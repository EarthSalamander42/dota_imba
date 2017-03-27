--[[	Author: Broccoli
		Date: 26-3-2017		]]

CreateEmptyTalents("abaddon")

-- Reference of curse of avernus ability to pull values at level 1 (required for nether ward and rubick)
local _curse_of_avernus_reference = nil

function getCurseOfAvernusDummyReference()
	if IsServer() and _curse_of_avernus_reference == nil then
		local abaddon_dummy = CreateUnitByName('npc_dummy_unit', Vector(0,0,0), false, nil, nil, DOTA_TEAM_NOTEAM )
		_curse_of_avernus_reference = abaddon_dummy:AddAbility("imba_abaddon_curse_of_avernus")
		_curse_of_avernus_reference:SetLevel(1)
		print("created dummy for curse of avernus reference")
	end

	return _curse_of_avernus_reference
end


function getOverChannelIncrease(caster)
	if caster:HasModifier("modifer_over_channel_caster") then
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

imba_abaddon_mist_coil = class({})

function imba_abaddon_mist_coil:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		caster:EmitSound("Hero_Abaddon.DeathCoil.Cast")

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

        if target:GetTeam() ~= caster:GetTeam() then
			-- If target has Linken Sphere, block effect entirely
            if target:TriggerSpellAbsorb(self) then
                return nil
            end

			local damage = self:GetLevelSpecialValueFor("damage", ability_level) + getOverChannelIncrease(caster)
			local damage_type = DAMAGE_TYPE_MAGICAL

			ApplyDamage({ victim = target, attacker = caster, damage = damage,	damage_type = damage_type })
			
			-- Apply curse of avernus debuff
			local curse_of_avernus = caster:FindAbilityByName("imba_abaddon_curse_of_avernus")
			
			if not curse_of_avernus then
				curse_of_avernus = getCurseOfAvernusDummyReference()
			end

			local debuff_duration = curse_of_avernus:GetSpecialValueFor("debuff_duration")

			-- debuff_duration can be 0 if caster has ability but not learnt it yet
			if debuff_duration > 0 then
				target:AddNewModifier(caster, curse_of_avernus, "modifier_imba_curse_of_avernus_debuff", { duration = debuff_duration })
			end

		else
			local heal = self:GetLevelSpecialValueFor("heal", ability_level) + getOverChannelIncrease(caster)

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
	-- #1 Talent: +150 Aphotic Shield cast range
	return self:GetSpecialValueFor("cast_range") + self:GetCaster():FindTalentValue("special_bonus_imba_abaddon_1")
end

function imba_abaddon_aphotic_shield:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		-- Play Sound
		caster:EmitSound("Hero_Abaddon.AphoticShield.Cast")

		-- Strong Dispel
		target:Purge(false, true, false, true, false)

		local modifier_name_aphotic_shield = "modifier_aphotic_shield_buff"

		-- Remove previous aphotic shield
		-- Did not use RemoveModifierByNameAndCaster because it will not destroy the shield if it was stolen by rubick from another rubick who stole from abaddon
		target:RemoveModifierByName(modifier_name_aphotic_shield)

		-- #2 Talent: +45sec duration on Aphotic Shield
		local duration = self:GetSpecialValueFor("duration") + caster:FindTalentValue("special_bonus_imba_abaddon_2")
		-- Add new modifier
		target:AddNewModifier(caster, self, modifier_name_aphotic_shield, { duration = duration })
	end
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
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local shield_size = target:GetModelRadius() * 0.7
		local ability = self:GetAbility()
		local ability_level = ability:GetLevel()

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
		ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

		--void AddParticle(int i, bool bDestroyImmediately, bool bStatusEffect, int iPriority, bool bHeroEffect, bool bOverheadEffect)
		self:AddParticle(particle, false, false, -1, false, false)

		self:StartIntervalThink( 0.03 )
	end
end

