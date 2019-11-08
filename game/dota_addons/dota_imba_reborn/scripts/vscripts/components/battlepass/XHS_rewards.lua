BATTLEPASS_LEVEL_REWARD = {}
BATTLEPASS_LEVEL_REWARD[5]		= {"teleport", "common"}
BATTLEPASS_LEVEL_REWARD[10]		= {"teleport2", "common"}
BATTLEPASS_LEVEL_REWARD[15]		= {"teleport3", "common"}
BATTLEPASS_LEVEL_REWARD[20]		= {"teleport4", "common"}
BATTLEPASS_LEVEL_REWARD[25]		= {"teleport5", "common"}
BATTLEPASS_LEVEL_REWARD[30]		= {"teleport6", "common"}
BATTLEPASS_LEVEL_REWARD[35]		= {"teleport7", "common"}
BATTLEPASS_LEVEL_REWARD[40]		= {"teleport8", "common"}
BATTLEPASS_LEVEL_REWARD[45]		= {"teleport9", "common"}
BATTLEPASS_LEVEL_REWARD[50]		= {"tome", "mythical"}
BATTLEPASS_LEVEL_REWARD[55]		= {"teleport10", "common"}
BATTLEPASS_LEVEL_REWARD[60]		= {"teleport11", "common"}
BATTLEPASS_LEVEL_REWARD[65]		= {"teleport12", "common"}
BATTLEPASS_LEVEL_REWARD[70]		= {"teleport13", "common"}
BATTLEPASS_LEVEL_REWARD[75]		= {"teleport14", "common"}
BATTLEPASS_LEVEL_REWARD[80]		= {"teleport15", "common"}
BATTLEPASS_LEVEL_REWARD[85]		= {"teleport16", "common"}
BATTLEPASS_LEVEL_REWARD[90]		= {"teleport17", "common"}
BATTLEPASS_LEVEL_REWARD[95]		= {"teleport18", "common"}
BATTLEPASS_LEVEL_REWARD[100]	= {"tome2", "mythical"}
BATTLEPASS_LEVEL_REWARD[105]	= {"teleport19", "common"}
BATTLEPASS_LEVEL_REWARD[110]	= {"teleport20", "common"}
BATTLEPASS_LEVEL_REWARD[115]	= {"teleport21", "common"}
BATTLEPASS_LEVEL_REWARD[120]	= {"teleport22", "common"}
BATTLEPASS_LEVEL_REWARD[125]	= {"teleport23", "common"}
BATTLEPASS_LEVEL_REWARD[130]	= {"teleport24", "common"}
BATTLEPASS_LEVEL_REWARD[135]	= {"teleport25", "common"}
BATTLEPASS_LEVEL_REWARD[140]	= {"teleport26", "common"}
BATTLEPASS_LEVEL_REWARD[145]	= {"teleport27", "common"}
BATTLEPASS_LEVEL_REWARD[150]	= {"tome3", "mythical"}
BATTLEPASS_LEVEL_REWARD[200]	= {"tome4", "mythical"}

CustomNetTables:SetTableValue("game_options", "battlepass", {battlepass = BATTLEPASS_LEVEL_REWARD})

function Battlepass:Init()
	BattlepassHeroes = {}
--[[
	BattlepassHeroes["axe"] = {}
	BattlepassHeroes["bristleback"] = {}
	BattlepassHeroes["chen"] = {}
	BattlepassHeroes["juggernaut"] = {}
	BattlepassHeroes["leshrac"] = {}
	BattlepassHeroes["life_stealer"] = {}
	BattlepassHeroes["lina"] = {}
	BattlepassHeroes["nyx_assassin"] = {}
	BattlepassHeroes["wisp"] = {}
--]]

	BattlepassItems = {}
--	BattlepassItems["blink"] = {}
	BattlepassItems["teleport"] = {}
	BattlepassItems["tome"] = {}

	for k, v in pairs(BATTLEPASS_LEVEL_REWARD) do
		local required_level = k
		local reward_name = v[1]
		local category = string.gsub(reward_name, "%d", "")
		local reward_level = string.gsub(reward_name, "%D", "")

		for i, j in pairs(BattlepassHeroes) do
			local hero_name = i

			if string.find(reward_name, hero_name) then
				BattlepassHeroes[hero_name][reward_name] = required_level
				break
			end
		end

