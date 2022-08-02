function COverthrowGameMode:OnGameRulesStateChange()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		self:GatherAndRegisterValidTeams()
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		local numberOfPlayers = PlayerResource:GetPlayerCount()

		if numberOfPlayers > 7 then
			--COverthrowGameMode.TEAM_KILLS_TO_WIN = 25
			COverthrowGameMode.nCOUNTDOWNTIMER = 901
		else
			--COverthrowGameMode.TEAM_KILLS_TO_WIN = 15
			COverthrowGameMode.nCOUNTDOWNTIMER = 601
		end

		if GetMapName() == "imbathrow_ffa" then
			COverthrowGameMode.TEAM_KILLS_TO_WIN = 50
		else
			COverthrowGameMode.TEAM_KILLS_TO_WIN = 30
		end
		-- print( "Kills to win = " .. tostring(COverthrowGameMode.TEAM_KILLS_TO_WIN) )

		CustomNetTables:SetTableValue( "game_options", "victory_condition", { kills_to_win = COverthrowGameMode.TEAM_KILLS_TO_WIN } )

		COverthrowGameMode._fPreGameStartTime = GameRules:GetGameTime()

	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "OnGameRulesStateChange: Game In Progress" )
		COverthrowGameMode:OnThink()
		COverthrowGameMode.countdownEnabled = true
		CustomGameEventManager:Send_ServerToAllClients( "show_timer", {} )
		DoEntFire( "center_experience_ring_particles", "Start", "0", 0, COverthrowGameMode, COverthrowGameMode  )
	end
end

--------------------------------------------------------------------------------
-- Event: OnNPCSpawned
--------------------------------------------------------------------------------
ListenToGameEvent("npc_spawned", function(event)
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if spawnedUnit:IsRealHero() then
		-- Destroys the last hit effects
		local deathEffects = spawnedUnit:Attribute_GetIntValue( "effectsID", -1 )
		if deathEffects ~= -1 then
			ParticleManager:DestroyParticle( deathEffects, true )
			spawnedUnit:DeleteAttribute( "effectsID" )
		end
		if COverthrowGameMode.allSpawned == false then
			if GetMapName() == "mines_trio" then
				--print("mines_trio is the map")
				--print("COverthrowGameMode.allSpawned is " .. tostring(COverthrowGameMode.allSpawned) )
				local unitTeam = spawnedUnit:GetTeam()
				local particleSpawn = ParticleManager:CreateParticleForTeam( "particles/addons_gameplay/player_deferred_light.vpcf", PATTACH_ABSORIGIN, spawnedUnit, unitTeam )
				ParticleManager:SetParticleControlEnt( particleSpawn, PATTACH_ABSORIGIN, spawnedUnit, PATTACH_ABSORIGIN, "attach_origin", spawnedUnit:GetAbsOrigin(), true )
			end
		end
	end
end, nil)

---------------------------------------------------------------------------
-- Event: OnTeamKillCredit, see if anyone won
---------------------------------------------------------------------------
ListenToGameEvent("dota_team_kill_credit", function(event)
--	print( "OnKillCredit" )
--	DeepPrint( event )

	local nKillerID = event.killer_userid
	local nTeamID = event.teamnumber
	local nTeamKills = event.herokills
	local nKillsRemaining = COverthrowGameMode.TEAM_KILLS_TO_WIN - nTeamKills
	
	local broadcast_kill_event =
	{
		killer_id = event.killer_userid,
		team_id = event.teamnumber,
		team_kills = nTeamKills,
		kills_remaining = nKillsRemaining,
		victory = 0,
		close_to_victory = 0,
		very_close_to_victory = 0,
	}

	if nKillsRemaining <= 0 then
		GameRules:SetCustomVictoryMessage( COverthrowGameMode.m_VictoryMessages[nTeamID] )
		GameRules:SetGameWinner( nTeamID )
		broadcast_kill_event.victory = 1
	elseif nKillsRemaining == 1 then
		EmitGlobalSound( "ui.npe_objective_complete" )
		broadcast_kill_event.very_close_to_victory = 1
	elseif nKillsRemaining <= COverthrowGameMode.CLOSE_TO_VICTORY_THRESHOLD then
		EmitGlobalSound( "ui.npe_objective_given" )
		broadcast_kill_event.close_to_victory = 1
	end

	CustomGameEventManager:Send_ServerToAllClients( "kill_event", broadcast_kill_event )
end, nil)

