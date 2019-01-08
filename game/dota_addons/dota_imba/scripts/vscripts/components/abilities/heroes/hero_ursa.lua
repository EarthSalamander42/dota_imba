-- Editors:
--     Seinken, 11.01.2017

---------------------------------------------------
--			Ursa's Earthshock
---------------------------------------------------

imba_ursa_earthshock = class({})

LinkLuaModifier("modifier_imba_earthshock_slow", "components/abilities/heroes/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_trembling_steps_buff", "components/abilities/heroes/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_trembling_steps_prevent", "components/abilities/heroes/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_trembling_steps_debuff", "components/abilities/heroes/hero_ursa", LUA_MODIFIER_MOTION_NONE)

function imba_ursa_earthshock:GetAbilityTextureName()
	return "ursa_earthshock"
end

function imba_ursa_earthshock:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self
		local sound_cast = "Hero_Ursa.Earthshock"
		local earthshock_particle = "particles/units/heroes/hero_ursa/ursa_earthshock.vpcf"
		local earthshock_debuff = "modifier_imba_earthshock_slow"
		local trembling_steps_buff = "modifier_imba_trembling_steps_buff"
		local trembling_steps_prevent = "modifier_imba_trembling_steps_prevent"
		local enrage_buff = "modifier_imba_enrage_buff"
		local enrage_ability = caster:FindAbilityByName("imba_ursa_enrage")
		local enrage_particle = "particles/hero/ursa/enrage_ursa_earthshock.vpcf"

		-- Ability specials
		local radius = ability:GetSpecialValueFor("radius")
		local duration = ability:GetSpecialValueFor("duration")
		local base_damage = ability:GetSpecialValueFor("base_damage")
		local values_increase_distance = ability:GetSpecialValueFor("values_increase_distance")
		local values_increase_pct = ability:GetSpecialValueFor("values_increase_pct")
		local slow_pct = ability:GetSpecialValueFor("slow_pct")
		local trembling_steps_cooldown = ability:GetSpecialValueFor("trembling_steps_cooldown")
		local trembling_steps_duration = ability:GetSpecialValueFor("trembling_steps_duration")
		local bonus_effects_radius = ability:GetSpecialValueFor("bonus_effects_radius")
		local bonus_damage_pct = ability:GetSpecialValueFor("bonus_damage_pct")
		local bonus_slow_pct = ability:GetSpecialValueFor("bonus_slow_pct")
		local enrage_bonus_radius = 0
		if enrage_ability then
			enrage_bonus_radius = enrage_ability:GetSpecialValueFor("bonus_radius_skills")
		else
			enrage_bonus_radius = 0
		end
		local enrage_bonus_dmg_pct = ability:GetSpecialValueFor("enrage_bonus_dmg_pct")

		-- Check if Ursa has Enrage buff active, increase radius, damage percents and set Enrage particles
		if caster:HasModifier(enrage_buff) then
			radius = radius + enrage_bonus_radius
			earthshock_particle = enrage_particle
			bonus_damage_pct = bonus_damage_pct + enrage_bonus_dmg_pct
		end

		-- Play cast sound
		EmitSoundOn(sound_cast, caster)

		-- Add appropriate particles
		local earthshock_particle_fx = ParticleManager:CreateParticle(earthshock_particle, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(earthshock_particle_fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(earthshock_particle_fx, 1, Vector(1,1,1))
		ParticleManager:ReleaseParticleIndex(earthshock_particle_fx)

		-- Find all enemies in Aoe
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		-- Calculate distance from edge of Earthshock's radius.
		for _,enemy in pairs(enemies) do

			if not enemy:IsMagicImmune() then
				local distance = (enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
				local edge_distance = radius - distance
				local earthshock_debuff_slow_pct
				local damage

				-- If enemy is closer than 190 units, set bonuses, otherwise calculate damage scaling with distance.
				if distance <= bonus_effects_radius then
					damage = base_damage * (1 + (bonus_damage_pct * 0.01))
					earthshock_debuff_slow_pct = slow_pct + bonus_slow_pct
				else
					local scale_increase_for_distance =  math.floor(edge_distance / values_increase_distance) --how much it should scale
					local pct_increase_for_distance =  values_increase_pct * scale_increase_for_distance -- how many percents the scale should go up
					damage = base_damage * (1 + pct_increase_for_distance) -- final damage
					earthshock_debuff_slow_pct = slow_pct * (1+ pct_increase_for_distance) -- final slow value
				end

				-- Apply damage
				local damageTable = {victim = enemy,
					attacker = caster,
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = ability}

				ApplyDamage(damageTable)

				-- Apply debuff to non-magic immune enemies
				enemy:AddNewModifier(caster, ability, earthshock_debuff, {duration = duration})
			end
		end

		-- Apply trembling steps buff to Ursa AND trembling_steps prevent buff (to stop him from immediately casting trembling steps
		caster:AddNewModifier(caster, ability, trembling_steps_buff, {duration = trembling_steps_duration})
		caster:AddNewModifier(caster, ability, trembling_steps_prevent, {duration = trembling_steps_cooldown})
	end
end




-- Earthshock slow debuff
modifier_imba_earthshock_slow = class({})

function modifier_imba_earthshock_slow:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.enemy = self:GetParent()

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.bonus_effects_radius = self.ability:GetSpecialValueFor("bonus_effects_radius")
	self.slow_pct = self.ability:GetSpecialValueFor("slow_pct")
	self.bonus_slow_pct = self.ability:GetSpecialValueFor("bonus_slow_pct")
	self.values_increase_distance = self.ability:GetSpecialValueFor("values_increase_distance")
	self.values_increase_pct = self.ability:GetSpecialValueFor("values_increase_pct")

	self.distance = (self.enemy:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D()
	self.edge_distance = self.radius - self.distance

	-- If enemy is closer than 190 units, set bonuses, otherwise calculate damage scaling with distance.
	if self.distance <= self.bonus_effects_radius then
		self.earthshock_debuff_slow_pct = self.slow_pct + self.bonus_slow_pct
	else
		self.scale_increase_for_distance =  math.floor(self.edge_distance / self.values_increase_distance) --how much it should scale
		self.pct_increase_for_distance =  self.values_increase_pct * self.scale_increase_for_distance -- how many percents the scale should go up
		self.earthshock_debuff_slow_pct = self.slow_pct * (1 + self.pct_increase_for_distance) -- final slow value
	end
end

function modifier_imba_earthshock_slow:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_earthshock_modifier.vpcf"
end

function modifier_imba_earthshock_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_earthshock_slow:IsDebuff()
	return true
end

function modifier_imba_earthshock_slow:IsHidden()
	return false
end

function modifier_imba_earthshock_slow:IsPurgable()
	return true
end

function modifier_imba_earthshock_slow:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_imba_earthshock_slow:GetModifierMoveSpeedBonus_Percentage()
	local enemy = self:GetParent()
	return self.earthshock_debuff_slow_pct * (-1)
end


-- Trembling Steps buff
modifier_imba_trembling_steps_buff = class({})

function modifier_imba_trembling_steps_buff:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.sound_step = "Imba.UrsaTremblingSteps"
		self.particle_step = "particles/hero/ursa/ursa_trembling_steps_elixir.vpcf"
		self.trembling_steps_prevent = "modifier_imba_trembling_steps_prevent"
		self.trembling_steps_debuff = "modifier_imba_trembling_steps_debuff"

		-- Ability specials
		self.base_radius = self.ability:GetSpecialValueFor("radius")
		self.trembling_steps_duration = self.ability:GetSpecialValueFor("trembling_steps_duration")
		self.trembling_steps_slow_pct = self.ability:GetSpecialValueFor("trembling_steps_slow_pct")
		self.trembling_steps_radius_pct = self.ability:GetSpecialValueFor("trembling_steps_radius_pct")
		self.trembling_steps_damage = self.ability:GetSpecialValueFor("trembling_steps_damage")
		self.trembling_steps_cooldown = self.ability:GetSpecialValueFor("trembling_steps_cooldown")

		-- Calculate radius
		self.radius = self.base_radius * self.trembling_steps_radius_pct

		-- #2 Talent: Every x points in Strength improves the cooldown of Earthshock's Trembling Steps cooldown
		if self.caster:HasTalent("special_bonus_imba_ursa_2") then
			local cooldown_improvement = self.caster:FindTalentValue("special_bonus_imba_ursa_2", "cooldown_improvement")
			local strength_per_cd = self.caster:FindTalentValue("special_bonus_imba_ursa_2", "strength_per_cd")
			local threshold = self.caster:FindTalentValue("special_bonus_imba_ursa_2", "threshold")

			-- Get Ursa's Strength
			local strength = self.caster:GetStrength()

			-- Calculate cooldown improvement
			local cd_reduction = math.floor(strength / strength_per_cd) * cooldown_improvement

			-- Value cannot exceed the maximum cooldown improvement
			if cd_reduction > threshold then
				cd_reduction = threshold
			end

			self.trembling_steps_cooldown = self.trembling_steps_cooldown - cd_reduction
		end
	end
end

function modifier_imba_trembling_steps_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_UNIT_MOVED}

	return decFuncs
end


function modifier_imba_trembling_steps_buff:OnUnitMoved()
	if IsServer() then

		-- Mark last position to find real movements
		if self.caster.last_position == nil then
			self.caster.last_position = self.caster:GetAbsOrigin()
		else
			if self.caster:GetAbsOrigin() - self.caster.last_position == Vector(0,0,0) then
				return nil
			else
				self.caster.last_position = self.caster:GetAbsOrigin()
			end
		end

		-- Check if ursa has prevent modifier, if so, do nothing
		if self.caster:HasModifier(self.trembling_steps_prevent) then
			return nil
		end

		-- Apply prevent modifier
		self.caster:AddNewModifier(self.caster, self.ability, self.trembling_steps_prevent, {duration = self.trembling_steps_cooldown})

		-- Play cast sound
		EmitSoundOn(self.sound_step, self.caster)

		-- Add particles
		local particle_step_fx = ParticleManager:CreateParticle(self.particle_step, PATTACH_ABSORIGIN, self.caster)
		ParticleManager:SetParticleControl(particle_step_fx, 0, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_step_fx, 1, Vector(1,1,1))
		ParticleManager:ReleaseParticleIndex(particle_step_fx)

		-- Find all units in AoE
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
			self.caster:GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)


		for _,enemy in pairs(enemies) do
			-- Damage units
			if not enemy:IsMagicImmune() then
				local damageTable = {victim = enemy,
					attacker = self.caster,
					damage = self.trembling_steps_damage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = self.ability}

				ApplyDamage(damageTable)
			end

			-- Apply trembling steps debuff to units
			enemy:AddNewModifier(self.caster, self.ability, self.trembling_steps_debuff, {duration = self.trembling_steps_duration})
		end
	end
end

function modifier_imba_trembling_steps_buff:IsDebuff()
	return false
end

function modifier_imba_trembling_steps_buff:IsHidden()
	return false
end

function modifier_imba_trembling_steps_buff:IsPurgable()
	return false
end


-- Trembling Steps prevention modifier
modifier_imba_trembling_steps_prevent = class({})

function modifier_imba_trembling_steps_prevent:IsDebuff()
	return false
end

function modifier_imba_trembling_steps_prevent:IsHidden()
	return true
end

function modifier_imba_trembling_steps_prevent:IsPurgable()
	return false
end

-- Trembling Steps slow debuff
modifier_imba_trembling_steps_debuff = class({})

function modifier_imba_trembling_steps_debuff:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_earthshock_modifier.vpcf"
end

function modifier_imba_trembling_steps_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_trembling_steps_debuff:IsDebuff()
	return true
end

function modifier_imba_trembling_steps_debuff:IsHidden()
	return false
end

function modifier_imba_trembling_steps_debuff:IsPurgable()
	return true
end

function modifier_imba_trembling_steps_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_imba_trembling_steps_debuff:GetModifierMoveSpeedBonus_Percentage()
	local ability = self:GetAbility()
	local trembling_steps_slow_pct = ability:GetSpecialValueFor("trembling_steps_slow_pct")

	return trembling_steps_slow_pct * (-1)
end





---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Ursa's Overpower
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_ursa_overpower = class({})
LinkLuaModifier("modifier_imba_overpower_buff", "components/abilities/heroes/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_overpower_disarm", "components/abilities/heroes/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_overpower_talent_fangs", "components/abilities/heroes/hero_ursa", LUA_MODIFIER_MOTION_NONE)

function imba_ursa_overpower:GetBehavior()
	-- #8 Talent: Overpower becomes a passive, allowing Ursa to use it as he attacks.
	if self:GetCaster():HasTalent("special_bonus_imba_ursa_8") then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	end
end

function imba_ursa_overpower:GetIntrinsicModifierName()
	-- #8 Talent: Overpower becomes a passive, allowing Ursa to use it as he attacks.
	if self:GetCaster():HasTalent("special_bonus_imba_ursa_8") then
		return "modifier_imba_overpower_talent_fangs"
	else
		return nil
	end
end

function imba_ursa_overpower:GetManaCost(level)
	-- #8 Talent: Overpower becomes a passive, allowing Ursa to use it as he attacks.
	if self:GetCaster():HasTalent("special_bonus_imba_ursa_8") then
		return nil
	else
		return self.BaseClass.GetManaCost(self, level)
	end
end

function imba_ursa_overpower:GetAbilityTextureName()
	return "ursa_overpower"
end

function imba_ursa_overpower:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self
		local aspd_buff =  "modifier_imba_overpower_buff"
		local sound_cast = "Hero_Ursa.Overpower"

		-- Ability specials
		local attacks_num = ability:GetSpecialValueFor("attacks_num")
		local aspd_duration = ability:GetSpecialValueFor("aspd_duration")

		-- Play cast sound
		EmitSoundOn(sound_cast, caster)

		-- Get pissed blyat (thanks again Valve)
		caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)

		-- Remove existing attack speed buff
		if caster:HasModifier(aspd_buff) then
			caster:RemoveModifierByName(aspd_buff)
		end

		-- Apply attack speed buff to caster, add stacks
		caster:AddNewModifier(caster, ability, aspd_buff, {duration = aspd_duration})
		caster:SetModifierStackCount(aspd_buff, caster, attacks_num)

		-- Disarm enemies!
		self:DisarmEnemies(caster, ability)
	end
end

function imba_ursa_overpower:DisarmEnemies(caster, ability)
	if IsServer() then
		-- Ability properties
		local disarm_debuff = "modifier_imba_overpower_disarm"
		local enrage_ability = caster:FindAbilityByName("imba_ursa_enrage")
		local enrage_buff = "modifier_imba_enrage_buff"
		local disarm_particle = "particles/hero/ursa/enrage_overpower.vpcf"

		-- Ability specials
		local disarm_radius = ability:GetSpecialValueFor("disarm_radius")
		local disarm_duration = ability:GetSpecialValueFor("disarm_duration")

		-- Find disarm radius increase
		local enrage_disarm_radius = 0
		if enrage_ability then
			enrage_disarm_radius = enrage_ability:GetSpecialValueFor("bonus_radius_skills")
		end

		-- Increase disarm radius if caster is enraged
		if caster:HasModifier(enrage_buff) then
			disarm_radius = disarm_radius + enrage_disarm_radius
		end

		-- Add Disarm particles
		local disarm_particle_fx = ParticleManager:CreateParticle(disarm_particle, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(disarm_particle_fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(disarm_particle_fx, 1, Vector(disarm_radius, 0, 0))
		ParticleManager:SetParticleControl(disarm_particle_fx, 3, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(disarm_particle_fx)

		-- Find enemy units in the AoE
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
			nil,
			disarm_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		-- Apply Disarm for the duration
		for _,enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() then
				enemy:AddNewModifier(caster, ability, disarm_debuff, {duration = disarm_duration})
			end
		end
	end
end


-- Overpower attack speed buff
modifier_imba_overpower_buff = class({})

function modifier_imba_overpower_buff:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.ursa_overpower_buff_particle = "particles/units/heroes/hero_ursa/ursa_overpower_buff.vpcf"

		local ursa_overpower_buff_particle_fx = ParticleManager:CreateParticle(self.ursa_overpower_buff_particle, PATTACH_CUSTOMORIGIN, self.caster)
		ParticleManager:SetParticleControlEnt(ursa_overpower_buff_particle_fx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_head", self.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(ursa_overpower_buff_particle_fx, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(ursa_overpower_buff_particle_fx, 2, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(ursa_overpower_buff_particle_fx, 3, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
		self:AddParticle(ursa_overpower_buff_particle_fx, false, false, -1, false, false)

		-- #8 Talent: Overpower becomes a passive, allowing Ursa to proc Overpower as he attacks
		-- Ursa loses his attack limit when in this state, instead attacking based on the duration of the buff
		if self.caster:HasTalent("special_bonus_imba_ursa_8") then
			self.overpower_talent = true
		end
	end
end

function modifier_imba_overpower_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_overpower_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_overpower.vpcf"
end

function modifier_imba_overpower_buff:IsDebuff()
	return false
end

function modifier_imba_overpower_buff:IsHidden()
	return false
end

function modifier_imba_overpower_buff:IsPurgable()
	return true
end

function modifier_imba_overpower_buff:StatusEffectPriority()
	return 10
end

function modifier_imba_overpower_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK}
	return decFuncs
end

function modifier_imba_overpower_buff:GetModifierAttackSpeedBonus_Constant()
	local ability = self:GetAbility()
	local attack_speed_bonus = ability:GetSpecialValueFor("attack_speed_bonus")

	return attack_speed_bonus
end

function modifier_imba_overpower_buff:OnAttack( keys )
	local caster = self:GetCaster()

	-- If Ursa has #8 Talent, he doesn't consume stacks
	if self.overpower_talent then
		return nil
	end

	if keys.attacker == caster then
		local current_stacks = self:GetStackCount()

		if current_stacks > 1 then
			self:DecrementStackCount()
		else
			self:Destroy()
		end
	end
end

-- Overpower disarm debuff
modifier_imba_overpower_disarm = class({})

function modifier_imba_overpower_disarm:GetEffectName()
	return "particles/generic_gameplay/generic_disarm.vpcf"
end

function modifier_imba_overpower_disarm:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_overpower_disarm:IsDebuff()
	return true
end

function modifier_imba_overpower_disarm:IsHidden()
	return false
end

function modifier_imba_overpower_disarm:IsPurgable()
	return true
end

function modifier_imba_overpower_disarm:CheckState()
	-- #6 Talent: Overpower also roots targets in addition to disarming them.
	local state
	if self:GetCaster():HasTalent("special_bonus_imba_ursa_6") then
		state = {[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_ROOTED] = true}
	else
		state = {[MODIFIER_STATE_DISARMED] = true}
	end

	return state
end


-- #8 Talent: Overpower becomes a passive, allowing Ursa to proc Overpower as he attacks

LinkLuaModifier("modifier_special_bonus_imba_ursa_8", "components/abilities/heroes/hero_ursa.lua", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_ursa_8 = modifier_special_bonus_imba_ursa_8 or class({})

function modifier_special_bonus_imba_ursa_8:IsHidden() return true end
function modifier_special_bonus_imba_ursa_8:RemoveOnDeath() return false end

function modifier_special_bonus_imba_ursa_8:OnCreated()
	if IsServer() then
		local ability = self:GetCaster():FindAbilityByName("imba_ursa_overpower")

		if ability then
			self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_imba_overpower_talent_fangs", {})
		end
	end
end


modifier_imba_overpower_talent_fangs = modifier_imba_overpower_talent_fangs or class({})

function modifier_imba_overpower_talent_fangs:IsHidden() return false end
function modifier_imba_overpower_talent_fangs:IsPurgable() return false end
function modifier_imba_overpower_talent_fangs:IsDebuff() return false end
function modifier_imba_overpower_talent_fangs:RemoveOnDeath() return false end

function modifier_imba_overpower_talent_fangs:OnCreated()
	if IsServer() then
		-- Talent properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.sound_cast = "Hero_Ursa.Overpower"
		self.modifier_overpower = "modifier_imba_overpower_buff"

		-- Talent specials
		self.duration = self.caster:FindTalentValue("special_bonus_imba_ursa_8")
	end
end

function modifier_imba_overpower_talent_fangs:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_START}

	return decFuncs
end

function modifier_imba_overpower_talent_fangs:OnAttackStart(keys)
	if IsServer() then
		local attacker = keys.attacker

		-- Only apply when Ursa is the one attacking
		if attacker == self.caster then

			-- If the ability is on cooldown, do nothing
			if not self.ability:IsCooldownReady() then
				return nil
			end

			-- If Ursa is broken, do nothing
			if self.caster:PassivesDisabled() then
				return nil
			end

			-- Apply Overpower to Ursa for the duration
			self.caster:AddNewModifier(self.caster, self.ability, self.modifier_overpower, {duration = self.duration})

			-- Play sound
			EmitSoundOn(self.sound_cast, self.caster)

			-- Disarm enemies
			self.ability:DisarmEnemies(self.caster, self.ability)

			-- Trigger the cooldown of the ability
			self.ability:UseResources(false, false, true)
		end
	end
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Ursa's Fury Swipes
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_ursa_fury_swipes = class({})
LinkLuaModifier("modifier_imba_fury_swipes", "components/abilities/heroes/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fury_swipes_debuff", "components/abilities/heroes/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fury_swipes_talent_ripper", "components/abilities/heroes/hero_ursa", LUA_MODIFIER_MOTION_NONE)

function imba_ursa_fury_swipes:GetAbilityTextureName()
	return "ursa_fury_swipes"
end

function imba_ursa_fury_swipes:GetIntrinsicModifierName()
	return "modifier_imba_fury_swipes"
end


-- Fury swipes debuff
modifier_imba_fury_swipes_debuff = class({})

function modifier_imba_fury_swipes_debuff:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end

function modifier_imba_fury_swipes_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_fury_swipes_debuff:IsDebuff()
	return true
end

function modifier_imba_fury_swipes_debuff:IsHidden()
	return false
end

function modifier_imba_fury_swipes_debuff:IsPurgable()
	return false
end

-- Fury Swipes modifier buff
modifier_imba_fury_swipes = class({})

function modifier_imba_fury_swipes:IsDebuff()
	return false
end

function modifier_imba_fury_swipes:IsHidden()
	return true
end

function modifier_imba_fury_swipes:IsPurgable()
	return false
end

function modifier_imba_fury_swipes:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	}
	return decFuncs
end

function modifier_imba_fury_swipes:GetModifierProcAttack_BonusDamage_Physical( keys )
	-- Ability properties
	if IsServer() then
		local caster = self:GetCaster()
		local target = keys.target
		local ability = self:GetAbility()
		local swipes_particle = "particles/units/heroes/hero_ursa/ursa_fury_swipes.vpcf"
		local fury_swipes_debuff = "modifier_imba_fury_swipes_debuff"
		local deep_strike_particle = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf"
		local sound_deep_strike = "Imba.UrsaDeepStrike"
		local enrage_ability = caster:FindAbilityByName("imba_ursa_enrage")
		local enrage_buff = "modifier_imba_enrage_buff"

		-- Ability specials
		local damage_per_stack = ability:GetSpecialValueFor("damage_per_stack")
		local stack_duration = ability:GetSpecialValueFor("stack_duration")
		local roshan_stack_duration = ability:GetSpecialValueFor("roshan_stack_duration")
		local deep_stack_multiplier = ability:GetSpecialValueFor("deep_stack_multiplier")
		local deep_stack_attacks = ability:GetSpecialValueFor("deep_stack_attacks")
		local enrage_swipes_multiplier = enrage_ability:GetSpecialValueFor("fury_swipes_multiplier")

		-- If the caster is broken, do nothing
		if caster:PassivesDisabled() then
			return nil
		end

		if keys.attacker == caster then
			-- Adjust duration if target is Roshan
			if target:IsRoshan() then
				stack_duration = roshan_stack_duration
			end

			-- If the target is a building, do nothing
			if target:IsBuilding() then
				return nil
			end

			-- Initialize variables
			local fury_swipes_debuff_handler
			local damage
			-- Add debuff/increment stacks if already exists
			if target:HasModifier(fury_swipes_debuff) then
				fury_swipes_debuff_handler = target:FindModifierByName(fury_swipes_debuff)
				fury_swipes_debuff_handler:IncrementStackCount()
			else
				target:AddNewModifier(caster, ability, fury_swipes_debuff, {duration = stack_duration})
				fury_swipes_debuff_handler = target:FindModifierByName(fury_swipes_debuff)
				fury_swipes_debuff_handler:IncrementStackCount()
			end

			-- Refresh stack duration
			fury_swipes_debuff_handler:ForceRefresh()

			-- Add fury swipe impact particle
			local swipes_particle_fx = ParticleManager:CreateParticle(swipes_particle, PATTACH_ABSORIGIN, target)
			ParticleManager:SetParticleControl(swipes_particle_fx, 0, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(swipes_particle_fx)

			-- Get stack count
			local fury_swipes_stacks = fury_swipes_debuff_handler:GetStackCount()

			-- Calculate damage
			damage = damage_per_stack * fury_swipes_stacks

			-- Check for Enrage's multiplier
			if caster:HasModifier(enrage_buff) then
				damage = damage * enrage_swipes_multiplier
			end

			-- Check for Deep Strike modifier, modify damage, apply particle and play sound if present
			if fury_swipes_stacks % deep_stack_attacks == 0 then --divides with no remainder
				damage = damage * (deep_stack_multiplier * 0.01)

				-- #5 Talent: If the target has more than the threshold, Devastating Blow deals a bonus of the target's maximum health.
				if caster:HasTalent("special_bonus_imba_ursa_5") then
					local maximum_health_dmg = caster:FindTalentValue("special_bonus_imba_ursa_5", "maximum_health_dmg")
					local health_threshold_pct = caster:FindTalentValue("special_bonus_imba_ursa_5", "health_threshold_pct")

					-- Get target's current health and see if it's above the treshold
					local health_pct = target:GetHealthPercent()

					-- If the target's health is above the threshold, deal bonus damage
					if health_pct >= health_threshold_pct then
						local maximum_health = target:GetMaxHealth()

						-- Add damage according to maximum health
						damage = damage + maximum_health * maximum_health_dmg * 0.01
					end
				end

				local deep_strike_particle_fx = ParticleManager:CreateParticle(deep_strike_particle, PATTACH_ABSORIGIN, target)
				ParticleManager:SetParticleControl(deep_strike_particle_fx, 0, target:GetAbsOrigin())
				ParticleManager:SetParticleControl(deep_strike_particle_fx, 1, target:GetAbsOrigin())
				ParticleManager:SetParticleControl(deep_strike_particle_fx, 3, target:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(deep_strike_particle_fx)

				EmitSoundOn(sound_deep_strike, caster)

				-- #4 Talent: Fury Swipes' Devastating Blow reduces the armor of the target. Stackable and refreshable.
				if caster:HasTalent("special_bonus_imba_ursa_4") then
					local talent_duration = caster:FindTalentValue("special_bonus_imba_ursa_4", "duration")
					local armor_reduction = caster:FindTalentValue("special_bonus_imba_ursa_4", "armor_reduction")

					-- If the target doesn't have the armor debuff yet, add it to it
					if not target:HasModifier("modifier_imba_fury_swipes_talent_ripper") then
						target:AddNewModifier(caster, ability, "modifier_imba_fury_swipes_talent_ripper", {duration = talent_duration})
					end

					-- Find handle, increase stacks
					local modifier_ripper_handler = target:FindModifierByName("modifier_imba_fury_swipes_talent_ripper")
					if modifier_ripper_handler then
						modifier_ripper_handler:SetStackCount(modifier_ripper_handler:GetStackCount() + armor_reduction)
						modifier_ripper_handler:ForceRefresh()
					end
				end
			end

			return damage
		end
	end
end

-- #4 Talent: Ripper Claw modifier
modifier_imba_fury_swipes_talent_ripper = modifier_imba_fury_swipes_talent_ripper or class({})

function modifier_imba_fury_swipes_talent_ripper:IsHidden() return false end
function modifier_imba_fury_swipes_talent_ripper:IsPurgable() return true end
function modifier_imba_fury_swipes_talent_ripper:IsDebuff() return true end

function modifier_imba_fury_swipes_talent_ripper:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}

	return decFuncs
end

function modifier_imba_fury_swipes_talent_ripper:GetModifierPhysicalArmorBonus()
	return self:GetStackCount() * (-1)
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			       Ursa's Enrage
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_ursa_enrage = class({})
LinkLuaModifier("modifier_imba_enrage_buff", "components/abilities/heroes/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enrage_talent_buff", "components/abilities/heroes/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_talent_enrage_damage", "components/abilities/heroes/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_talent_enrage_prevent", "components/abilities/heroes/hero_ursa", LUA_MODIFIER_MOTION_NONE)

function imba_ursa_enrage:GetAbilityTextureName()
	return "ursa_enrage"
end

function imba_ursa_enrage:GetIntrinsicModifierName() return "modifier_imba_talent_enrage_damage" end

function imba_ursa_enrage:GetCooldown(level)
	local caster = self:GetCaster()
	local ability = self
	local scepter = caster:HasScepter()

	local cooldown = self.BaseClass.GetCooldown(self, level)
	local scepter_cooldown = ability:GetSpecialValueFor("scepter_cooldown")

	if scepter then
		return scepter_cooldown
	end

	return cooldown
end

function imba_ursa_enrage:GetBehavior()
	local scepter = self:GetCaster():HasScepter()

	if not scepter then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
	end
end

function imba_ursa_enrage:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_cast = "Hero_Ursa.Enrage"
	local enrage_buff = "modifier_imba_enrage_buff"
	local enrage_talent_buff = "modifier_imba_enrage_talent_buff"

	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")

	-- Roar, baby, roar. CAUSE CAST ANIMATIONS ARE BROKEN LEL GG VALVE
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)

	-- Apply strong purge
	caster:Purge(false, true, false, true, true) --don't remove buffs, remove debuffs, not only on this frame, purges stuns.

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Apply enrage buff
	caster:AddNewModifier(caster, ability, enrage_buff, {duration = duration})

	-- #7 Talent: Enrage adds a portion of your current health as damage
	if caster:HasTalent("special_bonus_imba_ursa_7") then
		caster:AddNewModifier(caster, ability, enrage_talent_buff, {duration = duration})
	end
end


-- Enrage active buff
modifier_imba_enrage_buff = class({})

function modifier_imba_enrage_buff:AllowIllusionDuplicate()
	return false
end

function modifier_imba_enrage_buff:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

function modifier_imba_enrage_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_enrage_buff:IsDebuff()
	return false
end

function modifier_imba_enrage_buff:IsHidden()
	return false
end

function modifier_imba_enrage_buff:IsPurgable()
	return false
end

function modifier_imba_enrage_buff:OnCreated()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local reduce_cd_interval = ability:GetSpecialValueFor("reduce_cd_interval")

	if IsServer() then
		caster:SetRenderColor(255,0,0)
	end

	self:StartIntervalThink(reduce_cd_interval)
end

function modifier_imba_enrage_buff:OnDestroy()
	local caster = self:GetCaster()

	if IsServer() then
		caster:SetRenderColor(255,255,255)
	end
end

function modifier_imba_enrage_buff:OnIntervalThink()
	-- Ability properties
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local ability_earthshock = caster:FindAbilityByName("imba_ursa_earthshock")
		local ability_overpower = caster:FindAbilityByName("imba_ursa_overpower")

		-- Ability specials
		local reduce_cd_amount = ability:GetSpecialValueFor("reduce_cd_amount")

		-- Find current CD of skills, lower it if above reduction, else refresh	it
		if ability_earthshock then
			local ability_earthshock_cd = ability_earthshock:GetCooldownTimeRemaining()
			ability_earthshock:EndCooldown()
			if ability_earthshock_cd > reduce_cd_amount then
				ability_earthshock:StartCooldown(ability_earthshock_cd - reduce_cd_amount)
			end
		end

		if ability_overpower then
			local ability_overpower_cd = ability_overpower:GetCooldownTimeRemaining()
			ability_overpower:EndCooldown()
			if ability_overpower_cd > reduce_cd_amount then
				ability_overpower:StartCooldown(ability_overpower_cd - reduce_cd_amount)
			end
		end
	end
end

function modifier_imba_enrage_buff:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
	return decFuncs
end

function modifier_imba_enrage_buff:GetModifierModelScale()
	return 40
end

function modifier_imba_enrage_buff:GetModifierIncomingDamage_Percentage()
	local ability = self:GetAbility()
	local damage_reduction = ability:GetSpecialValueFor("damage_reduction")
	return damage_reduction * (-1)
end

function modifier_imba_enrage_buff:GetModifierStatusResistanceStacking()
	return self:GetAbility():GetSpecialValueFor("damage_reduction")
end

-- #7 Talent: Increases Ursa's damage as a portion of his current health
modifier_imba_enrage_talent_buff = modifier_imba_enrage_talent_buff or class({})

function modifier_imba_enrage_talent_buff:IsHidden() return true end
function modifier_imba_enrage_talent_buff:IsPurgable() return false end
function modifier_imba_enrage_talent_buff:IsDebuff() return false end

function modifier_imba_enrage_talent_buff:OnCreated()
	if IsServer() then
		-- Talent properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()

		-- Talent specials
		self.health_to_damage_pct = self.caster:FindTalentValue("special_bonus_imba_ursa_7")

		-- Start ticking, calculate stacks
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_enrage_talent_buff:OnIntervalThink()
	if IsServer() then
		-- Get current health
		local current_health = self.caster:GetHealth()

		-- Calculate damage according to current health
		local damage_bonus = self.health_to_damage_pct * current_health * 0.01

		-- Set as stacks on this modifier
		self:SetStackCount(damage_bonus)
	end
end

function modifier_imba_enrage_talent_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}

	return decFuncs
end

function modifier_imba_enrage_talent_buff:GetModifierPreAttack_BonusDamage(keys)
	return self:GetStackCount()
end


-- #1 Talent: When taking the talent, get the modifier

LinkLuaModifier("modifier_special_bonus_imba_ursa_1", "components/abilities/heroes/hero_ursa.lua", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_ursa_1 = modifier_special_bonus_imba_ursa_1 or class({})

function modifier_special_bonus_imba_ursa_1:IsHidden() return true end
function modifier_special_bonus_imba_ursa_1:RemoveOnDeath() return false end

function modifier_special_bonus_imba_ursa_1:OnCreated()
	if IsServer() then
		local ability = self:GetParent():FindAbilityByName("imba_ursa_enrage")
		if ability then
			self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_imba_talent_enrage_damage", {})
		end
	end
end

-- Enrage talent damage counter modifier
modifier_imba_talent_enrage_damage = class({})

function modifier_imba_talent_enrage_damage:OnCreated()
	if IsServer() then
		-- Talent properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.prevent_modifier = "modifier_imba_talent_enrage_prevent"
	end
end

function modifier_imba_talent_enrage_damage:OnIntervalThink()
	if IsServer() then
		-- Check if it's past the damage reset time
		local gametime = GameRules:GetGameTime()

		if (gametime - self.last_damage_instance_time) > self.damage_reset then
			-- Reset stacks
			self:SetStackCount(self.damage_threshold)

			-- Disable timer
			self:StartIntervalThink(-1)
		end
	end
end

function modifier_imba_talent_enrage_damage:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_TAKEDAMAGE}
	return decFuncs
end

function modifier_imba_talent_enrage_damage:IsHidden()
	-- If Ursa didn't learn Enrage yet, hide it
	if not self:GetCaster():HasTalent("special_bonus_imba_ursa_1") then
		return true
	end

	-- Show the buff only when Ursa doesn't have the prevention modifier
	if not self:GetCaster():HasModifier("modifier_imba_talent_enrage_prevent") then
		return false
	end

	return true
end

function modifier_imba_talent_enrage_damage:RemoveOnDeath()
	return false
end

function modifier_imba_talent_enrage_damage:IsPurgable()
	return false
end

function modifier_imba_talent_enrage_damage:IsDebuff()
	return false
end

function modifier_imba_talent_enrage_damage:OnTakeDamage( keys )
	if IsServer() then
		local target = keys.unit
		local damage_taken = keys.damage

		-- Only apply if the target taking damage is the caster
		if target == self.caster then
			if not self.caster:HasTalent("special_bonus_imba_ursa_1") then
				return nil
			end

			-- Talent specials
			if not self.damage_threshold or not self.damage_reset or not self.enrage_cooldown then
				self.damage_threshold = self.caster:FindTalentValue("special_bonus_imba_ursa_1", "damage_threshold")
				self.damage_reset = self.caster:FindTalentValue("special_bonus_imba_ursa_1", "damage_reset")
				self.enrage_cooldown = self.caster:FindTalentValue("special_bonus_imba_ursa_1", "enrage_cooldown")
			end

			-- If Ursa is broken, do nothing: don't count damage, don't trigger, etc)
			if self.caster:PassivesDisabled() then
				return nil
			end

			-- If Ursa doesn't have Enrage at least level 1, do nothing
			if self.ability:GetLevel() <= 0 then
				return nil
			end

			-- If Ursa has the prevention modifier, do nothing
			if self.caster:HasModifier(self.prevent_modifier) then
				self:StartIntervalThink(-1)
				return nil
			end

			-- Store/Update the time of the damage instance
			self.last_damage_instance_time = GameRules:GetGameTime()

			-- Check if there are enough stacks to keep going, or Enrage is triggered (get it?)
			if self:GetStackCount() > damage_taken then
				self:SetStackCount(self:GetStackCount() - damage_taken)

				-- Tick the timer
				self:StartIntervalThink(0.25)
			else
				self.caster:AddNewModifier(self.caster, self.ability, self.prevent_modifier, {duration = self.enrage_cooldown})
				self.ability:OnSpellStart()

				-- Reset stack count
				self:SetStackCount(self.damage_threshold)

				-- Disable the timer
				self:StartIntervalThink(-1)
			end
		end
	end
end


modifier_imba_talent_enrage_prevent = class({})

function modifier_imba_talent_enrage_prevent:IsHidden()
	return false
end

function modifier_imba_talent_enrage_prevent:IsPurgable()
	return false
end






---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Ursa's Territorial Hunter
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_ursa_territorial_hunter = class({})
LinkLuaModifier("modifier_terrorital_hunter_aura", "components/abilities/heroes/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_terrorital_hunter_fogvision", "components/abilities/heroes/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_terrorital_hunter_talent_tenacity", "components/abilities/heroes/hero_ursa", LUA_MODIFIER_MOTION_NONE)

function imba_ursa_territorial_hunter:GetAbilityTextureName()
	return "custom/territorial_hunter"
end

function imba_ursa_territorial_hunter:IsInnateAbility()
	return true
end

function imba_ursa_territorial_hunter:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self
		local target = self:GetCursorTarget()
		local aura = "modifier_terrorital_hunter_aura"

		-- Kill previous dummy, if exists
		if ability.territorial_aura_modifier then
			ability.territorial_aura_modifier:Destroy()
		end

		ability.territorial_tree = target

		-- Create Modifier Thinker
		ability.territorial_aura_modifier = CreateModifierThinker(caster, ability, aura, {}, ability.territorial_tree:GetAbsOrigin(), caster:GetTeamNumber(), false)
		ability.territorial_aura_modifier:AddRangeIndicator(caster, ability, "vision_range", nil, 200, 160, 100, true, true, false)
	end
end

-- Territorial Hunter aura modifier
modifier_terrorital_hunter_aura = class({})

function modifier_terrorital_hunter_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_talent = "modifier_terrorital_hunter_talent_tenacity"

	-- Ability specials
	self.vision_range = self.ability:GetSpecialValueFor("vision_range")

	-- Start interval
	self:StartIntervalThink(0.2)
end

function modifier_terrorital_hunter_aura:OnIntervalThink()
	if IsServer() then

		-- Check if tree is cut down, kill dummy if it is
		if not self.ability.territorial_tree:IsStanding() then
			self.ability.territorial_aura_modifier:Destroy()
			self.ability.territorial_aura_modifier = nil
		end

		-- #3 Talent: Territorial Hunter grants Tenacity to Ursa in its AoE, and has its cooldown refreshed if Ursa kills an enemy hero in it
		if self:GetCaster():HasTalent("special_bonus_imba_ursa_3") then

			-- Find if Ursa is in range of the aura
			local distance = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()

			-- If Ursa is in aura range and doesn't have the Tenacity bonus, add it
			if not self:GetCaster():HasModifier(self.modifier_talent) and distance <= self.vision_range then
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), self.modifier_talent , {})
			end

			-- If Ursa is too far and it has the Tenacity bonus, remove it
			if self:GetCaster():HasModifier(self.modifier_talent) and distance > self.vision_range then
				self:GetCaster():RemoveModifierByName(self.modifier_talent)
			end
		end
	end
