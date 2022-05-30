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
		Last updated: 18.03.2017
		Datadriven to Lua by EarthSalamander: 14/09/20
--]]

LinkLuaModifier("modifier_item_imba_dagon_passive", "components/items/item_dagon.lua", LUA_MODIFIER_MOTION_NONE)

item_imba_dagon = item_imba_dagon or class({})
item_imba_dagon_2 = item_imba_dagon
item_imba_dagon_3 = item_imba_dagon
item_imba_dagon_4 = item_imba_dagon
item_imba_dagon_5 = item_imba_dagon

function item_imba_dagon:GetIntrinsicModifierName()
	return "modifier_item_imba_dagon_passive"
end

local function DagonizeIt(caster, ability, source, target, damage)
	-- Draw particle
	local dagon_pfx = ParticleManager:CreateParticle("particles/item/dagon/dagon.vpcf", PATTACH_RENDERORIGIN_FOLLOW, source)
	ParticleManager:SetParticleControlEnt(dagon_pfx, 0, source, PATTACH_POINT_FOLLOW, "attach_attack1", source:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(dagon_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(dagon_pfx, 2, Vector(damage, 0, 0))
	ParticleManager:SetParticleControl(dagon_pfx, 3, Vector(0.3, 0, 0))
	ParticleManager:ReleaseParticleIndex(dagon_pfx)

	if target:IsAlive() then
		-- Deal damage to the target
		ApplyDamage({
			attacker = caster,
			victim = target,
			ability = ability,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL
		})
	end
end

function item_imba_dagon:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(self) then
			return nil
		end
	end

	-- If the target is magic immune (Lotus Orb/Anti Mage), do nothing
	if target:IsMagicImmune() then
		return nil
	end

	print("Target not immune")

	-- Parameters
	local damage = self:GetSpecialValueFor("damage")
	local bounce_damage = damage / 100 * self:GetSpecialValueFor("bounce_damage_pct")
	local bounce_range = self:GetSpecialValueFor("bounce_range")

	local targets_hit = {
		target
	}
	local search_sources = {
		target
	}

	print("Damage:", damage, bounce_damage)

	-- Play cast sound
	caster:EmitSound("DOTA_Item.Dagon.Activate")

	-- Play hit sound
	target:EmitSound("DOTA_Item.Dagon"..self:GetLevel()..".Target")

	-- Kill the target instantly if it is an illusion
	if target:IsIllusion() and not Custom_bIsStrongIllusion(target) then
		target:Kill(self, caster)
	end
	
	-- Dagonize the main target
	DagonizeIt(caster, self, caster, target, damage)

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
					DagonizeIt(caster, self, potential_source, potential_target, bounce_damage)
					targets_hit[#targets_hit+1] = potential_target
					search_sources[#search_sources+1] = potential_target
				end
			end

			-- Remove this potential source
			table.remove(search_sources, potential_source_index)
		end
	end
end

modifier_item_imba_dagon_passive = modifier_item_imba_dagon_passive or class({})

function modifier_item_imba_dagon_passive:IsHidden() return true end

function modifier_item_imba_dagon_passive:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_imba_dagon_passive:DeclareFunctions() return {
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
} end

function modifier_item_imba_dagon_passive:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_imba_dagon_passive:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_imba_dagon_passive:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end
