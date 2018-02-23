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
--     suthernfriend, 03.02.2018

require("api/api")
require("api/json")

ImbaApiFrontendPreloaded = {}

ImbaApiFrontendReady_ = false

ImbaApiFrontendSettings = {
	debug = true,
	eventTimer = 100
}

-- Asyncronous
-- has to be called in GameMode:OnFirstPlayerLoaded
-- loads donators / developers and registers the game
-- complete_fun is called once all preload requests are finished
function ImbaApiFrontendInit(CompleteFunction)

	ImbaApiFrontendPrint("Initializing API")

	local ProxyFunction = function ()
		if ImbaApiFrontendPreloaded.donators ~= nil
			and ImbaApiFrontendPreloaded.developers ~= nil
			and ImbaApiFrontendPreloaded.players ~= nil
			and ImbaApiFrontendPreloaded.topXpUsers ~= nil
			and ImbaApiFrontendPreloaded.topImrUsers ~= nil
			and ImbaApiFrontendPreloaded.hotDisabledHeroes ~= nil
			and ImbaApiFrontendPreloaded.companions ~= nil
		then
			ImbaApiFrontendReady_ = true
			ImbaApiFrontendPrint("Preloading completed")
			CompleteFunction()
		end
	end

	ImbaApiFrontendPreload(ProxyFunction)
	ImbaApiFrontendGameRegister(ProxyFunction)
	ImbaApiFrontendEventsRun()
end

function ImbaApiFrontendReady()
	return ImbaApiFrontendReady_
end

--
-- Asyncronous
-- has to be called in GameMode:OnFirstPlayerLoaded
-- will be called by imba_api_init()
-- loads donators, developers and top lists
-- complete_fun is called each time one api request is finished
--
function ImbaApiFrontendPreload(CompleteFunction)

	ImbaApiFrontendPrint("Preloading API data")

	ImbaApiInstance:MetaDonators(function (donors)
		ImbaApiFrontendPreloaded.donators = donors
		CompleteFunction()
	end)

	ImbaApiInstance:MetaDevelopers(function (devs)
		ImbaApiFrontendPreloaded.developers = devs
		CompleteFunction()
	end)

	ImbaApiInstance:MetaTopXpUsers(function (users)
		ImbaApiFrontendPreloaded.topXpUsers = users
		CompleteFunction()
	end)

	ImbaApiInstance:MetaTopImrUsers(function (users)
		ImbaApiFrontendPreloaded.topImrUsers = users
		CompleteFunction()
	end)

	ImbaApiInstance:MetaHotDisabledHeroes(function (heroes)
		ImbaApiFrontendPreloaded.hotDisabledHeroes = heroes
		CompleteFunction()
	end)

	ImbaApiInstance:MetaCompanions(function (heroes)
		ImbaApiFrontendPreloaded.companions = heroes
		CompleteFunction()
	end)
end

function ImbaApiPlayersLoaded()
	return ImbaApiFrontendPreloaded.player ~= nil
end

-- Syncronous
-- returns array of developers or nil
-- [ 7666611212312, 78877721371727, 7887272727711, ... ]
function GetDonators()
	return ImbaApiFrontendPreloaded.donators
end

-- Syncronous
-- returns
--   a string with the path to the companion model 	 if the player owning the hero is a donator
-- 	 nil											 if the hero doesnt have a player or is an illusion
--   false											 if the player is not a donator
-- WTF: COOKIES: DOCUMENTATION
function IsDonator(hero)
	if hero:GetPlayerID() == -1 or hero:IsIllusion() or ImbaApiFrontendPreloaded.donators == nil then return end
	for i = 1, #ImbaApiFrontendPreloaded.donators do
		if tostring(PlayerResource:GetSteamID(hero:GetPlayerID())) == ImbaApiFrontendPreloaded.donators[i].steamId64 then
			return ImbaApiFrontendPreloaded.donators[i].model
		elseif i == #ImbaApiFrontendPreloaded.donators then
			return false
		end
	end
end

-- Syncronous
-- returns array of developers or nil
-- [ 7666611212312, 78877721371727, 7887272727711, ... ]
function GetDevelopers()
	return ImbaApiFrontendPreloaded.developers
end

-- Syncronous
-- Returns true if the player with the given id is a developer, false otherwise
function IsDeveloper(playerid)
	if GetDevelopers() == nil then return end
	local devs = GetDevelopers()

	for i = 1, #devs do
		local id = tostring(PlayerResource:GetSteamID(playerid))
		if id == devs[i].steamId64 then
			return true
		end
	end

	return false
end

-- Syncronous
-- Returns a list with all companions
function GetAllCompanions()
	return ImbaApiFrontendPreloaded.companions
end

