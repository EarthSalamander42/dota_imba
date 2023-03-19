-- Creator: Shush
-- 19/05/2020

--	EarthSalamander, May 12th, 2019
--	Leshrac Diabolic Edict luafied




-----------------
-- SPLIT EARTH --
-----------------
LinkLuaModifier("modifier_imba_split_earth_stun", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_split_earth_empowered_split", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_split_earth_tormented_true_sight", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)

imba_leshrac_split_earth = imba_leshrac_split_earth or class({})

function imba_leshrac_split_earth:GetCooldown(level)
	local cd = self.BaseClass.GetCooldown(self, level)
	if self:GetCaster():HasModifier("modifier_imba_tormented_soul_form") then
		local tormented_form_cd_rdct_pct = self:GetSpecialValueFor("tormented_form_cd_rdct_pct")

		if tormented_form_cd_rdct_pct then
			cd = cd * tormented_form_cd_rdct_pct / 100
		end
	end

	return cd
end

function imba_leshrac_split_earth:GetAOERadius()
	-- Ability properties	
	local caster = self:GetCaster()
	local ability = self
	local modifier_empowered = "modifier_imba_split_earth_empowered_split"

	-- Ability specials
	local radius = ability:GetSpecialValueFor("radius")
	local empowered_split_radius = ability:GetSpecialValueFor("empowered_split_radius")

	if caster:HasModifier(modifier_empowered) then
		local radius_increase = caster:GetModifierStackCount(modifier_empowered, caster) * empowered_split_radius
		radius = radius + radius_increase
	end
	return radius
end

function imba_leshrac_split_earth:OnSpellStart(ese_location, ese_radius) -- procced via Pulse Nova IMBAFication only
	if IsClient() then return end

	-- Ability properties
	local caster = self:GetCaster()

	local ability = self
	local target_point = ability:GetCursorPosition()
	local cast_sound = "Hero_Leshrac.Split_Earth"
	local particle_spikes = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf" --cp0 location, cp1 radius Vector (radius, 1, 1)
	local particle_orb = "particles/hero/leshrac/leshrac_splitter_blast_projectile.vpcf"
	local modifier_stun = "modifier_imba_split_earth_stun"
	local modifier_empowered = "modifier_imba_split_earth_empowered_split"
	local modifier_tormented = "modifier_imba_tormented_soul_form"
	local modifier_truesight = "modifier_imba_split_earth_tormented_true_sight"

	-- Ability specials
	local delay = ability:GetSpecialValueFor("delay")
	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")
	local damage = ability:GetSpecialValueFor("damage")
	local empowered_split_duration = ability:GetSpecialValueFor("empowered_split_duration")
	local empowered_split_radius = ability:GetSpecialValueFor("empowered_split_radius")
	local empowered_split_damage = ability:GetSpecialValueFor("empowered_split_damage")
	local splitter_blast_radius = ability:GetSpecialValueFor("splitter_blast_radius")
	local splitter_blast_unit_energy_count = ability:GetSpecialValueFor("splitter_blast_unit_energy_count")
	local splitter_blast_hero_energy_count = ability:GetSpecialValueFor("splitter_blast_hero_energy_count")
	local splitter_blast_projectile_speed = ability:GetSpecialValueFor("splitter_blast_projectile_speed")
	local splitter_blast_delay = ability:GetSpecialValueFor("splitter_blast_delay")
	local tormented_form_trusight_duration = ability:GetSpecialValueFor("tormented_form_trusight_duration")

	-- Talent: Empowered Split Earth stack duration increase
	if caster:HasTalent("special_bonus_unique_imba_leshrac_empowered_split_earth_duration") then
		empowered_split_duration = empowered_split_duration + caster:FindTalentValue("special_bonus_unique_imba_leshrac_empowered_split_earth_duration")
	end

	-- IMBAfication: Empowered Split
	-- Get Empowered Split modifier and stack count, if any
	if caster:HasModifier(modifier_empowered) then
		local modifier_empowered_handle = caster:FindModifierByName(modifier_empowered)
		if modifier_empowered_handle then
			local stacks = modifier_empowered_handle:GetStackCount()
			radius = radius + empowered_split_radius * stacks
			damage = damage + empowered_split_damage * stacks
		end
	end

	-- If this is a Pulse Nova's Earth Edict Storm cast, adjust values
	if ese_location and ese_radius then
		target_point = ese_location
		radius = ese_radius
		delay = 0
	end

	-- Determine amount of energy orbs to be created
	local energy_orb_count = 0

	-- Wait for the delay before proccing
	Timers:CreateTimer(delay, function()
		-- Destroy trees in the radius
		GridNav:DestroyTreesAroundPoint(target_point, radius, true)

		-- Play cast sound
		EmitSoundOnLocationWithCaster(target_point, cast_sound, caster)

		-- Create particle effects
		local particle_spikes_fx = ParticleManager:CreateParticle(particle_spikes, PATTACH_WORLDORIGIN, nil, caster)
		ParticleManager:SetParticleControl(particle_spikes_fx, 0, target_point)
		ParticleManager:SetParticleControl(particle_spikes_fx, 1, Vector(radius, 1, 1))
		ParticleManager:ReleaseParticleIndex(particle_spikes_fx)

		-- Find all valid enemies in range. Doesn't pierce Magic immunity
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			target_point,
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_DAMAGE_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		for _, enemy in pairs(enemies) do
			-- Stun
			enemy:AddNewModifier(caster, ability, modifier_stun, { duration = duration * (1 - enemy:GetStatusResistance()) })

			-- Tormented Soul Form: causes enemies hit to become visible through fog/invis
			if caster:HasModifier(modifier_tormented) then
				enemy:AddNewModifier(caster, ability, modifier_truesight, { duration = tormented_form_trusight_duration })
			end

			-- Deal damage
			local damageTable = {
				victim = enemy,
				attacker = caster,
				damage = damage,
				damage_type = ability:GetAbilityDamageType(),
				ability = ability
			}

			ApplyDamage(damageTable)

			-- Add Empowered Split modifier/stack
			-- Only granted from hitting heroes
			if enemy:IsRealHero() then
				if not caster:HasModifier(modifier_empowered) then
					caster:AddNewModifier(caster, ability, modifier_empowered, { duration = empowered_split_duration })
				end

				local modifier_empowered_handle = caster:FindModifierByName(modifier_empowered)
				if modifier_empowered_handle then
					modifier_empowered_handle:IncrementStackCount()
				end
			end

			if enemy:IsRealHero() or enemy:IsConsideredHero() then
				energy_orb_count = energy_orb_count + splitter_blast_hero_energy_count
			else
				energy_orb_count = energy_orb_count + splitter_blast_unit_energy_count
			end
		end

		-- IMBAfication: Splitter Blast:
		-- If necessary, scale Splitter Blast radius
		if radius > splitter_blast_radius then
			splitter_blast_radius = radius
		end

		-- Find nearby enemies in the Splitter Blast radius
		local splitter_enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			target_point,
			nil,
			splitter_blast_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
			FIND_ANY_ORDER,
			false)

		if #splitter_enemies > 0 then
			-- Create a dummy to fire the orbs from
			local dummy = CreateUnitByName("npc_dummy_unit", target_point, false, caster, caster, caster:GetTeamNumber())

			-- Repeat for each orb
			local orbs_fired = 0
			Timers:CreateTimer(splitter_blast_delay, function()
				local chosen_enemy

				-- Pick a random enemy and make sure it is valid
				local valid_chosen_enemy = false
				local tries = 0
				while not valid_chosen_enemy do
					local picked_enemy_num = RandomInt(1, #splitter_enemies)

					chosen_enemy = splitter_enemies[picked_enemy_num]
					if chosen_enemy and not chosen_enemy:IsMagicImmune() and chosen_enemy:IsAlive() then
						-- If the enemy is valid, flag it
						valid_chosen_enemy = true
					else
						-- If this wasn't, increment tries, up to 5 tries. If this doesn't work, just give it up to prevent forever loops
						tries = tries + 1

						if tries >= 5 then
							break
						end
					end
				end

				if valid_chosen_enemy and chosen_enemy then
					-- Fire projectile from the ground center
					local projectile =
					{
						Target            = chosen_enemy,
						Source            = dummy,
						Ability           = ability,
						EffectName        = particle_orb,
						iMoveSpeed        = splitter_blast_projectile_speed,
						vSpawnOrigin      = dummy:GetAbsOrigin(),
						bDrawsOnMinimap   = false,
						bDodgeable        = true,
						bIsAttack         = false,
						bVisibleToEnemies = true,
						bReplaceExisting  = false,
						flExpireTime      = GameRules:GetGameTime() + 10,
					}
					ProjectileManager:CreateTrackingProjectile(projectile)
				end

				orbs_fired = orbs_fired + 1
				if orbs_fired < energy_orb_count then
					return splitter_blast_delay
				else
					-- No more orbs are left to fire: stop iterating and destroy the dummy										
					UTIL_Remove(dummy)
					return nil
				end
			end)
		end
	end)
