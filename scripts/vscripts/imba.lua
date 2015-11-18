<<<<<<< HEAD
-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode
=======
-- Dota IMBA version 6.84.1
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108


-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output

BAREBONES_DEBUG_SPEW = false

<<<<<<< HEAD
if GameMode == nil then
	DebugPrint( '[IMBA] creating game mode' )
	_G.GameMode = class({})
end
=======
RECOMMENDED_BUILDS_DISABLED = true     -- Should we disable the recommened builds for heroes (Note: this is not working currently I believe)
CAMERA_DISTANCE_OVERRIDE = 1134.0       -- How far out should we allow the camera to go?  1134 is the default in Dota
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for creating frankenstein monsters
require('libraries/attachments')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')

-- storage API
--require('libraries/json')
--require('libraries/storage')

--Storage:SetApiKey("35c56d290cbd168b6a58aabc43c87aff8d6b39cb")

--[[
	This function should be used to set up Async precache calls at the beginning of the gameplay.

	In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
	after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
	be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
	precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
	defined on the unit.

<<<<<<< HEAD
	This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
	time, you can call the functions individually (for example if you want to precache units in a new wave of
	holdout).
=======
USE_STANDARD_DOTA_BOT_THINKING = false 	-- Should we have bots act like they would in Dota? (This requires 3 lanes, normal items, etc)
USE_STANDARD_HERO_GOLD_BOUNTY = true    -- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108

	This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
	DebugPrint("[IMBA] Performing Post-Load precache")    

end

--[[
	This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
	It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
	DebugPrint("[IMBA] First Player has loaded")

	-------------------------------------------------------------------------------------------------
	-- IMBA: Roshan initialization
	-------------------------------------------------------------------------------------------------

	local roshan_spawn_loc = Entities:FindByName(nil, "roshan_spawn_point"):GetAbsOrigin()
	local roshan = CreateUnitByName("npc_imba_roshan", roshan_spawn_loc, true, nil, nil, DOTA_TEAM_NEUTRALS)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Contributor models
	-------------------------------------------------------------------------------------------------

	local radiant_spawn = Vector(6820, -6028, 408)
	local dire_spawn = Vector(-5930, 6916, 278)
	local spawn_radius = 400
	local radiant_count = 3
	--local direction = RandomVector(1)
	local radiant_spawns = {}
	for i = 1,radiant_count do
		radiant_spawns[i] = radiant_spawn + RandomVector(1) * spawn_radius * (i - 1) / (radiant_count - 1)
	end

	-- Martyn Garcia
	local martyn_model = CreateUnitByName("npc_imba_contributor_martyn", radiant_spawns[1], true, nil, nil, DOTA_TEAM_NEUTRALS)
	martyn_model:SetForwardVector(RandomVector(100))

	-- Mikkel Garcia
	local mikkel_model = CreateUnitByName("npc_imba_contributor_mikkel", radiant_spawns[2], true, nil, nil, DOTA_TEAM_NEUTRALS)
	mikkel_model:SetForwardVector(RandomVector(100))

<<<<<<< HEAD
	-- Hjort
	local hjort_model = CreateUnitByName("npc_imba_contributor_hjort", radiant_spawns[3], true, nil, nil, DOTA_TEAM_NEUTRALS)
	hjort_model:SetForwardVector(RandomVector(100))
=======
playerIdsToNames = {}

isDisconnected = {}
DisconnectTime = {}
DisconnectKicked = {}

if not Testing then
  statcollection.addStats({
    modID = "3c618932c8379fe1284bc14438f76c89"
  })
end
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108

end

<<<<<<< HEAD
-- Multiplies bounty rune experience and gold according to the gamemode multiplier
function GameMode:BountyRuneFilter( keys )

	--player_id_const	 ==> 	0
	--xp_bounty	 ==> 	136.5
	--gold_bounty	 ==> 	132.6
=======
-- Generated from template
if GameMode == nil then
	GameMode = class({})
end

function Precache( context )
	for ind = 0, 20, 1 do
		playerIdsToNames[ind]=0;
	end
end

function GameMode:PostLoadPrecache()
	print("[IMBA] Performing Post-Load precache")
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108

	keys["gold_bounty"] = ( 100 + CREEP_GOLD_BONUS ) / 100 * keys["gold_bounty"]
	keys["xp_bounty"] = ( 100 + CREEP_XP_BONUS ) / 100 * keys["xp_bounty"]

<<<<<<< HEAD
	return true
end

-- Order filter function
function GameMode:OrderFilter( keys )

	--entindex_ability	 ==> 	0
	--sequence_number_const	 ==> 	20
	--queue	 ==> 	0
	--units	 ==> 	table: 0x031d5fd0
	--entindex_target	 ==> 	0
	--position_z	 ==> 	384
	--position_x	 ==> 	-5694.3334960938
	--order_type	 ==> 	1
	--position_y	 ==> 	-6381.1127929688
	--issuer_player_id_const	 ==> 	0

	--local units = keys["units"]
	--local unit = EntIndexToHScript(units["0"])

	return true
=======
--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
	print("[IMBA] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
	print("[IMBA] All Players have loaded into the game")
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108
end

-- Damage filter function
function GameMode:DamageFilter( keys )

<<<<<<< HEAD
	--damagetype_const
	--damage
	--entindex_attacker_const
	--entindex_victim_const

	local attacker
	local victim
=======
  The hero parameter is the hero entity that just spawned in.
]]
function GameMode:OnHeroInGame(hero)
	print("[IMBA] Hero spawned in game for first time -- " .. hero:GetUnitName())

	if not self.greetPlayers then
		-- At this point a player now has a hero spawned in your map.
		
	    local firstLine = ColorIt("Welcome to ", "green") .. ColorIt("Dota IMBA! ", "orange") .. ColorIt("v6.84.1", "blue");
		-- Send the first greeting in 4 secs.
		Timers:CreateTimer(4, function()
	        GameRules:SendCustomMessage(firstLine, 0, 0)
		end)
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108

	if keys.entindex_attacker_const and keys.entindex_victim_const then
		attacker = EntIndexToHScript(keys.entindex_attacker_const)
		victim = EntIndexToHScript(keys.entindex_victim_const)
	else
		return false
	end

<<<<<<< HEAD
	local damage_type = keys.damagetype_const
	local display_red_crit_number = false

	-- Lack of entities handling
	if not attacker or not victim then
		return false
=======
	-- Store a reference to the player handle inside this hero handle.
	hero.player = PlayerResource:GetPlayer(hero:GetPlayerID())
	-- Store the player's name inside this hero handle.
	hero.playerName = PlayerResource:GetPlayerName(hero:GetPlayerID())
	-- Store this hero handle in this table.
	table.insert(self.vPlayers, hero)

	-- Show a popup with game instructions.
    ShowGenericPopupToPlayer(hero.player, "#barebones_instructions_title", "#barebones_instructions_body", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN )

	-- This line for example will set the starting gold of every hero to 625 unreliable gold
	hero:SetGold(625, false)

	-- These lines will create an item and add it to the player, effectively ensuring they start with the item
	--local item = CreateItem("item_example_item", hero, hero)
	--hero:AddItem(item)

	if Testing then
		Say(nil, "Testing is on.", false)
		hero:SetGold(50000, false)
		local item_1 = CreateItem("item_imba_diffusal_blade", hero, hero)
		local item_2 = CreateItem("item_imba_manta", hero, hero)
		local item_3 = CreateItem("item_imba_blink", hero, hero)
		local item_4 = CreateItem("item_imba_travel_boots", hero, hero)
		local item_5 = CreateItem("item_imba_ultimate_scepter", hero, hero)
		hero:AddItem(item_1)
		hero:AddItem(item_2)
		hero:AddItem(item_3)
		hero:AddItem(item_4)
		hero:AddItem(item_5)
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108
	end

<<<<<<< HEAD
	-- Orchid crit
	if attacker:HasModifier("modifier_item_imba_orchid_unique") and (damage_type == DAMAGE_TYPE_MAGICAL or damage_type == DAMAGE_TYPE_PURE) then
		
		-- Fetch the orchid's ability handle
		local ability
		for i = 0,5 do
			local this_item = attacker:GetItemInSlot(i)
			if this_item and this_item:GetName() == "item_imba_orchid" then
				ability = this_item
			end
		end

		local ability_level = ability:GetLevel() - 1
=======
--[[
	This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
	gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
	is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
	print("[IMBA] The game has officially begun")

	-- Makes all non-T1 structures invulnerable
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name ~= "dota_goodguys_tower1_top" and name ~= "dota_goodguys_tower1_mid" and name ~= "dota_goodguys_tower1_bot"
			and name ~= "dota_badguys_tower1_top" and name ~= "dota_badguys_tower1_mid" and name ~= "dota_badguys_tower1_bot" then
				v:AddNewModifier(nil, nil, "modifier_invulnerable", {})
			end
		end
end
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108

		-- Parameters
		local crit_chance = ability:GetLevelSpecialValueFor("crit_chance", ability_level)
		local crit_damage = ability:GetLevelSpecialValueFor("crit_damage", ability_level)
		local distance_taper_start = ability:GetLevelSpecialValueFor("distance_taper_start", ability_level)
		local distance_taper_end = ability:GetLevelSpecialValueFor("distance_taper_end", ability_level)

		-- Check for a valid target
		if not (victim:IsBuilding() or victim:IsTower() or victim == attacker) then

			-- Scale damage bonus according to distance
			local distance = ( victim:GetAbsOrigin() - attacker:GetAbsOrigin() ):Length2D()
			local distance_taper = 1
			if distance > distance_taper_start and distance < distance_taper_end then
				distance_taper = distance_taper * ( 0.3 + ( distance_taper_end - distance ) / ( distance_taper_end - distance_taper_start ) * 0.7 )
			elseif distance >= distance_taper_end then
				distance_taper = 0.3
			end

			-- Roll for crit chance
			if RandomInt(1, 100) <= crit_chance then
				keys.damage = keys.damage * (100 + (crit_damage - 100) * distance_taper) / 100
				display_red_crit_number = true
			end
		end
	end

	-- Rapier damage amplification
	--if attacker:HasModifier("modifier_item_imba_rapier_unique") then

		-- If the target is Roshan, a building, or an ally, or if the attacker is an invulnerable storm spirit, do nothing
		--if not ( victim:IsBuilding() or IsRoshan(victim) or victim:GetTeam() == attacker:GetTeam() or (attacker:IsInvulnerable() and attacker:GetName() == "npc_dota_hero_storm_spirit") ) then
			
			-- Fetch the rapier's ability handle
			--local ability = false
			--local rapier_level = 1
			--for i = 0,5 do
			--	local item = attacker:GetItemInSlot(i)
			--	for j = 1, 10 do
			--		if item and item:GetAbilityName() == ( "item_imba_rapier_"..j ) then
			--			if j >= rapier_level then
			--				ability = item
			--				rapier_level = j
			--			end
			--		end
			--	end
			--end

			--if ability then
			--	local ability_level = ability:GetLevel() - 1

				-- Parameters
			--	local damage_amplify = ability:GetLevelSpecialValueFor("damage_amplify", ability_level)
			--	local distance_taper_start = ability:GetLevelSpecialValueFor("distance_taper_start", ability_level)
			--	local distance_taper_end = ability:GetLevelSpecialValueFor("distance_taper_end", ability_level)

				-- Scale damage bonus according to distance
			--	local distance = ( victim:GetAbsOrigin() - attacker:GetAbsOrigin() ):Length2D()
			--	local distance_taper = 1
			--	if distance > distance_taper_start and distance < distance_taper_end then
			--		distance_taper = distance_taper * ( 0.3 + ( distance_taper_end - distance ) / ( distance_taper_end - distance_taper_start ) * 0.7 )
			--	elseif distance >= distance_taper_end then
			--		distance_taper = 0.3
			--	end

				-- Amplify damage
			--	keys.damage = keys.damage * (100 + damage_amplify * distance_taper) / 100
			--end
		--end
	--end

	-- Spiked Carapace damage prevention
	if victim:HasModifier("modifier_imba_spiked_carapace") and keys.damage > 0 then

<<<<<<< HEAD
		-- Nullify damage
		keys.damage = 0

		-- Prevent crit damage notifications
		display_red_crit_number = false
	end

	-- Backtrack dodge
	if victim:HasModifier("modifier_imba_backtrack") and not victim:HasModifier("modifier_imba_backtrack_cooldown") and keys.damage > 0 then

		-- Fetch backtrack's ability handle
		local ability
		for i = 0,15 do
			local this_ability = victim:GetAbilityByIndex(i)
			if this_ability and this_ability:GetName() == "imba_faceless_void_backtrack" then
				ability = this_ability
			end
		end

		-- If the ability wasn't found, do nothing
		if ability then

			local ability_level = ability:GetLevel() - 1

			-- Parameters
			local dodge_chance = ability:GetLevelSpecialValueFor("passive_dodge", ability_level)
			
			-- If backtrack is active, increase dodge chance
			if victim:HasModifier("modifier_imba_backtrack_active") then
				dodge_chance = ability:GetLevelSpecialValueFor("active_dodge", ability_level)
			end

			-- Roll for dodge chance
			if RandomInt(1, 100) <= dodge_chance then

				-- Nullify damage
				keys.damage = 0

				-- Play backtrack particle
				local backtrack_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN, victim)
				ParticleManager:SetParticleControl(backtrack_pfx, 0, victim:GetAbsOrigin())

				-- Prevent crit damage notifications
				display_red_crit_number = false
			end
=======
-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
	print('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
	PrintTable(keys)
	if THINK_TICKS >5 then
		local plyID
		for ind = 0, 20, 1 do
			if string.match(keys.name,playerIdsToNames[ind]) then
				plyID=ind
			end            
		end
		
		for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
			if hero ~= nil then
				local id = hero:GetPlayerOwnerID()
				print("this hero's id" .. tostring(hero:GetPlayerOwnerID()))
				if id == plyID then
					print("this is the DCd hero")
					isDisconnected[id] = hero
				end
			end
		end
		GameRules:SendCustomMessage("<font color='#800000'> " .. tostring(keys.name) .. " has disconnected they will have 5 minutes of gametime (not pauses) before their gold is distributed </font> ", DOTA_TEAM_GOODGUYS, 0)
	end
end

function GameMode:OnConnectFull(keys)
	print ( '[BAREBONES] OnConnectFull' )
	PrintTable(keys)
	isDisconnected[keys.index] = 0
	DisconnectTime[keys.index] = 0
	if DisconnectKicked[keys.index] ~=0 then
		GameRules:SendCustomMessage("<font color='#800000'>A player that abandoned has reconnected. rough... </font> ", DOTA_TEAM_GOODGUYS, 0)
	end
end

function GameMode:OnThink()
	if THINK_TICKS < 160 then
		--print("looked for a hero")
		for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
			PlayerResource:GetPlayerName( hero:GetPlayerID())
			playerIdsToNames[hero:GetPlayerID()] = PlayerResource:GetPlayerName( hero:GetPlayerID())
		end
	end

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if THINK_TICKS == 7 then			
			NUM_GOOD_PLAYERS = 0
			NUM_BAD_PLAYERS = 0
			for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
				if hero ~= nil and hero:IsOwnedByAnyPlayer() then
					print("modifying team gold for" .. hero:GetTeamNumber())
					if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
						NUM_GOOD_PLAYERS = NUM_GOOD_PLAYERS + 1
					elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
						NUM_BAD_PLAYERS = NUM_BAD_PLAYERS + 1
					end
				end
			end
		end

		if GameRules:GetGameTime() ~= LAST_TIME then
			for ind = 0, 11, 1 do
				if isDisconnected[ind]~=0 then
					local hero=isDisconnected[ind]
					DisconnectTime[ind]=DisconnectTime[ind]+1

					if DisconnectTime[ind]>300 then
						GameRules:SendCustomMessage("<font color='#800000'> A player is being removed from the game.</font> ", DOTA_TEAM_GOODGUYS, 0)
						local herogold = hero:GetGold()

						for itemSlot = 0, 11, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
							if hero ~= nil then --checks to make sure the killed unit is not nonexistent.
								local Item = hero:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
								if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
									hero:SetGold(herogold + Item:GetGoldCost(0), true)
									hero:SetGold(0, false)
								end
							end
						end

						local hero_gold_after_sell = hero:GetGold()

						hero:SetGold(0, false)
						hero:SetGold(0, true)
						for _,hero2 in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
							if hero2 ~= nil then
								local id = hero2:GetPlayerOwnerID()
								if id == ind then
									isDisconnected[ind]=hero2
								end
							end
						end

						if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
							NUM_GOOD_PLAYERS = NUM_GOOD_PLAYERS - 1
							hero_gold_divided = hero_gold_after_sell / NUM_GOOD_PLAYERS
							if hero_gold_divided % NUM_GOOD_PLAYERS == 0 then
								for _,hero2 in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
									if hero2 ~= nil then
										if hero2:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
											if isDisconnected[ind]~=0 then
												local id = hero2:GetPlayerOwnerID()
												id_gold = id:GetGold()
												id:SetGold(id_gold + hero_gold_divided, true)
											end
										end
									end
								end
								hero:SetGold(0, false)
								hero:SetGold(0, true)
							end
						elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
							NUM_BAD_PLAYERS = NUM_BAD_PLAYERS - 1
							hero_gold_divided = hero_gold_after_sell / NUM_BAD_PLAYERS
							if hero_gold_divided % NUM_BAD_PLAYERS == 0 then
								for _,hero2 in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
									if hero2 ~= nil then
										if hero2:GetTeamNumber() == DOTA_TEAM_BADGUYS then
											if isDisconnected[ind]~=0 then
												local id = hero2:GetPlayerOwnerID()
												id_gold = id:GetGold()
												id:SetGold(id_gold + hero_gold_divided, true)
											end
										end
									end
								end
								hero:SetGold(0, false)
								hero:SetGold(0, true)
							end
						end

						DisconnectKicked[ind] = 1
					end

					if DisconnectKicked[ind] == 1 then
						if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
							NUM_GOOD_PLAYERS = NUM_GOOD_PLAYERS - 1
							hero_gold_divided = hero_gold_after_sell / NUM_GOOD_PLAYERS
							if hero_gold_divided % NUM_GOOD_PLAYERS == 0 then
								for _,hero2 in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
									if hero2 ~= nil then
										if hero2:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
											if isDisconnected[ind]~=0 then
												local id = hero2:GetPlayerOwnerID()
												id_gold = id:GetGold()
												id:SetGold(id_gold + hero_gold_divided, true)
											end
										end
									end
								end
								hero:SetGold(0, false)
								hero:SetGold(0, true)
							end
						elseif  hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
							NUM_BAD_PLAYERS = NUM_BAD_PLAYERS - 1
							hero_gold_divided = hero_gold_after_sell / NUM_BAD_PLAYERS
							if hero_gold_divided % NUM_BAD_PLAYERS == 0 then
								for _,hero2 in pairs( Entities:FindAllByClassname( "npc_dota_hero*")) do
									if hero2 ~= nil then
										if hero2:GetTeamNumber() == DOTA_TEAM_BADGUYS then
											if isDisconnected[ind]~=0 then
												local id = hero2:GetPlayerOwnerID()
												id_gold = id:GetGold()
												id:SetGold(id_gold + hero_gold_divided, true)
											end
										end
									end
								end
								hero:SetGold(0, false)
								hero:SetGold(0, true)
							end
						end
					end
				end
			end
		end
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
	print("[IMBA] GameRules State Changed")
	PrintTable(keys)

	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
		self.bSeenWaitForPlayers = true
	elseif newState == DOTA_GAMERULES_STATE_INIT then
		Timers:RemoveTimer("alljointimer")
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		local et = 6
		if self.bSeenWaitForPlayers then
			et = .01
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108
		end
	end

<<<<<<< HEAD
	-- Vanguard block
	if victim:HasModifier("modifier_item_vanguard_unique") and damage_type == DAMAGE_TYPE_PHYSICAL and keys.damage > 0 then

		-- If a higher tier of Vanguard-based block is present, do nothing
		if not ( victim:HasModifier("modifier_item_crimson_guard_unique") or victim:HasModifier("modifier_item_crimson_guard_active") or victim:HasModifier("modifier_item_greatwyrm_plate_unique") or victim:HasModifier("modifier_item_greatwyrm_plate_active") ) and not victim:HasModifier("modifier_sheepstick_debuff") then

			local block_sound = "Imba.VanguardBlock"
			local proc_chance = 30
			local damage_block = 30
			local damage_blocked = 0

			-- Roll for a proc
			if RandomInt(1, 100) <= proc_chance then

				-- Play the block sound for damage over a certain threshold
				if keys.damage > (victim:GetMaxHealth() * 0.2) then
					victim:EmitSound(block_sound)
				end

				-- Halve damage
				keys.damage = keys.damage / 2

				-- Store blocked damage
				damage_blocked = damage_blocked + keys.damage

				-- Prevent crit damage notifications
				display_red_crit_number = false
			end

			-- Calculate actual damage
			local actual_damage = math.max(keys.damage - damage_block, 0)

			-- Update blocked damage
			damage_blocked = damage_blocked + keys.damage - actual_damage

			-- Play block message
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, victim, damage_blocked, nil)

			-- Reduce damage
			keys.damage = actual_damage
		end
	end

	-- Crimson Guard block
	if ( victim:HasModifier("modifier_item_crimson_guard_unique") or victim:HasModifier("modifier_item_crimson_guard_active") ) and damage_type == DAMAGE_TYPE_PHYSICAL and keys.damage > 0 then

		-- If a higher tier of Vanguard-based block is present, do nothing
		if not ( victim:HasModifier("modifier_item_greatwyrm_plate_unique") or victim:HasModifier("modifier_item_greatwyrm_plate_active") ) and not victim:HasModifier("modifier_sheepstick_debuff") then

			local block_sound = "Imba.VanguardBlock"
			local proc_chance = 35
			local damage_block = 45
			local damage_blocked = 0

			-- Roll for a proc
			if RandomInt(1, 100) <= proc_chance then

				-- Play the block sound for damage over a certain threshold
				if keys.damage > (victim:GetMaxHealth() * 0.2) then
					victim:EmitSound(block_sound)
				end

				-- Halve damage
				keys.damage = keys.damage / 2

				-- Store blocked damage
				damage_blocked = damage_blocked + keys.damage

				-- Prevent crit damage notifications
				display_red_crit_number = false
			end
=======
-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)

	-- Reaper's Scythe buyback clean-up
	if npc:IsRealHero() then
		npc:SetBuyBackDisabledByReapersScythe(false)
	end
	
	-- First hero spawn function call
	if npc:IsRealHero() and npc.bFirstSpawned == nil then
		npc.bFirstSpawned = true
		GameMode:OnHeroInGame(npc)
	end

	-- Creep bounty adjustment
	if not npc:IsHero() and not npc:IsOwnedByAnyPlayer() then
		local gold_bounty = npc:GetGoldBounty()
		local xp_bounty = npc:GetDeathXP()

		npc:SetDeathXP(math.floor( xp_bounty * 1.3 ))
		npc:SetMaximumGoldBounty(math.floor( gold_bounty * 1.4 ))
		npc:SetMinimumGoldBounty(math.floor( gold_bounty * 1.3 ))
	end
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
--	print("[IMBA] Entity Hurt")
--	PrintTable(keys)
--	local attacker = EntIndexToHScript(keys.entindex_attacker)
--	local victim = EntIndexToHScript(keys.entindex_killed)
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
--	print ( '[IMBA] OnItemPurchased' )
--	PrintTable(keys)

--	local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
--	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
--	local player = PlayerResource:GetPlayer(keys.PlayerID)
--	local itemname = keys.itemname
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)

end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
--	print ( '[IMBA] OnItemPurchased' )
--	PrintTable(keys)

	-- The playerID of the hero who is buying something
--	local plyID = keys.PlayerID
--	if not plyID then return end

	-- The name of the item purchased
--	local itemName = keys.itemname

	-- The cost of the item purchased
--	local itemcost = keys.itemcost
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108

			-- Calculate actual damage
			local actual_damage = math.max(keys.damage - damage_block, 0)

<<<<<<< HEAD
			-- Update blocked damage
			damage_blocked = damage_blocked + keys.damage - actual_damage

			-- Play block message
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, victim, damage_blocked, nil)

			-- Reduce damage
			keys.damage = actual_damage
		end
	end

	-- Greatwyrm plate block
	if ( victim:HasModifier("modifier_item_greatwyrm_plate_unique") or victim:HasModifier("modifier_item_greatwyrm_plate_active") ) and keys.damage > 0 then

		if damage_type == DAMAGE_TYPE_PHYSICAL and not victim:HasModifier("modifier_sheepstick_debuff") then

			local block_sound = "Imba.VanguardBlock"
			local proc_chance = 40
			local damage_block = 60
			local damage_blocked = 0

			-- Roll for a proc
			if RandomInt(1, 100) <= proc_chance then

				-- Play the block sound for damage over a certain threshold
				if keys.damage > (victim:GetMaxHealth() * 0.2) then
					victim:EmitSound(block_sound)
				end

				-- Halve damage
				keys.damage = keys.damage / 2

				-- Store blocked damage
				damage_blocked = damage_blocked + keys.damage

				-- Prevent crit damage notifications
				display_red_crit_number = false
			end

			-- If damage is physical, block part of it
			if damage_type == DAMAGE_TYPE_PHYSICAL then

				-- Calculate actual damage
				local actual_damage = math.max(keys.damage - damage_block, 0)

				-- Update blocked damage
				damage_blocked = damage_blocked + keys.damage - actual_damage

				-- Reduce damage
				keys.damage = actual_damage
			end

			-- If any damage was blocked, play block message
			if damage_blocked > 0 then
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, victim, damage_blocked, nil)
			end
		end
	end

	-- Decrepify damage counter
	if victim.decrepify_damage_counter then
		if damage_type == DAMAGE_TYPE_MAGICAL then
			victim.decrepify_damage_counter = victim.decrepify_damage_counter + keys.damage
		end
	end

	-- Damage overhead display
	if display_red_crit_number then
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, victim, keys.damage, nil)		
	end

	return true
