-- The overall game state has changed
function GameMode:_OnGameRulesStateChange(keys)
	if GameMode._reentrantCheck then
		return
	end

	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
		self.bSeenWaitForPlayers = true
	elseif newState == DOTA_GAMERULES_STATE_INIT then
		--Timers:RemoveTimer("alljointimer")
	elseif newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		TeamSelection:InitializeTeamSelection()
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		GameMode:PostLoadPrecache()
		GameMode:OnAllPlayersLoaded()

		if USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS then
			for i=0,9 do
				if PlayerResource:IsValidPlayer(i) then
					local color = TEAM_COLORS[PlayerResource:GetTeam(i)]
					PlayerResource:SetCustomPlayerColor(i, color[1], color[2], color[3])
				end
			end
		end
	end

	GameMode._reentrantCheck = true
	GameMode:OnGameRulesStateChange(keys)
	GameMode._reentrantCheck = false
end

-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:_OnNPCSpawned(keys)
	if GameMode._reentrantCheck then
		return
	end

	local npc = EntIndexToHScript(keys.entindex)

	if npc:IsRealHero() and npc.bFirstSpawned == nil then
		npc.bFirstSpawned = true
	end

	GameMode._reentrantCheck = true
	GameMode:OnNPCSpawned(keys)
	GameMode._reentrantCheck = false
end

function GameMode:_OnEntityKilled( keys )
	if GameMode._reentrantCheck then
		return
	end

	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local killerEntity = nil

	if keys.entindex_attacker ~= nil then
		killerEntity = EntIndexToHScript( keys.entindex_attacker )
	end

	GameMode._reentrantCheck = true
	GameMode:OnEntityKilled( keys )
	GameMode._reentrantCheck = false
end

function GameMode:_OnConnectFull(keys)
	if GameMode._reentrantCheck then
		return
	end

	GameMode:_CaptureGameMode()

	local entIndex = keys.index+1
	-- The Player entity of the joining user
	local ply = EntIndexToHScript(entIndex)

	self.vUserIds = self.vUserIds or {}
	self.vUserIds[keys.userid] = ply

	GameMode._reentrantCheck = true
	GameMode:OnConnectFull( keys )
	GameMode._reentrantCheck = false
end
