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

require('events/combat_events')
require('events/npc_spawned/on_hero_spawned')
require('events/npc_spawned/on_unit_spawned')
require('events/on_entity_killed/on_hero_killed')

function GameMode:OnGameRulesStateChange(keys)
	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		InitItemIds()
		HeroSelection:Init() -- init picking screen kv (this function is a bit heavy to run)
		OnSetGameMode() -- setup gamemode rules
		TeamSelection:InitializeTeamSelection()
		GetPlayerInfoIXP() -- Add a class later
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		api.imba.event(api.events.entered_hero_selection)
		HeroSelection:StartSelection()
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
		api.imba.event(api.events.entered_pre_game)
		COURIER_TEAM = {}
		COURIER_TEAM[2] = CreateUnitByName("npc_dota_courier", Entities:FindByClassname(nil, "info_courier_spawn_radiant"):GetAbsOrigin(), true, nil, nil, 2)
		COURIER_TEAM[3] = CreateUnitByName("npc_dota_courier", Entities:FindByClassname(nil, "info_courier_spawn_dire"):GetAbsOrigin(), true, nil, nil, 3)
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		api.imba.event(api.events.started_game)
	elseif newState == DOTA_GAMERULES_STATE_POST_GAME then
		api.imba.event(api.events.entered_post_game)
	end
end

dummy_created_count = 0

function GameMode:OnNPCSpawned(keys)
	GameMode:_OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)

	if npc then
		-- UnitSpawned Api Event
		local player = "-1"

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

