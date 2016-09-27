-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode


-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output

BAREBONES_DEBUG_SPEW = false

if GameMode == nil then
	DebugPrint( '[IMBA] creating game mode' )
	_G.GameMode = class({})
end

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

	This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
	time, you can call the functions individually (for example if you want to precache units in a new wave of
	holdout).

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
	-- IMBA: Random OMG forced hero selection
	-------------------------------------------------------------------------------------------------
	if IMBA_ABILITY_MODE_RANDOM_OMG then
		GameRules:SetSameHeroSelectionEnabled(true)
		GameRules:GetGameModeEntity():SetCustomGameForceHero(RANDOM_OMG_HEROES[tostring(RandomInt(1, 90))])
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Contributor models
	-------------------------------------------------------------------------------------------------

	--local contributor_locations = {}
	--for i = 1, 9 do
	--	contributor_locations[i] = Entities:FindByName(nil, "contributor_location_0"..i):GetAbsOrigin()
	--end
	--for i = 10, 30 do
	--	contributor_locations[i] = Entities:FindByName(nil, "contributor_location_"..i):GetAbsOrigin()
	--end

	-- Martyn Garcia
	--local current_position = table.remove(contributor_locations, RandomInt(1, 30))
	--local martyn_model = CreateUnitByName("npc_imba_contributor_martyn", current_position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	--martyn_model:SetForwardVector(RandomVector(100))

	-- Mikkel Garcia
	--current_position = table.remove(contributor_locations, RandomInt(1, 29))
	--local mikkel_model = CreateUnitByName("npc_imba_contributor_mikkel", current_position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	--mikkel_model:SetForwardVector(RandomVector(100))

	-- Hjort
	--current_position = table.remove(contributor_locations, RandomInt(1, 28))
	--local hjort_model = CreateUnitByName("npc_imba_contributor_hjort", current_position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	--hjort_model:SetForwardVector(RandomVector(100))

	-- Anees
	--current_position = table.remove(contributor_locations, RandomInt(1, 27))
	--local anees_model = CreateUnitByName("npc_imba_contributor_anees", current_position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	--anees_model:SetForwardVector(RandomVector(100))

	-- Swizard
	--current_position = table.remove(contributor_locations, RandomInt(1, 26))
	--local swizard_model = CreateUnitByName("npc_imba_contributor_swizard", current_position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	--swizard_model:SetForwardVector(RandomVector(100))

	-- Phroureo
	--current_position = table.remove(contributor_locations, RandomInt(1, 25))
	--local phroureo_model = CreateUnitByName("npc_imba_contributor_phroureo", current_position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	--phroureo_model:SetForwardVector(RandomVector(100))

	-- Catchy
	--current_position = table.remove(contributor_locations, RandomInt(1, 24))
	--local catchy_model = CreateUnitByName("npc_imba_contributor_catchy", current_position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	--catchy_model:SetForwardVector(RandomVector(100))

	-- Hewdraw
	--current_position = table.remove(contributor_locations, RandomInt(1, 23))
	--local hewdraw_model = CreateUnitByName("npc_imba_contributor_hewdraw", current_position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	--hewdraw_model:SetForwardVector(RandomVector(100))

	-- Zimber
	--current_position = table.remove(contributor_locations, RandomInt(1, 22))
	--local zimber_model = CreateUnitByName("npc_imba_contributor_zimber", current_position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	--zimber_model:SetForwardVector(RandomVector(100))

	-- Matt
	--current_position = table.remove(contributor_locations, RandomInt(1, 21))
	--local matt_model = CreateUnitByName("npc_imba_contributor_matt", current_position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	--matt_model:SetForwardVector(RandomVector(100))

	-- Maxime
	--current_position = table.remove(contributor_locations, RandomInt(1, 20))
	--local maxime_model = CreateUnitByName("npc_imba_contributor_maxime", current_position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	--maxime_model:SetForwardVector(RandomVector(100))

end

-- Multiplies bounty rune experience and gold according to the gamemode multiplier
function GameMode:BountyRuneFilter( keys )

	--player_id_const	 ==> 	0
	--xp_bounty	 ==> 	136.5
	--gold_bounty	 ==> 	132.6

	keys["gold_bounty"] = ( 100 + CREEP_GOLD_BONUS ) / 100 * keys["gold_bounty"]
	keys["xp_bounty"] = ( 100 + CREEP_XP_BONUS ) / 100 * keys["xp_bounty"]

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

	local units = keys["units"]
	local unit = EntIndexToHScript(units["0"])

	-- Queen of Pain's Sonic Wave confusion
	if unit:HasModifier("modifier_imba_sonic_wave_daze") then

		-- Determine order type
		local rand = math.random
			
		-- Change "move to target" to "move to position"
		if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
			local target = EntIndexToHScript(keys["entindex_target"])
			local target_loc = target:GetAbsOrigin()
			keys.position_x = target_loc.x
			keys.position_y = target_loc.y
			keys.position_z = target_loc.z
			keys.entindex_target = 0
			keys.order_type = DOTA_UNIT_ORDER_MOVE_TO_POSITION
		end

		-- Change "attack target" to "attack move"
		if keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
			local target = EntIndexToHScript(keys["entindex_target"])
			local target_loc = target:GetAbsOrigin()
			keys.position_x = target_loc.x
			keys.position_y = target_loc.y
			keys.position_z = target_loc.z
			keys.entindex_target = 0
			keys.order_type = DOTA_UNIT_ORDER_ATTACK_MOVE
		end

		-- Change "cast on target" target
		if keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET or keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET_TREE then
			
			local target = EntIndexToHScript(keys["entindex_target"])
			local caster_loc = unit:GetAbsOrigin()
			local target_loc = target:GetAbsOrigin()
			local target_distance = (target_loc - caster_loc):Length2D()
			local found_new_target = false
			local nearby_units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, caster_loc, nil, target_distance, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
			if #nearby_units >= 1 then
				keys.entindex_target = nearby_units[1]:GetEntityIndex()

			-- If no target was found, change to "cast on position" order
			else
				keys.position_x = target_loc.x
				keys.position_y = target_loc.y
				keys.position_z = target_loc.z
				keys.entindex_target = 0
				keys.order_type = DOTA_UNIT_ORDER_CAST_POSITION
			end
		end

		-- Spin positional orders a random angle
		if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or keys.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE or keys.order_type == DOTA_UNIT_ORDER_CAST_POSITION then
			
			-- Calculate new order position
			local target_loc = Vector(keys.position_x, keys.position_y, keys.position_z)
			local origin_loc = unit:GetAbsOrigin()
			local order_vector = target_loc - origin_loc
			local new_order_vector = RotatePosition(origin_loc, QAngle(0, rand(45, 315), 0), origin_loc + order_vector)

			-- Override order
			keys.position_x = new_order_vector.x
			keys.position_y = new_order_vector.y
			keys.position_z = new_order_vector.z
		end
	end

	return true
end

-- Damage filter function
function GameMode:DamageFilter( keys )

	--damagetype_const
	--damage
	--entindex_attacker_const
	--entindex_victim_const

	local attacker
	local victim

	if keys.entindex_attacker_const and keys.entindex_victim_const then
		attacker = EntIndexToHScript(keys.entindex_attacker_const)
		victim = EntIndexToHScript(keys.entindex_victim_const)
	else
		return false
	end

	local damage_type = keys.damagetype_const
	local display_red_crit_number = false

	-- Lack of entities handling
	if not attacker or not victim then
		return false
	end

	-- Orchid spell crit
	if attacker:HasModifier("modifier_item_imba_orchid_unique") then

		-- If damage is physical, or owner has a Bloodthorn, do nothing
		if (damage_type == DAMAGE_TYPE_MAGICAL or damage_type == DAMAGE_TYPE_PURE) and not attacker:HasModifier("modifier_item_imba_bloodthorn_unique") then
			
			-- Parameters
			local crit_chance = 40
			local crit_damage = 175
			local distance_taper_start = 2500

			-- Check for a valid target
			if not (victim:IsBuilding() or victim:IsTower() or victim:GetTeam() == attacker:GetTeam()) then

				-- Ignore crit beyond the effect threshold
				local distance = ( victim:GetAbsOrigin() - attacker:GetAbsOrigin() ):Length2D()
				local target_too_far = false
				if distance > distance_taper_start then
					target_too_far = true
				end

				-- Roll for crit chance
				if RandomInt(1, 100) <= crit_chance and not target_too_far then
					keys.damage = keys.damage * crit_damage / 100
					display_red_crit_number = true
				end
			end
		end
	end

	-- Bloodthorn spell crit
	if attacker:HasModifier("modifier_item_imba_bloodthorn_unique") then

		-- If damage is physical, do nothing
		if damage_type == DAMAGE_TYPE_MAGICAL or damage_type == DAMAGE_TYPE_PURE then
			
			-- Parameters
			local crit_chance = 40
			local crit_damage = 175
			local distance_taper_start = 2500

			-- Check for a valid target
			if not (victim:IsBuilding() or victim:IsTower() or victim:GetTeam() == attacker:GetTeam()) then

				-- Ignore crit beyond the effect threshold
				local distance = ( victim:GetAbsOrigin() - attacker:GetAbsOrigin() ):Length2D()
				local target_too_far = false
				if distance > distance_taper_start then
					target_too_far = true
				end

				-- Roll for crit chance
				if RandomInt(1, 100) <= crit_chance and not target_too_far then
					keys.damage = keys.damage * crit_damage / 100
					display_red_crit_number = true
				end
			end
		end
	end

	-- Bloodthorn active crit
	if victim:HasModifier("modifier_item_imba_bloodthorn_debuff") then

		-- Multiply damage and flag for a crit
		local target_crit_multiplier = 145
		keys.damage = keys.damage * target_crit_multiplier / 100
		display_red_crit_number = true
	end

	-- Rapier damage amplification
	if attacker:HasModifier("modifier_item_imba_rapier_stacks_magic") then

		-- If the target is Roshan, a building, or an ally, or this was an autoattack, do nothing
		if not ( victim:IsBuilding() or IsRoshan(victim) or victim:GetTeam() == attacker:GetTeam() or attacker:IsInvulnerable() or attacker:IsOutOfGame() or victim:HasModifier("modifier_item_imba_rapier_prevent_attack_amp") ) then
			
			-- Calculate damage amplification
			local damage_amp = 0
			local amp_stacks = attacker:GetModifierStackCount("modifier_item_imba_rapier_stacks_magic", attacker)

			-- Fetch appropriate stacks
			if damage_type == DAMAGE_TYPE_PHYSICAL then
				damage_amp = 40 + 40 * amp_stacks
			elseif damage_type == DAMAGE_TYPE_MAGICAL then
				damage_amp = 40 + 40 * amp_stacks
			elseif damage_type == DAMAGE_TYPE_PURE then
				damage_amp = 15 + 15 * amp_stacks
			end

			-- Reduce damage amplification if the target is too far away
			local distance = ( victim:GetAbsOrigin() - attacker:GetAbsOrigin() ):Length2D()
			if distance > 2500 then
				damage_amp = 0
			end

			-- Amplify damage
			keys.damage = keys.damage * (100 + damage_amp) / 100
		end
	end

	-- Spiked Carapace damage prevention
	if victim:HasModifier("modifier_imba_spiked_carapace") and keys.damage > 0 then

		-- Nullify damage
		keys.damage = 0

		-- Prevent crit damage notifications
		display_red_crit_number = false
	end

	-- Vanguard block
	if victim:HasModifier("modifier_item_vanguard_unique") and keys.damage > 0 then

		-- If a higher tier of Vanguard-based block is present, do nothing
		if not ( victim:HasModifier("modifier_item_crimson_guard_unique") or victim:HasModifier("modifier_item_crimson_guard_active") or victim:HasModifier("modifier_item_greatwyrm_plate_unique") or victim:HasModifier("modifier_item_greatwyrm_plate_active") ) and not victim:HasModifier("modifier_sheepstick_debuff") then

			-- Reduce damage
			if victim:GetTeam() ~= attacker:GetTeam() then
				keys.damage = keys.damage * 0.94
			end

			-- Physical damage block
			if damage_type == DAMAGE_TYPE_PHYSICAL and not attacker:IsBuilding() and not attacker:GetUnitName() == "witch_doctor_death_ward" then

				-- Calculate damage block
				local damage_block = 0 + victim:GetLevel()

				-- Calculate actual damage
				local actual_damage = math.max(keys.damage - damage_block, 0)

				-- Calculate actually blocked damage
				local damage_blocked = keys.damage - actual_damage

				-- Play block message
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, victim, damage_blocked, nil)

				-- Reduce damage
				keys.damage = actual_damage
			end
		end
	end

	-- Crimson Guard block
	if ( victim:HasModifier("modifier_item_crimson_guard_unique") or victim:HasModifier("modifier_item_crimson_guard_active") ) and keys.damage > 0 then

		-- If a higher tier of Vanguard-based block is present, do nothing
		if not ( victim:HasModifier("modifier_item_greatwyrm_plate_unique") or victim:HasModifier("modifier_item_greatwyrm_plate_active") ) and not victim:HasModifier("modifier_sheepstick_debuff") then

			-- Reduce damage
			if victim:GetTeam() ~= attacker:GetTeam() then
				keys.damage = keys.damage * 0.91
			end

			-- Physical damage block
			if damage_type == DAMAGE_TYPE_PHYSICAL and not attacker:IsBuilding() and not attacker:GetUnitName() == "witch_doctor_death_ward" then

				-- Calculate damage block
				local damage_block = 5 + victim:GetLevel()

				-- Calculate actual damage
				local actual_damage = math.max(keys.damage - damage_block, 0)

				-- Calculate actually blocked damage
				local damage_blocked = keys.damage - actual_damage

				-- Play block message
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, victim, damage_blocked, nil)

				-- Reduce damage
				keys.damage = actual_damage
			end
		end
	end

	-- Greatwyrm plate block
	if ( victim:HasModifier("modifier_item_greatwyrm_plate_unique") or victim:HasModifier("modifier_item_greatwyrm_plate_active") ) and keys.damage > 0 and not victim:HasModifier("modifier_sheepstick_debuff") then

		-- Reduce damage
		if victim:GetTeam() ~= attacker:GetTeam() then
			keys.damage = keys.damage * 0.88
		end

		-- Physical damage block
		if damage_type == DAMAGE_TYPE_PHYSICAL and not attacker:IsBuilding() and not attacker:GetUnitName() == "witch_doctor_death_ward" then

			-- Calculate damage block
			local damage_block = 10 + victim:GetLevel()

			-- Calculate actual damage
			local actual_damage = math.max(keys.damage - damage_block, 0)

			-- Calculate actually blocked damage
			local damage_blocked = keys.damage - actual_damage

			-- Play block message
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, victim, damage_blocked, nil)

			-- Reduce damage
			keys.damage = actual_damage
		end
	end

	-- Return damage prevention
	if victim:HasModifier("modifier_imba_centaur_return") then

		-- Parameters
		local ability = victim:FindAbilityByName("imba_centaur_return")
		local damage_ignore = ability:GetLevelSpecialValueFor("dmg_ignore", ability:GetLevel() - 1)

		-- Ignore part of incoming damage
		if keys.damage > damage_ignore then
			keys.damage = keys.damage - damage_ignore
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, victim, damage_ignore, nil)
		else
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, victim, keys.damage, nil)
			keys.damage = 0
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

	-- Reaper's Scythe kill credit logic
	if victim:HasModifier("modifier_imba_reapers_scythe") then
		
		-- Check if this is the killing blow
		local victim_health = victim:GetHealth()
		if keys.damage >= victim_health then

			-- Prevent death and trigger Reaper's Scythe's on-kill effects
			local scythe_modifier = victim:FindModifierByName("modifier_imba_reapers_scythe")
			local scythe_caster = false
			if scythe_modifier then
				scythe_caster = scythe_modifier:GetCaster()
			end
			if scythe_caster and attacker ~= scythe_caster then
				keys.damage = 0
				TriggerNecrolyteReaperScytheDeath(victim, scythe_caster)
			end
		end
	end

	-- Reincarnation death prevention
	if victim:HasModifier("modifier_imba_reincarnation") or victim:HasModifier("modifier_imba_reincarnation_scepter") then

		-- Check if death is imminent
		local victim_health = victim:GetHealth()
		if keys.damage >= victim_health and not (victim:HasModifier("modifier_imba_shallow_grave") or victim:HasModifier("modifier_imba_shallow_grave_passive")) then

			-- If this unit is reincarnation's owner and it is off cooldown, trigger reincarnation sequence
			if victim:HasModifier("modifier_imba_reincarnation") then
				local reincarnation_ability = victim:FindAbilityByName("imba_wraith_king_reincarnation")
				if reincarnation_ability and reincarnation_ability:IsCooldownReady() then

					-- Prevent death
					keys.damage = 0

					-- Trigger Reincarnation
					TriggerWraithKingReincarnation(victim, reincarnation_ability)

					-- Exit
					return true
				end
			end
			
			-- Else, trigger Wraith Form
			if victim:HasModifier("modifier_imba_reincarnation_scepter") then
				keys.damage = 0
				TriggerWraithKingWraithForm(victim, attacker)
				return true
			end
		end
	end

	-- Aegis death prevention
	if victim:HasModifier("modifier_item_imba_aegis") then

		-- Check if death is imminent
		local victim_health = victim:GetHealth()
		if keys.damage >= victim_health and not (victim:HasModifier("modifier_imba_shallow_grave") or victim:HasModifier("modifier_imba_shallow_grave_passive")) then
			
			-- Prevent death
			keys.damage = 0

			-- Trigger the Aegis
			TriggerAegisReincarnation(victim)

			-- Exit
			return true
		end
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

	self.players = {}
	self.heroes = {}

	IMBA_STARTED_TRACKING_CONNECTIONS = true

	GOODGUYS_CONNECTED_PLAYERS = 0
	BADGUYS_CONNECTED_PLAYERS = 0

	-- Assign players to the table
	for id = 0, ( IMBA_PLAYERS_ON_GAME - 1 ) do
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
		else

			-- If the player never connected, assign it a special string
			if PlayerResource:GetConnectionState(id) == 1 then
				self.players[id] = "empty_player_slot"
				print("player "..id.." never connected")
			end

		end
	end

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

	-------------------------------------------------------------------------------------------------
	-- IMBA: Filter setup
	-------------------------------------------------------------------------------------------------

	GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap(GameMode, "BountyRuneFilter"), self )
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap(GameMode, "OrderFilter"), self )
	GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap(GameMode, "DamageFilter"), self )

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
		elseif string.find(building_name, "tower") then
			building:SetDayTimeVisionRange(1900)
			building:SetNightTimeVisionRange(800)
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Banned player message
	-------------------------------------------------------------------------------------------------

	if IS_BANNED_PLAYER then
		Timers:CreateTimer(1, function()
			Say(nil, "<font color='#FF0000'>Baumi</font> detected, game will not start. Please disconnect.", false)
		end)
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
			game_mode = "<font color='#FF7800'>RANDOM OMG</font>, <font color='#FF7800'>"..IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT.."</font> abilities, <font color='#FF7800'>"..IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT.."</font> ultimates, skills are randomed on every respawn"
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

		-- Creep power setting
		local creep_power = "Lane creeps' power is set to "
		if CREEP_POWER_FACTOR == 1 then
			creep_power = creep_power.."<font color='#FF7800'>normal</font>,"
		elseif CREEP_POWER_FACTOR == 2 then
			creep_power = creep_power.."<font color='#FF7800'>high</font>,"
		elseif CREEP_POWER_FACTOR == 4 then
			creep_power = creep_power.."<font color='#FF7800'>extreme</font>,"
		end

		-- Tower power setting
		local tower_power = " and tower power is set to "
		if TOWER_POWER_FACTOR == 0 then
			tower_power = tower_power.."<font color='#FF7800'>normal</font>."
		elseif TOWER_POWER_FACTOR == 1 then
			tower_power = tower_power.."<font color='#FF7800'>high</font>."
		elseif TOWER_POWER_FACTOR == 2 then
			tower_power = tower_power.."<font color='#FF7800'>extreme</font>."
		end

		-- Tower abilities
		local tower_abilities = ""
		if TOWER_ABILITY_MODE then
			if TOWER_UPGRADE_MODE then
				tower_abilities = "Towers will gain <font color='#FF7800'>upgradable random abilities</font>."
			else
				tower_abilities = "Towers will gain <font color='#FF7800'>random abilities</font>."
			end
		end

		-- Comeback gold
		local comeback_gold = ""
		if HERO_GLOBAL_BOUNTY_FACTOR > 0 then
			comeback_gold = " Global comeback gold is <font color='#FF7800'>enabled</font>."
		else
			comeback_gold = " Global comeback gold is <font color='#FF7800'>disabled</font>."
		end

		-- Kills to end the game
		local kills_to_end = ""
		if END_GAME_ON_KILLS then
			kills_to_end = "<font color='#FF7800'>ARENA MODE:</font> the game will only end when one team reaches <font color='#FF7800'>"..KILLS_TO_END_GAME_FOR_TEAM.."</font> kills."
		end

		-- Frantic mode
		local frantic_mode = ""
		if FRANTIC_MULTIPLIER > 1 then
			frantic_mode = " <font color='#FF7800'>FRANTIC MODE:</font> cooldowns and mana costs decreased by <font color='#FF7800'>"..FRANTIC_MULTIPLIER.."x</font>."
		end
		
		Say(nil, game_mode..same_hero, false)
		Say(nil, gold_bounty.." gold rate, "..XP_bounty.." experience rate, "..respawn_time..buyback_cooldown, false)
		Say(nil, start_status, false)
		Say(nil, creep_power..tower_power, false)
		Say(nil, tower_abilities..comeback_gold, false)
		Say(nil, kills_to_end, false)
		if frantic_mode ~= "" then
			Say(nil, frantic_mode, false)
		end
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

	-- Give Invoker an extra ability point at level 1
	if hero:GetName() == "npc_dota_hero_invoker" then
		hero:SetAbilityPoints( hero:GetAbilityPoints() + 1 )
	end

	-- Make heroes briefly visible on spawn (to prevent bad fog interactions)
	Timers:CreateTimer(0.5, function()
		hero:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, 0.5)
		hero:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, 0.5)
	end)

	-- Add frantic mode passive buff
	if FRANTIC_MULTIPLIER > 1 then
		hero:AddAbility("imba_frantic_buff")
		ability_frantic = hero:FindAbilityByName("imba_frantic_buff")
		ability_frantic:SetLevel(1)
	end

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

	-- Roll the random ancient abilities for this game
	local ancient_ability_2 = "imba_ancient_stalwart_defense"
	local ancient_ability_3 = GetAncientAbility(1)
	local ancient_ability_4 = GetAncientAbility(2)
	local ancient_ability_5 = GetAncientAbility(3)

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
			building:AddAbility("imba_tower_buffs")
			local tower_ability = building:FindAbilityByName("imba_tower_buffs")
			tower_ability:SetLevel(1)

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

				-- Add Spawn Behemoth ability, if appropriate
				if SPAWN_ANCIENT_BEHEMOTHS then
					if string.find(building_name, "goodguys") then
						building:AddAbility("imba_ancient_radiant_spawn_behemoth")
						ancient_ability = building:FindAbilityByName("imba_ancient_radiant_spawn_behemoth")
					elseif string.find(building_name, "badguys") then
						building:AddAbility("imba_ancient_dire_spawn_behemoth")
						ancient_ability = building:FindAbilityByName("imba_ancient_dire_spawn_behemoth")
					end
					ancient_ability:SetLevel(1)
				end

				-- Add Stalwart Defense ability
				building:AddAbility(ancient_ability_2)
				ancient_ability = building:FindAbilityByName(ancient_ability_2)
				ancient_ability:SetLevel(1)

				-- Add tier 1 ability
				building:AddAbility(ancient_ability_3)
				ancient_ability = building:FindAbilityByName(ancient_ability_3)
				ancient_ability:SetLevel(1)

				-- Add tier 2 ability
				building:AddAbility(ancient_ability_4)
				ancient_ability = building:FindAbilityByName(ancient_ability_4)
				ancient_ability:SetLevel(1)

				-- Add tier 3 ability
				building:AddAbility(ancient_ability_5)
				ancient_ability = building:FindAbilityByName(ancient_ability_5)
				if ancient_ability:GetAbilityName() == "tidehunter_ravage" then
					ancient_ability:SetLevel(3)
				else
					ancient_ability:SetLevel(1)
				end
				
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

	-------------------------------------------------------------------------------------------------
	-- IMBA: Tower abilities setup
	-------------------------------------------------------------------------------------------------

	if TOWER_ABILITY_MODE then

		-- Roll the random tower abilities for this game
		TOWER_UPGRADE_TREE["safelane"]["tier_1"][1] = GetRandomTowerAbility(1, "attack")
		TOWER_UPGRADE_TREE["safelane"]["tier_1"][2] = GetRandomTowerAbility(1, "aura")
		TOWER_UPGRADE_TREE["safelane"]["tier_1"][3] = GetRandomTowerAbility(1, "active")

		TOWER_UPGRADE_TREE["safelane"]["tier_2"][1] = GetRandomTowerAbility(2, "attack")
		TOWER_UPGRADE_TREE["safelane"]["tier_2"][2] = GetRandomTowerAbility(2, "aura")
		TOWER_UPGRADE_TREE["safelane"]["tier_2"][3] = GetRandomTowerAbility(2, "active")

		TOWER_UPGRADE_TREE["safelane"]["tier_3"][1] = GetRandomTowerAbility(3, "attack")
		TOWER_UPGRADE_TREE["safelane"]["tier_3"][2] = GetRandomTowerAbility(3, "aura")
		TOWER_UPGRADE_TREE["safelane"]["tier_3"][3] = GetRandomTowerAbility(3, "active")

		TOWER_UPGRADE_TREE["hardlane"]["tier_1"][1] = GetRandomTowerAbility(1, "attack")
		TOWER_UPGRADE_TREE["hardlane"]["tier_1"][2] = GetRandomTowerAbility(1, "aura")
		TOWER_UPGRADE_TREE["hardlane"]["tier_1"][3] = GetRandomTowerAbility(1, "active")
		
		TOWER_UPGRADE_TREE["hardlane"]["tier_2"][1] = GetRandomTowerAbility(2, "attack")
		TOWER_UPGRADE_TREE["hardlane"]["tier_2"][2] = GetRandomTowerAbility(2, "aura")
		TOWER_UPGRADE_TREE["hardlane"]["tier_2"][3] = GetRandomTowerAbility(2, "active")
		
		TOWER_UPGRADE_TREE["hardlane"]["tier_3"][1] = GetRandomTowerAbility(3, "attack")
		TOWER_UPGRADE_TREE["hardlane"]["tier_3"][2] = GetRandomTowerAbility(3, "aura")
		TOWER_UPGRADE_TREE["hardlane"]["tier_3"][3] = GetRandomTowerAbility(3, "active")

		TOWER_UPGRADE_TREE["midlane"]["tier_1"][1] = GetRandomTowerAbility(1, "attack")
		TOWER_UPGRADE_TREE["midlane"]["tier_1"][2] = GetRandomTowerAbility(1, "aura")
		TOWER_UPGRADE_TREE["midlane"]["tier_1"][3] = GetRandomTowerAbility(1, "active")
		
		TOWER_UPGRADE_TREE["midlane"]["tier_2"][1] = GetRandomTowerAbility(2, "attack")
		TOWER_UPGRADE_TREE["midlane"]["tier_2"][2] = GetRandomTowerAbility(2, "aura")
		TOWER_UPGRADE_TREE["midlane"]["tier_2"][3] = GetRandomTowerAbility(2, "active")
		
		TOWER_UPGRADE_TREE["midlane"]["tier_3"][1] = GetRandomTowerAbility(3, "attack")
		TOWER_UPGRADE_TREE["midlane"]["tier_3"][2] = GetRandomTowerAbility(3, "aura")
		TOWER_UPGRADE_TREE["midlane"]["tier_3"][3] = GetRandomTowerAbility(3, "active")

		-- Make sure tier 4s are unique between themselves
		TOWER_UPGRADE_TREE["midlane"]["tier_41"][1] = GetRandomTowerAbility(4, "attack")
		TOWER_UPGRADE_TREE["midlane"]["tier_41"][2] = GetRandomTowerAbility(4, "aura")
		TOWER_UPGRADE_TREE["midlane"]["tier_41"][3] = GetRandomTowerAbility(4, "active")

		TOWER_UPGRADE_TREE["midlane"]["tier_42"][1] = GetRandomTowerAbility(4, "attack")
		while TOWER_UPGRADE_TREE["midlane"]["tier_42"][1] == TOWER_UPGRADE_TREE["midlane"]["tier_41"][1] do
			TOWER_UPGRADE_TREE["midlane"]["tier_42"][1] = GetRandomTowerAbility(4, "attack")
		end
		TOWER_UPGRADE_TREE["midlane"]["tier_42"][2] = GetRandomTowerAbility(4, "aura")
		while TOWER_UPGRADE_TREE["midlane"]["tier_42"][2] == TOWER_UPGRADE_TREE["midlane"]["tier_41"][2] do
			TOWER_UPGRADE_TREE["midlane"]["tier_42"][2] = GetRandomTowerAbility(4, "aura")
		end
		TOWER_UPGRADE_TREE["midlane"]["tier_42"][3] = GetRandomTowerAbility(4, "active")
		while TOWER_UPGRADE_TREE["midlane"]["tier_42"][3] == TOWER_UPGRADE_TREE["midlane"]["tier_41"][3] do
			TOWER_UPGRADE_TREE["midlane"]["tier_42"][3] = GetRandomTowerAbility(4, "active")
		end

		
		-- Safelane towers
		for i = 1, 3 do
			
			-- Find safelane towers
			local radiant_tower_loc = Entities:FindByName(nil, "radiant_safe_tower_t"..i):GetAbsOrigin()
			local dire_tower_loc = Entities:FindByName(nil, "dire_safe_tower_t"..i):GetAbsOrigin()
			local radiant_tower = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, radiant_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			local dire_tower = FindUnitsInRadius(DOTA_TEAM_BADGUYS, dire_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			radiant_tower = radiant_tower[1]
			dire_tower = dire_tower[1]

			-- Store the towers' tier and lane
			radiant_tower.tower_tier = i
			dire_tower.tower_tier = i
			radiant_tower.tower_lane = "safelane"
			dire_tower.tower_lane = "safelane"

			-- Fetch the corresponding ability's name
			local ability_name
			if i == 1 then
				ability_name = TOWER_UPGRADE_TREE["safelane"]["tier_1"][1]
			elseif i == 2 then
				ability_name = TOWER_UPGRADE_TREE["safelane"]["tier_2"][1]
			elseif i == 3 then
				ability_name = TOWER_UPGRADE_TREE["safelane"]["tier_3"][1]
			end

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

			-- Store the towers' tier and lane
			radiant_tower.tower_tier = i
			dire_tower.tower_tier = i
			radiant_tower.tower_lane = "midlane"
			dire_tower.tower_lane = "midlane"

			-- Fetch the corresponding ability's name
			local ability_name
			if i == 1 then
				ability_name = TOWER_UPGRADE_TREE["midlane"]["tier_1"][1]
			elseif i == 2 then
				ability_name = TOWER_UPGRADE_TREE["midlane"]["tier_2"][1]
			elseif i == 3 then
				ability_name = TOWER_UPGRADE_TREE["midlane"]["tier_3"][1]
			end

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

			-- Store the towers' tier and lane
			radiant_tower.tower_tier = i
			dire_tower.tower_tier = i
			radiant_tower.tower_lane = "hardlane"
			dire_tower.tower_lane = "hardlane"

			-- Fetch the corresponding ability's name
			local ability_name
			if i == 1 then
				ability_name = TOWER_UPGRADE_TREE["hardlane"]["tier_1"][1]
			elseif i == 2 then
				ability_name = TOWER_UPGRADE_TREE["hardlane"]["tier_2"][1]
			elseif i == 3 then
				ability_name = TOWER_UPGRADE_TREE["hardlane"]["tier_3"][1]
			end

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

		-- Store the towers' tier and lane
		radiant_left_t4.tower_tier = 41
		radiant_right_t4.tower_tier = 42
		dire_left_t4.tower_tier = 41
		dire_right_t4.tower_tier = 42
		radiant_left_t4.tower_lane = "midlane"
		radiant_right_t4.tower_lane = "midlane"
		dire_left_t4.tower_lane = "midlane"
		dire_right_t4.tower_lane = "midlane"

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
		radiant_left_ability:SetLevel(3)
		dire_left_ability:SetLevel(3)
		radiant_right_ability:SetLevel(3)
		dire_right_ability:SetLevel(3)
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

	GameRules.HeroKV = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
	GameRules.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")

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