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
--     EarthSalamander #42, 07.08.18

-- DOTA_RUNE_INVALID = -1
-- DOTA_RUNE_DOUBLEDAMAGE = 0
-- DOTA_RUNE_HASTE = 1
-- DOTA_RUNE_ILLUSION = 2
-- DOTA_RUNE_INVISIBILITY = 3
-- DOTA_RUNE_REGENERATION = 4
-- DOTA_RUNE_BOUNTY = 5
-- DOTA_RUNE_ARCANE = 6
-- DOTA_RUNE_WATER = 7
-- DOTA_RUNE_XP = 8
-- DOTA_RUNE_SHIELD = 9
-- DOTA_RUNE_COUNT = 10

if Runes == nil then
	Runes = class({})
	Runes.spawnTime = {}
	Runes.spawnTime[DOTA_RUNE_XP] = 420.0 -- 7 minutes
	-- if IsInToolsMode() then
	-- 	Runes.spawnTime[DOTA_RUNE_XP] = 10.0
	-- end
	Runes.spawnLocation = {}
	Runes.spawnLocation[DOTA_RUNE_XP] = {}

	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(Runes, "OnGameRulesStateChange"), Runes)
end

require("components/settings/settings_runes")

LinkLuaModifier("modifier_imba_arcane_rune", "components/modifiers/runes/modifier_imba_arcane_rune.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_double_damage_rune", "components/modifiers/runes/modifier_imba_double_damage_rune.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_haste_rune", "components/modifiers/runes/modifier_imba_haste_rune", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_haste_rune_speed_limit_break", "components/modifiers/runes/modifier_imba_haste_rune_speed_limit_break.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_regen_rune", "components/modifiers/runes/modifier_imba_regen_rune", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_invisibility_rune_handler", "components/modifiers/runes/modifier_imba_invisibility_rune", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_illusion_rune", "components/modifiers/runes/modifier_imba_illusion_rune", LUA_MODIFIER_MOTION_NONE)
--	LinkLuaModifier("modifier_imba_frost_rune", "components/modifiers/runes/modifier_imba_frost_rune", LUA_MODIFIER_MOTION_NONE)
--	LinkLuaModifier("modifier_imba_ember_rune", "components/modifiers/runes/modifier_imba_ember_rune", LUA_MODIFIER_MOTION_NONE)
--	LinkLuaModifier("modifier_imba_stone_rune", "components/modifiers/runes/modifier_imba_stone_rune", LUA_MODIFIER_MOTION_NONE)

function Runes:OnGameRulesStateChange()
	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		Runes:Init()
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		Runes:Spawn()
	end
end

function Runes:Init()
	-- Wisdom runes fix
	local xp_rune_spawners = Entities:FindAllByClassname("dota_item_rune_spawner_xp")

	for _, rune_spawner in pairs(xp_rune_spawners) do
		table.insert(Runes.spawnLocation[DOTA_RUNE_XP], rune_spawner:GetAbsOrigin())
		rune_spawner:RemoveSelf()
	end
end

function Runes:Spawn()
	for rune_id = 0, 9 do
		if Runes.spawnLocation[rune_id] then
			GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("rune_timer_" .. rune_id), function()
				-- Runes spawn on each others. We want to check if there is already a rune on the same spot, and if so, spawn the new rune on a nearby empty spot
				for _, location in pairs(Runes.spawnLocation[rune_id]) do
					local random_vector_number = 55
					local iteration = 0
					local max_iterations = 1000 -- that will never happen, but just in case

					while Entities:FindAllByClassnameWithin("dota_item_rune", location, random_vector_number) and Entities:FindAllByClassnameWithin("dota_item_rune", location, random_vector_number)[1] do
						if iteration >= max_iterations then
							break
						end

						location = location + RandomVector(random_vector_number)
						random_vector_number = random_vector_number + 0.1
						-- iteration = iteration + 1
					end

					CreateRune(location, rune_id)
				end

				return Runes.spawnTime[rune_id]
			end, Runes.spawnTime[rune_id])
		end
	end
end

