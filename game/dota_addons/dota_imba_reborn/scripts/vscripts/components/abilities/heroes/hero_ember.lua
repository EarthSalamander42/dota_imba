--	IMBA Ember Spirit
-- 	by Firetoad, 22.03.2018

LinkLuaModifier("modifier_imba_flame_guard_aura", "components/abilities/heroes/hero_ember.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_flame_guard_talent", "components/abilities/heroes/hero_ember.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_flame_guard_passive", "components/abilities/heroes/hero_ember.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sleight_of_fist_caster", "components/abilities/heroes/hero_ember.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sleight_of_fist_marker", "components/abilities/heroes/hero_ember.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_searing_chains_attack", "components/abilities/heroes/hero_ember.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_searing_chains_debuff", "components/abilities/heroes/hero_ember.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fire_remnant_state", "components/abilities/heroes/hero_ember.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fire_remnant_charges", "components/abilities/heroes/hero_ember.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fire_remnant_cooldown", "components/abilities/heroes/hero_ember.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fire_remnant_dash", "components/abilities/heroes/hero_ember.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fire_remnant_timer", "components/abilities/heroes/hero_ember.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

-- Finds all remnants in the map
function FindActiveRemnants(caster)
	local remnants = Entities:FindAllByModel("models/heroes/ember_spirit/ember_spirit.vmdl")

	for key, remnant in pairs(remnants) do
		--if caster == remnant or caster ~= remnant:GetOwner() or remnant:IsIllusion() or (not remnant:IsAlive()) then	
		if caster ~= remnant:GetOwner() or not remnant:HasModifier("modifier_imba_fire_remnant_state") then
			table.remove(remnants, key)
		end
	end

	if #remnants > 0 then
		local available_remnants = {}
		for _, remnant in pairs(remnants) do
			if remnant:GetTeam() == caster:GetTeam() then
				table.insert(available_remnants, remnant)
			end
		end

		return available_remnants
	else
		return nil
	end
end

--------------------------------------------------------------------------------

-- Apply Searing Chains debuff
function ApplySearingChains(caster, source, target, ability, duration)
	target:EmitSound("Hero_EmberSpirit.SearingChains.Target")
	target:AddNewModifier(caster, ability, "modifier_imba_searing_chains_debuff", {damage = ability:GetSpecialValueFor("damage_per_tick"), tick_interval = ability:GetSpecialValueFor("tick_interval"), duration = duration})
	local impact_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(impact_pfx, 0, source:GetAbsOrigin())
	ParticleManager:SetParticleControl(impact_pfx, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(impact_pfx)
end

--------------------------------------------------------------------------------

-- Flame Guard talent checker
modifier_imba_flame_guard_talent = modifier_imba_flame_guard_talent or class ({})

function modifier_imba_flame_guard_talent:IsDebuff() return false end
function modifier_imba_flame_guard_talent:IsHidden() return true end
function modifier_imba_flame_guard_talent:IsPurgable() return false end

function modifier_imba_flame_guard_talent:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_flame_guard_talent:OnCreated(keys)
	if IsServer() then
		self.learned_guard_talent = false
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_flame_guard_talent:OnIntervalThink()
	if IsServer() then
		if not self.learned_guard_talent then
			if self:GetParent():IsAlive() and self:GetParent():HasTalent("special_bonus_ember_permanent_guard") then
				self:GetParent():RemoveModifierByName("modifier_imba_flame_guard_aura")
				self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_flame_guard_passive", {})
				self:GetParent():EmitSound("Hero_EmberSpirit.FlameGuard.Loop")
				self:GetAbility():SetActivated(false)
				self.learned_guard_talent = true
			end
		end
	end
end

--------------------------------------------------------------------------------

-- Flame Guard passive
modifier_imba_flame_guard_passive = modifier_imba_flame_guard_passive or class ({})

function modifier_imba_flame_guard_passive:IsDebuff() return false end
function modifier_imba_flame_guard_passive:IsHidden() return false end
function modifier_imba_flame_guard_passive:IsPurgable() return false end

function modifier_imba_flame_guard_passive:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_imba_flame_guard_passive:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf"
end

function modifier_imba_flame_guard_passive:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_flame_guard_passive:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_interval"))
	end
end

function modifier_imba_flame_guard_passive:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local damage = ability:GetSpecialValueFor("damage_per_second")
		if caster:FindAbilityByName("special_bonus_ember_guard_damage") and caster:FindAbilityByName("special_bonus_ember_guard_damage"):GetLevel() > 0 then
			damage = damage + caster:FindAbilityByName("special_bonus_ember_guard_damage"):GetSpecialValueFor("value")
		end
		damage = damage * ability:GetSpecialValueFor("tick_interval")
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ability:GetSpecialValueFor("effect_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(nearby_enemies) do
			ApplyDamage({victim = enemy, attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	end
end

function modifier_imba_flame_guard_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_imba_flame_guard_passive:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("absorb_amount")
end

--------------------------------------------------------------------------------

-- Flame Guard fire aura
modifier_imba_flame_guard_aura = modifier_imba_flame_guard_aura or class ({})

function modifier_imba_flame_guard_aura:IsDebuff() return false end
function modifier_imba_flame_guard_aura:IsHidden() return false end
function modifier_imba_flame_guard_aura:IsPurgable() return true end

function modifier_imba_flame_guard_aura:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf"
end

function modifier_imba_flame_guard_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_flame_guard_aura:OnCreated(keys)
	if IsServer() then
		self.tick_interval = keys.tick_interval
		self.damage = keys.damage * self.tick_interval
		self.effect_radius = keys.effect_radius
		self.remaining_health = keys.remaining_health
		self:SetStackCount(self.remaining_health)
		self:StartIntervalThink(self.tick_interval)
	end
end

function modifier_imba_flame_guard_aura:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_EmberSpirit.FlameGuard.Loop")
	end
end

function modifier_imba_flame_guard_aura:OnIntervalThink()
	if IsServer() then
		if self.remaining_health <= 0 then
			self:GetParent():RemoveModifierByName("modifier_imba_flame_guard_aura")
		else
			local nearby_enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.effect_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(nearby_enemies) do
				ApplyDamage({victim = enemy, attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
			end
		end
	end
end

function modifier_imba_flame_guard_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
	return funcs
end

function modifier_imba_flame_guard_aura:GetModifierAvoidDamage(keys)
	if IsServer() then
		if keys.damage_type == DAMAGE_TYPE_MAGICAL then
			self.remaining_health = self.remaining_health - keys.original_damage
			self:SetStackCount(self.remaining_health)
			return 1
		else
			return 0
		end
	end
end

--------------------------------------------------------------------------------

-- Sleight of Fist caster modifier
modifier_imba_sleight_of_fist_caster = modifier_imba_sleight_of_fist_caster or class ({})

function modifier_imba_sleight_of_fist_caster:IsDebuff() return false end
function modifier_imba_sleight_of_fist_caster:IsHidden() return true end
function modifier_imba_sleight_of_fist_caster:IsPurgable() return false end

function modifier_imba_sleight_of_fist_caster:OnCreated()
	if IsServer() then
		self:GetParent():AddNoDraw()
	end
end

function modifier_imba_sleight_of_fist_caster:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveNoDraw()
	end
end

function modifier_imba_sleight_of_fist_caster:CheckState()
	if IsServer() then
		local state = {
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_DISARMED] = true
		}

		return state
	end
end

function modifier_imba_sleight_of_fist_caster:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

function modifier_imba_sleight_of_fist_caster:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

--------------------------------------------------------------------------------

-- Sleight of Fist target marker
modifier_imba_sleight_of_fist_marker = modifier_imba_sleight_of_fist_marker or class ({})

function modifier_imba_sleight_of_fist_marker:IsDebuff() return true end
function modifier_imba_sleight_of_fist_marker:IsHidden() return true end
function modifier_imba_sleight_of_fist_marker:IsPurgable() return false end

function modifier_imba_sleight_of_fist_marker:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_targetted_marker.vpcf"
end

function modifier_imba_sleight_of_fist_marker:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

-- Searing Chains attack proc
modifier_imba_searing_chains_attack = modifier_imba_searing_chains_attack or class ({})

function modifier_imba_searing_chains_attack:IsDebuff() return false end
function modifier_imba_searing_chains_attack:IsHidden() return true end
function modifier_imba_searing_chains_attack:IsPurgable() return false end

function modifier_imba_searing_chains_attack:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_imba_searing_chains_attack:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local attacker = self:GetParent()
			if attacker:FindAbilityByName("special_bonus_ember_chains_on_attack") and attacker:FindAbilityByName("special_bonus_ember_chains_on_attack"):GetLevel() > 0 then
				local talent_ability = attacker:FindAbilityByName("special_bonus_ember_chains_on_attack")
				local target = keys.target
				if RollPercentage(talent_ability:GetSpecialValueFor("chance")) and not (target:IsBuilding() or target:IsMagicImmune()) then
					ApplySearingChains(attacker, attacker, target, self:GetAbility(), talent_ability:GetSpecialValueFor("duration"))
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

-- Searing Chains debuff
modifier_imba_searing_chains_debuff = modifier_imba_searing_chains_debuff or class ({})

function modifier_imba_searing_chains_debuff:IsDebuff() return true end
function modifier_imba_searing_chains_debuff:IsHidden() return false end
function modifier_imba_searing_chains_debuff:IsPurgable() return true end

function modifier_imba_searing_chains_debuff:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf"
end

function modifier_imba_searing_chains_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_searing_chains_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true
	}

	return state
end

function modifier_imba_searing_chains_debuff:OnCreated(keys)
	if IsServer() then
		self.tick_interval = keys.tick_interval
		self.damage = keys.damage
		self:StartIntervalThink(self.tick_interval)

		-- Mini-stun
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.1})
	end
end

function modifier_imba_searing_chains_debuff:OnIntervalThink()
	if IsServer() then
		ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end

--------------------------------------------------------------------------------

-- Charge counter modifier
modifier_imba_fire_remnant_charges = modifier_imba_fire_remnant_charges or class ({})

function modifier_imba_fire_remnant_charges:IsDebuff() return false end
function modifier_imba_fire_remnant_charges:IsHidden() return false end
function modifier_imba_fire_remnant_charges:IsPurgable() return false end
function modifier_imba_fire_remnant_charges:RemoveOnDeath() return false end

function modifier_imba_fire_remnant_charges:OnCreated(keys)
	if IsServer() then
		self:GetCaster().spirit_charges = 0
		self:SetStackCount(self:GetAbility():GetSpecialValueFor("max_charges"))
		self.learned_charges_talent = false
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_fire_remnant_charges:OnIntervalThink()
	if IsServer() then
		if not self.learned_charges_talent then
			local talent = self:GetParent():FindAbilityByName("special_bonus_ember_remnant_charges")
			if talent and talent:GetLevel() > 0 then
				self:SetStackCount(self:GetStackCount() + talent:GetSpecialValueFor("value"))
				self.learned_charges_talent = true
			end
		end

		if self:GetParent():IsAlive() and self:GetCaster().spirit_charges > 0 then
			self:SetStackCount(self:GetStackCount() + self:GetCaster().spirit_charges)
			self:GetCaster().spirit_charges = 0
			self:GetAbility():SetActivated(true)
		end
	end
end

--------------------------------------------------------------------------------

-- Remnant state modifier
modifier_imba_fire_remnant_state = modifier_imba_fire_remnant_state or class ({})

function modifier_imba_fire_remnant_state:IsDebuff() return false end
function modifier_imba_fire_remnant_state:IsHidden() return false end
function modifier_imba_fire_remnant_state:IsPurgable() return false end

function modifier_imba_fire_remnant_state:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant.vpcf"
end

function modifier_imba_fire_remnant_state:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_fire_remnant_state:StatusEffectPriority()
	return 20
end

function modifier_imba_fire_remnant_state:GetStatusEffectName()
	return "particles/status_fx/status_effect_burn.vpcf"
end

function modifier_imba_fire_remnant_state:CheckState()
	if IsServer() then
		local state = {
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true
		}

		return state
	end
end

function modifier_imba_fire_remnant_state:OnCreated(keys)
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kill", {duration = self:GetDuration()})
		if self:GetCaster():HasScepter() then
			self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("attack_cd_scepter"))
			self.has_scepter = true
		else
			self:StartIntervalThink(5.0)
			self.has_scepter = false
		end
	end
end

function modifier_imba_fire_remnant_state:OnIntervalThink()
	if IsServer() then
		if self.has_scepter then
			local caster = self:GetCaster()
			local remnant = self:GetParent()

			-- Animate the slash
			remnant:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK , 1)

			print(caster:Script_GetAttackRange())
			
			-- Pick a random enemy in range
			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), remnant:GetAbsOrigin(), nil, caster:Script_GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
			if nearby_enemies[1] then
				caster:PerformAttack(nearby_enemies[1], true, true, true, false, false, false, true)
			end
		else
			local rand = RandomInt(1, 10)
			if rand == 1 then
				self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4 , 1)
