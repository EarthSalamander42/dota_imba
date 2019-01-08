-- Editors:
--     Shush, 26.03.2017

-------------------------------
--        STARSTORM          --
-------------------------------

imba_mirana_starfall = class({})
LinkLuaModifier("modifier_imba_starfall_scepter_thinker", "components/abilities/heroes/hero_mirana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_starfall_talent_seed_debuff", "components/abilities/heroes/hero_mirana", LUA_MODIFIER_MOTION_NONE)

function imba_mirana_starfall:GetAbilityTextureName()
	return "mirana_starfall"
end

function imba_mirana_starfall:GetIntrinsicModifierName()
	return "modifier_imba_starfall_scepter_thinker"
end

function imba_mirana_starfall:IsHiddenWhenStolen()
	return false
end

function imba_mirana_starfall:OnUnStolen()
	local modifier_agh_starfall = "modifier_imba_starfall_scepter_thinker"

	-- Remove modifier from Rubick when he loses the spell
	if self:GetCaster():HasModifier(modifier_agh_starfall) then
		self:GetCaster():RemoveModifierByName(modifier_agh_starfall)
	end
end

function imba_mirana_starfall:OnSpellStart()
	-- Ability properties
	local ability = self
	local particle_circle = "particles/units/heroes/hero_mirana/mirana_starfall_circle.vpcf"
	local particle_moon = "particles/units/heroes/hero_mirana/mirana_moonlight_owner.vpcf"
	local cast_response = "mirana_mir_ability_star_0"
	local sound_cast = "Ability.Starfall"

	-- Ability specials
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("damage")
	local secondary_damage_pct = ability:GetSpecialValueFor("secondary_damage_pct")
	local additional_waves_count = ability:GetSpecialValueFor("additional_waves_count")
	local additional_waves_dmg_pct = ability:GetSpecialValueFor("additional_waves_dmg_pct")
	local additional_waves_interval = ability:GetSpecialValueFor("additional_waves_interval")

	-- Roll cast response for "longer" line
	if RollPercentage(10) then
		cast_response = cast_response..3
		EmitSoundOn(cast_response, self:GetCaster())

	elseif RollPercentage(75) then -- If it failed, roll for normal cast response
		cast_response = cast_response..math.random(1,2)
		EmitSoundOn(cast_response, self:GetCaster())
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, self:GetCaster())

	-- Assign caster's location on cast, since the waves do not move with Mirana
	local caster_position = self:GetCaster():GetAbsOrigin()

	-- Add circle particle, repeat it every second until all waves came down
	local repeats = additional_waves_count * additional_waves_interval
	local current_instance = 0

	-- Start repeating
	Timers:CreateTimer(function()
		local particle_circle_fx = ParticleManager:CreateParticle(particle_circle, PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(particle_circle_fx, 0, caster_position)
		ParticleManager:ReleaseParticleIndex(particle_circle_fx)

		current_instance = current_instance + 1

		-- If there are still waves incoming, repeat the particle creation
		if current_instance <= repeats then
			return 1
		else
			return nil
		end
	end)

	-- Add moon particle
	local particle_moon_fx = ParticleManager:CreateParticle(particle_moon, PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_moon_fx, 0, Vector(caster_position.x, caster_position.y, caster_position.z + 400))

	-- Remove moon particle after the duration elapsed
	Timers:CreateTimer(repeats, function()
		ParticleManager:DestroyParticle(particle_moon_fx, false)
		ParticleManager:ReleaseParticleIndex(particle_moon_fx)
	end)

	-- First Starfall wave
	StarfallWave(self:GetCaster(), ability, caster_position, radius, damage)

	-- Secondary Starfall
	local secondary_wave_damage = damage * (secondary_damage_pct * 0.01)
	SecondaryStarfall(self:GetCaster(), ability, caster_position, radius, secondary_wave_damage)

	-- Additional waves
	local current_wave = 1
	local additional_wave_damage = damage * (additional_waves_dmg_pct * 0.01)
	local additional_secondary_damage = additional_wave_damage * (secondary_damage_pct * 0.01)

	Timers:CreateTimer(additional_waves_interval, function()
		-- Commence Starfalls
		StarfallWave(self:GetCaster(), ability, caster_position, radius, additional_wave_damage)
		SecondaryStarfall(self:GetCaster(), ability, caster_position, radius, additional_secondary_damage)

		current_wave = current_wave + 1

		if current_wave <= additional_waves_count then
			return additional_waves_interval
		else
			return nil
		end
	end)
end

function StarfallWave(caster, ability, caster_position, radius, damage)
	local particle_starfall = "particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf"
	local hit_delay = ability:GetSpecialValueFor("hit_delay")
	local sound_impact = "Ability.StarfallImpact"

	-- Find enemies in radius
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		caster_position,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
		FIND_ANY_ORDER,
		false)

	for _,enemy in pairs(enemies) do

		-- Does not hit magic immune enemies
		if not enemy:IsMagicImmune() then

			-- Add starfall effect
			local particle_starfall_fx = ParticleManager:CreateParticle(particle_starfall, PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(particle_starfall_fx, 0, enemy:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_starfall_fx, 1, enemy:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_starfall_fx, 3, enemy:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_starfall_fx)

			-- Wait for the star to get to the target
			Timers:CreateTimer(hit_delay, function()
				-- Deal damage if the target did not become magic immune
				if not enemy:IsMagicImmune() then

					-- Play impact sound
					EmitSoundOn(sound_impact, enemy)

					local damageTable = {victim = enemy,
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						attacker = caster,
						ability = ability
					}

					ApplyDamage(damageTable)

					-- #8 Talent: Each Starstorm wave marks the target. If Mirana lands an attack on the target, she drops an additional secondary star on it.
					if caster:HasTalent("special_bonus_imba_mirana_8") then
						local seed_duration = caster:FindTalentValue("special_bonus_imba_mirana_8")
						enemy:AddNewModifier(caster, ability, "modifier_imba_starfall_talent_seed_debuff", {duration = seed_duration})
					end
				end
			end)
		end
	end
end

function SecondaryStarfall(caster, ability, caster_position, radius, damage)
	local secondary_delay = ability:GetSpecialValueFor("secondary_delay")

	-- Find the closest enemy in the secondary radius
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		caster_position,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NO_INVIS,
		FIND_CLOSEST,
		false)

	-- Check if there is an enemy to rain on
	if enemies[1] then
		-- Commence after a small delay
		Timers:CreateTimer(secondary_delay, function()
			SecondaryStarfallTarget(caster, ability, enemies[1], damage)
		end)
	end
