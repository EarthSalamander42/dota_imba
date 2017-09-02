function Storegga(hero)
	if not STOREGGA_ACTIVE then
		local team = hero:GetTeamNumber()
		local enemy_storegga = 0
		STOREGGA_ACTIVE = true
		Notifications:TopToAll({text="Storegga event triggered! Bonus Imba XP for everyone!", duration=99999.0, style={color="red", ["font-size"]="30px"}})
		Notifications:TopToAll({text="Blue Tiny is angry! Giff him mana!", duration=99999.0, style={color="red", ["font-size"]="24px"}})

		for abilitySlot = 0, 23 do
			local ability = hero:GetAbilityByIndex(abilitySlot)
			if ability then 
				hero:RemoveAbility(ability:GetAbilityName())
			end
		end

		hero:AddAbility("storegga_arm_slam")
		hero:AddAbility("storegga_grab")
		hero:AddAbility("storegga_grab_throw")
		hero:AddAbility("storegga_passive")
		hero:AddAbility("storegga_avalanche")
		hero:AddAbility("holdout_lordaeron_smash")
		hero:AddAbility("holdout_sindragosa")
		hero:SetModel('models/creeps/ice_biome/storegga/storegga.vmdl')
		hero:SetOriginalModel('models/creeps/ice_biome/storegga/storegga.vmdl')
		hero:SetModelScale(1.3)
		hero:SetBaseAttackTime(0.9)
		hero.storegga = true

		for _, enemy in pairs(HeroList:GetAllHeroes()) do
			print("Enemy heroes found")
			print(enemy:GetTeamNumber().."/"..team)
			if enemy:GetTeamNumber() ~= team and enemy_storegga == 0 then
				print("Enemy locked!")

				for abilitySlot = 0, 23 do
					local ability = enemy:GetAbilityByIndex(abilitySlot)
					if ability then 
						enemy:RemoveAbility(ability:GetAbilityName())
					end
				end

				enemy:AddAbility("storegga_arm_slam")
				enemy:AddAbility("storegga_grab")
				enemy:AddAbility("storegga_grab_throw")
				enemy:AddAbility("storegga_passive")
				enemy:AddAbility("storegga_avalanche")
				enemy:AddAbility("holdout_lordaeron_smash")
				enemy:AddAbility("holdout_sindragosa")
				enemy:SetModel('models/creeps/ice_biome/storegga/storegga.vmdl')
				enemy:SetOriginalModel('models/creeps/ice_biome/storegga/storegga.vmdl')
				enemy:SetModelScale(1.3)
				enemy:SetBaseAttackTime(0.9)
				enemy.storegga = true
				enemy_storegga = 1
			end
		end
	end
end
