require('components/mutation/mutation_list')
require('components/mutation/mutation_settings')

local validItems = {} -- Empty table to fill with full list of valid airdrop items
local tier1 = {} -- 1000 to 2000 gold cost up to 5 minutes
local tier2 = {} -- 2000 to 3500 gold cost up to 10 minutes
local tier3 = {} -- 3500 to 5000 gold cost up to 15 minutes
local tier4 = {} -- 5000 to 99998 gold cost beyond 15 minutes
local counter = 1 -- Slowly increments as time goes on to expand list of cost-valid items
local varFlag = 0 -- Flag to stop the repeat until loop for tier iterations

function Mutation:Init()
	-- Selecting Mutations (Take out if statement for IsInToolsMode if you want to test randomized)

	IMBA_MUTATION["imba"] = "frantic"

	if IsInToolsMode() then
		IMBA_MUTATION["positive"] = "teammate_resurrection"
		IMBA_MUTATION["negative"] = "periodic_spellcast"
		IMBA_MUTATION["terrain"] = "tug_of_war"
	else
		Mutation:ChooseMutation("positive", POSITIVE_MUTATION_LIST)
		Mutation:ChooseMutation("negative", NEGATIVE_MUTATION_LIST)
		Mutation:ChooseMutation("terrain", TERRAIN_MUTATION_LIST)
	end

	CustomNetTables:SetTableValue("mutations", "mutation", {IMBA_MUTATION})

--	if IMBA_MUTATION["positive"] == "greed_is_good" then
--		LinkLuaModifier("modifier_mutation_greed_is_good", "components/modifiers/mutation/modifier_mutation_greed_is_good.lua", LUA_MODIFIER_MOTION_NONE )
--	end
	if IMBA_MUTATION["positive"] == "killstreak_power" then
		LinkLuaModifier("modifier_mutation_kill_streak_power", "components/modifiers/mutation/modifier_mutation_kill_streak_power.lua", LUA_MODIFIER_MOTION_NONE )
	elseif IMBA_MUTATION["positive"] == "slark_mode" then
		LinkLuaModifier("modifier_mutation_shadow_dance", "components/modifiers/mutation/modifier_mutation_shadow_dance.lua", LUA_MODIFIER_MOTION_NONE )
	elseif IMBA_MUTATION["positive"] == "super_fervor" then
		LinkLuaModifier("modifier_mutation_super_fervor", "components/modifiers/mutation/modifier_mutation_super_fervor.lua", LUA_MODIFIER_MOTION_NONE )
	end

--	if IMBA_MUTATION["negative"] == "alien_incubation" then
--		LinkLuaModifier("modifier_mutation_alien_incubation", "components/modifiers/mutation/modifier_mutation_alien_incubation.lua", LUA_MODIFIER_MOTION_NONE )
	if IMBA_MUTATION["negative"] == "all_random_deathmatch" then
		require('components/mutation/mutators/negative/ardm')
	elseif IMBA_MUTATION["negative"] == "death_explosion" then
		LinkLuaModifier("modifier_mutation_death_explosion", "components/modifiers/mutation/modifier_mutation_death_explosion.lua", LUA_MODIFIER_MOTION_NONE )
	elseif IMBA_MUTATION["negative"] == "defense_of_the_ants" then
		LinkLuaModifier("modifier_mutation_ants", "components/modifiers/mutation/modifier_mutation_ants.lua", LUA_MODIFIER_MOTION_NONE )
	elseif IMBA_MUTATION["negative"] == "monkey_business" then
		LinkLuaModifier("modifier_mutation_monkey_business", "components/modifiers/mutation/modifier_mutation_monkey_business.lua", LUA_MODIFIER_MOTION_NONE )
	elseif IMBA_MUTATION["negative"] == "no_health_bar" then
		LinkLuaModifier("modifier_no_health_bar", "components/modifiers/mutation/modifier_no_health_bar.lua", LUA_MODIFIER_MOTION_NONE )
	elseif IMBA_MUTATION["negative"] == "periodic_spellcast" then
		LinkLuaModifier("modifier_mutation_thundergods_wrath", "components/modifiers/mutation/periodic_spellcast/modifier_mutation_thundergods_wrath.lua", LUA_MODIFIER_MOTION_NONE )
		LinkLuaModifier("modifier_mutation_track", "components/modifiers/mutation/periodic_spellcast/modifier_mutation_track.lua", LUA_MODIFIER_MOTION_NONE )
		LinkLuaModifier("modifier_mutation_rupture", "components/modifiers/mutation/periodic_spellcast/modifier_mutation_rupture.lua", LUA_MODIFIER_MOTION_NONE )
		LinkLuaModifier("modifier_mutation_torrent", "components/modifiers/mutation/periodic_spellcast/modifier_mutation_torrent.lua", LUA_MODIFIER_MOTION_NONE )
		LinkLuaModifier("modifier_mutation_cold_feet", "components/modifiers/mutation/periodic_spellcast/modifier_mutation_cold_feet.lua", LUA_MODIFIER_MOTION_NONE )
		LinkLuaModifier("modifier_mutation_stampede", "components/modifiers/mutation/periodic_spellcast/modifier_mutation_stampede.lua", LUA_MODIFIER_MOTION_NONE )
		LinkLuaModifier("modifier_mutation_bloodlust", "components/modifiers/mutation/periodic_spellcast/modifier_mutation_bloodlust.lua", LUA_MODIFIER_MOTION_NONE )
		LinkLuaModifier("modifier_mutation_aphotic_shield", "components/modifiers/mutation/periodic_spellcast/modifier_mutation_aphotic_shield.lua", LUA_MODIFIER_MOTION_NONE )
		LinkLuaModifier("modifier_mutation_sun_strike", "components/modifiers/mutation/periodic_spellcast/modifier_mutation_sun_strike.lua", LUA_MODIFIER_MOTION_NONE )