--		print(required_level, category, reward_level)
		if BattlepassItems[category] then
			if reward_level == "" then reward_level = 1 end
			table.insert(BattlepassItems[category], tonumber(reward_level), required_level)
		end
	end
end

--[[ -- instead of a flat BattlepassHeroes[hero_name] value, generate it by finding if there's a hero name in all reward names
function Battlepass:IsHeroName(hero_name)
	local herolist = LoadKeyValues("scripts/npc/herolist.txt")

	print(herolist[hero_name])
	if herolist[hero_name] then
		return true
	end

	return false
end
--]]

function Battlepass:GetTeleportEffect(ID)
	local effects = {}

	effects["effect1"] = {}
	effects["effect1"][0] = "particles/items2_fx/teleport_start.vpcf"
	effects["effect1"][1] = "particles/econ/events/ti4/teleport_start_ti4.vpcf"
	effects["effect1"][2] = "particles/econ/events/league_teleport_2014/teleport_start_league.vpcf"
	effects["effect1"][3] = "particles/econ/events/league_teleport_2014/teleport_start_league_bronze.vpcf"
	effects["effect1"][4] = "particles/econ/events/league_teleport_2014/teleport_start_league_silver.vpcf"
	effects["effect1"][5] = "particles/econ/events/league_teleport_2014/teleport_start_league_gold.vpcf"
	effects["effect1"][6] = "particles/econ/events/ti5/teleport_start_ti5.vpcf"
	effects["effect1"][7] = "particles/econ/events/ti5/teleport_start_lvl2_ti5.vpcf"
	effects["effect1"][8] = "particles/econ/events/fall_major_2015/teleport_start_fallmjr_2015.vpcf"
	effects["effect1"][9] = "particles/econ/events/fall_major_2015/teleport_start_fallmjr_2015_lvl2.vpcf"
	effects["effect1"][10] = "particles/econ/events/fall_major_2016/teleport_start_fm06_lvl1.vpcf"
	effects["effect1"][11] = "particles/econ/events/fall_major_2016/teleport_start_fm06_lvl2.vpcf"
	effects["effect1"][12] = "particles/econ/events/fall_major_2016/teleport_start_fm06_lvl3.vpcf"
	effects["effect1"][13] = "particles/econ/events/ti6/teleport_start_ti6.vpcf"
	effects["effect1"][14] = "particles/econ/events/ti6/teleport_start_ti6_lvl2.vpcf"
	effects["effect1"][15] = "particles/econ/events/ti6/teleport_start_ti6_lvl3.vpcf"
	effects["effect1"][16] = "particles/econ/events/winter_major_2016/teleport_start_winter_major_2016_lvl1.vpcf"
	effects["effect1"][17] = "particles/econ/events/winter_major_2016/teleport_start_winter_major_2016_lvl2.vpcf"
	effects["effect1"][18] = "particles/econ/events/winter_major_2016/teleport_start_winter_major_2016_lvl3.vpcf"
	effects["effect1"][19] = "particles/econ/events/ti7/teleport_start_ti7.vpcf"
	effects["effect1"][20] = "particles/econ/events/ti7/teleport_start_ti7_lvl2.vpcf"
	effects["effect1"][21] = "particles/econ/events/ti7/teleport_start_ti7_lvl3.vpcf"
	effects["effect1"][22] = "particles/econ/events/ti8/teleport_start_ti8.vpcf"
	effects["effect1"][23] = "particles/econ/events/ti8/teleport_start_ti8_lvl2.vpcf"
	effects["effect1"][24] = "particles/econ/events/ti8/teleport_start_ti8_lvl3.vpcf"
	effects["effect1"][25] = "particles/econ/events/ti9/teleport_start_ti9.vpcf"
	effects["effect1"][26] = "particles/econ/events/ti9/teleport_start_ti9_lvl2.vpcf"
	effects["effect1"][27] = "particles/econ/events/ti9/teleport_start_ti9_lvl3.vpcf"

	-- particles/econ/items/tinker/boots_of_travel/teleport_start_bots.vpcf"

	effects["effect2"] = {}
	effects["effect2"][0] = "particles/items2_fx/teleport_end.vpcf"
	effects["effect2"][1] = "particles/econ/events/ti4/teleport_end_ti4.vpcf"
	effects["effect2"][2] = "particles/econ/events/league_teleport_2014/teleport_end_league.vpcf"
	effects["effect2"][3] = "particles/econ/events/league_teleport_2014/teleport_end_league_bronze.vpcf"
	effects["effect2"][4] = "particles/econ/events/league_teleport_2014/teleport_end_league_silver.vpcf"
	effects["effect2"][5] = "particles/econ/events/league_teleport_2014/teleport_end_league_gold.vpcf"
	effects["effect2"][6] = "particles/econ/events/ti5/teleport_end_ti5.vpcf"
	effects["effect2"][7] = "particles/econ/events/ti5/teleport_end_lvl2_ti5.vpcf"
	effects["effect2"][8] = "particles/econ/events/fall_major_2015/teleport_end_fallmjr_2015.vpcf"
	effects["effect2"][9] = "particles/econ/events/fall_major_2015/teleport_end_fallmjr_2015_lvl2.vpcf"
	effects["effect2"][10] = "particles/econ/events/fall_major_2016/teleport_end_fm06.vpcf"
	effects["effect2"][11] = "particles/econ/events/fall_major_2016/teleport_end_fm06_lvl2.vpcf"
	effects["effect2"][12] = "particles/econ/events/fall_major_2016/teleport_end_fm06_lvl3.vpcf"
	effects["effect2"][13] = "particles/econ/events/ti6/teleport_end_ti6.vpcf"
	effects["effect2"][14] = "particles/econ/events/ti6/teleport_end_ti6_lvl2.vpcf"
	effects["effect2"][15] = "particles/econ/events/ti6/teleport_end_ti6_lvl3.vpcf"
	effects["effect2"][16] = "particles/econ/events/winter_major_2016/teleport_end_winter_major_2016_lvl1.vpcf"
	effects["effect2"][17] = "particles/econ/events/winter_major_2016/teleport_end_winter_major_2016_lvl2.vpcf"
	effects["effect2"][18] = "particles/econ/events/winter_major_2016/teleport_end_winter_major_2016_lvl3.vpcf"
	effects["effect2"][19] = "particles/econ/events/ti7/teleport_end_ti7.vpcf"
	effects["effect2"][20] = "particles/econ/events/ti7/teleport_end_ti7_lvl2.vpcf"
	effects["effect2"][21] = "particles/econ/events/ti7/teleport_end_ti7_lvl3.vpcf"
	effects["effect2"][22] = "particles/econ/events/ti8/teleport_end_ti8.vpcf"
	effects["effect2"][23] = "particles/econ/events/ti8/teleport_end_ti8_lvl2.vpcf"
	effects["effect2"][24] = "particles/econ/events/ti8/teleport_end_ti8_lvl3.vpcf"
	effects["effect2"][25] = "particles/econ/events/ti9/teleport_end_ti9.vpcf"
	effects["effect2"][26] = "particles/econ/events/ti9/teleport_end_ti9_lvl2.vpcf"
	effects["effect2"][27] = "particles/econ/events/ti9/teleport_end_ti9_lvl3.vpcf"

	-- particles/econ/items/natures_prophet/natures_prophet_weapon_sufferwood/furion_teleport_end_sufferwood.vpcf
	-- particles/econ/items/tinker/boots_of_travel/teleport_end_bots.vpcf
	-- add wisp relocate arcana?

	local hero_item_effects = {}
	hero_item_effects["level"] = 0
	hero_item_effects["effect1"] = effects["effect1"][0]
	hero_item_effects["effect2"] = effects["effect2"][0]

