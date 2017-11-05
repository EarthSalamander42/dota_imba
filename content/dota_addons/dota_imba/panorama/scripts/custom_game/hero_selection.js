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
	$('#PickedHeroAbility6'),
	$('#PickedHeroAbility7'),
	$('#PickedHeroAbility8')
]

var hiddenAbilities = [ 
	"imba_alchemist_mammonite",
	"imba_phoenix_icarus_dive_stop",
	"nyx_assassin_burrow",
	"nyx_assassin_unburrow",
	"imba_dazzle_ressurection",
	"imba_jakiro_ice_breath",
	"imba_empress_ambient_effects",
	"" // Leave it alone, he's useful
]

/* Event Handlers
=========================================================================*/

/* Picking phase is done, start loading heroes */
function OnPickingDone( data ) {
	$("#EnterGameBtnTxt").text = $.Localize( "#enter_game_button" );
	$("#RepickBtn").AddClass( "disabled" );
}

/* Hero loading is done, allow the player to enter the game */
function OnHeroLoadingDone( data ) {
	$("#EnterGameBtn").RemoveClass( "disabled" );
	$("#EnterGameBtnTxt").text = $.Localize( "#loading_heroes_button" );
	canEnter = true;
}

/* Visual timer update */
function OnTimeUpdate( data ) {
	if (data.time < 10)
	{
		$("#TimerTxt").text = "0:0" + data.time;
	}
	else
	{
		$("#TimerTxt").text = "0:" + data.time;
	}
	$("#EnterGameBtnTxt").text = data.time;
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
	PlayerReconnected(data.PlayerID, data.PickedHeroes, data.PlayerPicks, data.pickState, data.repickState);
}

/* A player has received the list of nonhidden abilities for the selected hero */
function OnReceiveAbilities( data ) {
	UpdateAbilities( data.heroAbilities);
}

/* Functionality
=========================================================================*/

var switched = false
function PickingScreenSwap() {
	if (switched == false) {
		switched = true
		$("#HeroListSTR").style.visibility = 'collapse';
		$("#HeroListAGI").style.visibility = 'collapse';
		$("#HeroListINT").style.visibility = 'collapse';
		$("#HeroListSTR_Custom").style.visibility = 'visible';
		$("#HeroListAGI_Custom").style.visibility = 'visible';
		$("#HeroListINT_Custom").style.visibility = 'visible';
		$("#PickingScreenSwapLabel").text = $.Localize("swap_vanilla_to_custom");
	}
	else {
		switched = false
		$("#HeroListSTR").style.visibility = 'visible';
		$("#HeroListAGI").style.visibility = 'visible';
		$("#HeroListINT").style.visibility = 'visible';
		$("#HeroListSTR_Custom").style.visibility = 'collapse';
		$("#HeroListAGI_Custom").style.visibility = 'collapse';
		$("#HeroListINT_Custom").style.visibility = 'collapse';
		$("#PickingScreenSwapLabel").text = $.Localize("swap_custom_to_vanilla");
	}
}

var switched_alt = false
function ShowStatsSwap() {
	if (switched == false) {
		switched = true
		$("#TeamRadiant").style.visibility = 'collapse';
		$("#TeamDire").style.visibility = 'collapse';
		$("#LeftStatsPanel").style.visibility = 'visible';
		$("#RightStatsPanel").style.visibility = 'visible';
	}
	else {
		switched = false
		$("#TeamRadiant").style.visibility = 'visible';
		$("#TeamDire").style.visibility = 'visible';
		$("#LeftStatsPanel").style.visibility = 'collapse';
		$("#RightStatsPanel").style.visibility = 'collapse';
	}
}

/*  Create a hero panel based on the attribute 
	also handles 3 additional panels for custom heroes */