end

function SecondaryStarfallTarget(caster, ability, target, damage)
	local particle_starfall = "particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf"
	local hit_delay = ability:GetSpecialValueFor("hit_delay")
	local sound_impact = "Ability.StarfallImpact"

	-- Add starfall effect
	local particle_starfall_fx = ParticleManager:CreateParticle(particle_starfall, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_starfall_fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_starfall_fx, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_starfall_fx, 3, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_starfall_fx)

	-- Wait for the star to get to the target
	Timers:CreateTimer(hit_delay, function()
		-- Deal damage if the target did not become magic immune
		if not target:IsMagicImmune() then

			-- Play impact sound
			EmitSoundOn(sound_impact, target)

			local damageTable = {victim = target,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				attacker = caster,
				ability = ability
			}

			ApplyDamage(damageTable)
		end
	end)
end

-- Aghnaim's Scepter thinker modifier
modifier_imba_starfall_scepter_thinker = class({})

function modifier_imba_starfall_scepter_thinker:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()

		-- Start thinking!
		self:StartIntervalThink(1)
	end
end

function modifier_imba_starfall_scepter_thinker:IsHidden()
	if self:GetCaster():HasScepter() then
		return false
	end

	return true
end

function modifier_imba_starfall_scepter_thinker:IsPurgable() return false end
function modifier_imba_starfall_scepter_thinker:IsDebuff() return false end
function modifier_imba_starfall_scepter_thinker:DestroyOnExpire() return false end
function modifier_imba_starfall_scepter_thinker:RemoveOnDeath() return false end
function modifier_imba_starfall_scepter_thinker:IsPermanent() return true end

function modifier_imba_starfall_scepter_thinker:OnIntervalThink()
	if IsServer() then
		-- Ability specials
		self.radius = self.ability:GetSpecialValueFor("radius")
		self.damage = self.ability:GetSpecialValueFor("damage")
		self.scepter_starfall_cd = self.ability:GetSpecialValueFor("scepter_starfall_cd")

		-- If the buff is not ready yet, do nothing
		if self:GetRemainingTime() > 0.5 then
			return nil
		else
			-- Set the buff's duration to -1
			self:SetDuration(-1, true)
		end

		-- If caster is dead, do nothing
		if not self.caster:IsAlive() then
			return nil
		end

		-- If caster does not have scepter, do nothing
		if not self.caster:HasScepter() then
			return nil
		end

		-- If caster is invisible, do nothing
		if self.caster:IsImbaInvisible() then
			return nil
		end

		-- Look for nearby enemy units to use Starfall on
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
			self.caster:GetAbsOrigin(),
			nil,
			self.radius-50,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
			FIND_ANY_ORDER,
			false)

		-- If there are no enemies, do nothing
		if #enemies == 0 then
			return nil
		end

		-- Otherwise, Commence Starfall
		StarfallWave(self.caster, self.ability, self.caster:GetAbsOrigin(), self.radius, self.damage)

		-- Restart the buff duration
		self:SetDuration(self.scepter_starfall_cd, true)
	end
end



-- #8 Talent: Each Starstorm wave marks the target. If Mirana lands an attack on the target, she drops an additional secondary star on it.
modifier_imba_starfall_talent_seed_debuff = modifier_imba_starfall_talent_seed_debuff or class({})

function modifier_imba_starfall_talent_seed_debuff:IsHidden() return false end
function modifier_imba_starfall_talent_seed_debuff:IsPurgable() return true end
function modifier_imba_starfall_talent_seed_debuff:IsDebuff() return true end

function modifier_imba_starfall_talent_seed_debuff:OnCreated()
	-- Talent properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability properties
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.secondary_damage_pct = self.ability:GetSpecialValueFor("secondary_damage_pct")

	-- Calculate damage
	self.secondary_damage = self.damage * self.secondary_damage_pct * 0.01
end

function modifier_imba_starfall_talent_seed_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFuncs
end

function modifier_imba_starfall_talent_seed_debuff:OnAttackLanded(keys)
	local target = keys.target
	local attacker = keys.attacker

	-- Only apply if the attack is the caster, and the target is the parent
	if (attacker == self.caster) and (target == self.parent) then

		-- If the target is magic immune, do nothing
		if target:IsMagicImmune() then
			return nil
		end

		-- Drop a star!
		SecondaryStarfallTarget(self.caster, self.ability, target, self.secondary_damage)

		-- Destroy modifier
		self:Destroy()
	end
end


-------------------------------
--        SACRED ARROW       --
-------------------------------

imba_mirana_arrow = class({})
LinkLuaModifier("modifier_imba_sacred_arrow_stun", "components/abilities/heroes/hero_mirana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sacred_arrow_haste", "components/abilities/heroes/hero_mirana", LUA_MODIFIER_MOTION_NONE)

function imba_mirana_arrow:GetAbilityTextureName()
	return "mirana_arrow"
end

function imba_mirana_arrow:IsHiddenWhenStolen()
	return false
end

function imba_mirana_arrow:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local sound_cast = "Hero_Mirana.ArrowCast"

	-- Ability specials
	local spawn_distance = ability:GetSpecialValueFor("spawn_distance")

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Set direction for main arrow
	local direction = (target_point - caster:GetAbsOrigin()):Normalized()

	-- Get spawn point
	local spawn_point = caster:GetAbsOrigin() + direction * spawn_distance

	-- Fire main arrow
	FireSacredArrow(caster, ability, spawn_point, direction)

	-- #4 Talent: Two additional Sacred Arrows to the sides
	if caster:HasTalent("special_bonus_imba_mirana_4") then

		-- Set QAngles
		local left_QAngle = QAngle(0, 30, 0)
		local right_QAngle = QAngle(0, -30, 0)

		-- Left arrow variables
		local left_spawn_point = RotatePosition(caster:GetAbsOrigin(), left_QAngle, spawn_point)
		local left_direction = (left_spawn_point - caster:GetAbsOrigin()):Normalized()

		-- Right arrow variables
		local right_spawn_point = RotatePosition(caster:GetAbsOrigin(), right_QAngle, spawn_point)
		local right_direction = (right_spawn_point - caster:GetAbsOrigin()):Normalized()

		-- Fire left and right arrows
		FireSacredArrow(caster, ability, left_spawn_point, left_direction)
		FireSacredArrow(caster, ability, right_spawn_point, right_direction)
	end
