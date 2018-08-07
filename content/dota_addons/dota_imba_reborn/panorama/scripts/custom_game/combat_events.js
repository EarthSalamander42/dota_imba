// Toasts (Ported from AABS, credits to the owner)

// url("s2r://panorama/images/hud/icon_kill_ally_psd.vtex")
// url("s2r://panorama/images/hud/icon_kill_enemy_psd.vtex")

// <DOTAEmoticon src="file://{images}/emoticons/bountyrune.png" defaultsrc="" scaling="stretch"
// width and height = 24px, transform = translateY( 10px )

function CreateCustomToast(data) {
	var row = $.CreatePanel('Panel', $('#CustomToastManager'), '');
	row.BLoadLayoutSnippet('ToastPanel');
	row.AddClass('ToastPanel');
	var rowText = '';
	var gold = data.gold

	if (data.type === 'kill') {
		var byNeutrals = data.killerPlayer == undefined && data.neutral == true && data.suicide == false;
		var isSelfKill = data.suicide == true;
		var isAllyKill = !byNeutrals && data.victimPlayer == true && Players.GetTeam(data.victimPlayer) === Players.GetTeam(data.killerPlayer) && data.roshan == undefined;
		var isVictim = data.victimPlayer === Game.GetLocalPlayerID();
		var isKiller = data.killerPlayer === Game.GetLocalPlayerID();
		var isRoshanKill = data.roshan == true;
		var isTowerKill = data.tower == true;
//		var teamVictim = byNeutrals || Players.GetTeam(data.victimPlayer) === Players.GetTeam(Game.GetLocalPlayerID());
		var teamKiller = !byNeutrals && Players.GetTeam(data.killerPlayer) === Players.GetTeam(Game.GetLocalPlayerID());
		row.SetHasClass('AllyEvent', teamKiller);
		row.SetHasClass('EnemyEvent', byNeutrals || !teamKiller);
		row.SetHasClass('LocalPlayerInvolved', isVictim || isKiller);
		row.SetHasClass('LocalPlayerKiller', isKiller);
		row.SetHasClass('LocalPlayerVictim', isVictim);

		if (isKiller) {
			Game.EmitSound('notification.self.kill');
		} else if (isVictim)
			Game.EmitSound('notification.self.death');
		else if (teamKiller)
			Game.EmitSound('notification.teammate.kill');
//		else if (teamVictim)
//			Game.EmitSound('notification.teammate.death');
		if (isSelfKill) {
			Game.EmitSound('notification.self.kill');
			rowText = $.Localize('custom_toast_PlayerDeniedSelf');
		} else if (isAllyKill) {
			rowText = $.Localize('#custom_toast_PlayerDenied');
		} else if (isRoshanKill) {
			rowText = '{team_name} {killed_icon} {roshan_icon} Roshan {gold}';
		} else {
			if (byNeutrals) {
				rowText = $.Localize('#npc_dota_neutral_creep');
			} else {
				rowText = '{killer_name}';
			}

			if (data.roshan != true) {
				rowText = rowText + ' {killed_icon} {victim_name} {gold}';
			}
		}
	} else if (data.type === 'generic') {
		if (data.teamPlayer == true || data.teamColor == true) {
			var team = data.teamPlayer == false ? data.teamColor : Players.GetTeam(data.teamPlayer);
			var teamVictim = team === Players.GetTeam(Game.GetLocalPlayerID());
			if (data.teamInverted === 1)
				teamVictim = !teamVictim;
			row.SetHasClass('AllyEvent', teamVictim);
			row.SetHasClass('EnemyEvent', !teamVictim);
		} else {
			row.AddClass('AllyEvent');
			rowText = $.Localize(data.text);
		}

		if (data.tower) {
			$.Msg(data.teamPlayer)
			var team = data.teamPlayer == false ? data.teamColor : Players.GetTeam(data.teamPlayer);
			rowText = '{team_name} {killed_icon} {victim_name}';
		}
	}

	// yet nothing different
	if (data.firstblood == true) {
		rowText = rowText.replace('{denied_icon}', "<img class='DeniedIcon'/>").replace('{killed_icon}', "<img class='CombatEventKillIcon'/>").replace('{time_dota}', "<font color='lime'>" + secondsToMS(Game.GetDOTATime(false, false), true) + '</font>');
	} else {
		rowText = rowText.replace('{denied_icon}', "<img class='DeniedIcon'/>").replace('{killed_icon}', "<img class='CombatEventKillIcon'/>").replace('{time_dota}', "<font color='lime'>" + secondsToMS(Game.GetDOTATime(false, false), true) + '</font>');
	}

	if (data.player != null)
		rowText = rowText.replace('{player_name}', CreateHeroElements(data.player));
	if (data.victimPlayer != null)
		rowText = rowText.replace('{victim_name}', CreateHeroElements(data.victimPlayer));
	if (data.killerPlayer != null) {
		rowText = rowText.replace('{killer_name}', CreateHeroElements(data.killerPlayer));
	}

	if (byNeutrals) {
		rowText = rowText.replace('{gold}', "");
	}

	if (data.victimUnitName)
		rowText = rowText.replace('{victim_name}', "<font color='red'>" + $.Localize(data.victimUnitName) + '</font>');
	if (data.team != null)
		rowText = rowText.replace('{team_name}', "<font color='" + GameUI.CustomUIConfig().team_colors[data.team] + "'>" + GameUI.CustomUIConfig().team_names[data.team] + '</font>');
	if (data.glyph == true)
		rowText = rowText.replace('{glyph_icon}', "<img class='CombatEventGlyphIcon' />");
	if (data.courier == true)
		rowText = rowText.replace('{courier_icon}', "<img class='CombatEventCourierIcon' />");
	if (data.roshan)
		rowText = rowText.replace('{roshan_icon}', "<img class='CombatEventRoshanIcon' />");
	if (data.runeType != null)
		if (data.runeType == "bounty" && data.runeFirst == true) {
			rowText = rowText.replace('{rune_name}', "<font color='#" + RUNES_COLOR_MAP[data.runeType] + "'>" + $.Localize('DOTA_Tooltip_ability_item_imba_rune_' + data.runeType) + ' (global) </font>');
		} else {
			rowText = rowText.replace('{rune_name}', "<font color='#" + RUNES_COLOR_MAP[data.runeType] + "'>" + $.Localize('DOTA_Tooltip_ability_item_imba_rune_' + data.runeType) + '</font>');			
		}
	if (gold != null && gold > 0) {
		rowText = rowText.replace('{gold}', "<font color='gold'>" + FormatGold(gold.toFixed(0)) + "</font> <img class='CombatEventGoldIcon' />");
	} else {
		rowText = rowText.replace('{gold}', "");
	}

	if (data.tower) {
		rowText = rowText.replace('{team_name}', "<font color='" + GameUI.CustomUIConfig().team_colors[data.team] + "'>" + GameUI.CustomUIConfig().team_names[data.team] + '</font>');
	}

	if (data.variables)
		for (var k in data.variables) {
			//			rowText = rowText.replace(k, $.Localize(data.variables[k]));
			rowText = rowText + ' (' + $.Localize(data.variables[k]) + ")";
		}
	if (rowText.indexOf('<img') === -1)
		row.AddClass('SimpleText');
	row.FindChildTraverse('ToastLabel').text = rowText;
	$.Schedule(10, function () {
		row.AddClass('Collapsed');
	});
	row.DeleteAsync(10.3);
};

