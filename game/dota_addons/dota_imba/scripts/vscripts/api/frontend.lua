---
--- Simple syncronous API frontend. UNSAFE
---

require("api/api")
require("api/json")

api_preloaded = {}

-- Asyncronous
-- has to be called in GameMode:OnFirstPlayerLoaded
-- loads donators / developers and registers the game
-- complete_fun is called once all preload requests are finished 
function imba_api_init(complete_fun)

	print("[api-frontend] init")

	local proxy_fun = function () 
		if api_preloaded.donators ~= nil 
			and api_preloaded.developers ~= nil 
			and api_preloaded.players ~= nil
			and api_preloaded.topxpusers ~= nil 
			and api_preloaded.topimrusers ~= nil
		then
			print("[api-frontend] preloading completed")
			complete_fun()
		end
	end

	imba_api_preload(proxy_fun)
	imba_api_game_register(proxy_fun)
end

--
-- Asyncronous
-- has to be called in GameMode:OnFirstPlayerLoaded
-- will be called by imba_api_init()
-- loads donators, developers and top lists
-- complete_fun is called each time one api request is finished
--
function imba_api_preload(complete_fun)

	print("[api-frontend] preloading")

	imba_api():meta_donators(function (donors)
	   api_preloaded.donators = donors
	   complete_fun()
	end)

	imba_api():meta_developers(function (devs)
		api_preloaded.developers = devs
		complete_fun()
	end)

	imba_api():meta_topxpusers(function (users)
		api_preloaded.topxpusers = users
		complete_fun()
	end)

	imba_api():meta_topimrusers(function (users)
		api_preloaded.topimrusers = users
		complete_fun()
	end)
end

-- Syncronous
-- returns 
--   a string with the path to the companion model 	 if the player owning the hero is a donator
-- 	 nil											 if the hero doesnt have a player or is an illusion
--   false											 if the player is not a donator
-- WTF: COOKIES: DOCUMENTATION
function IsDonator(hero)
	if hero:GetPlayerID() == -1 or hero:IsIllusion() or api_preloaded.donators == nil then return end
	for i = 1, #api_preloaded.donators do
		if tostring(PlayerResource:GetSteamID(hero:GetPlayerID())) == api_preloaded.donators[i].steamId64 then
			return api_preloaded.donators[i].model
		elseif i == #api_preloaded.donators then
			return false
		end
	end
end

-- Syncronous
-- returns array of developers or nil
-- [ 7666611212312, 78877721371727, 7887272727711, ... ]
function GetDevelopers()
	return api_preloaded.developers
end

-- Syncronous
-- Returns true if the player with the given id is a developer, false otherwise
function IsDeveloper(playerid)
	local devs = GetDevelopers()
	for i = 1, #devs do
		local id = tostring(PlayerResource:GetSteamID(pid))
		if id == devs[i] then
			return true
		end
	end

	return false
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
	return api_preloaded.topxpusers
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
	return api_preloaded.topimrusers
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
	if api_preloaded.players ~= nil and api_preloaded.players[steamid] ~= nil then
		return api_preloaded.players[steamid];
	else
		return nil
	end
end

-- Saves a print message to server
function ApiPrint(str)
	imba_api_game_event("debug", str);
end

-- Will write a custom game event to the server
-- event and content mandatory, tag optional 
function imba_api_game_event(event, content, tag)

	print("[api-frontend] Saving event")

	local rtag = json.null

	if (type(tag) ~= "nil") then
		rtag = tostring(tag)
	end

	imba_api():game_event({ 
		id = api_preloaded.id,
		event = tostring(event),
		content = tostring(content),
		tag = rtag
	}, function (response) end, 
		function () print("[api-frontend] Error writing game event") end)
end

-- returns the match id as integer
function imba_api_get_match_id() 
	return tonumber(tostring(GameRules:GetMatchID()))
end

-- has to be called in GameMode:OnFirstPlayerLoaded 
-- will be called by imba_api_init()
-- registers the game in the server and requests an id.
function imba_api_game_register(complete_fun)
	
	-- get players
	local players = {}
	local leader = nil
	local match_id = imba_api_get_match_id()
	
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
		match_id = tonumber(match_id),
		map = tostring(GetMapName()),
		leader = leader,
		dedicated = true,
		players = players
	}

	-- perform request
	imba_api():game_register(args, function (data) 
		print("[api-frontend] Request good: ID: " .. tostring(data.id))
		api_preloaded.players = data.players
		api_preloaded.id = data.id
		complete_fun()
	end, function (err)
		print("[api-frontend] Request failed!")
		api_preloaded.id = 0
	end)

end

local MAX_ITEM_SLOT = 14

-- Has to be called in DOTA_GAMERULES_STATE_POST_GAME
-- Collects stats infos and saves them to the server
-- Will later be used for IMR and XP changes
-- 
-- complete_fun will get a table as argument: https://hastebin.com/ubopezureh.json        
-- 
function imba_api_game_complete(complete_fun)

	local args = {
		id = api_preloaded.id,
		winner = GAME_WINNER_TEAM,
		results = {}
	}

	ApiPrint("game_complete Before player info collection")
	ApiPrint("game_complete player count in game_complete: " .. tostring(PlayerResource:GetPlayerCount()))

	-- for each player
	for pid = 0, DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidPlayerID(pid) then
			local player = PlayerResource:GetPlayer(pid)
			local id = tostring(PlayerResource:GetSteamID(pid))

			local hero = PlayerResource:GetPickedHero(pid)
			local items = {}

			if hero == nil then
				ApiPrint("Hero for player " .. id .. " is nil")
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

	ApiPrint(json.encode(args))
	ApiPrint("game_complete after player info collection");

	-- perform request
	imba_api():game_complete(args, function (data)
		ApiPrint("Request good")
		print("[api-frontend] Request good (Game save)")

		-- data contains info about changed xp and changed imr:
		if complete_fun ~= nil then
			complete_fun(data.players)
		end
	end, function (err)
		if (err == nil) then
			ApiPrint("request failed with nil")
		elseif (err.message ~= nil) then
			ApiPrint("request failed :" .. err.message)
		end
		print("[api-frontend] Request failed!")
	end)

	ApiPrint("Serialization successful")
	print("[api-frontend] Saving game to server")
end
