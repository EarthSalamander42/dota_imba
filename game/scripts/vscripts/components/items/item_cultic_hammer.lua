-- Creator:
-- 	AltiV - December 27th, 2019

LinkLuaModifier("modifier_item_imba_cultic_hammer", "components/items/item_cultic_hammer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_cultic_hammer_aura", "components/items/item_cultic_hammer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_cultic_pull", "components/items/item_cultic_hammer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_cultic_status_resistance", "components/items/item_cultic_hammer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_cultic_root", "components/items/item_cultic_hammer", LUA_MODIFIER_MOTION_NONE)

item_imba_cultic_hammer							= item_imba_cultic_hammer or class({}) 
modifier_item_imba_cultic_hammer				= modifier_item_imba_cultic_hammer or class({})
modifier_item_imba_cultic_hammer_aura			= modifier_item_imba_cultic_hammer_aura or class({})
modifier_item_imba_cultic_pull					= modifier_item_imba_cultic_pull or class({})
modifier_item_imba_cultic_status_resistance		= modifier_item_imba_cultic_status_resistance or class({})
modifier_item_imba_cultic_root					= modifier_item_imba_cultic_root or class({})

-----------------------------
-- ITEM_IMBA_CULTIC_HAMMER --
-----------------------------

function item_imba_cultic_hammer:GetChannelAnimation()
	return ACT_DOTA_GENERIC_CHANNEL_1
end

function item_imba_cultic_hammer:GetIntrinsicModifierName()
	return "modifier_item_imba_cultic_hammer"
end

function item_imba_cultic_hammer:GetAOERadius()
	return self:GetSpecialValueFor("wretched_radius")
end

