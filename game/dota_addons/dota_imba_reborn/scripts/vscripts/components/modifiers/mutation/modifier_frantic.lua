modifier_frantic = modifier_frantic or class({})

----------------------------------------------------------------------
-- Frantic handler
----------------------------------------------------------------------

modifier_frantic = modifier_frantic or class({})

function modifier_frantic:IsDebuff() return false end
function modifier_frantic:RemoveOnDeath() return false end
function modifier_frantic:IsPurgable() return false end
function modifier_frantic:IsPurgeException() return false end

function modifier_frantic:GetTexture()
	return "custom/frantic"
end

-- Update this list here with abilities you don't want affected by frantic CDR
-- (it would be best to also update their tooltips in the respective separate files)
function modifier_frantic:OnCreated()
	self.ignore_frantic_cdr_abilities = {
		["imba_venomancer_plague_ward"]	= true,
		["imba_puck_phase_shift"] = true
	}
end

function modifier_frantic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		
		-- MODIFIER_EVENT_ON_ABILITY_START,
		-- MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}

	return funcs
end

function modifier_frantic:GetEffectName()
	return "particles/generic_gameplay/frantic.vpcf"
end

function modifier_frantic:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_frantic:GetModifierPercentageCooldownStacking()
	if self:GetStackCount() == CustomNetTables:GetTableValue("game_options", "frantic").frantic then
		if keys.ability and self.ignore_frantic_cdr_abilities[keys.ability:GetName()] then
			return nil
		else
			return self:GetStackCount()
		end
	end
end

function modifier_frantic:GetModifierPercentageCooldown(keys)
	if self:GetStackCount() == CustomNetTables:GetTableValue("game_options", "frantic").super_frantic then
		if keys.ability and self.ignore_frantic_cdr_abilities[keys.ability:GetName()] then
			return nil
		else
			return self:GetStackCount()
		end
	end
end

function modifier_frantic:GetModifierPercentageManacost()
	return self:GetStackCount()
end

function modifier_frantic:GetModifierStatusResistanceStacking()
	return self:GetStackCount()
end

-- Was another way to apply these effects but I needed something client-side as well
-- function modifier_frantic:OnAbilityStart(keys)
	-- if keys.ability and keys.ability:GetName() and IMBA_ABILITIES_IGNORE_FRANTIC_CDR and IMBA_ABILITIES_IGNORE_FRANTIC_CDR[keys.ability:GetName()] then
		-- self.stack_count	= self:GetStackCount()
		-- self:SetStackCount(0)
	-- end
-- end

-- function modifier_frantic:OnAbilityFullyCast(keys)
	-- if keys.ability and keys.ability:GetName() and IMBA_ABILITIES_IGNORE_FRANTIC_CDR and IMBA_ABILITIES_IGNORE_FRANTIC_CDR[keys.ability:GetName()] then
		-- self:SetStackCount(self.stack_count)
	-- end
-- end
