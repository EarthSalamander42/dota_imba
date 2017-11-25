-- 
-- IMBA API
--

require("api/json")

-- Constants
IMBA_API_CONFIG = {
    key = "3utx8DehTd42Wxqh65ldAErJjoCdi6XB",
    endpoint = "https://api.dota2imba.org",
    agent = "dota_imba-lua-1.x",
    timeout = 1000
}

IMBA_API_ENDPOINTS = {
    meta_news = "/meta/news",
    meta_donators = "/meta/donators",
    meta_developers = "/meta/developers"
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
    print("[API] " .. t)
end

function ImbaApi:perform(robj, endpoint, callback)

    local payload = nil
    local method = "GET"

    -- build base request
    if robj == nil then
        local base_request = {
            agent = self.config.agent,
            version = 1,
            data = robj
        }

        method = "POST"
    
        -- encode with json
        payload = json.encode(base_request)
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
                callback(false, rp)
            end
        end
    end)

end

function ImbaApi:meta_news(success_cb, error_cb)
    self:perform(nil, IMBA_API_ENDPOINTS.meta_news, function (err, rs)
        if err then 
            if error_cb then error_cb() end
        else success_cb(rs.data) end
    end)
end

function ImbaApi:meta_donators(success_cb, error_cb)
    self:perform(nil, IMBA_API_ENDPOINTS.meta_donators, function (err, rs)
        if err then
            if error_cb then error_cb() end
        else success_cb(rs.data) end
    end)
end

function ImbaApi:meta_developers(success_cb, error_cb)
    self:perform(nil, IMBA_API_ENDPOINTS.meta_developers, function (err, rs)
        if err then 
            if error_cb then error_cb() end
        else success_cb(rs.data) end
    end)
end

function imba_api_test()
    print("[API-TEST] IMBA API Test")

    local api = imba_api()

    api:meta_news(function (data)
        print("[API-TEST] " .. data.title)
        print("[API-TEST] " .. data.article)
    end)
end

-- Internal Vars
_api_instance = nil

-- functions
function imba_api()
    if _api_instance == nil then
        _api_instance = ImbaApi:new(nil, IMBA_API_CONFIG)
    end
 
    return _api_instance
end
