-- Creator:
--	   AltiV, April 21st, 2019

LinkLuaModifier("modifier_imba_chen_penitence", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_chen_penitence_buff", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_chen_penitence_remnants", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_chen_divine_favor", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_chen_divine_favor_aura", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_chen_divine_favor_aura_buff", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_chen_holy_persuasion", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_chen_holy_persuasion_tracker", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_chen_holy_persuasion_counter", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_chen_holy_persuasion_teleport", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_chen_holy_persuasion_immortalized", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_chen_holy_persuasion_immortalized_tracker", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_chen_holy_persuasion_immortalized_counter", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_chen_hand_of_god_overheal", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)

imba_chen_penitence                                     = class({})
modifier_imba_chen_penitence                            = class({})
modifier_imba_chen_penitence_buff                       = class({})
modifier_imba_chen_penitence_remnants                   = modifier_imba_chen_penitence_remnants or class({})

imba_chen_divine_favor                                  = class({})
modifier_imba_chen_divine_favor                         = class({})
modifier_imba_chen_divine_favor_aura                    = class({})
modifier_imba_chen_divine_favor_aura_buff               = class({})

imba_chen_holy_persuasion                               = class({})
modifier_imba_chen_holy_persuasion                      = class({})
modifier_imba_chen_holy_persuasion_tracker              = class({})
modifier_imba_chen_holy_persuasion_counter              = class({})
modifier_imba_chen_holy_persuasion_teleport             = class({})
modifier_imba_chen_holy_persuasion_immortalized         = class({})
modifier_imba_chen_holy_persuasion_immortalized_tracker = class({})
modifier_imba_chen_holy_persuasion_immortalized_counter = class({})

imba_chen_test_of_faith                                 = class({})

imba_chen_hand_of_god                                   = class({})
modifier_imba_chen_hand_of_god_overheal                 = class({})

---------------
-- PENITENCE --
---------------

function imba_chen_penitence:OnSpellStart()
	if not IsServer() then return end

	if self:GetCaster():GetName() == "npc_dota_hero_chen" and RollPercentage(50) then
		self:GetCaster():EmitSound("chen_chen_ability_penit_0" .. RandomInt(2, 3))
	end

	self:GetCaster():EmitSound("Hero_Chen.PenitenceCast")

	local projectile =
	{
		Target            = self:GetCursorTarget(),
		Source            = self:GetCaster(),
		Ability           = self,
		EffectName        = "particles/units/heroes/hero_chen/chen_penitence_proj.vpcf",
		iMoveSpeed        = self:GetSpecialValueFor("speed"),
		vSourceLoc        = self:GetCaster():GetAbsOrigin(),
		bDrawsOnMinimap   = false,
		bDodgeable        = true,
		bIsAttack         = false,
		bVisibleToEnemies = true,
		bReplaceExisting  = false,
		flExpireTime      = GameRules:GetGameTime() + 20,
		bProvidesVision   = false,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 -- Hmm...
	}

	ProjectileManager:CreateTrackingProjectile(projectile)
end

function imba_chen_penitence:OnProjectileHit_ExtraData(hTarget, vLocation, kv)
	if not IsServer() or not hTarget then return end

	-- Trigger spell absorb if applicable
	if hTarget:TriggerSpellAbsorb(self) then
		return nil
	end

	hTarget:EmitSound("Hero_Chen.PenitenceImpact")

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_penitence.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:ReleaseParticleIndex(particle)

	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_imba_chen_penitence", { duration = self:GetSpecialValueFor("duration") * (1 - hTarget:GetStatusResistance()) })

	if self:GetCaster():HasTalent("special_bonus_imba_chen_remnants_of_penitence") then
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_imba_chen_penitence_remnants", { duration = self:GetSpecialValueFor("duration") * (1 - hTarget:GetStatusResistance()) })
	end
end

------------------------
-- PENITENCE MODIFIER --
------------------------

function modifier_imba_chen_penitence:GetEffectName()
	return "particles/units/heroes/hero_chen/chen_penitence_debuff.vpcf"
end

function modifier_imba_chen_penitence:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.bonus_movement_speed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
	self.buff_duration        = self:GetAbility():GetSpecialValueFor("buff_duration")
end

function modifier_imba_chen_penitence:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,

		MODIFIER_EVENT_ON_ATTACK_START
	}
end

function modifier_imba_chen_penitence:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_movement_speed
end

function modifier_imba_chen_penitence:OnAttackStart(keys)
	if not IsServer() then return end

	if keys.target == self:GetParent() and keys.attacker:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		keys.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_chen_penitence_buff", { duration = self.buff_duration or 2 })
	end
end

-----------------------------
-- PENITENCE BUFF MODIFIER --
-----------------------------

function modifier_imba_chen_penitence_buff:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")

	if self:GetParent():IsCreep() then
		self.bonus_attack_speed = self.bonus_attack_speed * self:GetAbility():GetSpecialValueFor("creep_mult")
	end
end

function modifier_imba_chen_penitence_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_imba_chen_penitence_buff:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

-------------------------------------------
-- MODIFIER_IMBA_CHEN_PENITENCE_REMNANTS --
-------------------------------------------

function modifier_imba_chen_penitence_remnants:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_imba_chen_penitence_remnants:GetModifierIncomingDamage_Percentage(keys)
	return self:GetCaster():FindTalentValue("special_bonus_imba_chen_remnants_of_penitence")
end

------------------
-- DIVINE FAVOR --
------------------

function imba_chen_divine_favor:GetIntrinsicModifierName()
	return "modifier_imba_chen_divine_favor_aura"
end

function imba_chen_divine_favor:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_AURA + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end

function imba_chen_divine_favor:GetCooldown(iLevel)
	return self.BaseClass.GetCooldown(self, iLevel) - self:GetCaster():FindTalentValue("special_bonus_imba_chen_divine_favor_cd_reduction")
end