end

function FireSacredArrow(caster, ability, spawn_point, direction)
	local particle_arrow = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf"
	-- Ability specials

	local arrow_radius
	local arrow_speed
	local vision_radius
	local arrow_distance

	-- If ability is not levelled, assign level 1 values
	if ability:GetLevel() == 0 then
		arrow_radius = ability:GetLevelSpecialValueFor("arrow_radius", 1)
		arrow_speed = ability:GetLevelSpecialValueFor("arrow_speed", 1)
		vision_radius = ability:GetLevelSpecialValueFor("vision_radius", 1)
		arrow_distance = ability:GetLevelSpecialValueFor("arrow_distance", 1)
	else
		arrow_radius = ability:GetSpecialValueFor("arrow_radius")
		arrow_speed = ability:GetSpecialValueFor("arrow_speed")
		vision_radius = ability:GetSpecialValueFor("vision_radius")
		arrow_distance = ability:GetSpecialValueFor("arrow_distance")
	end

	-- Fire arrow in the set direction
	local arrow_projectile = {  Ability = ability,
		EffectName = particle_arrow,
		vSpawnOrigin = spawn_point,
		fDistance = arrow_distance,
		fStartRadius = arrow_radius,
		fEndRadius = arrow_radius,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit = true,
		vVelocity = direction * arrow_speed * Vector(1, 1, 0),
		bProvidesVision = true,
		iVisionRadius = vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber(),
		ExtraData = {cast_loc_x = tostring(caster:GetAbsOrigin().x),
			cast_loc_y = tostring(caster:GetAbsOrigin().y),
			cast_loc_z = tostring(caster:GetAbsOrigin().z)}
	}

	ProjectileManager:CreateLinearProjectile(arrow_projectile)
end

function imba_mirana_arrow:OnProjectileHit_ExtraData(target, location, extra_data)
	-- If no target was hit, do nothing
	if not target then
		return nil
	end

	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_response_hero = {"mirana_mir_ability_arrow_01", "mirana_mir_ability_arrow_07", "mirana_mir_lasthit_03"}
	local cast_response_hero_perfect = "mirana_mir_ability_arrow_02"
	local cast_response_creep = {"mirana_mir_ability_arrow_03", "mirana_mir_ability_arrow_04", "mirana_mir_ability_arrow_05", "mirana_mir_ability_arrow_06", "mirana_mir_ability_arrow_08"}
	local cast_response_roshan = {"mirana_mir_ability_arrow_09", "mirana_mir_ability_arrow_10", "mirana_mir_ability_arrow_11", "mirana_mir_ability_arrow_12"}
	local sound_impact = "Hero_Mirana.ArrowImpact"
	local modifier_stun = "modifier_imba_sacred_arrow_stun"

	-- Ability specials
	local base_damage = ability:GetSpecialValueFor("base_damage")
	local distance_tick = ability:GetSpecialValueFor("distance_tick")
	local stun_increase_per_tick = ability:GetSpecialValueFor("stun_increase_per_tick")
	local damage_increase_per_tick = ability:GetSpecialValueFor("damage_increase_per_tick")
	local max_bonus_damage = ability:GetSpecialValueFor("max_bonus_damage")
	local max_stun_duration = ability:GetSpecialValueFor("max_stun_duration")
	local base_stun = ability:GetSpecialValueFor("base_stun")
	local vision_radius = ability:GetSpecialValueFor("vision_radius")
	local vision_linger_duration = ability:GetSpecialValueFor("vision_linger_duration")

	-- Cast response for creeps
	if target:IsCreep() and not target:IsRoshan() then
		local chosen_response = cast_response_creep[math.random(1, 5)]
		EmitSoundOn(chosen_response, caster)
	end

	-- Cast response for Roshan
	if target:IsRoshan() then
		local chosen_response = cast_response_roshan[math.random(1,4)]
		EmitSoundOn(chosen_response, caster)
	end

	-- Play impact sound
	EmitSoundOn(sound_impact, target)

	-- Add FOW viewer for the linger duration
	AddFOWViewer(caster:GetTeamNumber(), location, vision_radius, vision_linger_duration, false)

	-- If target was a creep, kill it immediately and exit
	if target:IsCreep() and not target:IsRoshan() and not target:IsAncient() then
		target:Kill(ability, caster)
		return true
	end

	-- If target was an illusion, kill it immediately and exit
	if target:IsIllusion() then
		target:Kill(ability, caster)
		return true
	end

	-- Recombine cast location vector
	local cast_location = Vector(tonumber(extra_data.cast_loc_x), tonumber(extra_data.cast_loc_y), tonumber(extra_data.cast_loc_z))

	-- Calculate distance traveled
	local distance = (target:GetAbsOrigin() - cast_location):Length2D()

	-- Calculate damage
	local damage = base_damage + (distance / distance_tick * damage_increase_per_tick)

	-- Apply damage
	local damageTable = {victim = target,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		attacker = caster,
		ability = ability
	}

	ApplyDamage(damageTable)

	-- Calculate stun duration
	local stun_duration = base_stun + (distance / distance_tick * stun_increase_per_tick)

	-- Cannot exceed max stun
	if stun_duration > max_stun_duration then
		stun_duration = max_stun_duration
	end

	-- Cast response for heroes
	if target:IsRealHero() then

		-- Bullseye
		if stun_duration >= max_stun_duration then
			EmitSoundOn(cast_response_hero_perfect, caster)
		else
			local chosen_response = cast_response_hero[math.random(1, 3)]
			EmitSoundOn(chosen_response, caster)
		end
	end

	-- Apply stun
	target:AddNewModifier(caster, ability, modifier_stun, {duration = stun_duration})

	return true
end

-- Arrow stun modifier
modifier_imba_sacred_arrow_stun = class({})

function modifier_imba_sacred_arrow_stun:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.modifier_arrow_stun = "modifier_imba_sacred_arrow_stun"
		self.modifier_haste = "modifier_imba_sacred_arrow_haste"
		self.attackers_table = {}

		-- Ability specials
		self.on_prow_crit_damage = self.ability:GetSpecialValueFor("on_prow_crit_damage")
	end
end

function modifier_imba_sacred_arrow_stun:IsHidden() return false end
function modifier_imba_sacred_arrow_stun:IsStunDebuff() return true end
function modifier_imba_sacred_arrow_stun:IsPurgeException() return true end

