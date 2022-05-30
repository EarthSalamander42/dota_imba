LinkLuaModifier("modifier_imba_ward_deniable", "components/neutral_creeps/modifiers/modifier_imba_ward_deniable.lua", LUA_MODIFIER_MOTION_NONE)

Neutrals = Neutrals or class({})

-- require("components/neutral_creeps/util.lua")

Neutrals.start_time = 30.0
Neutrals.spawn_interval = 60.0
Neutrals.enable_custom_system = false

Neutrals.Creeps = {}
Neutrals.Creeps["small"] = {}
Neutrals.Creeps["small"][1] = {"npc_dota_neutral_harpy_scout", "npc_dota_neutral_harpy_scout", "npc_dota_neutral_harpy_storm"}
Neutrals.Creeps["small"][2] = {"npc_dota_neutral_fel_beast", "npc_dota_neutral_fel_beast", "npc_dota_neutral_ghost"}
Neutrals.Creeps["small"][3] = {"npc_dota_neutral_forest_troll_berserker", "npc_dota_neutral_forest_troll_berserker", "npc_dota_neutral_kobold_taskmaster"}
Neutrals.Creeps["small"][4] = {"npc_dota_neutral_gnoll_assassin", "npc_dota_neutral_gnoll_assassin", "npc_dota_neutral_gnoll_assassin"}
Neutrals.Creeps["small"][5] = {"npc_dota_neutral_forest_troll_berserker", "npc_dota_neutral_forest_troll_berserker", "npc_dota_neutral_forest_troll_high_priest"}
Neutrals.Creeps["small"][6] = {"npc_dota_neutral_kobold_taskmaster", "npc_dota_neutral_kobold_tunneler", "npc_dota_neutral_kobold", "npc_dota_neutral_kobold", "npc_dota_neutral_kobold"}

Neutrals.Creeps["medium"] = {}
Neutrals.Creeps["medium"][1] = {"npc_dota_neutral_centaur_outrunner", "npc_dota_neutral_centaur_khan"}
Neutrals.Creeps["medium"][2] = {"npc_dota_neutral_alpha_wolf", "npc_dota_neutral_giant_wolf", "npc_dota_neutral_giant_wolf"}
Neutrals.Creeps["medium"][3] = {"npc_dota_neutral_satyr_trickster", "npc_dota_neutral_satyr_trickster", "npc_dota_neutral_satyr_soulstealer", "npc_dota_neutral_satyr_soulstealer"}
Neutrals.Creeps["medium"][4] = {"npc_dota_neutral_ogre_mauler", "npc_dota_neutral_ogre_mauler", "npc_dota_neutral_ogre_magi"}
Neutrals.Creeps["medium"][5] = {"npc_dota_neutral_mud_golem", "npc_dota_neutral_mud_golem"}

Neutrals.Creeps["big"] = {}
Neutrals.Creeps["big"][1] = {"npc_dota_neutral_centaur_outrunner", "npc_dota_neutral_centaur_outrunner", "npc_dota_neutral_centaur_khan"}
Neutrals.Creeps["big"][2] = {"npc_dota_neutral_satyr_hellcaller", "npc_dota_neutral_satyr_trickster", "npc_dota_neutral_satyr_soulstealer"}
Neutrals.Creeps["big"][3] = {"npc_dota_neutral_polar_furbolg_champion", "npc_dota_neutral_polar_furbolg_ursa_warrior"}
Neutrals.Creeps["big"][4] = {"npc_dota_neutral_wildkin", "npc_dota_neutral_wildkin", "npc_dota_neutral_enraged_wildkin"}
Neutrals.Creeps["big"][5] = {"npc_dota_neutral_dark_troll", "npc_dota_neutral_dark_troll", "npc_dota_neutral_dark_troll_warlord"}

Neutrals.Creeps["ancient"] = {}
Neutrals.Creeps["ancient"][1] = {"npc_dota_neutral_black_dragon", "npc_dota_neutral_black_drake", "npc_dota_neutral_black_drake"}
Neutrals.Creeps["ancient"][2] = {"npc_dota_neutral_granite_golem", "npc_dota_neutral_rock_golem", "npc_dota_neutral_rock_golem"}
Neutrals.Creeps["ancient"][3] = {"npc_dota_neutral_big_thunder_lizard", "npc_dota_neutral_small_thunder_lizard", "npc_dota_neutral_small_thunder_lizard"}
Neutrals.Creeps["ancient"][4] = {"npc_dota_neutral_prowler_shaman", "npc_dota_neutral_prowler_acolyte", "npc_dota_neutral_prowler_acolyte"}

Neutrals.Triggers = {}
Neutrals.Triggers["neutralcamp_good_1"] = "small"
Neutrals.Triggers["neutralcamp_good_2"] = "big"
Neutrals.Triggers["neutralcamp_good_3"] = "ancient"
Neutrals.Triggers["neutralcamp_good_4"] = "medium"
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
Neutrals.Triggers["neutralcamp_evil_6"] = "medium"
Neutrals.Triggers["neutralcamp_evil_7"] = "medium"
Neutrals.Triggers["neutralcamp_evil_8"] = "ancient"
Neutrals.Triggers["neutralcamp_evil_9"] = "big"

