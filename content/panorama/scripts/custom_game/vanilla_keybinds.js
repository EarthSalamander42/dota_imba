// Original author: AABS (https://github.com/ark120202/angel-arena-black-star/blob/45d88d22746e41ccc6197b84d81edd4cf8ff9272/content/panorama/scripts/hotkey_tracker.js)

Game.Events = {};
var contextPanel = $.GetContextPanel();

function GetKeyBind(name) {
	$.CreatePanelWithProperties('DOTAHotkey', contextPanel, "", {
		keybind: name,
	});

	var keyElement = contextPanel.GetChild(contextPanel.GetChildCount() - 1);
	keyElement.DeleteAsync(0);
	return keyElement.GetChild(0).text;
}
/*
function RegisterKeyBindHandler(name) {
	Game.Events[name] = {};
	Game.AddCommand(GetCommandName(name), function() {
		for (var key in Game.Events[name]) {
			Game.Events[name][key]();
		}
	}, '', 0);
}

function RegisterKeyBind(name, callback) {
	if (Game.Events[name] == null) {
		RegisterKeyBindHandler(name);
		var key = GetKeyBind(name)
		if (key !== '') Game.CreateCustomKeyBind(key, GetCommandName(name));
	}

	Game.Events[name][callback.name] = callback;
};

GameUI.CustomUIConfig().RegisterKeyBind = RegisterKeyBind;
*/

function SetupVanillaKeyBinding(sName, callback_function, bHold, secondary_callback_function) {
//	$.Msg("Attempt to gather vanilla keybinding for player: " + Players.GetLocalPlayer())
//	$.Msg(sName)
//	$.Msg(callback_function)
//	$.Msg(bHold)
//	$.Msg(secondary_callback_function)
	if (Players.GetLocalPlayer() != -1) {
		var vanilla_keybind = GetKeyBind(sName).toLowerCase();
		if (vanilla_keybind == undefined || vanilla_keybind == "") {
			$.Msg("No vanilla key set for " + sName + ".")
			return;
		}
		$.RegisterKeyBind($.GetContextPanel(), 'key_' + vanilla_keybind, callback_function);
		Game.CreateCustomKeyBind(vanilla_keybind, sName);

		if (bHold) {
//			$.Msg("Keybind: On Hold")
//			$.Msg("+" + sName)
			Game.AddCommand("+" + sName, callback_function, "", 0);
			Game.AddCommand("-" + sName, secondary_callback_function, "", 0);
		} else {
//			$.Msg("Keybind: On Pressed")
			Game.AddCommand(sName, callback_function, "", 0);
		}

//		$.Msg(sName + " keybind of player ID " + Players.GetLocalPlayer() + ": " + vanilla_keybind);
	} else {
//		$.Msg("Local player nil, retry taunt key gathering...")
		$.Schedule(2.0, function() {
			SetupVanillaKeyBinding(sName, callback_function, bHold, secondary_callback_function)
		})
	}
}

function SetupTopBar() {
//	$.Msg("10v10 top bar")
	$.GetContextPanel().SetHasClass('TenVTen', true);
	var topbar = GameUI.Utils.FindDotaHudElement('topbar');
	topbar.style.width = '1550px';

	// Nice topbar colors
	var TopBarRadiantTeamContainer = topbar.FindChildTraverse("TopBarRadiantTeamContainer");
	var TopBarDireTeamContainer = topbar.FindChildTraverse("TopBarDireTeamContainer");

	TopBarRadiantTeamContainer.style.width = '780px'; // 620px
	TopBarDireTeamContainer.style.width = '780px'; // 620px

	// Top Bar Radiant
	var TopBarRadiantTeam = GameUI.Utils.FindDotaHudElement('TopBarRadiantTeam');
	TopBarRadiantTeam.style.width = '100%'; // 540px

	// Top Bar Dire
	var TopBarDireTeam = GameUI.Utils.FindDotaHudElement('TopBarDireTeam');
	TopBarDireTeam.style.width = '100%'; // 540px

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
}

(function(){
	GameUI.SetupVanillaKeyBinding = SetupVanillaKeyBinding;

	if (Game.GetMapInfo().map_display_name == 'imba_10v10') {
		SetupTopBar();
	}
})();
