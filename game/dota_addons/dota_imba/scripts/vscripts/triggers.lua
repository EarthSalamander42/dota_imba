-- This file is a redirection to events.lua

function OnStartTouch( trigger )
	local triggerName = thisEntity:GetName()
	local activator_entindex = trigger.activator:GetEntityIndex()
--	print("Start Touch: Trigger name:", triggerName)
--	print("Start Touch: Activator index:", activator_entindex)
	local caller_entindex = trigger.caller:GetEntityIndex()

	CCavern:OnTriggerStartTouch( triggerName, activator_entindex, caller_entindex )
end

function OnEndTouch( trigger )
	local triggerName = thisEntity:GetName()
	local activator_entindex = trigger.activator:GetEntityIndex()
--	print("End Touch: Trigger name:", triggerName)
--	print("End Touch: Activator index:", activator_entindex) -- error here when destroying a door, probably dummies
	local caller_entindex = trigger.caller:GetEntityIndex()

	CCavern:OnTriggerEndTouch( triggerName, activator_entindex, caller_entindex )
end
