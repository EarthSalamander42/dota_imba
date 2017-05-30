--[[
		By: AtroCty
		Date: 27.05.2017
		Updated:  27.05.2017
	]]
-------------------------------------------
--			RUSTY OLD SHOTGUN
-------------------------------------------
LinkLuaModifier("modifier_imba_shotgun_passive", "items/item_starfury.lua", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------
item_imba_shotgun = item_imba_shotgun or class({})
-------------------------------------------
function item_imba_shotgun:GetIntrinsicModifierName()
    return "modifier_imba_shotgun_passive"
end

-------------------------------------------
modifier_imba_shotgun_passive = modifier_imba_shotgun_passive or class({})
function modifier_imba_shotgun_passive:IsDebuff() return false end
function modifier_imba_shotgun_passive:IsHidden() return true end
function modifier_imba_shotgun_passive:IsPermanent() return true end
function modifier_imba_shotgun_passive:IsPurgable() return false end
function modifier_imba_shotgun_passive:IsPurgeException() return false end
function modifier_imba_shotgun_passive:IsStunDebuff() return false end
function modifier_imba_shotgun_passive:RemoveOnDeath() return false end
function modifier_imba_shotgun_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_shotgun_passive:OnDestroy()
	self:CheckUnique(false)
end

function modifier_imba_shotgun_passive:OnCreated()
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and self.item then
		self.bonus_damage = self.item:GetSpecialValueFor("bonus_damage")
		self.bonus_as = self.item:GetSpecialValueFor("bonus_as")
		self.bonus_agi = self.item:GetSpecialValueFor("bonus_agi")
	end
	if self.item then
		self.max_targets = self.item:GetSpecialValueFor("max_targets")
		self.proc_radius = self.item:GetSpecialValueFor("proc_radius")
		self.projectile_speed = self.item:GetSpecialValueFor("projectile_speed")
		self:CheckUnique(true)
	end
end

function modifier_imba_shotgun_passive:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_EVENT_ON_ATTACK_RECORD
    }
    return decFuns
end

function modifier_imba_shotgun_passive:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_imba_shotgun_passive:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_shotgun_passive:GetModifierBonusStats_Agility()
	return self.bonus_agi
end

function modifier_imba_shotgun_passive:OnAttackRecord(params)
	if IsServer() then
		if params.attacker == self.parent then
			if self.projectile_hit then
				self[params.record] = true
				self.projectile_hit = nil
			end
		end
	end
end
		

function modifier_imba_shotgun_passive:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self.parent then
			local no_projectile = true
			if self[params.record] then
				no_projectile = nil
				self[params.record] = nil
			end
			if self.item:IsCooldownReady() and (self:CheckUniqueValue(1,{"modifier_imba_starfury_passive"}) == 1) and no_projectile then
				local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.proc_radius, self.item:GetAbilityTargetTeam(), self.item:GetAbilityTargetType(), self.item:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
				-- If enemies found, start cooldown
				local counter = 0
				for _, enemy in pairs(enemies) do
					if enemy ~= params.target then
						local color = self.parent:GetFittingColor()
						projectile = {
							hTarget = enemy,
							hCaster = self.parent,
							vColor = color,
							hAbility = self.ability,
							iMoveSpeed = self.projectile_speed,
							EffectName = "particles/item/starfury/starfury_projectile.vpcf",
							flRadius = 1,
							bDodgeable = true,
							bDestroyOnDodge = true,
							iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
							OnProjectileHitUnit = function(params, projectileID)
								ProjectileHit(params, projectileID, self)
							end,
						}						
						TrackingProjectiles:Projectile(projectile)
						counter = counter + 1
						if counter == 1 then
							local bullet_pfx = ParticleManager:CreateParticle("particles/item/starfury/shotgun_eject_charlie.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
							ParticleManager:SetParticleControl(bullet_pfx, 0, self.parent:GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_ATTACK_1))
							ParticleManager:SetParticleControl(bullet_pfx, 4, color)
							self.item:UseResources(false, false, true)
							StartSoundEventFromPosition("Imba.Shotgun",self.parent:GetAbsOrigin())
						end
						if counter >= self.max_targets then
							break
						end
					end
				end
			end
		end
	end
end

function modifier_imba_shotgun_passive:OnAttackFail(params)
	self:OnAttackLanded(params)
end

-------------------------------------------
--			STARFURY
-------------------------------------------
LinkLuaModifier("modifier_imba_starfury_passive", "items/item_starfury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_starfury_reduce", "items/item_starfury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_starfury_buff_increase", "items/item_starfury.lua", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------
item_imba_starfury = item_imba_starfury or class({})
-------------------------------------------
function item_imba_starfury:GetIntrinsicModifierName()
    return "modifier_imba_starfury_passive"
end
-------------------------------------------
modifier_imba_starfury_passive = modifier_imba_starfury_passive or class({})
function modifier_imba_starfury_passive:IsDebuff() return false end
function modifier_imba_starfury_passive:IsHidden() return true end
function modifier_imba_starfury_passive:IsPermanent() return true end
function modifier_imba_starfury_passive:IsPurgable() return false end
function modifier_imba_starfury_passive:IsPurgeException() return false end
function modifier_imba_starfury_passive:IsStunDebuff() return false end
function modifier_imba_starfury_passive:RemoveOnDeath() return false end
function modifier_imba_starfury_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_starfury_passive:OnDestroy()
	self:CheckUnique(false)
end

function modifier_imba_starfury_passive:OnCreated()
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and self.item then
		self.bonus_damage = self.item:GetSpecialValueFor("bonus_damage")
		self.bonus_as = self.item:GetSpecialValueFor("bonus_as")
		self.bonus_agi = self.item:GetSpecialValueFor("bonus_agi")
		self.range = self.item:GetSpecialValueFor("range")
		self.proc_chance = self.item:GetSpecialValueFor("proc_chance")
		self.proc_duration = self.item:GetSpecialValueFor("proc_duration")
		self.projectile_speed = self.item:GetSpecialValueFor("projectile_speed")
		self:CheckUnique(true)
	end
end

function modifier_imba_starfury_passive:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_EVENT_ON_ATTACK_RECORD
    }
    return decFuns
