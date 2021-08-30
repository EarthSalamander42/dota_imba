(function() {
//	$.Msg("Vanilla Link Tooltips initialization...")
	OnThink();

	GameEvents.Subscribe('dota_player_update_selected_unit', InitTooltips);
	GameEvents.Subscribe('vanillafier_init_tooltips_first_spawn', InitTooltips);
	GameEvents.Subscribe("dota_player_hero_selection_dirty", InitTooltips);
	GameEvents.Subscribe("server_tooltips_info", SetAbilityTooltips);
})();

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
var AbilityExtraDescription = DotaHud.FindChildTraverse("AbilityExtraDescription");
var AbilityExtraAttributes = DotaHud.FindChildTraverse("AbilityExtraAttributes");
var AbilityCooldown = DotaHud.FindChildTraverse("AbilityCooldown");
var AbilityManaCost = DotaHud.FindChildTraverse("AbilityManaCost");
var AbilityLore = DotaHud.FindChildTraverse("AbilityLore");
var AbilityUpgradeLevel = DotaHud.FindChildTraverse("AbilityUpgradeLevel");

DotaHud.style.width = "100%";
DotaHud.style.height = "100%";
AbilityLore.style.width = "370px";
AbilityDetails.AddClass("AbilityContentsCustom");

var ItemScepterDescription = DotaHud.FindChildTraverse("ItemScepterDescription");

// $.Schedule(1.0, SetAbilityTooltips);
// OverrideAbilityTooltips();

function OverrideAbilityTooltips(sAbilityName) {
//	var tooltip = $.Localize( "DOTA_Tooltip_ability_" + sAbilityName + "_Description")
	var tooltip = $.Localize("DOTA_Tooltip_Ability_" + sAbilityName + "_Description")
	var Specials = GameUI.ReplaceDOTAAbilitySpecialValues(sAbilityName, tooltip, AbilityDetails)

//	$.Msg("Override Ability Tooltips")
//	$.Msg(Specials);
}

var eligible_heroes = [
	"npc_dota_hero_abaddon",
	"npc_dota_hero_alchemist",
	"npc_dota_hero_earth_spirit",
	"npc_dota_hero_mars",
];

function InitTooltips() {
//	$.Msg("Init Tooltips")

//	$.Msg("Game State: " + Game.GetState());

	for (var i = 0; i < 24; i++) {
		var ability = GetDotaHud().FindChildTraverse("Ability" + i);

		if (Game.GetState() <= 5) {
			ability = GetDotaHud().FindChildTraverse("HeroInspect").FindChildTraverse("HeroAbilities").GetChild(i);
		}

		if (ability) {
			var ability_button = ability.FindChildTraverse("AbilityButton");
			var ability_name = undefined;

			if (Game.GetState() <= 5) {
				ability_button = GetDotaHud().FindChildTraverse("HeroInspect").FindChildTraverse("HeroAbilities").GetChild(i);

				if (ability_button)
					ability_name = ability_button.abilityname;
			}

			if (ability && ability_button && ability_button.paneltype != "Panel") {
//				$.Msg(ability_name);

				(function (ability, ability_button, i, ability_name) {
					ability_button.SetPanelEvent("onmouseover", function() {
						RequestUnitTooltips(i, ability_name);
					})

					ability_button.SetPanelEvent("onmouseout", function() {
						HideTooltips();
					})

					if (ability.FindChildTraverse("LevelUpTab")) {
						ability.FindChildTraverse("LevelUpTab").SetPanelEvent("onmouseover", function() {
//							RequestUnitTooltips(i, ability_name);
						});

						ability.FindChildTraverse("LevelUpTab").SetPanelEvent("onmouseout", function() {
//							HideTooltips();
						});
					}
				})(ability, ability_button, i, ability_name);
			}
		}
	}
}

