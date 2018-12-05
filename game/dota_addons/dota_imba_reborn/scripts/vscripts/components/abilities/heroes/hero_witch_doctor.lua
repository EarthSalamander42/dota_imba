-- Editors:
--     yahnich
--     AtroCty, 23.04.2017

-------------------------------------------
--			PARALYZING CASK
-------------------------------------------
imba_witch_doctor_paralyzing_cask = class({})
function imba_witch_doctor_paralyzing_cask:IsHiddenWhenStolen() return false end
function imba_witch_doctor_paralyzing_cask:IsRefreshable() return true end
function imba_witch_doctor_paralyzing_cask:IsStealable() return true end
function imba_witch_doctor_paralyzing_cask:IsNetherWardStealable() return true end

function imba_witch_doctor_paralyzing_cask:GetAbilityTextureName()
	return "witch_doctor_paralyzing_cask"
end

-------------------------------------------

function imba_witch_doctor_paralyzing_cask:OnSpellStart()
	if IsServer() then
		local hTarget = self:GetCursorTarget()

		-- Parameters
		local speed = self:GetSpecialValueFor("speed")
		-- Creating a unique ID for each cast
		local index = DoUniqueString("index")
		self["split_" .. index] = self:GetSpecialValueFor("split_amount")
		-- Cask count
		self[index] = 1

		if (self:GetCaster():GetName() == "npc_dota_hero_witch_doctor") then
			self:GetCaster():EmitSound("witchdoctor_wdoc_ability_cask_0"..math.random(1,8))
		end

		local projectile =
			{
				Target = hTarget,
				Source = self:GetCaster(),
				Ability = self,
				EffectName = "particles/units/heroes/hero_witchdoctor/witchdoctor_cask.vpcf",
				bDodgable = false,
				bProvidesVision = false,
				iMoveSpeed = speed,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				ExtraData =
				{
					hero_duration = self:GetSpecialValueFor("hero_duration"),
					creep_duration = self:GetSpecialValueFor("creep_duration"),
					hero_damage = self:GetSpecialValueFor("hero_damage"),
					creep_damage = self:GetSpecialValueFor("creep_damage"),
					bounce_range = self:GetSpecialValueFor("bounce_range"),
					bounces = self:GetSpecialValueFor("bounces"),
					speed = speed,
					bounce_delay = self:GetSpecialValueFor("bounce_delay"),
					index = index,
					bFirstCast = 1
				}
			}
		EmitSoundOn("Hero_WitchDoctor.Paralyzing_Cask_Cast", self:GetCaster())
		ProjectileManager:CreateTrackingProjectile(projectile)
	end
end

