--[[	Author: d2imba
		Date:	25.06.2015	]]

function Yasha( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stacks = keys.modifier_stacks
	local sound_battle_rhythm = keys.sound_battle_rhythm

	-- Parameters
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	-- If a higher-priority battle rhytm buff is present, do nothing
	if caster:HasModifier("modifier_item_imba_azura_and_yasha_stack") or caster:HasModifier("modifier_item_imba_sange_and_yasha_stack") or caster:HasModifier("modifier_item_imba_sange_and_azura_and_yasha_stack") then
		return nil
	end

	-- Increase or refresh the number of battle rhythm stacks
	if caster:HasModifier(modifier_stacks) then
		local current_stacks = caster:GetModifierStackCount(modifier_stacks, ability)
		if current_stacks < max_stacks then
			AddStacks(ability, caster, caster, modifier_stacks, 1, true)
		else
			AddStacks(ability, caster, caster, modifier_stacks, 0, true)
		end
	else
		caster:EmitSound(sound_battle_rhythm)
		AddStacks(ability, caster, caster, modifier_stacks, 1, true)
	end
end

function YashaIllusion( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stacks = keys.modifier_stacks
	local modifier_yasha = keys.modifier_yasha
	local modifier_yasha_2 = keys.modifier_yasha_2
	local modifier_yasha_3 = keys.modifier_yasha_3
	local modifier_yasha_4 = keys.modifier_yasha_4
	local modifier_yasha_5 = keys.modifier_yasha_5
	local modifier_yasha_6 = keys.modifier_yasha_6

	-- If there's no valid target, do nothing
	if not target:IsHero() and not target:IsCreep() then
		return nil
	end

	-- If a higher-priority illusion generation buff is present, do nothing
	if caster:HasModifier("modifier_item_imba_azura_and_yasha_proc") or caster:HasModifier("modifier_item_imba_sange_and_yasha_proc") or caster:HasModifier("modifier_item_imba_sange_and_azura_and_yasha_proc") then
		return nil
	end

	-- Parameters
	local illusion_duration = ability:GetLevelSpecialValueFor("proc_duration", ability_level)
	local illusion_incoming_dmg = ability:GetLevelSpecialValueFor("illu_incoming_dmg", ability_level)
	local illusion_outgoing_dmg = ability:GetLevelSpecialValueFor("illu_outgoing_dmg", ability_level)
	local player = caster:GetPlayerID()
	local hero_name = caster:GetUnitName()
	local illusion_pos = caster:GetAbsOrigin() + RandomVector(100)

	-- Spawn the illusion
	local illusion = CreateUnitByName(hero_name, illusion_pos, true, caster, nil, caster:GetTeamNumber())

	-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
	illusion:SetPlayerID(player)
	illusion:MakeIllusion()
	ability:ApplyDataDrivenModifier(caster, illusion, "modifier_item_imba_yasha_illusion_effect", {})

	-- Set the unit as an illusion
	-- modifier_illusion controls many illusion properties like +green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle 
	illusion:AddNewModifier(caster, ability, "modifier_illusion", {duration = illusion_duration, outgoing_damage = illusion_outgoing_dmg, incoming_damage = illusion_incoming_dmg })

	-- Set the illusion's HP the same as the caster's
	illusion:SetHealth(caster:GetHealth())
	
 	-- Level up the illusion to the caster's level
	local caster_level = caster:GetLevel()
	for i = 1, caster_level - 1 do
		illusion:HeroLevelUp(false)
	end

	-- Recreate the items of the caster
	for item_slot = 0,5 do
		local item = caster:GetItemInSlot(item_slot)
		if item ~= nil then
			local item_name = item:GetName()
			local new_item = CreateItem(item_name, illusion, illusion)
			illusion:AddItem(new_item)
		end
	end

	-- Add the current amount of Battle Rhythm stacks to the illusion
	if caster:HasModifier(modifier_stacks) then
		local current_stacks = caster:GetModifierStackCount(modifier_stacks, ability)
		AddStacks(ability, caster, illusion, modifier_stacks, current_stacks, true)
	end

	-- Removes the yasha modifier, to prevent illusions spawning new illusions
	illusion:RemoveModifierByName(modifier_yasha)
	illusion:RemoveModifierByName(modifier_yasha_2)
	illusion:RemoveModifierByName(modifier_yasha_3)
	illusion:RemoveModifierByName(modifier_yasha_4)
	illusion:RemoveModifierByName(modifier_yasha_5)
	illusion:RemoveModifierByName(modifier_yasha_6)

	-- Make the illusion attack the current target immediately
	illusion:SetForceAttackTarget(target)

	-- Set the skill points to 0
	illusion:SetAbilityPoints(0)
end