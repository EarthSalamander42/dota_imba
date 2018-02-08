--
-- IMBA API
--

require("api/json")

-- Constants
local ImbaApiConfig = {
	key = "3utx8DehTd42Wxqh65ldAErJjoCdi6XB",
	endpoint = "http://api.dota2imba.org",
	agent = "dota_imba-7.04",
	timeout = 10000,
	debug = false
}

local ImbaApiEndpoints = {
	MetaNews = "/meta/news",
	MetaDonators = "/meta/donators",
	MetaDevelopers = "/meta/developers",
	GameRegister = "/game/register",
	GameComplete = "/game/complete",
	GameEvent = "/game/event",
	GameEvents = "/game/events",
	MetaTopXpUsers = "/meta/top-xp-users",
	MetaTopImrUsers = "/meta/top-imr-users",
	MetaHotDisabledHeroes = "/meta/hot-disabled-heroes",
	MetaCompanions = "/meta/companions",
	MetaCompanionChange = "/meta/companion-change",
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
	if tostring(PlayerResource:GetSteamID(0)) == "76561198015161808" then
		return
	else
		print("[api] " .. t)
	end
end

function ImbaApi:debug(t)
	if ImbaApiConfig.debug then
		print("[api-debug] " .. t)
	end
end

function ImbaApi:perform(robj, endpoint, callback)

	local payload = nil
	local method = "GET"

	-- build base request
	if robj ~= nil then
		local baseRequest = {
			agent = self.config.agent,
			version = 1,
			frames = tonumber(GetFrameCount()),
			server_system_datetime = tostring(GetSystemDate()) .. " " .. tostring(GetSystemTime()),
			server_time = tonumber(Time()),
			data = robj
		}

		method = "POST"

		-- encode with json
		payload = json.encode(baseRequest)
	end

	self:debug("Performing " .. method .. " @ " .. endpoint)

	if (method == "POST") then
		self:debug("Payload " .. payload)
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
					self:debug("Request succesful")
					self:debug("Payload: " .. result.Body)
					callback(false, rp)
				end
			end
	end)
end

function ImbaApi:SimplePerform(data, endpoint, successCallback, errorCallback)
	self:perform(data, endpoint, function (err, rs)
		if (err) then
			if (errorCallback) then errorCallback() end
		else successCallback(rs.data) end
	end)
end

function ImbaApi:MetaNews(successCallback, errorCallback)
	self:SimplePerform(nil, ImbaApiEndpoints.MetaNews, successCallback, errorCallback)
end

function ImbaApi:MetaDonators(successCallback, errorCallback)
	self:SimplePerform(nil, ImbaApiEndpoints.MetaDonators, successCallback, errorCallback)
end

function ImbaApi:MetaDevelopers(successCallback, errorCallback)
	self:SimplePerform(nil, ImbaApiEndpoints.MetaDevelopers, successCallback, errorCallback)
end

function ImbaApi:GameEvent(data, successCallback, errorCallback)
	self:SimplePerform(data, ImbaApiEndpoints.GameEvent, successCallback, errorCallback)
end

function ImbaApi:GameEvents(data, successCallback, errorCallback)
	self:SimplePerform(data, ImbaApiEndpoints.GameEvents, successCallback, errorCallback)
end

function ImbaApi:GameRegister(data, successCallback, errorCallback)
	self:SimplePerform(data, ImbaApiEndpoints.GameRegister, successCallback, errorCallback)
end

function ImbaApi:GameComplete(data, successCallback, errorCallback)
	self:SimplePerform(data, ImbaApiEndpoints.GameComplete, successCallback, errorCallback)
end

function ImbaApi:MetaTopXpUsers(successCallback, errorCallback)
	self:SimplePerform(nil, ImbaApiEndpoints.MetaTopXpUsers, successCallback, errorCallback)
end

function ImbaApi:MetaTopImrUsers(successCallback, errorCallback)
	self:SimplePerform(nil, ImbaApiEndpoints.MetaTopImrUsers, successCallback, errorCallback)
end

function ImbaApi:MetaHotDisabledHeroes(successCallback, errorCallback)
	self:SimplePerform(nil, ImbaApiEndpoints.MetaHotDisabledHeroes, successCallback, errorCallback)

end

function ImbaApi:MetaCompanions(successCallback, errorCallback)
	self:SimplePerform(nil, ImbaApiEndpoints.MetaCompanions, successCallback, errorCallback)
end

function ImbaApi:MetaCompanionChange(data, successCallback, errorCallback)
	self:SimplePerform(data, ImbaApiEndpoints.MetaCompanionChange, successCallback, errorCallback)
end

ImbaApiInstance = ImbaApi:new(nil, ImbaApiConfig)
