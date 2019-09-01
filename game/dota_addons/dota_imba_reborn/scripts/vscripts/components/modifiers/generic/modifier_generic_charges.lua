-- Generic Charges Library created by Elfansoer (with modifications)
-- See the reference at https://github.com/Elfansoer/dota-2-lua-abilities/blob/master/scripts/vscripts/lua_abilities/generic/modifier_generic_charges.lua

modifier_generic_charges = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_charges:IsHidden()
	return false
end

function modifier_generic_charges:IsDebuff()
	return false
end

function modifier_generic_charges:IsPurgable()
	return false
end

function modifier_generic_charges:DestroyOnExpire()
	return false
end

function modifier_generic_charges:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_charges:OnCreated()
	if not IsServer() then return end
	
	self:SetStackCount(self:GetAbility():GetTalentSpecialValueFor("max_charges"))
	self:CalculateCharge()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_generic_charges:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}

	return funcs
end

function modifier_generic_charges:OnAbilityFullyCast( params )
	if params.unit ~= self:GetParent() then return end
	
	if params.ability == self:GetAbility() then
		-- All this garbage is just to try and check for WTF mode to not expend charges and yet it's still bypassable
		local wtf_mode = true
		
		if not GameRules:IsCheatMode() then
			wtf_mode = false
		else
			for ability = 0, 24 - 1 do
				if self:GetParent():GetAbilityByIndex(ability) and self:GetParent():GetAbilityByIndex(ability):GetCooldownTimeRemaining() > 0 then
					wtf_mode = false
					break
				end
			end

			if wtf_mode == false then
				for item = 0, 15 do
					if self:GetParent():GetItemInSlot(item) and self:GetParent():GetItemInSlot(item):GetCooldownTimeRemaining() > 0 then
						wtf_mode = false
						break
					end
				end
			end
		end
		
		if wtf_mode == false then
			self:DecrementStackCount()
			self:CalculateCharge()
		end
	elseif params.ability:GetName() == "item_refresher" or params.ability:GetName() == "item_refresher_shard" then
		self:StartIntervalThink(-1)
		self:SetDuration( -1, true )
		self:SetStackCount(self:GetAbility():GetTalentSpecialValueFor("max_charges"))
	end
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_generic_charges:OnIntervalThink()
	self:IncrementStackCount()
	self:StartIntervalThink(-1)
	self:CalculateCharge()
end

function modifier_generic_charges:CalculateCharge()	
	if self:GetStackCount() >= self:GetAbility():GetTalentSpecialValueFor("max_charges") then
		-- stop charging
		self:SetDuration( -1, true )
		self:StartIntervalThink( -1 )
	else
		-- if not charging
		if self:GetRemainingTime() <= 0.05 then
			-- start charging
			local charge_time	= self:GetAbility():GetTalentSpecialValueFor("charge_restore_time") * self:GetParent():GetCooldownReduction()
			
			if self:GetParent():HasScepter() then
				charge_time		= self:GetAbility():GetTalentSpecialValueFor("charge_restore_time_scepter") * self:GetParent():GetCooldownReduction()
			end
			
			self:StartIntervalThink( charge_time )
			self:SetDuration( charge_time, true )
		end

		-- set on cooldown if no charges
		if self:GetStackCount() == 0 then
			self:GetAbility():StartCooldown(self:GetRemainingTime())
		else
			self:GetAbility():StartCooldown(0.25)
		end
	end
end
