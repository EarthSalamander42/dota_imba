"use strict";

var roshan_phase_3 = false

function UpdateTimer( data )
{
	var timerText = "";
	timerText += data.timer_minute_10;
	timerText += data.timer_minute_01;
	timerText += ":";
	timerText += data.timer_second_10;
	timerText += data.timer_second_01;

	$( "#Timer" ).text = timerText;
}

function ShowTimer()
{
	$("#Diretide").style.visibility = "visible";
	$("#Diretide2").style.visibility = "visible";
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

	var RoshanTable = CustomNetTables.GetTableValue("game_options", "roshan_hp");

	if (roshan_phase_3 == true)
	{
		if (RoshanTable !== null)
		{
			var RoshanHP = RoshanTable.HP;
			var RoshanHP_percent = RoshanTable.HP_alt;
			var RoshanMaxHP = RoshanTable.maxHP;
			var RoshanLvl = RoshanTable.level;
			$("#RoshanProgressBar").value = RoshanHP / 100;

			$.Msg("Roshan HP: " + RoshanHP_percent / 100)
			$("#RoshanHealth").text = RoshanHP + "/" + RoshanMaxHP;
			$("#RoshanLevel").text = "Level: " + RoshanLvl;
		}
	}
}

function Phase(args)
{
	var Label = "#diretide_phase_" + args.Phase
	$("#PhaseLabel").text = Label;

	if (args.Phase == "3")
	{
		$.Msg("Phase 3!")
		roshan_phase_3 = true
		$("#RoshanHP").style.visibility = "visible";
	}
}

(function()
{
	GameEvents.Subscribe("countdown", UpdateTimer);
	GameEvents.Subscribe("update_score", UpdateScoreUI);
	GameEvents.Subscribe("show_timer", ShowTimer);
	GameEvents.Subscribe("diretide_phase", Phase);
})();
