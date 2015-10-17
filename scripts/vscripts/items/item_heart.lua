--[[	Author: Firetoad
		Date:	12.10.2015	]]

function HeartDamage( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_regen = keys.modifier_regen

	-- If the attacker is not a hero, do nothing
	if not attacker:IsHero() and not IsRoshan(attacker) then
		return nil
	end

	-- Parameters
	local cooldown = ability:GetLevelSpecialValueFor("regen_cooldown", ability_level)

	-- Remove the noncombat regen modifier
	caster:RemoveModifierByName(modifier_regen)

	-- Start the cooldown
	ability:StartCooldown(cooldown)
end

function HeartRegen( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_regen = keys.modifier_regen

	-- If the ability is off cooldown, apply the regen modifier
	if ability:IsCooldownReady() then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_regen, {})
	end
end