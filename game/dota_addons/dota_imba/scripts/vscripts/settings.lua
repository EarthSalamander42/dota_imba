-------------------------------------------------------------------------------------------------
-- IMBA: Game settings
-------------------------------------------------------------------------------------------------

IMBA_VERSION = "7.01"						-- Tracks game version

-------------------------------------------------------------------------------------------------
-- Barebones basics
-------------------------------------------------------------------------------------------------

START_GAME_AUTOMATICALLY = true				-- Should the game start automatically

ENABLE_HERO_RESPAWN = true					-- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = false					-- Should the main shop contain Secret Shop items as well as regular items

HERO_SELECTION_TIME = 45.0 + 10.0		-- How long should we let people select their hero?
if IsInToolsMode() then HERO_SELECTION_TIME = 5.0 end

PRE_GAME_TIME = 90.0 + HERO_SELECTION_TIME + 10.0	-- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0						-- How long should we let people look at the scoreboard before closing the server automatically?
AUTO_LAUNCH_DELAY = 15.0					-- How long should we wait for the host to setup the game, after all players have loaded in?
TREE_REGROW_TIME = 180.0					-- How long should it take individual trees to respawn after being cut down/destroyed?
SHOWCASE_TIME = 0.0							-- How long should showcase time last?
STRATEGY_TIME = 0.0							-- How long should strategy time last?

GOLD_PER_TICK = 1							-- How much gold should players get per tick?
GOLD_TICK_TIME = 0.6						-- How long should we wait in seconds between gold ticks?

RECOMMENDED_BUILDS_DISABLED = true			-- Should we disable the recommened builds for heroes
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
DOTA_MAX_PLAYERS = 20						-- Maximum amount of players allowed in a game

-------------------------------------------------------------------------------------------------
-- IMBA: gameplay globals
-------------------------------------------------------------------------------------------------

BUYBACK_COOLDOWN_ENABLED = true												-- Is the buyback cooldown enabled?

BUYBACK_BASE_COST = 100														-- Base cost to buyback
BUYBACK_COST_PER_LEVEL = 1.5												-- Level-based buyback cost
BUYBACK_COST_PER_LEVEL_AFTER_25 = 35										-- Level-based buyback cost growth after level 25
BUYBACK_COST_PER_SECOND = 0.25												-- Time-based buyback cost

BUYBACK_COOLDOWN_START_POINT = 600											-- Game time (in seconds) after which buyback cooldown is activated
BUYBACK_COOLDOWN_GROW_FACTOR = 0.167										-- Buyback cooldown increase per second
BUYBACK_COOLDOWN_MAXIMUM = 360												-- Maximum buyback cooldown

ABANDON_TIME = 180															-- Time for a player to be considered as having abandoned the game (in seconds)
FULL_ABANDON_TIME = 15														-- Time for a team to be considered as having abandoned the game (in seconds)

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

HERO_RESPAWN_TIME_PER_LEVEL = {}											-- Hero respawn time per level
HERO_RESPAWN_TIME_PER_LEVEL[1] = 6
HERO_RESPAWN_TIME_PER_LEVEL[2] = 8
HERO_RESPAWN_TIME_PER_LEVEL[3] = 10
HERO_RESPAWN_TIME_PER_LEVEL[4] = 12
HERO_RESPAWN_TIME_PER_LEVEL[5] = 14
HERO_RESPAWN_TIME_PER_LEVEL[6] = 18
HERO_RESPAWN_TIME_PER_LEVEL[7] = 20
HERO_RESPAWN_TIME_PER_LEVEL[8] = 22
HERO_RESPAWN_TIME_PER_LEVEL[9] = 24
HERO_RESPAWN_TIME_PER_LEVEL[10] = 26
HERO_RESPAWN_TIME_PER_LEVEL[11] = 28
HERO_RESPAWN_TIME_PER_LEVEL[12] = 32
HERO_RESPAWN_TIME_PER_LEVEL[13] = 34
HERO_RESPAWN_TIME_PER_LEVEL[14] = 36
HERO_RESPAWN_TIME_PER_LEVEL[15] = 38
HERO_RESPAWN_TIME_PER_LEVEL[16] = 40
HERO_RESPAWN_TIME_PER_LEVEL[17] = 42
HERO_RESPAWN_TIME_PER_LEVEL[18] = 46
HERO_RESPAWN_TIME_PER_LEVEL[19] = 48
HERO_RESPAWN_TIME_PER_LEVEL[20] = 50
HERO_RESPAWN_TIME_PER_LEVEL[21] = 52
HERO_RESPAWN_TIME_PER_LEVEL[22] = 54
HERO_RESPAWN_TIME_PER_LEVEL[23] = 56
HERO_RESPAWN_TIME_PER_LEVEL[24] = 58
HERO_RESPAWN_TIME_PER_LEVEL[25] = 60

