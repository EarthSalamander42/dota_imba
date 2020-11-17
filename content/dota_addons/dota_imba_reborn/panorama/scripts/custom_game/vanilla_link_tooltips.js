GameEvents.Subscribe('dota_player_update_selected_unit', InitTooltips);
GameEvents.Subscribe("server_tooltips_info", SetAbilityTooltips);

function GetDotaHud() {
	var p = $.GetContextPanel();
	try {
		while (true) {
			if (p.id === "Hud")
				return p;
			else
				p = p.GetParent();
		}
	} catch (e) {}
}

var Array_BehaviorTooltips = [];
Array_BehaviorTooltips[DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_PASSIVE] = "Passive";
Array_BehaviorTooltips[DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_NO_TARGET] = "NoTarget";
Array_BehaviorTooltips[DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET] = "Target";
Array_BehaviorTooltips[DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT] = "Point";
Array_BehaviorTooltips[DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_CHANNELLED] = "Channelled";
Array_BehaviorTooltips[DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_TOGGLE] = "Toggle";
Array_BehaviorTooltips[DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_AUTOCAST] = "AutoCast";
Array_BehaviorTooltips[DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_AURA] = "Aura";

var Array_AbilityDamageType = [];
Array_AbilityDamageType[1] = "Physical";
Array_AbilityDamageType[2] = "Magical";
Array_AbilityDamageType[4] = "Pure";

var Array_AbilityImmunityType = [];
Array_AbilityImmunityType[SPELL_IMMUNITY_TYPES.SPELL_IMMUNITY_NONE] = "No";
Array_AbilityImmunityType[SPELL_IMMUNITY_TYPES.SPELL_IMMUNITY_ALLIES_YES] = "Yes";
Array_AbilityImmunityType[SPELL_IMMUNITY_TYPES.SPELL_IMMUNITY_ALLIES_NO] = "No";
Array_AbilityImmunityType[SPELL_IMMUNITY_TYPES.SPELL_IMMUNITY_ENEMIES_YES] = "Yes";
Array_AbilityImmunityType[SPELL_IMMUNITY_TYPES.SPELL_IMMUNITY_ENEMIES_NO] = "No";
Array_AbilityImmunityType[SPELL_IMMUNITY_TYPES.SPELL_IMMUNITY_ALLIES_YES_ENEMIES_NO] = "AlliesYesEnemiesNo";

var Array_AbilityDispellableType = [];
Array_AbilityDispellableType["SPELL_DISPELLABLE_YES_STRONG"] = "Yes_Strong";
Array_AbilityDispellableType["SPELL_DISPELLABLE_YES"] = "Yes_Soft";
Array_AbilityDispellableType["SPELL_DISPELLABLE_NO"] = "No";
Array_AbilityDispellableType[4] = "Item_Yes_Strong";
Array_AbilityDispellableType[5] = "Item_Yes_Soft";

// var DotaHud = GetDotaHud();
var DotaHud = $.GetContextPanel();

var AbilitiesAndStatBranch = GetDotaHud().FindChildTraverse("AbilitiesAndStatBranch");

var AbilityDetails = DotaHud.FindChildTraverse("AbilityDetails");
var AbilityName = DotaHud.FindChildTraverse("AbilityName");
var AbilityLevel = DotaHud.FindChildTraverse("AbilityLevel");
var CurrentAbilityManaCost = DotaHud.FindChildTraverse("CurrentAbilityManaCost");
var CurrentAbilityCooldown = DotaHud.FindChildTraverse("CurrentAbilityCooldown");
var AbilityCastType = DotaHud.FindChildTraverse("AbilityCastType");
var AbilityTargetType = DotaHud.FindChildTraverse("AbilityTargetType"); // Not setup yet!
var AbilityDamageType = DotaHud.FindChildTraverse("AbilityDamageType");
var AbilitySpellImmunityType = DotaHud.FindChildTraverse("AbilitySpellImmunityType");
var AbilityDispelType = DotaHud.FindChildTraverse("AbilityDispelType");
var AbilityAttributes = DotaHud.FindChildTraverse("AbilityAttributes");
var AbilityExtraAttributes = DotaHud.FindChildTraverse("AbilityExtraAttributes");
var AbilityCooldown = DotaHud.FindChildTraverse("AbilityCooldown");
var AbilityManaCost = DotaHud.FindChildTraverse("AbilityManaCost");
var AbilityLore = DotaHud.FindChildTraverse("AbilityLore");
var AbilityUpgradeLevel = DotaHud.FindChildTraverse("AbilityUpgradeLevel");

