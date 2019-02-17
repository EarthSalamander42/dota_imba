"use strict";

var api = {

	timeout: 5000,
	base: "http://api.dota2imba.fr/imba/",
	endpoints: {
		meta: {
			companions: "companions",
			statues: "ingame-statues",
			modify_companion: "modify-companion",
			modify_statue: "modify-ingame-statue",
			player_info: "player-info",
			multi_player_info: "multi-player-info",
			game_info: "game-info",
			loading_screen: "loading-screen",
			resolve_map_name: "resolve-map-name",
//			diretide_highscores: "diretide/high-scores",
		}
	},

	get_url: function (endpoint, args) {
		var final = this.base + endpoint;
		if (args !== undefined) {
			final += "?";

			for (var k in args) {
				final += k + "=" + args[k] + "&";
			}
		}
		return final;
	},

	multi_player_info: function (steamids) {
		return this.request(this.get_url(this.endpoints.meta.multi_player_info, { ids: steamids.join(",") }));
	},

	resolve_map_name: function (name) {
		return this.request(this.get_url(this.endpoints.meta.resolve_map_name, { name: name }));
	},

	loading_screen: function () {
		return this.request(this.get_url(this.endpoints.meta.loading_screen));
	},

	player_info: function (username) {
		return this.request(this.get_url(this.endpoints.meta.player_info, { username: username }));
	},

	game_info: function () {
		return this.request(this.get_url(this.endpoints.meta.game_info));
	},

//	diretide_highscores: function () {
//		return this.request(this.get_url(this.endpoints.meta.diretide_highscores));
//	},

	request: function (url, data) {

		var self = this;

		var type = "GET";
		if (data !== undefined)
			type = "POST";
		else
			data = {};

		$.Msg("Performing request to " + url + " with method " + type);

		return new Promise(function (resolve, reject) {
			$.AsyncWebRequest(url, {
				type: type,
				data: data,
				dataType: "json",
				timeout: self.timeout,
				success: function (obj) {
					if (obj.error || !obj.data)
						reject("Request to '" + url + "' failed: " + (obj.message ? obj.message : "unknown error"));
					else
						resolve(obj.data);
				},
				error: function (err) {
					$.Msg("Received error: ");
					$.Msg(err);

					var before = err.responseText;
					var length = before.length; 

					var actual = "";
					for (var i = 0; i < length - 1; i++) {
						actual += before[i];
					} 

					reject(JSON.parse(actual));
				}
			});
		})
	},
};
