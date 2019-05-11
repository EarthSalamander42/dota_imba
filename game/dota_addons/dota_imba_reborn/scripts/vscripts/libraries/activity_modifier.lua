-- Credits: https://steamcommunity.com/sharedfiles/filedetails?id=1663264349

--[[
  Lua-controlled ActivityModifier Library by pilaoda

  fix activity modifier on hero model
  --]]
if not ActivityModifier then
    ActivityModifier = {}
    ActivityModifier.__index = Wearable
    _G.ActivityModifier = ActivityModifier
end

require('libraries/modifiers/animation_code')

LinkLuaModifier(
    "modifier_attack_speed_activity",
    "libraries/modifiers/modifier_attack_speed_activity.lua",
    LUA_MODIFIER_MOTION_NONE
)
LinkLuaModifier(
    "modifier_movement_speed_activity",
    "libraries/modifiers/modifier_movement_speed_activity.lua",
    LUA_MODIFIER_MOTION_NONE
)
LinkLuaModifier(
    "modifier_attack_range_activity",
    "libraries/modifiers/modifier_attack_range_activity.lua",
    LUA_MODIFIER_MOTION_NONE
)

LinkLuaModifier("modifier_activity0", "libraries/modifiers/modifier_activity0.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity1", "libraries/modifiers/modifier_activity1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity2", "libraries/modifiers/modifier_activity2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity3", "libraries/modifiers/modifier_activity3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity4", "libraries/modifiers/modifier_activity4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity5", "libraries/modifiers/modifier_activity5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity6", "libraries/modifiers/modifier_activity6.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity7", "libraries/modifiers/modifier_activity7.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity8", "libraries/modifiers/modifier_activity8.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity9", "libraries/modifiers/modifier_activity9.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity10", "libraries/modifiers/modifier_activity10.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity11", "libraries/modifiers/modifier_activity11.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity12", "libraries/modifiers/modifier_activity12.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity13", "libraries/modifiers/modifier_activity13.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity14", "libraries/modifiers/modifier_activity14.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity15", "libraries/modifiers/modifier_activity15.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity16", "libraries/modifiers/modifier_activity16.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity17", "libraries/modifiers/modifier_activity17.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity18", "libraries/modifiers/modifier_activity18.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity19", "libraries/modifiers/modifier_activity19.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity20", "libraries/modifiers/modifier_activity20.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_battlepass_wearable_spellicons", "libraries/modifiers/modifier_battlepass_wearable_spellicons.lua", LUA_MODIFIER_MOTION_NONE)

function GetTable(ParentTable, key)
    if not ParentTable[key] then
        ParentTable[key] = {}
    end
    return ParentTable[key]
end

function SwitchKeyValue(t)
    local new_t = {}
    for k, v in pairs(t) do
        new_t[v] = k
    end
    return new_t
end

function ActivityModifier:Init()
    ActivityModifier.units = {}
    local custom_units = LoadKeyValues("scripts/npc/npc_units_custom.txt")
    for unit_name, unit_table in pairs(custom_units) do
        if type(unit_table) == "table" then
            if unit_table.AttackSpeedActivityModifiers then
                local unit_modifiers = GetTable(ActivityModifier.units, unit_name)
                unit_modifiers["AttackSpeedActivityModifiers"] = SwitchKeyValue(unit_table.AttackSpeedActivityModifiers)
            end
            if unit_table.MovementSpeedActivityModifiers then
                local unit_modifiers = GetTable(ActivityModifier.units, unit_name)
                unit_modifiers["MovementSpeedActivityModifiers"] =
                    SwitchKeyValue(unit_table.MovementSpeedActivityModifiers)
            end
            if unit_table.AttackRangeActivityModifiers then
                local unit_modifiers = GetTable(ActivityModifier.units, unit_name)
                unit_modifiers["AttackRangeActivityModifiers"] = SwitchKeyValue(unit_table.AttackRangeActivityModifiers)
            end
        end
    end
    ActivityModifier.THINK_INTERVAL = 1 / 30
end

function ActivityModifier:AddActivityModifierThink(hUnit)
    local sUnitName = hUnit:GetUnitName()
    local Modifiers = ActivityModifier.units[sUnitName]
    if Modifiers then
        hUnit:SetContextThink(
            "self:ThinkActivity",
            function()
                return self:ThinkActivity(hUnit)
            end,
            0
        )
    end
end

