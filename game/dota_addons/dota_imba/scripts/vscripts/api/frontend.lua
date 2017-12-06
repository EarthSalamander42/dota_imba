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
    
    local winning_team = GAME_WINNER_TEAM
    local winning_team_number = 2
    if winning_team == "Dire" then
        winning_team_number = 3
    end
    
    local args = {
        id = api_preloaded.id,
        winner = winning_team_number,
        results = {}
    }

    ApiPrint("game_complete Before player info collection")

    local player_count = 0

    for playerID = 0, DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            player_count = player_count + 1
        end
    end

    ApiPrint("game_complete player count in game_complete: " .. tostring(player_count))

    -- for each player
    for pid = 0, DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(pid) then
            local player = PlayerResource:GetPlayer(pid)
            local id = tostring(PlayerResource:GetSteamID(pid))

            local hero = PlayerResource:GetPickedHero(pid)
            local items = {}

            if hero == nil then
                ApiPrint("Hero for player " .. id .. " is nil")
            else
                -- get all items
                -- inventory + backpack
                for slot = 0, MAX_ITEM_SLOT do
                    local item = hero:GetItemInSlot(slot)
                    if item ~= nil then
                        table.insert(items, tostring(item:GetAbilityName()))
                    end
                end    
            end

            local rhero = json.null
            if hero ~= nil then
                rhero = tostring(hero:GetUnitName())
            end

            -- final object for user
            args.results[id] = {
                team = tonumber(PlayerResource:getTeam()),
                hero = rhero,
                items = items,
                aegis_pickups = tonumber(PlayerResource:GetAegisPickups(pid)),
                assists = tonumber(PlayerResource:GetAssists(pid)),
                claimed_denies = tonumber(PlayerResource:GetClaimedDenies(pid)),
                claimed_farm = tonumber(PlayerResource:GetClaimedFarm(pid)),
                claimed_misses = tonumber(PlayerResource:GetClaimedMisses(pid)),
                connection_state = tonumber(PlayerResource:GetConnectionState(pid)),
                creep_damage_taken = tonumber(PlayerResource:GetCreepDamageTaken(pid)),
                deaths = tonumber(PlayerResource:GetDeaths(pid)),
                denies = tonumber(PlayerResource:GetDenies(pid)),
                gold = tonumber(PlayerResource:GetGold(pid)),
                gold_lost_to_death = tonumber(PlayerResource:GetGoldLostToDeath(pid)),
                gold_per_minute = tonumber(PlayerResource:GetGoldPerMinute(pid)),
                gold_spent_on_buybacks = tonumber(PlayerResource:GetGoldSpentOnBuybacks(pid)),
                gold_spent_on_consumables = tonumber(PlayerResource:GetGoldSpentOnConsumables(pid)),
                gold_spent_on_items = tonumber(PlayerResource:GetGoldSpentOnItems(pid)),
                gold_spent_on_support = tonumber(PlayerResource:GetGoldSpentOnSupport(pid)),
                healing = tonumber(PlayerResource:GetHealing(pid)),
                hero_damage_taken = tonumber(PlayerResource:GetHeroDamageTaken(pid)),
                kills = tonumber(PlayerResource:GetKills(pid)),
                last_hit_multikill = tonumber(PlayerResource:GetLastHitMultikill(pid)),
                last_hits = tonumber(PlayerResource:GetLastHits(pid)),
                last_hit_streak = tonumber(PlayerResource:GetLastHitStreak(pid)),
                level = tonumber(PlayerResource:GetLevel(pid)),
                misses = tonumber(PlayerResource:GetMisses(pid)),
                nearby_creep_deaths = tonumber(PlayerResource:GetNearbyCreepDeaths(pid)),
                consumables_purchased = tonumber(PlayerResource:GetConsumablesPurchased(pid)),
                items_purchased = tonumber(PlayerResource:GetItemsPurchased(pid)),
                player_name = tostring(PlayerResource:GetPlayerName(pid)),
                raw_player_damage = tonumber(PlayerResource:GetRawPlayerDamage(pid)),
                reliable_gold = tonumber(PlayerResource:GetReliableGold(pid)),
                roshan_kills = tonumber(PlayerResource:GetRoshanKills(pid)),
                rune_pickups = tonumber(PlayerResource:GetRunePickups(pid)),
                streak = tonumber(PlayerResource:GetStreak(pid)),
                stuns = tonumber(PlayerResource:GetStuns(pid)),
                total_earned_gold = tonumber(PlayerResource:GetTotalEarnedGold(pid)),
                total_earned_xp = tonumber(PlayerResource:GetTotalEarnedXp(pid)),
                total_gold_spent = tonumber(PlayerResource:GetTotalGoldSpent(pid)),
                tower_damage_taken = tonumber(PlayerResource:GetTowerDamageTaken(pid)),
                tower_kills = tonumber(PlayerResource:GetTowerKills(pid)),
                unreliable_gold = tonumber(PlayerResource:GetUnreliableGold(pid)),
                xp_per_minute = tonumber(PlayerResource:GetXpPerMinute(pid)),
                team = tonumber(PlayerResource:GetTeam(pid)),
                valid_player = true
            };
        end
    end

    ApiPrint(json.encode(args))
    ApiPrint("game_complete after player info collection");
    
    -- perform request
    imba_api():game_complete(args, function (data)
        ApiPrint("Request good")
        print("[api-frontend] Request good (Game save)")
    end, function (err)
        if (err == nil) then
            ApiPrint("request failed with nil")
        elseif (err.message ~= nil) then
            ApiPrint("request failed :" .. err.message)
        end
        print("[api-frontend] Request failed!")
    end)

    ApiPrint("Serialization successful")
    print("[api-frontend] Saving game to server")
end

-- Saves a print message to server
function ApiPrint(str)
    imba_api_game_event("debug", str);
end

