
local delayed_add_talents_list = {}

local function PopulateGenericImbaTalentTableValues()
    -- Allow client access to IMBA_GENERIC_TALENT_LIST (javascript access)
    CustomNetTables:SetTableValue("imba_talent_manager", "imba_generic_talent_info", IMBA_GENERIC_TALENT_LIST)
end

local function GetHeroEndAbilityIndex(hero)
    -- endAbilityIndex hinges on the idea that talent ability index does not break in between and talents are at the last 8 of the ability list
    local endAbilityIndex = (hero:GetAbilityCount()-1)
    while hero:GetAbilityByIndex(endAbilityIndex) == nil and endAbilityIndex >= 0 do
        endAbilityIndex = endAbilityIndex - 1
    end

    return endAbilityIndex
end

local function PopulateHeroTalentList(hero)
    local heroName = hero:GetUnitName()
    local endAbilityIndex = GetHeroEndAbilityIndex(hero)

    local hero_talent_list = {}
    for i=0,7 do
        local current_level = 40-(i*5)
        local inner_value = {}
        if i%2 == 0 then
            local areImbaTalents = false
            local currentAbilityIndex = (endAbilityIndex - i)
            -- Special talents
            -- Imba talents only allow 2 selection. Non Imba talents allow 8 selection
            local ability1 = hero:GetAbilityByIndex(currentAbilityIndex-1)
            if ability1 then
                local abilityName = ability1:GetAbilityName()
                if abilityName:find("special_bonus_imba_") == 1 then
                    areImbaTalents = true
                end

                if abilityName:find("special_bonus_imba_") == 1 or abilityName:find("special_bonus_unique_") == 1 then
                    -- Only add to selection if it is a imba or unique talent
                    inner_value[7] = abilityName
                end
            end
            local ability2 = hero:GetAbilityByIndex(currentAbilityIndex)
            if ability2 then
                local abilityName = ability2:GetAbilityName()
                if abilityName:find("special_bonus_imba_") == 1 then
                    areImbaTalents = true
                end

                if abilityName:find("special_bonus_imba_") == 1 or abilityName:find("special_bonus_unique_") == 1 then
                    -- Only add to selection if it is a imba or unique talent
                    inner_value[8] = abilityName
                end
            end

            if not areImbaTalents then
                -- Copy table
                for k,v in pairs(IMBA_HERO_TALENTS_LIST[heroName]) do 
                    inner_value[k] = v
                end
            end
        else
            -- Stat talents (Pick either of the 6)
            inner_value = IMBA_HERO_TALENTS_LIST[heroName]
        end

        hero_talent_list[current_level] = inner_value
    end

    CustomNetTables:SetTableValue( "imba_talent_manager", "hero_talent_list_"..hero:entindex(), hero_talent_list )
end

local function PopulateHeroTalentChoice(hero)
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

    CustomNetTables:SetTableValue( "imba_talent_manager", "hero_talent_choice_"..hero:entindex(), talent_choices )
end

local function LinkAbilityWithTalent(compiled_list, ability_name, talent_name)
    local ability_list = compiled_list[talent_name]
    if ability_list == nil then
        ability_list = {}
    end

    local bol_found = false
    for _,v in pairs(ability_list) do
        if v == ability_name then
            bol_found = true
        end
    end

    if bol_found == false then
        table.insert(ability_list, ability_name)
        compiled_list[talent_name] = ability_list
    end
end

local function PopulateHeroTalentLinkedAbilities(hero)
    local existing_table = CustomNetTables:GetTableValue( "imba_talent_manager", "talent_linked_abilities" )
    if existing_table == nil then
        existing_table = {}
    end

    local currentAbilityIndex = GetHeroEndAbilityIndex(hero)
    while currentAbilityIndex > 0 do
        local ability = hero:GetAbilityByIndex(currentAbilityIndex)

        if ability then
            local ability_values = ability:GetAbilityKeyValues()
            local ability_name = ability:GetAbilityName()

            --Lua String index start at 1
            if ability_name:find("special_bonus") == 1 then
                -- Talent
                for k,v in pairs(ability_values) do
                    if k == "LinkedAbility" then
                        for _,m in pairs(v) do
                            LinkAbilityWithTalent(existing_table, m, ability_name)
                        end
                        break
                    end
                end
            else
                -- Ability
                for k,v in pairs(ability_values) do
                    if k == "AbilitySpecial" then
                        for _,m in pairs(v) do
                            local talentBonus = m["LinkedSpecialBonus"]
                            if talentBonus ~= nil then
                                LinkAbilityWithTalent(existing_table, ability_name, talentBonus)
                            end
                        end
                        break
                    end
                end
            end
        end

        -- Continue traversing
        currentAbilityIndex = currentAbilityIndex - 1
    end

    CustomNetTables:SetTableValue( "imba_talent_manager", "talent_linked_abilities", existing_table )
end

local function RemoveTalents(hero)
    -- This is to prevent default UI bypassing the talent window to upgrade talents via hotkeys even though they are invisible
    local heroName = hero:GetUnitName()
    local endAbilityIndex = GetHeroEndAbilityIndex(hero)
    for i=0,7 do
        local ability = hero:GetAbilityByIndex(endAbilityIndex-i)
        if ability then
            hero:RemoveAbility(ability:GetAbilityName())
        end
    end
