--[[	Author: Firetoad
		Date: 12.05.2017	]]

if modifier_contributor_statue == nil then
	modifier_contributor_statue = class({})
end

function modifier_contributor_statue:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

function modifier_contributor_statue:GetStatusEffectName()
--	return "particles/ambient/contributor_effigy_fx.vpcf"
end

function modifier_contributor_statue:IsHidden()
	return true
end

--[[	Author: EarthSalamander
		Date: 04.03.2021	]]


modifier_contributor_filler = modifier_contributor_filler or class({})

function modifier_contributor_filler:IsHidden() return true end
function modifier_contributor_filler:RemoveOnDeath() return false end

function modifier_contributor_filler:DeclareFunctions() return {
	MODIFIER_EVENT_ON_MODEL_CHANGED,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_EVENT_ON_DEATH,
} end

function modifier_contributor_filler:OnCreated()
	if not IsServer() then return end

	self.model = self:GetParent():GetModelName()
end

function modifier_contributor_filler:OnModelChanged()
	-- weird bugfix
	self:GetParent():SetModel(self.model)
	self:GetParent():SetOriginalModel(self.model)
	self:GetParent():StartGesture(ACT_DOTA_IDLE)
end

function modifier_contributor_filler:OnTakeDamage(keys)
	if keys.unit == self:GetParent() then
		if self:GetParent():GetModelName() ~= self.model then
			self:OnModelChanged()
		end
	end
end

function modifier_contributor_filler:OnDeath(keys)
	local player_name = PlayerResource:GetPlayerName(keys.attacker:GetPlayerOwnerID())

	if self:GetParent() == keys.unit then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(0), "send_effigy_death_message", {
			player_name = player_name,
			unit_name = self:GetParent():GetUnitName(),
		})

		if self:GetParent().pedestal and self:GetParent().pedestal:IsAlive() then
			self:GetParent().pedestal:ForceKill(false)
		end
	end
end
