// test for PA Manifold Paradox UI
var hide_panel = {};

function UpdateTooltip(args) {
	$.Msg(args)
//	$.Msg(args.victim)
	$.Msg(hide_panel[Players.GetLocalPlayer()])

	if (args.victim_id != undefined) {
		hide_panel[Players.GetLocalPlayer()] = false;

		var query_panel = FindDotaHudElement("QueryUnit");
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
	} else {
		if (hide_panel[Players.GetLocalPlayer()] == false) {
			FindDotaHudElement("QueryUnit").AddClass("Hidden");
			hide_panel[Players.GetLocalPlayer()] = true;
		}
	}
}

(function() {
	GameEvents.Subscribe("update_pa_arcana_tooltips", UpdateTooltip);
})();
