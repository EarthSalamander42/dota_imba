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
--

--[[	Author: d2imba
		Date:	15.08.2015
		Updated by: Fudge
		Update Date: 24.07.2017
  ]]

---------------------------------
----         ACTIVE          ----
---------------------------------
item_imba_silver_edge = item_imba_silver_edge or class({})
LinkLuaModifier("modifier_item_imba_silver_edge_passive", "components/items/item_silver_edge.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_silver_edge_invis", "components/items/item_silver_edge.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_silver_edge_invis_flying_disabled", "components/items/item_silver_edge.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_silver_edge_invis_panic_debuff", "components/items/item_silver_edge.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_silver_edge_invis_break_debuff", "components/items/item_silver_edge.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_silver_edge_invis_attack_cleave_particle", "components/items/item_silver_edge.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_silver_edge:OnSpellStart()
	-- Ability properties
	local caster    =   self:GetCaster()
	local particle_invis_start = "particles/generic_hero_status/status_invisibility_start.vpcf"
	-- Ability parameters
	local duration  =   self:GetSpecialValueFor("invis_duration")
	local fade_time =   self:GetSpecialValueFor("invis_fade_time")

	-- Play cast sound
	EmitSoundOn("DOTA_Item.InvisibilitySword.Activate", caster)

	-- Wait for the fade time to end, then emit the invisibility effect and apply the invis modifier
	Timers:CreateTimer(fade_time, function()
		local particle_invis_start_fx = ParticleManager:CreateParticle(particle_invis_start, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_invis_start_fx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_invis_start_fx)

		caster:AddNewModifier(caster, self, "modifier_item_imba_silver_edge_invis", {duration = duration})
	end)
end

function item_imba_silver_edge:GetIntrinsicModifierName()
	return "modifier_item_imba_silver_edge_passive"
end


---------------------
--- INVIS MODIFIER
---------------------
modifier_item_imba_silver_edge_invis = modifier_item_imba_silver_edge_invis or class({})

-- Modifier properties
function modifier_item_imba_silver_edge_invis:IsDebuff() return false end
function modifier_item_imba_silver_edge_invis:IsHidden() return false end
function modifier_item_imba_silver_edge_invis:IsPurgable() return false end

function modifier_item_imba_silver_edge_invis:OnCreated()
	-- Start flying if has not taken damage recently
	if IsServer() then
		if not self:GetParent():FindModifierByName("modifier_item_imba_silver_edge_invis_flying_disabled") then
			self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
		end
	end

	if self:GetAbility() == nil then return end
	self.bonus_movespeed        =   self:GetAbility():GetSpecialValueFor("invis_ms_pct")
	self.bonus_attack_damage    =   self:GetAbility():GetSpecialValueFor("invis_damage")
end

-- Damage and movespeed bonuses
function modifier_item_imba_silver_edge_invis:DeclareFunctions()
	local funcs =   {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		-- Breaking invis handlers
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		-- Check who got hit by the cleave
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	}
	return funcs
end

function modifier_item_imba_silver_edge_invis:GetModifierMoveSpeedBonus_Percentage() return self.bonus_movespeed end

-- Phase invis and flying bonuses
function modifier_item_imba_silver_edge_invis:CheckState()
	local state =   {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true -- Attack out of invis cannot miss.
	}
	return state
end

function modifier_item_imba_silver_edge_invis:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_item_imba_silver_edge_invis:GetModifierInvisibilityLevel()
	return 1
end

function modifier_item_imba_silver_edge_invis:OnAttackLanded(params)
	if IsServer() then

		if params.attacker == self:GetParent() then

			local ability 			=	self:GetAbility()
			local attack_particle	=	"particles/item/silver_edge/imba_silver_edge.vpcf"
			local initial_pos
			-- Ability paramaters
			local cleave_damage		 	= ability:GetSpecialValueFor("shadow_rip_damage")
			local cleave_radius_start 	= ability:GetSpecialValueFor("shadow_rip_start_width")
			local cleave_radius_end 	= ability:GetSpecialValueFor("shadow_rip_end_width")
			local cleave_distance 		= ability:GetSpecialValueFor("shadow_rip_distance")
			local panic_duration		= ability:GetSpecialValueFor("panic_duration")
			local break_duration		= ability:GetSpecialValueFor("main_debuff_duration")

			-- Teleport ranged attackers to make the affect go from the target's vector
			if self:GetParent():IsRangedAttacker() then

				initial_pos 	= self:GetParent():GetAbsOrigin()
				local target_pos 	= params.target:GetAbsOrigin()

				-- Offset is necessary, because cleave from Battlefury doesn't work (in any direction) if you are exactly on top of the target unit
				local offset = 100 --dotameters (default melee range is 150 dotameters)

				-- Find the distance vector (distance, but as a vector rather than Length2D)
				-- z is 0 to prevent any wonkiness due to height differences, we'll use the targets height, unmodified
				local distance_vector = Vector(target_pos.x - initial_pos.x, target_pos.y - initial_pos.y, 0)
				-- Normalize it, so the offset can be applied to x/y components, proportionally
				distance_vector = distance_vector:Normalized()

				-- Offset the caster 100 units in front of the target
				target_pos.x = target_pos.x - offset * distance_vector.x
				target_pos.y = target_pos.y - offset * distance_vector.y

				self:GetParent():SetAbsOrigin(target_pos)

				-- Give the dummy which direction to look at
				local direction = (CalculateDirection(params.target, self:GetParent()))

				-- Create a particle for the cleave effect for ranged heroes
				CreateModifierThinker(self:GetParent(), ability, "modifier_item_imba_silver_edge_invis_attack_cleave_particle",
					{duration =1, direction_x = direction.x, direction_y = direction.y, direction_z = direction.z}, target_pos, self:GetParent():GetTeamNumber(), false)
				--end
			else
				-- Do Cleave particle for melee heroes
				local cleave_particle 		= "particles/item/silver_edge/silver_edge_shadow_rip.vpcf"	-- Badass custom shit
				local particle_fx = ParticleManager:CreateParticle(cleave_particle, PATTACH_ABSORIGIN, self:GetParent())
				ParticleManager:SetParticleControl(particle_fx, 0, self:GetParent():GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle_fx)
			end

			-- Find units hit by the cleave (amazing custom function from funcs.lua)


			local enemies = FindUnitsInCone(self:GetParent():GetTeamNumber(),
				CalculateDirection(params.target, self:GetParent()),
				self:GetParent():GetAbsOrigin(),
				cleave_radius_start,
				cleave_radius_end,
				cleave_distance,
				nil,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				0,
				FIND_ANY_ORDER,
				false)

			-- Damage each unit hit by the cleave and give them the panic modifier
			for _,enemy in pairs(enemies) do
				local damager = self:GetParent()

				local damageTable =({victim = enemy,
					attacker = damager,
					ability = ability,
					damage = cleave_damage,
					damage_type = DAMAGE_TYPE_PURE})

				ApplyDamage(damageTable)

				enemy:AddNewModifier(self:GetParent(), ability, "modifier_item_imba_silver_edge_invis_panic_debuff", {duration = panic_duration})
			end

			-- Give the main target a different, longer modifier
			params.target:AddNewModifier(self:GetParent(), ability, "modifier_item_imba_silver_edge_invis_break_debuff", {duration = break_duration})

			-- Emit custom sound effect
			self:GetParent():EmitSound("Imba.SilverEdgeInvisAttack")

			-- Emit custom slash particle
			local particle_fx = ParticleManager:CreateParticle(attack_particle, PATTACH_ABSORIGIN, self:GetParent())
			ParticleManager:SetParticleControl(particle_fx, 0, params.target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_fx)

			-- Teleport ranged attackers to make the affect go from the target's vector
			if self:GetParent():IsRangedAttacker() then
				self:GetParent():SetAbsOrigin(initial_pos)
			end

			-- Remove the invis on attack
			self:Destroy()
			--end
		end
	end
end

function modifier_item_imba_silver_edge_invis:OnAbilityExecuted( keys )
	if IsServer() then
		local parent =	self:GetParent()
		-- Remove the invis on cast
		if keys.unit == parent then
			self:Destroy()
		end
	end
end

function modifier_item_imba_silver_edge_invis:OnDestroy()
	if IsServer() then
		if not self:GetParent():FindModifierByName("modifier_silver_edge_invis_flying_disabled") then
			-- Remove flying movement
			self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
			-- Destroy trees to not get stuck
			GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 175, false)
			-- Find a clear space to stand on
			ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 64)
		end
	end
