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
	if string.find(unit:GetUnitName(), "npc_dota_lone_druid_bear") then
		unit:SetupHealthBarLabel()

		-- Give the custom mechanics like damage block and lifesteal
		unit:AddNewModifier(unit, nil, "modifier_custom_mechanics", {})

		if unit:GetOwner() and unit:GetOwner():HasModifier("modifier_frantic") then
			local main_hero = unit:GetOwner()
			local shared_buff_modifier = main_hero:FindModifierByName("modifier_frantic")
			local shared_buff_ability = shared_buff_modifier:GetAbility()
			local buff_time = shared_buff_modifier:GetRemainingTime()
			if buff_time <= 0 then
				buff_time = shared_buff_modifier:GetDuration()
			end
			local cloned_modifier = unit:AddNewModifier(main_hero, shared_buff_ability, shared_buff_modifier:GetName(), {duration = buff_time})

			cloned_modifier:SetStackCount(shared_buff_modifier:GetStackCount())
		end
	end

	-- Let's give jungle creeps some love too...I guess
	if string.find(unit:GetUnitName(), "_neutral_") then
		unit:AddAbility("custom_creep_scaling")
	end
	
	if unit:GetClassname() == "npc_dota_creep_lane" or unit:GetClassname() == "npc_dota_creep_siege" then
		if unit:HasAbility("custom_creep_scaling") then
			unit:FindAbilityByName("custom_creep_scaling"):SetLevel(1)
		end
	
		if IMBA_GREEVILING == true then
			Greeviling(unit)
			return
		end
	end

	-- Burning Army override (skeletons invulnerable + fix not dying when duration ends)
	if unit:GetClassname() == "npc_dota_clinkz_skeleton_archer" then
		-- IMBA effect
--		unit:AddNewModifier(unit, nil, "modifier_invulnerable_hidden", {})

		for _, hero in pairs(HeroList:GetAllHeroes()) do
			if hero:GetUnitName() == "npc_dota_hero_clinkz" then
				if hero:HasTalent("special_bonus_imba_clinkz_8") then
					unit:AddNewModifier(unit, nil, "modifier_imba_burning_army", {mana_burn=hero:FindTalentValue("special_bonus_imba_clinkz_8")})
				end

				break
			end
		end

		Timers:CreateTimer(GetAbilitySpecial("clinkz_burning_army", "duration"), function()
			if unit then
				if unit:IsAlive() then
					unit:ForceKill(false)
				end
			end
		end)
	end

	-- Unit cosmetics
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
				elseif wearable == "models/items/rubick/rubick_arcana/rubick_arcana_back.vmdl" then
					ParticleManager:CreateParticle("particles/econ/items/rubick/rubick_arcana/rubick_arc_ambient_default.vpcf", PATTACH_ABSORIGIN_FOLLOW, cosmetic)
--				elseif wearable == "models/items/juggernaut/arcana/juggernaut_arcana_mask.vmdl" then
--					ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, cosmetic)
				elseif wearable == "models/items/juggernaut/jugg_ti8/jugg_ti8_sword.vmdl" then
					ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_ti8_sword/jugg_ti8_crimson_sword_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, cosmetic)
				end
			end
		end
	end)

	return
end

-- everytime an unit respawn
function GameMode:OnUnitSpawned(unit)
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
	end
end