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
		Date:	14.11.2016	]]

function InitiateRobeThink( keys )
	local caster = keys.caster

	-- If a higher-level version of the ability is present, do nothing
	if caster:HasModifier("modifier_item_imba_arcane_nexus_unique") then
		return nil
	end

	-- Parameters
	local ability = keys.ability
	local modifier_stacks = keys.modifier_stacks
	local particle_shield = keys.particle_shield
	local mana_conversion_rate = ability:GetSpecialValueFor("mana_conversion_rate") * 0.01
	local max_stacks = ability:GetSpecialValueFor("max_stacks")

	-- Create the global variables, if necessary
	if not caster.magic_shield_mana_count then
		caster.magic_shield_mana_count = caster:GetMana()
	end

	if not caster.magic_shield_int_count then
		caster.magic_shield_int_count = caster:GetIntellect()
	end

	-- Fetch current parameters
	local current_mana = caster:GetMana()
	local current_int = caster:GetIntellect()

	-- Adjust mana tracking variable based on intelligence
	if current_int < caster.magic_shield_int_count then
		local int_loss = (caster.magic_shield_int_count - current_int)
		caster.magic_shield_mana_count = caster.magic_shield_mana_count - 12 * int_loss
	end

	-- Update intelligence count
	caster.magic_shield_int_count = current_int

	-- If mana was spent or lost, grant magic shield stacks
	if current_mana < caster.magic_shield_mana_count then

		-- Calculate magic shield stacks to gain
		local stacks_to_gain = ( caster.magic_shield_mana_count - current_mana ) * mana_conversion_rate

		-- Update mana tracking variable
		caster.magic_shield_mana_count = current_mana

		-- Fetch current amount of shield stacks
		local current_stacks = caster:GetModifierStackCount(modifier_stacks, caster)

		-- Add the appropriate amount of shield stacks
		AddStacks(ability, caster, caster, modifier_stacks, math.min(stacks_to_gain, max_stacks - current_stacks), true)

		-- Play the mana shield particle
		local shield_pfx = ParticleManager:CreateParticle(particle_shield, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(shield_pfx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(shield_pfx)

		-- Else, update the mana tracking variable
	else
		caster.magic_shield_mana_count = current_mana
	end
end

function InitiateRobeEnd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_stacks = keys.modifier_stacks

	-- Clear global variables
	caster.magic_shield_mana_count = nil
	caster.magic_shield_int_count = nil

	-- Remove magic shield stacks
	caster:RemoveModifierByName(modifier_stacks)
end
