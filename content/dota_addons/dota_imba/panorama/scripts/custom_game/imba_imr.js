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
	}
	else {
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
	$("#LeaderboardInfoContainer").style.visibility = "collapse";

	$("#"+tab).style.visibility = "visible";
}

function Battlepass()
{
	var BattlepassRewards = CustomNetTables.GetTableValue("game_options", "battlepass").battlepass;
//	BattlepassRewards.sort();
	if (BattlepassRewards === undefined) {
		$.Msg("Battlepass undefined..")
		$.Schedule(1, Battlepass)
		return;
	} else {
		var i = 0;
		var i_count = 1;
		var class_option_count = 1;
		var i_single = false

		for (var i = 1; i <= 200; i++) {
			if (BattlepassRewards[i] != undefined) {
				if (i_single == false) {
					i_single = true
					var reward_row = $.CreatePanel("Panel", $('#BattlepassInfoContainer'), "BattlepassRow" + class_option_count);
					reward_row.AddClass("BattlepassRow")
				}

				// Battlepass reward level
//				$.Msg(BattlepassRewards.level)

				var reward = $.CreatePanel("Panel", $("#BattlepassRow" + class_option_count), BattlepassRewards[i]);
				reward.AddClass("BattlepassReward")
	
				var reward_icon = $.CreatePanel("Panel", reward, BattlepassRewards[i] + "_icon");
				reward_icon.AddClass("BattlepassRewardIcon")
				reward_icon.style.backgroundImage = 'url("file://{images}/custom_game/battlepass/'+ BattlepassRewards[i] +'.png")';

				// all tooltips only show the last created window...
//				(function () {
//					reward_icon.SetPanelEvent("onmouseover", function() {
//						$.DispatchEvent("DOTAShowTextTooltip", reward_icon, $.Localize("battlepass_" + BattlepassRewards[i]));
//					})
//					reward_icon.SetPanelEvent("onmouseout", function() {
//						$.DispatchEvent( "DOTAHideTextTooltip", reward_icon);
//					})
//				})(reward_icon);

				var reward_label = $.CreatePanel("Label", reward, BattlepassRewards[i] + "_label");
				reward_label.AddClass("BattlepassRewardLabel")
				reward_label.text = $.Localize("battlepass_level") + i;

				var radiantPlayers = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_GOODGUYS );
				$.Each( radiantPlayers, function( player ) {
					var plyData = CustomNetTables.GetTableValue("player_table", player);
					if (plyData != null) {
						if (i >= plyData.Lvl) {
							reward_icon.AddClass("BattlepassRewardIcon_locked")
							var reward_label_locked = $.CreatePanel("Label", reward_icon, BattlepassRewards[i] + "_label");
							reward_label_locked.AddClass("BattlepassRewardLabelLocked")
							reward_label_locked.text = $.Localize("battlepass_reward_locked");
						}
					}
				});
				// onmouseover="UIShowTextTooltip( imba_gamemode_settings_tower_power_title_tooltip )"
				// onmouseout="UIHideTextTooltip()">

				var direPlayers = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_BADGUYS );
				$.Each( direPlayers, function( player ) {
					var plyData = CustomNetTables.GetTableValue("player_table", player);
					if (plyData != null) {
						if (i >= plyData.Lvl) {
							reward_icon.AddClass("BattlepassRewardIcon_locked")
							var reward_label_locked = $.CreatePanel("Label", reward_icon, BattlepassRewards[i] + "_label");
							reward_label_locked.AddClass("BattlepassRewardLabelLocked")
							reward_label_locked.text = $.Localize("battlepass_reward_locked");
						}
					}
				});				

				i_count = i_count +1

				if (i_count > 10) {
					class_option_count = class_option_count +1
					var reward_row = $.CreatePanel("Panel", $('#BattlepassInfoContainer'), "BattlepassRow" + class_option_count);
					reward_row.AddClass("BattlepassRow")
					i_count = 1
				}
			}	
		}
	}
}

var current_type = ""
function HallOfFame(type)
{
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

		if ($("#player_"+i)) {
			$("#player_"+i).DeleteAsync(0);
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
	// Update the game options display
	var bounty_multiplier = CustomNetTables.GetTableValue("game_options", "bounty_multiplier");
	var exp_multiplier = CustomNetTables.GetTableValue("game_options", "exp_multiplier");
	var tower_power = CustomNetTables.GetTableValue("game_options", "tower_power");
	var initial_gold = CustomNetTables.GetTableValue("game_options", "initial_gold");
	var initial_level = CustomNetTables.GetTableValue("game_options", "initial_level");
	var max_level = CustomNetTables.GetTableValue("game_options", "max_level");
	var frantic_mode = CustomNetTables.GetTableValue("game_options", "frantic_mode");
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

	$("#TowerPowerValue").text = $.Localize( '#imba_gamemode_settings_power_' + tower_power[1] );
	GameEvents.Subscribe("hall_of_fame", HallOfFame);
})();
