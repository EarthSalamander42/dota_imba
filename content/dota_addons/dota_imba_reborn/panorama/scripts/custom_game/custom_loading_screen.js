"use strict";

var secret_key = {};

var api = {
	base : "https://api.frostrose-studio.com/",
	urls : {
		loadingScreenMessage : "imba/loading-screen-info",
	},
	getLoadingScreenMessage : function(success_callback, error_callback) {
		$.AsyncWebRequest(api.base + api.urls.loadingScreenMessage, {
			type : "GET",
			dataType : "json",
			timeout : 5000,
			headers : {'X-Dota-Server-Key' : secret_key},
			success : function(obj) {
				if (obj.error) {
					$.Msg("Error loading screen info");
					error_callback();
				} else {
					$.Msg("Get loading screen info successful");
					success_callback(obj);
				}
			},
			error : function(err) {
				$.Msg("Error loading screen info" + JSON.stringify(err));
				error_callback();
			}
		});
	},
}

var view = {
	title: $("#loading-title-text"),
	subtitle: $("#loading-subtitle-text"),
	text: $("#loading-description-text"),
	map: $("#loading-map-text"),
	link: $("#loading-link"),
	link_text:  $("#loading-link-text")
};

var link_targets = "";

function info_already_available() {
	return Game.GetMapInfo().map_name != "";
}

function isInt(n) {
   return n % 1 === 0;
}

function LoadingScreenDebug(args) {
	$.Msg(args)
	view.text.text = view.text.text + ". \n\n" + args.text;
}

function SwitchTab(count) {
	var container = $.GetContextPanel().FindChildrenWithClassTraverse("bottom-footer-container");

	if (container && container[0]) {
		for (var i = 0; i < container[0].GetChildCount(); i++) {
			var panel = container[0].GetChild(i);
			var new_panel = container[0].GetChild(count - 1);

			if (panel == new_panel)
				panel.style.visibility = "visible";
			else
				panel.style.visibility = "collapse";
		}
	}

	var label = $("#BottomLabel");

	if (label) {
		label.text = $.Localize("#loading_screen_custom_games_" + count);
	}
}

function SetProfile() {
	var check = false;
	var check = false;

	if ($("#HomeProfileContainer")) {
		if ($("#HomeProfileContainer").FindChildTraverse("UserNickname") && $("#HomeProfileContainer").FindChildTraverse("UserNickname").GetChild(0)) {
			var player_table = CustomNetTables.GetTableValue("battlepass_player", Players.GetLocalPlayer().toString());

			if (player_table && player_table.Lvl) {
				$("#HomeProfileContainer").FindChildTraverse("UserNickname").GetChild(0).text = "Battle Pass Level: " + player_table.Lvl;

				check = true;
			}
		}
	}

	if (check == false) {
		$.Schedule(0.1, SetProfile);
		return;
	}
}

function SetProfileName() {
	var check = false;

	if ($("#HomeProfileContainer")) {
		if ($("#HomeProfileContainer").FindChildTraverse("AvatarImage") && Game.GetLocalPlayerInfo(Players.GetLocalPlayer())) {
			if ($("#HomeProfileContainer").FindChildTraverse("UserName") && $("#HomeProfileContainer").FindChildTraverse("UserName").GetChild(0)) {
				if ($("#HomeProfileContainer").FindChildTraverse("UserNickname") && $("#HomeProfileContainer").FindChildTraverse("UserNickname").GetChild(0)) {
					$("#HomeProfileContainer").FindChildTraverse("AvatarImage").steamid = Game.GetLocalPlayerInfo(Players.GetLocalPlayer()).player_steamid;

					$("#HomeProfileContainer").FindChildTraverse("UserName").GetChild(0).text = Players.GetPlayerName(Game.GetLocalPlayerID());
					$("#HomeProfileContainer").FindChildTraverse("UserName").GetChild(0).style.textOverflow = "shrink";

					$("#HomeProfileContainer").FindChildTraverse("RankTierContainer").style.marginTop = "21px";
					$("#HomeProfileContainer").FindChildTraverse("RankTierContainer").style.marginRight = "-15px";

					$("#HomeProfileContainer").FindChildTraverse("UserNickname").GetChild(0).text = "";

					check = true;
				}
			}
		}
	}

	if (check == false) {
		$.Schedule(0.1, SetProfileName);
		return;
	} else {
		SetProfile();
	}
}