function imba_witch_doctor_paralyzing_cask:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	EmitSoundOn("Hero_WitchDoctor.Paralyzing_Cask_Bounce", hTarget)

	if hTarget then
		if hTarget:IsRealHero() or hTarget:IsConsideredHero() or hTarget:IsRoshan() then
			if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
				if not hTarget:IsMagicImmune() and (ExtraData.bFirstCast == 0 or not hTarget:TriggerSpellAbsorb(self)) then
					-- #4 TALENT: Casket applies maledict if previous target was maledicted
					if IsServer() and self:GetCaster():HasTalent("special_bonus_imba_witch_doctor_4") then
						local maledict_ability	=	self:GetCaster():FindAbilityByName("imba_witch_doctor_maledict")
						if hTarget:FindModifierByName("modifier_imba_maledict") then
							self.cursed_casket = true
						else
							self.cursed_casket = false
						end
						if ExtraData.cursed_casket == 1 then
							hTarget:AddNewModifier(self:GetCaster(), maledict_ability, "modifier_imba_maledict", {duration = maledict_ability:GetSpecialValueFor("duration") + FrameTime()} )
						end
					end
					hTarget:AddNewModifier(hTarget, self, "modifier_stunned", {duration = ExtraData.hero_duration})
					ApplyDamage({victim = hTarget, attacker = self:GetCaster(), damage = ExtraData.hero_damage, damage_type = self:GetAbilityDamageType()})
				end
			else
				local heal = ExtraData.hero_damage
				hTarget:Heal(heal, self:GetCaster())
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, hTarget, heal, nil)
			end
		else
			if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
				if not hTarget:IsMagicImmune() and (ExtraData.bFirstCast == 0 or not hTarget:TriggerSpellAbsorb(self)) then

					hTarget:AddNewModifier(hTarget, self, "modifier_stunned", {duration = ExtraData.creep_duration})
					ApplyDamage({victim = hTarget, attacker = self:GetCaster(), damage = ExtraData.creep_damage, damage_type = self:GetAbilityDamageType()})
				end
			else
				local heal = ExtraData.creep_damage
				hTarget:Heal(heal, self:GetCaster())
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, hTarget, heal, nil)
			end
		end
	else
		-- If target is out of world or gets invulnerable
		hTarget = CreateUnitByName("npc_dummy_unit", vLocation, false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
	end
	if ExtraData.bounces >= 1 then
		Timers:CreateTimer(ExtraData.bounce_delay, function()
			-- Finds all units in the area, prioritizing enemies
			local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), hTarget:GetAbsOrigin(), nil, ExtraData.bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, self:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false)
			local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), hTarget:GetAbsOrigin(), nil, ExtraData.bounce_range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, self:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, 0, false)

			-- Go through the target tables, checking for the first one that isn't the same as the target
			local tJumpTargets = {}
			-- If the target is an enemy, bounce on an enemy.
			if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
				for _,unit in pairs(enemies) do
					if hTarget then
						if (unit ~= hTarget) and (not unit:IsOther()) and ((self["split_" .. ExtraData.index] >= 1) or #tJumpTargets == 0) then
							table.insert(tJumpTargets, unit)
							if #tJumpTargets == 2 then
								self[ExtraData.index] = self[ExtraData.index] + 1
								break
							end
						end
					end
				end
				-- If the target is an ally, bounce on an ally.
			else
				if #tJumpTargets == 0 then
					for _,unit in pairs(allies) do
						if hTarget then
							if (unit ~= hTarget) and (not unit:IsOther()) then
								table.insert(tJumpTargets, unit)
								break
							end
						end
					end
				end
			end

			if #tJumpTargets == 0 then
				-- End of spell
				self.cursed_casket = false
				if self[ExtraData.index] == 1 then
					self[ExtraData.index] = nil
					self["split_" .. ExtraData.index] = nil
				else
					self[ExtraData.index] = self[ExtraData.index] - 1
				end
				return nil
			elseif #tJumpTargets >= 2 then
				self["split_" .. ExtraData.index] = self["split_" .. ExtraData.index] - 1
			end
			for _, hJumpTarget in pairs(tJumpTargets) do
				local projectile = {
					Target = hJumpTarget,
					Source = hTarget,
					Ability = self,
					EffectName = "particles/units/heroes/hero_witchdoctor/witchdoctor_cask.vpcf",
					bDodgable = false,
					bProvidesVision = false,
					iMoveSpeed = ExtraData.speed,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
					ExtraData =
					{
						hero_duration 		= ExtraData.hero_duration,
						creep_duration 		= ExtraData.creep_duration,
						hero_damage 		= ExtraData.hero_damage,
						creep_damage 		= ExtraData.creep_damage,
						bounce_range 		= ExtraData.bounce_range,
						bounces 			= ExtraData.bounces - 1,
						speed				= ExtraData.speed,
						bounce_delay 		= ExtraData.bounce_delay,
						index 				= ExtraData.index,
						cursed_casket 		= self.cursed_casket,
						bFirstCast			= 0
					}
				}
				ProjectileManager:CreateTrackingProjectile(projectile)
				if hTarget:GetName() == "npc_dummy_unit" then
					hTarget:Destroy()
				end
			end
		end)
	else
		self.cursed_casket = false
		if self[ExtraData.index] == 1 then
			self[ExtraData.index] = nil
			self["split_" .. ExtraData.index] = nil
		else
			self[ExtraData.index] = self[ExtraData.index] - 1
		end
		return nil
	end
end

-------------------------------------------
--			VOODOO RESTORATION
-------------------------------------------

