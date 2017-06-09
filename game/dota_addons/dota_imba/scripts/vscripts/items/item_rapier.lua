--[[
		By: AtroCty
		Date: 17.05.2017
		Updated:  17.05.2017
	]]

local function ShallowCopy(orig)
    local copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    return copy
end
-------------------------------------------
--			RAPIER BASECLASS
-------------------------------------------
LinkLuaModifier("modifier_imba_divine_rapier", "items/item_rapier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_divine_rapier_2", "items/item_rapier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_arcane_rapier", "items/item_rapier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_arcane_rapier_2", "items/item_rapier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rapier_cursed", "items/item_rapier.lua", LUA_MODIFIER_MOTION_NONE)

rapier_base_class = class({})

function rapier_base_class:OnOwnerDied(params)
	local hCaster = self:GetCaster()
	if not hCaster:IsReincarnating() then
		self:GetCaster():DropRapier(self, true)
	end
end

function rapier_base_class:IsRapier()
	return true
end

-------------------------------------------
modifier_rapier_base_class = class({})
function modifier_rapier_base_class:IsDebuff() return false end
function modifier_rapier_base_class:IsHidden() return true end
function modifier_rapier_base_class:IsPurgable() return false end
function modifier_rapier_base_class:IsPurgeException() return false end
function modifier_rapier_base_class:IsStunDebuff() return false end
function modifier_rapier_base_class:RemoveOnDeath() return false end
function modifier_rapier_base_class:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_rapier_base_class:OnDestroy()
	if IsServer() then 
		self:StartIntervalThink(-1)
	end
end
-------------------------------------------
--			  DIVINE RAPIER
-------------------------------------------
item_imba_rapier = ShallowCopy( rapier_base_class )
-------------------------------------------
function item_imba_rapier:GetIntrinsicModifierName()
    return "modifier_imba_divine_rapier"
end

function item_imba_rapier:GetAbilityTextureName()
   return "custom/imba_rapier"
end
-------------------------------------------
modifier_imba_divine_rapier = ShallowCopy( modifier_rapier_base_class )
function modifier_imba_divine_rapier:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
    return decFuns
end

function modifier_imba_divine_rapier:OnCreated()
	local item = self:GetAbility()
	if self:GetParent():IsHero() and item then
		self.bonus_damage = item:GetSpecialValueFor("bonus_damage")
	else
		self.bonus_damage = 0
	end
end

function modifier_imba_divine_rapier:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end
-------------------------------------------
--			  TRINITY RAPIER
-------------------------------------------
item_imba_rapier_2 = ShallowCopy( rapier_base_class )
-------------------------------------------
function item_imba_rapier_2:GetIntrinsicModifierName()
    return "modifier_imba_divine_rapier_2"
end

function item_imba_rapier_2:GetAbilityTextureName()
   return "custom/imba_rapier_2"
end
-------------------------------------------
modifier_imba_divine_rapier_2 = ShallowCopy( modifier_rapier_base_class )
function modifier_imba_divine_rapier_2:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_FORCE_DRAW_MINIMAP
    }
    return decFuns
end

function modifier_imba_divine_rapier_2:GetForceDrawOnMinimap()
	return 1
end

function modifier_imba_divine_rapier_2:GetModifierProvidesFOWVision()
	return 1
end

function modifier_imba_divine_rapier_2:OnCreated()
	local item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and item then
		self.bonus_damage = item:GetSpecialValueFor("bonus_damage")
	else
		self.bonus_damage = 0
	end
end

function modifier_imba_divine_rapier_2:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_divine_rapier_2:GetEffectName()
	return "particles/item/rapier/rapier_trail_regular.vpcf"
end

function modifier_imba_divine_rapier_2:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
-------------------------------------------
--			  ARCANE RAPIER
-------------------------------------------
item_imba_rapier_magic = ShallowCopy( rapier_base_class )
-------------------------------------------
function item_imba_rapier_magic:GetIntrinsicModifierName()
    return "modifier_imba_arcane_rapier"
end

function item_imba_rapier_magic:GetAbilityTextureName()
   return "custom/imba_rapier_magic"
end
-------------------------------------------
modifier_imba_arcane_rapier = ShallowCopy( modifier_rapier_base_class )
function modifier_imba_arcane_rapier:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
    }
    return decFuns
