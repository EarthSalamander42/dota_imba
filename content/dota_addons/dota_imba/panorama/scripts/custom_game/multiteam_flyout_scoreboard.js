"use strict";

var g_ScoreboardHandle = null;
var g_flyoutUpdateTimer = null;


function UpdateFlyoutScoreboard() {
	ScoreboardUpdater_SetScoreboardActive(g_ScoreboardHandle, true);
	g_flyoutUpdateTimer = $.Schedule(0.2, UpdateFlyoutScoreboard);
}

function SetFlyoutScoreboardVisible(bVisible) {
	$.GetContextPanel().SetHasClass("flyout_scoreboard_visible", bVisible);
	if (bVisible) {
		UpdateFlyoutScoreboard();
	} else { 
		ScoreboardUpdater_SetScoreboardActive(g_ScoreboardHandle, false);
		if (g_flyoutUpdateTimer) {
			$.CancelScheduled(g_flyoutUpdateTimer);
			g_flyoutUpdateTimer = null;
		}
	}
}

(function () {
	if (Game.GetMapInfo().map_display_name == "cavern") {
		$.GetContextPanel().style.visibility = "collapse";
		return;
	}

	if (ScoreboardUpdater_InitializeScoreboard === null) {
		$.Msg("WARNING: This file requires shared_scoreboard_updater.js to be included.");
	}

	var scoreboardConfig = {
		"teamXmlName": "file://{resources}/layout/custom_game/multiteam_flyout_scoreboard_team.xml",
		"playerXmlName": "file://{resources}/layout/custom_game/multiteam_flyout_scoreboard_player.xml",
	};

	g_ScoreboardHandle = ScoreboardUpdater_InitializeScoreboard(scoreboardConfig, $("#TeamsContainer"));

	SetFlyoutScoreboardVisible(false);

	HideIMR($.GetContextPanel());

	$.RegisterEventHandler("DOTACustomUI_SetFlyoutScoreboardVisible", $.GetContextPanel(), SetFlyoutScoreboardVisible);
})();
