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
		// start game in 5 secs
		$.Msg("Starting game in 5 seconds")
//		Game.SetRemainingSetupTime(5);
	}
};

var OnCompute = function(data) {
	// auto assign teams and fire event
	if (Game.GetLocalPlayerInfo().player_has_host_privileges) {
		$.Msg("OnCompute...")
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

(function() {

	var mapsWithAutoSelect = [ "ranked_5v5" ];

	// dont run this script on normal maps or when state is not team-select
	if (mapsWithAutoSelect.indexOf(Game.GetMapInfo().map_display_name) == -1 || Game.GetState() != 2)
		return;

	if (Game.GetLocalPlayerInfo().player_has_host_privileges) {
		Game.SetAutoLaunchEnabled(true);
		GameEvents.Subscribe(events.compute, OnCompute);
		GameEvents.Subscribe(events.complete, OnComplete);
		GameEvents.Subscribe(events.failure, OnFailure);
		GameEvents.SendCustomGameEventToServer(events.hostReady, {});
	}
})();
