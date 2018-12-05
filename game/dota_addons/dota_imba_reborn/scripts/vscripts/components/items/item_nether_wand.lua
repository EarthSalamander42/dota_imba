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
function modifier_imba_item_nether_wand_passive:IsDebuff() return false end
function modifier_imba_item_nether_wand_passive:IsHidden() return true end
function modifier_imba_item_nether_wand_passive:IsPermanent() return true end
function modifier_imba_item_nether_wand_passive:IsPurgable() return false end
function modifier_imba_item_nether_wand_passive:IsPurgeException() return false end
function modifier_imba_item_nether_wand_passive:IsStunDebuff() return false end
function modifier_imba_item_nether_wand_passive:RemoveOnDeath() return false end
function modifier_imba_item_nether_wand_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_item_nether_wand_passive:OnDestroy()
	self:CheckUnique(false)
end

function modifier_imba_item_nether_wand_passive:OnCreated()
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and self.item then
		self.spell_amp = self.item:GetSpecialValueFor("spell_amp")
	end
end

function modifier_imba_item_nether_wand_passive:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		}
	return decFuns
end

function modifier_imba_item_nether_wand_passive:GetModifierSpellAmplify_Percentage()
	return self.spell_amp
end

-------------------------------------------
--			ELDER STAFF
-------------------------------------------
item_imba_arcane_nexus = item_imba_arcane_nexus or class({})
-------------------------------------------
function item_imba_arcane_nexus:GetIntrinsicModifierName()
	return "modifier_item_imba_arcane_nexus_passive"
end

LinkLuaModifier( "modifier_item_imba_kaya_active", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable

function item_imba_arcane_nexus:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_kaya_active", {duration=self:GetSpecialValueFor("active_duration")})
		self:GetCaster():EmitSound("DOTA_Item.Pipe.Activate")
	end
end

-------------------------------------------

modifier_item_imba_arcane_nexus_passive = modifier_item_imba_arcane_nexus_passive or class({})
function modifier_item_imba_arcane_nexus_passive:IsDebuff() return false end
function modifier_item_imba_arcane_nexus_passive:IsHidden() return true end
function modifier_item_imba_arcane_nexus_passive:IsPermanent() return true end
function modifier_item_imba_arcane_nexus_passive:IsPurgable() return false end
function modifier_item_imba_arcane_nexus_passive:IsPurgeException() return false end
function modifier_item_imba_arcane_nexus_passive:IsStunDebuff() return false end
function modifier_item_imba_arcane_nexus_passive:RemoveOnDeath() return false end
function modifier_item_imba_arcane_nexus_passive:OnDestroy()
	self:CheckUnique(false)
end

function modifier_item_imba_arcane_nexus_passive:OnCreated()
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and self.item then
		self.bonus_damage = self.item:GetSpecialValueFor("bonus_damage")
		self.bonus_as = self.item:GetSpecialValueFor("bonus_as")
		self.bonus_intellect = self.item:GetSpecialValueFor("bonus_intellect")
		self.cast_range_bonus = self.item:GetSpecialValueFor("cast_range_bonus")
		self.spell_amp = self.item:GetSpecialValueFor("spell_amp")
		self.burn_duration = self.item:GetSpecialValueFor("burn_duration")
		self.bonus_cdr = self.item:GetSpecialValueFor("bonus_cdr")
	end
end

function modifier_item_imba_arcane_nexus_passive:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
			MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		}
	return decFuns
end

function modifier_item_imba_arcane_nexus_passive:GetModifierSpellAmplify_Percentage()
	return self.spell_amp
end

function modifier_item_imba_arcane_nexus_passive:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_imba_arcane_nexus_passive:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_item_imba_arcane_nexus_passive:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_imba_arcane_nexus_passive:GetModifierPercentageCooldown()
	return self.bonus_cdr
end

function modifier_item_imba_arcane_nexus_passive:GetModifierPercentageManacost()
	return self.bonus_cdr
end
