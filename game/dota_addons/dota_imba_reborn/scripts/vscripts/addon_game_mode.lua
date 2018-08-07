require('internal/util')
require('gamemode')

function Precache( context )

end

function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end
