--[[	Author: Broccoli
		Date: 2-4-2017		]]

CreateEmptyTalents("abaddon")
local LinkedModifiers = {}
-- Reference of curse of avernus ability to pull values at level 1 (required for nether ward and rubick)
local _curse_of_avernus_reference = nil

function getCurseOfAvernusDummyReference()
	if IsServer() and _curse_of_avernus_reference == nil then
		local abaddon_dummy = CreateUnitByName('npc_dummy_unit', Vector(0,0,0), false, nil, nil, DOTA_TEAM_NOTEAM )
		_curse_of_avernus_reference = abaddon_dummy:AddAbility("imba_abaddon_curse_of_avernus")
		_curse_of_avernus_reference:SetLevel(1)		
	end

	return _curse_of_avernus_reference
end


function getOverChannelIncrease(caster)
	if caster:HasModifier("modifier_over_channel_handler") then
		local over_channel = caster:FindAbilityByName("imba_abaddon_over_channel")
		if over_channel then
			local ability_level = over_channel:GetLevel() - 1
			-- #6 Talent: +50% Overchannel power
			return over_channel:GetLevelSpecialValueFor( "extra_dmg" , ability_level ) * (1 + caster:FindTalentValue("special_bonus_imba_abaddon_6"))
		end
	end

	return 0
end

-----------------------------
--		Mist Coil          --
-----------------------------
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_mist_coil_passive"] = LUA_MODIFIER_MOTION_NONE,
})
imba_abaddon_mist_coil = imba_abaddon_mist_coil or class({})

function imba_abaddon_mist_coil:GetAbilityTextureName()
   return "abaddon_death_coil"
end

function imba_abaddon_mist_coil:GetIntrinsicModifierName()
    return "modifier_imba_mist_coil_passive"
end

function imba_abaddon_mist_coil:GetCastRange() 
	return self:GetSpecialValueFor("cast_range")
end
function imba_abaddon_mist_coil:IsHiddenWhenStolen()	return false end

function imba_abaddon_mist_coil:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		caster:EmitSound("Hero_Abaddon.DeathCoil.Cast")
		
		local responses = {"abaddon_abad_deathcoil_01","abaddon_abad_deathcoil_02","abaddon_abad_deathcoil_06","abaddon_abad_deathcoil_08",}
		caster:EmitCasterSound("npc_dota_hero_abaddon",responses, 25, DOTA_CAST_SOUND_FLAG_NONE, 20,"coil")

		local health_cost = getOverChannelIncrease(caster)

		if health_cost > 0 then
			ApplyDamage({ victim = caster, attacker = caster, ability = self, damage = health_cost, damage_type = DAMAGE_TYPE_PURE })
		end

		-- Create the projectile
		local info = {
			Target = target,
			Source = caster,
			Ability = self,
			EffectName = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf",
			bDodgeable = false,
			bProvidesVision = true,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
			iVisionRadius = 0,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		ProjectileManager:CreateTrackingProjectile( info )
	end
end

function imba_abaddon_mist_coil:GetCooldown()
	-- #3 Talent: -1.5sec cooldown on Mist Coil
	return self:GetSpecialValueFor("cooldown") + self:GetCaster():FindTalentValue("special_bonus_imba_abaddon_3")
end

function imba_abaddon_mist_coil:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		local caster = self:GetCaster()
		local target = hTarget
		local ability_level = self:GetLevel() - 1

		target:EmitSound("Hero_Abaddon.DeathCoil.Target")

		local over_channel_increase = getOverChannelIncrease(caster)

        if target:GetTeam() ~= caster:GetTeam() then
			-- If target has Linken Sphere, block effect entirely
            if target:TriggerSpellAbsorb(self) then
                return nil
            end

			local damage = self:GetLevelSpecialValueFor("damage", ability_level) + over_channel_increase
			local damage_type = DAMAGE_TYPE_MAGICAL

			-- Apply damage + parsing if the ability killed the target
			local dealt_damage = ApplyDamage({ victim = target, attacker = caster, damage = damage,	damage_type = damage_type })
			if caster:HasModifier(self:GetIntrinsicModifierName()) then
				caster:FindModifierByName(self:GetIntrinsicModifierName()).applied_damage = dealt_damage
			end
			-- Apply curse of avernus debuff
			local curse_of_avernus = caster:FindAbilityByName("imba_abaddon_curse_of_avernus")
			
			if not curse_of_avernus then
				curse_of_avernus = getCurseOfAvernusDummyReference()
			end

			local debuff_duration = curse_of_avernus:GetSpecialValueFor("debuff_duration")

			-- debuff_duration can be 0 if caster has ability but not learnt it yet
			if debuff_duration > 0 and not caster:PassivesDisabled() then
				target:AddNewModifier(caster, curse_of_avernus, "modifier_imba_curse_of_avernus_debuff_slow", { duration = debuff_duration })
			end

		else
			--Apply spellpower to heal
			local heal_amp = 1 + (caster:GetSpellPower() * 0.01)

			local heal = (self:GetLevelSpecialValueFor("heal", ability_level) + over_channel_increase) * heal_amp			
	
			-- heal allies or self
			target:Heal(heal, caster)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, heal, nil)
        end

		-- Extra effect if coil was casted with over channel
		if caster:HasModifier("modifier_over_channel_handler") then
			local over_channel_particle = ParticleManager:CreateParticle("particles/dev/library/base_dust_hit_detail.vpcf", PATTACH_POINT, target)
			ParticleManager:ReleaseParticleIndex(over_channel_particle)

			over_channel_particle = ParticleManager:CreateParticle("particles/dev/library/base_dust_hit_smoke.vpcf", PATTACH_POINT, target)
			ParticleManager:ReleaseParticleIndex(over_channel_particle)
		end
		
		-- Cast response
		Timers:CreateTimer(0.4, function()
			if self.killed then
				local responses = {"abaddon_abad_deathcoil_03","abaddon_abad_deathcoil_07","abaddon_abad_deathcoil_04","abaddon_abad_deathcoil_05","abaddon_abad_deathcoil_09","abaddon_abad_deathcoil_10"}
				caster:EmitCasterSound("npc_dota_hero_abaddon",responses, 25, DOTA_CAST_SOUND_FLAG_BOTH_TEAMS, nil,nil)
				self.killed = nil
			end
		end)
	end
