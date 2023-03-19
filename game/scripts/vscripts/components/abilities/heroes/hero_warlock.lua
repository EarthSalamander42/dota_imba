-- Editors:
--     Shush, 25.04.2017
--     naowin, 11.07.2018

-----------------------------
--      FATAL BONDS        --
-----------------------------
imba_warlock_fatal_bonds = class({})
LinkLuaModifier("modifier_imba_fatal_bonds", "components/abilities/heroes/hero_warlock.lua", LUA_MODIFIER_MOTION_NONE)

function imba_warlock_fatal_bonds:IsHiddenWhenStolen()
	return false
end

function imba_warlock_fatal_bonds:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local particle_base = "particles/units/heroes/hero_warlock/warlock_fatal_bonds_base.vpcf"
	local particle_hit = "particles/units/heroes/hero_warlock/warlock_fatal_bonds_hit.vpcf"
	local modifier_bonds = "modifier_imba_fatal_bonds"

	-- Ability specials
	local max_targets = ability:GetSpecialValueFor("max_targets")
	local duration = ability:GetSpecialValueFor("duration")
	local link_search_radius = ability:GetSpecialValueFor("link_search_radius")

	-- Play cast sound
	EmitSoundOn("Hero_Warlock.FatalBonds", caster)

	-- Initialize variables
	local targets_linked = 0
	local linked_units = {}
	local bond_table = {}

	local modifier_table = {}

	-- If target has Linken's Sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	local bond_target = target

	for link = 1, max_targets do
		-- Find enemies and apply it on them as well, up to the maximum
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			bond_target:GetAbsOrigin(),
			nil,
			link_search_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NO_INVIS,
			FIND_CLOSEST,
			false)

		for _, enemy in pairs(enemies) do
			if not linked_units[enemy:GetEntityIndex()] then
				local bond_modifier = enemy:AddNewModifier(caster, ability, modifier_bonds, { duration = duration * (1 - enemy:GetStatusResistance()) })
				table.insert(modifier_table, bond_modifier)

				table.insert(bond_table, enemy)
				linked_units[enemy:GetEntityIndex()] = true

				-- If it was the main target, link from Warlock to it - otherwise, link from the target to them
				if enemy == target then
					local particle_hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_fatal_bonds_hit_parent.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster, caster)
					ParticleManager:SetParticleControlEnt(particle_hit_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle_hit_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle_hit_fx)
				else
					local particle_hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_fatal_bonds_hit_parent.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster, caster)
					ParticleManager:SetParticleControlEnt(particle_hit_fx, 0, bond_target, PATTACH_POINT_FOLLOW, "attach_hitloc", bond_target:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle_hit_fx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle_hit_fx)
				end

				bond_target = enemy

				break
			end
		end

		-- Break out of outer loop early if last loop iteration didn't successfully apply another modifier
		if link > #modifier_table then
			break
		end
	end

	-- Put the bond table on all enemies' debuff modifiers
	for _, modifiers in pairs(modifier_table) do
		modifiers.bond_table = bond_table
	end
end

modifier_imba_fatal_bonds = class({})

function modifier_imba_fatal_bonds:IsHidden() return false end

function modifier_imba_fatal_bonds:IsPurgable() return true end

function modifier_imba_fatal_bonds:IsDebuff() return true end