function imba_chen_divine_favor:OnSpellStart()
	if not IsServer() then return end

	-- This can be WAY more efficient but my brain is dead right now
	if self:GetCaster():GetName() == "npc_dota_hero_chen" then
		if RollPercentage(50) then
			-- Initialize the responses table
			if not self.responses then
				self.responses =
				{
					["chen_chen_ability_holyp_01"] = 0,
					["chen_chen_move_07"] = 0
				}
			end

			-- Check if 120 seconds has passed betewen either of the caster responses
			if self.responses["chen_chen_ability_holyp_01"] == 0 or GameRules:GetDOTATime(true, true) - self.responses["chen_chen_ability_holyp_01"] >= 120 then
				self:GetCaster():EmitSound("chen_chen_ability_holyp_01")
				self.responses["chen_chen_ability_holyp_01"] = GameRules:GetDOTATime(true, true)
			elseif self.responses["chen_chen_move_07"] == 0 or GameRules:GetDOTATime(true, true) - self.responses["chen_chen_move_07"] >= 120 then
				self:GetCaster():EmitSound("chen_chen_move_07")
				self.responses["chen_chen_move_07"] = GameRules:GetDOTATime(true, true)
			end
		end
	end

	self:GetCaster():EmitSound("Hero_Chen.DivineFavor.Cast")

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_divine_favor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCursorTarget())
	ParticleManager:ReleaseParticleIndex(particle)

	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_chen_divine_favor", { duration = self:GetSpecialValueFor("duration") })
end

---------------------------
-- DIVINE FAVOR MODIFIER --
---------------------------

function modifier_imba_chen_divine_favor:GetEffectName()
	return "particles/units/heroes/hero_chen/chen_divine_favor_buff.vpcf"
end

function modifier_imba_chen_divine_favor:OnCreated()
	-- AbilitySpecials
	self.heal_amp          = self:GetAbility():GetSpecialValueFor("heal_amp")
	self.heal_rate         = self:GetAbility():GetSpecialValueFor("heal_rate")
	self.damage_bonus      = self:GetAbility():GetSpecialValueFor("damage_bonus")
	self.creep_damage_mult = self:GetAbility():GetSpecialValueFor("creep_damage_mult")
end

function modifier_imba_chen_divine_favor:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,

		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE, -- IMBAfication: Pure Devotion

		MODIFIER_PROPERTY_TOOLTIP
	}
end

-- function modifier_imba_chen_divine_favor:GetModifierHPRegenAmplify_Percentage()
-- return self.heal_amp
-- end

function modifier_imba_chen_divine_favor:Custom_AllHealAmplify_Percentage()
	return self.heal_amp
end

function modifier_imba_chen_divine_favor:GetModifierConstantHealthRegen()
	return self.heal_rate
end

function modifier_imba_chen_divine_favor:GetModifierPreAttack_BonusDamage()
	if not self:GetParent():IsHero() then
		return self.damage_bonus * self.creep_damage_mult
	else
		return self.damage_bonus
	end
end

function modifier_imba_chen_divine_favor:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_imba_chen_divine_favor:OnTooltip()
	return self.heal_amp
end

--------------------------------
-- DIVINE FAVOR AURA MODIFIER --
--------------------------------

function modifier_imba_chen_divine_favor_aura:IsHidden() return true end

function modifier_imba_chen_divine_favor_aura:IsAura() return true end

function modifier_imba_chen_divine_favor_aura:IsAuraActiveOnDeath() return false end

function modifier_imba_chen_divine_favor_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end

function modifier_imba_chen_divine_favor_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end

function modifier_imba_chen_divine_favor_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_imba_chen_divine_favor_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_imba_chen_divine_favor_aura:GetModifierAura() return "modifier_imba_chen_divine_favor_aura_buff" end

function modifier_imba_chen_divine_favor_aura:GetAuraEntityReject(hTarget) return self:GetCaster():PassivesDisabled() or (not hTarget.GetPlayerID and not hTarget:GetOwnerEntity()) or hTarget:HasModifier("modifier_imba_chen_divine_favor") end

-------------------------------------
-- DIVINE FAVOR AURA BUFF MODIFIER --
-------------------------------------

function modifier_imba_chen_divine_favor_aura_buff:OnCreated()
	if self:GetAbility() then
		self.heal_amp_aura          = self:GetAbility():GetSpecialValueFor("heal_amp_aura")
		self.heal_rate_aura         = self:GetAbility():GetSpecialValueFor("heal_rate_aura")
		self.damage_bonus_aura      = self:GetAbility():GetSpecialValueFor("damage_bonus_aura")
		self.army_damage_multiplier = self:GetAbility():GetSpecialValueFor("army_damage_multiplier")
	else
		self:Destroy()
	end
end

function modifier_imba_chen_divine_favor_aura_buff:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,

		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE, -- IMBAfication: Pure Devotion

		MODIFIER_PROPERTY_TOOLTIP
	}
end

-- function modifier_imba_chen_divine_favor_aura_buff:GetModifierHPRegenAmplify_Percentage()
-- return self.heal_amp_aura
-- end

function modifier_imba_chen_divine_favor_aura_buff:Custom_AllHealAmplify_Percentage()
	return self.heal_amp
end

function modifier_imba_chen_divine_favor_aura_buff:GetModifierConstantHealthRegen()
	return self.heal_rate_aura
end

function modifier_imba_chen_divine_favor_aura_buff:GetModifierPreAttack_BonusDamage()
	if not self:GetParent():IsHero() then
		return self.damage_bonus_aura * self.army_damage_multiplier
	else
		return self.damage_bonus_aura
	end
end

function modifier_imba_chen_divine_favor_aura_buff:OnTooltip()
	return self.heal_amp_aura
end

---------------------
-- HOLY PERSUASION --
---------------------

function imba_chen_holy_persuasion:GetCastRange(vLocation, hTarget)
	if IsServer() and hTarget and hTarget:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return 0
	else
		return self.BaseClass.GetCastRange(self, vLocation, hTarget)
	end
end

-- Man this is messy...
function imba_chen_holy_persuasion:CastFilterResultTarget(hTarget)
	-- Malfurion living tower exception
	if hTarget:GetUnitLabel() == "living_tower" then
		return UF_FAIL_ANCIENT
	end

	if not IsServer() then return end

	if hTarget == self:GetCaster()
		or (hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and hTarget:IsCreep() and not hTarget:IsRoshan()) and hTarget:GetLevel() <= self:GetSpecialValueFor("level_req") and (not hTarget:IsAncient() or (hTarget:IsAncient() and self:GetCaster():HasAbility("imba_chen_hand_of_god") and self:GetCaster():FindAbilityByName("imba_chen_hand_of_god"):IsTrained() and self:GetCaster():HasScepter()))
		or (hTarget:GetTeamNumber() == self:GetCaster():GetTeamNumber() and (hTarget:IsRealHero() or hTarget:IsClone() or hTarget:GetOwnerEntity() == self:GetCaster() or (hTarget.GetPlayerID and self:GetCaster().GetPlayerID and hTarget:GetPlayerID() == self:GetCaster():GetPlayerID()) or hTarget:IsOther())) then
		return UF_SUCCESS
	elseif hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and hTarget:IsCreep() and not hTarget:IsRoshan() and hTarget:GetLevel() > self:GetSpecialValueFor("level_req") then
		return UF_FAIL_CUSTOM
	elseif hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and hTarget:IsCreep() and not hTarget:IsRoshan() and hTarget:IsAncient() then
		return UF_FAIL_ANCIENT
	elseif hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and hTarget:IsConsideredHero() then
		return UF_FAIL_HERO
	elseif hTarget:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return UF_FAIL_CUSTOM
	else
		return UF_FAIL_OTHER
	end
