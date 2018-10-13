-- Author:
--		Firetoad

-- Editors:
--     Baumi

-- Custom hero system
--		EarthSalamander #42

-- Model:
--		Carlos RPG

sohei_dash = sohei_dash or class ({})

LinkLuaModifier( "modifier_sohei_dash_free_turning", "components/abilities/heroes/hero_sohei.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sohei_dash_movement", "components/abilities/heroes/hero_sohei.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_sohei_dash_charges", "components/abilities/heroes/hero_sohei.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function sohei_dash:GetIntrinsicModifierName()
	return "modifier_sohei_dash_free_turning"
end

--------------------------------------------------------------------------------

if IsServer() then
	function sohei_dash:OnUpgrade()
		local caster = self:GetCaster()
		local modifier_charges = caster:FindModifierByName( "modifier_sohei_dash_charges" )

		if not modifier_charges then
			modifier_charges = caster:AddNewModifier( self:GetCaster(), self, "modifier_sohei_dash_charges", {} )
			modifier_charges:SetStackCount( self:GetSpecialValueFor( "max_charges" ) )
		elseif modifier_charges:GetDuration() <= 0 then
			modifier_charges:SetDuration( self:GetChargeRefreshTime(), true )
			modifier_charges:StartIntervalThink( 0.1 )
		end
	end

--------------------------------------------------------------------------------

	function sohei_dash:GetChargeRefreshTime()
		-- Reduce the charge recovery time if the appropriate talent is learned
		local refreshTime = self:GetSpecialValueFor( "charge_restore_time" )
		local talent = self:GetCaster():FindAbilityByName( "special_bonus_sohei_dash_recharge" )

		if talent and talent:GetLevel() > 0 then
			refreshTime = math.max( refreshTime - talent:GetSpecialValueFor( "value" ), 1 )
		end

		-- put the unit cdr stuff here if we ever get it

		return refreshTime
	end

--------------------------------------------------------------------------------

	function sohei_dash:PerformDash()
		local caster = self:GetCaster()
		local distance = self:GetSpecialValueFor( "dash_distance" )
		local speed = self:GetSpecialValueFor( "dash_speed" )
		local treeRadius = self:GetSpecialValueFor( "tree_radius" )
		local duration = distance / speed

		caster:RemoveModifierByName( "modifier_sohei_dash_movement" )
		caster:EmitSound( "Sohei.Dash" )
		caster:StartGesture( ACT_DOTA_RUN )
		caster:AddNewModifier( nil, nil, "modifier_sohei_dash_movement", {
			duration = duration,
			distance = distance,
			tree_radius = treeRadius,
			speed = speed
		} )
	end

--------------------------------------------------------------------------------

	function sohei_dash:OnSpellStart()
		local caster = self:GetCaster()
		local modifier_charges = caster:FindModifierByName( "modifier_sohei_dash_charges" )
		local dashDistance = self:GetSpecialValueFor( "dash_distance" )
		local dashSpeed = self:GetSpecialValueFor( "dash_speed" )

		-- since changing stack count deals with cooldown anyway
		-- let's remove the default one
		self:EndCooldown()

		if modifier_charges and not modifier_charges:IsNull() then
			-- Perform the dash if there is at least one charge remaining
			if modifier_charges:GetStackCount() >= 1 then
				modifier_charges:SetStackCount( modifier_charges:GetStackCount() - 1 )

				local shortCD = dashDistance / dashSpeed
				if self:GetCooldownTimeRemaining() < shortCD then
					self:EndCooldown()
					self:StartCooldown( dashDistance / dashSpeed )
				end
			end
		else
			caster:AddNewModifier( caster, self, "modifier_sohei_dash_charges", {
				duration = self:GetChargeRefreshTime()
			} )

			self:EndCooldown()
			self:StartCooldown( self:GetChargeRefreshTime() )
		end

		-- i commented on this in guard but
		-- faking not casting is really just not a great solution
		-- especially if something breaks due to dev fault and suddenly a bread and butter ability isn't
		-- usable
		-- so let's instead give the player some let in this regard and let 'em dash anyway

		self:PerformDash()

		-- cd refund for momentum
		local cdRefund = self:GetSpecialValueFor( "momentum_cd_refund" )

		if cdRefund > 0 then
			local momentum = caster:FindAbilityByName( "sohei_momentum" )

			if momentum and not momentum:IsCooldownReady() then
				local momentumCooldown = momentum:GetCooldownTimeRemaining()
				local refundCooldown = momentumCooldown * ( cdRefund / 100.0 )

				momentum:EndCooldown()
				momentum:StartCooldown( momentumCooldown - refundCooldown )
			end
		end
	end

--------------------------------------------------------------------------------

	function sohei_dash:RefreshCharges()
		local modifier_charges = self:GetCaster():FindModifierByName( "modifier_sohei_dash_charges" )

    if modifier_charges and not modifier_charges:IsNull() then
		  modifier_charges:SetStackCount( self:GetSpecialValueFor( "max_charges" ) )
    end
	end
end

--------------------------------------------------------------------------------

-- Dash free turning modifier
modifier_sohei_dash_free_turning = modifier_sohei_dash_free_turning or class ({})

--------------------------------------------------------------------------------

function modifier_sohei_dash_free_turning:IsDebuff()
	return false
end

function modifier_sohei_dash_free_turning:IsHidden()
	return true
end

function modifier_sohei_dash_free_turning:IsPurgable()
	return false
end

function modifier_sohei_dash_free_turning:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_sohei_dash_free_turning:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_sohei_dash_free_turning:GetModifierIgnoreCastAngle()
	return 1
end

--------------------------------------------------------------------------------

-- Dash charges modifier
modifier_sohei_dash_charges = modifier_sohei_dash_charges or class ({})


--------------------------------------------------------------------------------

function modifier_sohei_dash_charges:IsDebuff()
	return false
end

function modifier_sohei_dash_charges:IsDebuff()
	return false
end

function modifier_sohei_dash_charges:IsHidden()
	return false
end

function modifier_sohei_dash_charges:IsPurgable()
	return false
end

function modifier_sohei_dash_charges:RemoveOnDeath()
	return false
end

function modifier_sohei_dash_charges:DestroyOnExpire()
	return false
end

function modifier_sohei_dash_charges:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

if IsServer() then
	function modifier_sohei_dash_charges:OnCreated()
		if self:GetParent():IsIllusion() or self:GetParent():HasModifier("modifier_illusion_manager") then return end
		self:StartIntervalThink( 0.1 )
	end

--------------------------------------------------------------------------------

	function modifier_sohei_dash_charges:OnRefresh()
		self:StartIntervalThink( 0.1 )
	end

--------------------------------------------------------------------------------

	function modifier_sohei_dash_charges:OnIntervalThink()
		if self:GetRemainingTime() <= 0 then
			self:OnExpire()
		end
	end

--------------------------------------------------------------------------------

	function modifier_sohei_dash_charges:OnExpire()
		local spell = self:GetAbility()

		-- used to handle all charge-gaining logic here
		-- but that doesn't work with RefreshCharges also adding
		-- charges, so sayonara old chap
		self:SetDuration( -1, true )
		self:SetStackCount( self:GetStackCount() + 1 )
	end

--------------------------------------------------------------------------------

	function modifier_sohei_dash_charges:OnStackCountChanged( oldCount )
	if self:GetParent():IsIllusion() or self:GetParent():HasModifier("modifier_illusion_manager") then return end
		local spell = self:GetAbility()
		local newCount = self:GetStackCount()
		local maxCount = spell:GetSpecialValueFor( "max_charges" )

		if newCount >= maxCount then
			-- we want to make sure that the thinking stops at max
			-- charges, and not just in OnExpire as charges can be added
			-- through Refresher items and such
			self:SetDuration( -1, true )
			self:StartIntervalThink( -1 )
		else
			-- we're just starting the thinking again
			-- so we don't bother doing anything if that's already happening
			-- ( otherwise, we'll end up restarting the recharge time )
			if self:GetDuration() <= 0 and newCount < maxCount then
				local duration = self:GetAbility():GetChargeRefreshTime()

				self:SetDuration( duration, true )
				self:StartIntervalThink( 0.1 )
				-- we can probably now tell StartIntervalThink to only think every duration
				-- seconds now, but I'd rather not go about extensively testing that for now
			end

			-- also do cooldown if the count is dead
			-- rip dracula
			if newCount <= 0 then
				local remainingTime = self:GetRemainingTime()

				if remainingTime > spell:GetCooldownTimeRemaining() then
					spell:EndCooldown()
					spell:StartCooldown( remainingTime )
				end

				local spellPalm = self:GetParent():FindAbilityByName( "sohei_palm_of_life" )

				if remainingTime > spellPalm:GetCooldownTimeRemaining() then
					spellPalm:EndCooldown()
					spellPalm:StartCooldown( remainingTime )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

-- Dash movement modifier
modifier_sohei_dash_movement = modifier_sohei_dash_movement or class ({})


--------------------------------------------------------------------------------

function modifier_sohei_dash_movement:IsDebuff()
	return false
end

function modifier_sohei_dash_movement:IsHidden()
	return true
end

function modifier_sohei_dash_movement:IsPurgable()
	return false
end

function modifier_sohei_dash_movement:IsStunDebuff()
	return false
end

function modifier_sohei_dash_movement:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end

--------------------------------------------------------------------------------

function modifier_sohei_dash_movement:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}

	return state
end

--------------------------------------------------------------------------------

if IsServer() then
	function modifier_sohei_dash_movement:OnCreated( event )
		-- Movement parameters
		local parent = self:GetParent()
		self.direction = parent:GetForwardVector()
		self.distance = event.distance
		self.speed = event.speed
		self.tree_radius = event.tree_radius

		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end

		-- Trail particle
		local trail_pfx = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/bladekeeper_omnislash/_dc_juggernaut_omni_slash_trail.vpcf", PATTACH_CUSTOMORIGIN, parent )
		ParticleManager:SetParticleControl( trail_pfx, 0, parent:GetAbsOrigin() )
		ParticleManager:SetParticleControl( trail_pfx, 1, parent:GetAbsOrigin() + parent:GetForwardVector() * 300 )
		ParticleManager:ReleaseParticleIndex( trail_pfx )
	end

--------------------------------------------------------------------------------

	function modifier_sohei_dash_movement:OnDestroy()
		local parent = self:GetParent()

		parent:FadeGesture( ACT_DOTA_RUN )
		parent:RemoveHorizontalMotionController( self )
		ResolveNPCPositions( parent:GetAbsOrigin(), 128 )
	end

--------------------------------------------------------------------------------

	function modifier_sohei_dash_movement:UpdateHorizontalMotion( parent, deltaTime )
		local parentOrigin = parent:GetAbsOrigin()

		local tickSpeed = self.speed * deltaTime
		tickSpeed = math.min( tickSpeed, self.distance )
		local tickOrigin = parentOrigin + ( tickSpeed * self.direction )

		parent:SetAbsOrigin( tickOrigin )

		self.distance = self.distance - tickSpeed

		GridNav:DestroyTreesAroundPoint( tickOrigin, self.tree_radius, false )
	end

--------------------------------------------------------------------------------

	function modifier_sohei_dash_movement:OnHorizontalMotionInterrupted()
		self:Destroy()
	end
end

sohei_flurry_of_blows = sohei_flurry_of_blows or class ({})

LinkLuaModifier( "modifier_sohei_flurry_self", "components/abilities/heroes/hero_sohei.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_special_bonus_sohei_fob_radius", "components/abilities/heroes/hero_sohei.lua", LUA_MODIFIER_MOTION_NONE )

-- Required to change behaviour on client-side
modifier_special_bonus_sohei_fob_radius = class ({})

function modifier_special_bonus_sohei_fob_radius:IsHidden() 		return true end
function modifier_special_bonus_sohei_fob_radius:IsPurgable() 		return false end
function modifier_special_bonus_sohei_fob_radius:RemoveOnDeath() 	return false end

-- Should close out talent behavior change problems
function sohei_flurry_of_blows:OnOwnerSpawned()
	if not IsServer() then return end
	if self:GetCaster():HasAbility("special_bonus_sohei_fob_radius") and self:GetCaster():FindAbilityByName("special_bonus_sohei_fob_radius"):IsTrained() and not self:GetCaster():HasModifier("modifier_special_bonus_sohei_fob_radius") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_sohei_fob_radius", {})
	end
end


function sohei_flurry_of_blows:GetAssociatedPrimaryAbilities()
	return "sohei_momentum"
end

--------------------------------------------------------------------------------

-- Cast animation + playback rate
function sohei_flurry_of_blows:GetCastAnimation()
  return ACT_DOTA_CAST_ABILITY_2
end

function sohei_flurry_of_blows:GetPlaybackRateOverride()
  return 0.35
end

--------------------------------------------------------------------------------

function sohei_flurry_of_blows:OnAbilityPhaseStart()
  if IsServer() then
    self:GetCaster():EmitSound( "Hero_EmberSpirit.FireRemnant.Stop" )
    return true
  end
end

--------------------------------------------------------------------------------

function sohei_flurry_of_blows:OnAbilityPhaseInterrupted()
  if IsServer() then
    self:GetCaster():StopSound( "Hero_EmberSpirit.FireRemnant.Stop" )
  end
end

--------------------------------------------------------------------------------

function sohei_flurry_of_blows:GetChannelTime()
  --[[
  if self:GetCaster():HasScepter() then
    return 300
  end--]]

  return self:GetSpecialValueFor( "max_duration" )
end

--------------------------------------------------------------------------------

function sohei_flurry_of_blows:OnAbilityPhaseInterrupted()
  if IsServer() then
    self:GetCaster():StopSound( "Hero_EmberSpirit.FireRemnant.Stop" )
  end
end

--------------------------------------------------------------------------------

if IsServer() then
  function sohei_flurry_of_blows:OnSpellStart()
    local caster = self:GetCaster()
    local target_loc = self:GetCursorPosition()
    local flurry_radius = self:GetAOERadius()
    local max_attacks = self:GetSpecialValueFor( "max_attacks" )
    local max_duration = self:GetSpecialValueFor( "max_duration" )
    local attack_interval = self:GetSpecialValueFor( "attack_interval" )

    -- Emit sound
    caster:EmitSound( "Hero_EmberSpirit.FireRemnant.Cast" )

    -- Draw the particle
    if caster.flurry_ground_pfx then
      ParticleManager:DestroyParticle( caster.flurry_ground_pfx, false )
      ParticleManager:ReleaseParticleIndex( caster.flurry_ground_pfx )
    end
    caster.flurry_ground_pfx = ParticleManager:CreateParticle( "particles/hero/sohei/flurry_of_blows_ground.vpcf", PATTACH_CUSTOMORIGIN, nil )
    ParticleManager:SetParticleControl( caster.flurry_ground_pfx, 0, target_loc )
	ParticleManager:SetParticleControl( caster.flurry_ground_pfx, 10, Vector(flurry_radius, 0, 0) )

    -- Start the spell
    caster:SetAbsOrigin( target_loc + Vector(0, 0, 200) )
    caster:AddNewModifier( caster, self, "modifier_sohei_flurry_self", {
      duration = max_duration,
      max_attacks = max_attacks,
      flurry_radius = flurry_radius,
      attack_interval = attack_interval
    } )
  end

--------------------------------------------------------------------------------

  function sohei_flurry_of_blows:OnChannelFinish()
    local caster = self:GetCaster()

    caster:RemoveModifierByName( "modifier_sohei_flurry_self" )
  end
end

--------------------------------------------------------------------------------

function sohei_flurry_of_blows:GetAOERadius()
  local caster = self:GetCaster()
  local additionalRadius = 0

	if self:GetCaster():HasTalent("special_bonus_sohei_fob_radius") then
		additionalRadius = self:GetCaster():FindTalentValue("special_bonus_sohei_fob_radius")
    end

  return self:GetSpecialValueFor( "flurry_radius" ) + additionalRadius
end

--------------------------------------------------------------------------------

-- Flurry of Blows' self buff
modifier_sohei_flurry_self = modifier_sohei_flurry_self or class ({})

--------------------------------------------------------------------------------

function modifier_sohei_flurry_self:IsDebuff()
  return false
end

function modifier_sohei_flurry_self:IsHidden()
  return true
end

function modifier_sohei_flurry_self:IsPurgable()
  return false
end

function modifier_sohei_flurry_self:IsStunDebuff()
  return false
end

--------------------------------------------------------------------------------

function modifier_sohei_flurry_self:StatusEffectPriority()
   return 20
end

function modifier_sohei_flurry_self:GetStatusEffectName()
  return "particles/status_fx/status_effect_omnislash.vpcf"
end

--------------------------------------------------------------------------------

function modifier_sohei_flurry_self:CheckState()
  local state = {
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    [MODIFIER_STATE_ROOTED] = true
  }

  return state
end

--------------------------------------------------------------------------------

function modifier_sohei_flurry_self:OnDestroy()
  if IsServer() then
    local caster = self:GetCaster()

    ParticleManager:DestroyParticle( caster.flurry_ground_pfx, false )
    ParticleManager:ReleaseParticleIndex( caster.flurry_ground_pfx )
    caster.flurry_ground_pfx = nil

    caster:FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_2)

    caster:Interrupt()
  end
