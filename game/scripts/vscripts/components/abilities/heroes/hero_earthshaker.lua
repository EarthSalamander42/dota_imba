-- Editor:
--	   AltiV, February 20th, 2020

-- Much of the original logic was derived from Elfansoer; I will leave the lua abilities intact below as reference, but somewhat copy these into imba classes for better consistency

LinkLuaModifier("modifier_imba_earthshaker_fissure_thinker", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_earthshaker_enchant_totem", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_earthshaker_enchant_totem_leap", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE)

imba_earthshaker_fissure							= imba_earthshaker_fissure or class({})
modifier_imba_earthshaker_fissure_thinker			= modifier_imba_earthshaker_fissure_thinker or class({})

imba_earthshaker_enchant_totem						= imba_earthshaker_enchant_totem or class({})
modifier_imba_earthshaker_enchant_totem				= modifier_imba_earthshaker_enchant_totem or class({})
modifier_imba_earthshaker_enchant_totem_leap		= modifier_imba_earthshaker_enchant_totem_leap or class({})


------------------------------
-- IMBA_EARTHSHAKER_FISSURE --
------------------------------

-- Credits: Elfansoer.
-- Earthshaker Fissure luafied
-- Fissure: https://github.com/Elfansoer/dota-2-lua-abilities/blob/master/scripts/vscripts/lua_abilities/earthshaker_fissure_lua/earthshaker_fissure_lua.lua
-- Fissure: https://github.com/Elfansoer/dota-2-lua-abilities/blob/master/scripts/vscripts/lua_abilities/earthshaker_fissure_lua/modifier_earthshaker_fissure_lua_thinker.lua
-- Enchant Totem: https://github.com/Elfansoer/dota-2-lua-abilities/blob/master/scripts/vscripts/lua_abilities/earthshaker_enchant_totem_lua/earthshaker_enchant_totem_lua.lua
-- Enchant Totem: https://github.com/Elfansoer/dota-2-lua-abilities/blob/master/scripts/vscripts/lua_abilities/earthshaker_enchant_totem_lua/modifier_earthshaker_enchant_totem_lua.lua

earthshaker_fissure_lua = class({})

LinkLuaModifier( "modifier_earthshaker_fissure_lua_thinker", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_earthshaker_fissure_lua_prevent_movement", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function earthshaker_fissure_lua:OnSpellStart()
	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

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
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
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

		if unit:GetTeamNumber()~=caster:GetTeamNumber() and not unit:IsMagicImmune() then
			-- damage
			damageTable.victim = unit
			ApplyDamage(damageTable)

			-- stun
			unit:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_stunned", -- modifier name
				{ duration = stun_duration * (1 - unit:GetStatusResistance()) } -- kv
			)
		end
	end

	-- Effects
	self:PlayEffects( start_pos, end_pos, duration )
end