-- Spawns runes on the map (old full custom system)
-- function Runes:Spawn()
-- 	if IMBA_RUNE_SYSTEM == false then return end
-- 	-- List of powerup rune types
-- 	-- item name, particle name
-- 	local powerup_rune_types = {
-- 		{ "item_imba_rune_arcane",       "particles/generic_gameplay/rune_arcane.vpcf",                          "particles/generic_gameplay/rune_arcane_super.vpcf" },
-- 		{ "item_imba_rune_doubledamage", "particles/generic_gameplay/rune_doubledamage.vpcf",                    "particles/generic_gameplay/rune_quadrupledamage.vpcf" },
-- 		{ "item_imba_rune_haste",        "particles/generic_gameplay/rune_haste.vpcf",                           "particles/generic_gameplay/rune_haste_super.vpcf" },
-- 		{ "item_imba_rune_regen",        "particles/generic_gameplay/rune_regeneration.vpcf",                    "particles/generic_gameplay/rune_regeneration_super.vpcf" },
-- 		{ "item_imba_rune_illusion",     "particles/generic_gameplay/rune_illusion.vpcf",                        "particles/generic_gameplay/rune_illusion_super.vpcf" },
-- 		{ "item_imba_rune_invis",        "particles/generic_gameplay/rune_invisibility.vpcf",                    "particles/generic_gameplay/rune_invisibility_super.vpcf" },
-- 		{ "item_imba_rune_frost",        "particles/econ/items/puck/puck_snowflake/puck_snowflake_ambient.vpcf", "particles/econ/items/puck/puck_snowflake/puck_snowflake_ambient.vpcf" },
-- 		--		{"item_imba_rune_ember", "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_trail.vpcf"},
-- 		--		{"item_imba_rune_stone", "particles/econ/items/natures_prophet/natures_prophet_flower_treant/natures_prophet_flower_treant_ambient.vpcf"},
-- 	}

-- 	local powerup_super_rune_colors = {}
-- 	powerup_super_rune_colors[2] = { 204, 51, 255 }

-- 	local powerup_super_rune_particles = {}
-- 	powerup_super_rune_particles[2] = "particles/generic_gameplay/rune_quadrupledamage.vpcf",

-- 		Timers:CreateTimer(function()
-- 			Runes:RemoveRunes(1)

-- 			for k, v in pairs(Runes.powerup_rune_locations) do
-- 				local random_int = RandomInt(1, #powerup_rune_types)
-- 				local rune = CreateItemOnPositionForLaunch(Runes.powerup_rune_locations[k], CreateItem(powerup_rune_types[random_int][1], nil, nil))
-- 				Runes:RegisterRune(rune, 1)
-- 				if IMBA_MUTATION and IMBA_MUTATION["terrain"] == "super_runes" then
-- 					if powerup_super_rune_colors[random_int] then
-- 						rune:SetRenderColor(powerup_super_rune_colors[random_int][1], powerup_super_rune_colors[random_int][2], powerup_super_rune_colors[random_int][3])
-- 					end

-- 					if powerup_super_rune_particles[random_int] then
-- 						Runes:SpawnRuneParticle(rune, powerup_super_rune_particles[random_int])
-- 					else
-- 						Runes:SpawnRuneParticle(rune, powerup_rune_types[random_int][2])
-- 					end
-- 				else
-- 					Runes:SpawnRuneParticle(rune, powerup_rune_types[random_int][2])
-- 				end
-- 			end

-- 			return RUNE_SPAWN_TIME
-- 		end)

-- 	Timers:CreateTimer(function()
-- 		Runes:RemoveRunes(2)

-- 		for k, v in pairs(Runes.bounty_rune_locations) do
-- 			local bounty_rune = CreateItem("item_imba_rune_bounty", nil, nil)
-- 			local rune = CreateItemOnPositionForLaunch(Runes.bounty_rune_locations[k], bounty_rune)
-- 			Runes:RegisterRune(rune, 2)
-- 			Runes:SpawnRuneParticle(rune, "particles/generic_gameplay/rune_bounty_first.vpcf")
-- 		end

-- 		return BOUNTY_RUNE_SPAWN_TIME
-- 	end)
-- end

-- function Runes:SpawnRuneParticle(rune, particle)
-- 	local rune_particle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, rune)
-- 	ParticleManager:SetParticleControl(rune_particle, 0, rune:GetAbsOrigin())
-- 	ParticleManager:ReleaseParticleIndex(rune_particle)
-- end

-- function Runes:RegisterRune(rune, rune_type)
-- 	AddFOWViewer(2, rune:GetAbsOrigin(), 100, 0.02, false)
-- 	AddFOWViewer(3, rune:GetAbsOrigin(), 100, 0.02, false)

-- 	-- Initialize table
-- 	if not rune_spawn_table then
-- 		rune_spawn_table = {}
-- 	end

-- 	if not bounty_rune_spawn_table then
-- 		bounty_rune_spawn_table = {}
-- 	end

-- 	-- Register rune into table
-- 	if rune_type == 1 then
-- 		table.insert(rune_spawn_table, rune)
-- 	elseif rune_type == 2 then
-- 		table.insert(bounty_rune_spawn_table, rune)
-- 	end
-- end

-- function Runes:RemoveRunes(rune_type)
-- 	local rune_table

-- 	if rune_type == 1 then
-- 		rune_table = rune_spawn_table
-- 	elseif rune_type == 2 then
-- 		rune_table = bounty_rune_spawn_table
-- 	end

