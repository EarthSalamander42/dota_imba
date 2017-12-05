"use strict";

var playerPanels = {};

var toggle = false
var first_time = false
function FrostivusAltar() {
	if (toggle == false) {
		$("#HallOfFame").style.visibility = "visible";
		toggle = true
		if (first_time == false) {
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

var dot = "."
function HallOfFame()
{
	var LeaderboardTable = CustomNetTables.GetTableValue("game_options", "leaderboard");
	$("#LoadingWarning").text = $.Localize("#leaderboard_loading") + dot;
	if (dot == ".") {
		dot = ".."
	} else if (dot == "..") {
		dot = "..."
	} else if (dot == "...") {
		dot = "."
	}

	if (LeaderboardTable === undefined) {
		$.Schedule(1, HallOfFame)
		return;
	} else if (LeaderboardTable.SteamID64[10] === undefined) {
		$.Schedule(1, HallOfFame)
		return;
	} else {
		var SteamID64 = LeaderboardTable.SteamID64;
		var Experience = LeaderboardTable.XP;
		var MaxExperience = LeaderboardTable.MaxXP;
		var Level = LeaderboardTable.Lvl;
		var Title = LeaderboardTable.Title;
		var Title_Color = LeaderboardTable.TitleColor;
		var ImbaMatchmakingRank = LeaderboardTable.IMR;
		$("#LoadingWarning").style.visibility = "collapse";

		if (ImbaMatchmakingRank == undefined) {
			ImbaMatchmakingRank = []
			for (var i = 1; i <= 10; i++) {
				ImbaMatchmakingRank[i] = 3000;
			}
		}

		for (var i = 1; i <= 10; i++) {
			var player = $.CreatePanel("Panel", $('#Tops'), "player_" + i);
			player.AddClass("LeaderboardGames")
			var rank = $.CreatePanel("Label", player, "rank_" + i);
			rank.AddClass("LeaderboardRank")
			rank.text = i

//			var steam_id = $.CreatePanel("Label", player, "player_steamid_" + i);
//			steam_id.AddClass("LeaderboardAvatar_alt")
//			steam_id.text = SteamID64[i]

			var steam_id = $.CreatePanel("DOTAAvatarImage", player, "player_steamid_" + i);
			steam_id.AddClass("LeaderboardAvatar")
			steam_id.steamid = SteamID64[i]
			steam_id.style.width = "15%";
			steam_id.style.height = "100%";
			steam_id.style.borderLeft = "1px solid white";
			steam_id.style.borderTop = "1px solid white";
			steam_id.style.borderRight = "1px solid white";

//			var ply_name = $.CreatePanel("Label", player, "player_steamid_" + i);
//			ply_name.AddClass("LeaderboardAvatar_alt")

			var imbar_container = $.CreatePanel("Panel", player, "imbar_container_" + i);
			imbar_container.AddClass("LeaderboardXP")
			var imbar = $.CreatePanel("ProgressBar", imbar_container, "imbar_" + i);
			imbar.AddClass("imbar-progress-bar")
			imbar.value = Experience[i] / MaxExperience[i]

			var imbar_lvl = $.CreatePanel("Label", imbar_container, "imbar_lvl" + i);
			imbar_lvl.AddClass("imbar-lvl")
			imbar_lvl.text = "Level: " + Level[i]

			var imbar_rank = $.CreatePanel("Label", imbar_container, "imbar_rank" + i);
			imbar_rank.AddClass("imbar-rank")
			imbar_rank.text = Title[i]
			imbar_rank.style.color = Title_Color[i]

			var imbar_xp = $.CreatePanel("Label", imbar_container, "imbar_xp" + i);
			imbar_xp.AddClass("imbar-xp")
			imbar_xp.text = Experience[i] + "/" + MaxExperience[i]

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