if (Game.IsInToolsMode()) {
	DotaHud.style.width = "100%";
	DotaHud.style.height = "100%";
	AbilityDetails.AddClass("AbilityContentsCustom");
}

var ItemScepterDescription = DotaHud.FindChildTraverse("ItemScepterDescription");

// $.Schedule(1.0, SetAbilityTooltips);
// OverrideAbilityTooltips();

function OverrideAbilityTooltips() {
	var sAbilityName = "lina_fiery_soul";
//	var tooltip = $.Localize( "DOTA_Tooltip_ability_" + sAbilityName + "_Description")
	var tooltip = $.Localize("DOTA_Tooltip_Ability_" + sAbilityName + "_Description")
	var Specials = GameUI.ReplaceDOTAAbilitySpecialValues(sAbilityName, tooltip, AbilityDetails)

	$.Msg(Specials);
}

function InitTooltips() {
	var i = 0;

//	$.Msg("Init Tooltips")

		$.Schedule(0.03, function() {
			if (!AbilitiesAndStatBranch.BHasClass("npc_dota_hero_abaddon")) {
				$.Msg("Custom tooltips only work for Abaddon so far.")

				// Re-enable vanilla tooltips
				while (GetDotaHud().FindChildTraverse("Ability" + i) != null) {
					var ability = GetDotaHud().FindChildTraverse("Ability" + i);
					var ability_name = ability.FindChildTraverse("AbilityImage").abilityname;

					(function (ability, ability_name) {
						ability.SetPanelEvent("onmouseover", function () {
							$.DispatchEvent("DOTAShowAbilityTooltip", ability, ability_name);
						})
						ability.SetPanelEvent("onmouseout", function () {
							$.DispatchEvent("DOTAHideAbilityTooltip", ability);
						})
					})(ability, ability_name);

					i++;
				}
			}

			return;
		})

	$.Schedule(0.03, function() {
		while (GetDotaHud().FindChildTraverse("Ability" + i) != null) {
			var ability = GetDotaHud().FindChildTraverse("Ability" + i);

			(function (ability, i) {
				ability.SetPanelEvent("onmouseover", function () {
					CallTooltips(i);
				})
				ability.SetPanelEvent("onmouseout", function () {
					HideTooltips();
				})
			})(ability, i);

			i++;
		}
	});
}

function CallTooltips(i) {
	var hPanel = GetDotaHud().FindChildTraverse("Ability" + i);
	var sAbilityName = hPanel.FindChildTraverse("AbilityImage").abilityname;

	// if IMBA hero then
	$.DispatchEvent("DOTAHideAbilityTooltip", hPanel);

	GameEvents.SendCustomGameEventToServer("get_tooltips_info", {
		sAbilityName: sAbilityName,
		hPosition: hPanel.GetPositionWithinWindow(),
	})
}

