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

USE_TEAM_COURIER = true
PICKING_SCREEN_OVER = false
ENABLE_HERO_RESPAWN = true					-- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = false					-- Should the main shop contain Secret Shop items as well as regular items
if IsInToolsMode() then
	UNIVERSAL_SHOP_MODE = true
end

AP_GAME_TIME = 60.0					-- How long should we let people select their hero?

CAPTAINS_MODE_CAPTAIN_TIME = 20           -- how long players have to claim the captain chair
CAPTAINS_MODE_PICK_BAN_TIME = 30          -- how long you have to do each pick/ban
CAPTAINS_MODE_HERO_PICK_TIME = 30         -- time to choose which hero you're going to play
CAPTAINS_MODE_RESERVE_TIME = 130          -- total bonus time that can be used throughout any selection

PRE_GAME_TIME = 90.0
if GetMapName() == "cavern" then
	PRE_GAME_TIME = 30.0
end
PRE_GAME_TIME = PRE_GAME_TIME + AP_GAME_TIME	-- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 600.0						-- How long should we let people look at the scoreboard before closing the server automatically?
AUTO_LAUNCH_DELAY = 5.0					-- How long should we wait for the host to setup the game, after all players have loaded in?
if IsFranticMap() then
	AUTO_LAUNCH_DELAY = 10.0
end
TREE_REGROW_TIME = 180.0					-- How long should it take individual trees to respawn after being cut down/destroyed?
SHOWCASE_TIME = 0.0							-- How long should showcase time last?
STRATEGY_TIME = 0.0							-- How long should strategy time last?

GOLD_PER_TICK = 1							-- How much gold should players get per tick?

RECOMMENDED_BUILDS_DISABLED = false			-- Should we disable the recommened builds for heroes

MINIMAP_ICON_SIZE = 1						-- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1					-- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1					-- What icon size should we use for runes?

RUNE_SPAWN_TIME = 120						-- How long in seconds should we wait between rune spawns?
BOUNTY_RUNE_SPAWN_TIME = 300
CUSTOM_BUYBACK_COST_ENABLED = true			-- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = true		-- Should we use a custom buyback time?
BUYBACK_ENABLED = true						-- Should we allow people to buyback when they die?

-- Note: DISABLE_FOG_OF_WAR_ENTIRELY must be false for USE_UNSEEN_FOG_OF_WAR to work
USE_STANDARD_DOTA_BOT_THINKING = false		-- Should we have bots act like they would in Dota? (This requires 3 lanes, normal items, etc)
USE_NONSTANDARD_HERO_GOLD_BOUNTY = false	-- Should heroes follow their own gold bounty rules instead of the default DOTA ones?
USE_NONSTANDARD_HERO_XP_BOUNTY = true		-- Should heroes follow their own XP bounty rules instead of the default DOTA ones?

USE_CUSTOM_TOP_BAR_VALUES = false			-- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true						-- Should we display the top bar score/count at all?

ENABLE_TOWER_BACKDOOR_PROTECTION = true		-- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false			-- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false					-- Should we disable the gold sound when players get gold?

ENABLE_FIRST_BLOOD = true					-- Should we enable first blood for the first kill in this game?
HIDE_KILL_BANNERS = false					-- Should we hide the kill banners that show when a player is killed?
LOSE_GOLD_ON_DEATH = true					-- Should we have players lose the normal amount of dota gold on death?
FORCE_PICKED_HERO = "npc_dota_hero_dummy_dummy"						-- What hero should we force all players to spawn as? (e.g. "npc_dota_hero_axe").  Use nil to allow players to pick their own hero.

