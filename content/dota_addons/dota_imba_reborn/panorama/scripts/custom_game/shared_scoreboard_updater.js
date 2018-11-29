"use strict";

// =============================================================================
// =============================================================================
function _ScoreboardUpdater_SetTextSafe(panel, childName, textValue) {
	if (panel === null)
		return;
	var childPanel = panel.FindChildInLayoutFile(childName)
	if (childPanel === null)
		return;

	childPanel.text = textValue;
}

function _ScoreboardUpdater_SetValueSafe(panel, childName, Value) {
	if (panel === null)
		return;
	var childPanel = panel.FindChildInLayoutFile(childName)

	if (childPanel === null)
		return;

	childPanel.value = Value;
}

function _ScoreboardUpdater_UpdatePlayerPanelImr(playerId, playerPanel) {

//	$.Msg("Updating player imr panel");
	
	var map_info = Game.GetMapInfo();

	var ids = {
		_5v5: {
			teammate: "TeammateIMRAmount",
			player: "PlayerIMRAmount"
		},
		_10v10: {
			teammate: "TeammateIMR10v10Amount",
			player: "PlayerIMR10v10Amount"
		}
	};

	// set labels

	var steamid = Game.GetPlayerInfo(playerId).player_steamid;
	
	LoadPlayerInfo(function (playerInfo) {
		var thisPlayerInfo = null;
		playerInfo.forEach(function (i) {
			if (i.username == steamid)
				thisPlayerInfo = i;
		});

		if (thisPlayerInfo == null) // wtf
			return;

		var imr5v5 = "TBD";
		var imr10v10 = "TBD";
		if (!thisPlayerInfo.imr5v5_callibrating)
			imr5v5 = Math.floor(thisPlayerInfo.imr5v5);
		if (!thisPlayerInfo.imr10v10_callibrating)
			imr10v10 = Math.floor(thisPlayerInfo.imr10v10)

		_ScoreboardUpdater_SetTextSafe(playerPanel, ids._5v5.teammate, imr5v5);
		_ScoreboardUpdater_SetTextSafe(playerPanel, ids._10v10.teammate, imr10v10);
		
	});
}

