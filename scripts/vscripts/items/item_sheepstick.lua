--[[	Author: d2imba
		Date:	09.05.2015	]]

function Sheepstick( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_debuff = keys.modifier_debuff
	local modifier_dearmor = keys.modifier_dearmor
	local modifier_demagic = keys.modifier_demagic
	local modifier_recast = keys.modifier_recast
	-- Parameters
	local duration = ability:GetLevelSpecialValueFor("sheep_duration", ability:GetLevel() - 1 )
	local armor_max = ability:GetLevelSpecialValueFor("armor_reduction", ability:GetLevel() - 1 )
	local sheep_recast_duration = ability:GetLevelSpecialValueFor("sheep_recast_duration", ability:GetLevel() - 1 )
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability:GetLevel() - 1)
	-- Kills the target if it is an illusion
	if target:IsIllusion() then
		target:ForceKill(true)
	else
		-- if target has recently (10 seconds) affected by sheepstick, apply sheepstick modifier with %50 reduced duration.
		if target:HasModifier( modifier_recast ) then
			local recast_stack = target:GetModifierStackCount( modifier_recast, ability )
				duration = duration / ( 2 * recast_stack )
					if recast_stack <= max_stacks then
						--AddStacks(ability, caster, target, modifier_recast, recast_stack + 1, true)
						target:SetModifierStackCount( modifier_recast, ability, recast_stack + 1 )
						print("adding more")
						print(duration .. ": duration")
					end
				target:AddNewModifier(caster, ability, "modifier_sheepstick_debuff", {duration = duration})
				ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, { duration = duration })
		else
		
		-- Applies sheepstick modifiers
		target:AddNewModifier(caster, ability, "modifier_sheepstick_debuff", {duration = duration})
			ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, { duration = duration })
			ability:ApplyDataDrivenModifier(caster, target, modifier_recast, { sheep_recast_duration = sheep_recast_duration })
			AddStacks(ability, caster, target, modifier_recast, 1, true)

		end


		-- Removes magic resistance and armor for the duration
		local magical_armor = target:GetMagicalArmorValue()
		magical_armor = math.max( math.min(magical_armor, 0.8), 0)

		local magical_armor_stacks = math.floor( 100 * ( 1 / ( 1 - magical_armor ) - 1 ) )
		local armor_stacks = math.floor(math.min(target:GetPhysicalArmorValue(), armor_max))
		AddStacks(ability, caster, target, modifier_dearmor, armor_stacks, false)
		AddStacks(ability, caster, target, modifier_demagic, magical_armor_stacks, false)
	end
end