FIXED_RESPAWN_TIME = -1						-- What time should we use for a fixed respawn timer?  Use -1 to keep the default dota behavior.
FOUNTAIN_CONSTANT_MANA_REGEN = 14			-- What should we use for the constant fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_MANA_REGEN = 6			-- What should we use for the percentage fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_HEALTH_REGEN = 6		-- What should we use for the percentage fountain health regen?  Use -1 to keep the default dota behavior.
MAXIMUM_ATTACK_SPEED = 1000					-- What should we use for the maximum attack speed?
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
HERO_RESPAWN_TIME_PER_LEVEL[1] = 5
HERO_RESPAWN_TIME_PER_LEVEL[2] = 10
HERO_RESPAWN_TIME_PER_LEVEL[3] = 13
HERO_RESPAWN_TIME_PER_LEVEL[4] = 15
HERO_RESPAWN_TIME_PER_LEVEL[5] = 18
HERO_RESPAWN_TIME_PER_LEVEL[6] = 20
HERO_RESPAWN_TIME_PER_LEVEL[7] = 22
HERO_RESPAWN_TIME_PER_LEVEL[8] = 24
HERO_RESPAWN_TIME_PER_LEVEL[9] = 25
HERO_RESPAWN_TIME_PER_LEVEL[10] = 27
HERO_RESPAWN_TIME_PER_LEVEL[11] = 29
HERO_RESPAWN_TIME_PER_LEVEL[12] = 30
HERO_RESPAWN_TIME_PER_LEVEL[13] = 32
HERO_RESPAWN_TIME_PER_LEVEL[14] = 33
HERO_RESPAWN_TIME_PER_LEVEL[15] = 34
HERO_RESPAWN_TIME_PER_LEVEL[16] = 35
HERO_RESPAWN_TIME_PER_LEVEL[17] = 37
HERO_RESPAWN_TIME_PER_LEVEL[18] = 38
HERO_RESPAWN_TIME_PER_LEVEL[19] = 39
HERO_RESPAWN_TIME_PER_LEVEL[20] = 40
HERO_RESPAWN_TIME_PER_LEVEL[21] = 41
HERO_RESPAWN_TIME_PER_LEVEL[22] = 42
HERO_RESPAWN_TIME_PER_LEVEL[23] = 43
HERO_RESPAWN_TIME_PER_LEVEL[24] = 44
HERO_RESPAWN_TIME_PER_LEVEL[25] = 45
HERO_RESPAWN_TIME_PER_LEVEL[26] = 46
HERO_RESPAWN_TIME_PER_LEVEL[27] = 47
HERO_RESPAWN_TIME_PER_LEVEL[28] = 48
HERO_RESPAWN_TIME_PER_LEVEL[29] = 49
HERO_RESPAWN_TIME_PER_LEVEL[30] = 50
HERO_RESPAWN_TIME_PER_LEVEL[31] = 51
HERO_RESPAWN_TIME_PER_LEVEL[32] = 52
HERO_RESPAWN_TIME_PER_LEVEL[33] = 53
HERO_RESPAWN_TIME_PER_LEVEL[34] = 54
HERO_RESPAWN_TIME_PER_LEVEL[35] = 55
HERO_RESPAWN_TIME_PER_LEVEL[36] = 55
HERO_RESPAWN_TIME_PER_LEVEL[37] = 56
HERO_RESPAWN_TIME_PER_LEVEL[38] = 57
HERO_RESPAWN_TIME_PER_LEVEL[39] = 58
HERO_RESPAWN_TIME_PER_LEVEL[40] = 59
HERO_RESPAWN_TIME_PER_LEVEL[41] = 60
HERO_RESPAWN_TIME_PER_LEVEL[42] = 60

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

TEAM_COLORS = {}															-- If USE_CUSTOM_TEAM_COLORS is set, use these colors.
TEAM_COLORS[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }							-- Teal
TEAM_COLORS[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }							-- Yellow

CUSTOM_TEAM_PLAYER_COUNT = {}
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 5
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 5

if GetMapName() == "imba_1v1" then
	IMBA_PLAYERS_ON_GAME = 2
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 1
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 1
	IMBA_1V1_SCORE = 3
	PRE_GAME_TIME = 30.0 + AP_GAME_TIME
elseif GetMapName() == "imba_ranked_10v10" or GetMapName() == "imba_frantic_10v10"  or GetMapName() == "imba_mutation_10v10" then
	IMBA_PLAYERS_ON_GAME = 20
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 10
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 10
elseif GetMapName() == "imba_12v12" then
	IMBA_PLAYERS_ON_GAME = 24
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 12
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 12
elseif GetMapName() == "imba_overthrow" then
	require("libraries/overthrow/items")
	PRE_GAME_TIME = 20.0 + AP_GAME_TIME
	UNIVERSAL_SHOP_MODE = true
	FIXED_RESPAWN_TIME = 10
	MAX_NUMBER_OF_TEAMS = 4
	IMBA_PLAYERS_ON_GAME = 16
	USE_CUSTOM_TEAM_COLORS = true						-- Should we use custom team colors?
	USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS = true			-- Should we use custom team colors to color the players/minimap?
	TEAM_COLORS[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }	-- Teal
	TEAM_COLORS[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }	-- Yellow
	TEAM_COLORS[DOTA_TEAM_CUSTOM_1]  = { 197, 77, 168 }	-- Pink
	TEAM_COLORS[DOTA_TEAM_CUSTOM_2]  = { 255, 108, 0 }	-- Orange

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

	m_GatheredShuffledTeams = {}

