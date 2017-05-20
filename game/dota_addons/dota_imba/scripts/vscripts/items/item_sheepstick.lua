--	Author: Firetoad
--	Date: 			09.05.2015
--	Last Update:	18.03.2017

-----------------------------------------------------------------------------------------------------------
--	Sheepstick definition
-----------------------------------------------------------------------------------------------------------

if item_imba_sheepstick == nil then item_imba_sheepstick = class({}) end
LinkLuaModifier( "modifier_item_imba_sheepstick", "items/item_sheepstick.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_sheepstick_debuff", "items/item_sheepstick.lua", LUA_MODIFIER_MOTION_NONE )	-- Enemy debuff
LinkLuaModifier( "modifier_item_imba_sheepstick_buff", "items/item_sheepstick.lua", LUA_MODIFIER_MOTION_NONE )		-- Self-use buff

function item_imba_sheepstick:GetIntrinsicModifierName()
	return "modifier_item_imba_sheepstick" end

function item_imba_sheepstick:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		
		-- Can't cast on allies, except for yourself
		if caster:GetTeam() == target:GetTeam() and caster ~= target then
			return UF_FAIL_CUSTOM
		elseif caster:GetTeam() ~= target:GetTeam() and target:IsMagicImmune() then
			return UF_FAIL_CUSTOM
		elseif target:IsBuilding() then
			return UF_FAIL_CUSTOM
		elseif target:HasModifier("modifier_item_imba_sheepstick_debuff") or target:HasModifier("modifier_imba_lion_hex") or target:HasModifier("modifier_shadow_shaman_voodoo") then
			return UF_FAIL_CUSTOM
		end
		return UF_SUCCESS
	end
end

function item_imba_sheepstick:GetCustomCastErrorTarget(target)
	local caster = self:GetCaster()
	if caster:GetTeam() == target:GetTeam() and caster ~= target then
		return "#dota_hud_error_only_cast_on_self"
	elseif caster:GetTeam() ~= target:GetTeam() and target:IsMagicImmune() then
		return "#dota_hud_error_target_magic_immune"
	elseif target:IsBuilding() then
		return "#dota_hud_error_cant_cast_on_building"
	elseif target:HasModifier("modifier_item_imba_sheepstick_debuff") or target:HasModifier("modifier_imba_lion_hex") or target:HasModifier("modifier_shadow_shaman_voodoo") then
		return "#dota_hud_error_cant_use_already_hexed"
	end
end

function item_imba_sheepstick:OnSpellStart()
	if IsServer() then
		-- Parameters
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local hex_duration = self:GetSpecialValueFor("hex_duration")

		-- If the target possesses a ready Linken's Sphere, do nothing
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(self) then
				return nil
			end
		end

		-- Play the cast sound
		target:EmitSound("DOTA_Item.Sheepstick.Activate")

		-- Play the target particle
		local sheep_pfx = ParticleManager:CreateParticle("particles/items_fx/item_sheepstick.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(sheep_pfx, 0, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(sheep_pfx)

		-- Kill the target instantly if it is an illusion
		if target:IsIllusion() then
			target:ForceKill(true)
			return
		end

		-- If the target is yourself, apply the buff and purge, else, the debuff
		if caster == target then
			target:AddNewModifier(caster, self, "modifier_item_imba_sheepstick_buff", {duration = hex_duration})
			target:Purge(false, true, false, false, false)
		else
			target:AddNewModifier(caster, self, "modifier_item_imba_sheepstick_debuff", {duration = hex_duration})
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Sheepstick owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sheepstick == nil then modifier_item_imba_sheepstick = class({}) end
function modifier_item_imba_sheepstick:IsHidden() return true end
function modifier_item_imba_sheepstick:IsDebuff() return false end
function modifier_item_imba_sheepstick:IsPurgable() return false end
function modifier_item_imba_sheepstick:IsPermanent() return true end
function modifier_item_imba_sheepstick:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Attribute bonuses
function modifier_item_imba_sheepstick:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
	}
	return funcs
end

function modifier_item_imba_sheepstick:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_strength") end

function modifier_item_imba_sheepstick:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agility") end

function modifier_item_imba_sheepstick:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_intellect") end

function modifier_item_imba_sheepstick:GetModifierPercentageManaRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end

-----------------------------------------------------------------------------------------------------------
--	Sheepstick enemy debuff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sheepstick_debuff == nil then modifier_item_imba_sheepstick_debuff = class({}) end
function modifier_item_imba_sheepstick_debuff:IsHidden() return false end
function modifier_item_imba_sheepstick_debuff:IsDebuff() return true end
function modifier_item_imba_sheepstick_debuff:IsPurgable() return true end

-- Declare modifier events/properties
function modifier_item_imba_sheepstick_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
	return funcs
end

function modifier_item_imba_sheepstick_debuff:GetModifierMoveSpeedOverride()
	return self:GetAbility():GetSpecialValueFor("enemy_move_speed") end

function modifier_item_imba_sheepstick_debuff:GetModifierModelChange()
	return "models/props_gameplay/pig.vmdl" end

-- Hexed state
function modifier_item_imba_sheepstick_debuff:CheckState()
	local states = {
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
	}
	return states
end

-----------------------------------------------------------------------------------------------------------
--	Sheepstick self-buff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sheepstick_buff == nil then modifier_item_imba_sheepstick_buff = class({}) end
function modifier_item_imba_sheepstick_buff:IsHidden() return false end
function modifier_item_imba_sheepstick_buff:IsDebuff() return false end
function modifier_item_imba_sheepstick_buff:IsPurgable() return true end

-- Destroy trees at the end of the self-buff's duration
function modifier_item_imba_sheepstick_buff:OnDestroy()
	if IsServer() then
		local owner = self:GetParent()
		GridNav:DestroyTreesAroundPoint(owner:GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("tree_radius"), false)
	end
end

-- Base movement speed override
function modifier_item_imba_sheepstick_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
	return funcs
end

function modifier_item_imba_sheepstick_buff:GetModifierMoveSpeedOverride()
	return self:GetAbility():GetSpecialValueFor("self_move_speed") end

function modifier_item_imba_sheepstick_buff:GetModifierModelChange()
	return "models/items/courier/mighty_chicken/mighty_chicken_flying.vmdl" end

-- Hexed state
function modifier_item_imba_sheepstick_buff:CheckState()
	local states = {
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
	}
	return states
end