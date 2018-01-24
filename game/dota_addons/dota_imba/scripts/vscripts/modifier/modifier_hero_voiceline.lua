modifier_hero_voiceline = class({})

function modifier_hero_voiceline:IsHidden() return false end
function modifier_hero_voiceline:RemoveOnDeath() return false end

function modifier_hero_voiceline:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_RESPAWN,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_hero_voiceline:OnCreated()
	if IsServer() then
		HeroVoiceLine(self:GetParent(), "spawn")
		self:StartIntervalThink(1.0)
	end
end

function modifier_hero_voiceline:OnIntervalThink()
	if IsServer() then
		if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			if not self:GetParent().announce_horn then
				HeroVoiceLine(self:GetParent(), "battlebegins")
				self:GetParent().announce_horn = true
			end
		elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME then
			if not self:GetParent().announce_end_game then
				if self:GetParent():GetTeamNumber() == GAME_WINNER_TEAM then
					HeroVoiceLine(self:GetParent(), "win")
				else
					HeroVoiceLine(self:GetParent(), "lose")
				end
				self:GetParent().announce_end_game = true
			end
		end
	end
end

function modifier_hero_voiceline:OnOrder(keys)
	if keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
		HeroVoiceLine(self:GetParent(), "attack")
	elseif keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
		HeroVoiceLine(self:GetParent(), "move")
	elseif keys.order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM then

--		if itemName == "item_imba_blink" then
--			HeroVoiceLine(self:GetParent(), "blink")
--		end

		if RandomInt(1, 100) >= 50 then
			HeroVoiceLine(self:GetParent(), "purch", extra)
		end
	elseif keys.order_type == DOTA_UNIT_ORDER_CAST_POSITION or keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET or keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET_TREE or keys.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
		-- not using DOTA_UNIT_ORDER_CAST_TOGGLE
		HeroVoiceLine(self:GetParent(), "cast")
	end
end

function modifier_hero_voiceline:OnDeath(keys)
	if IsServer() then
		if self:GetParent() == keys.unit then
			HeroVoiceLine(self:GetParent(), "death")
		end
	end
end

function modifier_hero_voiceline:OnRespawn()
	if IsServer() then
		HeroVoiceLine(self:GetParent(), "respawn")
	end
end

function modifier_hero_voiceline:OnTakeDamage(keys)
	if self:GetParent() == keys.attacker then
		HeroVoiceLine(self:GetParent(), "pain")
	end
end
