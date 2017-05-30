--[[
Author: sercankd
Date: 06.04.2017
Updated: 15.04.2017
]]

CreateEmptyTalents("phantom_assassin")

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
	cast_range				=	ability:GetCastRange(caster:GetAbsOrigin(), target) + GetCastRangeIncrease(caster)
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

		-- TALENT: +1 Stifling Dagger bonus dagger (like aghs)
		if not scepter and caster:HasTalent("special_bonus_imba_phantom_assassin_3") then
			scepter_dagger_count = self:GetCaster():FindTalentValue("special_bonus_imba_phantom_assassin_3")
			secondary_knives_thrown = scepter_dagger_count
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

	if not target then
		return nil
	end

	-- With 20 percentage play random stifling dagger response
	local responses = {"phantom_assassin_phass_ability_stiflingdagger_01","phantom_assassin_phass_ability_stiflingdagger_02","phantom_assassin_phass_ability_stiflingdagger_03","phantom_assassin_phass_ability_stiflingdagger_04"}
	caster:EmitCasterSound("npc_dota_hero_phantom_assassin",responses, 20, DOTA_CAST_SOUND_FLAG_NONE, 20,"stifling_dagger")

	-- If the target possesses a ready Linken's Sphere, do nothing else
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		if target:TriggerSpellAbsorb(self) then
			return nil
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

	-- Offset is necessary, because cleave from Battlefury doesn't work (in any direction) if you are exactly on top of the target unit
	local offset = 100 --dotameters (default melee range is 150 dotameters)
	
	-- Find the distance vector (distance, but as a vector rather than Length2D)
	-- z is 0 to prevent any wonkiness due to height differences, we'll use the targets height, unmodified
	local distance_vector = Vector(target_pos.x - initial_pos.x, target_pos.y - initial_pos.y, 0)
	-- Normalize it, so the offset can be applied to x/y components, proportionally
	distance_vector = distance_vector:Normalized()
	
	-- Offset the caster 100 units in front of the target
	target_pos.x = target_pos.x - offset * distance_vector.x
	target_pos.y = target_pos.y - offset * distance_vector.y
	
	caster:SetAbsOrigin(target_pos)
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
function imba_phantom_assassin_phantom_strike:IsNetherWardStealable() return false end
function imba_phantom_assassin_phantom_strike:CastFilterResultTarget(target)
    if IsServer() then
        local caster = self:GetCaster()
        local casterID = caster:GetPlayerOwnerID()
        local targetID = target:GetPlayerOwnerID()

        -- Can't cast on self (self blink!) 
        if target == caster then
        	return UF_FAIL_CUSTOM
       	end

        local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
        return nResult
    end
end

function imba_phantom_assassin_phantom_strike:GetCustomCastErrorTarget(target)
	return "dota_hud_error_cant_cast_on_self"
