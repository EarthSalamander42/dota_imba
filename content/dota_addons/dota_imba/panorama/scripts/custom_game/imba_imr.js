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
			Battlepass()
			HallOfFame("XP")
		}
	} else {
		$("#BattlepassWindow").style.visibility = "collapse";
		toggle = false
	}
}

var toggle = false

function ToggleGameOptions() {
	var bool = ""

	if (toggle == false) {
		toggle = true
		$("#ImbaGameInfo").style.visibility = "visible"
	} else {
		toggle = false
		$("#ImbaGameInfo").style.visibility = "collapse"
	}
}

function SwitchTab(tab) {
	$("#BattlepassInfoContainer").style.visibility = "collapse";
	$("#DonatorInfoContainer").style.visibility = "collapse";
	$("#LeaderboardInfoContainer").style.visibility = "collapse";

	$("#" + tab).style.visibility = "visible";
}

var companions = null

function Battlepass() {
	var BattlepassRewards = CustomNetTables.GetTableValue("game_options", "battlepass").battlepass;

	$.AsyncWebRequest('http://api.dota2imba.org/meta/companions', {
		type: 'GET',
		dataType: 'json',
		success: function (d) {
			companions = d.data
		},

		timeout: 5000,
		error: function (err) {
			$.Msg("Companion Api Error: " + JSON.stringify(err));
		}
	});

	//	BattlepassRewards.sort();
	if (BattlepassRewards === undefined || companions == null) {
		$.Msg("Battlepass or Companions undefined..")
		$.Schedule(1, Battlepass)
		return;
	} else {
		var radiantPlayers = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS);
		$.Each(radiantPlayers, function (player) {
			if (player != Players.GetLocalPlayer()) {
				return
			}
			var i_count = 0;
			var class_option_count = 1;
			var plyData = CustomNetTables.GetTableValue("player_table", player);

			//Button Generator (is_donator not added yet in lua)
			var button_count = 3;

			//			if (plyData.is_donator) {
			//				button_count = button_count +1;
			//			}

			var button_size = 100 / button_count;
			button_size = button_size.toString();
			$("#BattlepassTabButton").style.width = button_size + "%";
			$("#DonatorTabButton").style.width = button_size + "%";
			$("#LeaderboardTabButton").style.width = button_size + "%";

			var reward_row = $.CreatePanel("Panel", $('#BattlepassInfoContainer'), "BattlepassRow" + class_option_count + "_" + player);
			reward_row.AddClass("BattlepassRow")

			// Battlepass Generator
			for (var i = 0; i <= 200; i++) {
				if (BattlepassRewards[i] != undefined) {

					i_count = i_count + 1

					if (i_count > 10) {
						class_option_count = class_option_count + 1
						var reward_row = $.CreatePanel("Panel", $('#BattlepassInfoContainer'), "BattlepassRow" + class_option_count + "_" + player);
						reward_row.AddClass("BattlepassRow")
						i_count = 1
					}

					var reward = $.CreatePanel("Panel", $("#BattlepassRow" + class_option_count + "_" + player), BattlepassRewards[i]);
					reward.AddClass("BattlepassReward")

					//					$.Msg(i + " " + BattlepassRewards[i])

					var reward_icon = $.CreatePanel("Panel", reward, BattlepassRewards[i] + "_icon");
					reward_icon.AddClass("BattlepassRewardIcon")
					reward_icon.style.backgroundImage = 'url("file://{images}/custom_game/battlepass/' + BattlepassRewards[i] + '.png")';

					var reward_label = $.CreatePanel("Label", reward, BattlepassRewards[i] + "_label");
					reward_label.AddClass("BattlepassRewardLabel")
					reward_label.text = $.Localize("battlepass_level") + i;

					if (plyData != null) {
						if (i <= plyData.Lvl) {
							var reward_label_unlocked = $.CreatePanel("Label", reward_icon, BattlepassRewards[i] + "_label");
							reward_label_unlocked.AddClass("BattlepassRewardLabelUnlocked")
							reward_label_unlocked.text = $.Localize("#battlepass_" + BattlepassRewards[i]);
						} else {
							reward_icon.AddClass("BattlepassRewardIcon_locked")
							var reward_label_locked = $.CreatePanel("Label", reward_icon, BattlepassRewards[i] + "_label");
							reward_label_locked.AddClass("BattlepassRewardLabelLocked")
							reward_label_locked.text = $.Localize("battlepass_reward_locked");
						}

						// all tooltips only show the last created window...
						//						(function () {
						//							reward_icon.SetPanelEvent("onmouseover", function() {
						//								$.DispatchEvent("DOTAShowTextTooltip", reward_icon, $.Localize("battlepass_" + BattlepassRewards[i]));
						//							})
						//							reward_icon.SetPanelEvent("onmouseout", function() {
						//								$.DispatchEvent( "DOTAHideTextTooltip", reward_icon);
						//							})
						//						})(reward_icon);
					} else {
						reward_icon.AddClass("BattlepassRewardIcon_locked")
						var reward_label_locked = $.CreatePanel("Label", reward_icon, BattlepassRewards[i] + "_label");
						reward_label_locked.AddClass("BattlepassRewardLabelLocked")
						reward_label_locked.text = $.Localize("battlepass_reward_locked");
					}

					// onmouseover="UIShowTextTooltip( imba_gamemode_settings_tower_power_title_tooltip )"
					// onmouseout="UIHideTextTooltip()">
				}
			}

			class_option_count = 1
			i_count = 0

			var donator_row = $.CreatePanel("Panel", $('#DonatorInfoContainer'), "DonatorRow" + class_option_count + "_" + player);
			donator_row.AddClass("DonatorRow")

			// Companion Generator
			var companion_unit = []
			for (var i = 0; i <= companions.length - 1; i++) {
				if (companions[i] != undefined) {
					i_count = i + 1
					companion_unit[i] = companions[i]["file"]
					//					$.Msg(companion_unit[i.toString()])

					if (i_count > 5) {
						class_option_count = class_option_count + 1
						var donator_row = $.CreatePanel("Panel", $('#DonatorInfoContainer'), "DonatorRow" + class_option_count + "_" + player);
						donator_row.AddClass("DonatorRow")
					}

					var companion = $.CreatePanel("Panel", $("#DonatorRow" + class_option_count + "_" + player), companions[i]["name"]);
					companion.AddClass("DonatorReward")

					var companionpreview = $.CreatePanel("Button", companion, "CompanionPreview_" + i);
					companionpreview.style.width = "100%";
					companionpreview.style.height = "85%";
					companionpreview.BLoadLayoutFromString('<root><Panel><DOTAScenePanel style="width:100%; height:100%;" particleonly="false" unit="' + companion_unit[i.toString()] + '"/></Panel></root>', false, false);
					companionpreview.style.opacityMask = 'url("s2r://panorama/images/masks/hero_model_opacity_mask_png.vtex");'

					var companion_unit_name = companion_unit[i];

					/* This is weird. Seams like panorama v8 has a bug here. companion_unit_name should be 
					 * copy-by-value but instead is copy-by-reference */
					var event = function (ev) {
						return function () {
							SetCompanion(ev);
						}
					};
					
					companionpreview.SetPanelEvent("onactivate", event(companion_unit_name));

					var reward_label = $.CreatePanel("Label", companion, companions[i]["name"] + "_label");
					reward_label.AddClass("BattlepassRewardLabel")
					reward_label.text = companions[i]["name"];

					if (plyData != null) {
						if (i <= plyData.Lvl) {
							var reward_label_unlocked = $.CreatePanel("Label", reward_icon, companions[i] + "_label");
							reward_label_unlocked.AddClass("BattlepassRewardLabelUnlocked")
							reward_label_unlocked.text = $.Localize("#battlepass_" + companions[i]);
						} else {
							reward_icon.AddClass("BattlepassRewardIcon_locked")
							var reward_label_locked = $.CreatePanel("Label", reward_icon, companions[i] + "_label");
							reward_label_locked.AddClass("BattlepassRewardLabelLocked")
							reward_label_locked.text = $.Localize("battlepass_reward_locked");
						}

						// all tooltips only show the last created window...
						//						(function () {
						//							reward_icon.SetPanelEvent("onmouseover", function() {
						//								$.DispatchEvent("DOTAShowTextTooltip", reward_icon, $.Localize("battlepass_" + companions[i]));
						//							})
						//							reward_icon.SetPanelEvent("onmouseout", function() {
						//								$.DispatchEvent( "DOTAHideTextTooltip", reward_icon);
						//							})
						//						})(reward_icon);
					} else {
						reward_icon.AddClass("BattlepassRewardIcon_locked")
						var reward_label_locked = $.CreatePanel("Label", reward_icon, companions[i] + "_label");
						reward_label_locked.AddClass("BattlepassRewardLabelLocked")
						reward_label_locked.text = $.Localize("battlepass_reward_locked");
					}

					// onmouseover="UIShowTextTooltip( imba_gamemode_settings_tower_power_title_tooltip )"
					// onmouseout="UIHideTextTooltip()">
				}
			}
		});

		var direPlayers = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_BADGUYS);
		$.Each(direPlayers, function (player) {
			if (player != Players.GetLocalPlayer()) {
				return
			}
			var i_count = 0;
			var class_option_count = 1;

			var reward_row = $.CreatePanel("Panel", $('#BattlepassInfoContainer'), "BattlepassRow" + class_option_count + "_" + player);
			reward_row.AddClass("BattlepassRow")

			for (var i = 0; i <= 500; i++) {
				if (BattlepassRewards[i] != undefined) {

					i_count = i_count + 1

					if (i_count > 10) {
						$.Msg("Create second panel...")
						class_option_count = class_option_count + 1
						var reward_row = $.CreatePanel("Panel", $('#BattlepassInfoContainer'), "BattlepassRow" + class_option_count + "_" + player);
						reward_row.AddClass("BattlepassRow")
						i_count = 1
					}

					var reward = $.CreatePanel("Panel", $("#BattlepassRow" + class_option_count + "_" + player), BattlepassRewards[i]);
					reward.AddClass("BattlepassReward")

					//					$.Msg(i + " " + BattlepassRewards[i])

					var reward_icon = $.CreatePanel("Panel", reward, BattlepassRewards[i] + "_icon");
					reward_icon.AddClass("BattlepassRewardIcon")
					reward_icon.style.backgroundImage = 'url("file://{images}/custom_game/battlepass/' + BattlepassRewards[i] + '.png")';

					var reward_label = $.CreatePanel("Label", reward, BattlepassRewards[i] + "_label");
					reward_label.AddClass("BattlepassRewardLabel")
					reward_label.text = $.Localize("battlepass_level") + i;

					var plyData = CustomNetTables.GetTableValue("player_table", player);
					if (plyData != null) {
						if (i <= plyData.Lvl) {
							var reward_label_unlocked = $.CreatePanel("Label", reward_icon, BattlepassRewards[i] + "_label");
							reward_label_unlocked.AddClass("BattlepassRewardLabelUnlocked")
							reward_label_unlocked.text = $.Localize("#battlepass_" + BattlepassRewards[i]);
						} else {
							reward_icon.AddClass("BattlepassRewardIcon_locked")
							var reward_label_locked = $.CreatePanel("Label", reward_icon, BattlepassRewards[i] + "_label");
							reward_label_locked.AddClass("BattlepassRewardLabelLocked")
							reward_label_locked.text = $.Localize("battlepass_reward_locked");
						}

						// all tooltips only show the last created window...
						//						(function () {
						//							reward_icon.SetPanelEvent("onmouseover", function() {
						//								$.DispatchEvent("DOTAShowTextTooltip", reward_icon, $.Localize("battlepass_" + BattlepassRewards[i]));
						//							})
						//							reward_icon.SetPanelEvent("onmouseout", function() {
						//								$.DispatchEvent( "DOTAHideTextTooltip", reward_icon);
						//							})
						//						})(reward_icon);
					} else {
						reward_icon.AddClass("BattlepassRewardIcon_locked")
						var reward_label_locked = $.CreatePanel("Label", reward_icon, BattlepassRewards[i] + "_label");
						reward_label_locked.AddClass("BattlepassRewardLabelLocked")
						reward_label_locked.text = $.Localize("battlepass_reward_locked");
					}

					// onmouseover="UIShowTextTooltip( imba_gamemode_settings_tower_power_title_tooltip )"
					// onmouseout="UIHideTextTooltip()">
				}
			}
		});
	}
}

