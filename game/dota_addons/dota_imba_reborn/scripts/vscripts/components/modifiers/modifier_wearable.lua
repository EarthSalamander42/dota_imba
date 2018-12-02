modifier_wearable = class({})

function modifier_wearable:CheckState()
	local state = { 
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}

	return state
end

function modifier_wearable:IsPurgable()
	return false
end

function modifier_wearable:IsStunDebuff()
	return false
end

function modifier_wearable:IsPurgeException()
	return false
end

function modifier_wearable:IsHidden()
	return true
end
