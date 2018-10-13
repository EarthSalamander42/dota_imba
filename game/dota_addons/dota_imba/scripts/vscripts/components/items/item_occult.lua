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

item_imba_occult_mask = item_imba_occult_mask or class({})
LinkLuaModifier("modifier_imba_occult_mask", "components/items/item_occult", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_occult_mask_unique", "components/items/item_occult", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_occult_mask_drain_debuff", "components/items/item_occult", LUA_MODIFIER_MOTION_NONE)

function item_imba_occult_mask:GetIntrinsicModifierName()
	return "modifier_imba_occult_mask"
end



-- Stat modifier (stackable)
modifier_imba_occult_mask = modifier_imba_occult_mask or class({})

function modifier_imba_occult_mask:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_self = "modifier_imba_occult_mask"
	self.modifier_unique = "modifier_imba_occult_mask_unique"

	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_strength = self.ability:GetSpecialValueFor("bonus_strength")

	if IsServer() then
		-- If the caster doesn't already has the unique modifier, give it to him
		if not self.caster:HasModifier(self.modifier_unique) then
			self.caster:AddNewModifier(self.caster, self.ability, self.modifier_unique, {})
		end
	end
end

function modifier_imba_occult_mask:OnDestroy()
	if IsServer() then
		-- If the caster no longer has the stats buff, remove the unique
		if not self.caster:HasModifier(self.modifier_self) then
			self.caster:RemoveModifierByName(self.modifier_unique)
		end
	end
end

function modifier_imba_occult_mask:IsHidden() return true end
function modifier_imba_occult_mask:IsPurgable() return false end
function modifier_imba_occult_mask:IsDebuff() return false end
function modifier_imba_occult_mask:IsPermanent() return true end
function modifier_imba_occult_mask:RemoveOnDeath() return false end
function modifier_imba_occult_mask:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_occult_mask:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}

	return decFunc
end

function modifier_imba_occult_mask:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_occult_mask:GetModifierBonusStats_Strength()
	return self.bonus_strength
end


-- Unique modifier
modifier_imba_occult_mask_unique = modifier_imba_occult_mask_unique or class({})

function modifier_imba_occult_mask_unique:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	self.radius = self.ability:GetSpecialValueFor("radius")
	self.damage_per_second = self.ability:GetSpecialValueFor("damage_per_second")
	self.interval = self.ability:GetSpecialValueFor("interval")

	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end

function modifier_imba_occult_mask_unique:OnIntervalThink()
	if IsServer() then
		-- Find all nearby enemies
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
			self.caster:GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		for _,enemy in ipairs(enemies) do
			-- Ignore if the enemy has either Curseblade or Hellblade debuff on them
			local ignore_enemy
			if enemy:HasModifier("modifier_imba_souldrain_damage") or enemy:HasModifier("modifier_imba_helldrain_damage") then
				ignore_enemy = true
			end

			if not ignore_enemy then
				-- Deal damage to nearby enemies
				local damageTable = {victim = enemy,
					attacker = self.caster,
					damage = self.damage_per_second * self.interval,
					damage_type = DAMAGE_TYPE_MAGICAL,
					damage_flags = DOTA_DAMAGE_FLAG_HPLOSS,
					ability = self.ability}

				local actual_damage = ApplyDamage(damageTable)

				-- Heal actual damage done
				if actual_damage > 0 then
					self.caster:Heal(actual_damage, self.caster)
				end
			end
		end
	end
end

function modifier_imba_occult_mask_unique:IsHidden() return true end
function modifier_imba_occult_mask_unique:IsPurgable() return false end
function modifier_imba_occult_mask_unique:IsDebuff() return false end
function modifier_imba_occult_mask_unique:IsPermanent() return true end
function modifier_imba_occult_mask_unique:RemoveOnDeath() return false end
function modifier_imba_occult_mask_unique:IsAura() return true end
function modifier_imba_occult_mask_unique:GetAuraRadius() return self.radius end
function modifier_imba_occult_mask_unique:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_occult_mask_unique:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_occult_mask_unique:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_occult_mask_unique:GetModifierAura() return "modifier_imba_occult_mask_drain_debuff" end
function modifier_imba_occult_mask_unique:GetAuraEntityReject(target)
	-- If the target has Curseblade or Hellblade debuffs, ignore it
	if target:HasModifier("modifier_imba_souldrain_damage") or target:HasModifier("modifier_imba_helldrain_damage") then
		return true
	end

	return false
end


-- Debuff on enemies' HUD. Doesn't actually do anything
modifier_imba_occult_mask_drain_debuff = modifier_imba_occult_mask_drain_debuff or class({})

function modifier_imba_occult_mask_drain_debuff:IsHidden() return false end
function modifier_imba_occult_mask_drain_debuff:IsPurgable() return false end
function modifier_imba_occult_mask_drain_debuff:IsDebuff() return true end
function modifier_imba_occult_mask_drain_debuff:GetEffectName() return "particles/item/occult_mask/imba_occult_mask_spirits.vpcf" end
function modifier_imba_occult_mask_drain_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
