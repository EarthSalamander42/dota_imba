--[[ 	Author: Hewdraw
		Date: 17.05.2015	]]

function MoonShardActive( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier
	
	AddStacks(ability, caster, target, modifier, 1, true)
	caster:RemoveItem(ability)
end