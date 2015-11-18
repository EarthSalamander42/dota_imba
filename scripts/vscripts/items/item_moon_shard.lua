<<<<<<< HEAD
--[[ 	Author: Hewdraw
		Date: 17.05.2015	]]
=======
--[[ Author: Hewdraw ]]
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108

function MoonShardActive( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
<<<<<<< HEAD
	local modifier = keys.modifier
	
	AddStacks(ability, caster, target, modifier, 1, true)
	target:EmitSound("Item.MoonShard.Consume")
	caster:RemoveItem(ability)
=======
	local modifier = "modifier_moon_shard_activated"
	
	if target == caster then
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {}) 
		caster:RemoveItem(ability)
	end
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108
end