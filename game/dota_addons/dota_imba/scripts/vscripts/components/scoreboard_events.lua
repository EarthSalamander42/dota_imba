function UpdateSharedUnitControlForPlayer(playerID)
    local existing_table_value = {}
    -- 20 players
    for k=0,20 do
        if PlayerResource:IsValidPlayerID(k) and k~=playerID and PlayerResource:GetTeam(k) == PlayerResource:GetTeam(playerID) then
            existing_table_value[k] = PlayerResource:GetUnitShareMaskForPlayer(playerID, k)
        end
    end

    -- Change playerID to string
    CustomNetTables:SetTableValue( "shared_unit_control", ""..playerID, existing_table_value )
end

 -- bitmask; 1 shares heroes, 2 shares units, 4 disables help 
function FlipUnitShareMaskBit(targetPlayerID, otherPlayerID, bitVal)
   
    if bitVal > 0 and PlayerResource:IsValidPlayerID(targetPlayerID) and PlayerResource:IsValidPlayerID(otherPlayerID) then
        local currentUnitShareMask = PlayerResource:GetUnitShareMaskForPlayer(targetPlayerID, otherPlayerID)

        -- Toggle bit value
        local toggleBol
        if currentUnitShareMask == 0 then
            toggleBol = true
        else
            -- Find remainder of the bit higher than current target bit
            -- Then remove current bit from remainder. If it is lesser than 0 it will mean the bit did not exist.
            toggleBol = (((currentUnitShareMask % (bitVal*2)) - bitVal) < 0)
        end

        PlayerResource:SetUnitShareMaskForPlayer(targetPlayerID, otherPlayerID, bitVal, toggleBol)

        UpdateSharedUnitControlForPlayer(targetPlayerID)
    end
end

function ToggleDisablePlayerHelp(unused, kv)
    FlipUnitShareMaskBit(kv.PlayerID, kv.otherPlayerID, 4)
end

function ToggleDisableShareUnit(unused, kv)
    FlipUnitShareMaskBit(kv.PlayerID, kv.otherPlayerID, 2)
end

function ToggleDisableShareHero(unused, kv)
    FlipUnitShareMaskBit(kv.PlayerID, kv.otherPlayerID, 1)
end

function initScoreBoardEvents()
    -- Populate net table "shared_unit_control"
    -- 20 players
    for i=0, 20 do
        if PlayerResource:IsValidPlayerID(i) then
            UpdateSharedUnitControlForPlayer(i)
        end
    end

    CustomGameEventManager:RegisterListener("toggle_disable_player_help", ToggleDisablePlayerHelp)
    CustomGameEventManager:RegisterListener("toggle_share_unit", ToggleDisableShareUnit)
    CustomGameEventManager:RegisterListener("toggle_share_hero", ToggleDisableShareHero)
end