function SetAbilityTooltips(keys) {
	var ability = Entities.GetAbilityByName(Game.GetLocalPlayerInfo().player_selected_hero_entity_index, keys.sAbilityName);
	$.Msg(keys.sAbilityName)

	// HasCooldown // ScepterUpgradable

	var bIsItem = false;

	if (bIsItem == false) {
		ItemScepterDescription.style.visibility = "collapse";

		if (!AbilityDetails.BHasClass("IsAbility"))
			AbilityDetails.AddClass("IsAbility");
	} else {
		ItemScepterDescription.style.visibility = "visible";
	}

	if (AbilityDetails.BHasClass("NoAbilityData"))
		AbilityDetails.RemoveClass("NoAbilityData");

	if (!AbilityDetails.BHasClass("TooltipContainer"))
		AbilityDetails.AddClass("TooltipContainer");

	AbilityName.SetDialogVariable("name", $.Localize("DOTA_Tooltip_ability_" + keys.sAbilityName));
	AbilityLevel.SetDialogVariable("level", Abilities.GetLevel(ability));

	if (Abilities.GetManaCost(ability) == 0)
		CurrentAbilityManaCost.style.visibility = "collapse";
	else {
		CurrentAbilityManaCost.style.visibility = "visible";
		CurrentAbilityManaCost.SetDialogVariable("current_manacost", Abilities.GetManaCost(ability));
	}

	CurrentAbilityCooldown.SetDialogVariable("current_cooldown", Abilities.GetCooldown(ability));
	AbilityCastType.SetDialogVariable("casttype", $.Localize("DOTA_ToolTip_Ability_" + Array_BehaviorTooltips[GetAbilityType(Abilities.GetBehavior(ability))]));

//	$.Msg(Abilities.GetAbilityTargetType(ability))
//	AbilityTargetType.SetDialogVariable("targettype", "");
	AbilityTargetType.style.visibility = "collapse";

	if (Abilities.GetAbilityDamageType(ability)) {
		AbilityDamageType.SetDialogVariable("damagetype", $.Localize("DOTA_ToolTip_Damage_" + Array_AbilityDamageType[Abilities.GetAbilityDamageType(ability)]));
		AbilityDamageType.style.visibility = "visible";
	} else
		AbilityDamageType.style.visibility = "collapse";

	if (keys["sSpellImmunity"]) {
		AbilitySpellImmunityType.SetDialogVariable("spellimmunity", $.Localize("DOTA_ToolTip_PiercesSpellImmunity_" + Array_AbilityImmunityType[GetImmunityType(keys["sSpellImmunity"])]))
		AbilitySpellImmunityType.style.visibility = "visible";
	} else {
		AbilitySpellImmunityType.style.visibility = "collapse";
	}

	if (keys["sSpellDispellable"] && !keys["sSpellDispellable"] == "SPELL_DISPELLABLE_NO") {
		AbilityDispelType.SetDialogVariable("dispeltype", $.Localize("DOTA_ToolTip_Dispellable_" + Array_AbilityDispellableType[keys["sSpellDispellable"]]))
		AbilityDispelType.style.visibility = "visible";
	} else {
		AbilityDispelType.style.visibility = "collapse";
	}

	var AbilityDescription_String = "DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Description";
	var AbilityDescription = $.Localize(AbilityDescription_String);

	if ($.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName.replace("imba_", "") + "_Description"))

//	var ability_special = AbilityDescription.split(/[%%]/).reverse();

	var AbilityExtraDescription = "";

	if (keys["sSpecial"]) {
		for (var i in keys["sSpecial"]) {
			if (keys["sSpecial"][i] && keys["sSpecial"][i][1]) {
				var special_key = keys["sSpecial"][i][1];
				var special_values = keys["sSpecial"][i][2].toString().split(" ");
				var special_value = special_values[Abilities.GetLevel(ability) - 1]

//				$.Msg(special_key)
//				$.Msg(special_values)
//				$.Msg(special_value)

				// Percentage checker
				if (AbilityDescription.indexOf("%" + special_key + "%%") !== -1) {
	//				$.Msg("Percentage value: " + special_key)
					special_values = special_values.join("% / ") + "%";
					special_values = special_values.replace(special_value + "%", '<span class="GameplayValues"><span class="GameplayVariable"><span class="GameplayVariable">' + special_value + '%</span></span></span> ')
				} else {
	//				$.Msg("Non Percentage value: " + special_key)
					special_values = special_values.join(" / ");
					special_values = special_values.replace(special_value, '<span class="GameplayValues"><span class="GameplayVariable"><span class="GameplayVariable">' + special_value + '</span></span></span>')
				}

				if (AbilityDescription.indexOf("%" + special_key + "%") !== -1) {
	//				$.Msg("Replace " + "%" + special_key + "%" + " with: " + special_values)

					// for some reason .replace is not working?
					AbilityDescription = AbilityDescription.replace("%" + special_key + "%", special_values);
				}

				var tooltip_string = "DOTA_Tooltip_Ability_" + keys.sAbilityName.replace("imba_", "") + "_" + special_key;
				if ($.Localize(tooltip_string) != tooltip_string) {
					AbilityExtraDescription = AbilityExtraDescription + $.Localize(tooltip_string) + " " + special_values + "<br>";
				}
			}
		}
	}

	$.Msg(AbilityDescription)

	AbilityExtraDescription = AbilityExtraDescription.slice(0, -4);

	AbilityExtraAttributes.SetDialogVariable("extra_attributes", AbilityExtraDescription);