function fetch() {
	// if data is not available yet, reschedule
	if (!info_already_available()) {
		$.Schedule(0.1, fetch);
		return;
	}

	var game_options = CustomNetTables.GetTableValue("game_options", "game_version");
	if (game_options == undefined) {
		$.Schedule(0.1, fetch);
		return;
	}

	secret_key = CustomNetTables.GetTableValue("game_options", "server_key");
	if (secret_key == undefined) {
		$.Schedule(0.1, fetch);
		return;
	} else {
		secret_key = secret_key["1"];
	}

	if (Game.GetMapInfo().map_display_name == "imba_1v1")
		DisableVoting();
	else if (Game.GetMapInfo().map_display_name == "imbathrow_3v3v3v3")
		DisableRankingVoting();

	var game_version = game_options.value;

	if (isInt(game_version))
		game_version = game_version.toString() + ".0";

	view.title.text = $.Localize("#addon_game_name") + " " + game_version;
	view.subtitle.text = $.Localize("#game_version_name").toUpperCase();

	api.getLoadingScreenMessage(function(data) {
		var found_lang = false;
		var result = data.data;
		var english_row;

		for (var i in result) {
			var info = result[i];

			if (info.lang == $.Localize("lang")) {
				view.text.text = info.content;
//				view.link_text.text = info.link_text;
				found_lang = true;
				break;
			} else if (info.lang == "en") {
				english_row = info;
			}
		}

		if (found_lang == false) {
			view.text.text = english_row.content;
//			view.link_text.text = english_row.link_text;
		}
	}, function() {
		// error callback
		$.Msg("Unable to retrieve loading screen info.")
	});
};

function AllPlayersLoaded() {
	$.Msg("ALL PLAYERS LOADED IN!")

	$("#MainVoteButton").style.opacity = "1";

	for (var i = 1; i <= $("#vote-container").GetChildCount() - 3; i++) {
		//$.Msg("Game Mode: ", i)
		var panel = $("#vote-container").GetChild(i);
		var gamemode = panel.id.replace("VoteGameModeText", "");

		if (!panel.BHasClass("Active"))
			panel.AddClass("Active");

		(function (panel, gamemode) {
			panel.SetPanelEvent("onmouseover", function () {
				$.DispatchEvent("UIShowTextTooltip", panel, $.Localize("description_gamemode_" + gamemode));
			})

			panel.SetPanelEvent("onmouseout", function () {
				$.DispatchEvent("UIHideTextTooltip", panel);
			})
		})(panel, gamemode);
	}

	ToggleVoteContainer(true);

	var vote_panel = $.GetContextPanel().FindChildrenWithClassTraverse("vote-select-panel-container");

	if (vote_panel && vote_panel[0]) {
		for (var i = 0; i <= vote_panel[0].GetChildCount() - 1; i++) {
			var panel = vote_panel[0].GetChild(i);
			var gamemode = undefined;
			var button = undefined;

			if (panel.GetChild(2)) {
				gamemode = panel.GetChild(2).id.replace("VoteGameModeMainText", "");
				button = panel.GetChild(2);

				panel.GetChild(0).text = $.Localize("vote_gamemode_" + gamemode);
				panel.GetChild(1).text = $.Localize("description_gamemode_" + gamemode);
			}

//			if (!panel.BHasClass("Active"))
//				panel.AddClass("Active");

			if (gamemode) {
				(function (button, gamemode) {
					button.SetPanelEvent("onactivate", function () {
						OnVoteButtonPressed('gamemode', gamemode);
						ToggleVoteContainer(false);
					})
				})(button, gamemode);
			}
		}
	}

//	$("#VoteGameMode1").checked = true;
//	OnVoteButtonPressed("gamemode", 1);
}