end


----------------------------------
--- STACKABLE PASSIVE MODIFIER ---
----------------------------------
modifier_item_imba_silver_edge_passive = modifier_item_imba_silver_edge_passive or class({})

-- Modifier properties
function modifier_item_imba_silver_edge_passive:IsDebuff() return false end
function modifier_item_imba_silver_edge_passive:IsHidden() return true end
function modifier_item_imba_silver_edge_passive:IsPurgable() return false end
function modifier_item_imba_silver_edge_passive:IsPermanent() return true end
function modifier_item_imba_silver_edge_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_silver_edge_passive:OnCreated()
	local ability   =   self:GetAbility()

	-- Ability parameters
	if self:GetParent():IsHero() and ability then
		self.attack_damage_bonus    =   ability:GetSpecialValueFor("bonus_damage")
		self.attack_speed_bonus     =   ability:GetSpecialValueFor("bonus_attack_speed")
		self.bonus_all_stats		=	ability:GetSpecialValueFor("bonus_all_stats")
		self:CheckUnique(true)
	end
end

-- Attack speed, damage and stat bonuses
function modifier_item_imba_silver_edge_passive:DeclareFunctions()
	local funcs =   {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE            -- Flying disabler handler
	}
	return funcs
end

function modifier_item_imba_silver_edge_passive:GetModifierPreAttack_BonusDamage() return self.attack_damage_bonus end
function modifier_item_imba_silver_edge_passive:GetModifierAttackSpeedBonus_Constant() return self.attack_speed_bonus end
function modifier_item_imba_silver_edge_passive:GetModifierBonusStats_Strength() return self.bonus_all_stats end
function modifier_item_imba_silver_edge_passive:GetModifierBonusStats_Agility() return self.bonus_all_stats end
function modifier_item_imba_silver_edge_passive:GetModifierBonusStats_Intellect() return self.bonus_all_stats end

