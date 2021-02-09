vanilla_baseclass = vanilla_baseclass or {}

function vanilla_baseclass:GetRightfulKV(sKeyValue, bHideAtLevel0)
	if bHideAtLevel0 and self:GetLevel() == 0 then
		return 0
	end

	local imba_value = GetAbilityKV(self:GetName(), sKeyValue, self:GetLevel())

	if imba_value then
		return imba_value
	end

	return self:GetVanillaKeyValue(sKeyValue)
end

-- Careful! These functions are being overriden if one exists in hero scripts
function vanilla_baseclass:GetCooldown()
	return self:GetRightfulKV("AbilityCooldown")
end

function vanilla_baseclass:GetManaCost()
	return self:GetRightfulKV("AbilityManaCost", true)
end

function vanilla_baseclass:GetCastPoint()
	return self:GetRightfulKV("AbilityCastPoint")
end

function vanilla_baseclass:GetCastRange(location, target)
	return self:GetRightfulKV("AbilityCastRange")
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
