"use strict";

(function () {
	GameEvents.Subscribe("end_game", EndScoreboard);
/*
	// Placeholder
	var args = {
		"data":{
			"players":{
				"76561198015161808":{
					"xp_multiplier": 10,
					"xp": "0",
					"xp_change": 200
				},
				"90071996842377216":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 1
				},
				"90071996842377217":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 2
				},
				"90071996842377218":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 3
				},
				"90071996842377219":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 4
				},
				"90071996842377220":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 5
				},
				"90071996842377221":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 6
				},
				"90071996842377222":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 7
				},
				"90071996842377223":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 8
				},
				"90071996842377224":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 9
				},
			}
		},
	};

	EndScoreboard(args);
*/
})();

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

function EndScoreboard(args) {
//	$.Msg(args)

	// Hide all other UI
	var MainPanel = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent()
	MainPanel.FindChildTraverse("topbar").style.visibility = "collapse";
	MainPanel.FindChildTraverse("minimap_container").style.visibility = "collapse";
	MainPanel.FindChildTraverse("lower_hud").style.visibility = "collapse";
//	MainPanel.FindChildTraverse("HudChat").style.visibility = "collapse";
	MainPanel.FindChildTraverse("NetGraph").style.visibility = "collapse";
	MainPanel.FindChildTraverse("quickstats").style.visibility = "collapse";

	// Victory Info text
	var victoryMessage = "winning_team_name Victory!";
	var victoryMessageLabel = $("#es-victory-info-text");

	victoryMessage = victoryMessage.replace("winning_team_name", $.Localize(Game.GetTeamDetails(Game.GetGameWinner()).team_name));

	victoryMessageLabel.text = victoryMessage;

	// sort a player by merging results from server and using getplayerinfo
	var loadPlayer = function (id) {
		var info = Game.GetPlayerInfo(id);
		var result = null;

		for (var k in args.data.players) {
//			$.Msg(k + " / " + info.player_steamid)
			if (k == info.player_steamid) {
//				$.Msg(args.data.players[k])
				return {
					id: id,
					info: info,
					result: args.data.players[k]
				};
			}
		}

		return null;
	};

	var teamPlayers = [];

	for (var i = 2; i <= 13; i++) {
		if (Game.GetTeamDetails(i).team_num_players > 0) {
			teamPlayers[i] = [];
			$.Each(Game.GetPlayerIDsOnTeam(i), function(id) { teamPlayers[i].push(loadPlayer(id)); });

			// Set Team Score
			$("#es-team-score-" + i).text = new String(Game.GetTeamDetails(i).team_score);
		}
	}

	// the panorama xml file used for the player lines
	var playerXmlFile = "file://{resources}/layout/custom_game/frostrose_end_screen_player.xml";

	var createPanelForPlayer = function (player, parent) {
		if (player == null)
			return;

		// Create a new Panel for this player
//		$.Msg(player)
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
			gold: pp.FindChildInLayoutFile("es-player-gold"),
			level: pp.FindChildInLayoutFile("es-player-level"),
			xp: {
				bar: xp_bar,
				progress: pp.FindChildInLayoutFile("es-player-xp-progress"),
				progress_diff: pp.FindChildInLayoutFile("es-player-xp-progress-diff"),
				level: pp.FindChildInLayoutFile("es-player-xp-level"),
				rank: pp.FindChildInLayoutFile("es-player-xp-rank"),
				rank_name: pp.FindChildInLayoutFile("es-player-xp-rank-name"),
				earned: pp.FindChildInLayoutFile("es-player-xp-earned"),
				booster: pp.FindChildInLayoutFile("es-player-xp-booster")
			}
		};

//		$.Msg(player.info.player_steamid);

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
		var ply_table = CustomNetTables.GetTableValue("battlepass", player.id.toString());

		var player_xp = ply_table.XP;

		$.Msg(ply_table.player_xp)
		if (ply_table && ply_table.player_xp == 1) {
			values.xp.rank.text = Math.floor(player_xp) + "/" + Math.floor(ply_table.MaxXP);
			values.xp.level.text = $.Localize("#battlepass_level") + ply_table.Lvl;
			values.xp.rank_name.text = ply_table.title;
			values.xp.rank_name.style.color = ply_table.title_color;
			values.xp.booster.style.color = ply_table.donator_color;

//			$.Msg(Math.floor(player_xp) + " / " + Math.floor(ply_table.MaxXP))
//			$.Msg(Math.floor(player_xp) / Math.floor(ply_table.MaxXP))

			var progress = Math.round((100.0 * Math.floor(player_xp)) / Math.floor(ply_table.MaxXP));
			values.xp.progress.style.width = progress + "%";
		} else {			
			values.xp.rank.text = "N/A";
			values.xp.level.text = "N/A";
			values.xp.rank_name.text = "N/A";
			values.xp.rank_name.style.color = "#FFFFFF";
			values.xp.booster.style.color = "white";
			values.xp.progress.style.width = "0%";			
		}

		if (player.result != null) {
			var xpDiff = Math.floor(player.result.xp_change);

			if (xpDiff > 0) {
				values.xp.earned.text = "+" + xpDiff;
				values.xp.earned.AddClass("es-text-green");

				if (ply_table) {
					var progress_diff = Math.round(100.0 * (xpDiff / ply_table.MaxXP));
					values.xp.progress_diff.style.width = progress_diff + "%";
					values.xp.progress_diff.style.marginLeft = (progress - 1) + "%";

					if (Math.floor(player_xp + xpDiff) / Math.floor(ply_table.MaxXP) >= 1) {
						values.xp.bar[0].AddClass("level-up");
					}
				}
			} else if (xpDiff == 0) {
				values.xp.earned.text = "0";
				values.xp.earned.AddClass("es-text-white");
			} else {
				values.xp.earned.text = new String(xpDiff);
				values.xp.earned.AddClass("es-text-red");
			}

			var multiplier = Math.round(player.result.xp_multiplier * 100.0);
			values.xp.booster.text = " (" + multiplier + "%)";
		} else {
			values.xp.earned.text = "N/A";
		}
	};

	for (var i = 2; i <= 13; i++) {
		if (Game.GetTeamDetails(i).team_num_players > 0) {
			$.Each(teamPlayers[i], function (player) {
				createPanelForPlayer(player, $("#es-" + i + "-players"));
			});

			$("#es-" + i + "-team").style.visibility = "visible";
		}
	}

	$("#es-game-time-text").text = RawTimetoGameTime(Game.GetDOTATime(false, false));
}
