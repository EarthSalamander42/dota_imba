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
		Date:	09.05.2015	]]

function Mango( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast

	-- If there isn't a target, use on self
	if not target then
		target = caster
	end

	-- Parameters
	local minimum_mana = ability:GetLevelSpecialValueFor("minimum_mana", ability_level)
	local mana_percent = ability:GetLevelSpecialValueFor("mana_percent", ability_level)

	-- Calculate the mana to restore
	local mana_to_restore = target:GetMaxMana() * mana_percent / 100
	if mana_to_restore < minimum_mana then
		mana_to_restore = minimum_mana
	end

	-- Play sound
	target:EmitSound(sound_cast)

	-- Restore mana
	target:GiveMana(mana_to_restore)
end
