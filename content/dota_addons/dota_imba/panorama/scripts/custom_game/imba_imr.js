"use strict";

var playerPanels = {};

var toggle = false
var first_time = false
function FrostivusAltar() {
	if (toggle == false) {
		$("#HallOfFame").style.visibility = "visible";
		toggle = true
		if (first_time == false) {
			$.Msg("First time!")
			first_time = true
			DiretidePlayersXP()
			HallOfFame()
			$("#ButtonContent").style.visibility = "collapse";
		}
	}
	else {
		$("#HallOfFame").style.visibility = "collapse";
		toggle = false
	}
}

function DiretidePlayersXP()
{
	//Get the players for both teams
	var radiantPlayers = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_GOODGUYS );
	var direPlayers = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_BADGUYS );

//	if (CustomNetTables.GetTableValue("player_table", 0).DT_GT == undefined) {
//		$.Msg("Couldn't gather info from Diretide XP, trying again in 5 seconds...")
//		$.Schedule(5, HallOfFame)
//		return;
//	}

	$.Each( radiantPlayers, function( player ) {
		var playerPanel = Modular.Spawn( "picking_player", $("#RadiantPlayers"), "HoF" );
		var playerInfo = Game.GetPlayerInfo( player )

		playerPanels[player] = playerPanel;

		playerPanels[player].SetHeroDT(playerInfo.player_selected_hero);
		playerPanel.SetPlayerAvatarDT( player );
		playerPanel.SetPlayerNameDT( player );

//		var DT_Lvl = CustomNetTables.GetTableValue("player_table", player).DT_Lvl;
//		var DT_HP = CustomNetTables.GetTableValue("player_table", player).DT_HP;
//		playerPanel.SetPlayerDTInfo( player, DT_Lvl, DT_HP );
	});

	$.Each( direPlayers, function( player ) {
		var playerPanel = Modular.Spawn( "picking_player", $("#DirePlayers"), "HoF" );
		var playerInfo = Game.GetPlayerInfo( player )

		playerPanels[player] = playerPanel;

		playerPanels[player].SetHeroDT(playerInfo.player_selected_hero);
		playerPanel.SetPlayerAvatarDT( player );
		playerPanel.SetPlayerNameDT( player );

//		var DT_Lvl = CustomNetTables.GetTableValue("player_table", player).DT_Lvl;
//		var DT_HP = CustomNetTables.GetTableValue("player_table", player).DT_HP;
//		playerPanel.SetPlayerDTInfo( player, DT_Lvl, DT_HP );
	});
}

function HallOfFame()
{
	var LeaderboardTable = CustomNetTables.GetTableValue("game_options", "leaderboard");

	if (LeaderboardTable == undefined) {
		$.Msg("Couldn't find any leaderboard values, trying again in 5 seconds...")
		$.Schedule(5, HallOfFame)
		return;
	} else {
		var SteamID64 = LeaderboardTable.SteamID64;
		var Experience = LeaderboardTable.XP;
		var ImbaMatchmakingRank = LeaderboardTable.IMR;

		for (var i = 1; i <= 10; i++) {
//			$("#Rank"+i).text = i; // bug, table inverted now i'm re-ordering it in lua..

			var player = $.CreatePanel("Panel", $('#Tops'), "player_" + i);
			player.AddClass("LeaderboardGames")
			var rank = $.CreatePanel("Label", player, "rank_" + i);
			rank.AddClass("LeaderboardRank")
			rank.text = i

			var steam_id = $.CreatePanel("Label", player, "player_steamid_" + i);
			steam_id.AddClass("LeaderboardAvatar_alt")
			steam_id.text = SteamID64[i]

//			var steam_id = $.CreatePanel("DOTAAvatarImage", player, "player_steamid_" + i);
//			steam_id.AddClass("LeaderboardAvatar_alt")
//			steam_id.steamid = SteamID64[i]
//			$.Msg(steam_id)

			var ply_name = $.CreatePanel("Label", player, "player_steamid_" + i);
			ply_name.AddClass("LeaderboardAvatar_alt")

			var imbar_container = $.CreatePanel("Panel", player, "imbar_container_" + i);
			imbar_container.AddClass("LeaderboardXP")
			var imbar = $.CreatePanel("ProgressBar", imbar_container, "imbar_" + i);
			imbar.AddClass("imbar-progress-bar")

			$.Msg(Experience[i])

			var plyData = CustomNetTables.GetTableValue("player_table", i - 1);
			if (plyData != undefined) {
				imbar.value = plyData.XP / plyData.MaxXP
				var imbar_lvl = $.CreatePanel("Label", imbar_container, "imbar_lvl" + i);
				imbar_lvl.AddClass("imbar-lvl")
				imbar_lvl.text = "Level: " + plyData.Lvl
				var imbar_rank = $.CreatePanel("Label", imbar_container, "imbar_rank" + i);
				imbar_rank.AddClass("imbar-rank")
				imbar_rank.text = plyData.title
				imbar_rank.style.color = plyData.title_color;
				var imbar_xp = $.CreatePanel("Label", imbar_container, "imbar_xp" + i);
				imbar_xp.AddClass("imbar-xp")
				imbar_xp.text = plyData.XP + "/" + plyData.MaxXP
			}

			/*
			_ScoreboardUpdater_SetValueSafe( playerPanel, "XPProgressBar"+playerId, plyData.XP / plyData.MaxXP );
			_ScoreboardUpdater_SetTextSafe( playerPanel, "ImbaLvl"+playerId, "Lvl: " + plyData.Lvl );
			_ScoreboardUpdater_SetTextSafe( playerPanel, "ImbaXPRank"+playerId, plyData.title );
			_ScoreboardUpdater_SetTextSafe( playerPanel, "ImbaXP"+playerId, plyData.XP + "/" + plyData.MaxXP );
			*/
			var imr = $.CreatePanel("Label", player, "rank_" + i);
			imr.AddClass("LeaderboardIMR")
			imr.text = ImbaMatchmakingRank[i]
		}
	}
}

(function()
{
	GameEvents.Subscribe("hall_of_fame", HallOfFame);
})();