function modifier_item_imba_silver_edge_passive:OnTakeDamage(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			local parent            =   self:GetParent()
			local disable_duration  =   self:GetAbility():GetSpecialValueFor("invis_flying_damage_disable_duration")

			if params.attacker:IsHeroDamage(params.damage) then
				-- Disable flying
				parent:AddNewModifier(parent, self, "modifier_item_imba_silver_edge_invis_flying_disabled", {duration = disable_duration})
			end
		end
	end
end

--- Flying disabler handler
modifier_item_imba_silver_edge_invis_flying_disabled = modifier_item_imba_silver_edge_invis_flying_disabled or class({})

-- Modifier properties
function modifier_item_imba_silver_edge_invis_flying_disabled:IsDebuff() return false end
function modifier_item_imba_silver_edge_invis_flying_disabled:IsHidden() return true end
function modifier_item_imba_silver_edge_invis_flying_disabled:IsPurgable() return false end

function modifier_item_imba_silver_edge_invis_flying_disabled:OnCreated()
	if IsServer() then
		-- flying disabled
		self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)

		-- Destroy trees to not get stuck
		GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 175, false)
		-- Find a clear space to stand on
		ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 64)
	end
end

function modifier_item_imba_silver_edge_invis_flying_disabled:OnDestroy()
	if IsServer() then
		-- flying enabled
		if self:GetParent():FindModifierByName("modifier_item_imba_silver_edge_invis") then
			self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
		end
	end
end

-----------------------------
--- PANIC DEBUFF MODIFIER
-----------------------------
modifier_item_imba_silver_edge_invis_panic_debuff = modifier_item_imba_silver_edge_invis_panic_debuff or class({})

