-- Copyright (C) 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Editors:
--     AtroCty, 17.04.2017

-------------------------------------------
-- SPELL STEAL ANIMATIONS REFERENCES
-------------------------------------------
imba_rubick_animations_reference = {}

imba_rubick_animations_reference.animations = {
-- AbilityName, bNormalWhenStolen, nActivity, nTranslate, fPlaybackRate
    {"default", nil, ACT_DOTA_CAST_ABILITY_5, "bolt"},

    {"abaddon_mist_coil_lua", false, ACT_DOTA_CAST_ABILITY_3, "", 1.4},

    {"antimage_blink_lua", nil, nil, "am_blink"},
    {"antimage_mana_void_lua", false, ACT_DOTA_CAST_ABILITY_5, "mana_void"},

    {"bane_brain_sap_lua", false, ACT_DOTA_CAST_ABILITY_5,"brain_sap"},
    {"bane_fiends_grip_lua", false, ACT_DOTA_CHANNEL_ABILITY_5,"fiends_grip"},

    {"bristleback_viscous_nasal_goo_lua", false, ACT_DOTA_ATTACK,"",2.0},

    {"chaos_knight_chaos_bolt_lua", false, ACT_DOTA_ATTACK,"", 2.0},
    {"chaos_knight_reality_rift_lua", true, ACT_DOTA_CAST_ABILITY_5, "strike", 2.0},
    {"chaos_knight_phantasm_lua", true, ACT_DOTA_CAST_ABILITY_5, "remnant"},

    {"centaur_warrunner_hoof_stomp_lua", false, ACT_DOTA_CAST_ABILITY_5, "slam", 2.0},
    {"centaur_warrunner_double_edge_lua", false, ACT_DOTA_ATTACK, "", 2.0},
    {"centaur_warrunner_stampede_lua", false, ACT_DOTA_OVERRIDE_ABILITY_4, "strength"},

    {"crystal_maiden_crystal_nova_lua", false, ACT_DOTA_CAST_ABILITY_5, "crystal_nova"},
    {"crystal_maiden_frostbite_lua", false, ACT_DOTA_CAST_ABILITY_5, "frostbite"},
    {"crystal_maiden_freezing_field_lua", false, ACT_DOTA_CHANNEL_ABILITY_5, "freezing_field"},

    {"dazzle_shallow_grave_lua", false, ACT_DOTA_CAST_ABILITY_5, "repel"},
    {"dazzle_shadow_wave_lua", false, ACT_DOTA_CAST_ABILITY_3, ""},
    {"dazzle_weave_lua", false, ACT_DOTA_CAST_ABILITY_5, "crystal_nova"},

    {"furion_sprout_lua", false, ACT_DOTA_CAST_ABILITY_5, "sprout"},
    {"furion_teleportation_lua", true, ACT_DOTA_CAST_ABILITY_5, "teleport"},
    {"furion_force_of_nature_lua", false, ACT_DOTA_CAST_ABILITY_5, "summon"},
    {"furion_wrath_of_nature_lua", false, ACT_DOTA_CAST_ABILITY_5, "wrath"},

    {"lina_dragon_slave_lua", false, nil, "wave"},
    {"lina_light_strike_array_lua", false, nil, "lsa"},
    {"lina_laguna_blade_lua", false, nil, "laguna"},

    {"ogre_magi_fireblast_lua", false, nil, "frostbite"},

    {"omniknight_purification_lua", true, nil, "purification", 1.4},
    {"omniknight_repel_lua", false, nil, "repel"},
    {"omniknight_guardian_angel_lua", true, nil, "guardian_angel", 1.3},

    {"phantom_assassin_stifling_dagger_lua", false, ACT_DOTA_ATTACK,"", 2.0},
    {"phantom_assassin_shadow_strike_lua", false, nil, "qop_blink"},

    {"queen_of_pain_shadow_strike_lua", false, nil, "shadow_strike"},
    {"queen_of_pain_blink_lua", false, nil, "qop_blink"},
    {"queen_of_pain_scream_of_pain_lua", false, nil, "scream"},
    {"queen_of_pain_sonic_wave_lua", false, nil, "sonic_wave"},

    {"shadow_fiend_shadowraze_a_lua", false, ACT_DOTA_CAST_ABILITY_5, "shadowraze", 2.0},
    {"shadow_fiend_shadowraze_b_lua", false, ACT_DOTA_CAST_ABILITY_5, "shadowraze", 2.0},
    {"shadow_fiend_shadowraze_c_lua", false, ACT_DOTA_CAST_ABILITY_5, "shadowraze", 2.0},
    {"shadow_fiend_requiem_of_souls_lua", true, ACT_DOTA_CAST_ABILITY_5, "requiem"},

    {"sven_warcry_lua", nil, ACT_DOTA_OVERRIDE_ABILITY_3, "strength"},
    {"sven_gods_strength_lua", nil, ACT_DOTA_OVERRIDE_ABILITY_4, "strength"},

    {"slardar_slithereen_crush_lua", false, ACT_DOTA_MK_SPRING_END, nil},

    {"ursa_earthshock_lua", true, ACT_DOTA_CAST_ABILITY_5, "earthshock", 1.7},
    {"ursa_overpower_lua", true, ACT_DOTA_OVERRIDE_ABILITY_3, "overpower"},
    {"ursa_enrage_lua", true, ACT_DOTA_OVERRIDE_ABILITY_4, "enrage"},

    {"vengefulspirit_wave_of_terror_lua", nil, nil, "roar"},
    {"vengefulspirit_nether_swap_lua", nil, nil, "qop_blink"},
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
			maximum_distance = self:GetSpecialValueFor("ally_range") + GetCastRangeIncrease(caster) + caster:FindTalentValue("special_bonus_unique_rubick")
		else
			maximum_distance = self:GetSpecialValueFor("enemy_range") + GetCastRangeIncrease(caster) + caster:FindTalentValue("special_bonus_unique_rubick")
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

		cooldown = (cooldown - caster:FindTalentValue("special_bonus_unique_rubick_4"))  - self:GetDuration()

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


-------------------------------------------
--			SPELL STEAL
-------------------------------------------

imba_rubick_spellsteal = imba_rubick_spellsteal or class({})
LinkLuaModifier("imba_rubick_spellsteal", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rubick_spellsteal", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rubick_spellsteal_animation", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rubick_spellsteal_hidden", "components/abilities/heroes/hero_rubick", LUA_MODIFIER_MOTION_NONE)




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
		DOTA_UNIT_TARGET_HERO,
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

imba_rubick_spellsteal.stolenSpell = nil
function imba_rubick_spellsteal:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- Cancel if blocked
	if target:TriggerSpellAbsorb( self ) then
		return
	end

	-- Get last used spell
	self.stolenSpell = {}
	self.stolenSpell.stolenFrom = self:GetLastSpell( target ).handle:GetUnitName()
	self.stolenSpell.primarySpell = self:GetLastSpell( target ).primarySpell
	self.stolenSpell.secondarySpell = self:GetLastSpell( target ).secondarySpell
	-- load data
	local projectile_name = "particles/units/heroes/hero_rubick/rubick_spell_steal.vpcf"
	local projectile_speed = self:GetSpecialValueFor("projectile_speed")

	-- Create Projectile
	local info = {
		Target = caster,
		Source = target,
		Ability = self,	
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		vSourceLoc = target:GetAbsOrigin(),                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
		bDodgeable = false,                                -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bReplaceExisting = false,                         -- Optional
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)

	-- Play effects
	local sound_cast = "Hero_Rubick.SpellSteal.Cast"
	EmitSoundOn( sound_cast, caster )
	local sound_target = "Hero_Rubick.SpellSteal.Target"
	EmitSoundOn( sound_target, target )
end

function imba_rubick_spellsteal:OnProjectileHit( target, location )
	-- Add ability
	self:SetStolenSpell( self.stolenSpell )
	self.stolenSpell = nil

	-- Add modifier
	local steal_duration = self:GetSpecialValueFor("duration")
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_imba_rubick_spellsteal", -- modifier name
		{ duration = steal_duration } -- kv
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
	primary_ability = hSpell:GetAssociatedPrimaryAbilities()
	secondary_ability = hSpell:GetAssociatedSecondaryAbilities()

	-- check if there is primary or secondary linked ability

	if primary_ability ~= nil then
		primary = hHero:FindAbilityByName(primary_ability)
		secondary = hSpell
	else
		primary = hSpell
	end
	if secondary_ability ~= nil then
		secondary = hHero:FindAbilityByName(secondary_ability)
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
	else
		local newData = {}
		newData.handle = hHero
		newData.primarySpell = primary
		newData.secondarySpell = secondary
		table.insert( imba_rubick_spellsteal.heroesData, newData )
	end
	--self:PrintStatus()
	-- self:PrintStatus()
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
	-- Forget previous one
	self:ForgetSpell()

	print("Stolen spell: "..primarySpell:GetAbilityName())
	print("Stolen secondary spell: "..secondarySpell:GetAbilityName())

	--phoenix is a meme
	if self.CurrentSpellOwner == "npc_dota_hero_phoenix" then
		if secondarySpell:GetAbilityName() == "imba_phoenix_icarus_dive_stop" then
			secondarySpell:SetHidden(true)
		end

--		self:GetCaster():AddAbility( "imba_phoenix_sun_ray_stop" )
	elseif self.CurrentSpellOwner == "npc_dota_hero_storm_spirit" then
		self.vortex = self:GetCaster():AddAbility( "imba_storm_spirit_electric_vortex" )
		self.vortex:SetLevel( 4 )
		self.vortex:SetStolen( true )
	end

	-- Add new spell
	if not primarySpell:IsNull() then
	self.CurrentPrimarySpell = self:GetCaster():AddAbility( primarySpell:GetAbilityName() )
	self.CurrentPrimarySpell:SetLevel( primarySpell:GetLevel() )
	self.CurrentPrimarySpell:SetStolen( true )
	self:GetCaster():SwapAbilities( self.slot1, self.CurrentPrimarySpell:GetAbilityName(), false, true )
	end
	if secondarySpell~=nil and not secondarySpell:IsNull() then
		self.CurrentSecondarySpell = self:GetCaster():AddAbility( secondarySpell:GetAbilityName() )
		self.CurrentSecondarySpell:SetLevel( secondarySpell:GetLevel() )
		self.CurrentSecondarySpell:SetStolen( true )
		self:GetCaster():SwapAbilities( self.slot2, self.CurrentSecondarySpell:GetAbilityName(), false, true )
	end

 	-- Animations override
	self.animations:SetCurrentReference( self.CurrentPrimarySpell:GetAbilityName() )
	if not self.animations:IsNormal() then
		self.CurrentPrimarySpell:SetOverrideCastPoint( 0.1 )
	end
	self.CurrentSpellOwner = spellData.stolenFrom
end
-- Remove currently stolen spell
function imba_rubick_spellsteal:ForgetSpell()
	if self.CurrentSpellOwner ~= nil then
		for i = 0, self:GetCaster():GetModifierCount() -1 do
			if string.find(self:GetCaster():GetModifierNameByIndex(i),string.gsub(self.CurrentSpellOwner, "npc_dota_hero_","")) then
            	self:GetCaster():RemoveModifierByName(self:GetCaster():GetModifierNameByIndex(i))
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
		self:GetAbility():SetLastSpell( params.unit, params.ability )
	end
end

-------------------------------------------
--	modifier_imba_rubick_spellsteal
-------------------------------------------
modifier_imba_rubick_spellsteal = class({})

function modifier_imba_rubick_spellsteal:IsHidden() return false end
function modifier_imba_rubick_spellsteal:IsDebuff()	return false end
function modifier_imba_rubick_spellsteal:IsPurgable() return false end

function modifier_imba_rubick_spellsteal:OnCreated( kv ) end
function modifier_imba_rubick_spellsteal:OnRefresh( kv ) end
function modifier_imba_rubick_spellsteal:OnDestroy( kv ) 
	self:GetAbility():ForgetSpell() 
end

--------------------------------------------------------------------------------
-- Modifier Effects
--------------------------------------------------------------------------------
function modifier_imba_rubick_spellsteal:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_START,
	}

	return funcs
end

function modifier_imba_rubick_spellsteal:OnAbilityStart( params )
	if IsServer() then
		if params.unit==self:GetParent() and params.ability==self:GetAbility().currentSpell then
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