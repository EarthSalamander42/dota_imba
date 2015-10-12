--[[	Author: Firetoad
		Date:	11.10.2015	]]

function VanguardBlock( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = keys.damage
	local block_sound = keys.block_sound

	-- Fetch full block chance
	local proc_chance = ability:GetLevelSpecialValueFor("proc_chance", ability_level)
	local damage_block = ability:GetLevelSpecialValueFor("damage_block", ability_level)
	local damage_to_block = 0

	-- If damage is less or the same as the damage block, just block all of it
	if damage <= damage_block then
		damage_to_block = damage

	-- Else, roll for a proc
	elseif RandomInt(1, 100) <= proc_chance then

		-- Play the block sound
		caster:EmitSound("Imba.VanguardBlock")

		-- Block all damage
		damage_to_block = damage

	-- Else, block the normal amount
	else
		damage_to_block = damage_block
	end
	
	-- Heal damage done
	caster:Heal(damage_to_block, caster)

	-- Play block message
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, caster, damage_to_block, nil)
end