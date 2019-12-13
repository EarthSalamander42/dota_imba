imba_snapfire_scatterblast = imba_snapfire_scatterblast or class({})

function imba_snapfire_scatterblast:OnAbilityPhaseStart()
	if not IsServer() then return end

	self:GetCaster():EmitSound("")

	-- todo: add precast pfx
end