--------------------------------------------------------------------------------
function earthshaker_fissure_lua:PlayEffects( start_pos, end_pos, duration )
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_ti9/earthshaker_fissure_ti9.vpcf", PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster())
	ParticleManager:SetParticleControl( effect_cast, 0, start_pos )
	ParticleManager:SetParticleControl( effect_cast, 1, end_pos )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( duration, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( start_pos, "Hero_EarthShaker.Fissure", self:GetCaster())
	EmitSoundOnLocationWithCaster( end_pos, "Hero_EarthShaker.Fissure", self:GetCaster())
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

	-- -- Prevent units from moving if near fissure
	-- for _,unit in pairs(units) do
		-- unit:AddNewModifier(unit, self:GetAbility(), "modifier_earthshaker_fissure_lua_prevent_movement", {duration=0.1})
	-- end
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
		if not self:GetParent():IsHero() and not self:GetParent():IsControllableByAnyPlayer() then
			self.movement_capability = 0

			if self:GetParent():HasGroundMovementCapability() then
				self.movement_capability = 1
			elseif self:GetParent():HasFlyMovementCapability() then
				self.movement_capability = 2
			end

			self:GetParent():SetMoveCapability(0)
		end
	end
end

function modifier_earthshaker_fissure_lua_prevent_movement:OnDestroy( kv )
	if IsServer() and self.movement_capability then
		self:GetParent():SetMoveCapability(self.movement_capability)
	end
end

earthshaker_enchant_totem_lua = class({})
LinkLuaModifier( "modifier_earthshaker_enchant_totem_lua", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_earthshaker_enchant_totem_lua_movement", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_earthshaker_enchant_totem_lua_leap", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_BOTH )
-- LinkLuaModifier( "modifier_earthshaker_enchant_totem_lua_leap", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE )

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

-- function earthshaker_enchant_totem_lua:CastFilterResultTarget( target )
	-- if IsServer() then
		-- if self:GetCaster():HasScepter() and target == self:GetCaster() then
			-- return UF_SUCCESS
		-- end

		-- local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		-- return nResult
	-- end
-- end

-- function earthshaker_enchant_totem_lua:GetCustomCastErrorTarget(target)
	-- return "dota_hud_error_cant_cast_on_ally"
-- end


function earthshaker_enchant_totem_lua:CastFilterResultLocation(vLocation)
	if self:GetCaster():HasScepter() and self:GetCaster():IsRooted() then
		return UF_FAIL_CUSTOM
	end
end

function earthshaker_enchant_totem_lua:GetCustomCastErrorLocation(vLocation)
	return "dota_hud_error_ability_disabled_by_root"
end

function earthshaker_enchant_totem_lua:CastFilterResultTarget(target)
	if target ~= self:GetCaster() then
		return UF_FAIL_OBSTRUCTED
	end
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
		-- Doesn't seem to work?
		self:GetCaster():FaceTowards(self:GetCursorPosition())
	
		-- local modifier_movement_handler = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_earthshaker_enchant_totem_lua_movement", {})
		local modifier_movement_handler = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_earthshaker_enchant_totem_lua_leap",
			{
				duration	= 1,
				x			= self:GetCursorPosition().x,
				y			= self:GetCursorPosition().y,
				z			= self:GetCursorPosition().z,
			})

		if modifier_movement_handler then
			modifier_movement_handler.target_point = self:GetCursorPosition()
		end
	else
		EmitSoundOn("Hero_EarthShaker.Totem", self:GetCaster())
	
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_earthshaker_enchant_totem_lua", {duration = self:GetDuration()})

		if self:GetCaster():HasScepter() then
			if self:GetCaster():HasModifier("modifier_earthshaker_aftershock_lua") then
				self:GetCaster():FindModifierByName("modifier_earthshaker_aftershock_lua"):CastAftershock()
			end
		end
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
	self.bonus_attack_range	= self:GetAbility():GetSpecialValueFor("bonus_attack_range")
	
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
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
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

