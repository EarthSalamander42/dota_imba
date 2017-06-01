--[[
		By: AtroCty
		Prev. Authors: Firetoad
		Date: 27.04.2015
		Updated:  02.04.2017
--]]

CreateEmptyTalents("necrolyte")

-------------------------------------------
--				SADIST
-------------------------------------------

LinkLuaModifier("modifier_imba_sadist", "hero/hero_necrolyte", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sadist_stack", "hero/hero_necrolyte", LUA_MODIFIER_MOTION_NONE)

imba_necrolyte_sadist = imba_necrolyte_sadist or class({})
function imba_necrolyte_sadist:GetIntrinsicModifierName()
    if self:GetCaster():IsRealHero() then return "modifier_imba_sadist" end
	return false
end

function imba_necrolyte_sadist:IsInnateAbility()
	return true
end

modifier_imba_sadist = class({})
function modifier_imba_sadist:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return decFuncs
end

function modifier_imba_sadist:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()	
	self.modifier_sadist = "modifier_imba_sadist_stack"

	-- Ability specials
	self.regen_duration = self.ability:GetSpecialValueFor("regen_duration")	
	self.hero_multiplier = self.ability:GetSpecialValueFor("hero_multiplier")
end



function modifier_imba_sadist:IsHidden()    
	return true
end

function modifier_imba_sadist:OnAttackLanded( params )
	if IsServer() then		

		-- If this is an illusion, do nothing
		if not params.attacker:IsRealHero() then
			return nil
		end

		-- If target has break, do nothing
		if params.attacker:PassivesDisabled() then
			return nil
		end
		
		if self.caster:HasTalent("special_bonus_imba_necrolyte_2") then
			if params.attacker == self.caster and params.target:IsHero() then				

				-- If the caster doesn't have the modifier, add it
				if not self.caster:HasModifier(self.modifier_sadist) then
					self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_sadist_stack", {duration = self.regen_duration})
				end

				-- Increment a stack
				local modifier_sadist_handler = self.caster:FindModifierByName(self.modifier_sadist)
				if modifier_sadist_handler then
					modifier_sadist_handler:IncrementStackCount()
					modifier_sadist_handler:ForceRefresh()
				end
			end
		end		
	end
end

function modifier_imba_sadist:OnDeath(params)
	if IsServer() then
		local unit = params.unit

		if params.attacker == self:GetParent() then
			-- If this is an illusion, do nothing
			if not params.attacker:IsRealHero() then
				return nil
			end

			-- If target has break, do nothing
			if params.attacker:PassivesDisabled() then
				return nil
			end
			
			-- Initialize stacks
			local stacks = 1

			-- If the target was a real hero, increase stack count
			if unit:IsRealHero() then
				stacks = self.hero_multiplier
			end
			
			-- If the caster doesn't have the modifier, add it
			if not self.caster:HasModifier(self.modifier_sadist) then
				self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_sadist_stack", {duration = self.regen_duration})
			end

			-- Increment stacks
			local modifier_sadist_handler = self.caster:FindModifierByName(self.modifier_sadist)
			if modifier_sadist_handler then
				for i = 1, stacks do
					modifier_sadist_handler:IncrementStackCount()
					modifier_sadist_handler:ForceRefresh()
				end
			end
		end
	end
end


modifier_imba_sadist_stack = modifier_imba_sadist_stack or class({})

function modifier_imba_sadist_stack:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent()        

        -- Ability specials
        self.regen_duration = self.ability:GetSpecialValueFor("regen_duration")        
        self.mana_regen = self.ability:GetSpecialValueFor("mana_regen")
        self.health_regen = self.ability:GetSpecialValueFor("health_regen")

        -- Initialize table
        self.stacks_table = {}        

        -- Start thinking
        self:StartIntervalThink(0.1)
    end
end

function modifier_imba_sadist_stack:OnIntervalThink()
    if IsServer() then

        -- Check if there are any stacks left on the table
        if #self.stacks_table > 0 then

            -- For each stack, check if it is past its expiration time. If it is, remove it from the table
            for i = #self.stacks_table, 1, -1 do
                if self.stacks_table[i] + self.regen_duration < GameRules:GetGameTime() then
                    table.remove(self.stacks_table, i)                          
                end
            end
            
            -- If after removing the stacks, the table is empty, remove the modifier.
            if #self.stacks_table == 0 then
                self:Destroy()

            -- Otherwise, set its stack count
            else
                self:SetStackCount(#self.stacks_table)
            end            

        -- If there are no stacks on the table, just remove the modifier.
        else
            self:Destroy()
        end
    end
end

function modifier_imba_sadist_stack:OnRefresh()
    if IsServer() then
        -- Insert new stack values
        table.insert(self.stacks_table, GameRules:GetGameTime())
    end
end

function modifier_imba_sadist_stack:IsHidden() return false end
function modifier_imba_sadist_stack:IsPurgable() return false end
function modifier_imba_sadist_stack:IsDebuff() return false end

function modifier_imba_sadist_stack:DeclareFunctions()
    local decFunc = {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
					 MODIFIER_PROPERTY_MANA_REGEN_CONSTANT}

    return decFunc
end

function modifier_imba_sadist_stack:GetModifierConstantManaRegen()	
	local mana_regen = self.mana_regen + self.caster:FindTalentValue("special_bonus_imba_necrolyte_6")
	return mana_regen * self:GetStackCount()
end

function modifier_imba_sadist_stack:GetModifierConstantHealthRegen()
	local health_regen = self.health_regen + self.caster:FindTalentValue("special_bonus_imba_necrolyte_6")
	return health_regen * self:GetStackCount()
end


-------------------------------------------
--			DEATH PULSE
-------------------------------------------
imba_necrolyte_death_pulse = imba_necrolyte_death_pulse or class({})
function imba_necrolyte_death_pulse:GetCastRange( location , target)
	return self:GetTalentSpecialValueFor("radius")
end

function imba_necrolyte_death_pulse:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		
		-- Parameters
		local radius = self:GetTalentSpecialValueFor("radius")
		local damage = self:GetSpecialValueFor("damage")
		local heal_amp = 1 + (caster:GetSpellPower() * 0.01)
		local base_heal = self:GetSpecialValueFor("base_heal")
		local sec_heal_pct = self:GetSpecialValueFor("sec_heal_pct")
		local enemy_speed = self:GetSpecialValueFor("enemy_speed")
		local ally_speed = self:GetSpecialValueFor("ally_speed")
		
		-- Cast sound
		caster:EmitSound("Hero_Necrolyte.DeathPulse")
		if (math.random(1,100) <= 50) and (caster:GetName() == "npc_dota_hero_necrolyte") then
			caster:EmitSound("necrolyte_necr_ability_tox_0"..math.random(1,3))
		end
		
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			ApplyDamage({attacker = caster, victim = enemy, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
			-- Enemy projectile
			local enemy_projectile = 
			{
				Target = caster,
				Source = enemy,
				Ability = self,
				EffectName = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_enemy.vpcf",
				bDodgeable = false,
				bProvidesVision = false,
				iMoveSpeed = enemy_speed,
				flExpireTime = GameRules:GetGameTime() + 60,
			--	iVisionRadius = vision_radius,
			--	iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				ExtraData = {sec_heal_pct = sec_heal_pct, heal_amp = heal_amp, radius = radius, ally_speed = ally_speed}
			}

			-- Create the projectile
			ProjectileManager:CreateTrackingProjectile(enemy_projectile)
		end
		
		local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,ally in pairs(allies) do
			-- Ally projectile
			local ally_projectile = 
			{
				Target = ally,
				Source = caster,
				Ability = self,
				EffectName = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_friend.vpcf",
				bDodgeable = false,
				bProvidesVision = false,
				iMoveSpeed = ally_speed,
				flExpireTime = GameRules:GetGameTime() + 60,
			--	iVisionRadius = vision_radius,
			--	iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				ExtraData = {base_heal = base_heal, heal_amp = heal_amp}
			}
			-- Create the projectile
			ProjectileManager:CreateTrackingProjectile(ally_projectile)
		end
	end
end

function imba_necrolyte_death_pulse:OnProjectileHit_ExtraData(target, vLocation, extraData)
	if IsServer() then
		local caster = self:GetCaster()
		
		-- Base Heal
		if extraData.base_heal then
			target:Heal((extraData.base_heal * extraData.heal_amp), caster)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, extraData.base_heal * extraData.heal_amp, nil)
			return nil
		end
		
		local caster_loc = caster:GetAbsOrigin()
		
		if not extraData.radius then
			local heal = target:GetMaxHealth() * (extraData.sec_heal_pct / 100) * extraData.heal_amp
			target:Heal(heal, caster)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, heal, nil)
		end
		--Essence dilation
		if extraData.radius then
			local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, extraData.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,ally in pairs(allies) do
				-- Ally projectile
				local ally_projectile = 
				{
					Target = ally,
					Source = caster,
					Ability = self,
					EffectName = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_friend.vpcf",
					bDodgeable = false,
					bProvidesVision = false,
					iMoveSpeed = extraData.ally_speed,
					flExpireTime = GameRules:GetGameTime() + 60,
				--	iVisionRadius = vision_radius,
				--	iVisionTeamNumber = caster:GetTeamNumber(),
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
					ExtraData = {sec_heal_pct = extraData.sec_heal_pct, heal_amp = extraData.heal_amp, ally_speed = extraData.ally_speed}
				}

				-- Create the projectile
				ProjectileManager:CreateTrackingProjectile(ally_projectile)
			end
			return nil
		end
	end
end

function imba_necrolyte_death_pulse:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel ) - self:GetCaster():FindTalentValue("special_bonus_imba_necrolyte_3")
end

-------------------------------------------
--			GHOST SHROUD
-------------------------------------------

imba_necrolyte_ghost_shroud = imba_necrolyte_ghost_shroud or class({})
LinkLuaModifier("modifier_imba_ghost_shroud_aura", "hero/hero_necrolyte", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ghost_shroud_aura_debuff", "hero/hero_necrolyte", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ghost_shroud_aura_purge", "hero/hero_necrolyte", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ghost_shroud_buff", "hero/hero_necrolyte", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ghost_shroud_debuff", "hero/hero_necrolyte", LUA_MODIFIER_MOTION_NONE)

function imba_necrolyte_ghost_shroud:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()

		-- Params
		local duration = self:GetSpecialValueFor("duration")
		local radius = self:GetTalentSpecialValueFor("radius")
		local healing_amp_pct = self:GetSpecialValueFor("healing_amp_pct")
		local slow_pct = self:GetSpecialValueFor("slow_pct")
		
		caster:EmitSound("Hero_Necrolyte.SpiritForm.Cast")
		
		caster:StartGesture(ACT_DOTA_NECRO_GHOST_SHROUD)
		caster:AddNewModifier(caster, self, "modifier_imba_ghost_shroud_aura", { duration = duration, radius = radius, healing_amp_pct = healing_amp_pct, slow_pct = slow_pct})
		caster:AddNewModifier(caster, self, "modifier_imba_ghost_shroud_aura_debuff", { duration = duration, radius = radius, healing_amp_pct = healing_amp_pct, slow_pct = slow_pct})
		caster:AddNewModifier(caster, self, "modifier_imba_ghost_shroud_aura_purge", { duration = duration - FrameTime()})
	end
end

function imba_necrolyte_ghost_shroud:GetCastRange( location , target)
	return self:GetTalentSpecialValueFor("radius")
end

function imba_necrolyte_ghost_shroud:IsHiddenWhenStolen()
	return false
end

modifier_imba_ghost_shroud_aura_purge = modifier_imba_ghost_shroud_aura_purge or class({})
function modifier_imba_ghost_shroud_aura_purge:IsPurgable()
    return true
end

-- Make the aura purgable
function modifier_imba_ghost_shroud_aura_purge:OnRemoved()
	if IsServer() then
		local parent = self:GetParent()
		if parent:HasModifier("modifier_imba_ghost_shroud_aura") then
			parent:RemoveModifierByName("modifier_imba_ghost_shroud_aura")
			parent:RemoveModifierByName("modifier_imba_ghost_shroud_aura_debuff")
		end
	end
end

function modifier_imba_ghost_shroud_aura_purge:IsDebuff()
	return false
end

function modifier_imba_ghost_shroud_aura_purge:IsHidden()
	return true
end

modifier_imba_ghost_shroud_aura = class({})
function modifier_imba_ghost_shroud_aura:OnCreated( params )
	if IsServer() then
		self.radius = params.radius
		self.healing_amp_pct = params.healing_amp_pct
		self.slow_pct = params.slow_pct
	end
end

function modifier_imba_ghost_shroud_aura:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_spirit.vpcf"
end

function modifier_imba_ghost_shroud_aura:StatusEffectPriority()
    return MODIFIER_PRIORITY_ULTRA
end

function modifier_imba_ghost_shroud_aura:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_imba_ghost_shroud_aura:GetAuraEntityReject(target)
    if IsServer() then
        return false
    end
end

function modifier_imba_ghost_shroud_aura:GetAuraRadius()
	return self.radius
end

function modifier_imba_ghost_shroud_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_ghost_shroud_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_ghost_shroud_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_imba_ghost_shroud_aura:GetModifierAura()
	return "modifier_imba_ghost_shroud_buff"
end

function modifier_imba_ghost_shroud_aura:IsAura()
	return true
end

function modifier_imba_ghost_shroud_aura:IsHidden()
	if self:GetParent() == self:GetCaster() then return true end
	return false
end

modifier_imba_ghost_shroud_aura_debuff = modifier_imba_ghost_shroud_aura_debuff or class({})
function modifier_imba_ghost_shroud_aura_debuff:OnCreated( params )
	if IsServer() then
		self.radius = params.radius
		self.healing_amp_pct = params.healing_amp_pct
	end
end

function modifier_imba_ghost_shroud_aura_debuff:GetEffectName()
	return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf"
end

function modifier_imba_ghost_shroud_aura_debuff:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_imba_ghost_shroud_aura_debuff:GetAuraEntityReject(target)
    if IsServer() then
        return false
    end
end

function modifier_imba_ghost_shroud_aura_debuff:GetAuraRadius()
	return self.radius
end

function modifier_imba_ghost_shroud_aura_debuff:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_ghost_shroud_aura_debuff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_ghost_shroud_aura_debuff:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_imba_ghost_shroud_aura_debuff:GetModifierAura()
	return "modifier_imba_ghost_shroud_debuff"
end

function modifier_imba_ghost_shroud_aura_debuff:IsAura()
	return true
end

function modifier_imba_ghost_shroud_aura_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE, }
end

