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
--	Last Update:	07.08.2017


-----------------------------------------------------------------------------------------------------------
--	Crystalys definition
-----------------------------------------------------------------------------------------------------------

if item_imba_lesser_crit == nil then item_imba_lesser_crit = class({}) end
LinkLuaModifier( "modifier_item_imba_lesser_crit", "components/items/item_crit.lua", LUA_MODIFIER_MOTION_NONE )		-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_lesser_crit_buff", "components/items/item_crit.lua", LUA_MODIFIER_MOTION_NONE )	-- Critical damage increase counter

function item_imba_lesser_crit:GetIntrinsicModifierName()
	return "modifier_item_imba_lesser_crit" end

-----------------------------------------------------------------------------------------------------------
--	Crystalys owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_lesser_crit == nil then modifier_item_imba_lesser_crit = class({}) end
function modifier_item_imba_lesser_crit:IsHidden() return true end
function modifier_item_imba_lesser_crit:IsDebuff() return false end
function modifier_item_imba_lesser_crit:IsPurgable() return false end
function modifier_item_imba_lesser_crit:IsPermanent() return true end
function modifier_item_imba_lesser_crit:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the damage increase counter when created
function modifier_item_imba_lesser_crit:OnCreated(keys)
	self.ability = self:GetAbility()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")

	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_lesser_crit_buff") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_imba_lesser_crit_buff", {})
		end
	end
end


function modifier_item_imba_lesser_crit:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,}

	return decFuncs
end

function modifier_item_imba_lesser_crit:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

-- Removes the crit if Crystalys is not in the inventory
function modifier_item_imba_lesser_crit:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_lesser_crit") then
			parent:RemoveModifierByName("modifier_item_imba_lesser_crit_buff")
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Crystalys crit triggers
-----------------------------------------------------------------------------------------------------------
modifier_item_imba_lesser_crit_buff = modifier_item_imba_lesser_crit_buff or class({})
function modifier_item_imba_lesser_crit_buff:IsHidden() return true end
function modifier_item_imba_lesser_crit_buff:IsDebuff() return false end
function modifier_item_imba_lesser_crit_buff:IsPurgable() return false end

-- Track parameters to prevent errors if the item is unequipped
function modifier_item_imba_lesser_crit_buff:OnCreated()
	if IsServer() then
		self.base_crit = self:GetAbility():GetSpecialValueFor("base_crit")
		self.crit_chance = self:GetAbility():GetSpecialValueFor("crit_chance")
	end
end

-- Declare modifier events/properties
function modifier_item_imba_lesser_crit_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
	return funcs
end

-- Grant the crit damage multiplier
function modifier_item_imba_lesser_crit_buff:GetModifierPreAttack_CriticalStrike(params)
	if IsServer() then
		if RollPercentage(self.crit_chance) then
			return self.base_crit
		else
			return nil
		end
	end
end



-----------------------------------------------------------------------------------------------------------
--	Daedalus definition
-----------------------------------------------------------------------------------------------------------

if item_imba_greater_crit == nil then item_imba_greater_crit = class({}) end
LinkLuaModifier( "modifier_item_imba_greater_crit", "components/items/item_crit.lua", LUA_MODIFIER_MOTION_NONE )		-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_greater_crit_buff", "components/items/item_crit.lua", LUA_MODIFIER_MOTION_NONE )	-- Critical damage increase counter

function item_imba_greater_crit:GetIntrinsicModifierName()
	return "modifier_item_imba_greater_crit" end

-----------------------------------------------------------------------------------------------------------
--	Daedalus owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_greater_crit == nil then modifier_item_imba_greater_crit = class({}) end
function modifier_item_imba_greater_crit:IsHidden() return true end
function modifier_item_imba_greater_crit:IsDebuff() return false end
function modifier_item_imba_greater_crit:IsPurgable() return false end
function modifier_item_imba_greater_crit:IsPermanent() return true end
function modifier_item_imba_greater_crit:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the damage increase counter when created
function modifier_item_imba_greater_crit:OnCreated(keys)
	self.ability = self:GetAbility()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")

	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_greater_crit_buff") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_imba_greater_crit_buff", {})
		end
	end
end

function modifier_item_imba_greater_crit:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}

	return decFuncs
end

function modifier_item_imba_greater_crit:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end


-- Removes the damage increase counter if this is the last Daedalus in the inventory
function modifier_item_imba_greater_crit:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_greater_crit") then
			parent:RemoveModifierByName("modifier_item_imba_greater_crit_buff")
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Daedalus crit damage buff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_greater_crit_buff == nil then modifier_item_imba_greater_crit_buff = class({}) end
function modifier_item_imba_greater_crit_buff:IsHidden() return false end
function modifier_item_imba_greater_crit_buff:IsDebuff() return false end
function modifier_item_imba_greater_crit_buff:IsPurgable() return false end
function modifier_item_imba_greater_crit_buff:IsPermanent() return true end

function modifier_item_imba_greater_crit_buff:OnCreated()
	-- Ability
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Special values
	self.base_crit = self.ability:GetSpecialValueFor("base_crit")
	self.crit_increase = self.ability:GetSpecialValueFor("crit_increase")
	self.crit_chance = self.ability:GetSpecialValueFor("crit_chance")
end

function modifier_item_imba_greater_crit_buff:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return decFuncs
end

function modifier_item_imba_greater_crit_buff:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() then

		-- Find how many Daedaluses we have for calculating crits
		local crit_modifiers = self.caster:FindAllModifiersByName("modifier_item_imba_greater_crit")

		-- Get current power
		local stacks = self:GetStackCount()
		local crit_power = self.base_crit + self.crit_increase/self.crit_increase * stacks

		self.crit_succeeded = false
		local multiplicative_chance = (1 - (1 - self.crit_chance * 0.01) ^ #crit_modifiers) * 100

		if RollPercentage(multiplicative_chance) then
			self:SetStackCount(0)
			self.crit_succeeded = true
		end

		if self.crit_succeeded then
			return crit_power
		else
			return nil
		end
	end
end

function modifier_item_imba_greater_crit_buff:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() then

			-- If the target is a building, do nothing
			if params.target:IsBuilding() then
				return nil
			end

			if not self.crit_succeeded then
				local stacks = self:GetStackCount()
				local crit_modifiers = self.caster:FindAllModifiersByName("modifier_item_imba_greater_crit")
				self:SetStackCount(stacks + self.crit_increase * #crit_modifiers)
			end
		end
	end
end
