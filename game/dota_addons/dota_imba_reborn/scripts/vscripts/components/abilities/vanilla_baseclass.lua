vanilla_baseclass = vanilla_baseclass or {}

function vanilla_baseclass:GetCooldown()
	return self:GetVanillaKeyValue("AbilityCooldown")
end

function vanilla_baseclass:GetManaCost()
	if self:GetLevel() == 0 then
		return 0
	else
		return self:GetVanillaKeyValue("AbilityManaCost")
	end
end

function vanilla_baseclass:GetCastPoint()
	return self:GetVanillaKeyValue("AbilityCastPoint")
end

function vanilla_baseclass:GetCastRange(location, target)
	return self:GetVanillaKeyValue("AbilityCastRange")
end

return vanilla_baseclass