end

function imba_leshrac_split_earth:OnProjectileHit(target, location)
	if not target then return end

	-- Ability properties
	local caster = self:GetCaster()
	local ability = self

	-- Ability specials
	local splitter_blast_damage = ability:GetSpecialValueFor("splitter_blast_damage")

	-- Deal damage!	
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = splitter_blast_damage,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability
	}

	ApplyDamage(damageTable)
end

-------------------------------
-- SPLIT EARTH STUN MODIFIER --
-------------------------------

modifier_imba_split_earth_stun = modifier_imba_split_earth_stun or class({})

function modifier_imba_split_earth_stun:IsHidden() return false end

function modifier_imba_split_earth_stun:IsPurgable() return false end

function modifier_imba_split_earth_stun:IsDebuff() return true end

function modifier_imba_split_earth_stun:IsStunDebuff() return true end

function modifier_imba_split_earth_stun:IsPurgeException() return true end

function modifier_imba_split_earth_stun:IsStunDebuff() return true end

function modifier_imba_split_earth_stun:CheckState()
	return { [MODIFIER_STATE_STUNNED] = true }
end

function modifier_imba_split_earth_stun:DeclareFunctions()
	return { MODIFIER_PROPERTY_OVERRIDE_ANIMATION }
end

function modifier_imba_split_earth_stun:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_imba_split_earth_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_split_earth_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-----------------------------------
-- EMPOWERED SPLIT BUFF MODIFIER --
-----------------------------------
modifier_imba_split_earth_empowered_split = modifier_imba_split_earth_empowered_split or class({})

function modifier_imba_split_earth_empowered_split:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials	
	self.empowered_split_duration = self.ability:GetSpecialValueFor("empowered_split_duration")

	-- Talent: Empowered Split Earth stack duration increase
	if self.caster:HasTalent("special_bonus_unique_imba_leshrac_empowered_split_earth_duration") then
		self.empowered_split_duration = self.empowered_split_duration + self.caster:FindTalentValue("special_bonus_unique_imba_leshrac_empowered_split_earth_duration")
	end

	-- Initialize stacks table
	self.stack_table = {}

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(1)
	end
end

function modifier_imba_split_earth_empowered_split:OnStackCountChanged(prev_stacks)
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

function modifier_imba_split_earth_empowered_split:OnIntervalThink()
	local repeat_needed = true

	-- We''ll repeat the table removal check and remove as many expired items from it as needed.
	while repeat_needed do
		-- Check if the firstmost entry in the table has expired
		local item_time = self.stack_table[1]

		-- If the difference between times is longer, it's time to get rid of a stack
		if GameRules:GetGameTime() - item_time >= self.empowered_split_duration then
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

function modifier_imba_split_earth_empowered_split:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2 }

	return decFuncs
end

function modifier_imba_split_earth_empowered_split:OnTooltip()
	return self.ability:GetSpecialValueFor("empowered_split_radius") * self:GetStackCount()
end

function modifier_imba_split_earth_empowered_split:OnTooltip2()
	return self.ability:GetSpecialValueFor("empowered_split_damage") * self:GetStackCount()
end

---------------------------------------------------------
-- SPLIT EARTH TORMENTED SOUL FORM TRUE SIGHT MODIFIER --
---------------------------------------------------------

modifier_imba_split_earth_tormented_true_sight = modifier_imba_split_earth_tormented_true_sight or class({})

function modifier_imba_split_earth_tormented_true_sight:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_PROVIDES_FOW_POSITION }

	return decFuncs
end

function modifier_imba_split_earth_tormented_true_sight:GetModifierProvidesFOWVision()
	return 1
end

--------------------
-- DIABOLIC EDICT --
--------------------

LinkLuaModifier("modifier_imba_leshrac_diabolic_edict", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_leshrac_diabolic_edict_weakening_torment", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)

imba_leshrac_diabolic_edict = imba_leshrac_diabolic_edict or class({})

function imba_leshrac_diabolic_edict:OnSpellStart(ese_target, ese_explosion_count)
	if IsClient() then return end

	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_sound = "Hero_Leshrac.Diabolic_Edict_lp"
	local modifier_diabolic = "modifier_imba_leshrac_diabolic_edict"

	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")

	-- Play cast sound
	self:GetCaster():EmitSound(cast_sound)

	-- If this is a Pulse Nova Earth Storm Edict cast, adjust values
	if ese_target and ese_explosion_count then
		local num_explosions = ability:GetSpecialValueFor("num_explosions")

		-- Calculate the explosion rate for the explosion count and set it as the duration
		duration = duration / num_explosions * ese_explosion_count

		-- Give special cast
		self:GetCaster():AddNewModifier(caster, ability, modifier_diabolic, { duration = duration, ese_explosion_count = ese_explosion_count, ese_target = ese_target:entindex() })
	else
		-- Normal cast
		self:GetCaster():AddNewModifier(caster, ability, modifier_diabolic, { duration = duration })
	end
end

-----------------------------
-- DIABOLIC EDICT MODIFIER --
-----------------------------

modifier_imba_leshrac_diabolic_edict = class({})

function modifier_imba_leshrac_diabolic_edict:IsHidden() return false end

function modifier_imba_leshrac_diabolic_edict:IsDebuff() return false end

function modifier_imba_leshrac_diabolic_edict:IsPurgable() return false end

function modifier_imba_leshrac_diabolic_edict:RemoveOnDeath() return false end

function modifier_imba_leshrac_diabolic_edict:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_leshrac_diabolic_edict:OnCreated(keys)
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	if IsClient() then return end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.hit_sound = "Hero_Leshrac.Diabolic_Edict"
	self.particle_explosion = "particles/hero/leshrac/leshrac_diabolic_edict.vpcf"
	self.particle_ring = "particles/hero/leshrac/leshrac_purity_casing_ring.vpcf"
	self.particle_hit = "particles/hero/leshrac/leshrac_purity_casing_hit.vpcf"
	self.modifier_tormented = "modifier_imba_tormented_soul_form"
	self.modifier_weakening = "modifier_imba_leshrac_diabolic_edict_weakening_torment"

	-- Ability specials
	self.num_explosions = self.ability:GetSpecialValueFor("num_explosions") + self.caster:FindTalentValue("special_bonus_unique_leshrac_1")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.tower_bonus = self.ability:GetSpecialValueFor("tower_bonus")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.tormented_soul_weakening_duration = self.ability:GetSpecialValueFor("tormented_soul_weakening_duration")
	self.diabolic_adapt_radius_inc = self.ability:GetSpecialValueFor("diabolic_adapt_radius_inc")
	self.diabolic_adapt_duration_inc = self.ability:GetSpecialValueFor("diabolic_adapt_duration_inc")
	self.purity_casing_radius = self.ability:GetSpecialValueFor("purity_casing_radius")
	self.purity_casing_fixed_dmg = self.ability:GetSpecialValueFor("purity_casing_fixed_dmg")
	self.purity_casing_dmg_per_stack = self.ability:GetSpecialValueFor("purity_casing_dmg_per_stack")
	self.purity_casing_ring_duration = self.ability:GetSpecialValueFor("purity_casing_ring_duration")

	-- Talent: Diabolic Edict explosions increase (only applicable on standard casts)
	if self.caster:HasTalent("special_bonus_unique_imba_leshrac_diabolic_edict_explosions") then
		self.num_explosions = self.num_explosions + self.caster:FindTalentValue("special_bonus_unique_imba_leshrac_diabolic_edict_explosions")
	end

	-- If this is a Pulse Nova Earth Storm Edict cast, adjust values and set target	
	if keys.ese_explosion_count and keys.ese_target then
		self.num_explosions = keys.ese_explosion_count
		self.target = EntIndexToHScript(keys.ese_target)
	end

	-- Calculate delay between each explosion
	self.delay = self:GetDuration() / self.num_explosions

	-- IMBAfication: Diabolic Adaptation
	self.explosion_radius = 0

	self:StartIntervalThink(self.delay)
end

function modifier_imba_leshrac_diabolic_edict:OnIntervalThink()
	if not IsServer() then return end

	-- If this is a Pulse Nova Earth Storm Edict cast, hit the target only and do nothing else
	if self.target and self.target:IsAlive() and IsValidEntity(self.target) then
		self:DiabolicEditExplosion(self.target)
		return
	end

	-- Find all nearby enemies	
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
		self.caster:GetAbsOrigin(),
		nil,
		self.radius,
		self:GetAbility():GetAbilityTargetTeam(),
		self:GetAbility():GetAbilityTargetType(),
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)

	local enemy = enemies[RandomInt(1, #enemies)]
	if enemy then
		self:DiabolicEditExplosion(enemy)
	else
		self:DiabolicEditExplosion(nil)

		-- IMBAfication: Purity casing (procs whenever it doesn't hit anything)
		self:IncrementStackCount()
	end
end

function modifier_imba_leshrac_diabolic_edict:DiabolicEditExplosion(target)
	-- Create Particle	
	local pfx = ParticleManager:CreateParticle(self.particle_explosion, PATTACH_CUSTOMORIGIN, nil, self.caster)
	local position_cast

	if target then
		position_cast = target:GetAbsOrigin()

		local damage = self.damage
		-- Calculate tower bonus, if relevant
		if target:IsBuilding() then
			damage = damage * (1 + self.tower_bonus / 100)
		end

		ApplyDamage({
			attacker = self.caster,
			victim = target,
			damage = damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK,
			ability = self.ability
		})

		-- Tormented Soul Form active: Weakning Torment
		if self.caster:HasModifier(self.modifier_tormented) then
			-- Add weakning modifier if enemy doesn't have it already
			if not target:HasModifier(self.modifier_weakening) then
				target:AddNewModifier(self.caster, self.ability, self.modifier_weakening, { duration = self.tormented_soul_weakening_duration * (1 - target:GetStatusResistance()) })
			end

			-- Increase stacks and refresh the modifier
			local modifier_weakening_handle = target:FindModifierByName(self.modifier_weakening)
			if modifier_weakening_handle then
				modifier_weakening_handle:IncrementStackCount()
				modifier_weakening_handle:ForceRefresh()
			end
		end

		-- Diabolic Adaptation radius and duration increase
		if target:IsRealHero() then
			self.explosion_radius = self.explosion_radius + self.diabolic_adapt_radius_inc
			self:SetDuration(self:GetRemainingTime() + self.diabolic_adapt_duration_inc, true)
		end

		-- Play particle effects. For clarity, particle should be at least 50-100 in radius (this is how it originally behaves)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 2, Vector(max(self.explosion_radius, RandomInt(50, 100)), 0, 0))

		-- If explosion radius is bigger than 0, look for enemies in range to deal damage (no buildings!)
		if self.explosion_radius > 0 then
			local explosion_enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
				self.caster:GetAbsOrigin(),
				nil,
				self.explosion_radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false)

			for _, explosion_enemy in pairs(explosion_enemies) do
				-- Doesn't include the explosion target
				if explosion_enemy ~= target then
					local damageTable = {
						victim = explosion_enemy,
						attacker = self.caster,
						damage = self.damage,
						damage_type = self.ability:GetAbilityDamageType(),
						ability = self.ability
					}

					ApplyDamage(damageTable)
				end
			end
		end
	else
		position_cast = self.caster:GetAbsOrigin() + RandomVector(RandomInt(0, self.radius))
		ParticleManager:SetParticleControl(pfx, 1, position_cast)
	end

	EmitSoundOnLocationWithCaster(position_cast, self.hit_sound, self.caster)
	ParticleManager:ReleaseParticleIndex(pfx)
end

function modifier_imba_leshrac_diabolic_edict:OnDestroy()
	if not IsServer() then return end

	self:GetParent():StopSound("Hero_Leshrac.Diabolic_Edict_lp")

	-- IMBAfication: Purity Casing
	-- Only takes effect if the stacks count is at least 1
	if self:GetStackCount() <= 0 then return end

	-- Fire particle
	self.particle_ring_fx = ParticleManager:CreateParticle(self.particle_ring, PATTACH_ABSORIGIN_FOLLOW, self.caster, self.caster)
	ParticleManager:SetParticleControl(self.particle_ring_fx, 0, self.caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_ring_fx, 1, Vector(100, 0, self.purity_casing_radius))
	ParticleManager:ReleaseParticleIndex(self.particle_ring_fx)

	-- Calculate the damage to be applied
	local damage = self.purity_casing_fixed_dmg + self.purity_casing_dmg_per_stack * self:GetStackCount()

	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
		self.caster:GetAbsOrigin(),
		nil,
		self.purity_casing_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	for _, enemy in pairs(enemies) do
		local damageTable = {
			victim = enemy,
			attacker = self.caster,
			damage = damage,
			damage_type = self.ability:GetAbilityDamageType(),
			ability = self.ability
		}

		ApplyDamage(damageTable)

		-- Fire hit particles
		self.particle_hit_fx = ParticleManager:CreateParticle(self.particle_hit, PATTACH_ABSORIGIN_FOLLOW, enemy, self.caster)
		ParticleManager:SetParticleControl(self.particle_hit_fx, 0, enemy:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.particle_hit_fx)
	end
end

-----------------------------------------
-- TORMENTED WEAKENING DEBUFF MODIFIER --
-----------------------------------------

modifier_imba_leshrac_diabolic_edict_weakening_torment = modifier_imba_leshrac_diabolic_edict_weakening_torment or class({})

function modifier_imba_leshrac_diabolic_edict_weakening_torment:IsHidden() return false end

function modifier_imba_leshrac_diabolic_edict_weakening_torment:IsPurgable() return true end

function modifier_imba_leshrac_diabolic_edict_weakening_torment:IsDebuff() return true end

function modifier_imba_leshrac_diabolic_edict_weakening_torment:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.tormented_soul_phys_armor_rdct = self.ability:GetSpecialValueFor("tormented_soul_phys_armor_rdct")
	self.tormented_soul_magic_resist_rdct = self.ability:GetSpecialValueFor("tormented_soul_magic_resist_rdct")
end

function modifier_imba_leshrac_diabolic_edict_weakening_torment:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS }

	return decFuncs
