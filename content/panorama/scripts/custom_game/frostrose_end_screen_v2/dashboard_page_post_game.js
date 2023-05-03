var is_donator_set = [];

var permanent_buffs = {
	"modifier_imba_flesh_heap_stacks": "spellicons",
	"modifier_imba_finger_of_death_counter": "spellicons",
	"modifier_imba_silencer_arcane_supremacy": "spellicons",
	"modifier_slark_essence_shift_permanent_buff": "spellicons",
	"modifier_imba_slark_essence_shift_permanent_buff": "spellicons",
	"modifier_imba_singularity": "spellicons",
	"modifier_imba_rubick_clandestine_librarian": "spellicons",
	"modifier_legion_commander_duel_damage_boost": "spellicons",
	"modifier_imba_timbersaw_chakram_3": "spellicons",
	"modifier_imba_necromastery_souls": "spellicons",
	"modifier_imba_clinkz_death_pact_723_permanent_buff": "spellicons",
	"modifier_imba_furion_wrath_of_nature": "spellicons",
	"modifier_imba_furion_wrath_of_nature": "spellicons",
	"modifier_imba_jinada_gold_tracker": "spellicons",

	"modifier_item_ultimate_scepter_consumed": "items",
	"modifier_item_tome_of_knowledge_consumed": "items",
	"modifier_item_imba_moon_shard_active": "items",
	"modifier_item_imba_banana": "items",
}

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

