--[[ 	Author: D2imba
		Date: 11.05.2015	]]

function Void( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifier = keys.modifier

	local duration_day = ability:GetLevelSpecialValueFor("duration_day", (ability:GetLevel() - 1))
	local duration_night = ability:GetLevelSpecialValueFor("duration_night", (ability:GetLevel() - 1))

	if GameRules:IsDaytime() then
		ability:ApplyDataDrivenModifier(caster, target, modifier, {duration = duration_day})
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier, {duration = duration_night})
	end
end

function CripplingFear( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	local modifier_day = keys.modifier_day
	local modifier_night = keys.modifier_night

	if GameRules:IsDaytime() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_day, {})
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier_night, {})
	end
end

function HunterInTheNight( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.modifier
	local modifier_stack = keys.modifier_stack

	if not GameRules:IsDaytime() then
		if caster.hunter_in_the_night_stacks then
			ability:ApplyDataDrivenModifier(caster, caster, modifier_stack, {})
			caster:SetModifierStackCount(modifier_stack, ability, caster.hunter_in_the_night_stacks)
		end
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
	else
		if caster:HasModifier(modifier) then caster:RemoveModifierByName(modifier) end
		if caster:HasModifier(modifier_stack) then caster:RemoveModifierByName(modifier_stack) end
	end
end

function HunterInTheNightModelChange( keys )
	local caster = keys.caster
	local night_model = keys.night_model

	-- Stores the day model to revert to it later
	if not caster.hunter_in_the_night_day_model then
		caster.hunter_in_the_night_day_model = caster:GetModelName()
	end

	-- Changes the caster's model to its night mode
	caster:SetOriginalModel(night_model)
	caster:SetModel(night_model)
end

function HunterInTheNightModelRevert( keys )
	local caster = keys.caster

	-- Checking for errors
	if caster.hunter_in_the_night_day_model then
		caster:SetModel(caster.hunter_in_the_night_day_model)
		caster:SetOriginalModel(caster.hunter_in_the_night_day_model)
		caster.hunter_in_the_night_day_model = nil
	end
end

--[[	daytime 0-2 min is 0.25-0.49
		daytime 2-4 min is 0.50-0.74
		night 0-2 min is 0.75-0.99
		night 2-4 min is 0.00-0.24
		the whole cycle lasts 480 seconds	]]
function Darkness( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.modifier
	local modifier_enemy_vision = keys.modifier_enemy_vision
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )

	-- Increases the hunter in the night stack bonuses
	if not caster.hunter_in_the_night_stacks then
		caster.hunter_in_the_night_stacks = 0
	end

	caster.hunter_in_the_night_stacks = caster.hunter_in_the_night_stacks + 1

	-- Grants vision of all enemies for a duration on cast
	local enemy_heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for k,v in pairs(enemy_heroes) do
		ability:ApplyDataDrivenModifier(caster, v, modifier_enemy_vision, {})
	end

	-- Time variables
	local time_elapsed = 0

	-- Calculating what time of the day will it be after Darkness ends
	local start_time_of_day = GameRules:GetTimeOfDay()
	local end_time_of_day = start_time_of_day + duration / 480 --

	if end_time_of_day >= 1 then end_time_of_day = end_time_of_day - 1 end

	-- Setting it to the middle of the night
	GameRules:SetTimeOfDay(0)

	-- Using a timer to keep the time as middle of the night and once Darkness is over, normal day resumes
	Timers:CreateTimer(1, function()
		enemy_heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for k,v in pairs(enemy_heroes) do
			ability:ApplyDataDrivenModifier(caster, v, modifier, {})
		end
		if time_elapsed < duration then
			GameRules:SetTimeOfDay(0)
			time_elapsed = time_elapsed + 1
			return 1
		else
			GameRules:SetTimeOfDay(end_time_of_day)
			for k,v in pairs(enemy_heroes) do
				v:RemoveModifierByName(modifier)
			end
			return nil
		end
	end)
end

function DarknessLimitBreak( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Removes movement speed cap
	if not caster:HasModifier("modifier_bloodseeker_thirst") then
		caster:AddNewModifier(caster, ability, "modifier_bloodseeker_thirst", {})
	end

	-- Simulate attack speed cap removal
	RemoveAttackSpeedCap(caster)
end

function DarknessLimitBreakEnd( keys )
	local caster = keys.caster

	-- Returns movement speed cap
	caster:RemoveModifierByName("modifier_bloodseeker_thirst")

	-- Return attack speed cap
	ReturnAttackSpeedCap(caster)
end

function ReduceVision( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability:GetLevel() - 1 )
	
	-- Checks for Aghanim's Scepter
	if HasScepter(caster) then
		vision_radius = ability:GetLevelSpecialValueFor("vision_radius_scepter", ability:GetLevel() - 1 )
	end

	-- Saves the target's original vision range
	target.darkness_original_vision = target:GetBaseNightTimeVisionRange()

	target:SetNightTimeVisionRange(vision_radius)
end

function RevertVision( keys )
	local target = keys.target

	target:SetNightTimeVisionRange(target.darkness_original_vision)
end