--	elseif IMBA_MUTATION["negative"] == "stay_frosty" then
--		LinkLuaModifier("modifier_disable_healing", "components/modifiers/mutation/modifier_disable_healing.lua", LUA_MODIFIER_MOTION_NONE )
--		LinkLuaModifier("modifier_mutation_stay_frosty", "components/modifiers/mutation/modifier_mutation_stay_frosty.lua", LUA_MODIFIER_MOTION_NONE )
	end

	if IMBA_MUTATION["terrain"] == "danger_zone" then
		LinkLuaModifier("modifier_mutation_danger_zone", "components/modifiers/mutation/modifier_mutation_danger_zone.lua", LUA_MODIFIER_MOTION_NONE )
	elseif IMBA_MUTATION["terrain"] == "river_flows" then
		LinkLuaModifier("modifier_mutation_river_flows", "components/modifiers/mutation/modifier_mutation_river_flows.lua", LUA_MODIFIER_MOTION_NONE )
	elseif IMBA_MUTATION["terrain"] == "speed_freaks" then
		LinkLuaModifier("modifier_mutation_speed_freaks", "components/modifiers/mutation/modifier_mutation_speed_freaks.lua", LUA_MODIFIER_MOTION_NONE )
	elseif IMBA_MUTATION["terrain"] == "sticky_river" then
		LinkLuaModifier("modifier_sticky_river", "components/modifiers/mutation/modifier_sticky_river.lua", LUA_MODIFIER_MOTION_NONE )
	elseif IMBA_MUTATION["terrain"] == "tug_of_war" then
		LinkLuaModifier("modifier_mutation_tug_of_war_golem", "components/modifiers/mutation/modifier_mutation_tug_of_war_golem.lua", LUA_MODIFIER_MOTION_NONE )
	elseif IMBA_MUTATION["terrain"] == "wormhole" then
		LinkLuaModifier("modifier_mutation_wormhole_cooldown", "components/modifiers/mutation/modifier_mutation_wormhole_cooldown.lua", LUA_MODIFIER_MOTION_NONE )
	end
end

function Mutation:Precache(context)
--	if IMBA_MUTATION["positive"] == "killstreak_power" then
		PrecacheResource("particle", "particles/hw_fx/candy_carrying_stack.vpcf", context)
--	elseif IMBA_MUTATION["positive"] == "super_fervor" then
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_troll_warlord.vsndevts", context)
--	end