function modifier_imba_ghost_shroud_aura_debuff:CheckState() 
    return 
	{
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}
end

function modifier_imba_ghost_shroud_aura_debuff:GetModifierMagicalResistanceDecrepifyUnique( params )
	return self:GetAbility():GetSpecialValueFor("magic_amp_pct") * (-1)
end

modifier_imba_ghost_shroud_buff = modifier_imba_ghost_shroud_buff or class({})
function modifier_imba_ghost_shroud_buff:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE,
	}
	return decFuncs
end

function modifier_imba_ghost_shroud_buff:GetModifierHealAmplify_Percentage()
	local healing_amp_pct = self:GetAbility():GetSpecialValueFor("healing_amp_pct")
	if self:GetCaster() ~= self:GetParent() then 
		healing_amp_pct = healing_amp_pct / 2
	end
	return healing_amp_pct
end

function modifier_imba_ghost_shroud_buff:GetHealthRegenAmp()
	local healing_amp_pct = self:GetAbility():GetSpecialValueFor("healing_amp_pct")
	if self:GetCaster() ~= self:GetParent() then 
		healing_amp_pct = healing_amp_pct / 2
	end
	return healing_amp_pct
end

function modifier_imba_ghost_shroud_buff:IsDebuff()
	return false
end

function modifier_imba_ghost_shroud_buff:IsHidden()
	if self:GetParent() == self:GetCaster() then return true end
	return false