function modifier_earthshaker_enchant_totem_lua:GetModifierAttackRangeBonus()
	return self.bonus_attack_range
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
	local particle_cast = self:GetParent().enchant_totem_buff_pfx or "particles/units/heroes/hero_earthshaker/earthshaker_totem_buff.vpcf"

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

	local effect_cast = ParticleManager:CreateParticle( self:GetParent().enchant_totem_cast_pfx or "particles/units/heroes/hero_earthshaker/earthshaker_totem_cast.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:ReleaseParticleIndex(effect_cast)
end

modifier_earthshaker_enchant_totem_lua_movement = modifier_earthshaker_enchant_totem_lua_movement or class({})

function modifier_earthshaker_enchant_totem_lua_movement:IsHidden() return true end
function modifier_earthshaker_enchant_totem_lua_movement:IsPurgable() return false end
function modifier_earthshaker_enchant_totem_lua_movement:IsDebuff() return false end
function modifier_earthshaker_enchant_totem_lua_movement:IgnoreTenacity() return true end
function modifier_earthshaker_enchant_totem_lua_movement:IsMotionController() return true end
function modifier_earthshaker_enchant_totem_lua_movement:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_earthshaker_enchant_totem_lua_movement:RemoveOnDeath() return false end

--------------------------------------------------------------------------------

function modifier_earthshaker_enchant_totem_lua_movement:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.scepter_height = self.ability:GetSpecialValueFor("scepter_height")

	if IsServer() then
		self.blur_effect = ParticleManager:CreateParticle( self:GetParent().enchant_totem_leap_blur_pfx or "particles/units/heroes/hero_earthshaker/earthshaker_totem_leap_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

		-- Variables
		self.time_elapsed = 0
		self.leap_z = 0

		Timers:CreateTimer(FrameTime(), function()
			self.jump_time = self.ability:GetSpecialValueFor("duration")
			self.direction = (self.target_point - self.caster:GetAbsOrigin()):Normalized()
			local distance = (self.caster:GetAbsOrigin() - self.target_point):Length2D()
			self.jump_speed = distance / self.jump_time
			self:StartIntervalThink(FrameTime())
		end)
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

		if self.blur_effect then
			ParticleManager:DestroyParticle(self.blur_effect, false)
			ParticleManager:ReleaseParticleIndex(self.blur_effect)
		end

		-- Mark enchant_totem as completed
		self.enchant_totem_land_commenced = true

		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_earthshaker_enchant_totem_lua", {duration = self:GetAbility():GetDuration()})
		EmitSoundOn("Hero_EarthShaker.Totem", self:GetParent())

		self:GetParent():SetUnitOnClearGround()
		ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 150)

		-- Here it is
		if self:GetParent():HasModifier("modifier_earthshaker_aftershock_lua") then
			self:GetParent():FindModifierByName("modifier_earthshaker_aftershock_lua"):CastAftershock()
		end

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

-- add "ultimate_scepter" + "enchant_totem_leap_from_battle"
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
		-- Check if we're still jumping
		self.time_elapsed = self.time_elapsed + dt
		if self.time_elapsed < self.jump_time then

			-- Go forward
			local new_location = self.caster:GetAbsOrigin() + self.direction * self.jump_speed * dt
			self.caster:SetAbsOrigin(new_location)
		else
			self:Destroy()
		end
	end
end

function modifier_earthshaker_enchant_totem_lua_movement:VerticalMotion( me, dt )
	if IsServer() then
		-- Check if we're still jumping
		if self.time_elapsed < self.jump_time then

			-- Check if we should be going up or down
			if self.time_elapsed <= self.jump_time / 2 then
				-- Going up
				self.leap_z = self.leap_z + 60

				self.caster:SetAbsOrigin(GetGroundPosition(self.caster:GetAbsOrigin(), self.caster) + Vector(0,0,self.leap_z))
			else
				-- Going down
				self.leap_z = self.leap_z - 60
				if self.leap_z > 0 then
					self.caster:SetAbsOrigin(GetGroundPosition(self.caster:GetAbsOrigin(), self.caster) + Vector(0,0,self.leap_z))
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- This still needs a LOT of ironing out (w.r.t proper vertical orientation and proper movement interrupt logic), but at its core it's passable
modifier_earthshaker_enchant_totem_lua_leap	= class({})

function modifier_earthshaker_enchant_totem_lua_leap:IsHidden()	return true end

function modifier_earthshaker_enchant_totem_lua_leap:OnCreated( params )
	if not IsServer() then return end

	self.destination	= Vector(params.x, params.y, params.z)
	self.vector			= (self.destination - self:GetParent():GetAbsOrigin())
	self.direction		= self.vector:Normalized()
	self.speed			= self.vector:Length2D() / self:GetDuration()

	if self:ApplyVerticalMotionController() == false then 
		self:Destroy()
	end
	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
	end
	
	self.interval	= FrameTime()
	
	self:StartIntervalThink(self.interval)
end

function modifier_earthshaker_enchant_totem_lua_leap:OnIntervalThink()
	local z_axis = (-1) * self:GetElapsedTime() * (self:GetElapsedTime() - self:GetDuration()) * 562 * 4
	
	-- self:GetParent():SetOrigin( GetGroundPosition(self:GetParent():GetOrigin(), nil) + Vector(0, 0, z_axis) )

	-- -- Okay so IDK how to check if Earthshaker is stunned to interrupt this, without catching the stun that this modifier itself provides...
	-- if self:GetParent():IsStunned() or self:GetParent():IsRooted() then
		-- self.aftershock_interrupt = true
		-- self:Destroy()
		-- return
	-- end

	self:GetParent():SetOrigin( (self:GetParent():GetOrigin() * Vector(1, 1, 0)) + (((self.direction * self.speed * self.interval) * Vector(1, 1, 0)) + (Vector(0, 0, GetGroundHeight(self:GetParent():GetOrigin(), nil)) + Vector(0, 0, z_axis) )))
end

function modifier_earthshaker_enchant_totem_lua_leap:OnDestroy( kv )
	if not IsServer() then return end
	
	self:GetParent():InterruptMotionControllers( true )
	
	-- "However, getting hit by forced movement causes the ability to not apply Aftershock or the totem buff upon landing."
	if not self.aftershock_interrupt then
		EmitSoundOn("Hero_EarthShaker.Totem", self:GetCaster())
	
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_earthshaker_enchant_totem_lua", {duration = self:GetAbility():GetDuration()})
		
		if self:GetParent():HasModifier("modifier_earthshaker_aftershock_lua") then
			self:GetParent():FindModifierByName("modifier_earthshaker_aftershock_lua"):CastAftershock()
		end
	end
end

function modifier_earthshaker_enchant_totem_lua_leap:UpdateHorizontalMotion( me, dt )
	-- self:GetParent():SetOrigin( self:GetParent():GetOrigin() + (self.direction * self.speed * dt) )
end

function modifier_earthshaker_enchant_totem_lua_leap:OnHorizontalMotionInterrupted()
	if IsServer() and self:GetRemainingTime() > 0 then
		self.aftershock_interrupt = true
	end
end

function modifier_earthshaker_enchant_totem_lua_leap:OnVerticalMotionInterrupted()
	if IsServer() then
		self.aftershock_interrupt = true
		self:Destroy()
	end
end

-- "The leap duration is always the same, so the speed adapts based on the targeted distance. The leap height is always 562 range."
-- I'm forgetting all my parabola math, but multiplying height by 4 here sets it as the max height at mid-point; there's obviously a formula for this
function modifier_earthshaker_enchant_totem_lua_leap:UpdateVerticalMotion( me, dt )
	-- local z_axis = (-1) * self:GetElapsedTime() * (self:GetElapsedTime() - self:GetDuration()) * 562 * 4
	
	-- self:GetParent():SetOrigin( GetGroundPosition(self:GetParent():GetOrigin(), nil) + Vector(0, 0, z_axis) )
end

function modifier_earthshaker_enchant_totem_lua_leap:OnVerticalMotionInterrupted()
	-- if IsServer() then
		-- self:Destroy()
	-- end
end

function modifier_earthshaker_enchant_totem_lua_leap:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

-- add "ultimate_scepter" + "enchant_totem_leap_from_battle"
function modifier_earthshaker_enchant_totem_lua_leap:GetActivityTranslationModifiers()
	return "ultimate_scepter"
end

function modifier_earthshaker_enchant_totem_lua_leap:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_2
end

function modifier_earthshaker_enchant_totem_lua_leap:GetEffectName()
	return "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf"
end

function modifier_earthshaker_enchant_totem_lua_leap:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_earthshaker_aftershock_lua", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE )

earthshaker_aftershock_lua = class({})

--------------------------------------------------------------------------------
-- Passive Modifier
function earthshaker_aftershock_lua:GetIntrinsicModifierName()
	return "modifier_earthshaker_aftershock_lua"
end

modifier_earthshaker_aftershock_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_earthshaker_aftershock_lua:IsHidden()
	return true
end

function modifier_earthshaker_aftershock_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_earthshaker_aftershock_lua:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "aftershock_range" ) -- special value

	if IsServer() then
		local damage = self:GetAbility():GetAbilityDamage() -- special value
		self.duration = self:GetAbility():GetDuration() -- special value

		-- precache damage
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}
	end
