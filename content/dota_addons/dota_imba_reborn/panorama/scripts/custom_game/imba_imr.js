var playerPanels = {};

var localTeam = Players.GetTeam(Players.GetLocalPlayer())
if (localTeam != 2 && localTeam != 3) {
	HideBattlepass()
}

function HideBattlepass() {
	$.GetContextPanel().style.visibility = "collapse";
	$.Schedule(2.0, HideBattlepass)
}

var toggle = false;
var first_time = false;

var api = {
	base : "http://api.dota2imba.org/imba/",
	urls : {
		companions : "companions",
		statues : "statues",
		modifyCompanion : "modify-companion",
		modifyStatue : "modify-statue",
//		rankingsImr5v5 : "meta/rankings/imr-5v5",
//		rankingsImr10v10 : "meta/rankings/imr-10v10",
//		rankingsXp : "meta/rankings/xp",
//		rankingsLevel1v1 : "meta/rankings/level-1v1"
	},
	loadCompanions : function(callback) {
		$.AsyncWebRequest(api.base + api.urls.companions, {
			type : "GET",
			dataType : "json",
			timeout : 5000,
			success : function(obj) {
				if (obj.error || !obj.data)
					$.Msg("Error Loading Companions! " + JSON.stringify(obj.message));
				else {
					$.Msg("Loaded " + obj.data.length + " companions.");
					callback(obj.data);
				}
			},
			error : function(err) {
				$.Msg("Error Loading Companions! " + JSON.stringify(err));
			}
		});
	},
	updateCompanion : function(data, success_callback, error_callback) {
		$.AsyncWebRequest(api.base + api.urls.modifyCompanion, {
			type : "POST",
			data : data,
			timeout : 5000,
			success : function(obj) {
				if (obj.error) {
					$.Msg("Error updating companion");
					error_callback();
				} else {
					$.Msg("Updated companion");
					success_callback();
				}
			},
			error : function(err) {
				$.Msg("Error updating companion" + JSON.stringify(err));
				error_callback();
			}
		});
	},
	loadStatues : function(callback) {
		$.AsyncWebRequest(api.base + api.urls.statues, {
			type : "GET",
			dataType : "json",
			timeout : 5000,
			success : function(obj) {
				if (obj.error || !obj.data || !obj.data.ingame_statues)
					$.Msg("Error Loading Statues! " + JSON.stringify(obj.message));
				else {
					$.Msg("Loaded " + obj.data.ingame_statues.length + " statues.");
					callback(obj.data.ingame_statues);
				}
			},
			error : function(err) {
				$.Msg("Error Loading Statues! " + JSON.stringify(err));
			}
		});
	},
	updateStatue : function(data, success_callback, error_callback) {
		$.AsyncWebRequest(api.base + api.urls.modifyStatue, {
			type : "POST",
			data : data,
			timeout : 5000,
			success : function(obj) {
				if (obj.error) {
					$.Msg("Error updating statue");
					error_callback();
				} else {
					$.Msg("Updated statue");
					success_callback();
				}
			},
			error : function(err) {
				$.Msg("Error updating statue " + JSON.stringify(err));
				error_callback();
			}
		});
	}
};

function ToggleBattlepass() {
	if (toggle === false) {
		toggle = true;
		if (first_time === false) {
			first_time = true;
			Battlepass();
			HallOfFame("XP");
		}

		if ($("#BattlepassWindow").BHasClass("sethidden")) {
			$("#BattlepassWindow").RemoveClass("sethidden");
		}
		$("#BattlepassWindow").AddClass("setvisible");
	} else {
		toggle = false;
		if ($("#BattlepassWindow").BHasClass("setvisible")) {
			$("#BattlepassWindow").RemoveClass("setvisible");
		}
		$("#BattlepassWindow").AddClass("sethidden");
	}
}

var toggle = false;