end

--[[
	This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
	It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]

function GameMode:OnAllPlayersLoaded()
	DebugPrint("[IMBA] All Players have loaded into the game")

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player globals initialization
	-------------------------------------------------------------------------------------------------
=======
-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
--	print('[IMBA] AbilityUsed')
--	PrintTable(keys)

--	local player = EntIndexToHScript(keys.PlayerID)
--	local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
--	print('[IMBA] OnNonPlayerUsedAbility')
--	PrintTable(keys)

--	local abilityname = keys.abilityname
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
--	print('[IMBA] OnPlayerChangedName')
--	PrintTable(keys)

--	local newName = keys.newname
--	local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility( keys)
--	print ('[IMBA] OnPlayerLearnedAbility')
--	PrintTable(keys)

--	local player = EntIndexToHScript(keys.player)
--	local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
--	print ('[IMBA] OnAbilityChannelFinished')
--	PrintTable(keys)

--	local abilityname = keys.abilityname
--	local interrupted = keys.interrupted == 1
end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)
--	print ('[IMBA] OnPlayerLevelUp')
--	PrintTable(keys)

--	local player = EntIndexToHScript(keys.player)
--	local level = keys.level
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
--	print ('[IMBA] OnLastHit')
--	PrintTable(keys)

--	local isFirstBlood = keys.FirstBlood == 1
--	local isHeroKill = keys.HeroKill == 1
--	local isTowerKill = keys.TowerKill == 1
--	local player = PlayerResource:GetPlayer(keys.PlayerID)
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
--	print ('[IMBA] OnTreeCut')
--	PrintTable(keys)