var single_msg = false
function CreateHeroPanel(hero_table, attribute, custom) {
	if (custom == true) {
//		$.Msg(hero_table)
		attribute = attribute + "_Custom"
	}
	var i = 1;
	var i_count = 1;
	var class_option_count = 1;
	var i_single = false
	for (i in hero_table) {
		if (hero_table[i] != null) {
			if (i_single == false) {
				i_single = true
				var ClassOptionPanel = $.CreatePanel("Panel", $('#HeroList' + attribute), "HeroLine" + attribute + "_" + class_option_count);
				ClassOptionPanel.AddClass("ClassOptionRow")
			}

    		var Hero_Panel = $.CreatePanel("Button", $("#HeroLine" + attribute + "_" + class_option_count), hero_table[i]);
			Hero_Panel.AddClass("ClassNormalOption")
			Hero_Panel.style.backgroundImage = 'url("file://{images}/heroes/'+ hero_table[i] +'.png")';
			Hero_Panel.style.backgroundSize = "100% 100%";

			// disable picked heroes
			var hero_list = CustomNetTables.GetTableValue("game_options", "hero_list");
			var picked_herolist = hero_list.Picked
			var j = 0;

			if (single_msg == false) {
				single_msg = true
				$.Msg("Hero tables:")
				$.Msg(hero_table)
				$.Msg(picked_herolist)
			}

			// Gray out heroes already selected by according to hero pick rule (handled by server)
			for (j in picked_herolist) {
				if (picked_herolist[j] == hero_table[i]) {
					$.Msg("Picked heroes: " + picked_herolist[j])
					$('#'+picked_herolist[j]).AddClass("taken");
					var HeroLabel = $.CreatePanel("Label", $('#'+picked_herolist[j]), picked_herolist[j] + "_label");
					HeroLabel.AddClass("ClassCustomOptionLabel")
					HeroLabel.text = $.Localize("picked_hero");
				}
			}

			i_count = i_count +1

			if (i_count > 5) {
				class_option_count = class_option_count +1
				var ClassOptionPanel_alt = $.CreatePanel("Panel", $("#HeroList" + attribute), "HeroLine" + attribute + "_" + class_option_count);
				ClassOptionPanel_alt.AddClass("ClassOptionRow")
				i_count = 1
			}
		}
	}

	var j = 1;
	for (j in hero_table) {
		if (hero_table[j] != null) {
			$("#PickList").FindChildTraverse(hero_table[j]).SetPanelEvent("onactivate", function(k){ return function() { SelectHero(hero_table[k]) }}(j));
		}
	}
}

function MakeImbaHero(imba_heroes) {
	var h = 1;
	for (h in imba_heroes) {
		if (imba_heroes[h] != null) {
			$("#PickList").FindChildTraverse(imba_heroes[h]).RemoveClass("ClassNormalOption")
			$("#PickList").FindChildTraverse(imba_heroes[h]).AddClass("ClassImbaOption")
		}
	}
}

function MakeNewHero(new_heroes) {
	var h = 1;
	for (h in new_heroes) {
		if (new_heroes[h] != null) {
			$("#PickList").FindChildTraverse(new_heroes[h]).RemoveClass("ClassNormalOption")
			$("#PickList").FindChildTraverse(new_heroes[h]).AddClass("ClassCustomOption")
			var HeroLabel = $.CreatePanel("Label", $("#PickList").FindChildTraverse(new_heroes[h]), new_heroes[h] + "_label");
			HeroLabel.AddClass("ClassCustomOptionLabel")
			HeroLabel.text = $.Localize("new_hero");
		}
	}
}

function MakeDisabledHeroes(disabled_10v10, disabled_all) {
	var map_info = Game.GetMapInfo();
	if (map_info.map_display_name == "imba_10v10" || map_info.map_display_name == "imba_custom_10v10" || map_info.map_display_name == "imba_12v12") {
		var g = 1;
		for (g in disabled_10v10) {
			if (disabled_10v10[g] != null) {
				var hero_panel = $("#PickList").FindChildTraverse(disabled_10v10[g])
				$("#PickList").FindChildTraverse(disabled_10v10[g]).AddClass("taken")
				var HeroLabel = $.CreatePanel("Label", $("#PickList").FindChildTraverse(disabled_10v10[g]), disabled_10v10[g] + "_label");
				HeroLabel.AddClass("ClassCustomOptionLabel")
				HeroLabel.text = $.Localize("disabled_hero_10v10");
			}
		}
	}

	var h = 1;
	for (h in disabled_all) {
		if (disabled_all[h] != null) {
			var hero_panel = $("#PickList").FindChildTraverse(disabled_all[h])
			hero_panel.AddClass("taken")
			var HeroLabel = $.CreatePanel("Label", $("#PickList").FindChildTraverse(disabled_all[h]), disabled_all[h] + "_label");
			HeroLabel.AddClass("ClassCustomOptionLabel")
			HeroLabel.text = $.Localize("disabled_hero");
		}
	}
}

