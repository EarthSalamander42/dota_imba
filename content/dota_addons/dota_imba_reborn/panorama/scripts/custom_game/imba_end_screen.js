"use strict";

(function () {

// GameEvents.Subscribe("hall_of_fame", HallOfFame);

function EndScoreboard() {
	GameEvents.Subscribe("end_game", function (args) {
//		$.Msg(args)

		HideIMR($.GetContextPanel())

		// Hide all other UI
		var MainPanel = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent()
		MainPanel.FindChildTraverse("topbar").style.visibility = "collapse";
		MainPanel.FindChildTraverse("minimap_container").style.visibility = "collapse";
		MainPanel.FindChildTraverse("lower_hud").style.visibility = "collapse";
		// MainPanel.FindChildTraverse("HudChat").style.visibility = "collapse";
		MainPanel.FindChildTraverse("NetGraph").style.visibility = "collapse";
		MainPanel.FindChildTraverse("quickstats").style.visibility = "collapse";

		// Gather info 
		var playerResults = args.players;
		var serverInfo = args.info;
		var mapInfo = Game.GetMapInfo();

		// player ids
		var radiantPlayerIds = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS);
		var direPlayerIds = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_BADGUYS);

		// Victory Info text
		var victoryMessage = "winning_team_name Victory!";
		var victoryMessageLabel = $("#es-victory-info-text");

		if (serverInfo.winner == 2) {
			victoryMessage = victoryMessage.replace("winning_team_name", $.Localize("#DOTA_GoodGuys"));
		} else if (serverInfo.winner == 3) {
			victoryMessage = victoryMessage.replace("winning_team_name", $.Localize("#DOTA_BadGuys"));
		}

		victoryMessageLabel.text = victoryMessage;

		// Load frequently used panels
		var teamsContainer = $("#es-teams");

		var panels = {
			radiant: $("#es-radiant"),
			dire: $("#es-dire"),
			radiantPlayers: $("#es-radiant-players"),
			direPlayers: $("#es-dire-players"),
		};

		// the panorama xml file used for the player lines
		var playerXmlFile = "file://{resources}/layout/custom_game/imba_end_screen_player.xml";

		// sort a player by merging results from server and using getplayerinfo  
		var loadPlayer = function (id) {
			var info = Game.GetPlayerInfo(id);

			var result = null;
			for (var k in args.data.players) {
                if (k == info.player_steamid)
//                	$.Msg(args.data.players[k])
                    return {
                        id: id,
                        info: info,
                        result: args.data.players[k]
                    };
			}

//			$.Msg("WTF");
//			$.Msg(playerResults);

			return null;
		};

		// Load players = sort our data we got from above
		var radiantPlayers = [];
		var direPlayers = [];

		$.Each(radiantPlayerIds, function (id) { radiantPlayers.push(loadPlayer(id)); });
		$.Each(direPlayerIds, function (id) { direPlayers.push(loadPlayer(id)); });

		var createPanelForPlayer = function (player, parent) {
			// Create a new Panel for this player
//			$.Msg(player)
			var pp = $.CreatePanel("Panel", parent, "es-player-" + player.id);
			pp.AddClass("es-player");
			pp.BLoadLayout(playerXmlFile, false, false);
			var xp_bar = pp.FindChildrenWithClassTraverse("es-player-xp")

			var values = {
				name: pp.FindChildInLayoutFile("es-player-name"),
				avatar: pp.FindChildInLayoutFile("es-player-avatar"),
				hero: pp.FindChildInLayoutFile("es-player-hero"),
				desc: pp.FindChildInLayoutFile("es-player-desc"),
				kills: pp.FindChildInLayoutFile("es-player-k"),
				deaths: pp.FindChildInLayoutFile("es-player-d"),
				assists: pp.FindChildInLayoutFile("es-player-a"),
				imr: pp.FindChildInLayoutFile("es-player-imr"),
				imr10v10: pp.FindChildInLayoutFile("es-player-imr10v10"),
				rank1v1: pp.FindChildInLayoutFile("es-player-imr1v1"),
				gold: pp.FindChildInLayoutFile("es-player-gold"),
				level: pp.FindChildInLayoutFile("es-player-level"),
				xp: {
					bar: xp_bar,
					progress: pp.FindChildInLayoutFile("es-player-xp-progress"),
					level: pp.FindChildInLayoutFile("es-player-xp-level"),
					rank: pp.FindChildInLayoutFile("es-player-xp-rank"),
					rank_name: pp.FindChildInLayoutFile("es-player-xp-rank-name"),
					earned: pp.FindChildInLayoutFile("es-player-xp-earned"),
					booster: pp.FindChildInLayoutFile("es-player-xp-booster")
				}
			};

			// Avatar + Hero Image
			values.avatar.steamid = player.info.player_steamid;
			values.hero.heroname = player.info.player_selected_hero;

			// Steam Name + Hero name
			values.name.text = player.info.player_name;
			values.desc.text = $.Localize(player.info.player_selected_hero);

			// Stats
			values.kills.text = player.info.player_kills;
			values.deaths.text = player.info.player_deaths;
			values.assists.text = player.info.player_assists;
			values.gold.text = player.info.player_gold;
			values.level.text = player.info.player_level;

			// XP
			var player_table = CustomNetTables.GetTableValue("player_table", player.id.toString());
			if (player_table) {
				values.xp.rank.text = Math.floor(player_table.XP) + "/" + Math.floor(player_table.MaxXP);
				values.xp.level.text = $.Localize("#battlepass_level") + player_table.Lvl;
				values.xp.rank_name.text = player_table.title;
				values.xp.rank_name.style.color = player_table.title_color;
				values.xp.booster.style.color = player_table.donator_color;
//				$.Msg(Math.floor(player_table.XP) / Math.floor(player_table.MaxXP))
//				if (Math.floor(player_table.XP) / Math.floor(player_table.MaxXP) >= 1) {
//					$.Msg("Level Up!")
//					values.xp.bar[0].AddClass("level-up");
//				}
				var progress = Math.round((100.0 * Math.floor(player_table.XP)) / Math.floor(player_table.MaxXP));
				values.xp.progress.style.width = progress + "%";
			}

			// IMR
			if (player.result != null) {
				if (mapInfo.map_display_name == "ranked_5v5") {
					values.imr.style.visibility = "visible";

					if (player.result.imr5v5_calibrating)
						values.imr.text = "TBD";
					else {
						var imr = Math.floor(player.result.imr5v5);
						var diff = Math.floor(player.result.imr5v5_difference);

						if (diff == 0) {
							values.imr.text = imr;
							values.imr.AddClass("es-text-white");
						} else if (diff > 0) {
							values.imr.text = imr + " (+" + diff + ")";
							values.imr.AddClass("es-text-green");
						} else {
							values.imr.text = imr + " (" + diff + ")";
							values.imr.AddClass("es-text-red");
						}
					}
				} else if (mapInfo.map_display_name == "imba_ranked_10v10") {
					values.imr10v10.style.visibility = "visible";
					
					if (player.result.imr10v10_calibrating)
						values.imr10v10.text = "TBD";
					else {
						var imr = Math.floor(player.result.imr10v10);
						var diff = Math.floor(player.result.imr10v10_difference);

						if (diff == 0) {
							values.imr10v10.text = imr;
							values.imr10v10.AddClass("es-text-white");
						} else if (diff > 0) {
							values.imr10v10.text = imr + " (+" + diff + ")";
							values.imr10v10.AddClass("es-text-green");
						} else {
							values.imr10v10.text = imr + " (" + diff + ")";
							values.imr10v10.AddClass("es-text-red");
						}
					}
				} else if (mapInfo.map_display_name == "imba_1v1") {
					// display columns
					values.rank1v1.style.visibility = "visible";
					
					var rank1v1 = player.result.level1v1;
					var diff = player.result.level1v1_difference;

					if (diff == 0) {
						values.rank1v1.text = rank1v1;
						values.rank1v1.AddClass("es-text-white");
					} else if (diff > 0) {
						values.rank1v1.text = rank1v1 + " (+)";
						values.rank1v1.AddClass("es-text-green");
					} else {
						values.rank1v1.text = rank1v1 + " (-)";
						values.rank1v1.AddClass("es-text-red");
					}
				}
			} else {
				values.imr10v10.text = "N/A";
				values.imr.text = "N/A";
				values.rank1v1.text = "N/A";
			}

//			$.Msg(player)
			if (player.result != null) {
				var xpDiff = Math.floor(player.result.xp_change);

				if (xpDiff > 0) {
					values.xp.earned.text = "+" + xpDiff;
					values.xp.earned.AddClass("es-text-green");
				} else if (xpDiff == 0) {
					values.xp.earned.text = "0";
					values.xp.earned.AddClass("es-text-white");
				} else {
					values.xp.earned.text = new String(xpDiff);
					values.xp.earned.AddClass("es-text-red");
				}

				var multiplier = Math.round(player.result.xp_multiplier * 100.0);

				values.xp.booster.text = " (" + multiplier + "%)";
				values.xp.booster.style.color = "white";
			} else {
				values.xp.earned.text = "N/A";
			}
		};

		// Create the panels for the players
		$.Each(radiantPlayers, function (player) {
			createPanelForPlayer(player, panels.radiantPlayers);
		});

		$.Each(direPlayers, function (player) {
			createPanelForPlayer(player, panels.direPlayers);
		});

		// Set Team Score
		$("#es-team-score-radiant").text = new String(serverInfo.radiant_score);
		$("#es-team-score-dire").text = new String(serverInfo.dire_score);
		$("#es-game-time-text").text = RawTimetoGameTime(Game.GetDOTATime(false, false));

//		HallOfFame()
//		$.Schedule(2.0, HallOfFame);
//		$.Schedule(5.0, HallOfFame);
	});
}

