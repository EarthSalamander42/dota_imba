  --[[	
		Author: AtroCty
		Date: 17.04.2017	
	]]

--CreateEmptyTalents("rubick")

-------------------------------------------
--			TRANSPOSITION
-------------------------------------------
LinkLuaModifier("modifier_imba_telekinesis", "hero/hero_rubick", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_imba_telekinesis_stun", "hero/hero_rubick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_telekinesis_root", "hero/hero_rubick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_telekinesis_caster", "hero/hero_rubick", LUA_MODIFIER_MOTION_NONE)

imba_rubick_telekinesis = class({})
function imba_rubick_telekinesis:IsHiddenWhenStolen() return false end
function imba_rubick_telekinesis:IsRefreshable() return true end
function imba_rubick_telekinesis:IsStealable() return true end
function imba_rubick_telekinesis:IsNetherWardStealable() return true end
-------------------------------------------

function imba_rubick_telekinesis:OnSpellStart( params )
	local caster = self:GetCaster()
	-- Handler on lifted targets
	if caster:HasModifier("modifier_imba_telekinesis_caster") then
		local target_loc = self:GetCursorPosition()
		-- Parameters
		local maximum_distance
		if self.target:GetTeam() == caster:GetTeam() then
			maximum_distance = self:GetSpecialValueFor("ally_range") + GetCastRangeIncrease(caster)
		else
			maximum_distance = self:GetSpecialValueFor("enemy_range") + GetCastRangeIncrease(caster)
		end
		
		if self.telekinesis_marker_pfx then
			ParticleManager:DestroyParticle(self.telekinesis_marker_pfx, false)
			ParticleManager:ReleaseParticleIndex(self.telekinesis_marker_pfx)
		end
		
		-- If the marked distance is too great, limit it
		local marked_distance = (target_loc - self.target_origin):Length2D()
		if marked_distance > maximum_distance then
			target_loc = self.target_origin + (target_loc - self.target_origin):Normalized() * maximum_distance
		end
		
		-- Draw marker particle
		self.telekinesis_marker_pfx = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_rubick/rubick_telekinesis_marker.vpcf", PATTACH_CUSTOMORIGIN, caster, caster:GetTeam())
		ParticleManager:SetParticleControl(self.telekinesis_marker_pfx, 0, target_loc)
		ParticleManager:SetParticleControl(self.telekinesis_marker_pfx, 1, Vector(3, 0, 0))
		ParticleManager:SetParticleControl(self.telekinesis_marker_pfx, 2, self.target_origin)
		ParticleManager:SetParticleControl(self.target_modifier.tele_pfx, 1, target_loc)
		
		self.target_modifier.final_loc = target_loc
		self.target_modifier.changed_target = true
		self:EndCooldown()
	-- Handler on regular 
	else
		-- Parameters
		self.target = self:GetCursorTarget()
		self.target_origin = self.target:GetAbsOrigin()
		
		local duration
		local is_ally = true
		-- Create modifier and check Linken
		if self.target:GetTeam() ~= caster:GetTeam() then
			
			if self.target:TriggerSpellAbsorb(self) then
				return nil
			end
			
			duration = self:GetSpecialValueFor("enemy_lift_duration")
			self.target:AddNewModifier(caster, self, "modifier_imba_telekinesis_stun", { duration = duration })
			is_ally = false
		else
			duration = self:GetSpecialValueFor("ally_lift_duration")
			self.target:AddNewModifier(caster, self, "modifier_imba_telekinesis_root", { duration = duration})
		end
		
		self.target_modifier = self.target:AddNewModifier(caster, self, "modifier_imba_telekinesis", { duration = duration })
		
		if is_ally then
			self.target_modifier.is_ally = true
		end
		
		-- Add the particle & sounds
		self.target_modifier.tele_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_telekinesis.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(self.target_modifier.tele_pfx, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.target_modifier.tele_pfx, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.target_modifier.tele_pfx, 2, Vector(duration,0,0))
		self.target_modifier:AddParticle(self.target_modifier.tele_pfx, false, false, 1, false, false)
		caster:EmitSound("Hero_Rubick.Telekinesis.Cast")
		self.target:EmitSound("Hero_Rubick.Telekinesis.Target")
		
		-- Modifier-Params
		self.target_modifier.final_loc = self.target_origin
		self.target_modifier.changed_target = false
		-- Add caster handler
		caster:AddNewModifier(caster, self, "modifier_imba_telekinesis_caster", { duration = duration + FrameTime()})
		
		self:EndCooldown()
	end
end

function imba_rubick_telekinesis:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_telekinesis_caster") then
		return "rubick_telekinesis_land"
	end
	return "rubick_telekinesis"
end

function imba_rubick_telekinesis:GetBehavior()
	if self:GetCaster():HasModifier("modifier_imba_telekinesis_caster") then
		return DOTA_ABILITY_BEHAVIOR_POINT
	end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end

function imba_rubick_telekinesis:GetManaCost( target )
	if self:GetCaster():HasModifier("modifier_imba_telekinesis_caster") then
		return 0
	else
		return self.BaseClass.GetManaCost(self, target)
	end
end

function imba_rubick_telekinesis:GetCastRange( location , target)
	if self:GetCaster():HasModifier("modifier_imba_telekinesis_caster") then
		return 25000
	end
	return self.BaseClass.GetCastRange(self,location,target)
end

function imba_rubick_telekinesis:CastFilterResultTarget( target )
	if IsServer() then
		local caster = self:GetCaster()
		local casterID = caster:GetPlayerOwnerID()
		local targetID = target:GetPlayerOwnerID()

		if target ~= nil and not target:IsOpposingTeam(caster:GetTeamNumber()) and PlayerResource:IsDisableHelpSetForPlayerID(targetID,casterID) then
			return UF_FAIL_DISABLE_HELP
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

-------------------------------------------
modifier_imba_telekinesis_caster = class({})
function modifier_imba_telekinesis_caster:IsDebuff() return false end
function modifier_imba_telekinesis_caster:IsHidden() return true end
function modifier_imba_telekinesis_caster:IsPurgable() return false end
function modifier_imba_telekinesis_caster:IsPurgeException() return false end
function modifier_imba_telekinesis_caster:IsStunDebuff() return false end
-------------------------------------------

function modifier_imba_telekinesis_caster:OnDestroy()
	local ability = self:GetAbility()
	if ability.telekinesis_marker_pfx then
		ParticleManager:DestroyParticle(ability.telekinesis_marker_pfx, false)
		ParticleManager:ReleaseParticleIndex(ability.telekinesis_marker_pfx)
	end
end

-------------------------------------------
modifier_imba_telekinesis = class({})
function modifier_imba_telekinesis:IsDebuff() 
	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then return true end
	return false 
end
function modifier_imba_telekinesis:IsHidden() return false end
function modifier_imba_telekinesis:IsPurgable() return false end
function modifier_imba_telekinesis:IsPurgeException() return false end
function modifier_imba_telekinesis:IsStunDebuff() return false end
function modifier_imba_telekinesis:IgnoreTenacity() return true end
function modifier_imba_telekinesis:IsMotionController() return true end
function modifier_imba_telekinesis:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
-------------------------------------------

function modifier_imba_telekinesis:OnCreated( params )
	if IsServer() then
		 -- Ability properties
		local caster = self:GetCaster()
		local ability = self:GetAbility()		
		self.parent = self:GetParent()		
		self.z_height = 0
		self.duration = params.duration
		self.lift_animation = ability:GetSpecialValueFor("lift_animation")
		self.fall_animation = ability:GetSpecialValueFor("fall_animation")
		self.current_time = 0
		
		-- Start thinking
		self.frametime = FrameTime()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_telekinesis:OnIntervalThink()
	if IsServer() then
		-- Check motion controllers
		if not self:CheckMotionControllers() then
			self:Destroy()
			return nil
		end		

		-- Vertical Motion
		self:VerticalMotion(self.parent, self.frametime)

		-- Horizontal Motion
		self:HorizontalMotion(self.parent, self.frametime)
	end
end

function modifier_imba_telekinesis:EndTransition()
	if IsServer() then
		if self.transition_end_commenced then
			return nil
		end

		self.transition_end_commenced = true

		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()					
		
		-- Set the thrown unit on the ground		
		parent:SetUnitOnClearGround()		

		-- Remove the stun/root modifier
		parent:RemoveModifierByName("modifier_imba_telekinesis_stun")
		parent:RemoveModifierByName("modifier_imba_telekinesis_root")

		local parent_pos = parent:GetAbsOrigin()

		 -- Ability properties
		local ability = self:GetAbility()
		local impact_radius = ability:GetSpecialValueFor("impact_radius")
		GridNav:DestroyTreesAroundPoint(parent_pos, impact_radius, true)
		
		-- Parameters
		local damage = ability:GetSpecialValueFor("damage")
		local impact_stun_duration = ability:GetSpecialValueFor("impact_stun_duration")
		local impact_radius = ability:GetSpecialValueFor("impact_radius")
		local cooldown 
		if self.is_ally then
			cooldown = ability:GetSpecialValueFor("ally_cooldown")
		else
			cooldown = ability.BaseClass.GetCooldown( ability, ability:GetLevel() )
		end
		
		cooldown = (cooldown * (1 - caster:GetCooldownReduction() * 0.01)) - self:GetDuration()
		
		parent:StopSound("Hero_Rubick.Telekinesis.Target")
		parent:EmitSound("Hero_Rubick.Telekinesis.Target.Land")
		ParticleManager:ReleaseParticleIndex(self.tele_pfx)
		
		-- Play impact particle
		local landing_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_telekinesis_land.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(landing_pfx, 0, parent_pos)
		ParticleManager:SetParticleControl(landing_pfx, 1, parent_pos)
		ParticleManager:ReleaseParticleIndex(landing_pfx)
		
		-- Deal damage and stun to enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent_pos, nil, impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in ipairs(enemies) do
			if enemy ~= parent then
				enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = impact_stun_duration})
			end
			ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = ability:GetAbilityDamageType()})
		end
		if #enemies > 0 and self.is_ally then
			parent:EmitSound("Hero_Rubick.Telekinesis.Target.Stun")
		elseif #enemies > 1 and not self.is_ally then
			parent:EmitSound("Hero_Rubick.Telekinesis.Target.Stun")
		end
		ability:StartCooldown(cooldown)
	end