end

function modifier_imba_leshrac_diabolic_edict_weakening_torment:GetModifierPhysicalArmorBonus()
	return self.tormented_soul_phys_armor_rdct * self:GetStackCount() * (-1)
end

function modifier_imba_leshrac_diabolic_edict_weakening_torment:GetModifierMagicalResistanceBonus()
	return self.tormented_soul_magic_resist_rdct * self:GetStackCount() * (-1)
end

---------------------
-- LIGHTNING STORM --
---------------------
LinkLuaModifier("modifier_imba_leshrac_lightning_storm_slow", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_leshrac_lightning_storm_scepter_thinker", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_leshrac_lightning_storm_lightning_rider", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_leshrac_lightning_storm_tormented_cloud_aura", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_leshrac_lightning_storm_tormented_cloud_debuff", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_leshrac_lightning_storm_tormented_mark", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)

imba_leshrac_lightning_storm = imba_leshrac_lightning_storm or class({})

function imba_leshrac_lightning_storm:GetBehavior()
	local caster = self:GetCaster()
	local modifier_tormented = "modifier_imba_tormented_soul_form"

	if caster:HasModifier(modifier_tormented) then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
	end

	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end

function imba_leshrac_lightning_storm:GetAOERadius()
	local caster = self:GetCaster()
	local modifier_tormented = "modifier_imba_tormented_soul_form"

	if caster:HasModifier(modifier_tormented) then
		return self:GetSpecialValueFor("tormented_soul_aoe_radius")
	end

	return 0
end

function imba_leshrac_lightning_storm:OnSpellStart(ese_target, ese_jump_count)
	if IsClient() then return end

	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = ability:GetCursorTarget()
	local modifier_tormented = "modifier_imba_tormented_soul_form"
	local modifier_tormented_mark = "modifier_imba_leshrac_lightning_storm_tormented_mark"

	-- Ability specials
	local jump_count = ability:GetSpecialValueFor("jump_count")
	local radius = ability:GetSpecialValueFor("radius")
	local jump_delay = ability:GetSpecialValueFor("jump_delay")
	local tormented_soul_aoe_radius = ability:GetSpecialValueFor("tormented_soul_aoe_radius")
	local tormented_soul_mark_duration = ability:GetSpecialValueFor("tormented_soul_mark_duration")

	-- If this is a Pulse Nova's Earth Edict and Storm cast, adjust values
	if ese_target and ese_jump_count then
		target = ese_target
		jump_count = ese_jump_count
	end

	-- If the target has Linken's Sphere, do nothing
	if target:TriggerSpellAbsorb(ability) then
		return nil
	end

	-- Variables
	local remaining_jumps = jump_count + 1 -- initial target doesn't count as a jump
	local enemies_table = {}
	local tormented_cast = false

	if caster:HasModifier(modifier_tormented) then
		tormented_cast = true
	end

	-- If this is a tormented cast, find units in the AoE and give them the tormented mark debuff
	if tormented_cast then
		local marked_units = FindUnitsInRadius(caster:GetTeamNumber(),
			target:GetAbsOrigin(),
			nil,
			tormented_soul_aoe_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
			FIND_ANY_ORDER,
			false)

		for _, marked_unit in pairs(marked_units) do
			marked_unit:AddNewModifier(caster, ability, modifier_tormented_mark, { duration = tormented_soul_mark_duration * (1 - marked_unit:GetStatusResistance()) })
		end
	end

	-- Wait for the delay between each jump
	Timers:CreateTimer(function()
		-- Hit it with lightning
		self:LaunchLightningBoltOnTarget(target)

		-- Add the target to the list of enemies hit so it can't be hit again
		-- ..Unless he has the tormented mark on it
		if not target:HasModifier(modifier_tormented_mark) then
			enemies_table[target:entindex()] = true
		end

		-- Reduce jumps by 1
		remaining_jumps = remaining_jumps - 1

		-- If there are anymore jumps left, look for a random unit in radius
		if remaining_jumps > 0 then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
				target:GetAbsOrigin(),
				nil,
				radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
				FIND_ANY_ORDER,
				false)

			for _, enemy in pairs(enemies) do
				-- Check that this enemy is different from the target and isn't in the enemies hit table
				if not enemies_table[enemy:entindex()] and enemy ~= target then
					-- If it's not (was not hit), then set it as the target
					target = enemy

					-- Repeat timer
					return jump_delay
				end
			end
		end

		-- If no jumps are left, or no units are found, stop repeating the timer.
		return nil
	end)
