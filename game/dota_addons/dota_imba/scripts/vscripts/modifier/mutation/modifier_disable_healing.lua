modifier_disable_healing = class({})

function modifier_disable_healing:IsHidden() return true end
function modifier_disable_healing:RemoveOnDeath() return false end

function modifier_disable_healing:DeclareFunctions()
	local funcs = 
	{
		[MODIFIER_PROPERTY_DISABLE_HEALING] = true,
	}

	return funcs
end

function modifier_disable_healing:GetDisableHealing()
	return 1
end
