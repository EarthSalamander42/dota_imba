--[[	Author: Firetoad
		Date:	25.11.2016	]]

function NetherWand( keys )
	local caster = keys.caster

	-- If the bearer has a higher-level version of this ability, do nothing
	if caster:HasModifier("modifier_item_imba_elder_staff") then
		return nil
	end

	-- If the target is over 2500 distance away, do nothing
	local target = keys.unit
	if (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > IMBA_DAMAGE_EFFECTS_DISTANCE_CUTOFF then
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

	-- If the target is over 2500 distance away, do nothing
	if (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > IMBA_DAMAGE_EFFECTS_DISTANCE_CUTOFF then
		return nil
	end

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
	local damage = target:GetHealth() * burn_damage * 0.01

	-- Caustic finale interaction part 1
	local caustic_ability = caster:FindAbilityByName("imba_sandking_caustic_finale")
	if caustic_ability and caustic_ability:GetLevel() > 0 then
		caustic_ability:ApplyDataDrivenModifier(caster, target, "modifier_imba_caustic_finale_prevent", {})
	end

	-- Deal damage
	if caster:HasModifier(modifier_unique) then
		caster:RemoveModifierByName(modifier_unique)
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		ability:ApplyDataDrivenModifier(caster, caster, modifier_unique, {})
	end

	-- Caustic finale interaction part 2
	target:RemoveModifierByNameAndCaster("modifier_imba_caustic_finale_prevent", caster)
end