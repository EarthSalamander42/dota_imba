-- Author: MouJiaoZi
-- Date: 2017/12/02  YYYY/MM/DD

-- For battle pass
function GetForceStaffEffect(npc)
	local effect = "particles/items_fx/force_staff.vpcf"

	if Imbattlepass:GetRewardUnlocked(npc:GetPlayerID(), 18) == true then
		effect = "particles/econ/events/fall_major_2016/force_staff_fm06.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(npc:GetPlayerID(), 27) == true then
		effect = "particles/econ/events/ti7/force_staff_ti7.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(npc:GetPlayerID(), 45) == true then
		effect = "particles/econ/events/winter_major_2017/force_staff_wm07.vpcf"
	elseif Imbattlepass:GetRewardUnlocked(npc:GetPlayerID(), 54) == true then
		effect = "particles/econ/events/ti6/force_staff_ti6.vpcf"
	end

	return effect
end

item_imba_gungnir = item_imba_gungnir or class({})

LinkLuaModifier("modifier_item_imba_gungnir", "items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_gungnir_unique", "items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_gungnir_force_ally", "items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_gungnir_force_enemy_ranged", "items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_gungnir_force_enemy_melee", "items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_gungnir_force_self_ranged", "items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_gungnir_force_self_melee", "items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_gungnir_attack_speed", "items/item_gungnir", LUA_MODIFIER_MOTION_NONE)

function item_imba_gungnir:GetIntrinsicModifierName()
	return "modifier_item_imba_gungnir"
end

function item_imba_gungnir:OnSpellStart()
	if not IsServer() then return end
	local ability = self
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if caster:GetTeamNumber() == target:GetTeamNumber() then
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
		target:AddNewModifier(caster, ability, "modifier_item_imba_gungnir_force_ally", {duration = ability:GetSpecialValueFor("duration")})
	else
		if caster:IsRangedAttacker() then
			target:AddNewModifier(caster, ability, "modifier_item_imba_gungnir_force_enemy_ranged", {duration = ability:GetSpecialValueFor("duration")/2})
			caster:AddNewModifier(target, ability, "modifier_item_imba_gungnir_force_self_ranged", {duration = ability:GetSpecialValueFor("duration")/2})
		else
			target:AddNewModifier(caster, ability, "modifier_item_imba_gungnir_force_enemy_melee", {duration = ability:GetSpecialValueFor("duration")/2})
			caster:AddNewModifier(target, ability, "modifier_item_imba_gungnir_force_self_melee", {duration = ability:GetSpecialValueFor("duration")/2})
		end
		local buff = caster:AddNewModifier(caster, ability, "modifier_item_imba_gungnir_attack_speed", {duration = ability:GetSpecialValueFor("range_duration")})
		buff.target = target
		buff:SetStackCount(ability:GetSpecialValueFor("max_attacks"))
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", caster)
		local startAttack = {
							UnitIndex = caster:entindex(),
							OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
							TargetIndex = target:entindex(),}
		ExecuteOrderFromTable(startAttack)
	end
end

-------------------------------------
-----  STATE MODIFIER ---------------
-------------------------------------

modifier_item_imba_gungnir = modifier_item_imba_gungnir or class({})

function modifier_item_imba_gungnir:IsHidden() return true end
function modifier_item_imba_gungnir:IsPurgable() return false end
function modifier_item_imba_gungnir:IsDebuff() return false end
function modifier_item_imba_gungnir:RemoveOnDeath() return false end
function modifier_item_imba_gungnir:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_gungnir:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_gungnir_unique") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_imba_gungnir_unique", {})
		end
	end
end

function modifier_item_imba_gungnir:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_gungnir") then
			parent:RemoveModifierByName("modifier_item_imba_gungnir_unique")
		end
	end
end

function modifier_item_imba_gungnir:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					 MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					 MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					 MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					 MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
					 MODIFIER_EVENT_ON_ATTACK_LANDED,
					 MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
					 }
	return decFuncs
end

function modifier_item_imba_gungnir:CheckState()
	local state = 
	{
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}
	return state
end

function modifier_item_imba_gungnir:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_imba_gungnir:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_item_imba_gungnir:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_item_imba_gungnir:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

modifier_item_imba_gungnir_unique = modifier_item_imba_gungnir_unique or class({})

