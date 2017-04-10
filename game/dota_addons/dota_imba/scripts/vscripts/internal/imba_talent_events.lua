
local function PopulateGenericImbaTalentTableValues()
    -- Allow client access to IMBA_GENERIC_TALENT_LIST
    CustomNetTables:SetTableValue("imba_talent_manager", "imba_generic_talent_info", IMBA_GENERIC_TALENT_LIST)
end

function PopulatePlayerHeroImbaTalents(player_id)
    -- This function is used in hero_selection.lua

    if PlayerResource:IsValidPlayerID(player_id) then
        
        local playerRef = PlayerResource:GetPlayer(player_id)
        local assignedHero = playerRef:GetAssignedHero()

        if assignedHero then
            local heroName = assignedHero:GetUnitName()
            -- endAbilityIndex hinges on the idea that talent ability index does not break in between and talents are at the last of the ability list
            local endAbilityIndex = (assignedHero:GetAbilityCount()-1)
            while assignedHero:GetAbilityByIndex(endAbilityIndex) == nil and endAbilityIndex >= 0 do
                endAbilityIndex = endAbilityIndex - 1
            end

            local hero_talent_list = {}
            for i=0,7 do
                local current_level = 40-(i*5)
                local inner_value = {}
                if i%2 == 0 then
                    local currentAbilityIndex = (endAbilityIndex - i)
                    -- Special talents (Pick either of the 2)
                    -- TODO include linked abilities to show as ability buttons on client side
                    local ability1 = assignedHero:GetAbilityByIndex(currentAbilityIndex-1)
                    if ability1 then
                        inner_value[1] = ability1:GetAbilityName()
                    end
                    local ability2 = assignedHero:GetAbilityByIndex(currentAbilityIndex)
                    if ability2 then
                        inner_value[2] = ability2:GetAbilityName()
                    end
                else
                    -- Stat talents (Pick either of the 6)
                    inner_value = IMBA_HERO_TALENTS_LIST[heroName]
                end

                hero_talent_list[current_level] = inner_value
            end

            -- 16/04/2017
            -- Note that this uses hero entity index instead of player index because the panorama API currently do not allow getting playerID of a given hero index
            CustomNetTables:SetTableValue( "imba_talent_manager", "hero_talent_list_"..assignedHero:entindex(), hero_talent_list )
        end
    end
end

function PopulatePlayerHeroImbaTalentChoices(playerID)
    -- TODO consider whether to change this to use hero index instead of playerID to keep it consistent
    -- This struct looks like this (keys are levels, values are index chosen)
    --[[
        talent_choices {
            40 : -1
            35 : -1
            30 : -1
            etc ...
        }
    ]]--
    local talent_choices = {}
    for i=0,7 do
        local current_level = 40-(i*5)
        talent_choices[current_level] = -1
    end

    CustomNetTables:SetTableValue( "imba_talent_manager", "player_choice_"..playerID, talent_choices )
end

function HandlePlayerUpgradeImbaTalent(unused, kv)
    local thisPlayerID = kv.PlayerID
    local ownerPlayerID = kv.ownerPlayerID --playerID who owns the hero (allow player to upgrade talent values for disconnected players)
    if PlayerResource:IsValidPlayerID(thisPlayerID) then
        local player_talent_choices = CustomNetTables:GetTableValue( "imba_talent_manager", "player_choice_"..ownerPlayerID )
        local playerOwner = PlayerResource:GetPlayer(ownerPlayerID)
        -- Check that player has granted share hero with player (bit mask 1 is for hero sharing)
        if playerOwner and (thisPlayerID == ownerPlayerID or (PlayerResource:GetUnitShareMaskForPlayer(ownerPlayerID, thisPlayerID) % 1 == 1)) then
            local assignedHero = playerOwner:GetAssignedHero()
            local currentUnspentAbilityPoints = assignedHero:GetAbilityPoints()
            -- Ensure that hero has unspent ability point
            if assignedHero and currentUnspentAbilityPoints > 0 then
                -- TODO check if there is an existing choice for that level
                

                -- Reduce ability point by 1
                assignedHero:SetAbilityPoints(currentUnspentAbilityPoints - 1)
            end
        end
    end
end

function InitPlayerHeroImbaTalents()
    -- Populate net table "imba_talent_manager"
    PopulateGenericImbaTalentTableValues()

    -- 20 players
    for i=0, 20 do
        if PlayerResource:IsValidPlayerID(i) then
            PopulatePlayerHeroImbaTalentChoices(i)
        end
    end

    -- Register for event when user select a talent to upgrade
    CustomGameEventManager:RegisterListener("upgrade_imba_talent", HandlePlayerUpgradeImbaTalent)
end