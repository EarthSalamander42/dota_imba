-- Dota IMBA version 6.84.1

-- Carryovers from Barebones
-------------------------------------------------------------------------------------------------------------------------------------

ENABLE_HERO_RESPAWN = true              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = false             -- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = true       -- Should we let people select the same hero as each other

HERO_SELECTION_TIME = 60.0             	-- How long should we let people select their hero?
PRE_GAME_TIME = 90.0                   	-- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0                   -- How long should we let people look at the scoreboard before closing the server automatically?
TREE_REGROW_TIME = 300.0                -- How long should it take individual trees to respawn after being cut down/destroyed?

GOLD_PER_TICK = 2                     	-- How much gold should players get per tick?
GOLD_TICK_TIME = 0.8                    -- How long should we wait in seconds between gold ticks?

RECOMMENDED_BUILDS_DISABLED = true     -- Should we disable the recommened builds for heroes (Note: this is not working currently I believe)
CAMERA_DISTANCE_OVERRIDE = 1134.0       -- How far out should we allow the camera to go?  1134 is the default in Dota

MINIMAP_ICON_SIZE = 1                   -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1              -- What icon size should we use for runes?

RUNE_SPAWN_TIME = 120                   -- How long in seconds should we wait between rune spawns?
CUSTOM_BUYBACK_COST_ENABLED = false     -- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = true  -- Should we use a custom buyback time?
BUYBACK_ENABLED = true              	-- Should we allow people to buyback when they die?

DISABLE_FOG_OF_WAR_ENTIRELY = false     -- Should we disable fog of war entirely for both teams?
										-- NOTE: This won't reveal particle effects for everyone. You need to create vision dummies for that.

USE_STANDARD_DOTA_BOT_THINKING = false 	-- Should we have bots act like they would in Dota? (This requires 3 lanes, normal items, etc)
USE_STANDARD_HERO_GOLD_BOUNTY = true    -- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?

USE_CUSTOM_TOP_BAR_VALUES = false       -- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = true             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = true -- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false       -- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players get gold?

END_GAME_ON_KILLS = false               -- Should the game end after a certain number of kills?
--KILLS_TO_END_GAME_FOR_TEAM = 50       -- How many kills for a team should signify an end of game?

USE_CUSTOM_HERO_LEVELS = false          -- Should we allow heroes to have custom levels?
MAX_LEVEL = 25                        	-- What level should we let heroes get to?
USE_CUSTOM_XP_VALUES = false            -- Should we use custom XP values to level up heroes, or the default Dota numbers?

OutOfWorldVector = Vector(11000, 11000, -200)

-- Game globals
-------------------------------------------------------------------------------------------------------------------------------------

CREEP_XP_BONUS = 30						-- Amount of bonus XP granted by creeps (in %)
CREEP_GOLD_BONUS = 30					-- Amount of bonus gold granted by creeps (in %)

HERO_KILL_GOLD_BASE = 200				-- Base amount of gold awarded on a hero kill
HERO_KILL_GOLD_PER_LEVEL = 20			-- Amount of gold awarded on a hero kill per killed hero's level
HERO_KILL_GOLD_PER_KILLSTREAK = 80		-- Amount of gold awarded per killstreak, starting on 3 kills
HERO_KILL_GOLD_PER_DEATHSTREAK = 80		-- Amount of gold reduced from the hero's bounty on a deathstreak, starting at 3 deaths

HERO_ASSIST_RADIUS = 1300				-- Radius around the killed hero where allies will gain assist gold and experience

HERO_ASSIST_BOUNTY_FACTOR_2 = 0.70		-- Factor to multiply the assist bounty by when 2 heroes are involved
HERO_ASSIST_BOUNTY_FACTOR_3 = 0.55		-- Factor to multiply the assist bounty by when 3 heroes are involved
HERO_ASSIST_BOUNTY_FACTOR_4 = 0.40		-- Factor to multiply the assist bounty by when 4 heroes are involved
HERO_ASSIST_BOUNTY_FACTOR_5 = 0.30		-- Factor to multiply the assist bounty by when 5 heroes are involved

-- Enable stat collection
--if not Testing then
--  statcollection.addStats({
--    modID = "3c618932c8379fe1284bc14438f76c89"
--  })
--end

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {}
for i=1,MAX_LEVEL do
	XP_PER_LEVEL_TABLE[i] = i * 100
