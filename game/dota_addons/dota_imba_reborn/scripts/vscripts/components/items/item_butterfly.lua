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
-- Date: 13/05/2017

item_imba_butterfly = class({})
LinkLuaModifier("modifier_item_imba_butterfly", "components/items/item_butterfly", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_butterfly_unique", "components/items/item_butterfly", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_butterfly_flutter", "components/items/item_butterfly", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_butterfly_wind_song_stacks", "components/items/item_butterfly", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_butterfly_wind_song_active", "components/items/item_butterfly", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_butterfly_wind_song_slow", "components/items/item_butterfly", LUA_MODIFIER_MOTION_NONE)

function item_imba_butterfly:GetIntrinsicModifierName()
	return "modifier_item_imba_butterfly"
end

function item_imba_butterfly:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_cast = "DOTA_Item.Butterfly"
	local modifier_flutter = "modifier_item_imba_butterfly_flutter"

	-- Ability specials
	local flutter_duration = ability:GetSpecialValueFor("flutter_duration")

	-- Emit Flutter sound
	EmitSoundOn(sound_cast, caster)

	-- Apply Flutter
	caster:AddNewModifier(caster, ability, modifier_flutter, {duration = flutter_duration})
end

-- Butterfly stacking modifier
modifier_item_imba_butterfly = class({})

function modifier_item_imba_butterfly:IsHidden() return true end
function modifier_item_imba_butterfly:IsPurgable() return false end
function modifier_item_imba_butterfly:IsDebuff() return false end
function modifier_item_imba_butterfly:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_butterfly:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_unique = "modifier_item_imba_butterfly_unique"
	self.modifier_flutter = "modifier_item_imba_butterfly_flutter"
	self.modifier_active_song = "modifier_item_imba_butterfly_wind_song_active"

	-- Ability specials
	self.bonus_agility = self.ability:GetSpecialValueFor("bonus_agility")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_evasion = self.ability:GetSpecialValueFor("bonus_evasion")
	self.wind_song_evasion = self.ability:GetSpecialValueFor("wind_song_evasion")
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")

	if IsServer() then
		-- Add unique modifier if caster doesn't already has it
		if not self.caster:HasModifier(self.modifier_unique) then
			self.caster:AddNewModifier(self.caster, self.ability, self.modifier_unique, {})
		end
	end
end

function modifier_item_imba_butterfly:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_item_imba_butterfly:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_imba_butterfly:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_imba_butterfly:GetModifierEvasion_Constant()
	-- If the caster has Wind Song active, his evasion is perfect
	if self.caster:HasModifier(self.modifier_active_song) then
		return self.wind_song_evasion
	end

	-- Otherwise, just return normal evasion
	return self.bonus_evasion
end

function modifier_item_imba_butterfly:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_imba_butterfly:OnDestroy()
	if IsServer() then
		-- Remove unique modifier if it is the last Butterfly in inventory
		if not self.caster:HasModifier("modifier_item_imba_butterfly") then
			self.caster:RemoveModifierByName("modifier_item_imba_butterfly_unique")
		end
	end
end


-- Unique modifier for granting stacks of Song of the Wind
modifier_item_imba_butterfly_unique = class({})

function modifier_item_imba_butterfly_unique:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_stacks = "modifier_item_imba_butterfly_wind_song_stacks"
	self.modifier_active_song = "modifier_item_imba_butterfly_wind_song_active"

	-- Ability specials
	self.wind_song_stack_duration = self.ability:GetSpecialValueFor("wind_song_stack_duration")
end

function modifier_item_imba_butterfly_unique:IsHidden() return true end
function modifier_item_imba_butterfly_unique:IsPurgable() return false end
function modifier_item_imba_butterfly_unique:IsDebuff() return false end

function modifier_item_imba_butterfly_unique:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_FAIL}

	return decFuncs
end

function modifier_item_imba_butterfly_unique:OnAttackFail(keys)
	local attacker = keys.attacker
	local target = keys.target

	-- Only apply if the evading unit is the caster
	if self.caster == target then -- and self.caster:GetTeamNumber() ~= attacker:GetTeamNumber() then

		-- Cannot generate stacks when Wind Song is active
		if self.caster:HasModifier(self.modifier_active_song) then
			return nil
	end

	-- If the caster don't have the stack modifier, give it to him
	if not self.caster:HasModifier(self.modifier_stacks) then
		self.caster:AddNewModifier(self.caster, self.ability, self.modifier_stacks, {duration = self.wind_song_stack_duration})
	end

	-- Either way, grant a stack and refresh the duration
	local modifier_active_song_handler = self.caster:FindModifierByName(self.modifier_stacks)
	if modifier_active_song_handler then
		modifier_active_song_handler:IncrementStackCount()
		modifier_active_song_handler:ForceRefresh()
	end
	end
end

function modifier_item_imba_butterfly_unique:OnDestroy()
	if IsServer() then
		-- If no more Butterflies are in the inventory, remove Wind Song stacks
		if self.caster:HasModifier(self.modifier_stacks) then
			self.caster:RemoveModifierByName(self.modifier_stacks)
		end
	end
