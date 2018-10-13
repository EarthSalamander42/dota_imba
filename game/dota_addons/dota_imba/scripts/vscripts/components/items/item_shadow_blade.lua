-- Copyright (C) 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Editors:
--

--[[	Author: d2imba
		Date:	14.08.2015
		Updated by: Fudge
		Update Date: 23.07.2017
  ]]

---------------------------------
----         ACTIVE          ----
---------------------------------
item_imba_shadow_blade = item_imba_shadow_blade or class({})
LinkLuaModifier("modifier_item_imba_shadow_blade_passive", "components/items/item_shadow_blade.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_shadow_blade_invis", "components/items/item_shadow_blade.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_shadow_blade_invis_flying_disabled", "components/items/item_shadow_blade.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_shadow_blade_invis_turnrate_debuff", "components/items/item_shadow_blade.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_shadow_blade:OnSpellStart()
	-- Ability properties
	local caster    =   self:GetCaster()
	local particle_invis_start = "particles/generic_hero_status/status_invisibility_start.vpcf"
	-- Ability parameters
	local duration  =   self:GetSpecialValueFor("invis_duration")
	local fade_time =   self:GetSpecialValueFor("invis_fade_time")

	-- Play cast sound
	EmitSoundOn("DOTA_Item.InvisibilitySword.Activate", caster)

	-- Wait for the fade time to end, then emit the invisibility effect and apply the invis modifier
	Timers:CreateTimer(fade_time, function()

		local particle_invis_start_fx = ParticleManager:CreateParticle(particle_invis_start, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_invis_start_fx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_invis_start_fx)

		caster:AddNewModifier(caster, self, "modifier_item_imba_shadow_blade_invis", {duration = duration})
	end)
end

function item_imba_shadow_blade:GetIntrinsicModifierName()
	return "modifier_item_imba_shadow_blade_passive"
end

---------------------
--- INVIS MODIFIER
---------------------
modifier_item_imba_shadow_blade_invis = modifier_item_imba_shadow_blade_invis or class({})

-- Modifier properties
function modifier_item_imba_shadow_blade_invis:IsDebuff() return false end
function modifier_item_imba_shadow_blade_invis:IsHidden() return false end
function modifier_item_imba_shadow_blade_invis:IsPurgable() return false end

function modifier_item_imba_shadow_blade_invis:OnCreated()
	-- Start flying if has not taken damage recently
	if IsServer() then
		if not self:GetParent():FindModifierByName("modifier_item_imba_shadow_blade_invis_flying_disabled") then
			self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
		end
	end

	if self:GetAbility() == nil then return end
	if not self:GetParent():IsCreature() then
		self.bonus_movespeed = self:GetAbility():GetSpecialValueFor("invis_ms_pct")
		self.bonus_attack_damage = self:GetAbility():GetSpecialValueFor("invis_damage")
	end
end

-- Damage and movespeed bonuses
function modifier_item_imba_shadow_blade_invis:DeclareFunctions()
	local funcs =   {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		-- Breaking invis handler
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
	return funcs
end

function modifier_item_imba_shadow_blade_invis:GetModifierMoveSpeedBonus_Percentage() return self.bonus_movespeed end
function modifier_item_imba_shadow_blade_invis:GetModifierPreAttack_BonusDamagePostCrit(params)
	-- Does not deal bonus damage to wards/buildings
	if params.target:IsOther() or params.target:IsBuilding() then
		return 0
	else
		return self.bonus_attack_damage
	end
end


-- Phase invis and flying bonuses
function modifier_item_imba_shadow_blade_invis:CheckState()
	local state =   {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVISIBLE] = true,
	}
	return state
end

function modifier_item_imba_shadow_blade_invis:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_item_imba_shadow_blade_invis:GetModifierInvisibilityLevel()
	return 1
end

function modifier_item_imba_shadow_blade_invis:OnAttack(params)
	if IsServer() then
		if params.attacker == self:GetParent() then

			local ability          =   self:GetAbility()
			local debuff_duration  =   ability:GetSpecialValueFor("turnrate_slow_duration")

			-- Apply turnrate debuff modifier
			params.target:AddNewModifier(params.attacker, ability, "modifier_item_imba_shadow_blade_invis_turnrate_debuff", {duration = debuff_duration})

			-- Remove the invis on attack
			self:Destroy()
		end
	end
end

function modifier_item_imba_shadow_blade_invis:OnAbilityExecuted( keys )
	if IsServer() then
		local parent =	self:GetParent()
		-- Remove the invis on cast
		if keys.unit == parent then
			self:Destroy()
		end
	end
end

function modifier_item_imba_shadow_blade_invis:OnDestroy()
	if IsServer() then
		if not self:GetParent():FindModifierByName("modifier_shadow_blade_invis_flying_disabled") then
			-- Remove flying movement
			self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
			-- Destroy trees to not get stuck
			GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 175, false)
			-- Find a clear space to stand on
			ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 64)
		end
	end
