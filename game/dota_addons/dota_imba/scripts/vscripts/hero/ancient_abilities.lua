--[[	Author: Firetoad
		Date: 10.01.2016	]]

function AncientHealth( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Parameters
	local health = ability:GetLevelSpecialValueFor("ancient_health", 0)

	-- Update health
	SetCreatureHealth(caster, health, true)
end

function AncientThink( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- If the game is set to end on kills, make the ancient invulnerable
	if END_GAME_ON_KILLS then

		-- Make the ancient invulnerable
		caster:AddNewModifier(caster, ability, "modifier_fountain_glyph", {})
		caster:AddNewModifier(caster, ability, "modifier_invulnerable", {})

		-- Kill any nearby creeps (prevents lag)
		local enemy_creeps = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemy_creeps) do
			enemy:Kill(ability, caster)
		end
		return nil
	end

	-- Parameters
	local ancient_health = caster:GetHealth() / caster:GetMaxHealth()

	-- Search for nearby units
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- If there are no nearby enemies, do nothing
	if #enemies == 0 then
		return nil
	end
	
	-- Ancient abilities logic
	local behemoth_adjustment = 0
	if SPAWN_ANCIENT_BEHEMOTHS then behemoth_adjustment = -1 end
	local tier_1_ability = caster:GetAbilityByIndex(4 + behemoth_adjustment)
	local tier_2_ability = caster:GetAbilityByIndex(5 + behemoth_adjustment)
	local tier_3_ability = caster:GetAbilityByIndex(6 + behemoth_adjustment)

	-- If health < 40%, refresh abilities once
	if (( ancient_health < 0.40 and IMBA_PLAYERS_ON_GAME == 20 ) and not caster.abilities_refreshed ) then
		caster.tier_1_cast = false
		caster.tier_3_cast = false
		tier_1_ability:SetActivated(true)
		tier_3_ability:SetActivated(true)
		caster.abilities_refreshed = true

		-- Small delay for tier 2 (defensive) abilities
		Timers:CreateTimer(2, function()
			caster.tier_2_cast = false
			tier_2_ability:SetActivated(true)
		end)
	end

	-- If health < 50%, use the tier 3 ability
	if ancient_health < 0.5 and tier_3_ability and not caster.tier_3_cast then
		tier_3_ability:OnSpellStart()
		tier_3_ability:SetActivated(false)
		caster.tier_3_cast = true
		return nil
	end

	-- If health < 70%, use the tier 2 ability
	if ancient_health < 0.7 and tier_2_ability and not caster.tier_2_cast then
		tier_2_ability:OnSpellStart()
		tier_2_ability:SetActivated(false)
		caster.tier_2_cast = true
		return nil
	end

	-- If health < 90%, use the tier 1 ability
	if ancient_health < 0.9 and tier_1_ability and not caster.tier_1_cast then
		tier_1_ability:OnSpellStart()
		tier_1_ability:SetActivated(false)
		caster.tier_1_cast = true
		return nil
	end
end

function AncientAttacked( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Parameters
	local ancient_health = caster:GetHealth() / caster:GetMaxHealth()

	-- Search for nearby units
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- If there are no nearby enemies, do nothing
	if #enemies == 0 then
		return nil
	end
	
	-- Ancient abilities logic
	local tier_1_ability = caster:GetAbilityByIndex(4)
	local tier_2_ability = caster:GetAbilityByIndex(5)
	local tier_3_ability = caster:GetAbilityByIndex(6)

	-- If health < 20%, refresh abilities once
	if (( ancient_health < 0.20 and IMBA_PLAYERS_ON_GAME == 20 ) and not caster.abilities_refreshed ) then
		caster.tier_1_cast = false
		caster.tier_3_cast = false
		tier_1_ability:SetActivated(true)
		tier_3_ability:SetActivated(true)
		caster.abilities_refreshed = true

		-- Small delay for tier 2 (defensive) abilities
		Timers:CreateTimer(2, function()
			caster.tier_2_cast = false
			tier_2_ability:SetActivated(true)
		end)
	end

	-- If health < 30%, use the tier 3 ability
	if ancient_health < 0.3 and tier_3_ability and not caster.tier_3_cast then
		tier_3_ability:OnSpellStart()
		tier_3_ability:SetActivated(false)
		caster.tier_3_cast = true
		return nil
	end

	-- If health < 60%, use the tier 2 ability
	if ancient_health < 0.6 and tier_2_ability and not caster.tier_2_cast then
		tier_2_ability:OnSpellStart()
		tier_2_ability:SetActivated(false)
		caster.tier_2_cast = true
		return nil
	end

	-- If health < 90%, use the tier 1 ability
	if ancient_health < 0.9 and tier_1_ability and not caster.tier_1_cast then
		tier_1_ability:OnSpellStart()
		tier_1_ability:SetActivated(false)
		caster.tier_1_cast = true
		return nil
	end
end

function SpawnRadiantBehemoth( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_stack = keys.modifier_stack
	local particle_ambient = keys.particle_ambient

	-- Prevents the ability from working on hero-creeps
	if IsHeroCreep(keys.unit) then
		return nil
	end

	-- Increase body count by 1
	if not caster.ancient_recently_dead_enemies then
		caster.ancient_recently_dead_enemies = 1
	else
		caster.ancient_recently_dead_enemies = caster.ancient_recently_dead_enemies + 1
	end

	-- Keep track of body count
	local this_call_body_count = caster.ancient_recently_dead_enemies

	-- If no other hero died after 10 seconds, spawn the Behemoth
	Timers:CreateTimer(12, function()

		-- If body count is a match, this is the right spawn call
		if caster.ancient_recently_dead_enemies and (this_call_body_count == caster.ancient_recently_dead_enemies) then

			-- Parameters
			local base_health = ability:GetLevelSpecialValueFor("base_health", ability:GetLevel() - 1)
			local health_per_minute = ability:GetLevelSpecialValueFor("health_per_minute", ability:GetLevel() - 1)
			local health_per_hero = ability:GetLevelSpecialValueFor("health_per_hero", ability:GetLevel() - 1)
			local game_time = GameRules:GetDOTATime(false, false) * CREEP_POWER_FACTOR / 60
			
			-- Spawn the Behemoth
			local spawn_loc = Entities:FindByName(nil, "radiant_reinforcement_spawn_mid"):GetAbsOrigin()
			local behemoth = CreateUnitByName("npc_imba_goodguys_mega_hulk", spawn_loc, true, caster, caster, caster:GetTeam())
			FindClearSpaceForUnit(behemoth, spawn_loc, true)

			-- Adjust health
			SetCreatureHealth(behemoth, base_health + this_call_body_count * health_per_hero + game_time * health_per_minute, true)
			
			-- Adjust armor & health regeneration
			AddStacks(ability, caster, behemoth, modifier_stack, game_time, true)

			-- Grant extra abilities
			behemoth:AddAbility("imba_behemoth_aura_goodguys")
			local aura_ability = behemoth:FindAbilityByName("imba_behemoth_aura_goodguys")
			aura_ability:SetLevel(math.min(this_call_body_count, 5))
			behemoth:AddAbility("imba_behemoth_dearmor")
			local dearmor_ability = behemoth:FindAbilityByName("imba_behemoth_dearmor")
			dearmor_ability:SetLevel(1)

			-- Increase Behemoth size according to its power
			behemoth:SetModelScale(0.85 + 0.06 * this_call_body_count)

			-- Play ambient particle
			local ambient_pfx = ParticleManager:CreateParticle(particle_ambient, PATTACH_CUSTOMORIGIN, behemoth)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 0, behemoth, PATTACH_POINT_FOLLOW, "attach_mane1", behemoth:GetAbsOrigin(), true)

			-- Make Behemoth attack-move the opposing ancient
			local target_loc = Entities:FindByName(nil, "dire_reinforcement_spawn_mid"):GetAbsOrigin()
			Timers:CreateTimer(0.5, function()
				behemoth:MoveToPositionAggressive(target_loc)
			end)

			-- Reset body count
			caster.ancient_recently_dead_enemies = nil
		end
	end)
end

function SpawnDireBehemoth( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_stack = keys.modifier_stack
	local particle_ambient = keys.particle_ambient

	-- Prevents the ability from working on hero-creeps
	if IsHeroCreep(keys.unit) then
		return nil
	end

	-- Increase body count by 1
	if not caster.ancient_recently_dead_enemies then
		caster.ancient_recently_dead_enemies = 1
	else
		caster.ancient_recently_dead_enemies = caster.ancient_recently_dead_enemies + 1
	end

	-- Keep track of body count
	local this_call_body_count = caster.ancient_recently_dead_enemies

	-- If no other hero died after 10 seconds, spawn the Behemoth
	Timers:CreateTimer(12, function()

		-- If body count is a match, this is the right spawn call
		if caster.ancient_recently_dead_enemies and (this_call_body_count == caster.ancient_recently_dead_enemies) then

			-- Parameters
			local base_health = ability:GetLevelSpecialValueFor("base_health", ability:GetLevel() - 1)
			local health_per_minute = ability:GetLevelSpecialValueFor("health_per_minute", ability:GetLevel() - 1)
			local health_per_hero = ability:GetLevelSpecialValueFor("health_per_hero", ability:GetLevel() - 1)
			local game_time = GameRules:GetDOTATime(false, false) * CREEP_POWER_FACTOR / 60
			
			-- Spawn the Behemoth
			local spawn_loc = Entities:FindByName(nil, "dire_reinforcement_spawn_mid"):GetAbsOrigin()
			local behemoth = CreateUnitByName("npc_imba_badguys_mega_hulk", spawn_loc, true, nil, nil, caster:GetTeam())
			FindClearSpaceForUnit(behemoth, spawn_loc, true)

			-- Adjust health
			SetCreatureHealth(behemoth, base_health + this_call_body_count * health_per_hero + game_time * health_per_minute, true)

			-- Adjust armor & health regeneration
			AddStacks(ability, caster, behemoth, modifier_stack, game_time, true)

			-- Grant extra abilities
			behemoth:AddAbility("imba_behemoth_aura_badguys")
			local aura_ability = behemoth:FindAbilityByName("imba_behemoth_aura_badguys")
			aura_ability:SetLevel(math.min(this_call_body_count, 5))
			behemoth:AddAbility("imba_behemoth_dearmor")
			local dearmor_ability = behemoth:FindAbilityByName("imba_behemoth_dearmor")
			dearmor_ability:SetLevel(1)

			-- Increase Behemoth size according to its power
			behemoth:SetModelScale(0.85 + 0.06 * this_call_body_count)

			-- Play ambient particle
			local ambient_pfx = ParticleManager:CreateParticle(particle_ambient, PATTACH_CUSTOMORIGIN, behemoth)
			ParticleManager:SetParticleControlEnt(ambient_pfx, 0, behemoth, PATTACH_POINT_FOLLOW, "attach_mane1", behemoth:GetAbsOrigin(), true)

			-- Make Behemoth move to the opposing ancient
			local target_loc = Entities:FindByName(nil, "radiant_reinforcement_spawn_mid"):GetAbsOrigin()
			Timers:CreateTimer(0.5, function()
				behemoth:MoveToPositionAggressive(target_loc)
			end)

			-- Reset body count
			caster.ancient_recently_dead_enemies = nil
		end
	end)
end

function BehemothAttacked( keys )
	local caster = keys.caster
	local ability = keys.ability
	local attacker = keys.attacker
	local modifier_stack = keys.modifier_stack

	-- If the attacker is a hero, reduce the Behemoth's armor
	if attacker:IsHero() then
		AddStacks(ability, caster, caster, modifier_stack, 1, true)
	end
end

function StalwartDefense( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_buff = keys.modifier_buff
	local sound_cast = keys.sound_cast
	local particle_hit = keys.particle_hit
	local particle_buff = keys.particle_buff

	-- Prevents the ability from working on hero-creeps
	if IsHeroCreep(keys.unit) then
		return nil
	end

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)

	-- Find nearby allied heroes
	local nearby_heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)

	-- Do nothing if there are no other nearby heroes
	if #nearby_heroes > 0 then
		
		-- Play LOUD VUVUZELA SOUNDS
		caster:EmitSound(sound_cast)

		-- Iterate through nearby allies
		for _,hero in pairs(nearby_heroes) do

			-- Purge debuffs
			hero:Purge(false, true, false, true, false)	
			
			-- Apply the modifier
			ability:ApplyDataDrivenModifier(caster, hero, modifier_buff, {})

			-- Play the light particles
			if hero.stalwart_defense_light_pfx then
				ParticleManager:DestroyParticle(hero.stalwart_defense_light_pfx, true)
			end
			hero.stalwart_defense_light_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, hero)
			ParticleManager:SetParticleControl(hero.stalwart_defense_light_pfx, 0, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(hero.stalwart_defense_light_pfx, 1, caster:GetAbsOrigin())

			-- Play the buff particles
			if not hero.stalwart_defense_buff_pfx then
				hero.stalwart_defense_buff_pfx = ParticleManager:CreateParticle(particle_buff, PATTACH_ABSORIGIN_FOLLOW, hero)
				ParticleManager:SetParticleControlEnt(hero.stalwart_defense_buff_pfx, 0, hero, PATTACH_POINT_FOLLOW, "attach_attack1", hero:GetAbsOrigin(), true)
			end
		end
	end
end

function StalwartDefenseParticleEnd( keys )
	local unit = keys.target

	-- Destroy buff particles
	if unit.stalwart_defense_light_pfx then
		ParticleManager:DestroyParticle(unit.stalwart_defense_light_pfx, false)
		unit.stalwart_defense_light_pfx = nil
	end
	if unit.stalwart_defense_buff_pfx then
		ParticleManager:DestroyParticle(unit.stalwart_defense_buff_pfx, false)
		unit.stalwart_defense_buff_pfx = nil
	end
end