var is_donator_set = [];

function AdvanceTimeline()
{
	if ( !g_bPlaying )
		return false;

	$( '#DetailsHeatmapsTimelineSlider' ).value += 0.0001;
	if ( $( '#DetailsHeatmapsTimelineSlider' ).value >= 1.0 )
	{
		g_bPlaying = false;
		return true;
	}

	$.Schedule( 0.01, AdvanceTimeline );
	return true;
};

var g_bPlaying = false;
function TogglePlayPause()
{
	g_bPlaying = !g_bPlaying;
	if ( g_bPlaying )
	{
		if ( $( '#DetailsHeatmapsTimelineSlider' ).value >= 1.0 )
		{
			$( '#DetailsHeatmapsTimelineSlider' ).value = 0.0;
		}
		AdvanceTimeline();
	}
};

function LightenDarkenColor(col, amt) {
	var usePound = false;
  
	if (col[0] == "#") {
		col = col.slice(1);
		usePound = true;
	}
 
	var num = parseInt(col,16);
 
	var r = (num >> 16) + amt;
 
	if (r > 255) r = 255;
	else if  (r < 0) r = 0;
 
	var b = ((num >> 8) & 0x00FF) + amt;
 
	if (b > 255) b = 255;
	else if  (b < 0) b = 0;
 
	var g = (num & 0x0000FF) + amt;
 
	if (g > 255) g = 255;
	else if (g < 0) g = 0;
	
	var color = ("") + (g | (b << 8) | (r << 16)).toString(16);

	var length = color.length;

	if ( length < 6 ) {
		for (var i = 0; i < (6-length); i++) {
			color = "0" + color;
		}
	}

	return (usePound?"#":"") + color;
}

function rnd(min, max) {
	return Math.floor(Math.random() * (max - min + 1)) + min;
}

function SetDonatorRow(panel, playerId, player_table) {
//	$.Schedule(0.1, function(){
//		SetDonatorRow(panel, playerId)
//	})

	if (player_table && player_table.donator_level && player_table.donator_color) {
		if (player_table.donator_level < 10) {
			if (player_table.in_game_tag == 1) {
				if (is_donator_set.indexOf( playerId.toString() ) == -1) {
					is_donator_set.push( playerId.toString() );
					// panel.style.backgroundImage = 'url("file://{images}/custom_game/flyout/donator_' + player_table.donator_level + '.webm")';

//					donatorTitlePanel.style.backgroundColor = player_table.donator_color + "dd";
//					donatorTitlePanel.FindChildInLayoutFile("DonatorTitle").text = $.Localize("donator_label_" + player_table.donator_level) || "Donator";

//					donatorTitlePanel.style.visibility = "visible";

					var dark_donator_levels = [ 1, 2, 7, 9 ];
					var donator_color = player_table.donator_color;

					if ( dark_donator_levels.indexOf( player_table.donator_level ) > -1 ) {
						panel.style.backgroundColor = 'gradient( linear, 100% 0, 0 0, from( ' + donator_color + ' ), ' +
						'color-stop( 0.2, ' + LightenDarkenColor(donator_color, -60) + 'FF ), ' +
						'color-stop( 0.5, ' + donator_color + 'FF ), ' +
						'color-stop( 0.8, ' + LightenDarkenColor(donator_color, -40) + 'FF ), ' +
						'to( ' +  donator_color + ' ) )';

						panel.style.animationName = 'color_transition_bright';
					} else {
						if ( player_table.donator_level != 8 ) {
							donator_color = LightenDarkenColor(donator_color, -30);
						} else {
							donator_color = LightenDarkenColor(donator_color, 20);
						}

						panel.style.backgroundColor = 'gradient( linear, 100% 0, 0 0, from( ' + donator_color + ' ), ' +
						'color-stop( 0.2, ' + LightenDarkenColor(donator_color, -80) + 'FF ), ' +
						'color-stop( 0.5, ' + donator_color + 'FF ), ' +
						'color-stop( 0.8, ' + LightenDarkenColor(donator_color, -80) + 'FF ), ' +
						'to( ' +  donator_color + ' ) )';
					}

//					playerPanel.FindChildInLayoutFile("HeroNameAndDescription").style.color = "#FFFFFF";
//					playerPanel.FindChildInLayoutFile("HeroNameAndDescription").style.opacity = 0.7;

					if (!panel.FindChildTraverse("particle-holder")) {
						panel.BCreateChildren('<Panel id="particle-holder" />');
						var holder = panel.FindChildTraverse("particle-holder");
						var bubblecount = 30;

						for (var i = 0; i <= bubblecount; i++) {
							var size = rnd(50, 80) / 10;

							holder.BCreateChildren(
								'<Panel class="particle" style="background-color: ' + LightenDarkenColor(donator_color, 70) +
								';x:' +
								rnd(5, 90) +
								"%; y:" +
								rnd(95, 85) +
								"%;width:" +
								size +
								"px; height:" +
								size +
								"px;animation-delay: " +
								rnd(0, 40) / 10 +
								's;" />'
							);
						}
					}
				}
			} else {
				if (is_donator_set.indexOf( playerId.toString() ) != -1) {
					var index = is_donator_set.indexOf( playerId.toString() );
					is_donator_set.splice( index, 1 );
//					donatorTitlePanel.style.visibility = "collapse";
					panel.FindChildTraverse("particle-holder").DeleteAsync(1);
					panel.style.backgroundColor = "transparent";
				}
			}
		}
	}
}

