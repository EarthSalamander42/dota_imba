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
--	Last Update:	14.03.2017

-----------------------------------------------------------------------------------------------------------
--	Vladmir's Offering definition
-----------------------------------------------------------------------------------------------------------

if item_imba_vladmir == nil then item_imba_vladmir = class({}) end
LinkLuaModifier( "modifier_item_imba_vladmir", "components/items/item_vladmir.lua", LUA_MODIFIER_MOTION_NONE )					-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_vladmir_aura_emitter", "components/items/item_vladmir.lua", LUA_MODIFIER_MOTION_NONE )	-- Aura emitter
LinkLuaModifier( "modifier_item_imba_vladmir_aura", "components/items/item_vladmir.lua", LUA_MODIFIER_MOTION_NONE )			-- Aura buff

function item_imba_vladmir:GetAbilityTextureName()
	return "custom/imba_vladmir"
end

function item_imba_vladmir:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_PASSIVE + DOTA_ABILITY_BEHAVIOR_AURA end

function item_imba_vladmir:GetCastRange()
	return self:GetSpecialValueFor("aura_radius") end

function item_imba_vladmir:GetIntrinsicModifierName()
	return "modifier_item_imba_vladmir" end

-----------------------------------------------------------------------------------------------------------
--	Vladmir's offering owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_vladmir == nil then modifier_item_imba_vladmir = class({}) end
function modifier_item_imba_vladmir:IsHidden() return true end
function modifier_item_imba_vladmir:IsDebuff() return false end
function modifier_item_imba_vladmir:IsPurgable() return false end
function modifier_item_imba_vladmir:IsPermanent() return true end
function modifier_item_imba_vladmir:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the aura emitter to the caster when created
function modifier_item_imba_vladmir:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_vladmir_aura_emitter") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_imba_vladmir_aura_emitter", {})
		end
	end
end