function _ScoreboardUpdater_UpdatePlayerPanelXP(playerId, playerPanel, ImbaXP_Panel) {

//	$.Msg("Updating player xp panel");

	var ids = {
		xpRank:  "ImbaXPRank" + playerId,
		xp: "ImbaXP" + playerId,
		xpEarned: "ImbaXPEarned" + playerId,
		level: "ImbaLvl" + playerId,
		progress_bar: "XPProgressBar" + playerId,
	};

	// setup panels
	ImbaXP_Panel.BCreateChildren("<Panel id='XPProgressBarContainer" + playerId + "' value='0.0'/>");
	var Imbar = ImbaXP_Panel.BCreateChildren("<ProgressBar id='XPProgressBar" + playerId + "'/>");
	ImbaXP_Panel.BCreateChildren("<Label id='ImbaLvl" + playerId + "' text='999'/>");
	ImbaXP_Panel.BCreateChildren("<Label id='ImbaXPRank" + playerId + "' text='999'/>");
	ImbaXP_Panel.BCreateChildren("<Label id='ImbaXP" + playerId + "' text='999'/>");
	ImbaXP_Panel.BCreateChildren("<Label id='ImbaXPEarned" + playerId + "' text='+0'/>");

	var steamid = Game.GetPlayerInfo(playerId).player_steamid;

	// load player data from api
//	LoadPlayerInfo(function (data) {
//		var thisPlayerInfo = null;
//		playerInfo.forEach(function (i) {
//			if (i.steamid == steamid)
//				thisPlayerInfo = i;
//		});

//		if (thisPlayerInfo == null) // wtf
//			return;

//		_ScoreboardUpdater_SetTextSafe(playerPanel, ids.xpRank, thisPlayerInfo.xp_rank_title);
//		_ScoreboardUpdater_SetTextSafe(playerPanel, ids.xp, thisPlayerInfo.xp_in_current_level + "/" + thisPlayerInfo.total_xp_for_current_level);
//		_ScoreboardUpdater_SetTextSafe(playerPanel, ids.level, thisPlayerInfo.xp_level);
//		_ScoreboardUpdater_SetValueSafe(playerPanel, ids.progress_bar, thisPlayerInfo.xp_in_current_level / thisPlayerInfo.total_xp_for_current_level);
//		playerPanel.FindChildTraverse(ids.xpRank).style.color = "#" + thisPlayerInfo.xp_rank_color;

//	});

	// xp shown fix (temporary?)
	var player_info = CustomNetTables.GetTableValue("player_table", playerId)
	_ScoreboardUpdater_SetTextSafe(playerPanel, ids.xpRank, player_info.title);
	_ScoreboardUpdater_SetTextSafe(playerPanel, ids.xp, player_info.XP + "/" + player_info.MaxXP);
	_ScoreboardUpdater_SetTextSafe(playerPanel, ids.level, player_info.Lvl);
	_ScoreboardUpdater_SetValueSafe(playerPanel, ids.progress_bar, player_info.XP / player_info.MaxXP);
	playerPanel.FindChildTraverse(ids.xpRank).style.color = player_info.title_color;

}
// =============================================================================
// =============================================================================
function _ScoreboardUpdater_UpdatePlayerPanel(scoreboardConfig, playersContainer, playerId, localPlayerTeamId) {
	var playerPanelName = "_dynamic_player_" + playerId;
	var playerPanel = playersContainer.FindChild(playerPanelName);
	if (playerPanel === null) {
		playerPanel = $.CreatePanel("Panel", playersContainer, playerPanelName);
		playerPanel.SetAttributeInt("player_id", playerId);
		playerPanel.BLoadLayout(scoreboardConfig.playerXmlName, false, false);

		// setup XP and IMR
		var ImbaXP_Panel = playerPanel.FindChildInLayoutFile("PanelImbaXP");

		if (ImbaXP_Panel != null) {
			// get player data
			var plyData = CustomNetTables.GetTableValue("player_table", playerId);

			if (plyData != null) {
				// set xp values
				_ScoreboardUpdater_UpdatePlayerPanelXP(playerId, playerPanel, ImbaXP_Panel);

				// set imr values
				_ScoreboardUpdater_UpdatePlayerPanelImr(playerId, playerPanel);
			}
		}
	}

//	playerPanel.SetHasClass("is_local_player", (playerId == Game.GetLocalPlayerID()));

	var player_table = CustomNetTables.GetTableValue("player_table", playerId.toString());
//		$.Msg(player_table.donator_level)
//		$.Msg(player_table.donator_color)
	if (player_table && player_table.donator_level && player_table.donator_color) {
		if (player_table.donator_level < 10) {
			playerPanel.style.backgroundColor = player_table.donator_color;
//			playerPanel.backgroundColor = 'gradient( linear, 100% 0, 0 0, from( ' + player_table.donator_color + ' ), color-stop( 0.4, #FFFFFF ), to( #FFFFFF ) )';
		}
	}

	// values > 0 mean on on cooldown for x seconds
	var ultStateOrTime = PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_HIDDEN;
	var goldValue = -1;
	var isTeammate = false;
	var isSpectator = false;

	var playerInfo = Game.GetPlayerInfo(playerId);
	if (playerInfo) {
		isTeammate = (playerInfo.player_team_id == localPlayerTeamId);
		isSpectator = Players.IsSpectator(Game.GetLocalPlayerID());
		if (isTeammate || isSpectator) {
			ultStateOrTime = Game.GetPlayerUltimateStateOrTime(playerId);
		}
		goldValue = playerInfo.player_gold;

		playerPanel.SetHasClass("player_dead", (playerInfo.player_respawn_seconds >= 0));
		playerPanel.SetHasClass("local_player_teammate", isTeammate && (playerId != Game.GetLocalPlayerID()));
		playerPanel.SetHasClass("spectator_view", isSpectator);

		// valua is rounded dow so just add one for rounded up
		_ScoreboardUpdater_SetTextSafe(playerPanel, "RespawnTimer", (playerInfo.player_respawn_seconds + 1));
		_ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerName", playerInfo.player_name);
		_ScoreboardUpdater_SetTextSafe(playerPanel, "Level", playerInfo.player_level);
		_ScoreboardUpdater_SetTextSafe(playerPanel, "Kills", playerInfo.player_kills);
		_ScoreboardUpdater_SetTextSafe(playerPanel, "Deaths", playerInfo.player_deaths);
		_ScoreboardUpdater_SetTextSafe(playerPanel, "Assists", playerInfo.player_assists);

		var btnMuteVoice = playerPanel.FindChildInLayoutFile("BtnMuteVoice");

		if (btnMuteVoice) {
			btnMuteVoice.SetHasClass("Activated", Game.IsPlayerMuted(playerId));
		}

		var tableValue = CustomNetTables.GetTableValue("shared_unit_control", Game.GetLocalPlayerID());
		if (tableValue && tableValue[playerId] != null) {
			var btnShareUnit = playerPanel.FindChildInLayoutFile("BtnShareUnit");
			var btnShareHero = playerPanel.FindChildInLayoutFile("BtnShareHero");
			var btnDisableHelp = playerPanel.FindChildInLayoutFile("BtnDisableHelp");

			// bitmask; 1 shares heroes, 2 shares units, 4 disables help
			if (btnShareUnit) {
				btnShareUnit.SetHasClass("Activated", ((tableValue[playerId] & 2) > 0));
			}
			if (btnShareHero) {
				btnShareHero.SetHasClass("Activated", ((tableValue[playerId] & 1) > 0));
			}
			if (btnDisableHelp) {
				btnDisableHelp.SetHasClass("Activated", ((tableValue[playerId] & 4) > 0));
			}
		}

		var playerPortrait = playerPanel.FindChildInLayoutFile("HeroIcon");
		if (playerPortrait) {
			if (playerInfo.player_selected_hero !== "") {
				playerPortrait.SetImage("file://{images}/heroes/" + playerInfo.player_selected_hero + ".png");
			} else {
				playerPortrait.SetImage("file://{images}/custom_game/unassigned.png");
			}
		}

		if (playerInfo.player_selected_hero_id == -1) {
			_ScoreboardUpdater_SetTextSafe(playerPanel, "HeroName", $.Localize("#DOTA_Scoreboard_Picking_Hero"))
		} else {
			_ScoreboardUpdater_SetTextSafe(playerPanel, "HeroName", $.Localize("#" + playerInfo.player_selected_hero))
		}

		var heroNameAndDescription = playerPanel.FindChildInLayoutFile("HeroNameAndDescription");
		if (heroNameAndDescription) {
			if (playerInfo.player_selected_hero_id == -1) {
				heroNameAndDescription.SetDialogVariable("hero_name", $.Localize("#DOTA_Scoreboard_Picking_Hero"));
			} else {
				heroNameAndDescription.SetDialogVariable("hero_name", $.Localize("#" + playerInfo.player_selected_hero));
			}
			// heroNameAndDescription.SetDialogVariableInt( "hero_level",
			// playerInfo.player_level );
		}

		playerPanel.SetHasClass("player_connection_abandoned", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED);
		playerPanel.SetHasClass("player_connection_failed", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_FAILED);
		playerPanel.SetHasClass("player_connection_disconnected", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED);

		var playerAvatar = playerPanel.FindChildInLayoutFile("AvatarImage");
		if (playerAvatar) {
			playerAvatar.steamid = playerInfo.player_steamid;
		}

		var playerColorBar = playerPanel.FindChildInLayoutFile("PlayerColorBar");
		if (playerColorBar !== null) {
			var PlyColors = CustomNetTables.GetTableValue("game_options", "player_colors");
			if (PlyColors != undefined)
			{
				if (PlyColors[playerId] != undefined)
					playerColorBar.style.backgroundColor = PlyColors[playerId];
			}
		}
	}

	var playerItemsContainer = playerPanel.FindChildInLayoutFile("PlayerItemsContainer");
	if (playerItemsContainer) {
		var playerItems = Game.GetPlayerItems(playerId);
		if (playerItems) {
			// $.Msg( "playerItems = ", playerItems );
			for (var i = playerItems.inventory_slot_min; i < playerItems.inventory_slot_max; ++i) {
				var itemPanelName = "_dynamic_item_" + i;
				var itemPanel = playerItemsContainer.FindChild(itemPanelName);

				var itemInfo = playerItems.inventory[i];

				if (itemPanel === null) {
					// Needs DOTAItemImage to be able to load from flash3 images
					// (similar to those used for dota shop, hence reusing
					// existing resources)
					itemPanel = $.CreatePanel("DOTAItemImage", playerItemsContainer, itemPanelName);
					itemPanel.AddClass("PlayerItem");
				}


				if (itemInfo) {
					itemPanel.itemname = itemInfo.item_name;
				} else {
					itemPanel.itemname = "";
				}
			}
		}
	}

	if (isTeammate || isSpectator) {
		_ScoreboardUpdater_SetTextSafe(playerPanel, "TeammateGoldAmount", goldValue);
	}

	_ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerGoldAmount", goldValue);

	playerPanel.SetHasClass("player_ultimate_ready", (ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_READY));
	playerPanel.SetHasClass("player_ultimate_no_mana", (ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_NO_MANA));
	playerPanel.SetHasClass("player_ultimate_not_leveled", (ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_NOT_LEVELED));
	playerPanel.SetHasClass("player_ultimate_hidden", (ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_HIDDEN));
	playerPanel.SetHasClass("player_ultimate_cooldown", (ultStateOrTime > 0));
	_ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerUltimateCooldown", ultStateOrTime);
}

