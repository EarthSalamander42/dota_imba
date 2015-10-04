--[[	Author: d2imba
		Date:	09.05.2015	]]

function Sheepstick( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_debuff = keys.modifier_debuff
	local modifier_dearmor = keys.modifier_dearmor
	local modifier_demagic = keys.modifier_demagic

	-- Parameters
	local duration = ability:GetLevelSpecialValueFor("sheep_duration", ability:GetLevel() - 1 )

	-- Kills the target if it is an illusion
	if target:IsIllusion() then
		target:ForceKill(true)
	else
		-- Applies sheepstick modifiers
		target:AddNewModifier(caster, ability, "modifier_sheepstick_debuff", {duration = duration})
		ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})

		-- Removes magic resistance and armor for the duration
		local magical_armor = target:GetMagicalArmorValue()
		magical_armor = math.max( math.min(magical_armor, 0.8), 0)

		local magical_armor_stacks = math.floor( 100 * ( 1 / ( 1 - magical_armor ) - 1 ) )
		local armor_stacks = math.floor(target:GetPhysicalArmorValue())
		AddStacks(ability, caster, target, modifier_dearmor, armor_stacks, false)
		AddStacks(ability, caster, target, modifier_demagic, magical_armor_stacks, false)
	end
end