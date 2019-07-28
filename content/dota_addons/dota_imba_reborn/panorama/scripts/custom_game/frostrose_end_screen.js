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
			} else if (xpDiff == 0) {
				values.xp.earned.text = "0";
				values.xp.earned.AddClass("es-text-white");
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