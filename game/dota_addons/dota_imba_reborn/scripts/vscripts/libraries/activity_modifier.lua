-- Credits: https://steamcommunity.com/sharedfiles/filedetails?id=1663264349

--[[
  Lua-controlled ActivityModifier Library by pilaoda

  fix activity modifier on hero model
  --]]
if not ActivityModifier then
    ActivityModifier = {}
    ActivityModifier.__index = Wearable
    _G.ActivityModifier = ActivityModifier
end

local _ANIMATION_TRANSLATE_TO_CODE = {
    abysm = 13,
    admirals_prow = 307,
    agedspirit = 3,
    aggressive = 4,
    agrressive = 163,
    am_blink = 182,
    ancestors_edge = 144,
    ancestors_pauldron = 145,
    ancestors_vambrace = 146,
    ancestral_scepter = 67,
    ancient_armor = 6,
    anvil = 7,
    arcana = 8,
    armaments_set = 20,
    attack_long_range = 375,
    attack_normal_range = 376,
    axes = 188,
    backstab = 41,
    backstroke_gesture = 283,
    backward = 335,
    ball_lightning = 231,
    batter_up = 43,
    bazooka = 284,
    belly_flop = 180,
    berserkers_blood = 35,
    black = 44,
    black_hole = 194,
    bladebiter = 147,
    blood_chaser = 134,
    bolt = 233,
    bot = 47,
    brain_sap = 185,
    broodmother_spin = 50,
    burning_fiend = 148,
    burrow = 229,
    burrowed = 51,
    cat_dancer_gesture = 285,
    cauldron = 29,
    charge = 97,
    charge_attack = 98,
    chase = 246,
    chasm = 57,
    chemical_rage = 2,
    chicken_gesture = 258,
    come_get_it = 39,
    corpse_dress = 104,
    corpse_dresstop = 103,
    corpse_scarf = 105,
    cryAnimationExportNode = 341,
    crystal_nova = 193,
    culling_blade = 184,
    dagger_twirl = 143,
    dark_wraith = 174,
    darkness = 213,
    dc_sb_charge = 107,
    dc_sb_charge_attack = 108,
    dc_sb_charge_finish = 109,
    dc_sb_ultimate = 110,
    deadwinter_soul = 96,
    death_protest = 94,
    demon_drain = 116,
    desolation = 55,
    digger = 176,
    dismember = 218,
    divine_sorrow = 117,
    divine_sorrow_loadout = 118,
    divine_sorrow_loadout_spawn = 119,
    divine_sorrow_sunstrike = 120,
    dizzying_punch = 343,
    dog_of_duty = 342,
    dogofduty = 340,
    dominator = 254,
    dryad_tree = 311,
    dualwield = 14,
    duel_kill = 121,
    earthshock = 235,
    emp = 259,
    enchant_totem = 313,
    ["end"] = 243,
    eyeoffetizu = 34,
    f2p_doom = 131,
    face_me = 286,
    faces_hakama = 111,
    faces_mask = 113,
    faces_wraps = 112,
    fast = 10,
    faster = 11,
    fastest = 12,
    fear = 125,
    fiends_grip = 186,
    fiery_soul = 149,
    finger = 200,
    firefly = 190,
    fish_slap = 123,
    fishstick = 339,
    fissure = 195,
    flying = 36,
    focusfire = 124,
    forcestaff_enemy = 122,
    forcestaff_friendly = 15,
    forward = 336,
    fountain = 49,
    freezing_field = 191,
    frost_arrow = 37,
    frostbite = 192,
    frostiron_raider = 150,
    frostivus = 54,
    ftp_dendi_back = 126,
    gale = 236,
    get_burned = 288,
    giddy_up_gesture = 289,
    glacier = 101,
    glory = 345,
    good_day_sir = 40,
    great_safari = 267,
    greevil_black_hole = 58,
    greevil_blade_fury = 59,
    greevil_bloodlust = 60,
    greevil_cold_snap = 61,
    greevil_decrepify = 62,
    greevil_diabolic_edict = 63,
    greevil_echo_slam = 64,
    greevil_fatal_bonds = 65,
    greevil_ice_wall = 66,
    greevil_laguna_blade = 68,
    greevil_leech_seed = 69,
    greevil_magic_missile = 70,
    greevil_maledict = 71,
    greevil_miniboss_black_brain_sap = 72,
    greevil_miniboss_black_nightmare = 73,
    greevil_miniboss_blue_cold_feet = 74,
    greevil_miniboss_blue_ice_vortex = 75,
    greevil_miniboss_green_living_armor = 76,
    greevil_miniboss_green_overgrowth = 77,
    greevil_miniboss_orange_dragon_slave = 78,
    greevil_miniboss_orange_lightstrike_array = 79,
    greevil_miniboss_purple_plague_ward = 80,
    greevil_miniboss_purple_venomous_gale = 81,
    greevil_miniboss_red_earthshock = 82,
    greevil_miniboss_red_overpower = 83,
    greevil_miniboss_white_purification = 84,
    greevil_miniboss_yellow_ion_shell = 85,
    greevil_miniboss_yellow_surge = 86,
    greevil_natures_attendants = 87,
    greevil_phantom_strike = 88,
    greevil_poison_nova = 89,
    greevil_purification = 90,
    greevil_shadow_strike = 91,
    greevil_shadow_wave = 92,
    groove_gesture = 305,
    ground_pound = 128,
    guardian_angel = 215,
    guitar = 290,
    hang_loose_gesture = 291,
    happy_dance = 293,
    harlequin = 129,
    haste = 45,
    hook = 220,
    horn = 292,
    immortal = 28,
    impale = 201,
    impatient_maiden = 100,
    impetus = 138,
    injured = 5,
    ["injured rare"] = 247,
    injured_aggressive = 130,
    instagib = 21,
    iron = 255,
    iron_surge = 99,
    item_style_2 = 133,
    jump_gesture = 294,
    laguna = 202,
    leap = 206,
    level_1 = 140,
    level_2 = 141,
    level_3 = 142,
    life_drain = 219,
    loadout = 0,
    loda = 173,
    lodestar = 114,
    loser = 295,
    lsa = 203,
    lucentyr = 158,
    lute = 296,
    lyreleis_breeze = 159,
    mace = 160,
    mag_power_gesture = 298,
    magic_ends_here = 297,
    mana_drain = 204,
    mana_void = 183,
    manias_mask = 135,
    manta = 38,
    mask_lord = 299,
    masquerade = 25,
    meld = 162,
    melee = 334,
    miniboss = 164,
    moon_griffon = 166,
    moonfall = 165,
    moth = 53,
    nihility = 95,
    obeisance_of_the_keeper = 151,
    obsidian_helmet = 132,
    odachi = 32,
    offhand_basher = 42,
    omnislash = 198,
    overpower1 = 167,
    overpower2 = 168,
    overpower3 = 169,
    overpower4 = 170,
    overpower5 = 171,
    overpower6 = 172,
    pegleg = 248,
    phantom_attack = 16,
    pinfold = 175,
    plague_ward = 237,
    poison_nova = 238,
    portrait_fogheart = 177,
    poundnpoint = 300,
    powershot = 242,
    punch = 136,
    purification = 216,
    pyre = 26,
    qop_blink = 221,
    ravage = 225,
    red_moon = 30,
    reincarnate = 115,
    remnant = 232,
    repel = 217,
    requiem = 207,
    roar = 187,
    robot_gesture = 301,
    roshan = 181,
    run = 372,
    run_fast = 373,
    salvaged_sword = 152,
    sandking_rubyspire_burrowstrike = 52,
    sb_bracers = 251,
    sb_helmet = 250,
    sb_shoulder = 252,
    sb_spear = 253,
    scream = 222,
    serene_honor = 153,
    shadow_strike = 223,
    shadowraze = 208,
    shake_moneymaker = 179,
    sharp_blade = 303,
    shinobi = 27,
    shinobi_mask = 154,
    shinobi_tail = 23,
    shrapnel = 230,
    silent_ripper = 178,
    slam = 196,
    slasher_chest = 262,
    slasher_mask = 263,
    slasher_offhand = 261,
    slasher_weapon = 260,
    sm_armor = 264,
    sm_head = 56,
    sm_shoulder = 265,
    snipe = 226,
    snowangel = 17,
    snowball = 102,
    sonic_wave = 224,
    sparrowhawk_bow = 269,
    sparrowhawk_cape = 270,
    sparrowhawk_hood = 272,
    sparrowhawk_quiver = 271,
    sparrowhawk_shoulder = 273,
    spin = 199,
    split_shot = 1,
    sprint = 275,
    sprout = 209,
    staff_swing = 304,
    stalker_exo = 93,
    start = 249,
    stinger = 280,
    stolen_charge = 227,
    stolen_firefly = 189,
    strike = 228,
    sugarrush = 276,
    suicide_squad = 18,
    summon = 210,
    sven_shield = 256,
    sven_warcry = 257,
    swag_gesture = 287,
    swordonshoulder = 155,
    taunt_fullbody = 19,
    taunt_killtaunt = 139,
    taunt_quickdraw_gesture = 268,
    taunt_roll_gesture = 302,
    techies_arcana = 9,
    telebolt = 306,
    teleport = 211,
    thirst = 137,
    tidebringer = 24,
    tidehunter_boat = 22,
    tidehunter_toss_fish = 312,
    tidehunter_yippy = 347,
    timelord_head = 309,
    tinker_rollermaw = 161,
    torment = 279,
    totem = 197,
    transition = 278,
    trapper = 314,
    tree = 310,
    trickortreat = 277,
    triumphant_timelord = 127,
    turbulent_teleport = 308,
    twinblade_attack = 315,
    twinblade_attack_b = 316,
    twinblade_attack_c = 317,
    twinblade_attack_d = 318,
    twinblade_attack_injured = 319,
    twinblade_death = 320,
    twinblade_idle = 321,
    twinblade_idle_injured = 322,
    twinblade_idle_rare = 323,
    twinblade_injured_attack_b = 324,
    twinblade_jinada = 325,
    twinblade_jinada_injured = 326,
    twinblade_shuriken_toss = 327,
    twinblade_shuriken_toss_injured = 328,
    twinblade_spawn = 329,
    twinblade_stun = 330,
    twinblade_track = 331,
    twinblade_track_injured = 332,
    twinblade_victory = 333,
    twister = 274,
    unbroken = 106,
    vendetta = 337,
    viper_strike = 239,
    viridi_set = 338,
    void = 214,
    vortex = 234,
    walk = 371,
    wall = 240,
    ward = 241,
    wardstaff = 344,
    wave = 205,
    web = 48,
    whalehook = 156,
    whats_that = 281,
    when_nature_attacks = 31,
    white = 346,
    windrun = 244,
    windy = 245,
    winterblight = 157,
    witchdoctor_jig = 282,
    with_item = 46,
    wolfhound = 266,
    wraith_spin = 33,
    wrath = 212,
    rampant = 348,
    overload = 349,
    surge = 350,
    es_prosperity = 351,
    Espada_pistola = 352,
    overload_injured = 353,
    ss_fortune = 354,
    liquid_fire = 355,
    jakiro_icemelt = 356,
    jakiro_roar = 357,
    chakram = 358,
    doppelwalk = 359,
    enrage = 360,
    fast_run = 361,
    overpower = 362,
    overwhelmingodds = 363,
    pregame = 364,
    shadow_dance = 365,
    shukuchi = 366,
    strength = 367,
    twinblade_run = 368,
    twinblade_run_injured = 369,
    windwalk = 370,
    ["<none>"] = 374,
    spear = 377,
    faces_vest = 378,
    slasher_shoulder = 379,
    slasher_arms = 380,
    slasher_belt = 381,
    ancestral = 382,
    spirit = 383,
    ancestors_belt = 384,
    sm_weapons = 385,
    sm_belt = 386,
    shinobi_wraps = 387,
    shinobi_shoulder = 388,
    faces_katana = 389,
    sb_offhand = 390,
    regalia_bonelord = 391,
    ernest_pipe = 392,
    lightning = 393,
    olde_pipe = 394,
    yuwipi = 395,
    MGC = 396,
    shade = 397,
    eldwurm = 398,
    reprisal = 399,
    basher = 400,
    suffer = 401,
    darkclaw = 402,
    whiskey = 403,
    banana_gesture = 404,
    dive = 405,
    eztzhok = 406,
    eztzhok_off = 407,
    immosh = 408,
    solar = 409,
    para = 410,
    priest = 411,
    tako = 412,
    force = 413,
    shard = 414,
    crimson = 415,
    light = 416,
    burn = 417,
    juggle_gesture = 418,
    hell_gesture = 419,
    disco_gesture = 420,
    tears = 421,
    ogre_hop_gesture = 422,
    sideflip_gesture = 423,
    blowkiss_gesture = 424,
    terror = 425,
    pogo_gesture = 426,
    ti7 = 427,
    pudge_ti7_immortal = 428,
    green = 429,
    weaver_ti7_immortal = 430,
    viper_immortal_head_ti7 = 431,
    bm_ti7_immortal_shoulder = 432,
    pl_ti7_immortal_shoulder = 433,
    rage_gesture = 434,
    funky_gesture = 435,
    ti4 = 436,
    auspice = 437,
    hydro = 438,
    ti6 = 439,
    fallen_legion = 440,
    hoard = 441,
    jade = 442,
    starstorm = 443,
    augur_arm = 444,
    latch = 445,
    falcon = 446,
    harpoon = 447,
    shards = 448,
    fur = 449,
    voodoo = 450,
    rain_gesture = 451,
    inner_peace_gesture = 452,
    selemene_gesture = 453,
    ti8_taunt = 454,
    dreamleague = 455,
    bonkers_the_mad = 456,
    aeons = 457,
    ["Hero_Magnataur.ShockWave.Cast.Anvil"] = 458,
    spike = 459,
    walk_gesture = 460,
    apex = 461,
    mermaid = 462,
    ashes = 463,
    tactician = 464,
    bladeform_pants = 465,
    favor = 466,
    silent = 467,
    freeze = 468,
    arcana_style = 469,
    red = 470,
    scholar = 471,
    lycosidae_spread = 472,
    shark_up = 473,
    spectre_ti7_immortal = 474,
    head_roll_gesture = 475,
    break_gesture = 476,
    swing_around_gesture = 477,
    smoke = 478,
    treant_ti7_immortal = 479,
    immortal_cape = 480,
    kotl_ti7_immortal = 481,
    back = 482,
    rage = 483,
    assassin = 484,
    immortal_shoulder = 485,
    musket = 486,
    rose = 487,
    rope = 488,
    corkscrew_gesture = 489,
    kunkka_dance_gesture = 490,
    thirst_loadout = 491,
    ti8 = 492,
    guns = 493,
    focal = 494,
    owl_mount = 495,
    bombadillo = 496,
    nords = 497,
    ti8_taunt_cooked = 498,
    tube_ti8 = 499,
    arcana_skip = 500,
    ti8_immortal = 501,
    ti8_style_1 = 502,
    viper_ti8_immortal_tail = 503,
    dance = 504,
    legion_commander_ti8 = 505,
    centaur_taunt_gesture = 506,
    keg_roll_gesture = 507,
    dota_plus_head = 508,
    dota_plus = 509,
    ["2018_frostivus"] = 510,
    Tsukumo_mount = 511,
    level1 = 512,
    level2 = 513,
    level3 = 514,
    level4 = 515,
    level5 = 516,
    level6 = 517,
    super_fast = 518,
    attack_closest_range = 519,
    attack_close_range = 520,
    attack_medium_range = 521
}

