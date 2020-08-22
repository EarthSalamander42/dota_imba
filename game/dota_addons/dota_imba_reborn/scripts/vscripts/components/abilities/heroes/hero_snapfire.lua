-- Original Lua Abilites created by Elfansoer: https://github.com/Elfansoer/dota-2-lua-abilities/blob/master/scripts/vscripts/lua_abilities
-- IMBAfied by EarthSalamander
-- Date: February 2020

--------------------------------------------------------------------------------
imba_snapfire_scatterblast = imba_snapfire_scatterblast or class({})
LinkLuaModifier( "modifier_imba_snapfire_scatterblast_slow", "components/abilities/heroes/hero_snapfire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_snapfire_scatterblast_silence", "components/abilities/heroes/hero_snapfire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_custom_indicator", "components/modifiers/generic/modifier_generic_custom_indicator", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom Indicator
function imba_snapfire_scatterblast:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end

function imba_snapfire_scatterblast:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			-- register cursor position
			self.custom_indicator:Register( vLoc )
		end
	end

	return UF_SUCCESS
end

function imba_snapfire_scatterblast:CreateCustomIndicator()
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_range_finder_aoe.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end

function imba_snapfire_scatterblast:UpdateCustomIndicator( loc )
	-- get data
	local origin = self:GetCaster():GetAbsOrigin()
	local point_blank = self:GetSpecialValueFor( "point_blank_range" )

	-- get direction
	local direction = loc - origin
	direction.z = 0
	direction = direction:Normalized()

	ParticleManager:SetParticleControl( self.effect_cast, 0, origin )
	ParticleManager:SetParticleControl( self.effect_cast, 1, origin + direction*(self:GetCastRange( loc, nil )+200) )
	ParticleManager:SetParticleControl( self.effect_cast, 6, origin + direction*point_blank )
end

function imba_snapfire_scatterblast:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function imba_snapfire_scatterblast:OnAbilityPhaseStart()
	-- play sound
	local sound_cast = "Hero_Snapfire.Shotgun.Load"
	EmitSoundOn( sound_cast, self:GetCaster() )

	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function imba_snapfire_scatterblast:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()
	self.first_target = nil

	-- load data
	local projectile_name = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun.vpcf"
	local projectile_distance = self:GetCastRange( point, nil )
	local projectile_start_radius = self:GetSpecialValueFor( "blast_width_initial" )/2
	local projectile_end_radius = self:GetSpecialValueFor( "blast_width_end" )/2
	local projectile_speed = self:GetSpecialValueFor( "blast_speed" )
	local projectile_direction = point-origin
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()	

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = self:GetAbilityTargetTeam(),
	    iUnitTargetFlags = self:GetAbilityTargetFlags(),
	    iUnitTargetType = self:GetAbilityTargetType(),
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bProvidesVision = false,
		ExtraData = {
			pos_x = origin.x,
			pos_y = origin.y,
		}
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- play sound
	local sound_cast = "Hero_Snapfire.Shotgun.Fire"
	EmitSoundOn( sound_cast, caster )
end
--------------------------------------------------------------------------------
-- Projectile
function imba_snapfire_scatterblast:OnProjectileHit_ExtraData( target, location, extraData )
	if not target then return end

	-- load data
	local caster = self:GetCaster()
	local location = target:GetOrigin()
	local point_blank_range = self:GetSpecialValueFor( "point_blank_range" )
	local point_blank_mult = self:GetSpecialValueFor( "point_blank_dmg_bonus_pct" )/100
	local damage = self:GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_unique_snapfire_7")
	local slow = self:GetSpecialValueFor( "slow_duration" )
	local modifier_name = "modifier_imba_snapfire_scatterblast_slow"

	-- check position
	local origin = Vector( extraData.pos_x, extraData.pos_y, 0 )
	local length = (location-origin):Length2D()

	-- manual check due to projectile's circle shape
	-- if length>self:GetCastRange( location, nil )+150 then return end

	local point_blank = (length<=point_blank_range)
	if point_blank then
		damage = damage + point_blank_mult*damage
		-- 12-Gauge IMBAfication
		modifier_name = "modifier_stunned"
	end

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- debuff
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		modifier_name, -- modifier name
		{ duration = slow } -- kv
	)

	if not self.first_target then
		self.first_target = true

		local debuff_modifier = "modifier_disarmed"

		-- Russian Roulette: either silence or disarm, does not require AbilitySpecial value
		if RollPercentage(50) then
			debuff_modifier = "modifier_imba_snapfire_scatterblast_silence"
		end

		target:AddNewModifier(
			caster, -- player source
			self, -- ability source
			debuff_modifier, -- modifier name
			{ duration = self:GetSpecialValueFor("debuff_duration") } -- kv
		)
	end

	-- effect
	self:PlayEffects( target, point_blank )
