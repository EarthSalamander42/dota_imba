-------------------------------------------------------------------------------------------------
-- IMBA: Game settings
-------------------------------------------------------------------------------------------------

IMBA_VERSION = "6.88"						-- Tracks game version

-------------------------------------------------------------------------------------------------
-- Barebones basics
-------------------------------------------------------------------------------------------------

START_GAME_AUTOMATICALLY = true				-- Should the game start automatically

ENABLE_HERO_RESPAWN = true					-- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = false					-- Should the main shop contain Secret Shop items as well as regular items

HERO_SELECTION_TIME = 45.0					-- How long should we let people select their hero?
PRE_GAME_TIME = 90.0 + HERO_SELECTION_TIME + 10.0	-- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0						-- How long should we let people look at the scoreboard before closing the server automatically?
AUTO_LAUNCH_DELAY = 20.0					-- How long should we wait for the host to setup the game, after all players have loaded in?
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
MAXIMUM_ATTACK_SPEED = 600					-- What should we use for the maximum attack speed?
MINIMUM_ATTACK_SPEED = 10					-- What should we use for the minimum attack speed?
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
BUYBACK_COOLDOWN_MAXIMUM = 300												-- Maximum buyback cooldown

ABANDON_TIME = 180															-- Time for a player to be considered as having abandoned the game (in seconds)
FULL_ABANDON_TIME = 15														-- Time for a team to be considered as having abandoned the game (in seconds)

ROSHAN_RESPAWN_TIME = 30													-- Roshan respawn timer (in seconds)
AEGIS_DURATION = 300														-- Aegis expiration timer (in seconds)

IMBA_DAMAGE_EFFECTS_DISTANCE_CUTOFF = 2500									-- Range at which most on-damage effects no longer trigger

COMEBACK_BOUNTY_SCORE = {}													-- Extra comeback gold based on hero and tower kills
COMEBACK_BOUNTY_SCORE[DOTA_TEAM_GOODGUYS] = 0
COMEBACK_BOUNTY_SCORE[DOTA_TEAM_BADGUYS] = 0
COMEBACK_BOUNTY_BONUS = {}													-- Extra comeback gold based on hero and tower kills
COMEBACK_BOUNTY_BONUS[DOTA_TEAM_GOODGUYS] = 0
COMEBACK_BOUNTY_BONUS[DOTA_TEAM_BADGUYS] = 0

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

SPELL_POWER_TALENTS = {}													-- Spell power talent values
SPELL_POWER_TALENTS["special_bonus_spell_amplify_3"] = 10
SPELL_POWER_TALENTS["special_bonus_spell_amplify_4"] = 15
SPELL_POWER_TALENTS["special_bonus_spell_amplify_5"] = 20
SPELL_POWER_TALENTS["special_bonus_spell_amplify_6"] = 25
SPELL_POWER_TALENTS["special_bonus_spell_amplify_8"] = 30
SPELL_POWER_TALENTS["special_bonus_spell_amplify_10"] = 35
SPELL_POWER_TALENTS["special_bonus_spell_amplify_12"] = 40
SPELL_POWER_TALENTS["special_bonus_spell_amplify_15"] = 45
SPELL_POWER_TALENTS["special_bonus_spell_amplify_20"] = 50
SPELL_POWER_TALENTS["special_bonus_spell_amplify_25"] = 60

ITEM_SPELL_POWER = {}														-- Spell power item values
ITEM_SPELL_POWER["item_imba_aether_lens"] = 10
ITEM_SPELL_POWER["item_imba_nether_wand"] = 10
ITEM_SPELL_POWER["item_imba_elder_staff"] = 20
ITEM_SPELL_POWER["item_imba_orchid"] = 25
ITEM_SPELL_POWER["item_imba_bloodthorn"] = 30
ITEM_SPELL_POWER["item_imba_rapier_magic"] = 70
ITEM_SPELL_POWER["item_imba_rapier_magic_2"] = 200
ITEM_SPELL_POWER["item_imba_rapier_cursed"] = 200

MODIFIER_SPELL_POWER = {}													-- Spell power modifier values
MODIFIER_SPELL_POWER["modifier_imba_rune_double_damage_owner"] = 50
MODIFIER_SPELL_POWER["modifier_imba_rune_double_damage_aura"] = 20

CAST_RANGE_TALENTS = {}														-- Cast range talent values
CAST_RANGE_TALENTS["special_bonus_cast_range_50"] = 100
CAST_RANGE_TALENTS["special_bonus_cast_range_60"] = 125
CAST_RANGE_TALENTS["special_bonus_cast_range_75"] = 150
CAST_RANGE_TALENTS["special_bonus_cast_range_100"] = 200
CAST_RANGE_TALENTS["special_bonus_cast_range_125"] = 250
CAST_RANGE_TALENTS["special_bonus_cast_range_150"] = 300
CAST_RANGE_TALENTS["special_bonus_cast_range_175"] = 350
CAST_RANGE_TALENTS["special_bonus_cast_range_200"] = 400
CAST_RANGE_TALENTS["special_bonus_cast_range_250"] = 450
CAST_RANGE_TALENTS["special_bonus_cast_range_300"] = 500

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
elseif GetMapName() == "imba_random_omg" then
	IMBA_ABILITY_MODE_RANDOM_OMG = true