-- Asyncronous
-- Changes the companion model for a user
-- playerid = ingame id of player p.e. '1'
-- newcompanion: the file name of the companion p.e. 'npc_imba_donator_companion_demi_doom'
-- callback: the function that is executed when the request is completed
function ChangeCompanion(playerid, newCompanion, callback)
	local id = tostring(PlayerResource:GetSteamID(playerid))

	ImbaApiFrontendPreloaded.MetaCompanionChange({
		steamid = id,
		model = newCompanion,
	}, callback, callback)

end


-- Syncronous
-- Returns array of the top users by xp
-- [ {
--    xp: number
--    imr_5v5: number
--    imr_10v10: number
--    imr_5v5_calibrating: boolean
--    imr_10v10_calibrating: boolean
--    steamName: string
--    steamid: string
--    rank: number
-- }, ... ]
function GetTopXpUsers()
	return ImbaApiFrontendPreloaded.topXpUsers
end

-- Syncronous
-- Returns array of the top users by imr
-- [ {
--    xp: number
--    imr_5v5: number
--    imr_10v10: number
--    imr_5v5_calibrating: boolean
--    imr_10v10_calibrating: boolean
--    steamName: string
--    steamid: string
--    rank: number
-- }, ... ]
function GetTopImrUsers()
	return ImbaApiFrontendPreloaded.topImrUsers
end

-- Returns the preloaded xp for player / if available
-- {
--    xp: number
--    imr_5v5: number
--    imr_10v10: number
--    imr_5v5_calibrating: boolean
--    imr_10v10_calibrating: boolean
-- }
function GetStatsForPlayer(ID)
	local steamid = tostring(PlayerResource:GetSteamID(ID))
	if ImbaApiFrontendPreloaded.players ~= nil and ImbaApiFrontendPreloaded.players[steamid] ~= nil then
		return ImbaApiFrontendPreloaded.players[steamid];
	else
		return nil
	end
end

function HeroIsHotDisabled(hero)
	if ImbaApiFrontendPreloaded.hotDisabledHeroes == nil then
		return false
	end

	for i = 1, #ImbaApiFrontendPreloaded.hotDisabledHeroes do
		if ImbaApiFrontendPreloaded.hotDisabledHeroes[i] == hero then
			return true
		end
	end
	return false
end

-- Returns the gameid
function GetApiGameId()
	return ImbaApiFrontendPreloaded.id
end

-- Saves a print message to server
function ApiPrint(str)
	ApiEvent(ApiEventCodes.Log, { str });
end

--
-- Event API
--
ApiEventCodes = {
	Log = 1, 					-- (text)
	PlayerConnected = 2,		-- (steamid)
	PlayerAbandoned = 3,		-- (steamid)
	EnteredHeroSelection = 4,	-- ()
	StartedGame = 5,			-- ()
	EnteredPreGame = 6,			-- ()
	EnteredPostGame = 7,		-- ()
	PlayerDisconnected = 8,		-- (steamid)
	ItemPurchased = 9,			-- (item_name, hero_name, steamid)
	AbilityLearned = 10,		-- (ability_name, hero_name, steamid)
	--	HeroKilled = 11,			-- (killer_unit, killer_steamid, dead_unit, dead_steamid)
	--	HeroRespawned = 12,			-- (hero_name, steamid)
	HeroLevelUp = 13,			-- (hero_name, level, steamid)
	--	BuildingKilled = 14,		-- (killed_unit, killed_team, unit_name, steamid)
	--	CourierKilled = 15,			-- (courier_team, killer_unit, steamid)
	--	RoshanKilled = 16,			-- (killer_unit, steamid)
	UnitKilled = 17,			-- (killer_unit, killer_steamid, dead_unit, dead_steamid)
	AbilityUsed = 18,			-- (hero_name, ability, steamid)
	--	ItemUsed = 19,				-- (hero_name, steamid, item)
	Timing = 20,				-- ()
	UnitSpawned = 21			-- (unit_name, steamid)
}

function ImbaApiFrontendEventToString(eventCode)
	for k,v in pairs(ApiEventCodes) do
		if v == eventCode then
			return tostring(k)
		end
	end
	return tostring(eventCode)
end

function ImbaApiFrontendDebug(t)
	if ImbaApiFrontendSettings.debug then
		print("[api-frontend-debug] " .. t)
	end
end

function ImbaApiFrontendPrint(t)
	if tostring(PlayerResource:GetSteamID(0)) == "76561198015161808" then
		return
	else
		print("[api-frontend] " .. t)
	end
end

