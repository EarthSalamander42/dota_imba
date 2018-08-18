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
function modifier_imba_initiate_robe_passive:IsDebuff() return false end
function modifier_imba_initiate_robe_passive:IsHidden() return false end
function modifier_imba_initiate_robe_passive:IsPermanent() return true end
function modifier_imba_initiate_robe_passive:IsPurgable() return false end
function modifier_imba_initiate_robe_passive:IsPurgeException() return false end
function modifier_imba_initiate_robe_passive:IsStunDebuff() return false end
function modifier_imba_initiate_robe_passive:RemoveOnDeath() return false end
function modifier_imba_initiate_robe_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_initiate_robe_passive:DeclareFunctions()
	local decFuns = {
		MODIFIER_EVENT_ON_SPENT_MANA,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}	

	return decFuns
end

function modifier_imba_initiate_robe_passive:OnCreated()
	local item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and item then
		self.bonus_mana_regen = item:GetSpecialValueFor("mana_regen")
		self.bonus_magic_resistance = item:GetSpecialValueFor("magic_resist")
		self.mana_conversion_rate = item:GetSpecialValueFor("mana_conversion_rate")
		self.max_stacks = item:GetSpecialValueFor("max_stacks")
		self.shield_pfx = nil
		self:CheckUnique(true)
	end
end


function modifier_imba_initiate_robe_passive:OnSpentMana(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then 
			local stacks = self:GetStackCount()
			stacks = stacks + keys.cost
			if stacks > self.max_stacks then
				stacks = self.max_stacks
			end

			local parent = self:GetParent()	
			-- Play the mana shield particle
			self.shield_pfx = ParticleManager:CreateParticle("particles/item/initiate_robe/initiate_robe_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
			ParticleManager:SetParticleControl(self.shield_pfx, 0, parent:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.shield_pfx)

			self:SetStackCount(stacks)
		end
	end
end

function modifier_imba_initiate_robe_passive:OnTakeDamage(keys)
	if IsServer() then 
		if self:GetParent() == keys.unit then
			local current_stacks = self:GetStackCount()
			if current_stacks > 0 then 
				if current_stacks > keys.damage then
					self:GetParent():Heal(keys.damage, self)
					self:SetStackCount(math.ceil(current_stacks - keys.damage))
					SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_MAGICAL_BLOCK , self:GetParent(), keys.damage, self:GetParent())
				else
					self:GetParent():Heal(current_stacks, self)
					self:SetStackCount(0)
					SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_MAGICAL_BLOCK , self:GetParent(), current_stacks, self:GetParent())
				end
			end
		end
	end
end

function modifier_imba_initiate_robe_passive:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_imba_initiate_robe_passive:GetModifierMagicalResistanceBonus()
	return self.bonus_magic_resistance
end
