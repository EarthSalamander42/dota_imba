-- Spell Steal Lua created by Elfansoer: https://github.com/Elfansoer/dota-2-lua-abilities/tree/master/scripts/vscripts/lua_abilities/rubick_spell_steal_lua

-------------------------------------------
--			TRANSPOSITION
-------------------------------------------
LinkLuaModifier("modifier_imba_telekinesis", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_imba_telekinesis_stun", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_telekinesis_root", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_telekinesis_caster", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)

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
			maximum_distance = self:GetSpecialValueFor("ally_range") + GetCastRangeIncrease(caster) + caster:FindTalentValue("special_bonus_imba_rubick_4")
		else
			maximum_distance = self:GetSpecialValueFor("enemy_range") + GetCastRangeIncrease(caster) + caster:FindTalentValue("special_bonus_imba_rubick_4")
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
			duration = self:GetSpecialValueFor("ally_lift_duration") + caster:FindTalentValue("special_bonus_imba_rubick_2")
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
	return self:GetSpecialValueFor("cast_range")
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
		local ally_cooldown_reduction = ability:GetSpecialValueFor("ally_cooldown")
		
		-- Set the thrown unit on the ground
		parent:SetUnitOnClearGround()
		ResolveNPCPositions(parent:GetAbsOrigin(), 64)

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
		
		ability:UseResources(true, false, true)
		
		-- Special considerations for ally telekinesis		
		if self.is_ally then
			local current_cooldown = ability:GetCooldownTime()
			ability:EndCooldown()
			ability:StartCooldown(current_cooldown * ally_cooldown_reduction)
		end
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

------------------------------------------------------------------------

imba_rubick_fade_bolt = imba_rubick_fade_bolt or class({})

LinkLuaModifier("modifier_imba_rubick_fade_bolt", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rubick_fade_bolt_break", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)

function imba_rubick_fade_bolt:OnSpellStart()
	if IsServer() then
		local previous_unit = self:GetCaster()
		local current_target = self:GetCursorTarget()
		local entities_damaged = {}
		local damage = self:GetSpecialValueFor("damage")
		local kaboom = false

		EmitSoundOn("Hero_Rubick.FadeBolt.Cast", self:GetCaster())

		-- Start bouncing with bounce delay
		Timers:CreateTimer(function()
			-- add entity in a table to not hit it twice!
			table.insert(entities_damaged, current_target)

			-- Look for enemy heroes
			local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
				current_target:GetAbsOrigin(),
				nil,
				self:GetSpecialValueFor("radius"),
				self:GetAbilityTargetTeam(),
				self:GetAbilityTargetType(),
				self:GetAbilityTargetFlags(),
				FIND_CLOSEST,
				false
			)

			-- if this jump is below the first one, increase damage
			if previous_unit ~= self:GetCaster() then
				local damage_increase = self:GetSpecialValueFor("jump_damage_bonus_pct") *  (damage / 100)
				if self:GetCaster():HasTalent("special_bonus_imba_rubick_5") then
					damage_increase = (self:GetSpecialValueFor("jump_damage_bonus_pct") + self:GetCaster():FindTalentValue("special_bonus_imba_rubick_5")) *  (damage / 100)
				end
				damage = damage + damage_increase
			end

			-- if talent 6 is level-up, kaboom the target and end the function
			if kaboom == true then
				local particle_explosion_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_fade_bolt_explode.vpcf", PATTACH_WORLDORIGIN, current_target)
				ParticleManager:SetParticleControl(particle_explosion_fx, 0, current_target:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_explosion_fx, 1, current_target:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_explosion_fx, 2, Vector(self:GetSpecialValueFor("radius"), 1, 1))
				ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

				EmitSoundOn("ParticleDriven.Rocket.Explode", current_target)

				for _, unit in pairs(units) do
					ApplyDamage({
						attacker = self:GetCaster(),
						victim = unit,
						ability = self,
						damage = damage / (100 / self:GetCaster():FindTalentValue("special_bonus_imba_rubick_7")),
						damage_type = self:GetAbilityDamageType()
					})
				end

				return nil
			end

			-- Damage target
			ApplyDamage({
				attacker = self:GetCaster(),
				victim = current_target,
				ability = self,
				damage = damage,
				damage_type = self:GetAbilityDamageType()
			})

			self.fade_bolt_particle = "particles/units/heroes/hero_rubick/rubick_fade_bolt.vpcf"

			-- turn particle to red if break talent is levelup
			if self:GetCaster():HasTalent("special_bonus_imba_rubick_3") then
				current_target:AddNewModifier(self:GetCaster(), self, "modifier_imba_rubick_fade_bolt_break", {duration = self:GetCaster():FindTalentValue("special_bonus_imba_rubick_3")})
--				self.fade_bolt_particle = "particles/units/heroes/hero_rubick/rubick_fade_bolt_red.vpcf"
			end

			-- play Fade Bolt particle
			local particle = ParticleManager:CreateParticle(self.fade_bolt_particle, PATTACH_CUSTOMORIGIN, previous_unit)
			ParticleManager:SetParticleControlEnt(particle, 0, previous_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", previous_unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 1, current_target, PATTACH_POINT_FOLLOW, "attach_hitloc", current_target:GetAbsOrigin(), true)

			-- Play cast sound
			EmitSoundOn("Hero_Rubick.FadeBolt.Target", current_target)

			current_target:AddNewModifier(self:GetCaster(), self, "modifier_imba_rubick_fade_bolt", {duration = self:GetSpecialValueFor("duration")})
			current_target.damaged_by_fade_bolt = true

			-- keep the last hero hit to play the particle for the next bounce
			previous_unit = current_target

			-- Search for a unit
			for _, unit in pairs(units) do
				if unit ~= previous_unit and unit.damaged_by_fade_bolt ~= true then
					-- update the new target
					current_target = unit
					break
				end
			end

			-- If a new target was found, wait and jump again
			if previous_unit ~= current_target then
				return self:GetSpecialValueFor("jump_delay")
			else
				-- reset fade bolt hit counter
				for _, damaged in pairs(entities_damaged) do
					damaged.damaged_by_fade_bolt = false
				end
				
				if self:GetCaster():HasTalent("special_bonus_imba_rubick_7") then
					kaboom = true
					return FrameTime()
				end

				return nil
			end
		end)
	end
end

modifier_imba_rubick_fade_bolt = modifier_imba_rubick_fade_bolt or class({})

function modifier_imba_rubick_fade_bolt:IsDebuff()
	return true
end

function modifier_imba_rubick_fade_bolt:GetEffectName()
	return self.effect_name
end

function modifier_imba_rubick_fade_bolt:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_rubick_fade_bolt:OnCreated()
	if IsServer() then
		self.effect_name = "particles/units/heroes/hero_rubick/rubick_fade_bolt_debuff.vpcf"

--		if self:GetAbility():GetCaster():HasTalent("special_bonus_imba_rubick_3") then
--			self.effect_name = "particles/units/heroes/hero_rubick/rubick_fade_bolt_debuff_red.vpcf"
--		end
	end
end

function modifier_imba_rubick_fade_bolt:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function modifier_imba_rubick_fade_bolt:GetModifierPreAttack_BonusDamage()
	if self:GetParent():IsHero() or self:GetParent():IsRoshan() then
		return -self:GetAbility():GetSpecialValueFor("hero_attack_damage_reduction")
	else
		return -self:GetAbility():GetSpecialValueFor("creep_attack_damage_reduction")
	end
end

modifier_imba_rubick_fade_bolt_break = class({})

function modifier_imba_rubick_fade_bolt_break:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true
	}

	return state
end

------------------------------------

LinkLuaModifier("modifier_imba_rubick_null_field_aura", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rubick_null_field_aura_debuff", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rubick_null_field", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rubick_null_field_debuff", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)

imba_rubick_null_field = imba_rubick_null_field or class({})

function imba_rubick_null_field:GetIntrinsicModifierName()
	return "modifier_imba_rubick_null_field_aura"
end

function imba_rubick_null_field:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():FindTalentValue("special_bonus_imba_rubick_6");
end

function imba_rubick_null_field:OnSpellStart()
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_imba_rubick_null_field_aura") then
			self:GetCaster():RemoveModifierByName("modifier_imba_rubick_null_field_aura")
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_rubick_null_field_aura_debuff", {})
			self:GetCaster():EmitSound("Hero_Rubick.NullField.Offense")
		elseif self:GetCaster():HasModifier("modifier_imba_rubick_null_field_aura_debuff") then
			self:GetCaster():RemoveModifierByName("modifier_imba_rubick_null_field_aura_debuff")
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_rubick_null_field_aura", {})
			self:GetCaster():EmitSound("Hero_Rubick.NullField.Defense")
		end
	end
end

function imba_rubick_null_field:GetAbilityTextureName()
	local offensive = self:GetCaster():HasModifier("modifier_imba_rubick_null_field_aura_debuff")

	if offensive then
		return "rubick_null_field_offensive"
	end

	return "rubick_null_field"
end

modifier_imba_rubick_null_field_aura = modifier_imba_rubick_null_field_aura or class({})

-- Modifier properties
function modifier_imba_rubick_null_field_aura:IsAura() return true end
function modifier_imba_rubick_null_field_aura:IsAuraActiveOnDeath() return false end
function modifier_imba_rubick_null_field_aura:IsDebuff() return false end
function modifier_imba_rubick_null_field_aura:IsHidden() return true end
function modifier_imba_rubick_null_field_aura:IsPermanent() return true end
function modifier_imba_rubick_null_field_aura:IsPurgable() return false end

-- Aura properties
function modifier_imba_rubick_null_field_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius") + self:GetCaster():FindTalentValue("special_bonus_imba_rubick_6")
end

function modifier_imba_rubick_null_field_aura:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_imba_rubick_null_field_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_rubick_null_field_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_imba_rubick_null_field_aura:GetModifierAura()
	return "modifier_imba_rubick_null_field"
end

modifier_imba_rubick_null_field_aura_debuff = modifier_imba_rubick_null_field_aura_debuff or class({})

-- Modifier properties
function modifier_imba_rubick_null_field_aura_debuff:IsAura() return true end
function modifier_imba_rubick_null_field_aura_debuff:IsAuraActiveOnDeath() return false end
function modifier_imba_rubick_null_field_aura_debuff:IsDebuff() return false end
function modifier_imba_rubick_null_field_aura_debuff:IsHidden() return true end
function modifier_imba_rubick_null_field_aura_debuff:IsPermanent() return true end
function modifier_imba_rubick_null_field_aura_debuff:IsPurgable() return false end

-- Aura properties
function modifier_imba_rubick_null_field_aura_debuff:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius") + self:GetCaster():FindTalentValue("special_bonus_imba_rubick_6")
end

function modifier_imba_rubick_null_field_aura_debuff:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_imba_rubick_null_field_aura_debuff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_rubick_null_field_aura_debuff:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_imba_rubick_null_field_aura_debuff:GetModifierAura()
	return "modifier_imba_rubick_null_field_debuff"
end

modifier_imba_rubick_null_field = modifier_imba_rubick_null_field or class({})

-- Modifier properties
function modifier_imba_rubick_null_field:IsHidden() return false end
function modifier_imba_rubick_null_field:IsPurgable() return false end

function modifier_imba_rubick_null_field:OnCreated()
	self.bonus_magic_resist = self:GetAbility():GetSpecialValueFor("magic_damage_reduction_pct")
	self.bonus_status_resistance = self:GetAbility():GetSpecialValueFor("status_resistance_reduction_pct")
end

function modifier_imba_rubick_null_field:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end

function modifier_imba_rubick_null_field:GetModifierMagicalResistanceBonus()
	return self.bonus_magic_resist
end

function modifier_imba_rubick_null_field:GetModifierStatusResistanceStacking()
	return self.bonus_status_resistance
end

--[[ -- talent idea
function modifier_imba_rubick_null_field:GetModifierStatusResistanceStacking()
	return self.bonus_status_resistance * 0.01 * self:GetParent():GetBaseMagicalResistanceValue()
end
--]]

modifier_imba_rubick_null_field_debuff = modifier_imba_rubick_null_field_debuff or class({})

-- Modifier properties
function modifier_imba_rubick_null_field_debuff:IsHidden() return false end
function modifier_imba_rubick_null_field_debuff:IsPurgable() return false end

function modifier_imba_rubick_null_field_debuff:OnCreated()
	self.bonus_magic_resist = self:GetAbility():GetSpecialValueFor("magic_damage_reduction_pct") * (-1)
	self.bonus_status_resistance = self:GetAbility():GetSpecialValueFor("status_resistance_reduction_pct") * (-1)
end

function modifier_imba_rubick_null_field_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end

function modifier_imba_rubick_null_field_debuff:GetModifierMagicalResistanceBonus()
	return self.bonus_magic_resist
end

function modifier_imba_rubick_null_field_debuff:GetModifierStatusResistanceStacking()
	return self.bonus_status_resistance
end

--[[ -- talent idea
function modifier_imba_rubick_null_field_debuff:GetModifierStatusResistanceStacking()
	return self.bonus_status_resistance * 0.01 * self:GetParent():GetBaseMagicalResistanceValue()
end
--]]

-------------------------------------------
--			CLANDESTINE LIBRARIAN
-------------------------------------------

LinkLuaModifier("modifier_imba_rubick_clandestine_librarian", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)

imba_rubick_clandestine_librarian = class({})

function imba_rubick_clandestine_librarian:IsInnateAbility()
	return true
end

function imba_rubick_clandestine_librarian:GetIntrinsicModifierName()
	return "modifier_imba_rubick_clandestine_librarian"
end

modifier_imba_rubick_clandestine_librarian = class({})

function modifier_imba_rubick_clandestine_librarian:IsDebuff() return false end
function modifier_imba_rubick_clandestine_librarian:IsHidden() return false end
function modifier_imba_rubick_clandestine_librarian:IsPurgable() return false end
function modifier_imba_rubick_clandestine_librarian:IsPurgeException() return false end

function modifier_imba_rubick_clandestine_librarian:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function modifier_imba_rubick_clandestine_librarian:OnAbilityFullyCast( keys )
	if keys.unit == self:GetParent() then
		if keys.ability:GetAbilityName() == "imba_rubick_spellsteal" and self:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_spell_amp") then
			self:SetStackCount(self:GetStackCount() + self:GetAbility():GetSpecialValueFor("spell_amp_per_cast"))
		end
	end
end

function modifier_imba_rubick_clandestine_librarian:GetModifierSpellAmplify_Percentage()
	return self:GetStackCount()
end

function modifier_imba_rubick_clandestine_librarian:OnDeath( keys )
	if keys.unit == self:GetParent() and not self:GetParent():IsImbaReincarnating() then
		self:SetStackCount(math.ceil(self:GetStackCount() * (100 - self:GetAbility():GetSpecialValueFor("loss_pct")) / 100))
	end
end

-------------------------------------------
-- SPELL STEAL ANIMATIONS REFERENCES
-------------------------------------------
imba_rubick_animations_reference = {}

imba_rubick_animations_reference.animations = {
-- AbilityName, bNormalWhenStolen, nActivity, nTranslate, fPlaybackRate
	{"default", nil, ACT_DOTA_CAST_ABILITY_5, "bolt"},

	{"imba_abaddon_mist_coil", false, ACT_DOTA_CAST_ABILITY_3, "", 1.4},

	{"imba_axe_berserkers_call", false, ACT_DOTA_CAST_ABILITY_3, "", 1.0},

	{"imba_antimage_blink", nil, nil, "am_blink"},
	{"imba_antimage_mana_void", false, ACT_DOTA_CAST_ABILITY_5, "mana_void"},

	{"imba_bane_brain_sap", false, ACT_DOTA_CAST_ABILITY_5,"brain_sap"},
	{"imba_bane_fiends_grip", false, ACT_DOTA_CHANNEL_ABILITY_5,"fiends_grip"},

	{"bristleback_viscous_nasal_goo", false, ACT_DOTA_ATTACK,"",2.0},

	{"chaos_knight_chaos_bolt", false, ACT_DOTA_ATTACK,"", 2.0},
	{"chaos_knight_reality_rift", true, ACT_DOTA_CAST_ABILITY_5, "strike", 2.0},
	{"chaos_knight_phantasm", true, ACT_DOTA_CAST_ABILITY_5, "remnant"},

	{"imba_centaur_warrunner_hoof_stomp", false, ACT_DOTA_CAST_ABILITY_5, "slam", 2.0},
	{"imba_centaur_warrunner_double_edge", false, ACT_DOTA_ATTACK, "", 2.0},
	{"imba_centaur_warrunner_stampede", false, ACT_DOTA_OVERRIDE_ABILITY_4, "strength"},

	{"imba_crystal_maiden_crystal_nova", false, ACT_DOTA_CAST_ABILITY_5, "crystal_nova"},
	{"imba_crystal_maiden_frostbite", false, ACT_DOTA_CAST_ABILITY_5, "frostbite"},
	{"imba_crystal_maiden_freezing_field", false, ACT_DOTA_CHANNEL_ABILITY_5, "freezing_field"},

	{"imba_dazzle_shallow_grave", false, ACT_DOTA_CAST_ABILITY_5, "repel"},
	{"imba_dazzle_shadow_wave", false, ACT_DOTA_CAST_ABILITY_3, ""},
	{"imba_dazzle_weave", false, ACT_DOTA_CAST_ABILITY_5, "crystal_nova"},

	{"furion_sprout", false, ACT_DOTA_CAST_ABILITY_5, "sprout"},
	{"furion_teleportation", true, ACT_DOTA_CAST_ABILITY_5, "teleport"},
	{"furion_force_of_nature", false, ACT_DOTA_CAST_ABILITY_5, "summon"},
	{"furion_wrath_of_nature", false, ACT_DOTA_CAST_ABILITY_5, "wrath"},

	{"imba_lina_dragon_slave", false, nil, "wave"},
	{"imba_lina_light_strike_array", false, nil, "lsa"},
	{"imba_lina_laguna_blade", false, nil, "laguna"},

	{"ogre_magi_fireblast", false, nil, "frostbite"},

	{"imba_omniknight_purification", true, nil, "purification", 1.4},
	{"imba_omniknight_repel", false, nil, "repel"},
	{"imba_omniknight_guardian_angel", true, nil, "guardian_angel", 1.3},

	{"imba_phantom_assassin_stifling_dagger", false, ACT_DOTA_ATTACK,"", 2.0},
	{"imba_phantom_assassin_shadow_strike", false, nil, "qop_blink"},

	{"imba_queen_of_pain_shadow_strike", false, nil, "shadow_strike"},
	{"imba_queen_of_pain_blink", false, nil, "qop_blink"},
	{"imba_queen_of_pain_scream_of_pain", false, nil, "scream"},
	{"imba_queen_of_pain_sonic_wave", false, nil, "sonic_wave"},

	{"imba_nevermore_shadowraze_close", false, ACT_DOTA_CAST_ABILITY_5, "shadowraze", 2.0},
	{"imba_nevermore_shadowraze_medium", false, ACT_DOTA_CAST_ABILITY_5, "shadowraze", 2.0},
	{"imba_nevermore_shadowraze_far", false, ACT_DOTA_CAST_ABILITY_5, "shadowraze", 2.0},
	{"imba_nevermore_requiem_of_souls", true, ACT_DOTA_CAST_ABILITY_5, "requiem"},

	{"imba_sven_warcry", nil, ACT_DOTA_OVERRIDE_ABILITY_3, "strength"},
	{"imba_sven_gods_strength", nil, ACT_DOTA_OVERRIDE_ABILITY_4, "strength"},

	{"imba_slardar_slithereen_crush", false, ACT_DOTA_MK_SPRING_END, nil},

	{"imba_ursa_earthshock", true, ACT_DOTA_CAST_ABILITY_5, "earthshock", 1.7},
	{"imba_ursa_overpower", true, ACT_DOTA_OVERRIDE_ABILITY_3, "overpower"},
	{"imba_ursa_enrage", true, ACT_DOTA_OVERRIDE_ABILITY_4, "enrage"},

	{"imba_vengefulspirit_wave_of_terror", nil, nil, "roar"},
	{"imba_vengefulspirit_nether_swap", nil, nil, "qop_blink"},
}

imba_rubick_animations_reference.current = 1
function imba_rubick_animations_reference:SetCurrentReference( spellName )
	self.imba_rubick_animations_reference = self:FindReference( spellName )
end
function imba_rubick_animations_reference:SetCurrentReferenceIndex( index )
	imba_rubick_animations_reference.current = index
end
function imba_rubick_animations_reference:GetCurrentReference()
	return self.current
end

function imba_rubick_animations_reference:FindReference( spellName )
	for k,v in pairs(self.animations) do
		if v[1]==spellName then
			return k
		end
	end
	return 1
end
function imba_rubick_animations_reference:IsNormal()
	return self.animations[self.current][2] or false
end
function imba_rubick_animations_reference:GetActivity()
	return self.animations[self.current][3] or ACT_DOTA_CAST_ABILITY_5
end
function imba_rubick_animations_reference:GetTranslate()
	return self.animations[self.current][4] or ""
end
function imba_rubick_animations_reference:GetPlaybackRate()
	return self.animations[self.current][5] or 1
end



-------------------------------------------
--			SPELL STEAL
-------------------------------------------
imba_rubick_spellsteal = imba_rubick_spellsteal or class({})
LinkLuaModifier("imba_rubick_spellsteal", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rubick_spellsteal", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rubick_spellsteal_animation", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rubick_spellsteal_hidden", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)

-------------------------------------------
--	BANNED ABILITIES
-------------------------------------------

imba_rubick_spellsteal.banned_abilities = {"imba_sniper_headshot", "imba_phoenix_sun_ray", "imba_phoenix_sun_ray_toggle_move", "imba_rubick_spellsteal"}

--------------------------------------------------------------------------------
-- Passive Modifier
--------------------------------------------------------------------------------
imba_rubick_spellsteal.firstTime = true
function imba_rubick_spellsteal:OnHeroCalculateStatBonus()
	if self.firstTime then
		self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_rubick_spellsteal_hidden",	{})
		self.firstTime = false
	end
end
--------------------------------------------------------------------------------
-- Ability Cast Filter
--------------------------------------------------------------------------------
imba_rubick_spellsteal.failState = nil
function imba_rubick_spellsteal:CastFilterResultTarget( hTarget )
	if IsServer() then
		if self:GetLastSpell( hTarget ) == nil then
			self.failState = "nevercast"
			return UF_FAIL_CUSTOM
		end
	end

	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
		self:GetCaster():GetTeamNumber()
	)

	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function imba_rubick_spellsteal:GetCustomCastErrorTarget( hTarget )
	if self.failState and self.failState == "nevercast" then
		self.failState = nil
		return "Target never casted an ability"
	end
	
	return ""
end
--------------------------------------------------------------------------------
-- Ability Start
--------------------------------------------------------------------------------

function imba_rubick_spellsteal:OnAbilityPhaseStart()
	-- Has Talent not working in CastFilterResultTarget for whatever reasons, ez fix
	if self:GetCursorTarget():IsCreep() and self:GetCaster():HasTalent("special_bonus_imba_rubick_1") == false then
		DisplayError(self:GetCaster():GetPlayerID(), "#dota_hud_error_cant_cast_on_creep")
		return false
	end

	return true
end

function imba_rubick_spellsteal:GetCastRange( vLocation, hTarget )
	if self:GetCaster():HasScepter() then 
		return self:GetSpecialValueFor("cast_range_scepter")
	else
		return self.BaseClass.GetCastRange( self, vLocation, hTarget )
	end
end

function imba_rubick_spellsteal:GetCooldown( iLevel )
	if self:GetCaster():HasScepter() then 
		return self:GetSpecialValueFor("cooldown_scepter")
	else
		return self.BaseClass.GetCooldown( self, iLevel )
	end
end

imba_rubick_spellsteal.stolenSpell = nil
function imba_rubick_spellsteal:OnSpellStart()
	-- unit identifier
	self.spell_target = self:GetCursorTarget()

	-- Cancel if blocked
	if self.spell_target:TriggerSpellAbsorb( self ) then
		return
	end

	-- Get last used spell
	self.stolenSpell = {}
	self.stolenSpell.stolenFrom = self:GetLastSpell( self.spell_target ).handle:GetUnitName()
	self.stolenSpell.primarySpell = self:GetLastSpell( self.spell_target ).primarySpell
	self.stolenSpell.secondarySpell = self:GetLastSpell( self.spell_target ).secondarySpell
	self.stolenSpell.linkedTalents = self:GetLastSpell( self.spell_target ).linkedTalents
	-- load data
	local projectile_name = "particles/units/heroes/hero_rubick/rubick_spell_steal.vpcf"
	local projectile_speed = self:GetSpecialValueFor("projectile_speed")
	
	-- Create Projectile
	local info = {
		Target = self:GetCaster(),
		Source = self.spell_target,
		Ability = self,	
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		vSourceLoc = self.spell_target:GetAbsOrigin(),                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
		bDodgeable = false,                                -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bReplaceExisting = false,                         -- Optional
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)

	-- Play effects
	local sound_cast = "Hero_Rubick.SpellSteal.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )
	local sound_target = "Hero_Rubick.SpellSteal.Target"
	EmitSoundOn( sound_target, self.spell_target )


end

function imba_rubick_spellsteal:OnProjectileHit( target, location )

	-- need to remove it to send the right spell amp stolen with aghanim
	if self:GetCaster():HasModifier("modifier_imba_rubick_spellsteal") then
		self:GetCaster():RemoveModifierByName("modifier_imba_rubick_spellsteal")
	end
	
	-- Add ability
	self:SetStolenSpell( self.stolenSpell )
	self.stolenSpell = nil

	-- Add modifier
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_imba_rubick_spellsteal", -- modifier name
		{spell_amp = self.spell_target:GetSpellAmplification(false)} -- kv
	)

	local sound_cast = "Hero_Rubick.SpellSteal.Complete"
	EmitSoundOn( sound_cast, target )
end
--------------------------------------------------------------------------------
-- Helper: Heroes Data
--------------------------------------------------------------------------------
imba_rubick_spellsteal.heroesData = {}
function imba_rubick_spellsteal:SetLastSpell( hHero, hSpell )
	local primary_ability = nil
	local secondary_ability = nil
	local secondary = nil
	local primary = nil
	local linked_talents = {}
	local hero_name = (string.gsub(hHero:GetUnitName(), "npc_dota_hero_",""))
	primary_ability = hSpell:GetAssociatedPrimaryAbilities()
	secondary_ability = hSpell:GetAssociatedSecondaryAbilities()

	-- check if there is primary or secondary linked ability

	if primary_ability ~= nil then
		primary = hHero:FindAbilityByName(primary_ability)
		secondary = hSpell
	else
		primary = hSpell
	end
	--print(primary:GetStolenActivityModifier())
	--special_bonus_imba_sniper_1
	--PrintTable(hHero:FindAbilityByName("special_bonus_imba_sniper_1"))
	
	-- loop thru poop thru talent table
	for i=1,8 do 
		talent = hHero:FindAbilityByName("special_bonus_imba_"..hero_name.."_"..i)
		if talent and talent:IsTrained() then
			for k,v in pairs(talent:GetAbilityKeyValues()) do
				if k == "LinkedAbility" then 
					if ( primary and v["01"] == primary:GetAbilityName() ) or ( secondary and v["01"] == secondary:GetAbilityName() ) then
						--print("we can haz this talent: "..talent:GetAbilityName())
						table.insert( linked_talents, talent:GetAbilityName() )
					end
				end
			end
		end
	end

	if secondary_ability ~= nil then
		secondary = hHero:FindAbilityByName(secondary_ability)
	end

	-- banned abilities from being stolen somehow
	for _,banned_ability in pairs(self.banned_abilities) do
		if primary ~= nil and primary:GetAbilityName() == banned_ability then
			primary = nil
		end
		if secondary ~= nil and secondary:GetAbilityName() == banned_ability then
			secondary = nil
		end
	end
	
	-- find hero in list
	local heroData = nil
	for _,data in pairs(imba_rubick_spellsteal.heroesData) do
		if data.handle == hHero then
			heroData = data
			break
		end
	end

	-- store data
	if heroData then
		heroData.primarySpell = primary
		heroData.secondarySpell = secondary
		heroData.linkedTalents = linked_talents
	else
		local newData = {}
		newData.handle = hHero
		newData.primarySpell = primary
		newData.secondarySpell = secondary
		newData.linkedTalents = linked_talents
		table.insert( imba_rubick_spellsteal.heroesData, newData )
	end
end

function imba_rubick_spellsteal:GetLastSpell(hHero)
	-- find hero in list
	local heroData = nil
	for _,data in pairs(imba_rubick_spellsteal.heroesData) do
		if data.handle==hHero then
			heroData = data
			break
		end
	end

	if heroData then
		-- local table = {}
		-- table.lastSpell = heroData.lastSpell
		-- table.interaction = self.interactions.Init( table.lastSpell, self )
		-- return table
		return heroData
	end

	return nil
end

function imba_rubick_spellsteal:PrintStatus()
	print("Heroes and spells:")
	for _,heroData in pairs(imba_rubick_spellsteal.heroesData) do
		if heroData.primarySpell ~= nil then
			print( heroData.handle:GetUnitName(), heroData.handle, heroData.primarySpell:GetAbilityName(), heroData.primarySpell )
		end
		if heroData.secondarySpell ~= nil then
			print( heroData.handle:GetUnitName(), heroData.handle, heroData.secondarySpell:GetAbilityName(), heroData.secondarySpell )
		end
	end
end
--------------------------------------------------------------------------------
-- Helper: Current spell
--------------------------------------------------------------------------------
imba_rubick_spellsteal.CurrentPrimarySpell = nil
imba_rubick_spellsteal.CurrentSecondarySpell = nil
imba_rubick_spellsteal.CurrentSpellOwner = nil
imba_rubick_spellsteal.animations = imba_rubick_animations_reference
imba_rubick_spellsteal.slot1 = "rubick_empty1"
imba_rubick_spellsteal.slot2 = "rubick_empty2"
-- Add new stolen spell
function imba_rubick_spellsteal:SetStolenSpell( spellData )
	local primarySpell = spellData.primarySpell
	local secondarySpell = spellData.secondarySpell
	local linkedTalents = spellData.linkedTalents
	-- Forget previous one
	self:ForgetSpell()
	-- print("Stolen spell: "..primarySpell:GetAbilityName())

	-- if secondarySpell then
		-- print("Stolen secondary spell: "..secondarySpell:GetAbilityName())
	-- end

	--phoenix is a meme
	if self.CurrentSpellOwner == "npc_dota_hero_phoenix" then
		if secondarySpell:GetAbilityName() == "imba_phoenix_icarus_dive_stop" then
			secondarySpell:SetHidden(true)
		end

		self:GetCaster():AddAbility( "imba_phoenix_sun_ray_stop" )
	elseif self.CurrentSpellOwner == "npc_dota_hero_storm_spirit" then
		self.vortex = self:GetCaster():AddAbility( "imba_storm_spirit_electric_vortex" )
		self.vortex:SetLevel( 4 )
		self.vortex:SetStolen( true )
	end

	-- Add new spell
	if primarySpell~=nil and not primarySpell:IsNull() then
		self.CurrentPrimarySpell = self:GetCaster():AddAbility( primarySpell:GetAbilityName() )
		self.CurrentPrimarySpell:SetLevel( primarySpell:GetLevel() )
		self.CurrentPrimarySpell:SetStolen( true )
		
		-- respect IsHiddenWhenStolen()
		if self.CurrentPrimarySpell:IsHiddenWhenStolen() then
			self.CurrentPrimarySpell:SetHidden(true)
		else
			self:GetCaster():SwapAbilities( self.slot1, self.CurrentPrimarySpell:GetAbilityName(), false, true )
		end
	end
	if secondarySpell~=nil and not secondarySpell:IsNull() then
		self.CurrentSecondarySpell = self:GetCaster():AddAbility( secondarySpell:GetAbilityName() )
		self.CurrentSecondarySpell:SetLevel( secondarySpell:GetLevel() )
		self.CurrentSecondarySpell:SetStolen( true )
		
		-- respect IsHiddenWhenStolen()
		if self.CurrentSecondarySpell:IsHiddenWhenStolen() then
			self.CurrentSecondarySpell:SetHidden(true)
		else
			self:GetCaster():SwapAbilities( self.slot2, self.CurrentSecondarySpell:GetAbilityName(), false, true )
		end
	end
	
	-- Add Linked Talents 
	for _,talent in pairs(linkedTalents) do
		local talent_handle = self:GetCaster():AddAbility( talent )
		talent_handle:SetLevel( 1 )
		talent_handle:SetStolen( true )
	end
	
	-- Animations override
	if self.CurrentPrimarySpell ~= nil then
		self.animations:SetCurrentReference( self.CurrentPrimarySpell:GetAbilityName() )
		if not self.animations:IsNormal() then
			--self.CurrentPrimarySpell:SetOverrideCastPoint( 0.1 )
		end
		self.CurrentSpellOwner = spellData.stolenFrom
	end
end
-- Remove currently stolen spell
function imba_rubick_spellsteal:ForgetSpell()
	if self.CurrentSpellOwner ~= nil then
		for i = 0, self:GetCaster():GetModifierCount() -1 do
			if string.find(self:GetCaster():GetModifierNameByIndex(i),string.gsub(self.CurrentSpellOwner, "npc_dota_hero_","")) then
				self:GetCaster():RemoveModifierByName(self:GetCaster():GetModifierNameByIndex(i))
			end	
		end
		-- remove stolen talents
		-- print("special_bonus_imba_"..string.gsub(self.CurrentSpellOwner, "npc_dota_hero_","").."_1")
		for i = 0, self:GetCaster():GetAbilityCount() -1 do
			local talent = self:GetCaster():FindAbilityByName("special_bonus_imba_"..string.gsub(self.CurrentSpellOwner, "npc_dota_hero_","").."_"..i)
			if talent then
				print(talent:GetAbilityName())
				self:GetCaster():RemoveAbility( talent:GetAbilityName() )
			end
		end
			
	end
	if self.CurrentPrimarySpell~=nil and not self.CurrentPrimarySpell:IsNull() then
		--print("forgetting primary")
		self:GetCaster():SwapAbilities( self.slot1, self.CurrentPrimarySpell:GetAbilityName(), true, false )
		self:GetCaster():RemoveAbility( self.CurrentPrimarySpell:GetAbilityName() )
		if self.CurrentSecondarySpell~=nil and not self.CurrentSecondarySpell:IsNull() then
			--print("forgetting secondary")
			self:GetCaster():SwapAbilities( self.slot2, self.CurrentSecondarySpell:GetAbilityName(), true, false )
			self:GetCaster():RemoveAbility( self.CurrentSecondarySpell:GetAbilityName() )
		end

		--GetAbility	
		self.CurrentPrimarySpell = nil
		self.CurrentSecondarySpell = nil
		self.CurrentSpellOwner = nil
	end
end
--------------------------------------------------------------------------------
-- Ability Considerations
--------------------------------------------------------------------------------
function imba_rubick_spellsteal:AbilityConsiderations()
	-- Scepter
	local bScepter = caster:HasScepter()

	-- Linken & Lotus
	local bBlocked = target:TriggerSpellAbsorb( self )

	-- Break
	local bBroken = caster:PassivesDisabled()

	-- Advanced Status
	local bInvulnerable = target:IsInvulnerable()
	local bInvisible = target:IsInvisible()
	local bHexed = target:IsHexed()
	local bMagicImmune = target:IsMagicImmune()

	-- Illusion Copy
	local bIllusion = target:IsIllusion()
end
-------------------------------------------
--	modifier_rubick_spellsteal_hidden
-------------------------------------------
modifier_rubick_spellsteal_hidden = class({})
LinkLuaModifier("modifier_rubick_spellsteal_hidden", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)

function modifier_rubick_spellsteal_hidden:IsHidden() return true end

function modifier_rubick_spellsteal_hidden:IsDebuff() return false end

function modifier_rubick_spellsteal_hidden:IsPurgable() return false end

function modifier_rubick_spellsteal_hidden:RemoveOnDeath() return false end

function modifier_rubick_spellsteal_hidden:OnCreated( kv ) end

function modifier_rubick_spellsteal_hidden:OnRefresh( kv ) end

function modifier_rubick_spellsteal_hidden:OnDestroy() end

function modifier_rubick_spellsteal_hidden:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
	return funcs
end

function modifier_rubick_spellsteal_hidden:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit==self:GetParent() and (not params.ability:IsItem()) then
			return
		end
		-- Filter illusions
		if params.unit:IsIllusion() then
			return
		end
		-- Is Stealable?
		if not params.ability:IsStealable() then
			return
		end
		-- Not sure why this is needed since it checks for being an item on top, maybe custom items?
		if string.find(params.ability:GetAbilityName(), "item") then
			return
		end
		self:GetAbility():SetLastSpell( params.unit, params.ability )
	end
end

-------------------------------------------
--	modifier_imba_rubick_spellsteal
-------------------------------------------
modifier_imba_rubick_spellsteal = class({})

function modifier_imba_rubick_spellsteal:IsHidden() return true end
function modifier_imba_rubick_spellsteal:IsDebuff()	return false end
function modifier_imba_rubick_spellsteal:IsPurgable() return false end

function modifier_imba_rubick_spellsteal:OnCreated( kv )
	if IsClient() then return end
	self.stolen_spell_amp = kv.spell_amp * 100

	if self:GetParent():HasScepter() then
		print("Spell Amp:", self.stolen_spell_amp)
		self:SetStackCount(self.stolen_spell_amp)
	end
end

function modifier_imba_rubick_spellsteal:OnRefresh( kv )
	if IsClient() then return end
	if self:GetParent():HasScepter() then
		print("Spell Amp (refresh):", self.stolen_spell_amp)
		self:SetStackCount(self.stolen_spell_amp)
	end
end

function modifier_imba_rubick_spellsteal:OnDestroy( kv ) 
	self:GetAbility():ForgetSpell() 
end

--------------------------------------------------------------------------------
-- Modifier Effects
--------------------------------------------------------------------------------
function modifier_imba_rubick_spellsteal:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_START,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}

	return funcs