function modifier_imba_fatal_bonds:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_fatal_bonds:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound_damage = "Hero_Warlock.FatalBondsDamage"
	self.modifier_bonds = "modifier_imba_fatal_bonds"
	self.modifier_word = "modifier_imba_shadow_word"
	self.ability_word = "imba_warlock_shadow_word"

	-- Ability specials
	self.link_damage_share_pct = self.ability:GetSpecialValueFor("link_damage_share_pct")
	self.golem_link_radius = self.ability:GetSpecialValueFor("golem_link_radius")
	self.golem_link_damage_pct = self.ability:GetSpecialValueFor("golem_link_damage_pct")

	-- #3 Talent: Fatal Bonds damage share increase
	self.link_damage_share_pct = self.link_damage_share_pct + self.caster:FindTalentValue("special_bonus_imba_warlock_3")

	-- #7 Talent: Golems share damage they take to Fatal Bonded units, no range limit
	self.golem_link_radius = self.golem_link_radius + self.caster:FindTalentValue("special_bonus_imba_warlock_7")

	if IsServer() then
		-- Find the caster's Shadow Word ability, if feasible
		if self.caster:HasAbility(self.ability_word) then
			self.ability_word_handler = self.caster:FindAbilityByName(self.ability_word)
		end

		self.pfx_overhead = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_fatal_bonds_icon.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent, self.caster)
		--		ParticleManager:SetParticleControlEnt(self.pfx_overhead, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		--		ParticleManager:SetParticleControlEnt(self.pfx_overhead, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	end
end

function modifier_imba_fatal_bonds:OnDestroy()
	if self.pfx_overhead then
		ParticleManager:DestroyParticle(self.pfx_overhead, false)
		ParticleManager:ReleaseParticleIndex(self.pfx_overhead)
	end

	if not IsServer() or self:GetParent():IsAlive() then return end

	-- Check every unit that was linked by this modifier
	for _, enemy in pairs(self.bond_table) do
		if enemy ~= self:GetParent() then
			-- Find all link modifiers that that unit has
			local bond_modifiers = enemy:FindAllModifiersByName("modifier_imba_fatal_bonds")

			-- For each link modifier, check its own bond table
			for _, modifier in pairs(bond_modifiers) do
				-- Do it in descending order so there aren't weird indexing issues when removing entries
				for num = #(modifier.bond_table), 1, -1 do
					-- If the parent is found in that table, remove it so they don't keep taking damage after respawning
					if (modifier.bond_table)[num] == self:GetParent() then
						table.remove(modifier.bond_table, num)
						break
					end
				end
			end
		end
	end
end

function modifier_imba_fatal_bonds:DeclareFunctions()
	local decFuncs = { MODIFIER_EVENT_ON_TAKEDAMAGE }

	return decFuncs
end

function modifier_imba_fatal_bonds:OnTakeDamage(keys)
	if IsServer() and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
		local unit = keys.unit
		local original_damage = keys.original_damage
		local damage_type = keys.damage_type
		local inflictor = keys.inflictor

		-- Only apply if the unit taking damage is the parent
		if unit == self:GetParent() and self.bond_table then
			for _, bonded_enemy in pairs(self.bond_table) do
				if not bonded_enemy:IsNull() and bonded_enemy ~= self:GetParent() then
					local damageTable = {
						victim       = bonded_enemy,
						damage       = keys.original_damage * self.link_damage_share_pct / 100,
						damage_type  = keys.damage_type,
						attacker     = self:GetCaster(),
						ability      = self.ability,
						damage_flags = DOTA_DAMAGE_FLAG_REFLECTION
					}

					ApplyDamage(damageTable)

					-- Add particle hit effect
					local particle_hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_fatal_bonds_hit.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent, self:GetCaster())
					ParticleManager:SetParticleControlEnt(particle_hit_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle_hit_fx, 1, bonded_enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", bonded_enemy:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle_hit_fx)

					-- If the parent has Shadow Word but the bonded unit doesn't, apply it on the unit as well
					if self.parent:HasModifier(self.modifier_word) and not bonded_enemy:HasModifier(self.modifier_word) then
						-- If Shadow Word is not defined on the caster of Fatal Bonds, do nothing
						if not self.ability_word_handler then
							return nil
						end

						-- If the unit is not magic immune, apply the debuff
						if not bonded_enemy:IsMagicImmune() then
							local modifier_word_handler = self.parent:FindModifierByName(self.modifier_word)
							if modifier_word_handler then
								local duration_remaining = modifier_word_handler:GetRemainingTime()
								bonded_enemy:AddNewModifier(self.caster, self.ability_word_handler, self.modifier_word, { duration = duration_remaining })
							end
						end
					end
				end
			end
			-- Instead, if it was an friendly Chaotic Golem that took damage, check if the debuffed unit is in its range
		elseif keys.attacker == self:GetParent() and string.find(keys.unit:GetUnitName(), "warlock_golem") and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			-- Check distance, if it's in range, damage the parent
			if (keys.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self.golem_link_radius then
				-- Apply damage
				local damageTable =
				{
					victim       = self:GetParent(),
					damage       = keys.original_damage * self.golem_link_damage_pct / 100,
					damage_type  = keys.damage_type,
					attacker     = self:GetCaster(),
					ability      = self.ability,
					damage_flags = DOTA_DAMAGE_FLAG_REFLECTION
				}

				ApplyDamage(damageTable)

				-- Add particle hit effect
				local particle_hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_fatal_bonds_hit.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent, self:GetCaster())
				ParticleManager:SetParticleControlEnt(particle_hit_fx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(particle_hit_fx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(particle_hit_fx)

				-- If Shadow Word is not defined on the caster, do nothing
				if not self.ability_word_handler then
					return nil
				end

				-- If the Golem has Shadow Word, spread it to the parent, if it's not magic immune
				if not self.parent:IsMagicImmune() then
					if unit:HasModifier(self.modifier_word) and not self.parent:HasModifier(self.modifier_word) then
						local modifier_word_handler = unit:FindModifierByName(self.modifier_word)
						if modifier_word_handler then
							local duration_remaining = modifier_word_handler:GetRemainingTime()
							self.parent:AddNewModifier(self.caster, self.ability_word_handler, self.modifier_word, { duration = duration_remaining })
						end
					end
				end

				-- If the parent has Shadow Word and the Golem doesn't, apply Shadow Word on the Golem
				if self.parent:HasModifier(self.modifier_word) and not unit:HasModifier(self.modifier_word) then
					local modifier_word_handler = self.parent:FindModifierByName(self.modifier_word)
					if modifier_word_handler then
						local duration_remaining = modifier_word_handler:GetRemainingTime()
						unit:AddNewModifier(self.caster, self.ability_word_handler, self.modifier_word, { duration = duration_remaining })
					end
				end
			end
		end
	end
end

-----------------------------
--      SHADOW WORD        --
-----------------------------
imba_warlock_shadow_word = class({})
LinkLuaModifier("modifier_imba_shadow_word", "components/abilities/heroes/hero_warlock.lua", LUA_MODIFIER_MOTION_NONE)

function imba_warlock_shadow_word:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function imba_warlock_shadow_word:IsHiddenWhenStolen()
	return false
end

function imba_warlock_shadow_word:GetAOERadius()
	local ability = self
	local radius = ability:GetSpecialValueFor("radius")

	return radius
end

function imba_warlock_shadow_word:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local sound_target = "Hero_Warlock.ShadowWord"
	local sound_explosion = "Imba.WarlockShadowWordExplosion"
	local particle_aoe = "particles/hero/warlock/warlock_shadow_word_aoe_a.vpcf"
	local modifier_word = "modifier_imba_shadow_word"

	-- Ability specials
	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")

	-- #5 Talent: Shadow Word duration increase
	duration = duration + caster:FindTalentValue("special_bonus_imba_warlock_5")

	-- Play cast sound
	EmitSoundOn(sound_target, caster)

	-- Play explosion sound
	EmitSoundOnLocationWithCaster(target_point, sound_explosion, caster)

	-- Add particle
	local particle_aoe_fx = ParticleManager:CreateParticle(particle_aoe, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle_aoe_fx, 0, target_point)
	ParticleManager:SetParticleControl(particle_aoe_fx, 1, Vector(radius, 0, 0))
	ParticleManager:SetParticleControl(particle_aoe_fx, 2, target_point)
	ParticleManager:ReleaseParticleIndex(particle_aoe_fx)

	-- Show target area
	AddFOWViewer(caster:GetTeamNumber(), target_point, radius, 2, true)

	-- Find all enemies and allies in the area of effect
	local units = FindUnitsInRadius(caster:GetTeamNumber(),
		target_point,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	for _, unit in pairs(units) do
		-- Apply Shadow Word modifier
		unit:AddNewModifier(caster, ability, modifier_word, { duration = duration })
	end

	-- Stop Shadow Word target sound after the duration ends
	Timers:CreateTimer(duration, function()
		StopSoundOn(sound_target, caster)
	end)
end

modifier_imba_shadow_word = class({})

function modifier_imba_shadow_word:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound_good = "Hero_Warlock.ShadowWordCastGood"
	self.sound_bad = "Hero_Warlock.ShadowWordCastBad"
	self.particle_good = "particles/units/heroes/hero_warlock/warlock_shadow_word_buff.vpcf"
	self.particle_bad = "particles/units/heroes/hero_warlock/warlock_shadow_word_debuff.vpcf"

	-- Minor test for client errors
	if not self.ability then return end

	-- Ability specials
	self.tick_value = self.ability:GetSpecialValueFor("tick_value")
	self.golem_bonus_ms_pct = self.ability:GetSpecialValueFor("golem_bonus_ms_pct")
	self.golem_bonus_as = self.ability:GetSpecialValueFor("golem_bonus_as")
	self.tick_interval = self.ability:GetSpecialValueFor("tick_interval")

	-- #1 Talent: Shadow Word Golem's attack speed increase
	self.golem_bonus_as = self.golem_bonus_as + self.caster:FindTalentValue("special_bonus_imba_warlock_1")

	-- Determine which side of the buff/debuff we're using
	if self.parent:GetTeamNumber() == self.caster:GetTeamNumber() then
		self.good_guy = true
	else
		self.good_guy = false
	end

	-- Check if the unit is a friendly Golem
	if self.good_guy and string.find(self.parent:GetUnitName(), "warlock_golem") then
		self.is_golem = true
	end

	if IsServer() then
		-- Play the correct sound
		if self.good_guy then
			EmitSoundOn(self.sound_good, self.parent)
		else
			EmitSoundOn(self.sound_bad, self.parent)
		end

		-- Add the correct particle to the unit
		if self.good_guy then
			self.particle_good_fx = ParticleManager:CreateParticle(self.particle_good, PATTACH_ABSORIGIN_FOLLOW, self.parent)
			ParticleManager:SetParticleControl(self.particle_good_fx, 0, self.parent:GetAbsOrigin())
			ParticleManager:SetParticleControl(self.particle_good_fx, 2, self.parent:GetAbsOrigin())
			self:AddParticle(self.particle_good_fx, false, false, -1, false, false)
		else
			self.particle_bad_fx = ParticleManager:CreateParticle(self.particle_bad, PATTACH_ABSORIGIN_FOLLOW, self.parent)
			ParticleManager:SetParticleControl(self.particle_bad_fx, 0, self.parent:GetAbsOrigin())
			ParticleManager:SetParticleControl(self.particle_bad_fx, 2, self.parent:GetAbsOrigin())
			self:AddParticle(self.particle_bad_fx, false, false, -1, false, false)
		end

		-- Start thinking
		self:StartIntervalThink(self.tick_interval)
	end
end

function modifier_imba_shadow_word:IsHidden() return false end

function modifier_imba_shadow_word:IsPurgable() return true end

function modifier_imba_shadow_word:IgnoreTenacity() return true end

function modifier_imba_shadow_word:IsDebuff()
	if self.good_guy then
		return false
	end

	return true
end

function modifier_imba_shadow_word:OnIntervalThink()
	-- Determine whether to deal damage or to heal
	if self.good_guy then
		-- Get caster's current Spell Power
		local spell_power = self.caster:GetSpellAmplification(false)
		local heal = self.tick_value * (1 + spell_power / 100)

		self.parent:Heal(heal, self.caster)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.parent, heal, nil)
	else
		local damageTable = {
			victim = self.parent,
			attacker = self.caster,
			damage = self.tick_value,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self.ability
		}

		ApplyDamage(damageTable)
	end
end

function modifier_imba_shadow_word:OnDestroy()
	-- Stop the appropriate sound event
	if self.good_guy then
		StopSoundOn(self.sound_good, self.parent)
	else
		StopSoundOn(self.sound_bad, self.parent)
	end
end

function modifier_imba_shadow_word:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT }

	return decFuncs
end

function modifier_imba_shadow_word:GetModifierMoveSpeedBonus_Percentage()
	-- If the unit is now a golem, do nothing
	if not self.is_golem then
		return nil
	end

	return self.golem_bonus_ms_pct
end

function modifier_imba_shadow_word:GetModifierAttackSpeedBonus_Constant()
	if not self.is_golem then
		return nil
	end

	return self.golem_bonus_as
end

-----------------------------
--        UPHEAVAL         --
-----------------------------

imba_warlock_upheaval = class({})
LinkLuaModifier("modifier_imba_upheaval", "components/abilities/heroes/hero_warlock.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_upheaval_debuff", "components/abilities/heroes/hero_warlock.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_upheaval_buff", "components/abilities/heroes/hero_warlock.lua", LUA_MODIFIER_MOTION_NONE)

function imba_warlock_upheaval:IsHiddenWhenStolen()
	return false
end

function imba_warlock_upheaval:GetChannelTime()
	local caster = self:GetCaster()
	if caster:HasTalent("special_bonus_imba_warlock_6") then
		return 0
	end

	return self.BaseClass.GetChannelTime(self)
end

function imba_warlock_upheaval:GetAOERadius()
	local ability = self
	local radius = ability:GetSpecialValueFor("radius")
	return radius
end

function imba_warlock_upheaval:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local cast_response = "warlock_warl_ability_upheav_0" .. math.random(1, 4)
	local sound_loop = "Hero_Warlock.Upheaval"
	local modifier_upheaval = "modifier_imba_upheaval"

	if not caster:HasTalent("special_bonus_imba_warlock_6") then
		-- Play cast response
		EmitSoundOn(cast_response, caster)

		-- Play cast sound
		EmitSoundOn(sound_loop, caster)

		-- Apply ModifierThinker on target location
		CreateModifierThinker(caster, ability, modifier_upheaval, {}, target_point, caster:GetTeamNumber(), false)
	else
		-- #5 Talent: Upheaval summons a demon to channel it for Warlock
		local playerID = caster:GetPlayerID()
		local demon = CreateUnitByName("npc_imba_warlock_upheaval_demon", target_point, true, caster, caster, caster:GetTeamNumber())
		demon:SetControllableByPlayer(playerID, true)
		demon:AddNewModifier(demon, self, "modifier_kill", { duration = 20 })

		Timers:CreateTimer(FrameTime(), function()
			-- Resolve positions
			ResolveNPCPositions(target_point, 64)

			-- Set the health of the demon to be equal to Warlock's
			demon:SetBaseMaxHealth(caster:GetBaseMaxHealth())
			demon:SetMaxHealth(caster:GetMaxHealth())
			demon:SetHealth(demon:GetMaxHealth())

			-- Find the demon's Upheaval ability
			local ability_demon = demon:FindAbilityByName("imba_warlock_upheaval")
			ability_demon:SetLevel(self:GetLevel())
			ability_demon:SetActivated(true)
			ExecuteOrderFromTable({ UnitIndex = demon:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_CAST_POSITION, Position = demon:GetAbsOrigin(), AbilityIndex = ability_demon:GetEntityIndex(), Queue = queue })

			-- Start the demon's idle activity
			demon:StartGesture(ACT_DOTA_IDLE)
		end)
	end
end

function imba_warlock_upheaval:OnChannelFinish()
	local caster = self:GetCaster()
	local sound_loop = "Hero_Warlock.Upheaval"
	local sound_end = "Hero_Warlock.Upheaval.Stop"

	-- Stop looping sound
	StopSoundOn(sound_loop, caster)

	-- Play stop sound instead
	EmitSoundOn(sound_end, caster)

	-- If the caster was a demon, wait 2 seconds, then remove it from play
	if string.find(caster:GetUnitName(), "npc_imba_warlock_upheaval_demon") then
		Timers:CreateTimer(2, function()
			caster:Kill(ability, caster)
		end)
	end
end

-- Upheaval modifier
modifier_imba_upheaval = class({})

function modifier_imba_upheaval:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_upheaval = "particles/units/heroes/hero_warlock/warlock_upheaval.vpcf"
	self.modifier_debuff = "modifier_imba_upheaval_debuff"
	self.modifier_golem_buff = "modifier_imba_upheaval_buff"

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.ms_slow_pct_per_tick = self.ability:GetSpecialValueFor("ms_slow_pct_per_tick")
	self.linger_duration = self.ability:GetSpecialValueFor("linger_duration")
	self.tick_interval = self.ability:GetSpecialValueFor("tick_interval")
	self.max_slow_pct = self.ability:GetSpecialValueFor("max_slow_pct")

	-- Initialize the amount of slow
	self.slow = 0

	if IsServer() then
		-- Add particle effects
		self.particle_upheaval_fx = ParticleManager:CreateParticle(self.particle_upheaval, PATTACH_WORLDORIGIN, self.parent)
		ParticleManager:SetParticleControl(self.particle_upheaval_fx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_upheaval_fx, 1, Vector(self.radius, 1, 1))
		self:AddParticle(self.particle_upheaval_fx, false, false, -1, false, false)

		-- Start thinking
		self:StartIntervalThink(self.tick_interval)
	end
end

function modifier_imba_upheaval:OnIntervalThink()
	-- If the caster stopped channeling, destroy the thinker modifier
	if not self.caster:IsChanneling() then
		self:Destroy()
		return nil
	end

	-- Increase the slow power per tick
	self.slow = self.slow + (self.ms_slow_pct_per_tick * self.tick_interval)

	-- If the slow is above the limit, keep it at the limit
	if self.slow > self.max_slow_pct then
		self.slow = self.max_slow_pct
	end

	-- Find all nearby enemies and apply the debuff
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
		local modifier_debuff_handler = enemy:AddNewModifier(self.caster, self.ability, self.modifier_debuff, { duration = self.linger_duration * (1 - enemy:GetStatusResistance()) })
		-- Insert the amount of slow in the new modifier
		if modifier_debuff_handler then
			modifier_debuff_handler.slow = self.slow
		end
	end

	-- Find Golems
	local units = FindUnitsInRadius(self.caster:GetTeamNumber(),
		self.parent:GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
		FIND_ANY_ORDER,
		false)

	for _, unit in pairs(units) do
		--if string.find(unit:GetUnitName(), "npc_imba_warlock_golem") then
		if string.find(unit:GetUnitName(), "warlock_golem") then
			local modifier_golem_buff_handler = unit:AddNewModifier(self.caster, self.ability, self.modifier_golem_buff, { duration = (self.tick_interval * 2) })
			if modifier_golem_buff_handler then
				modifier_golem_buff_handler.radius = self.radius
				modifier_golem_buff_handler.center = self.parent:GetAbsOrigin()
			end
		end
	end
end

modifier_imba_upheaval_debuff = class({})

function modifier_imba_upheaval_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self
	self.parent = self:GetParent()
	self.particle_debuff_hero = "particles/units/heroes/hero_warlock/warlock_upheaval_debuff.vpcf"
	self.particle_debuff_creep = "particles/units/heroes/hero_warlock/warlock_upheaval_debuff_creep.vpcf"

	-- Determine what particle to use, and add it
	if self.parent:IsHero() then
		self.particle_debuff_hero_fx = ParticleManager:CreateParticle(self.particle_debuff_hero, PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.particle_debuff_hero_fx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_debuff_hero_fx, 1, self.parent:GetAbsOrigin())
		self:AddParticle(self.particle_debuff_hero_fx, false, false, -1, false, false)
	else
		self.particle_debuff_creep_fx = ParticleManager:CreateParticle(self.particle_debuff_creep, PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.particle_debuff_creep_fx, 0, self.parent:GetAbsOrigin())
		self:AddParticle(self.particle_debuff_creep_fx, false, false, -1, false, false)
	end

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_upheaval_debuff:IsHidden() return false end

function modifier_imba_upheaval_debuff:IsPurgable() return true end

function modifier_imba_upheaval_debuff:IsDebuff() return true end

function modifier_imba_upheaval_debuff:OnIntervalThink()
	if IsServer() then
		-- If the slow was not yet defined, do nothing
		if not self.slow then
			return nil
		end

		-- Set stack count
		self:SetStackCount(self.slow)
	end
end

function modifier_imba_upheaval_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_imba_upheaval_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount() * (-1)
end

function modifier_imba_upheaval_debuff:GetModifierAttackSpeedBonus_Constant()
	-- #2 Talent: Upheaval also reduces attack speed
	if self.caster:HasTalent("special_bonus_imba_warlock_2") then
		return self:GetStackCount() * (-1)
	end
end

-- Golem Upheaval buff
modifier_imba_upheaval_buff = class({})

function modifier_imba_upheaval_buff:IsHidden() return false end

function modifier_imba_upheaval_buff:IsPurgable() return false end

function modifier_imba_upheaval_buff:IsDebuff() return false end

-----------------------------
--    CHAOTIC OFFERING     --
-----------------------------
imba_warlock_rain_of_chaos = class({})
LinkLuaModifier("modifier_imba_rain_of_chaos_stun", "components/abilities/heroes/hero_warlock.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rain_of_chaos_golem_as", "components/abilities/heroes/hero_warlock.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rain_of_chaos_golem_ms", "components/abilities/heroes/hero_warlock.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rain_of_chaos_demon_link", "components/abilities/heroes/hero_warlock.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rain_of_chaos_demon_visible", "components/abilities/heroes/hero_warlock.lua", LUA_MODIFIER_MOTION_NONE)

function imba_warlock_rain_of_chaos:IsHiddenWhenStolen()
	return false
end

function imba_warlock_rain_of_chaos:IsNetherWardStealable()
	return false
end

function imba_warlock_rain_of_chaos:GetAOERadius()
	local ability = self
	local radius = ability:GetSpecialValueFor("radius")
	return radius
end

function imba_warlock_rain_of_chaos:OnAbilityPhaseStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_precast = "Hero_Warlock.RainOfChaos_buildup"

	-- Play precast sound
	EmitSoundOn(sound_precast, caster)

	return true
end

function imba_warlock_rain_of_chaos:OnAbilityPhaseInterrupted()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_precast = "Hero_Warlock.RainOfChaos_buildup"

	-- Stop precast sound
	StopSoundOn(sound_precast, caster)
end

function imba_warlock_rain_of_chaos:OnSpellStart()
	local cursor_position = self:GetCursorPosition()

	if self:GetCaster():HasScepter() then
		for golems = 0, self:GetSpecialValueFor("number_of_golems_scepter") - 1 do
			Timers:CreateTimer(0.4 * golems, function()
				self:SummonGolem(cursor_position, true, false)
			end)
		end
	else
		self:SummonGolem(cursor_position, false, false)
	end

	-- -- Ability properties
	-- local caster = self:GetCaster()
	-- local ability = self
	-- local target_point = self:GetCursorPosition()
	-- local golem_level = ability:GetLevel()
	-- local playerID = caster:GetPlayerID()
	-- local cast_response = {"warlock_warl_ability_reign_02", "warlock_warl_ability_reign_03", "warlock_warl_ability_reign_04", "warlock_warl_ability_reign_05", "warlock_warl_ability_reign_06"}
	-- local rare_cast_response = "warlock_warl_ability_reign_01"
	-- local sound_cast = "Hero_Warlock.RainOfChaos"
	-- local particle_start = "particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf"
	-- local particle_main = "particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf"
	-- local modifier_stun = "modifier_imba_rain_of_chaos_stun"
	-- local modifier_attack_speed = "modifier_imba_rain_of_chaos_golem_as"
	-- local modifier_move_speed = "modifier_imba_rain_of_chaos_golem_ms"
	-- local modifier_demon_link = "modifier_imba_rain_of_chaos_demon_link"
	-- local ability_fists = "imba_warlock_flaming_fists"
	-- local ability_immolate = "imba_warlock_permanent_immolation"

	-- -- Ability specials
	-- local radius = ability:GetSpecialValueFor("radius")
	-- local duration = ability:GetSpecialValueFor("duration")
	-- local stun_duration = ability:GetSpecialValueFor("stun_duration")
	-- local bonus_hp_per_str = ability:GetSpecialValueFor("bonus_hp_per_str")
	-- local bonus_armor_per_agi = ability:GetSpecialValueFor("bonus_armor_per_agi")
	-- local bonus_aspeed_per_agi = ability:GetSpecialValueFor("bonus_aspeed_per_agi")
	-- local bonus_damage_per_int = ability:GetSpecialValueFor("bonus_damage_per_int")
	-- local ms_bonus_boots = ability:GetSpecialValueFor("ms_bonus_boots")
	-- local effect_delay = ability:GetSpecialValueFor("effect_delay")
	-- local scepter_demon_count = ability:GetSpecialValueFor("scepter_demon_count")
	-- local scepter_demon_distance = ability:GetSpecialValueFor("scepter_demon_distance")
	-- local scepter_demon_hp = ability:GetSpecialValueFor("scepter_demon_hp")

	-- -- Roll for rare cast response, otherwise, play normal cast response
	-- if RollPercentage(5) then
	-- EmitSoundOn(rare_cast_response, caster)
	-- else
	-- EmitSoundOn(cast_response[math.random(1, #cast_response)], caster)
	-- end

	-- -- Play cast sound
	-- EmitSoundOn(sound_cast, caster)

	-- -- Add start particle effect
	-- local particle_start_fx = ParticleManager:CreateParticle(particle_start, PATTACH_ABSORIGIN, caster)
	-- ParticleManager:SetParticleControl(particle_start_fx, 0, target_point)
	-- ParticleManager:ReleaseParticleIndex(particle_start_fx)

	-- -- Destroy trees in the radius
	-- GridNav:DestroyTreesAroundPoint(target_point, radius, false)

	-- -- Wait for the effect delay
	-- Timers:CreateTimer(effect_delay, function()
	-- -- Add main particle effect
	-- local particle_main_fx = ParticleManager:CreateParticle(particle_main, PATTACH_ABSORIGIN, caster)
	-- ParticleManager:SetParticleControl(particle_main_fx, 0, target_point)
	-- ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(radius, 0, 0))
	-- ParticleManager:ReleaseParticleIndex(particle_main_fx)

	-- -- Stun nearby enemies, even if they're magic immune
	-- local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
	-- target_point,
	-- nil,
	-- radius,
	-- DOTA_UNIT_TARGET_TEAM_ENEMY,
	-- DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	-- DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	-- FIND_ANY_ORDER,
	-- false)

	-- for _,enemy in pairs(enemies) do
	-- enemy:AddNewModifier(caster, ability, modifier_stun, {duration = stun_duration})
	-- end

	-- -- Summon the appropriate Golem unit based on the skill's level at the target point
	-- local golem = CreateUnitByName("npc_imba_warlock_golem_"..golem_level, target_point, true, caster, caster, caster:GetTeamNumber())

	-- -- Apply kill modifier on golem to set its duration
	-- golem:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})

	-- -- Set the golem to be controllable by Warlock's player
	-- golem:SetControllableByPlayer(playerID, true)

	-- -- Calculate bonus properties based on Warlock's stats
	-- local bonus_hp = caster:GetStrength() * bonus_hp_per_str
	-- local bonus_damage = caster:GetIntellect() * bonus_damage_per_int
	-- local bonus_armor = caster:GetAgility() * bonus_armor_per_agi
	-- local bonus_attack_speed = caster:GetAgility() * bonus_aspeed_per_agi
	-- local bonus_move_speed = caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), false) - caster:GetBaseMoveSpeed()

	-- -- Set Golem's properties according to the bonus properties
	-- -- Health:
	-- golem:SetBaseMaxHealth(golem:GetBaseMaxHealth() + bonus_hp)
	-- golem:SetMaxHealth(golem:GetMaxHealth() + bonus_hp)
	-- golem:SetHealth(golem:GetMaxHealth())

	-- -- Damage:
	-- golem:SetBaseDamageMin(golem:GetBaseDamageMin() + bonus_damage)
	-- golem:SetBaseDamageMax(golem:GetBaseDamageMax() + bonus_damage)

	-- -- Armor:
	-- golem:SetPhysicalArmorBaseValue(golem:GetPhysicalArmorValue(false) + bonus_armor)

	-- -- #4 Talent: Chaotic Golem armor increase
	-- if caster:HasTalent("special_bonus_imba_warlock_4") then
	-- golem:SetPhysicalArmorBaseValue(golem:GetPhysicalArmorValue(false) + caster:FindTalentValue("special_bonus_imba_warlock_4"))
	-- end

	-- -- Attack speed (needs to be done through a modifier):
	-- local modifier_attackspeed_handler = golem:AddNewModifier(caster, ability, modifier_attack_speed, {})
	-- if modifier_attackspeed_handler then
	-- modifier_attackspeed_handler:SetStackCount(bonus_attack_speed)
	-- end

	-- -- Move speed (needs to be done through a modifier):
	-- local modifier_movespeed_handler = golem:AddNewModifier(caster, ability, modifier_move_speed, {})
	-- if modifier_movespeed_handler then
	-- modifier_movespeed_handler:SetStackCount(bonus_move_speed)
	-- end

	-- -- #8 Talent: Chaotic Golems are now Spell Immune
	-- if caster:HasTalent("special_bonus_imba_warlock_8") then
	-- ability_spell_immunity = golem:AddAbility("imba_warlock_golem_spell_immunity")
	-- ability_spell_immunity:SetLevel(1)
	-- end

	-- -- Level the golem's skills to the appropriate level
	-- local ability_fists_handler = golem:FindAbilityByName(ability_fists)
	-- if ability_fists_handler then
	-- ability_fists_handler:SetLevel(golem_level)
	-- end

	-- local ability_immolate_handler = golem:FindAbilityByName(ability_immolate)
	-- if ability_immolate_handler then
	-- ability_immolate_handler:SetLevel(golem_level)
	-- end

	-- -- Resolve positions
	-- ResolveNPCPositions(target_point, 128)

	-- -- If caster has scepter, summon Demonic Ascension
	-- if caster:HasScepter() then
	-- -- Assign the golem with the demon link modifier
	-- local demon_link_modifier = golem:AddNewModifier(caster, ability, modifier_demon_link, {})

	-- -- Decide how to arrange the demons. First one is behind the golem, closest to Warlock's position
	-- local angle_per_demon = 360 / scepter_demon_count
	-- local summon_edge_point = target_point + (target_point - caster:GetAbsOrigin()):Normalized() * scepter_demon_distance

	-- for i = 0, (scepter_demon_count -1) do
	-- -- Spawning point
	-- local qangle = QAngle(0, i * angle_per_demon, 0)
	-- local demon_spawn_point = RotatePosition(target_point, qangle, summon_edge_point)

	-- -- Create demon
	-- local demon = CreateUnitByName("npc_imba_warlock_demonic_ascension", demon_spawn_point, true, caster, caster, caster:GetTeamNumber())
	-- demon:SetControllableByPlayer(playerID, true)
	-- demon:StartGesture(ACT_DOTA_IDLE)

	-- -- Forward vector
	-- local direction = (target_point - demon_spawn_point):Normalized()
	-- demon:SetForwardVector(direction)

	-- -- Set the demon's health according to level
	-- demon:SetMaxHealth(scepter_demon_hp)
	-- demon:SetBaseMaxHealth(scepter_demon_hp)
	-- demon:SetHealth(scepter_demon_hp)

	-- demon:AddNewModifier(golem, ability, "modifier_imba_rain_of_chaos_demon_visible", {})

	-- -- Assign the demons to that golem
	-- if demon_link_modifier then
	-- if not demon_link_modifier.demon_table then
	-- demon_link_modifier.demon_table = {}
	-- else
	-- table.insert(demon_link_modifier.demon_table, demon)
	-- end
	-- end
	-- end

	-- ResolveNPCPositions(target_point, radius)
	-- end
	-- end)