end

function imba_chen_holy_persuasion:GetCustomCastErrorTarget(hTarget)
	if not IsServer() then return end

	if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and hTarget:IsCreep() and not hTarget:IsRoshan() and hTarget:GetLevel() > self:GetSpecialValueFor("level_req") then
		return "#dota_hud_error_cant_cast_creep_level"
	elseif hTarget:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return "#dota_hud_error_cant_cast_on_creep_not_player_controlled"
	end
end

function imba_chen_holy_persuasion:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

function imba_chen_holy_persuasion:OnUpgrade()
	if not IsServer() then return end

	if self:GetLevel() == self:GetMaxLevel() and self:GetCaster():GetName() == "npc_dota_hero_chen" then
		self:GetCaster():EmitSound("chen_chen_item_04")
	end
end

-- function imba_chen_holy_persuasion:OnOwnerDied()
-- for ability = 0, 23 do
-- if self:GetCaster():GetAbilityByIndex(ability) and self:GetCaster():GetAbilityByIndex(ability).immortalized == true then
-- self:GetCaster():RemoveAbility(self:GetCaster():GetAbilityByIndex(ability):GetName())
-- end
-- end

-- self.auras = {}
-- end

function imba_chen_holy_persuasion:OnSpellStart()
	if not IsServer() then return end

	local target = self:GetCursorTarget()

	-- Emit glowing staff particle
	local weapon_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_cast.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(weapon_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(weapon_particle)

	-- Enemy logic
	if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		-- Play the standard Holy Persuasion sounds
		self:GetCaster():EmitSound("Hero_Chen.HolyPersuasionCast")
		target:EmitSound("Hero_Chen.HolyPersuasionEnemy")

		-- Basic dispel (buffs and debuffs)
		target:Purge(true, true, false, false, false)

		-- SUPER JANK LANE CREEP SWITCHAROO TO BYPASS LANE AI
		if string.find(target:GetUnitName(), "guys_") then
			local lane_creep_name = target:GetUnitName()

			local new_lane_creep = CreateUnitByName(target:GetUnitName(), target:GetAbsOrigin(), false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
			-- Copy the relevant stats over to the creep
			new_lane_creep:SetBaseMaxHealth(target:GetMaxHealth())
			new_lane_creep:SetHealth(target:GetHealth())
			new_lane_creep:SetBaseDamageMin(target:GetBaseDamageMin())
			new_lane_creep:SetBaseDamageMax(target:GetBaseDamageMax())
			new_lane_creep:SetMinimumGoldBounty(target:GetGoldBounty())
			new_lane_creep:SetMaximumGoldBounty(target:GetGoldBounty())
			target:AddNoDraw()
			target:ForceKill(false)
			target = new_lane_creep
		end

		-- Particle effects
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_holy_persuasion_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)

		-- "When the unit's maximum health is below the minimum health threshold, its maximum and current health are increased by the difference."
		if target:GetMaxHealth() < self:GetSpecialValueFor("health_min") then
			local health_difference = self:GetSpecialValueFor("health_min") - target:GetMaxHealth()
			target:SetBaseMaxHealth(target:GetMaxHealth() + health_difference)
			target:SetHealth(target:GetHealth() + health_difference)
		end

		-- "Fully restores the creep's mana."
		if target.SetMana and target.GetMaxMana then
			target:SetMana(target:GetMaxMana())
		end

		-- Transfer ownership over to Chen
		target:SetOwner(self:GetCaster())
		target:SetTeam(self:GetCaster():GetTeam())
		target:SetControllableByPlayer(self:GetCaster():GetPlayerID(), false)

		-- Base ability logic
		if not self:GetAutoCastState() then
			-- Add the persuasion modifiers (assign the creep as a variable to the caster's own tracking modifier to handle deaths/max count)
			target:AddNewModifier(self:GetCaster(), self, "modifier_imba_chen_holy_persuasion", {})
			local persuasion_tracker_modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_chen_holy_persuasion_tracker", {})
			persuasion_tracker_modifier.creep = target
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_chen_holy_persuasion_counter", {})

			-- Get the total number of persuaded creeps (and ancient persuaded ancient creeps) Chen currently has
			local persuaded_creeps_modifiers     = self:GetCaster():FindAllModifiersByName("modifier_imba_chen_holy_persuasion_tracker")
			local persuaded_creeps_count         = #persuaded_creeps_modifiers
			local persuaded_ancient_creeps_count = 0
			-- Keep a reference to the first ancient creep in case it needs to be force killed for over-capacity
			local first_ancient_creep            = nil
			local first_ancient_creep_modifier   = nil

			for _, modifier in pairs(persuaded_creeps_modifiers) do
				-- Let's clear out any dead modifiers if they appear...
				if not modifier.creep or modifier.creep:IsNull() then
					modifier:Destroy()
				elseif modifier.creep:IsAncient() then
					persuaded_ancient_creeps_count = persuaded_ancient_creeps_count + 1

					if persuaded_ancient_creeps_count == 1 then
						first_ancient_creep          = modifier.creep
						first_ancient_creep_modifier = modifier
					end
				end
			end

			-- If the total amount of persuaded ancient creeps exceeds the max limit (and all the ability checks passed), force kill the oldest one and remove it from the list
			if self:GetCaster():HasScepter() then
				local hand_of_god_ability = self:GetCaster():FindAbilityByName("imba_chen_hand_of_god")

				if hand_of_god_ability and hand_of_god_ability:IsTrained() and target:IsAncient() and persuaded_ancient_creeps_count > hand_of_god_ability:GetSpecialValueFor("ancient_creeps_scepter") then
					first_ancient_creep:ForceKill(false)
					first_ancient_creep_modifier:Destroy()
				end
			end

			-- Call these again to check if count has changed after Ancient check
			persuaded_creeps_modifiers = self:GetCaster():FindAllModifiersByName("modifier_imba_chen_holy_persuasion_tracker")
			persuaded_creeps_count     = #persuaded_creeps_modifiers

			-- If the total amount of persuaded creeps exceeds the max limit, force kill the oldest one and remove it from the table
			if persuaded_creeps_count > self:GetTalentSpecialValueFor("max_units") and persuaded_creeps_modifiers[1] then
				persuaded_creeps_modifiers[1].creep:ForceKill(false)
				persuaded_creeps_modifiers[1]:Destroy()
			end
		else
			-- IMBAfication: Immortalized
			-- if not self.auras then
			-- self.auras = {}
			-- end

			-- for ability = 0, 23 do
			-- if target:GetAbilityByIndex(ability) and target:GetAbilityByIndex(ability):GetIntrinsicModifierName() and target:FindModifierByNameAndCaster(target:GetAbilityByIndex(ability):GetIntrinsicModifierName(), target) and string.find(target:FindModifierByNameAndCaster(target:GetAbilityByIndex(ability):GetIntrinsicModifierName(), target):GetName(), "aura") then
			-- if #self.auras >= self:GetTalentSpecialValueFor("immortalize_max_units") then
			-- for index = 1, #self.auras do
			-- if not self.auras[index]:IsNull() then
			-- self:GetCaster():RemoveAbility(self.auras[index]:GetName())
			-- table.remove(self.auras, index)
			-- break
			-- end
			-- end
			-- end

			-- local aura_ability = self:GetCaster():AddAbility(target:GetAbilityByIndex(ability):GetName())
			-- aura_ability:SetLevel(target:GetAbilityByIndex(ability):GetLevel())
			-- self:GetCaster():FindModifierByNameAndCaster(aura_ability:GetIntrinsicModifierName(), self:GetCaster()):ForceRefresh()
			-- aura_ability.immortalized = true
			-- table.insert(self.auras, aura_ability)
			-- end
			-- end

			-- target:ForceKill(false)

			-- Sigh...this one was cool but it's potentially too laggy so I tried the basic one above that just adds auras and it doesn't even work properly

			-- Add the immortalized modifiers (assign the creep as a variable to the caster's own tracking modifier to handle deaths/max count)
			target:AddNewModifier(self:GetCaster(), self, "modifier_imba_chen_holy_persuasion_immortalized", {})
			local immortalized_tracker_modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_chen_holy_persuasion_immortalized_tracker", {})
			immortalized_tracker_modifier.creep = target
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_chen_holy_persuasion_immortalized_counter", {})

			-- Get the total number of immortalized creeps (and ancient immortalized ancient creeps) Chen currently has
			local immortalized_creeps_modifiers     = self:GetCaster():FindAllModifiersByName("modifier_imba_chen_holy_persuasion_immortalized_tracker")
			local immortalized_creeps_count         = #immortalized_creeps_modifiers
			local immortalized_ancient_creeps_count = 0
			-- Keep a reference to the first ancient creep in case it needs to be force killed for over-capacity
			local first_ancient_creep               = nil
			local first_ancient_creep_modifier      = nil

			for _, modifier in pairs(immortalized_creeps_modifiers) do
				-- Let's clear out any dead modifiers if they appear...
				if not modifier.creep or modifier.creep:IsNull() then
					modifier:Destroy()
				elseif modifier.creep:IsAncient() then
					immortalized_ancient_creeps_count = immortalized_ancient_creeps_count + 1

					if immortalized_ancient_creeps_count == 1 then
						first_ancient_creep          = modifier.creep
						first_ancient_creep_modifier = modifier
					end
				end
			end

			-- If the total amount of immortalized ancient creeps exceeds the max limit (and all the ability checks passed), force kill the oldest one and remove it from the list
			if self:GetCaster():HasScepter() then
				local hand_of_god_ability = self:GetCaster():FindAbilityByName("imba_chen_hand_of_god")

				if hand_of_god_ability and hand_of_god_ability:IsTrained() and target:IsAncient() and immortalized_ancient_creeps_count > hand_of_god_ability:GetSpecialValueFor("ancient_creeps_scepter") then
					first_ancient_creep:ForceKill(false)
					first_ancient_creep_modifier:Destroy()
				end
			end

			-- Call these again to check if count has changed after Ancient check
			immortalized_creeps_modifiers = self:GetCaster():FindAllModifiersByName("modifier_imba_chen_holy_persuasion_immortalized_tracker")
			immortalized_creeps_count     = #immortalized_creeps_modifiers

			-- If the total amount of immortalized creeps exceeds the max limit, force kill the oldest one and remove it from the table
			if immortalized_creeps_count > self:GetTalentSpecialValueFor("immortalize_max_units") and immortalized_creeps_modifiers[1] then
				immortalized_creeps_modifiers[1].creep:ForceKill(false)
				immortalized_creeps_modifiers[1]:Destroy()
			end
		end

		--target:AddNewModifier(self:GetCaster(), self, "modifier_dominated", {}) -- This didn't work for me

		-- IMBAfication: Commonwealth
		local target_xp                      = target:GetDeathXP()
		local target_gold_min                = target:GetMinimumGoldBounty()
		local target_gold_max                = target:GetMaximumGoldBounty()

		local commonwealth_xp                = target_xp * self:GetSpecialValueFor("commonwealth_pct") / 100
		local commonwealth_gold              = RandomInt(target_gold_min, target_gold_max) * self:GetSpecialValueFor("commonwealth_pct") / 100

		local commonwealth_xp_self           = commonwealth_xp * self:GetSpecialValueFor("commonwealth_caster_pct") / 100
		local commonwealth_gold_self         = commonwealth_gold * self:GetSpecialValueFor("commonwealth_caster_pct") / 100

		local commonwealth_xp_others_total   = commonwealth_xp - commonwealth_xp_self
		local commonwealth_gold_others_total = commonwealth_gold - commonwealth_gold_self

		-- Subtract commonwealth values from the creep
		target:SetDeathXP(math.max(target_xp - commonwealth_xp, 0))
		target:SetMinimumGoldBounty(math.max(target_gold_min - commonwealth_gold, 0))
		target:SetMaximumGoldBounty(math.max(target_gold_max - commonwealth_gold, 0))

		-- Give half of this to the caster
		self:GetCaster():AddExperience(commonwealth_xp_self, DOTA_ModifyXP_CreepKill, true, true)
		self:GetCaster():ModifyGold(commonwealth_gold_self, false, DOTA_ModifyGold_CreepKill)

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_XP, self:GetCaster(), commonwealth_xp_self, nil)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, self:GetCaster(), commonwealth_gold_self, nil)

		-- Give the rest to everyone else
		local ally_num = PlayerResource:GetPlayerCountForTeam(self:GetCaster():GetTeamNumber())

		local commonwealth_xp_others = math.max(commonwealth_xp_others_total / math.max(ally_num - 1, 1), 0)
		local commonwealth_gold_others = math.max(commonwealth_gold_others_total / math.max(ally_num - 1, 1), 0)

		for ally = 1, ally_num do
			-- This seems like kinda disgusting chaining of functions
			local hero = PlayerResource:GetPlayer(PlayerResource:GetNthPlayerIDOnTeam(self:GetCaster():GetTeamNumber(), ally)):GetAssignedHero()

			if hero ~= self:GetCaster() then
				hero:AddExperience(commonwealth_xp_others, DOTA_ModifyXP_CreepKill, true, true)
				hero:ModifyGold(commonwealth_gold_others, false, DOTA_ModifyGold_CreepKill)

				SendOverheadEventMessage(nil, OVERHEAD_ALERT_XP, hero, commonwealth_xp_self, nil)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, hero, commonwealth_gold_self, nil)
			end
		end
	else -- Same-team logic
		-- Self target
		if target == self:GetCaster() then
			local owned_units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)

			for _, owned_unit in pairs(owned_units) do
				if owned_unit ~= self:GetCaster() and not owned_unit:IsIllusion() and (owned_unit:GetOwnerEntity() == self:GetCaster() or (owned_unit.GetPlayerID and self:GetCaster().GetPlayerID and owned_unit:GetPlayerID() == self:GetCaster():GetPlayerID())) and not owned_unit:HasModifier("modifier_imba_chen_holy_persuasion_teleport") then -- that last conditional technically isn't vanilla but it makes more sense to not add the modifier if it exists already
					owned_unit:AddNewModifier(self:GetCaster(), self, "modifier_imba_chen_holy_persuasion_teleport", { duration = self:GetSpecialValueFor("teleport_delay") })
				end
			end
			-- Ally target
		else
			target:AddNewModifier(self:GetCaster(), self, "modifier_imba_chen_holy_persuasion_teleport", { duration = self:GetSpecialValueFor("teleport_delay") })
		end
	end
