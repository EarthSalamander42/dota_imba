-- Editors:
--     Earth Salamander #42

if Mutation == nil then
	Mutation = class({})

	IMBA_MUTATION = {}
	IMBA_MUTATION["positive"] = ""
	IMBA_MUTATION["negative"] = ""
	IMBA_MUTATION["terrain"] = ""
end

POSITIVE_MUTATION_LIST = {}
-- VANILLA
POSITIVE_MUTATION_LIST["killstreak_power"] = false
-- POSITIVE_MUTATION_LIST["jump_start"] = false
POSITIVE_MUTATION_LIST["teammate_resurrection"] = false
POSITIVE_MUTATION_LIST["super_blink"] = false
POSITIVE_MUTATION_LIST["pocket_tower"] = false
POSITIVE_MUTATION_LIST["super_fervor"] = false

-- Not coded/approved yet
-- POSITIVE_MUTATION_LIST["damage_reduction"] = false
-- POSITIVE_MUTATION_LIST["stationary_damage_reduction"] = false
-- POSITIVE_MUTATION_LIST["super_runes"] = false

-- IMBA
POSITIVE_MUTATION_LIST["frantic"] = false
POSITIVE_MUTATION_LIST["slark_mode"] = false

-- Not coded/approved yet
-- POSITIVE_MUTATION_LIST["greedisgood"] = false
-- POSITIVE_MUTATION_LIST["angel_arena"] = false

NEGATIVE_MUTATION_LIST = {}
-- VANILLA
NEGATIVE_MUTATION_LIST["death_explosion"] = false
-- NEGATIVE_MUTATION_LIST["death_gold_drop"] = false
-- NEGATIVE_MUTATION_LIST["no_health_bar"] = false
NEGATIVE_MUTATION_LIST["periodic_spellcast"] = false

-- IMBA
NEGATIVE_MUTATION_LIST["defense_of_the_ants"] = false

-- Disabled
-- NEGATIVE_MUTATION_LIST["stay_frosty"] = false

-- Not coded/approved yet
-- NEGATIVE_MUTATION_LIST["monkey_business"] = false
-- NEGATIVE_MUTATION_LIST["the_walking_dead"] = false
-- NEGATIVE_MUTATION_LIST["alien_incubation"] = false

TERRAIN_MUTATION_LIST = {}
TERRAIN_MUTATION_LIST["sleepy_river"] = false
TERRAIN_MUTATION_LIST["fast_runes"] = false
TERRAIN_MUTATION_LIST["call_down"] = false
--TERRAIN_MUTATION_LIST["minefield"] = false
TERRAIN_MUTATION_LIST["gift_exchange"] = false
TERRAIN_MUTATION_LIST["speed_freaks"] = false

-- Disabled
-- TERRAIN_MUTATION_LIST["no_trees"] = false
-- TERRAIN_MUTATION_LIST["omni_vision"] = false
-- TERRAIN_MUTATION_LIST["river_flows"] = false
-- TERRAIN_MUTATION_LIST["sticky_river"] = false

-- Not coded/approved yet
-- TERRAIN_MUTATION_LIST["danger_zone"] = false -- add archer's music danger zone
-- TERRAIN_MUTATION_LIST["river_fag"] = false
-- TERRAIN_MUTATION_LIST["diretide"] = false
-- TERRAIN_MUTATION_LIST["void_path"] = false
-- TERRAIN_MUTATION_LIST["reality_rift"] = false
-- TERRAIN_MUTATION_LIST["blizzard"] = false
-- TERRAIN_MUTATION_LIST["twister"] = false
