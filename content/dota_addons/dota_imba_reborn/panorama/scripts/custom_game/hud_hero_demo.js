var toggle = false
function OnHeroSelectionPressed() {
	if (toggle == false) {
		$("#PickScreen").style.visibility = "visible";
		toggle = true;
		return;
	}

	$("#PickScreen").style.visibility = "collapse";
	toggle = false;
}

function OnHeroSelected(hero) {
	ToggleCheatMenu();

	GameEvents.SendCustomGameEventToServer('demo_select_hero', {
		hero: hero
	});
}

function ToggleCheatMenu() {
	if ($.GetContextPanel().BHasClass("Minimized")) {
		$.GetContextPanel().RemoveClass("Minimized");	
	} else {
		$.GetContextPanel().AddClass("Minimized");
		if (toggle == true) {
			toggle = false;
		}

		$("#PickScreen").style.visibility = "collapse";
	}

//	$.GetContextPanel().ToggleClass('Minimized')
}

(function () {
	if (Game.GetMapInfo().map_display_name != "imba_demo")
	$.GetContextPanel().DeleteAsync(0)

	var herolist = CustomNetTables.GetTableValue('hero_selection', 'herolist').herolist;

	Object.keys(herolist).sort().forEach(function (hero) {
		var new_hero = $.CreatePanel('Panel', $("#" + herolist[hero]), hero);
		new_hero.AddClass("HeroContainer")
		new_hero.group = 'HeroChoises';


		new_hero.SetPanelEvent('onactivate', function () { OnHeroSelected(hero); });

		var new_hero_image = $.CreatePanel('DOTAHeroImage', new_hero, '');
		new_hero_image.hittest = false;
		new_hero_image.heroname = hero;
	});
})();
