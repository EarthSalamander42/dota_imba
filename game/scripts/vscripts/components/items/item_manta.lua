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
-- Author:
-- EarthSalamander #42

LinkLuaModifier("modifier_item_manta_passive", "components/items/item_manta", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_manta_invulnerable", "components/items/item_manta", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_yasha_active", "components/items/item_swords", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_manta_abyss_boost", "components/items/item_manta", LUA_MODIFIER_MOTION_NONE)

item_imba_manta                      = item_imba_manta or class({})
modifier_item_manta_passive          = modifier_item_manta_passive or class({})
modifier_manta_invulnerable          = modifier_manta_invulnerable or class({})
modifier_item_imba_manta_abyss_boost = modifier_item_imba_manta_abyss_boost or class({})

item_imba_manta_2                    = item_imba_manta

function item_imba_manta:GetIntrinsicModifierName()
	return "modifier_item_manta_passive"
end

function item_imba_manta:GetCooldown()
	if IsClient() then
		if self:GetCaster():IsRangedAttacker() then
			return self:GetSpecialValueFor("cooldown_ranged_tooltip")
		else
			return self:GetSpecialValueFor("cooldown_melee")
		end
	else
		if (self.GetCursorTarget and self:GetCursorTarget() and self:GetCursorTarget():IsRangedAttacker()) or (self:GetCaster():IsRangedAttacker() and self:GetName() == "item_imba_manta") then
			return self:GetSpecialValueFor("cooldown_ranged_tooltip")
		else
			return self:GetSpecialValueFor("cooldown_melee")
		end
	end
end

function item_imba_manta:OnSpellStart()
	if self:GetName() == "item_imba_manta" then
		self:GetCaster():EmitSound("DOTA_Item.Manta.Activate")
		self:GetCaster():Purge(false, true, false, false, false)
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_manta_invulnerable", { duration = self:GetSpecialValueFor("invuln_duration") })
	elseif self:GetName() == "item_imba_manta_2" then
		local target = self:GetCursorTarget()

		target:EmitSound("DOTA_Item.Manta.Activate")

		if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			self:GetCaster():Purge(false, true, false, false, false)
		else
			self:GetCaster():Purge(true, false, false, false, false)
		end

		target:AddNewModifier(self:GetCaster(), self, "modifier_manta_invulnerable", { duration = self:GetSpecialValueFor("invuln_duration") })
	end
end

---------------------------------
-- MODIFIER_ITEM_MANTA_PASSIVE --
---------------------------------

function modifier_item_manta_passive:IsHidden() return true end

function modifier_item_manta_passive:IsPurgable() return false end

function modifier_item_manta_passive:RemoveOnDeath() return false end

function modifier_item_manta_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_manta_passive:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	if not self:GetAbility() then return end

	self.bonus_strength       = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.bonus_agility        = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_intellect      = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.bonus_attack_speed   = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_movement_speed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
end

function modifier_item_manta_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,

		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_item_manta_passive:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_manta_passive:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_manta_passive:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_manta_passive:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_manta_passive:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_movement_speed
end

function modifier_item_manta_passive:OnDeath(keys)
	if self:GetAbility() and self:GetAbility():GetName() == "item_imba_manta_2" and keys.unit == self:GetParent() and self:GetParent():IsRealHero() and keys.attacker ~= self:GetParent() and (not self:GetParent().IsReincarnating or (self:GetParent().IsReincarnating and not self:GetParent():IsReincarnating())) and (keys.attacker:IsRealHero() or keys.attacker:IsClone() or keys.attacker:IsTempestDouble() or keys.attacker:IsIllusion()) then
		if not keys.attacker:IsRangedAttacker() then
			self.outgoing_damage = self:GetAbility():GetSpecialValueFor("images_do_damage_percent_melee")
			self.incoming_damage = self:GetAbility():GetSpecialValueFor("images_take_damage_percent_melee")
		else
			self.outgoing_damage = self:GetAbility():GetSpecialValueFor("images_do_damage_percent_ranged")
			self.incoming_damage = self:GetAbility():GetSpecialValueFor("images_take_damage_percent_ranged")
		end

		if keys.attacker:GetHullRadius() > 8 then
			self.distance_multiplier = 108
		else
			self.distance_multiplier = 72
		end

		self.death_illusions = CreateIllusions(self:GetCaster(), keys.attacker:GetOwner():GetAssignedHero(),
			{
				outgoing_damage           = self.outgoing_damage,
				incoming_damage           = self.incoming_damage,
				bounty_base               = keys.attacker:GetLevel() * 2,
				bounty_growth             = nil,
				outgoing_damage_structure = nil,
				outgoing_damage_roshan    = nil,
				duration                  = self:GetAbility():GetSpecialValueFor("tooltip_illusion_duration")
			}
			, 1, self.distance_multiplier, false, true)

		for _, illusion in pairs(self.death_illusions) do
			illusion:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_manta_abyss_boost", { target_entindex = keys.attacker:entindex() })
		end
	end
end

---------------------------------
-- MODIFIER_MANTA_INVULNERABLE --
---------------------------------

function modifier_manta_invulnerable:IsHidden() return true end

function modifier_manta_invulnerable:IsPurgable() return false end

function modifier_manta_invulnerable:GetEffectName()
	return "particles/items2_fx/manta_phase.vpcf"
end

function modifier_manta_invulnerable:OnDestroy()
	if not IsServer() or not self:GetParent():IsAlive() or not self:GetAbility() then return end

	-- "Orders the user to stop after the split time, canceling all queued orders, and orders given during the split time."
	if self:GetParent() == self:GetCaster() then
		self:GetParent():Stop()
	end

	-- "Provides 1000 radius ground vision for a second upon cast."
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 1000, 1, false)

	if self:GetAbility().manta_illusions then
		for _, illusion in pairs(self:GetAbility().manta_illusions) do
			if illusion and not illusion:IsNull() then
				illusion:ForceKill(false)
			end
		end
	end

	-- Just in case people go full asshole mode and try to make a billion illusions with refreshers and multiple Manta Styles or something...
	for _, mod in pairs(self:GetCaster():FindAllModifiersByName("modifier_item_manta_passive")) do
		if mod:GetAbility() and mod:GetAbility() ~= self:GetAbility() and mod:GetAbility().manta_illusions then
			for _, illusion in pairs(mod:GetAbility().manta_illusions) do
				if illusion and not illusion:IsNull() then
					illusion:ForceKill(false)
				end
			end
		end
	end

	self:GetAbility().manta_illusions = {}

	if not self:GetParent():IsRangedAttacker() then
		self.outgoing_damage = self:GetAbility():GetSpecialValueFor("images_do_damage_percent_melee")
		self.incoming_damage = self:GetAbility():GetSpecialValueFor("images_take_damage_percent_melee")
	else
		self.outgoing_damage = self:GetAbility():GetSpecialValueFor("images_do_damage_percent_ranged")
		self.incoming_damage = self:GetAbility():GetSpecialValueFor("images_take_damage_percent_ranged")
	end

	-- "The distance in between each is 108 range if the hero has a collision size of 24, and 72 if the collision size is 8."
	if self:GetParent():GetHullRadius() > 8 then
		self.distance_multiplier = 108
	else
		self.distance_multiplier = 72
	end

	self.created_manta_illusions = CreateIllusions(self:GetCaster(), self:GetParent():GetOwner():GetAssignedHero(),
		{
			outgoing_damage           = self.outgoing_damage,
			incoming_damage           = self.incoming_damage,
			bounty_base               = self:GetParent():GetLevel() * 2,
			bounty_growth             = nil,
			outgoing_damage_structure = nil,
			outgoing_damage_roshan    = nil,
			duration                  = self:GetAbility():GetSpecialValueFor("tooltip_illusion_duration")
		}
		, self:GetAbility():GetSpecialValueFor("images_count"), self.distance_multiplier, true, true)

	if self:GetParent():HasModifier("modifier_item_imba_yasha_active") then
		self:GetParent():FindModifierByName("modifier_item_imba_yasha_active"):Destroy()
	end

	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		self:GetParent():EmitSound("DOTA_Item.IronTalon.Activate")

		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_yasha_active", { duration = self:GetAbility():GetSpecialValueFor("active_duration") })
	end

	for _, unit in pairs(self.created_manta_illusions) do
		if unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			unit:EmitSound("DOTA_Item.IronTalon.Activate")

			unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_yasha_active", { duration = self:GetAbility():GetSpecialValueFor("active_duration") })

			if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
				unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_manta_abyss_boost", { target_entindex = self:GetParent():entindex() })
			end
		end

		if unit:IsIllusion() then
			table.insert(self:GetAbility().manta_illusions, unit)
		end
	end
