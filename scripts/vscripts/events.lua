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

		local disconnected_this_time = {}
	
		-- Update players' connection status
		for id = 0, ( IMBA_PLAYERS_ON_GAME - 1 ) do
			if self.players[id] and self.players[id].connection_state ~= PlayerResource:GetConnectionState(id) then
				self.players[id].connection_state = PlayerResource:GetConnectionState(id)
				print("player "..id.."has just disconnected, with connection state "..self.players[id].connection_state)
				if self.players[id].connection_state == 3 then
					self.players[id].is_disconnected = true
					print("set up player "..id.." as disconnected")
					disconnected_this_time[id] = true
				end
			end
		end

		-- Iterate through each recently disconnected player
		for id = 0, ( IMBA_PLAYERS_ON_GAME - 1 ) do
			if self.players[id] and self.players[id].is_disconnected and disconnected_this_time[id] then

				-- Parameters
				local team = PlayerResource:GetTeam(id)
				local hero = self.heroes[id]
				local hero_name = hero:GetName()
				local player_name = PlayerResource:GetPlayerName(id)
				local full_abandon = false
				local line_duration = 7
				local remaining_connected_players

				-- Show disconnect message
				Notifications:BottomToAll({hero = hero_name, duration = line_duration})
				Notifications:BottomToAll({text = player_name.." ", duration = line_duration, continue = true})
				Notifications:BottomToAll({text = "#imba_player_abandon_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})

				-- Radiant abandon logic
				if team == DOTA_TEAM_GOODGUYS then
					GOODGUYS_CONNECTED_PLAYERS = GOODGUYS_CONNECTED_PLAYERS - 1
					remaining_connected_players = GOODGUYS_CONNECTED_PLAYERS
					print(hero_name.." has disconnected, only "..remaining_connected_players.." players remaining on Radiant")

				-- Dire abandon logic
				elseif team == DOTA_TEAM_BADGUYS then
					BADGUYS_CONNECTED_PLAYERS = BADGUYS_CONNECTED_PLAYERS - 1
					remaining_connected_players = BADGUYS_CONNECTED_PLAYERS
					print(hero_name.." has disconnected, only "..remaining_connected_players.." players remaining on Dire")
				end
			end
		end

		-- Full radiant team has abandoned
		if GOODGUYS_CONNECTED_PLAYERS == 0 then
			full_abandon = true

			-- Display message to the other team
			Notifications:BottomToAll({text = "#imba_team_good_abandon_message", duration = line_duration, style = {color = "DodgerBlue"} })

			-- End the game in 15 seconds if no one reconnects
			--Timers:CreateTimer(FULL_ABANDON_TIME, function()
				if GOODGUYS_CONNECTED_PLAYERS == 0 then
					GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
				end
			--end)
		end

		-- Full dire team has abandoned
		if BADGUYS_CONNECTED_PLAYERS == 0 then
			full_abandon = true

			-- Display message to the other team
			Notifications:BottomToAll({text = "#imba_team_bad_abandon_message", duration = line_duration, style = {color = "DodgerBlue"} })

			-- End the game in 15 seconds if no one reconnects
			--Timers:CreateTimer(FULL_ABANDON_TIME, function()
				if BADGUYS_CONNECTED_PLAYERS == 0 then
					GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
				end
			--end)
		end
	end)
end

-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
	DebugPrint("[BAREBONES] GameRules State Changed")
	DebugPrintTable(keys)

	-- This internal handling is used to set up main barebones functions
	GameMode:_OnGameRulesStateChange(keys)

	local new_state = GameRules:State_Get()

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player-based stat collection
	-------------------------------------------------------------------------------------------------

	--if new_state == DOTA_GAMERULES_STATE_POST_GAME then
		
	--end
end

-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
	DebugPrint("[BAREBONES] NPC Spawned")
	DebugPrintTable(keys)

	-- This internal handling is used to set up main barebones functions
	GameMode:_OnNPCSpawned(keys)

	local npc = EntIndexToHScript(keys.entindex)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Random OMG on-respawn skill randomization
	-------------------------------------------------------------------------------------------------

	if IMBA_ABILITY_MODE_RANDOM_OMG and IMBA_RANDOM_OMG_RANDOMIZE_SKILLS_ON_DEATH then
		if npc:IsRealHero() then
			
			-- Randomize abilities
			ApplyAllRandomOmgAbilities(npc)

			-- Clean-up undesired permanent modifiers
			RemovePermanentModifiersRandomOMG(npc)

			-- Grant unspent skill points equal to the hero's level
			npc:SetAbilityPoints( math.min(npc:GetLevel(), 25) )
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: War Veteran stack updater
	-------------------------------------------------------------------------------------------------
	
	-- Attempt to find War Veteran ability 
	local ability_powerup = npc:FindAbilityByName("imba_unlimited_level_powerup")

	if ability_powerup then

		-- Fetch hero level and current amount of stacks
		local correct_amount = math.max( npc:GetLevel() - 25, 0)
		local power_stacks = npc:GetModifierStackCount("modifier_imba_unlimited_level_powerup", ability_powerup)

		-- If the number of stacks is not correct, fix it
		if power_stacks < correct_amount then
			AddStacks(ability_powerup, npc, npc, "modifier_imba_unlimited_level_powerup", ( correct_amount - power_stacks ), true)
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Remote Mines adjustment
	-------------------------------------------------------------------------------------------------

	Timers:CreateTimer(1.5, function()
		if npc:HasModifier("modifier_techies_remote_mine") then

			-- Add extra abilities
			npc:AddAbility("imba_techies_minefield_teleport")
			npc:AddAbility("imba_techies_remote_auto_creep")
			npc:AddAbility("imba_techies_remote_auto_hero")
			local minefield_teleport = npc:FindAbilityByName("imba_techies_minefield_teleport")
			local auto_creep = npc:FindAbilityByName("imba_techies_remote_auto_creep")
			local auto_hero = npc:FindAbilityByName("imba_techies_remote_auto_hero")
			auto_creep:SetLevel(1)
			auto_hero:SetLevel(1)

			-- Enable minefield teleport if the caster has a scepter
			local scepter = HasScepter(npc:GetOwnerEntity())
			if scepter then
				minefield_teleport:SetLevel(1)
			end
		end
	end)

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
	-- IMBA: Negative Vengeance Aura removal
	-------------------------------------------------------------------------------------------------
	if npc.vengeance_aura_target then
		npc.vengeance_aura_target:RemoveModifierByName("modifier_imba_command_aura_negative_aura")
		npc.vengeance_aura_target = nil
	end

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

	-- Connection status detection delay
	Timers:CreateTimer(1, function()

		-- Attempt to detect players who were ignored on the initial load
		for id = 0, ( IMBA_PLAYERS_ON_GAME - 1 ) do
			if not self.players[id] then
				print("attempting to fetch connection status for player"..id)
				self.players[id] = PlayerResource:GetPlayer(id)
				
				if self.players[id] then

					-- Initialize connection state
					self.players[id].connection_state = PlayerResource:GetConnectionState(id)
					print("initialized connection for player "..id..": "..self.players[id].connection_state)

					-- Assign appropriate player color
					if IMBA_PLAYERS_ON_GAME == 10 and id > 4 then
						PlayerResource:SetCustomPlayerColor(id+5, PLAYER_COLORS[id+5][1], PLAYER_COLORS[id+5][2], PLAYER_COLORS[id+5][3])
					else
						PlayerResource:SetCustomPlayerColor(id, PLAYER_COLORS[id][1], PLAYER_COLORS[id][2], PLAYER_COLORS[id][3])
					end

					-- Increment amount of players on this team by one
					if PlayerResource:GetTeam(id) == DOTA_TEAM_GOODGUYS then
						GOODGUYS_CONNECTED_PLAYERS = GOODGUYS_CONNECTED_PLAYERS + 1
						print("goodguys team now has "..GOODGUYS_CONNECTED_PLAYERS.." players")
					elseif PlayerResource:GetTeam(id) == DOTA_TEAM_BADGUYS then
						BADGUYS_CONNECTED_PLAYERS = BADGUYS_CONNECTED_PLAYERS + 1
						print("badguys team now has "..BADGUYS_CONNECTED_PLAYERS.." players")
					end
				end
			end
		end

		local reconnected_this_time = {}

		-- Update players' connection status
		for id = 0, ( IMBA_PLAYERS_ON_GAME - 1 ) do
			if self.players[id] and self.players[id].connection_state ~= PlayerResource:GetConnectionState(id) then
				self.players[id].connection_state = PlayerResource:GetConnectionState(id)
				print("player "..id.."has just reconnected, with connection state "..self.players[id].connection_state)
				if self.players[id].connection_state == 2 then
					self.players[id].is_disconnected = nil
					print("set up player "..id.." as reconnected")
					reconnected_this_time[id] = true
				end
			end
		end

		-- Iterate through each recently reconnected player
		for id = 0, ( IMBA_PLAYERS_ON_GAME - 1 ) do
			if self.players[id] and not self.players[id].is_disconnected and reconnected_this_time[id] then

				-- Parameters
				local player = PlayerResource:GetPlayer(id)
				local player_name = PlayerResource:GetPlayerName(id)
				local team = PlayerResource:GetTeam(id)
				local hero = player:GetAssignedHero()
				local hero_name = hero:GetName()

				-- Show reconnection message to remaining players
				local line_duration = 5

				Notifications:BottomToAll({hero = hero_name, duration = line_duration})
				Notifications:BottomToAll({text = player_name.." ", duration = line_duration, continue = true})
				Notifications:BottomToAll({text = "#imba_player_reconnect_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})

				-- Update team connection status
				if team == DOTA_TEAM_GOODGUYS then
					GOODGUYS_CONNECTED_PLAYERS = GOODGUYS_CONNECTED_PLAYERS + 1
					print(hero_name.." has reconnected, "..GOODGUYS_CONNECTED_PLAYERS.." players remaining on Radiant")
				elseif team == DOTA_TEAM_BADGUYS then
					BADGUYS_CONNECTED_PLAYERS = BADGUYS_CONNECTED_PLAYERS + 1
					print(hero_name.." has reconnected, "..BADGUYS_CONNECTED_PLAYERS.." players remaining on Dire")
				end
			end
		end
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

	-- The Unit that was killed
	local killed_unit = EntIndexToHScript( keys.entindex_killed )

	-- The Killing entity
	local killer = nil

	if keys.entindex_attacker ~= nil then
		killer = EntIndexToHScript( keys.entindex_attacker )
	end

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
	-- IMBA: Suicide Squad, Attack! Mines
	-------------------------------------------------------------------------------------------------

	-- Check if suicide is leveled
	local ability_suicide = killed_unit:FindAbilityByName("techies_suicide")
	if ability_suicide and ability_suicide:GetLevel() > 0 then

		-- Aghanim's Scepter doubles the number of mines dropped
		local scepter = HasScepter(killed_unit)
			
		-- Land mines
		local ability_land_mine = killed_unit:FindAbilityByName("imba_techies_land_mines")
		if ability_land_mine and ability_land_mine:GetLevel() > 0 then
			local caster = killed_unit				
			local ability_level = ability_land_mine:GetLevel() - 1
			local modifier_state = "modifier_imba_land_mines_state"
			
			-- Parameters
			local activation_time = ability_land_mine:GetLevelSpecialValueFor("activation_time", ability_level)
			local player_id = caster:GetPlayerID()

			-- Create the mines at the specified place
			local land_mine_1 = CreateUnitByName("npc_imba_techies_land_mine", caster:GetAbsOrigin() + RandomVector(100), false, caster, caster, caster:GetTeam())
			local land_mine_2 = CreateUnitByName("npc_imba_techies_land_mine", caster:GetAbsOrigin() + RandomVector(100), false, caster, caster, caster:GetTeam())
			land_mine_1:SetControllableByPlayer(player_id, true)
			land_mine_2:SetControllableByPlayer(player_id, true)

			-- Root the mines in place
			land_mine_1:AddNewModifier(land_mine, ability_land_mine, "modifier_rooted", {})
			land_mine_2:AddNewModifier(land_mine, ability_land_mine, "modifier_rooted", {})

			-- Make the mines have no unit collision or health bar
			ability_land_mine:ApplyDataDrivenModifier(caster, land_mine_1, modifier_state, {})
			ability_land_mine:ApplyDataDrivenModifier(caster, land_mine_2, modifier_state, {})

			-- Create two more mines if the owner has Aghanim's Scepter
			local land_mine_3
			local land_mine_4
			if scepter then
				land_mine_3 = CreateUnitByName("npc_imba_techies_land_mine", caster:GetAbsOrigin() + RandomVector(100), false, caster, caster, caster:GetTeam())
				land_mine_4 = CreateUnitByName("npc_imba_techies_land_mine", caster:GetAbsOrigin() + RandomVector(100), false, caster, caster, caster:GetTeam())
				land_mine_3:SetControllableByPlayer(player_id, true)
				land_mine_4:SetControllableByPlayer(player_id, true)
				land_mine_3:AddNewModifier(land_mine_3, ability_land_mine, "modifier_rooted", {})
				land_mine_4:AddNewModifier(land_mine_4, ability_land_mine, "modifier_rooted", {})
				ability_land_mine:ApplyDataDrivenModifier(caster, land_mine_3, modifier_state, {})
				ability_land_mine:ApplyDataDrivenModifier(caster, land_mine_4, modifier_state, {})
			end

			-- Wait for the activation delay
			Timers:CreateTimer(activation_time, function()
				
				-- Grant the mines the appropriately leveled abilities
				local mine_passive_1 = land_mine_1:FindAbilityByName("imba_techies_land_mine_passive")
				local mine_passive_2 = land_mine_2:FindAbilityByName("imba_techies_land_mine_passive")
				mine_passive_1:SetLevel(ability_level + 1)
				mine_passive_2:SetLevel(ability_level + 1)

				-- Grant the second mine the appropriately leveled abilities if appropriate
				if scepter then
					mine_passive_1 = land_mine_3:FindAbilityByName("imba_techies_land_mine_passive")
					mine_passive_2 = land_mine_4:FindAbilityByName("imba_techies_land_mine_passive")
					mine_passive_1:SetLevel(ability_level + 1)
					mine_passive_2:SetLevel(ability_level + 1)
					local mine_teleport = land_mine_1:FindAbilityByName("imba_techies_minefield_teleport")
					mine_teleport:SetLevel(1)
					mine_teleport = land_mine_2:FindAbilityByName("imba_techies_minefield_teleport")
					mine_teleport:SetLevel(1)
					mine_teleport = land_mine_3:FindAbilityByName("imba_techies_minefield_teleport")
					mine_teleport:SetLevel(1)
					mine_teleport = land_mine_4:FindAbilityByName("imba_techies_minefield_teleport")
					mine_teleport:SetLevel(1)
				end
			end)
		end

		-- Stasis Trap
		local ability_stasis_trap = killed_unit:FindAbilityByName("imba_techies_stasis_trap")
		if ability_stasis_trap and ability_stasis_trap:GetLevel() > 0 then

			local caster = killed_unit
			local ability_level = ability_stasis_trap:GetLevel() - 1
			
			-- Parameters
			local activation_delay = ability_stasis_trap:GetLevelSpecialValueFor("activation_delay", ability_level)
			local player_id = caster:GetPlayerID()
			local trap_loc_1 = caster:GetAbsOrigin() + RandomVector(100)
			local trap_loc_2 = caster:GetAbsOrigin() + RandomVector(100)

			-- Play the spawn animation
			local trap_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_stasis_trap_plant.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(trap_pfx, 0, trap_loc_1)
			ParticleManager:SetParticleControl(trap_pfx, 1, trap_loc_1)

			-- Play the spawn animation for the scepter extra mine, if appropriate
			if scepter then
				local trap_pfx_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_stasis_trap_plant.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(trap_pfx_2, 0, trap_loc_2)
				ParticleManager:SetParticleControl(trap_pfx_2, 1, trap_loc_2)
			end

			-- Wait for the activation delay
			Timers:CreateTimer(activation_delay, function()

				-- Create the mine at the specified place
				local stasis_trap = CreateUnitByName("npc_imba_techies_stasis_trap", trap_loc_1, false, caster, caster, caster:GetTeam())
				stasis_trap:SetControllableByPlayer(player_id, true)

				-- Root the mine in place
				stasis_trap:AddNewModifier(stasis_trap, ability_stasis_trap, "modifier_rooted", {})

				-- Make the mine have no unit collision or health bar
				ability_stasis_trap:ApplyDataDrivenModifier(caster, stasis_trap, "modifier_imba_stasis_trap_state", {})
					
				-- Grant the mine the appropriately leveled abilities
				local trap_passive = stasis_trap:FindAbilityByName("imba_techies_stasis_trap_passive")
				trap_passive:SetLevel(ability_level + 1)

				-- Create a second mine if the owner has Aghanim's Scepter
				local stasis_trap_2
				if scepter then
					stasis_trap_2 = CreateUnitByName("npc_imba_techies_stasis_trap", trap_loc_2, false, caster, caster, caster:GetTeam())
					stasis_trap_2:SetControllableByPlayer(player_id, true)
					stasis_trap_2:AddNewModifier(stasis_trap, ability_stasis_trap, "modifier_rooted", {})
					ability_stasis_trap:ApplyDataDrivenModifier(caster, stasis_trap_2, "modifier_imba_stasis_trap_state", {})
					local trap_passive = stasis_trap_2:FindAbilityByName("imba_techies_stasis_trap_passive")
					trap_passive:SetLevel(ability_level + 1)
					local trap_teleport = stasis_trap:FindAbilityByName("imba_techies_minefield_teleport")
					trap_teleport:SetLevel(1)
					local trap_teleport = stasis_trap_2:FindAbilityByName("imba_techies_minefield_teleport")
					trap_teleport:SetLevel(1)
				end
			end)
		end

		-- Remote Mine
		local ability_remote_mine = killed_unit:FindAbilityByName("techies_remote_mines")
		if ability_remote_mine and ability_remote_mine:GetLevel() > 0 then

			-- Create mine
			local remote_mine = CreateUnitByName("npc_dota_techies_remote_mine", killed_unit:GetAbsOrigin() + RandomVector(100), false, killed_unit, killed_unit, killed_unit:GetTeam())
			remote_mine:SetControllableByPlayer(killed_unit:GetPlayerID(), true)
			remote_mine:AddNewModifier(killed_unit, ability_remote_mine, "modifier_kill", {duration = 6000})
			remote_mine:AddNewModifier(killed_unit, ability_remote_mine, "modifier_techies_remote_mine", {})

			-- Adjust abilities
			local remote_self_detonate = remote_mine:FindAbilityByName("techies_remote_mines_self_detonate")
			remote_self_detonate:SetLevel(ability_remote_mine:GetLevel())

			-- Second mine (scepter)
			if scepter then
				local remote_mine_2 = CreateUnitByName("npc_dota_techies_remote_mine", killed_unit:GetAbsOrigin() + RandomVector(100), false, killed_unit, killed_unit, killed_unit:GetTeam())
				remote_mine_2:SetControllableByPlayer(killed_unit:GetPlayerID(), true)
				remote_mine_2:AddNewModifier(killed_unit, ability_remote_mine, "modifier_kill", {duration = 6000})
				remote_mine_2:AddNewModifier(killed_unit, ability_remote_mine, "modifier_techies_remote_mine", {})

				-- Adjust abilities
				remote_self_detonate = remote_mine_2:FindAbilityByName("techies_remote_mines_self_detonate")
				remote_self_detonate:SetLevel(ability_remote_mine:GetLevel())
			end
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

		-- Decrease respawn timer due to Techies' Suicide Squad, Attack!
		if killed_unit:HasModifier("modifier_techies_suicide_respawn_time") then
			killed_unit:RemoveModifierByName("modifier_techies_suicide_respawn_time")
			respawn_time = math.max( respawn_time * 0.5)
		end

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

		-- Killed hero Rancor clean-up
		if killed_unit:HasModifier("modifier_imba_rancor") then
			local current_stacks = killed_unit:GetModifierStackCount("modifier_imba_rancor", VENGEFUL_RANCOR_CASTER)
			if current_stacks <= 4 then
				killed_unit:RemoveModifierByName("modifier_imba_rancor")
			else
				killed_unit:SetModifierStackCount("modifier_imba_rancor", VENGEFUL_RANCOR_CASTER, current_stacks - math.floor(current_stacks / 2) - 2)
			end
		end

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

			-- Vengeful Spirit Rancor logic
			if VENGEFUL_RANCOR and killer:GetTeam() ~= VENGEFUL_RANCOR_TEAM then
				local eligible_rancor_targets = FindUnitsInRadius(killed_unit:GetTeamNumber(), killed_unit:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
				if eligible_rancor_targets[1] then
					local rancor_stacks = 1

					-- Double stacks if the killed unit was Venge
					if killed_unit == VENGEFUL_RANCOR_CASTER then
						rancor_stacks = rancor_stacks * 2
					end

					-- Double stacks if Venge has a scepter
					if VENGEFUL_RANCOR_SCEPTER then
						rancor_stacks = rancor_stacks * 2
					end

					-- Add stacks and play particle effect
					AddStacks(VENGEFUL_RANCOR_ABILITY, VENGEFUL_RANCOR_CASTER, eligible_rancor_targets[1], "modifier_imba_rancor", rancor_stacks, true)
					local rancor_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_negative_aura.vpcf", PATTACH_ABSORIGIN, eligible_rancor_targets[1])
					ParticleManager:SetParticleControl(rancor_pfx, 0, eligible_rancor_targets[1]:GetAbsOrigin())
					ParticleManager:SetParticleControl(rancor_pfx, 1, VENGEFUL_RANCOR_CASTER:GetAbsOrigin())
				end
			end
		end

		-- If the killer was a player-owned summon, make its owner the killer
		if IsPlayerOwnedSummon(killer) then
			killer = killer:GetOwnerEntity()
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

			-- Killer Rancor logic
			if VENGEFUL_RANCOR and killer_hero:GetTeam() ~= VENGEFUL_RANCOR_TEAM then
				local rancor_stacks = 1

				-- Double stacks if the killed unit was Venge
				if killed_unit == VENGEFUL_RANCOR_CASTER then
					rancor_stacks = rancor_stacks * 2
				end

				-- Double stacks if Venge has a scepter
				if VENGEFUL_RANCOR_SCEPTER then
					rancor_stacks = rancor_stacks * 2
				end

				-- Add stacks and play particle effect
				AddStacks(VENGEFUL_RANCOR_ABILITY, VENGEFUL_RANCOR_CASTER, killer_hero, "modifier_imba_rancor", rancor_stacks, true)
				local rancor_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_negative_aura.vpcf", PATTACH_ABSORIGIN, killer_hero)
				ParticleManager:SetParticleControl(rancor_pfx, 0, killer_hero:GetAbsOrigin())
				ParticleManager:SetParticleControl(rancor_pfx, 1, VENGEFUL_RANCOR_CASTER:GetAbsOrigin())
			end

			-- Vengeance Aura logic
			local vengeance_aura_ability = killed_unit:FindAbilityByName("imba_vengeful_command_aura")
			if vengeance_aura_ability and vengeance_aura_ability:GetLevel() > 0 then
				vengeance_aura_ability:ApplyDataDrivenModifier(killed_unit, killer_hero, "modifier_imba_command_aura_negative_aura", {})
				killed_unit.vengeance_aura_target = killer_hero
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

		-- Global comeback gold calculation
		local all_heroes = HeroList:GetAllHeroes()
		local killer_team_networth = 0
		local killed_team_networth = 0

		for id = 0,( IMBA_PLAYERS_ON_GAME - 1 ) do
			if self.players[id] and not self.players[id].is_disconnected then
				local hero_networth = PlayerResource:GetGold(id) + PlayerResource:GetGoldSpentOnItems(id)
				local hero = PlayerResource:GetPlayer(id):GetAssignedHero()
				if hero:GetTeam() == killer:GetTeam() then
					killer_team_networth = killer_team_networth + hero_networth
				else
					killed_team_networth = killed_team_networth + hero_networth
				end
			end
		end

		if killer_team_networth < killed_team_networth then
			local networth_difference = math.max( killed_team_networth - killer_team_networth, 0)
			local welfare_gold = networth_difference * ( HERO_GLOBAL_BOUNTY_FACTOR / 100 ) / PlayerResource:GetPlayerCountForTeam(killer:GetTeam())
			for id = 0,( IMBA_PLAYERS_ON_GAME - 1 ) do
				if self.players[id] and not self.players[id].is_disconnected then
					local hero = PlayerResource:GetPlayer(id):GetAssignedHero()
					if hero:GetTeam() == killer:GetTeam() then
						hero:ModifyGold(welfare_gold, true, DOTA_ModifyGold_HeroKill)
						SendOverheadEventMessage(PlayerResource:GetPlayer(id), OVERHEAD_ALERT_GOLD, hero, welfare_gold, nil)
					end
				end
			end
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
	local tower_team = keys.teamnumber

	-------------------------------------------------------------------------------------------------
	-- IMBA: Attack of the Ancients tower upgrade logic
	-------------------------------------------------------------------------------------------------

	if TOWER_UPGRADE_MODE then
		-- Find all radiant towers on the map
		local towers = FindUnitsInRadius(tower_team, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

		-- Upgrade each tower
		for _, tower in pairs(towers) do
			if tower.tower_tier then
				UpgradeTower(tower)
			end
		end

		-- Display upgrade message and play ominous sound
		if tower_team == DOTA_TEAM_GOODGUYS then
			Notifications:BottomToAll({text = "#tower_abilities_radiant_upgrade", duration = 7, style = {color = "DodgerBlue"}})
			EmitGlobalSound("powerup_01")
		else
			Notifications:BottomToAll({text = "#tower_abilities_dire_upgrade", duration = 7, style = {color = "DodgerBlue"}})
			EmitGlobalSound("powerup_02")
		end
	end
	
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