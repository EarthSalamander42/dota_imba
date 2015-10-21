-------------------------------------------------------------------------------------------------
-- IMBA: Game settings
-------------------------------------------------------------------------------------------------

IMBA_VERSION = "6.85.1c"					-- Tracks game version

-------------------------------------------------------------------------------------------------
-- Barebones basics
-------------------------------------------------------------------------------------------------

START_GAME_AUTOMATICALLY = true				-- Should the game start automatically

ENABLE_HERO_RESPAWN = true					-- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = false					-- Should the main shop contain Secret Shop items as well as regular items

HERO_SELECTION_TIME = 50.0					-- How long should we let people select their hero?
PRE_GAME_TIME = 90.0						-- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0						-- How long should we let people look at the scoreboard before closing the server automatically?
TREE_REGROW_TIME = 300.0					-- How long should it take individual trees to respawn after being cut down/destroyed?

GOLD_PER_TICK = 5							-- How much gold should players get per tick?
GOLD_TICK_TIME = 3.0						-- How long should we wait in seconds between gold ticks?

RECOMMENDED_BUILDS_DISABLED = true			-- Should we disable the recommened builds for heroes
CAMERA_DISTANCE_OVERRIDE = 1134.0			-- How far out should we allow the camera to go?  1134 is the default in Dota

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
USE_STANDARD_HERO_GOLD_BOUNTY = true		-- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?

USE_CUSTOM_TOP_BAR_VALUES = false			-- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true						-- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = true					-- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = true		-- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false			-- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false					-- Should we disable the gold sound when players get gold?

USE_CUSTOM_XP_VALUES = true					-- Should we use custom XP values to level up heroes, or the default Dota numbers?

ENABLE_FIRST_BLOOD = true					-- Should we enable first blood for the first kill in this game?
HIDE_KILL_BANNERS = false					-- Should we hide the kill banners that show when a player is killed?
LOSE_GOLD_ON_DEATH = false					-- Should we have players lose the normal amount of dota gold on death?
SHOW_ONLY_PLAYER_INVENTORY = false			-- Should we only allow players to see their own inventory even when selecting other units?
DISABLE_STASH_PURCHASING = false			-- Should we prevent players from being able to buy items into their stash when not at a shop?
DISABLE_ANNOUNCER = false					-- Should we disable the announcer from working in the game?
FORCE_PICKED_HERO = nil						-- What hero should we force all players to spawn as? (e.g. "npc_dota_hero_axe").  Use nil to allow players to pick their own hero.

FIXED_RESPAWN_TIME = -1						-- What time should we use for a fixed respawn timer?  Use -1 to keep the default dota behavior.
FOUNTAIN_CONSTANT_MANA_REGEN = -1			-- What should we use for the constant fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_MANA_REGEN = -1			-- What should we use for the percentage fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_HEALTH_REGEN = -1		-- What should we use for the percentage fountain health regen?  Use -1 to keep the default dota behavior.
MAXIMUM_ATTACK_SPEED = 600					-- What should we use for the maximum attack speed?
MINIMUM_ATTACK_SPEED = 20					-- What should we use for the minimum attack speed?

											-- NOTE: You always need at least 2 non-bounty (non-regen while broken) type runes to be able to spawn or your game will crash!
ENABLED_RUNES = {}							-- Which runes should be enabled to spawn in our game mode?
ENABLED_RUNES[DOTA_RUNE_DOUBLEDAMAGE] = true
ENABLED_RUNES[DOTA_RUNE_HASTE] = true
ENABLED_RUNES[DOTA_RUNE_ILLUSION] = true
ENABLED_RUNES[DOTA_RUNE_INVISIBILITY] = true
ENABLED_RUNES[DOTA_RUNE_REGENERATION] = true		-- Regen runes are currently not spawning as of the writing of this comment
ENABLED_RUNES[DOTA_RUNE_BOUNTY] = true

-------------------------------------------------------------------------------------------------
-- IMBA: gameplay globals
-------------------------------------------------------------------------------------------------

HERO_KILL_GOLD_BASE = 100													-- Hero gold bounty base value
HERO_KILL_GOLD_PER_LEVEL = 9												-- Hero gold bounty increase per level

HERO_KILL_GOLD_PER_KILLSTREAK = 60											-- Amount of gold awarded per killstreak
HERO_KILL_GOLD_PER_DEATHSTREAK = 50											-- Amount of gold reduced from the hero's bounty on a deathstreak

HERO_KILL_GOLD_KILLSTREAK_CAP = 1000										-- Maximum percentage of its bounty a hero can grant
HERO_KILL_GOLD_DEATHSTREAK_CAP = 50											-- Minimum percentage of its bounty a hero can grant

HERO_DEATH_GOLD_LOSS_PER_LEVEL = 30											-- Amount of gold lost on death per level