--	print("Teleport BP table:", BattlepassItems["teleport"], #BattlepassItems["teleport"])

	if Battlepass:GetRewardUnlocked(ID) ~= nil then
		for i = #BattlepassItems["teleport"] - 1, 1, -1 do
--			print(Battlepass:GetRewardUnlocked(ID), BattlepassItems["teleport"][i])
			if BattlepassItems["teleport"][i] and Battlepass:GetRewardUnlocked(ID) >= BattlepassItems["teleport"][i] then
				hero_item_effects["level"] = i
				hero_item_effects["effect1"] = effects["effect1"][i]
				hero_item_effects["effect2"] = effects["effect2"][i]
				break
			end
		end
	end

	return hero_item_effects
end

function Battlepass:GetTomeEffect(ID)
	local effects = {}

	effects["effect1"] = {}
	effects["effect1"][0] = "particles/generic_hero_status/hero_levelup.vpcf"
	effects["effect1"][1] = "particles/econ/events/ti6/hero_levelup_ti6.vpcf"
	effects["effect1"][2] = "particles/econ/events/ti7/hero_levelup_ti7.vpcf"
	effects["effect1"][3] = "particles/econ/events/ti8/hero_levelup_ti8.vpcf"
	effects["effect1"][4] = "particles/econ/events/ti9/hero_levelup_ti9.vpcf"

	local hero_item_effects = {}
	hero_item_effects["level"] = 0
	hero_item_effects["effect1"] = effects["effect1"][0]

	if Battlepass:GetRewardUnlocked(ID) ~= nil then
		for i = #BattlepassItems["tome"] - 1, 1, -1 do
			if BattlepassItems["tome"][i] and Battlepass:GetRewardUnlocked(ID) >= BattlepassItems["tome"][i] then
				hero_item_effects["level"] = i
				hero_item_effects["effect1"] = effects["effect1"][i]
				break
			end
		end
	end

	return hero_item_effects
end

function Battlepass:SetItemEffects(ID)
	CustomNetTables:SetTableValue("battlepass_item_effects", tostring(ID), {
--		blink = Battlepass:GetBlinkEffect(ID),
		teleport = Battlepass:GetTeleportEffect(ID),
		tome_stats = Battlepass:GetTomeEffect(ID),
	})

--	print(CustomNetTables:GetTableValue("battlepass_item_effects", tostring(ID)))
end

function Battlepass:GetHeroEffect(hero)
--[[
	if hero:GetUnitName() == "npc_dota_hero_axe" then
		hero.pre_attack_sound = "Hero_Axe.PreAttack"
		hero.attack_sound = "Hero_Axe.Attack"
		hero.counter_helix_pfx = "particles/units/heroes/hero_axe/axe_attack_blur_counterhelix.vpcf"
		hero.culling_blade_kill_pfx = "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
		hero.culling_blade_boost_pfx = "particles/units/heroes/hero_axe/axe_culling_blade_boost.vpcf"
		hero.culling_blade_sprint_pfx = "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf"
	elseif hero:GetUnitName() == "npc_dota_hero_juggernaut" then
		hero.blade_dance_effect = "particles/units/heroes/hero_juggernaut/juggernaut_crit_tgt.vpcf"
		hero.blade_dance_sound = "Hero_Juggernaut.BladeDance"
		hero.omni_slash_hit_effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf"
		hero.omni_slash_trail_effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf"
		hero.omni_slash_dash_effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_dash.vpcf"
		hero.omni_slash_status_effect = "particles/status_fx/status_effect_omnislash.vpcf"
		hero.omni_slash_end = "particles/units/heroes/hero_juggernaut/juggernaut_omni_end.vpcf"
		hero.omni_slash_light = "particles/units/heroes/hero_juggernaut/juggernaut_omnislash_light.vpcf"
	elseif hero:GetUnitName() == "npc_dota_hero_leshrac" then
		CustomNetTables:SetTableValue("battlepass", "leshrac", {
			diabolic_edict = "particles/units/heroes/hero_leshrac/leshrac_diabolic_edict.vpcf",
		})
	elseif hero:GetUnitName() == "npc_dota_hero_nyx_assassin" then
		hero.spiked_carapace_pfx = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace.vpcf"
		hero.spiked_carapace_debuff_pfx = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace_hit.vpcf"
--	elseif hero:GetUnitName() == "npc_dota_hero_wisp" then
	end

	local ply_table = CustomNetTables:GetTableValue("battlepass", tostring(hero:GetPlayerID()))

	if ply_table and ply_table.bp_rewards == 0 then
		return
	end

	if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) ~= nil then
		if hero:GetUnitName() == "npc_dota_hero_axe" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_AXE["axe_immortal"] then
				Wearable:_WearProp(hero, "12964", "weapon")
				Wearable:_WearProp(hero, "12965", "armor")
				Wearable:_WearProp(hero, "12966", "belt")
				Wearable:_WearProp(hero, "12968", "head")

				hero.pre_attack_sound = "Hero_Axe.PreAttack.Jungle"
				hero.attack_sound = "Hero_Axe.Attack.Jungle"
				hero.counter_helix_pfx = "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_attack_blur_counterhelix.vpcf"
				hero.culling_blade_kill_pfx = "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_kill.vpcf"
				hero.culling_blade_boost_pfx = "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_boost.vpcf"
				hero.culling_blade_sprint_pfx = "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_sprint.vpcf"

				hero:AddNewModifier(hero, nil, "modifier_axe_arcana", {})
				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {style = style})
			end
		elseif hero:GetUnitName() == "npc_dota_hero_bristleback" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_BRISTLEBACK["bristleback_rare2"] then
				Wearable:_WearProp(hero, "9786", "back", "1")
				Wearable:_WearProp(hero, "9787", "arms", "1")
				Wearable:_WearProp(hero, "9788", "head", "1")
				Wearable:_WearProp(hero, "9789", "neck", "1")
				Wearable:_WearProp(hero, "9790", "weapon", "1")
			elseif Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_BRISTLEBACK["bristleback_rare"] then
				Wearable:_WearProp(hero, "9786", "back", "0")
				Wearable:_WearProp(hero, "9787", "arms", "0")
				Wearable:_WearProp(hero, "9788", "head", "0")
				Wearable:_WearProp(hero, "9789", "neck", "0")
				Wearable:_WearProp(hero, "9790", "weapon", "0")
			end
		elseif hero:GetUnitName() == "npc_dota_hero_chen" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_CHEN["chen_mythical"] then
				Wearable:_WearProp(hero, "9950", "head")
				Wearable:_WearProp(hero, "9951", "weapon")
				Wearable:_WearProp(hero, "9952", "mount")
				Wearable:_WearProp(hero, "9953", "shoulder")
				Wearable:_WearProp(hero, "9954", "arms")
			end
		elseif hero:GetUnitName() == "npc_dota_hero_juggernaut" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_JUGGERNAUT["juggernaut_arcana"] then
				local style = 0
				if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_JUGGERNAUT["juggernaut_arcana2"] then
					style = 1
				end

				if style == 0 then
					hero.blade_fury_effect = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_blade_fury.vpcf"
					hero.blade_dance_effect = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_crit_tgt.vpcf"
					hero.arcana_trigger_effect = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_trigger.vpcf"
				elseif style == 1 then
					hero.blade_fury_effect = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_blade_fury.vpcf"
					hero.blade_dance_effect = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_crit_tgt.vpcf"
					hero.arcana_trigger_effect = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_trigger.vpcf"
				end

				hero.blade_dance_sound = "Hero_Juggernaut.BladeDance.Arcana"

				hero:AddNewModifier(hero, nil, "modifier_juggernaut_arcana", {})
				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {style = style})
				Wearable:_WearProp(hero, "9059", "head", style)
			end
		elseif hero:GetUnitName() == "npc_dota_hero_leshrac" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_LESHRAC["leshrac_immortal"] then
				CustomNetTables:SetTableValue("battlepass", "leshrac", {
					diabolic_edict = "particles/econ/items/leshrac/leshrac_ti9_immortal_head/leshrac_ti9_immortal_edict.vpcf",
				})

				Wearable:_WearProp(hero, "12933", "head")

				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {style = 1})
			end
		elseif hero:GetUnitName() == "npc_dota_hero_lina" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_LINA["lina_arcana"] then
				Wearable:_WearProp(hero, "4794", "head")

				hero.dragon_slave_effect = "particles/econ/items/lina/lina_head_headflame/lina_spell_dragon_slave_headflame.vpcf"
				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
			end
		elseif hero:GetUnitName() == "npc_dota_hero_nyx_assassin" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_NYX_ASSASSIN["nyx_assassin_immortal"] then
				hero.spiked_carapace_pfx = "particles/econ/items/nyx_assassin/nyx_ti9_immortal/nyx_ti9_carapace.vpcf"
				hero.spiked_carapace_debuff_pfx = "particles/econ/items/nyx_assassin/nyx_ti9_immortal/nyx_ti9_carapace_hit.vpcf"

				Wearable:_WearProp(hero, "12957", "back")
			end

			-- custom icons
			hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
		elseif hero:GetUnitName() == "npc_dota_hero_wisp" then
--			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_WISP["wisp_arcana"] then
--				Wearable:_WearProp(hero, "9235", "head")

--				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
--			end
		end
	end
--]]
end
