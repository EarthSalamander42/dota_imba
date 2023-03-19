-- Date: 4/5/2020
-- Creator: Shush



----------------
-- Disruption --
----------------

LinkLuaModifier("modifier_imba_disruption_hidden", "components/abilities/heroes/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_disruption_soul_illusion", "components/abilities/heroes/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_disruption_disrupted_reality_debuff", "components/abilities/heroes/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)

imba_shadow_demon_disruption = imba_shadow_demon_disruption or class({})

function imba_shadow_demon_disruption:GetCooldown(level)
	if not self:GetCaster():HasTalent("special_bonus_imba_shadow_demon_disruption_charges") then
		return self.BaseClass.GetCooldown(self, level)
	else
		return 0
	end
end

function imba_shadow_demon_disruption:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = ability:GetCursorTarget()
	local responses_enemy = { "shadow_demon_shadow_demon_ability_disruption_01", "shadow_demon_shadow_demon_ability_disruption_02", "shadow_demon_shadow_demon_ability_disruption_03", "shadow_demon_shadow_demon_ability_disruption_04", "shadow_demon_shadow_demon_ability_disruption_20" }
	local responses_friendly = { "shadow_demon_shadow_demon_ability_disruption_09", "shadow_demon_shadow_demon_ability_disruption_10", "shadow_demon_shadow_demon_ability_disruption_11", "shadow_demon_shadow_demon_ability_disruption_12" }
	local responses_self = { "shadow_demon_shadow_demon_ability_disruption_15", "shadow_demon_shadow_demon_ability_disruption_16", "shadow_demon_shadow_demon_ability_disruption_17", "shadow_demon_shadow_demon_ability_disruption_18", "shadow_demon_shadow_demon_ability_disruption_19" }
	local cast_sound = "Hero_ShadowDemon.Disruption.Cast"
	local modifier_disruption = "modifier_imba_disruption_hidden"

	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= self:GetCaster():GetTeam() then
		if target:TriggerSpellAbsorb(self) then
			return nil
		end
	end

	-- Ability specials
	local disruption_duration = ability:GetSpecialValueFor("disruption_duration")

	-- Play cast sound
	EmitSoundOn(cast_sound, caster)

	-- Play matching response depending on the target
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		EmitSoundOn(responses_enemy[RandomInt(1, #responses_enemy)], caster)
	elseif target == caster then
		EmitSoundOn(responses_self[RandomInt(1, #responses_self)], caster)
	else
		-- Target is an ally
		EmitSoundOn(responses_friendly[RandomInt(1, #responses_friendly)], caster)
	end

	-- Give target the Disruption modifier
	target:AddNewModifier(caster, ability, modifier_disruption, { duration = disruption_duration })
end

-------------------------
-- DISRUPTION MODIFIER --
-------------------------

modifier_imba_disruption_hidden = modifier_imba_disruption_hidden or class({})

function modifier_imba_disruption_hidden:IsHidden() return false end

function modifier_imba_disruption_hidden:IsPurgable() return false end

function modifier_imba_disruption_hidden:IsDebuff()
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return false
	end

	return true
end

function modifier_imba_disruption_hidden:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.responses_enemy_end = { "shadow_demon_shadow_demon_ability_disruption_05", "shadow_demon_shadow_demon_ability_disruption_06", "shadow_demon_shadow_demon_ability_disruption_07", "shadow_demon_shadow_demon_ability_disruption_08" }
	self.responses_friendly_end = { "shadow_demon_shadow_demon_ability_disruption_13", "shadow_demon_shadow_demon_ability_disruption_14" }
	self.disruption_sound = "Hero_ShadowDemon.Disruption"
	self.disruption_end_sound = "Hero_ShadowDemon.Disruption.End"
	self.particle_disruption = "particles/units/heroes/hero_shadow_demon/shadow_demon_disruption.vpcf"
	self.particle_disrupted = "particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_impact.vpcf"
	self.modifier_illusion_soul = "modifier_imba_disruption_soul_illusion"
	self.modifier_shadow_poison = "modifier_shadow_poison_debuff"
	self.modifier_disrupted = "modifier_imba_disruption_disrupted_reality_debuff"

	-- Ability specials
	self.illusion_count = self.ability:GetSpecialValueFor("illusion_count")
	self.illusion_duration = self.ability:GetSpecialValueFor("illusion_duration")
	self.illusion_outgoing_damage = self.ability:GetSpecialValueFor("illusion_outgoing_damage")
	self.illusion_incoming_damage = self.ability:GetSpecialValueFor("illusion_incoming_damage")
	self.disrupted_reality_damage_per_stack = self.ability:GetSpecialValueFor("disrupted_reality_damage_per_stack")
	self.disrupted_reality_interval = self.ability:GetSpecialValueFor("disrupted_reality_interval")
	self.disrupted_reality_duration = self.ability:GetSpecialValueFor("disrupted_reality_duration")

	-- Play disruption sound
	EmitSoundOn(self.disruption_sound, self.parent)

	if IsServer() then
		-- Remove hero drawing
		self.parent:AddNoDraw()

		-- Show particle
		local particle_disruption_fx = ParticleManager:CreateParticle(self.particle_disruption, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle_disruption_fx, 0, self.parent:GetAbsOrigin() + Vector(0, 0, 100))
		ParticleManager:SetParticleControl(particle_disruption_fx, 4, Vector(0, 0, 0))
		self:AddParticle(particle_disruption_fx, false, false, -1, false, false)

		-- Record the target's current health to set on the illusions when they spawn
		self.current_health = self.parent:GetHealth()

		-- Start interval thinker for Disrupted Reality
		self:StartIntervalThink(self.disrupted_reality_interval)
	end
end

function modifier_imba_disruption_hidden:OnIntervalThink()
	if not IsServer() then return end

	local stacks = nil

	-- Check if the target is afflicted with Shadow Poison debuff
	if self.parent:HasModifier(self.modifier_shadow_poison) then
		self.modifier_shadow_poison_handle = self.parent:FindModifierByName(self.modifier_shadow_poison)
		if self.modifier_shadow_poison_handle then
			stacks = self.modifier_shadow_poison_handle:GetStackCount()
		end
	end

	-- If we didn't find anything, then do nothing
	if not stacks then return end

	-- Calculate damage
	local damage = self.disrupted_reality_damage_per_stack * self.disrupted_reality_interval * stacks

	-- Deal damage to the parent
	local damageTable = {
		victim = self.parent,
		attacker = self.caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY,
		ability = self.ability
	}

	ApplyDamage(damageTable)

	-- Little extra smoke effect that comes out when the unit is taking damage
	local particle_disrupted_fx = ParticleManager:CreateParticle(self.particle_disrupted, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle_disrupted_fx, 0, self.parent:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_disrupted_fx)
end

function modifier_imba_disruption_hidden:OnDestroy()
	-- Stop disruption sound
	StopSoundOn(self.disruption_sound, self.parent)

	-- Emit end sound
	EmitSoundOn(self.disruption_end_sound, self.parent)

	if IsServer() then
		-- If target died during Disruption, no illusions are created
		if not self.parent:IsAlive() then
			return
		end

		-- Bring the hero drawing back
		self.parent:RemoveNoDraw()

		-- Create illusions under Shadow Demon's control near the target
		local illusions = CreateIllusions(self.caster, self.parent, {
			outgoing_damage = self.illusion_outgoing_damage,
			incoming_damage = self.illusion_incoming_damage,
			bounty_base     = self:GetCaster():GetIllusionBounty(),
			duration        = self.illusion_duration
		}, self.illusion_count, self.parent:GetHullRadius(), false, true)


		for _, illusion in pairs(illusions) do
			-- Set illusions current health to match what the target had when he was Disrupted
			illusion:SetHealth(self.current_health)

			-- IMBAfication: Soul Illusions: Give each illusion the Soul Illusions buff
			illusion:AddNewModifier(self.caster, self.ability, self.modifier_illusion_soul, { soul_target = self.parent:entindex() })
		end

		-- IMBAfication: Disrupted Reality
		local stacks
		if self.parent:HasModifier(self.modifier_shadow_poison) then
			local modifier_shadow_poison_handle = self.parent:FindModifierByName(self.modifier_shadow_poison)
			if modifier_shadow_poison_handle then
				stacks = modifier_shadow_poison_handle:GetStackCount()

				-- Give enemy the debuff based on the Shadow Poison stacks
				local disrupt_modifier = self.parent:AddNewModifier(self.caster, self.ability, self.modifier_disrupted, { duration = self.disrupted_reality_duration * (1 - self.parent:GetStatusResistance()) })
				if disrupt_modifier then
					disrupt_modifier:SetStackCount(stacks)
				end
			end
		end
	end
end

function modifier_imba_disruption_hidden:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
	return state
end

----------------------------
-- SOUL ILLUSION MODIFIER --
----------------------------

modifier_imba_disruption_soul_illusion = modifier_imba_disruption_soul_illusion or class({})

function modifier_imba_disruption_soul_illusion:IsHidden() return false end

function modifier_imba_disruption_soul_illusion:IsPurgable() return false end

function modifier_imba_disruption_soul_illusion:IsDebuff() return false end

function modifier_imba_disruption_soul_illusion:OnCreated(params)
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.soul_illusion_curr_hp_damage = self.ability:GetSpecialValueFor("soul_illusion_curr_hp_damage")
	self.soul_illusion_curr_hp_target_damage = self.ability:GetSpecialValueFor("soul_illusion_curr_hp_target_damage")

	if not IsServer() then return end

	-- Get the target from the params
	if params.soul_target then
		self.target = EntIndexToHScript(params.soul_target)
		if not self.target or not IsValidEntity(self.target) then
			self.target = nil
		end
	end
end

function modifier_imba_disruption_soul_illusion:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
		MODIFIER_PROPERTY_TOOLTIP }

	return decFuncs
end

function modifier_imba_disruption_soul_illusion:GetModifierProcAttack_BonusDamage_Pure(keys)
	if not IsServer() then return end

	local target = keys.target
	local attacker = keys.attacker

	-- Only apply if the attacker was the illusion
	if self.parent == attacker then
		local bonus_damage

		-- Determine from which target we take the damage, and what percentage do we roll
		if self.target and self.target:IsAlive() then
			-- Illusions are attacking their Soul Linked target
			if self.target == target then
				bonus_damage = self.target:GetHealth() * self.soul_illusion_curr_hp_target_damage / 100
			else
				-- Illusions attack another target using their Soul Linked target's health
				bonus_damage = self.target:GetHealth() * self.soul_illusion_curr_hp_damage / 100
			end
		else
			-- -- Otherwise we use the illusion's health instead, with damage reduction
			-- Decided not to go with this in the end :(
			-- bonus_damage = self.parent:GetHealth() * (self.soul_illusion_curr_hp_damage / 100) * (self.soul_illusion_curr_hp_self_damage_rdc / 100)

			-- Reset bonus damage to 0
			bonus_damage = 0
		end

		return bonus_damage
	end
end

function modifier_imba_disruption_soul_illusion:OnTooltip()
	return self.target:GetHealth() * self.soul_illusion_curr_hp_damage / 100
end

----------------------------------------------------
-- DISRUPTION'S DISRUPTED REALITY DEBUFF MODIFIER --
----------------------------------------------------

modifier_imba_disruption_disrupted_reality_debuff = modifier_imba_disruption_disrupted_reality_debuff or class({})

function modifier_imba_disruption_disrupted_reality_debuff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.disrupted_reality_ms_slow_stack = self.ability:GetSpecialValueFor("disrupted_reality_ms_slow_stack")
	self.disrupted_reality_as_slow_stack = self.ability:GetSpecialValueFor("disrupted_reality_as_slow_stack")
end

function modifier_imba_disruption_disrupted_reality_debuff:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2 }

	return decFuncs
end

function modifier_imba_disruption_disrupted_reality_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.disrupted_reality_ms_slow_stack * self:GetStackCount() * (-1)
end

function modifier_imba_disruption_disrupted_reality_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.disrupted_reality_as_slow_stack * self:GetStackCount() * (-1)
end

function modifier_imba_disruption_disrupted_reality_debuff:OnTooltip()
	return self.disrupted_reality_ms_slow_stack * self:GetStackCount()
end

function modifier_imba_disruption_disrupted_reality_debuff:OnTooltip2()
	return self.disrupted_reality_as_slow_stack * self:GetStackCount()
end

------------------
-- SOUL CATCHER --
------------------
LinkLuaModifier("modifier_imba_soul_catcher_buff", "components/abilities/heroes/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_soul_catcher_debuff", "components/abilities/heroes/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
imba_shadow_demon_soul_catcher = imba_shadow_demon_soul_catcher or class({})

function imba_shadow_demon_soul_catcher:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_shadow_demon_soul_catcher:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_shadow_demon_soul_catcher_cd")
end

function imba_shadow_demon_soul_catcher:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	-- 75% to roll those
	local responses_catch = { "shadow_demon_shadow_demon_ability_soul_catcher_01", "shadow_demon_shadow_demon_ability_soul_catcher_02", "shadow_demon_shadow_demon_ability_soul_catcher_03", "shadow_demon_shadow_demon_ability_soul_catcher_08" }
	local responses_miss = { "shadow_demon_shadow_demon_ability_soul_catcher_04", "shadow_demon_shadow_demon_ability_soul_catcher_05", "shadow_demon_shadow_demon_ability_soul_catcher_06", "shadow_demon_shadow_demon_ability_soul_catcher_07" }
	local cast_sound = "Hero_ShadowDemon.Soul_Catcher.Cast"
	local hit_sound = "Hero_ShadowDemon.Soul_Catcher"
	local modifier_debuff = "modifier_imba_soul_catcher_debuff"
	local modifier_buff = "modifier_imba_soul_catcher_buff"
	local particle_ground = "particles/units/heroes/hero_shadow_demon/shadow_demon_soul_catcher_v2_projected_ground.vpcf"
	local particle_hit = "particles/units/heroes/hero_shadow_demon/shadow_demon_soul_catcher.vpcf"
	local particle_hit_ally = "particles/hero/shadow_demon/shadow_demon_soul_catcher_cast_ally.vpcf"
	local modifier_demonic_purge = "modifier_imba_demonic_purge_debuff"

	-- Ability specials
	local health_lost = ability:GetSpecialValueFor("health_lost")
	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")

	-- Play cast sound
	EmitSoundOn(cast_sound, caster)

	-- Show particle on ground
	local particle_ground_fx = ParticleManager:CreateParticle(particle_ground, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle_ground_fx, 0, target_point)
	ParticleManager:SetParticleControl(particle_ground_fx, 1, target_point)
	ParticleManager:SetParticleControl(particle_ground_fx, 2, target_point)
	ParticleManager:SetParticleControl(particle_ground_fx, 3, Vector(radius, 0, 0))

	Timers:CreateTimer(0.1, function()
		ParticleManager:DestroyParticle(particle_ground_fx, false)
		ParticleManager:ReleaseParticleIndex(particle_ground_fx)
	end)

	-- Find all enemies in range. While technically finds all spell immune enemies, only those with the Demonic Purge debuff are affected
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		target_point,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)

	local total_health_stolen = 0
	-- For each enemy,
	for _, enemy in pairs(enemies) do
		local valid_enemy = true

		-- Enemies can be hit under Disruption
		if enemy:IsInvulnerable() and not enemy:HasModifier("modifier_imba_disruption_hidden") then
			valid_enemy = false
		end

		if not enemy:IsAlive() then
			valid_enemy = false
		end

		-- IMBAfication: Associative Darkness
		if enemy:IsMagicImmune() and not enemy:HasModifier(modifier_demonic_purge) then
			valid_enemy = false
		end

		if valid_enemy then
			-- Play hit sound
			EmitSoundOn(hit_sound, enemy)

			-- Play hit particle
			local particle_hit_fx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(particle_hit_fx, 1, enemy:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_hit_fx, 2, enemy:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_hit_fx, 3, Vector(1, 0, 0))
			ParticleManager:SetParticleControl(particle_hit_fx, 4, enemy:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_hit_fx)

			-- Store how much health will be taken from them, then take that health.
			local health_steal = enemy:GetHealth() * health_lost / 100
			total_health_stolen = total_health_stolen + health_steal

			local damageTable = {
				victim = enemy,
				attacker = caster,
				damage = health_steal,
				damage_type = DAMAGE_TYPE_PURE,
				damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY,
				ability = ability
			}

			ApplyDamage(damageTable)

			-- Give enemies the Soul Catcher modifier debuff
			-- Okay, look, don't kill me. Only way to apply a modiifer on an invulnerable target is through making the enemy give it to themselves, then manually changing the caster
			enemy:AddNewModifier(enemy, ability, modifier_debuff, { duration = duration * (1 - enemy:GetStatusResistance()), health_stolen = health_steal })
		end
	end

	-- Play response based on enemies caught
	if RollPercentage(75) then
		if #enemies > 0 then
			EmitSoundOn(responses_catch[RandomInt(1, #responses_catch)], caster)
		else
			EmitSoundOn(responses_miss[RandomInt(1, #responses_miss)], caster)
		end
	end

	-- If no enemies were found, then we don't need to do anything anymore
	if #enemies <= 0 then return end

	-- Count allies and determine how much health would be distributed evenly between them.
	local allies = FindUnitsInRadius(caster:GetTeamNumber(),
		target_point,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		FIND_ANY_ORDER,
		false)

	-- If not allies were found, then we don't need to do anything anymore
	if #allies <= 0 then return end

	-- Calculate health
	local allied_heal = total_health_stolen / #allies

	for _, ally in pairs(allies) do
		local valid_ally = true

		-- Including those under Shadow Demon's Disruption
		if ally:IsInvulnerable() and not ally:HasModifier("modifier_imba_disruption_hidden") then
			valid_ally = false
		end

		if valid_ally then
			-- Play hit particle
			local particle_hit_ally_fx = ParticleManager:CreateParticle(particle_hit_ally, PATTACH_ABSORIGIN_FOLLOW, ally)
			ParticleManager:SetParticleControl(particle_hit_ally_fx, 1, ally:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_hit_ally_fx, 2, ally:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_hit_ally_fx, 3, Vector(1, 0, 0))
			ParticleManager:SetParticleControl(particle_hit_ally_fx, 4, ally:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_hit_ally_fx)

			-- Give them the Soul Catcher buff modifier and assign the heal amount
			ally:AddNewModifier(caster, ability, modifier_buff, { duration = duration, allied_heal = allied_heal })
		end
	end
end

-----------------------
-- SOUL CATCHER BUFF --
-----------------------

modifier_imba_soul_catcher_buff = modifier_imba_soul_catcher_buff or class({})

function modifier_imba_soul_catcher_buff:IsHidden() return false end

function modifier_imba_soul_catcher_buff:IsPurgable() return true end

function modifier_imba_soul_catcher_buff:IsDebuff() return false end

function modifier_imba_soul_catcher_buff:OnCreated(params)
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_buff = "particles/hero/shadow_demon/shadow_demon_soul_catcher_ally.vpcf"

	-- Ability specials
	self.health_returned_pct = self.ability:GetSpecialValueFor("health_returned_pct")

	if not IsServer() then return end

	-- Add particle effect
	self.particle_buff_fx = ParticleManager:CreateParticle(self.particle_buff, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle_buff_fx, 0, self.parent:GetAbsOrigin())
	self:AddParticle(self.particle_buff_fx, false, false, -1, false, false)

	-- Get heal amount from params
	self.allied_heal = params.allied_heal

	-- This isn't supposed to happen but you may never know
	if not self.allied_heal then
		return
	end

	-- We'll let a frame for the game to include max health increase before healing
	Timers:CreateTimer(FrameTime(), function()
		self.parent:Heal(self.allied_heal, self.caster)
	end)
end

function modifier_imba_soul_catcher_buff:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS }

	return decFuncs
end

function modifier_imba_soul_catcher_buff:GetModifierExtraHealthBonus()
	if self.allied_heal then
		return self.allied_heal
	end

	return 0
end

function modifier_imba_soul_catcher_buff:OnDestroy()
	if not IsServer() then return end

	local health_lost = self.allied_heal * self.health_returned_pct / 100

	-- Only do this if current health would not be shortened because of the max health being lost, otherwise he'll lose both max HP and current HP
	if self.parent:GetMaxHealth() - self.parent:GetHealth() <= health_lost then return end

	-- Take the health gained by this modifier from the parent
	local damageTable = {
		victim = self.parent,
		attacker = self.parent,
		damage = health_lost,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NON_LETHAL,
		ability = self.ability
	}

	ApplyDamage(damageTable)
end

----------------------------------
-- SOUL CATCHER DEBUFF MODIFIER --
----------------------------------

modifier_imba_soul_catcher_debuff = modifier_imba_soul_catcher_debuff or class({})

function modifier_imba_soul_catcher_debuff:IsHidden() return false end

function modifier_imba_soul_catcher_debuff:IsPurgable()
	if self.parent:HasModifier(self.modifier_demonic_purge) then
		return false
	end

	return true
end

function modifier_imba_soul_catcher_debuff:IsDebuff() return true end

function modifier_imba_soul_catcher_debuff:OnCreated(params)
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	-- This needs to be done this way since the caster of the modifier is actually the enemy
	self.caster = self:GetAbility():GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_debuff = "particles/units/heroes/hero_shadow_demon/shadow_demon_soul_catcher_debuff.vpcf"
	self.modifier_demonic_purge = "modifier_imba_demonic_purge_debuff"
	self.shadow_poison_ability = "imba_shadow_demon_shadow_poison"

	-- Ability specials
	self.health_returned_pct = self.ability:GetSpecialValueFor("health_returned_pct")
	self.unleashed_projectile_count = self.ability:GetSpecialValueFor("unleashed_projectile_count")

	if not IsServer() then return end

	-- Add particle effect
	self.particle_debuff_fx = ParticleManager:CreateParticle(self.particle_debuff, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle_debuff_fx, 0, self.parent:GetAbsOrigin())
	self:AddParticle(self.particle_debuff_fx, false, false, -1, false, false)

	-- Get heal amount from params
	self.health_stolen = params.health_stolen
	self.soul_taken = false

	-- IMBAfication: Your Soul is Mine: if target is under Disruption, don't give it its health back
	if self.parent:HasModifier("modifier_imba_disruption_hidden") then
		self.soul_taken = true
	end
end

function modifier_imba_soul_catcher_debuff:DeclareFunctions()
	local decFuncs = { MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_TOOLTIP }

	return decFuncs
end

function modifier_imba_soul_catcher_debuff:OnDeath(keys)
	if not IsServer() then return end

	local unit = keys.unit

	-- Only apply when the parent dies, and only for heroes
	if unit == self.parent and self.parent:IsRealHero() then
		-- Make sure the caster has the Shadow Poison ability, otherwise it shouldn't trigger
		if self.caster:HasAbility(self.shadow_poison_ability) then
			local shadow_poison_ability_handle = self.caster:FindAbilityByName(self.shadow_poison_ability)
			if shadow_poison_ability_handle and shadow_poison_ability_handle:GetLevel() >= 1 then
				-- Set the death point of the parent as the origin point for all Shadow Poison projectiles to be fired
				local origin_point = self.parent:GetAbsOrigin()

				-- The first Shadow Poison will be fired in the way the enemy faced, with every other projectile rotating angle by 360/projectile count
				local direction = self.parent:GetForwardVector()
				local rotation_per_projectile = 360 / self.unleashed_projectile_count
				local new_direction

				for i = 1, self.unleashed_projectile_count do
					angle = QAngle(0, (i - 1) * (rotation_per_projectile), 0)
					new_direction = RotatePosition(origin_point, angle, direction)
					shadow_poison_ability_handle:FireShadowPoisonProjectile(origin_point, new_direction, true)
				end
			end
		end
	end
end

function modifier_imba_soul_catcher_debuff:OnTooltip()
	return self.health_stolen
end

function modifier_imba_soul_catcher_debuff:OnDestroy()
	if not IsServer() then return end

	-- This shouldn't happen but you may never know
	if not self.health_stolen then return end

	-- Only trigger if your soul wasn't taken
	if not self.soul_taken then
		-- Heal the target by the percentage of stolen health
		local health_restore = self.health_stolen * self.health_returned_pct / 100
		self.parent:Heal(health_restore, self.caster)
	end
end

-------------------
-- SHADOW POISON --
-------------------
LinkLuaModifier("modifier_shadow_poison_debuff", "components/abilities/heroes/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
imba_shadow_demon_shadow_poison = imba_shadow_demon_shadow_poison or class({})

function imba_shadow_demon_shadow_poison:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_shadow_demon_shadow_poison_cd")
end

function imba_shadow_demon_shadow_poison:OnUpgrade()
	if self:GetLevel() == 1 and self:GetCaster():HasAbility("imba_shadow_demon_shadow_poison_release") then
		local poison_ability = self:GetCaster():FindAbilityByName("imba_shadow_demon_shadow_poison_release")
		if poison_ability then
			poison_ability:SetLevel(1)
		end
	end
end

function imba_shadow_demon_shadow_poison:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = ability:GetCursorPosition()
	local cast_sound = "Hero_ShadowDemon.ShadowPoison.Cast"

	-- Play cast sound
	EmitSoundOn(cast_sound, caster)

	-- Fire projectile
	ability:FireShadowPoisonProjectile(caster:GetAbsOrigin(), target_point, false)
end

function imba_shadow_demon_shadow_poison:FireShadowPoisonProjectile(origin_point, target_point, grudges)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local projectile_sound = "Hero_ShadowDemon.ShadowPoison"
	local particle_poison = "particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_projectile.vpcf"

	-- Ability specials
	local radius = ability:GetSpecialValueFor("radius")
	local speed = ability:GetSpecialValueFor("speed")

	-- Emit projectile sound
	EmitSoundOnLocationWithCaster(origin_point, projectile_sound, caster)

	-- Calculate direction
	local direction = (target_point - origin_point):Normalized()

	-- Fire shadow wave in the direction
	local shadow_projectile = {
		Ability = ability,
		EffectName = particle_poison,
		vSpawnOrigin = origin_point,
		fDistance = ability:GetCastRange(target_point, nil),
		fStartRadius = radius,
		fEndRadius = radius,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		bDeleteOnHit = false,
		vVelocity = direction * speed * Vector(1, 1, 0),
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bProvidesVision = true,
		iVisionRadius = radius,
		iVisionTeamNumber = caster:GetTeamNumber(),
	}

	local projectileID = ProjectileManager:CreateLinearProjectile(shadow_projectile)
	if not self.shadow_poison_projectileID then
		self.shadow_poison_projectileID = {}
	end

	-- Insert into table for the projectile hit to get the target count
	table.insert(self.shadow_poison_projectileID, projectileID)
	self.shadow_poison_projectileID[projectileID] = { targets = 0, isGrudge = grudges }
end

function imba_shadow_demon_shadow_poison:OnProjectileHitHandle(target, location, projectileID)
	-- If this didn't hit a target, projectile finished traveling. Delete from table and do nothing else
	if not target then
		table.remove(self.shadow_poison_projectileID, projectileID)
		return
	end

	-- If the target is invulnerable, only accept if is has Disruption, otherwise do nothing
	if target:IsInvulnerable() and not target:HasModifier("modifier_imba_disruption_hidden") then return end

	-- If the target is magic immune, only accept if it has Demonic Purge applied on it
	if target:IsMagicImmune() and not target:HasModifier("modifier_imba_demonic_purge_debuff") then return end

	-- If it hit an ally which wasn't a Soul Illusion, do nothing
	if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() and not target:HasModifier("modifier_imba_disruption_soul_illusion") then return end

	-- If we got here, then target is valid: add a target count to the projectile
	if self.shadow_poison_projectileID[projectileID] then
		self.shadow_poison_projectileID[projectileID].targets = self.shadow_poison_projectileID[projectileID].targets + 1
	end

	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local particle_impact = "particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_impact.vpcf"
	local hit_sound = "Hero_ShadowDemon.ShadowPoison.Impact"
	local soul_catcher_ability = "imba_shadow_demon_soul_catcher"
	local modifier_shadow_poison = "modifier_shadow_poison_debuff"
	local modifier_elated_buff = "modifier_imba_demonic_purge_elated_demon_buff"

	-- Ability specials
	local hit_damage = ability:GetSpecialValueFor("hit_damage") * (1 + (caster:FindTalentValue("special_bonus_imba_shadow_demon_shadow_poison_damage") / 100))
	local stack_duration = ability:GetSpecialValueFor("stack_duration")

	-- If needed, get Soul Catcher's ability handle and its Unleashed Grudges definition
	if self.shadow_poison_projectileID[projectileID].isGrudge and caster:HasAbility(soul_catcher_ability) then
		local soul_catcher_ability_handle = caster:FindAbilityByName(soul_catcher_ability)
		if soul_catcher_ability_handle and soul_catcher_ability_handle:GetLevel() >= 1 then
			local unleashed_hit_damage = soul_catcher_ability_handle:GetSpecialValueFor("unleashed_hit_damage")

			if unleashed_hit_damage > 0 then
				-- Purge target
				target:Purge(true, false, false, false, false)

				-- Apply Unleashed Grudges damage
				local damageTable = {
					victim = target,
					attacker = caster,
					damage = unleashed_hit_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = ability
				}

				ApplyDamage(damageTable)
			end
		end
	end

	-- Play hit sound
	EmitSoundOn(hit_sound, target)

	-- Show impact particle
	local particle_impact_fx = ParticleManager:CreateParticle(particle_impact, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_impact_fx, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_impact_fx)

	-- If poison modifier doesn't exist on the target, add the modifier
	if not target:HasModifier(modifier_shadow_poison) then
		-- So I had to do this like this in order to make the shadow poison apply itself during Disruption
		target:AddNewModifier(target, ability, modifier_shadow_poison, { duration = stack_duration * (1 - target:GetStatusResistance()) })
	end

	-- Give poison modifier one stack and refresh it
	-- If Shadow Demon has the Elated Demon buff, add its stacks as well
	local additional_stacks = 0
	if caster:HasModifier(modifier_elated_buff) and self.shadow_poison_projectileID[projectileID].targets == 1 then
		local modifier_elated_buff_handle = caster:FindModifierByName(modifier_elated_buff)
		if modifier_elated_buff_handle then
			additional_stacks = modifier_elated_buff_handle:GetStackCount()
		end
	end

	local total_stacks = 1 + additional_stacks

	local modifier_shadow_poison_handle = target:FindModifierByName(modifier_shadow_poison)
	if modifier_shadow_poison_handle then
		for i = 1, total_stacks do
			modifier_shadow_poison_handle:IncrementStackCount()
			modifier_shadow_poison_handle:ForceRefresh()
		end
	end

	-- Apply damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = hit_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability
	}

	ApplyDamage(damageTable)
end

-----------------------------------
-- SHADOW POISON DEBUFF MODIFIER --
-----------------------------------

modifier_shadow_poison_debuff = modifier_shadow_poison_debuff or class({})

function modifier_shadow_poison_debuff:IsHidden() return false end

function modifier_shadow_poison_debuff:IsPurgable()
	if self.parent:HasModifier(self.modifier_demonic_purge) then
		return false
	end

	return true
end

function modifier_shadow_poison_debuff:IsDebuff() return true end

function modifier_shadow_poison_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetAbility():GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.impact_sound = "Hero_ShadowDemon.ShadowPoison.Impact"
	self.particle_ui = "particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_stackui.vpcf"                                                                                                                                                                                             --cp0 location, cp1 vector(second digit, first digit, 0)"
	self.particle_4stacks = "particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_4stack.vpcf"                                                                                                                                                                                         --cp0 location
	self.particle_kill = "particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_kill.vpcf"                                                                                                                                                                                              --cp0 location, cp2 location, cp3 Vector(1,0,0)
	self.particle_illusion_blast = "particles/hero/shadow_demon/shadow_demon_shadow_poison_soul_illusion_blast.vpcf"                                                                                                                                                                                  --cp0 location
	self.kill_responses = { "shadow_demon_shadow_demon_ability_shadow_poison_05", "shadow_demon_shadow_demon_ability_shadow_poison_06", "shadow_demon_shadow_demon_ability_shadow_poison_08", "shadow_demon_shadow_demon_ability_shadow_poison_09", "shadow_demon_shadow_demon_ability_shadow_poison_10" } --20% chance
	self.modifier_demonic_purge = "modifier_imba_demonic_purge_debuff"

	-- Ability specials
	self.stack_damage = self.ability:GetSpecialValueFor("stack_damage") * (1 + (self.caster:FindTalentValue("special_bonus_imba_shadow_demon_shadow_poison_damage") / 100))
	self.max_multiply_stacks = self.ability:GetSpecialValueFor("max_multiply_stacks")
	self.efficient_multiplier = self.ability:GetSpecialValueFor("efficient_multiplier")
	self.linked_pain_dmg_spread_pct = self.ability:GetSpecialValueFor("linked_pain_dmg_spread_pct")
	self.linked_pain_radius = self.ability:GetSpecialValueFor("linked_pain_radius")
	self.efficient_upwards_limit = self.ability:GetSpecialValueFor("efficient_upwards_limit")

	-- Create the UI particle so it can be controlled later
	self.particle_ui_fx = ParticleManager:CreateParticle(self.particle_ui, PATTACH_OVERHEAD_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle_ui_fx, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_ui_fx, 1, Vector(0, 1, 0))
	self:AddParticle(self.particle_ui_fx, true, false, -1, false, true)
end

function modifier_shadow_poison_debuff:OnStackCountChanged()
	-- This can only go upwards in terms of stacks
	-- When a stack increases, change the UI particle accordingly
	local stacks = self:GetStackCount()
	local first_digit = stacks % 10
	local second_digit = 0 -- default
	if stacks >= 10 then
		second_digit = 1 -- This is the highest second digit supported by this particle UI
	end

	-- Since the highest number suppsoed by the UI is 19, anything above it should just show 19 instead
	if stacks > 19 then
		first_digit = 9
	end

	-- Update UI particle
	ParticleManager:SetParticleControl(self.particle_ui_fx, 1, Vector(second_digit, first_digit, 0))

	-- If stack count reaches 4 stacks, activate the 4 stack particle on the parent
	if stacks >= 4 and not self.particle_4stacks_fx then
		self.particle_4stacks_fx = ParticleManager:CreateParticle(self.particle_4stacks, PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.particle_4stacks_fx, 0, self.parent:GetAbsOrigin())
		self:AddParticle(self.particle_4stacks_fx, true, false, -1, false, false)
	end
end

function modifier_shadow_poison_debuff:CalculateShadowPoisonDamage()
	-- Calculate the multiplier
	local stacks = self:GetStackCount()
	local multiplier = 2

	-- If this was manually triggered, then we should have the highest_stack variable
	if self.highest_stack then
		if stacks < (self.highest_stack - self.efficient_upwards_limit) then
			stacks = stacks + self.efficient_upwards_limit
		else
			stacks = self.highest_stack
		end
	end

	-- If we only need to calculate 2x multiplier
	if stacks <= self.max_multiply_stacks then
		multiplier = multiplier ^ (stacks - 1)
	else
		-- Otherwise we need to calculate both vanilla multiplier and the imbafication multiplier
		multiplier = (multiplier ^ (self.max_multiply_stacks - 1)) * self.efficient_multiplier ^ (stacks - self.max_multiply_stacks)
	end

	local damage = self.stack_damage * multiplier
	return damage
end

function modifier_shadow_poison_debuff:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_TOOLTIP }

	return decFuncs
end

function modifier_shadow_poison_debuff:OnTooltip()
	return self:CalculateShadowPoisonDamage()
end

function modifier_shadow_poison_debuff:OnDestroy()
	if not IsServer() then return end

	-- Play damage particles
	self.particle_kill_fx = ParticleManager:CreateParticle(self.particle_kill, PATTACH_ABSORIGIN, self.parent)
	ParticleManager:SetParticleControlEnt(self.particle_kill_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.particle_kill_fx, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.particle_kill_fx, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(1, 0, 0), true)
	ParticleManager:ReleaseParticleIndex(self.particle_kill_fx)

	-- If the parent is an enemy that died, we don't need to deal damage to it, so we only do this if it is alive
	-- Also determine if it's a regular enemy or a Soul Illusion (Linked Pain imbafication)
	if not self.parent:IsIllusion() and self.parent:IsAlive() then
		-- Play impact sound
		EmitSoundOn(self.impact_sound, self.caster)

		-- Calculate damage and deal it
		damage = self:CalculateShadowPoisonDamage()
		local damageTable = {
			victim = self.parent,
			attacker = self.caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self.ability
		}

		ApplyDamage(damageTable)

		-- Show overhead message
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self.parent, damage, nil)

		-- If the enemy died from this damage,
		if not self.parent:IsAlive() then
			if RollPercentage(20) then
				EmitSoundOn(self.kill_responses[RandomInt(1, #self.kill_responses)], self.caster)
			end
		end
	elseif self.parent:HasModifier("modifier_imba_disruption_soul_illusion") then
		-- Play impact sound
		EmitSoundOn(self.impact_sound, self.caster)

		-- IMBAfication: If this is a Soul Illusion, deal lower damage to surrounding enemy units. Linked target gets full damage
		-- Get linked target
		local linked_target
		local soul_illusion_handle = self.parent:FindModifierByName("modifier_imba_disruption_soul_illusion")
		if soul_illusion_handle and soul_illusion_handle.target then
			linked_target = soul_illusion_handle.target
		end

		-- Play explosion particle
		local particle_illusion_blast_fx = ParticleManager:CreateParticle(self.particle_illusion_blast, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle_illusion_blast_fx, 0, self.parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_illusion_blast_fx)

		-- Calculate damage to enemies
		local damage = self:CalculateShadowPoisonDamage()

		-- Find all enemies nearby
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
			self.parent:GetAbsOrigin(),
			nil,
			self.linked_pain_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
			FIND_ANY_ORDER,
			false)

		local enemy_killed = false
		for _, enemy in pairs(enemies) do
			local valid_enemy = true

			-- If enemy is magic immune or dead, do nothing
			if not enemy:IsAlive() or enemy:IsMagicImmune() then
				valid_enemy = false
			end

			-- If enemy is a courier, do nothing
			if enemy:IsCourier() then
				valid_enemy = false
			end

			-- If enemy is invulnerable but not due to Disruption, do nothing
			if enemy:IsInvulnerable() and not enemy:HasModifier("modifier_imba_disruption_hidden") then
				valid_enemy = false
			end

			if valid_enemy then
				-- Anyone who isn't a linked target of the illusion takes lower damage, linked damage takes full damage
				local actual_damage = damage
				if enemy ~= linked_target then
					actual_damage = damage * self.linked_pain_dmg_spread_pct / 100
				end

				local damageTable = {
					victim = enemy,
					attacker = self.parent,
					damage = actual_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self.ability
				}

				ApplyDamage(damageTable)

				-- Show overhead message
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damage, nil)

				-- If an enemy died from this damage, tag it for kill responses
				if not enemy:IsAlive() then
					enemy_killed = true
				end
			end
		end

		if enemy_killed then
			-- If the enemy died from this damage,
			if not self.parent:IsAlive() then
				if RollPercentage(20) then
					EmitSoundOn(self.kill_responses[RandomInt(1, #self.kill_responses)], self.caster)
				end
			end
		end
	end
end

---------------------------
-- SHADOW POISON RELEASE --
---------------------------

imba_shadow_demon_shadow_poison_release = imba_shadow_demon_shadow_poison_release or class({})

function imba_shadow_demon_shadow_poison_release:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_cast = "Hero_ShadowDemon.ShadowPoison.Release"
	local ability_shadow_poison = "imba_shadow_demon_shadow_poison"
	local modifier_poison = "modifier_shadow_poison_debuff"

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Find all enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		FIND_UNITS_EVERYWHERE,    --global
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)

	-- Create table of enemies that actually do have shadow poison debuff
	local debuffed_enemies = {}
	local highest_stack = 0
	local modifier_poison_handle
	local stacks

	-- Iterate; Get the highest stack of each of them of the shadow poison debuff
	for _, enemy in pairs(enemies) do
		if enemy:HasModifier(modifier_poison) then
			modifier_poison_handle = enemy:FindModifierByName(modifier_poison)
			if modifier_poison_handle then
				table.insert(debuffed_enemies, enemy)
				stacks = modifier_poison_handle:GetStackCount()
				if stacks > highest_stack then
					highest_stack = stacks
				end
			end
		end
	end

	-- Iterate actual debuffed enemies while taking the higher stack into account
	for _, enemy in pairs(debuffed_enemies) do
		modifier_poison_handle = enemy:FindModifierByName(modifier_poison)
		if modifier_poison_handle then
			modifier_poison_handle.highest_stack = highest_stack
			modifier_poison_handle:Destroy()
		end
	end

	-- Find Soul Illusions that have Shadow Poison and trigger them
	local illusions = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		FIND_UNITS_EVERYWHERE,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_DAMAGE_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	for _, illusion in pairs(illusions) do
		if illusion:IsIllusion() and illusion:HasModifier("modifier_imba_disruption_soul_illusion") and illusion:HasModifier(modifier_poison) then
			local modifier_poison_handle = illusion:FindModifierByName(modifier_poison)
			if modifier_poison_handle then
				modifier_poison_handle:Destroy()
			end
		end
	end
end

-------------------
-- DEMONIC PURGE --
-------------------
LinkLuaModifier("modifier_imba_demonic_purge_debuff", "components/abilities/heroes/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_demonic_purge_slow_freeze", "components/abilities/heroes/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_demonic_purge_elated_demon_buff", "components/abilities/heroes/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_charges", "components/modifiers/generic/modifier_generic_charges", LUA_MODIFIER_MOTION_NONE)

imba_shadow_demon_demonic_purge = imba_shadow_demon_demonic_purge or class({})

function imba_shadow_demon_demonic_purge:RequiresScepterForCharges() return true end

function imba_shadow_demon_demonic_purge:GetCooldown(level)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCooldown(self, level)
	else
		return 0
	end
end

function imba_shadow_demon_demonic_purge:OnInventoryContentsChanged(keys)
	-- Caster got scepter
	if self:GetCaster():HasScepter() then
		-- Check if there is a charges modifier
		if not self:GetCaster():HasModifier("modifier_generic_charges") then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_charges", {})
		else
			-- However, if there is, check its ability; if it's not this ability, still give the modifier
			local modifiers = self:GetCaster():FindAllModifiersByName("modifier_generic_charges")

			-- Try to find a modifier with the same ability instance as this
			local found_modifier = false
			for _, modifier in pairs(modifiers) do
				if modifier:GetAbility() and modifier:GetAbility() == self then
					found_modifier = true
					break
				end
			end

			-- If we didn't find it, add a modifier
			if not found_modifier then
				self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_charges", {})
			end
		end
	end
end

function imba_shadow_demon_demonic_purge:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = ability:GetCursorTarget()
	local cast_sound = "Hero_ShadowDemon.DemonicPurge.Cast"
	local cast_responses = { "shadow_demon_shadow_demon_ability_demonic_purge_01", "shadow_demon_shadow_demon_ability_demonic_purge_02", "shadow_demon_shadow_demon_ability_demonic_purge_03", "shadow_demon_shadow_demon_ability_demonic_purge_04", "shadow_demon_shadow_demon_ability_demonic_purge_05", "shadow_demon_shadow_demon_ability_demonic_purge_06", "shadow_demon_shadow_demon_ability_demonic_purge_07", "shadow_demon_shadow_demon_ability_demonic_purge_08", "shadow_demon_shadow_demon_ability_demonic_purge_09" }
	local particle_cast = "particles/units/heroes/hero_shadow_demon/shadow_demon_demonic_purge_cast.vpcf" -- cp0 location
	local modifier_debuff = "modifier_imba_demonic_purge_debuff"
	local modifier_elated_buff = "modifier_imba_demonic_purge_elated_demon_buff"

	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= self:GetCaster():GetTeam() then
		if target:TriggerSpellAbsorb(self) then
			return nil
		end
	end

	-- Ability specials
	local purge_duration = ability:GetSpecialValueFor("purge_duration")
	local elated_demon_duration = ability:GetSpecialValueFor("elated_demon_duration")
	--	local painful_purge_damage = ability:GetSpecialValueFor("painful_purge_damage")

	-- Emit cast sound
	EmitSoundOn(cast_sound, caster)

	-- Play cast response
	if RollPercentage(75) then
		EmitSoundOn(cast_responses[RandomInt(1, #cast_responses)], caster)
	end

	-- Play hit particle
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)

	--[[
	-- Dispel target + IMBAFication: Painful Purge. Only deals damage per purged buff
	local modifiers = target:FindAllModifiers()
	local total_damage = 0
	for _, modifier in pairs(modifiers) do
		-- Find eligible buffs that can be purged, increment damage for each buff purged this way
		if modifier and not modifier:IsDebuff() and modifier.isPurgable and modifier:IsPurgable() then
			total_damage = total_damage + painful_purge_damage
		end
	end

	-- Deal damage to the target
	local damageTable = {victim = target,
						attacker = caster,
						damage = total_damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						damage_flags = DOTA_DAMAGE_FLAG_NONE,
						ability = ability}

	ApplyDamage(damageTable)
--]]
	target:Purge(true, false, false, false, false)

	-- Give it the Demonic Purge debuff
	target:AddNewModifier(caster, ability, modifier_debuff, { duration = purge_duration * (1 - target:GetStatusResistance()) })

	-- Give the caster the Elated Demon buff and add a stack (or just add a stack)
	-- Durations are independent and should be controlled by the modifier
	if not caster:HasModifier(modifier_elated_buff) then
		caster:AddNewModifier(caster, ability, modifier_elated_buff, { duration = elated_demon_duration })
	end

	local modifier_elated_buff_handle = caster:FindModifierByName(modifier_elated_buff)
	if modifier_elated_buff_handle then
		modifier_elated_buff_handle:IncrementStackCount()
	end
end

-----------------------------------
-- DEMONIC PURGE DEBUFF MODIFIER --
-----------------------------------

modifier_imba_demonic_purge_debuff = modifier_imba_demonic_purge_debuff or class({})

function modifier_imba_demonic_purge_debuff:IsDebuff() return true end

function modifier_imba_demonic_purge_debuff:IsHidden() return false end

function modifier_imba_demonic_purge_debuff:IsPurgable() return false end

function modifier_imba_demonic_purge_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_demonic_purge_debuff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.impact_sound = "Hero_ShadowDemon.DemonicPurge.Impact"
	self.damage_sound = "Hero_ShadowDemon.DemonicPurge.Damage"
	self.particle_modifier = "particles/hero/shadow_demon/shadow_demon_demonic_purge.vpcf" -- cp0 location, cp1 location, cp3 direction forward vector of caster, cp4 location
	self.particle_break = "particles/generic_gameplay/generic_break.vpcf"               --cp location
	self.modifier_slow_freeze = "modifier_imba_demonic_purge_slow_freeze"
	self.modifier_poison = "modifier_shadow_poison_debuff"
	self.modifier_soul_catcher = "modifier_imba_soul_catcher_debuff"

	-- Ability specials
	self.purge_damage = self.ability:GetSpecialValueFor("purge_damage") + self.caster:FindTalentValue("special_bonus_imba_shadow_demon_demonic_purge_damage")
	self.max_slow = self.ability:GetSpecialValueFor("max_slow")
	self.min_slow = self.ability:GetSpecialValueFor("min_slow")
	--	self.painful_purge_damage = self.ability:GetSpecialValueFor("painful_purge_damage")
	self.painful_slow_reset_duration = self.ability:GetSpecialValueFor("painful_slow_reset_duration")
	self.purge_interval = self.ability:GetSpecialValueFor("purge_interval")

	-- Play impact sound
	EmitSoundOn(self.impact_sound, self.parent)

	-- Create particles on the target. Need its direction for cp3
	local direction = (self.parent:GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized()
	self.particle_modifier_fx = ParticleManager:CreateParticle(self.particle_modifier, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle_modifier_fx, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_modifier_fx, 1, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_modifier_fx, 3, direction)
	ParticleManager:SetParticleControl(self.particle_modifier_fx, 4, self.parent:GetAbsOrigin())
	self:AddParticle(self.particle_modifier_fx, false, false, -1, false, false)

	-- If caster has scepter, apply Break particle
	if self.caster:HasScepter() then
		self.particle_break_fx = ParticleManager:CreateParticle(self.particle_break, PATTACH_OVERHEAD_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.particle_break_fx, 0, self.parent:GetAbsOrigin())
		self:AddParticle(self.particle_break_fx, false, false, -1, false, true)
	end

	-- Calculate slow diminish rate
	self:CalculateSlowDiminishRate()

	-- For clients
	self.needs_slow_recalculate = false

	-- Start thinking
	self:StartIntervalThink(self.purge_interval)
end

function modifier_imba_demonic_purge_debuff:CalculateSlowDiminishRate()
	self.slow_diminish_rate = (self.max_slow - self.min_slow) / self:GetRemainingTime()
	self.slow = self.max_slow
	self.rate_tick = true
end

function modifier_imba_demonic_purge_debuff:OnIntervalThink()
	-- Slow value handling in case of a slow freeze
	if self.parent:HasModifier(self.modifier_slow_freeze) then
		self.rate_tick = false
		self.slow = self.max_slow
		self.needs_slow_recalculate = true
	elseif self.needs_slow_recalculate then
		self.needs_slow_recalculate = false
		self:CalculateSlowDiminishRate()
	end

	-- Tick slow rate down if rate is set
	if self.rate_tick then
		self.slow = self.slow - self.slow_diminish_rate * self.purge_interval
	end

	if IsServer() then
		-- Deal damage to the target if it has buffs to purge
		-- Find dispellable buffs and deal damage according to them (IMBAFication: Painful Purgation)

		--[[
		local modifiers = self.parent:FindAllModifiers()
		local total_damage = 0
		for _, modifier in pairs(modifiers) do
			-- Find eligible buffs that can be purged, increment damage for each buff purged this way
			if modifier and not modifier:IsDebuff() and modifier.IsPurgable and modifier:IsPurgable() then
				total_damage = total_damage + self.painful_purge_damage
			end
		end

		if total_damage > 0 then
			local damageTable = {victim = self.parent,
								attacker = self.caster,
								damage = total_damage,
								damage_type = DAMAGE_TYPE_MAGICAL,
								damage_flags = DOTA_DAMAGE_FLAG_NONE,
								ability = self.ability}

			-- Pierces invulnerablity if it is invulnerable and affected by Disruption
			if self.parent:IsInvulnerable() and self.parent:HasModifier("modifier_imba_disruption_hidden") then
				damageTable.damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY
			end

			ApplyDamage(damageTable)

			-- Add dummy modifier that handles timing of the slow
			self.parent:AddNewModifier(self.caster, self.ability, self.modifier_slow_freeze, {duration = self.painful_slow_reset_duration})
		end
--]]
		-- Purge parent
		self.parent:Purge(true, false, false, false, false)

		-- IMBAfication: Associative Darkness - Find Shadow Poison and Soul Catcher debuffs and pause them
		-- Shadow Poison modifier handling
		if not self.modifier_shadow_poison_handle then
			if self.parent:HasModifier(self.modifier_poison) then
				self.modifier_shadow_poison_handle = self.parent:FindModifierByName(self.modifier_poison)
			end
		end

		if self.modifier_shadow_poison_handle and self.modifier_shadow_poison_handle:GetRemainingTime() > 0 then
			self.modifier_shadow_poison_handle:SetDuration(self.modifier_shadow_poison_handle:GetDuration() + self.purge_interval, true)
		end

		-- Soul Catcher modifier handling
		if not self.modifier_soul_catcher_handle then
			if self.parent:HasModifier(self.modifier_soul_catcher) then
				self.modifier_soul_catcher_handle = self.parent:FindModifierByName(self.modifier_soul_catcher)
			end
		end

		if self.modifier_soul_catcher_handle and self.modifier_soul_catcher_handle:GetRemainingTime() > 0 then
			self.modifier_soul_catcher_handle:SetDuration(self.modifier_soul_catcher_handle:GetDuration() + self.purge_interval, true)
		end
	end
end

function modifier_imba_demonic_purge_debuff:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }

	return decFuncs
end

function modifier_imba_demonic_purge_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow * (-1)
end

function modifier_imba_demonic_purge_debuff:CheckState()
	if self.caster:HasScepter() then
		return { [MODIFIER_STATE_PASSIVES_DISABLED] = true }
	end
end

function modifier_imba_demonic_purge_debuff:OnDestroy()
	if not IsServer() then return end

	-- Deal damage to parent
	local damageTable = {
		victim = self.parent,
		attacker = self.caster,
		damage = self.purge_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		ability = self.ability
	}

	-- Pierces invulnerablity if it is invulnerable and affected by Disruption
	if self.parent:IsInvulnerable() and self.parent:HasModifier("modifier_imba_disruption_hidden") then
		damageTable.damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY
	end

	ApplyDamage(damageTable)
end

------------------------------------------------
-- DEMONIC PURGE DEBUFF SLOW STOPPER MODIFIER --
------------------------------------------------

modifier_imba_demonic_purge_slow_freeze = modifier_imba_demonic_purge_slow_freeze or class({})

function modifier_imba_demonic_purge_slow_freeze:IsHidden() return true end

function modifier_imba_demonic_purge_slow_freeze:IsPurgable() return false end

function modifier_imba_demonic_purge_slow_freeze:IsDebuff() return true end

----------------------------------------------
-- DEMONIC PURGE ELATED DEMON BUFF MODIFIER --
----------------------------------------------

modifier_imba_demonic_purge_elated_demon_buff = modifier_imba_demonic_purge_elated_demon_buff or class({})

function modifier_imba_demonic_purge_elated_demon_buff:IsHidden() return false end

function modifier_imba_demonic_purge_elated_demon_buff:IsPurgable() return true end

function modifier_imba_demonic_purge_elated_demon_buff:IsDebuff() return false end

function modifier_imba_demonic_purge_elated_demon_buff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.elated_demon_duration = self.ability:GetSpecialValueFor("elated_demon_duration")

	-- Initialize stacks table
	self.stack_table = {}

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(1)
	end
end

function modifier_imba_demonic_purge_elated_demon_buff:OnStackCountChanged(prev_stacks)
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

function modifier_imba_demonic_purge_elated_demon_buff:OnIntervalThink()
	local repeat_needed = true

	-- We''ll repeat the table removal check and remove as many expired items from it as needed.
	while repeat_needed do
		-- Check if the firstmost entry in the table has expired
		local item_time = self.stack_table[1]

		-- If the difference between times is longer, it's time to get rid of a stack
		if GameRules:GetGameTime() - item_time >= self.elated_demon_duration then
			-- Check if there is only one stack, which would mean bye bye debuff
			if self:GetStackCount() == 1 then
				self:Destroy()
				break
			else
				-- Remove the entry from the table
				table.remove(self.stack_table, 1)

				-- Decrement a stack
				self:DecrementStackCount()
			end
		else
			-- If no more items need to be removed, no need to repeat the table
			repeat_needed = false
		end
	end
end

function modifier_imba_demonic_purge_elated_demon_buff:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_TOOLTIP }

	return decFuncs
end

function modifier_imba_demonic_purge_elated_demon_buff:OnTooltip()
	return self:GetStackCount()
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_shadow_demon_shadow_poison_damage", "components/abilities/heroes/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_shadow_demon_shadow_poison_cd", "components/abilities/heroes/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_shadow_demon_soul_catcher_cd", "components/abilities/heroes/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_shadow_demon_demonic_purge_damage", "components/abilities/heroes/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_shadow_demon_disruption_charges", "components/abilities/heroes/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_shadow_demon_shadow_poison_damage = modifier_special_bonus_imba_shadow_demon_shadow_poison_damage or class({})
modifier_special_bonus_imba_shadow_demon_shadow_poison_cd = modifier_special_bonus_imba_shadow_demon_shadow_poison_cd or class({})
modifier_special_bonus_imba_shadow_demon_soul_catcher_cd = modifier_special_bonus_imba_shadow_demon_soul_catcher_cd or class({})
modifier_special_bonus_imba_shadow_demon_demonic_purge_damage = modifier_special_bonus_imba_shadow_demon_demonic_purge_damage or class({})
modifier_special_bonus_imba_shadow_demon_disruption_charges = modifier_special_bonus_imba_shadow_demon_disruption_charges or class({})

function modifier_special_bonus_imba_shadow_demon_shadow_poison_damage:IsHidden() return true end

function modifier_special_bonus_imba_shadow_demon_shadow_poison_damage:IsPurgable() return false end

function modifier_special_bonus_imba_shadow_demon_shadow_poison_damage:RemoveOnDeath() return false end

function modifier_special_bonus_imba_shadow_demon_shadow_poison_cd:IsHidden() return true end

function modifier_special_bonus_imba_shadow_demon_shadow_poison_cd:IsPurgable() return false end

function modifier_special_bonus_imba_shadow_demon_shadow_poison_cd:RemoveOnDeath() return false end

function modifier_special_bonus_imba_shadow_demon_soul_catcher_cd:IsHidden() return true end

function modifier_special_bonus_imba_shadow_demon_soul_catcher_cd:IsPurgable() return false end

function modifier_special_bonus_imba_shadow_demon_soul_catcher_cd:RemoveOnDeath() return false end

function modifier_special_bonus_imba_shadow_demon_demonic_purge_damage:IsHidden() return true end

function modifier_special_bonus_imba_shadow_demon_demonic_purge_damage:IsPurgable() return false end

function modifier_special_bonus_imba_shadow_demon_demonic_purge_damage:RemoveOnDeath() return false end

function modifier_special_bonus_imba_shadow_demon_disruption_charges:IsHidden() return true end

function modifier_special_bonus_imba_shadow_demon_disruption_charges:IsPurgable() return false end

function modifier_special_bonus_imba_shadow_demon_disruption_charges:RemoveOnDeath() return false end

function imba_shadow_demon_shadow_poison:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_shadow_demon_shadow_poison_damage") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_shadow_demon_shadow_poison_damage") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_shadow_demon_shadow_poison_damage"), "modifier_special_bonus_imba_shadow_demon_shadow_poison_damage", {})
	end
end

function imba_shadow_demon_shadow_poison:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_shadow_demon_shadow_poison_cd") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_shadow_demon_shadow_poison_cd") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_shadow_demon_shadow_poison_cd"), "modifier_special_bonus_imba_shadow_demon_shadow_poison_cd", {})
	end
end

function imba_shadow_demon_soul_catcher:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_shadow_demon_soul_catcher_cd") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_shadow_demon_soul_catcher_cd") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_shadow_demon_soul_catcher_cd"), "modifier_special_bonus_imba_shadow_demon_soul_catcher_cd", {})
	end
end

function imba_shadow_demon_demonic_purge:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_shadow_demon_demonic_purge_damage") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_shadow_demon_demonic_purge_damage") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_shadow_demon_demonic_purge_damage"), "modifier_special_bonus_imba_shadow_demon_demonic_purge_damage", {})
	end
end

function imba_shadow_demon_disruption:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_shadow_demon_disruption_charges") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_shadow_demon_disruption_charges") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_shadow_demon_disruption_charges"), "modifier_special_bonus_imba_shadow_demon_disruption_charges", {})
	end
end

function modifier_special_bonus_imba_shadow_demon_disruption_charges:OnCreated()
	if not IsServer() then return end
	local disruption_ability_handle = self:GetCaster():FindAbilityByName("imba_shadow_demon_disruption")

	if not self:GetCaster():HasModifier("modifier_generic_charges") and self:GetCaster():HasAbility("imba_shadow_demon_disruption") then
		if disruption_ability_handle then
			self:GetCaster():AddNewModifier(self:GetCaster(), disruption_ability_handle, "modifier_generic_charges", {})
		end
	else
		-- Has the charge modifier, but might be another ability's, so check if that should be added
		local modifier_charge_handler = self:GetCaster():FindModifierByName("modifier_generic_charges")
		if modifier_charge_handler and disruption_ability_handle and modifier_charge_handler:GetAbility() and modifier_charge_handler:GetAbility() ~= disruption_ability_handle then
			self:GetCaster():AddNewModifier(self:GetCaster(), disruption_ability_handle, "modifier_generic_charges", {})
		end
	end
end
