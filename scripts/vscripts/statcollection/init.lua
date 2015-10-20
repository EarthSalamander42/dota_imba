require("statcollection/schema")
require('statcollection/lib/statcollection')

statInfo = LoadKeyValues('scripts/vscripts/statcollection/settings.kv')
local COLLECT_STATS = not Convars:GetBool('developer')
local TESTING = tobool(statInfo.TESTING)
local MIN_PLAYERS = tonumber(statInfo.MIN_PLAYERS)
local HAS_SCHEMA = (statInfo.schemaID ~= 'XXXXXXXXXXXXXXXX')
print("COLLECT STATS? "..(COLLECT_STATS and 1 or 0))
print("TESTING? "..(TESTING and 1 or 0))
print("MIN PLAYERS? "..MIN_PLAYERS)
print("HAS SCHEMA? "..(HAS_SCHEMA and 1 or 0))

if COLLECT_STATS or TESTING then
    print("detected stats should be collected")
    ListenToGameEvent('game_rules_state_change', function(keys)
        local state = GameRules:State_Get()
        
        if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
            print("detected custom game setup stage")
            if PlayerResource:GetPlayerCount() >= MIN_PLAYERS or TESTING then
                print("Min players: "..MIN_PLAYERS.." actual players: "..PlayerResource:GetPlayerCount())

                -- Init stat collection
                statCollection:init()

                -- Only do schema stuff if we have a schema
                if HAS_SCHEMA then
                    customSchema:init()
                    print("doing schema stuff")
                end
            end
        end
    end, nil)
end