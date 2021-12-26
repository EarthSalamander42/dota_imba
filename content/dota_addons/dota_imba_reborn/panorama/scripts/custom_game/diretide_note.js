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

	$( "#DialogPanel" ).SetHasClass( "Visible", g_bSentToAll || data["JournalEntry"] );
	$( "#FloatingDialogPanel" ).SetHasClass( "Visible", !g_bSentToAll && !data["JournalEntry"] );
	$( "#DialogPanel" ).SetHasClass( "JournalEntry", data["JournalEntry"] );
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
		var szHeroLocalizedDialog = $.Localize( data["DialogText"] );
		if ( szHeroLocalizedDialog !== ( data["DialogText"] ) )
		{
			g_szPendingDialog = szHeroLocalizedDialog;
		}
		if ( data["JournalEntry"] )
		{
			g_nCurrentCharacter = g_szPendingDialog.length;
		}
	}

	g_flDialogAdvanceTime = Game.GetGameTime() + data["DialogAdvanceTime"];

	$.Schedule( g_flCharacterAdvanceRate, AdvanceDialogThink );
}

function OnCloseDialogButtonPressed()
{
	$( "#DialogPanel" ).SetHasClass( "Visible", false );
	$( "#FloatingDialogPanel" ).SetHasClass( "Visible", false );	
	GameEvents.SendCustomGameEventToServer( "dialog_complete", { DialogEntIndex : g_nCurrentDialogEnt, DialogLine : g_nCurrentDialogLine, ShowNextLine : false, PlayerHeroEntIndex : Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ) } );
}

GameEvents.Subscribe( "dialog", OnDialogReceived );

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