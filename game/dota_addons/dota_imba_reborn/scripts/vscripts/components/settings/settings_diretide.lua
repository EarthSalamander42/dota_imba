-- constants
DIRETIDE_BONUS_GOLD = 20000
PHASE_TIME = 361
if IsInToolsMode() then
	PHASE_TIME = 31
end
Diretide.nCOUNTDOWNTIMER = PHASE_TIME
Diretide.DIRETIDE_PHASE = 1
DIRETIDE_WINNER = 2
Diretide.COUNT_DOWN = false
Diretide.DIRETIDE_REINCARNATING = false

HIT_COUNT = {}
HIT_COUNT[2] = 0
HIT_COUNT[3] = 0

CustomNetTables:SetTableValue("game_options", "radiant", {score = 25})
CustomNetTables:SetTableValue("game_options", "dire", {score = 25})

-- modifiers
LinkLuaModifier("modifier_npc_dialog", "components/modifiers/diretide/modifier_npc_dialog.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_no_pvp", "components/modifiers/diretide/modifier_no_pvp.lua", LUA_MODIFIER_MOTION_NONE )
