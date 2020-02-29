"use strict";

function OnUIUpdated(table_name, key, data) {
	UpdateScoreUI();
}
CustomNetTables.SubscribeNetTableListener("game_options", OnUIUpdated)

function UpdateScoreUI() {
	var map_info = Game.GetMapInfo();
	if (map_info.map_display_name == "imba_overthrow" || map_info.map_display_name == "imba_1v1") {
		return;
	}

	var RoshanTable = CustomNetTables.GetTableValue("game_options", "roshan");
	if (RoshanTable !== null) {
		var RoshanHP = RoshanTable.HP;
		var RoshanHP_percent = RoshanTable.HP_alt;
		var RoshanMaxHP = RoshanTable.maxHP;
		var RoshanLvl = RoshanTable.level;
		$("#RoshanProgressBar").value = RoshanHP_percent / 100;

		$("#RoshanHealth").text = RoshanHP + "/" + RoshanMaxHP;
		$("#RoshanLevel").text = "Level: " + RoshanLvl;
	}
}

function ShowRoshanBar(args) {
	$("#RoshanHP").style.visibility = "visible";
}

function HideRoshanBar(args) {
	$("#RoshanHP").style.visibility = "collapse";
}

(function () {
	GameEvents.Subscribe("update_score", UpdateScoreUI);
	GameEvents.Subscribe("show_roshan_hp", ShowRoshanBar);
	GameEvents.Subscribe("hide_roshan_hp", HideRoshanBar);

	if (Game.GetMapInfo().map_display_name != "cavern" && Game.GetMapInfo().map_display_name != "imba_overthrow") {
		return;
	} else {
		$.GetContextPanel().DeleteAsync(0)
	}
})();