end

function imba_leshrac_lightning_storm:LaunchLightningBoltOnTarget(target)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local hit_sound = "Hero_Leshrac.Lightning_Storm"
	local particle_bolt = "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf" --cp0 hitloc location, cp1 lightning spawn location, cp2 location, cp5 location, 	
	local modifier_slow = "modifier_imba_leshrac_lightning_storm_slow"
	local modifier_rider = "modifier_imba_leshrac_lightning_storm_lightning_rider"

	-- Ability specials
	local slow_duration = ability:GetSpecialValueFor("slow_duration")
	local rider_stack_duration = ability:GetSpecialValueFor("rider_stack_duration")

	-- Talent: Lightning Storm slow duration increase
	if caster:HasTalent("special_bonus_unique_imba_leshrac_lightning_storm_duration") then
		slow_duration = slow_duration + caster:FindTalentValue("special_bonus_unique_imba_leshrac_lightning_storm_duration")
	end

	-- Play hit sound
	EmitSoundOn(hit_sound, target)

	-- Play lightning particle
	local particle_bolt_fx = ParticleManager:CreateParticle(particle_bolt, PATTACH_ABSORIGIN, target, caster)
	ParticleManager:SetParticleControlEnt(particle_bolt_fx, 0, target, PATTACH_ABSORIGIN, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_bolt_fx, 1, target:GetAbsOrigin() + Vector(0, 0, 2000))
	ParticleManager:SetParticleControl(particle_bolt_fx, 2, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_bolt_fx, 5, target:GetAbsOrigin())

	-- If the target suddenly became spell immune, do nothing
	if target:IsMagicImmune() or target:IsOutOfGame() or target:IsInvulnerable() then
		return nil
	end

	-- Damage the unit
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = ability:GetAbilityDamage(),
		damage_type = ability:GetAbilityDamageType(),
		ability = ability
	}

	ApplyDamage(damageTable)

	-- Give it the slow modifier
	target:AddNewModifier(caster, ability, modifier_slow, { duration = slow_duration * (1 - target:GetStatusResistance()) })

	-- IMBAfication: Lightning Rider
	-- If caster doesn't have the buff, give it to him
	if not caster:HasModifier(modifier_rider) then
		caster:AddNewModifier(caster, ability, modifier_rider, { duration = rider_stack_duration })
	end

	-- Find modifier and increment stacks based on target type
	local modifier_rider_handle = caster:FindModifierByName(modifier_rider)
	if modifier_rider_handle then
		modifier_rider_handle:IncrementStackCount()
	end
end

function imba_leshrac_lightning_storm:OnInventoryContentsChanged()
	local modifier_thinker = "modifier_imba_leshrac_lightning_storm_scepter_thinker"

	-- Caster now has a scepter
	if self:GetCaster():HasScepter() then
		if not self:GetCaster():HasModifier(modifier_thinker) then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, modifier_thinker, {})
		end
	else
		-- Caster no longer has a scepter effect due to it dropping it - remove the thinker
		if self:GetCaster():HasModifier(modifier_thinker) then
			self:GetCaster():RemoveModifierByName(modifier_thinker)
		end
	end
end

-----------------------------------
-- LIGHTNING STORM SLOW MODIFIER --
-----------------------------------

modifier_imba_leshrac_lightning_storm_slow = modifier_imba_leshrac_lightning_storm_slow or class({})

function modifier_imba_leshrac_lightning_storm_slow:IsHidden() return false end

function modifier_imba_leshrac_lightning_storm_slow:IsDebuff() return true end

function modifier_imba_leshrac_lightning_storm_slow:IsPurgable() return true end

function modifier_imba_leshrac_lightning_storm_slow:OnCreated()
	if not self:GetAbility() then
		if IsServer() then
			self:Destroy()
		end

		return
	end

	-- Ability specials
	self.slow_movement_speed = self:GetAbility():GetSpecialValueFor("slow_movement_speed")

	if not IsServer() then return end

	-- Ability properties
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.particle_slow = "particles/units/heroes/hero_leshrac/leshrac_lightning_slow.vpcf" --cp0 location, cp1 location

	-- Create particle effect
	self.particle_slow_fx = ParticleManager:CreateParticle(self.particle_slow, PATTACH_ABSORIGIN_FOLLOW, self.parent, self.caster)
	ParticleManager:SetParticleControl(self.particle_slow_fx, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_slow_fx, 1, self.parent:GetAbsOrigin())
	self:AddParticle(self.particle_slow_fx, false, false, -1, false, false)
end

function modifier_imba_leshrac_lightning_storm_slow:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }

	return decFuncs
end

function modifier_imba_leshrac_lightning_storm_slow:GetModifierMoveSpeedBonus_Percentage()
	if self.slow_movement_speed and self.slow_movement_speed ~= 0 then
		return self.slow_movement_speed * (-1)
	end
end

----------------------------------------------
-- LIGHTNING STORM SCEPTER THINKER MODIFIER --
----------------------------------------------

modifier_imba_leshrac_lightning_storm_scepter_thinker = modifier_imba_leshrac_lightning_storm_scepter_thinker or class({})

function modifier_imba_leshrac_lightning_storm_scepter_thinker:IsHidden() return true end

function modifier_imba_leshrac_lightning_storm_scepter_thinker:IsPurgable() return false end

function modifier_imba_leshrac_lightning_storm_scepter_thinker:IsDebuff() return false end

function modifier_imba_leshrac_lightning_storm_scepter_thinker:RemoveOnDeath() return false end

function modifier_imba_leshrac_lightning_storm_scepter_thinker:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_nova = "modifier_imba_leshrac_pulse_nova"

	-- Ability specials
	self.radius_scepter = self.ability:GetSpecialValueFor("radius_scepter")
	self.interval_scepter = self.ability:GetSpecialValueFor("interval_scepter")

	if IsServer() then
		-- Flag that determines whether or not a lightning can hit a target
		self.lightning_ready = true
	end

	self:StartIntervalThink(0.1)
end

