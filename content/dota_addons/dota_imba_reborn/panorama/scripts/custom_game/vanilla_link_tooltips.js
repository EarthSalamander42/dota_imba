'use strict';

function print(msg) {
	$.Msg(msg)
}

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

var DotaHud = GetDotaHud();

function AddHeroTooltips(slot_number) {
	if (DotaHud.FindChildTraverse("AbilitiesAndStatBranch").BHasClass("npc_dota_hero_abaddon_lul")) {
		var hero = Entities.GetAllEntitiesByName("npc_dota_hero_abaddon")[0] || null;
		var ability_name = null;

		if (hero != null) {
			var ability_level = 0;

			if (slot_number <= 6) {
				var ability_slot = Entities.GetAbility(hero, slot_number);
				ability_level = Abilities.GetLevel(ability_slot);

				if (ability_slot) {
					ability_name = Abilities.GetAbilityName(ability_slot).substring(5);
/*
					if (ability_name && ability_name.indexOf('invoker_empty1') > -1) {
						return
					}
*/
				}					
			}

//			print(ability_name)

			var AbilityTooltip = DotaHud.FindChildTraverse("DOTAAbilityTooltip");

			if (AbilityTooltip != null) {
				var AbilityText = $.Localize("DOTA_Tooltip_ability_" + ability_name + "_Description");
				var AbilityExtraAttributes = AbilityTooltip.FindChildTraverse('AbilityExtraAttributes');
				var ability_text_rows =  AbilityText.split("\n");

				var AbilityCooldown = AbilityTooltip.FindChildTraverse('AbilityCooldown');
				AbilityCooldown.text = SetKeyValueLevel(ability_level, AbilityCooldown.text);

				var AbilityManaCost = AbilityTooltip.FindChildTraverse('AbilityManaCost');

				print(AbilityText)

				var new_ability_text = "";

				if (ability_text_rows != null && ability_text_rows.length > 0) {
//					new_ability_text = new_ability_text + AbilityText;

					var container = DotaHud.FindChildTraverse("DOTAAbilityTooltip").FindChildTraverse('AbilityExtraAttributes')
					var parent_container = container.GetParent()					
					var extra_attributes = DotaHud.FindChildTraverse("DOTAAbilityTooltip").FindChildTraverse('AbilityCoreDetails').FindChildTraverse("imba_invoker_tooltip")

					if (extra_attributes) {
						extra_attributes.text = new_ability_text
						extra_attributes.style.visibility = "visible";
						container.style.visibility = "collapse";
					} else {
/*
						extra_attributes = $.CreatePanel('Label', parent_container, 'imba_invoker_tooltip')
//						extra_attributes.style['letter-spacing'] = '0px';
						extra_attributes.style['padding-left'] = '8px';
						extra_attributes.style['color'] = '#596e89';
						extra_attributes.style['font-size'] = '16px';
						extra_attributes.style['font-weight'] = 'normal';
						extra_attributes.style['font-family'] = 'Radiance';
						extra_attributes.html = true;
						extra_attributes.AddClass('imba_invoker_tooltip')
						extra_attributes.text = new_ability_text
						parent_container.MoveChildBefore(extra_attributes, container);
						container.style.visibility = "collapse";
*/
					}
				}

				AbilityCooldown
			}
		}
	} else {
		print("Tried to invoke invoker tooltip function wrong hero-class")
	}
}

function ToggleHeroTooltips() {
	var extra_attributes = DotaHud.FindChildTraverse("DOTAAbilityTooltip").FindChildTraverse('AbilityCoreDetails').FindChildTraverse("imba_invoker_tooltip")

	if(extra_attributes) {
		extra_attributes.style.visibility = "collapse";
//		DotaHud.FindChildTraverse("DOTAAbilityTooltip").FindChildTraverse('AbilityCoreDetails').GetChild(7).style.visibility = "visible"
	}
}

function init_tooltips(keys) {
	$.Msg(keys)

	for (var i = 0; i <= 5; i++) {
		var ability = DotaHud.FindChildTraverse("Ability" + i);

		if (ability) {
			var ability_name = ability.FindChildTraverse("AbilityImage").abilityname.substring(5);
			var tooltip_checker_string = "DOTA_Tooltip_Ability_" + ability_name;
			var tooltip_checker = $.Localize(tooltip_checker_string);


			print(tooltip_checker)

			if (tooltip_checker == tooltip_checker_string) {
				print("missing vanilla tooltip for ability " + ability_name + "! defaults to imba tooltips.")
				ability_name = ability.FindChildTraverse("AbilityImage").abilityname;
			}

			(function (ability, ability_name, i) {
				ability.SetPanelEvent("onmouseover", function() {
					$.DispatchEvent("DOTAHideAbilityTooltip", ability); // Disable vanilla tooltips
					$.DispatchEvent("DOTAShowAbilityTooltip", ability, ability_name); // Disable vanilla tooltips
//					AddHeroTooltips(i);
				})

//				ability.SetPanelEvent("onmouseout", function() {
//					ToggleHeroTooltips();
//				})
			})(ability, ability_name, i);
		}
	}
}

for (var i = 0; i <= 19; i++) {
	GameEvents.Subscribe("vanilla_abilities_" + i, init_tooltips);
}

//print(DotaHud.FindChildTraverse("DOTAAbilityTooltip").FindChildTraverse("AbilityName").text)
//print(DotaHud.FindChildTraverse("DOTAAbilityTooltip").FindChildTraverse('AbilityExtraAttributes'))
//print(DotaHud.FindChildTraverse("DOTAAbilityTooltip").FindChildTraverse('AbilityCoreDetails').GetChild(6).id)
//print(DotaHud.FindChildTraverse("DOTAAbilityTooltip").FindChildTraverse('AbilityCoreDetails'))