function ToggleGameOptions() {
	var bool = "";

	if (toggle === false) {
		toggle = true;
		$("#ImbaGameInfo").style.visibility = "visible";
	} else {
		toggle = false;
		$("#ImbaGameInfo").style.visibility = "collapse";
	}
}

var current_sub_tab = "";

function RefreshBattlepass() {
	if ($("#RefreshBattlepass").BHasClass("Active")) {
		return;
	}

	var childrens = $("#BattlepassInfoContainer").FindChildrenWithClassTraverse("BattlepassRow");
	childrens.forEach(function(e) {
		e.DeleteAsync(0);
	});

	var companion_childrens = $("#CompanionTableWrapper").FindChildrenWithClassTraverse("DonatorRow");
	companion_childrens.forEach(function(e) {
		e.DeleteAsync(0);
	});

	var statue_childrens = $("#StatueTableWrapper").FindChildrenWithClassTraverse("DonatorRow");
	statue_childrens.forEach(function(e) {
		e.DeleteAsync(0);
	});

	var donator_childrens = $("#StatueTableWrapper").FindChildrenWithClassTraverse("DonatorRow");
	donator_childrens.forEach(function(e) {
		e.DeleteAsync(0);
	});

	$("#RefreshBattlepass").AddClass("Active");

	$.Schedule(1.0, function() {
		$("#RefreshBattlepass").RemoveClass("Active");
		if (current_sub_tab != "") {
			Battlepass(true);
		} else {
			Battlepass();
		}		
	});
}

function SwitchTab(tab) {
	$("#BattlepassInfoContainer").style.visibility = "collapse";
	$("#DonatorInfoContainer").style.visibility = "collapse";
	$("#LeaderboardInfoContainer").style.visibility = "collapse";

	$("#" + tab).style.visibility = "visible";

	if (tab == 'DonatorInfoContainer') {
		$('#MiniTabButtonContainer').style.visibility = "visible";
	} else {
		$('#MiniTabButtonContainer').style.visibility = "collapse";
	}
}

function SwitchDonatorWrapper(type) {
	if (current_sub_tab == type) {
//		$.Msg("Bro don't reload you're fine!");
		return;
	}

	current_sub_tab = type;

//	$("#PatreonTableWrapper").style.visibility = "collapse";
	$("#CompanionTableWrapper").style.visibility = "collapse";
	$("#StatueTableWrapper").style.visibility = "collapse";
//	$("#PatreonTabButton").RemoveClass('active');
	$("#CompanionTabButton").RemoveClass('active');
	$("#StatueTabButton").RemoveClass('active');

	$("#" + type + "TableWrapper").style.visibility = "visible";
	$("#" + type + "TabButton").AddClass('active');

	$('#DonatorTabTitle').text = $.Localize("#donator_" + type.toLowerCase() + "_wrapper_label").toUpperCase();
}

var companions = null;

function Battlepass(retainSubTab) {
	if (typeof retainSubTab == "undefined") {retainSubTab = false;};
	var BattlepassRewards = CustomNetTables.GetTableValue("game_options", "battlepass").battlepass;

	api.loadStatues(function(statues) {
		$.Msg("Statues and Battlepass information available");
		GenerateCompanionPanel(statues, Players.GetLocalPlayer(), "Statue", retainSubTab);
	});

	GenerateBattlepassPanel(BattlepassRewards, Players.GetLocalPlayer());

	api.loadCompanions(function(companions) {
		if (BattlepassRewards === undefined) {
			$.Msg("Battlepass undefined..");
			$.Schedule(1, Battlepass);
			return;
		} else {
			$.Msg("Companions and Battlepass information available");
			GenerateCompanionPanel(companions, Players.GetLocalPlayer(), "Companion", retainSubTab);
		}
	});
}

var companion_changed = false;

