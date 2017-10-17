modifier_no_pvp = class({})

function modifier_no_pvp:IsHidden()
	return true
end

function modifier_no_pvp:OnCreated()
	
end

function modifier_no_pvp:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_no_pvp:OnTakeDamage( params )
	if params.attacker == params.unit then return end
	if params.attacker:IsRealHero() or params.attacker:GetPlayerOwner() then
		if params.unit:IsRealHero() then
			params.unit:Heal(params.damage, params.unit)
		end
	end
end