function modifier_imba_sacred_arrow_stun:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state
end

function modifier_imba_sacred_arrow_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_sacred_arrow_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_sacred_arrow_stun:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_TAKEDAMAGE}

	return decFuncs
end

function modifier_imba_sacred_arrow_stun:OnOrder(keys)
	if IsServer() then
		local unit = keys.unit
		local order_type = keys.order_type
		local target = keys.target

		-- Only apply on units from the caster's team
		if unit:GetTeamNumber() == self.caster:GetTeamNumber() then

			-- Only apply if the order is an attack order against the stunned unit. Anything else removes it
			if (order_type == DOTA_UNIT_ORDER_ATTACK_TARGET or order_type == DOTA_UNIT_ORDER_CAST_TARGET) and target:HasModifier(self.modifier_arrow_stun) then
				unit:AddNewModifier(self.caster, self.ability, self.modifier_haste, {})
			else
				if unit:HasModifier(self.modifier_haste) then
					unit:RemoveModifierByName(self.modifier_haste)
				end
			end
		end
	end
end

function modifier_imba_sacred_arrow_stun:OnTakeDamage(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.unit

		-- Only apply if the target is the stunned parent, and the attacker is from another team
		if target == self.parent and target:GetTeamNumber() ~= attacker:GetTeamNumber() then

			-- If the attacker is on the list of attackers, do nothing
			if #self.attackers_table > 0 then
				for i = 1 , #self.attackers_table do
					if attacker == self.attackers_table[i] then
						return nil
					end
				end
			end

			-- Add the attacker to the list
			table.insert(self.attackers_table, attacker)
		end
	end
end

function modifier_imba_sacred_arrow_stun:OnDestroy()
	if IsServer() then
		-- Find all enemies
		local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),
			self.parent:GetAbsOrigin(),
			nil,
			25000, -- global
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
			FIND_ANY_ORDER,
			false)

		-- Check if they have the haste modifier, if they do, remove it
		for _, enemy in pairs(enemies) do
			if enemy:HasModifier(self.modifier_haste) then
				enemy:RemoveModifierByName(self.modifier_haste)
			end
		end
	end
end

-- Allies haste modifier
modifier_imba_sacred_arrow_haste = class({})

function modifier_imba_sacred_arrow_haste:IsHidden() return false end
function modifier_imba_sacred_arrow_haste:IsPurgable() return true end
function modifier_imba_sacred_arrow_haste:IsDebuff() return false end

function modifier_imba_sacred_arrow_haste:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.on_prowl_movespeed = self.ability:GetSpecialValueFor("on_prowl_movespeed")
end

function modifier_imba_sacred_arrow_haste:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MOVESPEED_MAX}

	return decFuncs
end

function modifier_imba_sacred_arrow_haste:GetModifierMoveSpeedOverride()
	return self.on_prowl_movespeed
end

function modifier_imba_sacred_arrow_haste:GetModifierMoveSpeed_Max()
	return self.on_prowl_movespeed
end

function modifier_imba_sacred_arrow_haste:GetEffectName()
	return "particles/hero/mirana/mirana_sacred_boost.vpcf"
end

function modifier_imba_sacred_arrow_haste:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-------------------------------
--           LEAP            --
-------------------------------

imba_mirana_leap = class({})
LinkLuaModifier("modifier_imba_mirana_leap", "components/abilities/heroes/hero_mirana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_leap_movement", "components/abilities/heroes/hero_mirana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_leap_aura", "components/abilities/heroes/hero_mirana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_leap_speed_boost", "components/abilities/heroes/hero_mirana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_leap_talent_cast_angle_handler", "components/abilities/heroes/hero_mirana", LUA_MODIFIER_MOTION_NONE)

function imba_mirana_leap:GetAbilityTextureName()
	return "mirana_leap"
end

function imba_mirana_leap:GetIntrinsicModifierName()
	return "modifier_imba_mirana_leap"
end

function imba_mirana_leap:GetCastRange(location, target)
--	if IsServer() then return end
	local leap_range = self:GetSpecialValueFor("leap_range")
	local night_leap_range_bonus = self:GetSpecialValueFor("night_leap_range_bonus")

	if IsDaytime() then
		return leap_range
	else
		return leap_range + night_leap_range_bonus
	end
end

function imba_mirana_leap:IsHiddenWhenStolen()
	return false
end

