--[[	Author: Broccoli
		Date: 26-3-2017		]]

CreateEmptyTalents("abaddon")

-----------------------------
--		Mist Coil          --
-----------------------------

imba_abaddon_mist_coil = class({})

function imba_abaddon_mist_coil:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local ability_name_curse_of_avernus = "imba_abaddon_curse_of_avernus"

		caster:EmitSound("Hero_Abaddon.DeathCoil.Cast")

		if caster:HasAbility(ability_name_curse_of_avernus) then
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
		else
			-- Nether ward and rubick applies level 1 curse of avernus
			-- Hence there is a need to create a dummy unit to cast the spell while possessing both mist coil and curse of avernus abilities

			local dummy 					= CreateUnitByName('npc_dummy_unit', caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
			local dummy_mist_coil 			= dummy:AddAbility("imba_abaddon_mist_coil")
			local dummy_curse_of_avernus 	= dummy:AddAbility(ability_name_curse_of_avernus)
			dummy_mist_coil:SetLevel(self:GetLevel())
			dummy_curse_of_avernus:SetLevel(1)
			-- Allow casting of mist coil immediately
			dummy_mist_coil:SetOverrideCastPoint(0)
			dummy:CastAbilityOnTarget(target, dummy_mist_coil, caster:GetPlayerID())

			-- Destroy dummy after casting mist coil
			Timers:CreateTimer(1, function()
				UTIL_Remove(dummy)
			end)
		end
	end
end

function imba_abaddon_mist_coil:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		local caster = self:GetCaster()
		local target = hTarget
		local ability_level = self:GetLevel() - 1

		target:EmitSound("Hero_Abaddon.DeathCoil.Target")

        if target:GetTeam() ~= caster:GetTeam() then
			-- If target has Linken Sphere, block effect entirely
            if target:TriggerSpellAbsorb(self) then
                return nil
            end

			local damage = self:GetLevelSpecialValueFor("damage", ability_level)
			local damage_type = DAMAGE_TYPE_MAGICAL

			ApplyDamage({ victim = target, attacker = caster, damage = damage,	damage_type = damage_type })
			
			-- Apply curse of avernus debuff
			local curse_of_avernus = caster:FindAbilityByName("imba_abaddon_curse_of_avernus")
			if curse_of_avernus then
				-- TODO test if casting mist coil without curse will it have issues here
				local debuff_duration = curse_of_avernus:GetSpecialValueFor("debuff_duration")
				target:AddNewModifier(caster, curse_of_avernus, "modifier_imba_curse_of_avernus_debuff", { duration = debuff_duration })
			else
				--TODO remove after debug
				print("Mist coil casted without curse of avernus")
			end

		else
			local heal = self:GetLevelSpecialValueFor("heal", ability_level)

			-- heal allies or self
			target:Heal(heal, caster)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, heal, nil)
        end
	end
end

-----------------------------
--	   Aphotic Shield      --
-----------------------------

imba_abaddon_aphotic_shield = class({})
LinkLuaModifier("modifier_aphotic_shield_buff", "hero/hero_abaddon", LUA_MODIFIER_MOTION_NONE)

function imba_abaddon_aphotic_shield:GetCastRange(Location, Target)
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("cast_range")
end

function imba_abaddon_aphotic_shield:OnCreated()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- Strong Dispel
	target:Purge(false, true, false, true, false)

	local modifier_name_aphotic_shield = "modifier_aphotic_shield_buff"

	-- TODO check if it explodes if reapplied
	-- Remove previous aphotic shield
	target:RemoveModifierByNameAndCaster(modifier_name_aphotic_shield, caster)

	-- Add new modifier
	local duration = self:GetSpecialValueFor("duration")
	target:AddNewModifier(caster, self, modifier_name_aphotic_shield, { duration = duration })
end

modifier_aphotic_shield_buff = class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return true end,
	IsDebuff	  			= function(self) return false end
})

function modifier_aphotic_shield_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
 
	return funcs
end