end

modifier_imba_mist_coil_passive = modifier_imba_mist_coil_passive or class({})
function modifier_imba_mist_coil_passive:IsDebuff() return false end
function modifier_imba_mist_coil_passive:IsHidden() return true end
function modifier_imba_mist_coil_passive:IsPurgable() return false end
function modifier_imba_mist_coil_passive:IsPurgeException() return false end
function modifier_imba_mist_coil_passive:IsStunDebuff() return false end
function modifier_imba_mist_coil_passive:RemoveOnDeath() return false end
-------------------------------------------
function modifier_imba_mist_coil_passive:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
    return decFuns
end

function modifier_imba_mist_coil_passive:OnDeath(keys)
	if self.applied_damage then
		if keys.attacker == self:GetParent() then
			if self.record then
				if self.record == keys.record then
					local ability = self:GetAbility()
					if ability then
						ability.killed = true
					end
				end
			end
		end
	end
end

function modifier_imba_mist_coil_passive:OnTakeDamage(keys)
	if self.applied_damage then
		if keys.attacker == self:GetParent() then
			if keys.damage == self.applied_damage then
				self.record = keys.record
			end
		end
	end
end

-----------------------------
--	   Aphotic Shield      --
-----------------------------
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_aphotic_shield_buff_block"] = LUA_MODIFIER_MOTION_NONE,
})
imba_abaddon_aphotic_shield = imba_abaddon_aphotic_shield or class({})

function imba_abaddon_aphotic_shield:GetAbilityTextureName()
   return "abaddon_aphotic_shield"
end

function imba_abaddon_aphotic_shield:GetCastRange(Location, Target)
	-- #1 Talent: +150 Aphotic Shield cast range
	return self:GetSpecialValueFor("cast_range") + self:GetCaster():FindTalentValue("special_bonus_imba_abaddon_1")
end

function imba_abaddon_aphotic_shield:IsHiddenWhenStolen()	return false end