function imba_mirana_leap:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	local modifier_movement = "modifier_imba_leap_movement"
	local sound_cast = "Ability.Leap"

	-- Ability specials
	local jump_speed = self:GetSpecialValueFor("jump_speed")

	-- Start gesture
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Disjoint projectiles
	ProjectileManager:ProjectileDodge(caster)

	-- Make Mirana face the target (relevant with #7 Talent)
	caster:FaceTowards(target_point)
	
	-- Start moving
	local modifier_movement_handler = caster:AddNewModifier(caster, self, modifier_movement, {})

	-- Assign the target location in the modifier
	if modifier_movement_handler then
		modifier_movement_handler.target_point = target_point
	end

	-- #6 Talent: Free Sacred Arrow after Leap ends
	if caster:HasTalent("special_bonus_imba_mirana_6") then
		-- Calculate the landing time
		local distance = (caster:GetAbsOrigin() - target_point):Length2D()
		local jump_time = distance / jump_speed

		-- Calculate direction and spawn point of the arrow
		local direction = (target_point - caster:GetAbsOrigin()):Normalized()

		-- Set caster's location BEFORE the jump
		local caster_location = caster:GetAbsOrigin()

		-- Create Timer
		Timers:CreateTimer(jump_time, function()
			-- Get the Sacred Arrow ability definition and distance
			local sacred_arrow_ability = caster:FindAbilityByName("imba_mirana_arrow")

			-- Get values for at least level 1 arrow
			local spawn_distance

			if sacred_arrow_ability:GetLevel() > 0 then
				spawn_distance = sacred_arrow_ability:GetSpecialValueFor("spawn_distance")
			else
				spawn_distance = sacred_arrow_ability:GetLevelSpecialValueFor("spawn_distance", sacred_arrow_ability:GetLevel()+1)
			end

			-- Get spawn point
			local spawn_point = caster_location + direction * (spawn_distance + distance)

			-- Fire Sacred Arrow
			FireSacredArrow(caster, sacred_arrow_ability, spawn_point, direction)
		end)
	end
end

function imba_mirana_leap:OnUpgrade()
	if self:GetCaster():HasModifier("modifier_imba_mirana_leap") then
		if self:GetCaster():FindModifierByName("modifier_imba_mirana_leap"):GetDuration() == -1 and self:GetCaster():FindModifierByName("modifier_imba_mirana_leap"):GetStackCount() < self:GetSpecialValueFor("max_charges") then
			self:GetCaster():FindModifierByName("modifier_imba_mirana_leap"):SetDuration(self:GetSpecialValueFor("charge_restore_time"), true)
			self:GetCaster():FindModifierByName("modifier_imba_mirana_leap"):StartIntervalThink(self:GetSpecialValueFor("charge_restore_time"))
		end
	end
end

-- Charges modifier
modifier_imba_mirana_leap = class ({})

function modifier_imba_mirana_leap:IsHidden()			return false end
function modifier_imba_mirana_leap:DestroyOnExpire() 	return false end
function modifier_imba_mirana_leap:IsPurgable() 		return false end
function modifier_imba_mirana_leap:RemoveOnDeath() 		return false end

function modifier_imba_mirana_leap:OnCreated()
	self:SetStackCount(self:GetAbility():GetSpecialValueFor("max_charges"))
end

-- This function should run whenever the modifier duration ends
function modifier_imba_mirana_leap:OnIntervalThink()
	self:IncrementStackCount()

	if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_charges") then
		self:SetDuration(self:GetAbility():GetSpecialValueFor("charge_restore_time"), true)
	else
		self:SetDuration(-1, true)
		self:StartIntervalThink(-1)
	end
end

-- Leap movement modifier
modifier_imba_leap_movement = class({})

function modifier_imba_leap_movement:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_aura = "modifier_imba_leap_aura"

	-- Ability specials
	self.jump_speed = self.ability:GetSpecialValueFor("jump_speed")
	self.max_height = self.ability:GetSpecialValueFor("max_height")
	self.aura_duration = self.ability:GetSpecialValueFor("aura_duration")

	if IsServer() then

		-- Variables
		self.time_elapsed = 0
		self.leap_z = 0

		-- Wait one frame to get the target point from the ability's OnSpellStart, then calculate distance
		Timers:CreateTimer(FrameTime(), function()
			self.distance = (self.caster:GetAbsOrigin() - self.target_point):Length2D()
			self.jump_time = self.distance / self.jump_speed

			self.direction = (self.target_point - self.caster:GetAbsOrigin()):Normalized()

			self.frametime = FrameTime()
			self:StartIntervalThink(self.frametime)
		end)
	end
end

function modifier_imba_leap_movement:OnIntervalThink()
	-- Check motion controllers
	if not self:CheckMotionControllers() then		
		self:Destroy()
		return nil
	end

	-- Vertical Motion
	self:VerticalMotion(self.caster, self.frametime)

	-- Horizontal Motion
	self:HorizontalMotion(self.caster, self.frametime)
	
	self.ability:StartCooldown(0)
end

function modifier_imba_leap_movement:IsHidden() return true end
function modifier_imba_leap_movement:IsPurgable() return false end
function modifier_imba_leap_movement:IsDebuff() return false end
function modifier_imba_leap_movement:IgnoreTenacity() return true end
function modifier_imba_leap_movement:IsMotionController() return true end
function modifier_imba_leap_movement:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_leap_movement:VerticalMotion(me, dt)
	if IsServer() then

		-- Check if we're still jumping
		if self.time_elapsed < self.jump_time then

			-- Check if we should be going up or down
			if self.time_elapsed <= self.jump_time / 2 then
				-- Going up
				self.leap_z = self.leap_z + 30


				self.caster:SetAbsOrigin(GetGroundPosition(self.caster:GetAbsOrigin(), self.caster) + Vector(0,0,self.leap_z))
			else
				-- Going down
				self.leap_z = self.leap_z - 30
				if self.leap_z > 0 then
					self.caster:SetAbsOrigin(GetGroundPosition(self.caster:GetAbsOrigin(), self.caster) + Vector(0,0,self.leap_z))
				end

			end
		end
	end
end

function modifier_imba_leap_movement:HorizontalMotion(me, dt)
	if IsServer() then
		-- Check if we're still jumping
		self.time_elapsed = self.time_elapsed + dt
		if self.time_elapsed < self.jump_time then

			-- Go forward
			local new_location = self.caster:GetAbsOrigin() + self.direction * self.jump_speed * dt
			self.caster:SetAbsOrigin(new_location)
		else
			-- This should always be true
			if self:GetCaster():HasModifier("modifier_imba_mirana_leap") then
				-- Start by ending cooldown before checking for remaining charges
				self.ability:EndCooldown()
				-- If charges are at max, start the modifier countdown
				if self:GetCaster():FindModifierByName("modifier_imba_mirana_leap"):GetStackCount() == self.ability:GetSpecialValueFor("max_charges") then
					self:GetCaster():FindModifierByName("modifier_imba_mirana_leap"):SetDuration(self.ability:GetSpecialValueFor("charge_restore_time"), true)
					self:GetCaster():FindModifierByName("modifier_imba_mirana_leap"):StartIntervalThink(self.ability:GetSpecialValueFor("charge_restore_time"))
				-- If only one charge left, start the cooldown equivalent to remaining modifier time
				elseif self:GetCaster():FindModifierByName("modifier_imba_mirana_leap"):GetStackCount() <= 1 then
					self.ability:StartCooldown(self:GetCaster():FindModifierByName("modifier_imba_mirana_leap"):GetRemainingTime())
				end
				
				-- Consume a charge
				self:GetCaster():FindModifierByName("modifier_imba_mirana_leap"):DecrementStackCount()
			end
			self:Destroy()
		end
	end
end

function modifier_imba_leap_movement:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_INVISIBILITY_LEVEL}

	return decFuncs
end

function modifier_imba_leap_movement:GetModifierInvisibilityLevel()
	if self.caster:HasTalent("special_bonus_imba_mirana_7") then
		return 1
	end

	return nil
end

function modifier_imba_leap_movement:CheckState()
	local state
	-- #7 Talent: Makes Mirana invisible for the duration of the jump, causing her to dodge projectiles.
	-- Check if the caster should get invisibility
	if self.caster:HasTalent("special_bonus_imba_mirana_7") then
		state = {[MODIFIER_STATE_INVISIBLE] = true}
	end

	return state
end


