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
	if hero:IsIllusion() or hero:HasModifier("modifier_illusion_manager_out_of_world") or hero:HasModifier("modifier_illusion_manager") then return end

	if api.imba.is_donator(PlayerResource:GetSteamID(hero:GetPlayerID())) and PlayerResource:GetConnectionState(hero:GetPlayerID()) ~= 1 then
		if hero:GetUnitName() ~= FORCE_PICKED_HERO then
			Timers:CreateTimer(1.5, function()
				local steam_id = tostring(PlayerResource:GetSteamID(hero:GetPlayerID()))
				DonatorCompanion(hero:GetPlayerID(), api.imba.get_player_info(steam_id).companion_file)
			end)
		end
	end

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
			PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), GoodCamera)
		else
			PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), BadCamera)
		end
	else
		hero.picked = true

		-- remove camera focused pick screen
		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)

		if api.imba.is_developer(PlayerResource:GetSteamID(hero:GetPlayerID())) then
			hero.has_graph = true
			CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "show_netgraph", {})
--			CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "show_netgraph_heronames", {})
		end

		if not IsInToolsMode() then
			local steam_id = tostring(PlayerResource:GetSteamID(hero:GetPlayerID()))
			if steam_id ~= "0" and api.imba.is_donator(steam_id) ~= false then
--			print("set player original team of ID "..hero:GetPlayerID().." to "..hero:GetTeamNumber())
--			PLAYER_TEAM[hero:GetPlayerID()] = hero:GetTeamNumber()
				local donator_level = api.imba.is_donator(steam_id)

				if donator_level then
					hero:SetCustomHealthLabel("#imba_donator_label_" .. donator_level, DONATOR_COLOR[donator_level][1], DONATOR_COLOR[donator_level][2], DONATOR_COLOR[donator_level][3])
					-- needs a timer else GetSelectedHeroEntity is nil
					Timers:CreateTimer(0.3, function()
						if api.imba.get_player_info(steam_id) then
							DonatorStatue(hero:GetPlayerID(), api.imba.get_player_info(steam_id).ingame_statue_file)
						end
					end)
				end
			end
		end
	end

	if hero:GetUnitName() == "npc_dota_hero_arc_warden" then
		-- Arc Warden clone handling
		if hero:FindAbilityByName("arc_warden_tempest_double") and not hero.first_tempest_double_cast and hero:IsRealHero() then
			hero.first_tempest_double_cast = true
			local tempest_double_ability = hero:FindAbilityByName("arc_warden_tempest_double")
			tempest_double_ability:SetLevel(4)
			Timers:CreateTimer(0.1, function()
				if not hero:HasModifier("modifier_arc_warden_tempest_double") then
					tempest_double_ability:CastAbility()
					tempest_double_ability:SetLevel(1)
				end
			end)
		end

		if hero:HasModifier("modifier_arc_warden_tempest_double") then
			-- List of modifiers which carry over from the main hero to the clone
			local clone_shared_buffs = {
				"modifier_imba_moon_shard_stacks_dummy",
				"modifier_imba_moon_shard_consume_1",
				"modifier_imba_moon_shard_consume_2",
				"modifier_imba_moon_shard_consume_3",
				"modifier_item_imba_soul_of_truth"
			}

			-- Iterate through the main hero's potential modifiers
			local main_hero = hero:GetOwner():GetAssignedHero()
			for _, shared_buff in pairs(clone_shared_buffs) do
				-- If the main hero has this modifier, copy it to the clone
				if main_hero:HasModifier(shared_buff) then
					local shared_buff_modifier = main_hero:FindModifierByName(shared_buff)
					local shared_buff_ability = shared_buff_modifier:GetAbility()

					-- If a source ability was found, use it
					if shared_buff_ability then
						shared_buff_ability:ApplyDataDrivenModifier(main_hero, hero, shared_buff, {})

						-- Else, it's a consumable item modifier. Create a dummy item to use the ability from.
					else
						-- Moon Shard
						if string.find(shared_buff, "moon_shard") then
							-- Create dummy item
							local dummy_item = CreateItem("item_imba_moon_shard", hero, hero)
							main_hero:AddItem(dummy_item)

							-- Fetch dummy item's ability handle
							for i = 0, 11 do
								local current_item = main_hero:GetItemInSlot(i)
								if current_item and current_item:GetName() == "item_imba_moon_shard" then
									current_item:ApplyDataDrivenModifier(main_hero, hero, shared_buff, {})
									break
								end
							end
							main_hero:RemoveItem(dummy_item)
						end

						-- Soul of Truth
						if shared_buff == "modifier_item_imba_soul_of_truth" then
							-- Create dummy item
							local dummy_item = CreateItem("item_imba_soul_of_truth", hero, hero)
							main_hero:AddItem(dummy_item)

							-- Fetch dummy item's ability handle
							for i = 0, 11 do
								local current_item = main_hero:GetItemInSlot(i)
								if current_item and current_item:GetName() == "item_imba_soul_of_truth" then
									current_item:ApplyDataDrivenModifier(main_hero, hero, shared_buff, {})
									break
								end
							end
							main_hero:RemoveItem(dummy_item)
						end
					end

					-- Apply any stacks if relevant
					if main_hero:GetModifierStackCount(shared_buff, nil) > 0 then
						hero:SetModifierStackCount(shared_buff, main_hero, main_hero:GetModifierStackCount(shared_buff, nil))
					end
				end
			end
		end
	elseif hero:GetUnitName() == "npc_dota_hero_meepo" then
		if not hero:IsClone() then
			hero.is_real_meepo = true
		end
	elseif hero:GetUnitName() == "npc_dota_hero_monkey_king" then
		if TRUE_MK_HAS_SPAWNED then
			return
		else
			hero.is_real_mk = true
			TRUE_MK_HAS_SPAWNED = true
		end
	elseif hero:GetUnitName() == "npc_dota_hero_pudge" then
		local flesh_heap_ability = hero:FindAbilityByName("imba_pudge_flesh_heap")
		hero:AddNewModifier(hero, flesh_heap_ability, "modifier_imba_pudge_flesh_heap_handler", {})
	elseif hero:GetUnitName() == "npc_dota_hero_troll_warlord" then -- troll warlord weird fix needed
		hero:SwapAbilities("imba_troll_warlord_whirling_axes_ranged", "imba_troll_warlord_whirling_axes_melee", true, false)
		hero:SwapAbilities("imba_troll_warlord_whirling_axes_ranged", "imba_troll_warlord_whirling_axes_melee", false, true)
		hero:SwapAbilities("imba_troll_warlord_whirling_axes_ranged", "imba_troll_warlord_whirling_axes_melee", true, false)
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

	if IsMutationMap() then
		-- Speed Freaks mutation modifier
		if IMBA_MUTATION["terrain"] == "speed_freaks" then
			hero:AddNewModifier(hero, nil, "modifier_mutation_speed_freaks", {})
		end

		-- Super Fervor mutation modifier
		if IMBA_MUTATION["positive"] == "super_fervor" then
			hero:AddNewModifier(hero, nil, "modifier_mutation_super_fervor", {})
		end

		-- Alien Incubation mutation modifier
		if IMBA_MUTATION["negative"] == "alien_incubation" then
			hero:AddNewModifier(hero, nil, "modifier_mutation_alien_incubation", {})
		end
	end
