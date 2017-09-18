--[[	Author: Firetoad
		Date: 12.08.2015	]]
function RoshanSlam( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_slow = keys.modifier_slow
	local modifier_armor = keys.modifier_armor
	local sound_cast = keys.sound_cast
	local particle_slam = keys.particle_slam

	-- Parameters
	local slam_radius = ability:GetSpecialValueFor("slam_radius")
	local base_damage = ability:GetSpecialValueFor("base_damage")
	local stacking_damage = ability:GetSpecialValueFor("stacking_damage")
	local base_armor = ability:GetSpecialValueFor("base_armor")
	local stacking_armor = ability:GetSpecialValueFor("stacking_armor")
	local caster_loc = caster:GetAbsOrigin()

	-- Calculate updated parameters
	local total_damage = base_damage + stacking_damage * GAME_ROSHAN_KILLS
	local total_armor = base_armor + stacking_armor * GAME_ROSHAN_KILLS

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Play particle
	local slam_pfx = ParticleManager:CreateParticle(particle_slam, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(slam_pfx, 0, caster_loc)
	ParticleManager:SetParticleControl(slam_pfx, 1, Vector(slam_radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(slam_pfx)

	-- Iterate through targets
	local slam_targets = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, slam_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,target in pairs(slam_targets) do
		
		-- Apply slow and armor debuffs
		ability:ApplyDataDrivenModifier(caster, target, modifier_slow, {})
		AddStacks(ability, caster, target, modifier_armor, total_armor, true)

		-- Deal damage
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = total_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
	end

	-- Trigger reduced cooldown
	Timers:CreateTimer(0.1, function()
		ability:EndCooldown()
		ability:StartCooldown(math.max(ability:GetCooldown(1) - #slam_targets, 1))
	end)
end

function RoshanSummon( keys )
	local caster = keys.caster
	local ability = keys.ability
	local sound_summon = keys.sound_summon

	-- Parameters
	local summon_duration = ability:GetSpecialValueFor("summon_duration")
	local caster_loc = caster:GetAbsOrigin()
	local caster_direction = caster:GetForwardVector()
	local summon_name = "npc_imba_roshling"
	local summon_amount = 1 + GAME_ROSHAN_KILLS
	local summon_abilities = { "imba_roshling_bash", "imba_roshling_aura" }

	-- Play cast sound
	caster:EmitSound(sound_summon)

	-- Calculate summon positions
	local summon_positions = {}
	for i = 1, summon_amount do
		summon_positions[i] = RotatePosition(caster_loc, QAngle(0, (i - 1) * 360 / summon_amount, 0), caster_loc + caster_direction * 150)
	end

	-- Destroy trees
	GridNav:DestroyTreesAroundPoint(caster_loc, 250, false)

	-- Spawn the summons
	for i = 1, summon_amount do
		local roshling_summon = CreateUnitByName(summon_name, summon_positions[i], true, caster, caster, caster:GetTeam())

		-- Make the summons limited duration
		roshling_summon:AddNewModifier(caster, ability, "modifier_kill", {duration = summon_duration})

		-- Level up the summon's abilities
		for _, summon_ability in pairs(summon_abilities) do
			if roshling_summon:FindAbilityByName(summon_ability) then
				roshling_summon:FindAbilityByName(summon_ability):SetLevel(1)
			end
		end
	end
end

function RoshanSummonAttack( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_bonus = keys.modifier_bonus

	-- Parameters
	local bonus_damage = ability:GetSpecialValueFor("bonus_damage")

	-- Fetch the amount of stacks on the target
	local total_bonus = target:GetModifierStackCount(modifier_bonus, nil)

	-- Calculate damage
	local damage = caster:GetAttackDamage() * bonus_damage * total_bonus * 0.01

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
end

function RoshlingBash( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_debuff = keys.modifier_debuff

	-- Add a stack of Fury Smash
	AddStacks(ability, caster, target, modifier_debuff, 1, true)
end

function RoshanRage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_stack = keys.modifier_stack

	-- Parameters
	local base_hp_threshold = ability:GetSpecialValueFor("base_hp_threshold")
	local stacking_hp_threshold_perc = ability:GetSpecialValueFor("stacking_hp_threshold_perc")

	-- Calculate total buff stacks
	local hp_per_stack = base_hp_threshold * (stacking_hp_threshold_perc ^ GAME_ROSHAN_KILLS)
	local total_stacks = math.floor( (caster:GetMaxHealth() - caster:GetHealth()) / hp_per_stack )

	-- Update the stacks buff
	caster:RemoveModifierByName(modifier_stack)
	AddStacks(ability, caster, caster, modifier_stack, total_stacks, true)
end

function RoshanFury( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sound_cast = keys.sound_cast
	local particle_fury = keys.particle_fury

	-- Parameters
	local width = ability:GetSpecialValueFor("width")
	local length = ability:GetSpecialValueFor("length")
	local speed = ability:GetSpecialValueFor("speed")

	-- Projectile geometry
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = target:GetAbsOrigin()
	
	local projectile_direction
	if caster_pos == target_pos then
		projectile_direction = caster:GetForwardVector()
	else
		projectile_direction = (target_pos - caster_pos):Normalized()
	end
	-- Play sound
	caster:EmitSound(sound_cast)

	-- Create projectile
	local projectile_fury = {
		Ability				= ability,
		EffectName			= particle_fury,
		vSpawnOrigin		= caster_pos,
		fDistance			= length,
		fStartRadius		= width,
		fEndRadius			= width,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
	--	fExpireTime			= ,
		bDeleteOnHit		= false,
		vVelocity			= projectile_direction * speed,
		bProvidesVision		= false,
	--	iVisionRadius		= ,
	--	iVisionTeamNumber	= caster:GetTeamNumber(),
	}

	ProjectileManager:CreateLinearProjectile(projectile_fury)
end

function RoshanFuryHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	-- Parameters
	local length = ability:GetSpecialValueFor("length")
	local base_damage = ability:GetSpecialValueFor("base_damage")
	local stacking_damage = ability:GetSpecialValueFor("stacking_damage")
	local debuff_duration = ability:GetSpecialValueFor("debuff_duration")

	-- Calculate total damage
	local total_damage = base_damage + stacking_damage * GAME_ROSHAN_KILLS

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = total_damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Knockback calculations
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = target:GetAbsOrigin()
	local knockback_pos = caster_pos + ( target_pos - caster_pos ):Normalized() * length
	local knockback_distance = ( knockback_pos - target_pos ):Length2D()
	if ( target_pos - caster_pos ):Length2D() > length then
		knockback_distance = 50
	end

	-- Knockback
	local fury_knockback =	{
		should_stun = 1,
		knockback_duration = debuff_duration,
		duration = debuff_duration,
		knockback_distance = knockback_distance,
		knockback_height = 0,
		center_x = caster_pos.x,
		center_y = caster_pos.y,
		center_z = caster_pos.z
	}

	target:RemoveModifierByName("modifier_knockback")
	target:AddNewModifier(caster, ability, "modifier_knockback", fury_knockback)
end

function RoshanUpgrade( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_stack = keys.modifier_stack

	-- Update health
	local bonus_health = ability:GetSpecialValueFor("bonus_health")
	Timers:CreateTimer(0.5, function()
		SetCreatureHealth(caster, 10000 + bonus_health * GAME_ROSHAN_KILLS, true)
	end)

	-- Update the stacks buff
	if GAME_ROSHAN_KILLS > 0 then
		AddStacks(ability, caster, caster, modifier_stack, GAME_ROSHAN_KILLS, true)
	end
end

function RoshanIllusionPurge( keys )
	local attacker = keys.attacker

	if attacker:IsIllusion() then
		attacker:ForceKill(true)
	end
end

function RoshanDeath( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Parameters
	local respawn_time = ROSHAN_RESPAWN_TIME

	-- Increase Roshan's death count
	_G.GAME_ROSHAN_KILLS = _G.GAME_ROSHAN_KILLS + 1

	-- Drop the Aegis
	local drop_aegis = CreateItem("item_imba_aegis", nil, nil)
	CreateItemOnPositionSync(caster:GetAbsOrigin(), drop_aegis)
	drop_aegis:LaunchLoot(false, 100, 0.5, caster:GetAbsOrigin())

	-- On each sucessive death, grant extra chesse
	if _G.GAME_ROSHAN_KILLS > 1 then
		for i = 2, _G.GAME_ROSHAN_KILLS do
			local drop_cheese = CreateItem("item_imba_cheese", nil, nil)
			CreateItemOnPositionSync(caster:GetAbsOrigin(), drop_cheese)
			drop_cheese:LaunchLoot(false, 100, 0.5, caster:GetAbsOrigin() + RandomVector(100))
		end
	end

	-- After the respawn timer elapses, spawn another Roshan
	Timers:CreateTimer(respawn_time, function()
		local roshan_spawn_loc = Entities:FindByName(nil, "roshan_spawn_point"):GetAbsOrigin()
		local roshan = CreateUnitByName("npc_imba_roshan", roshan_spawn_loc, true, nil, nil, DOTA_TEAM_NEUTRALS)
	end)
end

function RoshanAIstart( keys )
	local caster = keys.caster

	-- If the AI is not active, kickstart it
	if not caster.ai_is_active then
		caster.ai_is_active = true
	end
end

function RoshanAIthink( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Search for enemies in the attack search radius
	local attack_search_range_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
	if #attack_search_range_enemies > 0 then
		caster.ai_is_active = true
		caster.closest_attack_target = attack_search_range_enemies[1]
	else
		caster.closest_attack_target = nil
	end

	-- Make couriers dodge Roshan
	local roshan_loc = caster:GetAbsOrigin()
	local nearby_targets = FindUnitsInRadius(caster:GetTeamNumber(), roshan_loc, nil, 600, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,potential_courier in pairs(nearby_targets) do
		if potential_courier:GetUnitName() == "npc_dota_courier" then
			local courier_loc = potential_courier:GetAbsOrigin()
			FindClearSpaceForUnit(potential_courier, courier_loc + (courier_loc - roshan_loc):Normalized() * 300, true)
		end
	end

	-- Parameters
	local slam_radius = ability:GetSpecialValueFor("slam_radius")
	local roshling_pct = ability:GetSpecialValueFor("roshling_pct")
	local fury_pct = ability:GetSpecialValueFor("fury_pct")
	local leash_radius = ability:GetSpecialValueFor("leash_radius")
	local leash_time = ability:GetSpecialValueFor("leash_time")
	local super_leash_time = ability:GetSpecialValueFor("super_leash_time")
	local leash_margin = ability:GetSpecialValueFor("leash_margin")
	local spawn_loc = Entities:FindByName(nil, "roshan_spawn_point"):GetAbsOrigin()
	local ability_slam = caster:FindAbilityByName("imba_roshan_slam")
	local ability_roshling = caster:FindAbilityByName("imba_roshan_summon")

	-- Condition variables
	local roshan_hp = caster:GetHealth() / caster:GetMaxHealth()

	-- Check if currently leashing back to the spawn position
	if caster.ai_is_leashing_back then

		-- Check if leashing back was successful
		if (roshan_loc - spawn_loc):Length2D() < leash_margin then
			caster.ai_is_leashing_back = nil
			caster.ai_leashing_delay = nil
			caster.ai_is_active = nil
			caster.closest_attack_target = nil
			caster.last_attacker = nil
			return nil
		else

			-- Teleport if leashing back for too long
			caster.ai_leashing_delay = caster.ai_leashing_delay + 0.1
			if caster.ai_leashing_delay > super_leash_time then
				FindClearSpaceForUnit(caster, spawn_loc, true)
				caster.ai_is_leashing_back = nil
				caster.ai_leashing_delay = nil
				caster.ai_is_active = nil
				caster.closest_attack_target = nil
				caster.last_attacker = nil
				return nil
			else
				caster:MoveToPosition(spawn_loc)
				return nil
			end
		end
	end

	-- Check if an ability cast is underway
	if ability_slam:IsInAbilityPhase() or ability_roshling:IsInAbilityPhase() then
		return nil
	end
		
	-- Check for leash range
	if (roshan_loc - spawn_loc):Length2D() > leash_radius then

		-- Count to [leash_time] if already out of the leash radius
		if caster.ai_leashing_delay then
			caster.ai_leashing_delay = caster.ai_leashing_delay + 0.1
		else
			caster.ai_leashing_delay = 0
		end

		-- If at or above [leash_time], start leashing back
		if caster.ai_leashing_delay >= leash_time then
			caster.ai_is_leashing_back = true
			caster:MoveToPosition(spawn_loc)
			return nil
		end

	-- If inside leash range, stop counting
	else
		caster.ai_leashing_delay = nil
	end

	-- If the AI is not active, do not launch skills (use basic AI functionality)
	if not caster.ai_is_active then
		return nil
	end

	if roshan_hp <= roshling_pct and ability_roshling and ability_roshling:IsCooldownReady() then
		
		-- Summon Roshlings
		caster:CastAbilityNoTarget(ability_roshling, 0)
		return nil
	-- Check for Slam cast conditions
	elseif ability_slam and ability_slam:IsCooldownReady() then
		
		-- Perform Slam
		caster:CastAbilityNoTarget(ability_slam, 0)
		return nil
	end
end


--------------------------------------------------
--				DIRETIDE Roshan AI
--------------------------------------------------
-- Author:	zimberzimber
-- Date:	30.8.2017

if imba_roshan_ai_diretide == nil then imba_roshan_ai_diretide = class({}) end
LinkLuaModifier("modifier_imba_roshan_ai_diretide", "hero/neutral_roshan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_roshan_ai_beg", "hero/neutral_roshan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_roshan_ai_eat", "hero/neutral_roshan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_roshan_eaten_candy", "hero/neutral_roshan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_roshan_fury_swipes", "hero/neutral_roshan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_roshan_acceleration", "hero/neutral_roshan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_roshan_death_buff", "hero/neutral_roshan", LUA_MODIFIER_MOTION_NONE)

function imba_roshan_ai_diretide:GetIntrinsicModifierName()
	return "modifier_imba_roshan_ai_diretide" end

------------------------------------------
--				Modifiers				--
------------------------------------------

if modifier_imba_roshan_ai_diretide == nil then modifier_imba_roshan_ai_diretide = class({}) end
function modifier_imba_roshan_ai_diretide:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_roshan_ai_diretide:IsPurgeException() return false end
function modifier_imba_roshan_ai_diretide:IsPurgable() return false end
function modifier_imba_roshan_ai_diretide:IsDebuff() return false end
function modifier_imba_roshan_ai_diretide:IsHidden() return true end

--	GENERAL

function modifier_imba_roshan_ai_diretide:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_imba_roshan_ai_diretide:GetModifierProvidesFOWVision()
	return 1 end
	
function modifier_imba_roshan_ai_diretide:GetActivityTranslationModifiers()
	if self:GetStackCount() == 3 then
		return "sugarrush"
	else return nil end
end

function modifier_imba_roshan_ai_diretide:DeclareFunctions()
	return { MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
			 MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
			 MODIFIER_EVENT_ON_ATTACK_LANDED,
			 MODIFIER_EVENT_ON_ATTACK_START,
			 MODIFIER_PROPERTY_MIN_HEALTH,
			 MODIFIER_EVENT_ON_TAKEDAMAGE 			 }
end

function modifier_imba_roshan_ai_diretide:CheckState()
	local state = {}
	
	if self:GetStackCount() == 2 then
		state = {
			[MODIFIER_STATE_ATTACK_IMMUNE]	= true,
			[MODIFIER_STATE_INVULNERABLE]	= true,
			[MODIFIER_STATE_MAGIC_IMMUNE]	= true,
			[MODIFIER_STATE_CANNOT_MISS]	= true,
			[MODIFIER_STATE_NO_HEALTH_BAR]	= true,
			[MODIFIER_STATE_ROOTED]			= false,
			[MODIFIER_STATE_DISARMED]		= false,
			[MODIFIER_STATE_SILENCED]		= false,
			[MODIFIER_STATE_MUTED]			= false,
			[MODIFIER_STATE_STUNNED]		= false,
			[MODIFIER_STATE_HEXED]			= false,
			[MODIFIER_STATE_INVISIBLE]		= false, }
		
		if self.isEatingCandy then
			state[MODIFIER_STATE_UNSELECTABLE] = true
			state[MODIFIER_STATE_DISARMED] = true
			state[MODIFIER_STATE_ROOTED] = true
			
		elseif self.begState == 1 then
			state[MODIFIER_STATE_DISARMED] = true
			state[MODIFIER_STATE_ROOTED] = true
		end
		
	elseif self:GetStackCount() == 3 then
		if self.isTransitioning then
			state = { [MODIFIER_STATE_INVULNERABLE]		= true,
					  [MODIFIER_STATE_NO_HEALTH_BAR]	= true,
					  [MODIFIER_STATE_UNSELECTABLE]		= true,
					  [MODIFIER_STATE_DISARMED]			= true,
					  [MODIFIER_STATE_ATTACK_IMMUNE]	= true, }
			if self.atStartPoint then	  
				state[MODIFIER_STATE_ROOTED] = true
			end
		end
	end
	
	return state
end

function modifier_imba_roshan_ai_diretide:GetMinHealth()
	if self:GetStackCount() > 1 then
		return 1
	else
		return 0
	end
end

function modifier_imba_roshan_ai_diretide:OnCreated()
	if IsServer() then
		
		-- common keys
		local ability = self:GetAbility()
		self.roshan = self:GetParent()	-- Roshans entity for easier handling
		self.AItarget = nil				-- Targeted hero
		
		-- phase 2 keys
		self.targetTeam		= math.random(DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS)	-- Team Roshan is currently targeting
		self.begState		= 0														-- 0 = not begged | 1 = begging | anything else = has begged
		self.isEatingCandy	= false													-- Is Roshan eating a candy right now?
		self.begDistance	= ability:GetSpecialValueFor("beg_distance")				-- Distance from target to start begging
		
		-- phase 3 keys
		self.isTransitioning	= false												-- Is Roshan playing the transition animation?
		self.atStartPoint		= false												-- Has Roshan reached the start point?
		self.acquisition_range	= ability:GetSpecialValueFor("acquisition_range")	-- Acquisition range for phase 3
		self.leashPoint			= nil												-- Phase 3 arena mid point (defined in phase 3 thinking function)
		self.leashDistance		= ability:GetSpecialValueFor("leash_distance")		-- How far is Roshan allowed to walk away from the starting point
		self.leashHealPcnt		= ability:GetSpecialValueFor("leash_heal_pcnt")		-- Percent of max health Roshan will heal should he get leashed
		self.isDead				= false												-- Is Roshan 'dead'?
		
		-- Sound delays to sync with animation
		self.candyBeg		= 0.5
		self.candyEat		= 0.15
		self.candySniff		= 3.33
		self.candyRoar		= 5.9
		self.pumpkinDrop	= 0
		self.candyGobble	= 0
		self.gobbleRoar		= 0
		
		-- Aimation durations
		self.animBeg		= 5
		self.animGobble		= 9
		self.animDeath		= 8
		
		-- Ability handlers
		self.forceWave	= self.roshan:FindAbilityByName("imba_roshan_diretide_force_wave")
		self.roshlings	= self.roshan:FindAbilityByName("imba_roshan_diretide_summon_roshlings")
		self.breath		= self.roshan:FindAbilityByName("creature_fire_breath")
		self.apocalypse	= self.roshan:FindAbilityByName("imba_roshan_diretide_apocalypse")
		self.fireBall	= self.roshan:FindAbilityByName("imba_roshan_diretide_fireball")
		self.toss		= self.roshan:FindAbilityByName("tiny_toss")
		
		-- Passive effect KVs
		self.bashChance = ability:GetSpecialValueFor("bash_chance") * 0.01
		self.bashDamage = ability:GetSpecialValueFor("bash_damage")
		self.bashDistance = ability:GetSpecialValueFor("bash_distance")
		self.bashDuration = ability:GetSpecialValueFor("bash_duration")
		self.furyswipeDamage = ability:GetSpecialValueFor("furyswipe_damage")
		self.furyswipeDuration = ability:GetSpecialValueFor("furyswipe_duration")
		self.furyswipeIncreasePerDeath = ability:GetSpecialValueFor("fury_swipe_increase_per_death")
		
		-- Create a dummy for global vision
		AddFOWViewer(self.roshan:GetTeamNumber(), Vector(0,0,0), 250000, 999999, false)

		-- Turn on brain
		self.targetTeam = DOTA_TEAM_GOODGUYS
		self:SetStackCount(1)
	end
end

function modifier_imba_roshan_ai_diretide:OnStackCountChanged(stacks)
	if IsServer() then
		-- Get new stacks, and start thinking if its 2 or 3, or become idle if its 1 or anything else
		local stacks = self:GetStackCount()
		if stacks < 1 or stacks > 3 then
			stacks = 1
		end
		self:StartPhase(stacks)
	end
end

function modifier_imba_roshan_ai_diretide:OnIntervalThink()
	local stacks = self:GetStackCount()
	
	if not self.roshan:IsAlive() then
		self:StartIntervalThink(-1)
		
		local deathParticle = ParticleManager:CreateParticle("particles/hw_fx/hw_roshan_death.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(deathParticle, 0, self.roshan:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(deathParticle)
		
	elseif stacks ~= 1 then
		if stacks == 2 and not self.isEatingCandy then
			if self.targetTeam ~= DOTA_TEAM_GOODGUYS and self.targetTeam ~= DOTA_TEAM_BADGUYS then
				self.targetTeam = math.random(DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS)
			end
			self:ThinkPhase2(self.roshan)
			
		elseif stacks == 3 then
			self:ThinkPhase3(self.roshan)
		end
	end
end

function modifier_imba_roshan_ai_diretide:StartPhase(phase)
	-- Reset values
	self.begState = 0
	self.AItarget = nil
	self.targetTeam = 0
	self.isEatingCandy = false
	self.isTransitioning = false
	self.atStartPoint = false
	self.wait = 0
	self.leashPoint = nil
	
	if self.isDead then
		self.isDead = false
		self:Respawn(self.roshan)
	end
	
	-- Reset behavior
	self.roshan:SetAcquisitionRange(-1000)
	self.roshan:SetForceAttackTarget(nil)
	self.roshan:Interrupt()
	
	self.roshan:SetHealth(self.roshan:GetMaxHealth())
	
	-- Destroy candy eaten count
	local candyMod = self.roshan:FindModifierByName("modifier_imba_roshan_eaten_candy")
	if candyMod then candyMod:Destroy() end
	
	-- Destroy all fury swipe modifiers
	local units = FindUnitsInRadius(self.roshan:GetTeamNumber(), Vector(0,0,0), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
	for _, unit in ipairs(units) do
		local swipesModifier = unit:FindModifierByName("modifier_imba_roshan_fury_swipes")
		if swipesModifier then swipesModifier:Destroy() end
	end
	
	-- Destroy acceleration modifier
	local accelerationMod = self.roshan:FindModifierByName("modifier_imba_roshan_acceleration")
	if accelerationMod then accelerationMod:Destroy() end
	
	if phase == 1 then			-- Halts thinking, and resets keys
		self:StartIntervalThink(-1)
	else						-- Starts thinking
		if phase == 2 then
			EmitGlobalSound("diretide_eventstart_Stinger")
			self.roshan:AddNewModifier(self.roshan, self:GetAbility(), "modifier_imba_roshan_eaten_candy", {})
			
			Timers:CreateTimer(5.8, function() -- Timer so music ends first
				self:StartIntervalThink(0.1)
			end)
		elseif phase == 3 then
			EmitGlobalSound("diretide_sugarrush_Stinger")
			self.isTransitioning = true
			self:StartIntervalThink(0.1)
		end
	end
end

--	PHASE II
function modifier_imba_roshan_ai_diretide:ThinkPhase2(roshan)
	if not self.AItarget then		-- If no target
		local heroes = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		for _, hero in ipairs(heroes) do
			if hero:GetTeamNumber() == self.targetTeam and hero:IsAlive() then
				self.AItarget = hero
				self.roshan:SetForceAttackTarget(hero)
				roshan:AddNewModifier(roshan, self:GetAbility(), "modifier_imba_roshan_acceleration", {})
				
				EmitSoundOnClient("diretide_select_target_Stinger", hero:GetPlayerOwner())
				break
			end
		end
		
	else
		if self.begState == 0 then		-- If haven't begged
			if CalcDistanceBetweenEntityOBB(roshan, self.AItarget) <= self.begDistance then
				self.begState = 1
				roshan:AddNewModifier(roshan, nil, "modifier_imba_roshan_ai_beg", {duration = self.animBeg})
				
				-- sound
				Timers:CreateTimer(self.candyBeg, function()
					roshan:EmitSound("RoshanDT.RoshanBeg")
				end)
			end
			
		elseif self.begState == 1 then
			
		else							-- If has begged
			if self.AItarget and self.AItarget:IsAlive() then 
				if not self.roshan:IsAttackingEntity(self.AItarget) then
					self.roshan:SetForceAttackTarget(self.AItarget)
				end
			else
				self:ChangeTagret(self.roshan)
			end
		end
	end
end

function modifier_imba_roshan_ai_diretide:Candy(roshan)
	self.isEatingCandy = true
	roshan:SetForceAttackTarget(nil)
	roshan:Interrupt()
	
	local begMod = roshan:FindModifierByName("modifier_imba_roshan_ai_beg")
	if begMod then begMod:DestroyNoAggro() end
	
	-- Timer because if an animation modifying modifier gets removed and another gets added at the same moment, the new animation will not apply
	Timers:CreateTimer(FrameTime(), function()
		roshan:AddNewModifier(roshan, nil, "modifier_imba_roshan_ai_eat", {duration = 7})
		
		-- Sounds
		Timers:CreateTimer(self.candyEat, function()
			roshan:EmitSound("RoshanDT.EatCandy")
		end)
		
		Timers:CreateTimer(self.candySniff, function()
			roshan:EmitSound("RoshanDT.Sniff")
		end)
		
		Timers:CreateTimer(self.candyRoar, function()
			roshan:EmitSound("RoshanDT.Roar")
		end)
	end)
	
	local candyMod = roshan:FindModifierByName("modifier_imba_roshan_eaten_candy")
	if not candyMod then candyMod = roshan:AddNewModifier(roshan, self:GetAbility(), "modifier_imba_roshan_eaten_candy", {}) end
	
	candyMod:IncrementStackCount()
end

function modifier_imba_roshan_ai_diretide:ChangeTagret(roshan)
	self.AItarget = nil
	self.begState = 0
	self.isEatingCandy = false
	
	roshan:SetForceAttackTarget(nil)
	roshan:Interrupt()
	
	-- Destroy all fury swipe modifiers
	local units = FindUnitsInRadius(roshan:GetTeamNumber(), Vector(0,0,0), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
	for _, unit in ipairs(units) do
		local swipesModifier = unit:FindModifierByName("modifier_imba_roshan_fury_swipes")
		if swipesModifier then swipesModifier:Destroy() end
	end
	
	-- Destroy acceleration modifier
	local accelerationMod = roshan:FindModifierByName("modifier_imba_roshan_acceleration")
	if accelerationMod then accelerationMod:Destroy() end
	
	local begMod = roshan:FindModifierByName("modifier_imba_roshan_ai_beg")
	if begMod then begMod:DestroyNoAggro() end
	
	if self.targetTeam == DOTA_TEAM_GOODGUYS then
		self.targetTeam = DOTA_TEAM_BADGUYS
	else
		self.targetTeam = DOTA_TEAM_GOODGUYS
	end
end

--	PHASE III
function modifier_imba_roshan_ai_diretide:ThinkPhase3(roshan)
	-- Don't think while being stunned, hexed, or casting spells
	if roshan:IsStunned() or roshan:IsHexed() or roshan:IsChanneling() or roshan:GetCurrentActiveAbility() then return end

	-- Wait. No reason to decrement negative values
	if self.wait < 0 then
		return
	elseif self.wait > 0 then
		self.wait = self.wait - 1
		return
	end

	if not self.leashPoint then
		if DIRETIDE_WINNER == DOTA_TEAM_BADGUYS then
			self.leashPoint = Entities:FindByName(nil, "roshan_arena_"..DIRETIDE_WINNER):GetAbsOrigin()		-- Pick arena based on phase 2 winner
		else
			self.leashPoint = Entities:FindByName(nil, "roshan_arena_"..DOTA_TEAM_GOODGUYS):GetAbsOrigin()	-- Default to Radiant
		end
	end

	-- Transitioning from Phase 2 to 3
	if self.isTransitioning then
		if self.atStartPoint then return end
		
		local distanceFromLeash = (roshan:GetAbsOrigin() - self.leashPoint):Length2D()
		if distanceFromLeash > 100 then
			roshan:SetForceAttackTarget(nil)
			roshan:MoveToPosition(self.leashPoint)
		else
			self.atStartPoint = true
			EmitSoundOnLocationWithCaster(roshan:GetAbsOrigin(), "RoshanDT.Gobble", roshan)
			
			roshan:SetForceAttackTarget(nil)
			roshan:Interrupt()
			roshan:StartGesture(ACT_TRANSITION)
			
			Timers:CreateTimer(self.animGobble, function()
				self.atStartPoint = false
				self.isTransitioning = false
				roshan:RemoveGesture(ACT_TRANSITION)
				roshan:SetAcquisitionRange(self.acquisition_range)
			end)
		end
	
		return
	end

	if COUNT_DOWN and COUNT_DOWN == 0 then
		local heroDetector = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		if #heroDetector > 0 then
			COUNT_DOWN = 1
		else
			self.wait = 5
			return
		end
	end
	
	-- Wait. No reason to decrement negative values
	if self.wait < 0 then
		return
	elseif self.wait > 0 then
		self.wait = self.wait - 1
		return
	end
	
	-- Check if Roshan too far away from the leashing point
	local distanceFromLeash = (roshan:GetAbsOrigin() - self.leashPoint):Length2D()
	if not self.returningToLeash and distanceFromLeash >= self.leashDistance then
		self.returningToLeash = true
		roshan:SetHealth(roshan:GetHealth() + roshan:GetMaxHealth() * (self.leashHealPcnt * 0.01)) -- To bypass shit like AAs ult or Malediction healing reduction
	elseif self.returningToLeash and distanceFromLeash < 100 then
		roshan:Interrupt()
		self.returningToLeash = false
	end
	
	-- Return to the leashing point if he should
	if self.returningToLeash then
		roshan:SetForceAttackTarget(nil)
		roshan:MoveToPosition(self.leashPoint)
		return
	end
	
	-- If can summon Roshlings, summon them and keep thinking
	if self.roshlings and self.roshlings:IsCooldownReady() then
		roshan:CastAbilityNoTarget(self.roshlings, 1)
	end
	
	-- Cast Force Wave if its available
	if self.forceWave and self.forceWave:IsCooldownReady() then
		local radius = self.forceWave:GetSpecialValueFor("radius")
		local minTargets = self.forceWave:GetSpecialValueFor("min_targets")
		
		local nearbyHeroes = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		if #nearbyHeroes >= minTargets then
			roshan:CastAbilityNoTarget(self.apocalypse, 1)
			return
		end
	end
	
	-- Cast apocalypse if its available
	if self.apocalypse and self.apocalypse:IsCooldownReady() then
		local maxRange = self.apocalypse:GetSpecialValueFor("max_range")
		local minRange = self.apocalypse:GetSpecialValueFor("min_range")
		local minTargets = self.apocalypse:GetSpecialValueFor("min_targets")
		local inRange = 0
		
		local nearbyHeroes = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, maxRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		for _, hero in ipairs(nearbyHeroes) do
			if CalcDistanceBetweenEntityOBB(roshan, hero) >= minRange then
				inRange = inRange + 1
			end
		end
		
		if inRange >= minTargets then
			roshan:CastAbilityNoTarget(self.apocalypse, 1)
			return
		end
	end
	
	-- Cast Fire Breath if its available
	if self.breath and self.breath:IsCooldownReady() then
		local searchRange = self.breath:GetSpecialValueFor("search_range")
		local nearbyHeroes = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, searchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, hero in ipairs(nearbyHeroes) do
			roshan:CastAbilityOnPosition(hero:GetAbsOrigin(), self.breath, 1)
			return
		end
	end
	
	-- Cast Fire Ball if its available
	if self.fireBall and self.fireBall:IsCooldownReady() then
		local range = self.fireBall:GetSpecialValueFor("range")
		local minTargets = self.fireBall:GetSpecialValueFor("min_targets")
		
		local nearbyHeroes = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		if #nearbyHeroes >= minTargets then
			roshan:CastAbilityNoTarget(self.fireBall, 1)
			return
		end
	end
	
	-- Cast Toss if its available
	if self.toss and self.toss:IsCooldownReady() then
		local maxRange = self.toss:GetSpecialValueFor("tooltip_range")
		local pickupRadius = self.toss:GetSpecialValueFor("grab_radius")
		local pickupUnit = nil
		local throwTarget = nil
		
		local units = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, pickupRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false) 
		for _, unit in ipairs(units) do
			if unit and unit:IsAlive() then
				pickupUnit = unit
				break
			end
		end
		
		if pickupUnit then
			units = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, maxRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_FARTHEST, false) 
			for _, unit in ipairs(units) do
				if unit and unit:IsAlive() then
					throwTarget = unit
					break
				end
			end
			
			if throwTarget then
				roshan:CastAbilityOnTarget(throwTarget, self.toss, 1)
				return
			end
		end
	end
end

function modifier_imba_roshan_ai_diretide:Die(roshan)
	self.isDead = true
	roshan:AddNoDraw()

	local dummyRoshan = CreateUnitByName("npc_diretide_roshan", roshan:GetAbsOrigin(), false, roshan, roshan, roshan:GetTeamNumber()) 
	dummyRoshan:ForceKill(true)

	-- not attached to Roshan or the dummy so it gets drawn (unlike Roshan), and stays until the particle expires (which the dummy would prevent)
	local deathParticle = ParticleManager:CreateParticle("particles/hw_fx/hw_roshan_death.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(deathParticle, 0, dummyRoshan:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(deathParticle)
	
	Timers:CreateTimer(self.animDeath, function()
		self:Respawn(roshan)
	end)
end

function modifier_imba_roshan_ai_diretide:Respawn(roshan)
	self.isDead = false
	roshan:SetHealth(roshan:GetMaxHealth())
	roshan:RemoveNoDraw()

	-- Refresh cooldowns
	if self.forceWave	then self.forceWave:EndCooldown()	end
	if self.roshlings	then self.roshlings:EndCooldown()	end
	if self.breath		then self.breath:EndCooldown()		end
	if self.apocalypse	then self.apocalypse:EndCooldown()	end
	if self.fireBall	then self.fireBall:EndCooldown()	end
	if self.toss		then self.toss:EndCooldown()		end

	DiretideIncreaseTimer(30)

	-- Increase Roshans strength through the modifier
	local deathMod = roshan:FindModifierByName("modifier_imba_roshan_death_buff")
	if not deathMod then
		deathMod = roshan:AddNewModifier(roshan, self:GetAbility(), "modifier_imba_roshan_death_buff", {})
	end
	
	if deathMod then deathMod:IncrementStackCount() end
end

--	SPECIAL EFFECTS + ATTACK SOUND
function modifier_imba_roshan_ai_diretide:OnAttackLanded(keys)
	if IsServer() then
		local roshan = self:GetParent()
		local target = keys.target
		
		if roshan == keys.attacker then
			
			-- Emit hit sound
			target:EmitSound("Roshan.Attack")
			target:EmitSound("Roshan.Attack.Post")
			
			-- Deal fury swipes increased damage
			local furySwipesModifier = target:FindModifierByName("modifier_imba_roshan_fury_swipes")
			if furySwipesModifier then
				local damageTable = { victim = target,attacker = roshan, damage_type = DAMAGE_TYPE_PURE, -- armor 2 stronk
									  damage = furySwipesModifier:GetStackCount() * self.furyswipeDamage,	}
				
				-- Increase fury swipe damage based on times Roshan died
				if self:GetStackCount() == 3 then
					local deathMod = roshan:FindModifierByName("modifier_imba_roshan_death_buff")
					if deathMod then
						damageTable.damage = damageTable.damage + deathMod:GetStackCount() * self.furyswipeIncreasePerDeath
					end
				end
				
				ApplyDamage(damageTable)
				furySwipesModifier:IncrementStackCount()
			else
				-- Does not wear off on phase 2
				if self:GetStackCount() == 2 then
					furySwipesModifier = target:AddNewModifier(roshan, self:GetAbility(), "modifier_imba_roshan_fury_swipes", {duration = math.huge})
					if furySwipesModifier then furySwipesModifier:SetStackCount(1) end
					
				elseif self:GetStackCount() == 3 then
					furySwipesModifier = target:AddNewModifier(roshan, self:GetAbility(), "modifier_imba_roshan_fury_swipes", {duration = self.furyswipeDuration})
					if furySwipesModifier then furySwipesModifier:SetStackCount(1) end
				end
			end
			
			-- Bash only in phase 3
			if self:GetStackCount() == 3 then
				-- check bash chance
				if math.random() <= self.bashChance then
					local knockback = {	center_x = target.x,
										center_y = target.y,
										center_z = target.z,
										duration = self.bashDuration,
										knockback_distance = 200,
										knockback_height = self.bashDistance,
										knockback_duration = self.bashDuration * 0.67,	}
					target:AddNewModifier(roshan, self:GetAbility(), "modifier_knockback", knockback)
					target:EmitSound("Roshan.Bash")
				end
			end
		end
	end
end

--	PREATTACK SOUND
function modifier_imba_roshan_ai_diretide:OnAttackStart(keys)
	if IsServer() then
		local roshan = self:GetParent()
		if roshan == keys.attacker then
			roshan:EmitSound("Roshan.PreAttack")
			roshan:EmitSound("Roshan.Grunt")
		end
	end
end

--	DEATH CHECK
function modifier_imba_roshan_ai_diretide:OnTakeDamage(keys)
	if IsServer() then
		local roshan = self:GetParent()
		if roshan == keys.unit then
			if keys.damage > roshan:GetHealth() then
				self:Die(roshan)
			else
				CustomNetTables:SetTableValue("game_options", "roshan_hp", {HP = roshan:GetHealth(), HP_alt = roshan:GetHealthPercent(), maxHP = roshan:GetMaxHealth()})
			end
		end
	end
end

---------- Roshans Fury Swipes modifier
if modifier_imba_roshan_fury_swipes == nil then modifier_imba_roshan_fury_swipes = class({}) end
function modifier_imba_roshan_fury_swipes:IsPurgeException() return false end
function modifier_imba_roshan_fury_swipes:IsPurgable() return false end
function modifier_imba_roshan_fury_swipes:IsHidden() return false end
function modifier_imba_roshan_fury_swipes:IsDebuff() return true end

function modifier_imba_roshan_fury_swipes:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf" end

function modifier_imba_roshan_fury_swipes:GetTexture()
	return "roshan_bash" end

function modifier_imba_roshan_fury_swipes:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

---------- Roshans acceleration modifier
if modifier_imba_roshan_acceleration == nil then modifier_imba_roshan_acceleration = class({}) end
function modifier_imba_roshan_acceleration:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_roshan_acceleration:IsPurgeException() return false end
function modifier_imba_roshan_acceleration:IsPurgable() return false end
function modifier_imba_roshan_acceleration:IsDebuff() return false end
function modifier_imba_roshan_acceleration:IsHidden() return true end

function modifier_imba_roshan_acceleration:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end

function modifier_imba_roshan_acceleration:OnCreated()
	local ability = self:GetAbility()
	self.speedIncrease = ability:GetSpecialValueFor("speedup_increase")
	self.asIncrease	= ability:GetSpecialValueFor("speedup_as_increase")
	
	if IsServer() then
		self:StartIntervalThink(ability:GetSpecialValueFor("speedup_interval"))
	end
end

function modifier_imba_roshan_acceleration:OnIntervalThink()
	self:IncrementStackCount() end

function modifier_imba_roshan_acceleration:GetModifierMoveSpeedBonus_Constant()
	return self.speedIncrease * self:GetStackCount() end

function modifier_imba_roshan_acceleration:GetModifierAttackSpeedBonus_Constant()
	return self.asIncrease * self:GetStackCount() end

---------- Roshans death buff
if modifier_imba_roshan_death_buff == nil then modifier_imba_roshan_death_buff = class({}) end
function modifier_imba_roshan_death_buff:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_roshan_death_buff:IsPurgeException() return false end
function modifier_imba_roshan_death_buff:IsPurgable() return false end
function modifier_imba_roshan_death_buff:IsHidden() return true end
function modifier_imba_roshan_death_buff:IsDebuff() return false end

function modifier_imba_roshan_death_buff:OnCreated()
	local ability = self:GetAbility()
	self.bonusSpellAmp = ability:GetSpecialValueFor("spellamp_per_death")
	self.bonusDamage = ability:GetSpecialValueFor("damage_per_death")
	self.bonusAttackSpeed = ability:GetSpecialValueFor("attackspeed_per_death")
	self.bonusHealth = ability:GetSpecialValueFor("health_per_death")
	self.bonusArmor = ability:GetSpecialValueFor("armor_per_death")
	self.bonusResist = ability:GetSpecialValueFor("resist_per_death")
end

function modifier_imba_roshan_death_buff:DeclareFunctions()
	return { MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_HEALTH_BONUS, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS } end

function modifier_imba_roshan_death_buff:GetModifierSpellAmplify_Percentage()
	return self.bonusSpellAmp * self:GetStackCount() end
	
function modifier_imba_roshan_death_buff:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage * self:GetStackCount() end
	
function modifier_imba_roshan_death_buff:GetModifierAttackSpeedBonus_Constant()
	return self.bonusAttackSpeed * self:GetStackCount() end
	
function modifier_imba_roshan_death_buff:GetModifierHealthBonus()
	return self.bonusHealth * self:GetStackCount() end
	
function modifier_imba_roshan_death_buff:GetModifierPhysicalArmorBonus()
	return self.bonusArmor * self:GetStackCount() end
	
function modifier_imba_roshan_death_buff:GetModifierMagicalResistanceBonus()
	return self.bonusResist * self:GetStackCount() end

---------- Modifier for handling begging
if modifier_imba_roshan_ai_beg == nil then modifier_imba_roshan_ai_beg = class({}) end
function modifier_imba_roshan_ai_beg:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_roshan_ai_beg:IsPurgeException() return false end
function modifier_imba_roshan_ai_beg:IsPurgable() return false end
function modifier_imba_roshan_ai_beg:IsDebuff() return false end
function modifier_imba_roshan_ai_beg:IsHidden() return true end

function modifier_imba_roshan_ai_beg:GetEffectName()
	return "particles/generic_gameplay/generic_has_quest.vpcf" end
	
function modifier_imba_roshan_ai_beg:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_roshan_ai_beg:OnDestroy()
	if IsServer() then
		if not self.noAggro then	-- Go ape shit if the modifier expired on its own (not by candy-ing Roshan or through 'ChangeTagret)
			local roshan = self:GetParent()
			local AImod = roshan:FindModifierByName("modifier_imba_roshan_ai_diretide")
			if AImod then
				AImod.begState = 2
			end
		end
	end
end

function modifier_imba_roshan_ai_beg:DestroyNoAggro()
	self.noAggro = true
	self:Destroy()
end

function modifier_imba_roshan_ai_beg:DeclareFunctions()
	return { MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
			 MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,}
end

function modifier_imba_roshan_ai_beg:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_5 end

function modifier_imba_roshan_ai_beg:GetOverrideAnimationWeight()
	return 100 end

---------- Modifier for when eating a candy
if modifier_imba_roshan_ai_eat == nil then modifier_imba_roshan_ai_eat = class({}) end
function modifier_imba_roshan_ai_eat:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_roshan_ai_eat:IsPurgeException() return false end
function modifier_imba_roshan_ai_eat:IsPurgable() return false end
function modifier_imba_roshan_ai_eat:IsDebuff() return false end
function modifier_imba_roshan_ai_eat:IsHidden() return true end
	
function modifier_imba_roshan_ai_eat:OnDestroy()
	if IsServer() then
		local roshan = self:GetParent()
		local AImod = roshan:FindModifierByName("modifier_imba_roshan_ai_diretide")
		
		if AImod then
			AImod:ChangeTagret(roshan)
		end
	end
end

function modifier_imba_roshan_ai_eat:DeclareFunctions()
	return { MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
			 MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,}
end

function modifier_imba_roshan_ai_eat:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_6 end

function modifier_imba_roshan_ai_eat:GetOverrideAnimationWeight()
	return 1000 end

---------- Candy modifier
if modifier_imba_roshan_eaten_candy == nil then modifier_imba_roshan_eaten_candy = class({}) end
function modifier_imba_roshan_eaten_candy:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_roshan_eaten_candy:IsPurgeException() return false end
function modifier_imba_roshan_eaten_candy:IsPurgable() return false end
function modifier_imba_roshan_eaten_candy:IsDebuff() return false end
function modifier_imba_roshan_eaten_candy:IsHidden() return false end

function modifier_imba_roshan_eaten_candy:GetTexture()
	return "item_halloween_candy_corn" end

function modifier_imba_roshan_eaten_candy:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_MAX,
			 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			 MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, }
end

function modifier_imba_roshan_eaten_candy:OnCreated()
	local ability = self:GetAbility()
	if not ability then
		print("ERROR - NO ABILITY FOR CANDY MODIFIER!")
		self:Destroy()
		return
	end
	
	self.speedPerCandy = ability:GetSpecialValueFor("speed_per_candy")
	self.damagePerCandy = ability:GetSpecialValueFor("damage_per_candy")
end

function modifier_imba_roshan_eaten_candy:GetModifierPreAttack_BonusDamage()
	return self.speedPerCandy * self:GetStackCount() end

function modifier_imba_roshan_eaten_candy:GetModifierMoveSpeedBonus_Constant()
	return self.damagePerCandy * self:GetStackCount() end

function modifier_imba_roshan_eaten_candy:GetModifierMoveSpeed_Max()
	return 99999 end

------------------------------------------
--				APOCALYPSE				--
------------------------------------------
if imba_roshan_diretide_apocalypse == nil then imba_roshan_diretide_apocalypse = class({}) end
function imba_roshan_diretide_apocalypse:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_1 end

function imba_roshan_diretide_apocalypse:OnSpellStart()
	local roshan = self:GetCaster()
	local minRange = self:GetSpecialValueFor("min_range")
	local maxRange = self:GetSpecialValueFor("max_range")
	local delay = self:GetSpecialValueFor("delay")
	local damage = self:GetSpecialValueFor("damage")
	local radius = self:GetSpecialValueFor("radius")
	
	local positions = {}
	local heroes = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, maxRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	for _, hero in ipairs(heroes) do
		if CalcDistanceBetweenEntityOBB(roshan, hero) >= minRange then
			local pos = hero:GetAbsOrigin()
			table.insert(positions, pos)
			
			EmitSoundOnLocationWithCaster(pos, "RoshanDT.SunStrike.Charge", roshan) 
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_CUSTOMORIGIN, roshan)
			ParticleManager:SetParticleControl(particle, 0, pos)
			ParticleManager:ReleaseParticleIndex(particle)
		end
	end
	
	Timers:CreateTimer(delay, function()
		
		-- loop through the positions and deal damage to all units caught in the explosions AoE
		for _, position in ipairs(positions) do
			local units = FindUnitsInRadius(roshan:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			local damageTable = {victim = nil, attacker = roshan, damage = damage / #units, damage_type = DAMAGE_TYPE_PURE}
			
			for _, unit in ipairs(units) do
				damageTable.victim = unit
				ApplyDamage(damageTable)
			end
			
			EmitSoundOnLocationWithCaster(position, "RoshanDT.SunStrike.Ignite", roshan) 
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_CUSTOMORIGIN, roshan)
			ParticleManager:SetParticleControl(particle, 0, position)
			ParticleManager:ReleaseParticleIndex(particle)
		end
	end)
end

--------------------------------------
--				SLAM				--
--------------------------------------
if imba_roshan_diretide_force_wave == nil then imba_roshan_diretide_force_wave = class({}) end

function imba_roshan_diretide_force_wave:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET end

function imba_roshan_diretide_force_wave:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2 end

function imba_roshan_diretide_force_wave:OnSpellStart()	-- Parameters
	local roshan = self:GetCaster()
	local castPoint = roshan:GetAbsOrigin()
	local waveDistance = 2000
	local waveSize = 200
	local waveSpeed = 500
	local waves = 8
	local angleStep = 360 / waves
	local hitUnits = {}

	roshan:EmitSound("RoshanDT.WaveOfForce.Cast")

	-- Base projectile information
	local waveProjectile = {
		Ability				= self,
		EffectName			= "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf",
		vSpawnOrigin		= castPoint + Vector(0, 0, 50),
		fDistance			= waveDistance,
		fStartRadius		= waveRadius,
		fEndRadius			= waveRadius,
		Source				= roshan,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit		= false,
		vVelocity			= 0,
		bProvidesVision		= false,
		iVisionRadius		= 0,
		iVisionTeamNumber	= roshan:GetTeamNumber(),
	}
	
	for i = 1, waves do
--		waveProjectile.vVelocity = roshans direction + angleStep
		waveProjectile.vVelocity.z = 0	-- So it doesn't move upwards
		ProjectileManager:CreateLinearProjectile(waveProjectile)
	end
end

function imba_roshan_diretide_force_wave:OnProjectileHit(unit, unitPos)

end

------------------------------------------
--				ROSHLINGS				--
------------------------------------------
if imba_roshan_diretide_summon_roshlings == nil then imba_roshan_diretide_summon_roshlings = class({}) end
function imba_roshan_diretide_summon_roshlings:OnSpellStart()
	local roshan = self:GetCaster()
	local roshanPos = roshan:GetAbsOrigin()
	local summonCount = self:GetSpecialValueFor("summon_count")
	local summon = "npc_imba_roshling"
	local summonAbilities = { "imba_roshling_bash", "imba_roshling_aura" }

	local deathMod = roshan:FindModifierByName("modifier_imba_roshan_death_buff")
	if deathMod then
		summonCount = summonCount + deathMod:GetStackCount() * self:GetSpecialValueFor("extra_per_death")
	end

	local roshling = nil
	GridNav:DestroyTreesAroundPoint(roshanPos, 250, false)
	for i = 1, summonCount do
		roshling = CreateUnitByName(summon, roshanPos, true, roshan, roshan, roshan:GetTeam())
		roshling:SetForwardVector(roshan:GetForwardVector())
		
		for _, abilityName in ipairs(summonAbilities) do
			local ability = roshling:FindAbilityByName(abilityName)
			if ability then ability:SetLevel(1) end
		end
	end
end