function modifier_aphotic_shield_buff:OnCreated()
	local target = self:GetParent()
	local shield_size = target:GetModelRadius() * 0.7
	local ability = self:GetAbility()
	local ability_level = ability:GetLevel()

	self.shield_remaining = ability:GetLevelSpecialValueFor( "shield", ability_level )

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	local common_vector = Vector(shield_size,0,shield_size)
	ParticleManager:SetParticleControl(particle, 1, common_vector)
	ParticleManager:SetParticleControl(particle, 2, common_vector)
	ParticleManager:SetParticleControl(particle, 4, common_vector)
	ParticleManager:SetParticleControl(particle, 5, Vector(shield_size,0,0))	

	-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
	ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

	--void AddParticle(int i, bool bDestroyImmediately, bool bStatusEffect, int iPriority, bool bHeroEffect, bool bOverheadEffect)
	self:AddParticle(particle, false, false, -1, false, false)
end

function modifier_aphotic_shield_buff:OnRemoved()
	local target 				= self:GetParent()
	local caster 				= self:GetCaster()
	local ability 				= self:GetAbility()
	local ability_level 		= ability:GetLevel()
	local radius 				= ability:GetSpecialValueFor("radius")
	local explode_target_team 	= DOTA_UNIT_TARGET_TEAM_ENEMY
	local explode_target_type 	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC

	target:EmitSound("Hero_Abaddon.AphoticShield.Destroy")

	-- TODO
	--local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, explode_target_team, explode_target_type, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	-- Deal damage to enemies around
	local damage = ability:GetLevelSpecialValueFor( "shield", ability_level )
	local damage_type = DAMAGE_TYPE_MAGICAL
	for _,enemy in pairs(enemies) do
		-- TODO check if damage is absorbed damage or just total damage
		ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = damage_type })
	end

	-- Apply debuff to enemies around
	local ability_name_curse_of_avernus 	= "imba_abaddon_curse_of_avernus"
	local curse_of_avernus 					= caster:FindAbilityByName(ability_name_curse_of_avernus)
	local spoof_caster
	if curse_of_avernus then
		spoof_caster 		= caster
	else
		--Apply debuff using dummy
		local dummy 		= CreateUnitByName('npc_dummy_unit', target:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
		curse_of_avernus 	= dummy:AddAbility(ability_name_curse_of_avernus)
		curse_of_avernus:SetLevel(1)
		spoof_caster 		= dummy

		-- Destroy dummy after applying debuff
		Timers:CreateTimer(1, function()
			UTIL_Remove(dummy)
		end)
	end

	local debuff_duration = curse_of_avernus:GetSpecialValueFor("debuff_duration")
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(spoof_caster, curse_of_avernus, "modifier_imba_curse_of_avernus_debuff", { duration = debuff_duration })
	end
end

function modifier_aphotic_shield_buff:OnTakeDamage(kv)
	local target = self:GetParent()

	-- Absorb damage taken by unit which has this buff
	if target == kv.unit then
		-- Avoid calculation when borrowed time is active
		if target:HasModifier("modifier_borrowed_time_buff") == false then
			local damage = kv.damage
			local shield_remaining = self.shield_remaining

			-- If the damage is bigger than what the shield can absorb, heal a portion
			local heal_amount
			if damage > shield_remaining then
				heal_amount = shield_remaining
			else
				heal_amount = damage
			end
			-- Heal can fail due to modifiers preventing heal, set unit's health instead
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, heal_amount, nil)
			target:SetHealth(target:GetHealth() + heal_amount)

			self.shield_remaining = self.shield_remaining - damage
			if self.shield_remaining <= 0 then
				traget:RemoveModifierByName("modifier_aphotic_shield_buff")
			end
		end
	end
end

-----------------------------
--     Curse Of Avernus    --
-----------------------------

imba_abaddon_curse_of_avernus = class({
	GetIntrinsicModifierName = function(self) return "modifier_imba_curse_of_avernus_caster" end
})
LinkLuaModifier("modifier_imba_curse_of_avernus_caster", "hero/hero_abaddon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_curse_of_avernus_debuff", "hero/hero_abaddon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_curse_of_avernus_buff", "hero/hero_abaddon", LUA_MODIFIER_MOTION_NONE)

modifier_imba_curse_of_avernus_caster = class({
	IsHidden				= function(self) return true end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end
})

function modifier_imba_curse_of_avernus_caster:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK
	}
 
	return funcs
end

