-- Creator:
-- 	AltiV - March 10th, 2019

LinkLuaModifier("modifier_item_imba_ghost", "components/items/item_ghost.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ghost_state", "components/items/item_ghost.lua", LUA_MODIFIER_MOTION_NONE)

item_imba_ghost				= class({})
modifier_item_imba_ghost	= class({})
modifier_imba_ghost_state	= class({})

------------------------
-- GHOST SCEPTER BASE --
------------------------

function item_imba_ghost:GetIntrinsicModifierName()
	return "modifier_item_imba_ghost"
end

function item_imba_ghost:OnSpellStart()
	self.caster		= self:GetCaster()
	
	-- AbilitySpecials
	self.duration					=	self:GetSpecialValueFor("duration")

	if not IsServer() then return end
	
	-- Play the cast sound
	self.caster:EmitSound("DOTA_Item.GhostScepter.Activate")
	
	-- Apply the Ethereal modifier
	self.caster:AddNewModifier(self.caster, self, "modifier_imba_ghost_state", {duration = self.duration})
	self.caster:AddNewModifier(self.caster, self, "modifier_item_imba_gem_of_true_sight", {duration = self.duration}) -- The radius was designated with the "radius" KV for the item in npc_items_custom.txt (guess that's just how it works)
end

--------------------------
-- GHOST STATE MODIFIER --
--------------------------
-- TODO: Change Pugna and Necrophos Ethereal to also use decrepify modifier property

function modifier_imba_ghost_state:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_imba_ghost_state:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.ability					= self:GetAbility()
	self.caster						= self:GetCaster()
	self.parent						= self:GetParent()
	
	self.extra_spell_damage_percent		= self.ability:GetSpecialValueFor("extra_spell_damage_percent")
	self.luminate_radius				= self.ability:GetSpecialValueFor("luminate_radius")
	
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_ghost_state:OnIntervalThink()
	if not IsServer() then return end

	AddFOWViewer(self.caster:GetTeam(), self.parent:GetAbsOrigin(), self.luminate_radius, FrameTime(), false)
	
	-- Remove itself if owner becomes spell immune (and the relevant truesight modifier)
	if self.parent:IsMagicImmune() then
		local truesight_modifiers = self.parent:FindAllModifiersByName("modifier_item_imba_gem_of_true_sight")
		
		for _, truesight_mod in pairs(truesight_modifiers) do
			if truesight_mod:GetAbility() == self.ability then
				truesight_mod:Destroy()
			end
		end

		self:Destroy()
	end
end

function modifier_imba_ghost_state:OnRefresh()
	self:OnCreated()
end

function modifier_imba_ghost_state:CheckState()
	local state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true
	}
	
	return state
end

function modifier_imba_ghost_state:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		
		-- IMBAfication: Extrasensory
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
    }
	
	return decFuncs
end

function modifier_imba_ghost_state:GetModifierMagicalResistanceDecrepifyUnique()
    return self.extra_spell_damage_percent
end

function modifier_imba_ghost_state:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_imba_ghost_state:GetModifierIgnoreCastAngle()
	if self:GetParent():GetTeam() == self:GetCaster():GetTeam() then
		return 1
	end
end

----------------------------
-- GHOST SCEPTER MODIFIER --
----------------------------

function modifier_item_imba_ghost:IsHidden()		return true end
function modifier_item_imba_ghost:IsPurgable()		return false end
function modifier_item_imba_ghost:RemoveOnDeath()	return false end
function modifier_item_imba_ghost:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_ghost:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.ability	= self:GetAbility()

	-- AbilitySpecials
	self.bonus_all_stats		=	self.ability:GetSpecialValueFor("bonus_all_stats")
	
	if not IsServer() then return end
end

function modifier_item_imba_ghost:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
	
    return decFuncs
end

function modifier_item_imba_ghost:GetModifierBonusStats_Strength()
	return self.bonus_all_stats
end

function modifier_item_imba_ghost:GetModifierBonusStats_Agility()
	return self.bonus_all_stats
end

function modifier_item_imba_ghost:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats
end
