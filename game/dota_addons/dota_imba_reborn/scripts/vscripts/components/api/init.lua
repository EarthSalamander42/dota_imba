-- Copyright (C) 2020 - Frostrose Studio Development Team
-- Api Interface for every custom games managed/created by Frostrose Studio

api = class({});

api.disabled_heroes = {}

local baseUrl = "https://api.frostrose-studio.com/imba/"
local websiteUrl = "https://api.frostrose-studio.com/website/"
local timeout = 5000

local native_print = print

-- Utils
function api:GetUrl(endpoint)
	if endpoint == "statistics/ranking/xp" or endpoint == "statistics/ranking/winrate" then
		baseUrl = websiteUrl
	end

	return baseUrl..endpoint
end

function api:IsDonator(player_id)
	if self:GetDonatorStatus(player_id) ~= 0 and self:GetDonatorStatus(player_id) ~= 10 then
		return true
	else
		return false
	end
end

function api:IsDeveloper(player_id)
	local status = self:GetDonatorStatus(player_id);
	if status == 1 or status == 2 then
		return true
	else
		return false
	end
end

function api:GetDonatorStatus(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
--		native_print("api:GetDonatorStatus: Player ID not valid!")
		return 0
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know if the player is a donator
	if self.players == nil then
		return 0
	end

	if self.players[steamid] ~= nil then
		return self.players[steamid].status
	else
		--		native_print("api:GetDonatorStatus: api players steamid not valid!")
		return 0
	end
end

function api:InitDonatorTableJS()
	local donators = {}

	for i = 0, PlayerResource:GetPlayerCount() - 1 do
		local donator_status = self:GetDonatorStatus(i)
		if donator_status ~= 0 and donator_status ~= 10 then
			donators[PlayerResource:GetSteamID(i)] = donator_status
		end
	end

	CustomNetTables:SetTableValue("game_options", "donators", donators)
end

function api:GetPlayerXP(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
		native_print("api:GetPlayerXP: Player ID not valid!")
		return 0
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know player xp
	if self.players == nil then
		native_print("api:GetPlayerXP() self.players == nil")
		return 0
	end

	if self.players[steamid] ~= nil then
		return self.players[steamid].xp
	else
		native_print("api:GetPlayerXP: api players steamid not valid!")
		return 0
	end
end

function api:GetPlayerCompanion(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
		native_print("api:GetPlayerCompanion: Player ID not valid!")
		return false
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know player xp
	if self.players == nil then
		native_print("api:GetPlayerCompanion() self.players == nil")
		return false
	end

	local ply_table = CustomNetTables:GetTableValue("battlepass_player", "companions")

	if self.players[steamid] ~= nil and ply_table and ply_table["1"] and ply_table["1"][tostring(self.players[steamid].companion_id)] then
		return ply_table["1"][tostring(self.players[steamid].companion_id)]
	else
		native_print("api:GetPlayerCompanion: api players steamid not valid!")
		return false
	end
end

function api:GetPlayerStatue(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
		native_print("api:GetPlayerStatue: Player ID not valid!")
		return false
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know player xp
	if self.players == nil then
		native_print("api:GetPlayerStatue() self.players == nil")
		return false
	end

	if self.players[steamid] ~= nil then
		return CustomNetTables:GetTableValue("battlepass_player", "statues")["1"][tostring(self.players[steamid].statue_id)]
	else
		native_print("api:GetPlayerStatue: api players steamid not valid!")
		return false
	end
end

function api:GetPlayerEmblem(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
		native_print("api:GetPlayerEmblem: Player ID not valid!")
		return ""
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know player xp
	if self.players == nil then
		native_print("api:GetPlayerEmblem() self.players == nil")
		return ""
	end

	if self.players[steamid] ~= nil then
		if type(self.players[steamid].emblem_id) == "number" and CustomNetTables:GetTableValue("battlepass_player", "emblems") then
			return CustomNetTables:GetTableValue("battlepass_player", "emblems")["1"][tostring(self.players[steamid].emblem_id)].file
		else
			return ""
		end
	else
		native_print("api:GetPlayerEmblem: api players steamid not valid!")
		return ""
	end
end

function api:GetPlayerTagEnabled(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
		native_print("api:GetPlayerTagEnabled: Player ID not valid!")
		return false
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know player xp
	if self.players == nil then
		native_print("api:GetPlayerTagEnabled() self.players == nil")
		return false
	end

	if self.players[steamid] ~= nil then
		return self.players[steamid]["in_game_tag"]
	else
		native_print("api:GetPlayerCompanion: api players steamid not valid!")
		return false
	end
end

function api:GetPlayerBPRewardsEnabled(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
		native_print("api:GetPlayerBPRewardsEnabled: Player ID not valid!")
		return false
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know player xp
	if self.players == nil then
		native_print("api:GetPlayerBPRewardsEnabled() self.players == nil")
		return false
	end

	if self.players[steamid] ~= nil then
		return self.players[steamid]["bp_rewards"]
	else
		native_print("api:GetPlayerBPRewardsEnabled: api players steamid not valid!")
		return false
	end
end

function api:GetPlayerXPEnabled(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
		native_print("api:GetPlayerXPEnabled: Player ID not valid!")
		return false
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know player xp
	if self.players == nil then
		native_print("api:GetPlayerXPEnabled() self.players == nil")
		return false
	end

	if self.players[steamid] ~= nil then
		return self.players[steamid]["player_xp"]
	else
		native_print("api:GetPlayerXPEnabled: api players steamid not valid!")
		return false
	end
end

function api:GetPlayerWinrateShown(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
		native_print("api:GetPlayerWinrateShown: Player ID not valid!")
		return false
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know player xp
	if self.players == nil then
		native_print("api:GetPlayerWinrateShown() self.players == nil")
		return false
	end

	if self.players[steamid] ~= nil then
		return self.players[steamid]["winrate_toggle"]
	else
		native_print("api:GetPlayerWinrateShown: api players steamid not valid!")
		return false
	end
end

function api:GetPlayerWinrate(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
		native_print("api:GetPlayerWinrate: Player ID not valid!")
		return false
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know player xp
	if self.players == nil then
		native_print("api:GetPlayerWinrate() self.players == nil")
		return false
	end

	if self.players[steamid] ~= nil then
		return self.players[steamid]["winrate_"..string.gsub(GetMapName(), "imba_", "")]
	else
		native_print("api:GetPlayerWinrate: api players steamid not valid!")
		return false
	end
end

function api:GetPlayerMMR(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
		native_print("api:GetPlayerMMR: Player ID not valid!")
		return false
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know player xp
	if self.players == nil then
		native_print("api:GetPlayerMMR() self.players == nil")
		return false
	end

	if self.players[steamid] ~= nil then
		return self.players[steamid]["mmr_value"]
	else
		native_print("api:GetPlayerMMR: api players steamid not valid!")
		return false
	end
end

function api:GetPlayerRankMMR(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
		native_print("api:GetPlayerMMR: Player ID not valid!")
		return false
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know player xp
	if self.players == nil then
		native_print("api:GetPlayerMMR() self.players == nil")
		return false
	end

	if self.players[steamid] ~= nil then
		return self.players[steamid]["mmr_title"]
	else
		native_print("api:GetPlayerMMR: api players steamid not valid!")
		return false
	end
end

function api:GetPhantomAssassinArcanaKills(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
--		native_print("api:GetPhantomAssassinArcanaKills: Player ID not valid!")
		return false
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know player xp
	if self.players == nil then
--		native_print("api:GetPhantomAssassinArcanaKills() self.players == nil")
		return false
	end

	if self.players[steamid] ~= nil then
		return self.players[steamid]["pa_arcana_kills"]
	else
--		native_print("api:GetPhantomAssassinArcanaKills: api players steamid not valid!")
		return false
	end
end

function api:GetArmory(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
--		native_print("api:GetArmory: Player ID not valid!")
		return {}
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know if the player is a donator
	if self.players == nil then
		return {}
	end

	if self.players[steamid] ~= nil then
		return self.players[steamid].armory
	else
--		native_print("api:GetArmory: api players steamid not valid!")
		return {}
	end
end

function api:GetDisabledHeroes()
	self:Request("disabled-heroes", function(data)
		local disabled_heroes = {}

		for k, v in pairs(data) do
			if v.map == GetMapName() then
				disabled_heroes[v.hero_name] = v.is_disabled
			end
		end

		api.disabled_heroes = disabled_heroes
	end, nil, "POST", {
		map = GetMapName(),
	});
end

function api:GetApiGameId()
	return self.game_id
end

function api:CheatDetector()
	if CustomNetTables:GetTableValue("game_options", "game_count").value == 1 then
		if Convars:GetBool("sv_cheats") == true or GameRules:IsCheatMode() then
			if not IsInToolsMode() and log then
				log.info("Cheats have been enabled, game don't count.")
				CustomNetTables:SetTableValue("game_options", "game_count", {value = 0})
				CustomGameEventManager:Send_ServerToAllClients("safe_to_leave", {})
				return true
			end
		end
	end

	return false
end

function api:IsCheatGame()
	if CustomNetTables:GetTableValue("game_options", "game_count").value == 0 then
		return true
	end

	return false
end

function api:GetWinnerTeam()
	return GAME_WINNER_TEAM
end

function api:GetKillsForTeam(team)
	return GetTeamHeroKills(team)
end

function api:GetAllPlayerSteamIds()
	local players = {}
	for id = 0, PlayerResource:GetPlayerCount() - 1 do
		if PlayerResource:IsValidPlayerID(id) then
			table.insert(players, tostring(PlayerResource:GetSteamID(id)))
		end
	end

	return players
end

function api:GetMatchID()
	return tostring(GameRules:GetMatchID())
end

function api:GetLoggingConfiguration(callback)
	-- TODO: implement this; do nothing for now
end

function api:Message(message, _type)
	if not message or message == '' then return end

	_type = _type or 1
	local data = json.null
	local messageType = type(message)

	if messageType == "string" or messageType == "boolean" or messageType == "number" or messageType == "table" then
		data = message
	elseif messageType == "function" or messageType == "userdata" then
		data = tostring(message)
	end

	local status, err = xpcall(function ()
--[[
		api:Request("game-event", nil, nil, "POST", {
			type = _type,
			game_id = api.game_id or 0,
			message = data
		})
--]]
	end , function(err)

		if err == nil then
			err = "Unknown Error"
		end

		native_print(err)
	end)
end

-- Core
function api:Request(endpoint, okCallback, failCallback, method, payload)
	if okCallback == nil then
		okCallback = function()
		end
	end

	if failCallback == nil then
		failCallback = function()
		end
	end

	if method == nil then
		method = "GET"
	end

	local request = CreateHTTPRequestScriptVM(method, self:GetUrl(endpoint))

	if request == nil then
		native_print("Failed to create http request. skipping")
		return failCallback()
	end

	request:SetHTTPRequestAbsoluteTimeoutMS(timeout)

	local header_key = nil

	if IsDedicatedServer() then
		header_key = GetDedicatedServerKeyV2("2")
	elseif LoadKeyValues("scripts/vscripts/components/api/backend_key.kv") then
		header_key = LoadKeyValues("scripts/vscripts/components/api/backend_key.kv").server_key
	end

	CustomNetTables:SetTableValue("game_options", "server_key", {header_key})

	request:SetHTTPRequestHeaderValue("X-Dota-Server-Key", header_key)
	request:SetHTTPRequestHeaderValue("X-Dota-Game-Type", CUSTOM_GAME_TYPE)

	-- encode payload
	if payload ~= nil then
		local encoded = json.encode(payload)
		request:SetHTTPRequestRawPostBody("application/json", encoded)
	end

	request:Send(function(result)
		local code = result.StatusCode;

		local fail = function(message)
			if (code == nil) then
				code = 0
			end
			native_print("Request to " .. endpoint .. " failed with message " .. message .. " (" .. tostring(code) .. ")")
			failCallback();
		end

		if code == 0 then
			return fail("Request timeout")
		elseif code >= 500 then
			return fail("Server Error")
		elseif code == 204 then
			return okCallback();
		else
			local obj, pos, err = json.decode(result.Body)

			if err then
				return fail("Json error: " .. tostring(err))
			end

			if obj == nil then
				return fail("Unknown Server error")
			end

			if obj.error == nil then
				return fail("Invalid response from server")
			elseif obj.error == true and obj.message ~= nil then
				return fail(obj.message)
			elseif obj.error == true and obj.message == nil then
				return fail("Unknown server error. (message is nil)")
			elseif code >= 200 and code < 400 then
				return okCallback(obj.data)
			else
				return fail("Wtf")
			end
		end
	end)
end

function api:RegisterGame(callback)
	self:Request("game-register", function(data)
		api.game_id = data.game_id
		api.players = data.players
		if IsInToolsMode() then
			print(data.players)
		end
		if callback ~= nil then
			callback(data)
		end
	end, nil, "POST", {
		map = GetMapName(),
		match_id = self:GetMatchID(),
		players = self:GetAllPlayerSteamIds(),
		cheat_mode = self:IsCheatGame(),
	});

	local cool_hat = {}
	local cool_hats = {
		"companions",
		"statues",
		"emblems"
	}

	for i, j in pairs(cool_hats) do
		self:Request(j, function(data)
			cool_hat[j] = {}
			for k, v in pairs(data) do
				table.insert(cool_hat[j], data[k]["id"], data[k])
			end

			CustomNetTables:SetTableValue("battlepass_player", j, {cool_hat[j]})
		end)
	end

	-- call in BP scripts after battlepass_player is set to show mmr medal in loading screen
--	print("ALL PLAYERS LOADED IN!")
--	CustomGameEventManager:Send_ServerToAllClients("all_players_loaded", {})
end

function api:CompleteGame(successCallback, failCallback)
	local players = {}

	for id = 0, PlayerResource:GetPlayerCount() - 1 do
		if PlayerResource:IsValidPlayerID(id) then
			local items = {}
			local heroEntity = PlayerResource:GetSelectedHeroEntity(id)
			local hero = json.null
			local networth = 0
			local healing = PlayerResource:GetHealing(id)
			local damage_done_to_heroes = 0
			local damage_done_to_buildings = 0
			local kills_done_to_hero = {}
			local items_bought = PlayerResource:GetItemsBought(id)
			local abandon = PlayerResource:GetHasAbandonedDueToLongDisconnect(id)

			if heroEntity ~= nil then
				hero = tostring(heroEntity:GetUnitName())

				for slot = 0, 15 do
					local item = heroEntity:GetItemInSlot(slot)
					if item ~= nil then
						table.insert(items, tostring(item:GetAbilityName()))
					end
				end

				networth = heroEntity:GetNetworth()
			end

			for i = 0, PlayerResource:GetPlayerCount() - 1 do
				damage_done_to_heroes = damage_done_to_heroes + PlayerResource:GetDamageDoneToHero(id, i)
				kills_done_to_hero[i] = PlayerResource:GetKillsDoneToHero(id, i)
			end

			if IsInToolsMode() and id == 0 then
--				print("CompleteGame: Items:", items)
--				print("CompleteGame: Items Bought:", items_bought)
--				print("CompleteGame: Support Items Bought:", PlayerResource:GetSupportItemsBought(id, items_bought))
--				print("CompleteGame: Abilities Level Up Order:", PlayerResource:GetAbilitiesLevelUpOrder(id))
			end

			local increment_pa_arcana_kills = false

			if hero and hero == "npc_dota_hero_phantom_assassin" and Battlepass and Battlepass:HasArcana(id, "phantom_assassin") then
				increment_pa_arcana_kills = true
			end

			local player = {
				id = id,
				kills = tonumber(PlayerResource:GetKills(id)),
				deaths = tonumber(PlayerResource:GetDeaths(id)),
				assists = tonumber(PlayerResource:GetAssists(id)),
				level = tonumber(PlayerResource:GetLevel(id)),
				hero = hero,
				team = tonumber(PlayerResource:GetTeam(id)),
				items = items,
				networth = networth,
				healing = healing,
				damage_done_to_heroes = damage_done_to_heroes,
				damage_done_to_buildings = damage_done_to_buildings,
				kills_done_to_hero = kills_done_to_hero,
				items_bought = items_bought,
				support_items = PlayerResource:GetSupportItemsBought(id, items_bought),
				gold_spent_on_support = PlayerResource:GetGoldSpentOnSupport(id),
				abilities_level_up_order = PlayerResource:GetAbilitiesLevelUpOrder(id),
				increment_pa_arcana_kills = increment_pa_arcana_kills,
				pa_arcana_kills = api:GetPhantomAssassinArcanaKills(id),
				abandon = abandon,
			}

			local steamid = tostring(PlayerResource:GetSteamID(id))

			if steamid == 0 then
				steamid = tostring(id)
			else

			end

			players[steamid] = player
		end
	end

	local winnerTeam = api:GetWinnerTeam()
	if winnerTeam == nil or winnerTeam == 0 then
		winnerTeam = json.null
	end

	local rosh_lvl
	local rosh_hp
	local rosh_max_hp

	if CUSTOM_GAME_TYPE == "IMBA" then
		print("Cheat game?", api:IsCheatGame(), api:GetCustomGamemode() == 4)

		if api:IsCheatGame() == false and api:GetCustomGamemode() == 4 then
			rosh_lvl = ROSHAN_ENT:GetLevel()
			rosh_hp = ROSHAN_ENT:GetHealth()
			rosh_max_hp = ROSHAN_ENT:GetMaxHealth()
		end
	end

--	print(rosh_lvl, rosh_hp, rosh_max_hp)

	local payload = {
		winner = winnerTeam,
		game_id = self.game_id,
		players = players,
		radiant_score = self:GetKillsForTeam(2),
		dire_score = self:GetKillsForTeam(3),
		game_time = GameRules:GetDOTATime(false, false),
		game_type = CUSTOM_GAME_TYPE,
		gamemode = api:GetCustomGamemode(),
		rosh_lvl = rosh_lvl,
		rosh_hp = rosh_hp,
		rosh_max_hp = rosh_max_hp,
	}

	self:Request("game-complete", function(data)
		if successCallback ~= nil then
			successCallback(data, payload);
		end
	end, failCallback, "POST", payload);
end

function api:DiretideHallOfFame(successCallback, failCallback)
	self:Request("diretide-score", function(data)
		if successCallback ~= nil then
			successCallback(data)
		end
	end, failCallback, "POST", {
		map = GetMapName(),
	});
end


function api:SetCustomGamemode(iValue)
	if iValue and type(iValue) == "number" then
		CustomNetTables:SetTableValue("game_options", "gamemode", {iValue})
	end

	return nil
end

function api:GetCustomGamemode()
	local gamemode = CustomNetTables:GetTableValue("game_options", "gamemode")

	if gamemode then
		gamemode = gamemode["1"]
	end

	return gamemode
end

function api:SendTeamConfiguration(players, combinations, callback)
	local data = {
		players = players,
		team_combinations = combinations,
		map = GetMapName(),
	}

	print(players)
	print(team_combinations)

	self:Request("teambalance", function(data)
		if callback ~= nil then
			callback(data)
		end
	end, nil, "POST", data)
end

-- Credits: darklord (Dota 12v12)
function api:DetectParties()
	self.parties = {}
	local party_indicies = {}
	local party_index = 1
	local players = {}

	-- Set up player colors
	for id = 0, 23 do
		if PlayerResource:IsValidPlayer(id) then
			players[id] = tostring(PlayerResource:GetSteamID(id))

			-- {"0":26703929098108930,"1":26703929098108930}
			local party_id = tonumber(tostring(PlayerResource:GetPartyID(id)))

			if party_id and party_id > 0 then
				if not party_indicies[party_id] then
					party_indicies[party_id] = party_index
					party_index = party_index + 1
				end

				self.parties[id] = party_indicies[party_id]
			end
		end
	end

	local data = {
		players = players,
		parties = api.parties,
		map = GetMapName(),
	}

	print(players)
	print(api.parties)

	self:Request("teambalance", function(data)
		if callback ~= nil then
			callback(data)
		end

		print(data)
	end, nil, "POST", data)
end

require("components/api/events")
