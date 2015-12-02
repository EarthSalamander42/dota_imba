--[[
Integrating the library into your scripts

1. Download the statcollection from github and merge the scripts folder into your game/YOUR_ADDON/ folder.
2. In your addon_game_mode.lua file, copy this line at the top: require('statcollection/init')
3. Go into the scripts/vscripts/statcollection folder and inside the `settings.kv` file, change the modID XXXXX value with the modID key that was handed to you by an admin.
4. After this, you will be sending the default basic stats when a lobby is succesfully created, and after the match ends.
   You are encouraged to add your own gamemode-specific stats (such as a particular game setting or items being purchased). More about this on the next section.

If you'd like to store flags, for example, the amount of kills to win, it can be done like so:

statCollection:setFlags({FlagName = 'FlagValue'})

Customising the stats beyond this will require talking to the GetDotaStats staff so a custom schema can be built for you.
Extended functionality will be added as it is needed.

Come bug us in our IRC channel or get in contact via the site chatbox. http://getdotastats.com/#contact
]]

-- Require libs
require('statcollection/lib/md5')
require('statcollection/schema')

-- Settings
local statInfo = LoadKeyValues('scripts/vscripts/statcollection/settings.kv')

-- Where stuff is posted to
local postLocation = 'http://getdotastats.com/s2/api/'

-- The schema version we are currently using
local schemaVersion = 4

-- Constants used for pretty formatting, as well as strings
local printPrefix = 'Stat Collection: '

local errorFailedToContactServer = 'Failed to contact the master server! Bad status code, or no body!'
local errorMissingModIdentifier = 'Please ensure you have a settings.kv in your statcollection folder! Missing modID!'
local errorDefaultModIdentifier = 'Please change your settings.kv with a valid modID, acquired after registration of your mod on the site!'
local errorMissingSchemaIdentifier = 'Please ensure you have a settings.kv in your statcollection folder! Missing schemaID!'
local errorDefaultSchemaIdentifier = 'Please change your settings.kv with a valid schemaID, acquired after contacting a site admin!'
local errorInitCalledTwice = 'Please ensure you only make a single call to statCollection:init, only the first call actually works.'
local errorJsonDecode = 'There was an issue decoding the JSON returned from the server, see below:'
local errorSomethingWentWrong = 'The server said something went wrong, see below:'
local errorRunInit = 'You need to call the init function before you can send stats!'
local errorMissedStage1 = 'You need to call the sendStage1 function before you can continue!'
local errorFlags = 'Flags needs to be a table!'
local errorSchemaNotEnabled = 'Schema has not been enabled!!'
local errorBadSchema = 'This schema doesn\'t exist!!'
local errorMissingModID = 'Missing modID'
local errorMissingSchemaID = 'Missing schemaID'

local messageStarting = 'GetDotaStats module is trying to init...'
local messagePhase1Starting = 'Attempting to register the match with GetDotaStats...'
local messagePhase2Starting = 'Attempting to send pregame stats...'
local messagePhase3Starting = 'Attempting to send final stats...'
local messageCustomStarting = 'Attempting to send custom stats...'
local messagePhase1Complete = 'Match was successfully registered with GetDotaStats!'
local messagePhase2Complete = 'Match pregame settings have been recorded!'
local messagePhase3Complete = 'Match stats were successfully recorded!'
local messageCustomComplete = 'Match custom stats were successfully recorded!'
local messageFlagsSet = 'Flag was successfully set!'

-- Create the stat collection class
if not statCollection then
    statCollection = class({})
end

-- Function that will setup stat collection
function statCollection:init()
    -- Only allow init to be run once
    if self.doneInit then
        print(printPrefix .. errorInitCalledTwice)
        return
    end
    self.doneInit = true

    -- Print the intro message
    print(printPrefix .. messageStarting)

    -- Check for a modIdentifier
    local modIdentifier = statInfo.modID
    if not modIdentifier then
        print(printPrefix .. errorMissingModIdentifier)

    elseif modIdentifier == 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' then
        print(printPrefix .. errorDefaultModIdentifier)

        self.doneInit = false
        return
    end

    --[[ Check for a schemaIdentifier
    if not schemaID then
        print(printPrefix .. errorMissingSchemaIdentifier)
    elseif schemaID == 'XXXXXXXXXXXXXXXX' and self.HAS_SCHEMA then
        print(printPrefix.. errorDefaultSchemaIdentifier)

        self.doneInit = false
        return
    end]]

    -- Load and set settings
    self.HAS_SCHEMA = statInfo.schemaID ~= 'XXXXXXXXXXXXXXXX'
    self.HAS_ROUNDS = tobool(statInfo.HAS_ROUNDS)
    self.GAME_WINNER = tobool(statInfo.GAME_WINNER)
    self.ANCIENT_EXPLOSION = tobool(statInfo.ANCIENT_EXPLOSION)
    self.TESTING = tobool(statInfo.TESTING)

    -- Store the modIdentifier
    self.modIdentifier = modIdentifier

    -- Store the schemaIdentifier
    self.SCHEMA_KEY = statInfo.schemaID

    -- Set the default winner to -1 (no winner)
    self.winner = -1

    --Store roundID globally
    self.roundID = 0

    -- Hook requred functions to operate correctly
    self:hookFunctions()
