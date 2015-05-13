function Rapier( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local damage = keys.damage

	if target:GetHealth() < damage then
		target:Kill(ability, caster)
	else
		target:SetHealth(target:GetHealth() - damage)
	end	
end