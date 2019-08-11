"use strict";

GameUI.SetCameraTerrainAdjustmentEnabled( false );

function OnPlayerEnteredZone( data )
{
	$.Msg( "OnPlayerEnteredZone" );
	Game.EmitSound("Dungeon.Stinger07");
	$( "#ZoneToastPanel" ).SetHasClass( "Visible", true );
	$( "#ZoneNameLabel" ).text = $.Localize( data["ZoneName"] );

	$.Schedule( 5.0, HideZoneNotification );
}

function HideZoneNotification()
{
	$( "#ZoneToastPanel" ).SetHasClass( "Visible", false );
}

GameEvents.Subscribe( "zone_enter", OnPlayerEnteredZone );


var g_flDialogAdvanceTime = -1;
var g_nCurrentCharacter = 0;
var g_flCharacterAdvanceRate = 0.0075;
var g_szPendingDialog = null;
var g_nCurrentDialogEnt = -1;
var g_nCurrentDialogLine = -1;
var g_bSentToAll = false;
var g_szConfirmToken = null;
var g_bShowAdvanceButton = true;

function OnDialogReceived( data )
{
	if ( data["DialogText"] ===  "" )
		return;

	g_bSentToAll = data["SendToAll"];
	if ( !g_bSentToAll )
	{
		var vAbsOrigin = Entities.GetAbsOrigin( data["DialogEntIndex"] );
		var nX = Game.WorldToScreenX( vAbsOrigin[0], vAbsOrigin[1], vAbsOrigin[2] );
		var nY = Game.WorldToScreenY( vAbsOrigin[0], vAbsOrigin[1], vAbsOrigin[2] );
		$( "#FloatingDialogPanel" ).style.x = ( nX + 25 ) + "px"; 
		$( "#FloatingDialogPanel" ).style.y = ( nY - 100 ) + "px";
	}
	
	$( "#DialogPanel" ).SetHasClass( "Visible", g_bSentToAll || data["JournalEntry"] || data["WardenNote"] );
	$( "#FloatingDialogPanel" ).SetHasClass( "Visible", !g_bSentToAll && !data["JournalEntry"] && !data["WardenNote"] );
	$( "#DialogPanel" ).SetHasClass( "JournalEntry", data["JournalEntry"] );
	$( "#DialogPanel" ).SetHasClass( "WardenNote", data["WardenNote"] );
	$( "#DialogTitle" ).text = $.Localize( Entities.GetUnitName( data["DialogEntIndex"] ) );
	$( "#DialogPortrait" ).SetUnit(Entities.GetUnitName( data["DialogEntIndex"] ), ""); 
	$( "#DialogPanel" ).SetHasClass( "ShowAdvanceButton", true );
	$( "#FloatingDialogPanel" ).SetHasClass( "ShowAdvanceButton", true );

	g_bShowAdvanceButton = data["ShowAdvanceButton"];
	g_nCurrentCharacter = 0;
	g_nCurrentDialogEnt = data["DialogEntIndex"];
	g_nCurrentDialogLine = data["DialogLine"];
	g_szPendingDialog = $.Localize( data["DialogText"] );
	g_szConfirmToken = data["ConfirmToken"]
	if ( !g_bSentToAll )
	{
		var szFullHeroName = Entities.GetUnitName( data["PlayerHeroEntIndex"] );
		var szHeroName = szFullHeroName.substring( 13, szFullHeroName.length );
		var szHeroLocalizedDialog = $.Localize( data["DialogText"] + szHeroName );
		if ( szHeroLocalizedDialog !== ( data["DialogText"] + szHeroName ) )
		{
			g_szPendingDialog = szHeroLocalizedDialog;
		}
		if ( data["JournalEntry"] || data["WardenNote"] )
		{
			g_nCurrentCharacter = g_szPendingDialog.length;
		}
	}
	
	$( "#DialogLabelSizer" ).text = g_szPendingDialog;
	$( "#FloatingDialogLabelSizer" ).text = g_szPendingDialog;
	
	$( "#DialogPanel" ).SetHasClass( "ConfirmStyle", data["DialogPlayerConfirm"] == 1 );
	$( "#DialogPlayerConfirm" ).SetHasClass( "Visible", data["DialogPlayerConfirm"] == 1) ;
	$( "#ConfirmButton" ).SetHasClass( "Visible", data["DialogPlayerConfirm"] == 1 );

	$("#DialogPanel").SetDialogVariableInt("player_id_0", 0);
	$("#DialogPanel").SetDialogVariableInt("player_id_1", 1);
	$("#DialogPanel").SetDialogVariableInt("player_id_2", 2);
	$("#DialogPanel").SetDialogVariableInt("player_id_3", 3);
	
	
	for(var i = 0; i < 4; i++)
	{	
		var heroImage = $( '#Player' + i + 'ConfirmIcon' );
		heroImage.heroname = Players.GetPlayerSelectedHero( i );
	}

	g_flDialogAdvanceTime = Game.GetGameTime() + data["DialogAdvanceTime"];

	$.Schedule( g_flCharacterAdvanceRate, AdvanceDialogThink );
}

