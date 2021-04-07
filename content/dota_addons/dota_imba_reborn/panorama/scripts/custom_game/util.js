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

// Somehow called multiple times, creating many panels for nothing
function OverrideTopBarHeroImage(args) {
	var team = "Radiant"

	if (Players.GetTeam(args.player_id) == 3) {
		team = "Dire"
	}

	var panel = FindDotaHudElement(team + "Player" + args.player_id).FindChildTraverse("HeroImage")
	var newheroimage = $.CreatePanel('Panel', panel, '');
	newheroimage.style.width = "100%";
	newheroimage.style.height = "100%";
	newheroimage.style.backgroundImage = 'url("file://{images}/heroes/' + args.icon_path + '.png")';
	newheroimage.style.backgroundSize = "cover";
}

GameEvents.Subscribe("override_hero_image", OverrideTopBarHeroImage);

/*
if (FindDotaHudElement("RadiantPlayer" + Players.GetLocalPlayer()).FindChildTraverse("HeroImage")) {
	var panel =  FindDotaHudElement("RadiantPlayer" + Players.GetLocalPlayer()).FindChildTraverse("HeroImage")
	$.Msg(panel)
	OverrideHeroImage("0", panel, "lina")
}
*/

function OverrideTopBarColor() {
	var colors = CustomNetTables.GetTableValue("game_options", "player_colors");

	for (var id in colors) {
		if (Players.GetTeam(parseInt(id)) && Players.GetTeam(parseInt(id)) && Players.GetTeam(parseInt(id)) != 1) {
			var team = "Radiant"

			if (Players.GetTeam(parseInt(id)) == 3) {
				team = "Dire"
			}

			var panel = FindDotaHudElement(team + "Player" + id)
	//		$.Msg(id)

			if (panel)
				panel.FindChildTraverse('PlayerColor').style.backgroundColor = colors[id];
		}
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
	donator_colors[7] = "#871414";
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

function SetupLoadingScreen(args) {
	var value = "collapse";
	if (args && args.value)
		value = args.value;

	if (Parent.FindChildTraverse("GameAndPlayersRoot") == undefined || Parent.FindChildTraverse("TeamsList") == undefined || Parent.FindChildTraverse("TeamsListGroup") == undefined || Parent.FindChildTraverse("CancelAndUnlockButton") == undefined || Parent.FindChildTraverse("UnassignedPlayerPanel") == undefined || Parent.FindChildTraverse("ShuffleTeamAssignmentButton") == undefined)
		$.Schedule(0.25, SetupLoadingScreen);
	else {
		Parent.FindChildTraverse("GameAndPlayersRoot").style.visibility = value;
		var cancel = Parent.FindChildTraverse("CancelAndUnlockButton");
		var lock = Parent.FindChildTraverse("LockAndStartButton");
		var shuffle = Parent.FindChildTraverse("ShuffleTeamAssignmentButton");

//		if (Game.IsInToolsMode() == false) {
//			Parent.FindChildTraverse("ShuffleTeamAssignmentButton").style.visibility = value;
//			cancel.style.visibility = value;
//			lock.style.visibility = value;
//		} else {
			var parent = Parent.FindChildTraverse("TeamsList");
			var header = Parent.FindChildTraverse("TeamsListGroup");

			var game_info = Parent.FindChildTraverse("GameAndPlayersRoot").FindChildTraverse("GameInfoPanel");
			var map_label = Parent.FindChildTraverse("MapInfoLabel");
			var text = "Re-ordering teams based on seasonal winrate, please wait";

			map_label.text = text;
			SetTeamOrderingText(map_label);

			if (game_info) {
				game_info.SetParent(parent);
				parent.MoveChildBefore(game_info, header);
			}

			if (parent.FindChildTraverse("GameInfoPanel"))
				parent.MoveChildBefore(parent.FindChildTraverse("GameInfoPanel"), header);

//			if (Game.IsInToolsMode() == false) {
				if (cancel)
					cancel.style.visibility = value;

				if (lock)
					lock.style.visibility = value;

				if (shuffle)
					shuffle.style.visibility = value;
//			} else {
//				if (cancel)
//					cancel.SetParent(parent);

//				if (lock)
//					lock.SetParent(parent);
//			}

//			Parent.FindChildTraverse("TeamsListGroup").SetParent(Parent.FindChildTraverse("GameAndPlayersRoot"))
//			Parent.FindChildTraverse("TeamsListGroup").style.verticalAlign = "top";
//			Parent.FindChildTraverse("TeamsListGroup").style.width = "99%";
//		}
	}
}

GameEvents.Subscribe("setup_loading_screen", SetupLoadingScreen);