end

--------------------------------------------------------------------------------
function imba_snapfire_scatterblast:PlayEffects( target, point_blank )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_impact.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_snapfire/hero_snapfire_shells_impact.vpcf"
	local particle_cast3 = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_pointblank_impact_sparks.vpcf"
	local sound_target = "Hero_Snapfire.Shotgun.Target"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	if point_blank then
		local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_POINT_FOLLOW, target )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			3,
			target,
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
		ParticleManager:ReleaseParticleIndex( effect_cast )

		local effect_cast = ParticleManager:CreateParticle( particle_cast3, PATTACH_POINT_FOLLOW, target )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			4,
			target,
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end

	-- Create Sound
	EmitSoundOn( sound_target, target )
end

--------------------------------------------------------------------------------
modifier_imba_snapfire_scatterblast_slow = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_snapfire_scatterblast_slow:IsHidden()
	return false
end

function modifier_imba_snapfire_scatterblast_slow:IsDebuff()
	return true
end

function modifier_imba_snapfire_scatterblast_slow:IsStunDebuff()
	return false
end

function modifier_imba_snapfire_scatterblast_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_snapfire_scatterblast_slow:OnCreated( kv )
	-- references
	self.slow = -self:GetAbility():GetSpecialValueFor( "movement_slow_pct" )
end

function modifier_imba_snapfire_scatterblast_slow:OnRefresh( kv )
	-- references
	self.slow = -self:GetAbility():GetSpecialValueFor( "movement_slow_pct" )	
end

function modifier_imba_snapfire_scatterblast_slow:OnRemoved()
end

function modifier_imba_snapfire_scatterblast_slow:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_snapfire_scatterblast_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_imba_snapfire_scatterblast_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_snapfire_scatterblast_slow:GetEffectName()
	return "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_debuff.vpcf"
end

function modifier_imba_snapfire_scatterblast_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_snapfire_scatterblast_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_imba_snapfire_scatterblast_slow:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

--------------------------------------------------------------------------------
modifier_imba_snapfire_scatterblast_silence = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_snapfire_scatterblast_silence:IsHidden()
	return false
end

function modifier_imba_snapfire_scatterblast_silence:IsDebuff()
	return true
end

function modifier_imba_snapfire_scatterblast_silence:IsStunDebuff()
	return false
end

function modifier_imba_snapfire_scatterblast_silence:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_snapfire_scatterblast_silence:CheckState()
	local funcs = {
		[MODIFIER_STATE_SILENCED] = true,
	}

	return funcs
end

--------------------------------------------------------------------------------
imba_snapfire_firesnap_cookie = imba_snapfire_firesnap_cookie or class({})

LinkLuaModifier("modifier_generic_knockback_lua", "components/modifiers/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH)

--------------------------------------------------------------------------------
-- Custom KV
function imba_snapfire_firesnap_cookie:GetCastPoint()
	if IsServer() and self:GetCursorTarget()==self:GetCaster() then
		return self:GetSpecialValueFor( "self_cast_delay" )
	end
	return 0.2
end

--------------------------------------------------------------------------------
-- Ability Cast Filter
function imba_snapfire_firesnap_cookie:CastFilterResultTarget( hTarget )
	if IsServer() and hTarget:IsChanneling() then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		0,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function imba_snapfire_firesnap_cookie:GetCustomCastErrorTarget( hTarget )
	if IsServer() and hTarget:IsChanneling() then
		return "#dota_hud_error_is_channeling"
	end

	return ""
end

-- Spicy Spicy Cookie IMBAfication
function imba_snapfire_firesnap_cookie:GetCastRange(location, target)
--	if self:GetAutoCastState() then
--		return self.BaseClass.GetCastRange(self, location, target) * self:GetSpecialValueFor("auto_cast_range_increase") / 100
--	else
		return self.BaseClass.GetCastRange(self, location, target)
--	end
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function imba_snapfire_firesnap_cookie:OnAbilityPhaseInterrupted()

end
function imba_snapfire_firesnap_cookie:OnAbilityPhaseStart()
	if self:GetCursorTarget()==self:GetCaster() then
		self:PlayEffects1()
	end

	-- prevent fast toggling to fuck things up by storing state pre-cast
	self.toggle_state = self:GetAutoCastState()

	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function imba_snapfire_firesnap_cookie:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local projectile_name = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )

	if caster:GetTeam() ~= target:GetTeam() then
		projectile_name = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_enemy_projectile.vpcf"
	end

	-- create projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)

	-- Play sound
	local sound_cast = "Hero_Snapfire.FeedCookie.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Projectile