function ActivityModifier:ThinkActivity(hUnit)
    local MoveSpeedAM = ActivityModifier.units[hUnit:GetUnitName()].MovementSpeedActivityModifiers
    if MoveSpeedAM then
        local nMoveSpeed = hUnit:GetIdealSpeed()
        local translate = nil
        local maxModifierSpeed = -1
        for speed, activity_modifier in pairs(MoveSpeedAM) do
            if nMoveSpeed > speed and speed > maxModifierSpeed then
                maxModifierSpeed = speed
                translate = activity_modifier
            end
        end
        if hUnit.sMoveSpeedTranslate ~= translate then
            if hUnit:HasModifier("modifier_movement_speed_activity") then
                hUnit:RemoveModifierByName("modifier_movement_speed_activity")
            end
            if translate then
                hUnit:AddNewModifier(hUnit, nil, "modifier_movement_speed_activity", {translate = translate})
                hUnit:SetModifierStackCount(
                    "modifier_movement_speed_activity",
                    hUnit,
                    _ANIMATION_TRANSLATE_TO_CODE[translate]
                )
            end
            hUnit.sMoveSpeedTranslate = translate
        end
    end

    local AttackSpeedAM = ActivityModifier.units[hUnit:GetUnitName()].AttackSpeedActivityModifiers
    if AttackSpeedAM then
        local nAttackSpeed = hUnit:GetAttackSpeed() * 100
        local translate = nil
        local maxModifierSpeed = -1
        for speed, activity_modifier in pairs(AttackSpeedAM) do
            if nAttackSpeed > speed and speed > maxModifierSpeed then
                maxModifierSpeed = speed
                translate = activity_modifier
            end
        end
        if hUnit.sAttackSpeedTranslate ~= translate then
            if hUnit:HasModifier("modifier_attack_speed_activity") then
                hUnit:RemoveModifierByName("modifier_attack_speed_activity")
            end
            if translate then
                hUnit:AddNewModifier(hUnit, nil, "modifier_attack_speed_activity", {translate = translate})
                hUnit:SetModifierStackCount(
                    "modifier_attack_speed_activity",
                    hUnit,
                    _ANIMATION_TRANSLATE_TO_CODE[translate]
                )
            end
            hUnit.sAttackSpeedTranslate = translate
        end
    end

    local AttackRangeAM = ActivityModifier.units[hUnit:GetUnitName()].AttackRangeActivityModifiers
    if AttackRangeAM then
        local target = hUnit:GetAttackTarget()
        local translate = nil
        for modifier_distance, activity_modifier in pairs(AttackRangeAM) do
            translate = activity_modifier
            break
        end
        if not hUnit:HasModifier("modifier_attack_range_activity") then
            hUnit:AddNewModifier(hUnit, nil, "modifier_attack_range_activity", {translate = translate})
            hUnit:SetModifierStackCount(
                "modifier_attack_range_activity",
                hUnit,
                _ANIMATION_TRANSLATE_TO_CODE[translate]
            )
        end
    end

    return ActivityModifier.THINK_INTERVAL
end

function ActivityModifier:RemoveWearableActivity(hUnit, sItemDef)
    for _, sActIndex in ipairs(hUnit.Activities[sItemDef]) do
        local sModifierName = "modifier_activity" .. sActIndex
        if hUnit:HasModifier(sModifierName) then
            hUnit:RemoveModifierByName(sModifierName)
        end

        hUnit.ActIndexPool[sActIndex] = nil
    end
    hUnit.Activities[sItemDef] = nil
end

function ActivityModifier:AddWearableActivity(hUnit, translate, sItemDef)
    -- print(translate, sItemDef)
    hUnit.ActIndexPool = hUnit.ActIndexPool or {}
    hUnit.Activities = hUnit.Activities or {}
    for i = 0, 20 do
        local sActIndex = tostring(i)
        if not hUnit.ActIndexPool[sActIndex] then
            local sModifierName = "modifier_activity" .. sActIndex
            hUnit.ActIndexPool[sActIndex] = sItemDef
            hUnit:AddNewModifier(hUnit, nil, sModifierName, {translate = translate})
            hUnit:SetModifierStackCount(sModifierName, hUnit, _ANIMATION_TRANSLATE_TO_CODE[translate])

            -- print(hUnit, translate, sActIndex, sItemDef)
            hUnit.Activities[sItemDef] = hUnit.Activities[sItemDef] or {}
            table.insert(hUnit.Activities[sItemDef], sActIndex)
            break
        end
    end
end

if not ActivityModifier.heroes then
    ActivityModifier:Init()
end
