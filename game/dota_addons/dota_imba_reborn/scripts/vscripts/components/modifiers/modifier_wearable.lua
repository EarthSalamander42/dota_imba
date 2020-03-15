modifier_wearable = class({})

function modifier_wearable:CheckState()
	local state = { 
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}

	return state
end

function modifier_wearable:IsPurgable()
	return false
end

function modifier_wearable:IsStunDebuff()
	return false
end

function modifier_wearable:IsPurgeException()
	return false
end

function modifier_wearable:IsHidden()
	return true
end

function modifier_wearable:OnCreated()
	if not IsServer() then return end

	self:StartIntervalThink(FrameTime())
	self.render_color = nil
end

function modifier_wearable:OnIntervalThink()
	local cosmetic = self:GetParent()
	local hero = cosmetic:GetOwnerEntity()
	if hero == nil then return end

	if self.render_color == nil then
		if hero:HasModifier("modifier_juggernaut_arcana") then
--			print("Jugg arcana 1, Color wearables!")
			self.render_color = true
			cosmetic:SetRenderColor(80, 80, 100)
		elseif hero:HasModifier("modifier_juggernaut_arcana") and hero:FindModifierByName("modifier_juggernaut_arcana"):GetStackCount() == 1 then
			print("Jugg arcana 2, Color wearables!")
			self.render_color = true
			cosmetic:SetRenderColor(255, 220, 220)
		elseif hero:GetUnitName() == "npc_dota_hero_vardor" then
			print("Vardor, Color wearables!")
			self.render_color = true
			cosmetic:SetRenderColor(255, 0, 0) -- not turning to red somehow :(
		end
	end

	for _,v in pairs(IMBA_INVISIBLE_MODIFIERS) do
		if not hero:HasModifier(v) then
			if cosmetic:HasModifier(v) then
				cosmetic:RemoveModifierByName(v)
			end
		else
			if not cosmetic:HasModifier(v) then
				cosmetic:AddNewModifier(cosmetic, nil, v, {})
				break -- remove this break if you want to add multiple modifiers at the same time
			end
		end
	end

	if hero:IsOutOfGame() or hero:IsHexed() then
		cosmetic:AddNoDraw()
	else
		cosmetic:RemoveNoDraw()
	end
end
