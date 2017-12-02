---
--- Simple syncronous API frontend. UNSAFE
---

require("api/api")

local api_preloaded = {}

function imba_api_init()

    print("[api-frontend] init")

    imba_api_preload()
    imba_api_game_register()
end

-- Call this function at the start of the server
-- returns nil
function imba_api_preload()
    
    print("[api-frontend] preloading")

    imba_api():meta_donators(function (donors)
       api_preloaded.donators = donors
    end)
    
    imba_api():meta_developers(function (devs)
        api_preloaded.developers = devs
    end)

end

-- Syncronous
-- returns array of donators or nil
function get_donators()
    return api_preloaded.donators
end

-- Syncronous
-- returns array of developers or nil
function get_developers()
    return api_preloaded.developers
end

-- Async. Will write a game event to the server
-- event and content mandatory, tag optional 
function imba_api_game_event(event, content, tag)
    imba_api():game_log({ 
        match_id = GameRules:GetMatchID(),
        event = event,
        content = content,
        tag = tag
    }, function (response) end, 
        function () print("[api-frontend] Error writing game event") end)
end

function imba_api_get_match_id() 
    return tonumber(tostring(GameRules:GetMatchID()))
end

function imba_api_game_register()
    
    -- get players
    local players = {}
    local leader = nil
    local match_id = imba_api_get_match_id()
    
    for playerID = 0, DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            local player = PlayerResource:GetPlayer( playerID )
            local id = PlayerResource:GetSteamID(playerID)
            table.insert(players, tostring(id))
            if GameRules:PlayerHasCustomGameHostPrivileges(player) then
                leader = tostring(id)
            end
        end
    end

    local dedicated = false

    -- dedicated
    if IsDedicatedServer() then
        dedicated = true
    end

    imba_api():game_register({
        match_id = tonumber(match_id),
        map = tostring(GetMapName()),
        leader = leader,
        dedicated = true,
        players = players
    }, function (data) 
        print("[api-frontend] Request good: ID: " .. tostring(data.id))
        api_preloaded.players = data.players
        api_preloaded.id = data.id
    end, function (err)
        print("[api-frontend] Request failed")
        api_preloaded.id = 0
    end)

end

--[[
function imba_api_game_complete(winner)

    local match_id = imba_api_get_match_id()

    for playerID = 0, DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            local player = PlayerResource:GetPlayer( playerID )
            local id = PlayerResource:GetSteamID(playerID)
            local team = PlayerResource:GetTeam(playerID)
            local hero = player:GetAssignedHero()
        end
    end
end
]]--