-------------------------------------------------------------------------------------------------
-- IMBA: map-based settings
-------------------------------------------------------------------------------------------------

MAX_NUMBER_OF_TEAMS = 2														-- How many potential teams can be in this game mode?
IMBA_PLAYERS_ON_GAME = 10													-- Number of players in the game
USE_CUSTOM_TEAM_COLORS = false												-- Should we use custom team colors?
USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS = false									-- Should we use custom team colors to color the players/minimap?

TEAM_COLORS = {}															-- If USE_CUSTOM_TEAM_COLORS is set, use these colors.
TEAM_COLORS[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }							-- Teal
TEAM_COLORS[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }							-- Yellow
TEAM_COLORS[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }							-- Pink
TEAM_COLORS[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }							-- Orange
TEAM_COLORS[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }							-- Blue
TEAM_COLORS[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }							-- Green
TEAM_COLORS[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }							-- Brown
TEAM_COLORS[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }							-- Cyan
TEAM_COLORS[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }							-- Olive
TEAM_COLORS[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }							-- Purple

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
PLAYER_COLORS[9] = { 1, 1, 1 }
PLAYER_COLORS[10] = { 255, 0, 255 }
PLAYER_COLORS[11]  = { 128, 128, 0 }
PLAYER_COLORS[12] = { 100, 255, 255 }
PLAYER_COLORS[13] = { 0, 190, 0 }
PLAYER_COLORS[14] = { 170, 110, 40 }
PLAYER_COLORS[15] = { 0, 0, 128 }
PLAYER_COLORS[16] = { 230, 190, 255 }
PLAYER_COLORS[17] = { 128, 0, 0 }
PLAYER_COLORS[18] = { 128, 128, 128 }
PLAYER_COLORS[19] = { 254, 254, 254 }

USE_AUTOMATIC_PLAYERS_PER_TEAM = false										-- Should we set the number of players to 10 / MAX_NUMBER_OF_TEAMS?

CUSTOM_TEAM_PLAYER_COUNT = {}
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 5
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 5
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_1] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_2] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_3] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_4] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_5] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_6] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_7] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_8] = 0

if GetMapName() == "imba_standard" then
	IMBA_PICK_MODE_ALL_PICK = true
elseif GetMapName() == "imba_custom" then
	IMBA_PICK_MODE_ALL_PICK = true
elseif GetMapName() == "imba_custom_10v10" then
	IMBA_PICK_MODE_ALL_PICK = true
	IMBA_PLAYERS_ON_GAME = 20
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 10
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 10
elseif GetMapName() == "imba_10v10" then
	IMBA_PICK_MODE_ALL_PICK = true
	IMBA_PLAYERS_ON_GAME = 20
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 10
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 10
elseif GetMapName() == "imba_arena" then
	IMBA_PICK_MODE_ALL_PICK = true
	IMBA_PLAYERS_ON_GAME = 12
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 6
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 6
end

