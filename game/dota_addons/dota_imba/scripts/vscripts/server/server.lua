local statInfo = LoadKeyValues('scripts/vscripts/server/auth.kv')


local _AuthCode = statInfo._auth --The auth code for game and http server


local table_PlayerID = {}
local table_SteamID64 = {}
local table_player_key = {}
local table_able = {}
local table_XP_has = {}
local table_XP = {}

local SteamID64
local player_key
local XP_has

local EnnDisEnabled = 0


--Level table for IMBA XP
local table_rankXP = {0,100,200,300,400,500,600,800,1000,1200,1400,1700,2000,2300,2600,2900,3400,3800,4200,4600,5000,5500,6000,6500,7000,7500,8500,9000,9500,10000,10500}
--------------------  0  1   2   3   4   5   6   7    8    9    10  11    12  13    14  15   16   17   18   19   20   21   22   23   24   25   26   27   28   29    30 
local XP_level_title= {}
local XP_level = {}
local XP_level_title_player = {}
local XP_need_to_next_level = {}
local XP_this_level = {}
local XP_has_this_level = {}
--Level table for IMBA XP

function Server_SetRankTitle()

    for ni = 1 , 31 do
        if ni==1 then
            XP_level_title[ni]=''
        end
        if ni>=2 and ni<=6 then
            XP_level_title[ni]='#imba_rank_title_rookie'
        end
        if ni>=7 and ni<=11 then
            XP_level_title[ni]='#imba_rank_title_amateur'
        end
        if ni>=12 and ni<=16 then
            XP_level_title[ni]='#imba_rank_title_warrior'
        end
        if ni>=17 and ni<=21 then
            XP_level_title[ni]='#imba_rank_title_general'
        end
        if ni>=22 and ni<=26 then
            XP_level_title[ni]='#imba_rank_title_master'
        end
        if ni>=27 and ni<=31 then
            XP_level_title[ni]='#imba_rank_title_legendary'
        end
    end

end
function Server_DecodeForPlayer ( t, nPlayerID )   --To deep-decode the Json code...
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                    elseif (type(val)=="string") then
                        --print(pos..':'..val)
                        if pos == "SteamID64" then
                            SteamID64 = val
                            print("SteamID64="..SteamID64)
                        end
                        if pos == "player_key" then
                            player_key = val
                            table_player_key[nPlayerID] = tostring(player_key)
                            print("player_key="..table_player_key[nPlayerID])
                        end
                        if pos == "XP_has" then
                            XP_has = val
                            table_XP_has[nPlayerID] = tostring(XP_has)
                            print("XP_has="..table_XP_has[nPlayerID])
                        end
                        table_able[nPlayerID] = tostring(0)
                    end
                end
            end
        end
    end
    if (type(t)=="table") then
        sub_print_r(t,"  ")
    end
    print()
    print("PlayerID:"..nPlayerID)
end

function Server_PrintInfo()
    for nPlayerID=0, DOTA_MAX_TEAM_PLAYERS-1 do
        if  PlayerResource:IsValidPlayer(nPlayerID)  then
        if PlayerResource:IsFakeClient(nPlayerID) then
        else
            print("=============================")
            print("PlayerID:"..nPlayerID)
            print("SteamID64:"..table_SteamID64[nPlayerID])
            print("Level:"..XP_level[nPlayerID])
            print("Rank_title:"..XP_level_title_player[nPlayerID])
            print("XP this level need:"..XP_this_level[nPlayerID])
            print("XP has in this level:"..XP_has_this_level[nPlayerID])
            print("XP need to level up:"..XP_need_to_next_level[nPlayerID])
            print("player_key:"..table_player_key[nPlayerID])
            print("If able to get XP:"..table_able[nPlayerID])
            print("XP has:"..table_XP_has[nPlayerID])
            print("XP to get this game:"..table_XP[nPlayerID])
            print("Team(2 is Radiant, 3 is Dire):"..PlayerResource:GetTeam(nPlayerID))
            print("=============================")
        end
        end
    end
end

function Server_GetPlayerLevelAndTitle(nPlayerID)
    --print("1231231313"..table_XP_has[nPlayerID])
    for i=31,1,-1 do
        if tonumber(table_XP_has[nPlayerID]) >= table_rankXP[i] then
            XP_level[nPlayerID] = i-1
            XP_level_title_player[nPlayerID] = XP_level_title[i]
            XP_this_level[nPlayerID] = table_rankXP[i]
            if i == 31 then
                XP_need_to_next_level[nPlayerID] = 0
            else
                XP_need_to_next_level[nPlayerID] = table_rankXP[i+1] - tonumber(table_XP_has[nPlayerID])
            end
            XP_has_this_level[nPlayerID] = tonumber(table_XP_has[nPlayerID]) - table_rankXP[i]
            break
        end
    end
end


