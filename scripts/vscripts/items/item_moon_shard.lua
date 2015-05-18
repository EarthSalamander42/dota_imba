--[[ 	Author: Hewdraw
		Date: 17.05.2015	]]

function MoonShardActive( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier
	
	ability:ApplyDataDrivenModifier(caster, target, modifier, {}) 
	caster:RemoveItem(ability)
end