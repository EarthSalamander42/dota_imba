var GridCategories = FindDotaHudElement('GridCategories');
var herolist = CustomNetTables.GetTableValue('hero_selection', 'herolist');
//	var total = herocard.GetChildCount();
var picked_heroes = [];
var children_count = 0;

	// $.Msg(herolist.hotdisabledlist)
//	$.Msg(GridCategories)

function InitHeroSelection()  {
	// $.Msg("InitHeroSelection()")
	var pick_screen_title = FindDotaHudElement('HeroSelectionText');
	var gamemode = CustomNetTables.GetTableValue("game_options", "gamemode");
	if (gamemode) gamemode = gamemode["1"];
	var same_selection = CustomNetTables.GetTableValue("game_options", "same_hero_pick");

	if (same_selection && same_selection.value == 1) {
		$.Schedule(0.5, SetPickButtonAlwaysEnabled)
		$.Schedule(0.5, UpdatePickedHeroes)

		GameEvents.Subscribe("dota_player_update_hero_selection", OnUpdateHeroSelection);
	}

	if (gamemode && typeof(gamemode) == "string") {
		pick_screen_title.text = ($.Localize("#LobbySetting_GameMode") + ": " + $.Localize("#vote_gamemode_" + gamemode)).toUpperCase();
		pick_screen_title.style.marginTop = "30px";
		pick_screen_title.style.height = "37px";
		pick_screen_title.style.fontSize = "300px"; // This was originally 30px, but it was overlapping with the All Pick text; changing this to 300px seems extremely wrong, but it makes it aligned anyways?...
		pick_screen_title.style.horizontalAlign = "left";
		pick_screen_title.style.opacity = "1";
	}

	var i = 0;

	while (i < GridCategories.GetChildCount()) {
		var HeroListContainer = GridCategories.GetChild(i).FindChildTraverse("HeroList");
//		$.Msg(GridCategories.GetChild(i))
//		$.Msg(HeroListContainer)

		for (var j = 0; j < HeroListContainer.GetChildCount(); j++) {
			if (HeroListContainer.GetChild(j)) {
				var hero_panel = HeroListContainer.GetChild(j).GetChild(0).GetChild(0);

				if (HeroListContainer.GetChild(j).BHasClass("AllHeroChallenge"))
					HeroListContainer.GetChild(j).RemoveClass("AllHeroChallenge");

				if (hero_panel) {
					if (IsHeroDisabled("npc_dota_hero_" + hero_panel.heroname) == true) {
						hero_panel.GetParent().GetParent().FindChildTraverse("BannedOverlay").style.opacity = "1";
						hero_panel.GetParent().GetParent().AddClass("Banned");
						hero_panel.GetParent().GetParent().AddClass("Unavailable");
						// $.Msg("Add Unavailable class to " + hero_panel.heroname);
						hero_panel.GetParent().GetParent().SetPanelEvent("onmouseover", function(){});
						hero_panel.GetParent().GetParent().SetPanelEvent("onactivate", function(){});
					}

					if (herolist && herolist.imbalist["npc_dota_hero_" + hero_panel.heroname]) {
						hero_panel.style.boxShadow = "inset #FF7800aa 0px 0px 2px 2px";
						hero_panel.style.transitionDuration = '0.25s';
						hero_panel.style.transitionProperty = 'box-shadow';
					} else if (herolist && herolist.customlist["npc_dota_hero_" + hero_panel.heroname]) {
						hero_panel.style.boxShadow = "inset purple 0px 0px 2px 2px";
						hero_panel.style.transitionDuration = '0.25s';
						hero_panel.style.transitionProperty = 'box-shadow';

						hero_panel.style.backgroundImage = 'url("file://{images}/heroes/selection/npc_dota_hero_' + hero_panel.heroname + '.png")';
						hero_panel.style.backgroundSize = "100% 100%";
					}
				}
			}
		}

		i++;
	}
}

