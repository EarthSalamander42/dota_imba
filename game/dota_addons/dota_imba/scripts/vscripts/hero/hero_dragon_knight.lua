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
--     SquawkyArctangent
--     EarthSalamander #42
--

---------------------------
--		BREATH FIRE  	 --
---------------------------

LinkLuaModifier("modifier_imba_breathe_fire_debuff", "hero/hero_dragon_knight", LUA_MODIFIER_MOTION_NONE)

imba_dragon_knight_breathe_fire = class({})

function imba_dragon_knight_breathe_fire:GetAbilityTextureName()
   return "dragon_knight_breathe_fire"
end

function imba_dragon_knight_breathe_fire:IsHiddenWhenStolen()
	return false
end

function imba_dragon_knight_breathe_fire:OnSpellStart()
local ability = self
local target = self:GetCursorTarget()
local target_point = self:GetCursorPosition()
local speed = self:GetSpecialValueFor("speed")

	EmitSoundOn("Hero_DragonKnight.BreathFire", self:GetCaster())

	local projectile = {
		Ability = self,
		EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
		vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
		fDistance = self:GetSpecialValueFor("range"),
		fStartRadius = self:GetSpecialValueFor("start_radius"),
		fEndRadius = self:GetSpecialValueFor("end_radius"),
		Source = self:GetCaster(),
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = self:GetAbilityTargetTeam(),							
		iUnitTargetType = self:GetAbilityTargetType(),							
		bDeleteOnHit = false,
		vVelocity = (((target_point - self:GetCaster():GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()) * speed,
		bProvidesVision = false,							
	}

	ProjectileManager:CreateLinearProjectile(projectile)

	if self:GetCaster():HasTalent("special_bonus_imba_dragon_knight_5") then
		print("Purge hero!")
		self:GetCaster():Purge(false, true, false, true, true)
	end
end 

function imba_dragon_knight_breathe_fire:OnProjectileHit(target, location)
	if IsServer() then
		local debuff_duration = self:GetSpecialValueFor("duration")
		local damage = self:GetSpecialValueFor("damage")
		local health_as_damage = self:GetCaster():GetHealth() / 100 * self:GetSpecialValueFor("health_as_damage")
		local damage_type = DAMAGE_TYPE_MAGICAL

		-- if no target was found, do nothing
		if not target then
			return nil
		end

		if self:GetCaster():HasTalent("special_bonus_imba_dragon_knight_1") then
			health_as_damage = self:GetCaster():GetMaxHealth() / 100 * self:GetSpecialValueFor("health_as_damage")
		end

		if self:GetCaster():HasTalent("special_bonus_imba_dragon_knight_4") then
			damage_type = DAMAGE_TYPE_PURE
		end

		-- Deal damage
		ApplyDamage({victim = target, damage = damage + health_as_damage, damage_type = damage_type, attacker = self:GetCaster(), ability = self})	

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, health_as_damage, nil)
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_breathe_fire_debuff", {duration = debuff_duration})
	end
end

modifier_imba_breathe_fire_debuff = class({})

function modifier_imba_breathe_fire_debuff:OnCreated()
	self.strength_reduction = 0

	if self:GetCaster():HasTalent("special_bonus_imba_dragon_knight_3") then
		self.strength_reduction = self:GetCaster():FindTalentValue("special_bonus_imba_dragon_knight_3") / 100
		self.strength_reduction = -self:GetParent():GetStrength() * self.strength_reduction
	end
end

function modifier_imba_breathe_fire_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifier_imba_breathe_fire_debuff:GetModifierBaseDamageOutgoing_Percentage()
    return self:GetAbility():GetSpecialValueFor("reduction")
end

function modifier_imba_breathe_fire_debuff:GetModifierBonusStats_Strength()
	return self.strength_reduction
end

function modifier_imba_breathe_fire_debuff:GetEffectName()
	return "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire_trail.vpcf"
end

function modifier_imba_breathe_fire_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end	
function modifier_imba_breathe_fire_debuff:IsHidden() return false end
function modifier_imba_breathe_fire_debuff:IsPurgable() return true end
function modifier_imba_breathe_fire_debuff:IsDebuff() return true end

---------------------------
--		Dragon Tail  	 --
---------------------------

LinkLuaModifier("modifier_imba_dragon_tail", "hero/hero_dragon_knight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dragon_tail_miss", "hero/hero_dragon_knight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dragon_tail_debuff", "hero/hero_dragon_knight.lua", LUA_MODIFIER_MOTION_NONE)

imba_dragon_knight_dragon_tail = class({})

function imba_dragon_knight_dragon_tail:GetCastRange()
self.cast_range = 150

	if self:GetCaster() and self:GetCaster().HasModifier and self:GetCaster():HasModifier("modifier_dragon_knight_dragon_form") then
		self.cast_range = self:GetSpecialValueFor("dragon_cast_range")
	end

	return self.cast_range
end

function imba_dragon_knight_dragon_tail:OnSpellStart()
	if IsServer() then
		self.main_target = self:GetCursorTarget()
		local speed = self:GetSpecialValueFor("projectile_speed")

		if self.main_target then
			if not self:GetCaster():HasModifier("modifier_dragon_knight_dragon_form") then
				self.main_target:EmitSound("Hero_DragonKnight.DragonTail.Target")
				ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.main_target)
				self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_dragon_tail", {duration = self:GetSpecialValueFor("duration_instances")})
				self.main_target:AddNewModifier(self:GetCaster(), self, "modifier_imba_dragon_tail_debuff", {duration = self:GetSpecialValueFor("stun_duration")})

				ApplyDamage({attacker = self:GetCaster(), victim = self.main_target, damage_type = self:GetAbilityDamageType(), damage = self:GetAbilityDamage(), ability = self})
			else
				self:GetCaster():EmitSound("Hero_DragonKnight.DragonTail.DragonFormCast")

				local cleave_particle = "particles/item/silver_edge/silver_edge_shadow_rip.vpcf"	-- Badass custom shit
				local particle_fx = ParticleManager:CreateParticle(cleave_particle, PATTACH_ABSORIGIN, self:GetCaster())
				ParticleManager:SetParticleControl(particle_fx, 0, self:GetCaster():GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle_fx)

				local enemies_to_cleave = FindUnitsInCone(self:GetCaster():GetTeamNumber(), CalculateDirection(self.main_target, self:GetCaster()), self:GetCaster():GetAbsOrigin(), self:GetSpecialValueFor("start_radius"), self:GetSpecialValueFor("end_radius"), self:GetSpecialValueFor("dragon_cast_range"), nil, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
				for _, enemy in pairs (enemies_to_cleave) do
					self.main_target:EmitSound("Hero_DragonKnight.DragonTail.Target")
					ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.main_target)
					if not enemy:HasModifier("modifier_imba_dragon_tail_debuff") then
						ApplyDamage({attacker = self:GetCaster(), victim = enemy, ability = self, damage = self:GetAbilityDamage(), damage_type = self:GetAbilityDamageType()})
					end

					enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_dragon_tail_debuff", {duration = self:GetSpecialValueFor("stun_duration") /2})
				end

				local info = 
				{
					Target = self.main_target,
					Source = self:GetCaster(),
					Ability = self, 
					EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail_dragonform_proj.vpcf",
					iMoveSpeed = speed,
				}
				ProjectileManager:CreateTrackingProjectile(info)
			end
		end
	end