--	if IMBA_MUTATION["negative"] == "death_explosion" then
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts", context)
--	elseif IMBA_MUTATION["negative"] == "death_gold_drop" then
--		PrecacheItemByNameSync("item_bag_of_gold", context)
--	elseif IMBA_MUTATION["negative"] == "monkey_business" then
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_monkey_king.vsndevts", context)
--	elseif IMBA_MUTATION["negative"] == "periodic_spellcast" then
		PrecacheResource("particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_bolt_parent.vpcf", context) -- Thundergod's Wrath
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context) -- Shield
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts", context) -- Cold Feet
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_bloodseeker.vsndevts", context) -- Rupture
--		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_bounty_hunter.vsndevts", context) -- Track
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts", context) -- Stampede
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts", context) -- Torrent
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context) -- Bloodlust
--		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts", context)
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context) -- Thundergod's Wrath
--	end

--	if IMBA_MUTATION["terrain"] == "danger_zone" then
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)
--	elseif IMBA_MUTATION["terrain"] == "tug_of_war" then
		PrecacheResource("particle", "particles/ambient/tug_of_war_team_dire.vpcf", context)
		PrecacheResource("particle", "particles/ambient/tug_of_war_team_radiant.vpcf", context)
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts", context) -- BOB Golem
--	elseif IMBA_MUTATION["terrain"] == "wormhole" then
		PrecacheResource("particle", "particles/ambient/wormhole_circle.vpcf", context)
--	end
end

function Mutation:ChooseMutation(mType, mList)
	-- Pick a random number within bounds of given mutation list	
	local random_int = RandomInt(1, #mList)
	-- Select a mutation from within that list and place it in the relevant IMBA_MUTATION field
	IMBA_MUTATION[mType] = mList[random_int]
	--print("IMBA_MUTATION["..mType.."] mutation picked: ", mList[random_int])
end

-- Mutation: Events
ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		Mutation:Init()
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		if IMBA_MUTATION["negative"] == "all_random_deathmatch" then
			Mutation:ARDM()
		end

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

		Mutation:UpdatePanorama()
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
			local caster

			-- initialize to negative
			CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["negative"], {0})

			Timers:CreateTimer(55.0, function()
				varSwap = (counter % 2) + 1
				random_int = RandomInt(1, #IMBA_MUTATION_PERIODIC_SPELLS[varSwap])
				Notifications:TopToAll({text = IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][2].." Mutation in 5 seconds...", duration = 5.0, style = {color = IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][3]}})

				return 60.0
			end)

			Timers:CreateTimer(60.0, function()
				CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["negative"], {varSwap})
				if bad_fountain == nil or good_fountain == nil then
					print("nao cucekd up!!! ")
					return 60.0 
				end

				for _, hero in pairs(HeroList:GetAllHeroes()) do
					if (hero:GetTeamNumber() == 3 and IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][3] == "Red") or (hero:GetTeamNumber() == 2 and IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][3] == "Green") then
						caster = good_fountain
					else
					    caster = bad_fountain
					end

					hero:AddNewModifier(caster, caster, "modifier_mutation_"..IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][1], {duration=IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][4]})
				end
				counter = counter + 1

				return 60.0
			end)
		end

		if IMBA_MUTATION["terrain"] == "airdrop" then
			for k, v in pairs(KeyValues.ItemKV) do -- Go through all the items in KeyValues.ItemKV and store valid items in validItems table
				varFlag = 0 -- Let's borrow this memory to suss out the forbidden items first...

				if v["ItemCost"] and v["ItemCost"] >= IMBA_MUTATION_AIRDROP_ITEM_MINIMUM_GOLD_COST and v["ItemCost"] ~= 99999 and not string.find(k, "recipe") and not string.find(k, "cheese") then
					for _, item in pairs(IMBA_MUTATION_RESTRICTED_ITEMS) do -- Make sure item isn't a restricted item
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
				if validItems[counter].v <= IMBA_MUTATION_AIRDROP_ITEM_TIER_1_GOLD_COST then
					tier1[#tier1 + 1] = {k = validItems[counter].k, v = validItems[counter].v}
					counter = counter + 1
				else
					varFlag = 1
				end
			until varFlag == 1

			varFlag = 0

			-- Create Tier 2 Table
			repeat
				if validItems[counter].v <= IMBA_MUTATION_AIRDROP_ITEM_TIER_2_GOLD_COST then
					tier2[#tier2 + 1] = {k = validItems[counter].k, v = validItems[counter].v}
					counter = counter + 1
				else
					varFlag = 1
				end
			until varFlag == 1

			varFlag = 0

			-- Create Tier 3 Table
			repeat
				if validItems[counter].v <= IMBA_MUTATION_AIRDROP_ITEM_TIER_3_GOLD_COST then
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

		if IMBA_MUTATION["terrain"] == "danger_zone" then
			local dummy_unit = CreateUnitByName("npc_dummy_unit_perma", Vector(0, 0, 0), true, nil, nil, DOTA_TEAM_NEUTRALS)
			dummy_unit:AddNewModifier(dummy_unit, nil, "modifier_mutation_danger_zone", {})
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
								unit:CenterCameraOnEntity(unit)
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
						local mine = CreateUnitByName(mines[RandomInt(1, #mines)], RandomVector(IMBA_MUTATION_MINEFIELD_MAP_SIZE), true, nil, nil, DOTA_TEAM_NEUTRALS)
						mine:AddNewModifier(mine, nil, "modifier_invulnerable", {})
					end
				end

--				print("Mine count:", mine_count)
				return 10.0
			end)
		end
		]]
	end
end, nil)

function Mutation:OnReconnect(id)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "send_mutations", IMBA_MUTATION)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "update_mutations", {})
end

