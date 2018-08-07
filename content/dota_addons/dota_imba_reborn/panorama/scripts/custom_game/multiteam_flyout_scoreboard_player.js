"use strict";

var current_tooltip_timer = null;
var current_shown_tooltip_id = null;

function GetLocalPlayerId() {
	var localPlayerId = 0;
	var localPlayerInfo = Game.GetLocalPlayerInfo();
	if (typeof (localPlayerInfo) !== "undefined") {
		localPlayerId = localPlayerInfo.player_id;
	}
	return localPlayerId;
}

function HideToolTips() {
	if (current_tooltip_timer) {
		$.CancelScheduled(current_tooltip_timer);
		current_tooltip_timer = null;
	}
	current_shown_tooltip_id = null;

	$.DispatchEvent("DOTAHideTextTooltip");
}

function ShowToolTip(button_id, text_normal, text_activated) {
	var button = $.FindChildInContext(button_id)
	if (button) {
		current_tooltip_timer = null;
		current_shown_tooltip_id = button_id;

		var show_text = $.Localize(text_normal)
		if (button.BHasClass("Activated")) {
			show_text += " " + $.Localize(text_activated);
		}

		$.DispatchEvent("DOTAShowTextTooltip", button, show_text);
	}
}

function DelayedShowToolTipHelper(button_id, text_normal, text_activated) {
	if (current_tooltip_timer) {
		$.CancelScheduled(current_tooltip_timer);
	}

	//Wait awhile before displaying tooltips
	current_tooltip_timer = $.Schedule(0.5, function () {
		ShowToolTip(button_id, text_normal, text_activated);
	});
}

function ShowToolTipMute() {
	DelayedShowToolTipHelper("#BtnMuteVoice", "#scoreboard_tool_tip_mute_player", "#scoreboard_tool_tip_active_mute_player");
}

function ShowToolTipShareUnit() {
	DelayedShowToolTipHelper("#BtnShareUnit", "#scoreboard_tool_tip_share_unit", "#scoreboard_tool_tip_active_share_unit_hero");
}

function ShowToolTipShareHero() {
	DelayedShowToolTipHelper("#BtnShareHero", "#scoreboard_tool_tip_share_hero", "#scoreboard_tool_tip_active_share_unit_hero");
}

function ShowToolTipDisableHelp() {
	DelayedShowToolTipHelper("#BtnDisableHelp", "#scoreboard_tool_tip_disable_help", "#scoreboard_tool_tip_active_disable_help");
}

function ToggleMute() {
	var bol_reopen_tooltip = (current_shown_tooltip_id == "#BtnMuteVoice");
	HideToolTips();
	var playerId = $.GetContextPanel().GetAttributeInt("player_id", -1);
	if (Players.IsValidPlayerID(playerId)) {
		var muteStatus = !Game.IsPlayerMuted(playerId)
		Game.SetPlayerMuted(playerId, muteStatus);
	}
	if (bol_reopen_tooltip) {
		ShowToolTipMute();
	}
}

function ToggleEvent(toggle_event_name) {
	HideToolTips();
	var playerId = $.GetContextPanel().GetAttributeInt("player_id", -1);
	if (Players.IsValidPlayerID(playerId)) {
		GameEvents.SendCustomGameEventToServer(toggle_event_name, {
			otherPlayerID: playerId
		})
	}
}

function ToggleShareUnit() {
	var bol_reopen_tooltip = (current_shown_tooltip_id == "#BtnShareUnit");
	ToggleEvent("toggle_share_unit")
	if (bol_reopen_tooltip) {
		ShowToolTipShareUnit();
	}
}

function ToggleShareHero() {
	var bol_reopen_tooltip = (current_shown_tooltip_id == "#BtnShareHero");
	ToggleEvent("toggle_share_hero")
	if (bol_reopen_tooltip) {
		ShowToolTipShareHero();
	}
}

function ToggleDisableHelp() {
	var bol_reopen_tooltip = (current_shown_tooltip_id == "#BtnDisableHelp");
	ToggleEvent("toggle_disable_player_help")
	if (bol_reopen_tooltip) {
		ShowToolTipDisableHelp();
	}
}