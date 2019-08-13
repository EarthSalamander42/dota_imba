// Editor: naowin 	12.08.2019

// not sure if overriding tooltip.text destroys stuff. If it turns out we cant
// do this. when we have to create new lable and just hide the old one.

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
			return text.replace(orb, "<font color='" + quas_color + "'>" + orb +"</font>") + "\n<br></br>"
		case "WEX":
			return text.replace(orb, "<font color='" + wex_color + "'>" + orb +"</font>") + "\n<br></br>"
		case "EXORT":
			return text.replace(orb, "<font color='" + exort_color + "'>" + orb +"</font>") + "\n<br></br>"
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
			values[i] = values[i].replace(values[i], "<font color='#4d5560'>" + highlight_value + "</font>")
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
		print("Failed to convert: " + text)
	}
}

// try call GetDotaHud() as few times as possible
var DotaHud = GetDotaHud();

// TODO: Find out a way for this to be triggered when mouseover on ability. 
// if possible only trigger this function on invoked tooltips (they are the only broken ones currently)
function ColorizeInvokerTooltip() 
{
	if(DotaHud.FindChildTraverse("AbilitiesAndStatBranch").BHasClass("npc_dota_hero_invoker"))
	{	
		var invoker = Entities.GetAllEntitiesByName("npc_dota_hero_invoker")[0] || null
		if (invoker != null) 
		{
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
							if (text_row.indexOf("(QUAS)") > -1) 
							{
								orb_text = true
								new_ability_text = new_ability_text + AddOrbColor("QUAS", ability_text_rows[i]) + AddDamageValue(quas_lvl, ability_text_rows[i + 1]) 
								i = i + 1
							}

							if (text_row.indexOf("(WEX)") > -1) 
							{
								orb_text = true
							new_ability_text = new_ability_text + AddOrbColor("WEX", ability_text_rows[i]) + AddDamageValue(wex_lvl, ability_text_rows[i + 1]) 
							i = i + 1
							}

							if (text_row.indexOf("(EXORT)") > -1) 
							{
								orb_text = true
								new_ability_text = new_ability_text + AddOrbColor("EXORT", ability_text_rows[i]) + AddDamageValue(exort_lvl, ability_text_rows[i + 1]) 
								i = i + 1
							}

							if (!orb_text) {

								new_ability_text = new_ability_text + PlainText(ability_text_rows[i])
							}
					}

					// for debugging 
					//print(new_ability_text)					
					//AbilityExtraAttributes.text = new_ability_text
				}
			}
		}
	}
}
