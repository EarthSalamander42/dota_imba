--[[	Authors: D2imba and Pizzalol
		Date: 23.05.2015				]]

function Blur( keys )
	local caster = keys.caster
	local ability = keys.ability
	local casterLocation = caster:GetAbsOrigin()
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))

	local enemyHeroes = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)

	if #enemyHeroes>0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_blur_enemy_datadriven", {})
	else
		if caster:HasModifier("modifier_blur_enemy_datadriven") then
			caster:RemoveModifierByName("modifier_blur_enemy_datadriven")
		end
	end
end