function SetCompanion(companion) {

	var steamId = Game.GetLocalPlayerInfo().player_steamid;
	var url = 'http://api.dota2imba.org/meta/set-companion';
	var data = {
		companion: companion,
		steam_id: steamId
	};

	$.AsyncWebRequest(url, {
		type: 'POST',
		success: function (d) {
			companions = d.data;
			$.Msg("Companion Api Good: " + JSON.stringify(d));
		},
		data: data,
		error: function (err) {
			$.Msg("Companion Api Error: " + JSON.stringify(err));
		}
	});

}

var current_type = ""

function HallOfFame(type) {
	if (current_type == type) {
		$.Msg("Bro don't reload you're fine!")
		return;
	}
	current_type = type
	for (var i = 1; i <= 10; i++) {
		if (type == "XP") {
			var top_users = CustomNetTables.GetTableValue("top_xp", i.toString());
		} else if (type == "IMR") {
			var top_users = CustomNetTables.GetTableValue("top_imr_5v5", i.toString());
		}

		if ($("#player_" + i)) {
			$("#player_" + i).DeleteAsync(0);
		}

		var player = $.CreatePanel("Panel", $('#Tops'), "player_" + i);
		player.AddClass("LeaderboardGames")
		var rank = $.CreatePanel("Label", player, "rank_" + i);
		rank.AddClass("LeaderboardRank")
		rank.text = i

		var steam_id = $.CreatePanel("DOTAAvatarImage", player, "player_steamid_" + i);
		steam_id.AddClass("LeaderboardAvatar")
		steam_id.steamid = top_users.SteamID64
		steam_id.style.width = "15%";
		steam_id.style.height = "100%";
		steam_id.style.borderLeft = "1px solid white";
		steam_id.style.borderTop = "1px solid white";
		steam_id.style.borderRight = "1px solid white";

		var imbar_container = $.CreatePanel("Panel", player, "imbar_container_" + i);
		imbar_container.AddClass("LeaderboardXP")
		var imbar = $.CreatePanel("ProgressBar", imbar_container, "imbar_" + i);
		imbar.AddClass("imbar-progress-bar")
		imbar.value = top_users.XP / top_users.MaxXP

		var imbar_lvl = $.CreatePanel("Label", imbar_container, "imbar_lvl" + i);
		imbar_lvl.AddClass("imbar-lvl")
		imbar_lvl.text = "Level: " + top_users.Lvl

		var imbar_rank = $.CreatePanel("Label", imbar_container, "imbar_rank" + i);
		imbar_rank.AddClass("imbar-rank")
		imbar_rank.text = top_users.title
		imbar_rank.style.color = top_users.title_color

		var imbar_xp = $.CreatePanel("Label", imbar_container, "imbar_xp" + i);
		imbar_xp.AddClass("imbar-xp")
		imbar_xp.text = top_users.XP + "/" + top_users.MaxXP

		var imr = $.CreatePanel("Label", player, "rank_" + i);
		imr.AddClass("LeaderboardIMR")
		imr.text = top_users.IMR_5v5.toFixed([0])
	}
}