function imba_snapfire_firesnap_cookie:OnProjectileHit( target, location )
	if not target then return end

	if target:IsChanneling() or target:IsOutOfGame() then return end

	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= self:GetCaster():GetTeam() then
		if target:TriggerSpellAbsorb(self) then
			return nil
		end
	end

	-- Firesnap Cookie heals
	if self:GetCaster():HasTalent("special_bonus_unique_snapfire_5") then
		if target:GetTeam() == self:GetCaster():GetTeam() then
			target:Heal(self:GetCaster():FindTalentValue("special_bonus_unique_snapfire_5"), self:GetCaster())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, self:GetCaster():FindTalentValue("special_bonus_unique_snapfire_5"), nil)
		end
	end

	-- load data
	local duration = self:GetSpecialValueFor( "jump_duration" )
	local height = self:GetSpecialValueFor( "jump_height" )
	local distance = self:GetSpecialValueFor( "jump_horizontal_distance" )
	local stun = self:GetSpecialValueFor( "impact_stun_duration" )
	local damage = self:GetSpecialValueFor( "impact_damage" )
	local radius = self:GetSpecialValueFor( "impact_radius" )

	if self.toggle_state then
		distance = distance + distance * self:GetSpecialValueFor("auto_cast_range_increase") / 100
	end

	-- play effects2
	local effect_cast = self:PlayEffects2( target )

	-- knockback
	local knockback = target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_knockback_lua", -- modifier name
		{
			distance = distance,
			height = height,
			duration = duration,
			direction_x = target:GetForwardVector().x,
			direction_y = target:GetForwardVector().y,
			IsStun = true,
		} -- kv
	)

	-- on landing
	local callback = function()
		-- precache damage
		local damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self, --Optional.
		}

		-- find enemies
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		for _,enemy in pairs(enemies) do
			-- apply damage
			damageTable.victim = enemy
			ApplyDamage(damageTable)

			if not self.toggle_state then
				-- stun
				enemy:AddNewModifier(
					self:GetCaster(), -- player source
					self, -- ability source
					"modifier_stunned", -- modifier name
					{ duration = stun } -- kv
				)
			end
		end

		-- destroy trees
		GridNav:DestroyTreesAroundPoint( target:GetOrigin(), radius, true )

		-- play effects
		ParticleManager:DestroyParticle( effect_cast, false )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		self:PlayEffects3( target, radius )
	end

	knockback:SetEndCallback( callback )
end

--------------------------------------------------------------------------------
function imba_snapfire_firesnap_cookie:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_selfcast.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function imba_snapfire_firesnap_cookie:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_buff.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_receive.vpcf"
	local sound_target = "Hero_Snapfire.FeedCookie.Consume"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, target )

	-- Create Sound
	EmitSoundOn( sound_target, target )

	return effect_cast
end