//	<span class="GameplayValues"><span class="GameplayVariable"><span class="GameplayVariable">400</span></span></span>.
	if (AbilityDescription.indexOf("imba_") !== -1)
		AbilityDescription = SetTooltipsValues(keys.sAbilityName, AbilityDescription, AbilityAttributes, true);
//	$.Msg(AbilityDescription)

	var i = 1;
	while ($.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Imbafication_" + i) != "DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Imbafication_" + i) {
//		$.Msg($.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Imbafication_" + i))
		AbilityDescription = AbilityDescription + "<br><br>" + $.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Imbafication_" + i);
		i++;
	}

	AbilityDescription = SetTooltipsValues(keys.sAbilityName, AbilityDescription, AbilityAttributes, false);

/*
	// cleanup double % signs
	while (AbilityDescription.indexOf("%%") !== -1) {
		AbilityDescription = AbilityDescription.replace("%%", "%");
	}
*/

	AbilityAttributes.SetDialogVariable("attributes", AbilityDescription);

/*
	var i = 1;
	while ($.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Note" + i) != "DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Note" + i) {
		AbilityExtraDescription = AbilityExtraDescription + "<br><br>" + $.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Note" + i);
		i++;
	}
	AbilityExtraAttributes.SetDialogVariable("extra_attributes", $.Localize(AbilityExtraDescription));
*/

	if (keys) {	
		if (keys["iCooldown"] != undefined) {	
			var cd = keys["iCooldown"].toString().split(" ");

			for (var i in cd) {
				cd[i] = parseFloat(cd[i]);
			}

			cd = cd.join(" / ");

			if (cd != 0) {
				if (Abilities.GetLevel(ability) != 0) {
					cd = SetActiveValue(cd, Abilities.GetCooldown(ability));
				}

				AbilityCooldown.style.visibility = "visible";
				AbilityCooldown.SetDialogVariable("cooldown", cd);
			} else
				AbilityCooldown.style.visibility = "collapse";
		}

		if (keys["iManaCost"] != undefined) {
			var mana = keys["iManaCost"].toString().split(" ");

			for (var i in mana) {
				mana[i] = parseFloat(mana[i]);
			}

			mana = mana.join(" / ");

			if (mana != 0) {
				if (Abilities.GetLevel(ability) != 0) {
					mana = SetActiveValue(mana, Abilities.GetManaCost(ability));
				}

				AbilityManaCost.style.visibility = "visible";
				AbilityManaCost.SetDialogVariable("manacost", mana);
			} else
				AbilityManaCost.style.visibility = "collapse";
		}
	}

	var String_Lore = "DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Lore";
	var Lore = $.Localize(String_Lore);

	if (Lore != String_Lore) {
		AbilityLore.SetDialogVariable("lore", $.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Lore"));
		AbilityLore.style.visibility = "visible";
	} else {
		AbilityLore.style.visibility = "collapse";
	}

	if (Abilities.GetLevel(ability) != Abilities.GetMaxLevel(ability)) {
		AbilityUpgradeLevel.SetDialogVariableInt("upgradelevel", Abilities.GetHeroLevelRequiredToUpgrade(ability))
		AbilityUpgradeLevel.style.visibility = "visible";
	} else {
		AbilityUpgradeLevel.style.visibility = "collapse";		
	}

	$.Schedule(1/60, () => {
		SetTooltipsPosition(keys.hPosition);
		// repeat or else panel is not at the right position
		$.Schedule(1/60, () => {
			SetTooltipsPosition(keys.hPosition);
		});
	});

}

