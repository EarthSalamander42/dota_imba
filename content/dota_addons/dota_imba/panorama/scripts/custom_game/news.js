"use strict";

(function () {

	var urls = {
		metaNews: "https://api.dota2imba.org/meta/news"
	};

	var ui = {
		title: $("#imba-normal-news-article-title"),
		text: $("#imba-normal-news-article-text")
	};

	var initializeNews = function InitializeNews() {
		$.Msg("Initialize News");

		$.AsyncWebRequest(urls.metaNews, {
			type: "GET",
			dataType: "json",
			success: function (data) {
				$.Msg("News received: " + JSON.stringify(data.data.en.title));
				ui.title.text = data.data.en.title;
				ui.text.text = data.data.en.text;
			},
			timeout: 5000,
			error: function (err) {
				$.Msg("Error: " + JSON.stringify(err));
			}
		});
	};

	initializeNews();

})();