end

function modifier_earthshaker_aftershock_lua:OnRefresh( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "aftershock_range" ) -- special value

	if IsServer() then
		local damage = self:GetAbility():GetAbilityDamage() -- special value
		self.duration = self:GetAbility():GetDuration() -- special value

		self.damageTable.damage = damage
	end
end

function modifier_earthshaker_aftershock_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_earthshaker_aftershock_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_earthshaker_aftershock_lua:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit ~= self:GetParent() or params.ability:IsItem() then return end

		print(params.ability:GetAbilityName())

		-- Handle that manually + prevent casting aftershock when channeling outpost
		if self:GetParent():HasScepter() and params.ability:GetAbilityName() == "earthshaker_enchant_totem_lua" or params.ability:GetAbilityName() == "ability_capture" then
			return
		end

		self:CastAftershock()
	end
end

function modifier_earthshaker_aftershock_lua:CastAftershock()
	-- Find enemies in radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- apply stun and damage
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(
			self:GetParent(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self.duration * (1 - enemy:GetStatusResistance()) } -- kv
		)

		self.damageTable.victim = enemy
		ApplyDamage(self.damageTable)
	end

	-- Effects
	Timers:CreateTimer(FrameTime(), function()
		self:PlayEffects()
	end)
end

function modifier_earthshaker_aftershock_lua:PlayEffects()
	-- Get Resources
	local particle_cast = self:GetParent().aftershock_pfx or "particles/units/heroes/hero_earthshaker/earthshaker_aftershock.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

