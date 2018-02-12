-- Copyright (C) 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Editors:
--     Firetoad
--     Moujiozi
--     EarthSalamander #42
--     suthernfriend
--

---------------------------------------------------------------------------------------------------
-- Barebones basics
-------------------------------------------------------------------------------------------------

START_GAME_AUTOMATICALLY = true				-- Should the game start automatically

ENABLE_HERO_RESPAWN = true					-- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = false					-- Should the main shop contain Secret Shop items as well as regular items

HERO_SELECTION_TIME = 30.0 + 5.0		-- How long should we let people select their hero?
if IsInToolsMode() then HERO_SELECTION_TIME = 15.0 end

PRE_GAME_TIME = 90.0 + HERO_SELECTION_TIME	-- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0						-- How long should we let people look at the scoreboard before closing the server automatically?
AUTO_LAUNCH_DELAY = 5.0					-- How long should we wait for the host to setup the game, after all players have loaded in?
if GetMapName() == "imba_frantic_10v10" then
	AUTO_LAUNCH_DELAY = 10.0
end
TREE_REGROW_TIME = 180.0					-- How long should it take individual trees to respawn after being cut down/destroyed?
SHOWCASE_TIME = 0.0							-- How long should showcase time last?
STRATEGY_TIME = 0.0							-- How long should strategy time last?

GOLD_PER_TICK = 1							-- How much gold should players get per tick?

RECOMMENDED_BUILDS_DISABLED = false			-- Should we disable the recommened builds for heroes
CAMERA_DISTANCE_OVERRIDE = -1				-- How far out should we allow the camera to go?  1134 is the default in Dota

MINIMAP_ICON_SIZE = 1						-- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1					-- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1					-- What icon size should we use for runes?

RUNE_SPAWN_TIME = 120						-- How long in seconds should we wait between rune spawns?
CUSTOM_BUYBACK_COST_ENABLED = true			-- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = true		-- Should we use a custom buyback time?
BUYBACK_ENABLED = true						-- Should we allow people to buyback when they die?

DISABLE_FOG_OF_WAR_ENTIRELY = false			-- Should we disable fog of war entirely for both teams?
USE_UNSEEN_FOG_OF_WAR = false				-- Should we make unseen and fogged areas of the map completely black until uncovered by each team?
-- Note: DISABLE_FOG_OF_WAR_ENTIRELY must be false for USE_UNSEEN_FOG_OF_WAR to work
USE_STANDARD_DOTA_BOT_THINKING = false		-- Should we have bots act like they would in Dota? (This requires 3 lanes, normal items, etc)
USE_NONSTANDARD_HERO_GOLD_BOUNTY = false	-- Should heroes follow their own gold bounty rules instead of the default DOTA ones?
USE_NONSTANDARD_HERO_XP_BOUNTY = true		-- Should heroes follow their own XP bounty rules instead of the default DOTA ones?

USE_CUSTOM_TOP_BAR_VALUES = false			-- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true						-- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = true					-- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = true		-- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false			-- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false					-- Should we disable the gold sound when players get gold?

ENABLE_FIRST_BLOOD = true					-- Should we enable first blood for the first kill in this game?
HIDE_KILL_BANNERS = false					-- Should we hide the kill banners that show when a player is killed?
LOSE_GOLD_ON_DEATH = true					-- Should we have players lose the normal amount of dota gold on death?
SHOW_ONLY_PLAYER_INVENTORY = false			-- Should we only allow players to see their own inventory even when selecting other units?
DISABLE_STASH_PURCHASING = false			-- Should we prevent players from being able to buy items into their stash when not at a shop?
DISABLE_ANNOUNCER = false					-- Should we disable the announcer from working in the game?
FORCE_PICKED_HERO = nil						-- What hero should we force all players to spawn as? (e.g. "npc_dota_hero_axe").  Use nil to allow players to pick their own hero.

FIXED_RESPAWN_TIME = -1						-- What time should we use for a fixed respawn timer?  Use -1 to keep the default dota behavior.
FOUNTAIN_CONSTANT_MANA_REGEN = 14			-- What should we use for the constant fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_MANA_REGEN = 6			-- What should we use for the percentage fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_HEALTH_REGEN = 6		-- What should we use for the percentage fountain health regen?  Use -1 to keep the default dota behavior.
MAXIMUM_ATTACK_SPEED = 1600					-- What should we use for the maximum attack speed?
MINIMUM_ATTACK_SPEED = 0					-- What should we use for the minimum attack speed?
DOTA_MAX_PLAYERS = 24						-- Maximum amount of players allowed in a game

