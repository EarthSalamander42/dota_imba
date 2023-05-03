-- Copyright (C) 2020 - Frostrose Studio Development Team
-- Api Interface for every custom games managed/created by Frostrose Studio

api = api or class({})

local baseUrl = "https://api.frostrose-studio.com/"
local endUrlWebsite = "website/"
local endUrlFrostrose = "imba/"
local timeout = 5000
local native_print = print

function api:Init()
	CustomGameEventManager:RegisterListener("get_companions_table", Dynamic_Wrap(self, "SendCompanionsTable"))
	CustomGameEventManager:RegisterListener("api_change_companion", Dynamic_Wrap(self, "SetCompanion"))
end

-- Utils
function api:GetUrl(endpoint)
	local url = baseUrl

	if endpoint == "statistics/ranking/xp" or endpoint == "statistics/ranking/winrate" then
		url = url .. endUrlWebsite
	else
		url = url .. endUrlFrostrose
	end

	print("URL:", url .. endpoint)

	return url .. endpoint
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

	local steamid = tostring(PlayerResource:GetSteamID(player_id))

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

function api:GetPlayerIngameTag(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
		--		native_print("api:GetPlayerIngameTag: Player ID not valid!")
		return nil
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know if the player is a donator
	if self.players == nil then
		return nil
	end

	if self.players[steamid] ~= nil then
		return self.players[steamid].ingame_tag
	else
		--		native_print("api:GetPlayerIngameTag: api players steamid not valid!")
		return nil
	end
end

function api:SetPlayerIngameTag(player_id, tag)
	if not PlayerResource:IsValidPlayerID(player_id) then
		--		native_print("api:GetPlayerIngameTag: Player ID not valid!")
		return nil
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know if the player is a donator
	if self.players == nil then
		return nil
	end

	if self.players[steamid] ~= nil and self.players[steamid]["toggle_tag"] then
		self.players[steamid].changed_tag_this_game = true
		self.players[steamid].ingame_tag = tag
	else
		--		native_print("api:GetPlayerIngameTag: api players steamid not valid!")
		return nil
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

	-- print(donators)
	CustomNetTables:SetTableValue("game_options", "donators", donators)
end

function api:GetPlayerXP(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
		native_print("api:GetPlayerXP: Player ID not valid!")
		return 0
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id))

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

function api:GetPlayerXPLevel(player_id)
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
		return self.players[steamid].xp_level + 1
	else
		native_print("api:GetPlayerXP: api players steamid not valid!")
		return 0
	end
end

-- companion, statue, emblem only, wearable cosmetics handled in api:GetArmory()
function api:GetPlayerCosmetics(player_id, cosmetic_type)
	if not PlayerResource:IsValidPlayerID(player_id) then
		native_print("api:GetPlayerCosmetics: Player ID not valid!")
		return false
	end

	if not cosmetic_type then
		native_print("api:GetPlayerCosmetics: cosmetic_type not valid!")
		return false
	end

	-- if the game isnt registered yet, we have no way to know player xp
	if self.players == nil then
		native_print("api:GetPlayerCosmetics() self.players == nil")
		return false
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id))

	if self.players[steamid] == nil then
		native_print("api:GetPlayerCosmetics: api players steamid not valid!")
		return false
	end

	local cosmetics = api[cosmetic_type]

	if cosmetics and type(cosmetics == "table" and next(cosmetics)) then
	else
		print("api:GetPlayerCosmetics: cosmetics table value is empty for cosmetic_type:", cosmetic_type)
		return false
	end

	local cosmetic_variable = nil

	if cosmetic_type == "companions" then
		cosmetic_variable = "companion_id"
	elseif cosmetic_type == "statues" then
		cosmetic_variable = "statue_id"
	elseif cosmetic_type == "emblems" then
		cosmetic_variable = "emblem_id"
	end

	if cosmetic_variable == nil then
		print("api:GetPlayerCosmetics: invalid cosmetics variable for cosmetics type:", cosmetic_type)
		return false
	end

	local cosmetic_id = self.players[steamid][cosmetic_variable]

	if cosmetic_id == nil then
		native_print("api:GetPlayerCosmetics: Unable to get " .. cosmetic_variable .. " player table!")
		return false
	end

	return self:GetCosmeticByID(cosmetics, cosmetic_id)
end

function api:GetCosmeticByID(hCosmetics, nIndex)
	for k, v in pairs(hCosmetics) do
		if v.id == tostring(nIndex) then
			-- print("Cosmetic found:", v)
			return v.file
		end
	end
