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

function PrintAll(t)
	for k,v in pairs(t) do
		print(k,v)
	end
end

function MergeTables( t1, t2 )
	for name,info in pairs(t2) do
		t1[name] = info
	end
end

function AddTableToTable( t1, t2)
	for k,v in pairs(t2) do
		table.insert(t1, v)
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

-------------------------------------------------------------------------------------------------
-- IMBA: custom utility functions
-------------------------------------------------------------------------------------------------

-- Returns the killstreak/deathstreak bonus gold for this hero
function GetKillstreakGold( hero )
	local base_bounty = HERO_KILL_GOLD_BASE + hero:GetLevel() * HERO_KILL_GOLD_PER_LEVEL
	local gold = ( hero.kill_streak_count ^ KILLSTREAK_EXP_FACTOR ) * HERO_KILL_GOLD_PER_KILLSTREAK - hero.death_streak_count * HERO_KILL_GOLD_PER_DEATHSTREAK
	
	-- Limits to maximum and minimum kill/deathstreak values
	gold = math.max(gold, (-1) * base_bounty * HERO_KILL_GOLD_DEATHSTREAK_CAP / 100 )
	gold = math.min(gold, base_bounty * ( HERO_KILL_GOLD_KILLSTREAK_CAP - 100 ) / 100)

	return gold
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
function GetRandomTowerAbility(tier, ability_table)

	local ability = RandomFromTable(ability_table[tier])	

	return ability
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

-- Initializes heroes' innate abilities
function InitializeInnateAbilities( hero )	

	-- Cycle through all of the heroes' abilities, and upgrade the innates ones
	for i = 0, 15 do		
		local current_ability = hero:GetAbilityByIndex(i)		
		if current_ability and current_ability.IsInnateAbility then
			if current_ability:IsInnateAbility() then
				current_ability:SetLevel(1)
			end
		end
	end
end


function IndexAllTowerAbilities()
	local ability_table = {}
	local tier_one_abilities = {}
	local tier_two_abilities = {}
	local tier_three_abilities = {}
	local tier_active_abilities = {}

	for _,tier in pairs(TOWER_ABILITIES) do		

		for _,ability in pairs(tier) do
			if tier == TOWER_ABILITIES.tier_one then
				table.insert(tier_one_abilities, ability.ability_name)
			elseif tier == TOWER_ABILITIES.tier_two then
				table.insert(tier_two_abilities, ability.ability_name)
			elseif tier == TOWER_ABILITIES.tier_three then
				table.insert(tier_three_abilities, ability.ability_name)
			else
				table.insert(tier_active_abilities, ability.ability_name)
			end			
		end
	end

	table.insert(ability_table, tier_one_abilities)
	table.insert(ability_table, tier_two_abilities)
	table.insert(ability_table, tier_three_abilities)
	table.insert(ability_table, tier_active_abilities)

	return ability_table
end

-- Upgrades a tower's abilities
function UpgradeTower(tower)
	for i = 0, tower:GetAbilityCount()-1 do
		local ability = tower:GetAbilityByIndex(i)
		if ability and ability:GetLevel() < ability:GetMaxLevel() then			
			ability:SetLevel(ability:GetLevel() + 1)
			break
		end
	end
end

