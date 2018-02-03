-- Copyright 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
--
-- limitations under the License.
--
-- Editors:
--     suthernfriend, 03.02.2018

tinker_rearm = tinker_rearm or class({})

function tinker_rearm:IsHiddenWhenStolen() 		return false end
function tinker_rearm:IsRefreshable() 			return true  end
function tinker_rearm:IsStealable() 				return true  end
function tinker_rearm:IsNetherWardStealable() 	return false end

function tinker_rearm:OnAbilityPhaseStart()
	EmitSoundOn("Hero_Tinker.RearmStart", self:GetCaster())
	return true
end

function tinker_rearm:OnSpellStart()
	if self:GetCaster():GetName() == "npc_dota_hero_tinker" then
		local gesture = {ACT_DOTA_TINKER_REARM1,ACT_DOTA_TINKER_REARM2,ACT_DOTA_TINKER_REARM3}
		self:GetCaster():StartGesture(gesture[math.min(self:GetLevel(),3)])
	end

	EmitSoundOn("Hero_Tinker.Rearm", self:GetCaster())
end

function tinker_rearm:OnChannelFinish(bInter)
	StopSoundOn("Hero_Tinker.Rearm", self:GetCaster())
	local caster = self:GetCaster()
	-- List of unrefreshable items
	local forbidden_items =
		{
			"item_imba_bloodstone",
			"item_imba_arcane_boots",
			"item_imba_mekansm",
			"item_imba_mekansm_2",
			"item_imba_guardian_greaves",
			"item_imba_hand_of_midas",
			"item_imba_white_queen_cape",
			"item_black_king_bar",
			"item_imba_refresher",
			"item_imba_necronomicon",
			"item_imba_necronomicon_2",
			"item_imba_necronomicon_3",
			"item_imba_necronomicon_4",
			"item_imba_necronomicon_5",
			"item_imba_skadi",
			"item_imba_sphere"
		}
	if not bInter then
		for i = 0, 23 do
			local ability = caster:GetAbilityByIndex(i)
			if ability and ability.IsRefreshable and ability:IsRefreshable() then
				ability:EndCooldown()
			end
		end
		for i = 0, 5 do
			local item = caster:GetItemInSlot(i)
			local canRefresh = true
			if item then
				for _, unre in pairs(forbidden_items) do
					if item:GetAbilityName() == unre then
						canRefresh = false
						break
					end
				end
				if canRefresh then
					item:EndCooldown()
				end
			end
		end
	end
end
