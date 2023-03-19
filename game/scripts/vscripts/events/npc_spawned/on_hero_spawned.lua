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

-- first time a real hero spawn
function GameMode:OnHeroFirstSpawn(hero)
	if not hero or hero:IsNull() then return end

	-- Track the time the unit spawned (for IMBAfications or other custom checks)
	hero.time_spawned = GameRules:GetGameTime()

--[[
	if IsInToolsMode() then
		if hero:GetUnitName() == "npc_dota_hero_mars" then
			Timers:CreateTimer(1.0, function()
				local modifiers = hero:FindAllModifiers()

				for _, modifier in pairs(modifiers) do
					if modifier.GetName then
						print(modifier:GetName())
					end
				end

				return 1.0
			end)
		end
	end
--]]

	if hero:IsIllusion() then
		hero:AddNewModifier(hero, nil, "modifier_custom_mechanics", {})
		return
	end -- Illusions will not be affected by scripts written under this line

	-- Let's try to make Meepo a bit more playable
	-- Ensure the Meepos get buffs like custom mechanics
	if hero:GetUnitName() == "npc_dota_hero_meepo" and hero:IsClone() then
		hero:AddNewModifier(hero:GetCloneSource(), nil, "modifier_meepo_divided_we_stand_lua", {})
		hero:AddNewModifier(hero:GetCloneSource(), nil, "modifier_custom_mechanics", {})
	elseif hero:GetUnitName() == "npc_dota_hero_skeleton_king" then
		hero:AddNewModifier(hero, nil, "modifier_skeleton_king_ambient", {})
	elseif hero:GetUnitName() == "npc_dota_hero_wisp" then
		hero:AddNewModifier(hero, nil, "modifier_wisp_death", {})
	end

	if hero == nil or hero:IsFakeHero() then return end

	-- Set up initial level
	local starting_level = tonumber(CustomNetTables:GetTableValue("game_options", "initial_level")["1"])
	if starting_level == nil then starting_level = 1 end

	if starting_level and starting_level > 1 then
		-- for level = 2, starting_level do
			-- hero:HeroLevelUp(true)
		-- end

		hero:SetAbilityPoints(1)
		hero:AddExperience(XP_PER_LEVEL_TABLE[starting_level], DOTA_ModifyXP_Unspecified, false, true)
		hero:SetCustomDeathXP(HERO_XP_BOUNTY_PER_LEVEL[starting_level])
	else
		hero:SetCustomDeathXP(HERO_XP_BOUNTY_PER_LEVEL[1])
	end

	-- add modifier for custom mechanics handling
	hero:AddNewModifier(hero, nil, "modifier_custom_mechanics", {})

	-- Initialize innate hero abilities
	hero:InitializeAbilities()

	-- Set starting gold
	PlayerResource:SetGold(hero:GetPlayerID(), hero:IMBA_GetHeroStartingGold(), false)

	-- Give players an additional 250 boost in gold if they random
--	if PlayerResource:HasRandomed(hero:GetPlayerID()) then
--		PlayerResource:SetGold(hero:GetPlayerID(), hero:GetGold() + 250, false)
--	end

	local deathEffects = hero:Attribute_GetIntValue("effectsID", -1)
	if deathEffects ~= -1 then
		ParticleManager:DestroyParticle(deathEffects, true)
		hero:DeleteAttribute("effectsID")
	end

	if hero:GetUnitName() == FORCE_PICKED_HERO then
		hero:AddNewModifier(hero, nil, "modifier_dummy_dummy", {})
		hero:SetDayTimeVisionRange(0)
		hero:SetNightTimeVisionRange(0)

		if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			PlayerResource:SetCameraTarget(hero:GetPlayerID(), GoodCamera)
		else
			PlayerResource:SetCameraTarget(hero:GetPlayerID(), BadCamera)
		end
	else
		hero.picked = true

		if hero:IsClone() then
			hero:SetRespawnsDisabled(true)

			-- add war veteran modifier to the clone if a new clone spawn after main hero gets level 26
			if hero:GetCloneSource():HasModifier("modifier_imba_war_veteran_"..hero:GetCloneSource():GetPrimaryAttribute()) then
				hero:AddNewModifier(hero, nil, "modifier_imba_war_veteran_"..hero:GetCloneSource():GetPrimaryAttribute(), {}):SetStackCount(math.min(hero:GetCloneSource():GetLevel() -25, 17))
			end
		else
			-- remove camera focused pick screen
			hero:CenterCameraOnEntity(hero, 0.1)

