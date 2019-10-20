-- Credits: JoBoDo (ReIncarnation RPG)
-- Date: 17th September 2019

modifier_charges = modifier_charges or class({})

if IsServer() then
	function modifier_charges:Update(kv)
		if kv then
			if kv.max_count then self.kv.max_count = kv.max_count end
		end

		if self:GetStackCount() ~= self.kv.max_count and self:GetDuration() == -1 then
			self:SetDuration(self.kv.replenish_time, true)
			self:StartIntervalThink(self.kv.replenish_time)
		end

		if self:GetStackCount() == 0 then
			self:GetAbility():StartCooldown(self:GetRemainingTime())
		end
	end

	function modifier_charges:OnCreated(kv)
		self:SetStackCount(kv.start_count or kv.max_count)
		self.kv = kv

		if kv.start_count and kv.start_count ~= kv.max_count then
			self:Update()
		end
	end

	function modifier_charges:OnRefresh(kv)
		if kv then
			if kv.start_count then self.kv.start_count = kv.start_count end
			if kv.max_count then self.kv.max_count = kv.max_count end
			if kv.replenish_time then self.kv.replenish_time = kv.replenish_time end
		end

		self:Update()
	end

	function modifier_charges:DeclareFunctions()
		local funcs = {
			MODIFIER_EVENT_ON_ABILITY_EXECUTED
		}

		return funcs
	end

	function modifier_charges:OnAbilityExecuted(params)
		if params.unit == self:GetParent() then
			local ability = params.ability

			if params.ability == self:GetAbility() then
				self:DecrementStackCount()
				self:Update()
			end
		end

		return 0
	end

	function modifier_charges:OnIntervalThink()
		local stacks = self:GetStackCount()

		if stacks < self.kv.max_count then
			self:SetDuration(self.kv.replenish_time, true)
			self:IncrementStackCount()

			if stacks == self.kv.max_count - 1 then
				self:SetDuration(-1, true)
				self:StartIntervalThink(-1)
			end
		end
	end
end

function modifier_charges:DestroyOnExpire() return false end
function modifier_charges:IsPurgable() return false end
function modifier_charges:RemoveOnDeath() return false end
function modifier_charges:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE
end