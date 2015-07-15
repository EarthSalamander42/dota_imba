-- This file contains all barebones-registered events and has already set up the passed-in parameters for your use.
-- Do not remove the GameMode:_Function calls in these events as it will mess with the internal barebones systems.

-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
	DebugPrint('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
	DebugPrintTable(keys)

	local name = keys.name
	local networkid = keys.networkid
	local reason = keys.reason
	local userid = keys.userid

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
	-- IMBA: Reaper's Scythe buyback clean-up
	-------------------------------------------------------------------------------------------------
	if npc:IsRealHero() then
		npc:SetBuyBackDisabledByReapersScythe(false)
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Buyback setup (part 2)
	-------------------------------------------------------------------------------------------------

	-- Check if the spawned unit has the buyback penalty modifier
	Timers:CreateTimer(0.1, function()
		if npc:HasModifier("modifier_buyback_gold_penalty") then

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
	-- IMBA: Generic creep bounty adjustment
	-------------------------------------------------------------------------------------------------
	if not npc:IsHero() and not npc:IsOwnedByAnyPlayer() then
		local gold_bounty = npc:GetGoldBounty()
		local xp_bounty = npc:GetDeathXP()

		npc:SetDeathXP( math.floor( xp_bounty * ( 1 + BOUNTY_BONUS / 100 ) ) )
		npc:SetMaximumGoldBounty( math.floor( gold_bounty * ( 1.1 + BOUNTY_BONUS / 100 ) ) )
		npc:SetMinimumGoldBounty( math.floor( gold_bounty * ( 0.9 + BOUNTY_BONUS / 100 ) ) )
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

	local hero = player:GetAssignedHero()
	local hero_bounty = hero:GetGoldBounty()

	print(hero:GetUnitName().."'s new bounty: "..hero:GetGoldBounty())
	--hero:SetMaximumGoldBounty( hero_bounty + HERO_KILL_GOLD_PER_LEVEL )
	--hero:SetMinimumGoldBounty( hero_bounty + HERO_KILL_GOLD_PER_LEVEL )
	--print("Set up "..hero:GetUnitName().."'s bounty: "..hero:GetGoldBounty())
	--print("Should be: "..(HERO_KILL_GOLD_BASE + HERO_KILL_GOLD_PER_LEVEL * hero:GetLevel()))
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
	-- IMBA: Respawn timer setup
	-------------------------------------------------------------------------------------------------
	
	if killed_unit:IsRealHero() and PlayerResource:GetPlayer(killed_unit:GetPlayerID()) then
		
		-- Calculate base respawn timer
		local hero_level = killed_unit:GetLevel()
		local respawn_time = HERO_RESPAWN_TIME_BASE + hero_level * HERO_RESPAWN_TIME_PER_LEVEL

		-- Multiply respawn timer by the lobby options
		respawn_time = respawn_time * HERO_RESPAWN_TIME_MULTIPLIER / 100

		-- Fetch increased respawn timer due to Reaper's Scythe on this death
		if killed_unit.scythe_added_respawn then
			respawn_time = respawn_time + killed_unit.scythe_added_respawn
			killed_unit.scythe_added_respawn = 0
		end

		-- Fetch stacking increased respawn timer due to Reaper's Scythe
		if killed_unit.scythe_stacking_respawn_timer then
			respawn_time = respawn_time + killed_unit.scythe_stacking_respawn_timer
		end

		-- Set up the respawn timer
		killed_unit:SetTimeUntilRespawn(respawn_time)
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
		local game_time = GameRules:GetGameTime() / 60

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

	-- Check if killed unit is a hero, and killer/killed belong to different teams
	if killed_unit:IsRealHero() and killed_unit:GetTeam() ~= killer:GetTeam() and non_neutral_killer then

		print(killed_unit:GetName().." died, granting bounty of: "..killed_unit:GetGoldBounty())
		-- Update streak bounties and display streak messages
		--if killed_unit.kill_streak then
		--	killed_unit:SetMaximumGoldBounty( HERO_KILL_GOLD_BASE + killed_unit:GetLevel() * HERO_KILL_GOLD_PER_LEVEL )
		--	killed_unit:SetMinimumGoldBounty( HERO_KILL_GOLD_BASE + killed_unit:GetLevel() * HERO_KILL_GOLD_PER_LEVEL )
		--elseif killed_unit.death_streak then
		--	killed_unit:SetMaximumGoldBounty( math.max( killed_unit:GetGoldBounty() - HERO_KILL_GOLD_PER_DEATHSTREAK, 0) )
		--	killed_unit:SetMinimumGoldBounty( math.max( killed_unit:GetGoldBounty() - HERO_KILL_GOLD_PER_DEATHSTREAK, 0) )

			
		--	local killed_hero_name = "#"..killed_unit:GetName()
		--	if killed_unit.death_streak_count == 3 then
		--		GameRules:SendCustomMessage(killed_hero_name.." is on a <font color='#00FF40'><b>DYING SPREE</b></font>", 0, 0)
		--	elseif killed_unit.death_streak_count == 4 then
		--		GameRules:SendCustomMessage(killed_hero_name.." is being <font color='#5E00BD'><b>DOMINATED</b></font>", 0, 0)
		--	elseif killed_unit.death_streak_count == 5 then
		--		GameRules:SendCustomMessage(killed_hero_name.." is on a <font color='#FF0080'><b>MEGA DEATH</b></font> streak", 0, 0)
		--	elseif killed_unit.death_streak_count == 6 then
		--		GameRules:SendCustomMessage(killed_hero_name.." is <font color='#FF8000'><b>HOPELESS</b></font>", 0, 0)
		--	elseif killed_unit.death_streak_count == 7 then
		--		GameRules:SendCustomMessage(killed_hero_name.." is on a <font color='#808000'><b>WICKED FEEDING</b></font> streak", 0, 0)
		--	elseif killed_unit.death_streak_count == 8 then
		--		GameRules:SendCustomMessage(killed_hero_name.." is on a <font color='#FF80FF'><b>MONSTER FEED</b></font> streak", 0, 0)
		--	elseif killed_unit.death_streak_count == 9 then
		--		GameRules:SendCustomMessage(killed_hero_name.." is <font color='#FF0000'><b>GHOSTLIKE</b></font>", 0, 0)
		--	elseif killed_unit.death_streak_count >= 10 then
		--		GameRules:SendCustomMessage(killed_hero_name.." is beyond <font color='#FF8000'><b>GHOSTLIKE</b></font>, someone FEED them!!", 0, 0)
		--	end
		--end

		--if killer.kill_streak then
		--	killer:SetMaximumGoldBounty( killer:GetGoldBounty() + HERO_KILL_GOLD_PER_KILLSTREAK )
		--	killer:SetMinimumGoldBounty( killer:GetGoldBounty() + HERO_KILL_GOLD_PER_KILLSTREAK )
		--elseif killer.death_streak then
		--	killer:SetMaximumGoldBounty( HERO_KILL_GOLD_BASE + killer:GetLevel() * HERO_KILL_GOLD_PER_LEVEL )
		--	killer:SetMinimumGoldBounty( HERO_KILL_GOLD_BASE + killer:GetLevel() * HERO_KILL_GOLD_PER_LEVEL )
		--end
			

		-- Update the killer's kill and death streaks
		--if killer:IsRealHero() then
		--	killer.death_streak = false
		--	killer.death_streak_count = 0
		--	killer.kill_streak_count = killer.kill_streak_count + 1
		--	if killer.kill_streak_count >= 2 then
		--		killer.kill_streak = true
		--	end
		--end

		-- Update the killed hero's kill and death streaks
		--if killed_unit:IsRealHero() then
		--	killed_unit.kill_streak = false
		--	killed_unit.kill_streak_count = 0
		--	killed_unit.death_streak_count = killed_unit.death_streak_count + 1
		--	if killed_unit.death_streak_count >= 2 then
		--		killed_unit.death_streak = true
		--	end
		--end
	end

end

-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
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