--[[
		Author: EarthSalamander
		Date: 08/06/2020
		DD/MM/AAAA
]]

LinkLuaModifier("modifier_imba_trusty_shovel_passives", "components/items/item_trusty_shovel", LUA_MODIFIER_MOTION_NONE)

modifier_imba_trusty_shovel_passives = modifier_imba_trusty_shovel_passives or class({})

function modifier_imba_trusty_shovel_passives:IsHidden() return true end
function modifier_imba_trusty_shovel_passives:IsPurgable() return false end
function modifier_imba_trusty_shovel_passives:IsPurgeException() return false end

function modifier_imba_trusty_shovel_passives:DeclareFunctions() return {
	MODIFIER_PROPERTY_HEALTH_BONUS,
} end

function modifier_imba_trusty_shovel_passives:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health")
end

item_imba_trusty_shovel = item_imba_trusty_shovel or class({})

function item_imba_trusty_shovel:GetIntrinsicModifierName()
	return "modifier_imba_trusty_shovel_passives"
end

function item_imba_trusty_shovel:OnSpellStart()
	if not IsServer() then return end

	self.bounty_chance_threshold = self:GetSpecialValueFor("bounty_rune_chance")
	self.flask_chance_threshold = self:GetSpecialValueFor("flask_chance") + self.bounty_chance_threshold
	self.tp_chance_threshold = self:GetSpecialValueFor("tp_chance") + self.flask_chance_threshold
	self.kobold_chance_threshold = self:GetSpecialValueFor("kobold_chance") + self.tp_chance_threshold

	-- Okay let's not spawn a kobold on the first time, make love not warcraft
	if self.last_reward == nil then
		self.last_reward = "kobold"
	end

	self.pfx = ParticleManager:CreateParticle("particles/econ/events/ti9/shovel_dig.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(self.pfx, 0, self:GetCursorPosition())

	EmitSoundOn("SeasonalConsumable.TI9.Shovel.Dig", self:GetCaster())
end

function item_imba_trusty_shovel:OnChannelThink(fInterval)
	if not IsServer() then return end

end

function item_imba_trusty_shovel:OnChannelFinish(bInterrupted)
	if not IsServer() then return end

	-- successful channel
	if not bInterrupted then
		local random_int = RandomInt(1, 100)

		if random_int > 0 and random_int <= self.bounty_chance_threshold then
			if self.last_reward == "bounty" then
				self:OnChannelFinish(bInterrupted)
				return
			end

			self.last_reward = "bounty"

			CreateRune(self:GetCursorPosition(), DOTA_RUNE_BOUNTY)
		elseif random_int > self.bounty_chance_threshold and random_int <= self.flask_chance_threshold then
			if self.last_reward == "flask" then
				self:OnChannelFinish(bInterrupted)
				return
			end

			self.last_reward = "flask"

			self:SpawnItem("item_imba_flask", self:GetCursorPosition())
		elseif random_int > self.flask_chance_threshold and random_int <= self.tp_chance_threshold then
			if self.last_reward == "tp" then
				self:OnChannelFinish(bInterrupted)
				return
			end

			self.last_reward = "tp"

			self:SpawnItem("item_tpscroll", self:GetCursorPosition())
		elseif random_int > self.tp_chance_threshold and random_int <= self.kobold_chance_threshold then
			if self.last_reward == "kobold" then
				self:OnChannelFinish(bInterrupted)
				return
			end

			self.last_reward = "kobold"

			CreateUnitByName("npc_dota_neutral_kobold", self:GetCursorPosition(), true, nil, nil, DOTA_TEAM_NEUTRALS)
		end

		local pfx2 = ParticleManager:CreateParticle("particles/econ/events/ti9/shovel_revealed_generic.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(pfx2, 0, self:GetCursorPosition())
		ParticleManager:ReleaseParticleIndex(pfx2)
	end

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end

	StopSoundOn("SeasonalConsumable.TI9.Shovel.Dig", self:GetCaster())
end

function item_imba_trusty_shovel:SpawnItem(sItemName, vPos)
	local item = CreateItem(sItemName, nil, nil)
	item:SetSellable(false)
	item:SetShareability(ITEM_FULLY_SHAREABLE)
	CreateItemOnPositionSync(vPos, item)
end