function item_imba_cultic_hammer:OnSpellStart()
	local caster = self:GetCaster()

	caster:EmitSound("Imba.Curseblade")

	self.aoe_particle_1 = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_ring.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(self.aoe_particle_1, 0, self:GetCursorPosition())
	ParticleManager:SetParticleControl(self.aoe_particle_1, 1, Vector(self:GetSpecialValueFor("wretched_radius"), 0, 0))
	
	self.aoe_particle_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg_dark_core.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(self.aoe_particle_2, 0, self:GetCursorPosition())
	ParticleManager:SetParticleControl(self.aoe_particle_2, 1, Vector(self:GetSpecialValueFor("wretched_radius") * 0.5, 0, 0))
	
	self.aoe_particle_3 = ParticleManager:CreateParticle("particles/item/cultic_hammer/cultic_hammer_channel_hammers.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(self.aoe_particle_3, 0, self:GetCursorPosition())
	ParticleManager:SetParticleControl(self.aoe_particle_3, 1, Vector(self:GetSpecialValueFor("wretched_radius"), 0, 0))
	
	caster:StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
	
	for _, enemy in pairs(FindUnitsInRadius(caster:GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("wretched_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		enemy:AddNewModifier(caster, self, "modifier_item_imba_cultic_pull", {
			duration	= self:GetChannelTime(),
			pos_x		= self:GetCursorPosition().x,
			pos_y		= self:GetCursorPosition().y,
			pos_z		= self:GetCursorPosition().z
		})
	end
end

function item_imba_cultic_hammer:OnChannelFinish(bInterrupted)
	local caster = self:GetCaster()
	
	caster:StopSound("Imba.Curseblade")

	ParticleManager:DestroyParticle(self.aoe_particle_1, true)
	ParticleManager:ReleaseParticleIndex(self.aoe_particle_1)
	
	ParticleManager:DestroyParticle(self.aoe_particle_2, true)
	ParticleManager:ReleaseParticleIndex(self.aoe_particle_2)
	
	ParticleManager:DestroyParticle(self.aoe_particle_3, true)
	ParticleManager:ReleaseParticleIndex(self.aoe_particle_3)
	
	caster:FadeGesture(ACT_DOTA_GENERIC_CHANNEL_1)
	
	for _, enemy in pairs(FindUnitsInRadius(caster:GetTeamNumber(), self:GetCursorPosition(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)) do
		if enemy:FindModifierByNameAndCaster("modifier_item_imba_cultic_pull", caster) then
			enemy:RemoveModifierByNameAndCaster("modifier_item_imba_cultic_pull", caster)
		end
	end
	
	if not bInterrupted then
		EmitSoundOnLocationWithCaster(self:GetCursorPosition(), "DOTA_Imba_Item.Cultic_Hammer.Slam", caster)
		
		self.aoe_particle_impact = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/planeshift/void_spirit_planeshift_impact.vpcf", PATTACH_POINT, caster)
		ParticleManager:SetParticleControl(self.aoe_particle_impact, 0, self:GetCursorPosition())
		ParticleManager:SetParticleControl(self.aoe_particle_impact, 1, Vector(self:GetSpecialValueFor("wretched_radius"), 0, 0))
		ParticleManager:ReleaseParticleIndex(self.aoe_particle_impact)

		self.aoe_particle_impact_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf", PATTACH_POINT, caster)
		ParticleManager:SetParticleControl(self.aoe_particle_impact_2, 0, self:GetCursorPosition())
		ParticleManager:SetParticleControl(self.aoe_particle_impact_2, 1, Vector(self:GetSpecialValueFor("wretched_radius") * 0.5, 0, 0))
		ParticleManager:ReleaseParticleIndex(self.aoe_particle_impact_2)
		
		local health_loss
		
		for _, enemy in pairs(FindUnitsInRadius(caster:GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("wretched_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			health_loss = enemy:GetHealth() * self:GetSpecialValueFor("wretched_hp_damage_pct") * 0.01
		
			enemy:SetHealth(math.max(enemy:GetHealth() - health_loss, 1))
			
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, enemy, health_loss, nil)
		
			ApplyDamage({
				victim 			= enemy,
				damage 			= self:GetSpecialValueFor("wretched_base_damage"),
				damage_type		= DAMAGE_TYPE_PURE,
				damage_flags 	= DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				attacker 		= caster,
				ability 		= self
			})
			
			enemy:AddNewModifier(caster, self, "modifier_item_imba_cultic_status_resistance", {duration = self:GetSpecialValueFor("wretched_status_duration")})
			
			enemy:AddNewModifier(caster, self, "modifier_item_imba_cultic_root", {duration = self:GetSpecialValueFor("wretched_root_duration") * (1 - enemy:GetStatusResistance())})
		end
		
		GridNav:DestroyTreesAroundPoint(self:GetCursorPosition(), self:GetSpecialValueFor("wretched_radius"), true)
	end
end

--------------------------------------
-- MODIFIER_ITEM_IMBA_CULTIC_HAMMER --
--------------------------------------

function modifier_item_imba_cultic_hammer:IsHidden()		return true end
function modifier_item_imba_cultic_hammer:IsPurgable()		return false end
function modifier_item_imba_cultic_hammer:RemoveOnDeath()	return false end
function modifier_item_imba_cultic_hammer:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_cultic_hammer:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if not self:GetAbility() then return end

	self.bonus_str		= self:GetAbility():GetSpecialValueFor("bonus_str")
	self.bonus_damage	= self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_imba_cultic_hammer:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_item_imba_cultic_hammer:GetModifierBonusStats_Strength()
	return self.bonus_str
end

function modifier_item_imba_cultic_hammer:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_imba_cultic_hammer:IsAura() 						return true end
function modifier_item_imba_cultic_hammer:IsAuraActiveOnDeath() 		return false end

function modifier_item_imba_cultic_hammer:GetAuraRadius()				return self:GetAbility():GetSpecialValueFor("soul_drain_radius") end
function modifier_item_imba_cultic_hammer:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_imba_cultic_hammer:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_imba_cultic_hammer:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_imba_cultic_hammer:GetModifierAura()				return "modifier_item_imba_cultic_hammer_aura" end

-------------------------------------------
-- MODIFIER_ITEM_IMBA_CULTIC_HAMMER_AURA --
-------------------------------------------

function modifier_item_imba_cultic_hammer_aura:GetEffectName()
	return "particles/item/curseblade/imba_curseblade_curse_rope_pnt.vpcf"
end

function modifier_item_imba_cultic_hammer_aura:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if not self:GetAbility() then return end

	self.soul_drain_health	= self:GetAbility():GetSpecialValueFor("soul_drain_health")
	self.soul_drain_mana	= self:GetAbility():GetSpecialValueFor("soul_drain_mana")
	
	self.soul_drain_health_illusions	= self.soul_drain_health * self:GetAbility():GetSpecialValueFor("soul_drain_illusion_efficiency") * 0.01
	self.soul_drain_mana_illusions		= self.soul_drain_mana * self:GetAbility():GetSpecialValueFor("soul_drain_illusion_efficiency") * 0.01
	
	if not IsServer() then return end
	
	self:StartIntervalThink(1)
end

function modifier_item_imba_cultic_hammer_aura:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	if parent:IsNull() or caster:IsNull() then
		return
	end

	if not caster:IsIllusion() then
		self.soul_drain_health_actual	=	self.soul_drain_health
		self.soul_drain_mana_actual		= 	self.soul_drain_mana
	else
		self.soul_drain_health_actual	=	self.soul_drain_health_illusions
		self.soul_drain_mana_actual		= 	self.soul_drain_mana_illusions
	end

	ApplyDamage({
		victim 			= parent,
		damage 			= self.soul_drain_health_actual,
		damage_type		= DAMAGE_TYPE_PURE,
		damage_flags 	= DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		attacker 		= caster,
		ability 		= ability
	})
	
	self.heal_particle = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(self.heal_particle)
	
	caster:Heal(self.soul_drain_health_actual, ability)

	if not parent:IsNull() and parent.GetMaxMana and parent:GetMaxMana() > 0 then
		if parent:IsAlive() then
			parent:ReduceMana(self.soul_drain_mana_actual, ability)
		end
		caster:GiveMana(self.soul_drain_mana_actual)
	end
end

------------------------------------
-- MODIFIER_ITEM_IMBA_CULTIC_PULL --
------------------------------------

function modifier_item_imba_cultic_pull:IsPurgable()		return false end
function modifier_item_imba_cultic_pull:IgnoreTenacity()	return true end

function modifier_item_imba_cultic_pull:GetEffectName()
	return "particles/item/curseblade/imba_curseblade_curse.vpcf"
end

function modifier_item_imba_cultic_pull:OnCreated(keys)
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.wretched_pull_speed	= self:GetAbility():GetSpecialValueFor("wretched_pull_speed")

	if not IsServer() then return end
	
	self.pos	= Vector(keys.pos_x, keys.pos_y, keys.pos_z)
	
	self:StartIntervalThink(FrameTime())
end

function modifier_item_imba_cultic_pull:OnRefresh(keys)
	self.pos	= Vector(keys.pos_x, keys.pos_y, keys.pos_z)
end

function modifier_item_imba_cultic_pull:OnIntervalThink()
	self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin() + (self.pos - self:GetParent():GetAbsOrigin()):Normalized() * FrameTime() * self.wretched_pull_speed)
end

function modifier_item_imba_cultic_pull:OnDestroy()
	if not IsServer() then return end
	
	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	
	self:GetParent():StopSound("Imba.Curseblade")
end

-------------------------------------------------
-- MODIFIER_ITEM_IMBA_CULTIC_STATUS_RESISTANCE --
-------------------------------------------------

function modifier_item_imba_cultic_status_resistance:IsPurgable()		return false end
function modifier_item_imba_cultic_status_resistance:IgnoreTenacity()	return true end

function modifier_item_imba_cultic_status_resistance:GetEffectName()
	return "particles/item/curseblade/imba_hellblade_curse.vpcf"
end

function modifier_item_imba_cultic_status_resistance:GetStatusEffectName()
	return "particles/status_fx/status_effect_abaddon_frostmourne.vpcf"
end

function modifier_item_imba_cultic_status_resistance:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.wretched_status_resistance	= self:GetAbility():GetSpecialValueFor("wretched_status_resistance") * (-1)
end

function modifier_item_imba_cultic_status_resistance:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_item_imba_cultic_status_resistance:GetModifierStatusResistanceStacking()
	return self.wretched_status_resistance
end

------------------------------------
-- MODIFIER_ITEM_IMBA_CULTIC_ROOT --
------------------------------------

function modifier_item_imba_cultic_root:GetEffectName()
	return "particles/items2_fx/rod_of_atos.vpcf"
end

function modifier_item_imba_cultic_root:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true
	}
end
