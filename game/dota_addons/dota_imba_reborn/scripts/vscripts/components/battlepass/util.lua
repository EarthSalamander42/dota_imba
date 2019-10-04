-- Copyright (C) 2018  The Dota IMBA Development Team
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
-- limitations under the License.
--
-- Editors:
--     Earth Salamander #42

LinkLuaModifier("modifier_companion", "components/battlepass/modifiers/modifier_companion.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_patreon_donator", "components/battlepass/modifiers/modifier_patreon_donator.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_donator_statue", "components/battlepass/modifiers/modifier_donator_statue.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_battlepass_taunt", "components/battlepass/modifiers/modifier_battlepass_taunt.lua", LUA_MODIFIER_MOTION_NONE )

CustomGameEventManager:RegisterListener("change_companion", Dynamic_Wrap(Battlepass, "DonatorCompanionJS"))
CustomGameEventManager:RegisterListener("change_statue", Dynamic_Wrap(Battlepass, "DonatorStatueJS"))
CustomGameEventManager:RegisterListener("change_emblem", Dynamic_Wrap(Battlepass, "DonatorEmblemJS"))
CustomGameEventManager:RegisterListener("change_companion_skin", Dynamic_Wrap(Battlepass, "DonatorCompanionSkinJS"))
CustomGameEventManager:RegisterListener("change_ingame_tag", Dynamic_Wrap(Battlepass, 'DonatorTag'))
CustomGameEventManager:RegisterListener("change_battlepass_rewards", Dynamic_Wrap(Battlepass, 'BattlepassRewards'))
CustomGameEventManager:RegisterListener("change_player_xp", Dynamic_Wrap(Battlepass, 'PlayerXP'))
CustomGameEventManager:RegisterListener("play_hero_taunt", Dynamic_Wrap(Battlepass, "PlayHeroTaunt"))
CustomGameEventManager:RegisterListener("change_winrate", Dynamic_Wrap(Battlepass, 'Winrate'))

function Battlepass:GetRewardUnlocked(ID)
	if IsInToolsMode() then return 1000 end
	if CustomNetTables:GetTableValue("battlepass", tostring(ID)) then
		if CustomNetTables:GetTableValue("battlepass", tostring(ID)).Lvl then
			return CustomNetTables:GetTableValue("battlepass", tostring(ID)).Lvl
		end
	end

	return 1
end

-- global functions shared across Frostrose Studio custom games

function Battlepass:AddItemEffects(hero)
	if hero.GetPlayerID == nil then return end

	local ply_table = CustomNetTables:GetTableValue("battlepass", tostring(hero:GetPlayerID()))

	if ply_table and ply_table.bp_rewards == 0 then
	else
		Battlepass:SetItemEffects(hero:GetPlayerID())
	end

	-- some effects override some items effects, need to call it after items setup
	Battlepass:GetHeroEffect(hero)
end

function Battlepass:HasArcana(ID, hero_name)
	if not Battlepass.GetRewardUnlocked or not BattlepassHeroes[hero_name] then return nil end

	if BattlepassHeroes[hero_name][hero_name.."_arcana2"] then
		if Battlepass:GetRewardUnlocked(ID) >= BattlepassHeroes[hero_name][hero_name.."_arcana2"] then
			return 1
		end
	elseif BattlepassHeroes[hero_name][hero_name.."_arcana"] then
		if Battlepass:GetRewardUnlocked(ID) >= BattlepassHeroes[hero_name][hero_name.."_arcana"] then
			return 0
		end
	-- axe immortal topbar icon handling
	elseif BattlepassHeroes[hero_name][hero_name.."_immortal"] then
		if Battlepass:GetRewardUnlocked(ID) >= BattlepassHeroes[hero_name][hero_name.."_immortal"] then
			return 0
		end
	end

	return nil
end

-- vanilla extension
function CDOTA_BaseNPC:SetupHealthBarLabel()
	local ply_table = CustomNetTables:GetTableValue("battlepass", tostring(self:GetPlayerOwnerID()))

	if ply_table and ply_table.in_game_tag == 0 then
		self:SetCustomHealthLabel("", 0, 0, 0)

		return
	end

--	print("Donator Player ID / status:", self:GetPlayerOwnerID(), api:GetDonatorStatus(self:GetPlayerOwnerID()))
	if api:IsDonator(self:GetPlayerOwnerID()) ~= false then
		local donator_level = api:GetDonatorStatus(self:GetPlayerOwnerID())
		if donator_level and donator_level > 0 then
			self:SetCustomHealthLabel("#donator_label_" .. donator_level, DONATOR_COLOR[donator_level][1], DONATOR_COLOR[donator_level][2], DONATOR_COLOR[donator_level][3])
		end
	end
end

function CDOTA_BaseNPC:CenterCameraOnEntity(hTarget, iDuration)
	PlayerResource:SetCameraTarget(self:GetPlayerID(), hTarget)
	if iDuration == nil then iDuration = FrameTime() end
	if iDuration ~= -1 then
		Timers:CreateTimer(iDuration, function()
			PlayerResource:SetCameraTarget(self:GetPlayerID(), nil)
			Timers:CreateTimer(FrameTime(), function() --fail-safe
				PlayerResource:SetCameraTarget(self:GetPlayerID(), nil)
			end)
			Timers:CreateTimer(FrameTime() * 3, function() --fail-safe
				PlayerResource:SetCameraTarget(self:GetPlayerID(), nil)
			end)
		end)
	end