function imba_abaddon_aphotic_shield:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		-- Play Sound
		caster:EmitSound("Hero_Abaddon.AphoticShield.Cast")
		local responses = {"abaddon_abad_aphoticshield_01","abaddon_abad_aphoticshield_02","abaddon_abad_aphoticshield_03","abaddon_abad_aphoticshield_04","abaddon_abad_aphoticshield_05","abaddon_abad_aphoticshield_06","abaddon_abad_aphoticshield_07"}
		caster:EmitCasterSound("npc_dota_hero_abaddon",responses, 50, DOTA_CAST_SOUND_FLAG_NONE, 20,"aphotic_shield")

		-- Check health cost required due to over channel
		local health_cost = getOverChannelIncrease(caster)
		if health_cost > 0 then
			ApplyDamage({ victim = caster, attacker = caster, ability = self, damage = health_cost, damage_type = DAMAGE_TYPE_PURE })
		end

		-- Strong Dispel
		target:Purge(false, true, false, true, false)

		local modifier_name_aphotic_shield = "modifier_imba_aphotic_shield_buff_block"

		-- Remove previous aphotic shield
		-- Did not use RemoveModifierByNameAndCaster because it will not destroy the shield if it was stolen by rubick from another rubick who stole from abaddon
		target:RemoveModifierByName(modifier_name_aphotic_shield)

		-- #2 Talent: +45sec duration on Aphotic Shield
		local duration = self:GetSpecialValueFor("duration") + caster:FindTalentValue("special_bonus_imba_abaddon_2")
		-- Add new modifier
		target:AddNewModifier(caster, self, modifier_name_aphotic_shield, { duration = duration })
	end
end

modifier_imba_aphotic_shield_buff_block = modifier_imba_aphotic_shield_buff_block or class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return true end,
	IsDebuff	  			= function(self) return false end
})

function modifier_imba_aphotic_shield_buff_block:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
 
	return funcs
end

function modifier_imba_aphotic_shield_buff_block:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local shield_size = target:GetModelRadius() * 0.7
		local ability = self:GetAbility()
		local ability_level = ability:GetLevel()
		local target_origin = target:GetAbsOrigin()
		local attach_hitloc = "attach_hitloc"

		-- #5 Talent: +200 shielding on Aphotic Shield
		self.shield_init_value = ability:GetLevelSpecialValueFor( "shield", ability_level ) + caster:FindTalentValue("special_bonus_imba_abaddon_5") + getOverChannelIncrease(caster)
		self.shield_remaining = self.shield_init_value
		self.target_current_health = target:GetHealth()

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		local common_vector = Vector(shield_size,0,shield_size)
		ParticleManager:SetParticleControl(particle, 1, common_vector)
		ParticleManager:SetParticleControl(particle, 2, common_vector)
		ParticleManager:SetParticleControl(particle, 4, common_vector)
		ParticleManager:SetParticleControl(particle, 5, Vector(shield_size,0,0))

		-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
		ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, attach_hitloc, target_origin, true)
		self:AddParticle(particle, false, false, -1, false, false)

		-- Extra effect if shield was casted with over channel
		if caster:HasModifier("modifier_over_channel_handler") then
			local over_channel_particle = ParticleManager:CreateParticle("particles/econ/courier/courier_baekho/courier_baekho_ambient_vapor.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControlEnt(over_channel_particle, 0, target, PATTACH_POINT_FOLLOW, attach_hitloc, target_origin, true)
			self:AddParticle(over_channel_particle, false, false, -1, false, false)

			over_channel_particle = ParticleManager:CreateParticle("particles/econ/courier/courier_baekho/courier_baekho_ambient_swirl.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControlEnt(over_channel_particle, 0, target, PATTACH_POINT_FOLLOW, attach_hitloc, target_origin, true)
			self:AddParticle(over_channel_particle, false, false, -1, false, false)
		end

	end
end

function modifier_imba_aphotic_shield_buff_block:OnDestroy()
	if IsServer() then
		local target 				= self:GetParent()
		local caster 				= self:GetCaster()
		local ability 				= self:GetAbility()
		local ability_level 		= ability:GetLevel()
		local radius 				= ability:GetSpecialValueFor("radius")
		local explode_target_team 	= DOTA_UNIT_TARGET_TEAM_ENEMY
		local explode_target_type 	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local target_vector			= target:GetAbsOrigin()
		target:EmitSound("Hero_Abaddon.AphoticShield.Destroy")

		-- Explosion particle is shown by default when the particle is to be removed, however that does not work for illusions. Hence this added explosion is to make the particle show when illusions die
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle, 0, target_vector) 
		ParticleManager:ReleaseParticleIndex(particle)

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_vector, nil, radius, explode_target_team, explode_target_type, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		-- Deal damage to enemies around
		local damage = self.shield_init_value
		local damage_type = DAMAGE_TYPE_MAGICAL
		for _,enemy in pairs(enemies) do
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = damage_type })
		end

		-- Apply debuff to enemies around
		local curse_of_avernus 	= caster:FindAbilityByName("imba_abaddon_curse_of_avernus")

		if not curse_of_avernus then
			curse_of_avernus = getCurseOfAvernusDummyReference()
		end

		local debuff_duration = curse_of_avernus:GetSpecialValueFor("debuff_duration")

		-- debuff_duration can be 0 if caster has ability but has not learnt it yet
		if debuff_duration > 0 then
			for _,enemy in pairs(enemies) do
				if not caster:PassivesDisabled() then
					enemy:AddNewModifier(caster, curse_of_avernus, "modifier_imba_curse_of_avernus_debuff_slow", { duration = debuff_duration })
				end
				-- Show particle when hit
				particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_hit.vpcf", PATTACH_POINT, enemy)
				ParticleManager:SetParticleControlEnt(particle, 0, enemy, PATTACH_POINT, "attach_hitloc", enemy:GetAbsOrigin(), true)
				local hit_size = enemy:GetModelRadius() * 0.3
				ParticleManager:SetParticleControl(particle, 1, Vector(hit_size, hit_size, hit_size))
				ParticleManager:ReleaseParticleIndex(particle)
			end
		end
	end
