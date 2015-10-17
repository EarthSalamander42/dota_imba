--[[	Author: Firetoad
		Date:	12.10.2015	]]

function Blademail( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local sound_cast = keys.sound_cast
	local modifier_active = keys.modifier_active

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Apply active modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_active, {})
end

function PassiveReflect( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = keys.damage

	-- Deals damage only to heroes
	if not attacker:IsHero() or attacker:GetTeam() == caster:GetTeam() then
		return nil
	end

	-- Parameters
	local passive_return = ability:GetLevelSpecialValueFor("passive_return", ability_level)
	local attacker_health = attacker:GetHealth() + 1

	-- Calculate damage to deal
	local reflect_damage = damage * passive_return / 100

	-- Checks if the target is not spell immune
	if not attacker:IsMagicImmune() then
			
		-- Uses HP removal to avoid infinite damage return loops. If the target's health is <= 0, kills it
		if attacker_health <= reflect_damage then
			attacker:Kill(ability, caster)
		else
			attacker:SetHealth(attacker_health - reflect_damage)
		end
	end
end

function ActiveReflect( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local damage = keys.damage
	local sound_reflect = keys.sound_reflect

	-- Deals damage only to heroes
	if not attacker:IsHero() or attacker:GetTeam() == caster:GetTeam() then
		return nil
	end

	-- Fetch the attacker's current health
	local attacker_health = attacker:GetHealth() + 1

	-- Checks if the target is not spell immune
	if not attacker:IsMagicImmune() then

		-- Play sound
		EmitSoundOnClient(sound_reflect, PlayerResource:GetPlayer(attacker:GetPlayerID()))

		-- Uses HP removal to avoid infinite damage return loops. If the target's health is <= 0, kills it
		if attacker_health <= damage then
			attacker:Kill(ability, caster)
		else
			attacker:SetHealth(attacker_health - damage)
		end
	end
end