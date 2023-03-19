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
--     sercankd, 17.05.2017

local LinkedModifiers = {}
-------------------------------------------
--			     Berserker's Call            --
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers, {
	["modifier_imba_berserkers_call_buff_armor"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_berserkers_call_debuff_cmd"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers, {
	["modifier_imba_berserkers_call_talent"] = LUA_MODIFIER_MOTION_NONE,
})

imba_axe_berserkers_call = imba_axe_berserkers_call or class({})

function imba_axe_berserkers_call:OnAbilityPhaseStart()
	if IsServer() then
		EmitSoundOn("Hero_Axe.BerserkersCall.Start", self:GetCaster())
	end

	return true
end

function imba_axe_berserkers_call:OnSpellStart()
	local caster  = self:GetCaster()
	local ability = self

	-- Ability specials
	local radius  = ability:GetSpecialValueFor("radius")
	self:GetCaster():EmitSound("Hero_Axe.Berserkers_Call")

	-- On cast, hit 1 or more units
	local responses_1_or_more_enemies = "axe_axe_ability_berserk_0" .. math.random(1, 9)
	-- On cast, hit no unit
	local responses_zero_enemy = "axe_axe_anger_0" .. math.random(1, 3)

	local particle = ParticleManager:CreateParticle("particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster, caster)
	ParticleManager:SetParticleControl(particle, 2, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(particle)

	-- find targets
	local enemies_in_radius = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	for _, target in pairs(enemies_in_radius) do
		if target:IsCreep() then
			-- This line works for lane/neutral creeps but not for player-controlled units (vanilla and custom included)
			target:SetForceAttackTarget(caster)

			-- This line works for player-controlled units
			target:MoveToTargetToAttack(caster)

			-- Essentially, it seems like both of these lines are required
		else
			target:Stop()
			target:Interrupt()

			local newOrder = {
				UnitIndex = target:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = caster:entindex()
			}

			ExecuteOrderFromTable(newOrder)
		end
		self:AddCalledTarget(target)
		target:AddNewModifier(caster, self, "modifier_imba_berserkers_call_debuff_cmd", { duration = ability:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance()) })
	end

	-- if enemies table is empty play random responses_zero_enemy
	if next(enemies_in_radius) == nil then
		self:GetCaster():EmitSound(responses_zero_enemy)
	else
		self:GetCaster():EmitSound(responses_1_or_more_enemies)
	end

	caster:AddNewModifier(caster, self, "modifier_imba_berserkers_call_buff_armor", { duration = ability:GetSpecialValueFor("duration") })

	if caster:HasTalent("special_bonus_imba_axe_2") then
		local talent_duration = caster:FindTalentValue("special_bonus_imba_axe_2")
		caster:AddNewModifier(caster, self, "modifier_imba_berserkers_call_talent", { duration = ability:GetSpecialValueFor("duration") + talent_duration })
	end
end

function imba_axe_berserkers_call:GetCastAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_1
end

function imba_axe_berserkers_call:IsHidden()
	return false
end

function imba_axe_berserkers_call:IsHiddenWhenStolen()
	return false
end

-- Helper functions for applying Battle Hunger to enemies affected by Berserker's Call
function imba_axe_berserkers_call:AddCalledTarget(target)
	if not self.called_targets then
		self.called_targets = {}
	end

	self.called_targets[target:entindex()] = target
end

function imba_axe_berserkers_call:RemoveCalledTarget(target)
	if not self.called_targets then
		return nil
	end

	self.called_targets[target:entindex()] = nil
end

function imba_axe_berserkers_call:GetCalledUnits()
	if not self.called_targets then
		return nil
	end

	return self.called_targets
end

-------------------------------------------
-- Berserker's Call caster modifier
-------------------------------------------

modifier_imba_berserkers_call_buff_armor = modifier_imba_berserkers_call_buff_armor or class({})
function modifier_imba_berserkers_call_buff_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_imba_berserkers_call_buff_armor:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_imba_berserkers_call_buff_armor:OnCreated()
	if not IsServer() then return end

	local caster_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster(), self:GetCaster())
	ParticleManager:SetParticleControl(caster_particle, 2, Vector(0, 0, 0))
	ParticleManager:ReleaseParticleIndex(caster_particle)
	return true
end

function modifier_imba_berserkers_call_buff_armor:GetStatusEffectName()
	return "particles/status_fx/status_effect_gods_strength.vpcf"
end

function modifier_imba_berserkers_call_buff_armor:IsPurgable()
	return false
end

function modifier_imba_berserkers_call_buff_armor:IsBuff()
	return true
end

function modifier_imba_berserkers_call_buff_armor:RemoveOnDeath()
	return true
end

-------------------------------------------
-- Berserker's Call caster talent modifier
-------------------------------------------

modifier_imba_berserkers_call_talent = modifier_imba_berserkers_call_talent or class({})

function modifier_imba_berserkers_call_talent:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_ATTACKED
	}
end

function modifier_imba_berserkers_call_talent:GetModifierPhysicalArmorBonus()
	local stack_count = self:GetCaster():GetModifierStackCount("modifier_imba_berserkers_call_talent", self)
	return stack_count
end

function modifier_imba_berserkers_call_talent:OnAttacked(keys)
	if IsServer() then
		if keys.target == self:GetParent() then
			if self:GetCaster():HasModifier("modifier_imba_berserkers_call_buff_armor") then
				local stack_count = self:GetCaster():GetModifierStackCount("modifier_imba_berserkers_call_talent", self)
				self:GetParent():SetModifierStackCount("modifier_imba_berserkers_call_talent", self, stack_count + 1)
			end
		end
	end
end

function modifier_imba_berserkers_call_talent:IsBuff()
	return true
end

function modifier_imba_berserkers_call_talent:IsHidden()
	return false
end

function modifier_imba_berserkers_call_talent:IsPurgable()
	return false
end

-------------------------------------------
-- Berserker's Call enemy modifier
-------------------------------------------

modifier_imba_berserkers_call_debuff_cmd = modifier_imba_berserkers_call_debuff_cmd or class({})