LinkLuaModifier(
    "modifier_attack_speed_activity",
    "libraries/modifiers/modifier_attack_speed_activity.lua",
    LUA_MODIFIER_MOTION_NONE
)
LinkLuaModifier(
    "modifier_movement_speed_activity",
    "libraries/modifiers/modifier_movement_speed_activity.lua",
    LUA_MODIFIER_MOTION_NONE
)
LinkLuaModifier(
    "modifier_attack_range_activity",
    "libraries/modifiers/modifier_attack_range_activity.lua",
    LUA_MODIFIER_MOTION_NONE
)

LinkLuaModifier("modifier_activity0", "libraries/modifiers/modifier_activity0.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity1", "libraries/modifiers/modifier_activity1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity2", "libraries/modifiers/modifier_activity2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity3", "libraries/modifiers/modifier_activity3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity4", "libraries/modifiers/modifier_activity4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity5", "libraries/modifiers/modifier_activity5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity6", "libraries/modifiers/modifier_activity6.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity7", "libraries/modifiers/modifier_activity7.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity8", "libraries/modifiers/modifier_activity8.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity9", "libraries/modifiers/modifier_activity9.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity10", "libraries/modifiers/modifier_activity10.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity11", "libraries/modifiers/modifier_activity11.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity12", "libraries/modifiers/modifier_activity12.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity13", "libraries/modifiers/modifier_activity13.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity14", "libraries/modifiers/modifier_activity14.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity15", "libraries/modifiers/modifier_activity15.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity16", "libraries/modifiers/modifier_activity16.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity17", "libraries/modifiers/modifier_activity17.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity18", "libraries/modifiers/modifier_activity18.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity19", "libraries/modifiers/modifier_activity19.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity20", "libraries/modifiers/modifier_activity20.lua", LUA_MODIFIER_MOTION_NONE)