end

function imba_warlock_rain_of_chaos:SummonGolem(target_point, bScepter, bDeath)
	-- Play cast sound
	EmitSoundOn("Hero_Warlock.RainOfChaos", self:GetCaster())

	-- Add start particle effect
	local particle_start_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_start_fx, 0, target_point)
	ParticleManager:ReleaseParticleIndex(particle_start_fx)

	local effect_delay = self:GetSpecialValueFor("effect_delay")

	if bDeath then
		effect_delay = 0
	end

	Timers:CreateTimer(effect_delay, function()
		-- Destroy trees in the radius
		GridNav:DestroyTreesAroundPoint(target_point, self:GetSpecialValueFor("radius"), false)

		-- Add main particle effect
		local particle_main_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(particle_main_fx, 0, target_point)
		ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(self:GetSpecialValueFor("radius"), 0, 0))
		ParticleManager:ReleaseParticleIndex(particle_main_fx)

		-- Stun nearby enemies, even if they're magic immune
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
			target_point,
			nil,
			self:GetSpecialValueFor("radius"),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER,
			false)

		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_rain_of_chaos_stun", { duration = self:GetSpecialValueFor("stun_duration") * (1 - enemy:GetStatusResistance()) })
		end

		-- Summon the appropriate Golem unit based on the skill's level at the target point
		-- local golem = CreateUnitByName("npc_imba_warlock_golem_"..self:GetLevel(), target_point, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())

		local golem = nil

		if not bScepter or bDeath then
			golem = CreateUnitByName("npc_dota_warlock_golem_" .. self:GetLevel(), target_point, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		else
			golem = CreateUnitByName("npc_dota_warlock_golem_scepter_" .. self:GetLevel(), target_point, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		end

		-- Apply kill modifier on golem to set its duration
		golem:AddNewModifier(self:GetCaster(), self, "modifier_kill", { duration = self:GetSpecialValueFor("duration") })

		-- Set the golem to be controllable by Warlock's player
		golem:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)

		-- Calculate bonus properties based on Warlock's stats
		local bonus_hp           = self:GetCaster():GetStrength() * self:GetSpecialValueFor("bonus_hp_per_str")
		local bonus_damage       = self:GetCaster():GetIntellect() * self:GetSpecialValueFor("bonus_damage_per_int")
		local bonus_armor        = self:GetCaster():GetAgility() * self:GetSpecialValueFor("bonus_armor_per_agi")
		local bonus_attack_speed = self:GetCaster():GetAgility() * self:GetSpecialValueFor("bonus_aspeed_per_agi")
		local bonus_move_speed   = self:GetCaster():GetMoveSpeedModifier(self:GetCaster():GetBaseMoveSpeed(), false) - self:GetCaster():GetBaseMoveSpeed()

		if bScepter or bDeath then
			bonus_hp           = bonus_hp * (100 - self:GetSpecialValueFor("hp_dmg_reduction_scepter")) / 100
			bonus_damage       = bonus_damage * (100 - self:GetSpecialValueFor("hp_dmg_reduction_scepter")) / 100
			bonus_armor        = bonus_armor * (100 - self:GetSpecialValueFor("hp_dmg_reduction_scepter")) / 100
			bonus_attack_speed = bonus_attack_speed * (100 - self:GetSpecialValueFor("hp_dmg_reduction_scepter")) / 100
			bonus_move_speed   = bonus_move_speed * (100 - self:GetSpecialValueFor("hp_dmg_reduction_scepter")) / 100

			-- Also reduce bounty
			if not bDeath then
				golem:SetMinimumGoldBounty(golem:GetMinimumGoldBounty() * (100 - self:GetSpecialValueFor("bounty_reduction_scepter")) / 100)
				golem:SetMaximumGoldBounty(golem:GetMaximumGoldBounty() * (100 - self:GetSpecialValueFor("bounty_reduction_scepter")) / 100)
			end
		end

		-- Set Golem's properties according to the bonus properties
		-- Health:
		golem:SetBaseMaxHealth(golem:GetBaseMaxHealth() + bonus_hp)
		golem:SetMaxHealth(golem:GetMaxHealth() + bonus_hp)
		golem:SetHealth(golem:GetMaxHealth())

		-- Damage:
		golem:SetBaseDamageMin(golem:GetBaseDamageMin() + bonus_damage)
		golem:SetBaseDamageMax(golem:GetBaseDamageMax() + bonus_damage)

		-- Armor:
		golem:SetPhysicalArmorBaseValue(golem:GetPhysicalArmorValue(false) + bonus_armor)

		-- #4 Talent: Chaotic Golem armor increase
		if self:GetCaster():HasTalent("special_bonus_imba_warlock_4") then
			golem:SetPhysicalArmorBaseValue(golem:GetPhysicalArmorValue(false) + self:GetCaster():FindTalentValue("special_bonus_imba_warlock_4"))
		end

		-- Attack speed (needs to be done through a modifier):
		-- I'm also going to attach the 100% magic resistance talent onto this modifier
		local modifier_attackspeed_handler = golem:AddNewModifier(self:GetCaster(), self, "modifier_imba_rain_of_chaos_golem_as", {})
		if modifier_attackspeed_handler then
			modifier_attackspeed_handler:SetStackCount(bonus_attack_speed)
		end

		-- Move speed (needs to be done through a modifier):
		local modifier_movespeed_handler = golem:AddNewModifier(self:GetCaster(), self, "modifier_imba_rain_of_chaos_golem_ms", {})
		if modifier_movespeed_handler then
			modifier_movespeed_handler:SetStackCount(bonus_move_speed)
		end

		-- #8 Talent: Chaotic Golems are now Spell Immune
		if self:GetCaster():HasTalent("special_bonus_imba_warlock_8") then
			ability_spell_immunity = golem:AddAbility("imba_warlock_golem_spell_immunity")
			ability_spell_immunity:SetLevel(1)
		end

		-- Level the golem's skills to the appropriate level
		local ability_fists_handler = golem:FindAbilityByName("imba_warlock_flaming_fists")
		if ability_fists_handler then
			ability_fists_handler:SetLevel(self:GetLevel())
		end

		local ability_immolate_handler = golem:FindAbilityByName("imba_warlock_permanent_immolation")
		if ability_immolate_handler then
			ability_immolate_handler:SetLevel(self:GetLevel())
		end

		-- Resolve positions
		ResolveNPCPositions(target_point, 128)
	end)
