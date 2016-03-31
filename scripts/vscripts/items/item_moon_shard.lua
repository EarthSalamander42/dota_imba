--[[ 	Author: Hewdraw
		Date: 17.05.2015	]]

function MoonShardActive( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_as = keys.modifier

	-- If this unit is not a real hero, do nothing
	if not caster:IsRealHero() then
		ability:RefundManaCost()
		ability:EndCooldown()
		return nil
	end
	
	AddStacks(ability, caster, target, modifier_as, 1, true)
	target:EmitSound("Item.MoonShard.Consume")
	caster:RemoveItem(ability)
end