-------------------------------------------------------------------------------------------------
-- IMBA: gameplay globals
-------------------------------------------------------------------------------------------------

BUYBACK_COOLDOWN_ENABLED = true												-- Is the buyback cooldown enabled?

BUYBACK_BASE_COST = 100														-- Base cost to buyback
BUYBACK_COST_PER_LEVEL = 1.25												-- Level-based buyback cost
BUYBACK_COST_PER_LEVEL_AFTER_25 = 20										-- Level-based buyback cost growth after level 25
BUYBACK_COST_PER_SECOND = 0.25												-- Time-based buyback cost

BUYBACK_COOLDOWN_START_POINT = 600											-- Game time (in seconds) after which buyback cooldown is activated
BUYBACK_COOLDOWN_GROW_FACTOR = 0.167										-- Buyback cooldown increase per second
BUYBACK_COOLDOWN_MAXIMUM = 360												-- Maximum buyback cooldown

ABANDON_TIME = 180															-- Time for a player to be considered as having abandoned the game (in seconds)
FULL_ABANDON_TIME = 15														-- Time for a team to be considered as having abandoned the game (in seconds)

GAME_ROSHAN_KILLS = 0														-- Tracks amount of Roshan kills
ROSHAN_RESPAWN_TIME = RandomInt(2, 4) * 60									-- Roshan respawn timer (in seconds)
AEGIS_DURATION = 300														-- Aegis expiration timer (in seconds)

IMBA_DAMAGE_EFFECTS_DISTANCE_CUTOFF = 2500									-- Range at which most on-damage effects no longer trigger

COMEBACK_BOUNTY_SCORE = {}													-- Extra comeback gold based on hero and tower kills
COMEBACK_BOUNTY_SCORE[DOTA_TEAM_GOODGUYS] = 0
COMEBACK_BOUNTY_SCORE[DOTA_TEAM_BADGUYS] = 0
COMEBACK_BOUNTY_BONUS = {}													-- Extra comeback gold based on hero and tower kills
COMEBACK_BOUNTY_BONUS[DOTA_TEAM_GOODGUYS] = 0
COMEBACK_BOUNTY_BONUS[DOTA_TEAM_BADGUYS] = 0

COMEBACK_EXP_BONUS = 100

-- Hero respawn time per leve
-- Formula: (42/srqt(50)) * (-1*(50-sqrt(lvl))+50)

HERO_RESPAWN_TIME_PER_LEVEL = {}
HERO_RESPAWN_TIME_PER_LEVEL[1] = 6
HERO_RESPAWN_TIME_PER_LEVEL[2] = 8
HERO_RESPAWN_TIME_PER_LEVEL[3] = 10
HERO_RESPAWN_TIME_PER_LEVEL[4] = 12
HERO_RESPAWN_TIME_PER_LEVEL[5] = 13
HERO_RESPAWN_TIME_PER_LEVEL[6] = 15
HERO_RESPAWN_TIME_PER_LEVEL[7] = 16
HERO_RESPAWN_TIME_PER_LEVEL[8] = 17
HERO_RESPAWN_TIME_PER_LEVEL[9] = 18
HERO_RESPAWN_TIME_PER_LEVEL[10] = 19
HERO_RESPAWN_TIME_PER_LEVEL[11] = 20
HERO_RESPAWN_TIME_PER_LEVEL[12] = 21
HERO_RESPAWN_TIME_PER_LEVEL[13] = 21
HERO_RESPAWN_TIME_PER_LEVEL[14] = 22
HERO_RESPAWN_TIME_PER_LEVEL[15] = 23
HERO_RESPAWN_TIME_PER_LEVEL[16] = 24
HERO_RESPAWN_TIME_PER_LEVEL[17] = 24
HERO_RESPAWN_TIME_PER_LEVEL[18] = 25
HERO_RESPAWN_TIME_PER_LEVEL[19] = 26
HERO_RESPAWN_TIME_PER_LEVEL[20] = 27
HERO_RESPAWN_TIME_PER_LEVEL[21] = 27
HERO_RESPAWN_TIME_PER_LEVEL[22] = 28
HERO_RESPAWN_TIME_PER_LEVEL[23] = 28
HERO_RESPAWN_TIME_PER_LEVEL[24] = 29
HERO_RESPAWN_TIME_PER_LEVEL[25] = 30
HERO_RESPAWN_TIME_PER_LEVEL[26] = 30
HERO_RESPAWN_TIME_PER_LEVEL[27] = 31
HERO_RESPAWN_TIME_PER_LEVEL[28] = 31
HERO_RESPAWN_TIME_PER_LEVEL[29] = 32
HERO_RESPAWN_TIME_PER_LEVEL[30] = 33
HERO_RESPAWN_TIME_PER_LEVEL[31] = 33
HERO_RESPAWN_TIME_PER_LEVEL[32] = 34
HERO_RESPAWN_TIME_PER_LEVEL[33] = 34
HERO_RESPAWN_TIME_PER_LEVEL[34] = 35
HERO_RESPAWN_TIME_PER_LEVEL[35] = 35
HERO_RESPAWN_TIME_PER_LEVEL[36] = 36
HERO_RESPAWN_TIME_PER_LEVEL[37] = 36
HERO_RESPAWN_TIME_PER_LEVEL[38] = 37
HERO_RESPAWN_TIME_PER_LEVEL[39] = 37
HERO_RESPAWN_TIME_PER_LEVEL[40] = 38
HERO_RESPAWN_TIME_PER_LEVEL[41] = 38
HERO_RESPAWN_TIME_PER_LEVEL[42] = 38
HERO_RESPAWN_TIME_PER_LEVEL[43] = 39
HERO_RESPAWN_TIME_PER_LEVEL[44] = 39
HERO_RESPAWN_TIME_PER_LEVEL[45] = 40
HERO_RESPAWN_TIME_PER_LEVEL[46] = 40
HERO_RESPAWN_TIME_PER_LEVEL[47] = 41
HERO_RESPAWN_TIME_PER_LEVEL[48] = 41
HERO_RESPAWN_TIME_PER_LEVEL[49] = 42
HERO_RESPAWN_TIME_PER_LEVEL[50] = 42

