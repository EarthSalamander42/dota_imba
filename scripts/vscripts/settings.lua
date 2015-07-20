-------------------------------------------------------------------------------------------------
-- IMBA: Game settings
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- Barebones basics
-------------------------------------------------------------------------------------------------

ENABLE_HERO_RESPAWN = true					-- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = false					-- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = false			-- Should we let people select the same hero as each other

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

END_GAME_ON_KILLS = false					-- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 5				-- How many kills for a team should signify an end of game?

USE_CUSTOM_HERO_LEVELS = false				-- Should we allow heroes to have custom levels?
MAX_LEVEL = 25								-- What level should we let heroes get to?
USE_CUSTOM_XP_VALUES = false				-- Should we use custom XP values to level up heroes, or the default Dota numbers?

-- Fill this table up with the required XP per level if you want to change it
--XP_PER_LEVEL_TABLE = {}

--for i=1,MAX_LEVEL do
--	XP_PER_LEVEL_TABLE[i] = (i-1) * 100
--end

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
ENABLED_RUNES = {}									-- Which runes should be enabled to spawn in our game mode?
ENABLED_RUNES[DOTA_RUNE_DOUBLEDAMAGE] = true
ENABLED_RUNES[DOTA_RUNE_HASTE] = true
ENABLED_RUNES[DOTA_RUNE_ILLUSION] = true
ENABLED_RUNES[DOTA_RUNE_INVISIBILITY] = true
ENABLED_RUNES[DOTA_RUNE_REGENERATION] = true		-- Regen runes are currently not spawning as of the writing of this comment
ENABLED_RUNES[DOTA_RUNE_BOUNTY] = true

MAX_NUMBER_OF_TEAMS = 2								-- How many potential teams can be in this game mode?
USE_CUSTOM_TEAM_COLORS = false						-- Should we use custom team colors?
USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS = false			-- Should we use custom team colors to color the players/minimap?

TEAM_COLORS = {}									-- If USE_CUSTOM_TEAM_COLORS is set, use these colors.
TEAM_COLORS[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }	-- Teal
TEAM_COLORS[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }	-- Yellow
TEAM_COLORS[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }	-- Pink
TEAM_COLORS[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }	-- Orange
TEAM_COLORS[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }	-- Blue
TEAM_COLORS[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }	-- Green
TEAM_COLORS[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }	-- Brown
TEAM_COLORS[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }	-- Cyan
TEAM_COLORS[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }	-- Olive
TEAM_COLORS[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }	-- Purple

USE_AUTOMATIC_PLAYERS_PER_TEAM = true				-- Should we set the number of players to 10 / MAX_NUMBER_OF_TEAMS?

CUSTOM_TEAM_PLAYER_COUNT = {}						-- If we're not automatically setting the number of players per team, use this table
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

-------------------------------------------------------------------------------------------------
-- IMBA: gameplay globals
-------------------------------------------------------------------------------------------------

HERO_KILL_GOLD_BASE = 100													-- Hero gold bounty base value
HERO_KILL_GOLD_PER_LEVEL = 9												-- Hero gold bounty increase per level

HERO_KILL_GOLD_PER_KILLSTREAK = 60											-- Amount of gold awarded per killstreak
HERO_KILL_GOLD_PER_DEATHSTREAK = 60											-- Amount of gold reduced from the hero's bounty on a deathstreak

HERO_DEATH_GOLD_LOSS_PER_LEVEL = 30											-- Amount of gold lost on death per level

HERO_DEATH_GOLD_LOSS_PER_DEATHSTREAK = 20									-- Amount of gold prevented from being lost on death per deathstreak (in %)

KILLSTREAK_EXP_FACTOR = 1.35												-- Killstreak gold formula exponent

HERO_ASSIST_RADIUS = 1300													-- Radius around the killed hero where allies will gain assist gold and experience

HERO_ASSIST_BOUNTY_FACTOR_2 = 0.60											-- Factor to multiply the assist bounty by when 2 heroes are involved
HERO_ASSIST_BOUNTY_FACTOR_3 = 0.40											-- Factor to multiply the assist bounty by when 3 heroes are involved
HERO_ASSIST_BOUNTY_FACTOR_4 = 0.30											-- Factor to multiply the assist bounty by when 4 heroes are involved
HERO_ASSIST_BOUNTY_FACTOR_5 = 0.25											-- Factor to multiply the assist bounty by when 5 heroes are involved

HERO_INITIAL_GOLD = 625														-- Gold granted to players at the start of the game on a normal pick
HERO_INITIAL_REPICK_GOLD = 525												-- Gold granted to players at the start of the game on repicking their hero
HERO_INITIAL_RANDOM_GOLD = 825												-- Gold granted to players at the start of the game on randoming their hero

HERO_BUYBACK_BASE_COST = 100												-- Base cost to buyback
HERO_BUYBACK_COST_PER_LEVEL = 25											-- Level-based buyback cost
HERO_BUYBACK_COST_PER_MINUTE = 15											-- Time-based buyback cost

HERO_BUYBACK_RESET_TIME_PER_LEVEL = 4										-- Time needed for the buyback price to reset, per hero level
HERO_BUYBACK_RESET_TIME_PER_MINUTE = 2										-- Time needed for the buyback price to reset, per minute of game time (in seconds)

HERO_BUYBACK_COST_SCALING = 30												-- Cost multiplier when buybacking in quick sucession (in %)

HERO_RESPAWN_TIME_BASE = 3.75												-- Base hero respawn time
HERO_RESPAWN_TIME_PER_LEVEL = 2.25											-- Hero respawn time per level

PLAYER_ABANDON_TIME = 180													-- Time for a player to be considered as having abandoned the game (in seconds)

-------------------------------------------------------------------------------------------------
-- IMBA: game mode globals
-------------------------------------------------------------------------------------------------

IMBA_PICK_MODE_ALL_PICK = true												-- Activates All Pick mode when true (default mode)

IMBA_ABILITY_MODE_RANDOM_OMG = false										-- Activates Random OMG mode when true
IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT = 4									-- Number of regular abilities in Random OMG mode
IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT = 2									-- Number of ultimate abilities in Random OMG mode
IMBA_RANDOM_OMG_HERO_SELECTION_TIME = 10.0									-- Time we need to wait before the game starts in Random OMG mode

CREEP_BOUNTY_BONUS = 30														-- Amount of bonus gold/XP granted by creeps and passive gold (in %)
HERO_BOUNTY_BONUS = 30														-- Amount of bonus gold/XP granted by heroes (in %)

HERO_BUYBACK_COST_MULTIPLIER = 100											-- User-defined buyback cost multiplier

HERO_RESPAWN_TIME_MULTIPLIER = 100											-- User-defined respawn time multiplier

-------------------------------------------------------------------------------------------------
-- IMBA: Stat collection
-------------------------------------------------------------------------------------------------
--if not BAREBONES_DEBUG_SPEW then
--  statcollection.addStats({
--    modID = "3c618932c8379fe1284bc14438f76c89"
--  })
--end