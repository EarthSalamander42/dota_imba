--[[
Author: sercankd
Date: 06.04.2017
Updated: 13.04.2017
]]

-------------------------------------------
-- Stifling Dagger
-------------------------------------------

imba_phantom_assassin_stifling_dagger = class({})

LinkLuaModifier("modifier_imba_stifling_dagger_slow", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_stifling_dagger_silence", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_stifling_dagger_bonus_damage", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_stifling_dagger_dmg_reduction", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_phantom_assassin_stifling_dagger:OnSpellStart()

    local caster 	= self:GetCaster()
	local ability 	= self
	local target 	= self:GetCursorTarget()
	local scepter 	= caster:HasScepter()

	--ability specials
	move_slow 				=	ability:GetSpecialValueFor("move_slow")
	dagger_speed 			=	ability:GetSpecialValueFor("dagger_speed")
	slow_duration 			=	ability:GetSpecialValueFor("slow_duration")
	silence_duration 		= 	ability:GetSpecialValueFor("silence_duration")
	damage_reduction 		=	ability:GetSpecialValueFor("damage_reduction")
	dagger_vision 			=	ability:GetSpecialValueFor("dagger_vision")
	scepter_knives_interval =	0.3
	cast_range				=	ability:GetCastRange(caster:GetAbsOrigin(), target)
	playbackrate			=	1 + scepter_knives_interval

	--TALENT: +35 Stifling Dagger bonus damage
	if caster:HasTalent("special_bonus_imba_phantom_assassin_1") then
    	bonus_damage	=	ability:GetSpecialValueFor("bonus_damage") + self:GetCaster():FindTalentValue("special_bonus_imba_phantom_assassin_1")
  	else
		bonus_damage	=	ability:GetSpecialValueFor("bonus_damage")
	end
	--coup de grace variables
	local ability_crit = caster:FindAbilityByName("modifier_imba_coup_de_grace")
	local ps_coup_modifier = "modifier_imba_phantom_strike_coup_de_grace"

	StartSoundEvent("Hero_PhantomAssassin.Dagger.Cast", caster)

	local extra_data = {main_dagger = true}

	local dagger_projectile

	dagger_projectile = {
			EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
			Dodgeable = true,
			Ability = ability,
			ProvidesVision = true,
			VisionRadius = 600,
			bVisibleToEnemies = true,
			iMoveSpeed = dagger_speed,
			Source = caster,
			iVisionTeamNumber = caster:GetTeamNumber(),
			Target = target,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
			bReplaceExisting = false,
			ExtraData = extra_data
		}
	ProjectileManager:CreateTrackingProjectile( dagger_projectile )


	-- Secondary knives		
	if scepter or caster:HasTalent("special_bonus_imba_phantom_assassin_3") then

		local secondary_knives_thrown = 0

		--TALENT: +1 Stifling Dagger bonus dagger (like aghs)
		if not scepter and caster:HasTalent("special_bonus_imba_phantom_assassin_3") then
			scepter_dagger_count = self:GetCaster():FindTalentValue("special_bonus_imba_phantom_assassin_3") + 1
			secondary_knives_thrown = 1
		elseif scepter and caster:HasTalent("special_bonus_imba_phantom_assassin_3") then
			scepter_dagger_count = ability:GetSpecialValueFor("scepter_dagger_count") + self:GetCaster():FindTalentValue("special_bonus_imba_phantom_assassin_3")
		else
			scepter_dagger_count = ability:GetSpecialValueFor("scepter_dagger_count")
		end
		-- Prepare extra_data
		extra_data = {main_dagger = false}			

		-- Clear marks from all enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
											caster:GetAbsOrigin(),
											nil,
											cast_range,
											DOTA_UNIT_TARGET_TEAM_ENEMY,
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
											DOTA_UNIT_TARGET_FLAG_NONE,
											FIND_UNITS_EVERYWHERE,
											false)
		for _, enemy in pairs (enemies) do
			enemy.hit_by_pa_dagger = false
		end

		-- Mark the main target, set variables
		target.hit_by_pa_dagger = true
		local dagger_target_found
								
		-- Look for a secondary target to throw a knife at
		Timers:CreateTimer(scepter_knives_interval, function()
			-- Set variable for clear action
			dagger_target_found = false

			-- Look for a target in the cast range of the spell
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
											caster:GetAbsOrigin(),
											nil,
											cast_range,
											DOTA_UNIT_TARGET_TEAM_ENEMY,
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
											DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
											FIND_ANY_ORDER,
											false)

			-- Check if there's an enemy unit without a mark. Mark it and throw a dagger to it
			for _, enemy in pairs (enemies) do
				if not enemy.hit_by_pa_dagger then
					enemy.hit_by_pa_dagger = true
					dagger_target_found = true	

					caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, playbackrate)

					dagger_projectile = {
										EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
										Dodgeable = true,
										Ability = ability,
										ProvidesVision = true,
										VisionRadius = 600,
										bVisibleToEnemies = true,
										iMoveSpeed = dagger_speed,
										Source = caster,
										iVisionTeamNumber = caster:GetTeamNumber(),
										Target = enemy,
										iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
										bReplaceExisting = false,
										ExtraData = extra_data
										}

					ProjectileManager:CreateTrackingProjectile(dagger_projectile)
					break -- only hit the first enemy found
				end
			end

			-- If all enemies were found with a mark, clear all marks from everyone
			if not dagger_target_found then
				for _, enemy in pairs (enemies) do
					enemy.hit_by_pa_dagger = false						
				end

				-- Throw dagger at a random enemy
				local enemy = enemies[RandomInt(1, #enemies)]
				
				dagger_projectile = {
									EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
									Dodgeable = true,
									Ability = ability,
									ProvidesVision = true,
									VisionRadius = 600,
									bVisibleToEnemies = true,
									iMoveSpeed = dagger_speed,
									Source = caster,
									iVisionTeamNumber = caster:GetTeamNumber(),
									Target = enemy,
									iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
									bReplaceExisting = false,
									ExtraData = extra_data
									}

				ProjectileManager:CreateTrackingProjectile(dagger_projectile)
			end				

			-- Check if there are knives remaining
			secondary_knives_thrown = secondary_knives_thrown + 1
			if secondary_knives_thrown < scepter_dagger_count then
				return scepter_knives_interval
			else
				return nil
			end
		end)
			
	end

end

function imba_phantom_assassin_stifling_dagger:OnProjectileHit( target, location )

    local caster = self:GetCaster()                                                                                 
	local response_stifling_dagger = "phantom_assassin_phass_ability_stiflingdagger_0"..math.random(1,4)

	if not target then
		return nil
	end

	--with 20 percentage play random stifling dagger response
	if RollPercentage(20) then
		caster:EmitSound(response_stifling_dagger)
	end

	-- If the target possesses a ready Linken's Sphere, do nothing else
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end


	-- If coup de grace is learned, roll for crits
	if ability_crit and ability_crit:GetLevel() > 0 then

		-- Crit parameters
		local crit_chance = ability_crit:GetSpecialValueFor("crit_chance")

		--if we have phantom strike modifier, apply bonus percentage to our crit_chance
		if caster:HasModifier(ps_coup_modifier) then
			ps_coup_modifier_handler = caster:FindModifierByName(ps_coup_modifier)
			bonus_coup_de_grace_chance = ps_coup_modifier_handler:GetAbility():GetSpecialValueFor("bonus_coup_de_grace")
			crit_chance_total = crit_chance + bonus_coup_de_grace_chance
		else
			crit_chance_total = crit_chance
		end

		if RollPercentage(crit_chance) then
			caster:AddNewModifier(caster, self, "modifier_imba_coup_de_grace_crit", {duration = 1.0})
		end
	end

	-- Apply slow and silence modifiers
	if not target:IsMagicImmune() then
		target:AddNewModifier(caster, self, "modifier_imba_stifling_dagger_silence", {duration = silence_duration})
		target:AddNewModifier(caster, self, "modifier_imba_stifling_dagger_slow", {duration = slow_duration})
	end

	caster:AddNewModifier(caster, self, "modifier_imba_stifling_dagger_dmg_reduction", {})
	caster:AddNewModifier(caster, self, "modifier_imba_stifling_dagger_bonus_damage", {})

	-- Attack (calculates on-hit procs)
	local initial_pos = caster:GetAbsOrigin()
	local target_pos = target:GetAbsOrigin()

	caster:SetAbsOrigin(target_pos)
	-- caster:PerformAttack(target, false, true, true, true, false, false, true)
	caster:PerformAttack(target, true, true, true, true, true, false, true)
	caster:SetAbsOrigin(initial_pos)

	caster:RemoveModifierByName( "modifier_imba_stifling_dagger_bonus_damage" )
	caster:RemoveModifierByName( "modifier_imba_stifling_dagger_dmg_reduction" )
	return true
end

-------------------------------------------
-- Stifling Dagger slow modifier
-------------------------------------------

modifier_imba_stifling_dagger_slow = class({})

function modifier_imba_stifling_dagger_slow:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local dagger_vision = ability:GetSpecialValueFor("dagger_vision")	
		local duration = ability:GetSpecialValueFor("slow_duration")
		local stifling_dagger_modifier_slow_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
		ParticleManager:ReleaseParticleIndex(stifling_dagger_modifier_slow_particle)

		-- Add vision for the duration	
		AddFOWViewer(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), dagger_vision, duration, false)
	end
