if GameMode == nil then
	_G.GameMode = class({})
end

-- clientside KV loading
require('addon_init')

require('libraries/adv_log')
require('libraries/animations')
require('libraries/keyvalues')
require('libraries/notifications')
require('libraries/player')
require('libraries/player_resource')
require('libraries/rgb_to_hex')
require('libraries/timers')

require('internal/gamemode')
require('internal/events')

require('components/api/imba')
require('components/battlepass/donator')
require('components/battlepass/experience')
require('components/battlepass/imbattlepass')
require('components/hero_selection/hero_selection')
require('components/settings/settings')
require('components/team_selection/team_selection')

require('events')
require('filters')

-- Use this function as much as possible over the regular Precache (this is Async Precache)
function GameMode:PostLoadPrecache()

end

function GameMode:OnFirstPlayerLoaded()
	api.imba.register(function ()
		-- configure log from api
		Log:ConfigureFromApi()
	end)
end

function GameMode:OnAllPlayersLoaded()

end

function GameMode:InitGameMode()
	self:_InitGameMode()
end
