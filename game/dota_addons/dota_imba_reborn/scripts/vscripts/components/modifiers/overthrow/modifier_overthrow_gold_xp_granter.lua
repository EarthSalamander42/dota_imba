LinkLuaModifier("modifier_overthrow_gold_xp_granter_global", "components/modifiers/overthrow/modifier_overthrow_gold_xp_granter.lua", LUA_MODIFIER_MOTION_NONE )

modifier_overthrow_gold_xp_granter = modifier_overthrow_gold_xp_granter or class({})

function modifier_overthrow_gold_xp_granter:IsHidden() return true end
function modifier_overthrow_gold_xp_granter:IsPurgable() return false end
function modifier_overthrow_gold_xp_granter:IsPurgeException() return false end

function modifier_overthrow_gold_xp_granter:GetTexture()
	return "custom/custom_games_xp_coin"
end

function modifier_overthrow_gold_xp_granter:OnCreated()
	if IsServer() then
		self.radius = 1400
		self.gold = 2
		self.xp = 6

		self:StartIntervalThink(0.5)
	end
end

function modifier_overthrow_gold_xp_granter:OnIntervalThink()
	local heroes = FindUnitsInRadius(2, Entities:FindByName(nil, "@overboss"):GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)

	for _, hero in pairs(heroes) do
		if hero:IsClone() then return end
		hero:ModifyGold(self.gold, false, DOTA_ModifyGold_Unspecified)
		hero:AddExperience(self.xp, DOTA_ModifyXP_Unspecified, false, true)
	end
end

---------------------------------------------------------------------

modifier_overthrow_gold_xp_granter_global = modifier_overthrow_gold_xp_granter_global or class({})

function modifier_overthrow_gold_xp_granter_global:IsHidden() return true end
function modifier_overthrow_gold_xp_granter_global:IsPurgable() return false end
function modifier_overthrow_gold_xp_granter_global:IsPurgeException() return false end

function modifier_overthrow_gold_xp_granter_global:GetTexture()
	return "alchemist_goblins_greed"
end

function modifier_overthrow_gold_xp_granter_global:OnCreated()
	if IsServer() then
		self.radius = 3400
		self.gold = 2
		self.xp = 3

		self:StartIntervalThink(0.5)
	end
end

function modifier_overthrow_gold_xp_granter_global:OnIntervalThink()
	local heroes = FindUnitsInRadius(2, Entities:FindByName(nil, "@overboss"):GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)

	for _, hero in pairs(heroes) do
		if hero:IsClone() then return end
		hero:ModifyGold(self.gold, false, DOTA_ModifyGold_Unspecified)
		hero:AddExperience(self.xp, DOTA_ModifyXP_Unspecified, false, true)
	end
end