function modifier_imba_leshrac_lightning_storm_scepter_thinker:OnIntervalThink()
	if not IsServer() then return end

	-- If the caster doesn't have Pulse Nova active, do nothing
	if not self.caster:HasModifier(self.modifier_nova) then return end

	-- Check if the lightning is ready to be launched
	if not self.lightning_ready then return end

	-- Search for nearby enemies
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
		self.caster:GetAbsOrigin(),
		nil,
		self.radius_scepter,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
		FIND_ANY_ORDER,
		false)

	-- If no units were found, do nothing else
	if #enemies == 0 then return end

	-- The lightning prioritizes heroes, so look for heroes first
	local enemy_found = false
	local chosen_enemy
	for _, enemy in pairs(enemies) do
		if enemy:IsHero() then
			enemy_found = true
			chosen_enemy = enemy
			break
		end
	end

	-- If no heroes were found, just choose a random enemy
	if not enemy_found then
		chosen_enemy = enemies[RandomInt(1, #enemies)]
		enemy_found = true
	end

	if chosen_enemy and enemy_found then
		-- Zap it!
		self.ability:LaunchLightningBoltOnTarget(chosen_enemy)

		-- Flag the lightning tag be unavailable
		self.lightning_ready = false

		-- Start timer that readies up the lightning flag
		Timers:CreateTimer(self.interval_scepter, function()
			self.lightning_ready = true
		end)
	end
end

-----------------------------------
-- LIGHTNING RIDER BUFF MODIFIER --
-----------------------------------

modifier_imba_leshrac_lightning_storm_lightning_rider = modifier_imba_leshrac_lightning_storm_lightning_rider or class({})

function modifier_imba_leshrac_lightning_storm_lightning_rider:IsHidden() return false end

function modifier_imba_leshrac_lightning_storm_lightning_rider:IsPurgable() return true end

function modifier_imba_leshrac_lightning_storm_lightning_rider:IsDebuff() return false end

function modifier_imba_leshrac_lightning_storm_lightning_rider:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.rider_ms_per_stack_pct = self.ability:GetSpecialValueFor("rider_ms_per_stack_pct")
	self.rider_stack_duration = self.ability:GetSpecialValueFor("rider_stack_duration")
	self.rider_static_ms_limit = self.ability:GetSpecialValueFor("rider_static_ms_limit")
	self.rider_static_limit_per_stack = self.ability:GetSpecialValueFor("rider_static_limit_per_stack")

	-- Initialize stacks table
	self.stack_table = {}

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(1)
	end
end

function modifier_imba_leshrac_lightning_storm_lightning_rider:OnStackCountChanged(prev_stacks)
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

function modifier_imba_leshrac_lightning_storm_lightning_rider:OnIntervalThink()
	local repeat_needed = true

	-- We'll repeat the table removal check and remove as many expired items from it as needed.
	while repeat_needed do
		-- Check if the firstmost entry in the table has expired
		local item_time = self.stack_table[1]

		-- If the difference between times is longer, it's time to get rid of a stack
		if GameRules:GetGameTime() - item_time >= self.rider_stack_duration then
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

function modifier_imba_leshrac_lightning_storm_lightning_rider:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT }

	return decFuncs
end

function modifier_imba_leshrac_lightning_storm_lightning_rider:GetModifierMoveSpeedBonus_Percentage()
	return self.rider_ms_per_stack_pct * self:GetStackCount()
end

function modifier_imba_leshrac_lightning_storm_lightning_rider:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_imba_leshrac_lightning_storm_lightning_rider:GetModifierMoveSpeed_Limit()
	return self.rider_static_ms_limit + self.rider_static_limit_per_stack * self:GetStackCount()
end

-----------------------------------
-- TORMENTED CLOUD AURA MODIFIER --
-----------------------------------

modifier_imba_leshrac_lightning_storm_tormented_cloud_aura = modifier_imba_leshrac_lightning_storm_tormented_cloud_aura or class({})

function modifier_imba_leshrac_lightning_storm_tormented_cloud_aura:IsHidden() return true end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_aura:IsPurgable() return false end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_aura:IsDebuff() return false end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_aura:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_storm_cloud = "particles/hero/leshrac/leshrac_tormented_lightning_storm_cloud.vpcf"
	self.modifier_aura_debuff = "modifier_imba_leshrac_lightning_storm_tormented_cloud_debuff"

	-- Ability specials
	self.tormented_soul_cast_aura_radius = self.ability:GetSpecialValueFor("tormented_soul_cast_aura_radius")

	if IsServer() then
		-- Create particle		
		self.particle_storm_cloud_fx = ParticleManager:CreateParticle(self.particle_storm_cloud, PATTACH_WORLDORIGIN, nil, self.caster)
		ParticleManager:SetParticleControl(self.particle_storm_cloud_fx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_storm_cloud_fx, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_storm_cloud_fx, 2, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_storm_cloud_fx, 3, Vector(self.tormented_soul_cast_aura_radius, 0, 0))
		ParticleManager:SetParticleControl(self.particle_storm_cloud_fx, 62, Vector(1, 1, 1))
		self:AddParticle(self.particle_storm_cloud_fx, false, false, -1, false, false)
	end
end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_aura:DeclareFunctions()
	local decFuncs = { MODIFIER_EVENT_ON_DEATH }

	return decFuncs
end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_aura:OnDeath(keys)
	if not IsServer() then return end

	-- Only apply if the dead unit is the caster
	if keys.unit == self.caster then
		self.parent:ForceKill(false)
		self:Destroy()
	end
end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_aura:GetAuraRadius()
	return self.tormented_soul_cast_aura_radius
end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_aura:GetModifierAura()
	return self.modifier_aura_debuff
end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_aura:IsAura()
	return true
end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_aura:GetAuraDuration()
	return 0.1
end

------------------------------------------
-- TORMENTED CLOUD AURA DEBUFF MODIFIER --
------------------------------------------

modifier_imba_leshrac_lightning_storm_tormented_cloud_debuff = modifier_imba_leshrac_lightning_storm_tormented_cloud_debuff or class({})

function modifier_imba_leshrac_lightning_storm_tormented_cloud_debuff:IsHidden() return false end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_debuff:IsPurgable() return false end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_debuff:IsDebuff() return true end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_debuff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.tormented_soul_cast_zap_chance = self.ability:GetSpecialValueFor("tormented_soul_cast_zap_chance")
	self.tormented_soul_cast_interval = self.ability:GetSpecialValueFor("tormented_soul_cast_interval")

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(self.tormented_soul_cast_interval)
	end
end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_debuff:OnIntervalThink()
	-- Roll for a thunder hit
	if RollPseudoRandom(self.tormented_soul_cast_zap_chance, self) then
		self.ability:LaunchLightningBoltOnTarget(self.parent)
	end
end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_debuff:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2 }

	return decFuncs
end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_debuff:OnTooltip()
	return self.tormented_soul_cast_zap_chance
end

function modifier_imba_leshrac_lightning_storm_tormented_cloud_debuff:OnTooltip2()
	return self.tormented_soul_cast_interval
end

------------------------------------
-- TORMENTED MARK DEBUFF MODIFIER --
------------------------------------

modifier_imba_leshrac_lightning_storm_tormented_mark = modifier_imba_leshrac_lightning_storm_tormented_mark or class({})

function modifier_imba_leshrac_lightning_storm_tormented_mark:IsHidden() return false end

function modifier_imba_leshrac_lightning_storm_tormented_mark:IsPurgable() return false end

function modifier_imba_leshrac_lightning_storm_tormented_mark:IsDebuff() return true end

function modifier_imba_leshrac_lightning_storm_tormented_mark:GetEffectName()
	return "particles/hero/leshrac/leshrac_lightning_storm_tormented_mark.vpcf"
end

function modifier_imba_leshrac_lightning_storm_tormented_mark:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