end

function modifier_imba_starfury_passive:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_imba_starfury_passive:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_starfury_passive:GetModifierBonusStats_Agility()
	return self.bonus_agi
end

function modifier_imba_starfury_passive:OnAttackRecord(params)
	if IsServer() then
		if params.attacker == self.parent then
			if self.projectile_hit then
				self[params.record] = true
				self.projectile_hit = nil
				self.mod = self.parent:AddNewModifier(self.parent, self.item, "modifier_imba_starfury_reduce", {duration = FrameTime()})
			end
		end
	end
end
		

function modifier_imba_starfury_passive:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self.parent then
			if (RollPseudoRandom(self.proc_chance, self.item) and (self:CheckUniqueValue(1,{}) == 1) and (self.parent:IsClone() or self.parent:IsRealHero())) then
				self.parent:AddNewModifier(self.parent, self.item, "modifier_imba_starfury_buff_increase", {duration = self.proc_duration})
			end
			local no_projectile = true
			if self[params.record] then
				no_projectile = nil
				self[params.record] = nil
				self.mod:Destroy()
				self.mod = nil
			end
			if self.item:IsCooldownReady() and (self:CheckUniqueValue(1,{}) == 1) and no_projectile then
				target_loc = params.target:GetAbsOrigin()
				StartSoundEventFromPosition("Imba.Starfury",target_loc)
				local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), target_loc, nil, self.range, self.item:GetAbilityTargetTeam(), self.item:GetAbilityTargetType(), self.item:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
				-- If enemies found, start cooldown
				local bFound = false
				for _, enemy in pairs(enemies) do
					if enemy ~= params.target then
						projectile = {
							hTarget = enemy,
							hCaster = self.parent,
							vColor = self.parent:GetFittingColor(),
							hAbility = self.ability,
							iMoveSpeed = self.projectile_speed,
							EffectName = "particles/item/starfury/starfury_projectile.vpcf",
							flRadius = 1,
							bDodgeable = true,
							bDestroyOnDodge = true,
							vSpawnOrigin = target_loc,
							OnProjectileHitUnit = function(params, projectileID)
								ProjectileHit(params, projectileID, self)
							end,
						}
						TrackingProjectiles:Projectile(projectile)
						if not bFound then
							bFound = true
							self.item:UseResources(false, false, true)
						end
					end
				end
			end
		end
	end
end

function modifier_imba_starfury_passive:OnAttackFail(params)
	self:OnAttackLanded(params)
end

-------------------------------------------
modifier_imba_starfury_reduce = modifier_imba_starfury_reduce or class({})
function modifier_imba_starfury_reduce:IsDebuff() return false end
function modifier_imba_starfury_reduce:IsHidden() return false end
function modifier_imba_starfury_reduce:IsPurgable() return false end
function modifier_imba_starfury_reduce:IsPurgeException() return false end
function modifier_imba_starfury_reduce:IsStunDebuff() return false end
function modifier_imba_starfury_reduce:RemoveOnDeath() return true end
-------------------------------------------
function modifier_imba_starfury_reduce:OnCreated()
	local item = self:GetAbility()
	if item then
		self.dmg_reduction = item:GetSpecialValueFor("dmg_reduction")
	else
		self:Destroy()
	end
end

function modifier_imba_starfury_reduce:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
    }
    return decFuns
end

function modifier_imba_starfury_reduce:GetModifierDamageOutgoing_Percentage()
	return self.dmg_reduction * (-1)
end
-------------------------------------------
modifier_imba_starfury_buff_increase = modifier_imba_starfury_buff_increase or class({})
function modifier_imba_starfury_buff_increase:IsDebuff() return false end
function modifier_imba_starfury_buff_increase:IsHidden() return false end
function modifier_imba_starfury_buff_increase:IsPurgable() return true end
function modifier_imba_starfury_buff_increase:IsStunDebuff() return false end
function modifier_imba_starfury_buff_increase:RemoveOnDeath() return true end
-------------------------------------------
function modifier_imba_starfury_buff_increase:OnCreated()
	local hItem = self:GetAbility()
	local hParent = self:GetParent()
	if hItem and hParent and IsServer() then
		local agility = hParent:GetAgility()
		self:SetStackCount(hItem:GetSpecialValueFor("proc_bonus") * 0.01 * agility)
	end
end

function modifier_imba_starfury_buff_increase:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
    }
    return decFuns
end

function modifier_imba_starfury_buff_increase:GetModifierBonusStats_Agility()
	return self:GetStackCount()
end

function ProjectileHit(params, projectileID, modifier)
	-- Perform an instant attack on hit enemy
	local procs = false
	if params.hCaster:IsAlive() then
		procs = true
	end
	modifier.projectile_hit = true
	params.hCaster:PerformAttack(params.hTarget, procs, procs, true, true, false, false, false)
end