-- Created by Elfansoer: https://github.com/Elfansoer/dota-2-lua-abilities
-- Imbafied by EarthSalamander
-- Date 19/11/2020

--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
imba_mars_spear = imba_mars_spear or class(VANILLA_ABILITIES_BASECLASS)
LinkLuaModifier("modifier_generic_knockback_lua", "components/modifiers/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier( "modifier_imba_mars_spear", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_imba_mars_spear_debuff", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_mars_spear_heaven_spear", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_mars_spear_trailblazer_thinker", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function imba_mars_spear:GetAOERadius()
	if self:GetAutoCastState() then
		return self:GetSpecialValueFor("heaven_spear_radius")
	end

	return 0
end

function imba_mars_spear:GetCastRange()
	if IsClient() then
		return self:GetVanillaAbilitySpecial("spear_range")
	end
end

function imba_mars_spear:OnAbilityPhaseStart()
	self.autocast = self:GetAutoCastState()

	if self.autocast then
		self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_1)
	end

	return true
end

-- Ability Start
function imba_mars_spear:OnSpellStart()
	-- unit identifier
	local point = self:GetCursorPosition()

	-- load data
	local projectile_name = "particles/units/heroes/hero_mars/mars_spear.vpcf"
	local projectile_distance = self:GetVanillaAbilitySpecial("spear_range")
	local projectile_speed = self:GetVanillaAbilitySpecial("spear_speed")
	local projectile_radius = self:GetVanillaAbilitySpecial("spear_width")
	local projectile_vision = self:GetVanillaAbilitySpecial("spear_vision")
	local heaven_spear_delay = self:GetSpecialValueFor("heaven_spear_delay")
	self.trailblazer_particles = {}

	if not IsServer() then return end

	if self.autocast then
		local duration = projectile_distance / projectile_speed + heaven_spear_delay
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_mars_spear_heaven_spear", {duration = duration})
	else
		-- calculate direction
		local direction = point - self:GetCaster():GetOrigin()
		direction.z = 0
		direction = direction:Normalized()

		local info = {
			Source = self:GetCaster(),
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(),
			
		    bDeleteOnHit = false,
		    
		    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		    
		    EffectName = projectile_name,
		    fDistance = projectile_distance,
		    fStartRadius = projectile_radius,
		    fEndRadius = projectile_radius,
			vVelocity = direction * projectile_speed,
		
			bHasFrontalCone = false,
			bReplaceExisting = false,
			-- fExpireTime = GameRules:GetGameTime() + 10.0,
			
			bProvidesVision = true,
			iVisionRadius = projectile_vision,
			fVisionDuration = 10,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber()
		}

		ProjectileManager:CreateLinearProjectile(info)

		self.trailblazer_thinker = CreateModifierThinker(
			self:GetCaster(),
			self,
			"modifier_imba_mars_spear_trailblazer_thinker",
			{duration = self:GetSpecialValueFor("trailblazer_duration")},
			self:GetCaster():GetAbsOrigin(),
			self:GetCaster():GetTeamNumber(),
			false
		)
	end

	-- play effects
	EmitSoundOn("Hero_Mars.Spear.Cast", self:GetCaster())
	EmitSoundOn("Hero_Mars.Spear", self:GetCaster())
end

modifier_imba_mars_spear_heaven_spear = modifier_imba_mars_spear_heaven_spear or class({})

function modifier_imba_mars_spear_heaven_spear:RemoveOnDeath() return false end

function modifier_imba_mars_spear_heaven_spear:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_mars_spear_heaven_spear:OnCreated()
	if not IsServer() then return end

	self.origin = self:GetAbility():GetCursorPosition()
	self.radius = self:GetAbility():GetSpecialValueFor("heaven_spear_radius")
	self.knockback_radius = self:GetAbility():GetSpecialValueFor("heaven_spear_knockback")
	self.stun_duration = self:GetAbility():GetVanillaAbilitySpecial("stun_duration")
	self.knockback_duration = self:GetAbility():GetSpecialValueFor("heaven_spear_duration")
	self.delay = self:GetAbility():GetSpecialValueFor("heaven_spear_delay")
	self.height = 700
	self.travel_time = self:GetDuration() - self.delay

	-- add viewer
	AddFOWViewer( self:GetCaster():GetTeamNumber(), self.origin, self.radius, self.stun_duration, false)

	local pre_spear = ParticleManager:CreateParticle("particles/units/hero/hero_mars/mars_sky_spear.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
--	ParticleManager:SetParticleControl(pre_spear, 0, self.origin)
	ParticleManager:SetParticleControl(pre_spear, 1, Vector(self.height, self.delay, self.travel_time))
	ParticleManager:SetParticleControl(pre_spear, 2, self.origin)
	self:AddParticle(pre_spear, false, false, -1, false, false)
end

function modifier_imba_mars_spear_heaven_spear:OnRemoved()
	if not IsServer() then return end

	local units = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self.origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)

	local hero_found = 0

	if #units > 0 then
		for k, v in pairs(units) do
			if v:IsConsideredHero() and hero_found < 1 then -- includes IsRealHero()
				hero_found = hero_found + 1

				v:SetAbsOrigin(self.origin)
				v:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_mars_spear_debuff", {duration = self.stun_duration, heaven_spear = 1})
				EmitSoundOn("Hero_Mars.Spear.Root", v)
			else
				local enemy_direction = (v:GetOrigin() - self.origin):Normalized()

				-- knockback if not having spear stun
				if not v:HasModifier( "modifier_imba_mars_spear_debuff" ) then
					v:AddNewModifier(
						caster, -- player source
						self, -- ability source
						"modifier_generic_knockback_lua", -- modifier name
						{
							duration = self.knockback_duration,
							distance = self.knockback_radius,
							height = 50,
							direction_x = enemy_direction.x,
							direction_y = enemy_direction.y,
						} -- kv
					)
				end
			end

			-- apply damage
			local damageTable = {
				victim = v,
				attacker = self:GetCaster(),
				damage = self:GetAbility():GetVanillaAbilitySpecial("damage"),
				damage_type = self:GetAbility():GetAbilityDamageType(),
				ability = self:GetAbility(), --Optional.
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			}
			ApplyDamage(damageTable)
		end
	end

	-- trailblazer
	self.trailblazer_thinker = CreateModifierThinker(
		self:GetCaster(),
		self:GetAbility(),
		"modifier_imba_mars_spear_trailblazer_thinker",
		{duration = self:GetAbility():GetSpecialValueFor("trailblazer_duration"), heaven_spear = 1},
		self.origin,
		self:GetCaster():GetTeamNumber(),
		false
	)

	self.trailblazer_thinker:EmitSound("Hero_Mars.Spear.Target", self:GetCaster())
end

--------------------------------------------
-- MODIFIER_IMBA_mars_spear_trailblazer_THINKER --
--------------------------------------------

modifier_imba_mars_spear_trailblazer_thinker = modifier_imba_mars_spear_trailblazer_thinker or class({})

function modifier_imba_mars_spear_trailblazer_thinker:IsPurgable() return false end

function modifier_imba_mars_spear_trailblazer_thinker:CheckState() return {
	-- keep thinker visible by everyone, so the firefly ground pfx don't disappear when batrider is no longer visible
	[MODIFIER_STATE_PROVIDES_VISION] = true,
} end

function modifier_imba_mars_spear_trailblazer_thinker:OnCreated(keys)
	if not IsServer() then return end

	if keys.heaven_spear then
		self.heaven_spear = keys.heaven_spear
	end

	self.tick_time = self:GetAbility():GetSpecialValueFor("trailblazer_tick_time")
	self.start_pos = self:GetParent():GetAbsOrigin()
	local direction = (self:GetCaster():GetCursorPosition() - self.start_pos):Normalized()

	if self.heaven_spear and self.heaven_spear == 1 then
		self.end_pos = self.start_pos
	else
		local direction = (self:GetCaster():GetCursorPosition() - self.start_pos):Normalized()
		self.end_pos = self.start_pos + direction * self:GetAbility():GetVanillaAbilitySpecial("spear_range")
	end

	if self.heaven_spear and self.heaven_spear == 1 then
		local ground_pfx = ParticleManager:CreateParticle("particles/units/hero/hero_mars/mars_sky_spear_ground.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(ground_pfx, 0, self.start_pos)
		ParticleManager:ReleaseParticleIndex(ground_pfx)
	end

	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_mars/mars_spear_burning_trail.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(self.pfx, 0, self.start_pos)
	ParticleManager:SetParticleControl(self.pfx, 1, self.end_pos)
	ParticleManager:SetParticleControl(self.pfx, 2, Vector(self:GetAbility():GetSpecialValueFor("trailblazer_duration"), 0, 0))
	ParticleManager:SetParticleControl(self.pfx, 3, Vector(self:GetAbility():GetSpecialValueFor("heaven_spear_radius"), 0, 0))

	self:StartIntervalThink(self.tick_time)
end

function modifier_imba_mars_spear_trailblazer_thinker:OnIntervalThink()
	local damage = (self:GetAbility():GetVanillaAbilitySpecial("damage") * (self:GetAbility():GetSpecialValueFor("trailblazer_damage_pct") / 100)) * self.tick_time
	local enemies = nil

	if self.heaven_spear and self.heaven_spear == 1 then
		enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.start_pos, nil, self:GetAbility():GetSpecialValueFor("trailblazer_radius"), self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), 0, false)
	else
		enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(), self.start_pos, self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("trailblazer_radius"), self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags())
	end

	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({
				attacker = self:GetCaster(),
				victim = enemy,
				damage = damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				damage_flags = self:GetAbility():GetAbilityTargetFlags()
			})
		end
	end
