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
	$.GetContextPanel().RemoveClass("MatchDataLoading");
	$("#ContainerLoaded").style.opacity = "1";

	// Hide Overview and use only Scoreboard tab for now
	$.GetContextPanel().AddClass("ScoreboardVisible");
	$("#DetailsOverview").style.opacity = "0";
	$("#DetailsScoreboardContainer").style.opacity = "1";
	$("#DetailsDamageDealt").style.opacity = "0"; // This is the panel following DetailsScoreboardContainer, not being used atm
	$("#PinnedHeroes").style.opacity = "1";

	// Set game time
//	$("#GameTimeText").text = $.Localize("DOTA_Tooltip_ability_fountain_glyph_duration") +  RawTimetoGameTime(Game.GetDOTATime(false, false));

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

//	$.Msg(args)

	var bTenvTen = Game.GetAllPlayerIDs().length > 10;

	if (bTenvTen == false) {
		$("#DetailsScoreboardContainer").style.marginTop = "15%";
		$("#PinnedHeroes").style.marginTop = "15%";
	}

	for (var i = 2; i <= 3; i++) {
		var pinned_team_container = $("#Pinned" + team_name[i]);
		pinned_team_container.AddClass("PinnedTeam");
		pinned_team_container.AddClass("TomBottomFlow");

		var player_row_container = $("#" + team_name[i] + "PlayerRows");
		// not sure why i have to hardcode it yet
		player_row_container.style.flowChildren = "down";
		player_row_container.style.height = "fit-children";
//		$.Msg("Team: " + i)

//		if (Game.GetTeamDetails(i).team_num_players > 0) {
			$.Each(Game.GetPlayerIDsOnTeam(i), function(id) {
//				$.Msg("Player ID " + id + " in team " + i)
				var player_info = Game.GetPlayerInfo(id);
				var player_items = Game.GetPlayerItems(id);
				var player_table = CustomNetTables.GetTableValue("battlepass", id.toString());

//				$.Msg(player_info)
//				$.Msg(player_table)

				// Set left bar player informations
				var PinnedPlayerRow = $.CreatePanel('Panel', pinned_team_container, 'PinnedPlayerRow' + id);
				PinnedPlayerRow.BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_pinned_player_row.xml", false, false);
				PinnedPlayerRow.AddClass("PlayerName");

				PinnedPlayerRow.FindChildTraverse("HeroImage").heroname = Players.GetPlayerSelectedHero(id);
				PinnedPlayerRow.FindChildTraverse("PlayerNameScoreboard").GetChild(0).text = player_info.player_name;
				PinnedPlayerRow.FindChildrenWithClassTraverse("HeroLevelLabel")[0].text = player_info.player_level;
				PinnedPlayerRow.FindChildrenWithClassTraverse("LevelAndHero")[0].text = $.Localize(Players.GetPlayerSelectedHero(id));

				// Set middle bar player informations
				var PlayerRowContainer = $.CreatePanel('Panel', player_row_container, 'PlayerRow' + id);
				PlayerRowContainer.BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_row.xml", false, false);

				// temporary fix

				if (bTenvTen) {
					PinnedPlayerRow.AddClass("StatRowHeight10v10");
					PlayerRowContainer.style.height = "42px";
					PlayerRowContainer.style.marginBottom = "5px";
					PinnedPlayerRow.style.marginBottom = "1px";
				} else {
					PinnedPlayerRow.AddClass("StatRowHeight");
					PlayerRowContainer.style.height = "56px";
				}

				PlayerRowContainer.FindChildrenWithClassTraverse("Level")[0].text = player_info.player_level;
				PlayerRowContainer.FindChildrenWithClassTraverse("Kills")[0].text = player_info.player_kills;
				PlayerRowContainer.FindChildrenWithClassTraverse("Deaths")[0].text = player_info.player_deaths;
				PlayerRowContainer.FindChildrenWithClassTraverse("Assists")[0].text = player_info.player_assists;
//				PlayerRowContainer.FindChildrenWithClassTraverse("MMRChange")[0]
				PlayerRowContainer.FindChildrenWithClassTraverse("NetWorth")[0].text = player_info.player_gold;

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
				var player_result = args.data.players[player_info.player_steamid];
//				$.Msg(player_result)

				if (player_result != null) {
					var xpDiff = Math.floor(player_result.xp_change);
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

					if (player_table && player_table.in_game_tag == 1) {
						var multiplier = Math.round(player_result.xp_multiplier * 100.0);
						panel_xp_booster_text.text = " (" + multiplier + "%)";
					} else {
						panel_xp_booster_text.text = " (100%)";
					}
				} else {
					panel_xp_diff_text.text = "N/A";
				}

				// setup player items in inventory
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
//				PlayerRowContainer.FindChildrenWithClassTraverse("HeroHealing")[0].text = 0;
			});

			// Set Team name and score
			$("#HeroIconsColumn").FindChildTraverse(team_name[i] + "TeamName").text = $.Localize(team_localization_name[i]);
			$("#" + team_name[i] + "TeamScore").text = "Score: " + Game.GetTeamDetails(i).team_score;

			if (Game.GetGameWinner() == i)
				$("#" + team_name[i] + "Winner").style.visibility = "visible";

			$("#" + team_name[i] + "PlayerRowLegend").BLoadLayout("file://{resources}/layout/custom_game/frostrose_end_screen_v2/dashboard_page_post_game_row_legend.xml", false, false);
//		}
	}
}

(function () {
//	$.Msg("START END SCREEN")

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

	// Show loading panel
	FindDotaHudElement("topbar").style.visibility = "collapse";
	$.GetContextPanel().AddClass("MatchDataLoading");

	GameEvents.Subscribe("end_game", EndScoreboard);

	// Placeholder
	if (Game.IsInToolsMode()) {
		var args = {
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

		EndScoreboard(args);
	}
})();
