-- In this file you can set up all the properties and settings for your game mode.

ENABLE_HERO_RESPAWN = true              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = true             -- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = false		-- Should we let people select the same hero as each other

HERO_SELECTION_TIME = 30.0              -- How long should we let people select their hero?
PRE_GAME_TIME = 90.0                    -- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0                   -- How long should we let people look at the scoreboard before closing the server automatically?
TREE_REGROW_TIME = 60.0                 -- How long should it take individual trees to respawn after being cut down/destroyed?
STRATEGY_TIME = 10.0
SHOWCASE_TIME = 0.0
AP_BAN_TIME = 10.0
AUTO_LAUNCH_DELAY = 10.0                -- How long should the default team selection launch timer be?  The default for custom games is 30.  Setting to 0 will skip team selection.

if IsInToolsMode() then
	AUTO_LAUNCH_DELAY = 0.0
	AP_BAN_TIME = 0.0
	STRATEGY_TIME = 0.0
end

GOLD_PER_TICK = 1						-- How much gold should players get per tick?

CAMERA_DISTANCE_OVERRIDE = -1           -- How far out should we allow the camera to go?  Use -1 for the default (1134) while still allowing for panorama camera distance changes

MINIMAP_ICON_SIZE = 1                   -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1              -- What icon size should we use for runes?

RUNE_SPAWN_TIME = 120                   -- How long in seconds should we wait between rune spawns?
CUSTOM_BUYBACK_COST_ENABLED = false		-- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = false	-- Should we use a custom buyback time?
BUYBACK_ENABLED = true					-- Should we allow people to buyback when they die?

DISABLE_FOG_OF_WAR_ENTIRELY = false     -- Should we disable fog of war entirely for both teams?
USE_UNSEEN_FOG_OF_WAR = false           -- Should we make unseen and fogged areas of the map completely black until uncovered by each team? 
										-- Note: DISABLE_FOG_OF_WAR_ENTIRELY must be false for USE_UNSEEN_FOG_OF_WAR to work
USE_STANDARD_DOTA_BOT_THINKING = true	-- Should we have bots act like they would in Dota? (This requires 3 lanes, normal items, etc)
USE_STANDARD_HERO_GOLD_BOUNTY = true    -- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?

TOP_BAR_VISIBLE = true                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = true             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = false-- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false       -- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players get gold?

END_GAME_ON_KILLS = false				-- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 50         -- How many kills for a team should signify an end of game?

USE_CUSTOM_HERO_LEVELS = false			-- Should we allow heroes to have custom levels?
MAX_LEVEL = 50                          -- What level should we let heroes get to?
USE_CUSTOM_XP_VALUES = false			-- Should we use custom XP values to level up heroes, or the default Dota numbers?

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {}
for i=1,MAX_LEVEL do
	XP_PER_LEVEL_TABLE[i] = (i-1) * 100
end

ENABLE_FIRST_BLOOD = true               -- Should we enable first blood for the first kill in this game?
HIDE_KILL_BANNERS = false               -- Should we hide the kill banners that show when a player is killed?
LOSE_GOLD_ON_DEATH = false               -- Should we have players lose the normal amount of dota gold on death?
SHOW_ONLY_PLAYER_INVENTORY = false      -- Should we only allow players to see their own inventory even when selecting other units?
DISABLE_STASH_PURCHASING = false        -- Should we prevent players from being able to buy items into their stash when not at a shop?
DISABLE_ANNOUNCER = false               -- Should we disable the announcer from working in the game?
FORCE_PICKED_HERO = nil                 -- What hero should we force all players to spawn as? (e.g. "npc_dota_hero_axe").  Use nil to allow players to pick their own hero.

FIXED_RESPAWN_TIME = -1                 -- What time should we use for a fixed respawn timer?  Use -1 to keep the default dota behavior.
FOUNTAIN_CONSTANT_MANA_REGEN = -1       -- What should we use for the constant fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_MANA_REGEN = -1     -- What should we use for the percentage fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_HEALTH_REGEN = -1   -- What should we use for the percentage fountain health regen?  Use -1 to keep the default dota behavior.
MAXIMUM_ATTACK_SPEED = 600              -- What should we use for the maximum attack speed?
MINIMUM_ATTACK_SPEED = 20               -- What should we use for the minimum attack speed?

GAME_END_DELAY = 30.0                     -- How long should we wait after the game winner is set to display the victory banner and End Screen?  Use -1 to keep the default (about 10 seconds)
VICTORY_MESSAGE_DURATION = 3.0            -- How long should we wait after the victory message displays to show the End Screen?  Use 
DISABLE_DAY_NIGHT_CYCLE = false         -- Should we disable the day night cycle from naturally occurring? (Manual adjustment still possible)
DISABLE_KILLING_SPREE_ANNOUNCER = false -- Shuold we disable the killing spree announcer?
DISABLE_STICKY_ITEM = false             -- Should we disable the sticky item button in the quick buy area?
SKIP_TEAM_SETUP = false                 -- Should we skip the team setup entirely?
ENABLE_AUTO_LAUNCH = true               -- Should we automatically have the game complete team setup after AUTO_LAUNCH_DELAY seconds?
LOCK_TEAM_SETUP = false                 -- Should we lock the teams initially?  Note that the host can still unlock the teams 
USE_MULTIPLE_COURIERS = true            -- Vanilla couriers?

