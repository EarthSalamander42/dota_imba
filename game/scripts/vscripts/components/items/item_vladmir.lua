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

--	Author: Firetoad
--	Date: 			03.08.2015
--	Last Update:	05.03.2020 (AltiV)

-----------------------------------------------------------------------------------------------------------
--	Vladmir's Offering definition
-----------------------------------------------------------------------------------------------------------

if item_imba_vladmir == nil then item_imba_vladmir = class({}) end
LinkLuaModifier("modifier_item_imba_vladmir", "components/items/item_vladmir.lua", LUA_MODIFIER_MOTION_NONE)        -- Owner's bonus attributes, stackable
LinkLuaModifier("modifier_item_imba_vladmir_aura", "components/items/item_vladmir.lua", LUA_MODIFIER_MOTION_NONE)   -- Aura buff

function item_imba_vladmir:GetAbilityTextureName()
	return "imba_vladmir"
end

function item_imba_vladmir:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_PASSIVE + DOTA_ABILITY_BEHAVIOR_AURA
end

function item_imba_vladmir:GetCastRange()
	return self:GetSpecialValueFor("aura_radius") - self:GetCaster():GetCastRangeBonus()
end

function item_imba_vladmir:GetIntrinsicModifierName()
	return "modifier_item_imba_vladmir"
end

-----------------------------------------------------------------------------------------------------------
--	Vladmir's offering owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_vladmir == nil then modifier_item_imba_vladmir = class({}) end

function modifier_item_imba_vladmir:IsHidden() return true end

function modifier_item_imba_vladmir:IsPurgable() return false end

function modifier_item_imba_vladmir:RemoveOnDeath() return false end

function modifier_item_imba_vladmir:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

--[[
-- Attribute bonuses
function modifier_item_imba_vladmir:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
end

function modifier_item_imba_vladmir:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("stat_bonus")
	end
end

function modifier_item_imba_vladmir:GetModifierBonusStats_Agility()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("stat_bonus")
	end
end

function modifier_item_imba_vladmir:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("stat_bonus")
	end
end
--]]
function modifier_item_imba_vladmir:IsAura() return true end

function modifier_item_imba_vladmir:IsAuraActiveOnDeath() return false end

function modifier_item_imba_vladmir:GetAuraRadius() if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("aura_radius") end end

function modifier_item_imba_vladmir:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_item_imba_vladmir:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_item_imba_vladmir:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_item_imba_vladmir:GetModifierAura() return "modifier_item_imba_vladmir_aura" end

function modifier_item_imba_vladmir:GetAuraEntityReject(hTarget) return hTarget:HasModifier("modifier_item_imba_vladmir_blood_aura") end

-----------------------------------------------------------------------------------------------------------
--	Vladmir's Offering aura
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_vladmir_aura == nil then modifier_item_imba_vladmir_aura = class({}) end
function modifier_item_imba_vladmir_aura:IsDebuff() return false end

function modifier_item_imba_vladmir_aura:IsPurgable() return false end

-- Aura icon
function modifier_item_imba_vladmir_aura:GetTexture()
	return "imba_vladmir"
end

-- Stores the aura's parameters to prevent errors when the item is unequipped
function modifier_item_imba_vladmir_aura:OnCreated(keys)
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.damage_aura     = self:GetAbility():GetSpecialValueFor("damage_aura")
	self.armor_aura      = self:GetAbility():GetSpecialValueFor("armor_aura")
	self.hp_regen_aura   = self:GetAbility():GetSpecialValueFor("hp_regen_aura")
	self.mana_regen_aura = self:GetAbility():GetSpecialValueFor("mana_regen_aura")
	self.vampiric_aura   = self:GetAbility():GetSpecialValueFor("vampiric_aura")

	if IsServer() and self:GetParent():IsHero() then
		ChangeAttackProjectileImba(self:GetParent())
	end
end

-- Possible projectile change
function modifier_item_imba_vladmir_aura:OnDestroy()
	if IsServer() and self:GetParent():IsHero() then
		ChangeAttackProjectileImba(self:GetParent())
	end
