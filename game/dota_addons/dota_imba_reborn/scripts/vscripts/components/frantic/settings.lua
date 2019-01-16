IMBA_FRANTIC_VALUE = IMBA_SUPER_FRANTIC_VALUE

CustomNetTables:SetTableValue("game_options", "frantic_mode", {true})
CustomNetTables:SetTableValue("game_options", "frantic", {frantic = IMBA_BASE_FRANTIC_VALUE, super_frantic = IMBA_SUPER_FRANTIC_VALUE})