end

function modifier_imba_rubick_spellsteal:OnAbilityStart( params )
	if IsServer() then
		if params.unit==self:GetParent() then
			-- No cast point is what Rubick is known for...
			params.ability:SetOverrideCastPoint(0)
			
			if params.ability==self:GetAbility().currentSpell then
				-- Destroy previous animation
				local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_imba_rubick_spellsteal_animation", self:GetParent() )
				if modifier then
					modifier:Destroy()
				end

				-- Animate
				local anim_duration = math.max( 1.5, params.ability:GetCastPoint() )
				if params.ability:GetChannelTime()>0 then
					anim_duration = params.ability:GetChannelTime()
				end
				local animate = self:GetParent():AddNewModifier(
					self:GetParent(),
					self:GetAbility(),
					"modifier_imba_rubick_spellsteal_animation",
					{
						duration = anim_duration,
						spellName = params.ability:GetAbilityName(),
					}
				)
			end
		end
	end
end

function modifier_imba_rubick_spellsteal:GetModifierSpellAmplify_Percentage()
	return self:GetStackCount()
end

-------------------------------------------
--	modifier_imba_rubick_spellsteal_animation
-------------------------------------------
modifier_imba_rubick_spellsteal_animation = class({})

function modifier_imba_rubick_spellsteal_animation:IsHidden() return false end
function modifier_imba_rubick_spellsteal_animation:IsDebuff() return false end
function modifier_imba_rubick_spellsteal_animation:IsPurgable() return false end

