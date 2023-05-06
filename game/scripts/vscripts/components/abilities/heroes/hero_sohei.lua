-- Author:
--		Firetoad

-- Editors:
--     Baumi

-- Custom hero system
--		EarthSalamander #42

-- Model:
--		Carlos RPG

sohei_dash = sohei_dash or class ({})

LinkLuaModifier( "modifier_sohei_dash_movement", "components/abilities/heroes/hero_sohei.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier("modifier_generic_charges", "components/modifiers/generic/modifier_generic_charges", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function sohei_dash:GetIntrinsicModifierName()
	return "modifier_generic_charges"
end

--------------------------------------------------------------------------------

if IsServer() then
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
		local dashDistance = self:GetSpecialValueFor( "dash_distance" )
		local dashSpeed = self:GetSpecialValueFor( "dash_speed" )

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
end

--------------------------------------------------------------------------------

-- Dash movement modifier
modifier_sohei_dash_movement = modifier_sohei_dash_movement or class ({})

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


function sohei_flurry_of_blows:GetAssociatedSecondaryAbilities()
	return "sohei_momentum"
end

--------------------------------------------------------------------------------

-- Cast animation + playback rate
function sohei_flurry_of_blows:GetCastAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_2
end

function sohei_flurry_of_blows:GetPlaybackRateOverride()
	return 1.2
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
		caster:AddNewModifier(caster, self, "modifier_sohei_flurry_self", {
			duration = max_duration,
			max_attacks = max_attacks,
			flurry_radius = flurry_radius,
			attack_interval = attack_interval
		})
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
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ROOTED] = true
	}
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
		caster:RemoveNoDraw()
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
			local abilityMomentum = parent:FindAbilityByName( "sohei_momentum" )
			local distance = 50

			parent:RemoveNoDraw()

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

			-- Remove if the ability is passive
			if abilityMomentum and abilityMomentum:GetLevel() > 0 then
				if not abilityMomentum:GetToggleState() then
					abilityMomentum:ToggleAbility()
				end
			end

			parent:PerformAttack( targets[1], true, true, true, false, false, false, false )

			return true
		-- Else, return false and keep meditating
		else
			parent:AddNoDraw()
			parent:SetAbsOrigin(self.position)
			parent:StartGestureWithPlaybackRate(ACT_DOTA_OVERRIDE_ABILITY_2 , 0.5)

			return false
		end
	end
end

sohei_wholeness_of_body = class({})

