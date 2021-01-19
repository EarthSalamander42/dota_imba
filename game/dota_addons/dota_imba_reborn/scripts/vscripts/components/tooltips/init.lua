if not CustomTooltips then
	CustomTooltips = class({})
	CustomTooltips.particles = {}

	CustomGameEventManager:RegisterListener("get_tooltips_info", Dynamic_Wrap(CustomTooltips, 'GetTooltipsInfo'))
	CustomGameEventManager:RegisterListener("remove_tooltips_info", Dynamic_Wrap(CustomTooltips, 'RemoveTooltipsInfo'))
end

local split = function(inputstr, sep)
	if sep == nil then sep = "%s" end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
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

	local hAbility = hero:FindAbilityByName(keys.sAbilityName)
	local hRealCooldown = split(ability_values["cooldown"], " ")

	print(hRealCooldown)

	for i = 1, #hRealCooldown do
		if hRealCooldown[i] then
--			print(hRealCooldown[i], hero:GetCooldownReduction())
			hRealCooldown[i] = hRealCooldown[i] * (hero:GetCooldownReduction() * 100) / 100
		end
	end

	local cast_range = 0

	if hAbility then
		cast_range = GetAbilityKV(ability_name, "AbilityCastRange", hAbility:GetLevel()) or 0
	end

	if cast_range ~= 0 then
		if not CustomTooltips.particles[keys.PlayerID] then
			CustomTooltips.particles[keys.PlayerID] = {}
		end

		local pfx = ParticleManager:CreateParticle("particles/ui_mouseactions/range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
		ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(cast_range + GetCastRangeIncrease(hero), 0, 0))
		table.insert(CustomTooltips.particles[keys.PlayerID], pfx)
	end

--	print("Send server tooltips info:", ability_values["specials"])
	CustomGameEventManager:Send_ServerToPlayer(player, "server_tooltips_info", {
		sAbilityName = keys.sAbilityName,
		hPosition = keys.hPosition,
		iCooldown = hRealCooldown,
		iManaCost = ability_values["manacost"],
		sSpellImmunity = ability_values["SpellImmunityType"],
		sSpellDispellable = ability_values["SpellDispellableType"],
		sSpecial = ability_values["specials"],
		iBonusCastRange = hero:GetCastRangeBonus(),
		iAbility = keys["iAbility"],
	})
end

function CustomTooltips:RemoveTooltipsInfo(keys)
	for k, v in pairs(CustomTooltips.particles[keys.PlayerID] or {}) do
		ParticleManager:DestroyParticle(v, false)
		ParticleManager:ReleaseParticleIndex(v)
	end
end
