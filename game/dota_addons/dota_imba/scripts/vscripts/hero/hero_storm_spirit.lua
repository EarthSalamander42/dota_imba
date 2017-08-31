-- Author: Fudge

CreateEmptyTalents("storm_spirit")
imba_storm_spirit_static_remnant = storm_spirit_static_remnant or class({})
LinkLuaModifier("modifier_imba_static_remnant", "hero/hero_storm_spirit.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------
---		    STATIC REMNANT		   ---
--------------------------------------

-- TODO: give it a animation
function imba_storm_spirit_static_remnant:OnSpellStart()
	if IsServer() then
		--Ability properties
		local caster				=	self:GetCaster()
		local cast_response			=	"stormspirit_ss_ability_static_0"
		local cast_sound			=	"Hero_StormSpirit.StaticRemnantPlant"
		--Ability paramaters
		local remnant_duration		=	self:GetSpecialValueFor("big_remnant_duration")
	
		--Play a random cast response 50% of the time
		if RollPercentage(50) and (caster:GetName() == "npc_dota_hero_storm_spirit") then 
			EmitSoundOn(cast_response..math.random(1,6),caster)
		end
		-- Play cast sound
		EmitSoundOn(cast_sound,caster)

		--Create remnant
		local dummy = CreateUnitByName( "npc_imba_dota_stormspirit_remnant", caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber() )
		-- Give it the necessary modifier
		dummy:AddNewModifier(caster, self, "modifier_imba_static_remnant", {duration = remnant_duration})

	end
end												

modifier_imba_static_remnant = modifier_imba_static_remnant or class({})

function modifier_imba_static_remnant:OnCreated()
	if IsServer() then

		--Ability properties
		self.ability			= 	self:GetAbility()
		self.caster				=	self:GetCaster()
		local remnant_particle	=	"particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf"
		self.caster_location	=	self.caster:GetAbsOrigin()
		self.dummy				=	self:GetParent()

		--Ability paramaters
		local activation_delay		=	self.ability:GetSpecialValueFor("big_remnant_activation_delay")
		local check_interval		=	self.ability:GetSpecialValueFor("explosion_check_interval")

		-- Create remnant in the location
		self.remnant_particle_fx = ParticleManager:CreateParticle(remnant_particle, PATTACH_ABSORIGIN, self.caster)
		ParticleManager:SetParticleControl(self.remnant_particle_fx, 0, self.caster_location)
		-- Make the remnant clone the hero
		ParticleManager:SetParticleControlEnt(self.remnant_particle_fx, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster_location, true)
		ParticleManager:SetParticleControl(self.remnant_particle_fx, 2, Vector(100, 1, 100) )
		ParticleManager:SetParticleControl(self.remnant_particle_fx, 11, self.caster_location)

		--Create a timer to delay the remnant explosion
		Timers:CreateTimer(activation_delay, function()
			--Start checking for nearby enemies
			self:StartIntervalThink(check_interval)
		end)
	end
end

function modifier_imba_static_remnant:OnIntervalThink()
	if IsServer() then

		--Ability properties
		local remnant_location 	=	self.dummy:GetAbsOrigin()
		--Ability paramaters
		local activation_range	=	self.ability:GetSpecialValueFor("big_remnant_activation_radius")

		--Find nearby enemies
		local nearby_enemies	=	FindUnitsInRadius(	self.caster:GetTeamNumber(),
		remnant_location,
		nil,
		activation_range,
		self.ability:GetAbilityTargetTeam(),
		self.ability:GetAbilityTargetType(),
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)
		--Blow up if there are nearby enemies
		if #nearby_enemies > 0 then
			self:Destroy()
		end
	end
end

function modifier_imba_static_remnant:OnDestroy()
	if IsServer() then
		--Ability properties
		local remnant_blowup_sound		=	"Hero_StormSpirit.StaticRemnantExplode"
		local remnant_location			=	self.dummy:GetAbsOrigin()
		--Ability paramaters
		local damage_radius				=	self.ability:GetSpecialValueFor("big_remnant_damage_radius")
		local damage					=	self.ability:GetSpecialValueFor("big_remnant_damage")

		--Emit blow up sound
		EmitSoundOn(remnant_blowup_sound,self.dummy)

		--Find nearby enemies
		local nearby_enemies	=	FindUnitsInRadius(	self.caster:GetTeamNumber(),
		remnant_location,
		nil,
		damage_radius,
		self.ability:GetAbilityTargetTeam(),
		self.ability:GetAbilityTargetType(),
		self.ability:GetAbilityTargetFlags(),
		FIND_ANY_ORDER, false)

		-- Damage nearby enemies
		for _,enemy in pairs(nearby_enemies) do
			-- Deal damage
			local damageTable = {victim = enemy,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				attacker = self.caster,
				ability = self.ability
			}

			ApplyDamage(damageTable)
		end

		--Get rid of the dummy
		ParticleManager:DestroyParticle(self.remnant_particle_fx, false)
		ParticleManager:ReleaseParticleIndex(self.remnant_particle_fx)
		UTIL_Remove(self.dummy)
	end
end

function modifier_imba_static_remnant:CheckState()
	local frozen_state	=	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}

	return frozen_state
