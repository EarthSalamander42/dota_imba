"use strict";

var gg_state = true;

function GenerateGGTopBar(player, team, has_gg) {
	var team_string;
	if (team == 2) {
		team_string = "Radiant";
	} else if (team == 3) {
		team_string ="Dire";
	}

	// ERROR: find traverse of null when full team has gg
	var TopBarHud = FindDotaHudElement(team_string + 'Player' + player).FindChildTraverse('SlantedContainerPanel');

	if (!TopBarHud.FindChildTraverse("GGBar-" + player) && has_gg == 1) {
		var gg_row = $.CreatePanel("Panel", TopBarHud, "GGBar-" + player);
		gg_row.AddClass("GG_Row");
		gg_row.style.backgroundColor = "gradient(linear,0  100%, 0% 0%, from(#800314b6),color-stop( 0.9, #0a1722ae ), to(#0a1722ae))";
		gg_row.style.width = "100%";
		gg_row.style.height = "100%";
		gg_row.style.align = "center center";
		gg_row.style.zIndex = "5";
		gg_row.style.textAlign = "center center";
		gg_row.style.flowChildren = "right";

		var gg_left_line = $.CreatePanel('Panel', gg_row, "");
		gg_left_line.style.width = "12px";
		gg_left_line.style.height = "2px";
		gg_left_line.style.backgroundColor = "gradient( linear, 100% 0, 0% 0%, from( #f26600 ), color-stop( 0.4, #f26600 ), to( #f2001300 ) )";
		gg_left_line.style.align = "left center";
		gg_left_line.style.margin = "0 0 0 8px";

		var gg_label = $.CreatePanel('Label', gg_row, "");
		gg_label.text = "GG";
		gg_label.style.fontSize = "14px";
		gg_label.style.align = "center center";
		gg_label.style.color = "#f26600";
		gg_label.style.textShadow = "1px 1px 3px 2.0 #000000aa";
		gg_label.style.margin = "2px 0 -2px 6px";

		var gg_right_line = $.CreatePanel('Panel', gg_row, "");
		gg_right_line.style.width = "12px";
		gg_right_line.style.height = "2px";
		gg_right_line.style.backgroundColor = "gradient( linear, 0 0, 100%  0%, from( #f26600 ), color-stop( 0.4, #f26600 ), to( #f2001300 ) )";
		gg_right_line.style.align = "right center";
		gg_right_line.style.margin = "0 5px 0 0";
	} else if (TopBarHud.FindChildTraverse("GGBar-" + player) && has_gg == 0) {
		TopBarHud.FindChildTraverse("GGBar-" + player).DeleteAsync(0)
	}
}

function GGLocal() {
	gg_state = true;
	GGInitCountDown();
	$.GetContextPanel().FindChildTraverse('Root').AddClass("visible");

	$.Schedule(9, function() {
		if (gg_state) {
			GameEvents.SendCustomGameEventToServer("send_gg_vote", {
				ID: Game.GetLocalPlayerID(),
				team: Players.GetTeam(Game.GetLocalPlayerID()),
				vote: true
			});

			$.GetContextPanel().FindChildTraverse('Root').RemoveClass("visible");
		};		
	});
}

function GGInitCountDown() {
	for (var i = 0; i < 9; i++) {
		// Isolating scope of i to be called later
		(function(i){
			$.Schedule(i, function() {
				$.GetContextPanel().FindChildTraverse('GGTimer').text = 8-i;
			});
		})(i);		
	}
}

function GGCalled(event) {
	$.Msg("GG Called...")

	var has_gg = false
	if (event.has_gg[1] == true || event.has_gg[2] == true)
		has_gg = true

	GenerateGGTopBar(event.ID, event.team, has_gg);
}

function CancelGG() {
	gg_state = false;
	$.GetContextPanel().FindChildTraverse('Root').RemoveClass("visible");
}

(function() {
	GameEvents.Subscribe("gg_called", GGCalled);
	GameEvents.Subscribe("gg_init_by_local", GGLocal);
})();
