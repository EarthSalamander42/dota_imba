--[[	Author: Firetoad
		Date: 09.03.2016	]]

function ShadowWord( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast_good = keys.sound_cast_good
	local sound_cast_bad = keys.sound_cast_bad
	local sound_target = keys.sound_target
	local modifier_buff = keys.modifier_buff
	local modifier_debuff = keys.modifier_debuff
	
	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end
	
	-- If the target is an ally, use "good" sound/modifier
	if caster:GetTeam() == target:GetTeam() then

		-- Play cast sound
		caster:EmitSound(sound_cast_good)

		-- Apply modifier
		ability:ApplyDataDrivenModifier(caster, target, modifier_buff, {})
		
	-- Else, use "bad" sound/modifier
	else

		-- Play cast sound
		caster:EmitSound(sound_cast_bad)

		-- Apply modifier
		ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})
	end


	-- Mark target for later explosion
	target.shadow_word_explosion_target = true

	-- Start or reset looping debuff sound
	target:StopSound(sound_target)
	target:EmitSound(sound_target)
end

function ShadowWordTickGood( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_stacks = keys.modifier_stacks

	-- If the ability was unlearned, remove existing stacks and exit
	if not ability then
		target:RemoveModifierByName(modifier_stacks)
		return nil
	end

	-- Parameters
	local ability_level = ability:GetLevel() - 1
	local tick_damage = ability:GetLevelSpecialValueFor("tick_damage", ability_level)
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)
	
	-- Apply healing
	target:Heal(tick_damage, caster)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, tick_damage, nil)

	-- Add a stack of the buff/debuff if below maximum amount of stacks
	if target:GetModifierStackCount(modifier_stacks, caster) < max_stacks then
		AddStacks(ability, caster, target, modifier_stacks, 1, true)
	end
end

function ShadowWordTickBad( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_stacks = keys.modifier_stacks

	-- If the ability was unlearned, remove existing stacks and exit
	if not ability then
		target:RemoveModifierByName(modifier_stacks)
		return nil
	end

	-- Parameters
	local ability_level = ability:GetLevel() - 1
	local tick_damage = ability:GetLevelSpecialValueFor("tick_damage", ability_level)
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)
	
	-- Apply damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = tick_damage, damage_type = DAMAGE_TYPE_MAGICAL})
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, tick_damage, nil)

	-- Add a stack of the buff/debuff if below maximum amount of stacks
	if target:GetModifierStackCount(modifier_stacks, caster) < max_stacks then
		AddStacks(ability, caster, target, modifier_stacks, 1, true)
	end
end