function modifier_aphotic_shield_buff:OnRemoved()
	if IsServer() then
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
				enemy:AddNewModifier(caster, curse_of_avernus, "modifier_imba_curse_of_avernus_debuff", { duration = debuff_duration })
			end
		end
	end
end

function modifier_aphotic_shield_buff:OnTakeDamage(kv)
	if IsServer() then
		local target = self:GetParent()

		-- Absorb damage taken by unit which has this buff
		if target == kv.unit then
			-- Avoid calculation when borrowed time is active
			if target:HasModifier("modifier_borrowed_time_caster_buff") == false then
				local caster = self:GetCaster()
				local damage = kv.damage
				local shield_remaining = self.shield_remaining
				local set_to_health

				-- If the damage is bigger than what the shield can absorb, heal a portion
				-- Heal can fail due to modifiers preventing heal, set unit's health instead
				local damage_block_amount
				if damage > shield_remaining then
					damage_block_amount = shield_remaining
					set_to_health = self.target_current_health - damage + shield_remaining
				else
					damage_block_amount = damage
					set_to_health = self.target_current_health
				end
				-- Show effect of damage blocked
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, damage_block_amount, nil)
				
				-- Note that we did not use GetHealth() here because it will ignore the health regen, which will sometimes cause health to decrease by 1
				target:SetHealth(set_to_health)

				self.shield_remaining = shield_remaining - damage
				if self.shield_remaining <= 0 then
					target:RemoveModifierByName("modifier_aphotic_shield_buff")
				end
			end
		end
	end
end

function modifier_aphotic_shield_buff:OnIntervalThink()
	self.target_current_health = self:GetParent():GetHealth()
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

		-- Do not apply curse if avernus if "break"
		if not caster:PassivesDisabled() then

			local attacker = kv.attacker

			if attacker == caster then

				local target = kv.target

				-- Apply curse of avernus to enemies
				if target:GetTeamNumber() ~= caster:GetTeamNumber() then
					-- Apply debuff if enemy
					local ability = self:GetAbility()
					local debuff_duration = ability:GetSpecialValueFor("debuff_duration") -- Not possible for this to be 0 here
					target:AddNewModifier(caster, ability, "modifier_imba_curse_of_avernus_debuff", { duration = debuff_duration })
				end
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
		self.heal_convert = ability:GetLevelSpecialValueFor("heal_convert", ability_level)
	end
end

function modifier_imba_curse_of_avernus_debuff:OnCreated()
	self:_UpdateSlowValues()

	if IsServer() then
		local caster = self:GetCaster()

		-- Give caster the buff immediately, else caster has to hit target again to gain the buff
		local buff_name = "modifier_imba_curse_of_avernus_buff"
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

		local target 	= kv.target

		-- Apply buff to allies who hit the enemy with this debuff
		if target == self:GetParent() then
			local caster 	= self:GetCaster()
			local attacker 	= kv.attacker

			if caster:GetTeamNumber() == attacker:GetTeamNumber() then
				local ability = self:GetAbility()
				local buff_duration = ability:GetSpecialValueFor( "buff_duration" )

				if buff_duration > 0 then
					attacker:AddNewModifier(caster, ability, "modifier_imba_curse_of_avernus_buff", { duration = buff_duration })
				end
			end
		end
	end
end

