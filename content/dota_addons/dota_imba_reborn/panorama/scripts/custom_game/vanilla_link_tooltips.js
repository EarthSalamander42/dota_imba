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

function PlainText(text) 
{
	var ability_splits = text.split(": ")
	if(ability_splits != null && ability_splits.length == 2) 
	{
		return text.replace(ability_splits[1], "<font color='#FFFFFF'>" + ability_splits[1] + "</font>\n<br></br>")
	}
	else 
	{
		print("Failed to convert tooltip text: " + text)
	}
}

var DotaHud = GetDotaHud();

function init_invoker_tooltips() {
	// Handle Invoked spell in slot 4
	var ability3 = DotaHud.FindChildTraverse("Ability3");
	ability3.SetPanelEvent(
		"onmouseover", 
		function(){
			ColorizeInvokerTooltip(3)
		}
	)

	ability3.SetPanelEvent(
		"onmouseout", 
		function(){
//			ToggleInvokerTooltip()
		}
	)
	
	// Handle Invoked spell in slot 5
	var ability4 = DotaHud.FindChildTraverse("Ability4");
	if (ability4) {

		ability4.SetPanelEvent(
			"onmouseover", 
			function(){
				ColorizeInvokerTooltip(4)
			}
		)

		ability4.SetPanelEvent(
			"onmouseout", 
			function(){
				ToggleInvokerTooltip()
			}
		)

	}

	// Toggle Visibility for Invokers invoke spell list
	if (DotaHud.FindChildTraverse("Ability5") && DotaHud.FindChildTraverse("Ability5").Children() && DotaHud.FindChildTraverse("Ability5").Children()[1])
		DotaHud.FindChildTraverse("Ability5").Children()[1].style.visibility = "visible"

	// Remove onmouseover tooltips from Inokver's Spell list... they bug out completely 
	var spell_card_icons = DotaHud.FindChildTraverse("lower_hud").FindChildTraverse("SpellRowContainer").FindChildrenWithClassTraverse("AbilityMaxLevel")
	if (spell_card_icons != null && spell_card_icons.length == 10)
	{
		for(var i = 0; i < 10; i++) 
		{
			var ability = spell_card_icons[i];
			var ability_name = spell_card_icons[i].abilityname;

			(function (ability, ability_name) {
				ability.SetPanelEvent("onmouseover", function () {
					$.DispatchEvent("DOTAShowAbilityTooltip", ability, "imba_" + ability_name);
				})
				ability.SetPanelEvent("onmouseout", function () {
					$.DispatchEvent("DOTAHideAbilityTooltip", ability);
				})
			})(ability, ability_name);
		}
	}
}

GameEvents.Subscribe("invoker_helper", init_invoker_tooltips);

//print(DotaHud.FindChildTraverse("DOTAAbilityTooltip").FindChildTraverse("AbilityName").text)
//print(DotaHud.FindChildTraverse("DOTAAbilityTooltip").FindChildTraverse('AbilityExtraAttributes'))
//print(DotaHud.FindChildTraverse("DOTAAbilityTooltip").FindChildTraverse('AbilityCoreDetails').GetChild(6).id)
//print(DotaHud.FindChildTraverse("DOTAAbilityTooltip").FindChildTraverse('AbilityCoreDetails'))
