--[[ 	Author: AtroCty
		Date: 
		15.09.2016	
		Last Update:
		15.09.2016			]]--

function blink_start(keys)
	local caster = keys.caster
	local ability = keys.ability
	local blink_effect = keys.blink_effect
	local blink_effect_end = keys.blink_effect_end
	local max_blink_range = ability:GetLevelSpecialValueFor("max_blink_range", 0)
	
	-- Disjointing everything
	ProjectileManager:ProjectileDodge(caster)
	
	-- Defining the color, either default or by command
	local color
	if caster.blinkcolor then
		color = caster.blinkcolor
	else
		-- Blueish, just a little brighter
		color = Vector(0, 20, 255)
	end
	
	-- Creating the particle & sound at the start-location
	local blink_pfx = ParticleManager:CreateParticle(blink_effect, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(blink_pfx, 15, color )
	ParticleManager:ReleaseParticleIndex(blink_pfx)
	caster:EmitSound("DOTA_Item.BlinkDagger.Activate")
	
	local origin_point = caster:GetAbsOrigin()
	local target_point = keys.target_points[1]
	local distance = (target_point - origin_point):Length2D()
	
	-- Set distance if targeted destiny is beyond range
	if distance > max_blink_range then

		-- Extra parameters
		local max_extra_distance = ability:GetLevelSpecialValueFor("max_extra_distance", 0)
		local max_extra_cooldown = ability:GetLevelSpecialValueFor("max_extra_cooldown", 0)

		-- Calculate total overshoot distance
		if distance > max_extra_distance then
			target_point = origin_point + (target_point - origin_point):Normalized() * max_extra_distance
			Timers:CreateTimer(0.03, function()
				ability:StartCooldown(ability:GetCooldownTimeRemaining() + max_extra_cooldown * GetCooldownReduction(caster))
			end)

		-- Calculate cooldown increase if between the two extremes
		else
			local extra_fraction = (distance - max_blink_range) / (max_extra_distance - max_blink_range)
			Timers:CreateTimer(0.03, function()
				ability:StartCooldown(ability:GetCooldownTimeRemaining() + max_extra_cooldown * extra_fraction * GetCooldownReduction(caster))
			end)
		end
	end
	
	-- Adding an extremely small timer for the particles, else they will only appear at the dest
	Timers:CreateTimer(0.01, function()
		caster:SetAbsOrigin(target_point)
		FindClearSpaceForUnit(caster, target_point, true)
		
		-- Create Particle on end-point
		local blink_end_pfx = ParticleManager:CreateParticle(blink_effect_end, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(blink_end_pfx, 15, color )
		ParticleManager:ReleaseParticleIndex(blink_end_pfx)
	end)
end

function blink_damaged(keys)
	local caster = keys.caster
	local ability = keys.ability
	local attacker_name = keys.attacker:GetName()
	local blink_damage_cooldown = ability:GetLevelSpecialValueFor("blink_damage_cooldown", 0)

	if keys.Damage > 0 and (attacker_name == "npc_dota_roshan" or keys.attacker:IsControllableByAnyPlayer()) and ( keys.attacker:GetTeam() ~= caster:GetTeam() ) then
		if ability:GetCooldownTimeRemaining() < blink_damage_cooldown then
			ability:StartCooldown(blink_damage_cooldown)
		end
	end
end