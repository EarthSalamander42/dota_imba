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
-- Date: 04/08/2017

item_imba_heart = item_imba_heart or class({})
LinkLuaModifier("modifier_item_imba_heart", "components/items/item_heart", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_heart_unique", "components/items/item_heart", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_heart_aura_buff", "components/items/item_heart", LUA_MODIFIER_MOTION_NONE)

function item_imba_heart:GetIntrinsicModifierName()
	return "modifier_item_imba_heart"
end

function item_imba_heart:GetCooldown(level)
	if self:GetCaster():IsRangedAttacker() then
		return self:GetSpecialValueFor("regen_cooldown_ranged")
	else
		return self:GetSpecialValueFor("regen_cooldown_melee")
	end
end


-- Stats modifier (stackable)
modifier_item_imba_heart = modifier_item_imba_heart or class({})

function modifier_item_imba_heart:IsHidden() return true end
function modifier_item_imba_heart:IsPurgable() return false end
function modifier_item_imba_heart:IsDebuff() return false end
function modifier_item_imba_heart:RemoveOnDeath() return false end
function modifier_item_imba_heart:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_heart:OnCreated()
	-- Ability properties
	self.modifier_self = "modifier_item_imba_heart"
	self.modifier_unique = "modifier_item_imba_heart_unique"

	-- Ability specials
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")	

	if IsServer() then
		-- If this is the first heart, add the unique modifier
		if not self:GetCaster():HasModifier(self.modifier_unique) then
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), self.modifier_unique, {})
		end
	end
end

function modifier_item_imba_heart:OnDestroy()
	if IsServer() then
		-- if this is the last heart, remove the unique modifier
		if not self:GetCaster():HasModifier(self.modifier_self) then
			self:GetCaster():RemoveModifierByName(self.modifier_unique)
		end
	end
end

function modifier_item_imba_heart:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS}
	return decFuncs
end

function modifier_item_imba_heart:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_imba_heart:GetModifierHealthBonus()
	return self.bonus_health
end

-- Strength aura modifier, regenerations
modifier_item_imba_heart_unique = modifier_item_imba_heart_unique or class({})

function modifier_item_imba_heart_unique:IsHidden() return true end
function modifier_item_imba_heart_unique:IsPurgable() return false end
function modifier_item_imba_heart_unique:IsDebuff() return false end
function modifier_item_imba_heart_unique:RemoveOnDeath() return false end

function modifier_item_imba_heart_unique:OnCreated()
	-- Ability properties
	-- Ability specials	
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
	self.base_regen = self:GetAbility():GetSpecialValueFor("base_regen")
	self.noncombat_regen = self:GetAbility():GetSpecialValueFor("noncombat_regen")
end

function modifier_item_imba_heart_unique:IsAura() return true end
function modifier_item_imba_heart_unique:GetAuraRadius() return self.aura_radius end
function modifier_item_imba_heart_unique:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_imba_heart_unique:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_imba_heart_unique:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_item_imba_heart_unique:GetModifierAura() return "modifier_item_imba_heart_aura_buff" end

function modifier_item_imba_heart_unique:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE}

	return decFuncs
end

function modifier_item_imba_heart_unique:GetModifierHealthRegenPercentage()
	if IsClient() then return end

	if self:GetAbility():GetCooldownTimeRemaining() == 0 then
		return self.noncombat_regen
	end

	return self.base_regen
end

function modifier_item_imba_heart_unique:OnTakeDamage(keys)
	if IsServer() then
		local unit = keys.unit
		local attacker = keys.attacker

		-- Only apply if the unit taking damage is the caster
		if unit == self:GetCaster() then
			-- If the attacker wasn't an enemy hero or Roshan, do nothing
			if attacker:IsHero() or attacker:IsRoshan() then
				if attacker == unit then
					-- don't trigger cd with self damage
					return
				end

				local cooldown = self:GetAbility():GetSpecialValueFor("regen_cooldown_melee")
				if self:GetCaster():IsRangedAttacker() then
					cooldown = self:GetAbility():GetSpecialValueFor("regen_cooldown_ranged")
				end

				self:GetAbility():StartCooldown(cooldown)
			end
		end
	end
end

-- Aura buff
modifier_item_imba_heart_aura_buff = modifier_item_imba_heart_aura_buff or class({})

function modifier_item_imba_heart_aura_buff:OnCreated()
	-- Ability specials	
	self.aura_str = self:GetAbility():GetSpecialValueFor("aura_str")	
end

function modifier_item_imba_heart_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}

	return decFuncs
end

function modifier_item_imba_heart_aura_buff:GetModifierBonusStats_Strength()
	return self.aura_str
end