end

----------------------------------
--- STACKABLE PASSIVE MODIFIER ---
----------------------------------
modifier_item_imba_shadow_blade_passive = modifier_item_imba_shadow_blade_passive or class({})

-- Modifier properties
function modifier_item_imba_shadow_blade_passive:IsDebuff() return false end
function modifier_item_imba_shadow_blade_passive:IsHidden() return true end
function modifier_item_imba_shadow_blade_passive:IsPurgable() return false end
function modifier_item_imba_shadow_blade_passive:IsPermanent() return true end
function modifier_item_imba_shadow_blade_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_shadow_blade_passive:OnCreated()
	local ability   =   self:GetAbility()

	-- Ability parameters
	if self:GetParent():IsHero() and ability then
		self.attack_damage_bonus    =   ability:GetSpecialValueFor("bonus_damage")
		self.attack_speed_bonus     =   ability:GetSpecialValueFor("bonus_attack_speed")
		self:CheckUnique(true)
	end
end

-- Attack speed and damage bonuses
function modifier_item_imba_shadow_blade_passive:DeclareFunctions()
	local funcs =   {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE            -- Flying disabler handler
	}
	return funcs
end

function modifier_item_imba_shadow_blade_passive:GetModifierPreAttack_BonusDamage() return self.attack_damage_bonus end
function modifier_item_imba_shadow_blade_passive:GetModifierAttackSpeedBonus_Constant() return self.attack_speed_bonus end

function modifier_item_imba_shadow_blade_passive:OnTakeDamage(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			local parent            =   self:GetParent()
			local disable_duration  =   self:GetAbility():GetSpecialValueFor("invis_flying_damage_disable_duration")

			if params.attacker:IsHeroDamage(params.damage) then
				-- Disable flying
				parent:AddNewModifier(parent, self, "modifier_item_imba_shadow_blade_invis_flying_disabled", {duration = disable_duration})
			end
		end
	end
end

--- Flying disabler handler
modifier_item_imba_shadow_blade_invis_flying_disabled = modifier_item_imba_shadow_blade_invis_flying_disabled or class({})

-- Modifier properties
function modifier_item_imba_shadow_blade_invis_flying_disabled:IsDebuff() return false end
function modifier_item_imba_shadow_blade_invis_flying_disabled:IsHidden() return true end
function modifier_item_imba_shadow_blade_invis_flying_disabled:IsPurgable() return false end

function modifier_item_imba_shadow_blade_invis_flying_disabled:OnCreated()
	if IsServer() then
		-- flying disabled
		self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)

		-- Destroy trees to not get stuck
		GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 175, false)
		-- Find a clear space to stand on
		ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 64)
	end
end

function modifier_item_imba_shadow_blade_invis_flying_disabled:OnDestroy()
	if IsServer() then
		-- flying enabled
		if self:GetParent():FindModifierByName("modifier_item_imba_shadow_blade_invis") then
			self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
		end
	end
end

--- TURNRATE SLOW MODIFIER
modifier_item_imba_shadow_blade_invis_turnrate_debuff = modifier_item_imba_shadow_blade_invis_turnrate_debuff or class({})

-- Modifier properties
function modifier_item_imba_shadow_blade_invis_turnrate_debuff:IsDebuff() return true end
function modifier_item_imba_shadow_blade_invis_turnrate_debuff:IsHidden() return false end
function modifier_item_imba_shadow_blade_invis_turnrate_debuff:IsPurgable() return true end

-- Turnrate slow
function modifier_item_imba_shadow_blade_invis_turnrate_debuff:OnCreated()
	local ability   =   self:GetAbility()

	self.turnrate   =   ability:GetSpecialValueFor("turnrate_slow")
end

function modifier_item_imba_shadow_blade_invis_turnrate_debuff:DeclareFunctions()
	local funcs =   {
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
	}
	return funcs
end

function modifier_item_imba_shadow_blade_invis_turnrate_debuff:GetModifierTurnRate_Percentage() return self.turnrate end

-- Particle
function modifier_item_imba_shadow_blade_invis_turnrate_debuff:GetEffectName()
	return "particles/item/shadow_blade/shadow_blade_panic_debuff.vpcf"
end

function modifier_item_imba_shadow_blade_invis_turnrate_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
