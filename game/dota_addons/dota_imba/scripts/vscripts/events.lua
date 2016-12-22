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

	-- GetConnectionState values:
	-- 0 - no connection
	-- 1 - bot connected
	-- 2 - player connected
	-- 3 - bot/player disconnected.

	PrintTable(keys)

	-- Fetch player's player ID and hero
	local player_id = keys.userid
	local hero = PlayerResource:GetPickedHero(player_id)

	-- If the game has already ended, do nothing
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME then
		return nil

	-- Else, start tracking player's reconnect/abandon state
	else
		print("started keeping track of player "..player_id.."'s connection state")
		local disconnect_time = 0
		Timers:CreateTimer(1, function()
			
			-- Keep track of time disconnected
			disconnect_time = disconnect_time + 1

			-- If the player has abandoned the game, set his gold to zero and distribute passive gold towards its allies
			if hero:HasOwnerAbandoned() or disconnect_time >= ABANDON_TIME then
				print("player "..player_id.." has abandoned the game.")

				-- Abandon message
				--Notifications:BottomToAll({text = "#imba_player_abandon_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})

				-- If this was the last player to abandon on his team, end the game
				--Notifications:BottomToAll({text = "#imba_team_good_abandon_message", duration = line_duration, style = {color = "DodgerBlue"} })
				--Timers:CreateTimer(FULL_ABANDON_TIME, function()
				--	if GOODGUYS_CONNECTED_PLAYERS == 0 then
				--		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
				--		GAME_WINNER_TEAM = "Dire"
				--	end
				--end)
				
			-- If the player has reconnected, stop tracking connection state every second
			elseif PlayerResource:GetConnectionState(player_id) == 2 then
				--Notifications:BottomToAll({text = "#imba_player_reconnect_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})

			-- Else, keep tracking connection state
			else
				print("tracking player "..player_id.."'s connection state, disconnected for "..disconnect_time.." seconds.")
				return 1
			end
		end)
	end
end

-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
	DebugPrint("[BAREBONES] GameRules State Changed")
	DebugPrintTable(keys)

	-- This internal handling is used to set up main barebones functions
	GameMode:_OnGameRulesStateChange(keys)

	local new_state = GameRules:State_Get()

	-------------------------------------------------------------------------------------------------
	-- IMBA: Start-of-pre-game stuff
	-------------------------------------------------------------------------------------------------

	if new_state == DOTA_GAMERULES_STATE_PRE_GAME then

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player greeting and explanations
	-------------------------------------------------------------------------------------------------

		local initial_time = 2
		local line_duration = 5
	
		Timers:CreateTimer(initial_time, function()

			-- First line
			Notifications:BottomToAll( {text = "#imba_introduction_line_01", duration = line_duration, style = {color = "DodgerBlue"} } )
			Notifications:BottomToAll( {text = "#imba_introduction_line_02", duration = line_duration, style = {color = "Orange"}, continue = true}	)
				
			-- Second line
			Timers:CreateTimer(line_duration, function()
				Notifications:BottomToAll( {text = "#imba_introduction_line_03", duration = line_duration, style = {color = "DodgerBlue"} }	)

				-- Third line
				Timers:CreateTimer(line_duration, function()
					Notifications:BottomToAll( {text = "#imba_introduction_line_04", duration = line_duration, style = {["font-size"] = "30px", color = "Orange"} }	)
				end)
			end)
		end)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Extra asset loading
	-------------------------------------------------------------------------------------------------

	--	print("loading started")

	--	Timers:CreateTimer(5, function()
	--		print("loading...")
	--		PrecacheUnitByNameAsync("npc_dota_hero_brewmaster", function(...) end)
	--	end)
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Force-random picks after the pick time has elapsed 
	-------------------------------------------------------------------------------------------------

	if new_state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		Timers:CreateTimer(HERO_SELECTION_TIME - 10.1, function()
			for player_id = 0, 19 do
				if PlayerResource:IsImbaPlayer(player_id) then

					-- If this player still hasn't picked a hero, random one
					if not PlayerResource:GetPickedHero(player_id) then
						PlayerResource:GetPlayer(player_id):MakeRandomHeroSelection()
						PlayerResource:SetCanRepick(player_id, false)
						PlayerResource:SetHasRandomed(player_id)
						print("tried to random a hero for "..player_id)
					end
				end
			end
		end)
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Skip strategy time
	-------------------------------------------------------------------------------------------------

	if new_state == DOTA_GAMERULES_STATE_STRATEGY_TIME then
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Stat collection stuff
	-------------------------------------------------------------------------------------------------

	--if new_state == DOTA_GAMERULES_STATE_POST_GAME then
	--end
end

-- An NPC has spawned somewhere in game. This includes heroes
function GameMode:OnNPCSpawned(keys)

	-- This internal handling is used to set up main barebones functions
	GameMode:_OnNPCSpawned(keys)

	local npc = EntIndexToHScript(keys.entindex)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Replace Silencer Int Steal with IMBA version
	--
	-- Unfortunately, needs to be done every time Silencer spawns as his modifier is permanently
	-- embedded into his character and he'll gain it every time he spawns
	-------------------------------------------------------------------------------------------------

	if npc:IsRealHero() then
		Timers:CreateTimer(1, function()
			if npc:HasModifier("modifier_silencer_int_steal") then
				npc:RemoveModifierByName("modifier_silencer_int_steal")
				
				-- Only add the modifier once, since it persists through death and whatnot
				if not npc:HasModifier("modifier_imba_silencer_int_steal") then
					npc:AddNewModifier(npc, nil, "modifier_imba_silencer_int_steal", {steal_range = 925, steal_amount = 2})
				end
			end
		end)
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Arc Warden clone handling
	-------------------------------------------------------------------------------------------------

	if npc:FindAbilityByName("arc_warden_tempest_double") and not npc.first_tempest_double_cast and npc:IsRealHero() then
		npc.first_tempest_double_cast = true
		local tempest_double_ability = npc:FindAbilityByName("arc_warden_tempest_double")
		tempest_double_ability:SetLevel(4)
		Timers:CreateTimer(0.1, function()
			if not npc:HasModifier("modifier_arc_warden_tempest_double") then
				tempest_double_ability:CastAbility()
				tempest_double_ability:SetLevel(1)
			end
		end)
	end

	if npc:HasModifier("modifier_arc_warden_tempest_double") then

		-- List of items the clone can't carry
		local clone_forbidden_items = {
			"item_imba_rapier",
			"item_imba_rapier_magic",
			"item_imba_rapier_dummy",
			"item_imba_moon_shard",
			"item_imba_soul_of_truth",
			"item_imba_refresher",
			"item_imba_ultimate_scepter_synth"
		}

		-- Iterate through the clone's items
		Timers:CreateTimer(0.05, function()
			for i = 0, 5 do
				local current_item = npc:GetItemInSlot(i)

				-- Remove any existing forbidden items on the clone
				for _, forbidden_item in pairs(clone_forbidden_items) do
					if current_item and current_item:GetName() == forbidden_item then
						npc:RemoveItem(current_item)
						break
					end
				end
			end

			-- Erase any leftover modifiers
			npc:RemoveModifierByName("modifier_item_imba_rapier_stacks_phys")
			npc:RemoveModifierByName("modifier_item_imba_rapier_stacks_magic")
		end)

		-- List of modifiers which carry over from the main hero to the clone
		local clone_shared_buffs = {
			"modifier_imba_unlimited_level_powerup",
			"modifier_imba_moon_shard_stacks_dummy",
			"modifier_imba_moon_shard_consume_1",
			"modifier_imba_moon_shard_consume_2",
			"modifier_imba_moon_shard_consume_3",
			"modifier_item_imba_soul_of_truth"
		}

		-- Iterate through the main hero's potential modifiers
		local main_hero = npc:GetOwner():GetAssignedHero()
		for _, shared_buff in pairs(clone_shared_buffs) do
			
			-- If the main hero has this modifier, copy it to the clone
			if main_hero:HasModifier(shared_buff) then
				local shared_buff_modifier = main_hero:FindModifierByName(shared_buff)
				local shared_buff_ability = shared_buff_modifier:GetAbility()

				-- If a source ability was found, use it
				if shared_buff_ability then
					shared_buff_ability:ApplyDataDrivenModifier(main_hero, npc, shared_buff, {})

				-- Else, it's a consumable item modifier. Create a dummy item to use the ability from.
				else
					-- Moon Shard
					if string.find(shared_buff, "moon_shard") then

						-- Create dummy item
						local dummy_item = CreateItem("item_imba_moon_shard", npc, npc)
						main_hero:AddItem(dummy_item)

						-- Fetch dummy item's ability handle
						for i = 0, 11 do
							local current_item = main_hero:GetItemInSlot(i)
							if current_item and current_item:GetName() == "item_imba_moon_shard" then
								current_item:ApplyDataDrivenModifier(main_hero, npc, shared_buff, {})
								break
							end
						end
						main_hero:RemoveItem(dummy_item)
					end

					-- Soul of Truth
					if shared_buff == "modifier_item_imba_soul_of_truth" then

						-- Create dummy item
						local dummy_item = CreateItem("item_imba_soul_of_truth", npc, npc)
						main_hero:AddItem(dummy_item)

						-- Fetch dummy item's ability handle
						for i = 0, 11 do
							local current_item = main_hero:GetItemInSlot(i)
							if current_item and current_item:GetName() == "item_imba_soul_of_truth" then
								current_item:ApplyDataDrivenModifier(main_hero, npc, shared_buff, {})
								break
							end
						end
						main_hero:RemoveItem(dummy_item)
					end
				end

				-- Apply any stacks if relevant
				if main_hero:GetModifierStackCount(shared_buff, nil) > 0 then
					npc:SetModifierStackCount(shared_buff, main_hero, main_hero:GetModifierStackCount(shared_buff, nil))
				end
			end
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Remote Mine ability setup
	-------------------------------------------------------------------------------------------------

	if string.find(npc:GetUnitName(), "npc_dota_techies_remote_mine") then
		npc.needs_remote_mine_setup = true
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Random OMG on-respawn skill randomization
	-------------------------------------------------------------------------------------------------

	if IMBA_ABILITY_MODE_RANDOM_OMG then
		if npc:IsRealHero() then
			
			-- Randomize abilities
			ApplyAllRandomOmgAbilities(npc)

			-- Clean-up undesired permanent modifiers
			RemovePermanentModifiersRandomOMG(npc)

			-- If the hero is level 25 or above, max out all its abilities
			if npc:GetLevel() >= 25 then

				npc:SetAbilityPoints(0)
				for i = 0, 16 do
					local current_ability = npc:GetAbilityByIndex(i)
					if current_ability then
						current_ability:SetLevel(current_ability:GetMaxLevel())
					end
				end
				
			-- Else, grant unspent skill points equal to the hero's level
			else
				npc:SetAbilityPoints( math.min(npc:GetLevel(), 25) )
			end
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Buyback setup (part 2)
	-------------------------------------------------------------------------------------------------

	-- Check if the spawned unit has the buyback penalty modifier
	Timers:CreateTimer(0.1, function()
		if not npc:IsNull() and npc:HasModifier("modifier_buyback_gold_penalty") then

			-- Add one to this player's buyback count
			npc.buyback_count = npc.buyback_count + 1

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
	-- IMBA: Creep stats adjustment
	-------------------------------------------------------------------------------------------------

	if not npc:IsHero() and not npc:IsOwnedByAnyPlayer() then

		-- Add passive buff to lane creeps
		if string.find(npc:GetUnitName(), "dota_creep") then
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

	--local damagebits = keys.damagebits -- This might always be 0 and therefore useless
	--if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
	--local entCause = EntIndexToHScript(keys.entindex_attacker)
	--local entVictim = EntIndexToHScript(keys.entindex_killed)
	--end
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
	DebugPrint( '[BAREBONES] OnItemPickedUp' )
	DebugPrintTable(keys)

	--local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
	--local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	--local player = PlayerResource:GetPlayer(keys.PlayerID)
	--local itemname = keys.itemname
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)
	DebugPrint( '[BAREBONES] OnPlayerReconnect' )
	DebugPrintTable(keys) 

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player reconnect logic
	-------------------------------------------------------------------------------------------------

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

	-------------------------------------------------------------------------------------------------
	-- IMBA: Remote Mines adjustment
	-------------------------------------------------------------------------------------------------

	-- if abilityname == "techies_remote_mines" then

	-- 	local mine_caster = player:GetAssignedHero()
	-- 	Timers:CreateTimer(0.01, function()
	-- 		local nearby_units = FindUnitsInRadius(mine_caster:GetTeamNumber(), mine_caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- 		for _,unit in pairs(nearby_units) do

	-- 			-- Only operate on remotes which need setup
	-- 			if unit.needs_remote_mine_setup then
					
	-- 				-- Add extra abilities
	-- 				unit:AddAbility("imba_techies_minefield_teleport")
	-- 				unit:AddAbility("imba_techies_remote_auto_creep")
	-- 				unit:AddAbility("imba_techies_remote_auto_hero")
	-- 				local minefield_teleport = unit:FindAbilityByName("imba_techies_minefield_teleport")
	-- 				local auto_creep = unit:FindAbilityByName("imba_techies_remote_auto_creep")
	-- 				local auto_hero = unit:FindAbilityByName("imba_techies_remote_auto_hero")
	-- 				auto_creep:SetLevel(1)
	-- 				auto_hero:SetLevel(1)

	-- 				-- Enable minefield teleport if the caster has a scepter
	-- 				local scepter = HasScepter(mine_caster)
	-- 				if scepter then
	-- 					minefield_teleport:SetLevel(1)
	-- 				end

	-- 				-- Toggle abilities on according to the current caster setting
	-- 				if mine_caster.auto_hero_exploding then
	-- 					auto_hero:ToggleAbility()
	-- 				elseif mine_caster.auto_creep_exploding then
	-- 					auto_creep:ToggleAbility()
	-- 				end

	-- 				-- Set this mine's setup as done
	-- 				unit.needs_remote_mine_setup = nil
	-- 			end
	-- 		end
	-- 	end)
	-- end

end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
	DebugPrint('[BAREBONES] OnNonPlayerUsedAbility')
	DebugPrintTable(keys)

	local abilityname = keys.abilityname
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
	-- IMBA: Unlimited level logic
	-------------------------------------------------------------------------------------------------

	local hero = player:GetAssignedHero()
	local hero_level = hero:GetLevel()

	if hero_level > 25 then

		-- Invoker is a special case
		if not hero:GetName() == "npc_dota_hero_invoker" then

			-- If the generic powerup isn't present, apply it
			local ability_powerup = hero:FindAbilityByName("imba_unlimited_level_powerup")
			if not ability_powerup then
				hero:AddAbility("imba_unlimited_level_powerup")
				ability_powerup = hero:FindAbilityByName("imba_unlimited_level_powerup")
				ability_powerup:SetLevel(1)

				for i = 0, 99 do
					if hero:GetAbilityByIndex(i) then
						print(hero:GetAbilityByIndex(i):GetName())
					end
				end
			end
		end
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

	local hero_class = keys.hero
	local hero_entity = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Assign hero to player
	-------------------------------------------------------------------------------------------------

	PlayerResource:SetPickedHero(player:GetPlayerID(), hero_entity)

	-------------------------------------------------------------------------------------------------
	-- IMBA: All Pick hero pick logic
	-------------------------------------------------------------------------------------------------

	if IMBA_PICK_MODE_ALL_PICK then

		-- Fetch player's team and chosen hero
		--local team = PlayerResource:GetTeam(player:GetPlayerID())
		--local hero = player:GetAssignedHero()
		--local hero_name = hero:GetName()

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

	if keys.entindex_attacker then
		killer = EntIndexToHScript( keys.entindex_attacker )
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Ancient destruction detection
	-------------------------------------------------------------------------------------------------

	if killed_unit:GetUnitName() == "npc_dota_badguys_fort" then
		GAME_WINNER_TEAM = "Radiant"
	elseif killed_unit:GetUnitName() == "npc_dota_goodguys_fort" then
		GAME_WINNER_TEAM = "Dire"
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Arena mode logic
	-------------------------------------------------------------------------------------------------

	if END_GAME_ON_KILLS then
		local radiant_kills = PlayerResource:GetTeamKills(DOTA_TEAM_GOODGUYS)
		local dire_kills = PlayerResource:GetTeamKills(DOTA_TEAM_BADGUYS)

		if radiant_kills >= KILLS_TO_END_GAME_FOR_TEAM then
			GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
			GAME_WINNER_TEAM = "Radiant"
		elseif dire_kills >= KILLS_TO_END_GAME_FOR_TEAM then
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
			GAME_WINNER_TEAM = "Dire"
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Meepo redirect to Meepo Prime
	-------------------------------------------------------------------------------------------------
	if killed_unit:GetUnitName() == "npc_dota_hero_meepo" then
		killed_unit = killed_unit:GetCloneSource()
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Respawn timer setup
	-------------------------------------------------------------------------------------------------
	
	if killed_unit:IsRealHero() and killed_unit:GetPlayerID() and PlayerResource:IsImbaPlayer(killed_unit:GetPlayerID()) then
		
		-- Calculate base respawn timer, capped at 60 seconds
		local hero_level = math.min(killed_unit:GetLevel(), 25)
		local respawn_time = HERO_RESPAWN_TIME_PER_LEVEL[hero_level]

		-- Calculate respawn timer reduction due to talents
		local respawn_reduction_talents = {}
		respawn_reduction_talents["special_bonus_respawn_reduction_15"] = 9
		respawn_reduction_talents["special_bonus_respawn_reduction_20"] = 12
		respawn_reduction_talents["special_bonus_respawn_reduction_25"] = 15
		respawn_reduction_talents["special_bonus_respawn_reduction_30"] = 18
		respawn_reduction_talents["special_bonus_respawn_reduction_35"] = 20
		respawn_reduction_talents["special_bonus_respawn_reduction_40"] = 25
		respawn_reduction_talents["special_bonus_respawn_reduction_50"] = 30
		respawn_reduction_talents["special_bonus_respawn_reduction_60"] = 40

		for talent_name,respawn_reduction_bonus in pairs(respawn_reduction_talents) do
			if killed_unit:FindAbilityByName(talent_name) and killed_unit:FindAbilityByName(talent_name):GetLevel() > 0 then
				respawn_time = respawn_time - respawn_reduction_bonus
			end
		end

		-- Fetch decreased respawn timer due to Bloodstone charges
		if killed_unit.bloodstone_respawn_reduction then
			respawn_time = math.max( respawn_time - killed_unit.bloodstone_respawn_reduction, 0)
		end

		-- Multiply respawn timer by the lobby options
		respawn_time = math.max( respawn_time * HERO_RESPAWN_TIME_MULTIPLIER * 0.01, 1)

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
		local game_time = GameRules:GetDOTATime(false, false) / 60

		local buyback_cost = ( HERO_BUYBACK_BASE_COST + hero_level * HERO_BUYBACK_COST_PER_LEVEL + game_time * HERO_BUYBACK_COST_PER_MINUTE ) * buyback_cost_multiplier
		local buyback_penalty_duration = HERO_BUYBACK_RESET_TIME_PER_LEVEL * hero_level + HERO_BUYBACK_RESET_TIME_PER_MINUTE * game_time

		-- Update buyback cost and penalty duration 
		PlayerResource:SetCustomBuybackCost(killed_unit:GetPlayerID(), buyback_cost)
		PlayerResource:SetBuybackGoldLimitTime(killed_unit:GetPlayerID(), buyback_penalty_duration)

		-- Setup buyback cooldown
		local buyback_cooldown = 0
		if game_time > HERO_BUYBACK_COOLDOWN_START_POINT and HERO_BUYBACK_COOLDOWN > 0 then
			buyback_cooldown = HERO_BUYBACK_COOLDOWN + (game_time - HERO_BUYBACK_COOLDOWN_START_POINT) * HERO_BUYBACK_COOLDOWN_GROW_FACTOR
		end
		PlayerResource:SetCustomBuybackCooldown(killed_unit:GetPlayerID(), buyback_cooldown)
		
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

		-- Killed hero Rancor clean-up
		if killed_unit:HasModifier("modifier_imba_rancor") then
			local current_stacks = killed_unit:GetModifierStackCount("modifier_imba_rancor", VENGEFUL_RANCOR_CASTER)
			if current_stacks <= 2 then
				killed_unit:RemoveModifierByName("modifier_imba_rancor")
			else
				killed_unit:SetModifierStackCount("modifier_imba_rancor", VENGEFUL_RANCOR_CASTER, current_stacks - math.floor(current_stacks / 2) - 1)
			end
		end

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

			-- Killer Rancor logic
			if VENGEFUL_RANCOR and killer_hero:GetTeam() ~= VENGEFUL_RANCOR_TEAM then
				local rancor_stacks = 1

				-- Double stacks if the killed unit was Venge
				if killed_unit == VENGEFUL_RANCOR_CASTER then
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
	local player_id = ply:GetPlayerID()

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player data initialization
	-------------------------------------------------------------------------------------------------

	PlayerResource:InitPlayerData(player_id)

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