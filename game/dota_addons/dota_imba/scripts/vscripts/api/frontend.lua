---
--- Simple syncronous API frontend. UNSAFE
---

require("api/api")
require("api/json")

local api_preloaded = {}

-- has to be called in GameMode:OnFirstPlayerLoaded
-- loads donators / developers and registers the game
function imba_api_init()

    print("[api-frontend] init")

    imba_api_preload()
    imba_api_game_register()
end

-- has to be called in GameMode:OnFirstPlayerLoaded
-- will be called by imba_api_init()
-- loads donators and developers
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

-- Will write a custom game event to the server
-- event and content mandatory, tag optional 
function imba_api_game_event(event, content, tag)

    print("[api-frontend] Saving event")

    local rtag = json.null

    if (type(tag) ~= "nil") then
        rtag = tostring(tag)
    end

    imba_api():game_event({ 
        id = api_preloaded.id,
        event = tostring(event),
        content = tostring(content),
        tag = rtag
    }, function (response) end, 
        function () print("[api-frontend] Error writing game event") end)
end

-- returns the match id as integer
function imba_api_get_match_id() 
    return tonumber(tostring(GameRules:GetMatchID()))
end

-- has to be called in GameMode:OnFirstPlayerLoaded 
-- will be called by imba_api_init()
-- registers the game in the server and requests an id.
function imba_api_game_register()
    
    -- get players
    local players = {}
    local leader = nil
    local match_id = imba_api_get_match_id()
    
    -- for each player / get its id
    for playerID = 0, DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            local player = PlayerResource:GetPlayer( playerID )
            local id = PlayerResource:GetSteamID(playerID)
            table.insert(players, tostring(id))

            -- if this is the leader set him to our var
            if GameRules:PlayerHasCustomGameHostPrivileges(player) then
                leader = tostring(id)
            end
        end
    end

    -- test if this is a dedicated server
    local dedicated = false
    if IsDedicatedServer() then
        dedicated = true
    end

    -- final object
    local args = {
        match_id = tonumber(match_id),
        map = tostring(GetMapName()),
        leader = leader,
        dedicated = true,
        players = players
    }

    -- perform request
    imba_api():game_register(args, function (data) 
        print("[api-frontend] Request good: ID: " .. tostring(data.id))
        api_preloaded.players = data.players
        api_preloaded.id = data.id
    end, function (err)
        print("[api-frontend] Request failed!")
        api_preloaded.id = 0
    end)

end

local MAX_ITEM_SLOT = 14

-- Has to be called in DOTA_GAMERULES_STATE_POST_GAME
-- Collects stats infos and saves them to the server
-- Will later be used for IMR and XP changes
function imba_api_game_complete()

    local args = {
        id = api_preloaded.id,
        winner = GAME_WINNER_TEAM,
        results = {}
    }

    imba_api_game_event("debug", "game_complete Before player info collection")

    local player_count = 0

    for playerID = 0, DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            player_count = player_count + 1
        end
    end

    imba_api_game_event("debug", "game_complete player count in game_complete: " .. player_count)

    -- for each player
    for playerID = 0, DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            local player = PlayerResource:GetPlayer(playerID)
            local id = tostring(PlayerResource:GetSteamID(playerID))

            local hero = PlayerResource:GetPickedHero(playerID)
            local items = {}

            -- get all items
            -- inventory + backpack
            for slot = 0, MAX_ITEM_SLOT do
                local item = hero:GetItemInSlot(slot)
                if item ~= nil then
                    table.insert(items, tostring(item:GetAbilityName()))
                end
            end

            local teamid = tonumber(PlayerResource:GetTeam(playerID))

            -- winner team conversation
            local team = "Invalid"
            if (teamid == 2) then 
                team = "Radiant"
            elseif (teamid == 3) then
                tean = "Dire"
            end

            -- final object for user
            args.results[id] = {
                team = team,
                hero = hero:GetUnitName(),
                items = items,
                kills = PlayerResource:GetKills(playerID),
                deaths = PlayerResource:GetDeaths(playerID),
                assists = PlayerResource:GetAssists(playerID),
                xpm = PlayerResource:GetXPPerMin(playerID),
                gpm = PlayerResource:GetGoldPerMin(playerID),
                level = PlayerResource:GetLevel(playerID),
                xp = PlayerResource:GetTotalEarnedXP(playerID),
                gold = PlayerResource:GetGold(playerID)
            };
        end
    end

    imba_api_game_event("debug", "game_complete after player info collection")
    
    -- perform request
    imba_api():game_complete(args, function (data)
        imba_api_game_event("debug", "Request good")
        print("[api-frontend] Request good (Game save)")
    end, function (err)
        if (err == nil) then
            imba_api_game_event("debug", "request failed with nil")
        elseif (err.message ~= nil) then
            imba_api_game_event("debug", "request failed :" .. err.message)
        end
        print("[api-frontend] Request failed!")
    end)

    print("[api-frontend] Saving game to server")
end

-- Saves a print message to server
function ApiPrint(str)
    imba_api_game_event("debug", str);
end