-------------------------------------------------------------------------------------------------
-- IMBA: map-based settings
-------------------------------------------------------------------------------------------------

MAX_NUMBER_OF_TEAMS = 2														-- How many potential teams can be in this game mode?
IMBA_PLAYERS_ON_GAME = 10													-- Number of players in the game
USE_CUSTOM_TEAM_COLORS = false												-- Should we use custom team colors?
USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS = false									-- Should we use custom team colors to color the players/minimap?

PLAYER_COLORS = {}															-- Stores individual player colors
PLAYER_COLORS[0] = { 67, 133, 255 }
PLAYER_COLORS[1]  = { 170, 255, 195 }
PLAYER_COLORS[2] = { 130, 0, 150 }
PLAYER_COLORS[3] = { 255, 234, 0 }
PLAYER_COLORS[4] = { 255, 153, 0 }
PLAYER_COLORS[5] = { 190, 255, 0 }
PLAYER_COLORS[6] = { 255, 0, 0 }
PLAYER_COLORS[7] = { 0, 128, 128 }
PLAYER_COLORS[8] = { 255, 250, 200 }
PLAYER_COLORS[9] = { 49, 49, 49 }
PLAYER_COLORS[10] = { 255, 0, 255 }
PLAYER_COLORS[11]  = { 128, 128, 0 }
PLAYER_COLORS[12] = { 100, 255, 255 }
PLAYER_COLORS[13] = { 0, 190, 0 }
PLAYER_COLORS[14] = { 170, 110, 40 }
PLAYER_COLORS[15] = { 0, 0, 128 }
PLAYER_COLORS[16] = { 230, 190, 255 }
PLAYER_COLORS[17] = { 128, 0, 0 }
PLAYER_COLORS[18] = { 144, 144, 144 }
PLAYER_COLORS[19] = { 254, 254, 254 }
PLAYER_COLORS[20] = { 166, 166, 166 }
PLAYER_COLORS[21] = { 255, 89, 255 }
PLAYER_COLORS[22] = { 203, 255, 89 }
PLAYER_COLORS[23] = { 108, 167, 255 }

USE_AUTOMATIC_PLAYERS_PER_TEAM = false										-- Should we set the number of players to 10 / MAX_NUMBER_OF_TEAMS?

CUSTOM_TEAM_PLAYER_COUNT = {}
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 5
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 5

TEAM_COLORS = {}															-- If USE_CUSTOM_TEAM_COLORS is set, use these colors.
TEAM_COLORS[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }							-- Teal
TEAM_COLORS[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }							-- Yellow

if GetMapName() == "imba_standard" then