function imba_snapfire_firesnap_cookie:PlayEffects3( target, radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_landing.vpcf"
	local sound_location = "Hero_Snapfire.FeedCookie.Impact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_location, target )
end

--------------------------------------------------------------------------------
imba_snapfire_lil_shredder = class({})
LinkLuaModifier( "modifier_imba_snapfire_lil_shredder", "components/abilities/heroes/hero_snapfire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_snapfire_lil_shredder_debuff", "components/abilities/heroes/hero_snapfire", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function imba_snapfire_lil_shredder:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetDuration()

	-- addd buff
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_imba_snapfire_lil_shredder", -- modifier name
		{ duration = duration } -- kv
	)
end

--------------------------------------------------------------------------------
modifier_imba_snapfire_lil_shredder = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_snapfire_lil_shredder:IsHidden()
	return false
end

function modifier_imba_snapfire_lil_shredder:IsDebuff()
	return false
end

function modifier_imba_snapfire_lil_shredder:IsStunDebuff()
	return false
end

function modifier_imba_snapfire_lil_shredder:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_snapfire_lil_shredder:OnCreated( kv )
	-- references
	self.attacks = self:GetAbility():GetSpecialValueFor( "buffed_attacks" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "attack_speed_bonus" )
	self.range_bonus = self:GetAbility():GetSpecialValueFor( "attack_range_bonus" )
	self.bat = self:GetAbility():GetSpecialValueFor( "base_attack_time" )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow_duration" )
	self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")

	if self:GetCaster():HasTalent("special_bonus_unique_snapfire_6") then
		self.damage = self:GetCaster():GetAverageTrueAttackDamage(nil) 
	end

	if not IsServer() then return end

	self.toggle_state = self:GetAbility():GetAutoCastState()

	if self.toggle_state then
		self:SetStackCount( 1 )
		self.damage = self.damage * self:GetAbility():GetSpecialValueFor( "buffed_attacks" )
	else
		self:SetStackCount( self.attacks )
	end

	self.records = {}

	-- play Effects & Sound
	self:PlayEffects()
	local sound_cast = "Hero_Snapfire.ExplosiveShells.Cast"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_imba_snapfire_lil_shredder:OnRefresh( kv )
	-- references
	self.attacks = self:GetAbility():GetSpecialValueFor( "buffed_attacks" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "attack_speed_bonus" )
	self.range_bonus = self:GetAbility():GetSpecialValueFor( "attack_range_bonus" )
	self.bat = self:GetAbility():GetSpecialValueFor( "base_attack_time" )
	self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")

	self.slow = self:GetAbility():GetSpecialValueFor( "slow_duration" )

	if not IsServer() then return end
	self:SetStackCount( self.attacks )

	-- play sound
	local sound_cast = "Hero_Snapfire.ExplosiveShells.Cast"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_imba_snapfire_lil_shredder:OnRemoved()
end

function modifier_imba_snapfire_lil_shredder:OnDestroy()
	if not IsServer() then return end

	-- stop sound
	local sound_cast = "Hero_Snapfire.ExplosiveShells.Cast"
	StopSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_snapfire_lil_shredder:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,		
	}

	return funcs
end

function modifier_imba_snapfire_lil_shredder:OnAttack( params )
	if params.attacker~=self:GetParent() then return end
	if self:GetStackCount()<=0 then return end

	-- record attack
	self.records[params.record] = true

	-- play sound
	local sound_cast = "Hero_Snapfire.ExplosiveShellsBuff.Attack"
	EmitSoundOn( sound_cast, self:GetParent() )

	-- decrement stack
	if self:GetStackCount()>0 then
		self:DecrementStackCount()
	end
end

function modifier_imba_snapfire_lil_shredder:OnAttackLanded( params )
	if self.records[params.record] then
		-- add modifier
		params.target:AddNewModifier(
			self:GetParent(), -- player source
			self:GetAbility(), -- ability source
			"modifier_imba_snapfire_lil_shredder_debuff", -- modifier name
			{ duration = self.slow } -- kv
		)
	end

	-- play sound
	local sound_cast = "Hero_Snapfire.ExplosiveShellsBuff.Target"
	EmitSoundOn( sound_cast, params.target )
end

function modifier_imba_snapfire_lil_shredder:OnAttackRecordDestroy( params )
	if self.records[params.record] then
		self.records[params.record] = nil

		-- if table is empty and no stack left, destroy
		if next(self.records)==nil and self:GetStackCount()<=0 then
			self:Destroy()
		end
	end
end

function modifier_imba_snapfire_lil_shredder:GetModifierProjectileName()
	if self:GetStackCount()<=0 then return end
	return "particles/units/heroes/hero_snapfire/hero_snapfire_shells_projectile.vpcf"
end