function AdvanceDialogThink()
{
	if ( Game.GetGameTime() > g_flDialogAdvanceTime || g_szPendingDialog === null )
	{
		if ( $( "#DialogPlayerConfirm" ).BHasClass( "Visible" ) )
		{
			GameEvents.SendCustomGameEventToServer( "dialog_confirm_expire", { ConfirmToken: g_szConfirmToken, DialogEntIndex: g_nCurrentDialogEnt, DialogLine: g_nCurrentDialogLine } );	
			GameEvents.SendCustomGameEventToServer( "dialog_complete", { DialogEntIndex : g_nCurrentDialogEnt, DialogLine : g_nCurrentDialogLine, ShowNextLine : false, PlayerHeroEntIndex : Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ) } );
		}
		else
		{
			$( "#DialogPanel" ).SetHasClass( "Visible", false );
			$( "#FloatingDialogPanel" ).SetHasClass( "Visible", false );
			GameEvents.SendCustomGameEventToServer( "dialog_complete", { DialogEntIndex : g_nCurrentDialogEnt, DialogLine : g_nCurrentDialogLine, ShowNextLine : false, PlayerHeroEntIndex : Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ) } );
		}
		return;
	}

	g_nCurrentCharacter = Math.min( g_nCurrentCharacter + 1, g_szPendingDialog.length )
	if ( g_nCurrentCharacter === g_szPendingDialog.length )
	{
		$( "#DialogLabel" ).text = g_szPendingDialog;
		$( "#FloatingDialogLabel" ).text = g_szPendingDialog;
		$( "#DialogPanel" ).SetHasClass( "ShowAdvanceButton", g_bShowAdvanceButton ); 
		$( "#FloatingDialogPanel" ).SetHasClass( "ShowAdvanceButton", g_bShowAdvanceButton ); 
	}

	$( "#DialogLabel" ).text = g_szPendingDialog.substring(0, g_nCurrentCharacter) + "<span class='HiddenText'>" + g_szPendingDialog.substring(g_nCurrentCharacter, g_szPendingDialog.length) + "</span>";
	$( "#FloatingDialogLabel" ).text = g_szPendingDialog.substring( 0, g_nCurrentCharacter );

	$.Schedule( g_flCharacterAdvanceRate, AdvanceDialogThink );
}

function OnAdvanceDialogButtonPressed()
{
	$.Msg( "AdvanceDialogButtonPressed" );
	if ( g_nCurrentCharacter < g_szPendingDialog.length )
	{
		g_nCurrentCharacter = g_szPendingDialog.length;
		AdvanceDialogThink();
		return;
	}
	else
	{
		if ( !g_bShowAdvanceButton )
		{
			$( "#DialogPanel" ).SetHasClass( "Visible", false );
			$( "#FloatingDialogPanel" ).SetHasClass( "Visible", false );
		}	
		GameEvents.SendCustomGameEventToServer( "dialog_complete", { DialogEntIndex : g_nCurrentDialogEnt, DialogLine : g_nCurrentDialogLine, ShowNextLine : g_bShowAdvanceButton, PlayerHeroEntIndex : Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ) } );
	}
}

