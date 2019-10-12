var herolist = CustomNetTables.GetTableValue('hero_selection', 'herolist')
var GridCategories = FindDotaHudElement('GridCategories');
//	var total = herocard.GetChildCount();
var picked_heroes = [];
var same_selection = CustomNetTables.GetTableValue("game_options", "same_hero_pick");

//	$.Msg(herolist.customlist)
//	$.Msg(GridCategories)

function FindDotaHudElement(panel) {
	return $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse(panel);
}


function InitHeroSelection()  {
//	$.Msg(GridCategories.GetChildCount())
	var pick_screen_title = FindDotaHudElement('HeroSelectionText');
		var gamemode = CustomNetTables.GetTableValue("game_options", "gamemode");

	if (same_selection && same_selection.value == 1) {
		pick_screen_title.style.marginTop = "30px";
		pick_screen_title.style.height = "37px";
		pick_screen_title.style.fontSize = "30px";
		pick_screen_title.style.horizontalAlign = "left";
		pick_screen_title.style.opacity = "1";
		if (gamemode && gamemode[1] == 3)
			pick_screen_title.text = $.Localize("pick_screen_same_hero_title") + " (" + $.Localize("DOTA_Tooltip_modifier_frantic") + ")";
		else
			pick_screen_title.text = $.Localize("pick_screen_same_hero_title");
	} else {
		if (gamemode && gamemode[1] == 3)
			pick_screen_title.text = $.Localize("DOTA_Tooltip_modifier_frantic");
	}

	var i = 0;

	while (i < GridCategories.GetChildCount()) {
//		$.Msg(GridCategories.GetChild(i))
//		$.Msg(GridCategories.GetChild(i).FindChildTraverse("HeroList"))
//		$.Msg(GridCategories.GetChild(i).FindChildTraverse("HeroList").GetChildCount())

		for (var j = 0; j < GridCategories.GetChild(i).FindChildTraverse("HeroList").GetChildCount(); j++) {
			if (GridCategories.GetChild(i).FindChildTraverse("HeroList").GetChild(j)) {
				var hero_panel = GridCategories.GetChild(i).FindChildTraverse("HeroList").GetChild(j).GetChild(0).GetChild(0);
				
				if (herolist.imbalist["npc_dota_hero_" + hero_panel.heroname]) {
					hero_panel.GetParent().AddClass("IMBA_HeroCard");
					hero_panel.GetParent().style.boxShadow = "inset #FF7800aa 0 0 5px 0";
				} else if (herolist.customlist["npc_dota_hero_" + hero_panel.heroname]) {
					hero_panel.GetParent().AddClass("IMBA_HeroCard");
					hero_panel.GetParent().style.boxShadow = "inset purple 0 0 50px 0";
					hero_panel.style.backgroundImage = 'url("file://{images}/heroes/selection/npc_dota_hero_' + hero_panel.heroname + '.png")';
					hero_panel.style.backgroundSize = "100% 100%";
				}
			}
		}

		i++;
	}
}

function OnUpdateHeroSelection() {
/*
	picked_heroes = []

	for(var i = 0; i < 19; i++)
	{
		if (Game.GetPlayerInfo(i)) {
			$.Msg(Game.GetPlayerInfo(i).player_selected_hero);
			picked_heroes[i] = Game.GetPlayerInfo(i).player_selected_hero;
		}
	}

	$.Msg("Start hero picked update...")

	count = 0;

	for(var i = 0; i < total; i++)
	{
		UpdatePickedHeroes();
	}

	count = 0;

	if (Game.GetMapInfo().map_display_name == "imba_demo") {
		$.Msg(Game.GetPlayerInfo(0).player_selected_hero);
		GameEvents.SendCustomGameEventToServer("fix_newly_picked_hero", {
			hero : Game.GetPlayerInfo(0).player_selected_hero,
		});
	}
*/

	if (same_selection && same_selection.value == 1)
		$.Schedule(0.1, UpdatePickedHeroes)
}

/*
function OnUpdateHeroSelectionDirty() {
//	CheckForBannedHero();
}
*/

/*
function OnUpdateHeroSelectionRepeat() {
	OnUpdateHeroSelection();
	CheckForBannedHero();
//	$.Schedule(1.0, OnUpdateHeroSelection); // iteration last longer, find another way
}
*/