end

------------------------------
-- HOLY PERSUASION MODIFIER --
------------------------------

function modifier_imba_chen_holy_persuasion:IsDebuff() return false end

function modifier_imba_chen_holy_persuasion:IsPurgable() return false end

function modifier_imba_chen_holy_persuasion:RemoveOnDeath() return false end

-- OnCreated and OnIntervalThink purely for stupid Rubick/Morphling exceptions
function modifier_imba_chen_holy_persuasion:OnCreated()
	if not IsServer() then return end

	self:StartIntervalThink(0.1)
end

function modifier_imba_chen_holy_persuasion:OnIntervalThink()
	if not IsServer() then return end

	if not self:GetCaster() or not self:GetAbility() or not self:GetParent():IsAlive() then
		self:GetParent():ForceKill(false)
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end

-- Without this state, the creep seems to ignore issued commands
function modifier_imba_chen_holy_persuasion:CheckState()
	local state = {
		[MODIFIER_STATE_DOMINATED] = true
	}

	return state
end

function modifier_imba_chen_holy_persuasion:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return decFuncs
end

function modifier_imba_chen_holy_persuasion:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("movement_speed_bonus")
end

-- If the persuaded creep dies, remove the relevant modifier from the caster as well
function modifier_imba_chen_holy_persuasion:OnDeath(keys)
	if not IsServer() then return end

	if keys.unit == self:GetParent() then
		local persuaded_creeps_modifiers = self:GetCaster():FindAllModifiersByName("modifier_imba_chen_holy_persuasion_tracker")

		for _, modifier in pairs(persuaded_creeps_modifiers) do
			if modifier.creep == self:GetParent() then
				modifier:Destroy()
				self:Destroy()
				break
			end
		end
	end
