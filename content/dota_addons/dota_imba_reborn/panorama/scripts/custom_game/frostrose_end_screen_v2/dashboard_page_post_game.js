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

function CreateBattlepassRewardPanel(level, levelup_count) {
	var battlepass = CustomNetTables.GetTableValue("game_options", "battlepass").battlepass;

	if (battlepass != undefined && battlepass[level] != undefined) {
		var battlepass_reward = battlepass[level][1];
		var battlepass_rarity = battlepass[level][2];
//		$.Msg("Earned a reward:")
//		$.Msg(level)
//		$.Msg(battlepass_reward)
//		$.Msg(battlepass_rarity)

		var rp = $.CreatePanel("Panel", $("#RewardContainer"), "es-player-reward-container" + level);
		rp.AddClass("es-player-reward-container");
		rp.AddClass("es-player-reward");

		var rewards = {
			desc: $.CreatePanel("Label", rp, "es-player-reward-description" + level),
			name: $.CreatePanel("Label", rp, "es-player-reward-name" + level),
			rarity: $.CreatePanel("Label", rp, "es-player-reward-rarity" + level),
			image: $.CreatePanel("Panel", rp, "es-player-reward-image" + level),
			button: $.CreatePanel("Button", rp, "es-player-reward-button" + level),
		};

		rewards.desc.AddClass("es-player-reward-description")
		rewards.name.AddClass("es-player-reward-name")
		rewards.rarity.AddClass("es-player-reward-rarity")
		rewards.image.AddClass("es-player-reward-image")
		rewards.button.AddClass("es-player-reward-button")
		rewards.button.SetPanelEvent("onactivate", function() {
			rp.style.visibility = "collapse"
		});

		var button_label = $.CreatePanel("Label", rewards.button, "es-player-reward-button_label" + level)
		button_label.AddClass("es-player-reward-button_label");
		button_label.text = "Accept";

		if (Game.IsInToolsMode()) {
			rp.RemoveClass("level-common");
			rp.RemoveClass("level-uncommon");
			rp.RemoveClass("level-rare");
			rp.RemoveClass("level-mythical");
			rp.RemoveClass("level-legendary");
			rp.RemoveClass("level-immortal");
			rp.RemoveClass("level-arcana");
			rp.RemoveClass("level-ancient");
			rewards.rarity.RemoveClass("common");
			rewards.rarity.RemoveClass("uncommon");
			rewards.rarity.RemoveClass("rare");
			rewards.rarity.RemoveClass("mythical");
			rewards.rarity.RemoveClass("legendary");
			rewards.rarity.RemoveClass("immortal");
			rewards.rarity.RemoveClass("arcana");
			rewards.rarity.RemoveClass("ancient");
		}

		rp.style.visibility = 'visible';
		rewards.desc.text = $.Localize("battlepass_reward_description") + " " + level;
		rewards.name.text = $.Localize("battlepass_" + battlepass_reward);
		rewards.rarity.AddClass(battlepass_rarity);
		rewards.rarity.text = battlepass_rarity;
		rewards.image.style.backgroundImage = 'url("file://{resources}/images/custom_game/battlepass/' + battlepass_reward + '.png")';
		rewards.image.style.backgroundSize = 'cover';

		rp.AddClass('level-' + battlepass_rarity);

		var sound_name = {};
		sound_name["common"] = "Loot_Drop_Sfx";
		sound_name["uncommon"] = "Loot_Drop_Stinger_Uncommon";
		sound_name["rare"] = "Loot_Drop_Stinger_Rare";
		sound_name["mythical"] = "Loot_Drop_Stinger_Mythical";
		sound_name["legendary"] = "Loot_Drop_Stinger_Legendary";
		sound_name["immortal"] = "Loot_Drop_Stinger_Immortal";
		sound_name["arcana"] = "Loot_Drop_Stinger_Arcana";
		sound_name["ancient"] = "Loot_Drop_Stinger_Ancient";

		Game.EmitSound(sound_name[battlepass_rarity])
	}
}

function RawTimetoGameTime(time) {
	var sec = Math.floor( time % 60 );
	var min = Math.floor( time / 60 );

	var timerText = "";
	timerText += min;
	timerText += ":";

	if ( sec < 10 )
	{
		timerText += "0";
	}
	timerText += sec;
	return timerText;
}

