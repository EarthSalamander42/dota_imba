-- Main logic taken from Valve's Slitbreaker dungeon files

-- Reformatted for DotA IMBA by:
-- 	AltiV - March 16th, 2019

-----------------------------
-- GLIMMERDARK SHIELD FILE --
-----------------------------

item_imba_glimmerdark_shield = class({})
LinkLuaModifier( "modifier_item_imba_glimmerdark_shield", "components/items/item_glimmerdark_shield", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_imba_glimmerdark_shield_prism", "components/items/item_glimmerdark_shield", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_imba_glimmerdark_shield:OnSpellStart()
	self.prism_duration = self:GetSpecialValueFor( "prism_duration" )

	if IsServer() then
		local hCaster = self:GetCaster()
		hCaster:AddNewModifier( hCaster, self, "modifier_item_imba_glimmerdark_shield_prism", { duration = self.prism_duration } )

		hCaster:AddNewModifier( hCaster, self, "modifier_item_imba_gem_of_true_sight", { duration = self.prism_duration } ) -- The radius was designated with the "radius" KV for the item in npc_items_custom.txt (guess that's just how it works)

		EmitSoundOn( "DOTA_Item.GhostScepter.Activate", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function item_imba_glimmerdark_shield:GetIntrinsicModifierName()
	return "modifier_item_imba_glimmerdark_shield"
end

--------------------------------------------------------------------------------

-- function item_imba_glimmerdark_shield:Spawn()
	-- self.required_level = self:GetSpecialValueFor( "required_level" )
-- end

--------------------------------------------------------------------------------

-- function item_imba_glimmerdark_shield:OnHeroLevelUp()
	-- if IsServer() then
		-- if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			-- self:OnUnequip()
			-- self:OnEquip()
		-- end
	-- end
-- end

--------------------------------------------------------------------------------

-- function item_imba_glimmerdark_shield:IsMuted()
	-- if self.required_level > self:GetCaster():GetLevel() then
		-- return true
	-- end
	-- if not self:GetCaster():IsHero() then
		-- return true
	-- end
	
	-- return self.BaseClass.IsMuted( self )
-- end

--------------------------------------------------------------------------------

---------------------------------------
-- GLIMMERDARK SHIELD PRISM MODIFIER --
---------------------------------------


modifier_item_imba_glimmerdark_shield_prism = class({})

--------------------------------------------------------------------------------

--[[
function modifier_item_imba_glimmerdark_shield_prism:GetEffectName()
	return "particles/act_2/gleam.vpcf"
end
]]

--------------------------------------------------------------------------------

function modifier_item_imba_glimmerdark_shield_prism:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

--------------------------------------------------------------------------------

-- function modifier_item_imba_glimmerdark_shield_prism:GetTexture()
	-- return "item_imba_glimmerdark_shield"
-- end

--------------------------------------------------------------------------------

function modifier_item_imba_glimmerdark_shield_prism:IsPurgable()
	return true -- originally false but for balance's sake let's make it purgable...
end

--------------------------------------------------------------------------------

function modifier_item_imba_glimmerdark_shield_prism:OnCreated( kv )
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.prism_bonus_magic_dmg = self:GetAbility():GetSpecialValueFor( "prism_bonus_magic_dmg" )
	
	self.luminate_radius = self:GetAbility():GetSpecialValueFor( "luminate_radius" )
	
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/item/glimmerdark_shield/gleam.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		--ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 3, Vector( 100, 100, 100 ) )
		
		self:StartIntervalThink(FrameTime())
	end
end

--------------------------------------------------------------------------------

function modifier_item_imba_glimmerdark_shield_prism:OnIntervalThink()
	if IsServer() then
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.luminate_radius, FrameTime(), false)
	end
end

--------------------------------------------------------------------------------

function modifier_item_imba_glimmerdark_shield_prism:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nFXIndex, false )
	end
end

--------------------------------------------------------------------------------

function modifier_item_imba_glimmerdark_shield_prism:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
		
		-- IMBAfication: Extrasensory
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_imba_glimmerdark_shield_prism:GetAbsoluteNoDamagePhysical( params )
	if not self:GetParent():IsMagicImmune() then -- Let's try to have a semblance of balance here
		return 1
	end
end

--------------------------------------------------------------------------------

function modifier_item_imba_glimmerdark_shield_prism:GetModifierMagicalResistanceDecrepifyUnique( params )
	return self.prism_bonus_magic_dmg
end 

--------------------------------------------------------------------------------

function modifier_item_imba_glimmerdark_shield_prism:GetModifierIgnoreCastAngle()
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return 1
	end
end

--------------------------------------------------------------------------------

---------------------------------
-- GLIMMERDARK SHIELD MODIFIER --
---------------------------------

modifier_item_imba_glimmerdark_shield = class({})

--------------------------------------------------------------------------------

function modifier_item_imba_glimmerdark_shield:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_imba_glimmerdark_shield:IsPurgable()
	return false
end

function modifier_item_imba_glimmerdark_shield:RemoveOnDeath()	return false end
function modifier_item_imba_glimmerdark_shield:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

--------------------------------------------------------------------------------

function modifier_item_imba_glimmerdark_shield:OnCreated( kv )
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.bonus_strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
	self.bonus_agility = self:GetAbility():GetSpecialValueFor( "bonus_agility" )
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor( "bonus_intellect" )
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
end

--------------------------------------------------------------------------------

function modifier_item_imba_glimmerdark_shield:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------


function modifier_item_imba_glimmerdark_shield:GetModifierBonusStats_Strength( params )
	return self.bonus_strength
end 

--------------------------------------------------------------------------------

function modifier_item_imba_glimmerdark_shield:GetModifierBonusStats_Agility( params )
	return self.bonus_agility
end 

--------------------------------------------------------------------------------

function modifier_item_imba_glimmerdark_shield:GetModifierBonusStats_Intellect( params )
	return self.bonus_intellect
end 

--------------------------------------------------------------------------------

function modifier_item_imba_glimmerdark_shield:GetModifierConstantHealthRegen( params )
	return self.bonus_health_regen
end 

--------------------------------------------------------------------------------

function modifier_item_imba_glimmerdark_shield:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor
end

--------------------------------------------------------------------------------
