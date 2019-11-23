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

CustomNetTables:SetTableValue("game_options", "battlepass", {battlepass = BATTLEPASS_LEVEL_REWARD})

function Battlepass:Init()
	CustomGameEventManager:RegisterListener("change_ingame_tag", Dynamic_Wrap(self, 'DonatorTag'))
	CustomGameEventManager:RegisterListener("change_battlepass_rewards", Dynamic_Wrap(self, 'BattlepassRewards'))
	CustomGameEventManager:RegisterListener("change_player_xp", Dynamic_Wrap(self, 'PlayerXP'))

	BattlepassHeroes = {}
--	BattlepassHeroes["drow_ranger"] = {}
--	BattlepassHeroes["earthshaker"] = {}
--	BattlepassHeroes["enigma"] = {}
--	BattlepassHeroes["huskar"] = {}
--	BattlepassHeroes["juggernaut"] = {}
--	BattlepassHeroes["lina"] = {}
--	BattlepassHeroes["nyx_assassin"] = {}
--	BattlepassHeroes["pudge"] = {}
--	BattlepassHeroes["skywrath_mage"] = {}
	BattlepassHeroes["sven"] = {}
--	BattlepassHeroes["vengefulspirit"] = {}
--	BattlepassHeroes["wisp"] = {}
--	BattlepassHeroes["zuus"] = {}

	BattlepassItems = {}
	BattlepassItems["blink"] = {}
	BattlepassItems["force_staff"] = {}

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

	print("Sven BP hero table:")
	print(BattlepassHeroes["sven"])
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

function Battlepass:GetBlinkEffect(ID)
	local effects = {}

	effects["effect1"] = {}
	effects["effect1"][0] = "particles/items_fx/blink_dagger_start.vpcf"
	effects["effect1"][1] = "particles/econ/events/fall_major_2016/blink_dagger_start_fm06.vpcf"
	effects["effect1"][2] = "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf"
	effects["effect1"][3] = "particles/econ/events/ti7/blink_dagger_start_ti7.vpcf"
	effects["effect1"][4] = "particles/econ/events/ti7/blink_dagger_start_ti7_lvl2.vpcf"
	effects["effect1"][5] = "particles/econ/events/winter_major_2017/blink_dagger_start_wm07.vpcf"
	effects["effect1"][6] = "particles/econ/events/ti4/blink_dagger_start_ti4.vpcf"
	effects["effect1"][7] = "particles/econ/events/ti6/blink_dagger_start_ti6.vpcf"
	effects["effect1"][8] = "particles/econ/events/ti6/blink_dagger_start_ti6_lvl2.vpcf"
	effects["effect1"][9] = "particles/econ/events/ti5/blink_dagger_start_ti5.vpcf"
	effects["effect1"][10] = "particles/econ/events/ti5/blink_dagger_start_lvl2_ti5.vpcf"
	effects["effect1"][11] = "particles/econ/events/ti8/blink_dagger_ti8_start.vpcf"
	effects["effect1"][12] = "particles/econ/events/ti8/blink_dagger_ti8_start_lvl2.vpcf"
	effects["effect1"][13] = "particles/econ/events/ti9/blink_dagger_ti9_start.vpcf"
	effects["effect1"][14] = "particles/econ/events/ti9/blink_dagger_ti9_start_lvl2.vpcf"

	effects["effect2"] = {}
	effects["effect2"][0] = "particles/items_fx/blink_dagger_end.vpcf"
	effects["effect2"][1] = "particles/econ/events/fall_major_2016/blink_dagger_end_fm06.vpcf"
	effects["effect2"][2] = "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf"
	effects["effect2"][3] = "particles/econ/events/ti7/blink_dagger_end_ti7.vpcf"
	effects["effect2"][4] = "particles/econ/events/ti7/blink_dagger_end_ti7_lvl2.vpcf"
	effects["effect2"][5] = "particles/econ/events/winter_major_2017/blink_dagger_end_wm07.vpcf"
	effects["effect2"][6] = "particles/econ/events/ti4/blink_dagger_end_ti4.vpcf"
	effects["effect2"][7] = "particles/econ/events/ti6/blink_dagger_end_ti6.vpcf"
	effects["effect2"][8] = "particles/econ/events/ti6/blink_dagger_end_ti6_lvl2.vpcf"
	effects["effect2"][9] = "particles/econ/events/ti5/blink_dagger_end_ti5.vpcf"
	effects["effect2"][10] = "particles/econ/events/ti5/blink_dagger_end_lvl2_ti5.vpcf"
	effects["effect2"][11] = "particles/econ/events/ti8/blink_dagger_ti8_end.vpcf"
	effects["effect2"][12] = "particles/econ/events/ti8/blink_dagger_ti8_end_lvl2.vpcf"
	effects["effect2"][13] = "particles/econ/events/ti9/blink_dagger_ti9_end.vpcf"
	effects["effect2"][14] = "particles/econ/events/ti9/blink_dagger_ti9_lvl2_end.vpcf"

	local hero_item_effects = {}
	hero_item_effects["level"] = 0
	hero_item_effects["effect1"] = effects["effect1"][0]
	hero_item_effects["effect2"] = effects["effect2"][0]

	if Battlepass:GetRewardUnlocked(ID) ~= nil then
		for i = #BattlepassItems["blink"], 1, -1 do
			if BattlepassItems["blink"][i] and Battlepass:GetRewardUnlocked(ID) >= BattlepassItems["blink"][i] then
				hero_item_effects["level"] = i
				hero_item_effects["effect1"] = effects["effect1"][i]
				hero_item_effects["effect2"] = effects["effect2"][i]
				break
			end
		end
	end

	return hero_item_effects
