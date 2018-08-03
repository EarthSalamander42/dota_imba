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

function GameMode:OnGameRulesStateChange(keys)
	-- This internal handling is used to set up main barebones functions
	GameMode:_OnGameRulesStateChange(keys)

	if IsMutationMap() then
		Mutation:OnGameRulesStateChange(keys)
	end

	-- Run this in safe context
	local new_state = GameRules:State_Get()

	-- IMBA: Team selection
	if new_state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		log.info("events: team selection")
		OnSetGameMode() -- setup gamemode rules
		InitializeTeamSelection()

		-- get the IXP of everyone (ignore bot)
		GetPlayerInfoIXP()

		local hex_colors = {}
		for i = 0, 23 do
			table.insert(hex_colors, i, rgbToHex(PLAYER_COLORS[i]))
		end

		CustomNetTables:SetTableValue("game_options", "player_colors", hex_colors)
	end

	-- IMBA: Pick screen stuff
	if new_state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		api.imba.event(api.events.entered_hero_selection)
		HeroSelection:Init()
	end

	-- IMBA: Start-of-pre-game stuff
	if new_state == DOTA_GAMERULES_STATE_PRE_GAME then
		api.imba.event(api.events.entered_pre_game)
		-- Shows various info to devs in pub-game to find lag issues
--		ImbaNetGraph(10.0)

		-- Initialize rune spawners
		InitRunes()

--		if GetMapName() ~= "imba_overthrow" then
			-- Initialize battlepass towers
