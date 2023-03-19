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
--	   AltiV, IDK sometime in 2019

-----------------------------------
--          COLD FRONT           --
-----------------------------------

imba_lich_cold_front = class({})
LinkLuaModifier("modifier_imba_cold_front_passive", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_cold_front_debuff", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_cold_front_freeze", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)

function imba_lich_cold_front:GetAbilityTextureName()
	return "lich_cold_front"
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
	local decFuncs = { MODIFIER_EVENT_ON_ATTACK_LANDED }

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
		target:AddNewModifier(caster, ability, modifier_debuff, { duration = duration * (1 - target:GetStatusResistance()) })
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
	local decFuncs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT }

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
			self.parent:AddNewModifier(self.caster, self.ability, self.modifier_freeze, { duration = self.freeze_duration * (1 - self.parent:GetStatusResistance()) })
		end
	end
end

-- Cold Front Freeze debuff
modifier_imba_cold_front_freeze = class({})

function modifier_imba_cold_front_freeze:IsHidden() return false end

function modifier_imba_cold_front_freeze:IsPurgable() return true end

function modifier_imba_cold_front_freeze:IsDebuff() return true end

function modifier_imba_cold_front_freeze:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true
	}
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
LinkLuaModifier("modifier_imba_frost_nova_handler", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)

function imba_lich_frost_nova:GetAbilityTextureName()
	return "lich_frost_nova"
end

function imba_lich_frost_nova:IsHiddenWhenStolen()
	return false
end

function imba_lich_frost_nova:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_lich_frost_nova:GetBehavior()
	if not self:GetCaster():HasTalent("special_bonus_imba_lich_11") then
		return self.BaseClass.GetBehavior(self)
	else
		return tonumber(tostring(self.BaseClass.GetBehavior(self))) + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
end

function imba_lich_frost_nova:GetCooldown(level)
	if self:GetCaster():HasTalent("special_bonus_imba_lich_11") and self:GetCaster():GetModifierStackCount("modifier_imba_frost_nova_handler", self:GetCaster()) == 1 then
		return self.BaseClass.GetCooldown(self, level) * self:GetCaster():FindTalentValue("special_bonus_imba_lich_11", "cooldown_mult")
	else
		return self.BaseClass.GetCooldown(self, level)
	end
end

function imba_lich_frost_nova:GetIntrinsicModifierName()
	return "modifier_imba_frost_nova_handler"
end

