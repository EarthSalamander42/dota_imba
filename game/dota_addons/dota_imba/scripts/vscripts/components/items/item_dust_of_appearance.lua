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

--[[	Author: zimberzimber
		Date:	7.2.2017	]]

LinkLuaModifier( "modifier_imba_dust_of_appearance", "components/items/item_dust_of_appearance.lua", LUA_MODIFIER_MOTION_NONE )	-- Dust reveal condition
-----------------------------------------------------------------------------------------------------------
--	Item Definition
-----------------------------------------------------------------------------------------------------------

if item_imba_dust_of_appearance == nil then item_imba_dust_of_appearance = class({}) end
function item_imba_dust_of_appearance:GetBehavior() return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET end

function item_imba_dust_of_appearance:GetAbilityTextureName()
	return "custom/imba_dust_of_appearance"
end

function item_imba_dust_of_appearance:OnSpellStart()
	local caster = 		self:GetCaster()
	local aoe = 		self:GetSpecialValueFor("area_of_effect")
	local duration =	self:GetSpecialValueFor("reveal_duration")
	local foundInvis =	0	-- 0% chance if no invis units are found

	caster:EmitSound("DOTA_Item.DustOfAppearance.Activate")
	local particle = ParticleManager:CreateParticle("particles/items_fx/dust_of_appearance.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 1, Vector(aoe, aoe, aoe))

	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER , false)
	for _,unit in pairs(targets) do
		if unit:IsImbaInvisible() then foundInvis = foundInvis + 1 end
		unit:AddNewModifier(caster, self, "modifier_imba_dust_of_appearance", {duration = duration})
	end

	local chance = self:GetSpecialValueFor("meme_chance") * foundInvis
	if RollPercentage(chance) then caster:EmitSound("Imba.DustMGS") end
	-- Consume charge if we didn't find any invis units, so no spammy-spammy
	if foundInvis == 0 then
		local new_charge_count = self:GetCurrentCharges() - 1
		if new_charge_count == 0 then
			self:Destroy()
		else
			self:SetCurrentCharges(new_charge_count)
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Reveal modifier
-----------------------------------------------------------------------------------------------------------

if modifier_imba_dust_of_appearance == nil then modifier_imba_dust_of_appearance = class({}) end
function modifier_imba_dust_of_appearance:IsDebuff() return true end
function modifier_imba_dust_of_appearance:IsHidden() return false end
function modifier_imba_dust_of_appearance:IsPurgable() return true end

function modifier_imba_dust_of_appearance:DeclareFunctions()
	local decFuncs = {	MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,	}
	return decFuncs
end

function modifier_imba_dust_of_appearance:GetEffectName()
	return "particles/items2_fx/true_sight_debuff.vpcf" end

function modifier_imba_dust_of_appearance:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_dust_of_appearance:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_imba_dust_of_appearance:CheckState()
	if self:GetParent():HasModifier("modifier_slark_shadow_dance") then
		return nil
	end

	return {[MODIFIER_STATE_INVISIBLE] = false,}
end

function modifier_imba_dust_of_appearance:GetModifierProvidesFOWVision()
	local parent = self:GetParent()

	if not parent:IsHero() then return 0 end

	local invisModifiers = {
		"modifier_invisible",
		"modifier_mirana_moonlight_shadow",
		"modifier_item_imba_shadow_blade_invis",
		"modifier_item_shadow_amulet_fade",
		"modifier_imba_vendetta",
		"modifier_nyx_assassin_burrow",
		"modifier_item_imba_silver_edge_invis",
		"modifier_item_glimmer_cape_fade",
		"modifier_weaver_shukuchi",
		"modifier_treant_natures_guise_invis",
		"modifier_templar_assassin_meld",
		"modifier_imba_skeleton_walk_dummy",
		"modifier_invoker_ghost_walk_self",
		"modifier_rune_invis",
		"modifier_item_imba_silver_edge_invis"
	}

	for _,v in ipairs(invisModifiers) do
		if parent:HasModifier(v) then return 1 end
	end
	return 0
end

function modifier_imba_dust_of_appearance:GetModifierMoveSpeedBonus_Percentage()
	local parent = self:GetParent()
	local ability = self:GetAbility()

	local slow = 0
	local invisModifiers = {
		"modifier_invisible",
		"modifier_mirana_moonlight_shadow",
		"modifier_item_imba_shadow_blade_invis",
		"modifier_item_shadow_amulet_fade",
		"modifier_imba_vendetta",
		"modifier_nyx_assassin_burrow",
		"modifier_item_imba_silver_edge_invis",
		"modifier_item_glimmer_cape_fade",
		"modifier_weaver_shukuchi",
		"modifier_treant_natures_guise_invis",
		"modifier_templar_assassin_meld",
		"modifier_imba_skeleton_walk_dummy",
		"modifier_invoker_ghost_walk_self",
		"modifier_rune_invis",
		"modifier_item_imba_silver_edge_invis"
	}

	for _,v in ipairs(invisModifiers) do
		if parent:HasModifier(v) then slow = ability:GetSpecialValueFor("invisible_slow") end
	end

	return slow
end
