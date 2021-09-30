-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')

function Precache( context )
	LinkLuaModifier("modifier_frantic", "components/modifiers/modifier_frantic.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_range_indicator", "components/modifiers/modifier_imba_range_indicator.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_turbo_courier", "components/modifiers/courier/modifier_imba_turbo_courier", LUA_MODIFIER_MOTION_NONE)

	-- Generic modifiers
--	LinkLuaModifier("modifier_generic_charges", "components/modifiers/generic/modifier_generic_charges.lua", LUA_MODIFIER_MOTION_NONE )
--	LinkLuaModifier("modifier_generic_custom_indicator", "components/modifiers/generic/modifier_generic_custom_indicator.lua", LUA_MODIFIER_MOTION_NONE )
--	LinkLuaModifier("modifier_generic_knockback_lua", "components/modifiers/generic/modifier_generic_knockback_lua.lua", LUA_MODIFIER_MOTION_NONE )
--	LinkLuaModifier("modifier_generic_motion_controller", "components/modifiers/generic/modifier_generic_motion_controller.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_generic_orb_effect_lua", "components/modifiers/generic/modifier_generic_orb_effect_lua.lua", LUA_MODIFIER_MOTION_NONE )

	-- Periodic Spellcast
--	PrecacheResource("particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_bolt_parent.vpcf", context)

	PrecacheResource("soundfile", "soundevents/game_sounds_custom.vsndevts", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end
