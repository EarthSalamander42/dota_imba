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
	if IsServer() then
		self:StartIntervalThink(FrameTime())
		self.render_color = nil
	end
end

function modifier_wearable:OnIntervalThink()
	local hero = self:GetParent():GetOwnerEntity()
	if hero == nil then return end

	if self.render_color == nil then
		if Battlepass:HasJuggernautArcana(self:GetParent():GetOwnerEntity():GetPlayerID()) == 0 then
			self.render_color = true
			self:GetParent():SetRenderColor(50, 50, 70)
		elseif Battlepass:HasJuggernautArcana(self:GetParent():GetOwnerEntity():GetPlayerID()) == 1 then
			self.render_color = true
			self:GetParent():SetRenderColor(255, 220, 220)
		elseif self:GetParent():GetOwnerEntity():GetUnitName() == "npc_dota_hero_vardor" then
			self.render_color = true
			self:GetParent():SetRenderColor(255, 0, 0) -- not turning to red somehow :(
		end
	end

	for _,v in pairs(IMBA_INVISIBLE_MODIFIERS) do
		if not hero:HasModifier(v) then
			if self:GetParent():HasModifier(v) then
				self:GetParent():RemoveModifierByName(v)
			end
		else
			if not self:GetParent():HasModifier(v) then
				self:GetParent():AddNewModifier(self:GetParent(), nil, v, {})
				break -- remove this break if you want to add multiple modifiers at the same time
			end
		end
	end

	if hero:IsOutOfGame() then
		self:GetParent():AddNoDraw()
	else
		self:GetParent():RemoveNoDraw()
	end
end
