Utils = {};

function CheckInit() {
	if (Game.GameStateIsAfter(6)) {
		InitIngameGlobalUtils();
	}
	else
		$.Schedule(1.0, CheckInit)
}

// local functions, this file only!
function GetDotaHud() {
	var panel = $.GetContextPanel();
	while (panel && panel.id !== 'Hud') {
		panel = panel.GetParent();
	}

	if (!panel) {
		throw new Error('Could not find Hud root from panel with id: ' + $.GetContextPanel().id);
	}

	return panel;
}

// global functions that must be initialized after pick screen
function InitIngameGlobalUtils() {
/*	
	Utils.GetUnitByName = function(sName, bConsiderMergedUnits) {
		for (var tier = 0; tier <= 7; tier++) {
			for (var i = 1; i <= Utils.GetUnitCountByTier(tier, bConsiderMergedUnits); i++) {
				var unit = Utils.GetUnitInTierByPosition(tier, i, bConsiderMergedUnits);
	
				if (unit) {
					if (unit.unit_name == sName) {
						return unit;
					}
				}
			}
		}
	}
*/
}

function InitGlobalUtilFuncs() {
	Utils.FindDotaHudElement = function(id) {
		return GetDotaHud().FindChildTraverse(id);
	}

	Utils.RawTimetoGameTime = function(time) {
		var sec = Math.floor( time % 60 );
		var min = Math.floor( time / 60 );

		var timerText = "";
		timerText += min;
		timerText += ":";

		if ( sec < 10 )
			timerText += "0";

		timerText += sec;

		return timerText;
	}

	GameUI.Utils = Utils;
}

(function() {
	CheckInit();
	InitGlobalUtilFuncs();

	// Custom error messages (mid-bottom red styled)
	GameEvents.Subscribe("CreateIngameErrorMessage", function(data) 
	{
		GameEvents.SendEventClientSide("dota_hud_error_message", 
		{
			"splitscreenplayer": 0,
			"reason": data.reason || 80,
			"message": data.message
		})
	})

	// init team color and names (used in loading screen)
	GameUI.CustomUIConfig().team_colors = {}
	GameUI.CustomUIConfig().team_names = {}

	GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_GOODGUYS] = "#08640E;"; // Format this later using rgbtohex lib, and taking team color in settings.lua
	GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_BADGUYS] = "#640808;"; // Format this later using rgbtohex lib, and taking team color in settings.lua

	GameUI.CustomUIConfig().team_names[DOTATeam_t.DOTA_TEAM_GOODGUYS] = "#DOTA_GoodGuysShort";
	GameUI.CustomUIConfig().team_names[DOTATeam_t.DOTA_TEAM_BADGUYS] = "#DOTA_BadGuysShort";

	// Fix 3 digits levels on buff bar modifier (up to 4)
	var Parent = $.GetContextPanel().GetParent().GetParent()
	Parent.FindChildTraverse("LevelLabel").style.width = "50px";

	// Hide Pick Screen until hero selection starts
	var PreGame = Parent.FindChildTraverse("PreGame");

	HidePickScreen();

	function HidePickScreen() {
		if (!Game.GameStateIsAfter(2)) {
			PreGame.style.opacity = "0";
			$.Schedule(0.25, HidePickScreen)
		}
		else {
			PreGame.style.opacity = "1";
		}
	}

	if (Game.GetMapInfo().map_display_name == "10v10")
		SetupTopBar();

	function SetupTopBar() {
	//	$.Msg("10v10 top bar")
		$.GetContextPanel().SetHasClass('TenVTen', true);
		var topbar = Utils.FindDotaHudElement('topbar');
		topbar.style.width = '1550px';
	
		// Nice topbar colors
		var TopBarRadiantTeamContainer = topbar.FindChildTraverse("TopBarRadiantTeamContainer");
		var TopBarDireTeamContainer = topbar.FindChildTraverse("TopBarDireTeamContainer");
	
		TopBarRadiantTeamContainer.style.width = '780px'; // 620px
		TopBarDireTeamContainer.style.width = '780px'; // 620px
	
		// Top Bar Radiant
		var TopBarRadiantTeam = Utils.FindDotaHudElement('TopBarRadiantTeam');
		TopBarRadiantTeam.style.width = '100%'; // 540px
	
		// Top Bar Dire
		var TopBarDireTeam = Utils.FindDotaHudElement('TopBarDireTeam');
		TopBarDireTeam.style.width = '100%'; // 540px

/*
		for (var tbg of TopBarRadiantTeam.FindChildrenWithClassTraverse("TeamBackground")) {
			tbg.style.width = "90%";
			for (var tbbg of tbg.FindChildrenWithClassTraverse("TopBarBackground")) {
				tbbg.style.backgroundSize = '0%';
				tbbg.style.backgroundColor = '#000000da';
				tbbg.style.width = "100%";
			}
		}
	
		for (var tbg of TopBarDireTeam.FindChildrenWithClassTraverse("TeamBackground")) {
			tbg.style.width = "90%";
			for (var tbbg of tbg.FindChildrenWithClassTraverse("TopBarBackground")) {
				tbbg.style.backgroundSize = '0%';
				tbbg.style.backgroundColor = '#000000da';
				tbbg.style.width = "100%";
			}
		}
*/
	}

	// todo: Correctly override top bar colors BUT does not respect the first 10 vanilla color positions
	function OverrideTopBarColor() {
		var colors = CustomNetTables.GetTableValue("game_options", "player_colors");
	
		for (var id in colors) {
			if (Players.GetTeam(parseInt(id)) && Players.GetTeam(parseInt(id)) && Players.GetTeam(parseInt(id)) != 1) {
				var team = "Radiant"
	
				if (Players.GetTeam(parseInt(id)) == 3) {
					team = "Dire"
				}
	
				var panel = Utils.FindDotaHudElement(team + "Player" + id)
		//		$.Msg(id)
	
				if (panel)
					panel.FindChildTraverse('PlayerColor').style.backgroundColor = colors[id];
			}
		}
	}

	GameEvents.Subscribe("override_top_bar_colors", OverrideTopBarColor);
})();
