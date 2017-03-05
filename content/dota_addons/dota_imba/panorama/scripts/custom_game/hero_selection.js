"use strict";
/* This file contains the scripts associated with hero_selection.xml.
 * This UI element provides a custom hero selection screen.
 *
 * By: Perry
 * Date: July 2015 */

//Define variables
var playerPanels = {};
var canEnter = false;
var selectedHero = null;
var abilityPanels = [ 
	$('#PickedHeroAbility1'),
	$('#PickedHeroAbility2'),
	$('#PickedHeroAbility3'),
	$('#PickedHeroAbility4'),
	$('#PickedHeroAbility5'),
	$('#PickedHeroAbility6') ]

//Subscribe to events
GameEvents.Subscribe( "picking_done", OnPickingDone );
GameEvents.Subscribe( "hero_loading_done", OnHeroLoadingDone );
GameEvents.Subscribe( "picking_time_update", OnTimeUpdate );
GameEvents.Subscribe( "hero_picked", OnHeroPicked );
GameEvents.Subscribe( "hero_unpicked", OnHeroUnpicked );
GameEvents.Subscribe( "player_reconnected", OnPlayerReconnect );
GameEvents.Subscribe( "pick_abilities", OnReceiveAbilities );

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
	HeroPicked( data.PlayerID, data.HeroName, data.Team, data.HasRandomed);
}

/* A player has un-picked a hero */
function OnHeroUnpicked( data ) {
	HeroUnpicked( data.PlayerID, data.HeroName, data.Team );
}

/* A player has reconnected to the game */
function OnPlayerReconnect( data ) {
	PlayerReconnected( data.PlayerID, data.PickedHeroes, data.PlayerPicks, data.pickState, data.repickState);
}

/* A player has received the list of nonhidden abilities for the selected hero */
function OnReceiveAbilities( data ) {
	UpdateAbilities( data.heroAbilities);
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
function HeroPicked(player, hero, team, has_randomed) {

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

		// If the player has randomed, set up hero portrait/ability information
		if (has_randomed) {
			SelectHero(hero)
		}

		// Switch to hero preview state
		SwitchToHeroPreview(hero);
	}
}

/* A player on the same team has picked a hero, tell the player's panel a hero was picked,
 * show the hero was taken and if the player that picked is the local player
 * swap to the hero preview screen. */
function HeroUnpicked(player, hero, team) {

	// Re-enable the hero button for the player's team
	if ( Players.GetTeam(Players.GetLocalPlayer()) == team) {
		var parent_panel = $.GetContextPanel().GetParent().GetParent()
		parent_panel.FindChildTraverse(hero).RemoveClass( "taken" );
	}

	// Update the player panel and hero selection, if appropriate
	if ( player != null ) {
		playerPanels[player].SetHero(null);
	}
}

/* Switch the content of the screen to show the picked hero instead of the
 * pickable heroes. */
function SwitchToHeroPreview( heroName ) {
	var previewPanel = $.CreatePanel("Panel", $('#PostPickScreen'), "HeroPreview");
	previewPanel.BLoadLayoutFromString('<root><Panel><DOTAScenePanel style="width: 600px; height: 600px; opacity-mask: url(\'s2r://panorama/images/masks/softedge_box_png.vtex\');" map="background" camera="camera_01" unit="'+heroName+'"/></Panel></root>', false, false );

	$('#PostPickScreen').MoveChildBefore( previewPanel, $("#EnterGameBtn") );

	// Hide/show relevant panels
	$("#PickHeroBtn").style.visibility = 'collapse';
	$('#PickList').style.visibility = 'collapse';
	$('#PostPickScreen').style.visibility = 'visible';
}

/* Select a hero, called when a player clicks a hero panel in the layout */
function SelectHero( heroName ) {

	// Do nothing if this hero is not available for the player's team
	var all_random_enabled = CustomNetTables.GetTableValue( "game_options", "all_random" );
	var selected_panel = $("#PickList").FindChildTraverse(heroName)
	if (selected_panel.BHasClass( "taken" ) || (all_random_enabled != null && all_random_enabled[1] == 1)) {
		$('#PickHeroBtn').AddClass("disabled");
	} else {
		$('#PickHeroBtn').RemoveClass("disabled");
	}

	// Set the appropriate hero image
	$("#PickedHeroImage").heroname = heroName;
	$("#PickedHeroImage").style.visibility = 'visible';

	// Update the hero name
	$("#PickedHeroName").text = $.Localize( heroName );
	selectedHero = heroName;

	// Make the abilities panel visible
	$("#HeroAbilitiesParentPanel").style.visibility = 'visible';

	// Request the hero's abilities table to the server 
	GameEvents.SendCustomGameEventToServer("pick_abilities_requested", { HeroName: heroName} );
}

/* Updates the selected hero abilities panel */
function UpdateAbilities(abilityList) {
	for ( var i = 1; i <= 6; i++ ) {
		var j = parseInt(i)
		var abilityPanel = abilityPanels[i-1]
		var ability = abilityList[j]
		if ( ability != null ) {
			abilityPanel.abilityname = ability;
			abilityPanel.style.visibility = 'visible';
			(function (abilityPanel, ability) {
				abilityPanel.SetPanelEvent("onmouseover", function() {
					$.DispatchEvent("DOTAShowAbilityTooltip", abilityPanel, ability);
				})
				abilityPanel.SetPanelEvent("onmouseout", function() {
					$.DispatchEvent("DOTAHideAbilityTooltip", abilityPanel);
				})
			})(abilityPanel, ability);
		} else {
			abilityPanel.abilityname = null;
			abilityPanel.style.visibility = 'collapse';
			abilityPanel.onmouseover = null;
		}
	}
}