function GetTable(ParentTable, key)
    if not ParentTable[key] then
        ParentTable[key] = {}
    end
    return ParentTable[key]
end

function SwitchKeyValue(t)
    local new_t = {}
    for k, v in pairs(t) do
        new_t[v] = k
    end
    return new_t
end

function ActivityModifier:Init()
    ActivityModifier.units = {}
    local custom_units = LoadKeyValues("scripts/npc/npc_units_custom.txt")
    for unit_name, unit_table in pairs(custom_units) do
        if type(unit_table) == "table" then
            if unit_table.AttackSpeedActivityModifiers then
                local unit_modifiers = GetTable(ActivityModifier.units, unit_name)
                unit_modifiers["AttackSpeedActivityModifiers"] = SwitchKeyValue(unit_table.AttackSpeedActivityModifiers)
            end
            if unit_table.MovementSpeedActivityModifiers then
                local unit_modifiers = GetTable(ActivityModifier.units, unit_name)
                unit_modifiers["MovementSpeedActivityModifiers"] =
                    SwitchKeyValue(unit_table.MovementSpeedActivityModifiers)
            end
            if unit_table.AttackRangeActivityModifiers then
                local unit_modifiers = GetTable(ActivityModifier.units, unit_name)
                unit_modifiers["AttackRangeActivityModifiers"] = SwitchKeyValue(unit_table.AttackRangeActivityModifiers)
            end
        end
    end
    ActivityModifier.THINK_INTERVAL = 1 / 30