imba_witch_doctor_voodoo_restoration = class({})
LinkLuaModifier("modifier_imba_voodoo_restoration", "components/abilities/heroes/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_voodoo_restoration_heal", "components/abilities/heroes/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)

function imba_witch_doctor_voodoo_restoration:GetAbilityTextureName()
	return "witch_doctor_voodoo_restoration"
end

LinkLuaModifier("modifier_special_bonus_imba_witch_doctor_6", "components/abilities/heroes/hero_witch_doctor.lua", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_witch_doctor_6 = modifier_special_bonus_imba_witch_doctor_6 or class({})

function modifier_special_bonus_imba_witch_doctor_6:IsHidden() return false end
function modifier_special_bonus_imba_witch_doctor_6:RemoveOnDeath() return false end

-- #6 TALENT : Voodo restoration turns into a passive.
function modifier_special_bonus_imba_witch_doctor_6:OnCreated()
	if IsServer() then
		local ability = self:GetParent():FindAbilityByName("imba_witch_doctor_voodoo_restoration")
		if not ability then return end
		self:GetParent():SetContextThink( DoUniqueString("checkforvoodoo"), function ( )
			if ability:GetLevel() > 0 then
				self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_imba_voodoo_restoration", {})
				return nil
			end

			return 1.0
		end, 0 )
	end
end

function imba_witch_doctor_voodoo_restoration:GetCastRange()
	return self:GetSpecialValueFor("radius")
end

function imba_witch_doctor_voodoo_restoration:GetBehavior()
	-- #6 TALENT : Voodo restoration turns into a passive.
	if self:GetCaster():HasTalent("special_bonus_imba_witch_doctor_6") then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL
	end
end

function imba_witch_doctor_voodoo_restoration:GetManaCost( hTarget )
	--#6 TALENT: Voodo restoration doesn't cost mana to activate.
	if self:GetCaster():HasTalent("special_bonus_imba_witch_doctor_6") then
		return 0
	else
		return self.BaseClass.GetManaCost(self, hTarget)
	end
end

function imba_witch_doctor_voodoo_restoration:OnUpgrade()
	if self:GetCaster():HasTalent("special_bonus_imba_witch_doctor_6") then
		if self:GetCaster():HasModifier("modifier_imba_voodoo_restoration") then
			self:GetCaster():RemoveModifierByName("modifier_imba_voodoo_restoration")
		end

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_voodoo_restoration", {})
	end
end

function imba_witch_doctor_voodoo_restoration:OnToggle()
	if self:GetToggleState() then
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration", self:GetCaster())
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration.Loop", self:GetCaster())
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_voodoo_restoration", {})

		if (not _G.VOODOO) and (self:GetCaster():GetName() == "npc_dota_hero_witch_doctor") then
			_G.VOODOO = true
			self:GetCaster():EmitSound("witchdoctor_wdoc_ability_voodoo_0"..math.random(1,5))
			Timers:CreateTimer(10,function()
				_G.VOODOO = nil
			end)
		end

		-- #2 TALENT: When Voodo Restoration is toggled on it applies the dispell immediately.
		if self:GetCaster():HasTalent("special_bonus_imba_witch_doctor_2")  then
			-- Special handling for first cast
			if not self.previous_dispell_time then self.previous_dispell_time = GameRules:GetGameTime() + self:GetCaster():FindTalentValue("special_bonus_imba_witch_doctor_2") end

			-- This can only happen every so often.
			if GameRules:GetGameTime() >= self.previous_dispell_time + self:GetCaster():FindTalentValue("special_bonus_imba_witch_doctor_2") then
				-- Remember what time the dispell happened
				self.previous_dispell_time = GameRules:GetGameTime()
				-- Find allies to dispell
				local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
					self:GetCaster():GetAbsOrigin(),
					nil,
					self:GetSpecialValueFor("radius"),
					self:GetAbilityTargetTeam(),
					self:GetAbilityTargetType(),
					self:GetAbilityTargetFlags(),
					0,
					false)
				-- Dispell them
				for _,hAlly in pairs(allies) do
					local bRemoveStuns		= false
					local bRemoveExceptions = false

					-- #3 TALENT: Voodo restoration now purges stuns/exceptions
					if self:GetCaster():HasTalent("special_bonus_imba_witch_doctor_3") then
						bRemoveStuns 	  = true
						bRemoveExceptions = true
					end

					hAlly:Purge(false, true, false, bRemoveStuns, bRemoveExceptions)
					local cleanse_pfc = ParticleManager:CreateParticle("particles/hero/witch_doctor/voodoo_cleanse.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
					ParticleManager:SetParticleControlEnt(cleanse_pfc, 0, hAlly, PATTACH_POINT_FOLLOW, "attach_hitloc", hAlly:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(cleanse_pfc)
					if hAlly == self:GetCaster() then
						EmitSoundOn("Imba.WitchDoctorDispel", self:GetCaster())
					end
				end
			end
		end
	else
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration.Off", self:GetCaster())
		StopSoundEvent("Hero_WitchDoctor.Voodoo_Restoration.Loop", self:GetCaster())
		self:GetCaster():RemoveModifierByName("modifier_imba_voodoo_restoration")
	end
end

modifier_imba_voodoo_restoration = class({})
function modifier_imba_voodoo_restoration:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		self.interval = ability:GetSpecialValueFor("heal_interval")
		self.cleanse_interval = ability:GetSpecialValueFor("cleanse_interval")
		self.manacost = ability:GetSpecialValueFor("mana_per_second") * self.interval
		self.radius = ability:GetSpecialValueFor("radius")
		self:StartIntervalThink( self.interval )
		self.mainParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.mainParticle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_staff", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.mainParticle, 1, Vector( self.radius, self.radius, self.radius ) )
		ParticleManager:SetParticleControlEnt(self.mainParticle, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_staff", self:GetCaster():GetAbsOrigin(), true)
	end
end

function modifier_imba_voodoo_restoration:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
		ParticleManager:DestroyParticle(self.mainParticle, false)
		ParticleManager:ReleaseParticleIndex(self.mainParticle)
	end
end

function modifier_imba_voodoo_restoration:OnIntervalThink()
	local hAbility = self:GetAbility()
	if not self:GetCaster():IsAlive() then return end
	-- Counter for purge effect
	self.cleanse_counter = self.cleanse_counter or 0

	self.cleanse_counter = self.cleanse_counter + self.interval
	if self.cleanse_counter >= self.cleanse_interval then
		self.cleanse_counter = 0
		local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), 0, false)
		for _,hAlly in pairs(allies) do
			local bRemoveStuns		= false
			local bRemoveExceptions = false

			-- #3 TALENT: Voodo restoration now purges stuns/exceptions
			if self:GetCaster():HasTalent("special_bonus_imba_witch_doctor_3") then
				bRemoveStuns      = true
				bRemoveExceptions = true
			end

			hAlly:Purge(false, true, false, bRemoveStuns, bRemoveExceptions)
			local cleanse_pfc = ParticleManager:CreateParticle("particles/hero/witch_doctor/voodoo_cleanse.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
			ParticleManager:SetParticleControlEnt(cleanse_pfc, 0, hAlly, PATTACH_POINT_FOLLOW, "attach_hitloc", hAlly:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(cleanse_pfc)
			if hAlly == self:GetCaster() then
				EmitSoundOn("Imba.WitchDoctorDispel", self:GetCaster())
			end
		end
	end

	-- #6 TALENT: Voodo restoration doesn't cost mana to maintain.
	if not self:GetCaster():HasTalent("special_bonus_imba_witch_doctor_6") then
		if self:GetCaster():GetMana() >= hAbility:GetManaCost(-1) then
			self:GetCaster():SpendMana(self.manacost, hAbility)
		else
			hAbility:ToggleAbility()
		end
	end
end

function modifier_imba_voodoo_restoration:IsAura()
	return true
end

function modifier_imba_voodoo_restoration:IsAuraActiveOnDeath()
	return false
end

function modifier_imba_voodoo_restoration:GetAuraRadius()
	return self.radius
end

function modifier_imba_voodoo_restoration:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_voodoo_restoration:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_voodoo_restoration:GetModifierAura()
	return "modifier_imba_voodoo_restoration_heal"
end

function modifier_imba_voodoo_restoration:IsHidden()
	return true
end
-------------------------------------------
modifier_imba_voodoo_restoration_heal = class({})
function modifier_imba_voodoo_restoration_heal:IsDebuff() return false end
function modifier_imba_voodoo_restoration_heal:IsHidden() return false end
function modifier_imba_voodoo_restoration_heal:IsPurgable() return false end
function modifier_imba_voodoo_restoration_heal:IsPurgeException() return false end
function modifier_imba_voodoo_restoration_heal:IsStunDebuff() return false end
function modifier_imba_voodoo_restoration_heal:RemoveOnDeath() return true end
function modifier_imba_voodoo_restoration_heal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
-------------------------------------------
function modifier_imba_voodoo_restoration_heal:OnCreated()
	if IsServer() then
		self.interval = self:GetAbility():GetSpecialValueFor("heal_interval")
		self:StartIntervalThink( self.interval )
	end
end

function modifier_imba_voodoo_restoration_heal:OnIntervalThink()
	local hParent = self:GetParent()
	local heal_amp = 1 + (self:GetCaster():GetSpellAmplification(false) * 0.01)
	local heal = (self:GetAbility():GetSpecialValueFor("heal") + (self:GetCaster():GetIntellect() * self:GetAbility():GetSpecialValueFor("int_to_heal") * 0.01)) * heal_amp * self.interval

	hParent:Heal(heal, self:GetCaster())
	SendOverheadEventMessage(hParent, OVERHEAD_ALERT_HEAL, hParent, heal, hParent)
end

-------------------------------------------
--				MALEDICT
-------------------------------------------
LinkLuaModifier("modifier_imba_maledict", "components/abilities/heroes/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_maledict_talent", "components/abilities/heroes/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)

imba_witch_doctor_maledict = class({})
function imba_witch_doctor_maledict:IsHiddenWhenStolen() return false end
function imba_witch_doctor_maledict:IsRefreshable() return true end
function imba_witch_doctor_maledict:IsStealable() return true end
function imba_witch_doctor_maledict:IsNetherWardStealable() return true end

function imba_witch_doctor_maledict:GetAbilityTextureName()
	return "witch_doctor_maledict"
end
-------------------------------------------

function imba_witch_doctor_maledict:OnSpellStart()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)
	local aoe_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_maledict_aoe.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl( aoe_pfx, 0, vPosition )
	ParticleManager:SetParticleControl( aoe_pfx, 1, Vector(radius, radius, radius) )
	if #enemies > 0 then
		EmitSoundOn("Hero_WitchDoctor.Maledict_Cast", self:GetCaster())
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_maledict", {duration = duration + (FrameTime())})
		end
	else
		EmitSoundOn("Hero_WitchDoctor.Maledict_CastFail", self:GetCaster())
	end
end

function imba_witch_doctor_maledict:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

-------------------------------------------
modifier_imba_maledict = class({})
function modifier_imba_maledict:IsDebuff() return true end
function modifier_imba_maledict:IsHidden() return false end
function modifier_imba_maledict:IsPurgable() return false end
function modifier_imba_maledict:IsPurgeException() return false end
function modifier_imba_maledict:IsStunDebuff() return false end
function modifier_imba_maledict:RemoveOnDeath() return true end
-------------------------------------------
function modifier_imba_maledict:OnCreated()
	local hAbility 	 = self:GetAbility()
	local hParent	 = self:GetParent()
	self.main_damage = hAbility:GetSpecialValueFor("main_damage")
	self.bonus_damage_pct = hAbility:GetSpecialValueFor("bonus_damage_pct") * 0.01
	self.tick_time_sec = hAbility:GetSpecialValueFor("tick_time_sec")
	self.tick_time_main = hAbility:GetSpecialValueFor("tick_time_main")
	self.heal_reduce_pct = hAbility:GetSpecialValueFor("heal_reduce_pct") * (-1)
	self.counter = 0
	self.burstParticle = ParticleManager:CreateParticle("particles/hero/witch_doctor/imba_witchdoctor_maledict.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.burstParticle, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.burstParticle, 1, Vector(self.tick_time_sec, 0, 0))
	if not self:GetCaster():HasTalent("special_bonus_imba_witch_doctor_1") then
		ParticleManager:SetParticleControl(self.burstParticle, 2, Vector(128, 1, 1))
		-- #1 TALENT: Maledict affects an area around the target.
	else
		ParticleManager:SetParticleControl(self.burstParticle, 2, Vector(self:GetCaster():FindTalentValue("special_bonus_imba_witch_doctor_1"), 1, 1))
	end


	if IsServer() then
		self.healthComparator = hParent:GetHealth()
		self:StartIntervalThink( self.tick_time_main )
	end
	EmitSoundOn("Hero_WitchDoctor.Maledict_Loop", hParent)
end

function modifier_imba_maledict:OnRefresh()
	local hAbility = self:GetAbility()
	self.bonus_damage_pct = hAbility:GetSpecialValueFor("bonus_damage_pct") * 0.01
	self.tick_time_sec = hAbility:GetSpecialValueFor("tick_time_sec")
	self.tick_time_main = hAbility:GetSpecialValueFor("tick_time_main")
	self.heal_reduce_pct = hAbility:GetSpecialValueFor("heal_reduce_pct") * (-1)
end

function modifier_imba_maledict:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
	end

	-- Activate the damage in the case that it has not activated the required amount of times.
	if self.soundcount then
		if self.soundcount < self:GetAbility():GetSpecialValueFor("duration") / self.tick_time_sec then
			self:DealHPBurstDamage(self:GetParent())
			EmitSoundOn("Hero_WitchDoctor.Maledict_Tick", hTarget)
		end
	end

	StopSoundEvent("Hero_WitchDoctor.Maledict_Loop", self:GetParent())
	ParticleManager:DestroyParticle(self.burstParticle, false)
	ParticleManager:ReleaseParticleIndex(self.burstParticle)
end

function modifier_imba_maledict:OnIntervalThink()
	local hParent = self:GetParent()
	self.counter = self.counter + self.tick_time_main
	ApplyDamage({victim = hParent, attacker = self:GetCaster(), damage = self.main_damage, damage_type = self:GetAbility():GetAbilityDamageType()})
	if self.counter >= self.tick_time_sec then

		self.counter = 0
		self:DealHPBurstDamage(hParent)
	end
end

function modifier_imba_maledict:GetStatusEffectName()
	return "particles/status_fx/status_effect_maledict.vpcf"
end

function modifier_imba_maledict:StatusEffectPriority()
	return 5
end

function modifier_imba_maledict:DeclareFunctions()
	local funcs =
		{
			MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE,
			MODIFIER_EVENT_ON_DEATH
		}
	return funcs
end

function modifier_imba_maledict:GetModifierHealAmplify_Percentage()
	return self.heal_reduce_pct
end

function modifier_imba_maledict:OnDeath(params)
	if (not _G.MALEDICT_KILL) and (self:GetParent() == params.unit) and self:GetCaster():GetName() == "npc_dota_hero_witch_doctor" then
		_G.MALEDICT_KILL = true
		self:GetCaster():EmitSound("witchdoctor_wdoc_ability_maledict_0"..math.random(1,4))
		Timers:CreateTimer(30,function()
			_G.MALEDICT_KILL = nil
		end)
	end
end

function modifier_imba_maledict:GetHealthRegenAmp()
	return self.heal_reduce_pct
end

function modifier_imba_maledict:DealHPBurstDamage(hTarget)
	self.soundcount = self.soundcount or 0
	self.soundcount = self.soundcount + 1

	local hAbility	= self:GetAbility()
	local newHP = hTarget:GetHealth()
	local maxHP_pct = newHP / hTarget:GetMaxHealth()
	if newHP > self.healthComparator then return end
	if (not _G.MALEDICT_POP) and (maxHP_pct < 0.2) and (self.soundcount == 2) and (self:GetCaster():GetName() == "npc_dota_hero_witch_doctor") then
		_G.MALEDICT_POP = true
		self:GetCaster():EmitSound("witchdoctor_wdoc_killspecial_0"..math.random(1,3))
		Timers:CreateTimer(30,function()
			_G.MALEDICT_POP = nil
		end)
	end
	local hpDiffDamage = (self.healthComparator - newHP) * self.bonus_damage_pct
	ApplyDamage({victim = hTarget, attacker = self:GetCaster(), damage = hpDiffDamage, damage_type = hAbility:GetAbilityDamageType()})
	EmitSoundOn("Hero_WitchDoctor.Maledict_Tick", hTarget)

	-- #1 TALENT: Maledict deals additional damage based on it's own damage, spread between enemies around the target.
	if self:GetCaster():HasTalent("special_bonus_imba_witch_doctor_1") then
		-- Find enemies near the target
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
			hTarget:GetAbsOrigin(),
			nil,
			self:GetCaster():FindTalentValue("special_bonus_imba_witch_doctor_1"),
			hAbility:GetAbilityTargetTeam(),
			hAbility:GetAbilityTargetType(),
			hAbility:GetAbilityTargetFlags(),
			FIND_ANY_ORDER,
			false)

		-- Deal damage to each enemy
		for _,enemy in pairs(enemies) do
			if enemy ~= hTarget then
				local DamageTable = {
					victim = enemy,
					attacker = self:GetCaster(),
					damage = hpDiffDamage / (#enemies - 1),
					damage_type = hAbility:GetAbilityDamageType()
				}
				ApplyDamage(DamageTable)
			end
		end
	end

	-- #7 TALENT: Maledict applies a no healing debuff briefly
	if self:GetCaster():HasTalent("special_bonus_imba_witch_doctor_7") then
		hTarget:AddNewModifier(self:GetCaster(), hAbility, "modifier_imba_maledict_talent", {duration = self:GetCaster():FindTalentValue("special_bonus_imba_witch_doctor_7")} )
	end
end

--- NO HEALING MODIFIER FROM #7 TALENT
modifier_imba_maledict_talent = modifier_imba_maledict_talent or class({})

-- Modifier properties
function modifier_imba_maledict_talent:IsDebuff() return true end
function modifier_imba_maledict_talent:IsHidden() return false end
function modifier_imba_maledict_talent:IsPurgable() return false end

function modifier_imba_maledict_talent:DeclareFunctions()
	local funcs ={
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE
	}
	return funcs
end

function modifier_imba_maledict_talent:GetModifierHealAmplify_Percentage()
	return -100
end

-------------------------------------------
--				DEATH WARD
-------------------------------------------
LinkLuaModifier("modifier_imba_death_ward", "components/abilities/heroes/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_ward_caster", "components/abilities/heroes/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)

imba_witch_doctor_death_ward = class({})
function imba_witch_doctor_death_ward:IsHiddenWhenStolen() return false end
function imba_witch_doctor_death_ward:IsRefreshable() return true end
function imba_witch_doctor_death_ward:IsStealable() return true end
function imba_witch_doctor_death_ward:IsNetherWardStealable() return false end

function imba_witch_doctor_death_ward:GetAbilityTextureName()
	return "witch_doctor_death_ward"
end
-------------------------------------------

function imba_witch_doctor_death_ward:OnSpellStart()
	if IsServer() then
		local vPosition = self:GetCursorPosition()
		if self:GetCaster():HasTalent("special_bonus_imba_witch_doctor_8") then
			-- Calculate where the wards shall spawn
			local distance = self:GetCaster():FindTalentValue("special_bonus_imba_witch_doctor_8")
			local spawn_line_direction = RotateVector2D((vPosition - self:GetCaster():GetAbsOrigin()):Normalized(),90,true)
			local talent_ward = self:CreateWard(vPosition - ((distance / 2) * spawn_line_direction))
			-- Flag this as a talent ward for the bounce mechanic
			talent_ward.bIsTalentWard = true
			-- Remove it after a delay, not by channeltime
			Timers:CreateTimer(self:GetChannelTime(),function()
				UTIL_Remove(talent_ward)
				-- #5 TALENT: Mini death wards need to be removed at the end of channel.
				if self:GetCaster():HasTalent("special_bonus_imba_witch_doctor_5") then
					-- Find mini death wards
					local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
						self:GetCaster():GetAbsOrigin(),
						nil,
						25000,
						DOTA_UNIT_TARGET_TEAM_FRIENDLY,
						DOTA_UNIT_TARGET_OTHER,
						DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
						FIND_ANY_ORDER,
						false)
					-- Remove mini death wards
					for _,unit in pairs(units) do
						if unit.bIsMiniDeathWard then
							UTIL_Remove(unit)
						end
					end
				end
			end)
			vPosition = vPosition + ((distance / 2) * spawn_line_direction)
			talent_ward:EmitSound("Hero_WitchDoctor.Death_WardBuild")
		end
		self.death_ward = self:CreateWard(vPosition)
		if USE_MEME_SOUNDS == true and RollPercentage(MEME_SOUNDS_CHANCE) then
			self.dance = true
			self.death_ward:EmitSound("Imba.WitchDoctorSingsASong")
		else
			self.death_ward:EmitSound("Hero_WitchDoctor.Death_WardBuild")
			self.dance = nil
		end
	end
end

function imba_witch_doctor_death_ward:CreateWard(vPosition, bIsMiniWard)
	local damage = self:GetSpecialValueFor("damage") + self:GetCaster():GetIntellect()*self:GetSpecialValueFor("int_to_dmg_pct")/100
	-- #5 TALENT: Mini death ward deal less damage
	if bIsMiniWard then
		damage = damage * self:GetCaster():FindTalentValue("special_bonus_imba_witch_doctor_5") * 0.01
	end
	local death_ward = CreateUnitByName("imba_witch_doctor_death_ward", vPosition, true, self:GetCaster(), nil, self:GetCaster():GetTeam())

	-- Set on a clear space
	Timers:CreateTimer(FrameTime(), function()
		ResolveNPCPositions(vPosition, 128)
	end)

	death_ward:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	death_ward:SetOwner(self:GetCaster())
	death_ward:SetCanSellItems(false)
	death_ward:SetBaseAttackTime( self:GetSpecialValueFor("base_attack_time") )
	local death_ward_mod = death_ward:AddNewModifier(self:GetCaster(), self, "modifier_imba_death_ward", {duration = self:GetChannelTime()})
	local exceptionList =
		{
			["item_imba_bfury"] = true,
			["item_imba_butterfly"] = true,
			["item_imba_echo_sabre"] = true,
			["item_imba_reverb_rapier"] = true,
			["item_imba_rapier"] = true,
			["item_imba_rapier_2"] = true,
			["item_imba_rapier_magic"] = true,
			["item_imba_rapier_magic_2"] = true,
			["item_imba_rapier_cursed"] = true,
		}
	for i = 0, 5 do
		local item = self:GetCaster():GetItemInSlot(i)
		if item and not exceptionList[item:GetName()] then
			death_ward:AddItemByName(item:GetName())
		end

		if self:GetCaster():HasModifier("modifier_item_imba_spell_fencer_unique") then
			death_ward:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_spell_fencer_unique", {})
		end
	end
	-- Removing the bonus damage from items
	local damageOffset = death_ward:GetAverageTrueAttackDamage(death_ward)
	-- Hacky method of bypassing critical strike modifiers that remove more attack damage than it should
	for iteration = 1, 100 do
		local temp = death_ward:GetAverageTrueAttackDamage(death_ward)
		if temp < damageOffset then
			damageOffset = temp
		end
	end
	
	death_ward:SetBaseDamageMax( damage - damageOffset )
	death_ward:SetBaseDamageMin( damage - damageOffset )
	-- For Attack-order
	self.mod_caster = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_death_ward_caster", {duration = self:GetChannelTime()})
	self.mod_caster.death_ward_mod = death_ward_mod
	local index = DoUniqueString("index")
	death_ward.index = index
	self[index] = death_ward
	return death_ward
end

function imba_witch_doctor_death_ward:GetChannelAnimation()
	if self.dance then return ACT_DOTA_VICTORY end
	return ACT_DOTA_CHANNEL_ABILITY_4
end

function imba_witch_doctor_death_ward:OnChannelFinish()
	if IsServer() then
		StopSoundOn("Hero_WitchDoctor.Death_WardBuild", self.death_ward)
		StopSoundOn("Imba.WitchDoctorSingsASong", self.death_ward)
		UTIL_Remove(self.death_ward)
		-- #5 TALENT: Mini death wards need to be removed at the end of channel.
		if self:GetCaster():HasTalent("special_bonus_imba_witch_doctor_5") then
			-- Find mini death wards
			local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
				self:GetCaster():GetAbsOrigin(),
				nil,
				25000,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_OTHER,
				DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
				FIND_ANY_ORDER,
				false)
			-- Remove mini death wards
			for _,unit in pairs(units) do
				if unit.bIsMiniDeathWard then
					UTIL_Remove(unit)
				end
			end
		end
		if self.mod_caster then self.mod_caster:Destroy() end
	end
end

function imba_witch_doctor_death_ward:OnProjectileHit_ExtraData(target, vLocation, ExtraData)
	if self[ExtraData.index] then
		if not self[ExtraData.index]:IsNull() then
			if self:GetCaster():HasScepter() then
				self[ExtraData.index]:PerformAttack(target, false, true, true, true, false, false, true)
			else
				self[ExtraData.index]:PerformAttack(target, false, true, true, true, false, false, false)
			end

			if ExtraData.bounces_left >= 0 and self:GetCaster():HasScepter() then
				ExtraData.bounces_left = ExtraData.bounces_left - 1
				ExtraData[tostring(target:GetEntityIndex())] = 1
				self:CreateBounceAttack(target, ExtraData)
			end
		end
	end
end

function imba_witch_doctor_death_ward:CreateBounceAttack(originalTarget, extraData)
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), originalTarget:GetAbsOrigin(), nil, self:GetSpecialValueFor("bounce_radius_scepter"), self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_CLOSEST, false)
	local target = originalTarget
	for _,enemy in pairs(enemies) do
		if extraData[tostring(enemy:GetEntityIndex())] ~= 1 and not enemy:IsAttackImmune() and extraData.bounces_left > 0 then
			extraData[tostring(enemy:GetEntityIndex())] = 1
			local projectile = {
				Target = enemy,
				Source = originalTarget,
				Ability = self,
				EffectName = "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_attack.vpcf",
				bDodgable = true,
				bProvidesVision = false,
				iMoveSpeed = 1500,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
				ExtraData = extraData
			}
			ProjectileManager:CreateTrackingProjectile(projectile)
			break
		end
	end
	EmitSoundOn("Hero_Jakiro.Attack" ,originalTarget)
end

-------------------------------------------
modifier_imba_death_ward_caster = class({})
function modifier_imba_death_ward_caster:IsDebuff() return false end
function modifier_imba_death_ward_caster:IsHidden() return true end
function modifier_imba_death_ward_caster:IsPurgable() return false end
function modifier_imba_death_ward_caster:IsPurgeException() return false end
function modifier_imba_death_ward_caster:IsStunDebuff() return false end
function modifier_imba_death_ward_caster:RemoveOnDeath() return true end
-------------------------------------------
modifier_imba_death_ward = class({})
function modifier_imba_death_ward:IsDebuff() return false end
function modifier_imba_death_ward:IsHidden() return true end
function modifier_imba_death_ward:IsPurgable() return false end
function modifier_imba_death_ward:IsPurgeException() return false end
function modifier_imba_death_ward:IsStunDebuff() return false end
function modifier_imba_death_ward:RemoveOnDeath() return true end
-------------------------------------------

function modifier_imba_death_ward:OnCreated()
	self.wardParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_ward_skull.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.wardParticle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.wardParticle, 2, self:GetParent():GetAbsOrigin())

	self.attack_range_bonus	=	self:GetAbility():GetSpecialValueFor("attack_range") - self:GetParent():Script_GetAttackRange()

	if IsServer() then
		self:StartIntervalThink( self:GetParent():GetBaseAttackTime() )
	end
end

function modifier_imba_death_ward:OnDestroy()
	if IsServer() then
		self:GetAbility()[self:GetParent().index] = nil
	end
end

function modifier_imba_death_ward:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local bounces = 0
		if self:GetCaster():HasScepter() then
			bounces = hAbility:GetSpecialValueFor("bounces_scepter") + 1
		end
		local range = hParent:Script_GetAttackRange()
		if self.attack_target then
			if not ((((self.attack_target:GetAbsOrigin() - hParent:GetAbsOrigin()):Length2D()) <= range) and UnitFilter( self.attack_target, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber()) == 0) then
				self.attack_target = nil
			end
		end
		if not self.attack_target then
			local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), hParent:GetAbsOrigin(), nil, range, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
			self.attack_target = units[1]
		end
		if self.attack_target then
			local projectile =
				{
					Target = self.attack_target,
					Source = hParent,
					Ability = hAbility,
					EffectName = "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_attack.vpcf",
					bDodgable = true,
					bProvidesVision = false,
					iMoveSpeed = hParent:GetProjectileSpeed(),
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
					ExtraData = {index = hParent.index, bounces_left = bounces, [tostring(self.attack_target:GetEntityIndex())] = 1, bIsTalentWard = hParent.bIsTalentWard}
				}
			EmitSoundOn("Hero_WitchDoctor_Ward.Attack", hParent)
			ProjectileManager:CreateTrackingProjectile(projectile)
		end
	end
end

function modifier_imba_death_ward:DeclareFunctions()
	local funcs ={
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

-- #5 TALENT: Death ward spawns another death ward when it's attacks kill the target
function modifier_imba_death_ward:OnTakeDamage(params)
	if params.attacker == self:GetParent() then
		if self:GetCaster():HasTalent("special_bonus_imba_witch_doctor_5") then
			-- If the target is dead
			if not params.unit:IsAlive() then
				-- Doesn't spawn off of ilussions.
				if params.unit:IsRealHero() then
					-- Spawn a Death Ward (marked true for a mini death ward).
					local talent_ward = self:GetAbility():CreateWard(params.unit:GetAbsOrigin(), true)
					talent_ward.bIsMiniDeathWard = true
					talent_ward:EmitSound("Hero_WitchDoctor.Death_WardBuild")
				end
			end
		end
	end
end

function modifier_imba_death_ward:GetModifierAttackRangeBonus()
	return self.attack_range_bonus
end

function modifier_imba_death_ward:CheckState()
	local state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MUTED] = true,
	}
	return state
end
