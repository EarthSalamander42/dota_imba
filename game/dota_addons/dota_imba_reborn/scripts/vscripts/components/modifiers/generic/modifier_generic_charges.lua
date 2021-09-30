-- Generic Charges Library created by Elfansoer (with modifications)
-- See the reference at https://github.com/Elfansoer/dota-2-lua-abilities/blob/master/scripts/vscripts/lua_abilities/generic/modifier_generic_charges.lua

modifier_generic_charges = modifier_generic_charges or class({})

--------------------------------------------------------------------------------
-- Classifications
--[[
function modifier_generic_charges:IsHidden()
	return self:GetAbility():GetLevel() <= 0 or (self:GetAbility():GetLevel() >= 1 and self:GetAbility():GetSpecialValueFor("max_charges") == 0 and self:GetAbility():GetSpecialValueFor("max_charges_scepter") ~= 0 and not self:GetCaster():HasScepter())
end
--]]

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

function modifier_generic_charges:RemoveOnDeath()
	return false
end

function modifier_generic_charges:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_charges:OnCreated()
	if not IsServer() then return end

	Timers:CreateTimer(1.0, function()
		if self:GetCaster():HasScepter() and self:GetAbility():GetTalentSpecialValueFor("max_charges_scepter") ~= 0 then
			self:SetStackCount(self:GetAbility():GetTalentSpecialValueFor("max_charges_scepter"))

			self:CalculateCharge()
		elseif self:GetAbility():GetTalentSpecialValueFor("max_charges") > 0 then
			self:SetStackCount(self:GetAbility():GetTalentSpecialValueFor("max_charges"))

			self:CalculateCharge()
		end		

		-- Check if the ability requires a scepter to have the charges
		if self:GetAbility().RequiresScepterForCharges and self:GetAbility():RequiresScepterForCharges() then
			Timers:CreateTimer(1, function()				
				if self:GetCaster():HasScepter() then

					-- If target has a permanent scepter buff that isn't being given to him by a droppable Aghs Scepter, we can stop checking.
					if not self:GetCaster():HasItemInInventory("item_ultimate_scepter") then
						return
					end

					return 1
				else
					self:Destroy()
				end
			end)
		end

		CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "init_charge_ui", {
			unit_index = self:GetParent():entindex(),
			ability_index = self:GetRightfulAbilityIndex(),
			charge_duration = self:GetAbility():GetTalentSpecialValueFor("charge_restore_time"),
			scepter_charge_duration = self:GetAbility():GetTalentSpecialValueFor("charge_restore_time_scepter") or 0,
			ability_name = self:GetAbility():GetAbilityName(),
		})
	end)
end

function modifier_generic_charges:OnRefresh(params)
	if not IsServer() then return end

	local max_charges = self:GetAbility():GetTalentSpecialValueFor("max_charges")

	if self:GetCaster():HasScepter() and self:GetAbility():GetTalentSpecialValueFor("max_charges_scepter") ~= 0 then
		max_charges = self:GetAbility():GetTalentSpecialValueFor("max_charges_scepter")
	end

	if params.bonus_charges then
		self:SetStackCount(math.min(self:GetStackCount() + params.bonus_charges, max_charges))
	end

	self:CalculateCharge()
end

function modifier_generic_charges:GetRightfulAbilityIndex()
	if not IsServer() then return end

	local ab_index = self:GetAbility():GetAbilityIndex()

	-- temporary stuff to make it work properly
	if self:GetAbility():GetAbilityName() == "imba_void_spirit_astral_step" then
		ab_index = 4
	end

	return ab_index
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_generic_charges:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_generic_charges:OnTooltip()
	local charge_time	= self:GetAbility():GetTalentSpecialValueFor("charge_restore_time") * self:GetParent():GetCooldownReduction()

	if self:GetParent():HasScepter() and self:GetAbility():GetTalentSpecialValueFor("charge_restore_time_scepter") and self:GetAbility():GetTalentSpecialValueFor("charge_restore_time_scepter") > 0 then
		charge_time		= self:GetAbility():GetTalentSpecialValueFor("charge_restore_time_scepter") * self:GetParent():GetCooldownReduction()
	end

	return charge_time
end

function modifier_generic_charges:OnAbilityFullyCast( params )
	if params.unit ~= self:GetParent() then return end
	
	-- Remove this modifier if the ability no longer exists
	if not self:GetAbility() or self:GetAbility():IsNull() then self:Destroy() return end
	
	if params.ability == self:GetAbility() then
		-- All this garbage is just to try and check for WTF mode to not expend charges and yet it's still bypassable
--		local wtf_mode = true
		local wtf_mode = false
		
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

			Timers:CreateTimer(FrameTime() * 2, function()
				CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "update_charge_count", {
					unit_index = self:GetParent():entindex(),
					ability_index = self:GetRightfulAbilityIndex(),
				})

				CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "update_charge_loading", {
					unit_index = self:GetParent():entindex(),
					ability_index = self:GetRightfulAbilityIndex(),
				})
			end)

			self:CalculateCharge()
		end
	elseif params.ability:GetName() == "item_refresher" or params.ability:GetName() == "item_refresher_shard" then
		self:StartIntervalThink(-1)
		self:SetDuration( -1, true )
		
		if self:GetCaster():HasScepter() and self:GetAbility():GetTalentSpecialValueFor("max_charges_scepter") ~= 0 then
			self:SetStackCount(self:GetAbility():GetTalentSpecialValueFor("max_charges_scepter"))
		else
			self:SetStackCount(self:GetAbility():GetTalentSpecialValueFor("max_charges"))
		end
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
	if self:IsHidden() then return end

	if (self:GetCaster():HasScepter() and self:GetAbility():GetTalentSpecialValueFor("max_charges_scepter") ~= 0 and self:GetStackCount() >= self:GetAbility():GetTalentSpecialValueFor("max_charges_scepter")) or (self:GetAbility():GetTalentSpecialValueFor("max_charges") > 0 and self:GetStackCount() >= self:GetAbility():GetTalentSpecialValueFor("max_charges")) then
		-- stop charging
		self:SetDuration( -1, true )
		self:StartIntervalThink( -1 )
	else
		-- if not charging
		if self:GetRemainingTime() <= 0.05 then
			-- start charging
			local charge_time	= self:GetAbility():GetTalentSpecialValueFor("charge_restore_time") * self:GetParent():GetCooldownReduction()

			if self:GetParent():HasScepter() and self:GetAbility():GetTalentSpecialValueFor("charge_restore_time_scepter") and self:GetAbility():GetTalentSpecialValueFor("charge_restore_time_scepter") > 0 then
				charge_time		= self:GetAbility():GetTalentSpecialValueFor("charge_restore_time_scepter") * self:GetParent():GetCooldownReduction()
			end

			self:StartIntervalThink( charge_time )
			self:SetDuration( charge_time, true )
		end

		-- set on cooldown if no charges
		if self:GetStackCount() == 0 then
			self:GetAbility():EndCooldown()
			self:GetAbility():StartCooldown(self:GetRemainingTime())
		else
			self:GetAbility():EndCooldown()

			if self:GetAbility():GetName() ~= "imba_gyrocopter_homing_missile" and self:GetAbility():GetName() ~= "imba_void_spirit_astral_step" and self:GetAbility():GetName() ~= "imba_void_spirit_astral_step_helper_2" then
				self:GetAbility():StartCooldown(0.25)
			end
		end
	end

	Timers:CreateTimer(FrameTime() * 2, function()
		CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "update_charge_count", {
			unit_index = self:GetParent():entindex(),
			ability_index = self:GetRightfulAbilityIndex(),
		})
	end)
end
