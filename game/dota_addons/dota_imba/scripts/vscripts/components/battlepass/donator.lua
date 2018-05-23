function DonatorStatue(ID, statue_unit)
	if IMBA_DONATOR_STATUE[tostring(PlayerResource:GetSteamID(ID))] then 
		statue_unit = IMBA_DONATOR_STATUE[tostring(PlayerResource:GetSteamID(ID))]
	end

	local pedestal_name = "npc_imba_donator_pedestal"
	local hero = PlayerResource:GetSelectedHeroEntity(ID)

--	if hero.donator_statue then
--		hero.donator_statue:ForceKill(false)

--		local unit = CreateUnitByName(statue_unit[2], abs, true, nil, nil, PlayerResource:GetPlayer(ID):GetTeam())
--		unit:SetModelScale(statue_unit[1])
--		unit:SetAbsOrigin(abs + Vector(0, 0, 17))
--		unit:AddNewModifier(unit, nil, "modifier_imba_contributor_statue", {})
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

	for _, ent_name in pairs(fillers) do
		local filler = Entities:FindByName(nil, ent_name)
		if filler then
			local abs = filler:GetAbsOrigin()

			filler:RemoveSelf()

			local unit = CreateUnitByName(statue_unit, abs, true, nil, nil, PlayerResource:GetPlayer(ID):GetTeam())
			unit:SetAbsOrigin(abs + Vector(0, 0, 45))
			unit:AddNewModifier(unit, nil, "modifier_imba_donator_statue", {})
			unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
			hero.donator_statue = unit

			local steam_id = tostring(PlayerResource:GetSteamID(hero:GetPlayerID()))
			local name = PlayerResource:GetPlayerName(ID)

			if api.imba.is_donator(steam_id) == 1 then
				unit:SetCustomHealthLabel(name, 160, 20, 20)
				pedestal_name = "npc_imba_donator_pedestal_cookies"
			elseif api.imba.is_donator(steam_id) == 2 then
				unit:SetCustomHealthLabel("sutherncuck", 0, 204, 255)
				pedestal_name = "npc_imba_donator_pedestal_developer_"..team
			elseif api.imba.is_donator(steam_id) == 3 then
				unit:SetCustomHealthLabel(name, 160, 20, 20)
			elseif api.imba.is_donator(steam_id) == 4 then
				unit:SetCustomHealthLabel(name, 240, 50, 50)
				pedestal_name = "npc_imba_donator_pedestal_ember_"..team
			elseif api.imba.is_donator(steam_id) == 5 then
				unit:SetCustomHealthLabel(name, 218, 165, 32)
				pedestal_name = "npc_imba_donator_pedestal_golden_"..team
			elseif api.imba.is_donator(steam_id) == 7 then
				unit:SetCustomHealthLabel(name, 47, 91, 151)
				pedestal_name = "npc_imba_donator_pedestal_salamander_"..team
			elseif api.imba.is_donator(steam_id) == 8 then
				unit:SetCustomHealthLabel(name, 153, 51, 153)
				pedestal_name = "npc_imba_donator_pedestal_icefrog"
			elseif api.imba.is_donator(steam_id) then -- 6: donator, 0: lesser donator
				unit:SetCustomHealthLabel(name, 45, 200, 45)
			end

			if statue_unit == "npc_imba_donator_statue_suthernfriend" then
				unit:SetMaterialGroup("1")
			elseif statue_unit == "npc_imba_donator_statue_tabisama" then
				unit:SetAbsOrigin(unit:GetAbsOrigin() + Vector(0, 0, 40))
			end

			if statue_unit == "npc_imba_donator_statue_zonnoz" then
				pedestal_name = "npc_imba_donator_pedestal_pudge_arcana"
			end

			local pedestal = CreateUnitByName(pedestal_name, abs, true, nil, nil, PlayerResource:GetPlayer(ID):GetTeam())
			pedestal:AddNewModifier(pedestal, nil, "modifier_imba_contributor_statue", {})
			pedestal:SetAbsOrigin(abs + Vector(0, 0, 45))
			unit.pedestal = pedestal

			if statue_unit == "npc_imba_donator_statue_zonnoz" then
				pedestal:SetMaterialGroup("1")
			end

			return
		end
	end
end

function DonatorCompanion(ID, unit_name, js)
if IMBA_DONATOR_COMPANION[tostring(PlayerResource:GetSteamID(ID))] and not js then 
	unit_name = IMBA_DONATOR_COMPANION[tostring(PlayerResource:GetSteamID(ID))]
end

if unit_name == nil then return end
local hero = PlayerResource:GetPlayer(ID):GetAssignedHero()
local color = hero:GetFittingColor()
local model = GetKeyValueByHeroName(unit_name, "Model")
local model_scale = GetKeyValueByHeroName(unit_name, "ModelScale")

--	print(unit_name, model, model_scale)

	if hero.companion then
		hero.companion:ForceKill(false)
	end

	local companion = CreateUnitByName("npc_imba_donator_companion", hero:GetAbsOrigin() + RandomVector(200), true, hero, hero, hero:GetTeamNumber())
	companion:SetModel(model)
	companion:SetOriginalModel(model)
	companion:SetOwner(hero)
	companion:SetControllableByPlayer(hero:GetPlayerID(), true)

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

		-- also attach eyes effect later
		local random_int = RandomInt(0, #particle_name)

		local particle = ParticleManager:CreateParticle(particle_name[random_int], PATTACH_ABSORIGIN_FOLLOW, companion)
		if random_int <= 5 then
			companion:SetMaterialGroup(tostring(random_int))
		else
			companion:SetModel("models/courier/baby_rosh/babyroshan_elemental.vmdl")
			companion:SetOriginalModel("models/courier/baby_rosh/babyroshan_elemental.vmdl")
			companion:SetMaterialGroup(tostring(random_int - 5))
		end
	elseif unit_name == "npc_imba_donator_companion_suthernfriend" then
		companion:SetMaterialGroup("1")
	elseif model == "models/items/courier/devourling/devourling.vmdl" then
		local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_devourling/courier_devourling_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, companion)
		ParticleManager:ReleaseParticleIndex(particle)
	elseif unit_name == "npc_imba_donator_companion_baekho" then
		local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_baekho/courier_baekho_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, companion)
		ParticleManager:ReleaseParticleIndex(particle)
	elseif unit_name == "npc_imba_donator_companion_terdic" then
		local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_shagbark/courier_shagbark_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, companion)
		ParticleManager:ReleaseParticleIndex(particle)
	elseif model == "models/items/io/io_ti7/io_ti7.vmdl" then
		local particle = ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_ambient_ti7.vpcf", PATTACH_ABSORIGIN_FOLLOW, companion)
		ParticleManager:ReleaseParticleIndex(particle)
	end

	companion:SetModelScale(model_scale)

	if string.find(model, "flying") then
		companion:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
	end

--	if super_donator then
--		local ab = companion:FindAbilityByName("companion_morph")
--		ab:SetLevel(1)
--		ab:CastAbility()		
--	end
end