end

function imba_dragon_knight_dragon_tail:OnProjectileHit(target, location, ExtraData)
	if IsServer() then
		if target then
			if target:TriggerSpellAbsorb(self) then
				return
			end

			target:EmitSound("Hero_DragonKnight.DragonTail.Target")

			ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)

			if not target:HasModifier("modifier_imba_dragon_tail_debuff") then
				ApplyDamage({attacker = self:GetCaster(), victim = target, damage_type = self:GetAbilityDamageType(), damage = self:GetAbilityDamage(), ability = self})
			end

			target:AddNewModifier(self:GetCaster(), self, "modifier_imba_dragon_tail_debuff", {duration = self:GetSpecialValueFor("stun_duration")})
		end
	end
end

modifier_imba_dragon_tail = modifier_imba_dragon_tail or class({})

function modifier_imba_dragon_tail:IsHidden() return false end
function modifier_imba_dragon_tail:IsPurgable() return false end
function modifier_imba_dragon_tail:IsPermanent() return true end
function modifier_imba_dragon_tail:RemoveOnDeath() return false end
function modifier_imba_dragon_tail:IsDebuff() return false end

function modifier_imba_dragon_tail:OnCreated()
	if IsServer() then
		self.attackers = self.attackers or {}

		--SORRY RUBICK!
		if self:GetAbility():IsStolen() then
			self:Destroy()
		end

		--initialize stack count
		self:GetCaster():SetModifierStackCount("modifier_imba_dragon_tail", self:GetCaster(), self:GetAbility():GetSpecialValueFor("instances"))
	end
