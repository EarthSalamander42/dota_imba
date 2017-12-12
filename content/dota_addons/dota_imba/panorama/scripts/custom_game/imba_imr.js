"use strict";

var playerPanels = {};

var toggle = false
var first_time = false
function ToggleBattlepass() {
	if (toggle == false) {
		$("#BattlepassWindow").style.visibility = "visible";
		toggle = true
		if (first_time == false) {
			first_time = true
//			DiretidePlayersXP()
			HallOfFame()
		}
	}
	else {
		$("#BattlepassWindow").style.visibility = "collapse";
		toggle = false
	}
}

function SwitchTab(tab) {
	$("#BattlepassInfoContainer").style.visibility = "collapse";
	$("#LeaderboardInfoContainer").style.visibility = "collapse";

	$("#"+tab).style.visibility = "visible";
}

var dot = "."
function HallOfFame()
{
	var LeaderboardTable = CustomNetTables.GetTableValue("game_options", "leaderboard");

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

			var steam_id = $.CreatePanel("DOTAAvatarImage", player, "player_steamid_" + i);
			steam_id.AddClass("LeaderboardAvatar")
			steam_id.steamid = SteamID64[i]
			steam_id.style.width = "15%";
			steam_id.style.height = "100%";
			steam_id.style.borderLeft = "1px solid white";
			steam_id.style.borderTop = "1px solid white";
			steam_id.style.borderRight = "1px solid white";

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

	var i = 1;
	var i_count = 1;
	var class_option_count = 1;
	var i_single = false

	$.Each( radiantPlayers, function( player ) {
		if (i_single == false) {
			i_single = true
			var ClassOptionPanel = $.CreatePanel("Panel", $('#RadiantPlayers'), "RadiantPlayers" + "_" + class_option_count);
			ClassOptionPanel.AddClass("LeaderboardInGamePlayers");
		}

		var playerPanel = Modular.Spawn( "picking_player", $("#RadiantPlayers" + "_" + class_option_count), "HoF" );
		var playerInfo = Game.GetPlayerInfo( player )

		playerPanels[player] = playerPanel;

		playerPanels[player].SetHeroDT(playerInfo.player_selected_hero);
		playerPanel.SetPlayerAvatarDT( player );
		playerPanel.SetPlayerNameDT( player );

		i_count = i_count +1;

		if (i_count > 2) {
			class_option_count = class_option_count +1
			var ClassOptionPanel_alt = $.CreatePanel("Panel", $("#RadiantPlayers"), "RadiantPlayers" + "_" + class_option_count);
			ClassOptionPanel_alt.AddClass("LeaderboardInGamePlayers");
			i_count = 1;
		}
	});

//	$.Each( direPlayers, function( player ) {
//		var playerPanel = Modular.Spawn( "picking_player", $("#DirePlayers"), "HoF" );
//		var playerInfo = Game.GetPlayerInfo( player )

//		playerPanels[player] = playerPanel;

//		playerPanels[player].SetHeroDT(playerInfo.player_selected_hero);
//		playerPanel.SetPlayerAvatarDT( player );
//		playerPanel.SetPlayerNameDT( player );

//		var DT_Lvl = CustomNetTables.GetTableValue("player_table", player).DT_Lvl;
//		var DT_HP = CustomNetTables.GetTableValue("player_table", player).DT_HP;
//		playerPanel.SetPlayerDTInfo( player, DT_Lvl, DT_HP );
//	});
}

(function()
{
	GameEvents.Subscribe("hall_of_fame", HallOfFame);
})();