-- NOTE: You always need at least 2 non-bounty type runes to be able to spawn or your game will crash!
ENABLED_RUNES = {}                      -- Which runes should be enabled to spawn in our game mode?
ENABLED_RUNES[DOTA_RUNE_DOUBLEDAMAGE] = true
ENABLED_RUNES[DOTA_RUNE_HASTE] = true
ENABLED_RUNES[DOTA_RUNE_ILLUSION] = true
ENABLED_RUNES[DOTA_RUNE_INVISIBILITY] = true
ENABLED_RUNES[DOTA_RUNE_REGENERATION] = true
ENABLED_RUNES[DOTA_RUNE_BOUNTY] = true
ENABLED_RUNES[DOTA_RUNE_ARCANE] = true
--	ENABLED_RUNES[DOTA_RUNE_HAUNTED] = true
--	ENABLED_RUNES[DOTA_RUNE_MYSTERY] = true
--	ENABLED_RUNES[DOTA_RUNE_RAPIER] = true
--	ENABLED_RUNES[DOTA_RUNE_SPOOKY] = true
--	ENABLED_RUNES[DOTA_RUNE_TURBO] = true

-------------------------------------------------------------------------------------------------
-- IMBA: game mode globals
-------------------------------------------------------------------------------------------------

GAME_WINNER_TEAM = "none"													-- Tracks game winner
GAME_ROSHAN_KILLS = 0														-- Tracks amount of Roshan kills

END_GAME_ON_KILLS = false													-- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 70												-- How many kills for a team should signify the end of the game?

IMBA_HYPER_MODE_ON = false													-- Is Hyper mode activated?
IMBA_FRANTIC_MODE_ON = false												-- Is Frantic mode activated?
IMBA_HERO_PICK_RULE = 0                                                     -- 0 : All Unique Heroes, 1 : Allow teams to pick same hero, 2 : Allow all to pick same hero

IMBA_PICK_MODE_ALL_PICK = false												-- Activates All Pick mode when true
IMBA_PICK_MODE_ALL_RANDOM = false											-- Activates All Random mode when true
IMBA_PICK_MODE_ALL_RANDOM_SAME_HERO = false									-- Activates All Random Same Hero mode when true
IMBA_ALL_RANDOM_HERO_SELECTION_TIME = 5.0									-- Time we need to wait before the game starts when all heroes are randomed

CUSTOM_GOLD_BONUS = 0														-- Amount of bonus gold gained (in %)
CUSTOM_XP_BONUS = 0														-- Amount of bonus XP gained (in %)

BOUNTY_RAMP_PER_SECOND = 0.04												-- Bounty increase (in %) based on game time
CREEP_POWER_FACTOR = 1														-- Creep power increase multiplier factor
CREEP_POWER_MAX_UPGRADES = 30												-- Maximum amount of creep/structure upgrades

REMAINING_GOODGUYS = 0														-- Remaining players on Radiant
REMAINING_BADGUYS = 0														-- Remaining players on Dire

ANCIENT_ABILITIES_LIST = {}													-- Initializes the ancients' abilities list
SPAWN_ANCIENT_BEHEMOTHS = true												-- Should the ancients spawn behemoths?
TOWER_ABILITY_MODE = true													-- Should towers gain random unique abilities?
TOWER_UPGRADE_MODE = false													-- Should tower abilities be upgradeable?
TOWER_POWER_FACTOR = 0														-- Tower durability/damage increase factor (0 = default)
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

HERO_RESPAWN_TIME_MULTIPLIER = 100											-- User-defined respawn time multiplier

MAP_INITIAL_GOLD = 0														-- Gold granted to players at the start of the game on a normal pick
HERO_INITIAL_GOLD = 625														-- Gold to add to players as soon as they spawn into the game
HERO_REPICK_GOLD = 525														-- Gold lost by players who repick their hero
HERO_RANDOM_GOLD = 825														-- Gold granted to players who random their hero
HERO_RERANDOM_GOLD = 725

HERO_STARTING_LEVEL = 1														-- User-defined starting level