--			if api.imba.is_developer(PlayerResource:GetSteamID(hero:GetPlayerID())) then
--				hero.has_graph = true
--				CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "show_netgraph", {})
--				CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "show_netgraph_heronames", {})
--			end
			
			if hero:IsTempestDouble() then
				GameMode:OnHeroSpawned(hero)
			-- Not a big deal, but don't give the MK ult clones frantic modifier (blue auras)
			elseif hero:GetUnitName() == "npc_dota_hero_monkey_king" then
				if hero:HasModifier("modifier_monkey_king_fur_army_soldier") or hero:HasModifier("modifier_monkey_king_fur_army_soldier_hidden") then return end
			elseif hero:GetUnitName() == "npc_dota_hero_pudge" then
				local flesh_heap_ability = hero:FindAbilityByName("imba_pudge_flesh_heap")
				hero:AddNewModifier(hero, flesh_heap_ability, "modifier_imba_pudge_flesh_heap_handler", {})
			elseif hero:GetUnitName() == "npc_dota_hero_tiny" then
				hero:AddNewModifier(hero, nil, "modifier_imba_tiny_death_handler", {})
			elseif hero:GetUnitName() == "npc_dota_hero_witch_doctor" then
				if hero:IsAlive() and hero:HasTalent("special_bonus_imba_witch_doctor_6") then
					if not hero:HasModifier("modifier_imba_voodoo_restoration") then
						hero:AddNewModifier(hero, hero:GetAbilityByIndex(1), "modifier_imba_voodoo_restoration", {})
					end
				end
			end

			-- IMBA: Negative Vengeance Aura removal
			if hero.vengeance_aura_target then
				hero.vengeance_aura_target:RemoveModifierByName("modifier_imba_command_aura_negative_aura")
				hero.vengeance_aura_target = nil
			end
		end

		-- Refresh TP on first spawn
		local teleport_scroll = hero:GetItemInSlot(15)
		
		if teleport_scroll then
			teleport_scroll:EndCooldown()
		end

		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerID()), "vanillafier_init_tooltips_first_spawn", {})
	end
end

-- everytime a real hero respawn
function GameMode:OnHeroSpawned(hero)
	-- Track the time the unit spawned (for IMBAfications or other custom checks)
	hero.time_spawned = GameRules:GetGameTime()
	
	-- Testing putting fountain invulnerability application here such that it will only apply on respawns in the fountain
	Timers:CreateTimer(0.1, function()
		if hero:HasModifier("modifier_fountain_aura_effect_lua") and IsNearFountain(hero:GetAbsOrigin(), 1200) then
			hero:AddNewModifier(hero, nil, "modifier_fountain_invulnerable", {})
		end
	end)
	
	-- Let's try to make Meepo a bit more playable
	-- Ensure the Meepos get buffs like custom mechanics
	if hero:GetUnitName() == "npc_dota_hero_meepo" and hero:IsClone() and (not hero:HasModifier("modifier_meepo_divided_we_stand_lua") or not hero:HasModifier("modifier_custom_mechanics")) then
		hero:AddNewModifier(hero:GetCloneSource(), nil, "modifier_meepo_divided_we_stand_lua", {})
		hero:AddNewModifier(hero:GetCloneSource(), nil, "modifier_custom_mechanics", {})
	end

	if hero:GetUnitName() == "npc_dota_hero_wisp" then
		hero:SetModel("models/heroes/wisp/wisp.vmdl")
		hero:SetOriginalModel("models/heroes/wisp/wisp.vmdl")
	end

	if hero:IsTempestDouble() then
		local clone_shared_buffs = {
			"modifier_frantic",
			"modifier_item_imba_moon_shard_active",
			"modifier_imba_soul_of_truth_buff",
			"modifier_imba_war_veteran_0",
			"modifier_imba_war_veteran_1",
			"modifier_imba_war_veteran_2"
		}
		
		-- Iterate through the main hero's potential modifiers
		local main_hero = hero:GetOwner():GetAssignedHero()
		
		for _, shared_buff in pairs(clone_shared_buffs) do
			-- If the main hero has this modifier, copy it to the clone
			
			if main_hero:HasModifier(shared_buff) then
				local shared_buff_modifier = main_hero:FindModifierByName(shared_buff)
				local shared_buff_ability = shared_buff_modifier:GetAbility()
				
				-- Exception for Soul of Truth; can only be cloned once per instance
				if not shared_buff_modifier.cloned then
					local buff_time = shared_buff_modifier:GetRemainingTime()
					if buff_time <= 0 then
						buff_time = shared_buff_modifier:GetDuration()
					end
					local cloned_modifier = hero:AddNewModifier(main_hero, shared_buff_ability, shared_buff_modifier:GetName(), {duration = buff_time})

					cloned_modifier:SetStackCount(shared_buff_modifier:GetStackCount())
					-- Once Soul of Truth is cloned, don't allow cloning the same one again
					if shared_buff == "modifier_imba_soul_of_truth_buff" then
						shared_buff_modifier.cloned = true
						
						local dummy_item = CreateItem("item_imba_soul_of_truth", hero, hero)
							main_hero:AddItem(dummy_item)

							-- Fetch dummy item's ability handle
							for i = 0, 14 do
								local current_item = main_hero:GetItemInSlot(i)
								if current_item and current_item:GetName() == "item_imba_soul_of_truth" then
									local cloned_modifier = hero:AddNewModifier(main_hero, current_item, "modifier_item_imba_gem_of_true_sight", {duration = buff_time})
									break
								end
							end
							Timers:CreateTimer(FrameTime(), function()
								main_hero:RemoveItem(dummy_item)
							end)
					end
				end
			end
		end

		if hero.duel_damage and hero.duel_ability then
			local duel_modifier = hero:AddNewModifier(hero, hero.duel_ability, "modifier_legion_commander_duel_damage_boost" , {})
			duel_modifier:SetStackCount(hero.duel_damage)
		end
	end
end
