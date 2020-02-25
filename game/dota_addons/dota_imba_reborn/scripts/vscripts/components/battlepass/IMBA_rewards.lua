BATTLEPASS_LEVEL_REWARD = {}
BATTLEPASS_LEVEL_REWARD[2]		= {"vengefulspirit_taunt", "immortal"}
BATTLEPASS_LEVEL_REWARD[6]		= {"bristleback_rare", "rare"}
BATTLEPASS_LEVEL_REWARD[7]		= {"slark_taunt", "immortal"}
-- BATTLEPASS_LEVEL_REWARD[10]		= {"sohei_arcana", "arcana"}
BATTLEPASS_LEVEL_REWARD[11]		= {"chen_mythical", "mythical"}
BATTLEPASS_LEVEL_REWARD[14]		= {"alchemist_taunt", "immortal"}
BATTLEPASS_LEVEL_REWARD[15]		= {"vengefulspirit_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[23]		= {"enigma_taunt", "rare"}
BATTLEPASS_LEVEL_REWARD[28]		= {"dark_seer_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[33]		= {"skywrath_mage_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[38]		= {"lion_taunt", "immortal"}
BATTLEPASS_LEVEL_REWARD[39]		= {"bristleback_rare2", "rare"}
BATTLEPASS_LEVEL_REWARD[46]		= {"nyx_assassin_immortal", "immortal"}
-- BATTLEPASS_LEVEL_REWARD[50]	= {"tidehunter_ancient", "ancient"}
BATTLEPASS_LEVEL_REWARD[52]		= {"enigma_mythical", "mythical"}
BATTLEPASS_LEVEL_REWARD[55]		= {"lina_arcana", "arcana"}
BATTLEPASS_LEVEL_REWARD[56]		= {"huskar_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[60]		= {"sheepstick", "common"}
BATTLEPASS_LEVEL_REWARD[62]		= {"dark_willow_taunt", "immortal"}
BATTLEPASS_LEVEL_REWARD[65]		= {"juggernaut_arcana", "arcana"}
BATTLEPASS_LEVEL_REWARD[68]		= {"axe_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[71]		= {"zuus_taunt", "mythical"}
BATTLEPASS_LEVEL_REWARD[75]		= {"pudge_arcana", "arcana"}
BATTLEPASS_LEVEL_REWARD[84]		= {"pangolier_taunt", "immortal"}
BATTLEPASS_LEVEL_REWARD[95]		= {"furion_taunt", "immortal"}
BATTLEPASS_LEVEL_REWARD[97]		= {"life_stealer_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[106]	= {"death_prophet_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[110]	= {"invoker_taunt", "immortal"}
BATTLEPASS_LEVEL_REWARD[115]	= {"pudge_arcana2", "arcana"}
BATTLEPASS_LEVEL_REWARD[116]	= {"centaur_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[125]	= {"juggernaut_arcana2", "arcana"}
BATTLEPASS_LEVEL_REWARD[128]	= {"dark_seer_immortal2", "immortal"}
BATTLEPASS_LEVEL_REWARD[133]	= {"skywrath_mage_immortal2", "immortal"}
BATTLEPASS_LEVEL_REWARD[135]	= {"phantom_assassin_arcana", "arcana"}
BATTLEPASS_LEVEL_REWARD[145]	= {"wisp_arcana", "arcana"}
BATTLEPASS_LEVEL_REWARD[146]	= {"earthshaker_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[152]	= {"leshrac_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[165]	= {"earthshaker_arcana", "arcana"}
BATTLEPASS_LEVEL_REWARD[170]	= {"enigma_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[180]	= {"drow_ranger_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[190]	= {"tiny_immortal", "immortal"}
if IsInToolsMode() then
--	BATTLEPASS_LEVEL_REWARD[195]	= {"terrorblade_arcana", "arcana"}
	BATTLEPASS_LEVEL_REWARD[195]	= {"nevermore_arcana", "arcana"}
end
BATTLEPASS_LEVEL_REWARD[197]	= {"life_stealer_immortal2", "immortal"}
BATTLEPASS_LEVEL_REWARD[225]	= {"invoker_legendary", "legendary"}
BATTLEPASS_LEVEL_REWARD[265]	= {"earthshaker_arcana2", "arcana"}
BATTLEPASS_LEVEL_REWARD[275]	= {"leshrac_taunt", "immortal"}
BATTLEPASS_LEVEL_REWARD[280]	= {"pudge_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[295]	= {"windrunner_taunt", "immortal"}
-- BATTLEPASS_LEVEL_REWARD[310]	= {"dragon_knight_mythical", "mythical"}
BATTLEPASS_LEVEL_REWARD[400]	= {"ursa_immortal", "immortal"}

CustomNetTables:SetTableValue("game_options", "battlepass", {battlepass = BATTLEPASS_LEVEL_REWARD})

function Battlepass:Init()
	BattlepassHeroes = {}
	BattlepassHeroes["ancient_apparition"] = {}
	BattlepassHeroes["axe"] = {}
	BattlepassHeroes["bristleback"] = {}
	BattlepassHeroes["centaur"] = {}
	BattlepassHeroes["chen"] = {}
	BattlepassHeroes["dark_seer"] = {}
	BattlepassHeroes["death_prophet"] = {}
	BattlepassHeroes["drow_ranger"] = {}
	BattlepassHeroes["earthshaker"] = {}
	BattlepassHeroes["enigma"] = {}
	BattlepassHeroes["huskar"] = {}
	BattlepassHeroes["invoker"] = {}
	BattlepassHeroes["juggernaut"] = {}
	BattlepassHeroes["leshrac"] = {}
	BattlepassHeroes["life_stealer"] = {}
	BattlepassHeroes["lina"] = {}
	if IsInToolsMode() then
		BattlepassHeroes["nevermore"] = {}
	end
	BattlepassHeroes["nyx_assassin"] = {}
	BattlepassHeroes["phantom_assassin"] = {}
	BattlepassHeroes["pudge"] = {}
	BattlepassHeroes["skywrath_mage"] = {}
--	BattlepassHeroes["terrorblade"] = {}
--	BattlepassHeroes["tidehunter"] = {}
	BattlepassHeroes["tiny"] = {}
	BattlepassHeroes["ursa"] = {}
	BattlepassHeroes["vengefulspirit"] = {}
	BattlepassHeroes["wisp"] = {}
	BattlepassHeroes["zuus"] = {}

	-- used to add a hero icon in BP reward windows
	CustomNetTables:SetTableValue("battlepass", "hero_rewards", BattlepassHeroes)

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

function Battlepass:GetBlinkEffect(ID)
	local effect_table = {}
	effect_table[1] = "particles/items_fx/blink_dagger_start.vpcf"
	effect_table[2] = "particles/items_fx/blink_dagger_end.vpcf"

	-- todo: http request to get equipped effect

	return effect_table
end

function Battlepass:GetBottleEffect(ID)
	local effect_table = {}
	effect_table[1] = "particles/items_fx/bottle.vpcf"

	-- todo: http request to get equipped effect

	return effect_table
end

function Battlepass:GetForceStaffEffect(ID)
	local effect_table = {}
	effect_table[1] = "particles/items_fx/force_staff.vpcf"

	-- todo: http request to get equipped effect

	return effect_table
end

function Battlepass:GetFountainEffect(ID)
	local effect_table = {}
	effect_table[1] = "particles/generic_gameplay/radiant_fountain_regen.vpcf"

	-- todo: http request to get equipped effect

	return effect_table
end

function Battlepass:GetMaelstormEffect(ID)
	local effect_table = {}
	effect_table[1] = "particles/items2_fx/mjollnir_shield.vpcf"
	effect_table[2] = "particles/item/mjollnir/static_lightning_bolt.vpcf"
	effect_table[3] = "particles/items_fx/chain_lightning.vpcf"

	-- todo: http request to get equipped effect

	return effect_table
end

function Battlepass:GetMekansmEffect(ID)
	local effect_table = {}
	effect_table[1] = "particles/items2_fx/mekanism.vpcf"
	effect_table[2] = "particles/items2_fx/mekanism_recipient.vpcf"
	effect_table[3] = "particles/items3_fx/warmage.vpcf"
	effect_table[4] = "particles/items3_fx/warmage_recipient.vpcf"
	effect_table[5] = "particles/items3_fx/warmage_mana_nonhero.vpcf"

	-- todo: http request to get equipped effect

	return effect_table
end

function Battlepass:GetRadianceEffect(ID)
	local effect_table = {}
	effect_table[1] = "particles/items2_fx/radiance_owner.vpcf"
	effect_table[2] = "particles/items2_fx/radiance.vpcf"

	-- todo: http request to get equipped effect

	return effect_table
end

function Battlepass:GetSheepstickEffect(ID)
	local effect_table = {}
	effect_table[1] = "particles/items_fx/item_sheepstick.vpcf"
	effect_table[2] = "models/props_gameplay/pig.vmdl"

	-- todo: http request to get equipped effect

	return effect_table
end

function Battlepass:GetShivaEffect(ID)
	local effect_table = {}
	effect_table[1] = "particles/items2_fx/shivas_guard_active.vpcf"
	effect_table[2] = "particles/items2_fx/shivas_guard_impact.vpcf"

	-- todo: http request to get equipped effect

	return effect_table
end

function Battlepass:SetItemEffects(ID)
	CustomNetTables:SetTableValue("battlepass_item_effects", tostring(ID), {
		blink = Battlepass:GetBlinkEffect(ID),
		bottle = Battlepass:GetBottleEffect(ID),
		force_staff = Battlepass:GetForceStaffEffect(ID),
		fountain = Battlepass:GetFountainEffect(ID),
		maelstorm = Battlepass:GetMaelstormEffect(ID),
		mekansm = Battlepass:GetMekansmEffect(ID),
		radiance = Battlepass:GetRadianceEffect(ID),
		sheepstick = Battlepass:GetSheepstickEffect(ID),
		shiva = Battlepass:GetShivaEffect(ID),
	})
end

local function failduh()
	print("CALLBACK FAIL")
end

-- todo: use values in items_game.txt instead
function Battlepass:GetHeroEffect(hero)
	if hero:GetUnitName() == "npc_dota_hero_axe" then
		hero.pre_attack_sound = "Hero_Axe.PreAttack"
		hero.attack_sound = "Hero_Axe.Attack"
		hero.counter_helix_pfx = "particles/units/heroes/hero_axe/axe_attack_blur_counterhelix.vpcf"
		hero.culling_blade_kill_pfx = "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
		hero.culling_blade_boost_pfx = "particles/units/heroes/hero_axe/axe_culling_blade_boost.vpcf"
		hero.culling_blade_sprint_pfx = "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf"
	elseif hero:GetUnitName() == "npc_dota_hero_centaur" then
		hero.double_edge_pfx = "particles/units/heroes/hero_centaur/centaur_double_edge.vpcf"
		hero.double_edge_body_pfx = "particles/units/heroes/hero_centaur/centaur_double_edge_body.vpcf"
		hero.double_edge_phase_pfx = "particles/units/heroes/hero_centaur/centaur_double_edge_phase.vpcf"
	elseif hero:GetUnitName() == "npc_dota_hero_dark_seer" then
		hero.ion_shell_effect = "particles/units/heroes/hero_dark_seer/dark_seer_ion_shell.vpcf"
		hero.ion_shell_damage_effect = "particles/units/heroes/hero_dark_seer/dark_seer_ion_shell_damage.vpcf"
		hero.ion_shell_sound = "Hero_Dark_Seer.Ion_Shield_Start"
		hero.ion_shell_end_sound = "Hero_Dark_Seer.Ion_Shield_end"
	elseif hero:GetUnitName() == "npc_dota_hero_death_prophet" then
		CustomNetTables:SetTableValue("battlepass", "death_prophet", {
			silence = "particles/units/heroes/hero_death_prophet/death_prophet_silence.vpcf",
			silence_impact = "particles/units/heroes/hero_death_prophet/death_prophet_silence_impact.vpcf",
			silence_overhead = "particles/generic_gameplay/generic_silenced.vpcf",
			silence_custom = "particles/units/heroes/hero_death_prophet/death_prophet_silence_custom.vpcf",
		})
	elseif hero:GetUnitName() == "npc_dota_hero_drow_ranger" then
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
	elseif hero:GetUnitName() == "npc_dota_hero_invoker" then
		hero.quas_attack = "particles/units/heroes/hero_invoker/invoker_base_attack.vpcf"
		hero.wex_attack = "particles/units/heroes/hero_invoker/invoker_base_attack.vpcf"
		hero.exort_attack = "particles/units/heroes/hero_invoker/invoker_base_attack.vpcf"
		hero.all_attack = "particles/units/heroes/hero_invoker/invoker_base_attack.vpcf"

		hero.quas_orb = "particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf"
		hero.wex_orb = "particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf"
		hero.exort_orb = "particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf"
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
	elseif hero:GetUnitName() == "npc_dota_hero_life_stealer" then
		CustomNetTables:SetTableValue("battlepass", "life_stealer", {
			open_wounds_impact = "particles/units/heroes/hero_life_stealer/life_stealer_open_wounds_impact.vpcf",
			open_wounds = "particles/units/heroes/hero_life_stealer/life_stealer_open_wounds.vpcf",
			open_wounds_status_effect = "particles/status_fx/status_effect_life_stealer_open_wounds.vpcf",
		})
	elseif hero:GetUnitName() == "npc_dota_hero_nyx_assassin" then
		hero.spiked_carapace_pfx = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace.vpcf"
		hero.spiked_carapace_debuff_pfx = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace_hit.vpcf"
	elseif hero:GetUnitName() == "npc_dota_hero_phantom_assassin" then
		hero.stifling_dagger_effect = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf"
		hero.stifling_dagger_debuff_effect = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_debuff.vpcf"
		hero.stifling_dagger_silence_effect = "particles/generic_gameplay/generic_silenced.vpcf"

		hero.phantom_strike_start_effect = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_start.vpcf"
		hero.phantom_strike_end_effect = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end.vpcf"

		hero.fatality_screen_blood_splatter = "particles/hero/phantom_assassin/screen_blood_splatter.vpcf"
		hero.coup_de_grace_crit_effect = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"

		hero.coup_de_grace_sound = "Hero_PhantomAssassin.CoupDeGrace"
	elseif hero:GetUnitName() == "npc_dota_hero_skywrath_mage" then
		hero.arcane_bolt_pfx = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf"
	elseif hero:GetUnitName() == "npc_dota_hero_terrorblade" then

	elseif hero:GetUnitName() == "npc_dota_hero_tiny" then
		hero.ambient_pfx_effect = "particles/units/heroes/hero_tiny/tiny_ambient.vpcf"
		hero.death_pfx = "particles/units/heroes/hero_tiny/tiny01_death.vpcf"

		hero.avalanche_effect = "particles/units/heroes/hero_tiny/tiny_avalanche.vpcf"
		hero.avalance_projectile_effect = "particles/units/heroes/hero_tiny/tiny_avalanche_projectile.vpcf"

		hero.tree_model = "models/heroes/tiny_01/tiny_01_tree.vmdl"
		hero.tree_linear_effect = "particles/units/heroes/hero_tiny/tiny_tree_linear_proj.vpcf"
		hero.tree_tracking_effect = "particles/units/heroes/hero_tiny/tiny_tree_proj.vpcf"
		hero.tree_ambient_effect = ""
		hero.tree_grab_sound = "Hero_Tiny.Tree.Grab"
		hero.tree_throw_sound = "Hero_Tiny.Tree.Throw"
		hero.tree_throw_target_sound = "Hero_Tiny.Tree.Target"
		hero.tree_channel_target_sound = "Hero_Tiny.TreeChannel.Target"

		hero.grow_effect = "particles/units/heroes/hero_tiny/tiny_transform.vpcf"

		hero.tree_cleave_effect = "particles/units/heroes/hero_tiny/tiny_craggy_cleave.vpcf"
	elseif hero:GetUnitName() == "npc_dota_hero_wisp" then
		hero.tether_effect = "particles/units/heroes/hero_wisp/wisp_tether.vpcf"
		hero.spirits_effect = "particles/units/heroes/hero_wisp/wisp_guardian.vpcf"
		hero.spirits_explosion_effect = "particles/units/heroes/hero_wisp/wisp_guardian_explosion.vpcf"
		hero.spirits_explosion_small_effect = "particles/units/heroes/hero_wisp/wisp_guardian_explosion_small.vpcf"
		hero.overcharge_effect = "particles/units/heroes/hero_wisp/wisp_overcharge.vpcf"
		hero.relocate_channel_effect = "particles/units/heroes/hero_wisp/wisp_relocate_channel.vpcf"
		hero.relocate_marker_effect = "particles/units/heroes/hero_wisp/wisp_relocate_marker.vpcf"
		hero.relocate_teleport_effect = "particles/units/heroes/hero_wisp/wisp_relocate_teleport.vpcf"
		hero.relocate_teleport_out_effect = "particles/units/heroes/hero_wisp/wisp_relocate_teleport_out.vpcf"
		hero.relocate_marker_endpoint_effect = "particles/units/heroes/hero_wisp/wisp_relocate_marker_endpoint.vpcf"
		hero.death_effect = "particles/units/heroes/hero_wisp/wisp_death.vpcf"
		hero.relocate_timer_buff = "particles/units/heroes/hero_wisp/wisp_relocate_timer_buff.vpcf"

		hero.relocate_sound = "Hero_Wisp.Relocate"
		hero.relocate_return_in_sound = "Hero_Wisp.Return"
		hero.relocate_return_out_sound = "Hero_Wisp.TeleportOut"
	end

	local ply_table = CustomNetTables:GetTableValue("battlepass", tostring(hero:GetPlayerID()))

	if ply_table and ply_table.bp_rewards == 0 then
		return
	end

	-- todo: http request to get which item_id is equipped for the hero
	if tostring(PlayerResource:GetSteamID(hero:GetPlayerID())) ~= "0" then
		local payload = {
			steamid = tostring(PlayerResource:GetSteamID(hero:GetPlayerID())),
			hero = hero:GetUnitName(),
		}

		print("Payload:", payload)

		api:Request("armory", function(data)
			print(data)

			for k, v in pairs(data) do
				Wearable:_WearProp(hero, v.item_id, v.slot_id)

--				print(ItemsGame.kv["items"][v.item_id])
				if ItemsGame.kv["items"][v.item_id] and ItemsGame.kv["items"][v.item_id]["visuals"] then
--					print(ItemsGame.kv["items"][v.item_id]["visuals"])

					for i, j in pairs(ItemsGame.kv["items"][v.item_id]["visuals"]) do
						if not string.find(i, "skip") then
							if j.type == "particle" then
								local particle_table = {}
								particle_table.asset = j.asset
								particle_table.modifier = j.modifier
								particle_table.parent = hero

								table.insert(CScriptParticleManager.PARTICLES_OVERRIDE, particle_table)
							elseif j.type == "sound" then
								local sound_table = {}
								sound_table.asset = j.asset
								sound_table.modifier = j.modifier
								sound_table.parent = hero

								table.insert(CDOTA_BaseNPC.SOUNDS_OVERRIDE, sound_table)
							elseif j.type == "ability_icon" then
								CustomNetTables:SetTableValue("battlepass", j.asset..'_'..hero:GetPlayerID(), {j.modifier}) 
							elseif j.type == "icon_replacement_hero" then
								CustomGameEventManager:Send_ServerToAllClients("override_hero_image", {
									player_id = hero:GetPlayerID(),
									icon_path = j.modifier,
								})
							end
						end
					end
				end
			end

--			print(CustomNetTables:GetTableValue("battlepass_item_effects", tostring(hero:GetPlayerID())))
		end, failduh(), "POST", payload);
	end

	local hello = false

	if hello == false then return end

--	print(CScriptParticleManager.PARTICLES_OVERRIDE)
--	print("---------------------------------")
--	print(CDOTA_BaseNPC.SOUNDS_OVERRIDE)

	if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) ~= nil then
		local short_name = string.gsub(hero:GetUnitName(), "npc_dota_hero_", "")

		if hero:GetUnitName() == "npc_dota_hero_axe" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["axe_immortal"] then
				LinkLuaModifier("modifier_axe_arcana", "components/abilities/heroes/hero_axe", LUA_MODIFIER_MOTION_NONE)

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
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["bristleback_rare2"] then
				Wearable:_WearProp(hero, "9786", "back", "1")
				Wearable:_WearProp(hero, "9787", "arms", "1")
				Wearable:_WearProp(hero, "9788", "head", "1")
				Wearable:_WearProp(hero, "9789", "neck", "1")
				Wearable:_WearProp(hero, "9790", "weapon", "1")
			elseif Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["bristleback_rare"] then
				Wearable:_WearProp(hero, "9786", "back", "0")
				Wearable:_WearProp(hero, "9787", "arms", "0")
				Wearable:_WearProp(hero, "9788", "head", "0")
				Wearable:_WearProp(hero, "9789", "neck", "0")
				Wearable:_WearProp(hero, "9790", "weapon", "0")
			end
		elseif hero:GetUnitName() == "npc_dota_hero_centaur" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["centaur_immortal"] then
				hero.double_edge_pfx = "particles/econ/items/centaur/centaur_ti9/centaur_double_edge_ti9.vpcf"
				hero.double_edge_body_pfx = "particles/econ/items/centaur/centaur_ti9/centaur_double_edge_body_ti9.vpcf"
				hero.double_edge_phase_pfx = "particles/econ/items/centaur/centaur_ti9/centaur_double_edge_phase_ti9.vpcf"

				Wearable:_WearProp(hero, "12945", "weapon")

				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
			end
		elseif hero:GetUnitName() == "npc_dota_hero_chen" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["chen_mythical"] then
				Wearable:_WearProp(hero, "9950", "head")
				Wearable:_WearProp(hero, "9951", "weapon")
				Wearable:_WearProp(hero, "9952", "mount")
				Wearable:_WearProp(hero, "9953", "shoulder")
				Wearable:_WearProp(hero, "9954", "arms")
			end
		elseif hero:GetUnitName() == "npc_dota_hero_dark_seer" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["dark_seer_immortal2"] then
				Wearable:_WearProp(hero, "12299", "arms")
				hero.ion_shell_effect = "particles/econ/items/dark_seer/dark_seer_ti8_immortal_arms/dark_seer_ti8_immortal_ion_shell_golden.vpcf"
				hero.ion_shell_damage_effect = "particles/econ/items/dark_seer/dark_seer_ti8_immortal_arms/dark_seer_ti8_immortal_ion_shell_dmg_golden.vpcf"
				hero.ion_shell_icon = 2
				hero.ion_shell_sound = "Hero_Dark_Seer.Ion_Shield_Start.TI8"
				hero.ion_shell_end_sound = "Hero_Dark_Seer.Ion_Shield_end.TI8"
			elseif Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["dark_seer_immortal"] then
				Wearable:_WearProp(hero, "9740", "arms")
				hero.ion_shell_effect = "particles/econ/items/dark_seer/dark_seer_ti8_immortal_arms/dark_seer_ti8_immortal_ion_shell.vpcf"
				hero.ion_shell_damage_effect = "particles/econ/items/dark_seer/dark_seer_ti8_immortal_arms/dark_seer_ti8_immortal_ion_shell_dmg.vpcf"
				hero.ion_shell_icon = 1
				hero.ion_shell_sound = "Hero_Dark_Seer.Ion_Shield_Start.TI8"
				hero.ion_shell_end_sound = "Hero_Dark_Seer.Ion_Shield_end.TI8"
			end
		elseif hero:GetUnitName() == "npc_dota_hero_death_prophet" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["death_prophet_immortal"] then
				CustomNetTables:SetTableValue("battlepass", "death_prophet", {
					silence = "particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_ti9.vpcf",
					silence_impact = "particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_impact_ti9.vpcf",
					silence_overhead = "particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_custom_ti9_overhead_model.vpcf",
					silence_custom = "particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_custom_ti9.vpcf",
				})

				Wearable:_WearProp(hero, "12931", "head")

				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
			end
		elseif hero:GetUnitName() == "npc_dota_hero_drow_ranger" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["drow_ranger_immortal"] then
				hero.base_attack_projectile = "particles/econ/items/drow/drow_ti9_immortal/drow_ti9_base_attack.vpcf"
				hero.frost_arrows_debuff_pfx = "particles/econ/items/drow/drow_ti9_immortal/drow_ti9_frost_arrow_debuff.vpcf"
				hero.marksmanship_arrow_pfx = "particles/econ/items/drow/drow_ti9_immortal/drow_ti9_marksman.vpcf"
				hero.marksmanship_frost_arrow_pfx = "particles/econ/items/drow/drow_ti9_immortal/drow_ti9_marksman_frost.vpcf"
				hero:SetRangedProjectileName("particles/econ/items/drow/drow_ti9_immortal/drow_ti9_base_attack.vpcf")

				Wearable:_WearProp(hero, "12946", "weapon")

				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
			end
		elseif hero:GetUnitName() == "npc_dota_hero_earthshaker" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["earthshaker_immortal"] then
				hero.fissure_pfx = "particles/econ/items/earthshaker/earthshaker_ti9/earthshaker_fissure_ti9.vpcf"

				Wearable:_WearProp(hero, "12969", "weapon")
				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
			end

			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["earthshaker_arcana2"] then
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
			elseif Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["earthshaker_arcana"] then
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
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["enigma_immortal"] then
				Wearable:_WearProp(hero, "8326", "arms")

				hero.black_hole_effect = "particles/hero/enigma/enigma_blackhole_ti5_scaleable.vpcf"
				hero.black_hole_sound = "Imba.EnigmaBlackHoleTi5"
				hero.black_hole_icon = 1
			elseif Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["enigma_mythical"] then
				Wearable:_WearProp(hero, "12329", "arms")
				Wearable:_WearProp(hero, "12330", "armor")
				Wearable:_WearProp(hero, "12332", "head")
				hero.eidolon_model = "models/items/enigma/eidolon/absolute_zero_updated_eidolon/absolute_zero_updated_eidolon.vmdl"
			end
		elseif hero:GetUnitName() == "npc_dota_hero_huskar" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["huskar_immortal"] then
				Wearable:_WearProp(hero, "8188", "head")
				hero.life_break_cast_effect = "particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_lifebreak_cast.vpcf"
				hero.life_break_start_effect = "particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_lifebreak_spellstart.vpcf"
				hero.life_break_effect = "particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_life_break.vpcf"
				hero.life_break_icon = 1
			end
		elseif hero:GetUnitName() == "npc_dota_hero_invoker" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["invoker_legendary"] then
				Wearable:_WearProp(hero, "13042", "persona_selector")

				hero.quas_attack = "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_quas.vpcf"
				hero.wex_attack = "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_wex.vpcf"
				hero.exort_attack = "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_exort.vpcf"
				hero.all_attack = "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_all.vpcf"

				hero.quas_orb = "particles/units/heroes/hero_invoker_kid/invoker_kid_quas_orb.vpcf"
				hero.wex_orb = "particles/units/heroes/hero_invoker_kid/invoker_kid_wex_orb.vpcf"
				hero.exort_orb = "particles/units/heroes/hero_invoker_kid/invoker_kid_exort_orb.vpcf"

				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
			end
		elseif hero:GetUnitName() == "npc_dota_hero_juggernaut" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["juggernaut_arcana"] then
				LinkLuaModifier("modifier_juggernaut_arcana", "components/abilities/heroes/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)

				local style = 0
				if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["juggernaut_arcana2"] then
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
		elseif hero:GetUnitName() == "npc_dota_hero_leshrac" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["leshrac_immortal"] then
				CustomNetTables:SetTableValue("battlepass", "leshrac", {
					diabolic_edict = "particles/econ/items/leshrac/leshrac_ti9_immortal_head/leshrac_ti9_immortal_edict.vpcf",
				})

				Wearable:_WearProp(hero, "12933", "head")

				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {style = 1})
			end
		elseif hero:GetUnitName() == "npc_dota_hero_life_stealer" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["life_stealer_immortal2"] then
				CustomNetTables:SetTableValue("battlepass", "life_stealer", {
					open_wounds_impact = "particles/econ/items/lifestealer/ls_ti9_immortal_gold/ls_ti9_open_wounds_gold_impact.vpcf",
					open_wounds = "particles/econ/items/lifestealer/ls_ti9_immortal_gold/ls_ti9_open_wounds_gold.vpcf",
					open_wounds_status_effect = "particles/econ/items/lifestealer/ls_ti9_immortal_gold/status_effect_ls_ti9_open_wounds_gold.vpcf",
				})

				Wearable:_WearProp(hero, "12998", "weapon")

				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {style = 1})
			elseif Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["life_stealer_immortal"] then
				CustomNetTables:SetTableValue("battlepass", "life_stealer", {
					open_wounds_impact = "particles/econ/items/lifestealer/ls_ti9_immortal/ls_ti9_open_wounds_impact.vpcf",
					open_wounds = "particles/econ/items/lifestealer/ls_ti9_immortal/ls_ti9_open_wounds.vpcf",
					open_wounds_status_effect = "particles/econ/items/lifestealer/ls_ti9_immortal/status_effect_ls_ti9_open_wounds.vpcf",
				})

				Wearable:_WearProp(hero, "12934", "weapon")

				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
			end
		elseif hero:GetUnitName() == "npc_dota_hero_lina" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["lina_arcana"] then
				Wearable:_WearProp(hero, "4794", "head")

				hero.dragon_slave_effect = "particles/econ/items/lina/lina_head_headflame/lina_spell_dragon_slave_headflame.vpcf"
				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
			end
		elseif hero:GetUnitName() == "npc_dota_hero_nevermore" then
			if IsInToolsMode() then
				if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["nevermore_arcana"] then
					Wearable:_WearProp(hero, "6996", "head")
				end
			end
		elseif hero:GetUnitName() == "npc_dota_hero_nyx_assassin" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["nyx_assassin_immortal"] then
				hero.spiked_carapace_pfx = "particles/econ/items/nyx_assassin/nyx_ti9_immortal/nyx_ti9_carapace.vpcf"
				hero.spiked_carapace_debuff_pfx = "particles/econ/items/nyx_assassin/nyx_ti9_immortal/nyx_ti9_carapace_hit.vpcf"

				Wearable:_WearProp(hero, "12957", "back")
			end

			-- custom icons
			hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
		elseif hero:GetUnitName() == "npc_dota_hero_phantom_assassin" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["phantom_assassin_arcana"] then
				LinkLuaModifier("modifier_phantom_assassin_arcana", "components/abilities/heroes/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)

				hero.stifling_dagger_effect = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_stifling_dagger_arcana.vpcf"
				hero.stifling_dagger_debuff_effect = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_stifling_dagger_debuff_arcana.vpcf"
				hero.stifling_dagger_silence_effect = "particles/econ/items/storm_spirit/storm_spirit_orchid_hat/storm_orchid_silenced.vpcf"

				hero.phantom_strike_start_effect = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_start.vpcf"
				hero.phantom_strike_end_effect = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_end.vpcf"

				hero.fatality_screen_blood_splatter = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_screen_blood_splatter.vpcf"
				hero.coup_de_grace_crit_effect = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop.vpcf"

				hero.coup_de_grace_sound = "Hero_PhantomAssassin.CoupDeGrace.Arcana"

				local style = 0
--				print("Arcana kills:")
				local pa_arcana_kills = api:GetPhantomAssassinArcanaKills(hero:GetPlayerID()) or 0
--				print(pa_arcana_kills)
				hero:AddNewModifier(hero, nil, "modifier_phantom_assassin_arcana", {}):SetStackCount(tonumber(pa_arcana_kills))

				if tonumber(pa_arcana_kills) >= 400 then
					style = 1
				elseif tonumber(pa_arcana_kills) >= 1000 then
					style = 2
				end

				Wearable:_WearProp(hero, "7247", "weapon", style)

				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
			end
		elseif hero:GetUnitName() == "npc_dota_hero_pudge" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["pudge_arcana"] then
				local style = 0
				if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["pudge_arcana2"] then
					style = 1
				end

				Wearable:_WearProp(hero, "7756", "back", style)

				-- custom icons
				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {style = style})
			end

			hero.hook_pfx = "particles/units/heroes/hero_pudge/pudge_meathook.vpcf"

			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["pudge_immortal"] then
				hero.hook_pfx = "particles/econ/items/pudge/pudge_dragonclaw/pudge_meathook_dragonclaw_imba.vpcf"
				Wearable:_WearProp(hero, "4007", "weapon")
			end
		elseif hero:GetUnitName() == "npc_dota_hero_skywrath_mage" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["skywrath_mage_immortal2"] then
				hero.arcane_bolt_pfx = "particles/econ/items/skywrath_mage/skywrath_ti9_immortal_back/skywrath_mage_ti9_arcane_bolt_golden.vpcf"

				Wearable:_WearProp(hero, "12993", "back")

				-- custom icons
				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {style = 1})
			elseif Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["skywrath_mage_immortal"] then
				hero.arcane_bolt_pfx = "particles/econ/items/skywrath_mage/skywrath_ti9_immortal_back/skywrath_mage_ti9_arcane_bolt.vpcf"

				Wearable:_WearProp(hero, "12926", "back")

				-- custom icons
				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
			end
		elseif hero:GetUnitName() == "npc_dota_hero_terrorblade" then
			if IsInToolsMode() then
--				if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["terrorblade_arcana"] then
--					Wearable:_WearProp(hero, "5957", "head")
--				end
			end
--		elseif hero:GetUnitName() == "npc_dota_hero_tidehunter" then
--			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["tidehunter_ancient"] then
--				Wearable:RemoveWearables(hero)
--				hero.arms = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/tidehunter/Celth_AzhagTidehunter/tidehunter_arms_wh/tidehunter_arms_wh.vmdl"})
--				hero.back = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/tidehunter/Celth_AzhagTidehunter/tidehunter_back_wh/tidehunter_back_wh.vmdl"})
--				hero.belt = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/tidehunter/Celth_AzhagTidehunter/tidehunter_belt_wh/tidehunter_belt_wh.vmdl"})
--				hero.head = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/tidehunter/Celth_AzhagTidehunter/tidehunter_head_wh/tidehunter_head_wh.vmdl"})
--				hero.offhand = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/tidehunter/Celth_AzhagTidehunter/tidehunter_offhand_wh/tidehunter_offhand_wh.vmdl"})
--				hero.weapon = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/tidehunter/Celth_AzhagTidehunter/tidehunter_weapon_wh/tidehunter_weapon_wh.vmdl"})
--			end
		elseif hero:GetUnitName() == "npc_dota_hero_tiny" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["tiny_immortal"] then
				-- attempt to fix tree throw pfx being vanilla (whatever you have equipped in your armory). not fixing it
				Wearable:RemoveWearables(hero)

				hero.ambient_pfx_effect = "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl1_ambient.vpcf"
				hero.death_pfx = "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl1_death.vpcf"

				hero.avalanche_effect = "particles/econ/items/tiny/tiny_prestige/tiny_prestige_avalanche.vpcf"
				hero.avalance_projectile_effect = "particles/econ/items/tiny/tiny_prestige/tiny_prestige_avalanche_projectile.vpcf"

				hero.tree_model = "models/items/tiny/tiny_prestige/tiny_prestige_sword.vmdl"
				hero.tree_ambient_effect = "particles/econ/items/tiny/tiny_prestige/tiny_prestige_tree_ambient.vpcf"
				hero.tree_linear_effect = "particles/econ/items/tiny/tiny_prestige/tiny_prestige_tree_linear_proj.vpcf"
				hero.tree_tracking_effect = "particles/econ/items/tiny/tiny_prestige/tiny_prestige_tree_proj.vpcf"
				hero.tree_grab_sound = "Hero_Tiny.Prestige.Grab"
				hero.tree_throw_sound = "Hero_Tiny.Prestige.Throw"
				hero.tree_throw_target_sound = "Hero_Tiny.Prestige.Target"
				hero.tree_channel_target_sound = "Hero_Tiny.Prestige.Target"

				hero.grow_effect = "particles/econ/items/tiny/tiny_prestige/tiny_prestige_transform.vpcf"

				hero.tree_cleave_effect = "particles/econ/items/tiny/tiny_prestige/tiny_prestige_tree_melee_hit.vpcf"

				hero.is_storegga = true
				hero:SetModel("models/items/tiny/tiny_prestige/tiny_prestige_lvl_01.vmdl")
				hero:SetOriginalModel("models/items/tiny/tiny_prestige/tiny_prestige_lvl_01.vmdl")
				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
--				Wearable:_WearProp(hero, "13541", "weapon")

				hero.ambient_pfx = ParticleManager:CreateParticle(hero.ambient_pfx_effect, PATTACH_ABSORIGIN_FOLLOW, hero)
			end
		elseif hero:GetUnitName() == "npc_dota_hero_ursa" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["ursa_immortal"] then
				Wearable:_WearProp(hero, "4212", "head")
				Wearable:_WearProp(hero, "4213", "back")
				Wearable:_WearProp(hero, "4214", "belt")
				Wearable:_WearProp(hero, "4215", "arms")
			end
		elseif hero:GetUnitName() == "npc_dota_hero_vengefulspirit" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["vengefulspirit_immortal"] then
				Wearable:_WearProp(hero, "9749", "back")
				hero.magic_missile_effect = "particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_magic_missle.vpcf"
				hero.magic_missile_icon = 1
				hero.magic_missile_sound = "Hero_VengefulSpirit.MagicMissile.TI8"
				hero.magic_missile_sound_hit = "Hero_VengefulSpirit.MagicMissileImpact.TI8"
			end
		elseif hero:GetUnitName() == "npc_dota_hero_wisp" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["wisp_arcana"] then
				Wearable:_WearProp(hero, "9235", "head")

				hero.tether_effect = "particles/econ/items/wisp/wisp_tether_ti7.vpcf"
				hero.spirits_effect = "particles/econ/items/wisp/wisp_guardian_ti7.vpcf"
				hero.spirits_explosion_effect = "particles/econ/items/wisp/wisp_guardian_explosion_ti7.vpcf"
				hero.spirits_explosion_small_effect = "particles/econ/items/wisp/wisp_guardian_explosion_small_ti7.vpcf"
				hero.overcharge_effect = "particles/econ/items/wisp/wisp_overcharge_ti7.vpcf"
				hero.relocate_channel_effect = "particles/econ/items/wisp/wisp_relocate_channel_ti7.vpcf"
				hero.relocate_marker_effect = "particles/econ/items/wisp/wisp_relocate_marker_ti7.vpcf"
				hero.relocate_teleport_effect = "particles/econ/items/wisp/wisp_relocate_teleport_ti7.vpcf"
				hero.relocate_teleport_out_effect = "particles/econ/items/wisp/wisp_relocate_teleport_ti7_out.vpcf"
				hero.relocate_marker_endpoint_effect = "particles/econ/items/wisp/wisp_relocate_marker_ti7_endpoint.vpcf"
				hero.death_effect = "particles/econ/items/wisp/wisp_death_ti7.vpcf"
				hero.relocate_timer_buff = "particles/econ/items/wisp/wisp_relocate_timer_buff_ti7.vpcf"

				hero.relocate_sound = "Hero_Wisp.Relocate.Arc"
				hero.relocate_return_in_sound = "Hero_Wisp.Return.Arc"
				hero.relocate_return_out_sound = "Hero_Wisp.TeleportOut.Arc"

				hero.tether_icon = 1
				hero.spirits_icon = 1

				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
			end
		end
	end
end

function Battlepass:InitializeTowers()
	local radiant_level = 0
	local dire_level = 0

	for ID = 0, PlayerResource:GetPlayerCount() - 1 do
		if PlayerResource:GetPlayer(ID):GetTeamNumber() == 2 then
			radiant_level = radiant_level + Battlepass:GetRewardUnlocked(ID)
		else
			dire_level = dire_level + Battlepass:GetRewardUnlocked(ID)
		end
	end

	print("Team Battlepass Levels:", radiant_level, dire_level)

	local towers = Entities:FindAllByClassname("npc_dota_tower")

	for _, tower in pairs(towers) do
		local level = dire_level
		local particle = "particles/world_tower/tower_upgrade/ti7_dire_tower_orb.vpcf"
		local team = "dire"
--		local max_particle = "particles/world_tower/tower_upgrade/ti7_radiant_tower_lvl11_orb.vpcf"

		if tower:GetTeamNumber() == 2 then
			level = radiant_level
			particle = "particles/world_tower/tower_upgrade/ti7_radiant_tower_orb.vpcf"
			team = "radiant"
		end

		tower:SetModel("models/props_structures/tower_upgrade/tower_upgrade.vmdl")
		tower:SetOriginalModel("models/props_structures/tower_upgrade/tower_upgrade.vmdl")
		tower:SetMaterialGroup(team.."_level"..Battlepass:CheckBattlepassTowerLevel(level).mg)
		ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, tower)
		StartAnimation(tower, {duration=9999, activity=ACT_DOTA_CAPTURE, rate=1.0, translate = 'level'..Battlepass:CheckBattlepassTowerLevel(level).anim})
	end
end

function Battlepass:CheckBattlepassTowerLevel(level)
	local animation
	local material_group

	if level < 25 then
		material_group = "1"
		animation = "1"
	elseif level >= 25 then
		material_group = "2"
		animation = "1"
	elseif level >= 50 then
		material_group = "2"
		animation = "2"
	elseif level >= 75 then
		material_group = "3"
		animation = "2"
	elseif level >= 100 then
		material_group = "3"
		animation = "3"
	elseif level >= 150 then
		material_group = "4"
		animation = "3"
	elseif level >= 200 then
		material_group = "4"
		animation = "4"
	elseif level >= 300 then
		material_group = "5"
		animation = "4"
	elseif level >= 500 then
		material_group = "5"
		animation = "5"
	elseif level >= 1000 then
		material_group = "6"
		animation = "5"
	elseif level >= 2000 then
		material_group = "6"
		animation = "6"
	end

	local params = {
		anim = animation,
		mg = material_group
	}

	return params
end
