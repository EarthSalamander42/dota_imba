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

(function () {
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

				$.Msg(player_info)
				$.Msg(player_items)

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

				$.Msg("Number of items: " + Entities.GetNumItemsInInventory(player_info.player_selected_hero_entity_index))

				PlayerRowContainer.FindChildrenWithClassTraverse("LastHits")[0].text = Players.GetLastHits(id);;
				PlayerRowContainer.FindChildrenWithClassTraverse("Denies")[0].text = Players.GetDenies(id);;
				PlayerRowContainer.FindChildrenWithClassTraverse("GoldPerMin")[0].text = Players.GetGoldPerMin(id).toFixed(0);
				PlayerRowContainer.FindChildrenWithClassTraverse("XPPerMin")[0].text = Players.GetXPPerMin(id).toFixed(0);
				PlayerRowContainer.FindChildrenWithClassTraverse("HeroHealing")[0].text = 0;
			});

			$.Msg($.Localize(team_localization_name[i]))

			// Set Team name and score
			$("#" + team_name[i] + "TeamName").text = $.Localize(team_localization_name[i]); // not working?
			$("#" + team_name[i] + "TeamScore").text = "Score: " + Game.GetTeamDetails(i).team_score;

			if (Game.GetGameWinner() == i)
				$("#" + team_name[i] + "Winner").style.visibility = "visible";

			$("#" + team_name[i] + "PlayerRowLegend").BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_row_legend.xml", false, false);
//		}
	}
})();
