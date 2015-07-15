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
		local max_bounty = npc:GetMaximumGoldBounty()
		local min_bounty = npc:GetMinimumGoldBounty()
		local xp_bounty = npc:GetDeathXP()

		npc:SetDeathXP( math.floor( xp_bounty * ( 1 + CREEP_BOUNTY_BONUS / 100 ) ) )
		npc:SetMaximumGoldBounty( math.floor( max_bounty * ( 1 + CREEP_BOUNTY_BONUS / 100 ) ) )
		npc:SetMinimumGoldBounty( math.floor( min_bounty * ( 1 + CREEP_BOUNTY_BONUS / 100 ) ) )
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

	-- Calculate new base bounty
	local hero = player:GetAssignedHero()
	local hero_level = hero:GetLevel()
	local hero_bounty = HERO_KILL_GOLD_BASE + hero_level * HERO_KILL_GOLD_PER_LEVEL + GetKillstreakGold(hero)

	-- Adjust bounty with the game options multiplier
	hero_bounty = math.max( hero_bounty * ( 100 + HERO_BOUNTY_BONUS ) / 100, 0)
	hero:SetMaximumGoldBounty(hero_bounty)
	hero:SetMinimumGoldBounty(hero_bounty)

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
		if PlayerResource:IsHeroSelected(hero_name) then
			local all_heroes = HeroList:GetAllHeroes()
			for _,picked_hero in pairs(all_heroes) do
				if hero_name == picked_hero:GetName() and team == picked_hero:GetTeam() then
					--player:MakeRandomHeroSelection()
				end
			end
		end
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

		-- Fetch decreased respawn timer due to Bloodstone charges
		if killed_unit.bloodstone_respawn_reduction then
			respawn_time = math.max( respawn_time - killed_unit.bloodstone_respawn_reduction, 0)
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

		-- Killed hero gold loss
		local killed_level = killed_unit:GetLevel()
		local killed_gold_loss = math.max( ( killed_level * HERO_DEATH_GOLD_LOSS_PER_LEVEL ) * ( 100 - HERO_DEATH_GOLD_LOSS_PER_DEATHSTREAK * killed_unit.death_streak_count) / 100, 0)
		killed_gold_loss = -1 * killed_gold_loss * ( 100 + HERO_BOUNTY_BONUS ) / 100
		killed_unit:ModifyGold(killed_gold_loss, false, DOTA_ModifyGold_Death)

		-- Nearby allied heroes gold gain
		local allied_heroes = FindUnitsInRadius(killer:GetTeamNumber(), killed_unit:GetAbsOrigin(), nil, HERO_ASSIST_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		local assist_gold = killed_unit:GetGoldBounty()
		print("Initial assist bounty: "..assist_gold)

		-- If no allied hero was near the kill, distribute gold evenly to all of the team's heroes
		if #allied_heroes == 0 then
			assist_gold = assist_gold * 0.2
			allied_heroes = FindUnitsInRadius(killer:GetTeamNumber(), killed_unit:GetAbsOrigin(), nil, HERO_ASSIST_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_UNITS_EVERYWHERE, false)
			for _,ally in pairs(allied_heroes) do
				ally:EmitSound("General.Coins")
				SendOverheadEventMessage(PlayerResource:GetPlayer(ally:GetPlayerID()), OVERHEAD_ALERT_GOLD, ally, assist_gold, nil)
				ally:ModifyGold(assist_gold, true, DOTA_ModifyGold_HeroKill)
			end
			print("Granted bounty to all allied heroes: "..assist_gold)
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
				print("Assist bounty for 1 nearby hero: "..assist_gold)
			elseif nearby_allies == 2 then
				assist_gold = assist_gold * HERO_ASSIST_BOUNTY_FACTOR_3
				for _,ally in pairs(allied_heroes) do
					if ally ~= killer then
						ally:EmitSound("General.Coins")
						SendOverheadEventMessage(PlayerResource:GetPlayer(ally:GetPlayerID()), OVERHEAD_ALERT_GOLD, ally, assist_gold, nil)
						ally:ModifyGold(assist_gold, true, DOTA_ModifyGold_HeroKill)
					end
				end
				print("Assist bounty for 2 nearby heroes: "..assist_gold)
			elseif nearby_allies == 3 then
				assist_gold = assist_gold * HERO_ASSIST_BOUNTY_FACTOR_4
				for _,ally in pairs(allied_heroes) do
					if ally ~= killer then
						ally:EmitSound("General.Coins")
						SendOverheadEventMessage(PlayerResource:GetPlayer(ally:GetPlayerID()), OVERHEAD_ALERT_GOLD, ally, assist_gold, nil)
						ally:ModifyGold(assist_gold, true, DOTA_ModifyGold_HeroKill)
					end
				end
				print("Assist bounty for 3 nearby heres: "..assist_gold)
			elseif nearby_allies >= 4 then
				assist_gold = assist_gold * HERO_ASSIST_BOUNTY_FACTOR_5
				for _,ally in pairs(allied_heroes) do
					if ally ~= killer then
						ally:EmitSound("General.Coins")
						SendOverheadEventMessage(PlayerResource:GetPlayer(ally:GetPlayerID()), OVERHEAD_ALERT_GOLD, ally, assist_gold, nil)
						ally:ModifyGold(assist_gold, true, DOTA_ModifyGold_HeroKill)
					end
				end
				print("Assist bounty for 4 nearby heres: "..assist_gold)
			end
		end

		-- Reset killed hero's killstreak and update its deathstreak
		killed_unit.kill_streak_count = 0
		killed_unit.death_streak_count = killed_unit.death_streak_count + 1

		-- Update killed hero's bounty
		local killed_bounty = HERO_KILL_GOLD_BASE + killed_level * HERO_KILL_GOLD_PER_LEVEL + GetKillstreakGold(killed_unit)
		killed_bounty = math.max( killed_bounty * ( 100 + HERO_BOUNTY_BONUS ) / 100, 0)
		killed_unit:SetMaximumGoldBounty(killed_bounty)
		killed_unit:SetMinimumGoldBounty(killed_bounty)

		-- Check if the killer was a creep, tower, or fountain (to avoid GetPlayerID crashes)
		local nonhero_killer = false
		if killer:IsTower() or killer:IsCreep() or IsFountain(killer) then
			nonhero_killer = true
		end

		-- If the killer is player-controlled, remove its deathstreak and start its killstreak
		if not nonhero_killer and killer:GetPlayerID() then
			local killer_player = PlayerResource:GetPlayer(killer:GetPlayerID())
			local killer_hero = killer_player:GetAssignedHero()
			
			-- Reset killer hero's deathstreak and update its killstreak
			killer_hero.death_streak_count = 0
			killer_hero.kill_streak_count = killer_hero.kill_streak_count + 1

			-- Update killer's bounty
			local killer_level = killer_hero:GetLevel()
			local killer_bounty = HERO_KILL_GOLD_BASE + killer_level * HERO_KILL_GOLD_PER_LEVEL + GetKillstreakGold(killer_hero)
			killer_bounty = math.max( killer_bounty * ( 100 + HERO_BOUNTY_BONUS ) / 100, 0)
			killer_hero:SetMaximumGoldBounty(killer_bounty)
			killer_hero:SetMinimumGoldBounty(killer_bounty)
		end

		-- Killed hero deathstreak messages
		local killed_hero_name = killed_unit:GetName()
		local killed_player_name = PlayerResource:GetPlayerName(killed_unit:GetPlayerID())
		local line_duration = 7

		if killed_unit.death_streak_count >= 3 then
			Notifications:BottomToAll({hero = killed_hero_name, duration = line_duration})
			Notifications:BottomToAll({text = killed_player_name.." ", duration = line_duration, style = {["font-size"] = "25px"}, continue = true})
		end

		if killed_unit.death_streak_count == 3 then
			Notifications:BottomToAll({text = "#imba_deathstreak_3", duration = line_duration, style = {["font-size"] = "25px"}, continue = true})
		elseif killed_unit.death_streak_count == 4 then
			Notifications:BottomToAll({text = "#imba_deathstreak_4", duration = line_duration, style = {["font-size"] = "25px"}, continue = true})
		elseif killed_unit.death_streak_count == 5 then
			Notifications:BottomToAll({text = "#imba_deathstreak_5", duration = line_duration, style = {["font-size"] = "25px"}, continue = true})
		elseif killed_unit.death_streak_count == 6 then
			Notifications:BottomToAll({text = "#imba_deathstreak_6", duration = line_duration, style = {["font-size"] = "25px"}, continue = true})
		elseif killed_unit.death_streak_count == 7 then
			Notifications:BottomToAll({text = "#imba_deathstreak_7", duration = line_duration, style = {["font-size"] = "25px"}, continue = true})
		elseif killed_unit.death_streak_count == 8 then
			Notifications:BottomToAll({text = "#imba_deathstreak_8", duration = line_duration, style = {["font-size"] = "25px"}, continue = true})
		elseif killed_unit.death_streak_count == 9 then
			Notifications:BottomToAll({text = "#imba_deathstreak_9", duration = line_duration, style = {["font-size"] = "25px"}, continue = true})
		elseif killed_unit.death_streak_count >= 10 then
			Notifications:BottomToAll({text = "#imba_deathstreak_10", duration = line_duration, style = {["font-size"] = "25px"}, continue = true})
		end
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