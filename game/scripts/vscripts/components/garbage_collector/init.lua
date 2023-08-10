if not GarbageCollector then
	GarbageCollector = class({})
	GarbageCollector._garbage = {}
	GarbageCollector._thinkInterval = 60

	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(GarbageCollector, "OnGameRulesStateChange"), GarbageCollector)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(GarbageCollector, "OnEntityKilled"), GarbageCollector)
end

require("components/garbage_collector/events")

function GarbageCollector:Destroy()
	for _, v in pairs(self._garbage) do
		if v and IsValidEntity(v) and not v:IsNull() then
			print("GarbageCollector: Removing unit:", v:GetUnitName(), v:GetEntityIndex())
			v:RemoveSelf()
		end

		table.remove(self._garbage, _)
	end
end

function GarbageCollector:CollectGarbage(unit)
	if unit and IsValidEntity(unit) and not unit:IsNull() then
		-- print("Collecting garbage:", unit:GetUnitName(), unit:GetEntityIndex())
		table.insert(self._garbage, unit)
	end
end

function GarbageCollector:CollectGarbageDelayed(unit, delay)
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("GarbageCollector"), function()
		self:CollectGarbage(unit)
	end, delay)
end

function GarbageCollector:OnThink()
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("GarbageCollector"), function()
		if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			self:Destroy()
			return self._thinkInterval
		else
			return 1.0
		end
	end, 0)
end