end

function modifier_imba_stifling_dagger_slow:DeclareFunctions()
  local funcs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_STATE_PROVIDES_VISION }
  return funcs
end

function modifier_imba_stifling_dagger_slow:GetModifierMoveSpeedBonus_Percentage()
  	return self:GetAbility():GetSpecialValueFor("move_slow");
end

function modifier_imba_stifling_dagger_slow:GetModifierProvidesFOWVision()	return true end

function modifier_imba_stifling_dagger_slow:IsDebuff()		return true end

function modifier_imba_stifling_dagger_slow:IsPurgable()	return true end

-------------------------------------------
-- Stifling Dagger silence modifier
-------------------------------------------

modifier_imba_stifling_dagger_silence = class({})

function modifier_imba_stifling_dagger_silence:OnCreated()
  self.stifling_dagger_modifier_silence_particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_silenced.vpcf", PATTACH_OVERHEAD_FOLLOW, self.target)
  ParticleManager:ReleaseParticleIndex(self.stifling_dagger_modifier_silence_particle)
end

function modifier_imba_stifling_dagger_silence:CheckState()
	local states = { [MODIFIER_STATE_SILENCED] = true, }
	return states
end

function modifier_imba_stifling_dagger_silence:IsDebuff() 	return true end

function modifier_imba_stifling_dagger_silence:IsPurgable()	return true end