end

function imba_warlock_rain_of_chaos:OnOwnerDied()
	if self:GetCaster():HasTalent("special_bonus_imba_warlock_9") and (not self:GetCaster().IsReincarnating or (self:GetCaster().IsReincarnating and not self:GetCaster():IsReincarnating())) and self:IsTrained() then
		self:SummonGolem(self:GetCaster():GetAbsOrigin(), self:GetCaster():HasScepter(), true)
	end
end

-- Stun modifier
modifier_imba_rain_of_chaos_stun = class({})

function modifier_imba_rain_of_chaos_stun:CheckState()
	return { [MODIFIER_STATE_STUNNED] = true }
end

function modifier_imba_rain_of_chaos_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_rain_of_chaos_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_rain_of_chaos_stun:IsHidden() return false end

function modifier_imba_rain_of_chaos_stun:IsPurgeException() return true end

function modifier_imba_rain_of_chaos_stun:IsStunDebuff() return true end

-- Golem attack speed bonus modifier
modifier_imba_rain_of_chaos_golem_as = class({})

function modifier_imba_rain_of_chaos_golem_as:IsHidden() return true end

function modifier_imba_rain_of_chaos_golem_as:IsPurgable() return false end

function modifier_imba_rain_of_chaos_golem_as:IsDebuff() return false end