end


function modifier_imba_static_remnant:DeclareFunctions()
	funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs
end

function modifier_imba_static_remnant:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_1
end

--------------------------------------
---		   ELECTRIC VORTEX		   ---
--------------------------------------
imba_storm_spirit_electric_vortex = storm_spirit_electric_vortex or class({})
LinkLuaModifier("modifier_imba_vortex_pull", "hero/hero_storm_spirit.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_vortex_self_slow", "hero/hero_storm_spirit.lua", LUA_MODIFIER_MOTION_NONE)

function imba_storm_spirit_electric_vortex:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster			=	self:GetCaster()
		local caster_loc		=	caster:GetAbsOrigin()
		local lingering_sound	=	"Hero_StormSpirit.ElectricVortex"
		local cast_sound		=	"Hero_StormSpirit.ElectricVortexCast"
		-- Ability paramaters															-- #1 TALENT: more pull duration
		local pull_duration			=	self:GetSpecialValueFor("pull_duration") + caster:FindTalentValue("special_bonus_imba_storm_spirit_1")
		local self_slow_duration	=	self:GetSpecialValueFor("self_slow_duration")	-- #2 TALENT: more pull speed
		local speed					=	self:GetSpecialValueFor("pull_units_per_second") + caster:FindTalentValue("special_bonus_imba_storm_spirit_2")

		-- Sound effect
		caster:EmitSound(cast_sound)
		EmitSoundOn(lingering_sound, caster)


		-- Apply pull slow side effect on caster
		caster:AddNewModifier(caster, self, "modifier_imba_vortex_self_slow",	{duration = self_slow_duration} )

		if not caster:HasScepter() then
			local target			=	self:GetCursorTarget()
			local direction 		= 	(caster:GetAbsOrigin() - target:GetAbsOrigin()):Normalized()

			-- Stop if target has linkens
			if target:TriggerSpellAbsorb(self) then return end

			-- Apply pull modifier on target
			target:AddNewModifier(caster, self, "modifier_imba_vortex_pull",		{duration = pull_duration, direction_x =direction.x, direction_y = direction.y, direction_z = direction.z, speed = speed} )

		else
			-- AGHANIM'S SCEPTER: Electric Vortex affects multiple targets around Storm.
			--Find nearby enemies
			local enemies	=	FindUnitsInRadius(	caster:GetTeamNumber(),
			caster_loc,
			nil,
			self:GetCastRange(),
			self:GetAbilityTargetTeam(),
			self:GetAbilityTargetType(),
			self:GetAbilityTargetFlags(),
			FIND_ANY_ORDER,
			false)

			-- Apply vortex on nearby enemies
			for _,enemy in pairs(enemies) do
				local direction 		= 	(caster:GetAbsOrigin() - enemy:GetAbsOrigin()):Normalized()
				-- Apply vortex on enemy
				enemy:AddNewModifier(caster, self, "modifier_imba_vortex_pull",		{duration = pull_duration, direction_x =direction.x, direction_y = direction.y, direction_z = direction.z, speed = speed} )
			end
		end

	end