end

function modifier_imba_ghost_shroud_buff:IsPurgable()
	return true
end

modifier_imba_ghost_shroud_debuff = modifier_imba_ghost_shroud_debuff or class({})
function modifier_imba_ghost_shroud_debuff:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_imba_ghost_shroud_debuff:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return decFuncs
end

function modifier_imba_ghost_shroud_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow_pct") * (-1)
end

function modifier_imba_ghost_shroud_debuff:IsDebuff()
	return true
end

function modifier_imba_ghost_shroud_debuff:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_spirit_debuff.vpcf"
end

function modifier_imba_ghost_shroud_debuff:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_imba_ghost_shroud_debuff:IsPurgable()
	return true
end

-------------------------------------------
--		  HEARTSTOPPER AURA
-------------------------------------------

LinkLuaModifier("modifier_imba_heartstopper_aura", "hero/hero_necrolyte", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_heartstopper_aura_damage", "hero/hero_necrolyte", LUA_MODIFIER_MOTION_NONE)

imba_necrolyte_heartstopper_aura = imba_necrolyte_heartstopper_aura or class({})
function imba_necrolyte_heartstopper_aura:GetIntrinsicModifierName()
    return "modifier_imba_heartstopper_aura"
end

function imba_necrolyte_heartstopper_aura:GetCastRange( location , target)
	return self:GetSpecialValueFor("radius")
end

modifier_imba_heartstopper_aura = class({})
function modifier_imba_heartstopper_aura:OnCreated()
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.damage_pct = self:GetAbility():GetTalentSpecialValueFor("damage_pct")
		if not self.timer then
			self:StartIntervalThink(1)
			self.timer = true
		end
	end
end

function modifier_imba_heartstopper_aura:OnRefresh()
	if IsServer() then
		self:OnCreated()
	end
end

function modifier_imba_heartstopper_aura:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		if not caster:PassivesDisabled() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in ipairs(enemies) do
				local modifier = enemy:FindModifierByNameAndCaster("modifier_imba_heartstopper_aura_damage",caster)
				if modifier then
					-- Calculates damage
					local damage = enemy:GetMaxHealth() * self.damage_pct / 100
					ApplyDamage({attacker = caster, victim = enemy, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS})
					if (math.random(1,1000) <= 2) and (caster:GetName() == "npc_dota_hero_necrolyte") then
						caster:EmitSound("necrolyte_necr_ability_aura_0"..math.random(1,3))
					end
				end
			end
		end
	end
end

function modifier_imba_heartstopper_aura:GetAuraEntityReject(target)
	return false
end

function modifier_imba_heartstopper_aura:GetAuraRadius()
	return self.radius
end

function modifier_imba_heartstopper_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_heartstopper_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_heartstopper_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_heartstopper_aura:GetModifierAura()
	return "modifier_imba_heartstopper_aura_damage"
end

function modifier_imba_heartstopper_aura:IsAura()
	if self:GetCaster():PassivesDisabled() then
		return false
	end
	return true
end

function modifier_imba_heartstopper_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_heartstopper_aura:IsHidden()
	return true
end

function modifier_imba_heartstopper_aura:GetEffectName()
	return "particles/auras/aura_heartstopper.vpcf"
end

function modifier_imba_heartstopper_aura:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

modifier_imba_heartstopper_aura_damage = modifier_imba_heartstopper_aura_damage or class({})
function modifier_imba_heartstopper_aura_damage:IsHidden()
	return false
end

function modifier_imba_heartstopper_aura_damage:IsDebuff()
	return true
end

function modifier_imba_heartstopper_aura_damage:IsPurgable()
	return false
end

function modifier_imba_heartstopper_aura_damage:OnIntervalThink()
	return false
end

function modifier_imba_heartstopper_aura_damage:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE,
	}
	return decFuncs
