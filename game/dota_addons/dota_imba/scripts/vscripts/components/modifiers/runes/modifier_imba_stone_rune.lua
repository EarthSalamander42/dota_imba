--[[


	Ember Rune

	Contributors: Lindbrum (14th March 2018)
]]

LinkLuaModifier("modifier_imba_stone_rune_debuff", "modifier/runes/modifier_imba_stone_rune", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_stone_rune_debuff_count", "modifier/runes/modifier_imba_stone_rune", LUA_MODIFIER_MOTION_NONE)

------------------------------------------------------------------------
-- Rune buff
------------------------------------------------------------------------
modifier_imba_stone_rune = modifier_imba_stone_rune or class({})

function modifier_imba_stone_rune:IsHidden() return false end
function modifier_imba_stone_rune:IsDebuff() return false end
function modifier_imba_stone_rune:IsPurgable() return true end

function modifier_imba_stone_rune:GetTexture()
	return ""
end

function modifier_imba_stone_rune:GetEffectName()
	return ""
end

function modifier_imba_stone_rune:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_stone_rune:OnCreated()
	if not IsServer() then return end
	self.parent = self:GetParent()
	self.att_threeshold = 7
	self.count_duration = 5.0
	self.debuff_duration = 1.0
end

function modifier_imba_stone_rune:DeclareFunctions()
	local funcs =  {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_imba_stone_rune:OnAttackLanded(kv)
	if not IsServer() then return end

	--Proceed only if the attacker is the parent
	if not self.parent == kv.attacker then return end

	local target = kv.target
	--Can't proc on magic immune enemies and buildings
	if target:IsMagicImmune() or target:IsBuilding() then return end

	local stacks = 0
	--Apply the debuff on the target if not affected yet, else add a stack
	if target:HasModifier("modifier_imba_stone_rune_debuff_count") then
		local modifier = target:FindModifierByName("modifier_imba_stone_rune_debuff_count")
		stacks = modifier:GetStackCount()
		modifier:SetStackCount(stacks + 1)
		modifier:SetDuration(self.count_duration, true)
	else
		local modifier = target:AddNewModifier(self.parent, nil, "modifier_imba_stone_rune_debuff_count", {duration = self.count_duration})
		modifier:SetStackCount(1)
		stacks = 1
	end

	--If enough attacks were landed, petrify the target
	if stacks >= 7 then
		target:AddNewModifier(self.parent, nil, "modifier_imba_stone_rune_debuff", {duration = self.debuff_duration})
		target:RemoveModifierByName("modifier_imba_stone_rune_debuff_count")
	end
end

------------------------------------------------------------------------------
-- Debuff attack count
------------------------------------------------------------------------------

modifier_imba_stone_rune_debuff_count = modifier_imba_stone_rune_debuff_count or class({})

function modifier_imba_stone_rune_debuff_count:IsHidden() return false end
function modifier_imba_stone_rune_debuff_count:IsDebuff() return true end
function modifier_imba_stone_rune_debuff_count:IsPurgable() return true end

function modifier_imba_stone_rune_debuff_count:GetTexture()
	return ""
end


-----------------------------------------------------------------------------
-- Debuff
-----------------------------------------------------------------------------

modifier_imba_stone_rune_debuff = modifier_imba_stone_rune_debuff or class({})

function modifier_imba_stone_rune_debuff:IsHidden() return false end
function modifier_imba_stone_rune_debuff:IsDebuff() return true end
function modifier_imba_stone_rune_debuff:IsPurgable() return false end
function modifier_imba_stone_rune_debuff:IsPurgeException() return true end
function modifier_imba_stone_rune_debuff:IsStunDebuff() return true end

function modifier_imba_stone_rune_debuff:GetTexture()
	return ""
end

function modifier_imba_stone_rune_debuff:CheckState()
	local state = {[MODIFIER_STATE_MAGIC_IMMUNE] = true,
					[MODIFIER_STATE_STUNNED] = true}
	return state	
end

function modifier_imba_stone_rune_debuff:OnCreated()

	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.end_particle = ""

	self.parent:SetRenderColor(153, 153, 102) --color it grey
end

function modifier_imba_stone_rune_debuff:OnDestroy()
	
	--Restore original color and play the "depetrify" effect
	self.parent:SetRenderColor(255,255,255)
	
end