function Mutation:OnHeroFirstSpawn(hero)
	print("Mutation: On Hero First Spawn")

	-- Check if we can add modifiers to hero
	if not Mutation:IsEligibleHero(hero) then return end

	if IMBA_MUTATION["positive"] == "killstreak_power" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_kill_streak_power", {})
	elseif IMBA_MUTATION["positive"] == "super_blink" then
		if not hero:IsIllusion() and not hero:IsClone() then
			hero:AddItemByName("item_imba_blink"):SetSellable(false)
		end
	elseif IMBA_MUTATION["positive"] == "pocket_roshan" then
		if not hero:IsIllusion() and not hero:IsClone() then
			hero:AddItemByName("item_pocket_roshan")
		end
	elseif IMBA_MUTATION["positive"] == "pocket_tower" then
		if not hero:IsIllusion() and not hero:IsClone() then
			hero:AddItemByName("item_pocket_tower")
		end
	elseif IMBA_MUTATION["positive"] == "greed_is_good" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_greed_is_good", {})
	elseif IMBA_MUTATION["positive"] == "teammate_resurrection" then
		hero.reincarnation = false
	elseif IMBA_MUTATION["positive"] == "super_fervor" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_super_fervor", {})
	elseif IMBA_MUTATION["positive"] == "slark_mode" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_shadow_dance", {})
--	elseif IMBA_MUTATION["positive"] == "damage_reduction" then
--		hero:AddNewModifier(hero, nil, "modifier_mutation_damage_reduction", {})
	end

	if IMBA_MUTATION["negative"] == "death_explosion" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_death_explosion", {})
	elseif IMBA_MUTATION["negative"] == "no_health_bar" then
		hero:AddNewModifier(hero, nil, "modifier_no_health_bar", {})
	elseif IMBA_MUTATION["negative"] == "defense_of_the_ants" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_ants", {})
	elseif IMBA_MUTATION["negative"] == "stay_frosty" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_stay_frosty", {})
	elseif IMBA_MUTATION["negative"] == "monkey_business" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_monkey_business", {})
	elseif IMBA_MUTATION["negative"] == "alien_incubation" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_alien_incubation", {})
	end

	if IMBA_MUTATION["terrain"] == "speed_freaks" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_speed_freaks", {projectile_speed = IMBA_MUTATION_SPEED_FREAKS_PROJECTILE_SPEED, movespeed_pct = _G.IMBA_MUTATION_SPEED_FREAKS_MOVESPEED_PCT, max_movespeed = IMBA_MUTATION_SPEED_FREAKS_MAX_MOVESPEED})
	elseif IMBA_MUTATION["terrain"] == "river_flows" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_river_flows", {})
	end
end

