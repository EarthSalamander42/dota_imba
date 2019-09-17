-- Author: Nibuja: https://steamcommunity.com/profiles/76561198068804194/
-- Editor: EarthSalamander

LinkLuaModifier("modifier_yari_count", "components/abilities/heroes/hero_vardor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_celestial_yari_dummy", "components/abilities/heroes/hero_vardor.lua", LUA_MODIFIER_MOTION_NONE)

ListenToGameEvent("npc_spawned", function(keys)
	local npc = EntIndexToHScript(keys.entindex)

	if not IsValidEntity(npc) then
		return
	end

	if npc:GetUnitName() == "npc_dota_hero_vardor" then
		if npc.yari == nil then
			Timers:CreateTimer(0.2, function()
				print("[Yari] Init Yari...")
				Wearable:_WearProp(npc, "127", "body_head")
				Wearable:_WearProp(npc, "7749", "shoulder")
				Wearable:_WearProp(npc, "9460", "head")
				Wearable:_WearProp(npc, "7747", "belt")
				Wearable:_WearProp(npc, "7746", "arms")
				npc:SetRenderColor(255, 0, 0)

				npc.yari = {}
				npc.yari.targets = {}
				npc.yari.targetCount = 0

				if GetAbilitySpecial("vardor_return_of_the_yari", "initial_yari_count", 1) then
					npc.yari.count = GetAbilitySpecial("vardor_return_of_the_yari", "initial_yari_count", 1)
				else
					npc.yari.count = 1
				end

				if not npc:HasModifier("modifier_yari_count") then
					npc:AddNewModifier(npc, self, "modifier_yari_count", nil)
				end

				local yariCount = npc.yari.count
				if yariCount < 1 then yariCount = 0 end
				npc:SetModifierStackCount("modifier_yari_count", npc, yariCount)
			end)
		end
	end
end, nil)

function AddYari( keys )
	local caster = keys.caster
	local casterLoc = caster:GetAbsOrigin()

	local ability = keys.ability

	if caster.yari == nil then
		caster.yari = {}
		caster.yari.count = ability:GetSpecialValueFor("initial_yari_count")
	end

	local amount = ability:GetSpecialValueFor("bonus_yari")
	if caster:HasScepter() then
		amount = ability:GetSpecialValueFor("bonus_yari_scepter")
	end

	local talentBonus = caster:FindTalentValue("special_bonus_vardor_7")
	amount = amount + talentBonus

	local oldAmount = caster.yari.ultBonus
	if caster:HasModifier("modifier_celestial_yari_bonus") then
		caster.yari.count = caster.yari.count - oldAmount
	end
	caster.yari.ultBonus = amount

	caster.yari.count = caster.yari.count + amount
	local yariCount = caster.yari.count
	if yariCount < 1 then yariCount = 0 end
	caster:SetModifierStackCount("modifier_yari_count", caster, yariCount)

	local shotAbility = caster:FindAbilityByName("vardor_piercing_shot")
	if caster.yari.count == 0 then
		shotAbility:SetActivated(false)
	else
		shotAbility:SetActivated(true)
	end

	local duration = ability:GetSpecialValueFor("duration")
	talentBonus = caster:FindTalentValue("special_bonus_vardor_5")
	duration = duration + talentBonus

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_celestial_yari_bonus", {Duration = duration})

end


function ShowYari( keys )
	local caster = keys.caster
	local casterLoc = caster:GetAbsOrigin()
	local ability = keys.ability 

end

function RemoveYari( keys )
	local caster = keys.caster
	local casterLoc = caster:GetAbsOrigin()

	local ability = keys.ability

	local amount = ability:GetSpecialValueFor("bonus_yari")
	if caster:HasScepter() then
		amount  =  ability:GetSpecialValueFor("bonus_yari_scepter")
	end

	local talentBonus = caster:FindTalentValue("special_bonus_vardor_7")
	amount = amount + talentBonus

	caster.yari.count = caster.yari.count - amount
	local yariCount = caster.yari.count
	if yariCount < 1 then yariCount = 0 end
	caster:SetModifierStackCount("modifier_yari_count", caster, yariCount)

	local shotAbility = caster:FindAbilityByName("vardor_piercing_shot")
	if caster.yari.count == 0 then
		shotAbility:SetActivated(false)
	else
		shotAbility:SetActivated(true)
	end

end