function LoadPlayers() {
var RadiantLevels = 0
var DireLevels = 0
var RadiantCount = 0
var DireCount = 0

	var radiantPlayers = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_GOODGUYS );
	var direPlayers = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_BADGUYS );
	var map_info = Game.GetMapInfo();
	$.Msg(radiantPlayers.length)

	var i = 1;
	var class_option_count = 1;
	var ClassOptionPanelRadiant = $.CreatePanel("Panel", $("#LeftPlayers"), "PlayerRow" + class_option_count + "_good");
	$.Each( radiantPlayers, function( player ) {
		var playerPanel = Modular.Spawn( "picking_player", $("#PlayerRow" + class_option_count + "_good") );
		playerPanel.SetPlayerName( player );

		//Save the panel for later
		playerPanels[player] = playerPanel;
		RadiantCount = RadiantCount +1

		if (RadiantCount >= 5) {
			class_option_count = class_option_count +1
			var ClassOptionPanelRadiant_alt = $.CreatePanel("Panel", $("#LeftPlayers"), "PlayerRow" + class_option_count + "_good");
			ClassOptionPanelRadiant.AddClass("PlayerOptionRowV10")
			ClassOptionPanelRadiant_alt.AddClass("PlayerOptionRowV10")
			RadiantCount = 0
		} else {
			ClassOptionPanelRadiant.AddClass("PlayerOptionRow")
		}

		var plyData = CustomNetTables.GetTableValue("player_table", player);
		if (plyData != null) {
			RadiantLevels = RadiantLevels + plyData.Lvl / RadiantCount
			$("#AverageMMRTeamRadiant").text = $.Localize("average_mmr") + RadiantLevels.toFixed([0]);
		}
	});

	var ClassOptionPanelDire = $.CreatePanel("Panel", $("#RightPlayers"), "PlayerRow" + class_option_count + "_bad");
	$.Each( direPlayers, function( player ) {
		var playerPanel = Modular.Spawn( "picking_player", $("#PlayerRow" + class_option_count + "_bad") );
		playerPanel.SetPlayerName( player );

		//Save the panel for later
		playerPanels[player] = playerPanel;
		DireCount = DireCount +1

		if (DireCount >= 5) {
			class_option_count = class_option_count +1
			var ClassOptionPanelDire_alt = $.CreatePanel("Panel", $("#RightPlayers"), "PlayerRow" + class_option_count + "_bad");
			ClassOptionPanelDire.AddClass("PlayerOptionRowV10")
			ClassOptionPanelDire_alt.AddClass("PlayerOptionRowV10")
			DireCount = 0
		} else {
			ClassOptionPanelDire.AddClass("PlayerOptionRow")
		}

		var plyData = CustomNetTables.GetTableValue("player_table", player);
		if (plyData != null) {
			DireLevels = DireLevels + plyData.Lvl / DireCount
			$("#AverageMMRTeamDire").text = $.Localize("average_mmr") + DireLevels.toFixed([0]);
		}
	});

	$.Schedule(1.0, CreateHeroPick)
}

function CreateHeroPick() {
	var hero_list = CustomNetTables.GetTableValue("game_options", "hero_list");

//	if (hero_list.Disabled10v10 == undefined) {
//		$.Msg("Couldn't find values, relaunching function..")
//		$.Schedule(1.0, CreateHeroPick)
//		return;
//	}

	var disabled_heroes_10v10 = hero_list.Disabled10v10;
	var disabled_heroes = hero_list.Disabled
	var imba_heroes = hero_list.Imba
	var new_heroes = hero_list.New
	var strength_heroes_custom = hero_list.StrengthCustom;
	var agility_heroes_custom = hero_list.AgilityCustom;
	var intellect_heroes_custom = hero_list.IntellectCustom;
	var strength_heroes = hero_list.Strength;
	var agility_heroes = hero_list.Agility;
	var intellect_heroes = hero_list.Intellect;

	CreateHeroPanel(strength_heroes, "STR", false)
	CreateHeroPanel(agility_heroes, "AGI", false)
	CreateHeroPanel(intellect_heroes, "INT", false)

	CreateHeroPanel(strength_heroes_custom, "STR", true)
	CreateHeroPanel(agility_heroes_custom, "AGI", true)
	CreateHeroPanel(intellect_heroes_custom, "INT", true)

	MakeImbaHero(imba_heroes)
	MakeNewHero(new_heroes)
	MakeDisabledHeroes(disabled_heroes_10v10, disabled_heroes)
}

