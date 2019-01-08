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

require('events/combat_events')
require('events/npc_spawned/on_hero_spawned')
require('events/npc_spawned/on_unit_spawned')
require('events/on_entity_killed/on_hero_killed')

function GameMode:OnGameRulesStateChange(keys)
	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		InitItemIds()
		GameMode:OnSetGameMode() -- setup gamemode rules
		InitializeTeamSelection()
		GetPlayerInfoIXP() -- Add a class later
		Imbattlepass:Init() -- Initialize Battle Pass

		if GetMapName() == "imba_demo" then
			require('components/demo/init')
			self:InitDemo()
		end

		-- temporary (from stat-collection)
		-- Build players array
		--		local players = {}
		--		for playerID = 0, PlayerResource:GetPlayerCount() - 1 do
		--			if PlayerResource:IsValidPlayerID(playerID) then
		--				players.steamID64 = PlayerResource:GetSteamID(playerID)
		--			end
		--		end

		--		local req = CreateHTTPRequestScriptVM("GET", "http://51.75.249.243/file_name.php")
		--		local req = CreateHTTPRequestScriptVM("GET", "http://51.75.249.243/opt/lampp/htdocs/dota2imba/db_scripts/fichier.php")
		--		local encoded = json.encode(payload)
		--		if self.TESTING then
		--			statCollection:print(encoded)
		--		end

		--		-- Add the data
		--		req:SetHTTPRequestGetOrPostParameter('payload', encoded)

		--		-- Send the request
		--		req:Send(function(res)
		--			print(res.StatusCode)
		--			if res.StatusCode ~= 200 then
		--				return
		--			end

		--			print(res.Body)
		--			if not res.Body then
		--				print(errorEmptyServerResponse)
		--				print("Status Code", res.StatusCode)
		--				return
		--			end

		--			-- Try to decode the result
		--			local obj, pos, err = json.decode(res.Body, 1, nil)

		--			-- Feed the result into our callback
		--			callback(err, obj)
		--		end)

		-- setup Player colors into hex for panorama
		local hex_colors = {}
		for i = 0, PlayerResource:GetPlayerCount() - 1 do
			table.insert(hex_colors, i, rgbToHex(PLAYER_COLORS[i]))
		end

		Timers:CreateTimer(2.0, function()
			if BOTS_ENABLED == true then
				SendToServerConsole('sm_gmode 1')
				SendToServerConsole('dota_bot_populate')
			end

			if GetMapName() == MapOverthrow() then
				require("components/overthrow/imbathrow")
				GoodCamera = Entities:FindByName(nil, "@overboss")
				BadCamera = Entities:FindByName(nil, "@overboss")

				local xp_granters = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, Entities:FindByName(nil, "@overboss"):GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

				for _, granter in pairs(xp_granters) do
					if string.find(granter:GetUnitName(), "npc_dota_xp_granter") then
						granter:RemoveSelf()
						break
					end
				end
			else
				GoodCamera = Entities:FindByName(nil, "good_healer_6")
				BadCamera = Entities:FindByName(nil, "bad_healer_6")
			end

			HeroSelection:Init()
		end)

		CustomNetTables:SetTableValue("game_options", "player_colors", hex_colors)
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		if IMBA_PICK_SCREEN == false then
--			for i = 0, PlayerResource:GetPlayerCount() - 1 do
--				if PlayerResource:IsValidPlayer(i) then
--					if PlayerResource:GetTeam(i) == DOTA_TEAM_GOODGUYS then
--						PlayerResource:SetCameraTarget(i, GoodCamera)
--					else
--						PlayerResource:SetCameraTarget(i, BadCamera)
--					end
--				end
--			end

			if IsInToolsMode() then
				for i = 1, PlayerResource:GetPlayerCount() - 1 do
					if PlayerResource:IsValidPlayer(i) then
						PlayerResource:GetPlayer(i):MakeRandomHeroSelection()
						PlayerResource:SetCanRepick(i, false)
					end
				end
			end
		end
	elseif newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		for i = 0, PlayerResource:GetPlayerCount() - 1 do
			if PlayerResource:IsValidPlayer(i) and not PlayerResource:HasSelectedHero(i) and PlayerResource:GetConnectionState(i) == DOTA_CONNECTION_STATE_CONNECTED then
				PlayerResource:GetPlayer(i):MakeRandomHeroSelection()
				PlayerResource:SetCanRepick(i, false)
			end
		end
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
--		api.imba.event(api.events.entered_pre_game)

		api:InitDonatorTableJS()

		if GetMapName() == MapOverthrow() then
			GoodCamera:AddNewModifier(GoodCamera, nil, "modifier_overthrow_gold_xp_granter", {})
			GoodCamera:AddNewModifier(GoodCamera, nil, "modifier_overthrow_gold_xp_granter_global", {})
		else
			self:SetupContributors()
			self:SetupFrostivus()
			self:SetupShrines()
		end

		local fountainEntities = Entities:FindAllByClassname("ent_dota_fountain")
		for _, fountainEnt in pairs(fountainEntities) do
			local danger_zone_pfx = ParticleManager:CreateParticle("particles/ambient/fountain_danger_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(danger_zone_pfx, 0, fountainEnt:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(danger_zone_pfx)
		end

		-- Create a timer to avoid lag spike entering pick screen
		Timers:CreateTimer(3.0, function()
			if USE_TEAM_COURIER == true then
				COURIER_TEAM = {}
				COURIER_TEAM[2] = CreateUnitByName("npc_dota_courier", Entities:FindByClassname(nil, "info_courier_spawn_radiant"):GetAbsOrigin(), true, nil, nil, 2)
				COURIER_TEAM[3] = CreateUnitByName("npc_dota_courier", Entities:FindByClassname(nil, "info_courier_spawn_dire"):GetAbsOrigin(), true, nil, nil, 3)
			end

			-- IMBA: Custom maximum level EXP tables adjustment
			local max_level = tonumber(CustomNetTables:GetTableValue("game_options", "max_level")["1"])
			if max_level and max_level > 25 then
				local j = 26
				Timers:CreateTimer(function()
					if j >= max_level then
						return
					end
					for i = j, j + 2 do
						XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i - 1] + 3500
						GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(XP_PER_LEVEL_TABLE)
					end
					j = j + 2
					return 1.0
				end)
			end

			-- Initialize IMBA Runes system
			if IMBA_RUNE_SYSTEM == true then
				ImbaRunes:Init()
			end

			-- Setup topbar player colors
			CustomGameEventManager:Send_ServerToAllClients("override_top_bar_colors", {})

			if IMBA_PICK_SCREEN == false then
				local line_duration = 5
	
				-- First line
				Notifications:BottomToAll( {text = "#imba_introduction_line_01", duration = line_duration, style = {color = "DodgerBlue"} } )
				Notifications:BottomToAll( {text = "#imba_introduction_line_02", duration = line_duration, style = {color = "Orange"}, continue = true})
				Notifications:BottomToAll( {text = "("..IMBA_VERSION..")", duration = line_duration, style = {color = "Orange"}, continue = true})

				-- Second line
				Timers:CreateTimer(line_duration, function()
					Notifications:BottomToAll( {text = "#imba_introduction_line_03", duration = line_duration, style = {color = "DodgerBlue"} }	)

					-- Third line
					Timers:CreateTimer(line_duration, function()
						Notifications:BottomToAll( {text = "#imba_introduction_line_04", duration = line_duration, style = {["font-size"] = "30px", color = "Orange"} }	)
					end)
				end)
			end
		end)
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--		api.imba.event(api.events.started_game)

		-- start rune timers
		if GetMapName() == Map1v1() then
			Setup1v1()
		else
			if IsMutationMap() or IsSuperFranticMap() then
				SpawnEasterEgg()
			end

			ImbaRunes:Spawn()
		end

		-- add abilities to all towers
		local towers = Entities:FindAllByClassname("npc_dota_tower")

		for _, tower in pairs(towers) do
			SetupTower(tower)
		end

		if IsMutationMap() then
			Timers:CreateTimer(function()
				Mutation:OnSlowThink()
				return 60.0
			end)
		end

	elseif newState == DOTA_GAMERULES_STATE_POST_GAME then
		api:CompleteGame(function(data, payload)
			CustomGameEventManager:Send_ServerToAllClients("end_game", {
				players = payload.players,
				data = data,
				info = {
					winner = GAME_WINNER_TEAM,
					id = api:GetApiGameId(),
					radiant_score = GetTeamHeroKills(2),
					dire_score = GetTeamHeroKills(3),
				},
			})
		end)
	end
