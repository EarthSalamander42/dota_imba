"use strict";
/* This file contains the scripts associated with hero_selection.xml.
 * This UI element provides a custom hero selection screen.
 *
 * By: Perry
 * Date: July 2015 */

//Define variables
var playerPanels = {};
var canEnter = false;

//Subscribe to events
GameEvents.Subscribe( "picking_done", OnPickingDone );
GameEvents.Subscribe( "hero_loading_done", OnHeroLoadingDone );
GameEvents.Subscribe( "picking_time_update", OnTimeUpdate );
GameEvents.Subscribe( "hero_picked", OnHeroPicked );
GameEvents.Subscribe( "hero_unpicked", OnHeroUnpicked );
GameEvents.Subscribe( "player_reconnected", OnPlayerReconnect );

/* Event Handlers
=========================================================================*/

/* Picking phase is done, start loading heroes */
function OnPickingDone( data ) {
	$("#EnterGameBtnTxt").text = $.Localize( "#imba_loading_heroes_button" );
	$("#RepickBtn").AddClass( "disabled" );
}

/* Hero loading is done, allow the player to enter the game */
function OnHeroLoadingDone( data ) {
	$("#EnterGameBtn").RemoveClass( "disabled" );
	$("#EnterGameBtnTxt").text = $.Localize( "#imba_enter_game_button" );
	canEnter = true;
}

/* Visual timer update */
function OnTimeUpdate( data ) {
	$("#TimerTxt").text = data.time;
}

/* A player has picked a hero */
function OnHeroPicked( data ) {
	HeroPicked( data.PlayerID, data.HeroName, data.Team );
}

/* A player has un-picked a hero */
function OnHeroUnpicked( data ) {
	OnHeroUnpicked( data.PlayerID, data.HeroName, data.Team );
}

/* A player has reconnected to the game */
function OnPlayerReconnect( data ) {
	PlayerReconnected( data.PlayerID, data.PickedHeroes, data.PlayerPicks, data.pickState, data.repickState);
}

/* Functionality
=========================================================================*/

/* Add an empty element for each player in the game (steam avatar plus space for hero portrait) */
function LoadPlayers() {
	//Get the players for both teams
	var radiantPlayers = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_GOODGUYS );
	var direPlayers = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_BADGUYS );

	//Assign radiant players
	$.Each( radiantPlayers, function( player ) {
		var playerPanel = Modular.Spawn( "picking_player", $("#LeftPlayers") );
		playerPanel.SetPlayer( player );

		//Save the panel for later
		playerPanels[player] = playerPanel;
	});

	//Assign dire players
	$.Each( direPlayers, function( player ) {
		var playerPanel = Modular.Spawn( "picking_player", $("#RightPlayers") );
		playerPanel.SetPlayer( player );
		playerPanel.SetIsRight( true );

		//Save the panel for later
		playerPanels[player] = playerPanel;
	});
}

/* A player on the same team has picked a hero, tell the player's panel a hero was picked,
 * show the hero was taken and if the player that picked is the local player
 * swap to the hero preview screen. */
function HeroPicked(player, hero, team) {

	// Update the player panel and hero selection, if appropriate
	if ( player != null ) {
		playerPanels[player].SetHero(hero);
	}

	// Disable the hero button for the player's team
	var LocalPlayer = Players.GetLocalPlayer()
	if ( Players.GetTeam(LocalPlayer) == team) {
		$('#'+hero).AddClass("taken");
	}

	// Check if the pick was by the local player
	if ( player == LocalPlayer ) {
		SwitchToHeroPreview(hero);
	}
}

/* A player on the same team has picked a hero, tell the player's panel a hero was picked,
 * show the hero was taken and if the player that picked is the local player
 * swap to the hero preview screen. */
function OnHeroUnpicked(player, hero, team) {

	// Update the player panel and hero selection, if appropriate
	if ( player != null ) {
		playerPanels[player].SetHero(null);
	}

	// Disable the hero button for the player's team
	if ( Players.GetTeam(Players.GetLocalPlayer()) == team) {
		var parent_panel = $.GetContextPanel().GetParent().GetParent()
		parent_panel.FindChildTraverse(hero).RemoveClass( "taken" );
	}
}

/* Switch the content of the screen to show the picked hero instead of the
 * pickable heroes. */
