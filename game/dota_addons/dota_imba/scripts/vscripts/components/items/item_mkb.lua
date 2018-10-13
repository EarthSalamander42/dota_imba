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
--	Date: 			20.09.2015
--	Last Update:	19.03.2017

-----------------------------------------------------------------------------------------------------------
--	Javelin definition
-----------------------------------------------------------------------------------------------------------

if item_imba_javelin == nil then item_imba_javelin = class({}) end
LinkLuaModifier( "modifier_item_imba_javelin", "components/items/item_mkb.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_javelin_unique", "components/items/item_mkb.lua", LUA_MODIFIER_MOTION_NONE )	-- Pierce and bonus attack range

function item_imba_javelin:GetAbilityTextureName()
	return "custom/imba_javelin"
end

function item_imba_javelin:GetIntrinsicModifierName()
	return "modifier_item_imba_javelin" end

-----------------------------------------------------------------------------------------------------------
--	Javelin owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_javelin == nil then modifier_item_imba_javelin = class({}) end
function modifier_item_imba_javelin:IsHidden() return true end
function modifier_item_imba_javelin:IsDebuff() return false end
function modifier_item_imba_javelin:IsPurgable() return false end
function modifier_item_imba_javelin:IsPermanent() return true end
function modifier_item_imba_javelin:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the unique modifier to the caster when created
function modifier_item_imba_javelin:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_javelin_unique") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_imba_javelin_unique", {})
		end
	end
end

-- Removes the unique modifier from the caster if this is the last Javelin in its inventory
function modifier_item_imba_javelin:OnDestroy(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_javelin") then
			parent:RemoveModifierByName("modifier_item_imba_javelin_unique")
		end
	end
end

-- Declare modifier events/properties
function modifier_item_imba_javelin:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function modifier_item_imba_javelin:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

-----------------------------------------------------------------------------------------------------------
--	Javelin unique passive (Pierce + melee range increase)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_javelin_unique == nil then modifier_item_imba_javelin_unique = class({}) end
function modifier_item_imba_javelin_unique:IsHidden() return true end
function modifier_item_imba_javelin_unique:IsDebuff() return false end
function modifier_item_imba_javelin_unique:IsPurgable() return false end
function modifier_item_imba_javelin_unique:IsPermanent() return true end

-- Store ability keys for later
function modifier_item_imba_javelin_unique:OnCreated()
	self.bonus_range = self:GetAbility():GetSpecialValueFor("bonus_range")
	self.pierce_count = self:GetAbility():GetSpecialValueFor("pierce_count")
	self.pierce_damage = self:GetAbility():GetSpecialValueFor("pierce_damage")
end

-- Declare modifier events/properties
function modifier_item_imba_javelin_unique:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_javelin_unique:GetModifierAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() then
		return 0
	else
		return self.bonus_range
	end
end

function modifier_item_imba_javelin_unique:OnAttackLanded(keys)
	if IsServer() then
		local owner = self:GetParent()

		-- If this attack was not performed by the modifier's owner, do nothing
		if owner ~= keys.attacker then
			return end

		-- If this is an illusion, do nothing
		if owner:IsIllusion() then
			return end

		-- Else, keep going
		local target = keys.target

		-- If the target is a hero or creep, increase this modifier's stack count
		if target:IsHeroOrCreep() then -- and owner:GetTeam() ~= target:GetTeam() then
			self:SetStackCount(self:GetStackCount() + 1)

			-- If this is the appropriate amount of stacks, deal bonus damage
			if self:GetStackCount() >= self.pierce_count then
				ApplyDamage({attacker = owner, victim = target, ability = self:GetAbility(), damage = self.pierce_damage, damage_type = DAMAGE_TYPE_MAGICAL})
				self:SetStackCount(0)
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Monkey King Bar definition
-----------------------------------------------------------------------------------------------------------

if item_imba_monkey_king_bar == nil then item_imba_monkey_king_bar = class({}) end
LinkLuaModifier( "modifier_item_imba_monkey_king_bar", "components/items/item_mkb.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_monkey_king_bar_unique", "components/items/item_mkb.lua", LUA_MODIFIER_MOTION_NONE )	-- Pulverize and bonus attack range

function item_imba_monkey_king_bar:GetIntrinsicModifierName()
	return "modifier_item_imba_monkey_king_bar" end

function item_imba_monkey_king_bar:GetAbilityTextureName()
	return "custom/imba_monkey_king_bar"
end

-----------------------------------------------------------------------------------------------------------
--	Monkey King Bar owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_monkey_king_bar == nil then modifier_item_imba_monkey_king_bar = class({}) end
function modifier_item_imba_monkey_king_bar:IsHidden() return true end
function modifier_item_imba_monkey_king_bar:IsDebuff() return false end
function modifier_item_imba_monkey_king_bar:IsPurgable() return false end
function modifier_item_imba_monkey_king_bar:IsPermanent() return true end
function modifier_item_imba_monkey_king_bar:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the unique modifier to the caster when created
function modifier_item_imba_monkey_king_bar:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_monkey_king_bar_unique") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_imba_monkey_king_bar_unique", {})
		end
	end
