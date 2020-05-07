NEUTRAL_CREEPS_START_TIME = 30.0
NEUTRAL_CREEPS_SPAWN_INTERVAL = 60.0

Neutrals.Creeps = {}
Neutrals.Creeps["small"] = {}
Neutrals.Creeps["small"][1] = {"npc_dota_neutral_harpy_scout", "npc_dota_neutral_harpy_scout", "npc_dota_neutral_harpy_storm"}
Neutrals.Creeps["small"][2] = {"npc_dota_neutral_fel_beast", "npc_dota_neutral_fel_beast", "npc_dota_neutral_ghost"}
Neutrals.Creeps["small"][3] = {"npc_dota_neutral_forest_troll_berserker", "npc_dota_neutral_forest_troll_berserker", "npc_dota_neutral_kobold_taskmaster"}
Neutrals.Creeps["small"][4] = {"npc_dota_neutral_gnoll_assassin", "npc_dota_neutral_gnoll_assassin", "npc_dota_neutral_gnoll_assassin"}
Neutrals.Creeps["small"][5] = {"npc_dota_neutral_forest_troll_berserker", "npc_dota_neutral_forest_troll_berserker", "npc_dota_neutral_forest_troll_high_priest"}
Neutrals.Creeps["small"][6] = {"npc_dota_neutral_kobold_taskmaster", "npc_dota_neutral_kobold_tunneler", "npc_dota_neutral_kobold", "npc_dota_neutral_kobold", "npc_dota_neutral_kobold"}

Neutrals.Creeps["medium"] = {}

Neutrals.Creeps["big"] = {}

Neutrals.Creeps["ancient"] = {}

Neutrals.Triggers = {}
Neutrals.Triggers["neutralcamp_good_1"] = "small"
Neutrals.Triggers["neutralcamp_good_2"] = "big"
Neutrals.Triggers["neutralcamp_good_3"] = "ancient"
Neutrals.Triggers["neutralcamp_good_4"] = "big"
Neutrals.Triggers["neutralcamp_good_5"] = "big"
Neutrals.Triggers["neutralcamp_good_6"] = "big"
Neutrals.Triggers["neutralcamp_good_7"] = "medium"
Neutrals.Triggers["neutralcamp_good_8"] = "big"
Neutrals.Triggers["neutralcamp_good_9"] = "medium"

Neutrals.Triggers["neutralcamp_evil_1"] = "big"
Neutrals.Triggers["neutralcamp_evil_2"] = "small"
Neutrals.Triggers["neutralcamp_evil_3"] = "medium"
Neutrals.Triggers["neutralcamp_evil_4"] = "big"
Neutrals.Triggers["neutralcamp_evil_5"] = "big"
Neutrals.Triggers["neutralcamp_evil_6"] = "big"
Neutrals.Triggers["neutralcamp_evil_7"] = "medium"
Neutrals.Triggers["neutralcamp_evil_8"] = "ancient"
Neutrals.Triggers["neutralcamp_evil_9"] = "big"

Neutrals = Neutrals or class({})

ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		local vanilla_spawners = Entities:FindAllByClassname("npc_dota_neutral_spawner")

		for trigger_name, camp_size in pairs(Neutrals.Triggers) do
			local trigger = Entities:FindByName(nil, trigger_name)

			for _, spawner in pairs(vanilla_spawners) do
--				if trigger:IsTouching(spawner) then
				if (spawner:GetAbsOrigin() - trigger:GetAbsOrigin()):Length2D() < 600 then
					print("WELL HELLO THERE")
					trigger.spawn_point = spawner:GetAbsOrigin()
					UTIL_Remove(spawner)
					break
				end
			end
		end
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if NEUTRAL_CREEPS_START_TIME < NEUTRAL_CREEPS_SPAWN_INTERVAL then
			Timers:CreateTimer(NEUTRAL_CREEPS_START_TIME, function()
				Neutrals:CheckForSpawn()
			end)
		end

		Timers:CreateTimer(NEUTRAL_CREEPS_SPAWN_INTERVAL, function()
			Neutrals:CheckForSpawn()

			return NEUTRAL_CREEPS_SPAWN_INTERVAL
		end)
	end
end, nil)

function Neutrals:CheckForSpawn()
	print("Neutrals:CheckForSpawn()")

	for trigger_name, camp_size in pairs(Neutrals.Triggers) do
		local trigger = Entities:FindByName(nil, trigger_name)
		local length = (trigger:GetBoundingMins() - trigger:GetBoundingMaxs()):Length2D()
		local creeps = FindUnitsInRadius(2, trigger:GetAbsOrigin(), nil, length, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local creeps_in_trigger = 0

		for _, creep in pairs(creeps) do
--			print(creep:GetUnitName())

			if trigger:IsTouching(creep) then
				creeps_in_trigger = creeps_in_trigger + 1
			end
		end

		print("Creep count in "..trigger_name..":", creeps_in_trigger)

		if creeps_in_trigger == 0 then
			Neutrals:Spawn(trigger, camp_size)
		end
	end
end

function Neutrals:Spawn(trigger, camp_size)
	print("Neutrals:Spawn()")
	local neutrals = Neutrals.Creeps[camp_size][RandomInt(1, #Neutrals.Creeps[camp_size])]

	for _, neutral in pairs(neutrals) do
		local unit = CreateUnitByName(neutral, trigger.spawn_point, true, nil, nil, 4)
		unit.return_point = trigger.spawn_point 
	end
end
