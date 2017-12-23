-- Battlepass
-- Author: Earth Salamander #42

if Imbattlepass == nil then Imbattlepass = class({}) end

IMBATTLEPASS_LEVEL_REWARD = {}
IMBATTLEPASS_LEVEL_REWARD["fountain"]		= 4
IMBATTLEPASS_LEVEL_REWARD["blink"]			= 9
IMBATTLEPASS_LEVEL_REWARD["fountain2"]		= 13
IMBATTLEPASS_LEVEL_REWARD["force_staff"]	= 16
IMBATTLEPASS_LEVEL_REWARD["blink2"]			= 18
IMBATTLEPASS_LEVEL_REWARD["fountain3"]		= 22
IMBATTLEPASS_LEVEL_REWARD["bottle"]			= 26
IMBATTLEPASS_LEVEL_REWARD["blink3"]			= 27
IMBATTLEPASS_LEVEL_REWARD["fountain4"]		= 31
IMBATTLEPASS_LEVEL_REWARD["force_staff2"]	= 32
IMBATTLEPASS_LEVEL_REWARD["mekansm"]		= 35
IMBATTLEPASS_LEVEL_REWARD["blink4"]			= 36
IMBATTLEPASS_LEVEL_REWARD["fountain5"]		= 40
IMBATTLEPASS_LEVEL_REWARD["radiance"]		= 44
IMBATTLEPASS_LEVEL_REWARD["blink5"]			= 45
IMBATTLEPASS_LEVEL_REWARD["force_staff3"]	= 48
IMBATTLEPASS_LEVEL_REWARD["fountain6"]		= 49
IMBATTLEPASS_LEVEL_REWARD["bottle2"]		= 50
IMBATTLEPASS_LEVEL_REWARD["blink6"]			= 54
IMBATTLEPASS_LEVEL_REWARD["fountain7"]		= 58
IMBATTLEPASS_LEVEL_REWARD["sheepstick"]		= 60
IMBATTLEPASS_LEVEL_REWARD["blink7"]			= 63
IMBATTLEPASS_LEVEL_REWARD["force_staff4"]	= 64
IMBATTLEPASS_LEVEL_REWARD["fountain8"]		= 67
IMBATTLEPASS_LEVEL_REWARD["mekansm2"]		= 70
IMBATTLEPASS_LEVEL_REWARD["blink8"]			= 72
IMBATTLEPASS_LEVEL_REWARD["bottle3"]		= 74
IMBATTLEPASS_LEVEL_REWARD["fountain9"]		= 76
IMBATTLEPASS_LEVEL_REWARD["blink9"]			= 81
IMBATTLEPASS_LEVEL_REWARD["fountain10"]		= 85
IMBATTLEPASS_LEVEL_REWARD["radiance2"]		= 88
IMBATTLEPASS_LEVEL_REWARD["blink10"]		= 90
IMBATTLEPASS_LEVEL_REWARD["fountain11"]		= 94
IMBATTLEPASS_LEVEL_REWARD["bottle4"]		= 98
IMBATTLEPASS_LEVEL_REWARD["shiva"]			= 100
IMBATTLEPASS_LEVEL_REWARD["fountain12"]		= 103
IMBATTLEPASS_LEVEL_REWARD["fountain13"]		= 112
IMBATTLEPASS_LEVEL_REWARD["sheepstick2"]	= 120
IMBATTLEPASS_LEVEL_REWARD["fountain14"]		= 121
IMBATTLEPASS_LEVEL_REWARD["fountain15"]		= 130
IMBATTLEPASS_LEVEL_REWARD["shiva2"]			= 200

a = {}
for k, v in pairs(IMBATTLEPASS_LEVEL_REWARD) do
	table.insert(a, v, k)
end

CustomNetTables:SetTableValue("game_options", "battlepass", {battlepass = a})

function Imbattlepass:Init()
if api_preloaded.players == nil then return end
	ImbattlepassReward = {}
	for ID = 0, PlayerResource:GetPlayerCount() -1 do
		for i = 1, #XP_level_table do
			if GetStatsForPlayer(ID).xp > XP_level_table[i] then
				ImbattlepassReward[ID] = i
			end
		end
	end
end

function Imbattlepass:AddItemEffects(hero)
if api_preloaded.players == nil then return end
	GetBlinkEffect(hero)
	GetForceStaffEffect(hero)
	GetRadianceEffect(hero)
	GetSheepstickEffect(hero)
	GetShivaEffect(hero)
	GetMekansmEffect(hero)
	GetFountainEffect(hero)
	GetBottleEffect(hero)
