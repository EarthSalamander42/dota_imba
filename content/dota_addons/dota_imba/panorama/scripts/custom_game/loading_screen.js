"use strict";

var view = {
	title: $("#imba-loading-title-text"),
	text: $("#imba-loading-content-text"),
	map: $("#imba-loading-map-text")
};
function ucwords (str) {
	return (str + '').replace(/^(.)|\s+(.)/g, function ($1) {
		return $1.toUpperCase();
	});
}

function fetch() {

	view.title.text = "Dota IMBA 7.06 - The Fundamental Awakening";

	var mapInfo = Game.GetMapInfo();
	var map_name = ucwords(mapInfo.map_display_name.replace('_', " "));

	api.resolve_map_name(mapInfo.map_display_name).then(function (data) {
		$.Msg(data);
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
		
		$.Msg(rdata);

	}).catch(function (reason) {
		$.Msg("Loading Loading screen information failed");
		$.Msg(reason);

		view.text.text = "News currently unavailable.";
	});

	var player_info = Game.GetPlayerInfo(Game.GetLocalPlayerID());
	$.Msg(player_info.player_steamid);
	
	api.player_info(player_info.player_steamid).then(function (data) {
		$.Msg(data);
	}).catch(function (reason) {
		$.Msg("Loading player info for loading screen failed!")
		$.Msg(reason);
	});
};

fetch();