function ShadowWordExplode( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local particle_explode = keys.particle_explode
	local sound_explode = keys.sound_explode
	local sound_cast_good = keys.sound_cast_good
	local sound_cast_bad = keys.sound_cast_bad
	local sound_target = keys.sound_target
	local modifier_buff = keys.modifier_buff
	local modifier_debuff = keys.modifier_debuff
	local modifier_stacks = keys.modifier_stacks

	-- If the ability was unlearned, remove existing stacks and exit
	if not ability then
		target:RemoveModifierByName(modifier_stacks)
		return nil
	end

	-- Parameters
	local ability_level = ability:GetLevel() - 1
	local spread_aoe = ability:GetLevelSpecialValueFor("spread_aoe", ability_level)
	local creep_chance = ability:GetLevelSpecialValueFor("creep_chance", ability_level)
	local target_loc = target:GetAbsOrigin()
	local affected_count = 0

	-- Remove existing stacks
	target:RemoveModifierByName(modifier_stacks)

	-- Stop playing sound loop
	target:StopSound(sound_target)

	-- If this is the original target, explode
	if target.shadow_word_explosion_target then

		-- Play explosion sound
		target:EmitSound(sound_explode)

		-- Play explosion particle
		local explosion_pfx = ParticleManager:CreateParticle(particle_explode, PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControl(explosion_pfx, 0, target_loc)

		-- Find nearby allies
		local nearby_allies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, spread_aoe, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		-- Find nearby enemies
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, spread_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		-- If allies are nearby, play "good" cast sound and apply modifier to them
		if #nearby_allies > 0 then
			
			-- Play sound
			target:EmitSound(sound_cast_good)

			-- Apply modifier
			for _,ally in pairs(nearby_allies) do

				-- Do not re-apply to the original target
				if ally ~= target then
					ability:ApplyDataDrivenModifier(caster, ally, modifier_buff, {})
				end
			end
		end

		-- If enemies are nearby, play "bad" cast sound and apply modifier to them
		if #nearby_enemies > 0 then
			
			-- Play sound
			target:EmitSound(sound_cast_bad)

			-- Apply modifier
			for _,enemy in pairs(nearby_enemies) do

				-- Do not re-apply to the original target
				if enemy ~= target then
					ability:ApplyDataDrivenModifier(caster, enemy, modifier_debuff, {})
				end
			end
		end
	end
	
	-- Clean-up explosion target
	target.shadow_word_explosion_target = nil
end

function Upheaval( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_loop = keys.sound_loop
	local modifier_tower = keys.modifier_tower
	local particle_aura = keys.particle_aura

	-- Parameters
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local health = ability:GetLevelSpecialValueFor("health", ability_level)
	local slow_radius = ability:GetLevelSpecialValueFor("slow_radius", ability_level)
	local player_id = false

	-- Nonhero caster handling (e.g. Nether Ward)
	if caster:IsRealHero() then
		player_id = caster:GetPlayerID()
	end

	-- Spawn the Upheaval Tower
	local upheaval_tower = CreateUnitByName("npc_imba_warlock_upheaval_tower", target, false, caster, caster, caster:GetTeam())
	FindClearSpaceForUnit(upheaval_tower, target, true)
	if player_id then
		upheaval_tower:SetControllableByPlayer(player_id, true)
	end

	-- Keep track of current slow level
	upheaval_tower.current_upheaval_stack_power = 1

	-- Face the same direction as the caster
	upheaval_tower:SetForwardVector(caster:GetForwardVector())

	-- Increase health according to ability level
	SetCreatureHealth(upheaval_tower, health, true)

	-- Prevent nearby units from getting stuck
	Timers:CreateTimer(0.01, function()
		local units = FindUnitsInRadius(caster:GetTeamNumber(), upheaval_tower:GetAbsOrigin(), nil, 128, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		for _,unit in pairs(units) do
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
		end
	end)

	-- Apply the appropriate modifiers
	upheaval_tower:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
	upheaval_tower:AddNewModifier(caster, ability, "modifier_rooted", {})
	ability:ApplyDataDrivenModifier(caster, upheaval_tower, modifier_tower, {})

	-- Play cast sound
	upheaval_tower:EmitSound(sound_loop)

	-- Play aura particle
	upheaval_tower.upheaval_pfx = ParticleManager:CreateParticle(particle_aura, PATTACH_ABSORIGIN_FOLLOW, upheaval_tower)
	ParticleManager:SetParticleControl(upheaval_tower.upheaval_pfx, 0, upheaval_tower:GetAbsOrigin())
	ParticleManager:SetParticleControl(upheaval_tower.upheaval_pfx, 1, Vector(slow_radius, 0, 0))

	-- Start tower animation
	StartAnimation(upheaval_tower, {activity = ACT_DOTA_IDLE, rate = 1.0})

	-- Stop the particle if the tower's duration expires naturally
	Timers:CreateTimer(duration, function()
		ParticleManager:DestroyParticle(upheaval_tower.upheaval_pfx, false)
	end)
end

function UpheavalTowerDamage( keys )
	local attacker = keys.attacker
	local tower = keys.target
	local ability = keys.ability
	local sound_loop = keys.sound_loop
	local sound_end = keys.sound_end

	-- If the ability was unlearned, destroy the tower
	if not ability then

		-- Stop looping sound and play destruction sound
		tower:StopSound(sound_loop)
		tower:EmitSound(sound_end)

		-- Destroy aura particle
		ParticleManager:DestroyParticle(tower.upheaval_pfx, false)

		-- Play death animation
		StartAnimation(tower, {activity = ACT_DOTA_DIE, rate = 1.0})

		-- Destroy the tower
		tower:Kill(ability, attacker)
		return nil
	end
	
	-- Parameters
	local damage = 1
	
	-- If the attacker is a hero, tower, or Roshan, deal more damage
	if attacker:IsHero() or attacker:IsTower() or IsRoshan(attacker) then
		damage = ability:GetLevelSpecialValueFor("hero_damage", ability:GetLevel() - 1)
	end

	-- If the damage is enough to kill the tower, destroy it
	if tower:GetHealth() <= damage then

		-- Stop looping sound and play destruction sound
		tower:StopSound(sound_loop)
		tower:EmitSound(sound_end)

		-- Destroy aura particle
		ParticleManager:DestroyParticle(tower.upheaval_pfx, false)

		-- Play death animation
		StartAnimation(tower, {activity = ACT_DOTA_DIE, rate = 1.0})

		-- Destroy the tower
		tower:Kill(ability, attacker)

	-- Else, reduce its HP
	else
		tower:SetHealth(tower:GetHealth() - damage)
	end
end

function UpheavalTowerAura( keys )
	local caster = keys.caster
	local tower = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_hero = keys.modifier_hero
	local modifier_creep = keys.modifier_creep

	-- Parameters
	local slow_radius = ability:GetLevelSpecialValueFor("slow_radius", ability_level)

	-- Find enemies in the aura's radius
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), tower:GetAbsOrigin(), nil, slow_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(nearby_enemies) do
		
		-- If this is a hero, use the hero particle
		if enemy:IsHero() then
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_hero, {})
			enemy:SetModifierStackCount(modifier_hero, caster, math.max(enemy:GetModifierStackCount(modifier_hero, caster), tower.current_upheaval_stack_power))

		-- Else, use the creep particle
		else
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_creep, {})
			enemy:SetModifierStackCount(modifier_creep, caster, math.max(enemy:GetModifierStackCount(modifier_creep, caster), tower.current_upheaval_stack_power))
		end
	end

	-- Increase stack amount
	tower.current_upheaval_stack_power = tower.current_upheaval_stack_power + 1
end

function ChaoticOfferingPreCast( keys )
	local caster = keys.caster
	local sound_precast = keys.sound_precast
	local particle_precast = keys.particle_precast

	-- Plays pre-cast sound and particle
	caster:EmitSound(sound_precast)
	local staff_pfx = ParticleManager:CreateParticle(particle_precast, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(staff_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
end

function ChaoticOffering( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_initial = keys.particle_initial
	local particle_secondary = keys.particle_secondary
	local particle_golem = keys.particle_golem
	local particle_golem_4 = keys.particle_golem_4
	local particle_golem_5 = keys.particle_golem_5
	local modifier_golem = keys.modifier_golem
	local modifier_main_golem = keys.modifier_main_golem
	local scepter = HasScepter(caster)

	-- Parameters
	local stun_radius = ability:GetLevelSpecialValueFor("stun_radius", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local effect_delay = ability:GetLevelSpecialValueFor("effect_delay", ability_level)
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local base_health = ability:GetLevelSpecialValueFor("base_health", ability_level)
	local health_per_level = ability:GetLevelSpecialValueFor("health_per_level", ability_level)
	local player_id = false

	-- Nonhero caster handling (e.g. Nether Ward)
	if caster:IsRealHero() then
		player_id = caster:GetPlayerID()
	end

	-- Grant vision on the target area
	ability:CreateVisibilityNode(target, stun_radius, stun_duration)

	-- Create particle/sound dummy
	local dummy_unit = CreateUnitByName("npc_dummy_unit", target, false, nil, nil, caster:GetTeamNumber())

	-- Roll for an infernal model
	local infernal_ambient_particle
	local infernal_model = RandomInt(1, 4)
	if infernal_model == 4 then
		infernal_ambient_particle = particle_golem_4
	else
		infernal_ambient_particle = particle_golem
	end

	-- Play impact sound
	if RandomInt(1, 100) <= 10 then

		-- YOU FACE JARAXXUS! Adjust model and particles
		infernal_ambient_particle = particle_golem_5
		infernal_model = 5
		Timers:CreateTimer(effect_delay, function()
			if scepter then
				dummy_unit:EmitSound("Imba.WarlockYouFaceJaraxxusLong")
			else
				dummy_unit:EmitSound("Imba.WarlockYouFaceJaraxxus")
			end
		end)

	-- No Jaraxxus. Sad.
	else
		dummy_unit:EmitSound(sound_cast)
	end

	-- Play initial particle
	local initial_pfx = ParticleManager:CreateParticle(particle_initial, PATTACH_ABSORIGIN_FOLLOW, dummy_unit)
	ParticleManager:SetParticleControl(initial_pfx, 0, target)

	-- Stun nearby enemies
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(nearby_enemies) do
		enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
	end

	-- Wait [effect_delay] seconds
	Timers:CreateTimer(effect_delay, function()

		-- Play impact particle
		local impact_pfx = ParticleManager:CreateParticle(particle_secondary, PATTACH_ABSORIGIN_FOLLOW, dummy_unit)
		ParticleManager:SetParticleControl(impact_pfx, 0, target)
		ParticleManager:SetParticleControl(impact_pfx, 1, Vector(stun_radius, 0, 0))

		-- Destroy trees
		GridNav:DestroyTreesAroundPoint(target, stun_radius, false)

		-- Spawn the infernal
		local infernal = CreateUnitByName("npc_imba_warlock_golem_"..infernal_model, target, false, caster, caster, caster:GetTeam())
		FindClearSpaceForUnit(infernal, target, true)
		if player_id then
			infernal:SetControllableByPlayer(player_id, true)
		end

		-- Face the same direction as the caster
		infernal:SetForwardVector(caster:GetForwardVector())

		-- Increase health according to ability level
		SetCreatureHealth(infernal, base_health + health_per_level * caster:GetLevel(), true)

		-- Prevent nearby units from getting stuck
		Timers:CreateTimer(0.01, function()
			local units = FindUnitsInRadius(caster:GetTeamNumber(), infernal:GetAbsOrigin(), nil, 128, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
			for _,unit in pairs(units) do
				FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
			end
		end)

		-- Apply the appropriate modifiers
		infernal:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
		ability:ApplyDataDrivenModifier(caster, infernal, modifier_golem, {})

		-- Level up abilities
		local ability_flaming_fists = infernal:FindAbilityByName("imba_warlock_flaming_fists")
		ability_flaming_fists:SetLevel(1)
		local ability_permanent_immolation = infernal:FindAbilityByName("imba_warlock_permanent_immolation")
		ability_permanent_immolation:SetLevel(1)

		-- Multi golem handling (for refresher orb or frantic mode)
		if not caster.chaotic_offering_main_golem_summoned then
			caster.chaotic_offering_main_golem_summoned = true
			ability:ApplyDataDrivenModifier(caster, infernal, modifier_main_golem, {})
		end

		-- Fire infernal ambient particles according to the chosen model
		if infernal_model == 1 or infernal_model == 2 then
			local ambient_pfx = ParticleManager:CreateParticle(infernal_ambient_particle, PATTACH_ABSORIGIN_FOLLOW, infernal)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 0, infernal, PATTACH_POINT_FOLLOW, "attach_mane1", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 1, infernal, PATTACH_POINT_FOLLOW, "attach_mane2", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 2, infernal, PATTACH_POINT_FOLLOW, "attach_mane3", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 3, infernal, PATTACH_POINT_FOLLOW, "attach_mane4", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 4, infernal, PATTACH_POINT_FOLLOW, "attach_mane5", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 5, infernal, PATTACH_POINT_FOLLOW, "attach_mane6", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 6, infernal, PATTACH_POINT_FOLLOW, "attach_mane7", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 7, infernal, PATTACH_POINT_FOLLOW, "attach_mane8", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 10, infernal, PATTACH_POINT_FOLLOW, "attach_hand_r", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 11, infernal, PATTACH_POINT_FOLLOW, "attach_hand_l", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 12, infernal, PATTACH_POINT_FOLLOW, "attach_mouthFire", infernal:GetAbsOrigin(), true)
		elseif infernal_model == 3 then
			local ambient_pfx = ParticleManager:CreateParticle(infernal_ambient_particle, PATTACH_ABSORIGIN_FOLLOW, infernal)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 0, infernal, PATTACH_POINT_FOLLOW, "attach_hitloc", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 1, infernal, PATTACH_POINT_FOLLOW, "attach_hitloc", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 2, infernal, PATTACH_POINT_FOLLOW, "attach_hitloc", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 3, infernal, PATTACH_POINT_FOLLOW, "attach_hitloc", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 4, infernal, PATTACH_POINT_FOLLOW, "attach_hitloc", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 5, infernal, PATTACH_POINT_FOLLOW, "attach_hitloc", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 6, infernal, PATTACH_POINT_FOLLOW, "attach_hitloc", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 7, infernal, PATTACH_POINT_FOLLOW, "attach_hitloc", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 10, infernal, PATTACH_POINT_FOLLOW, "attach_attack1", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 11, infernal, PATTACH_POINT_FOLLOW, "attach_attack2", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 12, infernal, PATTACH_POINT_FOLLOW, "attach_hitloc", infernal:GetAbsOrigin(), true)
		elseif infernal_model == 4 then
			local ambient_pfx = ParticleManager:CreateParticle(infernal_ambient_particle, PATTACH_ABSORIGIN_FOLLOW, infernal)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 12, infernal, PATTACH_POINT_FOLLOW, "attach_mouthFire", infernal:GetAbsOrigin(), true)
		elseif infernal_model == 5 then
			local ambient_pfx = ParticleManager:CreateParticle(particle_golem, PATTACH_ABSORIGIN_FOLLOW, infernal)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 0, infernal, PATTACH_POINT_FOLLOW, "attach_mouthFire", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 1, infernal, PATTACH_POINT_FOLLOW, "attach_mouthFire", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 2, infernal, PATTACH_POINT_FOLLOW, "attach_mouthFire", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 3, infernal, PATTACH_POINT_FOLLOW, "attach_mouthFire", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 4, infernal, PATTACH_POINT_FOLLOW, "attach_mouthFire", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 5, infernal, PATTACH_POINT_FOLLOW, "attach_mouthFire", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 6, infernal, PATTACH_POINT_FOLLOW, "attach_mouthFire", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 7, infernal, PATTACH_POINT_FOLLOW, "attach_mouthFire", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 10, infernal, PATTACH_POINT_FOLLOW, "attach_hand_r", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 11, infernal, PATTACH_POINT_FOLLOW, "attach_hand_l", infernal:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 12, infernal, PATTACH_POINT_FOLLOW, "attach_mouthFire", infernal:GetAbsOrigin(), true)
		end

		-- If the golem's item table isn't created yet, do it
		if not caster.chaotic_offering_golem_items then
			caster.chaotic_offering_golem_items = {}
		end

		-- Equip the golem with any previously existing items
		for i = 0, 5 do 
			local current_item = caster.chaotic_offering_golem_items[i]
			if current_item == nil then
				infernal:AddItem(CreateItem("item_imba_dummy", nil, nil))
			else
				-- Main golem gets real items
				if infernal:HasModifier(modifier_main_golem) then
					infernal:AddItem(current_item)

				-- Secondaries get copies
				else
					infernal:AddItem(CreateItem(current_item:GetAbilityName(), nil, nil))
				end
			end
		end

		-- If this is the main golem, destroy the slot-organizing dummies
		if infernal:HasModifier(modifier_main_golem) then
			for i = 0, 5 do
				local current_item = infernal:GetItemInSlot(i)
				if current_item:GetAbilityName() == "item_imba_dummy" then
					infernal:RemoveItem(current_item)
				end
			end
		end

		-- Destroy the sound/particle dummy after 3 seconds
		dummy_unit:AddNewModifier(caster, ability, "modifier_kill", {duration = 3})
	end)

	-- If the caster has a scepter, spawn lesser infernals after a small delay
	if scepter then

		-- Parameters
		local particle_small_1 = keys.particle_small_1
		local particle_small_2 = keys.particle_small_2
		local secondary_delay = ability:GetLevelSpecialValueFor("secondary_delay", ability_level)
		local stun_scepter = ability:GetLevelSpecialValueFor("stun_scepter", ability_level)

		-- Infernal creation delay
		Timers:CreateTimer(secondary_delay, function()

			-- Stun nearby enemies again
			local secondary_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			for _,enemy in pairs(secondary_enemies) do
				enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_scepter})
			end

			-- Impact sound
			dummy_unit:EmitSound(sound_cast)
			
			-- Infernal creation loop
			for infernal_count = 0,4 do

				-- Spawn the infernals in a pentagram around the central one
				local small_target = RotatePosition(target, QAngle(0, -infernal_count * 360 / 5, 0), target + (target - caster:GetAbsOrigin()):Normalized() * stun_radius / 2)

				-- Particles dummy unit
				local small_dummy = CreateUnitByName("npc_dummy_unit", small_target, false, nil, nil, caster:GetTeamNumber())

				-- Particle part 1
				local initial_small_pfx = ParticleManager:CreateParticle(particle_small_1, PATTACH_ABSORIGIN_FOLLOW, small_dummy)
				ParticleManager:SetParticleControl(initial_small_pfx, 0, small_target)

				-- Destroy the sound/particle dummy after 3 seconds
				small_dummy:AddNewModifier(caster, ability, "modifier_kill", {duration = 3})

				-- [effect_delay] delay
				Timers:CreateTimer(effect_delay, function()
					
					-- Impact particle
					local impact_small_pfx = ParticleManager:CreateParticle(particle_small_2, PATTACH_ABSORIGIN_FOLLOW, small_dummy)
					ParticleManager:SetParticleControl(impact_small_pfx, 0, small_target)
					ParticleManager:SetParticleControl(impact_small_pfx, 1, Vector(stun_radius / 2, 0, 0))

					-- Spawn the infernal
					local infernal_small = CreateUnitByName("npc_imba_warlock_golem_extra", small_target, false, caster, caster, caster:GetTeam())
					FindClearSpaceForUnit(infernal_small, small_target, true)
					infernal_small:SetControllableByPlayer(player_id, true)

					-- Face the same direction as the caster
					infernal_small:SetForwardVector(caster:GetForwardVector())

					-- Prevent nearby units from getting stuck
					Timers:CreateTimer(0.01, function()
						local units = FindUnitsInRadius(caster:GetTeamNumber(), infernal_small:GetAbsOrigin(), nil, 128, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
						for _,unit in pairs(units) do
							FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
						end
					end)

					-- Apply the appropriate modifiers
					infernal_small:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})

					-- Level up abilities
					local ability_flaming_fists = infernal_small:FindAbilityByName("imba_warlock_flaming_fists")
					ability_flaming_fists:SetLevel(1)
					local ability_permanent_immolation = infernal_small:FindAbilityByName("imba_warlock_permanent_immolation")
					ability_permanent_immolation:SetLevel(1)
				end)
			end
		end)
	end
