-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode
BAREBONES_VERSION = "1.00"

-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = false 

if GameMode == nil then
	_G.GameMode = class({})
end

require('libraries/adv_log')
require('libraries/timers')
require('libraries/notifications')
require('libraries/npc_class_extension')
require('libraries/rgb_to_hex')
require('libraries/keyvalues')

require('internal/gamemode')
require('settings')
require('events')
require('filters')

require('components/hero_selection')

function GameMode:PostLoadPrecache()
	--PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

-- CAREFUL, FOR REASONS THIS FUNCTION IS ALWAYS CALLED TWICE
function GameMode:InitGameMode()
	self:_InitGameMode()
end
