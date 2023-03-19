-- Creator:
--	   AltiV, February 25th, 2020

LinkLuaModifier("modifier_imba_undying_decay_buff", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_decay_buff_counter", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_decay_debuff", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_decay_debuff_counter", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_undying_soul_rip_soul_injection", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_soul_rip_soul_injection_debuff", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_imba_undying_tombstone_zombie_aura", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_tombstone_zombie_modifier", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_tombstone_zombie_modifier_no_home", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_tombstone_zombie_deathlust", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_tombstone_zombie_deathstrike", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_tombstone_zombie_deathstrike_slow_counter", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_tombstone_zombie_deathstrike_slow", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_undying_flesh_golem_grab", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_flesh_golem_grab_debuff", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_generic_motion_controller", "components/modifiers/generic/modifier_generic_motion_controller", LUA_MODIFIER_MOTION_BOTH)

LinkLuaModifier("modifier_imba_undying_flesh_golem_illusion_check", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_flesh_golem", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_flesh_golem_plague_aura", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_flesh_golem_slow", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)

imba_undying_decay                                              = imba_undying_decay or class({})
modifier_imba_undying_decay_buff                                = modifier_imba_undying_decay_buff or class({})
modifier_imba_undying_decay_buff_counter                        = modifier_imba_undying_decay_buff_counter or class({})
modifier_imba_undying_decay_debuff                              = modifier_imba_undying_decay_debuff or class({})
modifier_imba_undying_decay_debuff_counter                      = modifier_imba_undying_decay_debuff_counter or class({})

imba_undying_soul_rip                                           = imba_undying_soul_rip or class({})
modifier_imba_undying_soul_rip_soul_injection                   = modifier_imba_undying_soul_rip_soul_injection or class({})
modifier_imba_undying_soul_rip_soul_injection_debuff            = modifier_imba_undying_soul_rip_soul_injection_debuff or class({})

imba_undying_tombstone                                          = imba_undying_tombstone or class({})
modifier_imba_undying_tombstone_zombie_aura                     = modifier_imba_undying_tombstone_zombie_aura or class({})
modifier_imba_undying_tombstone_zombie_modifier                 = modifier_imba_undying_tombstone_zombie_modifier or class({})
modifier_imba_undying_tombstone_zombie_modifier_no_home         = modifier_imba_undying_tombstone_zombie_modifier_no_home or class({})
modifier_imba_undying_tombstone_zombie_deathlust                = modifier_imba_undying_tombstone_zombie_deathlust or class({})
modifier_imba_undying_tombstone_zombie_deathstrike              = modifier_imba_undying_tombstone_zombie_deathstrike or class({})
modifier_imba_undying_tombstone_zombie_deathstrike_slow_counter = modifier_imba_undying_tombstone_zombie_deathstrike_slow_counter or class({})
modifier_imba_undying_tombstone_zombie_deathstrike_slow         = modifier_imba_undying_tombstone_zombie_deathstrike_slow or class({})

imba_undying_tombstone_zombie_deathstrike                       = imba_undying_tombstone_zombie_deathstrike or class({})

imba_undying_flesh_golem_grab                                   = imba_undying_flesh_golem_grab or class({})
modifier_imba_undying_flesh_golem_grab                          = modifier_imba_undying_flesh_golem_grab or class({})
modifier_imba_undying_flesh_golem_grab_debuff                   = modifier_imba_undying_flesh_golem_grab_debuff or class({})

imba_undying_flesh_golem_throw                                  = imba_undying_flesh_golem_throw or class({})

imba_undying_flesh_golem                                        = imba_undying_flesh_golem or class({})
modifier_imba_undying_flesh_golem_illusion_check                = modifier_imba_undying_flesh_golem_illusion_check or class({})
modifier_imba_undying_flesh_golem                               = modifier_imba_undying_flesh_golem or class({})
modifier_imba_undying_flesh_golem_plague_aura                   = modifier_imba_undying_flesh_golem_plague_aura or class({})
modifier_imba_undying_flesh_golem_slow                          = modifier_imba_undying_flesh_golem_slow or class({})

------------------------
-- IMBA_UNDYING_DECAY --
------------------------

function imba_undying_decay:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_undying_decay:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_undying_decay_cooldown")
end

-- "Upon acquiring/losing Aghanim's Scepter, all stacks of stolen strength adapts immediately. "
-- What a pain
function imba_undying_decay:OnInventoryContentsChanged()
	if self:GetCaster():HasScepter() and not self.scepter_updated then
		for _, mod in pairs(self:GetCaster():FindAllModifiersByName("modifier_imba_undying_decay_buff")) do
			if mod.str_steal_scepter then
				mod:SetStackCount(mod.str_steal_scepter)
			end
		end

		if self.debuff_modifier_table and #self.debuff_modifier_table > 0 then
			for _, debuff in pairs(self.debuff_modifier_table) do
				if not debuff:IsNull() and debuff.str_steal_scepter then
					debuff:SetStackCount(debuff.str_steal_scepter)
				end
			end
		end

		self.scepter_updated = true
	elseif not self:GetCaster():HasScepter() and self.scepter_updated then
		for _, mod in pairs(self:GetCaster():FindAllModifiersByName("modifier_imba_undying_decay_buff")) do
			if mod.str_steal then
				mod:SetStackCount(mod.str_steal)
			end
		end

		if self.debuff_modifier_table then
			for _, debuff in pairs(self.debuff_modifier_table) do
				if not debuff:IsNull() and debuff.str_steal then
					debuff:SetStackCount(debuff.str_steal)
				end
			end
		end

		self.scepter_updated = false
	end
end

function imba_undying_decay:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end

-- "The strength loss on the target does not keep the current health percentage, but instead removes 20 health per strength from the current health pool."
-- "The strength gain on Undying does not keep the current health percentage either, and instead adds 20 health per strength to the current health pool."
function imba_undying_decay:OnSpellStart()
	-- This variable is to prevent glitches where the ability is obtained while a user already has Aghanim's Scepter, and then they drop the scepter and never retrieve it again, which would keep the Decay stacks at their scepter levels
	-- Yes I know it's stupid
	self.scepter_updated = self:GetCaster():HasScepter()

	self:GetCaster():EmitSound("Hero_Undying.Decay.Cast")

	if self:GetCaster():GetName() == "npc_dota_hero_undying" and RollPercentage(50) then
		if not self.responses then
			self.responses =
			{
				"undying_undying_decay_03",
				"undying_undying_decay_04",
				"undying_undying_decay_05",
				"undying_undying_decay_07",
				"undying_undying_decay_08",
				"undying_undying_decay_09",
				"undying_undying_decay_10"
			}
		end

		if not self.responses_big then
			self.responses_big =
			{
				"undying_undying_big_decay_03",
				"undying_undying_big_decay_04",
				"undying_undying_big_decay_05",
				"undying_undying_big_decay_07",
				"undying_undying_big_decay_08",
				"undying_undying_big_decay_09",
				"undying_undying_big_decay_10"
			}
		end

		if self:GetCaster():HasModifier("modifier_imba_undying_flesh_golem") then
			-- WHy isn't there a function that plays only on one unit but not on client? This function doesn't make the sound come out of the unit which is wrong, but no one else is supposed to hear these voicelines either. Ugh...
			EmitSoundOnClient(self.responses_big[RandomInt(1, #self.responses_big)], self:GetCaster():GetPlayerOwner())
		else
			EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
		end
	end

	local decay_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(decay_particle, 0, self:GetCursorPosition())
	ParticleManager:SetParticleControl(decay_particle, 1, Vector(self:GetSpecialValueFor("radius"), 0, 0))
	-- This isn't technically correct because the flies actually follow Undying all the way to the end but like...ugh
	ParticleManager:SetParticleControl(decay_particle, 2, self:GetCaster():GetAbsOrigin())
	-- ParticleManager:SetParticleControlEnt(decay_particle, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(decay_particle)

	local clone_owner_units          = {}
	local strength_transfer_particle = nil
	local flies_transfer_particle    = nil

	local buff_modifier              = nil
	local debuff_modifier            = nil

	if not self.debuff_modifier_table then
		self.debuff_modifier_table = {}
	end

	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		if enemy:IsClone() or enemy:IsTempestDouble() then
			if enemy.GetPlayerOwner and enemy:GetPlayerOwner().GetAssignedHero and enemy:GetPlayerOwner():GetAssignedHero():entindex() then
				if not clone_owner_units[enemy:GetPlayerOwner():GetAssignedHero():entindex()] then
					clone_owner_units[enemy:GetPlayerOwner():GetAssignedHero():entindex()] = {}
				end

				table.insert(clone_owner_units[enemy:GetPlayerOwner():GetAssignedHero():entindex()], enemy:entindex())
			end
		else
			if enemy:IsHero() and not enemy:IsIllusion() then
				enemy:EmitSound("Hero_Undying.Decay.Target")
				self:GetCaster():EmitSound("Hero_Undying.Decay.Transfer")

				strength_transfer_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay_strength_xfer.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:SetParticleControlEnt(strength_transfer_particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(strength_transfer_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(strength_transfer_particle)

				-- flies_transfer_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay_strength_xfer_flies.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
				-- ParticleManager:SetParticleControlEnt(flies_transfer_particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				-- ParticleManager:SetParticleControlEnt(flies_transfer_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
				-- ParticleManager:ReleaseParticleIndex(flies_transfer_particle)

				-- "Steals strength before applying its damage."
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_undying_decay_debuff_counter", { duration = self:GetTalentSpecialValueFor("decay_duration") * (1 - enemy:GetStatusResistance()) })
				debuff_modifier = enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_undying_decay_debuff", { duration = self:GetTalentSpecialValueFor("decay_duration") * (1 - enemy:GetStatusResistance()) })
				table.insert(self.debuff_modifier_table, debuff_modifier)

				self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_undying_decay_buff_counter", { duration = self:GetTalentSpecialValueFor("decay_duration") })
				buff_modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_undying_decay_buff", { duration = self:GetTalentSpecialValueFor("decay_duration") })
			end

			ApplyDamage({
				victim       = enemy,
				damage       = self:GetSpecialValueFor("decay_damage"),
				damage_type  = self:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = self:GetCaster(),
				ability      = self
			})
		end
	end

	local selected_unit = nil

	-- Separate handling for clones
	if #clone_owner_units > 0 then
		for tables in clone_owner_units do
			enemy:EmitSound("Hero_Undying.Decay.Target")
			self:GetCaster():EmitSound("Hero_Undying.Decay.Transfer")

			selected_unit = EntIndexToHScript(tables[RandomInt(1, #tables)])

			enemy:AddNewModifier(selected_unit, self, "modifier_imba_undying_decay_debuff_counter", { duration = self:GetTalentSpecialValueFor("decay_duration") * (1 - enemy:GetStatusResistance()) })
			debuff_modifier = enemy:AddNewModifier(selected_unit, self, "modifier_imba_undying_decay_debuff", { duration = self:GetTalentSpecialValueFor("decay_duration") * (1 - enemy:GetStatusResistance()) })
			table.insert(self.debuff_modifier_table, debuff_modifier)

			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_undying_decay_buff_counter", { duration = self:GetTalentSpecialValueFor("decay_duration") })
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_undying_decay_buff", { duration = self:GetTalentSpecialValueFor("decay_duration") })

			for enemy_entindex in tables do
				ApplyDamage({
					victim       = EntIndexToHScript(enemy_entindex),
					damage       = self:GetSpecialValueFor("decay_damage"),
					damage_type  = self:GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					attacker     = self:GetCaster(),
					ability      = self
				})
			end
		end
	end
end

--------------------------------------
-- MODIFIER_IMBA_UNDYING_DECAY_BUFF --
--------------------------------------

function modifier_imba_undying_decay_buff:IsHidden() return true end

function modifier_imba_undying_decay_buff:IsPurgable() return false end

function modifier_imba_undying_decay_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_undying_decay_buff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	self.str_steal         = self:GetAbility():GetSpecialValueFor("str_steal")
	self.str_steal_scepter = self:GetAbility():GetSpecialValueFor("str_steal_scepter")
	self.hp_gain_per_str   = 20

	if not IsServer() then return end

	if not self:GetCaster():HasScepter() then
		self:SetStackCount(self:GetStackCount() + self.str_steal)
		self.strength_gain = self.str_steal
	else
		self:SetStackCount(self:GetStackCount() + self.str_steal_scepter)
		self.strength_gain = self.str_steal_scepter
	end

	-- "The strength gain on Undying does not keep the current health percentage either, and instead adds 20 health per strength to the current health pool."	
	self:GetCaster():Heal(self.strength_gain * 20, self:GetCaster())
end

function modifier_imba_undying_decay_buff:OnDestroy()
	if not IsServer() then return end

	if self:GetParent():HasModifier("modifier_imba_undying_decay_buff_counter") then
		self:GetParent():FindModifierByName("modifier_imba_undying_decay_buff_counter"):SetStackCount(self:GetParent():FindModifierByName("modifier_imba_undying_decay_buff_counter"):GetStackCount() - self:GetStackCount())
	end
end

function modifier_imba_undying_decay_buff:OnStackCountChanged(stackCount)
	if not IsServer() then return end

	if self:GetParent():HasModifier("modifier_imba_undying_decay_buff_counter") then
		self:GetParent():FindModifierByName("modifier_imba_undying_decay_buff_counter"):SetStackCount(self:GetParent():FindModifierByName("modifier_imba_undying_decay_buff_counter"):GetStackCount() + (self:GetStackCount() - stackCount))
	end
end

function modifier_imba_undying_decay_buff:DeclareFunctions()
	return { MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS }
end

-- "Each status buff of Decay increases Undying's model size by 2%. This has no impact on his collision size."
function modifier_imba_undying_decay_buff:GetModifierModelScale()
	return 2
end

function modifier_imba_undying_decay_buff:GetModifierBonusStats_Strength()
	return self:GetStackCount()
end

----------------------------------------------
-- MODIFIER_IMBA_UNDYING_DECAY_BUFF_COUNTER --
----------------------------------------------

function modifier_imba_undying_decay_buff_counter:IsPurgable() return false end

function modifier_imba_undying_decay_buff_counter:GetEffectName()
	return "particles/units/heroes/hero_undying/undying_decay_strength_buff.vpcf"
end

----------------------------------------
-- MODIFIER_IMBA_UNDYING_DECAY_DEBUFF --
----------------------------------------

function modifier_imba_undying_decay_debuff:IsHidden() return true end

function modifier_imba_undying_decay_debuff:IsPurgable() return false end

function modifier_imba_undying_decay_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_undying_decay_debuff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	self.str_steal          = self:GetAbility():GetSpecialValueFor("str_steal")
	self.str_steal_scepter  = self:GetAbility():GetSpecialValueFor("str_steal_scepter")
	self.brains_int_pct     = self:GetAbility():GetSpecialValueFor("brains_int_pct")
	self.hp_removal_per_str = 20

	if not IsServer() then return end

	if not self:GetCaster():HasScepter() then
		self:SetStackCount(self:GetStackCount() + self.str_steal)
		self.strength_reduction = self.str_steal
	else
		self:SetStackCount(self:GetStackCount() + self.str_steal_scepter)
		self.strength_reduction = self.str_steal_scepter
	end

	-- "The strength loss on the target does not keep the current health percentage, but instead removes 20 health per strength from the current health pool."	
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.hp_removal_per_str * self.strength_reduction,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NON_LETHAL,
		ability = self:GetAbility()
	}

	ApplyDamage(damageTable)
end

function modifier_imba_undying_decay_debuff:OnDestroy()
	if not IsServer() then return end

	if self:GetParent():HasModifier("modifier_imba_undying_decay_debuff_counter") then
		self:GetParent():FindModifierByName("modifier_imba_undying_decay_debuff_counter"):SetStackCount(self:GetParent():FindModifierByName("modifier_imba_undying_decay_debuff_counter"):GetStackCount() - self:GetStackCount())
	end

	if self:GetAbility() and self:GetAbility().debuff_modifier_table then
		Custom_ArrayRemove(self:GetAbility().debuff_modifier_table, function(i, j)
			-- Remember that you return what you want to KEEP, which is kinda contradictory to the function name...
			return self:GetAbility().debuff_modifier_table[i] ~= self
		end)
	end
end

function modifier_imba_undying_decay_debuff:OnStackCountChanged(stackCount)
	if not IsServer() then return end

	if self:GetParent():HasModifier("modifier_imba_undying_decay_debuff_counter") then
		self:GetParent():FindModifierByName("modifier_imba_undying_decay_debuff_counter"):SetStackCount(self:GetParent():FindModifierByName("modifier_imba_undying_decay_debuff_counter"):GetStackCount() + (self:GetStackCount() - stackCount))
	end
end

function modifier_imba_undying_decay_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		-- IMBAfication: Braiiiinssss...
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_imba_undying_decay_debuff:GetModifierBonusStats_Strength()
	return self:GetStackCount() * (-1)
end

function modifier_imba_undying_decay_debuff:GetModifierBonusStats_Intellect()
	return math.ceil(self:GetStackCount() * self.brains_int_pct / 100) * (-1)
end

------------------------------------------------
-- MODIFIER_IMBA_UNDYING_DECAY_DEBUFF_COUNTER --
------------------------------------------------

function modifier_imba_undying_decay_debuff_counter:IsPurgable() return false end

---------------------------
-- IMBA_UNDYING_SOUL_RIP --
---------------------------

function imba_undying_soul_rip:CastFilterResultTarget(target)
	-- Can target tombstone
	if target:GetName() == "npc_dota_unit_undying_tombstone" and target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return UF_SUCCESS
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	end
end

function imba_undying_soul_rip:OnSpellStart()
	-- "Does not count Undying, the target, wards, buildings, invisible enemies and units in the Fog of War."
	-- "Spell immune allies are counted, including the zombies from Tombstone."
	-- "Units which require a certain amount of attacks to be killed do not lose health when counted in by Soul Rip."

	self:GetCaster():EmitSound("Hero_Undying.SoulRip.Cast")

	if self:GetCaster():GetName() == "npc_dota_hero_undying" and RollPercentage(50) then
		if not self.responses then
			self.responses =
			{
				"undying_undying_soulrip_02",
				"undying_undying_soulrip_03",
				"undying_undying_soulrip_04",
				"undying_undying_soulrip_07"
			}
		end

		if not self.responses_big then
			self.responses_big =
			{
				"undying_undying_big_soulrip_02",
				"undying_undying_big_soulrip_03",
				"undying_undying_big_soulrip_04",
				"undying_undying_big_soulrip_07"
			}
		end

		if self:GetCaster():HasModifier("modifier_imba_undying_flesh_golem") then
			-- WHy isn't there a function that plays only on one unit but not on client? This function doesn't make the sound come out of the unit which is wrong, but no one else is supposed to hear these voicelines either. Ugh...
			EmitSoundOnClient(self.responses_big[RandomInt(1, #self.responses_big)], self:GetCaster():GetPlayerOwner())
		else
			EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
		end
	end

	local target          = self:GetCursorTarget()

	local units_ripped    = 0
	local damage_particle = nil

	for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)) do
		if unit ~= self:GetCaster() and unit ~= target then
			if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
				damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_soul_rip_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			else
				damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_soul_rip_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			end

			ParticleManager:SetParticleControlEnt(damage_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(damage_particle)

			-- "Units which require a certain amount of attacks to be killed do not lose health when counted in by Soul Rip."
			if unit:GetName() ~= "npc_dota_unit_undying_zombie" then
				unit:SetHealth(math.max(unit:GetHealth() - self:GetSpecialValueFor("damage_per_unit"), 1))
			elseif unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() and unit:GetTeamNumber() ~= target:GetTeamNumber() then
				-- IMBAfication: Do Zombies Have Souls?
				unit:PerformAttack(target, true, true, true, true, false, false, true)
			end

			-- ApplyDamage({
			-- victim 			= unit,
			-- damage 			= self:GetSpecialValueFor("damage_per_unit"),
			-- damage_type		= DAMAGE_TYPE_PURE,
			-- damage_flags 	= DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL, -- Putting reflection flag here in case of unwanted interactions
			-- attacker 		= self:GetCaster(),
			-- ability 		= self
			-- })

			units_ripped = units_ripped + 1

			if units_ripped >= self:GetSpecialValueFor("max_units") then
				break
			end
		end
	end

	if units_ripped >= 1 then
		if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and not target:TriggerSpellAbsorb(self) then
			target:EmitSound("Hero_Undying.SoulRip.Enemy")

			ApplyDamage({
				victim       = target,
				damage       = self:GetSpecialValueFor("damage_per_unit") * units_ripped,
				damage_type  = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = self:GetCaster(),
				ability      = self
			})

			-- IMBAfication: Soul Injection
			local injection_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_undying_soul_rip_soul_injection_debuff", { duration = self:GetSpecialValueFor("soul_injection_duration") * (1 - target:GetStatusResistance()) })

			if injection_modifier then
				injection_modifier:SetStackCount(units_ripped)

				if target.CalculateStatBonus then
					target:CalculateStatBonus(true)
				end
			end
		elseif target:GetTeamNumber() == self:GetCaster():GetTeamNumber() and target:GetName() ~= "npc_dota_unit_undying_tombstone" then
			target:EmitSound("Hero_Undying.SoulRip.Ally")

			target:Heal(self:GetSpecialValueFor("damage_per_unit") * units_ripped, self:GetCaster())

			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, self:GetSpecialValueFor("damage_per_unit") * units_ripped, nil)

			-- IMBAfication: Soul Injection
			local injection_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_undying_soul_rip_soul_injection", { duration = self:GetSpecialValueFor("soul_injection_duration") })

			if injection_modifier then
				injection_modifier:SetStackCount(units_ripped)

				if target.CalculateStatBonus then
					target:CalculateStatBonus(true)
				end
			end
		elseif target:GetTeamNumber() == self:GetCaster():GetTeamNumber() and target:GetName() == "npc_dota_unit_undying_tombstone" then
			target:EmitSound("Hero_Undying.SoulRip.Ally")

			target:Heal(self:GetSpecialValueFor("tombstone_heal"), self:GetCaster())

			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, self:GetSpecialValueFor("tombstone_heal"), nil)
		end
	end
end

---------------------------------------------------
-- MODIFIER_IMBA_UNDYING_SOUL_RIP_SOUL_INJECTION --
---------------------------------------------------

function modifier_imba_undying_soul_rip_soul_injection:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_undying_soul_rip_soul_injection:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.soul_injection_stats_per_unit = self:GetAbility():GetSpecialValueFor("soul_injection_stats_per_unit")
end

function modifier_imba_undying_soul_rip_soul_injection:OnDestroy()
	if not IsServer() then return end

	if self:GetParent().CalculateStatBonus then
		self:GetParent():CalculateStatBonus(true)
	end
end

function modifier_imba_undying_soul_rip_soul_injection:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_imba_undying_soul_rip_soul_injection:GetModifierBonusStats_Strength()
	return self.soul_injection_stats_per_unit * self:GetStackCount()
end

function modifier_imba_undying_soul_rip_soul_injection:GetModifierBonusStats_Agility()
	return self.soul_injection_stats_per_unit * self:GetStackCount()
end

function modifier_imba_undying_soul_rip_soul_injection:GetModifierBonusStats_Intellect()
	return self.soul_injection_stats_per_unit * self:GetStackCount()
end

----------------------------------------------------------
-- MODIFIER_IMBA_UNDYING_SOUL_RIP_SOUL_INJECTION_DEBUFF --
----------------------------------------------------------

function modifier_imba_undying_soul_rip_soul_injection_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_undying_soul_rip_soul_injection_debuff:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.soul_injection_stats_per_unit = self:GetAbility():GetSpecialValueFor("soul_injection_stats_per_unit") * (-1)
end

function modifier_imba_undying_soul_rip_soul_injection_debuff:OnDestroy()
	if not IsServer() then return end

	if self:GetParent().CalculateStatBonus then
		self:GetParent():CalculateStatBonus(true)
	end
end

function modifier_imba_undying_soul_rip_soul_injection_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_imba_undying_soul_rip_soul_injection_debuff:GetModifierBonusStats_Strength()
	return self.soul_injection_stats_per_unit * self:GetStackCount()
end

function modifier_imba_undying_soul_rip_soul_injection_debuff:GetModifierBonusStats_Agility()
	return self.soul_injection_stats_per_unit * self:GetStackCount()
end

function modifier_imba_undying_soul_rip_soul_injection_debuff:GetModifierBonusStats_Intellect()
	return self.soul_injection_stats_per_unit * self:GetStackCount()
end

----------------------------
-- IMBA_UNDYING_TOMBSTONE --
----------------------------

function imba_undying_tombstone:OnSpellStart(deathPosition)
	local position = self:GetCursorPosition()

	if deathPosition then
		position = deathPosition
	end

	EmitSoundOnLocationWithCaster(position, "Hero_Undying.Tombstone", self:GetCaster())

	if self:GetCaster():GetName() == "npc_dota_hero_undying" then
		if not self.responses then
			self.responses =
			{
				"undying_undying_tombstone_01",
				"undying_undying_tombstone_02",
				"undying_undying_tombstone_03",
				"undying_undying_tombstone_04",
				"undying_undying_tombstone_05",
				"undying_undying_tombstone_06",
				"undying_undying_tombstone_07",
				"undying_undying_tombstone_08",
				"undying_undying_tombstone_09",
				"undying_undying_tombstone_10",
				"undying_undying_tombstone_11",
				"undying_undying_tombstone_12",
				"undying_undying_tombstone_13"
			}
		end

		if not self.responses_big then
			self.responses_big =
			{
				"undying_undying_big_tombstone_01",
				"undying_undying_big_tombstone_02",
				"undying_undying_big_tombstone_03",
				"undying_undying_big_tombstone_04",
				"undying_undying_big_tombstone_05",
				"undying_undying_big_tombstone_06",
				"undying_undying_big_tombstone_07",
				"undying_undying_big_tombstone_08",
				"undying_undying_big_tombstone_09",
				"undying_undying_big_tombstone_10",
				"undying_undying_big_tombstone_11",
				"undying_undying_big_tombstone_12",
				"undying_undying_big_tombstone_13"
			}
		end

		if self:GetCaster():HasModifier("modifier_imba_undying_flesh_golem") then
			-- WHy isn't there a function that plays only on one unit but not on client? This function doesn't make the sound come out of the unit which is wrong, but no one else is supposed to hear these voicelines either. Ugh...
			EmitSoundOnClient(self.responses_big[RandomInt(1, #self.responses_big)], self:GetCaster():GetPlayerOwner())
		else
			EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
		end
	end

	local tombstone = CreateUnitByName("npc_dota_unit_tombstone" .. self:GetLevel(), position, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())

	-- Just gonna spam all the health functions to see what sticks cause this is super inconsistent
	tombstone:SetBaseMaxHealth(self:GetTalentSpecialValueFor("hits_to_destroy_tooltip") * 4)
	tombstone:SetMaxHealth(self:GetTalentSpecialValueFor("hits_to_destroy_tooltip") * 4)
	tombstone:SetHealth(self:GetTalentSpecialValueFor("hits_to_destroy_tooltip") * 4)

	tombstone:AddNewModifier(self:GetCaster(), self, "modifier_imba_undying_tombstone_zombie_aura", { duration = self:GetSpecialValueFor("duration") })
	tombstone:AddNewModifier(self:GetCaster(), self, "modifier_magic_immune", { duration = self:GetSpecialValueFor("duration") })
	tombstone:AddNewModifier(self:GetCaster(), self, "modifier_kill", { duration = self:GetSpecialValueFor("duration") })

	-- "Destroys trees within 300 radius around the Tombstone upon cast."
	GridNav:DestroyTreesAroundPoint(position, 300, true)
end

-------------------------------------------------
-- MODIFIER_IMBA_UNDYING_TOMBSTONE_ZOMBIE_AURA --
-------------------------------------------------

-- I believe this was meant to be an intrinsic modifier to the undying_tombstone_zombie_aura ability, but it seems like the Tombstone doesn't have this anymore? So I guess I'll just use it as the tombstone's standard modifier

function modifier_imba_undying_tombstone_zombie_aura:IsHidden() return true end

function modifier_imba_undying_tombstone_zombie_aura:IsPurgable() return false end

function modifier_imba_undying_tombstone_zombie_aura:OnCreated()
	self.duration                     = self:GetAbility():GetSpecialValueFor("duration")
	self.radius                       = self:GetAbility():GetSpecialValueFor("radius")
	self.health_threshold_pct_tooltip = self:GetAbility():GetSpecialValueFor("health_threshold_pct_tooltip")
	self.zombie_interval              = self:GetAbility():GetSpecialValueFor("zombie_interval")
	self.level                        = self:GetAbility():GetLevel()

	if not IsServer() then return end

	self.zombie_types = { "npc_dota_unit_undying_zombie", "npc_dota_unit_undying_zombie_torso" }

	self:OnIntervalThink()
	self:StartIntervalThink(self.zombie_interval)
end

function modifier_imba_undying_tombstone_zombie_aura:OnIntervalThink()
	local zombie              = nil
	local deathstrike_ability = nil

	-- "Zombies do not spawn for invisible units or units in the Fog of War."
	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)) do
		-- "Zombies do not spawn for wards, buildings, couriers, hidden units and zombies from an enemy Tombstone."
		if not enemy:IsCourier() and enemy:GetName() ~= "npc_dota_unit_undying_zombie" then
			zombie = CreateUnitByName(self.zombie_types[RandomInt(1, #self.zombie_types)], enemy:GetAbsOrigin(), true, self:GetParent(), self:GetParent(), self:GetCaster():GetTeamNumber())

			zombie:EmitSound("Undying_Zombie.Spawn")

			zombie:SetBaseDamageMin(zombie:GetBaseDamageMin() + self:GetCaster():FindTalentValue("special_bonus_imba_undying_tombstone_zombie_damage"))
			zombie:SetBaseDamageMax(zombie:GetBaseDamageMax() + self:GetCaster():FindTalentValue("special_bonus_imba_undying_tombstone_zombie_damage"))

			-- Seems like these things are STILL getting stuck on units so put a bit of an offest
			FindClearSpaceForUnit(zombie, enemy:GetAbsOrigin() + RandomVector(enemy:GetHullRadius() + zombie:GetHullRadius()), true)
			ResolveNPCPositions(zombie:GetAbsOrigin(), zombie:GetHullRadius())
			zombie:SetAggroTarget(enemy)

			-- Passive modifier that handles the zombie's health and aggro
			zombie:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_undying_tombstone_zombie_modifier", { enemy_entindex = enemy:entindex() })

			deathstrike_ability = zombie:AddAbility("imba_undying_tombstone_zombie_deathstrike")

			if deathstrike_ability then
				deathstrike_ability:SetLevel(self.level)
			end

			zombie:SwapAbilities("imba_undying_tombstone_zombie_deathstrike", "undying_tombstone_zombie_deathstrike", true, false)
			zombie:RemoveAbility("undying_tombstone_zombie_deathstrike")
		end
	end
end

-- "When the Tombstone expires or is killed, all its zombies instantly die."
function modifier_imba_undying_tombstone_zombie_aura:OnDestroy()
	if not IsServer() then return end

	for _, ent in pairs(Entities:FindAllByName("npc_dota_unit_undying_zombie")) do
		if ent:GetOwner() == self:GetParent() then
			-- IMBAfication: No Home to Return
			if self:GetRemainingTime() > 0 then
				ent:ForceKill(false)
			else
				if ent:HasModifier("modifier_imba_undying_tombstone_zombie_modifier") then
					ent:FindModifierByName("modifier_imba_undying_tombstone_zombie_modifier").bTombstoneDead = true
					ent:FindModifierByName("modifier_imba_undying_tombstone_zombie_modifier").aggro_target   = nil
				end

				ent:SetOwner(self:GetCaster())
				ent:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
				ent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_undying_tombstone_zombie_modifier_no_home", { duration = self.duration })
				ent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kill", { duration = self.duration })
			end
		end
	end
end

function modifier_imba_undying_tombstone_zombie_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_imba_undying_tombstone_zombie_aura:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_imba_undying_tombstone_zombie_aura:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_imba_undying_tombstone_zombie_aura:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_imba_undying_tombstone_zombie_aura:OnAttackLanded(keys)
	if keys.target == self:GetParent() then
		if (keys.attacker:IsRealHero() or keys.attacker:IsClone() or keys.attacker:IsTempestDouble()) then
			self:GetParent():SetHealth(self:GetParent():GetHealth() - 4)
		else
			self:GetParent():SetHealth(self:GetParent():GetHealth() - 1)
		end

		if self:GetParent():GetHealth() <= 0 then
			self:GetParent():Kill(nil, keys.attacker)
			self:Destroy()
		end
	end
end

-----------------------------------------------------
-- MODIFIER_IMBA_UNDYING_TOMBSTONE_ZOMBIE_MODIFIER --
-----------------------------------------------------

function modifier_imba_undying_tombstone_zombie_modifier:IsPurgable() return false end

function modifier_imba_undying_tombstone_zombie_modifier:OnCreated(keys)
	if not IsServer() then return end

	self.aggro_target = EntIndexToHScript(keys.enemy_entindex)

	self.invis_timer  = 0
	self.game_time    = GameRules:GetGameTime()
end

function modifier_imba_undying_tombstone_zombie_modifier:CheckState()
	if IsServer() then
		if not self.bTombstoneDead then
			-- "When a zombies' target turns invisible, the associated zombies die after 0.1 seconds."
			if not self.aggro_target or self.aggro_target:IsNull() or (self.aggro_target:IsInvisible() and not self:GetParent():CanEntityBeSeenByMyTeam(self.aggro_target)) then
				self.invis_timer = GameRules:GetGameTime() - self.game_time

				if self.invis_timer >= 0.1 then
					self:GetParent():ForceKill(false)
				end
			else
				self.invis_timer = 0

				if not self:GetParent():CanEntityBeSeenByMyTeam(self.aggro_target) then
					ExecuteOrderFromTable({
						UnitIndex = self:GetParent():entindex(),
						OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
						Position = self.aggro_target:GetAbsOrigin()
					})
				elseif self:GetParent():GetAggroTarget() ~= self.aggro_target then
					ExecuteOrderFromTable({
						UnitIndex = self:GetParent():entindex(),
						OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
						TargetIndex = self.aggro_target
					})
				end

				self.game_time = GameRules:GetGameTime()
			end
		end
	end
end

function modifier_imba_undying_tombstone_zombie_modifier:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,

		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_imba_undying_tombstone_zombie_modifier:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_imba_undying_tombstone_zombie_modifier:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_imba_undying_tombstone_zombie_modifier:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_imba_undying_tombstone_zombie_modifier:OnAttackLanded(keys)
	if keys.target == self:GetParent() then
		if (keys.attacker:IsRealHero() or keys.attacker:IsClone() or keys.attacker:IsTempestDouble() or keys.attacker:IsBuilding()) then
			self:GetParent():Kill(nil, keys.attacker)
			self:Destroy()
		else
			-- "Illusions and creep-heroes are treated like creeps by the zombies, so the take 2 attacks to destroy it, instead of 1."
			self:GetParent():SetHealth(self:GetParent():GetHealth() - 1)

			if self:GetParent():GetHealth() <= 0 then
				self:GetParent():Kill(nil, keys.attacker)
				self:Destroy()
			end
		end
	end
end

function modifier_imba_undying_tombstone_zombie_modifier:OnDeath(keys)
	if self.aggro_target and keys.unit == self.aggro_target and not keys.reincarnate then
		self:GetParent():ForceKill(false)
	end
end

-------------------------------------------------------------
-- MODIFIER_IMBA_UNDYING_TOMBSTONE_ZOMBIE_MODIFIER_NO_HOME --
-------------------------------------------------------------

function modifier_imba_undying_tombstone_zombie_modifier_no_home:IsPurgable() return false end

function modifier_imba_undying_tombstone_zombie_modifier_no_home:GetStatusEffectName()
	return "particles/econ/items/spirit_breaker/spirit_breaker_iron_surge/status_effect_iron_surge.vpcf"
end

-----------------------------------------------
-- IMBA_UNDYING_TOMBSTONE_ZOMBIE_DEATHSTRIKE --
-----------------------------------------------

function imba_undying_tombstone_zombie_deathstrike:GetIntrinsicModifierName()
	return "modifier_imba_undying_tombstone_zombie_deathstrike"
end

--------------------------------------------------------
-- MODIFIER_IMBA_UNDYING_TOMBSTONE_ZOMBIE_DEATHSTRIKE --
--------------------------------------------------------

-- Going to combine Deathstrike and the standard zombie modifier logic together. Might be a bad idea?...

function modifier_imba_undying_tombstone_zombie_deathstrike:IsHidden() return true end

function modifier_imba_undying_tombstone_zombie_deathstrike:IsPurgable() return false end

function modifier_imba_undying_tombstone_zombie_deathstrike:RemoveOnDeath() return false end

function modifier_imba_undying_tombstone_zombie_deathstrike:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_imba_undying_tombstone_zombie_deathstrike:OnAttackLanded(keys)
	if self:GetAbility() and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther() and keys.target:GetTeamNumber() ~= keys.attacker:GetTeamNumber() and keys.target:GetName() ~= "npc_dota_visage_familiar" then
		keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_undying_tombstone_zombie_deathstrike_slow_counter", {})
		local deathstrike_modifier = keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_undying_tombstone_zombie_deathstrike_slow", { duration = self:GetAbility():GetSpecialValueFor("duration") })

		if deathstrike_modifier then
			deathstrike_modifier:SetDuration(self:GetAbility():GetSpecialValueFor("duration") * (1 - keys.target:GetStatusResistance()), true)
		end
	end
end

---------------------------------------------------------------------
-- MODIFIER_IMBA_UNDYING_TOMBSTONE_ZOMBIE_DEATHSTRIKE_SLOW_COUNTER --
---------------------------------------------------------------------

function modifier_imba_undying_tombstone_zombie_deathstrike_slow_counter:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.slow = self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_imba_undying_tombstone_zombie_deathstrike_slow_counter:OnRefresh()
	self:OnCreated()
end

function modifier_imba_undying_tombstone_zombie_deathstrike_slow_counter:OnStackCountChanged(stackCount)
	if not IsServer() then return end

	if self:GetStackCount() <= 0 then
		self:Destroy()
	end
end

function modifier_imba_undying_tombstone_zombie_deathstrike_slow_counter:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_imba_undying_tombstone_zombie_deathstrike_slow_counter:GetModifierMoveSpeedBonus_Percentage()
	return self.slow * self:GetStackCount()
end

-------------------------------------------------------------
-- MODIFIER_IMBA_UNDYING_TOMBSTONE_ZOMBIE_DEATHSTRIKE_SLOW --
-------------------------------------------------------------

function modifier_imba_undying_tombstone_zombie_deathstrike_slow:IsHidden() return true end

function modifier_imba_undying_tombstone_zombie_deathstrike_slow:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_undying_tombstone_zombie_deathstrike_slow:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.health_threshold_pct = self:GetAbility():GetSpecialValueFor("health_threshold_pct")
	self.duration             = self:GetAbility():GetSpecialValueFor("duration")

	if not IsServer() then return end

	if self:GetParent():HasModifier("modifier_imba_undying_tombstone_zombie_deathstrike_slow_counter") then
		self:GetParent():FindModifierByName("modifier_imba_undying_tombstone_zombie_deathstrike_slow_counter"):IncrementStackCount()
	end

	-- "The health of the target is checked in 0.5 second intervals. If their target is below the threshold, the Deathlust Frenzy buff is placed."
	self:StartIntervalThink(0.5)
end

function modifier_imba_undying_tombstone_zombie_deathstrike_slow:OnIntervalThink()
	if self:GetParent():GetHealthPercent() <= self.health_threshold_pct then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_undying_tombstone_zombie_deathlust", { duration = self.duration })
	end
end

function modifier_imba_undying_tombstone_zombie_deathstrike_slow:OnDestroy()
	if not IsServer() then return end

	if self:GetParent():HasModifier("modifier_imba_undying_tombstone_zombie_deathstrike_slow_counter") then
		self:GetParent():FindModifierByName("modifier_imba_undying_tombstone_zombie_deathstrike_slow_counter"):DecrementStackCount()
	end
end

------------------------------------------------------
-- MODIFIER_IMBA_UNDYING_TOMBSTONE_ZOMBIE_DEATHLUST --
------------------------------------------------------

function modifier_imba_undying_tombstone_zombie_deathlust:IsPurgable() return false end

function modifier_imba_undying_tombstone_zombie_deathlust:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.bonus_move_speed   = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_imba_undying_tombstone_zombie_deathlust:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_imba_undying_tombstone_zombie_deathlust:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_move_speed
end

function modifier_imba_undying_tombstone_zombie_deathlust:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

-----------------------------------
-- IMBA_UNDYING_FLESH_GOLEM_GRAB --
-----------------------------------

function imba_undying_flesh_golem_grab:IsStealable() return false end

function imba_undying_flesh_golem_grab:IsNetherWardStealable() return false end

function imba_undying_flesh_golem_grab:GetAssociatedSecondaryAbilities()
	return "imba_undying_flesh_golem_throw"
end

function imba_undying_flesh_golem_grab:CastFilterResultTarget(target)
	if self:GetCaster():HasTalent("special_bonus_imba_undying_flesh_golem_grab_allies") then
		if target:GetName() == "npc_dota_unit_undying_tombstone" then
			return UF_SUCCESS
		elseif target == self:GetCaster() then
			return UF_FAIL_CUSTOM
		else
			return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP, self:GetCaster():GetTeamNumber())
		end
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber())
	end
end

function imba_undying_flesh_golem_grab:GetCustomCastErrorTarget(target)
	if self:GetCaster():HasTalent("special_bonus_imba_undying_flesh_golem_grab_allies") and target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	end
end

function imba_undying_flesh_golem_grab:OnSpellStart()
	local target = self:GetCursorTarget()

	local grab_modifier_debuff = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_undying_flesh_golem_grab_debuff", { duration = self:GetSpecialValueFor("duration") })

	if grab_modifier_debuff then
		local grab_modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_undying_flesh_golem_grab", {
			duration        = self:GetSpecialValueFor("duration"),
			target_entindex = target:entindex()
		})

		if grab_modifier and self:GetCaster():GetTeamNumber() ~= target:GetTeamNumber() then
			grab_modifier_debuff:SetDuration(self:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance()), true)
			grab_modifier:SetDuration(self:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance()), true)
		end
	end

	if self:GetCaster():HasAbility("imba_undying_flesh_golem_throw") then
		self:GetCaster():FindAbilityByName("imba_undying_flesh_golem_throw"):SetActivated(true)
		self:GetCaster():SwapAbilities("imba_undying_flesh_golem_grab", "imba_undying_flesh_golem_throw", false, true)
	end
end

--------------------------------------------
-- MODIFIER_IMBA_UNDYING_FLESH_GOLEM_GRAB --
--------------------------------------------

function modifier_imba_undying_flesh_golem_grab:IsHidden() return true end

function modifier_imba_undying_flesh_golem_grab:IsPurgable() return false end

-- Undying should NEVER be able to grab more than one unit at a time, but this is just in case something breaks...and hopefully makes it not as broken
function modifier_imba_undying_flesh_golem_grab:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_undying_flesh_golem_grab:OnCreated(keys)
	if not IsServer() then return end

	self.target = EntIndexToHScript(keys.target_entindex)
end

---------------------------------------------------
-- MODIFIER_IMBA_UNDYING_FLESH_GOLEM_GRAB_DEBUFF --
---------------------------------------------------

function modifier_imba_undying_flesh_golem_grab_debuff:IsPurgable() return false end

function modifier_imba_undying_flesh_golem_grab_debuff:OnCreated()
	if not IsServer() then return end

	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.blink_break_range = self:GetAbility():GetSpecialValueFor("blink_break_range")
	self.position          = self:GetCaster():GetAbsOrigin()

	self:StartIntervalThink(FrameTime())
end

function modifier_imba_undying_flesh_golem_grab_debuff:OnIntervalThink()
	if not self:GetCaster() or self:GetCaster():IsStunned() or self:GetCaster():IsHexed() or self:GetCaster():IsNightmared() or self:GetCaster():IsOutOfGame() or not self:GetCaster():HasModifier("modifier_imba_undying_flesh_golem") or (self:GetCaster():GetAbsOrigin() - self.position):Length2D() > self.blink_break_range then
		self:Destroy()
	end

	if self:GetCaster():GetAggroTarget() ~= self:GetParent() then
		self:GetParent():SetAbsOrigin(self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1")) - Vector(0, 0, 50))
	else
		self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 50))
	end

	self.position = self:GetCaster():GetAbsOrigin()
end

function modifier_imba_undying_flesh_golem_grab_debuff:OnDestroy()
	if not IsServer() then return end

	-- self:GetParent():FollowEntity(nil, false)

	FindClearSpaceForUnit(self:GetCaster(), self:GetCaster():GetAbsOrigin(), true)
	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)

	if self:GetCaster():HasAbility("imba_undying_flesh_golem_throw") and self:GetCaster():FindAbilityByName("imba_undying_flesh_golem_throw"):IsActivated() then
		self:GetCaster():FindAbilityByName("imba_undying_flesh_golem_throw"):SetActivated(false)
		self:GetCaster():SwapAbilities("imba_undying_flesh_golem_grab", "imba_undying_flesh_golem_throw", true, false)
	end
end

function modifier_imba_undying_flesh_golem_grab_debuff:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_TETHERED]          = true
	}
end

------------------------------------
-- IMBA_UNDYING_FLESH_GOLEM_THROW --
------------------------------------

function imba_undying_flesh_golem_throw:IsStealable() return false end

function imba_undying_flesh_golem_throw:GetAssociatedPrimaryAbilities()
	return "imba_undying_flesh_golem_grab"
end

function imba_undying_flesh_golem_throw:OnSpellStart()
	if self:GetCaster():HasModifier("modifier_imba_undying_flesh_golem_grab") and self:GetCaster():FindModifierByName("modifier_imba_undying_flesh_golem_grab").target then
		local target = self:GetCaster():FindModifierByName("modifier_imba_undying_flesh_golem_grab").target

		target:RemoveModifierByName("modifier_imba_undying_flesh_golem_grab_debuff")
		self:GetCaster():RemoveModifierByName("modifier_imba_undying_flesh_golem_grab")

		local knockback_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_generic_motion_controller",
			{
				distance               = (self:GetCursorPosition() - target:GetAbsOrigin()):Length2D(),
				direction_x            = (self:GetCursorPosition() - target:GetAbsOrigin()):Normalized().x,
				direction_y            = (self:GetCursorPosition() - target:GetAbsOrigin()):Normalized().y,
				direction_z            = (self:GetCursorPosition() - target:GetAbsOrigin()):Normalized().z,
				duration               = (self:GetCursorPosition() - target:GetAbsOrigin()):Length2D() / self:GetSpecialValueFor("throw_speed"),
				height                 = self:GetSpecialValueFor("throw_max_height") * ((self:GetCursorPosition() - target:GetAbsOrigin()):Length2D() / self.BaseClass.GetCastRange(self, self:GetCursorPosition(), target)),
				bGroundStop            = false,
				bDecelerate            = false,
				bInterruptible         = false,
				bIgnoreTenacity        = true,
				bTreeRadius            = target:GetHullRadius(),
				bStun                  = false,
				bDestroyTreesAlongPath = true
			})
	end
end

------------------------------
-- IMBA_UNDYING_FLESH_GOLEM --
------------------------------

function imba_undying_flesh_golem:GetIntrinsicModifierName()
	return "modifier_imba_undying_flesh_golem_illusion_check"
end

function imba_undying_flesh_golem:OnUpgrade()
	-- Only relevant for the first level of the upgrade
	if self:GetLevel() == 1 then
		local caster = self:GetCaster()
		local ability_grab = "imba_undying_flesh_golem_grab"
		local ability_throw = "imba_undying_flesh_golem_throw"


		if caster:HasAbility(ability_grab) then
			caster:FindAbilityByName(ability_grab):SetLevel(1)
		end

		if caster:HasAbility(ability_throw) then
			caster:FindAbilityByName(ability_throw):SetLevel(1)
		end
	end
end

function imba_undying_flesh_golem:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Undying.FleshGolem.Cast")

	self:GetCaster():StartGesture(ACT_DOTA_SPAWN)

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_undying_flesh_golem", { duration = self:GetSpecialValueFor("duration") })
end

------------------------------------------------------
-- MODIFIER_IMBA_UNDYING_FLESH_GOLEM_ILLUSION_CHECK --
------------------------------------------------------

-- "Illusions get a new Flesh Golem buff, lasting for the full duration, regardless of how much is left on Undying himself."
-- This intrinsic modifier is only meant for illusions to check if their owner has the Flesh Golem modifier, and to apply it if so
function modifier_imba_undying_flesh_golem_illusion_check:IsHidden() return true end

function modifier_imba_undying_flesh_golem_illusion_check:IsPurgable() return false end

function modifier_imba_undying_flesh_golem_illusion_check:RemoveOnDeath() return false end

-- TODO: Cannot test this using the current -upgrade logic
function modifier_imba_undying_flesh_golem_illusion_check:OnCreated()
	if not IsServer() then return end

	if self:GetParent():HasAbility("imba_undying_flesh_golem_grab") then
		self:GetParent():FindAbilityByName("imba_undying_flesh_golem_grab"):SetLevel(1)
		self:GetParent():FindAbilityByName("imba_undying_flesh_golem_grab"):SetActivated(false)
	end

	if self:GetParent():HasAbility("imba_undying_flesh_golem_throw") then
		self:GetParent():FindAbilityByName("imba_undying_flesh_golem_throw"):SetLevel(1)
		self:GetParent():FindAbilityByName("imba_undying_flesh_golem_throw"):SetActivated(false)
	end

	if self:GetAbility() and self:GetParent():IsIllusion() and self:GetParent():GetPlayerOwner():GetAssignedHero():HasModifier("modifier_imba_undying_flesh_golem") then
		self:GetParent():AddNewModifier(self:GetParent():GetPlayerOwner():GetAssignedHero(), self:GetAbility(), "modifier_imba_undying_flesh_golem", { duration = self:GetAbility():GetSpecialValueFor("duration") })

		if self:GetParent():HasAbility("imba_undying_flesh_golem_grab") then
			self:GetParent():FindAbilityByName("imba_undying_flesh_golem_grab"):SetActivated(true)
		end
	end
end

---------------------------------------
-- MODIFIER_IMBA_UNDYING_FLESH_GOLEM --
---------------------------------------

-- function modifier_imba_undying_flesh_golem:IsPurgable()		return false end
-- function modifier_imba_undying_flesh_golem:RemoveOnDeath()	return (not self:GetAbility() or not self:GetAbility():IsStolen()) end

function modifier_imba_undying_flesh_golem:GetEffectName()
	return "particles/units/heroes/hero_undying/undying_fg_aura.vpcf"
end

function modifier_imba_undying_flesh_golem:OnCreated()
	self.slow                 = self:GetAbility():GetSpecialValueFor("slow")
	self.damage               = self:GetAbility():GetSpecialValueFor("damage")
	self.slow_duration        = self:GetAbility():GetSpecialValueFor("slow_duration")
	self.str_percentage       = self:GetAbility():GetSpecialValueFor("str_percentage")
	self.duration             = self:GetAbility():GetSpecialValueFor("duration")
	self.spawn_rate           = self:GetAbility():GetSpecialValueFor("spawn_rate")
	self.zombie_radius        = self:GetAbility():GetSpecialValueFor("zombie_radius")
	self.movement_bonus       = self:GetAbility():GetSpecialValueFor("movement_bonus")
	self.zombie_multiplier    = self:GetAbility():GetSpecialValueFor("zombie_multiplier")
	self.remnants_aura_radius = self:GetAbility():GetSpecialValueFor("remnants_aura_radius")

	if not IsServer() then return end

	if self:GetParent():HasAbility("imba_undying_flesh_golem_grab") then
		self:GetParent():FindAbilityByName("imba_undying_flesh_golem_grab"):SetActivated(true)
	end

	self:StartIntervalThink(FrameTime())
end

function modifier_imba_undying_flesh_golem:OnIntervalThink()
	self.strength = 0
	self.strength = self:GetParent():GetStrength() * self.str_percentage / 100
	self:GetParent():CalculateStatBonus(true)
end

function modifier_imba_undying_flesh_golem:OnDestroy()
	if not IsServer() then return end

	self:GetParent():EmitSound("Hero_Undying.FleshGolem.End")

	if self:GetParent():HasAbility("imba_undying_flesh_golem_grab") then
		self:GetParent():FindAbilityByName("imba_undying_flesh_golem_grab"):SetActivated(false)
	end

	if self:GetParent():HasAbility("imba_undying_flesh_golem_throw") and self:GetParent():FindAbilityByName("imba_undying_flesh_golem_throw"):IsActivated() then
		self:GetParent():FindAbilityByName("imba_undying_flesh_golem_throw"):SetActivated(false)
		self:GetParent():SwapAbilities("imba_undying_flesh_golem_grab", "imba_undying_flesh_golem_throw", true, false)
	end
end

function modifier_imba_undying_flesh_golem:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		-- MODIFIER_PROPERTY_STATS_STRENGTH_BONUS_PERCENTAGE, -- Yeah this still doesn't work
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MODEL_CHANGE,

		MODIFIER_EVENT_ON_ATTACK_LANDED,

		-- IMBAfications: Remnants of Flesh Golem
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_imba_undying_flesh_golem:GetModifierMoveSpeedBonus_Constant()
	return self.movement_bonus
end

function modifier_imba_undying_flesh_golem:GetModifierBonusStats_Strength()
	return self.strength
end

-- function modifier_imba_undying_flesh_golem:GetModifierBonusStats_Strength_Percentage()
-- return self.str_percentage
-- end

function modifier_imba_undying_flesh_golem:GetModifierModelChange()
	return "models/heroes/undying/undying_flesh_golem.vmdl"
end

-- This can affect allied units
function modifier_imba_undying_flesh_golem:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther() then
		keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_undying_flesh_golem_slow", {
			duration          = self.slow_duration * (1 - keys.target:GetStatusResistance()),
			slow              = self.slow,
			damage            = self.damage,
			zombie_multiplier = self.zombie_multiplier
		})
	end
end

-- This isn't removed by default or something if I give it the Flesh Golem model?...
function modifier_imba_undying_flesh_golem:OnDeath(keys)
	-- "Flesh Golem is fully canceled on death."
	-- "Rubick stays in Flesh Golem form even after death." -- WTF
	if keys.unit == self:GetParent() and (not self:GetAbility() or not self:GetAbility():IsStolen()) then
		self:Destroy()
	end
end

-- Auras are not purged or removed on death? Setting IsPurgable and RemoveOnDeath flags seems to make no difference
function modifier_imba_undying_flesh_golem:IsAura() return true end

function modifier_imba_undying_flesh_golem:IsAuraActiveOnDeath() return false end

function modifier_imba_undying_flesh_golem:GetAuraRadius() return self.remnants_aura_radius end

function modifier_imba_undying_flesh_golem:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_imba_undying_flesh_golem:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end

function modifier_imba_undying_flesh_golem:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_imba_undying_flesh_golem:GetModifierAura() return "modifier_imba_undying_flesh_golem_plague_aura" end

---------------------------------------------------
-- MODIFIER_IMBA_UNDYING_FLESH_GOLEM_PLAGUE_AURA --
---------------------------------------------------

function modifier_imba_undying_flesh_golem_plague_aura:IsHidden() return self:GetCaster() and self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() end

function modifier_imba_undying_flesh_golem_plague_aura:OnCreated()
	if self:GetAbility() then
		self.remnants_health_damage_pct = self:GetAbility():GetSpecialValueFor("remnants_health_damage_pct")
		self.remnants_max_health_heal_pct_hero = self:GetAbility():GetSpecialValueFor("remnants_max_health_heal_pct_hero")
		self.remnants_max_health_heal_pct_non_hero = self:GetAbility():GetSpecialValueFor("remnants_max_health_heal_pct_non_hero")
	else
		self.remnants_health_damage_pct            = 9
		self.remnants_max_health_heal_pct_hero     = 15
		self.remnants_max_health_heal_pct_non_hero = 2
	end

	self.interval = 0.5

	if not IsServer() then return end

	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		self:StartIntervalThink(self.interval)
	end
end

function modifier_imba_undying_flesh_golem_plague_aura:OnIntervalThink()
	-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), self:GetParent():GetHealth() * self.remnants_health_damage_pct * self.interval / 100, nil)

	ApplyDamage({
		victim       = self:GetParent(),
		damage       = self:GetParent():GetHealth() * self.remnants_health_damage_pct * self.interval / 100,
		damage_type  = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL,
		attacker     = self:GetCaster(),
		ability      = self:GetAbility()
	})
end

function modifier_imba_undying_flesh_golem_plague_aura:DeclareFunctions()
	-- IMBAfications: Remnants of Flesh Golem
	return {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_imba_undying_flesh_golem_plague_aura:OnDeath(keys)
	if keys.unit == self:GetParent() and not keys.reincarnate then
		self:GetCaster():EmitSound("Hero_Undying.SoulRip.Ally")

		local heal_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_fg_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(heal_particle, 1, keys.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.unit:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(heal_particle)

		if keys.unit:IsRealHero() then
			self:GetCaster():Heal(self:GetCaster():GetMaxHealth() * self.remnants_max_health_heal_pct_hero / 100, self:GetCaster())

			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetCaster(), self:GetCaster():GetMaxHealth() * self.remnants_max_health_heal_pct_hero / 100, nil)
		else
			self:GetCaster():Heal(self:GetCaster():GetMaxHealth() * self.remnants_max_health_heal_pct_non_hero / 100, self:GetCaster())

			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetCaster(), self:GetCaster():GetMaxHealth() * self.remnants_max_health_heal_pct_non_hero / 100, nil)
		end
	end
end

function modifier_imba_undying_flesh_golem_plague_aura:OnTooltip()
	return self.remnants_health_damage_pct
end

--------------------------------------------
-- MODIFIER_IMBA_UNDYING_FLESH_GOLEM_SLOW --
--------------------------------------------

function modifier_imba_undying_flesh_golem_slow:IgnoreTenacity() return true end

function modifier_imba_undying_flesh_golem_slow:OnCreated(keys)
	if self:GetAbility() then
		self.slow              = self:GetAbility():GetSpecialValueFor("slow")
		self.damage            = self:GetAbility():GetSpecialValueFor("damage")
		self.zombie_multiplier = self:GetAbility():GetSpecialValueFor("zombie_multiplier")
	elseif keys then
		self.slow              = keys.slow
		self.damage            = keys.damage
		self.zombie_multiplier = keys.zombie_multiplier
	else
		self.slow              = 40
		self.damage            = 25
		self.zombie_multiplier = 2
	end

	if not IsServer() then return end

	if self:GetAbility() then
		self.damage_type = self:GetAbility():GetAbilityDamageType()
	else
		self.damage_type = DAMAGE_TYPE_MAGICAL
	end

	self:SetStackCount(self.slow * (-1))

	self:StartIntervalThink(1)
end

function modifier_imba_undying_flesh_golem_slow:OnIntervalThink()
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), self.damage, nil)

	ApplyDamage({
		victim       = self:GetParent(),
		damage       = self.damage,
		damage_type  = self.damage_type,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		attacker     = self:GetCaster(),
		ability      = self
	})