end

function Battlepass:GetForceStaffEffect(ID)
	local effects = {}

	effects["effect1"] = {}
	effects["effect1"][0] = "particles/items_fx/force_staff.vpcf"
	effects["effect1"][1] = "particles/econ/events/fall_major_2016/force_staff_fm06.vpcf"
	effects["effect1"][2] = "particles/econ/events/ti7/force_staff_ti7.vpcf"
	effects["effect1"][3] = "particles/econ/events/winter_major_2017/force_staff_wm07.vpcf"
	effects["effect1"][4] = "particles/econ/events/ti6/force_staff_ti6.vpcf"
	effects["effect1"][5] = "particles/econ/events/ti8/force_staff_ti8.vpcf"
	effects["effect1"][6] = "particles/econ/events/ti9/force_staff_ti9.vpcf"

	local hero_item_effects = {}
	hero_item_effects["level"] = 0
	hero_item_effects["effect1"] = effects["effect1"][0]

	if Battlepass:GetRewardUnlocked(ID) ~= nil then
		for i = #BattlepassItems["force_staff"], 1, -1 do
			if BattlepassItems["force_staff"][i] and Battlepass:GetRewardUnlocked(ID) >= BattlepassItems["force_staff"][i] then
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
		blink = Battlepass:GetBlinkEffect(ID),
--		force_staff = Battlepass:GetForceStaffEffect(ID),
	})

--	print(CustomNetTables:GetTableValue("battlepass_item_effects", tostring(ID)))
end

