--[[
Author: Shush
Date: 13.09.2017
]]

-- CreateEmptyTalents("phantom_lancer")

--------------------------------------
--			SPIRIT LANCE            --
--------------------------------------
imba_phantom_lancer_spirit_lance = imba_phantom_lancer_spirit_lance or class({})
LinkLuaModifier("modifier_imba_spirit_lance_slow", "hero/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)

function imba_phantom_lancer_spirit_lance:OnAbilityPhaseStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()

	-- Ability specials
	local illusion_lance_cast_range = ability:GetSpecialValueFor("illusion_lance_cast_range")

	-- Find all nearby illusions
	local units = FindUnitsInRadius(caster:GetTeamNumber(),
	 									caster:GetAbsOrigin(),
	 									nil,
	 									illusion_lance_cast_range,
	 									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	 									DOTA_UNIT_TARGET_HERO,
	 									DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
	 									FIND_ANY_ORDER,
	 									false)	

	-- Cycle between found units, only include illusions
	for _, unit in pairs(units) do
		if unit:GetPlayerOwnerID() == caster:GetPlayerOwnerID() and unit ~= caster then			

			-- Fake casting animation
			unit:StartGesture(ACT_DOTA_CAST_ABILITY_1)				

			-- Illusions that are moving/attacking are ignored. Idle illusions fake their Spirit Lance
			if unit:IsIdle() then
				unit:FaceTowards(target:GetAbsOrigin())
			end			
		end
	end

	return true
end

function imba_phantom_lancer_spirit_lance:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local sound_cast = "Hero_PhantomLancer.SpiritLance.Throw"
	local projectile_lance = "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_projectile.vpcf"

	-- Ability specials
	local projectile_speed = ability:GetSpecialValueFor("projectile_speed")
	local illusion_lance_cast_range = ability:GetSpecialValueFor("illusion_lance_cast_range")	
	local scepter_bounce_count = ability:GetSpecialValueFor("scepter_bounce_count")

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Fire projectile at target	    
    local lance_projectile
    lance_projectile =	 {Target = target,
                          Source = caster,
                          Ability = ability,
                          EffectName = projectile_lance,
                          iMoveSpeed = projectile_speed,
                          bDodgeable = true, 
                          bVisibleToEnemies = true,
                          bReplaceExisting = false,
                          bProvidesVision = false,
                          ExtraData = {real_lance = 1, bounces_left = scepter_bounce_count}
    }

    ProjectileManager:CreateTrackingProjectile(lance_projectile)

	-- Nearby illusions also cast their own projectiles. Those are fake, of course
	-- Find all nearby illusions
	local units = FindUnitsInRadius(caster:GetTeamNumber(),
	 									caster:GetAbsOrigin(),
	 									nil,
	 									illusion_lance_cast_range,
	 									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	 									DOTA_UNIT_TARGET_HERO,
	 									DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
	 									FIND_ANY_ORDER,
	 									false)	

	-- Cycle between found units, only include illusions
	for _, unit in pairs(units) do
		if unit:GetPlayerOwnerID() == caster:GetPlayerOwnerID() and unit ~= caster then			
			lance_projectile =	 {Target = target,
		                          Source = unit,
		                          Ability = ability,
		                          EffectName = projectile_lance,
		                          iMoveSpeed = projectile_speed,
		                          bDodgeable = true, 
		                          bVisibleToEnemies = true,
		                          bReplaceExisting = false,
		                          bProvidesVision = false,
		                          ExtraData = {real_lance = 0, bounces_left = scepter_bounce_count}
    		}

    		ProjectileManager:CreateTrackingProjectile(lance_projectile)
		end
	end

end

function imba_phantom_lancer_spirit_lance:OnProjectileHit_ExtraData(target, location, extradata)
	-- If there was no target (disjointed), do nothing
	if not target then
		return nil
	end

	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_impact = "Hero_PhantomLancer.SpiritLance.Impact"	
	local scepter = caster:HasScepter()
	local modifier_slow = "modifier_imba_spirit_lance_slow"

	-- Ability specials
	local damage = ability:GetSpecialValueFor("damage")	
	local illusion_in_damage = ability:GetSpecialValueFor("illusion_in_damage")
	local illusion_out_damage = ability:GetSpecialValueFor("illusion_out_damage")
	local illusion_duration = ability:GetSpecialValueFor("illusion_duration")
	local slow_duration = ability:GetSpecialValueFor("slow_duration")
	local scepter_bounce_range = ability:GetSpecialValueFor("scepter_bounce_range")
	local scepter_bounce_count = ability:GetSpecialValueFor("scepter_bounce_count")
	local illusion_spawn_distance = ability:GetSpecialValueFor("illusion_spawn_distance")	
	local real_lance = extradata.real_lance
	local bounces_left = extradata.bounces_left

	-- If it was a fake lance, do nothing
	if real_lance == 0 then
		return nil
	end

	-- Play hit sound
	EmitSoundOn(sound_impact, target)

	-- Deal damage to target	
    local damageTable = {victim = target,
                         attacker = caster, 
                         damage = damage,
                         damage_type = DAMAGE_TYPE_MAGICAL,
                         ability = ability
                         }
        
    ApplyDamage(damageTable)  

	-- Slow target
	target:AddNewModifier(caster, ability, modifier_slow, {duration = slow_duration})

	-- Summon illusion
	-- Find valid space near the target
	local spawn_point = target:GetAbsOrigin() + RandomVector(illusion_spawn_distance)		

	-- Create illusion	
	local illusion = IllusionManager:CreateIllusion(caster, ability, target:GetAbsOrigin(), caster, {damagein = illusion_in_damage, damageout = illusion_out_damage, duration = illusion_duration, callback = attack_callback_func})		

	-- If caster has scepter, bounce, if applicable

		-- Each bounce has its own tag, summoning its own illusion
end


-- Slow modifier
modifier_imba_spirit_lance_slow = modifier_imba_spirit_lance_slow or class({})

function modifier_imba_spirit_lance_slow:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")

	if IsServer() then
		-- Apply hit effect
		self.particle_hit = "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_target.vpcf"

		local particle_hit_fx = ParticleManager:CreateParticle(self.particle_hit, PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(particle_hit_fx, 0, self.parent:GetAbsOrigin())

		self:AddParticle(particle_hit_fx, false, false, -1, false, false)
	end
end

function modifier_imba_spirit_lance_slow:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_imba_spirit_lance_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end