-- Creator:
--     EarthSalamander #42, 03.12.2017

-- Editors:
--	   AltiV, 07.08.2018

local function FindNearestPointFromLine(caster, dir, affected)
	local castertoaffected = affected - caster
	local len = castertoaffected:Dot(dir)
	local ntgt = Vector(dir.x * len, dir.y * len, caster.z)
	return caster + ntgt
end

-- Echo Stomp
imba_elder_titan_echo_stomp = class({})

function imba_elder_titan_echo_stomp:GetAbilityTextureName()
	return "imba_elder_titan_echo_stomp"
end

function imba_elder_titan_echo_stomp:IsHiddenWhenStolen()
	return false
end

function imba_elder_titan_echo_stomp:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target)
end

function imba_elder_titan_echo_stomp:GetBehavior()
	if self:GetCaster():HasTalent("special_bonus_imba_elder_titan_7") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED
	end
end

function imba_elder_titan_echo_stomp:GetCastPoint()
	if self:GetCaster():HasTalent("special_bonus_imba_elder_titan_7") then
		return self:GetSpecialValueFor("cast_time")
	else
		return self.BaseClass.GetCastPoint(self)
	end
end

function imba_elder_titan_echo_stomp:GetChannelTime()
	if self:GetCaster():HasTalent("special_bonus_imba_elder_titan_7") then
		return false
	else
		return self:GetSpecialValueFor("cast_time")
	end
end

function imba_elder_titan_echo_stomp:OnAbilityPhaseStart()
	-- if self:GetCaster():HasScepter() then
	-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_elder_titan_magic_immune", {duration = self:GetChannelTime()})
	-- end

	if astral_spirit and not astral_spirit:IsNull() and astral_spirit:FindAbilityByName("imba_elder_titan_echo_stomp_spirit") then
		Timers:CreateTimer(0.03, function()
			astral_spirit:CastAbilityNoTarget(astral_spirit:FindAbilityByName("imba_elder_titan_echo_stomp_spirit"), astral_spirit:GetPlayerOwnerID())
		end)
	else
		self.combined_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_cast_combined.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	end

	EmitSoundOn("Hero_ElderTitan.EchoStomp.Channel", self:GetCaster())

	return true
end

-- -- There is no ability phase right now...
-- function imba_elder_titan_echo_stomp:OnAbilityPhaseInterrupted()
-- if astral_spirit then
-- astral_spirit:Interrupt()
-- end

-- StopSoundOn("Hero_ElderTitan.EchoStomp.Channel", self:GetCaster())
-- end

function imba_elder_titan_echo_stomp:OnSpellStart()
	-- Echo Stomp no longer channeling talent logic only
	if not self:GetCaster():HasTalent("special_bonus_imba_elder_titan_7") then return end

	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self

		-- Ability specials
		local radius = ability:GetSpecialValueFor("radius")
		local stun_duration = ability:GetSpecialValueFor("sleep_duration")
		local stomp_damage = ability:GetSpecialValueFor("stomp_damage")

		-- Play cast sound
		EmitSoundOn("Hero_ElderTitan.EchoStomp", caster)

		-- Find all nearby enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

		for _, enemy in pairs(enemies) do
			-- Deal damage to nearby non-magic immune enemies
			if not enemy:IsMagicImmune() then
				local damageTable = { victim = enemy, attacker = caster, damage = stomp_damage, damage_type = ability:GetAbilityDamageType(), ability = ability }

				ApplyDamage(damageTable)

				-- Stun them
				enemy:AddNewModifier(caster, ability, "modifier_stunned", { duration = stun_duration * (1 - enemy:GetStatusResistance()) })
			end
		end
	end
end

function imba_elder_titan_echo_stomp:OnChannelFinish(interrupted)
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_imba_elder_titan_magic_immune") then
			self:GetCaster():RemoveModifierByName("modifier_imba_elder_titan_magic_immune")
		end

		if self.combined_particle then
			ParticleManager:DestroyParticle(self.combined_particle, true)
			ParticleManager:ReleaseParticleIndex(self.combined_particle)
		end

		if interrupted then
			if astral_spirit and not astral_spirit:IsNull() and not astral_spirit.is_returning then
				astral_spirit:Interrupt()
			end
			-- -- Vanilla doesn't stop the sound...
			-- StopSoundOn("Hero_ElderTitan.EchoStomp.Channel", self:GetCaster())
		else
			-- Ability properties
			local caster = self:GetCaster()
			local ability = self

			-- Ability specials
			local radius = ability:GetSpecialValueFor("radius")
			local stun_duration = ability:GetSpecialValueFor("sleep_duration")
			local stomp_damage = ability:GetSpecialValueFor("stomp_damage")

			-- Play cast sound
			EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7", caster)
			EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7_layer", caster)

			-- Add stomp particle
			local particle_stomp_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(particle_stomp_fx, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_stomp_fx, 1, Vector(radius, 1, 1))
			ParticleManager:SetParticleControl(particle_stomp_fx, 2, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_stomp_fx)

			local magical_particle = nil

			if astral_spirit and not astral_spirit:IsNull() then
				magical_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_magical.vpcf", PATTACH_ABSORIGIN, astral_spirit)
				ParticleManager:SetParticleControl(magical_particle, 2, astral_spirit:GetAbsOrigin())
			else
				magical_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_magical.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(magical_particle, 2, caster:GetAbsOrigin())
			end

			ParticleManager:SetParticleControl(magical_particle, 1, Vector(radius, 1, 1))
			ParticleManager:ReleaseParticleIndex(magical_particle)

			-- Find all nearby enemies
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

			-- Establish variable counting how many heroes were hit for scepter magic immunity duration
			local heroes_hit = 0

			for _, enemy in pairs(enemies) do
				-- Deal damage to nearby non-magic immune enemies
				if not enemy:IsMagicImmune() then
					ApplyDamage({
						victim = enemy,
						attacker = caster,
						damage = stomp_damage,
						damage_type = ability:GetAbilityDamageType(),
						ability = ability
					})

					if not astral_spirit or astral_spirit:IsNull() then
						ApplyDamage({
							victim = enemy,
							attacker = caster,
							damage = stomp_damage,
							damage_type = DAMAGE_TYPE_MAGICAL,
							ability = ability
						})
					end

					-- Stun them
					enemy:AddNewModifier(caster, ability, "modifier_stunned", { duration = stun_duration * (1 - enemy:GetStatusResistance()) })

					if enemy:IsRealHero() then
						heroes_hit = heroes_hit + 1
					end
				end
			end

			-- if self:GetCaster():HasScepter() then
			-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_elder_titan_magic_immune", {duration = heroes_hit * 2})
			-- end
		end
	end