function OnConfirmButtonPressed()
{
	GameEvents.SendCustomGameEventToServer( "dialog_confirm", { nPlayerID: (Players.GetLocalPlayer()), ConfirmToken: g_szConfirmToken, DialogEntIndex: g_nCurrentDialogEnt, DialogLine: g_nCurrentDialogLine } );
	$( "#ConfirmButton" ).AddClass( "Confirmed" );
}

function OnDialogPlayerConfirm( data )
{
	$( "#Player"+data["PlayerID"]+"Confirm" ).AddClass( "Confirmed" )
}

function OnDialogPlayerAllConfirmed( data )
{
	$( "#DialogPanel" ).SetHasClass( "Visible", false );
	GameEvents.SendCustomGameEventToServer( "dialog_complete", { DialogEntIndex: g_nCurrentDialogEnt, DialogLine: g_nCurrentDialogLine, ShowNextLine : false, PlayerHeroEntIndex : Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ) } );
	
	$( "#ConfirmButton" ).RemoveClass( "Confirmed" );
	$( "#Player"+0+"Confirm" ).RemoveClass( "Confirmed" )
	$( "#Player"+1+"Confirm" ).RemoveClass( "Confirmed" )
	$( "#Player"+2+"Confirm" ).RemoveClass( "Confirmed" )
	$( "#Player"+3+"Confirm" ).RemoveClass( "Confirmed" )
	g_szConfirmToken = null;
}

function OnCloseDialogButtonPressed()
{
	$( "#DialogPanel" ).SetHasClass( "Visible", false );
	$( "#FloatingDialogPanel" ).SetHasClass( "Visible", false );	
	GameEvents.SendCustomGameEventToServer( "dialog_complete", { DialogEntIndex : g_nCurrentDialogEnt, DialogLine : g_nCurrentDialogLine, ShowNextLine : false, PlayerHeroEntIndex : Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ) } );
}

GameEvents.Subscribe( "dialog", OnDialogReceived );
GameEvents.Subscribe( "dialog_player_confirm", OnDialogPlayerConfirm);
GameEvents.Subscribe( "dialog_player_all_confirmed", OnDialogPlayerAllConfirmed);

var g_nMovingCameraOffset = 600;
var g_nStillCameraOffset = 0;
var g_flTimeSpentMoving = 0.0;
var HUD_THINK = 0.005;
var g_bInBossIntro = false;
var g_nBossCameraEntIndex = -1;
var g_flCameraDesiredOffset = 128.0;
var g_flAdditionalCameraOffset = 0.0;
var g_flMaxLookDistance = 1200.0;
var g_bSentGuideDisable = false;
var g_szLastZoneLocation = null;
var g_ZoneList = [ 	"start", 
					"forest", 
					"forest_holdout", 
					"darkforest_death_maze", 
					"darkforest_rescue", 
					"darkforest_pass", 
					"underground_temple", 
					"desert_start", 
					"desert_town", 
					"desert_expanse",
					"desert_outpost",
					"desert_chasm",
					"desert_fortress" ];