end

function ActivityModifier:AddActivityModifierThink(hUnit)
    local sUnitName = hUnit:GetUnitName()
    local Modifiers = ActivityModifier.units[sUnitName]
    if Modifiers then
        hUnit:SetContextThink(
            "self:ThinkActivity",
            function()
                return self:ThinkActivity(hUnit)
            end,
            0
        )
    end
end

function ActivityModifier:ThinkActivity(hUnit)
    local MoveSpeedAM = ActivityModifier.units[hUnit:GetUnitName()].MovementSpeedActivityModifiers
    if MoveSpeedAM then
        local nMoveSpeed = hUnit:GetIdealSpeed()
        local translate = nil
        local maxModifierSpeed = -1
        for speed, activity_modifier in pairs(MoveSpeedAM) do
            if nMoveSpeed > speed and speed > maxModifierSpeed then
                maxModifierSpeed = speed
                translate = activity_modifier
            end
        end
        if hUnit.sMoveSpeedTranslate ~= translate then
            if hUnit:HasModifier("modifier_movement_speed_activity") then
                hUnit:RemoveModifierByName("modifier_movement_speed_activity")
            end
            if translate then
                hUnit:AddNewModifier(hUnit, nil, "modifier_movement_speed_activity", {translate = translate})
                hUnit:SetModifierStackCount(
                    "modifier_movement_speed_activity",
                    hUnit,
                    _ANIMATION_TRANSLATE_TO_CODE[translate]
                )
            end
            hUnit.sMoveSpeedTranslate = translate
        end
    end

    local AttackSpeedAM = ActivityModifier.units[hUnit:GetUnitName()].AttackSpeedActivityModifiers
    if AttackSpeedAM then
        local nAttackSpeed = hUnit:GetAttackSpeed() * 100
        local translate = nil
        local maxModifierSpeed = -1
        for speed, activity_modifier in pairs(AttackSpeedAM) do
            if nAttackSpeed > speed and speed > maxModifierSpeed then
                maxModifierSpeed = speed
                translate = activity_modifier
            end
        end
        if hUnit.sAttackSpeedTranslate ~= translate then
            if hUnit:HasModifier("modifier_attack_speed_activity") then
                hUnit:RemoveModifierByName("modifier_attack_speed_activity")
            end
            if translate then
                hUnit:AddNewModifier(hUnit, nil, "modifier_attack_speed_activity", {translate = translate})
                hUnit:SetModifierStackCount(
                    "modifier_attack_speed_activity",
                    hUnit,
                    _ANIMATION_TRANSLATE_TO_CODE[translate]
                )
            end
            hUnit.sAttackSpeedTranslate = translate
        end
    end

    local AttackRangeAM = ActivityModifier.units[hUnit:GetUnitName()].AttackRangeActivityModifiers
    if AttackRangeAM then
        local target = hUnit:GetAttackTarget()
        local translate = nil
        for modifier_distance, activity_modifier in pairs(AttackRangeAM) do
            translate = activity_modifier
            break
        end
        if not hUnit:HasModifier("modifier_attack_range_activity") then
            hUnit:AddNewModifier(hUnit, nil, "modifier_attack_range_activity", {translate = translate})
            hUnit:SetModifierStackCount(
                "modifier_attack_range_activity",
                hUnit,
                _ANIMATION_TRANSLATE_TO_CODE[translate]
            )
        end
    end

    return ActivityModifier.THINK_INTERVAL