--			Imbattlepass:InitializeTowers()
--		end

		CustomNetTables:SetTableValue("game_options", "donators", api.imba.get_donators())
		CustomNetTables:SetTableValue("game_options", "developers", api.imba.get_developers())

		-- IMBA: Custom maximum level EXP tables adjustment
		local max_level = tonumber(CustomNetTables:GetTableValue("game_options", "max_level")["1"])
		if max_level and max_level > 25 then
			for i = 26, max_level do
				XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i-1] + 3500
				GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
			end
		end

		Timers:CreateTimer(2.0, function()
				for _, hero in pairs(HeroList:GetAllHeroes()) do
					-- player table runs an error with new picking screen

					if CustomNetTables:GetTableValue("player_table", tostring(hero:GetPlayerID())) ~= nil then
						local donators = api.imba.get_donators()
						for k, v in pairs(donators) do
							CustomNetTables:SetTableValue("player_table", tostring(hero:GetPlayerID()), {
									companion_model = donators[k].model,
									companion_enabled = donators[k].enabled,
									Lvl = CustomNetTables:GetTableValue("player_table", tostring(hero:GetPlayerID())).Lvl,
								})
						end
					end
				end

				if GetMapName() == "imba_overthrow" then
					local foundTeams = {}
					COURIER_TEAM = {}
					for _, playerStart in pairs(Entities:FindAllByClassname("info_courier_spawn")) do
						COURIER_TEAM[playerStart:GetTeam()] = CreateUnitByName("npc_dota_courier", playerStart:GetAbsOrigin(), true, nil, nil, playerStart:GetTeam())
--						COURIER_PLAYER[playerStart:GetTeam()] = CreateUnitByName("npc_dota_courier", playerStart:GetAbsOrigin(), true, nil, nil, playerStart:GetTeam())
					end

					for _, hero in pairs(HeroList:GetAllHeroes()) do
						if Entities:FindAllByClassname("info_courier_spawn"):GetTeam() == hero:GetTeam() then
							COURIER_TEAM[hero:GetPlayerID()] = CreateUnitByName("npc_dota_courier", Entities:FindAllByClassname("info_courier_spawn"):GetAbsOrigin(), true, nil, nil, hero:GetTeam())
--							COURIER_PLAYER[hero:GetPlayerID()] = CreateUnitByName("npc_dota_courier", Entities:FindAllByClassname("info_courier_spawn"):GetAbsOrigin(), true, nil, nil, hero:GetTeam())
						end
					end
				elseif GetMapName() == "cavern" then
				else
--					safe(function()
--						if error then
--							log.info("An error occured with courier script, swap to original team couriers.")

--							COURIER_TEAM = {}
--							COURIER_TEAM[2] = CreateUnitByName("npc_dota_courier", Entities:FindByClassname(nil, "info_courier_spawn_radiant"):GetAbsOrigin(), true, nil, nil, 2)
--							COURIER_TEAM[3] = CreateUnitByName("npc_dota_courier", Entities:FindByClassname(nil, "info_courier_spawn_dire"):GetAbsOrigin(), true, nil, nil, 3)

--							error = true
--						else
					if USE_TEAM_COURIER then
						COURIER_TEAM = {}
						COURIER_TEAM[2] = CreateUnitByName("npc_dota_courier", Entities:FindByClassname(nil, "info_courier_spawn_radiant"):GetAbsOrigin(), true, nil, nil, 2)
						COURIER_TEAM[3] = CreateUnitByName("npc_dota_courier", Entities:FindByClassname(nil, "info_courier_spawn_dire"):GetAbsOrigin(), true, nil, nil, 3)
					else
						for _, hero in pairs(HeroList:GetAllHeroes()) do
							COURIER_PLAYER = {}
							if hero:GetTeamNumber() == 2 then
								COURIER_PLAYER[hero:GetPlayerID()] = CreateUnitByName("npc_dota_courier", Entities:FindByClassname(nil, "info_courier_spawn_radiant"):GetAbsOrigin(), true, nil, nil, hero:GetTeam())
							elseif hero:GetTeamNumber() == 3 then
								COURIER_PLAYER[hero:GetPlayerID()] = CreateUnitByName("npc_dota_courier", Entities:FindByClassname(nil, "info_courier_spawn_dire"):GetAbsOrigin(), true, nil, nil, hero:GetTeam())
							end
						end
					end
--						end

--						error = false
--					end)

					local good_fillers = {
						"good_filler_1",
						"good_filler_3",
						"good_filler_5",
					}

					local bad_fillers = {
						"bad_filler_1",
						"bad_filler_3",
						"bad_filler_5",
					}

					for _, ent_name in pairs(good_fillers) do
						local filler = Entities:FindByName(nil, ent_name)
						local abs = filler:GetAbsOrigin()
						filler:RemoveSelf()
						local shrine = CreateUnitByName("npc_dota_goodguys_healers", abs, true, nil, nil, 2)
						shrine:SetAbsOrigin(abs)
					end

					for _, ent_name in pairs(bad_fillers) do
						local filler = Entities:FindByName(nil, ent_name)
						local abs = filler:GetAbsOrigin()
						filler:RemoveSelf()
						local shrine = CreateUnitByName("npc_dota_badguys_healers", abs, true, nil, nil, 3)
						shrine:SetAbsOrigin(abs)
					end

					CustomGameEventManager:Send_ServerToAllClients("override_top_bar_colors", {})
				end
			end)
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Game started (horn sounded)
	-------------------------------------------------------------------------------------------------
	if new_state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		GameRules:SetSafeToLeave(false)
		api.imba.event(api.events.started_game)

		Timers:CreateTimer(60, function()
				StartGarbageCollector()
				--			DefineLosingTeam()
				return 60
			end)

		if IsMutationMap() then
			SpawnEasterEgg()
		elseif GetMapName() == "imba_overthrow" then
			countdownEnabled = true
			CustomGameEventManager:Send_ServerToAllClients( "show_timer", {} )
			DoEntFire( "center_experience_ring_particles", "Start", "0", 0, self, self )
		elseif GetMapName() == "imba_1v1" then
			local removed_ents = {
				"lane_top_goodguys_melee_spawner",
				"lane_bot_goodguys_melee_spawner",
				"lane_top_badguys_melee_spawner",
				"lane_bot_badguys_melee_spawner",
			}

			for _, ent_name in pairs(removed_ents) do
				local ent = Entities:FindByName(nil, ent_name)
				ent:RemoveSelf()
			end

			BlockJungleCamps()
		end
	end

	if new_state == DOTA_GAMERULES_STATE_POST_GAME then
		api.imba.event(api.events.entered_post_game)
		api.imba.complete(function (error, players)
			local game_id = 0
			if api.imba.data ~= nil then
				game_id = api.imba.data.id or 0
			end

			CustomGameEventManager:Send_ServerToAllClients("end_game", {
				players = players,
				info = {
					winner = GAME_WINNER_TEAM,
					id = game_id,
					radiant_score = GetTeamHeroKills(2),
					dire_score = GetTeamHeroKills(3),
					custom1_score = GetTeamHeroKills(6),
					custom2_score = GetTeamHeroKills(7),
					custom3_score = GetTeamHeroKills(8),
					custom4_score = GetTeamHeroKills(9),
					custom5_score = GetTeamHeroKills(10),
					custom6_score = GetTeamHeroKills(11),
					custom7_score = GetTeamHeroKills(12),
					custom8_score = GetTeamHeroKills(13),
				},
			})
		end)

		CustomNetTables:SetTableValue("game_options", "game_count", {value = 0})
	end
