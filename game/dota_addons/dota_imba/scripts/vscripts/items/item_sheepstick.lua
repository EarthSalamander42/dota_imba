--[[	Author: d2imba
		Date:	09.05.2015	]]

function Sheepstick( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_debuff = keys.modifier_debuff
	local modifier_dearmor = keys.modifier_dearmor
	local modifier_demagic = keys.modifier_demagic
	local modifier_prevent = keys.modifier_prevent
	local particle_cast = keys.particle_cast

	-- Parameters
	local sheep_duration = ability:GetLevelSpecialValueFor("sheep_duration", ability:GetLevel() - 1 )
	local armor_max = ability:GetLevelSpecialValueFor("armor_reduction", ability:GetLevel() - 1 )

	-- Calculate actual duration
	local duration = sheep_duration
	if target:HasModifier(modifier_prevent) then
		local current_prevention_stacks = target:GetModifierStackCount(modifier_prevent, nil)
		duration = sheep_duration / (2 * current_prevention_stacks)
	end

	-- Play particle
	local sheep_pfx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(sheep_pfx, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(sheep_pfx)
	
	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end
	
	-- Kills the target if it is an illusion
	if target:IsIllusion() then
		target:ForceKill(true)
	else
		-- Applies sheepstick modifiers
		target:AddNewModifier(caster, ability, "modifier_sheepstick_debuff", {duration = duration})
		ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {duration = duration})
		ability:ApplyDataDrivenModifier(caster, target, modifier_prevent, {duration = duration + sheep_duration})
		AddStacks(ability, caster, target, modifier_prevent, 1, false)

		-- Removes magic resistance and armor for the duration
		local magical_armor = target:GetMagicalArmorValue()
		magical_armor = math.max( math.min(magical_armor, 0.8), 0)

		local magical_armor_stacks = math.floor( 100 * ( 1 / ( 1 - magical_armor ) - 1 ) )
		local armor_stacks = math.floor(math.min(target:GetPhysicalArmorValue(), armor_max))
		ability:ApplyDataDrivenModifier(caster, target, modifier_dearmor, {duration = duration})
		ability:ApplyDataDrivenModifier(caster, target, modifier_demagic, {duration = duration})
		target:SetModifierStackCount(modifier_dearmor, caster, armor_stacks)
		target:SetModifierStackCount(modifier_demagic, caster, magical_armor_stacks)
	end
end