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
Array_BehaviorTooltips[DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_PASSIVE] = "Passive"
Array_BehaviorTooltips[DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_NO_TARGET] = "NoTarget"
Array_BehaviorTooltips[DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET] = "Target"
Array_BehaviorTooltips[DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT] = "Point"
Array_BehaviorTooltips[DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_CHANNELLED] = "Channeled"
Array_BehaviorTooltips[DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_TOGGLE] = "Toggle"
Array_BehaviorTooltips[DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_AUTOCAST] = "AutoCast"
Array_BehaviorTooltips[DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_AURA] = "Aura"

var Array_AbilityDamageType = [];
Array_AbilityDamageType[1] = "Physical"
Array_AbilityDamageType[2] = "Magical"
Array_AbilityDamageType[3] = "Pure"

// var DotaHud = GetDotaHud();
var DotaHud = $.GetContextPanel();

if (Game.IsInToolsMode()) {
	DotaHud.style.width = "450px";
	DotaHud.style.align = "center center";
}

var AbilityContents = DotaHud.FindChildrenWithClassTraverse("AbilityContents")[0];
var AbilityDetails = DotaHud.FindChildTraverse("AbilityDetails");
var AbilityName = DotaHud.FindChildTraverse("AbilityName");
var AbilityLevel = DotaHud.FindChildTraverse("AbilityLevel");
var CurrentAbilityManaCost = DotaHud.FindChildTraverse("CurrentAbilityManaCost");
var CurrentAbilityCooldown = DotaHud.FindChildTraverse("CurrentAbilityCooldown");
var AbilityCastType = DotaHud.FindChildTraverse("AbilityCastType");
var AbilityTargetType = DotaHud.FindChildTraverse("AbilityTargetType"); // Not setup yet!
var AbilityDamageType = DotaHud.FindChildTraverse("AbilityDamageType");
var AbilitySpellImmunityType = DotaHud.FindChildTraverse("AbilitySpellImmunityType"); // Not setup yet!
var AbilityAttributes = DotaHud.FindChildTraverse("AbilityAttributes");
var AbilityExtraAttributes = DotaHud.FindChildTraverse("AbilityExtraAttributes");
var AbilityCooldown = DotaHud.FindChildTraverse("AbilityCooldown");
var AbilityManaCost = DotaHud.FindChildTraverse("AbilityManaCost");
var AbilityLore = DotaHud.FindChildTraverse("AbilityLore");
var AbilityUpgradeLevel = DotaHud.FindChildTraverse("AbilityUpgradeLevel");

var ItemScepterDescription = DotaHud.FindChildTraverse("ItemScepterDescription");

InitTooltips();
$.Schedule(1.0, SetAbilityTooltips);
//OverrideAbilityTooltips();

function OverrideAbilityTooltips() {
	var ability_name = "lina_fiery_soul";
//	var tooltip = $.Localize( "DOTA_Tooltip_ability_" + ability_name + "_Description")
	var tooltip = $.Localize("DOTA_Tooltip_Ability_" + ability_name + "_Description")
	var Specials = GameUI.ReplaceDOTAAbilitySpecialValues(ability_name, tooltip, AbilityDetails)

	$.Msg(Specials);
}

function InitTooltips() {
	var i = 0;

	while (GetDotaHud().FindChildTraverse("Ability" + i) != null) {
		var ability = GetDotaHud().FindChildTraverse("Ability" + i);
		var ability_name = Abilities.GetAbilityName(Entities.GetAbility(Game.GetLocalPlayerInfo().player_selected_hero_entity_index, i));

		(function (ability, ability_name) {
			ability.SetPanelEvent("onmouseover", function () {
				$.DispatchEvent("DOTAHideAbilityTooltip", ability);
			})
			ability.SetPanelEvent("onmouseout", function () {
			})
		})(ability, ability_name);

		i++;
	}
}