function RequestUnitTooltips(i, sAbilityName) {
//	$.Msg("RequestUnitTooltips: ", i, " / ", sAbilityName);
	var hPanel = GetDotaHud().FindChildTraverse("Ability" + i);
	var selected_entities = Players.GetSelectedEntities(Game.GetLocalPlayerID());

	if (!sAbilityName) {
		sAbilityName = hPanel.FindChildTraverse("AbilityImage").abilityname;
	}

	GameEvents.SendCustomGameEventToServer("get_tooltips_info", {
		sAbilityName: sAbilityName,
		iAbility: i,
		iSelectedEntIndex: selected_entities[0],
	})
}

function SetAbilityTooltips(keys) {
//	$.Msg(keys)

	var hero = Players.GetSelectedEntities(Game.GetLocalPlayerID());
	if (hero && hero[0])
		hero = hero[0];
	if (typeof(hero) == "object")
		hero = undefined;

	var ability = undefined;
	var ability_mana_cost = 0;
	var ability_cooldown = 0;
	var ability_level = 0;
	var ability_max_level = keys.iMaxLevel;

	if (hero && Entities.GetAbilityByName(hero, keys.sAbilityName)) {
		ability = Entities.GetAbilityByName(hero, keys.sAbilityName);;
	}

	if (ability) {
		ability_level = Abilities.GetLevel(ability);
	}

	if (ability && ability_level != 0 && ability_level != -1) {
		ability_mana_cost = keys.iManaCost[ability_level];
		ability_cooldown = keys.iCooldown[ability_level];

		AbilityLevel.SetDialogVariable("level", ability_level);
		AbilityLevel.style.visibility = "visible";
	} else {
		AbilityLevel.style.visibility = "collapse";		
	}

	// HasCooldown // ScepterUpgradable
	var bIsItem = false;

	if (bIsItem == false) {
		if (ItemScepterDescription)
			ItemScepterDescription.style.visibility = "collapse";

		if (!AbilityDetails.BHasClass("IsAbility"))
			AbilityDetails.AddClass("IsAbility");
	} else {
		if (ItemScepterDescription)
			ItemScepterDescription.style.visibility = "visible";
	}

	if (AbilityDetails.BHasClass("NoAbilityData"))
		AbilityDetails.RemoveClass("NoAbilityData");

	if (!AbilityDetails.BHasClass("TooltipContainer"))
		AbilityDetails.AddClass("TooltipContainer");


	var AbilityName_String = "DOTA_Tooltip_Ability_" + keys.sAbilityName;
	var AbilityNameText = $.Localize(AbilityName_String);

	if (AbilityName_String == AbilityNameText) {
		AbilityName.SetDialogVariable("name", $.Localize("DOTA_Tooltip_ability_" + keys.sAbilityName.replace("imba_", "")));
	} else {
		AbilityName.SetDialogVariable("name", $.Localize("DOTA_Tooltip_ability_" + keys.sAbilityName));
	}

	if (ability_mana_cost == 0)
		CurrentAbilityManaCost.style.visibility = "collapse";
	else {
		CurrentAbilityManaCost.style.visibility = "visible";

		var manacosts = Object.values(keys["iManaCost"]);
		var mana_level = Math.min(ability_level, manacosts.length);
		var active_mana = keys["iManaCost"][mana_level];

		if (mana_level != 0)
			CurrentAbilityManaCost.SetDialogVariable("current_manacost", active_mana);
		else
			CurrentAbilityManaCost.style.visibility = "collapse";
	}

	if (ability_cooldown == 0) {
		CurrentAbilityCooldown.style.visibility = "collapse";
	} else {
		CurrentAbilityCooldown.style.visibility = "visible";

		var cooldowns = Object.values(keys["iCooldown"]);
		var cd_level = Math.min(ability_level, cooldowns.length)
		var active_cd = keys["iCooldown"][cd_level];

		if (isFloat(active_cd))
			active_cd = active_cd.toFixed(1);

		if (cd_level != 0)
			CurrentAbilityCooldown.SetDialogVariable("current_cooldown", active_cd);
		else
			CurrentAbilityCooldown.style.visibility = "collapse";
	}

	AbilityCastType.SetDialogVariable("casttype", $.Localize("DOTA_ToolTip_Ability_" + Array_BehaviorTooltips[GetAbilityType(keys.iBehavior)]));

//	$.Msg(Abilities.GetAbilityTargetType(ability))
//	AbilityTargetType.SetDialogVariable("targettype", "");
	AbilityTargetType.style.visibility = "collapse";

	if (keys.iDamageType) {
		AbilityDamageType.SetDialogVariable("damagetype", $.Localize("DOTA_ToolTip_Damage_" + keys.iDamageType.replace("DAMAGE_TYPE_", "")));
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
	var Imba_description = true;

	if (AbilityDescription_String == AbilityDescription) {
		AbilityDescription = $.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName.replace("imba_", "") + "_Description");
		Imba_description = false;
	}

	// set newline to supported format
	AbilityDescription = SetHTMLNewLine(AbilityDescription);

	var i = 1;

//	$.Msg($.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Imbafication_" + i))
	while ($.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Imbafication_" + i) != "DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Imbafication_" + i) {
//		$.Msg($.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Imbafication_" + i))
		AbilityDescription = AbilityDescription + "<br><br>" + $.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Imbafication_" + i);
		i++;
	}

//	var ability_special = AbilityDescription.split(/[%%]/).reverse();

//	$.Msg(AbilityDescription)

	var AbilityExtraAttributes_Text = "";

	// Set IMBA KV in description
//	$.Msg(keys["sSpecial"])
	if (keys["sSpecial"]) {
		for (var i in keys["sSpecial"]) {
			if (keys["sSpecial"][i] && keys["sSpecial"][i][1]) {
				var special_key = keys["sSpecial"][i][1];

				// Turn weird values with 10 decimals into 2 decimals max
				if (keys["sSpecial"][i][2])
					special_value = Number(keys["sSpecial"][i][2]).toFixed(0);

				if (isFloat(keys["sSpecial"][i][2]))
					keys["sSpecial"][i][2] = keys["sSpecial"][i][2].toFixed(2);

				var special_values = keys["sSpecial"][i][2].toString().split(" ");
				var special_value = special_values[Math.min(ability_level - 1, special_values.length - 1)];

//				$.Msg(special_key)
//				$.Msg(special_values)
//				$.Msg(special_value)

				var tooltip_string = "DOTA_Tooltip_Ability_" + keys.sAbilityName.replace("imba_", "") + "_" + special_key;
				var tooltip_string_localized = $.Localize(tooltip_string);

				// Check for IMBA KV extra attributes tooltips
				var imba_tooltip_string = "DOTA_Tooltip_Ability_" + keys.sAbilityName + "_" + special_key;
				var imba_tooltip_string_localized = $.Localize(imba_tooltip_string);

				var IsPercentage = false;
//				$.Msg(tooltip_string)
//				$.Msg(tooltip_string_localized)

				if (imba_tooltip_string_localized != tooltip_string) {
					if (imba_tooltip_string_localized.startsWith("%")) {
						imba_tooltip_string_localized = imba_tooltip_string_localized.replace("%", "");
						IsPercentage = true;
					}
				} 

				if (tooltip_string_localized != tooltip_string) {
					if (tooltip_string_localized.startsWith("%")) {
						tooltip_string_localized = tooltip_string_localized.replace("%", "");
						IsPercentage = true;
					}
				}

				// Percentage checker
//				$.Msg("%" + special_key + "%%%")

				if (AbilityDescription.indexOf("%" + special_key + "%%") !== -1 || IsPercentage == true) {
//					$.Msg("Percentage value: " + special_key)
					special_values = special_values.join("% / ") + "%";

					if (AbilityDescription.indexOf("%" + special_key + "%%%") !== -1) {
						special_values = special_values.replace(special_value + "%%", '<span class="GameplayValues"><span class="GameplayVariable"><span class="GameplayVariable">' + special_value + '%</span></span></span> ')

						if (AbilityDescription.indexOf("%" + special_key + "%%%") !== -1) {
	//						$.Msg("Replace " + "%" + special_key + "%" + " with: " + special_values)

							AbilityDescription = AbilityDescription.replace("%" + special_key + "%%%", special_values);
						}
					} else {
						special_values = special_values.replace(special_value + "%", '<span class="GameplayValues"><span class="GameplayVariable"><span class="GameplayVariable">' + special_value + '%</span></span></span> ')

						if (AbilityDescription.indexOf("%" + special_key + "%%") !== -1) {
	//						$.Msg("Replace " + "%" + special_key + "%" + " with: " + special_values)

							AbilityDescription = AbilityDescription.replace("%" + special_key + "%%", special_values);
						}
					}
				} else {
//					$.Msg("Non Percentage value: " + special_key)
					special_values = special_values.join(" / ");
					special_values = SetActiveValue(special_values, special_value);

					if (AbilityDescription.indexOf("%" + special_key + "%") !== -1) {
//						$.Msg("Replace " + "%" + special_key + "%" + " with: " + special_values)

						AbilityDescription = AbilityDescription.replace("%" + special_key + "%", special_values);
					}
				}

				if (tooltip_string_localized != tooltip_string) {
					AbilityExtraAttributes_Text = AbilityExtraAttributes_Text + tooltip_string_localized + " " + special_values + "<br>";
				}

				if (keys.sAbilityName.indexOf("imba_") !== -1 && imba_tooltip_string_localized != imba_tooltip_string) {
//					$.Msg(imba_tooltip_string)
//					$.Msg(imba_tooltip_string_localized)
					AbilityExtraAttributes_Text = AbilityExtraAttributes_Text + imba_tooltip_string_localized + " " + special_values + "<br>";
				}
			}
		}
	}

//	$.Msg($.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Note_" + i))
	while ($.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Note_" + i) != "DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Note_" + i) {
//		$.Msg($.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Note_" + i))
		AbilityDescription = AbilityDescription + "<br><br>" + $.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Note_" + i);
		i++;
	}

	// Need a proper way to gather cast range for every levels and highlight current level value
/*
	var cast_range_string = "DOTA_Tooltip_Ability_" + keys.sAbilityName.replace("imba_", "") + "_abilitycastrange";

	if ($.Localize(cast_range_string) != cast_range_string) {
		AbilityExtraAttributes_Text = AbilityExtraAttributes_Text + $.Localize(cast_range_string) + " " + special_values + "<br>";
	}
*/

	// If there is no vanilla ability for this IMBA ability, ignore
	if ($.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName.replace("imba_", "")) != "DOTA_Tooltip_Ability_" + keys.sAbilityName.replace("imba_", ""))
		AbilityDescription = SetTooltipsValues(keys.sAbilityName, AbilityDescription, AbilityAttributes, true);

	AbilityExtraAttributes_Text = AbilityExtraAttributes_Text.slice(0, -4);

	AbilityExtraAttributes.SetDialogVariable("extra_attributes", AbilityExtraAttributes_Text);

	AbilityDescription = SetTooltipsValues(keys.sAbilityName, AbilityDescription, AbilityAttributes, false);