elseif GetMapName() == "imba_frantic_10v10" then
	IMBA_PLAYERS_ON_GAME = 20
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 10
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 10
elseif GetMapName() == "imba_10v10" then
	IMBA_PLAYERS_ON_GAME = 20
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 10
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 10
elseif GetMapName() == "imba_12v12" then
	IMBA_PLAYERS_ON_GAME = 24
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 12
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 12
elseif GetMapName() == "imba_overthrow" then
	require("libraries/overthrow/items")
	PRE_GAME_TIME = 20.0 + HERO_SELECTION_TIME
	UNIVERSAL_SHOP_MODE = true
	FIXED_RESPAWN_TIME = 10
	MAX_NUMBER_OF_TEAMS = 2
	IMBA_PLAYERS_ON_GAME = 10
	USE_CUSTOM_TEAM_COLORS = true						-- Should we use custom team colors?
	USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS = true			-- Should we use custom team colors to color the players/minimap?
	TEAM_COLORS[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }	-- Teal
	TEAM_COLORS[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }	-- Yellow
	TEAM_COLORS[DOTA_TEAM_CUSTOM_1]  = { 197, 77, 168 }	-- Pink
	TEAM_COLORS[DOTA_TEAM_CUSTOM_2]  = { 255, 108, 0 }	-- Orange
	TEAM_COLORS[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }	-- Blue

	m_GoldRadiusMin = 250
	m_GoldRadiusMax = 550
	m_GoldDropPercent = 4
	nNextSpawnItemNumber = 1
	spawnTime = 120
	leadingTeam = -1
	runnerupTeam = -1
	leadingTeamScore = 0
	OVERTHROW_CAMP_NUMBER = 5
	CLOSE_TO_VICTORY_THRESHOLD = 5

	hasWarnedSpawn = false
	allSpawned = false
	countdownEnabled = false
	isGameTied = false

	itemSpawnIndex = 1
	itemSpawnLocation = Entities:FindByName( nil, "greevil" )
	tier1ItemBucket = {}
	tier2ItemBucket = {}
	tier3ItemBucket = {}
	tier4ItemBucket = {}

	m_VictoryMessages = {}
	m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys"
	m_VictoryMessages[DOTA_TEAM_BADGUYS]  = "#VictoryMessage_BadGuys"
	m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"
	m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#VictoryMessage_Custom2"
	m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#VictoryMessage_Custom3"
	--	m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#VictoryMessage_Custom4"
	--	m_VictoryMessages[DOTA_TEAM_CUSTOM_5] = "#VictoryMessage_Custom5"
	--	m_VictoryMessages[DOTA_TEAM_CUSTOM_6] = "#VictoryMessage_Custom6"
	--	m_VictoryMessages[DOTA_TEAM_CUSTOM_7] = "#VictoryMessage_Custom7"
	--	m_VictoryMessages[DOTA_TEAM_CUSTOM_8] = "#VictoryMessage_Custom8"

	m_GatheredShuffledTeams = {}

	--	if PlayerResource:GetPlayerCount() > 7 then
	TEAM_KILLS_TO_WIN = 25
	nCOUNTDOWNTIMER = 601
	--	elseif PlayerResource:GetPlayerCount() > 4 and PlayerResource:GetPlayerCount() <= 7 then
	--		TEAM_KILLS_TO_WIN = 20
	--		nCOUNTDOWNTIMER = 721
	--	else
	--		TEAM_KILLS_TO_WIN = 15
	--		nCOUNTDOWNTIMER = 601
	--	end
	CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = TEAM_KILLS_TO_WIN } );
end

-------------------------------------------------------------------------------------------------
-- IMBA: game mode globals
-------------------------------------------------------------------------------------------------
GAME_WINNER_TEAM = 0														-- Tracks game winner

if GetMapName() ~= "imba_frantic_10v10" then
	IMBA_FRANTIC_MODE_ON = false
else
	IMBA_FRANTIC_MODE_ON = true
end

IMBA_FRANTIC_VALUE = 0.4													-- 60% CDR

IMBA_PICK_MODE_ALL_PICK = true												-- Activates All Pick mode when true
IMBA_PICK_MODE_ALL_RANDOM = false											-- Activates All Random mode when true
IMBA_PICK_MODE_ALL_RANDOM_SAME_HERO = false									-- Activates All Random Same Hero mode when true
IMBA_ALL_RANDOM_HERO_SELECTION_TIME = 5.0									-- Time we need to wait before the game starts when all heroes are randomed