function modifier_imba_stifling_dagger_silence:IsHidden()		return true end

-------------------------------------------
-- Stifling Dagger bonus damage modifier
-------------------------------------------

modifier_imba_stifling_dagger_bonus_damage = class({})

function modifier_imba_stifling_dagger_bonus_damage:DeclareFunctions()
  local funcs = { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE }
  return funcs
end

function modifier_imba_stifling_dagger_bonus_damage:GetModifierPreAttack_BonusDamage()
	local ability = self:GetAbility()
  	return ability:GetSpecialValueFor("bonus_damage");
end

function modifier_imba_stifling_dagger_bonus_damage:IsBuff()			return true end

function modifier_imba_stifling_dagger_bonus_damage:IsPurgable() 	return false end

function modifier_imba_stifling_dagger_bonus_damage:IsHidden() 	  return true end

-------------------------------------------
-- Stifling Dagger damage reduction modifier
-------------------------------------------

modifier_imba_stifling_dagger_dmg_reduction = class({})

function modifier_imba_stifling_dagger_dmg_reduction:OnCreated()
	self.ability = self:GetAbility()
	self.damage_reduction = self.ability:GetSpecialValueFor("damage_reduction")
end

function modifier_imba_stifling_dagger_dmg_reduction:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE}
	return decFunc
end

function modifier_imba_stifling_dagger_dmg_reduction:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage_reduction * (-1)
end


----------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------
-- Phantom Strike
-------------------------------------------

imba_phantom_assassin_phantom_strike = class({})

