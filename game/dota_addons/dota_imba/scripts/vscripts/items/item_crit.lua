--	Author: Firetoad
--	Date: 			21.07.2016
--	Last Update:	21.03.2017

-----------------------------------------------------------------------------------------------------------
--	Daedalus definition
-----------------------------------------------------------------------------------------------------------

if item_imba_greater_crit == nil then item_imba_greater_crit = class({}) end
LinkLuaModifier( "modifier_item_imba_greater_crit", "items/item_crit.lua", LUA_MODIFIER_MOTION_NONE )		-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_greater_crit_buff", "items/item_crit.lua", LUA_MODIFIER_MOTION_NONE )	-- Critical damage increase counter
LinkLuaModifier( "modifier_item_imba_greater_crit_crit", "items/item_crit.lua", LUA_MODIFIER_MOTION_NONE )	-- Crit buff

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

-- Declare modifier events/properties
function modifier_item_imba_greater_crit:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_greater_crit:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage") end

-- Roll for crits on attack start
function modifier_item_imba_greater_crit:OnAttackStart(keys)
	if IsServer() then
		local owner = self:GetParent()

		-- If this unit is the attacker, roll for a crit
		if owner == keys.attacker then

			-- If the target is not a hero or creep, remove the crit modifier and do nothing else
			if not IsHeroOrCreep(keys.target) then
				owner:RemoveModifierByName("modifier_item_imba_greater_crit_crit")
				return
			end

			-- Roll for the actual crit
			if RollPercentage(self:GetAbility():GetSpecialValueFor("crit_chance")) then
				owner:AddNewModifier(owner, self:GetAbility(), "modifier_item_imba_greater_crit_crit", {duration = 1.0})
			end
		end
	end
end

-- On attack landed, remove the crit buff or increase the next crit's damage
function modifier_item_imba_greater_crit:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()

		-- If this attack was not performed by the modifier's owner, do nothing
		if owner ~= keys.attacker then
			return end

		-- If the owner has the crit modifier, remove it and reset buff stacks
		local modifier_crit_buff = owner:FindModifierByName("modifier_item_imba_greater_crit_buff")
		if owner:HasModifier("modifier_item_imba_greater_crit_crit") then
			owner:RemoveModifierByName("modifier_item_imba_greater_crit_crit")
			modifier_crit_buff:SetStackCount(0)
			keys.target:EmitSound("DOTA_Item.Daedelus.Crit")

		-- Else, increase the crit damage bonus
		else
			modifier_crit_buff:SetStackCount(modifier_crit_buff:GetStackCount() + self:GetAbility():GetSpecialValueFor("crit_increase"))
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

-----------------------------------------------------------------------------------------------------------
--	Daedalus crit buff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_greater_crit_crit == nil then modifier_item_imba_greater_crit_crit = class({}) end
function modifier_item_imba_greater_crit_crit:IsHidden() return true end
function modifier_item_imba_greater_crit_crit:IsDebuff() return false end
function modifier_item_imba_greater_crit_crit:IsPurgable() return false end

-- Track parameters to prevent errors if the item is unequipped
function modifier_item_imba_greater_crit_crit:OnCreated()
	if IsServer() then
		self.crit_damage = self:GetAbility():GetSpecialValueFor("base_crit") + self:GetParent():FindModifierByName("modifier_item_imba_greater_crit_buff"):GetStackCount()
	end
end

-- Declare modifier events/properties
function modifier_item_imba_greater_crit_crit:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
	return funcs
end

-- Grant the crit damage multiplier
function modifier_item_imba_greater_crit_crit:GetModifierPreAttack_CriticalStrike()
	if IsServer() then
		return self.crit_damage
	end
end