function SetCompanion(companion, name, id) {
	if (companion_changed === true) {
		$.Msg("SLOW DOWN BUDDY!");
		return;
	}

	if ($("#CompanionNotification").BHasClass("not_donator")) {
		$("#CompanionNotification").RemoveClass("not_donator");
	}

	if (IsDonator(Game.GetLocalPlayerID()) === false) {
		$("#CompanionNotification").AddClass("not_donator");
		$("#CompanionNotificationLabel").text = $.Localize("companion_not_donator");
		return;
	}

	api.updateCompanion({
		companion_id : id,
		steamid : Game.GetLocalPlayerInfo().player_steamid,
		companion_enabled : true
	}, function() {
		$("#CompanionNotification").AddClass("success");
		$("#CompanionNotificationLabel").text = $.Localize("companion_success") + $.Localize(name) + "!";
		GameEvents.SendCustomGameEventToServer("change_companion", {
			ID : Players.GetLocalPlayer(),
			unit : companion,
			js : true
		});
		$.Schedule(6.0, function() {
			$("#CompanionNotification").RemoveClass("success");
			companion_changed = false;
		});
	}, function() {
		$("#CompanionNotification").AddClass("failure");
		$("#CompanionNotificationLabel").text = $.Localize("companion_error");
		$.Schedule(6.0, function() {
			$("#CompanionNotification").RemoveClass("failure");
			companion_changed = false;
		});
	});

	companion_changed = true;
}

function SetStatue(statue, name, id) {
	if (companion_changed === true) {
		$.Msg("SLOW DOWN BUDDY!");
		return;
	}

	if ($("#CompanionNotification").BHasClass("not_donator")) {
		$("#CompanionNotification").RemoveClass("not_donator");
	}

	if (IsDonator(Game.GetLocalPlayerID()) === false) {
		$("#CompanionNotification").AddClass("not_donator");
		$("#CompanionNotificationLabel").text = $.Localize("companion_not_donator");
		return;
	}

	api.updateStatue({
		ingame_statue_id : id,
		steamid : Game.GetLocalPlayerInfo().player_steamid,
		ingame_statue_enabled : true
	}, function() {
		$("#CompanionNotification").AddClass("success");
		$("#CompanionNotificationLabel").text = $.Localize("statue_success") + $.Localize(name) + "!";
		GameEvents.SendCustomGameEventToServer("change_statue", {
			ID : Players.GetLocalPlayer(),
			unit : statue
		});
		$.Schedule(6.0, function() {
			$("#CompanionNotification").RemoveClass("success");
			companion_changed = false;
		});
	}, function() {
		$("#CompanionNotification").AddClass("failure");
		$("#CompanionNotificationLabel").text = $.Localize("companion_error");
		$.Schedule(6.0, function() {
			$("#CompanionNotification").RemoveClass("failure");
			companion_changed = false;
		});
	});

	companion_changed = true;
}