--	local treeX = keys.tree_x
--	local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated (keys)
--	print ('[IMBA] OnRuneActivated')
--	PrintTable(keys)

--	local player = PlayerResource:GetPlayer(keys.PlayerID)
--	local rune = keys.rune

	--[[ Rune Can be one of the following types
	DOTA_RUNE_DOUBLEDAMAGE
	DOTA_RUNE_HASTE
	DOTA_RUNE_HAUNTED
	DOTA_RUNE_ILLUSION
	DOTA_RUNE_INVISIBILITY
	DOTA_RUNE_MYSTERY
	DOTA_RUNE_RAPIER
	DOTA_RUNE_REGENERATION
	DOTA_RUNE_SPOOKY
	DOTA_RUNE_TURBO
	]]
end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
--	print ('[IMBA] OnPlayerTakeTowerDamage')
--	PrintTable(keys)

--	local player = PlayerResource:GetPlayer(keys.PlayerID)
--	local damage = keys.damage
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)
--	print ('[IMBA] OnPlayerPickHero')
--	PrintTable(keys)

--	local heroClass = keys.hero
--	local heroEntity = EntIndexToHScript(keys.heroindex)
--	local player = EntIndexToHScript(keys.player)
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
	print ('[IMBA] OnTeamKillCredit')
	PrintTable(keys)
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108

	self.players = {}
	self.heroes = {}