function Mutation:OnHeroSpawn(hero)
	print("Mutation: On Hero Respawned")

	-- Check if we can add modifiers to hero
	if not Mutation:IsEligibleHero(hero) then return end

	if IMBA_MUTATION["negative"] == "all_random_deathmatch" then
		if not hero:IsImbaReincarnating() then
			Mutation:ARDMReplacehero(hero)
		return
		else
			print("hero is reincarnating, don't change hero!")
			return
		end
	end

	if IMBA_MUTATION["positive"] == "teammate_resurrection" then
		if hero.tombstone_fx then
			ParticleManager:DestroyParticle(hero.tombstone_fx, false)
			ParticleManager:ReleaseParticleIndex(hero.tombstone_fx)
			hero.tombstone_fx = nil
		end

		Timers:CreateTimer(FrameTime(), function()
			if IsNearFountain(hero:GetAbsOrigin(), 1200) == false and hero.reincarnation == false and not hero:IsTempestDouble() then
				hero:SetHealth(hero:GetHealth() * 50 / 100)
				hero:SetMana(hero:GetMana() * 50 / 100)
			end

			hero:CenterCameraOnEntity(hero)

			hero.reincarnation = false
		end)
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

		if hero:IsImbaReincarnating() then
			print("Hero is reincarnating!")
			hero.reincarnation = true
		end
	end

	if IMBA_MUTATION["negative"] == "all_random_deathmatch" then
		if hero:IsImbaReincarnating() then print("hero is reincarnating, don't count down respawn count!") return end
		IMBA_MUTATION_ARDM_RESPAWN_SCORE[hero:GetTeamNumber()] = IMBA_MUTATION_ARDM_RESPAWN_SCORE[hero:GetTeamNumber()] - 1

		if IMBA_MUTATION_ARDM_RESPAWN_SCORE[hero:GetTeamNumber()] < 0 then
			IMBA_MUTATION_ARDM_RESPAWN_SCORE[hero:GetTeamNumber()] = 0
		end

		if IMBA_MUTATION_ARDM_RESPAWN_SCORE[hero:GetTeamNumber()] == 0 then
			print("hero respawn disabled!")
			hero:SetRespawnsDisabled(true)
			hero:SetTimeUntilRespawn(-1)

			local end_game = true
			Timers:CreateTimer(1.0, function()
				for _, alive_hero in pairs(HeroList:GetAllHeroes()) do
					if hero:GetTeamNumber() == alive_hero:GetTeamNumber() then
						if alive_hero:IsAlive() then
							print("A hero is still alive!")
							end_game = false
							break
						end
					end
				end

				-- if everyone is dead, end the game
				if end_game == true then
					if hero:GetTeamNumber() == 2 then
						GAME_WINNER_TEAM = 3
						GameRules:SetGameWinner(3)
					elseif hero:GetTeamNumber() == 3 then
						GAME_WINNER_TEAM = 2
						GameRules:SetGameWinner(2)
					end
				end
			end)
		end

		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["negative"], {IMBA_MUTATION_ARDM_RESPAWN_SCORE[2], IMBA_MUTATION_ARDM_RESPAWN_SCORE[3]})
		CustomGameEventManager:Send_ServerToAllClients("update_mutations", {})
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

function Mutation:OnUnitFirstSpawn(unit)
	if IMBA_MUTATION["terrain"] == "speed_freaks" then
		unit:AddNewModifier(unit, nil, "modifier_mutation_speed_freaks", {projectile_speed = IMBA_MUTATION_SPEED_FREAKS_PROJECTILE_SPEED, movespeed_pct = _G.IMBA_MUTATION_SPEED_FREAKS_MOVESPEED_PCT, max_movespeed = IMBA_MUTATION_SPEED_FREAKS_MAX_MOVESPEED})
	end
end

function Mutation:OnUnitSpawn(hero)
--	print("Mutation: On Unit Respawned")
end

function Mutation:OnUnitDeath(unit)
	if IMBA_MUTATION["terrain"] == "tug_of_war" then
		if unit:GetUnitName() == "npc_dota_mutation_golem" then
			IMBA_MUTATION_TUG_OF_WAR_DEATH_COUNT = IMBA_MUTATION_TUG_OF_WAR_DEATH_COUNT + 1
			CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["terrain"], {IMBA_MUTATION_TUG_OF_WAR_DEATH_COUNT})
			CustomGameEventManager:Send_ServerToAllClients("update_mutations", {})
		end
	end
end

function Mutation:OnThink()
--	print("Mutation: On Think")

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if IMBA_MUTATION["terrain"] == "airdrop" or IMBA_MUTATION["terrain"] == "danger_zone" then
			Mutation:MutationTimer()
		end
	end
end

