"use strict";

/* Initialisation - runs when the element is created
=========================================================================*/
(function () {
	InitializeUI()
	$.Schedule(4, InitializeNews);

	// Hides battlecuck crap
	var hit_test_blocker = $.GetContextPanel().GetParent().FindChild("SidebarAndBattleCupLayoutContainer");

	if (hit_test_blocker) {
		hit_test_blocker.hittest = false;
		hit_test_blocker.hittestchildren = false;
	}
})();

//init parameter values
var gold = 1
var exp = 1
var tower = 1
var hero = 1

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
			$('#GameOptionsPanel').style.visibility = 'collapse';
			//			$('#HeroPowerOptionsPanel').style.visibility = 'collapse';
			//			$('#TowerPowerOptionsPanel').style.visibility = 'collapse';
			//			$('#AllPickToggle').style.visibility = 'collapse';
			//			$('#AllRandomToggle').style.visibility = 'collapse';
			//			$('#AllRandomSameHeroToggle').style.visibility = 'collapse';
			//			$('#FranticInfo').style.visibility = 'collapse';
			//			$('#GoldOption1').checked = true;
			//			$('#ExpOption1').checked = true;
		} else if (map_info.map_display_name == "imba_10v10" || map_info.map_display_name == "imba_12v12") {
			$('#GameOptionsPanel').style.visibility = 'collapse';
			//			$('#game_options_game_mode_title').text = $.Localize( "#imba_gamemode_name_10v10" );
			//			$('#HeroPowerOptionsPanel').style.visibility = 'collapse';
			//			$('#TowerPowerOptionsPanel').style.visibility = 'collapse';
			//			$('#AllPickToggle').style.visibility = 'collapse';
			//			$('#AllRandomToggle').style.visibility = 'collapse';
			//			$('#AllRandomSameHeroToggle').style.visibility = 'collapse';
			//			$('#FranticInfo').style.visibility = 'collapse';
			//			$('#GoldOption1').checked = true;
			//			$('#ExpOption1').checked = true;
		} else if (map_info.map_display_name == "imba_custom" || map_info.map_display_name == "imba_frantic_10v10") {
			$('#GoldOptionsPanel').style.visibility = 'collapse';
			$('#ExpOptionsPanel').style.visibility = 'collapse';
			$('#TowerPowerOption1').checked = true;
			$('#HeroPower1').checked = true;
			$('#AllPickToggle').checked = true;
			gold = 2
			exp = 2
		} else if (map_info.map_display_name == "imba_overthrow") {
			$('#GameOptionsPanel').style.visibility = 'collapse';
			$('#imba-loading').style.visibility = 'collapse';
			$('#overthrow-loading').style.visibility = 'visible';
		}
	}

	SetGameOptions(); // Setup game options by default in case the host don't change them (initialize)
}

var news = null;

function setNews() {
	if (news == null) return;

	var lang = $.Localize("lang");
	var fallbackLanguage = "en";

	var title = news[fallbackLanguage].title;
	var text = news[fallbackLanguage].text;

	if (news[lang] !== undefined) {
		title = news[lang].title;
		text = news[lang].text;
	}

	$("#imba-news-article-title").text = title;
	$("#imba-news-article-text").text = text;
}

function InitializeNews() {
	$.Msg("Init News...");
	$.AsyncWebRequest('https://api.dota2imba.org/meta/news', {
		type: 'GET',
		dataType: 'json',
		success: function (d) {
			$.Msg("News received");
			news = d.data;
		},

		timeout: 5000,
		error: function (err) {
			$.Msg("Api Error" + JSON.stringify(err));
		}
	});

	$.Schedule(0.33, setNews);
}

// Checks if the local player has local privileges
function CheckForHostPrivileges() {
	var player_info = Game.GetLocalPlayerInfo();
	if (!player_info) {
		return undefined;
	} else {
		return player_info.player_has_host_privileges;
	}
}

// Locks the game mode
function SetGameParameters(parameter, value) {
	if (parameter == "gold") {
		gold = value
	} else if (parameter == "exp") {
		exp = value
	} else if (parameter == "tower") {
		tower = value
	} else if (parameter == "hero") {
		hero = value
	}
}

// Sets all options to Normal mode
function SetQuickOptionsNormal() {
	// Sets everything else to normal options
	var map_info = Game.GetMapInfo();
	if (map_info.map_display_name == "imba_standard" || map_info.map_display_name == "imba_10v10" || map_info.map_display_name == "imba_12v12") {
		$('#GoldOption1').checked = true;
		$('#ExpOption1').checked = true;
		gold = 1
		exp = 1
	} else {
		$('#TowerPowerOption1').checked = true;
		$('#HeroPower1').checked = true;
		tower = 1
		hero = 1
	}

	SetGameOptions();
}

// Sets all options to Hyper mode
function SetQuickOptionsHigh() {
	// Sets everything else to high options
	var map_info = Game.GetMapInfo();
	if (map_info.map_display_name == "imba_standard" || map_info.map_display_name == "imba_10v10" || map_info.map_display_name == "imba_12v12") {
		$('#GoldOption2').checked = true;
		$('#ExpOption2').checked = true;
		gold = 2
		exp = 2
	} else {
		$('#TowerPowerOption2').checked = true;
		$('#HeroPower2').checked = true;
		tower = 2
		hero = 2
	}

	SetGameOptions();
}

function SetGameOptions() {
	GameEvents.SendCustomGameEventToServer("set_game_mode", {
		"is_host": CheckForHostPrivileges(),
		"modes": {
			"all_pick": $('#AllPickToggle').checked,
			"all_random": $('#AllRandomToggle').checked,
			"all_random_same_hero": $('#AllRandomSameHeroToggle').checked,
			"bounty_multiplier": gold,
			"exp_multiplier": exp,
			"tower_power": tower,
			"hero_power": hero,
		}
	});
}