function modifier_imba_berserkers_call_debuff_cmd:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.bonus_as = self:GetAbility():GetSpecialValueFor("bonus_as")
end

function modifier_imba_berserkers_call_debuff_cmd:CheckState()
	return { [MODIFIER_STATE_COMMAND_RESTRICTED] = true }
end

function modifier_imba_berserkers_call_debuff_cmd:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_imba_berserkers_call_debuff_cmd:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as + self:GetCaster():FindTalentValue("special_bonus_imba_axe_5")
end

function modifier_imba_berserkers_call_debuff_cmd:OnDeath(event)
	if IsServer() then
		-- If Axe dies, remove this modifier.
		if event.unit == self:GetCaster() then
			self:Destroy()
		end
	end
end

function modifier_imba_berserkers_call_debuff_cmd:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()

		if parent:IsCreep() then
			parent:SetForceAttackTarget(nil)
		end

		if ability and ability.RemoveCalledTarget then
			ability:RemoveCalledTarget(parent)
		end
	end
end

function modifier_imba_berserkers_call_debuff_cmd:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

function modifier_imba_berserkers_call_debuff_cmd:StatusEffectPriority()
	return 10
end

function modifier_imba_berserkers_call_debuff_cmd:IsHidden()
	return false
end

function modifier_imba_berserkers_call_debuff_cmd:IsDebuff()
	return true
end

function modifier_imba_berserkers_call_debuff_cmd:IsPurgable()
	return false
end

----------------------------------------------------------------------------------------------------


-------------------------------------------
-- Battle Hunger
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers, {
	["modifier_imba_battle_hunger_buff_haste"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_battle_hunger_debuff_dot"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_battle_hunger_debuff_cmd"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_battle_hunger_debuff_deny"] = LUA_MODIFIER_MOTION_NONE,
})

imba_axe_battle_hunger = imba_axe_battle_hunger or class({})

function imba_axe_battle_hunger:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		-- Self-cast if we have the talent and are currently Berserker's Calling
		if caster == target and caster:HasTalent("special_bonus_imba_axe_3") and caster:HasModifier("modifier_imba_berserkers_call_buff_armor") then
			return UF_SUCCESS
		end
		return UnitFilter(target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber())
	end
end

--Do the battle hunger animation
function imba_axe_battle_hunger:GetCastAnimation()
	return (ACT_DOTA_OVERRIDE_ABILITY_2)
end

function imba_axe_battle_hunger:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
end

function imba_axe_battle_hunger:GetAOERadius()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("scepter_range")
	end

	return 0
end

function imba_axe_battle_hunger:OnAbilityPhaseStart()
	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_battle_hunger_cast.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster(), self:GetCaster())
	ParticleManager:SetParticleControlEnt(cast_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_particle)

	return true
end

function imba_axe_battle_hunger:OnSpellStart()
	local caster          = self:GetCaster()
	local target          = self:GetCursorTarget()
	local ability         = self
	local random_response = "axe_axe_ability_battlehunger_0" .. math.random(1, 3)

	caster:EmitSound(random_response)

	if caster ~= target then
		if caster:HasScepter() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), self:GetCursorPosition(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

			for _, enemy in pairs(enemies) do
				enemy:EmitSound("Hero_Axe.Battle_Hunger")
				self:ApplyBattleHunger(caster, enemy)
			end
		else
			-- If the target possesses a ready Linken's Sphere, do nothing
			if target:GetTeamNumber() ~= caster:GetTeamNumber() then
				if target:TriggerSpellAbsorb(ability) then
					return nil
				end
			end

			target:EmitSound("Hero_Axe.Battle_Hunger")
			self:ApplyBattleHunger(caster, target)
		end
		-- Self-cast with the talent (the cast permission is checked in CastFilterResultTarget)
	else
		caster:EmitSound("Hero_Axe.Battle_Hunger")

		local berserkers_call = caster:FindAbilityByName("imba_axe_berserkers_call")
		if not berserkers_call then
			return
		end

		local berserkers_call_modifier = "modifier_imba_berserkers_call_debuff_cmd"
		local called_units = berserkers_call:GetCalledUnits()

		-- Apply Battle Hunger to all called targets, regardless of their distance
		for entindex, unit in pairs(called_units) do
			if unit:HasModifier(berserkers_call_modifier) then
				self:ApplyBattleHunger(caster, unit)
			end
		end
	end
end

function imba_axe_battle_hunger:ApplyBattleHunger(caster, target)
	local caster_modifier = "modifier_imba_battle_hunger_buff_haste"
	local target_modifier = "modifier_imba_battle_hunger_debuff_dot"
	local duration = self:GetSpecialValueFor("duration")

	if not caster:HasModifier(caster_modifier) then
		caster:AddNewModifier(caster, self, caster_modifier, {})
		caster:SetModifierStackCount(caster_modifier, self, 1)
	else
		if not target:HasModifier(target_modifier) then
			local stack_count = caster:GetModifierStackCount(caster_modifier, self)
			caster:SetModifierStackCount(caster_modifier, self, stack_count + 1)
		end
	end

	-- Roshan Battle Hunger doesn't pause due to no damage done, sorry, no cheesing
	-- feel free to cast on creeps, though
	if target:IsRoshan() then
		target:AddNewModifier(caster, self, target_modifier, { duration = duration * (1 - target:GetStatusResistance()), no_pause = true })
	else
		target:AddNewModifier(caster, self, target_modifier, { duration = duration * (1 - target:GetStatusResistance()), no_pause = false })
	end
end

-------------------------------------------
-- Battle Hunger caster modifier
-------------------------------------------

modifier_imba_battle_hunger_buff_haste = modifier_imba_battle_hunger_buff_haste or class({})

function modifier_imba_battle_hunger_buff_haste:OnCreated()
	self.speed_bonus = self:GetAbility():GetSpecialValueFor("speed_bonus")
end

function modifier_imba_battle_hunger_buff_haste:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_imba_battle_hunger_buff_haste:GetModifierMoveSpeedBonus_Percentage()
	return self.speed_bonus * self:GetStackCount()
end

function modifier_imba_battle_hunger_buff_haste:IsHidden()
	return false
end

function modifier_imba_battle_hunger_buff_haste:IsPurgable()
	return false
end

-------------------------------------------
-- Battle Hunger enemy modifier
-------------------------------------------

modifier_imba_battle_hunger_debuff_dot = modifier_imba_battle_hunger_debuff_dot or class({})

function modifier_imba_battle_hunger_debuff_dot:GetStatusEffectName()
	return "particles/status_fx/status_effect_battle_hunger.vpcf"
end

function modifier_imba_battle_hunger_debuff_dot:StatusEffectPriority()
	return 9
end

function modifier_imba_battle_hunger_debuff_dot:IsDebuff()
	return true
end

function modifier_imba_battle_hunger_debuff_dot:IsPurgable()
	return true
end

function modifier_imba_battle_hunger_debuff_dot:OnCreated(params)
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.tick_rate = 1 --once per second
	self.cmd_restrict_modifier = "modifier_imba_battle_hunger_debuff_cmd"
	self.deny_allow_modifier = "modifier_imba_battle_hunger_debuff_deny"
	self.damage_over_time = self:GetAbility():GetSpecialValueFor("damage")
	self.maddening_chance_pct = self:GetAbility():GetSpecialValueFor("maddening_chance_pct")
	self.max_maddening_duration = self:GetAbility():GetSpecialValueFor("max_maddening_duration")
	self.maddening_buffer_distance = self:GetAbility():GetSpecialValueFor("maddening_buffer_distance")
	self.scepter_damage_reduction = self:GetAbility():GetSpecialValueFor("scepter_damage_reduction")
	self.pause_time = self:GetAbility():GetSpecialValueFor("pause_time")
	self.units = self:GetAbility():GetSpecialValueFor("units")
	self.slow = self:GetAbility():GetSpecialValueFor("slow") * (-1)

	if not IsServer() then return end

	self.no_pause = params.no_pause
	self.kill_count = 0
	self.last_damage_time = GameRules:GetGameTime()

	self.enemy_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_battle_hunger.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster())
	ParticleManager:SetParticleControl(self.enemy_particle, 2, Vector(0, 0, 0))
	self:AddParticle(self.enemy_particle, false, false, -1, false, false)

	self:SetStackCount(self.units)

	self:StartIntervalThink(self.tick_rate)