// =============================================================================
// =============================================================================
function _ScoreboardUpdater_UpdateTeamPanel(scoreboardConfig, containerPanel, teamDetails, teamsInfo) {
	if (!containerPanel)
		return;

	var teamId = teamDetails.team_id;
	// $.Msg( "_ScoreboardUpdater_UpdateTeamPanel: ", teamId );

	var teamPanelName = "_dynamic_team_" + teamId;
	var teamPanel = containerPanel.FindChild(teamPanelName);
	if (teamPanel === null) {
		// $.Msg( "UpdateTeamPanel.Create: ", teamPanelName, " = ",
		// scoreboardConfig.teamXmlName );
		teamPanel = $.CreatePanel("Panel", containerPanel, teamPanelName);
		teamPanel.SetAttributeInt("team_id", teamId);
		teamPanel.BLoadLayout(scoreboardConfig.teamXmlName, false, false);

		var logo_xml = GameUI.CustomUIConfig().team_logo_xml;
		if (logo_xml) {
			var teamLogoPanel = teamPanel.FindChildInLayoutFile("TeamLogo");
			if (teamLogoPanel) {
				teamLogoPanel.SetAttributeInt("team_id", teamId);
				teamLogoPanel.BLoadLayout(logo_xml, false, false);
			}
		}
	}

	var localPlayerTeamId = -1;
	var localPlayer = Game.GetLocalPlayerInfo();
	if (localPlayer) {
		localPlayerTeamId = localPlayer.player_team_id;
	}
	teamPanel.SetHasClass("local_player_team", localPlayerTeamId == teamId);
	teamPanel.SetHasClass("not_local_player_team", localPlayerTeamId != teamId);

	var teamPlayers = Game.GetPlayerIDsOnTeam(teamId)
	var playersContainer = teamPanel.FindChildInLayoutFile("PlayersContainer");
	if (playersContainer) {
		for (var playerId of teamPlayers) {
			_ScoreboardUpdater_UpdatePlayerPanel(scoreboardConfig, playersContainer, playerId, localPlayerTeamId)
		}
	}

	teamPanel.SetHasClass("no_players", (teamPlayers.length == 0))
	teamPanel.SetHasClass("one_player", (teamPlayers.length == 1))

	if (teamsInfo.max_team_players < teamPlayers.length) {
		teamsInfo.max_team_players = teamPlayers.length;
	}

	_ScoreboardUpdater_SetTextSafe(teamPanel, "TeamScore", teamDetails.team_score)
	_ScoreboardUpdater_SetTextSafe(teamPanel, "TeamName", $.Localize(teamDetails.team_name).toUpperCase())

	if (GameUI.CustomUIConfig().team_colors) {
		var teamColor = GameUI.CustomUIConfig().team_colors[teamId];
		var teamColorPanel = teamPanel.FindChildInLayoutFile("TeamColor");

		teamColor = teamColor.replace(";", "");

		if (teamColorPanel) {
			teamNamePanel.style.backgroundColor = teamColor + ";";
		}

		var teamColor_GradentFromTransparentLeft = teamPanel.FindChildInLayoutFile("TeamColor_GradentFromTransparentLeft");
		if (teamColor_GradentFromTransparentLeft) {
			var gradientText = 'gradient( linear, 0% 0%, 800% 0%, from( #00000000 ), to( ' + teamColor + ' ) );';
			// $.Msg( gradientText );
			teamColor_GradentFromTransparentLeft.style.backgroundColor = gradientText;
		}
	}

	return teamPanel;
}