end

-- Generated from template
if GameMode == nil then
	GameMode = class({})
end

-- Precaches everything in the "npc_precache_everything" block in npc_units_custom.txt
function GameMode:PostLoadPrecache()
	PrecacheUnitByNameAsync("npc_precache_everything", function(...) end)
end

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
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in.
]]
function GameMode:OnHeroInGame(hero)
	print("[IMBA] Hero spawned in game for first time -- " .. hero:GetUnitName())

	if not self.greetPlayers then

		-- At this point a player now has a hero spawned in your map.
		local line_1 = ColorIt("Welcome to ", "green") .. ColorIt("Dota IMBA! ", "orange") .. ColorIt("v6.84.4", "blue");
		local line_2 = ColorIt("Hover over your abilities to find out ", "green") .. ColorIt("what they do.", "orange");
		local line_3 = ColorIt("You can check out the new items and scepter upgrades on the shop.", "green");
		local line_4 = ColorIt("Check our workshop page for the newest updates. ", "green") .. ColorIt("HAVE FUN!", "orange");
		
		-- Send the first greeting in 4 secs.
		Timers:CreateTimer(4, function()
			GameRules:SendCustomMessage(line_1, 0, 0)
			Timers:CreateTimer(3, function()
				GameRules:SendCustomMessage(line_2, 0, 0)
				Timers:CreateTimer(3, function()
					GameRules:SendCustomMessage(line_3, 0, 0)
					Timers:CreateTimer(3, function()
						GameRules:SendCustomMessage(line_4, 0, 0)
					end)
				end)
			end)
		end)

		self.greetPlayers = true
	end

	-- Store a reference to the player handle inside this hero handle.
	hero.player = PlayerResource:GetPlayer(hero:GetPlayerID())
	-- Store the player's name inside this hero handle.
	hero.playerName = PlayerResource:GetPlayerName(hero:GetPlayerID())
	-- Store this hero handle in this table.
	table.insert(self.vPlayers, hero)

	-- Show a popup with game instructions.
	-- local scepter_string = "#"..hero:GetName().."_instructions_body"
	-- ShowGenericPopupToPlayer(hero.player, "#imba_instructions_title", scepter_string, "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN )

	-- This line for example will set the starting gold of every hero to 625 unreliable gold
	hero:SetGold(625, false)
end

--[[
	This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
	gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
	is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
	print("[IMBA] The game has officially begun")
	
end

function GameMode:PlayerSay( keys )
	--local ply = keys.ply
	--local hero = ply:GetAssignedHero()
	--local txt = keys.text

	--if keys.teamOnly then
		-- This text was team-only.
	--end

	--if txt == nil or txt == "" then
	--	return
	--end

  -- At this point we have valid text from a player.
	--print("P" .. ply .. " wrote: " .. keys.text)
end

-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
	print('[IMBA] Player Disconnected ' .. tostring(keys.userid))
	PrintTable(keys)

	local name = keys.name
	local networkid = keys.networkid
	local reason = keys.reason
	local userid = keys.userid
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
		end
		Timers:CreateTimer("alljointimer", {
			useGameTime = true,
			endTime = et,
			callback = function()
				if PlayerResource:HaveAllPlayersJoined() then
					GameMode:PostLoadPrecache()
					GameMode:OnAllPlayersLoaded()
					return
				end
				return 1
			end})
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		GameMode:OnGameInProgress()
	end
end

-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)

	-- Reaper's Scythe buyback clean-up
	if npc:IsRealHero() then
		npc:SetBuyBackDisabledByReapersScythe(false)
	end
	
	-- First hero spawn function call
	if npc:IsRealHero() and npc.bFirstSpawned == nil then

		-- Create kill and death streak globals
		npc.kill_streak = false
		npc.death_streak = false
		npc.kill_streak_count = 0
		npc.death_streak_count = 0

		-- Set up the level 1 gold bounty
		npc:SetMaximumGoldBounty( HERO_KILL_GOLD_BASE + HERO_KILL_GOLD_PER_LEVEL )
		npc:SetMinimumGoldBounty( HERO_KILL_GOLD_BASE + HERO_KILL_GOLD_PER_LEVEL )

		-- Prevent this function from being called again and go to OnHeroInGame function
		npc.bFirstSpawned = true
		GameMode:OnHeroInGame(npc)
	end

	-- Creep bounty adjustment
	if not npc:IsHero() and not npc:IsOwnedByAnyPlayer() then
		local gold_bounty = npc:GetGoldBounty()
		local xp_bounty = npc:GetDeathXP()

		npc:SetDeathXP(math.floor( xp_bounty * (1 + CREEP_XP_BONUS / 100 ) ))
		npc:SetMaximumGoldBounty( math.floor( gold_bounty * ( 1.05 + CREEP_GOLD_BONUS / 100 ) ))
		npc:SetMinimumGoldBounty( math.floor( gold_bounty * ( 0.95 + CREEP_GOLD_BONUS / 100 ) ))
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

end

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
	local player = EntIndexToHScript(keys.player)
	local level = keys.level
	
	-- Updates the target's bounty
	local hero = player:GetAssignedHero()
	local hero_bounty = hero:GetGoldBounty()

	hero:SetMaximumGoldBounty( hero_bounty + HERO_KILL_GOLD_PER_LEVEL )
	hero:SetMinimumGoldBounty( hero_bounty + HERO_KILL_GOLD_PER_LEVEL )
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

	local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
	local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
	local numKills = keys.herokills
	local killerTeamNumber = keys.teamnumber
end

-- An entity died
function GameMode:OnEntityKilled( keys )
	local killed_unit = EntIndexToHScript( keys.entindex_killed )
	local killer = nil

	if keys.entindex_attacker ~= nil then
		killer = EntIndexToHScript( keys.entindex_attacker )
	end

	-- Sets the game winner if an ancient is destroyed
	if killed_unit:GetName() == "npc_dota_badguys_fort" then
		GameRules:SetSafeToLeave( true )
		GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
	elseif killed_unit:GetName() == "npc_dota_goodguys_fort" then
		GameRules:SetSafeToLeave( true )
		GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )
	end

	-- Hero kill logic
	if killed_unit:IsRealHero() then

		-- Check if the killer is not a neutral unit
		local non_neutral_killer = false
		if killer:GetTeam() == DOTA_TEAM_GOODGUYS or killer:GetTeam() == DOTA_TEAM_BADGUYS then
			non_neutral_killer = true
		end

		-- Check if killed unit and killer belong to different teams
		if killed_unit:GetTeam() ~= killer:GetTeam() and non_neutral_killer then

			-- Increase scoreboard for the killer team
			if killer:GetTeam() == DOTA_TEAM_GOODGUYS then
				self.nRadiantKills = self.nRadiantKills + 1
			elseif killer:GetTeam() == DOTA_TEAM_BADGUYS then
				self.nDireKills = self.nDireKills + 1
			end

			-- Update the scoreboard
			if SHOW_KILLS_ON_TOPBAR then
				GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_BADGUYS, self.nDireKills )
				GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_GOODGUYS, self.nRadiantKills )
			end

			-- End the game if it is set to end on a fixed number of kills
			if END_GAME_ON_KILLS and self.nRadiantKills >= KILLS_TO_END_GAME_FOR_TEAM then
				GameRules:SetSafeToLeave( true )
				GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
			elseif END_GAME_ON_KILLS and self.nDireKills >= KILLS_TO_END_GAME_FOR_TEAM then
				GameRules:SetSafeToLeave( true )
				GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )
			end

			-- Calculate assist bounty
			local nearby_allies = FindUnitsInRadius(killer:GetTeam(), killed_unit:GetAbsOrigin(), nil, HERO_ASSIST_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_DEAD, 0, false)
			local assist_bounty = killed_unit:GetGoldBounty()
			print("initial assist bounty: "..assist_bounty)
			local ally_count = 0

			-- Count the number of nearby allies who are not illusions
			for _,hero in pairs(nearby_allies) do
				if hero:IsRealHero() then
					ally_count = ally_count + 1
				end
			end

			-- Reduce assist bounty according to the number of nearby allies
			if not killer:IsHero() then

				-- If the kill was made by a non-hero unit, divide the bounty equally by all of the team's heroes
				local all_team_heroes = FindUnitsInRadius(killer:GetTeam(), killed_unit:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_DEAD, 0, false)
				assist_bounty = assist_bounty / #all_team_heroes
				for _,hero in pairs(all_team_heroes) do
					hero:ModifyGold(assist_bounty, true, 0)
				end

			elseif ally_count == 2 then
				assist_bounty = assist_bounty * HERO_ASSIST_BOUNTY_FACTOR_2
				print("bounty after 2 division: "..assist_bounty)
			elseif ally_count == 3 then
				assist_bounty = assist_bounty * HERO_ASSIST_BOUNTY_FACTOR_3
				print("bounty after 3 division: "..assist_bounty)
			elseif ally_count == 4 then
				assist_bounty = assist_bounty * HERO_ASSIST_BOUNTY_FACTOR_4
				print("bounty after 4 division: "..assist_bounty)
			else
				assist_bounty = assist_bounty * HERO_ASSIST_BOUNTY_FACTOR_5
				print("bounty after 5 division: "..assist_bounty)
			end

			-- Grant bounties
			for _,hero in pairs(nearby_allies) do
				if hero ~= killer then
					hero:ModifyGold(assist_bounty, true, 0)
				end
			end

			-- Update streak bounties and display streak messages
			if killed_unit.kill_streak then
				killed_unit:SetMaximumGoldBounty( HERO_KILL_GOLD_BASE + killed_unit:GetLevel() * HERO_KILL_GOLD_PER_LEVEL )
				killed_unit:SetMinimumGoldBounty( HERO_KILL_GOLD_BASE + killed_unit:GetLevel() * HERO_KILL_GOLD_PER_LEVEL )
			elseif killed_unit.death_streak then
				killed_unit:SetMaximumGoldBounty( math.max( killed_unit:GetGoldBounty() - HERO_KILL_GOLD_PER_DEATHSTREAK, 0) )
				killed_unit:SetMinimumGoldBounty( math.max( killed_unit:GetGoldBounty() - HERO_KILL_GOLD_PER_DEATHSTREAK, 0) )

				
				local killed_hero_name = "#"..killed_unit:GetName()
				if killed_unit.death_streak_count == 3 then
					GameRules:SendCustomMessage(killed_hero_name.." is on a <font color='#00FF40'><b>DYING SPREE</b></font>", 0, 0)
				elseif killed_unit.death_streak_count == 4 then
					GameRules:SendCustomMessage(killed_hero_name.." is being <font color='#5E00BD'><b>DOMINATED</b></font>", 0, 0)
				elseif killed_unit.death_streak_count == 5 then
					GameRules:SendCustomMessage(killed_hero_name.." is on a <font color='#FF0080'><b>MEGA DEATH</b></font> streak", 0, 0)
				elseif killed_unit.death_streak_count == 6 then
					GameRules:SendCustomMessage(killed_hero_name.." is <font color='#FF8000'><b>HOPELESS</b></font>", 0, 0)
				elseif killed_unit.death_streak_count == 7 then
					GameRules:SendCustomMessage(killed_hero_name.." is on a <font color='#808000'><b>WICKED FEEDING</b></font> streak", 0, 0)
				elseif killed_unit.death_streak_count == 8 then
					GameRules:SendCustomMessage(killed_hero_name.." is on a <font color='#FF80FF'><b>MONSTER FEED</b></font> streak", 0, 0)
				elseif killed_unit.death_streak_count == 9 then
					GameRules:SendCustomMessage(killed_hero_name.." is <font color='#FF0000'><b>GHOSTLIKE</b></font>", 0, 0)
				elseif killed_unit.death_streak_count >= 10 then
					GameRules:SendCustomMessage(killed_hero_name.." is beyond <font color='#FF8000'><b>GHOSTLIKE</b></font>, someone FEED them!!", 0, 0)
				end
			end

			if killer.kill_streak then
				killer:SetMaximumGoldBounty( killer:GetGoldBounty() + HERO_KILL_GOLD_PER_KILLSTREAK )
				killer:SetMinimumGoldBounty( killer:GetGoldBounty() + HERO_KILL_GOLD_PER_KILLSTREAK )
			elseif killer.death_streak then
				killer:SetMaximumGoldBounty( HERO_KILL_GOLD_BASE + killer:GetLevel() * HERO_KILL_GOLD_PER_LEVEL )
				killer:SetMinimumGoldBounty( HERO_KILL_GOLD_BASE + killer:GetLevel() * HERO_KILL_GOLD_PER_LEVEL )
			end
				

			-- Update the killer's kill and death streaks
			if killer:IsRealHero() then
				killer.death_streak = false
				killer.death_streak_count = 0
				killer.kill_streak_count = killer.kill_streak_count + 1
				if killer.kill_streak_count >= 2 then
					killer.kill_streak = true
				end
			end

			-- Update the killed hero's kill and death streaks
			if killed_unit:IsRealHero() then
				killed_unit.kill_streak = false
				killed_unit.kill_streak_count = 0
				killed_unit.death_streak_count = killed_unit.death_streak_count + 1
				if killed_unit.death_streak_count >= 2 then
					killed_unit.death_streak = true
				end
			end
		end
	end

	-- Reaper's Scythe death timer increase
	if killed_unit.scythe_added_respawn then
		killed_unit:SetTimeUntilRespawn(killed_unit:GetRespawnTime() + killed_unit.scythe_added_respawn)
	end
