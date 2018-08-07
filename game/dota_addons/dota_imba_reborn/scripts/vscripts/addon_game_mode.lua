require('internal/util')
require('gamemode')

function Precache( context )
	LinkLuaModifier("modifier_custom_mechanics", "components/modifiers/modifier_custom_mechanics.lua", LUA_MODIFIER_MOTION_NONE )
end

function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end
