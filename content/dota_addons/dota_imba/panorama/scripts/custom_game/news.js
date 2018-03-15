"use strict";

(function () {

	var urls = {
		metaNews: "https://api.dota2imba.org/meta/news"
	};

	var ui = {
		normalTitle: $("#imba-normal-news-title"),
		normalText: $("#imba-normal-news-article-text"),
//		owTitle: $("#imba-ow-news-article-title")
//		owText: $("#imba-ow-news-article-text")
	};

	var initializeNews = function InitializeNews() {
//		$.Msg("Initialize News");

		$.AsyncWebRequest(urls.metaNews, {
			type: "GET",
			dataType: "json",
			success: function (data) {
//				$.Msg("News received: " + JSON.stringify(data.data.en.title));
				ui.normalTitle.text = data.data.en.title;
				ui.normalText.text = data.data.en.text;
//				ui.owTitle.text = data.data.en.title;
//				ui.owText.text = data.data.en.text;
			},
			timeout: 5000,
			error: function (err) {
				$.Msg("Error: " + JSON.stringify(err));
			}
		});
	};

	initializeNews();
})(); 