function modifier_imba_leap_movement:OnRemoved()
	if IsServer() then
		self.caster:SetUnitOnClearGround()
		self.caster:AddNewModifier(self.caster, self.ability, self.modifier_aura, {duration = self.aura_duration})
	end
end

-- Leap aura modifier
modifier_imba_leap_aura = class({})

function modifier_imba_leap_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.aura_aoe = self.ability:GetSpecialValueFor("aura_aoe")
	self.aura_linger_duration = self.ability:GetSpecialValueFor("aura_linger_duration")
end

function modifier_imba_leap_aura:IsHidden() return false end
function modifier_imba_leap_aura:IsPurgable() return false end
function modifier_imba_leap_aura:IsDebuff() return false end

function modifier_imba_leap_aura:GetAuraDuration()
	return self.aura_linger_duration
end

function modifier_imba_leap_aura:GetAuraRadius()
	return self.aura_aoe
end

function modifier_imba_leap_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_leap_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_leap_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_leap_aura:GetModifierAura()
	return "modifier_imba_leap_speed_boost"
end

function modifier_imba_leap_aura:IsAura()
	return true
end

-- Leap speed boost modifier
modifier_imba_leap_speed_boost = class({})

function modifier_imba_leap_speed_boost:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.move_speed_pct = self.ability:GetSpecialValueFor("move_speed_pct")
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
end

function modifier_imba_leap_speed_boost:IsHidden()
	if self.parent == self.caster and self.caster:HasModifier("modifier_imba_leap_aura") then
		return true
	end

	return false
end

function modifier_imba_leap_speed_boost:IsPurgable() return false end
function modifier_imba_leap_speed_boost:IsDebuff() return false end

function modifier_imba_leap_speed_boost:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_imba_leap_speed_boost:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed_pct
end

function modifier_imba_leap_speed_boost:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end



-- #7 Talent: Leap can now be cast without needing to turn. Makes Mirana invisible for the duration of the jump, causing her to dodge projectiles.
modifier_imba_leap_talent_cast_angle_handler = modifier_imba_leap_talent_cast_angle_handler or class({})

function modifier_imba_leap_talent_cast_angle_handler:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
			MODIFIER_PROPERTY_DISABLE_TURNING
		}
	return decFuncs
end

function modifier_imba_leap_talent_cast_angle_handler:IsHidden() return true end
function modifier_imba_leap_talent_cast_angle_handler:IsPurgable() return false end
function modifier_imba_leap_talent_cast_angle_handler:IsDebuff() return false end

function modifier_imba_leap_talent_cast_angle_handler:GetModifierIgnoreCastAngle()
	return 1
end

function modifier_imba_leap_talent_cast_angle_handler:GetModifierDisableTurning()
	return 1
end

function modifier_imba_leap_talent_cast_angle_handler:IsHidden()
	return false
end


-------------------------------
--     MOONLIGHT SHADOW      --
-------------------------------

imba_mirana_moonlight_shadow = class({})
LinkLuaModifier("modifier_imba_moonlight_shadow", "components/abilities/heroes/hero_mirana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_moonlight_shadow_invis", "components/abilities/heroes/hero_mirana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_moonlight_shadow_invis_dummy", "components/abilities/heroes/hero_mirana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_moonlight_shadow_invis_fade_time", "components/abilities/heroes/hero_mirana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_moonlight_shadow_talent_starstorm", "components/abilities/heroes/hero_mirana", LUA_MODIFIER_MOTION_NONE)

function imba_mirana_moonlight_shadow:GetAbilityTextureName()
	return "mirana_invis"
end

function imba_mirana_moonlight_shadow:IsHiddenWhenStolen()
	return false
end

function imba_mirana_moonlight_shadow:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_response = {"mirana_mir_ability_moon_02", "mirana_mir_ability_moon_03", "mirana_mir_ability_moon_04", "mirana_mir_ability_moon_07", "mirana_mir_ability_moon_08"}
	local sound_cast = "Ability.MoonlightShadow"
	local particle_moon = "particles/units/heroes/hero_mirana/mirana_moonlight_cast.vpcf"
	local modifier_main = "modifier_imba_moonlight_shadow"
	local modifier_talent_starstorm = "modifier_imba_moonlight_shadow_talent_starstorm"

	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")

	-- Play cast response
	EmitSoundOn(cast_response[math.random(1, 5)], caster)

	-- Play sound cast
	EmitSoundOn(sound_cast, caster)

	-- Add particle effect
	local particle_moon_fx = ParticleManager:CreateParticle(particle_moon, PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle_moon_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_moon_fx)

	-- Apply main modifier
	caster:AddNewModifier(caster, ability, modifier_main, {duration = duration})

	-- #1 Talent: Upon using Moonlight Shadow, allies are given a stack of Starstorm which will proc when they go out of invisibility near an enemy unit.
	if caster:HasTalent("special_bonus_imba_mirana_1") then

		-- Find the Starstorm ability. If Mirana does not have Starstorm, this talent does nothing
		if not caster:HasAbility("imba_mirana_starfall") then
			return nil
		end

		local starstorm_ability = caster:FindAbilityByName("imba_mirana_starfall")

		if starstorm_ability then
			local allies = FindUnitsInRadius(caster:GetTeamNumber(),
				caster:GetAbsOrigin(),
				nil,
				25000,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
				FIND_ANY_ORDER,
				false)

			for _, ally in pairs(allies) do
				ally:AddNewModifier(caster, starstorm_ability, modifier_talent_starstorm, {duration = duration})
			end
		end
	end
end

-- Main modifier (Mirana)
modifier_imba_moonlight_shadow = class({})

function modifier_imba_moonlight_shadow:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.modifier_invis = "modifier_imba_moonlight_shadow_invis"
		self.modifier_dummy = "modifier_imba_moonlight_shadow_invis_dummy"
		self.fade_delay = self.ability:GetSpecialValueFor("fade_delay")

		-- Start interval think
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_moonlight_shadow:IsHidden() return false end
function modifier_imba_moonlight_shadow:IsPurgable() return false end
function modifier_imba_moonlight_shadow:IsDebuff() return false end