USE_CUSTOM_HERO_LEVELS = true												-- Should we allow heroes to have custom levels?
MAX_LEVEL = 40																-- What level should we let heroes get to?

CHEAT_ENABLED = false

-- Changes settings according to the current map
if GetMapName() == "imba_standard" then										-- Standard map defaults
	END_GAME_ON_KILLS = false
	CUSTOM_GOLD_BONUS = 35
	CUSTOM_XP_BONUS = 35
	CREEP_POWER_FACTOR = 1
	TOWER_UPGRADE_MODE = false
	TOWER_POWER_FACTOR = 1
	HERO_RESPAWN_TIME_MULTIPLIER = 100
	HERO_INITIAL_GOLD = 1200
	HERO_REPICK_GOLD = 1100
	HERO_RANDOM_GOLD = 1400
	HERO_RERANDOM_GOLD = 1300
	HERO_STARTING_LEVEL = 3
	MAX_LEVEL = 40
elseif GetMapName() == "imba_custom" or GetMapName() == "imba_custom_10v10" then									-- Custom map defaults
	END_GAME_ON_KILLS = false
	CUSTOM_GOLD_BONUS = 200
	CUSTOM_XP_BONUS = 200
	CREEP_POWER_FACTOR = 2
	TOWER_UPGRADE_MODE = true
	TOWER_POWER_FACTOR = 1
	HERO_RESPAWN_TIME_MULTIPLIER = 75
	HERO_INITIAL_GOLD = 2000
	HERO_REPICK_GOLD = 1600
	HERO_RANDOM_GOLD = 2400
	HERO_RERANDOM_GOLD = 2200
	HERO_STARTING_LEVEL = 5
	MAX_LEVEL = 40
elseif GetMapName() == "imba_10v10" then									-- 10v10 map defaults
	END_GAME_ON_KILLS = false
	CUSTOM_GOLD_BONUS = 35
	CUSTOM_XP_BONUS = 35
	CREEP_POWER_FACTOR = 1
	TOWER_UPGRADE_MODE = true
	TOWER_POWER_FACTOR = 1
	HERO_RESPAWN_TIME_MULTIPLIER = 75
	HERO_INITIAL_GOLD = 2000
	HERO_REPICK_GOLD = 1600
	HERO_RANDOM_GOLD = 2400
	HERO_RERANDOM_GOLD = 2200
	HERO_STARTING_LEVEL = 5
	MAX_LEVEL = 40
elseif GetMapName() == "imba_arena" then									-- Arena map defaults
	END_GAME_ON_KILLS = true
	TOWER_ABILITY_MODE = false
	TOWER_UPGRADE_MODE = false
	SPAWN_ANCIENT_BEHEMOTHS = false
	GOLD_PER_TICK = 0
	UNIVERSAL_SHOP_MODE = true
	USE_CUSTOM_TOP_BAR_VALUES = true
	TREE_REGROW_TIME = 60.0
	CUSTOM_GOLD_BONUS = 100
	CUSTOM_XP_BONUS = 100
	TOWER_POWER_FACTOR = 2
	HERO_RESPAWN_TIME_MULTIPLIER = 40
	HERO_INITIAL_GOLD = 1000
	HERO_REPICK_GOLD = 750
	HERO_RANDOM_GOLD = 1250
	HERO_RERANDOM_GOLD = 1125
	HERO_STARTING_LEVEL = 3
	MAX_LEVEL = 40
	RUNE_SPAWN_TIME = 15
	FOUNTAIN_PERCENTAGE_MANA_REGEN = 15
	FOUNTAIN_PERCENTAGE_HEALTH_REGEN = 15
	PRE_GAME_TIME = 15.0 + HERO_SELECTION_TIME + 10.0
end

