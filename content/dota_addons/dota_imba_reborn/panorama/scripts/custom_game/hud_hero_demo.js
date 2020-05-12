function ToggleEnemyHeroPicker() {
	$('#SelectAllyHeroContainer').SetHasClass('HeroPickerVisible', false)
	$('#SelectEnemyHeroContainer').ToggleClass('HeroPickerVisible');
}

function ToggleAllyHeroPicker() {
	$('#SelectEnemyHeroContainer').SetHasClass('HeroPickerVisible', false)
	$('#SelectAllyHeroContainer').ToggleClass('HeroPickerVisible');
}

function SpawnEnemyNewHero(nHeroID) {
	$('#SelectEnemyHeroContainer').RemoveClass('HeroPickerVisible');
	$.DispatchEvent('FireCustomGameEvent_Str', 'SpawnEnemyButtonPressed', String(nHeroID));
}

function SpawnAllyNewHero(nHeroID) {
	$('#SelectAllyHeroContainer').RemoveClass('HeroPickerVisible');
	$.DispatchEvent('FireCustomGameEvent_Str', 'SpawnAllyButtonPressed', String(nHeroID));
}

// ç‚¹å‡»æ§½ä½åˆ‡æ¢å¯é€‰ç‰©å“æ é—­åŒ…
function SelectSlot(EconItemSlot, SlotStorePanel) {
	return function () {
		Game.EmitSound('ui.books.pageturns');
		var StyleMenus = $.GetContextPanel().FindChildrenWithClassTraverse("EconItemStyleContents");
		var unit = Players.GetLocalPlayerPortraitUnit();
		var container = $("#UnitItemContainer" + unit.toString());
		for (var child of StyleMenus) {
			child.SetHasClass("Hidden", true);
		}

		if (EconItemSlot != null) {
			var EconItemSlotParent = EconItemSlot.GetParent();
			for (var child of EconItemSlotParent.Children()) {
				child.SetHasClass("Selected", false);
			}
			EconItemSlot.SetHasClass("Selected", true);
			if (container) {
				container.FindChildTraverse("Bundle").SetHasClass("SourceButtonDisabled", true);
				container.FindChildTraverse("Single").SetHasClass("SourceButtonDisabled", false);
			}
		} else {
			// ç‚¹å‡»é¢æ¿ï¼Œåˆ‡æ¢åˆ°æ†ç»‘åŒ…æ 
			var children = $.GetContextPanel().FindChildrenWithClassTraverse("Selected");
			for (var child of children) {
				if (child.BHasClass("EconItemSlot")) {
					child.SetHasClass("Selected", false);
				}
			}
			if (container) {
				container.FindChildTraverse("Bundle").SetHasClass("SourceButtonDisabled", false);
				container.FindChildTraverse("Single").SetHasClass("SourceButtonDisabled", true);
			}
		}

		var SlotStoreParent = SlotStorePanel.GetParent();
		for (var child of SlotStoreParent.Children()) {
			child.SetHasClass("Hidden", true);
		}
		SlotStorePanel.SetHasClass("Hidden", false);
	}
};

