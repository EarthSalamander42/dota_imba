--[[	
		Author: AtroCty
		Date: 07.03.2015
		Updated: 09.03.2017
  ]]

-------------------------------------------
--			  MANA BREAK
-------------------------------------------

imba_antimage_mana_break = class({})
LinkLuaModifier("modifier_imba_antimage_mana_break", "hero/hero_antimage", LUA_MODIFIER_MOTION_NONE)

function imba_antimage_mana_break:GetIntrinsicModifierName()
	return "modifier_imba_antimage_mana_break"
end

-- Mana break modifier
modifier_imba_antimage_mana_break = class({})

function modifier_imba_antimage_mana_break:IsHidden()
	return true
end

function modifier_imba_antimage_mana_break:IsPurgable()
	return false
end

function modifier_imba_antimage_mana_break:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_ATTACK_START,
						  MODIFIER_EVENT_ON_ATTACK_LANDED,
						  MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE}
		return decFuncs	
end

function modifier_imba_antimage_mana_break:OnCreated()
	if IsServer() then
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		
		self.damage_per_burn = self.ability:GetSpecialValueFor("damage_per_burn")
		self.base_mana_burn = self.ability:GetSpecialValueFor("base_mana_burn")
		self.bonus_mana_burn = self.ability:GetSpecialValueFor("bonus_mana_burn")
		self.illusion_factor = self.ability:GetSpecialValueFor("illusion_factor")
	end
end

function modifier_imba_antimage_mana_break:OnRefresh()
	if IsServer() then
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		
		self.damage_per_burn = self.ability:GetSpecialValueFor("damage_per_burn")
		self.base_mana_burn = self.ability:GetSpecialValueFor("base_mana_burn")
		self.bonus_mana_burn = self.ability:GetSpecialValueFor("bonus_mana_burn")
		self.illusion_factor = self.ability:GetSpecialValueFor("illusion_factor")
	end
end