end

function modifier_imba_battle_hunger_debuff_dot:OnRefresh(params)
	self:OnCreated(params)
end

function modifier_imba_battle_hunger_debuff_dot:OnIntervalThink()
	if IsServer() then
		-- Check if target is in fountain area
		if IsNearFriendlyClass(self.parent, 1360, "ent_dota_fountain") then
			self:Destroy()
			return nil
		end

		local damageTable = {
			victim = self.parent,
			attacker = self.caster,
			damage = self.damage_over_time,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self.ability
		}

		ApplyDamage(damageTable)

		-- Check if the parent didn't attack for a long time - if so, the modifier should reset itself
		if self.no_pause == 0 and (GameRules:GetGameTime() > self.last_damage_time + self.pause_time) then
			self:SetDuration(self:GetRemainingTime() + self.tick_rate, true)
		end
	end
end

function modifier_imba_battle_hunger_debuff_dot:OnDestroy()
	if IsServer() and self:GetCaster() and not self:GetCaster():IsNull() then
		local stack_count = self:GetCaster():GetModifierStackCount("modifier_imba_battle_hunger_buff_haste", self)
		if (stack_count == 1) then
			self:GetCaster():RemoveModifierByName("modifier_imba_battle_hunger_buff_haste")
		else
			self:GetCaster():SetModifierStackCount("modifier_imba_battle_hunger_buff_haste", self, stack_count - 1)
		end

		-- Both modifiers are created in OnAttackStart and removed OnAttack, this is just in case shit happens...as it always tends to
		if self.restrict_modifier and not self.restrict_modifier:IsNull() then
			self.restrict_modifier:Destroy()
		end
		if self.deny_modifier and not self.deny_modifier:IsNull() then
			self.deny_modifier:Destroy()
		end
	end
end

function modifier_imba_battle_hunger_debuff_dot:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK,

		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_imba_battle_hunger_debuff_dot:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_imba_battle_hunger_debuff_dot:GetModifierTotalDamageOutgoing_Percentage()
	if self:GetCaster() and not self:GetCaster():IsNull() and self:GetCaster():HasScepter() then
		return self.scepter_damage_reduction
	else
		return 0
	end
end

function modifier_imba_battle_hunger_debuff_dot:OnDeath(keys)
	if keys.attacker == self.parent then
		self.kill_count = self.kill_count + 1

		self:DecrementStackCount()

		if self:GetStackCount() <= 0 then
			self:Destroy()
		end
	end
end

function modifier_imba_battle_hunger_debuff_dot:OnTakeDamage(keys)
	if IsServer() then
		if keys.attacker == self.parent and keys.damage > 0 then
			self.last_damage_time = GameRules:GetGameTime()
		end
	end
end

function modifier_imba_battle_hunger_debuff_dot:OnAttackStart(keys)
	if IsServer() then
		-- If we attack the caster, don't redirect
		if keys.attacker == self.parent and self.parent:IsHero() and keys.target ~= self.caster then
			if not self.cmd_restricted and RollPseudoRandom(self.maddening_chance_pct, self) then
				local targets = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.parent:Script_GetAttackRange() + self.maddening_buffer_distance, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

				-- If no one but us or us + current target are around, do nothing
				if #targets <= 2 then
					return
				end

				-- Find the first non-self unit and attack that (can even be the same unit we are attacking)
				self.cmd_restricted = true -- To prevent repeated target changing due to forced order
				for _, unit in pairs(targets) do
					if unit ~= self.parent and unit ~= keys.target then
						local newOrder = {
							UnitIndex = self.parent:entindex(),
							OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
							TargetIndex = unit:entindex()
						}
						ExecuteOrderFromTable(newOrder)

						-- Modifier that prevents orders until OnAttack happens
						self.restrict_modifier = self.parent:AddNewModifier(self.caster, self:GetAbility(), self.cmd_restrict_modifier, { duration = self.max_maddening_duration })

						-- Modifier that allows the enemy to attack it's targetted ally
						if unit:GetTeamNumber() == self.parent:GetTeamNumber() then
							self.deny_modifier = unit:AddNewModifier(self.caster, self:GetAbility(), self.deny_allow_modifier, { self.max_maddening_duration })
						end
						break
					end
				end
			end
		end
	end
