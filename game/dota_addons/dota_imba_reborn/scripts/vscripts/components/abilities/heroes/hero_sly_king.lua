-- Editors:
--     Earth Salamander #42
--     Lindbrum

---------------------------------------------------------------
----------------------- FROST GALE ----------------------------
---------------------------------------------------------------

imba_sly_king_frost_gale = imba_sly_king_frost_gale or class({})

LinkLuaModifier( "modifier_imba_frost_gale_setin", "components/abilities/heroes/hero_sly_king.lua", LUA_MODIFIER_MOTION_NONE )		-- Set in modifier (slow)
LinkLuaModifier( "modifier_imba_frost_gale_debuff", "components/abilities/heroes/hero_sly_king.lua", LUA_MODIFIER_MOTION_NONE )		-- Root

function imba_sly_king_frost_gale:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function imba_sly_king_frost_gale:OnSpellStart()
	if IsServer() then

		--Ability Properties
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()


		-- Ability Specials
		local set_in_time = self:GetSpecialValueFor("set_in_time")
		local chill_damage = self:GetSpecialValueFor("chill_damage")
		local radius = self:GetSpecialValueFor("radius")
		local projectile_speed = self:GetSpecialValueFor("projectile_speed")
		local projectile_count = self:GetSpecialValueFor("projectile_count")

		local direction
		if target_loc == caster_loc then
			direction = caster:GetForwardVector()
		else
			direction = (target_loc - caster_loc):Normalized()
		end
		local index = DoUniqueString("index")
		self[index] = {}
		local travel_distance
		caster:EmitSound("Hero_Venomancer.VenomousGale")

		for i = 1, projectile_count, 1 do
			local angle = 360 - (360 / projectile_count)*i
			local velocity = RotateVector2D(direction,angle,true)

			travel_distance = self:GetSpecialValueFor("cast_range") + GetCastRangeIncrease(caster)
			local projectile =
				{
					Ability				= self,
					EffectName			= "particles/heroes/hero_slyli/frost_gale.vpcf",
					vSpawnOrigin		= caster:GetAbsOrigin(),
					fDistance			= travel_distance,
					fStartRadius		= radius,
					fEndRadius			= radius,
					Source				= caster,
					bHasFrontalCone		= true,
					bReplaceExisting	= false,
					iUnitTargetTeam		= self:GetAbilityTargetTeam(),
					iUnitTargetFlags	= self:GetAbilityTargetFlags(),
					iUnitTargetType		= self:GetAbilityTargetType(),
					fExpireTime 		= GameRules:GetGameTime() + 10.0,
					bDeleteOnHit		= true,
					vVelocity			= Vector(velocity.x,velocity.y,0) * projectile_speed,
					bProvidesVision		= false,
					ExtraData			= {index = index, duration = set_in_time, projectile_count = projectile_count}
				}
			ProjectileManager:CreateLinearProjectile(projectile)
		end
	end
end

