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


function AddOrbColor(orb, text) 
{	
	var quas_color = '#0066FF'
	var wex_color = '#CC0099'
	var exort_color = '#E68A00'

	switch(orb) 
	{
		case "QUAS":
			return text.replace(orb, "<font color='" + quas_color + "'>" + $.Localize("DOTA_Tooltip_ability_invoker_quas").toUpperCase() + "</font>") + "\n<br></br>"
		case "WEX":
			return text.replace(orb, "<font color='" + wex_color + "'>" + $.Localize("DOTA_Tooltip_ability_invoker_wex").toUpperCase() + "</font>") + "\n<br></br>"
		case "EXORT":
			return text.replace(orb, "<font color='" + exort_color + "'>" + $.Localize("DOTA_Tooltip_ability_invoker_exort").toUpperCase() + "</font>") + "\n<br></br>"
	}
}

function AddDamageValue(orb_level, ability_values) 
{
	var white_color = '#FFFFFF'

	var values = ability_values.split(" / ")
	var highlight_value = values[orb_level - 1]

	for (var i = 0; i < values.length; i++) 
	{
		if (i == (orb_level - 1))
		{
			values[i] = values[i].replace(values[i], "<font color='#FFFFFF'>" + highlight_value + "</font>")
		}
		else
		{
			values[i] = values[i].replace(values[i], "<font color='#4d5560'>" + values[i] + "</font>")
		}
	}

	return values.join(" / ") + "\n<br></br>"
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
function ColorizeInvokerTooltip(slot_number) 
{
	if(DotaHud.FindChildTraverse("AbilitiesAndStatBranch").BHasClass("npc_dota_hero_invoker"))
	{	
		var invoker = Entities.GetAllEntitiesByName("npc_dota_hero_invoker")[0] || null
		if (invoker != null) 
		{
			if (slot_number > 0)
			{
				var ability_slot = Entities.GetAbility(invoker, slot_number);
				if(ability_slot) 
				{
					var ability_name = Abilities.GetAbilityName(ability_slot);
					if (ability_name && ability_name.indexOf('invoker_empty1') > -1) 
					{
						return
					}

					if (ability_name && ability_name.indexOf('invoker_empty2') > -1) 
					{
						return
					}

					if (ability_name && ability_name.indexOf('imba_invoker') == -1) 
					{
						return
					}
				}					
			}

			// Get orb ability levels
			var quas_lvl = Abilities.GetLevel(Entities.GetAbility(invoker, 0))
			var wex_lvl = Abilities.GetLevel(Entities.GetAbility(invoker, 1))
			var exort_lvl = Abilities.GetLevel(Entities.GetAbility(invoker, 2))

			//print("Q: " + quas_lvl + " W: " + wex_lvl + " E: " + exort_lvl)

			var AbilityTooltip = DotaHud.FindChildTraverse("DOTAAbilityTooltip")
			if(AbilityTooltip != null)
			{
				var AbilityExtraAttributes = AbilityTooltip.FindChildTraverse('AbilityExtraAttributes')
				var AbilityText = AbilityExtraAttributes.text
				var ability_text_rows =  AbilityText.split("\n")

				var new_ability_text = ""
				if(ability_text_rows != null && ability_text_rows.length > 0)
				{
					for(var i = 0; i < ability_text_rows.length; i++) {
						var text_row = ability_text_rows[i]
						var orb_text = false
							if (text_row.indexOf("(" + $.Localize("DOTA_Tooltip_ability_invoker_quas").toUpperCase() + ")") > -1) 
							{
								orb_text = true
								new_ability_text = new_ability_text + AddOrbColor("QUAS", ability_text_rows[i]) + AddDamageValue(quas_lvl, ability_text_rows[i + 1]) 
								i = i + 1
							}

							if (text_row.indexOf("(" + $.Localize("DOTA_Tooltip_ability_invoker_wex").toUpperCase() + ")") > -1) 
							{
								orb_text = true
								new_ability_text = new_ability_text + AddOrbColor("WEX", ability_text_rows[i]) + AddDamageValue(wex_lvl, ability_text_rows[i + 1]) 
								i = i + 1
							}

							if (text_row.indexOf("(" + $.Localize("DOTA_Tooltip_ability_invoker_exort").toUpperCase() + ")") > -1) 
							{
								orb_text = true
								new_ability_text = new_ability_text + AddOrbColor("EXORT", ability_text_rows[i]) + AddDamageValue(exort_lvl, ability_text_rows[i + 1]) 
								i = i + 1
							}

							if (!orb_text) {

								new_ability_text = new_ability_text + PlainText(ability_text_rows[i])
							}
					}

					var container = DotaHud.FindChildTraverse("DOTAAbilityTooltip").FindChildTraverse('AbilityExtraAttributes')
					var parent_container = container.GetParent()					
					var extra_attributes = DotaHud.FindChildTraverse("DOTAAbilityTooltip").FindChildTraverse('AbilityCoreDetails').GetChild(6)
					if (extra_attributes.id == 'imba_invoker_tooltip')
					{
						extra_attributes.text = new_ability_text
						extra_attributes.style.visibility = "visible";
						container.style.visibility = "collapse";
					}
					else
					{
						extra_attributes = $.CreatePanel('Label', parent_container, 'imba_invoker_tooltip')
						extra_attributes.style['letter-spacing'] = '0px';
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
					}
				}
			}
		}
	}
	else
	{
		print("Tried to invoke invoker tooltip function wrong hero-class")
	}
}

function ToggleInvokerTooltip() {
	var invoker_tooltip = DotaHud.FindChildTraverse("DOTAAbilityTooltip").FindChildTraverse('AbilityCoreDetails').GetChild(6)
	if(invoker_tooltip.id == 'imba_invoker_tooltip')
	{
		invoker_tooltip.style.visibility = "collapse";
		DotaHud.FindChildTraverse("DOTAAbilityTooltip").FindChildTraverse('AbilityCoreDetails').GetChild(7).style.visibility = "visible"
	}
}

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
	  		ToggleInvokerTooltip()
		}
	)
	
	// Handle Invoked spell in slot 5
	var ability4 = DotaHud.FindChildTraverse("Ability4");
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

	// Toggle Visibility for Invokers invoke spell list
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