function RawTimetoGameTime(time) {
	var sec = Math.floor( time % 60 );
	var min = Math.floor( time / 60 );

	var timerText = "";
	timerText += min;
	timerText += ":";

	if ( sec < 10 )
	{
		timerText += "0";
	}
	timerText += sec;
	return timerText;
}
/*
function CloseHallOfFame() {
	$("#HallOfFame").style.visibility = "collapse";
}

function HallOfFame() {
	var i = 1;
	var j = 0;

	api.diretide_highscores().then(function (data) {
		// data is array of {
		//		level: 123,
		//		players: [ steamid, steamid, steamid ]
		// }

		data.forEach(function (result) {
			if ($("#game_" + i)) {
				$("#game_" + i).DeleteAsync(0);
			}

			$.Msg("players: " + result.users.join(", ") + " made it to level " + result.level);

			var game = $.CreatePanel("Panel", $('#Tops'), "game_" + i);
			game.AddClass("LeaderboardGames");

			var rank = $.CreatePanel("Label", game, "rank_" + i);
			rank.AddClass("LeaderboardRank");
			rank.text = i;

			var steamid_container = $.CreatePanel("Panel", game, "steamid_container_" + i);
			steamid_container.AddClass("LeaderboardXP");
			steamid_container.text = i;

			while (result.users[j] != undefined) {
				$.Msg(result.users[j])

				var steam_id = $.CreatePanel("DOTAAvatarImage", steamid_container, "");
				steam_id.AddClass("LeaderboardAvatar");
				steam_id.steamid = result.users[j];
				steam_id.style.width = "38px";
				steam_id.style.height = "38px";
				steam_id.style.marginRight = "7px";

				j++;
			}

			var level = $.CreatePanel("Label", game, "level_" + i);
			level.AddClass("LeaderboardIMR");
			level.text = result.level;

			i++;
			j = 0;
		});
	});
}
*/
EndScoreboard()
})();