// =============================================================================
// =============================================================================
function _ScoreboardUpdater_ReorderTeam(scoreboardConfig, teamsParent, teamPanel, teamId, newPlace, prevPanel) {
	// $.Msg( "UPDATE: ", GameUI.CustomUIConfig().teamsPrevPlace );
	var oldPlace = null;
	if (GameUI.CustomUIConfig().teamsPrevPlace.length > teamId) {
		oldPlace = GameUI.CustomUIConfig().teamsPrevPlace[teamId];
	}
	GameUI.CustomUIConfig().teamsPrevPlace[teamId] = newPlace;

	if (newPlace != oldPlace) {
		// $.Msg( "Team ", teamId, " : ", oldPlace, " --> ", newPlace );
		teamPanel.RemoveClass("team_getting_worse");
		teamPanel.RemoveClass("team_getting_better");
		if (newPlace > oldPlace) {
			teamPanel.AddClass("team_getting_worse");
		} else if (newPlace < oldPlace) {
			teamPanel.AddClass("team_getting_better");
		}
	}

	teamsParent.MoveChildAfter(teamPanel, prevPanel);
}

// sort / reorder as necessary
function compareFunc(a, b) // GameUI.CustomUIConfig().sort_teams_compare_func;
{
	if (a.team_score < b.team_score) {
		return 1; // [ B, A ]
	} else if (a.team_score > b.team_score) {
		return -1; // [ A, B ]
	} else {
		return 0;
	}
};

