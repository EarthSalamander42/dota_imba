function DebugPrint(...)
	--local spew = Convars:GetInt('barebones_spew') or -1
	--if spew == -1 and BAREBONES_DEBUG_SPEW then
	--spew = 1
	--end

	--if spew == 1 then
	--print(...)
	--end
end

function DebugPrintTable(...)
	--local spew = Convars:GetInt('barebones_spew') or -1
	--if spew == -1 and BAREBONES_DEBUG_SPEW then
	--spew = 1
	--end

	--if spew == 1 then
	--PrintTable(...)
	--end
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
	if hero:HasModifier("modifier_item_ultimate_scepter_consumed") or hero:HasModifier("modifier_item_imba_ultimate_scepter_synth") then
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
		unit:SetModifierStackCount(modifier, ability, unit:GetModifierStackCount(modifier, nil) + stack_amount)
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

-- Checks if a given unit is a ward, or Techies bomb
function IsWardOrBomb(unit)

	local unit_name = unit:GetUnitName()
	local valid_unit_names = {
		"npc_dota_observer_wards",
		"npc_dota_sentry_wards",
		"npc_imba_techies_land_mine",
		"npc_imba_techies_stasis_trap",
		"npc_dota_techies_remote_mine"
	}

	for _,name in pairs(valid_unit_names) do
		if unit_name == name then
			return true
		end
	end

	return false
end

-- 100% kills a unit. Activates death-preventing modifiers, then removes them. Does not killsteal from Reaper's Scythe.
function TrueKill(caster, target, ability)
	
	-- Shallow Grave is peskier
	target:RemoveModifierByName("modifier_imba_shallow_grave")

	-- Extremely specific blademail interaction because fuck everything
	if caster:HasModifier("modifier_item_blade_mail_reflect") then
		target:RemoveModifierByName("modifier_imba_purification_passive")
	end

	-- Deals lethal damage in order to trigger death-preventing abilities... Except for Reincarnation
	if not ( target:HasModifier("modifier_imba_reincarnation") or target:HasModifier("modifier_imba_reincarnation_scepter") ) then
		target:Kill(ability, caster)
	end

	-- Removes the relevant modifiers
	target:RemoveModifierByName("modifier_invulnerable")
	target:RemoveModifierByName("modifier_imba_shallow_grave")
	target:RemoveModifierByName("modifier_aphotic_shield")
	target:RemoveModifierByName("modifier_imba_spiked_carapace")
	target:RemoveModifierByName("modifier_borrowed_time")
	target:RemoveModifierByName("modifier_imba_centaur_return")
	target:RemoveModifierByName("modifier_item_greatwyrm_plate_unique")
	target:RemoveModifierByName("modifier_item_greatwyrm_plate_active")
	target:RemoveModifierByName("modifier_item_crimson_guard_unique")
	target:RemoveModifierByName("modifier_item_crimson_guard_active")
	target:RemoveModifierByName("modifier_item_greatwyrm_plate_unique")
	target:RemoveModifierByName("modifier_item_vanguard_unique")
	target:RemoveModifierByName("modifier_item_imba_initiate_robe_stacks")
	target:RemoveModifierByName("modifier_imba_cheese_death_prevention")
	target:RemoveModifierByName("modifier_item_imba_rapier_cursed_unique")

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

	local summon_classes = {
		"npc_dota_techies_mines",
		"npc_dota_venomancer_plagueward",
		"npc_dota_lone_druid_bear"
	}

	local unit_name = unit:GetName()

	for i = 1, #summon_classes do
		if unit_name == summon_classes[i] then
			return true
		end
	end

	local summon_names = {
		"npc_imba_warlock_golem_extra"
	}

	unit_name = unit:GetUnitName()

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
function GetRandomTowerAbility(tier, type)

	local ability

	if tier == 1 then
		if type == "active" then
			ability = RandomFromTable(TOWER_ABILITIES.tier_one.active)
		elseif type == "aura" then
			ability = RandomFromTable(TOWER_ABILITIES.tier_one.aura)
		elseif type == "attack" then
			ability = RandomFromTable(TOWER_ABILITIES.tier_one.attack)
		end
	elseif tier == 2 then
		if type == "active" then
			ability = RandomFromTable(TOWER_ABILITIES.tier_two.active)
		elseif type == "aura" then
			ability = RandomFromTable(TOWER_ABILITIES.tier_two.aura)
		elseif type == "attack" then
			ability = RandomFromTable(TOWER_ABILITIES.tier_two.attack)
		end
	elseif tier == 3 then
		if type == "active" then
			ability = RandomFromTable(TOWER_ABILITIES.tier_three.active)
		elseif type == "aura" then
			ability = RandomFromTable(TOWER_ABILITIES.tier_three.aura)
		elseif type == "attack" then
			ability = RandomFromTable(TOWER_ABILITIES.tier_three.attack)
		end
	elseif tier == 4 then
		if type == "active" then
			ability = RandomFromTable(TOWER_ABILITIES.tier_four.active)
		elseif type == "aura" then
			ability = RandomFromTable(TOWER_ABILITIES.tier_four.aura)
		elseif type == "attack" then
			ability = RandomFromTable(TOWER_ABILITIES.tier_four.attack)
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
	hero:RemoveModifierByName("modifier_imba_purification_passive")
	hero:RemoveModifierByName("modifier_imba_purification_passive_cooldown")
	hero:RemoveModifierByName("modifier_imba_double_edge_prevent_deny")
	hero:RemoveModifierByName("modifier_imba_vampiric_aura")
	hero:RemoveModifierByName("modifier_imba_reincarnation_detector")
	hero:RemoveModifierByName("modifier_imba_time_walk_damage_counter")
	hero:RemoveModifierByName("modifier_charges")
	hero:RemoveModifierByName("modifier_imba_reincarnation")

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
			Timers:CreateTimer(2, function()
				UNIT_BEING_PRECACHED = false
			end)
		end
	end)
