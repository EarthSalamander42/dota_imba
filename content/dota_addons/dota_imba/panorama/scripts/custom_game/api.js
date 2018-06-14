"use strict";

var api = {

	timeout: 5000,
	base: "http://api.dota2imba.org/imba/",
	endpoints: {
		meta: {
			companions: "meta/companions",
			statues: "meta/ingame-statues",
			modify_companion: "meta/modify-companion",
			modify_statue: "meta/modify-ingame-statue",
			player_info: "meta/player-info",
			game_info: "meta/game-info",
			loading_screen: "meta/loading-screen"
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

	loading_screen: function () {
		return this.request(this.get_url(this.endpoints.meta.loading_screen));
	},

	user_info: function (username) {
		return this.request(this.get_url(this.endpoints.meta.user_info, { username: username }));
	},

	game_info: function () {
		return this.request(this.get_url(this.endpoints.meta.game_info));
	},

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
					reject(err);
				}
			});
		})
	},
};
