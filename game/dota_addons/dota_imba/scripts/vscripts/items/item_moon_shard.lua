--[[ 	Author: Hewdraw
		Date: 17.05.2015	]]

function MoonShardActive( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sound_consume = keys.sound_consume
	local modifier_consume_1 = keys.modifier_consume_1
	local modifier_consume_2 = keys.modifier_consume_2
	local modifier_consume_3 = keys.modifier_consume_3
	local modifier_stacks = keys.modifier_stacks

	-- If this unit is not a real hero, do nothing
	if not target:IsRealHero() then
		return nil
	end

	-- Decide the proper modifier to apply based on the target's stack amount
	local current_stacks = target:GetModifierStackCount(modifier_stacks, nil)
	if current_stacks <= 0 then
		ability:ApplyDataDrivenModifier(caster, target, modifier_consume_1, {})
	elseif current_stacks == 1 then
		ability:ApplyDataDrivenModifier(caster, target, modifier_consume_2, {})
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier_consume_3, {})
	end

	-- Add a stack of the dummy modifier
	AddStacks(ability, caster, target, modifier_stacks, 1, true)
	
	-- Play cast sound locally for the caster and the target
	if caster:IsRealHero() then
		local caster_id = caster:GetPlayerID()
		if caster_id then
			EmitSoundOnClient(sound_consume, PlayerResource:GetPlayer(caster_id))
		end
	end
	local target_id = target:GetPlayerID()
	if target_id then
		EmitSoundOnClient(sound_consume, PlayerResource:GetPlayer(target_id))
	end

	-- Destroy the moon shard
	caster:RemoveItem(ability)
end