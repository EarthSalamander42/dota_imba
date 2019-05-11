-- Creator:
--	   AltiV, May 11th, 2019

-- This file currently only contains "Lua-fication" for Open Wounds (for cosmetic related interactions), and has no IMBAfications.

LinkLuaModifier("modifier_imba_life_stealer_open_wounds", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)

imba_life_stealer_open_wounds 			= class({})
modifier_imba_life_stealer_open_wounds 	= class({})

-----------------
-- OPEN WOUNDS --
-----------------

function imba_life_stealer_open_wounds:OnSpellStart()
	if not IsServer() then return end
	
	if self:GetCursorTarget():TriggerSpellAbsorb(self) then return nil end

	self:GetCaster():EmitSound("Hero_LifeStealer.OpenWounds.Cast")
	
	self:GetCursorTarget():EmitSound("Hero_LifeStealer.OpenWounds")
	
	if self:GetCaster():GetName() == "npc_dota_hero_life_stealer" and RollPercentage(75) then
		if not self.responses then
			self.responses = 
			{
				["life_stealer_lifest_ability_openwound_01"] = 0,
				["life_stealer_lifest_ability_openwound_02"] = 0,
				["life_stealer_lifest_ability_openwound_03"] = 0,
				["life_stealer_lifest_ability_openwound_04"] = 0,
				["life_stealer_lifest_ability_openwound_05"] = 0,
				["life_stealer_lifest_ability_openwound_06"] = 0
			}
		end
		
		for response, timer in pairs(self.responses) do
			if GameRules:GetDOTATime(true, true) - timer >= 60 then
				self:GetCaster():EmitSound(response)
				self.responses[response] = GameRules:GetDOTATime(true, true)
				break
			end
		end
	end	
	
	local impact_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_open_wounds_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCursorTarget())
	ParticleManager:ReleaseParticleIndex(impact_particle)
	
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_life_stealer_open_wounds", {duration = self:GetSpecialValueFor("duration")}):SetDuration(self:GetSpecialValueFor("duration") * (1 - self:GetCursorTarget():GetStatusResistance()), true)
end

--------------------------
-- OPEN WOUNDS MODIFIER --
--------------------------

function modifier_imba_life_stealer_open_wounds:GetEffectName()
	return "particles/units/heroes/hero_life_stealer/life_stealer_open_wounds.vpcf"
end

function modifier_imba_life_stealer_open_wounds:OnCreated()
	self.heal_percent	= self:GetAbility():GetTalentSpecialValueFor("heal_percent")
	
	if not IsServer() then return end
	
	self.slow_steps = {}

	for step = 0, self:GetAbility():GetSpecialValueFor("duration") - 1 do
		table.insert(self.slow_steps, self:GetAbility():GetLevelSpecialValueFor("slow_steps", step))
	end
	
	self:SetStackCount(self.slow_steps[math.floor(self:GetElapsedTime()) + 1])

	self:StartIntervalThink(0.1)
end

function modifier_imba_life_stealer_open_wounds:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount(self.slow_steps[math.floor(self:GetElapsedTime()) + 1] or 0)
end

function modifier_imba_life_stealer_open_wounds:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_LifeStealer.OpenWounds")
end

function modifier_imba_life_stealer_open_wounds:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }
	
	return decFuncs
end

function modifier_imba_life_stealer_open_wounds:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

function modifier_imba_life_stealer_open_wounds:OnTakeDamage(keys)
	if not IsServer() then return end

	if keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.attacker:IsBuilding() and not keys.attacker:IsOther() then
		local heal_amount = keys.damage * self.heal_percent * 0.01
	
		keys.attacker:Heal(heal_amount, self:GetAbility())
		
		local lifesteal_particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
		ParticleManager:ReleaseParticleIndex(lifesteal_particle)
		
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.attacker, heal_amount, nil)
	end
end
