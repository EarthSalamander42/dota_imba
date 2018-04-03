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
		throw new HudNotFoundException(
				'Could not find Hud root as parent of panel with id: '
						+ $.GetContextPanel().id);
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
 * Author: EarthSalamander #42 Credits: EarthSalamander #42
 */

function IsDonator() {
	var i = 0
	if (CustomNetTables.GetTableValue("game_options", "donators") == undefined) {
		return false;
	}

	var local_steamid = Game.GetLocalPlayerInfo().player_steamid;
	var donators = CustomNetTables.GetTableValue("game_options", "donators");
		
	for (var key in donators) {
		var steamid = donators[key];
		if (local_steamid === steamid)
			return true;
	}

	return false;
}

function HideIMR(panel) {
	var map_info = Game.GetMapInfo();
	var imr_panel = panel.FindChildrenWithClassTraverse("es-legend-imr");
	var imr_panel_10v10 = panel
			.FindChildrenWithClassTraverse("es-legend-imr10v10");
	var rank1v1_panel = panel
			.FindChildrenWithClassTraverse("es-legend-rank1v1");

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
	} else if (map_info.map_display_name == "imba_frantic_5v5"
			|| map_info.map_display_name == "imba_frantic_10v10") {
		hide(imr_panel_10v10);
		hide(imr_panel);
		hide(rank1v1_panel);
	}
}
