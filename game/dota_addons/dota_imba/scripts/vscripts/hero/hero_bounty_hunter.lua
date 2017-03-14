-- Author: Shush
-- Date: 02/03/2017


CreateEmptyTalents("bounty_hunter")



-------------------------------------------
--			SHURIKEN TOSS
-------------------------------------------

imba_bounty_hunter_shuriken_toss = class({})
LinkLuaModifier("modifier_shuriken_toss_ministun", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shuriken_toss_pull", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)

function imba_bounty_hunter_shuriken_toss:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local particle_projectile = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_suriken_toss.vpcf"
	local sound_cast = "Hero_BountyHunter.Shuriken"
	local cast_response = "bounty_hunter_bount_ability_shur_0"..RandomInt(2, 3)
	local scepter = caster:HasScepter()

	-- Ability specials
	local projectile_speed = ability:GetSpecialValueFor("projectile_speed")		
	local scepter_throw_delay = ability:GetSpecialValueFor("scepter_throw_delay")

	-- Play cast responses (25% chance)
	local cast_response_chance = 25
	local cast_response_roll = RandomInt(1, 100)

	if cast_response_roll <= cast_response_chance then
		EmitSoundOn(cast_response, caster)
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)	

	-- Clear all target's marks	
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
										  caster:GetAbsOrigin(),
										  nil,
										  50000,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO,
										  DOTA_UNIT_TARGET_FLAG_NONE,
										  FIND_ANY_ORDER,
										  false)

	for _,enemy in pairs(enemies) do
		enemy.hit_by_first_shuriken = nil
		enemy.hit_by_second_shuriken = nil
	end

	-- Launch projectile on target
	local shuriken_projectile
	shuriken_projectile = {
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = particle_projectile,
		iMoveSpeed = projectile_speed,
		bDodgeable = true, 
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = false,
		ExtraData = {first_shuriken = true}
		}

	ProjectileManager:CreateTrackingProjectile(shuriken_projectile)

	-- If caster has scepter, launch another one after a second delay
	if scepter then
		Timers:CreateTimer(scepter_throw_delay, function()
			shuriken_projectile = {
			Target = target,
			Source = caster,
			Ability = ability,
			EffectName = particle_projectile,
			iMoveSpeed = projectile_speed,
			bDodgeable = true, 
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			bProvidesVision = false,
			ExtraData = {first_shuriken = false}
			}
			ProjectileManager:CreateTrackingProjectile(shuriken_projectile)
		end)
	end
end

function imba_bounty_hunter_shuriken_toss:OnProjectileHit_ExtraData(target, location, extradata)
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self		
		local particle_projectile = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_suriken_toss.vpcf"		
		local scepter = caster:HasScepter()					
		local first_shuriken = extradata.first_shuriken

		-- Ability specials
		local projectile_speed = ability:GetSpecialValueFor("projectile_speed")		
		local damage = ability:GetSpecialValueFor("damage")
		local bounce_radius = ability:GetSpecialValueFor("bounce_radius")
		local stun_duration = ability:GetSpecialValueFor("stun_duration")	
		local scepter_stun_duration = ability:GetSpecialValueFor("scepter_stun_duration")
		local pull_duration = ability:GetSpecialValueFor("pull_duration")	

		-- #3 Talent - Shuriken Damage increase
		damage = damage + caster:FindTalentValue("special_bonus_unique_bounty_hunter_3")

		-- #5 Talent - Shuriken bounce radius becomes global		
		bounce_radius = bounce_radius + caster:FindTalentValue("special_bonus_unique_bounty_hunter_5")	

		-- Mark target as hit by the correct shuriken
		if first_shuriken == 1 then
			target.hit_by_first_shuriken = true
		else						
			target.hit_by_second_shuriken = true
		end

		-- If target dodged at the last moment, do nothing
		if not target then
			return nil
		end

		-- If target became spell immune when the shuriken was in its way, do nothing
		if target:IsMagicImmune() then
			return nil
		end

		-- If target has Linken's sphere ready, do nothing
		if caster:GetTeamNumber() ~= target:GetTeamNumber() then
			if target:TriggerSpellAbsorb(ability) then
				return nil
			end
		end		

		-- Stun target. Duration increased by holding a scepter
		if scepter then
			stun_duration = scepter_stun_duration
		end		

		target:AddNewModifier(caster, ability, "modifier_shuriken_toss_ministun", {duration = stun_duration})

		-- Deal damage					
		local damageTable = {victim = target,
							damage = damage,
							damage_type = DAMAGE_TYPE_MAGICAL,
							attacker = caster,
							ability = ability
							}
							
		ApplyDamage(damageTable)	

		-- Apply pull modifier
		target:AddNewModifier(caster, ability, "modifier_shuriken_toss_pull", {duration = pull_duration})

		-- Find new enemy hero to bounce to
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
										  target:GetAbsOrigin(),
										  nil,
										  bounce_radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO,
										  DOTA_UNIT_TARGET_FLAG_NONE,
										  FIND_CLOSEST,
										  false)

		for _,enemy in pairs(enemies) do						
			-- Look for proper enemy to bounce to 					
			
			if (first_shuriken == 1 and not enemy.hit_by_first_shuriken) or (first_shuriken == 0 and not enemy.hit_by_second_shuriken)  then				
				-- Only commence if the enemy has track
				if enemy:HasModifier("modifier_imba_track_debuff") and enemy ~= target then
					
					-- Bounce
					local shuriken_projectile
					shuriken_projectile = {
					Target = enemy,
					Source = target,
					Ability = ability,
					EffectName = particle_projectile,
					iMoveSpeed = projectile_speed,
					bDodgeable = true, 
					bVisibleToEnemies = true,
					bReplaceExisting = false,
					bProvidesVision = false,
					ExtraData = {first_shuriken = first_shuriken}
					}

					ProjectileManager:CreateTrackingProjectile(shuriken_projectile)
					break -- Stop looking for this jump
				end
			end
		end

	end