function UpdatePickedHeroes() {
/*
	var hero_image_panel;

	if (herocard.GetChild(count) != null) {
		hero_image_panel = herocard.GetChild(count).FindChildTraverse("HeroImage");
	}

	if (hero_image_panel != undefined) {
		for(var i = 0; i < picked_heroes.length; i++)
		{
			if (picked_heroes[i] == "npc_dota_hero_" + hero_image_panel.heroname) {
				if (hero_image_panel.GetParent()) {
					$.Msg(picked_heroes[i] + " Has been disabled!")
					hero_image_panel.GetParent().GetParent().FindChildTraverse("BannedOverlay").style.opacity = "0";
					hero_image_panel.GetParent().GetParent().AddClass("Unavailable")
					hero_image_panel.GetParent().GetParent().RemoveClass("Banned")
					hero_image_panel.GetParent().GetParent().SetPanelEvent("onmouseover", function(){});
					hero_image_panel.GetParent().GetParent().SetPanelEvent("onactivate", function(){});
					count++;
					return;
				}
			}
		}
	}

	count++;
*/

	// todo: rework to aim only picked heroes instead of every heroes
	var i = 0;

	while (i < GridCategories.GetChildCount()) {
//		$.Msg(GridCategories.GetChild(i))
//		$.Msg(GridCategories.GetChild(i).FindChildTraverse("HeroList"))
//		$.Msg(GridCategories.GetChild(i).FindChildTraverse("HeroList").GetChildCount())

		for (var j = 0; j < GridCategories.GetChild(i).FindChildTraverse("HeroList").GetChildCount(); j++) {
			if (GridCategories.GetChild(i).FindChildTraverse("HeroList").GetChild(j)) {
				var hero_panel = GridCategories.GetChild(i).FindChildTraverse("HeroList").GetChild(j);

				if (hero_panel.BHasClass("AlreadyPicked"))
					hero_panel.RemoveClass("AlreadyPicked")
				if (hero_panel.BHasClass("Unavailable"))
					hero_panel.RemoveClass("Unavailable")

			}
		}

		i++;
	}
}

function CheckForBannedHero() {
	var pick_button = FindDotaHudElement("LockInButton");

	if (pick_button) {
		var hero_tooltip = pick_button.FindChildrenWithClassTraverse("PickButtonHeroName")[0].text.toLowerCase();

		hero_tooltip = hero_tooltip.replace(" ", "_");

		if (hero_tooltip.search(" (imba)"))
			hero_tooltip = hero_tooltip.replace(" (imba)", "");

		for (hero in herolist.hotdisabledlist) {
			hero = hero.replace("npc_dota_hero_", "");
			if (hero_tooltip.search(hero) == 0) {
				pick_button.style.opacity = "0";
				return;
			} else {
				pick_button.style.opacity = "1";
			}
		}

		for (hero in picked_heroes) {
			hero = hero.replace("npc_dota_hero_", "");
			if (hero_tooltip.search(hero) == 0) {
				pick_button.style.opacity = "0";
				return;
			} else {
				pick_button.style.opacity = "1";
			}
		}
	}
}

function SetPickButtonAlwaysEnabled() {
	var lock_in_button = FindDotaHudElement("LockInButton");
//	if (lock_in_button.BHasClass("Activated"))
//		lock_in_button.RemoveClass("Activated");

	lock_in_button.style.saturation = "1.0";
	lock_in_button.style.brightness = "1.0";

//	$.Schedule(0.1, SetPickButtonEnabled)
}

(function() {
	var PreGame = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("PreGame")
	PreGame.style.opacity = "1";
	PreGame.style.transitionDuration = "0.0s";

	$.Schedule(1.0, InitHeroSelection);
//	$.Schedule(1.0, OnUpdateHeroSelection);

	if (same_selection && same_selection.value == 1) {
		$.Schedule(0.5, SetPickButtonAlwaysEnabled)
		$.Schedule(0.5, UpdatePickedHeroes)

		GameEvents.Subscribe("dota_player_update_hero_selection", OnUpdateHeroSelection);
	}

//	GameEvents.Subscribe("dota_player_hero_selection_dirty", OnUpdateHeroSelectionDirty);
})();