function modifier_imba_snapfire_lil_shredder:GetModifierOverrideAttackDamage(keys)
	if self:GetStackCount() <= 0 then return end
	if not IsServer() then return end
	
	local target = keys.target
		
	-- Calculate bonus damage from Fury Shredder
	local bonus_damage = 0

	-- "Does not work against buildings, wards and allied units when attacking them."			
	if target:IsBuilding() or target:IsOther() or target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return nil
	end

	local fury_shredder_handle = target:FindModifierByName("modifier_imba_snapfire_lil_shredder_debuff")
	if fury_shredder_handle then
		-- Get stack count
		local fury_shredder_stacks = fury_shredder_handle:GetStackCount()				

		-- Calculate damage
		bonus_damage = self.damage_per_stack * fury_shredder_stacks				
	end
	
	return self.damage + bonus_damage
end

function modifier_imba_snapfire_lil_shredder:GetModifierAttackRangeBonus()
	if self:GetStackCount()<=0 then return end
	return self.range_bonus
end

function modifier_imba_snapfire_lil_shredder:GetModifierAttackSpeedBonus_Constant()
	if self:GetStackCount()<=0 then return end
	return self.as_bonus
end

function modifier_imba_snapfire_lil_shredder:GetModifierBaseAttackTimeConstant()
	if self:GetStackCount()<=0 then return end
	return self.bat
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_snapfire_lil_shredder:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_shells_buff.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		4,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		5,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end

--------------------------------------------------------------------------------
modifier_imba_snapfire_lil_shredder_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_snapfire_lil_shredder_debuff:IsHidden()
	return false
end

function modifier_imba_snapfire_lil_shredder_debuff:IsDebuff()
	return true
end

function modifier_imba_snapfire_lil_shredder_debuff:IsStunDebuff()
	return false
end

function modifier_imba_snapfire_lil_shredder_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_snapfire_lil_shredder_debuff:OnCreated( kv )
	-- references
	self.slow = -self:GetAbility():GetSpecialValueFor( "attack_speed_slow_per_stack" )

	if not IsServer() then return end
	self:SetStackCount( 1 )
end

function modifier_imba_snapfire_lil_shredder_debuff:OnRefresh( kv )
	if not IsServer() then return end
	self:IncrementStackCount()
end

function modifier_imba_snapfire_lil_shredder_debuff:OnRemoved()
end

function modifier_imba_snapfire_lil_shredder_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_snapfire_lil_shredder_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_imba_snapfire_lil_shredder_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.slow * self:GetStackCount()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_snapfire_lil_shredder_debuff:GetEffectName()
	-- return "particles/units/heroes/hero_snapfire/hero_snapfire_slow_debuff.vpcf"
	return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end

