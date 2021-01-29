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
	local ability_name = GetVanillaAbilityName(keys.sAbilityName)
	if not ability_name then
		print("ERROR: Vanilla ability name not found.", keys.sAbilityName)
		return
	end

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local hero = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
	local ability_values = {}

	local specials = GetAbilitySpecials(ability_name)
	local imba_specials = GetAbilitySpecials("imba_"..ability_name)
	local specials_issued = {}

	for k, v in pairs(imba_specials) do
		if v and v[1] and not specials_issued[v[1]] then
			specials_issued[v[1]] = true
		end
	end

--	print(specials_issued)

	-- use imba values by default, add vanilla values if imba missing (this way imba values has priority over vanilla)
	for k, v in pairs(specials) do
		-- prevent adding doublons, prioritize imba values
		if v and v[1] and not specials_issued[v[1]] then
--			print("From now on, ignore", v[1])
			specials_issued[v[1]] = true
			table.insert(imba_specials, v)
		end
	end

--	print(specials_issued)
--	print(imba_specials)

	local hRealCooldown = split(GetAbilityCooldown(ability_name), " ")

	for i = 1, #hRealCooldown do
		if hRealCooldown[i] then
--			print(hRealCooldown[i], hero:GetCooldownReduction())
			hRealCooldown[i] = hRealCooldown[i] * (hero:GetCooldownReduction() * 100) / 100
		end
	end

	local hRealManaCost = split(GetAbilityManaCost(ability_name), " ")
--[[

	for i = 1, #hRealManaCost do
		if hRealManaCost[i] then
--			print(hRealManaCost[i], hero:GetCooldownReduction())
			hRealManaCost[i] = hRealManaCost[i] * (hero:GetCooldownReduction() * 100) / 100
		end
	end
--]]

	local cast_range = 0

	local hAbility = hero:FindAbilityByName(keys.sAbilityName)

	if hAbility then
		cast_range = GetAbilityKV(ability_name, "AbilityCastRange", hAbility:GetLevel()) or 0
	end

	if cast_range ~= 0 then
		if not CustomTooltips.particles[keys.PlayerID] then
			CustomTooltips.particles[keys.PlayerID] = {}
		end

		local pfx = ParticleManager:CreateParticleForPlayer("particles/ui_mouseactions/range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero, player)
		ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(cast_range + GetCastRangeIncrease(hero), 0, 0))
		table.insert(CustomTooltips.particles[keys.PlayerID], pfx)
	end

--	print("Send server tooltips info:", imba_specials)
	CustomGameEventManager:Send_ServerToPlayer(player, "server_tooltips_info", {
		sAbilityName = keys.sAbilityName,
		iCooldown = hRealCooldown,
		iManaCost = hRealManaCost,
		sSpellImmunity = GetSpellImmunityType(ability_name),
		sSpellDispellable = GetSpellDispellableType(ability_name),
		sSpecial = imba_specials,
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