function stableCompareFunc(a, b) {
	var unstableCompare = compareFunc(a, b);
	if (unstableCompare != 0) {
		return unstableCompare;
	}

	if (GameUI.CustomUIConfig().teamsPrevPlace.length <= a.team_id) {
		return 0;
	}

	if (GameUI.CustomUIConfig().teamsPrevPlace.length <= b.team_id) {
		return 0;
	}

	// $.Msg( GameUI.CustomUIConfig().teamsPrevPlace );

	var a_prev = GameUI.CustomUIConfig().teamsPrevPlace[a.team_id];
	var b_prev = GameUI.CustomUIConfig().teamsPrevPlace[b.team_id];
	if (a_prev < b_prev) // [ A, B ]
	{
		return -1; // [ A, B ]
	} else if (a_prev > b_prev) // [ B, A ]
	{
		return 1; // [ B, A ]
	} else {
		return 0;
	}
};

// =============================================================================
// =============================================================================
function _ScoreboardUpdater_UpdateAllTeamsAndPlayers(scoreboardConfig, teamsContainer) {
	// $.Msg( "_ScoreboardUpdater_UpdateAllTeamsAndPlayers: ", scoreboardConfig
	// );

	var teamsList = [];
	for (var teamId of Game.GetAllTeamIDs()) {
		teamsList.push(Game.GetTeamDetails(teamId));
	}

	// update/create team panels
	var teamsInfo = {
		max_team_players: 0
	};
	var panelsByTeam = [];
	for (var i = 0; i < teamsList.length; ++i) {
		var teamPanel = _ScoreboardUpdater_UpdateTeamPanel(scoreboardConfig, teamsContainer, teamsList[i], teamsInfo);
		if (teamPanel) {
			panelsByTeam[teamsList[i].team_id] = teamPanel;
		}
	}

	if (teamsList.length > 1) {
		// $.Msg( "panelsByTeam: ", panelsByTeam );

		// sort
		if (scoreboardConfig.shouldSort) {
			teamsList.sort(stableCompareFunc);
		}

		// $.Msg( "POST: ", teamsAndPanels );

		// reorder the panels based on the sort
		var prevPanel = panelsByTeam[teamsList[0].team_id];
		for (var i = 0; i < teamsList.length; ++i) {
			var teamId = teamsList[i].team_id;
			var teamPanel = panelsByTeam[teamId];
			_ScoreboardUpdater_ReorderTeam(scoreboardConfig, teamsContainer, teamPanel, teamId, i, prevPanel);
			prevPanel = teamPanel;
		}
		// $.Msg( GameUI.CustomUIConfig().teamsPrevPlace );
	}

	// $.Msg( "END _ScoreboardUpdater_UpdateAllTeamsAndPlayers: ",
	// scoreboardConfig );
}


