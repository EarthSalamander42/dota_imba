modifier_mutation_alien_incubation = class({})

function modifier_mutation_alien_incubation:IsHidden() return true end
function modifier_mutation_alien_incubation:RemoveOnDeath() return false end
function modifier_mutation_alien_incubation:IsPurgable() return false end

function modifier_mutation_alien_incubation:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_mutation_alien_incubation:OnDeath(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			if keys.unit:GetMaxHealth() > 3000 and not (keys.unit:GetUnitName() == "npc_dota_mutation_spiderling_super_big") then
				local spider_count = RandomInt(1, math.floor(keys.unit:GetMaxHealth() / 3000))
				for i = 1, spider_count do
					local spider = CreateUnitByName("npc_dota_mutation_spiderling_super_big", keys.unit:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
					spider:AddNewModifier(spider, nil, "modifier_kill", {duration = 120})
					FindClearSpaceForUnit(spider, spider:GetAbsOrigin(), true)
				end
			elseif keys.unit:GetMaxHealth() > 1200 and not (keys.unit:GetUnitName() == "npc_dota_mutation_spiderling_big") then
				local spider_count = RandomInt(1, 3)
				for i = 1, spider_count do
					local spider = CreateUnitByName("npc_dota_mutation_spiderling_big", keys.unit:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
					spider:AddNewModifier(spider, nil, "modifier_kill", {duration = 90})
					FindClearSpaceForUnit(spider, spider:GetAbsOrigin(), true)
				end
			elseif keys.unit:GetMaxHealth() > 500 and not (keys.unit:GetUnitName() == "npc_dota_mutation_spiderling") then
				local spider_count = RandomInt(1, 3)
				for i = 1, spider_count do
					local spider = CreateUnitByName("npc_dota_mutation_spiderling", keys.unit:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
					spider:AddNewModifier(spider, nil, "modifier_kill", {duration = 60})
					FindClearSpaceForUnit(spider, spider:GetAbsOrigin(), true)
				end
			elseif keys.unit:GetMaxHealth() > 200 and not (keys.unit:GetUnitName() == "npc_dota_mutation_spiderite") then
				local spider_count = RandomInt(1, 5)
				for i = 1, spider_count do
					local spider = CreateUnitByName("npc_dota_mutation_spiderite", keys.unit:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
					spider:AddNewModifier(spider, nil, "modifier_kill", {duration = 30})
					FindClearSpaceForUnit(spider, spider:GetAbsOrigin(), true)
				end
			end
		end
	end
end