end

function modifier_imba_telekinesis:VerticalMotion(unit, dt)
    if IsServer() then
		self.current_time = self.current_time + dt
		
		local max_height = self:GetAbility():GetSpecialValueFor("max_height")
		-- Check if it shall lift up
        if self.current_time <= self.lift_animation  then
			self.z_height = self.z_height + ((dt / self.lift_animation) * max_height)
			unit:SetAbsOrigin(GetGroundPosition(unit:GetAbsOrigin(), unit) + Vector(0,0,self.z_height))
		elseif self.current_time > (self.duration - self.fall_animation) then
			self.z_height = self.z_height - ((dt / self.fall_animation) * max_height)
			if self.z_height < 0 then self.z_height = 0 end
			unit:SetAbsOrigin(GetGroundPosition(unit:GetAbsOrigin(), unit) + Vector(0,0,self.z_height))
		else
			max_height = self.z_height
		end
		
		if self.current_time >= self.duration then
			self:EndTransition()
			self:Destroy()
		end
    end
end

function modifier_imba_telekinesis:HorizontalMotion(unit, dt)
	if IsServer() then		
		
		self.distance = self.distance or 0
		if (self.current_time > (self.duration - self.fall_animation)) then
			if self.changed_target then
				local frames_to_end = math.ceil((self.duration - self.current_time) / dt)
				self.distance = (unit:GetAbsOrigin() - self.final_loc):Length2D() / frames_to_end
				self.changed_target = false
			end
			if (self.current_time + dt) >= self.duration then
				unit:SetAbsOrigin(self.final_loc)
				self:EndTransition()
			else
				unit:SetAbsOrigin( unit:GetAbsOrigin() + ((self.final_loc - unit:GetAbsOrigin()):Normalized() * self.distance))
			end
		end
	end
