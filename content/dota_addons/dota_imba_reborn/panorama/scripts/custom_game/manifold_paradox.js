// test for PA Manifold Paradox UI
var hide_panel = true;
var i = 3;

function UpdateTooltip(args) {
//	$.Msg(args)
//	$.Msg(args.victim)
//	$.Msg(hide_panel)
	i = 3;

	var query_panel = FindDotaHudElement("QueryUnit");

	if (args.victim_id != undefined) {
		query_panel.RemoveClass("Hidden");

		var gravestone_ui = query_panel.FindChildTraverse("pa_gravestone");
		gravestone_ui.style.visibility = "visible";

		gravestone_ui.FindChildTraverse("player").text = Players.GetPlayerName(args.victim_id);

		var hero_panel = gravestone_ui.FindChildTraverse("hero");
		hero_panel.style.visibility = "visible";
		hero_panel.style.marginTop = "55px";
		hero_panel.style.height = "40px";
		hero_panel.heroname = Entities.GetUnitName(args.victim);

		if (args.epitaph)
			gravestone_ui.FindChildTraverse("title").text = $.Localize("DOTA_PhantomAssassin_Gravestone_Epitaph_" + args.epitaph)
	}
}

function Countdown() {
//	$.Msg("i = " + i)
	i--;

	if (i < 0) {
		ClosePanel(FindDotaHudElement("QueryUnit"));
		hide_panel = true;
		i = 0;
	}

	$.Schedule(1.0, function(i){
		Countdown()
	});
}

function ClosePanel(panel) {
	if (!panel.BHasClass("Hidden"))
		panel.AddClass("Hidden");
}

(function() {
	Countdown();
	GameEvents.Subscribe("update_pa_arcana_tooltips", UpdateTooltip);
})();