function modifier_imba_antimage_mana_break:OnAttackStart(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target
		
		-- If target has break, do nothing
		if attacker:PassivesDisabled() then
			return nil
		end
		
		-- If there isn't a valid target, do nothing
		if target:GetMaxMana() == 0 or target:IsMagicImmune() then
			return nil
		end
		
		-- Only apply on caster attacking enemies
		if self.parent == attacker and target:GetTeamNumber() ~= self.parent:GetTeamNumber() then
			
			-- Calculate mana to burn
			local target_mana_burn = target:GetMana()
			if (target_mana_burn > self.base_mana_burn) then
				target_mana_burn = self.base_mana_burn
			end
			
			self.add_damage = target_mana_burn * self.damage_per_burn
			
			-- Talent 3 - % of missing mana as extra-dmg
			if attacker:HasTalent("special_bonus_imba_antimage_4") then
				self.add_damage = self.add_damage + (( (target:GetMaxMana() - target:GetMana() + target_mana_burn) * ( (attacker:FindTalentValue("special_bonus_imba_antimage_4")) / 100)) * self.damage_per_burn)
			end
		end
	end
end

function modifier_imba_antimage_mana_break:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target
		
		-- If target has break, do nothing
		if attacker:PassivesDisabled() then
			return nil
		end
		
		-- If there isn't a valid target, do nothing
		if target:GetMaxMana() == 0 or target:IsMagicImmune() then
			return nil
		end
		
		-- Only apply on caster attacking enemies
		if self.parent == attacker and target:GetTeamNumber() ~= self.parent:GetTeamNumber() then

			-- Play sound
			target:EmitSound("Hero_Antimage.ManaBreak")
			
			-- Add hit particle effects
			local manaburn_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(manaburn_pfx, 0, target:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex(manaburn_pfx)
			
			-- Calculate and burn mana
			local target_mana_burn = target:GetMana()
			if (target_mana_burn > self.base_mana_burn) then
				target_mana_burn = self.base_mana_burn
			end
			target:ReduceMana(target_mana_burn)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, target, target_mana_burn, nil)
		end
	end
end

function modifier_imba_antimage_mana_break:GetModifierBaseAttack_BonusDamage(params)
	if IsServer() then
		return self.add_damage
	end
end

-------------------------------------------
--			 BLINK
-------------------------------------------

imba_antimage_blink = class({})

-- Talent reducing cast point
function imba_antimage_blink:OnAbilityPhaseStart()
	if IsServer() then
		local caster = self:GetCaster()
		if ( caster:HasTalent("special_bonus_imba_antimage_3") ) and (not self.cast_point) then
			self.cast_point = true
			local cast_point = self:GetCastPoint()
			cast_point = cast_point - caster:FindTalentValue("special_bonus_imba_antimage_3")
			self:SetOverrideCastPoint(cast_point)
		end
		return true
	end
end

-- Talent reducing CD + CDR
function imba_antimage_blink:GetCooldown( nLevel )
	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
	local caster = self:GetCaster()
	if caster:HasTalent("special_bonus_imba_antimage_1") then
		cooldown = cooldown - caster:FindTalentValue("special_bonus_imba_antimage_1")
	end
	return cooldown
end

function imba_antimage_blink:OnSpellStart()
	if IsServer() then
		-- Declare variables
		local caster = self:GetCaster()
		local caster_position = caster:GetAbsOrigin()
		local target_point = self:GetCursorPosition()
		
		local distance = target_point - caster_position
		
		self.blink_range = self:GetSpecialValueFor("blink_range")
		self.percent_mana_burn = self:GetSpecialValueFor("percent_mana_burn")
		if caster:HasTalent("special_bonus_imba_antimage_1") then
			self.percent_mana_burn = self.percent_mana_burn + caster:FindTalentValue("special_bonus_imba_antimage_5")
		end
		self.percent_damage = self:GetSpecialValueFor("percent_damage")
		self.radius = self:GetSpecialValueFor("radius")
		
		-- Range-check
		if distance:Length2D() > self.blink_range then
			target_point = caster_position + (target_point - caster_position):Normalized() * self.blink_range
		end
		
		-- Disjointing everything
		ProjectileManager:ProjectileDodge(caster)
		
		-- Blink particles/sound on starting point
		local blink_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:ReleaseParticleIndex(blink_pfx)
		caster:EmitSound("Hero_Antimage.Blink_out")

		
		-- Adding an extreme small timer for the particles, else they will only appear at the dest
		Timers:CreateTimer(0.01, function()
			-- Move hero
			caster:SetAbsOrigin(target_point)
			FindClearSpaceForUnit(caster, target_point, true)
		
			-- Create Particle/sound on end-point
			local blink_end_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_blink_end.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:ReleaseParticleIndex(blink_end_pfx)
			caster:EmitSound("Hero_Antimage.Blink_in")
			
			-- Manaburn-Nova
			if not ( self.percent_mana_burn == 0) then
				
				-- Make a damage particle
				local mananova_pfx = ParticleManager:CreateParticle("particles/hero/antimage/blink_manaburn_basher_ti_5.vpcf", PATTACH_POINT, caster)
				ParticleManager:SetParticleControl(mananova_pfx, 0, caster:GetAbsOrigin() )
				ParticleManager:SetParticleControl(mananova_pfx, 1, Vector((self.radius * 2),1,1))
				ParticleManager:ReleaseParticleIndex(mananova_pfx)
				
				local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _,enemy in pairs(nearby_enemies) do
					-- Calculate this enemy's damage contribution
					local mana_burn = enemy:GetMana() * (self.percent_mana_burn / 100)
					-- only continue if target has mana
					if mana_burn > 0 then
						local this_enemy_damage = mana_burn * (self.percent_damage / 100)
						
						-- Add hit particle effects
						local manaburn_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
						ParticleManager:SetParticleControl(manaburn_pfx, 0, enemy:GetAbsOrigin() )
						ParticleManager:ReleaseParticleIndex(manaburn_pfx)
						
						-- Deal damage and burn mana			
						local damageTable = {victim = enemy,
											damage = this_enemy_damage,
											damage_type = DAMAGE_TYPE_MAGICAL,
											attacker = caster,
											ability = self
											}
						ApplyDamage(damageTable)
						enemy:ReduceMana(mana_burn)
						SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, enemy, mana_burn, nil)
					end
				end
			end
		end)
	end
end

function imba_antimage_blink:IsHiddenWhenStolen()
    return false
end

-------------------------------------------
--			SPELL SHIELD
-------------------------------------------

imba_antimage_spell_shield = class({})
LinkLuaModifier("modifier_imba_antimage_spell_shield_passive", "hero/hero_antimage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_antimage_spell_shield_active", "hero/hero_antimage", LUA_MODIFIER_MOTION_NONE)