-- Randoms an ability of a certain tier for the Ancient
function GetAncientAbility( tier )

	-- Tier 1 abilities
	if tier == 1 then
		local ability_list = {
			"venomancer_poison_nova",
			"juggernaut_blade_fury"			
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
			"tidehunter_ravage",
			"magnataur_reverse_polarity",
--			"phoenix_supernova",
		}

		return ability_list[RandomInt(1, #ability_list)]
	end
	
	return nil
end


-- Initialize Physics library on this target
function InitializePhysicsParameters(unit)

	if not IsPhysicsUnit(unit) then
		Physics:Unit(unit)
		unit:SetPhysicsVelocityMax(600)
		unit:PreventDI()
	end
end

-- Picks up a bounty rune
function PickupBountyRune(unit)

	-- Bounty rune parameters
	local base_bounty = 50
	local bounty_per_minute = 5
	local game_time = GameRules:GetDOTATime(false, false)
	local current_bounty = base_bounty + bounty_per_minute * game_time / 60

	-- If this is the first bounty rune spawn, double the base bounty
	if item.is_initial_bounty_rune then
		current_bounty = current_bounty  * 2
	end

	-- Adjust value for lobby options
	current_bounty = current_bounty * (1 + CUSTOM_GOLD_BONUS * 0.01)

	-- Grant the unit experience
	unit:AddExperience(current_bounty, DOTA_ModifyXP_CreepKill, false, true)

	-- If this is alchemist, increase the gold amount
	if unit:FindAbilityByName("imba_alchemist_goblins_greed") and unit:FindAbilityByName("imba_alchemist_goblins_greed"):GetLevel() > 0 then
		current_bounty = current_bounty * unit:FindAbilityByName("imba_alchemist_goblins_greed"):GetSpecialValueFor("bounty_multiplier")

		-- #7 Talent: Doubles gold from bounty runes
		if unit:HasTalent("special_bonus_imba_alchemist_7") then
			current_bounty = current_bounty * unit:FindTalentValue("special_bonus_imba_alchemist_7")
		end		
	end
	
	-- #3 Talent: Bounty runes give gold bags
    if unit:HasTalent("special_bonus_imba_alchemist_3") then
        local stacks_to_gold =( unit:FindTalentValue("special_bonus_imba_alchemist_3")/ 100 )  / 5
        local gold_per_bag = unit:FindModifierByName("modifier_imba_goblins_greed_passive"):GetStackCount() * stacks_to_gold
        for i=1, 5 do
            -- Drop gold bags
            local newItem = CreateItem( "item_bag_of_gold", nil, nil )
            newItem:SetPurchaseTime( 0 )
            newItem:SetCurrentCharges( gold_per_bag )
            
            local drop = CreateItemOnPositionSync( unit:GetAbsOrigin(), newItem )
            local dropTarget = unit:GetAbsOrigin() + RandomVector( RandomFloat( 300, 450 ) )
            newItem:LaunchLoot( true, 300, 0.75, dropTarget )
            EmitSoundOn( "Dungeon.TreasureItemDrop", unit )
        end
    end
		
	-- Grant the unit gold
	unit:ModifyGold(current_bounty, false, DOTA_ModifyGold_Unspecified)

	-- Show the gold gained message to everyone
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, unit, current_bounty, nil)

	-- Play the gold gained sound
	EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "General.Coins", unit)

	-- Play the bounty rune activation sound to the unit's team
	EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Bounty", unit)
end

-- Gold bag pickup event function
function GoldPickup(event)
	if IsServer() then
		local item = EntIndexToHScript( event.ItemEntityIndex )
		local owner = EntIndexToHScript( event.HeroEntityIndex )
		local gold_per_bag = item:GetCurrentCharges()
		PlayerResource:ModifyGold( owner:GetPlayerID(), gold_per_bag, true, 0 )
		SendOverheadEventMessage( owner, OVERHEAD_ALERT_GOLD, owner, gold_per_bag, nil )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	end
end
	
-- Talents modifier function
function ApplyAllTalentModifiers()
	Timers:CreateTimer(0.1,function()
		local current_hero_list = HeroList:GetAllHeroes()
		for k,v in pairs(current_hero_list) do
			local hero_name = string.match(v:GetName(),"npc_dota_hero_(.*)")
			for i = 1, 8 do
				local talent_name = "special_bonus_imba_"..hero_name.."_"..i
				local modifier_name = "modifier_special_bonus_imba_"..hero_name.."_"..i
				if v:HasTalent(talent_name) and not v:HasModifier(modifier_name) then
					v:AddNewModifier(v,v,modifier_name,{})
				end
			end
		end
		return 0.5
	end)
end

