vanilla_baseclass = vanilla_baseclass or {}

function vanilla_baseclass:GetCooldown()
	local imba_value = GetAbilityKV(self:GetName(), "AbilityCooldown")

	if imba_value then
		return imba_value
	end

	return self:GetVanillaKeyValue("AbilityCooldown")
end

function vanilla_baseclass:GetManaCost()
	local imba_value = GetAbilityKV(self:GetName(), "AbilityManaCost")

	if imba_value then
		return imba_value
	end

	if self:GetLevel() == 0 then
		return 0
	else
		return self:GetVanillaKeyValue("AbilityManaCost")
	end
end

function vanilla_baseclass:GetCastPoint()
	local imba_value = GetAbilityKV(self:GetName(), "AbilityCastPoint")

	if imba_value then
		return imba_value
	end

	return self:GetVanillaKeyValue("AbilityCastPoint")
end

function vanilla_baseclass:GetCastRange(location, target)
	local imba_value = GetAbilityKV(self:GetName(), "AbilityCastRange")

	if imba_value then
		return imba_value
	end

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
