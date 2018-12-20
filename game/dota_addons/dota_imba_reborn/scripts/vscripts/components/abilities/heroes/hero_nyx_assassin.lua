-- Editors:
--     Shush, 01.04.2017

-------------------------------------------------
--                  IMPALE                     --
-------------------------------------------------

imba_nyx_assassin_impale = class({})
LinkLuaModifier("modifier_imba_impale_suffering_aura", "components/abilities/heroes/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_impale_suffering", "components/abilities/heroes/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_impale_suffering_damage_counter", "components/abilities/heroes/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_impale_stun", "components/abilities/heroes/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_impale_talent_slow", "components/abilities/heroes/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_impale_talent_thinker", "components/abilities/heroes/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_nyx_assassin_impale:GetAbilityTextureName()
	return "nyx_assassin_impale"
end

function imba_nyx_assassin_impale:IsHiddenWhenStolen()
	return false
end

function imba_nyx_assassin_impale:OnUnStolen()
	local caster = self:GetCaster()
	local modifier_aura = "modifier_imba_impale_suffering_aura"

	if caster:HasModifier(modifier_aura) then
		caster:RemoveModifierByName(modifier_aura)
	end
end

function imba_nyx_assassin_impale:GetIntrinsicModifierName()
	return "modifier_imba_impale_suffering_aura"
end

function imba_nyx_assassin_impale:GetCastRange(location, target)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_burrowed = "modifier_nyx_assassin_burrow"
	local base_cast_range = self.BaseClass.GetCastRange(self, location, target)

	-- Ability specials
	local burrow_length_increase = ability:GetSpecialValueFor("burrow_length_increase")

	if caster:HasModifier(modifier_burrowed) then
		return base_cast_range + burrow_length_increase
	end

	return base_cast_range
end

function imba_nyx_assassin_impale:GetCooldown(level)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_burrowed = "modifier_nyx_assassin_burrow"
	local base_cooldown = self.BaseClass.GetCooldown(self, level)

	-- Ability specials
	local burrow_cd_reduction = ability:GetSpecialValueFor("burrow_cd_reduction")

	if caster:HasModifier(modifier_burrowed) then
		return base_cooldown - burrow_cd_reduction
	else
		return base_cooldown
	end
end

function imba_nyx_assassin_impale:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local sound_cast = "Hero_NyxAssassin.Impale"
	local particle_projectile = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_impale.vpcf"
	local modifier_burrowed = "modifier_nyx_assassin_burrow"

	-- Ability specials
	local width = ability:GetSpecialValueFor("width")
	local duration = ability:GetSpecialValueFor("duration")
	local length = ability:GetSpecialValueFor("length") + GetCastRangeIncrease(caster)
	local speed = ability:GetSpecialValueFor("speed")
	local burrow_length_increase = ability:GetSpecialValueFor("burrow_length_increase")

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Increase travel distance if caster is burrowed
	if caster:HasModifier(modifier_burrowed) then
		length = length + burrow_length_increase
	end

	-- Adjust direction
	local direction = (target_point - caster:GetAbsOrigin()):Normalized()

	-- Projectile information
	local spikes_projectile = { Ability = ability,
		EffectName = particle_projectile,
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = length,
		fStartRadius = width,
		fEndRadius = width,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit = false,
		vVelocity = direction * speed * Vector(1, 1, 0),
		bProvidesVision = false,
		ExtraData = { main_spike = true }
	}

	-- Launch projectile
	ProjectileManager:CreateLinearProjectile(spikes_projectile)
end

function imba_nyx_assassin_impale:OnProjectileHit_ExtraData(target, location, ExtraData)
	-- If there were no targets, do nothing
	if not target then
		return nil
	end

	-- If the target is spell immune, do nothing
	if target:IsMagicImmune() then
		return nil
	end

	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_impact = "Hero_NyxAssassin.Impale.Target"
	local sound_land = "Hero_NyxAssassin.Impale.TargetLand"
	local particle_impact = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_impale_hit.vpcf"
	local modifier_stun = "modifier_imba_impale_stun"
	local modifier_suffering = "modifier_imba_impale_suffering"
	local slow_after_stun = false --talent stuff
	local main_spike = 0 -- boolean is converted to integer automatically during ExtraData receival for some reason
	local impale_repeater = false
	local repeat_duration = 0

	-- Is this main spike or talent-made spike
	if IsServer() then
		main_spike = ExtraData.main_spike
	end

	-- Talent : Enemies that were hit by Impale get their movespeed reduced by 1% for each 50 distance they travel
	if caster:HasTalent("special_bonus_imba_nyx_assassin_7") then
		slow_after_stun = true
	end

	-- Talent : Impale now bursts in random locations around targets hit. Each mini-impale deals 75 damage and stuns for 0.75 seconds. Lasts 3 seconds. Mini spikes do not apply Relive Suffering.
	if caster:HasTalent("special_bonus_imba_nyx_assassin_6") then
		impale_repeater = true
		repeat_duration = caster:FindTalentValue("special_bonus_imba_nyx_assassin_6", "repeat_duration")
	end

	-- Ability specials
	local duration = 0
	local air_time = 0
	local air_height = 0
	local damage_repeat_pct = 0
	local damage = 0

	-- Talent values or ability values, depending on if this is the main spike or not
	if main_spike == 0 then
		duration = caster:FindTalentValue("special_bonus_imba_nyx_assassin_6", "duration")
		air_time = caster:FindTalentValue("special_bonus_imba_nyx_assassin_6", "air_time")
		air_height = caster:FindTalentValue("special_bonus_imba_nyx_assassin_6", "air_height")
		damage = caster:FindTalentValue("special_bonus_imba_nyx_assassin_6", "damage")
		slow_after_stun = false --no slow for non-primary spikes
		impale_repeater = false --no recursion
	else
		duration = ability:GetSpecialValueFor("duration")
		air_time = ability:GetSpecialValueFor("air_time")
		air_height = ability:GetSpecialValueFor("air_height")
		damage_repeat_pct = ability:GetSpecialValueFor("damage_repeat_pct")
		damage = ability:GetSpecialValueFor("damage")
	end

	-- Play impact sound
	EmitSoundOn(sound_impact, target)

	-- Add particle effect
	local particle_impact_fx = ParticleManager:CreateParticle(particle_impact, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle_impact_fx, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_impact_fx)

	-- Stun target
	target:AddNewModifier(caster, ability, modifier_stun, {duration = duration, slow_after_stun = slow_after_stun})

	-- Hurl target in the air
	local knockbackProperties =
		{
			duration = air_time,
			knockback_duration = air_time,
			knockback_distance = 0,
			knockback_height = air_height
		}

	target:RemoveModifierByName("modifier_knockback")
	target:AddNewModifier(target, nil, "modifier_knockback", knockbackProperties)
	-- We need to do this because the gesture takes it's fucking time to stop
	Timers:CreateTimer(0.5, function()
		target:RemoveGesture(ACT_DOTA_FLAIL)
	end)

	if impale_repeater and IsServer() then
		CreateModifierThinker(caster, ability, "modifier_imba_impale_talent_thinker", { duration = repeat_duration }, target:GetAbsOrigin(), caster:GetTeamNumber(), false)
	end

	-- Wait for it to land
	Timers:CreateTimer(air_time, function()

			-- Play land sound
			EmitSoundOn(sound_land, target)

			-- Get the target's Suffering modifier
			local total_dmg = 0
			local modifier_suffering_handler = target:FindAllModifiersByName("modifier_imba_impale_suffering_damage_counter")
			local suffering_damage = 0

			if main_spike == 1 and modifier_suffering_handler then

				-- Calculate Suffering damage
				for _,damage in pairs(modifier_suffering_handler) do
					suffering_damage = suffering_damage + damage:GetStackCount()
				end

				suffering_damage = suffering_damage * damage_repeat_pct * 0.01

				-- Deal Suffering damage
				local damageTable = {victim = target,
					attacker = caster,
					damage = suffering_damage,
					damage_type = DAMAGE_TYPE_PURE,
					damgae_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
					ability = ability,
				}

				local dmg1 = ApplyDamage(damageTable)
				total_dmg = total_dmg + dmg1
			end

			-- Deal base damage
			damageTable = {victim = target,
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = ability
			}

			local dmg2 = ApplyDamage(damageTable)
			total_dmg = total_dmg + dmg2
			-- Create alert
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, total_dmg, nil)
	end)
