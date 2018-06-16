"use strict";

CustomNetTables.SubscribeNetTableListener( "rosh_tracker", UpdateRoshIcon );

function SetFlyoutScoreboardVisible( bVisible )
{
//	$.Msg("setting scoreboard visible " + bVisible);
	$.GetContextPanel().SetHasClass( "flyout_scoreboard_visible", bVisible );
}

(function()
{	
	UpdateScoreboard();
	SetFlyoutScoreboardVisible( false );
	$.RegisterEventHandler( "DOTACustomUI_SetFlyoutScoreboardVisible", $.GetContextPanel(), SetFlyoutScoreboardVisible );

})();


function UpdateRoshIcon()
{
	var key = 0;
	var RoshData = CustomNetTables.GetTableValue( "rosh_tracker", key.toString() );
	
	if ( RoshData !== undefined )
	{
		var nRoshDirection = RoshData["rosh_next_move_direction"];
		var nDir = 0;
		for ( nDir; nDir < 4; nDir++ )
		{
			$.GetContextPanel().SetHasClass( "Direction" + nDir, nRoshDirection === nDir );
		}
	}
}


var g_bScoreboardTeamsInit = false;

function InitScoreboardTeams()
{
	//$.Msg( "InitScoreboardTeams" );

	var nTeam = DOTATeam_t.DOTA_TEAM_CUSTOM_1;
	for ( nTeam; nTeam <= DOTATeam_t.DOTA_TEAM_CUSTOM_8; nTeam++ )
	{
		var TeamContainer = $.GetContextPanel().FindChildInLayoutFile( "TeamContainer" + nTeam )
		if ( TeamContainer === null )
			continue;

		//$.Msg( "Init team " + nTeam );
		var teamColor = GameUI.CustomUIConfig().team_colors[ nTeam ];
		//	teamColor = teamColor.replace( ";", "" );
		//var gradientText = 'gradient( linear, 0% 0%, 50% 100%, from( ' + teamColor + ' ), to( #00000088 ) );';
		//TeamContainer.style.backgroundColor = teamColor;

		var PlayerIDs = Game.GetPlayerIDsOnTeam( nTeam );
		if ( PlayerIDs.length == 0 )
			continue;

		for ( var i = 0; i < PlayerIDs.length; i++ )
		{
			//$.Msg( "Init player " + PlayerIDs[i] );
			var playerPanel = $.CreatePanel( "Panel", TeamContainer, "Player" + PlayerIDs[i] );
			playerPanel.BLoadLayout( "file://{resources}/layout/custom_game/cavern_scoreboard_player.xml", false, false );
			playerPanel.SetAttributeInt( "player_id", PlayerIDs[i] );

			var entIndex = Players.GetPlayerHeroEntityIndex( PlayerIDs[i] );
			playerPanel.SetAttributeInt( "hero_ent_index", entIndex );

			var colorBand = playerPanel.FindChildInLayoutFile( "TeamColorBand" );
			colorBand.style.backgroundColor = teamColor;

			var nameLabel = playerPanel.FindChildInLayoutFile( "Name" );
			//nameLabel.style.color = teamColor;

			playerPanel.SetDialogVariable( "player_name", Players.GetPlayerName( PlayerIDs[i] ) );
			playerPanel.SetDialogVariableInt( "kills", 0 );
			playerPanel.SetDialogVariableInt( "eliminations", 0 );

			playerPanel.SetHasClass( "player_muted", Game.IsPlayerMuted( PlayerIDs[i]  ) )
			playerPanel.SetHasClass( "local_player", Game.GetLocalPlayerID() == PlayerIDs[i]  )

			var heroImage = playerPanel.FindChildInLayoutFile( "PlayerHeroIcon" );
			heroImage.heroname = Players.GetPlayerSelectedHero( PlayerIDs[i] );
		} 
	}

	g_bScoreboardTeamsInit = true;
}

function UpdateScoreboard()
{
	$.Schedule( 1.0, UpdateScoreboard );

	if ( Game.GameStateIsBefore( DOTA_GameState.DOTA_GAMERULES_STATE_PRE_GAME ) )
		return;

	if ( g_bScoreboardTeamsInit === false )
	{
		InitScoreboardTeams();
		return;
	}
	
	if ( $.GetContextPanel().BHasClass( "flyout_scoreboard_visible" ) === false )
		return;

	var nTeam = DOTATeam_t.DOTA_TEAM_CUSTOM_1;
	for ( nTeam; nTeam <= DOTATeam_t.DOTA_TEAM_CUSTOM_8; nTeam++ )
	{
		var TeamContainer = $.GetContextPanel().FindChildInLayoutFile( "TeamContainer" + nTeam )
		if ( TeamContainer === null )
			continue;

		var PlayerIDs = Game.GetPlayerIDsOnTeam( nTeam );
		if ( PlayerIDs.length == 0 )
			continue;


		for ( var i = 0; i < PlayerIDs.length; i++ )
		{
			var PlayerRow = TeamContainer.FindChildInLayoutFile( "Player" + PlayerIDs[i] )
			if ( PlayerRow === null )
				continue;

			PlayerRow.SetDialogVariableInt( "kills", 0 );
			PlayerRow.SetDialogVariableInt( "eliminations", 0 );

			PlayerRow.SetHasClass( "player_muted", Game.IsPlayerMuted( PlayerIDs[i]  ) )
			PlayerRow.SetHasClass( "local_player", Game.GetLocalPlayerID() == PlayerIDs[i]  )

			var PlayerEliminatedData = CustomNetTables.GetTableValue( "eliminated_players", PlayerIDs[i] .toString());
			PlayerRow.SetHasClass( "Eliminated", PlayerEliminatedData !== undefined && PlayerEliminatedData["eliminationTime"] !== null );
			PlayerRow.SetHasClass( "Alive", Players.GetRespawnSeconds( PlayerIDs[i] ) == -1 );
		}
	}
}

$.Schedule(1.0, HideScoreboard)

function HideScoreboard() {
	if (Game.GetMapInfo().map_display_name == "cavern") {
	
	} else {
		// .CavernTopBar
		$.GetContextPanel().style.visibility = "collapse";
	}

	$.Schedule(1.0, HideScoreboard)
}