function modifier_imba_curse_of_avernus_debuff:OnTakeDamage(kv)
	
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

				-- TODO show heal animation on caster
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, heal_amount, nil)
				-- Heal caster equal to a percentage of damage taken by unit affected by this debuff
				caster:Heal(heal_amount, caster)

				if caster:HasModifier("modifier_borrowed_time_caster_buff") then
					local buffed_allies = caster._borrowed_time_buffed_allies
					-- Aghanim heal allies
					if buffed_allies and HasScepter(caster) then
						for k,_ in pairs(buffed_allies) do
							--TODO show heal animation on allies
							k:Heal(heal_amount, caster)
						end
					end
				end
			end
		end
	end
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
		local caster = self:GetCaster()
		local ability_level = ability:GetLevel() - 1

		-- #4 Talent: +5% move speed/+30 attack speed on Curse of Avernus
		local talent_name = "special_bonus_imba_abaddon_4"
		local move_increase_name = "move_increase"
		local attack_increase_name = "attack_increase"
		self.move_increase = ability:GetSpecialValueFor( move_increase_name ) + caster:FindSpecificTalentValue( talent_name, move_increase_name )
		self.attack_increase = ability:GetLevelSpecialValueFor( attack_increase_name , ability_level) + caster:FindSpecificTalentValue( talent_name, attack_increase_name )
	end
end

function modifier_imba_curse_of_avernus_buff:OnCreated()
	if IsServer() then
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

imba_abaddon_over_channel = class({
	IsStealable 			= function(self) return false end,
	ResetToggleOnRespawn 	= function(self) return false end,
})
LinkLuaModifier("modifer_over_channel_caster", "hero/hero_abaddon", LUA_MODIFIER_MOTION_NONE)

function imba_abaddon_over_channel:OnToggle()
	local caster 		= self:GetCaster()
	local modifier_name = "modifer_over_channel_caster"
	if self:GetToggleState() then
		--TODO
		caster:AddNewModifier(caster, self, modifier_name, {})
	else
		--TODO
		caster:RemoveModifierByName( modifier_name )
	end
end

-- TODO attach effect
modifer_over_channel_caster = class({
	IsHidden				= function(self) return true end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
	RemoveOnDeath			= function(self) return false end
})

-----------------------------
--       Borrowed Time     --
-----------------------------
imba_abaddon_borrowed_time = class({
	GetIntrinsicModifierName = function(self) return "modifer_borrowed_time_caster_auto_cast" end
})
LinkLuaModifier("modifer_borrowed_time_caster_auto_cast", "hero/hero_abaddon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_borrowed_time_caster_buff", "hero/hero_abaddon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_borrowed_time_allies_buff", "hero/hero_abaddon", LUA_MODIFIER_MOTION_NONE)

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
		caster:AddNewModifier(caster, self, "modifier_borrowed_time_caster_buff", { duration = buff_duration })
	end
end

modifer_borrowed_time_caster_auto_cast = class({
	IsHidden				= function(self) return true end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
})

function modifer_borrowed_time_caster_auto_cast:_CheckHealth(damage)
	-- TODO check if this triggers
	local target = self:GetParent()
	local ability = self:GetAbility()

	-- Check state
	if ability:IsCooldownReady() and not target:IsSilenced() and not target:IsHexed() then
		local hp_threshold = self.hp_threshold
		local current_hp = target:GetHealth() - damage
		if current_hp < hp_threshold then
			-- TODO check if this prevents death, else we will need to set the health here
			target:CastAbilityImmediately(ability, target:GetPlayerID())
		end
	end
end

function modifer_borrowed_time_caster_auto_cast:OnCreated()
	if IsServer() then
		self.hp_threshold = ability:GetSpecialValueFor("hp_threshold")

		-- Check if we need to auto cast immediately
		self:_CheckHealth(0)
	end
end

function modifer_borrowed_time_caster_auto_cast:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_STATE_CHANGED
	}
 
	return funcs
end

function modifer_borrowed_time_caster_auto_cast:OnTakeDamage(kv)
	
	if IsServer() then
		local target = self:GetParent()

		if target == kv.unit and _IsValidAutoCastState() then
			-- Auto cast borrowed time if damage will bring target to lower than hp_threshold
			self:_CheckHealth(kv.damage)
		end
	end
	
end

function modifer_borrowed_time_caster_auto_cast:OnStateChanged(kv)
	-- Trigger borrowed time if health below hp_threshold after silence/hex
	if IsServer() then
		-- TODO check if this triggers
		-- TODO ensure only check if state is for the parent
		self:_CheckHealth(0)
	end