end

--------------------------------------------------------------------------------

if IsServer() then
  function modifier_sohei_flurry_self:OnCreated( event )
    self.remaining_attacks = event.max_attacks
    self.radius = event.flurry_radius
    self.attack_interval = event.attack_interval
    self.position = self:GetCaster():GetAbsOrigin()
    self.positionGround = self.position - Vector( 0, 0, 200 )

    self:StartIntervalThink( self.attack_interval )

    self:GetCaster():StartGestureWithPlaybackRate( ACT_DOTA_OVERRIDE_ABILITY_2 , 1.4)


    if self:PerformFlurryBlow() then
      self.remaining_attacks = self.remaining_attacks - 1
    end
  end

--------------------------------------------------------------------------------

  function modifier_sohei_flurry_self:OnIntervalThink()
    -- Attempt a strike
    if self:PerformFlurryBlow() then
      self.remaining_attacks = self.remaining_attacks - 1

      --[[
      if self:GetParent():HasScepter() then
        self:SetDuration( self:GetRemainingTime() + self.attack_interval, true )
      end
      --]]
    end

    -- If there are no strikes left, end
    if self.remaining_attacks <= 0 then
      self:Destroy()
    end
  end

--------------------------------------------------------------------------------

  function modifier_sohei_flurry_self:PerformFlurryBlow()
    local parent = self:GetParent()

    -- If there is at least one target to attack, hit it
    local targets = FindUnitsInRadius(
      parent:GetTeamNumber(),
      self.positionGround,
      nil,
      self.radius,
      DOTA_UNIT_TARGET_TEAM_ENEMY,
      DOTA_UNIT_TARGET_HERO,
      bit.bor( DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, DOTA_UNIT_TARGET_FLAG_NO_INVIS, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE ),
      FIND_ANY_ORDER,
      false
    )

    if targets[1] then
      local target = targets[1]
      local targetOrigin = target:GetAbsOrigin()
      local abilityDash = parent:FindAbilityByName( "sohei_dash" )
      local distance = 50

      if abilityDash then
        distance = abilityDash:GetSpecialValueFor( "dash_distance" ) + 50
      end

      local targetOffset = ( targetOrigin - self.positionGround ):Normalized() * distance
      local tickOrigin = targetOrigin + targetOffset

      parent:SetAbsOrigin( tickOrigin )
      parent:SetForwardVector( ( ( self.positionGround ) - tickOrigin ):Normalized() )
      parent:FaceTowards( targetOrigin )

      -- this stuff should probably be removed if we get actual animations
      -- just let the animations handle the movement
      if abilityDash and abilityDash:GetLevel() > 0 then
        abilityDash:PerformDash()
      end

      parent:PerformAttack( targets[1], true, true, true, false, false, false, false )

      return true

    -- Else, return false and keep meditating
    else
      parent:SetAbsOrigin( self.position )
      parent:StartGestureWithPlaybackRate( ACT_DOTA_OVERRIDE_ABILITY_2 , 0.5)

      return false
    end
  end
