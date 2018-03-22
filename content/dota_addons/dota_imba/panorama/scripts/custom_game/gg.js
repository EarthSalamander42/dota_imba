"use strict";

function LoadPlayers() {
	var PlayerPanel = $("#Players")
	var radiantPlayers = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS);
	$.Each(radiantPlayers, function(player) {
		var info = Game.GetPlayerInfo(player)
		var player_row = $.CreatePanel("Panel", PlayerPanel, "Player" + "_" + player);
		player_row.AddClass("PlayerRow")

		var steam_id = $.CreatePanel("DOTAAvatarImage", player_row, "player_steamid_" + player);
		steam_id.steamid = info.player_steamid
		steam_id.style.width = "50px";
		steam_id.style.height = "50px";
		steam_id.style.borderLeft = "1px solid grey";
		steam_id.style.borderTop = "1px solid grey";
		steam_id.style.borderRight = "1px solid grey";
		steam_id.style.borderBottom = "1px solid grey";
	});

	var direPlayers = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_BADGUYS);
	$.Each(direPlayers, function(player) {
		if (player != Players.GetLocalPlayer()) {
			return
		}
	});
}

(function() {
	LoadPlayers()
//	GameEvents.Subscribe("imbathrow_topbar", ShowImbathrowBar);
})();
