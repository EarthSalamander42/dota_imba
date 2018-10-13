"use strict";

function UpdateScoreUI(args) {
	var progress = (args.count / args.max_count) * 100;
	$("#precache-progress").style.width = progress + "%";
	$("#precache-label").text = "Precaching: " + progress.toFixed(1) + "%";

	if (progress == 100) {
		$("#precache-label").text = "Selecting hero..."
		$.Schedule(1.0, CheckPickedHero)
	}
}

function CheckPickedHero() {
	if (Game.GetLocalPlayerInfo().player_selected_hero != "npc_dota_hero_dummy_dummy")
		$.GetContextPanel().DeleteAsync(0)
	else
		$.Schedule(1.0, CheckPickedHero)
}

function ShowUI(args) {
	$("#precache").style.visibility = args.visibility;
}

(function () {
	GameEvents.Subscribe("ardm_ui", ShowUI);
	GameEvents.Subscribe("hero_selection_precache", UpdateScoreUI);
})();