end


--Block damage
function modifier_imba_aphotic_shield_buff_block:GetModifierTotal_ConstantBlock(kv)
	if IsServer() then
		local target 					= self:GetParent()
		local original_shield_amount	= self.shield_remaining
		local shield_hit_particle 		= "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_hit.vpcf"
		-- Avoid blocking when borrowed time is active						--No need for block when there is no damage
		if not target:HasModifier("modifier_imba_borrowed_time_buff_hot_caster")  and kv.damage > 0 then
		
			--Reduce the amount of shield remaining
			self.shield_remaining = self.shield_remaining - kv.damage 
				
			
			--If there is enough shield to block everything, then block everything.
			if kv.damage < original_shield_amount then
				--Emit damage blocking effect
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, kv.damage, nil)
				return kv.damage
			--Else, reduce what you can and blow up the shield
			else
				--Emit damage block effect
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, original_shield_amount, nil)
				self:Destroy()
				return original_shield_amount
			end
			
		end
	end
	
end 


-----------------------------
--     Curse Of Avernus    --
-----------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_curse_of_avernus_debuff_slow"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_curse_of_avernus_buff_haste"] = LUA_MODIFIER_MOTION_NONE
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_curse_of_avernus_passive"] = LUA_MODIFIER_MOTION_NONE,
})
imba_abaddon_curse_of_avernus = imba_abaddon_curse_of_avernus or class({
	GetIntrinsicModifierName = function(self) return "modifier_imba_curse_of_avernus_passive" end,
	GetAbilityTextureName = function(self) return "abaddon_frostmourne" end
})

modifier_imba_curse_of_avernus_passive = modifier_imba_curse_of_avernus_passive or class({
	IsHidden				= function(self) return true end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end
})

function modifier_imba_curse_of_avernus_passive:OnCreated()
	if IsServer() then
		local target = self:GetParent()
		if target:IsIllusion() then
			self:Destroy()
		end
	end
end

function modifier_imba_curse_of_avernus_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
	}
 
	return funcs
end