var current_type = "";
function HallOfFame(type) {

	if (current_type == type) {
//		$.Msg("Bro don't reload you're fine!");
		return;
	}

	current_type = type;

	for (var i = 1; i <= 25; i++) {
		if (type == "XP") {
			var top_users = CustomNetTables.GetTableValue("top_xp", i.toString());
		} else if (type == "IMR") {
			var top_users = CustomNetTables.GetTableValue("top_imr5v5", i.toString());
		}

		if (top_users === undefined) {
			return;
		}

		if ($("#player_" + i)) {
			$("#player_" + i).DeleteAsync(0);
		}

		var player = $.CreatePanel("Panel", $('#Tops'), "player_" + i);
		player.AddClass("LeaderboardGames");
		var rank = $.CreatePanel("Label", player, "rank_" + i);
		rank.AddClass("LeaderboardRank");
		rank.text = i;

		var steam_id = $.CreatePanel("DOTAAvatarImage", player, "player_steamid_" + i);
		steam_id.AddClass("LeaderboardAvatar");
		steam_id.steamid = top_users.SteamID64;
		steam_id.style.width = "38px";
		steam_id.style.height = "38px";
		steam_id.style.marginLeft = "40px";
		steam_id.style.marginRight = "40px";
		steam_id.style.align = "center center";

		var leaderboard_border = []
		leaderboard_border[1] = "darkred"
		leaderboard_border[2] = "red"
		leaderboard_border[3] = "blue"
		leaderboard_border[4] = "darkred"
		leaderboard_border[5] = "gold"
		leaderboard_border[6] = "green"
		leaderboard_border[7] = "purple"
		leaderboard_border[8] = "dodgerblue"
		leaderboard_border[9] = "brown"

//		if (top_users.donator_level)
//			steam_id.style.border = "2px solid " + leaderboard_border[top_users.donator_level];
			steam_id.style.border = "2px solid " + leaderboard_border[i];
//		else
//			steam_id.style.border = "2px solid #3f464ecc";

		var imbar_container = $.CreatePanel("Panel", player, "imbar_container_" + i);
		imbar_container.AddClass("LeaderboardXP");
		var imbar = $.CreatePanel("ProgressBar", imbar_container, "imbar_" + i);
		imbar.AddClass("imbar-progress-bar");
		imbar.value = top_users.XP / top_users.MaxXP;

		var imbar_lvl = $.CreatePanel("Label", imbar_container, "imbar_lvl" + i);
		imbar_lvl.AddClass("imbar-lvl");
		imbar_lvl.text = "Level: " + top_users.Lvl;

		var imbar_rank_wrapper = $.CreatePanel("Panel", imbar_container, "imbar_rank" + i);
		imbar_rank_wrapper.AddClass("imbar-rank-wrapper");

		var imbar_rank_circle = $.CreatePanel("Panel", imbar_rank_wrapper, "");
		imbar_rank_circle.AddClass("imbar-rank-cicle");
		imbar_rank_circle.style.backgroundColor = top_users.title_color;

		var imbar_rank = $.CreatePanel("Label", imbar_rank_wrapper, "");
		imbar_rank.AddClass("imbar-rank");
		imbar_rank.text = top_users.title;

		var imbar_xp = $.CreatePanel("Label", imbar_container, "imbar_xp" + i);
		imbar_xp.AddClass("imbar-xp");
		imbar_xp.text = top_users.XP + "/" + top_users.MaxXP;

		var imr = $.CreatePanel("Label", player, "rank_" + i);
		imr.AddClass("LeaderboardIMR");
		imr.text = top_users.IMR_5v5.toFixed([0]);
	}
}

function SafeToLeave() {
	$("#SafeToLeave").style.visibility = "visible";
}