end

-- Lifesteal
function modifier_item_imba_vladmir_aura:GetModifierLifesteal()
	return self:GetAbility():GetSpecialValueFor("vampiric_aura")
end

-- Bonuses (does not stack with Vladmir's Blood)
function modifier_item_imba_vladmir_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,

		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_item_imba_vladmir_aura:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetParent():HasModifier("modifier_item_imba_vladmir_blood_aura") then
		return 0
	else
		if self.damage_aura then
			return self.damage_aura
		end
	end
end

function modifier_item_imba_vladmir_aura:GetModifierPhysicalArmorBonusUnique()
	return self.armor_aura
end

function modifier_item_imba_vladmir_aura:GetModifierConstantHealthRegen()
	if self:GetParent():HasModifier("modifier_item_imba_vladmir_blood_aura") then
		return 0
	else
		if self.hp_regen_aura then
			return self.hp_regen_aura
		end
	end
end

function modifier_item_imba_vladmir_aura:GetModifierConstantManaRegen()
	if self:GetParent():HasModifier("modifier_item_imba_vladmir_blood_aura") then
		return 0
	else
		if self.mana_regen_aura then
			return self.mana_regen_aura
		end
	end
end

--- Enum DamageCategory_t
-- DOTA_DAMAGE_CATEGORY_ATTACK = 1
-- DOTA_DAMAGE_CATEGORY_SPELL = 0
function modifier_item_imba_vladmir_aura:OnTakeDamage(keys)
	if not keys.attacker:HasModifier("modifier_item_imba_vladmir_blood_aura") and not keys.attacker:HasModifier("modifier_custom_mechanics") and keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		-- Spell lifesteal handler
		if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.inflictor and self:GetParent():GetSpellLifesteal() > 0 and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			-- Particle effect
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)

			keys.attacker:Heal(math.max(keys.damage, 0) * self.vampiric_aura / 100, keys.attacker)
			-- Attack lifesteal handler
		elseif keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK and self:GetParent():GetLifesteal() > 0 then
			-- Heal and fire the particle			
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/item/vladmir/vladmir_blood_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)

			keys.attacker:Heal(keys.damage * self.vampiric_aura / 100, keys.attacker)
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Vladmir's Blood definition
-----------------------------------------------------------------------------------------------------------

if item_imba_vladmir_2 == nil then item_imba_vladmir_2 = class({}) end
LinkLuaModifier("modifier_item_imba_vladmir_blood", "components/items/item_vladmir.lua", LUA_MODIFIER_MOTION_NONE)                -- Owner's bonus attributes, stackable
LinkLuaModifier("modifier_item_imba_vladmir_blood_aura_emitter", "components/items/item_vladmir.lua", LUA_MODIFIER_MOTION_NONE)   -- Aura emitter
LinkLuaModifier("modifier_item_imba_vladmir_blood_aura", "components/items/item_vladmir.lua", LUA_MODIFIER_MOTION_NONE)           -- Aura buff

function item_imba_vladmir_2:GetAbilityTextureName()
	return "imba_vladmir_2"
end

function item_imba_vladmir_2:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_PASSIVE + DOTA_ABILITY_BEHAVIOR_AURA
end

function item_imba_vladmir_2:GetCastRange()
	return self:GetSpecialValueFor("aura_radius") - self:GetCaster():GetCastRangeBonus()
end

function item_imba_vladmir_2:GetIntrinsicModifierName()
	return "modifier_item_imba_vladmir_blood"
end

-----------------------------------------------------------------------------------------------------------
--	Vladmir's blood owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_vladmir_blood == nil then modifier_item_imba_vladmir_blood = class({}) end

function modifier_item_imba_vladmir_blood:IsHidden() return true end

function modifier_item_imba_vladmir_blood:IsPurgable() return false end

function modifier_item_imba_vladmir_blood:RemoveOnDeath() return false end

function modifier_item_imba_vladmir_blood:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

