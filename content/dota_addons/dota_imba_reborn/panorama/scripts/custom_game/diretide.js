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

(function()
{
	GameEvents.Subscribe("countdown", UpdateTimer);
	GameEvents.Subscribe("update_score", UpdateScoreUI);
	GameEvents.Subscribe("diretide_phase", Phase);
	GameEvents.Subscribe("roshan_target", RoshanTarget);
	GameEvents.Subscribe("diretide_player_reconnected", OnPlayerReconnect);
})();