end

function imba_storm_spirit_electric_vortex:GetCastRange()
	local caster	=	self:GetCaster()
	-- #2 TALENT: more pull range
	local talent_bonus	=	caster:FindTalentValue("special_bonus_imba_storm_spirit_2")
	if not caster:HasScepter() then
		return self:GetSpecialValueFor("cast_range") +  talent_bonus
	else
		-- AGHANIM'S SCEPTER: Electric Vortex has a aoe instead of a range
		return self:GetSpecialValueFor("scepter_radius") + talent_bonus
	end
end

function imba_storm_spirit_electric_vortex:GetBehavior()
	local caster	=	self:GetCaster()
	if not caster:HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	else
		-- AGHANIM'S SCEPTER: Electric Vortex is instant cast
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
end
--- PULL MODIFIER
modifier_imba_vortex_pull = modifier_imba_vortex_pull or class({})

-- Modifier properties
function modifier_imba_vortex_pull:IsHidden() 		  return false end
function modifier_imba_vortex_pull:IsPurgable() 	  return false end
function modifier_imba_vortex_pull:IsPurgeException() return true end
function modifier_imba_vortex_pull:IsDebuff() 		  return true end
function modifier_imba_vortex_pull:IsStunDebuff() 	  return true end
function modifier_imba_vortex_pull:IsMotionController() return true end
function modifier_imba_vortex_pull:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOW end

function modifier_imba_vortex_pull:OnCreated( params )
	if IsServer() then
		-- Ability properties
		local caster	=	self:GetCaster()
		local parent	=	self:GetParent()
		local vortex_particle	=	"particles/units/heroes/hero_stormspirit/stormspirit_electric_vortex.vpcf"

		self.vortex_loc	=	caster:GetAbsOrigin()
		-- Apply vortex particle on location
		self.vortex_particle_fx = ParticleManager:CreateParticle(vortex_particle, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(self.vortex_particle_fx, 0, caster:GetAbsOrigin())
		-- Apply vortex particle on target
		ParticleManager:SetParticleControlEnt(self.vortex_particle_fx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)

		-- Motion controller (moves the target)
		self.direction = Vector(params.direction_x, params.direction_y, params.direction_z)
		self.speed = params.speed * FrameTime()

		self.frametime = FrameTime()
		self:StartIntervalThink(self.frametime)
	end
end

function modifier_imba_vortex_pull:OnIntervalThink()
	-- Check for motion controllers
	if not self:CheckMotionControllers() then
		return nil
	end

	-- Horizontal motion
	self:HorizontalMotion(self:GetParent(), self.frametime)
end

function modifier_imba_vortex_pull:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		-- Find a clear space to stand on
		caster:SetUnitOnClearGround()
	end
end

function modifier_imba_vortex_pull:GetMotionControllerPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM
end

function modifier_imba_vortex_pull:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true
	}
	return state
end

function modifier_imba_vortex_pull:HorizontalMotion( unit, time )
	if IsServer() then

		-- Move the target 
		local set_point = unit:GetAbsOrigin() + self.direction * self.speed
		-- Stop moving when the vortex has been reached
		if (unit:GetAbsOrigin() - self.vortex_loc):Length2D() > 50 then
			unit:SetAbsOrigin(Vector(set_point.x, set_point.y, GetGroundPosition(set_point, unit).z))
		end

	end
end


function modifier_imba_vortex_pull:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return decFuncs
end

function modifier_imba_vortex_pull:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_imba_vortex_pull:OnDestroy()
	if IsServer() then
		-- Remove the vortex particle
		ParticleManager:DestroyParticle(self.vortex_particle_fx, false)
		ParticleManager:ReleaseParticleIndex(self.vortex_particle_fx)
		-- Stop making that noise
		StopSoundOn("Hero_StormSpirit.ElectricVortex",self:GetParent())

		-- Find a clear space to stand on
		self:GetParent():SetUnitOnClearGround()

	end
