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
            if npc:GetUnitName() ~= "npc_dota_hero_wisp" then
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
		for i = 1, #IMBA_DEVS do
			if PlayerResource:GetSteamAccountID(caster:GetPlayerID()) == IMBA_DEVS[i] then
				if str == "-dev_remove_units" then
					GameMode:RemoveUnits(true, true, true)
				end

				for i = 1,3 do
					if text == "-diretide "..i then
						local units = FindUnitsInRadius(1, Vector(0,0,0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
						for _, unit in ipairs(units) do
							if unit:GetName() == "npc_dota_roshan" then
								local AImod = unit:FindModifierByName("modifier_imba_roshan_ai_diretide")
								if AImod then
									AImod:SetStackCount(i)
									unit:Interrupt()
								else
									print("ERROR - Could not find Roshans AI modifier")
								end
							--	break (Do we want multiple Roshans roaming the map? :nofun:)
							end
						end
					end
				end

				if text == "-killrosh" then
					local units = FindUnitsInRadius(1, Vector(0,0,0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
					for _, unit in ipairs(units) do
						if unit:GetName() == "npc_dota_roshan" then
							unit:Kill(nil, unit)
						end
					end
				end

				if text == "-candy" then
					local units = FindUnitsInRadius(1, Vector(0,0,0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
					for _, unit in ipairs(units) do
						if unit:GetName() == "npc_dota_roshan" then
							local AImod = unit:FindModifierByName("modifier_imba_roshan_ai_diretide")
							if AImod then AImod:Candy(unit) end
						end
					end
				end

				if text == "-spawnrosh" then
					CreateUnitByName("npc_diretide_roshan", Vector(0,0,0), true, nil, nil, DOTA_TEAM_NEUTRALS) 
				end
			end
		end

		if str == "-rangeoff" then
			caster.norange = true
		end

		if str == "-rangeon" then
			caster.norange = nil
		end

		if str == "-printxpinfo" then
			Server_PrintInfo() --print the XP system info
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
		caster.blinkcolor = Vector(color[1], color[2], color[3])
		return nil
	end
end