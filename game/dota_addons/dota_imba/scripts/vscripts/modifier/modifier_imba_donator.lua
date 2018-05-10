modifier_imba_donator = class({})

function modifier_imba_donator:IsHidden() return true end
function modifier_imba_donator:IsPurgable() return false end
function modifier_imba_donator:IsPurgeException() return false end

function modifier_imba_donator:OnCreated()
	if IsServer() then
		local steam_id = PlayerResource:GetSteamID(self:GetParent():GetPlayerID())
		self:SetStackCount(api.imba.is_donator(tostring(steam_id)))
	end
end

function modifier_imba_donator:GetEffectName()
	if self:GetStackCount() == 1 then
		return "particles/econ/events/ti7/ti7_hero_effect_2.vpcf"
	elseif self:GetStackCount() == 4 then
		return "particles/econ/events/ti7/ti7_hero_effect.vpcf"
	elseif self:GetStackCount() == 7 or self:GetStackCount() == 8 then
		return "particles/econ/events/ti8/ti8_hero_effect.vpcf"
	else
		return ""
	end
end

function modifier_imba_donator:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
