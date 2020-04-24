"use strict";

var secret_key = {};

var api = {
	base : "http://api.frostrose-studio.com/",
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

function ucwords (str) {
	return (str + '').replace(/^(.)|\s+(.)/g, function ($1) {
//		return $1.toUpperCase();
		return $1;
	});
}

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
	view.subtitle.text = "Outlanders Rising";

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
	});

//	$.Msg("Fetching and setting loading screen data");

	var mapInfo = Game.GetMapInfo();
//	var map_name = ucwords(mapInfo.map_display_name.replace('_', " "));
	var map_name = mapInfo.map_display_name.replace('_', " ");

//	view.map.text = map_name;
/*
	api.resolve_map_name(mapInfo.map_display_name).then(function (data) {
		view.map.text = data;
	}).catch(function (err) {
		$.Msg("Failed to resolve map name: " + err.message);
		view.map.text = map_name;
	});

	api.loading_screen().then(function (data) {
		var lang = $.Language();
		var rdata = data.languages["en"];

		if (data.languages[lang] !== undefined)
			rdata = data.languages["en"];

		view.title.text = rdata.title;
		view.text.text = rdata.text;
		view.link_text.text = rdata.link_text;

		view.link.SetPanelEvent("onactivate", function() {
			$.DispatchEvent("DOTADisplayURL", rdata.link_value || "");
		});
		
	}).catch(function (reason) {
		$.Msg("Loading Loading screen information failed");
		$.Msg(reason);

		view.text.text = "News currently unavailable.";
	});
	*/
	/*
	var player_info = Game.GetPlayerInfo(Game.GetLocalPlayerID());
	
	api.player_info(player_info.player_steamid).then(function (data) {
		// TODO: do sth with the data
	}).catch(function (reason) {
		$.Msg("Loading player info for loading screen failed!")
		$.Msg(reason);
	});
	*/
};

function AllPlayersLoaded() {
//	$.Msg("ALL PLAYERS LOADED IN!")
	for (var i = 1; i <= $("#vote-container").GetChildCount() - 3; i++) {
		//$.Msg("Game Mode: ", i)
		var panel = $("#vote-container").GetChild(i);
		var gamemode = panel.id.replace("VoteGameModeText", "");

		if (!panel.BHasClass("Active"))
			panel.AddClass("Active");

		(function (panel, gamemode) {
			panel.SetPanelEvent("onactivate", function () {
				OnVoteButtonPressed('gamemode', gamemode);
			})

			panel.SetPanelEvent("onmouseover", function () {
				$.DispatchEvent("UIShowTextTooltip", panel, $.Localize("description_gamemode_" + gamemode));
			})

			panel.SetPanelEvent("onmouseout", function () {
				$.DispatchEvent("UIHideTextTooltip", panel);
			})
		})(panel, gamemode);
	}


//	$("#VoteGameMode1").checked = true;
//	OnVoteButtonPressed("gamemode", 1);

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
}

/* new system, double votes for donators

function OnVotesReceived(data)
{
//	$.Msg(data)
//	$.Msg(data.vote.toString())
//	$.Msg(data.table)
//	$.Msg(data.table[id])

	var vote_count = []

	var map_name_cut = Game.GetMapInfo().map_display_name.replace('_', " ");

	// Reset tooltips
	for (var i = 1; i <= 5; i++) {
		vote_count[i] = 0;
		if ($("#VoteGameModeText" + i))
			$("#VoteGameModeText" + i).text = map_name_cut + " " + $.Localize("#vote_gamemode_" + i);
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
			vote_tooltip = "votes"

		if ($("#VoteGameModeText" + i))
			$("#VoteGameModeText" + i).text = map_name_cut + " " + $.Localize("#vote_gamemode_" + i) + " (" + vote_count[i] + " "+ vote_tooltip +")";
	}

//	if (data.category == "random_tower_abilities") {

//	}
}

*/

function OnVotesReceived(data)
{
//	$.Msg(data)
//	$.Msg(data.vote.toString())
//	$.Msg(data.table)
//	$.Msg(data.table[id])

	var vote_count = []

	var map_name_cut = Game.GetMapInfo().map_display_name.replace('_', " ");

	// Reset tooltips
	for (var i = 1; i <= 5; i++) {
		vote_count[i] = 0;
		if ($("#VoteGameModeText" + i))
			$("#VoteGameModeText" + i).text = map_name_cut + " " + $.Localize("#vote_gamemode_" + i);
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

		if ($("#VoteGameModeText" + i))
			$("#VoteGameModeText" + i).text = map_name_cut + " " + $.Localize("#vote_gamemode_" + i) + " (" + vote_count[i] + " "+ vote_tooltip +")";
	}

//	if (data.category == "random_tower_abilities") {

//	}
}

function DisableVoting() {
	$("#imba-loading-title-vote").style.visibility = "collapse";
}

function DisableRankingVoting() {
	$("#imba-loading-title-vote").FindChildTraverse("vote-content").GetChild(0).style.visibility = "collapse";
}

(function(){
	HoverableLoadingScreen();
	fetch();
	AllPlayersLoaded()

	GameEvents.Subscribe("loading_screen_debug", LoadingScreenDebug);
	GameEvents.Subscribe("send_votes", OnVotesReceived);
	GameEvents.Subscribe("all_players_loaded", AllPlayersLoaded);
})();
