DONATOR_COLOR = {}
DONATOR_COLOR[0] = {255, 255, 255} -- Not a donator
DONATOR_COLOR[1] = {135, 20, 20} -- IMBA Lead-Developer
DONATOR_COLOR[2] = {100, 20, 20} -- IMBA Developer
DONATOR_COLOR[3] = {0, 102, 255} -- Administrator
DONATOR_COLOR[4] = {220, 40, 40} -- Ember Donator
DONATOR_COLOR[5] = {218, 165, 32} -- Golden Donator
DONATOR_COLOR[6] = {0, 204, 0} -- Green Donator (basic)
DONATOR_COLOR[7] = {153, 51, 153} -- Salamander Donator (purple)
DONATOR_COLOR[8] = {47, 91, 151} -- Icefrog Donator (blue)
DONATOR_COLOR[9] = {185, 75, 10} -- Gaben Donator
DONATOR_COLOR[10] = {255, 255, 255}

CustomNetTables:SetTableValue("game_options", "donator_colors", DONATOR_COLOR)

UNIQUE_DONATOR_COMPANION = {}
-- UNIQUE_DONATOR_COMPANION["76561198015161808"] = "npc_donator_companion_cookies"
UNIQUE_DONATOR_COMPANION["76561198094835750"] = "npc_donator_companion_zonnoz"
UNIQUE_DONATOR_COMPANION["76561198003571172"] = "npc_donator_companion_baumi"
UNIQUE_DONATOR_COMPANION["76561198014254115"] = "npc_donator_companion_icefrog"
UNIQUE_DONATOR_COMPANION["76561198014254115"] = "npc_donator_companion_admiral_bulldog"
UNIQUE_DONATOR_COMPANION["76561198021465788"] = "npc_donator_companion_suthernfriend"
UNIQUE_DONATOR_COMPANION["76561198073163389"] = "npc_donator_companion_terdic"
UNIQUE_DONATOR_COMPANION["76561197970766309"] = "npc_donator_companion_hamahe"
UNIQUE_DONATOR_COMPANION["76561193687456266"] = "npc_donator_companion_exzas"
UNIQUE_DONATOR_COMPANION["76561198095342815"] = "npc_donator_companion_the_blind_dog"
UNIQUE_DONATOR_COMPANION["76561198009727790"] = "npc_donator_companion_acalia"

-- UNIQUE_DONATOR_COMPANION["76561198194491261"] = "npc_donator_companion_conjurist"
UNIQUE_DONATOR_COMPANION["76561198194491261"] = "npc_donator_companion_suthernfriend" -- Conjurist wants a special Roshan

UNIQUE_DONATOR_COMPANION["76561198109559236"] = "npc_donator_companion_gordon_ramsay"
UNIQUE_DONATOR_COMPANION["76561198081698794"] = "npc_donator_companion_rayzone"
UNIQUE_DONATOR_COMPANION["76561198148311002"] = "npc_donator_companion_rubick_arcana" -- Carry Me Senpai
UNIQUE_DONATOR_COMPANION["76561197995265925"] = "npc_donator_companion_rubick_arcana" -- General Atrox
UNIQUE_DONATOR_COMPANION["76561198046069202"] = "npc_donator_companion_crux"
UNIQUE_DONATOR_COMPANION["76561197969985809"] = "npc_donator_companion_phish"
UNIQUE_DONATOR_COMPANION["76561198065838676"] = "npc_donator_companion_miku"
-- UNIQUE_DONATOR_COMPANION["76561198124080528"] = "npc_donator_companion_hastur"
-- UNIQUE_DONATOR_COMPANION["76561198330946475"] = "npc_donator_companion_deadknight"
UNIQUE_DONATOR_COMPANION["76561198054347194"] = "npc_donator_companion_vivi"
UNIQUE_DONATOR_COMPANION["76561198046078552"] = "npc_donator_companion_altivu"
UNIQUE_DONATOR_COMPANION["76561198885326839"] = "npc_donator_companion_suthernfriend"	-- test string

UNIQUE_DONATOR_STATUE = {}
-- UNIQUE_DONATOR_STATUE["76561198015161808"] = "npc_donator_statue_cookies"
UNIQUE_DONATOR_STATUE["76561193714760494"] = "npc_donator_statue_acalia"
UNIQUE_DONATOR_STATUE["76561193684594183"] = "npc_donator_statue_lily"
UNIQUE_DONATOR_STATUE["76561198021465788"] = "npc_donator_statue_suthernfriend"
UNIQUE_DONATOR_STATUE["76561193687456266"] = "npc_donator_statue_exzas"
UNIQUE_DONATOR_STATUE["76561198094835750"] = "npc_donator_statue_zonnoz"
-- UNIQUE_DONATOR_STATUE["76561198043254407"] = "npc_donator_statue_tabisama"
UNIQUE_DONATOR_STATUE["76561197980558838"] = "npc_donator_statue_january0000"
UNIQUE_DONATOR_STATUE["76561198073163389"] = "npc_donator_statue_terdic"
UNIQUE_DONATOR_STATUE["76561198077187165"] = "npc_donator_statue_toc"
UNIQUE_DONATOR_STATUE["76561198187809623"] = "npc_donator_statue_oviakin"
UNIQUE_DONATOR_STATUE["76561197970766309"] = "npc_donator_statue_hamahe"
-- UNIQUE_DONATOR_STATUE["76561198330946475"] = "npc_donator_statue_deadknight"

