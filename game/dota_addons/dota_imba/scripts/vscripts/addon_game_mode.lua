-- Copyright (C) 2018  The Dota IMBA Development Team
-- Copyright (C) 2015  bmddota
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Editors:
--     Firetoad
--     MouJiaoZi
--     Hewdraw
--     zimberzimer
--     Shush
--     Lindbrum
--     Earth Salamander #42
--     suthernfriend

require('internal/util')
require('internal/funcs')
require('libraries/player_resource')
require('imba')

require('components/hero_selection/hero_selection')

function Precache(context)
	log.debug("Performing pre-load precache")

	-- Lua modifiers activation
	LinkLuaModifier("modifier_imba_speed_limit_break", "modifier/modifier_imba_speed_limit_break.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_amphibian", "modifier/modifier_imba_amphibian.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_contributor_statue", "modifier/modifier_imba_contributor_statue.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_donator_statue", "modifier/modifier_imba_donator_statue.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_haste_rune_speed_limit_break", "modifier/modifier_imba_haste_rune_speed_limit_break.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_haste_boots_speed_break", "modifier/modifier_imba_haste_boots_speed_break.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_chronosphere_ally_slow", "modifier/modifier_imba_chronosphere_ally_slow.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_range_indicator", "modifier/modifier_imba_range_indicator.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_command_restricted", "modifier/modifier_command_restricted.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_companion", "modifier/modifier_companion.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_river", "modifier/modifier_river.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_frantic", "modifier/modifier_frantic.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_donator", "modifier/modifier_imba_donator.lua", LUA_MODIFIER_MOTION_NONE )

	-- Runes modifiers
	LinkLuaModifier("modifier_imba_arcane_rune", "modifier/runes/modifier_imba_arcane_rune.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_arcane_rune_aura", "modifier/runes/modifier_imba_arcane_rune.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_double_damage_rune", "modifier/runes/modifier_imba_double_damage_rune.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_rune_double_damage_aura", "modifier/runes/modifier_imba_double_damage_rune.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_haste_rune", "modifier/runes/modifier_imba_haste_rune", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_haste_rune_aura", "modifier/runes/modifier_imba_haste_rune", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_regen_rune", "modifier/runes/modifier_imba_regen_rune", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_regen_rune_aura", "modifier/runes/modifier_imba_regen_rune", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_frost_rune", "modifier/runes/modifier_imba_frost_rune", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_frost_rune_aura", "modifier/runes/modifier_imba_frost_rune", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_frost_rune_slow", "modifier/runes/modifier_imba_frost_rune", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_ember_rune", "modifier/runes/modifier_imba_ember_rune", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_stone_rune", "modifier/runes/modifier_imba_stone_rune", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_invisibility_rune_handler", "modifier/runes/modifier_imba_invisibility_rune", LUA_MODIFIER_MOTION_NONE)

	-- Imba Fountain Lua
	LinkLuaModifier( "modifier_fountain_aura_lua", "modifier/modifier_fountain_aura_lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_fountain_aura_effect_lua", "modifier/modifier_fountain_aura_effect_lua", LUA_MODIFIER_MOTION_NONE )

	-- Aegis
	LinkLuaModifier("modifier_item_imba_aegis", "items/item_aegis.lua", LUA_MODIFIER_MOTION_NONE)

	-- Custom Mechanics modifier
	LinkLuaModifier("modifier_custom_mechanics", "modifier/modifier_custom_mechanics.lua", LUA_MODIFIER_MOTION_NONE )

	-- War Veteran modifier
	LinkLuaModifier("modifier_imba_war_veteran_0", "modifier/modifier_imba_war_veteran.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_war_veteran_1", "modifier/modifier_imba_war_veteran.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_war_veteran_2", "modifier/modifier_imba_war_veteran.lua", LUA_MODIFIER_MOTION_NONE )

	-- Invoker lua modifiers
	LinkLuaModifier("modifier_imba_invoke_buff", "modifier/modifier_imba_invoke_buff.lua", LUA_MODIFIER_MOTION_NONE )

	-- Silencer lua modifiers
	LinkLuaModifier("modifier_imba_arcane_curse_debuff", "modifier/modifier_imba_arcane_curse_debuff.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_silencer_int_steal", "modifier/modifier_imba_silencer_int_steal.lua", LUA_MODIFIER_MOTION_NONE )

	-- Pudge flesh heap handler
	LinkLuaModifier("modifier_imba_pudge_flesh_heap_handler", "hero/hero_pudge.lua", LUA_MODIFIER_MOTION_NONE)

	-- Companion using mirana modifiers
	LinkLuaModifier("modifier_imba_mirana_silence_stance", "hero/hero_mirana", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_mirana_silence_stance_visible", "hero/hero_mirana", LUA_MODIFIER_MOTION_NONE)

	if GetMapName() == "imba_overthrow" then
		PrecacheItemByNameSync( "item_bag_of_gold", context )
		PrecacheResource( "particle", "particles/items2_fx/veil_of_discord.vpcf", context )

		PrecacheItemByNameSync( "item_treasure_chest", context )
		PrecacheModel( "item_treasure_chest", context )

		--Cache the creature models
		PrecacheUnitByNameSync( "npc_dota_creature_basic_zombie", context )
		PrecacheModel( "npc_dota_creature_basic_zombie", context )

		PrecacheUnitByNameSync( "npc_dota_creature_berserk_zombie", context )
		PrecacheModel( "npc_dota_creature_berserk_zombie", context )

		PrecacheUnitByNameSync( "npc_dota_treasure_courier", context )
		PrecacheModel( "npc_dota_treasure_courier", context )

		PrecacheUnitByNameSync( "npc_dota_kobold_overboss", context )
		PrecacheModel( "npc_dota_kobold_overboss", context )

		--Cache new particles
		PrecacheResource( "particle", "particles/econ/events/nexon_hero_compendium_2014/teleport_end_nexon_hero_cp_2014.vpcf", context )
		PrecacheResource( "particle", "particles/leader/leader_overhead.vpcf", context )
		PrecacheResource( "particle", "particles/last_hit/last_hit.vpcf", context )
		PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zeus_taunt_coin.vpcf", context )
		PrecacheResource( "particle", "particles/addons_gameplay/player_deferred_light.vpcf", context )
		PrecacheResource( "particle", "particles/items_fx/black_king_bar_avatar.vpcf", context )
		PrecacheResource( "particle", "particles/treasure_courier_death.vpcf", context )
		PrecacheResource( "particle", "particles/econ/wards/f2p/f2p_ward/f2p_ward_true_sight_ambient.vpcf", context )
		PrecacheResource( "particle", "particles/econ/items/lone_druid/lone_druid_cauldron/lone_druid_bear_entangle_dust_cauldron.vpcf", context )
		PrecacheResource( "particle", "particles/newplayer_fx/npx_landslide_debris.vpcf", context )

		--Cache particles for traps
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_dragon_knight", context )
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_venomancer", context )
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_axe", context )
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_life_stealer", context )

		--Cache sounds for traps
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/soundevents_conquest.vsndevts", context )

		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes_custom/game_sounds_sohei.vsndevts", context )
	elseif IsMutationMap() then
		Mutation:Precache(context)
	elseif GetMapName() == "cavern" then
		require( "components/cavern/cavern" )
		print( "Preaching Cavern assets..." )

		for _,Item in pairs( g_ItemPrecache ) do
			PrecacheItemByNameSync( Item, context )
		end

		for _,Unit in pairs( g_UnitPrecache ) do
			PrecacheUnitByNameAsync( Unit, function( unit ) end )
		end

		for _,Model in pairs( g_ModelPrecache ) do
			PrecacheResource( "model", Model, context )
		end

		for _,Model in pairs( CavernTreeModelNames ) do
			PrecacheResource( "model", Model, context )
		end

		for _,Particle in pairs( g_ParticlePrecache ) do
			PrecacheResource( "particle", Particle, context )
		end

		for _,ParticleFolder in pairs( g_ParticleFolderPrecache ) do
			PrecacheResource( "particle_folder", ParticleFolder, context )
		end

		for _,Sound in pairs( g_SoundPrecache ) do
			PrecacheResource( "soundfile", Sound, context )
		end
	end

	--[[
	PrecacheResource("particle", "particles/econ/items/effigies/status_fx_effigies/gold_effigy_ambient_dire_lvl2.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_mirana.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ember_spirit.vsndevts", context)

	-- Hell Empress
	PrecacheResource("particle", "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_ambient.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes_custom/game_sounds_hell_empress.vsndevts", context)

	PrecacheResource("particle", "particles/ambient/fountain_danger_circle.vpcf", context)

	-- Towers
	PrecacheResource("particle", "particles/units/heroes/hero_tinker/tinker_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_centaur/centaur_return.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_pudge/pudge_rot_radius.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_treant/treant_livingarmor.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ui.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_faceless_void.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_nyx_assassin.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts", context)

	-- Ancients
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_press.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_legion_commander.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_treant/treant_overgrowth_cast.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_treant.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace_hit.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_nyx_assassin.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_beserkers_call.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_tidehunter.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context)

	-- Radiant Hulk (Behemoth)
	PrecacheResource("particle", "particles/creeps/lane_creeps/creep_radiant_hulk_ambient.vpcf", context)
	PrecacheResource("particle", "particles/creeps/lane_creeps/creep_radiant_hulk_ambient_energy.vpcf", context)
	PrecacheResource("particle", "particles/creeps/lane_creeps/creep_radiant_hulk_ambient_flakes.vpcf", context)
	PrecacheResource("particle", "particles/creeps/lane_creeps/creep_radiant_hulk_swipe.vpcf", context)
	PrecacheResource("particle", "particles/creeps/lane_creeps/creep_radiant_hulk_swipe_glow.vpcf", context)
	PrecacheResource("particle", "particles/creeps/lane_creeps/creep_radiant_hulk_swipe_left.vpcf", context)
	PrecacheResource("particle", "particles/creeps/lane_creeps/creep_radiant_hulk_swipe_right.vpcf", context)    

	-- Dire Hulk (Behemoth)
	PrecacheResource("particle", "particles/creeps/lane_creeps/creep_dire_hulk_ambient_core.vpcf", context)
	PrecacheResource("particle", "particles/creeps/lane_creeps/creep_dire_hulk_flames.vpcf", context)
	PrecacheResource("particle", "particles/creeps/lane_creeps/creep_dire_hulk_rays.vpcf", context)
	PrecacheResource("particle", "particles/creeps/lane_creeps/creep_dire_hulk_swipe.vpcf", context)
	PrecacheResource("particle", "particles/creeps/lane_creeps/creep_dire_hulk_swipe_glow.vpcf", context)
	PrecacheResource("particle", "particles/creeps/lane_creeps/creep_dire_hulk_swipe_left.vpcf", context)
	PrecacheResource("particle", "particles/creeps/lane_creeps/creep_dire_hulk_swipe_right.vpcf", context)

	-- Roshan
	PrecacheResource("particle_folder", "particles/econ/items/invoker/invoker_apex", context)
	PrecacheResource("particle_folder", "particles/hw_fx", context)
	PrecacheResource("particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf", context) -- Apocalypse
	PrecacheUnitByNameSync("npc_dota_hero_invoker", context) -- Apocalypse
	PrecacheUnitByNameSync("npc_dota_hero_tiny", context) -- Toss

	-- Stuff
	PrecacheResource("particle_folder", "particles/hero", context)
	PrecacheResource("particle_folder", "particles/ambient", context)
	PrecacheResource("particle_folder", "particles/generic_gameplay", context)
	PrecacheResource("particle_folder", "particles/status_fx/", context)
	PrecacheResource("particle_folder", "particles/item", context)
	PrecacheResource("particle_folder", "particles/items_fx", context)
	PrecacheResource("particle_folder", "particles/items2_fx", context)
	PrecacheResource("particle_folder", "particles/items3_fx", context)
	PrecacheResource("particle_folder", "particles/creeps/lane_creeps/", context)
	PrecacheResource("particle_folder", "particles/customgames/capturepoints/", context)
	PrecacheResource("particle", "particles/range_indicator.vpcf", context)

	-- Models can also be precached by folder or individually
	PrecacheResource("model_folder", "models/development", context)
	PrecacheResource("model_folder", "models/creeps", context)
	PrecacheResource("model_folder", "models/props_gameplay", context)
	PrecacheResource("model_folder", "models/heroes", context)

	-- Companions
	PrecacheResource("model_folder", "models/courier/doom_demihero_courier", context)
	PrecacheResource("model_folder", "models/items/courier/livery_llama_courier", context)
	PrecacheResource("model", "models/items/courier/carty/carty.vmdl", context)

	-- Sounds can precached here like anything else
	PrecacheResource("soundfile", "sounds/weapons/creep/roshan/slam.vsnd", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_items.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_lancer.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_spirit_breaker.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_razor.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_weaver.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_roshan_halloween.vsndevts", context)
--]]
	-- Rapier sounds
	--PrecacheResource("sound", "sounds/vo/announcer_dlc_bastion/announcer_event_store_rapier.vsnd", context)
	--PrecacheResource("sound", "sounds/vo/announcer_dlc_pflax/announcer_divine_rapier_one.vsnd", context)
	--PrecacheResource("sound", "sounds/vo/announcer_dlc_stanleyparable/announcer_purchase_divinerapier_02.vsnd", context)
	--PrecacheResource("sound", "sounds/vo/announcer_dlc_pflax/announcer_divine_rapier_two.vsnd", context)
	--PrecacheResource("sound", "sounds/physics/items/weapon_drop_common_02.vsnd", context)
	--PrecacheResource("sound", "sounds/ui/inventory/metalblade_equip_01.vsnd", context)

	-- Battlepass
	PrecacheResource("model_folder", "models/items/pudge/arcana", context)
	PrecacheResource("particle_folder", "particles/econ/items/pudge/pudge_arcana", context)
	PrecacheResource("model_folder", "models/items/juggernaut/arcana", context)
	PrecacheResource("particle_folder", "particles/econ/items/juggernaut/jugg_arcana", context)

	-- Cosmetics Companions
	PrecacheResource("model", "models/items/pudge/blackdeath_offhand/blackdeath_offhand.vmdl", context)
	PrecacheResource("model", "models/items/pudge/blackdeath_head_s3/blackdeath_head_s3.vmdl", context)
	PrecacheResource("model", "models/items/pudge/immortal_arm/immortal_arm.vmdl", context)
	PrecacheResource("model", "models/items/pudge/scorching_talon/scorching_talon.vmdl", context)
	PrecacheResource("model", "models/items/pudge/doomsday_ripper_belt/doomsday_ripper_belt.vmdl", context)
	PrecacheResource("model", "models/items/pudge/pudge_deep_sea_abomination_arms/pudge_deep_sea_abomination_arms.vmdl", context)

	PrecacheResource("particle_folder", "particles/hero/scaldris", context) -- Scaldris Hero
	PrecacheResource("soundfile", "soundevents/imba_soundevents.vsndevts", context) -- Various sounds
	PrecacheResource("soundfile", "soundevents/imba_item_soundevents.vsndevts", context) -- Various Item sounds
	PrecacheResource("soundfile", "soundevents/diretide_soundevents.vsndevts", context) -- Roshan sounds

	PrecacheUnitByNameAsync("npc_dota_hero_abyssal_underlord", context) -- Hellion (attack sound)
	PrecacheUnitByNameAsync("npc_dota_hero_invoker", context) -- Roshan
	PrecacheUnitByNameAsync("npc_dota_hero_weaver", context) -- Sly King (attack sound)
end

function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end
