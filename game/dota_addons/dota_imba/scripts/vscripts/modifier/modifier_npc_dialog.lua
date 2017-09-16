modifier_npc_dialog = class({})

-----------------------------------------------------------------------

function modifier_npc_dialog:IsHidden()
	return true
end

-----------------------------------------------------------------------

function modifier_npc_dialog:IsPurgable()
	return false
end

-----------------------------------------------------------------------

function modifier_npc_dialog:OnCreated( params )
	if IsServer() then
	end
end

-----------------------------------------------------------------------

function modifier_npc_dialog:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACKED,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_npc_dialog:OnAttacked(keys)
local attacker = keys.attacker
local target = keys.target

	if IsServer() then
		if target:GetUnitName() == "npc_dota_diretide_easter_egg" then
			if attacker:HasModifier("modifier_imba_fervor_stacks") then
				attacker:SetModifierStackCount("modifier_imba_fervor_stacks", attacker, attacker:GetModifierStackCount("modifier_imba_fervor_stacks", attacker) -1)
			elseif attacker:HasModifier("modifier_imba_juggernaut_blade_dance_wind_dance") then
				attacker:SetModifierStackCount("modifier_imba_juggernaut_blade_dance_wind_dance", attacker, attacker:GetModifierStackCount("modifier_imba_juggernaut_blade_dance_wind_dance", attacker) -1)
			elseif attacker:HasModifier("modifier_imba_juggernaut_blade_dance_secret_blade") then
				attacker:SetModifierStackCount("modifier_imba_juggernaut_blade_dance_secret_blade", attacker, attacker:GetModifierStackCount("modifier_imba_juggernaut_blade_dance_secret_blade", attacker) -1)
			elseif attacker:HasModifier("modifier_imba_juggernaut_blade_dance_jade_blossom") then
				attacker:SetModifierStackCount("modifier_imba_juggernaut_blade_dance_jade_blossom", attacker, attacker:GetModifierStackCount("modifier_imba_juggernaut_blade_dance_jade_blossom", attacker) -1)
			end

			local netTable = {}
			netTable["DialogEntIndex"] = target:entindex()
			netTable["PlayerHeroEntIndex"] = attacker:entindex()
			netTable["DialogText"] = "#roshan_easter_egg"
			netTable["DialogAdvanceTime"] = 5.0
			netTable["DialogLine"] = 1
			netTable["ShowAdvanceButton"] = false
			netTable["SendToAll"] = false
			netTable["JournalEntry"] = target:FindAbilityByName( "ability_journal_note" ) ~= nil
			CustomGameEventManager:Send_ServerToPlayer(attacker:GetPlayerOwner(), "dialog", netTable)
		end
	end

--	return 0
end