end

function modifier_imba_heartstopper_aura_damage:GetModifierHealAmplify_Percentage()
	return ( self:GetAbility():GetTalentSpecialValueFor("heal_reduce_pct") * (-1) )
end

function modifier_imba_heartstopper_aura_damage:GetHealthRegenAmp()
	return ( self:GetAbility():GetTalentSpecialValueFor("heal_reduce_pct") * (-1) )
end

-------------------------------------------
--			REAPER'S SCYTHE
-------------------------------------------
imba_necrolyte_reapers_scythe = imba_necrolyte_reapers_scythe or class({})
LinkLuaModifier("modifier_imba_reapers_scythe", "hero/hero_necrolyte", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_reapers_scythe_debuff", "hero/hero_necrolyte", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_reapers_scythe_respawn", "hero/hero_necrolyte", LUA_MODIFIER_MOTION_NONE)

function imba_necrolyte_reapers_scythe:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		
		if target:TriggerSpellAbsorb(self) then
			return nil
		end
		
		-- Cast sound
		caster:EmitSound("Hero_Necrolyte.ReapersScythe.Cast")
		target:EmitSound("Hero_Necrolyte.ReapersScythe.Target")
		if (math.random(1,100) <= 30) and (caster:GetName() == "npc_dota_hero_necrolyte") then
			caster:EmitSound("necrolyte_necr_ability_reap_0"..math.random(1,3))
		end
		
		-- Parameters
		local damage = self:GetSpecialValueFor("damage")
		local stun_duration = self:GetSpecialValueFor("stun_duration")
		
		target:AddNewModifier(caster, self, "modifier_imba_reapers_scythe", {duration = stun_duration+FrameTime(), damage = damage})
	end