function modifier_imba_rubick_spellsteal_animation:OnCreated( kv )
	if IsServer() then
		-- Get SpellName
		self.spellName = kv.spellName

		-- Set stack to current reference
		self:SetStackCount( self:GetAbility().animations:GetCurrentReference() )
	end
	if not IsServer() then
		-- Retrieve current reference
		self:GetAbility().animations:SetCurrentReferenceIndex( self:GetStackCount() )
	end
end

function modifier_imba_rubick_spellsteal_animation:OnRefresh( kv ) end
function modifier_imba_rubick_spellsteal_animation:OnDestroy( kv ) end

function modifier_imba_rubick_spellsteal_animation:DeclareFunctions() 
  local funcs = {
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_EVENT_ON_ORDER,
  }
 
  return funcs
end

function modifier_imba_rubick_spellsteal_animation:GetOverrideAnimation()
	return self:GetAbility().animations:GetActivity()
end

function modifier_imba_rubick_spellsteal_animation:GetOverrideAnimationRate()
	return self:GetAbility().animations:GetPlaybackRate()
end

function modifier_imba_rubick_spellsteal_animation:GetActivityTranslationModifiers()
	return self:GetAbility().animations:GetTranslate()
end

function modifier_imba_rubick_spellsteal_animation:OnOrder( params )
	if IsServer() then
		if params.unit==self:GetParent() then
			self:Destroy()
		end
	end
end
