"use strict";

CustomNetTables.SubscribeNetTableListener( "rosh_tracker", UpdateGameTimers );
CustomNetTables.SubscribeNetTableListener( "eliminated_players", UpdateTopBarEnemies );
GameEvents.Subscribe( "on_hero_entered_room", OnHeroEnteredRoom );
GameEvents.Subscribe( "on_team_info", OnTeamInfo );

var g_nClientPointCapMax = -1;
var g_nClientPointCapUsed = -1;
var g_nRewardLineTier1 = -1;
var g_nRewardLineTier2 = -1;
var g_nNumRewardRequests = 0;

function intToARGB(i) 
{ 
                return ('00' + ( i & 0xFF).toString( 16 ) ).substr( -2 ) +
                                               ('00' + ( ( i >> 8 ) & 0xFF ).toString( 16 ) ).substr( -2 ) +
                                               ('00' + ( ( i >> 16 ) & 0xFF ).toString( 16 ) ).substr( -2 ) + 
                                                ('00' + ( ( i >> 24 ) & 0xFF ).toString( 16 ) ).substr( -2 );
}


function OnHeroEnteredRoom( data )
{
	return;
	$.GetContextPanel().FindChildInLayoutFile( "RoomTitle" ).text = $.Localize( data["EncounterName"] );
	$.GetContextPanel().FindChildInLayoutFile( "RoomInstructions" ).text = $.Localize( data["EncounterName"] + "_description" );
	var DifficultyContainer = $( "#TopBarPanel" ).FindChildInLayoutFile( "DifficultyContainer" );
	var nDifficultyLevel = data["EncounterDifficulty"];
	
	DifficultyContainer.SetHasClass( "2Skull", nDifficultyLevel > 1 );
	DifficultyContainer.SetHasClass( "3Skull", nDifficultyLevel > 2 );
	DifficultyContainer.SetHasClass( "4Skull", nDifficultyLevel > 3 );
	DifficultyContainer.SetHasClass( "5Skull", nDifficultyLevel > 4 );
}

function OnTeamInfo( data )
{

}

function UpdateTopBar()
{
	UpdateGameTimers();
//	UpdateScore();
	UpdateTopBarEnemies();
	$.Schedule( 1.0, UpdateTopBar );
}

function UpdateGameTimers()
{
	var bPreGame = Game.GameStateIs( DOTA_GameState.DOTA_GAMERULES_STATE_PRE_GAME );
	var secondsRaw = bPreGame ? Math.floor( Game.GetStateTransitionTime() - Game.GetGameTime()  ) : Math.floor( Game.GetDOTATime( false, false ) ) ;

	var minutes = secondsRaw / 60;
	var seconds = minutes < 1 ? secondsRaw : secondsRaw - ( Math.floor( minutes ) * 60 );
	$.GetContextPanel().FindChildInLayoutFile( "GameTimer" ).text = Math.floor( minutes ) + ":" + ( "0" + seconds ).slice(-2);

	var key = 0;
	var RoshData = CustomNetTables.GetTableValue( "rosh_tracker", key.toString() );
	
	if ( RoshData !== undefined )
	{
		var RoshSecondsRaw = Math.floor( RoshData["rosh_next_move_time"] ) 
		var RoshMinutes = RoshSecondsRaw / 60;
		var RoshSeconds = RoshMinutes < 1 ? RoshSecondsRaw : RoshSecondsRaw - ( Math.floor( RoshMinutes ) * 60 );
		$.GetContextPanel().FindChildInLayoutFile( "RoshText" ).text = RoshSecondsRaw;//Math.floor( RoshMinutes ) + ":" + ( "0" + RoshSeconds ).slice(-2);

		var nRoshDirection = RoshData["rosh_next_move_direction"];
		var nDir = 0;
		for ( nDir; nDir < 4; nDir++ )
		{
			$.GetContextPanel().SetHasClass( "Direction" + nDir, nRoshDirection === nDir );
		}

		var nMoving = RoshData["rosh_currently_moving"]
		$.GetContextPanel().SetHasClass( "Moving", nMoving == 1 );
		$.GetContextPanel().SetHasClass( "AboutToMove", RoshSecondsRaw <= 60 );
	}
}
/*
function UpdateScore()
{

	UpdateBattlePoints();
}

 CustomNetTables.SubscribeNetTableListener( "bp_tracker", UpdateBattlePoints );
*/
function UpdateBattlePoints()
{
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

		//$.Msg(g_nClientPointCapUsed + " "+ g_nClientPointCapMax);

		if( nClientPointCapRemaining > 0 )
		{
			$( "#EarnedBPAmount" ).SetDialogVariableInt( "earned_points", Math.min( nClientPointCapRemaining, nEarnedPoints*flMultiplier) );
			$( "#EarnedBPAmount" ).SetDialogVariableInt( "remaining_points", nClientPointCapRemaining );
		}
		else 
		{
			$( "#EarnedBPAmount" ).SetDialogVariableInt( "earned_points", g_nClientPointCapUsed );
			$( "#EarnedBPAmount" ).SetDialogVariableInt( "remaining_points", g_nClientPointCapMax );
		}

	}
}
	

