-- This file contains all barebones-registered events and has already set up the passed-in parameters for your use.
-- Do not remove the GameMode:_Function calls in these events as it will mess with the internal barebones systems.

-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
	DebugPrint('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
	DebugPrintTable(keys)

	local player_name = keys.name

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player disconnect/abandon logic
	-------------------------------------------------------------------------------------------------

	-- If players haven't finished picking yet, do nothing
	if not IMBA_STARTED_TRACKING_CONNECTIONS then
		return nil
	end

	-- If the game has already been won, do nothing
	--if ??? then
	--	return nil
	--end

	-- Connection status detection delay
	Timers:CreateTimer(1, function()
	
		-- Identify which player was disconnected
		local player_id = -1
		for id = 0, 9 do
			if self.players[id] and self.players[id].connection_state ~= PlayerResource:GetConnectionState(id) then
				player_id = id
				self.players[id].connection_state = PlayerResource:GetConnectionState(id)
				break
			end
		end

		-- If no valid player was detected, do nothing
		if player_id == (-1) then
			return nil
		end
		
		-- Parameters
		local team = PlayerResource:GetTeam(player_id)
		local hero = self.heroes[player_id]
		local hero_name = hero:GetName()
		local full_abandon = false
		local line_duration = 5
		local remaining_connected_players

		-- Set global variable tracking the time the player has been disconnected for
		if not self.players[player_id].disconnected_time then
			self.players[player_id].disconnected_time = 0
		end
		
		self.players[player_id].is_disconnected = true

		-- Radiant leaver logic
		if team == DOTA_TEAM_GOODGUYS then
			GOODGUYS_CONNECTED_PLAYERS = GOODGUYS_CONNECTED_PLAYERS - 1
			remaining_connected_players = GOODGUYS_CONNECTED_PLAYERS

			-- Full team has abandoned
			if GOODGUYS_CONNECTED_PLAYERS == 0 then
				full_abandon = true

				-- Display message to the other team
				Notifications:BottomToAll({text = "#imba_team_good_abandon_message", duration = line_duration, style = {color = "DodgerBlue"} })

				-- End the game in 15 seconds if no one reconnects
				Timers:CreateTimer(15, function()
					if GOODGUYS_CONNECTED_PLAYERS == 0 then
						GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
					end
				end)
			end

		-- Dire leaver logic
		elseif team == DOTA_TEAM_BADGUYS then
			BADGUYS_CONNECTED_PLAYERS = BADGUYS_CONNECTED_PLAYERS - 1
			remaining_connected_players = BADGUYS_CONNECTED_PLAYERS

			-- Full team has abandoned
			if BADGUYS_CONNECTED_PLAYERS == 0 then
				full_abandon = true

				-- Display message to the other team
				Notifications:BottomToAll({text = "#imba_team_bad_abandon_message", duration = line_duration, style = {color = "DodgerBlue"} })

				-- End the game in 15 seconds if no one reconnects
				Timers:CreateTimer(15, function()
					if BADGUYS_CONNECTED_PLAYERS == 0 then
						GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
					end
				end)
			end
		end

		-- Some players on the abandoner's team are still connected
		if not full_abandon then

			-- Show team-only disconnect message
			if not self.players[player_id].has_abandoned then
				Notifications:BottomToTeam(team, {hero = hero_name, duration = line_duration})
				Notifications:BottomToTeam(team, {text = player_name.." ", duration = line_duration, continue = true})
				Notifications:BottomToTeam(team, {text = "#imba_player_disconnect_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})
			end

			-- Grant control of the disconnected player's hero to its allies
			for player_num = 1, remaining_connected_players do
				local current_player_id = PlayerResource:GetNthPlayerIDOnTeam(team, player_num)
				hero:SetControllableByPlayer(current_player_id, true)
			end
		end

		-- If the player had already abandoned previously, run its abandon routine
		if self.players[player_id].has_abandoned then
			AbandonGame(hero, player_id)
		end

		-- Check for player abandon every second
		Timers:CreateTimer(1, function()

			-- If the player hasn't come back, update total disconnected time
			if self.players[player_id].is_disconnected then
				self.players[player_id].disconnected_time = self.players[player_id].disconnected_time + 1
			end

			-- If the player has been disconnected for over 3 minutes total, run its abandon routine
			if self.players[player_id].disconnected_time >= PLAYER_ABANDON_TIME then
				self.players[player_id].has_abandoned = true
				AbandonGame(hero, player_id)

				-- Show message to remaining players
				Notifications:BottomToAll({hero = hero_name, duration = line_duration})
				Notifications:BottomToAll({text = player_name.." ", duration = line_duration, continue = true})
				Notifications:BottomToAll({text = "#imba_player_abandon_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})
			else
				return 1
			end
		end)
	end)

end

-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
	DebugPrint("[BAREBONES] GameRules State Changed")
	DebugPrintTable(keys)

	-- This internal handling is used to set up main barebones functions
	GameMode:_OnGameRulesStateChange(keys)

	local newState = GameRules:State_Get()
end

-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
	DebugPrint("[BAREBONES] NPC Spawned")
	DebugPrintTable(keys)

	-- This internal handling is used to set up main barebones functions
	GameMode:_OnNPCSpawned(keys)

	local npc = EntIndexToHScript(keys.entindex)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Aegis clean-up
	-------------------------------------------------------------------------------------------------
	if npc.has_aegis then

		-- Remove Aegis ownership flag
		npc.has_aegis = nil
		npc:RemoveModifierByName("modifier_item_imba_aegis")

		-- Update kill bounty
		local npc_level = npc:GetLevel()
		local gold_bounty = HERO_KILL_GOLD_BASE + npc_level * HERO_KILL_GOLD_PER_LEVEL + GetKillstreakGold(npc)
		local xp_bounty
		if npc_level <= 5 then
			xp_bounty = HERO_KILL_XP_CONSTANT_1 + ( npc_level - 1 ) * HERO_KILL_XP_CONSTANT_2
		else
			xp_bounty = ( npc_level - 4 ) * HERO_KILL_XP_CONSTANT_1 + 4 * HERO_KILL_XP_CONSTANT_2
		end

		-- Adjust bounties with the game options multiplier
		gold_bounty = math.max( gold_bounty * ( 100 + HERO_GOLD_BONUS ) / 100, 0)
		xp_bounty = xp_bounty * ( 100 + HERO_XP_BONUS ) / 100
		npc:SetDeathXP(xp_bounty)
		npc:SetMaximumGoldBounty(gold_bounty)
		npc:SetMinimumGoldBounty(gold_bounty)
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Reaper's Scythe buyback prevention clean-up
	-------------------------------------------------------------------------------------------------

	if npc:IsRealHero() then
		npc:SetBuyBackDisabledByReapersScythe(false)
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Buyback setup (part 2)
	-------------------------------------------------------------------------------------------------

	-- Check if the spawned unit has the buyback penalty modifier
	Timers:CreateTimer(0.1, function()
		if not npc:IsNull() and npc:HasModifier("modifier_buyback_gold_penalty") then

			-- Update the quick sucession buyback cost increase variable
			if npc.quick_sucession_buybacks then
				npc.quick_sucession_buybacks = npc.quick_sucession_buybacks + 1
			else
				npc.quick_sucession_buybacks = 1
			end

			-- Store this buyback's variable amount for later reference
			local this_buyback_number = npc.quick_sucession_buybacks

			-- Reset buyback cost after the penalty time ends
			Timers:CreateTimer(0.5, function()
				if npc:HasModifier("modifier_buyback_gold_penalty") or not npc:IsAlive() then
					return 0.5
				else
					if this_buyback_number == npc.quick_sucession_buybacks then
						npc.quick_sucession_buybacks = 0
					end
				end
			end)
		end
	end)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Creep bounty/stats adjustment
	-------------------------------------------------------------------------------------------------

	if not npc:IsHero() and not npc:IsOwnedByAnyPlayer() then

		-- Fetch base bounties
		local max_bounty = npc:GetMaximumGoldBounty()
		local min_bounty = npc:GetMinimumGoldBounty()
		local xp_bounty = npc:GetDeathXP()

		-- Adjust bounties based on game time
		local game_time = GAME_TIME_ELAPSED / 60
		max_bounty = max_bounty * ( 100 + CREEP_BOUNTY_RAMP_UP_PER_MINUTE * game_time ) / 100
		min_bounty = min_bounty * ( 100 + CREEP_BOUNTY_RAMP_UP_PER_MINUTE * game_time ) / 100
		xp_bounty = xp_bounty * ( 100 + CREEP_BOUNTY_RAMP_UP_PER_MINUTE * game_time ) / 100

		-- Adjust bounties according to game options
		npc:SetDeathXP( math.floor( xp_bounty * ( 1 + CREEP_XP_BONUS / 100 ) ) )
		npc:SetMaximumGoldBounty( math.floor( max_bounty * ( 1 + CREEP_GOLD_BONUS / 100 ) ) )
		npc:SetMinimumGoldBounty( math.floor( min_bounty * ( 1 + CREEP_GOLD_BONUS / 100 ) ) )

		-- Add passive buff to non-neutrals
		if not string.find(npc:GetName(), "neutral") then
			npc:AddAbility("imba_creep_buffs")
			local creep_ability = npc:FindAbilityByName("imba_creep_buffs")
			creep_ability:SetLevel(1)
		end
	end

end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
	--DebugPrint("[BAREBONES] Entity Hurt")
	--DebugPrintTable(keys)

	local damagebits = keys.damagebits -- This might always be 0 and therefore useless
	if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
	local entCause = EntIndexToHScript(keys.entindex_attacker)
	local entVictim = EntIndexToHScript(keys.entindex_killed)
	end
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
	DebugPrint( '[BAREBONES] OnItemPickedUp' )
	DebugPrintTable(keys)

	local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local itemname = keys.itemname
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)
	DebugPrint( '[BAREBONES] OnPlayerReconnect' )
	DebugPrintTable(keys) 

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player reconnect logic
	-------------------------------------------------------------------------------------------------

	-- If players haven't finished picking yet, do nothing
	if not IMBA_STARTED_TRACKING_CONNECTIONS then
		return nil
	end

	-- If the game has already been won, do nothing
	--if ??? then
	--	return nil
	--end

	local player_id = -1

	-- Connection status detection delay
	Timers:CreateTimer(1, function()

		-- Identify which player just reconnected
		for id = 0, 9 do
			if self.players[id] and self.players[id].connection_state ~= PlayerResource:GetConnectionState(id) then
				player_id = id
				self.players[id].connection_state = PlayerResource:GetConnectionState(id)
				break
			end
		end

		-- If no valid connecting player was detected, do nothing
		if player_id == (-1) then
			return nil
		end

		-- Parameters
		local player = PlayerResource:GetPlayer(player_id)
		local player_name = PlayerResource:GetPlayerName(player_id)
		local team = PlayerResource:GetTeam(player_id)
		local hero = player:GetAssignedHero()
		local hero_name = hero:GetName()

		-- Update player and team connection status
		self.players[player_id].is_disconnected = false
		if team == DOTA_TEAM_GOODGUYS then
			GOODGUYS_CONNECTED_PLAYERS = GOODGUYS_CONNECTED_PLAYERS + 1
		elseif team == DOTA_TEAM_BADGUYS then
			BADGUYS_CONNECTED_PLAYERS = BADGUYS_CONNECTED_PLAYERS + 1
		end

		-- Show reconnection message to remaining players
		local line_duration = 5

		Notifications:BottomToAll({hero = hero_name, duration = line_duration})
		Notifications:BottomToAll({text = player_name.." ", duration = line_duration, continue = true})
		Notifications:BottomToAll({text = "#imba_player_reconnect_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})
	end)

end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
	DebugPrint( '[BAREBONES] OnItemPurchased' )
	DebugPrintTable(keys)

	-- The playerID of the hero who is buying something
	local plyID = keys.PlayerID
	if not plyID then return end

	-- The name of the item purchased
	local itemName = keys.itemname 
	
	-- The cost of the item purchased
	local itemcost = keys.itemcost
	
end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
	DebugPrint('[BAREBONES] AbilityUsed')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
	DebugPrint('[BAREBONES] OnNonPlayerUsedAbility')
	DebugPrintTable(keys)

	local abilityname=  keys.abilityname
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
	DebugPrint('[BAREBONES] OnPlayerChangedName')
	DebugPrintTable(keys)

	local newName = keys.newname
	local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility( keys)
	DebugPrint('[BAREBONES] OnPlayerLearnedAbility')
	DebugPrintTable(keys)

	local player = EntIndexToHScript(keys.player)
	local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
	DebugPrint('[BAREBONES] OnAbilityChannelFinished')
	DebugPrintTable(keys)

	local abilityname = keys.abilityname
	local interrupted = keys.interrupted == 1
end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)
	DebugPrint('[BAREBONES] OnPlayerLevelUp')
	DebugPrintTable(keys)

	local player = EntIndexToHScript(keys.player)
	local level = keys.level

	-------------------------------------------------------------------------------------------------
	-- IMBA: Update hero bounty on level up
	-------------------------------------------------------------------------------------------------

	-- Calculate new base bounties
	local hero = player:GetAssignedHero()
	local hero_level = hero:GetLevel()

	-- Gold bounty
	local gold_bounty = HERO_KILL_GOLD_BASE + hero_level * HERO_KILL_GOLD_PER_LEVEL + GetKillstreakGold(hero)

	-- XP bounty
	local xp_bounty
	if hero_level <= 5 then
		xp_bounty = HERO_KILL_XP_CONSTANT_1 + ( hero_level - 1 ) * HERO_KILL_XP_CONSTANT_2
	else
		xp_bounty = ( hero_level - 4 ) * HERO_KILL_XP_CONSTANT_1 + 4 * HERO_KILL_XP_CONSTANT_2
	end

	-- Adjust bounties with the game options multiplier
	gold_bounty = math.max( gold_bounty * ( 100 + HERO_GOLD_BONUS ) / 100, 0)
	xp_bounty = xp_bounty * ( 100 + HERO_XP_BONUS ) / 100
	hero:SetDeathXP(xp_bounty)
	hero:SetMaximumGoldBounty(gold_bounty)
	hero:SetMinimumGoldBounty(gold_bounty)

	-- If the hero owns the Aegis, nullify its bounty
	if hero.has_aegis then
		hero:SetDeathXP(0)
		hero:SetMaximumGoldBounty(0)
		hero:SetMinimumGoldBounty(0)
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Unlimited level logic
	-------------------------------------------------------------------------------------------------

	if hero_level > 25 then

		-- Prevent the hero from gaining further ability points after level 25
		hero:SetAbilityPoints( hero:GetAbilityPoints() - 1 )

		-- If the generic powerup isn't present, apply it
		local ability_powerup = hero:FindAbilityByName("imba_unlimited_level_powerup")
		if not ability_powerup then
			hero:AddAbility("imba_unlimited_level_powerup")
			ability_powerup = hero:FindAbilityByName("imba_unlimited_level_powerup")
			ability_powerup:SetLevel(1)
		end

		-- Increase the amount of stacks of the high level power-up
		AddStacks(ability_powerup, hero, hero, "modifier_imba_unlimited_level_powerup", 1, true)
	end

end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
	DebugPrint('[BAREBONES] OnLastHit')
	DebugPrintTable(keys)

	local isFirstBlood = keys.FirstBlood == 1
	local isHeroKill = keys.HeroKill == 1
	local isTowerKill = keys.TowerKill == 1
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local killedEnt = EntIndexToHScript(keys.EntKilled)
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
	DebugPrint('[BAREBONES] OnTreeCut')
	DebugPrintTable(keys)

	local treeX = keys.tree_x
	local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated (keys)
	DebugPrint('[BAREBONES] OnRuneActivated')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local rune = keys.rune

	--[[ Rune Can be one of the following types
	DOTA_RUNE_DOUBLEDAMAGE
	DOTA_RUNE_HASTE
	DOTA_RUNE_HAUNTED
	DOTA_RUNE_ILLUSION
	DOTA_RUNE_INVISIBILITY
	DOTA_RUNE_BOUNTY
	DOTA_RUNE_MYSTERY
	DOTA_RUNE_RAPIER
	DOTA_RUNE_REGENERATION
	DOTA_RUNE_SPOOKY
	DOTA_RUNE_TURBO
	]]
end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
	DebugPrint('[BAREBONES] OnPlayerTakeTowerDamage')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local damage = keys.damage
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)
	DebugPrint('[BAREBONES] OnPlayerPickHero')
	DebugPrintTable(keys)

	local heroClass = keys.hero
	local heroEntity = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)

	-------------------------------------------------------------------------------------------------
	-- IMBA: All Pick hero pick logic
	-------------------------------------------------------------------------------------------------

	if IMBA_PICK_MODE_ALL_PICK then

		-- Fetch player's team and chosen hero
		local team = PlayerResource:GetTeam(player:GetPlayerID())
		local hero = player:GetAssignedHero()
		local hero_name = hero:GetName()

		-- Check if the hero was already picked in the same team
		--if PlayerResource:IsHeroSelected(hero_name) then
		--	local all_heroes = HeroList:GetAllHeroes()
		--	for _,picked_hero in pairs(all_heroes) do
		--		if hero_name == picked_hero:GetName() and team == picked_hero:GetTeam() then
		--			player:MakeRandomHeroSelection()
		--		end
		--	end
		--end
	end
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
	DebugPrint('[BAREBONES] OnTeamKillCredit')
	DebugPrintTable(keys)

	local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
	local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
	local numKills = keys.herokills
	local killerTeamNumber = keys.teamnumber
end

-- An entity died
function GameMode:OnEntityKilled( keys )
	DebugPrint( '[BAREBONES] OnEntityKilled Called' )
	DebugPrintTable( keys )

	GameMode:_OnEntityKilled( keys )

	-- The Unit that was Killed
	local killed_unit = EntIndexToHScript( keys.entindex_killed )

	-- The Killing entity
	local killer = nil

	if keys.entindex_attacker ~= nil then
		killer = EntIndexToHScript( keys.entindex_attacker )
	end

	local damagebits = keys.damagebits -- This might always be 0 and therefore useless

	-------------------------------------------------------------------------------------------------
	-- IMBA: End game on kills logic
	-------------------------------------------------------------------------------------------------

	if END_GAME_ON_KILLS then
		local radiant_kills = PlayerResource:GetTeamKills(DOTA_TEAM_GOODGUYS)
		local dire_kills = PlayerResource:GetTeamKills(DOTA_TEAM_BADGUYS)

		if radiant_kills >= KILLS_TO_END_GAME_FOR_TEAM then
			GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
		elseif dire_kills >= KILLS_TO_END_GAME_FOR_TEAM then
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Random OMG on-death skill randomization
	-------------------------------------------------------------------------------------------------

	if IMBA_ABILITY_MODE_RANDOM_OMG and IMBA_RANDOM_OMG_RANDOMIZE_SKILLS_ON_DEATH then
		if killed_unit:IsRealHero() then

			-- Randomize abilities
			ApplyAllRandomOmgAbilities(killed_unit)
			print("randoming OMG abilities for "..killed_unit:GetName())

			-- Clean-up undesired permanent modifiers
			RemovePermanentModifiersRandomOMG(killed_unit)

			-- Grant unspent skill points equal to the hero's level
			killed_unit:SetAbilityPoints( math.min(killed_unit:GetLevel(), 25) )
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Respawn timer setup
	-------------------------------------------------------------------------------------------------
	
	if killed_unit:IsRealHero() and PlayerResource:GetPlayer(killed_unit:GetPlayerID()) then
		
		-- Calculate base respawn timer, capped at 60 seconds
		local hero_level = killed_unit:GetLevel()
		local respawn_time = HERO_RESPAWN_TIME_BASE + math.min(hero_level, 25) * HERO_RESPAWN_TIME_PER_LEVEL

		-- Multiply respawn timer by the lobby options
		respawn_time = math.max( respawn_time * HERO_RESPAWN_TIME_MULTIPLIER / 100, 3)

		-- Fetch increased respawn timer due to Reaper's Scythe on this death
		if killed_unit.scythe_added_respawn then
			respawn_time = respawn_time + killed_unit.scythe_added_respawn
			killed_unit.scythe_added_respawn = 0
		end

		-- Fetch stacking increased respawn timer due to Reaper's Scythe
		if killed_unit.scythe_stacking_respawn_timer then
			respawn_time = respawn_time + killed_unit.scythe_stacking_respawn_timer
		end

		-- Fetch decreased respawn timer due to Bloodstone charges
		if killed_unit.bloodstone_respawn_reduction then
			respawn_time = math.max( respawn_time - killed_unit.bloodstone_respawn_reduction, 0)
		end

		-- Set up the respawn timer
		killed_unit:SetTimeUntilRespawn(respawn_time)

		-- If the owner has an aegis, disregard everything
		if killed_unit.has_aegis then
			killed_unit:SetTimeUntilRespawn(3)
			killed_unit:SetRespawnPosition(killed_unit:GetAbsOrigin())
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Buyback setup (part 1)
	-------------------------------------------------------------------------------------------------

	-- Check if the dying unit was a player-controlled hero
	if killed_unit:IsRealHero() and PlayerResource:GetPlayer(killed_unit:GetPlayerID()) then

		-- Check if buyback cost is currently affected by the quick-buyback cost penalty
		local buyback_cost_multiplier = 1
		if killed_unit.quick_sucession_buybacks and killed_unit.quick_sucession_buybacks > 0 then
			buyback_cost_multiplier = ( ( 100 + HERO_BUYBACK_COST_SCALING ) / 100 ) ^ killed_unit.quick_sucession_buybacks
		end

		-- Apply lobby options to buyback cost
		buyback_cost_multiplier = buyback_cost_multiplier * HERO_BUYBACK_COST_MULTIPLIER / 100

		-- Calculate regular buyback cost and 
		local hero_level = killed_unit:GetLevel()
		local game_time = GAME_TIME_ELAPSED / 60

		local buyback_cost = ( HERO_BUYBACK_BASE_COST + hero_level * HERO_BUYBACK_COST_PER_LEVEL + game_time * HERO_BUYBACK_COST_PER_MINUTE ) * buyback_cost_multiplier
		local buyback_penalty_duration = HERO_BUYBACK_RESET_TIME_PER_LEVEL * hero_level + HERO_BUYBACK_RESET_TIME_PER_MINUTE * game_time

		-- Update buyback cost and penalty duration 
		PlayerResource:SetCustomBuybackCost(killed_unit:GetPlayerID(), buyback_cost)
		PlayerResource:SetBuybackGoldLimitTime(killed_unit:GetPlayerID(), buyback_penalty_duration)
		
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Hero kill bounty calculation
	-------------------------------------------------------------------------------------------------

	-- Check if the killer is not a neutral unit
	local non_neutral_killer = false

	if killer:GetTeam() == DOTA_TEAM_GOODGUYS or killer:GetTeam() == DOTA_TEAM_BADGUYS then
		non_neutral_killer = true
	end

	-- If the killed unit owns the Aegis, do nothing
	if killed_unit.has_aegis then
		return nil
	end
	
	-- Check if killed unit is a hero, and killer/killed belong to different teams
	if killed_unit:IsRealHero() and killed_unit:GetTeam() ~= killer:GetTeam() and non_neutral_killer then

		-- Killed hero gold loss
		local killed_level = killed_unit:GetLevel()
		local killed_gold_loss = math.max( ( killed_level * HERO_DEATH_GOLD_LOSS_PER_LEVEL ) * ( 100 - HERO_DEATH_GOLD_LOSS_PER_DEATHSTREAK * killed_unit.death_streak_count) / 100, 0)
		killed_gold_loss = -1 * killed_gold_loss * ( 100 + HERO_GOLD_BONUS ) / 100
		killed_unit:ModifyGold(killed_gold_loss, false, DOTA_ModifyGold_Death)

		-- Nearby allied heroes gold gain
		local allied_heroes = FindUnitsInRadius(killer:GetTeamNumber(), killed_unit:GetAbsOrigin(), nil, HERO_ASSIST_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		local assist_gold = killed_unit:GetGoldBounty()

		-- If no allied hero was near the kill, distribute gold evenly to all of the team's heroes
		if #allied_heroes == 0 then
			assist_gold = assist_gold * 0.2
			allied_heroes = FindUnitsInRadius(killer:GetTeamNumber(), killed_unit:GetAbsOrigin(), nil, HERO_ASSIST_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_UNITS_EVERYWHERE, false)
			for _,ally in pairs(allied_heroes) do
				ally:EmitSound("General.Coins")
				SendOverheadEventMessage(PlayerResource:GetPlayer(ally:GetPlayerID()), OVERHEAD_ALERT_GOLD, ally, assist_gold, nil)
				ally:ModifyGold(assist_gold, true, DOTA_ModifyGold_HeroKill)
			end
		else
			local is_killer_present = false
			local nearby_allies = #allied_heroes

			-- Check if the killer was near the kill
			for _,ally in pairs(allied_heroes) do
				if ally == killer then
					is_killer_present = true
				end
			end
			
			-- If yes, reduce the count of nearby allies by one
			if is_killer_present then
				nearby_allies = nearby_allies - 1
			end

			-- Distribute assist gold accordingly
			if nearby_allies == 1 then
				assist_gold = assist_gold * HERO_ASSIST_BOUNTY_FACTOR_2
				for _,ally in pairs(allied_heroes) do
					if ally ~= killer then
						ally:EmitSound("General.Coins")
						SendOverheadEventMessage(PlayerResource:GetPlayer(ally:GetPlayerID()), OVERHEAD_ALERT_GOLD, ally, assist_gold, nil)
						ally:ModifyGold(assist_gold, true, DOTA_ModifyGold_HeroKill)
					end
				end
			elseif nearby_allies == 2 then
				assist_gold = assist_gold * HERO_ASSIST_BOUNTY_FACTOR_3
				for _,ally in pairs(allied_heroes) do
					if ally ~= killer then
						ally:EmitSound("General.Coins")
						SendOverheadEventMessage(PlayerResource:GetPlayer(ally:GetPlayerID()), OVERHEAD_ALERT_GOLD, ally, assist_gold, nil)
						ally:ModifyGold(assist_gold, true, DOTA_ModifyGold_HeroKill)
					end
				end
			elseif nearby_allies == 3 then
				assist_gold = assist_gold * HERO_ASSIST_BOUNTY_FACTOR_4
				for _,ally in pairs(allied_heroes) do
					if ally ~= killer then
						ally:EmitSound("General.Coins")
						SendOverheadEventMessage(PlayerResource:GetPlayer(ally:GetPlayerID()), OVERHEAD_ALERT_GOLD, ally, assist_gold, nil)
						ally:ModifyGold(assist_gold, true, DOTA_ModifyGold_HeroKill)
					end
				end
			elseif nearby_allies >= 4 then
				assist_gold = assist_gold * HERO_ASSIST_BOUNTY_FACTOR_5
				for _,ally in pairs(allied_heroes) do
					if ally ~= killer then
						ally:EmitSound("General.Coins")
						SendOverheadEventMessage(PlayerResource:GetPlayer(ally:GetPlayerID()), OVERHEAD_ALERT_GOLD, ally, assist_gold, nil)
						ally:ModifyGold(assist_gold, true, DOTA_ModifyGold_HeroKill)
					end
				end
			end
		end

		-- Reset killed hero's killstreak and update its deathstreak
		killed_unit.kill_streak_count = 0
		killed_unit.death_streak_count = killed_unit.death_streak_count + 1

		-- Update killed hero's bounty
		local killed_bounty = HERO_KILL_GOLD_BASE + killed_level * HERO_KILL_GOLD_PER_LEVEL + GetKillstreakGold(killed_unit)
		killed_bounty = math.max( killed_bounty * ( 100 + HERO_GOLD_BONUS ) / 100, 0)
		killed_unit:SetMaximumGoldBounty(killed_bounty)
		killed_unit:SetMinimumGoldBounty(killed_bounty)

		-- Check if the killer was a non-hero entity (to avoid GetPlayerID crashes)
		local nonhero_killer = false
		if killer:IsTower() or killer:IsCreep() or IsFountain(killer) then
			nonhero_killer = true
		end

		-- If the killer is player-owned, remove its deathstreak and start its killstreak
		if not nonhero_killer and killer:GetPlayerID() then
			local killer_player = PlayerResource:GetPlayer(killer:GetPlayerID())
			local killer_hero = killer_player:GetAssignedHero()
			
			-- Reset killer hero's deathstreak and update its killstreak
			killer_hero.death_streak_count = 0
			killer_hero.kill_streak_count = killer_hero.kill_streak_count + 1

			-- Update killer's bounty
			local killer_level = killer_hero:GetLevel()
			local killer_bounty = HERO_KILL_GOLD_BASE + killer_level * HERO_KILL_GOLD_PER_LEVEL + GetKillstreakGold(killer_hero)
			killer_bounty = math.max( killer_bounty * ( 100 + HERO_GOLD_BONUS ) / 100, 0)
			killer_hero:SetMaximumGoldBounty(killer_bounty)
			killer_hero:SetMinimumGoldBounty(killer_bounty)

			-- If the killer owns the Aegis, nullify its bounty
			if killer_hero.has_aegis then
				killer_hero:SetMaximumGoldBounty(0)
				killer_hero:SetMinimumGoldBounty(0)
			end
		end

		-- Killed hero deathstreak messages
		local killed_hero_name = killed_unit:GetName()
		local killed_player_name = PlayerResource:GetPlayerName(killed_unit:GetPlayerID())
		local line_duration = 7

		if killed_unit.death_streak_count >= 3 then
			Notifications:BottomToAll({hero = killed_hero_name, duration = line_duration})
			Notifications:BottomToAll({text = killed_player_name.." ", duration = line_duration, continue = true})
		end

		if killed_unit.death_streak_count == 3 then
			Notifications:BottomToAll({text = "#imba_deathstreak_3", duration = line_duration, continue = true})
		elseif killed_unit.death_streak_count == 4 then
			Notifications:BottomToAll({text = "#imba_deathstreak_4", duration = line_duration, continue = true})
		elseif killed_unit.death_streak_count == 5 then
			Notifications:BottomToAll({text = "#imba_deathstreak_5", duration = line_duration, continue = true})
		elseif killed_unit.death_streak_count == 6 then
			Notifications:BottomToAll({text = "#imba_deathstreak_6", duration = line_duration, continue = true})
		elseif killed_unit.death_streak_count == 7 then
			Notifications:BottomToAll({text = "#imba_deathstreak_7", duration = line_duration, continue = true})
		elseif killed_unit.death_streak_count == 8 then
			Notifications:BottomToAll({text = "#imba_deathstreak_8", duration = line_duration, continue = true})
		elseif killed_unit.death_streak_count == 9 then
			Notifications:BottomToAll({text = "#imba_deathstreak_9", duration = line_duration, continue = true})
		elseif killed_unit.death_streak_count >= 10 then
			Notifications:BottomToAll({text = "#imba_deathstreak_10", duration = line_duration, continue = true})
		end
	end

end

-- This function is called 1 to 2 times as the player connects initially but before they have completely connected
function GameMode:PlayerConnect(keys)
	DebugPrint('[BAREBONES] PlayerConnect')
	DebugPrintTable(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
	DebugPrint('[BAREBONES] OnConnectFull')
	DebugPrintTable(keys)

	GameMode:_OnConnectFull(keys)
	
	local entIndex = keys.index+1
	-- The Player entity of the joining user
	local ply = EntIndexToHScript(entIndex)
	
	-- The Player ID of the joining player
	local playerID = ply:GetPlayerID()
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function GameMode:OnIllusionsCreated(keys)
	DebugPrint('[BAREBONES] OnIllusionsCreated')
	DebugPrintTable(keys)

	local originalEntity = EntIndexToHScript(keys.original_entindex)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Random OMG illusion ability adjustment
	-------------------------------------------------------------------------------------------------

	if IMBA_ABILITY_MODE_RANDOM_OMG then

		-- Find all Illusions
		local illusions_on_world = Entities:FindAllByName(originalEntity:GetName())
		for k,illusion in pairs(illusions_on_world) do

			-- Check if this illusion has already been adjusted
			if illusion:IsIllusion() and not illusion.illusion_skills_adjusted then
				local player_id = illusion:GetPlayerID()
				local hero = originalEntity

				-- Remove previously existing abilities
				for i = 0, 15 do
					local old_ability = illusion:GetAbilityByIndex(i)
					if old_ability then
						illusion:RemoveAbility(old_ability:GetAbilityName())
					end
				end

				-- Add and level owner's abilities
				for i = 0, 15 do
					if hero.random_omg_abilities[i] then
						illusion:AddAbility(hero.random_omg_abilities[i])
						local ability = illusion:FindAbilityByName(hero.random_omg_abilities[i])
						local ability_level = hero:FindAbilityByName(hero.random_omg_abilities[i]):GetLevel()
						ability:SetLevel(ability_level)
					end
				end

				-- Mark this illusion as already adjusted
				illusion.illusion_skills_adjusted = true
			end
		end
	end
end

-- This function is called whenever an item is combined to create a new item
function GameMode:OnItemCombined(keys)
	DebugPrint('[BAREBONES] OnItemCombined')
	DebugPrintTable(keys)

	-- The playerID of the hero who is buying something
	local plyID = keys.PlayerID
	if not plyID then return end
	local player = PlayerResource:GetPlayer(plyID)

	-- The name of the item purchased
	local itemName = keys.itemname 
	
	-- The cost of the item purchased
	local itemcost = keys.itemcost
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function GameMode:OnAbilityCastBegins(keys)
	DebugPrint('[BAREBONES] OnAbilityCastBegins')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local abilityName = keys.abilityname
end

-- This function is called whenever a tower is killed
function GameMode:OnTowerKill(keys)
	DebugPrint('[BAREBONES] OnTowerKill')
	DebugPrintTable(keys)

	local gold = keys.gold
	local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
	local team = keys.teamnumber
end

-- This function is called whenever a player changes there custom team selection during Game Setup 
function GameMode:OnPlayerSelectedCustomTeam(keys)
	DebugPrint('[BAREBONES] OnPlayerSelectedCustomTeam')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.player_id)
	local success = (keys.success == 1)
	local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function GameMode:OnNPCGoalReached(keys)
	DebugPrint('[BAREBONES] OnNPCGoalReached')
	DebugPrintTable(keys)

	local goalEntity = EntIndexToHScript(keys.goal_entindex)
	local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
	local npc = EntIndexToHScript(keys.npc_entindex)
end