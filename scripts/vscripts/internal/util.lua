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
	local gold = ( hero.kill_streak_count ^ KILLSTREAK_EXP_FACTOR ) * HERO_KILL_GOLD_PER_KILLSTREAK - hero.death_streak_count * HERO_KILL_GOLD_PER_DEATHSTREAK
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

			-- Keep the hero rooted and invulnerable for as long as the player remains disconnected
			Timers:CreateTimer(0, function()
				if GameMode.players[player_id].is_disconnected then
					hero:SetAbsOrigin(fountain_pos)
					return 1
				else
					hero:RemoveModifierByName("modifier_invulnerable")
					hero:RemoveModifierByName("modifier_rooted")
					hero:RemoveModifierByName("modifier_stunned")
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
		local current_gold = PlayerResource:GetGold(player_id)
		local connected_players_on_team

		if team == DOTA_TEAM_GOODGUYS then
			connected_players_on_team = GOODGUYS_CONNECTED_PLAYERS
		elseif team == DOTA_TEAM_BADGUYS then
			connected_players_on_team = BADGUYS_CONNECTED_PLAYERS
		end

		if current_gold >= connected_players_on_team then

			-- Calculates how much gold will be given
			local gold_to_share = math.floor( current_gold / connected_players_on_team )
			
			-- Distributes gold between the other players on the abandoner's team
			PlayerResource:SetGold(player_id, current_gold - gold_to_share * connected_players_on_team, false)
			for id = 0, 9 do
				local current_player = PlayerResource:GetPlayer(id)
				if PlayerResource:GetPlayer(id) and ( id ~= player_id ) and ( team == PlayerResource:GetTeam(id) ) then
					PlayerResource:ModifyGold(id, gold_to_share, false, DOTA_ModifyGold_AbandonedRedistribute)
				end
			end
		end

		-- If the player is still disconnected, keep checking
		if GameMode.players[player_id].is_disconnected then
			return 1
		end
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
		"sniper_shrapnel",
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
		"axe_counter_helix",
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
		"npc_dota_hero_sniper",
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
		"naga_siren_song_of_the_siren",
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
		"npc_dota_hero_naga_siren",
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