NEUTRAL_CREEPS_START_TIME = 60.0
NEUTRAL_CREEPS_SPAWN_INTERVAL = 60.0

NEUTRAL_SMALL_CAMP_CONTENT = {}
NEUTRAL_SMALL_CAMP_CONTENT[1] = {"npc_dota_neutral_harpy_scout", "npc_dota_neutral_harpy_scout", "npc_dota_neutral_harpy_storm"}
NEUTRAL_SMALL_CAMP_CONTENT[2] = {"npc_dota_neutral_fel_beast", "npc_dota_neutral_fel_beast", "npc_dota_neutral_ghost"}
NEUTRAL_SMALL_CAMP_CONTENT[3] = {"npc_dota_neutral_forest_troll_berserker", "npc_dota_neutral_forest_troll_berserker", "npc_dota_neutral_kobold_taskmaster"}
NEUTRAL_SMALL_CAMP_CONTENT[4] = {"npc_dota_neutral_gnoll_assassin", "npc_dota_neutral_gnoll_assassin", "npc_dota_neutral_gnoll_assassin"}
NEUTRAL_SMALL_CAMP_CONTENT[5] = {"npc_dota_neutral_forest_troll_berserker", "npc_dota_neutral_forest_troll_berserker", "npc_dota_neutral_forest_troll_high_priest"}
NEUTRAL_SMALL_CAMP_CONTENT[6] = {"npc_dota_neutral_kobold_taskmaster", "npc_dota_neutral_kobold_tunneler", "npc_dota_neutral_kobold", "npc_dota_neutral_kobold", "npc_dota_neutral_kobold"}

NEUTRAL_CAMP_CONTENT = {}
NEUTRAL_CAMP_CONTENT["small"] = NEUTRAL_SMALL_CAMP_CONTENT
NEUTRAL_CAMP_CONTENT["medium"] = {}
NEUTRAL_CAMP_CONTENT["big"] = {}
NEUTRAL_CAMP_CONTENT["ancient"] = {}

ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		Timers:CreateTimer(NEUTRAL_CREEPS_START_TIME, function()
			local trigger = Entities:FindByName(nil, "neutralcamp_good_1")
			local neutrals = NEUTRAL_SMALL_CAMP_CONTENT[RandomInt(1, #NEUTRAL_SMALL_CAMP_CONTENT)]

			for _, neutral in pairs(neutrals) do

			end

			return NEUTRAL_CREEPS_SPAWN_INTERVAL
		end)
	end
end, nil)
