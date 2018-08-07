-- Carefully, DON'T use this for visible modifiers or with stack-handling!!!!!!!!!
-- This is only needed if the modifier has MODIFIER_ATTRIBUTE_MULTIPLE!
function CDOTA_Modifier_Lua:CheckUnique(bCreated)
	local hParent = self:GetParent()
	if bCreated then
		local mod = hParent:FindAllModifiersByName(self:GetName())
		if #mod >= 2 then
			self:SetStackCount(1)
			return true
		else
			self:SetStackCount(0)
			return false
		end
	else
		if self:GetStackCount() == 0 then
			local mod = hParent:FindModifierByName(self:GetName())
			if mod then
				mod:SetStackCount(0)
			end
		end
		return nil
	end
end