function Server_SendAndGetInfoForAll()
    require('libraries/json')
    Server_SetRankTitle()
    --print('123123')
    --print(DOTA_MAX_TEAM_PLAYERS)
    for nPlayerID=0, DOTA_MAX_TEAM_PLAYERS-1 do
        if  PlayerResource:IsValidPlayer(nPlayerID)  then
        if PlayerResource:IsFakeClient(nPlayerID) then
        else

            table_SteamID64[nPlayerID] = tostring(PlayerResource:GetSteamID(nPlayerID))
            table_XP[nPlayerID] = tostring(math.random(18,32)) --How many XP will player get in this game

            local jsondata={}
            local jsontable={}
            jsontable.SteamID64 = table_SteamID64[nPlayerID]
            jsontable.XP = table_XP[nPlayerID]
            table.insert(jsondata,jsontable)
            local request = CreateHTTPRequestScriptVM( "GET", "http://www.dota2imba.cn/XP_game_to_tmp.php" )
                request:SetHTTPRequestGetOrPostParameter("data_json",JSON:encode(jsondata))
                request:SetHTTPRequestGetOrPostParameter("auth",_AuthCode);
                request:Send(function(result)
                Adecode=JSON:decode(result.Body)
                Server_DecodeForPlayer(Adecode, nPlayerID)
                Server_GetPlayerLevelAndTitle(nPlayerID)
            end )
            --Server_GetPlayerLevelAndTitle(nPlayerID)

        end
        end
    end
end

function Server_EnableToGainXPForPlyaer(nPlayerID)
    --print("player key:"..table_player_key[nPlayerID])
    if EnnDisEnabled == 1 then
        table_able[nPlayerID] = 1
        local jsondata={}
        local jsontable={}
        jsontable.player_key = table_player_key[nPlayerID]
        jsontable._able = table_able[nPlayerID]
        jsontable.SteamID64 = table_SteamID64[nPlayerID]
        table.insert(jsondata,jsontable)
        local request = CreateHTTPRequestScriptVM( "GET", "http://www.dota2imba.cn/XP_ability_to_gain.php" )
            request:SetHTTPRequestGetOrPostParameter("data_json",JSON:encode(jsondata))
            request:SetHTTPRequestGetOrPostParameter("auth",_AuthCode);
            request:Send(function(result)
            --print(table_SteamID64[nPlayerID].."("..player_key[nPlayerID].."):Can gain XP...Code="..table_able[nPlayerID])
            --print(result.Body)
        end )
    end
end

function Server_DisableToGainXpForPlayer(nPlayerID)
    --print("player key:"..table_player_key[nPlayerID])
    if EnnDisEnabled == 1 then
        table_able[nPlayerID] = 0
        local jsondata={}
        local jsontable={}
        jsontable.player_key = table_player_key[nPlayerID]
        jsontable._able = table_able[nPlayerID]
        jsontable.SteamID64 = table_SteamID64[nPlayerID]
        table.insert(jsondata,jsontable)
        local request = CreateHTTPRequestScriptVM( "GET", "http://www.dota2imba.cn/XP_ability_to_gain.php" )
            request:SetHTTPRequestGetOrPostParameter("data_json",JSON:encode(jsondata))
            request:SetHTTPRequestGetOrPostParameter("auth",_AuthCode);
            request:Send(function(result)
            --print(table_SteamID64[nPlayerID].."("..player_key[nPlayerID].."):Can **not** gain XP...Code="..table_able[nPlayerID])
            --print(result.Body)
        end )
    end
end

    -- GetConnectionState values:
    -- 0 - no connection
    -- 1 - bot connected
    -- 2 - player connected
    -- 3 - bot/player disconnected.



function Server_WaitToEnableXpGain()
    Timers:CreateTimer({
    endTime = 1, -- Plyaer can gain XP from this game after 10 mins later the creep spwans
    callback = function()
        EnnDisEnabled = 1
        print("Enable Xp gain system....")
        for nPlayerID=0, DOTA_MAX_TEAM_PLAYERS-1 do
            if PlayerResource:IsValidPlayer(nPlayerID)  then
            if PlayerResource:IsFakeClient(nPlayerID) then
            else
                -- Determain if this guy could gain XP
                if PlayerResource:GetConnectionState(nPlayerID) == 2 then
                    table_able[nPlayerID] = 1
                    Server_EnableToGainXPForPlyaer(nPlayerID)
                end
                if PlayerResource:GetConnectionState(nPlayerID) == 3 then
                    table_able[nPlayerID] = 0
                    Server_DisableToGainXpForPlayer(nPlayerID)
                end
                -- Determain if this guy could gain XP
            end
            end
        end
    end
    })
end

-- Radiant=2 or Dire=3

function Server_CalculateXPForWinnerAndAll(winning_team)
    local Winner
    for nPlayerID=0, DOTA_MAX_TEAM_PLAYERS-1 do
        if  PlayerResource:IsValidPlayer(nPlayerID)  then
        if PlayerResource:IsFakeClient(nPlayerID) then
        else
            if winning_team == "Radiant" then
                Winner = DOTA_TEAM_GOODGUYS
            end
            if winning_team == "Dire" then
                Winner = DOTA_TEAM_BADGUYS
            end
            local jsondata={}
            local jsontable={}
            jsontable.SteamID64 = table_SteamID64[nPlayerID]
            jsontable.XP = table_XP[nPlayerID]
            if PlayerResource:GetTeam(nPlayerID) == Winner then
                jsontable.XP = tostring(math.ceil(table_XP[nPlayerID] * 1.2))
            end
            jsontable.player_key = table_player_key[nPlayerID]
            table.insert(jsondata,jsontable)
            local request = CreateHTTPRequestScriptVM( "GET", "http://www.dota2imba.cn/XP_game_end_tmp_to_perm.php" )
                request:SetHTTPRequestGetOrPostParameter("data_json",JSON:encode(jsondata))
                request:SetHTTPRequestGetOrPostParameter("auth",_AuthCode);
                request:Send(function(result)
                --Adecode=JSON:decode(result.Body)
                --Server_DecodeForPlayer(Adecode, nPlayerID)
            end )

        end
        end
    end 
end