function GenerateBattlepassPanel(BattlepassRewards, player) {
	var i_count = 0;
	var class_option_count = 1;
	var plyData = CustomNetTables.GetTableValue("player_table", player);

	var reward_row = $.CreatePanel("Panel", $('#BattlepassInfoContainer'), "BattlepassRow" + class_option_count + "_" + player);
	reward_row.AddClass("BattlepassRow");

	for (var i = 1; i <= 500; i++) {
		if (BattlepassRewards[i] != undefined) {
			var is_arcana = false;
			var is_immortal = false;

			i_count++;

			var arcana = BattlepassRewards[i].search("arcana");
			var immortal = BattlepassRewards[i].search("immortal");

			if (arcana != -1)
				is_arcana = true;
			else if (immortal != -1)
				is_immortal = true;

			if (i_count > 10) {
				class_option_count = class_option_count + 1;
				var reward_row = $.CreatePanel("Panel", $('#BattlepassInfoContainer'), "BattlepassRow" + class_option_count + "_" + player);
				reward_row.AddClass("BattlepassRow");
				i_count = 1;
			}

			var reward = $.CreatePanel("Panel", $("#BattlepassRow" + class_option_count + "_" + player), BattlepassRewards[i]);
			reward.AddClass("BattlepassReward");
			var reward_icon = $.CreatePanel("Panel", reward, BattlepassRewards[i] + "_icon");
			reward_icon.style.backgroundImage = 'url("file://{images}/custom_game/battlepass/' + BattlepassRewards[i] + '.png")';
			reward_icon.AddClass("BattlepassRewardIcon");
			if (is_arcana == true)
				reward_icon.AddClass("arcana_border");
			if (is_immortal == true)
				reward_icon.AddClass("immortal_border");

			var reward_label = $.CreatePanel("Label", reward, BattlepassRewards[i] + "_label");
			reward_label.AddClass("BattlepassRewardLabel");
			reward_label.text = $.Localize("battlepass_level") + i;
			if (is_arcana == true)
				reward_label.AddClass("arcana_text");
			if (is_immortal == true)
				reward_label.AddClass("immortal_text");

			if (plyData != null) {
				if (i <= plyData.Lvl) {
					var reward_panel_unlocked = $.CreatePanel("Panel", reward_icon, BattlepassRewards[i] + "_panel_unlock");
					reward_panel_unlocked.AddClass("BattlepassRewardPanelUnlocked");
					reward_label.AddClass("unlocked");

					var reward_label_unlocked = $.CreatePanel("Label", reward_panel_unlocked, BattlepassRewards[i] + "_label");
					reward_label_unlocked.AddClass("BattlepassRewardLabelUnlocked");
					reward_label_unlocked.text = $.Localize("#battlepass_" + BattlepassRewards[i]);
				} else {
					reward_label.AddClass("locked");
					reward_icon.AddClass("BattlepassRewardIcon_locked")
					var reward_label_locked = $.CreatePanel("Label", reward_icon, BattlepassRewards[i] + "_label");
					reward_label_locked.AddClass("BattlepassRewardLabelLocked");
					reward_label_locked.text = $.Localize("battlepass_reward_locked") + $.Localize("#battlepass_" + BattlepassRewards[i]);
				}
			} else {
				reward_icon.AddClass("BattlepassRewardIcon_locked")
				var reward_label_locked = $.CreatePanel("Label", reward_icon, BattlepassRewards[i] + "_label");
				reward_label_locked.AddClass("BattlepassRewardLabelLocked");
				reward_label_locked.text = $.Localize("battlepass_reward_locked") + $.Localize("#battlepass_" + "\n" +  BattlepassRewards[i]);
			}
		}
	}
}

