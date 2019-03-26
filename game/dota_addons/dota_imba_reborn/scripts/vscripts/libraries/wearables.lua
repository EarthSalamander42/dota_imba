if not Wearables then Wearables = {} end

local cool_hats = LoadKeyValues("scripts/kv/wearables.kv")

function Wearables:SwapWearable(unit, new_model, material_group)
	for _, wearable in ipairs(unit:GetChildren()) do
		if wearable:GetClassname() == "dota_item_wearable" and wearable:GetModelName() ~= "" and wearable:GetModelName() ~= new_model then
			for k, v in pairs(cool_hats[new_model]["wearable_slot"]) do
				if string.find(wearable:GetModelName(), v) then
					print("Change cosmetic model from "..wearable:GetModelName().." to "..new_model)

					wearable:AddEffects(EF_NODRAW)

					local newWearable = CreateUnitByName("wearable_dummy", unit:GetAbsOrigin(), false, nil, nil, unit:GetTeam())
					newWearable:SetOriginalModel(new_model)
					newWearable:SetModel(new_model)
					newWearable:AddNewModifier(nil, nil, "modifier_wearable", {})
					newWearable:SetParent(unit, nil)
					newWearable:FollowEntity(unit, true)

					if material_group then
						newWearable:SetMaterialGroup(material_group)
					end

					if cool_hats[new_model]["cosmetic_particle"] then
						local particle_table = cool_hats[new_model]["cosmetic_particle"]["material_group"]["0"]

						if material_group then
							particle_table = cool_hats[new_model]["cosmetic_particle"]["material_group"][tostring(material_group)]
						end

						for _, particle_name in pairs(particle_table) do
							local pID = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, newWearable)
							ParticleManager:ReleaseParticleIndex(pID)
						end
					end

					if cool_hats[new_model]["hero_particle"] then
						for _, particle_name in pairs(cool_hats[new_model]["hero_particle"]) do
							local pID = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, unit)
							ParticleManager:ReleaseParticleIndex(pID)
						end
					end

					return
				end
			end
		end
	end
end

--[[
function Wearables:SwapWearable( unit, target_model, new_model )
	local wearable = unit:FirstMoveChild()
	while wearable ~= nil do
		if wearable:GetClassname() == "dota_item_wearable" then
			if wearable:GetModelName() == target_model then
				wearable:SetModel( new_model )
				return
			end
		end
		wearable = wearable:NextMovePeer()
	end
end

-- use -getwearable chat command to find what to search in the wearable name to filter it and hide it (e.g: mask, back, etc...)
function Wearables:SwapWearableSlot(unit, new_model, material_group)
	local wearable = unit:FirstMoveChild()
	local old_wearable = nil
	local cosmetic

	while wearable ~= nil do
		if wearable:GetClassname() == "dota_item_wearable" then
			for model_name, model_table in pairs(cool_hats) do
				if new_model == model_name then
					for particle_type, particle_table in pairs(model_table) do
						if particle_type == "wearable_slot" then
							for wearable_index, wearable_slot_name in pairs(particle_table) do
								if string.find(wearable:GetModelName(), wearable_slot_name) and wearable:GetModelName() ~= new_model then
--									old_wearable = wearable
									if wearable_slot == "hook" then
										wearable:SetModel(new_model)
										unit.hook_wearable = wearable
--										if material_group then -- disabled because useless for pudge hook
--											wearable:SetMaterialGroup(material_group)
--										end
									else
										print("Change cosmetic model from "..wearable:GetModelName().." to "..new_model)
										wearable:SetModel(new_model)
--										print("Create new cosmetic:", new_model)
--										cosmetic = SpawnEntityFromTableSynchronous("prop_dynamic", {model = new_model})
--										cosmetic:FollowEntity(unit, true)
--										if material_group then
--											cosmetic:SetMaterialGroup(material_group)
--										end
									end
								end
							end
						end
						if particle_type == "hero_particle" then
							for particle_index, particle_name in pairs(particle_table) do
								local pID = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, unit)
								ParticleManager:ReleaseParticleIndex(pID)
							end
						end
						if particle_type == "cosmetic_particle" then
							for material_group_table, material_group_list in pairs(particle_table) do
								for particle_list_index, particle_list in pairs(particle_table) do
									if material_group then
										for particle_index, particle_name in pairs(particle_list[material_group]) do
											local pID = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, cosmetic)
											ParticleManager:ReleaseParticleIndex(pID)
										end
									else
										for particle_index, particle_name in pairs(particle_list["0"]) do
											local pID = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, cosmetic)
											ParticleManager:ReleaseParticleIndex(pID)
										end
									end
								end
							end
						end
					end
					break
				end
			end
		end

		if wearable_slot ~= "hook" then
			if old_wearable and not old_wearable:IsNull() then
				Wearables:RemoveWearable(old_wearable)
				return -- When a cosmetic is replaced, end the function
			end
		end

		wearable = wearable:NextMovePeer()
	end
