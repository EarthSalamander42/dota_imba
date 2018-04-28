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

	if npc:IsRealHero() then
		if npc.bFirstSpawned == nil then
			npc.bFirstSpawned = true
			if npc:GetUnitName() ~= FORCE_PICKED_HERO then
				PopulateHeroImbaTalents(npc)
				InitializeInnateAbilities(npc)
			end
			GameMode:OnHeroInGame(npc)
		end

		AddMissingGenericTalent(npc)
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
		log.debug("KILLED, KILLER: " .. killedUnit:GetName() .. " -- " .. killerEntity:GetName())
		if END_GAME_ON_KILLS and GetTeamHeroKills(killerEntity:GetTeam()) >= KILLS_TO_END_GAME_FOR_TEAM then
			GameRules:SetSafeToLeave( true )
			GameRules:SetGameWinner( killerEntity:GetTeam() )
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
	local caster = PlayerResource:GetSelectedHeroEntity(keys.playerid)
	local caster_heroname = PlayerResource:GetSelectedHeroName(keys.playerid)
	local color = {}

	-- I dont know exactly where to put this so ill put here
	local steamid = tostring(PlayerResource:GetSteamID(keys.playerid))
	local _text = tostring(text)
	api.imba.event(api.events.chat, {
		steamid,
		text
	})

	-- This Handler is only for commands, ends the function if first character is not "-"
	if not (string.byte(text) == 45) then
		return nil
	end

	for str in string.gmatch(text, "%S+") do
		if IsInToolsMode() or api.imba.is_developer(steamid) then
			if str == "-dev_remove_units" then
				GameMode:RemoveUnits(true, true, true)
			end

			if str == "-spawnimbarune" then
				SpawnImbaRunes()
			end

			if str == "-replaceherowith" then
				text = string.gsub(text, str, "")
				text = string.gsub(text, " ", "")
				if PlayerResource:GetSelectedHeroName(caster:GetPlayerID()) ~= "npc_dota_hero_"..text then
					if caster.companion then
						caster.companion:ForceKill(false)
						caster.companion = nil
					end

					PrecacheUnitByNameAsync("npc_dota_hero_"..text, function()
						HeroSelection:GiveStartingHero(caster:GetPlayerID(), "npc_dota_hero_"..text, true)
					end)
				end
			end
		end

		if str == "-gg" then
			print("Player has GG!")
			CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "gg_init_by_local", {})
		end
	end
end
