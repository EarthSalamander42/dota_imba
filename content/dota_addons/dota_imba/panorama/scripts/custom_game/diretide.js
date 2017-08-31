"use strict";

function UpdateTimer( data )
{
	//$.Msg( "UpdateTimer: ", data );
	//var timerValue = Game.GetDOTATime( false, false );

	//var sec = Math.floor( timerValue % 60 );
	//var min = Math.floor( timerValue / 60 );

	//var timerText = "";
	//timerText += min;
	//timerText += ":";

	//if ( sec < 10 )
	//{
	//	timerText += "0";
	//}
	//timerText += sec;

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

	$.Msg("Radiant Score:", RadiantScore)
	$.Msg("Dire Score:", DireScore)

	$("#RadiantScoreText").SetDialogVariableInt("radiant_score", RadiantScore);
	$("#RadiantScoreText").text = RadiantScore;

	$("#DireScoreText").SetDialogVariableInt("dire_score", DireScore);
	$("#DireScoreText").text = DireScore;
}

(function()
{
	GameEvents.Subscribe( "countdown", UpdateTimer );
	GameEvents.Subscribe( "update_score", UpdateScoreUI );
	GameEvents.Subscribe( "show_timer", ShowTimer );
//	ShowTimer()
})();