-- sAmbientParticle, bFlying (doesn't require bFlying = true if contains flying in the model name)
DONATOR_COMPANION_ADDITIONAL_INFO = {}
DONATOR_COMPANION_ADDITIONAL_INFO["models/items/warlock/golem/ti_8_warlock_darkness_apostate_golem/ti_8_warlock_darkness_apostate_golem.vmdl"] = {"particles/econ/courier/courier_greevil_orange/courier_greevil_orange_ambient_3.vpcf"}
DONATOR_COMPANION_ADDITIONAL_INFO["models/items/courier/devourling/devourling.vmdl"] = {"particles/econ/courier/courier_devourling/courier_devourling_ambient.vpcf"}
DONATOR_COMPANION_ADDITIONAL_INFO["models/items/courier/baekho/baekho.vmdl"] = {"particles/econ/courier/courier_baekho/courier_baekho_ambient.vpcf"}
DONATOR_COMPANION_ADDITIONAL_INFO["models/items/courier/shagbark/shagbark.vmdl"] = {"particles/econ/courier/courier_shagbark/courier_shagbark_ambient.vpcf"}
DONATOR_COMPANION_ADDITIONAL_INFO["models/items/io/io_ti7/io_ti7.vmdl"] = {"particles/econ/items/wisp/wisp_ambient_ti7.vpcf"}
DONATOR_COMPANION_ADDITIONAL_INFO["models/courier/donkey_unicorn/donkey_unicorn_flying.vmdl"] = {"particles/econ/courier/courier_donkey_unicorn/courier_donkey_unicorn_ambient.vpcf"}
DONATOR_COMPANION_ADDITIONAL_INFO["models/heroes/phoenix/phoenix_bird.vmdl"] = {"particles/units/heroes/hero_phoenix/phoenix_ambient.vpcf", true}
DONATOR_COMPANION_ADDITIONAL_INFO["models/courier/donkey_crummy_wizard_2014/donkey_crummy_wizard_2014_flying.vmdl"] = {"particles/econ/courier/courier_hwytty/courier_hwytty_ambient.vpcf"}
DONATOR_COMPANION_ADDITIONAL_INFO["models/courier/sw_donkey/sw_donkey_flying.vmdl"] = {"particles/econ/courier/courier_dolfrat_and_roshinante/courier_dolfrat_and_roshinante_a.vpcf"}
DONATOR_COMPANION_ADDITIONAL_INFO["models/items/courier/nian_courier/nian_courier.vmdl"] = {"particles/econ/courier/courier_nian/courier_nian_ambient.vpcf"}
DONATOR_COMPANION_ADDITIONAL_INFO["models/items/phoenix/ultimate/golden_nirvana_golden_nirvana_nova/golden_nirvana_golden_nirvana_nova.vmdl"] = {nil, true} --  "particles/units/heroes/hero_phoenix/phoenix_supernova_egg.vpcf" effects might be too crazy for like a permanent entity
DONATOR_COMPANION_ADDITIONAL_INFO["models/courier/donkey_ti7/donkey_ti7_flying.vmdl"] = {"particles/econ/courier/courier_donkey_ti7/courier_donkey_ti7_ambient.vpcf", true}
DONATOR_COMPANION_ADDITIONAL_INFO["models/items/courier/deathripper/deathripper.vmdl"] = {"particles/econ/courier/courier_wmachine/courier_warmachine_ambient.vpcf", false, "attach_smoke_1"}
DONATOR_COMPANION_ADDITIONAL_INFO["models/items/courier/butch_pudge_dog/butch_pudge_dog.vmdl"] = {"particles/econ/courier/courier_butch/courier_butch_ambient.vpcf", false, "attach_tongue"}
DONATOR_COMPANION_ADDITIONAL_INFO["models/courier/venoling/venoling.vmdl"] = {"particles/econ/courier/courier_venoling_gold/courier_venoling_ambient_gold.vpcf"}
DONATOR_COMPANION_ADDITIONAL_INFO["models/items/courier/chocobo/chocobo.vmdl"] = {"particles/econ/courier/courier_master_chocobo/courier_master_chocobo_ambient.vpcf"}
DONATOR_COMPANION_ADDITIONAL_INFO["models/courier/mega_greevil_courier/mega_greevil_courier.vmdl"] = {"particles/econ/courier/courier_mega_greevil/courier_mega_greevil_ambient.vpcf", false, "attach_mouth"}
DONATOR_COMPANION_ADDITIONAL_INFO["models/items/courier/snail/courier_snail.vmdl"] = {"particles/econ/courier/courier_snail/courier_snail_trail.vpcf"}
DONATOR_COMPANION_ADDITIONAL_INFO["models/items/courier/mighty_chicken/mighty_chicken.vmdl"] = {"particles/econ/courier/courier_cluckles/courier_cluckles_ambient.vpcf"}

-- DONATOR_COMPANION_ADDITIONAL_INFO["models/items/rubick/rubick_arcana/rubick_arcana_base.vmdl"] = {""}

SHARED_NODRAW_MODIFIERS = {
	"modifier_item_shadow_amulet_fade",
	"modifier_monkey_king_tree_dance_hidden",
	"modifier_monkey_king_transform",
	"modifier_pangolier_gyroshell",
	"modifier_smoke_of_deceit",
	"modifier_mutation_monkey_business_transform",
}