function modifier_imba_moonlight_shadow:OnIntervalThink()
	if IsServer() then
		local duration = self:GetRemainingTime()

		-- Find all allied heroes
		local allies = FindUnitsInRadius(self.caster:GetTeamNumber(),
			self.caster:GetAbsOrigin(),
			nil,
			25000,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
			FIND_ANY_ORDER,
			false)

		-- If they don't have invisibility modifiers, give it to them
		for _,ally in pairs(allies) do
			if not ally:HasModifier(self.modifier_invis) then
				ally:AddNewModifier(self.caster, self.ability, self.modifier_dummy, {duration = duration})
				ally:AddNewModifier(self.caster, self.ability, self.modifier_invis, {duration = duration})
				if self:GetDuration() < (duration + self.fade_delay) then
					ally:AddNewModifier(self.caster, self.ability, "modifier_imba_moonlight_shadow_invis_fade_time", {duration = self.fade_delay})
				end
			end
		end
	end
end

function modifier_imba_moonlight_shadow:OnDestroy()
	if IsServer() then
		-- Find all allied heroes
		local allies = FindUnitsInRadius(self.caster:GetTeamNumber(),
			self.caster:GetAbsOrigin(),
			nil,
			25000,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
			FIND_ANY_ORDER,
			false)

		-- If they have the invisibility modifiers, remove it
		for _,ally in pairs(allies) do
			if ally:HasModifier(self.modifier_invis) then
				ally:RemoveModifierByName(self.modifier_invis)
				ally:RemoveModifierByName(self.modifier_dummy)
			end
		end
	end
end

-- Invisibility modifier (hidden)
modifier_imba_moonlight_shadow_invis = class({})

function modifier_imba_moonlight_shadow_invis:OnCreated()
	-- this stacks is the actual invisibility, but since it has a on/off triggers, it's counted with stacks
	-- 0 stacks means the hero is not invisible
	-- 1 stack means the hero is invisible, but can be detected
	-- 2 stacks means the hero is both invisible and cannot be detected

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.modifier_dummy_name = "modifier_imba_moonlight_shadow_invis_dummy"

	if self.ability then
		self.fade_delay = self.ability:GetSpecialValueFor("fade_delay")
		self.truesight_immunity_radius = self.ability:GetSpecialValueFor("truesight_immunity_radius")
	else
		self.fade_delay = 0
		self.truesight_immunity_radius = 1
	end

	if IsServer() then
		self.modifier_dummy = self.parent:FindModifierByName("modifier_imba_moonlight_shadow_invis_dummy")

		-- Set stack count to level 2
		self:SetStackCount(2)

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_moonlight_shadow_invis:IsHidden() return true end
function modifier_imba_moonlight_shadow_invis:IsPurgable() return false end
function modifier_imba_moonlight_shadow_invis:IsDebuff() return false end

function modifier_imba_moonlight_shadow_invis:OnIntervalThink()
	if IsServer() then
		-- Look around for enemy heroes in the immunity radius
		local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),
			self.parent:GetAbsOrigin(),
			nil,
			self.truesight_immunity_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
			FIND_ANY_ORDER,
			false)

		-- if the hero is not invisible, do nothing
		if self:GetStackCount() == 0 then
			return nil
		end

		-- If an enemy hero was found, remove immunity
		if #enemies > 0 then
			self:SetStackCount(1)
		else
			-- Else, set it back
			self:SetStackCount(2)
		end
	end
end

function modifier_imba_moonlight_shadow_invis:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_ATTACK}

	return decFuncs
end

function modifier_imba_moonlight_shadow_invis:GetModifierMoveSpeedBonus_Percentage()
	-- #3 Talent: Moonlight Shadow grants bonus move speed to invisible allies
	if self:GetStackCount() > 0 then
		return self.caster:FindTalentValue("special_bonus_imba_mirana_3")
	end

	return 0
end

function modifier_imba_moonlight_shadow_invis:GetModifierInvisibilityLevel()
	local stacks = self:GetStackCount()

	if stacks == 2 or stacks == 1 then
		return 1
	else
		return 0
	end
end

function modifier_imba_moonlight_shadow_invis:OnAbilityExecuted(keys)
	if IsServer() then
		local unit = keys.unit

		-- Only apply if the parent is the one casting
		if self.parent == unit then

			-- Remove invisibility, set duration to fade delay
			self:SetStackCount(0)
			self:SetDuration(self.fade_delay, true)
			self.modifier_dummy:SetDuration(self.fade_delay, true)
			self.parent:AddNewModifier(self.caster, self.ability, self:GetName(), {duration = self.fade_delay})
			self.parent:AddNewModifier(self.caster, self.ability, self.modifier_dummy_name, {duration = self.fade_delay})
			self.parent:AddNewModifier(self.caster, self.ability, "modifier_imba_moonlight_shadow_invis_fade_time", {duration = self.fade_delay})
		end
	end
end

function modifier_imba_moonlight_shadow_invis:OnAttack(keys)
	if IsServer() then
		local attacker = keys.attacker

		-- Only apply if the parent is the one attacking
		if self.parent == attacker then

			-- Remove invisibility, set duration to fade delay
			self:SetStackCount(0)
			self:SetDuration(self.fade_delay, true)
			self.modifier_dummy:SetDuration(self.fade_delay, true)
			self.parent:AddNewModifier(self.caster, self.ability, self:GetName(), {duration = self.fade_delay})
			self.parent:AddNewModifier(self.caster, self.ability, self.modifier_dummy_name, {duration = self.fade_delay})
			self.parent:AddNewModifier(self.caster, self.ability, "modifier_imba_moonlight_shadow_invis_fade_time", {duration = self.fade_delay})
		end
	end
end