<<<<<<< HEAD
	IMBA_STARTED_TRACKING_CONNECTIONS = true
=======
-- An entity died
function GameMode:OnEntityKilled( keys )
	--print( '[IMBA] OnEntityKilled Called' )
	--PrintTable( keys )
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108

	GOODGUYS_CONNECTED_PLAYERS = 0
	BADGUYS_CONNECTED_PLAYERS = 0

	-- Assign players to the table
	for id = 0, ( IMBA_PLAYERS_ON_GAME - 1 ) do
		self.players[id] = PlayerResource:GetPlayer(id)
		
		if self.players[id] then

			-- Initialize connection state
			self.players[id].connection_state = PlayerResource:GetConnectionState(id)
			print("initialized connection for player "..id..": "..self.players[id].connection_state)

<<<<<<< HEAD
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
		else

			-- If the player never connected, assign it a special string
			if PlayerResource:GetConnectionState(id) == 1 then
				self.players[id] = "empty_player_slot"
				print("player "..id.." never connected")
			end

=======
	-- Sets the game winner if an ancient is destroyed
	if killedUnit:GetName() == "npc_dota_badguys_fort" then
		GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
	elseif killedUnit:GetName() == "npc_dota_goodguys_fort" then
		GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )
	end

	if killedUnit:IsRealHero() then
		print ("KILLED: " .. killedUnit:GetName() .. " -- KILLER: " .. killerEntity:GetName())
		if killedUnit:GetTeam() == DOTA_TEAM_BADGUYS and killerEntity:GetTeam() == DOTA_TEAM_GOODGUYS then
			self.nRadiantKills = self.nRadiantKills + 1
			if END_GAME_ON_KILLS and self.nRadiantKills >= KILLS_TO_END_GAME_FOR_TEAM then
				GameRules:SetSafeToLeave( true )
				GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
			end
			-- Hero kill and assist bounty
			if killerEntity:IsHero() then
				local allies = FindUnitsInRadius(killerEntity:GetTeam(), killedUnit:GetAbsOrigin(), nil, 1300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
				local killer_bounty = 100 + killedUnit:GetLevel() * 10
				local assist_bounty
				if #allies == 1 then
					assist_bounty = 140 + killedUnit:GetLevel() * 7
				elseif #allies == 2 then
					assist_bounty = 110 + killedUnit:GetLevel() * 6
				elseif #allies == 3 then
					assist_bounty = 90 + killedUnit:GetLevel() * 5
				elseif #allies == 4 then
					assist_bounty = 70 + killedUnit:GetLevel() * 4
				else
					assist_bounty = 60 + killedUnit:GetLevel() * 3
				end

				killerEntity:ModifyGold(killer_bounty, true, 0)
				for _,ally in pairs(allies) do
					ally:ModifyGold(assist_bounty, true, 0)
				end
			end

		elseif killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS and killerEntity:GetTeam() == DOTA_TEAM_BADGUYS then
			self.nDireKills = self.nDireKills + 1
			if END_GAME_ON_KILLS and self.nDireKills >= KILLS_TO_END_GAME_FOR_TEAM then
				GameRules:SetSafeToLeave( true )
				GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )
			end

			-- Hero kill and assist bounty
			if killerEntity:IsHero() then
				local allies = FindUnitsInRadius(killerEntity:GetTeam(), killedUnit:GetAbsOrigin(), nil, 1300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
				local killer_bounty = 100 + killedUnit:GetLevel() * 10
				local assist_bounty
				if #allies == 1 then
					assist_bounty = 140 + killedUnit:GetLevel() * 7
				elseif #allies == 2 then
					assist_bounty = 110 + killedUnit:GetLevel() * 6
				elseif #allies == 3 then
					assist_bounty = 90 + killedUnit:GetLevel() * 5
				elseif #allies == 4 then
					assist_bounty = 70 + killedUnit:GetLevel() * 4
				else
					assist_bounty = 60 + killedUnit:GetLevel() * 3
				end

				killerEntity:ModifyGold(killer_bounty, true, 0)
				for _,ally in pairs(allies) do
					ally:ModifyGold(assist_bounty, true, 0)
				end
			end
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Random OMG setup
	-------------------------------------------------------------------------------------------------

	if IMBA_ABILITY_MODE_RANDOM_OMG then

		-- Pick setup
		for id = 0, ( IMBA_PLAYERS_ON_GAME - 1 ) do
			Timers:CreateTimer(0, function()
				--print("attempting to random a hero for player "..id)
				if self.players[id] and self.players[id] ~= "empty_player_slot" then
					PlayerResource:GetPlayer(id):MakeRandomHeroSelection()
					PlayerResource:SetHasRepicked(id)
					PlayerResource:SetHasRandomed(id)
					--print("succesfully randomed a hero for player "..id)
				elseif not self.players[id] then
					--print("player "..id.." still hasn't randomed a hero")
					return 0.5
				end
			end)
		end
	end

<<<<<<< HEAD
	-------------------------------------------------------------------------------------------------
	-- IMBA: All Random setup
	-------------------------------------------------------------------------------------------------

	if IMBA_PICK_MODE_ALL_RANDOM then

		-- Pick setup
		for id = 0, ( IMBA_PLAYERS_ON_GAME - 1 ) do
			Timers:CreateTimer(0, function()
				if self.players[id] and self.players[id] ~= "empty_player_slot" then
					PlayerResource:GetPlayer(id):MakeRandomHeroSelection()
					PlayerResource:SetHasRepicked(id)
					PlayerResource:SetHasRandomed(id)
				elseif not self.players[id] then
					return 0.5
				end
			end)
		end
	end
=======
	-- Reaper's Scythe death timer increase
	if killedUnit.scythe_added_respawn then
		killedUnit:SetTimeUntilRespawn(killedUnit:GetRespawnTime() + killedUnit.scythe_added_respawn)
	end

	-- Tower invulnerability removal
	if killedUnit:GetName() == "npc_dota_goodguys_tower1_top" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_tower2_top" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower1_mid" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_tower2_mid" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower1_bot" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_tower2_bot" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower2_top" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_tower3_top" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower2_mid" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_tower3_mid" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower2_bot" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_tower3_bot" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower3_top" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_melee_rax_top" or name == "npc_dota_goodguys_range_rax_top" or name == "npc_dota_goodguys_tower4" or name == "npc_dota_goodguys_fillers" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower3_mid" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_melee_rax_mid" or name == "npc_dota_goodguys_range_rax_mid" or name == "npc_dota_goodguys_tower4" or name == "npc_dota_goodguys_fillers" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower3_bot" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_melee_rax_bot" or name == "npc_dota_goodguys_range_rax_bot" or name == "npc_dota_goodguys_tower4" or name == "npc_dota_goodguys_fillers" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_goodguys_tower4" then
		local other_t4_killed = true
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_tower4" then
				other_t4_killed = false
			end
		end
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_goodguys_fort" and other_t4_killed then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower1_top" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_tower2_top" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower1_mid" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_tower2_mid" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower1_bot" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_tower2_bot" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower2_top" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_tower3_top" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower2_mid" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_tower3_mid" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower2_bot" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_tower3_bot" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower3_top" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_melee_rax_top" or name == "npc_dota_badguys_range_rax_top" or name == "npc_dota_badguys_tower4" or name == "npc_dota_badguys_fillers" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower3_mid" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_melee_rax_mid" or name == "npc_dota_badguys_range_rax_mid" or name == "npc_dota_badguys_tower4" or name == "npc_dota_badguys_fillers" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower3_bot" then
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_melee_rax_bot" or name == "npc_dota_badguys_range_rax_bot" or name == "npc_dota_badguys_tower4" or name == "npc_dota_badguys_fillers" then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	elseif killedUnit:GetName() == "npc_dota_badguys_tower4" then
		local other_t4_killed = true
		local structures = FindUnitsInRadius(1, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_tower4" then
				other_t4_killed = false
			end
		end
		for _,v in pairs(structures) do
			local name = v:GetName()
			if name == "npc_dota_badguys_fort" and other_t4_killed then
				v:RemoveModifierByName("modifier_invulnerable")
			end
		end
	end
end
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108

	-------------------------------------------------------------------------------------------------
	-- IMBA: Filter setup
	-------------------------------------------------------------------------------------------------

<<<<<<< HEAD
	GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap(GameMode, "BountyRuneFilter"), self )
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap(GameMode, "OrderFilter"), self )
	GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap(GameMode, "DamageFilter"), self )
