---
--- Simple syncronous API frontend. UNSAFE
---

require("api/api")
require("api/json")

local api_preloaded = {}

-- has to be called in GameMode:OnFirstPlayerLoaded
-- loads donators / developers and registers the game
function imba_api_init(complete_fun)

	print("[api-frontend] init")

	local proxy_fun = function () 
		if api_preloaded.donators ~= nil and api_preloaded.developers ~= nil and api_preloaded.players ~= nil then
			complete_fun()
		end
	end

	imba_api_preload(proxy_fun)
	imba_api_game_register(proxy_fun)
end

-- has to be called in GameMode:OnFirstPlayerLoaded
-- will be called by imba_api_init()
-- loads donators and developers
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
end

-- Syncronous
-- returns array of donators or nil
function IsDonator(hero)
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
function get_developers()
	return api_preloaded.developers
end

-- Returns the preloaded xp for player / if available
-- {
--    xp: number
--    imr_5v5: number
--    imr_10v10: number
--    imr_5v5_calibrating: boolean
--    imr_10v10_calibrating: boolean
-- }
function get_stats_for_player(ID)
	local steamid = tostring(PlayerResource:GetSteamID(ID))
	if api_preloaded.players ~= nil and api_preloaded.players[steamid] ~= nil then
		return api_preloaded.players[steamid];
	else
		return nil
	end
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

-- Saves a print message to server
function ApiPrint(str)
	imba_api_game_event("debug", str);
end

-- Experience System
CustomNetTables:SetTableValue("game_options", "game_count", {value = 0})
XP_level_table = {0,100,200,300,400,500,700,900,1100,1300,1500,1800,2100,2400,2700,3000,3400,3800,4200,4600,5000}
--------------    0  1   2   3   4   5   6   7    8    9   10   11   12   13   14   15   16   17   18   19   20

local bonus = 0
for i = 21 +1, 500 do
	bonus = bonus +10
	XP_level_table[i] = XP_level_table[i-1] + 500 + bonus
end

function GetTitleIXP(level)
	if level <= 19 then
		return "Rookie"
	elseif level <= 39 then
		return "Amateur"
	elseif level <= 59 then
		return "Captain"
	elseif level <= 79 then
		return "Warrior"
	elseif level <= 99 then
		return "Commander"
	elseif level <= 119 then
		return "General"
	elseif level <= 139 then
		return "Master"
	elseif level <= 159 then
		return "Epic"
	elseif level <= 179 then
		return "Legendary"
	elseif level <= 199 then
		return "Ancient"
	elseif level <= 299 then
		return "Amphibian"..level-200
	elseif level <= 399 then
		return "Icefrog"..level-300
	else 
		return "Firetoad "..level-400
	end
end

function GetTitleColorIXP(title, js)
	if js == true then
		if title == "Rookie" then
			return "#FFFFFF"
		elseif title == "Amateur" then
			return "#66CC00"
		elseif title == "Captain" then
			return "#4C8BCA"
		elseif title == "Warrior" then
			return "#004C99"
		elseif title == "Commander" then
			return "#985FD1"
		elseif title == "General" then
			return "#460587"
		elseif title == "Master" then
			return "#FA5353"
		elseif title == "Epic" then
			return "#8E0C0C"
		elseif title == "Legendary" then
			return "#EFBC14"
		elseif title == "Icefrog" then
			return "#1456EF"
		else -- it's Firetoaaaaaaaaaaad! 
			return "#C75102"
		end
	else
		if title == "Rookie" then
			return {255, 255, 255}
		elseif title == "Amateur" then
			return {102, 204, 0}
		elseif title == "Captain" then
			return {76, 139, 202}
		elseif title == "Warrior" then
			return {0, 76, 153}
		elseif title == "Commander" then
			return {152, 95, 209}
		elseif title == "General" then
			return {70, 5, 135}
		elseif title == "Master" then
			return {250, 83, 83}
		elseif title == "Epic" then
			return {142, 12, 12}
		elseif title == "Legendary" then
			return {239, 188, 20}
		elseif title == "Icefrog" then
			return {20, 86, 239}
		else -- it's Firetoaaaaaaaaaaad! 
			return {199, 81, 2}
		end
	end
end

function CountGameIXP()
	if CHEAT_ENABLED == true then
		print("CHEATS: Game will not record xp.")
		return
	else
		Timers:CreateTimer(GAME_COUNT_DELAY, function()
			CustomNetTables:SetTableValue("game_options", "game_count", {value = 1})
		end)
	end
end

function GetPlayerInfoIXP()
local xp_required_levelup = 0
local current_xp_in_level = 0
local level = 0

	for ID = 0, PlayerResource:GetPlayerCount() -1 do
		local current_xp = get_stats_for_player(ID).xp
		for i = #XP_level_table, 1, -1 do
			-- if the player has less than 0 xp, set to 0 and return end cause we don't need to go further
			if current_xp < 0 then
				CustomNetTables:SetTableValue("player_table", tostring(ID), {XP = current_xp})
			else
				-- setup the xp into the level
				current_xp_in_level = current_xp - XP_level_table[i]

				-- setup the level
				level = i-1

				-- setup the xp required to reach the next level
				if i ~= #XP_level_table then
					xp_required_levelup = XP_level_table[i+1] - tonumber(current_xp)
				end
			end
		end

		print("XP:", current_xp)
		print("Max XP:", xp_required_levelup + current_xp_in_level)
		print("Level:", level)
		print("ID:", ID)
		print("Title:", GetTitleIXP(level))
		print("Title Color:", GetTitleColorIXP(GetTitleIXP(level), true))

		CustomNetTables:SetTableValue("player_table", tostring(ID),
		{
			XP = current_xp,
			MaxXP = xp_required_levelup + current_xp_in_level,
			Lvl = level +1, -- add +1 only on the HUD else you are level 0 at the first level
			title = GetTitleIXP(level),
			title_color = GetTitleColorIXP(GetTitleIXP(level), true)
		})
	end
end