function ClassBy(type) {
	HallOfFame(type)
}

(function () {
	// Update the game options display
	var bounty_multiplier = CustomNetTables.GetTableValue("game_options", "bounty_multiplier");
	var exp_multiplier = CustomNetTables.GetTableValue("game_options", "exp_multiplier");
	var tower_power = CustomNetTables.GetTableValue("game_options", "tower_power");
	var initial_gold = CustomNetTables.GetTableValue("game_options", "initial_gold");
	var initial_level = CustomNetTables.GetTableValue("game_options", "initial_level");
	var max_level = CustomNetTables.GetTableValue("game_options", "max_level");
	var frantic_mode = CustomNetTables.GetTableValue("game_options", "frantic_mode");
	var gold_tick = CustomNetTables.GetTableValue("game_options", "gold_tick");
	var frantic = "Disabled";

	if (frantic_mode[1] == 1) {
		frantic = "Enabled"
	}

	$("#BountyMultiplierValue").text = bounty_multiplier[1] + "%";
	$("#ExpMultiplierValue").text = exp_multiplier[1] + "%";
	$("#InitialGoldValue").text = initial_gold[1];
	$("#InitialLevelValue").text = initial_level[1];
	$("#MaxLevelValue").text = max_level[1];
	$("#FranticModeValue").text = frantic;
	$("#GoldTickValue").text = gold_tick[1].toFixed(1);

	$("#TowerPowerValue").text = $.Localize('#imba_gamemode_settings_power_' + tower_power[1]);
	GameEvents.Subscribe("hall_of_fame", HallOfFame);
})();
