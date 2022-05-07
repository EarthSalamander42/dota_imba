-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')

function Precache( context )
	-- hero modifiers
	LinkLuaModifier("modifier_imba_pudge_flesh_heap_handler", "components/abilities/heroes/hero_pudge.lua", LUA_MODIFIER_MOTION_NONE )

	-- item modifiers
	LinkLuaModifier("modifier_item_imba_aegis", "components/items/item_aegis.lua", LUA_MODIFIER_MOTION_NONE )
	
	-- general modifiers
	LinkLuaModifier("modifier_frantic", "components/modifiers/modifier_frantic.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_custom_mechanics", "components/modifiers/modifier_custom_mechanics", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_range_indicator", "components/modifiers/modifier_imba_range_indicator.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_fountain_aura_lua", "components/modifiers/modifier_fountain_aura_lua.lua", LUA_MODIFIER_MOTION_NONE )

	-- courier modifiers
	LinkLuaModifier("modifier_imba_turbo_courier", "components/modifiers/courier/modifier_imba_turbo_courier", LUA_MODIFIER_MOTION_NONE)

	-- Generic modifiers
--	LinkLuaModifier("modifier_generic_charges", "components/modifiers/generic/modifier_generic_charges.lua", LUA_MODIFIER_MOTION_NONE )
--	LinkLuaModifier("modifier_generic_custom_indicator", "components/modifiers/generic/modifier_generic_custom_indicator.lua", LUA_MODIFIER_MOTION_NONE )
--	LinkLuaModifier("modifier_generic_knockback_lua", "components/modifiers/generic/modifier_generic_knockback_lua.lua", LUA_MODIFIER_MOTION_NONE )
--	LinkLuaModifier("modifier_generic_motion_controller", "components/modifiers/generic/modifier_generic_motion_controller.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_generic_orb_effect_lua", "components/modifiers/generic/modifier_generic_orb_effect_lua.lua", LUA_MODIFIER_MOTION_NONE )

	-- Periodic Spellcast
--	PrecacheResource("particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_bolt_parent.vpcf", context)

	-- vanilla item override
--	LinkLuaModifier("modifier_item_imba_bottle_heal", "components/items/item_bottle.lua", LUA_MODIFIER_MOTION_NONE) -- imba bottle using vanilla replacing modifier in ModifierFilter

	PrecacheResource("soundfile", "soundevents/game_sounds_custom.vsndevts", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end
