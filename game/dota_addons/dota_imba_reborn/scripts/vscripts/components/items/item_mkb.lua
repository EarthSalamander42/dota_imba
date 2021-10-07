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
--	Last Update:	13.03.2019 (by AltiV)

-----------------------------------------------------------------------------------------------------------
--	Javelin definition
-----------------------------------------------------------------------------------------------------------

if item_imba_javelin == nil then item_imba_javelin = class({}) end
LinkLuaModifier( "modifier_item_imba_javelin", "components/items/item_mkb.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable

function item_imba_javelin:GetIntrinsicModifierName()
	-- Client/server way of checking for multiple items and only apply the effects of one without relying on extra modifiers
	
	-- ...Also wtf who puts logic in the GetIntrinsicModifierName function
	Timers:CreateTimer(FrameTime(), function()
		if not self:IsNull() then
			for _, modifier in pairs(self:GetParent():FindAllModifiersByName("modifier_item_imba_javelin")) do
				modifier:SetStackCount(_)
			end
		end
	end)
	
	return "modifier_item_imba_javelin"
end

-----------------------------------------------------------------------------------------------------------
--	Javelin owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_javelin == nil then modifier_item_imba_javelin = class({}) end

function modifier_item_imba_javelin:IsHidden()		return true end
function modifier_item_imba_javelin:IsPurgable()		return false end
function modifier_item_imba_javelin:RemoveOnDeath()	return false end
function modifier_item_imba_javelin:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_javelin:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.ability	= self:GetAbility()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.bonus_damage			= self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_range			= self.ability:GetSpecialValueFor("bonus_range")
	self.bonus_chance			= self.ability:GetSpecialValueFor("bonus_chance")
	self.bonus_chance_damage	= self.ability:GetSpecialValueFor("bonus_chance_damage")
	
	-- Tracking when to give the true strike + bonus magical damage
	self.pierce_proc 			= false
	self.pierce_records			= {}
end

function modifier_item_imba_javelin:OnDestroy()
	if not IsServer() then return end
	
	for _, modifier in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
		modifier:SetStackCount(_)
	end
end

-- Declare modifier events/properties
function modifier_item_imba_javelin:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_EVENT_ON_ATTACK_RECORD
	}
end

function modifier_item_imba_javelin:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_imba_javelin:GetModifierAttackRangeBonus()
	if not self.parent:IsRangedAttacker() and self:GetStackCount() == 1 and 
	not self:GetParent():HasItemInInventory("item_imba_maelstrom") and 
	not self:GetParent():HasItemInInventory("item_imba_mjollnir") and 
	not self:GetParent():HasItemInInventory("item_imba_jarnbjorn") and 
	not self:GetParent():HasItemInInventory("item_imba_monkey_king_bar") then
		return self.bonus_range
	end
end

-- Once again with the jank logic to simulate percentage chance of no-miss + bonus magic damage on an attack
function modifier_item_imba_javelin:GetModifierProcAttack_BonusDamage_Magical(keys)
	for _, record in pairs(self.pierce_records) do	
		if record == keys.record then
			table.remove(self.pierce_records, _)

			if not self.parent:IsIllusion() and not keys.target:IsBuilding() then
				self.parent:EmitSound("DOTA_Item.MKB.proc")
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self.bonus_chance_damage, nil)
				
				return self.bonus_chance_damage
			end
		end
	end
end

function modifier_item_imba_javelin:OnAttackRecord(keys)
	if keys.attacker == self.parent then
		if self.pierce_proc then
			table.insert(self.pierce_records, keys.record)
			self.pierce_proc = false
		end
	
		if (not keys.target:IsMagicImmune() or self:GetName() == "modifier_item_imba_monkey_king_bar") and RollPseudoRandom(self.bonus_chance, self) then
			self.pierce_proc = true
		end
	end
end

-- Accuracy is actually determined before OnAttackStart is even called so procs are kinda shifted by one attack
function modifier_item_imba_javelin:CheckState()
	local state = {}
	
	if self.pierce_proc then
		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
	end

	return state
end

-----------------------------------------------------------------------------------------------------------
--	Monkey King Bar definition
-----------------------------------------------------------------------------------------------------------

if item_imba_monkey_king_bar == nil then item_imba_monkey_king_bar = class({}) end
LinkLuaModifier( "modifier_item_imba_monkey_king_bar", "components/items/item_mkb.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable

function item_imba_monkey_king_bar:GetIntrinsicModifierName()	
	return "modifier_item_imba_monkey_king_bar"
end

-----------------------------------------------------------------------------------------------------------
--	Monkey King Bar owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

modifier_item_imba_monkey_king_bar = modifier_item_imba_javelin

function modifier_item_imba_monkey_king_bar:IsHidden()		return true end
function modifier_item_imba_monkey_king_bar:IsPurgable()		return false end
function modifier_item_imba_monkey_king_bar:RemoveOnDeath()	return false end
function modifier_item_imba_monkey_king_bar:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_monkey_king_bar:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.ability	= self:GetAbility()
	self.parent		= self:GetParent()
	
	if not self.ability then return end
	
	-- AbilitySpecials
	self.bonus_damage			= self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_range			= self.ability:GetSpecialValueFor("bonus_range")
	self.bonus_chance			= self.ability:GetSpecialValueFor("bonus_chance")
	self.bonus_chance_damage	= self.ability:GetSpecialValueFor("bonus_chance_damage")
	self.bonus_attack_speed		= self.ability:GetSpecialValueFor("bonus_attack_speed")
	
	-- Tracking when to give the true strike + bonus magical damage
	self.pierce_proc 			= true
	self.pierce_records			= {}
	
	if not IsServer() then return end
	
    -- Use Secondary Charges system to make attack range not stack with multiple of the same item
    for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
        mod:GetAbility():SetSecondaryCharges(_)
    end
end

function modifier_item_imba_monkey_king_bar:OnDestroy()
    if not IsServer() then return end
    
    for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
        mod:GetAbility():SetSecondaryCharges(_)
    end
end

function modifier_item_imba_monkey_king_bar:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,

		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_EVENT_ON_ATTACK_RECORD
	}
end

function modifier_item_imba_monkey_king_bar:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_imba_monkey_king_bar:GetModifierAttackRangeBonus()
	if not self:GetParent():IsRangedAttacker() and self:GetAbility():GetSecondaryCharges() == 1 then
		return self.bonus_range
	end
end

-- MKB Pierces do not stack
function modifier_item_imba_monkey_king_bar:GetModifierProcAttack_BonusDamage_Magical(keys)
	if not IsServer() then return end

	for _, record in pairs(self.pierce_records) do	
		if record == keys.record then
			table.remove(self.pierce_records, _)

			if not self.parent:IsIllusion() and self:GetAbility():GetSecondaryCharges() == 1 and not keys.target:IsBuilding() then
				-- self.parent:EmitSound("DOTA_Item.MKB.proc")
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self.bonus_chance_damage, nil)
				
				return self.bonus_chance_damage
			end
		end
	end
end

function modifier_item_imba_monkey_king_bar:OnAttackRecord(keys)
	if keys.attacker == self.parent then
		if self.pierce_proc then
			table.insert(self.pierce_records, keys.record)
			self.pierce_proc = false
		end
	
		if RollPseudoRandom(self.bonus_chance, self) then
			self.pierce_proc = true
		end
	end
end
