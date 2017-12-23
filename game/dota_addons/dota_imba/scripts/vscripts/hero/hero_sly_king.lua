---------------------
-- Sly King
-- Author: 
-- Contributors: Lindbrum
---------------------


---------------------------------------------------------------
----------------------- FROST GALE ----------------------------
---------------------------------------------------------------

imba_sly_king_frost_gale = imba_sly_king_frost_gale or class({})

LinkLuaModifier( "modifier_imba_frost_gale_setin", "hero/hero_sly_king.lua", LUA_MODIFIER_MOTION_NONE )		-- Set in modifier (slow)
LinkLuaModifier( "modifier_imba_frost_gale_debuff", "hero/hero_sly_king.lua", LUA_MODIFIER_MOTION_NONE )		-- Root

function imba_sly_king_frost_gale:GetAbilityTextureName()
   return "sly_king_frost_gale"
end

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
		
		local projectile_count = 1
		
		
		for i = 1, projectile_count, 1 do
			local angle = 360 - (360 / projectile_count)*i
			local velocity = RotateVector2D(direction,angle,true)
			local projectile
		
			travel_distance = self.BaseClass.GetCastRange(self,target_loc,nil) + GetCastRangeIncrease(caster)
			projectile = 
				{
					Ability				= self,
					EffectName			= "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
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
	return "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf" end
	
function modifier_imba_frost_gale_setin:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_frost_gale_setin:OnCreated()

	--Ability properties
	self.root_modifier = "modifier_imba_frost_gale_debuff"
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	--Ability specials
	self.chill_damage = self.ability:GetSpecialValueFor("chill_damage")
	self.minimum_slow = self.ability:GetSpecialValueFor("minimum_slow")
	self.maximum_slow = self.ability:GetSpecialValueFor("maximum_slow")
	self.chill_duration = self.ability:GetSpecialValueFor("chill_duration")

	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_imba_frost_gale_setin:OnDestroy()
	if IsServer() then
		--if victim isn't dead and isn't magic immune, apply the root debuff
		if self.parent:IsAlive() and not self.parent:IsMagicImmune() then
			
			local mod = self.parent:AddNewModifier(self.ability:GetCaster(), self.ability, "modifier_imba_frost_gale_debuff", {duration = self.chill_duration})
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
		local damage = ApplyDamage({victim = self.parent, attacker = self.caster, damage = self.chill_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self.parent, damage, nil)
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
	return "sly_king_frost_gale" end

function modifier_imba_frost_gale_debuff:GetEffectName()
	return "particles/hero/sly_king/sly_king_frost_gale_freeze.vpcf" end
	
function modifier_imba_frost_gale_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_frost_gale_debuff:DeclareFunctions()
	local funcs = {	MODIFIER_EVENT_ON_STATE_CHANGED	}
	return funcs
end

function modifier_imba_frost_gale_debuff:OnStateChanged()
	local state = {[MODIFIER_STATE_ROOTED] = true}

	return state
end

function modifier_imba_frost_gale_debuff:OnCreated()

	--Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	--Ability Specials
	self.chill_damage = self.ability:GetSpecialValueFor("chill_damage")
	self.tick_interval = self.ability:GetSpecialValueFor("tick_interval") --currently it's 0.5

	if IsServer() then

		self:StartIntervalThink(self.tick_interval)
	end
	
end

function modifier_imba_frost_gale_debuff:OnIntervalThink()
	if IsServer() then
		--apply damage proportional to the tick interval
		local damage_per_tick = self.chill_damage * self.tick_interval
		
		ApplyDamage({victim = self.parent, attacker = self.caster, damage = damage_per_tick, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self.parent, damage_per_tick, nil)
	end
end




---------------------------------------------------------------
----------------------- BURROW BLAST --------------------------
---------------------------------------------------------------

LinkLuaModifier( "modifier_imba_burrow_blast", "hero/hero_sly_king.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_burrow_blast_stun", "hero/hero_sly_king.lua" ,LUA_MODIFIER_MOTION_NONE )

imba_sly_king_burrow_blast = imba_sly_king_burrow_blast or class({})

function imba_sly_king_burrow_blast:GetAbilityTextureName()
   local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_burrow_blast") then return "alchemist_acid_spray" end
   	return "disruptor_thunder_strike"
end

function imba_sly_king_burrow_blast:GetCooldown(nLevel)
	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
	return cooldown
end

function imba_sly_king_burrow_blast:OnAbilityPhaseStart()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:HasModifier("modifier_imba_burrow_blast") then 
			self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_5 )
		else 
			self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_4 )
		end
		return true
	end
end

function imba_sly_king_burrow_blast:OnAbilityPhaseInterrupted()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_burrow_blast") then 
		self:GetCaster():RemoveGesture( ACT_DOTA_CAST_ABILITY_4 )
	else 
		self:GetCaster():RemoveGesture( ACT_DOTA_CAST_ABILITY_4 )
	end
	
end

function imba_sly_king_burrow_blast:GetCastPoint()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_burrow_blast") then return nil end
   	return 0.7
end

function imba_sly_king_burrow_blast:OnSpellStart()
	if IsServer() then
		--Ability properties
		local caster = self:GetCaster()
		local ability = self

		--Ability Specials
		local duration = ability:GetSpecialValueFor("duration")
		local radius = ability:GetSpecialValueFor("radius")
		local damage = ability:GetSpecialValueFor("damage")
		local stun_duration = ability:GetSpecialValueFor("stun_duration")

		if caster:HasModifier("modifier_imba_burrow_blast") then
			-- second part of the spell
			caster:RemoveModifierByName("modifier_imba_burrow_blast")
			-- self:GetCaster():RemoveGesture( ACT_DOTA_CAST_ABILITY_4 )
			Timers:CreateTimer(0.2, function()
				local particleName = "particles/heroes/hero_slyli/ice_route.vpcf"
				local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, self:GetCaster())
				ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))
				Timers:CreateTimer(0.1, function()

						if caster:IsAlive() then
							-- caster:RemoveGesture( ACT_DOTA_CAST_ABILITY_5 );
						end
						local radius_find = FindUnitsInRadius(caster:GetTeamNumber(),
	                                        caster:GetAbsOrigin(),
	                                        nil,
	                                        radius,
	                                        DOTA_UNIT_TARGET_TEAM_ENEMY,
	                                        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	                                        DOTA_UNIT_FLAG_NONE,
	                                        FIND_ANY_ORDER,
											false)
						for _,enemy in pairs(radius_find) do
							if not enemy:IsMagicImmune() then
								ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
								--enemy:AddNewModifier(caster, ability, "modifier_imba_burrow_blast_stun", { duration = stun_duration })
							end
						end
						self:GetCaster():RemoveGesture( ACT_DOTA_IDLE_RARE )
					end)
			end)
		else
			-- First part of the spell
			self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_imba_burrow_blast", {duration = duration} )
		end
	end