function AllPlayersBattlepassLoaded() {
	$.Msg("ALL PLAYERS BATTLEPASS LOADED!")

	var player_table = CustomNetTables.GetTableValue("battlepass_player", Players.GetLocalPlayer().toString());

	if (player_table && player_table.mmr_title) {
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

		$.GetContextPanel().FindChildTraverse("RankTier").style.backgroundImage = 'url("s2r://panorama/images/rank_tier_icons/rank' + mmr_rank_to_medals[short_title] + '_psd.vtex")';
		$.GetContextPanel().FindChildTraverse("RankPips").style.backgroundImage = 'url("s2r://panorama/images/rank_tier_icons/pip' + title_stars + '_psd.vtex")';
/*
		rank_panel.SetPanelEvent("onmouseover", function () {
			$.DispatchEvent("DOTAShowTextTooltip", rank_panel, player_table.mmr_title);
		})
		rank_panel.SetPanelEvent("onmouseout", function () {
			$.DispatchEvent("DOTAHideTextTooltip", rank_panel);
		})
*/
	}
}

function ToggleVoteContainer(bBoolean) {
	var vote_container = $.GetContextPanel().FindChildrenWithClassTraverse("vote-container-main");

	if (vote_container && vote_container[0]) {
		vote_container[0].SetHasClass("Visible", bBoolean);
	}
}

function HoverableLoadingScreen() {
	if (Game.GameStateIs(2))
		$.GetContextPanel().style.zIndex = "1";
	else
		$.Schedule(1.0, HoverableLoadingScreen)
}

function OnVoteButtonPressed(category, vote)
{
//	$.Msg("Category: ", category);
//	$.Msg("Vote: ", vote);
	GameEvents.SendCustomGameEventToServer( "setting_vote", { "category":category, "vote":vote, "PlayerID":Game.GetLocalPlayerID() } );
	var gamemode_name = $.Localize("vote_gamemode_" + vote)
	$("#VoteGameModeCheck").text = "You have voted for " + gamemode_name + "."
}

/* new system, double votes for donators */

function OnVotesReceived(data)
{
//	$.Msg(data)
//	$.Msg(data.vote.toString())
//	$.Msg(data.table)

	var vote_count = [];

	var map_name_cut = Game.GetMapInfo().map_display_name.replace('_', " ");

	// Reset tooltips
	for (var i = 1; i <= 5; i++) {
		vote_count[i] = 0;
		if ($("#VoteGameModeText" + i))
			$("#VoteGameModeText" + i).text = $.Localize("#vote_gamemode_" + i);
	}


	// Check number of votes for each gamemodes
	for (var id in data.table){
		var gamemode = data.table[id][1];
		var amount_of_votes = data.table[id][2];
//		$.Msg(gamemode + " / "+ amount_of_votes)
		vote_count[gamemode] = vote_count[gamemode] + amount_of_votes;
	}

	// Modify tooltips based on voted gamemode
	for (var i = 1; i <= 5; i++) {
		var vote_tooltip = "vote"
		if (vote_count[i] > 1)
			vote_tooltip = "votes";

		if ($("#VoteGameModeText" + i)) {
			$("#VoteGameModeText" + i).style.color = "white";
			$("#VoteGameModeText" + i).text = $.Localize("#vote_gamemode_" + i) + " (" + vote_count[i] + " "+ vote_tooltip +")";
		}
	}

	// calculate number of people who voted
	var highest_vote = 0;
	for (var i in vote_count) {
		if (vote_count[i] > highest_vote)
			highest_vote = i;
	}

	if ($("#VoteGameModeText" + highest_vote)) {
		if (highest_vote != 1 && vote_count[highest_vote] < 5) {
			$("#VoteGameModeText1").style.color = "green";
		} else {
			$("#VoteGameModeText" + highest_vote).style.color = "green";
		}
	}
}

