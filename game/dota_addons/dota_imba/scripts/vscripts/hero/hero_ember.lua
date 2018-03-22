--	IMBA Ember Spirit
-- 	by Firetoad, 22.03.2018

LinkLuaModifier( "modifier_imba_searing_chains_attack", "hero/hero_ember.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_searing_chains_debuff", "hero/hero_ember.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_fire_remnant_state", "hero/hero_ember.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_fire_remnant_charges", "hero/hero_ember.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_fire_remnant_cooldown", "hero/hero_ember.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_fire_remnant_dash", "hero/hero_ember.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

-- Finds all remnants in the map
function FindActiveRemnants(caster)
	local remnants = Entities:FindAllByModel("models/heroes/ember_spirit/ember_spirit.vmdl")
	for key, remnant in pairs(remnants) do
		if caster == remnant or caster ~= remnant:GetOwner() then
			table.remove(remnants, key)
		end
	end
	if #remnants > 0 then
		return remnants
	else
		return nil
	end
end

--------------------------------------------------------------------------------

-- Applies Searing Chains debuff
function ApplySearingChains(caster, source, target, ability, duration)
	target:EmitSound("Hero_EmberSpirit.SearingChains.Target")
	target:AddNewModifier(caster, ability, "modifier_imba_searing_chains_debuff", {damage = ability:GetSpecialValueFor("damage_per_tick"), tick_interval = ability:GetSpecialValueFor("tick_interval"), duration = duration})
	local impact_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(impact_pfx, 0, source:GetAbsOrigin())
	ParticleManager:SetParticleControl(impact_pfx, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(impact_pfx)
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

function modifier_imba_fire_remnant_charges:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_fire_remnant_charges:OnCreated(keys)
	if IsServer() then
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
	end
end

--------------------------------------------------------------------------------

-- Remnant state modifier
modifier_imba_fire_remnant_state = modifier_imba_fire_remnant_state or class ({})

function modifier_imba_fire_remnant_state:IsDebuff() return false end
function modifier_imba_fire_remnant_state:IsHidden() return true end
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

			-- Pick a random enemy in range
			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), remnant:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("effect_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
			if nearby_enemies[1] then
				caster:PerformAttack(nearby_enemies[1], true, true, true, false, false, false, true)
			end
		else
			local rand = RandomInt(1, 10)
			if rand == 1 then
				self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4 , 1)
			elseif rand == 2 then
				self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_STATUE , 1)
			elseif rand == 3 then
				self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_VICTORY_START , 1)
			elseif rand == 4 then
				self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_VERSUS , 3)
			elseif rand > 4 and rand < 7 then
				self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_REMNANT_STATUE , 1)
			end
		end
	end
end

function modifier_imba_fire_remnant_state:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_kill")
		self:GetAbility():CollectRemnant()
	end
end

--------------------------------------------------------------------------------

-- Remnant cooldown modifier
modifier_imba_fire_remnant_cooldown = modifier_imba_fire_remnant_cooldown or class ({})

function modifier_imba_fire_remnant_cooldown:IsDebuff() return true end
function modifier_imba_fire_remnant_cooldown:IsHidden() return false end
function modifier_imba_fire_remnant_cooldown:IsPurgable() return false end

function modifier_imba_fire_remnant_cooldown:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_fire_remnant_cooldown:OnDestroy()
	if IsServer() then
		local charges_modifier = self:GetParent():FindModifierByName("modifier_imba_fire_remnant_charges")
		if charges_modifier then
			charges_modifier:SetStackCount(charges_modifier:GetStackCount() + 1)
		end
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

-- Fire Remnant ability
imba_ember_spirit_fire_remnant = imba_ember_spirit_fire_remnant or class ({})

function imba_ember_spirit_fire_remnant:CollectRemnant()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_fire_remnant_cooldown", {duration = self:GetSpecialValueFor("remnant_recharge")})
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
		end
	end
end

--------------------------------------------------------------------------------

-- Activate Fire Remnant ability
imba_ember_spirit_activate_fire_remnant = imba_ember_spirit_activate_fire_remnant or class ({})

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
				remnant:RemoveModifierByName("modifier_imba_fire_remnant_state")
			end
			ProjectileManager:ProjectileDodge(caster)
			FindClearSpaceForUnit(caster, closest_remnant_position, true)
			GridNav:DestroyTreesAroundPoint(closest_remnant_position, self:GetSpecialValueFor("effect_radius"), false)
			caster:EmitSound("Hero_EmberSpirit.FireRemnant.Stop")
			self:SetActivated(false)
		end
	end
end