end

function modifier_imba_battle_hunger_debuff_dot:OnAttack(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and self.cmd_restricted then
			-- Stop forcing attacking the target
			self.cmd_restricted = false
			if self.restrict_modifier and not self.restrict_modifier:IsNull() then
				self.restrict_modifier:Destroy()
			end
			if self.deny_modifier and not self.deny_modifier:IsNull() then
				self.deny_modifier:Destroy()
			end

			-- Target gets Battle Hunger'ed
			if keys.target:GetTeamNumber() == keys.attacker:GetTeamNumber() then
				if self:GetAbility() and self:GetAbility().ApplyBattleHunger then
					self:GetAbility():ApplyBattleHunger(self.caster, keys.target)
				end
			end
		end
	end
end

function modifier_imba_battle_hunger_debuff_dot:OnTooltip(keys)
	-- fail type might depend on how many other variables are being used in the tooltip

	if keys.fail_type == 2 then
		return self.damage_over_time
	elseif keys.fail_type == 3 then
		return self:GetStackCount()
	elseif keys.fail_type == 4 then
		return self.pause_time
	end
end

-------------------------------------------
-- Battle Hunger command restrict modifier
-------------------------------------------
modifier_imba_battle_hunger_debuff_cmd = modifier_imba_battle_hunger_debuff_cmd or class({})

function modifier_imba_battle_hunger_debuff_cmd:CheckState()
	return { [MODIFIER_STATE_COMMAND_RESTRICTED] = true }
end

function modifier_imba_battle_hunger_debuff_cmd:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

function modifier_imba_battle_hunger_debuff_cmd:StatusEffectPriority()
	return 10
end

function modifier_imba_battle_hunger_debuff_cmd:IsHidden()
	return true
end

function modifier_imba_battle_hunger_debuff_cmd:IsDebuff()
	return true
end

function modifier_imba_battle_hunger_debuff_cmd:IsPurgable()
	return false
end

----------------------------------------------------------------------------------------------------
-- Battle Hunger deny modifier to allow enemies to attack their allies
----------------------------------------------------------------------------------------------------
modifier_imba_battle_hunger_debuff_deny = modifier_imba_battle_hunger_debuff_deny or class({})

function modifier_imba_battle_hunger_debuff_deny:CheckState()
	return { [MODIFIER_STATE_SPECIALLY_DENIABLE] = true }
end

function modifier_imba_battle_hunger_debuff_deny:IsHidden()
	return true
end

function modifier_imba_battle_hunger_debuff_deny:IsDebuff()
	return true
end

function modifier_imba_battle_hunger_debuff_deny:IsPurgable()
	return false
end

----------------------------------------------------------------------------------------------------

-------------------------------------------
-- Counter Helix
-------------------------------------------
-- Hidden Modifiers:
MergeTables(LinkedModifiers, {
	["modifier_imba_counter_helix_passive"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_counter_helix_spin_stacks"] = LUA_MODIFIER_MOTION_NONE,
})
imba_axe_counter_helix = imba_axe_counter_helix or class({})

function imba_axe_counter_helix:GetCastRange()
	return self:GetSpecialValueFor("radius")
end

function imba_axe_counter_helix:GetIntrinsicModifierName()
	return "modifier_imba_counter_helix_passive"
end

-------------------------------------------
-- Counter Helix modifier
-------------------------------------------

modifier_imba_counter_helix_passive = modifier_imba_counter_helix_passive or class({})

function modifier_imba_counter_helix_passive:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_enemy_taunt = "modifier_imba_berserkers_call_debuff_cmd"
	self.spin_to_win_modifier = "modifier_imba_counter_helix_spin_stacks"

	--ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.radius_increase_per_stack = self.ability:GetSpecialValueFor("radius_increase_per_stack")
	self.stack_limit = self.ability:GetSpecialValueFor("stack_limit")
	self.stack_duration = self.ability:GetSpecialValueFor("stack_duration")
	self.proc_chance = self.ability:GetSpecialValueFor("proc_chance")
	self.base_damage = self.ability:GetSpecialValueFor("base_damage")
	-- Talent : Double Helix chance, but reduce base damage by 1/3
	if self.caster:HasTalent("special_bonus_imba_axe_5") then
		self.proc_chance = self.proc_chance * self.caster:FindTalentValue("special_bonus_imba_axe_5", "proc_chance_multiplier")
		self.base_damage = self.base_damage * self.caster:FindTalentValue("special_bonus_imba_axe_5", "damage_multiplier") / 100
	end
	-- Talent : 25% chance on Counter Helix to repeat itself, not recursive
	if self.caster:HasTalent("special_bonus_imba_axe_6") then
		self.allow_repeat = true
		self.repeat_chance_pct = self.caster:FindTalentValue("special_bonus_imba_axe_6")
	else
		self.allow_repeat = false
	end
	self.taunted_damage_bonus_pct = self.ability:GetSpecialValueFor("taunted_damage_bonus_pct")
end

function modifier_imba_counter_helix_passive:OnRefresh()
	self:OnCreated()
end

function modifier_imba_counter_helix_passive:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_imba_counter_helix_passive:OnAttackLanded(keys)
	-- "Cannot proc on attacks from buildings, wards and allies."
	if self:GetAbility() and not self:GetCaster():PassivesDisabled() and ((keys.target == self:GetParent() and not keys.attacker:IsBuilding() and not keys.attacker:IsOther() and keys.attacker:GetTeamNumber() ~= keys.target:GetTeamNumber()) or (keys.attacker == self:GetCaster() and self:GetCaster():HasTalent("special_bonus_imba_axe_9"))) then
		self.proc_chance = self:GetAbility():GetSpecialValueFor("proc_chance")
		self.base_damage = self:GetAbility():GetSpecialValueFor("base_damage")
		-- Talent : Double Helix chance, but reduce base damage by 1/3
		if self.caster:HasTalent("special_bonus_imba_axe_5") then
			self.proc_chance = self.proc_chance * self.caster:FindTalentValue("special_bonus_imba_axe_5", "proc_chance_multiplier")
			self.base_damage = self.base_damage * self.caster:FindTalentValue("special_bonus_imba_axe_5", "damage_multiplier") / 100
		end

		-- +30% of your strength added to Counter Helix damage.
		if self.caster:HasTalent("special_bonus_imba_axe_4") then
			self.str = self.caster:GetStrength() / 100
			self.talent_4_value = self.caster:FindTalentValue("special_bonus_imba_axe_4")
			self.bonus_damage = self.str * self.talent_4_value
			self.total_damage = self.base_damage + self.bonus_damage
		else
			self.total_damage = self.base_damage
		end

		-- Talent : Your armor value is added to Counter Helix damage
		if self.caster:HasTalent("special_bonus_imba_axe_7") then
			self.total_damage = self.total_damage + self.caster:GetPhysicalArmorValue(false) * self.caster:FindTalentValue("special_bonus_imba_axe_7")
		end

		--calculate chance to counter helix
		if RollPseudoRandom(self.proc_chance, self) then
			self:Spin(self.allow_repeat)
		end
	end
end

function modifier_imba_counter_helix_passive:Spin(repeat_allowed)
	self.helix_pfx_1 = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_attack_blur_counterhelix.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster, self.caster)
	ParticleManager:SetParticleControl(self.helix_pfx_1, 0, self.caster:GetAbsOrigin())
	if Battlepass and Battlepass:HasArcana(self.caster:GetPlayerID(), "axe") then
		ParticleManager:SetParticleControlEnt(self.helix_pfx_1, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_attack1", self.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.helix_pfx_1, 2, self.caster, PATTACH_POINT_FOLLOW, "attach_attack2", self.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.helix_pfx_1, 3, self.caster:GetAbsOrigin())
	end
	ParticleManager:ReleaseParticleIndex(self.helix_pfx_1)

	--	self.helix_pfx_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_counterhelix.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	--	ParticleManager:SetParticleControl(self.helix_pfx_2, 0, self.caster:GetAbsOrigin())
	--	ParticleManager:ReleaseParticleIndex(self.helix_pfx_2)

	self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
	self.caster:EmitSound("Hero_Axe.CounterHelix")

	local spin_to_win = self.caster:FindModifierByName(self.spin_to_win_modifier)
	local radius = self.radius
	if spin_to_win then
		radius = radius + spin_to_win:GetStackCount() * self.radius_increase_per_stack
	end

	-- Find nearby enemies
	self.enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	-- Apply damage to valid enemies
	for _, enemy in pairs(self.enemies) do
		local damage = self.total_damage

		-- If an enemy is tauned, increase damage on it
		if enemy:HasModifier(self.modifier_enemy_taunt) then
			damage = damage * (1 + self.taunted_damage_bonus_pct / 100)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, enemy, damage, nil)
		end

		ApplyDamage({ attacker = self.caster, victim = enemy, ability = self.ability, damage = damage, damage_type = DAMAGE_TYPE_PURE })
	end

	if spin_to_win then
		spin_to_win:ForceRefresh()
		spin_to_win:IncrementStackCount()
	else
		spin_to_win = self.caster:AddNewModifier(self.caster, self.ability, self.spin_to_win_modifier, { duration = self.stack_duration })
		if spin_to_win then
			spin_to_win:IncrementStackCount()
		end
	end

	-- Repeat Counter Helix'es don't proc repeats themselves
	if repeat_allowed and RollPercentage(self.repeat_chance_pct) then
		self:Spin(false)
	end
end

function modifier_imba_counter_helix_passive:IsPassive()
	return true
end

function modifier_imba_counter_helix_passive:IsHidden()
	return true
end

function modifier_imba_counter_helix_passive:IsBuff()
	return true
end

function modifier_imba_counter_helix_passive:IsPurgable()
	return false
end

----------------------------------------------------------------------------------------------------
modifier_imba_counter_helix_spin_stacks = modifier_imba_counter_helix_spin_stacks or class({})

function modifier_imba_counter_helix_spin_stacks:OnCreated()
	self.stack_limit = self:GetAbility():GetSpecialValueFor("stack_limit")
end

function modifier_imba_counter_helix_spin_stacks:OnStackCountChanged(oldstacks)
	if self:GetStackCount() > self.stack_limit then
		self:SetStackCount(self.stack_limit)
	end
end

function modifier_imba_counter_helix_spin_stacks:IsHidden()
	return false
end

function modifier_imba_counter_helix_spin_stacks:IsBuff()
	return true
end

function modifier_imba_counter_helix_spin_stacks:IsPurgable()
	return false
end

----------------------------------------------------------------------------------------------------


-------------------------------------------
-- Culling Blade
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers, {
	["modifier_imba_culling_blade_buff_haste"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_culling_blade_cull_stacks"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers, {
	["modifier_imba_culling_blade_motion"] = LUA_MODIFIER_MOTION_NONE,
})
imba_axe_culling_blade = imba_axe_culling_blade or class({})

function imba_axe_culling_blade:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():FindTalentValue("special_bonus_imba_axe_8")
end

function imba_axe_culling_blade:OnSpellStart()
	self.caster = self:GetCaster()
	self.ability = self
	self.target = self:GetCursorTarget()
	self.target_location = self.target:GetAbsOrigin()
	self.scepter = self.caster:HasScepter()

	--particle
	self.kill_enemy_response = "axe_axe_ability_cullingblade_0" .. math.random(1, 2)

	--ability specials
	self.culling_modifier = "modifier_imba_culling_blade_cull_stacks"
	self.kill_threshold = self.ability:GetSpecialValueFor("kill_threshold")
	self.kill_threshold_max_hp_pct = self.ability:GetSpecialValueFor("kill_threshold_max_hp_pct") / 100
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.speed_bonus = self.ability:GetSpecialValueFor("speed_bonus")
	self.as_bonus = self.ability:GetSpecialValueFor("as_bonus")
	self.speed_duration = self.ability:GetSpecialValueFor("speed_duration")
	self.speed_aoe_radius = self.ability:GetSpecialValueFor("speed_aoe")
	self.max_health_kill_heal_pct = self.ability:GetSpecialValueFor("max_health_kill_heal_pct")
	self.scepter_battle_hunger_radius = self.ability:GetSpecialValueFor("scepter_battle_hunger_radius")
	self.culling_stack_duration = self.ability:GetSpecialValueFor("stack_duration")
	self.threshold_increase = self.ability:GetSpecialValueFor("threshold_increase")
	self.threshold_max_hp_pct_increase = self.ability:GetSpecialValueFor("threshold_max_hp_pct_increase")
	-- Check for Linkens
	if self.target:GetTeamNumber() ~= self.caster:GetTeamNumber() then
		if self.target:TriggerSpellAbsorb(self.ability) then
			-- Do not pass go, do not dunk
			self.caster:RemoveModifierByName(self.culling_modifier)
			return
		end
	end

	local dunk_modifier = self.caster:FindModifierByName(self.culling_modifier)
	if dunk_modifier then
		self.kill_threshold = self.kill_threshold + dunk_modifier:GetStackCount() * self.threshold_increase
		self.kill_threshold_max_hp_pct = self.kill_threshold_max_hp_pct + dunk_modifier:GetStackCount() * self.threshold_max_hp_pct_increase / 100
	end

	-- Initializing the damage table
	self.damageTable = {
		victim = self.target,
		attacker = self.caster,
		damage = self.damage,
		damage_type = self.ability:GetAbilityDamageType(),
		ability = self.ability
	}

	--leap
	local vLocation = self:GetCursorPosition()
	local kv =
	{
		vLocX = vLocation.x,
		vLocY = vLocation.y,
		vLocZ = vLocation.z
	}

	-- Check if the target HP is equal or below the threshold
	if (self.target:GetHealth() <= self.kill_threshold or (self.target:GetHealth() / self.target:GetMaxHealth() <= self.kill_threshold_max_hp_pct)) and not self.target:HasModifier("modifier_imba_reincarnation_scepter_wraith") then
		if self.caster:HasTalent("special_bonus_imba_axe_8") and (self:GetCaster():GetAbsOrigin() - self.target_location):Length2D() > self.BaseClass.GetCastRange(self, self.target_location, self.target) then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_culling_blade_motion", kv)
			self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 1)
			Timers:CreateTimer(0.40, function()
				self:KillUnit(self.target)
				self:GetCaster():EmitSound("Hero_Axe.Culling_Blade_Success")
			end)
		else
			self:KillUnit(self.target)
			self:GetCaster():EmitSound("Hero_Axe.Culling_Blade_Success")
		end


		-- if blink and ulti kill successfully then play blink response
		for i = 0, 5 do
			self.item = self.caster:GetItemInSlot(i)
			if self.item and self.item:GetAbilityName():find("^item_imba_blink") then
				self.blink_cd_remaining = self.item:GetCooldownTimeRemaining()
				self.blink_cd_total_minus_two = self.item:GetCooldown(0) - 2
				if (self.blink_cd_remaining >= self.blink_cd_total_minus_two) then
					self.kill_enemy_response = "axe_axe_blinkcull_0" .. math.random(1, 3)
				else
					self.kill_enemy_response = "axe_axe_ability_cullingblade_0" .. math.random(1, 2)
				end
			end
		end
		self:GetCaster():EmitSoundParams(self.kill_enemy_response, 200, 1000, 1)

		-- find allied targets for speed bonus
		self.allies_in_radius = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.speed_aoe_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

		for _, target in pairs(self.allies_in_radius) do
			target:AddNewModifier(self.caster, self, "modifier_imba_culling_blade_buff_haste", { duration = self.speed_duration })
		end

		-- refresh cooldown if killed unit is player
		if (self.target:IsHero()) then
			self.ability:EndCooldown()
			if dunk_modifier then
				dunk_modifier:ForceRefresh()
			else
				dunk_modifier = self.caster:AddNewModifier(self.caster, self, self.culling_modifier, { duration = self.culling_stack_duration })
			end
			dunk_modifier:IncrementStackCount()
		end

		--scepter apply battle hunger to enemies in radius
		if self.scepter then
			self.targets = FindUnitsInRadius(self.caster:GetTeamNumber(), self.target:GetAbsOrigin(), nil, self.scepter_battle_hunger_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
			self.battle_hunger_ability = self.caster:FindAbilityByName("imba_axe_battle_hunger")
			if self.battle_hunger_ability and self.battle_hunger_ability:GetLevel() > 0 then
				for _, enemies in pairs(self.targets) do
					self.battle_hunger_ability:ApplyBattleHunger(self.caster, enemies)
				end
			end
		end
	else
		if self.caster:HasTalent("special_bonus_imba_axe_8") and (self:GetCaster():GetAbsOrigin() - self.target_location):Length2D() > self.BaseClass.GetCastRange(self, self.target_location, self.target) then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_culling_blade_motion", kv)
			self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 1)
			Timers:CreateTimer(0.4, function()
				EmitSoundOn("Hero_Axe.Culling_Blade_Fail", self:GetCaster())
				ApplyDamage(self.damageTable)
			end)
		else
			EmitSoundOn("Hero_Axe.Culling_Blade_Fail", self:GetCaster())
			ApplyDamage(self.damageTable)
		end

		-- You get nothing! You lose! Good day, sir!
		self.caster:RemoveModifierByName(self.culling_modifier)
	end
