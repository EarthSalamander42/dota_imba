--[[Author: d2imba
	Date: 10.03.2015.]]

function Enfeeble( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- get target's attributes
	local target_str = target:GetStrength()
	local target_agi = target:GetAgility()
	local target_int = target:GetIntellect()
	
	local reduce_factor = ability:GetLevelSpecialValueFor("stat_reduction", ability_level) / 100
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)

	-- calculate reductions
	local reduction_str = target_str * reduce_factor
	local reduction_agi = target_agi * reduce_factor
	local reduction_int = target_int * reduce_factor

	-- apply reductions
	target:ModifyStrength(reduction_str)
	target:ModifyAgility(reduction_agi)
	target:ModifyIntellect(reduction_int)

	-- restore regular attribute values after the duration elapses
	Timers:CreateTimer(duration, function()
		target:ModifyStrength(-reduction_str)
		target:ModifyAgility(-reduction_agi)
		target:ModifyIntellect(-reduction_int)
		end)
end

function BrainSapManaDrain( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local mana_to_steal = ability:GetLevelSpecialValueFor("mana_steal_amt", ability_level)

	target:ReduceMana(mana_to_steal)
	caster:GiveMana(mana_to_steal)
end

function BrainSapSpellCast( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local casted_ability = caster:GetCurrentActiveAbility()
	local casted_ability_index = casted_ability:GetAbilityIndex()
	local no_mana_sound = keys.no_mana_sound
	local ability_level = ability:GetLevel() - 1

	local spell_cost = casted_ability:GetManaCost(casted_ability_index)
	local caster_mana = caster:GetMana()
	local mana_multiplier = ability:GetLevelSpecialValueFor("mana_multiplier", ability_level) / 100
	local true_mana_cost = (mana_multiplier + 1) * spell_cost

	--if caster_mana < true_mana_cost then
	--	print ("no mana")
	--	EmitSoundOn(no_mana_sound, caster)
	--	caster:Stop()	
	--else
		caster:SpendMana(true_mana_cost - spell_cost, casted_ability)
	--end
end

function FiendsGripManaDrain( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local scepter = HasScepter(caster)
	local mana_drain = ability:GetLevelSpecialValueFor("fiends_grip_mana_drain", (ability:GetLevel() -1)) / 100
	local target_max_mana = target:GetMaxMana()
	
	if scepter == true then
		mana_drain = ability:GetLevelSpecialValueFor("fiends_grip_mana_drain_scepter", (ability:GetLevel() -1)) / 100
	end

	local actual_mana_drained = mana_drain * target_max_mana
	
	target:ReduceMana(actual_mana_drained)
	caster:GiveMana(actual_mana_drained)
end

function FiendsGripStopChannel( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.modifier
	local sound1 = keys.sound1
	local sound2 = keys.sound2
	local scepter = HasScepter(caster)
	local max_duration = ability:GetLevelSpecialValueFor("fiends_grip_duration", (ability:GetLevel() -1))

	if scepter == true then
		max_duration = ability:GetLevelSpecialValueFor("fiends_grip_duration_scepter", (ability:GetLevel() -1))
	end

	local enemies_affected = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType() , 0, FIND_CLOSEST, false)
	local channel_time = GameRules:GetGameTime() - ability:GetChannelStartTime()

	if channel_time * 2 > max_duration then
		Timers:CreateTimer(max_duration - channel_time, function()
			for _,v in pairs(enemies_affected) do
				v:RemoveModifierByName(modifier)
				StopSoundEvent(sound1, v)
				StopSoundEvent(sound2, v)
			end
			end)
	else
		Timers:CreateTimer(channel_time, function()
			for _,v in pairs(enemies_affected) do
				v:RemoveModifierByName(modifier)
				StopSoundEvent(sound1, v)
				StopSoundEvent(sound2, v)
			end
			end)
	end
end

function FiendsGripNightmare( keys )
	local caster = keys.caster
	local scepter = HasScepter(caster)

	if scepter == true then
		local target = keys.target
		local ability = keys.ability
		local player_index = caster:GetPlayerID()
		local ability_nightmare = caster:FindAbilityByName(keys.ability_nightmare)
		local sound_nightmare = keys.sound_nightmare
		local modifier = keys.modifier_nightmare
		local ability_level = ability:GetLevel() - 1

		local vision_radius = ability:GetLevelSpecialValueFor("fiends_grip_nightmare_radius", ability_level)
		local vision_cone = ability:GetLevelSpecialValueFor("fiends_grip_nightmare_vision_cone", ability_level)
		local caster_location = caster:GetAbsOrigin()
		local enemies_to_check = FindUnitsInRadius(target:GetTeam(), caster_location, nil, vision_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType() , 0, FIND_CLOSEST, false)
		
		for _,v in pairs(enemies_to_check) do
			caster_location = caster:GetAbsOrigin()
			local target_location = v:GetAbsOrigin()
			local direction = (caster_location - target_location):Normalized()
			local forward_vector = v:GetForwardVector()
			local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y)
			if angle <= vision_cone/2 then
				ability:ApplyDataDrivenModifier(caster, v, modifier, {})
			end
		end
	end
end

function NightmareDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	local target_health = target:GetHealth()
	local damage = ability:GetAbilityDamage()

	-- Check if the damage would be lethal
	-- If it is lethal then deal pure damage
	if target_health < damage + 1 then
		local damage_table = {}

		damage_table.attacker = caster
		damage_table.victim = target
		damage_table.ability = ability
		damage_table.damage_type = ability:GetAbilityDamageType()
		damage_table.damage = damage

		ApplyDamage(damage_table)
	else
		-- Otherwise just set the health to be lower
		target:SetHealth(target_health - damage)
	end
end

--[[Author: Pizzalol, chrislotix
	Date: 12.02.2015.
	Checks if the target thats about to be attacked has the Nightmare debuff
	If it does then we transfer the debuff and stop both units from taking any action]]
function NightmareBreak( keys )
	local caster = keys.caster
	local target = keys.target
	local attacker = keys.attacker -- need to test local attacker(works) and local caster(not needed)
	local ability = keys.ability
	local nightmare_modifier = keys.nightmare_modifier

	-- Check if it has the Nightmare debuff
	if target:HasModifier(nightmare_modifier) then
		
		-- If it does then remove the modifier from the target and apply it to the attacker
		--target:RemoveModifierByName(nightmare_modifier)
		ability:ApplyDataDrivenModifier(caster, attacker, nightmare_modifier, {})

		-- Stop any action on both units after transfering the debuff to prevent
		-- it from chaining endlessly
		Timers:CreateTimer(0.03, function()
			local order_target = 
			{
				UnitIndex = target:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = target:GetAbsOrigin()
			}
			local order_attacker = 
			{
				UnitIndex = attacker:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = attacker:GetAbsOrigin()
			}

			ExecuteOrderFromTable(order_attacker)
			ExecuteOrderFromTable(order_target)		
		end)
	end
end

--[[Author: Pizzalol
	Date: 12.02.2015.
	Acts as an aura which applies a debuff on the target
	the debuff does the NightmareBreak function calls]]
function NightmareAura( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier

	local aura_radius = ability:GetLevelSpecialValueFor("aura_radius", ability:GetLevel() - 1)

	local units = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, aura_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false)

	for _,v in pairs(units) do
		if v ~= target then
			ability:ApplyDataDrivenModifier(caster, v, modifier, {duration = 0.5})
		end
	end
end

--[[Author: Pizzalol
	Date: 12.02.2015.
	Stops the sound from playing]]
function NightmareStopSound( keys )
	local target = keys.target
	local sound = keys.sound

	StopSoundEvent(sound, target)
end

--[[Author: Pizzalol
	Date: 12.02.2015.
	Checks if the target that we applied the Nightmare debuff on is the caster
	if it is the caster then we give him the ability to break the Nightmare and on calls
	where the Nightmare ends then it reverts the abilities]]
function NightmareCasterCheck( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local check_ability = keys.check_ability
	local invul_modifier = keys.invul_modifier
	local invul_duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)

	-- If it is the caster then swap abilities
	if target == caster then
		-- Grant Bane invulnerability for Nightmare's duration
		ability:ApplyDataDrivenModifier(caster, caster, invul_modifier, {duration = invul_duration})
		-- Swap sub_ability
		local sub_ability_name = keys.sub_ability_name
		local main_ability_name = keys.main_ability_name

		caster:SwapAbilities(main_ability_name, sub_ability_name, false, true)

		-- Sets the level of the ability that we swapped 
		if main_ability_name == check_ability then
			local level_ability = caster:FindAbilityByName(sub_ability_name)
			level_ability:SetLevel(1)
		end
	end
end

--[[Author: Pizzalol
	Date: 12.02.2015.
	Turns of the toggle of the ability]]
function NightmareCasterEnd( keys )
	local caster = keys.caster
	local ability = keys.ability

	ability:ToggleAbility()
end