---------------------------------------------------------------------------
-- Event: OnEntityKilled
---------------------------------------------------------------------------
ListenToGameEvent("entity_killed", function(event)
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killedTeam = killedUnit:GetTeam()
	local hero = EntIndexToHScript( event.entindex_attacker )
	local heroTeam = hero:GetTeam()
	local extraTime = 0
	if killedUnit:IsRealHero() then
		COverthrowGameMode.allSpawned = true
		--print("Hero has been killed")
		--Add extra time if killed by Necro Ult
		if hero:IsRealHero() == true then
			if event.entindex_inflictor ~= nil then
				local inflictor_index = event.entindex_inflictor
				if inflictor_index ~= nil then
					local ability = EntIndexToHScript( event.entindex_inflictor )
					if ability ~= nil then
						if ability:GetAbilityName() ~= nil then
							if ability:GetAbilityName() == "necrolyte_reapers_scythe" then
								print("Killed by Necro Ult")
								extraTime = 20
							end
						end
					end
				end
			end
		end
		if hero:IsRealHero() and heroTeam ~= killedTeam then
			--print("Granting killer xp")
			if killedUnit:GetTeam() == COverthrowGameMode.leadingTeam and COverthrowGameMode.isGameTied == false then
				local memberID = hero:GetPlayerID()
				PlayerResource:ModifyGold( memberID, 500, true, 0 )
				hero:AddExperience( 100, 0, false, false )
				local name = hero:GetClassname()
				local victim = killedUnit:GetClassname()
				local kill_alert =
					{
						hero_id = hero:GetClassname()
					}
				CustomGameEventManager:Send_ServerToAllClients( "kill_alert", kill_alert )
			else
				hero:AddExperience( 50, 0, false, false )
			end
		end
		--Granting XP to all heroes who assisted
		local allHeroes = HeroList:GetAllHeroes()
		for _,attacker in pairs( allHeroes ) do
			--print(killedUnit:GetNumAttackers())
			for i = 0, killedUnit:GetNumAttackers() - 1 do
				if attacker == killedUnit:GetAttacker( i ) then
					--print("Granting assist xp")
					attacker:AddExperience( 25, 0, false, false )
				end
			end
		end
		if killedUnit:GetRespawnTime() > 10 then
			--print("Hero has long respawn time")
			if killedUnit:IsReincarnating() == true then
				--print("Set time for Wraith King respawn disabled")
				return nil
			else
				COverthrowGameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )
			end
		else
			COverthrowGameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )
		end
	end
end, nil)

function COverthrowGameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )
	--print("Setting time for respawn")
	if killedTeam == COverthrowGameMode.leadingTeam and COverthrowGameMode.isGameTied == false then
		killedUnit:SetTimeUntilRespawn( 20 + extraTime )
	else
		killedUnit:SetTimeUntilRespawn( 10 + extraTime )
	end
end

--------------------------------------------------------------------------------
-- Event: OnItemPickUp
--------------------------------------------------------------------------------
ListenToGameEvent("dota_item_picked_up", function(event)
	local item = EntIndexToHScript( event.ItemEntityIndex )
	local owner = EntIndexToHScript( event.HeroEntityIndex )
	r = 300
	--r = RandomInt(200, 400)
	if event.itemname == "item_bag_of_gold" then
		--print("Bag of gold picked up")
		PlayerResource:ModifyGold( owner:GetPlayerID(), r, true, 0 )
		SendOverheadEventMessage( owner, OVERHEAD_ALERT_GOLD, owner, r, nil )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	elseif event.itemname == "item_treasure_chest" then
		--print("Special Item Picked Up")
		DoEntFire( "item_spawn_particle_" .. COverthrowGameMode.itemSpawnIndex, "Stop", "0", 0, COverthrowGameMode, COverthrowGameMode )
		COverthrowGameMode:SpecialItemAdd( event )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	end
end, nil)

--------------------------------------------------------------------------------
-- Event: OnNpcGoalReached
--------------------------------------------------------------------------------
ListenToGameEvent("dota_npc_goal_reached", function(event)
	local npc = EntIndexToHScript( event.npc_entindex )
	if npc:GetUnitName() == "npc_dota_treasure_courier" then
		COverthrowGameMode:TreasureDrop( npc )
	end
end, nil)

function COverthrowGameMode:CountdownTimer()
	COverthrowGameMode.nCOUNTDOWNTIMER = COverthrowGameMode.nCOUNTDOWNTIMER - 1
	local t = COverthrowGameMode.nCOUNTDOWNTIMER
	-- print( t )
	local minutes = math.floor(t / 60)
	local seconds = t - (minutes * 60)
	local m10 = math.floor(minutes / 10)
	local m01 = minutes - (m10 * 10)
	local s10 = math.floor(seconds / 10)
	local s01 = seconds - (s10 * 10)
	local broadcast_gametimer = {
			timer_minute_10 = m10,
			timer_minute_01 = m01,
			timer_second_10 = s10,
			timer_second_01 = s01,
		}
	CustomGameEventManager:Send_ServerToAllClients( "countdown", broadcast_gametimer )
	if t <= 120 then
		CustomGameEventManager:Send_ServerToAllClients( "time_remaining", broadcast_gametimer )
	end
end

function COverthrowGameMode:OnThink()
	Timers:CreateTimer(function()
		for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
			COverthrowGameMode:UpdatePlayerColor( nPlayerID )
		end
		
		COverthrowGameMode:UpdateScoreboard()
		-- Stop thinking if game is paused
		if GameRules:IsGamePaused() == true then
			return 1
		end

		if COverthrowGameMode.countdownEnabled == true then
			COverthrowGameMode:CountdownTimer()
			if COverthrowGameMode.nCOUNTDOWNTIMER == 30 then
				CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
			end
			if COverthrowGameMode.nCOUNTDOWNTIMER <= 0 then
				--Check to see if there's a tie
				if COverthrowGameMode.isGameTied == false then
					GameRules:SetCustomVictoryMessage( COverthrowGameMode.m_VictoryMessages[COverthrowGameMode.leadingTeam] )
					COverthrowGameMode:EndGame( COverthrowGameMode.leadingTeam )
					COverthrowGameMode.countdownEnabled = false
				else
					COverthrowGameMode.TEAM_KILLS_TO_WIN = COverthrowGameMode.leadingTeamScore + 1
					local broadcast_killcount = 
					{
						killcount = COverthrowGameMode.TEAM_KILLS_TO_WIN
					}
					CustomGameEventManager:Send_ServerToAllClients( "overtime_alert", broadcast_killcount )
				end
			end
		end
		
		if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			--Spawn Gold Bags
			COverthrowGameMode:ThinkGoldDrop()
			COverthrowGameMode:ThinkSpecialItemDrop()
		end

		return 1.0
	end)
end