end

function modifier_imba_dragon_tail:DeclareFunctions()
	local funcs = {MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_FINISHED,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}

	return funcs
end

function modifier_imba_dragon_tail:GetModifierEvasion_Constant(params)
	--If the attack is to be parried, maximize evasion
	local parried = false

	for k,v in pairs(self.attackers) do
		if v == params.attacker then --has the attacker launched an attack to parry?
			parried = true
			break
		end
	end

	if parried then
		return 100
	else
		return 0
	end
end

function modifier_imba_dragon_tail:OnAttackStart(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target
		--proceed only if the target is Pangolier and the attacker is an hero
		if target == self:GetCaster() and attacker:GetTeam() ~= target:GetTeam() then
			--if no parry stacks remains, do nothing
			local stacks = self:GetStackCount()

			if stacks == 0 then
				--clears the attackers table to avoid inconsistencies
				self.attackers = {}
				target:RemoveModifierByName("modifier_imba_dragon_tail")
				return nil
			end

			--Makes the attacking hero ignore true strike
			attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_dragon_tail_miss", {})

			--Register the attacker
			table.insert(self.attackers, attacker)
		end
	end
end

function modifier_imba_dragon_tail:OnAttackFinished(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		--Proceed only if the target is Pangolier and the attacker is an hero
		if target == self:GetCaster() and attacker:IsHero() then
			--Remove debuff on attacker and remove him from table
			if attacker:HasModifier("modifier_imba_dragon_tail_miss") then
				attacker:RemoveModifierByName("modifier_imba_dragon_tail_miss")
				for k,v in pairs(self.attackers) do
					if v == attacker then
						table.remove(self.attackers, k)
					end
				end
			end

			self:SetStackCount(self:GetStackCount() -1)
		end
	end
end

--Attackers debuff: deny their true strike effect while Pangolier is parrying their attack
modifier_imba_dragon_tail_miss = modifier_imba_dragon_tail_miss or class({})

function modifier_imba_dragon_tail_miss:IsHidden() return true end
function modifier_imba_dragon_tail_miss:IsDebuff() return true end
function modifier_imba_dragon_tail_miss:IsPurgable() return false end
function modifier_imba_dragon_tail_miss:RemoveOnDeath() return true end
function modifier_imba_dragon_tail_miss:StatusEffectPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_imba_dragon_tail_miss:CheckState()
	state = {[MODIFIER_STATE_CANNOT_MISS] = false}

	return state
end

modifier_imba_dragon_tail_debuff = class({})

function modifier_imba_dragon_tail_debuff:CheckState()
	local state = {}

	if self:GetCaster():HasTalent("special_bonus_imba_dragon_knight_7") then
		state[MODIFIER_STATE_PASSIVES_DISABLED]	= true
	end

	state[MODIFIER_STATE_STUNNED] = true

	return state
end

function modifier_imba_dragon_tail_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}

	return decFuncs
end

function modifier_imba_dragon_tail_debuff:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_imba_dragon_tail_debuff:IsPurgable() return false end
function modifier_imba_dragon_tail_debuff:IsPurgeException() return true end
function modifier_imba_dragon_tail_debuff:IsStunDebuff() return true end
function modifier_imba_dragon_tail_debuff:IsHidden() return false end
function modifier_imba_dragon_tail_debuff:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_imba_dragon_tail_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

---------------------
--	Dragon Blood   --
---------------------

LinkLuaModifier("modifier_imba_dragon_blood", "hero/hero_dragon_knight.lua", LUA_MODIFIER_MOTION_NONE)

imba_dragon_knight_dragon_blood = imba_dragon_knight_dragon_blood or class({})

function imba_dragon_knight_dragon_blood:GetIntrinsicModifierName()
	return "modifier_imba_dragon_blood"
end

modifier_imba_dragon_blood = modifier_imba_dragon_blood or class({})

function modifier_imba_dragon_blood:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_imba_dragon_blood:GetModifierConstantHealthRegen()
	if self:GetCaster():PassivesDisabled() then return end
	if self:GetCaster():HasModifier("modifier_dragon_knight_dragon_form") then
		return self:GetAbility():GetSpecialValueFor("bonus_health_regen") * 2
	else
		return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	end
end

function modifier_imba_dragon_blood:GetModifierPhysicalArmorBonus()
	if self:GetCaster():PassivesDisabled() then return end
	if self:GetCaster():HasModifier("modifier_dragon_knight_dragon_form") then
		return self:GetAbility():GetSpecialValueFor("bonus_armor") * 2
	else
		return self:GetAbility():GetSpecialValueFor("bonus_armor")
	end
end

---------------------------
--	Elder Dragon Charge	 --
---------------------------

LinkLuaModifier( "modifier_imba_elder_dragon_charge", "hero/hero_dragon_knight.lua", LUA_MODIFIER_MOTION_NONE )

imba_dragon_knight_elder_dragon_charge = class({})

function imba_dragon_knight_elder_dragon_charge:IsInnateAbility()
	return true
end

function imba_dragon_knight_elder_dragon_charge:OnUpgrade()
	self:SetActivated(false)
end

function imba_dragon_knight_elder_dragon_charge:OnSpellStart()
local caster_loc = self:GetCaster():GetAbsOrigin()
local direction =  self:GetCaster():GetForwardVector()
local initial_radius = self:GetSpecialValueFor("initial_radius")
local final_radius = self:GetSpecialValueFor("final_radius")
local cone_length = self:GetSpecialValueFor("cone_length")
local fire_speed = self:GetSpecialValueFor("fire_speed")
local rush_distance = self:GetSpecialValueFor("rush_distance") + GetCastRangeIncrease(self:GetCaster()) + self:GetCaster():FindTalentValue("special_bonus_imba_dragon_knight_2")
local rush_speed = rush_distance / self:GetSpecialValueFor("rush_duration")

	self:GetCaster():EmitSound("Hero_DragonKnight.BreathFire")

	-- Create projectiles
	local jet_projectile = {
		Ability				= self,
		EffectName			= "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
		vSpawnOrigin		= caster_loc + Vector(0, 0, 100),
		fDistance			= cone_length,
		fStartRadius		= initial_radius,
		fEndRadius			= final_radius,
		Source				= self:GetCaster(),
		bHasFrontalCone		= true,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime 		= GameRules:GetGameTime() + 10.0,
		bDeleteOnHit		= false,
		vVelocity			= Vector(direction.x, direction.y, 0) * (-1) * fire_speed,
		bProvidesVision		= false,
	}

	local rush_projectile = {
		Ability				= self,
		EffectName			= "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
		vSpawnOrigin		= caster_loc + Vector(0, 0, 100),
		fDistance			= rush_distance,
		fStartRadius		= initial_radius,
		fEndRadius			= initial_radius,
		Source				= self:GetCaster(),
		bHasFrontalCone		= true,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime 		= GameRules:GetGameTime() + 10.0,
		bDeleteOnHit		= false,
		vVelocity			= Vector(direction.x, direction.y, 0) * rush_speed,
		bProvidesVision		= false,
	}

	ProjectileManager:CreateLinearProjectile(jet_projectile)
	Timers:CreateTimer(0.1, function()
		ProjectileManager:CreateLinearProjectile(rush_projectile)
	end)

	-- Move the caster
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_elder_dragon_charge", {duration = self:GetSpecialValueFor("rush_duration"), distance = rush_distance})
end

function imba_dragon_knight_elder_dragon_charge:OnProjectileHit(target, location)
	if not target then return end

	if IsServer() then
		local breathe_fire = self:GetCaster():FindAbilityByName("imba_dragon_knight_breathe_fire")
		local dragon_tail = self:GetCaster():FindAbilityByName("imba_dragon_knight_dragon_tail")
		local health_as_damage = self:GetCaster():GetHealth() / 100 * breathe_fire:GetSpecialValueFor("health_as_damage")
		local dmg_type = DAMAGE_TYPE_MAGICAL

		if self:GetCaster():HasTalent("special_bonus_imba_dragon_knight_1") then
			health_as_damage = self:GetCaster():GetMaxHealth() / 100 * breathe_fire:GetSpecialValueFor("health_as_damage")
		end

		if self:GetCaster():HasTalent("special_bonus_imba_dragon_knight_4") then
			dmg_type = DAMAGE_TYPE_PURE
		end

		ApplyDamage({attacker = self:GetCaster(), victim = target, damage = breathe_fire:GetSpecialValueFor("damage") + health_as_damage, damage_type = dmg_type, ability = breathe_fire})	
		ApplyDamage({attacker = self:GetCaster(), victim = target, damage = dragon_tail:GetAbilityDamage(), damage_type = dragon_tail:GetAbilityDamageType(), ability = dragon_tail})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, health_as_damage, nil)

		target:EmitSound("Hero_DragonKnight.DragonTail.Target")
		ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)

		if self:GetCaster():HasTalent("special_bonus_imba_dragon_knight_5") then
			self:GetCaster():Purge(false, true, false, true, true)
		end

		self:GetCaster():AddNewModifier(self:GetCaster(), dragon_tail, "modifier_imba_dragon_tail", {duration = dragon_tail:GetSpecialValueFor("duration_instances")})
		target:AddNewModifier(self:GetCaster(), breathe_fire, "modifier_imba_breathe_fire_debuff", {duration = breathe_fire:GetSpecialValueFor("duration")})
		target:AddNewModifier(self:GetCaster(), dragon_tail, "modifier_imba_dragon_tail_debuff", {duration = dragon_tail:GetSpecialValueFor("stun_duration")})
	end
