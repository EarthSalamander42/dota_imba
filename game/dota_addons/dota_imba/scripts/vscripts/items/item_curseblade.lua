-- Author: Shush
-- Date: 25/01/2017

-- Adds [stack_amount] stacks to a lua-based modifier
function AddStacksLua(ability, caster, unit, modifier, stack_amount, refresh)
    if unit:HasModifier(modifier) then
        if refresh then
            unit:AddNewModifier(caster, ability, modifier, {})
        end
        unit:SetModifierStackCount(modifier, ability, unit:GetModifierStackCount(modifier, nil) + stack_amount)
    else
        unit:AddNewModifier(caster, ability, modifier, {})
        unit:SetModifierStackCount(modifier, ability, stack_amount)
    end
end


if item_imba_curseblade == nil then
	item_imba_curseblade = class({})
end
LinkLuaModifier("modifier_item_imba_curseblade", "items/item_curseblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_curseblade_debuff", "items/item_curseblade", LUA_MODIFIER_MOTION_NONE)


function item_imba_curseblade:GetIntrinsicModifierName()
	return "modifier_item_imba_curseblade"
end


function item_imba_curseblade:OnSpellStart()
	if IsServer() then		
		-- Ability properties
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local sound_cast = "Imba.Curseblade"
		local particle_curse = "particles/item/curseblade/imba_curseblade_curse.vpcf"
		local datadrive_baseclass = "modifier_datadriven"
		local debuff = "modifier_item_imba_curseblade_debuff"
		
		-- Ability specials
		local duration = self:GetSpecialValueFor("duration")
		
		-- Play sound cast
		EmitSoundOn(sound_cast, caster)
		
		-- Check for Linken's Sphere
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(self) then
				return nil
			end
		end	
		
		-- Find all modifiers on caster	
		local modifiers = caster:FindAllModifiers()		
		for _,modifier in pairs(modifiers) do
			local modifier_name = modifier:GetName()		
			-- Compare debuff to try and find it in the KV debuff list
			for _,modifier_name_in_list in pairs(DISPELLABLE_DEBUFF_LIST) do
				if modifier_name == modifier_name_in_list then
					-- If a match was found, get its remaining duration, and remove it from caster
					local modifier_duration = modifier:GetDuration()								
					caster:RemoveModifierByName(modifier_name)

					-- Find if it is a lua based ability or datadriven and assign the correct function
					local modifier_ability = modifier:GetAbility()				
					--local modifier_caster = modifier:GetCaster()
					local modifier_class = modifier:GetClass()				
					
					if modifier_class == datadrive_baseclass then					
						modifier_ability:ApplyDataDrivenModifier(caster, target, modifier_name, {duration = modifier_duration})
					else					
						target:AddNewModifier(caster, modifier_ability, modifier_name, {duration = modifier_duration})
					end
				end	
			end			
		end
		
		-- Add debuff to target
		target:AddNewModifier(caster, ability, debuff, {duration = duration})	
	end
end		


-- Passive stats modifier
if modifier_item_imba_curseblade == nil then
	modifier_item_imba_curseblade = class({})
end

function modifier_item_imba_curseblade:IsHidden()
	return true
end

function modifier_item_imba_curseblade:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					  MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					  MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE}
		
	return decFuncs	
end

function modifier_item_imba_curseblade:GetModifierBonusStats_Agility()
	local ability = self:GetAbility()
	local agility_bonus = ability:GetSpecialValueFor("agility_bonus")
	
	return agility_bonus
end

function modifier_item_imba_curseblade:GetModifierBonusStats_Intellect()
	local ability = self:GetAbility()
	local intelligence_bonus = ability:GetSpecialValueFor("intelligence_bonus")	

	return intelligence_bonus
end

function modifier_item_imba_curseblade:GetModifierBonusStats_Strength()
	local ability = self:GetAbility()
	local strength_bonus = ability:GetSpecialValueFor("strength_bonus")
	
	return strength_bonus
end

function modifier_item_imba_curseblade:GetModifierBaseAttack_BonusDamage()
	local ability = self:GetAbility()
	local damage = ability:GetSpecialValueFor("damage")
	
	return damage
end

-- Active drain/slow modifier
modifier_item_imba_curseblade_debuff = class({})

function modifier_item_imba_curseblade_debuff:IsDebuff()
	return true
end

function modifier_item_imba_curseblade_debuff:IsHidden()
	return false
end

function modifier_item_imba_curseblade_debuff:IsPurgable()
	return true
end

function modifier_item_imba_curseblade_debuff:OnCreated()
	local caster = self:GetCaster()
	local target = self:GetParent()
	local ability = self:GetAbility()
	local tick_rate = ability:GetSpecialValueFor("tick_rate")	
		
	-- Start interval for ticking HP/MP drain.
	self:StartIntervalThink(tick_rate)	
end

function modifier_item_imba_curseblade_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
		
	return decFuncs	
end

function modifier_item_imba_curseblade_debuff:GetModifierMoveSpeedBonus_Percentage()
	local ability = self:GetAbility()
	local slow_amount = ability:GetSpecialValueFor("slow_amount")
	
	return slow_amount
end

function modifier_item_imba_curseblade_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_imba_curseblade_debuff:GetEffectName()
	return "particles/item/curseblade/imba_curseblade_curse.vpcf"
end

function modifier_item_imba_curseblade_debuff:OnIntervalThink()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local target = self:GetParent()	
		local ability = self:GetAbility()
		local particle_drain = "particles/hero/skeleton_king/skeleton_king_vampiric_aura_lifesteal.vpcf"
		
		-- Ability specials
		local lifedrain_per_second = ability:GetSpecialValueFor("lifedrain_per_second")
		local manadrain_per_second = ability:GetSpecialValueFor("manadrain_per_second")
		local tick_rate = ability:GetSpecialValueFor("tick_rate")
		
		-- Show drain particles
		local particle_drain_fx = ParticleManager:CreateParticle(particle_drain, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_drain_fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_drain_fx, 1, caster:GetAbsOrigin())
		
		
		-- Set actual damage/drain per tick
		local lifedrain = lifedrain_per_second * tick_rate
		local manadrain = manadrain_per_second * tick_rate
		
		-- Apply damage to enemy, heal caster
		local damageTable = {victim = target,
							attacker = caster,
							damage = lifedrain,
							damage_type = DAMAGE_TYPE_MAGICAL}			
		
		ApplyDamage(damageTable)	
		
		caster:Heal(lifedrain, caster)
		
		-- Reduce enemy's mana, replenish caster's.
		target:ReduceMana(manadrain)
		caster:GiveMana(manadrain)
	end
	
end