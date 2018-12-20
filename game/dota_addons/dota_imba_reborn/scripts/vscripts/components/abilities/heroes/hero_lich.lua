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
--     Shush, 22.03.2017
--     naowin, 25.06.2018

-----------------------------------
--          COLD FRONT           --
-----------------------------------

imba_lich_cold_front = class({})
LinkLuaModifier("modifier_imba_cold_front_passive", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_cold_front_debuff", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_cold_front_freeze", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)

function imba_lich_cold_front:GetAbilityTextureName()
	return "custom/lich_cold_front"
end

function imba_lich_cold_front:IsInnateAbility()
	return true
end

function imba_lich_cold_front:GetIntrinsicModifierName()
	return "modifier_imba_cold_front_passive"
end

-- Cold Front attack modifier
modifier_imba_cold_front_passive = class({})

function modifier_imba_cold_front_passive:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()

		-- Ability specials
		self.stacks_per_attack = self.ability:GetSpecialValueFor("stacks_per_attack")
	end
end

function modifier_imba_cold_front_passive:IsHidden() return true end
function modifier_imba_cold_front_passive:IsPurgable() return false end
function modifier_imba_cold_front_passive:IsDebuff() return false end

function modifier_imba_cold_front_passive:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFuncs
end

function modifier_imba_cold_front_passive:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- If it is an illusion, do nothing
		if attacker:IsIllusion() then
			return nil
		end

		-- If the target is spell immune, do nothing
		if target:IsMagicImmune() then
			return nil
		end

		-- If the target is a building, do nothing
		if target:IsBuilding() then
			return nil
		end

		-- Only applies when Lich attacks an enemy
		if attacker == self.caster and self.caster:GetTeamNumber() ~= target:GetTeamNumber() then
			IncreaseStacksColdFront(self.caster, target, self.stacks_per_attack)
		end
	end
end

-- Generic function responsible for adding Cold Front stacks from any spell
function IncreaseStacksColdFront(caster, target, stacks)
	-- Gather information
	local modifier_passive = "modifier_imba_cold_front_passive"
	local modifier_debuff = "modifier_imba_cold_front_debuff"

	-- Non-caster handling (Nether ward)
	if not caster or not caster:HasModifier(modifier_passive) then
		return nil
	end

	-- If Lich has Break applied on caster, do nothing
	if caster:PassivesDisabled() then
		return nil
	end

	-- Relevant information about the passive
	local modifier_passive_handler = caster:FindModifierByName(modifier_passive)
	local ability = modifier_passive_handler:GetAbility()
	local duration = ability:GetSpecialValueFor("duration")

	-- Add the modifier if the target doesn't have it already
	if not target:HasModifier(modifier_debuff) then
		target:AddNewModifier(caster, ability, modifier_debuff, {duration = duration})
	end

	-- Increase the stacks and refresh its duration
	local modifier_debuff_handler = target:FindModifierByName(modifier_debuff)
	if modifier_debuff_handler then
		modifier_debuff_handler:SetStackCount(modifier_debuff_handler:GetStackCount() + stacks)
		modifier_debuff_handler:ForceRefresh()
	end
end


-- Cold Front debuff
modifier_imba_cold_front_debuff = class({})

function modifier_imba_cold_front_debuff:IsHidden() return false end
function modifier_imba_cold_front_debuff:IsPurgable() return true end
function modifier_imba_cold_front_debuff:IsDebuff() return true end

function modifier_imba_cold_front_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.modifier_freeze = "modifier_imba_cold_front_freeze"

	if IsServer() then
		self.frost_nova_ability = self.caster:FindAbilityByName("imba_lich_frost_nova")
	end

	-- Ability specials
	self.max_stacks = self.ability:GetSpecialValueFor("max_stacks")
	self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")
	self.as_slow = self.ability:GetSpecialValueFor("as_slow")
	self.freeze_duration = self.ability:GetSpecialValueFor("freeze_duration")
end

function modifier_imba_cold_front_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_imba_cold_front_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end

function modifier_imba_cold_front_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow * (-1)
end

function modifier_imba_cold_front_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_imba_cold_front_debuff:OnStackCountChanged()
	if IsServer() then
		local stacks = self:GetStackCount()

		-- Check if we should freeze the target
		if stacks >= self.max_stacks then
			-- Reduce stacks to how much was needed to freeze the enemy
			self:SetStackCount(self:GetStackCount() - self.max_stacks)

			-- Cast Frost Nova on the target
			FrostNova(self.caster, self.frost_nova_ability, self.parent, true)

			-- Apply freeze on the target
			self.parent:AddNewModifier(self.caster, self.ability, self.modifier_freeze, {duration = self.freeze_duration})
		end
	end
end

-- Cold Front Freeze debuff
modifier_imba_cold_front_freeze = class({})

function modifier_imba_cold_front_freeze:IsHidden() return false end
function modifier_imba_cold_front_freeze:IsPurgable() return true end
function modifier_imba_cold_front_freeze:IsDebuff() return true end

