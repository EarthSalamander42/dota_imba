function Diretide:Announcer(announcer_type, event)
	if announcer_type == "diretide" then
		if event == "game_cancelled" then
			EmitGlobalSound("Diretide.Announcer.GameCancelled")
		end
		if event == "pre_game" then
			print("ANNOUNCER: PRE GAME")
			EmitGlobalSound("Diretide.Announcer.PreGame")
		end
		if event == "game_in_progress" then
			print("ANNOUNCER: GAME IN PROGRESS")
			EmitGlobalSound("Diretide.Announcer.GameInProgress")
			EmitGlobalSound("DireTideGameStart.DireSide")
		end
		if event == "phase_2" then
			print("ANNOUNCER: PHASE 2")
			EmitGlobalSound("Diretide.Announcer.TrickOrThreat")
			Timers:CreateTimer(3.0, function()
				local random_alt = RandomInt(1, 100)
				if random_alt >= 90 then
					EmitGlobalSound("Diretide.Announcer.RoshanTarget")
				end
			end)
		end
		if event == "roshan_target_good" then
			print("ANNOUNCER: ROSHAN TARGET RADIANT")
			EmitGlobalSound("Diretide.Announcer.RoshanTarget.Radiant")
		end
		if event == "roshan_target_bad" then
			print("ANNOUNCER: ROSHAN TARGET DIRE")
			EmitGlobalSound("Diretide.Announcer.RoshanTarget.Dire")
		end
		if event == "roshan_target_both" then
			print("ANNOUNCER: ROSHAN TARGET A TEAM")
			EmitGlobalSound("Diretide.Announcer.RoshanTarget.Both")
		end
		if event == "roshan_fed" then
			print("ANNOUNCER: ROSHAN RECEIVED A CANDY")
			EmitGlobalSound("announcer_diretide_rosh_")
		end
		if event == "winner_radiant" then
			print("ANNOUNCER: RADIANT CANDY WIN")
			EmitGlobalSound("Diretide.Announcer.MostCandy.Radiant")
		end
		if event == "winner_dire" then
			print("ANNOUNCER: DIRE CANDY WIN")
			EmitGlobalSound("Diretide.Announcer.MostCandy.Dire")
		end
		if event == "phase_3" then
			print("ANNOUNCER: PHASE 3")
			EmitGlobalSound("Diretide.Announcer.SugarRush")
		end
	end
end