LinkLuaModifier("modifier_sohei_wholeness_of_body_handler", "components/abilities/heroes/hero_sohei", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sohei_wholeness_of_body_status", "components/abilities/heroes/hero_sohei.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sohei_wholeness_of_body_knockback", "components/abilities/heroes/hero_sohei.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

function sohei_wholeness_of_body:GetCastRange(location, target)
	return self:GetSpecialValueFor("knockback_radius") - self:GetCaster():GetCastRangeBonus()
end

function sohei_wholeness_of_body:GetIntrinsicModifierName()
	return "modifier_sohei_wholeness_of_body_handler"
end

function sohei_wholeness_of_body:GetBehavior()
	local caster = self:GetCaster()
--	caster:HasTalent(...) will return true on the client only when OnPlayerLearnedAbility event happens
--	caster:HasModifier(...) will return true on the client only if the talent is leveled up with aghanim scepter
	if caster:HasTalent("special_bonus_imba_sohei_wholeness_allycast") or caster:HasModifier("modifier_special_bonus_imba_sohei_wholeness_allycast") then
		if self:GetCaster():GetModifierStackCount("modifier_sohei_wholeness_of_body_handler", self:GetCaster()) == 0 then
			return tonumber(tostring(self.BaseClass.GetBehavior(self))) + DOTA_ABILITY_BEHAVIOR_AUTOCAST
		else
			return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
		end
	end
	
	return self.BaseClass.GetBehavior(self)
end
--------------------------------------------------------------------------------

-- function sohei_wholeness_of_body:CastFilterResultTarget( target )
	-- local default_result = self.BaseClass.CastFilterResultTarget(self, target)
	-- return default_result
-- end

function sohei_wholeness_of_body:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() or caster
	-- Activation sound
	target:EmitSound("Sohei.Guard")
	-- Basic Dispel
	target:Purge(false, true, false, false, false)
	-- Applying the buff
	target:AddNewModifier(caster, self, "modifier_sohei_wholeness_of_body_status", {duration = self:GetTalentSpecialValueFor("sr_duration")})
	-- -- Knockback talent
	-- if caster:HasTalent("special_bonus_sohei_wholeness_knockback") then
		-- local position = target:GetAbsOrigin()
		-- local radius = caster:FindTalentValue("special_bonus_sohei_wholeness_knockback")
		-- local team = caster:GetTeamNumber()
		-- local enemies = FindUnitsInRadius(team, position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		-- for _, enemy in ipairs( enemies ) do
			-- local modifierKnockback = {
				-- center_x = position.x,
				-- center_y = position.y,
				-- center_z = position.z,
				-- duration = caster:FindTalentValue("special_bonus_sohei_wholeness_knockback", "duration"),
				-- knockback_duration = caster:FindTalentValue("special_bonus_sohei_wholeness_knockback", "duration"),
				-- knockback_distance = radius - (position - enemy:GetAbsOrigin()):Length2D(),
			-- }

			-- enemy:AddNewModifier(caster, self, "modifier_knockback", modifierKnockback ) 
		-- end 
	-- end
	
	local momentum_ability = self:GetCaster():FindAbilityByName("sohei_momentum")
	
	if momentum_ability and momentum_ability:IsTrained() then
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("knockback_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)) do
			enemy:RemoveModifierByName( "modifier_sohei_momentum_knockback" )
			enemy:AddNewModifier( self:GetCaster(), momentum_ability, "modifier_sohei_momentum_knockback", {
				duration = momentum_ability:GetSpecialValueFor("knockback_distance") / momentum_ability:GetSpecialValueFor("knockback_speed"),
				distance = momentum_ability:GetSpecialValueFor("knockback_distance"),
				speed = momentum_ability:GetSpecialValueFor("knockback_speed"),
				collision_radius = momentum_ability:GetSpecialValueFor("collision_radius"),
				source_entindex = target:entindex()
			} )
		end
	end
end

--------------------------------------------------------------------------------

-- wholeness_of_body modifier
modifier_sohei_wholeness_of_body_status = class({})
--------------------------------------------------------------------------------

function modifier_sohei_wholeness_of_body_status:IsDebuff()
	return false
end

function modifier_sohei_wholeness_of_body_status:IsHidden()
	return false
end

function modifier_sohei_wholeness_of_body_status:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

-- function modifier_sohei_wholeness_of_body_status:GetEffectName()
	-- return "particles/hero/sohei/guard.vpcf"
-- end

-- function modifier_sohei_wholeness_of_body_status:GetEffectAttachType()
	-- return PATTACH_ABSORIGIN_FOLLOW
-- end

function modifier_sohei_wholeness_of_body_status:OnCreated()
	local ability = self:GetAbility()
	self.status_resistance = ability:GetTalentSpecialValueFor("status_resistance")
	self.damageheal = ability:GetTalentSpecialValueFor("damage_taken_heal") / 100
	self.endHeal = 0
	
	if not IsServer() then return end
	
	self.wholeness_particle = ParticleManager:CreateParticle("particles/hero/sohei/guard.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.wholeness_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(self.wholeness_particle, false, false, -1, false, false)
end

function modifier_sohei_wholeness_of_body_status:OnRefresh()
	local ability = self:GetAbility()
	self.status_resistance = ability:GetTalentSpecialValueFor("status_resistance")
	self.damageheal = ability:GetTalentSpecialValueFor("damage_taken_heal") / 100
end

function modifier_sohei_wholeness_of_body_status:OnDestroy()
	if IsServer() then
		self:GetParent():Heal(self.endHeal + self:GetAbility():GetTalentSpecialValueFor("post_heal"), self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self.endHeal + self:GetAbility():GetTalentSpecialValueFor("post_heal"), nil)
	end
end

--------------------------------------------------------------------------------

function modifier_sohei_wholeness_of_body_status:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_sohei_wholeness_of_body_status:GetModifierStatusResistance( )
	return self.status_resistance
end

function modifier_sohei_wholeness_of_body_status:OnTakeDamage( params )
	if params.unit == self:GetParent() then
		self.endHeal = self.endHeal + params.damage * self.damageheal
	end
end

LinkLuaModifier("modifier_special_bonus_imba_sohei_wholeness_allycast", "components/abilities/heroes/hero_sohei.lua", LUA_MODIFIER_MOTION_NONE)

if modifier_special_bonus_imba_sohei_wholeness_allycast == nil then
	modifier_special_bonus_imba_sohei_wholeness_allycast = class({})
end

function modifier_special_bonus_imba_sohei_wholeness_allycast:IsHidden()
	return true
end

function modifier_special_bonus_imba_sohei_wholeness_allycast:IsPurgable()
	return false
end

function modifier_special_bonus_imba_sohei_wholeness_allycast:AllowIllusionDuplicate()
	return false
end

function modifier_special_bonus_imba_sohei_wholeness_allycast:RemoveOnDeath()
	return false
end

function modifier_special_bonus_imba_sohei_wholeness_allycast:OnCreated()
	if not IsServer() then return end
	
	if self:GetParent():HasAbility("sohei_wholeness_of_body") then
		self:GetParent():FindAbilityByName("sohei_wholeness_of_body"):ToggleAutoCast()
		
		if self:GetParent():HasModifier("modifier_sohei_wholeness_of_body_handler") then
			self:GetParent():FindModifierByName("modifier_sohei_wholeness_of_body_handler"):SetStackCount(1)
		end
	end
end

function sohei_wholeness_of_body:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_sohei_wholeness_allycast") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_sohei_wholeness_allycast") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_sohei_wholeness_allycast"), "modifier_special_bonus_imba_sohei_wholeness_allycast", {})
	end
end

----------------------------------------------
-- MODIFIER_SOHEI_WHOLENESS_OF_BODY_HANDLER --
----------------------------------------------

modifier_sohei_wholeness_of_body_handler	= modifier_sohei_wholeness_of_body_handler or class({})

function modifier_sohei_wholeness_of_body_handler:IsHidden()		return true end
function modifier_sohei_wholeness_of_body_handler:IsPurgable()		return false end
function modifier_sohei_wholeness_of_body_handler:RemoveOnDeath()	return false end
function modifier_sohei_wholeness_of_body_handler:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_sohei_wholeness_of_body_handler:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_sohei_wholeness_of_body_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end
	
	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
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
	-- if self:GetParent():IsIllusion() or self:GetParent():HasModifier("modifier_illusion_manager") then return end
	self:GetAbility().intrMod = self

	self.parentOrigin = self:GetParent():GetAbsOrigin()
	self.attackPrimed = false -- necessary for cases when sohei starts an attack while moving
	-- i.e. force staff
	-- and gets charged before the attack finishes, causing an attack with knockback but no crit
	
	-- Set this to default on for accessibility's sake
	if IsServer() and self:GetAbility() then
		self:GetAbility():ToggleAutoCast()
	end
	
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

			-- if self:GetParent():IsIllusion() then
				-- return nil
			-- end

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
				spell:UseResources(false, false, false, true)
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

		local difference = nil
		
		if not event.source_entindex then
			difference = unit:GetAbsOrigin() - caster:GetAbsOrigin()
		else
			difference = unit:GetAbsOrigin() - EntIndexToHScript(event.source_entindex):GetAbsOrigin()
		end

		-- Movement parameters
		self.direction = difference:Normalized()
		self.distance = event.distance
		self.speed = event.speed
		self.collision_radius = event.collision_radius
		
		self.slow_duration	= self:GetAbility():GetTalentSpecialValueFor("slow_duration")
		self.stun_duration	= self:GetAbility():GetTalentSpecialValueFor("stun_duration")
		
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
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false
		)

		local secondary_target = targets[1]
		if secondary_target == parent then
			secondary_target = targets[2]
		end

		local spell = self:GetAbility()
		
		if secondary_target then
			self:SlowAndStun( parent, caster, spell )
			self:SlowAndStun( secondary_target, caster, spell )
			self:Destroy()
		-- why do these mean two different things
		elseif not GridNav:IsTraversable( tickOrigin ) or GridNav:IsBlocked( tickOrigin ) or GridNav:IsNearbyTree( tickOrigin, self:GetParent():GetHullRadius(), true ) then
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
			duration = self.slow_duration * (1 - unit:GetStatusResistance()),
		} )

		-- local talent = caster:FindAbilityByName( "special_bonus_sohei_stun" )

		-- if talent and talent:GetLevel() > 0 then
			-- local stunDuration = talent:GetSpecialValueFor("value")

			-- unit:AddNewModifier( caster, ability, "modifier_stunned", {
				-- duration = stunDuration
			-- } )
		-- end
		unit:AddNewModifier( caster, ability, "modifier_stunned", {
			duration = self.stun_duration * (1 - unit:GetStatusResistance()),
		} )
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

function modifier_sohei_momentum_slow:GetTexture()
	if self:GetAbility() then
		return self:GetAbility().BaseClass.GetAbilityTextureName( self:GetAbility() )
	end
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
		local modifier_charges = caster:FindModifierByName( "modifier_generic_charges" )

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
		
		local modMomentum = caster:FindModifierByName( "modifier_sohei_momentum_passive" )
		local spellMomentum = caster:FindAbilityByName( "sohei_momentum" )

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
			doHeal = 1
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
					spellMomentum:UseResources(false, false, false, true)
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

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_sohei_wholeness_of_body_heal", "components/abilities/heroes/hero_sohei", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_sohei_wholeness_of_body_heal		= modifier_special_bonus_imba_sohei_wholeness_of_body_heal or class({})

function modifier_special_bonus_imba_sohei_wholeness_of_body_heal:IsHidden() 		return true end
function modifier_special_bonus_imba_sohei_wholeness_of_body_heal:IsPurgable()		return false end
function modifier_special_bonus_imba_sohei_wholeness_of_body_heal:RemoveOnDeath() 	return false end