Neutrals.deniable_allies = {}
Neutrals.deniable_allies["npc_dota_observer_wards"] = true
Neutrals.deniable_allies["npc_dota_sentry_wards"] = true
Neutrals.deniable_allies["npc_imba_techies_land_mines"] = true
Neutrals.deniable_allies["npc_imba_techies_land_mines_big_boom"] = true
Neutrals.deniable_allies["npc_imba_techies_stasis_trap"] = true
Neutrals.deniable_allies["npc_imba_techies_remote_mines"] = true

Neutrals.blacklisted_allies = {}
Neutrals.blacklisted_allies["npc_imba_techies_minefield_sign"] = true

Neutrals.spawn_point = {}

ListenToGameEvent('game_rules_state_change', function(keys)
	if Neutrals.enable_custom_system == false then return end

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		for trigger_name, camp_size in pairs(Neutrals.Triggers) do
			for _, spawner in pairs(Entities:FindAllByClassname("npc_dota_neutral_spawner") or {}) do
				local trigger = Entities:FindByName(nil, trigger_name)

				if spawner and trigger then
--					if trigger:IsTouching(spawner) then
					-- Not the greatest way to do it, but it works
					if (spawner:GetAbsOrigin() - trigger:GetAbsOrigin()):Length2D() < 1000 then
						print(trigger:GetName())
						Neutrals.spawn_point[trigger:GetName()] = spawner:GetAbsOrigin()
						UTIL_Remove(spawner)
						break
					end
				end
			end
		end
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if Neutrals.start_time < Neutrals.spawn_interval then
			Timers:CreateTimer(Neutrals.start_time, function()
				Neutrals:CheckForSpawn()
			end)
		end

		Timers:CreateTimer(Neutrals.spawn_interval, function()
			Neutrals:CheckForSpawn()

			return Neutrals.spawn_interval
		end)
	end
end, nil)

ListenToGameEvent("npc_spawned", function(keys)
	if not IsServer() then return end

	local npc = EntIndexToHScript(keys.entindex)

	if not IsValidEntity(npc) then
		return
	end

	if Neutrals.deniable_allies[npc:GetUnitName()] then
		npc:SetContextThink(DoUniqueString("ward_fucker"), function()
			if Neutrals:IsBlockingAllyNeutralSpawn(npc) then
				npc:AddNewModifier(npc, nil, "modifier_imba_ward_deniable", {})
			end

			return nil
		end, FrameTime())
	end

	if Neutrals.blacklisted_allies[npc:GetUnitName()] then
		npc:SetContextThink(DoUniqueString("ward_fucker"), function()
			if Neutrals:IsBlockingAllyNeutralSpawn(npc) then
				npc:ForceKill(false)

				local player_id = npc:GetPlayerOwnerID()
				DisplayError(player_id, "Can't spawn this unit in neutral camps area.")
			end
		end, FrameTime())
	end
end, nil)

--[[
function Neutrals:CheckForSpawn()
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

		local pos = Neutrals.spawn_point[trigger:GetName()]

--		print("Creep count in "..trigger_name..":", creeps_in_trigger)
--		print("trigger name:", trigger:GetName())
--		print("spawn pos:", pos)

		local pfx_name = "particles/world_environmental_fx/radiant_creep_spawn.vpcf"

		if string.find(trigger:GetName(), "evil") then
			pfx_name = "particles/world_environmental_fx/dire_creep_spawn.vpcf"
		end

		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		ParticleManager:ReleaseParticleIndex(pfx)

		if creeps_in_trigger == 0 then
			Neutrals:Spawn(trigger, pos, camp_size)
		end
	end
end
--]]

function Neutrals:Spawn(trigger, pos, camp_size)
	local neutrals = Neutrals.Creeps[camp_size][RandomInt(1, #Neutrals.Creeps[camp_size])]

	for _, neutral in pairs(neutrals) do
		local unit = CreateUnitByName(neutral, pos, true, nil, nil, 4)
	end
end

-- Make wards deniable if planted on Neutral Creeps triggers
function Neutrals:IsBlockingAllyNeutralSpawn(ward)
	for trigger_name, camp_size in pairs(Neutrals.Triggers) do
		local trigger = Entities:FindByName(nil, trigger_name)

		if trigger then
			local length = (trigger:GetBoundingMins() - trigger:GetBoundingMaxs()):Length2D()

			if string.find(trigger:GetName(), "good") and ward:GetTeam() == 2 or string.find(trigger:GetName(), "evil") and ward:GetTeam() == 3 then
				if trigger:IsTouching(ward) then
					return true
				end
			end
		end
	end

	return false
end
