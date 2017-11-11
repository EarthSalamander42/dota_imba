"use strict";

var toggle = false
function ToggleGameOptions() {
	var bool = ""

	if (toggle == false) {
		toggle = true
		$("#ImbaGameInfo").style.visibility = "visible"
	} else {
		toggle = false
		$("#ImbaGameInfo").style.visibility = "collapse"
	}
}

(function () {
	// Update the game options display
	var bounty_multiplier = CustomNetTables.GetTableValue("game_options", "bounty_multiplier");
	var exp_multiplier = CustomNetTables.GetTableValue("game_options", "exp_multiplier");
	var creep_power = CustomNetTables.GetTableValue("game_options", "creep_power");
	var tower_power = CustomNetTables.GetTableValue("game_options", "tower_power");
	var respawn_multiplier = CustomNetTables.GetTableValue("game_options", "respawn_multiplier");
	var initial_gold = CustomNetTables.GetTableValue("game_options", "initial_gold");
	var initial_level = CustomNetTables.GetTableValue("game_options", "initial_level");
	var max_level = CustomNetTables.GetTableValue("game_options", "max_level");
	var kills_to_end = CustomNetTables.GetTableValue("game_options", "kills_to_end");
	var frantic_mode = CustomNetTables.GetTableValue("game_options", "frantic_mode");
	var frantic = "Disabled";

	if (frantic_mode == true) {
		frantic = "Enabled"
	}

	$("#BountyMultiplierValue").text = bounty_multiplier[1] + "%";
	$("#ExpMultiplierValue").text = exp_multiplier[1] + "%";
	$("#InitialGoldValue").text = initial_gold[1];
	$("#InitialLevelValue").text = initial_level[1];
	$("#MaxLevelValue").text = max_level[1];
	$("#FranticModeValue").text = frantic;

	if (tower_power[1] == 1) {
		$("#TowerPowerValue").text = $.Localize( '#imba_gamemode_settings_power_1' );
	} else if (tower_power[1] == 2) {
		$("#TowerPowerValue").text = $.Localize( '#imba_gamemode_settings_power_2' );
	}

	if (creep_power[1] == 1) {
		$("#CreepPowerValue").text = $.Localize( '#imba_gamemode_settings_power_1' );
	} else if (creep_power[1] == 2) {
		$("#CreepPowerValue").text = $.Localize( '#imba_gamemode_settings_power_2' );
	} else if (creep_power[1] == 3) {
		$("#CreepPowerValue").text = $.Localize( '#imba_gamemode_settings_power_3' );
	}
})();
