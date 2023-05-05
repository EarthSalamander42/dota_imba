-- Tables/Arrays utils
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

function MergeTables( t1, t2 )
	for name,info in pairs(t2) do
		t1[name] = info
	end
end

-- Copy shallow copy given input
function ShallowCopy(orig)
	local copy = {}
	for orig_key, orig_value in pairs(orig) do
		copy[orig_key] = orig_value
	end
	return copy
end

function ShuffledList( orig_list )
	local list = ShallowCopy( orig_list )
	local result = {}
	local count = #list
	for i = 1, count do
		local pick = RandomInt( 1, #list )
		result[ #result + 1 ] = list[ pick ]
		table.remove( list, pick )
	end
	return result
end

function TableFindKey( table, val )
	if table == nil then
		print( "nil" )
		return nil
	end

	for k, v in pairs( table ) do
		if v == val then
			return k
		end
	end
	return nil
end


function CopyArray(array, length)
	local newArray = {}
	for i = 0, length - 1 do
		newArray[i] = array[i]
	end
	return newArray
end


function tableRemoveAtIndexZero(table)
	local newTable = {}
	for i = 0, #table - 1 do
		newTable[i] = table[i+1]
	end

	return newTable
end

function TableSubtract(greaterTable, smallerTable)
	local set = {}
	for i = 0, #smallerTable do
		set[smallerTable[i]] = true;
	end

	local difference = {}
	for i = 0, #greaterTable do
		difference[i] = greaterTable[i]
	end

	for i = #difference, 0, -1 do
		if set[difference[i]] then
			if i == 0 then
				difference = tableRemoveAtIndexZero(difference)
			else
				table.remove(difference, i)
			end
		end
	end

	return difference
end

function BubbleSortByElement(t, element_name)
	local i = 0

	-- Basically, if the counter goes up to table length without ordering anything we're good to go
	while i ~= #t do
		for k, v in ipairs(t) do
			if t[k + 1] and t[k][element_name] and t[k + 1][element_name] and t[k][element_name] > t[k + 1][element_name] then
--				print(t[k][element_name], t[k + 1][element_name])
				t[k], t[k + 1] = t[k + 1], t[k]
				i = 0
				break
			else
				i = i + 1
			end
		end
	end

	return t
end

-- String utils
function string.split(input, delimiter)
	input = tostring(input)
	delimiter = tostring(delimiter)
	if (delimiter == "") then
		return false
	end
	local pos, arr = 0, {}
	-- for each divider found
	for st, sp in function()
		return string.find(input, delimiter, pos, true)
	end do
		table.insert(arr, string.sub(input, pos, st - 1))
		pos = sp + 1
	end
	table.insert(arr, string.sub(input, pos))
	return arr
end

function String2Vector(s)
	local array = string.split(s, " ")
	return Vector(array[1], array[2], array[3])
end

-- Map utils
function Map1v1() return "imba_1v1" end
function Map10v10() return "imba_10v10" end
function MapTournament() return "map_tournament" end
function MapOverthrow() return "imbathrow_ffa" end
function MapDemo() return "imba_demo" end

function Is10v10Map()
	if GetMapName() == Map10v10() then
		return true
	end

	return false
end

function IsTournamentMap()
	if GetMapName() == MapTournament() then
		return true
	end

	return false
end

function IsOverthrowMap()
	if GetMapName() == MapOverthrow() then
		return true
	end

	return false
end

-- Check if an unit is near the enemy fountain
function IsNearFountain(location, distance)
	for _, fountain in pairs(Entities:FindAllByClassname("ent_dota_fountain")) do
		if (fountain:GetAbsOrigin() - location):Length2D() <= distance then
			return true
		end
	end

	return false
end

function IsNearEntity(entities, location, distance, owner)
	for _, entity in pairs(Entities:FindAllByClassname(entities)) do
		if (entity:GetAbsOrigin() - location):Length2D() <= distance or owner and (entity:GetAbsOrigin() - location):Length2D() <= distance and entity:GetOwner() == owner then
			return true
		end
	end

	return false
end

function IsNearPosition(location, distance)
	for _, fountain in pairs(Entities:FindAllByClassname(entity)) do
		if (fountain:GetAbsOrigin() - location):Length2D() <= distance then
			return true
		end
	end

	return false
end

-- Finds whether or not an entity is an item container (the box on the game ground)
function CBaseEntity:IsItemContainer()
	if self.GetContainedItem then
		if self:GetContainedItem() then
			return true
		end
	end

	return false
end

function ShowHUD(bool)
-- 0, Clock
-- 1, Top Bar
-- 2, ???
-- 3, Action Panel
-- 4, Minimap
-- 5, Inventory
-- 6, Courier + Shop Button Area

	for i = 0, 6 do
		if GameRules:GetGameModeEntity():GetHUDVisible(i) ~= bool then
			GameRules:GetGameModeEntity():SetHUDVisible(i, bool)
		end
	end
end

function UpdateRoshanBar(roshan)
	CustomNetTables:SetTableValue("game_options", "roshan", {
			level = GAME_ROSHAN_KILLS +1,
			HP = roshan:GetHealth(),
			HP_alt = roshan:GetHealthPercent(),
			maxHP = roshan:GetMaxHealth()
		})
	return time
end

-- TODO: Maybe this is laggy, format it later
function InitItemIds()
	GameMode.itemIDs = {}
	for k,v in pairs(KeyValues.ItemKV) do
		if type(v) == "table" and v.ID then
			GameMode.itemIDs[v.ID] = k
		end
	end
end

-- Yahnich's calculate distance and direction functions
function CalculateDistance(ent1, ent2)
	local pos1 = ent1
	local pos2 = ent2
	if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
	if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
	local distance = (pos1 - pos2):Length2D()
	return distance
end

-- Rolls a Psuedo Random chance. If failed, chances increases, otherwise chances are reset
-- Numbers taken from https://gaming.stackexchange.com/a/290788
function RollPseudoRandom(base_chance, entity)
	local chances_table = {
		{1, 0.015604},
		{2, 0.062009},
		{3, 0.138618},
		{4, 0.244856},
		{5, 0.380166},
		{6, 0.544011},
		{7, 0.735871},
		{8, 0.955242},
		{9, 1.201637},
		{10, 1.474584},
		{11, 1.773627},
		{12, 2.098323},
		{13, 2.448241},
		{14, 2.822965},
		{15, 3.222091},
		{16, 3.645227},
		{17, 4.091991},
		{18, 4.562014},
		{19, 5.054934},
		{20, 5.570404},
		{21, 6.108083},
		{22, 6.667640},
		{23, 7.248754},
		{24, 7.851112},
		{25, 8.474409},
		{26, 9.118346},
		{27, 9.782638},
		{28, 10.467023},
		{29, 11.171176},
		{30, 11.894919},
		{31, 12.637932},
		{32, 13.400086},
		{33, 14.180520},
		{34, 14.981009},
		{35, 15.798310},
		{36, 16.632878},
		{37, 17.490924},
		{38, 18.362465},
		{39, 19.248596},
		{40, 20.154741},
		{41, 21.092003},
		{42, 22.036458},
		{43, 22.989868},
		{44, 23.954015},
		{45, 24.930700},
		{46, 25.987235},
		{47, 27.045294},
		{48, 28.100764},
		{49, 29.155227},
		{50, 30.210303},
		{51, 31.267664},
		{52, 32.329055},
		{53, 33.411996},
		{54, 34.736999},
		{55, 36.039785},
		{56, 37.321683},
		{57, 38.583961},
		{58, 39.827833},
		{59, 41.054464},
		{60, 42.264973},
		{61, 43.460445},
		{62, 44.641928},
		{63, 45.810444},
		{64, 46.966991},
		{65, 48.112548},
		{66, 49.248078},
		{67, 50.746269},
		{68, 52.941176},
		{69, 55.072464},
		{70, 57.142857},
		{71, 59.154930},
		{72, 61.111111},
		{73, 63.013699},
		{74, 64.864865},
		{75, 66.666667},
		{76, 68.421053},
		{77, 70.129870},
		{78, 71.794872},
		{79, 73.417722},
		{80, 75.000000},
		{81, 76.543210},
		{82, 78.048780},
		{83, 79.518072},
		{84, 80.952381},
		{85, 82.352941},
		{86, 83.720930},
		{87, 85.057471},
		{88, 86.363636},
		{89, 87.640449},
		{90, 88.888889},
		{91, 90.109890},
		{92, 91.304348},
		{93, 92.473118},
		{94, 93.617021},
		{95, 94.736842},
		{96, 95.833333},
		{97, 96.907216},
		{98, 97.959184},
		{99, 98.989899},	
		{100, 100}
	}

	entity.pseudoRandomModifier = entity.pseudoRandomModifier or 0
	local prngBase
	for i = 1, #chances_table do
		if base_chance == chances_table[i][1] then		  
			prngBase = chances_table[i][2]
		end	 
	end

	if not prngBase then
--		print("The chance was not found! Make sure to add it to the table or change the value.")
		return false
	end
	
	if RollPercentage( prngBase + entity.pseudoRandomModifier ) then
		entity.pseudoRandomModifier = 0
		return true
	else
		entity.pseudoRandomModifier = entity.pseudoRandomModifier + prngBase		
		return false
	end
end

-- 100% kills a unit. Activates death-preventing modifiers, then removes them. Does not killsteal from Reaper's Scythe.
function TrueKill(caster, target, ability)

	-- Extremely specific blademail interaction because fuck everything
	if caster:HasModifier("modifier_item_blade_mail_reflect") then
		target:RemoveModifierByName("modifier_imba_purification_passive")
	end

	local nothlProtection = target:FindModifierByName("modifier_imba_dazzle_nothl_protection")
	if nothlProtection and nothlProtection:GetStackCount() < 1 then
		nothlProtection:SetStackCount(1)
		nothlProtection:StartIntervalThink(1)
	end

	-- Deals lethal damage in order to trigger death-preventing abilities... Except for Reincarnation
	if not ( target:HasModifier("modifier_imba_reincarnation") or target:HasModifier("modifier_imba_reincarnation_wraith_form_buff") or target:HasModifier("modifier_imba_reincarnation_wraith_form") ) then
		target:Kill(ability, caster)
	end
	
	if target:HasAbility("imba_huskar_berserkers_blood") and target:FindAbilityByName("imba_huskar_berserkers_blood"):IsCooldownReady() then
		target:FindAbilityByName("imba_huskar_berserkers_blood"):StartCooldown(FrameTime())
	end

	-- Removes the relevant modifiers
	target:RemoveModifierByName("modifier_invulnerable")
	target:RemoveModifierByName("modifier_imba_dazzle_shallow_grave")
	target:RemoveModifierByName("modifier_imba_aphotic_shield_buff_block")
	target:RemoveModifierByName("modifier_imba_spiked_carapace")
	target:RemoveModifierByName("modifier_borrowed_time")
	target:RemoveModifierByName("modifier_imba_centaur_return")
	target:RemoveModifierByName("modifier_item_greatwyrm_plate_unique")
	target:RemoveModifierByName("modifier_item_greatwyrm_plate_active")
	target:RemoveModifierByName("modifier_item_crimson_guard_unique")
	target:RemoveModifierByName("modifier_item_crimson_guard_active")	
	target:RemoveModifierByName("modifier_item_vanguard_unique")
	target:RemoveModifierByName("modifier_item_imba_initiate_robe_stacks")
	target:RemoveModifierByName("modifier_imba_cheese_death_prevention")
	target:RemoveModifierByName("modifier_imba_rapier_cursed")
	target:RemoveModifierByName("modifier_imba_dazzle_nothl_protection_aura_talent")
	target:RemoveModifierByName("modifier_imba_battle_trance_720")
	target:RemoveModifierByName("modifier_imba_huskar_berserkers_blood_crimson_priest")

	-- Kills the target
	if not target:HasModifier("modifier_imba_reincarnation_wraith_form") then
		target:Kill(ability, caster)
	end
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

function ChangeAttackProjectileImba(unit)

	local particle_deso = "particles/items_fx/desolator_projectile.vpcf"
	local particle_skadi = "particles/items2_fx/skadi_projectile.vpcf"
	local particle_lifesteal = "particles/item/lifesteal_mask/lifesteal_particle.vpcf"
	local particle_deso_skadi = "particles/item/desolator/desolator_skadi_projectile_2.vpcf"
	local particle_clinkz_arrows = "particles/units/heroes/hero_clinkz/clinkz_searing_arrow.vpcf"
	local particle_dragon_form_green = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_corrosive.vpcf"
	local particle_dragon_form_red = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf"
	local particle_dragon_form_blue = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf"
	local particle_terrorblade_transform = "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf"

	-- If the unit has a Desolator and a Skadi, use the special projectile
	if unit:HasModifier("modifier_item_imba_desolator") or unit:HasModifier("modifier_item_imba_desolator_2") then
		if unit:HasModifier("modifier_item_imba_skadi") then
			unit:SetRangedProjectileName(particle_deso_skadi)
		-- If only a Desolator, use its attack projectile instead
		else
			unit:SetRangedProjectileName(particle_deso)
		end
	-- If only a Skadi, use its attack projectile instead
	elseif unit:HasModifier("modifier_item_imba_skadi") then
		unit:SetRangedProjectileName(particle_skadi)

	-- If the unit has any form of lifesteal, use the lifesteal projectile
	elseif unit:HasModifier("modifier_imba_morbid_mask") or unit:HasModifier("modifier_imba_mask_of_madness") or unit:HasModifier("modifier_imba_satanic") or unit:HasModifier("modifier_item_imba_vladmir") or unit:HasModifier("modifier_item_imba_vladmir_blood") then		
		unit:SetRangedProjectileName(particle_lifesteal)	

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
--		print(unit:GetKeyValue("ProjectileModel"))
		unit:SetRangedProjectileName(unit:GetKeyValue("ProjectileModel"))
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

--[[
-- Items and abilities that have uninterruptable forced movement
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
--]]

-- Returns an unit's existing increased cast range modifiers
function GetCastRangeIncrease( unit )
	local cast_range_increase = 0
	-- Only the greatefd st increase counts for items, they do not stack
	for _, parent_modifier in pairs(unit:FindAllModifiers()) do        
		if parent_modifier.GetModifierCastRangeBonus then
			cast_range_increase = math.max(cast_range_increase,parent_modifier:GetModifierCastRangeBonus())
		end
	end

	for _, parent_modifier in pairs(unit:FindAllModifiers()) do        
		if parent_modifier.GetModifierCastRangeBonusStacking and parent_modifier:GetModifierCastRangeBonusStacking() then
			cast_range_increase = cast_range_increase + parent_modifier:GetModifierCastRangeBonusStacking()
		end
	end

	return cast_range_increase
end

function SetupTower(tower)
	if tower.initialized then return end
--	if tower.initialized or GetMapName() == Map1v1() then return end
	for i = 1, 4 do
		for _, ability in pairs(TOWER_ABILITIES["tower"..i]) do
			if string.find(tower:GetUnitName(), "tower"..i) then
--				print("Tower found:", ability) -- tower spawned from pocket tower mutation are found and print well, abilities are not given for reasons
				tower:AddAbility(ability):SetLevel(i)
				tower.initialized = true
			end
		end
	end
end

-- Outdated formula
--[[
function GetReductionFromArmor(armor)
	return (0.052 * armor) / (0.9 + 0.048 * math.abs(armor))
end
--]]

function GetReductionFromArmor(armor)
	return (0.06 * armor) / (1 + 0.06 * math.abs(armor))
end

function CalculateDamageIgnoringArmor(damage, armor)
	return 1 / (1 - GetReductionFromArmor(armor)) * damage
end

function CalculatePhysicalDamageNegatedByArmor(damage, armor)
	return (1 - GetReductionFromArmor(armor)) * damage
end

function CalculateReductionFromArmor_Percentage(armorOffset, armor)
	return -GetReductionFromArmor(armor) + GetReductionFromArmor(armorOffset)
end

-- if isDegree = true, entered angle is degree, else radians
function RotateVector2D(v,angle,bIsDegree)
	if bIsDegree then angle = math.rad(angle) end
	local xp = v.x * math.cos(angle) - v.y * math.sin(angle)
	local yp = v.x * math.sin(angle) + v.y * math.cos(angle)

	return Vector(xp,yp,v.z):Normalized()
end

-- Returns true if a value is in a table, false if it is not.
function CheckIfInTable(table, searched_value, optional_number_of_table_rows_to_search_through)
	-- Searches through the ENTIRE table
	if not optional_number_of_table_rows_to_search_through then
		for _,table_value in pairs(table) do
			if table_value == searched_value then
				return true
			end
		end
	else
		-- Searches through the first few rows
		for i=1, optional_number_of_table_rows_to_search_through do
			if i <= #table then
				if table[i] == searched_value then
					return true
				end
			end
		end
	end

	return false
end

function IsVanillaDebuff(modifier_name)		
local vanilla_debuffs = 
	{["modifier_cold_feet"] = true,
	["modifier_arc_warden_flux"] = true,
	["modifier_batrider_sticky_napalm"] = true,
	["modifier_flamebreak_damage"] = true,
	["modifier_beastmaster_primal_roar_slow"] = true,
	["modifier_brewmaster_thunder_clap"] = true,
	["modifier_brewmaster_drunken_haze"] = true,
	["modifier_bristleback_viscous_nasal_goo"] = true,
	["modifier_broodmother_spawn_spiderlings"] = true,
	["modifier_broodmother_incapacitating_bite_orb"] = true,
	["modifier_chaos_knight_reality_rift"] = true,
	["modifier_chen_penitence"] = true, 	 
	["modifier_silence"] = true,
	["modifier_doom_bringer_infernal_blade_burn"] = true,
	["modifier_dragonknight_breathefire_reduction"] = true,
	["modifier_dragon_knight_corrosive_breath_dot"] = true,
	["modifier_dragon_knight_frost_breath_slow"] = true,
	["modifier_earth_spirit_rolling_boulder_slow"] = true,
	["modifier_earth_spirit_geomagnetic_grip_debuff"] = true,
	["modifier_earth_spirit_magnetize"] = true,
	["modifier_elder_titan_earth_splitter"] = true,
	["modifier_ember_spirit_searing_chains"] = true,
	["modifier_enchantress_untouchable_slow"] = true,
	["modifier_enchantress_enchant_slow"] = true,
	["modifier_gyrocopter_call_down_slow"] = true,
	["modifier_huskar_life_break_slow"] = true,
	["modifier_invoker_cold_snap"] = true,
	["modifier_invoker_tornado"] = true,
	["modifier_invoker_chaos_meteor_burn"] = true,
	["modifier_wisp_tether_slow"] = true,
	["modifier_keeper_of_the_light_mana_leak"] = true,
	["modifier_keeper_of_the_light_blinding_light"] = true,
	["modifier_leshrac_lightning_storm_slow"] = true,
	["modifier_life_stealer_open_wounds"] = true,
	["modifier_lone_druid_savage_roar"] = true,
	["modifier_meepo_earthbind"] = true,
	["modifier_meepo_geostrike_debuff"] = true,
	["modifier_monkey_king_spring_slow"] = true,
	["modifier_naga_siren_ensnare"] = true,
	["modifier_naga_siren_rip_tide"] = true,
	["modifier_furion_wrathofnature_spawn"] = true,
	["modifier_ogre_magi_ignite"] = true,
	["modifier_oracle_fates_edict"] = true,
	["modifier_oracle_fortunes_end_purge"] = true,
	["modifier_phantom_lancer_spirit_lance"] = true,
	["modifier_phoenix_icarus_dive_burn"] = true,
	["modifier_phoenix_fire_spirit_burn"] = true,
	["modifier_razor_unstablecurrent_slow"] = true,
	["modifier_rubick_fade_bolt_debuff"] = true,
	["modifier_shadow_demon_soul_catcher"] = true,
	["modifier_shadow_demon_shadow_poison"] = true,
	["modifier_shadow_shaman_voodoo"] = true,
	["modifier_templar_assassin_meld_armor"] = true,
	["modifier_templar_assassin_trap_slow"] = true,
	["modifier_terrorblade_reflection_slow"] = true,
	["modifier_tidehunter_gush"] = true,
	["modifier_tidehunter_anchor_smash"] = true,
	["modifier_whirling_death_debuff"] = true,
	["modifier_shredder_chakram_debuff"] = true,
	["modifier_tinker_laser_blind"] = true,
	["modifier_treant_natures_guise_root"] = true,
	["modifier_greevil_leech_seed"] = true,
	["modifier_treant_overgrowth"] = true,
	["modifier_tusk_walrus_punch_slow"] = true,
	["modifier_tusk_walrus_kick_slow"] = true,
	["modifier_abyssal_underlord_pit_of_malice_ensare"] = true,
	["modifier_viper_poison_attack_slow"] = true,
	["modifier_viper_corrosive_skin_slow"] = true,
	["modifier_visage_grave_chill_debuff"] = true,
	["modifier_winter_wyvern_arctic_burn_slow"] = true,
	["modifier_winter_wyvern_splinter_blast_slow"] = true,
	["modifier_big_thunder_lizard_slam"] = true,
	["modifier_dark_troll_warlord_ensnare"] = true,
	["modifier_ghost_frost_attack_slow"] = true,
	["modifier_polar_furbolg_ursa_warrior_thunder_clap"] = true,
	["modifier_ogre_magi_frost_armor_slow"] = true,
	["modifier_imba_roshan_slam"] = true,
	["modifier_imba_roshan_slam_armor"] = true,
	["modifier_satyr_trickster_purge"] = true,
	["modifier_broodmother_poison_sting_debuff"] = true,
	["modifier_broodmother_poison_sting_dps_debuff"] = true,
	["modifier_lone_druid_spirit_bear_entangle_effect"] = true,
	["modifier_brewmaster_storm_cyclone"] = true,
	["modifier_undying_tombstone_zombie_deathlust"] = true,
	["modifier_gnoll_assassin_envenomed_weapon_poison"] = true,
	["modifier_item_ethereal_blade_ethereal"] = true,
	["modifier_item_ethereal_blade_slow"] = true,
	["modifier_cyclone"] = true,
	["modifier_item_medallion_of_courage_armor_reduction"] = true,
	["modifier_item_orb_of_venom_slow"] = true,
	["modifier_rod_of_atos_debuff"] = true,
	["modifier_item_imba_shivas_blast_slow"] = true,
	["modifier_item_solar_crest_armor_reduction"] = true}

	if vanilla_debuffs[modifier_name] then
		return true
	end

	return false
end

-- Finds units only on the outer layer of a ring
function FindUnitsInRing(teamNumber, position, cacheUnit, ring_radius, ring_width, teamFilter, typeFilter, flagFilter, order, canGrowCache)
	-- First checks all of the units in a radius
	local all_units	= FindUnitsInRadius(teamNumber, position, cacheUnit, ring_radius, teamFilter, typeFilter, flagFilter, order, canGrowCache)
	
	-- Then builds a table composed of the units that are in the outer ring, but not in the inner one.
	local outer_ring_units	=	{}

	for _,unit in pairs(all_units) do
		-- Custom function, checks if the unit is far enough away from the inner radius
		if CalculateDistance(unit:GetAbsOrigin(), position) >= ring_radius - ring_width then
			table.insert(outer_ring_units, unit)
		end
	end

	return outer_ring_units
end

-- Cleave-like cone search - returns the units in front of the caster in a cone.
function FindUnitsInCone(teamNumber, vDirection, vPosition, startRadius, endRadius, flLength, hCacheUnit, targetTeam, targetUnit, targetFlags, findOrder, bCache)
	local vDirectionCone = Vector( vDirection.y, -vDirection.x, 0.0 )
	local enemies = FindUnitsInRadius(teamNumber, vPosition, hCacheUnit, endRadius + flLength, targetTeam, targetUnit, targetFlags, findOrder, bCache )
	local unitTable = {}
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if enemy ~= nil then
				local vToPotentialTarget = enemy:GetOrigin() - vPosition
				local flSideAmount = math.abs( vToPotentialTarget.x * vDirectionCone.x + vToPotentialTarget.y * vDirectionCone.y + vToPotentialTarget.z * vDirectionCone.z )
				local enemy_distance_from_caster = ( vToPotentialTarget.x * vDirection.x + vToPotentialTarget.y * vDirection.y + vToPotentialTarget.z * vDirection.z )
				
				-- Author of this "increase over distance": Fudge, pretty proud of this :D 
				
				-- Calculate how much the width of the check can be higher than the starting point
				local max_increased_radius_from_distance = endRadius - startRadius
				
				-- Calculate how close the enemy is to the caster, in comparison to the total distance
				local pct_distance = enemy_distance_from_caster / flLength
				
				-- Calculate how much the width should be higher due to the distance of the enemy to the caster.
				local radius_increase_from_distance = max_increased_radius_from_distance * pct_distance
				
				if ( flSideAmount < startRadius + radius_increase_from_distance ) and ( enemy_distance_from_caster > 0.0 ) and ( enemy_distance_from_caster < flLength ) then
					table.insert(unitTable, enemy)
				end
			end
		end
	end
	return unitTable
end

-- Extracted from Elfansoer's Dazzle Poison Touch code
-- https://github.com/Elfansoer/dota-2-lua-abilities/blob/master/scripts/vscripts/lua_abilities/dazzle_poison_touch_lua/dazzle_poison_touch_lua.lua
function FindUnitsInBicycleChain( nTeamNumber, vCenterPos, vStartPos, vEndPos, fStartRadius, fEndRadius, hCacheUnit, nTeamFilter, nTypeFilter, nFlagFilter, nOrderFilter, bCanGrowCache )
	-- vCenterPos is used to determine searching center (FIND_CLOSEST will refer to units closest to vCenterPos)

	-- get cast direction and length distance
	local direction = vEndPos-vStartPos
	direction.z = 0

	local distance = direction:Length2D()
	direction = direction:Normalized()

	-- get max radius circle search
	local big_radius = distance + math.max(fStartRadius, fEndRadius)

	-- find enemies closest to primary target within max radius
	local units = FindUnitsInRadius(
		nTeamNumber,	-- int, your team number
		vCenterPos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		big_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		nTeamFilter,	-- int, team filter
		nTypeFilter,	-- int, type filter
		nFlagFilter,	-- int, flag filter
		nOrderFilter,	-- int, order filter
		bCanGrowCache	-- bool, can grow cache
	)

	-- Filter within cone
	local targets = {}
	for _,unit in pairs(units) do

		-- get unit vector relative to vStartPos
		local vUnitPos = unit:GetOrigin()-vStartPos

		-- get projection scalar of vUnitPos onto direction using dot-product
		local fProjection = vUnitPos.x*direction.x + vUnitPos.y*direction.y + vUnitPos.z*direction.z

		-- clamp projected scalar to [0,distance]
		fProjection = math.max(math.min(fProjection,distance),0)
		
		-- get projected vector of vUnitPos onto direction
		local vProjection = direction*fProjection

		-- calculate distance between vUnitPos and the projected vector
		local fUnitRadius = (vUnitPos - vProjection):Length2D()

		-- calculate interpolated search radius at projected vector
		local fInterpRadius = (fProjection/distance)*(fEndRadius-fStartRadius) + fStartRadius

		-- if unit is within distance (and not behind the caster), add them
		if fUnitRadius<=fInterpRadius and math.abs(AngleDiff(VectorToAngles(vCenterPos - vStartPos).y, VectorToAngles(unit:GetAbsOrigin() - vStartPos).y)) <= 90 then
			table.insert( targets, unit )
		end
	end

	return targets
end

function CalculateDirection(ent1, ent2)
	local pos1 = ent1
	local pos2 = ent2
	if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
	if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
	local direction = (pos1 - pos2):Normalized()
	return direction
end

function DisplayError(playerID, message)
	local player = PlayerResource:GetPlayer(playerID)
	if player then
		CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message=message})
	end