end

function modifier_imba_mars_spear_trailblazer_thinker:OnDestroy()
	if not IsServer() then return end

	self:GetParent():RemoveSelf()

	if self:GetAbility() then
		self:GetAbility().trailblazer_thinker = nil
	end

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end

--------------------------------------------------------------------------------
-- Projectile
-- projectile management
--[[
Fields:
- location
- direction
- init_pos
- unit
- modifier
- active
]]
local mars_projectiles = {}
function mars_projectiles:Init( projectileID )
	self[projectileID] = {}

	-- set location
	self[projectileID].location = ProjectileManager:GetLinearProjectileLocation( projectileID )
	self[projectileID].init_pos = self[projectileID].location

	-- set direction
	local direction = ProjectileManager:GetLinearProjectileVelocity( projectileID )
	direction.z = 0
	direction = direction:Normalized()
	self[projectileID].direction = direction
end

function mars_projectiles:Destroy( projectileID )
	self[projectileID] = nil
end
imba_mars_spear.projectiles = mars_projectiles

function imba_mars_spear:OnProjectileThink(vLocation)
	if not IsServer() then return end

	if self.trailblazer_thinker and vLocation then
		self.trailblazer_thinker:SetAbsOrigin(vLocation)
	end
end

-- projectile hit
function imba_mars_spear:OnProjectileHitHandle( target, location, iProjectileHandle )
	-- init in case it isn't initialized from below (if projectile launched very close to target)
	if not self.projectiles[iProjectileHandle] then
		self.projectiles:Init( iProjectileHandle )
	end

	if not target then
		-- add viewer
		local projectile_vision = self:GetVanillaAbilitySpecial("spear_vision")
		AddFOWViewer( self:GetCaster():GetTeamNumber(), location, projectile_vision, 1, false)

		-- destroy data
		self.projectiles:Destroy( iProjectileHandle )
		return
	end

	-- get stun and damage
	local stun = self:GetVanillaAbilitySpecial("stun_duration") + self:GetCaster():FindTalentValue("special_bonus_unique_mars_spear_stun_duration")
	local damage = self:GetVanillaAbilitySpecial("damage") + self:GetCaster():FindTalentValue("special_bonus_unique_mars_spear_bonus_damage")

	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	ApplyDamage(damageTable)

	-- check if it has skewered a unit, or target is not a hero
	if (not target:IsHero()) or self.projectiles[iProjectileHandle].unit then
		-- calculate knockback direction
		local direction = self.projectiles[iProjectileHandle].direction
		local proj_angle = VectorToAngles( direction ).y
		local unit_angle = VectorToAngles( target:GetOrigin()-location ).y
		local angle_diff = unit_angle - proj_angle
		if AngleDiff( unit_angle, proj_angle )>=0 then
			direction = RotatePosition( Vector(0,0,0), QAngle( 0, 90, 0 ), direction )
		else
			direction = RotatePosition( Vector(0,0,0), QAngle( 0, -90, 0 ), direction )
		end

		-- add sidestep modifier to other unit
		local knockback_duration = self:GetVanillaAbilitySpecial("knockback_duration")
		local knockback_distance = self:GetVanillaAbilitySpecial("knockback_distance")

		target:AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_generic_knockback_lua", -- modifier name
			{
				duration = knockback_duration,
				distance = knockback_distance,
				direction_x = direction.x,
				direction_y = direction.y,
				IsFlail = false,
			} -- kv
		)

		-- play effects
		local sound_cast = "Hero_Mars.Spear.Knockback"
		EmitSoundOn( sound_cast, target )

		return false
	end

	-- add modifier to skewered unit
	local modifier = target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_imba_mars_spear", -- modifier name
		{
			projectile = iProjectileHandle,
		} -- kv
	)
	self.projectiles[iProjectileHandle].unit = target
	self.projectiles[iProjectileHandle].modifier = modifier
	self.projectiles[iProjectileHandle].active = false

	-- play effects
	local sound_cast = "Hero_Mars.Spear.Target"
	EmitSoundOn( sound_cast, target )
end

-- projectile think
function imba_mars_spear:OnProjectileThinkHandle( iProjectileHandle )
	-- init for the first time
	if not self.projectiles[iProjectileHandle] then
		self.projectiles:Init( iProjectileHandle )
	end

	local data = self.projectiles[iProjectileHandle]

	-- init data
	local tree_radius = 120
	local wall_radius = 50
	local building_radius = 30
	local blocker_radius = 70

	-- save location
	local location = ProjectileManager:GetLinearProjectileLocation( iProjectileHandle )
	data.location = location

	-- check skewered unit, and dragged (caught unit not necessarily dragged)
	if not data.unit then return end
	if not data.active then
		-- check distance, mainly to avoid being pinned while behind the tree/cliffs
		local difference = (data.unit:GetOrigin()-data.init_pos):Length2D() - (data.location-data.init_pos):Length2D()
		if difference>0 then return end
		data.active = true
	end

	-- search for arena walls
	local arena_walls = Entities:FindAllByClassnameWithin( "npc_dota_phantomassassin_gravestone", data.location, wall_radius )
	for _,arena_wall in pairs(arena_walls) do
		if arena_wall:HasModifier( "modifier_imba_mars_arena_of_blood_blocker" ) then
			self:Pinned( iProjectileHandle )
			return			
		end
	end

	-- search for blocker
	local thinkers = Entities:FindAllByClassnameWithin( "npc_dota_thinker", data.location, wall_radius )
	for _,thinker in pairs(thinkers) do
		if thinker:IsPhantomBlocker() then
			self:Pinned( iProjectileHandle )
			return
		end
	end

	-- search for high ground
	local base_loc = GetGroundPosition( data.location, data.unit )
	local search_loc = GetGroundPosition( base_loc + data.direction*wall_radius, data.unit )
	if search_loc.z-base_loc.z>10 and (not GridNav:IsTraversable( search_loc )) then
		self:Pinned( iProjectileHandle )
		return
	end

	-- search for tree
	if GridNav:IsNearbyTree( data.location, tree_radius, false) then
		-- pinned
		self:Pinned( iProjectileHandle )
		return
	end

	-- search for buildings
	local buildings = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		data.location,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		building_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_BUILDING,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	if #buildings>0 then
		-- pinned
		self:Pinned( iProjectileHandle )
		return
	end
end

function imba_mars_spear:Pinned( iProjectileHandle )
	local data = self.projectiles[iProjectileHandle]
	local duration = self:GetVanillaAbilitySpecial("stun_duration")
	local projectile_vision = self:GetVanillaAbilitySpecial("spear_vision")

	-- add viewer
	AddFOWViewer( self:GetCaster():GetTeamNumber(), data.unit:GetOrigin(), projectile_vision, duration, false)

	-- destroy projectile and modifier
	ProjectileManager:DestroyLinearProjectile( iProjectileHandle )
	if data.modifier and not data.modifier:IsNull() then
		data.modifier:Destroy()

		data.unit:SetOrigin( GetGroundPosition( data.location, data.unit ) )
	end

	-- add stun modifier
	data.unit:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_imba_mars_spear_debuff", -- modifier name
		{
			duration = duration,
			projectile = iProjectileHandle,
		} -- kv
	)

	-- play effects
	self:PlayEffects( iProjectileHandle, duration )

	-- delete data
	self.projectiles:Destroy( iProjectileHandle )
end
--------------------------------------------------------------------------------
function imba_mars_spear:PlayEffects( projID, duration )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_spear_impact.vpcf"
	local sound_cast = "Hero_Mars.Spear.Root"

	-- Get Data
	local data = self.projectiles[projID]
	local delta = 50
	local location = GetGroundPosition( data.location, data.unit ) + data.direction*delta

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, location )
	ParticleManager:SetParticleControl( effect_cast, 1, data.direction*1000 )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( duration, 0, 0 ) )
	ParticleManager:SetParticleControlForward( effect_cast, 0, data.direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, data.unit )
end

--------------------------------------------------------------------------------
modifier_imba_mars_spear = modifier_imba_mars_spear or class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_mars_spear:IsHidden()
	return false
end

function modifier_imba_mars_spear:IsDebuff()
	return true
end

function modifier_imba_mars_spear:IsStunDebuff()
	return true
end

function modifier_imba_mars_spear:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_mars_spear:OnCreated( kv )
	if IsServer() then
		self.projectile = kv.projectile

		-- face towards
		self:GetParent():SetForwardVector( -self:GetAbility().projectiles[kv.projectile].direction )
		self:GetParent():FaceTowards( self:GetAbility().projectiles[self.projectile].init_pos )

		-- try apply
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function modifier_imba_mars_spear:OnRefresh( kv )
	
