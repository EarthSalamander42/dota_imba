if not CustomTooltips then
	CustomTooltips = class({})

	CustomGameEventManager:RegisterListener("get_tooltips_info", Dynamic_Wrap(CustomTooltips, 'GetTooltipsInfo'))
end

function CustomTooltips:GetTooltipsInfo(keys)
--	print(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local hero = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
	local ability_values = {}

	local ability_name = GetVanillaAbilityName(keys.sAbilityName)
	local specials = GetAbilitySpecials(ability_name)
	local imba_specials = GetAbilitySpecials("imba_"..ability_name)

	for k, v in pairs(imba_specials) do
		table.insert(specials, v)
	end

	if ability_name then
		ability_values["cooldown"] = GetAbilityCooldown(ability_name)
		ability_values["manacost"] = GetAbilityManaCost(ability_name)
		ability_values["specials"] = specials
		ability_values["SpellImmunityType"] = GetSpellImmunityType(ability_name)
		ability_values["SpellDispellableType"] = GetSpellDispellableType(ability_name)
	else
		print("ERROR: Vanilla ability name not found.", keys.sAbilityName)
		return
	end

--	print("Send server tooltips info:", ability_values["specials"])
	CustomGameEventManager:Send_ServerToPlayer(player, "server_tooltips_info", {
		sAbilityName = keys.sAbilityName,
		hPosition = keys.hPosition,
		iCooldown = ability_values["cooldown"],
		iManaCost = ability_values["manacost"],
		sSpellImmunity = ability_values["SpellImmunityType"],
		sSpellDispellable = ability_values["SpellDispellableType"],
		sSpecial = ability_values["specials"],
		iBonusCastRange = hero:GetCastRangeBonus(),
	})
end