end

---------------------------------------
-- HOLY PERSUASION TRACKER MODIFIER --
---------------------------------------

function modifier_imba_chen_holy_persuasion_tracker:IsHidden() return true end

function modifier_imba_chen_holy_persuasion_tracker:IsPurgable() return false end

function modifier_imba_chen_holy_persuasion_tracker:RemoveOnDeath() return false end

function modifier_imba_chen_holy_persuasion_tracker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_chen_holy_persuasion_tracker:OnDestroy()
	if not IsServer() then return end

	if self:GetCaster():HasModifier("modifier_imba_chen_holy_persuasion_counter") then
		self:GetCaster():FindModifierByNameAndCaster("modifier_imba_chen_holy_persuasion_counter", self:GetCaster()):SetStackCount(#self:GetCaster():FindAllModifiersByName(self:GetName()))
	end
end

--------------------------------------
-- HOLY PERSUASION COUNTER MODIFIER --
--------------------------------------

function modifier_imba_chen_holy_persuasion_counter:IsHidden() return self:GetStackCount() <= 0 end

function modifier_imba_chen_holy_persuasion_counter:IsPurgable() return false end

function modifier_imba_chen_holy_persuasion_counter:RemoveOnDeath() return false end

function modifier_imba_chen_holy_persuasion_counter:OnStackCountChanged()
	if not IsServer() then return end

	if self:GetStackCount() == 0 then
		self:Destroy()
	end
end

function modifier_imba_chen_holy_persuasion_counter:OnCreated()
	if not IsServer() then return end

	self:SetStackCount(#self:GetCaster():FindAllModifiersByName("modifier_imba_chen_holy_persuasion_tracker"))
end

function modifier_imba_chen_holy_persuasion_counter:OnRefresh()
	if not IsServer() then return end

	self:OnCreated()
end

---------------------------------------
-- HOLY PERSUASION TELEPORT MODIFIER --
---------------------------------------

function modifier_imba_chen_holy_persuasion_teleport:GetEffectName()
	return "particles/units/heroes/hero_chen/chen_teleport.vpcf"
end

function modifier_imba_chen_holy_persuasion_teleport:OnCreated()
	self.distance = self:GetAbility():GetSpecialValueFor("teleport_distance")

	if not IsServer() then return end
	self:GetParent():EmitSound("Hero_Chen.TeleportLoop")
end

function modifier_imba_chen_holy_persuasion_teleport:OnDestroy()
	if not IsServer() then return end

	self:GetParent():StopSound("Hero_Chen.TeleportLoop")

	-- The full duration has passed, and the teleport has succeeded
	if self:GetRemainingTime() <= 0 then
		local caster_position = self:GetCaster():GetAbsOrigin()

		if self:GetAbility() and self:GetCaster() and self:GetCaster():IsAlive() then
			-- If the initial teleport vector for the ability hasn't been set yet, do so now (starts East)
			if not self:GetAbility().teleport_vector then
				self:GetAbility().teleport_vector = Vector(self.distance, 0, 0)
			end

			EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Chen.TeleportOut", self:GetCaster())

			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_POINT, self:GetParent())
			ParticleManager:ReleaseParticleIndex(particle)

			-- Teleport the parent to the caster's position + the teleport vector
			--self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin() + self:GetAbility().teleport_vector)
			FindClearSpaceForUnit(self:GetParent(), self:GetCaster():GetAbsOrigin() + self:GetAbility().teleport_vector, false)

			EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Chen.TeleportIn", self:GetCaster())

			local parent = self:GetParent()

			Timers:CreateTimer(FrameTime(), function()
				if parent then
					local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_POINT, parent)
					ParticleManager:ReleaseParticleIndex(particle)
				end
			end)

			-- Send a stop command
			self:GetParent():Stop()

			-- Rotate the teleport vector 90 degrees counterclockwise to use for the next unit that gets ported
			self:GetAbility().teleport_vector = RotatePosition(Vector(0, 0, 0), QAngle(0, 90, 0), self:GetAbility().teleport_vector)
		end
	end