function modifier_imba_cold_front_freeze:CheckState()
	local state = {[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true}
	return state
end

function modifier_imba_cold_front_freeze:OnCreated()
	self.parent = self:GetParent()
	self.particle_freeze = "particles/hero/lich/cold_front_freeze.vpcf"

	-- Create freeze particle
	self.particle_freeze_fx = ParticleManager:CreateParticle(self.particle_freeze, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle_freeze_fx, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_freeze_fx, 15, Vector(105, 230, 255))
	ParticleManager:SetParticleControl(self.particle_freeze_fx, 16, Vector(1, 0, 0))
	self:AddParticle(self.particle_freeze_fx, false, false, -1, false, false)
end




-----------------------------------
--          FROST NOVA           --
-----------------------------------

imba_lich_frost_nova = class({})
LinkLuaModifier("modifier_imba_frost_nova_debuff", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)

function imba_lich_frost_nova:GetAbilityTextureName()
	return "lich_frost_nova"
end

function imba_lich_frost_nova:IsHiddenWhenStolen()
	return false
end

function imba_lich_frost_nova:GetAOERadius()
	local radius = self:GetSpecialValueFor("radius")
	return radius
end

function imba_lich_frost_nova:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local cast_response = "lich_lich_ability_chain_1"..math.random(1,4)
	local kill_response = "lich_lich_ability_nova_0"..math.random(1,5)
	local cm_kill_response = "lich_lich_ability_nova_06"

	-- Ability specials
	local radius = ability:GetSpecialValueFor("radius")

	-- Commence Frost Nova
	FrostNova(caster, ability, target, false)

	-- Roll for cast response
	if RollPercentage(15) then
		EmitSoundOn(cast_response, caster)
	end

	-- Find all nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		target:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
		FIND_ANY_ORDER,
		false)

	for _,enemy in pairs(enemies) do

		-- Wait one frame: if target died, roll for kill response. If it's Crystal Maiden, use CM's response
		Timers:CreateTimer(FrameTime(), function()
			if not enemy:IsAlive() and enemy:IsRealHero() then

				-- Check for Crystal Maiden
				if enemy:GetUnitName() == "npc_dota_hero_crystal_maiden" then

					-- Roll for CM's kill response
					if RollPercentage(25) then
						EmitSoundOn(cm_kill_response, caster)

						-- If CM's response roll failed, try the normal kill response
					elseif RollPercentage(20) then
						EmitSoundOn(kill_response, caster)
					end

				else -- Anyone else roll normal kill response
					if RollPercentage(20) then
						EmitSoundOn(kill_response, caster)
				end
				end
			end
		end)
	end
end

function FrostNova(caster, ability, target, cold_front)
	local sound_cast = "Ability.FrostNova"
	local particle_nova = "particles/units/heroes/hero_lich/lich_frost_nova.vpcf"
	local modifier_nova = "modifier_imba_frost_nova_debuff"
	local should_add_cold_front_stacks = true

	-- Ability specials
	local radius = ability:GetSpecialValueFor("radius")
	local aoe_damage = ability:GetSpecialValueFor("aoe_damage")
	local target_damage = ability:GetSpecialValueFor("target_damage")
	local slow_duration = ability:GetSpecialValueFor("slow_duration")
	local main_cold_front_stacks = ability:GetSpecialValueFor("main_cold_front_stacks")
	local area_cold_front_stacks = ability:GetSpecialValueFor("area_cold_front_stacks")

	-- #3 Talent: Frost Nova now deals a portion of the main target's current health as damage
	if caster:HasTalent("special_bonus_imba_lich_3") then
		-- Calculate target's current health
		local damage_current_health = target:GetHealth() * caster:FindTalentValue("special_bonus_imba_lich_3") * 0.01

		-- Increase damage on main target
		target_damage = target_damage + damage_current_health
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, target)

	-- If target has Linken's Sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- If the source is Cold Front, don't add stacks
	if cold_front then
		should_add_cold_front_stacks = false
	end

	-- Add particle effect
	local particle_nova_fx = ParticleManager:CreateParticle(particle_nova, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_nova_fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_nova_fx, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(particle_nova_fx, 2, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_nova_fx)

	-- Damage the main target
	local damageTable = {victim = target,
		damage = target_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		attacker = caster,
		ability = ability
	}

	ApplyDamage(damageTable)

	-- Add stacks to Cold Front, if appropriate
	if should_add_cold_front_stacks then
		IncreaseStacksColdFront(caster, target, main_cold_front_stacks)
	end

	-- Find all nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		target:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
		FIND_ANY_ORDER,
		false)

	for _,enemy in pairs(enemies) do

		--Make sure it doesn't hit someone that suddenly got magic immune
		if not enemy:IsMagicImmune() then

			-- Damage every enemy in the AoE, including the main target.
			local damageTable = {victim = enemy,
				damage = aoe_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				attacker = caster,
				ability = ability
			}

			ApplyDamage(damageTable)

			-- Add stacks to Cold Front, if appropriate
			if should_add_cold_front_stacks then
				IncreaseStacksColdFront(caster, enemy, area_cold_front_stacks)
			end

			-- Apply Frost Nova debuff
			enemy:AddNewModifier(caster, ability, modifier_nova, {duration = slow_duration})
		end
	end

	-- #4 Talent: Frost Nova draws a line of exploding Frost Novas that explode after a small delay
	if caster:HasTalent("special_bonus_imba_lich_4") and not cold_front then
		-- Talent properties
		local caster_loc = caster:GetAbsOrigin()
		local particle_nova_flower = "particles/hero/lich/nova_explosions_main.vpcf"

		-- Talent specials
		local distance_per_nova = caster:FindTalentValue("special_bonus_imba_lich_4", "distance_per_nova")
		local damage_radius = caster:FindTalentValue("special_bonus_imba_lich_4", "damage_radius")
		local nova_damage = caster:FindTalentValue("special_bonus_imba_lich_4", "nova_damage")
		local cold_front_stacks = caster:FindTalentValue("special_bonus_imba_lich_4", "cold_front_stacks")
		local explosion_delay = caster:FindTalentValue("special_bonus_imba_lich_4", "explosion_delay")
		local creation_delay = caster:FindTalentValue("special_bonus_imba_lich_4", "creation_delay")

		-- Determine how many Novas should be created
		local distance = (target:GetAbsOrigin() - caster_loc):Length2D()
		local direction = (target:GetAbsOrigin() - caster_loc):Normalized()
		local novas = math.floor(distance / distance_per_nova)

		-- Create each nova with increasing delays
		for i = 1, novas do
			Timers:CreateTimer(creation_delay * i, function()

					-- Determine location of nova
					local location = caster_loc + direction * distance_per_nova * i
					
					-- Might save this for a future update (makes a circle instead of a line)
					-- local location = target:GetAbsOrigin() + Vector(math.cos(math.rad(45 * i)), math.sin(math.rad(45 * i))) * (damage_radius + distance_per_nova)

					-- Apply particle effect
					local particle_nova_flower_fx = ParticleManager:CreateParticle(particle_nova_flower, PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleControl(particle_nova_flower_fx, 0, location)
					ParticleManager:SetParticleControl(particle_nova_flower_fx, 3, location)

					-- Start a timer for destruction
					Timers:CreateTimer(explosion_delay, function()

							-- Emit sound
							EmitSoundOnLocationWithCaster(location, sound_cast, caster)

							-- Remove flower particle
							ParticleManager:DestroyParticle(particle_nova_flower_fx, false)
							ParticleManager:ReleaseParticleIndex(particle_nova_flower_fx)

							-- Apply explosion particle
							local particle_nova_fx = ParticleManager:CreateParticle(particle_nova, PATTACH_WORLDORIGIN, nil)
							ParticleManager:SetParticleControl(particle_nova_fx, 0, location)
							ParticleManager:SetParticleControl(particle_nova_fx, 1, Vector(radius, radius, radius))
							ParticleManager:SetParticleControl(particle_nova_fx, 2, location)
							ParticleManager:ReleaseParticleIndex(particle_nova_fx)

							-- Find all enemies in radius
							local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
								location,
								nil,
								damage_radius,
								DOTA_UNIT_TARGET_TEAM_ENEMY,
								DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
								DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
								FIND_ANY_ORDER,
								false)

							for _, enemy in pairs(enemies) do
								-- Deal damage to each
								if not enemy:IsMagicImmune() then
									local damageTable = {victim = enemy,
										damage = aoe_damage,
										damage_type = DAMAGE_TYPE_MAGICAL,
										attacker = caster,
										ability = ability
									}

									ApplyDamage(damageTable)

									-- Add one stack of Cold Front to each enemy hit
									IncreaseStacksColdFront(caster, enemy, cold_front_stacks)
								end
							end
					end)
			end)
		end
	end