end

function modifier_imba_arcane_rapier:OnCreated()	
	local item = self:GetAbility()
	if self:GetParent():IsHero() and item then
		self.spell_power = item:GetSpecialValueFor("spell_power")
	else
		self.spell_power = 0
	end
end

function modifier_imba_arcane_rapier:GetModifierSpellAmplify_Percentage()
	return self.spell_power
end
-------------------------------------------
--			  ARCHMAGE RAPIER
-------------------------------------------
item_imba_rapier_magic_2 = ShallowCopy( rapier_base_class )
-------------------------------------------
function item_imba_rapier_magic_2:GetIntrinsicModifierName()
    return "modifier_imba_arcane_rapier_2"
end

function item_imba_rapier_magic_2:GetAbilityTextureName()
   return "custom/imba_rapier_magic_2"
end
-------------------------------------------
modifier_imba_arcane_rapier_2 = ShallowCopy( modifier_rapier_base_class )
function modifier_imba_arcane_rapier_2:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_FORCE_DRAW_MINIMAP
    }
    return decFuns
end

function modifier_imba_arcane_rapier_2:OnCreated()
	local item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and item then
		self.spell_power = item:GetSpecialValueFor("spell_power")
	else
		self.spell_power = 0
	end
end

function modifier_imba_arcane_rapier_2:GetModifierSpellAmplify_Percentage()
	return self.spell_power
end

function modifier_imba_arcane_rapier_2:GetEffectName()
	return "particles/item/rapier/rapier_trail_arcane.vpcf"
end

function modifier_imba_arcane_rapier_2:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_arcane_rapier_2:GetModifierProvidesFOWVision()
	return 1
end

function modifier_imba_arcane_rapier_2:GetForceDrawOnMinimap()
	return 1
end
-------------------------------------------
--			  CURSED RAPIER
-------------------------------------------
item_imba_rapier_cursed = ShallowCopy( rapier_base_class )
-------------------------------------------
function item_imba_rapier_cursed:GetIntrinsicModifierName()
    return "modifier_imba_rapier_cursed"
end

function item_imba_rapier_cursed:GetAbilityTextureName()
   return "custom/imba_rapier_cursed"
end
-------------------------------------------
modifier_imba_rapier_cursed = ShallowCopy( modifier_rapier_base_class )
function modifier_imba_rapier_cursed:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_FORCE_DRAW_MINIMAP
    }
    return decFuns
end

function modifier_imba_rapier_cursed:OnCreated()
	local item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and item then
		self.spell_power = item:GetSpecialValueFor("spell_power")
		self.bonus_damage = item:GetSpecialValueFor("bonus_damage")
		self.tenacity_pct = item:GetSpecialValueFor("tenacity_pct")
		self.base_corruption = item:GetSpecialValueFor("base_corruption")
		self.time_to_double = item:GetSpecialValueFor("time_to_double")
		self.corruption_total_time = 0
		if IsServer() then
			self:StartIntervalThink(FrameTime())
		end
	else
		self.spell_power = 0
		self.bonus_damage = 0
	end
end

function modifier_imba_rapier_cursed:GetTenacity()
	return self.tenacity_pct
end

function modifier_imba_rapier_cursed:OnIntervalThink()
	self.corruption_total_time = self.corruption_total_time + FrameTime()
	local total_corruption = self.base_corruption * self.parent:GetMaxHealth() * (self.corruption_total_time / self.time_to_double) * 0.01 * FrameTime()
	ApplyDamage({attacker = self.parent, victim = self.parent, ability = self:GetAbility(), damage = total_corruption, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_NON_LETHAL})
end

function modifier_imba_rapier_cursed:GetModifierSpellAmplify_Percentage()
	return self.spell_power
end

function modifier_imba_rapier_cursed:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_rapier_cursed:GetModifierProvidesFOWVision()
	return 1
end

function modifier_imba_rapier_cursed:GetForceDrawOnMinimap()
	return 1
end

function modifier_imba_rapier_cursed:GetEffectName()
	return "particles/item/rapier/item_rapier_cursed.vpcf"
end

function modifier_imba_rapier_cursed:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
-------------------------------------------