end

function modifier_imba_chen_holy_persuasion_teleport:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return decFuncs
end

-- "Damage greater than 0 (before reductions) from any player (including allies, excluding self) or Roshan dispels the effect."
function modifier_imba_chen_holy_persuasion_teleport:OnTakeDamage(keys)
	if not IsServer() then return end

	if keys.unit == self:GetParent() and keys.attacker ~= self:GetParent() and (keys.attacker:IsRealHero() or keys.attacker:IsRoshan()) and keys.original_damage > 0 then
		self:Destroy()
	end
end

-------------------------------------------
-- HOLY PERSUASION IMMORTALIZED MODIFIER --
-------------------------------------------

function modifier_imba_chen_holy_persuasion_immortalized:IsDebuff() return false end

function modifier_imba_chen_holy_persuasion_immortalized:IsPurgable() return false end

function modifier_imba_chen_holy_persuasion_immortalized:RemoveOnDeath() return false end

function modifier_imba_chen_holy_persuasion_immortalized:GetStatusEffectName()
	return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end

function modifier_imba_chen_holy_persuasion_immortalized:OnCreated()
	self.distance = self:GetAbility():GetSpecialValueFor("teleport_distance")

	if not IsServer() then return end

	if self:GetCaster() and not self:GetCaster():IsNull() and self:GetAbility() and self:GetParent():IsAlive() and self:GetCaster():IsAlive() then
		-- If the initial immortalize vector for the ability hasn't been set yet, do so now (starts North-East)
		if not self:GetAbility().immortalize_vector then
			self:GetAbility().immortalize_vector = RotatePosition(Vector(0, 0, 0), QAngle(0, 45, 0), Vector(self.distance * 2, 0, 0))
		end

		-- Use the saved immortalize vector for this modifier/creep instance
		self.immortalize_vector = self:GetAbility().immortalize_vector

		self:GetParent():SetAbsOrigin(GetGroundPosition(self:GetCaster():GetAbsOrigin() + self.immortalize_vector, nil))
		self:GetParent():MoveToNPC(self:GetCaster())

		-- Rotate the immortalize vector 90 degrees clockwise to use for the next unit that gets ported
		self:GetAbility().immortalize_vector = RotatePosition(Vector(0, 0, 0), QAngle(0, -90, 0), self:GetAbility().immortalize_vector)

		-- self:GetParent():SetForwardVector(self.immortalize_vector)
		-- self:GetParent():Stop()
		-- self:StartIntervalThink(FrameTime())
		self:StartIntervalThink(0.1)
	else
		self:GetParent():ForceKill(false)
	end
end

-- function modifier_imba_chen_holy_persuasion_immortalized:OnIntervalThink()
-- if not IsServer() then return end

-- if self:GetCaster() and not self:GetCaster():IsNull() and self:GetAbility() and self:GetParent():IsAlive() and self:GetCaster():IsAlive() then
-- self:GetParent():SetAbsOrigin(GetGroundPosition(self:GetCaster():GetAbsOrigin() + self.immortalize_vector, nil))
-- self:GetParent():SetForwardVector(self.immortalize_vector)
-- else
-- self:GetParent():ForceKill(false)
-- self:StartIntervalThink(-1)
-- self:Destroy()
-- end
-- end

function modifier_imba_chen_holy_persuasion_immortalized:OnIntervalThink()
	if not self:GetAbility() then
		self:GetParent():ForceKill(false)
	end
	-- if ((self:GetCaster():GetAbsOrigin() + self.immortalize_vector) - self:GetParent():GetAbsOrigin()):Length2D() > self.distance then
	-- self:GetParent():SetAbsOrigin(GetGroundPosition(self:GetCaster():GetAbsOrigin() + self.immortalize_vector, nil))
	-- else
	self:GetParent():MoveToPosition(GetGroundPosition(self:GetCaster():GetAbsOrigin() + self.immortalize_vector, nil))
	-- end
end

-- Perhaps a bit overkill?
function modifier_imba_chen_holy_persuasion_immortalized:CheckState()
	local state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		-- [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_DOMINATED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true
	}

	if self:GetCaster():IsInvisible() then
		state[MODIFIER_STATE_INVISIBLE] = true
	end

	return state
end

function modifier_imba_chen_holy_persuasion_immortalized:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MODEL_SCALE,

		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ORDER
	}

	return decFuncs
end

function modifier_imba_chen_holy_persuasion_immortalized:GetBonusVisionPercentage()
	return -100
end

