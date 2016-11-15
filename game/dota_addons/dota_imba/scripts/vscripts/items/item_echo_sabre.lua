--[[	Author: Firetoad
		Date:	14.11.2016	]]

function EchoSabreStart( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_double = keys.modifier_double

	-- If a higher-level echo sabre version is present, or the item is in cooldown, do nothing
	if caster:HasModifier("modifier_item_imba_reverb_rapier_unique") or not ability:IsCooldownReady() then
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
	ability:StartCooldown(cooldown * GetCooldownReduction(caster))
	
	-- Reduce attacker's BAT
	ModifyBAT(caster, bat_reduction, 0)

	-- Apply attacker modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_double, {})

	-- Reset global variable
	caster.echo_saber_remaining_hits = max_hits
end

function ReverbRapierStart( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_double = keys.modifier_double

	-- If the item is in cooldown, do nothing
	if not ability:IsCooldownReady() then
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
	ability:StartCooldown(cooldown * GetCooldownReduction(caster))
	
	-- Reduce attacker's BAT
	ModifyBAT(caster, bat_reduction, 0)

	-- Apply attacker modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_double, {})

	-- Reset global variable
	caster.echo_saber_remaining_hits = max_hits
end

function EchoSabreHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_double = keys.modifier_double
	local modifier_slow = keys.modifier_slow

	-- If the target is not magic immune, apply the slow modifier
	if not target:IsMagicImmune() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_slow, {})
	end

	-- Count down one attack from the limit
	if caster.echo_saber_remaining_hits then
		caster.echo_saber_remaining_hits = caster.echo_saber_remaining_hits - 1
	end

	-- If this is the last hit, remove the attacker modifier
	if caster.echo_saber_remaining_hits and caster.echo_saber_remaining_hits <= 0 then
		caster:RemoveModifierByName(modifier_double)
	end
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