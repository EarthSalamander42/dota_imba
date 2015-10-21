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

-- Returns a random value from a non-array table
function RandomFromTable(table)
	local array = {}
	local n = 0
	for _,v in pairs(table) do
		array[#array+1] = v
		n = n + 1
	end

	if n == 0 then return nil end

	return array[RandomInt(1,n)]
end

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
	if hero.has_aegis then
		return true
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
	if unit:GetName() == "npc_imba_roshan" or unit:GetName() == "npc_dota_roshan" then
		return true
	else
		return false
	end
end

-- 100% kills a unit. Activates death-preventing modifiers, then removes them. Does not killsteal from Reaper's Scythe.
function TrueKill(caster, target, ability)
	
	-- Shallow Grave and Purification are peskier
	target:RemoveModifierByName("modifier_imba_shallow_grave")

	-- Extremely specific blademail interaction because fuck everything
	if caster:HasModifier("modifier_item_blade_mail_reflect") then
		target:RemoveModifierByName("modifier_imba_purification_passive")
	end

	-- Deals lethal damage in order to trigger death-preventing abilities
	target:Kill(ability, caster)

	-- Removes the relevant modifiers
	target:RemoveModifierByName("modifier_invulnerable")
	target:RemoveModifierByName("modifier_imba_shallow_grave")
	target:RemoveModifierByName("modifier_aphotic_shield")
	target:RemoveModifierByName("modifier_imba_spiked_carapace")
	target:RemoveModifierByName("modifier_borrowed_time")

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

-- Returns if this unit is a player-owned summon or not
function IsPlayerOwnedSummon( unit )

	local summon_names = {
		"npc_dota_techies_mines",
		"npc_dota_venomancer_plagueward"
	}

	local unit_name = unit:GetName()

	for i = 1, #summon_names do
		if unit_name == summon_names[i] then
			return true
		end
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

-- Picks a legal non-ultimate ability in Random OMG mode
function GetRandomNormalAbility()

	local ability = RandomFromTable(RANDOM_OMG_ABILITIES)
	
	return ability.ability_name, ability.owner_hero
end

-- Picks a legal ultimate ability in Random OMG mode
function GetRandomUltimateAbility()

	local ability = RandomFromTable(RANDOM_OMG_ULTIMATES)

	return ability.ability_name, ability.owner_hero
end

-- Picks a random tower ability of level in the interval [level - 1, level]
function GetRandomTowerAbility( level )

	local ability = RandomFromTable(TOWER_ABILITIES)

	if level == 4 then
		while ability.level < 2 do
			ability = RandomFromTable(TOWER_ABILITIES)
		end
	else
		while ability.level > level or ability.level < ( level - 1) do
			ability = RandomFromTable(TOWER_ABILITIES)
		end
	end

	return ability.ability_name
end

-- Returns the upgrade cost to a specific tower ability
function GetTowerAbilityUpgradeCost(ability_name, level)

	if level == 1 then
		return TOWER_ABILITIES[ability_name].cost1
	elseif level == 2 then
		return TOWER_ABILITIES[ability_name].cost2
	end
end

-- Grants a given hero an appropriate amount of Random OMG abilities
function ApplyAllRandomOmgAbilities( hero )

	-- If there's no valid hero, do nothing
	if not hero then
		return nil
	end

	-- Check if the high level power-up ability is present
	local ability_powerup = hero:FindAbilityByName("imba_unlimited_level_powerup")
	local powerup_stacks
	if ability_powerup then
		powerup_stacks = hero:GetModifierStackCount("modifier_imba_unlimited_level_powerup", hero)
		hero:RemoveModifierByName("modifier_imba_unlimited_level_powerup")
		ability_powerup = true
	end

	-- Check if the frantic mode ability is present
	local ability_frantic = hero:FindAbilityByName("imba_frantic_buff")

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
	if not PRECACHED_HERO_LIST then
		PRECACHED_HERO_LIST = {}
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
			for j = 1, #PRECACHED_HERO_LIST do
				if PRECACHED_HERO_LIST[j] == ability_owner then
					is_precached = true
				end
			end

			-- If not, do so and add it to the precached heroes list
			if not is_precached then
				PrecacheUnitWithQueue(ability_owner)
				table.insert(PRECACHED_HERO_LIST, ability_owner)
			end

			-- Store it for later reference
			hero.random_omg_abilities[i] = randomed_ability
			i = i + 1
		end
	end

	-- Add new ultimate abilities
	while i <= ( IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT + IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT ) do

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
			for j = 1, #PRECACHED_HERO_LIST do
				if PRECACHED_HERO_LIST[j] == ultimate_owner then
					is_precached = true
				end
			end

			-- If not, do so and add it to the precached heroes list
			if not is_precached then
				PrecacheUnitByNameAsync(ultimate_owner, function(...) end)
				table.insert(PRECACHED_HERO_LIST, ultimate_owner)
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

	-- Apply frantic mode ability, if previously existing
	if ability_frantic then
		hero:AddAbility("imba_frantic_buff")
		ability_frantic = hero:FindAbilityByName("imba_frantic_buff")
		ability_frantic:SetLevel(1)
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
		"npc_dota_hero_dragon_knight",
		"npc_dota_hero_drow_ranger",
		"npc_dota_hero_earthshaker",
		"npc_dota_hero_jakiro",
		"npc_dota_hero_juggernaut",
		"npc_dota_hero_kunkka",
		"npc_dota_hero_lich",
		"npc_dota_hero_lina",
		"npc_dota_hero_lion",
		"npc_dota_hero_luna",
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
		"npc_dota_hero_puck",
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
		"npc_dota_hero_wisp",
		"npc_dota_hero_witch_doctor",
		"npc_dota_hero_zuus"
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
		"npc_dota_hero_dragon_knight",
		"npc_dota_hero_drow_ranger",
		"npc_dota_hero_earthshaker",
		"npc_dota_hero_jakiro",
		"npc_dota_hero_juggernaut",
		"npc_dota_hero_kunkka",
		"npc_dota_hero_lich",
		"npc_dota_hero_lina",
		"npc_dota_hero_lion",
		"npc_dota_hero_luna",
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
		"npc_dota_hero_puck",
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
		"npc_dota_hero_wisp",
		"npc_dota_hero_witch_doctor",
		"npc_dota_hero_zuus"
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
	hero:RemoveModifierByName("modifier_imba_shallow_grave")
	hero:RemoveModifierByName("modifier_imba_shallow_grave_passive")
	hero:RemoveModifierByName("modifier_imba_shallow_grave_passive_cooldown")
	hero:RemoveModifierByName("modifier_imba_shallow_grave_passive_check")
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
	hero:RemoveModifierByName("modifier_imba_hook_caster")
	hero:RemoveModifierByName("modifier_imba_god_strength")
	hero:RemoveModifierByName("modifier_imba_god_strength_aura")
	hero:RemoveModifierByName("modifier_imba_god_strength_aura_scepter")
	hero:RemoveModifierByName("modifier_imba_warcry_passive_aura")
	hero:RemoveModifierByName("modifier_imba_great_cleave")
	hero:RemoveModifierByName("modifier_imba_blur")
	hero:RemoveModifierByName("modifier_imba_flesh_heap_aura")
	hero:RemoveModifierByName("modifier_imba_flesh_heap_stacks")
	hero:RemoveModifierByName("modifier_medusa_split_shot")
	hero:RemoveModifierByName("modifier_luna_lunar_blessing")
	hero:RemoveModifierByName("modifier_luna_lunar_blessing_aura")
	hero:RemoveModifierByName("modifier_luna_moon_glaive")
	hero:RemoveModifierByName("modifier_dragon_knight_dragon")
	hero:RemoveModifierByName("modifier_dragon_knight_dragon_blood")
	hero:RemoveModifierByName("modifier_zuus_static_field")
	hero:RemoveModifierByName("modifier_witchdoctor_voodoorestoration")
	hero:RemoveModifierByName("modifier_imba_land_mines_caster")
	hero:RemoveModifierByName("modifier_riki_blinkstrike")
	hero:RemoveModifierByName("modifier_imba_purification_passive")
	hero:RemoveModifierByName("modifier_imba_purification_passive_cooldown")
	hero:RemoveModifierByName("modifier_imba_double_edge_prevent_deny")

	while hero:HasModifier("modifier_imba_flesh_heap_bonus") do
		hero:RemoveModifierByName("modifier_imba_flesh_heap_bonus")
	end
end

-- Precaches an unit, or, if something else is being precached, enters it into the precache queue
function PrecacheUnitWithQueue( unit_name )
	
	Timers:CreateTimer(0, function()

		-- If something else is being precached, wait two seconds
		if UNIT_BEING_PRECACHED then
			return 2

		-- Otherwise, start precaching and block other calls from doing so
		else
			UNIT_BEING_PRECACHED = true
			PrecacheUnitByNameAsync(unit_name, function(...) end)

			-- Release the queue after one second
			Timers:CreateTimer(1, function()
				UNIT_BEING_PRECACHED = false
			end)
		end
	end)
end

-- Simulates attack speed cap removal to a single unit through BAT manipulation
function RemoveAttackSpeedCap( unit )

	-- Fetch original BAT if necessary
	if not unit.as_cap_removal_original_bat then
		unit.as_cap_removal_original_bat = unit:GetBaseAttackTime()
	end

	-- Get current attack speed
	local current_as = unit:GetAttackSpeed() * 100

	-- Should we reduce BAT?
	if current_as > MAXIMUM_ATTACK_SPEED then
		local new_bat = MAXIMUM_ATTACK_SPEED / current_as * unit.as_cap_removal_original_bat
		unit:SetBaseAttackTime(new_bat)
	end
end

-- Returns a unit's attack speed cap
function ReturnAttackSpeedCap( unit )

	-- Return to original BAT
	unit:SetBaseAttackTime(unit.as_cap_removal_original_bat)

	-- Clean-up
	unit.as_cap_removal_original_bat = nil
end

-- Initializes heroes' innate abilities
function InitializeInnateAbilities( hero )

	-- List of innate abilities
	local innate_abilities = {
		"imba_faceless_void_timelord",
		"imba_queenofpain_delightful_torment",
		"imba_techies_minefield_sign",
		"imba_vengeful_rancor",
		"imba_venomancer_toxicity"
	}

	-- Cycle through any innate abilities found, then upgrade them
	for i = 1, #innate_abilities do
		local current_ability = hero:FindAbilityByName(innate_abilities[i])
		if current_ability then
			current_ability:SetLevel(1)
		end
	end
end
			
-- Break (remove passive skills from) a target
function PassiveBreak( unit, duration )

	-- Check if the target already has break status
	if unit.break_duration_left then
		
		-- Increase remaining break duration if appropriate
		if duration > unit.break_duration_left then
			unit.break_duration_left = duration
		end

		-- Break and do nothing more
		return nil
	end

	-- Initialize break globals
	unit.break_duration_left = duration
	unit.break_learn_levels = {}

	local passive_detected = false

	-- AM exceptions
	unit:RemoveModifierByName("modifier_imba_antimage_spell_shield_passive")
	unit:RemoveModifierByName("modifier_imba_antimage_spell_shield_active")

	-- Non-passive abilities disabled by break
	local break_exceptions = {
		"imba_antimage_spell_shield",
		"imba_faceless_void_backtrack"
	}

	-- Set all passive abilities' levels to zero
	for i = 0, 15 do
		local ability = unit:GetAbilityByIndex(i)
		if ability and ability:GetLevel() > 0 then
			
			-- Check for regular passives
			if ability:IsPassive() then
				passive_detected = true
				unit.break_learn_levels[i] = ability:GetLevel()
				ability:SetLevel(0)
			end

			-- Check for exceptions (togglable/activable "passives")
			for _,ability_exception in pairs(break_exceptions) do
				if ability_exception == ability:GetName() then
					passive_detected = true
					unit.break_learn_levels[i] = ability:GetLevel()
					ability:SetLevel(0)
				end
			end
		end
	end

	-- If at least one passive was broken, count down the duration
	if passive_detected then
		Timers:CreateTimer(0.1, function()

			-- Update duration left
			unit.break_duration_left = unit.break_duration_left - 0.1

			-- Restore ability levels if duration has elapsed
			if unit.break_duration_left <= 0 then
				if not ( not unit:IsAlive() and IMBA_ABILITY_MODE_RANDOM_OMG ) then
					for i = 0, 15 do
						if unit.break_learn_levels[i] and unit.break_learn_levels[i] > 0 then
							local ability = unit:GetAbilityByIndex(i)
							local excess_levels = ability:GetLevel()
							unit:SetAbilityPoints( unit:GetAbilityPoints() + excess_levels )
							ability:SetLevel(unit.break_learn_levels[i])
						end
					end
				end
				unit.break_duration_left = nil
				unit.break_learn_levels = nil
			else
				return 0.1
			end
		end)
	end
end

-- End an ongoing Break condition
function PassiveBreakEnd( unit )
	unit.break_duration_left = 0
end

-- Check if an ability should proc magic stick/wand
function StickProcCheck( ability )

	local ability_name = ability:GetName()

	local forbidden_skills = {
		"storm_spirit_ball_lightning",
		"witch_doctor_voodoo_restoration",
		"imba_necrolyte_death_pulse"
	}

	for i = 1, #forbidden_skills do
		if ability_name == forbidden_skills[i] then
			return false
		end
	end

	return true
end

-- Upgrades a tower's abilities
function UpgradeTower( tower )

	local abilities = {}

	-- Fetch tower abilities
	for i = 0, 15 do
		local current_ability = tower:GetAbilityByIndex(i)
		if current_ability and current_ability:GetName() ~= "backdoor_protection" and current_ability:GetName() ~= "backdoor_protection_in_base" then
			abilities[#abilities+1] = current_ability
		end
	end

	-- Iterate through abilities to identify the upgradable one
	for i = 1,3 do

		-- If this ability is not maxed, try to upgrade it
		if abilities[i] and abilities[i]:GetLevel() < 3 then

			-- Upgrade ability
			abilities[i]:SetLevel( abilities[i]:GetLevel() + 1 )

			-- Increase tower size
			tower:SetModelScale(tower:GetModelScale() + 0.03)

			return nil

		-- If this ability is maxed and the last one, then add a new one
		elseif abilities[i] and abilities[i]:GetLevel() == 3 and #abilities == i then

			-- Add a random new ability
			local duplicate_ability
			local new_ability

			-- Prevent duplicates
			repeat
				duplicate_ability = false
				new_ability = GetRandomTowerAbility(tower.tower_tier)
				for _,test_ability in pairs(abilities) do
					if test_ability:GetName() == new_ability then
						duplicate_ability = true
					end
				end
			until not duplicate_ability

			-- Level up the ability
			tower:AddAbility(new_ability)
			new_ability = tower:FindAbilityByName(new_ability)
			new_ability:SetLevel(1)

			-- Increase tower size
			tower:SetModelScale(tower:GetModelScale() + 0.08)
			return nil
		end
	end
end

-- Sets a creature's max health to [health]
function SetCreatureHealth(unit, health, update_current_health)

	unit:SetBaseMaxHealth(health)
	unit:SetMaxHealth(health)

	if update_current_health then
		unit:SetHealth(health)
	end
end