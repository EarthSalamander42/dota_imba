"use strict";

var hero_bio;

function OnUpdateHeroSelection()
{
	for ( var teamId of Game.GetAllTeamIDs() )
	{
		UpdateTeam( teamId );
	}

	var localPlayerInfo = Game.GetLocalPlayerInfo();
	if ( !localPlayerInfo )
		return;

	if (localPlayerInfo.possible_hero_selection !== "")
		var hype_text = $.Localize("npc_dota_hero_" + localPlayerInfo.possible_hero_selection + "_hype");

	if (hype_text == undefined)
		return;

	var friends_and_foes = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("FriendsAndFoes");

	if (friends_and_foes && hero_bio == null) {
		hero_bio = $.CreatePanel('Label', friends_and_foes, 'HeroBio');
		hero_bio.style.height = "100%";
		hero_bio.style.paddingLeft = "4%";
		hero_bio.style.paddingRight = "4%";
		hero_bio.style.color = "#6283BB";
		hero_bio.style.fontSize = "16px";
	}
/*
	// Testing purpose
	friends_and_foes.GetChild(0).DeleteAsync(0)
	friends_and_foes.GetChild(1).DeleteAsync(0)
	friends_and_foes.GetChild(2).DeleteAsync(0)
	friends_and_foes.GetChild(3).DeleteAsync(0)
	friends_and_foes.GetChild(4).DeleteAsync(0)
*/
	if (hero_bio) {
		if (hype_text == "npc_dota_hero_" + localPlayerInfo.possible_hero_selection + "_hype")
			hero_bio.text = "";
		else
			hero_bio.text = hype_text;
	}

	var hero_portrait = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HeroPortrait").GetChild(0);

	if (hero_portrait) {
		hero_portrait.style.backgroundImage = 'url("file://{images}/heroes/selection/npc_dota_hero_' + localPlayerInfo.possible_hero_selection + '.png")';
		hero_portrait.style.backgroundSize = "100% 100%";
	}
}

function UpdateTeam( teamId )
{
	var teamPanelName = "team_" + teamId;
	var teamPanel = $( "#"+teamPanelName );
	var teamPlayers = Game.GetPlayerIDsOnTeam( teamId );
	teamPanel.SetHasClass( "no_players", ( teamPlayers.length == 0 ) );

	for ( var playerId of teamPlayers )
	{
		UpdatePlayer( teamPanel, playerId );
	}
}