---------------
-- ECHO SLAM --
---------------

imba_earthshaker_echo_slam	= class({})

function imba_earthshaker_echo_slam:OnSpellStart()
	-- First part checks for how many heroes are around for appropriate sounds/responses
	local hero_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("echo_slam_damage_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	if #hero_enemies > 0 then
		self:GetCaster():EmitSound("Hero_EarthShaker.EchoSlam")
	else
		self:GetCaster():EmitSound("Hero_EarthShaker.EchoSlamSmall")
	end

	-- The hero response is a bit delayed
	Timers:CreateTimer(0.5, function()
		if self:GetCaster():GetName() == "npc_dota_hero_earthshaker" then
			if #hero_enemies == 2 then
				local random_response	= RandomInt(1, 4)
				
				-- Plays lines 1-2 or lines 4-5
				if random_response >= 3 then random_response = random_response + 1 end
				
				self:GetCaster():EmitSound("earthshaker_erth_ability_echo_0"..random_response)
			elseif #hero_enemies >= 3 then
				self:GetCaster():EmitSound("earthshaker_erth_ability_echo_03")
			elseif #hero_enemies == 0 then
				self:GetCaster():EmitSound("earthshaker_erth_ability_echo_0"..(RandomInt(6, 7)))
			end
		end
	end)

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("echo_slam_damage_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	local effect_counter = 0

	for _, enemy in pairs(enemies) do		
		local damageTable = {
			victim 			= enemy,
			damage 			= self:GetSpecialValueFor("echo_slam_initial_damage"),
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}
		
		ApplyDamage(damageTable)
		
		local echo_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), enemy:GetAbsOrigin(), nil, self:GetSpecialValueFor("echo_slam_echo_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
		for _, echo_enemy in pairs(echo_enemies) do
			if echo_enemy ~= enemy then
				echo_enemy:EmitSound("Hero_EarthShaker.EchoSlamEcho")
			
				local projectile =
				{
					Target 				= echo_enemy,
					Source 				= enemy,
					Ability 			= self,
					EffectName 			= self:GetCaster().echo_slam_pfx or "particles/units/heroes/hero_earthshaker/earthshaker_echoslam.vpcf",
					iMoveSpeed			= 600,
					vSourceLoc 			= enemy:GetAbsOrigin(),
					bDrawsOnMinimap 	= false,
					bDodgeable 			= false,
					bIsAttack 			= false,
					bVisibleToEnemies 	= true,
					bReplaceExisting 	= false,
					flExpireTime 		= GameRules:GetGameTime() + 10.0,
					bProvidesVision 	= false,

					ExtraData = {
						damage = self:GetTalentSpecialValueFor("echo_slam_echo_damage")
					}
				}

				ProjectileManager:CreateTrackingProjectile(projectile)

				-- Real heroes make two echoes
				if echo_enemy:IsRealHero() then
					effect_counter = effect_counter + 1
					ProjectileManager:CreateTrackingProjectile(projectile)

					Timers:CreateTimer(0.1, function()
						local echo_slam_death_pfx = ParticleManager:CreateParticle(self:GetCaster().echo_slam_tgt_pfx or "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_tgt.vpcf", PATTACH_ABSORIGIN, echo_enemy)
						ParticleManager:SetParticleControl(echo_slam_death_pfx, 6, Vector(math.min(effect_counter, 1), math.min(effect_counter, 1), math.min(effect_counter, 1)))
						ParticleManager:SetParticleControl(echo_slam_death_pfx, 10, Vector(4, 0, 0)) -- earth particle duration
						ParticleManager:ReleaseParticleIndex(echo_slam_death_pfx)
					end)
				end
			end
		end
	end

	local echo_slam_particle = ParticleManager:CreateParticle(self:GetCaster().echo_slam_start_pfx or "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(echo_slam_particle, 10, Vector(4, 0, 0)) -- earth particle duration
	ParticleManager:SetParticleControl(echo_slam_particle, 11, Vector(math.min(effect_counter, 1), math.min(effect_counter, 1), 0 )) -- enable ring with symbols
	ParticleManager:ReleaseParticleIndex(echo_slam_particle)
end

function imba_earthshaker_echo_slam:OnProjectileHit_ExtraData(target, location, data)
	if not IsServer() then return end
	
	if target and not target:IsMagicImmune() then
		local damageTable = {
			victim 			= target,
			damage 			= data.damage,
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}
		
		ApplyDamage(damageTable)
	end
end

--------------------------------------------------------------------------------

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

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_unique_earthshaker", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_earthshaker_bonus_magic_resistance", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_unique_earthshaker			= class({})
modifier_special_bonus_imba_earthshaker_bonus_magic_resistance	= modifier_special_bonus_imba_earthshaker_bonus_magic_resistance or class({})

function modifier_special_bonus_unique_earthshaker:IsHidden() 		return true end
function modifier_special_bonus_unique_earthshaker:IsPurgable() 	return false end
function modifier_special_bonus_unique_earthshaker:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_earthshaker_bonus_magic_resistance:IsHidden() 		return true end
function modifier_special_bonus_imba_earthshaker_bonus_magic_resistance:IsPurgable() 	return false end
function modifier_special_bonus_imba_earthshaker_bonus_magic_resistance:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_earthshaker_bonus_magic_resistance:OnCreated()
	self.magic_resistance = self:GetParent():FindTalentValue("special_bonus_imba_earthshaker_bonus_magic_resistance")
end

function modifier_special_bonus_imba_earthshaker_bonus_magic_resistance:DeclareFunctions()
    return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end

function modifier_special_bonus_imba_earthshaker_bonus_magic_resistance:GetModifierMagicalResistanceBonus()
	return self.magic_resistance
end

function earthshaker_enchant_totem_lua:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_unique_earthshaker") and not self:GetCaster():HasModifier("modifier_special_bonus_unique_earthshaker") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_unique_earthshaker"), "modifier_special_bonus_unique_earthshaker", {})
	end
	
	-- Doesn't matter where we attach the bonus magic resistance talent to but it should be attached to SOMETHING
	if self:GetCaster():HasTalent("special_bonus_imba_earthshaker_bonus_magic_resistance") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_earthshaker_bonus_magic_resistance") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_earthshaker_bonus_magic_resistance"), "modifier_special_bonus_imba_earthshaker_bonus_magic_resistance", {})
	end
end