function NetTableM(tablename,keyname,...) 
	local values = {...}                                                                  -- Our user input
	local returnvalues = {}                                                               -- table that will be unpacked for result                                                    
	for k,v in ipairs(values) do  
		local keyname = keyname..v[1]                                                       -- should be 1-8, but probably can be extrapolated later on to be any number
		if IsServer() then
			local netTableKey = netTableCmd(false,tablename,keyname)                              -- Command to grab our key set
			local my_key = createNetTableKey(v)                                               -- key = 250,444,111 as table, stored in key as 1 2 3
			if not netTableKey then                                                           -- No key with requested name exists
				netTableCmd(true,tablename,keyname,my_key)                                          -- create database key with "tablename","myHealth1","1=250,2=444,3=111"
			elseif type(netTableKey) == 'boolean' then                                        -- Our check returned that a key exists but that it is empty, we need to populate it for clients
				netTableCmd(true,tablename,keyname,my_key)                                          -- create database key with "tablename","myHealth1","1=250,2=444,3=111"
			else                                                                              -- Our key exists and we got some values, now we need to check the key against the requested value from other scripts  
				if #v > 1 then
					for i=1,#netTableKey do
						if netTableKey[i] ~= v[i-1] then                                              -- compare each value, does server 1 = our 250? does server 2 = our 444? 
							netTableCmd(true,tablename,keyname,my_key)                                      -- If our key is different from the sent value, rewrite it ONCE and break execution to main loop again
							break
						end
					end
				end
			end      
		end
		local allkeys = netTableCmd(false,tablename,keyname)
		if allkeys and type(allkeys) ~= 'boolean' then
			for i=1,#allkeys do
				table.insert(returnvalues, allkeys[i])    
			end
		else
			for i=1,#v do
				table.insert(returnvalues, 0)
			end
		end
	end
return unpack(returnvalues)
end

function netTableCmd(send,readtable,key,tabletosend)
	if send == false then
		local finalresulttable = {}
		local nettabletemp = CustomNetTables:GetTableValue(readtable,key)
		if not nettabletemp then return false end
		for key,value in pairs(nettabletemp) do
			table.insert(finalresulttable,value)
		end          
		if #finalresulttable > 0 then 
			return finalresulttable
		else
			return true
		end
	else
		CustomNetTables:SetTableValue(readtable, key, tabletosend)
	end
end

function createNetTableKey(v)
	local valuePair = {}
	if #v > 1 then
		for i=2,#v do
			table.insert(valuePair,v[i])                                              -- returns just numbers 2-x from sent value...
		end    
	end
	return valuePair  
end

function getkvValues(tEntity, ...) -- KV Values look hideous in finished code, so this function will parse through all sent KV's for tEntity (typically self)
	local values = {...}
	local data = {}
	for i,v in ipairs(values) do
		table.insert(data,tEntity:GetSpecialValueFor(v))
	end
	return unpack(data)
end

function TalentManager(tEntity, nameScheme, ...)
	local talents = {...}
	local return_values = {}
	for k,v in pairs(talents) do    
		if #v > 1 then
			for i=1,#v do
				table.insert(return_values, tEntity:FindSpecificTalentValue(nameScheme..v[1],v[i]))
			end
		else
			table.insert(return_values, tEntity:FindTalentValue(nameScheme..v[1]))
		end
	end    
return unpack(return_values)
end

function findtarget(source) -- simple list return function for finding a players current target entity
	local t = source:GetCursorTarget()
	local c = source:GetCaster()
	if t and c then return t,c end
end

function findgroundtarget(source) -- simple list return function for finding a players current target entity
	local t = source:GetCursorPosition()
	local c = source:GetCaster()
	if t and c then return t,c end
end

