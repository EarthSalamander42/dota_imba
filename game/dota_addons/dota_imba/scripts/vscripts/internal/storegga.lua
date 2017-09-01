function Storegga(hero)
	if not STOREGGA_ACTIVE then
		STOREGGA_ACTIVE = true
		Notifications:TopToAll({text="Storegga event triggered! Bonus Imba XP for everyone!", duration=10.0, style={color="red", ["font-size"]="30px"}})
		Notifications:TopToAll({text="Blue Tiny is angry! Giff him mana!", duration=10.0, style={color="red", ["font-size"]="24px"}})

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
	end
end