function modifier_item_imba_gungnir_unique:IsHidden() return true end
function modifier_item_imba_gungnir_unique:IsPurgable() return false end
function modifier_item_imba_gungnir_unique:IsDebuff() return false end
function modifier_item_imba_gungnir_unique:RemoveOnDeath() return false end

function modifier_item_imba_gungnir_unique:DeclareFunctions()
	local decFuncs = {
					 MODIFIER_EVENT_ON_ATTACK_LANDED,
					 MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
					 }
	return decFuncs
end

function modifier_item_imba_gungnir_unique:GetModifierAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() then
		return self:GetAbility():GetSpecialValueFor("ranged_bounce_ar")
	else
		return self:GetAbility():GetSpecialValueFor("melee_bounce_ar")
	end
end

function modifier_item_imba_gungnir_unique:OnAttackLanded( keys )
	if keys.attacker == self:GetParent() and keys.attacker:IsRealHero() and not keys.target:IsBuilding() then 
		if RollPseudoRandom(self:GetAbility():GetSpecialValueFor("bash_chance"), self) then
			local target = keys.target
			target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = 0.1})
			EmitSoundOn("DOTA_Item.MKB.Minibash", caster)
			local damageTable = {
					victim = target,
					attacker = self:GetParent(),
					damage = self:GetAbility():GetSpecialValueFor("bash_damage"),
					damage_type = DAMAGE_TYPE_PURE,
					ability = self:GetAbility(),
					}
			ApplyDamage(damageTable)
		end
	end
end

-------------------------------------
-----  ACTIVE MODIFIER --------------
-------------------------------------

modifier_item_imba_gungnir_force_ally = modifier_item_imba_gungnir_force_ally or class({})

function modifier_item_imba_gungnir_force_ally:IsDebuff() return false end
function modifier_item_imba_gungnir_force_ally:IsHidden() return true end
function modifier_item_imba_gungnir_force_ally:IsPurgable() return false end
function modifier_item_imba_gungnir_force_ally:IsStunDebuff() return false end
function modifier_item_imba_gungnir_force_ally:IsMotionController()  return true end
function modifier_item_imba_gungnir_force_ally:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_item_imba_gungnir_force_ally:OnCreated()
	if not IsServer() then return end
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = self:GetParent():GetForwardVector():Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("ally_distance") / ( self:GetDuration() / FrameTime())
	self.attacked_target = {}
end

function modifier_item_imba_gungnir_force_ally:GetEffectName() return "particles/items_fx/force_staff.vpcf" end

function modifier_item_imba_gungnir_force_ally:OnDestroy()
	if not IsServer() then return end
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_gungnir_force_ally:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	local attacker = self:GetParent()
	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(),
									attacker:GetAbsOrigin(),
									nil,
									160,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NONE,
									FIND_ANY_ORDER,
									false)
	for _,enemy in pairs(enemies) do
		if not self.attacked_target[enemy:entindex()] then
			attacker:PerformAttack(enemy, true, true, true, true, true, false, false)
			self.attacked_target[enemy:entindex()] = enemy:entindex()
		end
	end

	ProjectileManager:ProjectileDodge(self:GetParent())
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_gungnir_force_ally:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

function modifier_item_imba_gungnir_force_ally:CheckState()
	local state = 
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
	return state
end

modifier_item_imba_gungnir_force_enemy_ranged = modifier_item_imba_gungnir_force_enemy_ranged or class({})
modifier_item_imba_gungnir_force_self_ranged = modifier_item_imba_gungnir_force_self_ranged or class({})

function modifier_item_imba_gungnir_force_enemy_ranged:IsDebuff() return true end
function modifier_item_imba_gungnir_force_enemy_ranged:IsHidden() return true end
function modifier_item_imba_gungnir_force_enemy_ranged:IsPurgable() return false end
function modifier_item_imba_gungnir_force_enemy_ranged:IsStunDebuff() return false end
function modifier_item_imba_gungnir_force_enemy_ranged:IsMotionController()  return true end
function modifier_item_imba_gungnir_force_enemy_ranged:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_item_imba_gungnir_force_enemy_ranged:GetEffectName() return "particles/items_fx/force_staff.vpcf" end

function modifier_item_imba_gungnir_force_enemy_ranged:OnCreated()
	if not IsServer() then return end
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("enemy_distance_ranged") / ( self:GetDuration() / FrameTime())
end

function modifier_item_imba_gungnir_force_enemy_ranged:GetEffectName() return "particles/items_fx/force_staff.vpcf" end

