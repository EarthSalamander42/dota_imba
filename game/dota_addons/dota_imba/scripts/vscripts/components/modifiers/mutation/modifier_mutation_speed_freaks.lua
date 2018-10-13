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

function modifier_mutation_speed_freaks:OnCreated()
	self:SetStackCount(CustomNetTables:GetTableValue("mutation_info", "speed_freaks")["1"])
end

function modifier_mutation_speed_freaks:GetModifierProjectileSpeedBonus()
	return _G.IMBA_MUTATION_SPEED_FREAKS_PROJECTILE_SPEED
end

function modifier_mutation_speed_freaks:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

function modifier_mutation_speed_freaks:GetModifierMoveSpeed_Max()
	return _G.IMBA_MUTATION_SPEED_FREAKS_MAX_MOVESPEED
end

function modifier_mutation_speed_freaks:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end