/* Pick a hero, called when a player confirms his hero selection */
function PickHero() {

	// Send the pick to the server, if it is available
	if ($("#PickHeroBtn").BHasClass( "disabled" ) == false) {
		var selected_panel = $("#PickList").FindChildTraverse(selectedHero)
		if (selected_panel.BHasClass( "taken" ) == false) {
			GameEvents.SendCustomGameEventToServer( "hero_selected", { HeroName: selectedHero, HasRandomed: false} );
		}
	}
}

/* Go back to the pick screen, called when a player clicks the repick button */
function RepickHero() {

	// If this player has already repicked, do nothing
	if ($("#RepickBtn").BHasClass( "disabled" ) == false) {

		// Send the repick event to the server
		GameEvents.SendCustomGameEventToServer("hero_repicked", {} );

		// Reset the hero selection image
		$("#PickedHeroImage").heroname = null;

		// Update the hero name
		$("#PickedHeroName").text = $.Localize( "imba_hero_name_filler" );
		selectedHero = null;

		// Make the abilities panel invisible
		$("#HeroAbilitiesParentPanel").style.visibility = 'collapse';

		// Disable the repick button
		$("#RepickBtn").AddClass("disabled");

		// Re-enable the "select hero" button
		$("#PickHeroBtn").style.visibility = 'visible';

		// Show the hero pick menu again
		$('#HeroPreview').DeleteAsync( 0.0 );
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
		$('#Background').GetParent().DeleteAsync( 0.0 );
		$.GetContextPanel().GetParent().GetParent().FindChildTraverse("ScoreboardContainer").style.visibility = "visible";
	}
}

function PlayerReconnected(player_id, picked_heroes, player_picks, pick_state, repick_state) {

	// If this is not the local player, ignore everything
	if ( player_id == Players.GetLocalPlayer() ) {
		
		// If the player is already in-game, destroy the pick interface and ignore the rest
		if (pick_state == "in_game") {
			$('#Background').GetParent().DeleteAsync( 0.0 );
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

	// If this player is a spectator, just kill the whole pick screen
	if ( Players.IsSpectator( Players.GetLocalPlayer() ) ) {
		$('#Background').GetParent().DeleteAsync( 0.0 );

	// Else, do pick screen stuff
	} else {

		// Set panel visibility
		$('#PickList').style.visibility = 'visible';
		$('#PostPickScreen').style.visibility = 'collapse';

		///Load player elements
		LoadPlayers();

		// Show only map-specific elements
		var parent_panel = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent()
		var map_info = Game.GetMapInfo();

		if (map_info.map_display_name == "imba_random_omg") {
			$('#HeroSelectText').text = $.Localize( '#imba_gamemode_name_random_omg' );
		} else if (map_info.map_display_name == "imba_arena") {
			$('#HeroSelectText').text = $.Localize( '#imba_gamemode_name_arena_mode' );
		}

		// Hide the top scoreboard during the pick phase
		parent_panel.FindChildTraverse("ScoreboardContainer").style.visibility = "collapse";

		// Update the game options display
		var bounty_multiplier = CustomNetTables.GetTableValue("game_options", "bounty_multiplier");
		var creep_power = CustomNetTables.GetTableValue("game_options", "creep_power");
		var tower_power = CustomNetTables.GetTableValue("game_options", "tower_power");
		var respawn_multiplier = CustomNetTables.GetTableValue("game_options", "respawn_multiplier");
		var initial_gold = CustomNetTables.GetTableValue("game_options", "initial_gold");
		var initial_level = CustomNetTables.GetTableValue("game_options", "initial_level");
		var max_level = CustomNetTables.GetTableValue("game_options", "max_level");
		var kills_to_end = CustomNetTables.GetTableValue("game_options", "kills_to_end");
		$("#BountyMultiplierValue").text = bounty_multiplier[1] + "%";
		$("#RespawnTimerValue").text = respawn_multiplier[1] + "%";
		$("#InitialGoldValue").text = initial_gold[1];
		$("#InitialLevelValue").text = initial_level[1];
		$("#MaxLevelValue").text = max_level[1];

		if (tower_power[1] == 0) {
			$("#TowerPowerValue").text = $.Localize( '#imba_gamemode_settings_power_1' );
		} else if (tower_power[1] == 1) {
			$("#TowerPowerValue").text = $.Localize( '#imba_gamemode_settings_power_2' );
		} else if (tower_power[1] == 2) {
			$("#TowerPowerValue").text = $.Localize( '#imba_gamemode_settings_power_3' );
		}

		if (map_info.map_display_name == "imba_arena") {
			$("#CreepPowerLabel").text = $.Localize( '#imba_gamemode_settings_kills_to_end' );
			$("#CreepPowerValue").text = kills_to_end[1];
		} else if (creep_power[1] == 1) {
			$("#CreepPowerValue").text = $.Localize( '#imba_gamemode_settings_power_1' );
		} else if (creep_power[1] == 2) {
			$("#CreepPowerValue").text = $.Localize( '#imba_gamemode_settings_power_2' );
		} else if (creep_power[1] == 3) {
			$("#CreepPowerValue").text = $.Localize( '#imba_gamemode_settings_power_3' );
		}

		// If All Random is enabled, pick a random hero
		var all_random_enabled = CustomNetTables.GetTableValue("game_options", "all_random" );
		if (all_random_enabled != null && all_random_enabled[1] == 1) {
			$("#PickHeroBtn").AddClass( "disabled" );
			$("#RepickBtn").AddClass( "disabled" );
			$('#HeroSelectText').text = $.Localize( '#imba_gamemode_name_all_random' );
			$.Schedule(5, SelectRandomHero);
		}

		// Tell the server this player's UI was initialized
		GameEvents.SendCustomGameEventToServer( "ui_initialized", {} );
	}
})();