end


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

	-- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
	Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", 0 )

	Convars:RegisterCommand('player_say', function(...)
		local arg = {...}
		table.remove(arg,1)
		local sayType = arg[1]
		table.remove(arg,1)

		local cmdPlayer = Convars:GetCommandClient()
		keys = {}
		keys.ply = cmdPlayer
		keys.teamOnly = false
		keys.text = table.concat(arg, " ")

		if (sayType == 4) then
			-- Student messages
		elseif (sayType == 3) then
			-- Coach messages
		elseif (sayType == 2) then
			-- Team only
			keys.teamOnly = true
			-- Call your player_say function here like
			self:PlayerSay(keys)
		else
			-- All chat
			-- Call your player_say function here like
			self:PlayerSay(keys)
		end
	end, 'player say', 0)

	-- Fill server with fake clients
	-- Fake clients don't use the default bot AI for buying items or moving down lanes and are sometimes necessary for debugging
	Convars:RegisterCommand('fake', function()
		-- Check if the server ran it
		if not Convars:GetCommandClient() then
			-- Create fake Players
			SendToServerConsole('dota_create_fake_clients')

			Timers:CreateTimer('assign_fakes', {
				useGameTime = false,
				endTime = Time(),
				callback = function(barebones, args)
					local userID = 20
					for i=0, 9 do
						userID = userID + 1
						-- Check if this player is a fake one
						if PlayerResource:IsFakeClient(i) then
							-- Grab player instance
							local ply = PlayerResource:GetPlayer(i)
							-- Make sure we actually found a player instance
							if ply then
								CreateHeroForPlayer('npc_dota_hero_axe', ply)
								self:OnConnectFull({
									userid = userID,
									index = ply:entindex()-1
								})

								ply:GetAssignedHero():SetControllableByPlayer(0, true)
							end
						end
					end
				end})
		end
	end, 'Connects and assigns fake Players.', 0)

	-- Change random seed
	local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
	math.randomseed(tonumber(timeTxt))

	-- Initialized tables for tracking state
	self.vUserIds = {}
	self.vSteamIds = {}
	self.vBots = {}
	self.vBroadcasters = {}

	self.vPlayers = {}
	self.vRadiant = {}
	self.vDire = {}

	self.nRadiantKills = 0
	self.nDireKills = 0

	self.bSeenWaitForPlayers = false

	if RECOMMENDED_BUILDS_DISABLED then
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_SHOP_SUGGESTEDITEMS, false )
	end

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
	end
end

-- This function is called 1 to 2 times as the player connects initially but before they
-- have completely connected
function GameMode:PlayerConnect(keys)
	print('[IMBA] PlayerConnect')
	PrintTable(keys)

	if keys.bot == 1 then
		-- This user is a Bot, so add it to the bots table
		self.vBots[keys.userid] = 1
	end
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
	print ('[IMBA] OnConnectFull')
	PrintTable(keys)
	GameMode:CaptureGameMode()

	local entIndex = keys.index+1
	-- The Player entity of the joining user
	local ply = EntIndexToHScript(entIndex)

	-- The Player ID of the joining player
	local playerID = ply:GetPlayerID()

	-- Update the user ID table with this user
	self.vUserIds[keys.userid] = ply

	-- Update the Steam ID table
	self.vSteamIds[PlayerResource:GetSteamAccountID(playerID)] = ply

	-- If the player is a broadcaster flag it in the Broadcasters table
	if PlayerResource:IsBroadcaster(playerID) then
		self.vBroadcasters[keys.userid] = 1
		return
	end
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