end

function Imbattlepass:GetRewardUnlocked(ID)
	return ImbattlepassReward[ID]
end

function GetBlinkEffect(hero)
local effect = "particles/items_fx/blink_dagger_start.vpcf"
local effect2 = "particles/items_fx/blink_dagger_end.vpcf"
local icon = 0

	if Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink10"] then
		effect = "particles/econ/events/ti4/blink_dagger_start_ti4.vpcf"
		effect = "particles/econ/events/ti4/blink_dagger_end_ti4.vpcf"
		icon = 10
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink9"] then
		effect = "particles/econ/events/ti6/blink_dagger_start_ti6_lvl2.vpcf"
		effect2 = "particles/econ/events/ti6/blink_dagger_end_ti6_lvl2.vpcf"
		icon = 9
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink8"] then
		effect = "particles/econ/events/ti6/blink_dagger_start_ti6.vpcf"
		effect2 = "particles/econ/events/ti6/blink_dagger_end_ti6.vpcf"
		icon = 8
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink7"] then
		effect = "particles/econ/events/ti5/blink_dagger_start_lvl2_ti5.vpcf"
		effect = "particles/econ/events/ti5/blink_dagger_end_lvl2_ti5.vpcf"
		icon = 7
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink6"] then
		effect = "particles/econ/events/ti5/blink_dagger_start_ti5.vpcf"
		effect2 = "particles/econ/events/ti5/blink_dagger_end_ti5.vpcf"
		icon = 6
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink5"] then
		effect = "particles/econ/events/winter_major_2017/blink_dagger_start_wm07.vpcf"
		effect2 = "particles/econ/events/winter_major_2017/blink_dagger_end_wm07.vpcf"
		icon = 5
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink4"] then
		effect = "particles/econ/events/ti7/blink_dagger_start_ti7_lvl2.vpcf"
		effect2 = "particles/econ/events/ti7/blink_dagger_end_ti7_lvl2.vpcf"
		icon = 4
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink3"] then
		effect = "particles/econ/events/ti7/blink_dagger_start_ti7.vpcf"
		effect2 = "particles/econ/events/ti7/blink_dagger_end_ti7.vpcf"
		icon = 3
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink2"] then
		effect = "particles/econ/events/fall_major_2016/blink_dagger_start_fm06.vpcf"
		effect2 = "particles/econ/events/fall_major_2016/blink_dagger_end_fm06.vpcf"
		icon = 2
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink"] then
		effect = "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf"
		effect2 = "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf"
		icon = 1
	end

	hero.blink_effect = effect
	hero.blink_effect_end = effect2
	hero.blink_icon = icon
end

function GetForceStaffEffect(hero) -- still not working yet
local effect = "particles/items_fx/force_staff.vpcf"
local icon = 0

	if Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["force_staff4"] then
		
		effect = "particles/econ/events/ti6/force_staff_ti6.vpcf"
		icon = 4
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["force_staff3"] then
		effect = "particles/econ/events/winter_major_2017/force_staff_wm07.vpcf"
		icon = 3
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["force_staff2"] then
		effect = "particles/econ/events/ti7/force_staff_ti7.vpcf"
		icon = 2
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["force_staff"] then
		effect = "particles/econ/events/fall_major_2016/force_staff_fm06.vpcf"
		icon = 1
	end

	hero.force_staff_effect = effect
	hero.force_staff_icon = icon
end

function GetRadianceEffect(hero)
local effect = "particles/item/radiance/radiance_owner.vpcf"
local icon = 0

	if Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["radiance2"] then
		effect = "particles/econ/events/ti6/radiance_owner_ti6.vpcf"
		icon = 2
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["radiance"] then
		effect = "particles/econ/events/ti7/radiance_owner_ti7.vpcf"
		icon = 1
	end

	hero.radiance_effect = effect
	hero.radiance_icon = icon
end