end

---------------------------------------------------------------
------------Burrow Blast movement modifier --------------------
---------------------------------------------------------------

modifier_imba_burrow_blast = class({})

function modifier_imba_burrow_blast:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}

	return funcs
end

function modifier_imba_burrow_blast:CheckState()	
	local state = {} 
	state = {
		-- [MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		-- [MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
	
	return state
end

function modifier_imba_burrow_blast:GetModifierMoveSpeed_Limit()
	return self.speed
end

function modifier_imba_burrow_blast:GetModifierMoveSpeed_Max()
	return self.speed
end

function modifier_imba_burrow_blast:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_imba_burrow_blast:IsHidden()
	return false
end

function modifier_imba_burrow_blast:OnCreated()
	if IsServer() then

		--Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()

		--Ability specials
		self.speed = self.ability:GetSpecialValueFor("speed")


		--create particles used for the unerground rush effect

		self.caster:AddNoDraw()

		self.particleName = "particles/heroes/hero_slyli/slyli_underground.vpcf"
		self.particle = ParticleManager:CreateParticle(self.particleName, PATTACH_WORLDORIGIN, self.caster)
		ParticleManager:SetParticleControl(self.particle, 0, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle, 1, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle, 2, self.caster:GetAbsOrigin())
		self:StartIntervalThink(0.01)
	end
end

function modifier_imba_burrow_blast:OnIntervalThink()

	--update particles position
	if IsServer() then
		ParticleManager:SetParticleControl(self.particle, 0, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle, 1, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle, 2, self.caster:GetAbsOrigin())
	end
end

function modifier_imba_burrow_blast:OnDestroy()
	if IsServer() then
		
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.caster:RemoveNoDraw()
	end
end

-----------------------------------------------------------------
----------Burrow Blast stun modifier (DISABLED AT THE MOMENT)----------------------------
-----------------------------------------------------------------

modifier_imba_burrow_blast_stun = modifier_imba_burrow_blast_stun or class({})
function modifier_imba_burrow_blast_stun:IsPurgable()		return false end
function modifier_imba_burrow_blast_stun:IsDebuff()			return true end
function modifier_imba_burrow_blast_stun:IsHidden()			return true end
function modifier_imba_burrow_blast_stun:IsStunDebuff()		return true end
function modifier_imba_burrow_blast_stun:IsPurgeException()	return true end

function modifier_imba_burrow_blast_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf" end

function modifier_imba_burrow_blast_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_burrow_blast_stun:OnCreated()
	if IsServer() then
		self:GetParent():SetRenderColor(105,105,255)

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack02.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:ReleaseParticleIndex(particle)
	end
end

function modifier_imba_burrow_blast_stun:OnDestroy()
	if IsServer() then self:GetParent():SetRenderColor(255,255,255) end end

function modifier_imba_burrow_blast_stun:CheckState()
	if IsServer() then
		local state = {	[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_FROZEN ] = true	}
		return state
	end
end



---------------------------------------------------------------------
--------------------------FROZEN SKIN--------------------------------
---------------------------------------------------------------------

imba_sly_king_frozen_skin = imba_sly_king_frozen_skin or class({})

LinkLuaModifier("modifier_imba_frozen_skin_passive", "hero/hero_sly_king", LUA_MODIFIER_MOTION_NONE) --intrinsic modifier
LinkLuaModifier("modifier_imba_frozen_skin_debuff", "hero/hero_sly_king", LUA_MODIFIER_MOTION_NONE)  --frostbite debuff

function imba_sly_king_frozen_skin:GetIntrinsicModifierName()
	return "modifier_imba_frozen_skin_passive"
end

function imba_sly_king_frozen_skin:GetAbilityTextureName()
   return "tiny_craggy_exterior"
end


--------------------------------------------------------------
----------Frozen skin intrinsic modifier ------------------
--------------------------------------------------------------

modifier_imba_frozen_skin_passive = class({})
function modifier_imba_frozen_skin_passive:OnCreated()

	--Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.frostbite_modifier = "modifier_imba_frozen_skin_debuff"


	--Ability Specials

	self.chance = self.ability:GetSpecialValueFor("chance")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.stun_duration = self.ability:GetSpecialValueFor("stun_duration")
	self.prng = -10
end

function modifier_imba_frozen_skin_passive:OnRefresh()
	self.chance = self:GetAbility():GetSpecialValueFor("stun_chance")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.reduction_duration = self:GetAbility():GetSpecialValueFor("reduction_duration")
end

function modifier_imba_frozen_skin_passive:IsHidden()
	return true
end

function modifier_imba_frozen_skin_passive:RemoveOnDeath()
	return false
end

function modifier_imba_frozen_skin_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end


function modifier_imba_frozen_skin_passive:OnAttackLanded(params)
	if IsServer() then
		if params.target == self.parent then

			if self.caster:PassivesDisabled() or                                              -- if Sly King is broken, do nothing.
			params.attacker:IsBuilding() or	params.attacker:IsMagicImmune() then         -- if the guy attacking Sly King is a tower or spell immune, do nothing.
				return nil
			end

			--roll for a pseudo random chance: each fail will slightly increase the successive roll success chance
			if RollPseudoRandom(self.chance, self) then
				params.attacker:AddNewModifier(self.parent, self.ability, "modifier_stunned", {duration = self.stun_duration}) --mini-stun
				params.attacker:AddNewModifier(self.parent, self.ability, self.frostbite_modifier, {duration = self.duration}) --frostbite
			end

		end
	end
end


------------------------------------------------------------------
---------------Frozen skin debuff modifier -----------------------
------------------------------------------------------------------

modifier_imba_frozen_skin_debuff = modifier_imba_frozen_skin_debuff or class({})

function modifier_imba_burrow_blast_stun:IsPurgable()		return false end
function modifier_imba_burrow_blast_stun:IsDebuff()			return true end
function modifier_imba_burrow_blast_stun:IsHidden()			return false end
function modifier_imba_burrow_blast_stun:IsStunDebuff()		return true end
function modifier_imba_burrow_blast_stun:IsPurgeException()	return true end

function modifier_imba_frozen_skin_debuff:CheckState() return {[MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_DISARMED] = true,} end

function modifier_imba_frozen_skin_debuff:OnCreated( kv )
	if IsServer() then 
		--Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		--Ability Specials
		self.damage_interval = self.ability:GetSpecialValueFor("damage_interval")
		self.damage_per_second = self.ability:GetSpecialValueFor("damage_per_second")

		-- Immediately proc the first damage instance
		self:OnIntervalThink()
		
		--Play sound
		self:GetParent():EmitSound("Hero_Crystal.Frostbite")
		
		-- Get thinkin
		self:StartIntervalThink(self.damage_interval)
	end
end


function modifier_imba_frozen_skin_debuff:OnIntervalThink()
	if IsServer() then
		local tick_damage = self.damage_per_second * self.damage_interval
		ApplyDamage({attacker = self.caster, victim = self.parent, ability = self.ability, damage = tick_damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end

function modifier_imba_frozen_skin_debuff:GetEffectName() return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf" end
function modifier_imba_frozen_skin_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


----------------------------------------------
------       WINTERBRINGER      --------------
----------------------------------------------

imba_sly_king_winterbringer = imba_sly_king_winterbringer or class({})
LinkLuaModifier("modifier_imba_winterbringer_pulse", "hero/hero_sand_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_winterbringer_slow", "hero/hero_sand_king.lua", LUA_MODIFIER_MOTION_NONE)

function imba_sly_king_winterbringer:GetAbilityTextureName()
    return "sandking_epicenter"
end

function imba_sly_king_winterbringer:IsHiddenWhenStolen()
    return false
end

function imba_sly_king_winterbringer:GetChannelTime()

    local ability = self

    local channel_time = ability:GetSpecialValueFor("channel_time")
    
    return channel_time
end

function imba_sly_king_winterbringer:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    --local sound_cast = "Hero_KeeperOfTheLight.Illuminate.Charge"
    local particle_sandblast = "particles/units/heroes/hero_sandking/sandking_epicenter_tell.vpcf"
    local modifier_pulse = "modifier_imba_winterbringer_pulse"

    -- Ability special
    local channel_time = ability:GetSpecialValueFor("channel_time")

    -- Play cast sound
   -- EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_cast, caster)

    --Add the pulse modifier to the caster
    caster:AddNewModifier(caster, ability, modifier_pulse, {})


    -- Make Sly King perform perform the animation over and over
    Timers:CreateTimer(1.85, function()
        if caster:IsChanneling() then
            caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
            return FrameTime()
        else
            caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)
            return nil
        end
    end)

    -- Nether Ward handling
    if string.find(caster:GetUnitName(), "npc_imba_pugna_nether_ward") then
        -- Wait two seconds, then apply it like it had succeeded
        Timers:CreateTimer(2, function()


            -- Start pulsing
            caster:AddNewModifier(caster, ability, modifier_pulse, {})
        end)
    end
end

function imba_sly_king_winterbringer:OnChannelFinish(interrupted)
 
    local caster = self:GetCaster()
    local modifier_pulse = "modifier_imba_winterbringer_pulse"
   
    --Stop pulsing
    caster:RemoveModifierByName(modifier_pulse)
end

---------------------------------------------------
------------ Vacuum pulse modifier ----------------
---------------------------------------------------

modifier_imba_winterbringer_pulse = modifier_imba_winterbringer_pulse or class({})

function modifier_imba_winterbringer_pulse:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.sound_channeling = "Hero_KeeperOfTheLight.Illuminate.Charge"
        self.sound_wave_1 = "Hero_Crystal.CrystalNova"
        self.sound_wave_2 = "Hero_Crystal.CrystalNova.Yulsaria"
        self.particle_epicenter = "particles/units/heroes/hero_sandking/sandking_epicenter.vpcf"
        self.modifier_slow = "modifier_imba_winterbringer_slow"

        -- Ability specials
        self.damage = self.ability:GetSpecialValueFor("damage")
        self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")
        self.radius = self.ability:GetSpecialValueFor("radius")
        self.pull_speed = self.ability:GetSpecialValueFor("pull_speed")
        self.pulse_interval = self.ability:GetSpecialValueFor("pulse_interval")

        self.wave_fx_played = 0 --will be used to alternate the sound effects on the waves: 0 -> sound_wave_1 will be played; 1 -> sound_wave_2 will be played

        -- Play channeling sound
        EmitSoundOn(self.sound_channeling, self.caster)

        -- Start thinking
        self:StartIntervalThink(self.pulse_interval)

        --Replay channeling sound after 5 seconds
        Timers:CreateTimer(5, function()

        	StopSoundOn(self.sound_channeling, self.caster)
        	EmitSoundOn(self.sound_channeling, self.caster)

        end)
    end
end

function modifier_imba_winterbringer_pulse:OnIntervalThink()
    if IsServer() then
        -- Assign radiuses
        self.pull_radius = self.radius


        -- Add particle
        self.particle_epicenter_fx = ParticleManager:CreateParticle(self.particle_epicenter, PATTACH_ABSORIGIN_FOLLOW, self.caster)
        ParticleManager:SetParticleControl(self.particle_epicenter_fx, 0, self.caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(self.particle_epicenter_fx, 1, Vector(self.radius, self.radius, 1))
        ParticleManager:ReleaseParticleIndex(self.particle_epicenter_fx)

        --play wave sound
        if self.wave_fx_played then --sound_wave_2 will be played
        	StopSoundOn(self.sound_wave_1, self.caster)
        	EmitSoundOn(self.sound_wave_2, self.caster)
        else --sound_wave_1 will be played
        	StopSoundOn(self.sound_wave_2, self.caster)
        	EmitSoundOn(self.sound_wave_1, self.caster)
        end

        -- Find all nearby enemies in the damage radius
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

            -- Deal damage
            local damageTable = {victim = enemy,
                attacker = self.caster,
                damage = self.damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self.ability
            }

            ApplyDamage(damageTable)

            -- Apply slow
            enemy:AddNewModifier(self.caster, self.ability, self.modifier_slow, {duration = self.slow_duration})
        end

        -- Find all nearby enemies in the pull radius
        local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
        self.caster:GetAbsOrigin(),
        nil,
        self.pull_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false)

        for _,enemy in pairs(enemies) do

            -- Pull enemy towards Sand King
            -- Calculate distance and direction between SK and the enemy
            local distance = (enemy:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D()
            local direction = (enemy:GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized()

            -- If the target is not too close, calculate the pull point
            if (distance - self.pull_speed) > 50 then
                local pull_point = self.caster:GetAbsOrigin() + direction * (distance - self.pull_speed)

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

function modifier_imba_winterbringer_pulse:OnDestroy()

	--Stop sounds immediatly
	StopSoundOn(self.sound_wave_1, self.caster)
	StopSoundOn(self.sound_wave_2, self.caster)
	StopSoundOn(self.sound_channeling, self.caster)

end


function modifier_imba_winterbringer_pulse:IsHidden() return false end
function modifier_imba_winterbringer_pulse:IsPurgable() return false end
function modifier_imba_winterbringer_pulse:IsDebuff() return false end

-----------------------------------------------
-------- Winterbringer Slow modifier ----------
-----------------------------------------------
modifier_imba_winterbringer_slow = modifier_imba_winterbringer_slow or class({})

function modifier_imba_winterbringer_slow:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    -- Ability specials
    self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")
    self.as_slow = self.ability:GetSpecialValueFor("as_slow")
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