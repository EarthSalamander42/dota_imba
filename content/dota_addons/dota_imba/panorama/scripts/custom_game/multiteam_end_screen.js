"use strict";

(function() {	
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

		$.Msg("End game received");

		// Gather info 
		var playerResults = args.players;
		var serverInfo = args.info;
		var xpInfo = args.xp_info;
		var mapInfo = Game.GetMapInfo();
		var radiantPlayerIds = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_GOODGUYS );
		var direPlayerIds = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_BADGUYS );

		$.Msg({
			args: args,
			info: {
				map: mapInfo,
				ids1: radiantPlayerIds,
				ids2: direPlayerIds
			}
		});

		// Victory Info text
		var victoryMessage = "winning_team_name Victory!";
		var victoryMessageLabel = $("#es-victory-info-text");

		if (serverInfo.winner == 2)
			victoryMessage = victoryMessage.replace("winning_team_name", "Radiant");
		else
			victoryMessage = victoryMessage.replace("winning_team_name", "Dire");

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
		var playerXmlFile = "file://{resources}/layout/custom_game/multiteam_end_screen_player.xml";

		// sort a player by merging results from server and using getplayerinfo  
		var loadPlayer = function (id) {
			
			$.Msg("Loading player " + id);

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

		$.Each(radiantPlayerIds, function (id) { radiantPlayers.push(loadPlayer(id)); });
		$.Each(direPlayerIds, function (id) { direPlayers.push(loadPlayer(id)); });

		var createPanelForPlayer = function (player, parent) {

			$.Msg("Creating Panel for player " + player.info.player_steamid);

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

			$.Msg("Ok we loaded the layout file");


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

			$.Msg("Player panel complete");

		};

		var scores = {
			radiant: 0,
			dire: 0
		};

		$.Msg("Creating the panels");

		// Create the panels for the players
		$.Each(radiantPlayers, function (player) {
			scores.dire += player.info.player_deaths;
			createPanelForPlayer(player, panels.radiantPlayers);
		});
		
		$.Each(direPlayers, function (player) {
			scores.radiant += player.info.player_deaths;
			createPanelForPlayer(player, panels.direPlayers);
		});

		// Set Team Score
		$("#es-team-score-radiant").text = new String(scores.radiant);
		$("#es-team-score-dire").text = new String(scores.dire);

		$.Msg("Setting the gmaeid button panel event");

		// Configure Stats Button
		$("#es-buttons-stats").SetPanelEvent("onactivate", function () {
			$.DispatchEvent("DOTADisplayURL", "http://www.dota2imba.org/stats/game/" + serverInfo.gameid);
		});

		// Hide all other UI
		var MainPanel = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent()
		
		MainPanel.FindChildTraverse("topbar").style.visibility = "collapse";
		MainPanel.FindChildTraverse("minimap_container").style.visibility = "collapse";
		MainPanel.FindChildTraverse("lower_hud").style.visibility = "collapse";
		MainPanel.FindChildTraverse("HudChat").style.visibility = "collapse";
		MainPanel.FindChildTraverse("NetGraph").style.visibility = "collapse";
		MainPanel.FindChildTraverse("quickstats").style.visibility = "collapse";

		$.Msg("Scoreboard was created successfully? Or not?");
	});
}