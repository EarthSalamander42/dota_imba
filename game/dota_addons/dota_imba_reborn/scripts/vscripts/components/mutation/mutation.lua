local validItems = {} -- Empty table to fill with full list of valid airdrop items
Mutation.tier1 = {} -- 1000 to 2000 gold cost up to 5 minutes
Mutation.tier2 = {} -- 2000 to 3500 gold cost up to 10 minutes
Mutation.tier3 = {} -- 3500 to 5000 gold cost up to 15 minutes
Mutation.tier4 = {} -- 5000 to 99998 gold cost beyond 15 minutes
local counter = 1 -- Slowly increments as time goes on to expand list of cost-valid items
local varFlag = 0 -- Flag to stop the repeat until loop for tier iterations

function Mutation:Airdrop()
	for k, v in pairs(KeyValues.ItemKV) do -- Go through all the items in KeyValues.ItemKV and store valid items in validItems table
		varFlag = 0 -- Let's borrow this memory to suss out the forbidden items first...

		local item_cost = v["ItemCost"]

		if item_cost then
			item_cost = tonumber(item_cost)
		end

		if item_cost and item_cost >= IMBA_MUTATION_AIRDROP_ITEM_MINIMUM_GOLD_COST and item_cost ~= 99999 and not string.find(k, "recipe") and not string.find(k, "cheese") then
			for _, item in pairs(IMBA_MUTATION_RESTRICTED_ITEMS) do -- Make sure item isn't a restricted item
				if k == item then
					varFlag = 1
				end
			end

			if varFlag == 0 then -- If not a restricted item (while still meeting all the other criteria...)
				validItems[#validItems + 1] = {k = k, v = item_cost}
			end	
		end
	end

	table.sort(validItems, function(a, b) return a.v < b.v end) -- Sort by ascending item cost for easier retrieval later on

	--[[
	print("Table length: ", #validItems) -- # of valid items
				
	for a, b in pairs(validItems) do
		print(a)
		for key, value in pairs(b) do
			print('\t', key, value)
		end
	end	
	]]--

	varFlag = 0

	-- Create Tier 1 Table
	repeat
		if validItems[counter].v <= IMBA_MUTATION_AIRDROP_ITEM_TIER_1_GOLD_COST then
			Mutation.tier1[#Mutation.tier1 + 1] = {k = validItems[counter].k, v = validItems[counter].v}
			counter = counter + 1
		else
			varFlag = 1
		end
	until varFlag == 1

	varFlag = 0

	-- Create Tier 2 Table
	repeat
		if validItems[counter].v <= IMBA_MUTATION_AIRDROP_ITEM_TIER_2_GOLD_COST then
			Mutation.tier2[#Mutation.tier2 + 1] = {k = validItems[counter].k, v = validItems[counter].v}
			counter = counter + 1
		else
			varFlag = 1
		end
	until varFlag == 1

	varFlag = 0

	-- Create Tier 3 Table
	repeat
		if validItems[counter].v <= IMBA_MUTATION_AIRDROP_ITEM_TIER_3_GOLD_COST then
			Mutation.tier3[#Mutation.tier3 + 1] = {k = validItems[counter].k, v = validItems[counter].v}
			counter = counter + 1
		else
			varFlag = 1
		end
	until varFlag == 1

	varFlag = 0

	-- Create Tier 4 Table
	for num = counter, #validItems do
		Mutation.tier4[#Mutation.tier4 + 1] = {k = validItems[num].k, v = validItems[num].v}
	end

	varFlag = 0

	--[[
	print("TIER 1 LIST")
	
	for a, b in pairs(Mutation.tier1) do
		print(a)
		for key, value in pairs(b) do
			print('\t', key, value)
		end
	end	
			
	print("TIER 2 LIST")
	
	for a, b in pairs(Mutation.tier2) do
		print(a)
		for key, value in pairs(b) do
			print('\t', key, value)
		end
	end	
	
	print("TIER 3 LIST")
	
	for a, b in pairs(Mutation.tier3) do
		print(a)
		for key, value in pairs(b) do
			print('\t', key, value)
		end
	end	
	
	print("TIER 4 LIST")
	
	for a, b in pairs(Mutation.tier4) do
		print(a)
		for key, value in pairs(b) do
			print('\t', key, value)
		end
	end	
	]]--

	Timers:CreateTimer(110.0, function()
		Mutation:SpawnRandomItem()

		return 120.0
	end)
end

function Mutation:DangerZone()
	local dummy_unit = CreateUnitByName("npc_dummy_unit_perma", Vector(0, 0, 0), true, nil, nil, DOTA_TEAM_NEUTRALS)
	dummy_unit:AddNewModifier(dummy_unit, nil, "modifier_mutation_danger_zone", {})
end

function Mutation:PeriodicSpellcast()
	local buildings = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, 20000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	local good_fountain = nil
	local bad_fountain = nil

	for _, building in pairs(buildings) do
		local building_name = building:GetName()
		if string.find(building_name, "ent_dota_fountain_bad") then
			bad_fountain = building
		elseif string.find(building_name, "ent_dota_fountain_good") then
			good_fountain = building
		end
	end

	local random_int
	local counter = 0 -- Used to alternate between negative and positive spellcasts, and increments after each timer call
	local varSwap -- Switches between 1 and 2 based on counter for negative and positive spellcasts
	local caster

	-- initialize to negative
	CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["negative"], {0})

	Timers:CreateTimer(55.0, function()
		varSwap = (counter % 2) + 1
		random_int = RandomInt(1, #IMBA_MUTATION_PERIODIC_SPELLS[varSwap])
		Notifications:TopToAll({text = IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][2].." Mutation in 5 seconds...", duration = 5.0, style = {color = IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][3]}})

		return 60.0
	end)

	Timers:CreateTimer(60.0, function()
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["negative"], {varSwap})
		if bad_fountain == nil or good_fountain == nil then
			print("nao cucekd up!!! ")
			return 60.0 
		end

		for _, hero in pairs(HeroList:GetAllHeroes()) do
			if (hero:GetTeamNumber() == 3 and IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][3] == "Red") or (hero:GetTeamNumber() == 2 and IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][3] == "Green") then
				caster = good_fountain
			else
			    caster = bad_fountain
			end

			hero:AddNewModifier(caster, caster, "modifier_mutation_"..IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][1], {duration=IMBA_MUTATION_PERIODIC_SPELLS[varSwap][random_int][4]})
		end

		counter = counter + 1

		return 60.0
	end)
