"use strict";

function CheckForHostPrivileges(panel)
{
	var playerInfo = Game.GetLocalPlayerInfo();
	if ( !playerInfo )
		return undefined;

	// Set the "player_has_host_privileges" class on the panel, this can be used 
	// to have some sub-panels on display or be enabled for the host player.
	$.GetContextPanel().SetHasClass( "player_has_host_privileges", playerInfo.player_has_host_privileges );
	if (panel !== undefined) {
		panel.SetHasClass( "player_has_host_privileges", playerInfo.player_has_host_privileges );
	}
	return playerInfo.player_has_host_privileges;

}

function SelectDefaultGameMode(panel) {
	var mapInfo = Game.GetMapInfo();

	var mode_standard = panel.FindChildTraverse("standard_box");
	var mode_random_omg = panel.FindChildTraverse("random_omg_box");
	var mode_custom = panel.FindChildTraverse("custom_box");
	var mode_10v10 = panel.FindChildTraverse("10v10_box");

	if (mapInfo.map_display_name == "imba_standard") {
		mode_random_omg.ToggleClass("invisible");
		mode_custom.ToggleClass("invisible");
		mode_10v10.ToggleClass("invisible");

		panel.FindChildTraverse('tower_abilities_standard').SetSelected(true);
		panel.FindChildTraverse('comeback_gold_standard').SetSelected(true);
		panel.FindChildTraverse('spawn_behemoths_standard').SetSelected(true);
	} else if (mapInfo.map_display_name == "imba_random_omg") {
		mode_standard.ToggleClass("invisible");
		mode_custom.ToggleClass("invisible");
		mode_10v10.ToggleClass("invisible");
		
		panel.FindChildTraverse('tower_abilities_random_omg').SetSelected(true);
		panel.FindChildTraverse('comeback_gold_random_omg').SetSelected(true);
		panel.FindChildTraverse('spawn_behemoths_random_omg').SetSelected(true);
	} else if (mapInfo.map_display_name == "imba_custom") {
		mode_standard.ToggleClass("invisible");
		mode_random_omg.ToggleClass("invisible");
		mode_10v10.ToggleClass("invisible");
		
		panel.FindChildTraverse('tower_abilities_custom').SetSelected(true);
		panel.FindChildTraverse('comeback_gold_custom').SetSelected(true);
		panel.FindChildTraverse('spawn_behemoths_custom').SetSelected(true);
		panel.FindChildTraverse("max_level_dropdown_custom").SetSelected('50')
		panel.FindChildTraverse("gold_gain_dropdown_custom").SetSelected('200');
		panel.FindChildTraverse("xp_gain_dropdown_custom").SetSelected('200');
		panel.FindChildTraverse("creep_power_dropdown_custom").SetSelected('2');
		panel.FindChildTraverse("tower_power_dropdown_custom").SetSelected('1');
		panel.FindChildTraverse("respawn_dropdown_custom").SetSelected('respawn_half');
		panel.FindChildTraverse("buyback_dropdown_custom").SetSelected('60');
		panel.FindChildTraverse("gold_start_dropdown_custom").SetSelected('2000');
		panel.FindChildTraverse("xp_start_dropdown_custom").SetSelected('5');
	} else if (mapInfo.map_display_name == "imba_10v10") {
		mode_standard.ToggleClass("invisible");
		mode_random_omg.ToggleClass("invisible");
		mode_custom.ToggleClass("invisible");
		
		panel.FindChildTraverse('tower_abilities_10v10').SetSelected(true);
		panel.FindChildTraverse("tower_upgrades_10v10").SetSelected(true);
		panel.FindChildTraverse('comeback_gold_10v10').SetSelected(true);
		panel.FindChildTraverse('spawn_behemoths_10v10').SetSelected(true);
		panel.FindChildTraverse("gold_gain_dropdown_10v10").SetSelected('60');
		panel.FindChildTraverse("xp_gain_dropdown_10v10").SetSelected('100');
		panel.FindChildTraverse("creep_power_dropdown_10v10").SetSelected('2');
		panel.FindChildTraverse("tower_power_dropdown_10v10").SetSelected('1');
		panel.FindChildTraverse("respawn_dropdown_10v10").SetSelected('respawn_half');
		panel.FindChildTraverse("buyback_dropdown_10v10").SetSelected('120');
		panel.FindChildTraverse("gold_start_dropdown_10v10").SetSelected('2000');
		panel.FindChildTraverse("xp_start_dropdown_10v10").SetSelected('5');
	}
}

