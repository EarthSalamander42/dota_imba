-- Editors:
--     Earth Salamander #42
--     AltiV

-- Airdrop Mutation Variables
local ITEMS_KV = LoadKeyValues("scripts/npc/npc_items_custom.txt")
local MAP_SIZE = 7000
local MAP_SIZE_AIRDROP = 5000
local validItems = {} -- Empty table to fill with full list of valid airdrop items
local minValue = 1000 -- Minimum cost of items that can spawn
local tier1 = {} -- 1000 to 2000 gold cost up to 5 minutes
local t1cap = 2000
local t1time = 5 * 60
local tier2 = {} -- 2000 to 3500 gold cost up to 10 minutes
local t2cap = 3500
local t2time = 10 * 60
local tier3 = {} -- 3500 to 5000 gold cost up to 15 minutes
local t3cap = 5000
local t3time = 15 * 60
local tier4 = {} -- 5000 to 99998 gold cost beyond 15 minutes
local counter = 1 -- Slowly increments as time goes on to expand list of cost-valid items
local varFlag = 0 -- Flag to stop the repeat until loop for tier iterations
--

function Mutation:Init()
--	print("Mutation: Initialize...")

	LinkLuaModifier("modifier_mutation_death_explosion", "components/mutation/modifiers/modifier_mutation_death_explosion.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_kill_streak_power", "components/mutation/modifiers/modifier_mutation_kill_streak_power.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_frantic", "modifier/modifier_frantic.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_no_health_bar", "components/mutation/modifiers/modifier_no_health_bar.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_shadow_dance", "components/mutation/modifiers/modifier_mutation_shadow_dance.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_ants", "components/mutation/modifiers/modifier_mutation_ants.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_disable_healing", "components/mutation/modifiers/modifier_disable_healing.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_stay_frosty", "components/mutation/modifiers/modifier_mutation_stay_frosty.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_speed_freaks", "components/mutation/modifiers/modifier_mutation_speed_freaks.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_super_fervor", "components/mutation/modifiers/modifier_mutation_super_fervor.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_greed_is_good", "components/mutation/modifiers/modifier_mutation_greed_is_good.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_alien_incubation", "components/mutation/modifiers/modifier_mutation_alien_incubation.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_wormhole_cooldown", "components/mutation/modifiers/modifier_mutation_wormhole_cooldown.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_tug_of_war_golem", "components/mutation/modifiers/modifier_mutation_tug_of_war_golem.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_sun_strike", "components/mutation/modifiers/periodic_spellcast/modifier_mutation_sun_strike.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_call_down", "components/mutation/modifiers/modifier_mutation_call_down.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_thundergods_wrath", "components/mutation/modifiers/periodic_spellcast/modifier_mutation_thundergods_wrath.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_track", "components/mutation/modifiers/periodic_spellcast/modifier_mutation_track.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_rupture", "components/mutation/modifiers/periodic_spellcast/modifier_mutation_rupture.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_torrent", "components/mutation/modifiers/periodic_spellcast/modifier_mutation_torrent.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_cold_feet", "components/mutation/modifiers/periodic_spellcast/modifier_mutation_cold_feet.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_stampede", "components/mutation/modifiers/periodic_spellcast/modifier_mutation_stampede.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_bloodlust", "components/mutation/modifiers/periodic_spellcast/modifier_mutation_bloodlust.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_aphotic_shield", "components/mutation/modifiers/periodic_spellcast/modifier_mutation_aphotic_shield.lua", LUA_MODIFIER_MOTION_NONE )

	LinkLuaModifier("modifier_mutation_river_flows", "components/mutation/modifiers/modifier_mutation_river_flows.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_sticky_river", "modifier/mutation/modifier_sticky_river.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_ultimate_level", "modifier/modifier_ultimate_level.lua", LUA_MODIFIER_MOTION_NONE )

	-- Selecting Mutations (Take out if statement for IsInToolsMode if you want to test randomized)
	if IsInToolsMode() then
		IMBA_MUTATION["positive"] = "ultimate_level"
		IMBA_MUTATION["negative"] = "periodic_spellcast"
		IMBA_MUTATION["terrain"] = "speed_freaks"
	else
		Mutation:ChooseMutation("positive", POSITIVE_MUTATION_LIST)
		Mutation:ChooseMutation("negative", NEGATIVE_MUTATION_LIST)
		Mutation:ChooseMutation("terrain", TERRAIN_MUTATION_LIST)
	end

	IMBA_MUTATION_PERIODIC_SPELLS = {}
	IMBA_MUTATION_PERIODIC_SPELLS[1] = {"sun_strike", "Sunstrike", "Red", -1}
	IMBA_MUTATION_PERIODIC_SPELLS[2] = {"thundergods_wrath", "Thundergod's Wrath", "Red", 3.5}
	IMBA_MUTATION_PERIODIC_SPELLS[3] = {"rupture", "Rupture", "Red", 10.0}
	IMBA_MUTATION_PERIODIC_SPELLS[4] = {"torrent", "Torrent", "Red", 10}
	IMBA_MUTATION_PERIODIC_SPELLS[5] = {"cold_feet", "Cold Feet", "Red", 4.0}
	IMBA_MUTATION_PERIODIC_SPELLS[6] = {"stampede", "Stampede", "Green", 5.0}
	IMBA_MUTATION_PERIODIC_SPELLS[7] = {"bloodlust", "Bloodlust", "Green", 30.0}
	IMBA_MUTATION_PERIODIC_SPELLS[8] = {"aphotic_shield", "Aphotic Shield", "Green", 15.0}
	--IMBA_MUTATION_PERIODIC_SPELLS[9] = {"track", "Track", "Red", 20.0}

	-- Negative Spellcasts
	IMBA_MUTATION_PERIODIC_SPELLS[1] = {}
	IMBA_MUTATION_PERIODIC_SPELLS[1][1] = {"sun_strike", "Sunstrike", "Red", -1}
	IMBA_MUTATION_PERIODIC_SPELLS[1][2] = {"thundergods_wrath", "Thundergod's Wrath", "Red", -1}
	IMBA_MUTATION_PERIODIC_SPELLS[1][3] = {"rupture", "Rupture", "Red", 10.0}
	IMBA_MUTATION_PERIODIC_SPELLS[1][4] = {"torrent", "Torrent", "Red", 45}
	IMBA_MUTATION_PERIODIC_SPELLS[1][5] = {"cold_feet", "Cold Feet", "Red", 4.0}

	-- Positive Spellcasts
	IMBA_MUTATION_PERIODIC_SPELLS[2] = {}
	IMBA_MUTATION_PERIODIC_SPELLS[2][1] = {"stampede", "Stampede", "Green", 5.0}
	IMBA_MUTATION_PERIODIC_SPELLS[2][2] = {"bloodlust", "Bloodlust", "Green", 30.0}
	IMBA_MUTATION_PERIODIC_SPELLS[2][3] = {"aphotic_shield", "Aphotic Shield", "Green", 15.0}
	
	IMBA_MUTATION_WORMHOLE_COLORS = {}
	IMBA_MUTATION_WORMHOLE_COLORS[1] = Vector(100, 0, 0)
	IMBA_MUTATION_WORMHOLE_COLORS[2] = Vector(0, 100, 0)
	IMBA_MUTATION_WORMHOLE_COLORS[3] = Vector(0, 0, 100)
	IMBA_MUTATION_WORMHOLE_COLORS[4] = Vector(100, 100, 0)
	IMBA_MUTATION_WORMHOLE_COLORS[5] = Vector(100, 0, 100)
	IMBA_MUTATION_WORMHOLE_COLORS[6] = Vector(0, 100, 100)
	IMBA_MUTATION_WORMHOLE_COLORS[7] = Vector(0, 100, 100)
	IMBA_MUTATION_WORMHOLE_COLORS[8] = Vector(100, 0, 100)
	IMBA_MUTATION_WORMHOLE_COLORS[9] = Vector(100, 100, 0)
	IMBA_MUTATION_WORMHOLE_COLORS[10] = Vector(0, 0, 100)
	IMBA_MUTATION_WORMHOLE_COLORS[11] = Vector(0, 100, 0)
	IMBA_MUTATION_WORMHOLE_COLORS[12] = Vector(100, 0, 0)

	IMBA_MUTATION_WORMHOLE_POSITIONS = {}
	IMBA_MUTATION_WORMHOLE_POSITIONS[1] = Vector(-2471, -5025, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[2] = Vector(-576, -4320, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[3] = Vector(794, -3902, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[4] = Vector(2630, -3700, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[5] = Vector(3203, -6064, 0) -- Bot Lane Wormhole
	IMBA_MUTATION_WORMHOLE_POSITIONS[6] = Vector(1111, -5804, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[7] = Vector(4419, -5114, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[8] = Vector(6156, -4831, 0) -- Bot Lane Wormhole
	IMBA_MUTATION_WORMHOLE_POSITIONS[9] = Vector(6084, -3022, 0) -- Bone Lane Wormhole
	IMBA_MUTATION_WORMHOLE_POSITIONS[10] = Vector(4422, -1765, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[11] = Vector(6186, -654, 0) -- Bot Lane Wormhole
	IMBA_MUTATION_WORMHOLE_POSITIONS[12] = Vector(4754, -84, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[13] = Vector(3318, -58, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[14] = Vector(5008, 1799, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[15] = Vector(1534, -649, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[16] = Vector(2641, -2003, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[17] = Vector(3939, 2279, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[18] = Vector(2309, 4643, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[19] = Vector(843, 2300, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[20] = Vector(-544, -361, 0) -- Mid Lane Wormhole (Center)
	IMBA_MUTATION_WORMHOLE_POSITIONS[21] = Vector(354, -1349, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[22] = Vector(289, -2559, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[23] = Vector(-1534, -2893, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[24] = Vector(-5366, -2570, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[25] = Vector(-5238, -1727, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[26] = Vector(-3363, -1210, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[27] = Vector(-4535, 10, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[28] = Vector(-4420, 1351, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[29] = Vector(-6161, 440, 0) -- Top Lane Wormhole
	IMBA_MUTATION_WORMHOLE_POSITIONS[30] = Vector(-2110, 376, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[31] = Vector(-840, 1384, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[32] = Vector(-388, 2537, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[33] = Vector(-36, 4042, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[34] = Vector(-1389, 4325, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[35] = Vector(-2812, 3633, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[36] = Vector(-4574, 4804, 0)
	IMBA_MUTATION_WORMHOLE_POSITIONS[37] = Vector(-6339, 3841, 0) -- Top Lane Wormhole
	IMBA_MUTATION_WORMHOLE_POSITIONS[38] = Vector(-5971, 5455, 0) -- Top Lane Wormhole
	IMBA_MUTATION_WORMHOLE_POSITIONS[39] = Vector(-3099, 6112, 0) -- Top Lane Wormhole
	IMBA_MUTATION_WORMHOLE_POSITIONS[40] = Vector(-1606, 6103, 0) -- Top Lane Wormhole

	--IMBA_MUTATION_WORMHOLE_INTERVAL = 600
	--IMBA_MUTATION_WORMHOLE_DURATION = 600
	IMBA_MUTATION_WORMHOLE_PREVENT_DURATION = 3

	IMBA_MUTATION_TUG_OF_WAR_START = {}
	IMBA_MUTATION_TUG_OF_WAR_START[DOTA_TEAM_BADGUYS] = Vector(4037, 3521, 0)
	IMBA_MUTATION_TUG_OF_WAR_START[DOTA_TEAM_GOODGUYS] = Vector(-4448, -3936, 0)
	IMBA_MUTATION_TUG_OF_WAR_TARGET = {}
	IMBA_MUTATION_TUG_OF_WAR_TARGET[DOTA_TEAM_BADGUYS] = Vector(-5864, -5340, 0)
	IMBA_MUTATION_TUG_OF_WAR_TARGET[DOTA_TEAM_GOODGUYS] = Vector(5654, 4939, 0)

--[     TO DO
--	"telekinesis",
--	"glimpse",

--	"shallow_grave",
--	"false_promise",
--	"bloodrage",
--]

	self.restricted_items = {
		"item_imba_ironleaf_boots",
		"item_imba_travel_boots",
		"item_imba_travel_boots_2",
		"item_big_cheese_cavern",
		"item_potion_of_cowardice",
		"item_cavern_dynamite",
		"item_book_of_intelligence",
		"item_book_of_agility",
		"item_book_of_strength",
		"item_deployable_shop",

		-- Removed items!
		"item_imba_triumvirate",
		"item_imba_sange_azura",
		"item_imba_azura_yasha",
		"item_imba_travel_boots",
		"item_imba_travel_boots_2",
		"item_imba_cyclone",
		"item_imba_recipe_cyclone",
		"item_imba_plancks_artifact",
		"item_recipe_imba_plancks_artifact",
		"item_nokrash_blade",
		"item_recipe_nokrash_blade",
	}

	self.item_spawn_delay = 10
	self.item_spawn_vision_linger = 10
	self.item_spawn_radius = 300
end

function Mutation:Precache(context)
	-- Death Gold Drop
--	PrecacheItemByNameSync("item_bag_of_gold", context)

	-- Killstreak Power
	PrecacheResource("particle", "particles/hw_fx/candy_carrying_stack.vpcf", context)

	-- Periodic Spellcast
	PrecacheResource("particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_bolt_parent.vpcf", context)
	PrecacheResource("particle", "particles/ambient/wormhole_circle.vpcf", context)
	PrecacheResource("particle", "particles/ambient/tug_of_war_team_dire.vpcf", context)
	PrecacheResource("particle", "particles/ambient/tug_of_war_team_radiant.vpcf", context)

	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_bloodseeker.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_bounty_hunter.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_troll_warlord.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context)
end

function Mutation:ChooseMutation(mType, mList)
	-- Pick a random number within bounds of given mutation list	
	local random_int = RandomInt(1, #mList)
	-- Select a mutation from within that list and place it in the relevant IMBA_MUTATION field
	IMBA_MUTATION[mType] = mList[random_int]
	--print("IMBA_MUTATION["..mType.."] mutation picked: ", mList[random_int])
end

-- Mutation: Events
function Mutation:OnGameRulesStateChange(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		if IsMutationMap() then
			Mutation:Init()
		end
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		if IMBA_MUTATION["terrain"] == "no_trees" then
			GameRules:SetTreeRegrowTime(99999)
			GridNav:DestroyTreesAroundPoint(Vector(0, 0, 0), 50000, false)
			Mutation:RevealAllMap(1.0)
		elseif IMBA_MUTATION["terrain"] == "omni_vision" then
			Mutation:RevealAllMap()
		elseif IMBA_MUTATION["terrain"] == "fast_runes" then
			RUNE_SPAWN_TIME = 30.0
			BOUNTY_RUNE_SPAWN_TIME = 60.0
		end
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if IMBA_MUTATION["negative"] == "periodic_spellcast" then
			local buildings = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, 20000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
			local good_fountain = nil
			local bad_fountain = nil

			for _, building in pairs(buildings) do
				local building_name = building:GetName()
				if string.find(building_name, "ent_dota_fountain_bad") then
					bad_fountain = building
				elseif string.find(building_name, "ent_dota_fountain_good") then
					good_fountain = building
				end
			end

			local random_int
			local counter = 0 -- Used to alternate between negative and positive spellcasts, and increments after each timer call
			local varSwap -- Switches between 1 and 2 based on counter for negative and positive spellcasts

			Timers:CreateTimer(55.0, function()
				varSwap = (counter % 2) + 1
				random_int = RandomInt(1, #IMBA_MUTATION_PERIODIC_SPELLS[varSwap])
				Notifications:TopToAll({text = IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][2].." Mutation in 5 seconds...", duration = 5.0, style = {color = IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][3]}})

				return 60.0
			end)

			Timers:CreateTimer(60.0, function()
				if bad_fountain == nil or good_fountain == nil then
					log.error("nao cucekd up!!! ")
					return 60.0 
				end

				for _, hero in pairs(HeroList:GetAllHeroes()) do
					if (hero:GetTeamNumber() == 3 and IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][3] == "Red") or (hero:GetTeamNumber() == 2 and IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][3] == "Green") then
						caster = good_fountain
					end

					hero:AddNewModifier(caster, caster, "modifier_mutation_"..IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][1], {duration=IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][4]})
				end
				counter = counter + 1

				return 60.0
			end)
		end

		if IMBA_MUTATION["terrain"] == "gift_exchange" then
			for k, v in pairs(ITEMS_KV) do -- Go through all the items in ITEMS_KV and store valid items in validItems table
				varFlag = 0 -- Let's borrow this memory to suss out the forbidden items first...

				if v["ItemCost"] and v["ItemCost"] >= minValue and v["ItemCost"] ~= 99999 and not string.find(k, "recipe") and not string.find(k, "cheese") then
					for _, item in pairs(self.restricted_items) do -- Make sure item isn't a restricted item
						if k == item then
							varFlag = 1
						end
					end

					if varFlag == 0 then -- If not a restricted item (while still meeting all the other criteria...)
						validItems[#validItems + 1] = {k = k, v = v["ItemCost"]}
					end	
				end
			end

			table.sort(validItems, function(a, b) return a.v < b.v end) -- Sort by ascending item cost for easier retrieval later on

			--[[
			print("Table length: ", #validItems) -- # of valid items
						
			for a, b in pairs(validItems) do
				print(a)
				for key, value in pairs(b) do
					print('\t', key, value)
				end
			end	
			]]--

			varFlag = 0

			-- Create Tier 1 Table
			repeat
				if validItems[counter].v <= t1cap then
					tier1[#tier1 + 1] = {k = validItems[counter].k, v = validItems[counter].v}
					counter = counter + 1
				else
					varFlag = 1
				end
			until varFlag == 1

			varFlag = 0

			-- Create Tier 2 Table
			repeat
				if validItems[counter].v <= t2cap then
					tier2[#tier2 + 1] = {k = validItems[counter].k, v = validItems[counter].v}
					counter = counter + 1
				else
					varFlag = 1
				end
			until varFlag == 1

			varFlag = 0

			-- Create Tier 3 Table
			repeat
				if validItems[counter].v <= t3cap then
					tier3[#tier3 + 1] = {k = validItems[counter].k, v = validItems[counter].v}
					counter = counter + 1
				else
					varFlag = 1
				end
			until varFlag == 1

			varFlag = 0

			-- Create Tier 4 Table
			for num = counter, #validItems do
				tier4[#tier4 + 1] = {k = validItems[num].k, v = validItems[num].v}
			end

			varFlag = 0

			--[[
			print("TIER 1 LIST")
			
			for a, b in pairs(tier1) do
				print(a)
				for key, value in pairs(b) do
					print('\t', key, value)
				end
			end	
			
			print("TIER 2 LIST")
			
			for a, b in pairs(tier2) do
				print(a)
				for key, value in pairs(b) do
					print('\t', key, value)
				end
			end	
			
			print("TIER 3 LIST")
			
			for a, b in pairs(tier3) do
				print(a)
				for key, value in pairs(b) do
					print('\t', key, value)
				end
			end	
			
			print("TIER 4 LIST")
			
			for a, b in pairs(tier4) do
				print(a)
				for key, value in pairs(b) do
					print('\t', key, value)
				end
			end	
			]]--

			Timers:CreateTimer(110.0, function()
				Mutation:SpawnRandomItem()

				return 120.0
			end)
		end

		if IMBA_MUTATION["terrain"] == "call_down" then
			local dummy_unit = CreateUnitByName("npc_dummy_unit_perma", Vector(0, 0, 0), true, nil, nil, DOTA_TEAM_NEUTRALS)
			dummy_unit:AddNewModifier(dummy_unit, nil, "modifier_mutation_call_down", {})
		end

		if IMBA_MUTATION["terrain"] == "wormhole" then
			-- Assign initial wormhole positions
			local current_wormholes = {}
			for i = 1, 12 do
				local random_int = RandomInt(1, #IMBA_MUTATION_WORMHOLE_POSITIONS)
				current_wormholes[i] = IMBA_MUTATION_WORMHOLE_POSITIONS[random_int]
				table.remove(IMBA_MUTATION_WORMHOLE_POSITIONS, random_int)
			end

			-- Create wormhole particles (destroy and redraw every minute to accommodate for reconnecting players)
			local wormhole_particles = {}
			Timers:CreateTimer(0, function()
					for i = 1, 12 do
						if wormhole_particles[i] then
							ParticleManager:DestroyParticle(wormhole_particles[i], true)
							ParticleManager:ReleaseParticleIndex(wormhole_particles[i])
						end
						wormhole_particles[i] = ParticleManager:CreateParticle("particles/ambient/wormhole_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl(wormhole_particles[i], 0, GetGroundPosition(current_wormholes[i], nil) + Vector(0, 0, 20))
						ParticleManager:SetParticleControl(wormhole_particles[i], 2, IMBA_MUTATION_WORMHOLE_COLORS[i])
					end
					return 60
				end)
			-- Teleport loop
			Timers:CreateTimer(function()
				-- Find units to teleport
				for i = 1, 12 do
					local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, current_wormholes[i], nil, 150, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)
					for _, unit in pairs(units) do
						if not unit:HasModifier("modifier_mutation_wormhole_cooldown") then
							if unit:IsHero() then
								unit:EmitSound("Wormhole.Disappear")
								Timers:CreateTimer(0.03, function()
									unit:EmitSound("Wormhole.Appear")
								end)
							else
								unit:EmitSound("Wormhole.CreepDisappear")
								Timers:CreateTimer(0.03, function()
									unit:EmitSound("Wormhole.CreepAppear")
								end)
							end
							unit:AddNewModifier(unit, nil, "modifier_mutation_wormhole_cooldown", {duration = IMBA_MUTATION_WORMHOLE_PREVENT_DURATION})
							FindClearSpaceForUnit(unit, current_wormholes[13-i], true)
							if unit.GetPlayerID and unit:GetPlayerID() then
								PlayerResource:SetCameraTarget(unit:GetPlayerID(), unit)
								Timers:CreateTimer(0.03, function()
									PlayerResource:SetCameraTarget(unit:GetPlayerID(), nil)
								end)
							end
						end
					end
				end

				return 0.5
			end)
		end

		if IMBA_MUTATION["terrain"] == "tug_of_war" then
			local golem
			-- Random a team for the initial golem spawn
			if RandomInt(1, 2) == 1 then
				golem = CreateUnitByName("npc_dota_mutation_golem", IMBA_MUTATION_TUG_OF_WAR_START[DOTA_TEAM_GOODGUYS], false, nil, nil, DOTA_TEAM_GOODGUYS)
				golem.ambient_pfx = ParticleManager:CreateParticle("particles/ambient/tug_of_war_team_radiant.vpcf", PATTACH_ABSORIGIN_FOLLOW, golem)
				ParticleManager:SetParticleControl(golem.ambient_pfx, 0, golem:GetAbsOrigin())
				Timers:CreateTimer(0.1, function()
					golem:MoveToPositionAggressive(IMBA_MUTATION_TUG_OF_WAR_TARGET[DOTA_TEAM_GOODGUYS])
				end)
			else
				golem = CreateUnitByName("npc_dota_mutation_golem", IMBA_MUTATION_TUG_OF_WAR_START[DOTA_TEAM_BADGUYS], false, nil, nil, DOTA_TEAM_BADGUYS)
				golem.ambient_pfx = ParticleManager:CreateParticle("particles/ambient/tug_of_war_team_dire.vpcf", PATTACH_ABSORIGIN_FOLLOW, golem)
				ParticleManager:SetParticleControl(golem.ambient_pfx, 0, golem:GetAbsOrigin())
				Timers:CreateTimer(0.1, function()
					golem:MoveToPositionAggressive(IMBA_MUTATION_TUG_OF_WAR_TARGET[DOTA_TEAM_BADGUYS])
				end)
			end

			-- Initial logic
			golem:AddNewModifier(golem, nil, "modifier_mutation_tug_of_war_golem", {}):SetStackCount(1)
			FindClearSpaceForUnit(golem, golem:GetAbsOrigin(), true)
			golem:SetDeathXP(50)
			golem:SetMinimumGoldBounty(50)
			golem:SetMaximumGoldBounty(50)
		end

		--[[
		if IMBA_MUTATION["terrain"] == "minefield" then
			local mines = {
				"npc_imba_techies_proximity_mine",
				"npc_imba_techies_proximity_mine_big_boom",
				"npc_imba_techies_stasis_trap",
			}

			Timers:CreateTimer(function()
				local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)		
				local mine_count = 0
				local max_mine_count = 75

				for _, unit in pairs(units) do
					if unit:GetUnitName() == "npc_imba_techies_proximity_mine" or unit:GetUnitName() == "npc_imba_techies_proximity_mine_big_boom" or unit:GetUnitName() == "npc_imba_techies_stasis_trap" then			
						if unit:GetUnitName() == "npc_imba_techies_proximity_mine" then
							unit:FindAbilityByName("imba_techies_proximity_mine_trigger"):SetLevel(RandomInt(1, 4))
						elseif unit:GetUnitName() == "npc_imba_techies_proximity_mine_big_boom" then
							unit:FindAbilityByName("imba_techies_proximity_mine_trigger"):SetLevel(RandomInt(1, 4))
						elseif unit:GetUnitName() == "npc_imba_techies_stasis_trap" then
							unit:FindAbilityByName("imba_techies_stasis_trap_trigger"):SetLevel(RandomInt(1, 4))
						end

						mine_count = mine_count + 1
					end
				end

				if mine_count < max_mine_count then
					for i = 1, 10 do
						local mine = CreateUnitByName(mines[RandomInt(1, #mines)], RandomVector(MAP_SIZE), true, nil, nil, DOTA_TEAM_NEUTRALS)
						mine:AddNewModifier(mine, nil, "modifier_invulnerable", {})
					end
				end

--				print("Mine count:", mine_count)
				return 10.0
			end)
		end
		]]
	end
end

function Mutation:OnHeroFirstSpawn(hero)
--	print("Mutation: On Hero Respawned")

	-- Check if we can add modifiers to hero
	if not Mutation:IsEligibleHero(hero) then return end

	-- Frantic is permanent now
	hero:AddNewModifier(hero, nil, "modifier_frantic", {})

	if IMBA_MUTATION["positive"] == "killstreak_power" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_kill_streak_power", {})
--	elseif IMBA_MUTATION["positive"] == "jump_start" then
--		hero:AddExperience(XP_PER_LEVEL_TABLE[6], DOTA_ModifyXP_CreepKill, false, true)
	elseif IMBA_MUTATION["positive"] == "super_blink" then
		if hero:IsIllusion() then return end
		hero:AddItemByName("item_imba_blink"):SetSellable(false)
	elseif IMBA_MUTATION["positive"] == "pocket_tower" then
		hero:AddItemByName("item_pocket_tower")
	elseif IMBA_MUTATION["positive"] == "greed_is_good" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_greed_is_good", {})
--	elseif IMBA_MUTATION["positive"] == "ultimate_level" then
--		hero:AddNewModifier(hero, nil, "modifier_ultimate_level", {})
	end

	if IMBA_MUTATION["negative"] == "death_explosion" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_death_explosion", {})
	elseif IMBA_MUTATION["negative"] == "no_health_bar" then
		hero:AddNewModifier(hero, nil, "modifier_no_health_bar", {})
	elseif IMBA_MUTATION["negative"] == "defense_of_the_ants" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_ants", {})
	elseif IMBA_MUTATION["negative"] == "stay_frosty" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_stay_frosty", {})
	end
end

function Mutation:OnHeroSpawn(hero)
--	print("Mutation: On Hero Respawned")

	-- Check if we can add modifiers to hero
	if not Mutation:IsEligibleHero(hero) then return end

	if IMBA_MUTATION["positive"] == "damage_reduction" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_damage_reduction", {})
	elseif IMBA_MUTATION["positive"] == "slark_mode" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_shadow_dance", {})
	end

	if IMBA_MUTATION["terrain"] == "sleepy_river" then
		hero:AddNewModifier(hero, nil, "modifier_river", {})
	end

	if IMBA_MUTATION["terrain"] == "river_flows" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_river_flows", {})
	end

	if IMBA_MUTATION["terrain"] == "sticky_river" then
		hero:AddNewModifier(hero, nil, "modifier_sticky_river", {})
	end

	if IMBA_MUTATION["terrain"] == "speed_freaks" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_speed_freaks", {})
	end

	if hero.tombstone_fx then
		ParticleManager:DestroyParticle(hero.tombstone_fx, false)
		ParticleManager:ReleaseParticleIndex(hero.tombstone_fx)
		hero.tombstone_fx = nil
	end
end

function Mutation:OnHeroDeath(hero)
--	print("Mutation: On Hero Dead")

	if IMBA_MUTATION["positive"] == "teammate_resurrection" then
		local newItem = CreateItem("item_tombstone", hero, hero)
		newItem:SetPurchaseTime(0)
		newItem:SetPurchaser(hero)

		local tombstone = SpawnEntityFromTableSynchronous("dota_item_tombstone_drop", {})
		tombstone:SetContainedItem(newItem)
		tombstone:SetAngles(0, RandomFloat(0, 360), 0)
		FindClearSpaceForUnit(tombstone, hero:GetAbsOrigin(), true)

		hero.tombstone_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/holdout_borrowed_time_"..hero:GetTeamNumber()..".vpcf", PATTACH_ABSORIGIN_FOLLOW, tombstone)
	end

--	if IMBA_MUTATION["negative"] == "death_gold_drop" then
--		local game_time = math.min(GameRules:GetDOTATime(false, false) / 60, 30)
--		local random_int = RandomInt(30, 60)
--		local newItem = CreateItem("item_bag_of_gold", nil, nil)
--		newItem:SetPurchaseTime(0)
--		newItem:SetCurrentCharges(random_int * game_time)

--		local drop = CreateItemOnPositionSync(hero:GetAbsOrigin(), newItem)
--		local dropTarget = hero:GetAbsOrigin() + RandomVector(RandomFloat( 50, 150 ))
--		newItem:LaunchLoot(true, 300, 0.75, dropTarget)
--		EmitSoundOn("Dungeon.TreasureItemDrop", hero)
--	end
end

function Mutation:ModifierFilter(keys)
	local modifier_owner = EntIndexToHScript(keys.entindex_parent_const)
	local modifier_name = keys.name_const
	local modifier_caster = EntIndexToHScript(keys.entindex_caster_const)


end

function Mutation:OnThink()
--	print("Mutation: On Think")

end

-- Mutation: Utilities

function Mutation:RevealAllMap(duration)
	GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)

	if duration then
		Timers:CreateTimer(duration, function()
				GameRules:GetGameModeEntity():SetFogOfWarDisabled(false)
			end)
	end
end

function Mutation:SpawnRandomItem()
	local selectedItem 

	if GameRules:GetDOTATime(false, false) > t3time then
		selectedItem = tier4[RandomInt(1, #tier4)].k
	elseif GameRules:GetDOTATime(false, false) > t2time then
		selectedItem = tier3[RandomInt(1, #tier3)].k
	elseif GameRules:GetDOTATime(false, false) > t1time then
		selectedItem = tier2[RandomInt(1, #tier2)].k
	else
		selectedItem = tier1[RandomInt(1, #tier1)].k
	end

	local pos = RandomVector(MAP_SIZE_AIRDROP)
	AddFOWViewer(2, pos, self.item_spawn_radius, self.item_spawn_delay + self.item_spawn_vision_linger, false)
	AddFOWViewer(3, pos, self.item_spawn_radius, self.item_spawn_delay + self.item_spawn_vision_linger, false)
	GridNav:DestroyTreesAroundPoint(pos, self.item_spawn_radius, false)

	local particle_dummy = CreateUnitByName("npc_dummy_unit", pos, true, nil, nil, 6)
	local particle_arena_fx = ParticleManager:CreateParticle("particles/hero/centaur/centaur_hoof_stomp_arena.vpcf", PATTACH_ABSORIGIN_FOLLOW, particle_dummy)
	ParticleManager:SetParticleControl(particle_arena_fx, 0, pos)
	ParticleManager:SetParticleControl(particle_arena_fx, 1, Vector(self.item_spawn_radius + 45, 1, 1))

	local particle = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_timer.vpcf", PATTACH_ABSORIGIN_FOLLOW, particle_dummy)
	ParticleManager:SetParticleControl(particle, 1, Vector(self.item_spawn_delay, 0, 0))
	ParticleManager:SetParticleControl(particle, 3, pos)
	ParticleManager:ReleaseParticleIndex(particle)

	Timers:CreateTimer(self.item_spawn_delay, function()
			local item = CreateItem(selectedItem, nil, nil)
			item.airdrop = true
			-- print("Item Name:", selectedItem, pos)

			local drop = CreateItemOnPositionSync(pos, item)

			CustomGameEventManager:Send_ServerToAllClients("item_has_spawned", {spawn_location = pos})
			EmitGlobalSound( "powerup_05" )

			ParticleManager:DestroyParticle(particle_arena_fx, false)
			ParticleManager:ReleaseParticleIndex(particle_arena_fx)

			particle_dummy:ForceKill(false)
		end)

	CustomGameEventManager:Send_ServerToAllClients("item_will_spawn", {spawn_location = pos})
	EmitGlobalSound("powerup_03")
end

-- Currently only checks stuff for monkey king
function Mutation:IsEligibleHero(hero)	
	if(hero:GetName() == "npc_dota_hero_monkey_king" or hero:GetName() == "npc_dota_hero_rubick") and hero:GetAbsOrigin() ~= Vector(0,0,0) then 
		log.info("fake hero entered the game, ignoring mutation!", hero:GetEntityIndex(), hero:GetName())
		return false
	end

	return true
end
