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
--	Date: 			21.07.2016
--	Last Update:	09.03.2020 -- AlitV


-----------------------------------------------------------------------------------------------------------
--	Crystalys definition
-----------------------------------------------------------------------------------------------------------

if item_imba_lesser_crit == nil then item_imba_lesser_crit = class({}) end
LinkLuaModifier("modifier_item_imba_lesser_crit", "components/items/item_crit.lua", LUA_MODIFIER_MOTION_NONE)   -- Owner's bonus attributes, stackable

function item_imba_lesser_crit:GetIntrinsicModifierName()
	return "modifier_item_imba_lesser_crit"
end

-----------------------------------------------------------------------------------------------------------
--	Crystalys owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_lesser_crit == nil then modifier_item_imba_lesser_crit = class({}) end

function modifier_item_imba_lesser_crit:IsHidden() return true end

function modifier_item_imba_lesser_crit:IsPurgable() return false end

function modifier_item_imba_lesser_crit:RemoveOnDeath() return false end

function modifier_item_imba_lesser_crit:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_lesser_crit:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}
end

function modifier_item_imba_lesser_crit:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

-- "Does not work against wards, buildings, and allied units."
function modifier_item_imba_lesser_crit:GetModifierPreAttack_CriticalStrike(keys)
	if self:GetAbility() and (keys.target and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber()) and RollPseudoRandom(self:GetAbility():GetSpecialValueFor("crit_chance"), self) then
		return self:GetAbility():GetSpecialValueFor("crit_multiplier")
	end
end

-----------------------------------------------------------------------------------------------------------
--	Daedalus definition
-----------------------------------------------------------------------------------------------------------

if item_imba_greater_crit == nil then item_imba_greater_crit = class({}) end
LinkLuaModifier("modifier_item_imba_greater_crit", "components/items/item_crit.lua", LUA_MODIFIER_MOTION_NONE)        -- Owner's bonus attributes, stackable
LinkLuaModifier("modifier_item_imba_greater_crit_buff", "components/items/item_crit.lua", LUA_MODIFIER_MOTION_NONE)   -- Critical damage increase counter

function item_imba_greater_crit:GetIntrinsicModifierName()
	return "modifier_item_imba_greater_crit"
end

-----------------------------------------------------------------------------------------------------------
--	Daedalus owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_greater_crit == nil then modifier_item_imba_greater_crit = class({}) end

function modifier_item_imba_greater_crit:IsHidden() return true end

function modifier_item_imba_greater_crit:IsPurgable() return false end

function modifier_item_imba_greater_crit:RemoveOnDeath() return false end

function modifier_item_imba_greater_crit:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the damage increase counter when created
function modifier_item_imba_greater_crit:OnCreated(keys)
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	if not self:GetAbility() or not IsServer() then return end

	if not self:GetParent():HasModifier("modifier_item_imba_greater_crit_buff") then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_imba_greater_crit_buff", {})
	end
end

-- Removes the damage increase counter if this is the last Daedalus in the inventory
function modifier_item_imba_greater_crit:OnDestroy()
	if not IsServer() then return end

	if not self:GetParent():HasModifier("modifier_item_imba_greater_crit") then
		self:GetParent():RemoveModifierByName("modifier_item_imba_greater_crit_buff")
	end
end

function modifier_item_imba_greater_crit:DeclareFunctions()
	return { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE }
end

function modifier_item_imba_greater_crit:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

-----------------------------------------------------------------------------------------------------------
--	Daedalus crit damage buff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_greater_crit_buff == nil then modifier_item_imba_greater_crit_buff = class({}) end
function modifier_item_imba_greater_crit_buff:IsHidden() return false end

function modifier_item_imba_greater_crit_buff:IsPurgable() return false end

function modifier_item_imba_greater_crit_buff:RemoveOnDeath() return false end

function modifier_item_imba_greater_crit_buff:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	-- Special values
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor("crit_multiplier")
	self.crit_increase   = self:GetAbility():GetSpecialValueFor("crit_increase")
	self.crit_chance     = self:GetAbility():GetSpecialValueFor("crit_chance")
end

function modifier_item_imba_greater_crit_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_imba_greater_crit_buff:GetModifierPreAttack_CriticalStrike(keys)
	if self:GetAbility() and (keys.target and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber()) then
		local multiplicative_chance = (1 - ((1 - (self.crit_chance / 100)) ^ #self:GetParent():FindAllModifiersByName("modifier_item_imba_greater_crit"))) * 100

		-- RollPseudoRandom only keeps track of whole numbers, so some rounding is required
		if RollPseudoRandom(math.ceil(multiplicative_chance), self) then
			self.bCrit = true
			local stacks = self:GetStackCount()
			self:SetStackCount(0)
			return self.crit_multiplier + stacks
		else
			self.bCrit = false
		end
	end
end

function modifier_item_imba_greater_crit_buff:OnAttackLanded(keys)
	if self:GetAbility() and keys.attacker == self:GetParent() and (keys.target and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber()) then
		if not self.bCrit and keys.original_damage > 0 then
			self:SetStackCount(self:GetStackCount() + (self.crit_increase * #self:GetParent():FindAllModifiersByName("modifier_item_imba_greater_crit")))
		elseif self.bCrit then
			keys.target:EmitSound("DOTA_Item.Daedelus.Crit")
		end
	end
end