function GameMode:OnDisconnect(keys)
	-- GetConnectionState values:
	-- 0 - no connection
	-- 1 - bot connected
	-- 2 - player connected
	-- 3 - bot/player disconnected.

	-- Typical keys:
	-- PlayerID: 2
	-- name: Zimberzimber
	-- networkid: [U:1:95496383]
	-- reason: 2
	-- splitscreenplayer: -1
	-- userid: 7
	-- xuid: 76561198055762111

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player disconnect/abandon logic
	-------------------------------------------------------------------------------------------------

	-- If the game hasn't started, or has already ended, do nothing
	if (GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME) or (GameRules:State_Get() < DOTA_GAMERULES_STATE_PRE_GAME) then
		return nil
			-- Else, start tracking player's reconnect/abandon state
	else
		-- Fetch player's player and hero information
		local player_id = keys.PlayerID
		local player_name = keys.name
		local hero = PlayerResource:GetPickedHero(player_id)
		local hero_name = PlayerResource:GetPickedHeroName(player_id)
		local line_duration = 7

		-- Start tracking
		log.info("started keeping track of player "..player_id.."'s connection state")
		api.imba.event(api.events.player_disconnected, { tostring(PlayerResource:GetSteamID(player_id)) })

		local disconnect_time = 0
		Timers:CreateTimer(1, function()
			-- Keep track of time disconnected
			disconnect_time = disconnect_time + 1

			-- If the player has abandoned the game, set his gold to zero and distribute passive gold towards its allies
			if disconnect_time >= ABANDON_TIME then
				-- Abandon message
				Notifications:BottomToAll({hero = hero_name, duration = line_duration})
				Notifications:BottomToAll({text = player_name.." ", duration = line_duration, continue = true})
				Notifications:BottomToAll({text = "#imba_player_abandon_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})
				PlayerResource:SetHasAbandonedDueToLongDisconnect(player_id, true)
				log.info("player "..player_id.." has abandoned the game.")

				api.imba.event(api.events.player_abandoned, { tostring(PlayerResource:GetSteamID(player_id)) })

				-- Start redistributing this player's gold to its allies
				PlayerResource:StartAbandonGoldRedistribution(player_id)
				-- If the player has reconnected, stop tracking connection state every second
			elseif PlayerResource:GetConnectionState(player_id) == 2 then

			-- Else, keep tracking connection state
			else
				log.info("tracking player "..player_id.."'s connection state, disconnected for "..disconnect_time.." seconds.")
				return 1
			end
		end)

--		print("Increase GG amount!")
--		local table = {
--			ID = player_id,
--			team = PlayerResource:GetTeam(player_id),
--			disconnect = 1
--		}
--		GameMode:GG(table)
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

			if GetMapName() == "imba_overthrow" then
				Overthrow:OnEntityKilled(killer, killed_unit)
			else
				GameMode:OnHeroKilled(killer, killed_unit)

				if IsMutationMap() then
					Mutation:OnHeroDeath(killed_unit)
				end
			end
			return
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

			if GetMapName() == Map1v1() then
				local winner = 2

				if killed_unit:GetTeamNumber() == 2 then
					winner = 3
				end

				GAME_WINNER_TEAM = winner
				GameRules:SetGameWinner(winner)
			end
			return
		elseif killed_unit:IsCourier() then
			CombatEvents("generic", "courier_dead", killed_unit)
			return
		elseif killed_unit:GetUnitName() == "npc_imba_roshan" then
			CombatEvents("kill", "roshan_dead", killed_unit, killer)
			return
		end

		if killer:IsRealHero() then
			if killer:GetTeam() ~= killed_unit:GetTeam() and killed_unit:GetGoldBounty() > 0 then
				SendOverheadEventMessage(killer:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, killed_unit, killed_unit:GetGoldBounty(), nil)
			end
			if killer == killed_unit then
				CombatEvents("kill", "hero_suicide", killed_unit)
				return
			elseif killed_unit:IsRealHero() and killer:GetTeamNumber() == killed_unit:GetTeamNumber() then
				CombatEvents("kill", "hero_deny_hero", killed_unit, killer)
				return
			end
			return
		elseif killer:IsBuilding() then
			if killed_unit:IsRealHero() then
				CombatEvents("generic", "tower_kill_hero", killed_unit, killer)
				return
			end
			return
		end

		if killed_unit.pedestal then
			killed_unit.pedestal:ForceKill(false)
		end
	end
end

function GameMode:OnItemPickedUp(keys)
	local unitEntity = nil
	if keys.UnitEntitIndex then
		unitEntity = EntIndexToHScript(keys.UnitEntitIndex)
	elseif keys.HeroEntityIndex then
		unitEntity = EntIndexToHScript(keys.HeroEntityIndex)
	end

	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local itemname = keys.itemname
end

function GameMode:OnPlayerReconnect(keys)
	
end

function GameMode:OnAbilityUsed(keys)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local abilityname = keys.abilityname
end

function GameMode:OnPlayerLevelUp(keys)
	local player = EntIndexToHScript(keys.player)
	local level = keys.level
end

function GameMode:PlayerConnect(keys)

end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
	local entIndex = keys.index + 1
	local ply = EntIndexToHScript(entIndex)
	local playerID = ply:GetPlayerID()
end

-- This function is called whenever any player sends a chat message to team or All
function GameMode:OnPlayerChat(keys)
	local teamonly = keys.teamonly
	local userID = keys.userid
--	local playerID = self.vUserIds[userID]:GetPlayerID()

	local text = keys.text
end

-- TODO: FORMAT THIS GARBAGE
function GameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME then return nil end
	if GameRules:IsGamePaused() then return 1 end

	CheatDetector()

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME or GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if IsMutationMap() then
			Mutation:OnThink()
		end
	end

	for _, hero in pairs(HeroList:GetAllHeroes()) do
		-- Make courier controllable, repeat every second to avoid uncontrollable issues
		if COURIER_TEAM then
			if COURIER_TEAM[hero:GetTeamNumber()] and not COURIER_TEAM[hero:GetTeamNumber()]:IsControllableByAnyPlayer() then
				COURIER_TEAM[hero:GetTeamNumber()]:SetControllableByPlayer(hero:GetPlayerID(), true)
			end
		end

		-- Undying talent fix
		if hero.undying_respawn_timer then
			if hero.undying_respawn_timer > 0 then
				hero.undying_respawn_timer = hero.undying_respawn_timer -1
			end

			break
		end

		-- Lone Druid fixes
		if hero:GetUnitName() == "npc_dota_hero_lone_druid" and hero.savage_roar then
			local Bears = FindUnitsInRadius(hero:GetTeam(), Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
			for _, Bear in pairs(Bears) do
				if Bear and string.find(Bear:GetUnitName(), "npc_dota_lone_druid_bear") and Bear:FindAbilityByName("lone_druid_savage_roar_bear") and Bear:FindAbilityByName("lone_druid_savage_roar_bear"):IsHidden() then
					Bear:FindAbilityByName("lone_druid_savage_roar_bear"):SetHidden(false)
				end

				break
			end
		elseif hero:GetUnitName() == "npc_dota_hero_morphling" and hero:GetModelName() == "models/heroes/morphling/morphling.vmdl" then
			for _, modifier in pairs(MORPHLING_RESTRICTED_MODIFIERS) do
				if hero:HasModifier(modifier) then
					hero:RemoveModifierByName(modifier)
				end
			end
		elseif hero:GetUnitName() == "npc_dota_hero_witch_doctor" then
			if hero:HasTalent("special_bonus_imba_witch_doctor_6") then
				if not hero:HasModifier("modifier_imba_voodoo_restoration") then
					local ability = hero:FindAbilityByName("imba_witch_doctor_voodoo_restoration")
					hero:AddNewModifier(hero, ability, "modifier_imba_voodoo_restoration", {})
				end
			end
		end

		-- Tusk fixes
		if hero:FindModifierByName("modifier_tusk_snowball_movement") then
			if hero:FindAbilityByName("tusk_snowball") then
				hero:FindAbilityByName("tusk_snowball"):SetActivated(false)
			end
		else
			if hero:FindAbilityByName("tusk_snowball") then
				hero:FindAbilityByName("tusk_snowball"):SetActivated(true)
			end
		end

		-- Find hidden modifiers
--		for i = 0, hero:GetModifierCount() -1 do
--			print(hero:GetUnitName(), hero:GetModifierNameByIndex(i))
--		end
	end

	if GetMapName() == "imba_overthrow" then
		self:UpdateScoreboard()
		self:ThinkGoldDrop() -- TODO: Enable this
		self:ThinkSpecialItemDrop()
		CountdownTimer()

		if nCOUNTDOWNTIMER == 30 then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
		end

		if nCOUNTDOWNTIMER <= 0 then
			--Check to see if there's a tie
			if isGameTied == false then
				GameRules:SetCustomVictoryMessage( m_VictoryMessages[leadingTeam] )
				GameMode:EndGame( leadingTeam )
				countdownEnabled = false
				return nil
			else
				TEAM_KILLS_TO_WIN = leadingTeamScore + 1
				local broadcast_killcount =
				{
					killcount = TEAM_KILLS_TO_WIN
				}

				CustomGameEventManager:Send_ServerToAllClients( "overtime_alert", broadcast_killcount )
			end
		end
	elseif GetMapName() == "cavern" then
	else
		if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			-- End the game if one team completely abandoned
			if CustomNetTables:GetTableValue("game_options", "game_count").value == 1 then
				if not TEAM_ABANDON then
					TEAM_ABANDON = {} -- 15 second to abandon, is_abandoning?, player_count.
					TEAM_ABANDON[2] = {FULL_ABANDON_TIME, false, 0}
					TEAM_ABANDON[3] = {FULL_ABANDON_TIME, false, 0}
				end

				TEAM_ABANDON[2][3] = PlayerResource:GetPlayerCountForTeam(2)
				TEAM_ABANDON[3][3] = PlayerResource:GetPlayerCountForTeam(3)

				for ID = 0, PlayerResource:GetPlayerCount() -1 do
					local team = PlayerResource:GetTeam(ID)

					if PlayerResource:GetConnectionState(ID) ~= 2 then -- if disconnected then
						TEAM_ABANDON[team][3] = TEAM_ABANDON[team][3] -1
					end

					if TEAM_ABANDON[team][3] > 0 then
						TEAM_ABANDON[team][2] = false
					else
						if TEAM_ABANDON[team][2] == false then
							local abandon_text = "#imba_team_good_abandon_message"
							if team == 3 then
								abandon_text = "#imba_team_bad_abandon_message"
							end
							Notifications:BottomToAll({text = abandon_text.." ("..tostring(TEAM_ABANDON[team][1])..")", duration = 1.0, style = {color = "DodgerBlue"} })
						end

						TEAM_ABANDON[team][2] = true
						TEAM_ABANDON[team][1] = TEAM_ABANDON[team][1] -1

						if TEAM_ABANDON[2][1] <= 0 then
							GAME_WINNER_TEAM = 3
							GameRules:SetGameWinner(3)
						elseif TEAM_ABANDON[3][1] <= 0 then
							GAME_WINNER_TEAM = 2
							GameRules:SetGameWinner(2)
						end
					end
				end
			end
		end
	end

	if i == nil then i = AP_GAME_TIME -1
	elseif i < 0 then
		if PICKING_SCREEN_OVER == false then
			PICKING_SCREEN_OVER = true
		end

		return 1
	else
		i = i - 1
	end

--	print("i = "..i)

	return 1
end
