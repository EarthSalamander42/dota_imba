--[[
		By: AtroCty
		Prev. Authors: Firetoad
		Date: 26.04.2015
		Updated:  23.03.2017
	]]

CreateEmptyTalents("lina")

-------------------------------------------
-- 	#8 Talent - Blazing strike
-------------------------------------------
function modifier_special_bonus_imba_lina_8:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return decFuncs
end

function modifier_special_bonus_imba_lina_8:OnAttackLanded( params )
	if IsServer() then
		local parent = self:GetParent()
		local target = params.target
		if parent == params.attacker and target:GetTeamNumber() ~= parent:GetTeamNumber() and (target.IsCreep or target.IsHero) then
			local int = parent:GetIntellect()
			local ticks = parent:FindTalentValue("special_bonus_imba_lina_8", "ticks_amount")
			local duration = parent:FindTalentValue("special_bonus_imba_lina_8", "duration")
			local dmg_int_pct = parent:FindTalentValue("special_bonus_imba_lina_8", "dmg_int_pct")
			local dmg_per_tick = ( int * dmg_int_pct / 100) / (duration / ticks)
			local tick_duration = duration / ticks
			target:AddNewModifier(parent, nil, "modifier_imba_blazing_strike", {duration = duration, dmg_per_tick = dmg_per_tick, tick_duration = tick_duration})
		end
	end
end

LinkLuaModifier("modifier_imba_blazing_strike", "hero/hero_lina", LUA_MODIFIER_MOTION_NONE)
modifier_imba_blazing_strike = class({})

function modifier_imba_blazing_strike:OnCreated( params )
	if IsServer() then
		self.dmg_per_tick = params.dmg_per_tick
		self.counter = 10
		local parent = self:GetParent()
		self:StartIntervalThink(params.tick_duration)
		self.particle_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_fiery_soul.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.particle_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle_fx, 1, Vector(1,0,0))
	end
end

function modifier_imba_blazing_strike:OnRefresh( params )
	if IsServer() then
		self.dmg_per_tick = params.dmg_per_tick
		self.counter = 10
	end
end

function modifier_imba_blazing_strike:OnIntervalThink( )	
	if IsServer() then
		ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = nil, damage = self.dmg_per_tick, damage_type = DAMAGE_TYPE_MAGICAL})
		self.counter = self.counter - 1
	end
end

function modifier_imba_blazing_strike:OnDestroy( params )
	if IsServer() then
		ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = nil, damage = (self.dmg_per_tick * self.counter), damage_type = DAMAGE_TYPE_MAGICAL})
		ParticleManager:DestroyParticle(self.particle_fx, false)
		ParticleManager:ReleaseParticleIndex(self.particle_fx)
	end
end

function modifier_imba_blazing_strike:IsDebuff()
	return true
end

function modifier_imba_blazing_strike:IsHidden()
	return false
end

function modifier_imba_blazing_strike:GetTexture()
	return "lina_fiery_soul"
end

-------------------------------------------
--			DRAGON SLAVE
-------------------------------------------

imba_lina_dragon_slave = class({})

function imba_lina_dragon_slave:GetAbilityTextureName()
   return "lina_dragon_slave"
end

function imba_lina_dragon_slave:OnUpgrade()
	self.cast_point = self.cast_point or self:GetCastPoint()
end