function modifier_item_imba_gungnir_force_enemy_ranged:OnDestroy()
	if not IsServer() then return end
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_gungnir_force_enemy_ranged:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_gungnir_force_enemy_ranged:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

function modifier_item_imba_gungnir_force_self_ranged:IsDebuff() return false end
function modifier_item_imba_gungnir_force_self_ranged:IsHidden() return true end
function modifier_item_imba_gungnir_force_self_ranged:IsPurgable() return false end
function modifier_item_imba_gungnir_force_self_ranged:IsStunDebuff() return false end
function modifier_item_imba_gungnir_force_self_ranged:IgnoreTenacity() return true end
function modifier_item_imba_gungnir_force_self_ranged:IsMotionController()  return true end
function modifier_item_imba_gungnir_force_self_ranged:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_item_imba_gungnir_force_self_ranged:GetEffectName() return "particles/items_fx/force_staff.vpcf" end

function modifier_item_imba_gungnir_force_self_ranged:OnCreated()
	if not IsServer() then return end
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("enemy_distance_ranged") / ( self:GetDuration() / FrameTime())
end

function modifier_item_imba_gungnir_force_self_ranged:GetEffectName() return "particles/items_fx/force_staff.vpcf" end

function modifier_item_imba_gungnir_force_self_ranged:OnDestroy()
	if not IsServer() then return end
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_gungnir_force_self_ranged:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_gungnir_force_self_ranged:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

modifier_item_imba_gungnir_force_enemy_melee = modifier_item_imba_gungnir_force_enemy_melee or class({})
modifier_item_imba_gungnir_force_self_melee = modifier_item_imba_gungnir_force_self_melee or class({})

function modifier_item_imba_gungnir_force_enemy_melee:IsDebuff() return true end
function modifier_item_imba_gungnir_force_enemy_melee:IsHidden() return true end
function modifier_item_imba_gungnir_force_enemy_melee:IsPurgable() return false end
function modifier_item_imba_gungnir_force_enemy_melee:IsStunDebuff() return false end
function modifier_item_imba_gungnir_force_enemy_melee:IsMotionController()  return true end
function modifier_item_imba_gungnir_force_enemy_melee:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_item_imba_gungnir_force_enemy_melee:GetEffectName() return "particles/items_fx/force_staff.vpcf" end

function modifier_item_imba_gungnir_force_enemy_melee:OnCreated()
	if not IsServer() then return end
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("enemy_distance_melee") / ( self:GetDuration() / FrameTime())
end

function modifier_item_imba_gungnir_force_enemy_melee:GetEffectName() return "particles/items_fx/force_staff.vpcf" end

function modifier_item_imba_gungnir_force_enemy_melee:OnDestroy()
	if not IsServer() then return end
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_gungnir_force_enemy_melee:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_gungnir_force_enemy_melee:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

function modifier_item_imba_gungnir_force_self_melee:IsDebuff() return false end
function modifier_item_imba_gungnir_force_self_melee:IsHidden() return true end
function modifier_item_imba_gungnir_force_self_melee:IsPurgable() return false end
function modifier_item_imba_gungnir_force_self_melee:IsStunDebuff() return false end
function modifier_item_imba_gungnir_force_self_melee:IgnoreTenacity() return true end
function modifier_item_imba_gungnir_force_self_melee:IsMotionController()  return true end
function modifier_item_imba_gungnir_force_self_melee:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_item_imba_gungnir_force_self_melee:GetEffectName() return "particles/items_fx/force_staff.vpcf" end

function modifier_item_imba_gungnir_force_self_melee:OnCreated()
	if not IsServer() then return end
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("enemy_distance_melee") / ( self:GetDuration() / FrameTime())
end

function modifier_item_imba_gungnir_force_self_melee:GetEffectName() return "particles/items_fx/force_staff.vpcf" end

function modifier_item_imba_gungnir_force_self_melee:OnDestroy()
	if not IsServer() then return end
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_gungnir_force_self_melee:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_gungnir_force_self_melee:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

modifier_item_imba_gungnir_attack_speed = modifier_item_imba_gungnir_attack_speed or class({})

function modifier_item_imba_gungnir_attack_speed:IsDebuff() return false end
function modifier_item_imba_gungnir_attack_speed:IsHidden() return false end
function modifier_item_imba_gungnir_attack_speed:IsPurgable() return false end
function modifier_item_imba_gungnir_attack_speed:IsStunDebuff() return false end
function modifier_item_imba_gungnir_attack_speed:IgnoreTenacity() return true end
--function modifier_item_imba_gungnir_attack_speed:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_gungnir_attack_speed:OnCreated()
	if not IsServer() then return end
	self.as = 0
	self.ar = 0
	self:StartIntervalThink(FrameTime())