end

function modifier_terrorital_hunter_aura:OnDestroy()
	self:StartIntervalThink(-1)
end

function modifier_terrorital_hunter_aura:GetAuraRadius()
	return self.vision_range
end

function modifier_terrorital_hunter_aura:IsAura()
	return true
end

function modifier_terrorital_hunter_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_terrorital_hunter_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_terrorital_hunter_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_terrorital_hunter_aura:GetModifierAura()
	return "modifier_terrorital_hunter_fogvision"
end

function modifier_terrorital_hunter_aura:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end

function modifier_terrorital_hunter_aura:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_terrorital_hunter_aura:CheckState()
	local state = {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true}
	return state
end

function modifier_terrorital_hunter_aura:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_VISUAL_Z_DELTA}

	return decFuncs
end

function modifier_terrorital_hunter_aura:GetVisualZDelta()
	return 350
end

-- Territorial Hunter debuff
modifier_terrorital_hunter_fogvision = class({})

function modifier_terrorital_hunter_fogvision:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_terrorital_hunter_fogvision:IsHidden()
	return true
end

function modifier_terrorital_hunter_fogvision:OnCreated()
	if IsServer() then
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_terrorital_hunter_fogvision:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_EVENT_ON_STATE_CHANGED,
		MODIFIER_EVENT_ON_HERO_KILLED}

	return funcs