-- Update game mode net tables
CustomNetTables:SetTableValue("game_options", "all_pick", {IMBA_PICK_MODE_ALL_PICK})
CustomNetTables:SetTableValue("game_options", "all_random", {IMBA_PICK_MODE_ALL_RANDOM})
CustomNetTables:SetTableValue("game_options", "all_random_same_hero", {IMBA_PICK_MODE_ALL_RANDOM_SAME_HERO})
CustomNetTables:SetTableValue("game_options", "tower_upgrades", {TOWER_UPGRADE_MODE})
CustomNetTables:SetTableValue("game_options", "kills_to_end", {KILLS_TO_END_GAME_FOR_TEAM})
CustomNetTables:SetTableValue("game_options", "bounty_multiplier", {100 + CUSTOM_GOLD_BONUS})
CustomNetTables:SetTableValue("game_options", "exp_multiplier", {100 + CUSTOM_XP_BONUS})
CustomNetTables:SetTableValue("game_options", "creep_power", {CREEP_POWER_FACTOR})
CustomNetTables:SetTableValue("game_options", "tower_power", {TOWER_POWER_FACTOR})
CustomNetTables:SetTableValue("game_options", "respawn_multiplier", {100 - HERO_RESPAWN_TIME_MULTIPLIER})
CustomNetTables:SetTableValue("game_options", "initial_gold", {HERO_INITIAL_GOLD})
CustomNetTables:SetTableValue("game_options", "initial_level", {HERO_STARTING_LEVEL})
CustomNetTables:SetTableValue("game_options", "max_level", {MAX_LEVEL})
CustomNetTables:SetTableValue("game_options", "hero_pick_rule", {IMBA_HERO_PICK_RULE})

-- XP per level table (only active if custom hero levels are enabled) 
XP_PER_LEVEL_TABLE = {}

-- Vanilla
XP_PER_LEVEL_TABLE[1] = 0			-- +0
XP_PER_LEVEL_TABLE[2] = 240			-- +240
XP_PER_LEVEL_TABLE[3] = 600			-- +360
XP_PER_LEVEL_TABLE[4] = 1080		-- +480
XP_PER_LEVEL_TABLE[5] = 1680		-- +600
XP_PER_LEVEL_TABLE[6] = 2300		-- +620
XP_PER_LEVEL_TABLE[7] = 2940		-- +640
XP_PER_LEVEL_TABLE[8] = 3600		-- +660
XP_PER_LEVEL_TABLE[9] = 4280		-- +680
XP_PER_LEVEL_TABLE[10] = 5080		-- +800
XP_PER_LEVEL_TABLE[11] = 5900		-- +820
XP_PER_LEVEL_TABLE[12] = 6740		-- +840
XP_PER_LEVEL_TABLE[13] = 7640		-- +900
XP_PER_LEVEL_TABLE[14] = 8865		-- +1225
XP_PER_LEVEL_TABLE[15] = 10115		-- +1250
XP_PER_LEVEL_TABLE[16] = 11390		-- +1275
XP_PER_LEVEL_TABLE[17] = 12690		-- +1300
XP_PER_LEVEL_TABLE[18] = 14015		-- +1325
XP_PER_LEVEL_TABLE[19] = 15415		-- +1400
XP_PER_LEVEL_TABLE[20] = 16905		-- +1490
XP_PER_LEVEL_TABLE[21] = 18405		-- +1500
XP_PER_LEVEL_TABLE[22] = 20155		-- +1750
XP_PER_LEVEL_TABLE[23] = 20155		-- +2000
XP_PER_LEVEL_TABLE[24] = 24405		-- +2250
XP_PER_LEVEL_TABLE[25] = 26905		-- +2500
XP_PER_LEVEL_TABLE[26] = 29405		-- +2500
XP_PER_LEVEL_TABLE[27] = 31905		-- +2500
XP_PER_LEVEL_TABLE[28] = 34405		-- +2500
XP_PER_LEVEL_TABLE[29] = 36905		-- +2500
XP_PER_LEVEL_TABLE[30] = 39405		-- +2500
XP_PER_LEVEL_TABLE[31] = 42405		-- +3000
XP_PER_LEVEL_TABLE[32] = 45405		-- +3000
XP_PER_LEVEL_TABLE[33] = 48405		-- +3000
XP_PER_LEVEL_TABLE[34] = 51405		-- +3000
XP_PER_LEVEL_TABLE[35] = 54405		-- +3000
XP_PER_LEVEL_TABLE[36] = 57905		-- +3500
XP_PER_LEVEL_TABLE[37] = 61405		-- +3500
XP_PER_LEVEL_TABLE[38] = 64905		-- +3500
XP_PER_LEVEL_TABLE[39] = 68405		-- +3500
XP_PER_LEVEL_TABLE[40] = 71905		-- +3500

