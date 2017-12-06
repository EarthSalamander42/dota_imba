require('internal/util')
require('internal/funcs')
require('player_resource')
require('imba')
require('hero_selection')

function Precache(context)
DebugPrint("[IMBA] Performing pre-load precache")

	-- Lua modifiers activation
	LinkLuaModifier("modifier_imba_speed_limit_break", "modifier/modifier_imba_speed_limit_break.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_contributor_statue", "modifier/modifier_imba_contributor_statue.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_haste_rune_speed_limit_break", "modifier/modifier_imba_haste_rune_speed_limit_break.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_haste_boots_speed_break", "modifier/modifier_imba_haste_boots_speed_break.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_chronosphere_ally_slow", "modifier/modifier_imba_chronosphere_ally_slow.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_arena_passive_gold_thinker", "modifier/modifier_imba_arena_passive_gold_thinker.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_range_indicator", "modifier/modifier_imba_range_indicator.lua", LUA_MODIFIER_MOTION_NONE )	
	LinkLuaModifier("modifier_command_restricted", "modifier/modifier_command_restricted.lua", LUA_MODIFIER_MOTION_NONE )	
	LinkLuaModifier("modifier_companion", "modifier/modifier_companion.lua", LUA_MODIFIER_MOTION_NONE )	
	LinkLuaModifier("modifier_river", "modifier/modifier_river.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_courier_hack", "modifier/modifier_courier_hack.lua", LUA_MODIFIER_MOTION_NONE )

	-- Runes modifiers
	LinkLuaModifier("modifier_imba_double_damage_rune", "modifier/runes/modifier_imba_double_damage_rune.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_rune_double_damage_aura", "modifier/runes/modifier_imba_double_damage_rune.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_haste_rune", "modifier/runes/modifier_imba_haste_rune", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_haste_rune_aura", "modifier/runes/modifier_imba_haste_rune", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_regen_rune", "modifier/runes/modifier_imba_regen_rune", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_regen_rune_aura", "modifier/runes/modifier_imba_regen_rune", LUA_MODIFIER_MOTION_NONE)

	-- Aegis
	LinkLuaModifier("modifier_item_imba_aegis", "items/item_aegis.lua", LUA_MODIFIER_MOTION_NONE)

	-- Generic talent modifiers
	LinkLuaModifier("modifier_imba_generic_talents_handler", "modifier/generic_talents/modifier_imba_generic_talents_handler.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_damage", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_all_stats", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_strength", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_agility", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_intelligence", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_armor", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_magic_resistance", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_evasion", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_move_speed", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_attack_speed", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_hp", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_hp_regen", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_mp", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_mp_regen", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_attack_range", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_cast_range", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_attack_life_steal", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_spell_life_steal", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_spell_power", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_cd_reduction", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_bonus_xp", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_generic_talent_respawn_reduction", "modifier/generic_talents/modifier_imba_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )

	-- Invoker lua modifiers
	LinkLuaModifier("modifier_imba_invoke_buff", "modifier/modifier_imba_invoke_buff.lua", LUA_MODIFIER_MOTION_NONE )

	-- Silencer lua modifiers
	LinkLuaModifier("modifier_imba_arcane_curse_debuff", "modifier/modifier_imba_arcane_curse_debuff.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_imba_silencer_int_steal", "modifier/modifier_imba_silencer_int_steal.lua", LUA_MODIFIER_MOTION_NONE )

	-- Companion using mirana modifiers
	LinkLuaModifier("modifier_imba_mirana_silence_stance", "hero/hero_mirana", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_mirana_silence_stance_visible", "hero/hero_mirana", LUA_MODIFIER_MOTION_NONE)

	PrecacheResource("particle", "particles/econ/items/effigies/status_fx_effigies/gold_effigy_ambient_dire_lvl2.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_mirana.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ember_spirit.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/imba_soundevents.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/imba_item_soundevents.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/diretide_soundevents.vsndevts", context)

	-- Ghost Revenant
	PrecacheResource("particle", "particles/econ/items/windrunner/windrunner_cape_cascade/windrunner_windrun_slow_cascade.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_visage.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts", context)

	-- Hell Empress
	PrecacheResource("particle", "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_ambient.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes_custom/game_sounds_hell_empress.vsndevts", context)

	-- Roshan
	PrecacheResource("particle", "particles/neutral_fx/roshan_slam.vpcf", context)

	-- Fountain
	PrecacheResource("particle", "particles/units/heroes/hero_ursa/ursa_fury_swipes.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", context)
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

	-- Companions
	PrecacheResource("model_folder", "models/courier/doom_demihero_courier", context)
	PrecacheResource("model_folder", "models/items/courier/livery_llama_courier", context)
	PrecacheResource("model_folder", "models/items/courier/carty/carty.vmdl", context)

	-- Sounds can precached here like anything else
	PrecacheResource("soundfile", "sounds/weapons/creep/roshan/slam.vsnd", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_items.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_lancer.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_spirit_breaker.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_roshan_halloween.vsndevts", context)

	-- Rapier sounds
	--PrecacheResource("sound", "sounds/vo/announcer_dlc_bastion/announcer_event_store_rapier.vsnd", context)
	--PrecacheResource("sound", "sounds/vo/announcer_dlc_pflax/announcer_divine_rapier_one.vsnd", context)
	--PrecacheResource("sound", "sounds/vo/announcer_dlc_stanleyparable/announcer_purchase_divinerapier_02.vsnd", context)
	--PrecacheResource("sound", "sounds/vo/announcer_dlc_pflax/announcer_divine_rapier_two.vsnd", context)
	--PrecacheResource("sound", "sounds/physics/items/weapon_drop_common_02.vsnd", context)
	--PrecacheResource("sound", "sounds/ui/inventory/metalblade_equip_01.vsnd", context)

	PrecacheUnitByNameSync("npc_dota_hero_wisp", context) --Precaching dummy wisp
end

function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end
