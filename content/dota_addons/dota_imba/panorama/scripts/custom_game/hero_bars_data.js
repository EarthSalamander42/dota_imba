
var colors = {
	2: [ 255, 82, 66 ],
	3: [ 48, 168, 255 ] ,
	6: [ 197, 77, 168 ],
	7: [ 199, 228, 13 ],
	8: [ 161, 127, 255 ],
	9: [ 101, 212, 19 ]
};

var shieldModifiers = [
	"modifier_gyro_w",
	"modifier_lc_w_shield",
	"modifier_undying_q_health"
];

var hideBarModifiers = [
	"modifier_tusk_e",
	"modifier_ember_e",
	"modifier_hidden",
	"modifier_omni_e",
	"modifier_gyro_e",
	"modifier_storm_spirit_e",
	"modifier_ursa_e",
	"modifier_ursa_r",
	"modifier_drow_e",
	"modifier_earth_spirit_r",
];

var etherealModifiers = [
	"modifier_invoker_w"
];

var recastModifiers = [
	"modifier_gyro_w",
	"modifier_jugger_e",
	"modifier_cm_e",
	"modifier_earth_spirit_w_recast",
	"modifier_nevermore_q"
];

var specialLayouts = {
	"npc_dota_hero_ursa": "UrsaBar",
	//"npc_dota_hero_juggernaut": "JuggBar",
	"npc_dota_hero_undying": "UndyingBar"
};

var specialOffsetModifiers = {};

var customIcons = {};
var abilityData = {};

specialOffsetModifiers.npc_dota_hero_undying = function(entity) {
	if (HasModifier(entity, "modifier_undying_r")) {
		return GetStackCount(entity, "modifier_undying_q_health") * 40;
	}

	return GetStackCount(entity, "modifier_undying_q_health") * 20;
};

var ultimateAbilities = {};

function AddUltimateAbility(name, color) {
	ultimateAbilities[name] = {
		token: "#StatusUltimate",
		color: color
	}
}

var specialLayoutCallbacks = {};

specialLayoutCallbacks.npc_dota_hero_ursa = function(entity, panel) {
	var fury = FindModifier(entity.id, "modifier_ursa_fury");
	var frenzy = FindModifier(entity.id, "modifier_ursa_frenzy");
	var bar = panel.FindChildTraverse("UrsaRage");

	panel.FindChildTraverse("UrsaRage_Left").SetHasClass("UrsaFrenzy", !!frenzy);

	if (frenzy) {
		bar.value = 100;
	} else if (fury) {
		bar.value = Buffs.GetStackCount(entity.id, fury);
	}
};

//	SubscribeToNetTableKey("static", "abilities", true, function(data) {
//	abilityData = data;
//	});

AddUltimateAbility("wk_r", "#49f299");
AddUltimateAbility("gyro_r", "#ff6d10");
AddUltimateAbility("wr_r", "#8cff27");
AddUltimateAbility("drow_r",  "#6aace7");
AddUltimateAbility("lycan_r",  "#ff2b12");
AddUltimateAbility("earth_spirit_r",  "#2dd422");
AddUltimateAbility("nevermore_r",  "#b00600");