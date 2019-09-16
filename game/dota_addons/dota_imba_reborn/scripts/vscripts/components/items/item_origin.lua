-- Creator:
-- 	AltiV - April 14th, 2019

LinkLuaModifier("modifier_item_imba_origin", "components/items/item_origin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_origin_health", "components/items/item_origin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_origin_power", "components/items/item_origin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_origin_chaos", "components/items/item_origin", LUA_MODIFIER_MOTION_NONE)

item_imba_origin					= class({})
modifier_item_imba_origin			= class({})
modifier_item_imba_origin_health	= class({})
modifier_item_imba_origin_power		= class({})
modifier_item_imba_origin_chaos		= class({})

-----------------
-- ORIGIN BASE --
-----------------

function item_imba_origin:GetIntrinsicModifierName()
	return "modifier_item_imba_origin"
end

-- This does nothing
-- function item_imba_origin:GetAbilityTargetTeam()
	-- return DOTA_UNIT_TARGET_TEAM_BOTH
-- end

function item_imba_origin:CastFilterResultTarget(target)
	if IsServer() then
		if target == self:GetCaster() then
			return UF_SUCCESS
		elseif (self:GetCaster():GetModifierStackCount("modifier_item_imba_origin", self:GetCaster()) == 1 or self:GetCaster():GetModifierStackCount("modifier_item_imba_origin", self:GetCaster()) == 3) and target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and target:IsMagicImmune() then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		return UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
	end
end

function item_imba_origin:GetAbilityTextureName()
	local origin_modifier_stack_count = self:GetCaster():GetModifierStackCount("modifier_item_imba_origin", self:GetCaster())
	
	if origin_modifier_stack_count then
		if origin_modifier_stack_count <= 1 then
			return "custom/origin_health"
		elseif origin_modifier_stack_count == 2 then
			return "custom/origin_power"
		elseif origin_modifier_stack_count == 3 then
			return "custom/origin_chaos"
		else -- This should never be called but just in case...
			return "custom/origin_health"
		end
	end
end

function item_imba_origin:OnSpellStart()
	local target	= self:GetCursorTarget()
	local active_duration	= self:GetSpecialValueFor("active_duration")

	if target == self:GetCaster() then
		-- Self cast is only just to change the Origin state so give back the mana and cooldown
		self:RefundManaCost()
		self:EndCooldown()
		
		local origin_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_item_imba_origin", self:GetCaster())
		
		if origin_modifier then
			if origin_modifier:GetStackCount() == 3 then
				origin_modifier:SetStackCount(1)
			else
				origin_modifier:IncrementStackCount()
			end
		end
		
		target:CalculateStatBonus()
	else
		-- Do not bypass linken's Sphere
		if target:TriggerSpellAbsorb(self) then
			return
		end
	
		local origin_modifier_stack_count = self:GetCaster():GetModifierStackCount("modifier_item_imba_origin", self:GetCaster())
		local active_modifier
		
		-- Emit sound
		target:EmitSound("Origin.Cast")
		
		-- Emit particles
		local particle = ParticleManager:CreateParticle("particles/item/origin/origin_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 2, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
		
		if origin_modifier_stack_count then
			if origin_modifier_stack_count <= 1 then
				active_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_origin_health", {duration = active_duration})
			elseif origin_modifier_stack_count == 2 then
				active_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_origin_power", {duration = active_duration})
			elseif origin_modifier_stack_count == 3 then
				active_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_origin_chaos", {duration = active_duration})
			else -- This should never be called but just in case...
				active_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_origin_health", {duration = active_duration})
			end
			
			if active_modifier then
				active_modifier:SetDuration(active_duration * (1 - target:GetStatusResistance()), true)
			end
		end
	end
	
	-- This is in attempts to reserve the Origin item state if dropped and picked back up
	self.type = self:GetCaster():GetModifierStackCount("modifier_item_imba_origin", self:GetCaster())
end

-----------------------------------
-- ORIGIN HEALTH ACTIVE MODIFIER --
-----------------------------------

function modifier_item_imba_origin_health:IsPurgable()	return false end

function modifier_item_imba_origin_health:GetEffectName()
	return "particles/items4_fx/spirit_vessel_damage.vpcf"
end

function modifier_item_imba_origin_health:GetTexture()
	return "custom/origin_health"
end

function modifier_item_imba_origin_health:OnCreated(params)
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.active_duration			= self.ability:GetSpecialValueFor("active_duration")
	self.health_damage_amount		= self.ability:GetSpecialValueFor("health_damage_amount")	-- flat damage
	self.enemy_hp_drain				= self.ability:GetSpecialValueFor("enemy_hp_drain")			-- % of current HP
	
	if not IsServer() then return end
	
	self:StartIntervalThink(1 * (1 - self:GetParent():GetStatusResistance()))
end

-- This is mostly just to recalculate who the caster is for damage ownership
function modifier_item_imba_origin_health:OnRefresh()
	self:OnCreated()
end

function modifier_item_imba_origin_health:OnIntervalThink()
	if not IsServer() then return end
	
	-- Applies flat damage and damage based on current HP in one instance
	local damageTableHP = {
		victim 			= self.parent,
		damage 			= self.health_damage_amount + (self.parent:GetHealth() * (self.enemy_hp_drain / 100)),
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self.caster,
		ability 		= self.ability
	}
	
	ApplyDamage(damageTableHP)
end

function modifier_item_imba_origin_health:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2
    }

    return decFuncs
