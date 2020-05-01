BATTLEPASS_LEVEL_REWARD = {}
-- BATTLEPASS_LEVEL_REWARD[10]		= {"sohei_arcana", "arcana"}
-- BATTLEPASS_LEVEL_REWARD[50]	= {"tidehunter_ancient", "ancient"}
BATTLEPASS_LEVEL_REWARD[56]		= {"huskar_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[60]		= {"sheepstick", "common"}
BATTLEPASS_LEVEL_REWARD[68]		= {"axe_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[97]		= {"life_stealer_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[106]	= {"death_prophet_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[116]	= {"centaur_immortal", "immortal"}
BATTLEPASS_LEVEL_REWARD[128]	= {"dark_seer_immortal2", "immortal"}
BATTLEPASS_LEVEL_REWARD[133]	= {"skywrath_mage_immortal2", "immortal"}
BATTLEPASS_LEVEL_REWARD[145]	= {"wisp_arcana", "arcana"} -- try multiple modifiers to add multiple animation translation activities
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
BATTLEPASS_LEVEL_REWARD[280]	= {"pudge_immortal", "immortal"}
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

function Battlepass:SetOverrideAssets(hero, modifier, table_name)
	for i, j in pairs(table_name) do
		if i ~= "skip_model_combine" then
			if (j.type == "particle" and modifier == nil) or (j.type == "particle" and j.style and modifier and hero:FindModifierByName(modifier):GetStackCount() == j.style) then
--				print("Particle:", j)
				local particle_table = {}
				particle_table.asset = j.asset
				particle_table.modifier = j.modifier
				particle_table.parent = hero

				table.insert(CScriptParticleManager.PARTICLES_OVERRIDE, particle_table)
			elseif (j.type == "sound" and modifier == nil) or (j.type == "sound" and j.style and modifier and hero:FindModifierByName(modifier):GetStackCount() == j.style) then
--				print("Sound:", j)
				local sound_table = {}
				sound_table.asset = j.asset
				sound_table.modifier = j.modifier
				sound_table.parent = hero

				table.insert(CDOTA_BaseNPC.SOUNDS_OVERRIDE, sound_table)
			elseif (j.type == "ability_icon" and modifier == nil) or (j.type == "ability_icon" and j.style and modifier and hero:FindModifierByName(modifier):GetStackCount() == j.style) then
--				print("ability icon:", j)
				CustomNetTables:SetTableValue("battlepass", j.asset..'_'..hero:GetPlayerID(), {j.modifier}) 
			elseif (j.type == "icon_replacement_hero" and modifier == nil) or (j.type == "icon_replacement_hero" and j.style and modifier and hero:FindModifierByName(modifier):GetStackCount() == j.style) then
--				print("topbar icon:", j)
				CustomGameEventManager:Send_ServerToAllClients("override_hero_image", {
					player_id = hero:GetPlayerID(),
					icon_path = j.modifier,
				})
			elseif (j.type == "entity_model" and modifier == nil) or (j.type == "entity_model" and j.style and modifier and hero:FindModifierByName(modifier):GetStackCount() == j.style) then
--				print("entity model:", j)
				ENTITY_MODEL_OVERRIDE[j.asset] = j.modifier
			end
		end
	end

	-- override attack projectile
	for k, v in pairs(CScriptParticleManager.PARTICLES_OVERRIDE) do
		if v.asset == GetKeyValueByHeroName(hero:GetUnitName(), "ProjectileModel") and v.parent == hero then
			hero:SetRangedProjectileName(v.modifier)
			break
		end
	end
end

-- todo: use values in items_game.txt instead
function Battlepass:GetHeroEffect(hero)
	if hero:GetUnitName() == "npc_dota_hero_axe" then
		hero.pre_attack_sound = "Hero_Axe.PreAttack"
		hero.attack_sound = "Hero_Axe.Attack"
		hero.counter_helix_pfx = "particles/units/heroes/hero_axe/axe_attack_blur_counterhelix.vpcf"
		hero.culling_blade_kill_pfx = "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
		hero.culling_blade_boost_pfx = "particles/units/heroes/hero_axe/axe_culling_blade_boost.vpcf"
		hero.culling_blade_sprint_pfx = "particles/units/heroes/hero_axe/axe_cullingblade_sprint_axe.vpcf"
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

	if tostring(PlayerResource:GetSteamID(hero:GetPlayerID())) ~= "0" then
		local armory = api:GetArmory(hero:GetPlayerID())

		if not armory then return end

		CustomNetTables:SetTableValue("battlepass", "rewards_"..hero:GetPlayerID(), armory)

		local battlepass_items = {}
		battlepass_items["blink"] = ""
		battlepass_items["bottle"] = ""
		battlepass_items["force_staff"] = ""
		battlepass_items["fountain"] = ""
		battlepass_items["maelstrom"] = ""
		battlepass_items["mekansm"] = ""
		battlepass_items["radiance"] = ""
		battlepass_items["sheepstick"] = ""
		battlepass_items["shiva"] = ""

		for k, v in pairs(armory) do
			-- HEROES HANDLE
			if hero:GetUnitName() == v.hero then
				for item_id, slot_id in pairs(ItemsGame:GetItemWearables(v.item_id) or {}) do
					if type(item_id) == "number" then item_id = tostring(item_id) end

					local modifier = ItemsGame:GetItemModifier(v.item_id)

					if modifier then
--						print("Add cosmetic modifier:", modifier)
						hero:AddNewModifier(hero, nil, modifier, {})

						local style = 0

						if v.hero == "npc_dota_hero_phantom_assassin" then
--							print("Arcana kills:")
							local pa_arcana_kills = api:GetPhantomAssassinArcanaKills(hero:GetPlayerID()) or 0
--							print(pa_arcana_kills)
							hero:AddNewModifier(hero, nil, "modifier_phantom_assassin_arcana", {}):SetStackCount(tonumber(pa_arcana_kills))

							if tonumber(pa_arcana_kills) >= 400 then
								style = 1
							elseif tonumber(pa_arcana_kills) >= 1000 then
								style = 2
							end
						end
					end

					Wearable:_WearProp(hero, item_id, slot_id, style)

					if Wearable.asset_modifier[item_id] then
						Battlepass:SetOverrideAssets(hero, modifier, Wearable.asset_modifier[item_id])
					end

					if Wearable.items_game["items"][item_id] and Wearable.items_game["items"][item_id]["visuals"] then
						Battlepass:SetOverrideAssets(hero, modifier, Wearable.items_game["items"][item_id]["visuals"])
					end
				end
			else
				if v.hero == "levelup" then
					Battlepass:SetOverrideAssets(hero, nil, ItemsGame:GetItemVisuals(v.item_id))
				end

				if battlepass_items[v.hero] then
					battlepass_items[v.hero] = ItemsGame:GetItemEffects(v.item_id)
					local images = ItemsGame:GetItemImages(v.item_id)

					for k, v in pairs(images) do
						CustomNetTables:SetTableValue("battlepass", v.asset..'_'..hero:GetPlayerID(), {v.modifier}) 
					end
				end
			end
		end

		CustomNetTables:SetTableValue("battlepass_item_effects", tostring(hero:GetPlayerID()), battlepass_items)

--		print(CScriptParticleManager.PARTICLES_OVERRIDE)
--		print("---------------------------------")
--		print(CDOTA_BaseNPC.SOUNDS_OVERRIDE)
	end

	local hello = false
	if hello == false then return end

	print("DONT")

	if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) ~= nil then
		local short_name = string.gsub(hero:GetUnitName(), "npc_dota_hero_", "")

		if hero:GetUnitName() == "npc_dota_hero_axe" then
			-- if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["axe_immortal"] then
				-- LinkLuaModifier("modifier_axe_arcana", "components/abilities/heroes/hero_axe", LUA_MODIFIER_MOTION_NONE)

				-- Wearable:_WearProp(hero, "12964", "weapon")
				-- Wearable:_WearProp(hero, "12965", "armor")
				-- Wearable:_WearProp(hero, "12966", "belt")
				-- Wearable:_WearProp(hero, "12968", "head")

				-- hero.pre_attack_sound = "Hero_Axe.PreAttack.Jungle"
				-- hero.attack_sound = "Hero_Axe.Attack.Jungle"
				-- hero.counter_helix_pfx = "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_attack_blur_counterhelix.vpcf"
				-- hero.culling_blade_kill_pfx = "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_kill.vpcf"
				-- hero.culling_blade_boost_pfx = "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_boost.vpcf"
				-- hero.culling_blade_sprint_pfx = "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_sprint_axe.vpcf"

				-- hero:AddNewModifier(hero, nil, "modifier_axe_arcana", {})
				-- hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {style = style})
			-- end
		elseif hero:GetUnitName() == "npc_dota_hero_centaur" then
			if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["centaur_immortal"] then
				hero.double_edge_pfx = "particles/econ/items/centaur/centaur_ti9/centaur_double_edge_ti9.vpcf"
				hero.double_edge_body_pfx = "particles/econ/items/centaur/centaur_ti9/centaur_double_edge_body_ti9.vpcf"
				hero.double_edge_phase_pfx = "particles/econ/items/centaur/centaur_ti9/centaur_double_edge_phase_ti9.vpcf"

				Wearable:_WearProp(hero, "12945", "weapon")

				hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {})
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
		elseif hero:GetUnitName() == "npc_dota_hero_nevermore" then
			if IsInToolsMode() then
				if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BattlepassHeroes[short_name]["nevermore_arcana"] then
					Wearable:_WearProp(hero, "6996", "head")
				end
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
