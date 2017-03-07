--[[	Author: Firetoad
		Date: 26.02.2017	]]

if modifier_imba_arena_passive_gold_thinker == nil then
	modifier_imba_arena_passive_gold_thinker = class({})
end

function modifier_imba_arena_passive_gold_thinker:OnCreated()
	self:StartIntervalThink(3.0)
end

function modifier_imba_arena_passive_gold_thinker:OnIntervalThink()
	if IsServer() then
		local stacks = self:GetStackCount()
		local hero = self:GetCaster()
		hero:ModifyGold(stacks, false, DOTA_ModifyGold_GameTick)
		hero:AddExperience(stacks, DOTA_ModifyXP_Unspecified, false, true)
	end
end

function modifier_imba_arena_passive_gold_thinker:IsHidden()
	return false
end

function modifier_imba_arena_passive_gold_thinker:GetTexture()
	return "custom/imba_rune_bounty"
end