end


-- Flutter modifier
modifier_item_imba_butterfly_flutter = class({})

function modifier_item_imba_butterfly_flutter:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.particle_flutter = "particles/items2_fx/butterfly_active.vpcf"

	-- Ability specials
	self.flutter_movespeed_pct = self.ability:GetSpecialValueFor("flutter_movespeed_pct")

	-- Apply Flutter effect on caster
	local particle_flutter_fx = ParticleManager:CreateParticle(self.particle_flutter, PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:SetParticleControl(particle_flutter_fx, 0, self.caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_flutter_fx, 1, self.caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_flutter_fx)
end

function modifier_item_imba_butterfly_flutter:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_item_imba_butterfly_flutter:GetModifierMoveSpeedBonus_Percentage()
	return self.flutter_movespeed_pct
end



-- Butterfly Wind Song stacks modifier
modifier_item_imba_butterfly_wind_song_stacks = class({})

function modifier_item_imba_butterfly_wind_song_stacks:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_active_song = "modifier_item_imba_butterfly_wind_song_active"

	-- Ability specials
	self.wind_song_active_stacks = self.ability:GetSpecialValueFor("wind_song_active_stacks")
	self.wind_song_duration = self.ability:GetSpecialValueFor("wind_song_duration")
end

function modifier_item_imba_butterfly_wind_song_stacks:IsHidden() return false end
function modifier_item_imba_butterfly_wind_song_stacks:IsPurgable() return true end
function modifier_item_imba_butterfly_wind_song_stacks:IsDebuff() return false end

function modifier_item_imba_butterfly_wind_song_stacks:OnStackCountChanged()
	if IsServer() then
		local stacks = self:GetStackCount()

		-- If there are enough stacks, trigger Wind Song
		if stacks >= self.wind_song_active_stacks then
			self.caster:AddNewModifier(self.caster, self.ability, self.modifier_active_song, {duration = self.wind_song_duration})

			-- Remove stacks counter
			self:Destroy()
		end
	end
end

-- Active Wind Song modifier
modifier_item_imba_butterfly_wind_song_active = class({})

function modifier_item_imba_butterfly_wind_song_active:GetEffectName()
	return "particles/items2_fx/yasha_active.vpcf"
end

function modifier_item_imba_butterfly_wind_song_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_imba_butterfly_wind_song_active:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_slow = "modifier_item_imba_butterfly_wind_song_slow"

	-- Ability specials
	self.wind_song_bonus_ms_pct = self.ability:GetSpecialValueFor("wind_song_bonus_ms_pct")
	self.wind_song_bonus_as = self.ability:GetSpecialValueFor("wind_song_bonus_as")
	self.wind_song_slow_radius = self.ability:GetSpecialValueFor("wind_song_slow_radius")

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_item_imba_butterfly_wind_song_active:IsHidden() return false end
function modifier_item_imba_butterfly_wind_song_active:IsPurgable() return true end
function modifier_item_imba_butterfly_wind_song_active:IsDebuff() return false end

function modifier_item_imba_butterfly_wind_song_active:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_item_imba_butterfly_wind_song_active:GetModifierMoveSpeedBonus_Percentage()
	return self.wind_song_bonus_ms_pct
end

function modifier_item_imba_butterfly_wind_song_active:GetModifierAttackSpeedBonus_Constant()
	return self.wind_song_bonus_as
end

function modifier_item_imba_butterfly_wind_song_active:OnIntervalThink()
	if IsServer() then
		-- Find nearby enemies not affected with the debuff and slow them for the remaining time
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
			self.caster:GetAbsOrigin(),
			nil,
			self.wind_song_slow_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		for _,enemy in pairs(enemies) do
			if not enemy:HasModifier(self.modifier_slow) then
				local remaining_time = self:GetRemainingTime()
				enemy:AddNewModifier(self.caster, self.ability, self.modifier_slow, {duration = remaining_time})
			end
		end
	end
end

modifier_item_imba_butterfly_wind_song_slow = class({})

function modifier_item_imba_butterfly_wind_song_slow:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_slow = "particles/units/heroes/hero_windrunner/windrunner_windrun_slow.vpcf"

	-- Ability specials
	self.wind_song_ms_slow_pct = self.ability:GetSpecialValueFor("wind_song_ms_slow_pct")

	-- Add slow particle
	local particle_slow_fx = ParticleManager:CreateParticle(self.particle_slow, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle_slow_fx, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_slow_fx, 1, Vector(1, 0, 0))
	self:AddParticle(particle_slow_fx, false, false, -1, false, false)
end

function modifier_item_imba_butterfly_wind_song_slow:IsHidden() return false end
function modifier_item_imba_butterfly_wind_song_slow:IsPurgable() return true end
function modifier_item_imba_butterfly_wind_song_slow:IsDebuff() return true end

function modifier_item_imba_butterfly_wind_song_slow:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_item_imba_butterfly_wind_song_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.wind_song_ms_slow_pct * (-1)
end