--[[
XP_PER_LEVEL_TABLE[1] = 0			-- +0
XP_PER_LEVEL_TABLE[2] = 120			-- +120
XP_PER_LEVEL_TABLE[3] = 270			-- +150
XP_PER_LEVEL_TABLE[4] = 450			-- +180
XP_PER_LEVEL_TABLE[5] = 690			-- +240
XP_PER_LEVEL_TABLE[6] = 990			-- +300
XP_PER_LEVEL_TABLE[7] = 1350		-- +360
XP_PER_LEVEL_TABLE[8] = 1790		-- +440
XP_PER_LEVEL_TABLE[9] = 2310		-- +520
XP_PER_LEVEL_TABLE[10] = 2910		-- +600
XP_PER_LEVEL_TABLE[11] = 3590		-- +680
XP_PER_LEVEL_TABLE[12] = 4350		-- +760
XP_PER_LEVEL_TABLE[13] = 5190		-- +840
XP_PER_LEVEL_TABLE[14] = 6110		-- +920
XP_PER_LEVEL_TABLE[15] = 7110		-- +1000
XP_PER_LEVEL_TABLE[16] = 8190		-- +1080
XP_PER_LEVEL_TABLE[17] = 9350		-- +1160
XP_PER_LEVEL_TABLE[18] = 10590		-- +1240
XP_PER_LEVEL_TABLE[19] = 11910		-- +1320
XP_PER_LEVEL_TABLE[20] = 13310		-- +1420
XP_PER_LEVEL_TABLE[21] = 14810		-- +1500
XP_PER_LEVEL_TABLE[22] = 16410		-- +1600
XP_PER_LEVEL_TABLE[23] = 18110		-- +1700
XP_PER_LEVEL_TABLE[24] = 19910		-- +1800
XP_PER_LEVEL_TABLE[25] = 21810		-- +1900
XP_PER_LEVEL_TABLE[26] = 23810		-- +2000
XP_PER_LEVEL_TABLE[27] = 25910		-- +2100
XP_PER_LEVEL_TABLE[28] = 28110		-- +2200
XP_PER_LEVEL_TABLE[29] = 30410		-- +2300
XP_PER_LEVEL_TABLE[30] = 32810		-- +2400
XP_PER_LEVEL_TABLE[31] = 35310		-- +2500
XP_PER_LEVEL_TABLE[32] = 38010		-- +2700
XP_PER_LEVEL_TABLE[33] = 40910		-- +2900
XP_PER_LEVEL_TABLE[34] = 44010		-- +3100
XP_PER_LEVEL_TABLE[35] = 47310		-- +3300
XP_PER_LEVEL_TABLE[36] = 50810		-- +3500
XP_PER_LEVEL_TABLE[37] = 54610		-- +3800
XP_PER_LEVEL_TABLE[38] = 58710		-- +4100
XP_PER_LEVEL_TABLE[39] = 63110		-- +4400
XP_PER_LEVEL_TABLE[40] = 67810		-- +4700
]]

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

