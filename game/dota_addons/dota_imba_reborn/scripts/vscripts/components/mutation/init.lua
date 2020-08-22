if Mutation == nil then
	Mutation = class({})

	IMBA_MUTATION = {}
	IMBA_MUTATION["positive"] = ""
	IMBA_MUTATION["negative"] = ""
	IMBA_MUTATION["terrain"] = ""
end

ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		Timers:CreateTimer(0.5, function()
			if api:GetCustomGamemode() ~= 2 then return end

			require('components/mutation/util')
			require('components/mutation/events')
			require('components/mutation/mutation')
			require('components/mutation/mutation_list')
			require('components/mutation/mutation_settings')

			Mutation:Init()

--			if IMBA_MUTATION["negative"] == "all_random_deathmatch" then
--				Mutation:ARDM()
--			end
		end)
	end

	if GameRules:State_Get() > DOTA_GAMERULES_STATE_HERO_SELECTION then
		if api:GetCustomGamemode() ~= 2 then return end
	end

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		Timers:CreateTimer(function()
			Mutation:OnThink()

			return 1.0
		end)

		Timers:CreateTimer(function()
			Mutation:OnSlowThink()

			return 60.0
		end)

		if IMBA_MUTATION["positive"] == "ultimate_level" then
			GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)

			MAX_LEVEL[GetMapName()] = IMBA_MUTATION_ULTIMATE_LEVEL
			CustomNetTables:SetTableValue("game_options", "max_level", {MAX_LEVEL[GetMapName()]})

			-- IMBA: Custom maximum level EXP tables adjustment
			local max_level = tonumber(CustomNetTables:GetTableValue("game_options", "max_level")["1"])

			if max_level and max_level > 30 then
				local j = 31

				Timers:CreateTimer(function()
					if j >= max_level then
						return
					end

					for i = j, math.min(j + 2, max_level) do
						XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i - 1] + 7500
						GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(XP_PER_LEVEL_TABLE)
					end

					j = j + 2

					return 1.0
				end)
			end
		end

		if IMBA_MUTATION["terrain"] == "no_trees" then
			Mutation:NoTrees()
		elseif IMBA_MUTATION["terrain"] == "omni_vision" then
			Mutation:RevealAllMap()
		elseif IMBA_MUTATION["terrain"] == "fast_runes" then
			RUNE_SPAWN_TIME = 30.0
			BOUNTY_RUNE_SPAWN_TIME = 60.0
		end

		Mutation:UpdatePanorama()

		Timers:CreateTimer(3.0, function()
			CustomGameEventManager:Send_ServerToAllClients("send_mutations", IMBA_MUTATION)
		end)
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if IMBA_MUTATION["negative"] == "periodic_spellcast" then
			Mutation:PeriodicSpellcast()
		end

		if IMBA_MUTATION["terrain"] == "airdrop" then
			Mutation:Airdrop()
		elseif IMBA_MUTATION["terrain"] == "danger_zone" then
			Mutation:DangerZone()
		elseif IMBA_MUTATION["terrain"] == "wormhole" then
			Mutation:Wormhole()
		elseif IMBA_MUTATION["terrain"] == "tug_of_war" then
			Mutation:TugOfWar()
		elseif IMBA_MUTATION["terrain"] == "minefield" then
			Mutation:Minefield()
		end
	end
end, nil)

function Mutation:Init()
	-- Selecting Mutations (Take out if statement for IsInToolsMode if you want to test randomized)

	IMBA_MUTATION["imba"] = "frantic"

	if IsInToolsMode() then
		-- IMBA_MUTATION["positive"] = "ultimate_level"
		-- IMBA_MUTATION["negative"] = "monkey_business"
		-- IMBA_MUTATION["terrain"] = "river_flows"

		Mutation:ChooseMutation("positive", POSITIVE_MUTATION_LIST)
		Mutation:ChooseMutation("negative", NEGATIVE_MUTATION_LIST)
		Mutation:ChooseMutation("terrain", TERRAIN_MUTATION_LIST)
	else
		Mutation:ChooseMutation("positive", POSITIVE_MUTATION_LIST)
		Mutation:ChooseMutation("negative", NEGATIVE_MUTATION_LIST)
		Mutation:ChooseMutation("terrain", TERRAIN_MUTATION_LIST)
	end

--	if IsInToolsMode() then
--		print("Mutations:")
--		print(IMBA_MUTATION)
--	end

	CustomNetTables:SetTableValue("mutations", "mutation", {IMBA_MUTATION})

	if IMBA_PICK_SCREEN == false then
		Timers:CreateTimer(3.0, function()
			CustomGameEventManager:Send_ServerToAllClients("send_mutations", IMBA_MUTATION)
		end)
	end

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
	elseif IMBA_MUTATION["terrain"] == "hyper_blink" then
		LinkLuaModifier("modifier_mutation_hyper_blink", "components/modifiers/mutation/modifier_mutation_hyper_blink", LUA_MODIFIER_MOTION_NONE )
	end
end

function Mutation:ChooseMutation(mType, mList)
	-- Pick a random number within bounds of given mutation list	
	local random_int = RandomInt(1, #mList)
	-- Select a mutation from within that list and place it in the relevant IMBA_MUTATION field
	IMBA_MUTATION[mType] = mList[random_int]
	--print("IMBA_MUTATION["..mType.."] mutation picked: ", mList[random_int])
end

-- Can no longer precache because mutation mod is chosen too lately in loading screen
--[[
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
--]]

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