end

function imba_dragon_knight_elder_dragon_charge:GetIntrinsicModifierName()
	if self:GetCaster():HasScepter() then
		return "modifier_imba_elder_dragon_charge"
	end
end

modifier_imba_elder_dragon_charge = class({})

function modifier_imba_elder_dragon_charge:IsDebuff() return false end
function modifier_imba_elder_dragon_charge:IsHidden() return true end
function modifier_imba_elder_dragon_charge:IsPurgable() return false end
function modifier_imba_elder_dragon_charge:IsStunDebuff() return false end
function modifier_imba_elder_dragon_charge:IsMotionController() return true end
function modifier_imba_elder_dragon_charge:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_elder_dragon_charge:CheckState()
	state = {[MODIFIER_STATE_STUNNED] = true}

	return state
end

function modifier_imba_elder_dragon_charge:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(FrameTime())
		self.direction = self:GetParent():GetForwardVector()
		self.movement_tick = self.direction * keys.distance / ( self:GetDuration() / FrameTime() )
	end
end

function modifier_imba_elder_dragon_charge:GetEffectName() return "particles/hero/scaldris/jet_blaze.vpcf" end

function modifier_imba_elder_dragon_charge:OnDestroy()
	if IsServer() then
		ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
	end
end

function modifier_imba_elder_dragon_charge:OnIntervalThink()
	if IsServer() then
		-- Remove motion controller if conflicting with another
		if not self:CheckMotionControllers() then
			self:Destroy()
			return
		end

		-- Continue moving
		local unit = self:GetParent()
		local position = unit:GetAbsOrigin()
		GridNav:DestroyTreesAroundPoint(position, 100, false)
		unit:SetAbsOrigin(GetGroundPosition(position + self.movement_tick, unit))
	end
