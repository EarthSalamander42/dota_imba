// Dota IMBA Plus item builds generator

"use strict";

var kda_line_1;
var kda_line_2;
var kda_line_3;

var lhdn_line_1;
var lhdn_line_2;
var lhdn_line_3;

var nw_line_1;
var nw_line_2;
var nw_line_3;

(function() {
	if (!Game.IsInToolsMode()) {
		return;
	}

	var PlusStats = GameUI.Utils.FindDotaHudElement("stackable_side_panels").GetChild(1);
	var PlusContainer = PlusStats.FindChildTraverse("QuestStatusContainer");

	PlusStats.style.opacity = 1;

	for (var i = 0; i < PlusContainer.GetChildCount(); i++) {
		PlusContainer.GetChild(i).DeleteAsync(0);
	}

	PlusContainer.style.backgroundColor = "gradient( linear, 0% 0%, 100% 0%, from( #425663cc ), color-stop( .5, #42566355 ), to( #0000 ) )";

	var panel_width = 300;
	var panel_height = 30;

	var label_font_size = 17;

	var legend_column = $.CreatePanel("Panel", PlusContainer, "Legend_Column");
	legend_column.style.width = panel_width + "px";
	legend_column.style.height = panel_height + "px";
	legend_column.style.flowChildren = "right";

	var legend_line_1 = $.CreatePanel("Label", legend_column, "Legend_Line_1");
	legend_line_1.style.width = panel_width / 3 + "px";
	legend_line_1.style.height = panel_height + "px";
	legend_line_1.text = "Stat";
	legend_line_1.style.fontSize = label_font_size + "px";

	var legend_line_2 = $.CreatePanel("Label", legend_column, "Legend_Line_2");
	legend_line_2.style.width = panel_width / 3 + "px";
	legend_line_2.style.height = panel_height + "px";
	legend_line_2.text = "Current";
	legend_line_2.style.fontSize = label_font_size + "px";

	var legend_line_3 = $.CreatePanel("Label", legend_column, "Legend_Line_3");
	legend_line_3.style.width = panel_width / 3 + "px";
	legend_line_3.style.height = panel_height + "px";
	legend_line_3.text = "Goal";
	legend_line_3.style.fontSize = label_font_size + "px";

	var kda_column = $.CreatePanel("Panel", PlusContainer, "KDA_Column");
	kda_column.style.width = panel_width + "px";
	kda_column.style.height = panel_height + "px";
	kda_column.style.flowChildren = "right";

	kda_line_1 = $.CreatePanel("Label", kda_column, "KDA_Line_1");
	kda_line_1.style.width = panel_width / 3 + "px";
	kda_line_1.style.height = panel_height + "px";
	kda_line_1.text = "K/D/A";

	kda_line_2 = $.CreatePanel("Label", kda_column, "KDA_Line_2");
	kda_line_2.style.width = panel_width / 3 + "px";
	kda_line_2.style.height = panel_height + "px";
	kda_line_2.text = "0 / 0 / 0";

	kda_line_3 = $.CreatePanel("Label", kda_column, "KDA_Line_3");
	kda_line_3.style.width = panel_width / 3 + "px";
	kda_line_3.style.height = panel_height + "px";
	kda_line_3.text = "0 / 0 / 0";

	var lhdn_column = $.CreatePanel("Panel", PlusContainer, "LHDN_Column");
	lhdn_column.style.width = panel_width + "px";
	lhdn_column.style.height = panel_height + "px";
	lhdn_column.style.flowChildren = "right";

	lhdn_line_1 = $.CreatePanel("Label", lhdn_column, "LHDN_Line_1");
	lhdn_line_1.style.width = panel_width / 3 + "px";
	lhdn_line_1.style.height = panel_height + "px";
	lhdn_line_1.text = "LH/DN";

	lhdn_line_2 = $.CreatePanel("Label", lhdn_column, "LHDN_Line_2");
	lhdn_line_2.style.width = panel_width / 3 + "px";
	lhdn_line_2.style.height = panel_height + "px";
	lhdn_line_2.text = "0 / 0";

	lhdn_line_3 = $.CreatePanel("Label", lhdn_column, "LHDN_Line_3");
	lhdn_line_3.style.width = panel_width / 3 + "px";
	lhdn_line_3.style.height = panel_height + "px";
	lhdn_line_3.text = "0 / 0";

	var nw_column = $.CreatePanel("Panel", PlusContainer, "NW_Column");
	nw_column.style.width = panel_width + "px";
	nw_column.style.height = panel_height + "px";
	nw_column.style.flowChildren = "right";

	nw_line_1 = $.CreatePanel("Label", nw_column, "NW_Line_1");
	nw_line_1.style.width = panel_width / 3 + "px";
	nw_line_1.style.height = panel_height + "px";
	nw_line_1.text = "NW";

	nw_line_2 = $.CreatePanel("Label", nw_column, "NW_Line_2");
	nw_line_2.style.width = panel_width / 3 + "px";
	nw_line_2.style.height = panel_height + "px";
	nw_line_2.text = "0";

	nw_line_3 = $.CreatePanel("Label", nw_column, "NW_Line_3");
	nw_line_3.style.width = panel_width / 3 + "px";
	nw_line_3.style.height = panel_height + "px";
	nw_line_3.text = "0";

	$.Schedule(1.0, UpdateStats);
})();

function UpdateStats() {
	kda_line_2.text = Players.GetKills(Players.GetLocalPlayer()) + " / " + Players.GetDeaths(Players.GetLocalPlayer()) + " / " + Players.GetAssists(Players.GetLocalPlayer());
	lhdn_line_2.text = Players.GetLastHits(Players.GetLocalPlayer()) + " / " + Players.GetDenies(Players.GetLocalPlayer());
	nw_line_2.text = numberWithCommas(Players.GetTotalEarnedGold(Players.GetLocalPlayer()));

	$.Schedule(1.0, UpdateStats);
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// Entities.GetTotalDamageTaken()
// find a way to get physical/magical/pure damage taken to recreate the bar when pressing alt near stats