end

--Build the winners array
function statCollection:calcWinnersByTeam()
    local output = {}
    local winningTeam = self.winner

    for playerID = 0, DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            output[PlayerResource:GetSteamAccountID(playerID)] = PlayerResource:GetTeam(playerID) == winningTeam and '1' or '0'
        end
    end

    return output
end

-- Hooks functions to make things actually work
function statCollection:hookFunctions()
    local this = self

    -- Hook winner function
    if self.GAME_WINNER then
        local oldSetGameWinner = GameRules.SetGameWinner
        GameRules.SetGameWinner = function(gameRules, team)

            -- Store the stats
            this.winner = team

            -- Run the rael setGameWinner function
            oldSetGameWinner(gameRules, team)

            -- Attempt to send stage 3, since the match is over
            this:sendStage3(this:calcWinnersByTeam(), true)
        end
    end

    -- If we are testing (i.e. in workshop tools, don't wait for player connects to check)
    if self.TESTING then
        -- Send stage1 stuff
        this:sendStage1()
    else
        --Wait for host before sending Phase 1
        ListenToGameEvent('player_connect_full', function(keys)
            -- Ensure we can only send it once, and everything is good to go
            if self.playerCheckStage1 then return end

            -- Check each connected player to see if they are host
            for playerID = 0, DOTA_MAX_TEAM_PLAYERS do
                if PlayerResource:IsValidPlayerID(playerID) then
                    local player = PlayerResource:GetPlayer(playerID)

                    if GameRules:PlayerHasCustomGameHostPrivileges(player) then
                        self.playerCheckStage1 = true
                        -- Send stage1 stuff
                        this:sendStage1()
                        break
                    end
                end
            end
        end, nil)
    end

    -- Listen for changes in the current state
    ListenToGameEvent('game_rules_state_change', function(keys)
        -- Grab the current state
        local state = GameRules:State_Get()

        if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
            -- Load time flag
            statCollection:setFlags({ loadTime = math.floor(GameRules:GetGameTime()) })

            -- Start the client checking recording
            CustomUI:DynamicHud_Create(-1, "statcollection", "file://{resources}/layout/custom_game/statcollection.xml", nil)

        elseif state >= DOTA_GAMERULES_STATE_PRE_GAME then
            -- Send pregame stats
            this:sendStage2()
        end
        if self.ANCIENT_EXPLOSION then
            if state >= DOTA_GAMERULES_STATE_POST_GAME then
                -- Send postgame stats
                self:findWinnerUsingForts()
                this:sendStage3(this:calcWinnersByTeam(), true)
            end
        end
    end, nil)
end

-- This function will attempt to detect the winner using forts, if winner is currently -1
function statCollection:findWinnerUsingForts()
    -- Check if we have found no winner yet
    if self.winner == -1 then
        local winners = 0

        local forts = Entities:FindAllByClassname('npc_dota_fort')
        for k, v in pairs(forts) do
            -- Check it's HP level
            if v:GetHealth() > 0 then
                local team = v:GetTeam()

                if winners == 0 then
                    winners = team
                else
                    winners = -1
                end
            end
        end

        if winners == 0 then
            winners = -1
        end

        -- Return our estimate
        self.winner = winners
    end
end

-- Sets a flag
function statCollection:setFlags(flags)
    if not self.flags then self.flags = {} end

    if type(flags) == "table" then
        -- Store the new flags
        for flagKey, flagValue in pairs(flags) do
            self.flags[flagKey] = flagValue
            print(printPrefix .. messageFlagsSet .. " {" .. flagKey .. ":" .. tostring(flagValue) .. "}")
        end

    else
        -- Yell at the developer
        print(printPrefix .. errorFlags)
    end
end

-- Sends stage1
function statCollection:sendStage1()
    -- If we are missing required parameters, then don't send
    if not self.doneInit then
        print("sendStage1 ERROR")
        print(printPrefix .. errorRunInit)
        return
    end

    -- Ensure we can only send it once, and everything is good to go
    if self.sentStage1 then return end
    self.sentStage1 = true

    -- Print the intro message
    print(printPrefix .. messagePhase1Starting)

    -- Grab a reference to self
    local this = self

    -- Workout the player count
    local playerCount = PlayerResource:GetPlayerCount()
    if playerCount <= 0 then playerCount = 1 end
    statCollection:setFlags({ numPlayers = playerCount })

    -- Workout who is hosting
    local hostID = 0
    for playerID = 0, DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            local player = PlayerResource:GetPlayer(playerID)
            if GameRules:PlayerHasCustomGameHostPrivileges(player) then
                hostID = playerID
                break
            end
        end
    end
    local hostSteamID = PlayerResource:GetSteamAccountID(hostID)

    -- Workout if the server is dedicated or not
    local isDedicated = (IsDedicatedServer() and 1) or 0
    statCollection:setFlags({ dedi = isDedicated })

    -- Grab the mapname
    local mapName = GetMapName()
    statCollection:setFlags({ map = mapName })

    -- Build the payload
    local payload = {
        modIdentifier = self.modIdentifier,
        hostSteamID32 = tostring(hostSteamID),
        schemaVersion = schemaVersion
    }

    -- Begin the initial request
    self:sendStage('s2_phase_1.php', payload, function(err, res)
        -- Check if we got an error
        if err then
            print(printPrefix .. errorJsonDecode)
            print(printPrefix .. err)
            return
        end

        -- Check for an error
        if res.error then
            print(printPrefix .. errorSomethingWentWrong)
            print(res.error)
            return
        end

        -- Woot, store our vars
        this.authKey = res.authKey
        this.matchID = res.matchID

        -- Tell the user
        print(printPrefix .. messagePhase1Complete)
    end)
end

-- Sends stage2
function statCollection:sendStage2()
    -- If we are missing required parameters, then don't send
    if not self.doneInit then
        print("sendStage2 ERROR")
        print(printPrefix .. errorRunInit)
        return
    end

    -- If we are missing stage1 stuff, don't continue
    if not self.authKey or not self.matchID then
        print("sendStage2 ERROR")
        print(printPrefix .. errorMissedStage1)
        return
    end

    -- Ensure we can only send it once, and everything is good to go
    if self.sentStage2 then return end
    self.sentStage2 = true

    -- Print the intro message
    print(printPrefix .. messagePhase2Starting)

    -- Client check in
    CustomGameEventManager:Send_ServerToAllClients("statcollection_client", { modID = self.modIdentifier, matchID = self.matchID, schemaVersion = schemaVersion })

    -- Build players array
    local players = {}
    for playerID = 0, DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            table.insert(players, {
                playerName = PlayerResource:GetPlayerName(playerID),
                steamID32 = PlayerResource:GetSteamAccountID(playerID),
                connectionState = PlayerResource:GetConnectionState(playerID)
            })
        end
    end

    local payload = {
        authKey = self.authKey,
        matchID = self.matchID,
        modIdentifier = self.modIdentifier,
        flags = self.flags,
        schemaVersion = schemaVersion,
        players = players
    }

    -- Send stage2
    self:sendStage('s2_phase_2.php', payload, function(err, res)
        -- Check if we got an error
        if err then
            print(printPrefix .. errorJsonDecode)
            print(printPrefix .. err)
            return
        end

        -- Check for an error
        if res.error then
            print(printPrefix .. errorSomethingWentWrong)
            print(res.error)
            return
        end

        -- Tell the user
        print(printPrefix .. messagePhase2Complete)
    end)
end

-- Sends stage3
function statCollection:sendStage3(winners, lastRound)
    -- If we are missing required parameters, then don't send
    if not self.doneInit then
        print("sendStage3 ERROR")
        print(printPrefix .. errorRunInit)
        return
    end

    -- If we are missing stage1 stuff, don't continue
    if not self.authKey or not self.matchID then
        print("sendStage3 ERROR")
        print(printPrefix .. errorMissedStage1)
        return
    end

    -- Ensure we can only send it once, and everything is good to go
    if not self.HAS_ROUNDS then
        if self.sentStage3 then return end
        self.sentStage3 = true
    else
        self.roundID = self.roundID + 1
    end

    -- Print the intro message
    print(printPrefix .. messagePhase3Starting)

    -- Build players array
    local players = {}
    for playerID = 0, DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            local steamID = PlayerResource:GetSteamAccountID(playerID)

            table.insert(players, {
                steamID32 = steamID,
                connectionState = PlayerResource:GetConnectionState(playerID),
                isWinner = winners[steamID]
            })
        end
    end

    -- Build rounds table
    local rounds = {}
    rounds[tostring(self.roundID)] = {
        players = players
    }
    local payload = {
        authKey = self.authKey,
        matchID = self.matchID,
        modIdentifier = self.modIdentifier,
        schemaVersion = schemaVersion,
        rounds = rounds,
        gameDuration = GameRules:GetGameTime()
    }
    if lastRound == false then
        payload.gameFinished = 0
    end

    -- Send stage3
    self:sendStage('s2_phase_3.php', payload, function(err, res)
        -- Check if we got an error
        if err then
            print(printPrefix .. errorJsonDecode)
            print(printPrefix .. err)
            return
        end

        -- Check for an error
        if res.error then
            print(printPrefix .. errorSomethingWentWrong)
            print(res.error)
            return
        end

        -- Tell the user
        print(printPrefix .. messagePhase3Complete)
    end)
end

function statCollection:submitRound(args)
    --We receive the winners from the custom schema, lets tell phase 3 about it!
    local returnArgs = customSchema:submitRound(args)
    self:sendStage3(returnArgs.winners, returnArgs.lastRound)
end

-- Sends custom
function statCollection:sendCustom(args)
    if not self.HAS_SCHEMA then
        print("sendCustom ERROR")
        print(printPrefix .. errorDefaultSchemaIdentifier)
        return
    end

    local game = args.game or {} --Some custom gamemodes might not want this (ie, use player info only)
    local players = args.players or {} --Some custom gamemodes might not want this (ie, use game info only)
    if game == {} and players == {} then
        return --We have no info to actually send, truck it!
    end
    -- If we are missing required parameters, then don't send
    if not self.doneInit or not self.authKey or not self.matchID or not self.SCHEMA_KEY then
        print(printPrefix .. errorRunInit)
        if not self.SCHEMA_KEY then
            print(printPrefix .. errorRunInit)
        end
        return
    end

    -- Ensure we can only send it once, and everything is good to go
    if self.HAS_ROUNDS == false then
        if self.sentCustom then return end
        self.sentCustom = true
    end

    -- Print the intro message
    print(printPrefix .. messageCustomStarting)

    -- Build rounds table
    local rounds = {}
    rounds[tostring(self.roundID)] = {
        game = game,
        players = players
    }

    local payload = {
        authKey = self.authKey,
        matchID = self.matchID,
        modIdentifier = self.modIdentifier,
        schemaAuthKey = self.SCHEMA_KEY,
        schemaVersion = schemaVersion,
        rounds = rounds
    }

    -- Send custom
    self:sendStage('s2_custom.php', payload, function(err, res)
        -- Check if we got an error
        if err then
            print(printPrefix .. errorJsonDecode)
            print(printPrefix .. err)
            return
        end

        -- Check for an error
        if res.error then
            print(printPrefix .. errorSomethingWentWrong)
            print(res.error)
            return
        end

        -- Tell the user
        print(printPrefix .. messageCustomComplete)
    end)
end

-- Sends the payload data for the given stage, and return the result
function statCollection:sendStage(stageName, payload, callback)
    -- Create the request
    local req = CreateHTTPRequest('POST', postLocation .. stageName)
    --print(json.encode(payload))
    -- Add the data
    req:SetHTTPRequestGetOrPostParameter('payload', json.encode(payload))

    -- Send the request
    req:Send(function(res)
        if res.StatusCode ~= 200 or not res.Body then
            print(printPrefix .. errorFailedToContactServer)
            return
        end

        -- Try to decode the result
        local obj, pos, err = json.decode(res.Body, 1, nil)

        -- Feed the result into our callback
        callback(err, obj)
    end)
end

function tobool(s)
    if s == "true" or s == "1" or s == 1 then
        return true
    else --nil "false" "0"
    return false
    end
end