end

function Mutation:Minefield()
	local mines = {
		"npc_imba_techies_land_mines",
		"npc_imba_techies_land_mines_big_boom",
		"npc_imba_techies_stasis_trap",
	}

	Timers:CreateTimer(function()
		local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)		
		local mine_count = 0
		local max_mine_count = 75

		for _, unit in pairs(units) do
			if unit:GetUnitName() == "npc_imba_techies_land_mines" or unit:GetUnitName() == "npc_imba_techies_land_mines_big_boom" or unit:GetUnitName() == "npc_imba_techies_stasis_trap" then			
				if unit:GetUnitName() == "npc_imba_techies_land_mines" then
					unit:FindAbilityByName("imba_techies_land_mines_trigger"):SetLevel(RandomInt(1, 4))
				elseif unit:GetUnitName() == "npc_imba_techies_land_mines_big_boom" then
					unit:FindAbilityByName("imba_techies_land_mines_trigger"):SetLevel(RandomInt(1, 4))
				elseif unit:GetUnitName() == "npc_imba_techies_stasis_trap" then
					unit:FindAbilityByName("imba_techies_stasis_trap_trigger"):SetLevel(RandomInt(1, 4))
				end

				mine_count = mine_count + 1
			end
		end

		if mine_count < max_mine_count then
			for i = 1, 10 do
				local mine = CreateUnitByName(mines[RandomInt(1, #mines)], RandomVector(IMBA_MUTATION_MINEFIELD_MAP_SIZE), true, nil, nil, DOTA_TEAM_NEUTRALS)
				mine:AddNewModifier(mine, nil, "modifier_invulnerable", {})
			end
		end

--		print("Mine count:", mine_count)
		return 10.0
	end)
end

function Mutation:NoTrees()
	GameRules:SetTreeRegrowTime(99999)
	GridNav:DestroyTreesAroundPoint(Vector(0, 0, 0), 50000, false)
	Mutation:RevealAllMap(1.0)
end

function Mutation:TugOfWar()
	local golem

	-- Random a team for the initial golem spawn
	if RandomInt(1, 2) == 1 then
		golem = CreateUnitByName("npc_dota_mutation_golem", IMBA_MUTATION_TUG_OF_WAR_START[DOTA_TEAM_GOODGUYS], false, nil, nil, DOTA_TEAM_GOODGUYS)
		golem.ambient_pfx = ParticleManager:CreateParticle("particles/ambient/tug_of_war_team_radiant.vpcf", PATTACH_ABSORIGIN_FOLLOW, golem)
		ParticleManager:SetParticleControl(golem.ambient_pfx, 0, golem:GetAbsOrigin())
		Timers:CreateTimer(0.1, function()
			golem:MoveToPositionAggressive(IMBA_MUTATION_TUG_OF_WAR_TARGET[DOTA_TEAM_GOODGUYS])
		end)
	else
		golem = CreateUnitByName("npc_dota_mutation_golem", IMBA_MUTATION_TUG_OF_WAR_START[DOTA_TEAM_BADGUYS], false, nil, nil, DOTA_TEAM_BADGUYS)
		golem.ambient_pfx = ParticleManager:CreateParticle("particles/ambient/tug_of_war_team_dire.vpcf", PATTACH_ABSORIGIN_FOLLOW, golem)
		ParticleManager:SetParticleControl(golem.ambient_pfx, 0, golem:GetAbsOrigin())
		Timers:CreateTimer(0.1, function()
			golem:MoveToPositionAggressive(IMBA_MUTATION_TUG_OF_WAR_TARGET[DOTA_TEAM_BADGUYS])
		end)
	end

	-- Initial logic
	golem:AddNewModifier(golem, nil, "modifier_mutation_tug_of_war_golem", {}):SetStackCount(1)
	FindClearSpaceForUnit(golem, golem:GetAbsOrigin(), true)
	golem:SetDeathXP(50)
	golem:SetMinimumGoldBounty(50)
	golem:SetMaximumGoldBounty(50)
end

function Mutation:Wormhole()
	-- Assign initial wormhole positions
	local current_wormholes = {}

	for i = 1, 12 do
		local random_int = RandomInt(1, #IMBA_MUTATION_WORMHOLE_POSITIONS)
		current_wormholes[i] = IMBA_MUTATION_WORMHOLE_POSITIONS[random_int]
		table.remove(IMBA_MUTATION_WORMHOLE_POSITIONS, random_int)
	end

	-- Create wormhole particles (destroy and redraw every minute to accommodate for reconnecting players)
	local wormhole_particles = {}

	Timers:CreateTimer(function()
		for i = 1, 12 do
			if wormhole_particles[i] then
				ParticleManager:DestroyParticle(wormhole_particles[i], true)
				ParticleManager:ReleaseParticleIndex(wormhole_particles[i])
			end
			wormhole_particles[i] = ParticleManager:CreateParticle("particles/ambient/wormhole_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(wormhole_particles[i], 0, GetGroundPosition(current_wormholes[i], nil) + Vector(0, 0, 20))
			ParticleManager:SetParticleControl(wormhole_particles[i], 2, IMBA_MUTATION_WORMHOLE_COLORS[i])
		end
		return 60
	end)

	-- Teleport loop
	Timers:CreateTimer(function()
		-- Find units to teleport
		for i = 1, 12 do
			local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, current_wormholes[i], nil, 150, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)
			for _, unit in pairs(units) do
				if not unit:HasModifier("modifier_mutation_wormhole_cooldown") then
					if unit:IsHero() then
						unit:EmitSound("Wormhole.Disappear")
						Timers:CreateTimer(0.03, function()
							unit:EmitSound("Wormhole.Appear")
						end)
					else
						unit:EmitSound("Wormhole.CreepDisappear")
						Timers:CreateTimer(0.03, function()
							unit:EmitSound("Wormhole.CreepAppear")
						end)
					end
					unit:AddNewModifier(unit, nil, "modifier_mutation_wormhole_cooldown", {duration = IMBA_MUTATION_WORMHOLE_PREVENT_DURATION})
					FindClearSpaceForUnit(unit, current_wormholes[13-i], true)
					if unit.GetPlayerID and unit:GetPlayerID() then
						unit:CenterCameraOnEntity(unit)
					end
				end
			end
		end

		return 0.5
	end)
end
