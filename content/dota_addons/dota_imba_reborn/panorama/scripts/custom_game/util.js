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

	for (var key in donators) {
		var steamid = key;
		var status = donators[key];
		if (local_steamid === steamid && status != 1 || status != 2)
			return status;
	}

	return false;
}

function IsDeveloper(ID) {
	var i = 0
	if (CustomNetTables.GetTableValue("game_options", "donators") == undefined) {
		return false;
	}

	var local_steamid = Game.GetPlayerInfo(ID).player_steamid;
	var developers = CustomNetTables.GetTableValue("game_options", "donators");
		
	for (var key in developers) {
		var steamid = developers[key].steamid;
		var status = developers[key].status;
		if (local_steamid === steamid && status == 1 || status == 2)
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
	var herolist = CustomNetTables.GetTableValue('hero_selection', 'herolist')
	var arcana_level = undefined;
	var ply_battlepass = CustomNetTables.GetTableValue("battlepass", Game.GetLocalPlayerID());

	if (herolist && herolist.customlist["npc_dota_hero_" + args.hero_name]) {
		arcana_level = 7777
	} else {
		if (ply_battlepass && ply_battlepass.arcana) {
			if (ply_battlepass.arcana["npc_dota_hero_" + args.hero_name] != undefined) {
				arcana_level = ply_battlepass.arcana["npc_dota_hero_" + args.hero_name];
			} else {
//				$.Msg("No arcana found for this hero.")
				return;
			}
		}
	}

	var team = "Radiant"
	if (Players.GetTeam(args.player_id) == 3) {
		team = "Dire"
	}

	if (FindDotaHudElement(team + "Player" + args.player_id) && arcana_level != undefined) {
		var panel = FindDotaHudElement(team + "Player" + args.player_id).FindChildTraverse("HeroImage")
		if (panel) {OverrideHeroImage(arcana_level, panel, args.hero_name)}
	}
}

GameEvents.Subscribe("override_hero_image", OverrideTopBarHeroImage);

/*
if (FindDotaHudElement("RadiantPlayer" + Players.GetLocalPlayer()).FindChildTraverse("HeroImage")) {
	var panel =  FindDotaHudElement("RadiantPlayer" + Players.GetLocalPlayer()).FindChildTraverse("HeroImage")
	$.Msg(panel)
	OverrideHeroImage("0", panel, "lina")
}
*/

function OverrideHeroImage(arcana_level, panel, hero_name) {
	for (var i = 0; i < panel.GetChildCount(); i++) {
		panel.GetChild(i).DeleteAsync(0);
	}

	if (arcana_level !== false) {
		// list of heroes wich have arcana implented in battlepass
		var newheroimage = $.CreatePanel('Panel', panel, '');
		newheroimage.style.width = "100%";
		newheroimage.style.height = "100%";
		if (arcana_level == 7777)
			newheroimage.style.backgroundImage = 'url("file://{images}/heroes/npc_dota_hero_' + hero_name + '.png")';
		else
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
//	$.Msg(panel)

	$("#Mutation" + j + "Label").text = $.Localize("mutation_" + mutation[j]);

	panel.SetPanelEvent("onmouseover", function () {
		$.DispatchEvent("UIShowTextTooltip", panel, $.Localize("mutation_" + mutation[j] + "_Description"));
	})

	panel.SetPanelEvent("onmouseout", function () {
		$.DispatchEvent("UIHideTextTooltip", panel);
	})
}

GameEvents.Subscribe("send_mutations", Mutation);

// temporary
function DonatorStatusConverter(new_status) {
	if (new_status == 6)
		return 1;
	else if (new_status == 5)
		return 2;
	else if (new_status == 4)
		return 3;
	else if (new_status == 7)
		return 4;
	else if (new_status == 8)
		return 5;
	else if (new_status == 9)
		return 6;
	else if (new_status == 1)
		return 102;
	else if (new_status == 2)
		return 101;
	else if (new_status == 3)
		return 100;
}

function DonatorStatusConverterReverse(new_status) {
	if (new_status == 1)
		return 6;
	else if (new_status == 2)
		return 5;
	else if (new_status == 3)
		return 4;
	else if (new_status == 4)
		return 7;
	else if (new_status == 5)
		return 8;
	else if (new_status == 6)
		return 9;
	else if (new_status == 100)
		return 3;
	else if (new_status == 101)
		return 2;
	else if (new_status == 102)
		return 1;
}

function GetDonatorColor(status) {
	// lua donator status are still using old numbers
//	var donator_colors = CustomNetTables.GetTableValue("game_options", "donator_colors")
//	$.Msg("Donator colors:")
//	$.Msg(donator_colors)

	// Placeholder
	var donator_colors = [];
	donator_colors[1] = "#00CC00";
	donator_colors[2] = "#DAA520";
	donator_colors[3] = "#DC2828";
	donator_colors[4] = "#993399";
	donator_colors[5] = "#2F5B97";
	donator_colors[6] = "#BB4B0A";
	donator_colors[100] = "#0066FF";
	donator_colors[101] = "#641414";
	donator_colors[102] = "#871414";

	return donator_colors[status];
}

GameEvents.Subscribe("toggle_ui", ToggleUI);

var toggle_ui = true;

function ToggleUI() {
	if (toggle_ui == true) {
		FindDotaHudElement("HUDElements").style.visibility = "collapse";
		FindDotaHudElement("CustomUIRoot").style.visibility = "collapse";
		toggle_ui = false;
	} else {
		FindDotaHudElement("HUDElements").style.visibility = "visible";
		FindDotaHudElement("CustomUIRoot").style.visibility = "visible";
		toggle_ui = true;
	}
}
