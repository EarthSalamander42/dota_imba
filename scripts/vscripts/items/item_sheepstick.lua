--[[	Author: d2imba
		Date:	09.05.2015	]]

function Sheepstick( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("sheep_duration", ability:GetLevel() - 1 )
	local pig_model = keys.pig_model
	local modifier_dearmor = keys.modifier_dearmor
	local modifier_demagic = keys.modifier_demagic

	-- Kills the target if it is an illusion, and changes it into a sheep if not
	if target:IsIllusion() then
		target:ForceKill(true)
	else
		if target.target_model == nil then
			target.target_model = target:GetModelName()
		end

		-- Changes the target's model to a pig's
		target:SetOriginalModel(pig_model)
		target:SetModel(pig_model)

		-- Removes magic resistance and armor for the duration
		local magical_armor = target:GetMagicalArmorValue()
		if magical_armor > 0.8 then
			magical_armor = 0.8
		elseif magical_armor < 0 then
			magical_armor = 0
		end
		local magical_armor_stacks = math.floor( 100 * ( 1 / ( 1 - magical_armor ) - 1 ) )
		local armor_stacks = math.floor(target:GetPhysicalArmorValue())
		AddStacks(ability, caster, target, modifier_dearmor, armor_stacks, false)
		AddStacks(ability, caster, target, modifier_demagic, magical_armor_stacks, false)
	end
end

function SheepstickEnd( keys )
	local target = keys.target

	-- Checking for errors
	if target.target_model ~= nil then
		target:SetModel(target.target_model)
		target:SetOriginalModel(target.target_model)
		target.target_model = nil
	end
end