-- Declare active skill + visuals
function imba_antimage_spell_shield:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self
		local active_modifier = "modifier_imba_antimage_spell_shield_active"
		self.duration = ability:GetSpecialValueFor("active_duration")


		-- Start skill cooldown.
		caster:AddNewModifier(caster, ability, active_modifier, {duration = self.duration})
		
		-- Run visual + sound
		local shield_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_blink_end_glow.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(shield_pfx)
		caster:EmitSound("Hero_Antimage.SpellShield.Block")
	end	
end

-- Magic resistence modifier
function imba_antimage_spell_shield:GetIntrinsicModifierName()
	return "modifier_imba_antimage_spell_shield_passive"
end

function imba_antimage_spell_shield:GetCooldown( nLevel )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "cooldown_scepter" )
	end
	return self.BaseClass.GetCooldown( self, nLevel )
end

function imba_antimage_spell_shield:IsHiddenWhenStolen()
    return false
end

modifier_imba_antimage_spell_shield_passive = class({})

function modifier_imba_antimage_spell_shield_passive:IsHidden()
	return true
end

function modifier_imba_antimage_spell_shield_passive:IsDebuff()
	return false
end

function modifier_imba_antimage_spell_shield_passive:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
						  MODIFIER_PROPERTY_ABSORB_SPELL,
						  MODIFIER_PROPERTY_REFLECT_SPELL}
		return decFuncs	
end

function modifier_imba_antimage_spell_shield_passive:OnCreated()
	if IsServer() then
		self.duration = self:GetAbility():GetSpecialValueFor("active_duration")
		self.magic_resistance = self:GetAbility():GetSpecialValueFor("magic_resistance")
		self:GetParent().tOldSpells = {}
        self:StartIntervalThink(0.5)
	end
end

function modifier_imba_antimage_spell_shield_passive:OnRefresh()
	if IsServer() then
		self.duration = self:GetAbility():GetSpecialValueFor("active_duration")
		self.magic_resistance = self:GetAbility():GetSpecialValueFor("magic_resistance")
	end
end

function modifier_imba_antimage_spell_shield_passive:GetModifierMagicalResistanceBonus(params)
	if IsServer() then
		return self.magic_resistance
	end
end