(function HUDThink()
{	
	var flThink = HUD_THINK;
	if ( g_bInBossIntro === false )
	{
		UpdateBossHP()
	}
	else
	{
		BossHPTickUp();
		flThink = 0.05;
	}

	if ( !g_bSentToAll && $( "#FloatingDialogPanel" ).BHasClass( "Visible") )
	{
		var vAbsOrigin = Entities.GetAbsOrigin( g_nCurrentDialogEnt );
		var nX = Game.WorldToScreenX( vAbsOrigin[0], vAbsOrigin[1], vAbsOrigin[2] );
		var nY = Game.WorldToScreenY( vAbsOrigin[0], vAbsOrigin[1], vAbsOrigin[2] );
		$( "#FloatingDialogPanel" ).style.x = ( nX / $( "#FloatingDialogPanel" ).actualuiscale_x ) + 25 + "px"; 
		$( "#FloatingDialogPanel" ).style.y = ( nY / $( "#FloatingDialogPanel" ).actualuiscale_y  ) - 100 + "px";
	}

	UpdateRespawnsRemaining();
	UpdateCryptHoldout();

	var playerZoneData = CustomNetTables.GetTableValue( "player_zone_locations", Players.GetLocalPlayer().toString() );
	if (  typeof(playerZoneData) !== "undefined" )
	{
		var zoneName = playerZoneData["ZoneName"];
	 	if ( g_szLastZoneLocation !== zoneName )
	 	{
	 		if ( g_szLastZoneLocation !== null )
	 		{
	 			$( "#DungeonHUDContents" ).RemoveClass( g_szLastZoneLocation );
	 		}
	 		$( "#DungeonHUDContents" ).SetHasClass( zoneName, true );
	 		g_szLastZoneLocation = zoneName;
	 	}
	}

	$( "#DungeonHUDContents" ).SetHasClass( "HasAbilityToSpend", Entities.GetAbilityPoints( Players.GetLocalPlayerPortraitUnit() ) > 0 );

	if( !g_bSentGuideDisable )
	{
		$.DispatchEvent( 'DOTAShopSetGuideVisibility', false);
		g_bSentGuideDisable = true;
	}

	if ( Entities.GetUnitName( Players.GetLocalPlayerPortraitUnit() ) === "npc_dota_creature_invoker" && Game.IsShopOpen() === false )
	{
		Game.SetCustomShopEntityString( "invoker_shop" );
		$.DispatchEvent( "DOTAHUDShopOpened", DOTA_SHOP_TYPE.DOTA_SHOP_CUSTOM, true );
	}
	
	$.Schedule( flThink, HUDThink );
})();

(function CameraThink() {
    if (g_bInBossIntro === false)
    {
    	if ( Game.GetState() < DOTA_GameState.DOTA_GAMERULES_STATE_POST_GAME )
    	{
        	UpdateCameraOffset();
        }
    }
    $.Schedule(0, CameraThink);
})();

CustomNetTables.SubscribeNetTableListener( "boss", UpdateBossHP )
CustomNetTables.SubscribeNetTableListener( "respawns_remaining", UpdateRespawnsRemaining )

function UpdateRespawnsRemaining()
{
	var selectedUnitEntIndex = Players.GetLocalPlayerPortraitUnit( Players.GetLocalPlayer() );
	if ( selectedUnitEntIndex !== null )
	{
		var bIsHero = Entities.IsRealHero( selectedUnitEntIndex );
		$( "#DungeonHUDContents" ).SetHasClass( "IsPlayer", bIsHero );
		if ( !bIsHero )
			return;

		var respawnData = CustomNetTables.GetTableValue( "respawns_remaining", selectedUnitEntIndex.toString() );
		var tombstoneData = CustomNetTables.GetTableValue( "revive_state", selectedUnitEntIndex.toString() );
		if ( typeof( respawnData != "undefined" ) )
		{
			var nRespawnsRemaining = respawnData["respawns"]
			var bShowTombstone = false;
			if ( typeof( tombstoneData != "undefined" ) )
			{
				bShowTombstone = tombstoneData["tombstone"] == 1;
			}
			$( "#death_panel_buyback" ).SetDialogVariableInt( "respawns_remaining", nRespawnsRemaining );
			$( "#death_panel_buyback" ).FindChild( "BuybackLifeCost" ).heroname = Entities.GetUnitName( selectedUnitEntIndex );
			var LifeRemainingContainer = $( "#LifeRemainingContainer" );
			if ( LifeRemainingContainer !== null )
			{
				var i = 0;
				for ( i = 0; i < 5; i++ )
				{
					var LifeIconsContainer = LifeRemainingContainer.FindChild( "LifeIconsContainer" + i.toString() );
					var LifePanel = LifeIconsContainer.FindChild( "Life" + i.toString() );
					if ( LifePanel !== null )
					{
						LifePanel.heroname = Entities.GetUnitName( selectedUnitEntIndex );
						LifePanel.SetHasClass( "LifeUsed", i >= nRespawnsRemaining )
					}
					var TombstonePanel = LifeIconsContainer.FindChild( "Tombstone" + i.toString() );
					if ( TombstonePanel !== null )
					{
						TombstonePanel.SetHasClass( "Visible", bShowTombstone && i == nRespawnsRemaining );
					}
				}
			}
		}

		if ( Entities.IsAlive( selectedUnitEntIndex ) )
		{
			
		}
	}
}