end

--- SELF SLOW MODIFIER
modifier_imba_vortex_self_slow = modifier_imba_vortex_self_slow or class({})

-- Modifier properties
function modifier_imba_vortex_pull:IsHidden() 		  return false end
function modifier_imba_vortex_pull:IsPurgable() 	  return true end
function modifier_imba_vortex_pull:IsDebuff() 		  return true end

function modifier_imba_vortex_self_slow:DeclareFunctions()
	local funcs ={
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_imba_vortex_self_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("self_slow")
end

--------------------------------------
---		   	  OVERLOAD		       ---
--------------------------------------
imba_storm_spirit_overload = imba_storm_spirit_overload or class({})
LinkLuaModifier("modifier_imba_overload", 			"hero/hero_storm_spirit.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_overload_buff", 		"hero/hero_storm_spirit.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_overload_debuff", 	"hero/hero_storm_spirit.lua", LUA_MODIFIER_MOTION_NONE)

function imba_storm_spirit_overload:GetIntrinsicModifierName()
	return "modifier_imba_overload"
end

function imba_storm_spirit_overload:GetAbilityTextureName()
	return "storm_spirit_overload"
end

--- OVERLOAD PASSIVE MODIFIER
modifier_imba_overload = modifier_imba_overload or class({})

-- Modifier properties
function modifier_imba_overload:IsPassive() return true end
function modifier_imba_overload:IsDebuff() return false end
function modifier_imba_overload:IsHidden() return true end
function modifier_imba_overload:IsPurgable() return false end
function modifier_imba_overload:RemoveOnDeath() return true end

function modifier_imba_overload:DeclareFunctions()
	local funcs	=	{
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
	return funcs
end

function modifier_imba_overload:OnAbilityExecuted( keys )
	if IsServer() then
		if keys.ability then
			-- When an actual ability was executed
			local parent =	self:GetParent()
			-- When the attacker is Storm then
			if keys.unit == parent then
				-- Doesn't work when Storm is broken
				if not parent:PassivesDisabled() then
					-- Ignore toggles and items
					if ( not keys.ability:IsItem() and not keys.ability:IsToggle() )  then

						parent:AddNewModifier(parent, self:GetAbility(), "modifier_imba_overload_buff",	{} )
					end
				end
			end
		end
	end
end


--------------------------------
--- OVERLOAD "ACTIVE" MODIFIER
--------------------------------
modifier_imba_overload_buff = modifier_imba_overload_buff or class({})

-- Modifier properties
function modifier_imba_overload_buff:IsDebuff() return false end
function modifier_imba_overload_buff:IsHidden() return false end
function modifier_imba_overload_buff:IsPurgable() return true end

function modifier_imba_overload_buff:OnCreated()
	if IsServer() then
		-- Attach the particle to Storm
		local parent	=	self:GetParent()
		local particle	=	"particles/units/heroes/hero_stormspirit/stormspirit_overload_ambient.vpcf"
		self.particle_fx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, parent)
		ParticleManager:SetParticleControlEnt(self.particle_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true)

	end
end

function modifier_imba_overload_buff:DeclareFunctions()
	local funcs ={
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
	return funcs
end

function modifier_imba_overload_buff:OnAttackLanded( keys )
	if IsServer() then
		-- When someone affected by overload buff has attacked
		if keys.attacker == self:GetParent() then
			-- Does not proc when attacking buildings or allies
			if not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= keys.attacker:GetTeamNumber() then

				-- Ability properties
				local parent	=	self:GetParent()
				local ability	=	self:GetAbility()
				local particle	=	"particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf"
				-- Ability paramaters
				local radius 		=	ability:GetSpecialValueFor("aoe")
				local damage		=	ability:GetSpecialValueFor("damage")
				local slow_duration	=	ability:GetSpecialValueFor("slow_duration")

				-- Find enemies around the target
				local enemies	=	FindUnitsInRadius(	parent:GetTeamNumber(),
				keys.target:GetAbsOrigin(),
				nil,
				radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				ability:GetAbilityTargetFlags(),
				FIND_ANY_ORDER,
				false)

				-- Damage and apply slow to enemies near target
				for _,enemy in pairs(enemies) do

					-- Deal damage
					local damageTable = {victim = enemy,
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						attacker = parent,
						ability = ability
					}

					ApplyDamage(damageTable)

					-- Apply debuff
					enemy:AddNewModifier(parent, ability, "modifier_imba_overload_debuff",	{duration = slow_duration} )

					-- Emit particle
					local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, parent)
					ParticleManager:SetParticleControl(particle_fx, 0, keys.target:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(particle_fx)
					-- Remove overload buff
					self:Destroy()
				end
			end
		end
	end
end

function modifier_imba_overload_buff:GetActivityTranslationModifiers()
	if self:GetParent():GetName() == "npc_dota_hero_storm_spirit" then
		--return ACT_STORM_SPIRIT_OVERLOAD_RUN_OVERRIDE
		return "overload"
	end
	return 0
end

function modifier_imba_overload_buff:GetOverrideAnimation()
	return ACT_STORM_SPIRIT_OVERLOAD_RUN_OVERRIDE
end

function modifier_imba_overload_buff:OnDestroy()
	if IsServer() then
		-- Remove the particle
		ParticleManager:DestroyParticle(self.particle_fx, false)
		ParticleManager:ReleaseParticleIndex(self.particle_fx)
	end
end

--- OVERLOAD DEBUFF MODIFIER
modifier_imba_overload_debuff = modifier_imba_overload_debuff or class({})

-- Modifier properties
function modifier_imba_overload_debuff:IsDebuff() return true end
function modifier_imba_overload_debuff:IsHidden() return false end
function modifier_imba_overload_debuff:IsPurgable() return true end

function modifier_imba_overload_debuff:OnCreated()
	-- Ability properties
	local ability	=	self:GetAbility()
	-- Ability parmameters
	self.move_slow		=	ability:GetSpecialValueFor("move_slow")
	self.attack_slow	=	ability:GetSpecialValueFor("attack_slow")
end

function modifier_imba_overload_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

-- Slow functions
function modifier_imba_overload_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.move_slow
end

function modifier_imba_overload_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attack_slow
end

--------------------------------
--- 	 BALL LIGHTNING      ---
--------------------------------
imba_storm_spirit_ball_lightning = imba_storm_spirit_ball_lightning or class({})
LinkLuaModifier("modifier_imba_ball_lightning", "hero/hero_storm_spirit.lua", LUA_MODIFIER_MOTION_NONE)

function imba_storm_spirit_ball_lightning:OnSpellStart()
	if IsServer() then
		-- Prevent some stupid shit that happens when you try to zip while already zipping
		if self:GetCaster():FindModifierByName("modifier_imba_ball_lightning") then
			self:RefundManaCost()
			return
		end

		-- Ability properties
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()
		-- Ability parameters
		local speed 			=	self:GetSpecialValueFor("ball_speed")
		local damage_radius 	= 	self:GetSpecialValueFor("damage_radius")
		local vision 			= 	self:GetSpecialValueFor("ball_vision_radius")
		local tree_radius 		= 	100
		local damage 			= 	self:GetSpecialValueFor("damage_per_100_units")
		local base_mana_cost	= 	self:GetSpecialValueFor("travel_mana_cost_base")
		local pct_mana_cost		= 	self:GetSpecialValueFor("travel_mana_cost_pct") * caster:GetMaxMana()
		local total_mana_cost 	=	base_mana_cost + pct_mana_cost
		local max_spell_amp_range	=	self:GetSpecialValueFor("max_spell_amp_range")

		-- Motion control properties
		self.traveled 	= 0
		self.distance 	= (target_loc - caster_loc):Length2D()
		self.direction 	= (target_loc - caster_loc):Normalized()

		-- Play the cast sound
		caster:EmitSound("Hero_StormSpirit.BallLightning")
		caster:EmitSound("Hero_StormSpirit.BallLightning.Loop")

		-- Fire the ball of death!
		local projectile = 
		{
			Ability				= self,
			EffectName			= "particles/hero/storm_spirit/no_particle_particle.vpcf",
			vSpawnOrigin		= caster_loc,
			fDistance			= self.distance,
			fStartRadius		= damage_radius,
			fEndRadius			= damage_radius,
			Source				= caster,
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= self:GetAbilityTargetTeam(),
			iUnitTargetFlags	= self:GetAbilityTargetFlags(),
			iUnitTargetType		= self:GetAbilityTargetType(),
			bDeleteOnHit		= false,
			vVelocity 			= self.direction * speed * Vector(1, 1, 0),
			bProvidesVision		= true,
			iVisionRadius 		= vision,
			iVisionTeamNumber 	= caster:GetTeamNumber(),
			ExtraData			= {damage = damage,
								   tree_radius = tree_radius,
								   base_mana_cost = base_mana_cost,
								   pct_mana_cost = pct_mana_cost,
								   total_mana_cost = total_mana_cost,
								   speed = speed * FrameTime(),
								   max_spell_amp_range = max_spell_amp_range
								}
		}
		self.projectileID = ProjectileManager:CreateLinearProjectile(projectile)
                  
		-- Add Motion-Controller Modifier
		caster:AddNewModifier(caster, self, "modifier_imba_ball_lightning", {})

	end
end

function imba_storm_spirit_ball_lightning:OnProjectileThink_ExtraData(location, ExtraData)
	-- Move the caster as long as he has not reached the distance he wants to go to, and he still has enough mana
	local caster = self:GetCaster()
	if (self.traveled + ExtraData.speed < self.distance) and caster:IsAlive() and (caster:GetMana() > ExtraData.total_mana_cost * 0.01 ) then

		-- Destroy the trees in the way
		GridNav:DestroyTreesAroundPoint(location, ExtraData.tree_radius, false)

		-- Set the caster slightly forwards
		caster:SetAbsOrigin(Vector(location.x, location.y, GetGroundPosition(location, caster).z))

		-- Calculate the new travel distance
		self.traveled = self.traveled + ExtraData.speed

		self.units_traveled_in_last_tick = ExtraData.speed

		-- Use up mana for traveling
		caster:ReduceMana(( (ExtraData.pct_mana_cost * 0.01) + ExtraData.base_mana_cost ) * self.units_traveled_in_last_tick * 0.01)
		-- Note: the last *0.01 in the calculation is because the manacost is calculated for every 100 units.

		-- Once the caster can no longer travel, remove this projectile
	else
		-- Emit end response
		local responses = {"stormspirit_ss_ability_lightning_04", "stormspirit_ss_ability_lightning_05", "stormspirit_ss_ability_lightning_06", "stormspirit_ss_ability_lightning_07",
			"stormspirit_ss_ability_lightning_08", "stormspirit_ss_ability_lightning_09", "stormspirit_ss_ability_lightning_10", "stormspirit_ss_ability_lightning_13",
			"stormspirit_ss_ability_lightning_14", "stormspirit_ss_ability_lightning_18", "stormspirit_ss_ability_lightning_20", "stormspirit_ss_ability_lightning_21",
			"stormspirit_ss_ability_lightning_22", "stormspirit_ss_ability_lightning_23", "stormspirit_ss_ability_lightning_24", "stormspirit_ss_ability_lightning_25",
			"stormspirit_ss_ability_lightning_26", "stormspirit_ss_ability_lightning_27", "stormspirit_ss_ability_lightning_28", "stormspirit_ss_ability_lightning_29",
			"stormspirit_ss_ability_lightning_30", "stormspirit_ss_ability_lightning_31", "stormspirit_ss_ability_lightning_32",
		}
		if caster:GetName() == "npc_dota_hero_storm_spirit" then
			caster:EmitCasterSound("npc_dota_hero_storm_spirit",responses, 100, DOTA_CAST_SOUND_FLAG_BOTH_TEAMS, nil, nil)
		end

		-- Find a clear space to stand on
		caster:SetUnitOnClearGround()

		caster:StopSound("Hero_StormSpirit.BallLightning.Loop")

		-- Get rid of the Ball
		caster:FindModifierByName("modifier_imba_ball_lightning"):Destroy()
		ProjectileManager:DestroyLinearProjectile(self.projectileID)
			
	end
end

function imba_storm_spirit_ball_lightning:OnProjectileHit_ExtraData(target, location, ExtraData)
	if IsServer() then
		if target then 

	 		local caster	=	self:GetCaster()
	 		local damage		=	ExtraData.damage * math.floor(self.traveled * 0.01)
	 		local damage_flags 	= 	DOTA_DAMAGE_FLAG_NONE

	 		-- Prevent spell amp at large distances
	 		if self.traveled > ExtraData.max_spell_amp_range then
	 			damage_flags = damage_flags + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION

	 			local damage_at_max_distance =  ExtraData.damage * ExtraData.max_spell_amp_range * 0.01 * (1 + (caster:GetSpellPower() * 0.01))
	 			
	 			-- If you are doing less damage because you went slightly more than the max range, set the damage to how much it would be at max range.
	 			if damage < damage_at_max_distance then
	 				damage	= damage_at_max_distance
	 			end
	 		end

			-- Deal damage
			local damageTable = {victim = target,
								damage = damage,
								damage_type = self:GetAbilityDamageType(),
								attacker = caster,
								ability = ability,
								damage_flags = damage_flags
								}

			ApplyDamage(damageTable)

			-- Emit rare kill response
				if not target:IsAlive() then
				local responses = {"stormspirit_ss_ability_lightning_01", "stormspirit_ss_ability_lightning_03"}
				if caster:GetName() == "npc_dota_hero_storm_spirit" and RollPercentage(10) then
					caster:EmitCasterSound("npc_dota_hero_storm_spirit",responses, 100, DOTA_CAST_SOUND_FLAG_BOTH_TEAMS, nil, nil)
				end
			end
		end
	end
end

-- Custom mana cost for Ball Lightning
function imba_storm_spirit_ball_lightning:GetManaCost()
	local caster	=	self:GetCaster()
	local base_cost	= 	self:GetSpecialValueFor("initial_mana_cost_base")
	local pct_cost 	=	self:GetSpecialValueFor("initial_mana_cost_pct")

	return (base_cost +( caster:GetMaxMana() * pct_cost * 0.01 ))
end

--- BALL LIGHTNING MODIFIER
modifier_imba_ball_lightning = modifier_imba_ball_lightning or class({})

-- Modifier properties
function modifier_imba_ball_lightning:IsDebuff() 	return false end
function modifier_imba_ball_lightning:IsHidden() 	return false end
function modifier_imba_ball_lightning:IsPurgable() return false end

function modifier_imba_ball_lightning:GetEffectName()
	return "particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf"
end

function modifier_imba_ball_lightning:GetEffectAttachType()
	-- Yep, this is a thing.
	return PATTACH_ROOTBONE_FOLLOW
end

function modifier_imba_ball_lightning:CheckState()
	local state	=	{
		[MODIFIER_STATE_INVULNERABLE] = true
	}
	return state
end

function modifier_imba_ball_lightning:DeclareFunctions()
	local funcs	=	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs
end

function modifier_imba_ball_lightning:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_4
end


-- Rubick shit
function imba_storm_spirit_static_remnant:IsHiddenWhenStolen() return false end
function imba_storm_spirit_electric_vortex:IsHiddenWhenStolen() return false end
function imba_storm_spirit_ball_lightning:IsHiddenWhenStolen() return false end