HERO_DEATH_GOLD_LOSS_PER_DEATHSTREAK = 10									-- Amount of gold prevented from being lost on death per deathstreak (in %)

KILLSTREAK_EXP_FACTOR = 1.2													-- Killstreak gold formula exponent

HERO_ASSIST_RADIUS = 1300													-- Radius around the killed hero where allies will gain assist gold and experience

HERO_ASSIST_BOUNTY_FACTOR_2 = 0.60											-- Factor to multiply the assist bounty by when 2 heroes are involved
HERO_ASSIST_BOUNTY_FACTOR_3 = 0.40											-- Factor to multiply the assist bounty by when 3 heroes are involved
HERO_ASSIST_BOUNTY_FACTOR_4 = 0.30											-- Factor to multiply the assist bounty by when 4 heroes are involved
HERO_ASSIST_BOUNTY_FACTOR_5 = 0.25											-- Factor to multiply the assist bounty by when 5 heroes are involved

HERO_GLOBAL_BOUNTY_FACTOR = 15												-- Global comeback gold awarded as a fraction of the difference between team networths (in %)

HERO_KILL_XP_CONSTANT_1 = 100												-- XP formula up to level 5 is constant I + (level - 1) * constant II
HERO_KILL_XP_CONSTANT_2 = 20												-- XP formula from level 6 and beyond is the level 5 value + (level - 5) * constant II

HERO_BUYBACK_BASE_COST = 100												-- Base cost to buyback
HERO_BUYBACK_COST_PER_LEVEL = 25											-- Level-based buyback cost
HERO_BUYBACK_COST_PER_MINUTE = 20											-- Time-based buyback cost

HERO_BUYBACK_RESET_TIME_PER_LEVEL = 4										-- Time needed for the buyback price to reset, per hero level
HERO_BUYBACK_RESET_TIME_PER_MINUTE = 2										-- Time needed for the buyback price to reset, per minute of game time (in seconds)

HERO_BUYBACK_COST_SCALING = 100												-- Cost multiplier when buybacking in quick sucession (in %)

HERO_RESPAWN_TIME_BASE = 3.75												-- Base hero respawn time
HERO_RESPAWN_TIME_PER_LEVEL = 2.25											-- Hero respawn time per level

FULL_ABANDON_TIME = 15														-- Time for a team to be considered as having abandoned the game (in seconds)

TOWER_MINIMUM_GOLD = 180													-- Tower minimum gold bounty
TOWER_MAXIMUM_GOLD = 220													-- Tower maximum gold bounty
TOWER_EXPERIENCE = 400														-- Tower experience bounty

MELEE_RAX_MINIMUM_GOLD = 180												-- Melee barracks minimum gold bounty
MELEE_RAX_MAXIMUM_GOLD = 200												-- Melee barracks maximum gold bounty
MELEE_RAX_EXPERIENCE = 400													-- Melee barracks experience bounty

RANGED_RAX_MINIMUM_GOLD = 100												-- Ranged barracks minimum gold bounty
RANGED_RAX_MAXIMUM_GOLD = 120												-- Ranged barracks maximum gold bounty
RANGED_RAX_EXPERIENCE = 200													-- Ranged barracks experience bounty

ROSHAN_RESPAWN_TIME = 480													-- Roshan respawn timer (in seconds)
AEGIS_DURATION = 420														-- Aegis expiration timer (in seconds)

GAME_TIME_ELAPSED = 0														-- Initializes game time tracker

VENGEFUL_RANCOR = false														-- Tracks if Vengeful Spirit's "Rancor" ability is in the game

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
PLAYER_COLORS[0] = { 64, 128, 208 }
PLAYER_COLORS[1]  = { 88, 224, 160 }
PLAYER_COLORS[2] = { 160, 0, 160 }
PLAYER_COLORS[3] = { 208, 208, 8 }
PLAYER_COLORS[4] = { 224, 96, 0 }
PLAYER_COLORS[5] = { 0, 252, 64 }
PLAYER_COLORS[6] = { 56, 0, 116 }
PLAYER_COLORS[7] = { 252, 0, 128 }
PLAYER_COLORS[8] = { 244, 124, 0 }
PLAYER_COLORS[9] = { 120, 120, 0 }
PLAYER_COLORS[10] = { 220, 116, 168 }
PLAYER_COLORS[11]  = { 116, 128, 48 }
PLAYER_COLORS[12] = { 88, 188, 228 }
PLAYER_COLORS[13] = { 0, 112, 28 }
PLAYER_COLORS[14] = { 136, 84, 0 }
PLAYER_COLORS[15] = { 244, 124, 244 }
PLAYER_COLORS[16] = { 240, 0, 0 }
PLAYER_COLORS[17] = { 248, 128, 0 }
PLAYER_COLORS[18] = { 224, 184, 24 }
PLAYER_COLORS[19] = { 160, 255, 96 }

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
elseif GetMapName() == "imba_random_omg" then
	IMBA_ABILITY_MODE_RANDOM_OMG = true