end

-- Removes the unique modifier from the caster if this is the last MKB in its inventory
function modifier_item_imba_monkey_king_bar:OnDestroy(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_monkey_king_bar") then
			parent:RemoveModifierByName("modifier_item_imba_monkey_king_bar_unique")
		end
	end
end

-- Declare modifier events/properties
function modifier_item_imba_monkey_king_bar:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function modifier_item_imba_monkey_king_bar:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage") end

-----------------------------------------------------------------------------------------------------------
--	Monkey King Bar unique passive (Pulverize + True Strike + melee range increase)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_monkey_king_bar_unique == nil then modifier_item_imba_monkey_king_bar_unique = class({}) end
function modifier_item_imba_monkey_king_bar_unique:IsHidden() return true end
function modifier_item_imba_monkey_king_bar_unique:IsDebuff() return false end
function modifier_item_imba_monkey_king_bar_unique:IsPurgable() return false end
function modifier_item_imba_monkey_king_bar_unique:IsPermanent() return true end

-- Store ability keys for later
function modifier_item_imba_monkey_king_bar_unique:OnCreated()
	self.bonus_range = self:GetAbility():GetSpecialValueFor("bonus_range")
	self.pulverize_count = self:GetAbility():GetSpecialValueFor("pulverize_count")
	self.pulverize_damage = self:GetAbility():GetSpecialValueFor("pulverize_damage")
	self.pulverize_stun = self:GetAbility():GetSpecialValueFor("pulverize_stun")
end

-- Declare modifier states
function modifier_item_imba_monkey_king_bar_unique:CheckState()
	local states = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}
	return states
end

-- Declare modifier events/properties
function modifier_item_imba_monkey_king_bar_unique:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_monkey_king_bar_unique:GetModifierAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() then
		return 0
	else
		return self.bonus_range
	end
end

function modifier_item_imba_monkey_king_bar_unique:OnAttackLanded(keys)
	if IsServer() then
		local owner = self:GetParent()
		local target = keys.target

		-- If this attack was not performed by the modifier's owner, do nothing
		if owner ~= keys.attacker then
			return end

		-- If this is an illusion, do nothing
		if owner:IsIllusion() then
			return
		end

		-- If the target is a hero or creep, increase this modifier's stack count
		if target:IsHeroOrCreep() then -- and owner:GetTeam() ~= target:GetTeam() then
			self:SetStackCount(self:GetStackCount() + 1)

			-- If this is the appropriate amount of stacks, pulverize the target
			if self:GetStackCount() >= self.pulverize_count then

				-- Reset stack amount
				self:SetStackCount(0)

				-- Play sound
				target:EmitSound("DOTA_Item.MKB.Minibash")

				-- If the target is magic immune, do nothing - effect is wasted
				if target:IsMagicImmune() then
					return nil
				end

				-- Mini-bash
				target:AddNewModifier(owner, self:GetAbility(), "modifier_stunned", {duration = self.pulverize_stun})

				-- Deal damage
				ApplyDamage({attacker = owner, victim = target, ability = self:GetAbility(), damage = self.pulverize_damage, damage_type = DAMAGE_TYPE_MAGICAL})
			end
		end
	end
end