function imba_lich_frost_nova:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local cast_response = "lich_lich_ability_chain_1" .. math.random(1, 4)
	local kill_response = "lich_lich_ability_nova_0" .. math.random(1, 5)
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
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	for _, enemy in pairs(enemies) do
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
		local damage_current_health = target:GetHealth() * caster:FindTalentValue("special_bonus_imba_lich_3") / 100

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
	local damageTable = {
		victim = target,
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
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	for _, enemy in pairs(enemies) do
		--Make sure it doesn't hit someone that suddenly got magic immune
		if not enemy:IsMagicImmune() then
			-- Damage every enemy in the AoE, including the main target.
			local damageTable = {
				victim = enemy,
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
			enemy:AddNewModifier(caster, ability, modifier_nova, { duration = slow_duration * (1 - enemy:GetStatusResistance()) })
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
							local damageTable = {
								victim = enemy,
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

	-- Death Blossom
	if caster:HasTalent("special_bonus_imba_lich_11") and not cold_front and ability:GetAutoCastState() then
		-- Talent properties
		local particle_nova_flower = "particles/hero/lich/nova_explosions_main.vpcf"

		-- Talent specials
		local rings                = caster:FindTalentValue("special_bonus_imba_lich_11", "rings")
		local novae_per_ring       = caster:FindTalentValue("special_bonus_imba_lich_11", "novae_per_ring")
		local ring_distance        = caster:FindTalentValue("special_bonus_imba_lich_11", "ring_distance")
		local creation_delay       = caster:FindTalentValue("special_bonus_imba_lich_11", "creation_delay")
		local explosion_delay      = caster:FindTalentValue("special_bonus_imba_lich_11", "explosion_delay")
		local cold_front_stacks    = caster:FindTalentValue("special_bonus_imba_lich_11", "cold_front_stacks")

		local target_loc           = target:GetAbsOrigin()

		local deviation            = RandomInt(0, 359)
		local angle                = 360 / novae_per_ring

		-- Create each nova with increasing delays
		for i = 1, rings do
			for j = 1, novae_per_ring do
				Timers:CreateTimer(creation_delay * i, function()
					local chaos_variable = RandomInt(-15, 15)

					-- Might save this for a future update (makes a circle instead of a line)
					local location = target_loc + Vector(math.cos(math.rad((angle * j) + deviation + chaos_variable)), math.sin(math.rad((angle * j) + deviation + chaos_variable))) * (i * ring_distance)

					location.z = GetGroundHeight(location, nil)

					-- Apply particle effect
					local particle_nova_flower_fx = ParticleManager:CreateParticle(particle_nova_flower, PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleControl(particle_nova_flower_fx, 0, location)
					ParticleManager:SetParticleControl(particle_nova_flower_fx, 3, location)

					-- Start a timer for destruction
					Timers:CreateTimer(explosion_delay, function()
						-- Emit sound (let's just play it once per ring to not kill ears)
						if j == 1 then
							EmitSoundOnLocationWithCaster(location, sound_cast, caster)
						end

						-- Remove flower particle
						ParticleManager:DestroyParticle(particle_nova_flower_fx, false)
						ParticleManager:ReleaseParticleIndex(particle_nova_flower_fx)

						-- Apply explosion particle
						local particle_nova_fx = ParticleManager:CreateParticle(particle_nova, PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleControl(particle_nova_fx, 0, location)
						ParticleManager:SetParticleControl(particle_nova_fx, 1, Vector(damage_radius, damage_radius, damage_radius))
						ParticleManager:SetParticleControl(particle_nova_fx, 2, location)
						ParticleManager:ReleaseParticleIndex(particle_nova_fx)

						-- Find all enemies in radius
						local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
							location,
							nil,
							radius,
							DOTA_UNIT_TARGET_TEAM_ENEMY,
							DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
							DOTA_UNIT_TARGET_FLAG_NONE,
							FIND_ANY_ORDER,
							false)

						for _, enemy in pairs(enemies) do
							-- Deal damage to each
							if not enemy:IsMagicImmune() then
								local damageTable = {
									victim = enemy,
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
	local decFuncs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT }

	return decFuncs
end

function modifier_imba_frost_nova_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end

function modifier_imba_frost_nova_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow * (-1)
end

------------------------------------
-- STROKE OF FATE EXTEND MODIFIER --
------------------------------------

modifier_imba_frost_nova_handler = modifier_imba_frost_nova_handler or class({})

function modifier_imba_frost_nova_handler:IsHidden() return true end

function modifier_imba_frost_nova_handler:IsPurgable() return false end

function modifier_imba_frost_nova_handler:RemoveOnDeath() return false end

function modifier_imba_frost_nova_handler:DeclareFunctions()
	return { MODIFIER_EVENT_ON_ORDER }
end

function modifier_imba_frost_nova_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end

	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

------------------------------------------
--	FROST NOVA DEATH BLOSSOM TALENT		--
------------------------------------------

LinkLuaModifier("modifier_special_bonus_imba_lich_11", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_lich_11 = modifier_special_bonus_imba_lich_11 or class({})

function modifier_special_bonus_imba_lich_11:IsHidden() return true end

function modifier_special_bonus_imba_lich_11:IsPurgable() return false end

function modifier_special_bonus_imba_lich_11:RemoveOnDeath() return false end

function imba_lich_frost_nova:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_lich_11") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_lich_11") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_lich_11"), "modifier_special_bonus_imba_lich_11", {})
	end
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

		local nResult = UnitFilter(target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber())
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
	local cast_response = "lich_lich_ability_armor_0" .. math.random(1, 5)
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
	target:AddNewModifier(caster, ability, modifier_armor, { duration = armor_duration })
end

-- #5 Talent: Frost Armor adds a portion of the Lich's intelligence to the armor bonus
LinkLuaModifier("modifier_special_bonus_imba_lich_5", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_lich_5 = modifier_special_bonus_imba_lich_5 or class({})
function modifier_special_bonus_imba_lich_5:IsHidden() return true end

function modifier_special_bonus_imba_lich_5:IsPurgable() return false end

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
		local armor_bonus = math.floor(intelligence * self:GetParent():FindTalentValue("special_bonus_imba_lich_5") / 100)

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
	ParticleManager:SetParticleControl(self.particle_frost_armor_fx, 1, Vector(1, 1, 1))
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
	local decFuncs = { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED }

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
			modifier_debuff_handler = attacker:AddNewModifier(self.caster, self.ability, self.modifier_armor_debuff, { duration = self.frost_duration * (1 - attacker:GetStatusResistance()) })

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
	local decFuncs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT }

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
	local decFuncs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT }

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
		self.parent:AddNewModifier(self.caster, self.ability, self.modifier_disarm, { duration = self.disarm_duration * (1 - self.parent:GetStatusResistance()) })
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
	local state = { [MODIFIER_STATE_DISARMED] = true }
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
	local decFuncs = { MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_RESPAWN }

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

function modifier_imba_frost_armor_auto_cast:RemoveOnDeath() return false end

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
		local nResult = UnitFilter(target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber())
		return nResult
	end
end

function imba_lich_dark_ritual:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local cast_response = "lich_lich_ability_ritual_"
	local cast_response_nums = { "01", "02", "03", "04", "05", "07", "13" }
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
		local cast_response_number = cast_response_nums[math.random(1, 7)]
		EmitSoundOn(cast_response .. cast_response_number, caster)
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
		local mana_gained = creep_hp * mana_conversion_pct / 100
		caster:GiveMana(mana_gained)

		-- XP Overhead message
		local particleName = "particles/msg_fx/msg_xp.vpcf"
		local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)

		local digits = 0
		if mana_gained then
			digits = #tostring(mana_gained)
		end

		ParticleManager:SetParticleControl(particle, 1, Vector(9, mana_gained, 6))
		ParticleManager:SetParticleControl(particle, 2, Vector(1, digits + 1, 0))
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

		for _, creep in pairs(allied_creeps) do
			-- Give all nearby creeps the creep bonus modifier
			local modifier_creeps_handler = creep:AddNewModifier(caster, ability, modifier_creeps, {})

			if modifier_creeps_handler then
				-- For client interactions
				modifier_creeps_handler:SetStackCount(creep_hp)
			end
		end

		-- Divide target's XP bounty between all heroes in the AoE
		local xp_per_hero = creep_xp / #heroes

		for _, hero in pairs(heroes) do
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

	for _, hero in pairs(heroes) do
		-- Give heroes appropriate modifier,
		if ally_creep then
			hero:AddNewModifier(caster, ability, modifier_allied_sacrifice, { duration = sacrifice_duration })

			-- Add ally particle effect
			local particle_sacrifice_allies_fx = ParticleManager:CreateParticle(particle_sacrifice_allies, PATTACH_CUSTOMORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(particle_sacrifice_allies_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle_sacrifice_allies_fx, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle_sacrifice_allies_fx)
		else
			hero:AddNewModifier(caster, ability, modifier_enemy_sacrifice, { duration = sacrifice_duration })

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
			local adjusted_hp = self.parent:GetMaxHealth() + self:GetStackCount() * self.creeps_bonus_hp_pct / 100
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
	local decFuncs = { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE }

	return decFuncs
end

function modifier_imba_dark_ritual_creeps:GetModifierAttackSpeedBonus_Constant()
	return self.creeps_bonus_as
end

function modifier_imba_dark_ritual_creeps:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount() * self.creeps_bonus_dmg_pct / 100
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
	local decFuncs = { MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE }

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
	local decFuncs = { MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE }

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
		target:AddNewModifier(caster, ability, "modifier_imba_chain_frost_talent_buff", { duration = buff_duration })
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

	-- If the caster has Scepter (changed to being Level 25 instead now), increase bounces to infinity (well, almost, but you get the point)
	if self:GetCaster():GetLevel() >= 25 then
		num_bounces = num_bounces + 99999
	end

	-- Launch the projectile
	local chain_frost_projectile = {
		Target = target,
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
		ExtraData = { bounces_left = num_bounces, current_projectile_speed = projectile_base_speed, main_chain_frost = true, counter = 0 }
	}

	ProjectileManager:CreateTrackingProjectile(chain_frost_projectile)
end

function imba_lich_chain_frost:OnProjectileHit_ExtraData(target, location, extradata)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	--	local sound_hit = "Hero_Lich.ChainFrostImpact.Creep"
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

			-- Remove the current enemy target from the table of possible targets (as well as Undying Zombies)
			for i = #enemies, 1, -1 do
				if enemies[i] ~= nil and (target == enemies[i] or enemies[i]:GetName() == "npc_dota_unit_undying_zombie") then
					table.remove(enemies, i)
					--break
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

			-- -- Add a check to heavily reduce bounces if near fountain for scepter ult to prevent massive chaining lag
			-- if self:GetCaster():GetLevel() >= 25 and IsNearFountain(enemies[1]:GetAbsOrigin(), 1200) then
			-- bounces_left = bounces_left - 10000
			-- end

			local chain_frost_projectile
			chain_frost_projectile = {
				Target = bounce_target,
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
				ExtraData = { bounces_left = bounces_left, current_projectile_speed = projectile_speed, main_chain_frost = true, counter = extradata.counter + 1 }
			}

			ProjectileManager:CreateTrackingProjectile(chain_frost_projectile)

			-- If there is more than one enemy and the caster has #7 Talent, throw smaller chain frosts at them
			if caster:HasTalent("special_bonus_imba_lich_7") then
				local projectiles_launched = 0

				for i = 2, #enemies do
					-- Check if there are still more projectiles that should be launched
					if projectiles_launched < bonus_projectiles then
						-- Define and launch a smaller frost
						chain_frost_projectile = {
							Target = enemies[i],
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
							ExtraData = { main_chain_frost = false, counter = extradata.counter + 1 }
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
		damage = damage * projectiles_damage_pct / 100
	end

	-- If target has Linken's Sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if extradata.counter == 0 and target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- If the target became spell immune, do nothing
	if target:IsMagicImmune() then
		return nil
	end

	-- Damage the target
	local damageTable = {
		victim = target,
		damage = damage + (self:GetSpecialValueFor("bonus_jump_damage") * extradata.counter),
		damage_type = DAMAGE_TYPE_MAGICAL,
		attacker = caster,
		ability = ability
	}

	ApplyDamage(damageTable)

	-- Apply slow
	target:AddNewModifier(caster, ability, modifier_slow, { duration = slow_duration * (1 - target:GetStatusResistance()) })

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
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
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
		ParticleManager:SetParticleControl(particle_orb_fx, 2, Vector(1, 0, 0))
		ParticleManager:SetParticleControl(particle_orb_fx, 3, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_orb_fx, 5, Vector(self.parent:GetHullRadius() * 3, 1, 1))
		self:AddParticle(particle_orb_fx, false, false, -1, false, false)
	end
end

function modifier_imba_chain_frost_talent_buff:DeclareFunctions()
	return { MODIFIER_EVENT_ON_TAKEDAMAGE }
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

-----------------------------------
--			FROST SHIELD         --
-----------------------------------

imba_lich_frost_shield = class({})

LinkLuaModifier("modifier_imba_lich_frost_shield", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_lich_frost_shield_slow", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_lich_9", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)

function imba_lich_frost_shield:GetAbilityTextureName()
	return "lich_frost_shield"
end

function imba_lich_frost_shield:OnSpellStart()
	if not IsServer() then return end

	-- IMBAfication: Remnants of Ice Armor
	local intellect   = self:GetCaster():GetIntellect()
	local armor_bonus = intellect * self:GetSpecialValueFor("int_armor_pct") / 100

	EmitSoundOn("Hero_Lich.IceAge", self:GetCursorTarget())

	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_lich_frost_shield", { duration = self:GetSpecialValueFor("duration") }):SetStackCount(armor_bonus)
end

--------------------------------------
--		FROST SHIELD MODIFIER		--
--------------------------------------

modifier_imba_lich_frost_shield = class({})

function modifier_imba_lich_frost_shield:OnCreated()
	-- Establish variables
	self.ability           = self:GetAbility()
	self.caster            = self:GetCaster()
	self.parent            = self:GetParent()

	-- AbilitySpecial
	self.damage_reduction  = self.ability:GetSpecialValueFor("damage_reduction")
	-- self.movement_slow		= self.ability:GetSpecialValueFor("movement_slow")
	self.slow_duration     = self.ability:GetSpecialValueFor("slow_duration")
	self.damage            = self.ability:GetSpecialValueFor("damage")
	self.interval          = self.ability:GetSpecialValueFor("interval")
	self.radius            = self.ability:GetSpecialValueFor("radius")
	self.duration          = self.ability:GetSpecialValueFor("duration")
	self.cold_front_stacks = self.ability:GetSpecialValueFor("cold_front_stacks")

	if self.caster:HasTalent("special_bonus_imba_lich_9") then
		self.hp_regen = self.caster:FindTalentValue("special_bonus_imba_lich_9")

		if self.parent:IsBuilding() then
			self.hp_regen = self.hp_regen * (self.caster:FindTalentValue("special_bonus_imba_lich_9", "building_efficiency") / 100)
		end
	end

	-- The remainder of the code only needs to be run server-side
	if not IsServer() then return end

	-- Add the "encircling orb" particle
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_ice_age.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(self.particle, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
	self:AddParticle(self.particle, false, false, -1, false, false)

	-- Add the frost armor particle
	self.particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_frost_armor.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
	self:AddParticle(self.particle2, false, false, -1, false, false)

	-- Doesn't implement the innate 60 second cooldown on voicelines so percentage chance is reduced from 75% to 60%
	if self.caster:GetName() == "npc_dota_hero_lich" and RollPercentage(60) then
		self.caster:EmitSound("lich_lich_ability_armor_0" .. math.random(1, 5))
	end

	-- Start the damage emittance
	self:StartIntervalThink(self.interval)
end

function modifier_imba_lich_frost_shield:OnRefresh()
	self:OnCreated()
end

function modifier_imba_lich_frost_shield:OnIntervalThink()
	if not IsServer() then return end

	-- Pulse particle
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_ice_age_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle, 2, Vector(self.radius, self.radius, self.radius))

	ParticleManager:ReleaseParticleIndex(particle)

	-- Emit tick sound
	self.parent:EmitSound("Hero_Lich.IceAge.Tick")

	-- Get a table of all the enemies in radius of Frost Shield's pulse
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
		self.parent:GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	for _, enemy in pairs(enemies) do
		enemy:EmitSound("Hero_Lich.IceAge.Damage")

		-- Deal damage
		local damageTable = {
			victim = enemy,
			attacker = self.caster,
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			ability = self.ability
		}

		ApplyDamage(damageTable)

		-- Apply the slow modifier
		enemy:AddNewModifier(self.caster, self.ability, "modifier_imba_lich_frost_shield_slow", { duration = self.slow_duration * (1 - enemy:GetStatusResistance()) })

		IncreaseStacksColdFront(self.caster, enemy, self.cold_front_stacks)
	end
end

function modifier_imba_lich_frost_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end

function modifier_imba_lich_frost_shield:GetModifierIncomingPhysicalDamage_Percentage(keys)
	return self.damage_reduction * (-1)
end

function modifier_imba_lich_frost_shield:GetModifierPhysicalArmorBonus()
	return self:GetStackCount()
end

function modifier_imba_lich_frost_shield:GetModifierConstantHealthRegen()
	return self.hp_regen or 0
end

--------------------------------------
--		FROST SHIELD SLOW MODIFIER	--
--------------------------------------

modifier_imba_lich_frost_shield_slow = class({})

function modifier_imba_lich_frost_shield_slow:GetHeroEffectName()
	return "particles/units/heroes/hero_lich/lich_ice_age_debuff.vpcf"
end

function modifier_imba_lich_frost_shield_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_lich_ice_age.vpcf"
end

function modifier_imba_lich_frost_shield_slow:OnCreated()
	-- Establish variables
	self.ability       = self:GetAbility()

	-- AbilitySpecial
	self.movement_slow = self.ability:GetSpecialValueFor("movement_slow")
end

function modifier_imba_lich_frost_shield_slow:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }

	return decFuncs
end

function modifier_imba_lich_frost_shield_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow * (-1)
end

------------------------------------------
--	FROST SHIELD HEALTH REGEN TALENT	--
------------------------------------------

modifier_special_bonus_imba_lich_9 = class({})

function modifier_special_bonus_imba_lich_9:IsHidden() return true end

function modifier_special_bonus_imba_lich_9:IsPurgable() return false end

function modifier_special_bonus_imba_lich_9:RemoveOnDeath() return false end

function imba_lich_frost_shield:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_lich_9") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_lich_9") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_lich_9", {})
	end
end

-----------------------------------
--			SINISTER GAZE        --
-----------------------------------

imba_lich_sinister_gaze = class({})

LinkLuaModifier("modifier_imba_lich_sinister_gaze_handler", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_lich_sinister_gaze", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_lich_sinister_gaze_bonus_health", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)

function imba_lich_sinister_gaze:GetIntrinsicModifierName()
	return "modifier_imba_lich_sinister_gaze_handler"
end

function imba_lich_sinister_gaze:GetAbilityTextureName()
	return "lich_sinister_gaze"
end

function imba_lich_sinister_gaze:GetBehavior()
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetBehavior(self)
	else
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	end
end

function imba_lich_sinister_gaze:GetAOERadius()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("aoe_scepter")
	end
end

function imba_lich_sinister_gaze:GetChannelTime()
	return self:GetCaster():GetModifierStackCount("modifier_imba_lich_sinister_gaze_handler", self:GetCaster()) / 100
end

function imba_lich_sinister_gaze:CastFilterResultTarget(target)
	if self:GetCaster():GetTeamNumber() == target:GetTeamNumber() and target:IsConsideredHero() then
		return UF_FAIL_CUSTOM
	end

	return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, self:GetCaster():GetTeamNumber())
end

function imba_lich_sinister_gaze:GetCustomCastErrorTarget(target)
	return "Ability Can't Target Allied Heroes"
end

function imba_lich_sinister_gaze:GetCastAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_3
end

function imba_lich_sinister_gaze:OnSpellStart()
	self.caster = self:GetCaster()
	self.target = self:GetCursorTarget()

	if not self.caster:HasScepter() and self.target:TriggerSpellAbsorb(self) then
		self.caster:Interrupt()
		return
	end

	-- Doesn't implement the innate 60 second cooldown on voicelines so percentage chance is reduced from 75% to 40%
	if self.caster:GetName() == "npc_dota_hero_lich" and RollPercentage(40) then
		self.caster:EmitSound("lich_lich_ability_ritual_0" .. math.random(2, 5))
	end

	-- AbilitySpecial
	self.duration                   = self:GetSpecialValueFor("duration")
	self.soul_consumption_duration  = self:GetSpecialValueFor("soul_consumption_duration")
	self.retaliatory_chains_dmg_pct = self:GetSpecialValueFor("retaliatory_chains_dmg_pct")
	self.sacrifice_mana_pct         = self:GetSpecialValueFor("sacrifice_mana_pct")
	self.sacrifice_health_pct       = self:GetSpecialValueFor("sacrifice_health_pct")
	self.cold_front_stacks          = self:GetSpecialValueFor("cold_front_stacks")

	self.caster:EmitSound("Hero_Lich.SinisterGaze.Cast")

	if not self:GetCaster():HasScepter() then
		self.target:EmitSound("Hero_Lich.SinisterGaze.Target")

		self.target:AddNewModifier(self:GetCaster(), self, "modifier_imba_lich_sinister_gaze", { duration = self:GetChannelTime() })
		self.target:AddNewModifier(self:GetCaster(), nil, "modifier_truesight", { duration = self:GetChannelTime() })

		if self.target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
			IncreaseStacksColdFront(self.caster, self.target, self.cold_front_stacks)
		end
	else
		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("aoe_scepter"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false)

		if #units == 0 then
			self.end_channel = true
		else
			for _, unit in pairs(units) do
				if unit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() or (unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() and unit:IsCreep() and not unit:IsConsideredHero()) then
					if _ == 1 then
						self.target = unit
					end

					unit:AddNewModifier(self:GetCaster(), self, "modifier_imba_lich_sinister_gaze", { duration = self:GetChannelTime() })
					unit:AddNewModifier(self:GetCaster(), nil, "modifier_truesight", { duration = self:GetChannelTime() })

					if self.target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
						IncreaseStacksColdFront(self.caster, unit, self.cold_front_stacks)
					end
				end
			end
		end
	end
end

function imba_lich_sinister_gaze:OnChannelThink()
	if self.end_channel then
		self:EndChannel(false)
		self.end_channel = nil
	end
end

function imba_lich_sinister_gaze:OnChannelFinish(bInterrupted)
	if not IsServer() then return end

	-- IMBAfication: Remnants of Sacrifice (gain mana and kill creeps with full channel; gains health from allied creeps)
	if not bInterrupted and self.target and self.target:IsCreep() and not self.target:IsRoshan() then -- Extrenuous Roshan line in case someone ruins targetting
		local creep_health = self.target:GetHealth()
		local mana_gained = creep_health * (self.sacrifice_mana_pct / 100)
		local health_gained = creep_health * (self.sacrifice_health_pct / 100)

		self.caster:GiveMana(mana_gained)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self.caster, mana_gained, nil)

		if self.target:GetTeam() == self.caster:GetTeam() then
			self.caster:Heal(health_gained, self.caster)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.caster, health_gained, nil)
		end

		self.target:Kill(self, self.caster)
	else
		Timers:CreateTimer(FrameTime(), function()
			if self.target then
				-- IMBAfication: Soul Consumption
				if not self.target:IsAlive() and not self.target:IsReincarnating() and (self.target:IsRealHero() or self.target:IsClone()) then
					local consumption_health = self.target:GetMaxHealth()

					self.caster:AddNewModifier(self.caster, self, "modifier_imba_lich_sinister_gaze_bonus_health", { duration = self.soul_consumption_duration }):SetStackCount(consumption_health)

					self.caster:CalculateStatBonus(true)

					-- Sure takes a while to add that max health through the modifier...
					-- Timers:CreateTimer(0.5, function()
					self.caster:Heal(consumption_health, self.caster)
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.caster, consumption_health, nil)
					-- end)

					-- IMBAfication: Retaliatory Chains
				elseif not self.caster:IsAlive() and not self.target:IsReincarnating() then
					local retaliation_damage = self.caster:GetMaxHealth() * (self.retaliatory_chains_dmg_pct / 100)

					local damageTable = {
						victim = self.target,
						damage = retaliation_damage,
						damage_type = DAMAGE_TYPE_PURE,
						damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
						DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
						attacker = self.caster,
						ability = self
					}
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self.target, retaliation_damage, nil)

					ApplyDamage(damageTable)
				end
			end
		end)
	end

	Timers:CreateTimer(FrameTime(), function()
		if self.target and not self.target:IsAlive() and (not self.target.IsReincarnating or (self.target.IsReincarnating and not self.target:IsReincarnating())) then
			local particle_name = ""

			if self.target:GetTeam() == self.caster:GetTeam() then
				particle_name = "particles/units/heroes/hero_lich/lich_dark_ritual.vpcf"
			else
				particle_name = "particles/hero/lich/lich_dark_ritual_enemy.vpcf"
			end

			local particle = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN_FOLLOW, self.caster)
			ParticleManager:SetParticleControlEnt(particle, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle)
		end
	end)

	self.caster:StopSound("Hero_Lich.SinisterGaze.Cast")

	if self.target then
		self.target:StopSound("Hero_Lich.SinisterGaze.Target")

		if self.target:HasModifier("modifier_imba_lich_sinister_gaze") then
			self.target:RemoveModifierByName("modifier_imba_lich_sinister_gaze")
		end
	end