function modifier_imba_snapfire_lil_shredder_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------
imba_snapfire_mortimer_kisses = imba_snapfire_mortimer_kisses or class({})
LinkLuaModifier( "modifier_imba_snapfire_mortimer_kisses", "components/abilities/heroes/hero_snapfire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_snapfire_mortimer_kisses_thinker", "components/abilities/heroes/hero_snapfire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_snapfire_magma_burn_slow", "components/abilities/heroes/hero_snapfire", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function imba_snapfire_mortimer_kisses:GetAOERadius()
	return self:GetSpecialValueFor( "impact_radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function imba_snapfire_mortimer_kisses:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetDuration()

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_imba_snapfire_mortimer_kisses", -- modifier name
		{
			duration = duration,
			pos_x = point.x,
			pos_y = point.y,
		} -- kv
	)
end

--------------------------------------------------------------------------------
-- Projectile
function imba_snapfire_mortimer_kisses:OnProjectileHit( target, location )
	if not target then return end

	-- load data
	local damage = self:GetSpecialValueFor( "damage_per_impact" )
	local duration = self:GetSpecialValueFor( "burn_ground_duration" )
	local impact_radius = self:GetSpecialValueFor( "impact_radius" )

	if target.secondary then
		impact_radius = self:GetSpecialValueFor("rings_radius")
	end
	local vision = self:GetSpecialValueFor( "projectile_vision" )

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		location,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		impact_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end

	-- start aura on thinker
	local mod = target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_imba_snapfire_mortimer_kisses_thinker", -- modifier name
		{
			duration = duration,
			slow = 1,
		} -- kv
	)

	-- destroy trees
	GridNav:DestroyTreesAroundPoint( location, impact_radius, true )

	-- create Vision
	AddFOWViewer( self:GetCaster():GetTeamNumber(), location, vision, duration, false )

	-- play effects
	self:PlayEffects( location )

	if target.secondary then return end

	-- Mortimer Hugs IMBAfication (unable to set ground blob pfx size, need custom one)
	if target.mega_blob then
		local forward = target:GetForwardVector()
		local blob_rings_count = self:GetSpecialValueFor("blob_rings_count")
		local rings_distance = self:GetSpecialValueFor("rings_distance")
		local angle_diff = 360 / blob_rings_count
		local blob_pos = {}

		for i = 1, blob_rings_count do
			blob_pos[i] = RotatePosition(location, QAngle(0, angle_diff * i, 0), location + (forward * rings_distance))
	
			local target_pos = GetGroundPosition( blob_pos[i], nil )
			local travel_time = self:GetSpecialValueFor("rings_delay")
	
			-- create target thinker
			local thinker = CreateModifierThinker(
				self:GetCaster(), -- player source
				self, -- ability source
				"modifier_imba_snapfire_mortimer_kisses_thinker", -- modifier name
				{ travel_time = travel_time }, -- kv
				target_pos,
				self:GetCaster():GetTeamNumber(),
				false
			)
	
			thinker.secondary = true
	
			local min_range = self:GetSpecialValueFor( "min_range" )
			local max_range = self:GetCastRange( Vector(0,0,0), nil )
			local vec = (location - target_pos):Length2D()
	
			local info = {
				Target = thinker,
				Source = target,
				Ability = self,	
				iMoveSpeed = vec / travel_time,
				EffectName = "particles/units/heroes/hero_snapfire/snapfire_lizard_blobs_arced.vpcf",
				bDodgeable = false,                           -- Optional
	
				vSourceLoc = location,                -- Optional (HOW)
	
				bDrawsOnMinimap = false,                          -- Optional
				bVisibleToEnemies = true,                         -- Optional
				bProvidesVision = true,                           -- Optional
				iVisionRadius = self:GetSpecialValueFor( "projectile_vision" ),                              -- Optional
				iVisionTeamNumber = self:GetCaster():GetTeamNumber()        -- Optional
			}
	
			-- launch projectile
			ProjectileManager:CreateTrackingProjectile( info )
	
			-- create FOW
			AddFOWViewer( self:GetCaster():GetTeamNumber(), thinker:GetOrigin(), 100, 1, false )
	
			-- play sound
			EmitSoundOn( "Hero_Snapfire.MortimerBlob.Launch", target )
		end
	end
end
	
--------------------------------------------------------------------------------
function imba_snapfire_mortimer_kisses:PlayEffects( loc )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_impact.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_linger.vpcf"
	local sound_cast = "Hero_Snapfire.MortimerBlob.Impact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 3, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, loc )
	ParticleManager:SetParticleControl( effect_cast, 1, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	local sound_location = "Hero_Snapfire.MortimerBlob.Impact"
	EmitSoundOnLocationWithCaster( loc, sound_location, self:GetCaster() )
end

--------------------------------------------------------------------------------
modifier_imba_snapfire_mortimer_kisses = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_snapfire_mortimer_kisses:IsHidden()
	return false
end

function modifier_imba_snapfire_mortimer_kisses:IsDebuff()
	return false
end

function modifier_imba_snapfire_mortimer_kisses:IsStunDebuff()
	return false
end

function modifier_imba_snapfire_mortimer_kisses:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_snapfire_mortimer_kisses:OnCreated( kv )
	-- references
	self.min_range = self:GetAbility():GetSpecialValueFor( "min_range" )
	self.max_range = self:GetAbility():GetCastRange( Vector(0,0,0), nil )
	self.range = self.max_range-self.min_range

	self.min_travel = self:GetAbility():GetSpecialValueFor( "min_lob_travel_time" )
	self.max_travel = self:GetAbility():GetSpecialValueFor( "max_lob_travel_time" )
	self.travel_range = self.max_travel-self.min_travel

	local projectile_vision = self:GetAbility():GetSpecialValueFor( "projectile_vision" )

	self.turn_rate = self:GetAbility():GetSpecialValueFor( "turn_rate" )
	self.blob_count = 0

	if not IsServer() then return end

	-- load data
	local projectile_speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" ) + self:GetCaster():FindTalentValue("special_bonus_imba_snapfire_1")
	local projectile_count = self:GetAbility():GetSpecialValueFor( "projectile_count" ) + self:GetCaster():FindTalentValue("special_bonus_unique_snapfire_1")
	local interval = self:GetAbility():GetDuration() / projectile_count + 0.01 -- so it only have 8 projectiles instead of 9
	self:SetValidTarget( Vector( kv.pos_x, kv.pos_y, 0 ) )
	local projectile_start_radius = 0
	local projectile_end_radius = 0

	-- precache projectile
	self.info = {
		-- Target = target,
		Source = self:GetCaster(),
		Ability = self:GetAbility(),	
		
		EffectName = "particles/units/heroes/hero_snapfire/snapfire_lizard_blobs_arced.vpcf",
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional
	
		vSourceLoc = self:GetCaster():GetOrigin(),                -- Optional (HOW)
		
		bDrawsOnMinimap = false,                          -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,                              -- Optional
		iVisionTeamNumber = self:GetCaster():GetTeamNumber()        -- Optional
	}

	-- Start interval
	self:StartIntervalThink( interval )
	self:OnIntervalThink()
end

function modifier_imba_snapfire_mortimer_kisses:OnRefresh( kv )
	
end

function modifier_imba_snapfire_mortimer_kisses:OnRemoved()
end

function modifier_imba_snapfire_mortimer_kisses:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_snapfire_mortimer_kisses:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,

		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}

	return funcs