end


-- Relive Suffering aura modifier
modifier_imba_impale_suffering_aura = class({})

function modifier_imba_impale_suffering_aura:GetAuraRadius()
	return 25000 --global
end

function modifier_imba_impale_suffering_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_imba_impale_suffering_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_impale_suffering_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_impale_suffering_aura:GetModifierAura()
	return "modifier_imba_impale_suffering"
end

function modifier_imba_impale_suffering_aura:IsAura()
	return true
end

function modifier_imba_impale_suffering_aura:IsAuraActiveOnDeath()
	return true
end

function modifier_imba_impale_suffering_aura:IsDebuff() return true end
function modifier_imba_impale_suffering_aura:IsHidden() return true end
function modifier_imba_impale_suffering_aura:RemoveOnDeath() return false end
function modifier_imba_impale_suffering_aura:IsPurgable() return false end


-- Relive Suffering damage counter
modifier_imba_impale_suffering = class({})

function modifier_imba_impale_suffering:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		-- Ability specials
		self.damage_duration = self.ability:GetSpecialValueFor("damage_duration")
	end
end

function modifier_imba_impale_suffering:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_TAKEDAMAGE}

	return decFuncs
end

function modifier_imba_impale_suffering:OnTakeDamage(keys)
	if IsServer() then
		local unit = keys.unit
		local damage = keys.damage

		-- Only apply if the unit taking damage is the parent of the modifier
		if self.parent == unit and self.parent:IsAlive() then
			if damage > 0 then
				local buff = self.parent:AddNewModifier(self.parent, self.ability, "modifier_imba_impale_suffering_damage_counter", {duration = self.damage_duration})
				buff:SetStackCount(math.floor(damage+0.5))
			end
		end
	end
end

function modifier_imba_impale_suffering:IsHidden() return true end
function modifier_imba_impale_suffering:IsPurgable() return false end
function modifier_imba_impale_suffering:IsDebuff() return true end
function modifier_imba_impale_suffering:RemoveOnDeath() return true end

modifier_imba_impale_suffering_damage_counter = modifier_imba_impale_suffering_damage_counter or class({})

function modifier_imba_impale_suffering_damage_counter:IsHidden() return true end
function modifier_imba_impale_suffering_damage_counter:IsPurgable() return false end
function modifier_imba_impale_suffering_damage_counter:IsDebuff() return true end
function modifier_imba_impale_suffering_damage_counter:RemoveOnDeath() return true end
function modifier_imba_impale_suffering_damage_counter:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end



-- Impale stun modifier
modifier_imba_impale_stun = class({})

function modifier_imba_impale_stun:OnCreated( kv )
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	if IsServer() then
		self.slow_after_stun = kv.slow_after_stun
		if self.slow_after_stun then
			self.slow_duration = self.caster:FindTalentValue("special_bonus_imba_nyx_assassin_7", "duration")
			self.slow_modifier = "modifier_imba_impale_talent_slow"
		end
	end
end

function modifier_imba_impale_stun:OnDestroy()
	if self.slow_after_stun and not self:GetParent():IsMagicImmune() then
		self.parent:AddNewModifier(self.caster, self.ability, self.slow_modifier, { duration = self.slow_duration })
	end
end