function imba_sly_king_frost_gale:OnProjectileHit_ExtraData(target, location, ExtraData)
	local caster = self:GetCaster()
	if target then
		local was_hit = false
		for _, stored_target in ipairs(self[ExtraData.index]) do
			if target == stored_target then
				was_hit = true
				break
			end
		end
		if was_hit then
			return nil
		else
			table.insert(self[ExtraData.index],target)
		end
		target:AddNewModifier(caster, self, "modifier_imba_frost_gale_setin", {duration = ExtraData.duration})
		target:EmitSound("Hero_Venomancer.VenomousGaleImpact")
	else
		self[ExtraData.index]["count"] = self[ExtraData.index]["count"] or 0
		self[ExtraData.index]["count"] = self[ExtraData.index]["count"] + 1
		if self[ExtraData.index]["count"] == ExtraData.projectile_count then
			if (#self[ExtraData.index] > 0) and (caster:GetName() == "npc_dota_hero_venomancer") then
				caster:EmitSound("venomancer_venm_cast_0"..math.random(1,2))
			end
			self[ExtraData.index] = nil
		end
	end
end

-----------------------------------------------
-------	Frost Gale set in modifier	 ----------
-----------------------------------------------

modifier_imba_frost_gale_setin = modifier_imba_frost_gale_setin or class({})

function modifier_imba_frost_gale_setin:IsPurgable() return true end
function modifier_imba_frost_gale_setin:IsHidden() return false end
function modifier_imba_frost_gale_setin:IsDebuff() return true end
function modifier_imba_frost_gale_setin:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_frost_gale_setin:GetEffectName()
	return "particles/econ/courier/courier_greevil_blue/courier_greevil_blue_ambient_3.vpcf" end

function modifier_imba_frost_gale_setin:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_frost_gale_setin:OnCreated()

	--Ability properties
	self.root_modifier = "modifier_imba_frost_gale_debuff"

	--Ability specials
	self.chill_damage = self:GetAbility():GetSpecialValueFor("chill_damage")
	self.minimum_slow = self:GetAbility():GetSpecialValueFor("minimum_slow")
	self.maximum_slow = self:GetAbility():GetSpecialValueFor("maximum_slow")
	self.chill_duration = self:GetAbility():GetSpecialValueFor("chill_duration")

	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_imba_frost_gale_setin:OnDestroy()
	if IsServer() then
		--if victim isn't dead and isn't magic immune, apply the root debuff
		if self:GetParent():IsAlive() and not self:GetParent():IsMagicImmune() then

			local mod = self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_imba_frost_gale_debuff", {duration = self.chill_duration})
			mod:SetStackCount(self:GetStackCount())
		end
	end
end

function modifier_imba_frost_gale_setin:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
		}
	return funcs
end

function modifier_imba_frost_gale_setin:OnIntervalThink()
	if IsServer() then
		--play chill tick sound and apply a tick of damage
		EmitSoundOn("Hero_Ancient_Apparition.ColdFeetTick", self:GetParent())
		local damage = ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.chill_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), damage, nil)
	end
end

function modifier_imba_frost_gale_setin:GetModifierMoveSpeedBonus_Percentage()
	if IsServer() then

		--increase slow over time
		local duration = self:GetDuration()
		local elapsed = math.floor(self:GetElapsedTime())

		local totalSlow = (self.maximum_slow - self.minimum_slow) / duration * elapsed + self.minimum_slow
		return totalSlow * -1
	end
end

-----------------------------------------------
-----	Frost Gale root debuff modifier	  -----
-----------------------------------------------

modifier_imba_frost_gale_debuff = modifier_imba_frost_gale_debuff or class({})

function modifier_imba_frost_gale_debuff:IsPurgable() return true end
function modifier_imba_frost_gale_debuff:IsHidden() return false end
function modifier_imba_frost_gale_debuff:IsDebuff() return true end

function modifier_imba_frost_gale_debuff:GetTexture()
	return "sly_king_frost_gale"
end

function modifier_imba_frost_gale_debuff:GetEffectName()
	return "particles/hero/sly_king/sly_king_frost_gale_freeze.vpcf"
end

function modifier_imba_frost_gale_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_frost_gale_debuff:CheckState()
	local state = {[MODIFIER_STATE_ROOTED] = true}

	return state
end

function modifier_imba_frost_gale_debuff:OnCreated()
	--Ability Specials
	self.chill_damage = self:GetAbility():GetSpecialValueFor("chill_damage")
	self.tick_interval = self:GetAbility():GetSpecialValueFor("tick_interval") --currently it's 0.5

	if IsServer() then
		self:StartIntervalThink(self.tick_interval)
		self:GetParent():AddNewModifier(self:GetCaster(), nil, "modifier_rooted", {duration = self:GetAbility():GetSpecialValueFor("chill_duration")})
		self:GetParent():EmitSound("Hero_Crystal.Frostbite")
	end
end

function modifier_imba_frost_gale_debuff:OnIntervalThink()
	if IsServer() then
		--apply damage proportional to the tick interval
		local damage_per_tick = self.chill_damage * self.tick_interval

		ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = damage_per_tick, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), damage_per_tick, nil)
	end
end

-------------------------------
--       burrowblast        --
-------------------------------
imba_sly_king_burrow_blast = class({})
LinkLuaModifier("modifier_imba_burrowblast_burrow", "components/abilities/heroes/hero_sly_king.lua", LUA_MODIFIER_MOTION_NONE)