end

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
	self.attacks 			= 	self.ability:GetSpecialValueFor("attacks")
	
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
	local distance = (self.target:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D()
	local direction = (self.target:GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized()
	local blink_point = self.caster:GetAbsOrigin() + direction * (distance - 128)
	self.caster:SetAbsOrigin(blink_point)
	Timers:CreateTimer(FrameTime(), function()
		FindClearSpaceForUnit(self.caster, blink_point, true)
	end)
	
	self.caster:SetForwardVector(direction)

	-- Disjoint projectiles
	ProjectileManager:ProjectileDodge(self.caster)

	-- Fire blink particle
	self.blink_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:ReleaseParticleIndex(self.blink_pfx)

	-- Fire blink end sound
	self.target:EmitSound("Hero_PhantomAssassin.Strike.End")	

	-- Apply coup de grace modifier on caster it was an enemy
	if self.target:GetTeamNumber() ~= self.caster:GetTeamNumber() then

		-- Apply blink strike modifier on caster
		self.caster:AddNewModifier(self.caster, self, "modifier_imba_phantom_strike", { duration= self.buff_duration })

		-- Apply crit modifier
		self.caster:AddNewModifier(self.caster, self, "modifier_imba_phantom_strike_coup_de_grace", { duration= self.buff_duration })

		--Increased Coup de Grace chance for the next 4 attacks
		--TALENT
		if self.caster:HasTalent("special_bonus_imba_phantom_assassin_6") then
			attacks_count = self.caster:FindTalentValue("special_bonus_imba_phantom_assassin_6") + 4
		else			
			attacks_count = self.attacks
		end

		self.caster:SetModifierStackCount( "modifier_imba_phantom_strike_coup_de_grace", self.caster, attacks_count)

		-- If cast on an enemy, immediately start attacking it				
		self.caster:MoveToTargetToAttack(self.target)
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
    self.speed_bonus = ability:GetSpecialValueFor("bonus_attack_speed")
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
	local modifier_speed = "modifier_imba_phantom_strike"		
	local stackcount = self:GetStackCount()

	-- If attack was not performed by the modifier's owner, do nothing
	if owner ~= keys.attacker then
		return end

	if stackcount == 1 then
		print()
		self:Destroy()
		if caster:HasModifier(modifier_speed) then
			caster:RemoveModifierByName(modifier_speed)
		end
	else
		self:DecrementStackCount()
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
LinkLuaModifier("modifier_imba_blur_opacity", "hero/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_phantom_assassin_blur:GetIntrinsicModifierName()
  return "modifier_imba_blur"
end

-------------------------------------------
-- Blur modifier
-------------------------------------------

modifier_imba_blur = class({})

function modifier_imba_blur:OnCreated()
  if IsServer() then
  	-- Ability properties
  	self.caster = self:GetCaster()
  	self.ability = self:GetAbility()
  	self.parent = self:GetParent()
  	self.modifier_aura = "modifier_imba_blur_blur"
	self.modifier_blur_transparent = "modifier_imba_blur_opacity"
	self.modifier_speed = "modifier_imba_blur_speed"

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.evasion = self.ability:GetSpecialValueFor("evasion")
	self.ms_duration = self.ability:GetSpecialValueFor("speed_bonus_duration")

	-- Start thinking
    self:StartIntervalThink(0.2)
  end
end

function modifier_imba_blur:OnRefresh()
	self:OnCreated()
end

function modifier_imba_blur:OnIntervalThink()
  if IsServer() then

	-- Find nearby enemies
	local nearby_enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	-- If there is at least one, apply the blur modifier	
	if #nearby_enemies > 0 and self.caster:HasModifier(self.modifier_aura) then
		self.caster:RemoveModifierByName(self.modifier_aura)

		-- Make mortred transparent (wtf firetoad)
		self.caster:AddNewModifier(self.caster, self, self.modifier_blur_transparent, {})

	-- Else, if there are no enemies, remove the modifier
	elseif #nearby_enemies == 0 and not self.caster:HasModifier(self.modifier_aura) then
		self.caster:AddNewModifier(self.caster, self.ability, self.modifier_aura, {})

		-- Make mortred not transparent (wtf firetoad)
		self.caster:RemoveModifierByName(self.modifier_blur_transparent)
		local responses = {"phantom_assassin_phass_ability_blur_01",
			"phantom_assassin_phass_ability_blur_02",
			"phantom_assassin_phass_ability_blur_03"
		}
		self.caster:EmitCasterSound("npc_dota_hero_phantom_assassin",responses, 10, DOTA_CAST_SOUND_FLAG_NONE, 50,"blur")
	end
  end
end


function modifier_imba_blur:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_EVASION_CONSTANT,
				    MODIFIER_EVENT_ON_ATTACK_FAIL,
				    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end

function modifier_imba_blur:GetModifierEvasion_Constant()
	return self.evasion
end

function modifier_imba_blur:GetModifierIncomingDamage_Percentage()	

	--TALENT: Blur now grants +30% chance to evade any damage	
	if RollPercentage(self.caster:FindTalentValue("special_bonus_imba_phantom_assassin_8")) then
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_EVADE, self.caster, 0, nil)
		return -100
	end

	return nil	
end

function modifier_imba_blur:OnAttackFail(keys)
  if IsServer() then

	if keys.target == self:GetParent() then
		-- If the caster doesn't have the evasion speed modifier yet, give it to him
		if not self.caster:HasModifier(self.modifier_speed) then
			self.caster:AddNewModifier(self.caster, self.ability, self.modifier_speed, {duration = self.ms_duration})
		end

		-- Increment a stack and refresh
		local modifier_speed_handler = self.caster:FindModifierByName(self.modifier_speed)
		if modifier_speed_handler then
			modifier_speed_handler:IncrementStackCount()
			modifier_speed_handler:ForceRefresh()
		end		
	end
  end
end

function modifier_imba_blur:IsHidden()	  return true end
function modifier_imba_blur:IsBuff()			return true end
function modifier_imba_blur:IsPurgable()  return false end


-- Evasion speed buff modifier
modifier_imba_blur_speed = class({})

function modifier_imba_blur_speed:OnCreated()    
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent()        

        -- Ability specials
        self.speed_bonus_duration = self.ability:GetSpecialValueFor("speed_bonus_duration")
        self.blur_ms = self.ability:GetSpecialValueFor("blur_ms")
        print(self.blur_ms)

    if IsServer() then

        -- Initialize table
        self.stacks_table = {}        

        -- Start thinking
        self:StartIntervalThink(0.1)
    end
end

function modifier_imba_blur_speed:OnIntervalThink()
    if IsServer() then

        -- Check if there are any stacks left on the table
        if #self.stacks_table > 0 then

            -- For each stack, check if it is past its expiration time. If it is, remove it from the table
            for i = #self.stacks_table, 1, -1 do
                if self.stacks_table[i] + self.speed_bonus_duration < GameRules:GetGameTime() then
                    table.remove(self.stacks_table, i)                          
                end
            end
            
            -- If after removing the stacks, the table is empty, remove the modifier.
            if #self.stacks_table == 0 then
                self:Destroy()

            -- Otherwise, set its stack count
            else
                self:SetStackCount(#self.stacks_table)
            end

            -- Recalculate bonus based on new stack count
            self:GetParent():CalculateStatBonus()

        -- If there are no stacks on the table, just remove the modifier.
        else
            self:Destroy()
        end
    end
end

function modifier_imba_blur_speed:OnRefresh()
    if IsServer() then
        -- Insert new stack values
        table.insert(self.stacks_table, GameRules:GetGameTime())
    end
end

function modifier_imba_blur_speed:IsHidden() return false end
function modifier_imba_blur_speed:IsPurgable() return true end
function modifier_imba_blur_speed:IsDebuff() return false end

function modifier_imba_blur_speed:DeclareFunctions()
    local decFunc = {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT}

    return decFunc
end

function modifier_imba_blur_speed:GetModifierMoveSpeedBonus_Constant()
    return self.blur_ms * self:GetStackCount()
end



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

function modifier_imba_blur_blur:OnRemoved()
	ParticleManager:DestroyParticle(self.blur_particle, false)
end

function modifier_imba_blur_blur:OnDestroy()
	ParticleManager:ReleaseParticleIndex(self.blur_particle)
end

function modifier_imba_blur_blur:IsHidden()	   return true end
function modifier_imba_blur_blur:IsDebuff()	 return false end
function modifier_imba_blur_blur:IsPurgable()  return false end

-------------------------------------------
-- Blur opacity modifier
-------------------------------------------

modifier_imba_blur_opacity = class({})

function modifier_imba_blur_opacity:IsHidden()	return false end
function modifier_imba_blur_opacity:IsDebuff()	return false end
function modifier_imba_blur_opacity:IsPurgable()return false end

function modifier_imba_blur_opacity:DeclareFunctions()
    return {MODIFIER_PROPERTY_INVISIBILITY_LEVEL}
end

function modifier_imba_blur_opacity:GetModifierInvisibilityLevel()
    return 1
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

function imba_phantom_assassin_coup_de_grace:GetIntrinsicModifierName()
  return "modifier_imba_coup_de_grace"
end

-------------------------------------------
-- Coup De Grace modifier
-------------------------------------------

modifier_imba_coup_de_grace = class({})

function modifier_imba_coup_de_grace:OnCreated()	
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.ps_coup_modifier = "modifier_imba_phantom_strike_coup_de_grace"			
	self.modifier_stacks = "modifier_imba_coup_de_grace_crit"

	-- Ability specials
	self.crit_chance = self.ability:GetSpecialValueFor("crit_chance")	
	self.crit_increase_duration = self.ability:GetSpecialValueFor("crit_increase_duration")	
	self.crit_bonus = self.ability:GetSpecialValueFor("crit_bonus")
end

function modifier_imba_coup_de_grace:OnRefresh()
	self:OnCreated()
end

function modifier_imba_coup_de_grace:DeclareFunctions()
  local funcs = {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE}
  return funcs
end

function modifier_imba_coup_de_grace:GetModifierPreAttack_CriticalStrike(keys)	
	if IsServer() then		
		local target = keys.target		
		local crit_duration = self.crit_increase_duration
		local crit_chance_total = self.crit_chance

		-- Ignore crit for buildings
		if target:IsBuilding() then 
			return end      

        -- if we have phantom strike modifier, apply bonus percentage to our crit_chance        
        if self.caster:HasModifier(self.ps_coup_modifier) then
            local ps_coup_modifier_handler = self.caster:FindModifierByName(self.ps_coup_modifier)
            if ps_coup_modifier_handler then
            	local bonus_coup_de_grace_chance = ps_coup_modifier_handler:GetAbility():GetSpecialValueFor("bonus_coup_de_grace")

				-- TALENT: +5% Phantom Strike bonus crit chance				
				bonus_coup_de_grace_chance = bonus_coup_de_grace_chance + self:GetCaster():FindTalentValue("special_bonus_imba_phantom_assassin_4")				

				-- Calculate total crit chance
				local crit_chance_total = crit_chance_total + bonus_coup_de_grace_chance                
            end            
        end        

        if RollPseudoRandom(crit_chance_total, self) then        	

			local coup_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, caster)			
			ParticleManager:SetParticleControlEnt(coup_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(coup_pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(coup_pfx)
			
			StartSoundEvent("Hero_PhantomAssassin.CoupDeGrace", target)
			local responses = {"phantom_assassin_phass_ability_coupdegrace_01",
				"phantom_assassin_phass_ability_coupdegrace_02",
				"phantom_assassin_phass_ability_coupdegrace_03",
				"phantom_assassin_phass_ability_coupdegrace_04"
			}
			self.caster:EmitCasterSound("npc_dota_hero_phantom_assassin",responses, 50, DOTA_CAST_SOUND_FLAG_BOTH_TEAMS, 20,"coup_de_grace")

			--TALENT: +8 sec Coup de Grace bonus damage duration			
			crit_duration = crit_duration + self.caster:FindTalentValue("special_bonus_imba_phantom_assassin_7")			

			-- If the caster doesn't have the stacks modifier, give it to him 
			if not self.caster:HasModifier(self.modifier_stacks) then
				self.caster:AddNewModifier(self.caster, self.ability, self.modifier_stacks, {duration = crit_duration})
			end

			-- Find the modifier, increase a stack and refresh it
			local modifier_stacks_handler = self.caster:FindModifierByName(self.modifier_stacks)			
			if modifier_stacks_handler then
				modifier_stacks_handler:IncrementStackCount()				
				modifier_stacks_handler:ForceRefresh()
			end

			-- TALENT: +100% Coup de Grace crit damage			
			local crit_bonus = self.crit_bonus + self.caster:FindTalentValue("special_bonus_imba_phantom_assassin_5")
            return crit_bonus
        end

        return nil        
	end
end

function modifier_imba_coup_de_grace:IsPassive() return true end

function modifier_imba_coup_de_grace:IsHidden()	
	local stacks = self:GetStackCount()
	if stacks > 0 then
		return false
	end

	return true 
end


modifier_imba_coup_de_grace_crit = class({})

function modifier_imba_coup_de_grace_crit:OnCreated()    
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent()        

        -- Ability specials
        self.crit_increase_duration = self.ability:GetSpecialValueFor("crit_increase_duration")
        self.crit_increase_damage = self.ability:GetSpecialValueFor("crit_increase_damage")        

    if IsServer() then
        -- Initialize table
        self.stacks_table = {}        

        -- Start thinking
        self:StartIntervalThink(0.1)
    end
end

function modifier_imba_coup_de_grace_crit:OnIntervalThink()
    if IsServer() then
        -- Check if there are any stacks left on the table
        if #self.stacks_table > 0 then

            -- For each stack, check if it is past its expiration time. If it is, remove it from the table
            for i = #self.stacks_table, 1, -1 do
                if self.stacks_table[i] + self.crit_increase_duration < GameRules:GetGameTime() then
                    table.remove(self.stacks_table, i)                          
                end
            end
            
            -- If after removing the stacks, the table is empty, remove the modifier.
            if #self.stacks_table == 0 then
                self:Destroy()

            -- Otherwise, set its stack count
            else
                self:SetStackCount(#self.stacks_table)
            end

            -- Recalculate bonus based on new stack count
            self:GetParent():CalculateStatBonus()

        -- If there are no stacks on the table, just remove the modifier.
        else
            self:Destroy()
        end
    end
end

function modifier_imba_coup_de_grace_crit:OnRefresh()
    if IsServer() then
        -- Insert new stack values
        table.insert(self.stacks_table, GameRules:GetGameTime())
    end
end

function modifier_imba_coup_de_grace_crit:IsHidden() return false end
function modifier_imba_coup_de_grace_crit:IsPurgable() return true end
function modifier_imba_coup_de_grace_crit:IsDebuff() return false end


function modifier_imba_coup_de_grace_crit:DeclareFunctions()
    local decFunc = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}

    return decFunc
end

function modifier_imba_coup_de_grace_crit:GetModifierPreAttack_BonusDamage()	
 	return self.crit_increase_damage * self:GetStackCount()
end