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
		Date:	20.09.2015
		Last updated: 18.03.2017	]]

function Dagon( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sound_cast = keys.sound_cast
	local sound_hit = keys.sound_hit
	local particle_hit = "particles/item/dagon/dagon.vpcf"

	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- If the target is magic immune (Lotus Orb/Anti Mage), do nothing
	if target:IsMagicImmune() then
		return nil
	end

	-- Parameters
	local damage = ability:GetSpecialValueFor("damage")
	local bounce_damage = ability:GetSpecialValueFor("bounce_damage")
	local bounce_range = ability:GetSpecialValueFor("bounce_range")
	local targets_hit = {
		target
	}
	local search_sources = {
		target
	}

	-- Determine dagon color
	local dagon_colors = {}
	dagon_colors["item_imba_dagon_6"] = Vector(0.4, 0.0, 0.0)
	dagon_colors["item_imba_dagon_7"] = Vector(0.2, 0.0, 0.2)
	dagon_colors["item_imba_dagon_8"] = Vector(0.0, 0.15, 0.25)
	dagon_colors["item_imba_dagon_9"] = Vector(0.3, 0.3, 0.0)
	dagon_colors["item_imba_dagon_10"] = Vector(0.0, 0.4, 0.0)

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Play hit sound
	target:EmitSound(sound_hit)

	-- Dagonize the main target
	DagonizeIt(caster, ability, caster, target, damage, particle_hit, dagon_colors[ability:GetAbilityName()])

	-- While there are potential sources, keep looping
	while #search_sources > 0 do

		-- Loop through every potential source this iteration
		for potential_source_index, potential_source in pairs(search_sources) do

			-- Iterate through potential targets near this source
			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), potential_source:GetAbsOrigin(), nil, bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
			for _, potential_target in pairs(nearby_enemies) do

				-- Check if this target was already hit
				local already_hit = false
				for _, hit_target in pairs(targets_hit) do
					if potential_target == hit_target then
						already_hit = true
						break
					end
				end

				-- If not, dagonize it from this source, and mark it as a hit target and potential future source
				if not already_hit then
					DagonizeIt(caster, ability, potential_source, potential_target, bounce_damage, particle_hit, dagon_colors[ability:GetAbilityName()] + Vector(RandomFloat(0, 0.3), RandomFloat(0, 0.3), RandomFloat(0, 0.3)))
					targets_hit[#targets_hit+1] = potential_target
					search_sources[#search_sources+1] = potential_target
				end
			end

			-- Remove this potential source
			table.remove(search_sources, potential_source_index)
		end
	end
end

function DagonizeIt(caster, ability, source, target, damage, particle, color)

	-- Draw particle
	local dagon_pfx = ParticleManager:CreateParticle(particle, PATTACH_RENDERORIGIN_FOLLOW, source)
	ParticleManager:SetParticleControlEnt(dagon_pfx, 0, source, PATTACH_POINT_FOLLOW, "attach_attack1", source:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(dagon_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(dagon_pfx, 2, Vector(damage, 0, 0))
	ParticleManager:SetParticleControl(dagon_pfx, 3, color)
	ParticleManager:ReleaseParticleIndex(dagon_pfx)

	-- Deal damage to the target
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end
