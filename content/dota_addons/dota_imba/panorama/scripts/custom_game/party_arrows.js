"use strict";

function intToARGB(i) 
{ 
                return ('00' + ( i & 0xFF).toString( 16 ) ).substr( -2 ) +
                                               ('00' + ( ( i >> 8 ) & 0xFF ).toString( 16 ) ).substr( -2 ) +
                                               ('00' + ( ( i >> 16 ) & 0xFF ).toString( 16 ) ).substr( -2 ) + 
                                                ('00' + ( ( i >> 24 ) & 0xFF ).toString( 16 ) ).substr( -2 );
}

(function UpdatePartyArrows()
{
	var arrowsContainer = $( "#PartyArrows" );
	var localPlayerInfo = Game.GetLocalPlayerInfo();
	var players = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_GOODGUYS );

	var screenWidth = arrowsContainer.actuallayoutwidth / arrowsContainer.actualuiscale_x;
	var screenHeight = 1080;
	var screenXMid = screenWidth / 2;
	var screenYMid = screenHeight / 2;	
	
	for ( var i in players )
	{
		var playerID = players[i];
		if ( localPlayerInfo && ( playerID === localPlayerInfo.player_id ) )
			continue;

		var arrowPanelName = "PartyArrow" + playerID;
		var playerHeroEntIndex = Players.GetPlayerHeroEntityIndex( playerID );
		var arrowPanel = arrowsContainer.FindChild( arrowPanelName );
		if ( arrowPanel === null )
		{
			if ( playerHeroEntIndex === -1 )
				continue;
			
			$.Msg( "Creating a player arrow" );
			arrowPanel = $.CreatePanel( "Panel", arrowsContainer, arrowPanelName );
			arrowPanel.SetAttributeInt( "player_id", playerID );
			arrowPanel.BLoadLayout( "file://{resources}/layout/custom_game/party_arrow.xml", false, false )
			var arrowImage = arrowPanel.FindChildInLayoutFile( "PartyArrowImage" );
			var arrowColor = Players.GetPlayerColor( playerID );
			arrowImage.style.washColor = "#" + intToARGB( arrowColor );

		}

		var heroImagePanel = arrowPanel.FindChildInLayoutFile("HeroImage");

		var objectSize = 56;

		var vPos = Entities.GetAbsOrigin( playerHeroEntIndex );
		var screenX = screenWidth - objectSize;
		var screenY = screenHeight - objectSize;

		var posOut = GameUI.WorldToScreenXYClamped( vPos );
		var posX = posOut[0] * screenWidth;
		var posY = posOut[1] * screenHeight;  
		var szFullHeroName = Entities.GetUnitName( playerHeroEntIndex );
		heroImagePanel.heroname = szFullHeroName;


		//adjust the position by the image size
		posX -= (objectSize / 2) - 1;
		posY -= (objectSize / 2) - 1;

		//determine party arrow rotation angle
		{
			var dirX = screenXMid - posX;
			var dirY = screenYMid - posY;
			var magSqr = dirX * dirX + dirY * dirY;
			var mag = Math.sqrt(magSqr);
			//dirX = dirX / mag;
			dirY = dirY / mag;
			//since our dot direction is straight up, the dotResult is just the normalized Y value
			var dotResult = dirY;
			if(dotResult > 1.0)
			{
				dotResult = 1.0;
			}
			else if(dotResult < -1.0)
			{
				dotResult = -1.0;
			}

			var angle = Math.acos(dotResult);
			var angleDegrees = angle * (180.0 / Math.PI);

			//adjust the angle negative if we are on the opposite side of the screen
			if(dirX > 0)
			{
				angleDegrees *= -1.0;
			}
			arrowPanel.style.transform = "rotateZ(" + angleDegrees + "deg)";
			heroImagePanel.style.transform = "rotateZ(" + (360.0 - angleDegrees) + "deg)"
		}


		
		var bOffscreen = false;
		if ( posX > screenX )
		{
			posX = screenX;
			bOffscreen = true;
		}
		if ( posX < 6 )
		{
			posX = 6;
			bOffscreen = true;
		}

		if ( posY > screenY - 6 )
		{
			posY = screenY - 6;
			bOffscreen = true;
		}
		if ( posY < 0 )
		{
			posY = 0;
			bOffscreen = true;
		}

		arrowPanel.SetHasClass( "Hidden", !bOffscreen );
		arrowPanel.style.x = posX + "px";
		arrowPanel.style.y = posY + "px";
	}

	$.Schedule( 1.0/150.0, UpdatePartyArrows );
})();

