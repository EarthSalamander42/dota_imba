-- Credits: Elfansoer.
-- Earthshaker Fissure luafied
-- Fissure: https://github.com/Elfansoer/dota-2-lua-abilities/blob/master/scripts/vscripts/lua_abilities/earthshaker_fissure_lua/earthshaker_fissure_lua.lua
-- Fissure: https://github.com/Elfansoer/dota-2-lua-abilities/blob/master/scripts/vscripts/lua_abilities/earthshaker_fissure_lua/modifier_earthshaker_fissure_lua_thinker.lua
-- Enchant Totem: https://github.com/Elfansoer/dota-2-lua-abilities/blob/master/scripts/vscripts/lua_abilities/earthshaker_enchant_totem_lua/earthshaker_enchant_totem_lua.lua
-- Enchant Totem: https://github.com/Elfansoer/dota-2-lua-abilities/blob/master/scripts/vscripts/lua_abilities/earthshaker_enchant_totem_lua/modifier_earthshaker_enchant_totem_lua.lua

earthshaker_fissure_lua = class({})
LinkLuaModifier( "modifier_earthshaker_fissure_lua_thinker", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_earthshaker_fissure_lua_prevent_movement", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE )

function earthshaker_fissure_lua:GetAbilityTextureName()
	if not IsClient() then return end
	if not self:GetCaster().arcana_style then return "earthshaker_fissure" end
	return "earthshaker_fissure_ti9"
end

--------------------------------------------------------------------------------
-- Ability Start
function earthshaker_fissure_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local damage = self:GetAbilityDamage()
	local distance = self:GetCastRange( point, caster ) + GetCastRangeIncrease(caster)
	local duration = self:GetSpecialValueFor("fissure_duration")
	local radius = self:GetSpecialValueFor("fissure_radius")
	local stun_duration = self:GetSpecialValueFor("stun_duration")

	-- generate data
	local block_width = 24
	local block_delta = 8.25

	if caster:HasTalent("special_bonus_unique_earthshaker_3") then
		distance = distance + caster:FindTalentValue("special_bonus_unique_earthshaker_3")
	end

	-- get wall vector
	local direction = point-caster:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	local wall_vector = direction * distance

	-- Create blocker along path
	local block_spacing = (block_delta+2*block_width)
	local blocks = distance/block_spacing
	local block_pos = caster:GetHullRadius() + block_delta + block_width
	local start_pos = caster:GetOrigin() + direction*block_pos

	for i=1,blocks do
		local block_vec = caster:GetOrigin() + direction*block_pos
		local blocker = CreateModifierThinker(
			caster, -- player source
			self, -- ability source
			"modifier_earthshaker_fissure_lua_thinker", -- modifier name
			{ duration = duration }, -- kv
			block_vec,
			caster:GetTeamNumber(),
			true
		)
		blocker:SetHullRadius( block_width )
		block_pos = block_pos + block_spacing
	end

	-- find units in line
	local end_pos = start_pos + wall_vector
	local units = FindUnitsInLine(
		caster:GetTeamNumber(),
		start_pos,
		end_pos,
		-- caster:GetOrigin() + direction*caster:GetHullRadius(),
		-- caster:GetOrigin() + direction*caster:GetHullRadius() + wall_vector,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}

	-- apply damage, shove and stun
	for _,unit in pairs(units) do
		-- shove
		FindClearSpaceForUnit( unit, unit:GetOrigin(), true )

		if unit:GetTeamNumber()~=caster:GetTeamNumber() then
			-- damage
			damageTable.victim = unit
			ApplyDamage(damageTable)

			-- stun
			local stun_modifier = unit:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_stunned", -- modifier name
				{ duration = stun_duration } -- kv
			)
			
			if stun_modifier then
				stun_modifier:SetDuration(stun_duration * (1 - unit:GetStatusResistance()), true)
			end
		end
	end

	-- Effects
	self:PlayEffects( start_pos, end_pos, duration )
end

--------------------------------------------------------------------------------
function earthshaker_fissure_lua:PlayEffects( start_pos, end_pos, duration )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_earthshaker/earthshaker_fissure.vpcf"
	local sound_cast = "Hero_EarthShaker.Fissure"

	-- generate data
	local caster = self:GetCaster()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( caster.fissure_pfx, PATTACH_WORLDORIGIN, caster )
