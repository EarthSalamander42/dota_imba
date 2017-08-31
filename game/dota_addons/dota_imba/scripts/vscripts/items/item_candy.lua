-- Author: Shush
-- Date: 31/07/2017

item_diretide_candy = class({})
LinkLuaModifier("modifier_diretide_candy_hp_loss", "items/item_candy", LUA_MODIFIER_MOTION_NONE)

function item_diretide_candy:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local modifier_candy = caster:FindModifierByName("modifier_diretide_candy_hp_loss")

		if target:GetTeam() == DOTA_TEAM_GOODGUYS then
			CustomNetTables:SetTableValue("game_options", "radiant", {score = CustomNetTables:GetTableValue("game_options", "radiant").score +1})
		elseif target:GetTeam() == DOTA_TEAM_BADGUYS then
			CustomNetTables:SetTableValue("game_options", "dire", {score = CustomNetTables:GetTableValue("game_options", "dire").score +1})
		end

		self:SetCurrentCharges(self:GetCurrentCharges()-1)
		if self:GetCurrentCharges() <= 0 then self:RemoveSelf() end
	end
end

function item_diretide_candy:GetIntrinsicModifierName()
	return "modifier_diretide_candy_hp_loss"
end

modifier_diretide_candy_hp_loss = class({})

function modifier_diretide_candy_hp_loss:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()    

		-- Ability specials
		self.hp_loss_pct = self.ability:GetSpecialValueFor("hp_loss_pct")

		-- Start thinking
		self:StartIntervalThink(0.3)
	end
end

function modifier_diretide_candy_hp_loss:OnIntervalThink()
	if IsServer() then
		-- Get the current amount of charges of this item and set the stack count accordingly        
		if self.ability then
			local charges = self.ability:GetCurrentCharges()
			self:SetStackCount(charges)
		end

		-- Re-calculate health stats
		self.caster:CalculateStatBonus()
	end
end

function modifier_diretide_candy_hp_loss:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE}

	return decFuncs
end

function modifier_diretide_candy_hp_loss:GetModifierExtraHealthPercentage()
	if IsServer() then
		local hp_to_reduce = self.hp_loss_pct * 0.01 * self:GetStackCount() * (-1)
		-- Make sure you don't go over 100%
		if hp_to_reduce > 99 then
			return 99
		end

		return hp_to_reduce
	end
end

function modifier_diretide_candy_hp_loss:CastFilterResultTarget(target)
	if IsServer() then
		if target:GetUnitName() == "npc_dota_candy_pumpkin" then
			return UF_SUCCESS
		end
		return UF_FAIL_CUSTOM
	end
end

function modifier_diretide_candy_hp_loss:GetCustomCastErrorTarget(target) 
	if IsServer() then
		return "#dota_hud_error_cast_only_pumpkin"
	end
end
