--[[	Author: Firetoad
		Date:	12.10.2015	]]

function HeartDamage( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_regen = keys.modifier_regen

	-- If the attacker is a hero or roshan, and not an ally, put the heart on cooldown
	if (attacker:IsHero() or IsRoshan(attacker)) and attacker:GetTeam() ~= caster:GetTeam() then

		-- Parameters
		local cooldown = ability:GetLevelSpecialValueFor("regen_cooldown", ability_level)

		-- Remove the noncombat regen modifier
		caster:RemoveModifierByName(modifier_regen)

		-- Start the cooldown
		ability:StartCooldown(cooldown * caster:GetCooldownReduction())
	end
end

function HeartRegen( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_regen = keys.modifier_regen

	-- If the ability is off cooldown, apply the regen modifier
	if ability:IsCooldownReady() then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_regen, {})
	else
		caster:RemoveModifierByName(modifier_regen)
	end
end