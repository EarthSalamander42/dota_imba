--[[	Author: Firetoad
		Date:	14.11.2016	]]

function EchoSabreStart( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_applier = keys.modifier_applier
	local modifier_double = keys.modifier_double

	-- If a higher-level echo sabre version is present, or the item is in cooldown, do nothing
	if caster:HasModifier("modifier_item_imba_reverb_rapier_unique") or not ability:IsCooldownReady() or caster:HasModifier(modifier_double) then
		return nil
	end

	-- Parameters
	local bat_reduction = ability:GetSpecialValueFor("bat_reduction")
	local max_hits = ability:GetSpecialValueFor("max_hits")

	-- Trigger ability cooldown (longer for ranged units)
	local cooldown = ability:GetCooldown(0)
	if caster:IsRangedAttacker() and ( not caster:HasModifier("modifier_imba_berserkers_rage") ) then
		cooldown = ability:GetSpecialValueFor("ranged_cooldown")
	end
	ability:StartCooldown(cooldown * caster:GetCooldownReduction())
	
	-- Reduce attacker's BAT
	ModifyBAT(caster, bat_reduction, 0)

	-- Apply attacker modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_double, {})

	-- Apply the slow-applier modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_applier, {})

	-- Reset global variable
	caster.echo_saber_remaining_hits = max_hits - 1
end

function ReverbRapierStart( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_applier = keys.modifier_applier
	local modifier_double = keys.modifier_double

	-- If the item is in cooldown, or the attacker is already benefitting from increased attack speed, do nothing
	if not ability:IsCooldownReady() or caster:HasModifier(modifier_double) then
		return nil
	end

	-- Parameters
	local bat_reduction = ability:GetSpecialValueFor("bat_reduction")
	local max_hits = ability:GetSpecialValueFor("max_hits")

	-- Trigger ability cooldown (longer for ranged units)
	local cooldown = ability:GetCooldown(0)
	if caster:IsRangedAttacker() and ( not caster:HasModifier("modifier_imba_berserkers_rage") ) then
		cooldown = ability:GetSpecialValueFor("ranged_cooldown")
	end
	ability:StartCooldown(cooldown * caster:GetCooldownReduction())
	
	-- Reduce attacker's BAT
	ModifyBAT(caster, bat_reduction, 0)

	-- Apply attacker modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_double, {})

	-- Apply the slow-applier modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_applier, {})

	-- Reset global variable
	caster.echo_saber_remaining_hits = max_hits - 1
end

function EchoSabreStartHit( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_applier = keys.modifier_applier
	local modifier_double = keys.modifier_double

	-- Count down one attack from the limit
	if caster.echo_saber_remaining_hits then
		caster.echo_saber_remaining_hits = caster.echo_saber_remaining_hits - 1
	end

	-- If this is the last hit, remove the attacker modifier
	if caster.echo_saber_remaining_hits and caster.echo_saber_remaining_hits <= 0 then
		caster:RemoveModifierByName(modifier_double)
	end

	-- Apply the slow-applier modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_applier, {})
end

function EchoSabreFinishHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_applier = keys.modifier_applier
	local modifier_slow = keys.modifier_slow

	-- If the target is not magic immune, apply the slow modifier
	if not target:IsMagicImmune() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_slow, {})
	end

	-- Remove the slow-applier modifier
	caster:RemoveModifierByName(modifier_applier)
end

function EchoSabreEnd( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	-- Parameters
	local bat_reduction = ability:GetSpecialValueFor("bat_reduction")
	local bat_increase = 100 * ( 100 / ( 100 + bat_reduction ) - 1 )
	
	-- Restore attacker's BAT
	ModifyBAT(caster, bat_increase, 0)
end

function EchoSabreUnequip( keys )
	local caster = keys.caster
	local modifier_multihit = keys.modifier_multihit
	local modifier_slow_applier = keys.modifier_slow_applier

	-- Remove all relevant modifiers
	caster:RemoveModifierByName(modifier_multihit)
	caster:RemoveModifierByName(modifier_slow_applier)
end