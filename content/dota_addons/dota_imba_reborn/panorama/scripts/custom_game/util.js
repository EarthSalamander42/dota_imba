/* global $ */
'use strict';

/* Author: Angel Arena Blackstar Credits: Angel Arena Blackstar */
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

/* Credits: EarthSalamander #42 */
function IsDonator(ID) {
	var i = 0
	if (CustomNetTables.GetTableValue("game_options", "donators") == undefined) {
		return false;
	}

	var local_steamid = Game.GetPlayerInfo(ID).player_steamid;
	var donators = CustomNetTables.GetTableValue("game_options", "donators");
	$.Msg(donators)

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
	var imr_panel = panel.FindChildrenWithClassTraverse("ScoreCol_ImbaImr5v5");
	var imr_panel_10v10 = panel.FindChildrenWithClassTraverse("ScoreCol_ImbaImr10v10");
	var imr_panel_1v1 = panel.FindChildrenWithClassTraverse("ScoreCol_ImbaImr1v1");

	var end_imr5v5 = panel.FindChildrenWithClassTraverse("es-legend-imr");
	var end_imr10v10 = panel.FindChildrenWithClassTraverse("es-legend-imr10v10");
	var end_imr1v1 = panel.FindChildrenWithClassTraverse("es-legend-imr1v1");

	var show = function(panels) {
		for ( var i in panels)
			panels[i].style.visibility = "visible";
	};

	if (map_info.map_display_name == "ranked_5v5") {
		show(imr_panel);
		show(end_imr5v5);
	} else if (map_info.map_display_name == "ranked_10v10") {
		show(imr_panel_10v10);
		show(end_imr10v10);
	} else if (map_info.map_display_name == "ranked_1v1") {
		show(imr_panel_1v1);
		show(end_imr1v1);
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

function OverrideTopBarColor() {
	var colors = CustomNetTables.GetTableValue("game_options", "player_colors")

	for (var id in colors) {
//		if (!Players.GetTeam(parseInt(id))) {return $.Msg("No player for this ID, stop loop.")};
		if (!Players.GetTeam(parseInt(id))) {return};
		var team = "Radiant"

		if (Players.GetTeam(parseInt(id)) == 3) {
			team = "Dire"
		}

		var panel = FindDotaHudElement(team + "Player" + id)
//		$.Msg(id)
		panel.FindChildTraverse('PlayerColor').style.backgroundColor = colors[id];
	}    
}

GameEvents.Subscribe("override_top_bar_colors", OverrideTopBarColor);

// Mutation tooltips (used in mutation.js and hero_selection.js)
var mutation = [];

function Mutation(args) {
	mutation[0] = args["imba"]
	mutation[1] = args["positive"]
	mutation[2] = args["negative"]
	mutation[3] = args["terrain"]

	if ($("#Mutations"))
	{
		$("#Mutations").style.visibility = "visible";

		for (var j = 0; j <= 3; j++) {
			SetMutationTooltip(j)
		}
	}
}

function SetMutationTooltip(j) {
	var panel = $("#Mutation" + j)

	$("#Mutation" + j + "Label").text = $.Localize("mutation_" + mutation[j]);

	panel.SetPanelEvent("onmouseover", function () {
		$.DispatchEvent("UIShowTextTooltip", panel, $.Localize("mutation_" + mutation[j] + "_Description"));
	})

	panel.SetPanelEvent("onmouseout", function () {
		$.DispatchEvent("UIHideTextTooltip", panel);
	})
}

GameEvents.Subscribe("send_mutations", Mutation);