function imba_lina_dragon_slave:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()
		
		-- Parameters
		local primary_damage = self:GetSpecialValueFor("primary_damage")
		local secondary_damage = self:GetSpecialValueFor("secondary_damage")
		local spread_angle = self:GetSpecialValueFor("spread_angle")
		local secondary_amount = self:GetTalentSpecialValueFor("secondary_amount")
		local speed = self:GetSpecialValueFor("speed")
		local width_initial = self:GetSpecialValueFor("width_initial")
		local width_end = self:GetSpecialValueFor("width_end")
		local primary_distance = self:GetCastRange(caster_loc,caster) + GetCastRangeIncrease(caster)
		local secondary_distance = self:GetSpecialValueFor("secondary_distance")
		local split_delay = self:GetSpecialValueFor("split_delay")
		local secondary_width_initial = self:GetSpecialValueFor("secondary_width_initial")
		local secondary_width_end = self:GetSpecialValueFor("secondary_width_end")
		local cdr_hero = self:GetSpecialValueFor("cdr_hero")
		local cdr_units = self:GetSpecialValueFor("cdr_units")
		
		-- Distances
		local direction = (target_loc - caster_loc):Normalized()
		local split_timer = (CalculateDistance(caster_loc,target_loc) / speed)
		local velocity = direction * speed

		local projectile = 
		{
			Ability				= self,
			EffectName			= "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf",
			vSpawnOrigin		= caster_loc,
			fDistance			= primary_distance,
			fStartRadius		= width_initial,
			fEndRadius			= width_end,
			Source				= caster,
			bHasFrontalCone		= true,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime 		= GameRules:GetGameTime() + 10.0,
			bDeleteOnHit		= false,
			vVelocity			= Vector(velocity.x,velocity.y,0),
			bProvidesVision		= false,
			ExtraData			= {damage = primary_damage, cdr_hero = cdr_hero, cdr_units = cdr_units}
		}
		ProjectileManager:CreateLinearProjectile(projectile)

		if secondary_amount == 0 then 
			return true 
		end
		
		caster:EmitSound("Hero_Lina.DragonSlave")
		
		Timers:CreateTimer(split_timer - 0.1, function()
			local particle_fx = ParticleManager:CreateParticle("particles/hero/lina/dragon_slave_delay.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(particle_fx, 0, (target_loc + Vector(0,0,50)))
			ParticleManager:SetParticleControl(particle_fx, 1, (target_loc + Vector(0,0,50)))
			ParticleManager:SetParticleControl(particle_fx, 3, (target_loc + Vector(0,0,50)))
			Timers:CreateTimer(split_delay + 0.1, function()
				ParticleManager:DestroyParticle(particle_fx, false)
				ParticleManager:ReleaseParticleIndex(particle_fx)
				local particle_fx2 = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_loadout.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(particle_fx2, 0, target_loc)
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(particle_fx2, false)
					ParticleManager:ReleaseParticleIndex(particle_fx2)
				end)
			end)
		end)

		Timers:CreateTimer((split_timer + split_delay), function()
			EmitSoundOnLocationWithCaster( target_loc, "Hero_Lina.DragonSlave", caster )
			local start_angle
			local interval_angle = 0
			if secondary_amount == 1 then
				start_angle = 0
			else
				start_angle = spread_angle * (-1)
				interval_angle = spread_angle * 2 / (secondary_amount - 1)
			end
			for i = 1, secondary_amount, 1 do
				local angle = start_angle + (i-1) * interval_angle
				velocity = RotateVector2D(direction,angle,true) * speed
				local projectile = 
				{
					Ability				= self,
					EffectName			= "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf",
					vSpawnOrigin		= target_loc,
					fDistance			= secondary_distance,
					fStartRadius		= secondary_width_initial,
					fEndRadius			= secondary_width_end,
					Source				= caster,
					bHasFrontalCone		= true,
					bReplaceExisting	= false,
					iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					fExpireTime 		= GameRules:GetGameTime() + 10.0,
					bDeleteOnHit		= false,
					vVelocity			= Vector(velocity.x,velocity.y,0),
					bProvidesVision		= false,
					ExtraData			= {damage = secondary_damage, cdr_hero = cdr_hero, cdr_units = cdr_units}
				}
				ProjectileManager:CreateLinearProjectile(projectile)
			end
		end)
	end
end