function UpdateBossHP()
{
	var key = 0;
	var bossData = CustomNetTables.GetTableValue( "boss", key.toString() );
	if ( typeof( bossData ) != "undefined" )
	{
		var nBossHP = bossData["boss_hp"];
		var bShowBossHP = bossData["bosses_alive"] > 0 ? true : false;

		$( "#BossProgressBar" ).value = nBossHP / 100;
		$( "#BossHP").SetHasClass( "Visible", bShowBossHP );
	}
}

function BossHPTickUp()
{
	if ( $( "#BossProgressBar" ).value < 1.0 )
	{
		$( "#BossProgressBar" ).value = $( "#BossProgressBar" ).value + 0.025;
	}
}

function OnBossIntroBegin( data )
{
	$( "#BossProgressBar" ).value = 0;
	$( "#BossHP").SetHasClass( data["BossName"], true );
	$( "#BossIcon" ).SetHasClass( data["BossName"], true );
	$( "#BossLabel" ).text = $.Localize( data["BossName"] );
	
	if ( g_bInBossIntro === true )
		return;

	if ( data["SkipIntro"] )
		return;

	Game.EmitSound( "Dungeon.Stinger02" );
	Game.EmitSound( "Dungeon.BossBar" );

	$( "#BossHP").SetHasClass( "Visible", true );

	$( "#DialogPanel" ).SetHasClass( "Visible", data["DialogText"] != "" );
	//$( "#DialogTitle" ).text = $.Localize( Entities.GetUnitName( data["DialogEntIndex"] ) );
	g_nCurrentDialogEnt = data["DialogEntIndex"];
	g_nCurrentDialogLine = data["DialogLine"];
	//$( "#DialogLabel" ).text = $.Localize( data["DialogText"] );
	//$( "#DialogLabelSizer" ).text = $.Localize( data["DialogText"] );
	
	g_bInBossIntro = true;
	g_nBossCameraEntIndex = data["BossEntIndex"];

	if ( typeof( data["CameraPitch"] ) != "undefined" )
	{
		GameUI.SetCameraPitchMin( data["CameraPitch"] );
		GameUI.SetCameraPitchMax( data["CameraPitch"] );
	}
	if ( typeof( data["CameraDistance"] ) != "undefined" )
	{
		GameUI.SetCameraDistance( data["CameraDistance"] );
	}
	if ( typeof( data["CameraDistance"] ) != "undefined" )
	{
		GameUI.SetCameraLookAtPositionHeightOffset( data["CameraDistance"] );
	}
	
	
	UpdateCameraOffset();
}

GameEvents.Subscribe( "boss_intro_begin", OnBossIntroBegin );

function OnBossIntroEnd( data )
{
	g_bInBossIntro = false;
	g_nBossCameraEntIndex = -1;
	GameUI.SetCameraPitchMin( 38 );
	GameUI.SetCameraPitchMax( 60 );
	GameUI.SetCameraDistance( 1134.0 );
	GameUI.SetCameraLookAtPositionHeightOffset( 0 );
	$( "#DialogPanel" ).SetHasClass( "Visible", false );
	UpdateCameraOffset();
}

