-- not working: team kill tower, courier dead, courier respawn, 
-- hero kill tower says hero denied
function CombatEvents(event_type, reason, victim, attacker, custom_gold)
	if IMBA_COMBAT_EVENTS == false then return end
	local text = ""
	local team
	local atacker_name
	local victim_name
	local courier = false
	local first_blood = false
	local glyph = false
	local neutral = false
	local roshan = false
	local suicide = false
	local tower = false
	local gold = 0
	if victim then
		if victim:IsBuilding() then gold = 200 end
		if victim:GetUnitName() == "npc_dota_goodguys_healers" or victim:GetUnitName() == "npc_dota_badguys_healers" then gold = 125 end
	end
	local attacker_id
	local victim_id
	local variables

	local streak = {}
	streak[3] = "Killing spree"
	streak[4] = "Dominating"
	streak[5] = "Mega kill"
	streak[6] = "Unstoppable"
	streak[7] = "Wicked sick"
	streak[8] = "Monster kill"
	streak[9] = "Godlike"
	streak[10] = "Beyond Godlike"

--	gold = gold * (tonumber(CustomNetTables:GetTableValue("game_options", "bounty_multiplier")["1"]) / 100)

	if event_type == "generic" then
		if reason == "courier_respawn" then
			text = "#custom_toast_CourierRespawned"
			team = victim:GetTeam()
			victim_id = victim.owner_id
			courier = true
		elseif reason == "courier_dead" then
			text = "#custom_toast_CourierKilled"
			team = victim:GetTeam()
			victim_id = victim.owner_id
			courier = true
		elseif reason == "tower_kill_hero" then
			text = "#custom_toast_TeamKilled"
			team = attacker:GetTeam()
			victim_name = victim:GetUnitName()
			tower = true
		elseif reason == "tower_dead" then
			text = "#custom_toast_TeamKilled"
			team = attacker:GetTeam()
			victim_name = victim:GetUnitName()
		elseif reason == "glyph" then
			text = "#custom_toast_GlyphUsed"
			team = victim:GetTeam()
			glyph = true
		end

		CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", {
			type = "generic",
			text = text,
			teamColor = team,
			teamPlayer = team,
			team = team,
			victimUnitName = victim_name,
			courier = courier,
			gold = gold,
			tower = tower,
			glyph = glyph,
			victimPlayer = victim_id,			
		})
	elseif event_type == "kill" then
		if reason == "first_blood" then
			attacker_id = attacker:GetPlayerID()
			victim_id = victim:GetPlayerID()
			first_blood = true
			gold = custom_gold
		elseif reason == "hero_kill" then
			attacker_id = attacker:GetPlayerID()
			victim_id = victim:GetPlayerID()
			gold = custom_gold
			variables = {
				["{kill_streak}"] = streak[math.min(attacker.killstreak, 10)]
			}
		elseif reason == "hero_kill_tower" then
			attacker_id = attacker:GetPlayerID()
			victim_name = victim:GetUnitName()
			gold = gold
		elseif reason == "roshan_dead" then
			team = attacker:GetTeam()
			victim_name = victim:GetUnitName()
			roshan = true
			gold = 150 * (tonumber(CustomNetTables:GetTableValue("game_options", "bounty_multiplier")["1"]) / 100)
		elseif reason == "hero_suicide" then
			victim_name = victim:GetUnitName()
			suicide = true
		elseif reason == "hero_deny_hero" then
			attacker_id = attacker:GetPlayerID()
			victim_id = victim:GetPlayerID()
			victim_name = victim:GetUnitName()
		elseif reason == "neutrals_kill_hero" then
			victim_name = victim:GetUnitName()
			neutral = true
		end

		CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", {
			type = "kill",
			teamColor = team,
			team = team,
			killerPlayer = attacker_id,
			victimPlayer = victim_id,
			victimUnitName = victim_name,
			courier = courier,
			gold = gold,
			tower = tower,
			variables = variables,
			roshan = roshan,
			neutral = neutral,
			suicide = suicide,
		})
	end
end
