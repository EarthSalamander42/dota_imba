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
IMBATTLEPASS_LEVEL_REWARD["blink6"]			= 54
IMBATTLEPASS_LEVEL_REWARD["fountain7"]		= 58
IMBATTLEPASS_LEVEL_REWARD["sheepstick"]		= 60
IMBATTLEPASS_LEVEL_REWARD["blink7"]			= 63
IMBATTLEPASS_LEVEL_REWARD["force_staff4"]	= 64
IMBATTLEPASS_LEVEL_REWARD["fountain8"]		= 67
IMBATTLEPASS_LEVEL_REWARD["mekansm2"]		= 70
IMBATTLEPASS_LEVEL_REWARD["blink8"]			= 72
IMBATTLEPASS_LEVEL_REWARD["fountain9"]		= 76
IMBATTLEPASS_LEVEL_REWARD["blink9"]			= 81
IMBATTLEPASS_LEVEL_REWARD["fountain10"]		= 85
IMBATTLEPASS_LEVEL_REWARD["radiance2"]		= 88
IMBATTLEPASS_LEVEL_REWARD["blink10"]		= 90
IMBATTLEPASS_LEVEL_REWARD["fountain11"]		= 94
IMBATTLEPASS_LEVEL_REWARD["shiva"]			= 100
IMBATTLEPASS_LEVEL_REWARD["fountain12"]		= 103
IMBATTLEPASS_LEVEL_REWARD["fountain13"]		= 112
IMBATTLEPASS_LEVEL_REWARD["sheepstick2"]	= 120
IMBATTLEPASS_LEVEL_REWARD["fountain14"]		= 121
IMBATTLEPASS_LEVEL_REWARD["fountain15"]		= 130
IMBATTLEPASS_LEVEL_REWARD["shiva2"]			= 200

--[[ Not Added yet: 
	Custom Icons if has special item effects
	Rank Double Down,
	XP Boosters,
	TP Scroll effect + pro team effect (7.04),
	golden roshan contributor statue(level 500?) (7.04),
	Mekansm/Guardian Greaves effect,
	Mjollnir/Jarnbjorn effect,
	Companion unlocking (need to create the companion choice in-game and remove the one in website),
	Dagon effect,
	Eul Scepter effect,
	Level Up effect (not sure it's possible) (7.04),
	Bottle effect (7.04),
	Aegis effect,
	Hermes companion with all cosmetics (7.04),
	Axolotl companion with all cosmetics (7.04),
	River painting (if possible) (7.04),
	Deny creep effect with ? instead of !,
	Tiny unique set (7.04),
--]]

function Imbattlepass:Init()
if api_preloaded.players == nil then return end
	ImbattlepassReward = {}
	for ID = 0, PlayerResource:GetPlayerCount() -1 do
		for i = 1, #XP_level_table do
			if get_stats_for_player(ID).xp > XP_level_table[i] then
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
	GetSheepstickModel(hero)
	GetShivaEffect(hero)
	GetMekansmEffect(hero)
	GetFountainEffect(hero)
end

function Imbattlepass:GetRewardUnlocked(ID)
	return ImbattlepassReward[ID]
end

function GetBlinkEffect(hero)
	local effect = "particles/items_fx/blink_dagger_start.vpcf"
	local effect2 = "particles/items_fx/blink_dagger_end.vpcf"

	if Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink10"] then
		effect = "particles/econ/events/ti4/blink_dagger_start_ti4.vpcf"
		effect = "particles/econ/events/ti4/blink_dagger_end_ti4.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink9"] then
		effect = "particles/econ/events/ti5/blink_dagger_start_lvl2_ti5.vpcf"
		effect = "particles/econ/events/ti5/blink_dagger_end_lvl2_ti5.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink8"] then
		effect = "particles/econ/events/ti5/blink_dagger_start_ti5.vpcf"
		effect2 = "particles/econ/events/ti5/blink_dagger_end_ti5.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink7"] then
		effect = "particles/econ/events/ti6/blink_dagger_start_ti6_lvl2.vpcf"
		effect2 = "particles/econ/events/ti6/blink_dagger_end_ti6_lvl2.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink6"] then
		effect = "particles/econ/events/ti6/blink_dagger_start_ti6.vpcf"
		effect2 = "particles/econ/events/ti6/blink_dagger_end_ti6.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink5"] then
		effect = "particles/econ/events/winter_major_2017/blink_dagger_start_wm07.vpcf"
		effect2 = "particles/econ/events/winter_major_2017/blink_dagger_end_wm07.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink4"] then
		effect = "particles/econ/events/ti7/blink_dagger_start_ti7_lvl2.vpcf"
		effect2 = "particles/econ/events/ti7/blink_dagger_end_ti7_lvl2.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink3"] then
		effect = "particles/econ/events/ti7/blink_dagger_start_ti7.vpcf"
		effect2 = "particles/econ/events/ti7/blink_dagger_end_ti7.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink2"] then
		effect = "particles/econ/events/fall_major_2016/blink_dagger_start_fm06.vpcf"
		effect2 = "particles/econ/events/fall_major_2016/blink_dagger_end_fm06.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["blink"] then
		effect = "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf"
		effect2 = "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf"
	end

	hero.blink_effect = effect
	hero.blink_effect_end = effect2