=======
-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
	GameMode = self
	print('[IMBA] Starting to load Barebones gamemode...')

	-- Setup rules
	GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
	GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
	GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
	GameRules:SetPreGameTime( PRE_GAME_TIME)
	GameRules:SetPostGameTime( POST_GAME_TIME )
	GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
	GameRules:SetUseCustomHeroXPValues ( USE_CUSTOM_XP_VALUES )
	GameRules:SetGoldPerTick(GOLD_PER_TICK)
	GameRules:SetGoldTickTime(GOLD_TICK_TIME)
	GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
	GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
	GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
	GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
	GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )
	print('[IMBA] GameRules set')

	InitLogFile( "log/barebones.txt","")

	-- Event Hooks
	-- All of these events can potentially be fired by the game, though only the uncommented ones have had
	-- Functions supplied for them.  If you are interested in the other events, you can uncomment the
	-- ListenToGameEvent line and add a function to handle the event
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GameMode, 'OnPlayerLevelUp'), self)
	ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(GameMode, 'OnAbilityChannelFinished'), self)
	ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(GameMode, 'OnPlayerLearnedAbility'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(GameMode, 'OnConnectFull'), self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(GameMode, 'OnDisconnect'), self)
	ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(GameMode, 'OnItemPurchased'), self)
	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(GameMode, 'OnItemPickedUp'), self)
	ListenToGameEvent('last_hit', Dynamic_Wrap(GameMode, 'OnLastHit'), self)
	ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(GameMode, 'OnNonPlayerUsedAbility'), self)
	ListenToGameEvent('player_changename', Dynamic_Wrap(GameMode, 'OnPlayerChangedName'), self)
	ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(GameMode, 'OnRuneActivated'), self)
	ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(GameMode, 'OnPlayerTakeTowerDamage'), self)
	ListenToGameEvent('tree_cut', Dynamic_Wrap(GameMode, 'OnTreeCut'), self)
	ListenToGameEvent('entity_hurt', Dynamic_Wrap(GameMode, 'OnEntityHurt'), self)
	ListenToGameEvent('player_connect', Dynamic_Wrap(GameMode, 'PlayerConnect'), self)
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(GameMode, 'OnAbilityUsed'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameMode, 'OnGameRulesStateChange'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, 'OnNPCSpawned'), self)
	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(GameMode, 'OnPlayerPickHero'), self)
	ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(GameMode, 'OnTeamKillCredit'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, 'OnPlayerReconnect'), self)
	--ListenToGameEvent('player_spawn', Dynamic_Wrap(GameMode, 'OnPlayerSpawn'), self)
	--ListenToGameEvent('dota_unit_event', Dynamic_Wrap(GameMode, 'OnDotaUnitEvent'), self)
	--ListenToGameEvent('nommed_tree', Dynamic_Wrap(GameMode, 'OnPlayerAteTree'), self)
	--ListenToGameEvent('player_completed_game', Dynamic_Wrap(GameMode, 'OnPlayerCompletedGame'), self)
	--ListenToGameEvent('dota_match_done', Dynamic_Wrap(GameMode, 'OnDotaMatchDone'), self)
	--ListenToGameEvent('dota_combatlog', Dynamic_Wrap(GameMode, 'OnCombatLogEvent'), self)
	--ListenToGameEvent('dota_player_killed', Dynamic_Wrap(GameMode, 'OnPlayerKilled'), self)
	--ListenToGameEvent('player_team', Dynamic_Wrap(GameMode, 'OnPlayerTeam'), self)
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108

	-------------------------------------------------------------------------------------------------
	-- IMBA: Fountain abilities setup
	-------------------------------------------------------------------------------------------------

	-- Find all buildings on the map
	local buildings = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, 20000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	
	-- Iterate through each one
	for _, building in pairs(buildings) do
		
		-- Parameters
		local building_name = building:GetName()

		-- Identify the fountains
		if string.find(building_name, "fountain") then

			-- Add fountain passive abilities
			building:AddAbility("imba_fountain_buffs")
			building:AddAbility("imba_tower_grievous_wounds")
			local fountain_ability = building:FindAbilityByName("imba_fountain_buffs")
			local swipes_ability = building:FindAbilityByName("imba_tower_grievous_wounds")
			fountain_ability:SetLevel(1)
			swipes_ability:SetLevel(1)
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Selected game mode confirmation messages
	-------------------------------------------------------------------------------------------------

	-- Delay the message a bit so it shows up during hero picks
	Timers:CreateTimer(3, function()

		-- If no options were chosen, use the default ones
		if not GAME_OPTIONS_SET then
			Say(nil, "Host did not select any game options, using the default ones.", false)
		end

		-- Game mode
		local game_mode = "<font color='#FF7800'>ALL PICK</font>"
		if IMBA_PICK_MODE_ALL_RANDOM then
			game_mode = "<font color='#FF7800'>ALL RANDOM</font>"
		elseif IMBA_ABILITY_MODE_RANDOM_OMG then
			game_mode = "<font color='#FF7800'>RANDOM OMG</font>, <font color='#FF7800'>"..IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT.."</font> abilities, <font color='#FF7800'>"..IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT.."</font> ultimates"
			if IMBA_RANDOM_OMG_RANDOMIZE_SKILLS_ON_DEATH then
				game_mode = game_mode..", skills are randomed on every respawn"
			end
		end

		-- Same hero
		local same_hero = ""
		if ALLOW_SAME_HERO_SELECTION then
			same_hero = ", same hero allowed"
		end

		-- Bounties
		local gold_bounty = 100 + CREEP_GOLD_BONUS
		gold_bounty = "<font color='#FF7800'>"..gold_bounty.."%</font>"
		local XP_bounty = 100 + CREEP_XP_BONUS
		XP_bounty = "<font color='#FF7800'>"..XP_bounty.."%</font>"

		-- Respawn
		local respawn_time = HERO_RESPAWN_TIME_MULTIPLIER
		if respawn_time == 100 then
			respawn_time = "<font color='#FF7800'>normal</font> respawn time, "
		elseif respawn_time == 50 then
			respawn_time = "<font color='#FF7800'>half</font> respawn time, "
		elseif respawn_time == 0 then
			respawn_time = "<font color='#FF7800'>zero</font> respawn time, "
		end

		-- Buyback
		local buyback_cooldown = HERO_BUYBACK_COOLDOWN
		if buyback_cooldown == 0 then
			buyback_cooldown = "<font color='#FF7800'>no</font> buyback cooldown."
		else
			buyback_cooldown = "<font color='#FF7800'>"..buyback_cooldown.." seconds</font> buyback cooldown."
		end

		-- Starting gold & level
		local start_status = "Heroes will start with <font color='#FF7800'>"..HERO_INITIAL_GOLD.."</font> gold, at level <font color='#FF7800'>"..HERO_STARTING_LEVEL.."</font>, and can progress up to level <font color='#FF7800'>"..MAX_LEVEL.."</font>."

		-- Creep power ramp
		local creep_power = "Creeps and summons' damage will increase "
		if CREEP_POWER_RAMP_UP_FACTOR == 1 then
			creep_power = creep_power.."at <font color='#FF7800'>normal</font> speed."
		elseif CREEP_POWER_RAMP_UP_FACTOR == 2 then
			creep_power = creep_power.."<font color='#FF7800'>quicker</font> than normal."
		elseif CREEP_POWER_RAMP_UP_FACTOR == 4 then
			creep_power = creep_power.."at <font color='#FF7800'>extreme</font> speed."
		end

		-- Frantic mode
		local frantic_mode = ""
		if FRANTIC_MULTIPLIER > 1 then
			frantic_mode = " <font color='#FF7800'>Frantic mode</font> is activated - cooldowns and mana costs decreased by <font color='#FF7800'>"..FRANTIC_MULTIPLIER.."x</font>."
		end

		-- Tower abilities
		local tower_abilities = ""
		if TOWER_ABILITY_MODE then
			if TOWER_UPGRADE_MODE then
				tower_abilities = "Towers will gain <font color='#FF7800'>upgradable random abilities</font>."
			else
				tower_abilities = "Towers will gain <font color='#FF7800'>random abilities</font>, with abilities being mirrored for both teams."
			end
		end

		-- Kills to end the game
		local kills_to_end = ""
		if END_GAME_ON_KILLS then
			kills_to_end = "<font color='#FF7800'>ARENA MODE:</font> Game will only end when one team reaches <font color='#FF7800'>"..KILLS_TO_END_GAME_FOR_TEAM.."</font> kills."
		end
		
		Say(nil, game_mode..same_hero, false)
		Say(nil, gold_bounty.." gold rate, "..XP_bounty.." experience rate, "..respawn_time..buyback_cooldown, false)
		Say(nil, start_status, false)
		Say(nil, creep_power..frantic_mode, false)
		Say(nil, tower_abilities, false)
		Say(nil, kills_to_end, false)
	end)
