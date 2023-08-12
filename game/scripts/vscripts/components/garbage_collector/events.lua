function GarbageCollector:OnGameRulesStateChange()
	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		GarbageCollector:OnThink()
	end
end

function GarbageCollector:OnNPCSpawned(event)
	local npc = EntIndexToHScript(event.entindex)

	if npc and not npc:IsNull() and not npc:IsRealHero() and not npc:IsCourier() then
		npc:AddNewModifier(npc, nil, "modifier_garbage_dead_tracker", {})
		-- print("OnNPCSpawned:", npc:GetUnitName(), npc:GetEntityIndex())
		-- GarbageCollector:CollectGarbage(npc)
	end
end

-- function GarbageCollector:OnEntityKilled(event)
-- 	local killedUnit = EntIndexToHScript(event.entindex_killed)

-- 	if killedUnit and not killedUnit:IsNull() then
-- 		-- print("OnEntityKilled:", killedUnit:GetUnitName(), killedUnit:GetEntityIndex())
-- 		-- todo: check if this is causing non-hero units that can respawn to be removed
-- 		if not killedUnit:IsRealHero() then
-- 			-- print("Collecting garbage:", killedUnit:GetUnitName(), killedUnit:GetEntityIndex())
-- 			GarbageCollector:CollectGarbageDelayed(killedUnit, 10.0)
-- 		end
-- 	end
-- end
