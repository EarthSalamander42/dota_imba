-- Author: Shush
-- Date: 31/07/2017

item_diretide_candy = class({})
LinkLuaModifier("modifier_diretide_candy_hp_loss", "items/item_candy", LUA_MODIFIER_MOTION_NONE)

function item_diretide_candy:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local modifier_candy = caster:FindModifierByName("modifier_diretide_candy_hp_loss")

		if target:IsBuilding() then
			print("Candy: Building!")
			if target:GetTeam() == DOTA_TEAM_GOODGUYS then
				CustomNetTables:SetTableValue("game_options", "radiant", {score = CustomNetTables:GetTableValue("game_options", "radiant").score +1})
			elseif target:GetTeam() == DOTA_TEAM_BADGUYS then
				CustomNetTables:SetTableValue("game_options", "dire", {score = CustomNetTables:GetTableValue("game_options", "dire").score +1})
			end
		elseif target:GetUnitName() == "npc_diretide_roshan" then
			print("Candy: Roshan!")
			local units = FindUnitsInRadius(1, Vector(0,0,0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
			for _, unit in ipairs(units) do
				if unit:GetName() == "npc_dota_roshan" then
					local AImod = unit:FindModifierByName("modifier_imba_roshan_ai_diretide")
					if AImod then AImod:Candy(unit) end
				end
			end
		elseif target:IsRealHero() then
			print("Candy: Real Hero!")
			-- make give a candy or a charge
		end

		-- Create the projectile
		local info = {
			Target = target,
			Source = caster,
			Ability = self,
			EffectName = "particles/hw_fx/hw_candy_drop.vpcf",
			bDodgeable = false,
			bProvidesVision = true,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
			iVisionRadius = 0,
			iVisionTeamNumber = caster:GetTeamNumber(),
			ExtraData = {special_cast = special_cast}
		}
		ProjectileManager:CreateTrackingProjectile( info )

		self:SetCurrentCharges(self:GetCurrentCharges()-1)
		if self:GetCurrentCharges() <= 0 then self:RemoveSelf() end
	end
end

function item_diretide_candy:GetIntrinsicModifierName()
	return "modifier_diretide_candy_hp_loss"
end

modifier_diretide_candy_hp_loss = class({})

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
		if not target:GetUnitName() == "npc_dota_candy_pumpkin" then
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