end

function modifier_imba_mars_spear:OnRemoved()
	if not IsServer() then return end
	-- Compulsory interrupt
	self:GetParent():InterruptMotionControllers( false )
end

function modifier_imba_mars_spear:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_mars_spear:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_imba_mars_spear:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_imba_mars_spear:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_mars_spear:OnIntervalThink()
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_imba_mars_spear:UpdateHorizontalMotion( me, dt )
	-- check projectile data
	if not self:GetAbility().projectiles[self.projectile] then
		self:Destroy()
		return
	end

	-- get location
	local data = self:GetAbility().projectiles[self.projectile]

	if not data.active then return end

	-- move parent to projectile location
	self:GetParent():SetOrigin( data.location + data.direction*60 )
end

function modifier_imba_mars_spear:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
modifier_imba_mars_spear_debuff = modifier_imba_mars_spear_debuff or class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_mars_spear_debuff:IsHidden()
	return false
end

function modifier_imba_mars_spear_debuff:IsDebuff()
	return true
end

function modifier_imba_mars_spear_debuff:IsStunDebuff()
	return true
end

function modifier_imba_mars_spear_debuff:IsPurgable()
	return true
end

function modifier_imba_mars_spear_debuff:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_mars_spear_debuff:OnCreated( kv )
	if not IsServer() then return end

	self.projectile = kv.projectile
end

function modifier_imba_mars_spear_debuff:OnRefresh( kv )
end

function modifier_imba_mars_spear_debuff:OnRemoved()
	if not IsServer() then return end

	-- destroy tree
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), 120, false )
end

function modifier_imba_mars_spear_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_mars_spear_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_imba_mars_spear_debuff:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_imba_mars_spear_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_mars_spear_debuff:GetEffectName()
	return "particles/units/heroes/hero_mars/mars_spear_impact_debuff.vpcf"
end

function modifier_imba_mars_spear_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_mars_spear_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_mars_spear.vpcf"
end

-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
imba_mars_gods_rebuke = imba_mars_gods_rebuke or class({})
LinkLuaModifier( "modifier_imba_mars_gods_rebuke", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_mars_gods_rebuke_strong_argument", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function imba_mars_gods_rebuke:GetCooldown(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("imba_scepter_cooldown")
	end

	return self.BaseClass.GetCooldown(self, iLevel)
end

function imba_mars_gods_rebuke:GetBehavior()
--	if self:GetCaster():HasTalent("special_bonus_imba_mars_1") then
--		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
--	end

	return DOTA_ABILITY_BEHAVIOR_POINT
end

function imba_mars_gods_rebuke:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	local mod = caster:FindModifierByName("modifier_imba_mars_bulwark_active")

	if mod then
		point = caster:GetAbsOrigin() + mod.forward_vector
	end

	-- load data
	local radius = self:GetVanillaAbilitySpecial("radius")
	local angle = self:GetVanillaAbilitySpecial("angle") / 2
	local duration = self:GetVanillaAbilitySpecial("knockback_duration")
	local distance = self:GetVanillaAbilitySpecial("knockback_distance")

	-- find units
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- add buff modifier
	local buff = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_imba_mars_gods_rebuke", -- modifier name
		{  } -- kv
	)

	-- precache
	local origin = caster:GetOrigin()
	local cast_direction = (point-origin):Normalized()
	local cast_angle = VectorToAngles( cast_direction ).y

	-- for each units
	local caught = false
	local heroes_count = 0

	for _,enemy in pairs(enemies) do
		-- check within cast angle
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )

		-- If in right angle or has full circle talent
		if angle_diff <= angle or self:GetCaster():HasTalent("special_bonus_imba_mars_1") then
			-- attack
			caster:PerformAttack(
				enemy,
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)

			-- knockback if not having spear stun
			if not enemy:HasModifier( "modifier_imba_mars_spear_debuff" ) then
				enemy:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_generic_knockback_lua", -- modifier name
					{
						duration = duration,
						distance = distance,
						height = 30,
						direction_x = enemy_direction.x,
						direction_y = enemy_direction.y,
						IsStun = self:GetCaster():HasTalent("special_bonus_imba_mars_2"),
					} -- kv
				)
			end

			if enemy:IsRealHero() then
				heroes_count = heroes_count + 1
			end

			-- play effects
			self:PlayEffects2( enemy, origin, cast_direction )
		end
	end

	if #enemies > 0 then
		if heroes_count > 0 then
			caught = true

			local stacks = heroes_count * self:GetSpecialValueFor("strong_argument_bonus_strength")

			caster:AddNewModifier(caster, self, "modifier_imba_mars_gods_rebuke_strong_argument", {duration = self:GetSpecialValueFor("strong_argument_duration")}):SetStackCount(stacks)
			caster:CalculateStatBonus(true)
		end
	end

	-- destroy buff modifier
	buff:Destroy()

	-- play effects
	self:PlayEffects1(caught, (point - origin):Normalized())
end

--------------------------------------------------------------------------------
-- Play Effects
function imba_mars_gods_rebuke:PlayEffects1( caught, direction )
	local sound_cast = "Hero_Mars.Shield.Cast"

	if caught == false then
		local sound_cast = "Hero_Mars.Shield.Cast.Small"
	end

	-- Create Particle
	if self:GetCaster():HasTalent("special_bonus_imba_mars_1") then
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_shield_bash_full_circle.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
		ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
		ParticleManager:ReleaseParticleIndex( effect_cast )
	else
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_shield_bash.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
		ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

function imba_mars_gods_rebuke:PlayEffects2( target, origin, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf"
	local sound_cast = "Hero_Mars.Shield.Crit"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
modifier_imba_mars_gods_rebuke = modifier_imba_mars_gods_rebuke or class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_mars_gods_rebuke:IsHidden() return true end
function modifier_imba_mars_gods_rebuke:IsDebuff() return false end
function modifier_imba_mars_gods_rebuke:IsPurgable() return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_mars_gods_rebuke:OnCreated( kv )
	-- references
	self.bonus_damage = self:GetAbility():GetVanillaAbilitySpecial( "bonus_damage_vs_heroes" )
	self.bonus_crit = self:GetAbility():GetVanillaAbilitySpecial( "crit_mult" ) + self:GetCaster():FindTalentValue("special_bonus_unique_mars_gods_rebuke_extra_crit")

	local mod = self:GetParent():FindModifierByName("modifier_imba_mars_bulwark_jupiters_strength")

	if mod then
		self.bonus_damage = self.bonus_damage + mod:GetStackCount()
		mod.stack_table = {}
		mod:SetStackCount(0)
	else
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_mars_bulwark_jupiters_strength", {})
	end
end

function modifier_imba_mars_gods_rebuke:OnRefresh( kv )
end

function modifier_imba_mars_gods_rebuke:OnRemoved()
end

function modifier_imba_mars_gods_rebuke:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_mars_gods_rebuke:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}

	return funcs
end

function modifier_imba_mars_gods_rebuke:GetModifierPreAttack_BonusDamagePostCrit( params )
	if not IsServer() then return end
	print("Bonus Damage:", self.bonus_damage)
	return self.bonus_damage
end
function modifier_imba_mars_gods_rebuke:GetModifierPreAttack_CriticalStrike( params )
	print("Bonus Crit:", self.bonus_crit)
	return self.bonus_crit
end

--------------------------------------------------------------------------------
modifier_imba_mars_gods_rebuke_strong_argument = modifier_imba_mars_gods_rebuke_strong_argument or class({})

function modifier_imba_mars_gods_rebuke_strong_argument:DeclareFunctions() return {
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
} end

function modifier_imba_mars_gods_rebuke_strong_argument:GetModifierBonusStats_Strength()
	return self:GetStackCount()
end

--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_imba_mars_bulwark", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE )
-- Using vanilla modifier for now
LinkLuaModifier( "modifier_imba_mars_bulwark_active", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_mars_bulwark_jupiters_strength", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE )

imba_mars_bulwark = imba_mars_bulwark or class({})

--------------------------------------------------------------------------------

function imba_mars_bulwark:IsStealable()			return false end
function imba_mars_bulwark:ResetToggleOnRespawn()	return true end

function imba_mars_bulwark:GetIntrinsicModifierName()
	return "modifier_imba_mars_bulwark"
end

function imba_mars_bulwark:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_mars_bulwark_active", {})
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_mars_bulwark_active", {})
	else
		self:GetCaster():RemoveModifierByName("modifier_mars_bulwark_active")
		self:GetCaster():RemoveModifierByName("modifier_imba_mars_bulwark_active")
	end
end

--------------------------------------------------------------------------------

modifier_imba_mars_bulwark = modifier_imba_mars_bulwark or class({})

--------------------------------------------------------------------------------

-- Classifications
function modifier_imba_mars_bulwark:IsHidden()
	return true
end

function modifier_imba_mars_bulwark:IsDebuff()
	return false
end

function modifier_imba_mars_bulwark:IsStunDebuff()
	return false
end

function modifier_imba_mars_bulwark:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_mars_bulwark:OnCreated( kv )
	-- references
	self.reduction_front = self:GetAbility():GetVanillaAbilitySpecial( "physical_damage_reduction" )
	self.reduction_side = self:GetAbility():GetVanillaAbilitySpecial( "physical_damage_reduction_side" )
	self.angle_front = self:GetAbility():GetVanillaAbilitySpecial( "forward_angle" )/2
	self.angle_side = self:GetAbility():GetVanillaAbilitySpecial( "side_angle" )/2

	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_mars_bulwark_jupiters_strength", {})
	end
end

function modifier_imba_mars_bulwark:OnRefresh( kv )
	-- references
	self.reduction_front = self:GetAbility():GetVanillaAbilitySpecial( "physical_damage_reduction" )
	self.reduction_side = self:GetAbility():GetVanillaAbilitySpecial( "physical_damage_reduction_side" )
	self.angle_front = self:GetAbility():GetVanillaAbilitySpecial( "forward_angle" )/2
	self.angle_side = self:GetAbility():GetVanillaAbilitySpecial( "side_angle" )/2
end

function modifier_imba_mars_bulwark:OnRemoved()
end

function modifier_imba_mars_bulwark:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_mars_bulwark:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
	}

	return funcs