--	if PlayerResource:GetPlayerCount() > 7 then
	TEAM_KILLS_TO_WIN = 50
	nCOUNTDOWNTIMER = 901
--	elseif PlayerResource:GetPlayerCount() > 4 and PlayerResource:GetPlayerCount() <= 7 then
--		TEAM_KILLS_TO_WIN = 20
--		nCOUNTDOWNTIMER = 721
--	else
--		TEAM_KILLS_TO_WIN = 15
--		nCOUNTDOWNTIMER = 601
--	end

	CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = TEAM_KILLS_TO_WIN } );
elseif GetMapName() == "cavern" then
	IMBA_PLAYERS_ON_GAME = 24
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 3
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 3
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_1]  = 3
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_2]  = 3
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_3]  = 3
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_4]  = 3
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_5]  = 3
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_6]  = 3
end

-------------------------------------------------------------------------------------------------
-- IMBA: game mode globals
-------------------------------------------------------------------------------------------------
GAME_WINNER_TEAM = 0														-- Tracks game winner
GG_TEAM = {}
GG_TEAM[2] = 0
GG_TEAM[3] = 0

if IsFranticMap() then
	IMBA_FRANTIC_MODE_ON = true
else
	IMBA_FRANTIC_MODE_ON = false
end

_G.IMBA_FRANTIC_VALUE = 50

IMBA_PICK_MODE_ALL_PICK = true												-- Activates All Pick mode when true
IMBA_PICK_MODE_ALL_RANDOM = false											-- Activates All Random mode when true
IMBA_PICK_MODE_ALL_RANDOM_SAME_HERO = false									-- Activates All Random Same Hero mode when true
IMBA_ALL_RANDOM_HERO_SELECTION_TIME = 5.0									-- Time we need to wait before the game starts when all heroes are randomed

-- Global Gold earning, values are doubled with Hyper for non-custom maps
CUSTOM_GOLD_BONUS = {} -- 1 = Normal, 2 = Hyper
CUSTOM_GOLD_BONUS["imba_1v1"] = 250
CUSTOM_GOLD_BONUS["imba_overthrow"] = 250
CUSTOM_GOLD_BONUS["imba_ranked_5v5"] = 250
CUSTOM_GOLD_BONUS["imba_ranked_10v10"] = 250
CUSTOM_GOLD_BONUS["imba_tournament"] = 250
CUSTOM_GOLD_BONUS["imba_mutation_5v5"] = 400
CUSTOM_GOLD_BONUS["imba_mutation_10v10"] = 400
CUSTOM_GOLD_BONUS["imba_frantic_5v5"] = 400
CUSTOM_GOLD_BONUS["imba_frantic_10v10"] = 400
CUSTOM_GOLD_BONUS["cavern"] = 200

