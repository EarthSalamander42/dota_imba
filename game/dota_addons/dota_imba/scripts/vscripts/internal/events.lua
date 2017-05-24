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
        if npc:GetUnitName() ~= "npc_dota_hero_wisp" then
            PopulateHeroImbaTalents(npc)
            InitializeInnateAbilities(npc)
        end
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
end

-- This function is called once a player says something on any chat
function GameMode:OnPlayerChat(keys)
	local text = keys.text
	
	-- This Handler is only for commands, ends the function if first character is not "-"
	if not (string.byte(text) == 45) then
		return nil
	end
	
	-- If we are here, declare variables
	local caster = PlayerResource:GetSelectedHeroEntity(keys.playerid)
	local caster_heroname = PlayerResource:GetSelectedHeroName(keys.playerid)
	local color = {}
	
	-- Check for Chakram-Colorcode
	-- if caster_heroname == "npc_dota_hero_shredder" then
	-- 	local chakram_command = false
	-- 	for str in string.gmatch(text, "%S+") do
	-- 		if str == "-chakram" then
	-- 			chakram_command = true
	-- 		elseif chakram_command == false then
	-- 			break
	-- 		end
			
	-- 		if tonumber(str) then
	-- 			if correct_command and tonumber(str) >= 0 and tonumber(str) <=255 then
	-- 				table.insert(color,str)
	-- 				if #color >= 3 then
	-- 					break
	-- 				end
	-- 			else
	-- 				chakram_command = false
	-- 			end
	-- 		end
			
	-- 		if chakram_command == false then
	-- 			break
	-- 		end
	-- 	end
	-- 	if chakram_command == true then
	-- 		caster.color = Vector ( color[1], color[2], color[3])
	-- 		return nil
	-- 	end
	-- end
	
	-- Check for Blink-Colorcode
	local blink_command = false
	for str in string.gmatch(text, "%S+") do
		if str == "-rangeoff" then
			caster.norange = true
		end
		
		if str == "-rangeon" then
			caster.norange = nil
		end
		
		if str == "-blink" then
			blink_command = true
		elseif blink_command == false then
			break
		end
		
		if tonumber(str) then
			if blink_command and tonumber(str) >= 0 and tonumber(str) <=255 then
				table.insert(color,str)
				if #color >= 3 then
					break
				end
			else
				blink_command = false
			end
		end
		
		if blink_command == false then
			break
		end
	end
	
	if blink_command == true then
		caster.blinkcolor = Vector ( color[1], color[2], color[3])
		return nil
	end
end