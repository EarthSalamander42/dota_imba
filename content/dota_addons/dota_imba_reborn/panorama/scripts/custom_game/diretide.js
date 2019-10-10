"use strict";

var JS_PHASE = 0
var playerPanels = {};
var Parent = $.GetContextPanel().GetParent().GetParent().GetParent()
var hudElements = Parent.FindChildTraverse("HUDElements");

function UpdateTimer( data )
{
	var timerText = "";
	timerText += data.timer_minute_10;
	timerText += data.timer_minute_01;
	timerText += ":";
	timerText += data.timer_second_10;
	timerText += data.timer_second_01;

	$( "#Timer" ).text = timerText;
	$( "#Timer_alt" ).text = timerText;
}

function OnUIUpdated(table_name, key, data)
{
	UpdateScoreUI();
}
CustomNetTables.SubscribeNetTableListener("game_options", OnUIUpdated)

function UpdateScoreUI()
{
	var RadiantScore = CustomNetTables.GetTableValue("game_options", "radiant").score;
	var DireScore = CustomNetTables.GetTableValue("game_options", "dire").score;

	$("#RadiantScoreText").SetDialogVariableInt("radiant_score", RadiantScore);
	$("#RadiantScoreText").text = RadiantScore;

	$("#DireScoreText").SetDialogVariableInt("dire_score", DireScore);
	$("#DireScoreText").text = DireScore;

	var RoshanTable = CustomNetTables.GetTableValue("game_options", "roshan");
	if (JS_PHASE == 3)
	{
		if (RoshanTable !== null)
		{
			var RoshanHP = RoshanTable.HP;
			var RoshanHP_percent = RoshanTable.HP_alt;
			var RoshanMaxHP = RoshanTable.maxHP;
			var RoshanLvl = RoshanTable.level;
			$("#RoshanProgressBar").value = RoshanHP_percent / 100;

			$("#RoshanHealth").text = RoshanHP + "/" + RoshanMaxHP;
			$("#RoshanLevel").text = "Level: " + RoshanLvl;
		}
	}
}

function Phase(args)
{
	$("#PhaseLabel").text = $.Localize("#diretide_phase_" + args.Phase);
	JS_PHASE = args.Phase

	$.Msg(args.Phase)

	if (args.Phase == 1)
	{
		$("#Diretide").style.visibility = "visible";
		$("#Diretide2").style.visibility = "visible";
		//Chat
		var Chat = hudElements.FindChildTraverse("HudChat");
		if (Chat != undefined) {
			Chat.style.marginBottom = "11%";
//			Chat.style.width = "35%";
//			Chat.FindChildTraverse("ChatControls").style.opacity = "1";
			Chat.style.zIndex = "10";
		}

		//Channel Bar
		var ChannelBar = Parent.FindChildTraverse("ChannelBar");
		ChannelBar.style.zIndex = "10";
	}
	if (args.Phase == 2)
	{
		$('#ScorePanel').MoveChildBefore($('#Timer'), $('#Roshan'));
		$("#RoshanTarget").style.visibility = "visible";
	}
	else if (args.Phase == 3)
	{
		$("#Diretide2").style.visibility = "collapse";
		$("#RoshanHP").style.visibility = "visible";
	}
}

function RoshanTarget(args)
{
	$("#RoshanTarget").text = $.Localize(args.target);
	if (args.team_target == 2)
	{
		$("#RoshanTarget").style.color = "green";
	}
	else if (args.team_target == 3)
	{
		$("#RoshanTarget").style.color = "red";
	}
}

function DiretideInfo()
{
	$.DispatchEvent("UIShowTextTooltip", $("#PhaseLabel"), $.Localize("#diretide_phase_" + JS_PHASE + "_desc"));
}

function OnPlayerReconnect( data ) {
	$.Msg("DIRETIDE: Player has reconnected!")
	var phase = data.Phase;
	$.Msg("Phase: " + phase)
}

var secret_key = CustomNetTables.GetTableValue("game_options", "server_key")["1"];

var api = {
	base : "http://api.dota2imba.fr/",
	urls : {
		rankingsXp : "website/statistics/ranking/xp",
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
};

var current_type = "";
var top_xp = [];

function HallOfFame(type) {
	var leaderboard_container = $("#LeaderboardInfoContainer");
	leaderboard_container.style.visibility = "visible";

	var type = "XP";

	if (current_type == type) {
//		$.Msg("Bro don't reload you're fine!");
		return;
	}

	$.Msg(top_xp)

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

	for (var i = 1; i <= 10; i++) {
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

(function()
{
	api.getTopPlayerXP(function(players) {
		$.Msg(players)
		for (var player in players) {
			top_xp[player] = players[player];
		}
	});

	GameEvents.Subscribe("countdown", UpdateTimer);
	GameEvents.Subscribe("update_score", UpdateScoreUI);
	GameEvents.Subscribe("diretide_phase", Phase);
	GameEvents.Subscribe("roshan_target", RoshanTarget);
	GameEvents.Subscribe("diretide_player_reconnected", OnPlayerReconnect);
	GameEvents.Subscribe("hall_of_fame", HallOfFame);
})();