function ChangeSpear( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- HideWearables(caster, ability)
end

modifier_yari_count = class({})

function modifier_yari_count:IsPurgable()
	return false
end

function modifier_yari_count:RemoveOnDeath()
	return false
end

function modifier_yari_count:IsDebuff()
	return false
end

function modifier_yari_count:GetTexture()
	return "phantom_lancer_spirit_lance"
end

function modifier_yari_count:DeclareFunctions()
	local funcs = {
			MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
			MODIFIER_PROPERTY_EXTRA_MANA_BONUS,
			MODIFIER_PROPERTY_TOOLTIP,
			MODIFIER_EVENT_ON_RESPAWN,
	}
	return funcs
end

function modifier_yari_count:OnCreated( event )
	if IsServer() then

		local caster = self:GetParent()
		local casterLoc = caster:GetAbsOrigin()

		caster.yari.particle = false
		caster.weaponParticle = false

		local spearHolder = CreateUnitByName("spearholder_unit", casterLoc, false, caster, caster, caster:GetTeam())
		spearHolder:SetAbsOrigin(casterLoc)
		spearHolder:AddNewModifier(caster, self, "modifier_celestial_yari_dummy", {EntIndex = caster:entindex(), Count = 0})
		self.spearHolder = spearHolder
	end
end

function modifier_yari_count:OnStackCountChanged( oldCount )
	if IsServer() then

		local caster = self:GetParent()
		local casterLoc = caster:GetAbsOrigin()
		local newCount = self:GetStackCount()

		if newCount == 0 then
			if caster.yari.particle then
				ParticleManager:DestroyParticle(caster.yari.particle, false)
				caster.yari.particle = false
			end

			if not caster.weaponParticle then
				local tempParticle = ParticleManager:CreateParticle("particles/yari_hold/yari_hold_01.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControlEnt(tempParticle, 1, caster, PATTACH_POINT_FOLLOW, "attach_weapon", casterLoc, true)
				ParticleManager:SetParticleControlEnt(tempParticle, 2, caster, PATTACH_POINT_FOLLOW, "attach_spear_end", casterLoc, true)
				caster.weaponParticle = tempParticle
			end

		elseif newCount > 0 then
			if caster.weaponParticle then
				ParticleManager:DestroyParticle(caster.weaponParticle, false)
				caster.weaponParticle = false
			end

			local ret = 1
			if caster.oppressReturn then
				if caster.oppressReturn == true then
					ret = 0
				end
			end

			if not caster.yari.particle then
				local tempParticle = ParticleManager:CreateParticle("particles/yari_hold/yari_hold_02.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControl(tempParticle, 10, Vector(ret, 0, 0))
				ParticleManager:SetParticleControlEnt(tempParticle, 1, caster, PATTACH_POINT_FOLLOW, "attach_weapon", casterLoc, true)
				ParticleManager:SetParticleControlEnt(tempParticle, 2, caster, PATTACH_POINT_FOLLOW, "attach_spear_end", casterLoc, true)
				caster.yari.particle = tempParticle
			end

			self.spearHolder:RemoveModifierByName("modifier_celestial_yari_dummy")
			self.spearHolder:AddNewModifier(caster, self, "modifier_celestial_yari_dummy", {EntIndex = caster:entindex(), Count = newCount - 1})
		end
	end
end

modifier_celestial_yari_dummy = class({})

function modifier_celestial_yari_dummy:CheckState()   
	local state = {
					[MODIFIER_STATE_UNSELECTABLE] = true,
					[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
					[MODIFIER_STATE_NO_HEALTH_BAR] = true,
					[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
					[MODIFIER_STATE_ATTACK_IMMUNE] = true,
					[MODIFIER_STATE_MAGIC_IMMUNE] = true,
				}
	return state
end

function modifier_celestial_yari_dummy:OnCreated( event )
	if IsServer() then
		self.target = EntIndexToHScript(event.EntIndex)
		self:StartIntervalThink(0.005)

		local parent = self:GetParent()
		local attachment = self.target:ScriptLookupAttachment("attach_hitloc")
		local targetLoc = self.target:GetAttachmentOrigin(attachment)
		local targetVec = self.target:GetForwardVector()

		local count = event.Count

		parent:SetAbsOrigin(targetLoc)
		parent:SetForwardVector(targetVec)

		if self.particle then
			ParticleManager:DestroyParticle(self.particle, false)
		end
		if self.particle2 then
			ParticleManager:DestroyParticle(self.particle2, false)
		end
		if self.particle3 then
			ParticleManager:DestroyParticle(self.particle3, false)
		end

		local ret = 1
		if self.target.oppressReturn then
			if self.target.oppressReturn == true then
				ret = 0
			end
		end

		if count == 1 then
			local tempParticle = ParticleManager:CreateParticle("particles/yari_hold/yari_hold_little_02.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, parent)
			ParticleManager:SetParticleControl(tempParticle, 10, Vector(ret, 0, 0))
			ParticleManager:SetParticleControlEnt(tempParticle, 1, parent, PATTACH_POINT_FOLLOW, "spear_pos_1_end", parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(tempParticle, 2, parent, PATTACH_POINT_FOLLOW, "spear_pos_1", parent:GetAbsOrigin(), true)
			self.particle = tempParticle

		elseif count == 2 then
			local tempParticle = ParticleManager:CreateParticle("particles/yari_hold/yari_hold_little_02.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, parent)
			ParticleManager:SetParticleControl(tempParticle, 10, Vector(ret, 0, 0))
			ParticleManager:SetParticleControlEnt(tempParticle, 1, parent, PATTACH_POINT_FOLLOW, "spear_pos_2_end", parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(tempParticle, 2, parent, PATTACH_POINT_FOLLOW, "spear_pos_2", parent:GetAbsOrigin(), true)
			self.particle = tempParticle

			tempParticle = ParticleManager:CreateParticle("particles/yari_hold/yari_hold_little_02.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, parent)
			ParticleManager:SetParticleControl(tempParticle, 10, Vector(ret, 0, 0))
			ParticleManager:SetParticleControlEnt(tempParticle, 1, parent, PATTACH_POINT_FOLLOW, "spear_pos_3_end", parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(tempParticle, 2, parent, PATTACH_POINT_FOLLOW, "spear_pos_3", parent:GetAbsOrigin(), true)
			self.particle2 = tempParticle

		elseif count == 3 then
			local tempParticle = ParticleManager:CreateParticle("particles/yari_hold/yari_hold_little_02.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, parent)
			ParticleManager:SetParticleControl(tempParticle, 10, Vector(ret, 0, 0))
			ParticleManager:SetParticleControlEnt(tempParticle, 1, parent, PATTACH_POINT_FOLLOW, "spear_pos_2_end", parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(tempParticle, 2, parent, PATTACH_POINT_FOLLOW, "spear_pos_2", parent:GetAbsOrigin(), true)
			self.particle = tempParticle

			tempParticle = ParticleManager:CreateParticle("particles/yari_hold/yari_hold_little_02.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, parent)
			ParticleManager:SetParticleControl(tempParticle, 10, Vector(ret, 0, 0))
			ParticleManager:SetParticleControlEnt(tempParticle, 1, parent, PATTACH_POINT_FOLLOW, "spear_pos_3_end", parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(tempParticle, 2, parent, PATTACH_POINT_FOLLOW, "spear_pos_3", parent:GetAbsOrigin(), true)
			self.particle2 = tempParticle

			tempParticle = ParticleManager:CreateParticle("particles/yari_hold/yari_hold_little_02.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, parent)
			ParticleManager:SetParticleControl(tempParticle, 10, Vector(ret, 0, 0))
			ParticleManager:SetParticleControlEnt(tempParticle, 1, parent, PATTACH_POINT_FOLLOW, "spear_pos_1_end", parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(tempParticle, 2, parent, PATTACH_POINT_FOLLOW, "spear_pos_1", parent:GetAbsOrigin(), true)
			self.particle3 = tempParticle
		end
	end
end

function modifier_celestial_yari_dummy:OnIntervalThink()
	if IsServer() then
		if self.target then
			local attachment = self.target:ScriptLookupAttachment("attach_hitloc")
			local targetLoc = self.target:GetAttachmentOrigin(attachment)
			local targetVec = self.target:GetForwardVector()

			self:GetParent():SetAbsOrigin(targetLoc)
			self:GetParent():SetForwardVector(targetVec)
		end
	end
end

function modifier_celestial_yari_dummy:OnDestroy()
	if IsServer() then
		if self.particle then
			ParticleManager:DestroyParticle(self.particle, false)
		end
		if self.particle2 then
			ParticleManager:DestroyParticle(self.particle2, false)
		end
		if self.particle3 then
			ParticleManager:DestroyParticle(self.particle3, false)
		end
	end
end

LinkLuaModifier("modifier_graceful_jump_movement", "components/abilities/heroes/hero_vardor.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_graceful_jump_teleport", "components/abilities/heroes/hero_vardor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_graceful_jump_dummy", "components/abilities/heroes/hero_vardor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_graceful_jump_hidden", "components/abilities/heroes/hero_vardor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_graceful_jump_count", "components/abilities/heroes/hero_vardor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_graceful_jump_count_hidden", "components/abilities/heroes/hero_vardor.lua", LUA_MODIFIER_MOTION_NONE)

--Spell Function

vardor_graceful_jump = class({})

function vardor_graceful_jump:OnUpgrade()
	local caster = self:GetCaster()
	if not caster:HasModifier("modifier_graceful_jump_count_hidden") and not caster:HasModifier("modifier_graceful_jump_count") then
		caster:AddNewModifier(caster, self, "modifier_graceful_jump_count_hidden", nil)
	end
end

function vardor_graceful_jump:CastFilterResultTarget( target )
	if self:GetCaster() == target then
		return UF_FAIL_CUSTOM
	end
	if not target:IsHero() and not target:HasModifier("modifier_piercing_shot_dummy_slow_aura") then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function vardor_graceful_jump:GetCustomCastErrorTarget( target )
	if self:GetCaster() == target then
		return "#dota_hud_error_cant_cast_on_self"
	else
		return "Can only target heroes or yaris"
	end
end

function vardor_graceful_jump:OnAbilityPhaseStart()
	if not IsServer() then return end

	local active_remnants = self:GetCaster().yari.targets

	if #active_remnants == 0 and self:GetCursorTarget() == nil then
		DisplayError(self:GetCaster():GetPlayerID(), "No active spear.")
		return false
	end

	-- init/remove previous
	self.target = nil

	if self:GetCursorTarget() then
		self.target = self:GetCursorTarget()
	end

--[[
	if closest_distance <= self:GetSpecialValueFor("max_range") then

	else
		DisplayError(caster:GetPlayerID(), "Spear is too far away!")
		return false
	end
--]]

	return true
end

function vardor_graceful_jump:OnSpellStart()
	local caster = self:GetCaster()

	if caster:HasTalent("special_bonus_vardor_6") then
		local modifier = caster:FindModifierByName("modifier_graceful_jump_count")
		modifier:DecrementStackCount()
		local count = modifier:GetStackCount()

		if count > 0 then
			self:EndCooldown()
		elseif count == 0 then
			local duration = modifier:GetRemainingTime()

			if duration > 0 then
				self:EndCooldown()
				self:StartCooldown(duration)
			end
		end
	end

	EmitSoundOnLocationWithCaster(self:GetCursorPosition(), "Hero_SkywrathMage.ConcussiveShot.Cast", caster)

	print("Target:", self.target)

	if self.target then
		print("Target:", self.target:GetUnitName())

--		if self.target:HasModifier("modifier_piercing_shot_stuck") or self.target:HasModifier("modifier_piercing_shot_dummy_slow_aura") then
			print("Teleport")
			Teleport(self)
--		else
--			print("Jump")
--			Jump(self)
--		end

		return
	end

	local active_remnants = caster.yari.targets

	print(#active_remnants)

	if active_remnants[1] then
		local closest_remnant_position = active_remnants[1]:GetAbsOrigin()
		local closest_distance = (closest_remnant_position - self:GetCursorPosition()):Length2D()

		self.target = active_remnants[1]

		print(self.target:GetUnitName(), self.target:entindex())

		for _, spear in pairs(active_remnants) do
			if (spear:GetAbsOrigin() - self:GetCursorPosition()):Length2D() < closest_distance then
				self.target = spear
				closest_remnant_position = spear:GetAbsOrigin()
				closest_distance = (closest_remnant_position - self:GetCursorPosition()):Length2D()
			end
		end

		if self.target:HasModifier("modifier_piercing_shot_stuck") or self.target:HasModifier("modifier_piercing_shot_dummy_slow_aura") then
			Teleport(self)
		else
			Jump(self)
		end
	end
end

function Teleport(self)
	local caster = self:GetCaster()

	local casterLoc = caster:GetAbsOrigin()
	local casterLocG = GetGroundPosition(casterLoc, caster)
	local targetLoc = self.target:GetAbsOrigin()
	local targetLocG = GetGroundPosition(targetLoc, self.target)

	local projectileSpeed = self:GetSpecialValueFor("jump_speed")

	local endTinker = CreateUnitByName("npc_dota_vardor_spear_dummy", targetLocG, false, caster, caster, caster:GetTeam())
	endTinker:SetAbsOrigin(targetLocG)
	endTinker:SetModelScale(0)
	endTinker:AddNewModifier(caster, self, "modifier_graceful_jump_dummy", {EntIndex = self.target:entindex(), StartX = casterLoc.x, StartY = casterLoc.y, StartZ = casterLoc.z})

	local startTinker = CreateUnitByName("npc_dota_vardor_spear_dummy", targetLocG, false, caster, caster, caster:GetTeam())
	startTinker:SetModel("models/development/invisiblebox.vmdl")
	startTinker:SetOriginalModel("models/development/invisiblebox.vmdl")
	startTinker:SetAbsOrigin(casterLocG)
	startTinker:SetModelScale(0)

	caster:AddNewModifier(caster, self, "modifier_graceful_jump_hidden", nil)

	-- local particle = ParticleManager:CreateParticle("particles/graceful_jump/graceful_jump.vpcf", PATTACH_ABSORIGIN, caster)
	-- ParticleManager:SetParticleControl(particle, 0, casterLoc)
	-- ParticleManager:SetParticleControl(particle, 1, targetLoc)

	local particleName = "particles/graceful_jump/graceful_jump_projectile.vpcf"
	local projectileTable = {
				Source = startTinker,
				Target = endTinker,
				Ability = self,  
				EffectName = particleName,
				iMoveSpeed = projectileSpeed,
				vSourceLoc= casterLocG,				-- Optional (HOW)
				bDrawsOnMinimap = false,						  -- Optional
				bDodgeable = false,								-- Optional
				bIsAttack = false,								-- Optional
				bVisibleToEnemies = true,						 -- Optional
				bReplaceExisting = false,						 -- Optional
				bProvidesVision = true,						   -- Optional
				iVisionRadius = 400,							  -- Optional
				iVisionTeamNumber = caster:GetTeamNumber()		-- Optional
			}	   
	ProjectileManager:CreateTrackingProjectile(projectileTable)
	startTinker:ForceKill(false)

end

function vardor_graceful_jump:OnProjectileHit(target, location)
	local caster = self:GetCaster()
	local targetLoc = target:GetAbsOrigin()

	EndJump(caster, self.target, self, targetLoc)

	caster:SetAbsOrigin(targetLoc)
	caster:RemoveModifierByName("modifier_graceful_jump_hidden")
	EmitSoundOnLocationWithCaster(targetLoc, "Hero_SkywrathMage.ConcussiveShot.Target", caster)

	target:RemoveSelf()
end

function vardor_graceful_jump:OnProjectileThink( location )
	local caster = self:GetCaster()
	local locG = GetGroundPosition(location, caster)

	caster:SetAbsOrigin(locG)
end

function Jump(self)
	local caster = self:GetCaster()
	local casterLoc = caster:GetAbsOrigin()
	local targetLoc = self.target:GetAbsOrigin()
	local speed = 1400

	caster:Stop()

	-- Motion Controller Data
	self.speed = speed
	self.maxZ = 200
	self.curZ = 0
	self.initDist = (targetLoc - casterLoc):Length2D()
	self.travDist = 0

	caster:AddNewModifier(caster, self, "modifier_graceful_jump_movement", nil)
end

function EndJump(caster, target, ability, location)

	caster.oppressReturn = true
	local casterLoc = caster:GetAbsOrigin()

	local particle = ParticleManager:CreateParticle("particles/graceful_jump_ground.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, location)
	
	local damageTable = {
		attacker = caster,
		ability = ability,
		damage_type = ability:GetAbilityDamageType(),
	}
	local radius = ability:GetSpecialValueFor("damage_radius")
	local targetTeams = DOTA_UNIT_TARGET_TEAM_ENEMY
--	local targetTypes = ability:GetAbilityTargetType()
	local targetTypes = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local targetFlags = ability:GetAbilityTargetFlags()

	if target:HasModifier("modifier_piercing_shot_stuck") then
		damageTable.damage = ability:GetSpecialValueFor("spear_damage")

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, radius, targetTeams, targetTypes, targetFlags, FIND_CLOSEST, false) 
		for _,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
		end

		target:RemoveModifierByName("modifier_piercing_shot_stuck")

	elseif target:HasModifier("modifier_piercing_shot_dummy_slow_aura") then
		damageTable.damage = ability:GetSpecialValueFor("spear_damage")

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, radius, targetTeams, targetTypes, targetFlags, FIND_CLOSEST, false) 
		for _,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
		end

		target:RemoveModifierByName("modifier_dummy_health")
		target:RemoveSelf()
	else
		damageTable.damage = ability:GetSpecialValueFor("low_damage")
		damageTable.victim = target
		ApplyDamage(damageTable)
	end

	FindClearSpaceForUnit(caster, location, true)

	Timers:CreateTimer(0.1, function()
		caster.oppressReturn = false
	end)
end

function OnMotionDone(self, location)
	local caster = self:GetCaster()
	local target = self.target
	local ability = self:GetAbility()

	EndJump(caster, target, ability, target:GetAbsOrigin())
end


--Modifiers

modifier_graceful_jump_movement = class({})

function modifier_graceful_jump_movement:IsHidden() return true end
function modifier_graceful_jump_movement:IsDebuff() return false end
function modifier_graceful_jump_movement:IsPurgable() return true end

function modifier_graceful_jump_movement:OnCreated( event )
	if IsServer() then
		self.target = self:GetAbility().target
		self.speed = self:GetAbility().speed
		self.maxZ = self:GetAbility().maxZ
		self.curZ = self:GetAbility().curZ
		self.initDist = self:GetAbility().initDist
		self.travDist = self:GetAbility().travDist
		self.parent = self:GetParent()
		self:ApplyHorizontalMotionController()
		self:ApplyVerticalMotionController()

		print("modifier_graceful_jump_movement:OnCreated")
	end
end
	
function modifier_graceful_jump_movement:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local caster = me
		local target = self.target

		local targetLoc = GetGroundPosition(target:GetAbsOrigin(), target)
		local targetLocG = GetGroundPosition(targetLoc, target)
		local casterLoc = GetGroundPosition(caster:GetAbsOrigin(), caster)
		local casterLocG = GetGroundPosition(casterLoc, caster)
		local direction = (targetLocG - casterLocG):Normalized()
		local maxDist = self:GetAbility():GetSpecialValueFor("short_range") * 2
		local distance = (targetLoc - casterLoc):Length2D()

		print(self.travDist, maxDist)
--		if self.travDist >= maxDist then
--			caster:InterruptMotionControllers(true)
--			caster:RemoveModifierByName("modifier_graceful_jump_movement")
--			FindClearSpaceForUnit(caster, casterLocG, true)
--		end

		if distance > 20 then
			local newPos = casterLoc + direction * self.speed * dt
			caster:SetAbsOrigin(newPos)
		else
			caster:InterruptMotionControllers(true)
			caster:RemoveModifierByName("modifier_graceful_jump_movement")
			caster:SetAbsOrigin(casterLocG)
			FindClearSpaceForUnit(caster, casterLocG, true)
			OnMotionDone(self)
		end
	end
end

function modifier_graceful_jump_movement:UpdateVerticalMotion(me, dt)
	if IsServer() then
		local caster = me
		local target = self.target
		local casterLoc = caster:GetAbsOrigin()
		local casterLocG = GetGroundPosition(casterLoc, caster)
		local targetLoc = target:GetAbsOrigin()
		local targetLocG = GetGroundPosition(targetLoc, target)
		local direction = (targetLocG - casterLocG):Normalized()
		local distance = (targetLoc - casterLoc):Length2D()

		if casterLoc.z < casterLocG.z then
			caster:SetAbsOrigin(casterLocG)
		end

		if distance > (self.initDist / 2) then
			self.curZ = self.curZ + self.speed * dt
		elseif distance < (self.initDist / 3) then
			self.curZ = self.curZ - self.speed * 2 * dt
		end
		if self.curZ > self.maxZ then
			self.curZ = self.maxZ
		elseif self.curZ < 0 then
			self.curZ = 0
		end

		caster:SetAbsOrigin(casterLocG + Vector(0,0, self.curZ))
	end
end

function modifier_graceful_jump_movement:OnDestroy()
	if IsServer() then
		print("modifier_graceful_jump_movement:OnCreated")
		self.parent:RemoveHorizontalMotionController( self )
		self.parent:RemoveVerticalMotionController( self )
		Timers:CreateTimer(FrameTime(), function()
			FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
		end)
	end
end

function modifier_graceful_jump_movement:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.parent:RemoveModifierByName("modifier_graceful_jump_movement")
	end
end

function modifier_graceful_jump_movement:OnVerticalMotionInterrupted()
	if IsServer() then
		self.parent:RemoveModifierByName("modifier_graceful_jump_movement")
	end
end

modifier_graceful_jump_teleport = class ({})

function modifier_graceful_jump_teleport:IsHidden()
	return true
end

function modifier_graceful_jump_teleport:IsDebuff()
	return false
end

function modifier_graceful_jump_teleport:IsPurgable()
	return false
end

function modifier_graceful_jump_teleport:OnCreated( event )
	if IsServer() then
		self.target = self:GetAbility().target
		self:ApplyVerticalMotionController()
	end
end

function modifier_graceful_jump_teleport:UpdateVerticalMotion(me, dt)
	local caster = me
	local casterLoc = caster:GetAbsOrigin()
	local casterLocG = GetGroundPosition(casterLoc, caster)
	local speed = 1500 * dt

	if casterLoc.z > casterLocG.z then
		local newLoc = casterLoc - Vector(0,0,speed)
		caster:SetAbsOrigin(newLoc)
	else
		caster:RemoveModifierByName("modifier_graceful_jump_teleport")
		FindClearSpaceForUnit(caster, casterLocG, true)
		caster:InterruptMotionControllers(true)
		OnMotionDone(self)
	end
end

function modifier_graceful_jump_teleport:OnVerticalMotionInterrupted()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_graceful_jump_movement")
	end
end

modifier_graceful_jump_dummy = class({})

function modifier_graceful_jump_dummy:CheckState()   
	local state = {
					[MODIFIER_STATE_UNSELECTABLE] = true,
					[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
					[MODIFIER_STATE_NO_HEALTH_BAR] = true,
					[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
					[MODIFIER_STATE_ATTACK_IMMUNE] = true,
					[MODIFIER_STATE_MAGIC_IMMUNE] = true,
				}
	return state
end

function modifier_graceful_jump_dummy:OnCreated( event )
	if IsServer() then
		self.target = EntIndexToHScript(event.EntIndex)
		self.startLoc = Vector(event.StartX, event.StartY, event.StartZ)
		self:StartIntervalThink(0.05)
	end
end

function modifier_graceful_jump_dummy:OnIntervalThink()
	if IsServer() then
		if self.target then
			local targetLoc = self.target:GetAbsOrigin()
			local direction = (targetLoc - self.startLoc):Normalized()
			local newLoc = targetLoc - direction * self.target:GetHullRadius() * 2
			local newLocG = GetGroundPosition(newLoc, self:GetCaster())

			self:GetParent():SetAbsOrigin(newLocG)
		end
	end
end

modifier_graceful_jump_hidden = class({})

function modifier_graceful_jump_hidden:IsHidden()
	return true
end

function modifier_graceful_jump_hidden:IsDebuff()
	return false
end

function modifier_graceful_jump_hidden:IsPurgable()
	return false
end

function modifier_graceful_jump_hidden:CheckState()   
	local state = {
					[MODIFIER_STATE_UNSELECTABLE] = true,
					[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
					[MODIFIER_STATE_NO_HEALTH_BAR] = true,
					[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
					[MODIFIER_STATE_ATTACK_IMMUNE] = true,
					[MODIFIER_STATE_MAGIC_IMMUNE] = true,
					[MODIFIER_STATE_STUNNED] = true,
					[MODIFIER_STATE_INVULNERABLE] = true,
				}
	return state
end

function modifier_graceful_jump_hidden:OnCreated( event )
	if IsServer() then
		self:GetParent():AddNoDraw()
	end
end

function modifier_graceful_jump_hidden:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveNoDraw()
	end
end

modifier_graceful_jump_count_hidden = ({})

function modifier_graceful_jump_count_hidden:IsHidden()
	return true
end

function modifier_graceful_jump_count_hidden:IsDebuff()
	return false
end

function modifier_graceful_jump_count_hidden:IsPurgable()
	return false
end

function modifier_graceful_jump_count_hidden:OnCreated( event )
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_graceful_jump_count_hidden:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()

		if self:GetParent():HasTalent("special_bonus_vardor_6") then

			local parent = self:GetParent()
			self:Destroy()

			Timers:CreateTimer(0.1, function()
				parent:AddNewModifier(parent, ability, "modifier_graceful_jump_count", nil)
			end)
		end
	end
end

modifier_graceful_jump_count = class({})

function modifier_graceful_jump_count:IsHidden()
	return false
end

function modifier_graceful_jump_count:IsDebuff()
	return false
end

function modifier_graceful_jump_count:IsPurgable()
	return false
end

function modifier_graceful_jump_count:OnCreated( event )
	if IsServer() then
		self.cooldown = 0
		self.curCooldown = 0
		self.tickRate = 0.1
		self:StartIntervalThink(self.tickRate)

		local cd = self:GetAbility():GetCooldownTimeRemaining()
		if cd > 0 then
			self:SetDuration(cd + 0.1, true)
			self.curCooldown = self:GetAbility():GetCooldown(self:GetAbility():GetLevel()) - cd
		else
			self:SetStackCount(1)
			self:SetDuration(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()) + 0.1, true)
		end
	end
end

function modifier_graceful_jump_count:OnIntervalThink()
	if IsServer() then

		local ability = self:GetAbility()

		if self:GetStackCount() < 2 then
			self.cooldown = ability:GetCooldown(ability:GetLevel())
			self.curCooldown = self.curCooldown + self.tickRate

			if self.curCooldown >= self.cooldown then
				self:IncrementStackCount()
				self.curCooldown = 0

				if self:GetStackCount() == 2 then
					self:SetDuration(-1, true)
				else
					self:SetDuration(self.cooldown + 0.1, true)
				end
			end
		end

		if self:GetDuration() < 0.1 and not self:GetDuration() == -1 then
			self:SetDuration(-1, false)
		end
	end
end

function modifier_graceful_jump_count:OnStackCountChanged( oldStackCount )
	if IsServer() then
		local newStackCount = self:GetStackCount()
		if oldStackCount == 1 and newStackCount == 0 then
			-- self:SetDuration(self:GetAbility():GetCooldownTimeRemaining() + 0.1, true)
		end
		if oldStackCount == 2 and newStackCount == 1 then
			self:SetDuration(self.cooldown + 0.1, true)
		end
	end
end

--=================================================================================================================
--Hero: Vardor
--Ability: Mental Thrusts
--Author: Nibuja
--Date: 02.09.2018
--=================================================================================================================

LinkLuaModifier("modifier_mind_bleeding", "components/abilities/heroes/hero_vardor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_yari_count", "components/abilities/heroes/hero_vardor.lua", LUA_MODIFIER_MOTION_NONE)


--===============================================================
--Increases the Stack counter of 'Mind Bleeding' with each attack
--===============================================================
function MentalThrustsHit(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	if target:IsHero() and target:IsAlive() and caster:IsRealHero() and caster.yari.count > 0 then
		AddMindBleeding(caster, target, caster.yari.count)
	end
end

function AddMindBleeding(caster, target, count)
	local ability = caster:FindAbilityByName("vardor_mental_thrusts")

	local abilityLevel = ability:GetLevel()

	if abilityLevel > 0 then
		local duration = ability:GetLevelSpecialValueFor("duration", abilityLevel - 1) 
		local reduction = ability:GetLevelSpecialValueFor("reduction", abilityLevel - 1)

		local talentBonus = caster:FindTalentValue("special_bonus_vardor_8")
		reduction = reduction + talentBonus 

		local modifierReduction = "modifier_mind_bleeding"

		SubstractValues(caster, target, -reduction)
		if target:HasModifier(modifierReduction) then
			currentStack = target:GetModifierStackCount(modifierReduction, ability) + count

			target:AddNewModifier(caster, ability, modifierReduction, { Duration = duration })
			target:SetModifierStackCount( modifierReduction, ability, currentStack)
		else
			target:AddNewModifier(caster, ability, modifierReduction, { Duration = duration })
			target:SetModifierStackCount( modifierReduction, ability, count )
		end

		if target:IsRealHero() then
			target:CalculateStatBonus()
		end
	end
end

--===================================
--Recuces the current health and mana
--===================================
function SubstractValues(caster, target, reduction)
	local ability = caster:FindAbilityByName("vardor_mental_thrusts")

	local damageTable = 
	{
		victim = target,
		attacker = caster,
		damage = reduction,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK,
		ability = ability,
	}
	ApplyDamage(damageTable)
	target:ReduceMana(reduction)
end

--================================
--Creates initial yari definitions
--================================
function LevelUp(keys)
	local caster = keys.caster
	local ability = keys.ability
	local abilityLevel = ability:GetLevel()

	if caster.yari == nil then
--		print("Init Yari!")
		caster.yari = {}
		caster.yari.count = 1
		caster.yari.targets = {}
		
		if not caster:HasModifier("modifier_yari_count") then
			caster:AddNewModifier(caster, self, "modifier_yari_count", nil)
		end

		local yariCount = caster.yari.count
		if yariCount < 1 then yariCount = 0 end
		caster:SetModifierStackCount("modifier_yari_count", caster, yariCount)
	end

end

modifier_mind_bleeding = class({})

function modifier_mind_bleeding:IsHidden() return false end
function modifier_mind_bleeding:IsDebuff() return true end
function modifier_mind_bleeding:IsPurgable() return false end
function modifier_mind_bleeding:RemoveOnDeath() return false end
function modifier_mind_bleeding:GetEffectName() return "particles/mental_thrusts_debuff.vpcf" end
function modifier_mind_bleeding:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_mind_bleeding:ShouldUseOverheadOffset() return true end

function modifier_mind_bleeding:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_EXTRA_MANA_BONUS,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_RESPAWN,
	}
	return funcs
end

function modifier_mind_bleeding:OnCreated( event )
	self.lastManaAmount = 0
end

function modifier_mind_bleeding:GetModifierExtraHealthBonus()
	local stackCount = self:GetStackCount()
	local reduction = self:GetAbility():GetSpecialValueFor("reduction")
	local talentBonus = self:GetCaster():FindTalentValue("special_bonus_vardor_8")
	reduction = reduction + talentBonus 

	local amount = stackCount * reduction

	if self:GetParent():GetMaxHealth() > amount then
		return amount
	end

	return 0
end

function modifier_mind_bleeding:GetModifierExtraManaBonus()
	local stackCount = self:GetStackCount()
	local reduction = self:GetAbility():GetSpecialValueFor("reduction")
	local talentBonus = self:GetCaster():FindTalentValue("special_bonus_vardor_8")
	reduction = reduction + talentBonus 

	local newAmount = stackCount * reduction
	local trueMaxMana = self:GetParent():GetMaxMana() + math.abs(self.lastManaAmount)
	if math.abs(newAmount) >= trueMaxMana then
		newAmount = -(trueMaxMana - 1)
	end
	self.lastManaAmount = newAmount
	return newAmount
end

function modifier_mind_bleeding:OnDeath(params)
	if not IsServer() then return end

	self:SetDuration(-1, true)
end

function modifier_mind_bleeding:OnRespawn( event )
	if IsServer() then
		local parent = self:GetParent()

		if event.unit == parent then
			Timers:CreateTimer(FrameTime(), function()
				print("heal!")
				local maxHP = parent:GetMaxHealth()
				local maxMana = parent:GetMaxMana()
				parent:SetHealth(maxHP)
				parent:SetMana(maxMana)
			end)
		end

		self:Destroy()
	end
end

LinkLuaModifier("modifier_piercing_shot_prevent_movement", "components/abilities/heroes/hero_vardor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dummy_health", "components/abilities/heroes/hero_vardor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_piercing_shot_dummy_slow_aura", "components/abilities/heroes/hero_vardor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_piercing_shot_slow", "components/abilities/heroes/hero_vardor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_piercing_shot_stuck", "components/abilities/heroes/hero_vardor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_yari_count", "components/abilities/heroes/hero_vardor.lua", LUA_MODIFIER_MOTION_NONE)

--Spell Function

vardor_piercing_shot = class({})

function table.clone(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in pairs(orig) do
			copy[orig_key] = orig_value
		end
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function vardor_piercing_shot:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():FindTalentValue("special_bonus_vardor_3")
end

function vardor_piercing_shot:OnUpgrade()
	local caster = self:GetCaster()

	local returnAbility = caster:FindAbilityByName("vardor_return_of_the_yari")
	if returnAbility:GetLevel() < 1 then
		returnAbility:SetLevel( 1 )
		returnAbility:SetActivated(false)
	end
end

function vardor_piercing_shot:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	if not (caster.yari.count > 0) then
		return false
	end
	return true
end

function vardor_piercing_shot:OnSpellStart()
	local caster = self:GetCaster()
	if caster.yari.count > 0 then
		caster.yari.count = caster.yari.count - 1
		local yariCount = caster.yari.count
		if yariCount < 1 then yariCount = 0 end
		caster:SetModifierStackCount("modifier_yari_count", caster, yariCount)
		local target = self:GetCursorTarget()
		if target ~= nil then
			PiercingShotCastHero(self)
		else
			--caster.yari.count = caster.yari.count + 1
			PiercingShotCastPoint(self)
		end

		if caster.yari.count == 0 then
			self:SetActivated(false)
		else
			self:SetActivated(true)
		end

		if caster.yari.count > 0 then
			self:EndCooldown()
		end

		EmitSoundOnLocationWithCaster(self:GetCursorPosition(), "Hero_EarthSpirit.StoneRemnant.Impact", caster)
	end
end

function PiercingShotCastHero(self)

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local damage = self:GetSpecialValueFor("damage")
	local duration = self:GetSpecialValueFor("spear_duration")
	local lanceProjectile = "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf"


	local damageTable = {
						attacker = caster,
						damage = damage,
						damage_type = self:GetAbilityDamageType(),
						victim = target,
						}

	target:AddNewModifier(caster, self, "modifier_piercing_shot_stuck", {Duration = duration})
	ApplyDamage(damageTable)

	table.insert(caster.yari.targets, target)
	caster.yari.targetCount = caster.yari.targetCount + 1

	local returnAbility = caster:FindAbilityByName("vardor_return_of_the_yari")
	if caster.yari.targetCount > 0 then
		returnAbility:SetActivated(true)
	else
		returnAbility:SetActivated(false)
	end
end

function PiercingShotCastPoint(self)
	local caster = self:GetCaster()
	local casterLoc = caster:GetAbsOrigin()
	local targetLoc = self:GetCursorPosition()

	local targetTeams = self:GetAbilityTargetTeam()
--	local targetTypes = self:GetAbilityTargetType()
	local targetTypes = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local targetFlags = self:GetAbilityTargetFlags()

	local rootDuration = self:GetSpecialValueFor("root_duration")
	local duration = self:GetSpecialValueFor("spear_duration")
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage_ground")

	local particle = ParticleManager:CreateParticle("particles/piercing_shot_ground_impact.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, targetLoc)
	self.spearParticle = particle

	local damageTable = {
		attacker = caster,
		ability = self,
		damage_type = self:GetAbilityDamageType(),
		damage = damage,
	}

	Timers:CreateTimer(self:GetSpecialValueFor("spawn_delay"), function()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), targetLoc, nil, radius, targetTeams, targetTypes, targetFlags, FIND_CLOSEST, false) 
		for _,enemy in pairs(enemies) do
			enemy:AddNewModifier(caster, self, "modifier_piercing_shot_prevent_movement", {Duration = rootDuration})
			damageTable.victim = enemy
			ApplyDamage(damageTable)
		end

		local dummy = CreateUnitByName("npc_dota_vardor_spear_dummy" , targetLoc, false, caster, caster, caster:GetTeamNumber())
		dummy:AddNewModifier(caster, self, "modifier_dummy_health", nil)
		dummy:AddNewModifier(caster, self, "modifier_piercing_shot_dummy_slow_aura", nil)
		dummy:AddNewModifier(caster, self, "modifier_kill", {Duration = duration})
		dummy:SetAbsOrigin(targetLoc + Vector(0,0,100))

		table.insert(caster.yari.targets, dummy)
	end)

	caster.yari.targetCount = caster.yari.targetCount + 1

	local returnAbility = caster:FindAbilityByName("vardor_return_of_the_yari")
	if caster.yari.targetCount > 0 then
		returnAbility:SetActivated(true)
	else
		returnAbility:SetActivated(false)
	end
end

function ReturnYari( keys )
	local caster = keys.caster

	local tempTable = table.clone(caster.yari.targets)

	caster.yari.count = caster.yari.count + #tempTable
	caster:SetModifierStackCount("modifier_yari_count", caster, caster.yari.count + #tempTable)

	if #tempTable > 0 then
		caster:FindAbilityByName("vardor_piercing_shot"):SetActivated(true)
	end

	for _,target in pairs(tempTable) do
		if target:HasModifier("modifier_piercing_shot_stuck") then
			target:RemoveModifierByName("modifier_piercing_shot_stuck")
		elseif target:HasModifier("modifier_piercing_shot_dummy_slow_aura") then
			target:RemoveSelf()
		end
	end

	caster.yari.targets = {}
end

---------------------------------------
--Applies 'Mind Bleeding' to the target
--Called from a modifier
---------------------------------------
function ApplyMentalThrusts(self)
	--Definitions
	local caster = self:GetCaster()
	local target = self:GetParent()

	AddMindBleeding(caster, target, 1)
end

--<===============================================>
--<-----------------> MODIFIER <------------------>
--<===============================================>

modifier_piercing_shot_prevent_movement = class({})

function modifier_piercing_shot_prevent_movement:IsHidden()
	return false
end

function modifier_piercing_shot_prevent_movement:IsDebuff()
	return true
end

function modifier_piercing_shot_prevent_movement:GetEffectName()
	return "particles/piercing_shot_ground_root.vpcf"
end

function modifier_piercing_shot_prevent_movement:GetEffectAttachType()
	return PATTACH_ABSORIGIN
end

function modifier_piercing_shot_prevent_movement:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state
end

modifier_dummy_health = class({})

function modifier_dummy_health:IsHidden()
	return true
end

function modifier_dummy_health:IsDebuff()
	return false
end

function modifier_dummy_health:CheckState()
	local state = {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}
	return state
end

function modifier_dummy_health:OnCreated( event )
	if IsServer() then
		self.particle = self:GetAbility().spearParticle
	end
end

function modifier_dummy_health:OnDestroy()
	if IsServer() then
		self:GetParent():SetModelScale(0)
		local caster = self:GetCaster()
		caster.yari.count = caster.yari.count + 1
		local yariCount = caster.yari.count
		if yariCount < 1 then yariCount = 0 end
		caster:SetModifierStackCount("modifier_yari_count", caster, yariCount)

		local index={}
		for k,v in pairs(caster.yari.targets) do
		   index[v]=k
		end
		table.remove(caster.yari.targets, index[self:GetParent()])
		caster.yari.targetCount = caster.yari.targetCount - 1 

		local returnAbility = caster:FindAbilityByName("vardor_return_of_the_yari")
		if caster.yari.targetCount > 0 then
			returnAbility:SetActivated(true)
		else
			returnAbility:SetActivated(false)
		end

		local shotAbility = caster:FindAbilityByName("vardor_piercing_shot")
		if caster.yari.count == 0 then
			shotAbility:SetActivated(false)
		else
			shotAbility:SetActivated(true)
		end

		ParticleManager:DestroyParticle(self.particle, false)
	end
end

modifier_piercing_shot_dummy_slow_aura = class({})

function modifier_piercing_shot_dummy_slow_aura:IsHidden()
	return false
end

function modifier_piercing_shot_dummy_slow_aura:IsDebuff()
	return false
end

function modifier_piercing_shot_dummy_slow_aura:IsAura()
	return true
end

function modifier_piercing_shot_dummy_slow_aura:GetModifierAura()
	return "modifier_piercing_shot_slow"
end

function modifier_piercing_shot_dummy_slow_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_piercing_shot_dummy_slow_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_piercing_shot_dummy_slow_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_piercing_shot_dummy_slow_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

modifier_piercing_shot_slow = class({})

function modifier_piercing_shot_slow:IsHidden()
	return false
end

function modifier_piercing_shot_slow:IsDebuff()
	return true
end

function modifier_piercing_shot_slow:IsPurgable()
	return false
end

function modifier_piercing_shot_slow:GetEffectName()
	return "particles/piercing_shot_ground_slow.vpcf"
end

function modifier_piercing_shot_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_piercing_shot_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_piercing_shot_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end

modifier_piercing_shot_stuck = class({})

function modifier_piercing_shot_stuck:IsHidden() return false end
function modifier_piercing_shot_stuck:IsDebuff() return true end
function modifier_piercing_shot_stuck:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- function modifier_piercing_shot_stuck:GetEffectName()
-- 	return "particles/piercing_shot_debuff.vpcf"
-- end

-- function modifier_piercing_shot_stuck:GetEffectAttachType()
-- 	return PATTACH_CUSTOMORIGIN_FOLLOW
-- end

function modifier_piercing_shot_stuck:DeclareFunctions() return {
	MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
} end

function modifier_piercing_shot_stuck:OnCreated( event )
	if IsServer() then
		ApplyMentalThrusts(self)
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("think_interval"))
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_truesight", nil)

		self.debuffParticle = ParticleManager:CreateParticle("particles/piercing_shot_debuff.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.debuffParticle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	end
end

function modifier_piercing_shot_stuck:OnIntervalThink()
	if IsServer() then
		ApplyMentalThrusts(self)
	end
end

function modifier_piercing_shot_stuck:GetModifierProvidesFOWVision()
	return 1
end

function modifier_piercing_shot_stuck:OnDestroy()
	if IsServer() then

		local caster = self:GetCaster()
		caster.yari.count = caster.yari.count + 1
		local yariCount = caster.yari.count
		if yariCount < 1 then yariCount = 0 end
		caster:SetModifierStackCount("modifier_yari_count", caster, yariCount)

		local index={}
		for k,v in pairs(caster.yari.targets) do
		   index[v]=k
		end
		table.remove(caster.yari.targets, index[self:GetParent()])
		caster.yari.targetCount = caster.yari.targetCount - 1

		local returnAbility = caster:FindAbilityByName("vardor_return_of_the_yari")
		if caster.yari.targetCount > 0 then
			returnAbility:SetActivated(true)
		else
			returnAbility:SetActivated(false)
		end

		local shotAbility = caster:FindAbilityByName("vardor_piercing_shot")
		if caster.yari.count == 0 then
			shotAbility:SetActivated(false)
		else
			shotAbility:SetActivated(true)
		end

		self:GetParent():RemoveModifierByName("modifier_truesight")

		if self.debuffParticle then
			ParticleManager:DestroyParticle(self.debuffParticle, false)
		end
	end
end

LinkLuaModifier("vardor_perma_status_effect", "components/abilities/heroes/hero_vardor.lua", LUA_MODIFIER_MOTION_NONE)

--Hides all wearables and creates an array of all cosmetics
function HideWearables(caster) 
	local casterLoc = caster:GetAbsOrigin()
	local playerID = caster.playerID

	--local greevil = CreateUnitByName("npc_greevil", casterLoc, true, caster, caster, caster:GetTeam())

	caster.wearableNames = {} -- In here we'll store the wearable names to revert the change
	caster.hiddenWearables = {} -- Keep every wearable handle in a table, as its way better to iterate than in the MovePeer system

	local model = caster:FirstMoveChild()
	--local model = caster:FirstMoveChild()
	--print(model)
	while model ~= nil do
		if model:GetClassname() ~= "" and model:GetClassname() == "dota_item_wearable" then
			local modelName = model:GetModelName()
			if string.find(modelName, "invisiblebox") == nil then

				local index = findLast(modelName, "/")
				if index ~= nil then
					modelName = string.sub(modelName, index)
					print("> "..modelName)

					-- Set model invisible
					if string.find(modelName, "weapon") ~= nil or 
					   string.find(modelName, "spear") ~= nil then

						print("Hide Weapon!")

						table.insert(caster.wearableNames, modelName)
						model:SetModel("models/development/invisiblebox.vmdl")
						table.insert(caster.hiddenWearables, model)
					end
				end
			end
		end
		model = model:NextMovePeer()
		if model ~= nil then
			--print("Next Peer:" .. model:GetModelName())
		end
	end

	for i,v in ipairs(caster.hiddenWearables) do
		v:RemoveSelf()
	end

	caster:AddNewModifier(caster, nil, "vardor_perma_status_effect", nil)

	-- local tempParticle = ParticleManager:CreateParticle("particles/yari_hold/yari_hold_01.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
	-- -- ParticleManager:SetParticleControl(tempParticle, 0, Vector(1,1,0))
	-- ParticleManager:SetParticleControlEnt(tempParticle, 1, caster, PATTACH_POINT_FOLLOW, "attach_weapon", casterLoc, true)
	-- ParticleManager:SetParticleControlEnt(tempParticle, 2, caster, PATTACH_POINT_FOLLOW, "attach_spear_end", casterLoc, true)
	-- caster.weaponParticle = tempParticle
end

function findLast(wString, sWord)
	local i = wString:match(".*"..sWord.."()")
	if i==nil then 
		return nil 
	else 
		return i-1 
	end
end

vardor_perma_status_effect = class({})

function vardor_perma_status_effect:IsDebuff() return false end
function vardor_perma_status_effect:IsPurgable() return false end
function vardor_perma_status_effect:IsHidden() return true end
function vardor_perma_status_effect:RemoveOnDeath() return false end
function vardor_perma_status_effect:GetStatusEffectName() return "particles/status_effect_grey.vpcf" end
function vardor_perma_status_effect:StatusEffectPriority() return 99 end