end

-- TODO: FORMAT THIS SHIT
function ReconnectPlayer(player_id)
	if not player_id then player_id = 0 end
	if player_id == "test_reconnect" then player_id = 0 end

	print("Player is reconnecting:", player_id)
	-- Say(nil, "Debug: Player ID " .. player_id .. " has reconnected!", false)

	-- Reinitialize the player's pick screen panorama, if necessary
	Timers:CreateTimer(function()
--		print(PlayerResource:GetSelectedHeroEntity(player_id))

		if PlayerResource:GetSelectedHeroEntity(player_id) then
			if IMBA_PICK_SCREEN == true then
				CustomGameEventManager:Send_ServerToAllClients("player_reconnected", {PlayerID = player_id, PickedHeroes = HeroSelection.picked_heroes, pickState = pick_state, repickState = repick_state})

				local hero = PlayerResource:GetSelectedHeroEntity(player_id)

				if hero and PICKING_SCREEN_OVER == true then
					if hero:GetUnitName() == FORCE_PICKED_HERO then
						print('Giving player ' .. player_id .. ' a random hero! (reconnected)')
						local random_hero = HeroSelection:RandomHero()
						print("Random Hero:", random_hero)
						HeroSelection:GiveStartingHero(player_id, random_hero, true)
					end
				end
			end

			-- set player connected again for GG logic
			Timers:CreateTimer(2.0, function()
				local gg_table = {
					ID = player_id,
					team = PlayerResource:GetTeam(player_id),
					disconnect = 2,
				}

				GoodGame:Call(gg_table)
			end)

--			TeamOrdering:OnPlayerReconnect(player_id)
		else
--			print("Not fully reconnected yet:", player_id)
			return 1.0
		end
	end)

	-- If this is a reconnect from abandonment due to a long disconnect, remove the abandon state
	if PlayerResource:GetHasAbandonedDueToLongDisconnect(player_id) then
		local player_name = PlayerResource:GetPlayerName(player_id)
		local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
		local hero_name = hero:GetUnitName()
		local line_duration = 7

		Notifications:BottomToAll({hero = hero_name, duration = line_duration})
		Notifications:BottomToAll({text = player_name.." ", duration = line_duration, continue = true})
		Notifications:BottomToAll({text = "#imba_player_reconnect_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})

		-- Stop redistributing gold to allies, if applicable (Valve handle this now)
--		PlayerResource:StopAbandonGoldRedistribution(player_id)
	end
end

-- Turns a table of entity handles into entindex string separated by commas.
function TableToStringCommaEnt(table)	
	local string = ""
	local first_value = true

	for _,handle in pairs(table) do
		if first_value then
			string = string..tostring(handle:entindex())	
			first_value = false
		else
			string = string..","
			string = string..tostring(handle:entindex())	
		end		
	end

	return string
end

-- Turns an entindex string into a table and returns a table of handles.
-- Separator can only be a space (" ") or a comma (",").
function StringToTableEnt(string, separator)
	local gmatch_sign

	if separator == " " then
		gmatch_sign = "%S+"
	elseif separator == "," then
		gmatch_sign = "([^,]+)"
	end

	local return_table = {}
	for str in string.gmatch(string, gmatch_sign) do 		
		local handle = EntIndexToHScript(tonumber(str))
		table.insert(return_table, handle)
	end	

	return return_table
end

function StoreCurrentDayCycle()	
	Timers:CreateTimer(function()		
		-- Get current daytime cycle
		local is_day = GameRules:IsDaytime()		

		-- Set in the table
		CustomNetTables:SetTableValue("game_options", "isdaytime", {is_day = is_day} )

		-- Repeat
		return 0.5
	end)	
end

function IsDaytime()
	if CustomNetTables:GetTableValue("game_options", "isdaytime") then
		if CustomNetTables:GetTableValue("game_options", "isdaytime").is_day then  
			local is_day = CustomNetTables:GetTableValue("game_options", "isdaytime").is_day  

			if is_day == 1 then
				return true
			else
				return false
			end
		end
	end

	return true   
end

function Greeviling(unit)
	if RandomInt(1, 100) > 85 then
		if string.find(unit:GetUnitName(), "dota_creep") then
			local material_group = tostring(RandomInt(0, 8))
			unit.is_greevil = true
			if string.find(unit:GetUnitName(), "ranged") then
				unit:SetModel("models/courier/greevil/greevil_flying.vmdl")
				unit:SetOriginalModel("models/courier/greevil/greevil_flying.vmdl")
			else
				unit:SetModel("models/courier/greevil/greevil.vmdl")
				unit:SetOriginalModel("models/courier/greevil/greevil.vmdl")
			end

			unit:SetMaterialGroup(material_group)
			unit.eyes = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_eyes.vmdl"})
			unit.ears = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_ears"..RandomInt(1, 2)..".vmdl"})

			if RandomInt(1, 100) > 80 then
				unit.feathers = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_feathers.vmdl"})
				unit.feathers:FollowEntity(unit, true)
			end

			unit.hair = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_hair"..RandomInt(1, 2)..".vmdl"})
			unit.horns = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_horns"..RandomInt(1, 4)..".vmdl"})
			unit.nose = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_nose"..RandomInt(1, 3)..".vmdl"})
			unit.tail = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_tail"..RandomInt(1, 4)..".vmdl"})
			unit.teeth = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_teeth"..RandomInt(1, 4)..".vmdl"})
			unit.wings = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_wings"..RandomInt(1, 4)..".vmdl"})

			-- lock to bone
			unit.eyes:SetMaterialGroup(material_group)
			unit.eyes:FollowEntity(unit, true)
			unit.ears:SetMaterialGroup(material_group)
			unit.ears:FollowEntity(unit, true)
			unit.hair:FollowEntity(unit, true)
			unit.horns:SetMaterialGroup(material_group)
			unit.horns:FollowEntity(unit, true)
			unit.nose:SetMaterialGroup(material_group)
			unit.nose:FollowEntity(unit, true)
			unit.tail:SetMaterialGroup(material_group)
			unit.tail:FollowEntity(unit, true)
			unit.teeth:SetMaterialGroup(material_group)
			unit.teeth:FollowEntity(unit, true)
			unit.wings:SetMaterialGroup(material_group)
			unit.wings:FollowEntity(unit, true)
		elseif string.find(unit:GetUnitName(), "_siege") then
			unit:SetModel("models/creeps/mega_greevil/mega_greevil.vmdl")
			unit:SetOriginalModel("models/creeps/mega_greevil/mega_greevil.vmdl")
			unit:SetModelScale(2.75)
		end

		return
	end
end

function Setup1v1()
	local removed_ents = {
		"lane_top_goodguys_melee_spawner",
		"lane_bot_goodguys_melee_spawner",
		"lane_top_badguys_melee_spawner",
		"lane_bot_badguys_melee_spawner",
	}

	for _, ent_name in pairs(removed_ents) do
		local ent = Entities:FindByName(nil, ent_name)
		ent:RemoveSelf()
	end

	local towers = Entities:FindAllByClassname("npc_dota_tower")

	for _, tower in pairs(towers) do
		if string.find(tower:GetUnitName(), "tower1_top") or string.find(tower:GetUnitName(), "tower1_bot") then
			tower:AddNewModifier(tower, nil, "modifier_invulnerable", {})
		end
	end

	BlockJungleCamps()
end

function BlockJungleCamps()
	local blocked_camps = {}
	blocked_camps[1] = {"neutralcamp_evil_1", Vector(-4170, 3670, 512)}
	blocked_camps[2] = {"neutralcamp_evil_2", Vector(-3030, 4500, 512)}
	blocked_camps[3] = {"neutralcamp_evil_3", Vector(-2000, 4220, 384)}
	blocked_camps[4] = {"neutralcamp_evil_4", Vector(-10, 3300, 512)}
	blocked_camps[5] = {"neutralcamp_evil_5", Vector(1315, 3520, 512)}
	blocked_camps[6] = {"neutralcamp_evil_6", Vector(-675, 2280, 1151)}
	blocked_camps[7] = {"neutralcamp_evil_7", Vector(2400, 360, 520)}
	blocked_camps[8] = {"neutralcamp_evil_8", Vector(4060, -620, 384)}
	blocked_camps[9] = {"neutralcamp_evil_9", Vector(4100, 1050, 1288)}
	blocked_camps[10] = {"neutralcamp_good_1", Vector(3010, -4430, 512)}
	blocked_camps[11] = {"neutralcamp_good_2", Vector(4810, -4200, 512)}
	blocked_camps[12] = {"neutralcamp_good_3", Vector(787, -4500, 512)}
	blocked_camps[13] = {"neutralcamp_good_4", Vector(-430, -3100, 384)}
	blocked_camps[14] = {"neutralcamp_good_5", Vector(-1500, -4290, 384)}
	blocked_camps[15] = {"neutralcamp_good_6", Vector(-3040, 100, 512)}
	blocked_camps[16] = {"neutralcamp_good_7", Vector(-3700, 890, 512)}
	blocked_camps[17] = {"neutralcamp_good_8", Vector(-4780, -190, 512)}
	blocked_camps[18] = {"neutralcamp_good_9", Vector(256, -1717, 1280)}

	for i = 1, #blocked_camps do
		local ent = Entities:FindByName(nil, blocked_camps[i][1])
		local dummy = CreateUnitByName("npc_dummy_unit_perma", blocked_camps[i][2], true, nil, nil, DOTA_TEAM_NEUTRALS)
	end
end

function SpawnEasterEgg()
	if RandomInt(1, 100) > 20 then
		Timers:CreateTimer((RandomInt(15, 25) * 60) + RandomInt(0, 60), function()
			local pos = {}
			pos[1] = Vector(6446, -6979, 1496)
			pos[2] = Vector(RandomInt(-6000, 0), RandomInt(7150, 7300), 1423)
			pos[3] = Vector(RandomInt(-1000, 2000), RandomInt(6900, 7200), 1440)
			pos[4] = Vector(7041, -6263, 1461)
			local pos = pos[RandomInt(1, 4)]

			GridNav:DestroyTreesAroundPoint(pos, 80, false)
			local item = CreateItem("item_the_caustic_finale", nil, nil)
			local drop = CreateItemOnPositionSync(pos, item)
		end)
	end
end

function mysplit(inputstr, sep)
	-- whitespace by default
	if sep == nil then
		sep = "%s"
	end

	local t = {}

	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end

	return t
end

function IsSaturday()
	local check_date = {}
	check_date.day = 28
	check_date.month = 09
	check_date.year = 19

--	if IsInToolsMode() then
		-- GetSystemDate returns MM/DD/AA format
--		current_date = "03/28/20"
--	end

	local current_date_split = mysplit(GetSystemDate(), "/")
	local current_date = {}
	current_date.day = tonumber(current_date_split[2])
	current_date.month = tonumber(current_date_split[1])
	current_date.year = tonumber(current_date_split[3])
	local day_count = 0
	-- print(check_date, current_date)

	if current_date.month == check_date.month and current_date.year == check_date.year then
		-- print("Check/Current day:", check_date.day, current_date.day)
		day_count = check_date.day - current_date.day
		if day_count < 0 then day_count = day_count * (-1) end
	else
		for y = check_date.year, current_date.year do
			-- print("Currently checking year:", y)
			if check_date.year == current_date.year then
				-- print("Check in same check/current year")
				for i = check_date.month, current_date.month do
					if i == check_date.month then
						-- print("First month:", get_remaining_days_in_month(check_date.month, check_date.day, check_date.year % 4 == 0))
						day_count = day_count + get_remaining_days_in_month(check_date.month, check_date.day, check_date.year % 4 == 0)
					elseif i == current_date.month then
						-- print("last month:", get_remaining_days_in_month(current_date.month, current_date.day, current_date.year % 4 == 0))
						day_count = day_count + current_date.day - 1
					else
						-- print("month between (full)", get_remaining_days_in_month(current_date.month, nil, current_date.year % 4 == 0)	)
						day_count = day_count + get_remaining_days_in_month(current_date.month, nil, current_date.year % 4 == 0)						
					end
				end
			else
				if y == check_date.year then
					-- print("Remaining days in first year:", get_remaining_days_in_year(check_date.year, check_date.month, check_date.day))
					day_count = day_count + get_remaining_days_in_year(check_date.year, check_date.month, check_date.day)
				elseif y == current_date.year then
					-- print("Remaining days in last year:", get_remaining_days_in_year(current_date.year) - get_remaining_days_in_year(current_date.year, current_date.month, current_date.day))
					day_count = day_count + (get_remaining_days_in_year(current_date.year) - get_remaining_days_in_year(current_date.year, current_date.month, current_date.day))
				else
					-- print("Year between (full):", get_remaining_days_in_year(check_date.year))
					day_count = day_count + get_remaining_days_in_year(check_date.year)
				end
			end
		end
	end

	-- print("Day count:", day_count, day_count % 7)

	if day_count % 7 == 0 then
		return true
	else
		return false
	end
end

function get_remaining_days_in_month(iMonth, iDay, iLeapYear)
	local count = 0
	local days_in_months = {"31", "28", "31", "30", "31", "30", "31", "31", "30", "31", "30", "31"}
	if iLeapYear and iMonth == 2 then count = 1 end

	if iDay then
		-- print("Total days/current day:", iMonth, days_in_months[iMonth], iDay)
		count = count + (tonumber(days_in_months[iMonth]) - iDay) + 1
	else
		count = count + tonumber(days_in_months[iMonth])
	end

	return count
end

function get_remaining_days_in_year(iYear, iMonth, iDay)
	local count = 0
	local leap_year = false
	if iYear % 4 == 0 then leap_year = true end

	local starting_iteration = 1
	if iMonth then starting_iteration = iMonth end

	for i = starting_iteration, 12 do
		if i == starting_iteration and iMonth then
			-- print(i, get_remaining_days_in_month(i, iDay, leap_year))
			count = count + get_remaining_days_in_month(i, iDay, leap_year)
		else
			count = count + get_remaining_days_in_month(i, nil, leap_year)
			-- print(i, get_remaining_days_in_month(i, nil, leap_year))
		end
	end

	return count
end

-- ALLOW MULTIPLE INTRINSIC MODIFIERS (table support for GetIntrinsicModifierName)

--[[
-- needs to be tested before using it
original_GetIntrinsicModifierName = CDOTABaseAbility.GetIntrinsicModifierName
CDOTABaseAbility.GetIntrinsicModifierName = function(self, sModifierName)
	print("Ability/Item:", self:GetAbilityName())
	if self == nil then return end

	print("type:", type(sModifierName))
	if type(sModifierName) == "table" then
		print("Table of intrinsic modifiers! yay!")
		for index, modifier_name in pairs(sModifierName) do
			print(index, modifier_name)
			if not self.intrinsic_modifiers then self.intrinsic_modifiers = {} end

			local class = modifier_name.." = class({IsHidden = function(self) return true end, RemoveOnDeath = function(self) return false end, AllowIllusionDuplicate = function(self) return true end})"  
			load(class)()

			local mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, modifier_name, {})
			table.insert(self.intrinsic_modifiers, mod)
		end
	else
		return original_GetIntrinsicModifierName(self, sModifierName)
	end
end

-- Item added to inventory filter
GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(function(ctx, event)
	local unit = EntIndexToHScript(event.inventory_parent_entindex_const)
	if unit == nil then return end
	if unit:IsRealHero() then if unit:GetPlayerID() == -1 then return end end
	local item = EntIndexToHScript(event.item_entindex_const)

	if not unit:HasItemInInventory(item:GetAbilityName()) then
		if not unit:HasItemInInventory(item:GetAbilityName()) then
			print("Dropped item has multiple intrinsic modifiers, removing them")
			for index, modifier_name in pairs(item.intrinsic_modifiers) do
				if unit:HasModifier(modifier_name) then
					unit:RemoveModifierByName(modifier_name)
				end
			end
		end
	end

	return true
end, GameMode)
--]]

-- FireParticle credits: yahnich
function ParticleManager:FireParticle(effect, attach, owner, cps)
	local FX = ParticleManager:CreateParticle(effect, attach, owner)
	if cps then
		for cp, value in pairs(cps) do
			if type(value) == "userdata" then
				ParticleManager:SetParticleControl(FX, tonumber(cp), value)
			elseif type(value) == "table" then
				ParticleManager:SetParticleControlEnt(FX, cp, value.owner or owner, value.attach or attach, value.point or "attach_hitloc", owner:GetAbsOrigin(), true)
			else
				ParticleManager:SetParticleControlEnt(FX, cp, owner, attach, value, owner:GetAbsOrigin(), true)
			end
		end
	end
	ParticleManager:ReleaseParticleIndex(FX)
end

-- custom event listeners credits: darklord (Dota 12v12)
for _, listenerId in ipairs(registeredCustomEventListeners or {}) do
	CustomGameEventManager:UnregisterListener(listenerId)
end
registeredCustomEventListeners = {}
function RegisterCustomEventListener(eventName, callback)
	local listenerId = CustomGameEventManager:RegisterListener(eventName, function(_, args)
		callback(args)
	end)

	table.insert(registeredCustomEventListeners, listenerId)
end

for _, listenerId in ipairs(registeredGameEventListeners or {}) do
	StopListeningToGameEvent(listenerId)
end
registeredGameEventListeners = {}
function RegisterGameEventListener(eventName, callback)
	local listenerId = ListenToGameEvent(eventName, callback, nil)
	table.insert(registeredGameEventListeners, listenerId)
end

-- Much more efficient implementation of table element removal than table.remove()
-- Written by Mitch McMabers of StackOverflow
-- https://stackoverflow.com/a/53038524

-- Example Usage:
-- local t = {
	-- 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'
-- };

-- Custom_ArrayRemove(t, function(t, i, j)
	-- -- Return true to keep the value, or false to discard it.
	-- local v = t[i];
	-- return (v == 'a' or v == 'b' or v == 'f' or v == 'h'); // This keeps a, b, f, and h in the array while removing everything else
-- end);

function Custom_ArrayRemove(t, fnKeep)
	local j, n = 1, #t;

	for i=1,n do
		if (fnKeep(i, j)) then
			-- Move i's kept value to j's position, if it's not already there.
			if (i ~= j) then
				t[j] = t[i];
				t[i] = nil;
			end
			j = j + 1; -- Increment position of where we'll place the next kept value.
		else
			t[i] = nil;
		end
	end

	return t;
end

function Custom_bIsStrongIllusion(unit)
	if not unit or unit:IsNull() then
		return
	end
	local strong_illus = {
		"modifier_chaos_knight_phantasm_illusion",
		"modifier_imba_chaos_knight_phantasm_illusion",
		"modifier_vengefulspirit_hybrid_special",
		"modifier_chaos_knight_phantasm_illusion_shard",
	}
	for _, v in pairs(strong_illus) do
		if unit:HasModifier(v) then
			return true
		end
	end
	return false
end

-- Checks if the entity is any kind of tree (either regular or temporary)
function CEntityInstance:Custom_IsTree()
	if self:Custom_IsRegularTree() or self:Custom_IsTempTree() then
		return true
	end

	return false
end

-- Checks if the entity is a regular tree that spawns in the map
function CEntityInstance:Custom_IsRegularTree()
	if self.CutDown then
		return true	
	end

	return false
end

-- Checks if the entity is a temporary tree that despawns after a while (Furion's Sprout, gg branch etc.)
function CEntityInstance:Custom_IsTempTree()
	if self:GetClassname() == "dota_temp_tree" then
		return true
	end

	return false
end

-- Gets all Ethereal abilities
function GetEtherealAbilities()
	local abilities = {
		"modifier_imba_ghost_shroud_active",
		"modifier_imba_ghost_state",
		"modifier_item_imba_ethereal_blade_ethereal",
	}

	return abilities
end