end

------------------------------------
-- SINISTER GAZE HANDLER MODIFIER --
------------------------------------

modifier_imba_lich_sinister_gaze_handler = class({})

function modifier_imba_lich_sinister_gaze_handler:IsHidden() return true end

function modifier_imba_lich_sinister_gaze_handler:IsPurgable() return false end

-- Grimstroke Soulbind exception (without this line the modifier disappears -_-)
function modifier_imba_lich_sinister_gaze_handler:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_lich_sinister_gaze_handler:DeclareFunctions()
	return { MODIFIER_EVENT_ON_ABILITY_EXECUTED }
end

-- Going to use this hacky method to determine channel time on UI
-- During the brief time before the ability actually casts, record the target's status resistance * 100 into its intrinsic modifier, then use that divided by 100 as the channel time
function modifier_imba_lich_sinister_gaze_handler:OnAbilityExecuted(keys)
	if not IsServer() then return end

	if keys.ability == self:GetAbility() and keys.target then
		if keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			if not keys.target:IsCreep() then
				self:SetStackCount(self:GetAbility():GetSpecialValueFor("duration") * (1 - keys.target:GetStatusResistance()) * 100)
			else
				self:SetStackCount(self:GetAbility():GetSpecialValueFor("duration") * (100 - self:GetAbility():GetSpecialValueFor("creep_channel_reduction")) / 100 * (1 - keys.target:GetStatusResistance()) * 100)
			end
		else
			if not keys.target:IsCreep() then
				self:SetStackCount(self:GetAbility():GetSpecialValueFor("duration") * 100)
			else
				self:SetStackCount(self:GetAbility():GetSpecialValueFor("duration") * (100 - self:GetAbility():GetSpecialValueFor("creep_channel_reduction")))
			end
		end
	else
		self:SetStackCount(self:GetAbility():GetSpecialValueFor("duration") * 100)
	end