end

function Battlepass:DonatorTag(keys)
	local hero = PlayerResource:GetPlayer(keys.ID):GetAssignedHero()
	local ply_table = CustomNetTables:GetTableValue("battlepass", tostring(keys.ID))

	CustomNetTables:SetTableValue("battlepass", tostring(keys.ID), {
		XP = ply_table.XP,
		MaxXP = ply_table.MaxXP,
		Lvl = ply_table.Lvl,
		ply_color = ply_table.ply_color,
		title = ply_table.title,
		title_color = ply_table.title_color,
		XP_change = 0,
		IMR_5v5_change = 0,
		donator_level = ply_table.donator_level,
		donator_color = ply_table.donator_color,
		in_game_tag = keys.tag,
		bp_rewards = ply_table.bp_rewards,
		player_xp = ply_table.player_xp
	})

	hero:SetupHealthBarLabel()
end

function Battlepass:BattlepassRewards(keys)
	local ply_table = CustomNetTables:GetTableValue("battlepass", tostring(keys.ID))

	CustomNetTables:SetTableValue("battlepass", tostring(keys.ID), {
		XP = ply_table.XP,
		MaxXP = ply_table.MaxXP,
		Lvl = ply_table.Lvl,
		ply_color = ply_table.ply_color,
		title = ply_table.title,
		title_color = ply_table.title_color,
		XP_change = 0,
		IMR_5v5_change = 0,
		donator_level = ply_table.donator_level,
		donator_color = ply_table.donator_color,
		in_game_tag = ply_table.in_game_tag,
		bp_rewards = keys.bp_rewards,
		player_xp = ply_table.player_xp
	})
end

function Battlepass:PlayerXP(keys)
	local ply_table = CustomNetTables:GetTableValue("battlepass", tostring(keys.ID))

	CustomNetTables:SetTableValue("battlepass", tostring(keys.ID), {
		XP = ply_table.XP,
		MaxXP = ply_table.MaxXP,
		Lvl = ply_table.Lvl,
		ply_color = ply_table.ply_color,
		title = ply_table.title,
		title_color = ply_table.title_color,
		XP_change = 0,
		IMR_5v5_change = 0,
		donator_level = ply_table.donator_level,
		donator_color = ply_table.donator_color,
		in_game_tag = ply_table.in_game_tag,
		bp_rewards = ply_table.bp_rewards,
		player_xp = keys.player_xp
	})
end

function Battlepass:PlayHeroTaunt(keys)
	local hero = PlayerResource:GetSelectedHeroEntity(keys.ID)

	if hero.can_cast_taunt == false then
		-- Notification: You can cast it again in x seconds

		return
	end

	if not Battlepass or not Battlepass.GetRewardUnlocked or not BATTLEPASS_LEVEL_REWARD then
		return
	end

	local hero_short_name = string.gsub(hero:GetUnitName(), "npc_dota_hero_", "")
	local taunt_unlocked = false

	for k, v in pairs(BATTLEPASS_LEVEL_REWARD) do
		if v[1] == hero_short_name.."_taunt" then
			if Battlepass:GetRewardUnlocked(keys.ID) >= k then
				taunt_unlocked = true

				break
			end
		end
	end

	if taunt_unlocked == false then
		-- Notification: you're level is too low or this hero have no taunt!

		return
	end

	if not hero.can_cast_taunt then
		hero.can_cast_taunt = true
	end

	if hero.can_cast_taunt == true then
		hero.can_cast_taunt = false
		hero:AddNewModifier(hero, nil, "modifier_battlepass_taunt", {duration=7.0})

		Timers:CreateTimer(8.0, function()
			hero.can_cast_taunt = true
		end)
	end
end

function Battlepass:Winrate(keys)
	local ply_table = CustomNetTables:GetTableValue("battlepass", tostring(keys.ID))

	CustomNetTables:SetTableValue("battlepass", tostring(keys.ID), {
		XP = ply_table.XP,
		MaxXP = ply_table.MaxXP,
		Lvl = ply_table.Lvl,
		ply_color = ply_table.ply_color,
		title = ply_table.title,
		title_color = ply_table.title_color,
		XP_change = 0,
		IMR_5v5_change = 0,
		donator_level = ply_table.donator_level,
		donator_color = ply_table.donator_color,
		in_game_tag = ply_table.in_game_tag,
		bp_rewards = ply_table.bp_rewards,
		player_xp = ply_table.player_xp,
		winrate = keys.winrate
	})
end

function Battlepass:DonatorCompanionJS(event)
	Battlepass:DonatorCompanion(event.ID, event.unit, event.js)
end

function Battlepass:DonatorStatueJS(event)
	-- need to update the current statue with the new one
--	Battlepass:DonatorCompanion(event.ID, event.unit, event.js)
end

function Battlepass:DonatorEmblemJS(event)
	local hero = PlayerResource:GetSelectedHeroEntity(event.ID)

	if hero:HasModifier("modifier_patreon_donator") then
		local modifier = hero:FindModifierByName("modifier_patreon_donator")

		modifier.effect_name = event.unit
	end
end

function Battlepass:DonatorCompanionSkinJS(event)
	DonatorCompanionSkin(event.ID, event.unit, event.skin)
end