function modifier_imba_curse_of_avernus_passive:OnAttack(kv)
	if IsServer() then
		local caster = self:GetCaster()

		-- Do not apply curse if avernus if "break"
		if not caster:PassivesDisabled() then

			local attacker = kv.attacker

			if attacker == caster then

				local target = kv.target

				-- Apply curse of avernus to enemies
				if target:GetTeamNumber() ~= caster:GetTeamNumber() then
					-- Apply debuff if enemy
					local ability = self:GetAbility()
					if ability then
						local debuff_duration = ability:GetSpecialValueFor("debuff_duration") -- Not possible for this to be 0 here
						target:AddNewModifier(caster, ability, "modifier_imba_curse_of_avernus_debuff_slow", { duration = debuff_duration })
						local responses = {"abaddon_abad_frostmourne_01","abaddon_abad_frostmourne_02","abaddon_abad_frostmourne_03","abaddon_abad_frostmourne_04","abaddon_abad_frostmourne_05","abaddon_abad_frostmourne_06","abaddon_abad_frostmourne_06"}
						caster:EmitCasterSound("npc_dota_hero_abaddon",responses, 50, DOTA_CAST_SOUND_FLAG_NONE, 30,"curse_of_avernus")
					end
				end
			end
		end
	end
end

modifier_imba_curse_of_avernus_debuff_slow = modifier_imba_curse_of_avernus_debuff_slow or class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return true end,
	IsDebuff	  			= function(self) return true end,
	GetEffectName			= function(self) return "particles/units/heroes/hero_abaddon/abaddon_frost_slow.vpcf" end,
	GetEffectAttachType		= function(self) return PATTACH_ABSORIGIN_FOLLOW end,
})

function modifier_imba_curse_of_avernus_debuff_slow:_UpdateSlowValues()
	local ability = self:GetAbility()

	self.move_slow = -(ability:GetSpecialValueFor("move_slow"))
	self.attack_slow = -(ability:GetSpecialValueFor("attack_slow"))
	-- Convert heal_convert to decimal point (optimization)
	self.heal_convert = (ability:GetSpecialValueFor("heal_convert") / 100)
end

function modifier_imba_curse_of_avernus_debuff_slow:OnCreated()
	self:_UpdateSlowValues()

	if IsServer() then
		local caster = self:GetCaster()

		-- Give caster the buff immediately, else caster has to hit the target again to gain the buff
		local buff_name = "modifier_imba_curse_of_avernus_buff_haste"
		local current_buff = caster:FindModifierByName(buff_name)
		if not current_buff then
			local ability = self:GetAbility()
			local buff_duration = ability:GetSpecialValueFor( "buff_duration" ) -- Not possible for this to be 0 here
			caster:AddNewModifier(caster, ability, buff_name, { duration = buff_duration })
		else
			current_buff:ForceRefresh()
		end
	end
end

function modifier_imba_curse_of_avernus_debuff_slow:OnRefresh()
	self:_UpdateSlowValues()
end

function modifier_imba_curse_of_avernus_debuff_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
 
	return funcs
end

function modifier_imba_curse_of_avernus_debuff_slow:OnAttack(kv)
	if IsServer() then

		local target = kv.target

		-- Apply buff to allies who hit the enemy with this debuff
		if target == self:GetParent() then
			local caster 	= self:GetCaster()
			local attacker 	= kv.attacker

			if caster:GetTeamNumber() == attacker:GetTeamNumber() then
				local ability = self:GetAbility()
				local buff_duration = ability:GetSpecialValueFor( "buff_duration" ) -- Not possible for this to be 0 here
				-- Apply buff on allies who attack this enemy
				attacker:AddNewModifier(caster, ability, "modifier_imba_curse_of_avernus_buff_haste", { duration = buff_duration })
			end
		end
	end
end

function modifier_imba_curse_of_avernus_debuff_slow:OnTakeDamage(kv)
	
	if IsServer() then

		-- Caster gain heal equal to damage to taken (heal_convert)
		local heal_convert = self.heal_convert

		-- Do not process if there is no heal convert
		if heal_convert > 0 then
			local target = self:GetParent()

			-- Unit having this debuff must be the one taking damage
			if target == kv.unit then
				local caster = self:GetCaster()
				local damage = kv.damage
				local target_health_left = target:GetHealth()

				-- Ensure that we do not heal over the target's health
				local heal_amount
				if damage > target_health_left then
					heal_amount = target_health_left
				else
					heal_amount = damage
				end
				heal_amount = heal_amount * heal_convert

				local life_steal_particle_name = "particles/generic_gameplay/generic_lifesteal.vpcf"
				-- Show heal animation on caster
				local healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_POINT_FOLLOW, caster)
				ParticleManager:ReleaseParticleIndex(healFX)
				-- Heal caster equal to a percentage of damage taken by unit affected by this debuff
				caster:Heal(heal_amount, caster)

				if caster:HasModifier("modifier_imba_borrowed_time_buff_hot_caster") then
					local buffed_allies = caster._borrowed_time_buffed_allies
					-- Aghanim heal allies
					if buffed_allies and caster:HasScepter() then
						for k,_ in pairs(buffed_allies) do
							-- Show heal animation on allies
							healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_POINT_FOLLOW, k)
							ParticleManager:ReleaseParticleIndex(healFX)
							-- Show value healed on allies
							SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, k, heal_amount, nil)
							k:Heal(heal_amount, caster)
						end
					end
				end
			end
		end
	end