end

function api:GetPlayerCompanion(player_id)
	return self:GetPlayerCosmetics(player_id, "companions")
end

function api:GetPlayerStatue(player_id)
	return self:GetPlayerCosmetics(player_id, "statues")
end

function api:GetPlayerEmblem(player_id)
	return self:GetPlayerCosmetics(player_id, "emblems")
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
		return self.players[steamid]["toggle_tag"]
	else
		native_print("api:GetPlayerTagEnabled: api players steamid not valid!")
		return false
	end
end

function api:GetPlayerBPRewardsEnabled(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
		native_print("api:GetPlayerBPRewardsEnabled: Player ID not valid!")
		return false
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id))

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
		return self.players[steamid]["winrate_" .. string.gsub(GetMapName(), "imba_", "")]
	else
		native_print("api:GetPlayerWinrate: api players steamid not valid!")
		return false
	end
end

function api:GetPlayerSeasonalWinrate(player_id)
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
		return self.players[steamid]["seasonal_winrate"]
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

function api:GetPlayerSeasonalWinrate(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
		native_print("api:GetPlayerSeasonalWinrate: Player ID not valid!")
		return false
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know player xp
	if self.players == nil then
		native_print("api:GetPlayerSeasonalWinrate() self.players == nil")
		return false
	end

	if self.players[steamid] ~= nil then
		return self.players[steamid]["seasonal_winrate"]
	else
		native_print("api:GetPlayerSeasonalWinrate: api players steamid not valid!")
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
	if not api.disabled_heroes then return end
	if not api:IsHeroDisabled("npc_dota_hero_target_dummy") then table.insert(api.disabled_heroes, "npc_dota_hero_target_dummy") end
	return api.disabled_heroes
end

function api:IsHeroDisabled(sHeroName)
	if api.disabled_heroes and type(api.disabled_heroes) == "table" then
		for index, hero_name in pairs(api.disabled_heroes) do
			if hero_name == sHeroName then
				return true
			end
		end
	end
	return false
end

function api:GetApiGameId()
	return self.game_id
end

function api:CheatDetector()
	if CustomNetTables:GetTableValue("game_options", "game_count").value == 1 then
		if Convars:GetBool("sv_cheats") == true or GameRules:IsCheatMode() then
			if not IsInToolsMode() and log then
				log.info("Cheats have been enabled, game don't count.")
				CustomNetTables:SetTableValue("game_options", "game_count", { value = 0 })
				CustomGameEventManager:Send_ServerToAllClients("safe_to_leave", {})
				return true
			end
		end
	end

	return false
end

function api:IsCheatGame()
	if IsInToolsMode() then
		return true
	end

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
	return tostring(GameRules:Script_GetMatchID())
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

	local status, err = xpcall(function()
		--[[
		api:Request("game-event", nil, nil, "POST", {
			type = _type,
			game_id = api.game_id or 0,
			message = data
		})
--]]
	end, function(err)
		if err == nil then
			err = "Unknown Error"
		end

		native_print(err)
	end)
end

-- Core
function api:Request(endpoint, okCallback, failCallback, method, payload)
	print(endpoint)
	print(okCallback)
	print(failCallback)
	print(method)
	print(payload)
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
		return failCallback();
	end

	request:SetHTTPRequestAbsoluteTimeoutMS(timeout)

	local header_key = nil

	if IsDedicatedServer() then
		header_key = GetDedicatedServerKeyV2("2")
	else
		local key = LoadKeyValues("scripts/vscripts/components/api/backend_key.kv")

		if key then
			header_key = key.server_key
		end
	end

	print(header_key)
	CustomNetTables:SetTableValue("game_options", "server_key", { header_key })

	request:SetHTTPRequestHeaderValue("X-Dota-Server-Key", header_key)
	request:SetHTTPRequestHeaderValue("X-Dota-Game-Type", CUSTOM_GAME_TYPE)

	-- encode payload
	-- print(payload)
	if payload ~= nil then
		local encoded = json.encode(payload)
		request:SetHTTPRequestRawPostBody("application/json", encoded)
	end

	print("About to send request...")
	request:Send(function(result)
		print(result)
		local code = result.StatusCode;
		print("Result status code:", code)

		local fail = function(message)
			if (code == nil) then
				code = 0
			end
			print("Request to " .. endpoint .. " failed with message " .. message .. " (" .. tostring(code) .. ")")
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

			print(obj)
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
				return okCallback(obj.data);
			else
				return fail("Wtf")
			end
		end
	end)
end

function api:RegisterGame(callback)
	self:Request("game-register", function(data)
		api.game_id = tonumber(data.game_id)
		api.players = data.players
		api.companions = data.companions or nil
		api.emblems = data.emblems or nil
		api.disabled_heroes = data.disabled_heroes or nil

		if IsInToolsMode() then
			print(data)
		end

		if callback ~= nil then
			callback(data)
		end
	end, function()
		-- fail-safe if http request can't reach backend
		--		GameRules:SetCustomGameSetupRemainingTime(20.0)
	end, "POST", {
		map = GetMapName(),
		match_id = self:GetMatchID(),
		players = self:GetAllPlayerSteamIds(),
		cheat_mode = self:IsCheatGame(),
	})

	-- call in BP scripts after battlepass_player is set to show mmr medal in loading screen
	--	print("ALL PLAYERS LOADED IN!")
	--	CustomGameEventManager:Send_ServerToAllClients("all_players_loaded", {})
end

function api:CompleteGame(successCallback)
	print("CompleteGame")
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
			local items_bought = nil
			local abandon = false
			local leaderboard = {}
			local support_items = {}
			local abilities_level_up_order = {}

			if PlayerResource.GetHasAbandonedDueToLongDisconnect then
				abandon = PlayerResource:GetHasAbandonedDueToLongDisconnect(id)
			end

			if PlayerResource.GetItemsBought then
				items_bought = PlayerResource:GetItemsBought(id)
			end

			if PlayerResource.GetSupportItemsBought then
				support_items = PlayerResource:GetSupportItemsBought(id, items_bought)
			end

			if PlayerResource.GetAbilitiesLevelUpOrder then
				abilities_level_up_order = PlayerResource:GetAbilitiesLevelUpOrder(id)
			end

			if heroEntity ~= nil then
				hero = tostring(heroEntity:GetUnitName())

				for slot = 0, 15 do
					local item = heroEntity:GetItemInSlot(slot)
					if item ~= nil then
						table.insert(items, tostring(item:GetAbilityName()))
					end
				end

				networth = PlayerResource:GetNetWorth(id)
			end

			if CUSTOM_GAME_TYPE == "PLS" then
				for index, score in pairs(Rounds.player_score[id]) do
					table.insert(leaderboard, index, score)
					--					table.insert(leaderboard, tonumber(index), score)
				end
			end

			for i = 0, PlayerResource:GetPlayerCount() - 1 do
				damage_done_to_heroes = damage_done_to_heroes + PlayerResource:GetDamageDoneToHero(id, i)
				kills_done_to_hero[i] = PlayerResource:GetKillsDoneToHero(id, i)
			end

			--			if IsInToolsMode() and id == 0 then
			--				print("CompleteGame: Items:", items)
			--				print("CompleteGame: Items Bought:", items_bought)
			--				print("CompleteGame: Support Items Bought:", PlayerResource:GetSupportItemsBought(id, items_bought))
			--				print("CompleteGame: Abilities Level Up Order:", PlayerResource:GetAbilitiesLevelUpOrder(id))
			--			end

			local increment_pa_arcana_kills = false

			if hero and hero == "npc_dota_hero_phantom_assassin" and Battlepass and Battlepass:HasArcana(id, "phantom_assassin") then
				increment_pa_arcana_kills = true
			end

			--			print("Player Leaderboard:", leaderboard)

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
				support_items = support_items,
				gold_spent_on_support = PlayerResource:GetGoldSpentOnSupport(id),
				abilities_level_up_order = abilities_level_up_order,
				increment_pa_arcana_kills = increment_pa_arcana_kills,
				pa_arcana_kills = api:GetPhantomAssassinArcanaKills(id),
				abandon = abandon,
				leaderboard = leaderboard,
			}

			local steamid = tostring(PlayerResource:GetSteamID(id))

			if steamid == 0 then
				steamid = tostring(id)
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
		game_id = self:GetApiGameId(),
		players = players,
		radiant_score = self:GetKillsForTeam(2),
		dire_score = self:GetKillsForTeam(3),
		game_time = GameRules:GetDOTATime(false, false),
		game_type = CUSTOM_GAME_TYPE,
		gamemode = api:GetCustomGamemode(),
		rosh_lvl = rosh_lvl,
		rosh_hp = rosh_hp,
		rosh_max_hp = rosh_max_hp,
		cheat_mode = self:IsCheatGame(),
		map = GetMapName(),
	}

	self:Request("game-complete", function(data)
			print("Game complete successful!")
			if successCallback ~= nil then
				successCallback(data, payload)
			end
		end,

		function(data)
			print("Error on game complete!")
			print(data)
			if successCallback ~= nil then
				successCallback(data, payload)
			end
		end, "POST", payload)