function trim1(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- Event Queue
ImbaApiFrontendEventQueue = {}

-- Event Queue Loop
function ImbaApiFrontendEventsRun()
	Timers:CreateTimer(ImbaApiFrontendSettings.eventTimer, function ()
		ImbaApiFrontendEventsCycle()
		return ImbaApiFrontendSettings.eventTimer
	end)
end

function ImbaApiFrontendEventsCycle()

	ImbaApiFrontendDebug("Sending events")

	-- copy and empty queue
	local copy = ImbaApiFrontendEventQueue
	ImbaApiFrontendEventQueue = {}

	ImbaApiFrontendDebug(tostring(table.getn(copy)) .. " events")

	ImbaApiInstance:GameEvents({
		id = ImbaApiFrontendPreloaded.id,
		events = copy
	}, function (response)
		ImbaApiFrontendDebug("Events written")
	end, function ()
		ImbaApiFrontendPrint("Error writing game events")
	end)

end

-- Will write a custom game event to the server
-- event and content mandatory, tag optional
function ApiEvent(event, content)

	ImbaApiFrontendDebug("Saving game event")

	-- print message
	local text = ""
	if content ~= nil then
		for i = 1, #content do
			text = text .. content[i] .. " "
		end
	end

	text = trim1(text)

	ImbaApiFrontendDebug("Sending Event " .. ImbaApiFrontendEventToString(event) .. " with content '" .. text .. "'")

	-- enque game event
	local rcontent = content
	if content == nil then
		rcontent = json.null
	end

	table.insert(ImbaApiFrontendEventQueue, {
		event = tonumber(event),
		content = rcontent,
		frames = tonumber(GetFrameCount()),
		server_system_datetime = tostring(GetSystemDate()) .. " " .. tostring(GetSystemTime()),
		server_time = tonumber(Time())
	})
end

-- auto order teams
function ImbaApiAutoOrderImr5v5Random(players, callback)
	ImbaApiInstance:GameAutoOrderImr5v5Random({
		players = players,
		teams = 2
	}, function (data)
		callback({ ok = true, data = data })
	end, function (err)
		callback({ ok = false, data = data })
	end)
end

function ImbaApiAutoOrderImr10v10KeepTeams(players, groupings, callback)
	ImbaApiInstance:GameAutoOrderImr10v10KeepTeams({
		players = players,
		groupings = groupings,
		teams = 2
	}, function (data)
		callback({ ok = true, data = data })
	end, function (err)
		callback({ ok = false, data = data })
	end)
end

-- returns the match id as integer
function ImbaApiGetMatchId()
	return tonumber(tostring(GameRules:GetMatchID()))
end

-- has to be called in GameMode:OnFirstPlayerLoaded
-- will be called by imba_api_init()
-- registers the game in the server and requests an id.
function ImbaApiFrontendGameRegister(CompleteFunction)

	-- get players
	local players = {}
	local leader = nil
	local MatchId = ImbaApiGetMatchId()

	-- for each player / get its id
	for playerID = 0, DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidPlayerID(playerID) then
			local player = PlayerResource:GetPlayer( playerID )
			local id = PlayerResource:GetSteamID(playerID)
			table.insert(players, tostring(id))

			-- if this is the leader set him to our var
			if GameRules:PlayerHasCustomGameHostPrivileges(player) then
				leader = tostring(id)
			end
		end
	end

	-- test if this is a dedicated server
	local dedicated = false
	if IsDedicatedServer() then
		dedicated = true
	end

	-- final object
	local args = {
		match_id = tonumber(MatchId),
		map = tostring(GetMapName()),
		leader = leader,
		dedicated = true,
		players = players
	}

	-- perform request
	ImbaApiInstance:GameRegister(args, function (data)
		ImbaApiFrontendDebug("Request good: ID: " .. tostring(data.id))
		ImbaApiFrontendPreloaded.players = data.players
		ImbaApiFrontendPreloaded.id = data.id
		CompleteFunction()
	end, function (err)
		ImbaApiFrontendPrint("Game Register Request failed!")
		ImbaApiFrontendPreloaded.id = 0
	end)

end

local MAX_ITEM_SLOT = 14

-- Has to be called in DOTA_GAMERULES_STATE_POST_GAME
-- Collects stats infos and saves them to the server
-- Will later be used for IMR and XP changes
--
-- complete_fun will get a table as argument: https://hastebin.com/ubopezureh.json
--
function ImbaApiFrontendGameComplete(CompleteFunction)

	local args = {
		id = ImbaApiFrontendPreloaded.id,
		winner = GAME_WINNER_TEAM,
		results = {}
	}

	-- for each player
	for pid = 0, DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidPlayerID(pid) then
			local player = PlayerResource:GetPlayer(pid)
			local id = tostring(PlayerResource:GetSteamID(pid))

			local hero = PlayerResource:GetPickedHero(pid)
			local items = {}

			if hero == nil then
				ImbaApiFrontendPrint("Hero for player " .. id .. " is nil")
			else
				-- get all items
				-- inventory + backpack
				for slot = 0, MAX_ITEM_SLOT do
					local item = hero:GetItemInSlot(slot)
					if item ~= nil then
						table.insert(items, tostring(item:GetAbilityName()))
					end
				end
			end

			local rhero = json.null
			if hero ~= nil then
				rhero = tostring(hero:GetUnitName())
			end

			-- final object for user
			args.results[id] = {
				team = tonumber(PlayerResource:GetTeam(pid)),
				hero = rhero,
				items = items,
				aegis_pickups = tonumber(PlayerResource:GetAegisPickups(pid)),
				assists = tonumber(PlayerResource:GetAssists(pid)),
				claimed_denies = tonumber(PlayerResource:GetClaimedDenies(pid)),
				claimed_farm = tonumber(PlayerResource:GetClaimedFarm(pid, true)),
				claimed_misses = tonumber(PlayerResource:GetClaimedMisses(pid)),
				connection_state = tonumber(PlayerResource:GetConnectionState(pid)),
				creep_damage_taken = tonumber(PlayerResource:GetCreepDamageTaken(pid)),
				deaths = tonumber(PlayerResource:GetDeaths(pid)),
				denies = tonumber(PlayerResource:GetDenies(pid)),
				gold = tonumber(PlayerResource:GetGold(pid)),
				gold_lost_to_death = tonumber(PlayerResource:GetGoldLostToDeath(pid)),
				gold_per_minute = tonumber(PlayerResource:GetGoldPerMin(pid)),
				gold_spent_on_buybacks = tonumber(PlayerResource:GetGoldSpentOnBuybacks(pid)),
				gold_spent_on_consumables = tonumber(PlayerResource:GetGoldSpentOnConsumables(pid)),
				gold_spent_on_items = tonumber(PlayerResource:GetGoldSpentOnItems(pid)),
				gold_spent_on_support = tonumber(PlayerResource:GetGoldSpentOnSupport(pid)),
				healing = tonumber(PlayerResource:GetHealing(pid)),
				hero_damage_taken = tonumber(PlayerResource:GetHeroDamageTaken(pid)),
				kills = tonumber(PlayerResource:GetKills(pid)),
				last_hit_multikill = tonumber(PlayerResource:GetLastHitMultikill(pid)),
				last_hits = tonumber(PlayerResource:GetLastHits(pid)),
				last_hit_streak = tonumber(PlayerResource:GetLastHitStreak(pid)),
				level = tonumber(PlayerResource:GetLevel(pid)),
				misses = tonumber(PlayerResource:GetMisses(pid)),
				nearby_creep_deaths = tonumber(PlayerResource:GetNearbyCreepDeaths(pid)),
				consumables_purchased = tonumber(PlayerResource:GetNumConsumablesPurchased(pid)),
				items_purchased = tonumber(PlayerResource:GetNumItemsPurchased(pid)),
				player_name = tostring(PlayerResource:GetPlayerName(pid)),
				raw_player_damage = tonumber(PlayerResource:GetRawPlayerDamage(pid)),
				reliable_gold = tonumber(PlayerResource:GetReliableGold(pid)),
				roshan_kills = tonumber(PlayerResource:GetRoshanKills(pid)),
				rune_pickups = tonumber(PlayerResource:GetRunePickups(pid)),
				streak = tonumber(PlayerResource:GetStreak(pid)),
				stuns = tonumber(PlayerResource:GetStuns(pid)),
				total_earned_gold = tonumber(PlayerResource:GetTotalEarnedGold(pid)),
				total_earned_xp = tonumber(PlayerResource:GetTotalEarnedXP(pid)), -- in the API but returns nil
				total_gold_spent = tonumber(PlayerResource:GetTotalGoldSpent(pid)),
				tower_damage_taken = tonumber(PlayerResource:GetTowerDamageTaken(pid)),
				tower_kills = tonumber(PlayerResource:GetTowerKills(pid)),
				unreliable_gold = tonumber(PlayerResource:GetUnreliableGold(pid)),
				xp_per_minute = tonumber(PlayerResource:GetXPPerMin(pid)), -- in the API but returns nil
				team = tonumber(PlayerResource:GetTeam(pid)),
				valid_player = true
			};
		end
	end

	-- perform request
	ImbaApiInstance:GameComplete(args, function (data)
		ImbaApiFrontendDebug("Request good (Game save)")

		-- data contains info about changed xp and changed imr:
		if CompleteFunction ~= nil then
			CompleteFunction(data.players)
		end
	end, function (err)
		if (err == nil) then
			ImbaApiFrontendPrint("Game complete request failed with nil")
		elseif (err.message ~= nil) then
			ImbaApiFrontendPrint("Game complete request failed :" .. err.message)
		end
		ImbaApiFrontendDebug("Request failed!")
	end)

	ImbaApiFrontendDebug("Saving game to server")
end