end

function modifier_imba_curse_of_avernus_debuff_slow:GetModifierMoveSpeedBonus_Percentage() return self.move_slow end
function modifier_imba_curse_of_avernus_debuff_slow:GetModifierAttackSpeedBonus_Constant() return self.attack_slow end

modifier_imba_curse_of_avernus_buff_haste = modifier_imba_curse_of_avernus_buff_haste or class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return true end,
	IsDebuff	  			= function(self) return false end,
	GetEffectName			= function(self) return "particles/units/heroes/hero_abaddon/abaddon_frost_buff.vpcf" end,
	GetEffectAttachType		= function(self) return PATTACH_ABSORIGIN_FOLLOW end,
})

function modifier_imba_curse_of_avernus_buff_haste:_UpdateIncreaseValues()
	local ability = self:GetAbility()
	local caster = self:GetCaster()

	-- #4 Talent: +5% move speed/+30 attack speed on Curse of Avernus
	local talent_name = "special_bonus_imba_abaddon_4"
	local move_increase_name = "move_increase"
	local attack_increase_name = "attack_increase"
	self.move_increase = ability:GetSpecialValueFor( move_increase_name ) + caster:FindSpecificTalentValue( talent_name, move_increase_name )
	self.attack_increase = ability:GetSpecialValueFor( attack_increase_name ) + caster:FindSpecificTalentValue( talent_name, attack_increase_name )
end

function modifier_imba_curse_of_avernus_buff_haste:OnCreated()
	self:_UpdateIncreaseValues()
end

function modifier_imba_curse_of_avernus_buff_haste:OnRefresh()
	self:_UpdateIncreaseValues()
end

function modifier_imba_curse_of_avernus_buff_haste:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
 
	return funcs
end

function modifier_imba_curse_of_avernus_buff_haste:GetModifierMoveSpeedBonus_Percentage() return self.move_increase end
function modifier_imba_curse_of_avernus_buff_haste:GetModifierAttackSpeedBonus_Constant() return self.attack_increase end

-----------------------------
--		Over Channel       --
-----------------------------
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_over_channel_handler"] = LUA_MODIFIER_MOTION_NONE,
})
imba_abaddon_over_channel = imba_abaddon_over_channel or class({
	IsStealable 			= function(self) return false end,
	IsInnateAbility			= function(self) return true end,
	GetAbilityTextureName	= function(self) return "custom/abaddon_over_channel" end,
})

function imba_abaddon_over_channel:OnToggle()
	if IsServer() then
		local caster 		= self:GetCaster()
		local modifier_name = "modifier_over_channel_handler"
		if self:GetToggleState() then
			caster:AddNewModifier(caster, self, modifier_name, {})
		else
			caster:RemoveModifierByName( modifier_name )
		end
	end
end

function imba_abaddon_over_channel:OnOwnerSpawned()
	-- self.death_toggle_mode can be nil but still works here
	if self.death_toggle_mode ~= self:GetToggleState() then
		self:ToggleAbility()
	end
end

function imba_abaddon_over_channel:OnOwnerDied()
	-- If this is not overriden, toggle will set back to off when hero dies
	self.death_toggle_mode = self:GetToggleState()
	-- Note that I have tried ResetToggleOnRespawn but it doesn't seem to work
end

modifier_over_channel_handler = modifier_over_channel_handler or class({
	IsHidden				= function(self) return true end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
	IsPermanent				= function(self) return true end,
	RemoveOnDeath			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end -- Allow illusions to carry this particle modifier
})

