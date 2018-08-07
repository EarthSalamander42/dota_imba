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

item_imba_haste_boots = item_imba_haste_boots or class({})
LinkLuaModifier("modifier_imba_haste_boots", "components/items/item_haste_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_haste_boots_buff", "components/items/item_haste_boots", LUA_MODIFIER_MOTION_NONE)


function item_imba_haste_boots:GetIntrinsicModifierName()
	return "modifier_imba_haste_boots"
end

function item_imba_haste_boots:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_cast = "DOTA_Item.PhaseBoots.Activate"
	local modifier_boost = "modifier_imba_haste_boots_buff"

	-- Ability specials
	local phase_duration = ability:GetSpecialValueFor("phase_duration")

	-- Emit cast sound
	EmitSoundOn(sound_cast, caster)

	-- Add boost modifier
	caster:AddNewModifier(caster, ability, modifier_boost, {duration = phase_duration})
end


-- Stats modifier (stackable)
modifier_imba_haste_boots = modifier_imba_haste_boots or class({})

function modifier_imba_haste_boots:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	self.bonus_movement_speed = self.ability:GetSpecialValueFor("bonus_movement_speed")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_strength = self.ability:GetSpecialValueFor("bonus_strength")
end

function modifier_imba_haste_boots:IsHidden() return true end
function modifier_imba_haste_boots:IsPurgable() return false end
function modifier_imba_haste_boots:IsDebuff() return false end
function modifier_imba_haste_boots:IsPermanent() return true end
function modifier_imba_haste_boots:RemoveOnDeath() return false end
function modifier_imba_haste_boots:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_haste_boots:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE}

	return decFuncs
end

function modifier_imba_haste_boots:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_haste_boots:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_imba_haste_boots:GetModifierMoveSpeedBonus_Special_Boots()
	return self.bonus_movement_speed
end


-- Move speed bonus buff (active)
modifier_imba_haste_boots_buff = modifier_imba_haste_boots_buff or class({})

function modifier_imba_haste_boots_buff:IsHidden() return false end
function modifier_imba_haste_boots_buff:IsPurgable() return false end
function modifier_imba_haste_boots_buff:IsDebuff() return false end

function modifier_imba_haste_boots_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.particle_boost = "particles/item/boots/haste_boots_speed_boost.vpcf"
	self.particle_drain = "particles/item/boots/haste_boots_drain.vpcf"

	-- Ability specials
	self.phase_ms = self.ability:GetSpecialValueFor("phase_ms")
	self.ms_limit = self.ability:GetSpecialValueFor("ms_limit")
	self.drain_damage = self.ability:GetSpecialValueFor("drain_damage")
	self.drain_radius = self.ability:GetSpecialValueFor("drain_radius")

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

function modifier_imba_haste_boots_buff:OnIntervalThink()
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

function modifier_imba_haste_boots_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_MAX}

	return decFuncs
end

function modifier_imba_haste_boots_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.phase_ms
end

--function modifier_imba_haste_boots_buff:GetModifierMoveSpeed_Max()
--	return self.ms_limit
--end

function modifier_imba_haste_boots_buff:CheckState()
	local state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	return state
end