function UpdatePlayer( teamPanel, playerId )
{
	var playerContainer = teamPanel.FindChildInLayoutFile( "PlayersContainer" );
	var playerPanelName = "player_" + playerId;
	var playerPanel = playerContainer.FindChild( playerPanelName );
	var player_table = CustomNetTables.GetTableValue("battlepass", playerId.toString());
	var playerIMR = playerContainer.FindChild( playerPanelName + "_imr");

	if ( playerPanel === null )
	{
		playerPanel = $.CreatePanel( "Image", playerContainer, playerPanelName );
		playerPanel.BLoadLayout( "file://{resources}/layout/custom_game/multiteam_hero_select_overlay_player.xml", false, false );
		playerPanel.AddClass( "PlayerPanel" );

		if (Game.GetMapInfo().map_display_name == "imba_1v1")
			return;

		if (player_table && player_table.IMR) {
//			$.Msg(player_table)
			playerIMR = $.CreatePanel( "Label", playerPanel, playerPanelName + "_imr" );
			playerIMR.AddClass("PlayerIMR");
			playerIMR.text = $.Localize("#custom_end_screen_legend_mmr") + ": " + player_table.IMR;
		} else if (Game.IsInToolsMode()) {
			playerIMR = $.CreatePanel( "Label", playerPanel, playerPanelName + "_imr" );
			playerIMR.AddClass("PlayerIMR");
			playerIMR.text = $.Localize("#custom_end_screen_legend_mmr") + ": " + 3000;			
		}
	}

	var playerInfo = Game.GetPlayerInfo( playerId );
	if ( !playerInfo )
		return;

	var localPlayerInfo = Game.GetLocalPlayerInfo();
	if ( !localPlayerInfo )
		return;

	var localPlayerTeamId = localPlayerInfo.player_team_id;
	var playerPortrait = playerPanel.FindChildInLayoutFile( "PlayerPortrait" );
	
	if ( playerId == localPlayerInfo.player_id )
	{
		playerPanel.AddClass( "is_local_player" );
	}

//	$.Msg(player_table.donator_level)
//	$.Msg(player_table.donator_color)

	if (player_table && player_table.donator_level && player_table.donator_color) {
		if (player_table.donator_level < 10) {
			playerPortrait.style.border = "1px solid " + player_table.donator_color;
		}
	}

	if ( playerInfo.player_selected_hero !== "" )
	{
		playerPortrait.SetImage( "file://{images}/heroes/" + playerInfo.player_selected_hero + ".png" );
		playerPanel.SetHasClass( "hero_selected", true );
		playerPanel.SetHasClass( "hero_highlighted", false );
	}
	else if ( playerInfo.possible_hero_selection !== "" && ( playerInfo.player_team_id == localPlayerTeamId ) )
	{
		playerPortrait.SetImage( "file://{images}/heroes/npc_dota_hero_" + playerInfo.possible_hero_selection + ".png" );
		playerPanel.SetHasClass( "hero_selected", false );
		playerPanel.SetHasClass( "hero_highlighted", true );
	}
	else
	{
		playerPortrait.SetImage( "file://{images}/custom_game/unassigned.png" );
	}

	var playerName = playerPanel.FindChildInLayoutFile( "PlayerName" );
	playerName.text = playerInfo.player_name;

	playerPanel.SetHasClass( "is_local_player", ( playerId == Game.GetLocalPlayerID() ) );
}

function UpdateTimer()
{
	var gameTime = Game.GetGameTime();
	var transitionTime = Game.GetStateTransitionTime();

	var timerValue = Math.max( 0, Math.floor( transitionTime - gameTime ) );
	
	if ( Game.GameStateIsAfter( DOTA_GameState.DOTA_GAMERULES_STATE_HERO_SELECTION ) )
	{
		timerValue = 0;
	}
	$("#TimerPanel").SetDialogVariableInt( "timer_seconds", timerValue );

	var banPhaseInstructions = $("#BanPhaseInstructions");
	var pickPhaseInstructions = $("#PickPhaseInstructions");

	var bIsInBanPhase = Game.IsInBanPhase();

	banPhaseInstructions.SetHasClass(  "Visible", bIsInBanPhase == true );
	pickPhaseInstructions.SetHasClass( "Visible", bIsInBanPhase == false );

	$.Schedule( 0.1, UpdateTimer );
}

