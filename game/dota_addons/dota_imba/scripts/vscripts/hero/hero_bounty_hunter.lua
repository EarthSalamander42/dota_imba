-- Author: Shush
-- Date: 02/03/2017


CreateEmptyTalents("bounty_hunter")
local LinkedModifiers = {}
-------------------------------------------
--			SHURIKEN TOSS
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_shuriken_toss_debuff"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_shuriken_toss_stunned"] = LUA_MODIFIER_MOTION_NONE,
})
imba_bounty_hunter_shuriken_toss = imba_bounty_hunter_shuriken_toss or class({})

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
	if RollPercentage(25) then
		EmitSoundOn(cast_response, caster)
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)	

	-- Prepare enemy table
	local enemy_table = {}
	table.insert(enemy_table, target)
	local enemy_table_string = TableToStringCommaEnt(enemy_table)

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
		ExtraData = {enemy_table_string = enemy_table_string}
		}

	ProjectileManager:CreateTrackingProjectile(shuriken_projectile)

	-- If caster has scepter, launch another one after a second delay
	if scepter then
		Timers:CreateTimer(scepter_throw_delay, function()
			caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

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
			ExtraData = {enemy_table_string = enemy_table_string}
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
		local enemy_table_string = extradata.enemy_table_string
		local enemy_table = StringToTableEnt(enemy_table_string, ",")		

		-- Ability specials
		local projectile_speed = ability:GetSpecialValueFor("projectile_speed")		
		local damage = ability:GetSpecialValueFor("damage")
		local bounce_radius = ability:GetSpecialValueFor("bounce_radius")
		local stun_duration = ability:GetSpecialValueFor("stun_duration")	
		local scepter_stun_duration = ability:GetSpecialValueFor("scepter_stun_duration")
		local pull_duration = ability:GetSpecialValueFor("pull_duration")	

		-- #3 Talent - Shuriken Damage increase
		damage = damage + caster:FindTalentValue("special_bonus_imba_bounty_hunter_3")

		-- #5 Talent - Shuriken bounce radius becomes global		
		bounce_radius = bounce_radius + caster:FindTalentValue("special_bonus_imba_bounty_hunter_5")			

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

		target:AddNewModifier(caster, ability, "modifier_imba_shuriken_toss_stunned", {duration = stun_duration})

		-- Deal damage					
		local damageTable = {victim = target,
							damage = damage,
							damage_type = DAMAGE_TYPE_MAGICAL,
							attacker = caster,
							ability = ability
							}
							
		ApplyDamage(damageTable)	

		-- Apply pull modifier		
		target:AddNewModifier(caster, ability, "modifier_imba_shuriken_toss_debuff", {duration = pull_duration})

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

		
		local projectile_fired = false
		for _,enemy in pairs(enemies) do						
			-- Look for proper enemy to bounce to 					
			local enemy_found = false
			for _,enemy_in_table in pairs(enemy_table) do

				-- Find enemy in the table
				if enemy == enemy_in_table then
					enemy_found = true					
					break									
				end			
			end

			-- Only commence if the enemy has track and was not found in the table
			if enemy:HasModifier("modifier_imba_track_debuff_mark") and not enemy_found then
				
				-- Add enemy to the enemy table
				table.insert(enemy_table, enemy)					

				-- Stringify enemy table
				enemy_table_string = TableToStringCommaEnt(enemy_table)

				-- Bounce to enemy
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
				ExtraData = {enemy_table_string = enemy_table_string}
				}

				ProjectileManager:CreateTrackingProjectile(shuriken_projectile)

				projectile_fired = true				
				break -- Stop looking for this jump
			end						
		end
	end
end

function imba_bounty_hunter_shuriken_toss:IsHiddenWhenStolen()
	return false
end


-- Stun modifier
modifier_imba_shuriken_toss_stunned = modifier_imba_shuriken_toss_stunned or class({})

function modifier_imba_shuriken_toss_stunned:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state	
end

function modifier_imba_shuriken_toss_stunned:IsStunDebuff()
	return true
end

