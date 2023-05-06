-- require('components/statcollection/init')
require('components/scoreboard_events')
require('internal/util')
require('gamemode')

function Precache(context)
	LinkLuaModifier("modifier_buyback_penalty", "components/modifiers/modifier_buyback_penalty.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_command_restricted", "components/modifiers/modifier_command_restricted.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_custom_mechanics", "components/modifiers/modifier_custom_mechanics.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_dummy_dummy", "components/modifiers/modifier_dummy_dummy.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_fountain_aura_lua", "components/modifiers/modifier_fountain_aura_lua.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_contributor_statue", "components/modifiers/modifier_contributor_statue.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_contributor_filler", "components/modifiers/modifier_contributor_statue.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_war_veteran_0", "components/modifiers/modifier_imba_war_veteran.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_war_veteran_1", "components/modifiers/modifier_imba_war_veteran.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_war_veteran_2", "components/modifiers/modifier_imba_war_veteran.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_roshan_ai", "components/modifiers/modifier_imba_roshan_ai.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_meepo_divided_we_stand_lua", "components/abilities/heroes/hero_meepo.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_range_indicator", "components/modifiers/modifier_imba_range_indicator.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_illusion_bonuses", "components/modifiers/modifier_illusion_bonuses.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_invulnerable_hidden", "components/modifiers/modifier_invulnerable_hidden.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("lm_take_no_damage", "components/modifiers/demo/lm_take_no_damage", LUA_MODIFIER_MOTION_NONE)

	LinkLuaModifier("modifier_item_imba_helm_of_the_undying_addendum", "components/items/item_helm_of_the_undying", LUA_MODIFIER_MOTION_NONE)

	-- vanilla item override
	LinkLuaModifier("modifier_item_imba_bottle_heal", "components/items/item_bottle.lua", LUA_MODIFIER_MOTION_NONE) -- imba bottle using vanilla replacing modifier in ModifierFilter
	LinkLuaModifier("modifier_item_imba_aegis", "components/items/item_aegis.lua", LUA_MODIFIER_MOTION_NONE)     -- using vanilla aegis item with imba aegis modifier to keep combat events notifications on pickup/steal/deny

	-- Fountain Circle
	PrecacheResource("particle", "particles/ambient/fountain_danger_circle.vpcf", context)

	-- Sounds
	PrecacheResource("soundfile", "soundevents/imba_soundevents.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/imba_item_soundevents.vsndevts", context)

	--[[
	local heroeskv = LoadKeyValues("scripts/npc/herolist.txt")
	for hero, _ in pairs(heroeskv) do
		PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_"..string.sub(hero,15)..".vsndevts", context )
	end
--]]
end

function Activate()
	print("Activate()")
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
	-- Run the scoreboard functions that handle share unit / share hero / disable help
	initScoreBoardEvents()
end