end

function imba_axe_culling_blade:KillUnit(target)
	TrueKill(self.caster, target, self)
	self.heal_amount = (self.caster:GetMaxHealth() / 100) * self.max_health_kill_heal_pct
	self.caster:Heal(self.heal_amount, self.caster)
	-- Play the kill particle
	self.culling_kill_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", PATTACH_CUSTOMORIGIN, self.caster, self.caster)
	--ParticleManager:SetParticleControlEnt(self.culling_kill_particle, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target_location, true)
	--ParticleManager:SetParticleControlEnt(self.culling_kill_particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target_location, true)
	--ParticleManager:SetParticleControlEnt(self.culling_kill_particle, 2, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target_location, true)
	-- ParticleManager:SetParticleControlEnt(self.culling_kill_particle, 4, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target_location, true)
	ParticleManager:SetParticleControl(self.culling_kill_particle, 4, self.target_location)
	-- ParticleManager:SetParticleControlEnt(self.culling_kill_particle, 8, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target_location, true)
	ParticleManager:ReleaseParticleIndex(self.culling_kill_particle)
end

function imba_axe_culling_blade:GetCastAnimation()
	if self.target and self.target_location and self:GetCaster():HasTalent("special_bonus_imba_axe_8") and (self:GetCaster():GetAbsOrigin() - self.target_location):Length2D() > self.BaseClass.GetCastRange(self, self.target_location, self.target) then
		return ACT_SHOTGUN_PUMP
	else
		return ACT_DOTA_CAST_ABILITY_4
	end