end

function GameMode:OnNPCSpawned(keys)
	GameMode:_OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)

	if npc then
		-- UnitSpawned Api Event
		local player = "-1"

		if npc:IsRealHero() and npc:GetPlayerID() then
			player = PlayerResource:GetSteamID(npc:GetPlayerID())
		end

		--		api.imba.event(api.events.unit_spawned, {
		--			tostring(npc:GetUnitName()),
		--			tostring(player)
		--		})

		if npc:IsCourier() then
			if npc.first_spawn == true then
				CombatEvents("generic", "courier_respawn", npc)
			else
				npc:AddAbility("courier_movespeed"):SetLevel(1)
				npc.first_spawn = true
			end

			return
		elseif npc:IsRealHero() or npc:IsFakeHero() then
			if npc.first_spawn ~= true then
				npc.first_spawn = true

				-- Need a frame time to detect illusions
				Timers:CreateTimer(FrameTime(), function()
					GameMode:OnHeroFirstSpawn(npc)
				end)

				return
			end

			GameMode:OnHeroSpawned(npc)

			return
		elseif string.find(npc:GetUnitName(), "tower") then
			print("Tower Spawned!")
			SetupTower(npc)
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

	-- IMBA: Player disconnect/abandon logic
	-- If the game hasn't started, or has already ended, do nothing
	if (GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME) or (GameRules:State_Get() < DOTA_GAMERULES_STATE_PRE_GAME) then
		return nil
		-- Else, start tracking player's reconnect/abandon state
	else
		-- Fetch player's player and hero information
		if keys.PlayerID == nil or keys.PlayerID == -1 then
			return
		end
		local player_id = keys.PlayerID
		local player_name = keys.name
		if PlayerResource:GetPlayer(player_id):GetAssignedHero() == nil then
			return
		end
		local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
		local line_duration = 7

		-- Start tracking
		--		print("started keeping track of player "..player_id.."'s connection state")
		--		api.imba.event(api.events.player_disconnected, { tostring(PlayerResource:GetSteamID(player_id)) })

		local disconnect_time = 0
		Timers:CreateTimer(1, function()
			-- Keep track of time disconnected
			disconnect_time = disconnect_time + 1

			-- If the player has abandoned the game, set his gold to zero and distribute passive gold towards its allies
			if disconnect_time >= ABANDON_TIME then
				-- Abandon message
				Notifications:BottomToAll({ hero = hero:GetUnitName(), duration = line_duration })
				Notifications:BottomToAll({ text = player_name .. " ", duration = line_duration, continue = true })
				Notifications:BottomToAll({ text = "#imba_player_abandon_message", duration = line_duration, style = { color = "DodgerBlue" }, continue = true })
				PlayerResource:SetHasAbandonedDueToLongDisconnect(player_id, true)
				print("player " .. player_id .. " has abandoned the game.")

				--				api.imba.event(api.events.player_abandoned, { tostring(PlayerResource:GetSteamID(player_id)) })

				-- Start redistributing this player's gold to its allies
				PlayerResource:StartAbandonGoldRedistribution(player_id)
				-- If the player has reconnected, stop tracking connection state every second
			elseif PlayerResource:GetConnectionState(player_id) == 2 then

				-- Else, keep tracking connection state
			else
				--				print("tracking player "..player_id.."'s connection state, disconnected for "..disconnect_time.." seconds.")
				return 1
			end
		end)

		local table = {
			ID = player_id,
			team = PlayerResource:GetTeam(player_id),
			disconnect = 1
		}

		GoodGame:Call(table)
	end
