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
--	   Naowin, 18.08.2018
--	   AltiV, 19.08.2018

-- Author:  Firetoad
-- Date:	14.11.2016

-------------------------------------------
--				Initiate Robe
-------------------------------------------
LinkLuaModifier("modifier_imba_initiate_robe_passive", "components/items/item_initiate_robe.lua", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------
item_imba_initiate_robe = class({})
-------------------------------------------
function item_imba_initiate_robe:GetIntrinsicModifierName()
	return "modifier_imba_initiate_robe_passive"
end

function item_imba_initiate_robe:GetAbilityTextureName()
	return "custom/imba_initiate_robe"
end

modifier_imba_initiate_robe_passive = modifier_imba_initiate_robe_passive or class({})
function modifier_imba_initiate_robe_passive:IsDebuff() 		return false end
function modifier_imba_initiate_robe_passive:IsHidden() 		return false end
function modifier_imba_initiate_robe_passive:IsPermanent() 		return true end
function modifier_imba_initiate_robe_passive:IsPurgable() 		return false end
function modifier_imba_initiate_robe_passive:IsPurgeException() return false end
function modifier_imba_initiate_robe_passive:IsStunDebuff() 	return false end
function modifier_imba_initiate_robe_passive:RemoveOnDeath() 	return false end
function modifier_imba_initiate_robe_passive:GetAttributes() 	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_initiate_robe_passive:DeclareFunctions()
	local decFuns = {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}	

	return decFuns
end

function modifier_imba_initiate_robe_passive:OnCreated()
	if IsServer() then 
		local item = self:GetAbility()
		self.parent = self:GetParent()
		if self.parent:IsHero() and item then
			self.bonus_mana_regen = item:GetSpecialValueFor("mana_regen")
			self.bonus_magic_resistance = item:GetSpecialValueFor("magic_resist")
			self.mana_conversion_rate = item:GetSpecialValueFor("mana_conversion_rate")
			self.max_stacks = item:GetSpecialValueFor("max_stacks")
			self.shield_pfx = nil
			self:CheckUnique(true)
			
			-- Start tracking mana percentages and mana values to determine if mana was lost
			self.mana_pct = self:GetParent():GetManaPercent()
			self.mana_raw = self:GetParent():GetMana()
			
			self:StartIntervalThink(0.03)
		end
	else 
		self.bonus_magic_resistance = 20
		self.bonus_mana_regen = 1.0
	end
end

function modifier_imba_initiate_robe_passive:OnIntervalThink()
	if not IsServer() then return end
	
	-- If mana percentage at any frame is lower than the frame before it, set stacks
	if self.parent:GetManaPercent() < self.mana_pct and self:GetParent():GetMana() < self.mana_raw then
		self:SetStackCount(min(self:GetStackCount() + (self.mana_raw - self:GetParent():GetMana()) * (self.mana_conversion_rate * 0.01), self.max_stacks))
	end

	self.mana_raw = self:GetParent():GetMana()
	self.mana_pct = self:GetParent():GetManaPercent()
end

function modifier_imba_initiate_robe_passive:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_imba_initiate_robe_passive:GetModifierMagicalResistanceBonus()
	return self.bonus_magic_resistance
end

function modifier_imba_initiate_robe_passive:GetModifierTotal_ConstantBlock(keys)
	local blocked = self:GetStackCount()
	
	-- Block for the smaller value between total current stacks and total damage
	if blocked > 0 then 
		SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_MAGICAL_BLOCK , self:GetParent(), min(self:GetStackCount(), keys.damage), self:GetParent())
		self:SetStackCount(max(self:GetStackCount() - keys.damage, 0))
	end

	return blocked
end
