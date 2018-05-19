-- Editors:
--     Earth Salamander #42

local ITEMS_KV = LoadKeyValues("scripts/npc/npc_items_custom.txt")
local MAP_SIZE = 15000

function Mutation:Init()
--	print("Mutation: Initialize...")

	LinkLuaModifier("modifier_mutation_death_explosion", "modifier/mutation/modifier_mutation_death_explosion.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_kill_streak_power", "modifier/mutation/modifier_mutation_kill_streak_power.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_frantic", "modifier/modifier_frantic.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_no_health_bar", "modifier/mutation/modifier_no_health_bar.lua", LUA_MODIFIER_MOTION_NONE )

	LinkLuaModifier("modifier_mutation_sun_strike", "modifier/mutation/periodic_spellcast/modifier_mutation_sun_strike.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_thundergods_wrath", "modifier/mutation/periodic_spellcast/modifier_mutation_thundergods_wrath.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_track", "modifier/mutation/periodic_spellcast/modifier_mutation_track.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_rupture", "modifier/mutation/periodic_spellcast/modifier_mutation_rupture.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_shadow_dance", "modifier/mutation/modifier_mutation_shadow_dance.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_mutation_ants", "modifier/mutation/modifier_mutation_ants.lua", LUA_MODIFIER_MOTION_NONE )

--	Mutation:ChooseMutation("positive", POSITIVE_MUTATION_LIST, 15 - 1) -- -1 because index is 0
--	Mutation:ChooseMutation("negative", NEGATIVE_MUTATION_LIST, 10 - 1)
--	Mutation:ChooseMutation("terrain", TERRAIN_MUTATION_LIST, 11 - 1)

	Mutation:ChooseMutation("positive", POSITIVE_MUTATION_LIST, 5 - 1) -- -1 because index is 0
	Mutation:ChooseMutation("negative", NEGATIVE_MUTATION_LIST, 5 - 1)
	Mutation:ChooseMutation("terrain", TERRAIN_MUTATION_LIST, 5 - 1)

	IMBA_MUTATION_PERIODIC_SPELLS = {}
	IMBA_MUTATION_PERIODIC_SPELLS[1] = {"sun_strike", "Sunstrike", "Red"}
	IMBA_MUTATION_PERIODIC_SPELLS[2] = {"thundergods_wrath", "Thundergod's Wrath", "Red"}
	IMBA_MUTATION_PERIODIC_SPELLS[3] = {"track", "Track", "Red"}
	IMBA_MUTATION_PERIODIC_SPELLS[4] = {"rupture", "Rupture", "Red"}

--	"cold_feet",
--	"telekinesis",
--	"glimpse",
--	"torrent",

--	"shallow_grave",
--	"false_promise",
--	"bloodrage",
--	"bloodlust",
end

function Mutation:ChooseMutation(type, table, count)
	local i = 0