end

dummy_created_count = 0

function GameMode:OnNPCSpawned(keys)
	GameMode:_OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)

	if npc then
		-- UnitSpawned Api Event
		local player = "-1"

		-- Adding boundary modifier here (to keep entities within the map)
		npc:AddNewModifier(npc, nil, "modifier_boundaries", {})

		if npc:IsRealHero() and npc:GetPlayerID() then
			player = PlayerResource:GetSteamID(npc:GetPlayerID())
		end

		api.imba.event(api.events.unit_spawned, {
			tostring(npc:GetUnitName()),
			tostring(player)
		})

		if npc:IsCourier() then
			if npc.first_spawn == true then
				CombatEvents("generic", "courier_respawn", npc)
			else
				npc:AddAbility("courier_movespeed"):SetLevel(1)
				npc.first_spawn = true
			end

			return
		elseif npc:IsRealHero() then
			if api.imba.is_donator(PlayerResource:GetSteamID(npc:GetPlayerID())) then
				npc:AddNewModifier(npc, nil, "modifier_imba_donator", {})
			end

			if IsMutationMap() then
				if npc:GetUnitName() ~= FORCE_PICKED_HERO then
					Mutation:OnHeroSpawn(npc)
				end
			end

			if npc.first_spawn ~= true then
				npc.first_spawn = true

				if IsMutationMap() then
					if npc:GetUnitName() ~= FORCE_PICKED_HERO then
						Mutation:OnHeroFirstSpawn(npc)
					end
				end

				GameMode:OnHeroFirstSpawn(npc)

				return
			end

			GameMode:OnHeroSpawned(npc)

			return
		else
			if npc.first_spawn ~= true then
				npc.first_spawn = true
				GameMode:OnUnitFirstSpawn(npc)

				return
			end

			GameMode:OnUnitSpawned(npc)

			return
		end
	end
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
	
	if type(keys.HeroEntityIndex) ~= "number" then 
		log.warn({"Item picked up but hero entity index is not a number.", keys})
		return 
	end
	
	local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
	local plyID = keys.PlayerID
	if not plyID then return end
	local hero = PlayerResource:GetSelectedHeroEntity(plyID)
	local itemcost = keys.itemcost

	if heroEntity:IsHero() then
		if keys.itemname == "item_bag_of_gold" then
			-- Pick up the gold
			GoldPickup(keys)
		elseif keys.itemname == "item_treasure_chest" then
			log.debug("Special Item Picked Up")
			DoEntFire( "item_spawn_particle_" .. itemSpawnIndex, "Stop", "0", 0, self, self )
			GameMode:SpecialItemAdd( event )
			UTIL_Remove( item ) -- otherwise it pollutes the player inventory
		end
	end

	api.imba.event(api.events.item_picked_up, {
			tostring(keys.itemname),
			tostring(hero:GetUnitName()),
			tostring(PlayerResource:GetSteamID(plyID))
		})
end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
	local plyID = keys.PlayerID
	if not plyID then return end
	local hero = PlayerResource:GetSelectedHeroEntity(plyID)
	local itemName = keys.itemname
	local itemcost = keys.itemcost

	api.imba.event(api.events.item_purchased, {
			tostring(keys.itemname),
			tostring(hero:GetUnitName()),
			tostring(PlayerResource:GetSteamID(plyID))
		})
