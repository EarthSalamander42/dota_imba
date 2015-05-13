function MeleeNecro1( keys )
	local target = keys.target
	local ability_1 = target:FindAbilityByName("necronomicon_warrior_mana_burn")
	local ability_2 = target:FindAbilityByName("necronomicon_warrior_last_will")

	ability_1:SetLevel(1)
	ability_2:SetLevel(1)
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), true)
end

function MeleeNecro2( keys )
	local target = keys.target
	local ability_1 = target:FindAbilityByName("necronomicon_warrior_mana_burn")
	local ability_2 = target:FindAbilityByName("necronomicon_warrior_last_will")

	ability_1:SetLevel(2)
	ability_2:SetLevel(2)
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), true)
end

function MeleeNecro3( keys )
	local target = keys.target
	local ability_1 = target:FindAbilityByName("necronomicon_warrior_mana_burn")
	local ability_2 = target:FindAbilityByName("necronomicon_warrior_last_will")

	ability_1:SetLevel(3)
	ability_2:SetLevel(3)
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), true)
end

function RangedNecro1( keys )
	local target = keys.target
	local ability_1 = target:FindAbilityByName("necronomicon_archer_mana_burn")
	local ability_2 = target:FindAbilityByName("necronomicon_archer_aoe")

	ability_1:SetLevel(1)
	ability_2:SetLevel(1)
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), true)
end

function RangedNecro2( keys )
	local target = keys.target
	local ability_1 = target:FindAbilityByName("necronomicon_archer_mana_burn")
	local ability_2 = target:FindAbilityByName("necronomicon_archer_aoe")

	ability_1:SetLevel(2)
	ability_2:SetLevel(2)
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), true)
end

function RangedNecro3( keys )
	local target = keys.target
	local ability_1 = target:FindAbilityByName("necronomicon_archer_mana_burn")
	local ability_2 = target:FindAbilityByName("necronomicon_archer_aoe")

	ability_1:SetLevel(3)
	ability_2:SetLevel(3)
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), true)
end

function NecroMinion( keys )
	local target = keys.target
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), true)
end