GameEvents.Subscribe( "boss_intro_end", OnBossIntroEnd );

function OnBossFightFinished( data )
{
	$( "#BossProgressBar" ).value = 0;
	$( "#BossHP").SetHasClass( data["BossName"], false );
	$( "#BossIcon" ).SetHasClass( data["BossName"], false );
	Game.EmitSound( "Dungeon.Stinger01" );
}

GameEvents.Subscribe( "boss_fight_finished", OnBossFightFinished );

var g_nCachedCameraEntIndex = -1;

function UpdateCameraOffset()
{
	var localCamFollowIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
	//handle spectators
	if ( Players.IsLocalPlayerInPerspectiveCamera() )
	{
		localCamFollowIndex = Players.GetPerspectivePlayerEntityIndex();
	}

	if ( g_nBossCameraEntIndex !== -1 )
	{
		localCamFollowIndex = g_nBossCameraEntIndex;
	}
	if ( localCamFollowIndex !== -1 )
	{
		if ( Entities.IsAlive( localCamFollowIndex ) === false )
			return;

		var vDesiredLookAtPosition = Entities.GetAbsOrigin( localCamFollowIndex );
		var vLookAtPos = GameUI.GetCameraLookAtPosition();
		var flCurOffset = GameUI.GetCameraLookAtPositionHeightOffset();
		var flCameraRawHeight = vLookAtPos[2] - flCurOffset;
		var flEntityHeight = vDesiredLookAtPosition[2];
		vDesiredLookAtPosition[1] = vDesiredLookAtPosition[1] - 180.0;
		
		var bMouseWheelDown = GameUI.IsMouseDown( 2 );
		if ( bMouseWheelDown )
		{
			var vScreenWorldPos = GameUI.GetScreenWorldPosition( GameUI.GetCursorPosition() );
			if ( vScreenWorldPos !== null )
			{
				var vToCursor = [];
				vToCursor[0] = vScreenWorldPos[0] - vDesiredLookAtPosition[0];
				vToCursor[1] = vScreenWorldPos[1] - vDesiredLookAtPosition[1];
				vToCursor[2] = vScreenWorldPos[2] - vDesiredLookAtPosition[2];
				vToCursor = Game.Normalized( vToCursor );
				var flDistance = Math.min( Game.Length2D( vScreenWorldPos, vDesiredLookAtPosition ), g_flMaxLookDistance );
				vDesiredLookAtPosition[0] = vDesiredLookAtPosition[0] + vToCursor[0] * flDistance;
				vDesiredLookAtPosition[1] = vDesiredLookAtPosition[1] + vToCursor[1] * flDistance;
				vDesiredLookAtPosition[2] = vDesiredLookAtPosition[2] + vToCursor[2] * flDistance;
			}
		}

		var flHeightDiff = flCameraRawHeight - flEntityHeight;
		var flNewOffset = g_flCameraDesiredOffset - flHeightDiff + 50;
		var key = 0;
		var bossData = CustomNetTables.GetTableValue("boss", key.toString());
		var flAdditionalOffset = 0.0;
		if ( typeof( bossData ) != "undefined" )
		{
			var bShowBossHP = bossData["boss_hp"] == 0 ? false : true;
			if ( bShowBossHP )
			{
			    flAdditionalOffset = 100.0;
			}
		}

		var t = Game.GetGameFrameTime() / 1.5;
		if ( t > 1.0 ) { t = 1.0; }

		g_flAdditionalCameraOffset = g_flAdditionalCameraOffset * t + flAdditionalOffset * ( 1.0 - t ); 
		flNewOffset = flNewOffset + g_flAdditionalCameraOffset;

		var flLerp = 0.05;
		if ( bMouseWheelDown )
		{
			flLerp = 0.1;
		}
		if ( g_nCachedCameraEntIndex !== localCamFollowIndex )
		{
			flLerp = 1.5;
		}

		GameUI.SetCameraTargetPosition(vDesiredLookAtPosition, flLerp);
		GameUI.SetCameraLookAtPositionHeightOffset( flNewOffset );

		g_nCachedCameraEntIndex = localCamFollowIndex;
	}
	else
	{
		GameUI.SetCameraLookAtPositionHeightOffset( 0.0 );
	}
}