function DrawGameModeUiSelected() {
	DrawGameModeUiNonHost($.GetContextPanel());
}

function DrawGameModeUiNonHost(panel)
{
	var gameModePanel = undefined;

	if (panel == undefined) {

		gameModePanel = $.CreatePanel( "Panel", $.GetContextPanel(), "" );
		gameModePanel.BLoadLayout( "file://{resources}/layout/custom_game/game_mode.xml", false, false );

	} else {

		gameModePanel = panel;

	}

	gameModePanel.style.x = '-250px';
	gameModePanel.style.opacity = 0;
	gameModePanel.enabled = false;
	gameModePanel.SetHasClass('not_host', true);

	SelectDefaultGameMode(gameModePanel);

	gameModePanel.FindChildTraverse('Group1').SetHasClass('not_host', true);
	gameModePanel.FindChildTraverse('GroupRdnSk').SetHasClass('not_host', true);

	AnimatePanel(gameModePanel, { "transform": "translateX(250px);", "opacity": "1;" }, 1.0, "ease-out"); 
}

function DrawGameModeUi()
{

	var isHost = CheckForHostPrivileges();
	if (isHost === undefined) {
		$.Schedule(1, DrawGameModeUi);
		return;
	}

	//isHost = false;

	if (!isHost) {
		return;
	}

	var gameModePanel = $.CreatePanel( "Panel", $.GetContextPanel(), "" );
	gameModePanel.BLoadLayout( "file://{resources}/layout/custom_game/game_mode.xml", false, false );

	// default values
	SelectDefaultGameMode(gameModePanel);

	// startup animation
	gameModePanel.style.x = '-250px';
	gameModePanel.style.opacity = 0;
	AnimatePanel(gameModePanel, { "transform": "translateX(250px);", "opacity": "1;" }, 1.0, "ease-out"); 

}


// function SetGameModeNonHost(event_data)
// {
// 	var isHost = CheckForHostPrivileges();
// 	if (!isHost) {
// 		return;
// 	}

// 	DrawGameModeUiNonHost();

// 	$.GetContextPanel().FindChildTraverse("PlayMode").SetSelected(event_data.gamemode);
// 	$.GetContextPanel().FindChildTraverse("easyMode").checked = event_data.em;
// 	$.GetContextPanel().FindChildTraverse("buffStats").checked = event_data.bs;
// 	$.GetContextPanel().FindChildTraverse("buffCreeps").checked = event_data.bc;
// 	$.GetContextPanel().FindChildTraverse("buffTowers").checked = event_data.bt;
// 	$.GetContextPanel().FindChildTraverse("randomSkills").checked = event_data.omg;
// 	$.GetContextPanel().FindChildTraverse("TotalSkills").SetSelected(event_data.tskills);
// 	$.GetContextPanel().FindChildTraverse("TotalUltis").SetSelected(event_data.tultis);

// }