end

function modifier_imba_mars_bulwark:GetModifierPhysical_ConstantBlock( params )
	-- cancel if from ability
	if params.inflictor then return 0 end

	-- cancel if break
	if params.target:PassivesDisabled() then return 0 end

	-- get data
	local parent = params.target
	local attacker = params.attacker
	local reduction = 0

	-- Check target position
	local facing_direction = parent:GetAnglesAsVector().y
	local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
	local attacker_direction = VectorToAngles( attacker_vector ).y
	local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ) )

	-- calculate damage reduction
	if angle_diff < self.angle_front then
		reduction = self.reduction_front
		self:PlayEffects( true, attacker_vector )
	elseif angle_diff < self.angle_side then
		reduction = self.reduction_side
		self:PlayEffects( false, attacker_vector )
	end

	local damage_blocked = reduction * params.damage / 100

	local stacks = damage_blocked * self:GetAbility():GetSpecialValueFor("jupiters_strength_stored_damage_pct") / 100
	local mod = self:GetParent():FindModifierByName("modifier_imba_mars_bulwark_jupiters_strength")

	if mod then
		mod:SetStackCount(mod:GetStackCount() + stacks)
	else
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_mars_bulwark_jupiters_strength", {}):SetStackCount(stacks)
	end

	return damage_blocked
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_mars_bulwark:PlayEffects( front )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_of_mars.vpcf"
	local sound_cast = "Hero_Mars.Shield.Block"

	if not front then
		particle_cast = "particles/units/heroes/hero_mars/mars_shield_of_mars_small.vpcf"
		sound_cast = "Hero_Mars.Shield.BlockSmall"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	self:GetParent():EmitSound(sound_cast)
end

modifier_imba_mars_bulwark_active = modifier_imba_mars_bulwark_active or class({})

function modifier_imba_mars_bulwark_active:IsHidden() return true end

function modifier_imba_mars_bulwark_active:DeclareFunctions() return {
	MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
} end

function modifier_imba_mars_bulwark_active:OnCreated()
	if not IsServer() then return end

	self.ability = self:GetAbility()
	self.forward_vector = self:GetParent():GetForwardVector()
	self.angle_front = self.ability:GetVanillaAbilitySpecial( "forward_angle" ) / 2
	self.angle_side = self.ability:GetVanillaAbilitySpecial( "side_angle" ) / 2
	self.spiked_shield_return_pct = self.ability:GetSpecialValueFor("spiked_shield_return_pct")

	self:StartIntervalThink(FrameTime())
end

function modifier_imba_mars_bulwark_active:OnIntervalThink()
	self:GetParent():SetForwardVector(self.forward_vector)
end

function modifier_imba_mars_bulwark_active:OnAbilityFullyCast(params)
	if not IsServer() then return end

	if params.ability and params.ability.GetAbilityName and params.unit == self:GetParent() then
		if params.ability:GetAbilityName() == "imba_mars_spear" then
			self.ability:ToggleAbility()
		end
	end
end

function modifier_imba_mars_bulwark_active:OnTakeDamage(keys)
	if not IsServer() then return end

	local attacker = keys.attacker
	local target = keys.unit
	local original_damage = keys.original_damage
	local damage_type = keys.damage_type
	local damage_flags = keys.damage_flags
	local damage = keys.damage

	if keys.unit == self:GetParent() and not keys.attacker:IsBuilding() and keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then	
		if not keys.unit:IsOther() then
			local facing_direction = self:GetParent():GetAnglesAsVector().y
			local attacker_vector = (attacker:GetOrigin() - self:GetParent():GetOrigin())
			local attacker_direction = VectorToAngles( attacker_vector ).y
			local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ) )

			local bonus_damage = 0

			-- calculate damage reduction (same return from front or side for now, leaving different statements here in case it gets changed)
			if angle_diff < self.angle_front then
				bonus_damage = self.spiked_shield_return_pct
			elseif angle_diff < self.angle_side then
				bonus_damage = self.spiked_shield_return_pct
			end

			-- if received damage from front or side
			if bonus_damage > 0 then
				local damageTable = {
					victim			= keys.attacker,
					damage			= keys.original_damage / 100 * bonus_damage,
					damage_type		= keys.damage_type,
					damage_flags	= DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
					attacker		= self:GetParent(),
					ability			= self.ability
				}

				-- expecting shitfest in team fights so let's not
--				EmitSoundOnClient("DOTA_Item.BladeMail.Damage", keys.attacker:GetPlayerOwner())

				ApplyDamage(damageTable)
			end
		end
	end
end

modifier_imba_mars_bulwark_jupiters_strength = modifier_imba_mars_bulwark_jupiters_strength or class({})

function modifier_imba_mars_bulwark_jupiters_strength:RemoveOnDeath() return false end
function modifier_imba_mars_bulwark_jupiters_strength:IsPurgable() return false end

function modifier_imba_mars_bulwark_jupiters_strength:IsHidden()
	if self:GetStackCount() == 0 then
		return true
	end

	return false
end

function modifier_imba_mars_bulwark_jupiters_strength:OnCreated()
	if IsServer() then
		self.duration = self:GetAbility():GetSpecialValueFor("jupiters_strength_duration")
		self.stack_table = {}
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_mars_bulwark_jupiters_strength:OnIntervalThink()
	if not self.stack_table[1] then return end
	-- Check if the firstmost entry in the table has expired
	local item_time = self.stack_table[1][1]
	local stacks = self.stack_table[1][2]

	if item_time then
		-- If the difference between times is longer, it's time to get rid of a stack
		if GameRules:GetGameTime() - item_time >= self.duration then
			-- Remove the entry from the table
			table.remove(self.stack_table, 1)

			-- Decrement a stack
			self:SetStackCount(self:GetStackCount() - stacks)
			self:GetParent():CalculateStatBonus(true)
		end
	end
end

function modifier_imba_mars_bulwark_jupiters_strength:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end

	local stacks = self:GetStackCount()

	-- We only care about stack incrementals
	if stacks > prev_stacks then
		-- Insert the current game time of the stack that was just added to the stack table
		table.insert(self.stack_table, {GameRules:GetGameTime(), stacks - prev_stacks})
		self:SetDuration(self.duration, true)

		-- Refresh timer
--		self:ForceRefresh()
	end
end

--[[
Shoud be revised:
- soldier still use "models/heroes/attachto_ghost/pa_gravestone_ghost.vmdl" as base class (also affects Spear of Mars)
]]
--------------------------------------------------------------------------------
imba_mars_arena_of_blood = imba_mars_arena_of_blood or class({})
LinkLuaModifier( "modifier_imba_mars_arena_of_blood", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_mars_arena_of_blood_blocker", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_mars_arena_of_blood_thinker", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_mars_arena_of_blood_wall_aura", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_mars_arena_of_blood_spear_aura", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_mars_arena_of_blood_projectile_aura", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_imba_mars_arena_of_blood_coliseum_aura", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mars_arena_of_blood_coliseum", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mars_arena_of_blood_scepter", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_BOTH)

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function imba_mars_arena_of_blood:GetAOERadius()
	return self:GetVanillaAbilitySpecial( "radius" )
end

function imba_mars_arena_of_blood:GetCastRange(vLocation, hTarget)
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("scepter_cast_range")
	end

	return self.BaseClass.GetCastRange(self, vLocation, hTarget)
end

--------------------------------------------------------------------------------
-- Ability Start
function imba_mars_arena_of_blood:OnSpellStart()
	if not IsServer() then return end

	local cast_position = self:GetCursorPosition()

	if self:GetCaster():HasScepter() then
		self.scepter_cast_position = cast_position
		local mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_mars_arena_of_blood_scepter", {})
	else
		-- create thinker
		CreateModifierThinker(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_imba_mars_arena_of_blood_thinker", -- modifier name
			{  }, -- kv
			cast_position,
			self:GetCaster():GetTeamNumber(),
			false
		)
	end
end