function modifier_imba_shuriken_toss_stunned:IsHidden()
	return false	
end

function modifier_imba_shuriken_toss_stunned:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_shuriken_toss_stunned:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
	

-- Pull modifier
modifier_imba_shuriken_toss_debuff = modifier_imba_shuriken_toss_debuff or class({})

function modifier_imba_shuriken_toss_debuff:OnCreated()
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

		self:StartIntervalThink(FrameTime())		
	end
end

function modifier_imba_shuriken_toss_debuff:OnIntervalThink()
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

function modifier_imba_shuriken_toss_debuff:OnRemoved()
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

function modifier_imba_shuriken_toss_debuff:IsDebuff()
	return true
end

function modifier_imba_shuriken_toss_debuff:IsHidden()
	return false
end

function modifier_imba_shuriken_toss_debuff:IsPurgable()
	return true
end


-------------------------------------------
--				JINADA
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_jinada_debuff_slow"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_jinada_buff_crit"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_jinada_passive"] = LUA_MODIFIER_MOTION_NONE,
})

imba_bounty_hunter_jinada = imba_bounty_hunter_jinada or class({})

function imba_bounty_hunter_jinada:IsNetherWardStealable() return false end

function imba_bounty_hunter_jinada:GetCooldown(level)	
	local caster = self:GetCaster()
	local cd = self.BaseClass.GetCooldown(self, level)

	-- #7 Talent cd reduction	
	cd = cd - caster:FindTalentValue("special_bonus_imba_bounty_hunter_7")
	return cd	
end

function imba_bounty_hunter_jinada:GetIntrinsicModifierName()
	return "modifier_imba_jinada_passive"
end

function imba_bounty_hunter_jinada:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()

		-- Check if caster has Track, or target is an ally
		if not target:HasModifier("modifier_imba_track_debuff_mark") or target:GetTeamNumber() == caster:GetTeamNumber() then
			return UF_FAIL_CUSTOM
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_bounty_hunter_jinada:GetCustomCastErrorTarget(target)	
	return "#dota_hud_error_shadow_jaunt_track"
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
			if caster:HasModifier("modifier_imba_jinada_buff_crit") then
				caster:RemoveModifierByName("modifier_imba_jinada_buff_crit")
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
modifier_imba_jinada_passive = modifier_imba_jinada_passive or class({})

function modifier_imba_jinada_passive:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_jinada_passive:OnCreated()	
	self:StartIntervalThink(0.2)
end

function modifier_imba_jinada_passive:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local crit_modifier = "modifier_imba_jinada_buff_crit"		
		
		-- Check if caster should have the crit modifier.
		if ability:IsCooldownReady() and not caster:HasModifier(crit_modifier) then
			caster:AddNewModifier(caster, ability, crit_modifier, {})
		end
	end
end

function modifier_imba_jinada_passive:IsHidden()
	return true
end

function modifier_imba_jinada_passive:IsPurgable()
	return false
end

function modifier_imba_jinada_passive:IsDebuff()
	return false	
end

-- Slow debuff modifier
modifier_imba_jinada_debuff_slow = modifier_imba_jinada_debuff_slow or class({})

function modifier_imba_jinada_debuff_slow:OnCreated()		
		-- Prepare variables
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")
		self.as_slow = self.ability:GetSpecialValueFor("as_slow")		
		
		-- #2 Talent: Jinada's slow increase
		 self.ms_slow_pct = self.ms_slow_pct + self.caster:FindTalentValue("special_bonus_imba_bounty_hunter_2")
		 self.as_slow = self.as_slow + self.caster:FindTalentValue("special_bonus_imba_bounty_hunter_2")
end

function modifier_imba_jinada_debuff_slow:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
					  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_imba_jinada_debuff_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end

function modifier_imba_jinada_debuff_slow:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow * (-1)
end

function modifier_imba_jinada_debuff_slow:IsDebuff()
	return true
end

function modifier_imba_jinada_debuff_slow:IsPurgable()
	return true
end

function modifier_imba_jinada_debuff_slow:IsHidden()
	return false
end


