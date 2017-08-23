STAT_UTILITIES_VERSION = "0.2"

--[[
    This file contains a general use API for collecting stats, to be used in your schema.lua BuildGameArray or BuildPlayersArray
    It will be extended with more functionalities as the library gets more usage and example cases
    All the functions should only use methods from the Dota API, and not contain calls to a value specific to a certain game mode (use a different file for this!)
]]

------------------------------
-- Game Functions     --
------------------------------

-- Number of times roshan was killed
function GetRoshanKills()
    local total_rosh_kills = 0
    for playerID = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            local roshan_kills_player = PlayerResource:GetRoshanKills(playerID)
            total_rosh_kills = total_rosh_kills + roshan_kills_player
        end
    end

    return total_rosh_kills
end

------------------------------
-- Player Functions    --
------------------------------

-- Hero name without its npc_dota_hero prefix.
-- If you would like to send custom hero names you should use a different function instead
function GetHeroName(playerID)
    local heroName = PlayerResource:GetSelectedHeroName(playerID)
    heroName = string.gsub(heroName, "npc_dota_hero_", "") --Cuts the npc_dota_hero_ prefix

    return heroName
end

function GetWinningHeroName(playerID)
    local winning_team = GAME_WINNER_TEAM

    -- Convert winning team. If no team has won (disconnect) the game winners will be "none".
    if winning_team == "Radiant" then
        winning_team = DOTA_TEAM_GOODGUYS
    elseif winning_team == "Dire" then
        winning_team = DOTA_TEAM_BADGUYS    
    end    
    
    local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()
    if not hero then
        print("no hero found. Check passed player ID")
        return nil
    end

    -- Check winning team
    if hero:GetTeamNumber() == winning_team then
        local hero_name = PlayerResource:GetSelectedHeroName(playerID)
        hero_name = string.gsub(hero_name, "npc_dota_hero_", "") -- Removes the npc_dota_hero_ perfix
    else
        -- If it is not a hero that won, return an empty string
        return ""
    end    
end

function GetPickedTalents(playerID)
    local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()

    if not hero then
        print("no hero found. Check passed player ID")
        return nil
    end

    -- Get the partial hero name
    local hero_name = PlayerResource:GetSelectedHeroName(playerID)
    hero_name = string.gsub(hero_name, "npc_dota_hero_", "")    

    -- Get talent partial names
    local talent_prefix = "special_bonus_imba_"..hero_name    

    -- Get picked talents
    local picked_talents = {}
    for i = 1, 8 do
        print(talent_prefix.."_"..i)
        if hero:HasTalent(talent_prefix.."_"..i) then            
            table.insert(picked_talents, talent_prefix.."_"..i)
        end
    end

    return picked_talents    
end

-- Current gold and item net worth
function GetNetworth(hero)
    local networth = hero:GetGold()

    -- Iterate over item slots adding up its gold cost
    for i = 0, 15 do
        local item = hero:GetItemInSlot(i)
        if item then
            networth = networth + item:GetCost()
        end
    end

    return networth
end

-- String of item name, without the item_ prefix
function GetItemSlot(hero, slot)
    local item = hero:GetItemInSlot(slot)
    local itemName = ""

    if item then
        itemName = string.gsub(item:GetAbilityName(), "item_", "")
    end

    return itemName
end

-- Long string of item names ordered alphabetically, without the item_ prefix and separated by commas
function GetItemList(hero)
    local itemTable = {}

    for i = 0, 5 do
        local item = hero:GetItemInSlot(i)
        if item then
            local itemName = string.gsub(item:GetAbilityName(), "item_", "") --Cuts the item_ prefix
            table.insert(itemTable, itemName)
        end
    end

    table.sort(itemTable)
    local itemList = table.concat(itemTable, ",") --Concatenates with a comma

    return itemList
end