end

function api:SetCustomGamemode(iValue)
	if iValue and type(iValue) == "number" then
		GameRules:SetCustomGameDifficulty(iValue)
		CustomNetTables:SetTableValue("game_options", "gamemode", { tostring(iValue) })
	else
		print("ERROR: Value should be a number, not string.")
		api:SetCustomGamemode(tonumber(iValue))
	end

	return nil
end

function api:GetCustomGamemode()
	local gamemode = CustomNetTables:GetTableValue("game_options", "gamemode")

	if gamemode then
		gamemode = gamemode["1"]
	end

	return tonumber(gamemode)
end

-- Credits: darklord (Dota 12v12)
function api:DetectParties()
	self.parties = {}
	local party_indicies = {}
	local party_members_count = {}
	local party_index = 1
	-- Set up player colors
	for id = 0, 23 do
		if PlayerResource:IsValidPlayer(id) then
			local party_id = tonumber(tostring(PlayerResource:GetPartyID(id)))
			if party_id and party_id > 0 then
				if not party_indicies[party_id] then
					party_indicies[party_id] = party_index
					party_index = party_index + 1
				end
				local party_index = party_indicies[party_id]
				self.parties[id] = party_index
				if not party_members_count[party_index] then
					party_members_count[party_index] = 0
				end
				party_members_count[party_index] = party_members_count[party_index] + 1
			end
		end
	end
	for id, party in pairs(self.parties) do
		-- at least 2 ppl in party!
		if party_members_count[party] and party_members_count[party] < 2 then
			self.parties[id] = nil
		end
	end

	print("Parties:", api.parties)