var RUNES_COLOR_MAP = {
	"bounty": 'FF7800',
	"haste": 'F62817',
	"arcane": 'FD3AFB',
	"frost": '0099FF',
	"invisibility": '8B008B',
	"regeneration": '7FFF00',
	"double_damage": '80CCFF',
	"illusion": 'FFEC5E',
};

function CreateHeroElements(id) {
	var playerColor = GetHEXPlayerColor(id);
	return "<img src='" + TransformTextureToPath(GetPlayerHeroName(id), 'icon') + "' class='CombatEventHeroIcon'/> <font color='" + playerColor + "'>" + Players.GetPlayerName(id).encodeHTML() + '</font>';
}

function GetHEXPlayerColor(playerId) {
	var playerColor = Players.GetPlayerColor(playerId).toString(16);
	return playerColor == null ? '#000000' : ('#' + playerColor.substring(6, 8) + playerColor.substring(4, 6) + playerColor.substring(2, 4) + playerColor.substring(0, 2));
}

function secondsToMS(seconds, bTwoChars) {
	var sec_num = parseInt(seconds, 10);
	var minutes = Math.floor(sec_num / 60);
	var seconds = Math.floor(sec_num - minutes * 60);

	if (bTwoChars && minutes < 10)
		minutes = '0' + minutes;
	if (seconds < 10)
		seconds = '0' + seconds;
	return minutes + ':' + seconds;
}

String.prototype.encodeHTML = function () {
	return this.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&apos;');
};

function TransformTextureToPath(texture, optPanelImageStyle) {
	//	if (IsHeroName(texture)) {
	return optPanelImageStyle === 'portrait' ?
		'file://{images}/heroes/selection/' + texture + '.png' :
		optPanelImageStyle === 'icon' ?
		'file://{images}/heroes/icons/' + texture + '.png' :
		'file://{images}/heroes/' + texture + '.png';
	//	} else if (IsBossName(texture)) {
	//		return bossesMap[texture] || 'file://{images}/custom_game/units/' + texture + '.png';
	//	} else if (texture.lastIndexOf('npc_') === 0) {
	//		return optPanelImageStyle === 'portrait' ?
	//			'file://{images}/custom_game/units/portraits/' + texture + '.png' :
	//			'file://{images}/custom_game/units/' + texture + '.png';
	//	} else {
	//		return optPanelImageStyle === 'item' ?
	//			'raw://resource/flash3/images/items/' + texture + '.png' :
	//			'raw://resource/flash3/images/spellicons/' + texture + '.png';
	//	}
}

function GetPlayerHeroName(playerId) {
	if (Players.IsValidPlayerID(playerId)) {
		return Game.GetPlayerInfo(playerId).player_selected_hero
	}
	return '';
}

function FormatGold(value) {
	return (GameUI.IsAltDown() ? value : value > 9999999 ? (value / 1000000).toFixed(2) + 'M' : value > 99999 ? (value / 1000).toFixed(1) + 'k' : value)
		.toString()
		.replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
}

(function () {
	GameEvents.Subscribe('create_custom_toast', CreateCustomToast);
})();