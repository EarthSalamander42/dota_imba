/* global $ */
'use strict';

/*
 * Author: Angel Arena Blackstar Credits: Angel Arena Blackstar
 */

if (typeof module !== 'undefined' && module.exports) {
	module.exports.FindDotaHudElement = FindDotaHudElement;
	module.exports.ColorToHexCode = ColorToHexCode;
	module.exports.ColoredText = ColoredText;
	module.exports.LuaTableToArray = LuaTableToArray;
}

var HudNotFoundException = /** @class */
(function() {
	function HudNotFoundException(message) {
		this.message = message;
	}
	return HudNotFoundException;
}());

function FindDotaHudElement(id) {
	return GetDotaHud().FindChildTraverse(id);
}

function GetDotaHud() {
	var p = $.GetContextPanel();
	while (p !== null && p.id !== 'Hud') {
		p = p.GetParent();
	}
	if (p === null) {
		throw new HudNotFoundException('Could not find Hud root as parent of panel with id: ' + $.GetContextPanel().id);
	} else {
		return p;
	}
}

/**
 * Takes an array-like table passed from Lua that has stringified indices
 * starting from 1 and returns an array of type T containing the elements of the
 * table. Order of elements is preserved.
 */
function LuaTableToArray(table) {
	var array = [];

	for (var i = 1; table[i.toString()] !== undefined; i++) {
		array.push(table[i.toString()]);
	}

	return array;
}

/**
 * Takes an integer and returns a hex code string of the color represented by
 * the integer
 */
function ColorToHexCode(color) {
	var red = (color & 0xff).toString(16);
	var green = ((color & 0xff00) >> 8).toString(16);
	var blue = ((color & 0xff0000) >> 16).toString(16);

	return '#' + red + green + blue;
}

function ColoredText(colorCode, text) {
	return '<font color="' + colorCode + '">' + text + '</font>';
}

/*
 * Credits: Gafu Ji (not working atm needs to be fixed)
 */

/*
function IsDonator(ID) {
	if (var donators = CustomNetTables.GetTableValue("game_options", "donators")) {
		var local_steamid = Game.GetPlayerInfo(ID).player_steamid;
		// Assuming donators is an array
		if (donators.indexOf(local_steamid) > -1) {
			return true;
		}
	}
	return false;
}
*/

/*
 * Credits: EarthSalamander #42
 */

function IsDonator(ID) {
	var i = 0
	if (CustomNetTables.GetTableValue("game_options", "donators") == undefined) {
		return false;
	}

	var local_steamid = Game.GetPlayerInfo(ID).player_steamid;
	var donators = CustomNetTables.GetTableValue("game_options", "donators");

	for (var key in donators) {
		var steamid = donators[key];
		if (local_steamid === steamid)
			return true;
	}

	return false;
}

function IsDeveloper(ID) {
	var i = 0
	if (CustomNetTables.GetTableValue("game_options", "developers") == undefined) {
		return false;
	}

	var local_steamid = Game.GetPlayerInfo(ID).player_steamid;
	var developers = CustomNetTables.GetTableValue("game_options", "developers");
		
	for (var key in developers) {
		var steamid = developers[key];
		if (local_steamid === steamid)
			return true;
	}

	return false;
}

function HideIMR(panel) {
	var map_info = Game.GetMapInfo();
	var imr_panel = panel.FindChildrenWithClassTraverse("es-legend-imr");
	var imr_panel_10v10 = panel.FindChildrenWithClassTraverse("es-legend-imr10v10");
	var rank1v1_panel = panel.FindChildrenWithClassTraverse("es-legend-rank1v1");

	var hide = function(panels) {
		for ( var i in panels)
			panels[i].style.visibility = "collapse";
	};

	if (map_info.map_display_name == "imba_ranked_5v5") {
		hide(imr_panel_10v10);
		hide(rank1v1_panel);
	} else if (map_info.map_display_name == "imba_ranked_10v10") {
		hide(imr_panel);
		hide(rank1v1_panel);
	} else if (map_info.map_display_name == "imba_1v1") {
		hide(imr_panel_10v10);
		hide(imr_panel);
	} else if (map_info.map_display_name == "imba_frantic_5v5" || map_info.map_display_name == "imba_frantic_10v10") {
		hide(imr_panel_10v10);
		hide(imr_panel);
		hide(rank1v1_panel);
	}
}

function OverrideTopBarHeroImage(args) {
	var arcana_level = args.arcana
	var team = "Radiant"
	if (Players.GetTeam(Players.GetLocalPlayer()) == 3) {
		team = "Dire"
	}

	var panel = FindDotaHudElement(team + "Player" + Players.GetLocalPlayer()).FindChildTraverse("HeroImage")
	if (panel) {OverrideHeroImage(arcana_level, panel, args.hero_name)}
}
GameEvents.Subscribe("override_hero_image", OverrideTopBarHeroImage);

/*
if (FindDotaHudElement("RadiantPlayer" + Players.GetLocalPlayer()).FindChildTraverse("HeroImage")) {
	var panel =  FindDotaHudElement("RadiantPlayer" + Players.GetLocalPlayer()).FindChildTraverse("HeroImage")
	$.Msg(panel)
	OverrideHeroImage("2", panel, "pudge", "topbar")
}
*/

function OverrideHeroImage(arcana_level, panel, hero_name) {
	if (arcana_level != false) {
		if (arcana_level > 1) {arcana_level = 1}
		// list of heroes wich have arcana implented in imbattlepass
		var newheroimage = $.CreatePanel('Panel', panel, '');
		newheroimage.style.width = "100%";
		newheroimage.style.height = "100%";
		newheroimage.style.backgroundImage = 'url("file://{images}/heroes/npc_dota_hero_' + hero_name + '_arcana' + arcana_level + '.png")';
		newheroimage.style.backgroundSize = "cover";

//		panel.style.border = "1px solid #99ff33";
//		panel.style.boxShadow = "fill lightgreen -4px -4px 8px 8px";

//		var newherolabel = $.CreatePanel('Label', panel, '');
//		newherolabel.AddClass("Arcana")
//		newherolabel.text = "Arcana!"
	}
}

//	function OverrideTopBarColor(args) {
//		var team = "Radiant"
//		if (Players.GetTeam(Players.GetLocalPlayer()) == 3) {
//			team = "Dire"
//		}
//	
//		var panel = FindDotaHudElement(team + "Player" + Players.GetLocalPlayer())
//		var picked_hero = Game.GetLocalPlayerInfo().player_selected_hero
//	
//		picked_hero = picked_hero.replace('npc_dota_hero_', "")
//	
//		var color = args.color.replace('0X', '#')
//	
//		if (panel.FindChildTraverse("HeroImage").heroname == picked_hero) {
//			if (panel.FindChildTraverse("PlayerNewColor")) {
//				return;
//			} else {
//				var color_panel = $.CreatePanel('Panel', panel.FindChildTraverse("PlayerColor"), 'PlayerNewColor');
//				color_panel.style.width = "100%";
//				color_panel.style.height = "4px";
//				color_panel.style.backgroundColor = color;
//				color_panel.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/topbar_playerslot_vignette_psd.vtex")';
//				color_panel.style.backgroundSize = '92% 100%';
//				color_panel.style.backgroundRepeat = 'no-repeat';
//	
//	//			$.Msg("---------------")
//	//			$.Msg(color_panel.style.backgroundColor)
//	//			$.Msg(color)
//			}
//		}
//	}

//	GameEvents.Subscribe("override_top_bar_colors", OverrideTopBarColor);
