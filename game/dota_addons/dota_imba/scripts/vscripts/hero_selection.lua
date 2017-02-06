--[[
 Hero selection module for D2E.
 This file basically just separates the functions related to hero selection from
 the other functions present in D2E.
]]

--Constant parameters
SELECTION_DURATION_LIMIT = HERO_SELECTION_TIME

--Class definition
if HeroSelection == nil then
	HeroSelection = {}
	HeroSelection.__index = HeroSelection
end

--[[
	Start
	Call this function from your gamemode once the gamestate changes
	to pre-game to start the hero selection.
]]
function HeroSelection:Start()
	--Figure out which players have to pick
	 HeroSelection.playerPicks = {}
	 HeroSelection.numPickers = 0
	for pID = 0, DOTA_MAX_PLAYERS -1 do
		if PlayerResource:IsValidPlayer( pID ) then
			HeroSelection.numPickers = self.numPickers + 1
		end
	end

	--Start the pick timer
	HeroSelection.TimeLeft = SELECTION_DURATION_LIMIT
	Timers:CreateTimer( 0.04, HeroSelection.Tick )

	--Keep track of the number of players that have picked
	HeroSelection.playersPicked = 0

	--Listen for the pick event
	HeroSelection.listener = CustomGameEventManager:RegisterListener( "hero_selected", HeroSelection.HeroSelect )
end

--[[
	Tick
	A tick of the pick timer.
	Params:
		- event {table} - A table containing PlayerID and HeroID.
]]
function HeroSelection:Tick() 
	--Send a time update to all clients
	if HeroSelection.TimeLeft >= 0 then
		CustomGameEventManager:Send_ServerToAllClients( "picking_time_update", {time = HeroSelection.TimeLeft} )
	end

	--Tick away a second of time
	HeroSelection.TimeLeft = HeroSelection.TimeLeft - 1
	if HeroSelection.TimeLeft == -1 then
		--End picking phase
		HeroSelection:EndPicking()
		return nil
	elseif HeroSelection.TimeLeft >= 0 then
		return 1
	else
		return nil
	end
end

--[[
	HeroSelect
	A player has selected a hero. This function is caled by the CustomGameEventManager
	once a 'hero_selected' event was seen.
	Params:
		- event {table} - A table containing PlayerID and HeroID.
]]
function HeroSelection:HeroSelect( event )

	--If this player has not picked yet give him the hero
	if HeroSelection.playerPicks[ event.PlayerID ] == nil then
		HeroSelection.playersPicked = HeroSelection.playersPicked + 1
		HeroSelection.playerPicks[ event.PlayerID ] = event.HeroName
		if tobool(event.HasRandomed) then PlayerResource:SetHasRandomed(event.PlayerID) end

		--Send a pick event to all clients
		CustomGameEventManager:Send_ServerToAllClients( "picking_player_pick", 
			{ PlayerID = event.PlayerID, HeroName = event.HeroName} )

		--Assign the hero if picking is over
		if HeroSelection.TimeLeft <= 0 then
			HeroSelection:AssignHero( event.PlayerID, event.HeroName )
		end
	end

	--Check if all heroes have been picked
	if HeroSelection.playersPicked >= HeroSelection.numPickers then
		--End picking
		--HeroSelection.TimeLeft = 0
		HeroSelection:Tick()
	end
end

--[[
	EndPicking
	The final function of hero selection which is called once the selection is done.
	This function spawns the heroes for the players and signals the picking screen
	to disappear.
]]
function HeroSelection:EndPicking()
	--Stop listening to pick events
	--CustomGameEventManager:UnregisterListener( self.listener )

	--Assign the picked heroes to all players that have picked
	local i = 0
	local keep_going = false
	Timers:CreateTimer(0, function()
		if HeroSelection.playerPicks[i] then
			HeroSelection:AssignHero(i, HeroSelection.playerPicks[i])
			keep_going = true
		end
		if keep_going then
			i = i + 1
			keep_going = false
			return 1
		else
			CustomGameEventManager:Send_ServerToAllClients( "hero_loading_done", {} )
		end
	end)
end

--[[
	AssignHero
	Assign a hero to the player. Replaces the current hero of the player
	with the selected hero, after it has finished precaching.
	Params:
		- player_id {integer} - The playerID of the player to assign to.
		- hero_name {string} - The unit name of the hero to assign (e.g. 'npc_dota_hero_rubick')
]]
function HeroSelection:AssignHero( player_id, hero_name )
	PrecacheUnitByNameAsync( hero_name, function()

		PlayerResource:ReplaceHeroWith( player_id, hero_name, 0, 0 )

		-------------------------------------------------------------------------------------------------
		-- IMBA: First hero spawn initialization
		-------------------------------------------------------------------------------------------------

		-- Fetch this player's hero entity
		local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()

		-- Initializes player data if this is a bot
		if PlayerResource:GetConnectionState(player_id) == 1 then
			PlayerResource:InitPlayerData(player_id)
		end

		-- Check if initial setup was already performed
		if PlayerResource:IsPlayerSpawnSetupDone(player_id) then
			return nil
		end

		-- Make heroes briefly visible on spawn (to prevent bad fog interactions)
		Timers:CreateTimer(0.5, function()
			hero:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, 0.5)
			hero:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, 0.5)
		end)

		-- Set up initial level 1 experience bounty
		hero:SetCustomDeathXP(HERO_XP_BOUNTY_PER_LEVEL[1])

		-- Set up initial level
		if HERO_STARTING_LEVEL > 1 then
			Timers:CreateTimer(1, function()
				hero:AddExperience(XP_PER_LEVEL_TABLE[HERO_STARTING_LEVEL], DOTA_ModifyXP_CreepKill, false, true)
			end)
		end

		-- Set up initial gold
		local has_randomed = PlayerResource:HasRandomed(player_id)
		local has_repicked = false

		if has_randomed or IMBA_PICK_MODE_ALL_RANDOM then
			PlayerResource:SetGold(player_id, HERO_RANDOM_GOLD, false)
		elseif has_repicked then
			PlayerResource:SetGold(player_id, HERO_REPICK_GOLD, false)
		else
			PlayerResource:SetGold(player_id, HERO_INITIAL_GOLD, false)
		end

		-- Randomize abilities
		if IMBA_ABILITY_MODE_RANDOM_OMG then
			ApplyAllRandomOmgAbilities(hero)
		end

		-- Initialize innate hero abilities
		InitializeInnateAbilities(hero)

		-- Set up player color
		PlayerResource:SetCustomPlayerColor(player_id, PLAYER_COLORS[player_id][1], PLAYER_COLORS[player_id][2], PLAYER_COLORS[player_id][3])

		-- Set initial spawn setup as having been done
		PlayerResource:SetPlayerSpawnSetupDone(player_id)
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "picking_done", {})
	end, player_id)
end