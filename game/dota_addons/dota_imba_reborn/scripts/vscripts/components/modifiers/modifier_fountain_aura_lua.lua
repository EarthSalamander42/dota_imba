LinkLuaModifier("modifier_fountain_aura_effect_lua", "components/modifiers/modifier_fountain_aura_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_fountain_invulnerable", "components/modifiers/modifier_fountain_aura_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_cursed_fountain", "components/modifiers/modifier_fountain_aura_lua.lua", LUA_MODIFIER_MOTION_NONE)

modifier_fountain_aura_lua = class({})

function modifier_fountain_aura_lua:IsHidden() return true end
function modifier_fountain_aura_lua:IsAura() return true end

function modifier_fountain_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_fountain_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_COURIER
end

function modifier_fountain_aura_lua:GetModifierAura()
	return "modifier_fountain_aura_effect_lua"
end

function modifier_fountain_aura_lua:GetAuraDuration()
	return 3.0
end

function modifier_fountain_aura_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_fountain_aura_lua:GetAuraRadius()
	return 1200
end

modifier_fountain_aura_effect_lua = class({})

function modifier_fountain_aura_effect_lua:IsHidden()	return false end
function modifier_fountain_aura_effect_lua:IsPurgable() return false end

function modifier_fountain_aura_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		
		-- Testing fountain invuln camping prevention system
		MODIFIER_EVENT_ON_HERO_KILLED
	}

	return funcs
end

function modifier_fountain_aura_effect_lua:GetTexture()
	return "rune_regen"
end

