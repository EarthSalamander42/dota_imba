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

function print_r ( t )   --To deep-decode the Json code...
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
                            print("player_key="..player_key)
                        end
                        if pos == "XP_has" then
                            XP_has = val
                            print("XP_has="..XP_has)
                        end
                    end
                end
            end
        end
    end
    if (type(t)=="table") then
        sub_print_r(t,"  ")
    end
    print()
end

function Server_OnConnectFull()
    print('123123')
    print(DOTA_MAX_TEAM_PLAYERS)
    table_PlayerID[1]= "a"
    table_PlayerID[3]= "n"
    print(table_PlayerID[1]..table_PlayerID[3])

end

function Server_SendAndGetInfoForAll()
    require('libraries/json')
    print('123123')
    print(DOTA_MAX_TEAM_PLAYERS)
    local iPlayerNum = 1
    for nPlayerID=0, DOTA_MAX_TEAM_PLAYERS-1 do
        if  PlayerResource:IsValidPlayer(nPlayerID)  then
        if PlayerResource:IsFakeClient(nPlayerID) then
        else
            table_SteamID64[nPlayerID] = tostring(PlayerResource:GetSteamID(nPlayerID))
            table_XP[nPlayerID] = tostring(100)

            local jsondata={}
            local jsontable={}
            jsontable.XP=table_XP[nPlayerID]
            jsontable.SteamID64=table_SteamID64[nPlayerID]
            table.insert(jsondata,jsontable)
            local request = CreateHTTPRequestScriptVM( "GET", "http://www.dota2imba.cn/XP_game_to_tmp.php" )
                request:SetHTTPRequestGetOrPostParameter("data_json",JSON:encode(jsondata))
                request:SetHTTPRequestGetOrPostParameter("auth",_AuthCode);
                request:Send(function(result)
                Adecode=JSON:decode(result.Body)
                print_r(Adecode)
            end )

            table_player_key[nPlayerID] = player_key
            table_XP_has[nPlayerID] = XP_has
        end
        end
    end

end


function Server_WaitToEnableXpGain()
    print("Hero select!!!!!")
end