LinkLuaModifier("modifier_imba_phantom_strike", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantom_strike_coup_de_grace", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_phantom_assassin_phantom_strike:OnSpellStart()
if IsServer() then
	self.caster 	= self:GetCaster()
	self.ability	= self
	self.target 	= self:GetCursorTarget()
	
	--ability specials
	self.bonus_attack_speed =	self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.buff_duration 		=	self.ability:GetSpecialValueFor("buff_duration")
	self.projectile_speed 	=	self.ability:GetSpecialValueFor("projectile_speed")
	self.projectile_width 	=	self.ability:GetSpecialValueFor("projectile_width")
	
	--TALENT: +30 Phantom Strike bonus attack speed
	if self.caster:HasTalent("special_bonus_imba_phantom_assassin_2") then
    	self.bonus_attack_speed	=	self.ability:GetSpecialValueFor("bonus_attack_speed") + self.caster:FindTalentValue("special_bonus_imba_phantom_assassin_2")
  	else
		self.bonus_attack_speed =	self.ability:GetSpecialValueFor("bonus_attack_speed")
	end

	-- Trajectory calculations
	self.caster_pos = self.target:GetAbsOrigin()
	self.target_pos = self.target:GetAbsOrigin()
	self.direction	= ( self.target_pos - self.caster_pos ):Normalized()
	self.distance = ( self.target_pos - self.caster_pos ):Length2D()

	-- If the target possesses a ready Linken's Sphere, do nothing else
	if self.target:GetTeamNumber() ~= self.caster:GetTeamNumber() then
		if self.target:TriggerSpellAbsorb(self.ability) then
			return nil
		end
	end

	self.blink_projectile = {
		Ability				= self.ability,
		vSpawnOrigin		= self.caster_pos,
		fDistance			= self.distance,
		fStartRadius		= self.projectile_width,
		fEndRadius			= self.projectile_width,
		Source				= self.caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		bDeleteOnHit		= false,
		vVelocity			= Vector(self.direction.x, self.direction.y, 0) * self.projectile_speed,
		bProvidesVision		= false,
	}

	ProjectileManager:CreateLinearProjectile(self.blink_projectile)
	StartSoundEvent("Hero_PhantomAssassin.Strike.Start", self:GetCaster())

	-- Blink
	FindClearSpaceForUnit(self.caster, self.target_pos, true)
	self.caster:SetForwardVector( (self.target:GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized() )

	-- Disjoint projectiles
	ProjectileManager:ProjectileDodge(self.caster)

	-- Fire blink particle
	self.blink_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:ReleaseParticleIndex(self.blink_pfx)

	-- Fire blink end sound
	self.target:EmitSound("Hero_PhantomAssassin.Strike.End")

	-- Apply blink strike modifier on caster
	self.caster:AddNewModifier(self.caster, self, "modifier_imba_phantom_strike", { duration= self.buff_duration })

	-- Apply coup de grace modifier on caster
	self.caster:AddNewModifier(self.caster, self, "modifier_imba_phantom_strike_coup_de_grace", { duration= self.buff_duration })

	--Increased Coup de Grace chance for the next 4 attacks
	--TALENT
	if self.caster:HasTalent("special_bonus_imba_phantom_assassin_6") then
		attacks_count = self.caster:FindTalentValue("special_bonus_imba_phantom_assassin_6") + 4
	else
		attacks_count = 4
	end

	self.caster:SetModifierStackCount( "modifier_imba_phantom_strike_coup_de_grace", self.caster, attacks_count)

	-- If cast on an enemy, immediately start attacking it
	if self.caster:GetTeam() ~= self.target:GetTeam() then
		self.caster.phantom_strike_target = self.target
		self.caster:SetAttacking(self.target)
		self.caster:SetForceAttackTarget(self.target)
		Timers:CreateTimer(0.01, function()
			self.caster:SetForceAttackTarget(nil)
		end)
	end
end
end

-------------------------------------------
-- Phantom Strike modifier
-------------------------------------------

modifier_imba_phantom_strike = class({})

function modifier_imba_phantom_strike:DeclareFunctions()
  local funcs = { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT }
  return funcs
end

function modifier_imba_phantom_strike:GetModifierAttackSpeedBonus_Constant()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    self.speed_bonus = ability:GetSpecialValueFor("bonus_attack_speed") -- + caster:FindTalentValue("special_bonus_imba_axe_5")
    return self.speed_bonus
end

function modifier_imba_phantom_strike:IsBuff()		  return true end

function modifier_imba_phantom_strike:IsPurgable()  return true end

-------------------------------------------
-- Phantom Strike coup de grace modifier
-------------------------------------------

modifier_imba_phantom_strike_coup_de_grace = class({})

function modifier_imba_phantom_strike_coup_de_grace:DeclareFunctions()
  local funcs = { MODIFIER_EVENT_ON_ATTACK_LANDED }
  return funcs
end

function modifier_imba_phantom_strike_coup_de_grace:OnAttackLanded(keys)
  if IsServer() then
    local caster = self:GetCaster()
    local ability = self:GetAbility()
		local owner = self:GetParent()
		local modifier_ps_coup = "modifier_imba_phantom_strike_coup_de_grace"
		local stackcount = caster:GetModifierStackCount(modifier_ps_coup, self)

	-- If attack was not performed by the modifier's owner, do nothing
	if owner ~= keys.attacker then
		return end

	if stackcount == 1 then
		caster:RemoveModifierByName(modifier_ps_coup)
	else
		caster:SetModifierStackCount( "modifier_imba_phantom_strike_coup_de_grace", self, stackcount - 1)
	end
  end
end

function modifier_imba_phantom_strike_coup_de_grace:IsBuff()			return true end

function modifier_imba_phantom_strike_coup_de_grace:IsPurgable()	return true end

----------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------
-- Blur
-------------------------------------------

imba_phantom_assassin_blur = class({})

LinkLuaModifier("modifier_imba_blur", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_blur_blur", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE) --wat
LinkLuaModifier("modifier_imba_blur_speed", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_blur_speed_dummy", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_blur_opacity", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_phantom_assassin_blur:GetIntrinsicModifierName()
  return "modifier_imba_blur"
end

function imba_phantom_assassin_blur:OnUpgrade()
  local caster = self:GetCaster()
  local modifier_aura = "modifier_imba_blur"
  if caster:HasModifier(modifier_aura) then
    caster:RemoveModifierByName(modifier_aura)
    caster:AddNewModifier(caster, self, modifier_aura, {})
  end
end

-------------------------------------------
-- Blur modifier
-------------------------------------------

modifier_imba_blur = class({})

function modifier_imba_blur:OnCreated()
  if IsServer() then
    self:StartIntervalThink(0.2)
  end
end

function modifier_imba_blur:OnIntervalThink()
  if IsServer() then
	local caster = self:GetCaster()
	local modifier_aura = "modifier_imba_blur_blur"
	local modifier_blur_transparent = "modifier_imba_blur_opacity"
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	local responses_blur = "phantom_assassin_phass_ability_blur_0"..math.random(1,3)
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	-- If there is at least one, apply the blur modifier
	if #nearby_enemies > 0 and caster:HasModifier(modifier_aura) then
		caster:RemoveModifierByName(modifier_aura)
		-- make mortred transparent (wtf firetoad)
		caster:AddNewModifier(caster, self, modifier_blur_transparent, {})
	-- Else, if there are no enemies, remove the modifier
	elseif #nearby_enemies == 0 and not caster:HasModifier(modifier_aura) then
		caster:AddNewModifier(caster, self, modifier_aura, {})
		-- make mortred not transparent (wtf firetoad)
		caster:RemoveModifierByName(modifier_blur_transparent)
		caster:EmitSound(responses_blur)
	end
  end
end


function modifier_imba_blur:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_EVASION_CONSTANT, MODIFIER_EVENT_ON_ATTACK_FAIL, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE }
	return funcs
end

function modifier_imba_blur:GetModifierEvasion_Constant()
	return self:GetAbility():GetSpecialValueFor("evasion")
end

function modifier_imba_blur:GetModifierIncomingDamage_Percentage()
	local caster = self:GetCaster()
    --TALENT: Blur now grants +30% chance to evade any damage
	if caster:HasTalent("special_bonus_imba_phantom_assassin_8") then
		if RollPercentage(caster:FindTalentValue("special_bonus_imba_phantom_assassin_8")) then
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_EVADE, caster, 0, nil)
			return -100
		end
	else
		return nil
	end
end

function modifier_imba_blur:OnAttackFail(keys)
  if IsServer() then
	local ms_duration = self:GetAbility():GetSpecialValueFor("speed_bonus_duration")
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local dummy_modifier = "modifier_imba_blur_speed_dummy"

	if keys.target == self:GetParent() then
	--apply real modifier
		caster:AddNewModifier(caster, ability, "modifier_imba_blur_speed", {duration = ms_duration})
		if not caster:HasModifier(dummy_modifier) then
			--apply dummy modifier
				modifier_dummy = caster:AddNewModifier(caster, ability, dummy_modifier, {duration = ms_duration})
				modifier_dummy:IncrementStackCount()
		else
				modifier_dummy = caster:FindModifierByName( dummy_modifier )
				modifier_dummy:IncrementStackCount()
				modifier_dummy:SetDuration( ms_duration, true )
		end
	end
  end
end

function modifier_imba_blur:IsPassive()   return true end

function modifier_imba_blur:IsHidden()	  return true end

function modifier_imba_blur:IsBuff()			return true end

function modifier_imba_blur:IsPurgable()  return false end

-------------------------------------------
-- Blur blur modifier 
-------------------------------------------

modifier_imba_blur_blur = class({})

function modifier_imba_blur_blur:OnCreated()
    self.blur_particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
end

function modifier_imba_blur_blur:GetStatusEffectName()
	return "particles/hero/phantom_assassin/blur_status_fx.vpcf"
end

function modifier_imba_blur_blur:StatusEffectPriority()  return 11 end

function modifier_imba_blur_blur:CheckState()
	local states = { [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true, }
	return states
end

function modifier_imba_blur_blur:IsPassive()   return false end

function modifier_imba_blur_blur:IsHidden()	   return true end

function modifier_imba_blur_blur:IsBuff()			 return true end

function modifier_imba_blur_blur:IsPurgable()  return false end

function modifier_imba_blur_blur:OnRemoved()
    ParticleManager:DestroyParticle(self.blur_particle, false)
    ParticleManager:ReleaseParticleIndex(self.blur_particle)
end

-------------------------------------------
-- Blur speed modifier
-------------------------------------------

modifier_imba_blur_speed = class({})

function modifier_imba_blur_speed:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
	return funcs
end

function modifier_imba_blur_speed:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_imba_blur_speed:GetModifierMoveSpeedBonus_Percentage()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local stack_count = caster:GetModifierStackCount("modifier_imba_blur_speed_dummy", ability)
 	return self:GetAbility():GetSpecialValueFor("blur_ms") * stack_count
end

function modifier_imba_blur_speed:IsPassive()  	return false end

function modifier_imba_blur_speed:IsHidden()  	return true end

function modifier_imba_blur_speed:IsBuff()  		return true end

function modifier_imba_blur_speed:IsPurgable()  return false end

function modifier_imba_blur_speed:OnRemoved()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local bonus_speed_dummy = "modifier_imba_blur_speed_dummy"
		local bonus_speed_dummy_handler = caster:FindModifierByName(bonus_speed_dummy)
		if caster:HasModifier(bonus_speed_dummy) then
			bonus_speed_dummy_handler:DecrementStackCount()
		end
	end
end

-------------------------------------------
-- Blur speed dummy modifier
-------------------------------------------

modifier_imba_blur_speed_dummy = class({})

function modifier_imba_blur_speed_dummy:IsPassive()	return false end

function modifier_imba_blur_speed_dummy:IsHidden()	return false end

function modifier_imba_blur_speed_dummy:IsBuff()	return true end

function modifier_imba_blur_speed_dummy:IsPurgable()return false end

-------------------------------------------
-- Blur opacity modifier
-------------------------------------------

modifier_imba_blur_opacity = class({})

function modifier_imba_blur_opacity:IsPassive()	return false end

function modifier_imba_blur_opacity:IsHidden()	return false end

function modifier_imba_blur_opacity:IsBuff()	return true end

function modifier_imba_blur_opacity:IsPurgable()return false end

function modifier_imba_blur_opacity:DeclareFunctions()
    return { MODIFIER_PROPERTY_INVISIBILITY_LEVEL }
end

function modifier_imba_blur_opacity:GetModifierInvisibilityLevel(params)
    return 1.0
end

function modifier_imba_blur_opacity:IsHidden()
    return true
end
----------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------
-- Coup De Grace
-------------------------------------------

imba_phantom_assassin_coup_de_grace = class({})

LinkLuaModifier("modifier_imba_coup_de_grace", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_coup_de_grace_crit", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_coup_de_grace_bonus_damage", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_coup_de_grace_bonus_damage_dummy", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_phantom_assassin_coup_de_grace:GetIntrinsicModifierName()
  return "modifier_imba_coup_de_grace"
end

function imba_phantom_assassin_coup_de_grace:OnUpgrade()
  local caster = self:GetCaster()
  local modifier_aura = "modifier_imba_coup_de_grace"
  if caster:HasModifier(modifier_aura) then
    caster:RemoveModifierByName(modifier_aura)
    caster:AddNewModifier(caster, self, modifier_aura, {})
  end
end

-------------------------------------------
-- Coup De Grace modifier
-------------------------------------------

modifier_imba_coup_de_grace = class({})

function modifier_imba_coup_de_grace:DeclareFunctions()
  local funcs = { MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE }
  return funcs
end

function modifier_imba_coup_de_grace:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() then

		caster = self:GetCaster()
		ability = self:GetAbility()
		target = keys.target
		--ability specials
		crit_chance = ability:GetSpecialValueFor("crit_chance")
		crit_increase_damage = ability:GetSpecialValueFor("crit_increase_damage")
		crit_increase_duration = ability:GetSpecialValueFor("crit_increase_duration")
		ps_coup_modifier = "modifier_imba_phantom_strike_coup_de_grace"
		responses_coup_de_grace = "phantom_assassin_phass_ability_coupdegrace_0"..math.random(1,4)
		--ignore crit for buildings
		if target:IsBuilding() then 
			return end      

        --if we have phantom strike modifier, apply bonus percentage to our crit_chance
        if caster:HasModifier(ps_coup_modifier) then
            local ps_coup_modifier_handler = caster:FindModifierByName(ps_coup_modifier)
            if ps_coup_modifier_handler then
					--TALENT: +5% Phantom Strike bonus crit chance
					if caster:HasTalent("special_bonus_imba_phantom_assassin_4") then
						bonus_coup_de_grace_chance = ps_coup_modifier_handler:GetAbility():GetSpecialValueFor("bonus_coup_de_grace") + self:GetCaster():FindTalentValue("special_bonus_imba_phantom_assassin_4")
					else
						bonus_coup_de_grace_chance = ps_coup_modifier_handler:GetAbility():GetSpecialValueFor("bonus_coup_de_grace")
					end
                crit_chance_total = crit_chance + bonus_coup_de_grace_chance
            end            
        else
            crit_chance_total = crit_chance
        end

        if RollPercentage(crit_chance) then

			local coup_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, target)
			local dummy_modifier = "modifier_imba_coup_de_grace_bonus_damage_dummy"
			ParticleManager:SetParticleControlEnt(coup_pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(coup_pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(coup_pfx)
			
			StartSoundEvent("Hero_PhantomAssassin.CoupDeGrace", target)

			--TALENT: +8 sec Coup de Grace bonus damage duration
			if caster:HasTalent("special_bonus_imba_phantom_assassin_7") then
				crit_duration = crit_increase_duration + self:GetCaster():FindTalentValue("special_bonus_imba_phantom_assassin_7")
			else
				crit_duration = crit_increase_duration
			end
			--apply real bonus damage modifier
			caster:AddNewModifier(caster, ability, "modifier_imba_coup_de_grace_bonus_damage", {duration = crit_duration})
			if not caster:HasModifier(dummy_modifier) then
				--apply dummy modifier
				modifier_dummy = caster:AddNewModifier(caster, ability, dummy_modifier, {duration = crit_duration})
				modifier_dummy:IncrementStackCount()
			else
				modifier_dummy = caster:FindModifierByName( dummy_modifier )
				modifier_dummy:IncrementStackCount()
				modifier_dummy:SetDuration( crit_increase_duration, true )
			end

			caster:EmitSound(responses_coup_de_grace)
			--TALENT: +100% Coup de Grace crit damage
			if caster:HasTalent("special_bonus_imba_phantom_assassin_5") then
				crit_bonus	=	ability:GetSpecialValueFor("crit_bonus") + self:GetCaster():FindTalentValue("special_bonus_imba_phantom_assassin_5")
			else
				crit_bonus	=	ability:GetSpecialValueFor("crit_bonus")
			end
            return crit_bonus
        end
        return nil        
	end
end

function modifier_imba_coup_de_grace:IsPassive()	return true end

function modifier_imba_coup_de_grace:IsHidden()		return true end

-------------------------------------------
-- Coup De Grace bonus damage modifier
-------------------------------------------

modifier_imba_coup_de_grace_bonus_damage = class({})

function modifier_imba_coup_de_grace_bonus_damage:OnCreated()
	local ability = self:GetAbility()
	local caster = self:GetParent()
	local stack_count = caster:GetModifierStackCount("modifier_imba_coup_de_grace_bonus_damage_dummy", ability)
	self.bonus_percentage = ability:GetSpecialValueFor("crit_increase_damage") * stack_count
end

function modifier_imba_coup_de_grace_bonus_damage:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE }
	return funcs
end

function modifier_imba_coup_de_grace_bonus_damage:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_imba_coup_de_grace_bonus_damage:GetModifierDamageOutgoing_Percentage()
 	return self.bonus_percentage
end

function modifier_imba_coup_de_grace_bonus_damage:IsPassive()  return false end

function modifier_imba_coup_de_grace_bonus_damage:IsHidden()   return true end

function modifier_imba_coup_de_grace_bonus_damage:IsBuff() 		 return true end

function modifier_imba_coup_de_grace_bonus_damage:IsPurgable() return false end

function modifier_imba_coup_de_grace_bonus_damage:OnRemoved()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = self:GetParent()
		local bonus_damage_dummy = "modifier_imba_coup_de_grace_bonus_damage_dummy"
		local bonus_damage_dummy_handler = caster:FindModifierByName("modifier_imba_coup_de_grace_bonus_damage_dummy")

		if caster:HasModifier(bonus_damage_dummy) then
				bonus_damage_dummy_handler:DecrementStackCount()
		end
	end
end

-------------------------------------------
-- Coup De Grace bonus damage dummy modifier
-------------------------------------------

modifier_imba_coup_de_grace_bonus_damage_dummy = class({})

function modifier_imba_coup_de_grace_bonus_damage_dummy:IsPassive()  return false end

function modifier_imba_coup_de_grace_bonus_damage_dummy:IsHidden()   return false end

function modifier_imba_coup_de_grace_bonus_damage_dummy:IsBuff() 	   return true end

function modifier_imba_coup_de_grace_bonus_damage_dummy:IsPurgable() return false end


------------------------------------------------------------------------------------------------------------

-------------------------------------------
-- talent modifiers
-------------------------------------------

LinkLuaModifier("modifier_special_bonus_imba_phantom_assassin_1", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_imba_phantom_assassin_1 = class({})

function modifier_special_bonus_imba_phantom_assassin_1:IsHidden()
	return true
end

function modifier_special_bonus_imba_phantom_assassin_1:RemoveOnDeath()
	return false
end

LinkLuaModifier("modifier_special_bonus_imba_phantom_assassin_2", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_imba_phantom_assassin_2 = class({})

function modifier_special_bonus_imba_phantom_assassin_2:IsHidden()
	return true
end

function modifier_special_bonus_imba_phantom_assassin_2:RemoveOnDeath()
	return false
end

LinkLuaModifier("modifier_special_bonus_imba_phantom_assassin_3", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_imba_phantom_assassin_3 = class({})

function modifier_special_bonus_imba_phantom_assassin_3:IsHidden()
	return true
end

function modifier_special_bonus_imba_phantom_assassin_3:RemoveOnDeath()
	return false
end

LinkLuaModifier("modifier_special_bonus_imba_phantom_assassin_4", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_imba_phantom_assassin_4 = class({})

function modifier_special_bonus_imba_phantom_assassin_4:IsHidden()
	return true
end

function modifier_special_bonus_imba_phantom_assassin_4:RemoveOnDeath()
	return false
end

LinkLuaModifier("modifier_special_bonus_imba_phantom_assassin_5", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_imba_phantom_assassin_5 = class({})

function modifier_special_bonus_imba_phantom_assassin_5:IsHidden()
	return true
end

function modifier_special_bonus_imba_phantom_assassin_5:RemoveOnDeath()
	return false
end

LinkLuaModifier("modifier_special_bonus_imba_phantom_assassin_6", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_imba_phantom_assassin_6 = class({})

function modifier_special_bonus_imba_phantom_assassin_6:IsHidden()
	return true
end

function modifier_special_bonus_imba_phantom_assassin_6:RemoveOnDeath()
	return false
end

LinkLuaModifier("modifier_special_bonus_imba_phantom_assassin_7", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_imba_phantom_assassin_7 = class({})

function modifier_special_bonus_imba_phantom_assassin_7:IsHidden()
	return true
end

function modifier_special_bonus_imba_phantom_assassin_7:RemoveOnDeath()
	return false
end

LinkLuaModifier("modifier_special_bonus_imba_phantom_assassin_8", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_imba_phantom_assassin_8 = class({})

function modifier_special_bonus_imba_phantom_assassin_8:IsHidden()
	return true
end

function modifier_special_bonus_imba_phantom_assassin_8:RemoveOnDeath()
	return false
end