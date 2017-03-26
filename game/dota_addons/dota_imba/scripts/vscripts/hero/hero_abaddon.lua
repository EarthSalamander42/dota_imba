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


--[[ TODO
		"Ability2"					"imba_abaddon_aphotic_shield"
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

function AphoticShieldInitialize( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local stacks_modifier = keys.stacks_modifier
	local max_charges = ability:GetLevelSpecialValueFor("max_charges", ability_level )
	
	-- Initialize stack and reset skill cooldown
	caster:SetModifierStackCount(stacks_modifier, caster, max_charges)
	ability:EndCooldown()
	caster.aphotic_cooldown = 0.0
end

function AphoticShieldThink( keys )
	local caster = keys.caster

	-- If this is Rubick and Aphotic Shield is no longer present, do nothing and kill the modifiers
	if IsStolenSpell(caster) then
		if not caster:FindAbilityByName("imba_abaddon_aphotic_shield") then
			caster:RemoveModifierByName("modifier_aphotic_shield_stack_counter")
			return nil
		end
	end
end

function AphoticShield( keys )
	local caster = keys.caster
	local ability = keys.ability
	local stacks_modifier = keys.stacks_modifier
	local charges_on_cast = caster:GetModifierStackCount(stacks_modifier, caster)
	
	-- Check if there are enough charges to cast the skill
	if charges_on_cast > 0 then

		-- Variables
		local target = keys.target
		local ability_level = ability:GetLevel() - 1
		local shield_modifier = keys.shield_modifier
		local cast_sound = keys.cast_sound
		local max_damage_absorb = keys.ability:GetLevelSpecialValueFor("damage_absorb", ability_level)
		local shield_size = target:GetModelRadius() * 0.7
		local max_charges = ability:GetLevelSpecialValueFor("max_charges", ability_level)
		local charge_cooldown = ability:GetLevelSpecialValueFor("charge_cooldown", ability_level)

		-- Deplete charge
		if charges_on_cast == max_charges then
			AphoticShieldStartCooldown(caster, ability, stacks_modifier, max_charges, charge_cooldown, charge_cooldown)
		end
		caster:SetModifierStackCount(stacks_modifier, caster, charges_on_cast - 1 )

		-- Play sound, apply modifier
		target:EmitSound(cast_sound)
		target:RemoveModifierByName(shield_modifier)
		ability:ApplyDataDrivenModifier(caster, target, shield_modifier, {})

		-- Strong Dispel
		local RemovePositiveBuffs = false
		local RemoveDebuffs = true
		local BuffsCreatedThisFrameOnly = false
		local RemoveStuns = true
		local RemoveExceptions = false
		target:Purge(RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)	

		-- Reset the shield
		target.AphoticShieldRemaining = max_damage_absorb	

		-- Particle. Need to wait one frame for the older particle to be destroyed
		Timers:CreateTimer(0.01, function() 
			target.ShieldParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(target.ShieldParticle, 1, Vector(shield_size,0,shield_size))
			ParticleManager:SetParticleControl(target.ShieldParticle, 2, Vector(shield_size,0,shield_size))
			ParticleManager:SetParticleControl(target.ShieldParticle, 4, Vector(shield_size,0,shield_size))
			ParticleManager:SetParticleControl(target.ShieldParticle, 5, Vector(shield_size,0,0))	

			-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
			ParticleManager:SetParticleControlEnt(target.ShieldParticle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		end)

		-- Check if stack is 0, display ability cooldown
		if caster:GetModifierStackCount(stacks_modifier, caster) == 0 then
			
			-- Start cooldown from caster.aphotic_cooldown
			ability:EndCooldown()
			ability:StartCooldown(caster.aphotic_cooldown)
		else
			ability:EndCooldown()
		end
	else
		ability:RefundManaCost()
	end
end

function AphoticShieldStartCooldown( caster, ability, stacks_modifier, max_charges, charge_cooldown, cooldown )
	caster.aphotic_cooldown = cooldown
	if caster.aphotic_cooldown <= 0 then
		local current_charges = caster:GetModifierStackCount(stacks_modifier, caster)
		caster:SetModifierStackCount(stacks_modifier, caster, current_charges + 1 )
		if caster:GetModifierStackCount(stacks_modifier, caster) >= max_charges then
			caster:SetModifierStackCount(stacks_modifier, caster, max_charges)
			return
		else
			AphoticShieldStartCooldown(caster, ability, stacks_modifier, max_charges, charge_cooldown, charge_cooldown)
		end
	else
		Timers:CreateTimer(0.03, function()
			AphoticShieldStartCooldown(caster, ability, stacks_modifier, max_charges, charge_cooldown, cooldown - 0.03 )
		end)
	end
end

function AphoticShieldAbsorb( keys )
	local damage = keys.DamageTaken
	local attacker = keys.attacker
	local unit = keys.unit
	local ability = keys.ability

	-- If the attacker is the unit, do nothing
	if attacker == unit then
		return nil
	end
	
	-- Track how much damage was already absorbed by the shield
	local shield_remaining = unit.AphoticShieldRemaining

	if unit:HasModifier("modifier_borrowed_time") == false then
		
		-- If the damage is bigger than what the shield can absorb, heal a portion
		if damage > shield_remaining then
			local health_before = unit:GetHealth()
			unit:Heal(shield_remaining, unit)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, unit, shield_remaining, nil)
			if unit:GetHealth() == health_before then
				unit:SetHealth(unit:GetHealth() + shield_remaining)
			end
		else
			local health_before = unit:GetHealth()
			unit:Heal(damage, unit)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, unit, damage, nil)
			if unit:GetHealth() == health_before then
				unit:SetHealth(unit:GetHealth() + damage)
			end
		end

		-- Reduce the shield remaining and remove
		unit.AphoticShieldRemaining = unit.AphoticShieldRemaining - damage
		if unit.AphoticShieldRemaining <= 0 then
			unit.AphoticShieldRemaining = nil
			unit:RemoveModifierByName("modifier_aphotic_shield")
		end
	end
end

-- Destroys the particle when the modifier is destroyed. Also plays the sound
function EndShieldParticle( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local damageType = DAMAGE_TYPE_MAGICAL

	target:EmitSound("Hero_Abaddon.AphoticShield.Destroy")
	ParticleManager:DestroyParticle(target.ShieldParticle,false)

	-- If ability was unlearned, do nothing
	if not ability then
		return nil
	end

	local ability_level = ability:GetLevel() - 1
	local base_damage_absorb = keys.ability:GetLevelSpecialValueFor("damage_absorb", ability_level )
	local radius = ability:GetLevelSpecialValueFor( "radius" , ability_level )

	local enemies = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	local ability_frostmourne = caster:FindAbilityByName("imba_abaddon_frostmourne")
	local max_stacks = 1
	if ability_frostmourne and ability_frostmourne:GetLevel() ~= 0 then
		max_stacks = ability_frostmourne:GetLevelSpecialValueFor("max_stacks", ability_frostmourne:GetLevel() - 1)
	end
	local modifier_debuff_base = "modifier_imba_frostmourne_debuff_base"
	local modifier_debuff = "modifier_imba_frostmourne_debuff"

	for _,enemy in pairs(enemies) do
		ApplyDamage({ victim = enemy, attacker = caster, damage = base_damage_absorb, damage_type = damageType })
		if enemy:HasModifier(modifier_debuff_base) then
			local stack_count = enemy:GetModifierStackCount(modifier_debuff, ability)

			if stack_count < max_stacks then
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_debuff_base, {})
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_debuff, {})
				enemy:SetModifierStackCount(modifier_debuff, ability, stack_count + 1)
			else
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_debuff_base, {})
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_debuff, {})
			end
		else
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_debuff_base, {})
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_debuff, {})
			enemy:SetModifierStackCount(modifier_debuff, ability, 1)
		end
	end
end

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