function EndScoreboard(args) {
	// Whenever data is available, hide loading panel and show actual end screen panel
	$("#ContainerLoading").style.opacity = "0";
	$.GetContextPanel().RemoveClass("MatchDataLoading");
	$("#ContainerLoaded").style.opacity = "1";

	// Hide Overview and use only Scoreboard tab for now
	$.GetContextPanel().AddClass("ScoreboardVisible");
	$("#DetailsOverview").style.opacity = "0";
	$("#DetailsScoreboardContainer").style.opacity = "1";
	$("#PinnedHeroes").style.opacity = "1";

	// Set game time
//	$("#GameTimeText").text = $.Localize("DOTA_Tooltip_ability_fountain_glyph_duration") +  RawTimetoGameTime(Game.GetDOTATime(false, false));

//	for (var i = 0; i < Game.GetAllPlayerIDs().length; i++) {
//		Game.GetAllPlayerIDs()[i]
//	}

	var team_name = []
	team_name[2] = "Radiant";
	team_name[3] = "Dire";

	var team_localization_name = []
	team_localization_name[2] = "#DOTA_Goodguys";
	team_localization_name[3] = "#DOTA_Badguys";

//	$.Msg(args)

	var bTenvTen = Game.GetAllPlayerIDs().length > 10;
//	var IsRanked = Game.IsInToolsMode();
	var IsRanked = false;

	var gamemode = CustomNetTables.GetTableValue("game_options", "gamemode");
	if (gamemode) gamemode = gamemode["1"];

	if (Game.GetMapInfo().map_display_name == "imba_5v5" || Game.GetMapInfo().map_display_name == "imba_10v10") {
		if (gamemode && gamemode == 1)
			IsRanked = true;
	}

	if (bTenvTen == false) {
		$("#DetailsScoreboardContainer").style.marginTop = "15%";
		$("#PinnedHeroes").style.marginTop = "15%";
	}

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
	var opposite_team = 3;

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

//	$.Msg(args.players)

	for (var team_number = 2; team_number <= 3; team_number++) {
		if (team_number == 3)
			opposite_team = 2;

		var pinned_team_container = $("#Pinned" + team_name[team_number]);
		pinned_team_container.AddClass("PinnedTeam");
		pinned_team_container.AddClass("TomBottomFlow");

		var player_row_container = $("#" + team_name[team_number] + "PlayerRows");
		// not sure why i have to hardcode it yet
		player_row_container.style.flowChildren = "down";
		player_row_container.style.height = "fit-children";
//		$.Msg("Team: " + team_number)

		var player_damage_dealt_row_container = $("#" + team_name[team_number] + "DamageDealtRows");
//		var player_damage_received_row_container = $("#" + team_name[team_number] + "DamageReceivedRows");
		var panel_kill_matrix_row_container = $("#" + team_name[team_number] + "KillMatrixRows");
		panel_kill_matrix_row_container.RemoveClass("StatRowHeight");
		var panel_support_items_row_container = $("#" + team_name[team_number] + "SupportItemsRows");

		var panel_abilities_row_legend_container = $("#Abilities" + team_name[team_number] + "PlayerRowLegend");
		var panel_support_item = $.CreatePanel('Panel', panel_abilities_row_legend_container, '');
		panel_support_item.BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_abilities_row_legend.xml", false, false);

		var panel_abilities_row_container = $("#Abilities" + team_name[team_number] + "PlayerRows");

//		if (Game.GetTeamDetails(team_number).team_num_players > 0) {
			// Set Team name and score
			$("#HeroIconsColumn").FindChildTraverse(team_name[team_number] + "TeamName").text = $.Localize(team_localization_name[team_number]);
			$("#" + team_name[team_number] + "TeamScore").text = "Score: " + Game.GetTeamDetails(team_number).team_score;

			if (Game.GetGameWinner() == team_number)
				$("#" + team_name[team_number] + "Winner").style.visibility = "visible";

			$("#" + team_name[team_number] + "PlayerRowLegend").BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_row_legend.xml", false, false);

			if (IsRanked)
				$("#" + team_name[team_number] + "PlayerRowLegend").FindChildrenWithClassTraverse("LegendMMRChange")[0].style.visibility = "visible";

			$("#DetailsSupportItems").AddClass("MaxItems" + item_length);

			$("#NormalMatchPlayers").AddClass("PermanentBuffs" + buff_length);
			$("#" + team_name[team_number] + "PlayerRowLegend").FindChildTraverse("PermanentBuffsLegend").AddClass("PermanentBuffs" + buff_length);

//			$.Msg(args.data)

			$.Each(Game.GetPlayerIDsOnTeam(team_number), function(id) {
//				$.Msg("Player ID " + id + " in team " + team_number)
				var player_info = Game.GetPlayerInfo(id);
				var player_items = Game.GetPlayerItems(id);
				var player_table = CustomNetTables.GetTableValue("battlepass", id.toString());
				var player_result = args.players[player_info.player_steamid];
				var player_backend_result = args.data.players[player_info.player_steamid];

//				$.Msg(player_info)
//				$.Msg(player_table)
//				$.Msg(player_result)

				// Set left bar player informations
				var PinnedPlayerRow = $.CreatePanel('Panel', pinned_team_container, 'PinnedPlayerRow' + id);
				PinnedPlayerRow.BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_pinned_player_row.xml", false, false);
				PinnedPlayerRow.AddClass("PlayerName");

				if (bTenvTen) {
					PinnedPlayerRow.AddClass("StatRowHeight10v10");
				} else {
					PinnedPlayerRow.AddClass("StatRowHeight5v5");
				}

				// using panel.heroname doesn't work for custom heroes
				PinnedPlayerRow.FindChildTraverse("HeroImage").style.backgroundImage = 'url("s2r://panorama/images/heroes/' + Players.GetPlayerSelectedHero(id) + '.png")';
				PinnedPlayerRow.FindChildTraverse("HeroImage").style.backgroundSize = "cover";

				PinnedPlayerRow.FindChildTraverse("PlayerNameScoreboard").GetChild(0).text = player_info.player_name;
				PinnedPlayerRow.FindChildrenWithClassTraverse("HeroLevelLabel")[0].text = player_info.player_level;
				PinnedPlayerRow.FindChildrenWithClassTraverse("LevelAndHero")[0].text = $.Localize(Players.GetPlayerSelectedHero(id));

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
							title_stars = "_empty";
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

				// Set middle bar player informations
				var PlayerRowContainer = $.CreatePanel('Panel', player_row_container, 'PlayerRow' + id);
				PlayerRowContainer.BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_row.xml", false, false);

				if (IsRanked)
					PlayerRowContainer.FindChildrenWithClassTraverse("MMRChange")[0].style.visibility = "visible";

				PlayerRowContainer.FindChildrenWithClassTraverse("Level")[0].text = player_info.player_level;
				PlayerRowContainer.FindChildrenWithClassTraverse("Kills")[0].text = player_info.player_kills;
				PlayerRowContainer.FindChildrenWithClassTraverse("Deaths")[0].text = player_info.player_deaths;
				PlayerRowContainer.FindChildrenWithClassTraverse("Assists")[0].text = player_info.player_assists;
//				PlayerRowContainer.FindChildrenWithClassTraverse("MMRChange")[0]

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
				if (player_table && player_table.XP && player_table.MaxXP) {
					panel_xp_text.text = Math.floor(player_table.XP) + "/" + Math.floor(player_table.MaxXP);
					panel_level_text.text = $.Localize("#battlepass_level") + player_table.Lvl;
					panel_rank_name.text = player_table.title;
					panel_rank_name.style.color = player_table.title_color;

//					if (player_table.in_game_tag == 1)
//						panel_xp_booster_text.style.color = player_table.donator_color;

//					$.Msg(Math.floor(player_table.XP) + " / " + Math.floor(player_table.MaxXP))
//					$.Msg(Math.floor(player_table.XP) / Math.floor(player_table.MaxXP))

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
//					$.Msg("XP earned: " + player_backend_result.xp_change)
					var xpDiff = Math.floor(player_backend_result.xp_change);
//					if (Game.IsInToolsMode())
//						xpDiff = 1000000;

//					$.Msg("XP DIFF: " + xpDiff)
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

							if (player_info.player_id == Players.GetLocalPlayer()) {
								for (var i = 1; i <= levelup_count; i++) {
									var level = player_table.Lvl + i;
									// Comment me please
//									if (Game.IsInToolsMode())
//										var level = 0 + i;

									CreateBattlepassRewardPanel(level, i);
								}
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

					if (player_table && player_table.in_game_tag == 1 && player_backend_result && player_backend_result.xp_multiplier) {
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

//				$.Msg("Player ID: " + id)
				var perm_buffs = GetPermanentBuffs(player_info.player_selected_hero_entity_index);
				var buff_count = 0;

				for (var buff_id in perm_buffs) {
					buff_count++;
					var buff_name = perm_buffs[buff_id];
					var buff_image = Buffs.GetTexture(player_info.player_selected_hero_entity_index, parseInt(buff_id)).replace("item_", "");
					var buff_stacks = Buffs.GetStackCount(player_info.player_selected_hero_entity_index, parseInt(buff_id));
//					$.Msg('file://{images}/' + permanent_buffs[buff_name] + '/' + buff_image + '.png')

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

				PlayerRowContainer.FindChildrenWithClassTraverse("LastHits")[0].text = Players.GetLastHits(id);;
				PlayerRowContainer.FindChildrenWithClassTraverse("Denies")[0].text = Players.GetDenies(id);;
				PlayerRowContainer.FindChildrenWithClassTraverse("GoldPerMin")[0].text = Players.GetGoldPerMin(id).toFixed(0);
				PlayerRowContainer.FindChildrenWithClassTraverse("XPPerMin")[0].text = Players.GetTotalEarnedXP(id) / Players.GetLevel(id);


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

				var iteration = -1;
				$.Each(Game.GetPlayerIDsOnTeam(opposite_team), function(enemy_id) {
					iteration++;
					var enemy_info = Game.GetPlayerInfo(enemy_id);

					if (player_result && player_result.kills_done_to_hero && player_result.kills_done_to_hero[enemy_id] > 0 && panel_kill_matrix_row.FindChildTraverse("VictimDeathCount" + iteration)) {
						panel_kill_matrix_row.AddClass("Victim_" + iteration + "_Active")
						panel_kill_matrix_row.FindChildTraverse("VictimDeathCount" + iteration).text = "x" + player_result.kills_done_to_hero[enemy_id];
					}

					// TODO: Somehow, panel 5 to 9 are not created in 10v10, despite dashboard_page_post_game_kill_matrix_row.xml being edited with 10 panels
//					$.Msg(iteration + " / " + panel_kill_matrix_row.FindChildTraverse("VictimHero" + iteration))
					if (panel_kill_matrix_row.FindChildTraverse("VictimHero" + iteration)) {
						// using panel.heroname doesn't work for custom heroes
						panel_kill_matrix_row.FindChildTraverse("VictimHero" + iteration).style.backgroundImage = 'url("s2r://panorama/images/heroes/icons/' + enemy_info.player_selected_hero + '.png")';
						panel_kill_matrix_row.FindChildTraverse("VictimHero" + iteration).style.backgroundSize = "cover";

						panel_kill_matrix_row.FindChildTraverse("VictimHero" + iteration).heroname = enemy_info.player_selected_hero;
					}
				});

				panel_kill_matrix_row.FindChildTraverse("TotalKills").GetChild(0).text = player_info.player_kills;

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

//					$.Msg(player_result.abilities_level_up_order)
					if (player_result.abilities_level_up_order) {
						for (var i = 1; i <= 25; i++) {
							var ability_name = player_result.abilities_level_up_order[i];
							var ability_entity = Entities.GetAbilityByName(player_info.player_selected_hero_entity_index, ability_name);
							var ability_level = GetAbilityLevel(player_result.abilities_level_up_order, ability_name, i);
							var ability_max_level = Abilities.GetMaxLevel(ability_entity);

							var ability = $.CreatePanel('DOTAAbilityImage', panel_abilities, '');
							ability.abilityname = ability_name;

							if (ability_level == ability_max_level) {
//								ability.AddClass("AbilityMaxLevel"); // not working somehow
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

//				panel_kill_matrix_row.FindChildTraverse("TotalKills").GetChild(0).text = player_info.player_kills;
			});

			// Would be good to use css class at some point...
			if (bTenvTen) {
				for (var child = 0; child < player_row_container.GetChildCount(); child++) {
					player_row_container.GetChild(child).style.height = "42px";
					player_row_container.GetChild(child).style.marginTop = "2.5px";
					player_row_container.GetChild(child).style.marginBottom = "2.5px";
					player_row_container.GetChild(child).GetChild(0).style.paddingBottom = "0px";
					player_row_container.GetChild(child).FindChildTraverse("TalentTree").style.width = "40px";
					player_row_container.GetChild(child).FindChildrenWithClassTraverse("Level")[0].style.visibility = "visible";
					player_row_container.GetChild(child).FindChildrenWithClassTraverse("Level")[0].style.fontSize = "26px";
					player_row_container.GetChild(child).FindChildrenWithClassTraverse("Level")[0].style.textAlign = "right";
					player_row_container.GetChild(child).FindChildrenWithClassTraverse("Level")[0].style.marginRight = "23px";
				}

				pinned_team_container.style.marginTop = "1px";

				for (var child = 0; child < pinned_team_container.GetChildCount(); child++) {
					pinned_team_container.GetChild(child).AddClass("StatRowHeight10v10");
					pinned_team_container.GetChild(child).style.height = "42px";
					pinned_team_container.GetChild(child).style.marginBottom = "5px";
					pinned_team_container.GetChild(child).FindChildrenWithClassTraverse("HeroLevelLabel")[0].style.visibility = "collapse";
					pinned_team_container.GetChild(child).FindChildrenWithClassTraverse("LevelAndHero")[0].style.marginLeft = "30px";
				}

				for (var child = 0; child < player_damage_dealt_row_container.GetChildCount(); child++) {
					player_damage_dealt_row_container.GetChild(child).style.height = "42px"
					player_damage_dealt_row_container.GetChild(child).style.marginTop = "2.5px"
					player_damage_dealt_row_container.GetChild(child).style.marginBottom = "2.5px"
				}

				for (var child = 0; child < panel_kill_matrix_row_container.GetChildCount(); child++) {
					panel_kill_matrix_row_container.GetChild(child).style.height = "42px"
					panel_kill_matrix_row_container.GetChild(child).style.marginTop = "2.5px"
					panel_kill_matrix_row_container.GetChild(child).style.marginBottom = "2.5px"
				}

				for (var child = 0; child < panel_support_items_row_container.GetChildCount(); child++) {
					panel_support_items_row_container.GetChild(child).style.height = "42px"
					panel_support_items_row_container.GetChild(child).style.marginTop = "2.5px"
					panel_support_items_row_container.GetChild(child).style.marginBottom = "2.5px"
				}

				for (var child = 0; child < panel_abilities_row_container.GetChildCount(); child++) {
					panel_abilities_row_container.GetChild(child).style.height = "42px"
					panel_abilities_row_container.GetChild(child).style.marginTop = "2.5px"
					panel_abilities_row_container.GetChild(child).style.marginBottom = "2.5px"
				}
			} else {
//				for (var child = 0; child < pinned_team_container.GetChildCount(); child++) {
//					pinned_team_container.GetChild(child).AddClass("StatRowHeight");
//					pinned_team_container.GetChild(child).style.height = row_height;
//				}

				$("#" + team_name[team_number] + "PlayerRowLegend").FindChildrenWithClassTraverse("LegendLevel")[0].style.visibility = "collapse";
			}
//		}
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

		for (var i = 0; i < $("#RadiantDamageDealtRows").GetChildCount(); i++) {
			$("#RadiantDamageDealtRows").GetChild(i).DeleteAsync(0);
		}

		for (var i = 0; i < $("#DireDamageDealtRows").GetChildCount(); i++) {
			$("#DireDamageDealtRows").GetChild(i).DeleteAsync(0);
		}

		for (var i = 0; i < $("#RadiantDamageReceivedRows").GetChildCount(); i++) {
			$("#RadiantDamageReceivedRows").GetChild(i).DeleteAsync(0);
		}

		for (var i = 0; i < $("#DireDamageReceivedRows").GetChildCount(); i++) {
			$("#DireDamageReceivedRows").GetChild(i).DeleteAsync(0);
		}

		for (var i = 0; i < $("#RadiantKillMatrixRows").GetChildCount(); i++) {
			$("#RadiantKillMatrixRows").GetChild(i).DeleteAsync(0);
		}

		for (var i = 0; i < $("#DireKillMatrixRows").GetChildCount(); i++) {
			$("#DireKillMatrixRows").GetChild(i).DeleteAsync(0);
		}

		if ($("#RadiantSupportItemsRows")) {
			for (var i = 0; i < $("#RadiantSupportItemsRows").GetChildCount(); i++) {
				$("#RadiantSupportItemsRows").GetChild(i).DeleteAsync(0);
			}
		}

		if ($("#DireSupportItemsRows")) {
			for (var i = 0; i < $("#DireSupportItemsRows").GetChildCount(); i++) {
				$("#DireSupportItemsRows").GetChild(i).DeleteAsync(0);
			}
		}

		if ($("#AbilitiesRadiantPlayerRows")) {
			for (var i = 0; i < $("#AbilitiesRadiantPlayerRows").GetChildCount(); i++) {
				$("#AbilitiesRadiantPlayerRows").GetChild(i).DeleteAsync(0);
			}
		}

		if ($("#AbilitiesDirePlayerRows")) {
			for (var i = 0; i < $("#AbilitiesDirePlayerRows").GetChildCount(); i++) {
				$("#AbilitiesDirePlayerRows").GetChild(i).DeleteAsync(0);
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

	// bla bla temporary make it clean later
	function FindDotaHudElement(id) {
		return GetDotaHud().FindChildTraverse(id);
	}

	function GetDotaHud() {
		var p = $.GetContextPanel();
		while (p !== null && p.id !== 'Hud') {
			p = p.GetParent();
		}
		if (p === null) {
			throw new HudNotFoundException('Could not find Hud root as parent of panel with id: ' + $.GetContextPanel().id);
		} else {
			return p;
		}
	}

	GameEvents.Subscribe("end_game", EndScoreboard);
/*
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

		EndScoreboard(args);
	}
*/
})();
