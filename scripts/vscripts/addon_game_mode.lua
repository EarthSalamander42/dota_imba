-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('imba')

function Precache( context )
--[[
	This function is used to precache resources/units/items/abilities that will be needed
	for sure in your game and that will not be precached by hero selection.  When a hero
	is selected from the hero selection screen, the game will precache that hero's assets,
	any equipped cosmetics, and perform the data-driven precaching defined in that hero's
	precache{} block, as well as the precache{} block for any equipped abilities.

	See GameMode:PostLoadPrecache() in gamemode.lua for more information
	]]

	DebugPrint("[IMBA] Performing pre-load precache")

	-- Particles can be precached individually or by folder
	-- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed

	-- Items
	PrecacheResource("particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_blur.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_gyrocopter/gyro_guided_missile_target.vpcf", context)
	PrecacheResource("particle", "particles/item/silver_edge/silver_edge_break.vpcf", context)
	PrecacheResource("particle", "particles/item/silver_edge/silver_edge_ring.vpcf", context)
	PrecacheResource("particle", "particles/item/silver_edge/silver_edge.vpcf", context)
	PrecacheResource("particle", "particles/item/octarine_core/octarine_core_active.vpcf", context)
	PrecacheResource("particle", "particles/item/octarine_core/octarine_core_hit.vpcf", context)
	PrecacheResource("particle", "particles/item/pipe_of_insight/pipe_of_insight.vpcf", context)

	-- Roshan
	PrecacheResource("particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf", context)
	PrecacheResource("particle", "particles/neutral_fx/roshan_slam.vpcf", context)

	-- Fountain
	PrecacheResource("particle", "particles/units/heroes/hero_ursa/ursa_fury_swipes.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", context)

	-- Stuff
	PrecacheResource("particle_folder", "particles/hero", context)
	PrecacheResource("particle_folder", "particles/generic_gameplay", context)
	PrecacheResource("particle_folder", "particles/item", context)
	PrecacheResource("particle_folder", "particles/items_fx", context)
	PrecacheResource("particle_folder", "particles/items2_fx", context)
	PrecacheResource("particle_folder", "particles/items3_fx", context)

	-- Models can also be precached by folder or individually
	PrecacheResource("model_folder", "models/development", context)
	PrecacheResource("model_folder", "models/creeps", context)
	PrecacheResource("model_folder", "models/props_gameplay", context)

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

	-- Entire items can be precached by name
	-- Abilities can also be precached in this way despite the name
	--PrecacheItemByNameSync("example_ability", context)
	--PrecacheItemByNameSync("item_example_item", context)

	-- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
	-- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
	--PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
	--PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end