function Battlepass:GetHeroEffect(hero)
	if hero:GetUnitName() == "npc_dota_hero_drow_ranger" then
		hero.base_attack_projectile = "particles/units/heroes/hero_drow/drow_base_attack.vpcf"
		hero.frost_arrows_debuff_pfx = "particles/units/heroes/hero_drow/drow_frost_arrow_debuff.vpcf"
		hero.marksmanship_arrow_pfx = "particles/units/heroes/hero_drow/drow_marksmanship_attack.vpcf"
		hero.marksmanship_frost_arrow_pfx = "particles/units/heroes/hero_drow/drow_marksmanship_frost_arrow.vpcf"
	elseif hero:GetUnitName() == "npc_dota_hero_earthshaker" then
		hero.fissure_pfx = "particles/units/heroes/hero_earthshaker/earthshaker_fissure.vpcf"
		hero.enchant_totem_leap_blur_pfx = "particles/units/heroes/hero_earthshaker/earthshaker_totem_leap_blur.vpcf"
		hero.enchant_totem_buff_pfx = "particles/units/heroes/hero_earthshaker/earthshaker_totem_buff.vpcf"
		hero.enchant_totem_cast_pfx = "particles/units/heroes/hero_earthshaker/earthshaker_totem_cast.vpcf"
		hero.aftershock_pfx = "particles/units/heroes/hero_earthshaker/earthshaker_aftershock.vpcf"
		hero.echo_slam_start_pfx = "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf"
		hero.echo_slam_tgt_pfx = "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_tgt.vpcf"
		hero.echo_slam_pfx = "particles/units/heroes/hero_earthshaker/earthshaker_echoslam.vpcf"

		-- if earthshaker have ti6 totem + arcana, use this particles
--		hero.enchant_totem_buff_pfx = "particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_buff.vpcf"
--		hero.enchant_totem_buff_pfx = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_buff_ti6_combined.vpcf"
--		hero.enchant_totem_cast_pfx = "particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_cast.vpcf"
--		hero.enchant_totem_cast_pfx = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_cast_ti6_combined.vpcf"
--		hero.enchant_totem_cast_pfx = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_cast_ti6_combined_v2.vpcf"
	elseif hero:GetUnitName() == "npc_dota_hero_huskar" then
		hero.life_break_cast_effect = "particles/units/heroes/hero_huskar/huskar_life_break_cast.vpcf"
		hero.life_break_start_effect = "particles/units/heroes/hero_huskar/huskar_life_break_spellstart.vpcf"
		hero.life_break_effect = "particles/units/heroes/hero_huskar/huskar_life_break.vpcf"
	elseif hero:GetUnitName() == "npc_dota_hero_juggernaut" then
		hero.blade_dance_effect = "particles/units/heroes/hero_juggernaut/juggernaut_crit_tgt.vpcf"
		hero.blade_dance_sound = "Hero_Juggernaut.BladeDance"
		hero.omni_slash_hit_effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf"
		hero.omni_slash_trail_effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf"
		hero.omni_slash_dash_effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_dash.vpcf"
		hero.omni_slash_status_effect = "particles/status_fx/status_effect_omnislash.vpcf"
		hero.omni_slash_end = "particles/units/heroes/hero_juggernaut/juggernaut_omni_end.vpcf"
		hero.omni_slash_light = "particles/units/heroes/hero_juggernaut/juggernaut_omnislash_light.vpcf"
	elseif hero:GetUnitName() == "npc_dota_hero_nyx_assassin" then
		hero.spiked_carapace_pfx = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace.vpcf"
		hero.spiked_carapace_debuff_pfx = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace_hit.vpcf"
	elseif hero:GetUnitName() == "npc_dota_hero_skywrath_mage" then
		hero.arcane_bolt_pfx = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf"
	end

	local ply_table = CustomNetTables:GetTableValue("battlepass", tostring(hero:GetPlayerID()))

	if ply_table and ply_table.bp_rewards == 0 then
		return
	end

	if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) ~= nil then
		local short_name = string.gsub(hero:GetUnitName(), "npc_dota_hero_", "")