--------------------------------------------------------------------------------
-- Projectile
imba_mars_arena_of_blood.projectiles = {}
function imba_mars_arena_of_blood:OnProjectileHitHandle( target, location, id )
	local data = self.projectiles[id]
	self.projectiles[id] = nil

	if data.destroyed then return end

	local attacker = EntIndexToHScript( data.entindex_source_const )
	attacker:PerformAttack( target, true, true, true, true, false, false, true )
end

--------------------------------------------------------------------------------
modifier_imba_mars_arena_of_blood = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_mars_arena_of_blood:IsHidden()
	return false
end

function modifier_imba_mars_arena_of_blood:IsDebuff()
	return false
end

function modifier_imba_mars_arena_of_blood:IsStunDebuff()
	return false
end

function modifier_imba_mars_arena_of_blood:IsPurgable()
	return true
end

function modifier_imba_mars_arena_of_blood:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_INVULNERABLE 
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_mars_arena_of_blood:OnCreated( kv )
	if IsServer() then
		-- Start interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()
	end
end

function modifier_imba_mars_arena_of_blood:OnRefresh( kv )
	
end

function modifier_imba_mars_arena_of_blood:OnRemoved()
end

function modifier_imba_mars_arena_of_blood:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_mars_arena_of_blood:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_EVENT_ON_ATTACKED,
	}

	return funcs
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_imba_mars_arena_of_blood:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_mars_arena_of_blood:OnIntervalThink()
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_imba_mars_arena_of_blood:UpdateHorizontalMotion( me, dt )
end

function modifier_imba_mars_arena_of_blood:OnHorizontalMotionInterrupted()
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_imba_mars_arena_of_blood:IsAura()
	return true
end

function modifier_imba_mars_arena_of_blood:GetModifierAura()
	return "modifier_imba_mars_arena_of_blood_effect"
end

function modifier_imba_mars_arena_of_blood:GetAuraRadius()
	return self.radius
end

function modifier_imba_mars_arena_of_blood:GetAuraDuration()
	return self.radius
end

function modifier_imba_mars_arena_of_blood:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_mars_arena_of_blood:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_mars_arena_of_blood:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_imba_mars_arena_of_blood:GetAuraEntityReject( hEntity )
	if IsServer() then
		
	end

	return false
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_mars_arena_of_blood:GetEffectName()
	return "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
end

function modifier_imba_mars_arena_of_blood:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_mars_arena_of_blood:GetStatusEffectName()
	return "status/effect/here.vpcf"
end

function modifier_imba_mars_arena_of_blood:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
	local sound_cast = "string"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_NAME, hOwner )
	ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		iControlPoint,
		hTarget,
		PATTACH_NAME,
		"attach_name",
		vOrigin, -- unknown
		bool -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, iControlPoint, vForward )
	SetParticleControlOrientation( effect_cast, iControlPoint, vForward, vRight, vUp )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOnLocationWithCaster( vTargetPosition, sound_location, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end

--------------------------------------------------------------------------------
modifier_imba_mars_arena_of_blood_blocker = modifier_imba_mars_arena_of_blood_blocker or class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_mars_arena_of_blood_blocker:IsHidden()
	return true
end

function modifier_imba_mars_arena_of_blood_blocker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_mars_arena_of_blood_blocker:OnCreated( kv )
	if not IsServer() then return end

	if kv.model==1 then
		-- references
		self.fade_min = self:GetAbility():GetVanillaAbilitySpecial( "warrior_fade_min_dist" )
		self.fade_max = self:GetAbility():GetVanillaAbilitySpecial( "warrior_fade_max_dist" )
		self.fade_range = self.fade_max-self.fade_min
		self.origin = self:GetParent():GetOrigin()

		-- replace model for even soldiers
		self:GetParent():SetOriginalModel( "models/heroes/mars/mars_soldier.vmdl" )
		self:GetParent():SetRenderAlpha( 0 )
		self:GetParent().model = 1

		-- Start interval
		self:StartIntervalThink( 0.1 )
	end
end

function modifier_imba_mars_arena_of_blood_blocker:OnRefresh( kv )
end

function modifier_imba_mars_arena_of_blood_blocker:OnRemoved()
end

function modifier_imba_mars_arena_of_blood_blocker:OnDestroy()
	if not IsServer() then return end
	self:GetParent():ForceKill( false )
	-- UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_imba_mars_arena_of_blood_blocker:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_mars_arena_of_blood_blocker:OnIntervalThink()
	local alpha = 0

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self.origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.fade_max,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- find out distance between closest enemy
	if #enemies>0 then
		local enemy = enemies[1]
		local range = math.max( self:GetParent():GetRangeToUnit( enemy ), self.fade_min )
		range = math.min( range, self.fade_max )-self.fade_min
		alpha = self:Interpolate( range/self.fade_range, 255, 0 )
	end

	-- set alpha based on distance
	self:GetParent():SetRenderAlpha( alpha )
end

function modifier_imba_mars_arena_of_blood_blocker:Interpolate( value, min, max )
	return value*(max-min) + min
end

modifier_imba_mars_arena_of_blood_coliseum_aura = modifier_imba_mars_arena_of_blood_coliseum_aura or class({})

function modifier_imba_mars_arena_of_blood_coliseum_aura:IsHidden()	return true end
function modifier_imba_mars_arena_of_blood_coliseum_aura:IsPurgable() return false end
function modifier_imba_mars_arena_of_blood_coliseum_aura:IsDebuff() return false end

function modifier_imba_mars_arena_of_blood_coliseum_aura:IsAura() return true end
function modifier_imba_mars_arena_of_blood_coliseum_aura:GetModifierAura() return "modifier_imba_mars_arena_of_blood_coliseum" end
function modifier_imba_mars_arena_of_blood_coliseum_aura:GetAuraRadius() return self:GetAbility():GetVanillaAbilitySpecial("radius") end
function modifier_imba_mars_arena_of_blood_coliseum_aura:GetAuraDuration() return 0.0 end
function modifier_imba_mars_arena_of_blood_coliseum_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_mars_arena_of_blood_coliseum_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_imba_mars_arena_of_blood_coliseum_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
--[[
function modifier_imba_mars_arena_of_blood_coliseum_aura:GetAuraEntityReject( hEntity )
	if IsServer() then

	end

	return false
end
--]]

function modifier_imba_mars_arena_of_blood_coliseum_aura:OnCreated()
	if IsServer() then
		if not self:GetAbility() then
			self:Destroy()
			return nil
		end
	end
end

function modifier_imba_mars_arena_of_blood_coliseum_aura:OnRefresh()
	self:OnCreated()
end

modifier_imba_mars_arena_of_blood_coliseum = modifier_imba_mars_arena_of_blood_coliseum or class({})

function modifier_imba_mars_arena_of_blood_coliseum:IsHidden() return true end
function modifier_imba_mars_arena_of_blood_coliseum:IsPurgable() return false end

function modifier_imba_mars_arena_of_blood_coliseum:DeclareFunctions() return {
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
} end

function modifier_imba_mars_arena_of_blood_coliseum:OnCreated()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("coliseum_bonus_damage")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("coliseum_bonus_attack_speed")

	if not IsServer() then return end

	self.health_regen = self:GetCaster():GetOwnerEntity():FindTalentValue("special_bonus_unique_mars_arena_of_blood_hp_regen") or 0

	self:SetHasCustomTransmitterData(true)
	self:StartIntervalThink(0.2) -- for optimisation sake, screw frame time checks we're not a competitive mode
end

function modifier_imba_mars_arena_of_blood_coliseum:OnIntervalThink()
	if IsServer() then
		if not self:GetCaster() or self:GetCaster() and not self:GetCaster():IsAlive() then
			self:Destroy()
			return
		end

		local heroes = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
			self:GetCaster():GetAbsOrigin(),
			nil,
			self:GetAbility():GetVanillaAbilitySpecial("radius"),
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
			FIND_ANY_ORDER,
			false
		)

		-- Set stack count to the number of heroes in arena
		self:SetStackCount(#heroes)
	end
end

function modifier_imba_mars_arena_of_blood_coliseum:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage * self:GetStackCount()
end

function modifier_imba_mars_arena_of_blood_coliseum:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed * self:GetStackCount()
end

function modifier_imba_mars_arena_of_blood_coliseum:AddCustomTransmitterData() return {
	health_regen = self.health_regen,
} end

function modifier_imba_mars_arena_of_blood_coliseum:HandleCustomTransmitterData(data)
	self.health_regen = data.health_regen
end

function modifier_imba_mars_arena_of_blood_coliseum:GetModifierConstantHealthRegen()
	return self.health_regen
end

--------------------------------------------------------------------------------
modifier_imba_mars_arena_of_blood_projectile_aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_mars_arena_of_blood_projectile_aura:IsHidden() return true end
function modifier_imba_mars_arena_of_blood_projectile_aura:IsDebuff() return false end
function modifier_imba_mars_arena_of_blood_projectile_aura:IsStunDebuff() return false end
function modifier_imba_mars_arena_of_blood_projectile_aura:IsPurgable() return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_mars_arena_of_blood_projectile_aura:OnCreated( kv )
	self.radius = self:GetAbility():GetVanillaAbilitySpecial( "radius" )
	self.width = self:GetAbility():GetVanillaAbilitySpecial( "width" )

	if not IsServer() then return end

	self.owner = kv.isProvidedByAura~=1
	if not self.owner then return end

	-- create filter using library
--	self.filter = FilterManager:AddTrackingProjectileFilter( self.ProjectileFilter, self )

	self:StartIntervalThink( 0.03 )
end

function modifier_imba_mars_arena_of_blood_projectile_aura:OnDestroy()
	if not IsServer() then return end

	if not self.owner then return end
--	FilterManager:RemoveTrackingProjectileFilter( self.filter )
end

--------------------------------------------------------------------------------
-- Filter Effects
function modifier_imba_mars_arena_of_blood_projectile_aura:ProjectileFilter( data )
	-- get data
	local attacker = EntIndexToHScript( data.entindex_source_const )
	local target = EntIndexToHScript( data.entindex_target_const )
	local ability = EntIndexToHScript( data.entindex_ability_const )
	local isAttack = data.is_attack

	-- only block things that aren't from this ability
	if self.lock then return true end

	-- only block attacks
	if not data.is_attack then return true end

	-- only block enemies
	if attacker:GetTeamNumber()==self:GetCaster():GetTeamNumber() then return true end

	-- only block projectiles that either one of them is inside
	local mod1 = attacker:FindModifierByNameAndCaster( 'modifier_imba_mars_arena_of_blood_projectile_aura', self:GetCaster() )
	local mod2 = target:FindModifierByNameAndCaster( 'modifier_imba_mars_arena_of_blood_projectile_aura', self:GetCaster() )
	if (not mod1) and (not mod2) then return true end

	-- create projectile
	local info = {
		Target = target,
		Source = attacker,
		Ability = self:GetAbility(),	
		
		EffectName = attacker:GetRangedProjectileName(),
		iMoveSpeed = data.move_speed,
		bDodgeable = true,                           -- Optional
	
		vSourceLoc = attacker:GetAbsOrigin(),                -- Optional (HOW)
		bIsAttack = true,                                -- Optional

		ExtraData = data,
	}
	self.lock = true
	local id = ProjectileManager:CreateTrackingProjectile(info)
	self.lock = false
	self:GetAbility().projectiles[id] = data

	return false
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_mars_arena_of_blood_projectile_aura:OnIntervalThink()
	local origin = self:GetParent():GetOrigin()

	for id,_ in pairs(self:GetAbility().projectiles) do
		-- get position
		local pos = ProjectileManager:GetTrackingProjectileLocation( id )

		-- check location
		local distance = (pos-origin):Length2D()

		-- check if position is within the ring
		if math.abs(distance-self.radius)<self.width then
			-- destroy
			self:GetAbility().projectiles[id].destroyed = true
			ProjectileManager:DestroyTrackingProjectile( id )

			-- play effects
			self:PlayEffects( pos )
		end
	end
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_imba_mars_arena_of_blood_projectile_aura:IsAura()
	return self.owner
end

function modifier_imba_mars_arena_of_blood_projectile_aura:GetModifierAura()
	return "modifier_imba_mars_arena_of_blood_projectile_aura"
end

function modifier_imba_mars_arena_of_blood_projectile_aura:GetAuraRadius()
	return self.radius
end

function modifier_imba_mars_arena_of_blood_projectile_aura:GetAuraDuration()
	return 0.3
end

function modifier_imba_mars_arena_of_blood_projectile_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_imba_mars_arena_of_blood_projectile_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_imba_mars_arena_of_blood_projectile_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_imba_mars_arena_of_blood_projectile_aura:GetAuraEntityReject( hEntity )
	if IsServer() then
		
	end

	return false
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_mars_arena_of_blood_projectile_aura:PlayEffects( loc )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_arena_of_blood_impact.vpcf"
	local sound_cast = "Hero_Mars.Block_Projectile"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( loc, sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
modifier_imba_mars_arena_of_blood_spear_aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_mars_arena_of_blood_spear_aura:IsHidden()
	return true
end

function modifier_imba_mars_arena_of_blood_spear_aura:IsDebuff()
	return true
end

function modifier_imba_mars_arena_of_blood_spear_aura:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_mars_arena_of_blood_spear_aura:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetVanillaAbilitySpecial( "radius" )
	self.width = self:GetAbility():GetVanillaAbilitySpecial( "spear_distance_from_wall" )
	self.duration = self:GetAbility():GetVanillaAbilitySpecial( "spear_attack_interval" )
	self.damage = self:GetAbility():GetVanillaAbilitySpecial( "spear_damage" )
	self.knockback_duration = 0.2

	self.spear_radius = self.radius-self.width

	if not IsServer() then return end
	self.owner = kv.isProvidedByAura~=1
	self.aura_origin = self:GetParent():GetOrigin()

	if not self.owner then
		self.aura_origin = Vector( kv.aura_origin_x, kv.aura_origin_y, 0 )
		local direction = self.aura_origin-self:GetParent():GetOrigin()
		direction.z = 0

		-- damage
		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), --Optional.
		}
		ApplyDamage(damageTable)

		-- animate soldiers
		local arena_walls = Entities:FindAllByClassnameWithin( "npc_dota_phantomassassin_gravestone", self:GetParent():GetOrigin(), 160 )
		for _,arena_wall in pairs(arena_walls) do
			if arena_wall:HasModifier( "modifier_imba_mars_arena_of_blood_blocker" ) and arena_wall.model then
				arena_wall:FadeGesture( ACT_DOTA_ATTACK )
				arena_wall:StartGesture( ACT_DOTA_ATTACK )
				break
			end
		end

		-- play effects
		self:PlayEffects( direction:Normalized() )

		-- knockback if not having spear buff
		if self:GetParent():HasModifier( "modifier_imba_mars_spear" ) then return end
		if self:GetParent():HasModifier( "modifier_imba_mars_spear_debuff" ) then return end

		self:GetParent():AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_generic_knockback_lua", -- modifier name
			{
				duration = self.knockback_duration,
				distance = self.width,
				height = 30,
				direction_x = direction.x,
				direction_y = direction.y,
			} -- kv
		)
	end