/* A player on the same team has picked a hero, tell the player's panel a hero was picked,
 * show the hero was taken and if the player that picked is the local player
 * swap to the hero preview screen. */
function HeroPicked(player, hero, team, has_randomed) {
	// Update the player panel and hero selection, if appropriate
	if ( playerPanels[player] != null ) {
		playerPanels[player].SetHero(hero);
	}

	// Disable the hero button according to hero pick rule
	var LocalPlayer = Players.GetLocalPlayer()
	$('#'+hero).AddClass("taken");

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
	var parent_panel = $.GetContextPanel().GetParent().GetParent()
	parent_panel.FindChildTraverse(hero).RemoveClass( "taken" );

	// Update the player panel and hero selection, if appropriate
	if ( player != null ) {
		playerPanels[player].SetHero(null);
	}
}

/* Switch the content of the screen to show the picked hero instead of the
 * pickable heroes. */
function SwitchToHeroPreview( heroName ) {

	var previewPanel = $.CreatePanel("Panel", $('#PostPickScreen'), "HeroPreview");
	previewPanel.BLoadLayoutFromString('<root><Panel><DOTAScenePanel style="width:100%; height:100%;" particleonly="false" unit="'+heroName+'"/></Panel></root>', false, false );
	previewPanel.style.opacityMask = 'url("s2r://panorama/images/masks/hero_model_opacity_mask_png.vtex");'

	$('#PostPickScreen').MoveChildBefore( previewPanel, $("#PostPickScreenButtonContainer") );

	// Hide/show relevant panels
	$("#PickHeroBtn").style.visibility = 'collapse';
	$('#PickList').style.visibility = 'collapse';
	$('#PostPickScreen').style.visibility = 'visible';
	$('#WelcomePanel').style.visibility = 'collapse';	
}

/* Select a hero, called when a player clicks a hero panel in the layout */
function SelectHero( heroName ) {
	// Do nothing if this hero is not available for the player's team
	var selected_panel = $("#PickList").FindChildTraverse(heroName)

	// Set the appropriate hero image
	// TODO: Replace this line with the other one, not working yet
	$("#PickedHeroImage").style.backgroundImage = 'url("s2r://panorama/images/heroes/'+ heroName +'_png.vtex")';
	$("#PickedHeroImage").style.backgroundSize = "100% 100%";
	$("#PickedHeroImage").style.visibility = 'visible';

	var panel_table = $("#PickList").FindChildrenWithClassTraverse("selected");
	for (var i = 0; i < panel_table.length; i++) {
		panel_table[i].RemoveClass("selected")
	}

	var LocalPlayer = Players.GetLocalPlayer()
	playerPanels[LocalPlayer].SetPreviewHero(heroName)

	selected_panel.AddClass("selected");
	$("#PickHeroBtn").RemoveClass("Banned")

	// Update the hero name
	$("#PickedHeroName").text = $.Localize( heroName );
	selectedHero = heroName;

	// Make the abilities panel visible
	$("#HeroAbilitiesParentPanel").style.visibility = 'visible';
	$("#PickHeroBtn").style.visibility = 'visible';
	if (selected_panel.BHasClass("taken")) {
		$("#PickHeroBtn").AddClass("Banned")
	}

	// Request the hero's abilities table to the server 
	GameEvents.SendCustomGameEventToServer("pick_abilities_requested", {HeroName: heroName});
}