function modifier_imba_moonlight_shadow_invis:CheckState()
	if IsServer() then
		local state
		local stacks = self:GetStackCount()

		-- If parent is not invisible, no states are applied
		if stacks == 0 then
			return nil
		end

		-- If parent is truesight immune and invisible, set correct state
		if stacks == 2 then
			state = {[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
				[MODIFIER_STATE_INVISIBLE] = true}
		else
			state = {[MODIFIER_STATE_INVISIBLE] = true}
		end

		return state
	end
end

-- Dummy invisibility modifier (shown)
modifier_imba_moonlight_shadow_invis_dummy = class({})

function modifier_imba_moonlight_shadow_invis_dummy:IsHidden() return false end
function modifier_imba_moonlight_shadow_invis_dummy:IsPurgable() return false end
function modifier_imba_moonlight_shadow_invis_dummy:IsDebuff() return false end

function modifier_imba_moonlight_shadow_invis_dummy:GetEffectName()
	return "particles/units/heroes/hero_mirana/mirana_moonlight_owner.vpcf"
end

function modifier_imba_moonlight_shadow_invis_dummy:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-- Dummy fade modifier (shown)
modifier_imba_moonlight_shadow_invis_fade_time = class({})

function modifier_imba_moonlight_shadow_invis_fade_time:IsHidden() return false end
function modifier_imba_moonlight_shadow_invis_fade_time:IsPurgable() return false end
function modifier_imba_moonlight_shadow_invis_fade_time:IsPurgeException() return false end
function modifier_imba_moonlight_shadow_invis_fade_time:IsDebuff() return false end


-- #1 Talent: Moonlight Shadow grants allies a single Starstorm which will proc when they go out of invisibility
modifier_imba_moonlight_shadow_talent_starstorm = modifier_imba_moonlight_shadow_talent_starstorm or class({})

function modifier_imba_moonlight_shadow_talent_starstorm:IsHidden() return false end
function modifier_imba_moonlight_shadow_talent_starstorm:IsPurgable() return true end
function modifier_imba_moonlight_shadow_talent_starstorm:IsDebuff() return false end

function modifier_imba_moonlight_shadow_talent_starstorm:OnCreated()
	if IsServer() then
		-- Talent properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		-- Talent specials
		self.delay_time = self.caster:FindTalentValue("special_bonus_imba_mirana_1", "delay_time")

		-- Ability specials
		self.radius = self.ability:GetSpecialValueFor("radius")
		self.damage = self.ability:GetSpecialValueFor("damage")
		self.secondary_damage_pct = self.ability:GetSpecialValueFor("secondary_damage_pct")

		-- Wait for the delay time before starting to think
		Timers:CreateTimer(self.delay_time, function()
			if not self:IsNull() then
				-- Think immediately
				self:OnIntervalThink()

				-- Set thinker to think every second
				self:StartIntervalThink(1)
			end
		end)
	end
end

function modifier_imba_moonlight_shadow_talent_starstorm:OnIntervalThink()
	if IsServer() then
		-- If the parent is invisible, do nothing
		if self.parent:IsImbaInvisible() then
			return nil
		end

		-- Look for nearby enemy units to use Starfall on
		local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),
			self.parent:GetAbsOrigin(),
			nil,
			self.radius-50,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
			FIND_ANY_ORDER,
			false)

		-- If there are no enemies, do nothing
		if #enemies == 0 then
			return nil
		end

		-- Otherwise, Commence Starfall
		StarfallWave(self.parent, self.ability, self.parent:GetAbsOrigin(), self.radius, self.damage)

		-- Secondary Starfall
		local secondary_wave_damage = self.damage * (self.secondary_damage_pct * 0.01)
		SecondaryStarfall(self.parent, self.ability, self.parent:GetAbsOrigin(), self.radius, secondary_wave_damage)

		-- Remove the buff
		self:Destroy()
	end
end

modifier_imba_mirana_silence_stance = modifier_imba_mirana_silence_stance or class({})

function modifier_imba_mirana_silence_stance:IsHidden() return true end
function modifier_imba_mirana_silence_stance:IsPurgable() return false end
function modifier_imba_mirana_silence_stance:IsDebuff() return false end
function modifier_imba_mirana_silence_stance:RemoveOnDeath() return false end

function modifier_imba_mirana_silence_stance:OnCreated()
	-- Stacks determine invisibility state:
	-- 0: not invisible
	-- 1: invisible

	if IsServer() then
		-- Talent properties
		self.parent = self:GetParent()

		-- Talent specials
		self.stand_time = self.parent:FindTalentValue("special_bonus_imba_mirana_5")

		-- Set the current stand position and timer
		self.last_position = self.parent:GetAbsOrigin()
		self.last_time_tick = GameRules:GetGameTime()

		-- Set invisibility state
		self:SetStackCount(0)

		-- Start thinking
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_mirana_silence_stance:OnIntervalThink()
	if IsServer() then
		-- Check if this is a day. If so, Mirana cannot hide, and the stance does nothing
		if GameRules:IsDaytime() then
			self:SetStackCount(0)
			self.last_time_tick = GameRules:GetGameTime()
			self.last_position = self.parent:GetAbsOrigin()

			-- Do nothing else
			return nil
		end

		-- Check Mirana's current position. If it changed, remove possible invisibility and reset the last tick time
		if self.last_position ~= self.parent:GetAbsOrigin() then
			self:SetStackCount(0)
			self.last_position = self.parent:GetAbsOrigin()
			self.last_time_tick = GameRules:GetGameTime()
		else
			-- Otherwise, check if Mirana is not invisible yet.
			if self:GetStackCount() == 0 then

				-- Check last tick and see if she should be awarded invisibility
				if (GameRules:GetGameTime() - self.last_time_tick) >= self.stand_time then

					-- Grant invisibility
					self:SetStackCount(1)
				end
			end
		end
	end
end

function modifier_imba_mirana_silence_stance:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL}

	return decFuncs
end

function modifier_imba_mirana_silence_stance:OnAttack(keys)
	if IsServer() then
		local attacker = keys.attacker

		-- Only apply if the attacker is the parent
		if attacker == self.parent then

			-- Remove invisibility
			self:SetStackCount(0)

			-- Set last tick time
			self.last_time_tick = GameRules:GetGameTime()
		end
	end
end

function modifier_imba_mirana_silence_stance:CheckState()
	local state
	if self:GetStackCount() == 1 then
		state = {[MODIFIER_STATE_INVISIBLE] = true}
	end

	return state
end

function modifier_imba_mirana_silence_stance:GetModifierInvisibilityLevel()
	if self:GetStackCount() == 1 then
		return 1
	end
end


-- Responsible for showing Mirana that she's invisible thanks to Silence Stance talent
modifier_imba_mirana_silence_stance_visible = modifier_imba_mirana_silence_stance_visible or class({})

function modifier_imba_mirana_silence_stance_visible:GetTexture()
	return "custom/mirana_princess_of_the_night"
end

function modifier_imba_mirana_silence_stance_visible:IsHidden()
	local stacks = self:GetParent():GetModifierStackCount("modifier_imba_mirana_silence_stance", self:GetParent())

	if stacks == 1 then
		return false
	end

	return true
end

function modifier_imba_mirana_silence_stance_visible:IsPurgable() return false end
function modifier_imba_mirana_silence_stance_visible:IsDebuff() return false end
function modifier_imba_mirana_silence_stance_visible:RemoveOnDeath() return false end