end

local function HasNotPopulatedValues(hero_id)
    return (CustomNetTables:GetTableValue( "imba_talent_manager", "hero_talent_list_"..hero_id) == nil)
end

function PopulateHeroImbaTalents(hero)
    if HasNotPopulatedValues(hero:entindex()) then
        PopulateHeroTalentChoice(hero)
        PopulateHeroTalentList(hero)
        PopulateHeroTalentLinkedAbilities(hero)
        RemoveTalents(hero)
    end
end

function HandlePlayerUpgradeImbaTalent(unused, kv)
    local thisPlayerID = kv.PlayerID
    local heroID = kv.heroID
    local level = kv.level
    local index = kv.index

    --Convert heroID to hero entity
    local hero = EntIndexToHScript(heroID)
    if hero and IsValidEntity(hero) then
        local ownerPlayerID = hero:GetPlayerID()
        -- Check that player has granted share hero with player (bit mask 1 is for hero sharing)
        if ownerPlayerID == thisPlayerID or (PlayerResource:GetUnitShareMaskForPlayer(ownerPlayerID, thisPlayerID) % 2 == 1) then
            local hero_talent_list = CustomNetTables:GetTableValue( "imba_talent_manager", "hero_talent_list_"..heroID )
            local hero_talent_choices = CustomNetTables:GetTableValue( "imba_talent_manager", "hero_talent_choice_"..heroID )
            local currentUnspentAbilityPoints = hero:GetAbilityPoints()
            local level_key = tostring(level)
            -- Ensure that hero has unspent ability point
            -- Check that the level is valid
            if hero:GetLevel() >= level and
                (currentUnspentAbilityPoints > 0) and
                hero_talent_choices ~= nil and
                hero_talent_list ~= nil and
                (hero_talent_choices[level_key] ~= nil) and
                (hero_talent_list[level_key] ~= nil) and
                hero_talent_choices[level_key] <= 0 then

                -- Add ability/modifier to hero
                local talent_name = hero_talent_list[level_key][tostring(index)]
                if talent_name ~= nil then

                    if string.find(talent_name, "imba_generic_talent") == 1 then
                        -- Generic talent (add as modifier)
                        -- level goes from 1 to 4
                        -- 5 = 1, 15 = 2, 25 = 3, 35 = 4
                        local modifier_talent_name = "modifier_"..talent_name
                        local modifier = hero:FindModifierByName(modifier_talent_name)
                        if modifier ~= nil then
                            -- Do not allow learning of the same type of ability again
                            print("Talent: Taken before")
                            return
                        else
                            modifier = hero:AddNewModifier(hero, nil, modifier_talent_name, {})
                            if modifier == nil then
                                -- Add to delayed list (you cannot add modifiers to dead heroes)
                                local existing_list = delayed_add_talents_list[heroID]
                                if existing_list == nil then
                                    existing_list = {}
                                end

                                existing_list[modifier_talent_name] = level

                                delayed_add_talents_list[heroID] = existing_list
                            else
                                modifier:SetStackCount(1+(level-5)/5)
                                modifier:ForceRefresh() -- Refresh for modifier to update values (for server side. Client side will receive it as onCreated())
                            end
                        end
                    else
                        -- Ability talent (upgrade ability level)
                        local ability = hero:FindAbilityByName(talent_name)
                        if ability then
                            print("Talent: talent name not suppose to exist")
                            return
                        else
                            ability = hero:AddAbility(talent_name)
                            ability:SetLevel(1)
                        end
                    end

                    hero_talent_choices[level_key] = index

                    -- Reduce ability point by 1
                    hero:SetAbilityPoints(currentUnspentAbilityPoints - 1)

                    --Update table choice
                    CustomNetTables:SetTableValue( "imba_talent_manager", "hero_talent_choice_"..heroID, hero_talent_choices )
                else
                    print("Talent: Invalid link")
                end
            else
                print("Talent: Invalid Choice")
            end
        else
            print("Talent: Invalid hero ownership")
            print("ownerPlayerID :"..ownerPlayerID)
            print("thisPlayerID :"..thisPlayerID)
            print("mask: "..PlayerResource:GetUnitShareMaskForPlayer(ownerPlayerID, thisPlayerID))
        end
    else
        print("Talent: Invalid hero index")
    end
end

function InitPlayerHeroImbaTalents()
    -- Populate net table "imba_talent_manager"
    PopulateGenericImbaTalentTableValues()

    -- Register for event when user select a talent to upgrade
    CustomGameEventManager:RegisterListener("upgrade_imba_talent", HandlePlayerUpgradeImbaTalent)
end

function AddMissingGenericTalent(hero)

    local heroID = hero:GetEntityIndex()
    local existing_list = delayed_add_talents_list[heroID]
    if existing_list then
        for modifier_talent_name,level in pairs(existing_list) do
            local modifier = hero:AddNewModifier(hero, nil, modifier_talent_name, {})
            modifier:SetStackCount(1+(level-5)/5)
            modifier:ForceRefresh() -- Refresh for modifier to update values (for server side. Client side will receive it as onCreated())
        end
        delayed_add_talents_list[heroID] = nil
    end
end