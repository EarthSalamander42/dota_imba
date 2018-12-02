-- Copyright (C) 2018  The Dota IMBA Development Team
-- Api Interface for Dota IMBA

api = class({});

local baseUrl = "http://api.dota2imba.org/imba/"
local timeout = 5000

function api:GetUrl(endpoint)
	return baseUrl .. endpoint
end

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
	request:SetHTTPRequestAbsoluteTimeoutMS(timeout)
	request:SetHTTPRequestHeaderValue("X-Dota-Server-Key", GetDedicatedServerKey("2"))

	-- encode payload
	if payload ~= nil then
		local encoded = json.encode(payload)
		request:SetHTTPRequestRawPostBody("application/json", encoded)
	end

	print("Performing request to " .. endpoint)

	request:Send(function(result)

		local code = result.StatusCode;

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
	end);
end

function api:IsDonator(player_id)
	if self:GetDonatorStatus(player_id) ~= 0 then
		return true
	else
		return false
	end
end

function api:IsDeveloper(player_id)
	local status = self:GetDonatorStatus(player_id);
	if status == 1 or status == 2 or status == 3 then
		return true
	else
		return false
	end
end

function api:GetDonatorStatus(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
		print("api:GetDonatorStatus: Player ID not valid!")
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
		--		print("api:GetDonatorStatus: api players steamid not valid!")
		return 0
	end
end

function api:GetPlayerXP(player_id)
	if not PlayerResource:IsValidPlayerID(player_id) then
		print("api:GetPlayerXP: Player ID not valid!")
		return 0
	end

	local steamid = tostring(PlayerResource:GetSteamID(player_id));

	-- if the game isnt registered yet, we have no way to know player xp
	if self.players == nil then
		print("api:GetPlayerXP() self.players == nil")
		return 0
	end

	if self.players[steamid] ~= nil then
		return self.players[steamid].xp
	else
		print("api:GetPlayerXP: api players steamid not valid!")
		return 0
	end
end

function api:GetApiGameId()
	return self.game_id
end

function api:IsCheatGame()
	-- TODO: cookies implement this
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
	if IsInToolsMode() then
		return tostring(RandomInt(1000000000, 9000000000))
	end

	return tostring(GameRules:GetMatchID())
end

ListenToGameEvent('player_connect_full', function(keys)
	api:Request("game-register", function(data)
		api.game_id = data.game_id
		api.players = data.players
	end, nil, "POST", {
		map = GetMapName(),
		match_id = api:GetMatchID(),
		players = api:GetAllPlayerSteamIds(),
		cheat_mode = api:IsCheatGame()
	});
end, nil)

ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME then
		local players = {}

		for id = 0, PlayerResource:GetPlayerCount() - 1 do
			if PlayerResource:IsValidPlayerID(id) then
				local items = {}
				local heroEntity = PlayerResource:GetSelectedHeroEntity(id)
				local hero = json.null

				if heroEntity ~= nil then
					hero = tostring(heroEntity:GetUnitName())

					for slot = 0, 15 do
						local item = heroEntity:GetItemInSlot(slot)
						if item ~= nil then
							table.insert(items, tostring(item:GetAbilityName()))
						end
					end
				end

				local player = {
					id = id,
					kills = tonumber(PlayerResource:GetKills(id)),
					deaths = tonumber(PlayerResource:GetDeaths(id)),
					assists = tonumber(PlayerResource:GetAssists(id)),
					hero = hero,
					team = tonumber(PlayerResource:GetTeam(id)),
					items = items
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

		local payload = {
			winner = winnerTeam,
			game_id = api.game_id,
			players = players,
			radiant_score = api:GetKillsForTeam(2),
			dire_score = api:GetKillsForTeam(3)
		}

		api:Request("game-complete", function(data)
			CustomGameEventManager:Send_ServerToAllClients("end_game", {
				players = players,
--				data = data,
				info = {
					winner = api:GetWinnerTeam(),
					id = api:GetApiGameId(),
					radiant_score = api:GetKillsForTeam(2),
					dire_score = api:GetKillsForTeam(3),
				},
			})

--			successCallback(data, payload);
		end, failCallback, "POST", payload);
	end
end, nil)

function api:GetLoggingConfiguration(callback)
	-- TODO: implement this; do nothing for now
end

function api:Message(message, type)

	type = type or 1
	local data = json.null
	local messageType = type(message)

	if messageType == "string" or messageType == "boolean" or messageType == "number" or messageType == "table" then
		data = message
	elseif messageType == "function" or messageType == "userdata" then
		data = tostring(message)
	end

	xpcall(function ()

		self:Request("game-event", nil, nil, "POST", {
			type = type,
			game_id = self.data.game_id,
			message = data
		})

	end, debug.traceback)
end