function SetGameMode()
{
	var mapInfo = Game.GetMapInfo();

	if (mapInfo.map_display_name == "imba_standard") {
		GameEvents.SendCustomGameEventToServer( "set_game_mode", {
			"isHost": CheckForHostPrivileges(),
			"modes": {
				"allow_same_hero": $.GetContextPanel().FindChildTraverse("allow_same_hero_standard").checked,
				"tower_abilities": $.GetContextPanel().FindChildTraverse("tower_abilities_standard").checked,
				"tower_upgrades": $.GetContextPanel().FindChildTraverse("tower_upgrades_standard").checked,
				"comeback_gold": $.GetContextPanel().FindChildTraverse("comeback_gold_standard").checked,
				"spawn_behemoths": $.GetContextPanel().FindChildTraverse("spawn_behemoths_standard").checked,
				"number_of_kills": $.GetContextPanel().FindChildTraverse("game_objective_dropdown_standard").GetSelected().id,
				"gold_bounty": $.GetContextPanel().FindChildTraverse("gold_gain_dropdown_standard").GetSelected().id,
				"xp_bounty": $.GetContextPanel().FindChildTraverse("xp_gain_dropdown_standard").GetSelected().id,
				"creep_power": $.GetContextPanel().FindChildTraverse("creep_power_dropdown_standard").GetSelected().id,
				"tower_power": $.GetContextPanel().FindChildTraverse("tower_power_dropdown_standard").GetSelected().id,
				"respawn": $.GetContextPanel().FindChildTraverse("respawn_dropdown_standard").GetSelected().id,
				"buyback": $.GetContextPanel().FindChildTraverse("buyback_dropdown_standard").GetSelected().id,
			}
		}	);
	} else if (mapInfo.map_display_name == "imba_random_omg") {
		GameEvents.SendCustomGameEventToServer( "set_game_mode", {
			"isHost": CheckForHostPrivileges(),
			"modes": {
				"tower_abilities": $.GetContextPanel().FindChildTraverse("tower_abilities_random_omg").checked,
				"tower_upgrades": $.GetContextPanel().FindChildTraverse("tower_upgrades_random_omg").checked,
				"comeback_gold": $.GetContextPanel().FindChildTraverse("comeback_gold_random_omg").checked,
				"spawn_behemoths": $.GetContextPanel().FindChildTraverse("spawn_behemoths_random_omg").checked,
				"number_of_abilities": $.GetContextPanel().FindChildTraverse("number_of_abilities_random_omg").GetSelected().id,
				"number_of_kills": $.GetContextPanel().FindChildTraverse("game_objective_dropdown_random_omg").GetSelected().id,
				"gold_bounty": $.GetContextPanel().FindChildTraverse("gold_gain_dropdown_random_omg").GetSelected().id,
				"xp_bounty": $.GetContextPanel().FindChildTraverse("xp_gain_dropdown_random_omg").GetSelected().id,
				"gold_start": $.GetContextPanel().FindChildTraverse("gold_start_dropdown_random_omg").GetSelected().id,
				"xp_start": $.GetContextPanel().FindChildTraverse("xp_start_dropdown_random_omg").GetSelected().id,
				"creep_power": $.GetContextPanel().FindChildTraverse("creep_power_dropdown_random_omg").GetSelected().id,
				"tower_power": $.GetContextPanel().FindChildTraverse("tower_power_dropdown_random_omg").GetSelected().id,
				"respawn": $.GetContextPanel().FindChildTraverse("respawn_dropdown_random_omg").GetSelected().id,
				"buyback": $.GetContextPanel().FindChildTraverse("buyback_dropdown_random_omg").GetSelected().id,
			}
		}	);
	} else if (mapInfo.map_display_name == "imba_custom") {
		GameEvents.SendCustomGameEventToServer( "set_game_mode", {
			"isHost": CheckForHostPrivileges(),
			"modes": {
				"all_random": $.GetContextPanel().FindChildTraverse("all_random_custom").checked,
				"allow_same_hero": $.GetContextPanel().FindChildTraverse("allow_same_hero_custom").checked,
				"tower_abilities": $.GetContextPanel().FindChildTraverse("tower_abilities_custom").checked,
				"tower_upgrades": $.GetContextPanel().FindChildTraverse("tower_upgrades_custom").checked,
				"frantic_mode": $.GetContextPanel().FindChildTraverse("frantic_mode_custom").checked,
				"comeback_gold": $.GetContextPanel().FindChildTraverse("comeback_gold_custom").checked,
				"spawn_behemoths": $.GetContextPanel().FindChildTraverse("spawn_behemoths_custom").checked,
				"number_of_kills": $.GetContextPanel().FindChildTraverse("game_objective_dropdown_custom").GetSelected().id,
				"level_cap": $.GetContextPanel().FindChildTraverse("max_level_dropdown_custom").GetSelected().id,
				"gold_bounty": $.GetContextPanel().FindChildTraverse("gold_gain_dropdown_custom").GetSelected().id,
				"xp_bounty": $.GetContextPanel().FindChildTraverse("xp_gain_dropdown_custom").GetSelected().id,
				"gold_start": $.GetContextPanel().FindChildTraverse("gold_start_dropdown_custom").GetSelected().id,
				"xp_start": $.GetContextPanel().FindChildTraverse("xp_start_dropdown_custom").GetSelected().id,
				"creep_power": $.GetContextPanel().FindChildTraverse("creep_power_dropdown_custom").GetSelected().id,
				"tower_power": $.GetContextPanel().FindChildTraverse("tower_power_dropdown_custom").GetSelected().id,
				"respawn": $.GetContextPanel().FindChildTraverse("respawn_dropdown_custom").GetSelected().id,
				"buyback": $.GetContextPanel().FindChildTraverse("buyback_dropdown_custom").GetSelected().id,
			}
		}	);
	} else if (mapInfo.map_display_name == "imba_10v10") {
		GameEvents.SendCustomGameEventToServer( "set_game_mode", {
			"isHost": CheckForHostPrivileges(),
			"modes": {
				"tower_abilities": $.GetContextPanel().FindChildTraverse("tower_abilities_10v10").checked,
				"tower_upgrades": $.GetContextPanel().FindChildTraverse("tower_upgrades_10v10").checked,
				"comeback_gold": $.GetContextPanel().FindChildTraverse("comeback_gold_10v10").checked,
				"spawn_behemoths": $.GetContextPanel().FindChildTraverse("spawn_behemoths_10v10").checked,
				"number_of_kills": $.GetContextPanel().FindChildTraverse("game_objective_dropdown_10v10").GetSelected().id,
				"level_cap": $.GetContextPanel().FindChildTraverse("max_level_dropdown_10v10").GetSelected().id,
				"gold_bounty": $.GetContextPanel().FindChildTraverse("gold_gain_dropdown_10v10").GetSelected().id,
				"xp_bounty": $.GetContextPanel().FindChildTraverse("xp_gain_dropdown_10v10").GetSelected().id,
				"gold_start": $.GetContextPanel().FindChildTraverse("gold_start_dropdown_10v10").GetSelected().id,
				"xp_start": $.GetContextPanel().FindChildTraverse("xp_start_dropdown_10v10").GetSelected().id,
				"creep_power": $.GetContextPanel().FindChildTraverse("creep_power_dropdown_10v10").GetSelected().id,
				"tower_power": $.GetContextPanel().FindChildTraverse("tower_power_dropdown_10v10").GetSelected().id,
				"respawn": $.GetContextPanel().FindChildTraverse("respawn_dropdown_10v10").GetSelected().id,
				"buyback": $.GetContextPanel().FindChildTraverse("buyback_dropdown_10v10").GetSelected().id,
			}
		}	);
	}

	AnimatePanel($.GetContextPanel(), { "transform": "translateX(-150px);", "opacity": "0;" }, 0.8);

	$.Schedule(1, DrawGameModeUiSelected);
}

