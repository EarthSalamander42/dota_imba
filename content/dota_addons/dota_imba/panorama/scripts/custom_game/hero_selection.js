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
GameEvents.Subscribe( "picking_player_pick", OnPlayerPicked );

/* Event Handlers
=========================================================================*/

/* Picking phase is done, start loading heroes */
function OnPickingDone( data ) {
	$("#EnterGameBtnTxt").text = $.Localize( "#imba_loading_heroes_button" );
}

/* Hero loading is done, allow the player to enter the game */
function OnHeroLoadingDone( data ) {
	$("#EnterGameBtn").RemoveClass( "disabled" );
	$("#EnterGameBtnTxt").text = $.Localize( "#imba_enter_game_button" );
}

/* Visual timer update */
function OnTimeUpdate( data ) {
	$("#TimerTxt").text = data.time;
	if (data.time <= 0) {
		canEnter = true;
	}
}

/* A player has picked a hero */
function OnPlayerPicked( data ) {
	PlayerPicked( data.PlayerID, data.HeroName );
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

/* A player has picked a hero, tell the player's panel a hero was picked,
 * show the hero was taken and if the player that picked is the local player
 * swap to the hero preview screen. */
function PlayerPicked( player, hero ) {
	//Update the player panel
	playerPanels[player].SetHero( hero );

	//Disable the hero button
	$('#'+hero).AddClass( "taken" );

	//Check if the pick was by the local player
	if ( player == Players.GetLocalPlayer() ) {
		SwitchToHeroPreview( hero );
	}
}

/* Switch the content of the screen to show the picked hero instead of the
 * pickable heroes. */
function SwitchToHeroPreview( heroName ) {
	var previewPanel = $.CreatePanel("Panel", $('#PostPickScreen'), "HeroPreview");
	previewPanel.BLoadLayoutFromString('<root><Panel><DOTAScenePanel style="width: 600px; height: 600px; opacity-mask: url(\'s2r://panorama/images/masks/softedge_box_png.vtex\');" unit="'+heroName+'"/></Panel></root>', false, false );

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
		GameEvents.SendCustomGameEventToServer( "hero_selected", { HeroName: heroName, HasRandomed: false } );
	}
}

