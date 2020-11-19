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

--[[ -- occasionnally turns the ability to an uncastable state
function vanilla_baseclass:GetBehavior()
	if not self.vanilla_behavior then
		self.vanilla_behavior = _G[self:GetVanillaKeyValue("AbilityBehavior")]
	end

	return self.vanilla_behavior
end
--]]

return vanilla_baseclass