function modifier_imba_rain_of_chaos_golem_as:OnCreated()
	if self:GetAbility() and self:GetCaster() and not self:GetCaster():IsNull() and self:GetCaster():HasTalent("special_bonus_imba_warlock_chaotic_offering_magic_resistance") then
		self.magic_resistance = 100
	else
		self.magic_resistance = 0
	end
end

function modifier_imba_rain_of_chaos_golem_as:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_imba_rain_of_chaos_golem_as:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end

function modifier_imba_rain_of_chaos_golem_as:GetModifierMagicalResistanceBonus()
	return self.magic_resistance
end

-- Golem move speed bonus modifier
modifier_imba_rain_of_chaos_golem_ms = class({})

function modifier_imba_rain_of_chaos_golem_ms:IsHidden() return true end

function modifier_imba_rain_of_chaos_golem_ms:IsPurgable() return false end

function modifier_imba_rain_of_chaos_golem_ms:IsDebuff() return false end

function modifier_imba_rain_of_chaos_golem_ms:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT }
end

function modifier_imba_rain_of_chaos_golem_ms:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()
end

-- Demon Link modifier (placed on golem)
modifier_imba_rain_of_chaos_demon_link = class({})
function modifier_imba_rain_of_chaos_demon_link:IsPurgable() return false end

