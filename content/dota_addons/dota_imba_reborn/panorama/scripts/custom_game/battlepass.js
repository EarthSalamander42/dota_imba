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

var secret_key = CustomNetTables.GetTableValue("game_options", "server_key")["1"];

var api = {
	base : "http://api.dota2imba.fr/",
	urls : {
		modifyCompanion : "imba/modify-companion",
		modifyStatue : "imba/modify-statue",
		modifyEmblem : "imba/modify-emblem",
//		rankingsImr5v5 : "imba/meta/rankings/imr-5v5",
//		rankingsImr10v10 : "imba/meta/rankings/imr-10v10",
		rankingsXp : "website/statistics/ranking/xp",
		rankingsWinrate : "website/statistics/ranking/winrate",
//		rankingsLevel1v1 : "imba/meta/rankings/level-1v1",
		toggleIngameTag : "imba/toggle-ingame-tag",
		toggleBPRewards : "imba/toggle-bp-rewards",
		togglePlayerXP : "imba/toggle-player-xp",
		toggleWinrate : "imba/toggle-winrate",
	},
	updateCompanion : function(data, success_callback, error_callback) {
		$.AsyncWebRequest(api.base + api.urls.modifyCompanion, {
			type : "POST",
			dataType : "json",
			data : data,
			timeout : 5000,
			headers : {'X-Dota-Server-Key' : secret_key},
			success : function(obj) {
				if (obj.error) {
//					$.Msg("Error updating companion");
					error_callback();
				} else {
//					$.Msg("Updated companion");
					success_callback();
				}
			},
			error : function(err) {
//				$.Msg("Error updating companion" + JSON.stringify(err));
				error_callback();
			}
		});
	},
	updateStatue : function(data, success_callback, error_callback) {
		$.AsyncWebRequest(api.base + api.urls.modifyStatue, {
			type : "POST",
			dataType : "json",
			data : data,
			timeout : 5000,
			headers : {'X-Dota-Server-Key' : secret_key},
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
	},
	updateEmblem : function(data, success_callback, error_callback) {
		$.AsyncWebRequest(api.base + api.urls.modifyEmblem, {
			type : "POST",
			dataType : "json",
			data : data,
			timeout : 5000,
			headers : {'X-Dota-Server-Key' : secret_key},
			success : function(obj) {
				if (obj.error) {
					$.Msg("Error updating emblem");
					error_callback();
				} else {
					$.Msg("Updated emblem");
					success_callback();
				}
			},
			error : function(err) {
				$.Msg("Error updating emblem " + JSON.stringify(err));
				error_callback();
			}
		});
	},
	getTopPlayerXP : function(callback) {
		$.AsyncWebRequest(api.base + api.urls.rankingsXp, {
			type : "GET",
			dataType : "json",
			timeout : 5000,
			headers : {'X-Dota-Server-Key' : secret_key},
			success : function(obj) {
				if (obj.error || !obj.data || !obj.data.players)
					$.Msg("Error finding top xp");
				else {
					callback(obj.data.players);
				}
			},
			error : function(err) {
				$.Msg("Error finding top xp " + JSON.stringify(err));
			}
		});
	},
	getTopPlayerWinrate : function(callback) {
		$.AsyncWebRequest(api.base + api.urls.rankingsWinrate, {
			type : "GET",
			dataType : "json",
			timeout : 5000,
			headers : {'X-Dota-Server-Key' : secret_key},
			success : function(obj) {
				if (obj.error || !obj.data || !obj.data)
					$.Msg("Error finding top winrate");
				else {
					callback(obj.data);
				}
			},
			error : function(err) {
				$.Msg("Error finding top winrate " + JSON.stringify(err));
			}
		});
	},
	updateIngameTag : function(data, success_callback, error_callback) {
		$.AsyncWebRequest(api.base + api.urls.toggleIngameTag, {
			type : "POST",
			dataType : "json",
			data : data,
			timeout : 5000,
			headers : {'X-Dota-Server-Key' : secret_key},
			success : function(obj) {
//				$.Msg(obj)
				if (obj.error) {
					$.Msg("Error updating ingame tag");
					error_callback();
				} else {
					$.Msg("Updated ingame tag");
					success_callback();
				}
			},
			error : function(err) {
				$.Msg("Error ingame tag " + JSON.stringify(err));
				error_callback();
			}
		});
	},
	updateBPRewards : function(data, success_callback, error_callback) {
		$.AsyncWebRequest(api.base + api.urls.toggleBPRewards, {
			type : "POST",
			dataType : "json",
			data : data,
			timeout : 5000,
			headers : {'X-Dota-Server-Key' : secret_key},
			success : function(obj) {
//				$.Msg(obj)
				if (obj.error) {
					$.Msg("Error updating bp rewards");
					error_callback();
				} else {
					$.Msg("Updated bp rewards");
					success_callback();
				}
			},
			error : function(err) {
				$.Msg("Error bp rewards " + JSON.stringify(err));
				error_callback();
			}
		});
	},
	updatePlayerXP : function(data, success_callback, error_callback) {
		$.AsyncWebRequest(api.base + api.urls.togglePlayerXP, {
			type : "POST",
			dataType : "json",
			data : data,
			timeout : 5000,
			headers : {'X-Dota-Server-Key' : secret_key},
			success : function(obj) {
//				$.Msg(obj)
				if (obj.error) {
					$.Msg("Error updating ply xp");
					error_callback();
				} else {
					$.Msg("Updated ply xp");
					success_callback();
				}
			},
			error : function(err) {
				$.Msg("Error ply xp " + JSON.stringify(err));
				error_callback();
			}
		});
	},
	updateWinrate : function(data, success_callback, error_callback) {
		$.AsyncWebRequest(api.base + api.urls.toggleWinrate, {
			type : "POST",
			dataType : "json",
			data : data,
			timeout : 5000,
			headers : {'X-Dota-Server-Key' : secret_key},
			success : function(obj) {
//				$.Msg(obj)
				if (obj.error) {
					$.Msg("Error updating winrate");
					error_callback();
				} else {
					$.Msg("Updated winrate");
					success_callback();
				}
			},
			error : function(err) {
				$.Msg("Error winrate " + JSON.stringify(err));
				error_callback();
			}
		});
	},
};

function ToggleBattlepass() {
	if (toggle === false) {
		toggle = true;
		if (first_time === false) {
			first_time = true;
			Battlepass();
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

function RefreshBattlepass(bRewardsDisabled) {
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

	var emblem_childrens = $("#EmblemTableWrapper").FindChildrenWithClassTraverse("DonatorRow");
	emblem_childrens.forEach(function(e) {
		e.DeleteAsync(0);
	});

	$("#RefreshBattlepass").AddClass("Active");

	$("#RefreshBattlepass").RemoveClass("Active");
	if (current_sub_tab != "") {
		Battlepass(true, bRewardsDisabled);
	} else {
		Battlepass(false, bRewardsDisabled);
	}		
}

function SwitchTab(tab) {
	$("#BattlepassInfoContainer").style.visibility = "collapse";
	$("#DonatorInfoContainer").style.visibility = "collapse";
	$("#LeaderboardInfoContainer").style.visibility = "collapse";
	$("#SettingsInfoContainer").style.visibility = "collapse";

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
	$("#EmblemTableWrapper").style.visibility = "collapse";
//	$("#PatreonTabButton").RemoveClass('active');
	$("#CompanionTabButton").RemoveClass('active');
	$("#StatueTabButton").RemoveClass('active');
	$("#EmblemTabButton").RemoveClass('active');

	$("#" + type + "TableWrapper").style.visibility = "visible";
	$("#" + type + "TabButton").AddClass('active');

	$('#DonatorTabTitle').text = $.Localize("#donator_" + type.toLowerCase() + "_wrapper_label").toUpperCase();
}

var top_xp = [];
var top_winrate = [];

function Battlepass(retainSubTab, bRewardsDisabled) {
	if (typeof retainSubTab == "undefined") {retainSubTab = false;};
	var BattlepassRewards = CustomNetTables.GetTableValue("game_options", "battlepass").battlepass;

	api.getTopPlayerXP(function(players) {
		for (player in players) {
			top_xp[player] = players[player];
		}

		HallOfFame("XP");
	});

	api.getTopPlayerWinrate(function(players) {
		for (player in players) {
			top_winrate[player] = players[player];
		}
	});

	GenerateBattlepassPanel(BattlepassRewards, Players.GetLocalPlayer(), bRewardsDisabled);

	var companions = CustomNetTables.GetTableValue("battlepass", "companions");
	if (companions != undefined)
		GenerateCompanionPanel(companions["1"], Players.GetLocalPlayer(), "Companion", retainSubTab);
/* weird whitespace issue, need investigation
	var statues = CustomNetTables.GetTableValue("battlepass", "statues");
	if (statues != undefined)
		GenerateCompanionPanel(statues["1"], Players.GetLocalPlayer(), "Statue", retainSubTab);

	var emblems = CustomNetTables.GetTableValue("battlepass", "emblems");
	if (emblems != undefined)
		GenerateCompanionPanel(emblems["1"], Players.GetLocalPlayer(), "Emblem", retainSubTab);
*/
	SetupPanel();
}

var companion_changed = false;

function SetCompanion(companion, name, id, required_status) {
	if (companion_changed === true) {
//		$.Msg("SLOW DOWN BUDDY!");
		return;
	}

	if ($("#CompanionNotification").BHasClass("not_donator")) {
		$("#CompanionNotification").RemoveClass("not_donator");
	}

	var donator_status = IsDonator(Game.GetLocalPlayerID());

	if (IsDonator(Game.GetLocalPlayerID()) === false) {
		$("#CompanionNotification").AddClass("not_donator");
		$("#CompanionNotificationLabel").text = $.Localize("companion_not_donator");
		return;
	}

//	$.Msg(DonatorStatusConverter(donator_status))
//	$.Msg(required_status)
	if (DonatorStatusConverter(donator_status) < required_status) {
		$("#CompanionNotification").AddClass("not_donator");
		$("#CompanionNotificationLabel").text = "Your donator status is too low. Required status: (" + $.Localize("donator_label_" + DonatorStatusConverterReverse(required_status)) + ")";
		return;
	}

//	$.Msg("POST modify companion:")
//	$.Msg(id)
//	$.Msg(Game.GetLocalPlayerInfo().player_steamid)

	api.updateCompanion({
		companion_id : id,
		steamid : Game.GetLocalPlayerInfo().player_steamid,
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
//		$.Msg("SLOW DOWN BUDDY!");
		return;
	}

	if ($("#CompanionNotification").BHasClass("not_donator")) {
		$("#CompanionNotification").RemoveClass("not_donator");
	}

	var donator_status = IsDonator(Game.GetLocalPlayerID());

	if (IsDonator(Game.GetLocalPlayerID()) === false) {
		$("#CompanionNotification").AddClass("not_donator");
		$("#CompanionNotificationLabel").text = $.Localize("companion_not_donator");
		return;
	}

	if (DonatorStatusConverter(donator_status) < required_status) {
		$("#CompanionNotification").AddClass("not_donator");
		$("#CompanionNotificationLabel").text = "Your donator status is too low. Required status: (" + $.Localize("donator_label_" + DonatorStatusConverterReverse(required_status)) + ")";
		return;
	}

	api.updateStatue({
		statue_id : id,
		steamid : Game.GetLocalPlayerInfo().player_steamid,
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

function SetEmblem(emblem, name, id, required_status) {
	if (companion_changed === true) {
//		$.Msg("SLOW DOWN BUDDY!");
		return;
	}

	if ($("#CompanionNotification").BHasClass("not_donator")) {
		$("#CompanionNotification").RemoveClass("not_donator");
	}

	var donator_status = IsDonator(Game.GetLocalPlayerID());

	if (IsDonator(Game.GetLocalPlayerID()) === false) {
		$("#CompanionNotification").AddClass("not_donator");
		$("#CompanionNotificationLabel").text = $.Localize("companion_not_donator");
		return;
	}

//	$.Msg(DonatorStatusConverter(donator_status))
//	$.Msg(required_status)
	if (DonatorStatusConverter(donator_status) < required_status) {
		$("#CompanionNotification").AddClass("not_donator");
		$("#CompanionNotificationLabel").text = "Your donator status is too low. Required status: (" + $.Localize("donator_label_" + DonatorStatusConverterReverse(required_status)) + ")";
		return;
	}

	api.updateEmblem({
		emblem_id : id,
		steamid : Game.GetLocalPlayerInfo().player_steamid,
	}, function() {
		$("#CompanionNotification").AddClass("success");
		$("#CompanionNotificationLabel").text = $.Localize("emblem_success") + $.Localize(name) + "!";
		GameEvents.SendCustomGameEventToServer("change_emblem", {
			ID : Players.GetLocalPlayer(),
			unit : emblem
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

	// temporary, implement in the for loop later
	// local player stats
	var plyData = CustomNetTables.GetTableValue("battlepass", Players.GetLocalPlayer());
	$.Msg(plyData)

	var player = $.CreatePanel("Panel", $('#LocalPlayerInfo'), "player_local");
	player.AddClass("LeaderboardGames");
	var rank = $.CreatePanel("Label", player, "rank_local");
	rank.AddClass("LeaderboardRank");
	rank.text = "--"; // add winrate rank oaeide!

	var steam_id = $.CreatePanel("DOTAAvatarImage", player, "player_steamid_" + i);
	steam_id.AddClass("LeaderboardAvatar");
	steam_id.steamid = Game.GetLocalPlayerInfo().player_steamid;
	steam_id.style.width = "38px";
	steam_id.style.height = "38px";
	steam_id.style.marginLeft = "40px";
	steam_id.style.marginRight = "40px";
	steam_id.style.align = "center center";

	var imbar_container = $.CreatePanel("Panel", player, "imbar_container_local");
	imbar_container.AddClass("LeaderboardXP");
	var imbar = $.CreatePanel("ProgressBar", imbar_container, "imbar_local");
	imbar.AddClass("imbar-progress-bar");
	imbar.value = parseFloat(plyData.XP / plyData.MaxXP);

	var imbar_lvl = $.CreatePanel("Label", imbar_container, "imbar_lvl_local");
	imbar_lvl.AddClass("imbar-lvl");
	imbar_lvl.text = "Level: " + plyData.Lvl;

	var imbar_rank_wrapper = $.CreatePanel("Panel", imbar_container, "imbar_rank_local");
	imbar_rank_wrapper.AddClass("imbar-rank-wrapper");

	var imbar_rank_circle = $.CreatePanel("Panel", imbar_rank_wrapper, "");
	imbar_rank_circle.AddClass("imbar-rank-cicle");
	imbar_rank_circle.style.backgroundColor = "white";
//	imbar_rank_circle.style.backgroundColor = top_users.title_color;

	var imbar_rank = $.CreatePanel("Label", imbar_rank_wrapper, "");
	imbar_rank.AddClass("imbar-rank");
	imbar_rank.text = plyData.title;

//	var imbar_xp = $.CreatePanel("Label", imbar_container, "imbar_xp" + i);
//	imbar_xp.AddClass("imbar-xp");
//	imbar_xp.text = top_users.XP + "/" + top_users.MaxXP;

	var imr = $.CreatePanel("Label", player, "rank_local");
	imr.AddClass("LeaderboardIMR");

	// temporary
	if (type == "IMR") {
		imr.text = plyData.win_percentage;
	} else {
		imr.text = 0;
	}

	for (var i = 1; i <= 100; i++) {
		if (type == "XP") {
			var top_users = top_xp;
		} else if (type == "IMR") {
			var top_users = top_winrate;
		}

		if (top_users === undefined) {
			$.Msg("Top Players not defined...")
			return;
		}

		if (!top_users[i - 1])
			return;

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
		steam_id.steamid = top_users[i - 1].steamid;
		steam_id.style.width = "38px";
		steam_id.style.height = "38px";
		steam_id.style.marginLeft = "40px";
		steam_id.style.marginRight = "40px";
		steam_id.style.align = "center center";

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

//		if (top_users[i - 1].donator_level)
//			steam_id.style.border = "2px solid " + leaderboard_border[top_users.donator_level];
//			steam_id.style.border = "2px solid " + leaderboard_border[i];
//		else
//			steam_id.style.border = "2px solid #3f464ecc";

		var imbar_container = $.CreatePanel("Panel", player, "imbar_container_" + i);
		imbar_container.AddClass("LeaderboardXP");
		var imbar = $.CreatePanel("ProgressBar", imbar_container, "imbar_" + i);
		imbar.AddClass("imbar-progress-bar");
		imbar.value = parseFloat(top_users[i - 1].next_level_progress) / 100;

		var imbar_lvl = $.CreatePanel("Label", imbar_container, "imbar_lvl" + i);
		imbar_lvl.AddClass("imbar-lvl");
		imbar_lvl.text = "Level: " + top_users[i - 1].xp_level;

		var imbar_rank_wrapper = $.CreatePanel("Panel", imbar_container, "imbar_rank" + i);
		imbar_rank_wrapper.AddClass("imbar-rank-wrapper");

		var imbar_rank_circle = $.CreatePanel("Panel", imbar_rank_wrapper, "");
		imbar_rank_circle.AddClass("imbar-rank-cicle");
		imbar_rank_circle.style.backgroundColor = "white";
//		imbar_rank_circle.style.backgroundColor = top_users.title_color;

		var imbar_rank = $.CreatePanel("Label", imbar_rank_wrapper, "");
		imbar_rank.AddClass("imbar-rank");
		imbar_rank.text = top_users[i - 1].rank_title;

//		var imbar_xp = $.CreatePanel("Label", imbar_container, "imbar_xp" + i);
//		imbar_xp.AddClass("imbar-xp");
//		imbar_xp.text = top_users.XP + "/" + top_users.MaxXP;

		var imr = $.CreatePanel("Label", player, "rank_" + i);
		imr.AddClass("LeaderboardIMR");

		// temporary
		if (type == "IMR") {
			imr.text = top_users[i - 1].win_percentage;
		} else {
			imr.text = 0;
		}
	}
}

function SafeToLeave() {
	$("#SafeToLeave").style.visibility = "visible";
}

function GenerateBattlepassPanel(BattlepassRewards, player, bRewardsDisabled) {
	var i_count = 0;
	var class_option_count = 1;
	var plyData = CustomNetTables.GetTableValue("battlepass", player);

	var reward_row = $.CreatePanel("Panel", $('#BattlepassInfoContainer'), "BattlepassRow" + class_option_count + "_" + player);
	reward_row.AddClass("BattlepassRow");

	for (var i = 1; i <= 500; i++) {
		if (BattlepassRewards[i] != undefined) {
			var bp_reward = BattlepassRewards[i][1];
			var bp_rarity = BattlepassRewards[i][2];
			i_count++;

			if (i_count > 10) {
				class_option_count = class_option_count + 1;
				var reward_row = $.CreatePanel("Panel", $('#BattlepassInfoContainer'), "BattlepassRow" + class_option_count + "_" + player);
				reward_row.AddClass("BattlepassRow");
				i_count = 1;
			}

			var reward = $.CreatePanel("Panel", $("#BattlepassRow" + class_option_count + "_" + player), bp_reward);
			reward.AddClass("BattlepassReward");
			var reward_icon = $.CreatePanel("Panel", reward, bp_reward + "_icon");
			reward_icon.style.backgroundImage = 'url("file://{images}/custom_game/battlepass/' + bp_reward + '.png")';
			reward_icon.AddClass("BattlepassRewardIcon");
			reward_icon.AddClass(bp_rarity + "_border");

			var reward_label = $.CreatePanel("Label", reward, bp_reward + "_label");
			reward_label.AddClass("BattlepassRewardLabel");
			reward_label.text = $.Localize("battlepass_level") + i;
			reward_label.AddClass(bp_rarity + "_text");

			var hero_name = bp_reward.replace("_arcana", "").replace("_immortal", "").replace("_mythical", "").replace("_rare", "").replace("2", "");
			// WARNING: The following line is NSFW. Later on use GetTableValue("battlepass", "hero_name")
			if (hero_name == "axe" || hero_name == "bristleback" || hero_name == "centaur" || hero_name == "chen" || hero_name == "dark_seer" || hero_name == "death_prophet" || hero_name == "drow_ranger" || hero_name == "earthshaker" || hero_name == "enigma" || hero_name == "huskar" || hero_name == "juggernaut" || hero_name == "leshrac" || hero_name == "life_stealer" || hero_name == "lina" || hero_name == "nyx_assassin" || hero_name == "pudge" || hero_name == "skywrath_mage" || hero_name == "vengefulspirit" || hero_name == "wisp" || hero_name == "zuus") {
				var reward_hero_icon = $.CreatePanel("Panel", reward_icon, bp_reward + "_icon");
				reward_hero_icon.style.backgroundImage = 'url("file://{images}/heroes/icons/npc_dota_hero_' + hero_name + '.png")';
				reward_hero_icon.AddClass("BattlepassRewardHeroIcon");
			}

			if (plyData != null || bRewardsDisabled & bRewardsDisabled == true) {
				if (i <= plyData.Lvl) {
					var reward_panel_unlocked = $.CreatePanel("Panel", reward_icon, bp_reward + "_panel_unlock");
					reward_panel_unlocked.AddClass("BattlepassRewardPanelUnlocked");
					reward_label.AddClass("unlocked");

					var reward_label_unlocked = $.CreatePanel("Label", reward_panel_unlocked, bp_reward + "_label");
					reward_label_unlocked.AddClass("BattlepassRewardLabelUnlocked");
					reward_label_unlocked.text = $.Localize("#battlepass_" + bp_reward);
				} else {
					reward_label.AddClass("locked");
					reward_icon.AddClass("BattlepassRewardIcon_locked")
					var reward_label_locked = $.CreatePanel("Label", reward_icon, bp_reward + "_label");
					reward_label_locked.AddClass("BattlepassRewardLabelLocked");
					reward_label_locked.text = $.Localize("battlepass_reward_locked") + $.Localize("#battlepass_" + bp_reward);
				}
			} else {
				reward_icon.AddClass("BattlepassRewardIcon_locked")
				var reward_label_locked = $.CreatePanel("Label", reward_icon, bp_reward + "_label");
				reward_label_locked.AddClass("BattlepassRewardLabelLocked");
				reward_label_locked.text = $.Localize("battlepass_reward_locked") + $.Localize("#battlepass_" + bp_reward);
			}
		}
	}
}

function GenerateCompanionPanel(companions, player, panel, retainSubTab) {
	var i_count = 0;
	var class_option_count = 1;

//	$.Msg("List of available companions:")
//	$.Msg(companions)

	var donator_row = $.CreatePanel("Panel", $('#' + panel + 'TableWrapper'), "DonatorRow" + class_option_count + "_" + player);
	donator_row.AddClass("DonatorRow");

	// Companion Generator
	var plyData = CustomNetTables.GetTableValue("battlepass", Players.GetLocalPlayer());

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
	for (i in companions) {
		var vip = false;
		i_count = i_count + 1;
		if (companions[i] != undefined) {
			companion_unit[i] = companions[i]["file"];
			companion_id[i] = i;
			required_status = companions[i]["required_status"];

			if (i == 0) {
				companion_name[i] = "Disabled";
			}
			else
				companion_name[i] = companions[i]["name"];

			if (companion_unit[i] == "npc_donator_companion_sappling")
				companion_skin[i] = 3;
		}

		if (i_count > 5) {
			class_option_count = class_option_count + 1;
			var donator_row = $.CreatePanel("Panel", $('#' + panel + 'TableWrapper'), panel + "Row" + class_option_count + "_" + player);
			donator_row.AddClass("DonatorRow");
			i_count = 1;
		}

		var companion = $.CreatePanel("Panel", donator_row, companion_name[i]);
		companion.AddClass("DonatorReward");

		var companionpreview = $.CreatePanel("Button", companion, "CompanionPreview_" + i);
		companionpreview.style.width = "132px";
		companionpreview.style.height = "135px";

		companionpreview.style.backgroundImage = 'url("file://{images}/custom_game/flyout/donator_emblem_' + i + '.png")';
		companionpreview.BLoadLayoutFromString('<root><Panel><DOTAScenePanel style="width:100%; height:153px; margin-top: -45px;" particleonly="false" unit="' + companion_unit[i.toString()] + '"/></Panel></root>', false, false);
		companionpreview.style.opacityMask = 'url("s2r://panorama/images/masks/hero_model_opacity_mask_png.vtex");'

		var companion_unit_name = companion_unit[i];

		/*
		 * This is weird. Seams like panorama v8 has a bug here.
		 * companion_unit_name should be copy-by-value but instead is
		 * copy-by-reference
		 */

		if (panel == "Companion") {
			var event = function(ev, name, id, required_status) {
				return function() {
					SetCompanion(ev, name, id, required_status);
				}
			};
		} else if (panel == "Statue") {
			var event = function(ev, name, id, required_status) {
				return function() {
					SetStatue(ev, name, id, required_status);
				}
			};
		} else if (panel == "Emblem") {
			var event = function(ev, name, id, required_status) {
				return function() {
					SetEmblem(ev, name, id, required_status);
				}
			};
		}

		companionpreview.SetPanelEvent("onactivate", event(companion_unit_name, companion_name[i], companion_id[i], required_status));

		var reward_label = $.CreatePanel("Label", companion, companion_name[i] + "_label");
		reward_label.AddClass("BattlepassRewardLabel");
		reward_label.text = companion_name[i];

		if (required_status != undefined && required_status != 0) {
			if (GetDonatorColor(required_status))
				reward_label.style.color = GetDonatorColor(required_status);
			else
				$.Msg("Failed to give color for status " + required_status);
		}

		if (!retainSubTab) {
			SwitchDonatorWrapper(panel);
		}
	}
}

function CompanionSkin(unit, j) {
//	$.Msg(unit, j)
	GameEvents.SendCustomGameEventToServer("change_companion_skin", {
		ID : Players.GetLocalPlayer(),
		unit : unit,
		skin : j
	})
}

function SettingsIngameTag() {
	var tag = false;
	if (CustomNetTables.GetTableValue("battlepass", Players.GetLocalPlayer()).in_game_tag != undefined) {
		tag = CustomNetTables.GetTableValue("battlepass", Players.GetLocalPlayer()).in_game_tag

		if (tag == 1)
			tag = 0
		else
			tag = 1
	}

	api.updateIngameTag({
		steamid : Game.GetLocalPlayerInfo().player_steamid,
		in_game_tag : tag
	}, function() {
		GameEvents.SendCustomGameEventToServer("change_ingame_tag", {
			ID : Players.GetLocalPlayer(),
			tag : tag
		});
//		$.Msg("Ingame tag update: success!")
//		$.Schedule(6.0, function() {
//			$("#CompanionNotification").RemoveClass("success");
//			companion_changed = false;
//		});
	}, function() {
//		$.Msg("Ingame tag update: failure")
//		$("#CompanionNotification").AddClass("failure");
//		$("#CompanionNotificationLabel").text = $.Localize("companion_error");
//		$.Schedule(6.0, function() {
//			$("#CompanionNotification").RemoveClass("failure");
//			companion_changed = false;
//		});
	});
}

function SettingsBattlepassRewards() {
	var toggle_rewards = false;
//	$.Msg("BP Rewards :" + CustomNetTables.GetTableValue("battlepass", Players.GetLocalPlayer()).bp_rewards)
	if (CustomNetTables.GetTableValue("battlepass", Players.GetLocalPlayer()).bp_rewards != undefined) {
		toggle_rewards = CustomNetTables.GetTableValue("battlepass", Players.GetLocalPlayer()).bp_rewards
		if (toggle_rewards == 1)
			toggle_rewards = 0
		else
			toggle_rewards = 1
	}

//	$.Msg("BP Rewards :" + toggle_rewards)

	api.updateBPRewards({
		steamid : Game.GetLocalPlayerInfo().player_steamid,
		bp_rewards : toggle_rewards
	}, function() {
		GameEvents.SendCustomGameEventToServer("change_battlepass_rewards", {
			ID : Players.GetLocalPlayer(),
			bp_rewards : toggle_rewards
		});
		RefreshBattlepass(toggle_rewards);
//		$.Msg("BP rewards update: success!")
//		$.Schedule(6.0, function() {
//			$("#CompanionNotification").RemoveClass("success");
//			companion_changed = false;
//		});
	}, function() {
//		$.Msg("BP rewards update: failure")
//		$("#CompanionNotification").AddClass("failure");
//		$("#CompanionNotificationLabel").text = $.Localize("companion_error");
//		$.Schedule(6.0, function() {
//			$("#CompanionNotification").RemoveClass("failure");
//			companion_changed = false;
//		});
	});
}

function SettingsPlayerXP() {
	var toggle = false;
//	$.Msg("BP Rewards :" + CustomNetTables.GetTableValue("battlepass", Players.GetLocalPlayer()).player_xp)
	if (CustomNetTables.GetTableValue("battlepass", Players.GetLocalPlayer()).player_xp != undefined) {
		toggle = CustomNetTables.GetTableValue("battlepass", Players.GetLocalPlayer()).player_xp
		if (toggle == 1)
			toggle = 0
		else
			toggle = 1
	}

//	$.Msg("Player XP :" + toggle)

	api.updatePlayerXP({
		steamid : Game.GetLocalPlayerInfo().player_steamid,
		player_xp : toggle
	}, function() {
		GameEvents.SendCustomGameEventToServer("change_player_xp", {
			ID : Players.GetLocalPlayer(),
			player_xp : toggle
		});
//		$.Msg("Player XP update: success!")
//		$.Schedule(6.0, function() {
//			$("#CompanionNotification").RemoveClass("success");
//			companion_changed = false;
//		});
	}, function() {
//		$.Msg("Player XP update: failure")
//		$("#CompanionNotification").AddClass("failure");
//		$("#CompanionNotificationLabel").text = $.Localize("companion_error");
//		$.Schedule(6.0, function() {
//			$("#CompanionNotification").RemoveClass("failure");
//			companion_changed = false;
//		});
	});
}

function SettingsWinrate() {
	var toggle = false;
	$.Msg("BP Rewards :" + CustomNetTables.GetTableValue("battlepass", Players.GetLocalPlayer()).winrate_toggle)
	if (CustomNetTables.GetTableValue("battlepass", Players.GetLocalPlayer()).winrate_toggle != undefined) {
		toggle = CustomNetTables.GetTableValue("battlepass", Players.GetLocalPlayer()).winrate_toggle
		if (toggle == 1)
			toggle = 0
		else
			toggle = 1
	}

//	$.Msg("Player XP :" + toggle)

	api.updateWinrate({
		steamid : Game.GetLocalPlayerInfo().player_steamid,
		winrate : toggle
	}, function() {
		GameEvents.SendCustomGameEventToServer("change_winrate", {
			ID : Players.GetLocalPlayer(),
			player_xp : toggle
		});
	}, function() {
		$.Msg("Winrate update fail!")
	});
}

function SetupPanel() {
	var ply_table = CustomNetTables.GetTableValue("battlepass", Players.GetLocalPlayer());

//	$.Msg(ply_table.winrate_toggle)
	if (ply_table) {
		if (ply_table.in_game_tag)
			$("#IngameTagCheckBox").checked = ply_table.in_game_tag;
		if (ply_table.bp_rewards)
			$("#BPRewardsCheckBox").checked = ply_table.bp_rewards;
		if (ply_table.player_xp)
			$("#PlayerXPCheckBox").checked = ply_table.player_xp;
		if (ply_table.winrate_toggle)
			$("#WinrateCheckBox").checked = ply_table.winrate_toggle;
	}
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