end

function modifier_imba_mars_arena_of_blood_spear_aura:OnRefresh( kv )
	
end

function modifier_imba_mars_arena_of_blood_spear_aura:OnRemoved()
end

function modifier_imba_mars_arena_of_blood_spear_aura:OnDestroy()
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_imba_mars_arena_of_blood_spear_aura:IsAura()
	return self.owner
end

function modifier_imba_mars_arena_of_blood_spear_aura:GetModifierAura()
	return "modifier_imba_mars_arena_of_blood_spear_aura"
end

function modifier_imba_mars_arena_of_blood_spear_aura:GetAuraRadius()
	return self.radius
end

function modifier_imba_mars_arena_of_blood_spear_aura:GetAuraDuration()
	return self.duration
end

function modifier_imba_mars_arena_of_blood_spear_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_mars_arena_of_blood_spear_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_mars_arena_of_blood_spear_aura:GetAuraSearchFlags()
	return 0
end
function modifier_imba_mars_arena_of_blood_spear_aura:GetAuraEntityReject( unit )
	if not IsServer() then return end

	-- check flying
	if unit:HasFlyMovementCapability() then return true end

	-- check vertical motion controlled
	if unit:IsCurrentlyVerticalMotionControlled() then return true end

	-- check if already own this aura
	if unit:FindModifierByNameAndCaster( "modifier_imba_mars_arena_of_blood_spear_aura", self:GetCaster() ) then
		return true
	end

	-- check distance
	local distance = (unit:GetOrigin()-self.aura_origin):Length2D()
	if (distance-self.spear_radius)<0 then
		return true
	end

	return false
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_mars_arena_of_blood_spear_aura:PlayEffects( direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_arena_of_blood_spear.vpcf"
	local sound_cast = "Hero_Mars.Phalanx.Attack"
	local sound_target = "Hero_Mars.Phalanx.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, self:GetParent() )
end

--------------------------------------------------------------------------------
modifier_imba_mars_arena_of_blood_thinker = modifier_imba_mars_arena_of_blood_thinker or class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_mars_arena_of_blood_thinker:IsHidden() return true end

--------------------------------------------------------------------------------

-- Initializations
function modifier_imba_mars_arena_of_blood_thinker:OnCreated( kv )
	-- references
	self.delay = self:GetAbility():GetVanillaAbilitySpecial( "formation_time" )
	self.duration = self:GetAbility():GetVanillaAbilitySpecial( "duration" )
	self.radius = self:GetAbility():GetVanillaAbilitySpecial( "radius" )

	if IsServer() then
		self.thinkers = {}

		-- Start interval
		self.phase_delay = true
		self:StartIntervalThink( self.delay )

		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_mars_arena_of_blood_coliseum_aura", {})

		-- play effects
		self:PlayEffects()
	end
end

function modifier_imba_mars_arena_of_blood_thinker:OnRemoved()
	if not IsServer() then return end
	-- stop effects
	local sound_stop = "Hero_Mars.ArenaOfBlood.End"
	local sound_loop = "Hero_Mars.ArenaOfBlood"

	EmitSoundOn( sound_stop, self:GetParent() )
	StopSoundOn( sound_loop, self:GetParent() )
end

function modifier_imba_mars_arena_of_blood_thinker:OnDestroy()
	if not IsServer() then return end

	-- destroy modifiers (somehow it does not automatically calls OnDestroy on modifiers)
	local modifiers = {}
	for k,v in pairs(self:GetParent():FindAllModifiers()) do
		modifiers[k] = v
	end
	for k,v in pairs(modifiers) do
		v:Destroy()
	end

	UTIL_Remove( self:GetParent() ) 
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_mars_arena_of_blood_thinker:OnIntervalThink()
	if self.phase_delay then
		self.phase_delay = false

		-- create vision
		AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), self.radius, self.duration, false)
		
		-- create wall aura
		self:GetParent():AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_imba_mars_arena_of_blood_wall_aura", -- modifier name
			{  } -- kv
		)

		-- create spear aura
		self:GetParent():AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_imba_mars_arena_of_blood_spear_aura", -- modifier name
			{  } -- kv
		)

		-- create spear aura
		self:GetParent():AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_imba_mars_arena_of_blood_projectile_aura", -- modifier name
			{  } -- kv
		)

		-- create phantom blockers
		self:SummonBlockers()

		-- play effects
		local sound_loop = "Hero_Mars.ArenaOfBlood"
		EmitSoundOn( sound_loop, self:GetParent() )

		-- add end duration
		self:StartIntervalThink( self.duration )
		self.phase_duration = true
		return
	end
	if self.phase_duration then
		self:Destroy()
		return
	end