// åˆ‡æ¢é¥°å“é—­åŒ…
function SwitchWearable(itemDef, itemStyle) {
	if (!itemStyle) {
		itemStyle = 0;
	}
	return function () {
		$.Msg('SwitchWearable ', itemDef, ' ', itemStyle);
		var unit = Players.GetLocalPlayerPortraitUnit();
		GameEvents.SendCustomGameEventToServer("SwitchWearable", { "unit": unit, "itemDef": itemDef, "itemStyle": itemStyle });
	}
};
/*
// åˆ‡æ¢ä¿¡ä½¿é—­åŒ…
function SwitchCourier(itemDef, itemStyle, bFlying, bDire) {
	return function () {
		$.Msg('SwitchCourier ', itemDef, ' ', itemStyle, ' ', bFlying, ' ', bDire);

		// å¿…é¡»é‡æ–°è®¾ä¸€ä¸ªæ–°å˜é‡ï¼Œå¦åˆ™é—­åŒ…å°†ç»´æŠ¤å˜é‡
		var _itemDef = itemDef;
		var _itemStyle = itemStyle;
		var _bFlying = bFlying;
		var _bDire = bDire;

		var unit = Players.GetLocalPlayerPortraitUnit();
		var container = $("#UnitItemContainer" + unit.toString());
		if (container) {
			var CourierSelectorContainer = container.FindChildTraverse("CourierSelectorContainer");
			if (CourierSelectorContainer.bFlying && _bFlying === undefined) {
				_bFlying = CourierSelectorContainer.bFlying;
			}
		}

		if (!_itemStyle) {
			_itemStyle = 0;
		}
		if (!_bFlying) {
			_bFlying = false;
		}
		if (!_bDire) {
			_bDire = false;
		}

		SendEventToServerWithCallback(
			"SwitchCourier",
			{
				"unit": unit,
				"itemDef": _itemDef,
				"itemStyle": _itemStyle,
				"bFlying": _bFlying,
				'bDire': _bDire,
			},
			function (params) {
				Game.EmitSound('ui.courier_in_use');

				var slotName = "courier";
				if (container) {
					var CourierSelectorContainer = container.FindChildTraverse("CourierSelectorContainer");
					CourierSelectorContainer.itemDef = _itemDef;
					CourierSelectorContainer.itemStyle = _itemStyle;
					CourierSelectorContainer.bFlying = _bFlying;
					CourierSelectorContainer.bDire = _bDire;

					var TeamSelectorContainer = container.FindChildTraverse("TeamSelectorContainer");
					if (_bDire) {
						TeamSelectorContainer.SetHasClass("DireSelected", true);
					} else {
						TeamSelectorContainer.SetHasClass("DireSelected", false);
					}

					var FlySelectorContainer = container.FindChildTraverse("FlySelectorContainer");
					if (_bFlying) {
						FlySelectorContainer.SetHasClass("FlySelected", true);
					} else {
						FlySelectorContainer.SetHasClass("FlySelected", false);
					}

					var EquipContainer = container.FindChildTraverse("EquipItemContainer");
					var EconItemSlot = EquipContainer.FindChildTraverse(slotName);

					if (EconItemSlot) {
						var EconItem = GetEconItem(EconItemSlot);
						var StyleMenu = $("#" + EconItem.id + "StyleMenu");

						EconItem.DeleteAsync(0);
						if (StyleMenu) {
							StyleMenu.DeleteAsync(0);
						}

						var uid = GetUniqueID();
						var econItemText = '<DOTAEconItem id="' + uid + '" class="DisableInspect" itemdef="' + _itemDef + '" onload="SetEconItemButtons(\'' + uid + '\', \'' + _itemDef + '\', ' + _itemStyle + ')" />';
						EconItemSlot.BCreateChildren(econItemText);
					}
				}
			}
		);
	}
};

function SwitchCourierTeam(bDire) {
	var unit = Players.GetLocalPlayerPortraitUnit();
	var container = $("#UnitItemContainer" + unit.toString());
	if (container) {
		var CourierSelectorContainer = container.FindChildTraverse("CourierSelectorContainer");
		var itemDef = CourierSelectorContainer.itemDef;
		var itemStyle = CourierSelectorContainer.itemStyle;
		var bFlying = CourierSelectorContainer.bFlying;
		SwitchCourier(itemDef, itemStyle, bFlying, bDire)();
	}
}

function SwitchCourierFly(bFlying) {
	var unit = Players.GetLocalPlayerPortraitUnit();
	var container = $("#UnitItemContainer" + unit.toString());
	if (container) {
		var CourierSelectorContainer = container.FindChildTraverse("CourierSelectorContainer");
		var itemDef = CourierSelectorContainer.itemDef;
		var itemStyle = CourierSelectorContainer.itemStyle;
		var bDire = CourierSelectorContainer.bDire;
		SwitchCourier(itemDef, itemStyle, bFlying, bDire)();
	}
}

// åˆ‡æ¢å®ˆå«é—­åŒ…
function SwitchWard(itemDef, itemStyle) {
	return function () {
		$.Msg('SwitchWard ', itemDef, ' ', itemStyle);

		var unit = Players.GetLocalPlayerPortraitUnit();
		var container = $("#UnitItemContainer" + unit.toString());

		if (!itemStyle) {
			itemStyle = 0;
		}

		SendEventToServerWithCallback(
			"SwitchWard",
			{
				"unit": unit,
				"itemDef": itemDef,
				"itemStyle": itemStyle,
			},
			function (params) {
				Game.EmitSound('DOTA_Item.ObserverWard.Activate');

				var slotName = "ward";
				if (container) {
					var EquipContainer = container.FindChildTraverse("EquipItemContainer");
					var EconItemSlot = EquipContainer.FindChildTraverse(slotName);

					if (EconItemSlot) {
						var EconItem = GetEconItem(EconItemSlot);
						var StyleMenu = $("#" + EconItem.id + "StyleMenu");

						EconItem.DeleteAsync(0);
						if (StyleMenu) {
							StyleMenu.DeleteAsync(0);
						}

						var uid = GetUniqueID();
						var econItemText = '<DOTAEconItem id="' + uid + '" class="DisableInspect" itemdef="' + itemDef + '" onload="SetEconItemButtons(\'' + uid + '\', \'' + itemDef + '\', ' + itemStyle + ')" />';
						EconItemSlot.BCreateChildren(econItemText);
					}
				}
			}
		);
	}
};

function CreateSelectCosmeticsForUnit(unit) {
	var origin_unit = ID_Map[unit] || unit;
	$.Msg("CreateSelectCosmeticsForUnit", origin_unit, ' ', unit);
	var container = $.CreatePanel("Panel", $("#HeroInspectBackground"), "UnitItemContainer" + origin_unit.toString());
	container.BLoadLayoutSnippet("EconItemContainer");
	var EquipContainer = container.FindChildTraverse("EquipItemContainer");
	var AvailableItemsCarousel = container.FindChildTraverse("AvailableItemsCarousel");

	if (IsWearableUnit(unit)) {
		var Wearables = CustomNetTables.GetTableValue("hero_wearables", unit.toString());
		var AvailableItems = CustomNetTables.GetTableValue("hero_available_items", GetUnitName(unit));

		// åˆ›å»ºæ†ç»‘åŒ…å¯æ›´æ¢è£…å¤‡æ 
		if (AvailableItems && AvailableItems["bundles"]) {
			var Bundles = AvailableItems["bundles"];
			var BundlePanel = $.CreatePanel("DelayLoadPanel", AvailableItemsCarousel, "bundle");
			BundlePanel.AddClass("CarouselPage");
			for (var k in Bundles) {
				var storeItemDef = Bundles[k];
				var storeItemID = "StoreItem" + storeItemDef;
				var storeItemText = '<DOTAStoreItem id="' + storeItemID + '" itemdef="' + storeItemDef + '" onactivate="SwitchWearable(' + storeItemDef + ')()" />';
				BundlePanel.BCreateChildren(storeItemText);
				var StoreItem = BundlePanel.FindChildTraverse(storeItemID);

				// é¥°å“å›¾ç‰‡ä¼šæŒ¡ä½çˆ¶é¢æ¿çš„ç‚¹å‡»äº‹ä»¶ï¼Œä½†åˆéœ€è¦å®ƒçš„tooltipï¼Œä¸èƒ½å…³é—­hittest
				var ItemImage = StoreItem.FindChildTraverse("ItemImage");
				ItemImage.SetPanelEvent("onactivate", SwitchWearable(storeItemDef));
			}
			EquipContainer.SetPanelEvent("onactivate", SelectSlot(null, BundlePanel));
			var BundleButton = container.FindChildTraverse("Bundle");
			BundleButton.SetPanelEvent("onactivate", SelectSlot(null, BundlePanel));
		}

		var SlotArray = SortSlots(AvailableItems);
		for (var slotIndex = 0; slotIndex < SlotArray.length; slotIndex++) {
			var Slot = SlotArray[slotIndex];

			if (Slot.DisplayInLoadout == 0) {
				continue;
			}

			var slotName = Slot.SlotName;
			var EquipedItem = Wearables[slotName];
			if (!EquipedItem) {
				continue;
			}
			var equipedItemDef = EquipedItem["itemDef"];
			var equipedItemStyle = EquipedItem["style"];

			// åˆ›å»ºå•ä¸€æ§½ä½æ ¼
			var EconItemSlot = $.CreatePanel("Panel", EquipContainer, slotName);
			EconItemSlot.BLoadLayoutSnippet("EconItemSlot");

			var SlotLabel = EconItemSlot.FindChildTraverse("SlotName");
			SlotLabel.text = $.Localize(Slot.SlotText);

			var uid = GetUniqueID();
			var econItemText = '<DOTAEconItem id="' + uid + '" class="DisableInspect" itemdef="' + equipedItemDef
				+ '" onload="SetEconItemButtons(\'' + uid + '\', \'' + equipedItemDef + '\', ' + equipedItemStyle + ')"'
				+ ' oncontextmenu="ShowDetailButton(\'' + uid + '\', \'' + equipedItemDef + '\', ' + equipedItemStyle + ')" />';
			EconItemSlot.BCreateChildren(econItemText);

			// åˆ›å»ºè¯¥æ§½ä½å¯æ›´æ¢è£…å¤‡æ 
			var DelayLoadPanel = $.CreatePanel("DelayLoadPanel", AvailableItemsCarousel, slotName);
			DelayLoadPanel.AddClass("CarouselPage");
			for (var k in Slot["ItemDefs"]) {
				var storeItemDef = Slot["ItemDefs"][k];
				var storeItemID = "StoreItem" + storeItemDef;
				var storeItemText = '<DOTAStoreItem id="' + storeItemID + '" itemdef="' + storeItemDef + '" onactivate="SwitchWearable(' + storeItemDef + ')()" />';
				DelayLoadPanel.BCreateChildren(storeItemText);
				var StoreItem = DelayLoadPanel.FindChildTraverse(storeItemID);

				// é¥°å“å›¾ç‰‡ä¼šæŒ¡ä½çˆ¶é¢æ¿çš„ç‚¹å‡»äº‹ä»¶ï¼Œä½†åˆéœ€è¦é¼ æ ‡åœç•™æ—¶å®ƒçš„tooltipï¼Œä¸èƒ½å…³é—­hittest
				var ItemImage = StoreItem.FindChildTraverse("ItemImage");
				ItemImage.SetPanelEvent("onactivate", SwitchWearable(storeItemDef));
			}
			DelayLoadPanel.SetHasClass("Hidden", true);

			EconItemSlot.SetPanelEvent("onactivate", SelectSlot(EconItemSlot, DelayLoadPanel));
		}
	} else if (IsCourier(unit)) {
		var AvailableItems = CustomNetTables.GetTableValue("other_available_items", "courier");

		var slotName = "courier";
		// åˆ›å»ºå•ä¸€æ§½ä½æ ¼
		var EconItemSlot = $.CreatePanel("Panel", EquipContainer, slotName);
		EconItemSlot.BLoadLayoutSnippet("EconItemSlot");

		var SlotLabel = EconItemSlot.FindChildTraverse("SlotName");
		SlotLabel.text = $.Localize("DOTA_GlobalItems_Couriers");

		var uid = GetUniqueID();
		var equipedItemDef = "595";
		var equipedItemStyle = 0;
		var econItemText = '<DOTAEconItem id="' + uid + '" class="DisableInspect" itemdef="' + equipedItemDef
			+ '" onload="SetEconItemButtons(\'' + uid + '\', \'' + equipedItemDef + '\', ' + equipedItemStyle + ')"'
			+ ' oncontextmenu="ShowDetailButton(\'' + uid + '\', \'' + equipedItemDef + '\', ' + equipedItemStyle + ')" />';
		EconItemSlot.BCreateChildren(econItemText);

		// åˆ›å»ºé˜Ÿä¼å’Œé£žè¡Œé€‰æ‹©å™¨
		var CourierSelectorContainer = $.CreatePanel("Panel", EquipContainer, "CourierSelectorContainer");
		CourierSelectorContainer.BLoadLayoutSnippet("CourierSelectorContainer");
		CourierSelectorContainer.itemDef = equipedItemDef;
		CourierSelectorContainer.itemStyle = equipedItemStyle;
		CourierSelectorContainer.bFlying = false;
		CourierSelectorContainer.bDire = false;

		// åˆ›å»ºå¯æ›´æ¢è£…å¤‡æ 
		var DelayLoadPanel = $.CreatePanel("DelayLoadPanel", AvailableItemsCarousel, "courier");
		DelayLoadPanel.AddClass("CarouselPage");
		for (var storeItemDef in AvailableItems) {
			var storeItemID = "StoreItem" + storeItemDef;
			var storeItemText = '<DOTAStoreItem id="' + storeItemID + '" itemdef="' + storeItemDef + '" onactivate="SwitchCourier(' + storeItemDef + ')()" />';
			DelayLoadPanel.BCreateChildren(storeItemText);
			var StoreItem = DelayLoadPanel.FindChildTraverse(storeItemID);

			// é¥°å“å›¾ç‰‡ä¼šæŒ¡ä½çˆ¶é¢æ¿çš„ç‚¹å‡»äº‹ä»¶ï¼Œä½†åˆéœ€è¦é¼ æ ‡åœç•™æ—¶å®ƒçš„tooltipï¼Œä¸èƒ½å…³é—­hittest
			var ItemImage = StoreItem.FindChildTraverse("ItemImage");
			ItemImage.SetPanelEvent("onactivate", SwitchCourier(storeItemDef));
		}
	} else if (Entities.IsWard(unit)) {
		var AvailableItems = CustomNetTables.GetTableValue("other_available_items", "ward");

		var slotName = "ward";
		// åˆ›å»ºå•ä¸€æ§½ä½æ ¼
		var EconItemSlot = $.CreatePanel("Panel", EquipContainer, slotName);
		EconItemSlot.BLoadLayoutSnippet("EconItemSlot");

		var SlotLabel = EconItemSlot.FindChildTraverse("SlotName");
		SlotLabel.text = $.Localize("DOTA_GlobalItems_Wards");

		var uid = GetUniqueID();
		var equipedItemDef = "596";
		var equipedItemStyle = 0;
		var econItemText = '<DOTAEconItem id="' + uid + '" class="DisableInspect" itemdef="' + equipedItemDef
			+ '" onload="SetEconItemButtons(\'' + uid + '\', \'' + equipedItemDef + '\', ' + equipedItemStyle + ')"'
			+ ' oncontextmenu="ShowDetailButton(\'' + uid + '\', \'' + equipedItemDef + '\', ' + equipedItemStyle + ')" />';
		EconItemSlot.BCreateChildren(econItemText);

		// åˆ›å»ºå¯æ›´æ¢è£…å¤‡æ 
		var DelayLoadPanel = $.CreatePanel("DelayLoadPanel", AvailableItemsCarousel, "ward");
		DelayLoadPanel.AddClass("CarouselPage");
		for (var storeItemDef in AvailableItems) {
			var storeItemID = "StoreItem" + storeItemDef;
			var storeItemText = '<DOTAStoreItem id="' + storeItemID + '" itemdef="' + storeItemDef + '" onactivate="SwitchWard(' + storeItemDef + ')()" />';
			DelayLoadPanel.BCreateChildren(storeItemText);
			var StoreItem = DelayLoadPanel.FindChildTraverse(storeItemID);

			// é¥°å“å›¾ç‰‡ä¼šæŒ¡ä½çˆ¶é¢æ¿çš„ç‚¹å‡»äº‹ä»¶ï¼Œä½†åˆéœ€è¦é¼ æ ‡åœç•™æ—¶å®ƒçš„tooltipï¼Œä¸èƒ½å…³é—­hittest
			var ItemImage = StoreItem.FindChildTraverse("ItemImage");
			ItemImage.SetPanelEvent("onactivate", SwitchWard(storeItemDef));
		}
	} else {
		EquipContainer.SetHasClass("NotWearable", true);
	}
}
function SetEconItemButtons(econItemID, itemDef, itemStyle) {
	var EconItem = $("#" + econItemID);
	var EconItemSlot = EconItem.GetParent()
	var slotName = EconItemSlot.id
	var position = EconItemSlot.GetPositionWithinWindow();
	var x = position.x / EconItemSlot.actualuiscale_x
	var y = (position.y + EconItemSlot.actuallayoutheight) / EconItemSlot.actualuiscale_y;

	if (itemStyle === undefined) {
		itemStyle = 0;
	}
	var MultiStyle = EconItem.FindChildTraverse("MultiStyle");
	if (MultiStyle.visible) {
		var unit = Players.GetLocalPlayerPortraitUnit();
		var imageSrc = null;
		var AvailableStylesList = null
		if (IsWearableUnit(unit)) {
			var AvailableItems = CustomNetTables.GetTableValue("hero_available_items", GetUnitName(unit));
			AvailableStylesList = AvailableItems[slotName]["styles"][itemDef];
		} else if (IsCourier(unit)) {
			var AvailableItems = CustomNetTables.GetTableValue("other_available_items", "courier");
			AvailableStylesList = AvailableItems[itemDef]["styles"];
		} else if (Entities.IsWard(unit)) {
			var AvailableItems = CustomNetTables.GetTableValue("other_available_items", "ward");
			AvailableStylesList = AvailableItems[itemDef]["styles"];
		}

		if (AvailableStylesList
			&& AvailableStylesList[itemStyle.toString()]
			&& AvailableStylesList[itemStyle.toString()].icon_path) {
			imageSrc = "s2r://panorama/images/" + AvailableStylesList[itemStyle.toString()].icon_path + "_png.vtex";
		}

		var SelectStyle = MultiStyle.FindChildTraverse("MultiStyleSelectedStyle");
		var total = SelectStyle.text.split('/')[1];
		
		SelectStyle.text = (itemStyle + 1).toString() + "/" + total;

		var StyleMenu = $.CreatePanel("Panel", $.GetContextPanel(), econItemID + "StyleMenu");
		StyleMenu.BLoadLayoutSnippet("EconItemStyleContextMenu");

		var EconItemIcon = EconItem.FindChildTraverse("EconItemIcon");

		if (imageSrc) {
			EconItemIcon.SetImage(imageSrc);
		}

		StyleMenu.SetPositionInPixels(x, y, 0);

		var StylesList = StyleMenu.FindChildTraverse("StylesList");
		for (var iStyle = 0; iStyle < parseInt(total); iStyle++) {
			var StyleEntry = $.CreatePanel("Panel", StylesList, "");
			StyleEntry.BLoadLayoutSnippet("StyleEntry");
			if (iStyle == itemStyle) {
				StyleEntry.AddClass("Selected");
			} else {
				StyleEntry.AddClass("Available");
				if (IsCourier(unit)) {
					StyleEntry.SetPanelEvent("onactivate", SwitchCourier(itemDef, iStyle));
				} else if (Entities.IsWard(unit)) {
					StyleEntry.SetPanelEvent("onactivate", SwitchWard(itemDef, iStyle));
				} else {
					StyleEntry.SetPanelEvent("onactivate", SwitchWearable(itemDef, iStyle));
				}
			}
			if (AvailableStylesList
				&& AvailableStylesList[iStyle.toString()]
				&& AvailableStylesList[iStyle.toString()].name) {
				var StyleLabel = StyleEntry.FindChildTraverse("StyleLabel");
				StyleLabel.text = $.Localize(AvailableStylesList[iStyle.toString()].name)
			}
		}
		MultiStyle.SetPanelEvent("onactivate", ToggleStyleMenu(StyleMenu));
	}

	EconItem.SetPanelEvent("oncontextmenu", function () {
		var contextMenu = $.CreatePanel("ContextMenuScript", $.GetContextPanel(), "");
		contextMenu.AddClass("ContextMenu_NoArrow");
		contextMenu.AddClass("ContextMenu_NoBorder");
		contextMenu.GetContentsPanel().itemDef = itemDef;
		contextMenu.GetContentsPanel().itemStyle = itemStyle;
		contextMenu.GetContentsPanel().BLoadLayout("file://{resources}/layout/custom_game/econ_item_context_menu.xml", false, false);
		contextMenu.GetContentsPanel().SetFocus();
	})

	var TeamSelectorContainer = EconItemSlot.GetParent().FindChildTraverse("TeamSelectorContainer");
	if (TeamSelectorContainer) {
		if (EconItem.BHasClass("HasTeamSpecificViews")) {
			TeamSelectorContainer.SetHasClass("Hidden", false);
		} else {
			TeamSelectorContainer.SetHasClass("Hidden", true);
		}
	}
}
*/