----------------
-- PULSE NOVA --
----------------
LinkLuaModifier("modifier_imba_leshrac_pulse_nova", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_leshrac_pulse_nova_earth_edict_storm_debuff", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)

imba_leshrac_pulse_nova = imba_leshrac_pulse_nova or class({})

function imba_leshrac_pulse_nova:GetCastRange(location, target)
	return self:GetSpecialValueFor("radius") + self:GetCaster():FindTalentValue("special_bonus_unique_imba_leshrac_pulse_nova_radius")
end

function imba_leshrac_pulse_nova:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local ability_tormented_soul = "imba_leshrac_tormented_soul_form"

	if caster:HasAbility(ability_tormented_soul) then
		local ability_tormented_soul_handle = caster:FindAbilityByName(ability_tormented_soul)
		if ability_tormented_soul_handle then
			ability_tormented_soul_handle:SetLevel(ability_tormented_soul_handle:GetLevel() + 1)
		end
	end
end

function imba_leshrac_pulse_nova:OnToggle()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_sound = "Hero_Leshrac.Pulse_Nova"
	local modifier_nova = "modifier_imba_leshrac_pulse_nova"

	-- Check toggle state
	local state = ability:GetToggleState()

	if state then
		-- Toggled on: Grant Leshrac the Pulse Nova modifier
		caster:AddNewModifier(caster, ability, modifier_nova, {})
	else
		-- Toggled off: Remove Leshrac the Pulse Nova modifier
		caster:RemoveModifierByName(modifier_nova)
	end
end

-------------------------
-- PULSE NOVA MODIFIER --
-------------------------

modifier_imba_leshrac_pulse_nova = modifier_imba_leshrac_pulse_nova or class({})

function modifier_imba_leshrac_pulse_nova:IsHidden() return false end

function modifier_imba_leshrac_pulse_nova:IsPurgable() return false end

function modifier_imba_leshrac_pulse_nova:IsDebuff() return false end

function modifier_imba_leshrac_pulse_nova:RemoveOnDeath() return true end

function modifier_imba_leshrac_pulse_nova:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.sound_hit = "Hero_Leshrac.Pulse_Nova_Strike"
	self.particle_hit = "particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf"
	self.modifier_ese = "modifier_imba_leshrac_pulse_nova_earth_edict_storm_debuff"
	self.modifier_tormented = "modifier_imba_tormented_soul_form"

	-- Ability specials
	self.mana_cost_per_second = self.ability:GetSpecialValueFor("mana_cost_per_second")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.interval = self.ability:GetSpecialValueFor("interval")
	self.nova_circulation_radius_per_hit = self.ability:GetSpecialValueFor("nova_circulation_radius_per_hit")
	self.nova_circulation_max_radius = self.ability:GetSpecialValueFor("nova_circulation_max_radius")
	self.ese_debuff_duration = self.ability:GetSpecialValueFor("ese_debuff_duration")
	self.tormented_soul_interval_rdct_pct = self.ability:GetSpecialValueFor("tormented_soul_interval_rdct_pct")

	-- Talent: Pulse Nova radius increase
	if self.caster:HasTalent("special_bonus_unique_imba_leshrac_pulse_nova_radius") then
		self.radius = self.radius + self.caster:FindTalentValue("special_bonus_unique_imba_leshrac_pulse_nova_radius")
	end

	self.mana_cost_per_interval = self.mana_cost_per_second * self.interval

	if IsServer() then
		-- Flag tormented intervals
		self.tormented_pulse = false
		if self.caster:HasModifier(self.modifier_tormented) then
			self.tormented_pulse = true
		end

		local actual_interval = self.interval
		-- If this pulse is a tormented pulse, reduce interval
		if self.tormented_pulse then
			actual_interval = actual_interval * (1 - (self.tormented_soul_interval_rdct_pct / 100))
		end

		self.circulation_bonus_radius = 0
		self:OnIntervalThink()
		self:StartIntervalThink(actual_interval)
	end
end

function modifier_imba_leshrac_pulse_nova:OnIntervalThink(tormented_radius)
	if not IsServer() then return end

	-- If we have a value here, then this is a tormented instance
	local tormented_cast = false
	if tormented_radius then
		tormented_cast = true
	end

	-- Check if there is enough mana to keep the spell toggled on; otherwise, toggle off and stop this effect
	if self.caster:GetMana() < self.mana_cost_per_interval then
		self.ability:ToggleAbility()
	end

	-- Spend the mana cost for the interval
	self.caster:SpendMana(self.mana_cost_per_interval, self.ability)

	local actual_radius = self.radius + self.circulation_bonus_radius
	if tormented_cast then
		actual_radius = actual_radius * tormented_radius
	end

	-- Find all enemies in range of Leshrac
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
		self.caster:GetAbsOrigin(),
		nil,
		actual_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_DAMAGE_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	local damage = self.damage
	-- Talent: Pulse Nova damage increase per enemy in radius
	if self.caster:HasTalent("special_bonus_unique_imba_leshrac_pulse_nova_damage") then
		damage = damage + self.caster:FindTalentValue("special_bonus_unique_imba_leshrac_pulse_nova_damage") * #enemies
	end

	-- Iterate between enemies
	for _, enemy in pairs(enemies) do
		-- Play hit sound
		EmitSoundOn(self.sound_hit, enemy)

		-- Apply particle effect on enemy
		self.particle_hit_fx = ParticleManager:CreateParticle(self.particle_hit, PATTACH_ABSORIGIN, enemy, self.caster)
		ParticleManager:SetParticleControl(self.particle_hit_fx, 0, enemy:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_hit_fx, 1, Vector(1, 0, 0))
		ParticleManager:ReleaseParticleIndex(self.particle_hit_fx)

		local damageTable
		if tormented_cast then
			-- Tormented cast: Deal PURE damage to enemy
			damageTable = {
				victim = enemy,
				attacker = self.caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_PURE,
				ability = self.ability
			}
		else
			-- Deal standard type damage to enemy
			damageTable = {
				victim = enemy,
				attacker = self.caster,
				damage = damage,
				damage_type = self.ability:GetAbilityDamageType(),
				ability = self.ability
			}
		end

		ApplyDamage(damageTable)

		-- IMBAfication: Earth Storm and Edict:
		if not enemy:HasModifier(self.modifier_ese) then
			enemy:AddNewModifier(self.caster, self.ability, self.modifier_ese, { duration = self.ese_debuff_duration })
		end

		-- Add a stack for the hit
		local modifier_ese_handle = enemy:FindModifierByName(self.modifier_ese)
		if modifier_ese_handle then
			modifier_ese_handle:IncrementStackCount()
			modifier_ese_handle:ForceRefresh()
		end

		-- IMBAfication: Nova Circulation
		self.circulation_bonus_radius = self.circulation_bonus_radius + self.nova_circulation_radius_per_hit
		if self.circulation_bonus_radius >= self.nova_circulation_max_radius then
			self.circulation_bonus_radius = self.nova_circulation_max_radius
		end
	end

	-- Check if the status of the tormented pulses changed	
	if self.caster:HasModifier(self.modifier_tormented) ~= self.tormented_pulse then
		-- If the status changed, calculate interval, then restart the timer
		local actual_interval = self.interval
		if self.caster:HasModifier(self.modifier_tormented) then
			-- Flag pulse
			self.tormented_pulse = true

			-- Tormented pulse, reduce interval			
			actual_interval = actual_interval * (1 - (self.tormented_soul_interval_rdct_pct / 100))
		else
			-- Flag non-pulse
			self.tormented_pulse = false
		end

		-- Adjust interval		
		self:StartIntervalThink(actual_interval)
	end
end

function modifier_imba_leshrac_pulse_nova:GetEffectName()
	return "particles/units/heroes/hero_leshrac/leshrac_pulse_nova_ambient.vpcf"
end

function modifier_imba_leshrac_pulse_nova:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-------------------------------------------
-- EARTH STORM AND EDICT DEBUFF MODIFIER --
-------------------------------------------

modifier_imba_leshrac_pulse_nova_earth_edict_storm_debuff = modifier_imba_leshrac_pulse_nova_earth_edict_storm_debuff or class({})

function modifier_imba_leshrac_pulse_nova_earth_edict_storm_debuff:IsHidden() return false end

function modifier_imba_leshrac_pulse_nova_earth_edict_storm_debuff:IsPurgable() return true end

function modifier_imba_leshrac_pulse_nova_earth_edict_storm_debuff:IsDebuff() return true end

function modifier_imba_leshrac_pulse_nova_earth_edict_storm_debuff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.ability_earth = "imba_leshrac_split_earth"
	self.ability_edict = "imba_leshrac_diabolic_edict"
	self.ability_storm = "imba_leshrac_lightning_storm"

	-- Ability specials
	self.ese_stacks_threshold = self.ability:GetSpecialValueFor("ese_stacks_threshold")
	self.ese_earth_proc_chance = self.ability:GetSpecialValueFor("ese_earth_proc_chance")
	self.ese_earth_radius = self.ability:GetSpecialValueFor("ese_earth_radius")
	self.ese_edict_proc_chance = self.ability:GetSpecialValueFor("ese_edict_proc_chance")
	self.ese_edict_exp_count = self.ability:GetSpecialValueFor("ese_edict_exp_count")
	self.ese_storm_proc_chance = self.ability:GetSpecialValueFor("ese_storm_proc_chance")
	self.ese_storm_jumps = self.ability:GetSpecialValueFor("ese_storm_jumps")

	-- Talent: Trigger threshold re-set to reduced value
	if self.caster:HasTalent("special_bonus_unique_imba_leshrac_pulse_nova_ese_threshold") then
		self.ese_stacks_threshold = self.caster:FindTalentValue("special_bonus_unique_imba_leshrac_pulse_nova_ese_threshold")
	end

	-- Initialize last chosen effect and actual chances variables
	self.ese_earth_current_proc = self.ese_earth_proc_chance
	self.ese_edict_current_proc = self.ese_edict_proc_chance
	self.ese_storm_current_proc = self.ese_storm_proc_chance
	self.last_chosen_effect = nil
end

function modifier_imba_leshrac_pulse_nova_earth_edict_storm_debuff:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_TOOLTIP }

	return decFuncs
end

function modifier_imba_leshrac_pulse_nova_earth_edict_storm_debuff:OnTooltip()
	return self.ese_stacks_threshold
end

function modifier_imba_leshrac_pulse_nova_earth_edict_storm_debuff:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end

	-- Check if the stack count has reached the threshold. If it didn't, do nothing
	if self:GetStackCount() < self.ese_stacks_threshold then return end

	-- If we're here, it did. Reset stacks to zero
	self:SetStackCount(0)

	-- Randomize a number
	local result = RandomInt(1, 100)

	-- Choose an effect. Chosen effect's chances get halved and given to the two other
	-- Check if effect is Split Earth
	if result <= self.ese_earth_current_proc then
		self:ProcSplitEarth()
		self:CutChosenEffect("earth")
		-- Check if effect is Diabolic Edict
	elseif result <= self.ese_earth_current_proc + self.ese_edict_current_proc then
		self:ProcDiabolicEdict()
		self:CutChosenEffect("edict")
	else
		-- Otherwise, effect is Storm Lightning
		self:ProcStormLightning()
		self:CutChosenEffect("storm")
	end
end

function modifier_imba_leshrac_pulse_nova_earth_edict_storm_debuff:CutChosenEffect(chosen_effect)
	if not IsServer() then return end

	-- If last chosen effect was changed, reset all values to original values
	if not self.last_chosen_effect or chosen_effect ~= self.last_chosen_effect then
		self.ese_earth_current_proc = self.ese_earth_proc_chance
		self.ese_edict_current_proc = self.ese_edict_proc_chance
		self.ese_storm_current_proc = self.ese_storm_proc_chance
	end

	-- Set last chosen effect
	self.last_chosen_effect = chosen_effect

	-- Halve the chosen effect value and increase the other two effect chances
	local stored_value
	if chosen_effect == "earth" then
		stored_value = self.ese_earth_current_proc / 2 / 2
		self.ese_earth_current_proc = self.ese_earth_current_proc / 2
		self.ese_edict_current_proc = self.ese_edict_current_proc + stored_value
		self.ese_storm_current_proc = self.ese_storm_current_proc + stored_value
	elseif chosen_effect == "edict" then
		stored_value = self.ese_edict_current_proc / 2 / 2
		self.ese_earth_current_proc = self.ese_earth_current_proc + stored_value
		self.ese_edict_current_proc = self.ese_edict_current_proc / 2
		self.ese_storm_current_proc = self.ese_storm_current_proc + stored_value
	else
		stored_value = self.ese_storm_current_proc / 2 / 2
		self.ese_earth_current_proc = self.ese_earth_current_proc + stored_value
		self.ese_edict_current_proc = self.ese_edict_current_proc + stored_value
		self.ese_storm_current_proc = self.ese_storm_current_proc / 2
	end
