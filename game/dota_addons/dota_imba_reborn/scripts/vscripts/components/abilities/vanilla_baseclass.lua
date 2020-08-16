vanilla_baseclass = vanilla_baseclass or {}

local function GetVanillaAbilityName(sAbilityName)
	return string.gsub(sAbilityName, "imba_", "")
end

function vanilla_baseclass:GetCooldown(iLevel)
	return GetAbilityKV(GetVanillaAbilityName(self:GetAbilityName()), "AbilityCooldown", iLevel)
end

function vanilla_baseclass:GetManaCost(iLevel)
	return GetAbilityKV(GetVanillaAbilityName(self:GetAbilityName()), "AbilityManaCost", iLevel)
end

function vanilla_baseclass:GetCastPoint()
	return GetAbilityKV(GetVanillaAbilityName(self:GetAbilityName()), "AbilityCastPoint", iLevel)
end

-- CDOTABaseAbility:GetAbilitySpecial("key")

return vanilla_baseclass