elseif GetMapName() == "imba_custom" then
	IMBA_PICK_MODE_ALL_PICK = true
elseif GetMapName() == "imba_10v10" then
	IMBA_PICK_MODE_ALL_PICK = true
	IMBA_PLAYERS_ON_GAME = 20
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 10
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 10
elseif GetMapName() == "imba_arena" then
	IMBA_PICK_MODE_ALL_PICK = true
	IMBA_PLAYERS_ON_GAME = 16
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 8
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 8
end

-------------------------------------------------------------------------------------------------
-- IMBA: game mode globals
-------------------------------------------------------------------------------------------------

GAME_WINNER_TEAM = "none"													-- Tracks game winner
GAME_ROSHAN_KILLS = 0														-- Tracks amount of Roshan kills

END_GAME_ON_KILLS = false													-- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 40												-- How many kills for a team should signify the end of the game?

IMBA_WISP_PICKERS_TABLE = {}												-- Stores the pick-dummy wisps
			
ALLOW_SAME_HERO_SELECTION = true											-- Allows people to select the same hero as each other if true

IMBA_HYPER_MODE_ON = false													-- Is Hyper mode activated?

IMBA_PICK_MODE_ALL_RANDOM = false											-- Activates All Random mode when true
IMBA_ALL_RANDOM_HERO_SELECTION_TIME = 5.0									-- Time we need to wait before the game starts when all heroes are randomed

IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT = 5									-- Number of regular abilities in Random OMG mode
IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT = 1									-- Number of ultimate abilities in Random OMG mode

CUSTOM_GOLD_BONUS = 30														-- Amount of bonus gold gained (in %)
CUSTOM_XP_BONUS = 30														-- Amount of bonus XP gained (in %)

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

HERO_STARTING_LEVEL = 1														-- User-defined starting level

USE_CUSTOM_HERO_LEVELS = true												-- Should we allow heroes to have custom levels?
MAX_LEVEL = 40																-- What level should we let heroes get to?

-- Changes settings according to the current map
if GetMapName() == "imba_standard" then										-- Standard map defaults
	END_GAME_ON_KILLS = false
	CUSTOM_GOLD_BONUS = 35
	CUSTOM_XP_BONUS = 35
	CREEP_POWER_FACTOR = 1
	TOWER_UPGRADE_MODE = false
	TOWER_POWER_FACTOR = 1
	HERO_RESPAWN_TIME_MULTIPLIER = 100
	HERO_INITIAL_GOLD = 625
	HERO_REPICK_GOLD = 525
	HERO_RANDOM_GOLD = 825
	HERO_STARTING_LEVEL = 1
	MAX_LEVEL = 40
elseif GetMapName() == "imba_random_omg" then								-- ROMG map defaults
	END_GAME_ON_KILLS = false
	CUSTOM_GOLD_BONUS = 35
	CUSTOM_XP_BONUS = 35
	CREEP_POWER_FACTOR = 1
	TOWER_UPGRADE_MODE = false
	TOWER_POWER_FACTOR = 1
	HERO_RESPAWN_TIME_MULTIPLIER = 100
	HERO_INITIAL_GOLD = 625
	HERO_REPICK_GOLD = 525
	HERO_RANDOM_GOLD = 825
	HERO_STARTING_LEVEL = 1
	MAX_LEVEL = 40
	IMBA_PICK_MODE_ALL_RANDOM = true
elseif GetMapName() == "imba_custom" then									-- Custom map defaults
	END_GAME_ON_KILLS = false
	CUSTOM_GOLD_BONUS = 150
	CUSTOM_XP_BONUS = 150
	CREEP_POWER_FACTOR = 2
	TOWER_UPGRADE_MODE = true
	TOWER_POWER_FACTOR = 1
	HERO_RESPAWN_TIME_MULTIPLIER = 75
	HERO_INITIAL_GOLD = 2000
	HERO_REPICK_GOLD = 1600
	HERO_RANDOM_GOLD = 2400
	HERO_STARTING_LEVEL = 5
	MAX_LEVEL = 50
elseif GetMapName() == "imba_10v10" then									-- 10v10 map defaults
	END_GAME_ON_KILLS = false
	CUSTOM_GOLD_BONUS = 60
	CUSTOM_XP_BONUS = 60
	CREEP_POWER_FACTOR = 1
	TOWER_UPGRADE_MODE = true
	TOWER_POWER_FACTOR = 1
	HERO_RESPAWN_TIME_MULTIPLIER = 75
	HERO_INITIAL_GOLD = 2000
	HERO_REPICK_GOLD = 1600
	HERO_RANDOM_GOLD = 2400
	HERO_STARTING_LEVEL = 5
	MAX_LEVEL = 40
