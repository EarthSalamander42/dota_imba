function DebugPrint(...)
	local spew = Convars:GetInt('barebones_spew') or -1
	if spew == -1 and BAREBONES_DEBUG_SPEW then
	spew = 1
	end

	if spew == 1 then
	print(...)
	end
end

function DebugPrintTable(...)
	local spew = Convars:GetInt('barebones_spew') or -1
	if spew == -1 and BAREBONES_DEBUG_SPEW then
	spew = 1
	end

	if spew == 1 then
	PrintTable(...)
	end
end

function PrintTable(t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
	if type(t) ~= "table" then return end

	done = done or {}
	done[t] = true
	indent = indent or 0

	local l = {}
	for k, v in pairs(t) do
	table.insert(l, k)
	end

	table.sort(l)
	for k, v in ipairs(l) do
	-- Ignore FDesc
	if v ~= 'FDesc' then
		local value = t[v]

		if type(value) == "table" and not done[value] then
		done [value] = true
		print(string.rep ("\t", indent)..tostring(v)..":")
		PrintTable (value, indent + 2, done)
		elseif type(value) == "userdata" and not done[value] then
		done [value] = true
		print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
		PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
		else
		if t.FDesc and t.FDesc[v] then
			print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
		else
			print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
		end
		end
	end
	end
end

-- Colors
COLOR_NONE = '\x06'
COLOR_GRAY = '\x06'
COLOR_GREY = '\x06'
COLOR_GREEN = '\x0C'
COLOR_DPURPLE = '\x0D'
COLOR_SPINK = '\x0E'
COLOR_DYELLOW = '\x10'
COLOR_PINK = '\x11'
COLOR_RED = '\x12'
COLOR_LGREEN = '\x15'
COLOR_BLUE = '\x16'
COLOR_DGREEN = '\x18'
COLOR_SBLUE = '\x19'
COLOR_PURPLE = '\x1A'
COLOR_ORANGE = '\x1B'
COLOR_LRED = '\x1C'
COLOR_GOLD = '\x1D'

-------------------------------------------------------------------------------------------------
-- IMBA: custom utility functions
-------------------------------------------------------------------------------------------------

-- Checks if a hero is wielding Aghanim's Scepter
function HasScepter(hero)
	if hero:HasModifier("modifier_item_ultimate_scepter_consumed") then
		return true
	end

	for i=0,5 do
		local item = hero:GetItemInSlot(i)
		if item and item:GetAbilityName() == "item_ultimate_scepter" then
			return true
		end
	end
	
	return false
end

-- Checks if a hero is wielding an Aegis of the immortal
function HasAegis(hero)
	for i=0,5 do
		local item = hero:GetItemInSlot(i)
		if item and item:GetAbilityName() == "item_aegis" then
			return true
		end
	end
	return false
end

-- Adds [stack_amount] stacks to a modifier
function AddStacks(ability, caster, unit, modifier, stack_amount, refresh)
	if unit:HasModifier(modifier) then
		if refresh then
			ability:ApplyDataDrivenModifier(caster, unit, modifier, {})
		end
		unit:SetModifierStackCount(modifier, ability, unit:GetModifierStackCount(modifier, ability) + stack_amount)
	else
		ability:ApplyDataDrivenModifier(caster, unit, modifier, {})
		unit:SetModifierStackCount(modifier, ability, stack_amount)
	end
end

-- Removes [stack_amount] stacks from a modifier
function RemoveStacks(ability, unit, modifier, stack_amount)
	if unit:HasModifier(modifier) then
		if unit:GetModifierStackCount(modifier, ability) > stack_amount then
			unit:SetModifierStackCount(modifier, ability, unit:GetModifierStackCount(modifier, ability) - stack_amount)
		else
			unit:RemoveModifierByName(modifier)
		end
	end
end

-- Switches one skill with another
function SwitchAbilities(hero, added_ability_name, removed_ability_name, keep_level, keep_cooldown)
	local removed_ability = hero:FindAbilityByName(removed_ability_name)
	local level = removed_ability:GetLevel()
	local cooldown = removed_ability:GetCooldownTimeRemaining()
	hero:RemoveAbility(removed_ability_name)
	hero:AddAbility(added_ability_name)
	local added_ability = hero:FindAbilityByName(added_ability_name)
	
	if keep_level then
		added_ability:SetLevel(level)
	end
	
	if keep_cooldown then
		added_ability:StartCooldown(cooldown)
	end
end

-- Removes unwanted passive modifiers from illusions upon their creation
function IllusionPassiveRemover( keys )
	local target = keys.target
	local modifier = keys.modifier

	if target:IsIllusion() or not target:GetPlayerOwner() then
		target:RemoveModifierByName(modifier)
	end
end

function ApplyDataDrivenModifierWhenPossible( caster, target, ability, modifier_name)
	Timers:CreateTimer(0, function()
		if target:IsOutOfGame() or target:IsInvulnerable() then
			return 0.1
		else
			ability:ApplyDataDrivenModifier(caster, target, modifier_name, {})
		end			
	end)
end

--[[ ============================================================================================================
	Author: Rook
	Date: February 3, 2015
	A helper method that switches the removed_item item to one with the inputted name.
================================================================================================================= ]]
function SwapToItem(caster, removed_item, added_item)
	for i=0, 5, 1 do  --Fill all empty slots in the player's inventory with "dummy" items.
		local current_item = caster:GetItemInSlot(i)
		if current_item == nil then
			caster:AddItem(CreateItem("item_imba_dummy", caster, caster))
		end
	end
	
	caster:RemoveItem(removed_item)
	caster:AddItem(CreateItem(added_item, caster, caster))  --This should be put into the same slot that the removed item was in.
	
	for i=0, 5, 1 do  --Remove all dummy items from the player's inventory.
		local current_item = caster:GetItemInSlot(i)
		if current_item ~= nil then
			if current_item:GetName() == "item_imba_dummy" then
				caster:RemoveItem(current_item)
			end
		end
	end
end

-- Checks if a given unit is Roshan
function IsRoshan(unit)
	if unit:GetName() == "npc_dota_roshan" then
		return true
	else
		return false
	end
end

-- 100% kills a unit. Activates death-preventing modifiers, then removes them. Does not killsteal from Reaper's Scythe.
function TrueKill(caster, target, ability)
	
	-- Shallow Grave is more pesky
	target:RemoveModifierByName("modifier_imba_shallow_grave")

	-- Deals lethal damage in order to trigger death-preventing abilities
	target:Kill(ability, caster)

	-- Removes the relevant modifiers
	target:RemoveModifierByName("modifier_imba_shallow_grave")
	target:RemoveModifierByName("modifier_aphotic_shield")
	target:RemoveModifierByName("modifier_imba_spiked_carapace")
	target:RemoveModifierByName("modifier_imba_purification_passive")

	-- Kills the target
	target:Kill(ability, caster)
end

-- Checks if a unit is near units of a certain class not on its team
function IsNearEnemyClass(unit, radius, class)
	local class_units = Entities:FindAllByClassnameWithin(class, unit:GetAbsOrigin(), radius)

	for _,found_unit in pairs(class_units) do
		if found_unit:GetTeam() ~= unit:GetTeam() then
			return true
		end
	end
	
	return false
end

-- Checks if a unit is near units of a certain class on the same team
function IsNearFriendlyClass(unit, radius, class)
	local class_units = Entities:FindAllByClassnameWithin(class, unit:GetAbsOrigin(), radius)

	for _,found_unit in pairs(class_units) do
		if found_unit:GetTeam() == unit:GetTeam() then
			return true
		end
	end
	
	return false
end

-- Returns the killstreak/deathstreak bonus gold for this hero
function GetKillstreakGold( hero )
	local base_bounty = HERO_KILL_GOLD_BASE + hero:GetLevel() * HERO_KILL_GOLD_PER_LEVEL
	local gold = ( hero.kill_streak_count ^ KILLSTREAK_EXP_FACTOR ) * HERO_KILL_GOLD_PER_KILLSTREAK - hero.death_streak_count * HERO_KILL_GOLD_PER_DEATHSTREAK
	
	-- Limits to maximum and minimum kill/deathstreak values
	gold = math.max(gold, (-1) * base_bounty * HERO_KILL_GOLD_DEATHSTREAK_CAP / 100 )
	gold = math.min(gold, base_bounty * ( HERO_KILL_GOLD_KILLSTREAK_CAP - 100 ) / 100)

	return gold
end

-- Returns if this unit is a fountain or not
function IsFountain( unit )
	if unit:GetName() == "ent_dota_fountain_bad" or unit:GetName() == "ent_dota_fountain_good" then
		return true
	end
	
	return false
end

-- Returns true if the target is hard disabled
function IsHardDisabled( unit )
	if unit:IsStunned() or unit:IsHexed() or unit:IsNightmared() or unit:IsOutOfGame() or unit:HasModifier("modifier_axe_berserkers_call") then
		return true
	end

	return false
end

-- Handles a player's abandoned state
function AbandonGame( hero, player_id )
	local team = PlayerResource:GetTeam(player_id)
	local fountain_pos = Vector(0, 0, 0)
	
	-- Retrieves the position the player should move to
	if team == DOTA_TEAM_GOODGUYS then
		fountain_pos = Vector(-7456, -6938, 400)
	elseif team == DOTA_TEAM_BADGUYS then
		fountain_pos = Vector(7412, 6750, 649)
	end

	-- Start moving the player's hero to the fountain
	Timers:CreateTimer(0, function()
		hero:MoveToPosition(fountain_pos)

		-- If the hero is close enough to the fountain, make it rooted and invulnerable
		if IsNearFriendlyClass(hero, 300, "ent_dota_fountain") then
			local fountain_pos = hero:GetAbsOrigin()
			hero:AddNewModifier(hero, nil, "modifier_invulnerable", {})
			hero:AddNewModifier(hero, nil, "modifier_rooted", {})
			hero:AddNewModifier(hero, nil, "modifier_stunned", {})
			hero:AddNewModifier(hero, nil, "modifier_obsidian_destroyer_astral_imprisonment_prison", {})

			-- Keep the hero rooted and invulnerable for as long as the player remains disconnected
			Timers:CreateTimer(0, function()
				if GameMode.players[player_id].is_disconnected then
					hero:SetAbsOrigin(fountain_pos)
					return 1
				else
					hero:RemoveModifierByName("modifier_invulnerable")
					hero:RemoveModifierByName("modifier_rooted")
					hero:RemoveModifierByName("modifier_stunned")
					hero:RemoveModifierByName("modifier_obsidian_destroyer_astral_imprisonment_prison")
				end
			end)

		-- Otherwise, if the player is still disconnected, keep moving towards it
		elseif GameMode.players[player_id].is_disconnected then
			return 0.1
		end
	end)

	-- Distribute any gold the player gains to its teammates
	Timers:CreateTimer(0, function()

		-- Calculates if there is enough gold to be shared without loss
		--local current_gold = PlayerResource:GetGold(player_id)
		--local connected_players_on_team

		--if team == DOTA_TEAM_GOODGUYS then
		--	connected_players_on_team = GOODGUYS_CONNECTED_PLAYERS
		--elseif team == DOTA_TEAM_BADGUYS then
		--	connected_players_on_team = BADGUYS_CONNECTED_PLAYERS
		--end

		--if current_gold >= connected_players_on_team then

			-- Calculates how much gold will be given
		--	local gold_to_share = math.floor( current_gold / connected_players_on_team )
			
			-- Distributes gold between the other players on the abandoner's team
		--	PlayerResource:SpendGold(player_id, gold_to_share * connected_players_on_team, DOTA_ModifyGold_AbandonedRedistribute)
			--PlayerResource:SetGold(player_id, current_gold - gold_to_share * connected_players_on_team, true)
		--	for id = 0, 9 do
		--		local current_player = PlayerResource:GetPlayer(id)
		--		if PlayerResource:GetPlayer(id) and ( id ~= player_id ) and ( team == PlayerResource:GetTeam(id) ) then
		--			PlayerResource:ModifyGold(id, gold_to_share, false, DOTA_ModifyGold_AbandonedRedistribute)
		--		end
		--	end
		--end

		-- If the player is still disconnected, keep checking
		--if GameMode.players[player_id].is_disconnected then
		--	return 1
		--end
	end)
end

-- Picks a legal non-ultimate ability in Random OMG mode
function GetRandomNormalAbility()

	local legal_abilities = {
		"alchemist_acid_spray",
		"alchemist_goblins_greed",
		"ancient_apparition_cold_feet",
		"ancient_apparition_ice_vortex",
		"ancient_apparition_chilling_touch",
		"chaos_knight_chaos_bolt",
		"chaos_knight_reality_rift",
		"chaos_knight_chaos_strike",
		"earthshaker_fissure",
		"earthshaker_enchant_totem",
		"earthshaker_aftershock",
		"faceless_void_time_walk",
		"faceless_void_backtrack",
		"faceless_void_time_lock",
		"juggernaut_blade_fury",
		"juggernaut_blade_dance",
		"juggernaut_healing_ward",
		"lion_impale",
		"lion_voodoo",
		"lion_mana_drain",
		"medusa_split_shot",
		"medusa_mystic_snake",
		"medusa_mana_shield",
		"naga_siren_mirror_image",
		"naga_siren_ensnare",
		"naga_siren_rip_tide",
		"furion_sprout",
		"furion_teleportation",
		"furion_force_of_nature",
		"phantom_lancer_spirit_lance",
		"phantom_lancer_doppelwalk",
		"phantom_lancer_phantom_edge",
		"sandking_burrowstrike",
		"sandking_sand_storm",
		"sandking_caustic_finale",
		"shadow_demon_disruption",
		"shadow_demon_soul_catcher",
		"nevermore_shadowraze1",
		"nevermore_shadowraze2",
		"nevermore_shadowraze3",
		"nevermore_necromastery",
		"nevermore_dark_lord",
		"shadow_shaman_ether_shock",
		"shadow_shaman_voodoo",
		"shadow_shaman_shackles",
		"slark_dark_pact",
		"slark_pounce",
		"slark_essence_shift",
		"storm_spirit_static_remnant",
		"storm_spirit_electric_vortex",
		"storm_spirit_overload",
		"sven_storm_bolt",
		"sven_great_cleave",
		"sven_warcry",
		"templar_assassin_refraction",
		"templar_assassin_meld",
		"templar_assassin_psi_blades",
		"terrorblade_reflection",
		"terrorblade_metamorphosis",
		"tinker_laser",
		"tinker_heat_seeking_missile",
		"tinker_march_of_the_machines",
		"ursa_earthshock",
		"ursa_overpower",
		"ursa_fury_swipes",
		"vengefulspirit_magic_missile",
		"vengefulspirit_command_aura",
		"vengefulspirit_wave_of_terror",
		"venomancer_venomous_gale",
		"venomancer_poison_sting",
		"venomancer_plague_ward",
		"wisp_overcharge",
		"imba_abaddon_frostmourne",
		"imba_antimage_mana_break",
		"imba_antimage_spell_shield",
		"antimage_blink",
		"imba_axe_berserkers_call",
		"imba_axe_battle_hunger",
		"imba_bane_enfeeble",
		"imba_bane_brain_sap",
		"imba_bounty_hunter_shuriken_toss",
		"imba_bounty_hunter_wind_walk",
		"bounty_hunter_jinada",
		"imba_centaur_hoof_stomp",
		"imba_centaur_double_edge",
		"imba_centaur_return",
		"imba_crystal_maiden_crystal_nova",
		"imba_crystal_maiden_frostbite",
		"imba_crystal_maiden_brilliance_aura",
		"imba_dazzle_poison_touch",
		"imba_dazzle_shallow_grave",
		"imba_dazzle_shadow_wave",
		"imba_drow_ranger_gust",
		"imba_drow_ranger_trueshot",
		"imba_jakiro_liquid_fire",
		"jakiro_ice_path",
		"imba_kunkka_tidebringer",
		"imba_lich_frost_nova",
		"imba_lich_frost_armor",
		"imba_lich_dark_ritual",
		"imba_lina_light_strike_array",
		"imba_mirana_starfall",
		"imba_mirana_arrow",
		"imba_mirana_leap",
		"imba_necrolyte_death_pulse",
		"imba_necrolyte_heartstopper_aura",
		"imba_necrolyte_sadist",
		"imba_night_stalker_void",
		"imba_night_stalker_crippling_fear",
		"imba_night_stalker_hunter_in_the_night",
		"imba_nyx_assassin_impale",
		"imba_nyx_assassin_spiked_carapace",
		"nyx_assassin_mana_burn",
		"imba_obsidian_destroyer_arcane_orb",
		"imba_obsidian_destroyer_essence_aura",
		"imba_omniknight_purification",
		"imba_omniknight_repel",
		"imba_omniknight_degen_aura",
		"imba_phantom_assassin_phantom_strike",
		"imba_phantom_assassin_blur",
		"imba_queenofpain_shadow_strike",
		"imba_queenofpain_scream_of_pain",
		"imba_pudge_meat_hook",
		"imba_pudge_rot",
		"imba_pudge_flesh_heap"
	}

	local ability_owners = {
		"npc_dota_hero_alchemist",
		"npc_dota_hero_alchemist",
		"npc_dota_hero_ancient_apparition",
		"npc_dota_hero_ancient_apparition",
		"npc_dota_hero_ancient_apparition",
		"npc_dota_hero_chaos_knight",
		"npc_dota_hero_chaos_knight",
		"npc_dota_hero_chaos_knight",
		"npc_dota_hero_earthshaker",
		"npc_dota_hero_earthshaker",
		"npc_dota_hero_earthshaker",
		"npc_dota_hero_faceless_void",
		"npc_dota_hero_faceless_void",
		"npc_dota_hero_faceless_void",
		"npc_dota_hero_juggernaut",
		"npc_dota_hero_juggernaut",
		"npc_dota_hero_juggernaut",
		"npc_dota_hero_lion",
		"npc_dota_hero_lion",
		"npc_dota_hero_lion",
		"npc_dota_hero_medusa",
		"npc_dota_hero_medusa",
		"npc_dota_hero_medusa",
		"npc_dota_hero_naga_siren",
		"npc_dota_hero_naga_siren",
		"npc_dota_hero_naga_siren",
		"npc_dota_hero_furion",
		"npc_dota_hero_furion",
		"npc_dota_hero_furion",
		"npc_dota_hero_phantom_lancer",
		"npc_dota_hero_phantom_lancer",
		"npc_dota_hero_phantom_lancer",
		"npc_dota_hero_sand_king",
		"npc_dota_hero_sand_king",
		"npc_dota_hero_sand_king",
		"npc_dota_hero_shadow_demon",
		"npc_dota_hero_shadow_demon",
		"npc_dota_hero_nevermore",
		"npc_dota_hero_nevermore",
		"npc_dota_hero_nevermore",
		"npc_dota_hero_nevermore",
		"npc_dota_hero_nevermore",
		"npc_dota_hero_shadow_shaman",
		"npc_dota_hero_shadow_shaman",
		"npc_dota_hero_shadow_shaman",
		"npc_dota_hero_slark",
		"npc_dota_hero_slark",
		"npc_dota_hero_slark",
		"npc_dota_hero_storm_spirit",
		"npc_dota_hero_storm_spirit",
		"npc_dota_hero_storm_spirit",
		"npc_dota_hero_sven",
		"npc_dota_hero_sven",
		"npc_dota_hero_sven",
		"npc_dota_hero_templar_assassin",
		"npc_dota_hero_templar_assassin",
		"npc_dota_hero_templar_assassin",
		"npc_dota_hero_terrorblade",
		"npc_dota_hero_terrorblade",
		"npc_dota_hero_tinker",
		"npc_dota_hero_tinker",
		"npc_dota_hero_tinker",
		"npc_dota_hero_ursa",
		"npc_dota_hero_ursa",
		"npc_dota_hero_ursa",
		"npc_dota_hero_vengefulspirit",
		"npc_dota_hero_vengefulspirit",
		"npc_dota_hero_vengefulspirit",
		"npc_dota_hero_venomancer",
		"npc_dota_hero_venomancer",
		"npc_dota_hero_venomancer",
		"npc_dota_hero_wisp",
		"npc_dota_hero_abaddon",
		"npc_dota_hero_antimage",
		"npc_dota_hero_antimage",
		"npc_dota_hero_antimage",
		"npc_dota_hero_axe",
		"npc_dota_hero_axe",
		"npc_dota_hero_bane",
		"npc_dota_hero_bane",
		"npc_dota_hero_bounty_hunter",
		"npc_dota_hero_bounty_hunter",
		"npc_dota_hero_bounty_hunter",
		"npc_dota_hero_centaur",
		"npc_dota_hero_centaur",
		"npc_dota_hero_centaur",
		"npc_dota_hero_crystal_maiden",
		"npc_dota_hero_crystal_maiden",
		"npc_dota_hero_crystal_maiden",
		"npc_dota_hero_dazzle",
		"npc_dota_hero_dazzle",
		"npc_dota_hero_dazzle",
		"npc_dota_hero_drow_ranger",
		"npc_dota_hero_drow_ranger",
		"npc_dota_hero_jakiro",
		"npc_dota_hero_jakiro",
		"npc_dota_hero_kunkka",
		"npc_dota_hero_lich",
		"npc_dota_hero_lich",
		"npc_dota_hero_lich",
		"npc_dota_hero_lina",
		"npc_dota_hero_mirana",
		"npc_dota_hero_mirana",
		"npc_dota_hero_mirana",
		"npc_dota_hero_necrolyte",
		"npc_dota_hero_necrolyte",
		"npc_dota_hero_necrolyte",
		"npc_dota_hero_night_stalker",
		"npc_dota_hero_night_stalker",
		"npc_dota_hero_night_stalker",
		"npc_dota_hero_nyx_assassin",
		"npc_dota_hero_nyx_assassin",
		"npc_dota_hero_nyx_assassin",
		"npc_dota_hero_obsidian_destroyer",
		"npc_dota_hero_obsidian_destroyer",
		"npc_dota_hero_omniknight",
		"npc_dota_hero_omniknight",
		"npc_dota_hero_omniknight",
		"npc_dota_hero_phantom_assassin",
		"npc_dota_hero_phantom_assassin",
		"npc_dota_hero_queenofpain",
		"npc_dota_hero_queenofpain",
		"npc_dota_hero_pudge",
		"npc_dota_hero_pudge",
		"npc_dota_hero_pudge"
	}

	local random_int = RandomInt(1, #legal_abilities)
	return legal_abilities[random_int], ability_owners[random_int]
end

-- Picks a legal ultimate ability in Random OMG mode
function GetRandomUltimateAbility()

	local legal_ultimates = {
		"alchemist_chemical_rage",
		"chaos_knight_phantasm",
		"earthshaker_echo_slam",
		"faceless_void_chronosphere",
		"juggernaut_omni_slash",
		"lion_finger_of_death",
		"medusa_stone_gaze",
		"furion_wrath_of_nature",
		"phantom_lancer_juxtapose",
		"phoenix_supernova",
		"sandking_epicenter",
		"slark_shadow_dance",
		"storm_spirit_ball_lightning",
		"sven_gods_strength",
		"terrorblade_sunder",
		"tinker_rearm",
		"ursa_enrage",
		"vengefulspirit_nether_swap",
		"venomancer_poison_nova",
		"imba_abaddon_borrowed_time",
		"imba_antimage_mana_void",
		"imba_axe_culling_blade",
		"imba_bane_fiends_grip",
		"imba_centaur_stampede",
		"imba_crystal_maiden_freezing_field",
		"imba_dazzle_weave",
		"imba_jakiro_macropyre",
		"imba_kunkka_ghostship",
		"imba_lich_chain_frost",
		"imba_lina_laguna_blade",
		"imba_mirana_invis",
		"imba_necrolyte_reapers_scythe",
		"imba_nyx_assassin_vendetta",
		"imba_phantom_assassin_coup_de_grace",
		"imba_sniper_assassinate",
		"imba_pudge_dismember"
	}

	local ultimate_owners = {
		"npc_dota_hero_alchemist",
		"npc_dota_hero_chaos_knight",
		"npc_dota_hero_earthshaker",
		"npc_dota_hero_faceless_void",
		"npc_dota_hero_juggernaut",
		"npc_dota_hero_lion",
		"npc_dota_hero_medusa",
		"npc_dota_hero_furion",
		"npc_dota_hero_phantom_lancer",
		"npc_dota_hero_phoenix",
		"npc_dota_hero_sand_king",
		"npc_dota_hero_slark",
		"npc_dota_hero_storm_spirit",
		"npc_dota_hero_sven",
		"npc_dota_hero_terrorblade",
		"npc_dota_hero_tinker",
		"npc_dota_hero_ursa",
		"npc_dota_hero_vengefulspirit",
		"npc_dota_hero_venomancer",
		"npc_dota_hero_abaddon",
		"npc_dota_hero_antimage",
		"npc_dota_hero_axe",
		"npc_dota_hero_bane",
		"npc_dota_hero_centaur",
		"npc_dota_hero_crystal_maiden",
		"npc_dota_hero_dazzle",
		"npc_dota_hero_jakiro",
		"npc_dota_hero_kunkka",
		"npc_dota_hero_lich",
		"npc_dota_hero_lina",
		"npc_dota_hero_mirana",
		"npc_dota_hero_necrolyte",
		"npc_dota_hero_nyx_assassin",
		"npc_dota_hero_phantom_assassin",
		"npc_dota_hero_sniper",
		"npc_dota_hero_pudge"
	}

	local random_int = RandomInt(1, #legal_ultimates)
	return legal_ultimates[random_int], ultimate_owners[random_int]
end

-- Grants a given hero an appropriate amount of Random OMG abilities
function ApplyAllRandomOmgAbilities( hero )

	-- Check if the high level power-up ability is present
	local ability_powerup = hero:FindAbilityByName("imba_unlimited_level_powerup")
	local powerup_stacks
	if ability_powerup then
		powerup_stacks = hero:GetModifierStackCount("modifier_imba_unlimited_level_powerup", hero)
		hero:RemoveModifierByName("modifier_imba_unlimited_level_powerup")
		ability_powerup = true
	end

	-- Remove default abilities
	for i = 0, 15 do
		local old_ability = hero:GetAbilityByIndex(i)
		if old_ability then
			hero:RemoveAbility(old_ability:GetAbilityName())
		end
	end

	-- Creates the table to store ability information for that hero
	if not hero.random_omg_abilities then
		hero.random_omg_abilities = {}
	end

	-- Initialize the precache list if necessary
	if not GameMode.precached_hero_list then
		GameMode.precached_hero_list = {}
		for id = 0, 9 do
			if GameMode.players[id] and GameMode.players[id] ~= "empty_player_slot" then
				table.insert(GameMode.precached_hero_list, GameMode.heroes[id]:GetName())
			end
		end
	end

	-- Add new regular abilities
	local i = 1
	while i <= IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT do

		-- Randoms an ability from the list of legal random omg abilities
		local randomed_ability
		local ability_owner
		randomed_ability, ability_owner = GetRandomNormalAbility()

		-- Checks for duplicate abilities
		if not hero:FindAbilityByName(randomed_ability) then

			-- Add the ability
			hero:AddAbility(randomed_ability)

			-- Check if this hero has been precached before
			local is_precached = false
			for j = 1, #GameMode.precached_hero_list do
				if GameMode.precached_hero_list[j] == ability_owner then
					is_precached = true
				end
			end

			-- If not, do so and add it to the precached heroes list
			if not is_precached then
				PrecacheUnitByNameAsync(ability_owner, function(...) end)
				table.insert(GameMode.precached_hero_list, ability_owner)
			end

			-- Store it for later reference
			hero.random_omg_abilities[i] = randomed_ability
			i = i + 1
		end
	end

	-- Add new ultimate abilities
	while i <= IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT + IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT do

		-- Randoms an ability from the list of legal random omg ultimates
		local randomed_ultimate
		local ultimate_owner
		randomed_ultimate, ultimate_owner = GetRandomUltimateAbility()

		-- Checks for duplicate abilities
		if not hero:FindAbilityByName(randomed_ultimate) then

			-- Add the ultimate
			hero:AddAbility(randomed_ultimate)

			-- Check if this hero has been precached before
			local is_precached = false
			for j = 1, #GameMode.precached_hero_list do
				if GameMode.precached_hero_list[j] == ultimate_owner then
					is_precached = true
				end
			end

			-- If not, do so and add it to the precached heroes list
			if not is_precached then
				PrecacheUnitByNameAsync(ultimate_owner, function(...) end)
				table.insert(GameMode.precached_hero_list, ultimate_owner)
			end

			-- Store it for later reference
			hero.random_omg_abilities[i] = randomed_ultimate
			i = i + 1
		end
	end

	-- Figure out which attribute bonus to add
	local ability_start_string = ""
	local ability_end_string = ""

	-- Choose number of abilities
	if IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT == 3 and IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT == 2 then
		ability_end_string = "_random_omg_3a2u"
	elseif IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT == 4 and IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT == 1 then
		ability_end_string = "_random_omg_4a1u"
	elseif IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT == 5 and IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT == 1 then
		ability_end_string = "_random_omg_5a1u"
	elseif IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT == 4 and IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT == 2 then
		ability_end_string = "_random_omg_4a2u"
	end

	-- Choose attribute
	if hero:GetPrimaryAttribute() == 0 then
		ability_start_string = "attribute_bonus_str"
	elseif hero:GetPrimaryAttribute() == 1 then
		ability_start_string = "attribute_bonus_agi"
	elseif hero:GetPrimaryAttribute() == 2 then
		ability_start_string = "attribute_bonus_int"
	end

	-- Re-add attribute bonus and store it for reference
	hero:AddAbility(ability_start_string..ability_end_string)
	hero.random_omg_abilities[i] = ability_start_string..ability_end_string
	i = i + 1

	-- Apply ability layout modifier
	local layout_ability_name
	if IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT + IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT == 4 then
		layout_ability_name = "random_omg_ability_layout_changer_4"
	elseif IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT + IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT == 5 then
		layout_ability_name = "random_omg_ability_layout_changer_5"
	elseif IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT + IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT == 6 then
		layout_ability_name = "random_omg_ability_layout_changer_6"
	end

	hero:AddAbility(layout_ability_name)
	local layout_ability = hero:FindAbilityByName(layout_ability_name)
	layout_ability:SetLevel(1)
	hero.random_omg_abilities[i] = layout_ability_name

	-- Apply high level powerup ability, if previously existing
	if ability_powerup then
		hero:AddAbility("imba_unlimited_level_powerup")
		ability_powerup = hero:FindAbilityByName("imba_unlimited_level_powerup")
		ability_powerup:SetLevel(1)
		AddStacks(ability_powerup, hero, hero, "modifier_imba_unlimited_level_powerup", powerup_stacks, true)
	end

end

-- Randoms a hero not in the forbidden Random OMG hero pool
function PickValidHeroRandomOMG()

	local valid_heroes = {
		"npc_dota_hero_abaddon",
		"npc_dota_hero_alchemist",
		"npc_dota_hero_ancient_apparition",
		"npc_dota_hero_antimage",
		"npc_dota_hero_axe",
		"npc_dota_hero_bane",
		"npc_dota_hero_bounty_hunter",
		"npc_dota_hero_centaur",
		"npc_dota_hero_chaos_knight",
		"npc_dota_hero_crystal_maiden",
		"npc_dota_hero_dazzle",
		"npc_dota_hero_drow_ranger",
		"npc_dota_hero_earthshaker",
		"npc_dota_hero_jakiro",
		"npc_dota_hero_juggernaut",
		"npc_dota_hero_kunkka",
		"npc_dota_hero_lich",
		"npc_dota_hero_lina",
		"npc_dota_hero_lion",
		"npc_dota_hero_medusa",
		"npc_dota_hero_mirana",
		"npc_dota_hero_naga_siren",
		"npc_dota_hero_furion",
		"npc_dota_hero_necrolyte",
		"npc_dota_hero_obsidian_destroyer",
		"npc_dota_hero_omniknight",
		"npc_dota_hero_phantom_assassin",
		"npc_dota_hero_phantom_lancer",
		"npc_dota_hero_phoenix",
		"npc_dota_hero_queenofpain",
		"npc_dota_hero_sand_king",
		"npc_dota_hero_shadow_demon",
		"npc_dota_hero_nevermore",
		"npc_dota_hero_slark",
		"npc_dota_hero_sniper",
		"npc_dota_hero_storm_spirit",
		"npc_dota_hero_sven",
		"npc_dota_hero_templar_assassin",
		"npc_dota_hero_terrorblade",
		"npc_dota_hero_tinker",
		"npc_dota_hero_ursa",
		"npc_dota_hero_vengefulspirit",
		"npc_dota_hero_venomancer",
		"npc_dota_hero_wisp"
	}

	return valid_heroes[RandomInt(1, #valid_heroes)]
end

-- Checks if a hero is a valid pick in Random OMG
function IsValidPickRandomOMG( hero )

	local hero_name = hero:GetName()

	local valid_heroes = {
		"npc_dota_hero_abaddon",
		"npc_dota_hero_alchemist",
		"npc_dota_hero_ancient_apparition",
		"npc_dota_hero_antimage",
		"npc_dota_hero_axe",
		"npc_dota_hero_bane",
		"npc_dota_hero_bounty_hunter",
		"npc_dota_hero_centaur",
		"npc_dota_hero_chaos_knight",
		"npc_dota_hero_crystal_maiden",
		"npc_dota_hero_dazzle",
		"npc_dota_hero_drow_ranger",
		"npc_dota_hero_earthshaker",
		"npc_dota_hero_jakiro",
		"npc_dota_hero_juggernaut",
		"npc_dota_hero_kunkka",
		"npc_dota_hero_lich",
		"npc_dota_hero_lina",
		"npc_dota_hero_lion",
		"npc_dota_hero_medusa",
		"npc_dota_hero_mirana",
		"npc_dota_hero_naga_siren",
		"npc_dota_hero_furion",
		"npc_dota_hero_necrolyte",
		"npc_dota_hero_obsidian_destroyer",
		"npc_dota_hero_omniknight",
		"npc_dota_hero_phantom_assassin",
		"npc_dota_hero_phantom_lancer",
		"npc_dota_hero_phoenix",
		"npc_dota_hero_queenofpain",
		"npc_dota_hero_sand_king",
		"npc_dota_hero_shadow_demon",
		"npc_dota_hero_nevermore",
		"npc_dota_hero_slark",
		"npc_dota_hero_sniper",
		"npc_dota_hero_storm_spirit",
		"npc_dota_hero_sven",
		"npc_dota_hero_templar_assassin",
		"npc_dota_hero_terrorblade",
		"npc_dota_hero_tinker",
		"npc_dota_hero_ursa",
		"npc_dota_hero_vengefulspirit",
		"npc_dota_hero_venomancer",
		"npc_dota_hero_wisp"
	}

	for i = 1, #valid_heroes do
		if valid_heroes[i] == hero_name then
			return true
		end
	end

	return false
end

-- Removes undesired permanent modifiers in Random OMG mode
function RemovePermanentModifiersRandomOMG( hero )
	hero:RemoveModifierByName("modifier_imba_tidebringer_cooldown")
	hero:RemoveModifierByName("modifier_imba_hunter_in_the_night")
	hero:RemoveModifierByName("modifier_imba_shallow_grave_scepter_check")
	hero:RemoveModifierByName("modifier_imba_shallow_grave_scepter")
	hero:RemoveModifierByName("modifier_imba_shallow_grave_scepter_cooldown")
	hero:RemoveModifierByName("modifier_imba_vendetta_damage_stacks")
	hero:RemoveModifierByName("modifier_imba_heartstopper_aura")
	hero:RemoveModifierByName("modifier_imba_antimage_spell_shield_passive")
	hero:RemoveModifierByName("modifier_imba_brilliance_aura")
	hero:RemoveModifierByName("modifier_imba_trueshot_aura_owner_hero")
	hero:RemoveModifierByName("modifier_imba_trueshot_aura_owner_creep")
	hero:RemoveModifierByName("modifier_imba_frost_nova_aura")
	hero:RemoveModifierByName("modifier_imba_moonlight_scepter_aura")
	hero:RemoveModifierByName("modifier_imba_sadist_aura")
	hero:RemoveModifierByName("modifier_imba_impale_aura")
	hero:RemoveModifierByName("modifier_imba_essence_aura")
	hero:RemoveModifierByName("modifier_imba_degen_aura")
	hero:RemoveModifierByName("modifier_imba_flesh_heap_aura")
	hero:RemoveModifierByName("modifier_borrowed_time")
	hero:RemoveModifierByName("attribute_bonus_str")
	hero:RemoveModifierByName("attribute_bonus_agi")
	hero:RemoveModifierByName("attribute_bonus_int")
	hero:RemoveModifierByName("modifier_imba_hook_sharp_stack")
	hero:RemoveModifierByName("modifier_imba_hook_light_stack")
	hero:RemoveModifierByName("modifier_sven_gods_strength")
	hero:RemoveModifierByName("modifier_imba_blur")
end