-- The overall game state has changed
function GameMode:_OnGameRulesStateChange(keys)
	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
		self.bSeenWaitForPlayers = true
	elseif newState == DOTA_GAMERULES_STATE_INIT then
		--Timers:RemoveTimer("alljointimer")
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		GameMode:PostLoadPrecache()
    	GameMode:OnAllPlayersLoaded()
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		GameMode:OnGameInProgress()
	end
end

-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:_OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)

	if npc:IsRealHero() and npc.bFirstSpawned == nil then
		npc.bFirstSpawned = true
		GameMode:OnHeroInGame(npc)
	end
end

-- An entity died
function GameMode:_OnEntityKilled( keys )
	
	-- The Unit that was Killed
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	-- The Killing entity
	local killerEntity = nil

	if keys.entindex_attacker ~= nil then
		killerEntity = EntIndexToHScript( keys.entindex_attacker )
	end

	if killedUnit:IsRealHero() then 
		DebugPrint("KILLED, KILLER: " .. killedUnit:GetName() .. " -- " .. killerEntity:GetName())
		if END_GAME_ON_KILLS and GetTeamHeroKills(killerEntity:GetTeam()) >= KILLS_TO_END_GAME_FOR_TEAM then
			GameRules:SetSafeToLeave( true )
			GameRules:SetGameWinner( killerEntity:GetTeam() )
		end

		--PlayerResource:GetTeamKills
		if SHOW_KILLS_ON_TOPBAR then
			GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_BADGUYS, GetTeamHeroKills(DOTA_TEAM_BADGUYS))
			GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, GetTeamHeroKills(DOTA_TEAM_GOODGUYS))
		end
	end
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:_OnConnectFull(keys)
	GameMode:_CaptureGameMode()
	
	-- Store player's player ID
	local player_id = keys.PlayerID
	local player_steam_id_64 = tostring(PlayerResource:GetSteamID(player_id))

	-- If this is Baumi, end the game
	if player_steam_id_64 == "76561198003571172" then
		IS_BANNED_PLAYER = true
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
		GameRules:SetHeroSelectionTime(1)
		GameRules:SetPreGameTime(3)
		GameRules:SetPostGameTime(2)
		GameRules:SetCustomGameSetupAutoLaunchDelay(3)
		GameRules:SetCustomGameSetupRemainingTime(0)
	end
end