end

function imba_bounty_hunter_shuriken_toss:IsHiddenWhenStolen()
	return false
end


-- Stun modifier
modifier_shuriken_toss_ministun = class({})

function modifier_shuriken_toss_ministun:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state	
end

function modifier_shuriken_toss_ministun:IsStunDebuff()
	return true
end

function modifier_shuriken_toss_ministun:IsHidden()
	return false	
end

function modifier_shuriken_toss_ministun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_shuriken_toss_ministun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
	

-- Pull modifier
modifier_shuriken_toss_pull = class({})

function modifier_shuriken_toss_pull:OnCreated()
	if IsServer() then
		-- Ability properties
		self.parent = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.particle_leash = "particles/hero/bounty_hunter/shuriken_toss_leash.vpcf"
		self.particle_hook = "particles/hero/bounty_hunter/shuriken_toss_hook.vpcf"

		-- Ability specials (index in the modifier)
		self.minimum_pull_power = self.ability:GetSpecialValueFor("minimum_pull_power")
		self.minimum_pull_distance = self.ability:GetSpecialValueFor("minimum_pull_distance")
		self.maximum_pull_power = self.ability:GetSpecialValueFor("maximum_pull_power")
		self.pull_power_increase = self.ability:GetSpecialValueFor("pull_power_increase")
		self.pull_increase_distance = self.ability:GetSpecialValueFor("pull_increase_distance")
		self.toss_hit_location = self.parent:GetAbsOrigin()

		-- Create leash particle
		self.particle_leash_fx = ParticleManager:CreateParticle(self.particle_leash, PATTACH_ABSORIGIN, self.parent)		
		ParticleManager:SetParticleControl(self.particle_leash_fx, 3, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.particle_leash_fx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)

		-- Create a dummy for the ground hook particle		
		self.shuriken_toss_dummy = CreateUnitByName("npc_dummy_unit", self.parent:GetAbsOrigin(), false, nil, nil, self.parent:GetTeamNumber())		
		self.shuriken_toss_dummy:SetAbsOrigin(self.parent:GetAbsOrigin())

		-- Attach the ground hook to the dummy
		self.particle_hook_fx = ParticleManager:CreateParticle(self.particle_hook, PATTACH_CUSTOMORIGIN, self.parent)
		ParticleManager:SetParticleControl(self.particle_hook_fx, 0, Vector(self.shuriken_toss_dummy:GetAbsOrigin().x, self.shuriken_toss_dummy:GetAbsOrigin().y, 2000))
		ParticleManager:SetParticleControl(self.particle_hook_fx, 6, self.shuriken_toss_dummy:GetAbsOrigin())

		self:StartIntervalThink(0)		
	end
end

function modifier_shuriken_toss_pull:OnIntervalThink()
	if IsServer() then
		-- Find distance and direction between parent and hit location
		local distance = (self.parent:GetAbsOrigin() - self.toss_hit_location):Length2D()	
		local direction = (self.toss_hit_location - self.parent:GetAbsOrigin()):Normalized()				
		
		-- If distance is below the minimum, do nothing
		if distance <= self.minimum_pull_distance then			
			return nil
		end	

		-- Calculate pull power for that tick
		local velocity = self.minimum_pull_power + (distance/self.pull_increase_distance) * self.pull_power_increase		

		-- No more than the maximum distance
		if velocity > self.maximum_pull_power then
			velocity = self.maximum_pull_power
		end

		-- Move the target towards the hit location
		self.parent:SetAbsOrigin(self.parent:GetAbsOrigin() + direction * velocity * FrameTime())
		ResolveNPCPositions(self.parent:GetAbsOrigin(), 128)
	end
end

function modifier_shuriken_toss_pull:OnRemoved()
	if IsServer() then
		-- Clear particles
		ParticleManager:DestroyParticle(self.particle_leash_fx, false)
		ParticleManager:ReleaseParticleIndex(self.particle_leash_fx)

		ParticleManager:DestroyParticle(self.particle_hook_fx, true)
		ParticleManager:ReleaseParticleIndex(self.particle_hook_fx)

		-- Destroy dummy
		self.shuriken_toss_dummy:Destroy()
	end
