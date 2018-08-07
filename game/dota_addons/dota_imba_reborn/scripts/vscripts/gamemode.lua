if GameMode == nil then
	_G.GameMode = class({})
end

require('libraries/adv_log')
require('libraries/animations')
require('libraries/notifications')
require('libraries/playertables')
require('libraries/timers')

require('internal/gamemode')
require('internal/events')

require('components/settings/settings')
require('components/team_selection/team_selection')

require('events')
require('filters')

-- Use this function as much as possible over the regular Precache (this is Async Precache)
function GameMode:PostLoadPrecache()

end

function GameMode:OnFirstPlayerLoaded()

end

function GameMode:OnAllPlayersLoaded()

end

function GameMode:InitGameMode()
	self:_InitGameMode()
end
