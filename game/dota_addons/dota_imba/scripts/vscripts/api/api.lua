-- 
-- IMBA API
--

require("api/json")

-- Constants
local IMBA_API_CONFIG = {
	key = "3utx8DehTd42Wxqh65ldAErJjoCdi6XB",
	endpoint = "http://api.dota2imba.org",
	agent = "dota_imba-lua-1.x",
	timeout = 10000
}

local IMBA_API_ENDPOINTS = {
	meta_news = "/meta/news",
	meta_donators = "/meta/donators",
	meta_developers = "/meta/developers",
	game_register = "/game/register",
	game_complete = "/game/complete",
	game_event = "/game/event",
	meta_topxpusers = "/meta/top-xp-users",
	meta_topimrusers = "/meta/top-imr-users",
    meta_hotdisabledheroes = "/meta/hot-disabled-heroes",
    meta_companions = "/meta/companions",
    meta_companion_change = "/meta/companion-change",
}

ImbaApi = {}

function ImbaApi:new(cpo, config)
	cpo = cpo or {}
	setmetatable(cpo, self)
	self.__index = self
	self.config = config
	return cpo
end

function ImbaApi:print(t)
	print("[api] " .. t)
end

function ImbaApi:perform(robj, endpoint, callback)

	local payload = nil
	local method = "GET"

	-- build base request
	if robj ~= nil then
		local base_request = {
			agent = self.config.agent,
			version = 1,
			frames = tonumber(GetFrameCount()),
			server_system_datetime = tostring(GetSystemDate()) .. " " .. tostring(GetSystemTime()),
			server_time = tonumber(Time()),
			data = robj
		}

		method = "POST"
	
		-- encode with json
		payload = json.encode(base_request)
	end 

	self:print("Performing " .. method .. " @ " .. endpoint)

	if (method == "POST") then
		self:print("Payload " .. payload)
	end
	
	-- create request
	rqH = CreateHTTPRequestScriptVM(method, self.config.endpoint .. endpoint)
	rqH:SetHTTPRequestAbsoluteTimeoutMS(self.config.timeout)

	-- set payload
	if payload ~= nil then
		rqH:SetHTTPRequestRawPostBody("application/json", payload)
	end

	self:print("Performing Request to " .. self.config.endpoint .. endpoint)

	-- send request
	rqH:Send(function (result)

		-- decode response (we should always get json)
		-- 500 indi
		if result.StatusCode == 503 then
			self:print("Server not available!")
			callback(true, nil)
		elseif result.StatusCode ~= 200 then
			self:print("Request failed with Invalid status: " .. result.StatusCode)
			callback(true, nil)
		else 
			rp = json.decode(result.Body)
			if rp.error then
				self:print("Request failed with custom error: " .. rp.message)
				callback(true, rp)
			else
				self:print("Request succesful")
				self:print("Payload: " .. result.Body)
				callback(false, rp)
			end
		end
	end)
end

function ImbaApi:simple_perform(data, endpoint, success_cb, error_cb)
	self:perform(data, endpoint, function (err, rs)
		if (err) then
			if (error_cb) then error_cb() end
		else success_cb(rs.data) end
	end)
end

function ImbaApi:meta_news(success_cb, error_cb)
	self:simple_perform(nil, IMBA_API_ENDPOINTS.meta_news, success_cb, error_cb)
end

function ImbaApi:meta_donators(success_cb, error_cb)
	self:simple_perform(nil, IMBA_API_ENDPOINTS.meta_donators, success_cb, error_cb)
end

function ImbaApi:meta_developers(success_cb, error_cb)
	self:simple_perform(nil, IMBA_API_ENDPOINTS.meta_developers, success_cb, error_cb)
end

function ImbaApi:game_event(data, success_cb, error_cb)
	self:simple_perform(data, IMBA_API_ENDPOINTS.game_event, success_cb, error_cb)
end

function ImbaApi:game_register(data, success_cb, error_cb)
	self:simple_perform(data, IMBA_API_ENDPOINTS.game_register, success_cb, error_cb)
end

function ImbaApi:game_complete(data, success_cb, error_cb)
	self:simple_perform(data, IMBA_API_ENDPOINTS.game_complete, success_cb, error_cb)
end

function ImbaApi:meta_topxpusers(success_cb, error_cb)
	self:simple_perform(nil, IMBA_API_ENDPOINTS.meta_topxpusers, success_cb, error_cb)
end

function ImbaApi:meta_topimrusers(success_cb, error_cb)
	self:simple_perform(nil, IMBA_API_ENDPOINTS.meta_topimrusers, success_cb, error_cb)
end

function ImbaApi:meta_hotdisabledheroes(success_cb, error_cb)
    self:simple_perform(nil, IMBA_API_ENDPOINTS.meta_hotdisabledheroes, success_cb, error_cb)
end

function ImbaApi:meta_companions(success_cb, error_cb)
    self:simple_perform(nil, IMBA_API_ENDPOINTS.meta_companions, success_cb, error_cb)
end

function ImbaApi:meta_companion_change(data, success_cb, error_cb)
	self:simple_perform(data, IMBA_API_ENDPOINTS.meta_companion_change, success_cb, error_cb)
end

-- Internal Vars
local _api_instance = nil

-- functions
function imba_api()
	if _api_instance == nil then
		_api_instance = ImbaApi:new(nil, IMBA_API_CONFIG)
	end
 
	return _api_instance
end