--[[
function modifier_item_imba_vladmir_blood:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
end

function modifier_item_imba_vladmir_blood:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("stat_bonus")
	end
end

function modifier_item_imba_vladmir_blood:GetModifierBonusStats_Agility()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("stat_bonus")
	end
end

function modifier_item_imba_vladmir_blood:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("stat_bonus")
	end
end
--]]
function modifier_item_imba_vladmir_blood:IsAura() return true end

function modifier_item_imba_vladmir_blood:IsAuraActiveOnDeath() return false end

function modifier_item_imba_vladmir_blood:GetAuraRadius() if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("aura_radius") end end

function modifier_item_imba_vladmir_blood:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_item_imba_vladmir_blood:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_item_imba_vladmir_blood:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_item_imba_vladmir_blood:GetModifierAura() return "modifier_item_imba_vladmir_blood_aura" end

-- function modifier_item_imba_vladmir_blood:GetAuraEntityReject(hTarget)	return false end

-----------------------------------------------------------------------------------------------------------
--	Vladmir's Blood aura
-----------------------------------------------------------------------------------------------------------

modifier_item_imba_vladmir_blood_aura = modifier_item_imba_vladmir_blood_aura or class({})

-- Aura icon
function modifier_item_imba_vladmir_blood_aura:GetTexture()
	return "imba_vladmir_2"
end

-- Stores the aura's parameters to prevent errors when the item is unequipped
function modifier_item_imba_vladmir_blood_aura:OnCreated(keys)
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	self.damage_aura     = self:GetAbility():GetSpecialValueFor("damage_aura")
	self.armor_aura      = self:GetAbility():GetSpecialValueFor("armor_aura")
	self.hp_regen_aura   = self:GetAbility():GetSpecialValueFor("hp_regen_aura")
	self.mana_regen_aura = self:GetAbility():GetSpecialValueFor("mana_regen_aura")
	self.vampiric_aura   = self:GetAbility():GetSpecialValueFor("vampiric_aura")

	if IsServer() and self:GetParent():IsHero() then
		ChangeAttackProjectileImba(self:GetParent())
	end
end

-- Possible projectile change
function modifier_item_imba_vladmir_blood_aura:OnDestroy()
	if IsServer() and self:GetParent():IsHero() then
		local parent = self:GetParent()
		ChangeAttackProjectileImba(parent)
	end
end

-- Lifesteal
function modifier_item_imba_vladmir_blood_aura:GetModifierLifesteal()
	return self.vampiric_aura
end

-- Spell lifesteal
function modifier_item_imba_vladmir_blood_aura:GetModifierSpellLifesteal()
	return self.vampiric_aura
end

-- Bonuses
function modifier_item_imba_vladmir_blood_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,

		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_item_imba_vladmir_blood_aura:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage_aura
end

function modifier_item_imba_vladmir_blood_aura:GetModifierPhysicalArmorBonusUnique()
	return self.armor_aura
end

function modifier_item_imba_vladmir_blood_aura:GetModifierConstantHealthRegen()
	return self.hp_regen_aura
end

function modifier_item_imba_vladmir_blood_aura:GetModifierConstantManaRegen()
	return self.mana_regen_aura
end

-- Lifesteal handler (for units not covered by the generic talent handler modifier)

--- Enum DamageCategory_t
-- DOTA_DAMAGE_CATEGORY_ATTACK = 1
-- DOTA_DAMAGE_CATEGORY_SPELL = 0
function modifier_item_imba_vladmir_blood_aura:OnTakeDamage(keys)
	if not keys.attacker:HasModifier("modifier_custom_mechanics") and keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		-- Spell lifesteal handler
		if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.inflictor and self:GetParent():GetSpellLifesteal() > 0 and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			-- Particle effect
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)

			keys.attacker:Heal(math.max(keys.damage, 0) * self.vampiric_aura / 100, keys.attacker)
			-- Attack lifesteal handler
		elseif keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK and self:GetParent():GetLifesteal() > 0 then
			-- Heal and fire the particle			
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/item/vladmir/vladmir_blood_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)

			keys.attacker:Heal(keys.damage * self.vampiric_aura / 100, keys.attacker)
		end
	end
end
