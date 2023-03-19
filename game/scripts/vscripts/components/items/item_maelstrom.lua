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

--	Author: Firetoad
--	Date: 			19.07.2016
--	Last Update:	26.03.2017
--	Maelstrom, Mjollnir and Jarnbjorn

-- Here to ruin the fun.

-- Editor:
--	   AltiV, February 29th, 2020

-- These functions will be used for all the Maelstrom series items
LinkLuaModifier("modifier_item_imba_chain_lightning", "components/items/item_maelstrom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_chain_lightning_cooldown", "components/items/item_maelstrom", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_imba_static_charge", "components/items/item_maelstrom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_static_charge_slow", "components/items/item_maelstrom", LUA_MODIFIER_MOTION_NONE)

modifier_item_imba_chain_lightning          = modifier_item_imba_chain_lightning or class({})
modifier_item_imba_chain_lightning_cooldown = modifier_item_imba_chain_lightning_cooldown or class({})
modifier_item_imba_static_charge            = modifier_item_imba_static_charge or class({})
modifier_item_imba_static_charge_slow       = modifier_item_imba_static_charge_slow or class({})

LinkLuaModifier("modifier_item_imba_maelstrom", "components/items/item_maelstrom", LUA_MODIFIER_MOTION_NONE)

-- This code will be combining all three items into one class
item_imba_maelstrom          = item_imba_maelstrom or class({})
modifier_item_imba_maelstrom = modifier_item_imba_maelstrom or class({})

item_imba_mjollnir           = item_imba_maelstrom
item_imba_jarnbjorn          = item_imba_maelstrom

----------------------------------------
-- MODIFIER_ITEM_IMBA_CHAIN_LIGHTNING --
----------------------------------------

function modifier_item_imba_chain_lightning:IsHidden() return true end

function modifier_item_imba_chain_lightning:IsPurgable() return false end

function modifier_item_imba_chain_lightning:RemoveOnDeath() return false end

function modifier_item_imba_chain_lightning:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_chain_lightning:OnCreated(keys)
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	if not IsServer() then return end

	if self:GetAbility() then
		self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
		self.chain_damage = self:GetAbility():GetSpecialValueFor("chain_damage")
		self.chain_strikes = self:GetAbility():GetSpecialValueFor("chain_strikes")
		self.chain_radius = self:GetAbility():GetSpecialValueFor("chain_radius")
		self.chain_delay = self:GetAbility():GetSpecialValueFor("chain_delay")
	else
		self.bonus_damage = 0
		self.chain_damage = 0
		self.chain_strikes = 0
		self.chain_radius = 0
		self.chain_delay = 0
	end

	self.starting_unit_entindex = keys.starting_unit_entindex

	if self.starting_unit_entindex and EntIndexToHScript(self.starting_unit_entindex) then
		self.current_unit = EntIndexToHScript(self.starting_unit_entindex)
	else
		self:Destroy()
		return
	end

	self.units_affected = {}
	self.unit_counter   = 0

	self:OnIntervalThink()
	self:StartIntervalThink(self.chain_delay)
end

function modifier_item_imba_chain_lightning:OnIntervalThink()
	self.zapped = false

	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.current_unit:GetAbsOrigin(), nil, self.chain_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)) do
		if not self.units_affected[enemy] then
			enemy:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")

			self.zap_particle = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit, self:GetCaster())

			if self.unit_counter == 0 then
				ParticleManager:SetParticleControlEnt(self.zap_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			else
				ParticleManager:SetParticleControlEnt(self.zap_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
			end

			ParticleManager:SetParticleControlEnt(self.zap_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.zap_particle, 2, Vector(1, 1, 1))
			ParticleManager:ReleaseParticleIndex(self.zap_particle)

			self.unit_counter                      = self.unit_counter + 1
			self.current_unit                      = enemy
			self.units_affected[self.current_unit] = true
			self.zapped                            = true

			ApplyDamage({
				victim       = enemy,
				damage       = self.chain_damage,
				damage_type  = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = self:GetCaster(),
				ability      = self:GetAbility()
			})

			break
		end
	end

	if (self.unit_counter >= self.chain_strikes and self.chain_strikes > 0) or not self.zapped then
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end

-------------------------------------------------
-- MODIFIER_ITEM_IMBA_CHAIN_LIGHTNING_COOLDOWN --
-------------------------------------------------

function modifier_item_imba_chain_lightning_cooldown:IsHidden() return true end

function modifier_item_imba_chain_lightning_cooldown:IsPurgable() return false end

function modifier_item_imba_chain_lightning_cooldown:RemoveOnDeath() return false end

--------------------------------------
-- MODIFIER_ITEM_IMBA_STATIC_CHARGE --
--------------------------------------

function modifier_item_imba_static_charge:GetTexture()
	if self:GetAbility() then
		if self:GetAbility():GetName() == "item_imba_mjollnir" then
			return "item_mjollnir"
		elseif self:GetAbility():GetName() == "item_imba_jarnbjorn" then
			return "modifiers/imba_jarnbjorn"
		end
	end
end

function modifier_item_imba_static_charge:GetStatusEffectName()
	return "particles/status_fx/status_effect_mjollnir_shield.vpcf"
end

function modifier_item_imba_static_charge:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	if self:GetAbility() then
		self.static_chance        = self:GetAbility():GetSpecialValueFor("static_chance")
		self.static_strikes       = self:GetAbility():GetSpecialValueFor("static_strikes")
		self.static_damage        = self:GetAbility():GetSpecialValueFor("static_damage")
		self.static_radius        = self:GetAbility():GetSpecialValueFor("static_radius")
		self.static_cooldown      = self:GetAbility():GetSpecialValueFor("static_cooldown")

		self.static_slow          = self:GetAbility():GetSpecialValueFor("static_slow")
		self.static_slow_duration = self:GetAbility():GetSpecialValueFor("static_slow_duration")
	else
		self.static_chance        = 0
		self.static_strikes       = 0
		self.static_damage        = 0
		self.static_radius        = 0
		self.static_cooldown      = 0

		self.static_slow          = 0
		self.static_slow_duration = 0
	end

	if not IsServer() then return end

	self.bStaticCooldown = false

	self.shield_particle = ParticleManager:CreateParticle("particles/items2_fx/mjollnir_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster())
	self:AddParticle(self.shield_particle, false, false, -1, false, false)
end

function modifier_item_imba_static_charge:OnIntervalThink()
	self.bStaticCooldown = false
	self:StartIntervalThink(-1)
end

-- Stop playing sound and destroy the proc counter
function modifier_item_imba_static_charge:OnDestroy()
	if not IsServer() then return end

	self:GetParent():StopSound("DOTA_Item.Mjollnir.Loop")
end

function modifier_item_imba_static_charge:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_item_imba_static_charge:OnTakeDamage(keys)
	-- "Can only proc on damage instances of 5 or greater (after reductions)."
	if keys.unit == self:GetParent() and keys.attacker ~= self:GetParent() and not self.bStaticCooldown and keys.damage >= 5 and RollPseudoRandom(self.static_chance, self:GetAbility()) then
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning.Jump")

		if (keys.attacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self.static_radius and not keys.attacker:IsBuilding() and not keys.attacker:IsOther() and keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			local static_particle = nil

			static_particle = ParticleManager:CreateParticle("particles/item/mjollnir/static_lightning_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker, self:GetCaster())
			ParticleManager:SetParticleControlEnt(static_particle, 0, keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.attacker:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(static_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(static_particle)

			ApplyDamage({
				victim       = keys.attacker,
				damage       = self.static_damage,
				damage_type  = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = self:GetCaster(),
				ability      = self:GetAbility()
			})

			keys.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_static_charge_slow", { duration = self.static_slow_duration * (1 - keys.attacker:GetStatusResistance()) })
		end

		local unit_count = 0

		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.static_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)) do
			if enemy ~= keys.attacker then
				static_particle = ParticleManager:CreateParticle("particles/item/mjollnir/static_lightning_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy, self:GetCaster())
				ParticleManager:SetParticleControlEnt(static_particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(static_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(static_particle)

				ApplyDamage({
					victim       = enemy,
					damage       = self.static_damage,
					damage_type  = DAMAGE_TYPE_MAGICAL,
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					attacker     = self:GetCaster(),
					ability      = self:GetAbility()
				})

				enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_static_charge_slow", { duration = self.static_slow_duration * (1 - enemy:GetStatusResistance()) })

				unit_count = unit_count + 1

				if (unit_count >= self.static_strikes and self.static_strikes > 0) then
					break
				end
			end
		end

		self.bStaticCooldown = true
		self:StartIntervalThink(self.static_cooldown)
	end
end

function modifier_item_imba_static_charge:OnTooltip()
	return self.static_chance
end

-------------------------------------------
-- MODIFIER_ITEM_IMBA_STATIC_CHARGE_SLOW --
-------------------------------------------

function modifier_item_imba_static_charge_slow:GetTexture()
	if self:GetAbility() then
		if self:GetAbility():GetName() == "item_imba_mjollnir" then
			return "item_mjollnir"
		elseif self:GetAbility():GetName() == "item_imba_jarnbjorn" then
			return "modifiers/imba_jarnbjorn"
		end
	end
end

function modifier_item_imba_static_charge_slow:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	if self:GetAbility() then
		self.static_slow = self:GetAbility():GetSpecialValueFor("static_slow") * (-1)
	else
		self.static_slow = 0
	end
end

function modifier_item_imba_static_charge_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_imba_static_charge_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.static_slow
end

function modifier_item_imba_static_charge_slow:GetModifierAttackSpeedBonus_Constant()
	return self.static_slow
end

-------------------------
-- ITEM_IMBA_MAELSTROM --
-------------------------

function item_imba_maelstrom:GetIntrinsicModifierName()
	return "modifier_item_imba_maelstrom"
end

function item_imba_maelstrom:GetAOERadius()
	return self:GetSpecialValueFor("chop_tree_radius")
end

function item_imba_maelstrom:GetBehavior()
	if self:GetName() == "item_imba_jarnbjorn" then
		return self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_AOE
	else
		return self.BaseClass.GetBehavior(self)
	end
end

function item_imba_jarnbjorn:GetManaCost(level)
	if not self.bTargetingTree then
		return self.BaseClass.GetManaCost(self, level)
	else
		return 0
	end
end

function item_imba_maelstrom:GetCastRange(location, target)
	if IsClient() then
		return self.BaseClass.GetCastRange(self, location, target)
	else
		if (self:GetName() == "item_imba_jarnbjorn" and self:GetCursorTarget() and (self:GetCursorTarget().CutDown or not self:GetCursorTarget().IsCreep)) or self.bTargetingTree then
			self.bTargetingTree = true
			return self:GetSpecialValueFor("chop_tree_cast_range")
		else
			return self.BaseClass.GetCastRange(self, location, target)
		end
	end
end

function item_imba_maelstrom:GetCooldown(level)
	if IsServer() and self:GetName() == "item_imba_jarnbjorn" and self:GetCursorTarget() and (self:GetCursorTarget().CutDown or not self:GetCursorTarget().IsCreep) then
		return self:GetSpecialValueFor("chop_tree_cooldown")
	else
		return self.BaseClass.GetCooldown(self, level)
	end
end

function item_imba_maelstrom:OnSpellStart()
	self.bTargetingTree = false

	local target = self:GetCursorTarget()

	if self:GetName() == "item_imba_mjollnir" or self:GetName() == "item_imba_jarnbjorn" then
		if self:GetName() == "item_imba_jarnbjorn" and target.GetUnitName == nil then
			-- self:RefundManaCost()

			if target.CutDown then
				target:CutDown(-1)
			else
				target:Kill()
			end

			GridNav:DestroyTreesAroundPoint(target:GetAbsOrigin(), self:GetSpecialValueFor("chop_tree_radius"), true)
		else
			target:EmitSound("DOTA_Item.Mjollnir.Activate")
			target:EmitSound("DOTA_Item.Mjollnir.Loop")

			target:AddNewModifier(target, self, "modifier_item_imba_static_charge", { duration = self:GetSpecialValueFor("static_duration") })
		end
	end
end

----------------------------------
-- MODIFIER_ITEM_IMBA_MAELSTROM --
----------------------------------

function modifier_item_imba_maelstrom:IsHidden() return true end

function modifier_item_imba_maelstrom:IsPurgable() return false end

function modifier_item_imba_maelstrom:RemoveOnDeath() return false end

function modifier_item_imba_maelstrom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_maelstrom:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	if self:GetAbility() then
		self.bonus_damage          = self:GetAbility():GetSpecialValueFor("bonus_damage")
		self.bonus_attack_speed    = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
		self.bonus_health_regen    = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
		self.bonus_mana_regen      = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")

		self.chain_chance          = self:GetAbility():GetSpecialValueFor("chain_chance")
		self.chain_cooldown        = self:GetAbility():GetSpecialValueFor("chain_cooldown")

		-- Jarnbjorn KVs
		self.cleave_damage_percent = self:GetAbility():GetSpecialValueFor("cleave_damage_percent")
		self.quelling_bonus        = self:GetAbility():GetSpecialValueFor("quelling_bonus")
		self.quelling_bonus_ranged = self:GetAbility():GetSpecialValueFor("quelling_bonus_ranged")
		self.cleave_starting_width = self:GetAbility():GetSpecialValueFor("cleave_starting_width")
		self.cleave_ending_width   = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
		self.cleave_distance       = self:GetAbility():GetSpecialValueFor("cleave_distance")

		self.bonus_range           = self:GetAbility():GetSpecialValueFor("bonus_range")
	else
		self.bonus_damage          = 0
		self.bonus_attack_speed    = 0
		self.bonus_health_regen    = 0
		self.bonus_mana_regen      = 0

		self.chain_chance          = 0
		self.chain_cooldown        = 0

		-- Jarnbjorn KVs
		self.cleave_damage_percent = 0
		self.quelling_bonus        = 0
		self.quelling_bonus_ranged = 0
		self.cleave_starting_width = 0
		self.cleave_ending_width   = 0
		self.cleave_distance       = 0

		self.bonus_range           = 0
	end

	self.bChainCooldown = false

	if not IsServer() then return end

	local maelstroms = 0
	local mjollnirs  = 0
	local jarnbjorns = 0

	-- Use Secondary Charges system to make attack range not stack with multiple Maelstrom series items
	for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
		if mod:GetAbility():GetName() == "item_imba_maelstrom" then
			mod:GetAbility():SetSecondaryCharges(maelstroms + 1)
			maelstroms = maelstroms + 1
		elseif mod:GetAbility():GetName() == "item_imba_mjollnir" then
			mod:GetAbility():SetSecondaryCharges(mjollnirs + 1)
			mjollnirs = mjollnirs + 1
		elseif mod:GetAbility():GetName() == "item_imba_jarnbjorn" then
			mod:GetAbility():SetSecondaryCharges(jarnbjorns + 1)
			jarnbjorns = jarnbjorns + 1
		end
	end
end

function modifier_item_imba_maelstrom:OnDestroy()
	if not IsServer() then return end

	local maelstroms = 0
	local mjollnirs  = 0
	local jarnbjorns = 0

	for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
		if mod:GetAbility():GetName() == "item_imba_maelstrom" then
			mod:GetAbility():SetSecondaryCharges(maelstroms + 1)
			maelstroms = maelstroms + 1
		elseif mod:GetAbility():GetName() == "item_imba_mjollnir" then
			mod:GetAbility():SetSecondaryCharges(mjollnirs + 1)
			mjollnirs = mjollnirs + 1
		elseif mod:GetAbility():GetName() == "item_imba_jarnbjorn" then
			mod:GetAbility():SetSecondaryCharges(jarnbjorns + 1)
			jarnbjorns = jarnbjorns + 1
		end
	end
end

function modifier_item_imba_maelstrom:OnIntervalThink()
	self.bChainCooldown = false
	self:StartIntervalThink(-1)
end

function modifier_item_imba_maelstrom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,

		MODIFIER_EVENT_ON_ATTACK_LANDED,

		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_item_imba_maelstrom:GetModifierPreAttack_BonusDamage(keys)
	if IsServer() and keys.target and not keys.target:IsHero() and not keys.target:IsOther() and not keys.target:IsBuilding() and not string.find(keys.target:GetUnitName(), "npc_dota_lone_druid_bear") and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetParent():FindItemInInventory("item_imba_jarnbjorn") == self:GetAbility() then
		if not self:GetParent():IsRangedAttacker() then
			return self.bonus_damage + self.quelling_bonus
		else
			return self.bonus_damage + self.quelling_bonus_ranged
		end
	else
		return self.bonus_damage
	end
end

function modifier_item_imba_maelstrom:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_imba_maelstrom:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_imba_maelstrom:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_imba_maelstrom:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_imba_maelstrom:GetModifierAttackRangeBonus()
	if not self:GetParent():IsRangedAttacker() and
		((self:GetAbility():GetName() == "item_imba_maelstrom" and self:GetAbility():GetSecondaryCharges() == 1 and not self:GetParent():HasItemInInventory("item_imba_mjollnir") and not self:GetParent():HasItemInInventory("item_imba_jarnbjorn") and not self:GetParent():HasItemInInventory("item_imba_monkey_king_bar")) or
		(self:GetAbility():GetName() == "item_imba_mjollnir" and self:GetAbility():GetSecondaryCharges() == 1 and not self:GetParent():HasItemInInventory("item_imba_jarnbjorn") and not self:GetParent():HasItemInInventory("item_imba_monkey_king_bar")) or
		(self:GetAbility():GetName() == "item_imba_jarnbjorn" and self:GetAbility():GetSecondaryCharges() == 1 and not self:GetParent():HasItemInInventory("item_imba_monkey_king_bar"))) then
		return self.bonus_range
	end
end

function modifier_item_imba_maelstrom:OnAttackLanded(keys)
	-- Chain Lightning Logic
	if keys.attacker == self:GetParent() and self:GetParent():IsAlive() and not self.bChainCooldown and not self:GetParent():IsIllusion() and not keys.target:IsMagicImmune() and not keys.target:IsBuilding() and not keys.target:IsOther() and self:GetParent():GetTeamNumber() ~= keys.target:GetTeamNumber() and RollPseudoRandom(self.chain_chance, self:GetAbility()) then
		-- -- This line is if you don't want multiple of any Chain Lightning items stacking
		-- if self:GetCaster():HasModifier("modifier_item_imba_chain_lightning_cooldown") then return end

		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning")

		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_chain_lightning", {
			starting_unit_entindex = keys.target:entindex()
		})

		self.bChainCooldown = true

		self:StartIntervalThink(self.chain_cooldown)

		-- -- This line is if you don't want multiple of any Chain Lightning items stacking
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_chain_lightning_cooldown", {duration = self.chain_cooldown})
	end

	-- Cleave Logic (Jarnbjorn)
	if self:GetAbility():GetName() == "item_imba_jarnbjorn" and keys.attacker == self:GetParent() and not self:GetParent():IsRangedAttacker() and self:GetParent():IsAlive() and not self:GetParent():IsIllusion() and not keys.target:IsBuilding() and not keys.target:IsOther() and self:GetParent():GetTeamNumber() ~= keys.target:GetTeamNumber() then
		DoCleaveAttack(self:GetParent(), keys.target, ability, keys.damage * self.cleave_damage_percent / 100, self.cleave_starting_width, self.cleave_ending_width, self.cleave_distance, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf")
	end
end

-- This is just for Jarnbjorn and messing around with cast ranges between allies or trees
function modifier_item_imba_maelstrom:OnOrder(keys)
	if keys.unit == self:GetParent() and self:GetAbility():GetName() == "item_imba_jarnbjorn" then
		self:GetAbility().bTargetingTree = false
	end
end

-- I overwrote Maelstrom, but I'll leave the below code for...historical reasons. Delete it if you so see fit.

-- -----------------------------------------------------------------------------------------------------------
-- --	Mjollnir definition
-- -----------------------------------------------------------------------------------------------------------

-- if item_imba_mjollnir == nil then item_imba_mjollnir = class({}) end
-- LinkLuaModifier( "modifier_item_imba_mjollnir", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )					-- Owner's bonus attributes, stackable
-- LinkLuaModifier( "modifier_item_imba_mjollnir_counter", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )			-- Attack proc counter
-- LinkLuaModifier( "modifier_item_imba_mjollnir_static", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )			-- Static shield
-- LinkLuaModifier( "modifier_item_imba_mjollnir_static_counter", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )	-- Shield proc counter
-- LinkLuaModifier( "modifier_item_imba_mjollnir_slow", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )				-- Shield slow

-- function item_imba_mjollnir:GetIntrinsicModifierName()
-- return "modifier_item_imba_mjollnir"
-- end

-- function item_imba_mjollnir:GetAbilityTextureName()
-- return "item_mjollnir"
-- end

-- function item_imba_mjollnir:OnSpellStart()
-- if IsServer() then

-- -- Apply the modifier to the target
-- local target = self:GetCursorTarget()
-- target:AddNewModifier(target, self, "modifier_item_imba_mjollnir_static", {duration = self:GetSpecialValueFor("static_duration")})

-- -- Play cast sound
-- target:EmitSound("DOTA_Item.Mjollnir.Activate")
-- end
-- end

-- -----------------------------------------------------------------------------------------------------------
-- --	Mjollnir passive modifier (stackable)
-- -----------------------------------------------------------------------------------------------------------

-- if modifier_item_imba_mjollnir == nil then modifier_item_imba_mjollnir = class({}) end
-- function modifier_item_imba_mjollnir:IsHidden() return true end
-- function modifier_item_imba_mjollnir:IsDebuff() return false end
-- function modifier_item_imba_mjollnir:IsPurgable() return false end
-- function modifier_item_imba_mjollnir:IsPermanent() return true end

-- function modifier_item_imba_mjollnir:GetAttributes()
-- return MODIFIER_ATTRIBUTE_MULTIPLE
-- end

-- -- Declare modifier events/properties
-- function modifier_item_imba_mjollnir:DeclareFunctions()
-- local funcs = {
-- MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
-- MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
-- MODIFIER_EVENT_ON_ATTACK_LANDED,
-- }
-- return funcs
-- end

-- function modifier_item_imba_mjollnir:GetModifierPreAttack_BonusDamage()
-- return self:GetAbility():GetSpecialValueFor("bonus_damage") end

-- function modifier_item_imba_mjollnir:GetModifierAttackSpeedBonus_Constant()
-- return self:GetAbility():GetSpecialValueFor("bonus_as") end

-- -- On attack landed, roll for proc and apply stacks
-- function modifier_item_imba_mjollnir:OnAttackLanded( keys )
-- if IsServer() then
-- local attacker = self:GetParent()

-- -- If this attack is irrelevant, do nothing
-- if attacker ~= keys.attacker then
-- return
-- end

-- -- If this is an illusion, do nothing either
-- if attacker:IsIllusion() then
-- return
-- end

-- -- If the target is invalid, still do nothing
-- local target = keys.target
-- if (not target:IsHeroOrCreep()) or attacker:GetTeam() == target:GetTeam() then
-- return
-- end

-- -- All conditions met, stack the proc counter up
-- local ability = self:GetAbility()

-- -- zap the target's ass
-- local proc_chance = ability:GetSpecialValueFor("proc_chance")
-- if not keys.target:IsMagicImmune() and RollPseudoRandom(proc_chance, ability) then
-- LaunchLightning(attacker, target, ability, ability:GetSpecialValueFor("bounce_damage"), ability:GetSpecialValueFor("bounce_radius"))
-- end
-- end
-- end

-- -----------------------------------------------------------------------------------------------------------
-- --	Mjollnir static shield
-- -----------------------------------------------------------------------------------------------------------

-- if modifier_item_imba_mjollnir_static == nil then modifier_item_imba_mjollnir_static = class({}) end
-- function modifier_item_imba_mjollnir_static:IsHidden() return false end
-- function modifier_item_imba_mjollnir_static:IsDebuff() return false end
-- function modifier_item_imba_mjollnir_static:IsPurgable() return true end

-- -- Start playing sound and store ability parameters
-- function modifier_item_imba_mjollnir_static:OnCreated()
-- if IsServer() then
-- self:GetParent():EmitSound("DOTA_Item.Mjollnir.Loop")
-- self.static_cooldown = false

-- if not self.pfx then
-- local particle_name = "particles/items2_fx/mjollnir_shield.vpcf"

-- if CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetCaster():GetPlayerID())) and CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetCaster():GetPlayerID()))["maelstrom"]["effect1"] then
-- particle_name = CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetCaster():GetPlayerID()))["maelstrom"]["effect1"]
-- end

-- self.pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
-- ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
-- end
-- end
-- end

-- function modifier_item_imba_mjollnir_static:OnIntervalThink()
-- self.static_cooldown = false
-- self:StartIntervalThink(-1)
-- end

-- -- Stop playing sound and destroy the proc counter
-- function modifier_item_imba_mjollnir_static:OnDestroy()
-- if IsServer() then
-- StopSoundEvent("DOTA_Item.Mjollnir.Loop", self:GetParent())
-- self:GetParent():RemoveModifierByName("modifier_item_imba_mjollnir_static_counter")

-- if self.pfx then
-- ParticleManager:DestroyParticle(self.pfx, false)
-- ParticleManager:ReleaseParticleIndex(self.pfx)
-- end
-- end
-- end

-- -- Declare modifier events/properties
-- function modifier_item_imba_mjollnir_static:DeclareFunctions()
-- local funcs = {
-- MODIFIER_EVENT_ON_TAKEDAMAGE,
-- }
-- return funcs
-- end

-- -- On damage taken, count stacks and proc the static shield
-- function modifier_item_imba_mjollnir_static:OnTakeDamage( keys )
-- if IsServer() then
-- local shield_owner = self:GetParent()

-- -- If this damage event is irrelevant, do nothing
-- if shield_owner ~= keys.unit then
-- return end

-- -- If the attacker is invalid, do nothing either
-- if keys.attacker:GetTeam() == shield_owner:GetTeam() then
-- return end

-- -- All conditions met, stack the proc counter up
-- local ability = self:GetAbility()
-- -- If enough stacks accumulated, reset them and zap nearby enemies
-- local static_proc_chance = ability:GetSpecialValueFor("static_proc_chance")
-- local static_damage = ability:GetSpecialValueFor("static_damage")
-- local static_radius = ability:GetSpecialValueFor("static_radius")
-- local static_slow_duration = ability:GetSpecialValueFor("static_slow_duration")

-- if not self.static_cooldown and keys.damage >= 5 and RollPseudoRandom(static_proc_chance, ability) then
-- self.static_cooldown = true
-- self:StartIntervalThink(ability:GetSpecialValueFor("static_cooldown"))

-- -- Iterate through nearby enemies
-- local static_origin = shield_owner:GetAbsOrigin() + Vector(0, 0, 100)
-- local nearby_enemies = FindUnitsInRadius(shield_owner:GetTeamNumber(), shield_owner:GetAbsOrigin(), nil, static_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
-- for _, enemy in pairs(nearby_enemies) do

-- -- Play particle
-- local particle_name = "particles/item/mjollnir/static_lightning_bolt.vpcf"

-- if CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetCaster():GetPlayerID())) and CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetCaster():GetPlayerID()))["maelstrom"]["effect2"] then
-- particle_name = CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetCaster():GetPlayerID()))["maelstrom"]["effect2"]
-- end