/*
	// cleanup double % signs
	while (AbilityDescription.indexOf("%%") !== -1) {
		AbilityDescription = AbilityDescription.replace("%%", "%");
	}
*/

	AbilityAttributes.SetDialogVariable("attributes", AbilityDescription);

	var AbilityExtraDescription_Text = "";

	var i = 0;
	while ($.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Note" + i) != "DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Note" + i) {
		AbilityExtraDescription_Text = AbilityExtraDescription_Text + "<br><br>" + $.Localize("DOTA_Tooltip_Ability_" + keys.sAbilityName + "_Note" + i);
		i++;
	}

	AbilityExtraDescription_Text = AbilityExtraDescription_Text.slice(8);
	AbilityExtraDescription.SetDialogVariable("extradescription", AbilityExtraDescription_Text);

	if (keys) {
		if (keys["iCooldown"] != undefined) {	
			var cd = [];

			for (var i in keys["iCooldown"]) {
				var fixed_cd = keys["iCooldown"][i];

				if (isFloat(fixed_cd))
					fixed_cd = fixed_cd.toFixed(1);

				cd[i - 1] = fixed_cd;
			}

			var current_cd = cd[Math.min(ability_level - 1, cd.length - 1)];

			// This is where we turn array of values into a single string to use as text
			cd = cd.join(" / ");

			if (cd != 0) {
				if (ability_level != 0) {
					cd = SetActiveValue(cd, current_cd);
				}

				AbilityCooldown.style.visibility = "visible";
				AbilityCooldown.SetDialogVariable("cooldown", cd);
			} else
				AbilityCooldown.style.visibility = "collapse";
		}

		var same_mana = true;
		if (keys["iManaCost"] != undefined) {
			var mana = [];

			for (var i in keys["iManaCost"]) {
				var fixed_mana = keys["iManaCost"][i];

				mana[i - 1] = fixed_mana;
			}

			var current_mana = mana[Math.min(ability_level - 1, mana.length - 1)];

			// This is where we turn array of values into a single string to use as text
			mana = mana.join(" / ");

			if (mana != 0) {
				if (ability_level != 0) {
					mana = SetActiveValue(mana, current_mana);
				}

				AbilityManaCost.style.visibility = "visible";
				AbilityManaCost.SetDialogVariable("manacost", mana);
			} else
				AbilityManaCost.style.visibility = "collapse";
		}
	}

	var String_Lore = "DOTA_Tooltip_Ability_" + keys.sAbilityName.replace("imba_", "") + "_Lore";
	var Lore = $.Localize(String_Lore);

	if (Lore != String_Lore) {
		AbilityLore.SetDialogVariable("lore", Lore);
		AbilityLore.style.visibility = "visible";
	} else {
		AbilityLore.style.visibility = "collapse";
	}

	// Check ability valid so this don't show in pick screen
	if (ability && ability_level != ability_max_level && Abilities.GetHeroLevelRequiredToUpgrade(ability) != -1 && Abilities.GetHeroLevelRequiredToUpgrade(ability) > Entities.GetLevel(hero) && Abilities.CanAbilityBeUpgraded(ability)) {
		AbilityUpgradeLevel.SetDialogVariableInt("upgradelevel", Abilities.GetHeroLevelRequiredToUpgrade(ability))
		AbilityUpgradeLevel.style.visibility = "visible";
	} else {
		AbilityUpgradeLevel.style.visibility = "collapse";		
	}

	var hPanel = GetDotaHud().FindChildTraverse("Ability" + keys.iAbility);
	var ability_button = undefined;

	if (Game.GetState() <= 4) {
		hPanel = GetDotaHud().FindChildTraverse("HeroInspect").FindChildTraverse("HeroAbilities");
		ability_button = hPanel.GetChild(keys["iAbility"]);
	} else {
		ability_button = hPanel.FindChildTraverse("AbilityButton");
	}

	SetPositionLoop(ability_button, hPanel.GetPositionWithinWindow());

	AbilityDetails.style.opacity = "1";