function imba_sly_king_burrow_blast:IsHiddenWhenStolen()
	return false
end

function imba_sly_king_burrow_blast:IsNetherWardStealable()
	return false
end
--[[
function imba_sly_king_burrow_blast:GetCastRange(location, target)
	local caster = self:GetCaster()
	local cast_range = self:GetSpecialValueFor("cast_range")

	-- #3 Talent: burrowblast cast range increase
	cast_range = cast_range + caster:FindTalentValue("special_bonus_imba_sand_king_3")
	return cast_range
end
--]]
function imba_sly_king_burrow_blast:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local sound_cast = "Hero_NyxAssassin.Impale"
	local particle_burrow = "particles/heroes/hero_slyli/sly_king_burrowblast.vpcf"
	local modifier_burrow = "modifier_imba_burrowblast_burrow"

	-- Ability specials
	local burrow_speed = ability:GetSpecialValueFor("speed")
	local burrow_radius = ability:GetSpecialValueFor("radius")
	--	local burrowblast_time = ability:GetSpecialValueFor("burrowblast_time")

	-- #1 Talent: burrowblast path radius increase
	burrow_radius = burrow_radius + caster:FindTalentValue("special_bonus_imba_sand_king_1")

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Disjoint projectiles
	ProjectileManager:ProjectileDodge(caster)

	-- Calculate distance for the projectile to move
	local distance = (caster:GetAbsOrigin() - target_point):Length2D()

	-- Adjust direction
	local direction = (target_point - caster:GetAbsOrigin()):Normalized()

	-- Add particle effect
	local particle_burrow_fx = ParticleManager:CreateParticle(particle_burrow, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle_burrow_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_burrow_fx, 1, target_point)

	-- Projectile information
	local burrow_projectile = {Ability = ability,
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = distance,
		fStartRadius = burrow_radius,
		fEndRadius = burrow_radius,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit = false,
		vVelocity = direction * burrow_speed * Vector(1, 1, 0),
		bProvidesVision = false,
	}

	-- Launch projectile
	ProjectileManager:CreateLinearProjectile(burrow_projectile)

	-- Cache target_point in the ability
	self.target_point = target_point

	-- Set the caster's location at the end
	caster:SetAbsOrigin(target_point)

	-- Wait a frame, then resolve positions
	Timers:CreateTimer(FrameTime(), function()
		ResolveNPCPositions(target_point, 128)
	end)

	-- Add burrowed status modifier
	caster:AddNewModifier(caster, ability, modifier_burrow, {duration = self:GetSpecialValueFor("delay_burrow")})
end

function imba_sly_king_burrow_blast:OnProjectileHit(target, location)
	-- If there was no target, do nothing
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
	local target_point = self.target_point
	local modifier_stun = "modifier_stunned"
	--	local modifier_poison = "modifier_imba_caustic_finale_poison"

	-- Ability specials
	local knockback_duration = ability:GetSpecialValueFor("knockback_duration")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local damage = ability:GetSpecialValueFor("damage")
	local max_push_distance = ability:GetSpecialValueFor("max_push_distance")
	local knockup_height = ability:GetSpecialValueFor("knockup_height")
	local knockup_duration = ability:GetSpecialValueFor("knockup_duration")

	-- Caustic Finale
	--	local caustic_ability_name = "imba_sly_king_caustic_finale"
	local caustic_ability
	local poison_duration
	--	if caster:HasAbility(caustic_ability_name) then
	--		caustic_ability = caster:FindAbilityByName(caustic_ability_name)
	--		poison_duration = caustic_ability:GetSpecialValueFor("poison_duration")
	--	end

	-- If an enemy target has Linken's sphere ready, do nothing
	if caster:GetTeamNumber() ~= target:GetTeamNumber() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- Calculate target's distance from target point
	local push_distance = (target:GetAbsOrigin() - target_point):Length2D()

	-- If the distance is more than the maximum possible, use the maximum instead
	if push_distance > max_push_distance then
		push_distance = max_push_distance
	end

	-- Find a spot that would bring the enemy towards the caster
	local distance = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
	local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
	local bump_point = caster:GetAbsOrigin() + direction * (distance + 150)

	-- Knockback enemies up and towards the target point
	local knockbackProperties =
		{
			center_x = bump_point.x,
			center_y = bump_point.y,
			center_z = bump_point.z,
			duration = knockup_duration,
			knockback_duration = knockup_duration,
			knockback_distance = push_distance,
			knockback_height = knockup_height
		}

	target:RemoveModifierByName("modifier_knockback")
	target:AddNewModifier(target, nil, "modifier_knockback", knockbackProperties)

	-- Stun the target
	target:AddNewModifier(caster, ability, modifier_stun, {duration = stun_duration})

	-- Apply Caustic Finale to heroes, unless they already have it
	--	if target:IsHero() and poison_duration and poison_duration > 0 and not target:HasModifier(modifier_poison) then
	--		target:AddNewModifier(caster, caustic_ability, modifier_poison, {duration = poison_duration})
	--	end

	-- Deal damage
	local damageTable = {victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability
	}

	ApplyDamage(damageTable)

	-- Wait until the target lands, then resolve positions
	Timers:CreateTimer(knockup_duration + FrameTime(), function()
		ResolveNPCPositions(target_point, 128)
	end)