--			elseif rand == 2 then
--				self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_STATUE , 1)
			elseif rand == 3 then
				self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_VICTORY_START , 1)
			elseif rand == 4 then
				self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_VERSUS , 3)
--			elseif rand > 4 and rand < 7 then
--				self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_REMNANT_STATUE , 1)
			end
		end
	end
end

function modifier_imba_fire_remnant_state:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
		self:GetAbility():CollectRemnant()
	end
end

--------------------------------------------------------------------------------

-- Remnant cooldown modifier
modifier_imba_fire_remnant_cooldown = modifier_imba_fire_remnant_cooldown or class ({})

function modifier_imba_fire_remnant_cooldown:IsDebuff() return true end
function modifier_imba_fire_remnant_cooldown:IsHidden() return false end
function modifier_imba_fire_remnant_cooldown:IsPurgable() return false end
function modifier_imba_fire_remnant_cooldown:RemoveOnDeath() return false end

function modifier_imba_fire_remnant_cooldown:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_fire_remnant_cooldown:OnDestroy()
	if IsServer() then
		local charges_modifier = self:GetParent():FindModifierByName("modifier_imba_fire_remnant_charges")
		charges_modifier:SetStackCount(charges_modifier:GetStackCount() + 1)

		self:GetAbility():SetActivated(true)
	end
