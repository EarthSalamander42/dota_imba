"use strict";

var radiant_vote_count = 0
var dire_vote_count = 0
var radiant_player_count = 0
var dire_player_count = 0

function LoadPlayers() {
	var radiantPlayers = 2
	var direPlayers = 3

	GenerateGGPanel(radiantPlayers)
	GenerateGGPanel(direPlayers)
}

function GenerateGGPanel(team) {
	if (Game.GetPlayerInfo(Game.GetLocalPlayerID()).player_team_id == team) {
		var ids = Game.GetPlayerIDsOnTeam(team);
		$.Each(ids, function(player) {
			var PlayerPanel = $("#Players")
			var info = Game.GetPlayerInfo(player)
			var player_row = $.CreatePanel("Panel", PlayerPanel, "");
			player_row.AddClass("PlayerRow")

			var steam_id = $.CreatePanel("DOTAAvatarImage", player_row, "");
			steam_id.steamid = info.player_steamid
			steam_id.style.width = "50px";
			steam_id.style.height = "50px";
			steam_id.style.borderLeft = "1px solid grey";
			steam_id.style.borderTop = "1px solid grey";
			steam_id.style.borderRight = "1px solid grey";
			steam_id.style.borderBottom = "1px solid grey";

			var player_name = $.CreatePanel('Label', player_row, "");
			player_name.AddClass("GG_label")
			player_name.AddClass("GG_player_name")
			player_name.text = info.player_name

			if (player == Game.GetLocalPlayerID()) {
				var button = $.CreatePanel('Button', player_row, "GG" + player);
				button.AddClass("GG")
				button.SetPanelEvent('onactivate', function () { VoteGG(player, button, team, true); });

				var label = $.CreatePanel('Label', button, "GG" + player + "_label");
				label.AddClass("GG_label")
				label.text = "Call GG"
			} else {
				// add label to show if allies has GG'd
				var button = $.CreatePanel('Panel', player_row, "GG" + player);
				button.AddClass("not_GG")

				var label = $.CreatePanel('Label', button, "GG" + player + "_label");
				label.AddClass("GG_label")
				label.text = "Not GG"
			}

			if (team == 2) {
				radiant_player_count = radiant_player_count + 1
			} else if (team == 3) {
				dire_player_count = dire_player_count + 1
			}
		});

		if (Game.GetPlayerInfo(Game.GetLocalPlayerID()).player_team_id == 2) {
			$("#gg_count").text = $.Localize("#gg_count") + "0/" + radiant_player_count
		} else if (Game.GetPlayerInfo(Game.GetLocalPlayerID()).player_team_id == 3) {
			$("#gg_count").text = $.Localize("#gg_count") + "0/" + dire_player_count
		}
	}
}

function VoteGG(ID, panel, team, Vote) {
	if (panel.BHasClass("voted")) {
		return;
	}

	if (team == 2) {
		radiant_vote_count = radiant_vote_count + 1
		$("#gg_count").text = $.Localize("#gg_count") + radiant_vote_count + "/" + radiant_player_count
	} else if (team == 3) {
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

function TogglePanel() {
	if ($.GetContextPanel().BHasClass("translate")) {
		$.GetContextPanel().RemoveClass("translate")
	} else {
		$.GetContextPanel().AddClass("translate")
	}
}

(function() {
	LoadPlayers()
	TogglePanel()
})();