end

-- everytime a real hero respawn
function GameMode:OnHeroSpawned(hero)
	-- fix for killed with Ghost Revenant immolation
	if hero:HasModifier("modifier_ghost_revenant_ghost_immolation_debuff") then
		hero:RemoveModifierByName("modifier_ghost_revenant_ghost_immolation_debuff")
		Timers:CreateTimer(0.2, function()
			hero:SetHealth(100000)
		end)
	end

	if hero:GetUnitName() == "npc_dota_hero_meepo" then
		if hero:GetCloneSource() then
			if hero:GetCloneSource():IsAlive() then
				hero:RemoveModifierByName("modifier_command_restricted")
				hero:RemoveModifierByName("modifier_invulnerable")
			else
				hero:AddNewModifier(hero, nil, "modifier_command_restricted", {})
				hero:AddNewModifier(hero, nil, "modifier_invulnerable", {})
			end
		end
	end

	Timers:CreateTimer(1.0, function() -- Silencer fix
		if hero:HasModifier("modifier_silencer_int_steal") then
			hero:RemoveModifierByName("modifier_silencer_int_steal")
		end
	end)

	Timers:CreateTimer(FrameTime(), function()
		if IsNearFountain(hero:GetAbsOrigin(), 1200) == false then
			hero:SetHealth(hero:GetHealth() / 2)
			hero:SetMana(hero:GetMana() / 2)
		end
	end)
end
