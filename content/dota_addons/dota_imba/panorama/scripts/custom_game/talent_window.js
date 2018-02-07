"use strict";

var HUD_Elements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements")

function InitializeTalents(args) {
	var local_player = Players.GetLocalPlayer()
	var plyData = CustomNetTables.GetTableValue("player_table", Players.GetLocalPlayer());

	// width: 190, height: 47
	var i = 1

	for (i in args["1"]) {
		if (HUD_Elements.FindChildTraverse("Talent" + i)) {
			HUD_Elements.FindChildTraverse("Talent" + i).DeleteAsync(0)
		}
	}

	for (i in args["1"]) {
		var Talent = args["1"][i.toString()]
		Talent = Talent.replace("imba_", "")

		var TalentImage = $.CreatePanel("Panel", HUD_Elements.FindChildTraverse("Upgrade" + i), "HeroPreview")
		$.Msg("Talent linked: " + Talent)
		TalentImage.BLoadLayoutFromString('<root><Panel><Image id="' + "Talent" + i + '" src="raw://resource/flash3/images/spellicons/'+ Talent + '.png"/></Panel></root>', false, false);
		TalentImage.style.width = "48px"
		TalentImage.style.height = "48px"
		if (i == 2 || i == 4 || i == 6 || i == 8) {
			TalentImage.style.horizontalAlign = "right"

			for (var tbg of HUD_Elements.FindChildTraverse("Upgrade" + i).FindChildrenWithClassTraverse("StatBonusLabel")) {
				tbg.style.width = "145px"
				tbg.style.marginLeft = "0px"
				tbg.style.marginRight = "0px"
				tbg.style.textAlign = "left"
				tbg.style.fontSize = "14px"
			}
		} else {
			for (var tbg of HUD_Elements.FindChildTraverse("Upgrade" + i).FindChildrenWithClassTraverse("StatBonusLabel")) {
				tbg.style.width = "145px"
				tbg.style.marginLeft = "0px"
				tbg.style.marginRight = "10px"
				tbg.style.horizontalAlign = "right"
				tbg.style.textAlign = "right"
				tbg.style.fontSize = "14px"
			}
			// 190px
			HUD_Elements.FindChildTraverse("Upgrade" + i).style.width = "210px"
		}

//		var TalentContainer = HUD_Elements.FindChildTraverse("Upgrade" + i + "Container")
//		$.Msg(TalentContainer)
//		TalentContainer.style.height = "66px"
	}
}

(function () {
//	HUD_Elements.FindChildTraverse("StatBranchDrawer").style.height = "320px"
//	HUD_Elements.FindChildTraverse("StatBranchDrawer").style.marginBottom = "110px"

//	HUD_Elements.FindChildTraverse("DOTAStatBranch").style.height = "360px"

//	HUD_Elements.FindChildTraverse("StatBranchOuter").style.height = "280px"

//	HUD_Elements.FindChildTraverse("TalentDescriptions").style.height = "220px"

	for (var tbg of HUD_Elements.FindChildrenWithClassTraverse("StatBranchCenter")) {
		// 420px
		tbg.style.height = "460px"
	}

//	for (var tbg of HUD_Elements.FindChildrenWithClassTraverse("UpgradeContainer")) {
//		tbg.style.height = "61px"
//	}

//	for (var tbg of HUD_Elements.FindChildrenWithClassTraverse("LevelBG")) {
//		tbg.style.width = "64px"
//		tbg.style.height = "64px"
//	}

	GameEvents.Subscribe("init_talent_window", InitializeTalents);
})();