HERO_ABILITY_LIST = LoadKeyValues("scripts/npc//KV/nonhidden_ability_list.kv")
TOWER_ABILITIES = LoadKeyValues("scripts/npc/KV/tower_abilities.kv")
PURGE_BUFF_LIST = LoadKeyValues("scripts/npc/KV/purge_buffs_list.kv")
IMBA_GENERIC_TALENT_LIST = LoadKeyValues("scripts/npc/KV/imba_generic_talent_list.kv")
IMBA_HERO_TALENTS_LIST = LoadKeyValues("scripts/npc/KV/imba_hero_talents_list.kv")
DISPELLABLE_DEBUFF_LIST = LoadKeyValues("scripts/npc/KV/dispellable_debuffs_list.kv")

IMBA_DEVS = {
	54896080,	-- Cookies
	46875732,	-- Firetoad
	34067920,	-- Shush
	95496383,	-- ZimberZimber
	137997646,	-- Fudge
	142818979,	-- Luxcerv
	65988826,	-- Noobsauce
	137344217,	-- Moujiaozi
	65419767,	-- AtroCty
	33828741	-- sercankd
}

-- HEROLIST
normal_heroes = {
	"npc_dota_hero_abaddon",
	"npc_dota_hero_alchemist",
	"npc_dota_hero_antimage",
	"npc_dota_hero_axe",
	"npc_dota_hero_bane",
	"npc_dota_hero_bloodseeker",
	"npc_dota_hero_crystal_maiden",
	"npc_dota_hero_dazzle",
	"npc_dota_hero_drow_ranger",
--	"npc_dota_hero_enigma",
	"npc_dota_hero_faceless_void",
	"npc_dota_hero_juggernaut",
	"npc_dota_hero_kunkka",
	"npc_dota_hero_lich",
	"npc_dota_hero_lina",
	"npc_dota_hero_lion",
	"npc_dota_hero_meepo",
	"npc_dota_hero_mirana",
	"npc_dota_hero_necrolyte",
	"npc_dota_hero_nevermore",
	"npc_dota_hero_night_stalker",
	"npc_dota_hero_omniknight",
	"npc_dota_hero_pudge",
	"npc_dota_hero_pugna",
	"npc_dota_hero_riki",
	"npc_dota_hero_sand_king",
	"npc_dota_hero_slardar",
	"npc_dota_hero_sniper",
	"npc_dota_hero_spectre",
	"npc_dota_hero_sven",
	--"npc_dota_hero_tinker",
	"npc_dota_hero_tiny",
	"npc_dota_hero_vengefulspirit",
--	"npc_dota_hero_venomancer",
	"npc_dota_hero_witch_doctor",
	"npc_dota_hero_skeleton_king",
	"npc_dota_hero_queenofpain",
	"npc_dota_hero_jakiro",
	"npc_dota_hero_warlock",
	"npc_dota_hero_ursa",
	"npc_dota_hero_bounty_hunter",
	"npc_dota_hero_silencer",
	"npc_dota_hero_clinkz",
	"npc_dota_hero_obsidian_destroyer",
	"npc_dota_hero_phantom_assassin",
	"npc_dota_hero_disruptor",
	"npc_dota_hero_nyx_assassin",
--	"npc_dota_hero_magnataur",
	"npc_dota_hero_centaur",
	"npc_dota_hero_troll_warlord",
	"npc_dota_hero_skywrath_mage",
--	"npc_dota_hero_techies",
	"npc_dota_hero_ancient_apparition",
	"npc_dota_hero_beastmaster",
	"npc_dota_hero_chen",
	"npc_dota_hero_dark_seer",
	"npc_dota_hero_dragon_knight",
	"npc_dota_hero_doom_bringer",
	"npc_dota_hero_earthshaker",
	"npc_dota_hero_enchantress",
--	"npc_dota_hero_furion",
	"npc_dota_hero_leshrac",
	"npc_dota_hero_life_stealer",
	"npc_dota_hero_morphling",
	"npc_dota_hero_puck",
	"npc_dota_hero_rattletrap",
	"npc_dota_hero_razor",
	"npc_dota_hero_storm_spirit",
	"npc_dota_hero_tidehunter",
	"npc_dota_hero_viper",
	"npc_dota_hero_weaver",
	"npc_dota_hero_windrunner",
	"npc_dota_hero_broodmother",
	"npc_dota_hero_huskar",
	"npc_dota_hero_batrider",
	"npc_dota_hero_death_prophet",
	"npc_dota_hero_spirit_breaker",
	"npc_dota_hero_invoker",
	"npc_dota_hero_shadow_demon",
	--"npc_dota_hero_phantom_lancer",
	"npc_dota_hero_treant",
	"npc_dota_hero_ogre_magi",
	"npc_dota_hero_chaos_knight",
	"npc_dota_hero_gyrocopter",
	"npc_dota_hero_rubick",
	"npc_dota_hero_luna",
	"npc_dota_hero_wisp",
--	"npc_dota_hero_undying",
	"npc_dota_hero_templar_assassin",
	"npc_dota_hero_naga_siren",
	"npc_dota_hero_keeper_of_the_light",
	"npc_dota_hero_visage",
	"npc_dota_hero_slark",
	"npc_dota_hero_shredder",
	"npc_dota_hero_medusa",
	"npc_dota_hero_tusk",
	"npc_dota_hero_bristleback",
	"npc_dota_hero_elder_titan",
	"npc_dota_hero_abaddon",
	"npc_dota_hero_earth_spirit",
	"npc_dota_hero_ember_spirit",
	"npc_dota_hero_legion_commander",
	"npc_dota_hero_phoenix",
	"npc_dota_hero_terrorblade",
	"npc_dota_hero_oracle",
	"npc_dota_hero_winter_wyvern",
	"npc_dota_hero_arc_warden",
	"npc_dota_hero_abyssal_underlord",
--	"npc_dota_hero_zuus",
	"npc_dota_hero_monkey_king"
}

