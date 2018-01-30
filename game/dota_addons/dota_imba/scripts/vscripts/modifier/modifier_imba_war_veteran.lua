-- Author: Cookies
-- 30/01/2018 // DD/MM/YYYY

modifier_imba_war_veteran = class({})

function modifier_imba_war_veteran:IsPurgable() return false end
function modifier_imba_war_veteran:IsHidden() return false end
function modifier_imba_war_veteran:IsPermanent() return true end

function modifier_imba_war_veteran:OnCreated()
	self.hp_regen = 2				-- +50 health regen
	self.status_resistance = 1		-- +25% tenacity

	self.attack_speed = 3			-- +75 attack speed
	self.movespeed_pct = 1			-- +25% movespeed

	self.spell_amp = 2				-- +50% spell amp
	self.magic_resist = 1			-- +25% MR

	if IsServer() then
		self.primary_attribute = self:GetParent():GetPrimaryAttribute()
	end
end

function modifier_imba_war_veteran:GetTexture()
	print("custom/war_veteran_"..self.primary_attribute)
	return "custom/war_veteran_"..self.primary_attribute
end

function modifier_imba_war_veteran:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

function modifier_imba_war_veteran:GetModifierConstantHealthRegen()
	if self.primary_attribute ~= 0 then return 0 end
	return self.hp_regen * (self:GetParent():GetLevel() - 25)
end

function modifier_imba_war_veteran:GetCustomTenacity()
	if self.primary_attribute ~= 0 then return 0 end
	return self.status_resistance * (self:GetParent():GetLevel() - 25)
end

function modifier_imba_war_veteran:GetModifierAttackSpeedBonus_Constant()
	if self.primary_attribute ~= 1 then return 0 end
	return self.attack_speed * (self:GetParent():GetLevel() - 25)
end

function modifier_imba_war_veteran:GetModifierMoveSpeedBonus_Percentage()
	if self.primary_attribute ~= 1 then return 0 end
	return self.movespeed_pct * (self:GetParent():GetLevel() - 25)
end

function modifier_imba_war_veteran:GetModifierSpellAmplify_Percentage()
	if self.primary_attribute ~= 2 then return 0 end
	return self.spell_amp * (self:GetParent():GetLevel() - 25)
end

function modifier_imba_war_veteran:GetModifierMagicalResistanceBonus()
	if self.primary_attribute ~= 2 then return 0 end
	return self.magic_resist * (self:GetParent():GetLevel() - 25)
end