end

function ChaoticOfferingItemUpdate( keys )
	local infernal = keys.target
	local caster = infernal:GetOwnerEntity()

	-- Nonhero caster handling (e.g. Nether Ward)
	if not caster:IsRealHero() then
		return nil
	end
	
	-- Update the golem's persistent item table
	for i = 0, 5 do
		local current_item = infernal:GetItemInSlot(i)
		if current_item then
			if current_item:GetOwner() == infernal then
				caster.chaotic_offering_golem_items[i] = current_item
			else
				infernal:DropItemAtPositionImmediate(current_item, infernal:GetAbsOrigin())
				caster.chaotic_offering_golem_items[i] = nil
			end
		else
			caster.chaotic_offering_golem_items[i] = nil
		end
	end
end

function ChaoticOfferingGolemDeath( keys )
	local infernal = keys.target
	local caster = infernal:GetOwnerEntity()

	-- Nonhero caster handling (e.g. Nether Ward)
	if not caster:IsRealHero() then
		return nil
	end

	-- Free up space for a new main golem
	caster.chaotic_offering_main_golem_summoned = nil

	-- If the golem's item table isn't created yet, do it
	if not caster.chaotic_offering_golem_items then
		caster.chaotic_offering_golem_items = {}
	end
	
	-- Store the items currently in the golem for later
	for i = 0, 5 do
		local current_item = infernal:GetItemInSlot(i)
		if current_item then
			if current_item:GetOwner() == infernal then
				caster.chaotic_offering_golem_items[i] = current_item
			else
				caster.chaotic_offering_golem_items[i] = nil
			end
		else
			caster.chaotic_offering_golem_items[i] = nil
		end
	end
end

function GolemFlamingFists( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local damage_pct = ability:GetLevelSpecialValueFor("damage_pct", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)

	-- If the target is a building, do nothing
	if target:IsBuilding() then
		return nil
	end

	-- Calculate damage
	local damage = caster:GetAverageTrueAttackDamage(caster) * damage_pct / 100

	-- Damage enemies in the effect radius
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})
	end
end

function GolemPermanentImmolation( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local damage_pct = ability:GetLevelSpecialValueFor("damage_pct", ability_level)

	-- Calculate damage
	local damage = caster:GetMaxHealth() * damage_pct / 100

	-- Damage enemies in the effect radius
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end