end


-- Slow debuff
modifier_imba_frost_nova_debuff = class({})

function modifier_imba_frost_nova_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")
	self.as_slow = self.ability:GetSpecialValueFor("as_slow")
end

function modifier_imba_frost_nova_debuff:IsHidden() return false end
function modifier_imba_frost_nova_debuff:IsPurgable() return true end
function modifier_imba_frost_nova_debuff:IsDebuff() return true end

function modifier_imba_frost_nova_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_imba_frost_nova_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_imba_frost_nova_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end

function modifier_imba_frost_nova_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow * (-1)
end


-----------------------------------
--          FROST ARMOR          --
-----------------------------------

imba_lich_frost_armor = class({})
LinkLuaModifier("modifier_imba_frost_armor_buff", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_armor_debuff", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_armor_freeze", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_armor_auto_cast", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_armor_freezing_point", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)

function imba_lich_frost_armor:GetAbilityTextureName()
	return "lich_frost_armor"
end

function imba_lich_frost_armor:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()

		-- Can't apply on self since Lich already got it, like, forever
		if caster == target then
			return UF_FAIL_CUSTOM
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_lich_frost_armor:GetCustomCastErrorTarget(target)
	return "dota_hud_error_lich_self_ice_armor"
end

function imba_lich_frost_armor:IsHiddenWhenStolen()
	return false
end

function imba_lich_frost_armor:OnUnStolen()
	local modifier_buff = "modifier_imba_frost_armor_buff"
	local caster = self:GetCaster()

	-- Remove Ice Armor from Rubick when he loses the spell
	if caster:HasModifier(modifier_buff) then
		caster:RemoveModifierByName(modifier_buff)
	end
end

function imba_lich_frost_armor:GetIntrinsicModifierName()
	return "modifier_imba_frost_armor_auto_cast"
end

function imba_lich_frost_armor:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local modifier_armor = "modifier_imba_frost_armor_buff"

	-- Reapply Frost Armor on self
	if caster:HasModifier(modifier_armor) then
		caster:RemoveModifierByName(modifier_armor)
		caster:AddNewModifier(caster, ability, modifier_armor, {})
	else
		caster:AddNewModifier(caster, ability, modifier_armor, {})
	end
end

-- Function to ensure the talent that gives INT to armor applies if leveled when dead
function imba_lich_frost_armor:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_lich_5") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_lich_5") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_lich_5", {})
	end
end

function imba_lich_frost_armor:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local cast_response = "lich_lich_ability_armor_0"..math.random(1,5)
	local sound_cast = "Hero_Lich.FrostArmor"
	local modifier_armor = "modifier_imba_frost_armor_buff"

	-- Ability specials
	local armor_duration = ability:GetSpecialValueFor("armor_duration")

	-- Roll for cast response
	if RollPercentage(75) then
		EmitSoundOn(cast_response, caster)
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, target)

	-- Grant the target ally the armor buff
	target:AddNewModifier(caster, ability, modifier_armor, {duration = armor_duration})
end