end

function modifier_imba_undying_flesh_golem_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_imba_undying_flesh_golem_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

function modifier_imba_undying_flesh_golem_slow:GetModifierIncomingDamage_Percentage(keys)
	if keys.attacker:GetName() == "npc_dota_unit_undying_zombie" then
		return 100 * self.zombie_multiplier
	end
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_undying_decay_duration", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_undying_tombstone_zombie_damage", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_undying_tombstone_on_death", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_undying_flesh_golem_grab_allies", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_undying_decay_cooldown", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_undying_decay_duration          = modifier_special_bonus_imba_undying_decay_duration or class({})
modifier_special_bonus_imba_undying_tombstone_zombie_damage = modifier_special_bonus_imba_undying_tombstone_zombie_damage or class({})
modifier_special_bonus_imba_undying_tombstone_on_death      = modifier_special_bonus_imba_undying_tombstone_on_death or class({})
modifier_special_bonus_imba_undying_flesh_golem_grab_allies = modifier_special_bonus_imba_undying_flesh_golem_grab_allies or class({})
modifier_special_bonus_imba_undying_decay_cooldown          = modifier_special_bonus_imba_undying_decay_cooldown or class({})

function modifier_special_bonus_imba_undying_decay_duration:IsHidden() return true end

function modifier_special_bonus_imba_undying_decay_duration:IsPurgable() return false end