//	$.Msg("AbilityDetails visible : " + AbilityDetails.style.opacity);
}

function SetPositionLoop(hPanel, hPosition) {
	SetTooltipsPosition(hPanel.GetPositionWithinWindow());

	if (hPanel.BHasHoverStyle()) {
		$.Schedule(0.03, function() {
			SetPositionLoop(hPanel, hPosition);
		});

		return;
	}

	// fix for panel staying visible sometimes?
	$.Schedule(0.03, function() {
		if (AbilityDetails.style.opacity == 1) {
			HideTooltips();
		}
	});
}

function SetTooltipsPosition(hPosition) {
//	$.Msg(hPosition);
	var position_x = hPosition["x"];
	var position_y = hPosition["y"];
	var offset_x = 0;
	var offset_y = 0;

//	$.Msg("Actual layout height: ", AbilityDetails.actuallayoutheight);

	// 1.77, 1.6, 1.33: 16/9, 16/10, 4/3 (Offset for every ratios)
	var aspect_ratios = [];
	aspect_ratios[1.8] = ["16/9", 90, 0];
	aspect_ratios[1.6] = ["16/10", 90, 0];
	aspect_ratios[1.3] = ["4/3", 90, 0];

	var aspect_ratio = aspect_ratios[(AbilityDetails.GetParent().actuallayoutwidth / AbilityDetails.GetParent().actuallayoutheight).toFixed(1)];

	if (aspect_ratio) {
//		$.Msg("Aspect Ratio: ", aspect_ratio[0]);

		offset_x = aspect_ratio[1];
		offset_y = aspect_ratio[2];
	}

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
		offset_y = ((full_y) - (AbilityDetails.GetParent().actuallayoutheight)) * (-1) - 20; // -20 so it's not tied to the border of the screen

//	$.Msg("---------------------------------------------------------------------")

	var x_pct = ((position_x + offset_x) / Game.GetScreenWidth()) * 100;
	var y_pct = ((position_y + offset_y) / Game.GetScreenHeight()) * 100;

//	$.Msg("" + (position_x + offset_x) + "px " + (position_y + offset_y) + "px 0px")
	AbilityDetails.style.position = "" + x_pct + "% " + y_pct + "% 0px";
}