(function()
{
//	var bLargeGame = Game.GetAllPlayerIDs().length >= 12;
	var bTenvTen = Game.GetAllPlayerIDs().length > 10;
	var bLargeGame = false;

	var localPlayerTeamId = Game.GetLocalPlayerInfo().player_team_id;
	var first = true;
	var teamsContainer = $("#HeroSelectTeamsContainer");
	var teamsContainer2 = $("#HeroSelectTeamsContainer2");
	$.CreatePanel( "Panel", teamsContainer, "EndSpacer" );
	$.CreatePanel( "Panel", teamsContainer2, "EndSpacer" );
	
	var timerPanel = $.CreatePanel( "Panel", $.GetContextPanel(), "TimerPanel" );
	timerPanel.BLoadLayout( "file://{resources}/layout/custom_game/multiteam_hero_select_overlay_timer.xml", false, false );

	var nTeamsCreated = 0;
	var nTeams = Game.GetAllTeamIDs().length
//	$.Msg( nTeams );

	for ( var teamId of Game.GetAllTeamIDs() )
	{
		var teamPanelToUse = null;
		if ( bLargeGame && nTeamsCreated >= ( nTeams / 2 ) )
		{
			teamPanelToUse = teamsContainer2;
		}
		else
		{
			teamPanelToUse = teamsContainer;
		}

		$.CreatePanel( "Panel", teamPanelToUse, "Spacer" );

		var teamPanelName = "team_" + teamId;
		var teamPanel = $.CreatePanel( "Panel", teamPanelToUse, teamPanelName );
		teamPanel.BLoadLayout( "file://{resources}/layout/custom_game/multiteam_hero_select_overlay_team.xml", false, false );
		teamPanel.SetHasClass("TenvTen", bTenvTen)
		var teamName = teamPanel.FindChildInLayoutFile( "TeamName" );
		if ( teamName )
		{
			teamName.text = $.Localize( Game.GetTeamDetails( teamId ).team_name );
		}

		var logo_xml = GameUI.CustomUIConfig().team_logo_xml;
		if ( logo_xml )
		{
			var teamLogoPanel = teamPanel.FindChildInLayoutFile( "TeamLogo" );
			teamLogoPanel.SetAttributeInt( "team_id", teamId );
			teamLogoPanel.BLoadLayout( logo_xml, false, false );
		}

		var teamGradient = teamPanel.FindChildInLayoutFile( "TeamGradient" );
		if ( teamGradient && GameUI.CustomUIConfig().team_colors )
		{
			var teamColor = GameUI.CustomUIConfig().team_colors[ teamId ];
			teamColor = teamColor.replace( ";", "" );
			var gradientText = 'gradient( linear, 0% 0%, 0% 100%, from( ' + teamColor + '40  ), to( #00000000 ) );';
//			$.Msg( gradientText );
			teamGradient.style.backgroundColor = gradientText;
		}

		if ( teamName )
		{
			teamName.text = $.Localize( Game.GetTeamDetails( teamId ).team_name );
		}
		teamPanel.AddClass( "TeamPanel" );

		if ( teamId === localPlayerTeamId )
		{
			teamPanel.AddClass( "local_player_team" );
		}
		else
		{
			teamPanel.AddClass( "not_local_player_team" );
		}
		nTeamsCreated = nTeamsCreated + 1;

		var imr_calculation = 0;

		for (var i = 0; i < Game.GetPlayerIDsOnTeam(teamId).length; i++) {
			var player_id = Game.GetPlayerIDsOnTeam(teamId)[i];
			var player_table = CustomNetTables.GetTableValue("battlepass", player_id.toString());

			if (Game.IsInToolsMode())
				imr_calculation += 3000;
			else {
				if (player_table && player_table.IMR) {
					imr_calculation += player_table.IMR;
				}
			}
		}

		if (Game.GetMapInfo().map_display_name != "imba_1v1") {
			if (imr_calculation != 0) {
				imr_calculation /= Game.GetPlayerIDsOnTeam(teamId).length;
				teamPanel.FindChildTraverse("IMRAverage").GetParent().style.visibility = "visible";
				teamPanel.FindChildTraverse("IMRAverage").text = $.Localize("#average_mmr") + " " + imr_calculation;
			}
		}
	}

	$.CreatePanel( "Panel", teamsContainer, "EndSpacer" );
	$.CreatePanel( "Panel", teamsContainer2, "EndSpacer" );

	OnUpdateHeroSelection();
	GameEvents.Subscribe( "dota_player_hero_selection_dirty", OnUpdateHeroSelection );
	GameEvents.Subscribe( "dota_player_update_hero_selection", OnUpdateHeroSelection );

	if (CustomNetTables.GetTableValue("game_options", "gamemode")) {
		if (CustomNetTables.GetTableValue("game_options", "gamemode")[1] == 2)
			$("#Mutations").style.visibility = "visible";
	}

	UpdateTimer();

	if (Game.GetMapInfo().map_display_name == "imba_1v1") {
		var opposite_team = 2;

		if (Game.GetPlayerInfo(Players.GetLocalPlayer()).player_team_id == 2)
			opposite_team = 3;

		if ($("#team_" + opposite_team))
			$("#team_" + opposite_team).style.visibility = "collapse";
	}
})();