end

function api:FindPlayerParty(iPlayerID)
	if not self.parties then
		print("No party detected.")
		return
	end

	for id, party in pairs(self.parties) do
		if iPlayerID == id then
			return party
		end
	end
end

function api:SetCompanion(data)
	local player_id = data.PlayerID
	local unit_name = data.sUnitName

	local payload = {
		companion_id = data.companion_id,
		steamid = tostring(PlayerResource:GetSteamID(player_id))
	}

	api:Request("modify-companion", function(data)
			Battlepass:DonatorCompanion(player_id, unit_name, true)
		end,
		function(data)
			CustomGameEventManager:Send_ServerToPlayer(player, "change_companion_failure", {})
		end, "POST", payload)
end

function api:GetParties(iPlayerID)
	if not self.parties then
		print("No party detected.")
		return
	end

	return self.parties
end

function api:SendCompanionsTable(data)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(data.PlayerID), "receive_companions_table", api.companions)
end

function api:GenerateGameModeLeaderboard()
	local round_count = Rounds:GetRoundCount()
	--	print("Amount of rounds:", round_count)

	self:GetGameModeLeaderboard(1, round_count)
end

function api:GetGameModeLeaderboard(iRound, iMaxRound)
	if not self.pls_ranking then
		self.pls_ranking = {}
	end

	print("Iterate round " .. iRound .. "...")

	self:Request("pls_ranking", function(data)
		self.pls_ranking[iRound] = data.players

		-- if IsInToolsMode() then
		-- print("GameMode Leaderboard for round "..iRound..":", data.players)
		-- end

		print("Leaderboard round " .. iRound .. ": success!")
		iRound = iRound + 1

		if iRound < iMaxRound + 1 then
			self:GetGameModeLeaderboard(iRound, iMaxRound)
		else
			CustomNetTables:SetTableValue("game_options", "GameMode_leaderboard", self.pls_ranking)
		end
	end, function()
		print("Leaderboard round " .. iRound .. ": failure!!!")
		iRound = iRound + 1

		if iRound < iMaxRound + 1 then
			self:GetGameModeLeaderboard(iRound, iMaxRound)
		else
			CustomNetTables:SetTableValue("game_options", "GameMode_leaderboard", self.pls_ranking)
		end
	end, "POST", {
		round_range = iRound,
	})
end

api:Init()

require("components/api/events")
