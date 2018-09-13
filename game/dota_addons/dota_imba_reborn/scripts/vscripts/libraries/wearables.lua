if not Wearables then Wearables = {} end

local hats = LoadKeyValues("scripts/kv/wearables.kv")

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
function Wearables:SwapWearableSlot(unit, wearable_slot, new_model, material_group)
	local wearable = unit:FirstMoveChild()
	local old_wearable = nil
	while wearable ~= nil do
		if wearable:GetClassname() == "dota_item_wearable" then
			if string.find(wearable:GetModelName(), "_"..wearable_slot) then
				if wearable:GetModelName() ~= new_model then
					old_wearable = wearable
					cosmetic = SpawnEntityFromTableSynchronous("prop_dynamic", {model = new_model})
					cosmetic:FollowEntity(unit, true)
					cosmetic:SetMaterialGroup(material_group)

					if material_group then
						cosmetic:SetMaterialGroup(material_group)
					end
					for model_name, model_table in pairs(hats) do
						if new_model == model_name then
							for particle_type, particle_table in pairs(model_table) do
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
							break -- The break should be removed and start KV with hero name instead of model name if we add more than 1 cosmetic per hero, that's the most optimized way i can think of right now
						end
					end
				end
			end
		end
		wearable = wearable:NextMovePeer()
		if old_wearable and not old_wearable:IsNull() then
			old_wearable:RemoveSelf()
		end
	end
end

-- Returns a wearable handle if its the passed target_model
function Wearables:GetWearable( unit, target_model )
	local wearable = unit:FirstMoveChild()
	while wearable ~= nil do
		if wearable:GetClassname() == "dota_item_wearable" then
			if wearable:GetModelName() == target_model then
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
	for model_name, model_table in pairs(hats) do
		PrecacheModel(model_name, context)
		for particle_type, particle_table in pairs(model_table) do
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
