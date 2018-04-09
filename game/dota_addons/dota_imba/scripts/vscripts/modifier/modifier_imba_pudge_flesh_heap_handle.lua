modifier_imba_pudge_flesh_heap_handle = modifier_imba_pudge_flesh_heap_handle or class({})

function modifier_imba_pudge_flesh_heap_handle:IsDebuff() return false end
function modifier_imba_pudge_flesh_heap_handle:IsHidden() return true end
function modifier_imba_pudge_flesh_heap_handle:IsPurgable() return false end
function modifier_imba_pudge_flesh_heap_handle:RemoveOnDeath() return false end

function modifier_imba_pudge_flesh_heap_handle:DeclareFunctions()
	local funcs = {MODIFIER_EVENT_ON_DEATH}
	return funcs
end

function modifier_imba_pudge_flesh_heap_handle:OnDeath(keys)
	local unit = keys.unit
	local ability = self:GetCaster():FindAbilityByName("imba_pudge_flesh_heap")
	if not ability then return end
	local distance = ability:GetLevelSpecialValueFor("range", 1)
	if unit:IsRealHero() and unit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and CalcDistanceBetweenEntityOBB(unit, self:GetCaster()) <= distance then
		self:SetStackCount(self:GetStackCount() + 1)
		if IsServer() then
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
			ParticleManager:ReleaseParticleIndex(pfx)
		end
	end
end