end

function modifier_imba_leshrac_pulse_nova_earth_edict_storm_debuff:ProcSplitEarth()
	if not IsServer() then return end

	if self.caster:HasAbility(self.ability_earth) then
		local ability_earth_handle = self.caster:FindAbilityByName(self.ability_earth)
		if ability_earth_handle and ability_earth_handle:GetLevel() > 0 then
			ability_earth_handle:OnSpellStart(self.parent:GetAbsOrigin(), self.ese_earth_radius)
		end
	end
end

function modifier_imba_leshrac_pulse_nova_earth_edict_storm_debuff:ProcDiabolicEdict()
	if not IsServer() then return end

	if self.caster:HasAbility(self.ability_edict) then
		local ability_edict_handle = self.caster:FindAbilityByName(self.ability_edict)
		if ability_edict_handle and ability_edict_handle:GetLevel() > 0 then
			ability_edict_handle:OnSpellStart(self.parent, self.ese_edict_exp_count)
		end
	end
end

function modifier_imba_leshrac_pulse_nova_earth_edict_storm_debuff:ProcStormLightning()
	if not IsServer() then return end

	if self.caster:HasAbility(self.ability_storm) then
		local ability_storm_handle = self.caster:FindAbilityByName(self.ability_storm)
		if ability_storm_handle and ability_storm_handle:GetLevel() > 0 then
			ability_storm_handle:OnSpellStart(self.parent, self.ese_storm_jumps)
		end
	end
end

-------------------------
-- TORMENTED SOUL FORM --
-------------------------
LinkLuaModifier("modifier_imba_tormented_soul_form", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)

imba_leshrac_tormented_soul_form = imba_leshrac_tormented_soul_form or class({})

function imba_leshrac_tormented_soul_form:IsInnateAbility() return true end

function imba_leshrac_tormented_soul_form:IsNetherWardStealable() return false end

function imba_leshrac_tormented_soul_form:GetManaCost(level)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self

	-- Ability specials
	local max_hp_mp_cost_pct = ability:GetSpecialValueFor("max_hp_mp_cost_pct")

	-- Calculate mana cost
	local mana_cost = caster:GetMaxMana() * max_hp_mp_cost_pct / 100

	return mana_cost
end

function imba_leshrac_tormented_soul_form:OnSpellStart()
	if IsClient() then return end

	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_sound = "Hero_Leshrac.Split_Earth.Tormented"
	local modifier_buff = "modifier_imba_tormented_soul_form"

	-- Ability specials
	local max_hp_mp_cost_pct = ability:GetSpecialValueFor("max_hp_mp_cost_pct")
	local duration = ability:GetSpecialValueFor("duration")

	-- Talent: Tormented Soul Form buff duration increase
	if caster:HasTalent("special_bonus_unique_imba_leshrac_tormented_soul_form_duration") then
		duration = duration + caster:FindTalentValue("special_bonus_unique_imba_leshrac_tormented_soul_form_duration")
	end

	-- Play cast sound
	EmitSoundOn(cast_sound, caster)

	-- Pay with your health! (mana is calculated on the GetManaCost() function). This cannot kill you.
	local damage = caster:GetMaxHealth() * max_hp_mp_cost_pct / 100

	local damageTable = {
		victim = caster,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY,
		ability = ability
	}

	ApplyDamage(damageTable)

	-- Give yourself the buff!	
	caster:AddNewModifier(caster, ability, modifier_buff, { duration = duration })

	-- Apply on cast effects
	self:TormentedSplitEarthCast()
	self:TormentedDiabolicEdict()
	self:TormentedLightningStorm()
	self:TormentedPulseNova()
end

function imba_leshrac_tormented_soul_form:TormentedSplitEarthCast()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local ability_split = "imba_leshrac_split_earth"

	-- Find the ability	
	local ability_split_handle
	if caster:HasAbility(ability_split) then
		ability_split_handle = caster:FindAbilityByName(ability_split)
		if ability_split_handle then
			-- If the ability was found, proc the on cast effect
			-- If Split Earth's not on cooldown, cut its cooldown by half the cooldown of the ability	
			if not ability_split_handle:IsCooldownReady() then
				local total_cooldown = ability_split_handle:GetCooldown(ability_split_handle:GetLevel())
				local remaining_cooldown = ability_split_handle:GetCooldownTimeRemaining()

				if remaining_cooldown <= total_cooldown then
					ability_split_handle:EndCooldown()
				else
					ability_split_handle:EndCooldown()
					ability_split_handle:StartCooldown(remaining_cooldown - total_cooldown)
				end
			end
		end
	end
end

function imba_leshrac_tormented_soul_form:TormentedDiabolicEdict()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local ability_diabolic = "imba_leshrac_diabolic_edict"
	local modifier_diabolic = "modifier_imba_leshrac_diabolic_edict"

	-- Do nothing if the caster doesn't have Diabolic Edict active
	if not caster:HasModifier(modifier_diabolic) then
		return nil
	end

	-- Find the Diabolic Edict ability handle
	if caster:HasAbility(ability_diabolic) then
		local ability_diabolic_handle = caster:FindAbilityByName(ability_diabolic)
		local modifier_diabolic_handle = caster:FindModifierByName(modifier_diabolic)
		if ability_diabolic_handle and modifier_diabolic_handle then
			-- Ability specials
			local tormented_soul_cast_exp_count = ability_diabolic_handle:GetSpecialValueFor("tormented_soul_cast_exp_count")
			local tormented_soul_cast_exp_delay = ability_diabolic_handle:GetSpecialValueFor("tormented_soul_cast_exp_delay")
			local radius = ability_diabolic_handle:GetSpecialValueFor("radius")

			if tormented_soul_cast_exp_count and tormented_soul_cast_exp_delay then
				local fired_explosions = 0
				Timers:CreateTimer(function()
					-- If the modifier ended, do nothing else
					if not caster:HasModifier(modifier_diabolic) then
						return nil
					end

					-- Continually proc the OnIntervalThink of the modifier until all explosions are done					
					modifier_diabolic_handle:OnIntervalThink()
					fired_explosions = fired_explosions + 1

					if fired_explosions < tormented_soul_cast_exp_count then
						return tormented_soul_cast_exp_delay
					else
						return nil
					end
				end)
			end
		end
	end
end