function GenerateCompanionPanel(companions, player, panel, retainSubTab) {
	var i_count = 0;
	var class_option_count = 1;

	var donator_row = $.CreatePanel("Panel", $('#' + panel + 'TableWrapper'), "DonatorRow" + class_option_count + "_" + player);
	donator_row.AddClass("DonatorRow");

	// Companion Generator
	var plyData = CustomNetTables.GetTableValue("player_table", Players.GetLocalPlayer());

	/*
	 * if (plyData.companion_enabled == 1) { if
	 * ($("#DonatorOptionsToggle").BHasClass("companion_disabled")) {
	 * $("#DonatorOptionsToggle").RemoveClass("companion_disabled") }
	 * $("#DonatorOptionsToggle").AddClass("companion_enabled")
	 * $("#DonatorOptionsToggleLabel").text = $.Localize("#companion_enabled") }
	 * else { if ($("#DonatorOptionsToggle").BHasClass("companion_enabled")) {
	 * $("#DonatorOptionsToggle").RemoveClass("companion_enabled") }
	 * $("#DonatorOptionsToggle").AddClass("companion_disabled")
	 * $("#DonatorOptionsToggleLabel").text = $.Localize("#companion_disabled") }
	 */

	var companion_unit = [];
	var companion_name = [];
	var companion_id = [];
	var companion_skin = [];

	// +1 for unique companion (e.g: cookies, baumi,
	// bulldog, icefrog)
	for (var i = 0; i <= companions.length; i++) {
		var newbie = false;
		var vip = false;
		i_count = i_count + 1;

		if (i == companions.length - 1) {
			newbie = true;
		}

		if (companions[i] != undefined) {
			companion_unit[i] = companions[i].file;
			companion_name[i] = companions[i].name;
			companion_id[i] = companions[i].id;
			if (companions[i].file == "npc_imba_donator_companion_sappling")
				companion_skin[i] = 3;
		} else {
			var steamId = Game.GetLocalPlayerInfo().player_steamid;
			if (steamId == "76561198015161808") {
				companion_unit[i] = "npc_imba_donator_companion_cookies";
				vip = true;
			} else if (steamId == "76561198003571172") {
				companion_unit[i] = "npc_imba_donator_companion_baumi";
				vip = true;
			} else if (steamId == "76561198014254115") {
				companion_unit[i] = "npc_imba_donator_companion_icefrog";
				vip = true;
			} else if (steamId == "76561198003571172") {
				companion_unit[i] = "npc_imba_donator_companion_admiral_bulldog";
				vip = true;
			} else if (steamId == "76561198021465788") {
				companion_unit[i] = "npc_imba_donator_companion_suthernfriend";
				vip = true;
			} else {
				return;
			}

			companion_name[i] = $.Localize(companion_unit[i]);
		}

		if (i_count > 5) {
			class_option_count = class_option_count + 1;
			var donator_row = $.CreatePanel("Panel", $('#' + panel + 'TableWrapper'), panel + "Row" + class_option_count + "_" + player);
			donator_row.AddClass("DonatorRow");
			i_count = 0;
		}

		var companion = $.CreatePanel("Panel", donator_row, companion_name[i]);
		companion.AddClass("DonatorReward");

		var companionpreview = $.CreatePanel("Button", companion, "CompanionPreview_" + i);
		companionpreview.style.width = "132px";
		companionpreview.style.height = "135px";
		companionpreview.BLoadLayoutFromString('<root><Panel><DOTAScenePanel style="width:100%; height:153px; margin-top: -45px;" particleonly="false" unit="' + companion_unit[i.toString()] + '"/></Panel></root>', false, false);
		companionpreview.style.opacityMask = 'url("s2r://panorama/images/masks/hero_model_opacity_mask_png.vtex");'
/*
		var companionskin = $.CreatePanel("Panel", companionpreview, "CompanionSkinPanel_" + i);
		companionskin.style.width = "100%";
		companionskin.style.height = "25px";
		companionskin.style.align = "center bottom";
		companionskin.style.flowChildren = "right";

		for (var j = 0; j <= companion_skin[i]; j++) {
			var companionskinbutton = $.CreatePanel("Button", companionskin, "CompanionSkin_" + i + "_" + j);
			companionskinbutton.style.width = "20%";
			companionskinbutton.style.height = "25px";
			companionskinbutton.style.margin = "1px";
			companionskinbutton.style.align = "center bottom";
			companionskinbutton.style.zIndex = "100";
			companionskinbutton.style.backgroundColor = "grey";
			var event = function(unit, j) {
				return function() {
					CompanionSkin(unit, j);
				}
			};
			companionskinbutton.SetPanelEvent("onactivate", event(companion_unit_name, j));

			var label = $.CreatePanel("Label", companionskinbutton, companion_name[i] + "_label");
			label.text = j + 1;

			label.style.horizontalAlign = "left";
			label.style.fontSize = "12px";
			label.style.verticalAlign = "top";
			label.style.letterSpacing = "1px";
			label.style.align = "center center";
			label.style.textTransform = "uppercase";
			label.style.textAlign = "center center";
			label.style.textShadow = "0px 0px 3px 3 #00000070";
			label.style.color = "#99a8ad";
			label.style.width = "100%";
		}
*/
		if (newbie == true) {
			companionpreview.AddClass("CompanionNew");
		}

		if (vip == true) {
			companionpreview.AddClass("CompanionUnique");
		}

		var companion_unit_name = companion_unit[i];

		/*
		 * This is weird. Seams like panorama v8 has a bug here.
		 * companion_unit_name should be copy-by-value but instead is
		 * copy-by-reference
		 */

		if (panel == "Companion") {
			var event = function(ev, name, id) {
				return function() {
					SetCompanion(ev, name, id);
				}
			};
		} else if (panel == "Statue") {
			var event = function(ev, name, id) {
				return function() {
					SetStatue(ev, name, id);
				}
			};
		}

		companionpreview.SetPanelEvent("onactivate", event(companion_unit_name, companion_name[i], companion_id[i]));

		var reward_label = $.CreatePanel("Label", companion, companion_name[i] + "_label");
		reward_label.AddClass("BattlepassRewardLabel");
		reward_label.text = companion_name[i];

		if (!retainSubTab) {
			SwitchDonatorWrapper(panel);
		}
	}
}