function SwitchToHeroPreview( heroName ) {
	var previewPanel = $.CreatePanel("Panel", $('#PostPickScreen'), "HeroPreview");
	previewPanel.BLoadLayoutFromString('<root><Panel><DOTAScenePanel style="width: 600px; height: 600px; opacity-mask: url(\'s2r://panorama/images/masks/softedge_box_png.vtex\');" map="background" camera="camera_01" unit="'+heroName+'"/></Panel></root>', false, false );

	$('#PostPickScreen').MoveChildBefore( previewPanel, $("#EnterGameBtn") );

	var parent_panel = $.GetContextPanel().GetParent().GetParent()
	parent_panel.FindChildTraverse("ImbaPickListText").style.visibility = "collapse";
	$('#PickList').style.visibility = 'collapse';
	$('#PostPickScreen').style.visibility = 'visible';
}

/* Select a hero, called when a player clicks a hero panel in the layout */
function SelectHero( heroName ) {

	//Send the pick to the server, if it is available
	var parent_panel = $.GetContextPanel().GetParent().GetParent()
	var selected_panel = parent_panel.FindChildTraverse(heroName)
	if (selected_panel.BHasClass( "taken" ) == false) {
		GameEvents.SendCustomGameEventToServer( "hero_selected", { HeroName: heroName} );
	}
}

/* Go back to the pick screen, called when a player clicks the repick button */
function RepickHero() {

	// If this player has already repicked, do nothing
	if ($("#RepickBtn").BHasClass( "disabled" ) == false) {

		// Send the repick event to the server
		GameEvents.SendCustomGameEventToServer("hero_repicked", {} );

		// Disable the repick button
		$("#RepickBtn").AddClass("disabled");

		// Show the hero pick menu again
		$('#HeroPreview').DeleteAsync( 0.0 );
		$('#ImbaPickListText').style.visibility = 'visible';
		$('#PickList').style.visibility = 'visible';
		$('#PostPickScreen').style.visibility = 'collapse';
	}
}

/* Random a hero, called when a player clicks the random hero button */
function SelectRandomHero() {
	GameEvents.SendCustomGameEventToServer("hero_randomed", {});
}

/* Enter the game by removing the picking screen, called when the player
 * clicks a button in the layout. */
function EnterGame() {
	if ( canEnter ) {
		$('#Background').DeleteAsync( 0.0 );
		$.GetContextPanel().GetParent().GetParent().FindChildTraverse("ScoreboardContainer").style.visibility = "visible";
	}
}

function PlayerReconnected(player_id, picked_heroes, player_picks, pick_state, repick_state) {

	// If this is not the local player, ignore everything
	if ( player_id == Players.GetLocalPlayer() ) {
		
		// If the player is already in-game, destroy the pick interface and ignore the rest
		if (pick_state == "in_game") {
			$('#Background').DeleteAsync( 0.0 );
			$.GetContextPanel().GetParent().GetParent().FindChildTraverse("ScoreboardContainer").style.visibility = "visible";

		// Else, repopulate player pick panels
		} else {
			var i = 1;
			var j = 1;
			for (i = 1; i <= player_picks.length; i++) {
				if (player_picks[i] != null) {
					playerPanels[i].SetHero(player_picks[i])
				}
			}

			// If the player has already repicked, make the repick button unavailable
			if (repick_state) {
				$("#RepickBtn").AddClass("disabled");
			}

			// If the player has already selected a hero, go to the hero preview screen
			if (pick_state == "selected_hero" && player_picks[player_id] != null) {
				SwitchToHeroPreview(player_picks[player_id])
			}

			// Gray out heroes already selected by the player's team
			for (j = 1; j <= picked_heroes.length; j++) {
				if (picked_heroes[i] != null) {
					$('#'+picked_heroes[i]).AddClass("taken");
				}
			}
		}
	}
}

/* Initialisation - runs when the element is created
=========================================================================*/
(function () {
	// Set panel visibility
	$('#PickList').style.visibility = 'visible';
	$('#PostPickScreen').style.visibility = 'collapse';

	///Load player elements
	LoadPlayers();

	// Show only map-specific elements
	var parent_panel = $.GetContextPanel().GetParent().GetParent()
	var map_info = Game.GetMapInfo();

	if (map_info.map_display_name == "imba_random_omg") {
		parent_panel.FindChildTraverse("HeroSelectTextRandomOmg").style.visibility = "visible";
	} else if (map_info.map_display_name == "imba_arena") {
		parent_panel.FindChildTraverse("HeroSelectTextArenaMode").style.visibility = "visible";
	} else {
		parent_panel.FindChildTraverse("HeroSelectTextAllPick").style.visibility = "visible";
	}

	// Hide the top scoreboard during the pick phase
	parent_panel.FindChildTraverse("ScoreboardContainer").style.visibility = "collapse";

	// Tell the server this player's UI was initialized
	GameEvents.SendCustomGameEventToServer( "ui_initialized", {} );
})();