-- Jinada crit modifier
modifier_imba_jinada_buff_crit = modifier_imba_jinada_buff_crit or class({})

function modifier_imba_jinada_buff_crit:OnCreated()
	if IsServer() then
		self.parent = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.particle_glow = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_hand_l.vpcf"
		self.particle_hit = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_jinda_slow.vpcf"
		self.modifier_slow = "modifier_imba_jinada_debuff_slow"

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

function modifier_imba_jinada_buff_crit:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED,
						  MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE}
		
		return decFuncs	
end

function modifier_imba_jinada_buff_crit:OnAttackLanded(keys)
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

function modifier_imba_jinada_buff_crit:GetModifierPreAttack_CriticalStrike(keys)
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

function modifier_imba_jinada_buff_crit:IsHidden()
	return true
end

function modifier_imba_jinada_buff_crit:IsPurgable()
	return false	
end

function modifier_imba_jinada_buff_crit:IsDebuff()
	return false
end


-------------------------------------------
--			SHADOW WALK
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_shadow_walk_buff_invis"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_shadow_walk_vision"] = LUA_MODIFIER_MOTION_NONE,
})

imba_bounty_hunter_shadow_walk = imba_bounty_hunter_shadow_walk or class({})
LinkLuaModifier("modifier_imba_shadow_walk_buff_invis", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_walk_vision", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)

function imba_bounty_hunter_shadow_walk:IsNetherWardStealable() return false end
function imba_bounty_hunter_shadow_walk:GetCastRange(location, target)
	local caster = self:GetCaster()
	local ability = self
	local true_sight_radius = ability:GetSpecialValueFor("true_sight_radius")

	-- #1 Talent: Shadow Walk true sight radius increase	
	true_sight_radius = true_sight_radius + caster:FindTalentValue("special_bonus_imba_bounty_hunter_1")	
	return true_sight_radius
end

function imba_bounty_hunter_shadow_walk:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self
		local sound_cast = "Hero_BountyHunter.WindWalk"
		local cast_response = "bounty_hunter_bount_ability_windwalk_0"..RandomInt(1, 8)
		local particle_smoke = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf"
		local particle_invis_start = "particles/generic_hero_status/status_invisibility_start.vpcf"
		local modifier_invis = "modifier_imba_shadow_walk_buff_invis"

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
modifier_imba_shadow_walk_buff_invis = modifier_imba_shadow_walk_buff_invis or class({})

function modifier_imba_shadow_walk_buff_invis:OnCreated()	
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.invis_ms_bonus = self.ability:GetSpecialValueFor("invis_ms_bonus")
	self.true_sight_radius = self.ability:GetSpecialValueFor("true_sight_radius") 	
	
	-- #1 Talent: Shadow Walk true sight radius increase
	self.true_sight_radius = self.true_sight_radius + self.caster:FindTalentValue("special_bonus_imba_bounty_hunter_1")

end

function modifier_imba_shadow_walk_buff_invis:CheckState()
	local state = {[MODIFIER_STATE_INVISIBLE] = true,
				   [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	return state	
end

function modifier_imba_shadow_walk_buff_invis:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_imba_shadow_walk_buff_invis:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
					  MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
					  MODIFIER_EVENT_ON_ABILITY_EXECUTED,
					  MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFuncs
end

function modifier_imba_shadow_walk_buff_invis:GetModifierInvisibilityLevel()
	return 1
end

function modifier_imba_shadow_walk_buff_invis:GetModifierMoveSpeedBonus_Percentage()
	return self.invis_ms_bonus
end

function modifier_imba_shadow_walk_buff_invis:OnAbilityExecuted(keys)
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

function modifier_imba_shadow_walk_buff_invis:OnAttackLanded(keys)
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

function modifier_imba_shadow_walk_buff_invis:GetAuraRadius()
	return self.true_sight_radius
end

function modifier_imba_shadow_walk_buff_invis:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_imba_shadow_walk_buff_invis:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_shadow_walk_buff_invis:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_shadow_walk_buff_invis:GetModifierAura()
	return "modifier_imba_shadow_walk_vision"
end

function modifier_imba_shadow_walk_buff_invis:IsAura()
	return true
end

function modifier_imba_shadow_walk_buff_invis:IsDebuff()
	return false
end

function modifier_imba_shadow_walk_buff_invis:IsHidden()
	return false
end

function modifier_imba_shadow_walk_buff_invis:IsPurgable()
	return false
end

-- True sight debuff
modifier_imba_shadow_walk_vision = modifier_imba_shadow_walk_vision or class({})

function modifier_imba_shadow_walk_vision:CheckState()
	local state = {[MODIFIER_STATE_INVISIBLE] = false}				   
	return state	
end

function modifier_imba_shadow_walk_vision:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_imba_shadow_walk_vision:IsHidden()
	return true
end

function modifier_imba_shadow_walk_vision:IsPurgable()
	return false
end

function modifier_imba_shadow_walk_vision:IsDebuff()
	return true
end


-------------------------------------------
--				   TRACK
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_track_buff_ms"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_track_debuff_mark"] = LUA_MODIFIER_MOTION_NONE,
})

