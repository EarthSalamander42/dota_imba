DIRETIDE_BONUS_GOLD = 20000
PHASE_TIME = 361
if IsInToolsMode() then
	PHASE_TIME = 31
end
nCOUNTDOWNTIMER = PHASE_TIME
DIRETIDE_PHASE = 1
DIRETIDE_WINNER = 2
COUNT_DOWN = 0
DIRETIDE_REINCARNATING = false

HIT_COUNT = {}
HIT_COUNT[2] = 0
HIT_COUNT[3] = 0

CustomNetTables:SetTableValue("game_options", "radiant", {score = 25})
CustomNetTables:SetTableValue("game_options", "dire", {score = 25})

require("components/diretide/diretide")