elseif GetMapName() == "imba_custom" then
	IMBA_PICK_MODE_ALL_PICK = true
elseif GetMapName() == "imba_10v10" then
	IMBA_PICK_MODE_ALL_PICK = true
	IMBA_PLAYERS_ON_GAME = 20
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 10
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 10
end

-------------------------------------------------------------------------------------------------
-- IMBA: game mode globals
-------------------------------------------------------------------------------------------------

GAME_WINNER_TEAM = 0														-- Tracks game winner
GAME_ROSHAN_KILLS = 0														-- Tracks amount of Roshan kills

END_GAME_ON_KILLS = false													-- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 20												-- How many kills for a team should signify the end of the game?
			
ALLOW_SAME_HERO_SELECTION = false											-- Allows people to select the same hero as each other if true

IMBA_PICK_MODE_ALL_RANDOM = false											-- Activates All Random mode when true
IMBA_ALL_RANDOM_HERO_SELECTION_TIME = 10.0									-- Time we need to wait before the game starts when all heroes are randomed

IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT = 3									-- Number of regular abilities in Random OMG mode
IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT = 1									-- Number of ultimate abilities in Random OMG mode
IMBA_RANDOM_OMG_RANDOMIZE_SKILLS_ON_DEATH = true							-- Randomizes skills every time you die in Random OMG

CREEP_GOLD_BONUS = 30														-- Amount of bonus gold granted by creeps and passive gold (in %)
HERO_GOLD_BONUS = 30														-- Amount of bonus gold granted by heroes (in %)

CREEP_XP_BONUS = 30															-- Amount of bonus XP granted by creeps (in %)
HERO_XP_BONUS = 30															-- Amount of bonus XP granted by heroes (in %)

CREEP_POWER_RAMP_UP_FACTOR = 1												-- Creep power increase multiplier factor
CREEP_POWER_MAX_UPGRADES = 30												-- Maximum amount of creep/structure upgrades
CREEP_BOUNTY_RAMP_UP_PER_MINUTE = 4											-- Creep bounty increase (in %) based on game time

TOWER_ABILITY_MODE = true													-- Should towers gain random unique abilities?
TOWER_UPGRADE_MODE = false													-- Should tower abilities be upgradeable?

FRANTIC_MULTIPLIER = 1														-- Mana cost/cooldown decrease multiplier

HERO_BUYBACK_COST_MULTIPLIER = 100											-- User-defined buyback cost multiplier

HERO_RESPAWN_TIME_MULTIPLIER = 100											-- User-defined respawn time multiplier

HERO_INITIAL_GOLD = 625														-- Gold granted to players at the start of the game on a normal pick
HERO_INITIAL_REPICK_GOLD = 525												-- Gold granted to players at the start of the game on repicking their hero
HERO_INITIAL_RANDOM_GOLD = 825												-- Gold granted to players at the start of the game on randoming their hero

HERO_STARTING_LEVEL = 1														-- User-defined starting level

if GetMapName() == "imba_10v10" then										-- 10v10 defaults
	HERO_INITIAL_GOLD = 2000
	HERO_INITIAL_REPICK_GOLD = 1500
	HERO_INITIAL_RANDOM_GOLD = 2500
	HERO_STARTING_LEVEL = 5
	HERO_XP_BONUS = 60
	CREEP_XP_BONUS = 60
end

USE_CUSTOM_HERO_LEVELS = true												-- Should we allow heroes to have custom levels?
MAX_LEVEL = 35																-- What level should we let heroes get to?

-- XP per level table (only active if custom hero levels are enabled) 
XP_PER_LEVEL_TABLE = {}

XP_PER_LEVEL_TABLE[1] = 0

for i = 2, 5 do
	XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i-1] + i * 100
end

XP_PER_LEVEL_TABLE[6] = 2000
XP_PER_LEVEL_TABLE[7] = 2600
XP_PER_LEVEL_TABLE[8] = 3200
XP_PER_LEVEL_TABLE[9] = 4400
XP_PER_LEVEL_TABLE[10] = 5400
XP_PER_LEVEL_TABLE[11] = 6000
XP_PER_LEVEL_TABLE[12] = 8200
XP_PER_LEVEL_TABLE[13] = 9000

for i = 14, 100 do
	XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i-1] + i * 100
end

-------------------------------------------------------------------------------------------------
-- IMBA: Keyvalue tables
-------------------------------------------------------------------------------------------------

TOWER_ABILITIES = LoadKeyValues("scripts/npc/KV/tower_abilities.kv")
RANDOM_OMG_ABILITIES = LoadKeyValues("scripts/npc/KV/random_omg_abilities.kv")
RANDOM_OMG_ULTIMATES = LoadKeyValues("scripts/npc/KV/random_omg_ultimates.kv")