function imba_leshrac_tormented_soul_form:TormentedLightningStorm()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local ability_lightning = "imba_leshrac_lightning_storm"
	local modifier_storm_cloud = "modifier_imba_leshrac_lightning_storm_tormented_cloud_aura"

	-- Find Lightning Storm ability handle
	if caster:HasAbility(ability_lightning) then
		local ability_lightning_handle = caster:FindAbilityByName(ability_lightning)
		if ability_lightning_handle then
			-- Ability specials
			local tormented_soul_cast_duration = ability_lightning_handle:GetSpecialValueFor("tormented_soul_cast_duration")

			if tormented_soul_cast_duration then
				-- Spawn a modifier dummy at caster's location to be used as the storm aura
				CreateModifierThinker(caster, ability_lightning_handle, modifier_storm_cloud, { duration = tormented_soul_cast_duration }, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
			end
		end
	end
end

function imba_leshrac_tormented_soul_form:TormentedPulseNova()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local ability_nova = "imba_leshrac_pulse_nova"
	local modifier_nova = "modifier_imba_leshrac_pulse_nova"

	-- Do nothing if caster doesn't have Pulse Nova active
	if not caster:HasModifier(modifier_nova) then return end

	-- Find Pulse Nova ability handle and its modifier
	if caster:HasAbility(ability_nova) then
		local ability_nova_handle = caster:FindAbilityByName(ability_nova)
		local modifier_nova_handle = caster:FindModifierByName(modifier_nova)

		if ability_nova_handle and modifier_nova_handle then
			-- Ability specials			
			local tormented_soul_cast_range_mult = ability_nova_handle:GetSpecialValueFor("tormented_soul_cast_range_mult")

			modifier_nova_handle:OnIntervalThink(tormented_soul_cast_range_mult)
		end
	end
end

----------------------------------
-- TORMENTED SOUL BUFF MODIFIER --
----------------------------------

modifier_imba_tormented_soul_form = modifier_imba_tormented_soul_form or class({})

function modifier_imba_tormented_soul_form:IsHidden() return false end

function modifier_imba_tormented_soul_form:IsPurgable() return false end

function modifier_imba_tormented_soul_form:IsDebuff() return false end

function modifier_imba_tormented_soul_form:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.particle_buff = "particles/hero/leshrac/leshrac_tormented_soulrocks.vpcf" --cp0 location, cp5 location, cp6 location, cp7 Vector(1,0,0)
	self.particle_totalsteal = "particles/hero/leshrac/totalsteal_lifesteal.vpcf"

	-- Ability specials	
	self.totalsteal_convertion_pct = self.ability:GetSpecialValueFor("totalsteal_convertion_pct")
	self.max_hp_mp_cost_pct = self.ability:GetSpecialValueFor("max_hp_mp_cost_pct")

	-- Talent: Totalsteal values increase
	if self.caster:HasTalent("special_bonus_unique_imba_leshrac_tormented_soul_form_totalsteal") then
		self.totalsteal_convertion_pct = self.totalsteal_convertion_pct + self.caster:FindTalentValue("special_bonus_unique_imba_leshrac_tormented_soul_form_totalsteal")
	end

	if IsServer() then
		-- Create particle sysetm for the buff
		self.particle_buff_fx = ParticleManager:CreateParticle(self.particle_buff, PATTACH_ABSORIGIN_FOLLOW, self.caster, self.caster)
		ParticleManager:SetParticleControl(self.particle_buff_fx, 0, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_buff_fx, 5, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_buff_fx, 6, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_buff_fx, 7, Vector(1, 0, 0))
		self:AddParticle(self.particle_buff_fx, false, false, -1, false, false)

		-- Calculate the max health and mana values to be reduced
		self.max_hp_reduction = self.caster:GetMaxHealth() * self.max_hp_mp_cost_pct / 100
		self.max_mp_reduction = self.caster:GetMaxMana() * self.max_hp_mp_cost_pct / 100
	end
end

function modifier_imba_tormented_soul_form:DeclareFunctions()
	local decFuncs = { MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_EXTRA_MANA_BONUS,
		MODIFIER_PROPERTY_TOOLTIP }

	return decFuncs
end

function modifier_imba_tormented_soul_form:OnTooltip()
	return self.totalsteal_convertion_pct
end

function modifier_imba_tormented_soul_form:GetModifierExtraHealthBonus()
	if not IsServer() then return end

	return self.max_hp_reduction * (-1)
end

function modifier_imba_tormented_soul_form:GetModifierExtraManaBonus()
	if not IsServer() then return end

	return self.max_mp_reduction * (-1)
end

function modifier_imba_tormented_soul_form:OnTakeDamage(keys)
	if not IsServer() then return end

	-- Only apply if the attacker is Leshrac and the target isn't an ally
	if keys.attacker == self.caster and keys.unit:GetTeamNumber() ~= self.caster:GetTeamNumber() then
		local damage = keys.damage

		-- Calculate heal/MP replenish
		local replenish = damage * self.totalsteal_convertion_pct / 100

		-- Apply the particle effect
		local particle_totalsteal_fx = ParticleManager:CreateParticle(self.particle_totalsteal, PATTACH_ABSORIGIN_FOLLOW, self.caster, self.caster)
		ParticleManager:SetParticleControl(particle_totalsteal_fx, 0, self.caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_totalsteal_fx)

		-- Heal the caster
		self.caster:Heal(replenish, self.caster)

		-- Give mana to the caster
		self.caster:GiveMana(replenish)
	end
end

function modifier_imba_tormented_soul_form:OnRemoved()
	if not IsServer() then return end

	-- Adjust the health and mana to the max health and mana caster will have after the buff ends so it will have the same percentage
	local current_health_pct = self.caster:GetHealthPercent()
	local current_mana_pct = self.caster:GetManaPercent()

	-- Calculate the health and mana the caster should have when this is done
	self.adjusted_health = (self.caster:GetMaxHealth() + self.max_hp_reduction) * current_health_pct / 100
	self.adjusted_mana = (self.caster:GetMaxMana() + self.max_mp_reduction) * current_mana_pct / 100
end

function modifier_imba_tormented_soul_form:OnDestroy()
	if not IsServer() then return end
	self.caster:SetHealth(self.adjusted_health)
	self.caster:SetMana(self.adjusted_mana)
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_unique_imba_leshrac_empowered_split_earth_duration", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_unique_imba_leshrac_pulse_nova_damage", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_unique_imba_leshrac_lightning_storm_duration", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_unique_imba_leshrac_tormented_soul_form_duration", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_unique_imba_leshrac_pulse_nova_radius", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_unique_imba_leshrac_diabolic_edict_explosions", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_unique_imba_leshrac_tormented_soul_form_totalsteal", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_unique_imba_leshrac_pulse_nova_ese_threshold", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_unique_imba_leshrac_empowered_split_earth_duration = modifier_special_bonus_unique_imba_leshrac_empowered_split_earth_duration or class({})
modifier_special_bonus_unique_imba_leshrac_pulse_nova_damage = modifier_special_bonus_unique_imba_leshrac_pulse_nova_damage or class({})
modifier_special_bonus_unique_imba_leshrac_lightning_storm_duration = modifier_special_bonus_unique_imba_leshrac_lightning_storm_duration or class({})
modifier_special_bonus_unique_imba_leshrac_tormented_soul_form_duration = modifier_special_bonus_unique_imba_leshrac_tormented_soul_form_duration or class({})
modifier_special_bonus_unique_imba_leshrac_pulse_nova_radius = modifier_special_bonus_unique_imba_leshrac_pulse_nova_radius or class({})
modifier_special_bonus_unique_imba_leshrac_diabolic_edict_explosions = modifier_special_bonus_unique_imba_leshrac_diabolic_edict_explosions or class({})
modifier_special_bonus_unique_imba_leshrac_tormented_soul_form_totalsteal = modifier_special_bonus_unique_imba_leshrac_tormented_soul_form_totalsteal or class({})
modifier_special_bonus_unique_imba_leshrac_pulse_nova_ese_threshold = modifier_special_bonus_unique_imba_leshrac_pulse_nova_ese_threshold or class({})


function modifier_special_bonus_unique_imba_leshrac_empowered_split_earth_duration:IsHidden() return true end

function modifier_special_bonus_unique_imba_leshrac_empowered_split_earth_duration:IsPurgable() return false end

function modifier_special_bonus_unique_imba_leshrac_empowered_split_earth_duration:RemoveOnDeath() return false end

function modifier_special_bonus_unique_imba_leshrac_pulse_nova_damage:IsHidden() return true end

function modifier_special_bonus_unique_imba_leshrac_pulse_nova_damage:IsPurgable() return false end

function modifier_special_bonus_unique_imba_leshrac_pulse_nova_damage:RemoveOnDeath() return false end

function modifier_special_bonus_unique_imba_leshrac_lightning_storm_duration:IsHidden() return true end

function modifier_special_bonus_unique_imba_leshrac_lightning_storm_duration:IsPurgable() return false end

function modifier_special_bonus_unique_imba_leshrac_lightning_storm_duration:RemoveOnDeath() return false end

function modifier_special_bonus_unique_imba_leshrac_tormented_soul_form_duration:IsHidden() return true end

function modifier_special_bonus_unique_imba_leshrac_tormented_soul_form_duration:IsPurgable() return false end

function modifier_special_bonus_unique_imba_leshrac_tormented_soul_form_duration:RemoveOnDeath() return false end

function modifier_special_bonus_unique_imba_leshrac_pulse_nova_radius:IsHidden() return true end

function modifier_special_bonus_unique_imba_leshrac_pulse_nova_radius:IsPurgable() return false end

function modifier_special_bonus_unique_imba_leshrac_pulse_nova_radius:RemoveOnDeath() return false end

function modifier_special_bonus_unique_imba_leshrac_diabolic_edict_explosions:IsHidden() return true end

function modifier_special_bonus_unique_imba_leshrac_diabolic_edict_explosions:IsPurgable() return false end

function modifier_special_bonus_unique_imba_leshrac_diabolic_edict_explosions:RemoveOnDeath() return false end

function modifier_special_bonus_unique_imba_leshrac_tormented_soul_form_totalsteal:IsHidden() return true end

function modifier_special_bonus_unique_imba_leshrac_tormented_soul_form_totalsteal:IsPurgable() return false end

function modifier_special_bonus_unique_imba_leshrac_tormented_soul_form_totalsteal:RemoveOnDeath() return false end

function modifier_special_bonus_unique_imba_leshrac_pulse_nova_ese_threshold:IsHidden() return true end

function modifier_special_bonus_unique_imba_leshrac_pulse_nova_ese_threshold:IsPurgable() return false end

function modifier_special_bonus_unique_imba_leshrac_pulse_nova_ese_threshold:RemoveOnDeath() return false end

function imba_leshrac_pulse_nova:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_unique_imba_leshrac_pulse_nova_radius") and not self:GetCaster():HasModifier("modifier_modifier_special_bonus_unique_imba_leshrac_pulse_nova_radius") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_unique_imba_leshrac_pulse_nova_radius"), "modifier_special_bonus_unique_imba_leshrac_pulse_nova_radius", {})
	end
end