/* Random a hero, called when a player clicks the random hero button */
function SelectRandomHero() {
	var valid_heroes = [
		"npc_dota_hero_alchemist",
		"npc_dota_hero_ancient_apparition",
		"npc_dota_hero_antimage",
		"npc_dota_hero_axe",
		"npc_dota_hero_bane",
		"npc_dota_hero_beastmaster",
		"npc_dota_hero_bloodseeker",
		"npc_dota_hero_chen",
		"npc_dota_hero_crystal_maiden",
		"npc_dota_hero_dark_seer",
		"npc_dota_hero_dazzle",
		"npc_dota_hero_dragon_knight",
		"npc_dota_hero_doom_bringer",
		"npc_dota_hero_drow_ranger",
		"npc_dota_hero_earthshaker",
		"npc_dota_hero_enchantress",
		"npc_dota_hero_enigma",
		"npc_dota_hero_faceless_void",
		"npc_dota_hero_furion",
		"npc_dota_hero_juggernaut",
		"npc_dota_hero_kunkka",
		"npc_dota_hero_leshrac",
		"npc_dota_hero_lich",
		"npc_dota_hero_life_stealer",
		"npc_dota_hero_lina",
		"npc_dota_hero_lion",
		"npc_dota_hero_mirana",
		"npc_dota_hero_morphling",
		"npc_dota_hero_necrolyte",
		"npc_dota_hero_nevermore",
		"npc_dota_hero_night_stalker",
		"npc_dota_hero_omniknight",
		"npc_dota_hero_puck",
		"npc_dota_hero_pudge",
		"npc_dota_hero_pugna",
		"npc_dota_hero_rattletrap",
		"npc_dota_hero_razor",
		"npc_dota_hero_riki",
		"npc_dota_hero_sand_king",
		"npc_dota_hero_shadow_shaman",
		"npc_dota_hero_slardar",
		"npc_dota_hero_sniper",
		"npc_dota_hero_spectre",
		"npc_dota_hero_storm_spirit",
		"npc_dota_hero_sven",
		"npc_dota_hero_tidehunter",
		"npc_dota_hero_tinker",
		"npc_dota_hero_tiny",
		"npc_dota_hero_vengefulspirit",
		"npc_dota_hero_venomancer",
		"npc_dota_hero_viper",
		"npc_dota_hero_weaver",
		"npc_dota_hero_windrunner",
		"npc_dota_hero_witch_doctor",
		"npc_dota_hero_zuus",
		"npc_dota_hero_broodmother",
		"npc_dota_hero_skeleton_king",
		"npc_dota_hero_queenofpain",
		"npc_dota_hero_huskar",
		"npc_dota_hero_jakiro",
		"npc_dota_hero_batrider",
		"npc_dota_hero_warlock",
		"npc_dota_hero_death_prophet",
		"npc_dota_hero_ursa",
		"npc_dota_hero_bounty_hunter",
		"npc_dota_hero_silencer",
		"npc_dota_hero_spirit_breaker",
		"npc_dota_hero_invoker",
		"npc_dota_hero_clinkz",
		"npc_dota_hero_obsidian_destroyer",
		"npc_dota_hero_shadow_demon",
		"npc_dota_hero_lycan",
		"npc_dota_hero_lone_druid",
		"npc_dota_hero_brewmaster",
		"npc_dota_hero_phantom_lancer",
		"npc_dota_hero_treant",
		"npc_dota_hero_ogre_magi",
		"npc_dota_hero_chaos_knight",
		"npc_dota_hero_phantom_assassin",
		"npc_dota_hero_gyrocopter",
		"npc_dota_hero_rubick",
		"npc_dota_hero_luna",
		"npc_dota_hero_wisp",
		"npc_dota_hero_disruptor",
		"npc_dota_hero_undying",
		"npc_dota_hero_templar_assassin",
		"npc_dota_hero_naga_siren",
		"npc_dota_hero_nyx_assassin",
		"npc_dota_hero_keeper_of_the_light",
		"npc_dota_hero_visage",
		"npc_dota_hero_meepo",
		"npc_dota_hero_magnataur",
		"npc_dota_hero_centaur",
		"npc_dota_hero_slark",
		"npc_dota_hero_shredder",
		"npc_dota_hero_medusa",
		"npc_dota_hero_troll_warlord",
		"npc_dota_hero_tusk",
		"npc_dota_hero_bristleback",
		"npc_dota_hero_skywrath_mage",
		"npc_dota_hero_elder_titan",
		"npc_dota_hero_abaddon",
		"npc_dota_hero_earth_spirit",
		"npc_dota_hero_ember_spirit",
		"npc_dota_hero_legion_commander",
		"npc_dota_hero_phoenix",
		"npc_dota_hero_terrorblade",
		"npc_dota_hero_techies",
		"npc_dota_hero_oracle",
		"npc_dota_hero_winter_wyvern",
		"npc_dota_hero_arc_warden",
		"npc_dota_hero_abyssal_underlord",
		"npc_dota_hero_monkey_king"
	];

	var random_hero = valid_heroes[Math.floor(Math.random() * valid_heroes.length)];

	// If this is a valid pick, use it, else, Random another hero.
	var parent_panel = $.GetContextPanel().GetParent().GetParent()
	var selected_panel = parent_panel.FindChildTraverse(random_hero)
	if(selected_panel != null) {
		if (selected_panel.BHasClass( "taken" ) == false) {
			GameEvents.SendCustomGameEventToServer( "hero_selected", { HeroName: random_hero, HasRandomed: true } );
		} else {
			SelectRandomHero()
		}
	}
}

/* Enter the game by removing the picking screen, called when the player
 * clicks a button in the layout. */
function EnterGame() {
	if ( canEnter ) {
		$('#PickingScreen').DeleteAsync( 0.0 );
		$.GetContextPanel().GetParent().GetParent().FindChildTraverse("ScoreboardContainer").style.visibility = "visible";
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

	// Set Random OMG-forbidden heroes as disabled
	if (map_info.map_display_name == "imba_random_omg") {
		parent_panel.FindChildTraverse("npc_dota_hero_earth_spirit").AddClass( "taken" );
		parent_panel.FindChildTraverse("npc_dota_hero_life_stealer").AddClass( "taken" );
		parent_panel.FindChildTraverse("npc_dota_hero_morphling").AddClass( "taken" );
		parent_panel.FindChildTraverse("npc_dota_hero_nyx_assassin").AddClass( "taken" );
		parent_panel.FindChildTraverse("npc_dota_hero_ogre_magi").AddClass( "taken" );
		parent_panel.FindChildTraverse("npc_dota_hero_shredder").AddClass( "taken" );
		parent_panel.FindChildTraverse("npc_dota_hero_treant").AddClass( "taken" );
		parent_panel.FindChildTraverse("npc_dota_hero_tusk").AddClass( "taken" );
		parent_panel.FindChildTraverse("npc_dota_hero_zuus").AddClass( "taken" );
		parent_panel.FindChildTraverse("npc_dota_hero_night_stalker").AddClass( "taken" );
		parent_panel.FindChildTraverse("npc_dota_hero_silencer").AddClass( "taken" );
		parent_panel.FindChildTraverse("npc_dota_hero_keeper_of_the_light").AddClass( "taken" );
		parent_panel.FindChildTraverse("npc_dota_hero_visage").AddClass( "taken" );
		parent_panel.FindChildTraverse("npc_dota_hero_faceless_void").AddClass( "taken" );
	}
})();