function SortSlots(AvailableItems) {
	var SlotArray = [];
	for (var slotName in AvailableItems) {
		var Slot = AvailableItems[slotName];
		Slot.SlotName = slotName;
		var slotIndex = Slot.SlotIndex;
		if (slotIndex === undefined) {
			continue;
		}
		var i = 0
		for (var i = 0; i < SlotArray.length; i++) {
			if (slotIndex < SlotArray[i].SlotIndex) {
				break;
			}
		}
		SlotArray.splice(i, 0, Slot);

	}
	return SlotArray;
}
/*
function ToggleSelectCosmetics() {
	$('#SelectCosmeticsContainer').ToggleClass('CosmeticsContainerVisible');
	if (!$('#SelectCosmeticsContainer').BHasClass('CosmeticsContainerVisible')) {
		ResetCamera();
		var children = $("#HeroInspectBackground").Children();
		for (var child of children) {
			child.SetHasClass("Hidden", true);
		}
	} else {
		ZoomInCamera();
		var unit = Players.GetLocalPlayerPortraitUnit();
		var origin_unit = ID_Map[unit] || unit;

		var container = $("#UnitItemContainer" + origin_unit.toString());
		if (container === null) {
			CreateSelectCosmeticsForUnit(unit);
		} else {
			container.SetHasClass("Hidden", false);
		}

	}
}
*/
function ToggleStyleMenu(StyleMenu) {
	return function () {
		StyleMenu.ToggleClass("Hidden");
	}
}

