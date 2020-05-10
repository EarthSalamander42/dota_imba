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

-- Author: Shush
-- Date: 16/07/2017

-- Editor: AltiV
-- Date: 03/10/2018

item_imba_lifesteal_boots = item_imba_lifesteal_boots or class({})
LinkLuaModifier("modifier_imba_lifesteal_boots", "components/items/item_lifesteal_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_lifesteal_boots_buff", "components/items/item_lifesteal_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_lifesteal_boots_unslowable", "components/items/item_lifesteal_boots", LUA_MODIFIER_MOTION_NONE)

function item_imba_lifesteal_boots:GetIntrinsicModifierName()
	return "modifier_imba_lifesteal_boots"
end

function item_imba_lifesteal_boots:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_cast = "DOTA_Item.PhaseBoots.Activate"
	local modifier_boost = "modifier_imba_lifesteal_boots_buff"

	-- Ability specials
	local phase_duration = ability:GetSpecialValueFor("phase_duration")

	-- Emit cast sound
	EmitSoundOn(sound_cast, caster)

	-- Add boost modifier
	caster:AddNewModifier(caster, self, modifier_boost, {duration = phase_duration})
	caster:AddNewModifier(caster, self, "modifier_imba_lifesteal_boots_unslowable", {duration = phase_duration})
end


-- Stats modifier (stackable)
modifier_imba_lifesteal_boots = modifier_imba_lifesteal_boots or class({})

function modifier_imba_lifesteal_boots:GetTexture()
	return "custom/imba_lifesteal_boots"
end

function modifier_imba_lifesteal_boots:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	if IsServer() then
		-- Change to lifesteal projectile, if there's nothing "stronger"
		ChangeAttackProjectileImba(self:GetCaster())
	end
end

-- Removes the unique modifier from the caster if this is the last Satanic in its inventory
function modifier_imba_lifesteal_boots:OnDestroy()
	if IsServer() then
		-- Remove lifesteal projectile
		ChangeAttackProjectileImba(self:GetCaster())
	end
end

function modifier_imba_lifesteal_boots:IsHidden()		return true end
function modifier_imba_lifesteal_boots:IsPurgable()		return false end
function modifier_imba_lifesteal_boots:RemoveOnDeath()	return false end
function modifier_imba_lifesteal_boots:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_lifesteal_boots:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_imba_lifesteal_boots:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

function modifier_imba_lifesteal_boots:GetModifierMoveSpeedBonus_Special_Boots()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
	end
end

function modifier_imba_lifesteal_boots:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("armor")
	end
end

function modifier_imba_lifesteal_boots:GetModifierLifesteal()
	if self:GetAbility() and self:GetParent():FindAllModifiersByName(self:GetName())[1] == self then
		return self:GetAbility():GetSpecialValueFor("lifesteal_pct")
	end
end

-- Move speed bonus buff (active)
modifier_imba_lifesteal_boots_buff = modifier_imba_lifesteal_boots_buff or class({})

function modifier_imba_lifesteal_boots_buff:IsHidden() return false end
function modifier_imba_lifesteal_boots_buff:IsPurgable() return false end
function modifier_imba_lifesteal_boots_buff:IsDebuff() return false end

