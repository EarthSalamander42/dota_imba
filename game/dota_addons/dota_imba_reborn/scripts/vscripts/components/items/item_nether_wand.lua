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

--[[
		By: AtroCty
		Date: 17.05.2017
		Updated:  18.05.2017
	]]
-------------------------------------------
--			NETHER WAND
-------------------------------------------
LinkLuaModifier("modifier_imba_item_nether_wand_passive", "components/items/item_nether_wand.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_arcane_nexus_passive", "components/items/item_nether_wand.lua", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------

item_imba_nether_wand = item_imba_nether_wand or class({})

-------------------------------------------
function item_imba_nether_wand:GetIntrinsicModifierName()
	return "modifier_imba_item_nether_wand_passive"
end

function item_imba_nether_wand:GetAbilityTextureName()
	return "custom/imba_nether_wand"
end

-------------------------------------------
modifier_imba_item_nether_wand_passive = modifier_imba_item_nether_wand_passive or class({})

function modifier_imba_item_nether_wand_passive:IsHidden()		return true end
function modifier_imba_item_nether_wand_passive:IsPurgable()		return false end
function modifier_imba_item_nether_wand_passive:RemoveOnDeath()	return false end
function modifier_imba_item_nether_wand_passive:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_item_nether_wand_passive:OnDestroy()
	self:CheckUnique(false)
end

function modifier_imba_item_nether_wand_passive:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and self.item then
		self.spell_amp = self.item:GetSpecialValueFor("spell_amp")
	end
	
	if not IsServer() then return end
	
    -- Use Secondary Charges system to make mana loss reduction and CDR not stack with multiples
    for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
        mod:GetAbility():SetSecondaryCharges(_)
    end
end

function modifier_imba_item_nether_wand_passive:OnDestroy()
	if not IsServer() then return end
	
    for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
        mod:GetAbility():SetSecondaryCharges(_)
    end
end

function modifier_imba_item_nether_wand_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
end

-- As of 7.23, the items that Nether Wand's tree contains are as follows:
--   - Nether Wand
--   - Aether Lens
--   - Aether Specs
--   - Eul's Scepter of Divinity EX
--   - Armlet of Dementor
--   - Arcane Nexus
function modifier_imba_item_nether_wand_passive:GetModifierSpellAmplify_Percentage()
    if self:GetAbility():GetSecondaryCharges() == 1 and 
	not self:GetParent():HasModifier("modifier_imba_aether_lens_passive") and 
	not self:GetParent():HasModifier("modifier_item_imba_aether_specs") and 
	not self:GetParent():HasModifier("modifier_item_imba_cyclone_2") and 
	not self:GetParent():HasModifier("modifier_item_imba_armlet_of_dementor") and
	not self:GetParent():HasModifier("modifier_item_imba_arcane_nexus_passive") then
        return self.spell_amp
    end
end

-------------------------------------------
--			ARCANE NEXUS
-------------------------------------------
item_imba_arcane_nexus = item_imba_arcane_nexus or class({})
-------------------------------------------
function item_imba_arcane_nexus:GetIntrinsicModifierName()
	return "modifier_item_imba_arcane_nexus_passive"
end

LinkLuaModifier( "modifier_item_imba_kaya_active", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable

function item_imba_arcane_nexus:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_kaya_active", {duration = self:GetSpecialValueFor("active_duration")})
		self:GetCaster():EmitSound("DOTA_Item.Pipe.Activate")
	end
end

-------------------------------------------

modifier_item_imba_arcane_nexus_passive = modifier_item_imba_arcane_nexus_passive or class({})

function modifier_item_imba_arcane_nexus_passive:IsHidden()		return true end
function modifier_item_imba_arcane_nexus_passive:IsPurgable()		return false end
function modifier_item_imba_arcane_nexus_passive:RemoveOnDeath()	return false end
function modifier_item_imba_arcane_nexus_passive:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_arcane_nexus_passive:OnDestroy()
	self:CheckUnique(false)
end

function modifier_item_imba_arcane_nexus_passive:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
    
	if not IsServer() then return end
	
    -- Use Secondary Charges system to make mana loss reduction and CDR not stack with multiples
    for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
        mod:GetAbility():SetSecondaryCharges(_)
    end
end

function modifier_item_imba_arcane_nexus_passive:OnDestroy()
	if not IsServer() then return end
	
    for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
        mod:GetAbility():SetSecondaryCharges(_)
    end
end

function modifier_item_imba_arcane_nexus_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
end


-- As of 7.23, the items that Nether Wand's tree contains are as follows:
--   - Nether Wand
--   - Aether Lens
--   - Aether Specs
--   - Eul's Scepter of Divinity EX
--   - Armlet of Dementor
--   - Arcane Nexus
function modifier_item_imba_arcane_nexus_passive:GetModifierSpellAmplify_PercentageUnique()
    if self:GetAbility() and self:GetAbility():GetSecondaryCharges() == 1 then
        return self:GetAbility():GetSpecialValueFor("spell_amp")
    end
end

function modifier_item_imba_arcane_nexus_passive:GetModifierPreAttack_BonusDamage()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor("bonus_damage")
    end
end

function modifier_item_imba_arcane_nexus_passive:GetModifierAttackSpeedBonus_Constant()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor("bonus_as")
    end
end

function modifier_item_imba_arcane_nexus_passive:GetModifierBonusStats_Intellect()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor("bonus_intellect")
    end
end

function modifier_item_imba_arcane_nexus_passive:GetModifierPercentageCooldown()
	if self:GetAbility() and self:GetAbility():GetSecondaryCharges() == 1 and not self:GetParent():HasModifier("modifier_imba_octarine_core_unique") then
		return self:GetAbility():GetSpecialValueFor("bonus_cdr")
	end
end

function modifier_item_imba_arcane_nexus_passive:GetModifierPercentageManacost()
	if self:GetAbility() and self:GetAbility():GetSecondaryCharges() == 1 then
		 return self:GetAbility():GetSpecialValueFor("bonus_cdr")
	end
end