function IsHeroDisabled(sHeroName) {
	if (herolist && herolist.hotdisabledlist && typeof(herolist.hotdisabledlist) == "object") {
		for (var i in herolist.hotdisabledlist) {
			// $.Msg(herolist.hotdisabledlist[i] + " " + sHeroName);
			if (herolist.hotdisabledlist[i] && herolist.hotdisabledlist[i] == sHeroName)
				return true;
		}
	} else {
		// $.Msg("herolist.hotdisabledlist is not an object! " + typeof(herolist.hotdisabledlist));
	}

	return false;
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

	var same_selection = CustomNetTables.GetTableValue("game_options", "same_hero_pick");

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
		var HeroListContainer = GridCategories.GetChild(i).FindChildTraverse("HeroList");
//		$.Msg(GridCategories.GetChild(i))
//		$.Msg(HeroListContainer)
//		$.Msg(HeroListContainer.GetChildCount())

		for (var j = 0; j < HeroListContainer.GetChildCount(); j++) {
			if (HeroListContainer.GetChild(j)) {
				var hero_panel = HeroListContainer.GetChild(j);

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

		$.Msg(herolist.hotdisabledlist)

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

function SetIMBARandomButton() {
	var button = FindDotaHudElement("ReRandomButton");

	if (!button) {
		$.Schedule(0.03, SetIMBARandomButton);
	}

	var lock_button = FindDotaHudElement("LockInButton");

	if (lock_button) {
		var lock_label = lock_button.FindChildrenWithClassTraverse("PickButtonHeroName")[0];

		if (lock_label)
			lock_label.style.maxWidth = "150px";
			lock_label.style.maxHeight = "35px";
			lock_label.style.fontSize = "24px";
			lock_label.style.textOverflow = "shrink";
	}

	button.style.visibility = "visible";
	button.style.marginLeft = "12px";
	button.style.width = "93px";
	button.style.height = "93px";
	button.style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #7B4200 ), to( #9A5300 ) )";
	button.style.borderTop = "1px solid #B56100";
	button.style.borderLeft = "1px solid #B5610022";
	button.style.borderRight = "1px solid #B5610011";
	button.style.borderBottom = "1px solid #B5610033";
	button.style.padding = "8px 0px 0px 0px";

	button.SetPanelEvent("onmouseover", function() {
		$.DispatchEvent("UIShowTextTooltip", button, $.Localize("#imba_random_description"));
	})

	button.SetPanelEvent("onmouseout", function() {
		$.DispatchEvent("UIHideTextTooltip", button);
	})

	button.SetPanelEvent("onactivate", function() {
		button.style.visibility = "collapse";

		GameEvents.SendCustomGameEventToServer("imba_random", {
			iPlayerID : Game.GetLocalPlayerID(),
			bIMBA : true,
		});
	})

	var container = button.GetChild(0);

	container.style.flowChildren = "down";
	container.style.width = "100%";
	container.style.height = "100%";

	var image = container.GetChild(0);

	image.style.horizontalAlign = "center";
	image.style.washColor = "none";

	var label = container.GetChild(1);

	label.style.width = "100%";
	label.style.marginLeft = "0px";
	label.text = "IMBA-RANDOM";
	label.style.horizontalAlign = "center";
	label.style.textAlign = "center";
}

function GridChecker() {
	if (children_count != GridCategories.GetChildCount()) {
		children_count = GridCategories.GetChildCount();
		InitHeroSelection();
	}

	$.Schedule(0.03, GridChecker);
}

(function() {
	var PreGame = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("PreGame")
	PreGame.style.opacity = "1";
	PreGame.style.transitionDuration = "0.0s";

//	$.Schedule(1.0, OnUpdateHeroSelection);
//	SetIMBARandomButton();

	var clock_label = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("ClockLabel");
	clock_label.style.visibility = "visible";

	GridChecker();

//	GameEvents.Subscribe("dota_player_hero_selection_dirty", OnUpdateHeroSelectionDirty);
})();