-- Global Gold earning, values are doubled with Hyper for non-custom maps
CUSTOM_GOLD_BONUS = {} -- 1 = Normal, 2 = Hyper
CUSTOM_GOLD_BONUS["imba_standard"] = {150, 150}
CUSTOM_GOLD_BONUS["imba_10v10"] = {150, 150}
CUSTOM_GOLD_BONUS["imba_frantic_10v10"] = {250, 250}
CUSTOM_GOLD_BONUS["imba_overthrow"] = {100, 100}

-- Global XP earning, values are doubled with Hyper for non-custom maps (right now this is not used anymore, but i'll keep it there just in case)
CUSTOM_XP_BONUS = {} -- 1 = Normal, 2 = Hyper
CUSTOM_XP_BONUS["imba_standard"] = {100, 100}
CUSTOM_XP_BONUS["imba_10v10"] = {100, 100}
CUSTOM_XP_BONUS["imba_frantic_10v10"] = {200, 200}
CUSTOM_XP_BONUS["imba_overthrow"] = {100, 100}

-- Hero base level, values are doubled with Hyper for non-custom maps
HERO_STARTING_LEVEL = {} -- 1 = Normal, 2 = Hyper
HERO_STARTING_LEVEL["imba_standard"] = {1, 1}
HERO_STARTING_LEVEL["imba_10v10"] = {1, 1}
HERO_STARTING_LEVEL["imba_frantic_10v10"] = {5, 12}
HERO_STARTING_LEVEL["imba_overthrow"] = {1, 1}

MAX_LEVEL = {}
MAX_LEVEL["imba_standard"] = {50, 50}
MAX_LEVEL["imba_10v10"] = {50, 50}
MAX_LEVEL["imba_frantic_10v10"] = {50, 100}
MAX_LEVEL["imba_overthrow"] = {50, 50}

HERO_INITIAL_GOLD = {}
HERO_INITIAL_GOLD["imba_standard"] = {1200, 1200}
HERO_INITIAL_GOLD["imba_10v10"] = {1200, 1200}
HERO_INITIAL_GOLD["imba_frantic_10v10"] = {2500, 5000}
HERO_INITIAL_GOLD["imba_overthrow"] = {1200, 1200}

GOLD_TICK_TIME = {}
GOLD_TICK_TIME["imba_standard"] = 0.6
GOLD_TICK_TIME["imba_10v10"] = 0.4
GOLD_TICK_TIME["imba_frantic_10v10"] = 0.4
GOLD_TICK_TIME["imba_overthrow"] = 0.6

REMAINING_GOODGUYS = 0														-- Remaining players on Radiant
REMAINING_BADGUYS = 0														-- Remaining players on Dire

ANCIENT_ABILITIES_LIST = {}													-- Initializes the ancients' abilities list
SPAWN_ANCIENT_BEHEMOTHS = true												-- Should the ancients spawn behemoths?
TOWER_ABILITY_MODE = true													-- Should towers gain random unique abilities?
TOWER_UPGRADE_MODE = true													-- Should tower abilities be upgradeable?
TOWER_POWER_FACTOR = 1														-- Tower durability/damage increase factor (0 = default)
TOWER_UPGRADE_TREE = {}														-- Stores the tower upgrades for this game if necessary
TOWER_UPGRADE_TREE["safelane"] = {}
TOWER_UPGRADE_TREE["midlane"] = {}
TOWER_UPGRADE_TREE["hardlane"] = {}
TOWER_UPGRADE_TREE["safelane"]["tier_1"] = {}
TOWER_UPGRADE_TREE["safelane"]["tier_2"] = {}
TOWER_UPGRADE_TREE["safelane"]["tier_3"] = {}
TOWER_UPGRADE_TREE["midlane"]["tier_1"] = {}
TOWER_UPGRADE_TREE["midlane"]["tier_2"] = {}
TOWER_UPGRADE_TREE["midlane"]["tier_3"] = {}
TOWER_UPGRADE_TREE["midlane"]["tier_41"] = {}
TOWER_UPGRADE_TREE["midlane"]["tier_42"] = {}
TOWER_UPGRADE_TREE["hardlane"]["tier_1"] = {}
TOWER_UPGRADE_TREE["hardlane"]["tier_2"] = {}
TOWER_UPGRADE_TREE["hardlane"]["tier_3"] = {}

MAP_INITIAL_GOLD = 0														-- Gold granted to players at the start of the game on a normal pick
USE_CUSTOM_HERO_LEVELS = true												-- Should we allow heroes to have custom levels?

-- Update game mode net tables
CustomNetTables:SetTableValue("game_options", "all_pick", {IMBA_PICK_MODE_ALL_PICK})
CustomNetTables:SetTableValue("game_options", "all_random", {IMBA_PICK_MODE_ALL_RANDOM})
CustomNetTables:SetTableValue("game_options", "all_random_same_hero", {IMBA_PICK_MODE_ALL_RANDOM_SAME_HERO})
CustomNetTables:SetTableValue("game_options", "frantic_mode", {IMBA_FRANTIC_MODE_ON})
CustomNetTables:SetTableValue("game_options", "gold_tick", {GOLD_TICK_TIME[GetMapName()]})
CustomNetTables:SetTableValue("game_options", "max_level", {MAX_LEVEL[GetMapName()]})

-- XP per level table (only active if custom hero levels are enabled)
XP_PER_LEVEL_TABLE = {}

-- Vanilla
XP_PER_LEVEL_TABLE[1] =		0		-- +0
XP_PER_LEVEL_TABLE[2] =		200		-- +200
XP_PER_LEVEL_TABLE[3] =		600		-- +400
XP_PER_LEVEL_TABLE[4] =		1080	-- +480
XP_PER_LEVEL_TABLE[5] =		1680	-- +600
XP_PER_LEVEL_TABLE[6] =		2300	-- +620
XP_PER_LEVEL_TABLE[7] =		2940	-- +640
XP_PER_LEVEL_TABLE[8] =		3600	-- +660
XP_PER_LEVEL_TABLE[9] =		4280	-- +680
XP_PER_LEVEL_TABLE[10] =	5080	-- +800
XP_PER_LEVEL_TABLE[11] =	5900	-- +820
XP_PER_LEVEL_TABLE[12] =	6740	-- +840
XP_PER_LEVEL_TABLE[13] =	7640	-- +900
XP_PER_LEVEL_TABLE[14] =	8865	-- +1225
XP_PER_LEVEL_TABLE[15] =	10115	-- +1250
XP_PER_LEVEL_TABLE[16] =	11390	-- +1275
XP_PER_LEVEL_TABLE[17] =	12690	-- +1300
XP_PER_LEVEL_TABLE[18] =	14015	-- +1325
XP_PER_LEVEL_TABLE[19] =	15415	-- +1400
XP_PER_LEVEL_TABLE[20] =	16905	-- +1490
XP_PER_LEVEL_TABLE[21] =	18405	-- +1500
XP_PER_LEVEL_TABLE[22] =	20155	-- +1750
XP_PER_LEVEL_TABLE[23] =	22155	-- +2000
XP_PER_LEVEL_TABLE[24] =	24405	-- +2250
XP_PER_LEVEL_TABLE[25] =	26905	-- +2500

-- XP AWARDED per level table (how much bounty heroes are worth beyond level 25)
HERO_XP_BOUNTY_PER_LEVEL = {}
HERO_XP_BOUNTY_PER_LEVEL[1] = 125
HERO_XP_BOUNTY_PER_LEVEL[2] = 170
HERO_XP_BOUNTY_PER_LEVEL[3] = 215
HERO_XP_BOUNTY_PER_LEVEL[4] = 260
HERO_XP_BOUNTY_PER_LEVEL[5] = 305
HERO_XP_BOUNTY_PER_LEVEL[6] = 350
HERO_XP_BOUNTY_PER_LEVEL[7] = 395

for i = 8, 20 do
	HERO_XP_BOUNTY_PER_LEVEL[i] = HERO_XP_BOUNTY_PER_LEVEL[i-1] + 135
end

for i = 21, 100 do
	HERO_XP_BOUNTY_PER_LEVEL[i] = HERO_XP_BOUNTY_PER_LEVEL[i-1] + 135 + i * 3
end

USE_MEME_SOUNDS = true														-- Should we use meme/fun sounds on abilities occasionally?

-------------------------------------------------------------------------------------------------
-- IMBA: Test mode variables
-------------------------------------------------------------------------------------------------

IMBA_TESTBED_INITIALIZED = false

-------------------------------------------------------------------------------------------------
-- IMBA: Keyvalue tables
-------------------------------------------------------------------------------------------------

TOWER_ABILITIES = LoadKeyValues("scripts/npc/KV/tower_abilities.kv")
PURGE_BUFF_LIST = LoadKeyValues("scripts/npc/KV/purge_buffs_list.kv")
DISPELLABLE_DEBUFF_LIST = LoadKeyValues("scripts/npc/KV/dispellable_debuffs_list.kv")