function modifier_imba_curse_of_avernus_caster:OnAttack(kv)
	if IsServer() then
		local caster = self:GetCaster()
		local target = kv.target

		-- Do not apply curse if avernus if "break"
		if not caster:PassivesDisabled() then
			-- Apply curse of avernus to enemies
			if target:GetTeamNumber() ~= caster:GetTeamNumber() then
				-- Apply debuff if enemy
				local ability = self:GetAbility()
				local debuff_duration = ability:GetSpecialValueFor("debuff_duration")
				target:AddNewModifier(caster, ability, "modifier_imba_curse_of_avernus_debuff", { duration = debuff_duration })
			end
		end
	end
end

modifier_imba_curse_of_avernus_debuff = class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return true end,
	IsDebuff	  			= function(self) return true end,
	GetEffectName			= function(self) return "particles/units/heroes/hero_abaddon/abaddon_frost_slow.vpcf" end,
	GetEffectAttachType		= function(self) return PATTACH_ABSORIGIN_FOLLOW end,
})
function modifier_imba_curse_of_avernus_debuff:_UpdateSlowValues()
	if IsServer() then
		local ability = self:GetAbility()
		local ability_level = ability:GetLevel() - 1

		self.move_slow = ability:GetLevelSpecialValueFor("move_slow", ability_level)
		self.attack_slow = ability:GetLevelSpecialValueFor("attack_slow", ability_level)
	end
end

function modifier_imba_curse_of_avernus_debuff:OnCreated()
	self:_UpdateSlowValues()
end

function modifier_imba_curse_of_avernus_debuff:OnRefresh()
	self:_UpdateSlowValues()
end

function modifier_imba_curse_of_avernus_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
 
	return funcs
end

function modifier_imba_curse_of_avernus_debuff:OnAttack(kv)
	if IsServer() then
		local caster 	= self:GetCaster()
		local attacker 	= keys.attacker
		local target 	= keys.target

		-- Apply buff to allies who hit the enemy with this debuff
		if target == self:GetParent() and caster:GetTeamNumber() == attacker:GetTeamNumber() then
			local ability = self:GetAbility()
			local ability_level = ability:GetLevel()
			local buff_duration = ability:GetLevelSpecialValueFor("buff_duration", ability_level)

			attacker:AddNewModifier(caster, ability, "modifier_imba_curse_of_avernus_buff", { duration = buff_duration })
		end
	end
end

function modifier_imba_curse_of_avernus_debuff:OnTakeDamage()
	-- TODO caster gain heal equal to damage to taken (heal_convert)
end

function modifier_imba_curse_of_avernus_debuff:GetModifierMoveSpeedBonus_Percentage() return self.move_slow end
function modifier_imba_curse_of_avernus_debuff:GetModifierAttackSpeedBonus_Constant() return self.attack_slow end

modifier_imba_curse_of_avernus_buff = class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return true end,
	IsDebuff	  			= function(self) return false end,
	GetEffectName			= function(self) return "particles/units/heroes/hero_abaddon/abaddon_frost_buff.vpcf" end,
	GetEffectAttachType		= function(self) return PATTACH_ABSORIGIN_FOLLOW end,
})

function modifier_imba_curse_of_avernus_buff:_UpdateIncreaseValues()
	if IsServer() then
		local ability = self:GetAbility()
		local ability_level = ability:GetLevel() - 1

		self.move_increase = ability:GetLevelSpecialValueFor( "attack_increase" , ability_level)
	end
end

function modifier_imba_curse_of_avernus_buff:OnCreated()
	if IsServer() then
		self.move_increase = self:GetAbility():GetSpecialValueFor("move_increase")
		self:_UpdateIncreaseValues()
	end
end

function modifier_imba_curse_of_avernus_buff:OnRefresh()
	self:_UpdateIncreaseValues()
end

function modifier_imba_curse_of_avernus_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
 
	return funcs
end

function modifier_imba_curse_of_avernus_buff:GetModifierMoveSpeedBonus_Percentage() return self.move_increase end
function modifier_imba_curse_of_avernus_buff:GetModifierAttackSpeedBonus_Constant() return self.attack_increase end

-----------------------------
--		Over Channel       --
-----------------------------

-----------------------------
--       Borrowed Time     --
-----------------------------
imba_abaddon_borrowed_time = class({})
LinkLuaModifier("modifier_borrowed_time_buff", "hero/hero_abaddon", LUA_MODIFIER_MOTION_NONE)


modifier_borrowed_time_buff = class({})