-- local static_pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, shield_owner)
-- ParticleManager:SetParticleControlEnt(static_pfx, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
-- ParticleManager:SetParticleControl(static_pfx, 1, static_origin)
-- ParticleManager:ReleaseParticleIndex(static_pfx)

-- -- Apply damage
-- ApplyDamage({attacker = shield_owner, victim = enemy, ability = ability, damage = static_damage, damage_type = DAMAGE_TYPE_MAGICAL})

-- -- Apply slow modifier
-- enemy:AddNewModifier(shield_owner, ability, "modifier_item_imba_mjollnir_slow", {duration = static_slow_duration})
-- end

-- -- Play hit sound if at least one enemy was hit
-- if #nearby_enemies > 0 then
-- shield_owner:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
-- end
-- end
-- end
-- end

-- -----------------------------------------------------------------------------------------------------------
-- --	Mjollnir passive modifier (stackable)
-- -----------------------------------------------------------------------------------------------------------

-- if modifier_item_imba_mjollnir_slow == nil then modifier_item_imba_mjollnir_slow = class({}) end
-- function modifier_item_imba_mjollnir_slow:IsHidden() return false end
-- function modifier_item_imba_mjollnir_slow:IsDebuff() return true end
-- function modifier_item_imba_mjollnir_slow:IsPurgable() return true end

-- function modifier_item_imba_mjollnir_slow:OnCreated()
-- if not self:GetAbility() then self:Destroy() return end

-- self.static_slow	= self:GetAbility():GetSpecialValueFor("static_slow")
-- end

-- -- Declare modifier events/properties
-- function modifier_item_imba_mjollnir_slow:DeclareFunctions()
-- local funcs = {
-- MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
-- MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
-- }
-- return funcs
-- end

-- function modifier_item_imba_mjollnir_slow:GetModifierMoveSpeedBonus_Percentage()
-- return self.static_slow
-- end

-- function modifier_item_imba_mjollnir_slow:GetModifierAttackSpeedBonus_Constant()
-- return self.static_slow
-- end

-- -----------------------------------------------------------------------------------------------------------
-- --	Jarnbjorn definition
-- -----------------------------------------------------------------------------------------------------------

-- if item_imba_jarnbjorn == nil then item_imba_jarnbjorn = class({}) end
-- LinkLuaModifier( "modifier_item_imba_jarnbjorn", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )					-- Owner's bonus attributes, stackable
-- LinkLuaModifier( "modifier_item_imba_jarnbjorn_counter", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )			-- Attack proc counter
-- LinkLuaModifier( "modifier_item_imba_jarnbjorn_static", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )			-- Static shield
-- LinkLuaModifier( "modifier_item_imba_jarnbjorn_static_counter", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )	-- Shield proc counter
-- LinkLuaModifier( "modifier_item_imba_jarnbjorn_slow", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )				-- Shield slow

-- function item_imba_jarnbjorn:GetIntrinsicModifierName()
-- return "modifier_item_imba_jarnbjorn"
-- end

-- function item_imba_jarnbjorn:GetAbilityTextureName()
-- return "imba_jarnbjorn"
-- end

-- function item_imba_jarnbjorn:GetCooldown(level)
-- if IsClient() then
-- return self.BaseClass.GetCooldown(self, level)
-- elseif self:GetCursorTarget() and (self:GetCursorTarget().CutDown or self:GetCursorTarget():IsOther()) then
-- return self:GetSpecialValueFor("tree_cooldown")
-- else
-- return self.BaseClass.GetCooldown(self, level)
-- end
-- end

-- function item_imba_jarnbjorn:OnSpellStart()
-- if IsServer() then
-- local target = self:GetCursorTarget()

-- if target.GetUnitName == nil then
-- self:RefundManaCost()
-- target:CutDown(-1)
-- else
-- -- Play cast sound
-- target:EmitSound("DOTA_Item.Mjollnir.Activate")
-- target:AddNewModifier(target, self, "modifier_item_imba_jarnbjorn_static", {duration = self:GetSpecialValueFor("static_duration")})
-- end
-- end
-- end

-- -----------------------------------------------------------------------------------------------------------
-- --	Jarnbjorn passive modifier (stackable)
-- -----------------------------------------------------------------------------------------------------------

-- if modifier_item_imba_jarnbjorn == nil then modifier_item_imba_jarnbjorn = class({}) end
-- function modifier_item_imba_jarnbjorn:IsHidden() return true end
-- function modifier_item_imba_jarnbjorn:IsDebuff() return false end
-- function modifier_item_imba_jarnbjorn:IsPurgable() return false end
-- function modifier_item_imba_jarnbjorn:IsPermanent() return true end

-- function modifier_item_imba_jarnbjorn:GetTexture()
-- return "modifiers/imba_jarnbjorn"
-- end

-- function modifier_item_imba_jarnbjorn:GetAttributes()
-- return MODIFIER_ATTRIBUTE_MULTIPLE
-- end

-- -- Declare modifier events/properties
-- function modifier_item_imba_jarnbjorn:DeclareFunctions()
-- local funcs = {
-- MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
-- MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
-- MODIFIER_EVENT_ON_ATTACK_LANDED,
-- MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
-- MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
-- }
-- return funcs
-- end

-- function modifier_item_imba_jarnbjorn:GetModifierPreAttack_BonusDamage()
-- return self:GetAbility():GetSpecialValueFor("bonus_damage")
-- end

-- function modifier_item_imba_jarnbjorn:GetModifierAttackSpeedBonus_Constant()
-- return self:GetAbility():GetSpecialValueFor("bonus_as")
-- end

-- function modifier_item_imba_jarnbjorn:GetModifierConstantHealthRegen()
-- return self:GetAbility():GetSpecialValueFor("bonus_hp_regen")
-- end

-- function modifier_item_imba_jarnbjorn:GetModifierConstantManaRegen()
-- return self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
-- end

-- -- On attack landed, roll for proc and apply stacks
-- function modifier_item_imba_jarnbjorn:OnAttackLanded( keys )
-- if IsServer() then
-- local attacker = self:GetParent()
-- local damage = keys.damage

-- -- If this attack is irrelevant, do nothing
-- if attacker ~= keys.attacker then
-- return
-- end

-- -- If this is an illusion, do nothing either
-- if attacker:IsIllusion() then
-- return
-- end

-- -- If the target is invalid, still do nothing
-- local target = keys.target
-- if (not target:IsHeroOrCreep()) or attacker:GetTeam() == target:GetTeam() then
-- return
-- end

-- -- All conditions met, stack the proc counter up
-- local ability = self:GetAbility()

-- -- zap the target's ass
-- local proc_chance = ability:GetSpecialValueFor("proc_chance")
-- if not keys.target:IsMagicImmune() and RollPseudoRandom(proc_chance, ability) then
-- LaunchLightning(attacker, target, ability, ability:GetSpecialValueFor("bounce_damage"), ability:GetSpecialValueFor("bounce_radius"))
-- end

-- -- If this a ranged hero, do not cleave
-- if attacker:IsRangedAttacker() then
-- return
-- end

-- -- Only apply if the attacker is the parent of the buff, and the victim is on the opposing team.
-- if self:GetParent() == attacker and self:GetParent():GetTeamNumber() ~= target:GetTeamNumber() then
-- -- Add explosion particle
-- local explosion_pfx = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_weapon_bfury/faceless_void_weapon_bfury_cleave_b.vpcf", PATTACH_ABSORIGIN, target)
-- ParticleManager:SetParticleControl(explosion_pfx, 0, target:GetAbsOrigin())
-- ParticleManager:SetParticleControl(explosion_pfx, 3, target:GetAbsOrigin())
-- ParticleManager:ReleaseParticleIndex(explosion_pfx)

-- -- Calculate bonus damage
-- local splash_damage = damage * (ability:GetSpecialValueFor("splash_damage_pct") / 100)

-- DoCleaveAttack( attacker, keys.target, ability, splash_damage, ability:GetSpecialValueFor("cleave_start"), ability:GetSpecialValueFor("cleave_end"), ability:GetSpecialValueFor("splash_range"), "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf" )
-- end
-- end
-- end

-- -----------------------------------------------------------------------------------------------------------
-- --	jarnbjorn static shield
-- -----------------------------------------------------------------------------------------------------------

-- if modifier_item_imba_jarnbjorn_static == nil then modifier_item_imba_jarnbjorn_static = class({}) end
-- function modifier_item_imba_jarnbjorn_static:IsHidden() return false end
-- function modifier_item_imba_jarnbjorn_static:IsDebuff() return false end
-- function modifier_item_imba_jarnbjorn_static:IsPurgable() return true end

-- function modifier_item_imba_jarnbjorn_static:GetTexture()
-- return "modifiers/imba_jarnbjorn"
-- end

-- -- Start playing sound and store ability parameters
-- function modifier_item_imba_jarnbjorn_static:OnCreated()
-- if IsServer() then
-- self:GetParent():EmitSound("DOTA_Item.Mjollnir.Loop")
-- self.static_cooldown = false

-- if not self.pfx then
-- local particle_name = "particles/items2_fx/mjollnir_shield.vpcf"

-- if CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetCaster():GetPlayerID())) and CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetCaster():GetPlayerID()))["maelstrom"]["effect1"] then
-- particle_name = CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetCaster():GetPlayerID()))["maelstrom"]["effect1"]
-- end