elseif GetMapName() == "imba_arena" then									-- Arena map defaults
	END_GAME_ON_KILLS = true
	TOWER_ABILITY_MODE = false
	TOWER_UPGRADE_MODE = false
	SPAWN_ANCIENT_BEHEMOTHS = false
	UNIVERSAL_SHOP_MODE = true
	CUSTOM_GOLD_BONUS = 100
	CUSTOM_XP_BONUS = 100
	TOWER_POWER_FACTOR = 2
	HERO_RESPAWN_TIME_MULTIPLIER = 50
	HERO_INITIAL_GOLD = 1000
	HERO_REPICK_GOLD = 750
	HERO_RANDOM_GOLD = 1250
	HERO_STARTING_LEVEL = 3
	MAX_LEVEL = 40
	RUNE_SPAWN_TIME = 15
	FOUNTAIN_PERCENTAGE_MANA_REGEN = 15
	FOUNTAIN_PERCENTAGE_HEALTH_REGEN = 15
	PRE_GAME_TIME = 15.0 + HERO_SELECTION_TIME + 10.0
end

-- Update game mode net tables
CustomNetTables:SetTableValue("game_options", "all_random", {IMBA_PICK_MODE_ALL_RANDOM})
CustomNetTables:SetTableValue("game_options", "tower_upgrades", {TOWER_UPGRADE_MODE})
CustomNetTables:SetTableValue("game_options", "kills_to_end", {END_GAME_ON_KILLS})
CustomNetTables:SetTableValue("game_options", "bounty_multiplier", {100 + CUSTOM_GOLD_BONUS})
CustomNetTables:SetTableValue("game_options", "creep_power", {CREEP_POWER_FACTOR})
CustomNetTables:SetTableValue("game_options", "tower_power", {TOWER_POWER_FACTOR})
CustomNetTables:SetTableValue("game_options", "respawn_multiplier", {100 - HERO_RESPAWN_TIME_MULTIPLIER})
CustomNetTables:SetTableValue("game_options", "initial_gold", {HERO_INITIAL_GOLD})
CustomNetTables:SetTableValue("game_options", "initial_level", {HERO_STARTING_LEVEL})
CustomNetTables:SetTableValue("game_options", "max_level", {MAX_LEVEL})

-- XP per level table (only active if custom hero levels are enabled) 
XP_PER_LEVEL_TABLE = {}

XP_PER_LEVEL_TABLE[1] = 0

for i = 2, 5 do
	XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i-1] + i * 100
end

XP_PER_LEVEL_TABLE[6] = 2000
XP_PER_LEVEL_TABLE[7] = 2640
XP_PER_LEVEL_TABLE[8] = 3300
XP_PER_LEVEL_TABLE[9] = 3980
XP_PER_LEVEL_TABLE[10] = 4680
XP_PER_LEVEL_TABLE[11] = 5400
XP_PER_LEVEL_TABLE[12] = 6140
XP_PER_LEVEL_TABLE[13] = 7340
XP_PER_LEVEL_TABLE[14] = 8565
XP_PER_LEVEL_TABLE[15] = 9815
XP_PER_LEVEL_TABLE[16] = 11090
XP_PER_LEVEL_TABLE[17] = 12390
XP_PER_LEVEL_TABLE[18] = 13715
XP_PER_LEVEL_TABLE[19] = 15115
XP_PER_LEVEL_TABLE[20] = 16605
XP_PER_LEVEL_TABLE[21] = 18180
XP_PER_LEVEL_TABLE[22] = 20080
XP_PER_LEVEL_TABLE[23] = 22280
XP_PER_LEVEL_TABLE[24] = 24500

for i = 25, MAX_LEVEL do
	XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i-1] + i * 100
end

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
IS_BANNED_PLAYER = false													-- Is this player banned from playing the game?

-------------------------------------------------------------------------------------------------
-- IMBA: Keyvalue tables
-------------------------------------------------------------------------------------------------

HERO_ABILITY_LIST = LoadKeyValues("scripts/npc//KV/nonhidden_ability_list.kv")
TOWER_ABILITIES = LoadKeyValues("scripts/npc/KV/tower_abilities.kv")
RANDOM_OMG_HEROES = LoadKeyValues("scripts/npc/KV/random_omg_heroes.kv")
RANDOM_OMG_ABILITIES = LoadKeyValues("scripts/npc/KV/random_omg_abilities.kv")
RANDOM_OMG_ULTIMATES = LoadKeyValues("scripts/npc/KV/random_omg_ultimates.kv")
PURGE_BUFF_LIST = LoadKeyValues("scripts/npc/KV/purge_buffs_list.kv")