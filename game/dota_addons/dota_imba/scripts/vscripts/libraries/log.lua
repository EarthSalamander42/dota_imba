-- Copyright (c) 2018  The Dota IMBA Development Team
-- Licensed under the terms of the Apache 2.0 License

log = {
	}


if Log == nil then
	Log = {
		Levels = {
			TRACE = 1,
			DEBUG = 2,
			INFO = 3,
			WARN = 4,
			CRITICAL = 5,
			ERROR = 6,
			FATAL = 7
		}
	}
end

-- Utility
function Log:_LevelToString(lvl)
	if lvl == 1 then return "trace"
	elseif lvl == 2 then return "debug"
	elseif lvl == 3 then return "info "
	elseif lvl == 4 then return "warn "
	elseif lvl == 5 then return "crit "
	elseif lvl == 6 then return "error"
	elseif lvl == 7 then return "fatal"
	else return "invld" end
end

function Log:_LinesSplit(str)
	local t = {}
	local function helper(line)
		table.insert(t, line)
		return ""
	end
	helper((str:gsub("(.-)\r?\n", helper)))
	return t
end

function Log:_StringSplit(str, pat)
	local t = {}  -- NOTE: use {n = 0} in Lua-5.0
	local fpat = "(.-)" .. pat
	local last_end = 1
	local s, e, cap = str:find(fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(t,cap)
		end
		last_end = e+1
		s, e, cap = str:find(fpat, last_end)
	end
	if last_end <= #str then
		cap = str:sub(last_end)
		table.insert(t, cap)
	end
	return t
end

function Log:_Trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function Log:_PrintTable(node)
	-- to make output beautiful
	local function tab(amt)
		local str = ""
		for i=1,amt do
			str = str .. "  "
		end
		return str
	end

	local cache, stack, output = {},{},{}
	local depth = 1
	local output_str = "{\n"

	while true do
		local size = 0
		for k,v in pairs(node) do
			size = size + 1
		end

		local cur_index = 1
		for k,v in pairs(node) do
			if (cache[node] == nil) or (cur_index >= cache[node]) then

				if (string.find(output_str,"}",output_str:len())) then
					output_str = output_str .. ",\n"
				elseif not (string.find(output_str,"\n",output_str:len())) then
					output_str = output_str .. "\n"
				end

				-- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
				table.insert(output,output_str)
				output_str = ""

				local key
				if (type(k) == "number" or type(k) == "boolean") then
					key = "["..tostring(k).."]"
				else
					key = "['"..tostring(k).."']"
				end

				if (type(v) == "number" or type(v) == "boolean") then
					output_str = output_str .. tab(depth) .. key .. " = "..tostring(v)
				elseif (type(v) == "table") then
					output_str = output_str .. tab(depth) .. key .. " = {\n"
					table.insert(stack,node)
					table.insert(stack,v)
					cache[node] = cur_index+1
					break
				else
					output_str = output_str .. tab(depth) .. key .. " = '"..tostring(v).."'"
				end

				if (cur_index == size) then
					output_str = output_str .. "\n" .. tab(depth-1) .. "}"
				else
					output_str = output_str .. ","
				end
			else
				-- close the table
				if (cur_index == size) then
					output_str = output_str .. "\n" .. tab(depth-1) .. "}"
				end
			end

			cur_index = cur_index + 1
		end

		if (size == 0) then
			output_str = output_str .. "\n" .. tab(depth-1) .. "}"
		end

		if (#stack > 0) then
			node = stack[#stack]
			stack[#stack] = nil
			depth = cache[node] == nil and depth + 1 or depth - 1
		else
			break
		end
	end

	-- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
	table.insert(output,output_str)
	output_str = table.concat(output)

	return output_str
end

-- Print function
function Log:Print(obj, level)

	-- prepare stack trace
	local trace = self:_LinesSplit(debug.traceback(nil, 3));
	table.remove(trace, 1)

	-- prepare level
	local levelString = self:_LevelToString(level)


	local fun = self:_StringSplit(trace[1], ":")
	local file = "??"
	local line = "??"
	local context = "??"
	if fun[1] ~= nil then
		file = self:_Trim(fun[1])
		table.remove(fun, 1)
	end
	if fun[1] ~= nil then
		line = self:_Trim(fun[1])
		table.remove(fun, 1)
	end

	if fun[1] ~= nil then
		context = self:_Trim(table.concat(fun, ":"))
	end

	local prefix = "[" .. levelString .. "][" .. file .. ":" .. line .. "][" .. context .. "] "

	-- show
	if (type(obj) == "table") then
		local table = self:_LinesSplit(self:_PrintTable(obj));
		for _, v in pairs(table) do
			print(prefix .. v)
		end
	elseif (type(obj) == "string") then
		print(prefix .. obj)
	elseif (type(obj) == "number") then
		print(prefix .. tostring(obj))
	end

	--print(self:_PrintTable(trace))
end

function Log:ExecuteInSafeContext(fun)
	local status, err = xpcall(fun, function (err)
		if err == nil then
			err = "Unknown Error"
		end
		self:Print("Error occured while executing in safe context: " .. err, Log.Levels.ERROR)
	end)

	return status
end

function Log:Configure(config)
	self.config = config;
end

function log.trace(obj) Log:Print(obj, Log.Levels.TRACE) end
function log.debug(obj) Log:Print(obj, Log.Levels.DEBUG) end
function log.info(obj) Log:Print(obj, Log.Levels.INFO) end
function log.warn(obj) Log:Print(obj, Log.Levels.WARN) end
function log.warning(obj) Log:Print(obj, Log.Levels.WARN) end
function log.critical(obj) Log:Print(obj, Log.Levels.CRITICAL) end
function log.crit(obj) Log:Print(obj, Log.Levels.CRITICAL) end
function log.error(obj) Log:Print(obj, Log.Levels.ERROR) end
function log.fatal(obj) Log:Print(obj, Log.Levels.FATAL) end

function safe(fun)
	return Log:ExecuteInSafeContext(fun)
end