function GetSheepstickEffect(hero)
local effect = "particles/items_fx/item_sheepstick.vpcf"
local model = "models/props_gameplay/pig.vmdl"
local icon = 0

	if Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["sheepstick2"] then
		effect = "particles/econ/items/shadow_shaman/shadow_shaman_sheepstick/shadowshaman_voodoo_sheepstick.vpcf"
		model = "models/props_gameplay/roquelaire/roquelaire.vmdl"
		icon = 2
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["sheepstick"] then
		effect = "particles/econ/events/winter_major_2017/item_sheepstick_wm07.vpcf"
		model = "models/props_gameplay/pig_blue.vmdl"
		icon = 1
	end

	hero.sheepstick_effect = effect
	hero.sheepstick_model = model
	hero.sheepstick_icon = icon
end

function GetShivaEffect(hero)
local effect = "particles/items2_fx/shivas_guard_active.vpcf"
local effect2 = "particles/items2_fx/shivas_guard_impact.vpcf"
local icon = 0

	if Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["shiva2"] then
		effect = "particles/econ/events/newbloom_2015/shivas_guard_active_nian2015.vpcf"
		effect2 = "particles/econ/events/newbloom_2015/shivas_guard_impact_nian2015.vpcf"
		icon = 2
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["shiva"] then
		effect = "particles/econ/events/ti7/shivas_guard_active_ti7.vpcf"
		effect2 = "particles/econ/events/ti7/shivas_guard_impact_ti7.vpcf"
		icon = 1
	end

	hero.shiva_blast_effect = effect
	hero.shiva_hit_effect = effect2
	hero.shiva_icon = icon
end

function GetMekansmEffect(hero)
local effect = "particles/items2_fx/mekanism.vpcf"
local effect2 = "particles/items2_fx/mekanism_recipient.vpcf"
local icon = 0

	if Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["mekansm2"] then
		effect = "particles/econ/events/ti6/mekanism_ti6.vpcf"
		effect2 = "particles/econ/events/ti6/mekanism_recipient_ti6.vpcf"
		icon = 2
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["mekansm"] then
		effect = "particles/econ/events/ti7/mekanism_ti7.vpcf"
		effect2 = "particles/econ/events/ti7/mekanism_recipient_ti7.vpcf"
		icon = 1
	end

	hero.mekansm_effect = effect
	hero.mekansm_hit_effect = effect2
	hero.mekansm_icon = icon
end

function GetFountainEffect(hero)
local effect = ""

	if Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain15"] then
		effect = "particles/econ/events/ti4/radiant_fountain_regen_ti4.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain14"] then
		effect = "particles/econ/events/ti6/radiant_fountain_regen_ti6_lvl3.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain13"] then
		effect = "particles/econ/events/ti6/radiant_fountain_regen_ti6_lvl2.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain12"] then
		effect = "particles/econ/events/ti5/radiant_fountain_regen_ti6.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain11"] then
		effect = "particles/econ/events/ti5/radiant_fountain_regen_lvl2_ti5.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain10"] then
		effect = "particles/econ/events/ti5/radiant_fountain_regen_ti5.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain9"] then
		effect = "particles/econ/events/winter_major_2017/radiant_fountain_regen_wm07_lvl3.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain8"] then
		effect = "particles/econ/events/winter_major_2017/radiant_fountain_regen_wm07_lvl2.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain7"] then
		effect = "particles/econ/events/winter_major_2017/radiant_fountain_regen_wm07_lvl1.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain6"] then
		effect = "particles/econ/events/ti7/fountain_regen_ti7_lvl3.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain5"] then
		effect = "particles/econ/events/ti7/fountain_regen_ti7_lvl2.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain4"] then
		effect = "particles/econ/events/ti7/fountain_regen_ti7.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain3"] then
		effect = "particles/econ/events/fall_major_2016/radiant_fountain_regen_fm06_lvl3.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain2"] then
		effect = "particles/econ/events/fall_major_2016/radiant_fountain_regen_fm06_lvl2.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain"] then
		effect = "particles/econ/events/fall_major_2016/radiant_fountain_regen_fm06_lvl1.vpcf"
	end

	hero.fountain_effect = effect
end

function GetBottleEffect(hero)
local effect = "particles/items_fx/bottle.vpcf"

	if Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["bottle4"] then
		effect = "particles/econ/events/ti4/bottle_ti4.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["bottle3"] then
		effect = "particles/econ/events/ti6/bottle_ti6.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["bottle2"] then
		effect = "particles/econ/events/ti5/bottle_ti5.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["bottle"] then
		effect = "particles/econ/events/ti7/bottle_ti7.vpcf"
	end

	hero.bottle_effect = effect
end
