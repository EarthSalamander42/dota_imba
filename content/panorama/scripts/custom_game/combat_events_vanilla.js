var CombatEvents = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("ToastManager");

function SetBountyRuneGold(data) {
	$.Msg(data);
	var event_panel = CombatEvents.GetChild(CombatEvents.GetChildCount() - 1);

	if (event_panel && event_panel.BHasClass("event_dota_rune_pickup") && (!event_panel.gold_rune_set || Game.IsInToolsMode())) {
		$.Msg("Rune picked up!")

		// tools mode needs 
		if (Game.IsInToolsMode()) {
			if (event_panel.FindChildTraverse("additional_text")) {
				event_panel.FindChildTraverse("additional_text").DeleteAsync(0);
			}

			if (event_panel.FindChildTraverse("additional_tex2")) {
				event_panel.FindChildTraverse("additional_tex2").DeleteAsync(0);
			}

			if (event_panel.FindChildTraverse("gold_image")) {
				event_panel.FindChildTraverse("gold_image").DeleteAsync(0);
			}

			if (event_panel.FindChildTraverse("additional_container")) {
				event_panel.FindChildTraverse("additional_container").DeleteAsync(0);
			}
		}

		var container = $.CreatePanel('Panel', event_panel, 'additional_container');
		container.style.flowChildren = "right";
		container.style.backgroundColor = "#00000088";
		event_panel.MoveChildBefore(container, event_panel.FindChildTraverse("EventLabel"));

		var label = $.CreatePanel('Label', container, 'additional_text');
		label.AddClass("EventListLabel");
		label.text = " " + data.gold;
		label.style.backgroundColor = "none";
		label.style.paddingLeft = "0px";
		label.style.color = "gold";

		var image = $.CreatePanel('Label', container, 'gold_image');
		image.style.width =  "23px";
		image.style.height =  "23px";
		image.style.backgroundImage = 'url("s2r://panorama/images/hud/icon_gold_psd.vtex")';
		image.style.backgroundSize = "100%";
		image.style.marginRight = "5px";
		image.style.marginLeft = "4px";
		image.style.marginTop = "4px";

		var label2 = $.CreatePanel('Label', container, 'additional_text2');
		label2.AddClass("EventListLabel");
		label2.text = "each ";
		label2.style.backgroundColor = "none";
		label2.style.paddingLeft = "0px";

		event_panel.gold_rune_set = true;
	}
};

(function() {
	GameEvents.Subscribe('set_bounty_rune_gold', SetBountyRuneGold);
})();