GameEvents.Subscribe( "boss_intro_end", OnBossIntroEnd );

function HideScroll( data )
{
	$.Msg( "HideScroll" );
	var hitBoxPanel = $( '#TPScrollHitbox' );
	hitBoxPanel.RemoveClass( "MakeVisible" );			
	var clickHint = $( '#ClickHint' );
	clickHint.AddClass( "QuickHide" );

	var scenePanelContainer = $( '#TPScrollContainer' );
	scenePanelContainer.AddClass( "CollapsePanel" );
}

GameEvents.Subscribe( "hide_scroll", HideScroll );

function OnCheckpointActivated( data )
{
	$.Schedule( 3.0, HideCheckpointActivation );
}

GameEvents.Subscribe( "checkpoint_activated", OnCheckpointActivated );

function HideCheckpointActivation()
{
}

function OnGainedLife( data )
{
	var panel = $( '#1UpPopup' );
	panel.SetHasClass( "Play1Up", true );
	var heroImage = $( '#1UpHeroIcon' );
	var heroImageShadow = $( '#1UpHeroIconOutline' );
	var localPlayerInfo = Game.GetLocalPlayerInfo();
	var heroName = Players.GetPlayerSelectedHero( localPlayerInfo.player_id );
	heroImage.heroname = heroName;
	heroImageShadow.heroname = heroName;
	Game.EmitSound( "Dungeon.Plus1" );
	$.Schedule( 3.0, HideGainedLife );
}

GameEvents.Subscribe( "gained_life", OnGainedLife );

function HideGainedLife()
{
	var panel = $( '#1UpPopup' );
	panel.SetHasClass( "Play1Up", false );
}

function OnLostLife( data )
{
	var panel = $( '#1UpPopup' );
	panel.SetHasClass( "Play1Up", true );
	panel.SetHasClass( "LifeLost", true );
	var heroImage = $( '#1UpHeroIcon' );
	var heroImageShadow = $( '#1UpHeroIconOutline' );
	var localPlayerInfo = Game.GetLocalPlayerInfo();
	var heroName = Players.GetPlayerSelectedHero( localPlayerInfo.player_id );
	heroImage.heroname = heroName;
	heroImageShadow.heroname = heroName;
	//Game.EmitSound( "Dungeon.Plus1" );
	$.Schedule( 3.0, HideLostLife );
}

GameEvents.Subscribe( "life_lost", OnLostLife );

function HideLostLife()
{
	var panel = $( '#1UpPopup' );
	panel.SetHasClass( "Play1Up", false );
	panel.SetHasClass( "LifeLost", false );
}

var g_vWestPos = null;
var g_vEastPos = null;
var g_vSouthPos = null;
var g_vNorthPos = null;

