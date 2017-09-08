STAT_UTILITIES_VERSION = "0.2"

------------------------------
-- Player Functions    --
------------------------------

function GetHeroName(playerID)
	local heroName = PlayerResource:GetSelectedHeroName(playerID)
	heroName = string.gsub(heroName, "npc_dota_hero_", "") --Cuts the npc_dota_hero_ prefix

	return heroName
end

function GetWinningHeroName(playerID)
	local winning_team = GAME_WINNER_TEAM

	-- Convert winning team. If no team has won (disconnect) the game winners will be "none".
	if winning_team == "Radiant" then
		winning_team = DOTA_TEAM_GOODGUYS
	elseif winning_team == "Dire" then
		winning_team = DOTA_TEAM_BADGUYS
	end    
	
	local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()
	if not hero then
		print("no hero found. Check passed player ID")
		return nil
	end

	-- Check winning team
	if hero:GetTeamNumber() == winning_team then
		local hero_name = PlayerResource:GetSelectedHeroName(playerID)
		hero_name = string.gsub(hero_name, "npc_dota_hero_", "") -- Removes the npc_dota_hero_ perfix
	else
		-- If it is not a hero that won, return an empty string
		return ""
	end
end

-- Not implented yet
function GetPickedTalents(playerID)
	local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()

	if not hero then
		print("no hero found. Check passed player ID")
		return nil
	end

	-- Get the partial hero name
	local hero_name = PlayerResource:GetSelectedHeroName(playerID)
	hero_name = string.gsub(hero_name, "npc_dota_hero_", "")

	-- Get talent partial names
	local talent_prefix = "special_bonus_imba_"..hero_name

	-- Get picked talents
	local picked_talents = {}
	for i = 1, 8 do
		print(talent_prefix.."_"..i)
		if hero:HasTalent(talent_prefix.."_"..i) then
			table.insert(picked_talents, talent_prefix.."_"..i)
		end
	end

	return picked_talents
end

-- Trying to find a better item storing
function GetItemSlot(hero, slot)
	local item = hero:GetItemInSlot(slot)
	local itemName = ""

	if item then
		itemName = string.gsub(item:GetAbilityName(), "item_", "")
	end

	return itemName
end

-- Trying to find a better item storing
function GetItemList(hero)
	local itemTable = {}

	for i = 0, 5 do
		local item = hero:GetItemInSlot(i)
		if item then
			local itemName = string.gsub(item:GetAbilityName(), "item_", "")
			table.insert(itemTable, itemName)
		end
	end

	table.sort(itemTable)
	local itemList = table.concat(itemTable, ",")

	return itemList
end

function GetGameLength()
local time = GameRules:GetDOTATime(false, false)
local minutes = time / 60

	if minutes < 1 then
		time = "0 minutes"
	elseif minutes >= 1 and minutes <= 5 then
		time = "0-5 minutes"
	elseif minutes > 5 and minutes <= 10 then
		time = "5-10 minutes"
	elseif minutes > 10 and minutes <= 15 then
		time = "10-15 minutes"
	elseif minutes > 15 and minutes <= 20 then
		time = "15-20 minutes"
	elseif minutes > 20 and minutes <= 25 then
		time = "20-25 minutes"
	elseif minutes > 25 and minutes <= 30 then
		time = "25-30 minutes"
	elseif minutes > 30 and minutes <= 35 then
		time = "30-35 minutes"
	elseif minutes > 35 and minutes <= 40 then
		time = "35-40 minutes"
	elseif minutes > 40 and minutes <= 45 then
		time = "40-45 minutes"
	elseif minutes > 45 and minutes <= 50 then
		time = "45-50 minutes"
	elseif minutes > 50 and minutes <= 55 then
		time = "50-55 minutes"
	elseif minutes > 55 and minutes <= 60 then
		time = "55-60 minutes"
	elseif minutes > 60 then
		time = "60+ minutes"
	end

	return time
end

function GetMode()
local mode = ""

	if mode == "" or IMBA_PICK_MODE_ALL_PICK then
		mode = "All Pick"
	elseif IMBA_PICK_MODE_ALL_RANDOM then
		mode = "All Random"
	elseif IMBA_PICK_MODE_ALL_RANDOM_SAME_HERO then
		mode = "All Random Same Hero"
	end

	return mode
end

function GetTowerUpgrades()
local mode = ""

	if mode == "" then
		mode = "Tower Upgrade: Off"
	elseif TOWER_UPGRADE_MODE then
		mode = "Tower Upgrade: On"
	end

	return mode
end