function modifier_over_channel_handler:OnCreated()
	local target = self:GetParent()
	local target_origin = target:GetAbsOrigin()
	local particle_name = "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_trail_steam_blue.vpcf"

	-- Body steam particle
	local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_origin, true)
	self:AddParticle(particle, false, false, -1, false, false)

	-- Weapon particle
	particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_attack1", target_origin, true)
	self:AddParticle(particle, false, false, -1, false, false)
end

-----------------------------
--       Borrowed Time     --
-----------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_borrowed_time_buff_hot_caster"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_borrowed_time_buff_hot_ally"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_borrowed_time_handler"] = LUA_MODIFIER_MOTION_NONE,
})
imba_abaddon_borrowed_time = imba_abaddon_borrowed_time or class({
	GetIntrinsicModifierName = function(self) if self:GetCaster():IsRealHero() then return "modifier_imba_borrowed_time_handler" end end,
	GetAbilityTextureName = function(self) return "abaddon_borrowed_time" end
})
function imba_abaddon_borrowed_time:IsNetherWardStealable() return false end
function imba_abaddon_borrowed_time:OnUpgrade()
	local over_channel = self:GetCaster():FindAbilityByName("imba_abaddon_over_channel")
	if over_channel then
		over_channel:SetLevel(1 + self:GetLevel())
	end
end

function imba_abaddon_borrowed_time:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local ability_level = self:GetLevel()
		-- #7 Talent: +1sec duration on Borrowed Time
		local buff_duration = self:GetLevelSpecialValueFor("duration", ability_level) + caster:FindTalentValue("special_bonus_imba_abaddon_7")
		caster:AddNewModifier(caster, self, "modifier_imba_borrowed_time_buff_hot_caster", { duration = buff_duration })
		local responses = {"abaddon_abad_borrowedtime_02","abaddon_abad_borrowedtime_03","abaddon_abad_borrowedtime_04","abaddon_abad_borrowedtime_05","abaddon_abad_borrowedtime_06","abaddon_abad_borrowedtime_07","abaddon_abad_borrowedtime_08","abaddon_abad_borrowedtime_09","abaddon_abad_borrowedtime_10","abaddon_abad_borrowedtime_11"}
		if not caster:EmitCasterSound("npc_dota_hero_abaddon",responses, 50, DOTA_CAST_SOUND_FLAG_BOTH_TEAMS,nil,nil) then
			caster:EmitCasterSound("npc_dota_hero_abaddon",{"abaddon_abad_borrowedtime_01"}, 1, DOTA_CAST_SOUND_FLAG_BOTH_TEAMS, nil,nil)
		end
	end
end

modifier_imba_borrowed_time_handler = modifier_imba_borrowed_time_handler or class({
	IsHidden				= function(self) return true end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
})

function modifier_imba_borrowed_time_handler:_CheckHealth(damage)
	local target = self:GetParent()
	local ability = self:GetAbility()

	-- Check state
	if not ability:IsHidden() and ability:IsCooldownReady() and not target:PassivesDisabled() and target:IsAlive() then
		local hp_threshold = self.hp_threshold
		local current_hp = target:GetHealth()
		if current_hp <= hp_threshold then
			target:CastAbilityImmediately(ability, target:GetPlayerID())			
		end
	end
end

function modifier_imba_borrowed_time_handler:OnCreated()
	if IsServer() then
		local target = self:GetParent()
		if target:IsIllusion() then
			self:Destroy()
		else
			self.hp_threshold = self:GetAbility():GetSpecialValueFor("hp_threshold")

			-- Check if we need to auto cast immediately
			self:_CheckHealth(0)
		end
	end
end

function modifier_imba_borrowed_time_handler:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_STATE_CHANGED
	}
 
	return funcs
end

function modifier_imba_borrowed_time_handler:OnTakeDamage(kv)
	
	if IsServer() then
		local target = self:GetParent()

		if target == kv.unit then
			-- Auto cast borrowed time if damage will bring target to lower than hp_threshold
			self:_CheckHealth(kv.damage)
		end
	end
	
end

function modifier_imba_borrowed_time_handler:OnStateChanged(kv)
	-- Trigger borrowed time if health below hp_threshold after silence/hex
	if IsServer() then
		local target = self:GetParent()
		if target == kv.unit then
			self:_CheckHealth(0)
		end
	end
end