function CompanionSkin(unit, j) {
	$.Msg(unit, j)
	GameEvents.SendCustomGameEventToServer("change_companion_skin", {
		ID : Players.GetLocalPlayer(),
		unit : unit,
		skin : j
	})
}

function ToggleCompanion() {
	if ($("#CompanionNotification").BHasClass("not_donator")) {
		$("#CompanionNotification").RemoveClass("not_donator");
	}

	// check if player is donator; otherwise show advertisement
	if (IsDonator(Game.GetLocalPlayerID()) == false) {
		$("#CompanionNotification").AddClass("not_donator");
		$("#CompanionNotificationLabel").text = $.Localize("companion_not_donator");
		return;
	}

	$.AsyncWebRequest(url, {
		type : 'POST',
		success : function(d) {
			companions = d.data;
			$.Msg("Companion Api Good: " + JSON.stringify(d));
			$("#CompanionNotification").AddClass("success");
			$("#CompanionNotificationLabel").text = $.Localize("companion_success") + $.Localize(name) + "!";
			GameEvents.SendCustomGameEventToServer("change_companion", {
				ID : Players.GetLocalPlayer(),
				unit : companion
			});
			$.Schedule(6.0, function() {
				$("#CompanionNotification").RemoveClass("success");
			});
		},
		data : data,
		error : function(err) {
			$.Msg("Companion Api Error: " + JSON.stringify(err));
			$("#CompanionNotification").AddClass("failure");
			$("#CompanionNotificationLabel").text = $.Localize("companion_error");
			$.Schedule(6.0, function() {
				$("#CompanionNotification").RemoveClass("failure");
			});
		}
	});
}

(function() {
	// Update the game options display
	var bounty_multiplier = CustomNetTables.GetTableValue("game_options", "bounty_multiplier");
	var exp_multiplier = CustomNetTables.GetTableValue("game_options", "exp_multiplier");
	var initial_gold = CustomNetTables.GetTableValue("game_options", "initial_gold");
	var initial_level = CustomNetTables.GetTableValue("game_options", "initial_level");
	var max_level = CustomNetTables.GetTableValue("game_options", "max_level");
	var frantic_mode = CustomNetTables.GetTableValue("game_options", "frantic_mode");
	var gold_tick = CustomNetTables.GetTableValue("game_options", "gold_tick");

	$("#BountyMultiplierValue").text = bounty_multiplier[1] + "%";
	$("#ExpMultiplierValue").text = exp_multiplier[1] + "%";
	$("#InitialGoldValue").text = initial_gold[1];
	$("#InitialLevelValue").text = initial_level[1];
	$("#MaxLevelValue").text = max_level[1];
	$("#GoldTickValue").text = gold_tick[1].toFixed(1);

	GameEvents.Subscribe("hall_of_fame", HallOfFame);
	GameEvents.Subscribe("safe_to_leave", SafeToLeave);
})();