--[[ TODO
		"Ability4"					"imba_abaddon_over_channel"
		"Ability5"					"imba_abaddon_borrowed_time"

		"Ability10"					"special_bonus_imba_abaddon_1"
		"Ability11"					"special_bonus_imba_abaddon_2"
		"Ability12"					"special_bonus_imba_abaddon_3"
		"Ability13"					"special_bonus_imba_abaddon_4"
		"Ability14"					"special_bonus_imba_abaddon_5"
		"Ability15"					"special_bonus_imba_abaddon_6"
		"Ability16"					"special_bonus_imba_abaddon_7"
		"Ability17"					"special_bonus_imba_abaddon_8"
]]--

function BorrowedTimeActivate( keys )

	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local threshold = ability:GetLevelSpecialValueFor( "hp_threshold" , ability:GetLevel() - 1  )
	local cooldown = ability:GetCooldown( ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1  )
	local duration_scepter = ability:GetLevelSpecialValueFor( "duration_scepter" , ability:GetLevel() - 1  )
	local scepter = HasScepter(caster)

	-- Apply the modifier
	if ability:GetCooldownTimeRemaining() == 0 then
		if caster:GetHealth() < 400 and not caster.break_duration_left then

			-- Prevents illusions from gaining the borrowed time buff
			if not caster:IsIllusion() and caster:IsAlive() then
				BorrowedTimePurge( keys )
				caster:EmitSound("Hero_Abaddon.BorrowedTime")
				ability:StartCooldown(cooldown * GetCooldownReduction(caster))
			end
		end
	end
end

function BorrowedTimeHeal( keys )

	-- Variables
	local damage = keys.DamageTaken
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local scepter = HasScepter(caster)
	local radius = keys.ability:GetLevelSpecialValueFor("redirect_range", ability:GetLevel() - 1 )

	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	-- Account for rapier damage amplification
	if attacker:HasModifier("modifier_item_imba_rapier_stacks_magic") and not caster:HasModifier("modifier_item_imba_rapier_prevent_attack_amp") then
			
		-- Calculate damage amplification
		local amp_stacks = attacker:GetModifierStackCount("modifier_item_imba_rapier_stacks_magic", attacker)
		local damage_amp = 40 + 40 * amp_stacks

		-- Amplify damage
		damage = damage * (100 + damage_amp) / 100
	end

	if scepter == true then
		caster:Heal(damage, caster)
		for _,unit in pairs(allies) do
			unit:Heal(damage / #allies, caster)
		end
	else
		caster:Heal(damage * 2, caster)
	end
end

function BorrowedTimePurge( keys )
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1  )
	local duration_scepter = ability:GetLevelSpecialValueFor( "duration_scepter" , ability:GetLevel() - 1  )
	local scepter = HasScepter(caster)

	-- Strong Dispel
	local RemovePositiveBuffs = false
	local RemoveDebuffs = true
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = true
	local RemoveExceptions = false
	caster:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
	if scepter == true then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_borrowed_time", { duration = duration_scepter })
	else
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_borrowed_time", { duration = duration })
	end

	-- Toggle the ability off
	ability:ToggleAbility()
end

function BorrowedTimeAllies( keys )
	local caster = keys.caster
	local unit = keys.unit
	local ability = keys.ability
	local damage_taken = keys.DamageTaken
	local attacker = keys.attacker
	local redirect = ability:GetLevelSpecialValueFor("redirect", ability:GetLevel() - 1 )

	-- If this unit is an illusion or currently has Borrowed Time active, do nothing
	if unit:IsIllusion() or unit:HasModifier("modifier_borrowed_time") then
		return nil
	end
	
	-- Account for rapier damage amplification
	if attacker:HasModifier("modifier_item_imba_rapier_stacks_magic") and not unit:HasModifier("modifier_item_imba_rapier_prevent_attack_amp") then
			
		-- Calculate damage amplification
		local amp_stacks = attacker:GetModifierStackCount("modifier_item_imba_rapier_stacks_magic", attacker)
		local damage_amp = 40 + 40 * amp_stacks

		-- Amplify damage
		damage_taken = damage_taken * (100 + damage_taken) / 100
	end

	local redirect_damage = damage_taken * ( redirect / ( 1 - redirect ) )
	
	ApplyDamage({ victim = caster, attacker = attacker, damage = redirect_damage, damage_type = DAMAGE_TYPE_PURE })
end