end

-------------------------------------------
-- Culling Blade Cull Stack modifier - increases kill thresholds
-------------------------------------------
modifier_imba_culling_blade_cull_stacks = modifier_imba_culling_blade_cull_stacks or class({})

function modifier_imba_culling_blade_cull_stacks:OnCreated()
	self.stack_limit = self:GetAbility():GetSpecialValueFor("stack_limit")
end

function modifier_imba_culling_blade_cull_stacks:OnStackCountChanged(oldstacks)
	if self:GetStackCount() > self.stack_limit then
		self:SetStackCount(self.stack_limit)
	end
end

-------------------------------------------
-- Culling Blade sprint modifier
-------------------------------------------

modifier_imba_culling_blade_buff_haste = modifier_imba_culling_blade_buff_haste or class({})

function modifier_imba_culling_blade_buff_haste:OnCreated()
	-- I know that's a terrible workaround
	if not IsServer() then return end

	self.axe_culling_blade_boost = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_boost.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster(), self:GetCaster())
	ParticleManager:ReleaseParticleIndex(self.axe_culling_blade_boost)

	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_cullingblade_sprint_axe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster(), self:GetCaster())
	self:AddParticle(self.pfx, false, false, -1, false, false)
end

function modifier_imba_culling_blade_buff_haste:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_imba_culling_blade_buff_haste:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("speed_bonus")
end

