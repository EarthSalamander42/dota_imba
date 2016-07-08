function spairs(t, order, count)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return t[a] < t[b] end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
		if(i <= count) then
			if keys[i] then
				return keys[i], t[keys[i]]
			end
		end
    end
end