-- Removes the aura emitter from the caster if this is the last vladmir's offering in its inventory
function modifier_item_imba_vladmir:OnDestroy(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_vladmir") then
			parent:RemoveModifierByName("modifier_item_imba_vladmir_aura_emitter")
		end
	end
end

-- Attribute bonuses
function modifier_item_imba_vladmir:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifier_item_imba_vladmir:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("stat_bonus") end

function modifier_item_imba_vladmir:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("stat_bonus") end

function modifier_item_imba_vladmir:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("stat_bonus") end

-----------------------------------------------------------------------------------------------------------
--	Vladmir's Offering aura emitter
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_vladmir_aura_emitter == nil then modifier_item_imba_vladmir_aura_emitter = class({}) end
function modifier_item_imba_vladmir_aura_emitter:IsAura() return true end
function modifier_item_imba_vladmir_aura_emitter:IsHidden() return true end
function modifier_item_imba_vladmir_aura_emitter:IsDebuff() return false end
function modifier_item_imba_vladmir_aura_emitter:IsPurgable() return false end

function modifier_item_imba_vladmir_aura_emitter:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_item_imba_vladmir_aura_emitter:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end

function modifier_item_imba_vladmir_aura_emitter:GetModifierAura()
	if IsServer() then
		if self:GetParent():IsAlive() then
			return "modifier_item_imba_vladmir_aura"
		else
			return nil
		end
	end
end

function modifier_item_imba_vladmir_aura_emitter:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius") end

-----------------------------------------------------------------------------------------------------------
--	Vladmir's Offering aura
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_vladmir_aura == nil then modifier_item_imba_vladmir_aura = class({}) end
function modifier_item_imba_vladmir_aura:IsDebuff() return false end
function modifier_item_imba_vladmir_aura:IsPurgable() return false end

-- Aura icon
function modifier_item_imba_vladmir_aura:GetTexture()
	return "custom/imba_vladmir" end

function modifier_item_imba_vladmir_aura:IsHidden()
	if self:GetParent():HasModifier("modifier_item_imba_vladmir_blood_aura") then
		return true
	else
		return false
	end
end

-- Stores the aura's parameters to prevent errors when the item is unequipped
function modifier_item_imba_vladmir_aura:OnCreated(keys)
	self.damage_aura = self:GetAbility():GetSpecialValueFor("damage_aura")
	self.armor_aura = self:GetAbility():GetSpecialValueFor("armor_aura")
	self.hp_regen_aura = self:GetAbility():GetSpecialValueFor("hp_regen_aura")
	self.mana_regen_aura = self:GetAbility():GetSpecialValueFor("mana_regen_aura")

	if IsServer() and self:GetParent():IsHero() then
		ChangeAttackProjectileImba(self:GetParent())
	end
end

-- Possible projectile change
function modifier_item_imba_vladmir_aura:OnDestroy()
	if IsServer() and self:GetParent():IsHero() then
		local parent = self:GetParent()
		ChangeAttackProjectileImba(parent)
	end
end

-- Lifesteal
function modifier_item_imba_vladmir_aura:GetModifierLifesteal()
	return self:GetAbility():GetSpecialValueFor("vampiric_aura") end

-- Bonuses (does not stack with Vladmir's Blood)
function modifier_item_imba_vladmir_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
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
	return self.armor_aura end

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

-- Lifesteal handler (for creeps and illusions only - real heroes' lifesteal is covered by the generic talent handler modifier)
function modifier_item_imba_vladmir_aura:OnAttackLanded( keys )
	if IsServer() then
		local parent = self:GetParent()
		local attacker = keys.attacker

		-- If this attack was not performed by the modifier's parent, or if it is a real hero, or if it's affected by an upgraded Vladmir, do nothing
		if parent ~= attacker or parent:IsRealHero() or parent:HasModifier("modifier_item_imba_vladmir_blood_aura") then
			return end

		-- Else, keep going
		local target = keys.target
		local lifesteal_amount = self:GetAbility():GetSpecialValueFor("vampiric_aura")

		-- If there's no valid target, do nothing
		if target:IsBuilding() or target:IsIllusion() or (target:GetTeam() == attacker:GetTeam()) then
			return end

		-- Calculate actual lifesteal amount
		local damage = keys.damage
		local target_armor = target:GetPhysicalArmorValue()
		local heal = damage * lifesteal_amount * 0.01 * (1 - 0.06 * (target_armor / (1 + 0.06 * target_armor)))

		-- If the attacker is an illusion, only draw the particle
		if attacker:IsHero() then
			local lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
			ParticleManager:SetParticleControl(lifesteal_pfx, 0, attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(lifesteal_pfx)

			-- If its a creep, heal and draw its appropriate particle
		else
			attacker:Heal(heal, attacker)
			local lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal_lanecreeps.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
			ParticleManager:SetParticleControl(lifesteal_pfx, 0, attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Vladmir's Blood definition
-----------------------------------------------------------------------------------------------------------

if item_imba_vladmir_2 == nil then item_imba_vladmir_2 = class({}) end
LinkLuaModifier( "modifier_item_imba_vladmir_blood", "components/items/item_vladmir.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_vladmir_blood_aura_emitter", "components/items/item_vladmir.lua", LUA_MODIFIER_MOTION_NONE )	-- Aura emitter
LinkLuaModifier( "modifier_item_imba_vladmir_blood_aura", "components/items/item_vladmir.lua", LUA_MODIFIER_MOTION_NONE )			-- Aura buff

function item_imba_vladmir_2:GetAbilityTextureName()
	return "custom/imba_vladmir_2"
end

function item_imba_vladmir_2:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_PASSIVE + DOTA_ABILITY_BEHAVIOR_AURA end

function item_imba_vladmir_2:GetCastRange()
	return self:GetSpecialValueFor("aura_radius") end

function item_imba_vladmir_2:GetIntrinsicModifierName()
	return "modifier_item_imba_vladmir_blood" end

-----------------------------------------------------------------------------------------------------------
--	Vladmir's blood owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_vladmir_blood == nil then modifier_item_imba_vladmir_blood = class({}) end
function modifier_item_imba_vladmir_blood:IsHidden() return true end
function modifier_item_imba_vladmir_blood:IsDebuff() return false end
function modifier_item_imba_vladmir_blood:IsPurgable() return false end
function modifier_item_imba_vladmir_blood:IsPermanent() return true end
function modifier_item_imba_vladmir_blood:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the aura emitter to the caster when created
function modifier_item_imba_vladmir_blood:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_vladmir_blood_aura_emitter") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_imba_vladmir_blood_aura_emitter", {})
		end
		parent:RemoveModifierByName("modifier_item_imba_vladmir_aura_emitter")
	end
end

-- Removes the aura emitter from the caster if this is the last vladmir's offering in its inventory
function modifier_item_imba_vladmir_blood:OnDestroy(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_vladmir_blood") then
			parent:RemoveModifierByName("modifier_item_imba_vladmir_blood_aura_emitter")
		end
	end
end

-- Attribute bonuses
function modifier_item_imba_vladmir_blood:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifier_item_imba_vladmir_blood:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("stat_bonus") end

function modifier_item_imba_vladmir_blood:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("stat_bonus") end

function modifier_item_imba_vladmir_blood:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("stat_bonus") end

-----------------------------------------------------------------------------------------------------------
--	Vladmir's Blood aura emitter
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_vladmir_blood_aura_emitter == nil then modifier_item_imba_vladmir_blood_aura_emitter = class({}) end
function modifier_item_imba_vladmir_blood_aura_emitter:IsAura() return true end
function modifier_item_imba_vladmir_blood_aura_emitter:IsHidden() return true end
function modifier_item_imba_vladmir_blood_aura_emitter:IsDebuff() return false end
function modifier_item_imba_vladmir_blood_aura_emitter:IsPurgable() return false end

function modifier_item_imba_vladmir_blood_aura_emitter:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_item_imba_vladmir_blood_aura_emitter:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end

function modifier_item_imba_vladmir_blood_aura_emitter:GetModifierAura()
	if IsServer() then
		if self:GetParent():IsAlive() then
			return "modifier_item_imba_vladmir_blood_aura"
		else
			return nil
		end
	end
end

function modifier_item_imba_vladmir_blood_aura_emitter:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius") end

-----------------------------------------------------------------------------------------------------------
--	Vladmir's Blood aura
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_vladmir_blood_aura == nil then modifier_item_imba_vladmir_blood_aura = class({}) end
function modifier_item_imba_vladmir_blood_aura:IsHidden() return false end
function modifier_item_imba_vladmir_blood_aura:IsDebuff() return false end
function modifier_item_imba_vladmir_blood_aura:IsPurgable() return false end

-- Aura icon
function modifier_item_imba_vladmir_blood_aura:GetTexture()
	return "custom/imba_vladmir_2" end

-- Stores the aura's parameters to prevent errors when the item is unequipped
function modifier_item_imba_vladmir_blood_aura:OnCreated(keys)
	if self:GetAbility() == nil then return end
	self.damage_aura = self:GetAbility():GetSpecialValueFor("damage_aura")
	self.armor_aura = self:GetAbility():GetSpecialValueFor("armor_aura")
	self.hp_regen_aura = self:GetAbility():GetSpecialValueFor("hp_regen_aura")
	self.mana_regen_aura = self:GetAbility():GetSpecialValueFor("mana_regen_aura")
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
	return self:GetAbility():GetSpecialValueFor("vampiric_aura") end

-- Spell lifesteal
function modifier_item_imba_vladmir_blood_aura:GetModifierSpellLifesteal()
	return self:GetAbility():GetSpecialValueFor("vampiric_aura") end

-- Bonuses
function modifier_item_imba_vladmir_blood_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_vladmir_blood_aura:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage_aura end

function modifier_item_imba_vladmir_blood_aura:GetModifierPhysicalArmorBonusUnique()
	return self.armor_aura end

function modifier_item_imba_vladmir_blood_aura:GetModifierConstantHealthRegen()
	return self.hp_regen_aura end

function modifier_item_imba_vladmir_blood_aura:GetModifierConstantManaRegen()
	return self.mana_regen_aura end

-- Lifesteal handler (for creeps and illusions only - real heroes' lifesteal is covered by the generic talent handler modifier)
function modifier_item_imba_vladmir_blood_aura:OnAttackLanded( keys )
	if IsServer() then
		local parent = self:GetParent()
		local attacker = keys.attacker

		-- If this attack was not performed by the modifier's parent, or if it is a real hero, do nothing
		if parent ~= attacker or parent:IsRealHero() then
			return end

		-- Else, keep going
		local target = keys.target
		local lifesteal_amount = self:GetAbility():GetSpecialValueFor("vampiric_aura")

		-- If there's no valid target, do nothing
		if target:IsBuilding() or target:IsIllusion() or (target:GetTeam() == attacker:GetTeam()) then
			return end

		-- Calculate actual lifesteal amount
		local damage = keys.damage
		local target_armor = target:GetPhysicalArmorValue()
		local heal = damage * lifesteal_amount * 0.01 * (1 - 0.06 * (target_armor / (1 + 0.06 * target_armor)))

		-- If the attacker is an illusion, only draw the particle
		if attacker:IsHero() then
			local lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
			ParticleManager:SetParticleControl(lifesteal_pfx, 0, attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(lifesteal_pfx)

			-- If its a creep, heal and draw its appropriate particle
		else
			attacker:Heal(heal, attacker)
			local lifesteal_pfx = ParticleManager:CreateParticle("particles/item/vladmir/vladmir_offering_lifesteal_creeps.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
			ParticleManager:SetParticleControl(lifesteal_pfx, 0, attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
		end
	end
end