end
--]]

function Wearables:RemoveWearable(wearable)
	Timers:CreateTimer(0.1, function()
		if wearable and wearable.GetModelName then
			print("Wearable hidden:", wearable:GetModelName())
			wearable:SetModel("models/development/invisiblebox.vmdl")
			wearable:AddEffects(EF_NODRAW)
			UTIL_Remove(wearable)
			return 0.1
		else
			return nil
		end
	end)
end

-- Returns a wearable handle if its the passed target_model
function Wearables:GetWearable(unit, model_find)
	local wearable = unit:FirstMoveChild()
	while wearable ~= nil do
		if wearable:GetClassname() == "dota_item_wearable" then
			if string.find(wearable:GetModelName(), model_find) then
				return wearable
			end
		end
		wearable = wearable:NextMovePeer()
	end
	return false
end

function Wearables:HideWearable( unit, target_model )
	local wearable = unit:FirstMoveChild()
	while wearable ~= nil do
		if wearable:GetClassname() == "dota_item_wearable" then
			if wearable:GetModelName() == target_model then
				print("Wearable hidden:", wearable:GetModelName())
				wearable:AddEffects(EF_NODRAW)
				return
			end
		end
		wearable = wearable:NextMovePeer()
	end
end

function Wearables:ShowWearable( unit, target_model )
	local wearable = unit:FirstMoveChild()
	while wearable ~= nil do
		if wearable:GetClassname() == "dota_item_wearable" then
			if wearable:GetModelName() == target_model then
				wearable:RemoveEffects(EF_NODRAW)
				return
			end
		end
		wearable = wearable:NextMovePeer()
	end
end

function Wearables:PrintWearables( unit )
	print("---------------------")
	print("Wearable List of "..unit:GetUnitName())
	print("Main Model: "..unit:GetModelName())
	local wearable = unit:FirstMoveChild()
	while wearable ~= nil do
		if wearable:GetClassname() == "dota_item_wearable" then
			local model_name = wearable:GetModelName()
			if model_name ~= "" then print(model_name) end
		end
		wearable = wearable:NextMovePeer()
	end
end

function Wearables:PrecacheWearables(context)
	for model_name, model_table in pairs(cool_hats) do
		PrecacheModel(model_name, context)
		for particle_type, particle_table in pairs(model_table) do
			if particle_type == "precache_particle" then
				for particle_index, particle_name in pairs(particle_table) do
					if type(particle_name) == "string" and particle_name ~= "" then
						PrecacheResource("particle", particle_name, context)
					end
				end
			end
			if particle_type == "hero_particle" then
				for particle_index, particle_name in pairs(particle_table) do
					if type(particle_name) == "string" and particle_name ~= "" then
						PrecacheResource("particle", particle_name, context)
					end
				end
			end
			if particle_type == "cosmetic_particle" then
				for material_group_table, material_group_list in pairs(particle_table) do
					for particle_list_index, particle_list in pairs(particle_table) do
						for material_group_kv, material_group_list in pairs(particle_list) do
							for particle_index, particle_name in pairs(material_group_list) do
								if type(particle_name) == "string" and particle_name ~= "" then
									PrecacheResource("particle", particle_name, context)
								end
							end
						end
					end
				end
			end
		end
	end
end

function Wearables:GetModelStringFinders(target_model)
	local table = {}
	for model_name, model_table in pairs(cool_hats) do
		if target_model == model_name then
			for particle_type, particle_table in pairs(model_table) do
				if particle_type == "wearable_slot" then
					return particle_table
				end
			end
		end
	end
end