end

---------------------------
--	Elder Dragon Form  	 --
---------------------------

LinkLuaModifier( "modifier_imba_elder_dragon_form", "hero/hero_dragon_knight.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_elder_dragon_form_debuff", "hero/hero_dragon_knight.lua", LUA_MODIFIER_MOTION_NONE )

imba_dragon_knight_elder_dragon_form = class({})

-- this makes the ability passive when it has scepter
function imba_dragon_knight_elder_dragon_form:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end

	return self.BaseClass.GetBehavior( self )
end

-- this is meant to accompany the above, removing the mana cost and cooldown
-- from the tooltip when it becomes passive
function imba_dragon_knight_elder_dragon_form:GetCooldown( level )
	if self:GetCaster():HasScepter() then
		return 0
	end

	return self.BaseClass.GetCooldown( self, level )
end

function imba_dragon_knight_elder_dragon_form:GetManaCost( level )
	if self:GetCaster():HasScepter() then
		return 0
	end

	return self.BaseClass.GetManaCost( self, level )
end

function imba_dragon_knight_elder_dragon_form:OnSpellStart()
	modifier_imba_elder_dragon_form:AddElderForm(self:GetCaster(), self, self:GetLevel(), self:GetSpecialValueFor("duration"))
end

function imba_dragon_knight_elder_dragon_form:GetIntrinsicModifierName()
	if self:GetCaster():HasScepter() then
		return "modifier_imba_elder_dragon_form"
	end
