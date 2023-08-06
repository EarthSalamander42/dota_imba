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

item_imba_initiate_robe = item_imba_initiate_robe or class({})

-------------------------------------------

function item_imba_initiate_robe:GetIntrinsicModifierName()
	return "modifier_imba_initiate_robe_passive"
end

function item_imba_initiate_robe:GetAbilityTextureName()
	return "imba_initiate_robe"
end

modifier_imba_initiate_robe_passive = modifier_imba_initiate_robe_passive or class({})

function modifier_imba_initiate_robe_passive:IsPurgable()		return false end
function modifier_imba_initiate_robe_passive:RemoveOnDeath()	return false end
function modifier_imba_initiate_robe_passive:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_initiate_robe_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end

function modifier_imba_initiate_robe_passive:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if IsServer() then 
		local item = self:GetAbility()
		self.parent = self:GetParent()
		if self.parent:IsHero() and item then
			self.shield_pfx = nil
			self:CheckUnique(true)

			-- Start tracking mana percentages and mana values to determine if mana was lost
			self.mana_pct = self:GetParent():GetManaPercent()
			self.mana_raw = self:GetParent():GetMana()

			self:StartIntervalThink(0.03)
		end
	end
end

function modifier_imba_initiate_robe_passive:OnIntervalThink()
	local ability = self:GetAbility()
	if not self.parent or self.parent:IsNull() or not ability or ability:IsNull() then
		return
	end

	-- If mana percentage at any frame is lower than the frame before it, set stacks
	if self.parent:GetManaPercent() < self.mana_pct and self.parent:GetMana() < self.mana_raw then
		self:SetStackCount(math.min(self:GetStackCount() + (self.mana_raw - self.parent:GetMana()) * (ability:GetSpecialValueFor("mana_conversion_rate") * 0.01), ability:GetSpecialValueFor("max_stacks")))
	end

	self.mana_raw = self.parent:GetMana()
	self.mana_pct = self.parent:GetManaPercent()
end

function modifier_imba_initiate_robe_passive:GetModifierHealthBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health")
	end
end

function modifier_imba_initiate_robe_passive:GetModifierManaBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_mana")
	end
end

function modifier_imba_initiate_robe_passive:GetModifierConstantManaRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("mana_regen")
	end
end

function modifier_imba_initiate_robe_passive:GetModifierMagicalResistanceBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("magic_resist")
	end
end

function modifier_imba_initiate_robe_passive:GetModifierTotal_ConstantBlock(keys)
	local blocked = self:GetStackCount()
	
	-- Block for the smaller value between total current stacks and total damage
	if blocked > 0 and keys.damage > 0 then
		blocked = math.min(blocked, keys.damage)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, self:GetParent(), blocked, nil)
		self:SetStackCount(math.max(self:GetStackCount() - keys.damage, 0))
	end

	return blocked
end
