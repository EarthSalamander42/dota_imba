require('components/scoreboard_events')
require('internal/util')
require('gamemode')

function Precache( context )
	LinkLuaModifier("modifier_command_restricted", "components/modifiers/modifier_command_restricted.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_companion", "components/modifiers/modifier_companion.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_custom_mechanics", "components/modifiers/modifier_custom_mechanics.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_dummy_dummy", "components/modifiers/modifier_dummy_dummy.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_fountain_aura_lua", "components/modifiers/modifier_fountain_aura_lua.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_contributor_statue", "components/modifiers/modifier_imba_contributor_statue.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_donator", "components/modifiers/modifier_imba_donator.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_donator_statue", "components/modifiers/modifier_imba_donator_statue.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_war_veteran_0", "components/modifiers/modifier_imba_war_veteran.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_war_veteran_1", "components/modifiers/modifier_imba_war_veteran.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_war_veteran_2", "components/modifiers/modifier_imba_war_veteran.lua", LUA_MODIFIER_MOTION_NONE )

	-- Battlepass precaching
	Wearables:PrecacheWearables(context)
	PrecacheResource("particle", "particles/econ/items/pudge/pudge_arcana", context)
	PrecacheResource("particle_folder", "particles/econ/items/juggernaut/jugg_arcana", context)
	
	-- Battlepass Blink effects
	PrecacheResource("particle", "particles/econ/events/ti8/blink_dagger_ti8_start_lvl2.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti8/blink_dagger_ti8_end_lvl2.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti8/blink_dagger_ti8_start.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti8/blink_dagger_ti8_end.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti5/blink_dagger_start_lvl2_ti5.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti5/blink_dagger_end_lvl2_ti5.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti5/blink_dagger_start_ti5.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti5/blink_dagger_end_ti5.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti6/blink_dagger_start_ti6_lvl2.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti6/blink_dagger_end_ti6_lvl2.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti6/blink_dagger_start_ti6.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti6/blink_dagger_end_ti6.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti4/blink_dagger_start_ti4.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti4/blink_dagger_end_ti4.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/winter_major_2017/blink_dagger_start_wm07.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/winter_major_2017/blink_dagger_end_wm07.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti7/blink_dagger_start_ti7_lvl2.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti7/blink_dagger_end_ti7_lvl2.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti7/blink_dagger_start_ti7.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti7/blink_dagger_end_ti7.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/fall_major_2016/blink_dagger_start_fm06.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/fall_major_2016/blink_dagger_end_fm06.vpcf", context)

	-- Sounds
	PrecacheResource("soundfile", "soundevents/imba_soundevents.vsndevts", context)

	if IsMutationMap() then
		Mutation:Precache(context)
	end
end

function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
	-- Run the scoreboard functions that handle share unit / share hero / disable help
	initScoreBoardEvents()
end