function modifier_imba_impale_stun:DeclareFunctions()
	local funcs =   {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
	return funcs
end

function modifier_imba_impale_stun:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_imba_impale_stun:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state
end

function modifier_imba_impale_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_impale_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_impale_stun:IsHidden() return false end
function modifier_imba_impale_stun:IsPurgeException() return true end
function modifier_imba_impale_stun:IsStunDebuff() return true end


-- Impale afterstun slow modifier (talent)
modifier_imba_impale_talent_slow = modifier_imba_impale_talent_slow or class({})

function modifier_imba_impale_talent_slow:OnCreated()

	self.max_distance = 200 -- to detect blink movement so as to not apply the slow
	self.caster = self:GetCaster()
	self.target = self:GetParent()

	self.slow_per_movedistance = self.caster:FindTalentValue("special_bonus_imba_nyx_assassin_7", "slow_per_movedistance")
	self.movedistance = self.caster:FindTalentValue("special_bonus_imba_nyx_assassin_7", "movedistance")
	self.movement_slow_pct = 0
	self.distance_moved = 0
	self.last_position = self.target:GetAbsOrigin()
end

function modifier_imba_impale_talent_slow:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_UNIT_MOVED,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_imba_impale_talent_slow:OnUnitMoved()    -- THIS IS SERVERSIDE ONLY
	self.current_position = self.target:GetAbsOrigin()
	self.distance_moved = self.distance_moved + (self.last_position - self.current_position):Length2D()
	self.last_position = self.current_position
	-- This is to prevent blinking from counting as movement
	if self.distance_moved >= self.max_distance then
		self.distance_moved = 0
	end
	if self.distance_moved >= self.movedistance then
		self.denominator = math.floor(self.distance_moved / self.movedistance)
		self.movement_slow_pct = self.movement_slow_pct + self.denominator
		self.distance_moved = self.distance_moved - self.movedistance * self.denominator

		-- Update stack count to show slow for clientside
		self:SetStackCount(self.movement_slow_pct)
	end
end

function modifier_imba_impale_talent_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetStackCount()
end

function modifier_imba_impale_talent_slow:IsHidden() return false end
function modifier_imba_impale_talent_slow:IsDebuff() return true end
function modifier_imba_impale_talent_slow:IsPurgable() return true end


-- Impale thinker modifier (talent)
modifier_imba_impale_talent_thinker = modifier_imba_impale_talent_thinker or class({})

function modifier_imba_impale_talent_thinker:OnCreated( kv )
	-- Properties
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.location = self:GetParent():GetAbsOrigin()
	self.parent = self:GetParent()
	self.sound_cast = "Hero_NyxAssassin.Impale"
	self.particle_projectile = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_impale.vpcf"
	self.speed = 2000 -- doesn't really matter, since it's a point projectile

	-- Specialvalues
	self.spike_rate = self.caster:FindTalentValue("special_bonus_imba_nyx_assassin_6", "spike_rate")
	self.spike_chance = self.caster:FindTalentValue("special_bonus_imba_nyx_assassin_6", "spike_chance")
	self.spike_spawn_min_range = self.caster:FindTalentValue("special_bonus_imba_nyx_assassin_6", "spike_spawn_min_range")
	self.spike_spawn_max_range = self.caster:FindTalentValue("special_bonus_imba_nyx_assassin_6", "spike_spawn_max_range")
	self.spike_aoe = self.caster:FindTalentValue("special_bonus_imba_nyx_assassin_6", "spike_aoe")

	if IsServer() then
		self:StartIntervalThink(self.spike_rate)
	end
end

function modifier_imba_impale_talent_thinker:OnIntervalThink()
	if RollPercentage(self.spike_chance)  then
		-- Shameless copy-paste of Freezing Field code
		local castDistance = RandomInt( self.spike_spawn_min_range, self.spike_spawn_max_range )
		local angle = RandomInt( 0, 90 )
		local dy = castDistance * math.sin( angle )
		local dx = castDistance * math.cos( angle )
		local quadrant = RandomInt( 1, 4 ) -- no guarantees on where this will hit
		local attackPoint

		if quadrant == 1 then          -- NW
			attackPoint = Vector( self.location.x - dx, self.location.y + dy, self.location.z )
		elseif quadrant == 2 then      -- NE
			attackPoint = Vector( self.location.x + dx, self.location.y + dy, self.location.z )
		elseif quadrant == 3 then      -- SE
			attackPoint = Vector( self.location.x + dx, self.location.y - dy, self.location.z )
		else                                -- SW
			attackPoint = Vector( self.location.x - dx, self.location.y - dy, self.location.z )
		end

		local direction = (attackPoint - self.location):Normalized()

		-- Play cast sound
		self.parent:EmitSoundParams(self.sound_cast,1,0.01,0)

		-- Projectile information
		local spikes_projectile = {
			Ability = self.ability,
			EffectName = self.particle_projectile,
			vSpawnOrigin = self.location,
			fDistance = castDistance,
			fStartRadius = self.spike_aoe,
			fEndRadius = self.spike_aoe,
			Source = self.caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			bDeleteOnHit = false,
			vVelocity = direction * self.speed * Vector(1, 1, 0),
			bProvidesVision = false,
			ExtraData = { main_spike = false }
		}

		-- Launch projectile
		ProjectileManager:CreateLinearProjectile(spikes_projectile)
	end
end
-------------------------------------------------
--                MANA BURN                    --
-------------------------------------------------

imba_nyx_assassin_mana_burn = class({})
LinkLuaModifier("modifier_imba_mana_burn_parasite", "components/abilities/heroes/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mana_burn_parasite_charged", "components/abilities/heroes/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mana_burn_talent_parasite", "components/abilities/heroes/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_nyx_assassin_mana_burn:GetAbilityTextureName()
	return "nyx_assassin_mana_burn"
end

function imba_nyx_assassin_mana_burn:IsHiddenWhenStolen()
	return false
end

function imba_nyx_assassin_mana_burn:GetCastRange(location, target)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_burrowed = "modifier_nyx_assassin_burrow"
	local base_cast_range = self.BaseClass.GetCastRange(self, location, target)

	-- Ability specials
	local burrowed_cast_range_increase = ability:GetSpecialValueFor("burrowed_cast_range_increase")

	if caster:HasModifier(modifier_burrowed) then
		return base_cast_range + burrowed_cast_range_increase
	else
		return base_cast_range
	end
end

function imba_nyx_assassin_mana_burn:OnSpellStart(target)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = target or self:GetCursorTarget()
	local sound_cast = "Hero_NyxAssassin.ManaBurn.Target"
	local particle_manaburn = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf"
	local modifier_parasite = "modifier_imba_mana_burn_parasite"

	-- Ability specials
	local intelligence_mult = ability:GetSpecialValueFor("intelligence_mult")
	local mana_burn_damage_pct = ability:GetSpecialValueFor("mana_burn_damage_pct")
	local parasite_duration = ability:GetSpecialValueFor("parasite_duration")

	-- Play cast sound
	EmitSoundOn(sound_cast, target)

	-- If target has Linken's Sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- Add particle effect
	local particle_manaburn_fx = ParticleManager:CreateParticle(particle_manaburn, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(particle_manaburn_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_manaburn_fx)

	-- If target doesn't have a parasite yet, plant a new one in it
	if not target:HasModifier(modifier_parasite) then
		target:AddNewModifier(caster, ability, modifier_parasite, {duration = parasite_duration})
	end

	-- Get target's intelligence
	local target_stat = 0
	if target.GetIntellect ~= nil then
		target_stat = target:GetIntellect()

		-- Talent : Use the target's main attribute to calculate mana burn's damages
		if caster:HasTalent("special_bonus_imba_nyx_assassin_3") then
			target_stat = target:GetPrimaryStatValue()
		end
	end

	-- Calculate mana burn
	local manaburn = target_stat * intelligence_mult
	local actual_mana_burned = 0

	-- Burn mana
	local target_mana = target:GetMana()

	if target_mana > manaburn then
		target:ReduceMana(manaburn)
		actual_mana_burned = manaburn
	else
		target:ReduceMana(target_mana)
		actual_mana_burned = target_mana
	end

	-- Calculate damage
	local damage = actual_mana_burned * mana_burn_damage_pct * 0.01

	-- Apply damage
	damageTable =     {victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability
	}

	ApplyDamage(damageTable)
end

-- Mind Bug parasite leech modifier
modifier_imba_mana_burn_parasite = class({})

function modifier_imba_mana_burn_parasite:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_HERO_KILLED}

	return decFuncs
end

function modifier_imba_mana_burn_parasite:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.particle_flames = "particles/hero/nyx_assassin/mana_burn_parasite_flames.vpcf"
		self.modifier_charged = "modifier_imba_mana_burn_parasite_charged"

		-- Ability specials
		self.parasite_mana_leech = self.ability:GetSpecialValueFor("parasite_mana_leech")
		self.parasite_charge_threshold_pct = self.ability:GetSpecialValueFor("parasite_charge_threshold_pct")
		self.explosion_delay = self.ability:GetSpecialValueFor("explosion_delay")
		self.leech_interval = self.ability:GetSpecialValueFor("leech_interval")

		-- Adjust leech per second
		self.parasite_mana_leech = self.parasite_mana_leech * self.leech_interval

		-- Talent : If target dies during Mana Burn, scarabs jump out of it into Nyx
		if self.caster:HasTalent("special_bonus_imba_nyx_assassin_8") then
			self.scarab_retrieve = true
			self.scarab_modifier = "modifier_imba_mana_burn_talent_parasite"
			self.scarab_duration = self.caster:FindTalentValue("special_bonus_imba_nyx_assassin_8", "duration")
		end

		-- Get target's current mana, set the threshold
		self.starting_target_mana = self.parent:GetMana()
		self.charge_threshold = self.starting_target_mana * self.parasite_charge_threshold_pct * 0.01
		self.last_known_target_mana = self.starting_target_mana

		-- Start charging/count mana
		self.parasite_charged_mana = 0

		-- Add mana disruption particle
		self.particle_flames_fx = ParticleManager:CreateParticle(self.particle_flames, PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(self.particle_flames_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		self:AddParticle(self.particle_flames_fx, false, false, -1, false, false)

		-- Start thinking
		self:StartIntervalThink(self.leech_interval)
	end
end

function modifier_imba_mana_burn_parasite:OnIntervalThink()
	if IsServer() then
		-- Leech mana per interval
		local target_current_mana = self.parent:GetMana()
		local mana_leeched = 0
		local mana_lost = 0

		-- Check if there is enough mana to leech
		if target_current_mana >= self.parasite_mana_leech then
			self.parent:ReduceMana(self.parasite_mana_leech)
			mana_leeched = self.parasite_mana_leech

		else -- Get the mana that the target has
			self.parent:ReduceMana(target_current_mana)
			mana_leeched = target_current_mana
		end

		-- Check if the target has lost mana since the last check. If he has, add it to the charge count
		if target_current_mana < self.last_known_target_mana then
			mana_lost = self.last_known_target_mana - target_current_mana - mana_leeched
		end

		-- Update the charge meter
		self.parasite_charged_mana = self.parasite_charged_mana + mana_leeched + math.max(mana_lost, 0)

		-- Update last known target mana
		self.last_known_target_mana = target_current_mana

		-- Check if the threshold has been reached
		if self.parasite_charged_mana >= self.charge_threshold then

			-- Give the target the charged parasite modifier and the appropriate variables
			local modifier_charged_handler = self.parent:AddNewModifier(self.caster, self.ability, self.modifier_charged, {duration = self.explosion_delay})
			if modifier_charged_handler then
				modifier_charged_handler.starting_target_mana = self.starting_target_mana
			end

			-- Remove self
			self:Destroy()
		end
	end
end

function modifier_imba_mana_burn_parasite:OnHeroKilled( keys )
	if not self.scarab_retrieve or not IsServer() or keys.target ~= self.parent then
		return nil
	end

	-- Don't get scarabs off of illusions
	if not self.parent:IsRealHero() then
		return nil
	end

	self.caster:AddNewModifier(self.caster, self.ability, self.scarab_modifier, { duration = self.scarab_duration })
end

function modifier_imba_mana_burn_parasite:IsHidden() return false end
function modifier_imba_mana_burn_parasite:IsPurgable() return true end
function modifier_imba_mana_burn_parasite:IsDebuff() return true end


-- Mind Bug parasite charge (active) modifier
modifier_imba_mana_burn_parasite_charged = class({})

function modifier_imba_mana_burn_parasite_charged:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_HERO_KILLED}

	return decFuncs
end

function modifier_imba_mana_burn_parasite_charged:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.sound_charge = "Imba.Nyx_ManaBurnCharge"
		self.sound_explosion = "Imba.Nyx_ManaBurnExplosion"
		self.particle_charged = "particles/hero/nyx_assassin/mana_burn_parasite_charged.vpcf"
		self.particle_explosion = "particles/hero/nyx_assassin/mana_burn_parasite_explosion.vpcf"

		-- Ability specials
		self.parasite_mana_as_damage_pct = self.ability:GetSpecialValueFor("parasite_mana_as_damage_pct")
		self.leech_interval = self.ability:GetSpecialValueFor("leech_interval")

		-- Talent : If target dies during Mana Burn, scarabs jump out of it into Nyx
		if self.caster:HasTalent("special_bonus_imba_nyx_assassin_8") then
			self.scarab_retrieve = true
			self.scarab_modifier = "modifier_imba_mana_burn_talent_parasite"
			self.scarab_duration = self.caster:FindTalentValue("special_bonus_imba_nyx_assassin_8", "duration")
			self.skip_damage = false -- set to true if our host dies, to prevent OnDestroy damage
		end

		-- Play charge sound
		EmitSoundOn(self.sound_charge, self.parent)

		-- Add charged effect
		self.particle_charged_fx = ParticleManager:CreateParticle(self.particle_charged, PATTACH_CUSTOMORIGIN, self.parent)
		ParticleManager:SetParticleControl(self.particle_charged_fx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.particle_charged_fx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle_charged_fx, 2, self.parent:GetAbsOrigin())
		self:AddParticle(self.particle_charged_fx, false, false, -1, false, false)
	end
end

function modifier_imba_mana_burn_parasite_charged:OnDestroy()
	if IsServer() then
		if self.skip_damage then
			return nil
		end

		-- Get target's current mana
		local target_current_mana = self.parent:GetMana()

		-- Play explosion sound
		EmitSoundOn(self.sound_explosion, self.parent)

		-- Add explosion effect
		self.particle_explosion_fx = ParticleManager:CreateParticle(self.particle_explosion, PATTACH_CUSTOMORIGIN, self.parent)
		ParticleManager:SetParticleControlEnt(self.particle_explosion_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle_explosion_fx, 1, Vector(1,0,0))
		ParticleManager:ReleaseParticleIndex(self.particle_explosion_fx)

		-- If the target now has more mana than what he had when parasite was planted, do nothing
		if target_current_mana >= self.starting_target_mana then
			return nil
		end

		-- Deal damage according to mana lost
		local damage = (self.starting_target_mana - target_current_mana) * self.parasite_mana_as_damage_pct * 0.01

		damageTable = {victim = self.parent,
			attacker = self.caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self.ability
		}

		ApplyDamage(damageTable)
	end
end

function modifier_imba_mana_burn_parasite_charged:OnHeroKilled( keys )
	if not self.scarab_retrieve or not IsServer() or keys.target ~= self.parent then
		return nil
	end

	-- Don't get scarabs off of illusions
	if not self.parent:IsRealHero() then
		return nil
	end

	self.skip_damage = true
	self.caster:AddNewModifier(self.caster, self.ability, self.scarab_modifier, { duration = self.scarab_duration })
end

function modifier_imba_mana_burn_parasite_charged:IsHidden() return false end
function modifier_imba_mana_burn_parasite_charged:IsPurgable() return true end
function modifier_imba_mana_burn_parasite_charged:IsDebuff() return true end


-- Talent : Scarab modifier that jumps into enemies and Mana Burns them
modifier_imba_mana_burn_talent_parasite = modifier_imba_mana_burn_talent_parasite or class({})

function modifier_imba_mana_burn_talent_parasite:OnCreated( kv )
	if not IsServer() then
		return nil
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.scarab_particle = "particles/hero/nyx_assassin/mana_burn_parasite_flames_self.vpcf"

	self.search_radius = self.caster:FindTalentValue("special_bonus_imba_nyx_assassin_8", "search_radius")
	self.search_rate = self.caster:FindTalentValue("special_bonus_imba_nyx_assassin_8", "search_rate")
	self.mana_burn_ability = self.caster:FindAbilityByName("imba_nyx_assassin_mana_burn")

	-- Add mana disruption particle
	self.particle_flames_fx = ParticleManager:CreateParticle(self.scarab_particle, PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(self.particle_flames_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	self:AddParticle(self.particle_flames_fx, false, false, -1, false, false)

	self:StartIntervalThink(self.search_rate)
end

function modifier_imba_mana_burn_talent_parasite:OnDestroy()
	if self.particle_flames_fx then
		ParticleManager:DestroyParticle(self.particle_flames_fx, false)
		ParticleManager:ReleaseParticleIndex(self.particle_flames_fx)
	end
end

function modifier_imba_mana_burn_talent_parasite:OnIntervalThink()
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
		self.caster:GetAbsOrigin(),
		nil,
		self.search_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
		FIND_ANY_ORDER,
		false)

	if #enemies > 0 and self.mana_burn_ability then
		-- I assume it's randomized so it doesn't matter if we pick the first?
		self.mana_burn_ability:OnSpellStart(enemies[1])
		self:Destroy()
	end
end

function modifier_imba_mana_burn_talent_parasite:IsHidden() return false end
function modifier_imba_mana_burn_talent_parasite:IsPurgable() return true end
function modifier_imba_mana_burn_talent_parasite:IsDebuff() return false end
-------------------------------------------------
--              SPIKED CARAPACE                --
-------------------------------------------------

imba_nyx_assassin_spiked_carapace = class({})
LinkLuaModifier("modifier_imba_spiked_carapace", "components/abilities/heroes/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spiked_carapace_stun", "components/abilities/heroes/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_nyx_assassin_spiked_carapace:GetAbilityTextureName()
	return "nyx_assassin_spiked_carapace"
end

function imba_nyx_assassin_spiked_carapace:IsHiddenWhenStolen()
	return false
end

function imba_nyx_assassin_spiked_carapace:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_response = {"nyx_assassin_nyx_spikedcarapace_03", "nyx_assassin_nyx_spikedcarapace_05"}
	local sound_cast = "Hero_NyxAssassin.SpikedCarapace"
	local modifier_spikes = "modifier_imba_spiked_carapace"

	-- Ability specials
	local reflect_duration = ability:GetSpecialValueFor("reflect_duration")
	local burrow_stun_range = ability:GetSpecialValueFor("burrow_stun_range")

	-- Roll for cast response
	if RollPercentage(25) then
		EmitSoundOn(cast_response[math.random(1,2)], caster)
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Add spikes modifier
	caster:AddNewModifier(caster, ability, modifier_spikes, {duration = reflect_duration})
end

-- Spiked carapace modifier (owner)
modifier_imba_spiked_carapace = class({})

function modifier_imba_spiked_carapace:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.vendetta_ability = self.caster:FindAbilityByName("imba_nyx_assassin_vendetta")
		self.particle_spikes = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace.vpcf"
		self.modifier_stun = "modifier_imba_spiked_carapace_stun"
		self.modifier_vendetta = "modifier_imba_vendetta_charge"
		self.modifier_burrowed = "modifier_nyx_assassin_burrow"

		-- Ability specials
		self.stun_duration = self.ability:GetSpecialValueFor("stun_duration")
		self.damage_to_vendetta_pct = self.ability:GetSpecialValueFor("damage_to_vendetta_pct")
		self.burrowed_stun_range = self.ability:GetSpecialValueFor("burrow_stun_range")
		self.burrowed_vendetta_stacks = self.ability:GetSpecialValueFor("burrowed_vendetta_stacks")
		self.damage_reflection_pct = self.ability:GetSpecialValueFor("damage_reflection_pct")

		-- Add spikes particles
		self.particle_spikes_fx = ParticleManager:CreateParticle(self.particle_spikes, PATTACH_CUSTOMORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControlEnt(self.particle_spikes_fx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
		self:AddParticle(self.particle_spikes_fx, false, false, -1, false, false)

		-- we only need the enemiesHit table if we're not reflecting all damage
		if self:GetCaster():HasTalent("special_bonus_imba_nyx_assassin_4") then
			self.reflect_all_damage = true
		else
			self.reflect_all_damage = false
			self.enemiesHit = {}
		end

		-- If caster is burrowed, stun all nearby enemies and grant stacks per enemy
		if self.caster:HasModifier(self.modifier_burrowed) then
			local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
				self.caster:GetAbsOrigin(),
				nil,
				self.burrowed_stun_range,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
				FIND_ANY_ORDER,
				false)

			for _,enemy in pairs(enemies) do
				-- Stun each enemy
				enemy:AddNewModifier(self.caster, self.ability, self.modifier_stun, {duration = self.stun_duration})

				-- Grant 30 Vendetta stacks
				if self.vendetta_ability and self.vendetta_ability:GetLevel() > 0 then
					if not self.caster:HasModifier(self.modifier_vendetta) then
						self.caster:AddNewModifier(self.caster, self.vendetta_ability, self.modifier_vendetta, {})
					end

					-- Only stores damage from heroes (including illusions)
					if enemy:IsHero() then

						-- Get modifier handler
						local modifier_vendetta_handler = self.caster:FindModifierByName(self.modifier_vendetta)
						if modifier_vendetta_handler then

							-- Set Vendetta stacks
							modifier_vendetta_handler:SetStackCount(modifier_vendetta_handler:GetStackCount() + self.burrowed_vendetta_stacks)
						end
					end
				end
			end
		end
	end
end

function modifier_imba_spiked_carapace:IsHidden() return false end
function modifier_imba_spiked_carapace:IsPurgable() return false end
function modifier_imba_spiked_carapace:IsDebuff() return false end

function modifier_imba_spiked_carapace:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE}

	return decFuncs
end

function modifier_imba_spiked_carapace:GetModifierIncomingDamage_Percentage( kv )
	return -100
end

function modifier_imba_spiked_carapace:OnTakeDamage(keys)
	if IsServer() then
		local attacker = keys.attacker
		local unit = keys.unit
		local original_damage = keys.original_damage
		local damage_flags = keys.damage_flags

		-- Only apply on attacks against the caster
		if unit == self.caster then

			-- If it was a no reflection damage, do nothing
			if bit.band(damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
				return nil
			end

			-- If this has a HP loss flag, do nothing
			if bit.band(damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
				return nil
			end

			-- If the unit is a building, do nothing
			if attacker:IsBuilding() then
				return nil
			end
	
			-- If the unit dealing damage is on the same team, do nothing (ex. Bloodseeker's Bloodrage)
			if attacker:GetTeam() == unit:GetTeam() then
				return nil
			end
			
			-- If the attacking unit has Nyx's Carapace as well, do nothing
			if attacker:HasModifier("modifier_imba_spiked_carapace") then
				return nil
			end

			-- Calculate damage to reflect
			local damage = original_damage * self.damage_reflection_pct * 0.01

			-- Only apply if the caster has Vendetta as ability
			if self.vendetta_ability and self.vendetta_ability:GetLevel() > 0 then

				-- Convert damage to vendetta charges
				if not self.caster:HasModifier(self.modifier_vendetta) then
					self.caster:AddNewModifier(self.caster, self.vendetta_ability, self.modifier_vendetta, {})
				end

				-- Only stores damage from heroes (including illusions)
				if attacker:IsHero() then
					-- Get modifier handler
					local modifier_vendetta_handler = self.caster:FindModifierByName(self.modifier_vendetta)
					if modifier_vendetta_handler then
						-- Calculate stacks
						local stacks = damage * self.damage_to_vendetta_pct * 0.01

						-- Set Vendetta stacks
						modifier_vendetta_handler:SetStackCount(modifier_vendetta_handler:GetStackCount() + stacks)
					end
				end
			end

			-- If the attacker is magic immune or invulnerable, do nothing
			if attacker:IsMagicImmune() or attacker:IsInvulnerable() then
				return nil
			end

			-- By default, if we don't have the "reflect all instances" talent, reflect only 1 instance per source
			-- still stuns the target, even if we skip dealing damage to it
			local skip_damage = false
			if not self.reflect_all_damage and self.enemiesHit[attacker:entindex()] then
				skip_damage = true
			end

			if not skip_damage then
				-- if the table is nil, we're reflecting everything and housekeeping isn't needed
				if self.enemiesHit ~= nil then
					self.enemiesHit[attacker:entindex()] = true
				end

				local damageTable = {victim = attacker,
					attacker = self.caster,
					damage = damage,
					damage_type = keys.damage_type,
					damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION,
					ability = self.ability
				}

				ApplyDamage(damageTable)
			end

			-- Stun it
			attacker:AddNewModifier(self.caster, self.ability, self.modifier_stun, {duration = self.stun_duration})
		end
	end

end

-- Spiked carapace stun modifier
modifier_imba_spiked_carapace_stun = class({})

function modifier_imba_spiked_carapace_stun:OnCreated()
	if IsServer() then
		self.parent = self:GetParent()
		self.sound_hit = "Hero_NyxAssassin.SpikedCarapace.Stun"
		self.particle_spike_hit = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace_hit.vpcf"

		-- Play hit sound
		EmitSoundOn(self.sound_hit, self.parent)

		-- Add spikes hit particle
		self.particle_spike_hit_fx = ParticleManager:CreateParticle(self.particle_spike_hit, PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.particle_spike_hit_fx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.particle_spike_hit_fx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle_spike_hit_fx, 2, Vector(1,0,0))
	end
end

function modifier_imba_spiked_carapace_stun:IsHidden() return false end
function modifier_imba_spiked_carapace_stun:IsPurgeException() return true end
function modifier_imba_spiked_carapace_stun:IsStunDebuff() return true end

function modifier_imba_spiked_carapace_stun:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state
end

function modifier_imba_spiked_carapace_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_spiked_carapace_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end




-------------------------------------------------
--                  VENDETTA                   --
-------------------------------------------------


imba_nyx_assassin_vendetta = class({})
LinkLuaModifier("modifier_imba_vendetta", "components/abilities/heroes/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_vendetta_charge", "components/abilities/heroes/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_nyx_assassin_vendetta:GetAbilityTextureName()
	return "nyx_assassin_vendetta"
end

function imba_nyx_assassin_vendetta:IsNetherWardStealable() return false end
function imba_nyx_assassin_vendetta:IsHiddenWhenStolen()
	return false
end

function imba_nyx_assassin_vendetta:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local burrow_ability = caster:FindAbilityByName("nyx_assassin_unburrow")
	local cast_response = {"nyx_assassin_nyx_vendetta_01", "nyx_assassin_nyx_vendetta_02", "nyx_assassin_nyx_vendetta_03", "nyx_assassin_nyx_vendetta_09"}
	local sound_cast = "Hero_NyxAssassin.Vendetta"
	local modifier_vendetta = "modifier_imba_vendetta"
	local modifier_burrowed = "modifier_nyx_assassin_burrow"

	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")

	-- Play cast response
	EmitSoundOn(cast_response[math.random(1,4)], caster)

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- If Nyx is burrowed, unburrow it
	if burrow_ability and caster:HasModifier(modifier_burrowed) then
		burrow_ability:CastAbility()
	end

	-- Apply Vendetta modifier
	caster:AddNewModifier(caster, ability, modifier_vendetta, {duration = duration})
end


-- Vendetta modifier
modifier_imba_vendetta = class({})

function modifier_imba_vendetta:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.sound_attack = "Hero_NyxAssassin.Vendetta.Crit"
	self.particle_vendetta_start = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_vendetta_start.vpcf"
	self.particle_vendetta_attack = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_vendetta.vpcf"
	self.carapace_ability = "imba_nyx_assassin_spiked_carapace"
	self.modifier_charge = "modifier_imba_vendetta_charge"

	-- Ability specials
	self.movement_speed_pct = self.ability:GetSpecialValueFor("movement_speed_pct")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")

	-- Talent: If Vendetta kills an enemy unit, it doesn't consume the Eye for Eye stacks
	if self.caster:HasTalent("special_bonus_imba_nyx_assassin_1") then
		self.dont_consume_stacks = true
	end
	-- Talent: When hitting out of Vendetta, Mana Burn is instantly applied on the target.
	if self.caster:HasTalent("special_bonus_imba_nyx_assassin_2") and IsServer() then
		self.apply_mana_burn = true
		self.mana_burn_ability = self.caster:FindAbilityByName("imba_nyx_assassin_mana_burn")
	end

	-- Add Vendetta particle
	self.particle_vendetta_start_fx = ParticleManager:CreateParticle(self.particle_vendetta_start, PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:SetParticleControl(self.particle_vendetta_start_fx, 0, self.caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_vendetta_start_fx, 1, self.caster:GetAbsOrigin())
	self:AddParticle(self.particle_vendetta_start_fx, false, false, -1, false, false)
end

function modifier_imba_vendetta:IsHidden() return false end
function modifier_imba_vendetta:IsPurgable() return false end
function modifier_imba_vendetta:IsDebuff() return false end

function modifier_imba_vendetta:CheckState()
	local state = {[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]= true}
	return state
end

function modifier_imba_vendetta:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL}

	return decFuncs
end

function modifier_imba_vendetta:GetModifierInvisibilityLevel()
	return 1
end

function modifier_imba_vendetta:OnAbilityExecuted(keys)
	local ability = keys.ability
	local caster = keys.unit

	-- Only apply when the one casting abilities is the caster
	if caster == self.caster then

		-- If ability was Spiked Carapace, do nothing
		if ability:GetName() == self.carapace_ability then
			return nil
		end

		-- Remove invisibility
		self:Destroy()
	end
end

function modifier_imba_vendetta:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_speed_pct
end

function modifier_imba_vendetta:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply if the attacker is the caster
		if attacker == self.caster then

			-- If the target is not a unit or a hero, just remove invisibility
			if not target:IsHero() and not target:IsCreep() then
				self:Destroy()
				return nil
			end

			-- Play attack sound
			EmitSoundOn(self.sound_attack, self.caster)

			-- Add attack particle effect
			self.particle_vendetta_attack_fx = ParticleManager:CreateParticle(self.particle_vendetta_attack, PATTACH_CUSTOMORIGIN, self.caster)
			ParticleManager:SetParticleControl(self.particle_vendetta_attack_fx, 0, self.caster:GetAbsOrigin() )
			ParticleManager:SetParticleControl(self.particle_vendetta_attack_fx, 1, target:GetAbsOrigin() )

			-- Get stacks of E for Vendetta, if present
			local stacks = 0
			local modifier_charged_handler
			if self.caster:HasModifier(self.modifier_charge) then
				modifier_charged_handler = self.caster:FindModifierByName(self.modifier_charge)
				if modifier_charged_handler then
					stacks = modifier_charged_handler:GetStackCount()
				end
			end

			-- Calculate damage
			local damage = self.bonus_damage + stacks

			-- Apply Mana Burn, if necessary
			if self.apply_mana_burn and self.mana_burn_ability then
				self.mana_burn_ability:OnSpellStart(target)
			end

			-- Deal damage
			local damageTable = {victim = target,
				attacker = self.caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self.ability
			}

			ApplyDamage(damageTable)

			-- Create alert
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, target, damage, nil)

			if modifier_charged_handler then
				if not self.dont_consume_stacks or target:IsAlive() then
					modifier_charged_handler:Destroy()
				end
			end

			-- Remove modifier
			self:Destroy()
		end
	end
end

-- Vendetta charges modifier_charge
modifier_imba_vendetta_charge = class({})

function modifier_imba_vendetta_charge:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()

		-- Ability specials
		self.maximum_vendetta_stacks = self.ability:GetSpecialValueFor("maximum_vendetta_stacks")
	end
end

function modifier_imba_vendetta_charge:GetTexture()
	return "nyx_assassin_vendetta"
end

function modifier_imba_vendetta_charge:IsHidden() return false end
function modifier_imba_vendetta_charge:IsPurgable() return false end
function modifier_imba_vendetta_charge:IsDebuff() return false end

function modifier_imba_vendetta_charge:OnStackCountChanged()
	if IsServer() then
		-- Limit stack count
		local stacks = self:GetStackCount()

		if stacks > self.maximum_vendetta_stacks then
			self:SetStackCount(self.maximum_vendetta_stacks)
		end
	end
end

-----------------------------------------------------------------
-- Custom Talent Modifier code
-----------------------------------------------------------------
-- Falling below 30% procs Spiked Carapace automatically if the skill is off cooldown. Triggers cooldown.

LinkLuaModifier("modifier_special_bonus_imba_nyx_assassin_5", "components/abilities/heroes/hero_nyx_assassin.lua", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_nyx_assassin_5 = class({})

function modifier_special_bonus_imba_nyx_assassin_5:IsHidden() return true end
function modifier_special_bonus_imba_nyx_assassin_5:IsPurgable() return false end
function modifier_special_bonus_imba_nyx_assassin_5:IsDebuff() return false end
function modifier_special_bonus_imba_nyx_assassin_5:AllowIllusionDuplicate() return false end
function modifier_special_bonus_imba_nyx_assassin_5:RemoveOnDeath() return false end

function modifier_special_bonus_imba_nyx_assassin_5:_CheckHealth(damage)
	-- Check our health after receiving the damage
	if self.target and self.ability and self.ability:IsCooldownReady() and not self.target:PassivesDisabled() and self.target:IsAlive() then
		local current_hp = self.target:GetHealth() / self.target:GetMaxHealth()
		if current_hp <= self.hp_threshold_pct then
			-- Cast spell, but only use up the cooldown, not mana
			self.ability:OnSpellStart()
			self.ability:UseResources(false, false, true)
		end
	end
end

function modifier_special_bonus_imba_nyx_assassin_5:OnCreated()
	if IsServer() then
		self.target = self:GetParent()
		if self.target:IsIllusion() then
			self:Destroy()
		else
			self.ability = self.target:FindAbilityByName("imba_nyx_assassin_spiked_carapace")
			self.hp_threshold_pct = self.target:FindTalentValue("special_bonus_imba_nyx_assassin_5")  / 100
			self:_CheckHealth()
		end
	end
end

function modifier_special_bonus_imba_nyx_assassin_5:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function modifier_special_bonus_imba_nyx_assassin_5:OnTakeDamage(kv)
	if IsServer() then
		local target = self:GetParent()
		if target == kv.unit then
			-- Auto-cast Spiked Carapace if health decreases below threshold
			self:_CheckHealth()
		end
	end
end
