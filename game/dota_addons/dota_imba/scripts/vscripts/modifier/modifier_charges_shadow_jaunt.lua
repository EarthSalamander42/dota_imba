modifier_charges_shadow_jaunt = class({})

if IsServer() then
	function modifier_charges_shadow_jaunt:Update()
		if self:GetDuration() == -1 then
			self:SetDuration(self.kv.replenish_time, true)
			self:StartIntervalThink(self.kv.replenish_time)
		end

		if self:GetStackCount() == 0 then
			self:GetAbility():StartCooldown(self:GetRemainingTime())
		end
	end

	function modifier_charges_shadow_jaunt:OnCreated(kv)
		self:SetStackCount(kv.start_count or kv.max_count)
		self.kv = kv

		if kv.start_count and kv.start_count ~= kv.max_count then
			self:Update()
		end
	end

	function modifier_charges_shadow_jaunt:DeclareFunctions()
		local funcs = {
			MODIFIER_EVENT_ON_ABILITY_EXECUTED
		}

		return funcs
	end

	function modifier_charges_shadow_jaunt:OnAbilityExecuted(params)
		if params.unit == self:GetParent() then
			local ability = params.ability

			if params.ability == self:GetAbility() then
				self:DecrementStackCount()
				self:Update()
			end
		end

		-- If this is Rubick and the original ability is no longer present, do nothing and kill the modifiers
		local caster = self:GetParent()
		local ability = self:GetAbility()
		if IsStolenSpell(caster) then
			if not caster:FindAbilityByName("imba_bounty_hunter_shadow_jaunt") then
				caster:RemoveModifierByName("modifier_charges_shadow_jaunt")
			end
		end

		return 0
	end

	function modifier_charges_shadow_jaunt:OnIntervalThink()
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

function modifier_charges_shadow_jaunt:DestroyOnExpire()
	return false
end

function modifier_charges_shadow_jaunt:IsPurgable()
	return false
end