--	local random_int = RandomInt(0, #table) -- dunno why it doesn't get table length
	local random_int = RandomInt(0, count)

--	print("Mutation: Choose Mutation:", type, random_int)

	for mutation, bool in pairs(table) do
		if i == random_int then
--			print("Mutation:", mutation)
			IMBA_MUTATION[type] = mutation
			table[mutation] = true

			if IsInToolsMode() then
				IMBA_MUTATION["positive"] = "killstreak_power"
				IMBA_MUTATION["negative"] = "stay_frosty"
				IMBA_MUTATION["terrain"] = "gift_exchange"
			end

			return
		else
			i = i + 1
		end
	end
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

		Timers:CreateTimer(3.0, function()
			CustomGameEventManager:Send_ServerToAllClients("send_mutations", IMBA_MUTATION)
		end)
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if IMBA_MUTATION["negative"] == "periodic_spellcast" then
			local random_int = RandomInt(1, #IMBA_MUTATION_PERIODIC_SPELLS)
			local caster = Entities:FindByName(nil, "dota_goodguys_fort")

			Timers:CreateTimer(55.0, function()
				random_int = RandomInt(1, #IMBA_MUTATION_PERIODIC_SPELLS)
				Notifications:TopToAll({text = IMBA_MUTATION_PERIODIC_SPELLS[random_int][2].." Mutation in 5 seconds...", duration = 5.0, {color = IMBA_MUTATION_PERIODIC_SPELLS[random_int][3]}})

				return 60.0
			end)

			Timers:CreateTimer(function()
				for _, hero in pairs(HeroList:GetAllHeroes()) do
					if hero:GetTeamNumber() == 3 then
						caster = Entities:FindByName(nil, "dota_badguys_fort")
					end

					if IMBA_MUTATION_PERIODIC_SPELLS[random_int][1] == "sun_strike" then
						hero:AddNewModifier(caster, nil, "modifier_mutation_sun_strike", {duration=3.0})
					elseif IMBA_MUTATION_PERIODIC_SPELLS[random_int][1] == "thundergods_wrath" then
						hero:AddNewModifier(caster, nil, "modifier_mutation_thundergods_wrath", {duration=1.0})
					elseif IMBA_MUTATION_PERIODIC_SPELLS[random_int][1] == "track" then
						hero:AddNewModifier(caster, nil, "modifier_mutation_track", {duration=20.0})
					elseif IMBA_MUTATION_PERIODIC_SPELLS[random_int][1] == "rupture" then
						hero:AddNewModifier(caster, nil, "modifier_mutation_rupture", {duration=10.0})
					end
				end

				return 60.0
			end)
		end

		if IMBA_MUTATION["terrain"] == "gift_exchange" then
			Timers:CreateTimer(60.0 + RandomInt(1, 60), function()
				Mutation:SpawnRandomItem()

				return 60.0 + RandomInt(1, 60)
			end)
		end

		if IMBA_MUTATION["terrain"] == "minefield" then
			local mines = {
				"npc_imba_techies_proximity_mine",
				"npc_imba_techies_proximity_mine_big_boom",
				"npc_imba_techies_stasis_trap",
			}

			Timers:CreateTimer(function()
				local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)		
				local mine_count = 0
				local max_mine_count = 90

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
						local mine = CreateUnitByName(mines[RandomInt(1, #mines)], Vector(0, 0, 0) + RandomVector(RandomInt(1000, MAP_SIZE)), true, nil, nil, DOTA_TEAM_NEUTRALS)
						mine:AddNewModifier(mine, nil, "modifier_invulnerable", {})
					end
				end

--				print("Mine count:", mine_count)
				return 10.0
			end)
		end
	end
end

function Mutation:OnHeroFirstSpawn(hero)
--	print("Mutation: On Hero Respawned")

	if IMBA_MUTATION["positive"] == "killstreak_power" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_kill_streak_power", {})
	elseif IMBA_MUTATION["positive"] == "frantic" then
		hero:AddNewModifier(hero, nil, "modifier_frantic", {})
	elseif IMBA_MUTATION["positive"] == "jump_start" then
		hero:AddExperience(XP_PER_LEVEL_TABLE[6], DOTA_ModifyXP_CreepKill, false, true)
	end

	if IMBA_MUTATION["negative"] == "death_explosion" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_death_explosion", {})
	elseif IMBA_MUTATION["negative"] == "no_health_bar" then
		hero:AddNewModifier(hero, nil, "modifier_no_health_bar", {})
	elseif IMBA_MUTATION["negative"] == "defense_of_the_ants" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_ants", {})
	elseif IMBA_MUTATION["negative"] == "stay_frosty" then
		hero:AddNewModifier(hero, nil, "modifier_disable_healing", {})
	end
end

function Mutation:OnHeroSpawn(hero)
--	print("Mutation: On Hero Respawned")

	if IMBA_MUTATION["positive"] == "damage_reduction" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_damage_reduction", {})
	elseif IMBA_MUTATION["positive"] == "slark_mode" then
		hero:AddNewModifier(hero, nil, "modifier_mutation_shadow_dance", {})
	end

	if IMBA_MUTATION["negative"] == "stay_frosty" then
		hero:AddNewModifier(hero, nil, "modifier_ice_blast", {})
	end

	if IMBA_MUTATION["terrain"] == "sleepy_river" then
		hero:AddNewModifier(hero, nil, "modifier_river", {})
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
	end

	if IMBA_MUTATION["negative"] == "death_gold_drop" then
		local game_time = math.min(GameRules:GetDOTATime(false, false) / 60, 30)
		local random_int = RandomInt(30, 60)
		local newItem = CreateItem("item_bag_of_gold", nil, nil)
		newItem:SetPurchaseTime(0)
		print(game_time, random_int)
		newItem:SetCurrentCharges(random_int * game_time)

		local drop = CreateItemOnPositionSync(hero:GetAbsOrigin(), newItem)
		local dropTarget = hero:GetAbsOrigin() + RandomVector(RandomFloat( 50, 150 ))
		newItem:LaunchLoot(true, 300, 0.75, dropTarget)
		EmitSoundOn("Dungeon.TreasureItemDrop", hero)
	end
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
	local item_name
	local random_int = RandomInt(1, 190)
	local i = 1

	for k, v in pairs(ITEMS_KV) do
		if random_int == i then
			print("Map max bounds:", MAP_SIZE / 2.3)
			print(random_int, k, v["ItemCost"])

			if v["ItemCost"] < 1000 or string.find(k, "recipe") then
				return Mutation:SpawnRandomItem()
			end

			AddFOWViewer(2, pos, 250, 20.0, false)
			AddFOWViewer(3, pos, 250, 20.0, false)

			CustomGameEventManager:Send_ServerToAllClients("item_will_spawn", {spawn_location = pos})
			EmitGlobalSound("powerup_03")

			Timers:CreateTimer(10.0, function()
				print("Item Name:", k)
				local item = CreateItem(k, nil, nil)
				local pos = Vector(RandomInt(1000, MAP_SIZE / 2.3), RandomInt(1000, MAP_SIZE / 2.3), 0)
				print(pos)

				GridNav:DestroyTreesAroundPoint(pos, 80, false)
				local drop = CreateItemOnPositionSync(pos, item)
--				EmitSoundOn("Dungeon.TreasureItemDrop", hero)
			end)

			return
		end

		i = i + 1
	end
end