/* Updates the selected hero abilities panel */
function UpdateAbilities(abilityList) {
	for( var i = 1; i <= 8; i++ ) {
		var abilityPanel = abilityPanels[i-1]
		var ability = abilityList[i]
		if ( ability != null ) {
			abilityPanel.abilityname = ability;
			abilityPanel.style.visibility = 'visible';

			for( var j = 0; j <= hiddenAbilities.length -1; j++ ) {
				var ability_hidden = hiddenAbilities[j]
				if ( ability_hidden != null ) {
					if ( ability == ability_hidden ) {
						abilityPanel.style.visibility = 'collapse';
					}
				}
			}

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

	var numOfAbilities = Object.keys(abilityList).length
	var abilityParentPanel = $("#HeroAbilitiesParentPanel");
	abilityParentPanel.SetHasClass("six_abilities", numOfAbilities>=6);
	abilityParentPanel.SetHasClass("five_abilities", numOfAbilities==5);
	abilityParentPanel.SetHasClass("four_abilities", numOfAbilities==4);
}

/* Pick a hero, called when a player confirms his hero selection */
function PickHero() {
	// Send the pick to the server, if it is available
	if ($("#PickHeroBtn").BHasClass( "disabled" ) == false) {
		var selected_panel = $("#PickList").FindChildTraverse(selectedHero)

		if (selected_panel == null)
		{
			var selected_panel = $("#CustomPickList").FindChildTraverse(selectedHero)
		}

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
		$("#PickedHeroName").text = $.Localize( "hero_name_filler" );
		selectedHero = null;

		// Make the abilities panel invisible
		$("#HeroAbilitiesParentPanel").style.visibility = 'collapse';
		$("#PickHeroBtn").style.visibility = 'collapse';

		// Disable the repick button
		$("#RepickBtn").AddClass("disabled");

		// Show the hero pick menu again
		$('#HeroPreview').DeleteAsync( 0.0 );
		$('#PickList').style.visibility = 'visible';
		$("#PickHeroBtn").style.visibility = 'visible';
//		$('#PickInfoPanel').style.visibility = 'visible';
		$('#WelcomePanel').style.visibility = 'visible';	
		$('#PostPickScreen').style.visibility = 'collapse';
	}
}

/* Random a hero, called when a player clicks the random hero button */
function SelectRandomHero() {
	GameEvents.SendCustomGameEventToServer("hero_randomed", {});
}

function SelectRandomImbaHero() {
	GameEvents.SendCustomGameEventToServer("hero_imba_randomed", {});
}

/* Enter the game by removing the picking screen, called when the player
 * clicks a button in the layout. */
function EnterGame() {
	if ( canEnter ) {
		ShowHUD(true)
		ShowPickScreen(false)
	}
}

function PlayerReconnected(player_id, picked_heroes, player_picks, pick_state, repick_state) {
	// If this is not the local player, ignore everything
	$.Msg("PlayerReconnected (JS)")
	if ( player_id == Players.GetLocalPlayer() ) {
		$.Msg("Act on local player only..")
		// If the player is already in-game, destroy the pick interface and ignore the rest
		if (pick_state == "in_game") {
			ShowHUD(true)
			ShowPickScreen(false)
			$.Msg("Pick State: In-Game")
		// Else, repopulate player pick panels
		} else {
//			var localTeam = Players.GetTeam(Players.GetLocalPlayer())
//			if ( localTeam != 2 && localTeam != 3 ) {
//			} else {
				ShowHUD(false)
				ShowPickScreen(true)
				$.Msg("Pick State: Picking..")

				var i = 1;
				for (i = 1; i <= player_picks.length; i++) {
					if (player_picks[i] != null) {
						$("#PickInfoPanel").style.visibility = "visible";
						$.Msg(playerPanels[i])
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
//			}
		}
	}
}

function ShowHUD(hide) {
var show = "visible"
if (hide == false) {
	show = "collapse"
}
	var MainPanel = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent()
	MainPanel.FindChildTraverse("topbar").style.visibility = show;
	MainPanel.FindChildTraverse("minimap_container").style.visibility = show;
	MainPanel.FindChildTraverse("lower_hud").style.visibility = show;
	MainPanel.FindChildTraverse("HudChat").style.visibility = show;
	MainPanel.FindChildTraverse("NetGraph").style.visibility = show;
	MainPanel.FindChildTraverse("quickstats").style.visibility = show;
}

function ShowPickScreen(hide) {
var show = "visible"
if (hide == false) {
	show = "collapse"
}
	$('#BackgroundPanel').style.visibility = show;
	$('#PickingScreen').style.visibility = show;
	$('#LoadingPanel').style.visibility = show;
}

//Subscribe to events
GameEvents.Subscribe( "picking_done", OnPickingDone );
GameEvents.Subscribe( "hero_loading_done", OnHeroLoadingDone );
GameEvents.Subscribe( "picking_time_update", OnTimeUpdate );
GameEvents.Subscribe( "hero_picked", OnHeroPicked );
GameEvents.Subscribe( "hero_unpicked", OnHeroUnpicked );
GameEvents.Subscribe( "player_reconnected", OnPlayerReconnect );
GameEvents.Subscribe( "pick_abilities", OnReceiveAbilities );

/* Initialisation - runs when the element is created
=========================================================================*/
(function () {

	// If this player is a spectator, just kill the whole pick screen
	var localTeam = Players.GetTeam(Players.GetLocalPlayer())
	if ( localTeam != 2 && localTeam != 3 ) {
		$.Msg("VILKOMMEN BIENVENUE, SPECTATOR!")
		// Else, do pick screen stuff
	} else {
		///Load player elements
		ShowHUD(false);
		LoadPlayers()

		// Show only map-specific elements
		var map_info = Game.GetMapInfo();

		// Update the game options display
		var bounty_multiplier = CustomNetTables.GetTableValue("game_options", "bounty_multiplier");
		var exp_multiplier = CustomNetTables.GetTableValue("game_options", "exp_multiplier");
		var creep_power = CustomNetTables.GetTableValue("game_options", "creep_power");
		var tower_power = CustomNetTables.GetTableValue("game_options", "tower_power");
		var respawn_multiplier = CustomNetTables.GetTableValue("game_options", "respawn_multiplier");
		var initial_gold = CustomNetTables.GetTableValue("game_options", "initial_gold");
		var initial_level = CustomNetTables.GetTableValue("game_options", "initial_level");
		var max_level = CustomNetTables.GetTableValue("game_options", "max_level");
		var kills_to_end = CustomNetTables.GetTableValue("game_options", "kills_to_end");
		var frantic_mode = CustomNetTables.GetTableValue("game_options", "frantic_mode");
		$("#BountyMultiplierValue").text = bounty_multiplier[1] + "%";
		$("#ExpMultiplierValue").text = exp_multiplier[1] + "%";
		$("#InitialGoldValue").text = initial_gold[1];
		$("#InitialLevelValue").text = initial_level[1];
		$("#MaxLevelValue").text = max_level[1];

//		if (tower_power[1] == 0) {
//			$("#TowerPowerValue").text = $.Localize( '#imba_gamemode_settings_power_1' );
//		} else if (tower_power[1] == 1) {
//			$("#TowerPowerValue").text = $.Localize( '#imba_gamemode_settings_power_2' );
//		} else if (tower_power[1] == 2) {
//			$("#TowerPowerValue").text = $.Localize( '#imba_gamemode_settings_power_3' );
//		}

		if (tower_power[1] == 1) {
			$("#TowerPowerValue").text = $.Localize( '#imba_gamemode_settings_power_1' );
		} else if (tower_power[1] == 2) {
			$("#TowerPowerValue").text = $.Localize( '#imba_gamemode_settings_power_2' );
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

		if (map_info.map_display_name == "imba_custom" || map_info.map_display_name == "imba_custom_10v10") {
			if(frantic_mode) {
				$("#FranticModeValue").text = $.Localize( '#imba_gamemode_game_options_frantic_enabled' );
			}
		}

		// If All Random is enabled, pick a random hero
		var all_random_enabled = CustomNetTables.GetTableValue("game_options", "all_random" );
		if (all_random_enabled != null && all_random_enabled[1] == 1) {
			$("#PickHeroBtn").AddClass( "disabled" );
			$("#RepickBtn").AddClass( "disabled" );
			$('#GameModeSelectText').text = $.Localize( '#imba_gamemode_name_all_random' );
			$.Schedule(5, SelectRandomHero);
		}

		// Tell the server this player's UI was initialized
		GameEvents.SendCustomGameEventToServer( "ui_initialized", {} );

		//COOKIES: Custom Chat, created by Mahou Shoujo, approved to be used in IMBA
		$("#HeroSelectionChat").BLoadLayout("file://{resources}/layout/custom_game/simple_chat.xml", false, false);
	}
})();