end

sohei_guard = sohei_guard or class ({})

LinkLuaModifier( "modifier_sohei_guard_reflect", "components/abilities/heroes/hero_sohei.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sohei_guard_knockback", "components/abilities/heroes/hero_sohei.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

--------------------------------------------------------------------------------

-- unfinished talent stuff
function sohei_guard:CastFilterResultTarget( target )
	local caster = self:GetCaster()

	if ( target ~= caster ) and caster:IsStunned() then
		return UF_FAIL_CUSTOM
	end

	local ufResult = UnitFilter(
		target,
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		caster:GetTeamNumber()
	)

	return ufResult
end

--------------------------------------------------------------------------------

-- unfinished talent stuff
function sohei_guard:GetCustomCastErrorTarget( target )
	local caster = self:GetCaster()

	if ( target ~= caster ) and caster:IsStunned() then
		return "#dota_hud_error_cant_cast_on_ally_while_stunned"
	end

	return ""
end

--------------------------------------------------------------------------------

if IsServer() then
	-- always preferrable to stop a cast instead of faking not casting
	function sohei_guard:GetBehavior()
		local behavior = self.BaseClass.GetBehavior( self )
		local caster = self:GetCaster()
		local modifier_charges = caster:FindModifierByName( "modifier_sohei_dash_charges" )
		local talent = caster:FindAbilityByName( "special_bonus_sohei_guard_allycast" )

		-- unfinished talent stuff
		if talent and talent:GetLevel() > 0 then
			behavior = bit.bor( DOTA_ABILITY_BEHAVIOR_UNIT_TARGET, DOTA_ABILITY_BEHAVIOR_IMMEDIATE, DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL )
		end

		if modifier_charges and modifier_charges:GetStackCount() >= 2 then
			behavior = bit.bor( behavior, DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE )
		end

		return behavior
	end

--------------------------------------------------------------------------------

	function sohei_guard:OnSpellStart()
		local caster = self:GetCaster()
		local target = self:GetCursorTarget() or caster

		-- Check if there are enough charges to cast the ability, if the caster is stunned

		if caster:IsStunned() then
			local modifier_charges = caster:FindModifierByName( "modifier_sohei_dash_charges" )

			if modifier_charges then
				modifier_charges:SetStackCount( modifier_charges:GetStackCount() - 2 )
			end
			-- there could be the whole thing about faking the ability not casting here
			-- if there aren't enough charges
			-- but really, that still procs magic wand and stuff
		end

		-- Hard Dispel
		target:Purge( false, true, false, true, true )

		-- Start an animation
    caster:StartGestureWithPlaybackRate( ACT_DOTA_OVERRIDE_ABILITY_1 , 1)

		-- Play guard sound
		target:EmitSound( "Sohei.Guard" )

		--Apply Linken's + Lotus Orb + Attack reflect modifier for 2 seconds
		local duration = self:GetSpecialValueFor("guard_duration")
		target:AddNewModifier(caster, self, "modifier_item_lotus_orb_active", { duration = duration })
		target:AddNewModifier(caster, self, "modifier_sohei_guard_reflect", { duration = duration })

		-- Stop the animation when it's done
		Timers:CreateTimer(duration, function()
			caster:FadeGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
		end)

		-- If there is at least one target to attack, hit it
		local talent = caster:FindAbilityByName("special_bonus_sohei_guard_knockback")

		if talent and talent:GetLevel() > 0 then
			local radius = talent:GetSpecialValueFor( "value" )
			local pushTargets = FindUnitsInRadius(
				caster:GetTeamNumber(),
				target:GetAbsOrigin(),
				nil,
				radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE +	DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
				FIND_ANY_ORDER,
				false
			)

			for _, pushTarget in pairs(pushTargets) do
				self:PushAwayEnemy(pushTarget)
			end
		end
	end

--------------------------------------------------------------------------------

	function sohei_guard:PushAwayEnemy( target )
		local caster = self:GetCaster()
		local casterposition = caster:GetAbsOrigin()
		local targetposition = target:GetAbsOrigin()
		local radius = caster:FindAbilityByName( "special_bonus_sohei_guard_knockback" ):GetSpecialValueFor("value" )

		local vVelocity = casterposition - targetposition
		vVelocity.z = 0.0

		local distance = radius - vVelocity:Length2D() + caster:GetPaddedCollisionRadius()
		local duration = distance / self:GetSpecialValueFor( "knockback_speed" )

		target:AddNewModifier( caster, self, "modifier_sohei_guard_knockback", {
			duration = duration,
			distance = distance,
			tree_radius = target:GetPaddedCollisionRadius()
		} )
	end

--------------------------------------------------------------------------------

	function sohei_guard:OnProjectileHit_ExtraData( target, location, extra_data )
		target:EmitSound( "Sohei.GuardHit" )
		ApplyDamage( {
			victim = target,
			attacker = self:GetCaster(),
			damage = extra_data.damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self
		} )
	end
end

--------------------------------------------------------------------------------

-- Guard projectile reflect modifier
modifier_sohei_guard_reflect = modifier_sohei_guard_reflect or class ({})

--------------------------------------------------------------------------------

function modifier_sohei_guard_reflect:IsDebuff()
	return false
end

function modifier_sohei_guard_reflect:IsHidden()
	return false
end

function modifier_sohei_guard_reflect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

--[[
function modifier_sohei_guard_reflect:GetEffectName()
	return "particles/items3_fx/lotus_orb_shell.vpcf"
end
function modifier_sohei_guard_reflect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
]]--

--------------------------------------------------------------------------------

function modifier_sohei_guard_reflect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
		MODIFIER_PROPERTY_ABSORB_SPELL,
		--MODIFIER_PROPERTY_REFLECT_SPELL,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

--------------------------------------------------------------------------------

if IsServer() then
	function modifier_sohei_guard_reflect:GetModifierAvoidDamage( event )
		if event.ranged_attack == true and event.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
			return 1
		end

		return 0
	end

--------------------------------------------------------------------------------

	function modifier_sohei_guard_reflect:GetAbsorbSpell( event )
		return 1
	end

--------------------------------------------------------------------------------

	-- why does this do nothing
	function modifier_sohei_guard_reflect:GetReflectSpell( event )
		return 1
	end

--------------------------------------------------------------------------------

	function modifier_sohei_guard_reflect:OnAttackLanded( event )
		if event.target == self:GetParent() then
			if event.ranged_attack == true then
				-- Pre-heal for the damage done
				local parent = self:GetParent()
				--local parent_armor = parent:GetPhysicalArmorValue()
				--parent:Heal(event.damage * (1 - parent_armor / (parent_armor + 20)), parent)
				-- what is this, wc3

				-- Send the target's projectile back to them
				ProjectileManager:CreateTrackingProjectile( {
					Target = event.attacker,
					Source = parent,
					Ability = self:GetAbility(),
					EffectName = event.attacker:GetRangedProjectileName(),
					iMoveSpeed = event.attacker:GetProjectileSpeed(),
					vSpawnOrigin = parent:GetAbsOrigin(),
					bDodgeable = true,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,

					ExtraData = {
						damage = event.damage
					}
				} )

				parent:EmitSound( "Sohei.GuardProc" )
			end
		end
	end
end

--------------------------------------------------------------------------------

-- Dash movement modifier
modifier_sohei_guard_knockback = modifier_sohei_guard_knockback or class ({})

--------------------------------------------------------------------------------

function modifier_sohei_guard_knockback:IsDebuff()
	return true
end

function modifier_sohei_guard_knockback:IsHidden()
	return true
end

function modifier_sohei_guard_knockback:IsPurgable()
	return false
end

function modifier_sohei_guard_knockback:IsStunDebuff()
	return false
end

function modifier_sohei_guard_knockback:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM
end

--------------------------------------------------------------------------------

function modifier_sohei_guard_knockback:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_sohei_guard_knockback:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_sohei_guard_knockback:GetOverrideAnimation( event )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function modifier_sohei_guard_knockback:GetOverrideAnimationRate( event )
	return 2.5
end

--------------------------------------------------------------------------------

if IsServer() then
	function modifier_sohei_guard_knockback:OnCreated( event )
		local unit = self:GetParent()
		local caster = self:GetCaster()

		local difference = unit:GetAbsOrigin() - caster:GetAbsOrigin()

		-- Movement parameters
		self.direction = difference:Normalized()
		self.distance = event.distance
		self.speed = self:GetAbility():GetSpecialValueFor( "knockback_speed" )
		self.tree_radius = event.tree_radius

		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
	end

--------------------------------------------------------------------------------

	function modifier_sohei_guard_knockback:OnDestroy()
		local parent = self:GetParent()

		parent:RemoveHorizontalMotionController( self )
		ResolveNPCPositions( parent:GetAbsOrigin(), 128 )
	end

--------------------------------------------------------------------------------

	function modifier_sohei_guard_knockback:UpdateHorizontalMotion( parent, deltaTime )
		local parentOrigin = parent:GetAbsOrigin()

		local tickSpeed = self.speed * deltaTime
		tickSpeed = math.min( tickSpeed, self.distance )
		local tickOrigin = parentOrigin + ( tickSpeed * self.direction )

		parent:SetAbsOrigin( tickOrigin )

		self.distance = self.distance - tickSpeed

		GridNav:DestroyTreesAroundPoint( tickOrigin, self.tree_radius, false )
	end

--------------------------------------------------------------------------------

	function modifier_sohei_guard_knockback:OnHorizontalMotionInterrupted()
		self:Destroy()
	end
end

sohei_momentum = sohei_momentum or class ({})

LinkLuaModifier("modifier_sohei_momentum_passive", "components/abilities/heroes/hero_sohei.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_sohei_momentum_knockback", "components/abilities/heroes/hero_sohei.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier("modifier_sohei_momentum_slow", "components/abilities/heroes/hero_sohei.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function sohei_momentum:GetAbilityTextureName()
	local baseName = self.BaseClass.GetAbilityTextureName( self )

	if self:GetSpecialValueFor( "trigger_distance" ) <= 0 then
		return baseName
	end

	if self.intrMod and not self.intrMod:IsNull() and not self.intrMod:IsMomentumReady() then
		return baseName .. "_inactive"
	end

	return baseName
end

--------------------------------------------------------------------------------

function sohei_momentum:GetIntrinsicModifierName()
	return "modifier_sohei_momentum_passive"
end

--------------------------------------------------------------------------------

-- Momentum's passive modifier
modifier_sohei_momentum_passive = modifier_sohei_momentum_passive or class ({})

--------------------------------------------------------------------------------

function modifier_sohei_momentum_passive:IsHidden()
	return true
end

function modifier_sohei_momentum_passive:IsPurgable()
	return false
end

function modifier_sohei_momentum_passive:IsDebuff()
	return false
end

function modifier_sohei_momentum_passive:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_sohei_momentum_passive:IsMomentumReady()
	-- special case flurry of blows to always have momentum ready
	if self:GetParent():HasModifier( "modifier_sohei_flurry_self" ) then
		return true
	end

	local distanceFull = self:GetAbility():GetSpecialValueFor( "trigger_distance" )

	return self:GetStackCount() >= distanceFull
end

--------------------------------------------------------------------------------

function modifier_sohei_momentum_passive:OnCreated( event )
	if self:GetParent():IsIllusion() or self:GetParent():HasModifier("modifier_illusion_manager") then return end
	self:GetAbility().intrMod = self

	self.parentOrigin = self:GetParent():GetAbsOrigin()
	self.attackPrimed = false -- necessary for cases when sohei starts an attack while moving
	-- i.e. force staff
	-- and gets charged before the attack finishes, causing an attack with knockback but no crit

	self:StartIntervalThink( 1 / 30 )
end

--------------------------------------------------------------------------------

if IsServer() then
	function modifier_sohei_momentum_passive:OnRefresh( event )
		self:SetStackCount( 0 )
	end

--------------------------------------------------------------------------------

	function modifier_sohei_momentum_passive:OnIntervalThink()
		-- Update position
		local parent = self:GetParent()
		local spell = self:GetAbility()
		local oldOrigin = self.parentOrigin
		self.parentOrigin = parent:GetAbsOrigin()

		if not self:IsMomentumReady() then
			if spell:IsCooldownReady() then
				self:SetStackCount( self:GetStackCount() + ( self.parentOrigin - oldOrigin ):Length2D() )
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_sohei_momentum_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ORDER,
	}

	return funcs
end

--------------------------------------------------------------------------------

if IsServer() then

	function modifier_sohei_momentum_passive:OnOrder(kv)
		local order_type = kv.order_type
		local unit = kv.unit
		local target = kv.target

		self.force_casting = false
		if self:GetCaster() == unit then
			if order_type == DOTA_UNIT_ORDER_CAST_TARGET then
				self.force_casting = true
			end
		end
	end

	function modifier_sohei_momentum_passive:GetModifierPreAttack_CriticalStrike( event )
		if (self.force_casting == true or self:GetAbility():GetAutoCastState() == true) and self:IsMomentumReady() and (self:GetAbility():IsCooldownReady() or self:GetParent():HasModifier( "modifier_sohei_flurry_self" )) then

			-- make sure the target is valid
			local ufResult = UnitFilter(
				event.target,
				self:GetAbility():GetAbilityTargetTeam(),
				self:GetAbility():GetAbilityTargetType(),
				self:GetAbility():GetAbilityTargetFlags(),
				self:GetParent():GetTeamNumber()
			)

			if ufResult ~= UF_SUCCESS then
				return 0
			end

			self.attackPrimed = true

			return self:GetAbility():GetSpecialValueFor("crit_damage")
		end

		self.attackPrimed = false
		return 0
	end

--------------------------------------------------------------------------------

	function modifier_sohei_momentum_passive:OnAttackLanded( event )
		if event.attacker == self:GetParent() and self.attackPrimed == true then
			local attacker = self:GetParent()
			local target = event.target
			local spell = self:GetAbility()

			if target:GetTeam() == self:GetParent():GetTeam() then
				return nil
			end

			if target:IsBuilding() then
				return nil
			end

			-- Consume the buff
			self:ForceRefresh()

			-- Knock the enemy back
			local distance = spell:GetSpecialValueFor( "knockback_distance" )
			local speed = spell:GetSpecialValueFor( "knockback_speed" )
			local duration = distance / speed
			local collision_radius = spell:GetSpecialValueFor( "collision_radius" )
			target:RemoveModifierByName( "modifier_sohei_momentum_knockback" )
			target:AddNewModifier( attacker, spell, "modifier_sohei_momentum_knockback", {
				duration = duration,
				distance = distance,
				speed = speed,
				collision_radius = collision_radius
			} )

			-- Play the impact sound
			target:EmitSound( "Sohei.Momentum" )

			-- Play the impact particle
			local momentum_pfx = ParticleManager:CreateParticle( "particles/hero/sohei/momentum.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
			ParticleManager:SetParticleControl( momentum_pfx, 0, target:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex( momentum_pfx )

			-- Reduce guard cd if they skilled the talent
			local guard = attacker:FindAbilityByName( "sohei_guard" )
			local talent = attacker:FindAbilityByName( "special_bonus_sohei_momentum_guard_cooldown" )

			if talent and talent:GetLevel() > 0 then
				local cooldown_reduction = talent:GetSpecialValueFor( "value" )

				if not guard:IsCooldownReady() then
					local newCooldown = guard:GetCooldownTimeRemaining() - cooldown_reduction
					guard:EndCooldown()
					guard:StartCooldown( newCooldown )
				end
			end

			-- start momentum cooldown if not used during flurry
			if not self:GetParent():HasModifier( "modifier_sohei_flurry_self" ) then
				spell:UseResources( true, true, true )
			end
		end
	end
end

--------------------------------------------------------------------------------

-- Momentum's knockback modifier
modifier_sohei_momentum_knockback = modifier_sohei_momentum_knockback or class ({})

--------------------------------------------------------------------------------

function modifier_sohei_momentum_knockback:IsDebuff()
	return true
end

function modifier_sohei_momentum_knockback:IsHidden()
	return true
end

function modifier_sohei_momentum_knockback:IsPurgable()
	return false
end

function modifier_sohei_momentum_knockback:IsStunDebuff()
	return false
end

function modifier_sohei_momentum_knockback:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM
end

--------------------------------------------------------------------------------

function modifier_sohei_momentum_knockback:GetEffectName()
	return "particles/hero/sohei/knockback.vpcf"
end

--------------------------------------------------------------------------------

function modifier_sohei_momentum_knockback:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_sohei_momentum_knockback:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_sohei_momentum_knockback:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_sohei_momentum_knockback:GetOverrideAnimation( event )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

if IsServer() then
	function modifier_sohei_momentum_knockback:OnCreated( event )
		local unit = self:GetParent()
		local caster = self:GetCaster()

		local difference = unit:GetAbsOrigin() - caster:GetAbsOrigin()

		-- Movement parameters
		self.direction = difference:Normalized()
		self.distance = event.distance
		self.speed = event.speed
		self.collision_radius = event.collision_radius

		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
	end

--------------------------------------------------------------------------------

	function modifier_sohei_momentum_knockback:OnDestroy()
		local parent = self:GetParent()

		parent:RemoveHorizontalMotionController( self )
		ResolveNPCPositions( parent:GetAbsOrigin(), 128 )
	end

--------------------------------------------------------------------------------

	function modifier_sohei_momentum_knockback:UpdateHorizontalMotion( parent, deltaTime )
		local caster = self:GetCaster()
		local parentOrigin = parent:GetAbsOrigin()

		local tickSpeed = self.speed * deltaTime
		tickSpeed = math.min( tickSpeed, self.distance )
		local tickOrigin = parentOrigin + ( tickSpeed * self.direction )

		self.distance = self.distance - tickSpeed

		-- If there is at least one target to attack, hit it
		local targets = FindUnitsInRadius(
			caster:GetTeamNumber(),
			tickOrigin,
			nil,
			self.collision_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO,
			bit.bor( DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, DOTA_UNIT_TARGET_FLAG_NO_INVIS, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE ),
			FIND_CLOSEST,
			false
		)

		local nonHeroTarget = targets[1]
		if nonHeroTarget == parent then
			nonHeroTarget = targets[2]
		end

		local spell = self:GetAbility()

		if nonHeroTarget then
			self:SlowAndStun( parent, caster, spell )
			self:SlowAndStun( nonHeroTarget, caster, spell )
			self:Destroy()
		-- why do these mean two different things
		elseif not GridNav:IsTraversable( tickOrigin ) or GridNav:IsBlocked( tickOrigin ) then
			self:SlowAndStun( parent, caster, spell )
			GridNav:DestroyTreesAroundPoint( tickOrigin, self.collision_radius, false )
			self:Destroy()
		else
			-- if we check for collision after moving the unit, the unit will
			-- bounce around a bit due to resolving npc positions upon destruction
			-- so let's only move the unit if the move wouldn't hit anyone
			parent:SetAbsOrigin( tickOrigin )
		end
	end

--------------------------------------------------------------------------------

	function modifier_sohei_momentum_knockback:SlowAndStun( unit, caster, ability )
		unit:AddNewModifier( caster, ability, "modifier_sohei_momentum_slow", {
			duration = ability:GetSpecialValueFor( "slow_duration" ),
		} )

		local talent = caster:FindAbilityByName( "special_bonus_sohei_stun" )

		if talent and talent:GetLevel() > 0 then
			local stunDuration = talent:GetSpecialValueFor("value")

			unit:AddNewModifier( caster, ability, "modifier_stunned", {
				duration = stunDuration
			} )
		end
	end
end

--------------------------------------------------------------------------------

-- Momentum's knockback modifier
modifier_sohei_momentum_slow = modifier_sohei_momentum_slow or class ({})

--------------------------------------------------------------------------------

function modifier_sohei_momentum_slow:IsDebuff()
	return true
end

function modifier_sohei_momentum_slow:IsHidden()
	return false
end

function modifier_sohei_momentum_slow:IsPurgable()
	return false
end

function modifier_sohei_momentum_slow:IsStunDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_sohei_momentum_slow:OnCreated( event )
	self.slow = self:GetAbility():GetSpecialValueFor( "movement_slow" )
end

--------------------------------------------------------------------------------

function modifier_sohei_momentum_slow:OnRefresh( event )
	self.slow = self:GetAbility():GetSpecialValueFor( "movement_slow" )
end

--------------------------------------------------------------------------------

-- slows don't show correctly if they're in an IsServer() block govs
function modifier_sohei_momentum_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_sohei_momentum_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

sohei_palm_of_life = sohei_palm_of_life or class ({})

LinkLuaModifier( "modifier_sohei_palm_of_life_movement", "components/abilities/heroes/hero_sohei.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

--------------------------------------------------------------------------------

function sohei_palm_of_life:CastFilterResultTarget( target )
	local caster = self:GetCaster()

	if caster == target then
		return UF_FAIL_CUSTOM
	end

	local ufResult = UnitFilter(
		target,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_FLAG_NONE,
		caster:GetTeamNumber()
	)

	return ufResult
end

--------------------------------------------------------------------------------

function sohei_palm_of_life:GetCustomCastErrorTarget( target )
	if self:GetCaster() == target then
		return "#dota_hud_error_cant_cast_on_self"
	end

	return ""
end

--------------------------------------------------------------------------------

function sohei_palm_of_life:OnHeroCalculateStatBonus()
	local caster = self:GetCaster()

	if caster:HasScepter() then
		self:SetHidden( false )
		if self:GetLevel() <= 0 then
			self:SetLevel( 1 )
		end
	else
		self:SetHidden( true )
	end
end

--------------------------------------------------------------------------------

if IsServer() then
	function sohei_palm_of_life:OnSpellStart()
		local caster = self:GetCaster()
		local modifier_charges = caster:FindModifierByName( "modifier_sohei_dash_charges" )

		if modifier_charges and not modifier_charges:IsNull() then
			-- Perform the dash if there is at least one charge remaining
			if modifier_charges:GetStackCount() >= 1 then
				modifier_charges:SetStackCount( modifier_charges:GetStackCount() - 1 )
			end
		end

		-- i commented on this in guard but
		-- faking not casting is really just not a great solution
		-- especially if something breaks due to dev fault and suddenly a bread and butter ability isn't
		-- usable
		-- so let's instead give the player some let in this regard and let 'em dash anyway
		local target = self:GetCursorTarget()
		local speed = self:GetSpecialValueFor( "dash_speed" )
		local treeRadius = self:GetSpecialValueFor( "tree_radius" )
		local duration = self:GetSpecialValueFor( "max_duration" )
		local endDistance = self:GetSpecialValueFor( "end_distance" )
		local doHeal = 0

		local modMomentum = caster:FindModifierByName( "modifier_sohei_momentum_passive" )
		local spellMomentum = caster:FindAbilityByName( "sohei_momentum" )

		if ( modMomentum and modMomentum:IsMomentumReady() ) and ( spellMomentum and spellMomentum:IsCooldownReady() ) then
			doHeal = 1
		end

		caster:RemoveModifierByName( "modifier_sohei_palm_of_life_movement" )
		caster:RemoveModifierByName( "modifier_sohei_dash_movement" )
		caster:EmitSound( "Sohei.Dash" )
		caster:StartGesture( ACT_DOTA_RUN )
		caster:AddNewModifier( caster, self, "modifier_sohei_palm_of_life_movement", {
			duration = duration,
			target = target:entindex(),
			tree_radius = treeRadius,
			speed = speed,
			endDistance = endDistance,
			doHeal = doHeal
		} )
	end
end

--------------------------------------------------------------------------------

-- Dash movement modifier
modifier_sohei_palm_of_life_movement = modifier_sohei_palm_of_life_movement or class ({})

--------------------------------------------------------------------------------

function modifier_sohei_palm_of_life_movement:IsDebuff()
	return false
end

function modifier_sohei_palm_of_life_movement:IsHidden()
	return true
end

function modifier_sohei_palm_of_life_movement:IsPurgable()
	return false
end

function modifier_sohei_palm_of_life_movement:IsStunDebuff()
	return false
end

function modifier_sohei_palm_of_life_movement:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM
end

--------------------------------------------------------------------------------

function modifier_sohei_palm_of_life_movement:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

--------------------------------------------------------------------------------

if IsServer() then
	function modifier_sohei_palm_of_life_movement:OnCreated( event )
		-- Movement parameters
		local parent = self:GetParent()
		self.target = EntIndexToHScript( event.target )
		self.speed = event.speed
		self.tree_radius = event.tree_radius
		self.endDistance = event.endDistance
		self.doHeal = event.doHeal > 0

		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end

		-- Trail particle
		local trail_pfx = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/bladekeeper_omnislash/_dc_juggernaut_omni_slash_trail.vpcf", PATTACH_CUSTOMORIGIN, parent )
		ParticleManager:SetParticleControl( trail_pfx, 0, parent:GetAbsOrigin() )
		ParticleManager:SetParticleControl( trail_pfx, 1, (  self.target:GetAbsOrigin() - parent:GetAbsOrigin() ):Normalized() * 300 )
		ParticleManager:ReleaseParticleIndex( trail_pfx )
	end

--------------------------------------------------------------------------------

	function modifier_sohei_palm_of_life_movement:OnDestroy()
		local parent = self:GetParent()

		parent:FadeGesture( ACT_DOTA_RUN )
		parent:RemoveHorizontalMotionController( self )
		ResolveNPCPositions( parent:GetAbsOrigin(), 128 )
	end

--------------------------------------------------------------------------------

	function modifier_sohei_palm_of_life_movement:UpdateHorizontalMotion( parent, deltaTime )
		local parentOrigin = parent:GetAbsOrigin()
		local targetOrigin = self.target:GetAbsOrigin()
		local dA = parentOrigin
		dA.z = 0
		local dB = targetOrigin
		dB.z = 0
		local direction = ( dB - dA ):Normalized()

		local tickSpeed = self.speed * deltaTime
		tickSpeed = math.min( tickSpeed, self.endDistance )
		local tickOrigin = parentOrigin + ( tickSpeed * direction )

		parent:SetAbsOrigin( tickOrigin )
		parent:FaceTowards( targetOrigin )

		GridNav:DestroyTreesAroundPoint( tickOrigin, self.tree_radius, false )

		local distance = parent:GetRangeToUnit( self.target )

		if distance <= self.endDistance then
			if self.doHeal then
				-- do the heal
				local spell = self:GetAbility()
				local healAmount = parent:GetHealth() * ( spell:GetSpecialValueFor( "hp_as_heal" ) / 100 )

				self.target:Heal( healAmount, parent )

				self.target:EmitSound( "Sohei.PalmOfLife.Heal" )

				local part = ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target )
				ParticleManager:SetParticleControl( part, 1, Vector( self.target:GetModelRadius(), 1, 1 ) )
				ParticleManager:ReleaseParticleIndex( part )

				SendOverheadEventMessage( nil, 10, self.target, healAmount, nil )

				-- undo momentum charge
				local modMomentum = parent:FindModifierByName( "modifier_sohei_momentum_passive" )

				if modMomentum and modMomentum:IsMomentumReady() then
					modMomentum:SetStackCount( 0 )
				end

				local spellMomentum = parent:FindAbilityByName( "sohei_momentum" )

				if spellMomentum then
					spellMomentum:EndCooldown()
					spellMomentum:UseResources( true, true, true )
				end
			end

			-- end it alllllll
			self:Destroy()
		end
	end

--------------------------------------------------------------------------------

	function modifier_sohei_palm_of_life_movement:OnHorizontalMotionInterrupted()
		self:Destroy()
	end
end

