function Overthrow:OnEntityKilled(killer, killed_unit)
	if killer:GetTeam() ~= killed_unit:GetTeam() then
		--Add extra time if killed by Necro Ult
		if killed_unit:HasModifier("modifier_imba_reapers_scythe_respawn") then
			print("Killed by Necro Ult")
			respawn_time = respawn_time + OVERTHROW_EXTRA_TIME_NECRO_KILL
		end

		-- Grant killer xp
		if killed_unit:GetTeam() == leadingTeam and isGameTied == false then
			local memberID = killed_unit:GetPlayerID()
			PlayerResource:ModifyGold(memberID, 500, true, 0)
			killed_unit:AddExperience(100, 0, false, false)
			local name = killed_unit:GetClassname()
			local victim = killed_unit:GetClassname()
			local kill_alert =
			{
				hero_id = killed_unit:GetClassname()
			}
			CustomGameEventManager:Send_ServerToAllClients( "kill_alert", kill_alert )
		else
			killed_unit:AddExperience(50, 0, false, false)
		end

		local broadcast_team_points =
		{
			radiant = GetTeamHeroKills(2),
			dire = GetTeamHeroKills(3),
			custom_1 = GetTeamHeroKills(6),
			custom_2 = GetTeamHeroKills(7),
			custom_3 = GetTeamHeroKills(8),
		}

		CustomGameEventManager:Send_ServerToAllClients( "team_points", broadcast_team_points )
	end

	--Granting XP to all heroes who assisted
	for _,attacker in pairs(HeroList:GetAllHeroes()) do
		print(killed_unit:GetNumAttackers())

		for i = 0, killed_unit:GetNumAttackers() - 1 do
			if attacker == killed_unit:GetAttacker(i) then
				log.debug("Granting assist xp")
				attacker:AddExperience(25, 0, false, false)
			end
		end
	end

	if killed_unit:GetRespawnTime() > 10 then
		print("Hero has long respawn time")
		if killed_unit:IsImbaReincarnating() then
			print("Set time for Wraith King respawn disabled")
		else
			Overthrow:SetRespawnTime( killed_unit:GetTeamNumber(), killed_unit, respawn_time )
		end
	else
		Overthrow:SetRespawnTime( killed_unit:GetTeamNumber(), killed_unit, respawn_time )
	end
end

function Overthrow:SetRespawnTime( killedTeam, killed_unit, extraTime )
	if killedTeam == leadingTeam and isGameTied == false then
		killed_unit:SetTimeUntilRespawn( 20 + extraTime )
	else
		killed_unit:SetTimeUntilRespawn( 10 + extraTime )
	end
end