function Set10v10ModeA()
{
	$.GetContextPanel().FindChildTraverse('tower_abilities_10v10').SetSelected(true);
	$.GetContextPanel().FindChildTraverse("tower_upgrades_10v10").SetSelected(true);
	$.GetContextPanel().FindChildTraverse("max_level_dropdown_10v10").SetSelected('35')
	$.GetContextPanel().FindChildTraverse("gold_gain_dropdown_10v10").SetSelected('30');
	$.GetContextPanel().FindChildTraverse("xp_gain_dropdown_10v10").SetSelected('60');
	$.GetContextPanel().FindChildTraverse("creep_power_dropdown_10v10").SetSelected('1');
	$.GetContextPanel().FindChildTraverse("tower_power_dropdown_10v10").SetSelected('0');
	$.GetContextPanel().FindChildTraverse("respawn_dropdown_10v10").SetSelected('respawn_normal');
	$.GetContextPanel().FindChildTraverse("buyback_dropdown_10v10").SetSelected('180');
	$.GetContextPanel().FindChildTraverse("gold_start_dropdown_10v10").SetSelected('625');
	$.GetContextPanel().FindChildTraverse("xp_start_dropdown_10v10").SetSelected('1');
}

function Set10v10ModeB()
{
	$.GetContextPanel().FindChildTraverse('tower_abilities_10v10').SetSelected(true);
	$.GetContextPanel().FindChildTraverse("tower_upgrades_10v10").SetSelected(true);
	$.GetContextPanel().FindChildTraverse("max_level_dropdown_10v10").SetSelected('35')
	$.GetContextPanel().FindChildTraverse("gold_gain_dropdown_10v10").SetSelected('60');
	$.GetContextPanel().FindChildTraverse("xp_gain_dropdown_10v10").SetSelected('100');
	$.GetContextPanel().FindChildTraverse("creep_power_dropdown_10v10").SetSelected('2');
	$.GetContextPanel().FindChildTraverse("tower_power_dropdown_10v10").SetSelected('1');
	$.GetContextPanel().FindChildTraverse("respawn_dropdown_10v10").SetSelected('respawn_half');
	$.GetContextPanel().FindChildTraverse("buyback_dropdown_10v10").SetSelected('120');
	$.GetContextPanel().FindChildTraverse("gold_start_dropdown_10v10").SetSelected('2000');
	$.GetContextPanel().FindChildTraverse("xp_start_dropdown_10v10").SetSelected('5');
}