function modifier_imba_rain_of_chaos_demon_link:IsPurgeException() return false end

function modifier_imba_rain_of_chaos_demon_link:RemoveOnDeath() return true end

function modifier_imba_rain_of_chaos_demon_link:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_link = "particles/hero/warlock/warlock_demon_link.vpcf"
	self.particle_link_damage = "particles/hero/warlock/warlock_demon_link_damage.vpcf"

	-- Ability specials
	self.scepter_damage_transfer_pct = self.ability:GetSpecialValueFor("scepter_damage_transfer_pct")
	self.scepter_damage_per_demon_pct = self.ability:GetSpecialValueFor("scepter_damage_per_demon_pct")
	self.scepter_demon_count = self.ability:GetSpecialValueFor("scepter_demon_count")

	-- Demon table
	self.demon_table = {}

	-- Particle table
	self.particle_table = {}

	if IsServer() then
		-- Wait for a tick, then assign each particle to a demon
		Timers:CreateTimer(FrameTime(), function()
			if #self.demon_table < self.scepter_demon_count then
				return FrameTime()
			else
				for i = 1, self.scepter_demon_count do
					self.particle_table[i] = ParticleManager:CreateParticle(self.particle_link, PATTACH_CUSTOMORIGIN_FOLLOW, self.demon_table[i])
					ParticleManager:SetParticleControlEnt(self.particle_table[i], 0, self.demon_table[i], PATTACH_POINT_FOLLOW, "attach_hitloc", self.demon_table[i]:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(self.particle_table[i], 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
				end

				if self and not self:IsNull() then
					-- Set the stack count of the modifier to the amount of demons linked
					self:SetStackCount(self.scepter_demon_count)

					-- Start thinking
					self:StartIntervalThink(FrameTime())
				end
			end
		end)
	end
end

function modifier_imba_rain_of_chaos_demon_link:OnIntervalThink()
	-- Set the forward vectors of all current demons to face towards the golem they're linked to
	for i = 1, #self.demon_table do
		if not self.parent:IsNull() and self.parent.GetAbsOrigin and not self.demon_table[i]:IsNull() and self.demon_table[i].GetAbsOrigin then
			local direction = (self.parent:GetAbsOrigin() - self.demon_table[i]:GetAbsOrigin()):Normalized()
			self.demon_table[i]:SetForwardVector(direction)
		end
	end
end

function modifier_imba_rain_of_chaos_demon_link:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE }

	return decFuncs
end

function modifier_imba_rain_of_chaos_demon_link:GetModifierIncomingDamage_Percentage()
	for i = 1, #self.demon_table do
		if not self.demon_table[i] or not self.demon_table[i]:IsAlive() then
			return 0
		end
	end

	return -100
end

function modifier_imba_rain_of_chaos_demon_link:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetStackCount() * self.scepter_damage_per_demon_pct
end

function modifier_imba_rain_of_chaos_demon_link:OnTakeDamage(keys)
	if IsServer() then
		local unit = keys.unit
		local damage = keys.original_damage
		local attacker = keys.attacker
		local damage_type = keys.damage_type

		-- Only apply on the golem taking damage
		if unit == self.parent then
			-- Pick a random demon
			local chosen_demon = math.random(1, #self.demon_table)

			-- Add a particle for indicating the damage
			local particle_link_damage_fx = ParticleManager:CreateParticle(self.particle_link_damage, PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
			ParticleManager:SetParticleControlEnt(particle_link_damage_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)

			if not self.demon_table[chosen_demon]:IsNull() then
				ParticleManager:SetParticleControlEnt(particle_link_damage_fx, 1, self.demon_table[chosen_demon], PATTACH_POINT_FOLLOW, "attach_hitloc", self.demon_table[chosen_demon]:GetAbsOrigin(), true)
			end

			Timers:CreateTimer(0.5, function()
				ParticleManager:DestroyParticle(particle_link_damage_fx, false)
				ParticleManager:ReleaseParticleIndex(particle_link_damage_fx)
			end)

			-- Adjust damage according to armor or magic resist, if damage types match. (COMMENTED OUT DUE TO GAME-BREAKING SCRIPT ERROR)
			-- if damage_type == DAMAGE_TYPE_PHYSICAL then
			-- damage = damage * (1 - self.parent:GetPhysicalArmorReduction() / 100)

			-- elseif damage_type == DAMAGE_TYPE_MAGICAL then
			-- damage = damage * (1- self.parent:GetMagicalArmorValue() / 100)
			-- end

			-- Decrease damage to the demon
			damage = damage * self.scepter_damage_transfer_pct / 100

			-- Deal damage
			local damageTable = {
				victim = self.demon_table[chosen_demon],
				attacker = attacker,
				damage = damage,
				damage_type = damage_type,
			}

			ApplyDamage(damageTable)
		end
	end
end

function modifier_imba_rain_of_chaos_demon_link:OnDeath(keys)
	if IsServer() then
		local unit = keys.unit

		-- Apply when the killed unit is one of the linked demons
		for i = 1, #self.demon_table do
			if unit == self.demon_table[i] then
				-- Reduce stack count
				self:DecrementStackCount()

				if not self.particle_table[i] then break end

				-- Stop the particle effect
				ParticleManager:DestroyParticle(self.particle_table[i], false)
				ParticleManager:ReleaseParticleIndex(self.particle_table[i])

				-- Remove the demon and the particle from the table
				table.remove(self.demon_table, i)
				table.remove(self.particle_table, i)
			end

			-- If there are no more demons, destroy this modifier
			if #self.demon_table == 0 then
				self:Destroy()
			end
		end
	end
end

function modifier_imba_rain_of_chaos_demon_link:OnRemoved()
	-- Severe all remaining particles and kill all remaining demons
	for i = 1, #self.demon_table do
		if self.particle_table[i] then
			self.demon_table[i]:Kill(self.ability, self.caster)
			ParticleManager:DestroyParticle(self.particle_table[i], false)
			ParticleManager:ReleaseParticleIndex(self.particle_table[i])
		end
	end
end

-- Visbility modifier (placed on demons)
modifier_imba_rain_of_chaos_demon_visible = class({})

function modifier_imba_rain_of_chaos_demon_visible:IsPurgable() return false end

function modifier_imba_rain_of_chaos_demon_visible:IsHidden() return true end

function modifier_imba_rain_of_chaos_demon_visible:OnCreated()
	if not IsServer() then return end

	self:StartIntervalThink(1)
end

function modifier_imba_rain_of_chaos_demon_visible:OnIntervalThink()
	if not IsServer() then return end

	if not self:GetCaster():IsAlive() then
		self:GetParent():ForceKill(false)
	end
end

function modifier_imba_rain_of_chaos_demon_visible:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_PROVIDES_FOW_POSITION }

	return decFuncs
end

function modifier_imba_rain_of_chaos_demon_visible:GetModifierProvidesFOWVision()
	return 1
end

-----------------------------
--      FLAMING FISTS      --
-----------------------------
imba_warlock_flaming_fists = class({})
LinkLuaModifier("modifier_imba_flaming_fists", "components/abilities/heroes/hero_warlock.lua", LUA_MODIFIER_MOTION_NONE)

function imba_warlock_flaming_fists:GetAbilityTextureName()
	return "warlock_golem_flaming_fists"
end

function imba_warlock_flaming_fists:GetIntrinsicModifierName()
	return "modifier_imba_flaming_fists"
end

-- Flaming fists modifier
modifier_imba_flaming_fists = class({})

function modifier_imba_flaming_fists:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_upheaval = "modifier_imba_upheaval_buff"
	self.particle_burn = "particles/hero/warlock/warlock_upheaval_golem_burn.vpcf"

	-- Ability specials
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_imba_flaming_fists:OnRefresh()
	self:OnCreated()
end

function modifier_imba_flaming_fists:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
		MODIFIER_EVENT_ON_ATTACK_LANDED }

	return decFuncs
end

function modifier_imba_flaming_fists:GetModifierProcAttack_BonusDamage_Pure(keys)
	local target = keys.target

	-- If the unit is not a hero or a creep, do nothing
	if not target:IsHero() and not target:IsCreep() then
		return nil
	end

	-- If the caster is broken, do nothing
	if self.caster:PassivesDisabled() then
		return nil
	end

	return self.damage
end

function modifier_imba_flaming_fists:OnAttackLanded(keys)
	if IsServer() then
		local target = keys.target
		local attacker = keys.attacker

		-- Only apply if the caster is the one attacking
		if self.caster == attacker then
			-- If the unit is not a hero or a creep, do nothing
			if not target:IsHero() and not target:IsCreep() then
				return nil
			end

			-- If the caster is broken, do nothing
			if self.caster:PassivesDisabled() then
				return nil
			end


			local radius = self.radius

			-- If the caster is inside Upheaval, get and use the whole Upheaval radius
			if self.caster:HasModifier(self.modifier_upheaval) then
				local modifier_upheaval_handler = self.caster:FindModifierByName(self.modifier_upheaval)
				if modifier_upheaval_handler and modifier_upheaval_handler.radius and modifier_upheaval_handler.center then
					radius = modifier_upheaval_handler.radius

					-- Add the Upheaval burn particle effect
					self.particle_burn_fx = ParticleManager:CreateParticle(self.particle_burn, PATTACH_WORLDORIGIN, self.caster)
					ParticleManager:SetParticleControl(self.particle_burn_fx, 0, modifier_upheaval_handler.center)
					ParticleManager:SetParticleControl(self.particle_burn_fx, 1, Vector(radius, 0, 0))
					ParticleManager:ReleaseParticleIndex(self.particle_burn_fx)
				end
			end

			-- Find all nearby enemy units and deal pure damage to all of them
			local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
				target:GetAbsOrigin(),
				nil,
				radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				FIND_ANY_ORDER,
				false)

			-- Do not damage the main target
			for _, enemy in pairs(enemies) do
				if enemy ~= target then
					local damageTable = {
						victim = enemy,
						attacker = self.caster,
						damage = self.damage,
						damage_type = DAMAGE_TYPE_PURE,
						ability = self.ability
					}

					ApplyDamage(damageTable)
				end
			end
		end
	end
