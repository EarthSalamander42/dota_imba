--[[	Author: d2imba
		Date:	25.06.2015	]]

function Maim( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stacks = keys.modifier_stacks
	local sound_maim = keys.sound_maim

	-- If there's no valid target, do nothing
	if target:IsBuilding() or target:IsAncient() or target:IsMagicImmune() then
		return nil
	end

	-- If a higher-priority maim debuff is present, do nothing
	if target:HasModifier("modifier_item_imba_sange_and_azura_stack") or target:HasModifier("modifier_item_imba_sange_and_azura_and_yasha_maim_stack") then
		return nil
	end

	-- If a lower-priority maim debuff is present, remove it
	target:RemoveModifierByName("modifier_item_imba_sange_maim")
	target:RemoveModifierByName("modifier_item_imba_halberd_maim")
	target:RemoveModifierByName("modifier_item_imba_silver_edge_maim")

	-- Parameters
	local maim_base = ability:GetLevelSpecialValueFor("maim_base", ability_level)
	local maim_stacking = ability:GetLevelSpecialValueFor("maim_stacking", ability_level)

	-- Increases or refreshes the number of maim stacks
	if target:HasModifier(modifier_stacks) then
		AddStacks(ability, caster, target, modifier_stacks, maim_stacking, true)
	else
		target:EmitSound(sound_maim)
		AddStacks(ability, caster, target, modifier_stacks, maim_base, true)
	end
end

function Yasha( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stacks = keys.modifier_stacks
	local sound_battle_rhythm = keys.sound_battle_rhythm

	-- Parameters
	local max_stacks = ability:GetLevelSpecialValueFor("buff_stacks", ability_level)

	-- If a higher-priority battle rhytm buff is present, do nothing
	if caster:HasModifier("modifier_item_imba_sange_and_azura_and_yasha_stack") then
		return nil
	end

	-- If a lower-priority battle rhythm buff is present, remove it
	caster:RemoveModifierByName("modifier_item_imba_yasha_stacks")
	caster:RemoveModifierByName("modifier_item_imba_azura_and_yasha_stack")

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

function YashaProc( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_projectile = keys.particle_projectile
	local sound_projectile = keys.sound_projectile

	-- If a higher-priority illusion generation buff is present, do nothing
	if caster:HasModifier("modifier_item_imba_sange_and_azura_and_yasha_proc") then
		return nil
	end

	-- Parameters
	local proc_speed = ability:GetLevelSpecialValueFor("proc_speed", ability_level)

	-- Play sound
	caster:EmitSound(sound_projectile)

	-- Spawn a homing projectile which flies toward the target
	local yasha_projectile = {
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = particle_projectile,
		bDodgeable = false,
		bProvidesVision = false,
		iMoveSpeed = proc_speed,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
	}
	ProjectileManager:CreateTrackingProjectile(yasha_projectile)
end