end

-----------------------------------
--	SINISTER GAZE MODIFIER 		 --
-----------------------------------

modifier_imba_lich_sinister_gaze = modifier_imba_lich_sinister_gaze or class({})

function modifier_imba_lich_sinister_gaze:IgnoreTenacity() return true end

function modifier_imba_lich_sinister_gaze:GetStatusEffectName()
	return "particles/status_fx/status_effect_lich_gaze.vpcf"
end

function modifier_imba_lich_sinister_gaze:OnCreated()
	self.ability     = self:GetAbility()
	self.caster      = self:GetCaster()
	self.parent      = self:GetParent()

	self.destination = self.ability:GetSpecialValueFor("destination") + self.caster:FindTalentValue("special_bonus_imba_lich_10")
	self.distance    = CalcDistanceBetweenEntityOBB(self:GetCaster(), self:GetParent()) * (self.destination / 100)
	self.mana_drain  = self.ability:GetSpecialValueFor("mana_drain")

	if not IsServer() then return end

	self.status_resistance = self:GetParent():GetStatusResistance()

	self.duration          = self:GetRemainingTime()
	self.interval          = 0.1

	if self.parent.GetMana then
		self.current_mana = self.parent:GetMana()
	else
		self.current_mana = 0
	end

	self.mana_per_interval = (self.current_mana * self.mana_drain / 100) / (self.duration / self.interval)

	-- This is so errors don't pop up if the spell gets reflected
	if self.caster:GetName() == "npc_dota_hero_lich" then
		-- Particle attachments aren't perfect but they're good enough...I guess
		-- Add the gaze particles
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_gaze.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(self.particle, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.particle, 2, self.caster, PATTACH_POINT_FOLLOW, "attach_portrait", self.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.particle, 3, self.caster, PATTACH_ABSORIGIN_FOLLOW, nil, self.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.particle, 10, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		self:AddParticle(self.particle, false, false, -1, false, false)

		-- Add the red eyes particle
		self.particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_gaze_eyes.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(self.particle2, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_eye_l", self.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.particle2, 2, self.caster, PATTACH_POINT_FOLLOW, "attach_eye_r", self.caster:GetAbsOrigin(), true)
		self:AddParticle(self.particle2, false, false, -1, false, false)
	end

	self.parent:Interrupt()
	self.parent:MoveToNPC(self.caster)

	self:StartIntervalThink(self.interval)
end

function modifier_imba_lich_sinister_gaze:OnIntervalThink()
	if not self:GetCaster() or not self:GetAbility() or not self:GetAbility():IsChanneling() then
		self:Destroy()
	else
		if self.parent.ReduceMana then
			self.parent:ReduceMana(self.mana_per_interval)
		end

		if self.caster.GiveMana then
			self.caster:GiveMana(self.mana_per_interval)
		end
	end
end

function modifier_imba_lich_sinister_gaze:OnDestroy()
	if not IsServer() then return end

	self.parent:Interrupt()

	-- Why 100? IDK random number
	GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(), 100, false)

	if self.ability:IsChanneling() and not self:GetCaster():HasScepter() then
		self.ability:EndChannel(false)
		self.caster:MoveToPositionAggressive(self.caster:GetAbsOrigin())
	end
end

function modifier_imba_lich_sinister_gaze:CheckState()
	return {
		[MODIFIER_STATE_HEXED] = true, -- Using this as substitute for Fear which isn't a provided state
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	}
end

function modifier_imba_lich_sinister_gaze:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_LIMIT }
end

