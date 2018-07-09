modifier_mutation_speed_freaks = class({})

function modifier_mutation_speed_freaks:IsHidden() return true end
function modifier_mutation_speed_freaks:RemoveOnDeath() return false end
function modifier_mutation_speed_freaks:IsPurgable() return false end

function modifier_mutation_speed_freaks:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MOVESPEED_MAX,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS
	}
	return funcs
end

function modifier_mutation_speed_freaks:GetModifierProjectileSpeedBonus()
	return 500
end

function modifier_mutation_speed_freaks:GetModifierMoveSpeedBonus_Constant()
	return 250
end

function modifier_mutation_speed_freaks:GetModifierMoveSpeed_Max()
	return 1000
end

function modifier_mutation_speed_freaks:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end