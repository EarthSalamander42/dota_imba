LinkLuaModifier("modifier_imba_regen_rune_aura", "components/modifiers/runes/modifier_imba_regen_rune", LUA_MODIFIER_MOTION_NONE)

modifier_imba_regen_rune = modifier_imba_regen_rune or class({})

-- Modifier property stuff
function modifier_imba_regen_rune:IsDebuff() return false end
function modifier_imba_regen_rune:IsPurgable() return true end
-- Aura stuff
function modifier_imba_regen_rune:IsAura() return true end
function modifier_imba_regen_rune:GetAuraRadius() return CustomNetTables:GetTableValue("game_options", "runes").rune_radius_effect end
function modifier_imba_regen_rune:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_regen_rune:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_regen_rune:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_regen_rune:GetModifierAura() return "modifier_imba_regen_rune_aura" end

function modifier_imba_regen_rune:GetTexture()
	return "rune_regen"
end

function modifier_imba_regen_rune:GetEffectName()
	return "particles/generic_gameplay/rune_regen_owner.vpcf"
end

function modifier_imba_regen_rune:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Parent doesn't benefit from aura, since it has it's own modifier
function modifier_imba_regen_rune:GetAuraEntityReject(entity)
	if entity == self:GetParent() then
		return true
	end
	return false
end

function modifier_imba_regen_rune:OnCreated()

	-- Set the amount of damage instances we can take as stacks
	self:SetStackCount(CustomNetTables:GetTableValue("game_options", "runes").regen_rune_stacks)
end

function modifier_imba_regen_rune:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
				MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
				MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
				MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
				MODIFIER_EVENT_ON_TAKEDAMAGE}
	return funcs
end

function modifier_imba_regen_rune:GetModifierConstantHealthRegen()
	return CustomNetTables:GetTableValue("game_options", "runes").regen_rune_heal_base
end

function modifier_imba_regen_rune:GetModifierHealthRegenPercentage()
	return CustomNetTables:GetTableValue("game_options", "runes").regen_rune_heal_pct
end

function modifier_imba_regen_rune:GetModifierConstantManaRegen()
	return CustomNetTables:GetTableValue("game_options", "runes").regen_rune_mana_base
end

function modifier_imba_regen_rune:GetModifierTotalPercentageManaRegen()
	return CustomNetTables:GetTableValue("game_options", "runes").regen_rune_mana_pct
end

-- Decrease damage instance stacks on hero damage recieved, if we lose all stacks, remove modifier
function modifier_imba_regen_rune:OnTakeDamage(params)
	local victim = params.unit
	local attacker = params.attacker

	-- Only damage from hero/roshan units count towards the damage instances
	if self:GetCaster() == victim and (attacker:IsHeroDamage(params.damage) or attacker:IsTower()) then
		local current_stacks = self:GetStackCount()

		-- last stack, remove modifier
		if current_stacks == 1 then
			self:Destroy()
		-- not last stack, decrease by 1
		else
			self:SetStackCount(current_stacks - 1)
		end
	end
end

---------------------------------------------------------
-- Regeneration rune team aura
---------------------------------------------------------
modifier_imba_regen_rune_aura = modifier_imba_regen_rune_aura or class({})
function modifier_imba_regen_rune_aura:IsDebuff() return false end

function modifier_imba_regen_rune_aura:GetTextureName()
	return "rune_regen"
end

function modifier_imba_regen_rune_aura:GetEffectName()
	return "particles/generic_gameplay/rune_regen_owner.vpcf"
end

function modifier_imba_regen_rune_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_regen_rune_aura:OnCreated()
	self.hp_regen_base_aura = 50	/2
	self.hp_regen_perc_aura = 5		/2
	self.mp_regen_base_aura = 20	/2
	self.mp_regen_perc_aura = 2		/2
end

function modifier_imba_regen_rune_aura:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
				MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
				MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
				MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE}
	return funcs
end

function modifier_imba_regen_rune_aura:GetModifierConstantHealthRegen()
	return CustomNetTables:GetTableValue("game_options", "runes").regen_rune_heal_base / 2
end

function modifier_imba_regen_rune_aura:GetModifierHealthRegenPercentage()
	return CustomNetTables:GetTableValue("game_options", "runes").regen_rune_heal_pct / 2
end

function modifier_imba_regen_rune_aura:GetModifierConstantManaRegen()
	return CustomNetTables:GetTableValue("game_options", "runes").regen_rune_mana_base / 2
end

function modifier_imba_regen_rune_aura:GetModifierTotalPercentageManaRegen()
	return CustomNetTables:GetTableValue("game_options", "runes").regen_rune_mana_pct / 2
end