modifier_imba_borrowed_time_buff_hot_caster = modifier_imba_borrowed_time_buff_hot_caster or class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
	IsAura					= function(self) return true end,
	IsAuraActiveOnDeath		= function(self) return false end,
	GetModifierAura			= function(self) return "modifier_imba_borrowed_time_buff_hot_ally" end,
	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO end,
	GetAuraSearchTeam		= function(self) return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
	GetEffectName			= function(self) return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf" end,
	GetEffectAttachType		= function(self) return PATTACH_ABSORIGIN_FOLLOW end,
	GetStatusEffectName		= function(self) return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf" end,
	StatusEffectPriority	= function(self) return 15 end,
})

function modifier_imba_borrowed_time_buff_hot_caster:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
 
	return funcs
end

function modifier_imba_borrowed_time_buff_hot_caster:GetAuraRadius()
	-- #8 Talent: +300 aura range on Borrowed Time
	return self:GetAbility():GetSpecialValueFor("redirect_range") + self:GetCaster():FindTalentValue("special_bonus_imba_abaddon_8")
end

function modifier_imba_borrowed_time_buff_hot_caster:GetAuraEntityReject(hEntity)
	-- Do not apply aura to target
	return hEntity == self:GetParent()
end

function modifier_imba_borrowed_time_buff_hot_caster:OnCreated()
	if IsServer() then
		local target = self:GetParent()

		self.target_current_health = target:GetHealth()

		-- Create/Reset list to keep track of allies affected by buff
		target._borrowed_time_buffed_allies = {}

		-- Play Sound
		target:EmitSound("Hero_Abaddon.BorrowedTime")

		-- Strong Dispel
		target:Purge(false, true, false, true, false)

	end	
end


--Block damage

function modifier_imba_borrowed_time_buff_hot_caster:GetModifierIncomingDamage_Percentage(kv)
	if IsServer() then
		-- Ability properties
		local target 	= self:GetParent()

		-- Show borrowed time heal particle
		local heal_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		local target_vector = target:GetAbsOrigin()
		ParticleManager:SetParticleControl(heal_particle, 0, target_vector)
		ParticleManager:SetParticleControl(heal_particle, 1, target_vector)
		ParticleManager:ReleaseParticleIndex(heal_particle)
		
			--  A heal to heal the damage,and -100% to prevent it,
			target:Heal(kv.damage, target)
			return -100
	end
end 

modifier_imba_borrowed_time_buff_hot_ally = modifier_imba_borrowed_time_buff_hot_ally or class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
})

function modifier_imba_borrowed_time_buff_hot_ally:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
 
	return funcs
end

function modifier_imba_borrowed_time_buff_hot_ally:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local buff_list = caster._borrowed_time_buffed_allies
		if buff_list then
			buff_list[target] = true
		end

		local target_origin = target:GetAbsOrigin()
		local particle_name = "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_trail_steam.vpcf"

		-- Body steam particle
		local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_origin, true)
		self:AddParticle(particle, false, false, -1, false, false)

		-- Weapon particle
		particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_attack1", target_origin, true)
		self:AddParticle(particle, false, false, -1, false, false)
	end
end

function modifier_imba_borrowed_time_buff_hot_ally:OnRemoved()
	if IsServer() then
		local caster = self:GetCaster()
		local buff_list = caster._borrowed_time_buffed_allies
		if buff_list then
			buff_list[self:GetParent()] = nil
		end
	end
end

function modifier_imba_borrowed_time_buff_hot_ally:GetModifierIncomingDamage_Percentage(kv)
	if IsServer() then
		-- Ability properties
		local caster 		=	self:GetCaster()
		local target 		= 	self:GetParent()
		local ability 		=	self:GetAbility()
		local ability_level	=	ability:GetLevel()
		local attacker 		=	kv.attacker
		local redirect_pct	=	(ability:GetLevelSpecialValueFor("redirect", ability_level))
		local redirect_damage =	kv.damage * (redirect_pct/100)
		
		--Apply the damage to Abaddon.
		ApplyDamage({ victim = caster, attacker = attacker, damage = redirect_damage, damage_type = DAMAGE_TYPE_PURE })
		
		--Block the amount of damage required.
		return -(redirect_pct)

	end
end

-------------------------------------------
for LinkedModifier, MotionController in pairs(LinkedModifiers) do
	LinkLuaModifier(LinkedModifier, "hero/hero_abaddon", MotionController)
end