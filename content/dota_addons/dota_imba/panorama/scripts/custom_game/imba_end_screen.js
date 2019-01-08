"use strict";

(function () {

var placeholder = false

if (placeholder == true) {
	// PLACEHOLDERS: testing purpose only
	var args = {
		players: {
			0: {
				steamid: 76561198015161808,
				imr5v5_calibrating: false,
				imr5v5: 4500,
				imr5v5_difference: 12,
				xp: 5000,
				xp_difference: 100,
				xp_booster: 10.0, // already includes donator allies 20% share
				donator_status: 10.0,
				// GetPlayer lua thing
			}
		},

		xp_info: {
			0: {
				level: 12,
				title: 'Legend',
				earned: 17,
				steamid: 76561198015161808,
			},

			1: {
				level: 12,
				title: 'Legend',
				earned: 17,
				steamid: 76561198015161808,
			},
		},

		info: {
			radiant_score: 100,
			dire_score: 99,
			winner: 2,

			ids1: [0],
			ids2: [1]
		}
	};
}

function EndScoreboard() {
	GameEvents.Subscribe("end_game", function (args) {

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
			for (var k in playerResults) {
				if (playerResults[k].steamid == info.player_steamid)
					return {
						id: id,
						info: info,
						result: playerResults[k]
					};
			}
	
			$.Msg("WTF");
			$.Msg(playerResults);

			return null;
		};

		// Load players = sort our data we got from above
		var radiantPlayers = [];
		var direPlayers = [];

		$.Each(radiantPlayerIds, function (id) { radiantPlayers.push(loadPlayer(id)); });
		$.Each(direPlayerIds, function (id) { direPlayers.push(loadPlayer(id)); });

		var createPanelForPlayer = function (player, parent) {
			// Create a new Panel for this player
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

			// IMR
			if (player.result != null) {
				if (mapInfo.map_display_name == "imba_ranked_5v5") {
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

			var diff = player.result.xp_difference;

			if (player.result != null) {
				var xp = Math.floor(player.result.xp);
				var xpDiff = Math.floor(diff);

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

				var player_table = CustomNetTables.GetTableValue("player_table", player.id.toString());
				if (player_table) {
					if (player_table.donator_level >= 0 && player_table.donator_level <= 10) {
						values.xp.booster.style.color = player_table.donator_color;
					}
				}

				values.xp.level.text = $.Localize("#battlepass_level") + player.result.xp_level;
				values.xp.rank_name.text = player.result.xp_rank_title;
				values.xp.rank_name.style.color = "#" + player.result.xp_rank_color;

				values.xp.rank.text = Math.floor(player.result.xp_in_current_level) + "/" + Math.floor(player.result.total_xp_for_current_level);

//				$.Msg(player.result.xp_in_current_level / player.result.total_xp_for_current_level)
//				if (player.result.xp_in_current_level / player.result.total_xp_for_current_level >= 1) {
//					values.xp.bar[0].AddClass("level-up");
//				}
				var progress = Math.round((100.0 * player.result.xp_in_current_level) / player.result.total_xp_for_current_level);

				values.xp.progress.style.width = progress + "%";

				// TODO: WILL REWORK THIS SOON
				/*
				// if not leveling up
				else if (progress_bar >= 0 && progress_bar < 100) {
						values.xp.progress.style.width = progress_bar + "%";
					values.xp.rank.text = new_xp + "/" + max_xp;
				// else if leveling down
				} else if (progress_bar < 0) {
					values.xp.rank.text = max_xp + "/" + max_xp;
					values.xp.progress.style.width = "100%";

					if (values.xp.bar[0].BHasClass("level-down")) {
						values.xp.bar[0].RemoveClass("level-down")
					}
					values.xp.bar[0].AddClass("level-down")
					values.xp.level.text = "Level down..";
					values.xp.rank.text = "";
					progress_bar = progress_bar + 100;
					values.xp.progress.style.width = progress_bar + "%";
					$.Schedule(2.0, function() {
						var levelup_level = player.xp.level - 1
						var levelup_xp = progress_bar * max_xp / 100 // BUG: max_xp should be the max xp of previous level.
						values.xp.level.text = $.Localize("#battlepass_level") + levelup_level;
//						$.Msg(progress_bar * max_xp / 100)
//						$.Msg(levelup_xp.toFixed(0))
						values.xp.rank.text = levelup_xp.toFixed(0) + "/" + max_xp; // BUG: max_xp should be the max xp of previous level.
					});
				// else if leveling up
				} else {
					values.xp.rank.text = max_xp + "/" + max_xp;
					values.xp.progress.style.width = "100%";

					if (values.xp.bar[0].BHasClass("level-up")) {
						values.xp.bar[0].RemoveClass("level-up")
					}
					values.xp.bar[0].AddClass("level-up")
					values.xp.level.text = "Level up!";
					values.xp.rank.text = "";
					progress_bar = progress_bar -100;
					values.xp.progress.style.width = progress_bar + "%";
					$.Schedule(2.0, function() {
						var levelup_level = player.xp.level + 1
						var levelup_xp = old_xp + diff - max_xp // BUG: max_xp should be the max xp of previous level.
						values.xp.level.text = $.Localize("#battlepass_level") + levelup_level;
						values.xp.rank.text = levelup_xp.toFixed(0) + "/" + max_xp; // BUG: max_xp should be the max xp of previous level.
					});
				}
				*/
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
function UpdateTimer( data )
{
	//$.Msg( "UpdateTimer: ", data );
	//var timerValue = Game.GetDOTATime( false, false );

	//var sec = Math.floor( timerValue % 60 );
	//var min = Math.floor( timerValue / 60 );

	//var timerText = "";
	//timerText += min;
	//timerText += ":";

	//if ( sec < 10 )
	//{
	//	timerText += "0";
	//}
	//timerText += sec;

	var timerText = "";
	timerText += data.timer_minute_10;
	timerText += data.timer_minute_01;
	timerText += ":";
	timerText += data.timer_second_10;
	timerText += data.timer_second_01;

	$( "#Timer" ).text = timerText;

	//$.Schedule( 0.1, UpdateTimer );
}
*/
EndScoreboard()
})();