end


-- burrowblast burrow modifier
modifier_imba_burrowblast_burrow = class({})

function modifier_imba_burrowblast_burrow:OnCreated()
	if IsServer() then
		-- Remove caster's model
		self:GetCaster():AddNoDraw()
	end
end

function modifier_imba_burrowblast_burrow:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true}
	return state
end

function modifier_imba_burrowblast_burrow:OnDestroy()
	if IsServer() then
		-- Redraw caster's model
		self:GetCaster():RemoveNoDraw()
	end
end

function modifier_imba_burrowblast_burrow:IsHidden() return true end
function modifier_imba_burrowblast_burrow:IsPurgable() return false end
function modifier_imba_burrowblast_burrow:IsDebuff() return false end

---------------------------------------------------------------------
--------------------------FROZEN SKIN--------------------------------
---------------------------------------------------------------------

imba_sly_king_frozen_skin = imba_sly_king_frozen_skin or class({})

LinkLuaModifier("modifier_imba_frozen_skin_passive", "components/abilities/heroes/hero_sly_king", LUA_MODIFIER_MOTION_NONE) --intrinsic modifier
LinkLuaModifier("modifier_imba_frozen_skin_debuff", "components/abilities/heroes/hero_sly_king", LUA_MODIFIER_MOTION_NONE)  --frostbite debuff

function imba_sly_king_frozen_skin:GetIntrinsicModifierName()
	return "modifier_imba_frozen_skin_passive"
end

--------------------------------------------------------------
----------Frozen skin intrinsic modifier ------------------
--------------------------------------------------------------

modifier_imba_frozen_skin_passive = class({})
function modifier_imba_frozen_skin_passive:OnCreated()

	--Ability properties
	self.frostbite_modifier = "modifier_imba_frozen_skin_debuff"

	--Ability Specials
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	self.prng = -10
end

function modifier_imba_frozen_skin_passive:OnRefresh()
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.reduction_duration = self:GetAbility():GetSpecialValueFor("reduction_duration")
end

function modifier_imba_frozen_skin_passive:IsHidden()
	return true
end

function modifier_imba_frozen_skin_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_imba_frozen_skin_passive:OnAttackLanded(params)
	if IsServer() then
		if params.target == self:GetParent() then

			if self:GetCaster():PassivesDisabled() or                                              -- if Sly King is broken, do nothing.
				params.attacker:IsBuilding() or	params.attacker:IsMagicImmune() then         -- if the guy attacking Sly King is a tower or spell immune, do nothing.
				return nil
			end

			--roll for a pseudo random chance: each fail will slightly increase the successive roll success chance
			if RollPseudoRandom(self.chance, self) then
				params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self.stun_duration}) --mini-stun
				params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), self.frostbite_modifier, {duration = self.duration}) --frostbite
			end
		end
	end
end

------------------------------------------------------------------
---------------Frozen skin debuff modifier -----------------------
------------------------------------------------------------------

modifier_imba_frozen_skin_debuff = modifier_imba_frozen_skin_debuff or class({})

