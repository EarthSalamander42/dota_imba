LinkLuaModifier("modifier_overthrow_gold_xp_granter_buff", "components/modifiers/overthrow/modifier_overthrow_gold_xp_granter.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_overthrow_gold_xp_granter_global", "components/modifiers/overthrow/modifier_overthrow_gold_xp_granter.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_overthrow_gold_xp_granter_global_buff", "components/modifiers/overthrow/modifier_overthrow_gold_xp_granter.lua", LUA_MODIFIER_MOTION_NONE )

modifier_overthrow_gold_xp_granter = modifier_overthrow_gold_xp_granter or class({})

function modifier_overthrow_gold_xp_granter:IsHidden() return true end
function modifier_overthrow_gold_xp_granter:IsPurgable() return false end
function modifier_overthrow_gold_xp_granter:IsPurgeException() return false end
function modifier_overthrow_gold_xp_granter:IsAura() return true end
function modifier_overthrow_gold_xp_granter:GetAuraDuration() return 0.1 end
function modifier_overthrow_gold_xp_granter:GetAuraRadius() return 900 end
function modifier_overthrow_gold_xp_granter:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED end
function modifier_overthrow_gold_xp_granter:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_overthrow_gold_xp_granter:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_overthrow_gold_xp_granter:GetModifierAura() return "modifier_overthrow_gold_xp_granter_buff" end

modifier_overthrow_gold_xp_granter_buff = modifier_overthrow_gold_xp_granter_buff or class({})

function modifier_overthrow_gold_xp_granter_buff:IsHidden() return false end
function modifier_overthrow_gold_xp_granter_buff:IsDebuff() return false end
function modifier_overthrow_gold_xp_granter_buff:IsPurgable() return false end
function modifier_overthrow_gold_xp_granter_buff:IsPurgeException() return false end

function modifier_overthrow_gold_xp_granter_buff:GetTexture()
	return "custom/custom_games_xp_coin"
end

function modifier_overthrow_gold_xp_granter_buff:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsClone() then
			self.gold = 4
			self.xp = 6

			self:StartIntervalThink(0.5)
		end
	end
end

function modifier_overthrow_gold_xp_granter_buff:OnIntervalThink()
	self:GetParent():ModifyGold(self.gold, false, DOTA_ModifyGold_Unspecified)
	self:GetParent():AddExperience(self.xp, DOTA_ModifyXP_Unspecified, false, true)
end

---------------------------------------------------------------------

modifier_overthrow_gold_xp_granter_global = modifier_overthrow_gold_xp_granter_global or class({})

function modifier_overthrow_gold_xp_granter_global:IsHidden() return true end
function modifier_overthrow_gold_xp_granter_global:IsPurgable() return false end
function modifier_overthrow_gold_xp_granter_global:IsPurgeException() return false end
function modifier_overthrow_gold_xp_granter_global:IsAura() return true end
function modifier_overthrow_gold_xp_granter_global:GetAuraDuration() return 0.1 end
function modifier_overthrow_gold_xp_granter_global:GetAuraRadius() return 3000 end
function modifier_overthrow_gold_xp_granter_global:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED end
function modifier_overthrow_gold_xp_granter_global:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_overthrow_gold_xp_granter_global:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_overthrow_gold_xp_granter_global:GetModifierAura() return "modifier_overthrow_gold_xp_granter_global_buff" end

modifier_overthrow_gold_xp_granter_global_buff = modifier_overthrow_gold_xp_granter_global_buff or class({})

function modifier_overthrow_gold_xp_granter_global_buff:IsHidden() return false end
function modifier_overthrow_gold_xp_granter_global_buff:IsDebuff() return false end
function modifier_overthrow_gold_xp_granter_global_buff:IsPurgable() return false end
function modifier_overthrow_gold_xp_granter_global_buff:IsPurgeException() return false end

function modifier_overthrow_gold_xp_granter_global_buff:GetTexture()
	return "alchemist_goblins_greed"
end

function modifier_overthrow_gold_xp_granter_global_buff:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsClone() then
			self.gold = 2
			self.xp = 3

			self:StartIntervalThink(0.5)
		end
	end
end

function modifier_overthrow_gold_xp_granter_global_buff:OnIntervalThink()
	self:GetParent():ModifyGold(self.gold, false, DOTA_ModifyGold_Unspecified)
	self:GetParent():AddExperience(self.xp, DOTA_ModifyXP_Unspecified, false, true)
end