-- 	if rune_table then
-- 		-- Remove existing runes
-- 		for _, rune in pairs(rune_table) do
-- 			if not rune:IsNull() then
-- 				local item = rune:GetContainedItem()
-- 				UTIL_Remove(item)
-- 				UTIL_Remove(rune)
-- 			end
-- 		end

-- 		-- Clear the table
-- 		rune_table = {}
-- 	end
-- end

function Runes:PickupRune(rune_name, unit, bActiveByBottle)
	if string.find(rune_name, "item_imba_rune_") then
		rune_name = string.gsub(rune_name, "item_imba_rune_", "")
	end

	local bottle = bActiveByBottle or false
	local store_in_bottle = false
	local duration = GetItemKV("item_imba_rune_" .. rune_name, "RuneDuration")

	for i = 0, 5 do
		local item = unit:GetItemInSlot(i)
		if item and not bottle then
			if item:GetAbilityName() == "item_imba_bottle" and not item.RuneStorage then
				item:SetStorageRune(rune_name)
				store_in_bottle = true
				break
			end
		end
	end

	if store_in_bottle == false then
		if rune_name == "bounty" then
			-- I'm led to believe this block doesn't work anyways, but just in case...I'm commenting it out.
			-- Bounty Rune logic is handled in filters.lua

			-- Bounty rune parameters
			local base_bounty = GetAbilitySpecial("item_imba_rune_bounty", "base_bounty")
			local bounty_per_minute = GetAbilitySpecial("item_imba_rune_bounty", "bounty_increase_per_minute")
			local xp_per_minute = GetAbilitySpecial("item_imba_rune_bounty", "xp_increase_per_minute")
			local game_time = GameRules:GetDOTATime(false, false)
			local current_bounty = base_bounty + (bounty_per_minute * game_time / 60)
			local current_xp = xp_per_minute * game_time / 60

			-- Adjust value for lobby options
			local custom_gold_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "bounty_multiplier")["1"])
			current_bounty = current_bounty * (custom_gold_bonus / 100)

			-- if IMBA_MUTATION and IMBA_MUTATION["terrain"] == "super_runes" then
			-- 	current_bounty = current_bounty * GetAbilitySpecial("item_imba_rune_bounty", "super_runes_multiplier")
			-- 	current_xp = current_xp * GetAbilitySpecial("item_imba_rune_bounty", "super_runes_multiplier")
			-- end

			-- #3 Talent: Bounty runes give gold bags
			-- if unit:HasTalent("special_bonus_imba_alchemist_3") then
			-- local stacks_to_gold =( unit:FindTalentValue("special_bonus_imba_alchemist_3") / 100 )  / 5
			-- local gold_per_bag = unit:FindModifierByName("modifier_imba_goblins_greed_passive"):GetStackCount() + (current_bounty * stacks_to_gold)
			-- for i = 1, 5 do
			-- -- Drop gold bags
			-- local newItem = CreateItem( "item_bag_of_gold", nil, nil )
			-- newItem:SetPurchaseTime( 0 )
			-- newItem:SetCurrentCharges( gold_per_bag )

			-- local drop = CreateItemOnPositionSync( unit:GetAbsOrigin(), newItem )
			-- local dropTarget = unit:GetAbsOrigin() + RandomVector( RandomFloat( 300, 450 ) )
			-- newItem:LaunchLoot( true, 300, 0.75, dropTarget )
			-- EmitSoundOn( "Dungeon.TreasureItemDrop", unit )
			-- end
			-- end

			-- global bounty rune
			for _, hero in pairs(HeroList:GetAllHeroes()) do
				if hero:GetTeam() == unit:GetTeam() then
					if hero:IsFakeHero() then
						-- don't give gold to mk and meepo clones or illusions
					elseif hero:GetUnitName() == "npc_dota_hero_alchemist" then
						local alchemy_bounty = 0
						if unit:FindAbilityByName("imba_alchemist_goblins_greed") and unit:FindAbilityByName("imba_alchemist_goblins_greed"):GetLevel() > 0 then
							alchemy_bounty = current_bounty * (unit:FindAbilityByName("imba_alchemist_goblins_greed"):GetSpecialValueFor("bounty_multiplier") / 100)

							-- #7 Talent: Moar gold from bounty runes
							if unit:HasTalent("special_bonus_imba_alchemist_7") then
								alchemy_bounty = alchemy_bounty * (unit:FindTalentValue("special_bonus_imba_alchemist_7") / 100)
							end
						else
							alchemy_bounty = current_bounty
						end

						hero:ModifyGold(alchemy_bounty, false, DOTA_ModifyGold_Unspecified)
						SendOverheadEventMessage(PlayerResource:GetPlayer(hero:GetPlayerOwnerID()), OVERHEAD_ALERT_GOLD, hero, alchemy_bounty, nil)

						-- Grant the unit experience
						hero:AddExperience(current_xp, DOTA_ModifyXP_CreepKill, false, true)
						SendOverheadEventMessage(PlayerResource:GetPlayer(hero:GetPlayerOwnerID()), OVERHEAD_ALERT_MANA_ADD, hero, current_xp, nil)
					else
						hero:ModifyGold(current_bounty, false, DOTA_ModifyGold_Unspecified)
						SendOverheadEventMessage(PlayerResource:GetPlayer(hero:GetPlayerOwnerID()), OVERHEAD_ALERT_GOLD, hero, current_bounty, nil)

						-- Grant the unit experience
						hero:AddExperience(current_xp, DOTA_ModifyXP_CreepKill, false, true)
						SendOverheadEventMessage(PlayerResource:GetPlayer(hero:GetPlayerOwnerID()), OVERHEAD_ALERT_MANA_ADD, hero, current_xp, nil)
					end
				end
			end

			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Bounty", unit)
		elseif rune_name == "arcane" then
			unit:AddNewModifier(unit, item, "modifier_imba_arcane_rune", { duration = duration })
			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Arcane", unit)
		elseif rune_name == "doubledamage" then
			unit:AddNewModifier(unit, item, "modifier_imba_double_damage_rune", { duration = duration })
			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.DD", unit)
		elseif rune_name == "haste" then
			unit:AddNewModifier(unit, item, "modifier_imba_haste_rune", { duration = duration })
			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Haste", unit)
		elseif rune_name == "illusion" then
			-- Massive lag for custom illusions (plus some bad glitches) so let's remove this
			-- local images_count = 3
			-- if IMBA_MUTATION and IMBA_MUTATION["terrain"] == "super_runes" then
			-- images_count = 6
			-- end

			-- for i = 1, images_count do
			-- if not unit:IsRangedAttacker() then
			-- unit:CreateIllusion(duration, 100, -40)
			-- else
			-- unit:CreateIllusion(duration, 200, -40)
			-- end
			-- end

			-- FindClearSpaceForUnit(unit, unit:GetAbsOrigin() + RandomVector(72), true)

			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Illusion", unit)

			for _, ally in pairs(FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)) do
				if ally:GetOwner() and ally:GetOwner().GetAssignedHero and ally:GetOwner():GetAssignedHero() == unit then
					ally:AddNewModifier(unit, nil, "modifier_imba_illusion_rune", { duration = 40.0 })
				end
			end
		elseif rune_name == "invis" then
			unit:AddNewModifier(unit, nil, "modifier_imba_invisibility_rune_handler", { duration = 2.0, rune_duration = duration })
			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Invis", unit)
		elseif rune_name == "regen" then
			unit:AddNewModifier(unit, nil, "modifier_imba_regen_rune", { duration = duration })
			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Regen", unit)
		elseif rune_name == "frost" then
			unit:AddNewModifier(unit, nil, "modifier_imba_frost_rune", { duration = duration })
			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Frost", unit)
		elseif rune_name == "ember" then
			unit:AddNewModifier(unit, nil, "modifier_imba_ember_rune", { duration = duration })
			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Frost", unit)
		elseif rune_name == "stone" then
			unit:AddNewModifier(unit, nil, "modifier_imba_stone_rune", { duration = duration })
			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Frost", unit)
		end

		-- send a custom combat event if custom message is enabled
		if IMBA_COMBAT_EVENTS == true then
			CustomGameEventManager:Send_ServerToTeam(unit:GetTeam(), "create_custom_toast", {
				type = "generic",
				text = "#custom_toast_ActivatedRune",
				player = unit:GetPlayerID(),
				runeType = rune_name,
				runeFirst = true, -- every bounty runes are global now
			})
		end
	end
end

-- utils
function CBaseEntity:IsRune()
	local runes = {
		"models/props_gameplay/rune_goldxp.vmdl",
		"models/props_gameplay/rune_haste01.vmdl",
		"models/props_gameplay/rune_doubledamage01.vmdl",
		"models/props_gameplay/rune_regeneration01.vmdl",
		"models/props_gameplay/rune_arcane.vmdl",
		"models/props_gameplay/rune_invisibility01.vmdl",
		"models/props_gameplay/rune_illusion01.vmdl",
		"models/props_gameplay/rune_frost.vmdl",
		"models/props_gameplay/gold_coin001.vmdl", -- Overthrow coin
		"models/props_gameplay/rune_water.vmdl",
	}

	for _, model in pairs(runes) do
		if self:GetModelName() == model then
			return true
		end
	end

	return false
end
