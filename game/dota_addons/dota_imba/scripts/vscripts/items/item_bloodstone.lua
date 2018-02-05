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

--[[	Author: d2imba
		Date:	22.06.2015	]]

function Suicide( keys )
	local caster = keys.caster
	local item = keys.ability

	if caster:HasModifier("modifier_imba_reincarnation") then
		caster:Kill(item, caster)
	else
		TrueKill(caster, caster, item)
	end
end

function UpdateCharges( keys )
	local caster = keys.caster
	local item = keys.ability
	local charges_modifier = keys.charges_modifier

	-- Parameters
	local respawn_time_reduction = item:GetLevelSpecialValueFor("respawn_time_reduction", item:GetLevel() - 1)
	local current_charges = item:GetCurrentCharges()

	item:ApplyDataDrivenModifier(caster, caster, charges_modifier, {})
	caster:SetModifierStackCount(charges_modifier, caster, current_charges)

	-- Reduce respawn timer
	caster.bloodstone_respawn_reduction = current_charges * respawn_time_reduction
end

function GainChargesOnKill( keys )
	local caster = keys.caster
	local item = keys.ability
	local item_level = item:GetLevel() - 1
	local target = keys.target
	local assist_modifier = keys.assist_modifier

	-- Parameters
	local current_charges = item:GetCurrentCharges()

	if target:GetTeam() ~= caster:GetTeam() and not target:HasModifier(assist_modifier) and not target:IsIllusion() and not target:HasModifier("modifier_arc_warden_tempest_double") then
		item:SetCurrentCharges( current_charges + 1 )
	end
end

function GainChargesOnAssist( keys )
	local target = keys.unit
	local item = keys.ability
	local item_level = item:GetLevel() - 1

	-- Parameters
	local current_charges = item:GetCurrentCharges()

	if ( not target:IsIllusion() ) and not target:HasModifier("modifier_arc_warden_tempest_double") then
		item:SetCurrentCharges( current_charges + 1 )
	end
end

function LoseCharges( keys )
	local caster = keys.caster
	local item = keys.ability
	local item_level = item:GetLevel() - 1

	-- If this is not a real hero, do nothing
	if caster:HasModifier("modifier_arc_warden_tempest_double") or ( not caster:IsRealHero() ) then
		return nil
	end

	-- If caster will reincarnate, do nothing
	if caster:WillReincarnate() then
		return nil
	end

	-- Parameters
	local on_death_charge_loss = item:GetLevelSpecialValueFor("on_death_loss", item_level)
	local effect_radius = item:GetLevelSpecialValueFor("effect_radius", item_level)
	local heal_on_death_base = item:GetLevelSpecialValueFor("heal_on_death_base", item_level)
	local heal_on_death_per_charge = item:GetLevelSpecialValueFor("heal_on_death_per_charge", item_level)

	-- Calculations
	local current_charges = item:GetCurrentCharges()
	local total_heal = heal_on_death_base + current_charges * heal_on_death_per_charge

	-- Lose charges
	item:SetCurrentCharges( math.floor(current_charges * on_death_charge_loss) )

	-- Heal nearby allies
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, effect_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for _,ally in pairs(allies) do
		ally:Heal(total_heal, caster)
	end
end

function RespawnTimeReset( keys )
	local caster = keys.caster

	caster.bloodstone_respawn_reduction = nil
end
