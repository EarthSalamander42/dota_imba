"use strict";

var progress = 0;

/* Initialisation - runs when the element is created
=========================================================================*/
(function () {})();

/* Subscribe to events
=========================================================================*/
GameEvents.Subscribe("contest_started", ShowContestUI);
GameEvents.Subscribe("radiant_point_to_radiant", RadiantPointToRadiant);
GameEvents.Subscribe("radiant_point_to_dire", RadiantPointToDire);
GameEvents.Subscribe("dire_point_to_radiant", DirePointToRadiant);
GameEvents.Subscribe("dire_point_to_dire", DirePointToDire);
GameEvents.Subscribe("radiant_progress_update", RadiantProgressUpdate);
GameEvents.Subscribe("dire_progress_update", DireProgressUpdate);
GameEvents.Subscribe("radiant_score_update", RadiantScoreUpdate);
GameEvents.Subscribe("dire_score_update", DireScoreUpdate);

// Makes the arena contest UI visible
function ShowContestUI() {
	$('#ArenaTopBarContainer').style.visibility = 'visible';
	var points_to_end = CustomNetTables.GetTableValue("game_options", "kills_to_end");
	$('#CenterObjectivePoints').text = points_to_end[1];
}

// Makes the radiant contest point progress bar green
function RadiantPointToRadiant() {
	$('#RadiantProgressBar').style.visibility = 'visible';
	$('#RadiantTakenProgressBar').style.visibility = 'collapse';
}

// Makes the radiant contest point progress bar red
function RadiantPointToDire() {
	$('#RadiantProgressBar').style.visibility = 'collapse';
	$('#RadiantTakenProgressBar').style.visibility = 'visible';
}

// Makes the dire contest point progress bar green
function DirePointToRadiant() {
	$('#DireProgressBar').style.visibility = 'collapse';
	$('#DireTakenProgressBar').style.visibility = 'visible';
}

// Makes the dire contest point progress bar red
function DirePointToDire() {
	$('#DireProgressBar').style.visibility = 'visible';
	$('#DireTakenProgressBar').style.visibility = 'collapse';
}

// Updates the Radiant contest point's progress bar
function RadiantProgressUpdate() {
	var progress = CustomNetTables.GetTableValue("arena_capture", "radiant_progress");
	if (progress[1] >= 0) {
		$('#RadiantProgressBar').value = progress[1];
		$('#RadiantTakenProgressBar').value = progress[1];
	} else {
		$('#RadiantProgressBar').value = (-1) * progress[1];
		$('#RadiantTakenProgressBar').value = (-1) * progress[1];
	}
}

// Updates the Dire contest point's progress bar
function DireProgressUpdate() {
	var progress = CustomNetTables.GetTableValue("arena_capture", "dire_progress");
	if (progress[1] >= 0) {
		$('#DireProgressBar').value = progress[1];
		$('#DireTakenProgressBar').value = progress[1];
	} else {
		$('#DireProgressBar').value = (-1) * progress[1];
		$('#DireTakenProgressBar').value = (-1) * progress[1];
	}
}

// Updates the Radiant team 's score
function RadiantScoreUpdate() {
	var score = CustomNetTables.GetTableValue("arena_capture", "radiant_score");
	$('#RadiantScoreLabel').text = score[1];
}

// Updates the Dire team 's score
function DireScoreUpdate() {
	var score = CustomNetTables.GetTableValue("arena_capture", "dire_score");
	$('#DireScoreLabel').text = score[1];
}