function Taunt() {
	var unit = Players.GetLocalPlayerPortraitUnit();
	GameEvents.SendCustomGameEventToServer("Taunt", { "unit": unit });
}

function SelectAndLookUnit(unit) {
	if (Entities.IsValidEntity(unit)) {
		var position = Entities.GetAbsOrigin(unit);
		GameUI.SelectUnit(unit, false);
		if (!ZoomInMode) {
			GameUI.SetCameraTargetPosition(position, 0.5);
		} else {
			ZoomInCamera();
		}
	} else {
		$.Schedule(FRAME_TIME * 10, function () {
			SelectAndLookUnit(unit);
		})
	}
}

function AllyRemoved(data) {
	var unit = ID_Map[data.unit] || data.unit;
	var container = $("#UnitItemContainer" + unit.toString());
	if (container) {
		container.DeleteAsync(FRAME_TIME);
	}
	$("#Hero" + unit.toString()).DeleteAsync(FRAME_TIME);
}

function CopySelection() {
	var unit = Players.GetLocalPlayerPortraitUnit();
	GameEvents.SendCustomGameEventToServer("CopySelection", { "unit": unit });
}

function AllySpawned(data) {
	$.Msg(data)

	var unit = data.unit;
	if (Entities.IsValidEntity(unit)) {
		SelectAndLookUnit(unit);

		var HeroItemText = '<Panel id="Hero' + unit.toString() + '" class="HeroImageItem" onactivate="SelectAndLookUnit(' + unit + ')">' +
			'<DOTAHeroImage id="HeroImage" class="TopBarHeroImage" heroname="' + GetHeroName(unit) + '" heroimagestyle="landscape" />'
			+ '</Panel>';
		$("#HeroImageContainer").BCreateChildren(HeroItemText);
	} else {
		$.Schedule(FRAME_TIME * 10, function () {
			AllySpawned(data);
		})
	}
}