-- IMBA HEROLIST
imba_heroes = {
	"npc_dota_hero_abaddon",
	"npc_dota_hero_alchemist",
	"npc_dota_hero_antimage",
	"npc_dota_hero_axe",
	"npc_dota_hero_bane",
	"npc_dota_hero_bloodseeker",
	"npc_dota_hero_crystal_maiden",
	"npc_dota_hero_dazzle",
	"npc_dota_hero_drow_ranger",
--	"npc_dota_hero_enigma",
	"npc_dota_hero_faceless_void",
	"npc_dota_hero_juggernaut",
	"npc_dota_hero_kunkka",
	"npc_dota_hero_lich",
	"npc_dota_hero_lina",
	"npc_dota_hero_lion",
	"npc_dota_hero_mirana",
	"npc_dota_hero_necrolyte",
	"npc_dota_hero_nevermore",
	"npc_dota_hero_night_stalker",
	"npc_dota_hero_omniknight",
	"npc_dota_hero_pudge",
	"npc_dota_hero_pugna",
	"npc_dota_hero_riki",
	"npc_dota_hero_sand_king",
	"npc_dota_hero_skeleton_king",
	"npc_dota_hero_slardar",
	"npc_dota_hero_sniper",
	"npc_dota_hero_sven",
--	"npc_dota_hero_techies",
--	"npc_dota_hero_tinker",
	"npc_dota_hero_tiny",
	"npc_dota_hero_vengefulspirit",
--	"npc_dota_hero_venomancer",
	"npc_dota_hero_witch_doctor",
	"npc_dota_hero_queenofpain",
	"npc_dota_hero_jakiro",
	"npc_dota_hero_warlock",
	"npc_dota_hero_ursa",
	"npc_dota_hero_bounty_hunter",
	"npc_dota_hero_silencer",
	"npc_dota_hero_clinkz",
	"npc_dota_hero_obsidian_destroyer",
	"npc_dota_hero_phantom_assassin",
	"npc_dota_hero_disruptor",
	"npc_dota_hero_nyx_assassin",
--	"npc_dota_hero_magnataur",
	"npc_dota_hero_centaur",
	"npc_dota_hero_skywrath_mage",
	"npc_dota_hero_troll_warlord"
}