-- self.pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
-- ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
-- end
-- end
-- end

-- function modifier_item_imba_jarnbjorn_static:OnIntervalThink()
-- self.static_cooldown = false
-- self:StartIntervalThink(-1)
-- end

-- -- Stop playing sound and destroy the proc counter
-- function modifier_item_imba_jarnbjorn_static:OnDestroy()
-- if IsServer() then
-- StopSoundEvent("DOTA_Item.Mjollnir.Loop", self:GetParent())
-- self:GetParent():RemoveModifierByName("modifier_item_imba_jarnbjorn_static_counter")

-- if self.pfx then
-- ParticleManager:DestroyParticle(self.pfx, false)
-- ParticleManager:ReleaseParticleIndex(self.pfx)
-- end
-- end
-- end

-- -- Declare modifier events/properties
-- function modifier_item_imba_jarnbjorn_static:DeclareFunctions()
-- local funcs = {
-- MODIFIER_EVENT_ON_TAKEDAMAGE,
-- }
-- return funcs
-- end

-- -- On damage taken, count stacks and proc the static shield
-- function modifier_item_imba_jarnbjorn_static:OnTakeDamage( keys )
-- if IsServer() then
-- local shield_owner = self:GetParent()

-- -- If this damage event is irrelevant, do nothing
-- if shield_owner ~= keys.unit then
-- return end