function imba_lina_dragon_slave:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target then
		local caster = self:GetCaster()
		local ability_laguna = caster:FindAbilityByName("imba_lina_laguna_blade")
		ApplyDamage({victim = target, attacker = caster, ability = self, damage = ExtraData.damage, damage_type = self:GetAbilityDamageType()})
		target:RemoveModifierByName("modifier_imba_blazing_strike")
		if ability_laguna and not ability_laguna:IsCooldownReady() then
			local cdr
			if target:IsHero() and not target:IsIllusion() then
				cdr = ExtraData.cdr_hero
			else
				cdr = ExtraData.cdr_units
			end
			local current_cooldown = ability_laguna:GetCooldownTimeRemaining()
			ability_laguna:EndCooldown()
			ability_laguna:StartCooldown(current_cooldown - cdr)
		end
	end
	return false
end

function imba_lina_dragon_slave:IsStealable()
	return true
end

function imba_lina_dragon_slave:IsHiddenWhenStolen()
	return false
end

function imba_lina_dragon_slave:GetCooldown( nLevel )
	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
	local caster = self:GetCaster()
	if caster:HasTalent("special_bonus_imba_lina_3") then
		cooldown = cooldown - caster:FindTalentValue("special_bonus_imba_lina_3")
	end
	return cooldown
end

-------------------------------------------
--			LIGHT STRIKE ARRAY
-------------------------------------------

imba_lina_light_strike_array = class({})

function imba_lina_light_strike_array:GetAbilityTextureName()
   return "lina_light_strike_array"
end

function imba_lina_light_strike_array:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()

		-- Parameters
		local radius = self:GetSpecialValueFor("aoe_radius")
		local cast_delay = self:GetSpecialValueFor("cast_delay")
		local stun_duration = self:GetSpecialValueFor("stun_duration")
		local damage = self:GetTalentSpecialValueFor("damage")
		local secondary_delay = self:GetSpecialValueFor("secondary_delay")
		local array_count = self:GetSpecialValueFor("array_count")

		-- Distances
		local direction = (target_loc - caster_loc):Normalized()

		-- Emit cast-sound
		caster:EmitSound("Ability.PreLightStrikeArray")
		
		-- Response 20%
		if (math.random(1,5) < 2) and (caster:GetName() == "npc_dota_hero_lina") then
			caster:EmitSound("lina_lina_ability_lightstrike_0"..math.random(1,6))
		end
		
		for i=0, array_count-1, 1 do
			local distance = i
			if i == 0 then
				distance = 0
			else
				if math.mod(i,2) == 1 then
					distance = radius * (distance + 1)
				else
					distance = radius * distance * (-1)
				end
			end
			local delay = math.abs(distance / (radius * 2)) * secondary_delay
			local position = target_loc + distance * direction
			self:CreateStrike( position, delay, cast_delay, radius, damage, stun_duration )
		end
		if caster:HasTalent("special_bonus_imba_lina_4") then
			direction = RotateVector2D(direction,90,true)
			for i=1, caster:FindTalentValue("special_bonus_imba_lina_4"), 1 do
				local distance = i
				if math.mod(i,2) == 1 then
					distance = radius * (distance + 1)
				else
					distance = radius * distance * (-1)
				end
				local delay = math.abs(distance / (radius * 2)) * secondary_delay
				local position = target_loc + distance * direction
				self:CreateStrike( position, delay, cast_delay, radius, damage, stun_duration )
			end
		end
	end
end

