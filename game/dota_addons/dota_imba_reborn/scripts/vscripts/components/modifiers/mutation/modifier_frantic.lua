modifier_frantic = modifier_frantic or class({})

LinkLuaModifier("modifier_frantic_cdr_talent_handler", "components/modifiers/mutation/modifier_frantic", LUA_MODIFIER_MOTION_NONE)

modifier_frantic_cdr_talent_handler = class({})

----------------------------------------------------------------------
-- Frantic handler
----------------------------------------------------------------------

modifier_frantic = modifier_frantic or class({})

function modifier_frantic:DestroyOnExpire()	return false end
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
		["imba_venomancer_plague_ward"]			= true,
		["imba_puck_phase_shift"] 				= true,
		["imba_riki_tricks_of_the_trade_723"] 	= true
	}
	
	-- self.ignore_frantic_sr_abilities = {
		-- ["modifier_legion_commander_duel"]			= true
	-- }
	
	-- This may get updated by Valve over-time, in which case it will have to manually updated...zzz
	self.cdr_talents = {
		"special_bonus_cooldown_reduction_6",
		"special_bonus_cooldown_reduction_8",
		"special_bonus_cooldown_reduction_10",
		"special_bonus_cooldown_reduction_12",
		"special_bonus_cooldown_reduction_14",
		"special_bonus_cooldown_reduction_15",
		"special_bonus_cooldown_reduction_20",
		"special_bonus_cooldown_reduction_25",
		"special_bonus_cooldown_reduction_30",
		"special_bonus_cooldown_reduction_40",
		"special_bonus_cooldown_reduction_50",
		"special_bonus_cooldown_reduction_65" -- jfc who was this talent made for	
	}

	-- SPAGHETTI OVERFLOWS MY COLANDER
	if self:GetParent().AddNewModifier then
		self.cdr_talent_modifier = self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_frantic_cdr_talent_handler", {})	
	end

	if self:GetParent().HasAbility then
		for index = 1, #self.cdr_talents do
			if self:GetParent():HasAbility(self.cdr_talents[index]) and self:GetParent():FindAbilityByName(self.cdr_talents[index]):IsTrained() then				
				if self.cdr_talent_modifier then
					self.cdr_talent_modifier:SetStackCount(self.cdr_talent_modifier:GetStackCount() + tonumber(string.sub(self.cdr_talents[index], 34)))
				end
			end
		end
	end
	
	self.cooldown_reduction	= self:GetParent():GetCooldownReduction() / (1 - (self:GetParent():GetModifierStackCount("modifier_frantic_cdr_talent_handler", self:GetParent()) * 0.01))
	
	-- This IntervalThink is primarily to manually handle cooldown percentages, and to cap CDR at 40% ONLY EXCEPT when base CDR exceeds that, in which case it would be as though this modifier did not provide any CDR
	self:StartIntervalThink(0.1)
end

function modifier_frantic:OnIntervalThink()
	self.cooldown_reduction	= 0

	if self.cdr_talent_modifier then
		self.cdr_talent_modifier:SetStackCount(0)
	end

	if self:GetParent().HasAbility then
		for index = 1, #self.cdr_talents do
			if self:GetParent():HasAbility(self.cdr_talents[index]) and self:GetParent():FindAbilityByName(self.cdr_talents[index]):IsTrained() then
				if not self:GetParent():HasModifier("modifier_frantic_cdr_talent_handler") then
					self.cdr_talent_modifier = self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_frantic_cdr_talent_handler", {})
				end
				
				if self.cdr_talent_modifier then
					self.cdr_talent_modifier:SetStackCount(self.cdr_talent_modifier:GetStackCount() + tonumber(string.sub(self.cdr_talents[index], 34)))
				end
			end
		end
	end
	
	self.cooldown_reduction	= self:GetParent():GetCooldownReduction() / (1 - (self:GetParent():GetModifierStackCount("modifier_frantic_cdr_talent_handler", self:GetParent()) * 0.01))
end

function modifier_frantic:OnDestroy()
	if not IsServer() then return end
	
	if self:GetParent():HasModifier("modifier_frantic_cdr_talent_handler") then
		self:GetParent():RemoveModifierByName("modifier_frantic_cdr_talent_handler")
	end
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
		
		-- MODIFIER_EVENT_ON_MODIFIER_ADDED
	}
end

function modifier_frantic:GetEffectName()
	return "particles/generic_gameplay/frantic.vpcf"
end

function modifier_frantic:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_frantic:GetModifierPercentageCooldownStacking(keys)
	print(self:GetStackCount(), CustomNetTables:GetTableValue("game_options", "frantic").frantic)
	print(type(self:GetStackCount()), type(CustomNetTables:GetTableValue("game_options", "frantic").frantic))
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
--	if self:GetStackCount() == CustomNetTables:GetTableValue("game_options", "frantic").super_frantic then
		if keys.ability and self.ignore_frantic_cdr_abilities[keys.ability:GetName()] then
			return nil
		else
			-- return self:GetStackCount()
			
			if self.cooldown_reduction then
				return math.max(((self:GetStackCount() - 100) / self.cooldown_reduction) + 100, 0)
			end
		end
--	end
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

-- function modifier_frantic:OnModifierAdded(keys)
	-- if keys.unit == self:GetParent() and self.ignore_frantic_sr_abilities and self:GetParent().FindAllModifiers and #self:GetParent():FindAllModifiers() > 0 and self.ignore_frantic_sr_abilities[self:GetParent():FindAllModifiers()[#self:GetParent():FindAllModifiers()]:GetName()] then
		-- self:GetParent():FindAllModifiers()[#self:GetParent():FindAllModifiers()]:SetDuration(self:GetParent():FindAllModifiers()[#self:GetParent():FindAllModifiers()]:GetDuration() / ((100 - self:GetStackCount()) * 0.01), true)
	-- end
-- end

--------------

function modifier_frantic_cdr_talent_handler:IsHidden()			return true end
function modifier_frantic_cdr_talent_handler:IsPurgable()		return false end
function modifier_frantic_cdr_talent_handler:RemoveOnDeath()	return false end

-- function modifier_frantic_cdr_talent_handler:DeclareFunctions()
	-- return {
		-- MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		-- -- MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING -- Did they...break this or something?
	-- }
-- end

-- function modifier_frantic_cdr_talent_handler:GetModifierPercentageCooldown(keys)
	-- return self:GetStackCount()
-- end

-- -- function modifier_frantic_cdr_talent_handler:GetModifierPercentageCooldownStacking()
	-- -- return self:GetStackCount()
-- -- end