end

function modifier_shuriken_toss_pull:IsDebuff()
	return true
end

function modifier_shuriken_toss_pull:IsHidden()
	return false
end

function modifier_shuriken_toss_pull:IsPurgable()
	return true
end


-------------------------------------------
--				JINADA
-------------------------------------------


imba_bounty_hunter_jinada = class({})
LinkLuaModifier("modifier_imba_jinada_thinker", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_jinada_slow_debuff", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_jinada_crit", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)

function imba_bounty_hunter_jinada:GetCooldown(level)	
	local caster = self:GetCaster()
	local cd = self.BaseClass.GetCooldown(self, level)

	-- #7 Talent cd reduction	
	cd = cd - caster:FindTalentValue("special_bonus_unique_bounty_hunter_7")
	return cd	
end

function imba_bounty_hunter_jinada:GetIntrinsicModifierName()
	return "modifier_imba_jinada_thinker"
end

function imba_bounty_hunter_jinada:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()

		-- Check if caster has Track, or target is an ally
		if not target:HasModifier("modifier_imba_track_debuff") or target:GetTeamNumber() == caster:GetTeamNumber() then
			return UF_FAIL_CUSTOM
		end

		return UF_SUCCESS
	end
end

function imba_bounty_hunter_jinada:GetCustomCastErrorTarget(target)	
	return "Ability can only be used on Tracked enemies"
end