end

--------------------------------------------
-- MODIFIER_IMBA_ELDER_TITAN_MAGIC_IMMUNE --
--------------------------------------------

LinkLuaModifier("modifier_imba_elder_titan_magic_immune", "components/abilities/heroes/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)

modifier_imba_elder_titan_magic_immune = class({})

-- IDK what the texture name is called
-- function modifier_imba_elder_titan_magic_immune:GetTexture()
-- return "spell_immunity"
-- end

function modifier_imba_elder_titan_magic_immune:GetEffectName()
	return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_imba_elder_titan_magic_immune:CheckState()
	return { [MODIFIER_STATE_MAGIC_IMMUNE] = true }
end

-- Astral Spirit
imba_elder_titan_ancestral_spirit = class({})
LinkLuaModifier("modifier_imba_elder_titan_ancestral_spirit_self", "components/abilities/heroes/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_elder_titan_ancestral_spirit_damage", "components/abilities/heroes/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_elder_titan_ancestral_spirit_ms", "components/abilities/heroes/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_elder_titan_ancestral_spirit_armor", "components/abilities/heroes/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)

---------------------------------------
-- IMBA_ELDER_TITAN_ANCESTRAL_SPIRIT --
---------------------------------------

function imba_elder_titan_ancestral_spirit:GetAbilityTextureName()
	return "elder_titan_ancestral_spirit"
end

function imba_elder_titan_ancestral_spirit:GetAssociatedSecondaryAbilities()
	return "imba_elder_titan_return_spirit"
end

function imba_elder_titan_ancestral_spirit:GetCastRange(location, target)
	if self:GetCaster():HasTalent("special_bonus_imba_elder_titan_1") then
		return self:GetCaster():FindTalentValue("special_bonus_imba_elder_titan_1")
	else
		return self.BaseClass.GetCastRange(self, location, target)
	end
end

-- function imba_elder_titan_ancestral_spirit:OnAbilityPhaseStart()
-- StartAnimation(self:GetCaster(), {duration=self.BaseClass.GetCastPoint(self), activity=ACT_DOTA_ANCESTRAL_SPIRIT, rate=1.0})

-- return true
-- end

-- function imba_elder_titan_ancestral_spirit:OnAbilityPhaseInterrupted()
-- EndAnimation(self:GetCaster())
-- return true
-- end

function imba_elder_titan_ancestral_spirit:IsNetherWardStealable() return false end

function imba_elder_titan_ancestral_spirit:OnSpellStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("spirit_duration")
	local spirit_movespeed = self:GetTalentSpecialValueFor("speed")

	EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Cast", caster)
	caster:SwapAbilities("imba_elder_titan_ancestral_spirit", "imba_elder_titan_return_spirit", false, true)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_cast.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, target_point)
	ParticleManager:ReleaseParticleIndex(particle)

	astral_spirit = CreateUnitByName("npc_dota_elder_titan_ancestral_spirit", target_point, true, caster, caster, caster:GetTeamNumber())
	astral_spirit:SetControllableByPlayer(caster:GetPlayerID(), true)
	astral_spirit:AddNewModifier(astral_spirit, self, "modifier_imba_elder_titan_ancestral_spirit_self", {})
	--astral_spirit:AddNewModifier(astral_spirit, nil, "modifier_imba_haste_rune_speed_limit_break", {})
	astral_spirit.basemovespeed = spirit_movespeed

	if not astral_spirit:IsNull() then
		if caster:FindAbilityByName("imba_elder_titan_echo_stomp") ~= nil then
			astral_spirit:FindAbilityByName("imba_elder_titan_echo_stomp_spirit"):SetLevel(caster:FindAbilityByName("imba_elder_titan_echo_stomp"):GetLevel())
		end

		if caster:FindAbilityByName("imba_elder_titan_return_spirit") ~= nil then
			astral_spirit:FindAbilityByName("imba_elder_titan_return_spirit"):SetHidden(false)
			astral_spirit:FindAbilityByName("imba_elder_titan_return_spirit"):SetLevel(caster:FindAbilityByName("imba_elder_titan_return_spirit"):GetLevel())
		end

		if caster:FindAbilityByName("imba_elder_titan_natural_order") ~= nil then
			astral_spirit:FindAbilityByName("imba_elder_titan_natural_order"):SetLevel(caster:FindAbilityByName("imba_elder_titan_natural_order"):GetLevel())
		end
	end
end

-----------------------------------------------------
-- MODIFIER_IMBA_ELDER_TITAN_ANCESTRAL_SPIRIT_SELF --
-----------------------------------------------------

modifier_imba_elder_titan_ancestral_spirit_self = modifier_imba_elder_titan_ancestral_spirit_self or class({})

-- Modifier properties
function modifier_imba_elder_titan_ancestral_spirit_self:IsHidden() return true end

function modifier_imba_elder_titan_ancestral_spirit_self:IsPurgable() return false end

function modifier_imba_elder_titan_ancestral_spirit_self:GetEffectName()
	return "particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_ambient.vpcf"
end

function modifier_imba_elder_titan_ancestral_spirit_self:OnCreated()
	self.return_timer = 0.0
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.duration = self:GetAbility():GetSpecialValueFor("spirit_duration")
	self.buff_duration = self:GetAbility():GetSpecialValueFor("buff_duration")
	self.pass_damage = self:GetAbility():GetSpecialValueFor("pass_damage")
	self.damage_heroes = self:GetAbility():GetSpecialValueFor("damage_heroes")
	self.damage_creeps = self:GetAbility():GetSpecialValueFor("damage_creeps")
	self.speed_heroes = self:GetAbility():GetSpecialValueFor("move_pct_heroes")
	self.speed_creeps = self:GetAbility():GetSpecialValueFor("move_pct_creeps")
	self.armor_creeps = self:GetAbility():GetSpecialValueFor("armor_creeps")
	self.armor_heroes = self:GetAbility():GetSpecialValueFor("armor_heroes")
	self.scepter_magic_immune_per_hero = self:GetAbility():GetSpecialValueFor("scepter_magic_immune_per_hero")

	self.bonus_damage = 0
	self.bonus_ms = 0
	self.bonus_armor = 0

	self.targets_hit = {}

	if IsServer() then
		self.real_hero_counter = 0

		EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Spawn", self:GetParent())
		self:StartIntervalThink(0.1)

		Timers:CreateTimer(FrameTime(), function()
			self:GetParent():SetBaseMoveSpeed(self:GetParent().basemovespeed)
		end)
	end
end

function modifier_imba_elder_titan_ancestral_spirit_self:OnIntervalThink()
	-- Stupid exception for if the hero is changed / deleted while the Astral Spirit is up; remove it
	if self:GetAbility() == nil then
		self:GetParent():RemoveSelf()
	end

	-- "Astral Spirit roots targets hit" talent; root duration variable
	local duration = self:GetAbility():GetCaster():FindTalentValue("special_bonus_imba_elder_titan_3")

	-- Constantly check for nearby enemies to see if they haven't been hit by Astral Spirit yet
	local nearby_enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, enemy in pairs(nearby_enemies) do
		-- Check if this enemy was already hit
		local enemy_has_been_hit = false

		for _, enemy_hit in pairs(self.targets_hit) do
			if enemy == enemy_hit then
				enemy_has_been_hit = true
				break
			end
		end

		-- If not, blast it
		if not enemy_has_been_hit then
			-- Play hit particle
			local hit_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_touch.vpcf", PATTACH_CUSTOMORIGIN, enemy)
			ParticleManager:SetParticleControl(hit_pfx, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControlEnt(hit_pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)

			ParticleManager:ReleaseParticleIndex(hit_pfx)

			EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Buff", enemy)
			ApplyDamage({ attacker = self:GetParent(), victim = enemy, ability = self:GetAbility(), damage = self.pass_damage, damage_type = DAMAGE_TYPE_MAGICAL })

			-- "Astral Spirit roots targets hit" talent
			if self:GetParent():GetOwner():HasTalent("special_bonus_imba_elder_titan_3") then
				enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_rooted", { duration = duration * (1 - enemy:GetStatusResistance()) })

				local root_fx = ParticleManager:CreateParticle("particles/units/heroes/heroes_underlord/abyssal_underlord_pitofmalice_stun.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:SetParticleControl(root_fx, 0, enemy:GetAbsOrigin())

				Timers:CreateTimer(duration, function()
					ParticleManager:DestroyParticle(root_fx, true)
					ParticleManager:ReleaseParticleIndex(root_fx)
				end)
			end

			-- Apply slow modifier
			--			self:GetAbility():ApplyDataDrivenModifier(self:GetCaster(), enemy, modifier_slow, {})
			--			enemy:SetModifierStackCount(modifier_slow, self:GetCaster(), slow_initial_stacks)

			-- Add enemy to the targets hit table
			self.targets_hit[#self.targets_hit + 1] = enemy
			if enemy:IsRealHero() then
				self.bonus_damage      = self.bonus_damage + self.damage_heroes
				self.bonus_ms          = self.bonus_ms + self.speed_heroes
				self.bonus_armor       = self.bonus_armor + self.armor_heroes

				self.real_hero_counter = self.real_hero_counter + 1
			else
				self.bonus_damage = self.bonus_damage + self.damage_creeps
				self.bonus_ms     = self.bonus_ms + self.speed_creeps
				self.bonus_armor  = self.bonus_armor + self.armor_creeps
			end
		end
	end

	-- If Elder Titan is killed while the Astral Spirit is out, immediately swap the ability back and destroy the spirit
	if not self:GetParent():GetOwner():IsAlive() then
		self:GetParent():GetOwner():SwapAbilities("imba_elder_titan_ancestral_spirit", "imba_elder_titan_return_spirit", true, false)
		self:GetParent():RemoveSelf()
		astral_spirit = nil
		return nil
	end

	if not self.et_ab then self.et_ab = self:GetParent():FindAbilityByName("imba_elder_titan_echo_stomp_spirit") end
	if not self.owner_echo_stomp_ability then self.owner_echo_stomp_ability = self:GetParent():GetOwner():FindAbilityByName("imba_elder_titan_echo_stomp") end

	if self.et_ab and self.return_timer > self.duration and not self.et_ab:IsInAbilityPhase() and not self:GetParent().is_returning then
		self:GetParent():MoveToNPC(self:GetParent():GetOwner())
		self:GetParent().is_returning = true
		self:GetParent():FindModifierByName("modifier_imba_elder_titan_ancestral_spirit_self"):SetStackCount(1)
		-- StartAnimation(self:GetParent(), {duration=30.0, activity=ACT_DOTA_FLAIL, rate=0.1})
		EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Return", self:GetParent())
	end

	if self:GetParent().is_returning and (not self.owner_echo_stomp_ability or (not self.owner_echo_stomp_ability:IsInAbilityPhase() and not self.owner_echo_stomp_ability:IsChanneling())) then
		self:GetParent():MoveToNPC(self:GetParent():GetOwner())
	end

	if self.return_timer - 10.0 > self.duration or
		(self:GetParent().is_returning == true and (self:GetParent():GetOwner():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length() < 180) then
		self:GetParent():GetOwner():SwapAbilities("imba_elder_titan_ancestral_spirit", "imba_elder_titan_return_spirit", true, false)

		if self.bonus_damage > 0 then
			local damage_mod = self:GetParent():GetOwner():AddNewModifier(self:GetParent():GetOwner(), self:GetAbility(), "modifier_imba_elder_titan_ancestral_spirit_damage", { duration = self.buff_duration })
			damage_mod:SetStackCount(self.bonus_damage)
		end

		if self.bonus_ms > 0 then
			local speed_mod = self:GetParent():GetOwner():AddNewModifier(self:GetParent():GetOwner(), self:GetAbility(), "modifier_imba_elder_titan_ancestral_spirit_ms", { duration = self.buff_duration })
			speed_mod:SetStackCount(self.bonus_ms)
		end

		if self.bonus_armor > 0 then
			local armor_mod = self:GetParent():GetOwner():AddNewModifier(self:GetParent():GetOwner(), self:GetAbility(), "modifier_imba_elder_titan_ancestral_spirit_armor", { duration = self.buff_duration })
			armor_mod:SetStackCount(self.bonus_armor * 10)
		end

		if self:GetParent():GetOwner():HasScepter() then
			self:GetParent():GetOwner():AddNewModifier(self:GetParent():GetOwner(), self:GetAbility(), "modifier_imba_elder_titan_magic_immune", { duration = self.real_hero_counter * self.scepter_magic_immune_per_hero })
		end

		self:GetParent():RemoveSelf()
		astral_spirit = nil
		return nil
	end

	self.return_timer = self.return_timer + 0.1
end

function modifier_imba_elder_titan_ancestral_spirit_self:CheckState()
	if IsServer() then
		local state = {}

		state = {
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_FLYING] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_COMMAND_RESTRICTED] = false
		}

		if self:GetStackCount() == 1 then
			state = {
				[MODIFIER_STATE_UNSELECTABLE] = true,
				[MODIFIER_STATE_NO_HEALTH_BAR] = true,
				[MODIFIER_STATE_FLYING] = true,
				[MODIFIER_STATE_INVULNERABLE] = true,
				[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
				[MODIFIER_STATE_COMMAND_RESTRICTED] = true
			}
		end
		return state
	end
end

function modifier_imba_elder_titan_ancestral_spirit_self:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,

		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
end

function modifier_imba_elder_titan_ancestral_spirit_self:GetModifierMoveSpeed_AbsoluteMin(keys)
	return self:GetParent().basemovespeed
end

function modifier_imba_elder_titan_ancestral_spirit_self:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_imba_elder_titan_ancestral_spirit_self:GetOverrideAnimation()
	if self:GetStackCount() == 1 then
		return ACT_DOTA_FLAIL
	end
end

function modifier_imba_elder_titan_ancestral_spirit_self:GetOverrideAnimationRate()
	if self:GetStackCount() == 1 then
		return 0.2
	end
end

-- On the edge case where Juggernaut's Omnislash jumps to the Astral Spirit and kills it...give Elder Titan back the skill immediately
function modifier_imba_elder_titan_ancestral_spirit_self:OnDestroy(keys)
	if self:GetParent().GetOwner then
		self:GetParent():GetOwner():SwapAbilities("imba_elder_titan_ancestral_spirit", "imba_elder_titan_return_spirit", true, false)
	end
end

-------------------------------------------------------
-- MODIFIER_IMBA_ELDER_TITAN_ANCESTRAL_SPIRIT_DAMAGE --
-------------------------------------------------------

modifier_imba_elder_titan_ancestral_spirit_damage = modifier_imba_elder_titan_ancestral_spirit_damage or class({})

-- Modifier properties
function modifier_imba_elder_titan_ancestral_spirit_damage:IsDebuff() return false end

function modifier_imba_elder_titan_ancestral_spirit_damage:IsHidden() return false end

function modifier_imba_elder_titan_ancestral_spirit_damage:IsPurgable() return false end

function modifier_imba_elder_titan_ancestral_spirit_damage:GetEffectName()
	return "particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_buff.vpcf"
end

function modifier_imba_elder_titan_ancestral_spirit_damage:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return decFuncs
end

function modifier_imba_elder_titan_ancestral_spirit_damage:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end

---------------------------------------------------
-- MODIFIER_IMBA_ELDER_TITAN_ANCESTRAL_SPIRIT_MS --
---------------------------------------------------

modifier_imba_elder_titan_ancestral_spirit_ms = modifier_imba_elder_titan_ancestral_spirit_ms or class({})

-- Modifier properties
function modifier_imba_elder_titan_ancestral_spirit_ms:IsDebuff() return false end

function modifier_imba_elder_titan_ancestral_spirit_ms:IsHidden() return false end

function modifier_imba_elder_titan_ancestral_spirit_ms:IsPurgable() return false end

function modifier_imba_elder_titan_ancestral_spirit_ms:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return decFuncs
end

function modifier_imba_elder_titan_ancestral_spirit_ms:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

------------------------------------------------------
-- MODIFIER_IMBA_ELDER_TITAN_ANCESTRAL_SPIRIT_ARMOR --
------------------------------------------------------

modifier_imba_elder_titan_ancestral_spirit_armor = class({})

function modifier_imba_elder_titan_ancestral_spirit_armor:IsPurgable() return false end

function modifier_imba_elder_titan_ancestral_spirit_armor:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return decFuncs
end

function modifier_imba_elder_titan_ancestral_spirit_armor:GetModifierPhysicalArmorBonus()
	return self:GetStackCount() * 0.1
end

------------------------------------
-- IMBA_ELDER_TITAN_RETURN_SPIRIT --
------------------------------------

-- Return Spirit
imba_elder_titan_return_spirit = class({})

function imba_elder_titan_return_spirit:GetAbilityTextureName()
	return "elder_titan_return_spirit"
end

function imba_elder_titan_return_spirit:IsInnateAbility()
	return true
end

function imba_elder_titan_return_spirit:IsStealable() return false end

function imba_elder_titan_return_spirit:IsHiddenWhenStolen() return true end

function imba_elder_titan_return_spirit:IsNetherWardStealable() return false end

function imba_elder_titan_return_spirit:ProcsMagicStick() return false end

function imba_elder_titan_return_spirit:GetAssociatedPrimaryAbilities()
	return "imba_elder_titan_ancestral_spirit"
end

function imba_elder_titan_return_spirit:OnSpellStart()
	if astral_spirit and not astral_spirit.is_returning then
		astral_spirit:MoveToNPC(astral_spirit:GetOwner())
		astral_spirit.is_returning = true
		astral_spirit:FindModifierByName("modifier_imba_elder_titan_ancestral_spirit_self"):SetStackCount(1)
		-- StartAnimation(astral_spirit, {duration=30.0, activity=ACT_DOTA_FLAIL, rate=0.1})
		EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Return", astral_spirit)
	end
end

------------------------------------
-- IMBA_ELDER_TITAN_NATURAL_ORDER --
------------------------------------

-- Natural Order
imba_elder_titan_natural_order = imba_elder_titan_natural_order or class({})
LinkLuaModifier("modifier_imba_elder_titan_natural_order_aura", "components/abilities/heroes/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_elder_titan_natural_order", "components/abilities/heroes/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)

function imba_elder_titan_natural_order:GetAbilityTextureName()
	if self:GetCaster():GetUnitName() == "npc_dota_elder_titan_ancestral_spirit" then
		return "elder_titan_natural_order_spirit"
	end

	return "elder_titan_natural_order"
end

function imba_elder_titan_natural_order:GetIntrinsicModifierName()
	return "modifier_imba_elder_titan_natural_order_aura"
end

modifier_imba_elder_titan_natural_order_aura = modifier_imba_elder_titan_natural_order_aura or class({})

-- Modifier properties
function modifier_imba_elder_titan_natural_order_aura:IsAura() return true end

function modifier_imba_elder_titan_natural_order_aura:IsAuraActiveOnDeath() return false end

function modifier_imba_elder_titan_natural_order_aura:IsDebuff() return false end

function modifier_imba_elder_titan_natural_order_aura:IsHidden() return true end

function modifier_imba_elder_titan_natural_order_aura:RemoveOnDeath() return false end

function modifier_imba_elder_titan_natural_order_aura:IsPurgable() return false end

function modifier_imba_elder_titan_natural_order_aura:OnCreated()
	self.natural_order_radius = self:GetAbility():GetSpecialValueFor("radius")
end

-- Aura properties
function modifier_imba_elder_titan_natural_order_aura:GetAuraRadius()
	return self.natural_order_radius
end

function modifier_imba_elder_titan_natural_order_aura:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_imba_elder_titan_natural_order_aura:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_imba_elder_titan_natural_order_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_imba_elder_titan_natural_order_aura:GetModifierAura()
	return "modifier_imba_elder_titan_natural_order"
end

function modifier_imba_elder_titan_natural_order_aura:GetAuraDuration()
	return 1
end

modifier_imba_elder_titan_natural_order = modifier_imba_elder_titan_natural_order or class({})

-- Modifier properties
function modifier_imba_elder_titan_natural_order:IsDebuff() return true end

function modifier_imba_elder_titan_natural_order:IsHidden() return false end

function modifier_imba_elder_titan_natural_order:IsPurgable() return false end

-- function modifier_imba_elder_titan_natural_order:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end -- WTF do NOT make these stack

function modifier_imba_elder_titan_natural_order:GetEffectName()
	return "particles/units/heroes/hero_elder_titan/elder_titan_natural_order_physical.vpcf"
	-- particles/units/heroes/hero_elder_titan/elder_titan_natural_order_magical.vpcf
end

function modifier_imba_elder_titan_natural_order:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.base_armor_reduction = self:GetAbility():GetSpecialValueFor("armor_reduction_pct")
	self.magic_resist_reduction = self:GetAbility():GetSpecialValueFor("magic_resistance_pct")
	self.status_resistance_pct = self:GetAbility():GetSpecialValueFor("status_resistance_pct")
end

function modifier_imba_elder_titan_natural_order:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
end

function modifier_imba_elder_titan_natural_order:GetModifierPhysicalArmorBonus()
	return self.base_armor_reduction / 100 * self:GetParent():GetPhysicalArmorBaseValue()
end

function modifier_imba_elder_titan_natural_order:GetModifierMagicalResistanceBonus()
	return self.magic_resist_reduction / 100 * self:GetParent():GetBaseMagicalResistanceValue()
end

function modifier_imba_elder_titan_natural_order:GetModifierBaseAttack_BonusDamage()
	if self:GetCaster() ~= nil and self:GetCaster():HasTalent("special_bonus_imba_elder_titan_4") then
		if self:GetCaster():GetName() == "npc_dota_elder_titan_ancestral_spirit" then -- This line doesn't pick up the Ancestral Spirit
			return self:GetCaster():GetOwner():FindTalentValue("special_bonus_imba_elder_titan_4") * (-1)
		else
			return self:GetCaster():FindTalentValue("special_bonus_imba_elder_titan_4") * (-1)
		end
	else
		return 0
	end
end

function modifier_imba_elder_titan_natural_order:GetModifierStatusResistanceStacking()
	-- if self:GetCaster() ~= nil and self:GetCaster():HasTalent("special_bonus_imba_elder_titan_5") then
	-- if self:GetCaster():GetUnitName() == "npc_dota_elder_titan_ancestral_spirit" then -- This line doesn't pick up the Ancestral Spirit
	-- return self:GetCaster():GetOwner():FindTalentValue("special_bonus_imba_elder_titan_5") * (-1)
	-- else
	-- return self:GetCaster():FindTalentValue("special_bonus_imba_elder_titan_5") * (-1)
	-- end
	-- else
	-- return 0
	-- end

	return self.status_resistance_pct * (-1)
end

---------------
--	SPIRIT	--
---------------

imba_elder_titan_echo_stomp_spirit = class({})

function imba_elder_titan_echo_stomp_spirit:GetAbilityTextureName()
	return "imba_elder_titan_echo_stomp"
end

function imba_elder_titan_echo_stomp_spirit:GetPlaybackRateOverride()
	-- 1.7 is the standard channel speed for that animation
	return 1.7 / self:GetSpecialValueFor("cast_time")
end

function imba_elder_titan_echo_stomp_spirit:IsHiddenWhenStolen()
	return false
end

-- The subtraction of FrameTimes somewhat helps syncing up when trying to immediately cast Echo Stomp after Astral Spirit spawning
function imba_elder_titan_echo_stomp_spirit:GetCastPoint()
	return self.BaseClass.GetCastPoint(self) - (FrameTime())
end

function imba_elder_titan_echo_stomp_spirit:GetCastRange(location, target)
	local caster = self:GetCaster()
	local base_range = self.BaseClass.GetCastRange(self, location, target)

	return base_range
end

function imba_elder_titan_echo_stomp_spirit:OnAbilityPhaseStart()
	if self:GetCaster():GetOwner() then
		local ab = self:GetCaster():GetOwner():FindAbilityByName("imba_elder_titan_echo_stomp")
		if self:GetCaster():GetOwner():HasTalent("special_bonus_imba_elder_titan_7") then
			if ab:IsInAbilityPhase() == false then
				self:GetCaster():GetOwner():CastAbilityNoTarget(ab, self:GetCaster():GetOwner():GetPlayerID())
			end
		else
			if self:GetCaster():GetOwner():IsChanneling() == false then
				self:GetCaster():GetOwner():CastAbilityNoTarget(ab, self:GetCaster():GetOwner():GetPlayerID())
			end
		end
	end

	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_1)

	EmitSoundOn("Hero_ElderTitan.EchoStomp.Channel.ti7_layer", self:GetCaster())

	return true
end

function imba_elder_titan_echo_stomp_spirit:OnAbilityPhaseInterrupted()
	self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_1)
end

function imba_elder_titan_echo_stomp_spirit:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		-- if caster.is_returning == true then return end
		local ability = self

		-- Ability specials
		local radius = ability:GetSpecialValueFor("radius")
		local stun_duration = ability:GetSpecialValueFor("sleep_duration")
		local stomp_damage = ability:GetSpecialValueFor("stomp_damage")

		-- Play cast sound
		EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7", caster)
		EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7_layer", caster)

		-- Add stomp particle
		local particle_stomp_fx = ParticleManager:CreateParticle("particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_stomp_fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_stomp_fx, 1, Vector(radius, 1, 1))
		ParticleManager:SetParticleControl(particle_stomp_fx, 2, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_stomp_fx)

		-- Find all nearby enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

		for _, enemy in pairs(enemies) do
			-- Deal damage to nearby non-magic immune enemies
			if not enemy:IsMagicImmune() then
				local damageTable = { victim = enemy, attacker = caster, damage = stomp_damage, damage_type = ability:GetAbilityDamageType(), ability = ability }

				ApplyDamage(damageTable)

				-- Stun them
				enemy:AddNewModifier(caster, ability, "modifier_stunned", { duration = stun_duration * (1 - enemy:GetStatusResistance()) })
			end
		end

		self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_1)
	end
end

-----------------------------
--    Earth Splitter     --
-----------------------------
imba_elder_titan_earth_splitter = class({})
LinkLuaModifier("modifier_imba_earth_splitter", "components/abilities/heroes/hero_elder_titan.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_earth_splitter_scepter", "components/abilities/heroes/hero_elder_titan.lua", LUA_MODIFIER_MOTION_NONE)

function imba_elder_titan_earth_splitter:GetAbilityTextureName()
	return "elder_titan_earth_splitter"
end

function imba_elder_titan_earth_splitter:IsHiddenWhenStolen()
	return false
end

function imba_elder_titan_earth_splitter:IsNetherWardStealable()
	return false
end

function imba_elder_titan_earth_splitter:GetCastRange(location, target)
	if self:GetCaster():HasTalent("special_bonus_imba_elder_titan_6") then
		return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():FindTalentValue("special_bonus_imba_elder_titan_6")
	else
		return self.BaseClass.GetCastRange(self, location, target)
	end
end

function imba_elder_titan_earth_splitter:GetCooldown(level)
	if self:GetCaster():HasTalent("special_bonus_imba_elder_titan_9") then
		return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_elder_titan_9")
	else
		return self.BaseClass.GetCooldown(self, level)
	end
end

function imba_elder_titan_earth_splitter:OnSpellStart()
	if not IsServer() then return end

	-- Ability properties
	local caster = self:GetCaster()
	local caster_position = caster:GetAbsOrigin()
	local target_point = self:GetCursorPosition()
	local playerID = caster:GetPlayerID()
	local scepter = caster:HasScepter()

	-- Ability specials
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local slow_duration = self:GetSpecialValueFor("slow_duration")
	if scepter then
		slow_duration = self:GetSpecialValueFor("slow_duration_scepter")
	end
	local bonus_hp_per_str = self:GetSpecialValueFor("bonus_hp_per_str")
	local effect_delay = self:GetSpecialValueFor("crack_time")
	local crack_width = self:GetSpecialValueFor("crack_width")
	local crack_distance = self:GetSpecialValueFor("crack_distance")
	if caster:HasTalent("special_bonus_imba_elder_titan_6") then
		crack_distance = self:GetSpecialValueFor("crack_distance") + caster:FindTalentValue("special_bonus_imba_elder_titan_6")
	end
	local crack_damage = self:GetSpecialValueFor("damage_pct") / 2
	local caster_fw = caster:GetForwardVector()
	local crack_ending = caster_position + caster_fw * crack_distance

	-- Play cast sound
	EmitSoundOn("Hero_ElderTitan.EarthSplitter.Cast", caster)

	-- Add start particle effect
	local particle_start_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle_start_fx, 0, caster_position)
	ParticleManager:SetParticleControl(particle_start_fx, 1, crack_ending)
	ParticleManager:SetParticleControl(particle_start_fx, 3, Vector(0, effect_delay, 0))

	-- Destroy trees in the radius
	GridNav:DestroyTreesAroundPoint(target_point, radius, false)

	-- Wait for the effect delay
	Timers:CreateTimer(effect_delay, function()
		EmitSoundOn("Hero_ElderTitan.EarthSplitter.Destroy", caster)

		local enemies = FindUnitsInLine(caster:GetTeamNumber(), caster_position, crack_ending, nil, crack_width, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags())
		for _, enemy in pairs(enemies) do
			enemy:Interrupt()
			enemy:AddNewModifier(caster, self, "modifier_imba_earth_splitter", { duration = slow_duration * (1 - enemy:GetStatusResistance()) })
			if caster:HasScepter() then
				enemy:AddNewModifier(caster, self, "modifier_imba_earth_splitter_scepter", { duration = slow_duration * (1 - enemy:GetStatusResistance()) })
			end
			ApplyDamage({ victim = enemy, attacker = caster, damage = enemy:GetMaxHealth() * crack_damage / 100, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self })
			ApplyDamage({ victim = enemy, attacker = caster, damage = enemy:GetMaxHealth() * crack_damage / 100, damage_type = DAMAGE_TYPE_MAGICAL, ability = self })
			local closest_point = FindNearestPointFromLine(caster_position, caster_fw, enemy:GetAbsOrigin())
			FindClearSpaceForUnit(enemy, closest_point, false)
		end

		ParticleManager:ReleaseParticleIndex(particle_start_fx)
	end)
end

-- Earth Splitter modifier
modifier_imba_earth_splitter = class({})

function modifier_imba_earth_splitter:IsHidden() return false end

function modifier_imba_earth_splitter:IsPurgable() return true end

function modifier_imba_earth_splitter:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return decFuncs
end

function modifier_imba_earth_splitter:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true
	}
	return state
end

function modifier_imba_earth_splitter:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow_pct")
end

-- Earth Splitter Scepter modifier
modifier_imba_earth_splitter_scepter = class({})

function modifier_imba_earth_splitter_scepter:IsHidden() return false end

function modifier_imba_earth_splitter_scepter:IsPurgable() return true end

function modifier_imba_earth_splitter_scepter:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_elder_titan_1", "components/abilities/heroes/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_elder_titan_2", "components/abilities/heroes/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_elder_titan_4", "components/abilities/heroes/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_elder_titan_5", "components/abilities/heroes/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_elder_titan_6", "components/abilities/heroes/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_elder_titan_9", "components/abilities/heroes/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_elder_titan_1 = class({})
modifier_special_bonus_imba_elder_titan_2 = class({})
modifier_special_bonus_imba_elder_titan_4 = class({})
modifier_special_bonus_imba_elder_titan_5 = class({})
modifier_special_bonus_imba_elder_titan_6 = class({})
modifier_special_bonus_imba_elder_titan_9 = class({})

function modifier_special_bonus_imba_elder_titan_1:IsHidden() return true end

function modifier_special_bonus_imba_elder_titan_1:IsPurgable() return false end

function modifier_special_bonus_imba_elder_titan_1:RemoveOnDeath() return false end

function modifier_special_bonus_imba_elder_titan_2:IsHidden() return true end

function modifier_special_bonus_imba_elder_titan_2:IsPurgable() return false end

function modifier_special_bonus_imba_elder_titan_2:RemoveOnDeath() return false end

function modifier_special_bonus_imba_elder_titan_4:IsHidden() return true end

function modifier_special_bonus_imba_elder_titan_4:IsPurgable() return false end

function modifier_special_bonus_imba_elder_titan_4:RemoveOnDeath() return false end

function modifier_special_bonus_imba_elder_titan_5:IsHidden() return true end

function modifier_special_bonus_imba_elder_titan_5:IsPurgable() return false end

function modifier_special_bonus_imba_elder_titan_5:RemoveOnDeath() return false end

function modifier_special_bonus_imba_elder_titan_6:IsHidden() return true end

function modifier_special_bonus_imba_elder_titan_6:IsPurgable() return false end

function modifier_special_bonus_imba_elder_titan_6:RemoveOnDeath() return false end

function modifier_special_bonus_imba_elder_titan_9:IsHidden() return true end

function modifier_special_bonus_imba_elder_titan_9:IsPurgable() return false end

function modifier_special_bonus_imba_elder_titan_9:RemoveOnDeath() return false end

function imba_elder_titan_ancestral_spirit:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_elder_titan_1") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_elder_titan_1") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:FindAbilityByName("special_bonus_imba_elder_titan_1"), "modifier_special_bonus_imba_elder_titan_1", {})
	end

	if self:GetCaster():HasTalent("special_bonus_imba_elder_titan_2") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_elder_titan_2") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:FindAbilityByName("special_bonus_imba_elder_titan_2"), "modifier_special_bonus_imba_elder_titan_2", {})
	end
end

function imba_elder_titan_natural_order:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_elder_titan_4") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_elder_titan_4") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:FindAbilityByName("special_bonus_imba_elder_titan_4"), "modifier_special_bonus_imba_elder_titan_4", {})
	end

	if self:GetCaster():HasTalent("special_bonus_imba_elder_titan_5") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_elder_titan_5") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:FindAbilityByName("special_bonus_imba_elder_titan_5"), "modifier_special_bonus_imba_elder_titan_5", {})
	end
end

function imba_elder_titan_earth_splitter:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_elder_titan_6") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_elder_titan_6") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:FindAbilityByName("special_bonus_imba_elder_titan_6"), "modifier_special_bonus_imba_elder_titan_6", {})
	end

	if self:GetCaster():HasTalent("special_bonus_imba_elder_titan_9") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_elder_titan_9") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:FindAbilityByName("special_bonus_imba_elder_titan_9"), "modifier_special_bonus_imba_elder_titan_9", {})
	end
end