end

-- Simulates attack speed cap removal to a single unit through BAT manipulation
function IncreaseAttackSpeedCap(unit, new_cap)

	-- Fetch original BAT if necessary
	if not unit.current_modified_bat then
		unit.current_modified_bat = unit:GetBaseAttackTime()
	end

	-- Get current attack speed, limited to new_cap
	local current_as = math.min(unit:GetAttackSpeed() * 100, new_cap)

	-- Should we reduce BAT?
	if current_as > MAXIMUM_ATTACK_SPEED then
		local new_bat = MAXIMUM_ATTACK_SPEED / current_as * unit.current_modified_bat
		unit:SetBaseAttackTime(new_bat)
	end
end

-- Returns a unit's attack speed cap
function RevertAttackSpeedCap( unit )

	-- Return to original BAT
	unit:SetBaseAttackTime(unit.current_modified_bat)

end

-- Initializes heroes' innate abilities
function InitializeInnateAbilities( hero )

	-- List of innate abilities
	local innate_abilities = {
		"imba_faceless_void_timelord",
		"imba_queenofpain_delightful_torment",
		"imba_techies_minefield_sign",
		"imba_vengeful_rancor",
		"vengefulspirit_nether_swap",
		"imba_venomancer_toxicity",
		"imba_magnus_magnetize",
		"imba_enigma_gravity",
		"imba_troll_warlord_berserkers_rage",
		"imba_antimage_magehunter",
		"imba_necrolyte_death_pulse_aux",
		"imba_sandking_treacherous_sands",
		"imba_bane_nightmare_end",
		"imba_rubick_telekinesis_land"
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

	-- Exceptions
	unit:RemoveModifierByName("modifier_imba_antimage_spell_shield_passive")
	unit:RemoveModifierByName("modifier_imba_antimage_spell_shield_active")
	while unit:HasModifier("modifier_imba_fervor_stacks") do
		unit:RemoveModifierByName("modifier_imba_fervor_stacks")
	end

	-- Non-passive abilities disabled by break
	local break_exceptions = {
		"imba_antimage_spell_shield"
	}

	-- Passive abilities not disabled by break
	local break_immunities = {
		"imba_wraith_king_reincarnation",
		"imba_drow_ranger_marksmanship"
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

			-- Check for immunities (passives which are not disabled by Break)
			for _,ability_immunity in pairs(break_immunities) do
				if ability_immunity == ability:GetName() then
					ability:SetLevel(unit.break_learn_levels[i])
					unit.break_learn_levels[i] = 0
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
		"imba_necrolyte_death_pulse",
		"shredder_chakram",
		"shredder_chakram_2"
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
		if current_ability and current_ability:GetName() ~= "backdoor_protection" and current_ability:GetName() ~= "backdoor_protection_in_base" and current_ability:GetName() ~= "imba_tower_buffs" then
			abilities[#abilities+1] = current_ability
		end
	end

	-- Iterate through abilities to identify the upgradable one
	for i = 1,4 do

		-- If this ability is not maxed, try to upgrade it
		if abilities[i] and abilities[i]:GetLevel() < 3 then

			-- Upgrade ability
			abilities[i]:SetLevel( abilities[i]:GetLevel() + 1 )

			return nil

		-- If this ability is maxed and the last one, then add a new one
		elseif abilities[i] and abilities[i]:GetLevel() == 3 and #abilities == i then

			-- If there are no more abilities on the tree for this tower, do nothing
			if (tower.tower_tier <= 3 and i >= 3) or i >= 4 then
				return nil
			end

			-- Else, add a new ability from this game's ability tree
			local new_ability = false
			if tower.tower_tier == 1 then
				if tower.tower_lane == "safelane" then
					new_ability = TOWER_UPGRADE_TREE["safelane"]["tier_1"][i+1]
				elseif tower.tower_lane == "midlane" then
					new_ability = TOWER_UPGRADE_TREE["midlane"]["tier_1"][i+1]
				elseif tower.tower_lane == "hardlane" then
					new_ability = TOWER_UPGRADE_TREE["hardlane"]["tier_1"][i+1]
				end
			elseif tower.tower_tier == 2 then
				if tower.tower_lane == "safelane" then
					new_ability = TOWER_UPGRADE_TREE["safelane"]["tier_2"][i+1]
				elseif tower.tower_lane == "midlane" then
					new_ability = TOWER_UPGRADE_TREE["midlane"]["tier_2"][i+1]
				elseif tower.tower_lane == "hardlane" then
					new_ability = TOWER_UPGRADE_TREE["hardlane"]["tier_2"][i+1]
				end
			elseif tower.tower_tier == 3 then
				if tower.tower_lane == "safelane" then
					new_ability = TOWER_UPGRADE_TREE["safelane"]["tier_3"][i+1]
				elseif tower.tower_lane == "midlane" then
					new_ability = TOWER_UPGRADE_TREE["midlane"]["tier_3"][i+1]
				elseif tower.tower_lane == "hardlane" then
					new_ability = TOWER_UPGRADE_TREE["hardlane"]["tier_3"][i+1]
				end
			elseif tower.tower_tier == 41 then
				new_ability = TOWER_UPGRADE_TREE["midlane"]["tier_41"][i+1]
			elseif tower.tower_tier == 42 then
				new_ability = TOWER_UPGRADE_TREE["midlane"]["tier_42"][i+1]
			end

			-- Add the new ability
			if new_ability then
				tower:AddAbility(new_ability)
				new_ability = tower:FindAbilityByName(new_ability)
				new_ability:SetLevel(1)
			end

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

function RemoveWearables( hero )

	-- Setup variables
	Timers:CreateTimer(0.1, function()
		hero.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
		local model = hero:FirstMoveChild()
		while model ~= nil do
			if model:GetClassname() == "dota_item_wearable" then
				model:AddEffects(EF_NODRAW) -- Set model hidden
				table.insert(hero.hiddenWearables, model)
			end
			model = model:NextMovePeer()
		end
	end)
end

function ShowWearables( event )
  local hero = event.caster

  for i,v in pairs(hero.hiddenWearables) do
    v:RemoveEffects(EF_NODRAW)
  end
end

-- Skeleton king cosmetics
function SkeletonKingWearables( hero )

	-- Cape
	Attachments:AttachProp(hero, "attach_head", "models/heroes/skeleton_king/wraith_king_cape.vmdl", 1.0)

	-- Shoulderpiece
	Attachments:AttachProp(hero, "attach_head", "models/heroes/skeleton_king/wraith_king_shoulder.vmdl", 1.0)

	-- Crown
	Attachments:AttachProp(hero, "attach_head", "models/heroes/skeleton_king/wraith_king_head.vmdl", 1.0)

	-- Gauntlet
	Attachments:AttachProp(hero, "attach_attack1", "models/heroes/skeleton_king/wraith_king_gauntlet.vmdl", 1.0)

	-- Weapon (randomly chosen)
	local random_weapon = {
		"models/items/skeleton_king/spine_splitter/spine_splitter.vmdl",
		"models/items/skeleton_king/regalia_of_the_bonelord_sword/regalia_of_the_bonelord_sword.vmdl",
		"models/items/skeleton_king/weapon_backbone.vmdl",
		"models/items/skeleton_king/the_blood_shard/the_blood_shard.vmdl",
		"models/items/skeleton_king/sk_dragon_jaw/sk_dragon_jaw.vmdl",
		"models/items/skeleton_king/weapon_spine_sword.vmdl",
		"models/items/skeleton_king/shattered_destroyer/shattered_destroyer.vmdl"
	}
	Attachments:AttachProp(hero, "attach_attack1", random_weapon[RandomInt(1, #random_weapon)], 1.0)

	-- Eye particles
	local eye_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/skeletonking_eyes.vpcf", PATTACH_ABSORIGIN, hero)
	ParticleManager:SetParticleControlEnt(eye_pfx, 0, hero, PATTACH_POINT_FOLLOW, "attach_eyeL", hero:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(eye_pfx, 1, hero, PATTACH_POINT_FOLLOW, "attach_eyeR", hero:GetAbsOrigin(), true)
end

-- Returns the total cooldown reduction on a given unit
function GetCooldownReduction( unit )

	local reduction = 1.0

	-- Octarine Core
	if unit:HasModifier("modifier_item_imba_octarine_core_unique") then
		reduction = reduction * 0.75
	end

	return reduction
end

-- Returns true if this is a ward-type unit (nether ward, scourge ward, etc.)
function IsWardTypeUnit( unit )

	local ward_type_units = {
		"npc_imba_pugna_nether_ward_1",
		"npc_imba_pugna_nether_ward_2",
		"npc_imba_pugna_nether_ward_3",
		"npc_imba_pugna_nether_ward_4"
	}

	for _, ward_unit in pairs(ward_type_units) do
		if unit:GetUnitName() == ward_unit then
			return true
		end
	end

	return false
end

-- Randoms an ability of a certain tier for the Ancient
function GetAncientAbility( tier )

	-- Tier 1 abilities
	if tier == 1 then
		local ability_list = {
			"venomancer_poison_nova"
		}

		return ability_list[RandomInt(1, #ability_list)]

	-- Tier 2 abilities
	elseif tier == 2 then
		local ability_list = {
			"abaddon_borrowed_time",
			"nyx_assassin_spiked_carapace",
			"axe_berserkers_call"
		}

		return ability_list[RandomInt(1, #ability_list)]

	-- Tier 3 abilities
	elseif tier == 3 then
		local ability_list = {
			"treant_overgrowth",
			"tidehunter_ravage",
			"magnataur_reverse_polarity"
		}

		return ability_list[RandomInt(1, #ability_list)]
	end
	
	return nil
end

function GetBaseRangedProjectileName( unit )
	local unit_name = unit:GetUnitName()
	unit_name = string.gsub(unit_name, "dota", "imba")
	local unit_table = unit:IsHero() and GameRules.HeroKV[unit_name] or GameRules.UnitKV[unit_name]
	return unit_table and unit_table["ProjectileModel"] or ""
end

function ChangeAttackProjectileImba( unit )

	local particle_deso = "particles/items_fx/desolator_projectile.vpcf"
	local particle_skadi = "particles/items2_fx/skadi_projectile.vpcf"
	local particle_deso_skadi = "particles/item/desolator/desolator_skadi_projectile_2.vpcf"
	local particle_clinkz_arrows = "particles/units/heroes/hero_clinkz/clinkz_searing_arrow.vpcf"
	local particle_dragon_form_green = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_corrosive.vpcf"
	local particle_dragon_form_red = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf"
	local particle_dragon_form_blue = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf"
	local particle_terrorblade_transform = "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf"

	-- If the unit has a Desolator and a Skadi, use the special projectile
	if unit:HasModifier("modifier_item_imba_desolator_unique") or unit:HasModifier("modifier_item_imba_desolator_2_unique") then
		if unit:HasModifier("modifier_item_imba_skadi_unique") then
			unit:SetRangedProjectileName(particle_deso_skadi)

		-- If only a Desolator, use its attack projectile instead
		else
			unit:SetRangedProjectileName(particle_deso)
		end

	-- If only a Skadi, use its attack projectile instead
	elseif unit:HasModifier("modifier_item_imba_skadi_unique") then
		unit:SetRangedProjectileName(particle_skadi)

	-- If it's a Clinkz with Searing Arrows, use its attack projectile instead
	elseif unit:HasModifier("modifier_imba_searing_arrows_caster") then
		unit:SetRangedProjectileName(particle_clinkz_arrows)

	-- If it's one of Dragon Knight's forms, use its attack projectile instead
	elseif unit:HasModifier("modifier_dragon_knight_corrosive_breath") then
		unit:SetRangedProjectileName(particle_dragon_form_green)
	elseif unit:HasModifier("modifier_dragon_knight_splash_attack") then
		unit:SetRangedProjectileName(particle_dragon_form_red)
	elseif unit:HasModifier("modifier_dragon_knight_frost_breath") then
		unit:SetRangedProjectileName(particle_dragon_form_blue)

	-- If it's a metamorphosed Terrorblade, use its attack projectile instead
	elseif unit:HasModifier("modifier_terrorblade_metamorphosis") then
		unit:SetRangedProjectileName(particle_terrorblade_transform)

	-- Else, default to the base ranged projectile
	else
		unit:SetRangedProjectileName(GetBaseRangedProjectileName(unit))
	end
end

function IsUninterruptableForcedMovement( unit )
	
	-- List of uninterruptable movement modifiers
	local modifier_list = {
		"modifier_spirit_breaker_charge_of_darkness",
		"modifier_magnataur_skewer_movement",
		"modifier_invoker_deafening_blast_knockback",
		"modifier_knockback",
		"modifier_item_forcestaff_active",
		"modifier_shredder_timber_chain",
		"modifier_batrider_flaming_lasso",
		"modifier_imba_leap_self_root",
		"modifier_faceless_void_chronosphere_freeze",
		"modifier_storm_spirit_ball_lightning",
		"modifier_morphling_waveform"
	}

	-- Iterate through the list
	for _,modifier_name in pairs(modifier_list) do
		if unit:HasModifier(modifier_name) then
			return true
		end
	end

	return false
end

-- Returns an unit's existing increased cast range modifiers
function GetCastRangeIncrease( unit )
	local cast_range_increase = 0
	
	-- From items
	if unit:HasModifier("modifier_item_imba_elder_staff_range") then
		cast_range_increase = cast_range_increase + 300
	elseif unit:HasModifier("modifier_item_imba_aether_lens_range") then
		cast_range_increase = cast_range_increase + 225
	end

	-- From talents
	for talent_name,cast_range_bonus in pairs(CAST_RANGE_TALENTS) do
		if unit:FindAbilityByName(talent_name) and unit:FindAbilityByName(talent_name):GetLevel() > 0 then
			cast_range_increase = cast_range_increase + cast_range_bonus
		end
	end

	return cast_range_increase
end

-- Safely modify BAT while storing the unit's original value
function ModifyBAT(unit, modify_percent, modify_flat)

	-- Fetch base BAT if necessary
	if not unit.unmodified_bat then
		unit.unmodified_bat = unit:GetBaseAttackTime()
	end

	-- Create the current BAT variable if necessary
	if not unit.current_modified_bat then
		unit.current_modified_bat = unit.unmodified_bat
	end

	-- Create the percent modifier variable if necessary
	if not unit.percent_bat_modifier then
		unit.percent_bat_modifier = 1
	end

	-- Create the flat modifier variable if necessary
	if not unit.flat_bat_modifier then
		unit.flat_bat_modifier = 0
	end

	-- Update BAT percent modifiers
	unit.percent_bat_modifier = unit.percent_bat_modifier * (100 + modify_percent) / 100

	-- Update BAT flat modifiers
	unit.flat_bat_modifier = unit.flat_bat_modifier + modify_flat

	-- Unmodified BAT special exceptions
	if unit:GetUnitName() == "npc_dota_hero_alchemist" then
		return nil
	end
	
	-- Update modifier BAT
	unit.current_modified_bat = (unit.unmodified_bat + unit.flat_bat_modifier) * unit.percent_bat_modifier

	-- Update unit's BAT
	unit:SetBaseAttackTime(unit.current_modified_bat)

end

-- Override all BAT modifiers and return the unit to its base value
function RevertBAT( unit )

	-- Fetch base BAT if necessary
	if not unit.unmodified_bat then
		unit.unmodified_bat = unit:GetBaseAttackTime()
	end

	-- Create the current BAT variable if necessary
	if not unit.current_modified_bat then
		unit.current_modified_bat = unit.unmodified_bat
	end

	-- Create the percent modifier variable if necessary
	if not unit.percent_bat_modifier then
		unit.percent_bat_modifier = 1
	end

	-- Create the flat modifier variable if necessary
	if not unit.flat_bat_modifier then
		unit.flat_bat_modifier = 0
	end

	-- Reset variables
	unit.percent_bat_modifier = 1
	unit.flat_bat_modifier = 0

	-- Reset BAT
	unit:SetBaseAttackTime(unit.unmodified_bat)

end

-- Detect hero-creeps with an inventory, like warlock golems or lone druid's bear
function IsHeroCreep( unit )

	if unit:GetName() == "npc_dota_lone_druid_bear" then
		return true
	end

	return false
end

-- Changes the time of the day temporarily, memorizing the original time of the day to return to
function SetTimeOfDayTemp(time, duration)

	-- Store the original time of the day, if necessary
	local game_entity = GameRules:GetGameModeEntity()
	if not game_entity.tod_original_time then
		game_entity.tod_original_time = GameRules:GetTimeOfDay()
	end

	-- Initialize the time modification states, if necessary
	if not game_entity.tod_future_seconds then
		game_entity.tod_future_seconds = {}

		-- Start loop function
		Timers:CreateTimer(1, function()
			SetTimeOfDayTempLoop()
		end)
	end

	-- Store future time modification states
	for i = 1, duration do
		game_entity.tod_future_seconds[i] = time
	end

	-- Set the time of the day
	GameRules:SetTimeOfDay(time)
end

-- Auxiliary function to the one above
function SetTimeOfDayTempLoop()

	-- If there are no future time modification states, stop looping
	local game_entity = GameRules:GetGameModeEntity()
	if not game_entity.tod_future_seconds then
		return nil

	-- Else, move states one second forward
	elseif #game_entity.tod_future_seconds > 1 then
		for i = 1, (#game_entity.tod_future_seconds - 1) do
			game_entity.tod_future_seconds[i] = game_entity.tod_future_seconds[i + 1]
		end
		game_entity.tod_future_seconds[#game_entity.tod_future_seconds] = nil

		-- Keep the loop going
		GameRules:SetTimeOfDay(game_entity.tod_future_seconds[1])
		Timers:CreateTimer(1, function()
			SetTimeOfDayTempLoop()
		end)

	-- Else, the duration is over; restore the original time of the day, and exit the loop
	else
		game_entity.tod_future_seconds = nil
		Timers:CreateTimer(1, function()
			GameRules:SetTimeOfDay(game_entity.tod_original_time)
			game_entity.tod_original_time = nil
		end)
	end
end

-- Initializes a charge-based system for an ability
function InitializeAbilityCharges(unit, ability_name, max_charges, initial_charges, cooldown, modifier_name)

	-- Find the passed ability
	local ability = unit:FindAbilityByName(ability_name)

	-- Procees only if the relevant ability was found
	if ability then

		local extra_parameters = {
			max_count = max_charges,
			start_count = initial_charges,
			replenish_time = cooldown
		}

		unit:AddNewModifier(unit, ability, "modifier_charges_"..modifier_name, extra_parameters)
	end
end

-- Initialize Physics library on this target
function InitializePhysicsParameters(unit)

	if not IsPhysicsUnit(unit) then
		Physics:Unit(unit)
		unit:SetPhysicsVelocityMax(600)
		unit:PreventDI()
	end
end

-- Check if an unit is near the enemy fountain
function IsNearEnemyFountain(location, team, distance)

	local fountain_loc
	if team == DOTA_TEAM_GOODGUYS then
		fountain_loc = Vector(7472, 6912, 512)
	else
		fountain_loc = Vector(-7456, -6938, 528)
	end

	if (fountain_loc - location):Length2D() <= distance then
		return true
	end

	return false
end

-- Reaper's Scythe kill credit redirection
function TriggerNecrolyteReaperScytheDeath(target, caster)

	-- Find the Reaper's Scythe ability
	local ability = caster:FindAbilityByName("imba_necrolyte_reapers_scythe")
	if not ability then return nil end

	-- Attempt to kill the target
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = target:GetHealth(), damage_type = DAMAGE_TYPE_PURE})
end

-- Reincarnation death trigger
function TriggerWraithKingReincarnation(caster, ability)

	-- Keyvalues
	local ability_level = ability:GetLevel() - 1
	local modifier_death = "modifier_imba_reincarnation_death"
	local modifier_slow = "modifier_imba_reincarnation_slow"
	local modifier_kingdom_ms = "modifier_imba_reincarnation_kingdom_ms"
	local particle_wait = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
	local particle_kingdom = "particles/hero/skeleton_king/wraith_king_hellfire_eruption_tell.vpcf"
	local sound_death = "Hero_SkeletonKing.Reincarnate"
	local sound_reincarnation = "Hero_SkeletonKing.Reincarnate.Stinger"
	local sound_kingdom_start = "Hero_WraithKing.EruptionCast"

	-- Parameters
	local slow_radius = ability:GetLevelSpecialValueFor("slow_radius", ability_level)
	local reincarnate_delay = ability:GetLevelSpecialValueFor("reincarnate_delay", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)
	local damage = ability:GetLevelSpecialValueFor("kingdom_damage", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("kingdom_stun", ability_level)
	local caster_loc = caster:GetAbsOrigin()

	-- Put the ability on cooldown and play out the reincarnation
	local cooldown_reduction = GetCooldownReduction(caster)
	ability:StartCooldown(ability:GetCooldown(ability_level) * cooldown_reduction)

	-- Play initial sound
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, slow_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
	if USE_MEME_SOUNDS and #heroes >= IMBA_PLAYERS_ON_GAME * 0.35 then
		caster:EmitSound("Hero_WraithKing.IllBeBack")
	else
		caster:EmitSound(sound_death)
	end

	-- Create visibility node
	ability:CreateVisibilityNode(caster_loc, vision_radius, reincarnate_delay)

	-- Apply simulated death modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_death, {})

	-- Remove caster's model from the game
	caster:AddNoDraw()

	-- Play initial particle
	local wait_pfx = ParticleManager:CreateParticle(particle_wait, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleAlwaysSimulate(wait_pfx)
	ParticleManager:SetParticleControl(wait_pfx, 0, caster_loc)
	ParticleManager:SetParticleControl(wait_pfx, 1, Vector(reincarnate_delay, 0, 0))
	ParticleManager:SetParticleControl(wait_pfx, 11, Vector(200, 0, 0))
	ParticleManager:ReleaseParticleIndex(wait_pfx)

	-- Slow all nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, slow_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})
	end

	-- Heal, even through healing prevention debuffs
	caster:SetHealth(caster:GetMaxHealth())
	caster:SetMana(caster:GetMaxMana())

	-- Play Kingdom Come particle
	local kingdom_pfx = ParticleManager:CreateParticle(particle_kingdom, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleAlwaysSimulate(kingdom_pfx)
	ParticleManager:SetParticleControl(kingdom_pfx, 0, caster_loc)

	-- Play Kingdom Come sound
	Timers:CreateTimer(0.9, function()
		caster:EmitSound(sound_kingdom_start)
	end)

	-- After the respawn delay
	Timers:CreateTimer(reincarnate_delay, function()

		-- Purge most debuffs
		caster:Purge(false, true, false, true, true)

		-- Heal, even through healing prevention debuffs
		caster:SetHealth(caster:GetMaxHealth())
		caster:SetMana(caster:GetMaxMana())

		-- Redraw caster's model
		caster:RemoveNoDraw()

		-- Play reincarnation stinger
		caster:EmitSound(sound_reincarnation)

		-- Stop Kingdom Come particles
		ParticleManager:DestroyParticle(kingdom_pfx, false)
		ParticleManager:ReleaseParticleIndex(kingdom_pfx)

		-- Iterate through nearby enemies
		enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, slow_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			
			-- If this is a real hero, damage and stun it
			if enemy:IsRealHero() or IsRoshan(enemy) then
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
				enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})

				-- Increase caster's movement speed temporarily
				AddStacks(ability, caster, caster, modifier_kingdom_ms, 1, true)
			
			-- Else, kill it
			else
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = enemy:GetMaxHealth(), damage_type = DAMAGE_TYPE_PURE})
			end
		end
	end)
end

-- Reincarnation Wraith Form trigger
function TriggerWraithKingWraithForm(target, attacker)

	-- Keyvalues
	local reincarnation_modifier = target:FindModifierByName("modifier_imba_reincarnation_scepter")
	local caster = reincarnation_modifier:GetCaster()
	local ability = reincarnation_modifier:GetAbility()
	local modifier_scepter = "modifier_imba_reincarnation_scepter"
	local modifier_wraith = "modifier_imba_reincarnation_scepter_wraith"
	local sound_wraith = "Hero_SkeletonKing.Reincarnate.Ghost"

	-- Store the attacker which killed this unit's ID
	local killer_id
	local killer_type = "hero"
	if attacker:GetOwnerEntity() then
		killer_id = attacker:GetOwnerEntity():GetPlayerID()
	elseif attacker:IsHero() then
		killer_id = attacker:GetPlayerID()
	else
		killer_id = attacker
		killer_type = "creature"
	end

	-- If there is a player-owned killer, store it
	if killer_type == "hero" then
		target.reincarnation_scepter_killer = PlayerResource:GetPlayer(killer_id):GetAssignedHero()

	-- Else, assign the kill to the unit which dealt the finishing blow
	else
		target.reincarnation_scepter_killer = attacker
	end

	-- Play transformation sound
	target:EmitSound(sound_wraith)

	-- Apply wraith form modifier
	ability:ApplyDataDrivenModifier(caster, target, modifier_wraith, {})

	-- Remove the scepter aura modifier
	target:RemoveModifierByName(modifier_scepter)

	-- Purge all debuffs
	target:Purge(false, true, false, true, false)
end

-- Aegis Reincarnation trigger
function TriggerAegisReincarnation(caster)

	-- Keyvalues
	local aegis_modifier = caster:FindModifierByName("modifier_item_imba_aegis")
	local ability = aegis_modifier:GetAbility()
	local modifier_aegis = "modifier_item_imba_aegis"
	local modifier_death = "modifier_item_imba_aegis_death"
	local particle_wait = "particles/items_fx/aegis_timer.vpcf"
	local particle_respawn = "particles/items_fx/aegis_respawn_timer.vpcf"
	local sound_aegis = "Imba.AegisStinger"
	local caster_loc = caster:GetAbsOrigin()

	-- Parameters
	local respawn_delay = ability:GetSpecialValueFor("reincarnate_time")
	local vision_radius = ability:GetSpecialValueFor("vision_radius")

	-- Play sound
	caster:EmitSound(sound_aegis)

	-- Create visibility node
	ability:CreateVisibilityNode(caster_loc, vision_radius, respawn_delay)

	-- Apply simulated death modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_death, {})

	-- Remove caster's model from the game
	caster:AddNoDraw()

	-- Play initial particle
	local wait_pfx = ParticleManager:CreateParticle(particle_wait, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleAlwaysSimulate(wait_pfx)
	ParticleManager:SetParticleControl(wait_pfx, 0, caster_loc)
	ParticleManager:SetParticleControl(wait_pfx, 1, Vector(respawn_delay, 0, 0))
	ParticleManager:ReleaseParticleIndex(wait_pfx)

	-- After the respawn delay, play reincarnation particle
	local respawn_pfx = ParticleManager:CreateParticle(particle_respawn, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(respawn_pfx, 0, caster_loc)
	ParticleManager:SetParticleControl(respawn_pfx, 1, Vector(respawn_delay, 0, 0))
	ParticleManager:ReleaseParticleIndex(respawn_pfx)

	-- After the respawn delay
	Timers:CreateTimer(respawn_delay, function()

		-- Heal, even through healing prevention debuffs
		caster:SetHealth(caster:GetMaxHealth())
		caster:SetMana(caster:GetMaxMana())

		-- Purge all debuffs
		caster:Purge(false, true, false, true, true)

		-- Remove Aegis modifier
		caster:RemoveModifierByName(modifier_aegis)

		-- Destroy the Aegis
		caster:RemoveItem(ability)

		-- Flag caster as no longer having aegis
		caster.has_aegis = false

		-- Redraw caster's model
		caster:RemoveNoDraw()
	end)
end

-- Checks if this ability is casted by someone with Spell Steal (i.e. Rubick)
function IsStolenSpell(caster)

	-- If the caster has the Spell Steal ability, return true
	if caster:FindAbilityByName("rubick_spell_steal") then
		return true
	end

	return false
end

-- Sets level of the ability with [ability_name] to [level] for [caster] if the caster has this ability
function SetAbilityLevelIfPresent(caster, ability_name, level)
	local ability = caster:FindAbilityByName(ability_name)
	if ability then
		ability:SetLevel(level)
	end
end

-- Refreshes ability with [ability_name] for [caster] if the caster has this ability
function RefreshAbilityIfPresent(caster, ability_name)
	local ability = caster:FindAbilityByName(ability_name)
	if ability then
		ability:EndCooldown()
	end
end

-- Returns true if a hero has red hair
function IsGinger(unit)

	local ginger_hero_names = {
		"npc_dota_hero_enchantress",
		"npc_dota_hero_lina",
		"npc_dota_hero_windrunner"
	}

	local unit_name = unit:GetName()
	for _,name in pairs(ginger_hero_names) do
		if name == unit_name then
			return true
		end
	end
	
	return false
end

-- Fetches a hero's current spell power
function GetSpellPower(unit)

	-- If this is not a hero, or the unit is invulnerable, do nothing
	if not unit:IsHero() or unit:IsInvulnerable() then
		return 0
	end

	-- Adjust base spell power based on current intelligence
	local unit_intelligence = unit:GetIntellect()
	local spell_power = unit_intelligence * 0.125

	-- Adjust spell power based on War Veteran stacks
	if unit:HasModifier("modifier_imba_unlimited_level_powerup") then
		spell_power = spell_power + 2 * unit:GetModifierStackCount("modifier_imba_unlimited_level_powerup", unit)
	end

	-- Fetch current bonus spell power from modifiers, if existing
	for current_modifier, modifier_spell_power in pairs(MODIFIER_SPELL_POWER) do
		if unit:HasModifier(current_modifier) then
			spell_power = spell_power + modifier_spell_power
		end
	end

	-- Fetch current bonus spell power from items, if existing
	for i = 0, 5 do
		local current_item = unit:GetItemInSlot(i)
		if current_item then
			local current_item_name = current_item:GetName()
			if ITEM_SPELL_POWER[current_item_name] then
				spell_power = spell_power + ITEM_SPELL_POWER[current_item_name]
			end
		end
	end

	-- Fetch bonus spell power from talents
	spell_power = spell_power + GetSpellPowerFromTalents(unit)

	-- Return current spell power
	return spell_power
end

-- Fetches a hero's current spell power from talents
function GetSpellPowerFromTalents(unit)
	local spell_power = 0

	-- Iterate through all spell power talents
	for talent_name,spell_power_bonus in pairs(SPELL_POWER_TALENTS) do
		if unit:FindAbilityByName(talent_name) and unit:FindAbilityByName(talent_name):GetLevel() > 0 then
			spell_power = spell_power + spell_power_bonus
		end
	end

	return spell_power
end

-- Directly reduces a hero's HP without killing it
function ApplyHealthReductionDamage(unit, damage)
	unit:SetHealth(math.max(unit:GetHealth() - damage, 2))
end

-- Spawns runes on the map
function SpawnImbaRunes()

	-- Locate the rune spots on the map
	local bounty_rune_locations = Entities:FindAllByName("dota_item_rune_spawner_bounty")
	local powerup_rune_locations = Entities:FindAllByName("dota_item_rune_spawner_powerup")

	-- Spawn bounty runes
	local game_time = GameRules:GetDOTATime(false, false)
	for _, bounty_loc in pairs(bounty_rune_locations) do
		local bounty_rune = CreateItem("item_imba_rune_bounty", nil, nil)
		 CreateItemOnPositionForLaunch(bounty_loc:GetAbsOrigin(), bounty_rune)

		-- If these are the 00:00 runes, double their worth
		if game_time < 1 then
			bounty_rune.is_initial_bounty_rune = true
		end
	end

	-- List of powerup rune types
	local powerup_rune_types = {
		"item_imba_rune_double_damage",
		"item_imba_rune_haste",
		"item_imba_rune_regeneration"
	}

	-- Spawn a random powerup rune in a random powerup location
	if game_time > 1 then
		CreateItemOnPositionForLaunch(powerup_rune_locations[RandomInt(1, #powerup_rune_locations)]:GetAbsOrigin(), CreateItem(powerup_rune_types[RandomInt(1, #powerup_rune_types)], nil, nil))
	end
end

-- Picks up a bounty rune
function PickupBountyRune(item, unit)

	-- Bounty rune parameters
	local base_bounty = 50
	local bounty_per_minute = 5
	local game_time = GameRules:GetDOTATime(false, false)
	local current_bounty = base_bounty + bounty_per_minute * game_time / 60

	-- If this is the first bounty rune spawn, double the base bounty
	if item.is_initial_bounty_rune then
		current_bounty = base_bounty * 2
	end

	-- Adjust value for lobby options
	current_bounty = current_bounty * (1 + CUSTOM_GOLD_BONUS * 0.01)

	-- Grant the unit experience
	unit:AddExperience(current_bounty, DOTA_ModifyXP_CreepKill, false, true)

	-- If this is alchemist, increase the gold amount
	if unit:FindAbilityByName("alchemist_goblins_greed") and unit:FindAbilityByName("alchemist_goblins_greed"):GetLevel() > 0 then
		current_bounty = current_bounty * 4
	end

	-- Grant the unit gold
	unit:ModifyGold(current_bounty, false, DOTA_ModifyGold_CreepKill)

	-- Show the gold gained message to everyone
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, unit, current_bounty, nil)

	-- Play the gold gained sound
	unit:EmitSound("General.Coins")

	-- Play the bounty rune activation sound to the unit's team
	EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Bounty", unit)
end

-- Picks up a haste rune
function PickupHasteRune(item, unit)

	-- Apply the aura modifier to the owner
	item:ApplyDataDrivenModifier(unit, unit, "modifier_imba_rune_haste_owner", {})

	-- Apply the movement speed increase modifier to the owner
	local duration = item:GetSpecialValueFor("duration")
	unit:AddNewModifier(unit, item, "modifier_imba_haste_rune_speed_limit_break", {duration = duration})

	-- Play the haste rune activation sound to the unit's team
	EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Haste", unit)
end

-- Picks up a double damage rune
function PickupDoubleDamageRune(item, unit)

	-- Apply the aura modifier to the owner
	item:ApplyDataDrivenModifier(unit, unit, "modifier_imba_rune_double_damage_owner", {})

	-- Play the double damage rune activation sound to the unit's team
	EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.DD", unit)
end

-- Picks up a regeneration rune
function PickupRegenerationRune(item, unit)

	-- Apply the aura modifier to the owner
	item:ApplyDataDrivenModifier(unit, unit, "modifier_imba_rune_regeneration_owner", {})

	-- Play the double damage rune activation sound to the unit's team
	EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Regen", unit)
end