-- -- If the attacker is invalid, do nothing either
-- if keys.attacker:GetTeam() == shield_owner:GetTeam() then
-- return end

-- -- All conditions met, stack the proc counter up
-- local ability = self:GetAbility()
-- -- If enough stacks accumulated, reset them and zap nearby enemies
-- local static_proc_chance = ability:GetSpecialValueFor("static_proc_chance")
-- local static_damage = ability:GetSpecialValueFor("static_damage")
-- local static_radius = ability:GetSpecialValueFor("static_radius")
-- local static_slow_duration = ability:GetSpecialValueFor("static_slow_duration")
-- if not self.static_cooldown and keys.damage >= 5 and RollPseudoRandom(static_proc_chance, ability) then
-- self.static_cooldown = true
-- self:StartIntervalThink(ability:GetSpecialValueFor("static_cooldown"))

-- -- Iterate through nearby enemies
-- local static_origin = shield_owner:GetAbsOrigin() + Vector(0, 0, 100)
-- local nearby_enemies = FindUnitsInRadius(shield_owner:GetTeamNumber(), shield_owner:GetAbsOrigin(), nil, static_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
-- for _, enemy in pairs(nearby_enemies) do

-- -- Play particle
-- local particle_name = "particles/item/mjollnir/static_lightning_bolt.vpcf"

-- if CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetCaster():GetPlayerID())) and CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetCaster():GetPlayerID()))["maelstrom"]["effect2"] then
-- particle_name = CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetCaster():GetPlayerID()))["maelstrom"]["effect2"]
-- end

