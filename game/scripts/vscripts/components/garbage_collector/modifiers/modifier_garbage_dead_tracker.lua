-- Credits: DarkoniusXNG

modifier_garbage_dead_tracker = modifier_garbage_dead_tracker or class({})

function modifier_garbage_dead_tracker:IsHidden()
	return false
end

function modifier_garbage_dead_tracker:IsPurgable()
	return false
end

function modifier_garbage_dead_tracker:OnCreated()
	if not IsServer() then return end

	local caster = self:GetCaster()

	if not caster or caster:IsNull() then
		self:Destroy()
		return
	end
end

function modifier_garbage_dead_tracker:OnDestroy()
	if not IsServer() then return end

	local parent = self:GetParent()

	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("GarbageCollector"), function()
		if parent and not parent:IsNull() and parent.RemoveSelf then
			print("Removing unit:", parent:GetUnitName(), parent:GetEntityIndex())
			parent:RemoveSelf()
		end
	end, 7.0)
end