end

function modifier_item_imba_origin_health:GetDisableHealing()
	return 1
end

function modifier_item_imba_origin_health:OnTooltip()
	return self.health_damage_amount
end

function modifier_item_imba_origin_health:OnTooltip2()
	return self.enemy_hp_drain
end

----------------------------------
-- ORIGIN POWER ACTIVE MODIFIER --
----------------------------------

function modifier_item_imba_origin_power:IsPurgable()	return false end

function modifier_item_imba_origin_power:GetEffectName()
	return "particles/items4_fx/nullifier_slow.vpcf"
end

function modifier_item_imba_origin_power:GetTexture()
	return "custom/origin_power"
end

function modifier_item_imba_origin_power:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.power_stat_reduction			= self.ability:GetSpecialValueFor("power_stat_reduction")
	
	if not IsServer() then return end
	
	if self.parent.GetPrimaryStatValue then
		self:SetStackCount(math.max(self.parent:GetPrimaryStatValue() * self.power_stat_reduction * 0.01, 0))
	end
end

function modifier_item_imba_origin_power:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }

    return decFuncs
end

function modifier_item_imba_origin_power:GetModifierBonusStats_Strength()
	return self:GetStackCount() * (-1)
end

function modifier_item_imba_origin_power:GetModifierBonusStats_Agility()
	return self:GetStackCount() * (-1)
end

function modifier_item_imba_origin_power:GetModifierBonusStats_Intellect()
	return self:GetStackCount() * (-1)
end

----------------------------------
-- ORIGIN CHAOS ACTIVE MODIFIER --
----------------------------------

function modifier_item_imba_origin_chaos:GetEffectName()
	return "particles/econ/items/silencer/silencer_ti6/silencer_last_word_status_ti6.vpcf"
end

function modifier_item_imba_origin_chaos:GetStatusEffectName()
	return "particles/status_fx/status_effect_blademail.vpcf"
end

function modifier_item_imba_origin_chaos:GetTexture()
	return "custom/origin_chaos"
end

function modifier_item_imba_origin_chaos:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.chaos_radius			= self.ability:GetSpecialValueFor("chaos_radius")
	self.chaos_dmg_pct			= self.ability:GetSpecialValueFor("chaos_dmg_pct")
end

function modifier_item_imba_origin_chaos:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2
    }

    return decFuncs
end

