function Battlepass:DonatorCompanion(ID, unit_name, js)
	local hero = PlayerResource:GetPlayer(ID):GetAssignedHero()

	if hero.companion then
		hero.companion:ForceKill(false)
	end

	-- Disabled companion
	if unit_name == "" then
		hero.companion = nil
		return
	end

	-- set mini doom as default companion if something goes wrong
	if unit_name == nil then
		unit_name = "npc_donator_companion_demi_doom"
	end

	if UNIQUE_DONATOR_COMPANION[tostring(PlayerResource:GetSteamID(ID))] and not js then 
		unit_name = UNIQUE_DONATOR_COMPANION[tostring(PlayerResource:GetSteamID(ID))]
	end

	local model
	local model_scale

	for key, value in pairs(LoadKeyValues("scripts/npc/units/companions.txt")) do
		if key == unit_name then
			model = value["Model"]
			model_scale = value["ModelScale"]
			break
		end
	end

	local companion = CreateUnitByName("npc_donator_companion", hero:GetAbsOrigin() + RandomVector(200), true, hero, hero, hero:GetTeamNumber())
	companion:SetModel(model)
	companion:SetOriginalModel(model)
	companion:SetOwner(hero)

	companion:AddNewModifier(companion, nil, "modifier_companion", {})

	hero.companion = companion

	if model == "models/courier/baby_rosh/babyroshan.vmdl" then
		local particle_name = {}
		particle_name[0] = "particles/econ/courier/courier_donkey_ti7/courier_donkey_ti7_ambient.vpcf"
		particle_name[1] = "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf"
		particle_name[2] = "particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf"
		particle_name[3] = "particles/econ/courier/courier_roshan_darkmoon/courier_roshan_darkmoon.vpcf" -- particles/econ/courier/courier_roshan_darkmoon/courier_roshan_darkmoon_flying.vpcf
		particle_name[4] = "particles/econ/courier/courier_roshan_desert_sands/baby_roshan_desert_sands_ambient.vpcf"
		particle_name[5] = "particles/econ/courier/courier_roshan_ti8/courier_roshan_ti8.vpcf"
		particle_name[6] = "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf"
		particle_name[7] = "particles/econ/courier/courier_roshan_frost/courier_roshan_frost_ambient.vpcf"
		particle_name[8] = "particles/econ/courier/courier_babyroshan_winter18/courier_babyroshan_winter18_ambient.vpcf"
		particle_name[9] = "particles/econ/courier/courier_babyroshan_ti9/courier_babyroshan_ti9_ambient.vpcf"