function modifier_imba_lifesteal_boots_buff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.particle_boost = "particles/item/boots/lifesteal_boots_speed_boost.vpcf"
	self.particle_drain = "particles/item/boots/lifesteal_boots_drain.vpcf"

	-- Ability specials
	self.phase_ms = self.ability:GetSpecialValueFor("phase_ms")
	self.ms_limit = self.ability:GetSpecialValueFor("ms_limit")
	self.drain_damage = self.ability:GetSpecialValueFor("drain_damage")
	self.drain_radius = self.ability:GetSpecialValueFor("drain_radius")
	-- self.ideal_speed = math.min(self:GetParent():GetIdealSpeedNoSlows(), self.ms_limit)

	if IsServer() then
		-- Apply particle effects
		local particle_boost_fx = ParticleManager:CreateParticle(self.particle_boost, PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(particle_boost_fx, 0, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_boost_fx, 1, self.caster:GetAbsOrigin())
		self:AddParticle(particle_boost_fx, false, false, -1, false, false)

		-- Set table for drained units
		self.drained_units = {}

		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_lifesteal_boots_buff:OnIntervalThink()
	if IsServer() then
		-- Look for nearby enemies in drain radius
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
			self.caster:GetAbsOrigin(),
			nil,
			self.drain_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		-- Damage enemies and suck health
		for _,enemy in ipairs(enemies) do
			-- If the enemy was already drained, do nothing
			if not self.drained_units[enemy:entindex()] then

				local damageTable = {victim = enemy,
					damage = self.drain_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					attacker = self.caster,
					ability = self.ability
				}

				local actual_damage = ApplyDamage(damageTable)

				-- Add drain particle
				local particle_drain_fx = ParticleManager:CreateParticle(self.particle_drain, PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:SetParticleControl(particle_drain_fx, 0, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_drain_fx, 1, enemy:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle_drain_fx)

				-- Heal caster for damage dealt
				if actual_damage > 0 then
					self.caster:Heal(actual_damage, self.caster)
				end

				-- Add enemy to the table
				self.drained_units[enemy:entindex()] = enemy:entindex()
			end
		end
	end
end

function modifier_imba_lifesteal_boots_buff:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end

function modifier_imba_lifesteal_boots_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT
	}
end

function modifier_imba_lifesteal_boots_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.phase_ms
end

function modifier_imba_lifesteal_boots_buff:GetModifierIgnoreMovespeedLimit()
	return 1
end

-- https://dota2.gamepedia.com/Movement_speed
function modifier_imba_lifesteal_boots_buff:GetModifierMoveSpeed_Limit()
	if not self:GetParent():HasModifier("modifier_imba_thirst_passive") and
	not (self:GetParent():HasModifier("modifier_brewmaster_primal_split_duration") and self:GetParent():HasScepter()) and 
	not (self:GetParent():HasModifier("modifier_broodmother_spin_web") and self:GetParent():HasScepter()) and 
	not (self:GetParent():HasModifier("modifier_clinkz_wind_walk") and self:GetParent():HasScepter()) and 
	not (self:GetParent():HasModifier("modifier_imba_skeleton_walk_invis") and self:GetParent():HasScepter()) and 
	not (self:GetParent():HasModifier("modifier_imba_clinkz_wind_walk_723") and self:GetParent():HasScepter()) and 
	not self:GetParent():HasModifier("modifier_dark_seer_surge") and
	not self:GetParent():HasModifier("modifier_imba_dark_seer_surge") and
	not self:GetParent():HasModifier("modifier_wisp_tether_haste") and
	not self:GetParent():HasModifier("modifier_imba_wisp_tether") and
	not self:GetParent():HasModifier("modifier_slardar_sprint_river") and
	not self:GetParent():HasModifier("modifier_imba_guardian_sprint_river") and
	not self:GetParent():HasModifier("modifier_spirit_breaker_charge_of_darkness") and
	not self:GetParent():HasModifier("modifier_imba_spirit_breaker_charge_of_darkness") and
	not (self:GetParent():HasModifier("modifier_windrunner_windrun") and self:GetParent():HasScepter()) and
	not (self:GetParent():HasModifier("modifier_imba_windranger_windrun") and self:GetParent():HasScepter()) and
	not (self:GetParent():HasModifier("modifier_imba_hunter_in_the_night") and not self:GetParent():PassivesDisabled() and IsDaytime and not IsDaytime()) then
		return self.ms_limit
	end
end

----------------------------------------------
-- MODIFIER_IMBA_LIFESTEAL_BOOTS_UNSLOWABLE --
----------------------------------------------

modifier_imba_lifesteal_boots_unslowable	= modifier_imba_lifesteal_boots_unslowable or class({})

function modifier_imba_lifesteal_boots_unslowable:IsHidden()	return true end

function modifier_imba_lifesteal_boots_unslowable:CheckState()
	return {
		[MODIFIER_STATE_UNSLOWABLE] = true
	}
end