function GetEconItem(EconItemSlot) {
	var EconItem;
	for (var child of EconItemSlot.Children()) {
		if (child.paneltype == "DOTAEconItem") {
			EconItem = child;
		}
	}
	return EconItem
}
/*
function UpdateWearable(params) {
	// $.Msg("UpdateWearable ", params);
	Game.EmitSound('inventory.wear');
	
	var unit_id = params.unit;
	unit_id = ID_Map[unit_id] || unit_id;
	var itemDef = params.itemDef;
	var slotName = params.slotName;
	var itemStyle = params.itemStyle;

	var container = $("#UnitItemContainer" + unit_id.toString());

	if (container) {
		var EquipContainer = container.FindChildTraverse("EquipItemContainer");
		var EconItemSlot = EquipContainer.FindChildTraverse(slotName);

		if (EconItemSlot) {
			var EconItem = GetEconItem(EconItemSlot);
			var StyleMenu = $("#" + EconItem.id + "StyleMenu");

			EconItem.DeleteAsync(0);
			if (StyleMenu) {
				StyleMenu.DeleteAsync(0);
			}

			var uid = GetUniqueID();
			var econItemText = '<DOTAEconItem id="' + uid + '" class="DisableInspect" itemdef="' + itemDef + '" onload="SetEconItemButtons(\'' + uid + '\', \'' + itemDef + '\', ' + itemStyle + ')" />';
			EconItemSlot.BCreateChildren(econItemText);
		}
	}
}
*/
function RespawnWear(data) {
	$.Msg("RespawnWear ", data);
	var old_unit = data.old_unit;
	var new_unit = data.new_unit;
	var item = data.item;
	var bundle = data.bundle;

	ID_Map[new_unit] = old_unit;
	SelectAndLookUnit(new_unit);

	var HeroImagePanel = $("#Hero" + old_unit.toString());

	HeroImagePanel.SetPanelEvent("onactivate", function () {
		SelectAndLookUnit(new_unit);
	});
/*
	if (bundle) {
		for (var i in bundle) {
			var subItem = bundle[i];
			UpdateWearable(subItem);
		}
	} else {
		UpdateWearable(item);
	}
*/
}
/*
function OnSelectionChangeForCosmetics(unit, old_unit) {
	if ($('#SelectCosmeticsContainer').BHasClass('CosmeticsContainerVisible')) {
		if (old_unit) {
			var originID = ID_Map[old_unit] || old_unit;
			var CurrentCosmeticsContainer = $("#UnitItemContainer" + originID.toString());
			if (CurrentCosmeticsContainer) {
				CurrentCosmeticsContainer.SetHasClass("Hidden", true);
			}
		}

		var originID = ID_Map[unit] || unit;
		var CosmeticsContainer = $("#UnitItemContainer" + originID.toString());

		if (CosmeticsContainer === null) {
			CreateSelectCosmeticsForUnit(unit);
		} else {
			CosmeticsContainer.SetHasClass("Hidden", false);
		}
		ZoomInCamera();
	}
}
*/
function ShowDemoPanel() {
//	$.Msg("Enter Function ShowDemoPanel");
	$.GetContextPanel().FindChildTraverse('ControlPanel').AddClass("visible");
}

(function () {
	$.RegisterEventHandler('DOTAUIHeroPickerHeroSelected', $('#SelectEnemyHeroContainer'), SpawnEnemyNewHero);
	$.RegisterEventHandler('DOTAUIHeroPickerHeroSelected', $('#SelectAllyHeroContainer'), SpawnAllyNewHero);
//	GameEvents.Subscribe('UpdateWearable', UpdateWearable);
	GameEvents.Subscribe('AllySpawned', AllySpawned);
	GameEvents.Subscribe('AllyRemoved', AllyRemoved);
	GameEvents.Subscribe('RespawnWear', RespawnWear);
	
	GameEvents.Subscribe('ShowDemoPanel', ShowDemoPanel);

	ID_Map = {};

//	$('#SelectAllyHeroContainer').SetHasClass("HeroPickerVisible", true);

//	GetUniqueID = UniqueIDClosure();
//	RegisterSelectionChange(OnSelectionChangeForCosmetics);

})();