end

function modifier_manta_invulnerable:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE]      = true,
		[MODIFIER_STATE_NO_HEALTH_BAR]     = true,
		[MODIFIER_STATE_STUNNED]           = true,
		[MODIFIER_STATE_OUT_OF_GAME]       = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end

------------------------------------------
-- MODIFIER_ITEM_IMBA_MANTA_ABYSS_BOOST --
------------------------------------------

function modifier_item_imba_manta_abyss_boost:IsPurgable() return false end

function modifier_item_imba_manta_abyss_boost:OnCreated(keys)
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	self.abyss_boost_pct = self:GetAbility():GetSpecialValueFor("abyss_boost_pct")

	if not IsServer() then return end

	self.target = EntIndexToHScript(keys.target_entindex)

	self:OnIntervalThink()
	self:StartIntervalThink(0.5)
end

function modifier_item_imba_manta_abyss_boost:OnIntervalThink()
	if not self:GetParent():IsIllusion() then
		self:StartIntervalThink(-1)
		self:Destroy()
	end

	self:SetStackCount((self.target:GetAverageTrueAttackDamage(self.target) - (self.target:GetBaseDamageMin() + self.target:GetBaseDamageMax()) * 0.5) * self.abyss_boost_pct / 100)
end

function modifier_item_imba_manta_abyss_boost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_item_imba_manta_abyss_boost:GetModifierBaseAttack_BonusDamage()
	return self:GetStackCount()
end

function modifier_item_imba_manta_abyss_boost:OnTooltip()
	return self.abyss_boost_pct
end