function imba_lina_light_strike_array:CreateStrike( position, delay, cast_delay, radius, damage, stun_duration )
	local caster = self:GetCaster()
	
	Timers:CreateTimer(delay, function()
		local cast_pfx = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf", PATTACH_WORLDORIGIN, caster, caster:GetTeam())
		ParticleManager:SetParticleControl(cast_pfx, 0, position)
		ParticleManager:SetParticleControl(cast_pfx, 1, Vector(radius * 2, 0, 0))
		ParticleManager:ReleaseParticleIndex(cast_pfx)
	end)

	Timers:CreateTimer((delay+cast_delay), function()
		-- Emit particle + sound
		local blast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(blast_pfx, 0, position)
		ParticleManager:SetParticleControl(blast_pfx, 1, Vector(radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(blast_pfx)
		EmitSoundOnLocationWithCaster( position, "Ability.LightStrikeArray", caster )
		
		-- Destroys trees
		GridNav:DestroyTreesAroundPoint(position, radius, false)
		
		-- Deal damage and stun
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in ipairs(enemies) do
			self:OnHit(enemy, damage, stun_duration)
		end
	end)
end

function imba_lina_light_strike_array:OnHit( target, damage, stun_duration )
	local caster = self:GetCaster()
	ApplyDamage({attacker = caster, victim = target, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
	target:RemoveModifierByName("modifier_imba_blazing_strike")
	target:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration})
end

function imba_lina_light_strike_array:GetAOERadius()
	return self:GetSpecialValueFor("aoe_radius")
end

function imba_lina_light_strike_array:IsHiddenWhenStolen()
	return false
end

-------------------------------------------
--				FIERY SOUL
-------------------------------------------

imba_lina_fiery_soul = class({})
LinkLuaModifier("modifier_imba_fiery_soul", "hero/hero_lina", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fiery_soul_counter", "hero/hero_lina", LUA_MODIFIER_MOTION_NONE)

function imba_lina_fiery_soul:GetIntrinsicModifierName()
    return "modifier_imba_fiery_soul"
end


function imba_lina_fiery_soul:GetAbilityTextureName()
   return "lina_fiery_soul"
end

modifier_imba_fiery_soul = class({})

function modifier_imba_fiery_soul:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
	return decFuncs
end

function modifier_imba_fiery_soul:OnAbilityFullyCast( params )
	if IsServer() then
		local item = params.ability:IsItem()
		if item then
			return
		end
		local parent = self:GetParent()
		if (params.ability:GetCaster() == parent) then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_imba_fiery_soul_counter", {duration = self:GetAbility():GetSpecialValueFor("duration")})
		end
		return true
	end
end

function modifier_imba_fiery_soul:IsHidden()
	return true
end

function modifier_imba_fiery_soul:IsPurgable()
	return false
end


modifier_imba_fiery_soul_counter = class({})

function modifier_imba_fiery_soul_counter:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		self:SetStackCount(1)
		self.particle = ParticleManager:CreateParticle("particles/hero/lina/fiery_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.particle, 1, caster, PATTACH_POINT_FOLLOW, nil, caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle, 3, Vector(1,0,0))
		ParticleManager:SetParticleControl(self.particle, 4, Vector(1,0,0))
	end
end

function modifier_imba_fiery_soul_counter:OnRefresh()
	if IsServer() then
		local stacks = self:GetStackCount()
		local ability = self:GetAbility()
		local max_stacks = ability:GetTalentSpecialValueFor("max_stacks")
		if stacks < max_stacks then
			self:SetStackCount(stacks+1)
			ParticleManager:SetParticleControl(self.particle, 3, Vector(stacks,0,0))
			ParticleManager:SetParticleControl(self.particle, 4, Vector(stacks,0,3 ))
		end
	end
end

function modifier_imba_fiery_soul_counter:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

function modifier_imba_fiery_soul_counter:GetTexture()
	return "lina_fiery_soul"
end

function modifier_imba_fiery_soul_counter:DeclareFunctions()
	local decFuncs = 
	{	
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
	}
	return decFuncs	
end

function modifier_imba_fiery_soul_counter:GetModifierAttackSpeedBonus_Constant()
	local speed = self:GetAbility():GetTalentSpecialValueFor("bonus_as")
	return speed * self:GetStackCount()
end

function modifier_imba_fiery_soul_counter:GetModifierMoveSpeedBonus_Percentage()
	local speed = self:GetAbility():GetSpecialValueFor("bonus_ms_pct") + self:GetCaster():FindTalentValue("special_bonus_imba_lina_5", "value2")
	return speed * self:GetStackCount()
end

function modifier_imba_fiery_soul_counter:GetModifierPercentageCasttime()
	return self:GetAbility():GetSpecialValueFor("animation_pct") * self:GetStackCount()
end

function modifier_imba_fiery_soul_counter:GetCustomCooldownReductionStacking()
	return self:GetAbility():GetSpecialValueFor("cdr_pct") * self:GetStackCount()
end

-------------------------------------------
--			LAGUNA BLADE
-------------------------------------------

imba_lina_laguna_blade = class({})

function imba_lina_laguna_blade:GetAbilityTextureName()
   return "lina_laguna_blade"
end

function imba_lina_laguna_blade:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local target_loc = target:GetAbsOrigin()
		local caster_loc = caster:GetAbsOrigin()
		local damage_type = self:GetAbilityDamageType()

		local damage = self:GetSpecialValueFor("damage")
		local effect_delay = self:GetSpecialValueFor("effect_delay")
		local bounce_amount = self:GetSpecialValueFor("bounce_amount")
		local bounce_range = self:GetSpecialValueFor("bounce_range")

		-- Play the cast sound + fire particle
		caster:EmitSound("Ability.LagunaBlade")
		local blade_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(blade_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster_loc, true)
		ParticleManager:SetParticleControlEnt(blade_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_loc, true)
		ParticleManager:ReleaseParticleIndex(blade_pfx)
		
		-- If the target possesses a ready Spell-Counter, do nothing further
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(self) then
				return nil
			end
		end
		
		Timers:CreateTimer(effect_delay, function()
			ApplyDamage({victim = target, attacker = caster, ability = self, damage = damage, damage_type = damage_type})
			target:RemoveModifierByName("modifier_imba_blazing_strike")
			if caster:HasTalent("special_bonus_imba_lina_6") then
				target:AddNewModifier(caster, self, "modifier_stunned", { duration = caster:FindTalentValue("special_bonus_imba_lina_6") })
			end		
			-- Bouncing --
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			-- Remove main-target from list
			for i=1,#enemies,1 do
				if enemies[i] == target then
					table.remove(enemies, i)
				end
			end
			-- Bounce on remaining targets
			for i=1, math.min(#enemies,bounce_amount),1 do
				local bounce_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControlEnt(bounce_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_loc, true)
				ParticleManager:SetParticleControlEnt(bounce_pfx, 1, enemies[i], PATTACH_POINT_FOLLOW, "attach_hitloc", enemies[i]:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(bounce_pfx)
				ApplyDamage({victim = enemies[i], attacker = caster, ability = self, damage = damage, damage_type = damage_type})
		 		enemies[i]:RemoveModifierByName("modifier_imba_blazing_strike")
				if caster:HasTalent("special_bonus_imba_lina_6") then
					enemies[i]:AddNewModifier(caster, self, "modifier_stunned", { duration = caster:FindTalentValue("special_bonus_imba_lina_6") })
				end
			end
		end)
	end
end

-- Restrict Laguna Blade being casted on magic immune without scepter
function imba_lina_laguna_blade:CastFilterResultTarget( target )
	if IsServer() then

		if target ~= nil and target:IsMagicImmune() and ( not self:GetCaster():HasScepter() ) then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_lina_laguna_blade:GetAbilityDamageType()
	if self:GetCaster():HasScepter() then return DAMAGE_TYPE_PURE end
	return DAMAGE_TYPE_MAGICAL
end

function imba_lina_laguna_blade:GetAOERadius()
	return self:GetSpecialValueFor("bounce_range")
end

function imba_lina_laguna_blade:GetCooldown( nLevel )
	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
	local caster = self:GetCaster()
	if caster:HasTalent("special_bonus_imba_lina_3") then
		cooldown = cooldown - caster:FindTalentValue("special_bonus_imba_lina_3")
	end
	return cooldown
end

function imba_lina_laguna_blade:IsHiddenWhenStolen()
	return false
end