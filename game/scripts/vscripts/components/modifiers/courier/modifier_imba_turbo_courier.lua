modifier_imba_turbo_courier = modifier_imba_turbo_courier or class({})

-- Modifier properties
function modifier_imba_turbo_courier:IsHidden()			return true end
function modifier_imba_turbo_courier:IsPurgable()		return false end
function modifier_imba_turbo_courier:RemoveOnDeath()	return false end

function modifier_imba_turbo_courier:CheckState() return {
	[MODIFIER_STATE_UNSLOWABLE] = true,
	[MODIFIER_STATE_FLYING] = true,
} end

function modifier_imba_turbo_courier:OnCreated()
	self.ideal_speed = 2100
end

-- Function declarations
function modifier_imba_turbo_courier:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
} end

-- Minimum unslowable movement speed
function modifier_imba_turbo_courier:GetModifierMoveSpeed_AbsoluteMin()
	return self.ideal_speed
end

function modifier_imba_turbo_courier:GetModifierIgnoreMovespeedLimit()
	return 1
end