function modifier_imba_chen_holy_persuasion_immortalized:GetModifierMoveSpeed_Absolute()
	return 10000
end

function modifier_imba_chen_holy_persuasion_immortalized:GetModifierModelScale()
	return -20
end

function modifier_imba_chen_holy_persuasion_immortalized:OnOrder(keys)
	-- for _, key in pairs(keys) do
	-- print(_, " ", key)
	-- end
	if keys.unit == self:GetParent() and keys.order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
		local parent = self:GetParent()
		local caster = self:GetCaster()

		Timers:CreateTimer(FrameTime(), function()
			self:GetParent():Interrupt()
			self:GetParent():MoveToPosition(GetGroundPosition(self:GetCaster():GetAbsOrigin() + self.immortalize_vector, nil))
		end)
		-- self:GetParent():MoveToPosition(GetGroundPosition(self:GetCaster():GetAbsOrigin() + self.immortalize_vector, nil))
	end
end

-- If the immortalized creep dies (how, I don't know) or the caster dies, remove the relevant modifier from the caster as well (also make sure the creep dies)
function modifier_imba_chen_holy_persuasion_immortalized:OnDeath(keys)
	if not IsServer() then return end

	if keys.unit == self:GetParent() or keys.unit == self:GetCaster() then
		local immortalized_creeps_modifiers = self:GetCaster():FindAllModifiersByName("modifier_imba_chen_holy_persuasion_immortalized_tracker")

		for _, modifier in pairs(immortalized_creeps_modifiers) do
			if modifier.creep == self:GetParent() then
				modifier:Destroy()
				self:Destroy()

				-- Immortalized creeps die if the caster dies (let's give the kills to the killer)
				self:GetParent():Kill(self:GetAbility(), keys.attacker)
				break
			end
		end
	end
end

---------------------------------------------------
-- HOLY PERSUASION IMMORTALIZED TRACKER MODIFIER --
---------------------------------------------------

function modifier_imba_chen_holy_persuasion_immortalized_tracker:IsHidden() return true end

function modifier_imba_chen_holy_persuasion_immortalized_tracker:IsPurgable() return false end

function modifier_imba_chen_holy_persuasion_immortalized_tracker:RemoveOnDeath() return false end

function modifier_imba_chen_holy_persuasion_immortalized_tracker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_chen_holy_persuasion_immortalized_tracker:OnDestroy()
	if not IsServer() then return end

	if self:GetCaster():HasModifier("modifier_imba_chen_holy_persuasion_immortalized_counter") then
		self:GetCaster():FindModifierByNameAndCaster("modifier_imba_chen_holy_persuasion_immortalized_counter", self:GetCaster()):SetStackCount(#self:GetCaster():FindAllModifiersByName(self:GetName()))
	end
end

---------------------------------------------------
-- HOLY PERSUASION IMMORTALIZED COUNTER MODIFIER --
---------------------------------------------------

function modifier_imba_chen_holy_persuasion_immortalized_counter:IsHidden() return self:GetStackCount() <= 0 end

function modifier_imba_chen_holy_persuasion_immortalized_counter:IsPurgable() return false end

function modifier_imba_chen_holy_persuasion_immortalized_counter:RemoveOnDeath() return false end

function modifier_imba_chen_holy_persuasion_immortalized_counter:OnStackCountChanged()
	if not IsServer() then return end

	if self:GetStackCount() == 0 then
		self:Destroy()
	end
end

function modifier_imba_chen_holy_persuasion_immortalized_counter:OnCreated()
	if not IsServer() then return end

	self:SetStackCount(#self:GetCaster():FindAllModifiersByName("modifier_imba_chen_holy_persuasion_immortalized_tracker"))
end

function modifier_imba_chen_holy_persuasion_immortalized_counter:OnRefresh()
	if not IsServer() then return end

	self:OnCreated()
end

-------------------
-- TEST OF FAITH --
-------------------

function imba_chen_test_of_faith:GetCooldown(iLevel)
	return self.BaseClass.GetCooldown(self, iLevel) - self:GetCaster():FindTalentValue("special_bonus_imba_chen_test_of_faith_cd_reduction")
end

-- Self leveling function (since this is technically a completely separate ability)
function imba_chen_test_of_faith:OnHeroLevelUp()
	self:SetLevel(min(math.floor(self:GetCaster():GetLevel() / 3), 4))
end

function imba_chen_test_of_faith:OnSpellStart()
	if not IsServer() then return end

	local target = self:GetCursorTarget()

	if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and target:TriggerSpellAbsorb(self) then return end

	target:EmitSound("Hero_Chen.Test_of_Faith")

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(particle)

	if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		local heal_value = self:GetSpecialValueFor("heal_max")

		-- If the cast target isn't the caster themselves, get a random number between the min and max value
		if target ~= self:GetCaster() then
			heal_value = RandomInt(self:GetSpecialValueFor("heal_min"), self:GetSpecialValueFor("heal_max"))
		end

		-- IMBAfication: For the Faithful
		if target.GetPlayerID and target:GetPlayerID() then
			heal_value = heal_value + (PlayerResource:GetAssists(target:GetPlayerID()) * self:GetSpecialValueFor("faithful_assist_mult"))
		end

		target:Heal(heal_value, self:GetCaster())

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, heal_value, nil)
	else
		local damage_min = self:GetSpecialValueFor("damage_min")
		local damage_max = self:GetSpecialValueFor("damage_max")

		-- IMBAfication: For the Unfaithful	
		if self:GetCaster().GetPlayerID and target.GetPlayerID and self:GetCaster():GetPlayerID() and target:GetPlayerID() then
			local caster_assists = PlayerResource:GetAssists(self:GetCaster():GetPlayerID())
			local target_assists = PlayerResource:GetAssists(target:GetPlayerID())

			damage_max           = damage_max + math.max((caster_assists - target_assists) * self:GetSpecialValueFor("unfaithful_assist_mult"), 0)
		end

		local damage_value = RandomInt(damage_min, damage_max)

		local damageTable = {
			victim       = target,
			damage       = damage_value,
			damage_type  = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker     = self:GetCaster(),
			ability      = self
		}

		ApplyDamage(damageTable)

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, damage_value, nil)
	end
end

-----------------
-- HAND OF GOD --
-----------------

function imba_chen_hand_of_god:GetCooldown(iLevel)
	return self.BaseClass.GetCooldown(self, iLevel) - self:GetCaster():FindTalentValue("special_bonus_imba_chen_hand_of_god_cooldown")
end

function imba_chen_hand_of_god:OnSpellStart()
	if not IsServer() then return end

	local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)

	local voiceline = nil

	if self:GetCaster():GetName() == "npc_dota_hero_chen" then
		voiceline = "chen_chen_ability_handgod_0" .. RandomInt(1, 3)
	end

	for _, ally in pairs(allies) do
		if ally:IsRealHero() or ally:IsClone() or ally:GetOwnerEntity() == self:GetCaster() or (ally.GetPlayerID and self:GetCaster().GetPlayerID and ally:GetPlayerID() == self:GetCaster():GetPlayerID()) then
			-- Let's try not to blow up eardrums
			if voiceline and ally:IsRealHero() then
				ally:EmitSound(voiceline)
			end

			if ally:IsRealHero() then
				ally:EmitSound("Hero_Chen.HandOfGodHealHero")
			elseif ally:IsCreep() then
				ally:EmitSound("Hero_Chen.HandOfGodHealCreep")
			end

			--This has CP60 and 61 for colours...HMM...
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_hand_of_god.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
			ParticleManager:ReleaseParticleIndex(particle)

			if self:GetCaster():HasTalent("special_bonus_imba_chen_divine_favor_hand_of_god") and self:GetCaster():HasAbility("imba_chen_divine_favor") and self:GetCaster():FindAbilityByName("imba_chen_divine_favor"):IsTrained() then
				ally:AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("imba_chen_divine_favor"), "modifier_imba_chen_divine_favor", { duration = self:GetCaster():FindAbilityByName("imba_chen_divine_favor"):GetSpecialValueFor("duration") })
			end

			-- IMBAfication: Overheal
			local overheal_amount = self:GetTalentSpecialValueFor("heal_amount") - (ally:GetMaxHealth() - ally:GetHealth())

			if overheal_amount > 0 then
				ally:AddNewModifier(self:GetCaster(), self, "modifier_imba_chen_hand_of_god_overheal", { overheal_amount = overheal_amount })
			end

			-- Only shows numbers for heroes
			if ally:IsHero() then
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, self:GetTalentSpecialValueFor("heal_amount"), nil)
			end

			-- Heal happens after the IMBAfication logic here
			ally:Heal(self:GetTalentSpecialValueFor("heal_amount"), self:GetCaster())
		end
	end