--[[
		if hero:GetUnitName() == "npc_dota_hero_drow_ranger" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_DROW_RANGER["drow_ranger_immortal"] then
				hero.base_attack_projectile = "particles/econ/items/drow/drow_ti9_immortal/drow_ti9_base_attack.vpcf"
				hero.frost_arrows_debuff_pfx = "particles/econ/items/drow/drow_ti9_immortal/drow_ti9_frost_arrow_debuff.vpcf"
				hero.marksmanship_arrow_pfx = "particles/econ/items/drow/drow_ti9_immortal/drow_ti9_marksman.vpcf"
				hero.marksmanship_frost_arrow_pfx = "particles/econ/items/drow/drow_ti9_immortal/drow_ti9_marksman_frost.vpcf"
				hero:SetRangedProjectileName("particles/econ/items/drow/drow_ti9_immortal/drow_ti9_base_attack.vpcf")

				Wearable:_WearProp(hero, "12946", "weapon")

				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
			end
		elseif hero:GetUnitName() == "npc_dota_hero_earthshaker" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_EARTHSHAKER["earthshaker_immortal"] then
				hero.fissure_pfx = "particles/econ/items/earthshaker/earthshaker_ti9/earthshaker_fissure_ti9.vpcf"

				Wearable:_WearProp(hero, "12969", "weapon")
				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
			end

			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_EARTHSHAKER["earthshaker_arcana2"] then
				hero.enchant_totem_leap_blur_pfx = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_leap_v2.vpcf"
				hero.enchant_totem_buff_pfx = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_buff.vpcf"
				hero.enchant_totem_cast_pfx = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_cast_v2.vpcf"
				hero.aftershock_pfx = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock_v2.vpcf"
				hero.echo_slam_start_pfx = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_start_v2.vpcf"
				hero.echo_slam_tgt_pfx = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_ground_v2.vpcf"
				hero.echo_slam_pfx = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_proj_v2.vpcf"

				hero.blink_effect = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_start_v2.vpcf"
				hero.blink_effect_end = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_end_v2.vpcf"
				hero.blink_icon = "earthshaker2"
				hero.blink_sound = "Hero_Earthshaker.BlinkDagger.Arcana"

				Wearable:_WearProp(hero, "12692", "head", "02")
				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {style = 2})
			elseif Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_EARTHSHAKER["earthshaker_arcana"] then
				hero.enchant_totem_leap_blur_pfx = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_leap.vpcf"
				hero.enchant_totem_buff_pfx = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_buff.vpcf"
				hero.enchant_totem_cast_pfx = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_cast.vpcf"
				hero.aftershock_pfx = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock.vpcf"
				hero.echo_slam_start_pfx = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_start.vpcf"
				hero.echo_slam_tgt_pfx = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_ground.vpcf"
				hero.echo_slam_pfx = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_proj.vpcf"

				hero.blink_effect = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_start.vpcf"
				hero.blink_effect_end = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_end.vpcf"
				hero.blink_icon = "earthshaker"
				hero.blink_sound = "Hero_Earthshaker.BlinkDagger.Arcana"

				Wearable:_WearProp(hero, "12692", "head")
				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {style = 1})
				-- not used atm