end

--[[
	This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
	if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
	levels, changing the starting gold, removing/adding abilities, adding physics, etc.

	The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
	DebugPrint("[IMBA] Hero spawned in game for first time -- " .. hero:GetUnitName())

	-------------------------------------------------------------------------------------------------
	-- IMBA: First hero spawn initialization
	-------------------------------------------------------------------------------------------------

	-- Update the player's hero if it was picked or changed
	local player = PlayerResource:GetPlayer(hero:GetPlayerID())

	if player and self.players[player:GetPlayerID()] and self.players[player:GetPlayerID()] ~= "empty_player_slot" and not self.heroes[player:GetPlayerID()] then
		self.heroes[player:GetPlayerID()] = hero
	elseif player and self.players[player:GetPlayerID()] and self.players[player:GetPlayerID()] ~= "empty_player_slot" and self.heroes[player:GetPlayerID()] and ( self.heroes[player:GetPlayerID()]:GetName() ~= hero:GetName() ) then
		self.heroes[player:GetPlayerID()] = hero
	end

<<<<<<< HEAD
	-- Check if this function was already performed
	if not player then
		return nil
	elseif player.already_spawned then
		return nil
	end

	--If not, flag it as being done
	player.already_spawned = true

	-- Create kill and death streak and buyback globals
	hero.kill_streak_count = 0
	hero.death_streak_count = 0
	hero.buyback_count = 0

	-- Add frantic mode passive buff
	if FRANTIC_MULTIPLIER > 1 then
		hero:AddAbility("imba_frantic_buff")
		ability_frantic = hero:FindAbilityByName("imba_frantic_buff")
		ability_frantic:SetLevel(1)
=======
	print('[IMBA] Done loading Barebones gamemode!\n\n')
end

mode = nil

-- This function is called as the first player loads and sets up the GameMode parameters
function GameMode:CaptureGameMode()
	if mode == nil then
		-- Set GameMode parameters
		mode = GameRules:GetGameModeEntity()
		mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
		mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
		mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
		mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
		mode:SetBuybackEnabled( BUYBACK_ENABLED )
		mode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
		mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
		mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
		mode:SetCustomHeroMaxLevel ( MAX_LEVEL )
		mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

		--mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
		mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

		mode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
		mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
		mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )

		self:OnFirstPlayerLoaded()
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108
	end

<<<<<<< HEAD
	-- Set up initial level
	if HERO_STARTING_LEVEL > 1 then
		Timers:CreateTimer(1, function()
			hero:AddExperience(XP_PER_LEVEL_TABLE[HERO_STARTING_LEVEL], DOTA_ModifyXP_CreepKill, false, true)
		end)
	end

	-- Set up initial gold
	local has_randomed = PlayerResource:HasRandomed(hero:GetPlayerID())
	local has_repicked = PlayerResource:HasRepicked(hero:GetPlayerID())

	if has_repicked then
		hero:SetGold(HERO_INITIAL_REPICK_GOLD, false)
	elseif has_randomed then
		hero:SetGold(HERO_INITIAL_RANDOM_GOLD, false)
	else
		hero:SetGold(HERO_INITIAL_GOLD, false)
	end

	if IMBA_ABILITY_MODE_RANDOM_OMG then

		-- Set initial gold for the mode 
		hero:SetGold(HERO_INITIAL_RANDOM_GOLD, false)

		-- Randomize abilities
		ApplyAllRandomOmgAbilities(hero)
	end

	if IMBA_PICK_MODE_ALL_RANDOM then
=======
-- This function is called 1 to 2 times as the player connects initially but before they
-- have completely connected
function GameMode:PlayerConnect(keys)
	print('[IMBA] PlayerConnect')
	PrintTable(keys)
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108

		-- Set initial gold for the mode 
		hero:SetGold(HERO_INITIAL_RANDOM_GOLD, false)
	end

	-- Set up initial hero kill gold bounty
	local gold_bounty = HERO_KILL_GOLD_BASE + HERO_KILL_GOLD_PER_LEVEL

	-- Multiply bounty by the lobby options
	gold_bounty = gold_bounty * ( 100 + HERO_GOLD_BONUS ) / 100

	-- Update the hero's bounty
	hero:SetMinimumGoldBounty(gold_bounty)
	hero:SetMaximumGoldBounty(gold_bounty)

	-- Set up initial hero kill XP bounty
	local xp_bounty = HERO_KILL_XP_CONSTANT_1

	-- Multiply bounty by the lobby options
	xp_bounty = xp_bounty * ( 100 + HERO_XP_BONUS ) / 100
	hero:SetDeathXP(xp_bounty)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Initialize innate hero abilities
	-------------------------------------------------------------------------------------------------

	InitializeInnateAbilities(hero)

end

<<<<<<< HEAD
--[[
	This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
	gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
	is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
	DebugPrint("[IMBA] The game has officially begun")

	-------------------------------------------------------------------------------------------------
	-- IMBA: Game time tracker
	-------------------------------------------------------------------------------------------------
	
	Timers:CreateTimer(5, function()
		GAME_TIME_ELAPSED = GAME_TIME_ELAPSED + 5
		return 5
	end)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Structure bounty/stats setup
	-------------------------------------------------------------------------------------------------

	-- Find all buildings on the map
	local buildings = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, 20000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	
	-- Iterate through each one
	for _, building in pairs(buildings) do
		
		-- Parameters
		local building_name = building:GetName()
		local special_building = true
		local max_bounty = building:GetMaximumGoldBounty()
		local min_bounty = building:GetMinimumGoldBounty()
		local xp_bounty = building:GetDeathXP()

		-- Identify the building type
		if string.find(building_name, "tower") then

			-- Set up base bounties
			min_bounty = TOWER_MINIMUM_GOLD
			max_bounty = TOWER_MAXIMUM_GOLD
			xp_bounty = TOWER_EXPERIENCE

		elseif string.find(building_name, "rax_melee") then

			-- Set up base bounties
			min_bounty = MELEE_RAX_MINIMUM_GOLD
			max_bounty = MELEE_RAX_MAXIMUM_GOLD
			xp_bounty = MELEE_RAX_EXPERIENCE

		elseif string.find(building_name, "rax_range") then

			-- Set up base bounties
			min_bounty = RANGED_RAX_MINIMUM_GOLD
			max_bounty = RANGED_RAX_MAXIMUM_GOLD
			xp_bounty = RANGED_RAX_EXPERIENCE

		elseif string.find(building_name, "fort") then

			-- Add passive buff
			building:AddAbility("imba_ancient_buffs")
			local ancient_ability = building:FindAbilityByName("imba_ancient_buffs")
			ancient_ability:SetLevel(1)

			if TOWER_ABILITY_MODE then

				-- Add Poison Nova ability
				building:AddAbility("venomancer_poison_nova")
				ancient_ability = building:FindAbilityByName("venomancer_poison_nova")
				ancient_ability:SetLevel(1)

				-- Add Overgrowth ability
				building:AddAbility("treant_overgrowth")
				ancient_ability = building:FindAbilityByName("treant_overgrowth")
				ancient_ability:SetLevel(1)

				-- Add Eye of the Storm ability
				building:AddAbility("razor_eye_of_the_storm")
				ancient_ability = building:FindAbilityByName("razor_eye_of_the_storm")
				ancient_ability:SetLevel(1)

				-- Add Borrowed Time ability
				building:AddAbility("abaddon_borrowed_time")
				ancient_ability = building:FindAbilityByName("abaddon_borrowed_time")
				ancient_ability:SetLevel(1)

				-- Add Ravage ability
				building:AddAbility("tidehunter_ravage")
				ancient_ability = building:FindAbilityByName("tidehunter_ravage")
				ancient_ability:SetLevel(1)
			end

		elseif string.find(building_name, "fountain") then
			-- Do nothing (fountain was already modified previously)
		else

			-- Flag this building as non-tower, non-rax
			special_building = false
		end
		
		-- Update XP bounties
		building:SetDeathXP( math.floor( xp_bounty * ( 1 + CREEP_XP_BONUS / 100 ) ) )

		-- Update gold bounties
		if special_building then
			building:SetMaximumGoldBounty( math.floor( max_bounty * CREEP_GOLD_BONUS / 100 ) )
			building:SetMinimumGoldBounty( math.floor( min_bounty * CREEP_GOLD_BONUS / 100 ) )
		else
			building:SetMaximumGoldBounty( math.floor( max_bounty * ( 1 + CREEP_GOLD_BONUS / 100 ) ) )
			building:SetMinimumGoldBounty( math.floor( min_bounty * ( 1 + CREEP_GOLD_BONUS / 100 ) ) )
		end
	end
=======
-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
	print ('[IMBA] OnConnectFull')
	PrintTable(keys)
	GameMode:CaptureGameMode()
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108

	-------------------------------------------------------------------------------------------------
	-- IMBA: Tower abilities setup
	-------------------------------------------------------------------------------------------------

	if TOWER_ABILITY_MODE then
		
		-- Safelane towers
		for i = 1, 3 do
			
			-- Find safelane towers
			local radiant_tower_loc = Entities:FindByName(nil, "radiant_safe_tower_t"..i):GetAbsOrigin()
			local dire_tower_loc = Entities:FindByName(nil, "dire_safe_tower_t"..i):GetAbsOrigin()
			local radiant_tower = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, radiant_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			local dire_tower = FindUnitsInRadius(DOTA_TEAM_BADGUYS, dire_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			radiant_tower = radiant_tower[1]
			dire_tower = dire_tower[1]

			-- Store the towers' tier
			radiant_tower.tower_tier = i
			dire_tower.tower_tier = i

			-- Random an ability from the list
			local ability_name = GetRandomTowerAbility(i)

			-- Add and level up the ability
			radiant_tower:AddAbility(ability_name)
			dire_tower:AddAbility(ability_name)
			local radiant_ability = radiant_tower:FindAbilityByName(ability_name)
			local dire_ability = dire_tower:FindAbilityByName(ability_name)
			radiant_ability:SetLevel(1)
			dire_ability:SetLevel(1)
		end

		-- Mid towers
		for i = 1, 3 do
			
			-- Find mid towers
			local radiant_tower_loc = Entities:FindByName(nil, "radiant_mid_tower_t"..i):GetAbsOrigin()
			local dire_tower_loc = Entities:FindByName(nil, "dire_mid_tower_t"..i):GetAbsOrigin()
			local radiant_tower = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, radiant_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			local dire_tower = FindUnitsInRadius(DOTA_TEAM_BADGUYS, dire_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			radiant_tower = radiant_tower[1]
			dire_tower = dire_tower[1]

			-- Store the towers' tier
			radiant_tower.tower_tier = i
			dire_tower.tower_tier = i

			-- Random an ability from the list
			local ability_name = GetRandomTowerAbility(i)

			-- Add and level up the ability
			radiant_tower:AddAbility(ability_name)
			dire_tower:AddAbility(ability_name)
			local radiant_ability = radiant_tower:FindAbilityByName(ability_name)
			local dire_ability = dire_tower:FindAbilityByName(ability_name)
			radiant_ability:SetLevel(1)
			dire_ability:SetLevel(1)
		end

		-- Hardlane towers
		for i = 1, 3 do
			
			-- Find hardlane towers
			local radiant_tower_loc = Entities:FindByName(nil, "radiant_hard_tower_t"..i):GetAbsOrigin()
			local dire_tower_loc = Entities:FindByName(nil, "dire_hard_tower_t"..i):GetAbsOrigin()
			local radiant_tower = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, radiant_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			local dire_tower = FindUnitsInRadius(DOTA_TEAM_BADGUYS, dire_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			radiant_tower = radiant_tower[1]
			dire_tower = dire_tower[1]

			-- Store the towers' tier
			radiant_tower.tower_tier = i
			dire_tower.tower_tier = i

			-- Random an ability from the list
			local ability_name = GetRandomTowerAbility(i)

			-- Add and level up the ability
			radiant_tower:AddAbility(ability_name)
			dire_tower:AddAbility(ability_name)
			local radiant_ability = radiant_tower:FindAbilityByName(ability_name)
			local dire_ability = dire_tower:FindAbilityByName(ability_name)
			radiant_ability:SetLevel(1)
			dire_ability:SetLevel(1)
		end

		-- Tier 4s
		local radiant_left_t4_loc = Entities:FindByName(nil, "radiant_left_tower_t4"):GetAbsOrigin()
		local radiant_right_t4_loc = Entities:FindByName(nil, "radiant_right_tower_t4"):GetAbsOrigin()
		local dire_left_t4_loc = Entities:FindByName(nil, "dire_left_tower_t4"):GetAbsOrigin()
		local dire_right_t4_loc = Entities:FindByName(nil, "dire_right_tower_t4"):GetAbsOrigin()
		local radiant_left_t4 = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, radiant_left_t4_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		local radiant_right_t4 = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, radiant_right_t4_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		local dire_left_t4 = FindUnitsInRadius(DOTA_TEAM_BADGUYS, dire_left_t4_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		local dire_right_t4 = FindUnitsInRadius(DOTA_TEAM_BADGUYS, dire_right_t4_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		radiant_left_t4 = radiant_left_t4[1]
		radiant_right_t4 = radiant_right_t4[1]
		dire_left_t4 = dire_left_t4[1]
		dire_right_t4 = dire_right_t4[1]

		-- Store the towers' tier
		radiant_left_t4.tower_tier = 4
		radiant_right_t4.tower_tier = 4
		dire_left_t4.tower_tier = 4
		dire_right_t4.tower_tier = 4

		-- Add and level up the multishot ability
		local multishot_ability = "imba_tower_multishot"
		radiant_left_t4:AddAbility(multishot_ability)
		dire_left_t4:AddAbility(multishot_ability)
		radiant_right_t4:AddAbility(multishot_ability)
		dire_right_t4:AddAbility(multishot_ability)
		local radiant_left_ability = radiant_left_t4:FindAbilityByName(multishot_ability)
		local dire_left_ability = dire_left_t4:FindAbilityByName(multishot_ability)
		local radiant_right_ability = radiant_right_t4:FindAbilityByName(multishot_ability)
		local dire_right_ability = dire_right_t4:FindAbilityByName(multishot_ability)
		radiant_left_ability:SetLevel(1)
		dire_left_ability:SetLevel(1)
		radiant_right_ability:SetLevel(1)
		dire_right_ability:SetLevel(1)
	end

end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
	GameMode = self
	DebugPrint('[IMBA] Started loading Dota IMBA...')

	-- Call the internal function to set up the rules/behaviors specified in constants.lua
	-- This also sets up event hooks for all event handlers in events.lua
	-- Check out internals/gamemode to see/modify the exact code
	GameMode:_InitGameMode()

	-- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
	Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )

	DebugPrint('[IMBA] Finished loading Dota IMBA!\n\n')
end

-- This is an example console command
function GameMode:ExampleConsoleCommand()
	print( '******* Example Console Command ***************' )
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer then
		local playerID = cmdPlayer:GetPlayerID()
		if playerID ~= nil and playerID ~= -1 then
			-- Do something here for the player who called this command
			PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
		end
	end

	print( '*********************************************' )
end
