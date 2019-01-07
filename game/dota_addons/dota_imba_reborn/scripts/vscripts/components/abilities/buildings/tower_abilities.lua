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
--     Firetoad, 06.09.2015
--     suthernfriend, 03.02.2018

function HexAura( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_slow = keys.modifier_slow

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local hex_aoe = ability:GetLevelSpecialValueFor("hex_aoe", ability_level)
	local hex_duration = ability:GetLevelSpecialValueFor("hex_duration", ability_level)
	local min_creeps = ability:GetLevelSpecialValueFor("min_creeps", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local creeps = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, hex_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, hex_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #creeps >= min_creeps or #heroes >= 1 then

		-- Choose a random hero to be the modifier owner (having a non-hero hex modifier owner crashes the game)
		local hero_owner = HeroList:GetHero(0)

		-- Hex enemies
		for _,enemy in pairs(creeps) do
			if enemy:IsIllusion() then
				enemy:ForceKill(true)
			else
				enemy:AddNewModifier(hero_owner, ability, "modifier_sheepstick_debuff", {duration = hex_duration})
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})
			end
		end
		for _,enemy in pairs(heroes) do
			if enemy:IsIllusion() then
				enemy:ForceKill(true)
			else
				enemy:AddNewModifier(hero_owner, ability, "modifier_sheepstick_debuff", {duration = hex_duration})
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})
			end
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end