end

function modifier_imba_flaming_fists:IsHidden() return true end

function modifier_imba_flaming_fists:IsPurgable() return false end

function modifier_imba_flaming_fists:IsDebuff() return false end

-----------------------------
--  PERMANENT IMMOLATION   --
-----------------------------
imba_warlock_permanent_immolation = class({})
LinkLuaModifier("modifier_imba_permanent_immolation_aura", "components/abilities/heroes/hero_warlock.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_permanent_immolation_debuff", "components/abilities/heroes/hero_warlock.lua", LUA_MODIFIER_MOTION_NONE)

function imba_warlock_permanent_immolation:GetIntrinsicModifierName()
	return "modifier_imba_permanent_immolation_aura"
end

function imba_warlock_permanent_immolation:GetAbilityTextureName()
	return "warlock_golem_permanent_immolation"
end

-- Permanent immolation aura modifier
modifier_imba_permanent_immolation_aura = class({})

function modifier_imba_permanent_immolation_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_burn = "modifier_imba_permanent_immolation_debuff"
	self.modifier_upheaval = "modifier_imba_upheaval_buff"
	self.modifier_upheaval_debuff = "modifier_imba_upheaval_debuff"
	self.particle_burn = "particles/hero/warlock/warlock_upheaval_golem_burn.vpcf"

	-- Ability special
	self.radius = self.ability:GetSpecialValueFor("radius")

	-- Actual radius to use, in case of Upheaval burns
	self.actual_radius = self.radius

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("burn_interval"))
	end
