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

--	Author: Rook
--	Date: 			26.01.2015		<-- Dinosaurs roamed the earth
--	Converted to lua by Firetoad
--	Last Update:	26.03.2017

-----------------------------------------------------------------------------------------------------------
--	Arcane Boots definition
-----------------------------------------------------------------------------------------------------------

if item_imba_arcane_boots == nil then item_imba_arcane_boots = class({}) end

LinkLuaModifier("modifier_item_imba_arcane_boots", "components/items/item_arcane_boots", LUA_MODIFIER_MOTION_NONE)   -- Owner's bonus attributes, stackable

function item_imba_arcane_boots:GetIntrinsicModifierName()
	return "modifier_item_imba_arcane_boots"
end

function item_imba_arcane_boots:OnAbilityPhaseStart()
	if self:GetCaster():IsClone() then
		return false
	end

	return true
end

function item_imba_arcane_boots:OnSpellStart()
	if IsServer() then
		-- Parameters
		local replenish_mana = self:GetSpecialValueFor("base_replenish_mana") + self:GetSpecialValueFor("replenish_mana_pct") * self:GetCaster():GetMaxMana() / 100
		local replenish_radius = self:GetSpecialValueFor("replenish_radius")

		-- Play activation sound and particle
		self:GetCaster():EmitSound("DOTA_Item.ArcaneBoots.Activate")
		local arcane_pfx = ParticleManager:CreateParticle("particles/items_fx/arcane_boots.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:ReleaseParticleIndex(arcane_pfx)

		-- Iterate through nearby allies
		local nearby_allies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, replenish_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MANA_ONLY, FIND_ANY_ORDER, false)
		for _, ally in pairs(nearby_allies) do
			-- Grant the ally mana
			ally:GiveMana(replenish_mana)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, ally, replenish_mana, nil)

			-- Play the "hit" particle
			local arcane_target_pfx = ParticleManager:CreateParticle("particles/items_fx/arcane_boots_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
			ParticleManager:ReleaseParticleIndex(arcane_target_pfx)
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Arcane Boots owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_arcane_boots == nil then modifier_item_imba_arcane_boots = class({}) end

function modifier_item_imba_arcane_boots:IsHidden() return true end

function modifier_item_imba_arcane_boots:IsPurgable() return false end

function modifier_item_imba_arcane_boots:RemoveOnDeath() return false end

function modifier_item_imba_arcane_boots:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Declare modifier events/properties
function modifier_item_imba_arcane_boots:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_MANA_BONUS,
	}
end

function modifier_item_imba_arcane_boots:GetModifierMoveSpeedBonus_Special_Boots()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_ms")
	end
end

function modifier_item_imba_arcane_boots:GetModifierManaBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_mana")
	end
end