-- Controls comeback gold
function UpdateComebackBonus(points, team)

	-- Calculate both teams' networths
	local team_networth = {}
	team_networth[DOTA_TEAM_GOODGUYS] = 0
	team_networth[DOTA_TEAM_BADGUYS] = 0
	for player_id = 0, 19 do
		if PlayerResource:IsImbaPlayer(player_id) and PlayerResource:GetConnectionState(player_id) <= 2 and (not PlayerResource:GetHasAbandonedDueToLongDisconnect(player_id)) then
			team_networth[PlayerResource:GetTeam(player_id)] = team_networth[PlayerResource:GetTeam(player_id)] + PlayerResource:GetTotalEarnedGold(player_id)
		end
	end

	-- Update teams' score
	if COMEBACK_BOUNTY_SCORE[team] == nil then
		COMEBACK_BOUNTY_SCORE[team] = 0
	end
	
	COMEBACK_BOUNTY_SCORE[team] = COMEBACK_BOUNTY_SCORE[team] + points

	-- If one of the teams is eligible, apply the bonus
	if (COMEBACK_BOUNTY_SCORE[DOTA_TEAM_GOODGUYS] < COMEBACK_BOUNTY_SCORE[DOTA_TEAM_BADGUYS]) and (team_networth[DOTA_TEAM_GOODGUYS] < team_networth[DOTA_TEAM_BADGUYS]) then
		COMEBACK_BOUNTY_BONUS[DOTA_TEAM_GOODGUYS] = (COMEBACK_BOUNTY_SCORE[DOTA_TEAM_BADGUYS] - COMEBACK_BOUNTY_SCORE[DOTA_TEAM_GOODGUYS]) / ( COMEBACK_BOUNTY_SCORE[DOTA_TEAM_GOODGUYS] + 60 - GameRules:GetDOTATime(false, false) / 60 )
	elseif (COMEBACK_BOUNTY_SCORE[DOTA_TEAM_BADGUYS] < COMEBACK_BOUNTY_SCORE[DOTA_TEAM_GOODGUYS]) and (team_networth[DOTA_TEAM_BADGUYS] < team_networth[DOTA_TEAM_GOODGUYS]) then
		COMEBACK_BOUNTY_BONUS[DOTA_TEAM_BADGUYS] = (COMEBACK_BOUNTY_SCORE[DOTA_TEAM_GOODGUYS] - COMEBACK_BOUNTY_SCORE[DOTA_TEAM_BADGUYS]) / ( COMEBACK_BOUNTY_SCORE[DOTA_TEAM_BADGUYS] + 60 - GameRules:GetDOTATime(false, false) / 60 )
	end
end

