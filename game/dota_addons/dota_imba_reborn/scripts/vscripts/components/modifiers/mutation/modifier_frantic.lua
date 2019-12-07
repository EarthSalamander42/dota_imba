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
	
	self.cooldown_reduction	= self:GetParent():GetCooldownReduction()
	
	-- This IntervalThink is primarily to manually handle cooldown percentages, and to cap CDR at 40% ONLY EXCEPT when base CDR exceeds that, in which case it would be as though this modifier did not provide any CDR
	self:StartIntervalThink(0.1)
end

function modifier_frantic:OnIntervalThink()
	self.cooldown_reduction	= 0
	self.cooldown_reduction	= self:GetParent():GetCooldownReduction()
end

function modifier_frantic:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		-- MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_STATUS_RESISTANCE,
		
		-- MODIFIER_EVENT_ON_ABILITY_START,
		-- MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
end

function modifier_frantic:GetEffectName()
	return "particles/generic_gameplay/frantic.vpcf"
end

function modifier_frantic:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_frantic:GetModifierPercentageCooldownStacking(keys)
	if self:GetStackCount() == CustomNetTables:GetTableValue("game_options", "frantic").frantic then
		if keys.ability and self.ignore_frantic_cdr_abilities[keys.ability:GetName()] then
			return nil
		else
			-- return self:GetStackCount()
			
			if self.cooldown_reduction then
				-- Big brain math
				return math.max(((self:GetStackCount() - 100) / self.cooldown_reduction) + 100, 0)
			end
		end
	end
end

function modifier_frantic:GetModifierPercentageCooldown(keys)
	if self:GetStackCount() == CustomNetTables:GetTableValue("game_options", "frantic").super_frantic then
		if keys.ability and self.ignore_frantic_cdr_abilities[keys.ability:GetName()] then
			return nil
		else
			-- return self:GetStackCount()
			
			if self.cooldown_reduction then
				return math.max(((self:GetStackCount() - 100) / self.cooldown_reduction) + 100, 0)
			end
		end
	end
end

function modifier_frantic:GetModifierPercentageManacost()
	return self:GetStackCount()
end

-- function modifier_frantic:GetModifierStatusResistanceStacking()
	-- return self:GetStackCount()
-- end

function modifier_frantic:GetModifierStatusResistance()
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
