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

	GameEvents.Subscribe("diretide_hall_of_fame", HallOfFame);
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
//			imr: pp.FindChildInLayoutFile("es-player-imr"),
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
		var player_max_xp_in_level = ply_table.MaxXP

		// temporary, will be fixed with xp system on backend side
		if (typeof player_xp != "number")
			player_xp = 0;

		if (typeof player_max_xp_in_level != "number")
			player_max_xp_in_level = 500;

		// Comment me please
//		if (Game.IsInToolsMode())
//			var player_xp = 7800;

		if (ply_table && ply_table.player_xp == 1) {
			values.xp.rank.text = Math.floor(player_xp) + "/" + Math.floor(player_max_xp_in_level);
			values.xp.level.text = $.Localize("#battlepass_level") + ply_table.Lvl;
			values.xp.rank_name.text = ply_table.title;
			values.xp.rank_name.style.color = ply_table.title_color;
			if (ply_table.in_game_tag == 1)
				values.xp.booster.style.color = ply_table.donator_color;

//			$.Msg(Math.floor(player_xp) + " / " + Math.floor(player_max_xp_in_level))
//			$.Msg(Math.floor(player_xp) / Math.floor(player_max_xp_in_level))

			var progress = Math.round((100.0 * Math.floor(player_xp)) / Math.floor(player_max_xp_in_level));
			values.xp.progress.style.width = progress + "%";
		} else {			
			values.xp.rank.text = "N/A";
			values.xp.level.text = "N/A";
			values.xp.rank_name.text = "N/A";
			values.xp.rank_name.style.color = "#FFFFFF";
			values.xp.progress.style.width = "0%";			
		}

		if (player.result != null) {
			var xpDiff = Math.floor(player.result.xp_change);
//			if (Game.IsInToolsMode())
//				xpDiff = 300000;

			// fail-safe to prevent text being grey
			values.xp.earned.text = "0";
			values.xp.earned.AddClass("es-text-white");

			if (xpDiff > 0) {
				if (ply_table && ply_table.player_xp == 1) {
					values.xp.earned.text = "+" + xpDiff;
				} else {
					values.xp.earned.text = "+N/A";
				}
				values.xp.earned.AddClass("es-text-green");

				if (ply_table) {
					if (progress) {
						var progress_diff = Math.round(100.0 * (xpDiff / player_max_xp_in_level));
						values.xp.progress_diff.style.width = progress_diff + "%";
						values.xp.progress_diff.style.marginLeft = (progress - 1) + "%";
					}

					var levelup_count = Math.floor(player_xp + xpDiff) / Math.floor(player_max_xp_in_level);

					if (levelup_count >= 1) {
						values.xp.bar[0].AddClass("level-up");						
					}

					if (player.id == Players.GetLocalPlayer()) {
						for (var i = 1; i <= levelup_count; i++) {
							var level = ply_table.Lvl + i;
							// Comment me please
//							if (Game.IsInToolsMode())
//								var level = 0 + i;

							CreateBattlepassRewardPanel(level, i);
						}
					}
				}
			} else {
				values.xp.earned.text = new String(xpDiff);
				values.xp.earned.AddClass("es-text-red");
			}

			if (ply_table && ply_table.in_game_tag == 1) {
				var multiplier = Math.round(player.result.xp_multiplier * 100.0);
				values.xp.booster.text = " (" + multiplier + "%)";
			} else {
				values.xp.booster.text = " (100%)";
			}
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

function CloseBottlepassReward(panel) {
	panel.style.visibility = 'collapse';
}

function CreateBattlepassRewardPanel(level, levelup_count) {
	var battlepass = CustomNetTables.GetTableValue("game_options", "battlepass").battlepass;

	if (battlepass != undefined && battlepass[level] != undefined) {
		var battlepass_reward = battlepass[level][1];
		var battlepass_rarity = battlepass[level][2];
//		$.Msg("Earned a reward:")
//		$.Msg(level)
//		$.Msg(battlepass_reward)
//		$.Msg(battlepass_rarity)

		var rp = $.CreatePanel("Panel", $("#es-player-reward-panel"), "es-player-reward-container" + levelup_count);
		rp.AddClass("es-player-reward-container");
		rp.AddClass("es-player-reward");

		var rewards = {
			desc: $.CreatePanel("Label", rp, "es-player-reward-description" + levelup_count),
			name: $.CreatePanel("Label", rp, "es-player-reward-name" + levelup_count),
			rarity: $.CreatePanel("Label", rp, "es-player-reward-rarity" + levelup_count),
			image: $.CreatePanel("Panel", rp, "es-player-reward-image" + levelup_count),
			button: $.CreatePanel("Button", rp, "es-player-reward-button" + levelup_count),
		};

		rewards.desc.AddClass("es-player-reward-description")
		rewards.name.AddClass("es-player-reward-name")
		rewards.rarity.AddClass("es-player-reward-rarity")
		rewards.image.AddClass("es-player-reward-image")
		rewards.button.AddClass("es-player-reward-button")
		rewards.button.SetPanelEvent("onactivate", function() {

			rp.style.visibility = "collapse"
		});

		var button_label = $.CreatePanel("Label", rewards.button, "es-player-reward-button_label" + levelup_count)
		button_label.AddClass("es-player-reward-button_label");
		button_label.text = "Accept";

		if (Game.IsInToolsMode()) {
			rp.RemoveClass("level-common");
			rp.RemoveClass("level-uncommon");
			rp.RemoveClass("level-rare");
			rp.RemoveClass("level-mythical");
			rp.RemoveClass("level-legendary");
			rp.RemoveClass("level-immortal");
			rp.RemoveClass("level-arcana");
			rp.RemoveClass("level-ancient");
			rewards.rarity.RemoveClass("common");
			rewards.rarity.RemoveClass("uncommon");
			rewards.rarity.RemoveClass("rare");
			rewards.rarity.RemoveClass("mythical");
			rewards.rarity.RemoveClass("legendary");
			rewards.rarity.RemoveClass("immortal");
			rewards.rarity.RemoveClass("arcana");
			rewards.rarity.RemoveClass("ancient");
		}

		rp.style.visibility = 'visible';
		rewards.desc.text = $.Localize("battlepass_reward_description") + " " + level;
		rewards.name.text = $.Localize("battlepass_" + battlepass_reward);
		rewards.rarity.AddClass(battlepass_rarity);
		rewards.rarity.text = battlepass_rarity;
		rewards.image.style.backgroundImage = 'url("file://{resources}/images/custom_game/battlepass/' + battlepass_reward + '.png")';
		rewards.image.style.backgroundSize = 'cover';

		rp.AddClass('level-' + battlepass_rarity);

		var sound_name = {};
		sound_name["common"] = "Loot_Drop_Sfx";
		sound_name["uncommon"] = "Loot_Drop_Stinger_Uncommon";
		sound_name["rare"] = "Loot_Drop_Stinger_Rare";
		sound_name["mythical"] = "Loot_Drop_Stinger_Mythical";
		sound_name["legendary"] = "Loot_Drop_Stinger_Legendary";
		sound_name["immortal"] = "Loot_Drop_Stinger_Immortal";
		sound_name["arcana"] = "Loot_Drop_Stinger_Arcana";
		sound_name["ancient"] = "Loot_Drop_Stinger_Ancient";

		Game.EmitSound(sound_name[battlepass_rarity])
	}
}

function HallOfFame(args) {
	var diretide_records = args.data.games;
//	$.Msg(diretide_records)

	if (diretide_records == undefined)
		return;

	var leaderboard_container = $("#LeaderboardInfoContainer");
	if (Game.GetMapInfo().map_display_name == "imba_10v10")
		leaderboard_container.style.width = "80%";
	leaderboard_container.style.visibility = "visible";

	var i = 0;

	while (diretide_records[i] && i < 10) {
		var j = 1;
		var players = diretide_records[i]["players"];
		var roshan_level = diretide_records[i]["rosh_lvl"];
		var roshan_health = diretide_records[i]["rosh_hp"];
		var roshan_max_health = diretide_records[i]["rosh_max_hp"];

//		if ($("#player_" + i)) {
//			$("#player_" + i).DeleteAsync(0);
//		}

		var row = $.CreatePanel("Panel", $('#Tops'), "row_" + i);
		row.AddClass("LeaderboardGames");
		var rank = $.CreatePanel("Label", row, "rank_" + i);
		rank.AddClass("LeaderboardRank");
		rank.text = i + 1;

		var players_row = $.CreatePanel("Panel", row, "player_row_" + i);
		players_row.AddClass("LeaderboardXP");
		players_row.style.flowChildren = "right";
		players_row.style.width = "fit-children";

		while (players[j]) {
			var steamid = players[j];
//			$.Msg(steamid)
			var panel_steam_id = $.CreatePanel("DOTAAvatarImage", players_row, "player_steamid_" + j);
			panel_steam_id.AddClass("LeaderboardAvatar");
			panel_steam_id.steamid = steamid;
			panel_steam_id.style.width = "30px";
			panel_steam_id.style.height = "30px";
			panel_steam_id.style.marginLeft = "0.5%";
			panel_steam_id.style.marginRight = "0.5%";
			panel_steam_id.style.verticalAlign = "center";

			j++;
		}

/*
		var leaderboard_border = [];
		leaderboard_border[1] = "darkred"
		leaderboard_border[2] = "red"
		leaderboard_border[3] = "blue"
		leaderboard_border[4] = "darkred"
		leaderboard_border[5] = "gold"
		leaderboard_border[6] = "green"
		leaderboard_border[7] = "purple"
		leaderboard_border[8] = "dodgerblue"
		leaderboard_border[9] = "brown"
*/
//		if (top_users[i - 1].donator_level)
//			steam_id.style.border = "2px solid " + leaderboard_border[top_users.donator_level];
//			steam_id.style.border = "2px solid " + leaderboard_border[i];
//		else
//			steam_id.style.border = "2px solid #3f464ecc";







		var roshan_row = $.CreatePanel("Panel", row, "roshan_row_" + i);
		roshan_row.AddClass("LeaderboardIMR");


		var imbar_container = $.CreatePanel("Panel", roshan_row, "imbar_container_" + i);
		imbar_container.AddClass("imbar-progress-bar");
		var imbar = $.CreatePanel("ProgressBar", imbar_container, "imbar_" + i);
		imbar.AddClass("imbar-progress-bar");
		imbar.value = parseFloat(roshan_health / roshan_max_health);

		var imbar_lvl = $.CreatePanel("Label", imbar_container, "imbar_lvl" + i);
		imbar_lvl.AddClass("imbar-lvl");
		imbar_lvl.text = "Level: " + roshan_level;

		var imbar_rank_wrapper = $.CreatePanel("Panel", imbar_container, "imbar_rank" + i);
		imbar_rank_wrapper.AddClass("imbar-rank-wrapper");

		var imbar_rank_circle = $.CreatePanel("Panel", imbar_rank_wrapper, "");
		imbar_rank_circle.AddClass("imbar-rank-cicle");
		imbar_rank_circle.style.backgroundColor = "white";
//		imbar_rank_circle.style.backgroundColor = top_users.title_color;

		var imbar_rank = $.CreatePanel("Label", imbar_rank_wrapper, "");
		imbar_rank.AddClass("imbar-rank");
		imbar_rank.text = roshan_health + " / " + roshan_max_health;

//		var imbar_xp = $.CreatePanel("Label", imbar_container, "imbar_xp" + i);
//		imbar_xp.AddClass("imbar-xp");
//		imbar_xp.text = top_users.XP + "/" + top_users.MaxXP;

//		var imr = $.CreatePanel("Label", player, "rank_" + i);
//		imr.AddClass("LeaderboardIMR");

		i++
	}
}

function ToggleHallofFame() {
	$("#LeaderboardInfoContainer").style.visibility = "collapse";
}