function modifier_special_bonus_imba_undying_decay_duration:RemoveOnDeath() return false end

function modifier_special_bonus_imba_undying_tombstone_zombie_damage:IsHidden() return true end

function modifier_special_bonus_imba_undying_tombstone_zombie_damage:IsPurgable() return false end

function modifier_special_bonus_imba_undying_tombstone_zombie_damage:RemoveOnDeath() return false end

function modifier_special_bonus_imba_undying_tombstone_on_death:IsHidden() return true end

function modifier_special_bonus_imba_undying_tombstone_on_death:IsPurgable() return false end

function modifier_special_bonus_imba_undying_tombstone_on_death:RemoveOnDeath() return false end

function modifier_special_bonus_imba_undying_flesh_golem_grab_allies:IsHidden() return true end

function modifier_special_bonus_imba_undying_flesh_golem_grab_allies:IsPurgable() return false end

function modifier_special_bonus_imba_undying_flesh_golem_grab_allies:RemoveOnDeath() return false end

function modifier_special_bonus_imba_undying_decay_cooldown:IsHidden() return true end

function modifier_special_bonus_imba_undying_decay_cooldown:IsPurgable() return false end

function modifier_special_bonus_imba_undying_decay_cooldown:RemoveOnDeath() return false end

function modifier_special_bonus_imba_undying_tombstone_on_death:DeclareFunctions()
	return { MODIFIER_EVENT_ON_DEATH }
end

function modifier_special_bonus_imba_undying_tombstone_on_death:OnDeath(keys)
	if keys.unit == self:GetParent() and self:GetParent():HasAbility("imba_undying_tombstone") and self:GetParent():FindAbilityByName("imba_undying_tombstone"):IsTrained() then
		self:GetParent():FindAbilityByName("imba_undying_tombstone"):OnSpellStart(self:GetParent():GetAbsOrigin())
	end
end

function imba_undying_decay:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_undying_decay_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_undying_decay_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_undying_decay_cooldown"), "modifier_special_bonus_imba_undying_decay_cooldown", {})
	end
end

function imba_undying_tombstone:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_undying_tombstone_on_death") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_undying_tombstone_on_death") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_undying_tombstone_on_death"), "modifier_special_bonus_imba_undying_tombstone_on_death", {})
	end
end

function imba_undying_flesh_golem_grab:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_undying_flesh_golem_grab_allies") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_undying_flesh_golem_grab_allies") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_undying_flesh_golem_grab_allies"), "modifier_special_bonus_imba_undying_flesh_golem_grab_allies", {})
	end
end