end

function modifier_imba_permanent_immolation_aura:OnIntervalThink()
	if self.caster:HasModifier(self.modifier_upheaval) then
		local modifier_upheaval_handler = self.caster:FindModifierByName(self.modifier_upheaval)
		if modifier_upheaval_handler and modifier_upheaval_handler.radius and modifier_upheaval_handler.center then
			-- Set actual aura radius. Need to dramatically increase the radius of the immolation. This is remedied by rejecting enemies outside the radius
			self.actual_radius = modifier_upheaval_handler.radius * 2

			-- BURN!!!! effect
			self.particle_burn_fx = ParticleManager:CreateParticle(self.particle_burn, PATTACH_WORLDORIGIN, self.caster)
			ParticleManager:SetParticleControl(self.particle_burn_fx, 0, modifier_upheaval_handler.center)
			ParticleManager:SetParticleControl(self.particle_burn_fx, 1, Vector(modifier_upheaval_handler.radius, 0, 0))
			ParticleManager:ReleaseParticleIndex(self.particle_burn_fx)
		end
	else
		self.actual_radius = self.radius
	end

	-- Find nearby enemies
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
		self.caster:GetAbsOrigin(),
		nil,
		self.actual_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	for _, enemy in pairs(enemies) do
		if enemy:HasModifier(self.modifier_burn) then
			-- Damage enemies
			ApplyDamage({
				victim      = enemy,
				attacker    = self.caster,
				damage      = self:GetAbility():GetSpecialValueFor("damage"),
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability     = self.ability
			})
		end
	end
end

function modifier_imba_permanent_immolation_aura:GetAuraRadius()
	return self.actual_radius
end

function modifier_imba_permanent_immolation_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_permanent_immolation_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_permanent_immolation_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_permanent_immolation_aura:GetAuraEntityReject(target)
	-- If both the target and the golem are inside Upheaval, apply it
	if self.caster:HasModifier(self.modifier_upheaval) and target:HasModifier(self.modifier_upheaval_debuff) then
		return false
	end

	-- If the distance is bigger than the Immolation Aura's radius, ignore it
	if (self.caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > self.radius then
		return true
	end

	-- Otherwise, apply normally
	return false
end

function modifier_imba_permanent_immolation_aura:GetModifierAura()
	return "modifier_imba_permanent_immolation_debuff"
end

function modifier_imba_permanent_immolation_aura:IsAura()
	-- If caster is disabled, aura is not emitted
	if self:GetCaster():PassivesDisabled() then
		return false
	end

	return true
end

function modifier_imba_permanent_immolation_aura:IsHidden() return true end

function modifier_imba_permanent_immolation_aura:IsPurgable() return false end

function modifier_imba_permanent_immolation_aura:IsDebuff() return false end

-- Permanent immolation debuff modifier
modifier_imba_permanent_immolation_debuff = class({})

function modifier_imba_permanent_immolation_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_permanent_immolation_debuff:IsHidden() return false end

function modifier_imba_permanent_immolation_debuff:IsPurgable() return false end

function modifier_imba_permanent_immolation_debuff:IsDebuff() return true end

-----------------------------
--     SPELL IMMUNITY      --
-----------------------------
imba_warlock_golem_spell_immunity = class({})
LinkLuaModifier("modifier_imba_golem_spell_immunity", "components/abilities/heroes/hero_warlock.lua", LUA_MODIFIER_MOTION_NONE)

function imba_warlock_golem_spell_immunity:GetAbilityTextureName()
	return "neutral_spell_immunity"
end

function imba_warlock_golem_spell_immunity:GetIntrinsicModifierName()
	return "modifier_imba_golem_spell_immunity"
end

-- Spell immunity modifier
modifier_imba_golem_spell_immunity = class({})

function modifier_imba_golem_spell_immunity:GetEffectName()
	return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_imba_golem_spell_immunity:CheckState()
	return { [MODIFIER_STATE_MAGIC_IMMUNE] = true }
end

function modifier_imba_golem_spell_immunity:IsHidden() return false end

function modifier_imba_golem_spell_immunity:IsPurgable() return false end

function modifier_imba_golem_spell_immunity:IsDebuff() return false end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_warlock_1", "components/abilities/heroes/hero_warlock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_warlock_3", "components/abilities/heroes/hero_warlock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_warlock_9", "components/abilities/heroes/hero_warlock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_warlock_5", "components/abilities/heroes/hero_warlock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_warlock_4", "components/abilities/heroes/hero_warlock", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_warlock_1 = modifier_special_bonus_imba_warlock_1 or class({})
modifier_special_bonus_imba_warlock_3 = modifier_special_bonus_imba_warlock_3 or class({})
modifier_special_bonus_imba_warlock_9 = modifier_special_bonus_imba_warlock_9 or class({})
modifier_special_bonus_imba_warlock_5 = modifier_special_bonus_imba_warlock_5 or class({})
modifier_special_bonus_imba_warlock_4 = modifier_special_bonus_imba_warlock_4 or class({})

function modifier_special_bonus_imba_warlock_1:IsHidden() return true end

function modifier_special_bonus_imba_warlock_1:IsPurgable() return false end

function modifier_special_bonus_imba_warlock_1:RemoveOnDeath() return false end

function modifier_special_bonus_imba_warlock_3:IsHidden() return true end

function modifier_special_bonus_imba_warlock_3:IsPurgable() return false end

function modifier_special_bonus_imba_warlock_3:RemoveOnDeath() return false end

function modifier_special_bonus_imba_warlock_9:IsHidden() return true end

function modifier_special_bonus_imba_warlock_9:IsPurgable() return false end

function modifier_special_bonus_imba_warlock_9:RemoveOnDeath() return false end

function modifier_special_bonus_imba_warlock_5:IsHidden() return true end

function modifier_special_bonus_imba_warlock_5:IsPurgable() return false end

function modifier_special_bonus_imba_warlock_5:RemoveOnDeath() return false end

function modifier_special_bonus_imba_warlock_4:IsHidden() return true end

function modifier_special_bonus_imba_warlock_4:IsPurgable() return false end

function modifier_special_bonus_imba_warlock_4:RemoveOnDeath() return false end

LinkLuaModifier("modifier_special_bonus_imba_warlock_chaotic_offering_magic_resistance", "components/abilities/heroes/hero_warlock", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_warlock_chaotic_offering_magic_resistance = class({})

function modifier_special_bonus_imba_warlock_chaotic_offering_magic_resistance:IsHidden() return true end

function modifier_special_bonus_imba_warlock_chaotic_offering_magic_resistance:IsPurgable() return false end

function modifier_special_bonus_imba_warlock_chaotic_offering_magic_resistance:RemoveOnDeath() return false end

function imba_warlock_rain_of_chaos:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_warlock_chaotic_offering_magic_resistance") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_warlock_chaotic_offering_magic_resistance") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_warlock_chaotic_offering_magic_resistance"), "modifier_special_bonus_imba_warlock_chaotic_offering_magic_resistance", {})
	end
end