end

function ActivityModifier:RemoveWearableActivity(hUnit, sItemDef)
    for _, sActIndex in ipairs(hUnit.Activities[sItemDef]) do
        local sModifierName = "modifier_activity" .. sActIndex
        if hUnit:HasModifier(sModifierName) then
            hUnit:RemoveModifierByName(sModifierName)
        end

        hUnit.ActIndexPool[sActIndex] = nil
    end
    hUnit.Activities[sItemDef] = nil
end

function ActivityModifier:AddWearableActivity(hUnit, translate, sItemDef)
    -- print(translate, sItemDef)
    hUnit.ActIndexPool = hUnit.ActIndexPool or {}
    hUnit.Activities = hUnit.Activities or {}
    for i = 0, 20 do
        local sActIndex = tostring(i)
        if not hUnit.ActIndexPool[sActIndex] then
            local sModifierName = "modifier_activity" .. sActIndex
            hUnit.ActIndexPool[sActIndex] = sItemDef
            hUnit:AddNewModifier(hUnit, nil, sModifierName, {translate = translate})
            hUnit:SetModifierStackCount(sModifierName, hUnit, _ANIMATION_TRANSLATE_TO_CODE[translate])

            -- print(hUnit, translate, sActIndex, sItemDef)
            hUnit.Activities[sItemDef] = hUnit.Activities[sItemDef] or {}
            table.insert(hUnit.Activities[sItemDef], sActIndex)
            break
        end
    end
end

if not ActivityModifier.heroes then
    ActivityModifier:Init()
end