end

function GetForceStaffEffect(hero) -- still not working yet
	local effect = "particles/items_fx/force_staff.vpcf"

	if Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["force_staff4"] then
		effect = "particles/econ/events/fall_major_2016/force_staff_fm06.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["force_staff3"] then
		effect = "particles/econ/events/ti7/force_staff_ti7.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["force_staff2"] then
		effect = "particles/econ/events/winter_major_2017/force_staff_wm07.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["force_staff"] then
		effect = "particles/econ/events/ti6/force_staff_ti6.vpcf"
	end

	hero.force_staff_effect = effect
end

function GetRadianceEffect(hero)
local effect = "particles/item/radiance/radiance_owner.vpcf"

	if Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["radiance2"] then
		effect = "particles/econ/events/ti6/radiance_owner_ti6.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["radiance"] then
		effect = "particles/econ/events/ti7/radiance_owner_ti7.vpcf"
	end

	hero.radiance_effect = effect
end

function GetSheepstickEffect(hero)
local effect = "particles/items_fx/item_sheepstick.vpcf"

	if Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["sheepstick2"] then
		effect = "particles/econ/items/shadow_shaman/shadow_shaman_sheepstick/shadowshaman_voodoo_sheepstick.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["sheepstick"] then
		effect = "particles/econ/events/winter_major_2017/item_sheepstick_wm07.vpcf"
	end

	hero.sheepstick_effect = effect
end

function GetSheepstickModel(hero)
local effect = "models/props_gameplay/pig.vmdl"

	if Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["sheepstick2"] then
		effect = "models/props_gameplay/roquelaire/roquelaire.vmdl"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["sheepstick"] then
		effect = "models/props_gameplay/pig_blue.vmdl"
	end

	hero.sheepstick_model = effect
end

function GetShivaEffect(hero)
local effect = "particles/items2_fx/shivas_guard_active.vpcf"
local effect2 = "particles/items2_fx/shivas_guard_impact.vpcf"

	if Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["shiva2"] then
		effect = "particles/econ/events/newbloom_2015/shivas_guard_active_nian2015.vpcf"
		effect2 = "particles/econ/events/newbloom_2015/shivas_guard_impact_nian2015.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["shiva"] then
		effect = "particles/econ/events/ti7/shivas_guard_active_ti7.vpcf"
		effect2 = "particles/econ/events/ti7/shivas_guard_impact_ti7.vpcf"
	end

	hero.shiva_blast_effect = effect
	hero.shiva_hit_effect = effect2
end

function GetMekansmEffect(hero)
local effect = "particles/items2_fx/mekanism.vpcf"
local effect2 = "particles/items2_fx/mekanism_recipient.vpcf"

	if Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["mekansm2"] then
		effect = "particles/econ/events/ti6/mekanism_ti6.vpcf"
		effect2 = "particles/econ/events/ti6/mekanism_recipient_ti6.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["mekansm"] then
		effect = "particles/econ/events/ti7/mekanism_ti7.vpcf"
		effect2 = "particles/econ/events/ti7/mekanism_recipient_ti7.vpcf"
	end

	hero.mekansm_effect = effect
	hero.mekansm_hit_effect = effect2
end

function GetFountainEffect(hero)
local effect = ""

	if Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain15"] then
		effect = "particles/econ/events/winter_major_2017/radiant_fountain_regen_wm07_lvl3.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain14"] then
		effect = "particles/econ/events/winter_major_2017/radiant_fountain_regen_wm07_lvl2.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain13"] then
		effect = "particles/econ/events/winter_major_2017/radiant_fountain_regen_wm07_lvl1.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain12"] then
		effect = "particles/econ/events/ti6/radiant_fountain_regen_ti6_lvl3.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain11"] then
		effect = "particles/econ/events/ti6/radiant_fountain_regen_ti6_lvl2.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain10"] then
		effect = "particles/econ/events/ti6/radiant_fountain_regen_ti6.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain9"] then
		effect = "particles/econ/events/ti5/radiant_fountain_regen_lvl2_ti5.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain8"] then
		effect = "particles/econ/events/ti5/radiant_fountain_regen_ti5.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(hero:GetPlayerID()) >= IMBATTLEPASS_LEVEL_REWARD["fountain7"] then
		effect = "particles/econ/events/ti4/radiant_fountain_regen_ti4.vpcf"
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
