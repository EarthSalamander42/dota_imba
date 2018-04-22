"use strict";

function LoadPlayers() {
	// var radiantPlayers = DOTATeam_t.DOTA_TEAM_GOODGUYS
	// var direPlayers = DOTATeam_t.DOTA_TEAM_BADDGUYS

	// GenerateGGPanel(radiantPlayers)
	// GenerateGGPanel(direPlayers)
}

function GenerateGGTopBar(player) {
	var team = Game.GetPlayerInfo(player).player_team_id;
	var team_string;
	if (team == 2) {
		team_string = "Radiant";
	} else if (team == 3) {
		team_string ="Dire";
	}
	var TopBarHud = FindDotaHudElement(team_string + 'Player' + player).FindChildTraverse('SlantedContainerPanel');
			
	if (!TopBarHud.FindChildTraverse("GGBar-" + player)) {

		var gg_row = $.CreatePanel("Panel", TopBarHud, "GGBar-" + player);
		gg_row.AddClass("GG_Row");
		gg_row.style.backgroundColor = "gradient(linear,0  100%, 0% 0%, from(#800314b6),color-stop( 0.9, #0a1722ae ), to(#0a1722ae))";
		gg_row.style.width = "100%";
		gg_row.style.height = "100%";
		gg_row.style.align = "center center";
		gg_row.style.zIndex = "5";
		gg_row.style.textAlign = "center center";
		gg_row.style.flowChildren = "right";

		var gg_left_line = $.CreatePanel('Panel', gg_row, "");
		gg_left_line.style.width = "12px";
		gg_left_line.style.height = "2px";
		gg_left_line.style.backgroundColor = "gradient( linear, 100% 0, 0% 0%, from( #f26600 ), color-stop( 0.4, #f26600 ), to( #f2001300 ) )";
		gg_left_line.style.align = "left bottom";
		gg_left_line.style.margin = "0 0 7px 8px";


		var gg_label = $.CreatePanel('Label', gg_row, "");
		gg_label.text = "GG";
		gg_label.style.fontSize = "14px";
		gg_label.style.align = "center bottom";
		gg_label.style.color = "#f26600";
		gg_label.style.textShadow = "1px 1px 3px 2.0 #000000aa";
		gg_label.style.margin = "0 0 -2px 6px";

		var gg_right_line = $.CreatePanel('Panel', gg_row, "");
		gg_right_line.style.width = "12px";
		gg_right_line.style.height = "2px";
		gg_right_line.style.backgroundColor = "gradient( linear, 0 0, 100%  0%, from( #f26600 ), color-stop( 0.4, #f26600 ), to( #f2001300 ) )";
		gg_right_line.style.align = "right bottom";
		gg_right_line.style.margin = "0 5px 7px 0";

	}
}


// function GenerateGGPanel(team) {
// 	if (Game.GetPlayerInfo(Game.GetLocalPlayerID()).player_team_id == team) {
// 		var team_string;
// 		if (team == 2) {
// 			team_string = "Radiant";
// 		} else if (team == 3) {
// 			team_string ="Dire";
// 		}


// 		var ids = Game.GetPlayerIDsOnTeam(team);

// 		$.Each(ids, function(player) {

// 			var TopBarHud = FindDotaHudElement(team_string + 'Player' + player).FindChildTraverse('SlantedContainerPanel');
			
// 			if (!TopBarHud.FindChildTraverse("GGBar-" + player)) {
// 				var gg_row = $.CreatePanel("Panel", TopBarHud, "GGBar-" + player);
// 				gg_row.AddClass("GG_Row");
// 				gg_row.style.backgroundColor = "gradient(linear,0  100%, 0% 0%, from(#800314b6),color-stop( 0.9, #0a1722ae ), to(#0a1722ae))";
// 				gg_row.style.width = "100%";
// 				gg_row.style.height = "100%";
// 				gg_row.style.align = "center center";
// 				gg_row.style.zIndex = "5";
// 				gg_row.style.textAlign = "center center";
// 				gg_row.style.flowChildren = "right";

// 				var gg_left_line = $.CreatePanel('Panel', gg_row, "");
// 				gg_left_line.style.width = "12px";
// 				gg_left_line.style.height = "2px";
// 				gg_left_line.style.backgroundColor = "gradient( linear, 100% 0, 0% 0%, from( #f26600 ), color-stop( 0.4, #f26600 ), to( #f2001300 ) )";
// 				gg_left_line.style.align = "left bottom";
// 				gg_left_line.style.margin = "0 0 7px 8px";



// 				var gg_label = $.CreatePanel('Label', gg_row, "");
// 				gg_label.text = "GG";
// 				gg_label.style.fontSize = "14px";
// 				gg_label.style.align = "center bottom";
// 				gg_label.style.color = "#f26600";
// 				gg_label.style.textShadow = "1px 1px 3px 2.0 #000000aa";
// 				gg_label.style.margin = "0 0 -2px 6px";

// 				var gg_right_line = $.CreatePanel('Panel', gg_row, "");
// 				gg_right_line.style.width = "12px";
// 				gg_right_line.style.height = "2px";
// 				gg_right_line.style.backgroundColor = "gradient( linear, 0 0, 100%  0%, from( #f26600 ), color-stop( 0.4, #f26600 ), to( #f2001300 ) )";
// 				gg_right_line.style.align = "right bottom";
// 				gg_right_line.style.margin = "0 5px 7px 0";
// 			}
// 			// button.SetPanelEvent('onactivate', function () { VoteGG(player, button, true); });
// 		});
// 	}
// }

function VoteGG(ID, panel, Vote) {
	if (panel.BHasClass("voted")) {
		return;
	}

	if (Game.GetPlayerInfo(Game.GetLocalPlayerID()).player_team_id == 2) {
		radiant_vote_count = radiant_vote_count + 1
		$("#gg_count").text = $.Localize("#gg_count") + radiant_vote_count + "/" + radiant_player_count
	} else if (Game.GetPlayerInfo(Game.GetLocalPlayerID()).player_team_id == 3) {
		dire_vote_count = dire_vote_count + 1
		$("#gg_count").text = $.Localize("#gg_count") + dire_vote_count + "/" + dire_player_count
	}

	panel.AddClass("voted")
	panel.FindChildTraverse("GG" + ID + "_label").text = "Has GG!"

	GameEvents.SendCustomGameEventToServer("send_gg_vote", {
		ID: ID,
		Vote: Vote
	});
}



(function() {
	LoadPlayers();
	GenerateGGTopBar(0);
})();