end

function modifier_imba_telekinesis:GetTexture()
	return "rubick_telekinesis"
end

function modifier_imba_telekinesis:OnDestroy()
	if IsServer() then
		-- If it was destroyed because of the parent dying, set the caster at the ground position.
		if not self.parent:IsAlive() then
			self.parent:SetUnitOnClearGround()
		end
	end
end

-------------------------------------------
modifier_imba_telekinesis_stun = class({})
function modifier_imba_telekinesis_stun:IsDebuff() return true end
function modifier_imba_telekinesis_stun:IsHidden() return true end
function modifier_imba_telekinesis_stun:IsPurgable() return false end
function modifier_imba_telekinesis_stun:IsPurgeException() return false end
function modifier_imba_telekinesis_stun:IsStunDebuff() return true end
-------------------------------------------

function modifier_imba_telekinesis_stun:DeclareFunctions()
	local decFuns =
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return decFuns
end

function modifier_imba_telekinesis_stun:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_imba_telekinesis_stun:CheckState()
    local state = 
	{
		[MODIFIER_STATE_STUNNED] = true
	}
    return state
end



modifier_imba_telekinesis_root = class({})
function modifier_imba_telekinesis_root:IsDebuff() return false end
function modifier_imba_telekinesis_root:IsHidden() return true end
function modifier_imba_telekinesis_root:IsPurgable() return false end
function modifier_imba_telekinesis_root:IsPurgeException() return false end
-------------------------------------------
function modifier_imba_telekinesis_root:CheckState()
    local state = 
	{
		[MODIFIER_STATE_ROOTED] = true
	}
    return state
end