"use strict";

var view = {
	title: $("#imba-loading-title-text"),
	text: $("#imba-loading-content-text"),
	map: $("#imba-loading-map-text"),
	link: $("#imba-loading-link"),
	link_text:  $("#imba-loading-link-text")
};

var link_targets = "";

function ucwords (str) {
	return (str + '').replace(/^(.)|\s+(.)/g, function ($1) {
		return $1.toUpperCase();
	});
}

function info_already_available() {
	return Game.GetMapInfo().map_name != "";
}

function fetch() {
	view.title.text = "Dota IMBA 7.08f - The Grand Magus";
	view.text.text = "Dota IMBA 7.09 will be released as soon as possible, including Dota 2 7.20 changes, be patient! We're currently migrating the server, Imba XP will be down for few days. Experience Boosters will be multiplied by 2 for a limited time once the server is working again! (Non donators will get 200% xp boost instead of 100%, Ember donators will get 600% instead of 300%, etc...)";
	view.link_text.text = "Dota 2 IMBA website is currently unavailable.";

	// if data is not available yet, reschedule
	if (!info_already_available()) {
		$.Schedule(0.1, fetch);
		return;
	}

	$.Msg("Fetching and setting loading screen data");
	
	var mapInfo = Game.GetMapInfo();
	var map_name = ucwords(mapInfo.map_display_name.replace('_', " "));
 
	api.resolve_map_name(mapInfo.map_display_name).then(function (data) {
		view.map.text = data;
	}).catch(function (err) {
		$.Msg("Failed to resolve map name: " + err.message);
		view.map.text = map_name;
	});

	view.map.text = map_name;

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

fetch();