function Set10v10ModeC()
{
	$.GetContextPanel().FindChildTraverse('tower_abilities_10v10').SetSelected(true);
	$.GetContextPanel().FindChildTraverse("tower_upgrades_10v10").SetSelected(true);
	$.GetContextPanel().FindChildTraverse("max_level_dropdown_10v10").SetSelected('50')
	$.GetContextPanel().FindChildTraverse("gold_gain_dropdown_10v10").SetSelected('150');
	$.GetContextPanel().FindChildTraverse("xp_gain_dropdown_10v10").SetSelected('150');
	$.GetContextPanel().FindChildTraverse("creep_power_dropdown_10v10").SetSelected('3');
	$.GetContextPanel().FindChildTraverse("tower_power_dropdown_10v10").SetSelected('2');
	$.GetContextPanel().FindChildTraverse("respawn_dropdown_10v10").SetSelected('respawn_half');
	$.GetContextPanel().FindChildTraverse("buyback_dropdown_10v10").SetSelected('60');
	$.GetContextPanel().FindChildTraverse("gold_start_dropdown_10v10").SetSelected('2000');
	$.GetContextPanel().FindChildTraverse("xp_start_dropdown_10v10").SetSelected('5');
}

function ShowCommunityButton() {
	var community_panel = $.GetContextPanel().FindChildTraverse("Community");
	
	community_panel.ToggleClass("invisible");
}

function OnRandomSkillsClick()
{
	//$.Msg($.GetContextPanel());
	//$.GetContextPanel().SetHasClass('invisible', true);
	//GameEvents.SendCustomGameEventToServer( "set_game_mode", { "key1" : "value1", "key2" : "value2" } );
	// $.GetContextPanel().FindChildTraverse("GroupRdnSk").ToggleClass("invisible");
	var rndsk = $.GetContextPanel().FindChildTraverse("GroupRdnSk");
	rndsk.enabled = !rndsk.enabled;
	rndsk.ToggleClass("disabled");

}

(function()
{
	// We use a nettable to communicate victory conditions to make sure we get the value regardless of timing.
	// UpdateKillsToWin();
	// CustomNetTables.SubscribeNetTableListener( "game_state", OnGameStateChanged );

 //    GameEvents.Subscribe( "countdown", UpdateTimer );
 //    GameEvents.Subscribe( "show_timer", ShowTimer );
 //    GameEvents.Subscribe( "timer_alert", AlertTimer );
 //    GameEvents.Subscribe( "overtime_alert", HideTimer );
	//UpdateTimer();

	//GameEvents.Subscribe( "game_mode_was_set", SetGameModeNonHost);

})();