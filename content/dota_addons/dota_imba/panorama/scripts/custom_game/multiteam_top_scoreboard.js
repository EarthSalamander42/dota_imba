"use strict";

var g_ScoreboardHandle = null;

function UpdateScoreboard()
{
	ScoreboardUpdater_SetScoreboardActive( g_ScoreboardHandle, true );

	var Parent = $.GetContextPanel().GetParent().GetParent().GetParent()
	var hudElements = Parent.FindChildTraverse("HUDElements");
	var topbar = hudElements.FindChildTraverse("topbar");
	var map_info = Game.GetMapInfo();
	if (map_info.map_display_name == "imba_overthrow" && topbar.style.visibility == "visible") {
		topbar.style.visibility = "collapse";
	}

	$.Schedule( 0.2, UpdateScoreboard );
}

function OnScoreChanged( data )
{
	var radScore = $( "#ConquestScore_Radiant" );
	if ( radScore )
	{
		radScore.text = data.radiant;
	}
	
	var direScore = $( "#ConquestScore_Dire" );
	if ( direScore )
	{
		direScore.text = data.dire;
	}

	var custom1Score = $( "#ConquestScore_Custom1" );
	if ( custom1Score )
	{
		custom1Score.text = data.custom_1;
	}

//	var custom2Score = $( "#ConquestScore_Custom2" );
//	if ( custom2Score )
//	{
//		custom2Score.text = data.custom_2;
//	}
}

(function()
{
	var shouldSort = true;
//	$("#MultiteamScoreboard").style.visibility = "collapse";

	if ( GameUI.CustomUIConfig().multiteam_top_scoreboard )
	{
		var cfg = GameUI.CustomUIConfig().multiteam_top_scoreboard;
		if ( cfg.LeftInjectXMLFile )
		{
			$( "#LeftInjectXMLFile" ).BLoadLayout( cfg.LeftInjectXMLFile, false, false );
		}
		if ( cfg.RightInjectXMLFile )
		{
			$( "#RightInjectXMLFile" ).BLoadLayout( cfg.RightInjectXMLFile, false, false );
		}

		if ( typeof(cfg.shouldSort) !== 'undefined')
		{
			shouldSort = cfg.shouldSort;
		}
	}
	
	if ( ScoreboardUpdater_InitializeScoreboard === null ) { $.Msg( "WARNING: This file requires shared_scoreboard_updater.js to be included." ); }

	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/multiteam_top_scoreboard_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/multiteam_top_scoreboard_player.xml",
		"shouldSort" : false
	};
	g_ScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, $( "#MultiteamScoreboard" ) );

	GameEvents.Subscribe( "team_points", OnScoreChanged );

	$.Schedule(1.0, UpdateScoreboard);
})();
