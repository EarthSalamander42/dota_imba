"use strict";

(function() {
	var AbilityPanel = $("#AbilitiesImage");

	var abilities = [
		"imba_abaddon_over_channel",
		"imba_bounty_hunter_headhunter",
		"imba_centaur_thick_hide",
		"imba_crystal_maiden_arcane_dynamo",
		"imba_faceless_void_timelord",
		"imba_kunkka_ebb_and_flow",
		"imba_queenofpain_delightful_torment",
		"imba_scaldris_antipode",
		"imba_tiny_rolling_stone",
		"imba_ursa_territorial_hunter",
	]

	if (AbilityPanel) {
		for (var i = 0; i < abilities.length; ++i) {
			var abilityPanelName = "tutorial_ability_" + i;
			var abilityPanel = AbilityPanel.FindChild(abilityPanelName);

			if (abilityPanel === null) {
				// Needs DOTAAbilityImage to be able to load from flash3 images
				// (similar to those used for dota shop, hence reusing
				// existing resources)
				abilityPanel = $.CreatePanel("DOTAAbilityImage", AbilityPanel, abilityPanelName);
				abilityPanel.AddClass("AbilityIcon")
			}

			if (abilities[i]) {
				abilityPanel.abilityname = abilities[i];
			} else {
				abilityPanel.abilityname = "";
			}
		}
	}

	var ItemPanel = $("#ItemsImage");

	var items = [
		"item_imba_angelic_alliance",
		"item_imba_arcane_nexus",
		"item_imba_black_queen_cape",
		"item_imba_jarnbjorn",
		"item_imba_siege_cuirass",
		"item_imba_sogat_cuirass",
		"item_imba_starfury",
		"item_imba_ultimate_scepter_synth",
	]

	if (ItemPanel) {
		for (var i = 0; i < items.length; ++i) {
			var itemPanelName = "tutorial_item_" + i;
			var itemPanel = ItemPanel.FindChild(itemPanelName);

			if (itemPanel === null) {
				// Needs DOTAItemImage to be able to load from flash3 images
				// (similar to those used for dota shop, hence reusing
				// existing resources)
				itemPanel = $.CreatePanel("DOTAItemImage", ItemPanel, itemPanelName);
				itemPanel.AddClass("AbilityIcon")
			}

			if (items[i]) {
				itemPanel.itemname = items[i];
			} else {
				itemPanel.itemname = "";
			}
		}
	}
})();
