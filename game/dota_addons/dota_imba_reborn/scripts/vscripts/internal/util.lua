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

-- Map utils
function MapRanked5v5() return "imba_ranked_5v5" end
function MapRanked10v10() return "imba_ranked_10v10" end
function MapMutation5v5() return "imba_mutation_5v5" end
function MapMutation10v10() return "imba_mutation_10v10" end
function MapTournament() return "imba_tournament" end

function IsRankedMap()
	if GetMapName() == MapRanked5v5() or GetMapName() == MapRanked10v10() then
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

function IsMutationMap()
	if GetMapName() == MapMutation5v5() or GetMapName() == MapMutation10v10() then
		return true
	end

	return false
end

-- hero utils

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

-- Copy shallow copy given input
function ShallowCopy(orig)
	local copy = {}
	for orig_key, orig_value in pairs(orig) do
		copy[orig_key] = orig_value
	end
	return copy
end