-- local static_pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, shield_owner)
-- ParticleManager:SetParticleControlEnt(static_pfx, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
-- ParticleManager:SetParticleControl(static_pfx, 1, static_origin)
-- ParticleManager:ReleaseParticleIndex(static_pfx)

-- -- Apply damage
-- ApplyDamage({attacker = shield_owner, victim = enemy, ability = ability, damage = static_damage, damage_type = DAMAGE_TYPE_MAGICAL})

-- -- Apply slow modifier
-- enemy:AddNewModifier(shield_owner, ability, "modifier_item_imba_jarnbjorn_slow", {duration = static_slow_duration})
-- end

-- -- Play hit sound if at least one enemy was hit
-- if #nearby_enemies > 0 then
-- shield_owner:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
-- end
-- end
-- end
-- end

-- -----------------------------------------------------------------------------------------------------------
-- --	Jarnbjorn passive modifier (stackable)
-- -----------------------------------------------------------------------------------------------------------

-- if modifier_item_imba_jarnbjorn_slow == nil then modifier_item_imba_jarnbjorn_slow = class({}) end
-- function modifier_item_imba_jarnbjorn_slow:IsHidden() return false end
-- function modifier_item_imba_jarnbjorn_slow:IsDebuff() return true end
-- function modifier_item_imba_jarnbjorn_slow:IsPurgable() return true end

-- function modifier_item_imba_jarnbjorn_slow:GetTexture()
-- return "modifiers/imba_jarnbjorn"
-- end

-- function modifier_item_imba_jarnbjorn_slow:OnCreated()
-- if not self:GetAbility() then self:Destroy() return end

-- self.static_slow	= self:GetAbility():GetSpecialValueFor("static_slow")
-- end

-- -- Declare modifier events/properties
-- function modifier_item_imba_jarnbjorn_slow:DeclareFunctions()
-- local funcs = {
-- MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
-- MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
-- }
-- return funcs
-- end

-- function modifier_item_imba_jarnbjorn_slow:GetModifierMoveSpeedBonus_Percentage()
-- return self.static_slow
-- end

-- function modifier_item_imba_jarnbjorn_slow:GetModifierAttackSpeedBonus_Constant()
-- return self.static_slow
-- end

-- -----------------------------------------------------------------------------------------------------------
-- --	Lightning proc functions
-- -----------------------------------------------------------------------------------------------------------

-- -- Initial launch + main loop
-- function LaunchLightning(caster, target, ability, damage, bounce_radius)

-- -- Parameters
-- local targets_hit = { target }
-- local search_sources = { target	}

-- -- Play initial sound
-- caster:EmitSound("Item.Maelstrom.Chain_Lightning")

-- -- Play first bounce sound
-- target:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")

-- ZapThem(caster, ability, caster, target, damage)

-- -- While there are potential sources, keep looping
-- while #search_sources > 0 do

-- -- Loop through every potential source this iteration
-- for potential_source_index, potential_source in pairs(search_sources) do

-- local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), potential_source:GetAbsOrigin(), nil, bounce_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