CUSTOM_TEAM_PLAYER_COUNT = {}			-- If we're not automatically setting the number of players per team, use this table
CUSTOM_TEAM_PLAYER_COUNT["5v5"] = {}
CUSTOM_TEAM_PLAYER_COUNT["5v5"][DOTA_TEAM_GOODGUYS] = 5
CUSTOM_TEAM_PLAYER_COUNT["5v5"][DOTA_TEAM_BADGUYS]  = 5
CUSTOM_TEAM_PLAYER_COUNT["10v10"] = {}
CUSTOM_TEAM_PLAYER_COUNT["10v10"][DOTA_TEAM_GOODGUYS] = 10
CUSTOM_TEAM_PLAYER_COUNT["10v10"][DOTA_TEAM_BADGUYS]  = 10

PLAYER_COLORS = {}					-- Stores individual player colors
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

-- Was using GetRespawnTime() but Meepo respawn time is always 3, so let's use static values instead...
RESPAWN_TIME_VANILLA = {}
RESPAWN_TIME_VANILLA[1] = 6
RESPAWN_TIME_VANILLA[2] = 8
RESPAWN_TIME_VANILLA[3] = 10
RESPAWN_TIME_VANILLA[4] = 14
RESPAWN_TIME_VANILLA[5] = 16
RESPAWN_TIME_VANILLA[6] = 26
RESPAWN_TIME_VANILLA[7] = 28
RESPAWN_TIME_VANILLA[8] = 30
RESPAWN_TIME_VANILLA[9] = 32
RESPAWN_TIME_VANILLA[10] = 34
RESPAWN_TIME_VANILLA[11] = 36
RESPAWN_TIME_VANILLA[12] = 44
RESPAWN_TIME_VANILLA[13] = 46
RESPAWN_TIME_VANILLA[14] = 48
RESPAWN_TIME_VANILLA[15] = 50
RESPAWN_TIME_VANILLA[16] = 52
RESPAWN_TIME_VANILLA[17] = 54
RESPAWN_TIME_VANILLA[18] = 65
RESPAWN_TIME_VANILLA[19] = 70
RESPAWN_TIME_VANILLA[20] = 75
RESPAWN_TIME_VANILLA[21] = 80
RESPAWN_TIME_VANILLA[22] = 85
RESPAWN_TIME_VANILLA[23] = 90
RESPAWN_TIME_VANILLA[24] = 95
RESPAWN_TIME_VANILLA[25] = 100
RESPAWN_TIME_VANILLA[26] = 100
RESPAWN_TIME_VANILLA[27] = 100
RESPAWN_TIME_VANILLA[28] = 100
RESPAWN_TIME_VANILLA[29] = 100
RESPAWN_TIME_VANILLA[30] = 100

-- FRANTIC
_G.IMBA_FRANTIC_VALUE = 40

VANILLA_POWER_RUNE_TIME = 120.0
VANILLA_BOUNTY_RUNE_TIME = 180.0

local global_gold_bonus = 200 -- %
CUSTOM_GOLD_BONUS = {}
CUSTOM_GOLD_BONUS["5v5"] = global_gold_bonus
CUSTOM_GOLD_BONUS["10v10"] = global_gold_bonus

local global_xp_bonus = 200 -- %
CUSTOM_XP_BONUS = {}
CUSTOM_XP_BONUS["5v5"] = global_xp_bonus
CUSTOM_XP_BONUS["10v10"] = global_xp_bonus

-- Hero base level, values are doubled with Hyper for non-custom maps
local global_starting_level = 3
-- if IsInToolsMode() then global_starting_level = 1 end
HERO_STARTING_LEVEL = {} -- 1 = Normal, 2 = Hyper
HERO_STARTING_LEVEL["5v5"] = global_starting_level
HERO_STARTING_LEVEL["10v10"] = global_starting_level

-- vanilla, keep it as a static value because it is multiplied by gold multiplier
VANILA_HERO_INITIAL_GOLD = 600
HERO_INITIAL_GOLD = 600 -- will be multiplied based on gold map multiplier

local global_gold_tick_time = 0.6
local global_10v10_gold_tick_time = 0.4
GOLD_TICK_TIME = {}
GOLD_TICK_TIME["5v5"] = global_gold_tick_time
GOLD_TICK_TIME["10v10"] = global_10v10_gold_tick_time

FIRST_BOUNTY_RUNE_BONUS_PCT = 150 -- %

-- IMBA constants
IMBA_REINCARNATION_TIME = 3.0
IMBA_MAX_RESPAWN_TIME = 50.0		-- Maximum respawn time, does not include bonus reaper scythe duration
IMBA_RESPAWN_TIME_PCT = 50			-- Percentage of the respawn time from vanilla respawn time
