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

function CustomTooltips:GetIMBAValue(value)
	print("GetIMBAValue", value, type(value))
	if value then
		if type(value) == "string" then
			value = tonumber(value)
		end

		if type(value) == "number" then
			return value + (value * IMBAFIED_VALUE_BONUS / 100)
		end

		if type(value) == "table" and value["value"] and type(value["value"]) == "string" then
			value["value"] = split(value["value"], " ")
	
			for k, v in pairs(value["value"]) do
				if v then
					value["value"][k] = tonumber(v) * (100 + IMBAFIED_VALUE_BONUS) / 100
				end
			end

			print("GetIMBAValue", value, type(value))
			value["value"] = table.concat(value["value"], " ")
		end
	end

	return value or 0
end

function CustomTooltips:GetTooltipsInfo(keys)
--	print(keys)

	if not keys.PlayerID or keys.PlayerID == -1 then
		print("ERROR: Invalid Player ID:", keys.PlayerID)
		return
	end
--[[
	if PlayerResource:GetPlayer(keys.PlayerID):GetTeam() == 1 then
		print("Custom Tooltips: Block Spectators.")
		return
	end
--]]
--	print(keys)
	local ability_name = GetVanillaAbilityName(keys.sAbilityName)
	if not ability_name then
		print("ERROR: Vanilla ability name not found.", keys.sAbilityName)
		return
	end

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local hero = nil

	if keys.iSelectedEntIndex and type(keys.iSelectedEntIndex) == "number" and EntIndexToHScript(keys.iSelectedEntIndex) then
		hero = EntIndexToHScript(keys.iSelectedEntIndex)
	end

	local ability_values = {}
	local specials = GetAbilitySpecials(ability_name, true)
	local imba_specials = GetAbilitySpecials("imba_"..ability_name)
	local specials_issued = {}

	for k, v in pairs(imba_specials) do
		if v and v[1] and not specials_issued[v[1]] then
			specials_issued[v[1]] = true
		end
	end

	-- print(specials_issued)

	-- use imba values by default, add vanilla values if imba missing (this way imba values has priority over vanilla)
	for k, value in pairs(specials) do
		-- prevent adding doublons, prioritize imba values
		if value and value[1] and not specials_issued[value[1]] then
--			print("From now on, ignore", v[1])
			specials_issued[value[1]] = true

			if hero and hero:FindAbilityByName(keys.sAbilityName) then
				local talent_value = hero:FindAbilityByName(keys.sAbilityName):GetTalentSpecialValueFor(value[1])

				-- imba talent value found
				if talent_value and talent_value ~= 0 then
					table.insert(imba_specials, talent_value)
				else -- default to vanilla
					table.insert(imba_specials, value)
				end
			else
				table.insert(imba_specials, value)
			end
		end
	end

	-- print(specials_issued)
	-- print(imba_specials)

	local hRealCooldown = split(GetAbilityCooldown(ability_name), " ")
	local hRealManaCost = split(GetAbilityManaCost(ability_name), " ")

	-- hero is nil when spectating (however currently custom tooltips are disabled for spectators)
	if hero then
		for i = 1, #hRealCooldown do
			if hRealCooldown[i] then
--				print(hRealCooldown[i], hero:GetCooldownReduction())
				hRealCooldown[i] = hRealCooldown[i] * (hero:GetCooldownReduction() * 100) / 100
				hRealCooldown[i] = CustomTooltips:GetIMBAValue(hRealCooldown[i])
			end
		end

		for i = 1, #hRealManaCost do
			--[[
			if hRealManaCost[i] then
	--			print(hRealManaCost[i], hero:GetCooldownReduction())
				hRealManaCost[i] = hRealManaCost[i] * (hero:GetCooldownReduction() * 100) / 100
			end
			--]]
			if hRealManaCost[i] then
				hRealManaCost[i] = CustomTooltips:GetIMBAValue(hRealManaCost[i])
			end
		end
	end

	local cast_range = 0
	local lua_cast_range = 0
	local bonus_cast_range = 0
	local hAbility = nil
	local max_level = 4

	if GetAbilityKV(ability_name, "MaxLevel") then
		if GetAbilityKV(ability_name, "MaxLevel") ~= max_level then
			max_level = GetAbilityKV(ability_name, "MaxLevel")
		end
	else
		if GetAbilityKV(ability_name, "AbilityType") and GetAbilityKV(ability_name, "AbilityType") == "DOTA_ABILITY_TYPE_ULTIMATE" then
			max_level = 3
		end
	end

	if hero then
		hAbility = hero:FindAbilityByName(keys.sAbilityName)
		bonus_cast_range = hero:GetCastRangeBonus()
	end

	if hAbility and hAbility:GetLevel() ~= 0 then
		lua_cast_range = hAbility:GetCastRange(hero:GetAbsOrigin(), nil)

		if lua_cast_range == 0 then
			cast_range = GetAbilityKV(ability_name, "AbilityCastRange", hAbility:GetLevel()) or 0
		else
			cast_range = lua_cast_range or 0
		end

	--	print("Cast Range:", cast_range)
		if cast_range ~= 0 then
			if not CustomTooltips.particles[keys.PlayerID] then
				CustomTooltips.particles[keys.PlayerID] = {}
			end

			if bit.band(tonumber(tostring(hAbility:GetBehavior())), DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= DOTA_ABILITY_BEHAVIOR_NO_TARGET then
				cast_range = cast_range + GetCastRangeIncrease(hero)
			end

			local pfx = ParticleManager:CreateParticleForPlayer("particles/ui_mouseactions/range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero, player)
			ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, Vector(cast_range, 0, 0))
			table.insert(CustomTooltips.particles[keys.PlayerID], pfx)
		end
	end

	local values = {
		sAbilityName = keys.sAbilityName,
		iCooldown = hRealCooldown,
		iManaCost = hRealManaCost,
		sSpellImmunity = GetSpellImmunityType(ability_name),
		sSpellDispellable = GetSpellDispellableType(ability_name),
		sSpecial = imba_specials,
		iBonusCastRange = bonus_cast_range,
		iBehavior = GetAbilityKV(ability_name, "AbilityBehavior"),
		iDamageType = GetAbilityKV(ability_name, "AbilityUnitDamageType"),
		iMaxLevel = max_level,
		iAbility = keys["iAbility"],
	}

	print(values)
	if values["iBonusCastRange"] then
		values["iBonusCastRange"] = CustomTooltips:GetIMBAValue(values["iBonusCastRange"])
	end
	print(values)

--	print("Send server tooltips info:", imba_specials)
	CustomGameEventManager:Send_ServerToPlayer(player, "server_tooltips_info", values)
end

function CustomTooltips:RemoveTooltipsInfo(keys)
	for k, v in pairs(CustomTooltips.particles[keys.PlayerID] or {}) do
		ParticleManager:DestroyParticle(v, false)
		ParticleManager:ReleaseParticleIndex(v)
	end
end
