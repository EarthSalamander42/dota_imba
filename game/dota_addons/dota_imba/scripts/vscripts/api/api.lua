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

-- Api interface for several game modes

require("api/json")

api = {}

api.debug_levels = {
	error = 1,
	warn = 2,
	info = 3,
	debug = 4,
	trace = 5
}

api.config = {
	protocol = "http://",
	server = "api.dota2imba.org",
	version = "2",
	game = "imba",
	agent = "imba_705",
	timeout = 5000,
	debug_level = api.debug_levels.warn,
}

api.endpoints = {
	imba = {
		meta = {
			loading_screen_info = "/imba/meta/loading-screen-info",
			modify_donator = "/imba/meta/modify-donator",
			rankings_imr_5v5 = "/imba/meta/rankings/imr-5v5",
			rankings_imr_10v10 = "/imba/meta/rankings/imr-10v10",
			rankings_xp = "/imba/meta/rankings/xp",
			rankings_level_1v1 = "/imba/meta/rankings/level-1v1",
		},
		matchmaking = {
			imr_5v5_random = "/imba/matchmaking/imr-5v5-random",
			imr_10v10_teams = "/imba/matchmaking/imr-10v10-teams",
		},
		game = {
			register = "/imba/game/register",
			complete = "/imba/game/complete",
			events = "/imba/game/events",
		}
	},
	pudge_wars = {
		game = {
			register = "/pudge-wars/game/register",
			complete = "/pudge-wars/game/complete",
		}
	},
	xhs = {
		meta = {
			donators = "/xhs/meta/donators",
		}
	}
}

api.events = {
	log = 1, 					-- (text)
	player_connected = 2,		-- (steamid)
	player_abandoned = 3,		-- (steamid)
	entered_hero_selection = 4,	-- ()
	started_game = 5,			-- ()
	entered_pre_game = 6,		-- ()
	entered_post_game = 7,		-- ()
	player_disconnected = 8,	-- (steamid)
	item_purchased = 9,			-- (item_name, hero_name, steamid)
	ability_learned = 10,		-- (ability_name, hero_name, steamid)
	hero_level_up = 13,			-- (hero_name, level, steamid)
	unit_killed = 17,			-- (killer_unit, killer_steamid, dead_unit, dead_steamid)
	ability_used = 18,			-- (hero_name, ability, steamid)
	timing = 20,				-- ()
	unit_spawned = 21,			-- (unit_name, steamid)
	item_combined = 22,			-- (item_name, hero_name, steamid)
	item_picked_up = 23,		-- (item_name, hero_name, steamid)
	chat = 24	 				-- (steamid, text)
}

api.debug_levels_name = {}
api.debug_levels_name[1] = "error"
api.debug_levels_name[2] = "warn "
api.debug_levels_name[3] = "info "
api.debug_levels_name[4] = "debug"
api.debug_levels_name[5] = "trace"

function api.debug(obj, level)
	local real_level = level
	if real_level == nil then
		real_level = api.debug_levels.trace
	end

	if real_level <= api.config.debug_level then
		print("[api][" .. api.debug_levels_name[real_level] .. "] " .. tostring(obj))
	end
end

function api.request(endpoint, data, callback)

	local url = api.config.protocol .. api.config.server .. endpoint
	local method = "GET"
	local payload = nil

	if callback == nil then
		callback = (function (error, data)
			if (error) then
				api.debug("Error during request to " .. endpoint .. " (" .. data .. ")", api.debug_levels.error)
			else
				api.debug("Request to " .. endpoint .. " successful", api.debug_levels.info)
			end
		end)
	end

	if data ~= nil then
		method = "POST"
		payload = json.encode({
			agent = api.config.agent,
			version = api.config.version,
			time = {
				frames = tonumber(GetFrameCount()),
				server_time = tonumber(Time()),
				dota_time = tonumber(GameRules:GetDOTATime(true, true)),
				game_time = tonumber(GameRules:GetGameTime()),
				server_system_date_time = tostring(GetSystemDate()) .. " " .. tostring(GetSystemTime()),
			},
			data = data
		})
	end

	request = CreateHTTPRequestScriptVM(method, url)
	request:SetHTTPRequestAbsoluteTimeoutMS(api.config.timeout)

	if payload ~= nil then
		request:SetHTTPRequestRawPostBody("application/json", payload)
	end

	api.debug("Performing request to " .. endpoint, api.debug_levels.info)
	api.debug("Method: " .. method, api.debug_levels.debug)

	if payload ~= nil then
		api.debug("Payload: " .. payload, api.debug_levels.debug)
	end

	request:Send(function (raw_result)

			local result = {
				code = raw_result.StatusCode,
				body = raw_result.Body,
			}

			if result.body ~= nil then
				local decoded = json.decode(result.body)
				
				if decoded ~= nil then
					result.data = decoded.data
					result.error = decoded.error
					result.server = decoded.server
					result.version = decoded.version
					result.message = decoded.message
				else
					api.debug("Failed decoding JSON", api.debug_levels.error)
				end
			end

			if result.code == 503 then
				api.debug("Server unavailable", api.debug_levels.error)
				callback(true, "Server unavailable")
			elseif result.code == 500 then
				if result.message ~= nil then
					api.debug("Internal Server Error: " .. tostring(result.message), api.debug_levels.error)
					callback(true, "Internal Server Error: " .. tostring(result.message))
				else
					api.debug("Internal Server Error", api.debug_levels.error)
					callback(true, "Internal Server Error")
				end
			elseif result.code == 405 then
				api.debug("Used invalid method on endpoint" .. endpoint, api.debug_levels.error)
				callback(true, "Used invalid method on endpoint" .. endpoint)
			elseif result.code == 404 then
				api.debug("Tried to access unknown endpoint " .. endpoint, api.debug_levels.error)
				callback(true, "Tried to access unknown endpoint " .. endpoint)
			elseif result.code ~= 200 then
				api.debug("Unknown Error: " .. tostring(result.code), api.debug_levels.error)
				callback(true, "Unknown Error: " .. tostring(result.code))
			else
				api.debug("Request to " .. endpoint .. " successful", api.debug_levels.debug)
				callback(false, result.data)
			end

	end)

end

function api.print(object)

end