function SetDonatorRow(panel, playerId, player_table) {
//	$.Schedule(0.1, function(){
//		SetDonatorRow(panel, playerId)
//	})

	if (player_table && player_table.donator_level && player_table.donator_color) {
		if (player_table.donator_level < 10) {
			if (player_table.toggle_tag == 1) {
				if (is_donator_set.indexOf( playerId.toString() ) == -1) {
					is_donator_set.push( playerId.toString() );
					// panel.style.backgroundImage = 'url("file://{images}/custom_game/flyout/donator_' + player_table.donator_level + '.webm")';

//					donatorTitlePanel.style.backgroundColor = player_table.donator_color + "dd";
//					donatorTitlePanel.FindChildInLayoutFile("DonatorTitle").text = $.Localize("#donator_label_" + player_table.donator_level) || "Donator";

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

/*
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
*/
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

function EndScoreboard(args) {
	$.Msg(args);
	// Whenever data is available, hide loading panel and show actual end screen panel
	$("#ContainerLoading").style.opacity = "0";
	$.GetContextPanel().RemoveClass("MatchDataLoading");
	$("#ContainerLoaded").style.opacity = "1";

	// Hide Overview and use only Scoreboard tab for now
	$.GetContextPanel().AddClass("ScoreboardVisible");
	$("#DetailsOverview").style.opacity = "0";
	$("#DetailsScoreboardContainer").style.opacity = "1";
	$("#PinnedHeroes").style.opacity = "1";

	// Bring chat on top of end screen
	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HudChat").SetParent($.GetContextPanel());

	// Set game time
	$("#GameTimeText").text = $.Localize("#DOTA_Tooltip_ability_fountain_glyph_duration") +  RawTimetoGameTime(Game.GetDOTATime(false, false));

	const map_name = Game.GetMapInfo().map_display_name;

	if (map_name == "imbathrow_ffa") {
		$.GetContextPanel().AddClass("Multiteam");
	}

//	var IsRanked = false;

//	var gamemode = CustomNetTables.GetTableValue("game_options", "gamemode");
//	if (gamemode) gamemode = gamemode["1"];

//	if (Game.GetMapInfo().map_display_name == "imba_5v5" || Game.GetMapInfo().map_display_name == "imba_10v10") {
//		if (gamemode && gamemode == 1)
//			IsRanked = true;
//	}

/*
	$("#DetailsDeathStats").style.visibility = "collapse";
*/

/*
	$("#DetailsPicks").style.visibility = "visible";
*/

	$("#DetailsKillMatrix").style.visibility = "visible";

	$("#DetailsSupportItems").style.visibility = "visible";
	var item_length = 0;
	var buff_length = 0;

	$("#DetailsAbilities").style.visibility = "visible";

	var row_height = "56px";
	var row_marginBottom = "3.5px";

/*
	var mmr_rank_to_medals = {
		Herald: 1,
		Guardian: 2,
		Crusader: 3,
		Archon: 4,
		Legend: 5,
		Ancient: 6,
		Divine: 7,
		Immortal: 8,
	}
*/

	if (Game.IsInToolsMode()) {
		$("#HeroIconsColumn").RemoveAndDeleteChildren();
		$("#DetailsDamageDealt").RemoveAndDeleteChildren();
		$("#DetailsAbilities").RemoveAndDeleteChildren();

		for (let index = 0; index < $("#NormalMatchPlayers").GetChildCount(); index++) {
			if ($("#NormalMatchPlayers").GetChild(index) && $("#NormalMatchPlayers").GetChild(index).id != "PlayerRowLegend") {
				$("#NormalMatchPlayers").GetChild(index).DeleteAsync(0);
			}
		}
	}

	// if (IsRanked)
	// 	$("#" + team_number + "PlayerRowLegend").FindChildrenWithClassTraverse("LegendMMRChange")[0].style.visibility = "visible";

	// $.Msg(args.players);
	for (var team_number = 2; team_number <= 13; team_number++) {
		if (team_number == 4 || team_number == 5) continue;

		var pinned_team_container = $.CreatePanel('Panel', $("#HeroIconsColumn"), 'PinnedSnippet_' + team_number);
		pinned_team_container.BLoadLayoutSnippet("PinnedTeam");
		
		if (!pinned_team_container) {
			$.Msg("Skipping team: " + team_number);
			continue;
		}

		$.Msg("Proceed to team " + team_number);
		
		pinned_team_container.AddClass("PinnedTeam");
		pinned_team_container.AddClass("TomBottomFlow");	

		var player_row_container = $.CreatePanel('Panel', $("#NormalMatchPlayers"), 'PlayerRows_' + team_number);
		player_row_container.BLoadLayoutSnippet("PlayerRows");
		// not sure why i have to hardcode it yet
		player_row_container.style.flowChildren = "down";
		player_row_container.style.height = "fit-children";

		player_row_container.FindChildTraverse("PlayerRowLegend").BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_row_legend.xml", false, false);
		player_row_container.FindChildTraverse("PlayerRowLegend").FindChildTraverse("PermanentBuffsLegend").AddClass("PermanentBuffs" + buff_length);

		var player_damage_dealt_row_container = $.CreatePanel('Panel', $("#DetailsDamageDealt"), 'DamageDealtLegend_' + team_number);
		player_damage_dealt_row_container.BLoadLayoutSnippet("DamageDealtLegend");

		// var player_damage_received_row_container = $("#" + team_number + "DamageReceivedRows");

		var panel_kill_matrix_row_container = $.CreatePanel('Panel', $.GetContextPanel().FindChildrenWithClassTraverse("KillMatrixContainer")[0], 'KillMatrixRows_' + team_number);
		panel_kill_matrix_row_container.BLoadLayoutSnippet("KillMatrixRows");

		var panel_abilities_row_legend_container = $.CreatePanel('Panel', $("#DetailsAbilities"), 'AbilitiesPlayerRowLegend_' + team_number);
		panel_abilities_row_legend_container.BLoadLayoutSnippet("AbilitiesPlayerRowLegend");

		var panel_support_item = $.CreatePanel('Panel', panel_abilities_row_legend_container, '');
		panel_support_item.BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_abilities_row_legend.xml", false, false);

		var panel_abilities_row_container = pinned_team_container.FindChildTraverse("AbilitiesPlayerRows");

		// Set Team name and score
		pinned_team_container.FindChildTraverse("TeamName").text = $.Localize("#Overthrow_Team_" + team_number);
		pinned_team_container.FindChildTraverse("TeamName").style.textShadow = "0px 0px 6px 1.0 " + GameUI.CustomUIConfig().team_colors[team_number];
		pinned_team_container.FindChildTraverse("TeamScore").text = "Score: " + Game.GetTeamDetails(team_number).team_score;

		if (Game.GetGameWinner() == team_number)
			pinned_team_container.FindChildTraverse("Winner").style.visibility = "visible";


		$("#DetailsSupportItems").AddClass("MaxItems" + item_length);

		$("#NormalMatchPlayers").AddClass("PermanentBuffs" + buff_length);

//		$.Msg(args.data)
//		$.Msg(args.players)

		$.Each(Game.GetPlayerIDsOnTeam(team_number), function(id) {
//			$.Msg("Player ID " + id + " in team " + team_number)
			var player_info = Game.GetPlayerInfo(id);
			var player_items = Game.GetPlayerItems(id);
			var player_table = CustomNetTables.GetTableValue("battlepass_player", id.toString());
			var player_result = undefined;
			var player_backend_result = undefined;

			if (player_info && args.players && args.players[player_info.player_steamid])
				player_result = args.players[player_info.player_steamid];

			if (player_info && args.data && args.data.players && args.data.players[player_info.player_steamid])
				player_backend_result = args.data.players[player_info.player_steamid];

//			$.Msg(player_info)
//			$.Msg(player_table)
//			$.Msg(player_result)

			// Set left bar player informations
			var PinnedPlayerRow = $.CreatePanel('Panel', pinned_team_container, 'PinnedPlayerRow' + id);
			PinnedPlayerRow.BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_pinned_player_row.xml", false, false);
			PinnedPlayerRow.AddClass("PlayerName");

			// using panel.heroname doesn't work for custom heroes
			PinnedPlayerRow.FindChildTraverse("HeroImage").style.backgroundImage = 'url("s2r://panorama/images/heroes/' + Players.GetPlayerSelectedHero(id) + '.png")';
			PinnedPlayerRow.FindChildTraverse("HeroImage").style.backgroundSize = "cover";

			PinnedPlayerRow.FindChildTraverse("PlayerNameScoreboard").SetDialogVariable("user_account_id", player_info.player_name);
			PinnedPlayerRow.FindChildrenWithClassTraverse("HeroLevelLabel")[0].text = player_info.player_level;
			PinnedPlayerRow.FindChildrenWithClassTraverse("LevelAndHero")[0].text = $.Localize("#" + Players.GetPlayerSelectedHero(id));

/*
			if (IsRanked) {
				if (player_table && player_table.mmr_title) {
					var rank_panel = PinnedPlayerRow.FindChildTraverse("RankTierContainer");
					rank_panel.style.visibility = "visible";

					var short_title = player_table.mmr_title;
					var title_stars = player_table.mmr_title.substring(player_table.mmr_title.length - 1, player_table.mmr_title.length)

					// if last character is a number (horrible hack, look away please)
					if (parseInt(title_stars)) {
						short_title = player_table.mmr_title.substring(0, player_table.mmr_title.length - 2);
						title_stars = player_table.mmr_title[player_table.mmr_title.length -1];
					} else {
						short_title = player_table.mmr_title;
						title_stars = "1";
					}

					PinnedPlayerRow.FindChildTraverse("RankTier").style.backgroundImage = 'url("s2r://panorama/images/rank_tier_icons/rank' + mmr_rank_to_medals[short_title] + '_psd.vtex")';
					PinnedPlayerRow.FindChildTraverse("RankPips").style.backgroundImage = 'url("s2r://panorama/images/rank_tier_icons/pip' + title_stars + '_psd.vtex")';

					rank_panel.SetPanelEvent("onmouseover", function () {
						$.DispatchEvent("DOTAShowTextTooltip", rank_panel, player_table.mmr_title);
					})
					rank_panel.SetPanelEvent("onmouseout", function () {
						$.DispatchEvent("DOTAHideTextTooltip", rank_panel);
					})
				}
			}
*/

			// Set middle bar player informations
			var PlayerRowContainer = $.CreatePanel('Panel', player_row_container, 'PlayerRow' + id);
			PlayerRowContainer.BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_row.xml", false, false);

//			if (IsRanked)
//				PlayerRowContainer.FindChildrenWithClassTraverse("MMRChange")[0].style.visibility = "visible";

			PlayerRowContainer.FindChildrenWithClassTraverse("Level")[0].text = player_info.player_level;
			PlayerRowContainer.FindChildrenWithClassTraverse("Kills")[0].text = player_info.player_kills;
			PlayerRowContainer.FindChildrenWithClassTraverse("Deaths")[0].text = player_info.player_deaths;
			PlayerRowContainer.FindChildrenWithClassTraverse("Assists")[0].text = player_info.player_assists;
//			PlayerRowContainer.FindChildrenWithClassTraverse("MMRChange")[0]

			if (player_result && player_result.networth)
				PlayerRowContainer.FindChildrenWithClassTraverse("NetWorth")[0].text = player_result.networth;

			SetDonatorRow(PlayerRowContainer.GetChild(0), id, player_table)

			var panel_progress_bar = PlayerRowContainer.FindChildTraverse("es-player-xp-progress");
			var panel_xp_text = PlayerRowContainer.FindChildTraverse("es-player-xp-rank");
			var panel_level_text = PlayerRowContainer.FindChildTraverse("es-player-xp-level");
			var panel_rank_name = PlayerRowContainer.FindChildTraverse("es-player-xp-rank-name");
			var panel_xp_booster_text = PlayerRowContainer.FindChildTraverse("es-player-xp-booster");

			// temporary
			panel_xp_text.style.marginTop = "0px";
			panel_level_text.style.marginTop = "0px";
			panel_rank_name.style.marginTop = "0px";

			// setup Battlepass XP progress bar
			if (player_table && player_table.XP && player_table.MaxXP && player_table.player_xp == 1) {
				panel_xp_text.text = Math.floor(player_table.XP) + "/" + Math.floor(player_table.MaxXP);
				panel_level_text.text = $.Localize("#battlepass_level") + player_table.Lvl;
				panel_rank_name.text = player_table.title;
				panel_rank_name.style.color = player_table.title_color;

//				if (player_table.toggle_tag == 1)
//					panel_xp_booster_text.style.color = player_table.donator_color;

//				$.Msg(Math.floor(player_table.XP) + " / " + Math.floor(player_table.MaxXP))
//				$.Msg(Math.floor(player_table.XP) / Math.floor(player_table.MaxXP))

				var progress = Math.round((100.0 * Math.floor(player_table.XP)) / Math.floor(player_table.MaxXP));
				panel_progress_bar.style.width = progress + "%";
			} else {			
				panel_xp_text.text = "N/A";
				panel_level_text.text = "N/A";
				panel_rank_name.text = "N/A";
				panel_rank_name.style.color = "#FFFFFF";
				panel_progress_bar.style.width = "0%";
			}

			var panel_xp_diff_progress_bar = PlayerRowContainer.FindChildTraverse("es-player-xp-progress-diff");
			var panel_xp_diff_text = PlayerRowContainer.FindChildTraverse("es-player-xp-earned");

			// setup Battlepass XP diff and booster
			if (player_backend_result != null) {
//				$.Msg("XP earned: " + player_backend_result.xp_change)
				var xpDiff = Math.floor(player_backend_result.xp_change);
//				if (Game.IsInToolsMode())
//					xpDiff = 1000000;

//				$.Msg("XP DIFF: " + xpDiff)
				if (xpDiff > 0) {
					if (player_table && player_table.player_xp == 1) {
						panel_xp_diff_text.text = "+" + xpDiff;
					} else {
						panel_xp_diff_text.text = "+N/A";
					}

					panel_xp_diff_text.AddClass("es-text-green");

					if (player_table) {
						if (progress) {
							var progress_diff = Math.round(100.0 * (xpDiff / player_table.MaxXP));

							panel_xp_diff_progress_bar.style.width = progress_diff + "%";
							panel_xp_diff_progress_bar.style.marginLeft = (progress - 1) + "%";
						}

						var levelup_count = Math.floor(player_table.XP + xpDiff) / Math.floor(player_table.MaxXP);

						if (levelup_count >= 1) {
							panel_progress_bar.GetParent().AddClass("level-up");						
						}
					}
				} else if (xpDiff < 0) {
					panel_xp_diff_text.text = new String(xpDiff);
					panel_xp_diff_text.AddClass("es-text-red");
				} else {
					// fail-safe to prevent text being grey
					panel_xp_diff_text.text = "0";
					panel_xp_diff_text.AddClass("es-text-white");
				}

				if (player_table && player_table.toggle_tag == 1 && player_backend_result && player_backend_result.xp_multiplier) {
					var multiplier = Math.round(player_backend_result.xp_multiplier * 100.0);
					panel_xp_booster_text.text = " (" + multiplier + "%)";
				} else {
					panel_xp_booster_text.text = " (100%)";
				}

				if (player_result.healing)
					PlayerRowContainer.FindChildrenWithClassTraverse("HeroHealing")[0].text = player_result.healing;
			} else {
				panel_xp_diff_text.text = "N/A";
			}

			// setup player items in inventory
			if (player_items) {
				for (var i = player_items.inventory_slot_min; i < player_items.inventory_slot_max; i++) {
					var item = player_items.inventory[i];

					if (item && PlayerRowContainer.FindChildTraverse("ItemIcon" + i))
						PlayerRowContainer.FindChildTraverse("ItemIcon" + i).itemname = item.item_name;
				}
			}

//			$.Msg("Player ID: " + id)
			var perm_buffs = GetPermanentBuffs(player_info.player_selected_hero_entity_index);
			var buff_count = 0;

			for (var buff_id in perm_buffs) {
				buff_count++;
				var buff_name = perm_buffs[buff_id];
				var buff_image = Buffs.GetTexture(player_info.player_selected_hero_entity_index, parseInt(buff_id)).replace("item_", "");
				var buff_stacks = Buffs.GetStackCount(player_info.player_selected_hero_entity_index, parseInt(buff_id));
//				$.Msg('file://{images}/' + permanent_buffs[buff_name] + '/' + buff_image + '.png')

				var BuffPanel = $.CreatePanel('Panel', PlayerRowContainer.FindChildTraverse("PermanentBuffs"), buff_name);
				BuffPanel.BLoadLayoutSnippet('PermanentBuff');
				SetBuffTooltips(player_info.player_selected_hero_entity_index, BuffPanel, buff_id);
				BuffPanel.FindChildTraverse("PermanentBuffIcon").SetImage('file://{images}/' + permanent_buffs[buff_name] + '/' + buff_image + '.png');

				if (buff_stacks > 0)
					BuffPanel.FindChildTraverse("PermanentBuffStackCount").text = buff_stacks;
			}

			if (buff_count > buff_length)
				buff_length = buff_count;

			PlayerRowContainer.FindChildTraverse("PermanentBuffs").AddClass("PermanentBuffs" + buff_length);

			PlayerRowContainer.FindChildrenWithClassTraverse("LastHits")[0].text = Players.GetLastHits(id);
			PlayerRowContainer.FindChildrenWithClassTraverse("Denies")[0].text = Players.GetDenies(id);
			PlayerRowContainer.FindChildrenWithClassTraverse("GoldPerMin")[0].text = Players.GetGoldPerMin(id).toFixed(0);
			PlayerRowContainer.FindChildrenWithClassTraverse("XPPerMin")[0].text = (Players.GetTotalEarnedXP(id).toFixed(0) / Players.GetLevel(id)).toFixed(0);

			var DamageDealtContainer = $.CreatePanel('Panel', player_damage_dealt_row_container, '');
			DamageDealtContainer.BLoadLayoutSnippet('DetailsDamageDealtPlayerRow');
			DamageDealtContainer.style.height = row_height;
			DamageDealtContainer.style.marginBottom = row_marginBottom;

			if (player_result) {
				if (player_result.damage_done_to_heroes)
					DamageDealtContainer.FindChildTraverse("DamageDealtHeroValue").text = player_result.damage_done_to_heroes;

				if (player_result.damage_done_to_buildings)
					DamageDealtContainer.FindChildTraverse("DamageDealtBuildingValue").text = player_result.damage_done_to_buildings;
			}

			// todo: calculate raw damage and reduced damage received for each heroes (in lua)
/*
			$("#DetailsDamageReceived").style.visibility = "visible";
			var DamageReceivedContainer = $.CreatePanel('Panel', player_damage_received_row_container, '');
			DamageReceivedContainer.BLoadLayoutSnippet('DetailsDamageReceivedPlayerRow');
			DamageReceivedContainer.style.height = row_height;
			DamageReceivedContainer.style.marginBottom = row_marginBottom;
			DamageReceivedContainer.FindChildTraverse("DamageReceivedPreValue").text = player_result.damage_done_to_heroes;
			DamageReceivedContainer.FindChildTraverse("DamageReceivedPostValue").text = player_result.damage_done_to_buildings;
*/

			var panel_kill_matrix_row = $.CreatePanel('DOTAPostGameKillMatrixRow', panel_kill_matrix_row_container, 'KillMatrixHero' + id);
			panel_kill_matrix_row.BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_kill_matrix_row.xml", false, false);

// 			var iteration = -1;
// 			$.Each(Game.GetPlayerIDsOnTeam(opposite_team), function(enemy_id) {
// 				iteration++;
// 				var enemy_info = Game.GetPlayerInfo(enemy_id);

// 				if (player_result && player_result.kills_done_to_hero && player_result.kills_done_to_hero[enemy_id] > 0 && panel_kill_matrix_row.FindChildTraverse("VictimDeathCount" + iteration)) {
// 					panel_kill_matrix_row.AddClass("Victim_" + iteration + "_Active")
// 					panel_kill_matrix_row.FindChildTraverse("VictimDeathCount" + iteration).text = "x" + player_result.kills_done_to_hero[enemy_id];
// 				}

// 				// TODO: Somehow, panel 5 to 9 are not created in 10v10, despite dashboard_page_post_game_kill_matrix_row.xml being edited with 10 panels
// //				$.Msg(iteration + " / " + panel_kill_matrix_row.FindChildTraverse("VictimHero" + iteration))
// 				if (panel_kill_matrix_row.FindChildTraverse("VictimHero" + iteration)) {
// 					// using panel.heroname doesn't work for custom heroes
// 					panel_kill_matrix_row.FindChildTraverse("VictimHero" + iteration).style.backgroundImage = 'url("s2r://panorama/images/heroes/icons/' + enemy_info.player_selected_hero + '.png")';
// 					panel_kill_matrix_row.FindChildTraverse("VictimHero" + iteration).style.backgroundSize = "cover";

// 					panel_kill_matrix_row.FindChildTraverse("VictimHero" + iteration).heroname = enemy_info.player_selected_hero;
// 				}
// 			});

			panel_kill_matrix_row.FindChildTraverse("TotalKills").GetChild(0).text = player_info.player_kills;

			var panel_support_items_row_container = $.CreatePanel('Panel', $.GetContextPanel().FindChildTraverse("DetailsSupportItems"), 'SupportItems_' + team_number);
			panel_support_items_row_container.BLoadLayoutSnippet("SupportItems");

			var panel_support_items_row = $.CreatePanel('DOTAPostGameSupportItemsRow', panel_support_items_row_container, 'SupportItems' + id);
			panel_support_items_row.BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_support_items_row.xml", false, false);

			// temporary
			panel_support_items_row.FindChildTraverse("SupportItemsValue").text = 0;
			panel_support_items_row.FindChildTraverse("SupportItemsCampsStacked").text = 0;

			if (player_result) {
				if (player_result.support_items) {
					for (var item_id in player_result.support_items) {
						if (item_id > item_length)
							item_length = item_id;

						var item_name = player_result.support_items[item_id].item_name;
						var item_count = player_result.support_items[item_id].item_count;

						var panel_support_item = $.CreatePanel('Panel', panel_support_items_row.FindChildTraverse("SupportItemContainer"), '');
						panel_support_item.BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_support_items_item_entry.xml", false, false);
						panel_support_item.AddClass("ItemEntry")

						panel_support_item.FindChildTraverse("ItemImage").itemname = item_name;
						panel_support_item.FindChildrenWithClassTraverse("SupportItemCount")[0].text = "x" + item_count;
					};
				}

				if (item_length > 0)
					panel_support_items_row.AddClass("MaxItems" + item_length);

				if (player_result.gold_spent_on_support) {
					panel_support_items_row.FindChildTraverse("SupportItemsValue").text = player_result.gold_spent_on_support;
				}

				var panel_abilities = $.CreatePanel('Panel', panel_abilities_row_container, '');
				panel_abilities.BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_abilities_row.xml", false, false);

//				$.Msg(player_result.abilities_level_up_order)
				if (player_result.abilities_level_up_order) {
					for (var i = 1; i <= 25; i++) {
						var ability_name = player_result.abilities_level_up_order[i];
						var ability_entity = Entities.GetAbilityByName(player_info.player_selected_hero_entity_index, ability_name);
						var ability_level = GetAbilityLevel(player_result.abilities_level_up_order, ability_name, i);
						var ability_max_level = Abilities.GetMaxLevel(ability_entity);

						var ability = $.CreatePanel('DOTAAbilityImage', panel_abilities, '');
						ability.abilityname = ability_name;

						if (ability_level == ability_max_level) {
//							ability.AddClass("AbilityMaxLevel"); // not working somehow
							ability.style.saturation = "1";
							ability.style.washColor = "#00000000";
							ability.style.border = "1px solid #6CABAD32";
						}

						if (ability_name != "generic_hidden") {
							(function (ability, ability_name) {
								ability.SetPanelEvent("onmouseover", function () {
									$.DispatchEvent("DOTAShowAbilityTooltip", ability, ability_name);
								})
								ability.SetPanelEvent("onmouseout", function () {
									$.DispatchEvent("DOTAHideAbilityTooltip", ability);
								})
							})(ability, ability_name);
						}
					}
				}
			}

			if (id == Players.GetLocalPlayer()) {
				PinnedPlayerRow.AddClass("LocalPlayer")
				PlayerRowContainer.AddClass("LocalPlayer")
				panel_kill_matrix_row.AddClass("LocalPlayer")
				panel_support_items_row.AddClass("LocalPlayer")
			}

			// temporary fix
			PlayerRowContainer.style.backgroundImage = "none";

//			panel_kill_matrix_row.FindChildTraverse("TotalKills").GetChild(0).text = player_info.player_kills;
		});
	}
}

function GetAbilityLevel(array, ability_name, iteration) {
	var level = 0;

	for (var i = 1; i <= iteration; i++) {
		if (array[i] == ability_name)
			level++;
	}

	return level;
}

function SetTextSafe(panel, value) {
	if (panel == undefined)
		return;

	if (value == undefined)
		value = 0;

	panel.text = value;
}

function GetPermanentBuffs(selectedEntityID) {
	var num_buffs = Entities.GetNumBuffs(selectedEntityID);
	var iterations = num_buffs;
	var buffs = []

	//this is expecting to for num_buffs. We are assuming num_buffs means number of VALID buffs at any buff index (not sequentially from 0-N)
	for (var i = 0; i < iterations; i++) {
		var buff_name = Buffs.GetName(selectedEntityID, i);

		//this essentially nullifies the current iteration, but our index still goes up by 1 so we don't constantly look at the same buff index
		if(buff_name == ''){ iterations+= 1; continue; }

//		$.Msg(buff_name)

		if (permanent_buffs[buff_name]) {
			buffs[i] = buff_name;
		}
	}

	return buffs;
}

function SetBuffTooltips(selectedEntityID, buff_panel, buff_serial) {
	buff_panel.SetPanelEvent('onmouseover', function(){ $.DispatchEvent('DOTAShowBuffTooltip', buff_panel, selectedEntityID, buff_serial, false); })
	buff_panel.SetPanelEvent('onmouseout', function(){ $.DispatchEvent('DOTAHideBuffTooltip'); })
}

function ResetEndScoreboardPanels() {
	if (Game.IsInToolsMode()) {
		for (let team = 2; team <= 13; team++) {
			if ($("#Pinned_" + team)) {
				for (var i = 0; i < $("#Pinned_" + team).GetChildCount(); i++) {
					$("#Pinned_" + team).GetChild(i).DeleteAsync(0);
				}
			}

			if ($("#" + team + "_PlayerRows")) {
				for (var i = 0; i < $("#" + team + "_PlayerRows").GetChildCount(); i++) {
					$("#" + team + "_PlayerRows").GetChild(i).DeleteAsync(0);
				}
			}

			if ($("#" + team + "_DamageDealtRows")) {
				for (var i = 0; i < $("#" + team + "_DamageDealtRows").GetChildCount(); i++) {
					$("#" + team + "_DamageDealtRows").GetChild(i).DeleteAsync(0);
				}
			}

			if ($("#" + team + "_DamageReceivedRows")) {
				for (var i = 0; i < $("#RadiantDamageReceivedRows").GetChildCount(); i++) {
					$("#RadiantDamageReceivedRows").GetChild(i).DeleteAsync(0);
				}
			}

			if ($("#" + team + "_KillMatrixRows")) {
				for (var i = 0; i < $("#" + team + "_KillMatrixRows").GetChildCount(); i++) {
					$("#" + team + "_KillMatrixRows").GetChild(i).DeleteAsync(0);
				}
			}

			if ($("#" + team + "_SupportItemsRows")) {
				for (var i = 0; i < $("#" + team + "_SupportItemsRows").GetChildCount(); i++) {
					$("#" + team + "_SupportItemsRows").GetChild(i).DeleteAsync(0);
				}
			}

			if ($("#Abilities_" + team + "_PlayerRows")) {
				for (var i = 0; i < $("#Abilities_" + team + "_PlayerRows").GetChildCount(); i++) {
					$("#Abilities_" + team + "_PlayerRows").GetChild(i).DeleteAsync(0);
				}
			}
		}
	}
}

(function () {
//	$.Msg("START END SCREEN")

	$("#ContainerLoading").style.opacity = "1";
	// Show loading panel
	FindDotaHudElement("topbar").style.visibility = "collapse";
	$.GetContextPanel().AddClass("MatchDataLoading");
	$.Schedule(0.0, function() {
		if ($.GetContextPanel().BHasClass("MatchDataLoading")) {
			EndScoreboard({});
		}
	})

	GameEvents.Subscribe("end_game", EndScoreboard);

	// Placeholder
	if (Game.IsInToolsMode()) {
		ResetEndScoreboardPanels();

		var args = {
			"data":{
				"players":{
					"76561198015161808":{
						"xp_change": 1234,
						"xp_multiplier": 10,
					},
					"90071996842377216":{
						"xp_change": 1234,
						"xp_multiplier": 10,
					},
				},
			},
			"players":{
				"76561198015161808":{
					"xp_multiplier": 10,
					"xp": "0",
					"xp_change": 200,
					"healing": 1000,
					"networth": 24579,
					"damage_done_to_heroes": 52891,
					"damage_done_to_buildings": 11482,
					"kills_done_to_hero": {
						"0": 0,
						"1": 0,
						"2": 0,
						"3": 0,
						"4": 0,
						"5": 1,
						"6": 3,
						"7": 0,
						"8": 7,
						"9": 78,
					},
					"support_items": {
						"1": {
							"item_name": "item_ward_observer",
							"item_count": 4,
						},
						"2": {
							"item_name": "item_ward_sentry",
							"item_count": 12,
						},
					},
					"gold_spent_on_support": 0,
					"abilities_level_up_order": {
						"1": "imba_zuus_arc_lightning",
						"2": "imba_zuus_lightning_bolt",
						"3": "imba_zuus_arc_lightning",
						"4": "imba_zuus_lightning_bolt",
						"5": "imba_zuus_arc_lightning",
						"6": "imba_zuus_lightning_bolt",
						"7": "imba_zuus_arc_lightning",
						"8": "imba_zuus_lightning_bolt",
						"9": "imba_zuus_thundergods_wrath",
						"10": "imba_zuus_static_field",
						"11": "imba_zuus_thundergods_wrath",
						"12": "imba_zuus_static_field",
						"13": "imba_zuus_thundergods_wrath",
						"14": "imba_zuus_static_field",
						"15": "special_bonus_imba_magnataur_1",
						"16": "imba_zuus_static_field",
						"17": "generic_hidden",
						"18": "special_bonus_imba_magnataur_3",
						"19": "generic_hidden",
						"20": "special_bonus_imba_magnataur_5",
						"21": "generic_hidden",
						"22": "generic_hidden",
						"23": "generic_hidden",
						"24": "generic_hidden",
						"25": "special_bonus_imba_magnataur_8",
					}
				},
				"90071996842377216":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 1,
					"healing": 1000,
					"networth": 24579,
					"damage_done_to_heroes": 52891,
					"damage_done_to_buildings": 11482,
					"support_items": {
						"1": {
							"item_name": "item_ward_observer",
							"item_count": 4,
						},
						"2": {
							"item_name": "item_ward_sentry",
							"item_count": 12,
						},
					},
				},
				"90071996842377217":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 2,
					"healing": 1000,
					"networth": 24579,
					"damage_done_to_heroes": 52891,
					"damage_done_to_buildings": 11482,
				},
				"90071996842377218":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 3,
					"healing": 1000,
					"networth": 24579,
					"damage_done_to_heroes": 52891,
					"damage_done_to_buildings": 11482,
				},
				"90071996842377219":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 4,
					"healing": 1000,
					"networth": 24579,
					"damage_done_to_heroes": 52891,
					"damage_done_to_buildings": 11482,
				},
				"90071996842377220":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 5,
					"healing": 1000,
					"networth": 24579,
					"damage_done_to_heroes": 52891,
					"damage_done_to_buildings": 11482,
				},
				"90071996842377221":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 6,
					"healing": 1000,
					"networth": 24579,
					"damage_done_to_heroes": 52891,
					"damage_done_to_buildings": 11482,
				},
				"90071996842377222":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 7,
					"healing": 1000,
					"networth": 24579,
					"damage_done_to_heroes": 52891,
					"damage_done_to_buildings": 11482,
				},
				"90071996842377223":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 8,
					"healing": 1000,
					"networth": 24579,
					"damage_done_to_heroes": 52891,
					"damage_done_to_buildings": 11482,
				},
				"90071996842377224":{
					"xp_multiplier": 1,
					"xp": "0",
					"xp_change": 9,
					"healing": 1000,
					"networth": 24579,
					"damage_done_to_heroes": 52891,
					"damage_done_to_buildings": 11482,
				},
			},
		}

		var data = CustomNetTables.GetTableValue("game_options", "end_game");
		$.Msg(data);

		// EndScoreboard(args);
	}
})();