end

function modifier_item_imba_gungnir_attack_speed:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():GetAttackTarget() == self.target then
		self.as = self:GetAbility():GetSpecialValueFor("bounce_attack_speed")
		if self:GetParent():IsRangedAttacker() then
			self.ar = 999999
		end
	else
		self.as = 0
		if self:GetParent():IsRangedAttacker() then
			self.ar = 0
		end
	end
end

function modifier_item_imba_gungnir_attack_speed:DeclareFunctions()
	local decFuncs =   {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
						MODIFIER_EVENT_ON_ATTACK,
						MODIFIER_EVENT_ON_ORDER,
						MODIFIER_PROPERTY_ATTACK_RANGE_BONUS}
	return decFuncs
end

function modifier_item_imba_gungnir_attack_speed:GetModifierAttackSpeedBonus_Constant()
	if not IsServer() then return end
	return self.as
end

function modifier_item_imba_gungnir_attack_speed:GetModifierAttackRangeBonus()
	if not IsServer() then return end
	return self.ar
end

function modifier_item_imba_gungnir_attack_speed:OnAttack( keys )
	if not IsServer() then return end
	if keys.target == self.target and keys.attacker == self:GetParent() then
		if self:GetStackCount() > 1 then
			self:DecrementStackCount()
		else
			self:Destroy()
		end
	end
end


---------------------------------------------
--		item_imba_force_staff
---------------------------------------------
item_imba_force_staff = item_imba_force_staff or class({})
LinkLuaModifier("modifier_item_imba_force_staff", "items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_force_staff_active", "items/item_gungnir", LUA_MODIFIER_MOTION_NONE)

function item_imba_force_staff:GetIntrinsicModifierName()
	return "modifier_item_imba_force_staff"
end

function item_imba_force_staff:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		if caster:GetTeam() == target:GetTeam() and caster ~= target and target:IsMagicImmune() then
			return UF_FAIL_MAGIC_IMMUNE_ALLY
		elseif caster:GetTeam() ~= target:GetTeam() and target:IsMagicImmune() then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end
		return UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
	end
end

function item_imba_force_staff:OnSpellStart()
	if not IsServer() then return end
	local ability = self
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
	target:AddNewModifier(caster, ability, "modifier_item_imba_force_staff_active", {duration = ability:GetSpecialValueFor("duration")})
end

-------------------------------------
-----  STATE MODIFIER ---------------
-------------------------------------

modifier_item_imba_force_staff = modifier_item_imba_force_staff or class({})

function modifier_item_imba_force_staff:IsHidden() return true end
function modifier_item_imba_force_staff:IsPurgable() return false end
function modifier_item_imba_force_staff:IsDebuff() return false end
function modifier_item_imba_force_staff:RemoveOnDeath() return false end
function modifier_item_imba_force_staff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_force_staff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
					 MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					 }
	return decFuncs
end

function modifier_item_imba_force_staff:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end

function modifier_item_imba_force_staff:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

---------------------------------------
--------  ACTIVE BUFF -----------------
---------------------------------------

modifier_item_imba_force_staff_active = modifier_item_imba_force_staff_active or class({})

function modifier_item_imba_force_staff_active:IsDebuff() return false end
function modifier_item_imba_force_staff_active:IsHidden() return true end
function modifier_item_imba_force_staff_active:IsPurgable() return false end
function modifier_item_imba_force_staff_active:IsStunDebuff() return false end
function modifier_item_imba_force_staff_active:IsMotionController()  return true end
function modifier_item_imba_force_staff_active:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_item_imba_force_staff_active:OnCreated()
	if not IsServer() then return end
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = self:GetParent():GetForwardVector():Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("push_length") / ( self:GetDuration() / FrameTime())
end

function modifier_item_imba_force_staff_active:GetEffectName() return "particles/items_fx/force_staff.vpcf" end

function modifier_item_imba_force_staff_active:OnDestroy()
	if not IsServer() then return end
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_force_staff_active:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_force_staff_active:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end


---------------------------------------------
--		item_imba_hurricane_pike
---------------------------------------------
item_imba_hurricane_pike = item_imba_hurricane_pike or class({})