function SetAbilityTooltips() {
	var ability_index = 0;
	var test_ability = Entities.GetAbility(Game.GetLocalPlayerInfo().player_selected_hero_entity_index, ability_index);
	var ability_name = Abilities.GetAbilityName(test_ability);
	$.Msg(ability_name)

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

	AbilityName.SetDialogVariable("name", $.Localize("DOTA_Tooltip_ability_" + ability_name));
	AbilityLevel.SetDialogVariable("level", Abilities.GetLevel(test_ability));

	if (Abilities.GetManaCost(test_ability) == 0)
		CurrentAbilityManaCost.style.visibility = "collapse";
	else {
		CurrentAbilityManaCost.style.visibility = "visible";
		CurrentAbilityManaCost.SetDialogVariable("current_manacost", Abilities.GetManaCost(test_ability));
	}

	CurrentAbilityCooldown.SetDialogVariable("current_cooldown", Abilities.GetCooldown(test_ability));
	AbilityCastType.SetDialogVariable("casttype", $.Localize("DOTA_ToolTip_Ability_" + Array_BehaviorTooltips[GetAbilityType(Abilities.GetBehavior(test_ability))]));

//	$.Msg(Abilities.GetAbilityTargetType(test_ability))
//	AbilityTargetType.SetDialogVariable("targettype", "");


	if (Abilities.GetAbilityDamageType(test_ability)) {
		AbilityDamageType.SetDialogVariable("damagetype", $.Localize("DOTA_ToolTip_Damage_" + Array_AbilityDamageType[Abilities.GetAbilityDamageType(test_ability)]));
		AbilityDamageType.style.visibility = "visible";
	} else
		AbilityDamageType.style.visibility = "collapse";

//	AbilitySpellImmunityType.SetDialogVariable("spellimmunity", "")

	var AbilityDescription = $.Localize("DOTA_Tooltip_Ability_" + ability_name + "_Description");


	var AbilityValues = CustomNetTables.GetTableValue("player_table", "tooltips_" + Game.GetLocalPlayerID())
	if (!AbilityValues) {
		$.Msg("ERROR: Missing ability values!")
		return;
	}

//	$.Msg(AbilityValues[ability_index])

//	var ability_special = AbilityDescription.split(/[%%]/).reverse();

	var AbilityExtraDescription = "";

	if (AbilityValues["specials"]) {
		for (var i in AbilityValues["specials"]) {
			if (AbilityValues["specials"][ability_index][i] && AbilityValues["specials"][ability_index][i][1]) {
				var special_key = AbilityValues["specials"][ability_index][i][1];
				var special_values = AbilityValues["specials"][ability_index][i][2].toString().split(" ");
				var special_value = special_values[Abilities.GetLevel(test_ability) - 1]

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

				var tooltip_string = "DOTA_Tooltip_Ability_" + ability_name.replace("imba_", "") + "_" + special_key;
				if ($.Localize(tooltip_string) != tooltip_string) {
					AbilityExtraDescription = AbilityExtraDescription + $.Localize(tooltip_string) + " " + special_values + "<br>";
				}
			}
		}
	}

	AbilityExtraDescription = AbilityExtraDescription.slice(0, -4);
	AbilityExtraAttributes.SetDialogVariable("extra_attributes", AbilityExtraDescription);

//	<span class="GameplayValues"><span class="GameplayVariable"><span class="GameplayVariable">400</span></span></span>.
	AbilityDescription = SetTooltipsValues(ability_name, AbilityDescription, AbilityAttributes, true);
//	$.Msg(AbilityDescription)

	var i = 1;
	while ($.Localize("DOTA_Tooltip_Ability_" + ability_name + "_Imbafication_" + i) != "DOTA_Tooltip_Ability_" + ability_name + "_Imbafication_" + i) {
//		$.Msg($.Localize("DOTA_Tooltip_Ability_" + ability_name + "_Imbafication_" + i))
		AbilityDescription = AbilityDescription + "<br><br>" + $.Localize("DOTA_Tooltip_Ability_" + ability_name + "_Imbafication_" + i);
		i++;
	}

	AbilityDescription = SetTooltipsValues(ability_name, AbilityDescription, AbilityAttributes, false);

/*
	// cleanup double % signs
	while (AbilityDescription.indexOf("%%") !== -1) {
		AbilityDescription = AbilityDescription.replace("%%", "%");
	}
*/

	AbilityAttributes.SetDialogVariable("attributes", AbilityDescription);

/*
	var i = 1;
	while ($.Localize("DOTA_Tooltip_Ability_" + ability_name + "_Note" + i) != "DOTA_Tooltip_Ability_" + ability_name + "_Note" + i) {
		AbilityExtraDescription = AbilityExtraDescription + "<br><br>" + $.Localize("DOTA_Tooltip_Ability_" + ability_name + "_Note" + i);
		i++;
	}
	AbilityExtraAttributes.SetDialogVariable("extra_attributes", $.Localize(AbilityExtraDescription));
*/

	if (AbilityValues) {	
		if (AbilityValues["cooldown"] && AbilityValues["cooldown"][ability_index]) {	
			var cd = AbilityValues["cooldown"][ability_index].toString().split(" ");

			for (var i in cd) {
				cd[i] = parseFloat(cd[i]);
			}

			cd = cd.join(" / ");

			if (cd != 0) {
				if (Abilities.GetLevel(test_ability) != 0) {
					cd = SetActiveValue(cd, Abilities.GetCooldown(test_ability));
				}

				AbilityCooldown.style.visibility = "visible";
				AbilityCooldown.SetDialogVariable("cooldown", cd);
			} else
				AbilityCooldown.style.visibility = "collapse";
		}

		if (AbilityValues["manacost"] && AbilityValues["manacost"][ability_index]) {
			var mana = AbilityValues["manacost"][ability_index].toString().split(" ");

			for (var i in mana) {
				mana[i] = parseFloat(mana[i]);
			}

			mana = mana.join(" / ");

			if (mana != 0) {
				if (Abilities.GetLevel(test_ability) != 0) {
					mana = SetActiveValue(mana, Abilities.GetManaCost(test_ability));
				}

				AbilityManaCost.style.visibility = "visible";
				AbilityManaCost.SetDialogVariable("manacost", mana);
			} else
				AbilityCooldown.style.visibility = "collapse";
		}
	}

	AbilityLore.SetDialogVariable("lore", $.Localize("DOTA_Tooltip_Ability_" + ability_name + "_Lore"));

	if (Abilities.GetLevel(test_ability) != Abilities.GetMaxLevel(test_ability)) {
		AbilityUpgradeLevel.SetDialogVariableInt("upgradelevel", Abilities.GetHeroLevelRequiredToUpgrade(test_ability))
		AbilityUpgradeLevel.style.visibility = "visible";
	} else {
		AbilityUpgradeLevel.style.visibility = "collapse";		
	}
}

function SetTooltipsValues(ability_name, tooltip, panel, bVanilla) {
	if (bVanilla == true)
		ability_name = ability_name.replace("imba_", "");

	return GameUI.ReplaceDOTAAbilitySpecialValues(ability_name, tooltip, panel);
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

function ClearTooltips() {
	AbilityDetails.AddClass("NoAbilityData");
}

// utils
function bit_band(iBehavior, iBitCheck) {
	return iBehavior & iBitCheck;
}

(function() {

//	GameEvents.Subscribe( "dota_player_update_selected_unit", RefreshUI );
});
