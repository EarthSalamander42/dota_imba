--[[ 	Author: D2imba
		Date: 11.05.2015	]]

function Void( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifier = keys.modifier

	local duration_day = ability:GetLevelSpecialValueFor("duration_day", (ability:GetLevel() - 1))
	local duration_night = ability:GetLevelSpecialValueFor("duration_night", (ability:GetLevel() - 1))

	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end
	
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
	local modifier_mute = keys.modifier_mute

	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end
	
	if GameRules:IsDaytime() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_day, {})
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier_night, {})
		ability:ApplyDataDrivenModifier(caster, target, modifier_mute, {})
	end
end

function HunterInTheNight( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.modifier
	local modifier_stack = keys.modifier_stack
		
	-- If caster's passive are disabled by break, remove buff
	if caster:PassivesDisabled() then
		caster:RemoveModifierByName(modifier)
		return nil
	end
	
		
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
	local sound_cast = keys.sound_cast
	local modifier_enemy = keys.modifier_enemy
	local modifier_enemy_vision = keys.modifier_enemy_vision
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )

	-- Play meme sounds if appropriate
	local rand = RandomInt
	if USE_MEME_SOUNDS and rand(1, 100) <= 10 then
		caster:EmitSound("Imba.NightStalkerDarknessAlt0"..rand(1, 2))

	-- Else, use normal sound
	else
		caster:EmitSound(sound_cast)
	end

	-- Increase the hunter in the night stack bonuses
	if not caster.hunter_in_the_night_stacks then
		caster.hunter_in_the_night_stacks = 0
	end
	caster.hunter_in_the_night_stacks = caster.hunter_in_the_night_stacks + 1

	-- Apply vision reduction to all enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_enemy, {duration = duration})

		-- If this is a hero, grant vision of it for some seconds
		if enemy:IsRealHero() then
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_enemy_vision, {})
		end
	end

	-- Make it night for [duration] seconds
	SetTimeOfDayTemp(0, duration)
end

function DarknessLimitBreak( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_enemy = keys.modifier_enemy
	local modifier_caster = keys.modifier_caster

	-- Removes movement speed cap
	if not caster:HasModifier("modifier_imba_speed_limit_break") then
		caster:AddNewModifier(caster, ability, "modifier_imba_speed_limit_break", {})
	end

	-- Simulate attack speed cap removal
	IncreaseAttackSpeedCap(caster, 10000)

	-- Apply the enemy Darkness modifier to any enemies without it
	local remaining_duration = caster:FindModifierByName(modifier_caster):GetRemainingTime()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		if not enemy:HasModifier(modifier_enemy) then
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_enemy, {duration = remaining_duration})
		end
	end
end

function DarknessLimitBreakEnd( keys )
	local caster = keys.caster

	-- Returns movement speed cap
	caster:RemoveModifierByName("modifier_imba_speed_limit_break")

	-- Return attack speed cap
	RevertAttackSpeedCap(caster)
end

function ReduceVision( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability:GetLevel() - 1 )

	-- Saves the target's original vision range
	target.darkness_original_vision = target:GetBaseNightTimeVisionRange()

	-- If the target has more vision radius than Darkness' limit, reduce it
	if target:GetBaseNightTimeVisionRange() > vision_radius then
		target:SetNightTimeVisionRange(vision_radius)
	end
end

function RevertVision( keys )
	local target = keys.target

	target:SetNightTimeVisionRange(target.darkness_original_vision)
end