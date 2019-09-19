-- Author: Shush
-- Date: 31/07/2017

LinkLuaModifier("modifier_diretide_candy_hp_loss", "components/items/item_candy", LUA_MODIFIER_MOTION_NONE)

item_diretide_candy = class({})

function item_diretide_candy:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local modifier_candy = caster:FindModifierByName("modifier_diretide_candy_hp_loss")

		if target:GetUnitName() == "npc_dota_good_candy_pumpkin" then
			if caster:GetTeamNumber() == 3 then return end

			for _, hero in pairs(HeroList:GetAllHeroes()) do
				hero:AddExperience(75, false, false)
				hero:ModifyGold(50, true, 0)
			end

			StartAnimation(target, {duration=1.0, activity=ACT_DOTA_ATTACK, rate=1.0})
			CustomNetTables:SetTableValue("game_options", "radiant", {score = CustomNetTables:GetTableValue("game_options", "radiant").score +1})
		elseif target:GetUnitName() == "npc_dota_bad_candy_pumpkin" then
			if caster:GetTeamNumber() == 2 then return end
			for _, hero in pairs(HeroList:GetAllHeroes()) do
				hero:AddExperience(75, false, false)
				hero:ModifyGold(50, true, 0)
			end

			StartAnimation(target, {duration=1.0, activity=ACT_DOTA_ATTACK, rate=1.0})
			CustomNetTables:SetTableValue("game_options", "dire", {score = CustomNetTables:GetTableValue("game_options", "dire").score +1})
		elseif target:GetUnitLabel() == "npc_diretide_roshan" then
			local AImod = target:FindModifierByName("modifier_imba_roshan_ai_diretide")
			if AImod then AImod:Candy(target) end
		elseif target:IsRealHero() then
			-- make give a candy or a charge
			return
		else
			print("NIL target, do nothing.")
			return
		end

		local info = {
			Target = target,
			Source = caster,
			Ability = self,
			EffectName = "particles/hw_fx/hw_candy_drop.vpcf", -- particles/hw_fx/hw_candy_projectile.vpcf
			bDodgeable = false,
			bProvidesVision = true,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
			iVisionRadius = 0,
			iVisionTeamNumber = caster:GetTeamNumber(),
--			ExtraData = {special_cast = special_cast}
		}
		ProjectileManager:CreateTrackingProjectile( info )

		-- candy use sound
--		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "", caster)
		self:SetCurrentCharges(self:GetCurrentCharges()-1)
		if self:GetCurrentCharges() <= 0 then self:RemoveSelf() end
	end
end

function item_diretide_candy:GetIntrinsicModifierName()
	return "modifier_diretide_candy_hp_loss"
end

modifier_diretide_candy_hp_loss = class({})

function modifier_diretide_candy_hp_loss:GetTexture()
	return "modifiers/greevil_taffy"
end

function modifier_diretide_candy_hp_loss:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()    

		-- Ability specials
		self.hp_loss_pct = self.ability:GetSpecialValueFor("hp_loss_pct")

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_diretide_candy_hp_loss:OnIntervalThink()
	if IsServer() then
		-- Get the current amount of charges of this item and set the stack count accordingly        
		if self.ability then
			local charges = self.ability:GetCurrentCharges()
			self:SetStackCount(charges)
		end

		-- Re-calculate health stats
		self.caster:CalculateStatBonus()

		if not self.caster.OverHeadJingu then 
			self.caster.OverHeadJingu = ParticleManager:CreateParticle("particles/hw_fx/candy_carrying_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self.caster)
			ParticleManager:SetParticleControl(self.caster.OverHeadJingu, 0, self.caster:GetAbsOrigin())
		end
		if self:GetStackCount() < 10 then
			ParticleManager:SetParticleControl(self.caster.OverHeadJingu, 2, Vector(0, self:GetStackCount(), 0))
		elseif self:GetStackCount() >= 10 and self:GetStackCount() < 20 then
			ParticleManager:SetParticleControl(self.caster.OverHeadJingu, 2, Vector(1, self:GetStackCount()-10, 0))
		elseif self:GetStackCount() >= 20 and self:GetStackCount() < 30 then
			ParticleManager:SetParticleControl(self.caster.OverHeadJingu, 2, Vector(2, self:GetStackCount()-20, 0))
		end
	end
end

function modifier_diretide_candy_hp_loss:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE}

	return decFuncs
end

function modifier_diretide_candy_hp_loss:GetModifierExtraHealthPercentage()
	if IsServer() then
		local hp_to_reduce = self.hp_loss_pct * 0.01 * self:GetStackCount() * (-1)
		-- Make sure you don't go over 100%
		if hp_to_reduce < -0.99 then
			return -0.99
		end

		return hp_to_reduce
	end
end

function modifier_diretide_candy_hp_loss:CastFilterResultTarget(target)
	if IsServer() then
		if not target:GetUnitName() == "npc_dota_good_candy_pumpkin" or not target:GetUnitName() == "npc_dota_bad_candy_pumpkin" then
			return UF_FAIL_CUSTOM
		end
		print("Wrong Target!")
		return UF_SUCCESS
	end
end

function modifier_diretide_candy_hp_loss:GetCustomCastErrorTarget(target) 
	if IsServer() then
		print("Wrong target message..")
		return "#dota_hud_error_cast_only_pumpkin"
	end
end

function modifier_diretide_candy_hp_loss:OnDestroy()
	self.caster = self:GetCaster()

	ParticleManager:DestroyParticle(self.caster.OverHeadJingu, false)
	ParticleManager:ReleaseParticleIndex(self.caster.OverHeadJingu)
	self.caster.OverHeadJingu = nil
end
