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

function rapier_base_class:OnOwnerDied()
	self:GetCaster():DropRapier(self, true)
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
-------------------------------------------
modifier_imba_divine_rapier_2 = ShallowCopy( modifier_rapier_base_class )
function modifier_imba_divine_rapier_2:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
    return decFuns
end

function modifier_imba_divine_rapier_2:OnCreated()
	local item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and item then
		self.bonus_damage = item:GetSpecialValueFor("bonus_damage")
		local trail_pfx = ParticleManager:CreateParticle("particles/item/rapier/rapier_trail_regular.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(trail_pfx, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		self:AddParticle(trail_pfx, false, false, 0, true, false)
		if IsServer() then 
			self:StartIntervalThink(FrameTime())
		end
	else
		self.bonus_damage = 0
	end
end

function modifier_imba_divine_rapier_2:OnIntervalThink()
	-- Make the owner visible to both teams
	self.parent:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, FrameTime())
	self.parent:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, FrameTime())
end

function modifier_imba_divine_rapier_2:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end
-------------------------------------------
--			  ARCANE RAPIER
-------------------------------------------
item_imba_rapier_magic = ShallowCopy( rapier_base_class )
-------------------------------------------
function item_imba_rapier_magic:GetIntrinsicModifierName()
    return "modifier_imba_arcane_rapier"
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
-------------------------------------------
modifier_imba_arcane_rapier_2 = ShallowCopy( modifier_rapier_base_class )
function modifier_imba_arcane_rapier_2:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
    }
    return decFuns
end

function modifier_imba_arcane_rapier_2:OnCreated()
	local item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and item then
		self.spell_power = item:GetSpecialValueFor("spell_power")
		local trail_pfx = ParticleManager:CreateParticle("particles/item/rapier/rapier_trail_arcane.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(trail_pfx, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		self:AddParticle(trail_pfx, false, false, 0, true, false)
		if IsServer() then 
			self:StartIntervalThink(FrameTime())
		end
	else
		self.spell_power = 0
	end
end

function modifier_imba_arcane_rapier_2:GetModifierSpellAmplify_Percentage()
	return self.spell_power
end
-------------------------------------------
--			  CURSED RAPIER
-------------------------------------------
item_imba_rapier_cursed = ShallowCopy( rapier_base_class )
-------------------------------------------
function item_imba_rapier_cursed:GetIntrinsicModifierName()
    return "modifier_imba_rapier_cursed"
end
-------------------------------------------
modifier_imba_rapier_cursed = ShallowCopy( modifier_rapier_base_class )
function modifier_imba_rapier_cursed:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
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
		local trail_pfx = ParticleManager:CreateParticle("particles/item/rapier/item_rapier_cursed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(trail_pfx, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		self:AddParticle(trail_pfx, false, false, 0, true, false)
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
	-- Make the owner visible to both teams
	self.parent:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, FrameTime())
	self.parent:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, FrameTime())
	local total_corruption = self.base_corruption * self.parent:GetMaxHealth() * (self.corruption_total_time / self.time_to_double) * 0.01 * FrameTime()
	ApplyDamage({attacker = self.parent, victim = self.parent, ability = self:GetAbility(), damage = total_corruption, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS})
end

function modifier_imba_rapier_cursed:GetModifierSpellAmplify_Percentage()
	return self.spell_power
end

function modifier_imba_rapier_cursed:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end
-------------------------------------------