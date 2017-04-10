
local function LinkAbilityWithTalent(compiled_list, ability_name, talent_name)
    local ability_list = compiled_list[talent_name]
    if ability_list == nil then
        ability_list = {}
    end

    local bol_found = false
    for k,v in pairs(ability_list) do
        if v == ability_name then
            bol_found = true
        end
    end

    if bol_found == false then
        table.insert(ability_list, ability_name)

        compiled_list[talent_name] = ability_list
    end
end

local function PopulateLinkedAbilities(kv, compiled_list)
    -- Compile LinkedSpecialBonus list

    for abilityName,abilityValues in pairs(kv) do
        if type(abilityValues) == "table" then
            for k,v in pairs(abilityValues) do
                if k == "AbilitySpecial" then
                    for l,m in pairs(v) do
                        if m["LinkedSpecialBonus"] ~= nil then
                            LinkAbilityWithTalent(compiled_list, abilityName, m["LinkedSpecialBonus"])
                        end
                    end
                    -- Do not need to parse further if found
                    break
                end
            end
        end
    end
end

local function PopulateGenericImbaTalentTableValues()
    -- Allow client access to IMBA_GENERIC_TALENT_LIST (javascript access)
    CustomNetTables:SetTableValue("imba_talent_manager", "imba_generic_talent_info", IMBA_GENERIC_TALENT_LIST)

    local customKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
    local overrideKV = LoadKeyValues("scripts/npc/npc_abilities_override.txt")

    local compiled_list = {}
    PopulateLinkedAbilities(customKV, compiled_list)
    PopulateLinkedAbilities(overrideKV, compiled_list)

    CustomNetTables:SetTableValue("imba_talent_manager", "talent_linked_abilities", compiled_list)
end


local function PopulateHeroTalentList(hero)
    local heroName = hero:GetUnitName()
    -- endAbilityIndex hinges on the idea that talent ability index does not break in between and talents are at the last of the ability list
    local endAbilityIndex = (hero:GetAbilityCount()-1)
    while hero:GetAbilityByIndex(endAbilityIndex) == nil and endAbilityIndex >= 0 do
        endAbilityIndex = endAbilityIndex - 1
    end

    local hero_talent_list = {}
    for i=0,7 do
        local current_level = 40-(i*5)
        local inner_value = {}
        if i%2 == 0 then
            local currentAbilityIndex = (endAbilityIndex - i)
            -- Special talents (Pick either of the 2)
            local ability1 = hero:GetAbilityByIndex(currentAbilityIndex-1)
            if ability1 then
                inner_value[1] = ability1:GetAbilityName()
            end
            local ability2 = hero:GetAbilityByIndex(currentAbilityIndex)
            if ability2 then
                inner_value[2] = ability2:GetAbilityName()
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

function PopulatePlayerHeroImbaTalents(player_id)
    -- This function is used in hero_selection.lua

    if PlayerResource:IsValidPlayerID(player_id) then
        local playerRef = PlayerResource:GetPlayer(player_id)
        local assignedHero = playerRef:GetAssignedHero()

        if assignedHero then
            PopulateHeroTalentChoice(assignedHero)
            PopulateHeroTalentList(assignedHero)
        end
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
        if ownerPlayerID == thisPlayerID or (PlayerResource:GetUnitShareMaskForPlayer(ownerPlayerID, thisPlayerID) % 1 == 1) then
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

                    -- TODO not working, fix
                    if string.find(talent_name, "imba_generic_talent") == 1 then
                        -- Generic talent (add as modifier)
                        -- level goes from 1 to 4
                        -- 5 = 1, 15 = 2, 25 = 3, 35 = 4
                        hero:AddNewModifier(hero, nil, "modifier_"..talent_name, { level = (1+(level-5)/10) })
                    else
                        -- Ability talent (add as ability)
                        hero:AddAbility(talent_name)
                    end

                    hero_talent_choices[level_key] = index

                    -- Reduce ability point by 1
                    hero:SetAbilityPoints(currentUnspentAbilityPoints - 1)

                    --Update table choice
                    CustomNetTables:SetTableValue( "imba_talent_manager", "hero_talent_choice_"..heroID, hero_talent_choices )
                else
                    print("Talent: Invalid link")
                    print(hero_talent_list[level_key])
                    for k,v in pairs(hero_talent_list) do
                        print(k)
                        for l,m in pairs(v) do
                            print(l)
                            print(m)
                        end
                    end
                end
            else
                print("Talent: Invalid Choice")
            end
        else
            print("Talent: Invalid hero ownership")
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