function modifier_imba_frozen_skin_debuff:IsPurgable()			return false end
function modifier_imba_frozen_skin_debuff:IsDebuff()			return true end
function modifier_imba_frozen_skin_debuff:IsHidden()			return false end
function modifier_imba_frozen_skin_debuff:IsStunDebuff()		return true end
function modifier_imba_frozen_skin_debuff:IsPurgeException()	return true end
function modifier_imba_frozen_skin_debuff:CheckState()			return {[MODIFIER_STATE_ROOTED] = true} end

function modifier_imba_frozen_skin_debuff:OnCreated( kv )
	if IsServer() then
		--Ability Specials
		self.damage_interval = self:GetAbility():GetSpecialValueFor("damage_interval")
		self.damage_per_second = self:GetAbility():GetSpecialValueFor("damage_per_second")

		-- Immediately proc the first damage instance
		self:OnIntervalThink()

		--Play sound
		self:GetParent():EmitSound("Hero_Crystal.Frostbite")

		-- Get thinkin
		self:StartIntervalThink(self.damage_interval)
		self:GetParent():AddNewModifier(self:GetCaster(), nil, "modifier_rooted", {duration = self:GetAbility():GetSpecialValueFor("duration")})
	end
end

function modifier_imba_frozen_skin_debuff:OnIntervalThink()
	if IsServer() then
		local tick_damage = self.damage_per_second * self.damage_interval
		ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = tick_damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end

function modifier_imba_frozen_skin_debuff:GetEffectName() return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf" end
function modifier_imba_frozen_skin_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


----------------------------------------------
------       WINTERBRINGER      --------------
----------------------------------------------

imba_sly_king_winterbringer = imba_sly_king_winterbringer or class({})
LinkLuaModifier("modifier_imba_winterbringer_pulse", "components/abilities/heroes/hero_sly_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_winterbringer_slow", "components/abilities/heroes/hero_sly_king.lua", LUA_MODIFIER_MOTION_NONE)

function imba_sly_king_winterbringer:IsHiddenWhenStolen()
	return false
end

function imba_sly_king_winterbringer:OnSpellStart()
	-- Ability properties
	local sound_cast = "Hero_KeeperOfTheLight.Illuminate.Charge"
	local duration = self:GetSpecialValueFor("duration") - self:GetSpecialValueFor("pulse_interval") -- Remove 1 instance because the cast begins at 0:00
	local radius = self:GetSpecialValueFor("radius")

	-- Play cast sound
	EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), sound_cast, self:GetCaster())

	--Add the pulse modifier to the caster
	--self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_winterbringer_pulse", {duration = duration})
	
	-- This allows for multiple Winterbringers
	CreateModifierThinker(self:GetCaster(), self, "modifier_imba_winterbringer_pulse", {duration = duration}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	
	-- Make Sly King perform perform the animation over and over (doesn't do anything now)
	-- Timers:CreateTimer(1.85, function()
		-- if self:GetCaster():IsChanneling() then
			-- self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)
			-- return FrameTime()
		-- else
			-- self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_4)
			-- return nil
		-- end
	-- end)

	-- Nether Ward handling
	if string.find(self:GetCaster():GetUnitName(), "npc_imba_pugna_nether_ward") then
		-- Wait two seconds, then apply it like it had succeeded
		Timers:CreateTimer(2, function()
			-- Start pulsing
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_winterbringer_pulse", {})
		end)
	end
end

---------------------------------------------------
------------ Vacuum pulse modifier ----------------
---------------------------------------------------

modifier_imba_winterbringer_pulse = modifier_imba_winterbringer_pulse or class({})

