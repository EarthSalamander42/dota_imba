"use strict";

(function() {

	var newsUrl = "http://api.dota2imba.org/imba/meta/loading-screen-info";

	var ui = {
		title : $("#imba-news-title"),
		text : $("#imba-news-text"),
		link : $("#imba-news-link")
	};

	var defaultLanguage = "en";

	var initializeNews = function InitializeNews() {

		$.AsyncWebRequest(newsUrl, {
			type : "GET",
			dataType : "json",
			success : function(data) {

				var lang = data.data.languages[defaultLanguage];
				ui.title.text = lang.title;
				ui.text.text = lang.text;
				ui.link.text = lang.link_text;
				ui.link.SetPanelEvent("onactivate", function() {
					$.DispatchEvent("DOTADisplayURL", lang.link_value);
				});
			},
			timeout : 5000,
			error : function(err) {
				$.Msg("Error: " + JSON.stringify(err));
			}
		});
	};

	initializeNews();
})();