end

function modifier_imba_snapfire_mortimer_kisses:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	-- right click, switch position
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		self:SetValidTarget( params.new_pos )
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SetValidTarget( params.target:GetOrigin() )

	-- stop or hold
	elseif 
		params.order_type==DOTA_UNIT_ORDER_STOP or
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self:Destroy()
	end
end

function modifier_imba_snapfire_mortimer_kisses:GetModifierMoveSpeed_Limit()
	return 0.1
end

function modifier_imba_snapfire_mortimer_kisses:GetModifierTurnRate_Percentage()
	return -self.turn_rate
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_imba_snapfire_mortimer_kisses:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_snapfire_mortimer_kisses:OnIntervalThink()
	self:CreateBlob(kv)
end

function modifier_imba_snapfire_mortimer_kisses:CreateBlob(kv)
	if not kv then kv = {} end

	local travel_time = self.travel_time
	local target_pos = self.target

	if kv.pos then
		target_pos = GetGroundPosition( self.target + kv.pos, nil )
	end

	if kv.travel_time then
		travel_time = kv.travel_time
	end

	-- create target thinker
	local thinker = CreateModifierThinker(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_imba_snapfire_mortimer_kisses_thinker", -- modifier name
		{ travel_time = travel_time }, -- kv
		target_pos,
		self:GetParent():GetTeamNumber(),
		false
	)

	self.blob_count = self.blob_count + 1

	print(self.blob_count, self:GetAbility():GetSpecialValueFor("mini_blob_counter"))
	if self.blob_count == self:GetAbility():GetSpecialValueFor("mini_blob_counter") then
		self.blob_count = 0
		thinker.mega_blob = true
	end

	-- set projectile
	self.info.iMoveSpeed = self.vector:Length2D() / travel_time
	self.info.Target = thinker

	-- launch projectile
	ProjectileManager:CreateTrackingProjectile( self.info )

	-- create FOW
	AddFOWViewer( self:GetParent():GetTeamNumber(), thinker:GetOrigin(), 100, 1, false )

	-- play sound
	EmitSoundOn( "Hero_Snapfire.MortimerBlob.Launch", self:GetParent() )
end

--------------------------------------------------------------------------------
-- Helper
function modifier_imba_snapfire_mortimer_kisses:SetValidTarget( location )
	local origin = self:GetParent():GetOrigin()
	local vec = location-origin
	local direction = vec
	direction.z = 0
	direction = direction:Normalized()

	if vec:Length2D()<self.min_range then
		vec = direction * self.min_range
	elseif vec:Length2D()>self.max_range then
		vec = direction * self.max_range
	end

	self.target = GetGroundPosition( origin + vec, nil )
	self.vector = vec
	self.travel_time = (vec:Length2D()-self.min_range)/self.range * self.travel_range + self.min_travel
end

--------------------------------------------------------------------------------
modifier_imba_snapfire_magma_burn_slow = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_snapfire_magma_burn_slow:IsHidden()
	return false
end

function modifier_imba_snapfire_magma_burn_slow:IsDebuff()
	return true
