--[[	Author: Firetoad
		Date: 24.10.2015	]]

function NetherBlast( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local sound_blast = keys.sound_blast
	local particle_pre_blast = keys.particle_pre_blast
	local particle_blast = keys.particle_blast
	local modifier_debuff = keys.modifier_debuff

	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local secondary_damage = ability:GetLevelSpecialValueFor("secondary_damage", ability_level)
	local secondary_delay = ability:GetLevelSpecialValueFor("secondary_delay", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local center_radius = ability:GetLevelSpecialValueFor("center_radius", ability_level)
	local secondary_blasts = ability:GetLevelSpecialValueFor("secondary_blasts", ability_level)

	-- Create sound dummy and play sound on it
	local nether_blast_dummy = CreateUnitByName("npc_dummy_unit", target, false, nil, nil, caster:GetTeamNumber())
	nether_blast_dummy:EmitSound(sound_cast)

	-- Play central blast particle
	local nether_blast_pfx = ParticleManager:CreateParticle(particle_blast, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleAlwaysSimulate(nether_blast_pfx)
	ParticleManager:SetParticleControl(nether_blast_pfx, 0, target)
	ParticleManager:SetParticleControl(nether_blast_pfx, 1, Vector(radius, 0, 0))

	-- Find enemies in the central blast area
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	-- Iterate through central blast enemies
	for _,enemy in pairs(enemies) do
		
		-- Apply debuff
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_debuff, {})

		-- Deal damage
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})			
	end

	-- Calculate secondary blast positions
	local caster_pos = caster:GetAbsOrigin()
	local forward_vector = (target - caster_pos):Normalized()
	local secondary_targets = {}
	for i = 1, secondary_blasts do
		secondary_targets[i] = RotatePosition(target, QAngle(0, (i - 1) * 360 / secondary_blasts, 0), target + forward_vector * (radius - center_radius))
	end

	-- Create pre-blast particles
	for _,blast_target in pairs(secondary_targets) do
		local secondary_blast_pre_pfx = ParticleManager:CreateParticle(particle_pre_blast, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleAlwaysSimulate(secondary_blast_pre_pfx)
		ParticleManager:SetParticleControl(secondary_blast_pre_pfx, 0, blast_target)
		ParticleManager:SetParticleControl(secondary_blast_pre_pfx, 1, Vector(1, secondary_delay, 1))
	end

	-- Delayed secondary blasts
	Timers:CreateTimer(secondary_delay, function()
		
		-- Play blast sound
		nether_blast_dummy:EmitSound(sound_blast)

		-- Destroy dummy after another frame
		Timers:CreateTimer(0.01, function()
			nether_blast_dummy:Destroy()
		end)

		-- Iterate through blast positions
		for _,blast_target in pairs(secondary_targets) do

			-- Play blast particles
			local secondary_blast_pfx = ParticleManager:CreateParticle(particle_blast, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleAlwaysSimulate(secondary_blast_pfx)
			ParticleManager:SetParticleControl(secondary_blast_pfx, 0, blast_target)
			ParticleManager:SetParticleControl(secondary_blast_pfx, 1, Vector(radius, 0, 0))

			-- Find enemies in each secondary blast area
			local secondary_enemies = FindUnitsInRadius(caster:GetTeamNumber(), blast_target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

			-- Iterate through secondary blast enemies
			for _,enemy in pairs(secondary_enemies) do
				
				-- Apply debuff
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_debuff, {})

				-- Deal damage
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = secondary_damage, damage_type = DAMAGE_TYPE_MAGICAL})			
			end
		end

	end)
end

function Decrepify( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sound_cast = keys.sound_cast
	local modifier_ally = keys.modifier_ally
	local modifier_enemy = keys.modifier_enemy

	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end
	
	-- Play cast sound
	target:EmitSound(sound_cast)

	-- Apply relevant modifier
	if target:GetTeam() == caster:GetTeam() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_ally, {})
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier_enemy, {})
	end

	-- Initialize damage counter if necessary
	if not target.decrepify_damage_counter then
		target.decrepify_damage_counter = 0
	end
end

