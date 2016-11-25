--[[	Author: Firetoad
		Date:	25.11.2016	]]

function NetherWand( keys )
	local caster = keys.caster

	-- If the bearer has a higher-level version of this ability, do nothing
	if caster:HasModifier("modifier_item_imba_elder_staff") then
		return nil
	end

	-- Parameters
	local ability = keys.ability
	local target = keys.unit
	local modifier_burn = keys.modifier_burn

	-- Apply the burn modifier
	if target:GetTeam() ~= caster:GetTeam() and not target:IsBuilding() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_burn, {})
	end
end

function ElderStaff( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.unit
	local modifier_burn = keys.modifier_burn

	-- Apply the burn modifier
	if target:GetTeam() ~= caster:GetTeam() and not target:IsBuilding() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_burn, {})
	end
end

function NetherWandTick( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifier_unique = keys.modifier_unique

	-- Parameters
	local burn_duration = ability:GetSpecialValueFor("burn_duration")
	local burn_amount = ability:GetSpecialValueFor("burn_amount")
	local burn_tick = ability:GetSpecialValueFor("burn_tick")

	-- Calculate damage
	local burn_damage = burn_amount * burn_tick / burn_duration
	local damage = target:GetMaxHealth() * burn_damage * 0.01

	-- Deal damage
	if caster:HasModifier(modifier_unique) then
		caster:RemoveModifierByName(modifier_unique)
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		ability:ApplyDataDrivenModifier(caster, caster, modifier_unique, {})
	end
end

function NetherWandSpellPowerCreate( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- If this is an illusion, do nothing
	if caster:IsIllusion() then
		return nil
	end

	-- Increase spell power
	local spell_power = ability:GetSpecialValueFor("spell_power")
	ChangeSpellPower(caster, spell_power)
end

function NetherWandSpellPowerDestroy( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- If this is an illusion, do nothing
	if caster:IsIllusion() then
		return nil
	end

	-- Decrease spell power
	local spell_power = ability:GetSpecialValueFor("spell_power")
	ChangeSpellPower(caster, -spell_power)
end