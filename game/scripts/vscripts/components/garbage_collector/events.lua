function GarbageCollector:OnGameRulesStateChange()
	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		GarbageCollector:OnThink()
	end
end

function GarbageCollector:OnEntityKilled(event)
	local killedUnit = EntIndexToHScript(event.entindex_killed)

	if killedUnit and not killedUnit:IsNull() then
		-- print("OnEntityKilled:", killedUnit:GetUnitName(), killedUnit:GetEntityIndex())
		-- todo: check if this is causing non-hero units that can respawn to be removed
		if not killedUnit:IsRealHero() then
			-- print("Collecting garbage:", killedUnit:GetUnitName(), killedUnit:GetEntityIndex())
			GarbageCollector:CollectGarbageDelayed(killedUnit, 10.0)
		end
	end
end
