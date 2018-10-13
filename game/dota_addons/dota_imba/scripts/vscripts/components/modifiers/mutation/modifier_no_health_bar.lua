modifier_no_health_bar = class({})

function modifier_no_health_bar:IsHidden() return true end
function modifier_no_health_bar:RemoveOnDeath() return false end

function modifier_no_health_bar:CheckState()
	local state = 
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}

	return state
end
