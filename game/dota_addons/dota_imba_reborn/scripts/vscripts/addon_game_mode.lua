require('internal/util')
require('gamemode')

function Precache( context )
	LinkLuaModifier("modifier_companion", "components/modifiers/modifier_companion.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_contributor_statue", "components/modifiers/modifier_imba_contributor_statue.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_custom_mechanics", "components/modifiers/modifier_custom_mechanics.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_dummy_dummy", "components/modifiers/modifier_dummy_dummy.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_fountain_aura_lua", "components/modifiers/modifier_fountain_aura_lua.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_donator", "components/modifiers/modifier_imba_donator.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_donator_statue", "components/modifiers/modifier_imba_donator_statue.lua", LUA_MODIFIER_MOTION_NONE )
end

function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end