function ManaFlare( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_burn = keys.particle_burn
	local sound_burn = keys.sound_burn

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local burn_aoe = ability:GetLevelSpecialValueFor("burn_aoe", ability_level)
	local burn_pct = ability:GetLevelSpecialValueFor("burn_pct", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, burn_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #heroes >= 1 then

		-- Play sound
		caster:EmitSound(sound_burn)

		-- Iterate through enemies
		for _,enemy in pairs(heroes) do

			-- Burn mana
			local mana_to_burn = enemy:GetMaxMana() * burn_pct / 100
			enemy:ReduceMana(mana_to_burn)

			-- Play mana burn particle
			local mana_burn_pfx = ParticleManager:CreateParticle(particle_burn, PATTACH_ABSORIGIN, enemy)
			ParticleManager:SetParticleControl(mana_burn_pfx, 0, enemy:GetAbsOrigin())
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end

function Chronotower( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_stun = keys.sound_stun
	local modifier_stun = keys.modifier_stun

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local stun_radius = ability:GetLevelSpecialValueFor("stun_radius", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local min_creeps = ability:GetLevelSpecialValueFor("min_creeps", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local creeps = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #creeps >= min_creeps or #heroes >= 1 then

		-- Play sound
		caster:EmitSound(sound_stun)

		-- Stun enemies
		for _,enemy in pairs(creeps) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_stun, {})
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
		end
		for _,enemy in pairs(heroes) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_stun, {})
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end


function Reality( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_reality = keys.sound_reality

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local reality_aoe = ability:GetLevelSpecialValueFor("reality_aoe", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, reality_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Kill any existing illusions
	local ability_used = false
	for _,enemy in pairs(heroes) do
		if enemy:IsIllusion() then
			enemy:ForceKill(true)
			ability_used = true
		end
	end

	-- If the ability was used, play the sound and put it on cooldown
	if ability_used then

		-- Play sound
		caster:EmitSound(sound_reality)

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end

function Force( keys )
	local caster = keys.caster
	local ability = keys.ability
	local sound_force = keys.sound_force

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local force_aoe = ability:GetSpecialValueFor("force_aoe")
	local force_distance = ability:GetSpecialValueFor("force_distance")
	local force_duration = ability:GetSpecialValueFor("force_duration")
	local min_creeps = ability:GetSpecialValueFor("min_creeps")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local tower_loc = caster:GetAbsOrigin()
	local knockback_param

	-- Find nearby enemies
	local creeps = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, force_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, force_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #creeps >= min_creeps or #heroes >= 1 then

		-- Play sound
		caster:EmitSound(sound_force)

		-- Knockback enemies
		for _,enemy in pairs(creeps) do
			-- Set up knockback parameters
			knockback_param =
				{	should_stun = 1,
					knockback_duration = force_duration,
					duration = force_duration,
					knockback_distance = force_distance,
					knockback_height = 0,
					center_x = tower_loc.x,
					center_y = tower_loc.y,
					center_z = tower_loc.z
				}
			enemy:RemoveModifierByName("modifier_knockback")
			enemy:AddNewModifier(caster, nil, "modifier_knockback", knockback_param)


		end

		for _,enemy in pairs(heroes) do
			-- Calculate distance from tower
			local distance = (enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()

			-- Create dummy that knockbacks toward the tower
			local direction = (enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
			local knockback_dummy_loc = enemy:GetAbsOrigin() + direction * 150
			local knockback_dummy = CreateUnitByName("npc_dummy_unit", knockback_dummy_loc, false, caster, caster, caster:GetTeamNumber())

			-- Set up knockback parameters
			knockback_param =
				{	should_stun = 1,
					knockback_duration = force_duration,
					duration = force_duration,
					knockback_distance = distance-180,
					knockback_height = 0,
					center_x = knockback_dummy:GetAbsOrigin().x,
					center_y = knockback_dummy:GetAbsOrigin().y,
					center_z = knockback_dummy:GetAbsOrigin().z
				}

			enemy:RemoveModifierByName("modifier_knockback")
			enemy:AddNewModifier(caster, nil, "modifier_knockback", knockback_param)

			knockback_dummy:Destroy()

			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(-1))
	end
end

function Nature( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_root = keys.sound_root
	local modifier_root = keys.modifier_root

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local root_radius = ability:GetLevelSpecialValueFor("root_radius", ability_level)
	local min_creeps = ability:GetLevelSpecialValueFor("min_creeps", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local creeps = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, root_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, root_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #creeps >= min_creeps or #heroes >= 1 then

		-- Play sound
		caster:EmitSound(sound_root)

		-- Root enemies
		for _,enemy in pairs(creeps) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_root, {})
		end
		for _,enemy in pairs(heroes) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_root, {})
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end

function Mindblast( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_silence = keys.sound_silence
	local modifier_silence = keys.modifier_silence

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local silence_radius = ability:GetLevelSpecialValueFor("silence_radius", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, silence_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #heroes >= 1 then

		-- Play sound
		caster:EmitSound(sound_silence)

		-- Silence enemies
		for _,enemy in pairs(heroes) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_silence, {})
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end

-- Fountain's Grievous Wounds
function GrievousWounds( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_debuff = keys.modifier_debuff
	local particle_hit = keys.particle_hit

	-- Parameters
	local damage_increase = ability:GetLevelSpecialValueFor("damage_increase", ability_level)

	-- Play hit particle
	local hit_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(hit_pfx, 0, target:GetAbsOrigin())

	-- Calculate bonus damage
	local base_damage = caster:GetAttackDamage()
	local current_stacks = target:GetModifierStackCount(modifier_debuff, caster)
	local total_damage = base_damage * ( 1 + current_stacks * damage_increase / 100 )

	-- Apply damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = total_damage, damage_type = DAMAGE_TYPE_PHYSICAL})

	-- Apply bonus damage modifier
	AddStacks(ability, caster, target, modifier_debuff, 1, true)
end


-- Tier 1 to 3 tower aura abilities
-- Author: Shush
-- Date: 8/2/2017

---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--		  Tower's Protective Instincts
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_tower_protective_instinct = imba_tower_protective_instinct or class({})
LinkLuaModifier("modifier_imba_tower_protective_instinct", "components/abilities/buildings/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE)

function imba_tower_protective_instinct:GetIntrinsicModifierName()
	return "modifier_imba_tower_protective_instinct"
end

function imba_tower_protective_instinct:GetAbilityTextureName()
	return "wisp_empty1"
end

-- protective instinct modifier
modifier_imba_tower_protective_instinct = modifier_imba_tower_protective_instinct or class({})

function modifier_imba_tower_protective_instinct:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		if not self.ability then
			self:Destroy()
			return nil
		end

		-- Ability specials
		self.radius = self.ability:GetSpecialValueFor("radius")

		-- Set stack count as 0 and start counting heroes
		self.stacks = 0
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_tower_protective_instinct:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_protective_instinct:OnIntervalThink()
	if IsServer() then
		local heroes = FindUnitsInRadius(self.caster:GetTeamNumber(),
			self.caster:GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
			FIND_ANY_ORDER,
			false)

		-- Set stack count to the number of heroes around the tower
		self:SetStackCount(#heroes)
	end
end

function modifier_imba_tower_protective_instinct:IsHidden()	return true end
function modifier_imba_tower_protective_instinct:IsPurgable() return false end
function modifier_imba_tower_protective_instinct:IsDebuff() return false end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Machinegun Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_machinegun = imba_tower_machinegun or class({})
LinkLuaModifier("modifier_imba_tower_machinegun_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_machinegun_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_machinegun:GetIntrinsicModifierName()
	return "modifier_imba_tower_machinegun_aura"
end

function imba_tower_machinegun:GetAbilityTextureName()
	return "gyrocopter_skyhigh_flak_cannon"
end

-- Tower Aura
modifier_imba_tower_machinegun_aura = modifier_imba_tower_machinegun_aura or class({})

function modifier_imba_tower_machinegun_aura:OnCreated()
	-- Ability properties
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_machinegun_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_machinegun_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_machinegun_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_machinegun_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_machinegun_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_machinegun_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_machinegun_aura:GetModifierAura()
	return "modifier_imba_tower_machinegun_aura_buff"
end

function modifier_imba_tower_machinegun_aura:IsAura()
	return true
end

function modifier_imba_tower_machinegun_aura:IsDebuff() return false end
function modifier_imba_tower_machinegun_aura:IsHidden() return true end
function modifier_imba_tower_machinegun_aura:IsPurgable() return false end


-- Attack Speed Modifier
modifier_imba_tower_machinegun_aura_buff = modifier_imba_tower_machinegun_aura_buff or class({})

function modifier_imba_tower_machinegun_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.parent = self:GetParent()

	-- Ability specials
	self.bonus_as = self.ability:GetSpecialValueFor("bonus_as")
	self.as_per_protective_instinct = self.ability:GetSpecialValueFor("as_per_protective_instinct")
end

function modifier_imba_tower_machinegun_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_machinegun_aura_buff:IsHidden() return false end
function modifier_imba_tower_machinegun_aura_buff:IsPurgable() return false end
function modifier_imba_tower_machinegun_aura_buff:IsDebuff() return false end

function modifier_imba_tower_machinegun_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_imba_tower_machinegun_aura_buff:GetModifierAttackSpeedBonus_Constant()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

	local extra_as = self.bonus_as + self.as_per_protective_instinct * protective_instinct_stacks
	return extra_as
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Thorns Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_thorns = imba_tower_thorns or class({})
LinkLuaModifier("modifier_imba_tower_thorns_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_thorns_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_thorns:GetAbilityTextureName()
	return "custom/tower_thorns"
end

function imba_tower_thorns:GetIntrinsicModifierName()
	return "modifier_imba_tower_thorns_aura"
end

-- Tower Aura
modifier_imba_tower_thorns_aura = modifier_imba_tower_thorns_aura or class({})

function modifier_imba_tower_thorns_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_thorns_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_thorns_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_thorns_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_thorns_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_thorns_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_thorns_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_thorns_aura:GetModifierAura()
	return "modifier_imba_tower_thorns_aura_buff"
end

function modifier_imba_tower_thorns_aura:IsAura()
	return true
end

function modifier_imba_tower_thorns_aura:IsDebuff()
	return false
end

function modifier_imba_tower_thorns_aura:IsHidden()
	return true
end

-- Return damage Modifier
modifier_imba_tower_thorns_aura_buff = modifier_imba_tower_thorns_aura_buff or class({})

function modifier_imba_tower_thorns_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.parent = self:GetParent()
	self.particle_return = "particles/units/heroes/hero_centaur/centaur_return.vpcf"

	-- Ability specials
	self.return_damage_pct = self.ability:GetSpecialValueFor("return_damage_pct")
	self.return_damage_per_stack = self.ability:GetSpecialValueFor("return_damage_per_stack")
	self.minimum_damage = self.ability:GetSpecialValueFor("minimum_damage")
end

function modifier_imba_tower_thorns_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_thorns_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_thorns_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFuncs
end

function modifier_imba_tower_thorns_aura_buff:OnAttackLanded( keys )
	-- Ability properties
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target
		local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

		-- Only apply if the parent is the victim and the attacker is on the opposite team
		if self.parent == target and attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() then

			-- Create return effect
			local return_pfx = ParticleManager:CreateParticle(self.particle_return, PATTACH_ABSORIGIN, self.parent)
			ParticleManager:SetParticleControlEnt(return_pfx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(return_pfx, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(return_pfx)

			-- Get the hero's main attribute value
			local main_attribute_value = self.parent:GetPrimaryStatValue()

			-- Calculate damage based on percentage of main stat
			local return_damage_pct_final = self.return_damage_pct + self.return_damage_per_stack * protective_instinct_stacks
			local return_damage = main_attribute_value * (return_damage_pct_final * 0.01)

			-- Increase damage to the minimum if it's not sufficient
			if self.minimum_damage > return_damage then
				return_damage = self.minimum_damage
			end

			-- Apply damage
			local damageTable = {victim = attacker,
				attacker = self.parent,
				damage = return_damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self.ability}

			ApplyDamage(damageTable)
		end
	end
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Aegis Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_tower_aegis = imba_tower_aegis or class({})
LinkLuaModifier("modifier_imba_tower_aegis_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_aegis_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_aegis:GetAbilityTextureName()
	return "modifier_invulnerable"
end

function imba_tower_aegis:GetIntrinsicModifierName()
	return "modifier_imba_tower_aegis_aura"
end

-- Tower Aura
modifier_imba_tower_aegis_aura = modifier_imba_tower_aegis_aura or class({})

function modifier_imba_tower_aegis_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_aegis_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_aegis_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_aegis_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_aegis_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_aegis_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_aegis_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_aegis_aura:GetModifierAura()
	return "modifier_imba_tower_aegis_aura_buff"
end

function modifier_imba_tower_aegis_aura:IsAura()
	return true
end

function modifier_imba_tower_aegis_aura:IsDebuff()
	return false
end

function modifier_imba_tower_aegis_aura:IsHidden()
	return true
end

-- Armor increase Modifier
modifier_imba_tower_aegis_aura_buff = modifier_imba_tower_aegis_aura_buff or class({})

function modifier_imba_tower_aegis_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.armor_per_protective = self.ability:GetSpecialValueFor("armor_per_protective")

end

function modifier_imba_tower_aegis_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_aegis_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_aegis_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}

	return decFuncs
end

function modifier_imba_tower_aegis_aura_buff:GetModifierPhysicalArmorBonus()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

	return self.bonus_armor + self.armor_per_protective * protective_instinct_stacks
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Toughness Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_tower_toughness = imba_tower_toughness or class({})
LinkLuaModifier("modifier_imba_tower_toughness_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_toughness_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_toughness:GetAbilityTextureName()
	return "custom/tower_toughness"
end

function imba_tower_toughness:GetIntrinsicModifierName()
	return "modifier_imba_tower_toughness_aura"
end

-- Tower Aura
modifier_imba_tower_toughness_aura = modifier_imba_tower_toughness_aura or class({})

function modifier_imba_tower_toughness_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_toughness_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_toughness_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_toughness_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_toughness_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_toughness_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_toughness_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_toughness_aura:GetModifierAura()
	return "modifier_imba_tower_toughness_aura_buff"
end

function modifier_imba_tower_toughness_aura:IsAura()
	return true
end

function modifier_imba_tower_toughness_aura:IsDebuff()
	return false
end

function modifier_imba_tower_toughness_aura:IsHidden()
	return true
end

-- Health increase Modifier
modifier_imba_tower_toughness_aura_buff = modifier_imba_tower_toughness_aura_buff or class({})

function modifier_imba_tower_toughness_aura_buff:OnCreated()
	if string.find(self:GetParent():GetUnitName(), "npc_dota_lone_druid_bear") then return end
	if not self:GetParent():IsRealHero() then self:Destroy() return end
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	if self:GetParent():GetUnitName() == "npc_dota_courier" then
		return nil
	end

	-- Ability specials
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.health_per_protective = self.ability:GetSpecialValueFor("health_per_protective")

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_tower_toughness_aura_buff:OnIntervalThink()
	if IsServer() then
		if not self:GetParent():IsNull() then
			self:GetParent():CalculateStatBonus()
		end
	end
end

function modifier_imba_tower_toughness_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_toughness_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_toughness_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_HEALTH_BONUS}

	return decFuncs
end

function modifier_imba_tower_toughness_aura_buff:GetModifierHealthBonus()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)
	return self.bonus_health + self.health_per_protective * protective_instinct_stacks
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Sniper Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_tower_sniper = imba_tower_sniper or class({})
LinkLuaModifier("modifier_imba_tower_sniper_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_sniper_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_sniper:GetAbilityTextureName()
	return "sniper_assassinate"
end

function imba_tower_sniper:GetIntrinsicModifierName()
	return "modifier_imba_tower_sniper_aura"
end

-- Tower Aura
modifier_imba_tower_sniper_aura = modifier_imba_tower_sniper_aura or class({})

function modifier_imba_tower_sniper_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_sniper_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_sniper_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_sniper_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_sniper_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_sniper_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_sniper_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_sniper_aura:GetModifierAura()
	return "modifier_imba_tower_sniper_aura_buff"
end

function modifier_imba_tower_sniper_aura:IsAura()
	return true
end

function modifier_imba_tower_sniper_aura:IsDebuff()
	return false
end

function modifier_imba_tower_sniper_aura:IsHidden()
	return true
end

-- Attack range Modifier
modifier_imba_tower_sniper_aura_buff = modifier_imba_tower_sniper_aura_buff or class({})

function modifier_imba_tower_sniper_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	-- Ability specials
	self.bonus_range = self.ability:GetSpecialValueFor("bonus_range")
	self.range_per_protective = self.ability:GetSpecialValueFor("range_per_protective")
end

function modifier_imba_tower_sniper_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_sniper_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_sniper_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACK_RANGE_BONUS}

	return decFuncs
end

function modifier_imba_tower_sniper_aura_buff:GetModifierAttackRangeBonus()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)
	return self.bonus_range + self.range_per_protective * protective_instinct_stacks
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Splash Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_tower_splash_fire = imba_tower_splash_fire or class({})
LinkLuaModifier("modifier_imba_tower_splash_fire_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_splash_fire_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_splash_fire:GetAbilityTextureName()
	return "custom/tower_explosion"
end

function imba_tower_splash_fire:GetIntrinsicModifierName()
	return "modifier_imba_tower_splash_fire_aura"
end

-- Tower Aura
modifier_imba_tower_splash_fire_aura = modifier_imba_tower_splash_fire_aura or class({})

function modifier_imba_tower_splash_fire_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_splash_fire_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_splash_fire_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_splash_fire_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_splash_fire_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_splash_fire_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_splash_fire_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_splash_fire_aura:GetModifierAura()
	return "modifier_imba_tower_splash_fire_aura_buff"
end

function modifier_imba_tower_splash_fire_aura:IsAura()
	return true
end

function modifier_imba_tower_splash_fire_aura:IsDebuff()
	return false
end

function modifier_imba_tower_splash_fire_aura:IsHidden()
	return true
end

-- Splash attack Modifier
modifier_imba_tower_splash_fire_aura_buff = modifier_imba_tower_splash_fire_aura_buff or class({})

function modifier_imba_tower_splash_fire_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.parent = self:GetParent()
	self.particle_explosion = "particles/ambient/tower_salvo_explosion.vpcf"

	-- Ability specials
	self.splash_damage_pct = self.ability:GetSpecialValueFor("splash_damage_pct")
	self.bonus_splash_per_protective = self.ability:GetSpecialValueFor("bonus_splash_per_protective")
	self.splash_radius = self.ability:GetSpecialValueFor("splash_radius")
end

function modifier_imba_tower_splash_fire_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_splash_fire_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_splash_fire_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFuncs
end

function modifier_imba_tower_splash_fire_aura_buff:OnAttackLanded( keys )
	if IsServer() then
		local target = keys.target --victim
		local attacker = keys.attacker --attacker
		local damage = keys.damage

		-- Only apply if the attacker is the parent of the buff, and the victim is on the opposing team.
		if self.parent == attacker and self.parent:GetTeamNumber() ~= target:GetTeamNumber() then

			-- Add explosion particle
			local explosion_pfx = ParticleManager:CreateParticle(self.particle_explosion, PATTACH_ABSORIGIN, target)
			ParticleManager:SetParticleControl(explosion_pfx, 0, target:GetAbsOrigin())
			ParticleManager:SetParticleControl(explosion_pfx, 3, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(explosion_pfx)

			-- Calculate bonus damage
			local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)
			local splash_damage = damage * ((self.splash_damage_pct + self.bonus_splash_per_protective * protective_instinct_stacks) * 0.01)

			-- Apply bonus damage on every enemy EXCEPT the main target
			local enemy_units = FindUnitsInRadius(self.parent:GetTeamNumber(),
				target:GetAbsOrigin(),
				nil,
				self.splash_radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false)

			for _,enemy in pairs(enemy_units) do
				if enemy ~= target then
					local damageTable = {victim = enemy,
						attacker = self.parent,
						damage = splash_damage,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self.ability
					}

					ApplyDamage(damageTable)
				end
			end
		end
	end
end



---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Replenishment Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_tower_replenishment = imba_tower_replenishment or class({})
LinkLuaModifier("modifier_imba_tower_replenishment_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_replenishment_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_replenishment:GetAbilityTextureName()
	return "keeper_of_the_light_chakra_magic"
end

function imba_tower_replenishment:GetIntrinsicModifierName()
	return "modifier_imba_tower_replenishment_aura"
end

-- Tower Aura
modifier_imba_tower_replenishment_aura = modifier_imba_tower_replenishment_aura or class({})

function modifier_imba_tower_replenishment_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_replenishment_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_replenishment_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_replenishment_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_replenishment_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_replenishment_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_replenishment_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_replenishment_aura:GetModifierAura()
	return "modifier_imba_tower_replenishment_aura_buff"
end

function modifier_imba_tower_replenishment_aura:IsAura()
	return true
end

function modifier_imba_tower_replenishment_aura:IsDebuff()
	return false
end

function modifier_imba_tower_replenishment_aura:IsHidden()
	return true
end

-- Cooldown reduction Modifier
modifier_imba_tower_replenishment_aura_buff = modifier_imba_tower_replenishment_aura_buff or class({})

function modifier_imba_tower_replenishment_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.cooldown_reduction_pct = self.ability:GetSpecialValueFor("cooldown_reduction_pct")
	self.bonus_cooldown_reduction = self.ability:GetSpecialValueFor("bonus_cooldown_reduction")
end

function modifier_imba_tower_replenishment_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_replenishment_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_replenishment_aura_buff:GetCustomCooldownReductionStacking()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)
	return self.cooldown_reduction_pct + self.bonus_cooldown_reduction * protective_instinct_stacks
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Observatory Vision
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_tower_observatory = imba_tower_observatory or class({})
LinkLuaModifier("modifier_imba_tower_observatory_vision", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_observatory:GetIntrinsicModifierName()
	return "modifier_imba_tower_observatory_vision"
end

function imba_tower_observatory:GetAbilityTextureName()
	return "custom/tower_observatory"
end

-- unobstructed vision modifier
modifier_imba_tower_observatory_vision = modifier_imba_tower_observatory_vision or class({})

function modifier_imba_tower_observatory_vision:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	-- Ability specials
	self.additional_vision_per_hero = self.ability:GetSpecialValueFor("additional_vision_per_hero")
end

function modifier_imba_tower_observatory_vision:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_observatory_vision:IsHidden()
	return false
end

function modifier_imba_tower_observatory_vision:CheckState()
	local state = {[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_ROOTED] = true}

	return state
end

function modifier_imba_tower_observatory_vision:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION}

	return decFuncs
end


function modifier_imba_tower_observatory_vision:GetBonusDayVision()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)
	local bonus_vision = self.additional_vision_per_hero * protective_instinct_stacks

	return bonus_vision
end

function modifier_imba_tower_observatory_vision:GetBonusNightVision()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)
	local bonus_vision = self.additional_vision_per_hero * protective_instinct_stacks

	return bonus_vision
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Spell Shield Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_tower_spell_shield = imba_tower_spell_shield or class({})
LinkLuaModifier("modifier_imba_tower_spell_shield_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_spell_shield_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_spell_shield:GetAbilityTextureName()
	return "custom/tower_spellshield"
end

function imba_tower_spell_shield:GetIntrinsicModifierName()
	return "modifier_imba_tower_spell_shield_aura"
end

-- Tower Aura
modifier_imba_tower_spell_shield_aura = modifier_imba_tower_spell_shield_aura or class({})

function modifier_imba_tower_spell_shield_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_spell_shield_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_spell_shield_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_spell_shield_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_spell_shield_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_spell_shield_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_spell_shield_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_spell_shield_aura:GetModifierAura()
	return "modifier_imba_tower_spell_shield_aura_buff"
end

function modifier_imba_tower_spell_shield_aura:IsAura()
	return true
end

function modifier_imba_tower_spell_shield_aura:IsDebuff()
	return false
end

function modifier_imba_tower_spell_shield_aura:IsHidden()
	return true
end

-- Attack range Modifier
modifier_imba_tower_spell_shield_aura_buff = modifier_imba_tower_spell_shield_aura_buff or class({})

function modifier_imba_tower_spell_shield_aura_buff:OnCreated( ... )
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.magic_resistance = self.ability:GetSpecialValueFor("magic_resistance")
	self.bonus_mr_per_protective = self.ability:GetSpecialValueFor("bonus_mr_per_protective")
end

function modifier_imba_tower_spell_shield_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_spell_shield_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_spell_shield_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}

	return decFuncs
end

function modifier_imba_tower_spell_shield_aura_buff:GetModifierMagicalResistanceBonus()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)
	return self.magic_resistance + self.bonus_mr_per_protective * protective_instinct_stacks
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Mana Burn Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_mana_burn = imba_tower_mana_burn or class({})
LinkLuaModifier("modifier_imba_tower_mana_burn_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_mana_burn_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_mana_burn:GetAbilityTextureName()
	return "custom/tower_mana_burn"
end

function imba_tower_mana_burn:GetIntrinsicModifierName()
	return "modifier_imba_tower_mana_burn_aura"
end

-- Tower Aura
modifier_imba_tower_mana_burn_aura = modifier_imba_tower_mana_burn_aura or class({})

function modifier_imba_tower_mana_burn_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_mana_burn_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_mana_burn_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_mana_burn_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_mana_burn_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_mana_burn_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_mana_burn_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_mana_burn_aura:GetModifierAura()
	return "modifier_imba_tower_mana_burn_aura_buff"
end

function modifier_imba_tower_mana_burn_aura:IsAura()
	return true
end

function modifier_imba_tower_mana_burn_aura:IsDebuff()
	return false
end

function modifier_imba_tower_mana_burn_aura:IsHidden()
	return true
end

-- Mana Burn damage Modifier
modifier_imba_tower_mana_burn_aura_buff = modifier_imba_tower_mana_burn_aura_buff or class({})

function modifier_imba_tower_mana_burn_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.particle_mana_burn = "particles/generic_gameplay/generic_manaburn.vpcf"

	-- Ability specials
	self.mana_burn = self.ability:GetSpecialValueFor("mana_burn")
	self.additional_burn_per_hero = self.ability:GetSpecialValueFor("additional_burn_per_hero")
	self.mana_burn_damage_pct = self.ability:GetSpecialValueFor("mana_burn_damage_pct")
	self.illusion_mana_burn_pct = self.ability:GetSpecialValueFor("illusion_mana_burn_pct")
end

function modifier_imba_tower_mana_burn_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_mana_burn_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_mana_burn_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFuncs
end

function modifier_imba_tower_mana_burn_aura_buff:OnAttackLanded( keys )
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target
		local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

		-- Only apply if the parent is the attacker and the victim is on the opposite team
		if self.parent == attacker and attacker:GetTeamNumber() ~= target:GetTeamNumber() then

			-- Only applies on non spell immune enemies
			if not target:IsMagicImmune() then

				-- Create mana burn effect
				local particle_mana_burn_fx = ParticleManager:CreateParticle(self.particle_mana_burn, PATTACH_ABSORIGIN, target)
				ParticleManager:SetParticleControl(particle_mana_burn_fx, 0, target:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle_mana_burn_fx)

				-- Calculate mana burn efficiency
				local target_current_mana = target:GetMana()
				local mana_burn_total = self.mana_burn + self.additional_burn_per_hero * protective_instinct_stacks

				-- Reduce mana burn and damage to the target's mana if it goes over his current mana
				if target:GetMana() < mana_burn_total then
					mana_burn_total = target_current_mana
				end

				-- Illusions burn mana on a much lower value
				if attacker:IsIllusion() then
					mana_burn_total = mana_burn_total * (self.illusion_mana_burn_pct * 0.01)
				end

				-- Calculate damage based on taget's current mana
				local mana_burn_damage = mana_burn_total * (self.mana_burn_damage_pct * 0.01)

				-- Burn target's mana
				target:ReduceMana(mana_burn_total)

				-- Apply damage
				local damageTable = {victim = target,
					attacker = self.parent,
					damage = mana_burn_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self.ability}

				ApplyDamage(damageTable)
			end
		end
	end
end




---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Bash Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_permabash = imba_tower_permabash or class({})
LinkLuaModifier("modifier_imba_tower_permabash_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_permabash_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_permabash_stun", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_permabash:GetIntrinsicModifierName()
	return "modifier_imba_tower_permabash_aura"
end

function imba_tower_permabash:GetAbilityTextureName()
	return "custom/tower_bash"
end

-- Tower Aura
modifier_imba_tower_permabash_aura = modifier_imba_tower_permabash_aura or class({})

function modifier_imba_tower_permabash_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_permabash_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_permabash_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_permabash_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_permabash_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_permabash_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_permabash_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_permabash_aura:GetModifierAura()
	return "modifier_imba_tower_permabash_aura_buff"
end

function modifier_imba_tower_permabash_aura:IsAura()
	return true
end

function modifier_imba_tower_permabash_aura:IsDebuff()
	return false
end

function modifier_imba_tower_permabash_aura:IsHidden()
	return true
end

-- Bash Modifier
modifier_imba_tower_permabash_aura_buff = modifier_imba_tower_permabash_aura_buff or class({})

function modifier_imba_tower_permabash_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.parent = self:GetParent()
	self.modifier_bash = "modifier_imba_tower_permabash_stun"

	-- Ability specials
	self.bash_damage = self.ability:GetSpecialValueFor("bash_damage")
	self.bash_duration = self.ability:GetSpecialValueFor("bash_duration")
	self.bash_damage_per_protective = self.ability:GetSpecialValueFor("bash_damage_per_protective")
	self.bash_chance = self.ability:GetSpecialValueFor("bash_chance")
end

function modifier_imba_tower_permabash_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_permabash_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_permabash_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFuncs
end

function modifier_imba_tower_permabash_aura_buff:OnAttackLanded( keys )
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target
		local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

		-- Only apply if the parent is the victim and the attacker is on the opposite team
		if self.parent == attacker and attacker:GetTeamNumber() ~= target:GetTeamNumber() then

			if RollPseudoRandom(self.bash_chance, self) then
				target:AddNewModifier(self.caster, self.ability, self.modifier_bash, {duration = self.bash_duration})

				-- Calculate damage
				local bash_damage_total = self.bash_damage + self.bash_damage_per_protective * protective_instinct_stacks

				-- Apply damage
				local damageTable = {victim = target,
					attacker = attacker,
					damage = bash_damage_total,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = self.ability}

				ApplyDamage(damageTable)
			end
		end
	end
end

-- Permabash stun modifier
modifier_imba_tower_permabash_stun = modifier_imba_tower_permabash_stun or class({})

function modifier_imba_tower_permabash_stun:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state
end

function modifier_imba_tower_permabash_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_tower_permabash_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_tower_permabash_stun:IsHidden() return false end
function modifier_imba_tower_permabash_stun:IsPurgable() return false end
function modifier_imba_tower_permabash_stun:IsDebuff() return false end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Vicious Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_vicious = imba_tower_vicious or class({})
LinkLuaModifier("modifier_imba_tower_vicious_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_vicious_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_vicious:GetAbilityTextureName()
	return "custom/tower_vicious"
end

function imba_tower_vicious:GetIntrinsicModifierName()
	return "modifier_imba_tower_vicious_aura"
end

-- Tower Aura
modifier_imba_tower_vicious_aura = modifier_imba_tower_vicious_aura or class({})

function modifier_imba_tower_vicious_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_vicious_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_vicious_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_vicious_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_vicious_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_vicious_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_vicious_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_vicious_aura:GetModifierAura()
	return "modifier_imba_tower_vicious_aura_buff"
end

function modifier_imba_tower_vicious_aura:IsAura()
	return true
end

function modifier_imba_tower_vicious_aura:IsDebuff()
	return false
end

function modifier_imba_tower_vicious_aura:IsHidden()
	return true
end

-- Critical Modifier
modifier_imba_tower_vicious_aura_buff = modifier_imba_tower_vicious_aura_buff or class({})

function modifier_imba_tower_vicious_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.parent = self:GetParent()

	-- Ability specials
	self.crit_damage = self.ability:GetSpecialValueFor("crit_damage")
	self.crit_chance_per_protective = self.ability:GetSpecialValueFor("crit_chance_per_protective")
	self.crit_chance = self.ability:GetSpecialValueFor("crit_chance")
end

function modifier_imba_tower_vicious_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_vicious_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_vicious_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE}

	return decFuncs
end

function modifier_imba_tower_vicious_aura_buff:GetModifierPreAttack_CriticalStrike()
	if IsServer() then
		local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

		-- Calculate crit chance
		local true_crit_chance = self.crit_chance + self.crit_chance_per_protective * protective_instinct_stacks

		if RollPseudoRandom(true_crit_chance, self) then
			return self.crit_damage
		else
			return nil
		end
	end
end

---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Spellmastery Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_spellmastery = imba_tower_spellmastery or class({})
LinkLuaModifier("modifier_imba_tower_spellmastery_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_spellmastery_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_spellmastery:GetAbilityTextureName()
	return "custom/tower_spellmastery"
end

function imba_tower_spellmastery:GetIntrinsicModifierName()
	return "modifier_imba_tower_spellmastery_aura"
end

-- Tower Aura
modifier_imba_tower_spellmastery_aura = modifier_imba_tower_spellmastery_aura or class({})

function modifier_imba_tower_spellmastery_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_spellmastery_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_spellmastery_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_spellmastery_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_spellmastery_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_spellmastery_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_spellmastery_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_spellmastery_aura:GetModifierAura()
	return "modifier_imba_tower_spellmastery_aura_buff"
end

function modifier_imba_tower_spellmastery_aura:IsAura()
	return true
end

function modifier_imba_tower_spellmastery_aura:IsDebuff()
	return false
end

function modifier_imba_tower_spellmastery_aura:IsHidden()
	return true
end

-- Spell amp/cast range Modifier
modifier_imba_tower_spellmastery_aura_buff = modifier_imba_tower_spellmastery_aura_buff or class({})

function modifier_imba_tower_spellmastery_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.parent = self:GetParent()

	-- Ability specials
	self.spellamp_bonus = self.ability:GetSpecialValueFor("spellamp_bonus")
	self.spellamp_per_protective = self.ability:GetSpecialValueFor("spellamp_per_protective")
	self.cast_range_bonus = self.ability:GetSpecialValueFor("cast_range_bonus")
end

function modifier_imba_tower_spellmastery_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_spellmastery_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_spellmastery_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING}

	return decFuncs
end

function modifier_imba_tower_spellmastery_aura_buff:GetModifierSpellAmplify_Percentage()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

	local spellamp = self.spellamp_bonus + self.spellamp_per_protective * protective_instinct_stacks
	return spellamp
end

function modifier_imba_tower_spellmastery_aura_buff:GetModifierCastRangeBonusStacking()
	return self.cast_range_bonus
end



---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Plague Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_plague = imba_tower_plague or class({})
LinkLuaModifier("modifier_imba_tower_plague_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_plague_aura_debuff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_plague:GetAbilityTextureName()
	return "custom/tower_rot"
end

function imba_tower_plague:GetIntrinsicModifierName()
	return "modifier_imba_tower_plague_aura"

end

-- Tower Aura
modifier_imba_tower_plague_aura = modifier_imba_tower_plague_aura or class({})

function modifier_imba_tower_plague_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.particle_rot = "particles/hero/tower/plague_tower_aura.vpcf"

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")

	if not self.particle_rot_fx then
		-- Apply particles
		self.particle_rot_fx = ParticleManager:CreateParticle(self.particle_rot, PATTACH_ABSORIGIN, self.caster)
		ParticleManager:SetParticleControl(self.particle_rot_fx, 0, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_rot_fx, 3, self.caster:GetAbsOrigin())
		self:AddParticle(self.particle_rot_fx, false, false, -1, false, false)
	end
end

function modifier_imba_tower_plague_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_plague_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_plague_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_tower_plague_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_tower_plague_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_plague_aura:GetModifierAura()
	return "modifier_imba_tower_plague_aura_debuff"
end

function modifier_imba_tower_plague_aura:IsAura()
	return true
end

function modifier_imba_tower_plague_aura:IsDebuff()
	return false
end

function modifier_imba_tower_plague_aura:IsHidden()
	return true
end

-- Attack Speed/Move speed slow Modifier
modifier_imba_tower_plague_aura_debuff = modifier_imba_tower_plague_aura_debuff or class({})

function modifier_imba_tower_plague_aura_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.ms_slow = self.ability:GetSpecialValueFor("ms_slow")
	self.additional_slow_per_protective = self.ability:GetSpecialValueFor("additional_slow_per_protective")
	self.as_slow = self.ability:GetSpecialValueFor("as_slow")
end

function modifier_imba_tower_plague_aura_debuff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_plague_aura_debuff:IsHidden()
	return false
end

function modifier_imba_tower_plague_aura_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_imba_tower_plague_aura_debuff:GetModifierMoveSpeedBonus_Percentage()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

	local ms_slow_total = self.ms_slow + self.additional_slow_per_protective * protective_instinct_stacks
	return ms_slow_total
end

function modifier_imba_tower_plague_aura_debuff:GetModifierAttackSpeedBonus_Constant()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

	local as_slow_total = self.as_slow + self.additional_slow_per_protective * protective_instinct_stacks
	return as_slow_total
end



---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Atrophy Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_atrophy = imba_tower_atrophy or class({})
LinkLuaModifier("modifier_imba_tower_atrophy_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_atrophy_aura_debuff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_atrophy:GetAbilityTextureName()
	return "custom/tower_atrophy"
end

function imba_tower_atrophy:GetIntrinsicModifierName()
	return "modifier_imba_tower_atrophy_aura"
end

-- Tower Aura
modifier_imba_tower_atrophy_aura = modifier_imba_tower_atrophy_aura or class({})

function modifier_imba_tower_atrophy_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
end

function modifier_imba_tower_atrophy_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_atrophy_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_atrophy_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_tower_atrophy_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_tower_atrophy_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_atrophy_aura:GetModifierAura()
	return "modifier_imba_tower_atrophy_aura_debuff"
end

function modifier_imba_tower_atrophy_aura:IsAura()
	return true
end

function modifier_imba_tower_atrophy_aura:IsDebuff()
	return false
end

function modifier_imba_tower_atrophy_aura:IsHidden()
	return true
end

-- Attack damage reduction Modifier
modifier_imba_tower_atrophy_aura_debuff = modifier_imba_tower_atrophy_aura_debuff or class({})

function modifier_imba_tower_atrophy_aura_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.damage_reduction = self.ability:GetSpecialValueFor("damage_reduction")
	self.additional_dr_per_protective = self.ability:GetSpecialValueFor("additional_dr_per_protective")
end

function modifier_imba_tower_atrophy_aura_debuff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_atrophy_aura_debuff:IsHidden()
	return false
end

function modifier_imba_tower_atrophy_aura_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE}

	return decFuncs
end

function modifier_imba_tower_atrophy_aura_debuff:GetModifierBaseDamageOutgoing_Percentage()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

	local total_damage_reduction = self.damage_reduction + self.additional_dr_per_protective * protective_instinct_stacks
	return total_damage_reduction
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Regeneration Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_regeneration = imba_tower_regeneration or class({})
LinkLuaModifier("modifier_imba_tower_regeneration_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_regeneration_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_regeneration:GetAbilityTextureName()
	return "custom/tower_regen"
end

function imba_tower_regeneration:GetIntrinsicModifierName()
	return "modifier_imba_tower_regeneration_aura"
end

-- Tower Aura
modifier_imba_tower_regeneration_aura = modifier_imba_tower_regeneration_aura or class({})

function modifier_imba_tower_regeneration_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_regeneration_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_regeneration_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_regeneration_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_regeneration_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_regeneration_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_regeneration_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_regeneration_aura:GetModifierAura()
	return "modifier_imba_tower_regeneration_aura_buff"
end

function modifier_imba_tower_regeneration_aura:IsAura()
	return true
end

function modifier_imba_tower_regeneration_aura:IsDebuff()
	return false
end

function modifier_imba_tower_regeneration_aura:IsHidden()
	return true
end

-- HP Regen Modifier
modifier_imba_tower_regeneration_aura_buff = modifier_imba_tower_regeneration_aura_buff or class({})

function modifier_imba_tower_regeneration_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.parent = self:GetParent()

	-- Ability specials
	self.hp_regen = self.ability:GetSpecialValueFor("hp_regen")
	self.bonus_hp_regen_per_protective = self.ability:GetSpecialValueFor("bonus_hp_regen_per_protective")
end

function modifier_imba_tower_regeneration_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_regeneration_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_regeneration_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE}

	return decFuncs
end

function modifier_imba_tower_regeneration_aura_buff:GetModifierHealthRegenPercentage()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

	local hp_regen_total = self.hp_regen + self.bonus_hp_regen_per_protective * protective_instinct_stacks
	return hp_regen_total
end



---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Starlight Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_starlight = imba_tower_starlight or class({})
LinkLuaModifier("modifier_imba_tower_starlight_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_starlight_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_starlight_debuff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_starlight:GetAbilityTextureName()
	return "custom/tower_starlight"
end

function imba_tower_starlight:GetIntrinsicModifierName()
	return "modifier_imba_tower_starlight_aura"
end

-- Tower Aura
modifier_imba_tower_starlight_aura = modifier_imba_tower_starlight_aura or class({})

function modifier_imba_tower_starlight_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_starlight_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_starlight_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_starlight_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_starlight_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_starlight_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_starlight_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_starlight_aura:GetModifierAura()
	return "modifier_imba_tower_starlight_aura_buff"
end

function modifier_imba_tower_starlight_aura:IsAura()
	return true
end

function modifier_imba_tower_starlight_aura:IsDebuff()
	return false
end

function modifier_imba_tower_starlight_aura:IsHidden()
	return true
end

-- Blind infliction Modifier
modifier_imba_tower_starlight_aura_buff = modifier_imba_tower_starlight_aura_buff or class({})

function modifier_imba_tower_starlight_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.parent = self:GetParent()
	self.modifier_blind = "modifier_imba_tower_starlight_debuff"
	self.particle_beam = "particles/econ/items/luna/luna_lucent_ti5/luna_lucent_beam_impact_bits_ti_5.vpcf"

	-- Ability specials
	self.blind_duration = self.ability:GetSpecialValueFor("blind_duration")
	self.blind_chance = self.ability:GetSpecialValueFor("blind_chance")
end

function modifier_imba_tower_starlight_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_starlight_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_starlight_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFuncs
end

function modifier_imba_tower_starlight_aura_buff:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply if the parent is the victim and the attacker is on the opposite team
		if self.parent == attacker and attacker:GetTeamNumber() ~= target:GetTeamNumber() then
			if RollPseudoRandom(self.blind_chance, self) then
				-- Apply effect
				local particle_beam_fx = ParticleManager:CreateParticle(self.particle_beam, PATTACH_ABSORIGIN_FOLLOW, target)
				ParticleManager:SetParticleControl(particle_beam_fx, 0, target:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_beam_fx, 1, target:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle_beam_fx)

				-- Add blindness modifier
				target:AddNewModifier(self.caster, self.ability, self.modifier_blind, {duration = self.blind_duration})
			end
		end
	end
end


-- Blind debuff
modifier_imba_tower_starlight_debuff = modifier_imba_tower_starlight_debuff or class({})

function modifier_imba_tower_starlight_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.miss_chance = self.ability:GetSpecialValueFor("miss_chance")
	self.additional_miss_per_protective = self.ability:GetSpecialValueFor("additional_miss_per_protective")
end

function modifier_imba_tower_starlight_debuff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_starlight_debuff:IsHidden()
	return false
end

function modifier_imba_tower_starlight_debuff:IsPurgable()
	return true
end

function modifier_imba_tower_starlight_debuff:IsDebuff()
	return true
end

function modifier_imba_tower_starlight_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MISS_PERCENTAGE}

	return decFuncs
end

function modifier_imba_tower_starlight_debuff:GetModifierMiss_Percentage()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

	-- Calculate miss chance
	local total_miss_chance = self.miss_chance + self.additional_miss_per_protective * protective_instinct_stacks
	return total_miss_chance
end

function modifier_imba_tower_starlight_debuff:GetEffectName()
	return "particles/ambient/tower_laser_blind.vpcf"
end

function modifier_imba_tower_starlight_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end



---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Grievous Wounds Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_grievous_wounds = imba_tower_grievous_wounds or class({})
LinkLuaModifier("modifier_imba_tower_grievous_wounds_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_grievous_wounds_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_grievous_wounds_debuff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_grievous_wounds:GetAbilityTextureName()
	return "ursa_fury_swipes"
end

function imba_tower_grievous_wounds:GetIntrinsicModifierName()
	return "modifier_imba_tower_grievous_wounds_aura"
end

-- Tower Aura
modifier_imba_tower_grievous_wounds_aura = modifier_imba_tower_grievous_wounds_aura or class({})

function modifier_imba_tower_grievous_wounds_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
end

function modifier_imba_tower_grievous_wounds_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_grievous_wounds_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_grievous_wounds_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_grievous_wounds_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_imba_tower_grievous_wounds_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_grievous_wounds_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_tower_grievous_wounds_aura:GetModifierAura()
	return "modifier_imba_tower_grievous_wounds_aura_buff"
end

function modifier_imba_tower_grievous_wounds_aura:IsAura()
	return true
end

function modifier_imba_tower_grievous_wounds_aura:IsDebuff()
	return false
end

function modifier_imba_tower_grievous_wounds_aura:IsHidden()
	return true
end

-- Grievous infliction Modifier
modifier_imba_tower_grievous_wounds_aura_buff = modifier_imba_tower_grievous_wounds_aura_buff or class({})

function modifier_imba_tower_grievous_wounds_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.parent = self:GetParent()
	self.grievous_debuff = "modifier_imba_tower_grievous_wounds_debuff"

	-- Ability specials
	self.damage_increase = self.ability:GetSpecialValueFor("damage_increase")
	self.damage_increase_per_hero = self.ability:GetSpecialValueFor("damage_increase_per_hero")
	self.debuff_duration = self.ability:GetSpecialValueFor("debuff_duration")
end

function modifier_imba_tower_grievous_wounds_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_grievous_wounds_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_grievous_wounds_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFuncs
end

function modifier_imba_tower_grievous_wounds_aura_buff:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target
		local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

		-- Only apply if the parent is the victim and the attacker is on the opposite team
		if self.parent == attacker and attacker:GetTeamNumber() ~= target:GetTeamNumber() then

			-- Add debuff modifier. Increment stack count and refresh
			if not target:HasModifier(self.grievous_debuff) then
				target:AddNewModifier(self.caster, self.ability, self.grievous_debuff, {duration = self.debuff_duration})
			end

			local grievous_debuff_handler = target:FindModifierByName(self.grievous_debuff)

			-- Increase stack count and refresh
			grievous_debuff_handler:IncrementStackCount()
			grievous_debuff_handler:ForceRefresh()

			-- Calculate damage based on stacks
			local grievous_stacks = grievous_debuff_handler:GetStackCount()
			local damage = (self.damage_increase + self.damage_increase_per_hero * protective_instinct_stacks) * grievous_stacks

			-- Apply damage
			local damageTable = {victim = target,
				attacker = self.parent,
				damage = damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self.ability}

			ApplyDamage(damageTable)
		end
	end
end


-- Fury Swipes debuff
modifier_imba_tower_grievous_wounds_debuff = modifier_imba_tower_grievous_wounds_debuff or class({})

function modifier_imba_tower_grievous_wounds_debuff:IsHidden()
	return false
end

function modifier_imba_tower_grievous_wounds_debuff:IsPurgable()
	return true
end

function modifier_imba_tower_grievous_wounds_debuff:IsDebuff()
	return true
end

function modifier_imba_tower_grievous_wounds_debuff:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end

function modifier_imba_tower_grievous_wounds_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--		   Tower's Essence Drain Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_essence_drain = imba_tower_essence_drain or class({})
LinkLuaModifier("modifier_imba_tower_essence_drain_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_essence_drain_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_essence_drain_debuff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_essence_drain_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_essence_drain:GetAbilityTextureName()
	return "slark_essence_shift"
end

function imba_tower_essence_drain:GetIntrinsicModifierName()
	return "modifier_imba_tower_essence_drain_aura"
end

-- Tower Aura
modifier_imba_tower_essence_drain_aura = modifier_imba_tower_essence_drain_aura or class({})

function modifier_imba_tower_essence_drain_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
end

function modifier_imba_tower_essence_drain_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_essence_drain_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_essence_drain_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_essence_drain_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_imba_tower_essence_drain_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_essence_drain_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_tower_essence_drain_aura:GetModifierAura()
	return "modifier_imba_tower_essence_drain_aura_buff"
end

function modifier_imba_tower_essence_drain_aura:IsAura()
	return true
end

function modifier_imba_tower_essence_drain_aura:IsDebuff()
	return false
end

function modifier_imba_tower_essence_drain_aura:IsHidden()
	return true
end

-- Essence Drain infliction Modifier
modifier_imba_tower_essence_drain_aura_buff = modifier_imba_tower_essence_drain_aura_buff or class({})

function modifier_imba_tower_essence_drain_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.parent = self:GetParent()
	self.modifier_debuff = "modifier_imba_tower_essence_drain_debuff"
	self.modifier_buff = "modifier_imba_tower_essence_drain_buff"
	self.particle_drain = "particles/econ/items/slark/slark_ti6_blade/slark_ti6_blade_essence_shift.vpcf"

	-- Ability specials
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.duration_per_protective = self.ability:GetSpecialValueFor("duration_per_protective")
end

function modifier_imba_tower_essence_drain_aura_buff:OnRefresh()
	self:OnCreated()
end


function modifier_imba_tower_essence_drain_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_essence_drain_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFuncs
end

function modifier_imba_tower_essence_drain_aura_buff:OnAttackLanded( keys )
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

		-- Only apply if the parent is the attacker and the victim is on the opposite team
		if (self.parent == attacker) and (attacker:GetTeamNumber() ~= target:GetTeamNumber()) and target:IsHero() then

			-- Apply effect
			local particle_drain_fx = ParticleManager:CreateParticle(self.particle_drain, PATTACH_ABSORIGIN, target)
			ParticleManager:SetParticleControl(particle_drain_fx, 0, target:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_drain_fx, 1, self.parent:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_drain_fx, 2, self.parent:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_drain_fx, 3, self.parent:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_drain_fx)

			-- Calculate duration
			local total_duration = self.duration + self.duration_per_protective * protective_instinct_stacks

			-- Add debuff modifier to the enemy Increment stack count and refresh
			if not target:HasModifier(self.modifier_debuff) then
				target:AddNewModifier(self.caster, self.ability, self.modifier_debuff, {duration = total_duration})
			end

			local drain_debuff_handler = target:FindModifierByName(self.modifier_debuff)

			-- Increase stacks and refresh
			drain_debuff_handler:IncrementStackCount()
			drain_debuff_handler:ForceRefresh()

			-- Add buff modifier to the attacker.
			if not self.parent:HasModifier(self.modifier_buff) then
				self.parent:AddNewModifier(self.caster, self.ability, self.modifier_buff, {duration = total_duration})
			end

			local drain_buff_handler = self.parent:FindModifierByName(self.modifier_buff)

			-- Increase stacks and refresh
			drain_buff_handler:IncrementStackCount()
			drain_buff_handler:ForceRefresh()
		end
	end
end

-- Essence Drain debuff (enemy)
modifier_imba_tower_essence_drain_debuff = modifier_imba_tower_essence_drain_debuff or class({})

function modifier_imba_tower_essence_drain_debuff:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		if not self.ability then
			self:Destroy()
			return nil
		end
		self.parent = self:GetParent()

		-- Ability specials
		self.stat_drain_amount_enemy = self.ability:GetSpecialValueFor("stat_drain_amount_enemy")

		-- Get the duration
		self.duration = self:GetDuration()

		-- Initialize table
		self.stacks_table = {}

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_tower_essence_drain_debuff:OnIntervalThink()
	if IsServer() then
		-- Check if there are any stacks left on the table
		if #self.stacks_table > 0 then

			-- For each stack, check if it is past its expiration time. If it is, remove it from the table
			for i = #self.stacks_table, 1, -1 do
				if self.stacks_table[i] + self.duration < GameRules:GetGameTime() then
					table.remove(self.stacks_table, i)
				end
			end

			-- If after removing the stacks, the table is empty, remove the modifier.
			if #self.stacks_table == 0 then
				self:Destroy()

				-- Otherwise, set its stack count
			else
				self:SetStackCount(#self.stacks_table)
			end

			-- Recalculate bonus based on new stack count
			self:GetParent():CalculateStatBonus()

			-- If there are no stacks on the table, just remove the modifier.
		else
			self:Destroy()
		end
	end
end

function modifier_imba_tower_essence_drain_debuff:OnRefresh()
	if IsServer() then
		-- Insert new stack values
		table.insert(self.stacks_table, GameRules:GetGameTime())
	end
end

function modifier_imba_tower_essence_drain_debuff:IsHidden()
	return false
end

function modifier_imba_tower_essence_drain_debuff:IsPurgable()
	return true
end

function modifier_imba_tower_essence_drain_debuff:IsDebuff()
	return true
end

function modifier_imba_tower_essence_drain_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}

	return decFuncs
end

function modifier_imba_tower_essence_drain_debuff:GetModifierBonusStats_Agility()
	local stacks = self:GetStackCount()

	local stats_drain = self.stat_drain_amount_enemy * stacks
	return stats_drain
end

function modifier_imba_tower_essence_drain_debuff:GetModifierBonusStats_Intellect()
	local stacks = self:GetStackCount()

	local stats_drain = self.stat_drain_amount_enemy * stacks
	return stats_drain
end

function modifier_imba_tower_essence_drain_debuff:GetModifierBonusStats_Strength()
	local stacks = self:GetStackCount()

	local stats_drain = self.stat_drain_amount_enemy * stacks
	return stats_drain
end

-- Essence Drain buff (ally)
modifier_imba_tower_essence_drain_buff = modifier_imba_tower_essence_drain_buff or class({})

function modifier_imba_tower_essence_drain_buff:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		if not self.ability then
			self:Destroy()
			return nil
		end
		self.parent = self:GetParent()

		-- Ability specials
		self.stat_drain_amount_ally = self.ability:GetSpecialValueFor("stat_drain_amount_ally")

		-- Set the hero's main attribute
		self.primary_attribute = self.parent:GetPrimaryAttribute()

		-- Get the duration
		self.duration = self:GetDuration()

		-- Initialize table
		self.stacks_table = {}

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_tower_essence_drain_buff:OnIntervalThink()
	if IsServer() then
		-- Check if there are any stacks left on the table
		if #self.stacks_table > 0 then

			-- For each stack, check if it is past its expiration time. If it is, remove it from the table
			for i = #self.stacks_table, 1, -1 do
				if self.stacks_table[i] + self.duration < GameRules:GetGameTime() then
					table.remove(self.stacks_table, i)
				end
			end

			-- If after removing the stacks, the table is empty, remove the modifier.
			if #self.stacks_table == 0 then
				self:Destroy()

				-- Otherwise, set its stack count
			else
				self:SetStackCount(#self.stacks_table)
			end

			-- Recalculate bonus based on new stack count
			self:GetParent():CalculateStatBonus()

			-- If there are no stacks on the table, just remove the modifier.
		else
			self:Destroy()
		end
	end
end

function modifier_imba_tower_essence_drain_buff:OnRefresh()
	if IsServer() then
		-- Insert new stack values
		table.insert(self.stacks_table, GameRules:GetGameTime())
	end
end

function modifier_imba_tower_essence_drain_buff:IsHidden()
	return false
end

function modifier_imba_tower_essence_drain_buff:IsPurgable()
	return true
end

function modifier_imba_tower_essence_drain_buff:IsDebuff()
	return false
end

function modifier_imba_tower_essence_drain_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}

	return decFuncs
end

function modifier_imba_tower_essence_drain_buff:GetModifierBonusStats_Agility()
	if IsServer() then
		-- Grant bonuses if Agility is the main attribute
		if self.primary_attribute == DOTA_ATTRIBUTE_AGILITY then
			local stacks = self:GetStackCount()

			local stats_drain = self.stat_drain_amount_ally * stacks
			return stats_drain
		end

		return nil
	end
end

function modifier_imba_tower_essence_drain_buff:GetModifierBonusStats_Intellect()
	if IsServer() then
		-- Grant bonuses if Intelligence is the main attribute
		if self.primary_attribute == DOTA_ATTRIBUTE_INTELLECT then
			local stacks = self:GetStackCount()

			local stats_drain = self.stat_drain_amount_ally * stacks
			return stats_drain
		end

		return nil
	end
end

function modifier_imba_tower_essence_drain_buff:GetModifierBonusStats_Strength()
	if IsServer() then
		-- Grant bonuses if Strength is the main attribute
		if self.primary_attribute == DOTA_ATTRIBUTE_STRENGTH then
			local stacks = self:GetStackCount()

			local stats_drain = self.stat_drain_amount_ally * stacks
			return stats_drain
		end

		return nil
	end
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--		   Tower's Protection Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_protection = imba_tower_protection or class({})
LinkLuaModifier("modifier_imba_tower_protection_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_protection_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_protection:GetAbilityTextureName()
	return "custom/tower_protection"
end

function imba_tower_protection:GetIntrinsicModifierName()
	return "modifier_imba_tower_protection_aura"
end

-- Tower Aura
modifier_imba_tower_protection_aura = modifier_imba_tower_protection_aura or class({})

function modifier_imba_tower_protection_aura:OnCreated()
	-- Ability propertes
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_protection_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_protection_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_protection_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_protection_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_protection_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_protection_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_protection_aura:GetModifierAura()
	return "modifier_imba_tower_protection_aura_buff"
end

function modifier_imba_tower_protection_aura:IsAura()
	return true
end

function modifier_imba_tower_protection_aura:IsDebuff()
	return false
end

function modifier_imba_tower_protection_aura:IsHidden()
	return true
end

-- Protection Modifier
modifier_imba_tower_protection_aura_buff = modifier_imba_tower_protection_aura_buff or class({})

function modifier_imba_tower_protection_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.parent = self:GetParent()

	-- Ability specials
	self.damage_reduction = self.ability:GetSpecialValueFor("damage_reduction")
	self.additional_dr_per_protective = self.ability:GetSpecialValueFor("additional_dr_per_protective")
end

function modifier_imba_tower_protection_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_protection_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_protection_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}

	return decFuncs
end

function modifier_imba_tower_protection_aura_buff:GetModifierIncomingDamage_Percentage()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

	local damage_reduction_total = self.damage_reduction + self.additional_dr_per_protective * protective_instinct_stacks
	return damage_reduction_total
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Disease Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_disease = imba_tower_disease or class({})
LinkLuaModifier("modifier_imba_tower_disease_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_disease_aura_debuff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_disease:GetAbilityTextureName()
	return "custom/disease_aura"
end

function imba_tower_disease:GetIntrinsicModifierName()
	return "modifier_imba_tower_disease_aura"
end

-- Tower Aura
modifier_imba_tower_disease_aura = modifier_imba_tower_disease_aura or class({})

function modifier_imba_tower_disease_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_disease_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_disease_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_disease_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_disease_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_tower_disease_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_tower_disease_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_disease_aura:GetModifierAura()
	return "modifier_imba_tower_disease_aura_debuff"
end

function modifier_imba_tower_disease_aura:IsAura()
	return true
end

function modifier_imba_tower_disease_aura:IsDebuff()
	return false
end

function modifier_imba_tower_disease_aura:IsHidden()
	return true
end

-- Attack damage reduction Modifier
modifier_imba_tower_disease_aura_debuff = modifier_imba_tower_disease_aura_debuff or class({})

function modifier_imba_tower_disease_aura_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.stat_reduction = self.ability:GetSpecialValueFor("stat_reduction")
	self.additional_sr_per_protective = self.ability:GetSpecialValueFor("additional_sr_per_protective")
end

function modifier_imba_tower_disease_aura_debuff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_disease_aura_debuff:IsHidden()
	return false
end

function modifier_imba_tower_disease_aura_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}

	return decFuncs
end

function modifier_imba_tower_disease_aura_debuff:GetModifierBonusStats_Agility()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

	local total_stat_reduction = self.stat_reduction + self.additional_sr_per_protective * protective_instinct_stacks
	return total_stat_reduction
end

function modifier_imba_tower_disease_aura_debuff:GetModifierBonusStats_Intellect()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

	local total_stat_reduction = self.stat_reduction + self.additional_sr_per_protective * protective_instinct_stacks
	return total_stat_reduction
end

function modifier_imba_tower_disease_aura_debuff:GetModifierBonusStats_Strength()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

	local total_stat_reduction = self.stat_reduction + self.additional_sr_per_protective * protective_instinct_stacks
	return total_stat_reduction
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Doppleganger Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_doppleganger = imba_tower_doppleganger or class({})
LinkLuaModifier("modifier_imba_tower_doppleganger_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_doppleganger_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_doppleganger_cooldown", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_doppleganger:GetAbilityTextureName()
	return "custom/tower_doppleganger"
end

function imba_tower_doppleganger:GetIntrinsicModifierName()
	return "modifier_imba_tower_doppleganger_aura"
end

-- Tower Aura
modifier_imba_tower_doppleganger_aura = modifier_imba_tower_doppleganger_aura or class({})

function modifier_imba_tower_doppleganger_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
end

function modifier_imba_tower_doppleganger_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_doppleganger_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_doppleganger_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_doppleganger_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_SUMMONED + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_imba_tower_doppleganger_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_doppleganger_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_tower_doppleganger_aura:GetModifierAura()
	return "modifier_imba_tower_doppleganger_aura_buff"
end

function modifier_imba_tower_doppleganger_aura:IsAura()
	return true
end

function modifier_imba_tower_doppleganger_aura:IsDebuff()
	return false
end

function modifier_imba_tower_doppleganger_aura:IsHidden()
	return true
end

-- Doppleganger Modifier
modifier_imba_tower_doppleganger_aura_buff = modifier_imba_tower_doppleganger_aura_buff or class({})

function modifier_imba_tower_doppleganger_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.parent = self:GetParent()
	self.particle_doppleganger = "particles/econ/items/phantom_lancer/phantom_lancer_immortal_ti6/phantom_lancer_immortal_ti6_spiritlance_cast.vpcf"
	self.prevention_modifier = "modifier_imba_tower_doppleganger_cooldown"

	-- Ability specials
	self.incoming_damage = self.ability:GetSpecialValueFor("incoming_damage")
	self.outgoing_damage = self.ability:GetSpecialValueFor("outgoing_damage")
	self.doppleganger_duration = self.ability:GetSpecialValueFor("doppleganger_duration")
	self.doppleganger_cooldown = self.ability:GetSpecialValueFor("doppleganger_cooldown")
	self.cd_reduction_per_protective = self.ability:GetSpecialValueFor("cd_reduction_per_protective")
	self.summon_distance = self.ability:GetSpecialValueFor("summon_distance")
end

function modifier_imba_tower_doppleganger_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_doppleganger_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_doppleganger_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFuncs
end

function modifier_imba_tower_doppleganger_aura_buff:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

		-- If the parent is an illusion, do nothing
		if self.parent:IsIllusion() then
			return nil
		end

		-- Only apply if the parent is the victim and the attacker is on the opposite team and is not prevented
		if self.parent == target and attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() and not self.parent:HasModifier(self.prevention_modifier) then

			-- Calculate cooldown and add a prevention modifier to the parent
			local cooldown_doppleganger = self.doppleganger_cooldown - self.cd_reduction_per_protective * protective_instinct_stacks
			self.parent:AddNewModifier(self.caster, self.ability, self.prevention_modifier, {duration = cooldown_doppleganger})

			-- Create effect
			local particle_doppleganger_fx = ParticleManager:CreateParticle(self.particle_doppleganger, PATTACH_ABSORIGIN, self.parent)
			ParticleManager:SetParticleControl(particle_doppleganger_fx, 0, self.parent:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_doppleganger_fx, 1, self.parent:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_doppleganger_fx)

			-- Calculate doppleganger origin and create it
			local rand_distance = math.random(0, self.summon_distance)
			local summon_origin = self.parent:GetAbsOrigin() + RandomVector(rand_distance)
			local doppleganger = CreateUnitByName(self.parent:GetUnitName(), summon_origin, true, self.parent, nil, self.parent:GetTeamNumber())

			-- Turn doppleganger into an illusion with the correct properties
			doppleganger:AddNewModifier(self.caster, self.ability, "modifier_illusion", {duration = self.doppleganger_duration, outgoing_damage = self.outgoing_damage, incoming_damage = self.incoming_damage})
			doppleganger:MakeIllusion()
			doppleganger:SetRespawnsDisabled(true)

			-- Set the doppleganger as controllable by the player
			doppleganger:SetControllableByPlayer(self.parent:GetPlayerID(), false)
			doppleganger:SetPlayerID(self.parent:GetPlayerID())

			-- Set the doppleganger's level to the parent's
			local parent_level = self.parent:GetLevel()
			for i=1, parent_level-1 do
				doppleganger:HeroLevelUp(false)
			end

			-- Set the skill points to 0 and learn the skills of the caster
			doppleganger:SetAbilityPoints(0)
			for abilitySlot=0,15 do
				local ability = self.parent:GetAbilityByIndex(abilitySlot)
				if ability ~= nil then
					local abilityLevel = ability:GetLevel()
					local abilityName = ability:GetAbilityName()
					local illusionAbility = doppleganger:FindAbilityByName(abilityName)
					illusionAbility:SetLevel(abilityLevel)
				end
			end

			-- Recreate the items of the caster
			for itemSlot=0,5 do
				local item = self.parent:GetItemInSlot(itemSlot)
				if item ~= nil then
					local itemName = item:GetName()
					local newItem = CreateItem(itemName, doppleganger, doppleganger)
					doppleganger:AddItem(newItem)
				end
			end

			-- Set Forward Vector the same as the player
			doppleganger:SetForwardVector(self.parent:GetForwardVector())

			-- Roll a chance to swap positions with the doppleganger
			local swap_change = math.random(1,2)
			if swap_change == 2 then
				local parent_loc = self.parent:GetAbsOrigin()
				local doppleganger_loc = doppleganger:GetAbsOrigin()
				self.parent:SetAbsOrigin(doppleganger_loc)
				doppleganger:SetAbsOrigin(parent_loc)
			end

			-- Stop the attacker, since it still auto attacks the original (will force it to attack the closest target)
			attacker:Stop()

			-- Stop the illusion, since it automatically attacks everything, then decide the next step
			doppleganger:Stop()

			-- Imitate target attack location
			if self.parent:IsAttacking() then
				local attack_target = self.parent:GetAttackTarget()
				doppleganger:MoveToTargetToAttack(attack_target)
			end

			if self.parent:IsChanneling() then
				local current_ability = self.parent:GetCurrentActiveAbility()
				local ability_name = current_ability:GetName()
				StartChannelingAnimation(self.parent, doppleganger, ability_name) -- custom function
			end
		end
	end
end

-- Doppleganger cooldown modifier
modifier_imba_tower_doppleganger_cooldown = modifier_imba_tower_doppleganger_cooldown or class({})

function modifier_imba_tower_doppleganger_cooldown:IsHidden()
	return false
end

function modifier_imba_tower_doppleganger_cooldown:IsPurgable()
	return false
end

function modifier_imba_tower_doppleganger_cooldown:IsDebuff()
	return false
end

-- Custom function responsible for stopping the illusion, making it look like it's casting the
-- same channeling spell as its original. Assigns the corrects gesture depending on the ability.
function StartChannelingAnimation (parent, doppleganger, ability_name)
	local ability_gesture

	local channel_4    = {"imba_bane_fiends_grip", "imba_pudge_dismember",}
	local cast_4    = {"imba_crystal_maiden_freezing_field", "imba_enigma_black_hole", "imba_sandking_epicenter", "witch_doctor_death_ward",}
	local cast_1    = {"elder_titan_echo_stomp", "keeper_of_the_light_illuminate", "oracle_fortunes_end",}
	local cast_3    = {"imba_lion_mana_drain",} -- Should be changed in the next update to "imba_lion_mana_drain"

	for _,v in ipairs(channel_4) do
		if ability_name == v then
			ability_gesture = ACT_DOTA_CHANNEL_ABILITY_4
			break
		end
	end

	for _,v in ipairs(cast_4) do
		if ability_name == v then
			ability_gesture = ACT_DOTA_CAST_ABILITY_4
			break
		end
	end

	for _,v in ipairs(cast_1) do
		if ability_name == v then
			ability_gesture = ACT_DOTA_CAST_ABILITY_1
			break
		end
	end

	for _,v in ipairs(cast_3) do
		if ability_name == v then
			ability_gesture = ACT_DOTA_CAST_ABILITY_3
			break
		end
	end

	-- If a target is channeling a spell that doesn't really have an animation, ignore it.
	if ability_gesture == nil then
		return nil
	end

	-- Start animation, stop movement, and stop attacking
	doppleganger:StartGesture(ability_gesture)
	doppleganger:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
	doppleganger:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)

	-- Check if parent is still casting, otherwise stop the gesture and return the attack capability
	Timers:CreateTimer(FrameTime(), function()
		if not parent:IsChanneling() then
			doppleganger:FadeGesture(ability_gesture)
			doppleganger:SetAttackCapability(parent:GetAttackCapability())
			doppleganger:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
			return nil
		end
		return FrameTime()
	end)
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--		   Tower's Barrier Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_barrier = imba_tower_barrier or class({})
LinkLuaModifier("modifier_imba_tower_barrier_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_barrier_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_barrier_aura_cooldown", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_barrier:GetIntrinsicModifierName()
	return "modifier_imba_tower_barrier_aura"
end

function imba_tower_barrier:GetAbilityTextureName()
	return "custom/tower_barrier"
end

-- Tower Aura
modifier_imba_tower_barrier_aura = modifier_imba_tower_barrier_aura or class({})

function modifier_imba_tower_barrier_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.prevention_modifier = "modifier_imba_tower_barrier_aura_cooldown"

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_barrier_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_barrier_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_barrier_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_barrier_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_barrier_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_barrier_aura:GetAuraEntityReject(target)
	if target:HasModifier(self.prevention_modifier) then
		return true -- reject
	end

	return false
end

function modifier_imba_tower_barrier_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_barrier_aura:GetModifierAura()
	return "modifier_imba_tower_barrier_aura_buff"
end

function modifier_imba_tower_barrier_aura:IsAura()
	return true
end

function modifier_imba_tower_barrier_aura:IsDebuff()
	return false
end

function modifier_imba_tower_barrier_aura:IsHidden()
	return true
end

-- Barrier Modifier
modifier_imba_tower_barrier_aura_buff = modifier_imba_tower_barrier_aura_buff or class({})

function modifier_imba_tower_barrier_aura_buff:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		if not self.ability then
			self:Destroy()
			return nil
		end
		self.parent = self:GetParent()
		self.prevention_modifier = "modifier_imba_tower_barrier_aura_cooldown"

		-- Ability specials
		self.base_maxdamage = self.ability:GetSpecialValueFor("base_maxdamage")
		self.maxdamage_per_protective = self.ability:GetSpecialValueFor("maxdamage_per_protective")
		self.replenish_duration = self.ability:GetSpecialValueFor("replenish_duration")

		-- Assign variables
		self.tower_barrier_damage = 0
		self.tower_barrier_max = self.base_maxdamage

		-- Calculate max damage to show on modifier creation
		local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)
		local show_stacks = self.base_maxdamage + self.maxdamage_per_protective * protective_instinct_stacks
		self:SetStackCount(show_stacks)

		-- Start thinking
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_tower_barrier_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_barrier_aura_buff:OnIntervalThink()
	if IsServer() then
		local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)
		self.tower_barrier_max = self.base_maxdamage + self.maxdamage_per_protective * protective_instinct_stacks

		-- If the barrier should be broken, break it
		local barrier_life = self.tower_barrier_max - self.tower_barrier_damage
		if barrier_life <= 0 then
			self.parent:AddNewModifier(self.caster, self.ability, self.prevention_modifier, {duration = self.replenish_duration})
			self:Destroy()
		end

		self:SetStackCount(barrier_life)
	end
end

function modifier_imba_tower_barrier_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE}

	return decFuncs
end

function modifier_imba_tower_barrier_aura_buff:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_imba_tower_barrier_aura_buff:OnTakeDamage(keys)
	if IsServer() then
		local unit = keys.unit
		local damage = keys.original_damage
		local damage_type = keys.damage_type

		-- Only apply on the golem taking damage
		if unit == self.parent then

			-- Adjust damage according to armor or magic resist, if damage types match.
			if damage_type == DAMAGE_TYPE_PHYSICAL then
				damage = damage * (1 - self.parent:GetPhysicalArmorReduction() * 0.01)

			elseif damage_type == DAMAGE_TYPE_MAGICAL then
				damage = damage * (1- self.parent:GetMagicalArmorValue() * 0.01)
			end

			-- Increase the damage that the barrier had blocked
			self.tower_barrier_damage = self.tower_barrier_damage + damage
		end
	end
end

function modifier_imba_tower_barrier_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_barrier_aura_buff:GetEffectName()
	return "particles/hero/tower/barrier_aura_shell.vpcf"
end

function modifier_imba_tower_barrier_aura_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Barrier cooldown modifier
modifier_imba_tower_barrier_aura_cooldown = modifier_imba_tower_barrier_aura_cooldown or class({})

function modifier_imba_tower_barrier_aura_cooldown:IsHidden()
	return false
end

function modifier_imba_tower_barrier_aura_cooldown:IsPurgable()
	return false
end

function modifier_imba_tower_barrier_aura_cooldown:IsDebuff()
	return false
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Soul Leech Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_soul_leech = imba_tower_soul_leech or class({})
LinkLuaModifier("modifier_imba_tower_soul_leech_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_soul_leech_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_soul_leech:GetAbilityTextureName()
	return "custom/tower_soul_leech"
end

function imba_tower_soul_leech:GetIntrinsicModifierName()
	return "modifier_imba_tower_soul_leech_aura"
end

-- Tower Aura
modifier_imba_tower_soul_leech_aura = modifier_imba_tower_soul_leech_aura or class({})

function modifier_imba_tower_soul_leech_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_soul_leech_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_soul_leech_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_soul_leech_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_soul_leech_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_soul_leech_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_soul_leech_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_soul_leech_aura:GetModifierAura()
	return "modifier_imba_tower_soul_leech_aura_buff"
end

function modifier_imba_tower_soul_leech_aura:IsAura()
	return true
end

function modifier_imba_tower_soul_leech_aura:IsDebuff()
	return false
end

function modifier_imba_tower_soul_leech_aura:IsHidden()
	return true
end

-- Leech Modifier
modifier_imba_tower_soul_leech_aura_buff = modifier_imba_tower_soul_leech_aura_buff or class({})

function modifier_imba_tower_soul_leech_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.parent = self:GetParent()
	self.particle_lifesteal = "particles/generic_gameplay/generic_lifesteal.vpcf"
	self.particle_spellsteal = "particles/items3_fx/octarine_core_lifesteal.vpcf"

	-- Ability specials
	self.soul_leech_pct = self.ability:GetSpecialValueFor("soul_leech_pct")
	self.leech_per_protective = self.ability:GetSpecialValueFor("leech_per_protective")
	self.creep_lifesteal_pct = self.ability:GetSpecialValueFor("creep_lifesteal_pct")
end

function modifier_imba_tower_soul_leech_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_soul_leech_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_soul_leech_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_TAKEDAMAGE}

	return decFuncs
end

function modifier_imba_tower_soul_leech_aura_buff:OnTakeDamage(keys)
	local attacker = keys.attacker
	local target = keys.unit
	local damage = keys.damage
	local damage_type = keys.damage_type

	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

	-- Only apply if the parent of this buff attacked an enemy
	if attacker == self.parent and self.parent:GetTeamNumber() ~= target:GetTeamNumber() then

		-- Play appropriate effect depending on damage type
		if damage_type == DAMAGE_TYPE_MAGICAL or damage_type == DAMAGE_TYPE_PURE then
			local particle_spellsteal_fx = ParticleManager:CreateParticle(self.particle_spellsteal, PATTACH_ABSORIGIN, attacker)
			ParticleManager:SetParticleControl(particle_spellsteal_fx, 0, attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_spellsteal_fx)
		end

		if damage_type == DAMAGE_TYPE_PHYSICAL then
			local particle_lifesteal_fx = ParticleManager:CreateParticle(self.particle_lifesteal, PATTACH_ABSORIGIN, attacker)
			ParticleManager:SetParticleControl(particle_lifesteal_fx, 0, attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_lifesteal_fx)
		end

		-- Calculate life/spell steal
		local soul_leech_total = self.soul_leech_pct + self.leech_per_protective * protective_instinct_stacks

		-- Decrease heal if the target is a creep
		if target:IsCreep() then
			soul_leech_total = soul_leech_total * (self.creep_lifesteal_pct * 0.01)
		end

		-- Heal caster by damage, only if damage isn't negative (to prevent negative heal)
		if damage > 0 then
			local heal_amount = damage * (soul_leech_total * 0.01)
			self.parent:Heal(heal_amount, self.parent)
		end
	end
end




---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--		   Tower's Frost Shroud Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_frost_shroud = imba_tower_frost_shroud or class({})
LinkLuaModifier("modifier_imba_tower_frost_shroud_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_frost_shroud_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_frost_shroud_debuff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_frost_shroud:GetAbilityTextureName()
	return "custom/tower_frost_shroud"
end

function imba_tower_frost_shroud:GetIntrinsicModifierName()
	return "modifier_imba_tower_frost_shroud_aura"
end

-- Tower Aura
modifier_imba_tower_frost_shroud_aura = modifier_imba_tower_frost_shroud_aura or class({})

function modifier_imba_tower_frost_shroud_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
end

function modifier_imba_tower_frost_shroud_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_frost_shroud_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_frost_shroud_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_frost_shroud_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_imba_tower_frost_shroud_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_frost_shroud_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_tower_frost_shroud_aura:GetModifierAura()
	return "modifier_imba_tower_frost_shroud_aura_buff"
end

function modifier_imba_tower_frost_shroud_aura:IsAura()
	return true
end

function modifier_imba_tower_frost_shroud_aura:IsDebuff()
	return false
end

function modifier_imba_tower_frost_shroud_aura:IsHidden()
	return true
end

-- Frost Shroud trigger Modifier
modifier_imba_tower_frost_shroud_aura_buff = modifier_imba_tower_frost_shroud_aura_buff or class({})

function modifier_imba_tower_frost_shroud_aura_buff:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.ability = self:GetAbility()
		if not self.ability then
			self:Destroy()
			return nil
		end
		self.modifier_frost = "modifier_imba_tower_frost_shroud_debuff"
		self.particle_frost = "particles/hero/tower/tower_frost_shroud.vpcf"

		-- Ability specials
		self.frost_shroud_chance = self.ability:GetSpecialValueFor("frost_shroud_chance")
		self.frost_shroud_duration = self.ability:GetSpecialValueFor("frost_shroud_duration")
		self.aoe_radius = self.ability:GetSpecialValueFor("aoe_radius")
	end
end

function modifier_imba_tower_frost_shroud_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_frost_shroud_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_frost_shroud_aura_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_TAKEDAMAGE}

	return decFuncs
end

function modifier_imba_tower_frost_shroud_aura_buff:OnTakeDamage(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.unit

		-- Only apply if the parent is the victim and the attacker is on the opposite team
		if self.parent == target and attacker:GetTeamNumber() ~= target:GetTeamNumber() then

			-- Roll for a proc
			if RollPseudoRandom(self.frost_shroud_chance, self) then

				-- Apply effect
				local particle_frost_fx = ParticleManager:CreateParticle(self.particle_frost, PATTACH_ABSORIGIN, target)
				ParticleManager:SetParticleControl(particle_frost_fx, 0, self.parent:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_frost_fx, 1, Vector(1, 1, 1))
				ParticleManager:ReleaseParticleIndex(particle_frost_fx)

				-- Find all enemies in the aoe radius of the blast
				local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),
					self.parent:GetAbsOrigin(),
					nil,
					self.aoe_radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_NONE,
					FIND_ANY_ORDER,
					false)

				for _, enemy in pairs(enemies) do

					-- Add debuff modifier to the enemy Increment stack count and refresh
					if not enemy:HasModifier(self.modifier_frost) then
						enemy:AddNewModifier(self.caster, self.ability, self.modifier_frost, {duration = self.frost_shroud_duration})
					end

					local modifier_frost_handler = enemy:FindModifierByName(self.modifier_frost)
					modifier_frost_handler:IncrementStackCount()
					modifier_frost_handler:ForceRefresh()
				end
			end
		end
	end
end


-- Frost Shroud debuff (enemy)
modifier_imba_tower_frost_shroud_debuff = modifier_imba_tower_frost_shroud_debuff or class({})

function modifier_imba_tower_frost_shroud_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.parent = self:GetParent()

	-- Ability specials
	self.ms_slow = self.ability:GetSpecialValueFor("ms_slow")
	self.as_slow = self.ability:GetSpecialValueFor("as_slow")
	self.slow_per_protective = self.ability:GetSpecialValueFor("slow_per_protective")

	-- Initialize table
	self.stacks_table = {}

	-- Get duration
	self.duration = self:GetDuration()

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_tower_frost_shroud_debuff:OnRefresh()
	if IsServer() then
		-- Insert new stack values
		table.insert(self.stacks_table, GameRules:GetGameTime())
	end
end

function modifier_imba_tower_frost_shroud_debuff:OnIntervalThink()
	if IsServer() then

		-- Check if there are any stacks left on the table
		if #self.stacks_table > 0 then

			-- For each stack, check if it is past its expiration time. If it is, remove it from the table
			for i = #self.stacks_table, 1, -1 do
				if self.stacks_table[i] + self.duration < GameRules:GetGameTime() then
					table.remove(self.stacks_table, i)
				end
			end

			-- If after removing the stacks, the table is empty, remove the modifier.
			if #self.stacks_table == 0 then
				self:Destroy()

				-- Otherwise, set its stack count
			else
				self:SetStackCount(#self.stacks_table)
			end

			-- If there are no stacks on the table, just remove the modifier.
		else
			self:Destroy()
		end
	end
end

function modifier_imba_tower_frost_shroud_debuff:IsHidden()
	return false
end

function modifier_imba_tower_frost_shroud_debuff:IsPurgable()
	return true
end

function modifier_imba_tower_frost_shroud_debuff:IsDebuff()
	return true
end

function modifier_imba_tower_frost_shroud_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_imba_tower_frost_shroud_debuff:GetModifierMoveSpeedBonus_Percentage()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

	-- Calculate slow percentage, based on stack count
	local movespeed_slow = (self.ms_slow + self.slow_per_protective * protective_instinct_stacks) * self:GetStackCount()
	return movespeed_slow
end

function modifier_imba_tower_frost_shroud_debuff:GetModifierAttackSpeedBonus_Constant()
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)

	-- Calculate slow percentage, based on stack count
	local attackspeed_slow = (self.as_slow + self.slow_per_protective * protective_instinct_stacks) * self:GetStackCount()
	return attackspeed_slow
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--		   		   HEALING TOWER
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------


imba_tower_healing_tower = imba_tower_healing_tower or class({})
LinkLuaModifier("modifier_tower_healing_think", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_healing_tower:GetIntrinsicModifierName()
	return "modifier_tower_healing_think"
end

function imba_tower_healing_tower:GetAbilityTextureName()
	return "custom/tower_healing_wave"
end

modifier_tower_healing_think = modifier_tower_healing_think or class({})

function modifier_tower_healing_think:OnCreated()
	if IsServer() then
		-- Ability properties
		if not self:GetAbility() then
			self:Destroy()
			return nil
		end
		self.particle_heal = "particles/hero/tower/tower_healing_wave.vpcf"

		-- Ability specials
		self.search_radius = self:GetAbility():GetSpecialValueFor("search_radius")
		self.bounce_delay = self:GetAbility():GetSpecialValueFor("bounce_delay")
		self.hp_threshold = self:GetAbility():GetSpecialValueFor("hp_threshold")
		self.bounce_radius = self:GetAbility():GetSpecialValueFor("bounce_radius")

		self:StartIntervalThink(0.2)
	end
end

function modifier_tower_healing_think:OnRefresh()
	self:OnCreated()
end

function modifier_tower_healing_think:OnIntervalThink()
	if IsServer() then

		-- If ability is on cooldown, do nothing
		if not self:GetAbility():IsCooldownReady() then
			return nil
		end

		-- Set variables
		local healing_in_process = false
		local current_healed_hero

		-- Clear heroes healed marker
		local heroes = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),
			nil,
			25000, --global
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		for _, hero in pairs(heroes) do
			hero.healed_by_healing_wave = false
		end

		-- Look for heroes that need healing
		heroes = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),
			nil,
			self.search_radius,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		-- Find at least one hero that needs healing, and heal him
		for _, hero in pairs(heroes) do
			local hero_hp_percent = hero:GetHealthPercent()
			if hero_hp_percent <= self.hp_threshold then
				current_healed_hero = hero
				HealingWaveBounce(self:GetParent(), self:GetParent(), self:GetAbility(), hero)
				self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(-1))
				break
			end
		end

		-- If no hero was found that needed healing, do nothing
		if not current_healed_hero then
			return nil
		end

		-- Start bouncing with bounce delay
		Timers:CreateTimer(self.bounce_delay, function()
			-- If those are null then the tower most likely died during self.bounce_delay... 
			if self == nil then return nil end
			if not self:GetParent() or not self.bounce_radius or not self:GetAbility() then 
				return nil
			end
			-- Still don't know if other heroes need healing, assumes doesn't unless found
			local heroes_need_healing = false

			-- Look for other heroes nearby, regardless of if they need healing
			heroes = FindUnitsInRadius(
				self:GetParent():GetTeamNumber(),
				current_healed_hero:GetAbsOrigin(),
				nil,
				self.bounce_radius,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)

			-- Search for a hero
			for _, hero in pairs(heroes) do
				if not hero.healed_by_healing_wave and current_healed_hero ~= hero then
					heroes_need_healing = true
					HealingWaveBounce(self:GetParent(), current_healed_hero, self:GetAbility(), hero)
					current_healed_hero = hero
					break
				end
			end

			-- If a hero was found, there might be more: repeat operation
			if heroes_need_healing then
				return bounce_delay
			else
				return nil
			end
		end)
	end
end

function HealingWaveBounce(caster, source, ability, hero)
	local sound_cast = "Greevil.Shadow_Wave"
	local particle_heal = "particles/hero/tower/tower_healing_wave.vpcf"
	local heal_amount = ability:GetSpecialValueFor("heal_amount")

	-- Mark hero as healed
	hero.healed_by_healing_wave = true

	-- Apply particle effect
	local particle_heal_fx = ParticleManager:CreateParticle(particle_heal, PATTACH_ABSORIGIN, source)
	ParticleManager:SetParticleControl(particle_heal_fx, 0, source:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_heal_fx, 1, hero:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_heal_fx, 3, source:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_heal_fx, 4, source:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_heal_fx)

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Heal target
	hero:Heal(heal_amount, caster)

	-- dispel
	hero:Purge(false, true, false, true, false)
end

function modifier_tower_healing_think:IsHidden()
	return true
end

function modifier_tower_healing_think:IsPurgable()
	return false
end

---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Tenacity Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_tenacity = imba_tower_tenacity or class({})
LinkLuaModifier("modifier_imba_tower_tenacity_aura", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_tenacity_aura_buff", "components/abilities/buildings/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_tenacity:GetAbilityTextureName()
	return "custom/tower_tenacity"
end

function imba_tower_tenacity:GetIntrinsicModifierName()
	return "modifier_imba_tower_tenacity_aura"
end

-- Tower Aura
modifier_imba_tower_tenacity_aura = modifier_imba_tower_tenacity_aura or class({})

function modifier_imba_tower_tenacity_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

function modifier_imba_tower_tenacity_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_tenacity_aura:GetAuraDuration()
	return self.aura_stickyness
end

function modifier_imba_tower_tenacity_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_tower_tenacity_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_tenacity_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_tenacity_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_tenacity_aura:GetModifierAura()
	return "modifier_imba_tower_tenacity_aura_buff"
end

function modifier_imba_tower_tenacity_aura:IsAura()
	return true
end

function modifier_imba_tower_tenacity_aura:IsDebuff()
	return false
end

function modifier_imba_tower_tenacity_aura:IsHidden()
	return true
end

-- Tenacity Modifier
modifier_imba_tower_tenacity_aura_buff = modifier_imba_tower_tenacity_aura_buff or class({})

function modifier_imba_tower_tenacity_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.ability then
		self:Destroy()
		return nil
	end
	self.parent = self:GetParent()

	-- Ability specials
	self.base_tenacity_pct = self.ability:GetSpecialValueFor("base_tenacity_pct")
	self.tenacity_per_protective = self.ability:GetSpecialValueFor("tenacity_per_protective")
end

function modifier_imba_tower_tenacity_aura_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end

function modifier_imba_tower_tenacity_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tower_tenacity_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_tenacity_aura_buff:GetModifierStatusResistanceStacking()
	if self.caster:IsNull() then return 0 end
	local protective_instinct_stacks = self.caster:GetModifierStackCount("modifier_imba_tower_protective_instinct", self.caster)
	local tenacity = self.base_tenacity_pct + self.tenacity_per_protective * protective_instinct_stacks
	return tenacity
end