imba_bounty_hunter_track = imba_bounty_hunter_track or class({})
LinkLuaModifier("modifier_imba_track_debuff_mark", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_track_buff_ms_haste", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)

function imba_bounty_hunter_track:GetCooldown(level)
	local caster = self:GetCaster()

	-- #4 Talent: Track cooldown decrease
	return self.BaseClass.GetCooldown(self, level) - caster:FindTalentValue("special_bonus_imba_bounty_hunter_4")
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
		local modifier_track = "modifier_imba_track_debuff_mark"

		-- Ability specials
		local projectile_speed = ability:GetSpecialValueFor("projectile_speed")
		local duration = ability:GetSpecialValueFor("duration")

		-- #6 Talent: Track duration increase
		duration = duration + caster:FindTalentValue("special_bonus_imba_bounty_hunter_6")

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
modifier_imba_track_debuff_mark = modifier_imba_track_debuff_mark or class({})

function modifier_imba_track_debuff_mark:OnCreated()	
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

function modifier_imba_track_debuff_mark:CheckState()
	local state = {[MODIFIER_STATE_INVISIBLE] = false}
	return state
end

function modifier_imba_track_debuff_mark:GetAuraDuration()
	return self.haste_linger
end

function modifier_imba_track_debuff_mark:GetAuraRadius()
	return self.haste_radius
end

function modifier_imba_track_debuff_mark:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_imba_track_debuff_mark:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_track_debuff_mark:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_track_debuff_mark:GetModifierAura()
	return "modifier_imba_track_buff_ms"
end

function modifier_imba_track_debuff_mark:IsAura()
	return true
end

function modifier_imba_track_debuff_mark:IsDebuff()
	return true
end

function modifier_imba_track_debuff_mark:IsPurgable()	
	-- #8 Talent - unpurgable track
	local purge_value = self.caster:FindTalentValue("special_bonus_imba_bounty_hunter_8")
	if purge_value == 1 then
	 	return false
	end

	return true
end

function modifier_imba_track_debuff_mark:IsPermanent()
	return false
end

function modifier_imba_track_debuff_mark:IsHidden()	
	-- #8 Talent - unpurgable track
	local hidden_value = self.caster:FindTalentValue("special_bonus_imba_bounty_hunter_8")
	if hidden_value == 1 then
		return true
	end

	return false
end

function modifier_imba_track_debuff_mark:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
					  MODIFIER_EVENT_ON_HERO_KILLED}

	return decFuncs
end

function modifier_imba_track_debuff_mark:OnHeroKilled(keys)
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

function modifier_imba_track_debuff_mark:GetModifierProvidesFOWVision()
	return 1
end

function modifier_imba_track_debuff_mark:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end


-- Allied haste modifier
modifier_imba_track_buff_ms = modifier_imba_track_buff_ms or class({})

function modifier_imba_track_buff_ms:OnCreated()	
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

function modifier_imba_track_buff_ms:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_imba_track_buff_ms:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus_allies_pct
end