function Mutation:OnSlowThink() -- 60 seconds
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if IMBA_MUTATION["negative"] == "death_explosion" then
			Mutation:DeathExplosionDamage()
		end
	end
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

	if GameRules:GetDOTATime(false, false) > IMBA_MUTATION_AIRDROP_ITEM_TIER_3_MINUTES * 60 then
		selectedItem = tier4[RandomInt(1, #tier4)].k
	elseif GameRules:GetDOTATime(false, false) > IMBA_MUTATION_AIRDROP_ITEM_TIER_2_MINUTES * 60 then
		selectedItem = tier3[RandomInt(1, #tier3)].k
	elseif GameRules:GetDOTATime(false, false) > IMBA_MUTATION_AIRDROP_ITEM_TIER_1_MINUTES * 60 then
		selectedItem = tier2[RandomInt(1, #tier2)].k
	else
		selectedItem = tier1[RandomInt(1, #tier1)].k
	end

	local pos = RandomVector(IMBA_MUTATION_AIRDROP_MAP_SIZE)
	AddFOWViewer(2, pos, IMBA_MUTATION_AIRDROP_ITEM_SPAWN_RADIUS, IMBA_MUTATION_AIRDROP_ITEM_SPAWN_DELAY + IMBA_MUTATION_AIRDROP_ITEM_VISION_LINGER, false)
	AddFOWViewer(3, pos, IMBA_MUTATION_AIRDROP_ITEM_SPAWN_RADIUS, IMBA_MUTATION_AIRDROP_ITEM_SPAWN_DELAY + IMBA_MUTATION_AIRDROP_ITEM_VISION_LINGER, false)
	GridNav:DestroyTreesAroundPoint(pos, IMBA_MUTATION_AIRDROP_ITEM_SPAWN_RADIUS, false)

	local particle_dummy = CreateUnitByName("npc_dummy_unit", pos, true, nil, nil, 6)
	local particle_arena_fx = ParticleManager:CreateParticle("particles/hero/centaur/centaur_hoof_stomp_arena.vpcf", PATTACH_ABSORIGIN_FOLLOW, particle_dummy)
	ParticleManager:SetParticleControl(particle_arena_fx, 0, pos)
	ParticleManager:SetParticleControl(particle_arena_fx, 1, Vector(IMBA_MUTATION_AIRDROP_ITEM_SPAWN_RADIUS + 45, 1, 1))

	local particle = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_timer.vpcf", PATTACH_ABSORIGIN_FOLLOW, particle_dummy)
	ParticleManager:SetParticleControl(particle, 1, Vector(IMBA_MUTATION_AIRDROP_ITEM_SPAWN_DELAY, 0, 0))
	ParticleManager:SetParticleControl(particle, 3, pos)
	ParticleManager:ReleaseParticleIndex(particle)

	Timers:CreateTimer(IMBA_MUTATION_AIRDROP_ITEM_SPAWN_DELAY, function()
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
	if hero:HasModifier("modifier_monkey_king_fur_army_soldier") or hero:HasModifier("modifier_monkey_king_fur_army_soldier_hidden") then 
--		print("fake hero entered the game, ignoring mutation!", hero:GetEntityIndex(), hero:GetName())
		return false
	end

	return true
end

function Mutation:UpdatePanorama()
	local var_swap = 1

	-- unique update
--	if IMBA_MUTATION["imba"] == "frantic" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["imba"], {IMBA_FRANTIC_VALUE, "%"})
--	end

	if IMBA_MUTATION["positive"] == "killstreak_power" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["positive"], {_G.IMBA_MUTATION_KILLSTREAK_POWER, "%"})
	elseif IMBA_MUTATION["positive"] == "slark_mode" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["positive"], {_G.IMBA_MUTATION_SLARK_MODE_HEALTH_REGEN, _G.IMBA_MUTATION_SLARK_MODE_MANA_REGEN})
	elseif IMBA_MUTATION["positive"] == "ultimate_level" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["positive"], {IMBA_MUTATION_ULTIMATE_LEVEL})
	end

	if IMBA_MUTATION["negative"] == "death_explosion" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["negative"], {_G.IMBA_MUTATION_DEATH_EXPLOSION_DAMAGE})
	elseif IMBA_MUTATION["negative"] == "defense_of_the_ants" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["negative"], {_G.IMBA_MUTATION_DEFENSE_OF_THE_ANTS_SCALE, "%"})
	elseif IMBA_MUTATION["negative"] == "monkey_business" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["negative"], {_G.IMBA_MUTATION_MONKEY_BUSINESS_DELAY, "s"})
	elseif IMBA_MUTATION["negative"] == "all_random_deathmatch" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["negative"], {IMBA_MUTATION_ARDM_RESPAWN_SCORE[2], IMBA_MUTATION_ARDM_RESPAWN_SCORE[3]})
	end

	-- shows undefined on panorama for reasons
--	if IMBA_MUTATION["terrain"] == "airdrop" then
--		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["terrain"], {IMBA_MUTATION_AIRDROP_TIMER})
--	elseif IMBA_MUTATION["terrain"] == "danger_zone" then
--		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["terrain"], {IMBA_MUTATION_DANGER_ZONE_TIMER})
--	elseif IMBA_MUTATION["terrain"] == "fast_runes" then
	if IMBA_MUTATION["terrain"] == "fast_runes" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["terrain"], {RUNE_SPAWN_TIME, BOUNTY_RUNE_SPAWN_TIME})
	elseif IMBA_MUTATION["terrain"] == "river_flows" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["terrain"], {_G.IMBA_MUTATION_RIVER_FLOWS_MOVESPEED})
	elseif IMBA_MUTATION["terrain"] == "speed_freaks" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["terrain"], {_G.IMBA_MUTATION_SPEED_FREAKS_MOVESPEED_PCT, "%"})
	elseif IMBA_MUTATION["terrain"] == "tug_of_war" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["terrain"], {IMBA_MUTATION_TUG_OF_WAR_DEATH_COUNT})
	end

	CustomGameEventManager:Send_ServerToAllClients("update_mutations", {})