end

modifier_borrowed_time_caster_buff = class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
	IsAura					= function(self) return true end,
	IsAuraActiveOnDeath		= function(self) return false end,
	GetModifierAura			= function(self) return "modifier_borrowed_time_allies_buff" end,
	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO end,
	GetAuraSearchTeam		= function(self) return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
	GetEffectName			= function(self) return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf" end,
	GetEffectAttachType		= function(self) return PATTACH_ABSORIGIN_FOLLOW end,
	GetStatusEffectName		= function(self) return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf" end,
	StatusEffectPriority	= function(self) return 15 end,
})

function modifier_borrowed_time_caster_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
 
	return funcs
end

function modifier_borrowed_time_caster_buff:GetAuraRadius()
	-- #8 Talent: +300 aura range on Borrowed Time
	return self:GetAbility():GetSpecialValueFor("redirect_range") + self:GetCaster():FindTalentValue("special_bonus_imba_abaddon_8")
end

function modifier_borrowed_time_caster_buff:GetAuraEntityReject(hEntity)
	-- Do not apply aura to target
	return hEntity == self:GetParent()
end

function modifier_borrowed_time_caster_buff:OnCreated()
	if IsServer() then
		local target = self:GetParent()

		self.target_current_health = target:GetHealth()

		-- Create/Reset list to keep track of allies affected by buff
		target._borrowed_time_buffed_allies = {}

		-- Play Sound
		target:EmitSound("Hero_Abaddon.BorrowedTime")

		-- Strong Dispel
		target:Purge(false, true, false, true, false)

		self:StartIntervalThink( 0.03 )
	end	
end

function modifier_borrowed_time_caster_buff:OnIntervalThink()
	self.target_current_health = self:GetParent():GetHealth()
end

function modifier_borrowed_time_caster_buff:OnTakeDamage(kv)
	if IsServer() then
		-- Ignore damage and convert to healing
		local target = self:GetParent()

		if target == kv.unit then
			local damage = kv.damage

			-- TODO Account for rapier damage amplification?

			-- Block incoming damage
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, damage, nil)
			target:SetHealth(self.target_current_health)

			-- Heal blocked damage
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, damage, nil)
			target:Heal(damage, target)
		end
	end
end

modifier_borrowed_time_allies_buff = class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
})

function modifier_borrowed_time_allies_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
 
	return funcs
end

function modifier_borrowed_time_allies_buff:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local buff_list = caster._borrowed_time_buffed_allies
		if buff_list then
			buff_list[self:GetParent()] = true
		end
	end
end

function modifier_borrowed_time_allies_buff:OnRemoved()
	if IsServer() then
		local caster = self:GetCaster()
		local buff_list = caster._borrowed_time_buffed_allies
		if buff_list then
			buff_list[self:GetParent()] = nil
		end
	end
end

function modifier_borrowed_time_allies_buff:OnTakeDamage(kv)
	if IsServer() then
		local target = self:GetParent()

		-- Works for illusions as well
		if target == kv.unit then
			local caster = self:GetCaster()
			local ability = self:GetAbility()
			local ability_level = ability:GetLevel()
			local redirect = ability:GetLevelSpecialValueFor("redirect", ability_level)
			local damage = kv.damage
			local attacker = kv.attacker

			-- TODO Account for rapier damage amplification?

			-- Redirect damage to caster (which should heal when caster takes damage)
			local redirect_damage = damage * redirect
			-- TODO create link effect
			target:SetHealth(target:GetHealth() + redirect_damage)
			-- Redirect as pure damage else it will be reduced again by armour/magic resistance
			ApplyDamage({ victim = caster, attacker = attacker, damage = redirect_damage, damage_type = DAMAGE_TYPE_PURE })
		end
		
	end
	
end