-------------------------------------------
--	   	       HEADHUNTER
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_headhunter_buff_handler"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_headhunter_passive"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_headhunter_debuff_handler"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_headhunter_debuff_illu"] = LUA_MODIFIER_MOTION_NONE,
})
imba_bounty_hunter_headhunter = imba_bounty_hunter_headhunter or class({})
LinkLuaModifier("modifier_imba_headhunter_passive", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_headhunter_debuff_handler", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_headhunter_buff_handler", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_headhunter_debuff_illu", "hero/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)

function imba_bounty_hunter_headhunter:GetIntrinsicModifierName()
	return "modifier_imba_headhunter_passive"
end

function imba_bounty_hunter_headhunter:IsInnateAbility()
	return true
end

function imba_bounty_hunter_headhunter:OnProjectileHit(target, location)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self	
	local modifier_contract_buff = "modifier_imba_headhunter_buff_handler"
	local modifier_contract_debuff = "modifier_imba_headhunter_debuff_handler"

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
modifier_imba_headhunter_passive = modifier_imba_headhunter_passive or class({})

function modifier_imba_headhunter_passive:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()			
		self.modifier_contract = "modifier_imba_headhunter_debuff_handler"
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

function modifier_imba_headhunter_passive:OnIntervalThink()
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

function modifier_imba_headhunter_passive:IsDebuff()
	return false
end

function modifier_imba_headhunter_passive:IsPurgable()
	return false
end

function modifier_imba_headhunter_passive:IsHidden()
	return true
end

-- Contract self buff
modifier_imba_headhunter_buff_handler = class({})

function modifier_imba_headhunter_buff_handler:IsDebuff()
	return false
end

function modifier_imba_headhunter_buff_handler:IsPurgable()
	return false
end

function modifier_imba_headhunter_buff_handler:IsHidden()
	return false
end


-- Contract debuff
modifier_imba_headhunter_debuff_handler = modifier_imba_headhunter_debuff_handler or class({})

function modifier_imba_headhunter_debuff_handler:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.particle_contract = "particles/hero/bounty_hunter/bounty_hunter_headhunter_scroll.vpcf"
		self.modifier_contract_buff = "modifier_imba_headhunter_buff_handler"
		self.track_debuff = "modifier_imba_track_debuff_mark"
		self.track_ability_name = "imba_bounty_hunter_track"
		self.gold_minimum = self.ability:GetSpecialValueFor("gold_minimum")
		self.modifier_dummy = "modifier_imba_headhunter_debuff_illu"

		-- Apply particles visible only to the caster's team
		self.particle_contract_fx = ParticleManager:CreateParticleForTeam(self.particle_contract, PATTACH_OVERHEAD_FOLLOW, self.parent, self.caster:GetTeamNumber())
		ParticleManager:SetParticleControl(self.particle_contract_fx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_contract_fx, 2, self.parent:GetAbsOrigin())	

		self:AddParticle(self.particle_contract_fx, false, false, -1, false, true)

		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_headhunter_debuff_handler:OnIntervalThink()
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

function modifier_imba_headhunter_debuff_handler:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_HERO_KILLED}

	return decFuncs
end

function modifier_imba_headhunter_debuff_handler:OnHeroKilled(keys)
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

function modifier_imba_headhunter_debuff_handler:IsDebuff()
	return true
end

function modifier_imba_headhunter_debuff_handler:IsPurgable()
	return false
end

function modifier_imba_headhunter_debuff_handler:IsHidden()
	return true
end

modifier_imba_headhunter_debuff_illu = modifier_imba_headhunter_debuff_illu or class({})

function modifier_imba_headhunter_debuff_illu:OnCreated()
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

function modifier_imba_headhunter_debuff_illu:IsDebuff()
	return true
end

function modifier_imba_headhunter_debuff_illu:IsPurgable()
	return false
end

function modifier_imba_headhunter_debuff_illu:IsHidden()
	return true
end
-------------------------------------------
for LinkedModifier, MotionController in pairs(LinkedModifiers) do
	LinkLuaModifier(LinkedModifier, "hero/hero_bounty_hunter", MotionController)
end