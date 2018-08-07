modifier_mutation_speed_freaks = class({})

function modifier_mutation_speed_freaks:IsHidden() return false end
function modifier_mutation_speed_freaks:RemoveOnDeath() return false end
function modifier_mutation_speed_freaks:IsPurgable() return false end
function modifier_mutation_speed_freaks:GetTexture() return "item_travel_boots" end

function modifier_mutation_speed_freaks:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MOVESPEED_MAX,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS
	}
	return funcs
end

function modifier_mutation_speed_freaks:OnCreated(keys)
--	self.projectile_speed = keys.projectile_speed
--	self.movespeed_pct = keys.movespeed_pct
--	self.max_movespeed = keys.max_movespeed
	self.projectile_speed = 500
	self:SetStackCount(50)
	self.max_movespeed = 1000
end

function modifier_mutation_speed_freaks:GetModifierProjectileSpeedBonus()
	return self.projectile_speed
end

function modifier_mutation_speed_freaks:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

function modifier_mutation_speed_freaks:GetModifierMoveSpeed_Max()
	return self.max_movespeed
end

function modifier_mutation_speed_freaks:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end