--				if not hero:HasModifier("modifier_earthshaker_arcana") then -- need to change name, this is the vanilla modifier name
--					hero:AddNewModifier(hero, nil, "modifier_earthshaker_arcana", {})
--				end
			end
		elseif hero:GetUnitName() == "npc_dota_hero_enigma" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_ENIGMA["enigma_immortal"] then
				Wearable:_WearProp(hero, "8326", "arms")

				hero.black_hole_effect = "particles/hero/enigma/enigma_blackhole_ti5_scaleable.vpcf"
				hero.black_hole_sound = "Imba.EnigmaBlackHoleTi5"
				hero.black_hole_icon = 1
			elseif Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_ENIGMA["enigma_mythical"] then
				Wearable:_WearProp(hero, "12329", "arms")
				Wearable:_WearProp(hero, "12330", "armor")
				Wearable:_WearProp(hero, "12332", "head")
				hero.eidolon_model = "models/items/enigma/eidolon/absolute_zero_updated_eidolon/absolute_zero_updated_eidolon.vmdl"
			end
		elseif hero:GetUnitName() == "npc_dota_hero_huskar" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_HUSKAR["huskar_immortal"] then
				Wearable:_WearProp(hero, "8188", "head")
				hero.life_break_cast_effect = "particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_lifebreak_cast.vpcf"
				hero.life_break_start_effect = "particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_lifebreak_spellstart.vpcf"
				hero.life_break_effect = "particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_life_break.vpcf"
				hero.life_break_icon = 1
			end
		elseif hero:GetUnitName() == "npc_dota_hero_invoker" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_INVOKER["invoker_legendary"] then
				Wearable:_WearProp(hero, "13042", "persona_selector")
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
					hero.omni_slash_hit_effect = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_tgt.vpcf"
					hero.omni_slash_trail_effect = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_trail.vpcf"
					hero.omni_slash_dash_effect = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_dash.vpcf"
					hero.omni_slash_status_effect = "particles/econ/items/juggernaut/jugg_arcana/status_effect_jugg_arcana_omni.vpcf"
					hero.omni_slash_end = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_end.vpcf"
					hero.arcana_trigger_effect = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_trigger.vpcf"
					hero.omni_slash_light = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omnislash_light.vpcf"
				elseif style == 1 then
					hero.blade_fury_effect = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_blade_fury.vpcf"
					hero.blade_dance_effect = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_crit_tgt.vpcf"
					hero.omni_slash_hit_effect = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_tgt.vpcf"
					hero.omni_slash_trail_effect = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_trail.vpcf"
					hero.omni_slash_dash_effect = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_dash.vpcf"
					hero.omni_slash_status_effect = "particles/econ/items/juggernaut/jugg_arcana/status_effect_jugg_arcana_v2_omni.vpcf"
					hero.omni_slash_end = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_end.vpcf"
					hero.arcana_trigger_effect = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_trigger.vpcf"
					hero.omni_slash_light = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omnislash_light.vpcf"
				end

				hero.blade_dance_sound = "Hero_Juggernaut.BladeDance.Arcana"

				hero:AddNewModifier(hero, nil, "modifier_juggernaut_arcana", {})
				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {style = style})
				Wearable:_WearProp(hero, "9059", "head", style)
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
		elseif hero:GetUnitName() == "npc_dota_hero_pudge" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_PUDGE["pudge_arcana"] then
				local style = 0
				if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_PUDGE["pudge_arcana2"] then
					style = 1
				end

				Wearable:_WearProp(hero, "7756", "back", style)

				-- custom icons
				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {style = style})
			end

			hero.hook_pfx = "particles/units/heroes/hero_pudge/pudge_meathook.vpcf"

			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_PUDGE["pudge_immortal"] then
				hero.hook_pfx = "particles/econ/items/pudge/pudge_dragonclaw/pudge_meathook_dragonclaw_imba.vpcf"
				Wearable:_WearProp(hero, "4007", "weapon")
			end
		elseif hero:GetUnitName() == "npc_dota_hero_skywrath_mage" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_SKYWRATH_MAGE["skywrath_mage_immortal2"] then
				hero.arcane_bolt_pfx = "particles/econ/items/skywrath_mage/skywrath_ti9_immortal_back/skywrath_mage_ti9_arcane_bolt_golden.vpcf"

				Wearable:_WearProp(hero, "12993", "back")

				-- custom icons
				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {style = 1})
			elseif Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_SKYWRATH_MAGE["skywrath_mage_immortal"] then
				hero.arcane_bolt_pfx = "particles/econ/items/skywrath_mage/skywrath_ti9_immortal_back/skywrath_mage_ti9_arcane_bolt.vpcf"

				Wearable:_WearProp(hero, "12926", "back")

				-- custom icons
				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
			end
--]]
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
		elseif hero:GetUnitName() == "npc_dota_hero_vengefulspirit" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_VENGEFULSPIRIT["vengefulspirit_immortal"] then
				Wearable:_WearProp(hero, "9749", "back")
				hero.magic_missile_effect = "particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_magic_missle.vpcf"
				hero.magic_missile_icon = 1
				hero.magic_missile_sound = "Hero_VengefulSpirit.MagicMissile.TI8"
				hero.magic_missile_sound_hit = "Hero_VengefulSpirit.MagicMissileImpact.TI8"
			end
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