end

-- An entity died
function GameMode:OnEntityKilled(keys)
	GameMode:_OnEntityKilled(keys)

	-- The Unit that was killed
	local killed_unit = EntIndexToHScript(keys.entindex_killed)

	-- The Killing entity
	local killer = nil

	if keys.entindex_attacker then
		killer = EntIndexToHScript(keys.entindex_attacker)
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

			--			api.imba.event(api.events.unit_killed, {
			--				tostring(killerUnitName),
			--				tostring(killerPlayer),
			--				tostring(killedUnitName),
			--				tostring(killedPlayer)
			--			})
		end

		-------------------------------------------------------------------------------------------------
		-- IMBA: Ancient destruction detection
		-------------------------------------------------------------------------------------------------
		if killed_unit:GetUnitName() == "npc_dota_badguys_fort" then
			GAME_WINNER_TEAM = 2
			return
		elseif killed_unit:GetUnitName() == "npc_dota_goodguys_fort" then
			GAME_WINNER_TEAM = 3
			return
		end

		if IMBA_DIRETIDE == true then
			Diretide:OnEntityKilled(killer, killed_unit)
		end

		-- Check if the dying unit was a player-controlled hero
		if killed_unit:IsRealHero() and killed_unit:GetPlayerID() then
			GameMode:OnHeroDeath(killer, killed_unit)

			if IsMutationMap() then
				Mutation:OnHeroDeath(killed_unit)
			end

			if IMBA_GOLD_SYSTEM == true then
				GoldSystem:OnHeroDeath(killer, killed_unit)
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

			-- if killer:IsRealHero() then
			-- CombatEvents("kill", "hero_kill_tower", killed_unit, killer)
			-- if killer:GetTeam() ~= killed_unit:GetTeam() then
			-- if killed_unit:GetUnitName() == "npc_dota_goodguys_healers" or killed_unit:GetUnitName() == "npc_dota_badguys_healers" then
			-- SendOverheadEventMessage(killer:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, killed_unit, 125, nil)
			-- else
			-- SendOverheadEventMessage(killer:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, killed_unit, 200, nil)
			-- end
			-- end
			-- else
			-- CombatEvents("generic", "tower_dead", killed_unit, killer)
			-- end

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
		else
			if IsMutationMap() then
				Mutation:OnUnitDeath(killed_unit)
			end
		end

		if killed_unit.pedestal then
			killed_unit.pedestal:ForceKill(false)
		end
	end