function DecrepifyBlast( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_pre_blast = keys.sound_pre_blast
	local sound_blast = keys.sound_blast
	local particle_pre_blast = keys.particle_pre_blast
	local particle_blast = keys.particle_blast

	-- Parameters
	local blast_damage = ability:GetLevelSpecialValueFor("blast_damage", ability_level)
	local blast_delay = ability:GetLevelSpecialValueFor("blast_delay", ability_level)
	local blast_radius = ability:GetLevelSpecialValueFor("blast_radius", ability_level)
	local structure_damage = ability:GetLevelSpecialValueFor("structure_damage", ability_level)
	local blast_position = target:GetAbsOrigin()

	-- If total damage is zero, reset the damage counter and do nothing
	if target.decrepify_damage_counter == 0 then
		target.decrepify_damage_counter = nil
		return nil
	end

	-- Calculate damage to deal
	local damage = target.decrepify_damage_counter * blast_damage / 100

	-- Reset the damage counter
	target.decrepify_damage_counter = nil

	-- Play pre-blast sound
	target:EmitSound(sound_pre_blast)

	-- Create sound dummy for later
	local blast_dummy = CreateUnitByName("npc_dummy_unit", blast_position, false, nil, nil, caster:GetTeamNumber())

	-- Play pre-blast particle
	local pre_blast_pfx = ParticleManager:CreateParticle(particle_pre_blast, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleAlwaysSimulate(pre_blast_pfx)
	ParticleManager:SetParticleControl(pre_blast_pfx, 0, blast_position)
	ParticleManager:SetParticleControl(pre_blast_pfx, 1, Vector(1, blast_delay, 1))

	-- Wait for [delay] seconds
	Timers:CreateTimer(blast_delay, function()
		
		-- Play blast sound
		blast_dummy:EmitSound(sound_blast)

		-- Destroy dummy after another frame
		Timers:CreateTimer(0.01, function()
			blast_dummy:Destroy()
		end)

		-- Play blast particle
		local blast_pfx = ParticleManager:CreateParticle(particle_blast, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleAlwaysSimulate(blast_pfx)
		ParticleManager:SetParticleControl(blast_pfx, 0, blast_position)
		ParticleManager:SetParticleControl(blast_pfx, 1, Vector(blast_radius, 0, 0))

		-- Find enemies in blast area
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), blast_position, nil, blast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		-- Damage blasted enemies
		for _,enemy in pairs(enemies) do
			if enemy:IsBuilding() then
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage * structure_damage / 100, damage_type = DAMAGE_TYPE_MAGICAL})
			else
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})			
			end
		end
	end)
end

