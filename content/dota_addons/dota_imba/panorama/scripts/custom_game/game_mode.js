"use strict";

/* Initialisation - runs when the element is created
=========================================================================*/
(function () {
	InitializeUI()

	GameEvents.Subscribe("loading_screen_news", InitializeNews);

	// Hides battlecuck crap
	var hit_test_blocker = $.GetContextPanel().GetParent().FindChild("SidebarAndBattleCupLayoutContainer");

	if (hit_test_blocker) {
		hit_test_blocker.hittest = false;
		hit_test_blocker.hittestchildren = false;
	}
})();

// Initializes the UI for the player with host privileges
function InitializeUI() {
	var is_host = CheckForHostPrivileges();
	if (is_host === undefined) {
		$.Schedule(1, InitializeUI);
		return;
	} else if (is_host) {

		// Make the game options panel visible
		var game_options_panel = $('#imba-admin')
		game_options_panel.style.visibility = 'visible';

		// Update other elements according to the current map
		var map_info = Game.GetMapInfo();

		if (map_info.map_display_name == "imba_standard") {
			$('#QuickOptionsPanel').style.visibility = 'collapse';
			$('#HeroPowerOptionsPanel').style.visibility = 'collapse';
			$('#CreepPowerOptionsPanel').style.visibility = 'collapse';
			$('#TowerPowerOptionsPanel').style.visibility = 'collapse';
			$('#TowerUpgradesToggle').style.visibility = 'collapse';
			$('#AllPickToggle').style.visibility = 'collapse';
			$('#AllRandomToggle').style.visibility = 'collapse';
			$('#AllRandomSameHeroToggle').style.visibility = 'collapse';
			$('#GoldOption1').checked = true;
			$('#ExpOption1').checked = true;
		} else if (map_info.map_display_name == "imba_10v10" || map_info.map_display_name == "imba_12v12") {
			$('#game_options_game_mode_title').text = $.Localize( "#imba_gamemode_name_10v10" );
			$('#QuickOptionsPanel').style.visibility = 'collapse';
			$('#HeroPowerOptionsPanel').style.visibility = 'collapse';
			$('#CreepPowerOptionsPanel').style.visibility = 'collapse';
			$('#TowerPowerOptionsPanel').style.visibility = 'collapse';
			$('#TowerUpgradesToggle').style.visibility = 'collapse';
			$('#AllPickToggle').style.visibility = 'collapse';
			$('#AllRandomToggle').style.visibility = 'collapse';
			$('#AllRandomSameHeroToggle').style.visibility = 'collapse';
			$('#GoldOption1').checked = true;
			$('#ExpOption1').checked = true;
		} else if (map_info.map_display_name == "imba_custom" || map_info.map_display_name == "imba_custom_10v10") {
			$('#TowerUpgradesToggle').SetSelected(true);
//			$('#FranticToggle').style.visibility = 'visible';
			$('#GoldOption1').checked = true;
			$('#ExpOption1').checked = true;
			$('#CreepPowerOption1').checked = true;
			$('#TowerPowerOption1').checked = true;
			$('#HeroPower1').checked = true;
			$('#AllPickToggle').checked = true;
		}
	}

	InitializeNews();
}

function InitializeNews() { 
	var lang = $.Localize("lang"); 

    $.AsyncWebRequest('http://api.dota2imba.org/meta/news',
	{
		type: 'GET',
		success: function (data) {
			var news = data.data;

			if (news[lang] !== undefined) {
				$.Msg("News received: " + news[lang].title)
				$("#imba-news-article-title").text = news[lang].title;
				$("#imba-news-article-text").text = news[lang].text;
			} else {
				$("#imba-news-article-title").text = "";
				$("#imba-news-article-text").text = "";
			}
		} 
	});
	
}

// Checks if the local player has local privileges
function CheckForHostPrivileges() {
	var player_info = Game.GetLocalPlayerInfo();
	if ( !player_info ) {
		return undefined;
	} else {
		return player_info.player_has_host_privileges;
	}
}

// Sets all options to Normal mode
function SetQuickOptionsNormal() {
	var map_info = Game.GetMapInfo();
	if (map_info.map_display_name != "imba_standard" || map_info.map_display_name != "imba_10v10" || map_info.map_display_name != "imba_12v12") {
		$('#TowerUpgradesToggle').SetSelected(false);
	} 

	// Sets everything else to normal options
	$('#GoldOption1').checked = true;
	$('#ExpOption1').checked = true;
	$('#CreepPowerOption1').checked = true;
	$('#TowerPowerOption1').checked = true;
	$('#HeroPower1').checked = true;
//	$('#FranticToggle').SetSelected(false);
}

// Sets all options to Hyper mode
function SetQuickOptionsHigh() {
	var map_info = Game.GetMapInfo();
	if (map_info.map_display_name != "imba_standard" || map_info.map_display_name != "imba_10v10" || map_info.map_display_name != "imba_12v12") {
		$('#TowerUpgradesToggle').SetSelected(true);
	} 

	// Sets everything else to high options
	$('#GoldOption2').checked = true;
	$('#ExpOption2').checked = true;
	$('#CreepPowerOption2').checked = true;
	$('#TowerPowerOption2').checked = true;
	$('#HeroPower2').checked = true;
//	$('#FranticToggle').SetSelected(true);
}

// Locks the game mode
function SetGameOptions()
{
	GameEvents.SendCustomGameEventToServer( "set_game_mode", {
		"is_host": CheckForHostPrivileges(),
		"modes": {
			"all_pick": $('#AllPickToggle').checked,
			"all_random": $('#AllRandomToggle').checked,
			"all_random_same_hero": $('#AllRandomSameHeroToggle').checked,
//			"frantic_mode": $('#FranticToggle').checked,
			"tower_upgrades": $('#TowerUpgradesToggle').checked,
			"bounty_multiplier": $('#GoldOptionsDropdown').GetSelected().id,
			"exp_multiplier": $('#ExpOptionsDropdown').GetSelected().id,
			"creep_power": $('#CreepPowerOptionsDropdown').GetSelected().id,
			"tower_power": $('#TowerPowerOptionsDropdown').GetSelected().id,
			"hero_power": $('#HeroPowerDropdown').GetSelected().id,
		}
	});
}
