if Mutation == nil then
	Mutation = class({})

	IMBA_MUTATION = {}
	IMBA_MUTATION["positive"] = ""
	IMBA_MUTATION["negative"] = ""
	IMBA_MUTATION["terrain"] = ""
end

-- Positive Mutations 
POSITIVE_MUTATION_LIST = {}
POSITIVE_MUTATION_LIST[1] = "killstreak_power"
POSITIVE_MUTATION_LIST[2] = "teammate_resurrection"
POSITIVE_MUTATION_LIST[3] = "super_fervor"
POSITIVE_MUTATION_LIST[4] = "slark_mode"
POSITIVE_MUTATION_LIST[5] = "ultimate_level"
-- POSITIVE_MUTATION_LIST[6] = "pocket_roshan" -- not finished
-- POSITIVE_MUTATION_LIST[6] = "death_healplosion" -- not finished
-- POSITIVE_MUTATION_LIST[7] = "super_blink" -- nofun

-- POSITIVE_MUTATION_LIST[8] = "pocket_tower" -- patreon poll disable vote

-- POSITIVE_MUTATION_LIST[9] = "greed_is_good"

-- Negative Mutations
NEGATIVE_MUTATION_LIST = {}
NEGATIVE_MUTATION_LIST[1] = "death_explosion"
NEGATIVE_MUTATION_LIST[2] = "periodic_spellcast"
NEGATIVE_MUTATION_LIST[3] = "defense_of_the_ants"
NEGATIVE_MUTATION_LIST[4] = "monkey_business"
-- NEGATIVE_MUTATION_LIST[5] = "all_random_deathmatch"
-- NEGATIVE_MUTATION_LIST[5] = "death_gold_drop" -- nofun
-- NEGATIVE_MUTATION_LIST["alien_incubation"] = false
-- NEGATIVE_MUTATION_LIST["no_health_bar"] = false
-- NEGATIVE_MUTATION_LIST["stay_frosty"] = false

-- Terrain Mutations
TERRAIN_MUTATION_LIST = {}
TERRAIN_MUTATION_LIST[1] = "airdrop"
TERRAIN_MUTATION_LIST[2] = "river_flows"
TERRAIN_MUTATION_LIST[3] = "wormhole"
TERRAIN_MUTATION_LIST[4] = "tug_of_war"
TERRAIN_MUTATION_LIST[5] = "super_runes"

-- TERRAIN_MUTATION_LIST[5] = "danger_zone" -- nofun
-- TERRAIN_MUTATION_LIST[1] = "fast_runes" -- patreon poll disable vote
-- TERRAIN_MUTATION_LIST[3] = "speed_freaks" -- patreon poll disable vote

-- TERRAIN_MUTATION_LIST[9] = "minefield" -- nofun

-- TERRAIN_MUTATION_LIST["sleepy_river"] = false
-- TERRAIN_MUTATION_LIST["no_trees"] = false
-- TERRAIN_MUTATION_LIST["omni_vision"] = false
-- TERRAIN_MUTATION_LIST["sticky_river"] = false

-- Mutations Not coded/approved yet

-- POSITIVE_MUTATION_LIST["damage_reduction"] = false
-- POSITIVE_MUTATION_LIST["stationary_damage_reduction"] = false
-- POSITIVE_MUTATION_LIST["greedisgood"] = false
-- POSITIVE_MUTATION_LIST["angel_arena"] = false

-- NEGATIVE_MUTATION_LIST["the_walking_dead"] = false

-- TERRAIN_MUTATION_LIST["river_fag"] = false
-- TERRAIN_MUTATION_LIST["diretide"] = false
-- TERRAIN_MUTATION_LIST["void_path"] = false
-- TERRAIN_MUTATION_LIST["reality_rift"] = false
-- TERRAIN_MUTATION_LIST["blizzard"] = false
-- TERRAIN_MUTATION_LIST["twister"] = false