-- #5 Talent: Frost Armor adds a portion of the Lich's intelligence to the armor bonus
LinkLuaModifier("modifier_special_bonus_imba_lich_5", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_lich_5 = modifier_special_bonus_imba_lich_5 or class({})
function modifier_special_bonus_imba_lich_5:IsHidden() 		return true end
function modifier_special_bonus_imba_lich_5:IsPurgable() 	return false end
function modifier_special_bonus_imba_lich_5:RemoveOnDeath() return false end

function modifier_special_bonus_imba_lich_5:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_special_bonus_imba_lich_5:OnIntervalThink()
	if IsServer() then
		-- Calculate intelligence bonus
		local intelligence = self:GetParent():GetIntellect()
		local armor_bonus = math.floor(intelligence * self:GetParent():FindTalentValue("special_bonus_imba_lich_5") * 0.01)

		self:SetStackCount(armor_bonus)
	end
end


-- Frost Armor buff
modifier_imba_frost_armor_buff = class({})

function modifier_imba_frost_armor_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_frost_armor = "particles/units/heroes/hero_lich/lich_frost_armor.vpcf"
	self.modifier_armor_debuff = "modifier_imba_frost_armor_debuff"

	-- Ability specials
	self.armor_bonus = self.ability:GetSpecialValueFor("armor_bonus")
	self.frost_duration = self.ability:GetSpecialValueFor("frost_duration")
	self.freeze_attacks = self.ability:GetSpecialValueFor("freeze_attacks")
	self.cold_front_stacks = self.ability:GetSpecialValueFor("cold_front_stacks")

	-- Add particle
	self.particle_frost_armor_fx = ParticleManager:CreateParticle(self.particle_frost_armor, PATTACH_OVERHEAD_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle_frost_armor_fx, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_frost_armor_fx, 1, Vector(1,1,1))
	-- Commenting this line out because it isn't properly attaching the particle
	--ParticleManager:SetParticleControlEnt(self.particle_frost_armor_fx, 2, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", self.parent:GetAbsOrigin(), true)
	self:AddParticle(self.particle_frost_armor_fx, false, false, -1, false, false)

	-- #8 Talent: Frost Armor is now an aura that slows nearby enemies in a small range around the target. The slow gets stronger each time the target is attacked.
	-- Aura starts with base stacks
	if IsServer() then
		if self.caster:HasTalent("special_bonus_imba_lich_8") then
			local base_slow = self.caster:FindTalentValue("special_bonus_imba_lich_8", "base_slow")
			self:SetStackCount(base_slow)

			self:StartIntervalThink(0.5)
		end
	end
end

function modifier_imba_frost_armor_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_frost_armor_buff:OnIntervalThink()
	-- #8 Talent: Frost Armor is now an aura that slows nearby enemies in a small range around the target. The slow gets stronger each time the target is attacked.
	-- Thinks updates stack counts for nearby enemies
	
	if self:GetCaster():IsNull() then
		self:StartIntervalThink(-1)
		return
	end
	
	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),
		self.parent:GetAbsOrigin(),
		nil,
		self.caster:FindTalentValue("special_bonus_imba_lich_8", "aura_range"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	for _, enemy in pairs(enemies) do

		-- Check if the enemy has the aura modifier. If it does, get the handle and set its stack count to be the same as this aura
		if enemy:HasModifier("modifier_imba_frost_armor_freezing_point") then
			local modifier_handler = enemy:FindModifierByName("modifier_imba_frost_armor_freezing_point")
			if modifier_handler then
				modifier_handler:SetStackCount(self:GetStackCount())
			end
		end
	end
end

function modifier_imba_frost_armor_buff:IsHidden() return false end
function modifier_imba_frost_armor_buff:IsDebuff() return false end

function modifier_imba_frost_armor_buff:IsPurgable()
	-- Cannot be purged on caster
	if self.caster == self.parent then
		return false
	end

	return true
end

function modifier_imba_frost_armor_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFuncs
end

function modifier_imba_frost_armor_buff:GetModifierPhysicalArmorBonus()
	local armor_bonus = self.armor_bonus
	if self.caster:HasModifier("modifier_special_bonus_imba_lich_5") then
		local armor_bonus_talent = self.caster:GetModifierStackCount("modifier_special_bonus_imba_lich_5", self.caster)
		
		armor_bonus = armor_bonus + armor_bonus_talent
	end

	return armor_bonus
end

function modifier_imba_frost_armor_buff:OnAttackLanded(keys)
	local attacker = keys.attacker
	local target = keys.target

	-- Only apply on an enemy attacker attacking the parent
	if target == self.parent and target:GetTeamNumber() ~= attacker:GetTeamNumber() then

		-- If attacker is magic immune, do nothing
		if attacker:IsMagicImmune() then
			return nil
		end

		-- If the attacker is a building (tower), do nothing
		if attacker:IsBuilding() then
			return nil
		end

		-- Set variable
		local modifier_debuff_handler

		-- If attacker doesn't have the debuff, apply it
		if not attacker:HasModifier(self.modifier_armor_debuff) then
			modifier_debuff_handler = attacker:AddNewModifier(self.caster, self.ability, self.modifier_armor_debuff, {duration = self.frost_duration})

			-- Set frost armor stacks to attacks to break
			if modifier_debuff_handler then
				modifier_debuff_handler:SetStackCount(self.freeze_attacks)
			end
		else
			-- Decrement a stack and refresh the debuff
			modifier_debuff_handler = attacker:FindModifierByName(self.modifier_armor_debuff)
			modifier_debuff_handler:DecrementStackCount()
			modifier_debuff_handler:ForceRefresh()
		end

		-- Apply Cold Front stacks
		IncreaseStacksColdFront(self.caster, attacker, self.cold_front_stacks)

		-- #8 Talent: Frost Armor is now an aura that slows nearby enemies in a small range around the target. The slow gets stronger each time the target is attacked.
		if self.caster:HasTalent("special_bonus_imba_lich_8") then
			-- Strengthen aura
			local max_slow = self.caster:FindTalentValue('special_bonus_imba_lich_8', "max_slow")
			local slow_increase_per_hit = self.caster:FindTalentValue("special_bonus_imba_lich_8", "slow_increase_per_hit")
			if self:GetStackCount() < max_slow then
				self:SetStackCount(math.min(self:GetStackCount() + slow_increase_per_hit, max_slow))
			end
		end
	end
end

function modifier_imba_frost_armor_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_armor.vpcf"
end

function modifier_imba_frost_armor_buff:IsAura()
	-- #8 Talent: Frost Armor is now an aura that slows nearby enemies in a small range around the target. The slow gets stronger each time the target is attacked.
	if self:GetCaster():HasTalent("special_bonus_imba_lich_8") then
		return true
	end

	return false
end

function modifier_imba_frost_armor_buff:GetAuraRadius()
	return self:GetCaster():FindTalentValue("special_bonus_imba_lich_8", "aura_range")
end

function modifier_imba_frost_armor_buff:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_frost_armor_buff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_frost_armor_buff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_frost_armor_buff:GetModifierAura()
	return "modifier_imba_frost_armor_freezing_point"
end


-- Freezing Point talent aura slow
modifier_imba_frost_armor_freezing_point = modifier_imba_frost_armor_freezing_point or class({})

function modifier_imba_frost_armor_freezing_point:IsHidden() return false end
function modifier_imba_frost_armor_freezing_point:IsPurgable() return false end
function modifier_imba_frost_armor_freezing_point:IsDebuff() return true end

function modifier_imba_frost_armor_freezing_point:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_imba_frost_armor_freezing_point:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_imba_frost_armor_freezing_point:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount() * (-1)
end

function modifier_imba_frost_armor_freezing_point:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() * (-1)
end

-- Talent Modifier trigger
modifier_special_bonus_imba_lich_8 = modifier_special_bonus_imba_lich_8 or class({})

function modifier_special_bonus_imba_lich_8:OnCreated()
	if IsServer() then
		if self:GetParent():HasModifier("modifier_imba_frost_armor_buff") then
			local modifier_handler = self:GetParent():FindModifierByName("modifier_imba_frost_armor_buff")
			if modifier_handler then
				modifier_handler:ForceRefresh()
			end
		end
	end
end

-- Frost debuff on attacker
modifier_imba_frost_armor_debuff = class({})

function modifier_imba_frost_armor_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.modifier_disarm = "modifier_imba_frost_armor_freeze"

	-- Ability specials
	self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")
	self.as_slow = self.ability:GetSpecialValueFor("as_slow")
	self.disarm_duration = self.ability:GetSpecialValueFor("disarm_duration")
	self.freeze_attacks = self.ability:GetSpecialValueFor("freeze_attacks")
end

function modifier_imba_frost_armor_debuff:IsHidden() return false end
function modifier_imba_frost_armor_debuff:IsPurgable() return true end
function modifier_imba_frost_armor_debuff:IsDebuff() return true end

function modifier_imba_frost_armor_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_imba_frost_armor_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_imba_frost_armor_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end

function modifier_imba_frost_armor_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow * (-1)
end

function modifier_imba_frost_armor_debuff:OnStackCountChanged()
	local stacks = self:GetStackCount()

	if stacks == 0 then
		-- Reset attack count
		self:SetStackCount(self.freeze_attacks)

		-- If target has Linken's Sphere off cooldown, do nothing
		if self.parent:GetTeam() ~= self.caster:GetTeam() then
			if self.parent:TriggerSpellAbsorb(self.ability) then
				return nil
			end
		end

		-- Apply disarm
		self.parent:AddNewModifier(self.caster, self.ability, self.modifier_disarm, {duration = self.disarm_duration})
	end
end

-- Freeze debuff
modifier_imba_frost_armor_freeze = class({})

function modifier_imba_frost_armor_freeze:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_hand_freeze = "particles/hero/lich/lich_ice_armor_freeze.vpcf"

	self.particle_hand_freeze_fx = ParticleManager:CreateParticle(self.particle_hand_freeze, PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(self.particle_hand_freeze_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.particle_hand_freeze_fx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	self:AddParticle(self.particle_hand_freeze_fx, false, false, -1, false, false)


end

function modifier_imba_frost_armor_freeze:IsHidden() return false end
function modifier_imba_frost_armor_freeze:IsPurgable() return true end
function modifier_imba_frost_armor_freeze:IsDebuff() return true end

function modifier_imba_frost_armor_freeze:CheckState()
	local state = {[MODIFIER_STATE_DISARMED] = true}
	return state
end

-- Auto cast thinker
modifier_imba_frost_armor_auto_cast = class({})

function modifier_imba_frost_armor_auto_cast:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_frost_armor = "modifier_imba_frost_armor_buff"

	self.autocast_radius = self.ability:GetSpecialValueFor("autocast_radius")
end

function modifier_imba_frost_armor_auto_cast:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_RESPAWN}

	return decFuncs
end

function modifier_imba_frost_armor_auto_cast:OnRespawn(keys)
	-- Only apply if the unit is the caster itself
	if keys.unit == self.caster then
		self.caster:AddNewModifier(self.caster, self.ability, self.modifier_frost_armor, {})
	end
end

function modifier_imba_frost_armor_auto_cast:OnAttack(keys)
	local target = keys.target

	-- If the spell is not on auto cast, do nothing
	if not self.ability:GetAutoCastState() then
		return nil
	end

	-- If the target wasn't an ally, do nothing
	if self.caster:GetTeamNumber() ~= target:GetTeamNumber() then
		return nil
	end

	-- If the target is not a hero or a building, do nothing
	if not target:IsHero() and not target:IsBuilding() then
		return nil
	end

	-- If the target is the caster, do nothing (caster always have Ice Armor)
	if self.caster == target then
		return nil
	end

	-- If the caster is channeling, do nothing (don't interrupt)
	if self.caster:IsChanneling() then
		return nil
	end

	-- If the target is too far away, do nothing
	local distance = (self.caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()
	if distance > self.autocast_radius then
		return nil
	end

	-- If the target already has the frost armor buff, do nothing
	if target:HasModifier(self.modifier_frost_armor) then
		return nil
	end

	-- If the ability is in cooldown, do nothing (why this is even needed lol)
	if not self.ability:IsCooldownReady() then
		return nil
	end

	-- Otherwise, cast Frost Armor on the target
	self.caster:CastAbilityOnTarget(target, self.ability, self.caster:GetPlayerID())
end

function modifier_imba_frost_armor_auto_cast:IsHidden() return true end
function modifier_imba_frost_armor_auto_cast:IsPurgable() return false end
function modifier_imba_frost_armor_auto_cast:IsDebuff() return false end
function modifier_imba_frost_armor_auto_cast:IsPermanent() return true end


-----------------------------------
--          SACRIFICE            --
-----------------------------------

imba_lich_dark_ritual = class({})
LinkLuaModifier("modifier_imba_dark_ritual_creeps", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dark_ritual_allied_sacrifice", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dark_ritual_enemy_sacrifice", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)

function imba_lich_dark_ritual:GetAbilityTextureName()
	return "lich_dark_ritual"
end

function imba_lich_dark_ritual:CastFilterResultTarget(target)
	if IsServer() then
		-- If Lich has the #2 Talent: Sacrifice can now be used on self, granting you and nearby allies the damage reduction buff
		-- He can target himself
		if self:GetCaster() == target and self:GetCaster():HasTalent("special_bonus_imba_lich_2") then
			return UF_SUCCESS
		end

		-- Otherwise, normal filtering
		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber())
		return nResult
	end
end

function imba_lich_dark_ritual:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local cast_response = "lich_lich_ability_ritual_"
	local cast_response_nums = {"01", "02", "03", "04", "05", "07", "13"}
	local sound_cast = "Ability.DarkRitual"
	local particle_sacrifice_allies = "particles/units/heroes/hero_lich/lich_dark_ritual.vpcf"
	local particle_sacrifice_enemy = "particles/hero/lich/lich_dark_ritual_enemy.vpcf"
	local modifier_creeps = "modifier_imba_dark_ritual_creeps"
	local modifier_allied_sacrifice = "modifier_imba_dark_ritual_allied_sacrifice"
	local modifier_enemy_sacrifice = "modifier_imba_dark_ritual_enemy_sacrifice"

	-- Ability specials
	local mana_conversion_pct = ability:GetSpecialValueFor("mana_conversion_pct")
	local xp_bonus_radius = ability:GetSpecialValueFor("xp_bonus_radius")
	local allied_creeps_radius = ability:GetSpecialValueFor("allied_creeps_radius")
	local sacrifice_duration = ability:GetSpecialValueFor("sacrifice_duration")

	-- If target has Linken's Sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- Roll for a cast response
	if RollPercentage(75) then
		-- Random a cast response from the appropriate sounds table
		local cast_response_number = cast_response_nums[math.random(1,7)]
		EmitSoundOn(cast_response..cast_response_number, caster)
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Find all nearby heroes (including Lich himself)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(),
		target:GetAbsOrigin(),
		nil,
		xp_bonus_radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	-- If it was a sacrifice, continue.
	if target ~= caster then

		-- Get the target's XP bounty and current HP
		local creep_xp = target:GetDeathXP()
		local creep_hp = target:GetHealth()

		-- Kill target
		target:Kill(ability, caster)

		-- Restore mana to Lich based on current HP
		local mana_gained = creep_hp * mana_conversion_pct * 0.01
		caster:GiveMana(mana_gained)

		-- XP Overhead message
		local particleName = "particles/msg_fx/msg_xp.vpcf"
		local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)

		local digits = 0
		if mana_gained then
			digits = #tostring(mana_gained)
		end

		ParticleManager:SetParticleControl(particle, 1, Vector(9, mana_gained, 6))
		ParticleManager:SetParticleControl(particle, 2, Vector(1, digits+1, 0))
		ParticleManager:SetParticleControl(particle, 3, Vector(170, 0, 250))

		-- Find all nearby allied creeps
		local allied_creeps = FindUnitsInRadius(caster:GetTeamNumber(),
			target:GetAbsOrigin(),
			nil,
			allied_creeps_radius,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_SUMMONED,
			FIND_ANY_ORDER,
			false)

		for _,creep in pairs (allied_creeps) do
			-- Give all nearby creeps the creep bonus modifier
			local modifier_creeps_handler = creep:AddNewModifier(caster, ability, modifier_creeps, {})

			if modifier_creeps_handler then
				-- For client interactions
				modifier_creeps_handler:SetStackCount(creep_hp)
			end
		end

		-- Divide target's XP bounty between all heroes in the AoE
		local xp_per_hero = creep_xp / #heroes

		for _,hero in pairs(heroes) do
			-- Increase all heroes' XP by the divided amount
			hero:AddExperience(xp_per_hero, false, false)
		end
	end

	-- Check if the sacrificed unit was an ally or an enemy
	local ally_creep

	if target:GetTeamNumber() == caster:GetTeamNumber() then
		ally_creep = true
	else
		ally_creep = false
	end

	for _,hero in pairs(heroes) do

		-- Give heroes appropriate modifier,
		if ally_creep then
			hero:AddNewModifier(caster, ability, modifier_allied_sacrifice, {duration = sacrifice_duration})

			-- Add ally particle effect
			local particle_sacrifice_allies_fx = ParticleManager:CreateParticle(particle_sacrifice_allies, PATTACH_CUSTOMORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(particle_sacrifice_allies_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle_sacrifice_allies_fx, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle_sacrifice_allies_fx)
		else
			hero:AddNewModifier(caster, ability, modifier_enemy_sacrifice, {duration = sacrifice_duration})

			-- Add enemy particle effect
			local particle_sacrifice_enemy_fx = ParticleManager:CreateParticle(particle_sacrifice_enemy, PATTACH_CUSTOMORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(particle_sacrifice_enemy_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle_sacrifice_enemy_fx, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle_sacrifice_enemy_fx)
		end
	end
end

-- Allied creeps bonuses modifier
modifier_imba_dark_ritual_creeps = class({})

function modifier_imba_dark_ritual_creeps:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.creeps_bonus_as = self.ability:GetSpecialValueFor("creeps_bonus_as")
	self.creeps_bonus_hp_pct = self.ability:GetSpecialValueFor("creeps_bonus_hp_pct")
	self.creeps_bonus_dmg_pct = self.ability:GetSpecialValueFor("creeps_bonus_dmg_pct")

	if IsServer() then
		-- Force adjust HP
		Timers:CreateTimer(2, function()
			local adjusted_hp = self.parent:GetMaxHealth() + self:GetStackCount() * self.creeps_bonus_hp_pct * 0.01
			SetCreatureHealth(self.parent, adjusted_hp, true)
		end)
	end
end

function modifier_imba_dark_ritual_creeps:IsHidden() return false end
function modifier_imba_dark_ritual_creeps:IsPurgable() return true end
function modifier_imba_dark_ritual_creeps:IsDebuff() return false end

function modifier_imba_dark_ritual_creeps:GetEffectName()
	return "particles/hero/lich/lich_dark_ritual_buff_ally.vpcf"
end

function modifier_imba_dark_ritual_creeps:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}

	return decFuncs
end

function modifier_imba_dark_ritual_creeps:GetModifierAttackSpeedBonus_Constant()
	return self.creeps_bonus_as
end

function modifier_imba_dark_ritual_creeps:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount() * self.creeps_bonus_dmg_pct * 0.01
end

-- Allied sacrificed creep hero bonuses
modifier_imba_dark_ritual_allied_sacrifice = class({})

function modifier_imba_dark_ritual_allied_sacrifice:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.allied_kill_dmg_red_pct = self.ability:GetSpecialValueFor("allied_kill_dmg_red_pct")
end

function modifier_imba_dark_ritual_allied_sacrifice:IsHidden() return false end
function modifier_imba_dark_ritual_allied_sacrifice:IsPurgable() return true end
function modifier_imba_dark_ritual_allied_sacrifice:IsDebuff() return false end

function modifier_imba_dark_ritual_allied_sacrifice:GetEffectName()
	return "particles/hero/lich/lich_dark_ritual_buff_ally.vpcf"
end

function modifier_imba_dark_ritual_allied_sacrifice:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}

	return decFuncs
end

function modifier_imba_dark_ritual_allied_sacrifice:GetModifierIncomingDamage_Percentage()
	return self.allied_kill_dmg_red_pct * (-1)
end

-- Enemy sacrificed creep hero bonuses
modifier_imba_dark_ritual_enemy_sacrifice = class({})

function modifier_imba_dark_ritual_enemy_sacrifice:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.enemy_kill_bonus_dmg_pct = self.ability:GetSpecialValueFor("enemy_kill_bonus_dmg_pct")
	self.enemy_kill_bonus_spell_amp = self.ability:GetSpecialValueFor("enemy_kill_bonus_spell_amp")
end

function modifier_imba_dark_ritual_enemy_sacrifice:IsHidden() return false end
function modifier_imba_dark_ritual_enemy_sacrifice:IsPurgable() return true end
function modifier_imba_dark_ritual_enemy_sacrifice:IsDebuff() return false end

function modifier_imba_dark_ritual_enemy_sacrifice:GetEffectName()
	return "particles/hero/lich/lich_dark_ritual_buff_enemy.vpcf"
end

function modifier_imba_dark_ritual_enemy_sacrifice:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}

	return decFuncs
end

function modifier_imba_dark_ritual_enemy_sacrifice:GetModifierBaseDamageOutgoing_Percentage()
	return self.enemy_kill_bonus_dmg_pct
end

function modifier_imba_dark_ritual_enemy_sacrifice:GetModifierSpellAmplify_Percentage()
	return self.enemy_kill_bonus_spell_amp
end



-----------------------------------
--         CHAIN FROST           --
-----------------------------------

imba_lich_chain_frost = class({})
LinkLuaModifier("modifier_imba_chain_frost_slow", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_chain_frost_talent_buff", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)

function imba_lich_chain_frost:GetAbilityTextureName()
	return "lich_chain_frost"
end

function imba_lich_chain_frost:IsHiddenWhenStolen()
	return false
end

function imba_lich_chain_frost:CastFilterResultTarget(target)
	if IsServer() then
		if self:GetCaster():HasTalent("special_bonus_imba_lich_6") then
			if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
				return UF_SUCCESS
			end
		end

		local nResult = UnitFilter(target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber())
		return nResult
	end
end

function imba_lich_chain_frost:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()

	-- #6 Talent: Chain Frost can be cast on allies to give them a orb that spins around them. Taking damage from an enemy hero causes the Chain Frost to bounce to the attacker.
	if caster:HasTalent("special_bonus_imba_lich_6") and target:GetTeamNumber() == caster:GetTeamNumber() then
		local buff_duration = caster:FindTalentValue("special_bonus_imba_lich_6", "buff_duration")
		target:AddNewModifier(caster, ability, "modifier_imba_chain_frost_talent_buff", {duration = buff_duration})
	else
		self:LaunchProjectile(caster, target)
	end


end

function imba_lich_chain_frost:LaunchProjectile(source, target)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_cast = "Hero_Lich.ChainFrost"
	local particle_projectile = "particles/units/heroes/hero_lich/lich_chain_frost.vpcf"
	local scepter = caster:HasScepter()

	-- Ability specials
	local projectile_base_speed = ability:GetSpecialValueFor("projectile_base_speed")
	local projectile_vision = ability:GetSpecialValueFor("projectile_vision")
	local num_bounces = ability:GetSpecialValueFor("num_bounces")

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- If the caster has Scepter, increase bounces to infinity (well, almost, but you get the point)
	if scepter then
		num_bounces = num_bounces + 99999
	end

	-- Launch the projectile
	local chain_frost_projectile
	chain_frost_projectile = {Target = target,
		Source = source,
		Ability = ability,
		EffectName = particle_projectile,
		iMoveSpeed = projectile_base_speed,
		bDodgeable = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = true,
		iVisionRadius = projectile_vision,
		iVisionTeamNumber = caster:GetTeamNumber(),
		ExtraData = {bounces_left = num_bounces, current_projectile_speed = projectile_base_speed, main_chain_frost = true}
	}

	ProjectileManager:CreateTrackingProjectile(chain_frost_projectile)
end

function imba_lich_chain_frost:OnProjectileHit_ExtraData(target, location, extradata)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_hit = "Hero_Lich.ChainFrostImpact.Creep"
	local particle_projectile = "particles/units/heroes/hero_lich/lich_chain_frost.vpcf"
	local particle_mini_frost_projectile = "particles/hero/lich/lich_mini_frosts.vpcf"
	local modifier_slow = "modifier_imba_chain_frost_slow"

	-- Ability specials
	local slow_duration = ability:GetSpecialValueFor("slow_duration")
	local bounce_range = ability:GetSpecialValueFor("bounce_range")
	local damage = ability:GetSpecialValueFor("damage")
	local speed_increase_per_bounce = ability:GetSpecialValueFor("speed_increase_per_bounce")
	local projectile_delay = ability:GetSpecialValueFor("projectile_delay")
	local projectile_vision = ability:GetSpecialValueFor("projectile_vision")
	local bonus_projectiles = caster:FindTalentValue("special_bonus_imba_lich_7", "bonus_projectiles")
	local projectiles_damage_pct = caster:FindTalentValue("special_bonus_imba_lich_7", "projectiles_damage_pct")
	local cold_front_stacks = ability:GetSpecialValueFor("cold_front_stacks")

	-- Make sure there is a target
	if not target then return nil end

	EmitSoundOn("Hero_Lich.ChainFrostImpact.Hero", target)

	-- #1 Talent: Chain Frost bounces almost instantly after hitting a target
	if caster:HasTalent("special_bonus_imba_lich_1") then
		projectile_delay = caster:FindTalentValue("special_bonus_imba_lich_1")
	end

	-- Check if this is a main chain frost (not talent mini frosts)
	if extradata.main_chain_frost == 1 then
		-- Start a timer and bounce again!
		Timers:CreateTimer(projectile_delay, function()
			-- If there are no more bounces remaining, do nothing
			if extradata.bounces_left <= 0 then
				return nil
			end

			-- Find enemies in bounce range
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
				target:GetAbsOrigin(),
				nil,
				bounce_range,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				FIND_ANY_ORDER,
				false)

			-- Remove the current enemy target from the table of possible targets
			for i = 1, #enemies do
				if target == enemies[i] then
					table.remove(enemies, i)
					break
				end
			end

			-- If there are no enemies, do nothing
			if #enemies <= 0 then
				return nil
			end

			-- Increase bounce speed
			local projectile_speed = extradata.current_projectile_speed + speed_increase_per_bounce

			-- Reduce bounce count
			local bounces_left = extradata.bounces_left - 1

			-- Bounce to a random enemy
			local bounce_target = enemies[1]
			
			-- Add a check to heavily reduce bounces if near fountain for scepter ult to prevent massive chaining lag
			if caster:HasScepter() and IsNearFountain(enemies[1]:GetAbsOrigin(), 1200) then
				bounces_left = bounces_left - 10000
			end
			
			local chain_frost_projectile
			chain_frost_projectile = {Target = bounce_target,
				Source = target,
				Ability = ability,
				EffectName = particle_projectile,
				iMoveSpeed = projectile_speed,
				bDodgeable = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				bProvidesVision = true,
				iVisionRadius = projectile_vision,
				iVisionTeamNumber = caster:GetTeamNumber(),
				ExtraData = {bounces_left = bounces_left, current_projectile_speed = projectile_speed, main_chain_frost = true}
			}

			ProjectileManager:CreateTrackingProjectile(chain_frost_projectile)

			-- If there is more than one enemy and the caster has #7 Talent, throw smaller chain frosts at them
			if caster:HasTalent("special_bonus_imba_lich_7") then
				local projectiles_launched = 0

				for i = 2, #enemies do
					-- Check if there are still more projectiles that should be launched
					if projectiles_launched < bonus_projectiles then

						-- Define and launch a smaller frost
						chain_frost_projectile = {Target = enemies[i],
							Source = target,
							Ability = ability,
							EffectName = particle_mini_frost_projectile,
							iMoveSpeed = projectile_speed,
							bDodgeable = false,
							bVisibleToEnemies = true,
							bReplaceExisting = false,
							bProvidesVision = true,
							iVisionRadius = projectile_vision,
							iVisionTeamNumber = caster:GetTeamNumber(),
							ExtraData = {main_chain_frost = false}
						}

						ProjectileManager:CreateTrackingProjectile(chain_frost_projectile)

						-- Increment counter
						projectiles_launched = projectiles_launched + 1
					end
				end
			end
		end)
	else
		-- Talent mini ball! Adjust damage
		damage = damage * projectiles_damage_pct * 0.01
	end

	-- If target has Linken's Sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
	    if ((not self:GetCaster():HasScepter() and extradata.bounces_left == self:GetSpecialValueFor("num_bounces"))
		or (self:GetCaster():HasScepter() and extradata.bounces_left == self:GetSpecialValueFor("num_bounces") + 99999))
		and target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- If the target became spell immune, do nothing
	if target:IsMagicImmune() then
		return nil
	end

	-- Damage the target
	local damageTable = {victim = target,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		attacker = caster,
		ability = ability
	}

	ApplyDamage(damageTable)

	-- Apply slow
	target:AddNewModifier(caster, ability, modifier_slow, {duration = slow_duration})

	-- Add Cold Front stacks
	IncreaseStacksColdFront(caster, target, cold_front_stacks)
end

-- Slow modifier
modifier_imba_chain_frost_slow = class({})

function modifier_imba_chain_frost_slow:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")
	self.as_slow = self.ability:GetSpecialValueFor("as_slow")
end

function modifier_imba_chain_frost_slow:IsHidden() return false end
function modifier_imba_chain_frost_slow:IsPurgable() return true end
function modifier_imba_chain_frost_slow:IsDebuff() return true end

function modifier_imba_chain_frost_slow:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_imba_chain_frost_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end

function modifier_imba_chain_frost_slow:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow * (-1)
end

-- #6 Talent: Chain Frost can be cast on allies to give them a orb that spins around them. Taking damage from an enemy hero causes the Chain Frost to bounce to the attacker.
modifier_imba_chain_frost_talent_buff = modifier_imba_chain_frost_talent_buff or class({})

function modifier_imba_chain_frost_talent_buff:IsHidden() return false end
function modifier_imba_chain_frost_talent_buff:IsPurgable() return false end
function modifier_imba_chain_frost_talent_buff:IsDebuff() return false end

function modifier_imba_chain_frost_talent_buff:OnCreated()
	if IsServer() then
		-- Talent properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.particle_orb = "particles/hero/lich/lich_frost_ally_spin.vpcf"

		-- Talent specials
		self.max_distance = self.caster:FindTalentValue("special_bonus_imba_lich_6", "max_distance")

		-- Apply orb effect
		local particle_orb_fx = ParticleManager:CreateParticle(self.particle_orb, PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(particle_orb_fx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_orb_fx, 2, Vector(1,0,0))
		ParticleManager:SetParticleControl(particle_orb_fx, 3, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_orb_fx, 5, Vector(self.parent:GetHullRadius()*3, 1,1))
		self:AddParticle(particle_orb_fx, false, false, -1, false, false)
	end
end

function modifier_imba_chain_frost_talent_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_TAKEDAMAGE}

	return decFuncs
end

function modifier_imba_chain_frost_talent_buff:OnTakeDamage(keys)
	local unit = keys.unit
	local attacker = keys.attacker

	-- Only apply if the target unit is the parent
	if self.parent == unit then

		-- If the attacker was not a hero, do nothing
		if not attacker:IsHero() then
			return nil
		end

		-- If the attacker is too far away, do nothing
		local distance = (unit:GetAbsOrigin() - attacker:GetAbsOrigin()):Length2D()
		if distance > self.max_distance then
			return nil
		end

		-- If the attacker is on the same team as the caster, do nothing
		if unit:GetTeamNumber() == attacker:GetTeamNumber() then
			return nil
		end

		-- That's a valid enemy hero, fire the Chain Frost at it!
		self.ability:LaunchProjectile(self.parent, attacker)

		-- Remove the buff immediately after
		self:Destroy()
	end
end