function NetherWard( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local ability_ward = keys.ability_ward
	
	-- Parameters
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local player_id = caster:GetPlayerID()

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Spawn the Nether Ward
	local nether_ward = CreateUnitByName("npc_imba_pugna_nether_ward_"..( ability_level + 1 ), target, false, caster, caster, caster:GetTeam())
	FindClearSpaceForUnit(nether_ward, target, true)
	nether_ward:SetControllableByPlayer(player_id, true)

	-- Prevent nearby units from getting stuck
	Timers:CreateTimer(0.01, function()
		local units = FindUnitsInRadius(caster:GetTeamNumber(), nether_ward:GetAbsOrigin(), nil, 128, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		for _,unit in pairs(units) do
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
		end
	end)

	-- Apply the Nether Ward duration modifier
	nether_ward:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
	nether_ward:AddNewModifier(caster, ability, "modifier_rooted", {})

	-- Grant the Nether Ward its aura ability
	local aura_ability = nether_ward:FindAbilityByName(ability_ward)
	aura_ability:SetLevel( ability_level + 1 )
end

function NetherWardDamage( keys )
	local ward = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability

	-- If the ability was unlearned, do nothing
	if not ability then
		ward:Kill(ability, attacker)
		return nil
	end
	
	-- Parameters
	local damage = 1
	
	-- If the attacker is a hero, deal more damage
	if (attacker:IsHero() or attacker:IsTower() or IsRoshan(attacker)) and not attacker:IsIllusion() then
		local ability_level = ability:GetLevel() - 1
		damage = ability:GetLevelSpecialValueFor("hero_damage", ability_level)
	end

	-- If the damage is enough to kill the ward, destroy it
	if ward:GetHealth() <= damage then
		ward:Kill(ability, attacker)

	-- Else, reduce its HP
	else
		ward:SetHealth(ward:GetHealth() - damage)
	end
end

function NetherWardZap( keys )
	local ward = keys.caster
	local caster = ward:GetOwnerEntity()
	local target = keys.unit
	local ability_zap = keys.ability
	local ability_zap_level = ability_zap:GetLevel() - 1
	local cast_ability = keys.event_ability
	local sound_zap = keys.sound_zap
	local sound_target = keys.sound_target
	local particle_heavy= keys.particle_heavy
	local particle_medium= keys.particle_medium
	local particle_light= keys.particle_light

	-- If there isn't a cast ability, or if its mana cost was zero, do nothing
	if not cast_ability or cast_ability:GetManaCost( cast_ability:GetLevel() - 1 ) == 0 then
		return nil
	end

	-- Parameters
	local mana_multiplier = ability_zap:GetLevelSpecialValueFor("mana_multiplier", ability_zap_level)
	local spell_damage = ability_zap:GetLevelSpecialValueFor("spell_damage", ability_zap_level)

	-- Fetch cast ability's mana cost
	local mana_spent = cast_ability:GetManaCost( cast_ability:GetLevel() - 1 ) / FRANTIC_MULTIPLIER

	-- Deal damage
	ApplyDamage({attacker = ward, victim = target, ability = ability_zap, damage = mana_spent * mana_multiplier, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Play zap sounds
	ward:EmitSound(sound_zap)
	target:EmitSound(sound_target)

	-- Play zap particle
	if mana_spent < 200 then
		local zap_pfx = ParticleManager:CreateParticle(particle_light, PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControlEnt(zap_pfx, 0, ward, PATTACH_POINT_FOLLOW, "attach_hitloc", ward:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(zap_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	elseif mana_spent < 400 then
		local zap_pfx = ParticleManager:CreateParticle(particle_medium, PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControlEnt(zap_pfx, 0, ward, PATTACH_POINT_FOLLOW, "attach_hitloc", ward:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(zap_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	else
		local zap_pfx = ParticleManager:CreateParticle(particle_heavy, PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControlEnt(zap_pfx, 0, ward, PATTACH_POINT_FOLLOW, "attach_hitloc", ward:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(zap_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	end

	-- If the ward does not have enough health to survive a spell cast, do nothing
	if ward:GetHealth() <= spell_damage then
		return nil
	end

	-- Ability replication
	local cast_ability_name = cast_ability:GetName()
	local forbidden_abilities = {
		"imba_pugna_nether_ward",
		"ancient_apparition_ice_blast",
		"furion_teleportation",
		"furion_wrath_of_nature",
		"imba_juggernaut_healing_ward",
		"imba_juggernaut_omni_slash",
		"imba_kunkka_x_marks_the_spot",
		"imba_lich_dark_ritual",
		"life_stealer_infest",
		"life_stealer_assimilate",
		"life_stealer_assimilate_eject",
		"imba_lina_fiery_soul",
		"imba_night_stalker_darkness",
		"imba_sandking_sand_storm",
		"imba_sandking_epicenter",
		"storm_spirit_static_remnant",
		"storm_spirit_ball_lightning",
		"imba_tinker_rearm",
		"imba_venomancer_plague_ward",
		"witch_doctor_voodoo_restoration",
		"imba_queenofpain_blink",
		"imba_jakiro_fire_breath",
		"imba_jakiro_ice_breath",
		"alchemist_unstable_concoction",
		"alchemist_chemical_rage",
		"ursa_overpower",
		"imba_bounty_hunter_wind_walk",
		"invoker_ghost_walk",
		"imba_clinkz_strafe",
		"imba_clinkz_skeleton_walk",
		"imba_clinkz_death_pact",
		"imba_obsidian_destroyer_arcane_orb",
		"imba_obsidian_destroyer_sanity_eclipse",
		"shadow_demon_shadow_poison",
		"shadow_demon_demonic_purge",
		"phantom_lancer_doppelwalk",
		"chaos_knight_phantasm",
		"imba_phantom_assassin_phantom_strike",
		"wisp_relocate",
		"templar_assassin_refraction",
		"templar_assassin_meld",
		"naga_siren_mirror_image",
		"imba_nyx_assassin_vendetta",
		"imba_centaur_stampede",
		"ember_spirit_activate_fire_remnant",
		"legion_commander_duel",
		"phoenix_fire_spirits",
		"terrorblade_conjure_image",
		"imba_techies_land_mines",
		"imba_techies_stasis_trap",
		"techies_suicide",
		"winter_wyvern_arctic_burn",
		"imba_wraith_king_kingdom_come",
		"imba_faceless_void_chronosphere",
		"magnataur_skewer",
		"imba_tinker_march_of_the_machines",
		"riki_blink_strike",
		"riki_tricks_of_the_trade",
		"imba_necrolyte_death_pulse",
		"beastmaster_call_of_the_wild",
		"beastmaster_call_of_the_wild_boar",
		"dark_seer_ion_shell",
		"dark_seer_wall_of_replica",
		"morphling_waveform",
		"morphling_adaptive_strike",
		"morphling_replicate",
		"morphling_morph_replicate",
		"morphling_hybrid",
		"leshrac_pulse_nova",
		"rattletrap_power_cogs",
		"rattletrap_rocket_flare",
		"rattletrap_hookshot",
		"spirit_breaker_charge_of_darkness",
		"shredder_timber_chain",
		"shredder_chakram",
		"shredder_chakram_2",
		"imba_enigma_demonic_conversion",
		"spectre_haunt",
		"windrunner_focusfire",
		"viper_poison_attack",
		"arc_warden_tempest_double",
		"broodmother_insatiable_hunger",
		"weaver_time_lapse",
		"death_prophet_exorcism",
		"treant_eyes_in_the_forest",
		"treant_living_armor",
		"enchantress_impetus",
		"chen_holy_persuasion",
		"batrider_firefly",
		"undying_decay",
		"undying_tombstone",
		"tusk_walrus_kick",
		"tusk_walrus_punch",
		"tusk_frozen_sigil",
		"gyrocopter_flak_cannon",
		"elder_titan_echo_stomp_spirit",
		"visage_soul_assumption",
		"visage_summon_familiars",
		"earth_spirit_geomagnetic_grip",
		"keeper_of_the_light_recall"
	}

	-- Ignore items
	if string.find(cast_ability_name, "item") then
		return nil
	end

	-- If the ability is on the list of uncastable abilities, do nothing
	for _,forbidden_ability in pairs(forbidden_abilities) do
		if cast_ability_name == forbidden_ability then
			return nil
		end
	end

	-- Look for the cast ability in the Nether Ward's own list
	local ability = ward:FindAbilityByName(cast_ability_name)
	
	-- If it was not found, add it to the Nether Ward
	if not ability then
		ward:AddAbility(cast_ability_name)
		ability = ward:FindAbilityByName(cast_ability_name)

	-- Else, activate it
	else
		ability:SetActivated(true)
	end

	-- Level up the ability
	ability:SetLevel(cast_ability:GetLevel())

	-- Refresh the ability
	ability:EndCooldown()

	local ability_range = ability:GetCastRange()
	local target_point = target:GetAbsOrigin()
	local ward_position = ward:GetAbsOrigin()

	-- Special cases
	-- Requiem of Souls: add souls before cast
	if cast_ability_name == "nevermore_requiem" then
		ward:AddAbility("nevermore_necromastery")
		local ability_souls = ward:FindAbilityByName("nevermore_necromastery")
		ward:AddNewModifier(ward, ability_souls, "modifier_nevermore_necromastery", {})
		ward:SetModifierStackCount("modifier_nevermore_necromastery", ward, 40)
	end

	-- Nether Strike: add greater bash
	if cast_ability_name == "spirit_breaker_nether_strike" then
		ward:AddAbility("spirit_breaker_greater_bash")
		local ability_bash = ward:FindAbilityByName("spirit_breaker_greater_bash")
		ability_bash:SetLevel(4)
	end

	-- Purification: remove omniguard
	if cast_ability_name == "imba_omniknight_purification" then
		ward:RemoveModifierByName("modifier_imba_purification_passive")
	end

	-- Meat Hook: ignore cast range
	if cast_ability_name == "imba_pudge_meat_hook" then
		ability_range = ability:GetLevelSpecialValueFor("base_range", ability:GetLevel() - 1)
	end

	-- Earth Splitter: ignore cast range
	if cast_ability_name == "elder_titan_earth_splitter" then
		ability_range = 25000
	end

	-- Storm Bolt: choose another target
	if cast_ability_name == "imba_sven_storm_bolt" then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), ward_position, nil, ability_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			if enemies[1]:FindAbilityByName("imba_sven_storm_bolt") then
				if #enemies > 1 then
					target = enemies[2]
				else
					return nil
				end
			else
				target = enemies[1]
			end
		else
			return nil
		end
	end

	-- Sun Strike: global cast range
	if cast_ability_name == "invoker_sun_strike" then
		ability_range = 25000
	end

	-- Eclipse: add lucent beam before cast
	if cast_ability_name == "luna_eclipse" then
		if not ward:FindAbilityByName("luna_lucent_beam") then
			ward:AddAbility("luna_lucent_beam")
		end
		local ability_lucent = ward:FindAbilityByName("luna_lucent_beam")
		ability_lucent:SetLevel(4)
	end

	-- Decide which kind of targetting to use
	local ability_behavior = ability:GetBehavior()
	local ability_target_team = ability:GetAbilityTargetTeam()

	-- If the ability is hidden, reveal it and remove the hidden binary sum
	if ability:IsHidden() then
		ability:SetHidden(false)
		ability_behavior = ability_behavior - 1
	end

	-- Memorize if an ability was actually cast
	local ability_was_used = false
	
	-- Toggle ability
	if ( ability_behavior - math.floor( ability_behavior / 512 ) * 512 ) == 0 then
		ability:ToggleAbility()
		ability_was_used = true

	-- Point target ability
	elseif ( ability_behavior - math.floor( ability_behavior / 16 ) * 16 ) == 0 then

		-- If the ability targets allies, use it on the ward's vicinity
		if ability_target_team == 1 then
			ExecuteOrderFromTable({ UnitIndex = ward:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_CAST_POSITION, Position = ward:GetAbsOrigin(), AbilityIndex = ability:GetEntityIndex(), Queue = queue})
			ability_was_used = true

		-- Else, use it as close as possible to the enemy
		else

			-- If target is not in range of the ability, use it on its general direction
			if (target_point - ward_position):Length2D() > ability_range then
				target_point = ward_position + (target_point - ward_position):Normalized() * (ability_range - 50)
			end
			ExecuteOrderFromTable({ UnitIndex = ward:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_CAST_POSITION, Position = target_point, AbilityIndex = ability:GetEntityIndex(), Queue = queue})
			ability_was_used = true
		end

	-- Unit target ability
	elseif ( ability_behavior - math.floor( ability_behavior / 8 ) * 8 ) == 0 then

		-- If the ability targets allies, use it on a random nearby ally
		if ability_target_team == 1 then
			
			-- Find nearby allies
			local allies = FindUnitsInRadius(caster:GetTeamNumber(), ward_position, nil, ability_range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

			-- If there is at least one ally nearby, cast the ability
			if #allies > 0 then
				ExecuteOrderFromTable({ UnitIndex = ward:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_CAST_TARGET, TargetIndex = allies[1]:GetEntityIndex(), AbilityIndex = ability:GetEntityIndex(), Queue = queue})
				ability_was_used = true
			end

		-- If not, try to use it on the original caster
		elseif (target_point - ward_position):Length2D() <= ability_range then
			ExecuteOrderFromTable({ UnitIndex = ward:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_CAST_TARGET, TargetIndex = target:GetEntityIndex(), AbilityIndex = ability:GetEntityIndex(), Queue = queue})
			ability_was_used = true

		-- If the original caster is too far away, cast the ability on a random nearby enemy
		else

			-- Find nearby enemies
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), ward_position, nil, ability_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

			-- If there is at least one ally nearby, cast the ability
			if #enemies > 0 then
				ExecuteOrderFromTable({ UnitIndex = ward:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_CAST_TARGET, TargetIndex = enemies[1]:GetEntityIndex(), AbilityIndex = ability:GetEntityIndex(), Queue = queue})
				ability_was_used = true
			end
		end

	-- No-target ability
	elseif ( ability_behavior - math.floor( ability_behavior / 4 ) * 4 ) == 0 then
		ability:CastAbility()
		ability_was_used = true
	end

	-- If an ability was actually used, reduce the ward's health
	if ability_was_used then
		ward:SetHealth(ward:GetHealth() - spell_damage)
	end

	-- Refresh the ability's cooldown and set it as inactive
	local cast_point = ability:GetCastPoint()
	Timers:CreateTimer(cast_point + 0.5, function()
		ability:SetActivated(false)
	end)
end

function LifeDrainCancelUpgrade( keys )
	local caster = keys.caster
	local ability_cancel = caster:FindAbilityByName(keys.ability_cancel)

	-- Upgrade the Life Drain Cancel ability
	if ability_cancel then
		ability_cancel:SetLevel(1)
	end
end

function LifeDrain( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local sound_target = keys.sound_target
	local modifier_enemy = keys.modifier_enemy
	local modifier_ally = keys.modifier_ally
	local scepter = HasScepter(caster)

	-- Parameters
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)

	
	-- Remove cooldown with scepter
	if scepter then
		ability:EndCooldown()
	end

	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end
	
	-- Play cast sounds
	caster:EmitSound(sound_cast)
	target:EmitSound(sound_target)
	
	-- Animate the caster during the drain
	StartAnimation(caster, {duration = duration,activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.0})

	-- Determine if the target is a friend or ally
	if caster:GetTeam() == target:GetTeam() then

		-- Apply ally modifier
		ability:ApplyDataDrivenModifier(caster, target, modifier_ally, {})
	else

		-- Apply enemy modifier
		ability:ApplyDataDrivenModifier(caster, target, modifier_enemy, {})
	end
end

function LifeDrainAllyStart( keys )
	local caster = keys.caster
	local target = keys.target
	local particle_drain = keys.particle_drain
	local sound_loop = keys.sound_loop

	-- Stop any ongoing looping sound on the target
	target:StopSound(sound_loop)
	target:EmitSound(sound_loop)

	-- End any pre-existing particle
	if target.life_give_particle then
		ParticleManager:DestroyParticle(target.life_give_particle, false)
		ParticleManager:ReleaseParticleIndex(target.life_give_particle)
	end
	
	-- Play ally particle
	target.life_give_particle = ParticleManager:CreateParticle(particle_drain, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(target.life_give_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(target.life_give_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
end

function LifeDrainEnemyStart( keys )
	local caster = keys.caster
	local target = keys.target
	local particle_drain = keys.particle_drain
	local sound_loop = keys.sound_loop

	-- Stop any ongoing looping sound on the target
	target:StopSound(sound_loop)
	target:EmitSound(sound_loop)

	-- End any pre-existing particle
	if target.life_drain_particle then
		ParticleManager:DestroyParticle(target.life_drain_particle, false)
		ParticleManager:ReleaseParticleIndex(target.life_drain_particle)
	end
	
	-- Play ally particle
	target.life_drain_particle = ParticleManager:CreateParticle(particle_drain, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(target.life_drain_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(target.life_drain_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
end

function LifeDrainTickEnemy( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_enemy = keys.modifier_enemy
	local scepter = HasScepter(caster)

	-- Parameters
	local health_drain = ability:GetLevelSpecialValueFor("health_drain", ability_level)
	local break_range = ability:GetLevelSpecialValueFor("break_range", ability_level) + GetCastRangeIncrease(caster)
	local tick_rate = ability:GetLevelSpecialValueFor("tick_rate", ability_level)

	-- Increase damage with scepter
	if scepter then
		local extra_health_drain = ability:GetLevelSpecialValueFor("health_drain_scepter", ability_level)
		local enemy_health = target:GetHealth()
		health_drain = health_drain + enemy_health * extra_health_drain / 100
	end

	-- Apply damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = health_drain * tick_rate, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Calculate amount of healing done
	local caster_healing = health_drain * tick_rate * (1 - target:GetMagicalArmorValue())

	-- If the caster would be overhealed, restore mana
	local health_missing = caster:GetMaxHealth() - caster:GetHealth()
	if health_missing < caster_healing and target:IsHero() then

		-- Heal and restore mana
		caster:Heal(health_missing, caster)
		caster_healing = caster_healing - health_missing
		caster:GiveMana(caster_healing)

		-- Update particle color
		if target.life_drain_particle then
			ParticleManager:SetParticleControl(target.life_drain_particle, 11, Vector(1, 0, 0))
		end
	
	-- If not, just heal the caster
	else
		caster:Heal(caster_healing, caster)

		-- Update particle color
		if target.life_drain_particle then
			ParticleManager:SetParticleControl(target.life_drain_particle, 11, Vector(0, 0, 0))
		end
	end

	-- Check link break conditions
	local should_break = false

	-- Break the link if the caster is stunned or silenced or dead
	if caster:IsStunned() or caster:IsSilenced() or not caster:IsAlive() then
		should_break = true
	end

	-- Break the link if this target is out of the world or no longer visible
	if target:IsOutOfGame() then
		should_break = true
	end

	-- Calculate distance from this target to the caster
	local target_loc = target:GetAbsOrigin()
	local caster_loc = caster:GetAbsOrigin()
	local distance = (target_loc - caster_loc):Length2D()

	-- Break the link if the distance is too large
	if distance > break_range then
		should_break = true
	end

	-- If any of the break conditions is true, break the link
	if should_break then
		target:RemoveModifierByName(modifier_enemy)
	end
end

function LifeDrainTickAlly( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_ally = keys.modifier_ally
	local scepter = HasScepter(caster)

	-- Parameters
	local health_drain = ability:GetLevelSpecialValueFor("health_drain", ability_level)
	local break_range = ability:GetLevelSpecialValueFor("break_range", ability_level)
	local tick_rate = ability:GetLevelSpecialValueFor("tick_rate", ability_level)

	-- Increase heal with scepter
	if scepter then
		local extra_health_drain = ability:GetLevelSpecialValueFor("health_drain_scepter", ability_level)
		local caster_health = caster:GetHealth()
		health_drain = health_drain + caster_health * extra_health_drain / 100
	end

	-- Apply damage
	ApplyDamage({attacker = caster, victim = caster, ability = ability, damage = health_drain * tick_rate / 2, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Calculate amount of healing done
	local target_healing = health_drain * tick_rate * ( 1 - caster:GetMagicalArmorValue() )

	-- If the target would be overhealed, restore its mana
	local health_missing = target:GetMaxHealth() - target:GetHealth()
	if health_missing < target_healing then

		-- Heal and restore mana
		target:Heal(health_missing, caster)
		target_healing = target_healing - health_missing
		target:GiveMana(target_healing)

		-- Update particle color
		if target.life_give_particle then
			ParticleManager:SetParticleControl(target.life_give_particle, 11, Vector(1, 0, 0))
		end
	
	-- If not, just heal the target
	else
		target:Heal(target_healing, caster)

		-- Update particle color
		if target.life_give_particle then
			ParticleManager:SetParticleControl(target.life_give_particle, 11, Vector(0, 0, 0))
		end
	end

	-- Check link break conditions
	local should_break = false

	-- Break the link if the caster is stunned or silenced or dead
	if caster:IsStunned() or caster:IsSilenced() or not caster:IsAlive() then
		should_break = true
	end

	-- Calculate distance from this target to the caster
	local target_loc = target:GetAbsOrigin()
	local caster_loc = caster:GetAbsOrigin()
	local distance = (target_loc - caster_loc):Length2D()

	-- Break the link if the distance is too large
	if distance > break_range then
		should_break = true
	end

	-- If any of the break conditions is true, break the link
	if should_break then
		target:RemoveModifierByName(modifier_ally)
	end
end

function LifeDrainCancel( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_ally = keys.modifier_ally
	
	-- Parameters
	local search_range = ability:GetLevelSpecialValueFor("search_range", ability_level)

	-- Find all currently tethered allies
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, search_range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	
	-- Iterate through valid allies, removing the life drain modifier
	for _,ally in pairs(allies) do
		ally:RemoveModifierByNameAndCaster(modifier_ally, caster)
	end
end

function LifeDrainEnemyEnd( keys )
	local caster = keys.caster
	local target = keys.target
	local sound_loop = keys.sound_loop
	local sound_target = keys.sound_target

	-- End the particle
	ParticleManager:DestroyParticle(target.life_drain_particle, false)
	ParticleManager:ReleaseParticleIndex(target.life_drain_particle)
	target.life_drain_particle = nil

	-- Stop the looping sound
	target:StopSound(sound_target)
	target:StopSound(sound_loop)

	-- Stop caster animation
	EndAnimation(caster)
end

function LifeDrainAllyEnd( keys )
	local caster = keys.caster
	local target = keys.target
	local sound_loop = keys.sound_loop
	local sound_target = keys.sound_target

	-- End the particle
	ParticleManager:DestroyParticle(target.life_give_particle, false)
	ParticleManager:ReleaseParticleIndex(target.life_give_particle)
	target.life_give_particle = nil

	-- Stop the looping sound
	target:StopSound(sound_target)
	target:StopSound(sound_loop)

	-- Stop caster animation
	EndAnimation(caster)
end