end

function modifier_imba_snapfire_magma_burn_slow:IsStunDebuff()
	return false
end

function modifier_imba_snapfire_magma_burn_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_snapfire_magma_burn_slow:OnCreated( kv )
	-- references
	self.dps = self:GetAbility():GetSpecialValueFor( "burn_damage" )
	local interval = self:GetAbility():GetSpecialValueFor( "burn_interval" )

	if not IsServer() then return end

	-- Fiery Slash Impact IMBAfication
	local distance = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()
--	local distance_travel = math.min(distance / self:GetCastRange(self:GetCaster():GetAbsOrigin(), self:GetCaster()), 1)
	-- fuck you, hardcoded for now
	local distance_travel = math.min(distance / 3000, 1)
	local min_slow = self:GetAbility():GetSpecialValueFor("min_slow_pct") + self:GetCaster():FindTalentValue("special_bonus_unique_snapfire_4")
	local max_slow = self:GetAbility():GetSpecialValueFor("max_slow_pct") + self:GetCaster():FindTalentValue("special_bonus_unique_snapfire_4")
	self:SetStackCount(math.max(max_slow * distance_travel, min_slow))

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.dps*interval,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}

	-- Start interval
	self:StartIntervalThink( interval )
	self:OnIntervalThink()
end

function modifier_imba_snapfire_magma_burn_slow:OnRefresh( kv )
	
end

function modifier_imba_snapfire_magma_burn_slow:OnRemoved()
end

function modifier_imba_snapfire_magma_burn_slow:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_snapfire_magma_burn_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_imba_snapfire_magma_burn_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount() * (-1)
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_snapfire_magma_burn_slow:OnIntervalThink()
	-- apply damage
	ApplyDamage( self.damageTable )

	-- play overhead
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_snapfire_magma_burn_slow:GetEffectName()
	return "particles/units/heroes/hero_snapfire/hero_snapfire_burn_debuff.vpcf"
end

function modifier_imba_snapfire_magma_burn_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_snapfire_magma_burn_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_snapfire_magma.vpcf"
end

function modifier_imba_snapfire_magma_burn_slow:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

--------------------------------------------------------------------------------
modifier_imba_snapfire_mortimer_kisses_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_snapfire_mortimer_kisses_thinker:OnCreated( kv )
	-- references
	self.max_travel = self:GetAbility():GetSpecialValueFor( "max_lob_travel_time" )
	self.radius = self:GetAbility():GetSpecialValueFor( "impact_radius" )
	self.linger = self:GetAbility():GetSpecialValueFor( "burn_linger_duration" )

	if not IsServer() then return end

	-- dont start aura right off
	self.start = false

	-- create aoe finder particle
	self:PlayEffects( kv.travel_time )
end

function modifier_imba_snapfire_mortimer_kisses_thinker:OnRefresh( kv )
	-- references
	self.max_travel = self:GetAbility():GetSpecialValueFor( "max_lob_travel_time" )
	self.radius = self:GetAbility():GetSpecialValueFor( "impact_radius" )
	self.linger = self:GetAbility():GetSpecialValueFor( "burn_linger_duration" )

	if not IsServer() then return end

	-- start aura
	self.start = true

	-- stop aoe finder particle
	self:StopEffects()
end

function modifier_imba_snapfire_mortimer_kisses_thinker:OnRemoved()
end

function modifier_imba_snapfire_mortimer_kisses_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_imba_snapfire_mortimer_kisses_thinker:IsAura()
	return self.start
end

function modifier_imba_snapfire_mortimer_kisses_thinker:GetModifierAura()
	return "modifier_imba_snapfire_magma_burn_slow"
end

function modifier_imba_snapfire_mortimer_kisses_thinker:GetAuraRadius()
	return self.radius
end

function modifier_imba_snapfire_mortimer_kisses_thinker:GetAuraDuration()
	return self.linger
end

function modifier_imba_snapfire_mortimer_kisses_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_snapfire_mortimer_kisses_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_snapfire_mortimer_kisses_thinker:PlayEffects( time )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius*(self.max_travel/time) ) )
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( time, 0, 0 ) )
end

function modifier_imba_snapfire_mortimer_kisses_thinker:StopEffects()
	ParticleManager:DestroyParticle( self.effect_cast, true )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end
