-- 
-- IMBA XP Level 
--

function imba_xp_get_level(xp_value) 
    -- function for xp level: 0.075 * x^0.66667
    return 0.075 * math.pow(xp_value, 0.6666667)
end

function imba_xp_get_title_by_level(level)
	if level <= 19 then
		return "Rookie"
	elseif level <= 39 then
		return "Amateur"
	elseif level <= 59 then
		return "Captain"
	elseif level <= 79 then
		return "Warrior"
	elseif level <= 99 then
		return "Commander"
	elseif level <= 119 then
		return "General"
	elseif level <= 139 then
		return "Master"
	elseif level <= 159 then
		return "Epic"
	elseif level <= 179 then
		return "Legendary"
	elseif level <= 199 then
		return "Ancient"
	elseif level <= 299 then
		return "Amphibian"..level-200
	elseif level <= 399 then
		return "Icefrog"..level-300
	else 
		return "Firetoad "..level-400
	end
end

function imba_xp_get_color_hexcode_by_level(level)
	if level <= 19 then
        return "#FFFFFF"
	elseif level <= 39 then
        return "#66CC00"
	elseif level <= 59 then
        return "#4C8BCA"
	elseif level <= 79 then
        return "#004C99"
	elseif level <= 99 then
        return "#985FD1"
	elseif level <= 119 then
        return "#460587"
	elseif level <= 139 then
        return "#FA5353"
	elseif level <= 159 then
        return "#8E0C0C"
	elseif level <= 179 then
        return "#EFBC14"
	elseif level <= 199 then
        return "#1456EF"
    else
        return "#C75102"
    end
end

function imba_xp_get_color_table_by_level(level)
	if level <= 19 then
        return {255, 255, 255}
	elseif level <= 39 then
        return {102, 204, 0}
	elseif level <= 59 then
        return {76, 139, 202}
	elseif level <= 79 then
        return {0, 76, 153}
	elseif level <= 99 then
        return {152, 95, 209}
	elseif level <= 119 then
        return {70, 5, 135}
	elseif level <= 139 then
        return {250, 83, 83}
	elseif level <= 159 then
        return {142, 12, 12}
	elseif level <= 179 then
        return {239, 188, 20}
	elseif level <= 199 then
        return {20, 86, 239}
    else
        return {199, 81, 2}
    end
end