function UpdateCryptHoldout()
{
	var westData = CustomNetTables.GetTableValue( "crypt_holdout", "crypt_holdout_west_trigger" );
	var westProgressBar = $( '#CryptHoldoutWest' );
	if ( typeof( westData ) != "undefined" )
	{
		var flPctComplete = westData["PercentComplete"];
		westProgressBar.value = flPctComplete;
		westProgressBar.SetHasClass( "ButtonActivated", flPctComplete > 0.0 );
		if ( g_vWestPos === null )
		{
			g_vWestPos = [ westData["X"], westData["Y"], westData["Z"] ];
		}

		var nX = Game.WorldToScreenX( g_vWestPos[0], g_vWestPos[1], g_vWestPos[2] );
		var nY = Game.WorldToScreenY( g_vWestPos[0], g_vWestPos[1], g_vWestPos[2] );
		westProgressBar.style.x = ( nX / westProgressBar.actualuiscale_x ) - 50 + "px"; 
		westProgressBar.style.y = ( nY / westProgressBar.actualuiscale_x ) + 100 + "px"; 
	}
	else
	{
		westProgressBar.SetHasClass( "ButtonActivated", false );
	}

	var eastData = CustomNetTables.GetTableValue( "crypt_holdout", "crypt_holdout_east_trigger" );
	var eastProgressBar = $( '#CryptHoldoutEast' );
	if ( typeof( eastData ) != "undefined" )
	{
		var flPctComplete = eastData["PercentComplete"];
		eastProgressBar.value = flPctComplete;
		eastProgressBar.SetHasClass( "ButtonActivated", flPctComplete > 0.0  );
		if ( g_vEastPos === null )
		{
			g_vEastPos = [ eastData["X"], eastData["Y"], eastData["Z"] ];
			
		}
		var nX = Game.WorldToScreenX( g_vEastPos[0], g_vEastPos[1], g_vEastPos[2] );
		var nY = Game.WorldToScreenY( g_vEastPos[0], g_vEastPos[1], g_vEastPos[2] );
		eastProgressBar.style.x = ( nX / eastProgressBar.actualuiscale_x ) - 50 + "px"; 
		eastProgressBar.style.y = ( nY / eastProgressBar.actualuiscale_x ) + 100 + "px"; 
	}
	else
	{
		eastProgressBar.SetHasClass( "ButtonActivated", false );
	}

	var northData = CustomNetTables.GetTableValue( "crypt_holdout", "crypt_holdout_north_trigger" );
	var northProgressBar = $( '#CryptHoldoutNorth' );
	if ( typeof( northData ) != "undefined" )
	{
		var flPctComplete = northData["PercentComplete"];
		northProgressBar.value = flPctComplete;
		northProgressBar.SetHasClass( "ButtonActivated", flPctComplete > 0.0  );
		if ( g_vNorthPos === null )
		{
			g_vNorthPos = [ northData["X"], northData["Y"], northData["Z"] ];
			
		}
		var nX = Game.WorldToScreenX( g_vNorthPos[0], g_vNorthPos[1], g_vNorthPos[2] );
		var nY = Game.WorldToScreenY( g_vNorthPos[0], g_vNorthPos[1], g_vNorthPos[2] );
		northProgressBar.style.x = ( nX / northProgressBar.actualuiscale_x ) - 50 + "px"; 
		northProgressBar.style.y = ( nY / northProgressBar.actualuiscale_x ) + 100 + "px"; 
	}
	else
	{
		northProgressBar.SetHasClass( "ButtonActivated", false );
	}

	var southData = CustomNetTables.GetTableValue( "crypt_holdout", "crypt_holdout_south_trigger" );
	var southProgressBar = $( '#CryptHoldoutSouth' );
	if ( typeof( southData ) != "undefined" )
	{
		var flPctComplete = southData["PercentComplete"];
		southProgressBar.value = flPctComplete;
		southProgressBar.SetHasClass( "ButtonActivated", flPctComplete > 0.0  );
	
		if ( g_vSouthPos === null )
		{
			g_vSouthPos = [ southData["X"], southData["Y"], southData["Z"] ];	
		}
		var nX = Game.WorldToScreenX( g_vSouthPos[0], g_vSouthPos[1], g_vSouthPos[2] );
		var nY = Game.WorldToScreenY( g_vSouthPos[0], g_vSouthPos[1], g_vSouthPos[2] );
		southProgressBar.style.x = ( nX / southProgressBar.actualuiscale_x ) - 50 + "px"; 
		southProgressBar.style.y = ( nY / southProgressBar.actualuiscale_x ) + 100 + "px"; 
	}
	else
	{
		southProgressBar.SetHasClass( "ButtonActivated", false );
	}
}


CustomNetTables.SubscribeNetTableListener( "crypt_holdout", UpdateCryptHoldout )

