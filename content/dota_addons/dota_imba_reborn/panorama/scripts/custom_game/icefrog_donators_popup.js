"use strict";

var hud = $.GetContextPanel().GetParent().GetParent().GetParent();
var root_panel = $.GetContextPanel();
var topbar = hud.FindChildTraverse("topbar");

if (Game.IsInToolsMode()) {
	root_panel.RemoveAndDeleteChildren();
}

var radiant_donators = [
	["1: ONO PERseverance ZONNOZ", "green"],
	["2: Snick", "darkred"],
	["3: Sijumah", "lightgrey"],
	["4: Gordon Ramsay", "orange"],
	["5: KimcilJahat", "black"],
];

var dire_donators = [
	["1: Acalia", "acalia_blue"],
	["2: General Atrox", "icefrog_blue"],
	["3: Miku MIku MIKu MIKU !!", "miku_blue"],
	["4: Anh Hùng Nùp", "anh_pink"],
	["5: Kiddo", "red"],
];

/*
var radiant_donators = {
	"1: ONO PERseverance ZONNOZ": "green",
	"2: Snick": "green",
	"3: Sijumah": "green",
	"4: Gordon Ramsay": "green",
	"5: KimcilJahat": "green",
};

var dire_donators = {
	"1: Acalia": "green",
	"2: General Atrox": "green",
	"3: Miku MIku MIKu MIKU !!": "green",
	"4: Anh Hùng Nùp": "green",
	"5: Kiddo": "green",
};
*/

var healthbars = new Map();

function SetHealthBar() {
	var all = Entities.GetAllEntitiesByClassname('ent_dota_shop');
	var radiant_shop = undefined;
	var dire_shop = undefined;
	var radiant_dist_check = 100000;
	var dire_dist_check = 100000;
	var shops = [];

	var radiant_spawn_point = Entities.GetAllEntitiesByClassname("info_player_start_goodguys")[0];
	var dire_spawn_point = Entities.GetAllEntitiesByClassname("info_player_start_badguys")[0];

	all.forEach(function (v) {
		if (Entities.IsAlive(v)) {
			if (!radiant_shop)
				radiant_shop = v;

			if (!dire_shop)
				dire_shop = v;

			var x1 = Entities.GetAbsOrigin(v)[0];
			var y1 = Entities.GetAbsOrigin(v)[1];

			var x2 = Entities.GetAbsOrigin(radiant_spawn_point)[0];
			var y2 = Entities.GetAbsOrigin(radiant_spawn_point)[1];
			var radiant_dist = Math.sqrt( Math.pow((x1-x2), 2) + Math.pow((y1-y2), 2) );

			if (radiant_dist_check > radiant_dist) {
				radiant_dist_check = radiant_dist;
				radiant_shop = v;
			}

			var x3 = Entities.GetAbsOrigin(dire_spawn_point)[0];
			var y3 = Entities.GetAbsOrigin(dire_spawn_point)[1];
			var dire_dist = Math.sqrt( Math.pow((x1-x3), 2) + Math.pow((y1-y3), 2) );

			if (dire_dist_check > dire_dist) {
				dire_dist_check = dire_dist;
				dire_shop = v;
			}
		}
	});

	shops[0] = radiant_shop;
	shops[1] = dire_shop;

	shops.forEach(function (v) {
		var x1 = Entities.GetAbsOrigin(v)[0];
		var y1 = Entities.GetAbsOrigin(v)[1];
		var x2 = x1;
		var y2 = y1;
		if (GameUI.GetScreenWorldPosition()) {
			y2 = GameUI.GetScreenWorldPosition()[1];
			x2 = GameUI.GetScreenWorldPosition()[0];
		}
		var dist = Math.sqrt( Math.pow((x1-x2), 2) + Math.pow((y1-y2), 2) );

//		$.Msg(dist)
		if (dist < 3000) {
			if (healthbars.has(v)) {
				var panel = healthbars.get(v);
				healthbars.get(v).style.opacity = "1";
			} else {
				var panel = $.CreatePanel("Panel", root_panel, "healthbar" + v);
				panel.BLoadLayoutSnippet('hpbar');
				healthbars.set(v, panel);

				if (v == shops[0]) {
					radiant_donators.forEach(function(v) {
						var label = $.CreatePanel('Label', panel.GetChild(0), '');
						label.AddClass(v[1]);
						label.text = v[0];
					})
				} else {
					dire_donators.forEach(function(v) {
						var label = $.CreatePanel('Label', panel.GetChild(0), '');
						label.AddClass(v[1]);
						label.text = v[0];
					})
				}

				var exit_button = $.CreatePanel("Panel", panel, "exitbutton" + v);
				exit_button.BLoadLayoutSnippet('exit');
			}
		} else {
			if (healthbars.has(v)) {
				var panel = healthbars.get(v);
				panel.style.opacity = "0";
			}
		}
	})

//	$.Msg(radiant_shop);
//	$.Msg(dire_shop);

	$.Schedule(0.1, SetHealthBar);
}

function hpbarmove() {
	var uiw = root_panel.actuallayoutwidth, uih = root_panel.actuallayoutheight;

	healthbars.forEach(function (v, k) {
		var vec = Entities.GetAbsOrigin(k);
		var uix_offset = -v.desiredlayoutwidth;
		var uiy_offset = -320;

		if (Game.GetLocalPlayerInfo() && Game.GetLocalPlayerInfo().player_team_id) {
			// fix for enemy team hpbar positions
			if (vec[1] > 0 && Game.GetLocalPlayerInfo().player_team_id == 2 || vec[1] < 0 && Game.GetLocalPlayerInfo().player_team_id == 3) {
				uiy_offset = -280;
			}

			var scrx = Game.WorldToScreenX(vec[0], vec[1], vec[2]);
			var scry = Game.WorldToScreenY(vec[0], vec[1], vec[2]);
			var uix = scrx + uix_offset;
			var uiy = scry + uiy_offset;

	//		$.Msg(scrx)

			if (uiw != 0 && uih != 0 && scrx != -1 && scry != -1) {
				var uixp = uix / uiw * 100, uiyp = uiy / uih * 100;

				v.style.position = uixp + '% ' + uiyp + '% -15%';
				v.SetHasClass("invis", false);
	//			v.style['zIndex'] = vec[1] / 100 * -1;
			}
		}

	});

	$.Schedule(0, hpbarmove);
}

function HideButton() {
	$.GetContextPanel().style.opacity = 0;
}

(function() {
	if (Game.GetMapInfo().map_display_name != "imba_demo") {
		SetHealthBar();
		hpbarmove();
	}
})();