function imba_bounty_hunter_jinada:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self
		local target = self:GetCursorTarget()

		-- If target has Linken's sphere, do nothing
		if caster:GetTeamNumber() ~= target:GetTeamNumber() then
			if target:TriggerSpellAbsorb(ability) then
				return nil
			end
		end

		-- Teleport caster near the target.		
		local blink_direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
		target_pos = target:GetAbsOrigin() + blink_direction * (-50)
		FindClearSpaceForUnit(caster, target_pos, false)

		-- Set caster's forward vector toward the enemy
		caster:SetForwardVector((target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized())	

		-- Start skill cooldown.
		ability:StartCooldown(ability:GetCooldown(ability:GetLevel()-1))

		-- Wait for one second. If crit buff is still not used, remove it.
		Timers:CreateTimer(1, function()
			if caster:HasModifier("modifier_imba_jinada_crit") then
				caster:RemoveModifierByName("modifier_imba_jinada_crit")
			end
		end)		

		-- Start attacking the target		
		Timers:CreateTimer(FrameTime(), function()
			caster:MoveToTargetToAttack(target)
		end)
	end	
end 

function imba_bounty_hunter_jinada:IsStealable()
	return false	
end

-- Jinada thinker modifier
modifier_imba_jinada_thinker = class({})

function modifier_imba_jinada_thinker:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_jinada_thinker:OnCreated()	
	self:StartIntervalThink(0.2)
end

function modifier_imba_jinada_thinker:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local crit_modifier = "modifier_imba_jinada_crit"		
		
		-- Check if caster should have the crit modifier.
		if ability:IsCooldownReady() and not caster:HasModifier(crit_modifier) then
			caster:AddNewModifier(caster, ability, crit_modifier, {})
		end
	end
end

function modifier_imba_jinada_thinker:IsHidden()
	return true
end

function modifier_imba_jinada_thinker:IsPurgable()
	return false
end

function modifier_imba_jinada_thinker:IsDebuff()
	return false	
end

-- Slow debuff modifier
modifier_imba_jinada_slow_debuff = class({})

function modifier_imba_jinada_slow_debuff:OnCreated()		
		-- Prepare variables
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")
		self.as_slow = self.ability:GetSpecialValueFor("as_slow")		
		
		-- #2 Talent: Jinada's slow increase
		 self.ms_slow_pct = self.ms_slow_pct + self.caster:FindTalentValue("special_bonus_unique_bounty_hunter_2")
		 self.as_slow = self.as_slow + self.caster:FindTalentValue("special_bonus_unique_bounty_hunter_2")
end

function modifier_imba_jinada_slow_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
					  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_imba_jinada_slow_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end

function modifier_imba_jinada_slow_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow * (-1)
end

function modifier_imba_jinada_slow_debuff:IsDebuff()
	return true
end

function modifier_imba_jinada_slow_debuff:IsPurgable()
	return true
end

function modifier_imba_jinada_slow_debuff:IsHidden()
	return false
end


-- Jinada crit modifier
modifier_imba_jinada_crit = class({})

function modifier_imba_jinada_crit:OnCreated()
	if IsServer() then
		self.parent = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.particle_glow = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_hand_l.vpcf"
		self.particle_hit = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_jinda_slow.vpcf"
		self.modifier_slow = "modifier_imba_jinada_slow_debuff"

		-- Set up glowing weapon particles
		self.particle_glow_fx = ParticleManager:CreateParticle(self.particle_glow, PATTACH_ABSORIGIN, self.parent)
		ParticleManager:SetParticleControlEnt(self.particle_glow_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_weapon1", self.parent:GetAbsOrigin(), true)
		self:AddParticle(self.particle_glow_fx, false, false, -1, false, false)

		self.particle_glow_fx = ParticleManager:CreateParticle(self.particle_glow, PATTACH_ABSORIGIN, self.parent)
		ParticleManager:SetParticleControlEnt(self.particle_glow_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_weapon2", self.parent:GetAbsOrigin(), true)
		self:AddParticle(self.particle_glow_fx, false, false, -1, false, false)

		-- Set up variables for later use
		self.crit_damage = self.ability:GetSpecialValueFor("crit_damage")
		self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")		
	end
end

function modifier_imba_jinada_crit:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED,
						  MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE}
		
		return decFuncs	
end

function modifier_imba_jinada_crit:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- If this is an illusion, do nothing
		if not attacker:IsRealHero() then
			return nil
		end

		-- If target has break, do nothing
		if attacker:PassivesDisabled() then
			return nil
		end

		-- Only apply on caster attacking enemies
		if self.parent == attacker and target:GetTeamNumber() ~= self.parent:GetTeamNumber() then

			-- Add hit particle effects
			self.particle_hit_fx = ParticleManager:CreateParticle(self.particle_hit, PATTACH_ABSORIGIN, self.parent)
			ParticleManager:SetParticleControl(self.particle_hit_fx, 0, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.particle_hit_fx)

			-- Add slow modifier to the target
			target:AddNewModifier(self.parent, self.ability, self.modifier_slow, {duration = self.slow_duration})

			-- Start the skill's cooldown if it's ready (might not be because of active)
			if self.ability:IsCooldownReady() then
				self.ability:StartCooldown(self.ability:GetCooldown(self.ability:GetLevel()-1))
			end

			-- Remove the critical strike modifier from the caster
			self:Destroy()
		end
	end
end

function modifier_imba_jinada_crit:GetModifierPreAttack_CriticalStrike(keys)
	local attacker = keys.attacker
	local target = keys.target

	-- If this is an illusion, do nothing
		if not self.parent:IsRealHero() then
			return nil
		end

	-- If caster has break, do nothing
		if attacker:PassivesDisabled() then
			return nil
		end

	-- Prevent critical attacks on allies
	if self.parent:GetTeamNumber() == target:GetTeamNumber() then
		return nil
	end

	return self.crit_damage
end

function modifier_imba_jinada_crit:IsHidden()
	return true
end

function modifier_imba_jinada_crit:IsPurgable()
	return false	
end

function modifier_imba_jinada_crit:IsDebuff()
	return false
end


-------------------------------------------
--			SHADOW WALK
-------------------------------------------


imba_bounty_hunter_shadow_walk = class({})
LinkLuaModifier("modifier_imba_shadow_walk_invisibility", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_walk_true_sight", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)

function imba_bounty_hunter_shadow_walk:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self
		local sound_cast = "Hero_BountyHunter.WindWalk"
		local cast_response = "bounty_hunter_bount_ability_windwalk_0"..RandomInt(1, 8)
		local particle_smoke = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf"
		local particle_invis_start = "particles/generic_hero_status/status_invisibility_start.vpcf"
		local modifier_invis = "modifier_imba_shadow_walk_invisibility"

		-- Ability specials
		local duration = ability:GetSpecialValueFor("duration")
		local fade_time = ability:GetSpecialValueFor("fade_time")

		-- Play cast response (75% chance)
		local cast_response_chance = 75
		local cast_response_roll = RandomInt(1, 100)

		if cast_response_roll <= cast_response_chance then			
			EmitSoundOn(cast_response, caster)
		end

		-- Play cast sound
		EmitSoundOn(sound_cast, caster)

		-- Add smoke particle
		local particle_smoke_fx = ParticleManager:CreateParticle(particle_smoke, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_smoke_fx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_smoke_fx)

		-- Wait for fade time, add invisibility effect and go invis
		Timers:CreateTimer(fade_time, function()
			local particle_invis_start_fx = ParticleManager:CreateParticle(particle_invis_start, PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(particle_invis_start_fx, 0, caster:GetAbsOrigin())

			caster:AddNewModifier(caster, ability, modifier_invis, {duration = duration})
		end)
	end	
end

function imba_bounty_hunter_shadow_walk:IsHiddenWhenStolen()
	return false
end

-- invisibility modifier
modifier_imba_shadow_walk_invisibility = class({})

function modifier_imba_shadow_walk_invisibility:OnCreated()	
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.invis_ms_bonus = self.ability:GetSpecialValueFor("invis_ms_bonus")
	self.true_sight_radius = self.ability:GetSpecialValueFor("true_sight_radius") 	
	
	-- #1 Talent: Shadow Walk true sight radius increase
	self.true_sight_radius = self.true_sight_radius + self.caster:FindTalentValue("special_bonus_unique_bounty_hunter_1")

end

function modifier_imba_shadow_walk_invisibility:CheckState()
	local state = {[MODIFIER_STATE_INVISIBLE] = true,
				   [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	return state	
end

function modifier_imba_shadow_walk_invisibility:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_imba_shadow_walk_invisibility:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
					  MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
					  MODIFIER_EVENT_ON_ABILITY_EXECUTED,
					  MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFuncs
end

function modifier_imba_shadow_walk_invisibility:GetModifierInvisibilityLevel()
	return 1
end

function modifier_imba_shadow_walk_invisibility:GetModifierMoveSpeedBonus_Percentage()
	return self.invis_ms_bonus
end

function modifier_imba_shadow_walk_invisibility:OnAbilityExecuted(keys)
	if IsServer() then
		local ability = keys.ability
		local caster = keys.caster

		-- Only apply when the shadow walk caster is the one casting an ability
		if caster == self.caster then
			-- Check if the ability that was cast is either Jinada or Track - if so, ignore it
			if ability:GetName() == "imba_bounty_hunter_jinada" or ability:GetName() == "imba_bounty_hunter_track" then
				return nil
			end

			-- Else, remove the invisibilty
			self:Destroy()
		end
	end
end

function modifier_imba_shadow_walk_invisibility:OnAttackLanded(keys)
	if IsServer() then
		-- key properties
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply on the caster attacking
		if self.caster == attacker then

			-- Deal bonus damage
			local damageTable = {victim = target,
								damage = self.bonus_damage,
								damage_type = DAMAGE_TYPE_PHYSICAL,
								attacker = self.caster,
								ability = self.ability
								}
								
			ApplyDamage(damageTable)			

			-- Remove invisibility
			self:Destroy()
		end
	end
end

function modifier_imba_shadow_walk_invisibility:GetAuraRadius()
	return self.true_sight_radius
end

function modifier_imba_shadow_walk_invisibility:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_imba_shadow_walk_invisibility:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_shadow_walk_invisibility:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_shadow_walk_invisibility:GetModifierAura()
	return "modifier_imba_shadow_walk_true_sight"
end

function modifier_imba_shadow_walk_invisibility:IsAura()
	return true
end

function modifier_imba_shadow_walk_invisibility:IsDebuff()
	return false
end

function modifier_imba_shadow_walk_invisibility:IsHidden()
	return false
end

function modifier_imba_shadow_walk_invisibility:IsPurgable()
	return false
end

-- True sight debuff
modifier_imba_shadow_walk_true_sight = class({})

function modifier_imba_shadow_walk_true_sight:CheckState()
	local state = {[MODIFIER_STATE_INVISIBLE] = false}				   
	return state	
end

function modifier_imba_shadow_walk_true_sight:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_imba_shadow_walk_true_sight:IsHidden()
	return true
end

function modifier_imba_shadow_walk_true_sight:IsPurgable()
	return false
end

function modifier_imba_shadow_walk_true_sight:IsDebuff()
	return true
end


-------------------------------------------
--				   TRACK
-------------------------------------------


imba_bounty_hunter_track = class({})
LinkLuaModifier("modifier_imba_track_debuff", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_track_buff", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)

function imba_bounty_hunter_track:GetCooldown(level)
	local caster = self:GetCaster()

	-- #4 Talent: Track cooldown decrease
	return self.BaseClass.GetCooldown(self, level) - caster:FindTalentValue("special_bonus_unique_bounty_hunter_4")
end

function imba_bounty_hunter_track:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self
		local target = self:GetCursorTarget()
		local particle_projectile = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_cast.vpcf"
		local cast_response = "bounty_hunter_bount_ability_track_0"..RandomInt(2, 3)
		local sound_cast = "Hero_BountyHunter.Target"
		local modifier_track = "modifier_imba_track_debuff"

		-- Ability specials
		local projectile_speed = ability:GetSpecialValueFor("projectile_speed")
		local duration = ability:GetSpecialValueFor("duration")

		-- #6 Talent: Track duration increase
		duration = duration + caster:FindTalentValue("special_bonus_unique_bounty_hunter_6")

		-- Cast responses
		local cast_response_chance = 10
		local cast_response_roll = RandomInt(1, 100)
		if cast_response_roll <= cast_response_chance then
			EmitSoundOn(cast_response, caster)
		end

		-- Play cast sound for the player's team only
		EmitSoundOnLocationForAllies(caster:GetAbsOrigin(), sound_cast, caster)

		-- Add track particle, only for the player's team
		local particle_projectile_fx = ParticleManager:CreateParticleForTeam(particle_projectile, PATTACH_CUSTOMORIGIN, caster, caster:GetTeamNumber())
		ParticleManager:SetParticleControlEnt(particle_projectile_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle_projectile_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle_projectile_fx)
		
		-- If target has Linken's sphere ready, do nothing
		if caster:GetTeamNumber() ~= target:GetTeamNumber() then
			if target:TriggerSpellAbsorb(ability) then
				return nil
			end
		end

		-- Add track debuff to target
		target:AddNewModifier(caster, ability, modifier_track, {duration = duration})		
	end
end

function imba_bounty_hunter_track:IsHiddenWhenStolen()
	return false
end

-- Track modifier (aura)
modifier_imba_track_debuff = class({})

function modifier_imba_track_debuff:OnCreated()	
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.particle_shield = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf"
		self.particle_trail = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_trail.vpcf"

		-- Ability specials	
		self.bonus_gold_self = self.ability:GetSpecialValueFor("bonus_gold_self")
		self.bonus_gold_allies = self.ability:GetSpecialValueFor("bonus_gold_allies")		
		self.haste_radius = self.ability:GetSpecialValueFor("haste_radius")
		self.haste_linger = self.ability:GetSpecialValueFor("haste_linger")
	
	if IsServer() then
		-- Adjust custom lobby gold settings to the gold
		self.bonus_gold_self = self.bonus_gold_self * (1 + CUSTOM_GOLD_BONUS/100)
		self.bonus_gold_allies = self.bonus_gold_allies * (1 + CUSTOM_GOLD_BONUS/100)

		-- Add overhead particle only for the caster's team
		self.particle_shield_fx = ParticleManager:CreateParticleForTeam(self.particle_shield, PATTACH_OVERHEAD_FOLLOW, self.parent, self.caster:GetTeamNumber())
		ParticleManager:SetParticleControl(self.particle_shield_fx, 0, self.parent:GetAbsOrigin())
		self:AddParticle(self.particle_shield_fx, false, false, -1, false, true)

		-- Add the track particle only for the caster's team
		self.particle_trail_fx = ParticleManager:CreateParticleForTeam(self.particle_trail, PATTACH_ABSORIGIN_FOLLOW, self.parent, self.caster:GetTeamNumber())
		ParticleManager:SetParticleControl(self.particle_trail_fx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.particle_trail_fx, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle_trail_fx, 8, Vector(1,0,0))
		self:AddParticle(self.particle_trail_fx, false, false, -1, false, false)
	end

	
end

function modifier_imba_track_debuff:CheckState()
	local state = {[MODIFIER_STATE_INVISIBLE] = false}
	return state
end

function modifier_imba_track_debuff:GetAuraDuration()
	return self.haste_linger
end

function modifier_imba_track_debuff:GetAuraRadius()
	return self.haste_radius
end

function modifier_imba_track_debuff:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_imba_track_debuff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_track_debuff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_track_debuff:GetModifierAura()
	return "modifier_imba_track_buff"
end

function modifier_imba_track_debuff:IsAura()
	return true
end

function modifier_imba_track_debuff:IsDebuff()
	return true
end

function modifier_imba_track_debuff:IsPurgable()	
	-- #8 Talent - unpurgable track
	local purge_value = self.caster:FindTalentValue("special_bonus_unique_bounty_hunter_8")
	if purge_value == 1 then
	 	return false
	end

	return true
end

function modifier_imba_track_debuff:IsPermanent()
	return false
end

function modifier_imba_track_debuff:IsHidden()	
	-- #8 Talent - unpurgable track
	local hidden_value = self.caster:FindTalentValue("special_bonus_unique_bounty_hunter_8")
	if hidden_value == 1 then
		return true
	end

	return false
end

function modifier_imba_track_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
					  MODIFIER_EVENT_ON_HERO_KILLED}

	return decFuncs
end

function modifier_imba_track_debuff:OnHeroKilled(keys)
	if IsServer() then
		local unit = keys.unit

		-- Only apply if the target of the track debuff is the one who just died
		if unit == self.parent then
			-- If the unit was an illusion, do nothing
			if not unit:IsRealHero() then
				return nil
			end

			-- Give money to the track caster
			self.caster:ModifyGold(self.bonus_gold_self, true, 0)
			SendOverheadEventMessage(self.caster, OVERHEAD_ALERT_GOLD, self.caster, bonus_gold_self, nil)

			-- Find caster's allies nearby
			local allies = FindUnitsInRadius(caster:GetTeamNumber(),
											 self.parent,
											 nil,
											 self.haste_radius,
											 DOTA_UNIT_TARGET_TEAM_FRIENDLY,
											 DOTA_UNIT_TARGET_HERO,
											 DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
											 FIND_ANY_ORDER,
											 false)

			for _,ally in pairs(allies) do
				-- Give allies bonus allied gold, except caster				
				if ally ~= self.caster then
					ally:ModifyGold(self.bonus_gold_allies, true, 0)	
					SendOverheadEventMessage(ally, OVERHEAD_ALERT_GOLD, ally, bonus_gold_allies, nil)			
				end
			end
		end		
	end
end

function modifier_imba_track_debuff:GetModifierProvidesFOWVision()
	return 1
end

function modifier_imba_track_debuff:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end


-- Allied haste modifier
modifier_imba_track_buff = class({})

function modifier_imba_track_buff:OnCreated()	
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.particle_haste = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_haste.vpcf" 

		-- Ability specials
		self.ms_bonus_allies_pct = self.ability:GetSpecialValueFor("ms_bonus_allies_pct")	
		self.bonus_gold_allies = self.ability:GetSpecialValueFor("bonus_gold_allies")

	if IsServer() then
		-- Create haste particle
		self.particle_haste_fx = ParticleManager:CreateParticle(self.particle_haste, PATTACH_ABSORIGIN_FOLLOW, self.parent)		
		ParticleManager:SetParticleControl(self.particle_haste_fx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_haste_fx, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_haste_fx, 2, self.parent:GetAbsOrigin())
		
		self:AddParticle(self.particle_haste_fx, false, false, -1, false, false)
	end
end

function modifier_imba_track_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_imba_track_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus_allies_pct
end



-------------------------------------------
--	   	       HEADHUNTER
-------------------------------------------

imba_bounty_hunter_headhunter = class({})
LinkLuaModifier("modifier_imba_headhunter", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_headhunter_debuff", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_headhunter_buff", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_headhunter_debuff_illusion", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)

function imba_bounty_hunter_headhunter:GetIntrinsicModifierName()
	return "modifier_imba_headhunter"
end

function imba_bounty_hunter_headhunter:OnProjectileHit(target, location)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self	
	local modifier_contract_buff = "modifier_imba_headhunter_buff"
	local modifier_contract_debuff = "modifier_imba_headhunter_debuff"

	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")
	local vision_radius = ability:GetSpecialValueFor("vision_radius")
	local vision_linger_time = ability:GetSpecialValueFor("vision_linger_time")

	-- Check that the target exists
	if not target then
		return nil
	end

	-- Apply contract modifiers	
	caster:AddNewModifier(caster, ability, modifier_contract_buff, {duration = duration})
	target:AddNewModifier(caster, ability, modifier_contract_debuff, {duration = duration})

	-- Show the area of the target
	AddFOWViewer(caster:GetTeamNumber(), target:GetAbsOrigin(), vision_radius, vision_linger_time, false)
end

--Contract buff (self)
modifier_imba_headhunter = class({})

function modifier_imba_headhunter:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()			
		self.modifier_contract = "modifier_imba_headhunter_debuff"
		self.particle_projectile = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_cast.vpcf"

		-- Ability specials
		self.projectile_speed = self.ability:GetSpecialValueFor("projectile_speed")		
		self.starting_cd = self.ability:GetSpecialValueFor("starting_cd")		
		self.vision_radius = self.ability:GetSpecialValueFor("vision_radius")

		-- Start the game with a cooldown
		self.ability:StartCooldown(self.starting_cd)

		self:StartIntervalThink(3)
	end
end

function modifier_imba_headhunter:OnIntervalThink()
	if IsServer() then		
		-- Check if the game start cooldown ended
		if not self.ability:IsCooldownReady() then			
			return nil			
		end		

		-- if Bounty is currently broken, do nothing
		if self.caster:PassivesDisabled() then
			return nil
		end

		-- If Bounty is near the fountain, decide if a new contract should begin
		if IsNearFriendlyClass(self.caster, 1360, "ent_dota_fountain") then			
			-- Find all enemy heroes and look for a contract debuff
			local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
											  self.caster:GetAbsOrigin(),
											  nil,
											  50000, -- global
											  DOTA_UNIT_TARGET_TEAM_ENEMY,
											  DOTA_UNIT_TARGET_HERO,
											  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
											  FIND_ANY_ORDER,
											  false)	

			-- Iterate each enemy
			for _, enemy in pairs(enemies) do
				-- Check if that hero has the contract debuff, go out if it was found				
				if enemy:HasModifier(self.modifier_contract) then					
					return nil
				end
			end			

			-- Check that an enemy really exists
			if not enemies[1] then
				return nil
			end

			-- If no enemy was found with a contract in the search, start a new contract with a random enemy		
			local contract_enemy = enemies[1]			

			-- Launch projectile on target
			local contract_projectile
			contract_projectile =   {
									Target = contract_enemy,
									Source = self.caster,
									Ability = self.ability,
									EffectName = self.particle_projectile,
									iMoveSpeed = self.projectile_speed,
									bDodgeable = false, 
									bVisibleToEnemies = true,
									bReplaceExisting = false,
									bProvidesVision = true,		
									iVisionRadius = self.vision_radius,
									iVisionTeamNumber = self.caster:GetTeamNumber()
									}

			ProjectileManager:CreateTrackingProjectile(contract_projectile)
		end
	end
end

function modifier_imba_headhunter:IsDebuff()
	return false
end

function modifier_imba_headhunter:IsPurgable()
	return false
end

function modifier_imba_headhunter:IsHidden()
	return true
end

-- Contract self buff
modifier_imba_headhunter_buff = class({})

function modifier_imba_headhunter_buff:IsDebuff()
	return false
end

function modifier_imba_headhunter_buff:IsPurgable()
	return false
end

function modifier_imba_headhunter_buff:IsHidden()
	return false
end


-- Contract debuff
modifier_imba_headhunter_debuff = class({})

function modifier_imba_headhunter_debuff:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.particle_contract = "particles/hero/bounty_hunter/bounty_hunter_headhunter_scroll.vpcf"
		self.modifier_contract_buff = "modifier_imba_headhunter_buff"
		self.track_debuff = "modifier_imba_track_debuff"
		self.track_ability_name = "imba_bounty_hunter_track"
		self.gold_minimum = self.ability:GetSpecialValueFor("gold_minimum")
		self.modifier_dummy = "modifier_imba_headhunter_debuff_illusion"

		-- Apply particles visible only to the caster's team
		self.particle_contract_fx = ParticleManager:CreateParticleForTeam(self.particle_contract, PATTACH_OVERHEAD_FOLLOW, self.parent, self.caster:GetTeamNumber())
		ParticleManager:SetParticleControl(self.particle_contract_fx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_contract_fx, 2, self.parent:GetAbsOrigin())	

		self:AddParticle(self.particle_contract_fx, false, false, -1, false, true)

		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_headhunter_debuff:OnIntervalThink()
	-- Find all heroes in the parent's team
	local heroes = FindUnitsInRadius(self.parent:GetTeamNumber(),
									 self.parent:GetAbsOrigin(),
									 nil,
									 50000, -- global
									 DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									 DOTA_UNIT_TARGET_HERO,
									 DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
									 FIND_ANY_ORDER,
									 false) 

	-- Check which of them are controlled by the same player and are illusions of the hero
	for _, hero in pairs(heroes) do
		if self.parent:GetPlayerID() == hero:GetPlayerID() and self.parent:GetUnitName() == hero:GetUnitName() and hero:IsIllusion() then
			-- Apply the debuff modifiers on those illusions as well, if they don't have it,
			-- however we apply dummy ones that only show particles
			hero:AddNewModifier(self.caster, self.ability, self.modifier_dummy, {duration = self:GetRemainingTime()})
		end
	end
end

function modifier_imba_headhunter_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_HERO_KILLED}

	return decFuncs
end

function modifier_imba_headhunter_debuff:OnHeroKilled(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target


		-- Only apply if Bounty was the killer, OR the target had Track on it
		if (self.caster == attacker and self.parent == target) or (self.parent == target and self.parent:HasModifier(self.track_debuff)) then
			-- Check if the caster has Track as an ability
			if self.caster:HasAbility(self.track_ability_name) then
				-- Get ability handle
				self.track_ability = self.caster:FindAbilityByName("imba_bounty_hunter_track")						
				-- Check if the ability has at least one level in it, if so, fetch allies gold value
				if self.track_ability:GetLevel() > 0 then
					self.contract_gold = self.track_ability:GetSpecialValueFor("bonus_gold_allies")
				end
			end

			-- If Track gold is defined, use it, otherwise use Headhunter's skill's minimum gold
			if not self.contract_gold then
				self.contract_gold = self.gold_minimum
			end

			-- Grant Bounty Hunter the gold for completing the contract
			self.caster:ModifyGold(self.contract_gold, true, 0)	
			SendOverheadEventMessage(self.caster, OVERHEAD_ALERT_GOLD, self.caster, self.contract_gold, nil)			

			-- Remove the contract modifier from Bounty Hunter
			if self.caster:HasModifier(self.modifier_contract_buff) then
				self.caster:RemoveModifierByName(self.modifier_contract_buff)
			end
		end
	end
end

function modifier_imba_headhunter_debuff:IsDebuff()
	return true
end

function modifier_imba_headhunter_debuff:IsPurgable()
	return false
end

function modifier_imba_headhunter_debuff:IsHidden()
	return true
end

modifier_imba_headhunter_debuff_illusion = class({})

function modifier_imba_headhunter_debuff_illusion:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.particle_contract = "particles/hero/bounty_hunter/bounty_hunter_headhunter_scroll.vpcf"		

		self.particle_contract_fx = ParticleManager:CreateParticleForTeam(self.particle_contract, PATTACH_OVERHEAD_FOLLOW, self.parent, self.caster:GetTeamNumber())
		ParticleManager:SetParticleControl(self.particle_contract_fx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_contract_fx, 2, self.parent:GetAbsOrigin())	 	

		self:AddParticle(self.particle_contract_fx, false, false, -1, false, true)		
	end	
end 

function modifier_imba_headhunter_debuff_illusion:IsDebuff()
	return true
end

function modifier_imba_headhunter_debuff_illusion:IsPurgable()
	return false
end

function modifier_imba_headhunter_debuff_illusion:IsHidden()
	return true
end