function modifier_imba_antimage_spell_shield_passive:GetReflectSpell( params )
	if IsServer() then
		local caster = self:GetParent()
		if ( caster:HasScepter() ) and ( self:GetAbility():IsCooldownReady() ) then
			-- If some spells shouldn't be reflected, enter it into this spell-list
			local exception_spell = 
			{
				["EXAMPLE1"] = true,
				["EXAMPLE2"] = true,
			}
			
			local reflected_spell_name = params.ability:GetAbilityName()
			local target = params.ability:GetCaster()
			
			if ( not exception_spell[reflected_spell_name] ) and (not target:HasModifier("modifier_imba_antimage_spell_shield_active") ) then
				local ability
				
				local reflect_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControlEnt(reflect_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(reflect_pfx)
				
				if self:HasSpell(reflected_spell_name) then
					ability = caster:FindAbilityByName(reflected_spell_name)
				else
					ability = caster:AddAbility(reflected_spell_name)
					ability:SetStolen(true)
					ability:SetHidden(true)
					
					-- Modifier counter, and add it into the old-spell list
					ability:SetRefCountsModifiers(true)
					table.insert(caster.tOldSpells, ability)
				end
				
				ability:SetLevel(params.ability:GetLevel())
				-- Set target & fire spell
				caster:SetCursorCastTarget(target)
				ability:OnSpellStart()
				target:EmitSound("Hero_Antimage.SpellShield.Reflect")
			end
			return false
		end
	end
end

function modifier_imba_antimage_spell_shield_passive:GetAbsorbSpell( params )
	if IsServer() then
		local caster = self:GetCaster()
		if ( caster:HasScepter() ) and ( self:GetAbility():IsCooldownReady() ) then
			local ability = self:GetAbility()
			local active_modifier = "modifier_imba_antimage_spell_shield_active"
			self.duration = ability:GetSpecialValueFor("active_duration")

			-- Start skill cooldown.
			caster:AddNewModifier(caster, ability, active_modifier, {duration = self.duration})
			ability:StartCooldown( (ability:GetCooldown(ability:GetLevel()-1) * GetCooldownReduction(self:GetCaster()) ) )
			
			local reflect_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(reflect_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true)
			ParticleManager:ReleaseParticleIndex(reflect_pfx)
			return 1
		end
		return false
	end
end

-- Reflect modifier
-- Biggest thanks to Yunten !
modifier_imba_antimage_spell_shield_active = class({})

function modifier_imba_antimage_spell_shield_active:IsHidden()
	return false
end

function modifier_imba_antimage_spell_shield_active:IsDebuff()
	return false
end

function modifier_imba_antimage_spell_shield_active:IsPurgable()
    return false
end

function modifier_imba_antimage_spell_shield_active:DeclareFunctions()	
		local decFuncs = {
			MODIFIER_PROPERTY_ABSORB_SPELL,
			MODIFIER_PROPERTY_REFLECT_SPELL
						 }
		return decFuncs
end

-- Initialize old-spell-checker
function modifier_imba_antimage_spell_shield_active:OnCreated( params )
    if IsServer() then

    end
end

function modifier_imba_antimage_spell_shield_active:GetReflectSpell( params )
	if IsServer() then
		-- If some spells shouldn't be reflected, enter it into this spell-list
		local exception_spell = 
		{
			["rubick_spell_steal"] = true,
			["EXAMPLE2"] = true,
		}
		
		local reflected_spell_name = params.ability:GetAbilityName()
		local target = params.ability:GetCaster()
		
		if ( not exception_spell[reflected_spell_name] ) and (not target:HasModifier("modifier_imba_antimage_spell_shield_active") ) then
			local caster = self:GetParent()
			local ability
			
			local reflect_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(reflect_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(reflect_pfx)
			
			if self:HasSpell(reflected_spell_name) then
				ability = caster:FindAbilityByName(reflected_spell_name)
			else
				ability = caster:AddAbility(reflected_spell_name)
				ability:SetStolen(true)
				ability:SetHidden(true)
				
				-- Modifier counter, and add it into the old-spell list
				ability:SetRefCountsModifiers(true)
				table.insert(caster.tOldSpells, ability)
			end
			
			ability:SetLevel(params.ability:GetLevel())
			-- Set target & fire spell
			caster:SetCursorCastTarget(target)
			ability:OnSpellStart()
			target:EmitSound("Hero_Antimage.SpellShield.Reflect")
		end
		return false
	end
end

function modifier_imba_antimage_spell_shield_active:GetAbsorbSpell( params )
	if IsServer() then
		-- Run visual + sound
		local caster = self:GetParent()
		local reflect_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(reflect_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true)
		ParticleManager:ReleaseParticleIndex(reflect_pfx)
		return 1
	end
end

-- Deleting old abilities
-- This is bound to the passive modifier, so this is constantly on!
function modifier_imba_antimage_spell_shield_passive:OnIntervalThink()
    if IsServer() then
		local caster = self:GetParent()
        for i=#caster.tOldSpells,1,-1 do
            local hSpell = caster.tOldSpells[i]
            if hSpell:NumModifiersUsingAbility() == 0 and not hSpell:IsChanneling() then
                hSpell:RemoveSelf()
                table.remove(caster.tOldSpells,i)
            end
        end
    end
end

function modifier_imba_antimage_spell_shield_passive:HasSpell( name )
	local caster = self:GetParent()
    for _,hSpell in pairs(caster.tOldSpells) do
        if hSpell ~= nil and hSpell:GetAbilityName() == name then
            return true
        end
    end
    return false
end

function modifier_imba_antimage_spell_shield_active:HasSpell( name )
	local caster = self:GetParent()
    for _,hSpell in pairs(caster.tOldSpells) do
        if hSpell ~= nil and hSpell:GetAbilityName() == name then
            return true
        end
    end
    return false
end

function modifier_imba_antimage_spell_shield_active:GetReflectSpell( params )
	if IsServer() then
		-- If some spells shouldn't be reflected, enter it into this spell-list
		local exception_spell = 
		{
			["rubick_spell_steal"] = true,
			["EXAMPLE2"] = true,
		}
		
		local reflected_spell_name = params.ability:GetAbilityName()
		local target = params.ability:GetCaster()
		
		if ( not exception_spell[reflected_spell_name] ) and (not target:HasModifier("modifier_imba_antimage_spell_shield_active") ) then
			local caster = self:GetParent()
			local ability
			
			local reflect_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(reflect_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(reflect_pfx)
			
			if self:HasSpell(reflected_spell_name) then
				ability = caster:FindAbilityByName(reflected_spell_name)
			else
				ability = caster:AddAbility(reflected_spell_name)
				ability:SetStolen(true)
				ability:SetHidden(true)
				
				-- Modifier counter, and add it into the old-spell list
				ability:SetRefCountsModifiers(true)
				table.insert(caster.tOldSpells, ability)
			end
			
			ability:SetLevel(params.ability:GetLevel())
			-- Set target & fire spell
			caster:SetCursorCastTarget(target)
			ability:OnSpellStart()
			target:EmitSound("Hero_Antimage.SpellShield.Reflect")
		end
		return false
	end
end

function modifier_imba_antimage_spell_shield_active:GetAbsorbSpell( params )
	if IsServer() then
		-- Run visual + sound
		local caster = self:GetParent()
		local reflect_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(reflect_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true)
		ParticleManager:ReleaseParticleIndex(reflect_pfx)
		return 1
	end
end

-------------------------------------------
--			MANA VOID
-------------------------------------------

imba_antimage_mana_void = class({})
LinkLuaModifier("modifier_imba_mana_void_ministun", "hero/hero_antimage", LUA_MODIFIER_MOTION_NONE)

function imba_antimage_mana_void:OnAbilityPhaseStart()
	if IsServer() then
		self:GetCaster():EmitSound("Hero_Antimage.ManaVoidCast")
		return true
	end
end

-- Talent reducing CD + CDR
function imba_antimage_mana_void:GetCooldown( nLevel )
	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
	local caster = self:GetCaster()
	if caster:HasTalent("special_bonus_imba_antimage_7") then
		cooldown = cooldown - caster:FindTalentValue("special_bonus_imba_antimage_7")
	end
	return cooldown
end

function imba_antimage_mana_void:GetAOERadius()
	return self:GetSpecialValueFor("mana_void_aoe_radius")
end

function imba_antimage_mana_void:IsHiddenWhenStolen()
    return false
end

function imba_antimage_mana_void:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local ability = self
		local scepter = HasScepter(caster)
		local modifier_ministun = "modifier_imba_mana_void_ministun"
		
		-- Parameters
		local damage_per_mana = ability:GetSpecialValueFor("mana_void_damage_per_mana")
		local radius = ability:GetSpecialValueFor("mana_void_aoe_radius")
		local mana_burn_pct = ability:GetSpecialValueFor("mana_void_mana_burn_pct")
		local mana_void_ministun = ability:GetSpecialValueFor("mana_void_ministun")
		local damage = 0
		
		-- If the target possesses a ready Linken's Sphere, do nothing
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(ability) then
				return nil
			end
		end
		
		-- Burn main target's mana & ministun
		local target_mana_burn = target:GetMaxMana() * mana_burn_pct / 100
		target:ReduceMana(target_mana_burn)
		target:AddNewModifier(caster, ability, modifier_ministun, {duration = mana_void_ministun})
		
		-- Find all enemies in the area of effect
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(nearby_enemies) do

			-- Calculate this enemy's damage contribution
			local this_enemy_damage = 0
			
			-- Talent 8, all missing mana pools added to damage
			if ( caster:HasTalent("special_bonus_imba_antimage_8") ) or (enemy == target) then
				this_enemy_damage = (enemy:GetMaxMana() - enemy:GetMana()) * damage_per_mana
			end
			-- Add this enemy's contribution to the damage tally
			damage = damage + this_enemy_damage
		end

		-- Damage all enemies in the area for the total damage tally
		for _,enemy in pairs(nearby_enemies) do
			ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damage, nil)
		end

		-- Shake screen due to excessive PURITY OF WILL
		ScreenShake(target:GetOrigin(), 10, 0.1, 1, 500, 0, true)
		
		local void_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", PATTACH_POINT_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(void_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true)
		ParticleManager:SetParticleControl(void_pfx, 1, Vector(radius,0,0))
		ParticleManager:ReleaseParticleIndex(void_pfx)
		target:EmitSound("Hero_Antimage.ManaVoid")
	end	
end



-- Stun modifier
modifier_imba_mana_void_ministun = class({})

function modifier_imba_mana_void_ministun:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state	
end

function modifier_imba_mana_void_ministun:IsStunDebuff()
	return true
end

function modifier_imba_mana_void_ministun:IsHidden()
	return false	
end

function modifier_imba_mana_void_ministun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_mana_void_ministun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end