end

function imba_dragon_knight_elder_dragon_form:OnUpgrade()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_elder_dragon_form", {})

	if self:GetCaster():HasScepter() then
		modifier_imba_elder_dragon_form:AddElderForm(self:GetCaster(), self, self:GetLevel())
	end
end

function imba_dragon_knight_elder_dragon_form:OnInventoryContentsChanged()
	if self:GetCaster():HasScepter() then
		modifier_imba_elder_dragon_form:AddElderForm(self:GetCaster(), self, self:GetLevel())
	else
		if self:GetCaster():HasModifier("modifier_dragon_knight_dragon_form") and self:GetCaster():FindModifierByName("modifier_dragon_knight_dragon_form"):GetDuration() == -1 then
			self:GetCaster():RemoveModifierByName("modifier_dragon_knight_dragon_form")
			self:GetCaster():RemoveModifierByName("modifier_dragon_knight_corrosive_breath")
			self:GetCaster():RemoveModifierByName("modifier_dragon_knight_splash_attack")
			self:GetCaster():RemoveModifierByName("modifier_dragon_knight_frost_breath")
		end
	end
end

modifier_imba_elder_dragon_form = class({})

function modifier_imba_elder_dragon_form:IsHidden() return true end
function modifier_imba_elder_dragon_form:IsDebuff() return false end
function modifier_imba_elder_dragon_form:IsPurgable() return false end
function modifier_imba_elder_dragon_form:RemoveOnDeath() return false end

function modifier_imba_elder_dragon_form:OnCreated( event )
	self:StartIntervalThink(0.5)

	-- apply all the edf modifiers on creation if has scepter
	if self:GetParent():HasScepter() then
		modifier_imba_elder_dragon_form:AddElderForm(self:GetParent(), self:GetAbility(), self:GetAbility():GetLevel())
	end
end