function modifier_item_imba_origin_chaos:OnTakeDamage(keys)
	-- No infinite loops plz
	if keys.unit == self.parent and bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION then
	
		local particle = ParticleManager:CreateParticle("particles/item/origin/origin_chaos_splash.vpcf", PATTACH_ABSORIGIN, self.parent)
		ParticleManager:ReleaseParticleIndex(particle)
	
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.chaos_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		
		for _, enemy in pairs(enemies) do
			if enemy ~= self.parent then
		
				local damageTable = {
					victim 			= enemy,
					damage 			= keys.original_damage * (self.chaos_dmg_pct * 0.01),
					damage_type		= keys.damage_type,
					damage_flags 	= DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
					attacker 		= self.caster,
					ability 		= self.ability
				}
										
				ApplyDamage(damageTable)
			end
		end
	end
end

function modifier_item_imba_origin_chaos:OnTooltip()
	return self.chaos_radius
end

function modifier_item_imba_origin_chaos:OnTooltip2()
	return self.chaos_dmg_pct
end

---------------------
-- ORIGIN MODIFIER --
---------------------

function modifier_item_imba_origin:IsHidden()		return true end
function modifier_item_imba_origin:IsPermanent()		return true end
function modifier_item_imba_origin:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_origin:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.bonus_strength			=	self.ability:GetSpecialValueFor("bonus_strength")
	self.bonus_agility			=	self.ability:GetSpecialValueFor("bonus_agility")
	self.bonus_intellect		=	self.ability:GetSpecialValueFor("bonus_intellect")
	
	self.bonus_damage			=	self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_aspd				=	self.ability:GetSpecialValueFor("bonus_aspd")
	self.bonus_armor			=	self.ability:GetSpecialValueFor("bonus_armor")
	
	self.bonus_health			=	self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_mana				= 	self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_mana_regen		=	self.ability:GetSpecialValueFor("bonus_mana_regen")
	
	self.health_passive			=	self.ability:GetSpecialValueFor("health_passive")
	self.power_passive			=	self.ability:GetSpecialValueFor("power_passive")
	self.chaos_passive			=	self.ability:GetSpecialValueFor("chaos_passive")
	
	if not IsServer() then return end
	
	-- Get back state of which item was dropped
	if self.ability.type then
		self:SetStackCount(self.ability.type)
	else
		self:SetStackCount(1)
	end
end

function modifier_item_imba_origin:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,  --GetModifierPreAttack_BonusDamage
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, --GetModifierAttackSpeedBonus_Constant
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, --GetModifierPhysicalArmorBonus
		
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		
		-- The special ability passive
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,	-- Health (1)
														-- Power is dealt in the str/agi/int functions (2)
		MODIFIER_EVENT_ON_TAKEDAMAGE					-- Chaos (3)			
    }
	
    return decFuncs
end

function modifier_item_imba_origin:GetModifierBonusStats_Strength()
	if self:GetStackCount() == 2 then
		return self.bonus_strength + self.power_passive
	else
		return self.bonus_strength
	end
end

function modifier_item_imba_origin:GetModifierBonusStats_Agility()
	if self:GetStackCount() == 2 then
		return self.bonus_agility + self.power_passive
	else
		return self.bonus_agility
	end
end

function modifier_item_imba_origin:GetModifierBonusStats_Intellect()
	if self:GetStackCount() == 2 then
		return self.bonus_intellect + self.power_passive
	else
		return self.bonus_intellect
	end
end



function modifier_item_imba_origin:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_imba_origin:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_aspd
end

function modifier_item_imba_origin:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end



function modifier_item_imba_origin:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_imba_origin:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_imba_origin:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end



function modifier_item_imba_origin:GetModifierHPRegenAmplify_Percentage()
	if self:GetStackCount() == 1 then
		return self.health_passive
	end
end

function modifier_item_imba_origin:OnTakeDamage(keys)
	if self:GetStackCount() == 3 and keys.unit == self.parent and keys.unit ~= keys.attacker and bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION then
	
		local damageTable = {
			victim 			= keys.attacker,
			damage 			= keys.original_damage * (self.chaos_passive * 0.01),
			damage_type		= keys.damage_type,
			damage_flags 	= DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
			attacker 		= self.caster,
			ability 		= self.ability
		}
								
		ApplyDamage(damageTable)
	end
end