function modifier_fountain_aura_effect_lua:OnCreated()
	if not IsServer() then return end

	if self:GetParent():GetClassname() == "npc_dota_additive" then
		self:Destroy()
		return
	end

	self:StartIntervalThink(0.1)

	Timers:CreateTimer(1.0, function()
		if self and not self:IsNull() and self.GetParent and self:GetParent() and not self:GetParent():IsNull() then
			self.pfx = ParticleManager:CreateParticle("particles/generic_gameplay/radiant_fountain_regen.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent())
		end
	end)
end

function modifier_fountain_aura_effect_lua:OnIntervalThink()
	if IsNearFountain(self:GetParent():GetAbsOrigin(), 1200) then
		-- self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_fountain_invulnerable", {})
	else
		self:GetParent():RemoveModifierByName("modifier_fountain_invulnerable")
	end

	if self:GetParent():HasItemInInventory("item_bottle") then
		local bottle = self:GetParent():FindItemByName("item_bottle", true, true)

		if bottle then
			if bottle:GetCurrentCharges() < bottle:GetSpecialValueFor("max_charges") then
				bottle:SetCurrentCharges(bottle:GetSpecialValueFor("max_charges"))
			end
		end
	end
end

function modifier_fountain_aura_effect_lua:GetModifierHealthRegenPercentage(params)
	return 5
end

function modifier_fountain_aura_effect_lua:GetModifierTotalPercentageManaRegen(params)
	return 6
end

function modifier_fountain_aura_effect_lua:OnHeroKilled(params)
	if not IsServer() then return end

	if params.attacker == self:GetParent() and IsNearFountain(self:GetParent():GetAbsOrigin(), 1800) then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_cursed_fountain", {})
	end
end

function modifier_fountain_aura_effect_lua:OnDestroy()
	if IsServer() then
		if self:GetParent():HasModifier("modifier_fountain_invulnerable") then
			self:GetParent():RemoveModifierByName("modifier_fountain_invulnerable")
		end

		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
	end
end

modifier_fountain_invulnerable = class({})

function modifier_fountain_invulnerable:IsPurgable() return false end
function modifier_fountain_invulnerable:GetTexture() return "tower_armor_aura" end

function modifier_fountain_invulnerable:GetStatusEffectName()
	return "particles/status_effect_gold_armor.vpcf"
end

function modifier_fountain_invulnerable:OnCreated()
	if not IsServer() then return end
	
	self:OnIntervalThink()
	self:StartIntervalThink(1)
end

function modifier_fountain_invulnerable:OnIntervalThink()
	if #FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false) > 0 then
		self.bEnemyProximity = true
	else
		self.bEnemyProximity = false
	end
end

function modifier_fountain_invulnerable:CheckState()
	if not IsServer() then return end

	return {[MODIFIER_STATE_INVULNERABLE] = self.bEnemyProximity}
end

function modifier_fountain_invulnerable:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
end

function modifier_fountain_invulnerable:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_fountain_invulnerable:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_fountain_invulnerable:GetAbsoluteNoDamagePure()
	return 1
end

------------------------------
-- CURSED FOUNTAIN MODIFIER --
------------------------------

modifier_imba_cursed_fountain = class({})

function modifier_imba_cursed_fountain:IsDebuff()	return true end
function modifier_imba_cursed_fountain:IsPurgable()	return false end
function modifier_imba_cursed_fountain:GetTexture()	return "custom/tower_rot" end

function modifier_imba_cursed_fountain:OnCreated()
	if not IsServer() then return end
	
	self.damage		= self:GetParent():GetAverageTrueAttackDamage(self:GetParent()) - ((self:GetParent():GetBaseDamageMax() + self:GetParent():GetBaseDamageMin()) / 2)
	self.spell_amp	= self:GetParent():GetSpellAmplification(false) - self:GetParent():GetSpellAmplification(true)
	
	if self:GetParent().GetStrength then
		self.strength	= self:GetParent():GetStrength()	- self:GetParent():GetBaseStrength()
		self.agility	= self:GetParent():GetAgility()		- self:GetParent():GetBaseAgility()
		self.intellect	= self:GetParent():GetIntellect()	- self:GetParent():GetBaseIntellect()
	else
		self.strength	= 0
		self.agility	= 0
		self.intellect	= 0
	end
	
	self.damage_outgoing	= -10
	
	self:SetStackCount(1)
	
	if self:GetParent():HasModifier("modifier_fountain_invulnerable") then
		self:GetParent():FindModifierByName("modifier_fountain_invulnerable"):Destroy()
	end
	
	self:StartIntervalThink(0.5)
end

function modifier_imba_cursed_fountain:OnRefresh()
	if not IsServer() then return end

	self:IncrementStackCount()
end

function modifier_imba_cursed_fountain:OnIntervalThink()
	if not IsServer() then return end

	-- Resetting variables to 0 first before recalculating (otherwise you'll end up with stacking negative values)
	self.damage		= 0
	self.spell_amp	= 0
	self.strength	= 0
	self.agility	= 0
	self.intellect	= 0
	
	self.damage		= self:GetParent():GetAverageTrueAttackDamage(self:GetParent()) - ((self:GetParent():GetBaseDamageMax() + self:GetParent():GetBaseDamageMin()) / 2)
	self.spell_amp	= self:GetParent():GetSpellAmplification(false) - self:GetParent():GetSpellAmplification(true)
	
	if self:GetParent().GetStrength then
		self.strength	= self:GetParent():GetStrength()	- self:GetParent():GetBaseStrength()
		self.agility	= self:GetParent():GetAgility()		- self:GetParent():GetBaseAgility()
		self.intellect	= self:GetParent():GetIntellect()	- self:GetParent():GetBaseIntellect()
		
		self:GetParent():CalculateStatBonus(true)
	else
		self.strength	= 0
		self.agility	= 0
		self.intellect	= 0
	end
end

function modifier_imba_cursed_fountain:CheckState()
	local state = {}
	
	if self:GetStackCount() >= 2 then
		state[MODIFIER_STATE_PROVIDES_VISION] = true
	end
	
	return state
end

function modifier_imba_cursed_fountain:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS, 
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,

		MODIFIER_EVENT_ON_HERO_KILLED
	}
	
	return decFuncs
end

function modifier_imba_cursed_fountain:GetModifierPreAttack_BonusDamage()
	if not IsServer() or self:GetStackCount() < 2 then return end
	
	return self.damage * (-1)
end

function modifier_imba_cursed_fountain:GetModifierSpellAmplify_Percentage()
	if not IsServer() or self:GetStackCount() < 2 then return end
	
	return self.spell_amp * (-1)
end

function modifier_imba_cursed_fountain:GetModifierBonusStats_Strength()
	if not IsServer() or self:GetStackCount() < 2 then return end
	
	return self.strength * (-1)
end

function modifier_imba_cursed_fountain:GetModifierBonusStats_Agility()
	if not IsServer() or self:GetStackCount() < 2 then return end
	
	return self.agility * (-1)
end

function modifier_imba_cursed_fountain:GetModifierBonusStats_Intellect()
	if not IsServer() or self:GetStackCount() < 2 then return end
	
	return self.intellect * (-1)
end

function modifier_imba_cursed_fountain:GetModifierTotalDamageOutgoing_Percentage()
	if not IsServer() or self:GetStackCount() < 2 then return end
	
	return self.damage_outgoing * self:GetStackCount()
end

function modifier_imba_cursed_fountain:OnHeroKilled(params)
	if not IsServer() then return end

	if params.attacker == self:GetParent() and not self:GetParent():HasModifier("modifier_fountain_aura_effect_lua") then
		self:Destroy()
	end
end