/*

function OnVotesReceived(data)
{
//	$.Msg(data)
//	$.Msg(data.vote.toString())
//	$.Msg(data.table)
//	$.Msg(data.table[id])

	var vote_count = [];

	var map_name_cut = Game.GetMapInfo().map_display_name.replace('_', " ");

	// Reset tooltips
	for (var i = 1; i <= 5; i++) {
		vote_count[i] = 0;
		if ($("#VoteGameModeText" + i))
			$("#VoteGameModeText" + i).text = $.Localize("#vote_gamemode_" + i);
	}

	// Check number of votes for each gamemodes
	for (var id in data.table){
		var gamemode = data.table[id];
		vote_count[gamemode]++;
	}

	// Modify tooltips based on voted gamemode
	for (var i = 1; i <= 5; i++) {
		var vote_tooltip = "vote"
		if (vote_count[i] > 1)
			vote_tooltip = "votes"

		if ($("#VoteGameModeText" + i)) {
			$("#VoteGameModeText" + i).text = $.Localize("#vote_gamemode_" + i) + " (" + vote_count[i] + " "+ vote_tooltip +")";
			$("#VoteGameModeText" + i).style.color = "white";
		}
	}

	// calculate number of people who voted
	var highest_vote = 0;
	for (var i in vote_count) {
		if (vote_count[i] > highest_vote)
			highest_vote = i;
	}

	if ($("#VoteGameModeText" + highest_vote)) {
		if (highest_vote != 1 && vote_count[highest_vote] < 5) {
			$("#VoteGameModeText1").style.color = "green";
		} else {
			$("#VoteGameModeText" + highest_vote).style.color = "green";
		}
	}
}
*/

function DisableVoting() {
	$("#imba-loading-title-vote").style.visibility = "collapse";
}

function DisableRankingVoting() {
	$("#imba-loading-title-vote").FindChildTraverse("vote-content").GetChild(0).style.visibility = "collapse";
}

(function(){
	var vote_info = $.GetContextPanel().FindChildrenWithClassTraverse("vote-info");

	if (vote_info && vote_info[0]) {
		vote_info[0].SetPanelEvent("onmouseover", function () {
			$.DispatchEvent("UIShowTextTooltip", vote_info[0], $.Localize("vote_gamemode_description"));
		})

		vote_info[0].SetPanelEvent("onmouseout", function () {
			$.DispatchEvent("UIHideTextTooltip", vote_info[0]);
		})
	}

	var bottom_button_container = $.GetContextPanel().FindChildrenWithClassTraverse("bottom-button-container");

	if (bottom_button_container && bottom_button_container[0] && bottom_button_container[0].GetChild(0))
		bottom_button_container[0].GetChild(0).checked = true;

	var bottom_patreon_container = $.GetContextPanel().FindChildrenWithClassTraverse("bottom-patreon-sub");

	if (bottom_patreon_container && bottom_patreon_container[0]) {
		var companion_list = [
			"npc_donator_companion_chocobo",
			"npc_donator_companion_mega_greevil",
			"npc_donator_companion_butch",
			"npc_donator_companion_hollow_jack",
			"npc_donator_companion_tory",
			"npc_donator_companion_frog",
		];

		for (var i in companion_list) {
			var companion = $.CreatePanel("Panel", bottom_patreon_container[0], "");
			companion.AddClass("DonatorReward");
			companion.style.width = 100 / companion_list.length + "%";

			var companionpreview = $.CreatePanel("Button", companion, "");
			companionpreview.style.width = "100%";
			companionpreview.style.height = "100%";

			companionpreview.BLoadLayoutFromString('<root><Panel><DOTAScenePanel style="width:100%; height:100%;" particleonly="false" unit="' + companion_list[i] + '"/></Panel></root>', false, false);
			companionpreview.style.opacityMask = 'url("s2r://panorama/images/masks/hero_model_opacity_mask_png.vtex");'
		}
	}

	HoverableLoadingScreen();
	fetch();
	SetProfileName();

	GameEvents.Subscribe("loading_screen_debug", LoadingScreenDebug);
	GameEvents.Subscribe("send_votes", OnVotesReceived);
	GameEvents.Subscribe("all_players_loaded", AllPlayersLoaded);
	GameEvents.Subscribe("all_players_battlepass_loaded", AllPlayersBattlepassLoaded);
})();