-- Modifier properties
function modifier_item_imba_silver_edge_invis_panic_debuff:IsDebuff() return true end
function modifier_item_imba_silver_edge_invis_panic_debuff:IsHidden() return false end
function modifier_item_imba_silver_edge_invis_panic_debuff:IsPurgable() return true end

-- Turnrate slow
function modifier_item_imba_silver_edge_invis_panic_debuff:OnCreated()
	local ability   =   self:GetAbility()

	self.turnrate   		=   ability:GetSpecialValueFor("panic_turnrate_slow")
	self.damage_reduction	=	ability:GetSpecialValueFor("panic_damage_reduction")

end

function modifier_item_imba_silver_edge_invis_panic_debuff:CheckState()
	local state ={
		[MODIFIER_STATE_PASSIVES_DISABLED]= true
	}
	return state
end

function modifier_item_imba_silver_edge_invis_panic_debuff:DeclareFunctions()
	local funcs =   {
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function modifier_item_imba_silver_edge_invis_panic_debuff:GetModifierTurnRate_Percentage() return self.turnrate end
function modifier_item_imba_silver_edge_invis_panic_debuff:GetModifierTotalDamageOutgoing_Percentage() return self.damage_reduction end

-- Particle
function modifier_item_imba_silver_edge_invis_panic_debuff:GetEffectName()
	return "particles/item/silver_edge/silver_edge_panic_debuff.vpcf"
end

function modifier_item_imba_silver_edge_invis_panic_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

---------------------------------------------
--- BREAK DEBUFF MODIFIER (main target only)
---------------------------------------------
modifier_item_imba_silver_edge_invis_break_debuff = modifier_item_imba_silver_edge_invis_break_debuff or class({})

-- Modifier properties
function modifier_item_imba_silver_edge_invis_break_debuff:IsDebuff() return true end
function modifier_item_imba_silver_edge_invis_break_debuff:IsHidden() return false end
function modifier_item_imba_silver_edge_invis_break_debuff:IsPurgable() return false end

-- Turnrate slow
function modifier_item_imba_silver_edge_invis_break_debuff:OnCreated()
	local ability   =   self:GetAbility()

	self.damage_reduction	=	ability:GetSpecialValueFor("panic_damage_reduction")

end

function modifier_item_imba_silver_edge_invis_break_debuff:CheckState()
	local state ={
		[MODIFIER_STATE_PASSIVES_DISABLED]= true
	}
	return state
end

function modifier_item_imba_silver_edge_invis_break_debuff:DeclareFunctions()
	local funcs =   {
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function modifier_item_imba_silver_edge_invis_break_debuff:GetModifierTotalDamageOutgoing_Percentage()
	-- Wait until the other debuff is over to reduce damage (to prevent them stacking)
	if self:GetParent():FindModifierByName("modifier_item_imba_silver_edge_invis_panic_debuff") then
		return 0
	else
		return self.damage_reduction
	end
end

--- PARTICLE FOR RANGED CLEAVE
modifier_item_imba_silver_edge_invis_attack_cleave_particle = modifier_item_imba_silver_edge_invis_attack_cleave_particle or class({})

-- Modifier properties
function modifier_item_imba_silver_edge_invis_attack_cleave_particle:IsDebuff() return false end
function modifier_item_imba_silver_edge_invis_attack_cleave_particle:IsHidden() return true end
function modifier_item_imba_silver_edge_invis_attack_cleave_particle:IsPurgable() return false end

function modifier_item_imba_silver_edge_invis_attack_cleave_particle:OnCreated(params)
	if IsServer() then
		-- Make the dummy face towards the target for the cleave effect particle
		local direction = Vector(params.direction_x, params.direction_y, params.direction_z)
		self:GetParent():SetForwardVector(direction)

		-- Emit cleave particle
		local cleave_particle 		= "particles/item/silver_edge/silver_edge_shadow_rip.vpcf"	-- Badass custom shit
		local particle_fx = ParticleManager:CreateParticle(cleave_particle, PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(particle_fx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_fx)

	end
end

function modifier_item_imba_silver_edge_invis_attack_cleave_particle:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end
