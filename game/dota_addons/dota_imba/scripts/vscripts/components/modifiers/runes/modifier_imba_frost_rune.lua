-- Custom Model Author: Champi Suicidaire

LinkLuaModifier("modifier_imba_frost_rune_aura", "components/modifiers/runes/modifier_imba_frost_rune", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_rune_slow", "components/modifiers/runes/modifier_imba_frost_rune", LUA_MODIFIER_MOTION_NONE)

item_imba_rune_frost = item_imba_rune_frost or class({})

modifier_imba_frost_rune = modifier_imba_frost_rune or class({})

-- Modifier properties
function modifier_imba_frost_rune:IsHidden() return false end
function modifier_imba_frost_rune:IsPurgable() return true end
function modifier_imba_frost_rune:IsDebuff() return false end

function modifier_imba_frost_rune:GetTexture()
	return "custom/imba_rune_frost"
end

function modifier_imba_frost_rune:OnCreated(keys)
	self.slow_duration = CustomNetTables:GetTableValue("game_options", "runes").frost_rune_slow_duration
end

-- Function declarations
function modifier_imba_frost_rune:DeclareFunctions()
	local funcs	= {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_imba_frost_rune:OnAttackLanded(kv)
	if (kv.attacker == self:GetParent()) and (kv.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber()) then
		kv.target:AddNewModifier(kv.attacker, nil, "modifier_imba_frost_rune_slow", {duration = self.slow_duration})
	end
end

function modifier_imba_frost_rune:OnTakeDamage(keys)
	if IsServer() then
		local target = keys.unit
		if keys.attacker:GetTeam() == target:GetTeam() or keys.attacker:IsBuilding() or keys.attacker == target then
			return
		end

		if self:GetParent() == target then
			keys.attacker:AddNewModifier(target, nil, "modifier_imba_frost_rune_slow", {duration = self.slow_duration})
		end
	end
end

-- Aura properties
function modifier_imba_frost_rune:IsAura() return true end
function modifier_imba_frost_rune:GetAuraRadius() return CustomNetTables:GetTableValue("game_options", "runes").rune_radius_effect end
function modifier_imba_frost_rune:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_frost_rune:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_frost_rune:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_imba_frost_rune:GetModifierAura()
	return "modifier_imba_frost_rune_aura"
end

function modifier_imba_frost_rune:GetAuraEntityReject(target)
	if target == self:GetCaster() then
        return true
    end
	return false
end

function modifier_imba_frost_rune:GetEffectName()
	return "particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_overhead.vpcf"
end

function modifier_imba_frost_rune:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--- MINOR AURA MODIFIER
modifier_imba_frost_rune_aura = modifier_imba_frost_rune_aura or class({})

-- Modifier properties
function modifier_imba_frost_rune_aura:IsHidden() 	return false end
function modifier_imba_frost_rune_aura:IsPurgable()	return false end
function modifier_imba_frost_rune_aura:IsDebuff() 	return false end

function modifier_imba_frost_rune_aura:GetTextureName()
	return "custom/imba_rune_frost"
end

-- Function declarations
function modifier_imba_frost_rune_aura:DeclareFunctions()
	local funcs	=	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_imba_frost_rune_aura:OnAttackLanded(kv)
	if (kv.attacker == self:GetParent()) and (kv.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber()) and (kv.attacker:GetTeam() ~= self:GetParent():GetTeam()) then
		kv.target:AddNewModifier(kv.attacker, nil, "modifier_imba_frost_rune_slow", {duration = self.slow_duration})
	end
end

function modifier_imba_frost_rune_aura:OnTakeDamage(keys)
	if IsServer() then
		local target = keys.unit
		if keys.attacker:GetTeam() == target:GetTeam() or keys.attacker:IsBuilding() then
			return
		end

		if self:GetParent() == target then
			keys.attacker:AddNewModifier(target, nil, "modifier_imba_frost_rune_slow", {duration = self.slow_duration})
		end
	end
end

function modifier_imba_frost_rune_aura:GetEffectName()
	return "particles/econ/courier/courier_greevil_blue/courier_greevil_blue_ambient_3.vpcf"
end

function modifier_imba_frost_rune_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-----------------------------------------------------------------------------------

if modifier_imba_frost_rune_slow == nil then modifier_imba_frost_rune_slow = class({}) end
function modifier_imba_frost_rune_slow:IsHidden() return false end
function modifier_imba_frost_rune_slow:IsDebuff() return true end
function modifier_imba_frost_rune_slow:IsPurgable() return true end

-- Modifier status effect
function modifier_imba_frost_rune_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf" end

function modifier_imba_frost_rune_slow:StatusEffectPriority()
	return 10
end

-- Declare modifier events/properties
function modifier_imba_frost_rune_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_imba_frost_rune_slow:GetModifierAttackSpeedBonus_Constant()
	return CustomNetTables:GetTableValue("game_options", "runes").frost_rune_attack_slow
end

function modifier_imba_frost_rune_slow:GetModifierMoveSpeedBonus_Percentage()
	return CustomNetTables:GetTableValue("game_options", "runes").frost_rune_move_speed_slow
end
