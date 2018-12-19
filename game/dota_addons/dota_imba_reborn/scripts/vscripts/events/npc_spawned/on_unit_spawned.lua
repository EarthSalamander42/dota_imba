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

-- first time a real hero spawn
function GameMode:OnUnitFirstSpawn(unit)
	if IsMutationMap() then
		Mutation:OnUnitFirstSpawn(unit)
	end

	if string.find(unit:GetUnitName(), "npc_dota_lone_druid_bear") then
		unit:SetupHealthBarLabel()
	end

	if unit:GetClassname() == "npc_dota_creep_lane" then
		if IMBA_GREEVILING == true then
			Greeviling(unit)
			return
		end
	end

	Timers:CreateTimer(FrameTime(), function()
		if not unit:IsNull() and UNIT_EQUIPMENT[unit:GetModelName()] then
			for _, wearable in pairs(UNIT_EQUIPMENT[unit:GetModelName()]) do
				local cosmetic = SpawnEntityFromTableSynchronous("prop_dynamic", {model = wearable})
				cosmetic:FollowEntity(unit, true)
				if wearable == "models/items/pudge/scorching_talon/scorching_talon.vmdl" then
					local particle = ParticleManager:CreateParticle("particles/econ/items/pudge/pudge_scorching_talon/pudge_scorching_talon_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
					ParticleManager:ReleaseParticleIndex(particle)
				elseif wearable == "models/items/pudge/immortal_arm/immortal_arm.vmdl" then
					cosmetic:SetMaterialGroup("1")
				elseif wearable == "models/items/pudge/arcana/pudge_arcana_back.vmdl" then
					unit:SetMaterialGroup("1") -- zonnoz pet
					cosmetic:SetMaterialGroup("1") -- zonnoz pet

					ParticleManager:CreateParticle("particles/econ/items/pudge/pudge_arcana/pudge_arcana_back_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, cosmetic)
					ParticleManager:CreateParticle("particles/econ/items/pudge/pudge_arcana/pudge_arcana_back_ambient_beam.vpcf", PATTACH_ABSORIGIN_FOLLOW, cosmetic)
					ParticleManager:CreateParticle("particles/econ/items/pudge/pudge_arcana/pudge_arcana_ambient_flies.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
				end
			end
		end
	end)

	return
end

-- everytime an unit respawn
function GameMode:OnUnitSpawned(unit)
	if IsMutationMap() then
		Mutation:OnUnitSpawn(npc)
	end

	-- levelup bear ability based on his level
	if string.find(unit:GetUnitName(), "npc_dota_lone_druid_bear") then
		for i = 0, 23 do
			local ability = unit:GetAbilityByIndex(i)
			if IsValidEntity(ability) then
				ability:SetLevel(unit:GetLevel())
			end
		end

		return
	elseif unit:IsIllusion() and not unit:HasModifier("modifier_illusion_manager_out_of_world") and not unit:HasModifier("modifier_illusion_manager") then
		-- Valve Illusion bug to prevent respawning
		UTIL_Remove(unit)
		return
	elseif unit:IsTempestDouble() then
		UTIL_Remove(unit)
		return
	end
end