-- for _, potential_target in pairs(nearby_enemies) do

-- -- Check if this target was already hit
-- local already_hit = false
-- for _, hit_target in pairs(targets_hit) do
-- if potential_target == hit_target then
-- already_hit = true
-- break
-- end
-- end

-- -- If not, zap it from this source, and mark it as a hit target and potential future source
-- if not already_hit then
-- ZapThem(caster, ability, potential_source, potential_target, damage)
-- targets_hit[#targets_hit+1] = potential_target
-- search_sources[#search_sources+1] = potential_target
-- end
-- end

-- -- Remove this potential source
-- table.remove(search_sources, potential_source_index)
-- end
-- end
-- end

-- -- One bounce. Particle + damage
-- function ZapThem(caster, ability, source, target, damage)
-- local particle_name = "particles/items_fx/chain_lightning.vpcf"

-- if not caster.GetPlayerID and caster:GetOwner() then
-- caster = caster:GetOwner()
-- end

-- if CustomNetTables:GetTableValue("battlepass_item_effects", tostring(caster:GetPlayerID())) and CustomNetTables:GetTableValue("battlepass_item_effects", tostring(caster:GetPlayerID()))["maelstrom"]["effect3"] then
-- particle_name = CustomNetTables:GetTableValue("battlepass_item_effects", tostring(caster:GetPlayerID()))["maelstrom"]["effect3"]
-- end

-- local bounce_pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, source)
-- ParticleManager:SetParticleControlEnt(bounce_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
-- ParticleManager:SetParticleControlEnt(bounce_pfx, 1, source, PATTACH_POINT_FOLLOW, "attach_hitloc", source:GetAbsOrigin(), true)
-- ParticleManager:SetParticleControl(bounce_pfx, 2, Vector(1, 1, 1))
-- ParticleManager:ReleaseParticleIndex(bounce_pfx)

-- ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
-- end
