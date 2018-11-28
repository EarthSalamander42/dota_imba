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
		print("ID not valid!")
		return 0
	end

	local steamid = PlayerResource:GetSteamID(player_id);

	-- if the game isnt registered yet, we have no way to know if the player is a donator
	if self.players == nil then
		print("api players not valid!")
		return 0
	end

	if self.players[steamid] ~= nil then
		return self.players[steamid].status
	else
		print("api players steamid not valid!")
		return 0
	end
end
 
function api:IsCheatGame()
	-- TODO: cookies implement this
	return false
end

function api:GetWinnerTeam()
	-- TODO: cookies implement this
	return 0
end

function api:GetAllPlayerSteamIds()
	local players = {}
	for id = 0, DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidPlayerID(id) then
			table.insert(players, tostring(PlayerResource:GetSteamID(id)))
		end
	end
 
	return players
end
 
function api:RegisterGame()
	self:Request("game-register", function(data)
		self.game_id = data.game_id
		self.players = data.players
	end, nil, "POST", {
		map = GetMapName(),
		match_id = tonumber(tostring(GameRules:GetMatchID())),
		players = self:GetAllPlayerSteamIds(),
		cheat_mode = self:IsCheatGame()
	});
end
 
function api:CompleteGame(successCallback, failCallback)
 
	local players = {}
 
	for id = 0, DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidPlayerID(id) then
 
			local items = {}
 
			for slot = 0, 15 do
				local item = data.hero:GetItemInSlot(slot)
				if item ~= nil then
					table.insert(items, tostring(item:GetAbilityName()))
				end
			end
 
			local player = {
				kills = tonumber(PlayerResource:GetKills(id)),
				deaths = tonumber(PlayerResource:GetDeaths(id)),
				assists = tonumber(PlayerResource:GetAssists(id)),
				hero = json.null,
				team = tonumber(PlayerResource:GetTeam(id)),
				items = items
			}
 
			local hero = PlayerResource:GetSelectedHeroEntity(id)
			if hero ~= nil then
				player.hero = hero:GetUnitName()
			end
 
			local steamid = PlayerResource:GetSteamID(id)
 
			if steamid == 0 then
				steamid = id
			end
 
			players[steamid] = player
		end
	end
 
	self:Request("game-complete", function(data)
		-- this code is executed when a game is completed
		successCallback(data);
	end, failCallback, "POST", {
		winner = self:GetWinnerTeam(),
		game_id = self.game_id,
		players = players
	});
end

function api:Message(message)
	self:Request("game-event", nil, nil, "POST", {
		type = 1,
		game_id = self.data.game_id,
		message = tostring(message)
	})
end

-- temporary (not working)
api.imba = {
	event = function () end
}
