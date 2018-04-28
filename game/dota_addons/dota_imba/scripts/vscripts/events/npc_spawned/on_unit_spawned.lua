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

-- first time a real hero spawn
function GameMode:OnUnitFirstSpawn(hero)
	
end

-- everytime a real hero respawn
function GameMode:OnUnitSpawned(unit)
	local greeviling = false

	if greeviling == true and RandomInt(1, 100) > 85 then
		if string.find(unit:GetUnitName(), "dota_creep") then
			local material_group = tostring(RandomInt(0, 8))
			unit.is_greevil = true
			if string.find(unit:GetUnitName(), "ranged") then
				unit:SetModel("models/courier/greevil/greevil_flying.vmdl")
				unit:SetOriginalModel("models/courier/greevil/greevil_flying.vmdl")
			else
				unit:SetModel("models/courier/greevil/greevil.vmdl")
				unit:SetOriginalModel("models/courier/greevil/greevil.vmdl")
			end
			unit:SetMaterialGroup(material_group)
			unit.eyes = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_eyes.vmdl"})
			unit.ears = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_ears"..RandomInt(1, 2)..".vmdl"})
			if RandomInt(1, 100) > 80 then
				unit.feathers = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_feathers.vmdl"})
				unit.feathers:FollowEntity(unit, true)
			end
			unit.hair = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_hair"..RandomInt(1, 2)..".vmdl"})
			unit.horns = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_horns"..RandomInt(1, 4)..".vmdl"})
			unit.nose = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_nose"..RandomInt(1, 3)..".vmdl"})
			unit.tail = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_tail"..RandomInt(1, 4)..".vmdl"})
			unit.teeth = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_teeth"..RandomInt(1, 4)..".vmdl"})
			unit.wings = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_wings"..RandomInt(1, 4)..".vmdl"})

			-- lock to bone
			unit.eyes:SetMaterialGroup(material_group)
			unit.eyes:FollowEntity(unit, true)
			unit.ears:SetMaterialGroup(material_group)
			unit.ears:FollowEntity(unit, true)
			unit.hair:FollowEntity(unit, true)
			unit.horns:SetMaterialGroup(material_group)
			unit.horns:FollowEntity(unit, true)
			unit.nose:SetMaterialGroup(material_group)
			unit.nose:FollowEntity(unit, true)
			unit.tail:SetMaterialGroup(material_group)
			unit.tail:FollowEntity(unit, true)
			unit.teeth:SetMaterialGroup(material_group)
			unit.teeth:FollowEntity(unit, true)
			unit.wings:SetMaterialGroup(material_group)
			unit.wings:FollowEntity(unit, true)
		elseif string.find(unit:GetUnitName(), "_siege") then
			unit:SetModel("models/creeps/mega_greevil/mega_greevil.vmdl")
			unit:SetOriginalModel("models/creeps/mega_greevil/mega_greevil.vmdl")
			unit:SetModelScale(2.75)
		end
	end

	-- levelup bear ability based on his level
	if string.find(unit:GetUnitName(), "npc_dota_lone_druid_bear") then
		for i = 0, 23 do
			local ability = unit:GetAbilityByIndex(i)
			if IsValidEntity(ability) then
				ability:SetLevel(unit:GetLevel())
			end
		end
	elseif unit:GetUnitName() == "npc_dummy_unit" or unit:GetUnitName() == "npc_dummy_unit_perma" then
		dummy_created_count = dummy_created_count + 1
	end

	Timers:CreateTimer(FrameTime(), function()
		if UNIT_EQUIPMENT[unit:GetModelName()] then
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
end