end

function modifier_imba_mars_arena_of_blood_thinker:SummonBlockers()
	-- init data
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local teamnumber = caster:GetTeamNumber()
	local origin = self:GetParent():GetOrigin()
	local angle = 0
	local vector = origin + Vector(self.radius,0,0)
	local zero = Vector(0,0,0)
	local one = Vector(1,0,0)
	local count = 28

	local angle_diff = 360/count

	for i=0,count-1 do
		local location = RotatePosition( origin, QAngle( 0, angle_diff*i, 0 ), vector )
		local facing = RotatePosition( zero, QAngle( 0, 200+angle_diff*i, 0 ), one )

		-- callback after creation
		local callback = function( unit )
			unit:SetForwardVector( facing )
			unit:SetNeverMoveToClearSpace( true )

			-- add modifier
			unit:AddNewModifier(
				caster, -- player source
				self:GetAbility(), -- ability source
				"modifier_imba_mars_arena_of_blood_blocker", -- modifier name
				{
					duration = self.duration,
					model = i%2==0,
				} -- kv
			)
		end

		-- create unit async (to avoid high think time)
		local unit = CreateUnitByNameAsync(
			"npc_dota_imba_mars_arena_of_blood_soldier",
			location,
			false,
			caster,
			nil,
			caster:GetTeamNumber(),
			callback
		)
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_mars_arena_of_blood_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_arena_of_blood.vpcf"
	local sound_cast = "Hero_Mars.ArenaOfBlood.Start"
	-- Hero_Mars.Block_Projectile

	-- Get data
	-- colloseum radius = radius + 50
	local radius = self.radius + 50

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 2, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 3, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Play sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
modifier_imba_mars_arena_of_blood_wall_aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_mars_arena_of_blood_wall_aura:IsHidden() return true end
function modifier_imba_mars_arena_of_blood_wall_aura:IsDebuff() return true end
function modifier_imba_mars_arena_of_blood_wall_aura:IsPurgable() return false end
function modifier_imba_mars_arena_of_blood_wall_aura:IsPurgeException() return false end
function modifier_imba_mars_arena_of_blood_wall_aura:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_mars_arena_of_blood_wall_aura:OnCreated( kv )
	if not IsServer() then return end
	-- references
	-- normal limit inner ring = radius - 200
	-- zero limit inner ring = radius - 100
	-- zero limit outer ring = radius + 100
	-- normal limit outer ring = radius + 200

	self.radius = self:GetAbility():GetVanillaAbilitySpecial( "radius" )
	self.width = self:GetAbility():GetVanillaAbilitySpecial( "width" )

	self.twice_width = self.width*2
	self.aura_radius = self.radius + self.twice_width
	self.MAX_SPEED = 550
	self.MIN_SPEED = 1
	self.arena_offset = 200

	self.owner = kv.isProvidedByAura~=1

	if not self.owner then
		self.aura_origin = Vector( kv.aura_origin_x, kv.aura_origin_y, 0 )
	else
		self.aura_origin = self:GetParent():GetOrigin()
	end

	self.position = self:GetParent():GetAbsOrigin()

	-- Seems like CheckState() interavls aren't fast enough to prevent a sort of "glitchy" effect
	self:OnIntervalThink()
	self:StartIntervalThink(FrameTime())
end


function modifier_imba_mars_arena_of_blood_wall_aura:OnIntervalThink()
	if self:GetAuraOwner() then
		if (self:GetParent():GetAbsOrigin() - self:GetAuraOwner():GetAbsOrigin()):Length2D() > self.aura_radius - self.arena_offset and (self.position - self:GetParent():GetAbsOrigin()):Length2D() < self.aura_radius then
			FindClearSpaceForUnit(self:GetParent(), self:GetAuraOwner():GetAbsOrigin() + ((self:GetParent():GetAbsOrigin() - self:GetAuraOwner():GetAbsOrigin()):Normalized() * self.radius), false)
		end
		
		if (self:GetParent():GetAbsOrigin() - self:GetAuraOwner():GetAbsOrigin()):Length2D() <= self.aura_radius - self.arena_offset then
			self.position	= self:GetParent():GetAbsOrigin()
		end
	end
end

function modifier_imba_mars_arena_of_blood_wall_aura:OnRefresh( kv )
end

function modifier_imba_mars_arena_of_blood_wall_aura:OnRemoved()
end

function modifier_imba_mars_arena_of_blood_wall_aura:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_mars_arena_of_blood_wall_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

-- IMBAfication: Divine Call (impassable walls)
function modifier_imba_mars_arena_of_blood_wall_aura:CheckState()
	return {[MODIFIER_STATE_TETHERED] = true}
end

function modifier_imba_mars_arena_of_blood_wall_aura:GetModifierMoveSpeed_Limit( params )
	if not IsServer() then return end
	-- do nothing if owner
	if self.owner then return 0 end

	-- get data
	local parent_vector = self:GetParent():GetOrigin()-self.aura_origin
	local parent_direction = parent_vector:Normalized()

	-- calculate distance
	local actual_distance = parent_vector:Length2D()
	local wall_distance = actual_distance-self.radius
	local isInside = (wall_distance)<0
	wall_distance = math.min( math.abs( wall_distance ), self.twice_width )
	wall_distance = math.max( wall_distance, self.width ) - self.width -- clamped between 0 and width

	-- calculate facing angle
	local parent_angle = 0
	if isInside then
		parent_angle = VectorToAngles(parent_direction).y
	else
		parent_angle = VectorToAngles(-parent_direction).y
	end
	local unit_angle = self:GetParent():GetAnglesAsVector().y
	local wall_angle = math.abs( AngleDiff( parent_angle, unit_angle ) )

	-- calculate movespeed limit
	local limit = 0
	if wall_angle>90 then
		-- no limit if facing away
		limit = 0
	else
		-- interpolate between max
		limit = self:Interpolate( wall_distance/self.width, self.MIN_SPEED, self.MAX_SPEED )
	end

	return limit
end

--------------------------------------------------------------------------------
-- Helper
function modifier_imba_mars_arena_of_blood_wall_aura:Interpolate( value, min, max )
	return value*(max-min) + min
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_imba_mars_arena_of_blood_wall_aura:IsAura()
	return self.owner
end

function modifier_imba_mars_arena_of_blood_wall_aura:GetModifierAura()
	return "modifier_imba_mars_arena_of_blood_wall_aura"
end

function modifier_imba_mars_arena_of_blood_wall_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_mars_arena_of_blood_wall_aura:GetAuraDuration()
	return 0.3
end

function modifier_imba_mars_arena_of_blood_wall_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_mars_arena_of_blood_wall_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_mars_arena_of_blood_wall_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_imba_mars_arena_of_blood_wall_aura:GetAuraEntityReject( unit )
	if not IsServer() then return end

	-- check flying
	if unit:HasFlyMovementCapability() then return true end

	return false
end

modifier_imba_mars_arena_of_blood_scepter = modifier_imba_mars_arena_of_blood_scepter or class({})