function modifier_imba_culling_blade_buff_haste:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("as_bonus")
end

function modifier_imba_culling_blade_buff_haste:IsBuff()
	return true
end

function modifier_imba_culling_blade_buff_haste:IsPurgable()
	return true
end

function modifier_imba_culling_blade_buff_haste:StatusEffectPriority()
	return 11
end

-- Pretty sure these effects are not working at all. Maybe they're not status effects
function modifier_imba_culling_blade_buff_haste:GetStatusEffectName()
	if self:GetCaster():HasModifier("modifier_axe_arcana") then
		return "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_hero_effect.vpcf"
	else
		return "particles/units/heroes/hero_axe/axe_culling_blade_hero_effect.vpcf"
	end
end

function modifier_imba_culling_blade_buff_haste:OnDestroy()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
	end
end

-------------------------------------------
-- Culling Blade leap modifier
-------------------------------------------
-- credits goes to o0oradaro0o/Battleships_Reborn

modifier_imba_culling_blade_motion = modifier_imba_culling_blade_motion or class({})

function modifier_imba_culling_blade_motion:IsHidden() return true end

function modifier_imba_culling_blade_motion:IsPurgable() return false end

function modifier_imba_culling_blade_motion:IsDebuff() return false end

function modifier_imba_culling_blade_motion:RemoveOnDeath() return false end

function modifier_imba_culling_blade_motion:IgnoreTenacity() return true end

function modifier_imba_culling_blade_motion:IsMotionController() return true end

function modifier_imba_culling_blade_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_imba_culling_blade_motion:OnCreated(kv)
	if IsServer() then
		self.axe_minimum_height_above_lowest = 500
		self.axe_minimum_height_above_highest = 100
		self.axe_acceleration_z = 4000
		self.axe_max_horizontal_acceleration = 3000

		self.vStartPosition = GetGroundPosition(self:GetParent():GetOrigin(), self:GetParent())
		self.flCurrentTimeHoriz = 0.0
		self.flCurrentTimeVert = 0.0

		self.vLoc = Vector(kv.vLocX, kv.vLocY, kv.vLocZ)
		self.vLastKnownTargetPos = self.vLoc

		local duration = self:GetAbility():GetSpecialValueFor("duration")
		local flDesiredHeight = self.axe_minimum_height_above_lowest * duration * duration
		local flLowZ = math.min(self.vLastKnownTargetPos.z, self.vStartPosition.z)
		local flHighZ = math.max(self.vLastKnownTargetPos.z, self.vStartPosition.z)
		local flArcTopZ = math.max(flLowZ + flDesiredHeight, flHighZ + self.axe_minimum_height_above_highest)

		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt(2.0 * flArcDeltaZ * self.axe_acceleration_z)

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt(math.max(0, (self.flInitialVelocityZ * self.flInitialVelocityZ) - 2.0 * self.axe_acceleration_z * flDeltaZ))
		self.flPredictedTotalTime = math.max((self.flInitialVelocityZ + flSqrtDet) / self.axe_acceleration_z, (self.flInitialVelocityZ - flSqrtDet) / self.axe_acceleration_z)

		self.vHorizontalVelocity = (self.vLastKnownTargetPos - self.vStartPosition) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0

		self.frametime = FrameTime()
		self:StartIntervalThink(self.frametime)
	end