function modifier_imba_winterbringer_pulse:OnCreated()
	if IsServer() then
		-- Ability properties
		self.sound_channeling = "Hero_KeeperOfTheLight.Illuminate.Charge"
		self.sound_wave_1 = "Hero_Crystal.CrystalNova"
		self.sound_wave_2 = "Hero_Crystal.CrystalNova.Yulsaria"
		self.particle_epicenter = "particles/units/heroes/hero_sly_king/sly_king_epicenter.vpcf"
		self.modifier_slow = "modifier_imba_winterbringer_slow"

		-- Ability specials
		self.damage = self:GetAbility():GetSpecialValueFor("damage")
		self.slow_duration = self:GetAbility():GetSpecialValueFor("slow_duration")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.pull_speed = self:GetAbility():GetSpecialValueFor("pull_speed")
		self.pulse_interval = self:GetAbility():GetSpecialValueFor("pulse_interval")
		self.pos = self:GetCaster():GetAbsOrigin()

		self.wave_fx_played = 0 --will be used to alternate the sound effects on the waves: 0 -> sound_wave_1 will be played; 1 -> sound_wave_2 will be played

		-- Play channeling sound
		EmitSoundOn(self.sound_channeling, self:GetCaster())

		-- Start thinking
		self:OnIntervalThink()
		self:StartIntervalThink(self.pulse_interval)

		--Replay channeling sound after 5 seconds
		Timers:CreateTimer(5, function()
			EmitSoundOn(self.sound_channeling, self:GetCaster())
		end)
	end
end

function modifier_imba_winterbringer_pulse:OnIntervalThink()
	if IsServer() then
		-- Assign radiuses
		self.pull_radius = self.radius

		-- Add particle
		
		-- This one has screenshake, but turns invisible if you lose sight of Sly King...
		--local particle = ParticleManager:CreateParticle("particles/heroes/hero_slyli/ice_route.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		
		local particle = ParticleManager:CreateParticle("particles/heroes/hero_slyli/ice_route.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(particle, 0, self.pos)
		ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, self.radius, self.radius))

		--play wave sound
		if self.wave_fx_played then --sound_wave_2 will be played
			EmitSoundOn(self.sound_wave_2, self:GetCaster())
		else --sound_wave_1 will be played
			EmitSoundOn(self.sound_wave_1, self:GetCaster())
		end

		-- Find all nearby enemies in the damage radius
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
			self.pos,
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		for _,enemy in pairs(enemies) do

			-- Deal damage
			local damageTable = {victim = enemy,
				attacker = self:GetCaster(),
				damage = self.damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}

			ApplyDamage(damageTable)

			-- Apply slow
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), self.modifier_slow, {duration = self.slow_duration})
		end

		-- Find all nearby enemies in the pull radius
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
			self.pos,
			nil,
			self.pull_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		for _,enemy in pairs(enemies) do
			-- Pull enemy towards Sand King
			-- Calculate distance and direction between SK and the enemy
			local distance = (enemy:GetAbsOrigin() - self.pos):Length2D()
			local direction = (enemy:GetAbsOrigin() - self.pos):Normalized()

			-- If the target is not too close, calculate the pull point
			if (distance - self.pull_speed) > 50 then
				local pull_point = self.pos + direction * (distance - self.pull_speed)

				-- Set the enemy at the pull point
				enemy:SetAbsOrigin(pull_point)

				-- Wait a frame, then resolve positions
				Timers:CreateTimer(FrameTime(), function()
					ResolveNPCPositions(pull_point, 64)
				end)
			end
		end
	end
end

function modifier_imba_winterbringer_pulse:IsHidden() return false end
function modifier_imba_winterbringer_pulse:IsPurgable() return false end
function modifier_imba_winterbringer_pulse:IsDebuff() return false end
function modifier_imba_winterbringer_pulse:RemoveOnDeath() return false end

-----------------------------------------------
-------- Winterbringer Slow modifier ----------
-----------------------------------------------
modifier_imba_winterbringer_slow = modifier_imba_winterbringer_slow or class({})

function modifier_imba_winterbringer_slow:OnCreated()
	-- Ability specials
	self.ms_slow_pct = self:GetAbility():GetSpecialValueFor("ms_slow_pct")
	self.as_slow = self:GetAbility():GetSpecialValueFor("as_slow")
end

function modifier_imba_winterbringer_slow:IsHidden() return false end
function modifier_imba_winterbringer_slow:IsPurgable() return true end
function modifier_imba_winterbringer_slow:IsDebuff() return true end

function modifier_imba_winterbringer_slow:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_imba_winterbringer_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end

function modifier_imba_winterbringer_slow:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow * (-1)
end
