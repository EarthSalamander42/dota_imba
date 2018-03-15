/**
 * Copyright (C) 2018 The Dota IMBA Development Team
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 * 
 * Editors: suthernfriend
 * 
 */

"use strict";

var events = {
	hostReady : "imba_teamselect_host_ready",
	compute : "imba_teamselect_compute",
	computeComplete : "imba_teamselect_compute_complete",
	complete : "imba_teamselect_complete",
	joinTeam : "imba_teamselect_join_team",
	failure : "imba_teamselect_failure"
};

var OnTeamChanged = function(data) {
	UpdateManuallyAssignTeamsUI();
};

var OnJoinTeam = function() {
	GameEvents.SendCustomGameEventToServer(events.joinTeam, {})
}

var OnComplete = function(data) {
	// we are finally done
	if (Game.GetLocalPlayerInfo().player_has_host_privileges) {
		$.Msg("Team selection completed");
		Game.SetAutoLaunchEnabled(false);
		// start game in 5 secs
		$.Msg("Starting game in 5 seconds")
		Game.SetRemainingSetupTime(5);
	}
};

var OnCompute = function(data) {
	// auto assign teams and fire event
	if (Game.GetLocalPlayerInfo().player_has_host_privileges) {
		Game.AutoAssignPlayersToTeams();
		GameEvents.SendCustomGameEventToServer(events.computeComplete, {});
	}
};

var OnFailure = function(data) {
	// on failure we do backup shizzle
	if (Game.GetLocalPlayerInfo().player_has_host_privileges) {
		$.Msg("Team selection failed. Making backup team assignments");
		Game.AutoAssignPlayersToTeams();
		OnComplete();
	}
};

var LegacyCompatSetupUI = function() {
	$("#TeamsList").visible = false;
	$("#StartGameCountdownTimer").visible = false;
	$("#UnassignedPlayerPanel").visible = false;
	$("#LockAndStartButton").visible = false;
	$("#CancelAndUnlockButton").visible = false;

	var mapInfo = Game.GetMapInfo();
	var map_name = mapInfo.map_display_name.replace('_', " ")
	$("#MapInfo").SetDialogVariable("map_name", map_name);
	
	$("#AutoTeamSelectInfo").RemoveClass("invisible");
	$("#AutoTeamSelectInfoLabel").text = "IMBA Matchmaking™";
	$("#AutoTeamSelectInfoLabel2").text = "Powered by";
};

(function() {

	// only operate on 5v5 and 10v10
	if ((Game.GetMapInfo().map_display_name == "imba_ranked_5v5")
			|| (Game.GetMapInfo().map_display_name == "imba_ranked_10v10")) {
		LegacyCompatSetupUI();
		if (Game.GetLocalPlayerInfo().player_has_host_privileges) {
			Game.SetAutoLaunchEnabled(false);
			GameEvents.Subscribe(events.compute, OnCompute);
			GameEvents.Subscribe(events.complete, OnComplete);
			GameEvents.Subscribe(events.failure, OnFailure);
			GameEvents.SendCustomGameEventToServer(events.hostReady, {});
		}
	}

})();