// =============================================================================
// =============================================================================
function ScoreboardUpdater_InitializeScoreboard(scoreboardConfig, scoreboardPanel) {
	GameUI.CustomUIConfig().teamsPrevPlace = [];
	if (typeof (scoreboardConfig.shouldSort) === 'undefined') {
		// default to false
		scoreboardConfig.shouldSort = false;
	}
	_ScoreboardUpdater_UpdateAllTeamsAndPlayers(scoreboardConfig, scoreboardPanel);
	return {
		"scoreboardConfig": scoreboardConfig,
		"scoreboardPanel": scoreboardPanel
	}
}


// =============================================================================
// =============================================================================
function ScoreboardUpdater_SetScoreboardActive(scoreboardHandle, isActive) {
	if (scoreboardHandle.scoreboardConfig === null || scoreboardHandle.scoreboardPanel === null) {
		return;
	}

	if (isActive) {
		_ScoreboardUpdater_UpdateAllTeamsAndPlayers(scoreboardHandle.scoreboardConfig, scoreboardHandle.scoreboardPanel);
	}
}

// =============================================================================
// =============================================================================
function ScoreboardUpdater_GetTeamPanel(scoreboardHandle, teamId) {
	if (scoreboardHandle.scoreboardPanel === null) {
		return;
	}

	var teamPanelName = "_dynamic_team_" + teamId;
	return scoreboardHandle.scoreboardPanel.FindChild(teamPanelName);
}

// =============================================================================
// =============================================================================
function ScoreboardUpdater_GetSortedTeamInfoList(scoreboardHandle) {
	var teamsList = [];
	for (var teamId of Game.GetAllTeamIDs()) {
		teamsList.push(Game.GetTeamDetails(teamId));
	}

	if (teamsList.length > 1) {
		teamsList.sort(stableCompareFunc);
	}

	return teamsList;
}

var playerInfo = null;
var playerInfoPending = [];

// returns true if available
function LoadPlayerInfo(cb) {
	
	$.Msg("Loading player info");

	if (playerInfo !== null) {
		cb(playerInfo);
		return;
	}

	playerInfoPending.push(cb);

	if (playerInfoPending.length > 1)
		return;

	// get all player ids
	var steamids = [];
	Game.GetAllPlayerIDs().forEach(function (i) {
		steamids.push(Game.GetPlayerInfo(i).player_steamid);
	});

	api.multi_player_info(steamids).then(function (data) {
		playerInfo = data;
		playerInfoPending.forEach(function (fn) {
			fn(playerInfo);
		});
		playerInfoPending = [];
	}).catch(function (err) {
		$.Msg("Cannot load player info: " + err.message);
	});
}