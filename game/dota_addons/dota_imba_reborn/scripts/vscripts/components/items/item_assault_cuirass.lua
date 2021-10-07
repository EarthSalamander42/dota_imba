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
-- Date: 16/05/2017


---------------------------------
--       ASSAULT CUIRASS       --
---------------------------------
item_imba_assault = class({})
LinkLuaModifier("modifier_imba_assault_cuirass", "components/items/item_assault_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_assault_cuirass_aura_positive", "components/items/item_assault_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_assault_cuirass_aura_positive_effect", "components/items/item_assault_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_assault_cuirass_aura_negative", "components/items/item_assault_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_assault_cuirass_aura_negative_effect", "components/items/item_assault_cuirass.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_assault:GetIntrinsicModifierName()
	return "modifier_imba_assault_cuirass"
end

-- Stats passive modifier (stacking)
modifier_imba_assault_cuirass = class({})

function modifier_imba_assault_cuirass:IsHidden()		return true end
function modifier_imba_assault_cuirass:IsPurgable()		return false end
function modifier_imba_assault_cuirass:RemoveOnDeath()	return false end
function modifier_imba_assault_cuirass:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_assault_cuirass:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	if not IsServer() then return end
	
	-- If it is the first Assault Cuirass in the inventory, grant the Assault Cuirass aura
	if not self:GetCaster():HasModifier("modifier_imba_assault_cuirass_aura_positive") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_assault_cuirass_aura_positive", {})
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_assault_cuirass_aura_negative", {})
	end
end

function modifier_imba_assault_cuirass:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		
--		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
--		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,	
--		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_imba_assault_cuirass:GetModifierAttackSpeedBonus_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_as")
	end
end

function modifier_imba_assault_cuirass:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_armor")
	end
end

--[[
function modifier_imba_assault_cuirass:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	end
end

function modifier_imba_assault_cuirass:GetModifierBonusStats_Agility()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	end
end

function modifier_imba_assault_cuirass:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	end
end
--]]

function modifier_imba_assault_cuirass:OnDestroy()
	if IsServer() then
		-- If it is the last Assault Cuirass in the inventory, remove the aura
		if not self:GetCaster():HasModifier("modifier_imba_assault_cuirass") then
			self:GetCaster():RemoveModifierByName("modifier_imba_assault_cuirass_aura_positive")
			self:GetCaster():RemoveModifierByName("modifier_imba_assault_cuirass_aura_negative")
		end
	end
end

-- Assault Cuirass positive aura
modifier_imba_assault_cuirass_aura_positive = class({})

function modifier_imba_assault_cuirass_aura_positive:IsDebuff() return false end
function modifier_imba_assault_cuirass_aura_positive:AllowIllusionDuplicate() return true end
function modifier_imba_assault_cuirass_aura_positive:IsHidden() return true end
function modifier_imba_assault_cuirass_aura_positive:IsPurgable() return false end

function modifier_imba_assault_cuirass_aura_positive:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("radius")
	end
end

function modifier_imba_assault_cuirass_aura_positive:GetAuraEntityReject(target)
	-- If the target has Siege Aura from Siege Cuirass, ignore it
	if target:HasModifier("modifier_imba_siege_cuirass_aura_positive_effect") or target:HasModifier("modifier_imba_sogat_cuirass_aura_positive") then
		return true
	end

	return false
end

function modifier_imba_assault_cuirass_aura_positive:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_assault_cuirass_aura_positive:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_assault_cuirass_aura_positive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_imba_assault_cuirass_aura_positive:GetModifierAura()
	return "modifier_imba_assault_cuirass_aura_positive_effect"
end

function modifier_imba_assault_cuirass_aura_positive:IsAura()
	return true
end



-- Assault Cuirass positive aura effect
modifier_imba_assault_cuirass_aura_positive_effect = class({})

function modifier_imba_assault_cuirass_aura_positive_effect:OnCreated()
	if not self:GetAbility() then
		if IsServer() then
			self:Destroy()
		end

		return
	end

	-- Ability specials
	self.aura_as_ally = self:GetAbility():GetSpecialValueFor("aura_as_ally")
	self.aura_armor_ally = self:GetAbility():GetSpecialValueFor("aura_armor_ally")
end

function modifier_imba_assault_cuirass_aura_positive_effect:IsHidden() return false end
function modifier_imba_assault_cuirass_aura_positive_effect:IsPurgable() return false end
function modifier_imba_assault_cuirass_aura_positive_effect:IsDebuff() return false end

function modifier_imba_assault_cuirass_aura_positive_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_imba_assault_cuirass_aura_positive_effect:GetModifierAttackSpeedBonus_Constant()
	return self.aura_as_ally
end

function modifier_imba_assault_cuirass_aura_positive_effect:GetModifierPhysicalArmorBonus()
	return self.aura_armor_ally
end

function modifier_imba_assault_cuirass_aura_positive_effect:GetEffectName()
	return "particles/items_fx/aura_assault.vpcf"
end

function modifier_imba_assault_cuirass_aura_positive_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


-- Assault Cuirass negative aura
modifier_imba_assault_cuirass_aura_negative = class({})

function modifier_imba_assault_cuirass_aura_negative:IsDebuff() return false end
function modifier_imba_assault_cuirass_aura_negative:AllowIllusionDuplicate() return true end
function modifier_imba_assault_cuirass_aura_negative:IsHidden() return true end
function modifier_imba_assault_cuirass_aura_negative:IsPurgable() return false end

function modifier_imba_assault_cuirass_aura_negative:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("radius")
	end
end

function modifier_imba_assault_cuirass_aura_negative:GetAuraEntityReject(target)
	-- If the target has Siege Aura from Siege Cuirass, ignore it
	if target:HasModifier("modifier_imba_siege_cuirass_aura_negative_effect") or target:HasModifier("modifier_imba_sogat_cuirass_aura_negative") then
		return true
	end

	return false
end

function modifier_imba_assault_cuirass_aura_negative:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_imba_assault_cuirass_aura_negative:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_assault_cuirass_aura_negative:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_imba_assault_cuirass_aura_negative:GetModifierAura()
	return "modifier_imba_assault_cuirass_aura_negative_effect"
end

function modifier_imba_assault_cuirass_aura_negative:IsAura()
	return true
end



-- Assault Cuirass negative aura effect
modifier_imba_assault_cuirass_aura_negative_effect = class({})

function modifier_imba_assault_cuirass_aura_negative_effect:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	self.aura_armor_reduction_enemy = self:GetAbility():GetSpecialValueFor("aura_armor_reduction_enemy") * (-1)
end

function modifier_imba_assault_cuirass_aura_negative_effect:IsHidden() return false end
function modifier_imba_assault_cuirass_aura_negative_effect:IsPurgable() return false end
function modifier_imba_assault_cuirass_aura_negative_effect:IsDebuff() return true end

function modifier_imba_assault_cuirass_aura_negative_effect:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_imba_assault_cuirass_aura_negative_effect:GetModifierPhysicalArmorBonus()
	return self.aura_armor_reduction_enemy
end
