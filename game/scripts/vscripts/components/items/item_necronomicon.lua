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

--[[	Author: Firetoad
		Date: 06.01.2016

		Converted to Lua by EarthSalamander
		Date: 20.12.2020
--]]

LinkLuaModifier("modifier_item_imba_necronomicon", "components/items/item_necronomicon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_necronomicon_summon", "components/items/item_necronomicon.lua", LUA_MODIFIER_MOTION_NONE)

item_imba_necronomicon = item_imba_necronomicon or class({})
item_imba_necronomicon_2 = item_imba_necronomicon
item_imba_necronomicon_3 = item_imba_necronomicon
item_imba_necronomicon_4 = item_imba_necronomicon
item_imba_necronomicon_5 = item_imba_necronomicon

function item_imba_necronomicon:GetIntrinsicModifierName()
	return "modifier_item_imba_necronomicon"
end

function item_imba_necronomicon:OnSpellStart()
	if not IsServer() then return end

	-- Parameters
	local summon_duration = self:GetSpecialValueFor("summon_duration")
	local caster_loc = self:GetCaster():GetAbsOrigin()
	local caster_direction = self:GetCaster():GetForwardVector()
	local melee_summon_name = "npc_imba_necronomicon_warrior_"..self:GetLevel()
	local ranged_summon_name = "npc_imba_necronomicon_archer_"..self:GetLevel()

	-- Play cast sound
	self:GetCaster():EmitSound("DOTA_Item.Necronomicon.Activate")

	-- Calculate summon positions
	local melee_loc = RotatePosition(caster_loc, QAngle(0, 30, 0), caster_loc + caster_direction * 180)
	local ranged_loc = RotatePosition(caster_loc, QAngle(0, -30, 0), caster_loc + caster_direction * 180)

	-- Destroy trees
	GridNav:DestroyTreesAroundPoint(caster_loc + caster_direction * 180, 180, false)

	-- prints return valid arguments
	print(melee_summon_name, melee_loc)
	print(ranged_summon_name, ranged_loc)

	print("Crash happens between this")

	-- Spawn the summons
	local melee_summon = CreateUnitByName(melee_summon_name, melee_loc, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeam())
	local ranged_summon = CreateUnitByName(ranged_summon_name, ranged_loc, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeam())

	print("and this")

	-- Make the summons limited duration and controllable
	melee_summon:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	melee_summon:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = summon_duration})
	melee_summon:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_necronomicon_summon", {})

	ranged_summon:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	ranged_summon:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = summon_duration})
	ranged_summon:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_necronomicon_summon", {})

	-- Find summon abilities
	local melee_abilities = {
		"necronomicon_warrior_mana_burn",
		"necronomicon_warrior_last_will",
		"necronomicon_warrior_sight",
		"black_dragon_dragonhide_aura",
		"granite_golem_hp_aura",
		"spawnlord_aura"
	}
	local ranged_abilities = {
		"necronomicon_archer_purge",
		"necronomicon_archer_mana_burn",
		"necronomicon_archer_aoe",
		"forest_troll_high_priest_mana_aura",
		"big_thunder_lizard_wardrums_aura",
		"imba_necronomicon_archer_multishot",
		"imba_necronomicon_archer_spread_shot"
	}

	print("Test 4")

	-- Upgrade melee minion abilities
	for _, melee_ability in pairs(melee_abilities) do
		if melee_summon:FindAbilityByName(melee_ability) then
			if melee_summon:FindAbilityByName(melee_ability):GetMaxLevel() > 1 then
				melee_summon:FindAbilityByName(melee_ability):SetLevel(self:GetLevel())
			else
				melee_summon:FindAbilityByName(melee_ability):SetLevel(1)
			end
		end
	end

	-- Upgrade ranged minion abilities
	for _, ranged_ability in pairs(ranged_abilities) do
		if ranged_summon:FindAbilityByName(ranged_ability) then
			if ranged_summon:FindAbilityByName(ranged_ability):GetMaxLevel() > 1 then
				ranged_summon:FindAbilityByName(ranged_ability):SetLevel(self:GetLevel())
			else
				ranged_summon:FindAbilityByName(ranged_ability):SetLevel(1)
			end
		end
	end
end

modifier_item_imba_necronomicon = modifier_item_imba_necronomicon or class({})

function modifier_item_imba_necronomicon:IsHidden() return true end

function modifier_item_imba_necronomicon:DeclareFunctions() return {
	MODIFIER_PROPERTY_EXTRA_STRENGTH_BONUS,
	MODIFIER_PROPERTY_EXTRA_INTELLECT_BONUS,
} end

function modifier_item_imba_necronomicon:GetModifierExtraStrengthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_item_imba_necronomicon:GetModifierExtraIntellectBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

modifier_item_imba_necronomicon_summon = modifier_item_imba_necronomicon_summon or class({})

function modifier_item_imba_necronomicon_summon:IsHidden() return true end

function modifier_item_imba_necronomicon_summon:CheckState() return {
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
} end