if IsServer() then
	function modifier_imba_elder_dragon_form:OnRefresh( event )
		-- apply all the edf modifiers on creation if has scepter
		if self:GetParent():HasScepter() then
			modifier_imba_elder_dragon_form:AddElderForm(self:GetParent(), self:GetAbility(), self:GetAbility():GetLevel())
		end
	end

	function modifier_imba_elder_dragon_form:DeclareFunctions()
		local funcs = {
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_EVENT_ON_RESPAWN,
			MODIFIER_EVENT_ON_DEATH,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		}

		return funcs
	end

	function modifier_imba_elder_dragon_form:OnRespawn( event )
		if event.unit == self:GetParent() and self:GetParent():HasScepter() then
			-- apply the edf modifiers on respawn
			modifier_imba_elder_dragon_form:AddElderForm(self:GetParent(), self:GetAbility(), self:GetAbility():GetLevel())
		end
	end

	function modifier_imba_elder_dragon_form:OnIntervalThink()
		if self:GetParent().HasModifier and self:GetParent():HasModifier("modifier_dragon_knight_dragon_form") then
			self:GetParent():FindAbilityByName("imba_dragon_knight_elder_dragon_charge"):SetActivated(true)
		else
			self:GetParent():FindAbilityByName("imba_dragon_knight_elder_dragon_charge"):SetActivated(false)
		end

		if self:GetParent():HasTalent("special_bonus_imba_dragon_knight_6") and self:GetParent():HasModifier("modifier_dragon_knight_dragon_form") then
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():FindTalentValue("special_bonus_imba_dragon_knight_6", "radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_DAMAGE_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_elder_dragon_form_debuff", {duration=1.0})
			end
		end

		if self:GetParent():HasModifier("modifier_item_ultimate_scepter_consumed") then
			self:AddElderForm(self:GetParent(), self:GetAbility(), self:GetAbility():GetLevel())
		end

		if self:GetParent():HasScepter() then
			if self:GetParent():PassivesDisabled() then
				print("Passive Disabled!")
				self:GetParent():RemoveModifierByName("modifier_dragon_knight_dragon_form")
				self:GetParent():RemoveModifierByName("modifier_dragon_knight_corrosive_breath")
				self:GetParent():RemoveModifierByName("modifier_dragon_knight_splash_attack")
				self:GetParent():RemoveModifierByName("modifier_dragon_knight_frost_breath")
			else
				self:AddElderForm(self:GetParent(), self:GetAbility(), self:GetAbility():GetLevel())
			end
		end

		if self:GetParent():HasTalent("special_bonus_imba_dragon_knight_8") and self:GetParent():HasModifier("modifier_dragon_knight_dragon_form") then
			self.bonus_ms = self:GetCaster():GetHealthPercent() * self:GetParent():FindTalentValue("special_bonus_imba_dragon_knight_8")
			self:SetStackCount(self.bonus_ms)
		else
			self:SetStackCount(0)
		end
	end

	function modifier_imba_elder_dragon_form:AddElderForm(hero, ability, level, duration)
		local modifier_duration = -1
		if not self.level then self.level = 0 end
		if duration then modifier_duration = duration end

		-- Don't transform again if already in permanent form
		if hero:HasModifier("modifier_dragon_knight_dragon_form") and hero:FindModifierByName("modifier_dragon_knight_dragon_form"):GetDuration() == -1 and modifier_duration == -1 and self.level == level then
			return
		end

		if level >= 1 then
			hero:AddNewModifier(hero, ability, "modifier_dragon_knight_dragon_form", {duration = modifier_duration})
			hero:AddNewModifier(hero, ability, "modifier_dragon_knight_corrosive_breath", {duration = modifier_duration})
		end

		if level >= 2 then
			hero:AddNewModifier(hero, ability, "modifier_dragon_knight_splash_attack", {duration = modifier_duration})
		end

		if level >= 3 then
			hero:AddNewModifier(hero, ability, "modifier_dragon_knight_frost_breath", {duration = modifier_duration})
		end

		self.level = level
	end
end

function modifier_imba_elder_dragon_form:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()
end

modifier_imba_elder_dragon_form_debuff = class({})

function modifier_imba_elder_dragon_form_debuff:IsHidden() return false end
function modifier_imba_elder_dragon_form_debuff:IsDebuff() return true end
function modifier_imba_elder_dragon_form_debuff:IsHidden() return false end
function modifier_imba_elder_dragon_form_debuff:IsPurgable() return false end

function modifier_imba_elder_dragon_form_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function modifier_imba_elder_dragon_form_debuff:GetModifierBaseDamageOutgoing_Percentage()
    return self:GetCaster():FindTalentValue("special_bonus_imba_dragon_knight_6", "reduction")
end

function modifier_imba_elder_dragon_form_debuff:GetEffectName() return "particles/econ/items/windrunner/windrunner_cape_cascade/windrunner_windrun_slow_cascade.vpcf" end
function modifier_imba_elder_dragon_form_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