end

function imba_necrolyte_reapers_scythe:GetCooldown( nLevel )
	if self:GetCaster():HasScepter() then return self:GetSpecialValueFor("scepter_cooldown") end
	return self.BaseClass.GetCooldown( self, nLevel )
end

function imba_necrolyte_reapers_scythe:IsHiddenWhenStolen()
	return false
end

modifier_imba_reapers_scythe = modifier_imba_reapers_scythe or class({})
function modifier_imba_reapers_scythe:IgnoreTenacity() return true end
function modifier_imba_reapers_scythe:OnCreated( params )
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		self.ability = self:GetAbility()
		self.damage = params.damage
		Timers:CreateTimer(self:GetRemainingTime()-FrameTime(), function()
			-- Calculates damage
			if target:IsAlive() and self.ability then
				self.damage = self.damage * (target:GetMaxHealth() - target:GetHealth())
				-- Deals damage
				target:AddNewModifier(self:GetCaster(), self.ability, "modifier_imba_reapers_scythe_respawn", {duration = 2*FrameTime()})
				ApplyDamage({attacker = caster, victim = target, ability = self.ability, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, self.damage, nil)
				self:Destroy()
			end
		end)
		local stun_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_stunned.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
		self:AddParticle(stun_fx,false,false,-1,false,false)
		local orig_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_orig.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		self:AddParticle(orig_fx,false,false,-1,false,false)
		
		local scythe_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(scythe_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(scythe_fx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(scythe_fx)
	end
end

function modifier_imba_reapers_scythe:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf"
end

function modifier_imba_reapers_scythe:StatusEffectPriority()
    return MODIFIER_PRIORITY_ULTRA
end

function modifier_imba_reapers_scythe:GetPriority()
    return MODIFIER_PRIORITY_ULTRA
end

function modifier_imba_reapers_scythe:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_reapers_scythe:CheckState()
	local state = 
	{
		[MODIFIER_STATE_STUNNED] = true
	}
	return state
end

function modifier_imba_reapers_scythe:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_reapers_scythe:IsPurgable() return false end
function modifier_imba_reapers_scythe:IsPurgeException() return false end



function modifier_imba_reapers_scythe:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_EVENT_ON_DEATH,
	}
	return decFuncs
end

function modifier_imba_reapers_scythe:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_imba_reapers_scythe:OnDeath( params )
	if params.unit == self:GetParent() then
		if self.ability and params.inflictor then
			if self.ability == params.inflictor then
				params.unit:FindModifierByName("modifier_imba_reapers_scythe_respawn"):SetDuration(-1,true)
			end
		end
	end
	return true
end

function modifier_imba_reapers_scythe:OnRemoved()
	if self.ability then
		if self.ability.ghost_death then
			self.ability.ghost_death = nil
			self:GetParent():AddNewModifier(self:GetCaster(), self.ability, "modifier_imba_reapers_scythe_respawn", {})
		end
	end
end

-------------------------------------------
modifier_imba_reapers_scythe_respawn = modifier_imba_reapers_scythe_respawn or class({})
function modifier_imba_reapers_scythe_respawn:OnCreated()
	if IsServer() then
		self.ability = self:GetAbility()
		if self.ability then
			self.respawn_increase = self.ability:GetSpecialValueFor("respawn_increase")
		end
	end
end

function modifier_imba_reapers_scythe_respawn:RespawnTimeStacking()
	return self.respawn_increase
end

function modifier_imba_reapers_scythe_respawn:IsHidden()
	return true
end

function modifier_imba_reapers_scythe_respawn:IsPurgable()
	return false
end

function modifier_imba_reapers_scythe_respawn:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_reapers_scythe_respawn:IsDebuff()
	return true
end

function modifier_imba_reapers_scythe_respawn:RemoveOnDeath()
	return false
end

function modifier_imba_reapers_scythe_respawn:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_EVENT_ON_RESPAWN,
	}
	return decFuncs	
end

function modifier_imba_reapers_scythe_respawn:OnRespawn( params )
	if IsServer() then
		if (self:GetParent() == params.unit) then
			if self.ability then
				local debuff_duration = self.ability:GetSpecialValueFor("debuff_duration")
				params.unit:AddNewModifier(params.unit, self.ability, "modifier_imba_reapers_scythe_debuff", {duration = debuff_duration})
			end
			self:Destroy()
		end
	end
end

modifier_imba_reapers_scythe_debuff = modifier_imba_reapers_scythe_debuff or class({})

function modifier_imba_reapers_scythe_debuff:GetStatusEffectName()
	return "particles/hero/necrophos/status_effect_reaper_scythe_sickness.vpcf"
end

function modifier_imba_reapers_scythe_debuff:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
	return decFuncs	
end

function modifier_imba_reapers_scythe_debuff:OnCreated( params )
	local ability = self:GetAbility()
	self.damage_reduction_pct = ability:GetTalentSpecialValueFor("damage_reduction_pct") * (-1)
	self.spellpower_reduction = ability:GetTalentSpecialValueFor("spellpower_reduction") * (-1)
end

function modifier_imba_reapers_scythe_debuff:IsDebuff()
	return true
end

function modifier_imba_reapers_scythe_debuff:IsPurgable()
	return false
end

function modifier_imba_reapers_scythe_debuff:GetModifierSpellAmplify_Percentage()
	return self.spellpower_reduction
end

function modifier_imba_reapers_scythe_debuff:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage_reduction_pct
end