-- Creator:
--     AltiV, February 25th, 2020
-- Reworked by: Shush


----------------------
-- HELPER FUNCTIONS --
----------------------

function IsUndyingZombie(unit)
	if unit.GetClassname then
		if unit:GetClassname() == "npc_dota_unit_undying_zombie" then
			return true
		end
	end

	return false
end

function IsUndyingTombstone(unit)
	if unit.GetClassname then
		if unit:GetClassname() == "npc_dota_unit_undying_tombstone" then
			return true
		end
	end

	return false
end

function GenerateZombieType()
	local zombie_types = { "npc_dota_undying_imba_zombie_torso", "npc_dota_undying_imba_zombie" }

	local chosen_zombie = zombie_types[RandomInt(1, #zombie_types)]
	return chosen_zombie
end

-------------------
-- UNDYING DECAY --
-------------------


LinkLuaModifier("modifier_imba_undying_decay_debuff", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_decay_buff", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)

imba_undying_decay = imba_undying_decay or class({})

function imba_undying_decay:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_undying_decay:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_undying_decay_cooldown")
end

function imba_undying_decay:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = ability:GetCursorPosition()
	local responses = { "undying_undying_decay_03", "undying_undying_decay_04", "undying_undying_decay_05", "undying_undying_decay_07", "undying_undying_decay_08", "undying_undying_decay_09", "undying_undying_decay_10" }
	local responses_big = { "undying_undying_big_decay_03", "undying_undying_big_decay_04", "undying_undying_big_decay_05", "undying_undying_big_decay_07", "undying_undying_big_decay_08", "undying_undying_big_decay_09", "undying_undying_big_decay_10" }
	local cast_sound = "Hero_Undying.Decay.Cast"
	local flesh_golem_modifier = "modifier_imba_undying_flesh_golem"

	-- Ability specials
	local radius = ability:GetSpecialValueFor("radius")

	-- Emit cast sound
	caster:EmitSound(cast_sound)

	if caster:GetName() == "npc_dota_hero_undying" and RollPercentage(50) then
		if caster:HasModifier(flesh_golem_modifier) then
			-- WHy isn't there a function that plays only on one unit but not on client? This function doesn't make the sound come out of the unit which is wrong, but no one else is supposed to hear these voicelines either. Ugh...
			EmitSoundOnClient(responses_big[RandomInt(1, #responses_big)], caster:GetPlayerOwner())
		else
			EmitSoundOnClient(responses[RandomInt(1, #responses)], caster:GetPlayerOwner())
		end
	end

	local decay_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(decay_particle, 0, target_point)
	ParticleManager:SetParticleControl(decay_particle, 1, Vector(radius, 0, 0))
	-- This isn't technically correct because the flies actually follow Undying all the way to the end but like...ugh
	ParticleManager:SetParticleControl(decay_particle, 2, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(decay_particle)

	local clone_owner_units = {}

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, enemy in pairs(enemies) do
		-- Clone handling: only one Meepo clone or Arc Warden will get its Strength stolen.
		if enemy:IsClone() or enemy:IsTempestDouble() or enemy:GetName() == "npc_dota_hero_meepo" or enemy:GetName() == "npc_dota_hero_arc_warden" then
			table.insert(clone_owner_units, enemy)
		else
			if enemy:IsHero() and not enemy:IsIllusion() then
				enemy:EmitSound("Hero_Undying.Decay.Target")
				caster:EmitSound("Hero_Undying.Decay.Transfer")

				local strength_transfer_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay_strength_xfer.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:SetParticleControlEnt(strength_transfer_particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(strength_transfer_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(strength_transfer_particle)

				-- "Steals strength before applying its damage."
				self:DecayDebuffEnemy(enemy)
				self:DecayBuffCaster()
			end

			self:DealDamageEnemy(enemy)
		end
	end

	local selected_unit = nil

	-- Separate handling for clones
	local repeat_needed = true

	if #clone_owner_units > 0 then
		while repeat_needed do
			local selected_unit = table.remove(clone_owner_units, RandomInt(1, #clone_owner_units))

			-- Apply buff/debuff
			self:DecayBuffCaster()
			self:DecayDebuffEnemy(selected_unit)

			-- Find all similar units of the same name in the table
			for i = 1, #clone_owner_units do
				if clone_owner_units[i] and selected_unit and clone_owner_units[i]:GetName() == selected_unit:GetName() then
					self:DealDamageEnemy(clone_owner_units[i])
					clone_owner_units[i] = nil
				end
			end

			-- If no more units are stored in the table, we don't need to repeat this anymore
			if #clone_owner_units == 0 then
				repeat_needed = false
			end
		end
	end
end

function imba_undying_decay:DecayBuffCaster()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_buff = "modifier_imba_undying_decay_buff"

	-- Ability specials
	local decay_duration = ability:GetSpecialValueFor("decay_duration") + caster:FindTalentValue("special_bonus_imba_undying_decay_duration")

	-- Add buff to Undying himself
	if not caster:HasModifier(modifier_buff) then
		caster:AddNewModifier(caster, self, modifier_buff, { duration = decay_duration })
	end

	-- Refresh and stack it up
	local buff_modifier_handle = caster:FindModifierByName(modifier_buff)
	if buff_modifier_handle then
		buff_modifier_handle:IncrementStackCount()
		buff_modifier_handle:ForceRefresh()
	end
end

function imba_undying_decay:DecayDebuffEnemy(enemy)
	if not enemy then return end
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_debuff = "modifier_imba_undying_decay_debuff"

	-- Ability specials
	local decay_duration = ability:GetSpecialValueFor("decay_duration") + caster:FindTalentValue("special_bonus_imba_undying_decay_duration")

	-- Add debuff to affected enemies
	if not enemy:HasModifier(modifier_debuff) then
		enemy:AddNewModifier(caster, ability, modifier_debuff, { duration = decay_duration * (1 - enemy:GetStatusResistance()) })
	end

	-- Refresh and stack it up
	local debuff_modifier_handle = enemy:FindModifierByName(modifier_debuff)
	if debuff_modifier_handle then
		debuff_modifier_handle:IncrementStackCount()
		debuff_modifier_handle:ForceRefresh()
	end
end

function imba_undying_decay:DealDamageEnemy(enemy)
	if not enemy then return end

	-- Ability properties
	local caster = self:GetCaster()
	local ability = self

	-- Ability specials
	local decay_damage = ability:GetSpecialValueFor("decay_damage")

	ApplyDamage({
		victim       = enemy,
		damage       = decay_damage,
		damage_type  = self:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		attacker     = caster,
		ability      = ability
	})
end

-------------------------
-- DECAY BUFF MODIFIER --
-------------------------

modifier_imba_undying_decay_buff = modifier_imba_undying_decay_buff or class({})

function modifier_imba_undying_decay_buff:IsHidden() return false end

function modifier_imba_undying_decay_buff:IsPurgable() return false end

function modifier_imba_undying_decay_buff:IsDebuff() return false end

function modifier_imba_undying_decay_buff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.str_steal = self.ability:GetSpecialValueFor("str_steal")
	self.str_steal_scepter = self.ability:GetSpecialValueFor("str_steal_scepter")
	self.decay_duration = self.ability:GetSpecialValueFor("decay_duration") + self.caster:FindTalentValue("special_bonus_imba_undying_decay_duration")

	-- Special variable for Undying's Decay
	self.hp_gain_per_str = 20

	-- Initialize stacks table
	self.stack_table = {}

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(1)
	end
end

function modifier_imba_undying_decay_buff:OnIntervalThink()
	local repeat_needed = true

	-- We''ll repeat the table removal check and remove as many expired items from it as needed.
	while repeat_needed do
		-- Check if the firstmost entry in the table has expired
		local item_time = self.stack_table[1]

		-- If the difference between times is longer, it's time to get rid of a stack
		if GameRules:GetGameTime() - item_time >= self.decay_duration then
			-- Check if there is only one stack, which would mean bye bye debuff
			if self:GetStackCount() == 1 then
				self:Destroy()
				break
			else
				-- Remove the entry from the table
				table.remove(self.stack_table, 1)

				-- Decrement a stack
				self:DecrementStackCount()

				-- Calculate hero status
				if self.parent.CalculateStatBonus then
					self.parent:CalculateStatBonus(true)
				end
			end
		else
			-- If no more items need to be removed, no need to repeat the table
			repeat_needed = false
		end
	end
end

function modifier_imba_undying_decay_buff:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end

	local stacks = self:GetStackCount()

	-- We only care about stack incrementals
	if stacks > prev_stacks then
		-- Insert the current game time of the stack that was just added to the stack table
		table.insert(self.stack_table, GameRules:GetGameTime())

		-- Determine which str_steal we're using right now dependong on if the caster has a scepter
		if self.caster:HasScepter() then
			self.strength_gain = self.str_steal_scepter
		else
			self.strength_gain = self.str_steal
		end

		-- "The strength gain on Undying does not keep the current health percentage either, and instead adds 20 health per strength to the current health pool."
		self:GetCaster():Heal(self.strength_gain * self.hp_gain_per_str, self:GetCaster())

		-- Refresh timer
		self:ForceRefresh()

		self:GetParent():CalculateStatBonus(true)
	end
end

function modifier_imba_undying_decay_buff:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MODEL_SCALE }

	return decFuncs
end

function modifier_imba_undying_decay_buff:GetModifierBonusStats_Strength()
	if self.caster:HasScepter() then
		return self.str_steal_scepter * self:GetStackCount()
	end

	return self.str_steal * self:GetStackCount()
end

function modifier_imba_undying_decay_buff:GetModifierModelScale()
	return 2 * self:GetStackCount()
end

---------------------------
-- DECAY DEBUFF MODIFIER --
---------------------------

modifier_imba_undying_decay_debuff = modifier_imba_undying_decay_debuff or class({})

function modifier_imba_undying_decay_debuff:IsHidden() return false end

function modifier_imba_undying_decay_debuff:IsPurgable() return false end

function modifier_imba_undying_decay_debuff:IsDebuff() return true end

function modifier_imba_undying_decay_debuff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.str_steal = self.ability:GetSpecialValueFor("str_steal")
	self.str_steal_scepter = self.ability:GetSpecialValueFor("str_steal_scepter")
	self.brains_int_pct = self.ability:GetSpecialValueFor("brains_int_pct")
	self.decay_duration = self.ability:GetSpecialValueFor("decay_duration") + self.caster:FindTalentValue("special_bonus_imba_undying_decay_duration")

	-- Special variable for Undying's Decay
	self.hp_removal_per_str = 20

	-- Initialize stacks table
	self.stack_table = {}

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(1)
	end
end

function modifier_imba_undying_decay_debuff:OnIntervalThink()
	local repeat_needed = true

	-- We''ll repeat the table removal check and remove as many expired items from it as needed.
	while repeat_needed do
		-- Check if the firstmost entry in the table has expired
		local item_time = self.stack_table[1]

		-- If the difference between times is longer, it's time to get rid of a stack
		if GameRules:GetGameTime() - item_time >= self.decay_duration then
			-- Check if there is only one stack, which would mean bye bye debuff
			if self:GetStackCount() == 1 then
				self:Destroy()
				break
			else
				-- Remove the entry from the table
				table.remove(self.stack_table, 1)

				-- Decrement a stack
				self:DecrementStackCount()

				-- Calculate hero status
				if self.parent.CalculateStatBonus then
					self.parent:CalculateStatBonus(true)
				end
			end
		else
			-- If no more items need to be removed, no need to repeat the table
			repeat_needed = false
		end
	end
end

function modifier_imba_undying_decay_debuff:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end

	local stacks = self:GetStackCount()

	-- We only care about stack incrementals
	if stacks > prev_stacks then
		-- Insert the current game time of the stack that was just added to the stack table
		table.insert(self.stack_table, GameRules:GetGameTime())

		-- Determine which str_steal we're using right now dependong on if the caster has a scepter
		if self.caster:HasScepter() then
			self.strength_reduction = self.str_steal_scepter
		else
			self.strength_reduction = self.str_steal
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

		-- Refresh timer
		self:ForceRefresh()

		self:GetParent():CalculateStatBonus(true)
	end
end

function modifier_imba_undying_decay_debuff:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		-- IMBAfication: Braiiiinssss...
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS }

	return decFuncs
end

function modifier_imba_undying_decay_debuff:GetModifierBonusStats_Strength()
	if self.caster:HasScepter() then
		return self.str_steal_scepter * self:GetStackCount() * (-1)
	end

	return self.str_steal * self:GetStackCount() * (-1)
end

function modifier_imba_undying_decay_debuff:GetModifierBonusStats_Intellect()
	if self.caster:HasScepter() then
		return math.ceil(self.str_steal_scepter * self:GetStackCount() * self.brains_int_pct / 100) * (-1)
	end

	return math.ceil(self.str_steal * self:GetStackCount() * self.brains_int_pct / 100) * (-1)
end

--------------
-- SOUL RIP --
--------------

LinkLuaModifier("modifier_imba_undying_soul_rip_soul_injection_buff", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_soul_rip_soul_injection_debuff", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)

imba_undying_soul_rip = imba_undying_soul_rip or class({})

function imba_undying_soul_rip:CastFilterResultTarget(target)
	-- Can target tombstone
	if IsUndyingTombstone(target) and target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return UF_SUCCESS
	elseif IsUndyingZombie(target) then
		return UF_FAIL_CUSTOM
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	end
end

function imba_undying_soul_rip:GetCustomCastErrorTarget(target)
	if IsUndyingZombie(target) then
		return "#undying_soul_rip_cannot_be_cast_on_zombies"
	end
end

function imba_undying_soul_rip:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local responses = { "undying_undying_soulrip_02", "undying_undying_soulrip_03", "undying_undying_soulrip_04", "undying_undying_soulrip_07" }
	local responses_big = { "undying_undying_big_soulrip_02", "undying_undying_big_soulrip_03", "undying_undying_big_soulrip_04", "undying_undying_big_soulrip_07" }
	local cast_sound = "Hero_Undying.SoulRip.Cast"
	local flesh_golem_modifier = "modifier_imba_undying_flesh_golem"
	local modifier_injection_debuff = "modifier_imba_undying_soul_rip_soul_injection_debuff"
	local modifier_injection_buff = "modifier_imba_undying_soul_rip_soul_injection_buff"

	-- Ability specials
	local radius = ability:GetSpecialValueFor("radius")
	local damage_per_unit = ability:GetSpecialValueFor("damage_per_unit")
	local max_units = ability:GetSpecialValueFor("max_units")
	local soul_injection_duration = ability:GetSpecialValueFor("soul_injection_duration")
	local tombstone_heal = ability:GetSpecialValueFor("tombstone_heal")

	caster:EmitSound(cast_sound)

	if caster:GetName() == "npc_dota_hero_undying" and RollPercentage(50) then
		if self:GetCaster():HasModifier(flesh_golem_modifier) then
			-- WHy isn't there a function that plays only on one unit but not on client? This function doesn't make the sound come out of the unit which is wrong, but no one else is supposed to hear these voicelines either. Ugh...
			EmitSoundOnClient(responses_big[RandomInt(1, #responses_big)], caster:GetPlayerOwner())
		else
			EmitSoundOnClient(responses[RandomInt(1, #responses)], caster:GetPlayerOwner())
		end
	end

	local units_ripped    = 0
	local damage_particle = nil

	-- "Does not count Undying, the target, wards, buildings, invisible enemies and units in the Fog of War."
	-- "Spell immune allies are counted, including the zombies from Tombstone."
	local units           = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
		FIND_ANY_ORDER,
		false)
	for _, unit in pairs(units) do
		if unit ~= caster and unit ~= target then
			if target:GetTeamNumber() ~= caster:GetTeamNumber() then
				damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_soul_rip_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			else
				damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_soul_rip_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			end

			ParticleManager:SetParticleControlEnt(damage_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(damage_particle)

			-- "Units which require a certain amount of attacks to be killed do not lose health when counted in by Soul Rip."
			if not IsUndyingZombie(unit) then
				ApplyDamage({
					victim       = unit,
					damage       = damage_per_unit,
					damage_type  = DAMAGE_TYPE_PURE,
					damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, -- Putting reflection flag here in case of unwanted interactions
					attacker     = caster,
					ability      = ability
				})

				-- IMBAfication: Do Zombies Have Souls?
				-- Zombies instantly attack the target if it an enemy
			elseif unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() and unit:GetTeamNumber() ~= target:GetTeamNumber() then
				unit:PerformAttack(target, true, true, true, true, false, false, true)
			end

			units_ripped = units_ripped + 1

			if units_ripped >= max_units then
				break
			end
		end
	end

	if units_ripped >= 1 then
		if target:GetTeamNumber() ~= caster:GetTeamNumber() and not target:TriggerSpellAbsorb(self) then
			target:EmitSound("Hero_Undying.SoulRip.Enemy")

			ApplyDamage({
				victim       = target,
				damage       = damage_per_unit * units_ripped,
				damage_type  = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = caster,
				ability      = ability
			})

			-- IMBAfication: Soul Injection
			if not target:HasModifier(modifier_injection_debuff) then
				target:AddNewModifier(caster, ability, modifier_injection_debuff, { duration = soul_injection_duration * (1 - target:GetStatusResistance()) })
			end

			-- Find the Soul Injection and give it stacks
			local injection_modifier = target:FindModifierByName(modifier_injection_debuff)
			if injection_modifier then
				for i = 1, units_ripped do
					injection_modifier:IncrementStackCount()
				end
			end

			-- Cause target to recalculate its stats
			if target.CalculateStatBonus then
				target:CalculateStatBonus(true)
			end
		elseif target:GetTeamNumber() == caster:GetTeamNumber() and not IsUndyingTombstone(target) then
			target:EmitSound("Hero_Undying.SoulRip.Ally")

			target:Heal(damage_per_unit * units_ripped, caster)

			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, damage_per_unit * units_ripped, nil)

			-- IMBAfication: Soul Injection
			if not target:HasModifier(modifier_injection_buff) then
				local injection_modifier = target:AddNewModifier(caster, ability, modifier_injection_buff, { duration = soul_injection_duration })
			end

			-- Find the Soul Injection and give it stacks
			local injection_modifier = target:FindModifierByName(modifier_injection_buff)
			if injection_modifier then
				for i = 1, units_ripped do
					injection_modifier:IncrementStackCount()
				end
			end

			-- Cause target to recalculate its stats, if possible
			if target.CalculateStatBonus then
				target:CalculateStatBonus(true)
			end
		elseif target:GetTeamNumber() == caster:GetTeamNumber() and IsUndyingTombstone(target) then
			target:EmitSound("Hero_Undying.SoulRip.Ally")

			target:Heal(tombstone_heal, caster)

			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, tombstone_heal, nil)
		end
	end
end

----------------------------------
-- SOUL INJECTION BUFF MODIFIER --
----------------------------------

modifier_imba_undying_soul_rip_soul_injection_buff = modifier_imba_undying_soul_rip_soul_injection_buff or class({})

function modifier_imba_undying_soul_rip_soul_injection_buff:IsHidden() return false end

function modifier_imba_undying_soul_rip_soul_injection_buff:IsPurgable() return true end

function modifier_imba_undying_soul_rip_soul_injection_buff:IsDebuff() return false end

function modifier_imba_undying_soul_rip_soul_injection_buff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.soul_injection_stats_per_unit = self.ability:GetSpecialValueFor("soul_injection_stats_per_unit")
	self.soul_injection_duration = self.ability:GetSpecialValueFor("soul_injection_duration")

	-- Initialize stacks table
	self.stack_table = {}

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(1)
	end
end

function modifier_imba_undying_soul_rip_soul_injection_buff:OnIntervalThink()
	local repeat_needed = true

	-- We''ll repeat the table removal check and remove as many expired items from it as needed.
	while repeat_needed do
		-- Check if the firstmost entry in the table has expired
		local item_time = self.stack_table[1]

		-- If the difference between times is longer, it's time to get rid of a stack
		if GameRules:GetGameTime() - item_time >= self.soul_injection_duration then
			-- Check if there is only one stack, which would mean bye bye debuff
			if self:GetStackCount() == 1 then
				self:Destroy()
				break
			else
				-- Remove the entry from the table
				table.remove(self.stack_table, 1)

				-- Decrement a stack
				self:DecrementStackCount()

				-- Calculate hero status
				if self.parent.CalculateStatBonus then
					self.parent:CalculateStatBonus(true)
				end
			end
		else
			-- If no more items need to be removed, no need to repeat the table
			repeat_needed = false
		end
	end
end

function modifier_imba_undying_soul_rip_soul_injection_buff:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end

	local stacks = self:GetStackCount()

	-- We only care about stack incrementals
	if stacks > prev_stacks then
		-- Insert the current game time of the stack that was just added to the stack table
		table.insert(self.stack_table, GameRules:GetGameTime())

		-- Refresh timer
		self:ForceRefresh()
	end
end

function modifier_imba_undying_soul_rip_soul_injection_buff:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS }

	return decFuncs
end

function modifier_imba_undying_soul_rip_soul_injection_buff:GetModifierBonusStats_Strength()
	return self.soul_injection_stats_per_unit * self:GetStackCount()
end

function modifier_imba_undying_soul_rip_soul_injection_buff:GetModifierBonusStats_Agility()
	return self.soul_injection_stats_per_unit * self:GetStackCount()
end

function modifier_imba_undying_soul_rip_soul_injection_buff:GetModifierBonusStats_Intellect()
	return self.soul_injection_stats_per_unit * self:GetStackCount()
end

------------------------------------
-- SOUL INJECTION DEBUFF MODIFIER --
------------------------------------

modifier_imba_undying_soul_rip_soul_injection_debuff = modifier_imba_undying_soul_rip_soul_injection_debuff or class({})

function modifier_imba_undying_soul_rip_soul_injection_debuff:IsHidden() return false end

function modifier_imba_undying_soul_rip_soul_injection_debuff:IsPurgable() return true end

function modifier_imba_undying_soul_rip_soul_injection_debuff:IsDebuff() return true end

function modifier_imba_undying_soul_rip_soul_injection_debuff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.soul_injection_stats_per_unit = self.ability:GetSpecialValueFor("soul_injection_stats_per_unit")
	self.soul_injection_duration = self.ability:GetSpecialValueFor("soul_injection_duration")

	-- Initialize stacks table
	self.stack_table = {}

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(1)
	end
end

function modifier_imba_undying_soul_rip_soul_injection_debuff:OnIntervalThink()
	local repeat_needed = true

	-- We''ll repeat the table removal check and remove as many expired items from it as needed.
	while repeat_needed do
		-- Check if the firstmost entry in the table has expired
		local item_time = self.stack_table[1]

		-- If the difference between times is longer, it's time to get rid of a stack
		if GameRules:GetGameTime() - item_time >= self.soul_injection_duration then
			-- Check if there is only one stack, which would mean bye bye debuff
			if self:GetStackCount() == 1 then
				self:Destroy()
				break
			else
				-- Remove the entry from the table
				table.remove(self.stack_table, 1)

				-- Decrement a stack
				self:DecrementStackCount()

				-- Calculate hero status
				if self.parent.CalculateStatBonus then
					self.parent:CalculateStatBonus(true)
				end
			end
		else
			-- If no more items need to be removed, no need to repeat the table
			repeat_needed = false
		end
	end
end

function modifier_imba_undying_soul_rip_soul_injection_debuff:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end

	local stacks = self:GetStackCount()

	-- We only care about stack incrementals
	if stacks > prev_stacks then
		-- Insert the current game time of the stack that was just added to the stack table
		table.insert(self.stack_table, GameRules:GetGameTime())

		-- Refresh timer
		self:ForceRefresh()
	end
end

function modifier_imba_undying_soul_rip_soul_injection_debuff:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS }

	return decFuncs
end

function modifier_imba_undying_soul_rip_soul_injection_debuff:GetModifierBonusStats_Strength()
	return self.soul_injection_stats_per_unit * self:GetStackCount() * (-1)
end

function modifier_imba_undying_soul_rip_soul_injection_debuff:GetModifierBonusStats_Agility()
	return self.soul_injection_stats_per_unit * self:GetStackCount() * (-1)
end

function modifier_imba_undying_soul_rip_soul_injection_debuff:GetModifierBonusStats_Intellect()
	return self.soul_injection_stats_per_unit * self:GetStackCount() * (-1)
end

---------------
-- TOMBSTONE --
---------------


imba_undying_tombstone = imba_undying_tombstone or class({})

function imba_undying_tombstone:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = ability:GetCursorPosition()
	local responses = { "undying_undying_tombstone_01", "undying_undying_tombstone_02", "undying_undying_tombstone_03", "undying_undying_tombstone_04", "undying_undying_tombstone_05", "undying_undying_tombstone_06", "undying_undying_tombstone_07", "undying_undying_tombstone_08", "undying_undying_tombstone_09", "undying_undying_tombstone_10", "undying_undying_tombstone_11", "undying_undying_tombstone_12", "undying_undying_tombstone_13" }
	local responses_big = { "undying_undying_big_tombstone_01", "undying_undying_big_tombstone_02", "undying_undying_big_tombstone_03", "undying_undying_big_tombstone_04", "undying_undying_big_tombstone_05", "undying_undying_big_tombstone_06", "undying_undying_big_tombstone_07", "undying_undying_big_tombstone_08", "undying_undying_big_tombstone_09", "undying_undying_big_tombstone_10", "undying_undying_big_tombstone_11", "undying_undying_big_tombstone_12", "undying_undying_big_tombstone_13" }
	local flesh_golem_modifier = "modifier_imba_undying_flesh_golem"

	-- Play cast response sound
	if caster:HasModifier(flesh_golem_modifier) then
		-- WHy isn't there a function that plays only on one unit but not on client? This function doesn't make the sound come out of the unit which is wrong, but no one else is supposed to hear these voicelines either. Ugh...
		EmitSoundOnClient(responses_big[RandomInt(1, #responses_big)], caster:GetPlayerOwner())
	else
		EmitSoundOnClient(responses[RandomInt(1, #responses)], caster:GetPlayerOwner())
	end

	-- Spawn a tombstone!
	self:SpawnTombstone(target_point)
end

function imba_undying_tombstone:SpawnTombstone(target_point)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_sound = "Hero_Undying.Tombstone"
	local tombstone_aura_ability = "imba_undying_tombstone_aura"
	local tombstone_spell_immunity_ability = "neutral_spell_immunity"

	-- Ability specials
	local tombstone_health = ability:GetSpecialValueFor("tombstone_health")
	local duration = ability:GetSpecialValueFor("duration")
	local trees_destroy_radius = ability:GetSpecialValueFor("trees_destroy_radius")

	-- Play cast sound
	EmitSoundOnLocationWithCaster(target_point, cast_sound, caster)

	local tombstone = CreateUnitByName("npc_dota_undying_imba_tombstone", target_point, true, caster, caster, caster:GetTeamNumber())

	tombstone:SetOwner(caster)

	-- Just gonna spam all the health functions to see what sticks cause this is super inconsistent
	tombstone:SetBaseMaxHealth(tombstone_health)
	tombstone:SetMaxHealth(tombstone_health)
	tombstone:SetHealth(tombstone_health)

	-- Add the kill timer to the Tombstone
	tombstone:AddNewModifier(self:GetCaster(), self, "modifier_kill", { duration = duration })

	-- Set the level of the Tombstone Aura skill of the Tombstone to Undying's Tombstone level, and learn the Spell Immunity ability
	local tombstone_aura_ability_handle = tombstone:FindAbilityByName(tombstone_aura_ability)
	local tombstone_spell_immunity_ability_handle = tombstone:FindAbilityByName(tombstone_spell_immunity_ability)
	if tombstone_aura_ability_handle and tombstone_spell_immunity_ability_handle then
		tombstone_aura_ability_handle:SetLevel(ability:GetLevel())
		tombstone_spell_immunity_ability_handle:SetLevel(1)
	end

	-- "Destroys trees within 300 radius around the Tombstone upon cast."
	GridNav:DestroyTreesAroundPoint(target_point, trees_destroy_radius, true)
end

---------------------------------------
-- TOMBSTONE ABILITY: TOMBSTONE AURA --
---------------------------------------
LinkLuaModifier("modifier_imba_undying_tombstone_aura", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)

imba_undying_tombstone_aura = imba_undying_tombstone_aura or class({})

function imba_undying_tombstone_aura:GetIntrinsicModifierName()
	return "modifier_imba_undying_tombstone_aura"
end

--------------------
-- TOMBSTONE AURA --
--------------------

modifier_imba_undying_tombstone_aura = modifier_imba_undying_tombstone_aura or class({})

function modifier_imba_undying_tombstone_aura:IsHidden() return true end

function modifier_imba_undying_tombstone_aura:IsPurgable() return false end

function modifier_imba_undying_tombstone_aura:IsDebuff() return false end

function modifier_imba_undying_tombstone_aura:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster() -- Note that the tombstone is the caster!
	self.ability = self:GetAbility()
	self.deathlust_ability = "imba_undying_tombstone_zombie_deathlust"
	self.zombie_neutral_spell_immunity_ability = "neutral_spell_immunity"
	self.modifier_no_home = "modifier_imba_undying_tombstone_zombie_modifier_no_home"

	-- Ability specials
	self.no_home_duration = self.ability:GetSpecialValueFor("no_home_duration")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.zombie_interval = self.ability:GetSpecialValueFor("zombie_interval")
	self.tombstone_damage_hero = self.ability:GetSpecialValueFor("tombstone_damage_hero")
	self.tombstone_damage_creep = self.ability:GetSpecialValueFor("tombstone_damage_creep")

	if IsServer() then
		-- Why can't they just let us know who the owner is clientside.. meh!
		self.owner = self.caster:GetOwner()

		-- Immediately spawn zombies, then start thinking
		self:OnIntervalThink()
		self:StartIntervalThink(self.zombie_interval)
	end
end

function modifier_imba_undying_tombstone_aura:OnIntervalThink()
	-- Stop thinking if the tombstone died
	if not self.caster:IsAlive() then
		self:StartIntervalThink(-1)
		return
	end

	-- "Zombies do not spawn for invisible units or units in the Fog of War."
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
		self.caster:GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
		FIND_ANY_ORDER,
		false)

	for _, enemy in pairs(enemies) do
		-- "Zombies do not spawn for wards, buildings, couriers, hidden units and zombies from an enemy Tombstone."
		if not enemy:IsCourier() and not IsUndyingZombie(enemy) then
			local zombie = CreateUnitByName(GenerateZombieType(), enemy:GetAbsOrigin(), true, self.owner, self.owner, self.caster:GetTeamNumber())

			zombie:EmitSound("Undying_Zombie.Spawn")

			zombie:SetBaseDamageMin(zombie:GetBaseDamageMin() + self.owner:FindTalentValue("special_bonus_imba_undying_tombstone_zombie_damage"))
			zombie:SetBaseDamageMax(zombie:GetBaseDamageMax() + self.owner:FindTalentValue("special_bonus_imba_undying_tombstone_zombie_damage"))

			-- Seems like these things are STILL getting stuck on units so put a bit of an offest
			FindClearSpaceForUnit(zombie, enemy:GetAbsOrigin() + RandomVector(enemy:GetHullRadius() + zombie:GetHullRadius()), true)
			ResolveNPCPositions(zombie:GetAbsOrigin(), enemy:GetHullRadius())

			-- Force the zombie to attack the enemy
			zombie:SetAggroTarget(enemy)

			local deathlust_ability = zombie:FindAbilityByName(self.deathlust_ability)
			local immunity_ability = zombie:FindAbilityByName(self.zombie_neutral_spell_immunity_ability)

			if deathlust_ability and immunity_ability then
				deathlust_ability:SetLevel(self.ability:GetLevel())
				deathlust_ability.tombstone_aggro_target = enemy
				immunity_ability:SetLevel(1)
			end
		end
	end
end

function modifier_imba_undying_tombstone_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_imba_undying_tombstone_aura:OnDeath(keys)
	if not IsServer() then return end

	local unit = keys.unit
	local attacker = keys.attacker

	-- Only apply if the Tombstone was the unit that died
	if IsUndyingTombstone(unit) then
		-- Assume the unit was killed unless otherwise stated
		local expired = false

		-- Tombstone expired naturally (and killed itself with modifier_kill)
		if unit == attacker then
			expired = true
		end

		-- Find all zombies
		local zombies = Entities:FindAllByClassname("npc_dota_unit_undying_zombie")

		for _, zombie in pairs(zombies) do
			-- Only apply on zombies under Undying's control
			if zombie:GetOwner() == self.owner then
				-- If the Tombstone naturally expired, release them from their control
				if expired then
					zombie:SetControllableByPlayer(self.owner:GetPlayerID(), true)
					zombie:AddNewModifier(self.owner, self:GetAbility(), self.modifier_no_home, { duration = self.no_home_duration })
					zombie:AddNewModifier(self.owner, self:GetAbility(), "modifier_kill", { duration = self.no_home_duration })
				else
					-- Otherwise, kill the zombies!
					zombie:ForceKill(false)
				end
			end
		end
	end
end

function modifier_imba_undying_tombstone_aura:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_imba_undying_tombstone_aura:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_imba_undying_tombstone_aura:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_imba_undying_tombstone_aura:OnAttackLanded(keys)
	-- Only apply when the Tombstone gets attacked
	if keys.target == self.caster then
		local damage_to_tombstone

		-- Set the expected damage
		if keys.attacker:IsRealHero() or keys.attacker:IsClone() or keys.attacker:IsTempestDouble() then
			damage_to_tombstone = self.tombstone_damage_hero
		else
			damage_to_tombstone = self.tombstone_damage_creep
		end

		-- Check if the Tombstone will be destroyed as a result of this attack
		if (self.caster:GetHealth() - damage_to_tombstone) <= 0 then
			self.caster:Kill(nil, keys.attacker)
			self:Destroy()
		else
			-- If the damage would not kill it, then simply reduce the Tombstone's health.
			self.caster:SetHealth(self.caster:GetHealth() - damage_to_tombstone)
		end
	end
end

---------------------------------------
-- UNDYING ZOMBIE'S NO HOME MODIFIER --
---------------------------------------
LinkLuaModifier("modifier_imba_undying_tombstone_zombie_modifier_no_home", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
modifier_imba_undying_tombstone_zombie_modifier_no_home = modifier_imba_undying_tombstone_zombie_modifier_no_home or class({})

function modifier_imba_undying_tombstone_zombie_modifier_no_home:IsPurgable() return false end

function modifier_imba_undying_tombstone_zombie_modifier_no_home:IsDebuff() return false end

function modifier_imba_undying_tombstone_zombie_modifier_no_home:IsHidden() return false end

function modifier_imba_undying_tombstone_zombie_modifier_no_home:GetTexture()
	return "undying_tombstone"
end

function modifier_imba_undying_tombstone_zombie_modifier_no_home:GetStatusEffectName()
	return "particles/econ/items/spirit_breaker/spirit_breaker_iron_surge/status_effect_iron_surge.vpcf"
end

--------------------------------
-- UNDYING ZOMBIE'S DEATHLUST --
--------------------------------
LinkLuaModifier("modifier_imba_undying_zombie_deathlust", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_zombie_deathlust_buff", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_zombie_deathlust_debuff", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)

imba_undying_tombstone_zombie_deathlust = imba_undying_tombstone_zombie_deathlust or class({})

function imba_undying_tombstone_zombie_deathlust:GetIntrinsicModifierName()
	return "modifier_imba_undying_zombie_deathlust"
end

-----------------------------------------
-- UNDYING ZOMBIE'S DEATHLUST MODIFIER --
-----------------------------------------

modifier_imba_undying_zombie_deathlust = modifier_imba_undying_zombie_deathlust or class({})

function modifier_imba_undying_zombie_deathlust:IsHidden() return true end

function modifier_imba_undying_zombie_deathlust:IsPurgable() return false end

function modifier_imba_undying_zombie_deathlust:IsDebuff() return false end

function modifier_imba_undying_zombie_deathlust:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster() -- The zombie!
	self.ability = self:GetAbility()
	self.modifier_deathlust_buff = "modifier_imba_undying_zombie_deathlust_buff"
	self.modifier_deathlust_debuff = "modifier_imba_undying_zombie_deathlust_debuff"
	self.modifier_no_home = "modifier_imba_undying_tombstone_zombie_modifier_no_home"

	-- Ability specials
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.health_threshold_pct = self.ability:GetSpecialValueFor("health_threshold_pct")
	self.hero_tower_damage = self.ability:GetSpecialValueFor("hero_tower_damage")
	self.other_damage = self.ability:GetSpecialValueFor("other_damage")

	if IsServer() then
		-- Get the aggro target from the ability (set by the tombstone)
		self.tombstone_aggro_target = self.ability.tombstone_aggro_target

		-- If for some reason there is no target, then get the target manually
		if not self.tombstone_aggro_target then
			local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
				self.caster:GetAbsOrigin(),
				nil,
				256,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
				FIND_CLOSEST,
				false)
			for _, enemy in pairs(enemies) do
				if not enemy:IsCourier() and not IsUndyingZombie(enemy) then
					self.tombstone_aggro_target = enemy
					break
				end
			end
		end

		-- If even after all this we still don't have an aggro target, then fuck it, the zombie should probably just die
		if not self.tombstone_aggro_target then
			self.caster:ForceKill(false)
		end

		self:StartIntervalThink(0.5)
	end
end

function modifier_imba_undying_zombie_deathlust:OnIntervalThink()
	-- If the zombie is dead and we're still ticking, just stop
	if not self.caster:IsAlive() then
		self:Destroy()
		return
	end

	-- If the zombie is a free zombie (no home), then stop ticking this
	if self.caster:HasModifier(self.modifier_no_home) then
		self:StartIntervalThink(-1)
		return
	end

	-- If we're here and we don't even have an aggro target, then the zombie should die
	if not self.tombstone_aggro_target then
		self.caster:ForceKill(false)
		return
	end

	-- If the aggro target is dead, kill the zombie
	if not self.tombstone_aggro_target:IsAlive() then
		self.caster:ForceKill(false)
		return
	end

	-- If the aggro target went invis and cannot be seen anymore, kill the zombie
	if self.tombstone_aggro_target:IsInvisible() and not self.caster:CanEntityBeSeenByMyTeam(self.tombstone_aggro_target) then
		self.caster:ForceKill(false)
		return
	end

	-- Remind the zombie to attack the target if it's not attacking it (he shouldn't ever stop, but you know, he might be taunted or something)
	if not self.caster:GetAggroTarget() or self.caster:GetAggroTarget() ~= self.tombstone_aggro_target then
		-- If the zombie can see the target, attack it
		if self.caster:CanEntityBeSeenByMyTeam(self.tombstone_aggro_target) then
			ExecuteOrderFromTable({
				UnitIndex   = self.caster:entindex(),
				OrderType   = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = self.tombstone_aggro_target:entindex()
			})
		else
			-- Otherwise, it should follow to its location
			ExecuteOrderFromTable({
				UnitIndex = self.caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = self.tombstone_aggro_target:GetAbsOrigin()
			})
		end
	end
end

function modifier_imba_undying_zombie_deathlust:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH }

	return decFuncs
end

function modifier_imba_undying_zombie_deathlust:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_imba_undying_zombie_deathlust:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_imba_undying_zombie_deathlust:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_imba_undying_zombie_deathlust:OnAttackLanded(keys)
	if not IsServer() then return end

	local target = keys.target
	local attacker = keys.attacker

	-- If the zombie is the one being attacked, handle zombie damage
	if target == self.caster then
		local damage_to_zombie

		-- Set the expected damage
		if attacker:IsRealHero() or attacker:IsClone() or attacker:IsTempestDouble() or attacker:IsTower() then
			damage_to_zombie = self.hero_tower_damage
		else
			damage_to_zombie = self.other_damage
		end

		-- Check if the zombie will die as a result of this attack
		if self.caster:GetHealth() - damage_to_zombie <= 0 then
			self.caster:Kill(nil, keys.attacker)
			self:Destroy()
		else
			-- If the damage would not kill it, then simply reduce its health.
			self.caster:SetHealth(self.caster:GetHealth() - damage_to_zombie)
		end
	end

	-- If the zombie is the one attacking his aggro target, handle Deathlust
	if attacker == self.caster and target == self.tombstone_aggro_target then
		-- Check if the zombie should get Deathlust buff
		if target:GetHealthPercent() <= self.health_threshold_pct then
			if not self.caster:HasModifier(self.modifier_deathlust_buff) then
				self.caster:AddNewModifier(self.caster, self.ability, self.modifier_deathlust_buff, { duration = self.duration })
			else
				local modifier_deathlust_buff_handle = self.caster:FindModifierByName(self.modifier_deathlust_buff)
				if modifier_deathlust_buff_handle then
					modifier_deathlust_buff_handle:ForceRefresh()
				end
			end
		end

		-- Give the target the deathlust debuff and/or a stack
		if not target:HasModifier(self.modifier_deathlust_debuff) then
			target:AddNewModifier(self.caster, self.ability, self.modifier_deathlust_debuff, { duration = self.duration * (1 - attacker:GetStatusResistance()) })
		end

		-- Give independent stack
		local modifier_deathlust_debuff_handle = target:FindModifierByName(self.modifier_deathlust_debuff)
		if modifier_deathlust_debuff_handle then
			modifier_deathlust_debuff_handle:IncrementStackCount()
		end
	end
end

----------------------------------------------
-- UNDYING ZOMBIE'S DEATHLUST BUFF MODIFIER --
----------------------------------------------

modifier_imba_undying_zombie_deathlust_buff = modifier_imba_undying_zombie_deathlust_buff or class({})

function modifier_imba_undying_zombie_deathlust_buff:IsHidden() return false end

function modifier_imba_undying_zombie_deathlust_buff:IsPurgable() return false end

function modifier_imba_undying_zombie_deathlust_buff:IsDebuff() return false end

function modifier_imba_undying_zombie_deathlust_buff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.bonus_move_speed_pct = self.ability:GetSpecialValueFor("bonus_move_speed_pct")
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
end

function modifier_imba_undying_zombie_deathlust_buff:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT }

	return decFuncs
end

function modifier_imba_undying_zombie_deathlust_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_move_speed_pct
end

function modifier_imba_undying_zombie_deathlust_buff:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

------------------------------------------------
-- UNDYING ZOMBIE'S DEATHLUST DEBUFF MODIFIER --
------------------------------------------------

modifier_imba_undying_zombie_deathlust_debuff = modifier_imba_undying_zombie_deathlust_debuff or class({})

function modifier_imba_undying_zombie_deathlust_debuff:IsHidden() return false end

function modifier_imba_undying_zombie_deathlust_debuff:IsPurgable() return true end

function modifier_imba_undying_zombie_deathlust_debuff:IsDebuff() return false end

function modifier_imba_undying_zombie_deathlust_debuff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.slow = self.ability:GetSpecialValueFor("slow")
	self.duration = self.ability:GetSpecialValueFor("duration")

	-- Initialize stacks table
	self.stack_table = {}

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(1)
	end
end

function modifier_imba_undying_zombie_deathlust_debuff:OnIntervalThink()
	local repeat_needed = true

	-- We''ll repeat the table removal check and remove as many expired items from it as needed.
	while repeat_needed do
		-- Check if the firstmost entry in the table has expired
		local item_time = self.stack_table[1]

		-- If the difference between times is longer, it's time to get rid of a stack
		if GameRules:GetGameTime() - item_time >= self.duration then
			-- Check if there is only one stack, which would mean bye bye debuff
			if self:GetStackCount() == 1 then
				self:Destroy()
				break
			else
				-- Remove the entry from the table
				table.remove(self.stack_table, 1)

				-- Decrement a stack
				self:DecrementStackCount()

				-- Calculate hero status
				if self.parent.CalculateStatBonus then
					self.parent:CalculateStatBonus(true)
				end
			end
		else
			-- If no more items need to be removed, no need to repeat the table
			repeat_needed = false
		end
	end
end

function modifier_imba_undying_zombie_deathlust_debuff:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end

	local stacks = self:GetStackCount()

	-- We only care about stack incrementals
	if stacks > prev_stacks then
		-- Insert the current game time of the stack that was just added to the stack table
		table.insert(self.stack_table, GameRules:GetGameTime())

		-- Refresh timer
		self:ForceRefresh()
	end
end

function modifier_imba_undying_zombie_deathlust_debuff:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }

	return decFuncs
end

function modifier_imba_undying_zombie_deathlust_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow * self:GetStackCount() * (-1)
end

------------------------------
-- UNDYING FLESH GOLEM GRAB --
------------------------------
LinkLuaModifier("modifier_imba_undying_flesh_golem_grab", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_flesh_golem_grab_debuff", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)

imba_undying_flesh_golem_grab = imba_undying_flesh_golem_grab or class({})

function imba_undying_flesh_golem_grab:IsStealable() return false end

function imba_undying_flesh_golem_grab:IsNetherWardStealable() return false end

function imba_undying_flesh_golem_grab:GetAssociatedSecondaryAbilities()
	return "imba_undying_flesh_golem_throw"
end

function imba_undying_flesh_golem_grab:CastFilterResultTarget(target)
	if self:GetCaster():HasTalent("special_bonus_imba_undying_flesh_golem_grab_allies") then
		if IsUndyingTombstone(target) then
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

---------------------------------------
-- UNDYING FLESH GOLEM GRAB MODIFIER --
---------------------------------------

modifier_imba_undying_flesh_golem_grab = modifier_imba_undying_flesh_golem_grab or class({})

function modifier_imba_undying_flesh_golem_grab:IsHidden() return true end

function modifier_imba_undying_flesh_golem_grab:IsPurgable() return false end

-- Undying should NEVER be able to grab more than one unit at a time, but this is just in case something breaks...and hopefully makes it not as broken
function modifier_imba_undying_flesh_golem_grab:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_undying_flesh_golem_grab:OnCreated(keys)
	if not IsServer() then return end

	self.target = EntIndexToHScript(keys.target_entindex)
end

----------------------------------------------
-- UNDYING FLESH GOLEM GRAB DEBUFF MODIFIER --
----------------------------------------------

modifier_imba_undying_flesh_golem_grab_debuff = modifier_imba_undying_flesh_golem_grab_debuff or class({})

function modifier_imba_undying_flesh_golem_grab_debuff:IsPurgable() return false end

function modifier_imba_undying_flesh_golem_grab_debuff:IsHidden() return false end

function modifier_imba_undying_flesh_golem_grab_debuff:IsDebuff() return true end

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

	FindClearSpaceForUnit(self:GetCaster(), self:GetCaster():GetAbsOrigin(), true)
	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	ResolveNPCPositions(self:GetCaster():GetAbsOrigin(), self:GetCaster():GetHullRadius() * 2)

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

-------------------------------
-- UNDYING FLESH GOLEM THROW --
-------------------------------

LinkLuaModifier("modifier_generic_motion_controller", "components/modifiers/generic/modifier_generic_motion_controller", LUA_MODIFIER_MOTION_BOTH)

imba_undying_flesh_golem_throw = imba_undying_flesh_golem_throw or class({})

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

-------------------------
-- UNDYING FLESH GOLEM --
-------------------------

imba_undying_flesh_golem = imba_undying_flesh_golem or class({})

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

LinkLuaModifier("modifier_imba_undying_flesh_golem_illusion_check", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_flesh_golem", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_flesh_golem_plague_aura", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_undying_flesh_golem_slow", "components/abilities/heroes/hero_undying", LUA_MODIFIER_MOTION_NONE)

modifier_imba_undying_flesh_golem_illusion_check = modifier_imba_undying_flesh_golem_illusion_check or class({})

-- "Illusions get a new Flesh Golem buff, lasting for the full duration, regardless of how much is left on Undying himself."
-- This intrinsic modifier is only meant for illusions to check if their owner has the Flesh Golem modifier, and to apply it if so
function modifier_imba_undying_flesh_golem_illusion_check:IsHidden() return true end

function modifier_imba_undying_flesh_golem_illusion_check:IsPurgable() return false end

function modifier_imba_undying_flesh_golem_illusion_check:RemoveOnDeath() return false end

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

	if self:GetAbility() and self:GetParent():IsIllusion() then
		local undyings = Entities:FindAllByName(self:GetParent():GetName())

		-- Find the real Undying
		for _, undying in pairs(undyings) do
			if undying:IsRealHero() and undying:GetTeamNumber() == self:GetParent():GetTeamNumber() then
				self:GetParent():AddNewModifier(self:GetParent():GetPlayerOwner():GetAssignedHero(), self:GetAbility(), "modifier_imba_undying_flesh_golem", { duration = self:GetAbility():GetSpecialValueFor("duration") })
				break
			end
		end
	end
end

---------------------------------------
-- UNDYING FLESH GOLEM BUFF MODIFIER --
---------------------------------------

modifier_imba_undying_flesh_golem = modifier_imba_undying_flesh_golem or class({})

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

	self:StartIntervalThink(0.5)
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
		MODIFIER_PROPERTY_TOOLTIP,
		-- IMBAfications: Remnants of Flesh Golem
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_imba_undying_flesh_golem:OnTooltip()
	return self.str_percentage
end

function modifier_imba_undying_flesh_golem:GetModifierMoveSpeedBonus_Constant()
	return self.movement_bonus
end

function modifier_imba_undying_flesh_golem:GetModifierBonusStats_Strength()
	return self.strength
end

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

modifier_imba_undying_flesh_golem_plague_aura = modifier_imba_undying_flesh_golem_plague_aura or class({})

function modifier_imba_undying_flesh_golem_plague_aura:IsHidden() return self:GetCaster() and self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() end

function modifier_imba_undying_flesh_golem_plague_aura:OnCreated()
	if self:GetAbility() then
		self.remnants_health_damage_pct            = self:GetAbility():GetSpecialValueFor("remnants_health_damage_pct")
		self.remnants_max_health_heal_pct_hero     = self:GetAbility():GetSpecialValueFor("remnants_max_health_heal_pct_hero")
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

modifier_imba_undying_flesh_golem_slow = modifier_imba_undying_flesh_golem_slow or class({})

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
	if IsUndyingZombie(keys.attacker) then
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
		self:GetParent():FindAbilityByName("imba_undying_tombstone"):SpawnTombstone(self:GetParent():GetAbsOrigin())
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
