-- This file contains all barebones-registered events and has already set up the passed-in parameters for your use.
-- Do not remove the GameMode:_Function calls in these events as it will mess with the internal barebones systems.

-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)

	-- GetConnectionState values:
	-- 0 - no connection
	-- 1 - bot connected
	-- 2 - player connected
	-- 3 - bot/player disconnected.

	-- Typical keys:
	-- PlayerID: 2
	-- name: Zimberzimber
	-- networkid: [U:1:95496383]
	-- reason: 2
	-- splitscreenplayer: -1
	-- userid: 7
	-- xuid: 76561198055762111

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player disconnect/abandon logic
	-------------------------------------------------------------------------------------------------

	-- If the game hasn't started, or has already ended, do nothing
	if (GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME) or (GameRules:State_Get() < DOTA_GAMERULES_STATE_PRE_GAME) then
		return nil

	-- Else, start tracking player's reconnect/abandon state
	else

		-- Fetch player's player and hero information
		local player_id = keys.PlayerID
		local player_name = keys.name
		local hero = PlayerResource:GetPickedHero(player_id)
		local hero_name = PlayerResource:GetPickedHeroName(player_id)
		local line_duration = 7

		-- Start tracking
		print("started keeping track of player "..player_id.."'s connection state")
		local disconnect_time = 0
		Timers:CreateTimer(1, function()
			
			-- Keep track of time disconnected
			disconnect_time = disconnect_time + 1

			-- If the player has abandoned the game, set his gold to zero and distribute passive gold towards its allies
			if hero:HasOwnerAbandoned() or disconnect_time >= ABANDON_TIME then

				-- Abandon message
				Notifications:BottomToAll({hero = hero_name, duration = line_duration})
				Notifications:BottomToAll({text = player_name.." ", duration = line_duration, continue = true})
				Notifications:BottomToAll({text = "#imba_player_abandon_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})
				PlayerResource:SetHasAbandonedDueToLongDisconnect(player_id, true)
				print("player "..player_id.." has abandoned the game.")

				-- Decrease the player's team's player count
				PlayerResource:DecrementTeamPlayerCount(player_id)

				-- Start redistributing this player's gold to its allies
				PlayerResource:StartAbandonGoldRedistribution(player_id)

				-- If this was the last player to abandon on his team, wait 15 seconds and end the game if no one came back.
				if REMAINING_GOODGUYS <= 0 then
					Notifications:BottomToAll({text = "#imba_team_good_abandon_message", duration = line_duration, style = {color = "DodgerBlue"} })
					Timers:CreateTimer(FULL_ABANDON_TIME, function()
						if REMAINING_GOODGUYS <= 0 then
							GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
							GAME_WINNER_TEAM = "Dire"
						end
					end)
				elseif REMAINING_BADGUYS <= 0 then
					Notifications:BottomToAll({text = "#imba_team_bad_abandon_message", duration = line_duration, style = {color = "DodgerBlue"} })
					Timers:CreateTimer(FULL_ABANDON_TIME, function()
						if REMAINING_BADGUYS <= 0 then
							GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
							GAME_WINNER_TEAM = "Radiant"
						end
					end)
				end
				
			-- If the player has reconnected, stop tracking connection state every second
			elseif PlayerResource:GetConnectionState(player_id) == 2 then

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
	-- IMBA: Pick screen stuff
	-------------------------------------------------------------------------------------------------

	if new_state == DOTA_GAMERULES_STATE_HERO_SELECTION then
        HeroSelection:Start()
    end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Start-of-pre-game stuff
	-------------------------------------------------------------------------------------------------

	if new_state == DOTA_GAMERULES_STATE_PRE_GAME then

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
	-- IMBA: Buyback penalty removal
	-------------------------------------------------------------------------------------------------

	Timers:CreateTimer(0.1, function()
		if (not npc:IsNull()) and npc:HasModifier("modifier_buyback_gold_penalty") then
			npc:RemoveModifierByName("modifier_buyback_gold_penalty")
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
	PrintTable(keys)

	local player_id = keys.PlayerID
	local player_name = keys.name
	local hero = PlayerResource:GetPickedHero(player_id)
	local hero_name = PlayerResource:GetPickedHeroName(player_id)
	local line_duration = 7

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player reconnect logic
	-------------------------------------------------------------------------------------------------

	-- If this is a reconnect from abandonment due to a long disconnect, remove the abandon state
	if PlayerResource:GetHasAbandonedDueToLongDisconnect(player_id) then
		Notifications:BottomToAll({hero = hero_name, duration = line_duration})
		Notifications:BottomToAll({text = player_name.." ", duration = line_duration, continue = true})
		Notifications:BottomToAll({text = "#imba_player_reconnect_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})
		PlayerResource:IncrementTeamPlayerCount(player_id)

		-- Stop redistributing gold to allies, if applicable
		PlayerResource:StopAbandonGoldRedistribution(player_id)
	end

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

	local player = EntIndexToHScript(keys.player)
	local hero = player:GetAssignedHero()
	local hero_level = hero:GetLevel()

	-------------------------------------------------------------------------------------------------
	-- IMBA: Unlimited level logic
	-------------------------------------------------------------------------------------------------

	-- If the generic powerup isn't present, apply it
	if hero_level > 25 then
		local ability_powerup = hero:FindAbilityByName("imba_unlimited_level_powerup")
		local is_this_hero_fucked_by_valve = false
		local heroes_fucked_by_valve = {
			"npc_dota_hero_rubick",
			"npc_dota_hero_wisp",
			"npc_dota_hero_invoker",
			"npc_dota_hero_lina",
			"npc_dota_hero_phoenix",
			"npc_dota_hero_keeper_of_the_light"
		}
		for _, fucked_hero in pairs(heroes_fucked_by_valve) do
			if fucked_hero == hero:GetUnitName() then
				is_this_hero_fucked_by_valve = true
				break
			end
		end
		if (not ability_powerup) and (not is_this_hero_fucked_by_valve) then
			hero:AddAbility("imba_unlimited_level_powerup")
			ability_powerup = hero:FindAbilityByName("imba_unlimited_level_powerup")
			ability_powerup:SetLevel(1)
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Hero experience bounty adjustment
	-------------------------------------------------------------------------------------------------

	hero:SetCustomDeathXP(HERO_XP_BOUNTY_PER_LEVEL[hero_level])
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

	local hero_entity = EntIndexToHScript(keys.heroindex)
	local player_id = hero_entity:GetPlayerID()

	-------------------------------------------------------------------------------------------------
	-- IMBA: Assign hero to player
	-------------------------------------------------------------------------------------------------

	PlayerResource:SetPickedHero(player_id, hero_entity)

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

	-- Typical keys:
	-- herokills: 6
	-- killer_userid: 0
	-- splitscreenplayer: -1
	-- teamnumber: 2
	-- victim_userid: 7
	-- killer id will be -1 in case of a non-player owned killer (e.g. neutrals, towers, etc.)

	local killer_id = keys.killer_userid
	local victim_id = keys.victim_userid
	local killer_team = keys.teamnumber

	-------------------------------------------------------------------------------------------------
	-- IMBA: Deathstreak logic
	-------------------------------------------------------------------------------------------------

	if PlayerResource:IsImbaPlayer(killer_id) and PlayerResource:IsImbaPlayer(victim_id) then
		
		-- Reset the killer's deathstreak
		PlayerResource:ResetDeathstreak(killer_id)

		-- Increment the victim's deathstreak
		PlayerResource:IncrementDeathstreak(victim_id)

		-- Show Deathstreak message
		local victim_hero_name = PlayerResource:GetPickedHeroName(victim_id)
		local victim_player_name = PlayerResource:GetPlayerName(victim_id)
		local victim_death_streak = PlayerResource:GetDeathstreak(victim_id)
		local line_duration = 7

		if victim_death_streak >= 3 then
			Notifications:BottomToAll({hero = victim_hero_name, duration = line_duration})
			Notifications:BottomToAll({text = victim_player_name.." ", duration = line_duration, continue = true})
		end

		if victim_death_streak == 3 then
			Notifications:BottomToAll({text = "#imba_deathstreak_3", duration = line_duration, continue = true})
		elseif victim_death_streak == 4 then
			Notifications:BottomToAll({text = "#imba_deathstreak_4", duration = line_duration, continue = true})
		elseif victim_death_streak == 5 then
			Notifications:BottomToAll({text = "#imba_deathstreak_5", duration = line_duration, continue = true})
		elseif victim_death_streak == 6 then
			Notifications:BottomToAll({text = "#imba_deathstreak_6", duration = line_duration, continue = true})
		elseif victim_death_streak == 7 then
			Notifications:BottomToAll({text = "#imba_deathstreak_7", duration = line_duration, continue = true})
		elseif victim_death_streak == 8 then
			Notifications:BottomToAll({text = "#imba_deathstreak_8", duration = line_duration, continue = true})
		elseif victim_death_streak == 9 then
			Notifications:BottomToAll({text = "#imba_deathstreak_9", duration = line_duration, continue = true})
		elseif victim_death_streak >= 10 then
			Notifications:BottomToAll({text = "#imba_deathstreak_10", duration = line_duration, continue = true})
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Rancor logic
	-------------------------------------------------------------------------------------------------

	-- Victim stack loss
	local victim_hero = PlayerResource:GetPickedHero(victim_id)
	if victim_hero and victim_hero:HasModifier("modifier_imba_rancor") then
		local current_stacks = victim_hero:GetModifierStackCount("modifier_imba_rancor", VENGEFUL_RANCOR_CASTER)
		if current_stacks <= 2 then
			victim_hero:RemoveModifierByName("modifier_imba_rancor")
		else
			victim_hero:SetModifierStackCount("modifier_imba_rancor", VENGEFUL_RANCOR_CASTER, current_stacks - math.floor(current_stacks / 2) - 1)
		end
	end
	
	-- Killer stack gain
	if victim_hero and VENGEFUL_RANCOR and PlayerResource:IsImbaPlayer(killer_id) and killer_team ~= VENGEFUL_RANCOR_TEAM then
		local eligible_rancor_targets = FindUnitsInRadius(victim_hero:GetTeamNumber(), victim_hero:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		if eligible_rancor_targets[1] then
			local rancor_stacks = 1

			-- Double stacks if the killed unit was Venge
			if victim_hero == VENGEFUL_RANCOR_CASTER then
				rancor_stacks = rancor_stacks * 2
			end

			-- Add stacks and play particle effect
			AddStacks(VENGEFUL_RANCOR_ABILITY, VENGEFUL_RANCOR_CASTER, eligible_rancor_targets[1], "modifier_imba_rancor", rancor_stacks, true)
			local rancor_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_negative_aura.vpcf", PATTACH_ABSORIGIN, eligible_rancor_targets[1])
			ParticleManager:SetParticleControl(rancor_pfx, 0, eligible_rancor_targets[1]:GetAbsOrigin())
			ParticleManager:SetParticleControl(rancor_pfx, 1, VENGEFUL_RANCOR_CASTER:GetAbsOrigin())
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Vengeance Aura logic
	-------------------------------------------------------------------------------------------------

	if victim_hero and PlayerResource:IsImbaPlayer(killer_id) then
		local vengeance_aura_ability = victim_hero:FindAbilityByName("imba_vengeful_command_aura")
		local killer_hero = PlayerResource:GetPickedHero(killer_id)
		if vengeance_aura_ability and vengeance_aura_ability:GetLevel() > 0 then
			vengeance_aura_ability:ApplyDataDrivenModifier(victim_hero, killer_hero, "modifier_imba_command_aura_negative_aura", {})
			victim_hero.vengeance_aura_target = killer_hero
		end
	end

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
	-- IMBA: Buyback setup
	-------------------------------------------------------------------------------------------------

	-- Check if the dying unit was a player-controlled hero
	if killed_unit:IsRealHero() and killed_unit:GetPlayerID() and PlayerResource:IsImbaPlayer(killed_unit:GetPlayerID()) then

		-- Buyback parameters
		local player_id = killed_unit:GetPlayerID()
		local hero_level = killed_unit:GetLevel()
		local game_time = GameRules:GetDOTATime(false, false)

		-- Calculate buyback cost
		local level_based_cost = math.min(hero_level * hero_level, 625) * BUYBACK_COST_PER_LEVEL
		if hero_level > 25 then
			level_based_cost = level_based_cost + BUYBACK_COST_PER_LEVEL_AFTER_25 * (hero_level - 25)
		end
		local buyback_cost = BUYBACK_BASE_COST + level_based_cost + game_time * BUYBACK_COST_PER_SECOND
		buyback_cost = buyback_cost * (1 + CUSTOM_GOLD_BONUS * 0.01)

		-- Update buyback cost
		PlayerResource:SetCustomBuybackCost(player_id, buyback_cost)

		-- Setup buyback cooldown
		local buyback_cooldown = 0
		if BUYBACK_COOLDOWN_ENABLED and game_time > BUYBACK_COOLDOWN_START_POINT then
			buyback_cooldown = math.min(BUYBACK_COOLDOWN_GROW_FACTOR * (game_time - BUYBACK_COOLDOWN_START_POINT), BUYBACK_COOLDOWN_MAXIMUM)
		end
		PlayerResource:SetCustomBuybackCooldown(player_id, buyback_cooldown)
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