function modifier_imba_mars_arena_of_blood_scepter:IsHidden() return true end
function modifier_imba_mars_arena_of_blood_scepter:IsPurgable() return false end
function modifier_imba_mars_arena_of_blood_scepter:IsDebuff() return false end
function modifier_imba_mars_arena_of_blood_scepter:IgnoreTenacity() return true end
function modifier_imba_mars_arena_of_blood_scepter:IsMotionController() return true end
function modifier_imba_mars_arena_of_blood_scepter:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_mars_arena_of_blood_scepter:OnCreated(keys)
	if not IsServer() then return end

	if self:GetAbility().scepter_cast_position then
		self.target_point = self:GetAbility().scepter_cast_position
	else
		-- fail-safe, shouldn't ever happen
		self.target_point = self:GetParent():GetAbsOrigin()
	end

	self.max_height = self:GetAbility():GetSpecialValueFor("scepter_max_height")

	-- Variables
	self.time_elapsed = 0
	self.leap_z = 0
	self.jump_speed = self:GetAbility():GetSpecialValueFor("scepter_jump_speed")

	self:GetParent():StartGesture(ACT_DOTA_CAST1_STATUE)

	-- Wait one frame to get the target point from the ability's OnSpellStart, then calculate distance
	Timers:CreateTimer(FrameTime(), function()
		self.distance = (self:GetParent():GetAbsOrigin() - self.target_point):Length2D()
		self.jump_time = self.distance / self.jump_speed
		self.direction = (self.target_point - self:GetParent():GetAbsOrigin()):Normalized()

		self:StartIntervalThink(FrameTime())
	end)
end

function modifier_imba_mars_arena_of_blood_scepter:OnIntervalThink()
	-- Check motion controllers
	if not self:CheckMotionControllers() then		
		self:Destroy()
		return nil
	end

	-- Vertical Motion
	self:VerticalMotion(self:GetParent(), FrameTime())

	-- Horizontal Motion
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_imba_mars_arena_of_blood_scepter:VerticalMotion(me, dt)
	if IsServer() then
		-- Check if we're still jumping
		if self.time_elapsed < self.jump_time then
			-- Check if we should be going up or down
			if self.time_elapsed <= self.jump_time / 2 then
				-- Going up
				self.leap_z = self.leap_z + 30

				self:GetParent():SetAbsOrigin(GetGroundPosition(self:GetParent():GetAbsOrigin(), self:GetParent()) + Vector(0,0,self.leap_z))
			else
				-- Going down
				self.leap_z = self.leap_z - 30
				if self.leap_z > 0 then
					self:GetParent():SetAbsOrigin(GetGroundPosition(self:GetParent():GetAbsOrigin(), self:GetParent()) + Vector(0,0,self.leap_z))
				end
			end
		end
	end
end

function modifier_imba_mars_arena_of_blood_scepter:HorizontalMotion(me, dt)
	if IsServer() then
		-- Check if we're still jumping
		self.time_elapsed = self.time_elapsed + dt

		if self.time_elapsed < self.jump_time then
			-- Go forward
			local new_location = self:GetParent():GetAbsOrigin() + self.direction * self.jump_speed * dt
			self:GetParent():SetAbsOrigin(new_location)
		else
			self:Destroy()
		end
	end
end

function modifier_imba_mars_arena_of_blood_scepter:OnDestroy()
	if not IsServer() then return end

	CreateModifierThinker(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_imba_mars_arena_of_blood_thinker", -- modifier name
		{  }, -- kv
		self.target_point,
		self:GetCaster():GetTeamNumber(),
		false
	)

	self:GetParent():SetUnitOnClearGround()
	self:GetParent():FadeGesture(ACT_DOTA_CAST1_STATUE)
end

--[[

-- Creator:
--	   AltiV, March 16th, 2019

LinkLuaModifier("modifier_imba_mars_arena_of_blood_enhance", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mars_arena_of_blood_thinker", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE)

imba_mars_arena_of_blood_enhance					= imba_mars_arena_of_blood_enhance or class({})
modifier_imba_mars_arena_of_blood_enhance			= modifier_imba_mars_arena_of_blood_enhance or class({})

modifier_imba_mars_arena_of_blood_thinker			= modifier_imba_mars_arena_of_blood_thinker or class({})

----------------------------
-- Arena of Blood ENHANCE --
----------------------------

function imba_mars_arena_of_blood_enhance:IsInnateAbility() return true end

function imba_mars_arena_of_blood_enhance:GetIntrinsicModifierName()
	return "modifier_imba_mars_arena_of_blood_enhance"
end

-------------------------------------
-- Arena of Blood ENHANCE Modifier --
-------------------------------------

function modifier_imba_mars_arena_of_blood_enhance:IsHidden()	return true end

function modifier_imba_mars_arena_of_blood_enhance:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_SCALE,
		
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
end

function modifier_imba_mars_arena_of_blood_enhance:GetModifierModelScale(keys)
	if self:GetParent():HasModifier("modifier_mars_arena_of_blood_animation") then
		return self:GetAbility():GetVanillaAbilitySpecial("expansion_pct")
	end
end

function modifier_imba_mars_arena_of_blood_enhance:OnAbilityFullyCast(keys)
	if keys.unit == self:GetParent() and keys.ability:GetName() == "mars_arena_of_blood" and keys.ability:GetCursorPosition() then
		local aura_thinker = CreateModifierThinker(
			self:GetCaster(),
			self:GetAbility(),
			"modifier_imba_mars_arena_of_blood_thinker",
			{
				duration			= keys.ability:GetVanillaAbilitySpecial("formation_time") + keys.ability:GetVanillaAbilitySpecial("duration"),
				ability_entindex	= keys.ability:entindex()
			},
			keys.ability:GetCursorPosition(),
			self:GetCaster():GetTeamNumber(),
			false
		)
	end
end

-----------------------------------------------
-- MODIFIER_IMBA_MARS_ARENA_OF_BLOOD_THINKER --
-----------------------------------------------

function modifier_imba_mars_arena_of_blood_thinker:OnCreated(keys)
	if not IsServer() then return end
	
	if keys.ability_entindex and EntIndexToHScript(keys.ability_entindex) then
		self.arena_ability	= EntIndexToHScript(keys.ability_entindex)
		
		self.duration		= self.arena_ability:GetVanillaAbilitySpecial("duration")
		self.radius			= self.arena_ability:GetVanillaAbilitySpecial("radius")
		self.width			= self.arena_ability:GetVanillaAbilitySpecial("width")
		self.formation_time	= self.arena_ability:GetVanillaAbilitySpecial("formation_time")
	else
		self:Destroy()
	end
end

function modifier_imba_mars_arena_of_blood_thinker:IsHidden()				return true end

function modifier_imba_mars_arena_of_blood_thinker:IsAura() 				return self.formation_time and self:GetElapsedTime() >= self.formation_time end
function modifier_imba_mars_arena_of_blood_thinker:IsAuraActiveOnDeath()	return false end

function modifier_imba_mars_arena_of_blood_thinker:GetAuraRadius()			return self.radius or 0 end
function modifier_imba_mars_arena_of_blood_thinker:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end

function modifier_imba_mars_arena_of_blood_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_mars_arena_of_blood_thinker:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_mars_arena_of_blood_thinker:GetModifierAura()		return "modifier_imba_mars_arena_of_blood_thinker_debuff" end

function modifier_imba_mars_arena_of_blood_thinker:GetAuraEntityReject(target)	return target:HasFlyMovementCapability() end

LinkLuaModifier("modifier_imba_mars_arena_of_blood_thinker_debuff", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE)

modifier_imba_mars_arena_of_blood_thinker_debuff	= modifier_imba_mars_arena_of_blood_thinker_debuff or class({})

------------------------------------------------------
-- MODIFIER_IMBA_MARS_ARENA_OF_BLOOD_THINKER_DEBUFF --
------------------------------------------------------

function modifier_imba_mars_arena_of_blood_thinker_debuff:IsHidden()	return true end

function modifier_imba_mars_arena_of_blood_thinker_debuff:OnCreated()
	if not IsServer() or not self:GetAuraOwner():HasModifier("modifier_imba_mars_arena_of_blood_thinker") then return end

	self.area_center	= self:GetAuraOwner():GetAbsOrigin()
	
	self.aura_modifier	= self:GetAuraOwner():FindModifierByName("modifier_imba_mars_arena_of_blood_thinker")
	
	if self.aura_modifier then
		self.duration		= self.aura_modifier.duration
		self.radius			= self.aura_modifier.radius
		self.width			= self.aura_modifier.width
		self.formation_time	= self.aura_modifier.formation_time
	else
		self:Destroy()
	end
end

-- IMBAfication: Ultra-Gravity
function modifier_imba_mars_arena_of_blood_thinker_debuff:CheckState()
	return {[MODIFIER_STATE_TETHERED] = true}
end

-- IMBAfication: Hardened Walls
function modifier_imba_mars_arena_of_blood_thinker_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_LIMIT}
end

function modifier_imba_mars_arena_of_blood_thinker_debuff:GetModifierMoveSpeed_Limit()
	if not IsServer() or not self:GetParent():IsMagicImmune() then return end
	
	-- A R B I T R A R Y   A N G L E
	if (self:GetParent():GetAbsOrigin() - self.area_center):Length2D() >= self.radius - self.width and math.abs(AngleDiff(VectorToAngles(self:GetParent():GetAbsOrigin() - self.area_center).y, VectorToAngles(self:GetParent():GetForwardVector() ).y)) <= 85 then
		return -0.01
	end
end
--]]