function UpdateTopBarEnemies()
{
	var nTeam = DOTATeam_t.DOTA_TEAM_CUSTOM_1;
	for ( nTeam; nTeam <= DOTATeam_t.DOTA_TEAM_CUSTOM_8; nTeam++ )
	{
		var TeamContainer = $.GetContextPanel().FindChildInLayoutFile( "Team" + nTeam )
		if ( TeamContainer === null )
			continue;

		var teamColor = GameUI.CustomUIConfig().team_colors[ nTeam ];
  		teamColor = teamColor.replace( ";", "DD" );
		var gradientText = 'gradient( linear, 0% 0%, 0% 80%, from( ' + teamColor + ' ), to( #00000000 ) );';

		var PlayerIDs = Game.GetPlayerIDsOnTeam( nTeam );
		var bTeamEliminated = true;
		for ( var nChild = 0; nChild < TeamContainer.GetChildCount(); nChild++ )
		{
			var PlayerIcon = TeamContainer.GetChild( nChild );
			if ( PlayerIcon === null )
				continue;

			if ( nChild >= PlayerIDs.length )
				continue;

			var HeroEntIndex = Players.GetPlayerHeroEntityIndex( PlayerIDs[nChild] );
			PlayerIcon.heroname = Players.GetPlayerSelectedHero( PlayerIDs[nChild] );

			var nPlayerID = PlayerIDs[nChild]
			var PlayerEliminatedData = CustomNetTables.GetTableValue( "eliminated_players", nPlayerID.toString());
			//$.Msg(nPlayerID + " " + PlayerEliminatedData)
			var bPlayerEliminated = PlayerEliminatedData !== undefined && PlayerEliminatedData["eliminationTime"] !== null;
			PlayerIcon.SetHasClass( "Eliminated", bPlayerEliminated );
			PlayerIcon.SetHasClass( "Alive", Players.GetRespawnSeconds( PlayerIDs[nChild] ) == -1 );

			if ( bPlayerEliminated === false )
			{
				bTeamEliminated = false;
			}
		}

		TeamContainer.SetHasClass( "TeamEliminated", bTeamEliminated );
		if ( bTeamEliminated === true )
		{
			TeamContainer.style.backgroundColor = "#000000";
		}
		else
		{
			TeamContainer.style.backgroundColor = gradientText;
		}
	}
}

var MainPanel = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent()
if (Game.GetMapInfo().map_display_name == "cavern") {
	MainPanel.FindChildTraverse("topbar").style.visibility = "collapse";
	$.Schedule( 1.0, UpdateTopBar );
	$.Schedule( 1.0, HideTopBar );
}

function HideTopBar() {
	$.GetContextPanel().visible = false;
}