end

function GameMode:OnAbilityUsed(keys)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local abilityname = keys.abilityname

	for _, ability in pairs(IMBA_ABILITIES_IGNORE_CDR) do
		if ability == abilityname then
			if player:GetAssignedHero() then
				if player:GetAssignedHero():FindAbilityByName(ability) then
					local ab = player:GetAssignedHero():FindAbilityByName(ability)
					ab:StartCooldown(ab:GetCooldown(ab:GetLevel()))
				end
			end

			break
		end
	end
end

function GameMode:OnPlayerLevelUp(keys)
	local player = EntIndexToHScript(keys.player)
	local hero = player:GetAssignedHero()
	if hero == nil then
		return
	end
	local level = keys.level
	local hero_attribute = hero:GetPrimaryAttribute()
	if hero_attribute == nil or hero:IsFakeHero() then
		return
	end

	hero:SetCustomDeathXP(HERO_XP_BOUNTY_PER_LEVEL[level])

	if hero:GetLevel() > 25 then
		if hero:GetUnitName() == "npc_dota_hero_meepo" then
			for _, hero in pairs(HeroList:GetAllHeroes()) do
				if hero:GetUnitName() == "npc_dota_hero_meepo" and hero:IsClone() then
					if not hero:HasModifier("modifier_imba_war_veteran_" .. hero_attribute) then
						hero:AddNewModifier(hero, nil, "modifier_imba_war_veteran_" .. hero:GetCloneSource():GetPrimaryAttribute(), {}):SetStackCount(math.min(hero:GetCloneSource():GetLevel() - 25, 17))
					else
						hero:FindModifierByName("modifier_imba_war_veteran_" .. hero:GetCloneSource():GetPrimaryAttribute()):SetStackCount(math.min(hero:GetCloneSource():GetLevel() - 25, 17))
					end
				end
			end
		end

		-- TODO: error sometimes on this line: "hero:AddNewModifier(hero, nil, "modifier_imba_war_veteran_"..hero_attribute, {}):SetStackCount(1)""
		if not hero:HasModifier("modifier_imba_war_veteran_" .. hero_attribute) then
			hero:AddNewModifier(hero, nil, "modifier_imba_war_veteran_" .. hero_attribute, {}):SetStackCount(1)
		elseif hero:HasModifier("modifier_imba_war_veteran_" .. hero_attribute) then
			hero:FindModifierByName("modifier_imba_war_veteran_" .. hero_attribute):SetStackCount(math.min(hero:GetLevel() - 25, 17))
		end

		hero:SetAbilityPoints(hero:GetAbilityPoints() - 1)
	end

	if hero:GetUnitName() == "npc_dota_hero_invoker" then
		hero:FindAbilityByName("invoker_invoke"):SetLevel(min(math.floor(level / 6 + 1), 4))
	end
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
	end

	-- initiate talent!
	if abilityname:find("special_bonus_imba_") == 1 then
		hero:AddNewModifier(hero, nil, "modifier_" .. abilityname, {})
	end

	if abilityname == "lone_druid_savage_roar" and not hero.savage_roar then
		hero.savage_roar = true
	end

	--	if hero then
	--		api.imba.event(api.events.ability_learned, {
	--			tostring(abilityname),
	--			tostring(hero:GetUnitName()),
	--			tostring(PlayerResource:GetSteamID(player:GetPlayerID()))
	--		})
	--	end