end

function Mutation:DeathExplosionDamage()
	local damage = _G.IMBA_MUTATION_DEATH_EXPLOSION_DAMAGE
	local game_time = math.min(GameRules:GetDOTATime(false, false) / 60, _G.IMBA_MUTATION_DEATH_EXPLOSION_MAX_MINUTES)

	game_time = game_time * _G.IMBA_MUTATION_DEATH_EXPLOSION_DAMAGE_INCREASE_PER_MIN
	CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["negative"], {damage + game_time})
	CustomGameEventManager:Send_ServerToAllClients("update_mutations", {})
end

function Mutation:MutationTimer()
	if IMBA_MUTATION_TIMER == nil then
		if IMBA_MUTATION["terrain"] == "danger_zone" then
			IMBA_MUTATION_TIMER = IMBA_MUTATION_DANGER_ZONE_TIMER
		elseif IMBA_MUTATION["terrain"] == "airdrop" then
			IMBA_MUTATION_TIMER = IMBA_MUTATION_AIRDROP_TIMER
		end
	end

	IMBA_MUTATION_TIMER = IMBA_MUTATION_TIMER - 1

	if IMBA_MUTATION_TIMER == 10 then
		if IMBA_MUTATION["terrain"] == "airdrop" then
			CustomGameEventManager:Send_ServerToAllClients("timer_alert", {true})
		end
	elseif IMBA_MUTATION_TIMER == 0 then
		if IMBA_MUTATION["terrain"] == "danger_zone" then
			IMBA_MUTATION_TIMER = IMBA_MUTATION_DANGER_ZONE_TIMER - 1
		elseif IMBA_MUTATION["terrain"] == "airdrop" then
			IMBA_MUTATION_TIMER = IMBA_MUTATION_AIRDROP_TIMER - 1
			CustomGameEventManager:Send_ServerToAllClients("timer_alert", {false})
		end
	end

	local t = IMBA_MUTATION_TIMER
	local minutes = math.floor(t / 60)
	local seconds = t - (minutes * 60)
	local m10 = math.floor(minutes / 10)
	local m01 = minutes - (m10 * 10)
	local s10 = math.floor(seconds / 10)
	local s01 = seconds - (s10 * 10)
	local broadcast_gametimer = 
	{
		timer_minute_10 = m10,
		timer_minute_01 = m01,
		timer_second_10 = s10,
		timer_second_01 = s01,
	}

	CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["terrain"], broadcast_gametimer)
	CustomGameEventManager:Send_ServerToAllClients("update_mutations", {})
end
