// Dota IMBA Plus item builds generator

"use strict";

var SYSTEM_ENABLED = false;

// Panels def
var Shop;
var ItemBuild;
var Categories;
var GuideBrowser;
var GridUpgradeItems;

// Dota Plus choose build button
var dota_plus_button;
var dota_plus_selected_label;

var category_name = [
	"starting_items",
	"early_items",
	"late_items",
	"situational_items",
];

(function() {
	Shop = GameUI.Utils.FindDotaHudElement("shop");
	ItemBuild = Shop.FindChildTraverse("ItemBuild");
	Categories = Shop.FindChildTraverse("Categories");
	GuideBrowser = GameUI.Utils.FindDotaHudElement("GuideBrowser");
	GridUpgradeItems = GameUI.Utils.FindDotaHudElement("GridUpgradeItems");

	GridUpgradeItems.style.overflow = "squish scroll";

	if (SYSTEM_ENABLED == false)
		return;

	$.Msg(GuideBrowser.FindChildTraverse("GuideList").GetChildCount())

	ItemBuild.GetChild(0).style.visibility = "visible";
//	GuideBrowser.FindChildTraverse("GuideList").GetChild(0).style.visibility = "visible"


	// panel is generated only if you click item build browse button
//	GuideBrowser.FindChildTraverse("GuideList").GetChild(0).FindChildTraverse("GuideEntryTitles").GetChild(1).FindChildTraverse("GuideEntrySubtitle").text = "Dota IMBA (Frostrose Studio)";

	// Dota Plus choose build button
//	dota_plus_button = GuideBrowser.FindChildTraverse("GuideList").GetChild(0).FindChildTraverse("GuideEntryTitles").GetChild(2).GetChild(0);
//	dota_plus_selected_label = GuideBrowser.FindChildTraverse("GuideList").GetChild(0).FindChildTraverse("GuideEntryTitles").GetChild(2).GetChild(1);

	// start at 1 to ignore dota plus panel
	for (var i = 1; i < GuideBrowser.FindChildTraverse("GuideList").GetChildCount(); i++) {
		var child = GuideBrowser.FindChildTraverse("GuideList").GetChild(i);

		child.style.visibility = "collapse";
	}

	var hero_name = Game.GetLocalPlayerInfo().player_selected_hero;
	$.Msg(hero_name)

	// todo: http request to know if imba plus item build is enabled for this hero, if yes send item build
	var item_build = undefined;
//	var item_build = http_result;

	var imba_plus = true;

	if (imba_plus == true) {
//		dota_plus_button.style.visibility = "collapse";
//		dota_plus_selected_label.style.visibility = "visible";
	} else {
		(function (dota_plus_button, hero_name) {
			dota_plus_button.SetPanelEvent("onactivate", function() {
				// todo: http request to gather best item build for selected hero
			});
		})(dota_plus_button, hero_name);
	}

	var item_build = {
		"itembuild": {
			"starting_items": { // pre 00:00
				"item_tango" : 2,
				"item_branches" : 2,
				"item_ward_observer" : 1,
				"item_enchanted_mango" : 2,
				"item_quelling_blade" : 1,
			},
			"early_items": { // 00:00 - 10:00
				"item_imba_hand_of_midas" : 1,
			},
			"late_items": { // 10:00 - xx:xx
				"item_imba_heart" : 1,
			},
			"situational_items": { // ???
				"item_imba_heart" : 1,
			},
		}
	};

	if (item_build) {
		GenerateItemBuild(item_build["itembuild"]);
	}
})();

function GenerateItemBuild(items) {
	var remove_useless_categories = true;

	for (var i = 0; i < Categories.GetChildCount(); i++) {
		var category = Categories.GetChild(i);
		var item_category = Categories.GetChild(i).FindChildTraverse("ItemList");

		if (category.BHasClass("StartingItems")) {
			remove_useless_categories = false;
		}

		if (remove_useless_categories) {
			category.DeleteAsync(0);
		}

		var categories_items = items[category_name[i]];

		$.Msg(category)
		$.Msg(category.FindChildTraverse("ItemList").GetChildCount())

		// remove existing items
		for (var i = 0; i < category.FindChildTraverse("ItemList").GetChildCount(); i++) {
			var item = category.FindChildTraverse("ItemList").GetChild(i);
			item.DeleteAsync(0);
		}

		$.Msg(categories_items)

		if (categories_items) {
			for (var j in categories_items) {
				var item_name = j;
				var item_count = categories_items[j];

				var itemPanel = $.CreatePanel("DOTAShopItem", category.FindChildTraverse("ItemList"), item_name);
//				itemPanel.AddClass("ItemShop") // NOT FUCKING WORKING, FUCK, FUCK YOU, LITERALLY.
				itemPanel.AddClass("MainShopItem");
				itemPanel.AddClass("CanPurchase");
				itemPanel.RemoveClass("Popular");
				itemPanel.FindChildTraverse("PopularOverlay").style.visibility = "collapse";
				itemPanel.FindChildTraverse("CanPurchaseOverlay").style.visibility = "collapse";

				itemPanel.style.width = "42px";
				itemPanel.style.height = "width-percentage( 72.7% )";
				itemPanel.style.marginTop = "3px";
				itemPanel.style.marginBottom = "3px";
				itemPanel.style.marginRight = "6px";
				itemPanel.style.marginLeft = "4px";

				itemPanel.GetChild(0).itemname = item_name;

				(function (itemPanel, item_name) {
					itemPanel.SetPanelEvent("onmouseover", function () {
						$.DispatchEvent("DOTAShowAbilityTooltip", itemPanel, item_name);
					})
					itemPanel.SetPanelEvent("onmouseout", function () {
						$.DispatchEvent("DOTAHideAbilityTooltip", itemPanel);
					})

					itemPanel.SetPanelEvent('oncontextmenu', function() {
						BuyItem(item_name);
					});
				})(itemPanel, item_name);
			}
		}
	}
}

UpdateShopItems();

function UpdateShopItems() {
	for (var i = 0; i < Categories.GetChildCount(); i++) {
		var category = Categories.GetChild(i);
		var item_category = Categories.GetChild(i).FindChildTraverse("ItemList");

		// remove existing items
		for (var i = 0; i < category.FindChildTraverse("ItemList").GetChildCount(); i++) {
			var item = category.FindChildTraverse("ItemList").GetChild(i);

			if (item.BHasClass("Popular")) {
				item.AddClass("CanPurchase")
				$.Msg("Item is popular!")
			}
		}
	}

	$.Schedule(1.0, UpdateShopItems);
}

// Credits to Guarding Athena's Github: https://github.com/BigCiba/GuardingAthena/blob/becca55168063b08decc81bab8c0c32ef987d5b2/content/dota_addons/guarding_athena/panorama/scripts/custom_game/custom_hud/shop.js
function BuyItem(name) {
	var m_IsBuyEnable = false;
	var gold = Players.GetGold(Game.GetLocalPlayerID());

	if(gold >= Items.GetCost(item_ent_id)) {
		m_IsBuyEnable = true;
	}

	if(!m_IsBuyEnable) {
		Game.EmitSound("General.Cancel");
		return;
	}

	var unit = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());

	if( unit != -1) {
		Game.EmitSound( "General.Buy" );
		GameEvents.SendCustomGameEventToServer( "UI_BuyItem", { 'entindex':unit, 'itemName':name, 'cost':cost, 'type':type, 'cooldown':refreshTime} );
	}
	else
	{
		Game.EmitSound( "ui_rollover_micro" );
	}
}
