-- Copyright (c) 2018  The Dota IMBA Development Team
-- Licensed under the terms of the Apache 2.0 License

log = {
	}


if Log == nil then

	Log = {
		Levels = {
			DEBUG = 1,
			INFO = 2,
			WARN = 3,
			CRITICAL = 4,
			ERROR = 5
		},
		targets = {}
	}

	Log.config = {
		{
			matcher = ".*",
			level = Log.Levels.WARN,
			targets = {
				"api",
				"console"
			}
		}, {
			matcher = ".*",
			level = Log.Levels.INFO,
			targets = {
				"console"
			}
		}
	}

end

---------------------------------------------
-- Utility
---------------------------------------------
function Log:_LevelToString(lvl)
	if lvl == 1 then return "debug"
	elseif lvl == 2 then return "info"
	elseif lvl == 3 then return "warn"
	elseif lvl == 4 then return "critical"
	elseif lvl == 5 then return "error"
	else return "invalid" end
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
			str = str .. "\t"
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
	return table.concat(output)
end

function Log:_IsFiltered(target, level, file)

	-- go over each rule
	for i = 1, #self.config do
		local rule = self.config[i]

		-- check if matcher matches
		if string.match(file, rule.matcher) then

			-- check if level is high enough for rule
			if level >= rule.level then

				-- see if the rule defines this target
				for j = 1, #rule.targets do
					if rule.targets[j] == target then
						return false
					end
				end
			end
		end
	end

	return true
end

function Log:_GetStackTrace(ptr)

	local trace = {}

	-- gather info
	while true do
		local i = debug.getinfo(ptr, "nSl")
		if i == nil or ptr > 20 then
			break
		end
		table.insert(trace, i)
		ptr = ptr + 1
	end

	return trace
end

function Log:_GetFileFromTrace(trace)
	if #trace < 1 then
		return ""
	else
		return trace[1]["short_src"]
	end
end

---------------------------------------------
-- Print function
-- which actually just prepares data and passes them to the configured targets
---------------------------------------------
function Log:Print(obj, level)

	-- prepare level
	local levelString = self:_LevelToString(level)

	local content = ""

	if type(obj) == table then
		content = self:_PrintTable(obj)
	else
		content = tostring(obj)
	end

	local trace = self:_GetStackTrace(4);
	local file = self:_GetFileFromTrace(trace)

	for i = 1, #self.targets do
		if not self:_IsFiltered(self.targets[i].name, level, file) then
			self.targets[i]:print(levelString, content, trace)
		end
	end

end

---------------------------------------------
-- Runs code in safe context: Catches exceptions
-- and logs errors
---------------------------------------------
function Log:ExecuteInSafeContext(fun)
	local status, err = xpcall(fun, function (err)

			if err == nil then
				err = "Unknown Error"
			end

			-- dont filter errors
			local levelString = self:_LevelToString(Log.Levels.ERROR)

			for i = 1, #self.targets do
				self.targets[i]:print(levelString, "Error occured while executing in safe context: " .. err, self:_GetStackTrace(4))
			end
	end)

	return status
end

---------------------------------------------
-- Configure the logger with a given config
---------------------------------------------
function Log:Configure(config)
	self.config = config;
end

---------------------------------------------
-- Load the logger config from api
---------------------------------------------
function Log:ConfigureFromApi()
	api.imba.load_logging_configuration(function (data)
		log.info("Loaded new Logging configuration from server")
		self.config = data.rules
	end)
end

---------------------------------------------
-- Add a logging target
---------------------------------------------
function Log:AddTarget(target)
	table.insert(self.targets, target)
end

---------------------------------------------
-- General purpose log shortcut functions
---------------------------------------------
function log.debug(obj) Log:Print(obj, Log.Levels.DEBUG) end
function log.info(obj) Log:Print(obj, Log.Levels.INFO) end
function log.warn(obj) Log:Print(obj, Log.Levels.WARN) end
function log.warning(obj) Log:Print(obj, Log.Levels.WARN) end
function log.critical(obj) Log:Print(obj, Log.Levels.CRITICAL) end
function log.crit(obj) Log:Print(obj, Log.Levels.CRITICAL) end
function log.error(obj) Log:Print(obj, Log.Levels.ERROR) end

---------------------------------------------
-- Safe shortcut
---------------------------------------------
function safe(fun)
	return Log:ExecuteInSafeContext(fun)
end

---------------------------------------------
-- Logger Targets
---------------------------------------------

ApiLogTarget = {
	name = "api"
}

function ApiLogTarget:print(level, content, trace)

	local data = {}
	table.insert(data, level)
	table.insert(data, content)
	for i = 1, #trace do
		table.insert(data, json.encode(trace[i]))
	end

	-- prepare api request
	api.imba.event(api.events.log, data, true)
end

ConsoleLogTarget = {
	name = "console"
}

function ConsoleLogTarget:print(level, content, trace)
	local name = ""
	if trace[1]["name"] ~= nil then
		name = "|" .. trace[1]["name"]
	end
	print("[" .. level .. "][" .. trace[1]["short_src"] .. ":" .. trace[1]["currentline"] .. name .. "] " .. content)
end

---------------------------------------------
-- Initialization
---------------------------------------------
Log:AddTarget(ApiLogTarget)
Log:AddTarget(ConsoleLogTarget)