end

-- Reveal from fog
function modifier_terrorital_hunter_fogvision:GetModifierProvidesFOWVision()
	return 1
end

-- Invis particle handling
function modifier_terrorital_hunter_fogvision:OnStateChanged()
	if self:GetParent():IsImbaInvisible() and not self.applied_particle then
		self.invis_particle_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.invis_particle_fx, 0, caster, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self.applied_particle = true
	elseif not self:GetParent():IsImbaInvisible() and self.invis_particle_fx then
		ParticleManager:DestroyParticle(self.invis_particle_fx, false)
		ParticleManager:ReleaseParticleIndex(self.invis_particle_fx)
		self.applied_particle = false
	end
end

function modifier_terrorital_hunter_fogvision:OnHeroKilled(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply if the attacker is Ursa and it killed the parent of this modifier
		if attacker == self:GetCaster() and target == self:GetParent() then

			-- Refresh the Territorial Hunter ability's cooldown
			self:GetAbility():EndCooldown()
		end
	end
end

-- #3 Talent: Tenacity bonus to Ursa
modifier_terrorital_hunter_talent_tenacity = modifier_terrorital_hunter_talent_tenacity or class({})

function modifier_terrorital_hunter_talent_tenacity:IsHidden() return false end
function modifier_terrorital_hunter_talent_tenacity:IsPurgable() return false end
function modifier_terrorital_hunter_talent_tenacity:IsDebuff() return false end

function modifier_terrorital_hunter_talent_tenacity:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}

	return decFuncs
end

function modifier_terrorital_hunter_talent_tenacity:OnCreated()
	self.tenacity_bonus = self:GetCaster():FindTalentValue("special_bonus_imba_ursa_3", "tenacity_bonus")
end

function modifier_terrorital_hunter_talent_tenacity:GetModifierStatusResistanceStacking()
	return self.tenacity_bonus
end
