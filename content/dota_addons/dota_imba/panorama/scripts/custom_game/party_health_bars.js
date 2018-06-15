"use strict";

function intToARGB(i) 
{ 
                return ('00' + ( i & 0xFF).toString( 16 ) ).substr( -2 ) +
                                               ('00' + ( ( i >> 8 ) & 0xFF ).toString( 16 ) ).substr( -2 ) +
                                               ('00' + ( ( i >> 16 ) & 0xFF ).toString( 16 ) ).substr( -2 ) + 
                                                ('00' + ( ( i >> 24 ) & 0xFF ).toString( 16 ) ).substr( -2 );
}

(function UpdatePartyHealthBars()
{
	var partyContainer = $( "#PartyPortraits" );
	var nLocalPlayerID = Game.GetLocalPlayerID();
	var nLocalPlayerTeam = Players.GetTeam( nLocalPlayerID );
	if ( Players.IsSpectator( nLocalPlayerID ) )
	{
		var SelectedUnitEntIndex = Players.GetLocalPlayerPortaitUnit();
		if ( SelectedUnitEntIndex !== -1 )
		{
			nLocalPlayerTeam = 	Players.GetTeam( Entities.GetPlayerOwnerID( SelectedUnitEntIndex ) );
		}  
	}
	
	var PlayerIDs = Game.GetPlayerIDsOnTeam( nLocalPlayerTeam );
	var i = 0;
	for ( i; i < PlayerIDs.length; i++ )
	{
		var playerID = PlayerIDs[ i ];
		var playerPanelName = "PartyPortrait" + i;
		var entIndex = Players.GetPlayerHeroEntityIndex( playerID );
		var playerInfo = Game.GetPlayerInfo( playerID );
		var playerPanel = partyContainer.FindChild( playerPanelName );
		if ( playerPanel === null )
		{
			playerPanel = $.CreatePanel( "Panel", partyContainer, playerPanelName );
			playerPanel.BLoadLayout( "file://{resources}/layout/custom_game/party_portrait.xml", false, false );
		}

		if ( entIndex === -1 )
			continue;
		
		playerPanel.SetAttributeInt( "player_id", playerID );

		var colorInt = Players.GetPlayerColor( playerID );
		var colorString = "#" + intToARGB( colorInt );

	

		var heroImage = playerPanel.FindChildInLayoutFile( "HeroImage" );
		heroImage.heroname = Players.GetPlayerSelectedHero( playerID );
		var heroIconContainer = playerPanel.FindChildInLayoutFile( "HeroIconContainer" );
		heroIconContainer.SetAttributeInt( "ent_index", entIndex );

		var healthBar = playerPanel.FindChildInLayoutFile( "HealthBar" );
		healthBar.value = Entities.GetHealthPercent( entIndex );
		var manaBar = playerPanel.FindChildInLayoutFile( "ManaBar" );
		manaBar.value = 100.0 * (Entities.GetMana( entIndex ) / Entities.GetMaxMana( entIndex ) );
		var heroImage = playerPanel.FindChildInLayoutFile( "HeroImage" );

		var bDead = !Entities.IsAlive( entIndex );
		heroIconContainer.SetHasClass( "Dead", bDead );
	//	heroIconContainer.SetDialogVariableInt( "respawn_seconds", Players.GetRespawnSeconds( playerID ) );
		heroImage.style.washColor = bDead ? "#990000" : "#FFFFFF";	

		var bDisconnected = playerInfo.player_connection_state === DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED || playerInfo.player_connection_state === DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED;
		playerPanel.SetHasClass( "Disconnected", bDisconnected )
	
	}

	$.Schedule( 1.0/30.0, UpdatePartyHealthBars );
})();