(function () {
/*
	var game_options = {
		"data":{
			"players":{
				"76561198015161808":{
					"xp_multiplier": 10,
					"xp": "0",
					"xp_change": 200
				},
				"90071996842377216":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 1
				},
				"90071996842377217":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 2
				},
				"90071996842377218":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 3
				},
				"90071996842377219":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 4
				},
				"90071996842377220":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 5
				},
				"90071996842377221":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 6
				},
				"90071996842377222":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 7
				},
				"90071996842377223":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 8
				},
				"90071996842377224":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 9
				},
			}
		},
	};
*/
	$.Msg("START END SCREEN")
	// Show loading panel
	$.GetContextPanel().AddClass("MatchDataLoading");

	// Whenever data is available, hide loading panel and show actual end screen panel
	$.GetContextPanel().RemoveClass("MatchDataLoading");
	$("#ContainerLoaded").style.opacity = "1";

	// Hide Overview and use only Scoreboard tab for now
	$.GetContextPanel().AddClass("ScoreboardVisible");
	$("#DetailsOverview").style.opacity = "0";
	$("#DetailsScoreboardContainer").style.opacity = "1";
	$("#DetailsDamageDealt").style.opacity = "0"; // This is the panel following DetailsScoreboardContainer, not being used atm
	$("#PinnedHeroes").style.opacity = "1";

	if (Game.IsInToolsMode()) {
		for (var i = 0; i < $("#PinnedRadiant").GetChildCount(); i++) {
			$("#PinnedRadiant").GetChild(i).DeleteAsync(0);
		}

		for (var i = 0; i < $("#PinnedDire").GetChildCount(); i++) {
			$("#PinnedDire").GetChild(i).DeleteAsync(0);
		}

		for (var i = 0; i < $("#RadiantPlayerRows").GetChildCount(); i++) {
			$("#RadiantPlayerRows").GetChild(i).DeleteAsync(0);
		}

		for (var i = 0; i < $("#DirePlayerRows").GetChildCount(); i++) {
			$("#DirePlayerRows").GetChild(i).DeleteAsync(0);
		}
	}

//	for (var i = 0; i < Game.GetAllPlayerIDs().length; i++) {
//		Game.GetAllPlayerIDs()[i]
//	}

	var team_name = []
	team_name[2] = "Radiant";
	team_name[3] = "Dire";

	var team_localization_name = []
	team_localization_name[2] = "#DOTA_Goodguys";
	team_localization_name[3] = "#DOTA_Badguys";

	for (var i = 2; i <= 3; i++) {
		var pinned_team_container = $("#Pinned" + team_name[i]);
		pinned_team_container.AddClass("PinnedTeam");
		pinned_team_container.AddClass("TomBottomFlow");

		var player_row_container = $("#" + team_name[i] + "PlayerRows");
		// not sure why i have to hardcode it yet
		player_row_container.style.flowChildren = "down";
		player_row_container.style.height = "fit-children";
		$.Msg("Team: " + i)

//		if (Game.GetTeamDetails(i).team_num_players > 0) {
			$.Each(Game.GetPlayerIDsOnTeam(i), function(id) {
//				$.Msg("Player ID " + id + " in team " + i)
				var player_info = Game.GetPlayerInfo(id);
				var player_items = Game.GetPlayerItems(id);
				var player_table = CustomNetTables.GetTableValue("battlepass", id.toString());

				$.Msg(player_info)
				$.Msg(player_table)

				// Set left bar player informations
				var PinnedPlayerRow = $.CreatePanel('Panel', pinned_team_container, 'PinnedPlayerRow' + id);
				PinnedPlayerRow.BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_pinned_player_row.xml", false, false);
				PinnedPlayerRow.AddClass("PlayerName");
				PinnedPlayerRow.AddClass("StatRowHeight");
				PinnedPlayerRow.FindChildTraverse("HeroImage").heroname = Players.GetPlayerSelectedHero(id);
				PinnedPlayerRow.FindChildTraverse("PlayerNameScoreboard").GetChild(0).text = player_info.player_name;
				PinnedPlayerRow.FindChildrenWithClassTraverse("HeroLevelLabel")[0].text = player_info.player_level;
				PinnedPlayerRow.FindChildrenWithClassTraverse("LevelAndHero")[0].text = $.Localize(Players.GetPlayerSelectedHero(id));

				// Set middle bar player informations
				var PlayerRowContainer = $.CreatePanel('Panel', player_row_container, 'PlayerRow' + id);
				PlayerRowContainer.BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_row.xml", false, false);

				PlayerRowContainer.FindChildrenWithClassTraverse("Level")[0].text = player_info.player_level;
				PlayerRowContainer.FindChildrenWithClassTraverse("Kills")[0].text = player_info.player_kills;
				PlayerRowContainer.FindChildrenWithClassTraverse("Deaths")[0].text = player_info.player_deaths;
				PlayerRowContainer.FindChildrenWithClassTraverse("Assists")[0].text = player_info.player_assists;
//				PlayerRowContainer.FindChildrenWithClassTraverse("MMRChange")[0]
				PlayerRowContainer.FindChildrenWithClassTraverse("NetWorth")[0].text = player_info.player_gold;

				SetDonatorRow(PlayerRowContainer.GetChild(0), id, player_table)

				PlayerRowContainer.FindChildTraverse("BattlepassXPContainer").value = player_table.XP / player_table.MaxXP;

				if (player_items) {
					for (var i = player_items.inventory_slot_min; i < player_items.inventory_slot_max; i++) {
						var item = player_items.inventory[i];

						if (item)
							PlayerRowContainer.FindChildTraverse("ItemIcon" + i).itemname = item.item_name;
					}
				}

				PlayerRowContainer.FindChildrenWithClassTraverse("LastHits")[0].text = Players.GetLastHits(id);;
				PlayerRowContainer.FindChildrenWithClassTraverse("Denies")[0].text = Players.GetDenies(id);;
				PlayerRowContainer.FindChildrenWithClassTraverse("GoldPerMin")[0].text = Players.GetGoldPerMin(id).toFixed(0);
				PlayerRowContainer.FindChildrenWithClassTraverse("XPPerMin")[0].text = Players.GetXPPerMin(id).toFixed(0);
				PlayerRowContainer.FindChildrenWithClassTraverse("HeroHealing")[0].text = 0;
			});

			// Set Team name and score
			$("#HeroIconsColumn").FindChildTraverse(team_name[i] + "TeamName").text = $.Localize(team_localization_name[i]);
			$("#" + team_name[i] + "TeamScore").text = "Score: " + Game.GetTeamDetails(i).team_score;

			if (Game.GetGameWinner() == i)
				$("#" + team_name[i] + "Winner").style.visibility = "visible";

			$("#" + team_name[i] + "PlayerRowLegend").BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_row_legend.xml", false, false);
//		}
	}
})();
