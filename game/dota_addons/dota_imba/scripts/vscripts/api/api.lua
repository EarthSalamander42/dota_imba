-- Copyright (C) 2018  The Dota IMBA Development Team
-- Api

require("api/json")

api = {}

api.config = {
	protocol = "http://",
	server = "api.dota2imba.org",
	version = "2",
	game = "imba",
	agent = "imba_705",
	timeout = 10000
}

api.endpoints = {
	imba = {
		meta = {
			loading_screen_info = "/imba/meta/loading-screen-info",
			logging_configuration = "/imba/meta/logging-configuration",
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
			events = "/imba/game/events"
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

function api.request(endpoint, data, callback)
	local url = api.config.protocol .. api.config.server .. endpoint
	local method = "GET"
	local payload = nil

	if callback == nil then
		callback = (function (error, data)
			if (error) then
				log.error("Error during request to " .. endpoint .. " (" .. data .. ")")
			else
				log.info("Request to " .. endpoint .. " successful")
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

	log.debug("Performing request to " .. endpoint)
	log.debug("Method: " .. method)

	if payload ~= nil then
		log.debug("Payload: " .. payload:sub(1, 20))
	end

	request:Send(function (raw_result)
		local result = {
			code = raw_result.StatusCode,
			body = raw_result.Body,
		}

		if result.code == 0 then
			log.error("Request to " .. endpoint .. " timed out")
			callback(true, "Request to " .. endpoint .. " timed out")
			return
		end

		if result.body ~= nil then
			log.debug(result.body)

			local decoded = json.decode(result.body)

			if decoded ~= nil then
				result.data = decoded.data
				result.error = decoded.error
				result.server = decoded.server
				result.version = decoded.version
				result.message = decoded.message
			else
				log.error("Failed decoding JSON of Request: Status Code: " .. tostring(result.code) .. ", Payload: " .. payload)
			end

			if result.code == 503 then
				log.error("Server unavailable")
				callback(true, "Server unavailable")
			elseif result.code == 500 then
				if result.message ~= nil then
					log.error("Internal Server Error: " .. tostring(result.message))
					callback(true, "Internal Server Error: " .. tostring(result.message))
				else
					log.error("Internal Server Error")
					callback(true, "Internal Server Error")
				end
			elseif result.code == 405 then
				log.error("Used invalid method on endpoint" .. endpoint)
				callback(true, "Used invalid method on endpoint" .. endpoint)
			elseif result.code == 404 then
				log.error("Tried to access unknown endpoint " .. endpoint)
				callback(true, "Tried to access unknown endpoint " .. endpoint)
			elseif result.code ~= 200 then
				log.error("Unknown Error: " .. tostring(result.code))
				callback(true, "Unknown Error: " .. tostring(result.code))
			else
				log.debug("Request to " .. endpoint .. " successful")
				callback(false, result.data)
			end
		else
			log.error("Warning: Recieved response for request " .. endpoint .. " without body!")
		end
	end)
end