end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
	local player = keys.PlayerID
	local abilityname = keys.abilityname
	if not abilityname then return end

	local hero = PlayerResource:GetSelectedHeroEntity(player)
	if not hero then return end

	local abilityUsed = hero:FindAbilityByName(abilityname)
	if not abilityUsed then return end

	if abilityname == "rubick_spell_steal" then
		local target = abilityUsed:GetCursorTarget()
		hero.spellStealTarget = target
	end

	local meepo_table = Entities:FindAllByName("npc_dota_hero_meepo")
	if hero:GetUnitName() == "npc_dota_hero_meepo" then
		for m = 1, #meepo_table do
			if meepo_table[m]:IsClone() then
				if abilityname == "item_sphere" then
					local duration = abilityname:GetSpecialValueFor("block_cooldown")
					meepo_table[m]:AddNewModifier(meepo_table[m], ability, "modifier_item_sphere_target", {duration = duration})
				end
			end
		end
	end

	-- API
	api.imba.event(api.events.ability_used, {
			tostring(hero:GetUnitName()),
			tostring(abilityname),
			tostring(PlayerResource:GetSteamID(keys.PlayerID))
		})

	-------------------------------------------------------------------------------------------------
	-- IMBA: Remote Mines adjustment
	-------------------------------------------------------------------------------------------------

	-- if abilityname == "techies_remote_mines" then

	-- 	local mine_caster = player:GetAssignedHero()
	-- 	Timers:CreateTimer(0.01, function()
	-- 		local nearby_units = FindUnitsInRadius(mine_caster:GetTeamNumber(), mine_caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- 		for _,unit in pairs(nearby_units) do

	-- 			-- Only operate on remotes which need setup
	-- 			if unit.needs_remote_mine_setup then

	-- 				-- Add extra abilities
	-- 				unit:AddAbility("imba_techies_minefield_teleport")
	-- 				unit:AddAbility("imba_techies_remote_auto_creep")
	-- 				unit:AddAbility("imba_techies_remote_auto_hero")
	-- 				local minefield_teleport = unit:FindAbilityByName("imba_techies_minefield_teleport")
	-- 				local auto_creep = unit:FindAbilityByName("imba_techies_remote_auto_creep")
	-- 				local auto_hero = unit:FindAbilityByName("imba_techies_remote_auto_hero")
	-- 				auto_creep:SetLevel(1)
	-- 				auto_hero:SetLevel(1)

	-- 				-- Enable minefield teleport if the caster has a scepter
	-- 				local scepter = HasScepter(mine_caster)
	-- 				if scepter then
	-- 					minefield_teleport:SetLevel(1)
	-- 				end

	-- 				-- Toggle abilities on according to the current caster setting
	-- 				if mine_caster.auto_hero_exploding then
	-- 					auto_hero:ToggleAbility()
	-- 				elseif mine_caster.auto_creep_exploding then
	-- 					auto_creep:ToggleAbility()
	-- 				end

	-- 				-- Set this mine's setup as done
	-- 				unit.needs_remote_mine_setup = nil
	-- 			end
	-- 		end
	-- 	end)
	-- end
end

function GameMode:OnPlayerLearnedAbility(keys)
	local player = EntIndexToHScript(keys.player)
	local hero = player:GetAssignedHero()
	local abilityname = keys.abilityname

	-- If it the ability is Homing Missiles, wait a bit and set count to 1
	if abilityname == "gyrocopter_homing_missile" then
		Timers:CreateTimer(1, function()
				-- Find homing missile modifier
				local modifier_charges = player:GetAssignedHero():FindModifierByName("modifier_gyrocopter_homing_missile_charge_counter")
				if modifier_charges then
					modifier_charges:SetStackCount(3)
				end
			end)
	elseif abilityname == "special_bonus_imba_mirana_5" then -- fix for mirana stand still talent not working
		hero:AddNewModifier(hero, nil, "modifier_imba_mirana_silence_stance", {})
		hero:AddNewModifier(hero, nil, "modifier_imba_mirana_silence_stance_visible", {})
	end

	-- initiate talent!
	if abilityname:find("special_bonus_imba_") == 1 then
		hero:AddNewModifier(hero, nil, "modifier_"..abilityname, {})
	end

	if abilityname == "lone_druid_savage_roar" and not hero.savage_roar then
		hero.savage_roar = true
	end

	if hero then
		api.imba.event(api.events.ability_learned, {
				tostring(abilityname),
				tostring(hero:GetUnitName()),
				tostring(PlayerResource:GetSteamID(player:GetPlayerID()))
			})
	end
end

function GameMode:OnPlayerLevelUp(keys)
	local player = EntIndexToHScript(keys.player)
	local hero = player:GetAssignedHero()
	if hero == nil then return end
	local hero_level = hero:GetLevel()

	-------------------------------------------------------------------------------------------------
	-- IMBA: Hero experience bounty adjustment
	-------------------------------------------------------------------------------------------------
	hero:SetCustomDeathXP(HERO_XP_BOUNTY_PER_LEVEL[hero_level])

	api.imba.event(api.events.hero_level_up, {
			tostring(hero:GetUnitName()),
			tostring(hero_level),
			tostring(PlayerResource:GetSteamID(player:GetPlayerID()))
		})

	if hero:GetUnitName() == "npc_dota_hero_invoker" then
		if hero_level == 6 or hero_level == 12 or hero_level == 18 then
			local ab = hero:FindAbilityByName("invoker_invoke")
			ab:SetLevel(ab:GetLevel() + 1)
		end
	end

	if hero_level >= 26 then
		if not hero:HasModifier("modifier_imba_war_veteran_"..hero:GetPrimaryAttribute()) then
			hero:AddNewModifier(hero, nil, "modifier_imba_war_veteran_"..hero:GetPrimaryAttribute(), {})
		end

		hero:SetModifierStackCount("modifier_imba_war_veteran_"..hero:GetPrimaryAttribute(), hero, hero:GetLevel() -25)
		hero:SetAbilityPoints(hero:GetAbilityPoints() -1)
	end
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
	if keys.PlayerID == -1 then return end
	local isFirstBlood = keys.FirstBlood == 1
	local isHeroKill = keys.HeroKill == 1
	local isTowerKill = keys.TowerKill == 1
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local killedEnt = EntIndexToHScript(keys.EntKilled)

	if isFirstBlood and player ~= nil then
		player:GetAssignedHero().kill_hero_bounty = 0
		Timers:CreateTimer(FrameTime() * 2, function()
				CombatEvents("kill", "first_blood", killedEnt, player:GetAssignedHero())
			end)
		return
	elseif isHeroKill and player ~= nil then
		if not player:GetAssignedHero().killstreak then player:GetAssignedHero().killstreak = 0 end
		player:GetAssignedHero().killstreak = player:GetAssignedHero().killstreak +1

--		for _,attacker in pairs(HeroList:GetAllHeroes()) do
--			for i = 0, killedEnt:GetNumAttackers() -1 do
--				if attacker == killedEnt:GetAttacker(i) then
--					log.debug(attacker:GetUnitName())
--				end
--			end
--		end

		player:GetAssignedHero().kill_hero_bounty = 0
		Timers:CreateTimer(0.1, function()
				CombatEvents("kill", "hero_kill", killedEnt, player:GetAssignedHero())
			end)
	end
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)

	-- Typical keys:
	-- herokills: 6
	-- killer_userid: 0
	-- splitscreenplayer: -1
	-- teamnumber: 2
	-- victim_userid: 7
	-- killer id will be -1 in case of a non-player owned killer (e.g. neutrals, towers, etc.)

	local killer_id = keys.killer_userid
	local victim_id = keys.victim_userid
	local killer_team = keys.teamnumber
	local nTeamKills = keys.herokills

	-- Overthrow
	if GetMapName() == "imba_overthrow" then
		local nKillsRemaining = TEAM_KILLS_TO_WIN - nTeamKills
		local broadcast_kill_event =
		{
			killer_id = keys.killer_userid,
			team_id = keys.teamnumber,
			team_kills = nTeamKills,
			kills_remaining = nKillsRemaining,
			victory = 0,
			close_to_victory = 0,
			very_close_to_victory = 0,
		}

		if nKillsRemaining <= 0 then
			GameRules:SetCustomVictoryMessage( m_VictoryMessages[killer_team] )
			GAME_WINNER_TEAM = killer_team
			GameRules:SetGameWinner( killer_team )
			broadcast_kill_event.victory = 1
		elseif nKillsRemaining == 1 then
			EmitGlobalSound( "ui.npe_objective_complete" )
			broadcast_kill_event.very_close_to_victory = 1
		elseif nKillsRemaining <= CLOSE_TO_VICTORY_THRESHOLD then
			EmitGlobalSound( "ui.npe_objective_given" )
			broadcast_kill_event.close_to_victory = 1
		end
		CustomGameEventManager:Send_ServerToAllClients( "kill_event", broadcast_kill_event )
	elseif GetMapName() == "imba_1v1" then
		if nTeamKills == IMBA_1V1_SCORE then
			GAME_WINNER_TEAM = killer_team
			GameRules:SetGameWinner( killer_team )
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Comeback gold logic
	-------------------------------------------------------------------------------------------------
	--	UpdateComebackBonus(1, killer_team)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Deathstreak logic
	-------------------------------------------------------------------------------------------------
	if PlayerResource:IsValidPlayerID(killer_id) and PlayerResource:IsValidPlayerID(victim_id) then
		PlayerResource:ResetDeathstreak(killer_id)
		PlayerResource:IncrementDeathstreak(victim_id)

		-- Show Deathstreak message
		local victim_hero_name = PlayerResource:GetPickedHeroName(victim_id)
		local victim_player_name = PlayerResource:GetPlayerName(victim_id)
		local victim_death_streak = PlayerResource:GetDeathstreak(victim_id)
		local line_duration = 7

		if victim_death_streak then
			if victim_death_streak >= 3 then
				Notifications:BottomToAll({hero = victim_hero_name, duration = line_duration})
				Notifications:BottomToAll({text = victim_player_name.." ", duration = line_duration, continue = true})
			end

			if victim_death_streak == 3 then
				Notifications:BottomToAll({text = "#imba_deathstreak_3", duration = line_duration, continue = true})
			elseif victim_death_streak == 4 then
				Notifications:BottomToAll({text = "#imba_deathstreak_4", duration = line_duration, continue = true})
			elseif victim_death_streak == 5 then
				Notifications:BottomToAll({text = "#imba_deathstreak_5", duration = line_duration, continue = true})
			elseif victim_death_streak == 6 then
				Notifications:BottomToAll({text = "#imba_deathstreak_6", duration = line_duration, continue = true})
			elseif victim_death_streak == 7 then
				Notifications:BottomToAll({text = "#imba_deathstreak_7", duration = line_duration, continue = true})
			elseif victim_death_streak == 8 then
				Notifications:BottomToAll({text = "#imba_deathstreak_8", duration = line_duration, continue = true})
			elseif victim_death_streak == 9 then
				Notifications:BottomToAll({text = "#imba_deathstreak_9", duration = line_duration, continue = true})
			elseif victim_death_streak >= 10 then
				Notifications:BottomToAll({text = "#imba_deathstreak_10", duration = line_duration, continue = true})
			end
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Rancor logic
	-------------------------------------------------------------------------------------------------

	-- Victim stack loss
	local victim_hero = PlayerResource:GetPickedHero(victim_id)
	if victim_hero and victim_hero:HasModifier("modifier_imba_rancor") then
		local current_stacks = victim_hero:GetModifierStackCount("modifier_imba_rancor", VENGEFUL_RANCOR_CASTER)
		if current_stacks <= 2 then
			victim_hero:RemoveModifierByName("modifier_imba_rancor")
		else
			victim_hero:SetModifierStackCount("modifier_imba_rancor", VENGEFUL_RANCOR_CASTER, current_stacks - math.floor(current_stacks / 2) - 1)
		end
	end

	-- Killer stack gain
	if victim_hero and VENGEFUL_RANCOR and PlayerResource:IsImbaPlayer(killer_id) and killer_team ~= VENGEFUL_RANCOR_TEAM then
		local eligible_rancor_targets = FindUnitsInRadius(victim_hero:GetTeamNumber(), victim_hero:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		if eligible_rancor_targets[1] then
			local rancor_stacks = 1

			-- Double stacks if the killed unit was Venge
			if victim_hero == VENGEFUL_RANCOR_CASTER then
				rancor_stacks = rancor_stacks * 2
			end

			-- Add stacks and play particle effect
			AddStacks(VENGEFUL_RANCOR_ABILITY, VENGEFUL_RANCOR_CASTER, eligible_rancor_targets[1], "modifier_imba_rancor", rancor_stacks, true)
			local rancor_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_negative_aura.vpcf", PATTACH_ABSORIGIN, eligible_rancor_targets[1])
			ParticleManager:SetParticleControl(rancor_pfx, 0, eligible_rancor_targets[1]:GetAbsOrigin())
			ParticleManager:SetParticleControl(rancor_pfx, 1, VENGEFUL_RANCOR_CASTER:GetAbsOrigin())
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Vengeance Aura logic
	-------------------------------------------------------------------------------------------------

	if victim_hero and PlayerResource:IsImbaPlayer(killer_id) then
		local vengeance_aura_ability = victim_hero:FindAbilityByName("imba_vengeful_command_aura")
		local killer_hero = PlayerResource:GetPickedHero(killer_id)
		if vengeance_aura_ability and vengeance_aura_ability:GetLevel() > 0 then
			vengeance_aura_ability:ApplyDataDrivenModifier(victim_hero, killer_hero, "modifier_imba_command_aura_negative_aura", {})
			victim_hero.vengeance_aura_target = killer_hero
		end
	end
end

-- An entity died
function GameMode:OnEntityKilled( keys )
	GameMode:_OnEntityKilled( keys )

	-- The Unit that was killed
	local killed_unit = EntIndexToHScript( keys.entindex_killed )

	-- The Killing entity
	local killer = nil

	if keys.entindex_attacker then
		killer = EntIndexToHScript( keys.entindex_attacker )
	end

	if killed_unit then
		------------------------------------------------
		-- Api Event Unit Killed
		------------------------------------------------

		killedUnitName = tostring(killed_unit:GetUnitName())

		if (killedUnitName ~= "") then

			killedPlayer = "-1"

			if killed_unit:IsRealHero() and killed_unit:GetPlayerID() then
				killedPlayerId = killed_unit:GetPlayerID()
				killedPlayer = PlayerResource:GetSteamID(killedPlayerId)
			end

			killerUnitName = "-1"
			killerPlayer = "-1"
			if (killer ~= nil) then
				killerUnitName = tostring(killer:GetUnitName())
				if (killer:IsRealHero() and killer:GetPlayerID()) then
					killerPlayerId = killer:GetPlayerID()
					killerPlayer = PlayerResource:GetSteamID(killerPlayerId)
				end
			end

			api.imba.event(api.events.unit_killed, {
					tostring(killerUnitName),
					tostring(killerPlayer),
					tostring(killedUnitName),
					tostring(killedPlayer)
				})
		end

		-------------------------------------------------------------------------------------------------
		-- IMBA: Ancient destruction detection
		-------------------------------------------------------------------------------------------------
		if killed_unit:GetUnitName() == "npc_dota_badguys_fort" then
			GAME_WINNER_TEAM = 2
		elseif killed_unit:GetUnitName() == "npc_dota_goodguys_fort" then
			GAME_WINNER_TEAM = 3
		end

		-- Check if the dying unit was a player-controlled hero
		if killed_unit:IsRealHero() and killed_unit:GetPlayerID() then
			if killer:GetTeamNumber() == 4 then
				CombatEvents("kill", "neutrals_kill_hero", killed_unit)
			end

			-- reset killstreak if not comitted suicide
			if killer ~= killed_unit then
				killed_unit.killstreak = 0
			end

			-- stop thinking if cavern map
			if GetMapName() == "cavern" then
				return
			elseif GetMapName() == "imba_overthrow" then
				Overthrow:OnEntityKilled(killer, killed_unit)
			else
				GameMode:OnHeroKilled(killer, killed_unit)

				if IsMutationMap() then
					Mutation:OnHeroDeath(killed_unit)
				end
			end
		elseif killed_unit:IsBuilding() then
			if string.find(killed_unit:GetUnitName(), "tower3") then
				local unit_name = "npc_dota_goodguys_healers"
				if killed_unit:GetTeamNumber() == 3 then
					unit_name = "npc_dota_badguys_healers"
				end

				local units = FindUnitsInRadius(killed_unit:GetTeamNumber(), Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

				for _, building in pairs(units) do
					if building:GetUnitName() == unit_name or string.find(building:GetUnitName(), "npc_imba_donator_statue_") then
						if building:HasModifier("modifier_invulnerable") then
							building:RemoveModifierByName("modifier_invulnerable")
						end
					end
				end
			end

			if killer:IsRealHero() then
				CombatEvents("kill", "hero_kill_tower", killed_unit, killer)
			else
				CombatEvents("generic", "tower", killed_unit, killer)
			end

			if GetMapName() == "imba_1v1" then
				local winner = 2

				if killed_unit:GetTeamNumber() == 2 then
					winner = 3
				end

				GAME_WINNER_TEAM = winner
				GameRules:SetGameWinner(winner)
			end
		elseif killed_unit:IsCourier() then
			CombatEvents("generic", "courier_dead", killed_unit)
		elseif killed_unit:GetUnitName() == "npc_imba_roshan" then
			CombatEvents("kill", "roshan_dead", killed_unit, killer)
		end

		if killer:IsRealHero() then
			if killer == killed_unit then
				CombatEvents("kill", "hero_suicide", killed_unit)
				return
			elseif killed_unit:IsRealHero() and killer:GetTeamNumber() == killed_unit:GetTeamNumber() then
				CombatEvents("kill", "hero_deny_hero", killed_unit, killer)
			end
		elseif killer:IsBuilding() then
			if killed_unit:IsRealHero() then
				CombatEvents("generic", "tower_kill_hero", killed_unit, killer)
			end
		end

		if killed_unit.pedestal then
			killed_unit.pedestal:ForceKill(false)
		end
	end
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
	GameMode:_OnConnectFull(keys)

	local entIndex = keys.index+1
	local ply = EntIndexToHScript(entIndex)
	local player_id = ply:GetPlayerID()

	api.imba.event(api.events.player_connected, { tostring(PlayerResource:GetSteamID(player_id)) })
	-------------------------------------------------------------------------------------------------
	-- IMBA: Player data initialization
	-------------------------------------------------------------------------------------------------
	log.info("Player has fully connected:", player_id)

	--	if player.is_dev then
	--		CustomGameEventManager:Send_ServerToPlayer(player:GetPlayerOwner(), "show_netgraph", {})
	--	end

	CustomGameEventManager:Send_ServerToAllClients("send_news", {})

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player reconnect logic
	-------------------------------------------------------------------------------------------------
	ReconnectPlayer(player_id)

	PlayerResource:InitPlayerData(player_id)
end

-- This function is called whenever an item is combined to create a new item
function GameMode:OnItemCombined(keys)
	-- The playerID of the hero who is buying something
	local plyID = keys.PlayerID
	if not plyID then return end
	local hero = PlayerResource:GetSelectedHeroEntity(plyID)
	local itemName = keys.itemname
	local itemcost = keys.itemcost

	api.imba.event(api.events.item_combined, {
			tostring(keys.itemname),
			tostring(hero:GetUnitName()),
			tostring(PlayerResource:GetSteamID(plyID))
		})
end

-- This function is called whenever a tower is killed
function GameMode:OnTowerKill(keys)
	local gold = keys.gold
	local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
	local tower_team = keys.teamnumber

	local towers = FindUnitsInRadius(tower_team, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

	for _, tower in pairs(towers) do
		UpgradeTower(tower)
	end

	-- Display upgrade message and play ominous sound
	if tower_team == DOTA_TEAM_GOODGUYS then
		Notifications:BottomToAll({text = "#tower_abilities_radiant_upgrade", duration = 7, style = {color = "DodgerBlue"}})
		EmitGlobalSound("powerup_01")
	else
		Notifications:BottomToAll({text = "#tower_abilities_dire_upgrade", duration = 7, style = {color = "DodgerBlue"}})
		EmitGlobalSound("powerup_02")
	end
end

--[[
function GameMode:OnPlayerTeam(keys)
	local id = keys.userid -1
	local team = keys.team
	local old_team = keys.oldteam
	local hero = PlayerResource:GetSelectedHeroEntity(id)

--	PrintTable(keys)

	print(id, PLAYER_TEAM[id], old_team, team)
	if PLAYER_TEAM[id] and old_team ~= team then
		if hero and team ~= PLAYER_TEAM[id] and team == 5 then
			print("Player should stay in team "..old_team.." (attempt to be in team "..team..")")

			hero:SetTeam(PLAYER_TEAM[id])
			if hero:GetPlayerOwner() then
				hero:GetPlayerOwner():SetTeam(PLAYER_TEAM[id])
			end

			PlayerResource:UpdateTeamSlot(id, PLAYER_TEAM[id], 0)
			PlayerResource:SetCustomTeamAssignment(id, PLAYER_TEAM[id]) -- LIA don't use this line
		end
	end
end
--]]
