"use strict";

var g_nClientPointCapMax = -1;
var g_nClientPointCapUsed = -1;
var g_nRewardLineTier1 = -1;
var g_nRewardLineTier2 = -1;
var g_nNumRewardRequests = 0;
var SHOW_TUTORIAL = false

function OnNewRoomDiscovered( roomData )
{
	if ( roomData !== null )
	{
		$( "#RoomDiscoverPanel" ).FindChildInLayoutFile( "EncounterNameLabel" ).text = $.Localize( roomData.encounter_name );
	}

	$( "#RoomDiscoverPanel" ).SetHasClass( "Visible", true );

	var szRoomClass = "Difficulty";
	szRoomClass = szRoomClass + roomData.encounter_difficulty;

	$( "#RoomDiscoverPanel" ).SwitchClass( "RoomType", szRoomClass );

	Game.EmitSound( "RoomDiscover" );

	$.Schedule( 5.0, HideRoomDiscoverPanel );
}

function HideRoomDiscoverPanel()
{
	$( "#RoomDiscoverPanel" ).SetHasClass( "Visible", false );
}

GameEvents.Subscribe( "on_new_room_discovered", OnNewRoomDiscovered );

function OnOkButtonClicked()
{
	$( "#GameInfoPopup" ).SetHasClass( "Visible", false );
}

var g_TeamDefeatedData = null;

function ShowTeamDefeatedPanel()
{
	if ( g_TeamDefeatedData !== null )
	{
		if ( nTeamPosition < 3 )
			return;

		var PlayerIDs = Game.GetPlayerIDsOnTeam( Players.GetTeam( Game.GetLocalPlayerID() ) );
		for( var i = 0; i < PlayerIDs.length; i++ )
		{
			var nPlayerID = PlayerIDs[i];
			var PlayerInfo = Game.GetPlayerInfo( nPlayerID );
			//$.Msg( "PlayerID = " + nPlayerID );
			var szScenePanelID = "Hero" + (i+1);
			//$.Msg( "Scene Panel Name = " + szScenePanelID  );
			var scenePanel = $.GetContextPanel().FindChildInLayoutFile( szScenePanelID );
			if ( scenePanel !== null )
			{
				scenePanel.SetUnit( PlayerInfo.player_selected_hero, "default_camera" );
			}
			else
			{
				$.Msg( "No scene panel" );
			}

			var szLabelPanelID = "PlayerName" + (i+1);
			//$.Msg( "Label Panel Name = " + szLabelPanelID  );
			var nameLabel = $.GetContextPanel().FindChildInLayoutFile( szLabelPanelID );
			if ( nameLabel !== null )
			{
				nameLabel.steamid = PlayerInfo.player_steamid;
			}
			else
			{
				$.Msg( "Noname label" );
			}
		}

		var nTeamPosition = g_TeamDefeatedData["finish_position"];
		var szPositionString = "th";

		if ( nTeamPosition === 3 )
		{
			szPositionString = "rd";
		}
/*
		var BPData = CustomNetTables.GetTableValue( "bp_tracker", Players.GetLocalPlayer().toString() );
		if ( BPData !== undefined )
		{
			var nEarnedPoints = BPData["earned_points"];
			if( g_nRewardLineTier1 < 0 || g_nRewardLineTier2 < 0 || g_nClientPointCapUsed < 0 || g_nClientPointCapMax < 0 || g_nNumRewardRequests < 5)
			{
				g_nClientPointCapMax = EventData.GetPeriodicResourceMax(14);
				g_nClientPointCapUsed = EventData.GetPeriodicResourceUsed(14);
				

				g_nRewardLineTier1 = EventData.GetEventActionScore( 22, 1150 );
				g_nRewardLineTier2 = EventData.GetEventActionScore( 22, 1252 );

				++g_nNumRewardRequests;
			}

			var flMultiplier = 1.0
			if ( g_nRewardLineTier2 > 0) 
			{
				flMultiplier = 2.0;
			}
			else if ( g_nRewardLineTier1 > 0)
			{
				flMultiplier = 1.5;
			}

			var nClientPointCapRemaining = g_nClientPointCapMax - g_nClientPointCapUsed;
			$( "#GameOverPanel" ).SetDialogVariableInt( "event_game_points_earned", g_nClientPointCapUsed );
			$( "#GameOverPanel" ).SetDialogVariableInt( "event_game_point_cap", g_nClientPointCapMax );

			$( "#GameOverPanel" ).SetDialogVariableInt( "total_from_game", Math.min( nClientPointCapRemaining, nEarnedPoints*flMultiplier) );

			$( "#GameOverPanel" ).SetDialogVariableInt( "total_earned_points", Math.min( nClientPointCapRemaining, nEarnedPoints*flMultiplier) );

		}

		$( "#GameOverPanel" ).FindChildInLayoutFile( "SmallCheeseContainer" ).SetDialogVariableInt( "num_earned", g_TeamDefeatedData["small_cheese"] !== 'undefined' ? g_TeamDefeatedData["small_cheese"] : 0 );
		$( "#GameOverPanel" ).FindChildInLayoutFile( "BigCheeseContainer" ).SetDialogVariableInt( "num_earned", g_TeamDefeatedData["big_cheese"] !==  'undefined' ? g_TeamDefeatedData["big_cheese"] : 0 );
		$( "#GameOverPanel" ).FindChildInLayoutFile( "EliminationsContainer" ).SetDialogVariableInt( "num_earned", g_TeamDefeatedData["eliminations"] !== 'undefined' ? g_TeamDefeatedData["eliminations"] : 0 );
		$( "#GameOverPanel" ).SetDialogVariable( "finish_position", nTeamPosition + szPositionString );
		$( "#GameOverPanel" ).SetHasClass( "Visible", true );
		*/
	}
}

function OnTeamDefeated( data )
{
	g_TeamDefeatedData = data;
	$.Schedule( 5.0, ShowTeamDefeatedPanel );
}

// useless yet because somehow a script make it visible already
function ShowTutorial() {
	SHOW_TUTORIAL = true
	$.GetContextPanel().style.visibility = "visible";
}

$.Schedule(1.0, HideTutorial)

function HideTutorial() {
	if (SHOW_TUTORIAL == true) {
		return;
	} else {
		$.GetContextPanel().style.visibility = "collapse";
	}

	$.Schedule(1.0, HideTutorial)
}

GameEvents.Subscribe( "on_team_defeated", OnTeamDefeated );
GameEvents.Subscribe("show_cavern_tutorial", ShowTutorial);