-- Global XP earning, values are doubled with Hyper for non-custom maps (right now this is not used anymore, but i'll keep it there just in case)
CUSTOM_XP_BONUS = {} -- 1 = Normal, 2 = Hyper
CUSTOM_XP_BONUS["imba_1v1"] = 200
CUSTOM_XP_BONUS["imba_overthrow"] = 200
CUSTOM_XP_BONUS["imba_ranked_5v5"] = 200
CUSTOM_XP_BONUS["imba_ranked_10v10"] = 200
CUSTOM_XP_BONUS["imba_tournament"] = 200
CUSTOM_XP_BONUS["imba_mutation_5v5"] = 200
CUSTOM_XP_BONUS["imba_mutation_10v10"] = 200
CUSTOM_XP_BONUS["imba_frantic_5v5"] = 200
CUSTOM_XP_BONUS["imba_frantic_10v10"] = 200
CUSTOM_XP_BONUS["cavern"] = 100

-- Hero base level, values are doubled with Hyper for non-custom maps
HERO_STARTING_LEVEL = {} -- 1 = Normal, 2 = Hyper
HERO_STARTING_LEVEL["imba_1v1"] = 1
HERO_STARTING_LEVEL["imba_overthrow"] = 1
HERO_STARTING_LEVEL["imba_ranked_5v5"] = 1
HERO_STARTING_LEVEL["imba_ranked_10v10"] = 1
HERO_STARTING_LEVEL["imba_tournament"] = 1
HERO_STARTING_LEVEL["imba_mutation_5v5"] = 5
HERO_STARTING_LEVEL["imba_mutation_10v10"] = 5
HERO_STARTING_LEVEL["imba_frantic_5v5"] = 5
HERO_STARTING_LEVEL["imba_frantic_10v10"] = 5
HERO_STARTING_LEVEL["cavern"] = 1

MAX_LEVEL = {}
MAX_LEVEL["imba_1v1"] = 42
MAX_LEVEL["imba_overthrow"] = 42
MAX_LEVEL["imba_ranked_5v5"] = 42
MAX_LEVEL["imba_ranked_10v10"] = 42
MAX_LEVEL["imba_tournament"] = 42
MAX_LEVEL["imba_mutation_5v5"] = 42
MAX_LEVEL["imba_mutation_10v10"] = 42
MAX_LEVEL["imba_frantic_5v5"] = 42
MAX_LEVEL["imba_frantic_10v10"] = 42
MAX_LEVEL["cavern"] = 42

HERO_INITIAL_GOLD = {}
HERO_INITIAL_GOLD["imba_1v1"] = 1200
HERO_INITIAL_GOLD["imba_overthrow"] = 1200
HERO_INITIAL_GOLD["imba_ranked_5v5"] = 1200
HERO_INITIAL_GOLD["imba_ranked_10v10"] = 1200
HERO_INITIAL_GOLD["imba_tournament"] = 1200
HERO_INITIAL_GOLD["imba_mutation_5v5"] = 2000
HERO_INITIAL_GOLD["imba_mutation_10v10"] = 2000
HERO_INITIAL_GOLD["imba_frantic_5v5"] = 4000
HERO_INITIAL_GOLD["imba_frantic_10v10"] = 4000
HERO_INITIAL_GOLD["cavern"] = 1200

GOLD_TICK_TIME = {}
GOLD_TICK_TIME["imba_1v1"] = 0.6
GOLD_TICK_TIME["imba_overthrow"] = 0.6
GOLD_TICK_TIME["imba_ranked_5v5"] = 0.6
GOLD_TICK_TIME["imba_ranked_10v10"] = 0.4
GOLD_TICK_TIME["imba_tournament"] = 0.6
GOLD_TICK_TIME["imba_mutation_5v5"] = 0.6
GOLD_TICK_TIME["imba_mutation_10v10"] = 0.4
GOLD_TICK_TIME["imba_frantic_5v5"] = 0.4
GOLD_TICK_TIME["imba_frantic_10v10"] = 0.4
GOLD_TICK_TIME["cavern"] = 9999.0

BANNED_ITEMS = {}
BANNED_ITEMS["imba_1v1"] = {
	"item_imba_bottle",
	"item_infused_raindrop",
	"item_soul_ring",
	"item_tome_of_knowledge",
}
BANNED_ITEMS["imba_overthrow"] = {
	"item_cavern_dynamite",
}
BANNED_ITEMS["imba_ranked_5v5"] = {
	"item_cavern_dynamite",
}
BANNED_ITEMS["imba_ranked_10v10"] = {
	"item_cavern_dynamite",
}
BANNED_ITEMS["imba_tournament"] = {
	"item_cavern_dynamite",
}
BANNED_ITEMS["imba_mutation_5v5"] = {
	"item_cavern_dynamite",
}
BANNED_ITEMS["imba_mutation_10v10"] = {
	"item_cavern_dynamite",
}
BANNED_ITEMS["imba_frantic_5v5"] = {
	"item_cavern_dynamite",
}
BANNED_ITEMS["imba_frantic_10v10"] = {
	"item_cavern_dynamite",
}
BANNED_ITEMS["cavern"] = {
	"item_imba_aegis",
	"item_imba_bottle",
	"item_imba_hand_of_midas",
	"item_recipe_imba_hand_of_midas",
	"item_imba_heart",
	"item_helm_of_the_dominator",
	"item_smoke_of_deceit",
	"item_tome_of_knowledge",
	"item_tpscroll",
	"item_imba_blink",
	"item_imba_blink_boots",
}

REMAINING_GOODGUYS = 0														-- Remaining players on Radiant
REMAINING_BADGUYS = 0														-- Remaining players on Dire

ANCIENT_ABILITIES_LIST = {}													-- Initializes the ancients' abilities list
SPAWN_ANCIENT_BEHEMOTHS = true												-- Should the ancients spawn behemoths?

TOWER_ABILITIES = {}

TOWER_ABILITIES["tower1"] = {
	"imba_tower_healing_tower",
	"imba_tower_tenacity",
}

TOWER_ABILITIES["tower2"] = {
	"imba_tower_healing_tower",
	"imba_tower_regeneration",
	"imba_tower_tenacity",
	"imba_tower_toughness",
}

TOWER_ABILITIES["tower3"] = {
	"imba_tower_healing_tower",
	"imba_tower_regeneration",
	"imba_tower_tenacity",
	"imba_tower_toughness",
}

TOWER_ABILITIES["tower4"] = {
	"imba_tower_healing_tower",
	"imba_tower_regeneration",
	"imba_tower_tenacity",
	"imba_tower_toughness",
}

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

for i = 8, 25 do
	HERO_XP_BOUNTY_PER_LEVEL[i] = HERO_XP_BOUNTY_PER_LEVEL[i-1] + 135
end

for i = 26, 100 do
	HERO_XP_BOUNTY_PER_LEVEL[i] = HERO_XP_BOUNTY_PER_LEVEL[i-1] + 135 + i * 3
end

USE_MEME_SOUNDS = true														-- Should we use meme/fun sounds on abilities occasionally?
BOTS_ENABLED = false

-------------------------------------------------------------------------------------------------
-- IMBA: Test mode variables
-------------------------------------------------------------------------------------------------

IMBA_TESTBED_INITIALIZED = false

-------------------------------------------------------------------------------------------------
-- IMBA: Keyvalue tables
-------------------------------------------------------------------------------------------------

PURGE_BUFF_LIST = LoadKeyValues("scripts/npc/KV/purge_buffs_list.kv")
DISPELLABLE_DEBUFF_LIST = LoadKeyValues("scripts/npc/KV/dispellable_debuffs_list.kv")

PLAYER_TEAM = {}

DONATOR_COLOR = {}
DONATOR_COLOR[1] = {160, 20, 20}
DONATOR_COLOR[2] = {100, 20, 20}
DONATOR_COLOR[3] = {0, 102, 255}
DONATOR_COLOR[4] = {240, 50, 50}
DONATOR_COLOR[5] = {218, 165, 32}
DONATOR_COLOR[6] = {45, 200, 45}
DONATOR_COLOR[7] = {47, 91, 151}
DONATOR_COLOR[8] = {153, 51, 153}
DONATOR_COLOR[9] = {255, 135, 42}

IMBA_INVISIBLE_MODIFIERS = {
	"modifier_imba_moonlight_shadow_invis",
	"modifier_item_imba_shadow_blade_invis",
	"modifier_imba_vendetta",
	"modifier_nyx_assassin_burrow",
	"modifier_item_imba_silver_edge_invis",
	"modifier_item_glimmer_cape_fade",
	"modifier_weaver_shukuchi",
	"modifier_treant_natures_guise_invis",
	"modifier_templar_assassin_meld",
	"modifier_imba_skeleton_walk_dummy",
	"modifier_invoker_ghost_walk_self",
	"modifier_rune_invis",
	"modifier_imba_skeleton_walk_invis",
	"modifier_imba_riki_invisibility",
	"modifier_imba_shadow_walk_buff_invis",
	"modifier_imba_invisibility_rune",
}

IGNORE_FOUNTAIN_UNITS = {
	"npc_dota_elder_titan_ancestral_spirit",
	"npc_dummy_unit",
	"npc_dota_hero_dummy_dummy",
	"npc_imba_donator_companion",
	"npc_dota_wisp_spirit",
}

RESTRICT_FOUNTAIN_UNITS = {
	"npc_dota_unit_tombstone1",
	"npc_dota_unit_tombstone2",
	"npc_dota_unit_tombstone3",
	"npc_dota_unit_tombstone4",
	"npc_dota_unit_undying_zombie",
	"npc_dota_unit_undying_zombie_torso",
	"npc_imba_ember_spirit_remnant",
	"npc_imba_dota_stormspirit_remnant",
	"npc_dota_earth_spirit_stone",
	"npc_dota_tusk_frozen_sigil1",
	"npc_dota_tusk_frozen_sigil2",
	"npc_dota_tusk_frozen_sigil3",
	"npc_dota_tusk_frozen_sigil4",
	"imba_witch_doctor_death_ward",
	"npc_imba_techies_proximity_mine",
	"npc_imba_techies_proximity_mine_big_boom",
	"npc_imba_techies_stasis_trap",
}

MORPHLING_RESTRICTED_MODIFIERS = {
	"modifier_imba_riki_invisibility",
	"modifier_imba_ebb_and_flow_thinker",
	"modifier_imba_ebb_and_flow_tide_low",
	"modifier_imba_ebb_and_flow_tide_red",
	"modifier_imba_ebb_and_flow_tide_flood",
	"modifier_imba_ebb_and_flow_tide_high",
	"modifier_imba_ebb_and_flow_tide_wave",
	"modifier_imba_ebb_and_flow_tsunami",
	"modifier_imba_tidebringer",
	"modifier_imba_tidebringer_sword_particle",
	"modifier_imba_tidebringer_manual",
	"modifier_imba_tidebringer_slow",
	"modifier_imba_tidebringer_cleave_hit_target",
}

SHARED_NODRAW_MODIFIERS = {
	"modifier_item_shadow_amulet_fade",
	"modifier_monkey_king_tree_dance_hidden",
	"modifier_monkey_king_transform",
	"modifier_pangolier_gyroshell",
	"modifier_smoke_of_deceit",
}

IMBA_DONATOR_COMPANION = {}
IMBA_DONATOR_COMPANION["76561198015161808"] = "npc_imba_donator_companion_cookies"
IMBA_DONATOR_COMPANION["76561198094835750"] = "npc_imba_donator_companion_zonnoz"
IMBA_DONATOR_COMPANION["76561198003571172"] = "npc_imba_donator_companion_baumi"
IMBA_DONATOR_COMPANION["76561198014254115"] = "npc_imba_donator_companion_icefrog"
IMBA_DONATOR_COMPANION["76561198014254115"] = "npc_imba_donator_companion_admiral_bulldog"
IMBA_DONATOR_COMPANION["76561198021465788"] = "npc_imba_donator_companion_suthernfriend"
IMBA_DONATOR_COMPANION["76561198073163389"] = "npc_imba_donator_companion_terdic"
IMBA_DONATOR_COMPANION["76561197970766309"] = "npc_imba_donator_companion_hamahe"
IMBA_DONATOR_COMPANION["76561193687456266"] = "npc_imba_donator_companion_exzas"
-- IMBA_DONATOR_COMPANION["76561198330946475"] = "npc_imba_donator_companion_deadknight"

IMBA_DONATOR_STATUE = {}
IMBA_DONATOR_STATUE["76561198015161808"] = "npc_imba_donator_statue_cookies"
IMBA_DONATOR_STATUE["76561193714760494"] = "npc_imba_donator_statue_acalia"
IMBA_DONATOR_STATUE["76561193684594183"] = "npc_imba_donator_statue_lily"
IMBA_DONATOR_STATUE["76561198021465788"] = "npc_imba_donator_statue_suthernfriend"
IMBA_DONATOR_STATUE["76561193687456266"] = "npc_imba_donator_statue_exzas"
IMBA_DONATOR_STATUE["76561198094835750"] = "npc_imba_donator_statue_zonnoz"
-- IMBA_DONATOR_STATUE["76561198043254407"] = "npc_imba_donator_statue_tabisama"
IMBA_DONATOR_STATUE["76561197980558838"] = "npc_imba_donator_statue_january0000"
IMBA_DONATOR_STATUE["76561198073163389"] = "npc_imba_donator_statue_terdic"
IMBA_DONATOR_STATUE["76561198077187165"] = "npc_imba_donator_statue_toc"
IMBA_DONATOR_STATUE["76561198187809623"] = "npc_imba_donator_statue_oviakin"
IMBA_DONATOR_STATUE["76561197970766309"] = "npc_imba_donator_statue_hamahe"
-- IMBA_DONATOR_STATUE["76561198330946475"] = "npc_imba_donator_statue_deadknight"

UNIT_EQUIPMENT = {}
UNIT_EQUIPMENT["models/heroes/crystal_maiden/crystal_maiden.vmdl"] = {
	"models/heroes/crystal_maiden/crystal_maiden_staff.vmdl",
	"models/heroes/crystal_maiden/crystal_maiden_cuffs.vmdl",
	"models/heroes/crystal_maiden/crystal_maiden_cape.vmdl",
	"models/heroes/crystal_maiden/head_item.vmdl",
	"models/heroes/crystal_maiden/crystal_maiden_shoulders.vmdl",
}
UNIT_EQUIPMENT["models/heroes/crystal_maiden/crystal_maiden_arcana.vmdl"] = {
	"models/heroes/crystal_maiden/crystal_maiden_staff.vmdl",
	"models/heroes/crystal_maiden/crystal_maiden_cuffs.vmdl",
	"models/heroes/crystal_maiden/crystal_maiden_arcana_back.vmdl",
	"models/heroes/crystal_maiden/head_item.vmdl",
	"models/heroes/crystal_maiden/crystal_maiden_shoulders.vmdl",
}
UNIT_EQUIPMENT["models/heroes/shredder/shredder.vmdl"] = {
	"models/heroes/shredder/shredder_armor.vmdl",
	"models/heroes/shredder/shredder_blade.vmdl",
	"models/heroes/shredder/shredder_body.vmdl",
	"models/heroes/shredder/shredder_chainsaw.vmdl",
	"models/heroes/shredder/shredder_driver_hat.vmdl",
	"models/heroes/shredder/shredder_hook.vmdl",
	"models/heroes/shredder/shredder_shoulders.vmdl",
}
UNIT_EQUIPMENT["models/items/pudge/arcana/pudge_arcana_base.vmdl"] = {
	"models/items/pudge/blackdeath_offhand/blackdeath_offhand.vmdl",
	"models/items/pudge/blackdeath_head_s3/blackdeath_head_s3.vmdl",
	"models/items/pudge/immortal_arm/immortal_arm.vmdl",
	"models/items/pudge/scorching_talon/scorching_talon.vmdl",
	"models/items/pudge/doomsday_ripper_belt/doomsday_ripper_belt.vmdl",
	"models/items/pudge/pudge_deep_sea_abomination_arms/pudge_deep_sea_abomination_arms.vmdl",
	"models/items/pudge/arcana/pudge_arcana_back.vmdl",
}
UNIT_EQUIPMENT["models/heroes/huskar/huskar.vmdl"] = {
	"models/items/huskar/searing_dominator/searing_dominator.vmdl",
	"models/heroes/huskar/huskar_bracer.vmdl",
	"models/heroes/huskar/huskar_dagger.vmdl",
	"models/heroes/huskar/huskar_shoulder.vmdl",
	"models/heroes/huskar/huskar_spear.vmdl",
}
UNIT_EQUIPMENT["models/heroes/rubick/rubick.vmdl"] = {
	"models/items/rubick/force_staff/force_staff.vmdl",
	"models/items/rubick/kuroky_rubick_back/kuroky_rubick_back.vmdl",
	"models/items/rubick/kuroky_rubick_shoulders/kuroky_rubick_shoulders.vmdl",
	"models/items/rubick/kuroky_rubick_weapon/kuroky_rubick_weapon.vmdl",
	"models/items/rubick/rubick_kuroky_head/rubick_kuroky_head.vmdl",
}

IMBA_DISABLED_SKULL_BASHER = {
	"npc_dota_hero_faceless_void",
	"npc_dota_hero_slardar",
	"npc_dota_hero_spirit_breaker",
	"npc_dota_hero_troll_warlord",
}
