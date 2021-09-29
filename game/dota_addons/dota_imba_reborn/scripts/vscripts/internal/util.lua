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

function MergeTables( t1, t2 )
	for name,info in pairs(t2) do
		t1[name] = info
	end
end

function DebugAllCalls()
	if not GameRules.DebugCalls then
		print("Starting DebugCalls")
		GameRules.DebugCalls = true

		debug.sethook(function(...)
				local info = debug.getinfo(2)
				local src = tostring(info.short_src)
				local name = tostring(info.name)
				if name ~= "__index" then
						print("Call: ".. src .. " -- " .. name .. " -- " .. info.currentline)
				end
		end, "c")
	else
		print("Stopped DebugCalls")
		GameRules.DebugCalls = false
		debug.sethook(nil, "c")
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