end

function modifier_imba_culling_blade_motion:OnIntervalThink()
	-- Check motion controllers
	if not self:CheckMotionControllers() then
		self:Destroy()
		return nil
	end

	-- Horizontal motion
	self:HorizontalMotion(self:GetParent(), self.frametime)

	-- Vertical motion
	self:VerticalMotion(self:GetParent(), self.frametime)
end

function modifier_imba_culling_blade_motion:HorizontalMotion(me, dt)
	if IsServer() then
		self.flCurrentTimeHoriz = math.min(self.flCurrentTimeHoriz + dt, self.flPredictedTotalTime)
		local t = self.flCurrentTimeHoriz / self.flPredictedTotalTime
		local vStartToTarget = self.vLastKnownTargetPos - self.vStartPosition
		local vDesiredPos = self.vStartPosition + t * vStartToTarget

		local vOldPos = me:GetOrigin()
		local vToDesired = vDesiredPos - vOldPos
		vToDesired.z = 0.0
		local vDesiredVel = vToDesired / dt
		local vVelDif = vDesiredVel - self.vHorizontalVelocity
		local flVelDif = vVelDif:Length2D()
		vVelDif = vVelDif:Normalized()
		local flVelDelta = math.min(flVelDif, self.axe_max_horizontal_acceleration)

		self.vHorizontalVelocity = self.vHorizontalVelocity + vVelDif * flVelDelta * dt
		local vNewPos = vOldPos + self.vHorizontalVelocity * dt
		me:SetOrigin(vNewPos)
	end
end

function modifier_imba_culling_blade_motion:VerticalMotion(me, dt)
	if IsServer() then
		if not self:GetParent():IsAlive() then
			self:GetParent():InterruptMotionControllers(true)
			self:Destroy()
		end

		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = (-self.axe_acceleration_z * self.flCurrentTimeVert + self.flInitialVelocityZ) < 0

		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + (-0.5 * self.axe_acceleration_z * (self.flCurrentTimeVert * self.flCurrentTimeVert) + self.flInitialVelocityZ * self.flCurrentTimeVert)

		local flGroundHeight = GetGroundHeight(vNewPos, self:GetParent())
		local bLanded = false
		if (vNewPos.z < flGroundHeight and bGoingDown == true) then
			vNewPos.z = flGroundHeight
			bLanded = true
		end

		me:SetOrigin(vNewPos)
		if bLanded == true then
			self:Destroy()
		end
	end
end

function modifier_imba_culling_blade_motion:OnDestroy()
	if IsServer() then
		self:GetParent():SetUnitOnClearGround()
	end
end

-------------------------------------------
for LinkedModifier, MotionController in pairs(LinkedModifiers) do
	LinkLuaModifier(LinkedModifier, "components/abilities/heroes/hero_axe", MotionController)
end

LinkLuaModifier("modifier_axe_arcana", "components/abilities/heroes/hero_axe", LUA_MODIFIER_MOTION_NONE)

-- Arcana handler
modifier_axe_arcana = modifier_axe_arcana or class({})

function modifier_axe_arcana:RemoveOnDeath()
	return false
end

function modifier_axe_arcana:IsHidden()
	return true
end

function modifier_axe_arcana:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}
end

function modifier_axe_arcana:GetAttackSound()
	return "Hero_Axe.Attack.Jungle"
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_axe_2", "components/abilities/heroes/hero_axe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_axe_3", "components/abilities/heroes/hero_axe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_axe_4", "components/abilities/heroes/hero_axe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_axe_5", "components/abilities/heroes/hero_axe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_axe_8", "components/abilities/heroes/hero_axe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_axe_9", "components/abilities/heroes/hero_axe", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_axe_2 = modifier_special_bonus_imba_axe_2 or class({})
modifier_special_bonus_imba_axe_3 = modifier_special_bonus_imba_axe_3 or class({})
modifier_special_bonus_imba_axe_4 = modifier_special_bonus_imba_axe_4 or class({})
modifier_special_bonus_imba_axe_5 = modifier_special_bonus_imba_axe_5 or class({})
modifier_special_bonus_imba_axe_8 = modifier_special_bonus_imba_axe_8 or class({})
modifier_special_bonus_imba_axe_9 = modifier_special_bonus_imba_axe_9 or class({})

function modifier_special_bonus_imba_axe_2:IsHidden() return true end

function modifier_special_bonus_imba_axe_2:IsPurgable() return false end

function modifier_special_bonus_imba_axe_2:RemoveOnDeath() return false end

function modifier_special_bonus_imba_axe_3:IsHidden() return true end

function modifier_special_bonus_imba_axe_3:IsPurgable() return false end

function modifier_special_bonus_imba_axe_3:RemoveOnDeath() return false end

function modifier_special_bonus_imba_axe_4:IsHidden() return true end

function modifier_special_bonus_imba_axe_4:IsPurgable() return false end

function modifier_special_bonus_imba_axe_4:RemoveOnDeath() return false end

function modifier_special_bonus_imba_axe_5:IsHidden() return true end

function modifier_special_bonus_imba_axe_5:IsPurgable() return false end

function modifier_special_bonus_imba_axe_5:RemoveOnDeath() return false end

function modifier_special_bonus_imba_axe_8:IsHidden() return true end

function modifier_special_bonus_imba_axe_8:IsPurgable() return false end

function modifier_special_bonus_imba_axe_8:RemoveOnDeath() return false end

function modifier_special_bonus_imba_axe_9:IsHidden() return true end

function modifier_special_bonus_imba_axe_9:IsPurgable() return false end

function modifier_special_bonus_imba_axe_9:RemoveOnDeath() return false end

function imba_axe_culling_blade:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_axe_8") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_axe_8") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_axe_8"), "modifier_special_bonus_imba_axe_8", {})
	end
end