function modifier_imba_lich_sinister_gaze:GetModifierMoveSpeed_Limit()
	if not IsServer() then return end

	if not self:GetCaster():HasScepter() then
		return self.distance / (self.ability:GetChannelTime() * (1 - math.min(self.status_resistance, 0.9999))) -- If target has 100% status resistance, make non-divide by 0 so target zips to caster
	else
		return self.distance / self.ability:GetChannelTime()
	end
end

-------------------------------------------
--	SINISTER GAZE MODIFIER BONUS HEALTH	 --
-------------------------------------------

modifier_imba_lich_sinister_gaze_bonus_health = class({})

function modifier_imba_lich_sinister_gaze_bonus_health:IsDebuff() return false end

function modifier_imba_lich_sinister_gaze_bonus_health:IsPurgable() return false end

function modifier_imba_lich_sinister_gaze_bonus_health:RemoveOnDeath() return false end

function modifier_imba_lich_sinister_gaze_bonus_health:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_lich_sinister_gaze_bonus_health:DeclareFunctions()
	return { MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS }
end

function modifier_imba_lich_sinister_gaze_bonus_health:GetModifierExtraHealthBonus()
	return self:GetStackCount()
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_lich_10", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_lich_6", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_lich_1", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_lich_7", "components/abilities/heroes/hero_lich", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_lich_10 = modifier_special_bonus_imba_lich_10 or class({})
modifier_special_bonus_imba_lich_6 = modifier_special_bonus_imba_lich_6 or class({})
modifier_special_bonus_imba_lich_1 = modifier_special_bonus_imba_lich_1 or class({})
modifier_special_bonus_imba_lich_7 = modifier_special_bonus_imba_lich_7 or class({})

function modifier_special_bonus_imba_lich_10:IsHidden() return true end

function modifier_special_bonus_imba_lich_10:IsPurgable() return false end

function modifier_special_bonus_imba_lich_10:RemoveOnDeath() return false end

function modifier_special_bonus_imba_lich_6:IsHidden() return true end

function modifier_special_bonus_imba_lich_6:IsPurgable() return false end

function modifier_special_bonus_imba_lich_6:RemoveOnDeath() return false end

function modifier_special_bonus_imba_lich_1:IsHidden() return true end

function modifier_special_bonus_imba_lich_1:IsPurgable() return false end

function modifier_special_bonus_imba_lich_1:RemoveOnDeath() return false end

function modifier_special_bonus_imba_lich_7:IsHidden() return true end

function modifier_special_bonus_imba_lich_7:IsPurgable() return false end

function modifier_special_bonus_imba_lich_7:RemoveOnDeath() return false end
