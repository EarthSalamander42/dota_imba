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
		Date:	19.11.2016	]]

function AghanimsSynthCast( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_synth = keys.modifier_synth
	local modifier_stats = keys.modifier_stats
	local sound_cast = keys.sound_cast

	-- If the caster already has the synth buff, do nothing
	if caster:HasModifier(modifier_synth) or caster:HasModifier("modifier_arc_warden_tempest_double") then
		return nil
	end

	-- Otherwise, apply the synth buff and the stats buff
	caster:AddNewModifier(caster, nil, modifier_synth, {})
	ability:ApplyDataDrivenModifier(caster, caster, modifier_stats, {})

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Spend the item's only charge
	ability:SetCurrentCharges( ability:GetCurrentCharges() - 1 )
	caster:RemoveItem(ability)

	-- Create a regular scepter for one game frame to prevent regular dota interactions from going bad
	local dummy_scepter = CreateItem("item_ultimate_scepter", caster, caster)
	caster:AddItem(dummy_scepter)
	Timers:CreateTimer(0.01, function()
		caster:RemoveItem(dummy_scepter)
	end)
end
