-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')

function Precache( context )
	LinkLuaModifier("modifier_frantic", "modifiers/modifier_frantic.lua", LUA_MODIFIER_MOTION_NONE )

	-- Periodic Spellcast
--	PrecacheResource("particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_bolt_parent.vpcf", context)

	PrecacheResource("soundfile", "soundevents/game_sounds_custom.vsndevts", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end