function SetTooltipsPosition(hPosition) {
	var position_x = hPosition["x"];
	var position_y = hPosition["y"];
	var offset_x = 0;
	var offset_y = 0;

//	$.Msg("Actual layout height: ", AbilityDetails.actuallayoutheight);

	// 1.77, 1.6, 1.33: 16/9, 16/10, 4/3
	var aspect_ratios = []
	aspect_ratios[1.8] = ["16/9", 90, 0];
	aspect_ratios[1.6] = ["16/10", 0, 0];
	aspect_ratios[1.3] = ["4/3", 0, 0];

	var aspect_ratio = aspect_ratios[(AbilityDetails.GetParent().actuallayoutwidth / AbilityDetails.GetParent().actuallayoutheight).toFixed(1)];

	if (aspect_ratio) {
//		$.Msg("Aspect Ratio: ", aspect_ratio[0]);

		offset_x = aspect_ratio[1];
		offset_y = aspect_ratio[2];
	}

	AbilityDetails.style.opacity = "1";

//	$.Msg("Screen size: ", AbilityDetails.GetParent().actuallayoutwidth, " / ", AbilityDetails.GetParent().actuallayoutheight)
//	$.Msg("Tooltip size:", AbilityDetails.actuallayoutwidth, " / ", AbilityDetails.actuallayoutheight)
//	$.Msg("Tooltip position: ", position_x, " / ", position_y)

	var full_x = offset_x + position_x + AbilityDetails.actuallayoutwidth;
	var full_y = offset_y + position_y + AbilityDetails.actuallayoutheight;

//	$.Msg("Off-screen width? ", full_x > AbilityDetails.GetParent().actuallayoutwidth, " / ", full_x, " / ", AbilityDetails.GetParent().actuallayoutwidth)
	if (full_x > AbilityDetails.GetParent().actuallayoutwidth)
		offset_x = -30 - AbilityDetails.actuallayoutwidth;

//	$.Msg("Off-screen height? ", full_y > AbilityDetails.GetParent().actuallayoutheight, " / ", full_y, " / ", AbilityDetails.GetParent().actuallayoutheight)
	if (full_y > AbilityDetails.GetParent().actuallayoutheight)
		offset_y = ((full_y) - (AbilityDetails.GetParent().actuallayoutheight)) * (-1) - 10; // -10 so it's not tied to the border of the screen

//	$.Msg("---------------------------------------------------------------------")

//	$.Msg("" + (position_x + offset_x) + "px " + (position_y + offset_y) + "px 0px")
	AbilityDetails.style.position = "" + (position_x + offset_x) + "px " + (position_y + offset_y) + "px 0px";
}

function HideTooltips() {
	$.Schedule(1/60, () => {
		AbilityDetails.style.opacity = "0";
	});
}

// utils
function SetTooltipsValues(sAbilityName, tooltip, panel, bVanilla) {
	if (bVanilla == true)
		sAbilityName = sAbilityName.replace("imba_", "");

	return GameUI.ReplaceDOTAAbilitySpecialValues(sAbilityName, tooltip, panel);
}

function SetActiveValue(values, active_value, bFloat) {
//	if (bFloat == true)
//		return values.replace(active_value + ".0", '<span class="GameplayValues"><span class="GameplayVariable"><span class="GameplayVariable">' + active_value + '.0</span></span></span>')
//	else
		return values.replace(active_value, '<span class="GameplayValues"><span class="GameplayVariable"><span class="GameplayVariable">' + active_value + '</span></span></span>')
}

function GetAbilityType(iBehavior) {
	for (var i in DOTA_ABILITY_BEHAVIOR) {
		if (Array_BehaviorTooltips[bit_band(iBehavior, DOTA_ABILITY_BEHAVIOR[i])])
			return DOTA_ABILITY_BEHAVIOR[i];
	}
}

function GetImmunityType(iEnum) {
	for (var i in SPELL_IMMUNITY_TYPES) {
		if (i == iEnum)
			return SPELL_IMMUNITY_TYPES[i];
	}	
}

function ClearTooltips() {
	AbilityDetails.AddClass("NoAbilityData");
}

// utils
function bit_band(iBehavior, iBitCheck) {
	return iBehavior & iBitCheck;
}
