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
-- Date: 12.03.2017

-----------------------
--  MASK OF MADNESS  --
-----------------------

item_imba_mask_of_madness = class({})
LinkLuaModifier("modifier_imba_mask_of_madness", "components/items/item_mask_of_madness.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mask_of_madness_unique", "components/items/item_mask_of_madness.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mask_of_madness_berserk", "components/items/item_mask_of_madness.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mask_of_madness_rage", "components/items/item_mask_of_madness.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_mask_of_madness:GetAbilityTextureName()
	return "item_mask_of_madness"
end

function item_imba_mask_of_madness:GetIntrinsicModifierName()
	return "modifier_imba_mask_of_madness"
end

function item_imba_mask_of_madness:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_berserk = "modifier_imba_mask_of_madness_berserk"
	local sound_cast = "DOTA_Item.MaskOfMadness.Activate"

	-- Ability specials
	local berserk_duration = ability:GetSpecialValueFor("berserk_duration")

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Berserk!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	caster:AddNewModifier(caster, ability, modifier_berserk, {duration = berserk_duration})
end

-- Passive MoM modifier
modifier_imba_mask_of_madness = class({})

function modifier_imba_mask_of_madness:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	--self.modifier_rage = "modifier_imba_mask_of_madness_rage"

	-- Ability specials
	self.damage_bonus = self.ability:GetSpecialValueFor("damage_bonus")
	self.attack_speed_bonus = self.ability:GetSpecialValueFor("attack_speed_bonus")
	-- self.rage_damage_bonus = self.ability:GetSpecialValueFor("rage_damage_bonus")
	-- self.rage_lifesteal_bonus_pct = self.ability:GetSpecialValueFor("rage_lifesteal_bonus_pct")

	if IsServer() then
		if not self.caster:HasModifier("modifier_imba_mask_of_madness_unique") then
			self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_mask_of_madness_unique", {})
		end

		-- Change to lifesteal projectile, if there's nothing "stronger"
		ChangeAttackProjectileImba(self.caster)
	end
end

function modifier_imba_mask_of_madness:DeclareFunctions()
	local decFunc = {   MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT    }
	return decFunc
end

function modifier_imba_mask_of_madness:GetModifierPreAttack_BonusDamage()
	return self.damage_bonus

		-- Check for rage!!
		-- if self.caster:HasModifier(self.modifier_rage) then
		--     damage_bonus = damage_bonus + self.rage_damage_bonus
		-- end
end

function modifier_imba_mask_of_madness:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_bonus
end

function modifier_imba_mask_of_madness:OnDestroy()
	if IsServer() then
		-- If it is the last MoM in inventory, remove unique modiifer
		if self:IsNull() or not self.caster:HasModifier("modifier_imba_mask_of_madness") then
			self.caster:RemoveModifierByName("modifier_imba_mask_of_madness_unique")
		end

		-- Remove lifesteal projectile
		ChangeAttackProjectileImba(self.caster)
	end
end

function modifier_imba_mask_of_madness:IsHidden()
	return true
end

function modifier_imba_mask_of_madness:IsPurgable()
	return false
end

function modifier_imba_mask_of_madness:IsDebuff()
	return false
end

function modifier_imba_mask_of_madness:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end


modifier_imba_mask_of_madness_unique = class({})
function modifier_imba_mask_of_madness_unique:IsHidden() return true end
function modifier_imba_mask_of_madness_unique:IsPurgable() return false end
function modifier_imba_mask_of_madness_unique:IsDebuff() return false end

function modifier_imba_mask_of_madness_unique:OnCreated()
	-- Ability properties
	self.ability = self:GetAbility()

	-- Abilty specials
	self.lifesteal_pct = self.ability:GetSpecialValueFor("lifesteal_pct")
end

function modifier_imba_mask_of_madness_unique:OnRefresh()
	self:OnCreated()
end

function modifier_imba_mask_of_madness_unique:GetModifierLifesteal()
	return self.lifesteal_pct
end


-- Berserk modifier
modifier_imba_mask_of_madness_berserk = class({})

function modifier_imba_mask_of_madness_berserk:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	-- self.modifier_rage = "modifier_imba_mask_of_madness_rage"
	-- self.sound_rage = "Hero_Clinkz.Strafe"

	-- Ability specials
	self.berserk_attack_speed = self.ability:GetSpecialValueFor("berserk_attack_speed")
	self.berserk_ms_bonus_pct = self.ability:GetSpecialValueFor("berserk_ms_bonus_pct")
	self.berserk_armor_reduction = self.ability:GetSpecialValueFor("berserk_armor_reduction")
	-- self.rage_ms_bonus_pct = self.ability:GetSpecialValueFor("rage_ms_bonus_pct")
	-- self.rage_max_distance = self.ability:GetSpecialValueFor("rage_max_distance")

	-- if IsServer() then
	--     self:StartIntervalThink(0.2)
	-- end
end

function modifier_imba_mask_of_madness_berserk:OnIntervalThink()
	if IsServer() then
	-- -- If caster isn't raging, do nothing
	-- if not self.caster:HasModifier(self.modifier_rage) then
	--     return nil
	-- end

	-- -- Check if rage target is dead - if he is, remove rage modifier and go out
	-- if not self.rage_target or not self.rage_target:IsAlive() then
	--     self.caster:RemoveModifierByName(self.modifier_rage)
	--     return nil
	-- end

	-- -- If the target cannot be seen by the caster, remove rage modifier
	-- if not self.caster:CanEntityBeSeenByMyTeam(self.rage_target) then
	--     self.caster:RemoveModifierByName(self.modifier_rage)
	--     return nil
	-- end

	-- -- Check distance between the caster and his rage target
	-- local distance = (self.caster:GetAbsOrigin() - self.rage_target:GetAbsOrigin()):Length2D()

	-- -- If distance between them is too high, stop raging
	-- if distance >= self.rage_max_distance then
	--     self.caster:RemoveModifierByName(self.modifier_rage)
	-- end
	end
end

function modifier_imba_mask_of_madness_berserk:GetEffectName()
	return "particles/items2_fx/mask_of_madness.vpcf"
end

function modifier_imba_mask_of_madness_berserk:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_mask_of_madness_berserk:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFunc
end

function modifier_imba_mask_of_madness_berserk:GetModifierMoveSpeedBonus_Percentage()
	return self.berserk_ms_bonus_pct

		-- In a rage!! Get move speed bonus
		-- if self.caster:HasModifier(self.modifier_rage) then
		--     ms_bonus = ms_bonus + self.rage_ms_bonus_pct
		-- end
end

function modifier_imba_mask_of_madness_berserk:GetModifierAttackSpeedBonus_Constant()
	return self.berserk_attack_speed
end

function modifier_imba_mask_of_madness_berserk:GetModifierPhysicalArmorBonus()
	return self.berserk_armor_reduction * (-1)
end

function modifier_imba_mask_of_madness_berserk:CheckState()
	local state = {[MODIFIER_STATE_SILENCED] = true}
	return state
end

function modifier_imba_mask_of_madness_berserk:OnAttackLanded(keys)
-- RAGE IS DISBALED RIGHT NOW
-- if IsServer() then
--     local target = keys.target
--     local attacker = keys.attacker

--     -- Only apply on caster being the attacker, on other team, and when he doesn't have Rage
--     if self.caster == attacker and self.caster:GetTeamNumber() ~= target:GetTeamNumber() and not self.caster:HasModifier(self.modifier_rage) then

--         -- Also, only apply if the target is a hero
--         if target:IsHero() then
--             -- Mark target for rage distance checks
--             self.rage_target = target

--             -- Start a rage! (disables commands)
--             self.caster:AddNewModifier(self.caster, self.ability, self.modifier_rage, {})

--             -- Sound a rage!
--             EmitSoundOn(self.sound_rage, self.caster)

--             -- Force attacking the target
--             self.caster:MoveToTargetToAttack(target)
--         end
--     end
-- end
end

function modifier_imba_mask_of_madness_berserk:OnDestroy()
	if IsServer() then
	-- Remove rage
	-- if self.caster:HasModifier(self.modifier_rage) then
	--     self.caster:RemoveModifierByName(self.modifier_rage)
	-- end
	end
end

function modifier_imba_mask_of_madness_berserk:IsHidden()
	return false
end

function modifier_imba_mask_of_madness_berserk:IsPurgable()
	return false
end

function modifier_imba_mask_of_madness_berserk:IsDebuff()
	return false
end



-- Rage modifier
-- DISABLED FOR NOW - We'll make an armlet upgrade
-- modifier_imba_mask_of_madness_rage = class({})

-- function modifier_imba_mask_of_madness_rage:CheckState()
--     local state = {[MODIFIER_STATE_COMMAND_RESTRICTED] = true}
--     return state
-- end

-- function modifier_imba_mask_of_madness_rage:IsHidden()
--     return false
-- end

-- function modifier_imba_mask_of_madness_rage:IsPurgable()
--     return false
-- end

-- function modifier_imba_mask_of_madness_rage:IsDebuff()
--     return false
-- end

-- function modifier_imba_mask_of_madness_rage:GetEffectName()
--     return "particles/econ/items/drow/drow_head_mania/mask_of_madness_active_mania.vpcf"
-- end

-- function modifier_imba_mask_of_madness_rage:GetEffectAttachType()
--     return PATTACH_OVERHEAD_FOLLOW
-- end