end
--[[
function GameMode:PlayerConnect(keys)

end
--]]
-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
	local entIndex = keys.index + 1
	local ply = EntIndexToHScript(entIndex)
	local playerID = ply:GetPlayerID()

	ReconnectPlayer(playerID)

	--	PlayerResource:InitPlayerData(playerID)
end

-- This function is called whenever any player sends a chat message to team or All
function GameMode:OnPlayerChat(keys)
	local teamonly = keys.teamonly
	local userID = keys.userid
	--	local playerID = self.vUserIds[userID]:GetPlayerID()

	local text = keys.text

	local steamid = tostring(PlayerResource:GetSteamID(keys.playerid))
	api.Message("C[" .. steamid .. "] " .. tostring(text))

	-- This Handler is only for commands, ends the function if first character is not "-"
	if not (string.byte(text) == 45) then
		return nil
	end

	local caster = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()

	for str in string.gmatch(text, "%S+") do
		if IsInToolsMode() or GameRules:IsCheatMode() and (api.imba ~= nil and api.imba.is_developer(steamid)) then
			if str == "-dev_remove_units" then
				GameMode:RemoveUnits(true, true, true)
			end

			if str == "-spawnimbarune" then
				ImbaRunes:Spawn()
			end

			if str == "-replaceherowith" then
				text = string.gsub(text, str, "")
				text = string.gsub(text, " ", "")
				if PlayerResource:GetSelectedHeroName(caster:GetPlayerID()) ~= "npc_dota_hero_" .. text then
					if caster.companion then
						caster.companion:ForceKill(false)
						caster.companion = nil
					end

					if IMBA_PICK_SCREEN == true then
						PrecacheUnitByNameAsync("npc_dota_hero_" .. text, function()
							HeroSelection:GiveStartingHero(caster:GetPlayerID(), "npc_dota_hero_" .. text, true)
						end)
					else
						local old_hero = PlayerResource:GetSelectedHeroEntity(caster:GetPlayerID())
						PrecacheUnitByNameAsync("npc_dota_hero_" .. text, function()
							PlayerResource:ReplaceHeroWith(caster:GetPlayerID(), "npc_dota_hero_" .. text, 0, 0)

							Timers:CreateTimer(1.0, function()
								if old_hero then
									UTIL_Remove(old_hero)
								end
							end)
						end)
					end
				end
			end

			if str == "-getwearable" then
				Wearables:PrintWearables(caster)
			end
		end

		if str == "-gg" then
			CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "gg_init_by_local", {})
		end
	end
