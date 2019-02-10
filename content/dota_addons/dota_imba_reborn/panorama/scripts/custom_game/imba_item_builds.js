// Dota IMBA Plus item builds generator

"use strict";

(function() {
	var ItemPanel = FindDotaHudElement("ItemBuild").FindChildTraverse("Categories");

	for (var i = 0; i < ItemPanel.GetChildCount(); i++) {
		var category = ItemPanel.GetChild(i).FindChildTraverse("ItemList");
		GenerateItemBuildForCategory(category, i);
	}
})();

function GenerateItemBuildForCategory(panel, index) {
	for (var i = 0; i < panel.GetChildCount(); i++) {
		var item = panel.GetChild(i);
		item.DeleteAsync(0);
	}

	// Placeholder, later will be json get request
/*
	var items = [
		items[0] = [
			"item_tango",
		],
		items[1] = [
			"item_imba_angelic_alliance",
			"item_imba_arcane_nexus",
		],
		items[2] = [
			"item_imba_black_queen_cape",
			"item_imba_jarnbjorn",
		],
		items[3] = [
			"item_imba_siege_cuirass",
			"item_imba_sogat_cuirass",
		],
		items[4] = [
			"item_imba_starfury",
		],
		items[5] = [
			"item_imba_ultimate_scepter_synth",
		]
	]
*/

	var items = [
		"item_tango",
	]

	$.Msg(panel)
	$.Msg(index)

	for (var i = 0; i < items.length; ++i) {
		var itemPanelName = "imbaplus_item_" + index + "_" + i;
		var itemPanel = panel.FindChild(itemPanelName);

//		$.Msg(itemPanel)
//		if (itemPanel === null) {
			// Needs DOTAItemImage to be able to load from flash3 images
			// (similar to those used for dota shop, hence reusing
			// existing resources)
			$.Msg("Create new item: " + items[i])
			itemPanel = $.CreatePanel("DOTAItemImage", panel, itemPanelName);
			itemPanel.AddClass("ItemShop")
			itemPanel.SetPanelEvent('onactivate', function() {BuyItem(items[i]);});
//		}

		if (items[i]) {
			itemPanel.itemname = items[i];
		} else {
			itemPanel.itemname = "";
		}
	}
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