-- Arena control point logic
function ArenaControlPointThinkRadiant(control_point)

	-- Create the control point particle, if this is the first iteration
	if not control_point.particle then
		control_point.particle = ParticleManager:CreateParticle("particles/customgames/capturepoints/cp_allied_wind.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(control_point.particle, 0, control_point:GetAbsOrigin())
	end

	-- Check how many heroes are near the control point
	local allied_heroes = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, control_point:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	local enemy_heroes = FindUnitsInRadius(DOTA_TEAM_BADGUYS, control_point:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	local score_change = #allied_heroes - #enemy_heroes

	-- Calculate the new score
	local old_score = control_point.score
	control_point.score = math.max(math.min(control_point.score + score_change, 20), -20)

	-- If this control point changed disposition, update the UI and particle accordingly
	if old_score >= 0 and control_point.score < 0 then
		CustomGameEventManager:Send_ServerToAllClients("radiant_point_to_dire", {})
		ParticleManager:DestroyParticle(control_point.particle, true)
		control_point.particle = ParticleManager:CreateParticle("particles/customgames/capturepoints/cp_wind_captured.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(control_point.particle, 0, control_point:GetAbsOrigin())
		control_point:EmitSound("Imba.ControlPointTaken")
	elseif old_score < 0 and control_point.score >= 0 then
		CustomGameEventManager:Send_ServerToAllClients("radiant_point_to_radiant", {})
		ParticleManager:DestroyParticle(control_point.particle, true)
		control_point.particle = ParticleManager:CreateParticle("particles/customgames/capturepoints/cp_allied_wind.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(control_point.particle, 0, control_point:GetAbsOrigin())
		control_point:EmitSound("Imba.ControlPointTaken")
	end

	-- Update the progress bar
	CustomNetTables:SetTableValue("arena_capture", "radiant_progress", {control_point.score})
	CustomGameEventManager:Send_ServerToAllClients("radiant_progress_update", {})

	-- Run this function again after a second
	Timers:CreateTimer(1, function()
		ArenaControlPointThinkRadiant(control_point)
	end)
end

function ArenaControlPointThinkDire(control_point)

	-- Create the control point particle, if this is the first iteration
	if not control_point.particle then
		control_point.particle = ParticleManager:CreateParticle("particles/customgames/capturepoints/cp_metal_captured.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(control_point.particle, 0, control_point:GetAbsOrigin())
	end

	-- Check how many heroes are near the control point
	local allied_heroes = FindUnitsInRadius(DOTA_TEAM_BADGUYS, control_point:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	local enemy_heroes = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, control_point:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	local score_change = #allied_heroes - #enemy_heroes

	-- Calculate the new score
	local old_score = control_point.score
	control_point.score = math.max(math.min(control_point.score + score_change, 20), -20)

	-- If this control point changed disposition, update the UI and particle accordingly
	if old_score >= 0 and control_point.score < 0 then
		CustomGameEventManager:Send_ServerToAllClients("dire_point_to_radiant", {})
		ParticleManager:DestroyParticle(control_point.particle, true)
		control_point.particle = ParticleManager:CreateParticle("particles/customgames/capturepoints/cp_allied_metal.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(control_point.particle, 0, control_point:GetAbsOrigin())
		control_point:EmitSound("Imba.ControlPointTaken")
	elseif old_score < 0 and control_point.score >= 0 then
		CustomGameEventManager:Send_ServerToAllClients("dire_point_to_dire", {})
		ParticleManager:DestroyParticle(control_point.particle, true)
		control_point.particle = ParticleManager:CreateParticle("particles/customgames/capturepoints/cp_metal_captured.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(control_point.particle, 0, control_point:GetAbsOrigin())
		control_point:EmitSound("Imba.ControlPointTaken")
	end

	-- Update the progress bar
	CustomNetTables:SetTableValue("arena_capture", "dire_progress", {control_point.score})
	CustomGameEventManager:Send_ServerToAllClients("dire_progress_update", {})

	-- Run this function again after a second
	Timers:CreateTimer(1, function()
		ArenaControlPointThinkDire(control_point)
	end)
end

function ArenaControlPointScoreThink(radiant_cp, dire_cp)

	-- Fetch current scores
	local radiant_score = CustomNetTables:GetTableValue("arena_capture", "radiant_score")
	local dire_score = CustomNetTables:GetTableValue("arena_capture", "dire_score")

	-- Update scores
	if radiant_cp.score >= 0 then
		radiant_score["1"] = radiant_score["1"] + 1
	else
		dire_score["1"] = dire_score["1"] + 1
	end
	if dire_cp.score >= 0 then
		dire_score["1"] = dire_score["1"] + 1
	else
		radiant_score["1"] = radiant_score["1"] + 1
	end

	-- Set new values
	CustomNetTables:SetTableValue("arena_capture", "radiant_score", {radiant_score["1"]})
	CustomNetTables:SetTableValue("arena_capture", "dire_score", {dire_score["1"]})

	-- Update scoreboard
	CustomGameEventManager:Send_ServerToAllClients("radiant_score_update", {})
	CustomGameEventManager:Send_ServerToAllClients("dire_score_update", {})

	-- Check if one of the teams won the game
	if radiant_score["1"] >= KILLS_TO_END_GAME_FOR_TEAM then
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
		GAME_WINNER_TEAM = "Radiant"
	elseif dire_score["1"] >= KILLS_TO_END_GAME_FOR_TEAM then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		GAME_WINNER_TEAM = "Dire"
	end

	-- Call this function again after 10 seconds
	Timers:CreateTimer(10, function()
		ArenaControlPointScoreThink(radiant_cp, dire_cp)
	end)
end

-------------------------------------------------------------------------------------------------------
-- Client side daytime tracking system
-------------------------------------------------------------------------------------------------------

function StoreCurrentDayCycle()	
	Timers:CreateTimer(function()		

		-- Get current daytime cycle
		local is_day = GameRules:IsDaytime()		

		-- Set in the table
		CustomNetTables:SetTableValue("gamerules", "isdaytime", {is_day = is_day} )		

	-- Repeat
	return 0.5
	end)	
end

function IsDaytime()
    if CustomNetTables:GetTableValue("gamerules", "isdaytime") then
        if CustomNetTables:GetTableValue("gamerules", "isdaytime").is_day then  
            local is_day = CustomNetTables:GetTableValue("gamerules", "isdaytime").is_day  

            if is_day == 1 then
                return true
            else
                return false
            end
        end
    end

    return true   
end


-- COOKIES: PreGame Chat System, created by Mahou Shoujo
Chat = Chat or class({})

function Chat:constructor(players, users, teamColors)
	self.players = players
	self.teamColors = TEAM_COLORS
	self.users = users

	CustomGameEventManager:RegisterListener("custom_chat_say", function(id, ...) Dynamic_Wrap(self, "OnSay")(self, ...) end)
	print("CHAT: constructing...")
end

function Chat:OnSay(args)
	local id = args.PlayerID
	local message = args.message
	local player = PlayerResource:GetPlayer(id)

	message = message:gsub("^%s*(.-)%s*$", "%1") -- Whitespace trim
	message = message:gsub("^(.{0,256})", "%1") -- Limit string length

	if message:len() == 0 then
		return
	end

	local arguments = {
		hero = player,
		color = TEAM_COLORS[player:GetPlayerID()],
		player = id,
		message = args.message,
		team = args.team,
--		IsFiretoad = player:IsFireToad() -- COOKIES: Define this function later, can also be used for all devs
	}

	if args.team then
		CustomGameEventManager:Send_ServerToTeam(player:GetTeamNumber(), "custom_chat_say", arguments)
--	else -- i leave this here if someday we want to create a whole new chat, and not only a pregame chat
--		CustomGameEventManager:Send_ServerToAllClients("custom_chat_say", arguments)
	end
end

function Chat:PlayerRandomed(id, hero, teamLocal, name)
	local hero = PlayerResource:GetPlayer(id)
	local shared = {
		color = TEAM_COLORS[hero:GetPlayerID()],
		player = id,
--		IsFiretoad = player:IsFireToad()
	}

	local localArgs = vlua.clone(shared)
	localArgs.hero = hero
	localArgs.team = teamLocal
	localArgs.name = name

	CustomGameEventManager:Send_ServerToAllClients("custom_randomed_message", localArgs)
end

function SystemMessage(token, vars)
	CustomGameEventManager:Send_ServerToAllClients("custom_system_message", { token = token or "", vars = vars or {}})
end

-- This function is responsible for cleaning dummy units and wisps that may have accumulated
function StartGarbageCollector()	
print("started collector")

	-- Find all dummy units in the game
	local dummies = FindUnitsInRadius(DOTA_TEAM_BADGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)		

	-- Cycle each dummy. If it is alive for more than 1 minute, delete it.
	local gametime = GameRules:GetGameTime()
	for _, dummy in pairs(dummies) do
		if dummy:GetUnitName() == "npc_dummy_unit" then			
			local dummy_creation_time = dummy:GetCreationTime()
			if gametime - dummy_creation_time > 60 then
				print("NUKING A LOST DUMMY!")
				UTIL_Remove(dummy)
			else
				print("dummy is still kinda new. Not removing it!")
			end
		end
	end

--	local particle_removed = 0

--	for _, particle in pairs(PARTICLE_TABLE) do
--		print("Particle:", particle)
--		print("Amount:", gametime - particle.lifetime)

--		if gametime - particle.lifetime > 0 then
--			if particle then
--				particle_removed = particle_removed +1
--				table.remove(PARTICLE_TABLE, particle.name)
--			end
--		end
--	end

--	for i = 1, #PARTICLE_TABLE do
--		if manager == PARTICLE_TABLE[i] then
--			particle_removed = particle_removed+1		
--			table.remove(PARTICLE_TABLE, i)
--			break
--		end
--	end

--	if particle_removed > 0 then
--		print("Removed "..particle_removed.." particle.")			
--	end
end

-- This function is responsible for deciding which team is behind, if any, and store it at a nettable.
function DefineLosingTeam()
-- Losing team is defined as a team that is both behind in both the sums of networth and levels.
local radiant_networth = 0
local radiant_levels = 0
local dire_networth = 0
local dire_levels = 0

	for i = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:IsValidPlayer(i) then

			-- Only count connected players or bots
			if PlayerResource:GetConnectionState(i) == 1 or PlayerResource:GetConnectionState(i) == 2 then

			-- Get player
			local player = PlayerResource:GetPlayer(i)
			
				if player then				
					-- Get team
					local team = player:GetTeam()				

					-- Get level, add it to the sum
					local level = player:GetAssignedHero():GetLevel()				

					-- Get networth
					local hero_networth = 0
					for i = 0, 8 do
						local item = player:GetAssignedHero():GetItemInSlot(i)
						if item then
							hero_networth = hero_networth + GetItemCost(item:GetName())						
						end
					end

					-- Add to the relevant team
					if team == DOTA_TEAM_GOODGUYS then					
						radiant_networth = radiant_networth + hero_networth					
						radiant_levels = radiant_levels + level					
					else					
						dire_networth = dire_networth + hero_networth					
						dire_levels = dire_levels + level					
					end				
				end
			end
		end
	end	

	-- Check for the losing team. A team must be behind in both levels and networth.
	if (radiant_networth < dire_networth) and (radiant_levels < dire_levels) then
		-- Radiant is losing		
		CustomNetTables:SetTableValue("gamerules", "losing_team", {losing_team = DOTA_TEAM_GOODGUYS})

	elseif (radiant_networth > dire_networth) and (radiant_levels > dire_levels) then
		-- Dire is losing		
		CustomNetTables:SetTableValue("gamerules", "losing_team", {losing_team = DOTA_TEAM_BADGUYS})

	else -- No team is losing - one of the team is better on levels, the other on gold. No experience bonus in this case		
		CustomNetTables:SetTableValue("gamerules", "losing_team", {losing_team = 0})		
	end
end

hero_particles = {}
hero_particles[0] = 0
hero_particles[1] = 0
hero_particles[2] = 0
hero_particles[3] = 0
hero_particles[4] = 0
hero_particles[5] = 0
hero_particles[6] = 0
hero_particles[7] = 0
hero_particles[8] = 0
hero_particles[9] = 0
hero_particles[10] = 0
hero_particles[11] = 0
hero_particles[12] = 0
hero_particles[13] = 0
hero_particles[14] = 0
hero_particles[15] = 0
hero_particles[16] = 0
hero_particles[17] = 0
hero_particles[18] = 0
hero_particles[19] = 0

total_hero_particles = {}
total_hero_particles[0] = 0
total_hero_particles[1] = 0
total_hero_particles[2] = 0
total_hero_particles[3] = 0
total_hero_particles[4] = 0
total_hero_particles[5] = 0
total_hero_particles[6] = 0
total_hero_particles[7] = 0
total_hero_particles[8] = 0
total_hero_particles[9] = 0
total_hero_particles[10] = 0
total_hero_particles[11] = 0
total_hero_particles[12] = 0
total_hero_particles[13] = 0
total_hero_particles[14] = 0
total_hero_particles[15] = 0
total_hero_particles[16] = 0
total_hero_particles[17] = 0
total_hero_particles[18] = 0
total_hero_particles[19] = 0

total_particles = 0
total_particles_created = 0
function OverrideCreateParticle()
	local CreateParticleFunc = ParticleManager.CreateParticle

	ParticleManager.CreateParticle = 
	function(manager, path, int, handle) 		 
		local particle = CreateParticleFunc(manager, path, int, handle)
		local time = GameRules:GetGameTime()

		manager.lifetime = time
		manager.name = path

--		print("Manager:", manager)
--		print("Manager Time:", manager.lifetime)
--		print("Path:", path)
--		print("Int:", int)
--		print("Handle:", handle)
--		print("------------------------")

		-- Index in a big, fat table. Only works in tools mode!
--		if IsInToolsMode() then
			PARTICLE_TABLE = PARTICLE_TABLE or {}
			table.insert(PARTICLE_TABLE, manager)
--		end

--		if path == "particles/units/heroes/hero_pudge/pudge_meathook.vpcf" then
--			print("HOOK!")
--			print("Manager:", manager)
--			print("Int:", int)
--			print("Handle:", handle)
--			return particle
--		end

		if handle and handle:IsRealHero() then
			if handle.pID then
--				print("Valid pID")
--				hero_particles[handle.pID] = hero_particles[handle.pID] +1 -- Need to filter ReleaseParticleIndex for hero to get only active particles
				total_hero_particles[handle.pID] = total_hero_particles[handle.pID] +1
			end
		else
--			print("non-Hero Handle:", handle)
		end

		total_particles = total_particles +1
		total_particles_created = total_particles_created +1

		return particle
	end
end

function OverrideCreateLinearProjectile()
    local CreateProjectileFunc = ProjectileManager.CreateLinearProjectile

    ProjectileManager.CreateProjectileFunc = 
    function(manager, handle)                  

        -- Do things here to override

        return CreateProjectileFunc(manager, handle)
    end
end

function OverrideReleaseIndex()
local ReleaseIndexFunc = ParticleManager.ReleaseParticleIndex
local released_particles = 0

	ParticleManager.ReleaseParticleIndex = 
	function(manager, int)		
		-- Find handle in table
--		print(#PARTICLE_TABLE)
		for i = 1, #PARTICLE_TABLE do
			if manager == PARTICLE_TABLE[i] then
				released_particles = released_particles+1		
				table.remove(PARTICLE_TABLE, i)
				break
			end
		end

		-- Release normally
		total_particles = total_particles -1
		ReleaseIndexFunc(manager, int)
	end
--	print("Released "..released_particles.." particles.")
end

function PrintParticleTable()
	PrintTable(PARTICLE_TABLE)	
end

-- Creator: Cookies [Earth Salamander]
function ImbaNetGraph(tick)
	Timers:CreateTimer(function()
		local units = FindUnitsInRadius(DOTA_TEAM_BADGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)		
		local good_unit_count = 0
		local bad_unit_count = 0
		local dummy_count = 0

		for _, unit in pairs(units) do
			if unit:GetTeamNumber() == 2 then
				good_unit_count = good_unit_count +1
			elseif unit:GetTeamNumber() == 3 then
				bad_unit_count = bad_unit_count +1
			end
			if unit:GetUnitName() == "npc_dummy_unit" or unit:GetUnitName() == "npc_dummy_unit_perma" then			
				dummy_count = dummy_count +1
			end
		end

		CustomNetTables:SetTableValue("netgraph", "good_unit_number", {value = good_unit_count})
		CustomNetTables:SetTableValue("netgraph", "bad_unit_number", {value = bad_unit_count})
		CustomNetTables:SetTableValue("netgraph", "total_unit_number", {value = #units})
		CustomNetTables:SetTableValue("netgraph", "total_dummy_number", {value = dummy_count})
		CustomNetTables:SetTableValue("netgraph", "total_dummy_created_number", {value = dummy_created_count})
		CustomNetTables:SetTableValue("netgraph", "total_particle_number", {value = total_particles})
		CustomNetTables:SetTableValue("netgraph", "total_particle_created_number", {value = total_particles_created})

--		for i = 1, PlayerResource:GetPlayerCount() do
		for i = 1, 20 do
			CustomNetTables:SetTableValue("netgraph", "hero_particle_"..i-1, {particle = hero_particles[i-1], pID = i-1})
			CustomNetTables:SetTableValue("netgraph", "hero_total_particle_"..i-1, {particle = total_hero_particles[i-1], pID = i-1})
		end
		CustomGameEventManager:RegisterListener("remove_units", RemoveUnits)
	return tick
	end)
end
