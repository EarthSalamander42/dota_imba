modifier_command_restricted = class({})

--------------------------------------------------------------------------------

function modifier_command_restricted:IsHidden() return true end
function modifier_command_restricted:IsPurgable() return false end
function modifier_command_restricted:RemoveOnDeath() return false end

--------------------------------------------------------------------------------

function modifier_command_restricted:CheckState()
	local state = 
	{
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end