end

-- TODO: FORMAT THIS GARBAGE
function GameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	if GameRules:IsGamePaused() then
		return 1
	end

	CheatDetector()

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME or GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if IsMutationMap() then
			Mutation:OnThink()
		end
	end

	for _, hero in pairs(HeroList:GetAllHeroes()) do
		if api:GetDonatorStatus(hero:GetPlayerID()) == 10 then
			if not IsNearFountain(hero:GetAbsOrigin(), 1200) then
				local pos = Vector(-6700, -7165, 1509)
				if hero:GetTeamNumber() == 3 then
					pos = Vector(7168, 5750, 1431)
				end
				hero:SetAbsOrigin(pos)
			end
		end

		-- Make courier controllable, repeat every second to avoid uncontrollable issues
		if COURIER_TEAM then
			if COURIER_TEAM[hero:GetTeamNumber()] and not COURIER_TEAM[hero:GetTeamNumber()]:IsControllableByAnyPlayer() then
				COURIER_TEAM[hero:GetTeamNumber()]:SetControllableByPlayer(hero:GetPlayerID(), true)
			end
		end

		-- Undying talent fix
		if hero.undying_respawn_timer then
			if hero.undying_respawn_timer > 0 then
				hero.undying_respawn_timer = hero.undying_respawn_timer - 1
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
		--		if hero:GetUnitName() == "npc_dota_hero_skeleton_king" then
		--			for i = 0, hero:GetModifierCount() -1 do
		--				print(hero:GetUnitName(), hero:GetModifierNameByIndex(i))
		--			end
		--		end
	end

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		-- End the game if one team completely abandoned
		if CustomNetTables:GetTableValue("game_options", "game_count").value == 1 then
			if not TEAM_ABANDON then
				TEAM_ABANDON = {} -- 15 second to abandon, is_abandoning?, player_count.
				TEAM_ABANDON[2] = { FULL_ABANDON_TIME, false, 0 }
				TEAM_ABANDON[3] = { FULL_ABANDON_TIME, false, 0 }
			end

			TEAM_ABANDON[2][3] = PlayerResource:GetPlayerCountForTeam(2)
			TEAM_ABANDON[3][3] = PlayerResource:GetPlayerCountForTeam(3)

			for ID = 0, PlayerResource:GetPlayerCount() - 1 do
				local team = PlayerResource:GetTeam(ID)

				if PlayerResource:GetConnectionState(ID) ~= 2 then
					-- if disconnected then
					TEAM_ABANDON[team][3] = TEAM_ABANDON[team][3] - 1
				end

				if TEAM_ABANDON[team][3] > 0 then
					TEAM_ABANDON[team][2] = false
				else
					if TEAM_ABANDON[team][2] == false then
						local abandon_text = "#imba_team_good_abandon_message"
						if team == 3 then
							abandon_text = "#imba_team_bad_abandon_message"
						end
						Notifications:BottomToAll({ text = abandon_text .. " (" .. tostring(TEAM_ABANDON[team][1]) .. ")", duration = 1.0, style = { color = "DodgerBlue" } })
					end

					TEAM_ABANDON[team][2] = true
					TEAM_ABANDON[team][1] = TEAM_ABANDON[team][1] - 1

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

	if i == nil then
		i = AP_GAME_TIME - 1
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

	if GetMapName() == Map1v1() then
		if nTeamKills == IMBA_1V1_SCORE then
			GAME_WINNER_TEAM = killer_team
			GameRules:SetGameWinner(killer_team)
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Deathstreak logic
	-------------------------------------------------------------------------------------------------
	if victim_id ~= nil and victim_id ~= -1 then
		if PlayerResource:IsValidPlayerID(killer_id) and PlayerResource:IsValidPlayerID(victim_id) then
			if killer_id ~= -1 then
				PlayerResource:ResetDeathstreak(killer_id)
			end

			PlayerResource:IncrementDeathstreak(victim_id)

			-- Show Deathstreak message
			if PlayerResource.GetPlayer == nil then
				return
			end

			if PlayerResource:GetPlayer(victim_id).GetAssignedHero == nil then
				return
			end

			if PlayerResource:GetPlayer(victim_id):GetAssignedHero() == nil then
				return
			end

			local victim_hero = PlayerResource:GetPlayer(victim_id):GetAssignedHero()
			local victim_player_name = PlayerResource:GetPlayerName(victim_id)
			local victim_death_streak = PlayerResource:GetDeathstreak(victim_id)
			local line_duration = 7

			if victim_death_streak then
				if victim_death_streak >= 3 then
					Notifications:BottomToAll({ hero = victim_hero:GetUnitName(), duration = line_duration })
					Notifications:BottomToAll({ text = victim_player_name .. " ", duration = line_duration, continue = true })
				end

				if victim_death_streak == 3 then
					Notifications:BottomToAll({ text = "#imba_deathstreak_3", duration = line_duration, continue = true })
				elseif victim_death_streak == 4 then
					Notifications:BottomToAll({ text = "#imba_deathstreak_4", duration = line_duration, continue = true })
				elseif victim_death_streak == 5 then
					Notifications:BottomToAll({ text = "#imba_deathstreak_5", duration = line_duration, continue = true })
				elseif victim_death_streak == 6 then
					Notifications:BottomToAll({ text = "#imba_deathstreak_6", duration = line_duration, continue = true })
				elseif victim_death_streak == 7 then
					Notifications:BottomToAll({ text = "#imba_deathstreak_7", duration = line_duration, continue = true })
				elseif victim_death_streak == 8 then
					Notifications:BottomToAll({ text = "#imba_deathstreak_8", duration = line_duration, continue = true })
				elseif victim_death_streak == 9 then
					Notifications:BottomToAll({ text = "#imba_deathstreak_9", duration = line_duration, continue = true })
				elseif victim_death_streak >= 10 then
					Notifications:BottomToAll({ text = "#imba_deathstreak_10", duration = line_duration, continue = true })
				end
			end
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Rancor logic
	-------------------------------------------------------------------------------------------------

	-- TODO: Format this into venge's hero file
	-- Victim stack loss
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
		local killer_hero = PlayerResource:GetPlayer(killer_id):GetAssignedHero()
		if vengeance_aura_ability and vengeance_aura_ability:GetLevel() > 0 then
			vengeance_aura_ability:ApplyDataDrivenModifier(victim_hero, killer_hero, "modifier_imba_command_aura_negative_aura", {})
			victim_hero.vengeance_aura_target = killer_hero
		end
	end
end

-- A rune was activated by a player
function GameMode:OnRuneActivated(keys)
	local hero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()

	if keys.rune == DOTA_RUNE_ILLUSION then
		ImbaRunes:PickupRune("illusion", hero, false)
	end
end