end

-----------------------------------
-- HAND OF GOD OVERHEAL MODIFIER --
-----------------------------------

function modifier_imba_chen_hand_of_god_overheal:IsPurgable() return false end

function modifier_imba_chen_hand_of_god_overheal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_chen_hand_of_god_overheal:OnCreated(params)
	-- AbilitySpecials
	self.overheal_loss_per_tick = self:GetAbility():GetSpecialValueFor("overheal_loss_per_tick")
	self.overheal_tick_rate     = self:GetAbility():GetSpecialValueFor("overheal_tick_rate")

	if not IsServer() then return end

	self:SetStackCount(params.overheal_amount)

	self:StartIntervalThink(self.overheal_tick_rate)
end

function modifier_imba_chen_hand_of_god_overheal:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount(self:GetStackCount() - self.overheal_loss_per_tick)

	if self:GetParent().CalculateStatBonus then
		self:GetParent():CalculateStatBonus(true)
	end

	if self:GetStackCount() <= 0 then
		self:Destroy()
	end
end

function modifier_imba_chen_hand_of_god_overheal:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
	}

	return decFuncs
end

function modifier_imba_chen_hand_of_god_overheal:GetModifierExtraHealthBonus()
	return self:GetStackCount()
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_chen_divine_favor_cd_reduction", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_chen_test_of_faith_cd_reduction", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_chen_hand_of_god_cooldown", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_chen_remnants_of_penitence", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_chen_divine_favor_cd_reduction  = class({})
modifier_special_bonus_imba_chen_test_of_faith_cd_reduction = class({})
modifier_special_bonus_imba_chen_hand_of_god_cooldown       = modifier_special_bonus_imba_chen_hand_of_god_cooldown or class({})
modifier_special_bonus_imba_chen_remnants_of_penitence      = modifier_special_bonus_imba_chen_remnants_of_penitence or class({})

function modifier_special_bonus_imba_chen_divine_favor_cd_reduction:IsHidden() return true end

function modifier_special_bonus_imba_chen_divine_favor_cd_reduction:IsPurgable() return false end

function modifier_special_bonus_imba_chen_divine_favor_cd_reduction:RemoveOnDeath() return false end

function modifier_special_bonus_imba_chen_test_of_faith_cd_reduction:IsHidden() return true end

function modifier_special_bonus_imba_chen_test_of_faith_cd_reduction:IsPurgable() return false end

function modifier_special_bonus_imba_chen_test_of_faith_cd_reduction:RemoveOnDeath() return false end

function modifier_special_bonus_imba_chen_hand_of_god_cooldown:IsHidden() return true end

function modifier_special_bonus_imba_chen_hand_of_god_cooldown:IsPurgable() return false end

function modifier_special_bonus_imba_chen_hand_of_god_cooldown:RemoveOnDeath() return false end

function modifier_special_bonus_imba_chen_remnants_of_penitence:IsHidden() return true end

function modifier_special_bonus_imba_chen_remnants_of_penitence:IsPurgable() return false end

function modifier_special_bonus_imba_chen_remnants_of_penitence:RemoveOnDeath() return false end

function imba_chen_penitence:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_chen_remnants_of_penitence") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_chen_remnants_of_penitence") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_chen_remnants_of_penitence"), "modifier_special_bonus_imba_chen_remnants_of_penitence", {})
	end
end

function imba_chen_divine_favor:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_chen_divine_favor_cd_reduction") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_chen_divine_favor_cd_reduction") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_chen_divine_favor_cd_reduction"), "modifier_special_bonus_imba_chen_divine_favor_cd_reduction", {})
	end
end

function imba_chen_test_of_faith:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_chen_test_of_faith_cd_reduction") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_chen_test_of_faith_cd_reduction") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_chen_test_of_faith_cd_reduction"), "modifier_special_bonus_imba_chen_test_of_faith_cd_reduction", {})
	end
end

function imba_chen_hand_of_god:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_chen_hand_of_god_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_chen_hand_of_god_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_chen_hand_of_god_cooldown"), "modifier_special_bonus_imba_chen_hand_of_god_cooldown", {})
	end
end