--	local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, caster )
	ParticleManager:SetParticleControl( effect_cast, 0, start_pos )
	ParticleManager:SetParticleControl( effect_cast, 1, end_pos )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( duration, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( start_pos, sound_cast, caster )
	EmitSoundOnLocationWithCaster( end_pos, sound_cast, caster )
end

modifier_earthshaker_fissure_lua_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_earthshaker_fissure_lua_thinker:IsHidden()
	return true
end

function modifier_earthshaker_fissure_lua_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_earthshaker_fissure_lua_thinker:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_earthshaker_fissure_lua_thinker:OnIntervalThink()
	-- find units in line
	local units = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),
		nil,
		200,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false
	)

	-- Prevent units from moving if near fissure
	for _,unit in pairs(units) do
		unit:AddNewModifier(unit, self:GetAbility(), "modifier_earthshaker_fissure_lua_prevent_movement", {duration=0.1})
	end
end
--[[
function modifier_earthshaker_fissure_lua_thinker:OnRefresh( kv )
	
end
--]]
function modifier_earthshaker_fissure_lua_thinker:OnDestroy( kv )
	if IsServer() then
		-- Effects
		local sound_cast = "Hero_EarthShaker.FissureDestroy"
		EmitSoundOnLocationWithCaster(self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
		UTIL_Remove(self:GetParent())
	end
end


modifier_earthshaker_fissure_lua_prevent_movement = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_earthshaker_fissure_lua_prevent_movement:IsHidden()
	return true
end

function modifier_earthshaker_fissure_lua_prevent_movement:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_earthshaker_fissure_lua_prevent_movement:OnCreated()
	if IsServer() then
		self.movement_capability = 0

		if self:GetParent():HasGroundMovementCapability() then
			self.movement_capability = 1
		elseif self:GetParent():HasFlyMovementCapability() then
			self.movement_capability = 2
		end

		self:GetParent():SetMoveCapability(0)
	end
end

function modifier_earthshaker_fissure_lua_prevent_movement:OnDestroy( kv )
	if IsServer() then
		self:GetParent():SetMoveCapability(self.movement_capability)
	end
end

earthshaker_enchant_totem_lua = class({})
LinkLuaModifier( "modifier_earthshaker_enchant_totem_lua", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_earthshaker_enchant_totem_lua_movement", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function earthshaker_enchant_totem_lua:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT
	end

	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function earthshaker_enchant_totem_lua:GetCastRange(vLocation, hTarget)
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("distance_scepter")
	end

	return self.BaseClass.GetCastRange(self, vLocation, hTarget)
end

function earthshaker_enchant_totem_lua:GetCooldown(nLevel)
	return self.BaseClass.GetCooldown(self, nLevel) - self:GetCaster():FindTalentValue("special_bonus_unique_earthshaker")
end

function earthshaker_enchant_totem_lua:CastFilterResultTarget( target )
	if IsServer() then
		if self:GetCaster():HasScepter() then
			if target ~= nil then
				if self:GetCaster():GetTeamNumber() == target:GetTeamNumber() and self:GetCaster() ~= target then
					return UF_FAIL_FRIENDLY				
				end
			end
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function earthshaker_enchant_totem_lua:GetCustomCastErrorTarget(target)
	return "dota_hud_error_cant_cast_on_ally"
end

function earthshaker_enchant_totem_lua:OnAbilityPhaseStart()
	if self:GetCaster():HasScepter() and self:GetCaster() ~= self:GetCursorTarget() then
		self:SetOverrideCastPoint(0)
	end

	return true
end

-- Ability Start
function earthshaker_enchant_totem_lua:OnSpellStart()
	if IsClient() then return end

	if self:GetCastPoint() == 0 then
		self:SetOverrideCastPoint(GetAbilityKV("earthshaker_enchant_totem_lua", "AbilityCastPoint"))
	end

	if self:GetCaster():HasScepter() and self:GetCaster() ~= self:GetCursorTarget() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_earthshaker_enchant_totem_lua_movement", {duration = self:GetSpecialValueFor("duration")})
	else
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_earthshaker_enchant_totem_lua", {duration = self:GetDuration()})
	end
end

modifier_earthshaker_enchant_totem_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_earthshaker_enchant_totem_lua:IsHidden()
	return false
end

function modifier_earthshaker_enchant_totem_lua:IsDebuff()
	return false
end

function modifier_earthshaker_enchant_totem_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_earthshaker_enchant_totem_lua:OnCreated( kv )
	-- references
	self.bonus = self:GetAbility():GetSpecialValueFor( "totem_damage_percentage" ) -- special value
	if IsServer() then
		self:PlayEffects()
	end
end

function modifier_earthshaker_enchant_totem_lua:OnRefresh( kv )
	-- references
	self.bonus = self:GetAbility():GetSpecialValueFor( "totem_damage_percentage" ) -- special value
end

function modifier_earthshaker_enchant_totem_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_earthshaker_enchant_totem_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
--		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_earthshaker_enchant_totem_lua:GetActivityTranslationModifiers()
	return "enchant_totem"
end

-- disabled
function modifier_earthshaker_enchant_totem_lua:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function modifier_earthshaker_enchant_totem_lua:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus
end

function modifier_earthshaker_enchant_totem_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		EmitSoundOn( "Hero_EarthShaker.Totem.Attack", params.target )

		self:Destroy()
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_earthshaker_enchant_totem_lua:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_earthshaker_enchant_totem_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_earthshaker/earthshaker_totem_buff.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )

	local attach = "attach_attack1"
	if self:GetCaster():ScriptLookupAttachment( "attach_totem" )~=0 then attach = "attach_totem" end
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		attach,
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	EmitSoundOn("Hero_EarthShaker.Totem", self:GetCaster())
end

modifier_earthshaker_enchant_totem_lua_movement = modifier_earthshaker_enchant_totem_lua_movement or class({})

function modifier_earthshaker_enchant_totem_lua_movement:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_earthshaker_enchant_totem_lua_movement:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_earthshaker_enchant_totem_lua_movement:RemoveOnDeath()
	return false
end

function modifier_earthshaker_enchant_totem_lua_movement:IsHidden()
	return true
end

function modifier_earthshaker_enchant_totem_lua_movement:IgnoreTenacity()
	return true
end

function modifier_earthshaker_enchant_totem_lua_movement:IsMotionController()
	return true
end

function modifier_earthshaker_enchant_totem_lua_movement:GetMotionControllerPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM
end

-- Without this Tiny can fly to world origin with Hellblade transfer
function modifier_earthshaker_enchant_totem_lua_movement:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_earthshaker_enchant_totem_lua_movement:OnCreated()
	self.enchant_totem_minimum_height_above_lowest = 1000
	self.enchant_totem_minimum_height_above_highest = 300
	self.enchant_totem_acceleration_z = 8000
	self.enchant_totem_max_horizontal_acceleration = 5000

	if IsServer() then
		self.vStartPosition = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
		self.flCurrentTimeHoriz = 0.0
		self.flCurrentTimeVert = 0.0

		self.vLastKnownTargetPos = self:GetAbility():GetCursorPosition()

		local duration = self:GetAbility():GetSpecialValueFor( "duration" )
		local flDesiredHeight = self.enchant_totem_minimum_height_above_lowest * duration * duration
		local flLowZ = math.min( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flHighZ = math.max( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flArcTopZ = math.max( flLowZ + flDesiredHeight, flHighZ + self.enchant_totem_minimum_height_above_highest )

		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt( 2.0 * flArcDeltaZ * self.enchant_totem_acceleration_z )

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt( math.max( 0, ( self.flInitialVelocityZ * self.flInitialVelocityZ ) - 2.0 * self.enchant_totem_acceleration_z * flDeltaZ ) )
		self.flPredictedTotalTime = math.max( ( self.flInitialVelocityZ + flSqrtDet) / self.enchant_totem_acceleration_z, ( self.flInitialVelocityZ - flSqrtDet) / self.enchant_totem_acceleration_z )
		print(self.flPredictedTotalTime)
--		self.flPredictedTotalTime = 0.5

		self.vHorizontalVelocity = ( self.vLastKnownTargetPos - self.vStartPosition ) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0

		self:StartIntervalThink(FrameTime())
	end
end

function modifier_earthshaker_enchant_totem_lua_movement:OnIntervalThink()
	if IsServer() then
		-- Check for motion controllers
		if not self:CheckMotionControllers() then
			self:Destroy()
			return nil
		end

		-- Horizontal motion
		self:HorizontalMotion(self:GetParent(), FrameTime())

		-- Vertical motion
		self:VerticalMotion(self:GetParent(), FrameTime())
	end
end

function modifier_earthshaker_enchant_totem_lua_movement:EnchantTotemLand()
	if IsServer() then
		-- If the enchant_totem was already completed, do nothing
		if self.enchant_totem_land_commenced then
			return nil
		end

		-- Mark enchant_totem as completed
		self.enchant_totem_land_commenced = true

		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_earthshaker_enchant_totem_lua", {duration = self:GetAbility():GetDuration()})
		EmitSoundOn("Hero_EarthShaker.Totem", self:GetParent())

		self:GetParent():SetUnitOnClearGround()
		ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 150)

--		Timers:CreateTimer(FrameTime(), function()
--			ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 150)
--		end)
	end
end

function modifier_earthshaker_enchant_totem_lua_movement:OnDestroy()
	if IsServer() then
		self:GetParent():SetUnitOnClearGround()
		self:EnchantTotemLand()
	end
end

--------------------------------------------------------------------------------

function modifier_earthshaker_enchant_totem_lua_movement:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_earthshaker_enchant_totem_lua_movement:GetActivityTranslationModifiers()
	return "ultimate_scepter"
end

function modifier_earthshaker_enchant_totem_lua_movement:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_2
end

function modifier_earthshaker_enchant_totem_lua_movement:GetEffectName()
	return "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf"
end

function modifier_earthshaker_enchant_totem_lua_movement:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end

--------------------------------------------------------------------------------

function modifier_earthshaker_enchant_totem_lua_movement:HorizontalMotion( me, dt )
	if IsServer() then
		-- If the unit being enchant_totemed died, interrupt motion controllers and remove self (nah lul)
		-- if not self:GetParent():IsAlive() then
			-- self:GetParent():InterruptMotionControllers(true)
			-- self:Destroy()
		-- end

		self.flCurrentTimeHoriz = math.min( self.flCurrentTimeHoriz + dt, self.flPredictedTotalTime )
		local t = self.flCurrentTimeHoriz / self.flPredictedTotalTime
		local vStartToTarget = self.vLastKnownTargetPos - self.vStartPosition
		local vDesiredPos = self.vStartPosition + t * vStartToTarget

		local vOldPos = me:GetOrigin()
		local vToDesired = vDesiredPos - vOldPos
		vToDesired.z = 0.0
		local vDesiredVel = vToDesired / dt
		local vVelDif = vDesiredVel - self.vHorizontalVelocity
		local flVelDif = vVelDif:Length2D()
		vVelDif = vVelDif:Normalized()
		local flVelDelta = math.min( flVelDif, self.enchant_totem_max_horizontal_acceleration )

		self.vHorizontalVelocity = self.vHorizontalVelocity + vVelDif * flVelDelta * dt
		local vNewPos = vOldPos + self.vHorizontalVelocity * dt
		me:SetOrigin( vNewPos )
	end
end

function modifier_earthshaker_enchant_totem_lua_movement:VerticalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = ( -self.enchant_totem_acceleration_z * self.flCurrentTimeVert + self.flInitialVelocityZ ) < 0

		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + ( -0.5 * self.enchant_totem_acceleration_z * ( self.flCurrentTimeVert * self.flCurrentTimeVert ) + self.flInitialVelocityZ * self.flCurrentTimeVert )

		local flGroundHeight = GetGroundHeight( vNewPos, self:GetParent() )

		me:SetOrigin( vNewPos )
	end
end

LinkLuaModifier( "modifier_earthshaker_arcana", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE )

-- Arcana animation handler
modifier_earthshaker_arcana = modifier_earthshaker_arcana or class ({})

function modifier_earthshaker_arcana:RemoveOnDeath()
	return false
end

function modifier_earthshaker_arcana:IsHidden()
	return false
end

function modifier_earthshaker_arcana:OnCreated()
	if IsServer() then
		
	end
end
