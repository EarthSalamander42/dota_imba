BATTLEPASS_LEVEL_REWARD = {}
BATTLEPASS_LEVEL_REWARD[10]		= {"sven_rare", "common"}
BATTLEPASS_LEVEL_REWARD[20]		= {"blink1", "common"}
-- BATTLEPASS_LEVEL_REWARD[15]	= {"trail1", "common"}
BATTLEPASS_LEVEL_REWARD[40]		= {"blink2", "common"}
-- BATTLEPASS_LEVEL_REWARD[25]	= {"trail2", "common"}
BATTLEPASS_LEVEL_REWARD[60]		= {"blink3", "common"}
-- BATTLEPASS_LEVEL_REWARD[35]	= {"trail3", "common"}
BATTLEPASS_LEVEL_REWARD[80]		= {"blink4", "common"}
-- BATTLEPASS_LEVEL_REWARD[100]	= {"emblem1", "common"}
BATTLEPASS_LEVEL_REWARD[120]	= {"blink5", "common"}
BATTLEPASS_LEVEL_REWARD[140]	= {"blink6", "common"}
BATTLEPASS_LEVEL_REWARD[160]	= {"blink7", "common"}
BATTLEPASS_LEVEL_REWARD[180]	= {"blink8", "common"}
-- BATTLEPASS_LEVEL_REWARD[200]	= {"emblem2", "common"}
BATTLEPASS_LEVEL_REWARD[220]	= {"blink9", "common"}
BATTLEPASS_LEVEL_REWARD[240]	= {"blink10", "common"}
BATTLEPASS_LEVEL_REWARD[260]	= {"blink11", "common"}
BATTLEPASS_LEVEL_REWARD[280]	= {"blink12", "common"}
-- BATTLEPASS_LEVEL_REWARD[300]	= {"emblem3", "common"}
BATTLEPASS_LEVEL_REWARD[320]	= {"blink13", "common"}
BATTLEPASS_LEVEL_REWARD[340]	= {"blink14", "common"}

function Battlepass:GetHeroEffect(hero)
	print(hero:GetUnitName())

	local ply_table = CustomNetTables:GetTableValue("battlepass", tostring(hero:GetPlayerID()))

	if ply_table and ply_table.bp_rewards == 0 then
		return
	end

	if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) ~= nil then
		local short_name = string.gsub(hero:GetUnitName(), "npc_dota_hero_", "")

		if hero:GetUnitName() == "npc_dota_hero_sven" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["sven_rare"] then
				hero:SetMaterialGroup("1")
				Wearable:_WearProp(hero, "4109", "weapon", "1")
				Wearable:_WearProp(hero, "4206", "head", "1")
				Wearable:_WearProp(hero, "4237", "shoulder", "1")
				Wearable:_WearProp(hero, "4208", "back", "1")
				Wearable:_WearProp(hero, "4239", "belt", "1")
			end
--[[
		elseif hero:GetUnitName() == "npc_dota_hero_zuus" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_ZUUS["zuus_arcana"] then
				Wearable:_WearProp(hero, "6914", "head")
				Wearable:_WearProp(hero, "8692", "arms")
				Wearable:_WearProp(hero, "8693", "back")

				hero.static_field_icon = 1
				hero.static_field_effect = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_static_field.vpcf"
				hero.thundergods_wrath_start_effect = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start.vpcf"
				hero.thundergods_wrath_effect = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath.vpcf"
				hero.thundergods_wrath_icon = 1
				hero.thundergods_wrath_pre_sound = "Hero_Zuus.GodsWrath.PreCast.Arcana"

				hero.blink_effect = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf"
				hero.blink_effect_end = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_end.vpcf"
				hero.blink_icon = "zuus"
				hero.blink_sound = "Hero_Zeus.BlinkDagger.Arcana"
				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
			end
--]]
		end
	end
end
