"use strict";

(function () {
	/*
	var ApiDebug = function(obj) {
		$.AsyncWebRequest("http://api.dota2imba.org/game/event", {
			type: "POST",
			dataType: "json",
			data: {
				agent: "panorama",
				version: 1,
				data: {
					id: null, 
					event: "panorama",
					content: JSON.stringify(obj),
					tag: null
				}
			},
			complete: function (data) {
				$.Msg("Request Complete");
				$.Msg(data);
			},
			error: function (err) {
				$.Msg("Request failed");
				$.Msg(err);
			}
		});
	};
	*/

	EndScoreboard()
})();

function EndScoreboard() {
	GameEvents.Subscribe("end_game", function (args) {

		var map_info = Game.GetMapInfo();
		if (map_info.map_display_name == "imba_overthrow") {
			$("#es-custom1").style.visibility = "visible";
			$("#es-custom2").style.visibility = "visible";
			$("#es-custom3").style.visibility = "visible";
		}

		// Hide all other UI
		var MainPanel = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent()
		MainPanel.FindChildTraverse("topbar").style.visibility = "collapse";
		MainPanel.FindChildTraverse("minimap_container").style.visibility = "collapse";
		MainPanel.FindChildTraverse("lower_hud").style.visibility = "collapse";
		MainPanel.FindChildTraverse("HudChat").style.visibility = "collapse";
		MainPanel.FindChildTraverse("NetGraph").style.visibility = "collapse";
		MainPanel.FindChildTraverse("quickstats").style.visibility = "collapse";

		// Gather info 
		var playerResults = args.players;
		var serverInfo = args.info;
		var xpInfo = args.xp_info;
		var mapInfo = Game.GetMapInfo();
		var radiantPlayerIds = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS);
		var direPlayerIds = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_BADGUYS);
		var custom1PlayerIds = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_CUSTOM_1);
		var custom2PlayerIds = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_CUSTOM_2 );
		var custom3PlayerIds = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_CUSTOM_3 );

		$.Msg({
			args: args,
			info: {
				map: mapInfo,
				ids1: radiantPlayerIds,
				ids2: direPlayerIds,
				ids3: custom1PlayerIds,
				ids4: custom2PlayerIds,
				ids5: custom3PlayerIds,
			}
		});

		// Victory Info text
		var victoryMessage = "winning_team_name Victory!";
		var victoryMessageLabel = $("#es-victory-info-text");

		if (serverInfo.winner == 2)
			victoryMessage = victoryMessage.replace("winning_team_name", $.Localize("#DOTA_GoodGuys"));
		else if (serverInfo.winner == 3)
			victoryMessage = victoryMessage.replace("winning_team_name", $.Localize("#DOTA_BadGuys"));
		else if (serverInfo.winner == 6)
			victoryMessage = victoryMessage.replace("winning_team_name", $.Localize("#DOTA_Custom1"));
		else if (serverInfo.winner == 7)
			victoryMessage = victoryMessage.replace("winning_team_name", $.Localize("#DOTA_Custom2"));

		victoryMessageLabel.text = victoryMessage;

		// Load frequently used panels
		var teamsContainer = $("#es-teams");

		var panels = {
			radiant: $("#es-radiant"),
			dire: $("#es-dire"),
			custom1: $("#es-custom1"),
			custom2: $("#es-custom2"),
			custom3: $("#es-custom3"),
			radiantPlayers: $("#es-radiant-players"),
			direPlayers: $("#es-dire-players"),
			custom1Players: $("#es-custom1-players"),
			custom2Players: $("#es-custom2-players"),
			custom3Players: $("#es-custom3-players"),
		};

		// the panorama xml file used for the player lines
		var playerXmlFile = "file://{resources}/layout/custom_game/multiteam_end_screen_player.xml";

		// sort a player by merging results from server and using getplayerinfo  
		var loadPlayer = function (id) {

			var playerInfo = Game.GetPlayerInfo(id);
			var resultInfo = null;
			var xp = null;

			for (var steamid in playerResults) {
				if (playerInfo.player_steamid == steamid)
					resultInfo = playerResults[steamid];
			}

			for (var steamid in xpInfo) {
				if (playerInfo.player_steamid == steamid)
					xp = xpInfo[steamid];
			}

			return {
				id: id,
				info: playerInfo,
				result: resultInfo,
				xp: xp
			};
		};

		// Load players = sort our data we got from above
		var radiantPlayers = [];
		var direPlayers = [];
		var custom1Players = [];
		var custom2Players = [];
		var custom3Players = [];

		$.Each(radiantPlayerIds, function (id) { radiantPlayers.push(loadPlayer(id)); });
		$.Each(direPlayerIds, function (id) { direPlayers.push(loadPlayer(id)); });
		$.Each(custom1PlayerIds, function (id) { custom1Players.push(loadPlayer(id)); });
		$.Each(custom2PlayerIds, function (id) { custom2Players.push(loadPlayer(id)); });
		$.Each(custom3PlayerIds, function (id) { custom3Players.push(loadPlayer(id)); });

		var createPanelForPlayer = function (player, parent) {

			// Create a new Panel for this player
			var pp = $.CreatePanel("Panel", parent, "es-player-" + player.id);
			pp.AddClass("es-player");
			pp.BLoadLayout(playerXmlFile, false, false);

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
					progress: pp.FindChildInLayoutFile("es-player-xp-progress"),
					level: pp.FindChildInLayoutFile("es-player-xp-level"),
					rank: pp.FindChildInLayoutFile("es-player-xp-rank"),
					earned: pp.FindChildInLayoutFile("es-player-xp-earned")
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
				if (player.result.imr_5v5_calibrating)
					values.imr.text = "TBD";
				else {
					var imr = Math.floor(player.result.imr_5v5);
					var diff = Math.floor(player.result.imr_5v5_diff);

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
			} else {
				values.imr.text = "N/A";
			}

			// XP
			if (player.result != null) {
				var xp = Math.floor(player.result.xp);
				var xpDiff = Math.floor(player.result.xp_diff);
				var oldXp = xp - xpDiff;

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

				values.xp.level.text = player.xp.level;
				values.xp.rank.text = player.xp.title;
				values.xp.rank.style.color = player.xp.color;

				var convertToPercentString = function (f) {
					var x = Math.floor(Math.abs(f) * 100);
					return x + "%";
				};

				values.xp.progress.style.width = convertToPercentString(player.xp.progress);
			} else {
				values.xp.earned.text = "N/A";
			}
		};

		var scores = {
			radiant: 0,
			dire: 0,
			custom1: 0,
			custom2: 0,
			custom3: 0,
		};

		// Create the panels for the players
		$.Each(radiantPlayers, function (player) {
			scores.radiant = scores.radiant + player.info.player_kills;
			createPanelForPlayer(player, panels.radiantPlayers);
		});

		$.Each(direPlayers, function (player) {
			scores.dire = scores.dire + player.info.player_kills;
			createPanelForPlayer(player, panels.direPlayers);
		});

		$.Each(custom1Players, function (player) {
			scores.custom1 = scores.custom1 + player.info.player_kills;
			createPanelForPlayer(player, panels.custom1Players);
		});

		$.Each(custom2Players, function (player) {
			scores.radiant = player.info.player_kills;
			createPanelForPlayer(player, panels.custom2Players);
		});

		$.Each(custom3Players, function (player) {
			scores.custom3 = scores.custom3 + player.info.player_kills;
			createPanelForPlayer(player, panels.custom3Players);
		});

		// Set Team Score
		$("#es-team-score-radiant").text = new String(scores.radiant);
		$("#es-team-score-dire").text = new String(scores.dire);
		$("#es-team-score-custom1").text = new String(scores.custom1);
		$("#es-team-score-custom2").text = new String(scores.custom2);
		$("#es-team-score-custom3").text = new String(scores.custom3);

		// Configure Stats Button
		$("#es-buttons-stats").SetPanelEvent("onactivate", function () {
			$.DispatchEvent("DOTADisplayURL", "http://www.dota2imba.org/stats/game/" + serverInfo.gameid);
		});
	});
}