--		if RandomInt(1, 2) == 2 then
--			model = model.."_flying"
--		end

		-- also attach eyes effect later
		local random_int = RandomInt(0, #particle_name)

		local particle = ParticleManager:CreateParticle(particle_name[random_int], PATTACH_ABSORIGIN_FOLLOW, companion)
		if random_int <= 5 then
			companion:SetMaterialGroup(tostring(random_int))
		elseif random_int == 6 or random_int == 7 then
			companion:SetModel("models/courier/baby_rosh/babyroshan_elemental.vmdl")
			companion:SetOriginalModel("models/courier/baby_rosh/babyroshan_elemental.vmdl")
			companion:SetMaterialGroup(tostring(random_int - 5))
		elseif random_int == 8 then
			companion:SetModel("models/courier/baby_rosh/babyroshan_winter18.vmdl")
			companion:SetOriginalModel("models/courier/baby_rosh/babyroshan_winter18.vmdl")
		elseif random_int == 9 then
			companion:SetModel("models/courier/baby_rosh/babyroshan_ti9.vmdl")
			companion:SetOriginalModel("models/courier/baby_rosh/babyroshan_ti9.vmdl")
		end
	elseif unit_name == "npc_donator_companion_suthernfriend" then
		companion:SetMaterialGroup("1")
	end

	companion:SetModelScale(model_scale)

	if DONATOR_COMPANION_ADDITIONAL_INFO[model] and DONATOR_COMPANION_ADDITIONAL_INFO[model][1] then
		local particle = ParticleManager:CreateParticle(DONATOR_COMPANION_ADDITIONAL_INFO[model][1], PATTACH_ABSORIGIN_FOLLOW, companion)
		ParticleManager:ReleaseParticleIndex(particle)
	end

--	if super_donator then
--		local ab = companion:FindAbilityByName("companion_morph")
--		ab:SetLevel(1)
--		ab:CastAbility()		
--	end
end

function DonatorCompanionSkin(id, unit, skin)
	local hero = PlayerResource:GetPlayer(id):GetAssignedHero()

--	print("Material Group:", skin)
--	print(hero.companion, hero.companion:GetUnitName(), unit)
	if hero.companion and hero.companion:GetUnitName() == unit then
		hero.companion:SetMaterialGroup(tostring(skin))
	end
end

function Battlepass:DonatorStatue(ID, statue_unit)
	if UNIQUE_DONATOR_STATUE[tostring(PlayerResource:GetSteamID(ID))] then 
		statue_unit = UNIQUE_DONATOR_STATUE[tostring(PlayerResource:GetSteamID(ID))]
	end

	local pedestal_name = "npc_donator_pedestal"
	local hero = PlayerResource:GetSelectedHeroEntity(ID)

--	if hero.donator_statue then
--		hero.donator_statue:ForceKill(false)

--		local unit = CreateUnitByName(statue_unit[2], abs, true, nil, nil, PlayerResource:GetPlayer(ID):GetTeam())
--		unit:SetModelScale(statue_unit[1])
--		unit:SetAbsOrigin(abs + Vector(0, 0, 17))
--		unit:AddNewModifier(unit, nil, "modifier_contributor_statue", {})
--		hero.donator_statue = unit

--		return
--	end

	local team = "good"

	if PlayerResource:GetPlayer(ID):GetTeam() == 3 then
		team = "bad"
	end

	local fillers = {
		team.."_filler_2",
		team.."_filler_4",
		team.."_filler_6",
		team.."_filler_7",
	}

	local model_scale = nil

	for key, value in pairs(LoadKeyValues("scripts/npc/units/statues.txt")) do
		if key == statue_unit then
			model_scale = value["ModelScale"]
			break
		end
	end

	if model_scale == nil then model_scale = 1.0 end

	if statue_unit == nil then return end
	for _, ent_name in pairs(fillers) do
		local filler = Entities:FindByName(nil, ent_name)
		if filler then
			local abs = filler:GetAbsOrigin()

			filler:RemoveSelf()

			local unit = CreateUnitByName(statue_unit, abs, true, nil, nil, PlayerResource:GetPlayer(ID):GetTeam())
			if unit == nil then return end
			unit:SetModelScale(model_scale)
			unit:SetAbsOrigin(abs + Vector(0, 0, 45))
--			unit:AddNewModifier(unit, nil, "modifier_donator_statue", {})
			unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
			hero.donator_statue = unit

			local steam_id = tostring(PlayerResource:GetSteamID(hero:GetPlayerID()))
			local name = PlayerResource:GetPlayerName(ID)

			if api:GetDonatorStatus(ID) == 1 then
				unit:SetCustomHealthLabel(name, 160, 20, 20)
				pedestal_name = "npc_donator_pedestal_cookies"
			elseif api:GetDonatorStatus(ID) == 2 then
				unit:SetCustomHealthLabel("sutherncuck", 0, 204, 255)
				pedestal_name = "npc_donator_pedestal_developer_"..team
			elseif api:GetDonatorStatus(ID) == 3 then
				unit:SetCustomHealthLabel(name, 160, 20, 20)
			elseif api:GetDonatorStatus(ID) == 4 then
				unit:SetCustomHealthLabel(name, 240, 50, 50)
				pedestal_name = "npc_donator_pedestal_ember_"..team
			elseif api:GetDonatorStatus(ID) == 5 then
				unit:SetCustomHealthLabel(name, 218, 165, 32)
				pedestal_name = "npc_donator_pedestal_golden_"..team
			elseif api:GetDonatorStatus(ID) == 7 then
				unit:SetCustomHealthLabel(name, 47, 91, 151)
				pedestal_name = "npc_donator_pedestal_salamander_"..team
			elseif api:GetDonatorStatus(ID) == 8 then
				unit:SetCustomHealthLabel(name, 153, 51, 153)
				pedestal_name = "npc_donator_pedestal_icefrog"
			elseif api:GetDonatorStatus(ID) then -- 6: donator, 0: lesser donator
				unit:SetCustomHealthLabel(name, 45, 200, 45)
			end

			if statue_unit == "npc_donator_statue_suthernfriend" then
				unit:SetMaterialGroup("1")
			elseif statue_unit == "npc_donator_statue_tabisama" then
				unit:SetAbsOrigin(unit:GetAbsOrigin() + Vector(0, 0, 40))
			elseif statue_unit == "npc_donator_statue_zonnoz" then
				pedestal_name = "npc_donator_pedestal_pudge_arcana"
			elseif statue_unit == "npc_donator_statue_crystal_maiden_arcana" then
				local particle = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_arcana_base_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
				ParticleManager:ReleaseParticleIndex(particle)
			end

			local pedestal = CreateUnitByName(pedestal_name, abs, true, nil, nil, PlayerResource:GetPlayer(ID):GetTeam())
			pedestal:AddNewModifier(pedestal, nil, "modifier_contributor_statue", {})
			pedestal:SetAbsOrigin(abs + Vector(0, 0, 45))
			unit.pedestal = pedestal

			if statue_unit == "npc_donator_statue_zonnoz" then
				pedestal:SetMaterialGroup("1")
			end

			return
		end
	end
end
