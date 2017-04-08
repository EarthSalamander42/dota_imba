--[[
		By: AtroCty
		Prev. Authors: Firetoad
		Date: 21.11.2015
		Updated:  28.03.2017
	]]

CreateEmptyTalents("magnataur")

-------------------------------------------
--				POLARIZE
-------------------------------------------

LinkLuaModifier("modifier_imba_polarize_debuff", "hero/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
modifier_imba_polarize_debuff = class({})

function modifier_imba_polarize_debuff:IsDebuff()
	return true
end

function modifier_imba_polarize_debuff:IsHidden()
	return false
end

function modifier_imba_polarize_debuff:GetTexture()
	return "custom/magnus_polarize"
end

function modifier_imba_polarize_debuff:GetEffectName()
	return "particles/econ/items/magnataur/seismic_berserker/seismic_berserker_weapon_horn_b.vpcf"
end

function modifier_imba_polarize_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

LinkLuaModifier("modifier_imba_polarize_debuff_stack", "hero/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
modifier_imba_polarize_debuff_stack = class({})

function modifier_imba_polarize_debuff_stack:IsDebuff()
	return true
end

function modifier_imba_polarize_debuff_stack:IsHidden()
	return true
end

function modifier_imba_polarize_debuff_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_polarize_debuff_stack:OnCreated( params )
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()

		if parent:HasModifier("modifier_imba_polarize_debuff") then
			local modifier = parent:FindModifierByName("modifier_imba_polarize_debuff")
			modifier:IncrementStackCount()
			local max_duration = params.duration
			local modifier_counter = parent:FindAllModifiersByName("modifier_imba_polarize_debuff_stack")
			for _,modi in ipairs(modifier_counter) do
				local current_duration = modi:GetDuration()
				if current_duration > max_duration then
					max_duration = current_duration
				end
			end
			modifier:SetDuration(max_duration, true)
		else
			parent:AddNewModifier(caster, nil, "modifier_imba_polarize_debuff", {duration = params.duration})
			parent:FindModifierByName("modifier_imba_polarize_debuff"):SetStackCount(1)
		end
	end
end

function modifier_imba_polarize_debuff_stack:OnDestroy( )
	if IsServer() then
		local parent = self:GetParent()
		if parent:HasModifier("modifier_imba_polarize_debuff") then
			parent:FindModifierByName("modifier_imba_polarize_debuff"):DecrementStackCount()
		end
	end
end

-------------------------------------------
--				SHOCKWAVE
-------------------------------------------

imba_magnataur_shockwave = class({})

function imba_magnataur_shockwave:OnAbilityPhaseStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSound("Hero_Magnataur.ShockWave.Cast")
		self.swing_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_shockwave_cast.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
		local swing = self.swing_fx
		ParticleManager:SetParticleControlEnt(self.swing_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.swing_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		Timers:CreateTimer(self:GetBackswingTime(), function()
			ParticleManager:DestroyParticle(swing, false)
			ParticleManager:ReleaseParticleIndex(swing)
		end)
		return true
	end
end

function imba_magnataur_shockwave:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():StopSound("Hero_Magnataur.ShockWave.Cast")
		ParticleManager:DestroyParticle(self.swing_fx, false)
		return true
	end
end

function imba_magnataur_shockwave:IsStealable()
	return true
end

function imba_magnataur_shockwave:IsHiddenWhenStolen()
	return false
end

function imba_magnataur_shockwave:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()

		-- Parameters
		local damage = self:GetSpecialValueFor("damage")
		local secondary_damage = self:GetSpecialValueFor("secondary_damage")
		local spread_angle = self:GetSpecialValueFor("spread_angle")
		local secondary_amount = self:GetSpecialValueFor("secondary_amount")
		local secondary_occurance = self:GetSpecialValueFor("secondary_occurance")
		local distance = self:GetCastRange(caster_loc,caster) + GetCastRangeIncrease(caster)
		local polarize_duration = self:GetTalentSpecialValueFor("polarize_duration")
		local speed = self:GetSpecialValueFor("speed")
		local radius = self:GetSpecialValueFor("radius")
		local direction = (target_loc - caster_loc):Normalized()

		-- Creating a unique list of hit-Targets, delete it after 15 secs
		local index = "hit_targets_" .. tostring(GameRules:GetDOTATime(true,true))
		self[index] = {}
		self[index .. "_counter"] = secondary_occurance
		Timers:CreateTimer(15, function()
			self[index] = nil
			self[index .. "_counter"] = nil
		end)

		-- Play cast sound on dummy, which tracks the shockwave
		caster:EmitSound("Hero_Magnataur.ShockWave.Particle")

		if math.random(1,100) <= 75 and (caster:GetName() == "npc_dota_hero_magnataur") then
			caster:EmitSound("magnataur_magn_shockwave_0"..math.random(1,2))
		elseif (math.random(1,100) <= 50) and (caster:GetName() == "npc_dota_hero_magnataur") then
			caster:EmitSound("magnataur_magn_shockwave_0"..math.random(4,5))
		elseif (math.random(1,100) <= 15) and (caster:GetName() == "npc_dota_hero_magnataur") then
			caster:EmitSound("magnataur_magn_shockwave_03")
		end

		-- Launch projectile
		local projectile =
		{
			Ability				= self,
			EffectName			= "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
			vSpawnOrigin		= caster_loc,
			fDistance			= distance,
			fStartRadius		= radius,
			fEndRadius			= radius,
			Source				= caster,
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime 		= GameRules:GetGameTime() + 5.0,
			bDeleteOnHit		= false,
			vVelocity			= Vector(direction.x,direction.y,0) * speed,
			bProvidesVision		= false,
			ExtraData			= {index = index, damage = damage, secondary_damage = secondary_damage, spread_angle = spread_angle, secondary_amount = secondary_amount, distance = distance, polarize_duration = polarize_duration, speed = speed, direction_x = direction.x, direction_y = direction.y, radius = radius}
		}
		ProjectileManager:CreateLinearProjectile(projectile)
	end
end

function imba_magnataur_shockwave:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target then
		local caster = self:GetCaster()
		local was_hit = false
		for _,hit_target in pairs(self[ExtraData.index]) do
			if hit_target == target then
				was_hit = true
			end
		end

		if was_hit then
			-- Apply seondary damage
			ApplyDamage({victim = target, attacker = caster, ability = self, damage = ExtraData.secondary_damage, damage_type = self:GetAbilityDamageType()})
			target:AddNewModifier(caster, nil, "modifier_imba_polarize_debuff_stack", {duration = ExtraData.polarize_duration})
		else
			-- Apply full damage
			ApplyDamage({victim = target, attacker = caster, ability = self, damage = ExtraData.damage, damage_type = self:GetAbilityDamageType()})

			-- Add it into the unique hittable
			table.insert(self[ExtraData.index], target)

			-- Split the Shockwave if target has been Polarized and is a hero
			if (self[ExtraData.index .. "_counter"] > 0) and target:HasModifier("modifier_imba_polarize_debuff") and target:IsRealHero() then

				-- Reduce the amount of occurances
				self[ExtraData.index .. "_counter"] = self[ExtraData.index .. "_counter"] - 1

				local start_angle
				local interval_angle = 0
				local direction = Vector(ExtraData.direction_x,ExtraData.direction_y,0)
				if ExtraData.secondary_amount == 1 then
					start_angle = 0
				else
					start_angle = ExtraData.spread_angle * (-1)
					interval_angle = (ExtraData.spread_angle * 2 / (ExtraData.secondary_amount - 1) )
				end
				for i = 1, ExtraData.secondary_amount, 1 do
					local angle = start_angle + (i-1) * interval_angle
					local new_direction = RotateVector2D(direction,angle,true)
					local velocity = new_direction * ExtraData.speed
					-- Launch projectile
					local projectile =
					{
						Ability				= self,
						EffectName			= "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
						vSpawnOrigin		= location, -- if it is too static change this to target:GetAbsOrigin()
						fDistance			= ExtraData.distance,
						fStartRadius		= ExtraData.radius,
						fEndRadius			= ExtraData.radius,
						Source				= caster,
						bHasFrontalCone		= false,
						bReplaceExisting	= false,
						iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
						iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						fExpireTime 		= GameRules:GetGameTime() + 5.0,
						bDeleteOnHit		= false,
						vVelocity			= Vector(velocity.x,velocity.y,0),
						bProvidesVision		= false,
						ExtraData			= {index = ExtraData.index, damage = ExtraData.damage, secondary_damage = ExtraData.secondary_damage, spread_angle = ExtraData.spread_angle, secondary_amount = ExtraData.secondary_amount, distance = ExtraData.distance, polarize_duration = ExtraData.polarize_duration, speed = ExtraData.speed, direction_x = new_direction.x, direction_y = new_direction.y, radius = ExtraData.radius}
					}
					ProjectileManager:CreateLinearProjectile(projectile)
				end
			end
			-- Apply Polarize
			target:AddNewModifier(caster, nil, "modifier_imba_polarize_debuff_stack", {duration = ExtraData.polarize_duration})
		end

		-- Emit Hit-sound
		target:EmitSound("Hero_Magnataur.ShockWave.Target")
	end
end

function imba_magnataur_shockwave:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel ) - self:GetCaster():FindTalentValue("special_bonus_imba_magnataur_5")
end

-------------------------------------------
--				EMPOWER
-------------------------------------------

imba_magnataur_empower = class({})
LinkLuaModifier("modifier_imba_empower_aura", "hero/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_empower", "hero/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_empower_particle", "hero/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_supercharged", "hero/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_empower_linger", "hero/hero_magnataur", LUA_MODIFIER_MOTION_NONE)

function imba_magnataur_empower:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Magnataur.Empower.Cast")
	return true
end

function imba_magnataur_empower:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		-- Params
		local empower_duration = self:GetSpecialValueFor("empower_duration")
		local supercharge_duration = self:GetSpecialValueFor("supercharge_duration")
		if target:HasModifier("modifier_imba_empower") then
			target:AddNewModifier(caster, self, "modifier_imba_supercharged", { duration = supercharge_duration})
		end
		target:AddNewModifier(caster, self, "modifier_imba_empower", { duration = empower_duration})

		if (math.random(1,100) <= 25) and (caster:GetName() == "npc_dota_hero_magnataur") then
			local randomsound = math.random(1,4)
			if randomsound >= 2 then randomsound = randomsound + 1 end
			caster:EmitSound("magnataur_magn_empower_0"..randomsound)
		elseif (math.random(1,100) <= 15) and (caster == target) and (caster:GetName() == "npc_dota_hero_magnataur") then
			caster:EmitSound("magnataur_magn_empower_02")
		end
	end
end

function imba_magnataur_empower:GetIntrinsicModifierName()
    return "modifier_imba_empower_aura"
end

function imba_magnataur_empower:IsHiddenWhenStolen()
	return false
end

function imba_magnataur_empower:IsStealable()
	return true
end

-- Scepter Aura & self-sustain
modifier_imba_empower_aura = class({})

function modifier_imba_empower_aura:GetAuraEntityReject(target)
    if IsServer() then
		local parent = self:GetParent()
		
		-- Illusion handling
		if (parent:GetUnitName() == target:GetUnitName()) and target ~= parent then
			return true
		end

    	-- Active only on Scepter
        if parent:HasScepter() then
			if not self.particle then
				self.particle = ParticleManager:CreateParticle("particles/auras/aura_empower.vpcf", PATTACH_POINT_FOLLOW, parent)
				self:AddParticle(self.particle,false,false,-1,false,false)
			end
			if target:IsRealHero() then
                return false
            end
		else
			if self.particle then
				ParticleManager:DestroyParticle(self.particle, false)
				ParticleManager:ReleaseParticleIndex(self.particle)
				self.particle = nil
			end
        end

		-- Always on caster
    	if target == parent then
    		return false
    	end

        return true
    end
end

function modifier_imba_empower_aura:GetAuraRadius()
	if self:GetCaster():IsRealHero() then
		return self:GetAbility():GetSpecialValueFor("radius_scepter")
	end
	return 0
end

function modifier_imba_empower_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_imba_empower_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_empower_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_empower_aura:GetModifierAura()
	return "modifier_imba_empower"
end

function modifier_imba_empower_aura:IsAura()
	return true
end

function modifier_imba_empower_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_empower_aura:IsHidden()
	return true
end

modifier_imba_empower = class({})

function modifier_imba_empower:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
	return decFuncs
end

function modifier_imba_empower:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetCaster():IsRealHero() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage_pct") + self:GetCaster():FindSpecificTalentValue("special_bonus_imba_magnataur_3", "bonus_damage_pct")
	end
	return 0
end

function modifier_imba_empower:OnAttackLanded( params )
	local ability = self:GetAbility()
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		if params.attacker == parent and ( not parent:IsIllusion() ) then
			local cleave_particle = "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf"
			local splash_particle = "particles/hero/magnataur/magnataur_empower_splash.vpcf"
			if parent:HasModifier("modifier_imba_supercharged") then
				cleave_particle = "particles/hero/magnataur/magnataur_empower_cleave_red_effect.vpcf"
				splash_particle = "particles/hero/magnataur/magnataur_empower_red_splash.vpcf"
			end
			if params.attacker:IsRangedAttacker() then
				-- Ranged-Attacker
				local cleave_damage_ranged = (ability:GetSpecialValueFor("cleave_damage_ranged") + caster:FindSpecificTalentValue("special_bonus_imba_magnataur_3", "cleave_damage_ranged")) / 100
				local splash_radius = ability:GetSpecialValueFor("splash_radius")

				-- Find enemies to damage
				local enemies = FindUnitsInRadius(params.attacker:GetTeamNumber(), params.target:GetAbsOrigin(), nil, splash_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

				-- Deal damage
				for _,enemy in pairs(enemies) do
					if enemy ~= params.target and not enemy:IsAttackImmune() then
						ApplyDamage({attacker = params.attacker, victim = enemy, ability = ability, damage = (params.damage * cleave_damage_ranged), damage_type = DAMAGE_TYPE_PURE})
					end
				end

				local cleave_pfx = ParticleManager:CreateParticle(splash_particle, PATTACH_ABSORIGIN, params.target)
				ParticleManager:SetParticleControl(cleave_pfx, 0, params.target:GetAbsOrigin())
				ParticleManager:SetParticleControl(cleave_pfx, 1, Vector(splash_radius, 0, 0))
				ParticleManager:ReleaseParticleIndex(cleave_pfx)
			else
				-- Melee-Attacker
				local cleave_damage_pct = (ability:GetSpecialValueFor("cleave_damage_pct") + caster:FindSpecificTalentValue("special_bonus_imba_magnataur_3", "cleave_damage_pct")) / 100
				local cleave_radius_start = ability:GetSpecialValueFor("cleave_radius_start")
				local cleave_radius_end = ability:GetSpecialValueFor("cleave_radius_end")
				local cleave_distance = ability:GetSpecialValueFor("cleave_distance")
				DoCleaveAttack( params.attacker, params.target, ability, (params.damage * cleave_damage_pct), cleave_radius_start, cleave_radius_end, cleave_distance, cleave_particle )
			end
			local empower_duration = ability:GetSpecialValueFor("empower_duration")
		end
	end
end

function modifier_imba_empower:IsDebuff()
	return false
end

function modifier_imba_empower:IsHidden()
	return false
end

function modifier_imba_empower:OnCreated( params )
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		parent:AddNewModifier(caster, self:GetAbility(), "modifier_imba_empower_particle", {})
		if caster ~= parent then
			self.interval = 0.1
			if params.isProvidedByAura then
				self.remaining_duration = 0
			else
				self.remaining_duration = params.duration
			end
			self:StartIntervalThink(self.interval)
		end
		if not params.was_refreshed then
			parent:EmitSound("Hero_Magnataur.Empower.Target")
		end
	end
end

function modifier_imba_empower:OnRefresh( params )
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		parent:AddNewModifier(caster, self:GetAbility(), "modifier_imba_empower_particle", {})
		if caster ~= parent then
			self.remaining_duration = params.duration
			parent:RemoveModifierByName("modifier_imba_empower_linger")
		end
		parent:EmitSound("Hero_Magnataur.Empower.Target")
	end
end

function modifier_imba_empower:OnDestroy( )
	if IsServer() then
		if self:GetCaster() ~= self:GetParent() then
			if self:GetDuration() == 0.5 then
				local parent = self:GetParent()
				local ability = self:GetAbility()
				local linger_duration = ability:GetSpecialValueFor("linger_duration")
				if parent:HasModifier("modifier_imba_empower_linger") then
					local linger_remaining = parent:FindModifierByName("modifier_imba_empower_linger"):GetRemainingTime()
					if linger_duration < linger_remaining then
						linger_duration = linger_remaining
					end
					parent:RemoveModifierByName("modifier_imba_empower_linger")
				end
				self.was_refreshed = true
				parent:AddNewModifier(self:GetCaster(), ability, "modifier_imba_empower", { duration = linger_duration, was_refreshed = true})
			end
		end
	end
end

function modifier_imba_empower:OnIntervalThink( )
	if IsServer() then
		-- Check if target now receives this buff via aura. Aura = 0.5 sec duration
		-- Reminder: GetDuration = maximum duration, not remaining time
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		if self:GetDuration() == 0.5 then
			if not parent:HasModifier("modifier_imba_empower_linger") then
				parent:AddNewModifier(caster, ability, "modifier_imba_empower_linger", { duration = self.remaining_duration})
			end
		else
			self.remaining_duration = self.remaining_duration - self.interval
		end
		if not (parent:HasModifier("modifier_imba_empower_particle") or parent:HasModifier("modifier_imba_supercharged")) then
			parent:AddNewModifier(caster, ability, "modifier_imba_empower_particle", {})
		end
	end
end

modifier_imba_empower_particle = class({})

function modifier_imba_empower_particle:IsHidden()
	return true
end

function modifier_imba_empower_particle:OnCreated( )
	local parent = self:GetParent()
	if parent:HasModifier("modifier_imba_supercharged") or not parent:HasModifier("modifier_imba_empower") then
		self:Destroy()
		return
	end
	if not self.particle then
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_empower.vpcf", PATTACH_POINT_FOLLOW, parent)
		self:AddParticle(self.particle,false,false,-1,false,false)
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_empower_particle:OnIntervalThink( )
	self:OnCreated()
end

function modifier_imba_empower_particle:OnRefresh()
	self:OnCreated()
end

function modifier_imba_empower_particle:IsPurgable()
	return true
end

modifier_imba_empower_linger = class({})

function modifier_imba_empower_linger:IsDebuff()
	return false
end

function modifier_imba_empower_linger:IsHidden()
	return true
end

function modifier_imba_empower_linger:IsPurgable()
	return true
end

modifier_imba_supercharged = class({})

function modifier_imba_supercharged:OnCreated( params )
	if IsServer() then
		local particle = ParticleManager:CreateParticle("particles/hero/magnataur/magnataur_empower_red.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		self:AddParticle(particle,false,false,-1,false,false)
	end
end

function modifier_imba_supercharged:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if parent:HasModifier("modifier_imba_empower") then
			parent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_empower_particle", {})
		end
	end
end

function modifier_imba_supercharged:IsDebuff()
	return false
end

function modifier_imba_supercharged:IsHidden()
	return false
end

function modifier_imba_supercharged:GetEffectName()
	return "particles/hero/magnataur/magnataur_supercharge.vpcf"
end

function modifier_imba_supercharged:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_imba_supercharged:GetTexture()
	return "custom/magnus_supercharge"
end

function modifier_imba_supercharged:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return decFuncs
end

function modifier_imba_supercharged:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("supercharge_as") + self:GetCaster():FindSpecificTalentValue("special_bonus_imba_magnataur_6", "bonus_as")
end

function modifier_imba_supercharged:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("supercharge_ms") + self:GetCaster():FindSpecificTalentValue("special_bonus_imba_magnataur_6", "bonus_ms")
end

-------------------------------------------
--				SKEWER
-------------------------------------------

imba_magnataur_skewer = class({})
LinkLuaModifier("modifier_imba_skewer_motion_controller", "hero/hero_magnataur", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_skewer_motion_controller_linger", "hero/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_skewer_motion_controller_target", "hero/hero_magnataur", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_skewer_slow", "hero/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_skewer_entangle", "hero/hero_magnataur", LUA_MODIFIER_MOTION_NONE)

function imba_magnataur_skewer:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_skewer_motion_controller_linger") then return false end
	return true
end

function imba_magnataur_skewer:GetBehavior()
	if self:GetCaster():HasModifier("modifier_imba_skewer_motion_controller") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	else
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
end


function imba_magnataur_skewer:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()

		-- Parameters
		local range = self:GetSpecialValueFor("range") + GetCastRangeIncrease(caster)
		local distance = (target_loc - caster_loc):Length2D()
		local direction = (target_loc - caster_loc):Normalized()
		local current_cooldown = self:GetCooldownTimeRemaining()
		self:EndCooldown()

		if distance > range then
			distance = range
		end

		-- Play the cast sound
		caster:EmitSound("Hero_Magnataur.Skewer.Cast")

		local cast_sound = false
		if (math.random(1,100) <= 25) and (caster:GetName() == "npc_dota_hero_magnataur") then
			local randomsound = math.random(1,9)
			if randomsound >= 4 then randomsound = randomsound + 3 end
			if randomsound >= 10 then randomsound = randomsound + 2 end
			if randomsound <= 9 then
				randomsound = "0"..randomsound
			end
			caster:EmitSound("magnataur_magn_skewer_"..randomsound)
			cast_sound = true
		elseif (math.random(1,100) <= 20) and (caster:GetName() == "npc_dota_hero_magnataur") then
			caster:EmitSound("magnataur_magn_lasthit_09")
			cast_sound = true
		end

		-- Add Motion-Controller-Modifier
		caster:AddNewModifier(caster, self, "modifier_imba_skewer_motion_controller", {distance = distance, direction_x = direction.x, direction_y = direction.y, direction_z = direction.z, cooldown = current_cooldown, cast_sound = cast_sound})
	end
end

function imba_magnataur_skewer:GetCastAnimation()
    return ACT_DOTA_MAGNUS_SKEWER_START
end

function imba_magnataur_skewer:IsHiddenWhenStolen()
    return false
end

function imba_magnataur_skewer:IsStealable()
	return true
end

function imba_magnataur_skewer:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_skewer_motion_controller") then
		return "custom/magnataur_beg_my_pardon"
	else
		return "magnataur_skewer"
	end
end

function imba_magnataur_skewer:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel ) - self:GetCaster():FindTalentValue("special_bonus_imba_magnataur_4")
end

modifier_imba_skewer_motion_controller = class({})

function modifier_imba_skewer_motion_controller:OnCreated( params )
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local caster_loc = caster:GetAbsOrigin()

		caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)

		-- Parameters
		self.speed = ability:GetSpecialValueFor("speed") * FrameTime()
		self.skewer_radius = ability:GetSpecialValueFor("skewer_radius")
		self.tree_radius = ability:GetSpecialValueFor("tree_radius")
		self.slow_duration = ability:GetSpecialValueFor("slow_duration")
		self.horned_distance = ability:GetSpecialValueFor("horned_distance")
		self.pardon_min_range = ability:GetSpecialValueFor("pardon_min_range")
		self.damage = ability:GetSpecialValueFor("damage")
		self.pardon_extra_dmg = ability:GetSpecialValueFor("pardon_extra_dmg")
		self.entangle_dur = ability:GetSpecialValueFor("entangle_dur")
		self.distance = params.distance
		self.cast_sound = params.cast_sound
		self.direction = Vector(params.direction_x, params.direction_y, params.direction_z)
		self.traveled = 0
		self.final = false
		self.begged_for_pardon = false
		self.cooldown = params.cooldown

		self.skewer_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_skewer.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControlEnt(self.skewer_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.skewer_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_horn", caster:GetAbsOrigin(), true)

		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function modifier_imba_skewer_motion_controller:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_imba_skewer_motion_controller_linger", {duration = 0.1})
		self:GetAbility():StartCooldown(self.cooldown)
	end
end

function modifier_imba_skewer_motion_controller:IsHidden()
	return true
end

function modifier_imba_skewer_motion_controller:RemoveOnDeath()
	return false
end

function modifier_imba_skewer_motion_controller:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true
	}
	return state
end

function modifier_imba_skewer_motion_controller:UpdateHorizontalMotion( unit, time )
	if IsServer() then
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local ability = self:GetAbility()

		GridNav:DestroyTreesAroundPoint(caster_loc, self.tree_radius, false)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, self.skewer_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
		for _,enemy in ipairs(enemies) do
			if not enemy:HasModifier("modifier_imba_skewer_motion_controller_target") then
				enemy:SetAbsOrigin( caster:GetAbsOrigin() + self.direction * self.horned_distance )
				enemy:AddNewModifier(caster, ability, "modifier_imba_skewer_motion_controller_target", {direction_x = self.direction.x, direction_y = self.direction.y, direction_z = self.direction.z, speed = self.speed})
			end
		end

		-- Move the caster while the distance traveled is less than the original distance upon cast
		if (self.traveled < self.distance) and caster:IsAlive() and not self.begged_for_pardon then
			caster:SetAbsOrigin(caster:GetAbsOrigin() + self.direction * self.speed)
			-- Calculate the new travel distance
			self.traveled = self.traveled + self.speed

			-- if the next 3 frames are the end, start final animation
			if ((self.traveled + (3 * self.speed)) > self.distance) and not self.final then
				caster:FadeGesture( ACT_DOTA_CAST_ABILITY_3 )
				caster:StartGesture(ACT_DOTA_MAGNUS_SKEWER_END)
				self.final = true
			end
		else
			local piked_enemies = {}
			piked_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, self.skewer_radius * 2, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
			local polarize_counter = 0

			-- Check if polarized targets shall be entangled
			for _,enemy in ipairs(piked_enemies) do
				if enemy:HasModifier("modifier_imba_polarize_debuff") then
					polarize_counter = polarize_counter + 1
					if polarize_counter == 2 then
						break
					end
				end
			end

			-- Remove the motion controller once the distance has been traveled
			if not self.final then
				caster:FadeGesture( ACT_DOTA_CAST_ABILITY_3 )
				caster:StartGesture( ACT_DOTA_MAGNUS_SKEWER_END )
			end

			if (math.random(1,100) <= 15) and (caster == target) and not self.cast_sound and (caster:GetName() == "npc_dota_hero_magnataur") then
				local randomsound = math.random(4,8)
				if randomsound >= 7 then randomsound = randomsound + 3 end
				caster:EmitSound("magnataur_magn_skewer_0"..randomsound)
			end

			caster:InterruptMotionControllers(true)

			for _,enemy in ipairs(piked_enemies) do
				local damage = self.damage
				if self.begged_for_pardon then
					damage = damage + self.pardon_extra_dmg
				end
				local modifier = enemy:FindModifierByNameAndCaster("modifier_imba_skewer_motion_controller_target",caster)
				if modifier then
					if self.begged_for_pardon and not enemy:HasModifier("modifier_imba_polarize_debuff") then
						local knockup_duration = 0.5 + (math.random() * 0.3)
						local angle = (math.random() - 0.5) * 100
						local knockback =
						{
							should_stun = 1,
							knockback_duration = knockup_duration,
							duration = knockup_duration,
							knockback_distance = self.pardon_min_range + knockup_duration * 100,
							knockback_height = 125 + (knockup_duration * 50),
							center_x = (caster_loc - (RotateVector2D(self.direction,angle, true))*1000).x ,
							center_y = (caster_loc - (RotateVector2D(self.direction,angle, true))*1000).y,
							center_z = caster_loc.z
						}
						enemy:AddNewModifier(caster, self:GetAbility(), "modifier_knockback", knockback)
						Timers:CreateTimer(knockup_duration, function()
							ApplyDamage({victim = enemy, attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
						end)
					else
						local knockup_duration = 0.5
						local knockback =
						{
							should_stun = 1,
							knockback_duration = knockup_duration,
							duration = knockup_duration,
							knockback_distance = self.pardon_min_range + knockup_duration * 100,
							knockback_height = 125 + (knockup_duration * 50),
							center_x = caster_loc.x,
							center_y = caster_loc.y,
							center_z = caster_loc.z
						}
						enemy:AddNewModifier(caster, self:GetAbility(), "modifier_knockback", knockback)
						Timers:CreateTimer(knockup_duration, function()
							ApplyDamage({victim = enemy, attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
							if enemy:HasModifier("modifier_imba_polarize_debuff") and (polarize_counter == 2) then
								enemy:AddNewModifier(caster, ability, "modifier_imba_skewer_entangle", {duration = self.entangle_dur})
							end
						end)
					end
					enemy:AddNewModifier(caster, ability, "modifier_imba_skewer_slow", {duration = self.slow_duration, pardoned = self.begged_for_pardon})
				end
			end
		end
	end
end

function modifier_imba_skewer_motion_controller:OnHorizontalMotionInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle(self.skewer_fx, false)
		ParticleManager:ReleaseParticleIndex(self.skewer_fx)
		GridNav:DestroyTreesAroundPoint(self:GetCaster():GetAbsOrigin(), (self.tree_radius + 100), false)
		self:Destroy()
	end
end

modifier_imba_skewer_motion_controller_linger = class({})

function modifier_imba_skewer_motion_controller_linger:IsHidden()
	return true
end

function modifier_imba_skewer_motion_controller_linger:IsPurgable()
	return false
end

modifier_imba_skewer_motion_controller_target = class({})

function modifier_imba_skewer_motion_controller_target:OnCreated( params )
	if IsServer() then
		self.direction = Vector(params.direction_x, params.direction_y, params.direction_z)
		self.speed = params.speed

		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function modifier_imba_skewer_motion_controller_target:OnDestroy()
	return false
end

function modifier_imba_skewer_motion_controller_target:RemoveOnDeath()
	return false
end

function modifier_imba_skewer_motion_controller_target:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true
	}
	return state
end

function modifier_imba_skewer_motion_controller_target:UpdateHorizontalMotion( unit, time )
	if IsServer() then
		local caster = self:GetCaster()

		-- Move the target while caster has motion-controller
		if caster:HasModifier("modifier_imba_skewer_motion_controller") and caster:IsAlive() then
			unit:SetAbsOrigin(unit:GetAbsOrigin() + self.direction * self.speed)
		else
			-- Remove the motion controller once the caster lost the motion-controller
			unit:InterruptMotionControllers(true)
		end
	end
end

function modifier_imba_skewer_motion_controller_target:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

function modifier_imba_skewer_motion_controller_target:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_imba_skewer_motion_controller_target:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return decFuncs
end

modifier_imba_skewer_slow = class({})

function modifier_imba_skewer_slow:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return decFuncs
end

function modifier_imba_skewer_slow:GetModifierMoveSpeedBonus_Percentage()
	if self.pardoned then return self:GetAbility():GetSpecialValueFor("pardon_slow") * (-1) end
	return self:GetAbility():GetSpecialValueFor("slow") * (-1)
end

function modifier_imba_skewer_slow:GetModifierAttackSpeedBonus_Constant()
	if self.pardoned then return self:GetAbility():GetSpecialValueFor("pardon_slow") * (-1) end
	return self:GetAbility():GetSpecialValueFor("slow") * (-1)
end

function modifier_imba_skewer_slow:GetEffectName()
	return "particles/units/heroes/hero_magnataur/magnataur_skewer_debuff.vpcf"
end

function modifier_imba_skewer_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_skewer_slow:OnCreated( params )
	self.pardoned = params.pardoned
end

modifier_imba_skewer_entangle = class({})

function modifier_imba_skewer_entangle:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_MOVESPEED_LIMIT
	}
	return decFuncs
end

function modifier_imba_skewer_entangle:GetModifierMoveSpeed_Limit()
	return 0.1
end

function modifier_imba_skewer_entangle:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
end

function modifier_imba_skewer_entangle:GetEffectName()
	return "particles/hero/magnataur/skewer_entangle_debuff.vpcf"
end

function modifier_imba_skewer_entangle:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_skewer_entangle:OnCreated()
	if IsServer() then
		self.position = self:GetParent():GetAbsOrigin()
		self:StartIntervalThink(0.4)
	end
end

function modifier_imba_skewer_entangle:OnIntervalThink()
	if IsServer() then
		if (self.position - self:GetParent():GetAbsOrigin()):Length2D() > 3 then
			self:Destroy()
		end
	end
end

-------------------------------------------
--			REVERSE POLARITY
-------------------------------------------

imba_magnataur_reverse_polarity = class({})
LinkLuaModifier("modifier_imba_reverse_polarity_slow", "hero/hero_magnataur", LUA_MODIFIER_MOTION_NONE)

function imba_magnataur_reverse_polarity:OnAbilityPhaseStart()
	if IsServer() then
		local caster = self:GetCaster()
		local radius = self:GetTalentSpecialValueFor("main_radius")
		local caster_loc = caster:GetAbsOrigin()

		caster:EmitSound("Hero_Magnataur.ReversePolarity.Anim")

		local animation_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(animation_pfx, 0, caster, PATTACH_POINT_FOLLOW, nil, caster_loc, true)
		ParticleManager:SetParticleControl(animation_pfx, 1, Vector(radius, 0, 0))
		ParticleManager:SetParticleControl(animation_pfx, 2, Vector(self:GetCastPoint(), 0, 0))
		ParticleManager:SetParticleControl(animation_pfx, 3, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(animation_pfx)
		return true
	end
end

function imba_magnataur_reverse_polarity:IsHiddenWhenStolen()
	return false
end

function imba_magnataur_reverse_polarity:IsStealable()
	return true
end

function imba_magnataur_reverse_polarity:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()

		-- Setting the direction where Magnus is looking at so turning during cast-point is possible
		local direction = caster:GetForwardVector()

		-- Parameters
		local damage = self:GetTalentSpecialValueFor("damage")
		local radius = self:GetTalentSpecialValueFor("main_radius")
		local hero_stun_duration = self:GetSpecialValueFor("hero_stun_duration")
		local polarize_slow_duration = hero_stun_duration -- In case this needs to be changed
		local creep_stun_duration = self:GetSpecialValueFor("creep_stun_duration")
		local pull_offset = self:GetSpecialValueFor("pull_offset")
		local pull_per_stack = self:GetTalentSpecialValueFor("pull_per_stack")
		local polarize_duration = self:GetSpecialValueFor("polarize_duration")
		local polarize_slow = self:GetSpecialValueFor("polarize_slow")
		local global_pull = self:GetSpecialValueFor("global_pull")
		local final_loc = caster_loc + (direction * pull_offset)

		-- Play cast sound
		caster:EmitSound("Hero_Magnataur.ReversePolarity.Cast")
		if (math.random(1,100) <= 25) and (caster:GetName() == "npc_dota_hero_magnataur") then
			local randomsound = math.random(1,10)
			if randomsound <= 9 then
				randomsound = "0"..randomsound
			end
			caster:EmitSound("magnataur_magn_polarity_"..randomsound)
		end

		local creeps = FindUnitsInRadius(caster:GetTeam(), caster_loc, nil, radius, self:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,creep in ipairs(creeps) do
			creep:SetAbsOrigin(final_loc)
			FindClearSpaceForUnit(creep, final_loc, true)
			creep:AddNewModifier(caster, self, "modifier_stunned", {duration = creep_stun_duration})
			ApplyDamage({victim = creep, attacker = caster, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
			creep:EmitSound("Hero_Magnataur.ReversePolarity.Stun")
		end
		-- Finding all heroes on the map
		local enemies = FindUnitsInRadius(caster:GetTeam(), caster_loc, nil, 25000, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		for _,enemy in ipairs(enemies) do
			local particle_loc = final_loc
			local enemy_pos = enemy:GetAbsOrigin()
			local current_distance = ( caster_loc - enemy_pos ):Length2D()
			local pull_distance = radius
			local point_direction = (final_loc - enemy_pos):Normalized()
			local pull_pfx

			-- Increase pull-radius if the target has Polarize-stacks
			if enemy:HasModifier("modifier_imba_polarize_debuff") then
				pull_distance = pull_distance + (enemy:FindModifierByName("modifier_imba_polarize_debuff"):GetStackCount() * pull_per_stack)
				pull_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
				ParticleManager:SetParticleControl(pull_pfx, 0, enemy:GetAbsOrigin())
			else
				pull_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pull_pfx, 0, enemy:GetAbsOrigin())
			end

			-- Check if the target will be pulled into the main-radius, else check for slow, else global pull
			if pull_distance >= current_distance then
				-- Play pull particle
				enemy:SetAbsOrigin(final_loc)
				FindClearSpaceForUnit(enemy, final_loc, true)
				enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = hero_stun_duration})
				enemy:AddNewModifier(caster, nil, "modifier_imba_polarize_debuff_stack", {duration = polarize_duration})
				ApplyDamage({victim = enemy, attacker = caster, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
				enemy:EmitSound("Hero_Magnataur.ReversePolarity.Stun")
			elseif pull_distance > radius then
				pull_distance = pull_distance - radius
				local knockbackProperties =
				{
					center_x = caster:GetAbsOrigin()[1]+1,
					center_y = caster:GetAbsOrigin()[2]+1,
					center_z = caster:GetAbsOrigin()[3],
					duration = FrameTime()*2,
					knockback_duration = FrameTime()*2,
					knockback_distance = -pull_distance,
					knockback_height = 0,
					should_stun = 0
				}
				-- Apply knockback on enemies hit
				enemy:AddNewModifier(caster, self, "modifier_imba_reverse_polarity_slow", {duration = hero_stun_duration})
				enemy:AddNewModifier(caster, self, "modifier_knockback", knockbackProperties)
				particle_loc = enemy_pos + ((final_loc - enemy_pos):Normalized() * pull_distance)
			else
				pull_distance = global_pull
				local knockbackProperties =
				{
					center_x = caster:GetAbsOrigin()[1]+1,
					center_y = caster:GetAbsOrigin()[2]+1,
					center_z = caster:GetAbsOrigin()[3],
					duration = FrameTime()*2,
					knockback_duration = FrameTime()*2,
					knockback_distance = -pull_distance,
					knockback_height = 0,
					should_stun = 0
				}
				-- Apply knockback on enemies hit
				enemy:AddNewModifier(caster, self, "modifier_knockback", knockbackProperties)
				particle_loc = enemy_pos + ((final_loc - enemy_pos):Normalized() * pull_distance)
			end

			-- If an enemy was moved to the fountain area, remove it from there
			if enemy:IsRealHero() and IsNearEnemyClass(enemy, 1700, "ent_dota_fountain") then
				local fountain_loc
				if enemy:GetTeam() == DOTA_TEAM_GOODGUYS then
					fountain_loc = Vector(7472, 6912, 512)
				else
					fountain_loc = Vector(-7456, -6938, 528)
				end
				FindClearSpaceForUnit(enemy, fountain_loc + (enemy:GetAbsOrigin() - fountain_loc):Normalized() * 1700, true)
			end

			ParticleManager:SetParticleControl(pull_pfx, 1, particle_loc)
			ParticleManager:ReleaseParticleIndex(pull_pfx)

		end
	end
end

function imba_magnataur_reverse_polarity:GetCastRange( location , target)
	return self.BaseClass.GetCastRange(self,location,target) + self:GetCaster():FindTalentValue("special_bonus_imba_magnataur_7")
end

modifier_imba_reverse_polarity_slow = class({})

function modifier_imba_reverse_polarity_slow:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return decFuncs
end

function modifier_imba_reverse_polarity_slow:GetModifierMoveSpeedBonus_Percentage( )
	return self:GetAbility():GetSpecialValueFor("polarize_slow") * (-1)
end

function modifier_imba_reverse_polarity_slow:IsHidden()
	return false
end

function modifier_imba_reverse_polarity_slow:IsDebuff()
	return true
end

function modifier_imba_reverse_polarity_slow:IsPurgable()
	return true
end