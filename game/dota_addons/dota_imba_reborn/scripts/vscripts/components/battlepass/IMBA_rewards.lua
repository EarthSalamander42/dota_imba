BATTLEPASS_LEVEL_REWARD = {}
-- BATTLEPASS_LEVEL_REWARD[10]		= {"sohei_arcana", "arcana"}
-- BATTLEPASS_LEVEL_REWARD[50]	= {"tidehunter_ancient", "ancient"}
BATTLEPASS_LEVEL_REWARD[165]	= {"earthshaker_arcana", "arcana"}
BATTLEPASS_LEVEL_REWARD[190]	= {"tiny_immortal", "immortal"}
if IsInToolsMode() then
--	BATTLEPASS_LEVEL_REWARD[195]	= {"terrorblade_arcana", "arcana"}
	BATTLEPASS_LEVEL_REWARD[195]	= {"nevermore_arcana", "arcana"}
end
BATTLEPASS_LEVEL_REWARD[225]	= {"invoker_legendary", "legendary"}
BATTLEPASS_LEVEL_REWARD[280]	= {"pudge_immortal", "immortal"}
-- BATTLEPASS_LEVEL_REWARD[310]	= {"dragon_knight_mythical", "mythical"}
BATTLEPASS_LEVEL_REWARD[400]	= {"ursa_immortal", "immortal"}

-- CustomNetTables:SetTableValue("game_options", "battlepass", {battlepass = BATTLEPASS_LEVEL_REWARD})

function Battlepass:Init()
	BattlepassHeroes = {}
	BattlepassHeroes["earthshaker"] = {}
	BattlepassHeroes["invoker"] = {}
	BattlepassHeroes["lina"] = {}
	if IsInToolsMode() then
		BattlepassHeroes["nevermore"] = {}
	end
	BattlepassHeroes["phantom_assassin"] = {}
	BattlepassHeroes["pudge"] = {}
--	BattlepassHeroes["terrorblade"] = {}
--	BattlepassHeroes["tidehunter"] = {}
	BattlepassHeroes["tiny"] = {}
	BattlepassHeroes["ursa"] = {}

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

function Battlepass:SetOverrideAssets(hero, modifier, table_name)
	for i, j in pairs(table_name) do
		if i ~= "skip_model_combine" and type(j) ~= "number" then
			if (j.type == "particle" and modifier == nil) or (j.type == "particle" and j.style and modifier and hero:FindModifierByName(modifier) and hero:FindModifierByName(modifier):GetStackCount() == j.style) then
--				print("Particle:", j)
				local particle_table = {}
				particle_table.asset = j.asset
				particle_table.modifier = j.modifier
				particle_table.parent = hero

				table.insert(CScriptParticleManager.PARTICLES_OVERRIDE, particle_table)
			elseif (j.type == "sound" and modifier == nil) or (j.type == "sound" and j.style and modifier and hero:FindModifierByName(modifier) and hero:FindModifierByName(modifier):GetStackCount() == j.style) then
--				print("Sound:", j)
				CustomNetTables:SetTableValue("battlepass_player", j.asset..'_'..hero:GetPlayerID(), {j.modifier}) 
			elseif (j.type == "ability_icon" and modifier == nil) or (j.type == "ability_icon" and j.style and modifier and hero:FindModifierByName(modifier) and hero:FindModifierByName(modifier):GetStackCount() == j.style) then
--				print("ability icon:", j)
				CustomNetTables:SetTableValue("battlepass_player", j.asset..'_'..hero:GetPlayerID(), {j.modifier}) 
			elseif (j.type == "icon_replacement_hero" and modifier == nil) or (j.type == "icon_replacement_hero" and j.style and modifier and hero:FindModifierByName(modifier) and hero:FindModifierByName(modifier):GetStackCount() == j.style) then
--				print("topbar icon:", j)
				CustomGameEventManager:Send_ServerToAllClients("override_hero_image", {
					player_id = hero:GetPlayerID(),
					icon_path = j.modifier,
				})
			elseif (j.type == "entity_model" and modifier == nil) or (j.type == "entity_model" and j.style and modifier and hero:FindModifierByName(modifier) and hero:FindModifierByName(modifier):GetStackCount() == j.style) then
--				print("entity model:", j)
				ENTITY_MODEL_OVERRIDE[j.asset] = j.modifier
			elseif j.type == "sheepstick_model" then
				hero.sheepstick_model = j.modifier				
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
	if hero:GetUnitName() == "npc_dota_hero_drow_ranger" then
		hero.base_attack_projectile = "particles/units/heroes/hero_drow/drow_base_attack.vpcf"
		hero.frost_arrows_debuff_pfx = "particles/units/heroes/hero_drow/drow_frost_arrow_debuff.vpcf"
		hero.marksmanship_arrow_pfx = "particles/units/heroes/hero_drow/drow_marksmanship_attack.vpcf"
		hero.marksmanship_frost_arrow_pfx = "particles/units/heroes/hero_drow/drow_marksmanship_frost_arrow.vpcf"
	elseif hero:GetUnitName() == "npc_dota_hero_invoker" then
		hero.quas_attack = "particles/units/heroes/hero_invoker/invoker_base_attack.vpcf"
		hero.wex_attack = "particles/units/heroes/hero_invoker/invoker_base_attack.vpcf"
		hero.exort_attack = "particles/units/heroes/hero_invoker/invoker_base_attack.vpcf"
		hero.all_attack = "particles/units/heroes/hero_invoker/invoker_base_attack.vpcf"

		hero.quas_orb = "particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf"
		hero.wex_orb = "particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf"
		hero.exort_orb = "particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf"
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
	end

	local ply_table = CustomNetTables:GetTableValue("battlepass_player", tostring(hero:GetPlayerID()))

	if ply_table and ply_table.bp_rewards == 0 then
		return
	end

	if tostring(PlayerResource:GetSteamID(hero:GetPlayerID())) ~= "0" then
		local armory = api:GetArmory(hero:GetPlayerID())

		if not armory then return end

		CustomNetTables:SetTableValue("battlepass_rewards", "rewards_"..hero:GetPlayerID(), armory)

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

				local item_name = v.hero

				-- items rewards only
				if battlepass_items[item_name] then
--					print(v.item_id, item_name)
					local item_effects = ItemsGame:GetItemVisuals(v.item_id)

--					print(item_effects)
					Battlepass:SetOverrideAssets(hero, nil, ItemsGame:GetItemVisuals(v.item_id))

					local images = ItemsGame:GetItemImages(v.item_id)

					for k, v in pairs(images) do
						CustomNetTables:SetTableValue("battlepass_player", v.asset..'_'..hero:GetPlayerID(), {v.modifier}) 
					end
				end
			end
		end

--		print(CScriptParticleManager.PARTICLES_OVERRIDE)
--		print("---------------------------------")
--		print(CDOTA_BaseNPC.SOUNDS_OVERRIDE)
	end

	local hello = false
	if hello == false then return end

	print("DONT")

	if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) ~= nil then
		local short_name = string.gsub(hero:GetUnitName(), "npc_dota_hero_", "")

		if hero:GetUnitName() == "npc_dota_hero_drow_ranger" then
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