end

--------------------------------------------------------------------------------

-- Dash state modifier
modifier_imba_fire_remnant_dash = modifier_imba_fire_remnant_dash or class ({})

function modifier_imba_fire_remnant_dash:IsDebuff() return false end
function modifier_imba_fire_remnant_dash:IsHidden() return true end
function modifier_imba_fire_remnant_dash:IsPurgable() return false end

function modifier_imba_fire_remnant_dash:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf"
end

function modifier_imba_fire_remnant_dash:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_fire_remnant_dash:CheckState()
	if IsServer() then
		local state = {
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_COMMAND_RESTRICTED] = true
		}

		return state
	end
end

--------------------------------------------------------------------------------

-- Searing Chains ability
imba_ember_spirit_searing_chains = imba_ember_spirit_searing_chains or class ({})

function imba_ember_spirit_searing_chains:GetIntrinsicModifierName()
	return "modifier_imba_searing_chains_attack"
end

function imba_ember_spirit_searing_chains:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local max_targets = self:GetSpecialValueFor("units_per_charge")
		local main_targets = self:GetSpecialValueFor("units_per_charge")
		local duration = self:GetSpecialValueFor("duration")

		-- Extra targets from remnants
		if caster:FindModifierByName("modifier_imba_fire_remnant_charges") then
			main_targets = max_targets * (1 + caster:FindModifierByName("modifier_imba_fire_remnant_charges"):GetStackCount())
		end

		-- Extra duration from talent #2
		if caster:FindAbilityByName("special_bonus_ember_chains_duration") and caster:FindAbilityByName("special_bonus_ember_chains_duration"):GetLevel() > 0 then
			duration = duration + caster:FindAbilityByName("special_bonus_ember_chains_duration"):GetSpecialValueFor("value")
		end

		-- Particles and sound
		caster:EmitSound("Hero_EmberSpirit.SearingChains.Cast")
		local cast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_cast.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(cast_pfx, 0, caster_loc)
		ParticleManager:SetParticleControl(cast_pfx, 1, Vector(self:GetSpecialValueFor("effect_radius"), 1, 1))
		ParticleManager:ReleaseParticleIndex(cast_pfx)

		-- Find targets
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, self:GetSpecialValueFor("effect_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		for i = 1, main_targets do
			if nearby_enemies[i] then
				ApplySearingChains(caster, caster, nearby_enemies[i], self, duration)
			end
		end

		-- Remnant throws
		local active_remnants = FindActiveRemnants(caster)
		if active_remnants then
			for _, remnant in pairs(active_remnants) do
				local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), remnant:GetAbsOrigin(), nil, self:GetSpecialValueFor("effect_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
				for i = 1, max_targets do
					if nearby_enemies[i] then
						ApplySearingChains(caster, remnant, nearby_enemies[i], self, duration)
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

-- Sleight of Fist ability
imba_ember_spirit_sleight_of_fist = imba_ember_spirit_sleight_of_fist or class ({})

function imba_ember_spirit_sleight_of_fist:GetAOERadius()
	return self:GetSpecialValueFor("effect_radius")
end

function imba_ember_spirit_sleight_of_fist:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()
		local original_direction = (caster:GetAbsOrigin() - target_loc):Normalized()
		local effect_radius = self:GetSpecialValueFor("effect_radius")
		local attack_interval = self:GetSpecialValueFor("attack_interval")
		local sleight_targets = {}

		-- Play primary cast sound/particle
		caster:EmitSound("Hero_EmberSpirit.SleightOfFist.Cast")
		local cast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(cast_pfx, 0, target_loc)
		ParticleManager:SetParticleControl(cast_pfx, 1, Vector(effect_radius, 1, 1))
		ParticleManager:ReleaseParticleIndex(cast_pfx)

		-- Mark targets to hit
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, effect_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		for _, enemy in pairs(nearby_enemies) do
			sleight_targets[#sleight_targets + 1] = enemy:GetEntityIndex()
			enemy:AddNewModifier(caster, self, "modifier_imba_sleight_of_fist_marker", {duration = (#sleight_targets - 1) * attack_interval})
		end

		-- More targets to hit, from any active remnants
		local active_remnants = FindActiveRemnants(caster)
		if active_remnants then
			for _, remnant in pairs(active_remnants) do
				nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), remnant:GetAbsOrigin(), nil, effect_radius / 2, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
				for _, enemy in pairs(nearby_enemies) do
					sleight_targets[#sleight_targets + 1] = enemy:GetEntityIndex()
					enemy:AddNewModifier(caster, self, "modifier_imba_sleight_of_fist_marker", {duration = (#sleight_targets - 1) * attack_interval})
				end

				-- Secondary cast sound/particles
				remnant:EmitSound("Hero_EmberSpirit.SleightOfFist.Cast")
				local remnant_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(remnant_pfx, 0, remnant:GetAbsOrigin())
				ParticleManager:SetParticleControl(remnant_pfx, 1, Vector(effect_radius / 2, 1, 1))
				ParticleManager:ReleaseParticleIndex(remnant_pfx)
			end
		end

		-- If the appropriate talent is learned, hit some extra random enemies
		if caster:FindAbilityByName("special_bonus_ember_sleight_extra_targets") and caster:FindAbilityByName("special_bonus_ember_sleight_extra_targets"):GetLevel() > 0 then
			for i = 1, caster:FindAbilityByName("special_bonus_ember_sleight_extra_targets"):GetSpecialValueFor("bonus_targets") do
				if sleight_targets[i] then
					sleight_targets[#sleight_targets + 1] = sleight_targets[i]
				end
			end
		end

		-- If there's at least one target to hit, perform the spell
		if #sleight_targets >= 1 then
			local previous_position = caster:GetAbsOrigin()
			local current_count = 1
			local current_target = EntIndexToHScript(sleight_targets[current_count])
			caster:AddNewModifier(caster, self, "modifier_imba_sleight_of_fist_caster", {})
			--ProjectileManager:ProjectileDodge(caster)
			Timers:CreateTimer(FrameTime(), function()
				if current_target:IsAlive() then
					-- Particles and sound
					caster:EmitSound("Hero_EmberSpirit.SleightOfFist.Damage")
					local slash_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, current_target)
					ParticleManager:SetParticleControl(slash_pfx, 0, current_target:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(slash_pfx)

					local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(trail_pfx, 0, current_target:GetAbsOrigin())
					ParticleManager:SetParticleControl(trail_pfx, 1, previous_position)
					ParticleManager:ReleaseParticleIndex(trail_pfx)

					-- Perform the attack
					if caster:HasModifier("modifier_imba_sleight_of_fist_caster") then
						caster:SetAbsOrigin(current_target:GetAbsOrigin() + original_direction * 64)
						caster:PerformAttack(current_target, true, true, true, false, false, false, false)
					end
				end

				-- Check if the loop continues
				current_count = current_count + 1

				if #sleight_targets >= current_count and caster:HasModifier("modifier_imba_sleight_of_fist_caster") then
					previous_position = current_target:GetAbsOrigin()
					current_target = EntIndexToHScript(sleight_targets[current_count])
					return attack_interval
				-- If not, stop everything
				else
					if caster:HasModifier("modifier_imba_sleight_of_fist_caster") then
						FindClearSpaceForUnit(caster, caster_loc, true)
					end
					caster:RemoveModifierByName("modifier_imba_sleight_of_fist_caster")
					for _, target in pairs(sleight_targets) do
						EntIndexToHScript(target):RemoveModifierByName("modifier_imba_sleight_of_fist_marker")
					end
				end
			end)
		end
	end
end

--------------------------------------------------------------------------------

-- Fire Remnant ability
imba_ember_spirit_fire_remnant = imba_ember_spirit_fire_remnant or class ({})

function imba_ember_spirit_fire_remnant:GetAssociatedPrimaryAbilities() return "imba_ember_spirit_activate_fire_remnant" end

function imba_ember_spirit_fire_remnant:CollectRemnant()
	if IsServer() then
		-- ember spirit bug: this modifier is not added
		if self:GetCaster():IsAlive() then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_fire_remnant_cooldown", {duration = self:GetSpecialValueFor("remnant_recharge")})
		else
			self:GetCaster().spirit_charges = self:GetCaster().spirit_charges + 1
		end

		if FindActiveRemnants(self:GetCaster()) then
			self:GetCaster():FindAbilityByName("imba_ember_spirit_activate_fire_remnant"):SetActivated(false)
		end
	end
end

function imba_ember_spirit_fire_remnant:GetIntrinsicModifierName()
	return "modifier_imba_fire_remnant_charges"
end

function imba_ember_spirit_fire_remnant:GetAOERadius()
	return self:GetSpecialValueFor("effect_radius")
end

function imba_ember_spirit_fire_remnant:OnUpgrade()
	if IsServer() then
		local caster = self:GetCaster()
		local activate_ability = caster:FindAbilityByName("imba_ember_spirit_activate_fire_remnant")
		activate_ability:SetLevel(self:GetLevel())
	end
end

function imba_ember_spirit_fire_remnant:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local charges_modifier = caster:FindModifierByName("modifier_imba_fire_remnant_charges")

		if charges_modifier:GetStackCount() > 0 then
			charges_modifier:SetStackCount(charges_modifier:GetStackCount() - 1)
			caster:EmitSound("Hero_EmberSpirit.FireRemnant.Cast")
			local remnant = CreateUnitByName("npc_imba_ember_spirit_remnant", target_loc, true, caster, caster, caster:GetTeamNumber())
			remnant:SetOwner(caster)
			remnant:EmitSound("Hero_EmberSpirit.FireRemnant.Activate")
			remnant:SetRenderColor(255, 0, 0)
			remnant:AddNewModifier(caster, self, "modifier_imba_fire_remnant_state", {duration = self:GetSpecialValueFor("duration")})
			self:GetCaster():FindAbilityByName("imba_ember_spirit_activate_fire_remnant"):SetActivated(true)
			if charges_modifier:GetStackCount() <= 0 then
				self:SetActivated(false)
			end

			self:GetCaster():AddNewModifier(caster, self, "modifier_imba_fire_remnant_timer", {duration = self:GetSpecialValueFor("duration")})
			
			-- Remnant Flame Guard logic
			local ability_flame_guard = caster:FindAbilityByName("imba_ember_spirit_flame_guard")
			if ability_flame_guard then
				local effect_radius = ability_flame_guard:GetSpecialValueFor("effect_radius")
				local damage = ability_flame_guard:GetSpecialValueFor("damage_per_second")
				local tick_interval = ability_flame_guard:GetSpecialValueFor("tick_interval")
				if caster:FindAbilityByName("special_bonus_ember_guard_damage") and caster:FindAbilityByName("special_bonus_ember_guard_damage"):GetLevel() > 0 then
					damage = damage + caster:FindAbilityByName("special_bonus_ember_guard_damage"):GetSpecialValueFor("value")
				end
				if caster:HasModifier("modifier_imba_flame_guard_aura") then
					remnant:EmitSound("Hero_EmberSpirit.FlameGuard.Loop")
					remnant:AddNewModifier(caster, ability_flame_guard, "modifier_imba_flame_guard_aura", {damage = damage * 0.5, tick_interval = tick_interval, effect_radius = effect_radius, remaining_health = 1000, duration = caster:FindModifierByName("modifier_imba_flame_guard_aura"):GetRemainingTime()})
				elseif caster:FindAbilityByName("special_bonus_ember_permanent_guard") and caster:FindAbilityByName("special_bonus_ember_permanent_guard"):GetLevel() > 0 then
					remnant:EmitSound("Hero_EmberSpirit.FlameGuard.Loop")
					remnant:AddNewModifier(caster, ability_flame_guard, "modifier_imba_flame_guard_aura", {damage = damage * 0.5, tick_interval = tick_interval, effect_radius = effect_radius, remaining_health = 1000})
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

-- Flame Guard ability
imba_ember_spirit_flame_guard = imba_ember_spirit_flame_guard or class ({})

function imba_ember_spirit_flame_guard:GetIntrinsicModifierName()
	return "modifier_imba_flame_guard_talent"
end

function imba_ember_spirit_flame_guard:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local effect_radius = self:GetSpecialValueFor("effect_radius")
		local duration = self:GetSpecialValueFor("duration")
		local damage = self:GetSpecialValueFor("damage_per_second")
		local tick_interval = self:GetSpecialValueFor("tick_interval")
		local absorb_amount = self:GetSpecialValueFor("absorb_amount") * caster:GetMaxHealth() * 0.01

		-- Increase damage if the appropriate talent is learned
		if caster:FindAbilityByName("special_bonus_ember_guard_damage") and caster:FindAbilityByName("special_bonus_ember_guard_damage"):GetLevel() > 0 then
			damage = damage + caster:FindAbilityByName("special_bonus_ember_guard_damage"):GetSpecialValueFor("value")
		end

		-- Remnant versions
		local active_remnants = FindActiveRemnants(caster)
		if active_remnants then
			for _, remnant in pairs(active_remnants) do
				remnant:EmitSound("Hero_EmberSpirit.FlameGuard.Cast")
				remnant:EmitSound("Hero_EmberSpirit.FlameGuard.Loop")
				remnant:AddNewModifier(caster, self, "modifier_imba_flame_guard_aura", {damage = damage * 0.5, tick_interval = tick_interval, effect_radius = effect_radius, remaining_health = absorb_amount, duration = duration})
			end
		end

		-- Caster version
		caster:EmitSound("Hero_EmberSpirit.FlameGuard.Cast")
		caster:EmitSound("Hero_EmberSpirit.FlameGuard.Loop")
		caster:RemoveModifierByName("modifier_imba_flame_guard_aura")
		caster:AddNewModifier(caster, self, "modifier_imba_flame_guard_aura", {damage = damage, tick_interval = tick_interval, effect_radius = effect_radius, remaining_health = absorb_amount, duration = duration})
	end
end

--------------------------------------------------------------------------------

-- Activate Fire Remnant ability
imba_ember_spirit_activate_fire_remnant = imba_ember_spirit_activate_fire_remnant or class ({})

function imba_ember_spirit_activate_fire_remnant:GetAssociatedSecondaryAbilities() return "imba_ember_spirit_fire_remnant" end

function imba_ember_spirit_activate_fire_remnant:OnUpgrade()
	if IsServer() then
		if self:GetLevel() == 1 then
			self:SetActivated(false)
		end
	end
end

function imba_ember_spirit_activate_fire_remnant:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local active_remnants = FindActiveRemnants(caster)

		if active_remnants then
			local closest_remnant_position = active_remnants[1]:GetAbsOrigin()
			local closest_distance = (closest_remnant_position - target_loc):Length2D()
			for _, remnant in pairs(active_remnants) do
				if (remnant:GetAbsOrigin() - target_loc):Length2D() < closest_distance then
					closest_remnant_position = remnant:GetAbsOrigin()
					closest_distance = (closest_remnant_position - target_loc):Length2D()
				end

				local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), remnant:GetAbsOrigin(), nil, self:GetSpecialValueFor("effect_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _, enemy in pairs(nearby_enemies) do
					ApplyDamage({victim = enemy, attacker = caster, damage = self:GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
				end
				
				remnant:EmitSound("Hero_EmberSpirit.FireRemnant.Explode")
				
				GridNav:DestroyTreesAroundPoint(remnant:GetAbsOrigin(), self:GetSpecialValueFor("effect_radius"), false)
				
				if remnant ~= caster then
					remnant:ForceKill(false)
				end
				
				if caster:HasModifier("modifier_imba_fire_remnant_timer") then
					caster:RemoveModifierByName("modifier_imba_fire_remnant_timer")
				end
			end

			ProjectileManager:ProjectileDodge(caster)
			caster:RemoveModifierByName("modifier_imba_sleight_of_fist_caster")
			FindClearSpaceForUnit(caster, closest_remnant_position, true)
			caster:EmitSound("Hero_EmberSpirit.FireRemnant.Stop")
			self:SetActivated(false)
		end
	end
end

--------------------------------------------------------------------------------

-- Fire Remnant Expiry Timer (for caster)
modifier_imba_fire_remnant_timer = modifier_imba_fire_remnant_timer or class({})

function modifier_imba_fire_remnant_timer:IsHidden()		return false end
function modifier_imba_fire_remnant_timer:IsPurgable()		return false end
function modifier_imba_fire_remnant_timer:RemoveOnDeath()	return false end
function modifier_imba_fire_remnant_timer:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
