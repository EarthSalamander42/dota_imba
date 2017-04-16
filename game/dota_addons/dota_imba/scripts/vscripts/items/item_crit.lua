--	Author: Firetoad
--	Date: 			21.07.2016
--	Last Update:	21.03.2017

-----------------------------------------------------------------------------------------------------------
--	Daedalus definition
-----------------------------------------------------------------------------------------------------------

if item_imba_greater_crit == nil then item_imba_greater_crit = class({}) end
LinkLuaModifier( "modifier_item_imba_greater_crit", "items/item_crit.lua", LUA_MODIFIER_MOTION_NONE )		-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_greater_crit_buff", "items/item_crit.lua", LUA_MODIFIER_MOTION_NONE )	-- Critical damage increase counter

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
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_greater_crit_buff") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_imba_greater_crit_buff", {})
		end
	end
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
	local decFuncs = {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE}

	return decFuncs
end

function modifier_item_imba_greater_crit_buff:GetModifierPreAttack_CriticalStrike()	
	if IsServer() then
		-- Find how many Daedaluses we have for calculating crits
		local crit_modifiers = self.caster:FindAllModifiersByName("modifier_item_imba_greater_crit")

		-- Get current power		
		local stacks = self:GetStackCount()
		local crit_power = self.base_crit + self.crit_increase/self.crit_increase * stacks 
		
		local crit_succeeded = false		
		local multiplicative_chance = (1 - (1 - self.crit_chance * 0.01) ^ #crit_modifiers) * 100

		if RollPercentage(multiplicative_chance) then
			self:SetStackCount(0)			
			crit_succeeded = true
		end		

		if crit_succeeded then
			return crit_power
		else
			self:SetStackCount(stacks + self.crit_increase * #crit_modifiers)
			return nil	
		end
	end
end