function OnThink() {
//	$.Msg(AbilityDetails)
	if (AbilityDetails && AbilityExtraDescription) {
//		$.Msg(GameUI.IsAltDown())
//		$.Msg(AbilityDetails.style.opacity)
		if (GameUI.IsAltDown() && AbilityDetails.style.opacity == "1.0" && AbilityExtraDescription.text != "") {
			AbilityDetails.SetHasClass("ShowExtraDescription", true);
//			SetTooltipsPosition(hPosition); // Not sure yet how to properly find the ability button position
		} else {
			AbilityDetails.SetHasClass("ShowExtraDescription", false);
		}
	}

	$.Schedule(0.03, OnThink);
}

function HideTooltips() {
	AbilityDetails.style.opacity = "0";

	GameEvents.SendCustomGameEventToServer("remove_tooltips_info", {})
}

// utils
function SetTooltipsValues(sAbilityName, tooltip, panel, bVanilla) {
	if (bVanilla == true)
		sAbilityName = sAbilityName.replace("imba_", "");

	return GameUI.ReplaceDOTAAbilitySpecialValues(sAbilityName, tooltip, panel);
}

function SetActiveValue(values, active_value, bFloat) {
	if (typeof(values) == "number")
		values = values.toString();

	var sliced_string = values;
	var string_sliced = false;

//	$.Msg(values)
//	$.Msg(active_value)

	var last_match_pos_in_string = values.lastIndexOf(active_value);

	if (last_match_pos_in_string !== -1 && last_match_pos_in_string !== 0) {
//		$.Msg("Match/Position: " + active_value + " / " + last_match_pos_in_string);
		values = values.slice(0, last_match_pos_in_string);
		sliced_string = sliced_string.slice(last_match_pos_in_string);
		string_sliced = true;
	}

//	$.Msg(values)
//	$.Msg(sliced_string);

	if (string_sliced == true) {
		sliced_string = sliced_string.replace(active_value, '<span class="GameplayValues"><span class="GameplayVariable"><span class="GameplayVariable">' + active_value + '</span></span></span>');
		return values + sliced_string;
	} else {
		return values.replace(active_value, '<span class="GameplayValues"><span class="GameplayVariable"><span class="GameplayVariable">' + active_value + '</span></span></span>');
	}

//	if (bFloat == true)
//		return values.replace(active_value + ".0", '<span class="GameplayValues"><span class="GameplayVariable"><span class="GameplayVariable">' + active_value + '.0</span></span></span>')
//	else
//		return values.replace(active_value, '<span class="GameplayValues"><span class="GameplayVariable"><span class="GameplayVariable">' + active_value + '</span></span></span>')
}

function GetAbilityType(iBehavior) {
	for (var i in DOTA_ABILITY_BEHAVIOR) {
		if (Array_BehaviorTooltips[bit_band(iBehavior, DOTA_ABILITY_BEHAVIOR[i])])
			return DOTA_ABILITY_BEHAVIOR[i];
	}

	// Defaults to no target in case the function doesn't work as expected.
	return 4;
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
