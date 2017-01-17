--[[	Author: Yahnich
		Date: 28.12.2016	]]

imba_witch_doctor_paralyzing_cask = class({})

function imba_witch_doctor_paralyzing_cask:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	local projectile = {
			Target = hTarget,
			Source = self:GetCaster(),
			Ability = self,
			EffectName = "particles/units/heroes/hero_witchdoctor/witchdoctor_cask.vpcf",
			bDodgable = true,
			bProvidesVision = false,
			iMoveSpeed = self:GetSpecialValueFor("speed"),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		}
	local bounces = self:GetSpecialValueFor("bounces") + 1
	if not self.bounce_amount then self.bounce_amount = 2 end
	if not self.remainingBounces then self.remainingBounces = bounces
	else self.remainingBounces = self.remainingBounces + bounces end -- Adds bounces on refresh; can be commented out
	EmitSoundOn("Hero_WitchDoctor.Paralyzing_Cask_Cast", self:GetCaster())
	ProjectileManager:CreateTrackingProjectile(projectile)
end

function imba_witch_doctor_paralyzing_cask:OnProjectileHit(target, vLocation)
	EmitSoundOn("Hero_WitchDoctor.Paralyzing_Cask_Bounce", target)
	local bounce_delay  = self:GetSpecialValueFor("bounce_delay")
	local bounce_range = self:GetSpecialValueFor("bounce_range")
	local caster = self:GetCaster()
	if not target then return end
	if target:IsRealHero() then
		if self.remainingBounces then self.remainingBounces = self.remainingBounces - 1 end
		local healdmg = self:GetSpecialValueFor("hero_damage")
		if target:GetTeamNumber() ~= caster:GetTeamNumber() then
			target:AddNewModifier(target, self, "modifier_stunned", {Duration = self:GetSpecialValueFor("hero_duration")})
			ApplyDamage({victim = target, attacker = caster, damage = healdmg, damage_type = self:GetAbilityDamageType()})
		else
			target:Heal(healdmg, caster)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, healdmg, nil)
		end
	else
		if self.remainingBounces then self.remainingBounces = self.remainingBounces - 0.5 end
		local healdmg_creep = self:GetSpecialValueFor("creep_damage")
		if target:GetTeamNumber() ~= caster:GetTeamNumber() then
			target:AddNewModifier(target, self, "modifier_stunned", {Duration = self:GetSpecialValueFor("creep_duration")})
			ApplyDamage({victim = target, attacker = caster, damage = healdmg_creep, damage_type = self:GetAbilityDamageType()})
		else
			target:Heal(healdmg_creep, caster)
			SendOverheadEventMessage(target, OVERHEAD_ALERT_HEAL, target, healdmg_creep, target)
		end
	end
	if self.remainingBounces and self.remainingBounces > 0 then
		-- We wait on the delay
		Timers:CreateTimer(bounce_delay, function()

			-- Finds all units in the area, prioritizing enemies
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, self:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false)
			local allies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, bounce_range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, self:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false)
			
			-- Go through the target tables, checking for the first one that isn't the same as the target
			local target_to_jump = {}
			for _,unit in pairs(enemies) do
				if unit ~= target and self.bounce_amount and #target_to_jump < self.bounce_amount then
					table.insert(target_to_jump, unit)
					if #target_to_jump >= self.bounce_amount then
						break
					end
				end
			end
			if #target_to_jump == 0 then 
				for _,unit in pairs(allies) do
					if unit ~= target then
						table.insert(target_to_jump, unit)
						break
					end
				end
			end
			if #target_to_jump == 0 then 
				self.remainingBounces = nil
				self.bounce_amount = nil
				return
			elseif #target_to_jump >= 2 then
				self.bounce_amount = 1
			end
			for _, jumpTarget in pairs(target_to_jump) do
				local projectile = {
					Target = jumpTarget,
					Source = target,
					Ability = self,
					EffectName = "particles/units/heroes/hero_witchdoctor/witchdoctor_cask.vpcf",
					bDodgable = true,
					bProvidesVision = false,
					iMoveSpeed = self:GetSpecialValueFor("speed"),
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				}
				ProjectileManager:CreateTrackingProjectile(projectile)
			end
		end)
	else
		self.remainingBounces = nil
		self.bounce_amount = nil
	end
end


imba_witch_doctor_voodoo_restoration = class({})

function imba_witch_doctor_voodoo_restoration:GetCastRange()
	return self:GetSpecialValueFor("radius")
end

LinkLuaModifier("imba_witch_doctor_voodoo_restoration_handler", "hero/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
function imba_witch_doctor_voodoo_restoration:OnToggle()
	if self:GetToggleState() then
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration", self:GetCaster())
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration.Loop", self:GetCaster())
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "imba_witch_doctor_voodoo_restoration_handler", {})
	else
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration.Off", self:GetCaster())
		StopSoundEvent("Hero_WitchDoctor.Voodoo_Restoration.Loop", self:GetCaster())
		self:GetCaster():RemoveModifierByName("imba_witch_doctor_voodoo_restoration_handler")
	end
end

imba_witch_doctor_voodoo_restoration_handler = class({})

function imba_witch_doctor_voodoo_restoration_handler:OnCreated()
	self.interval = self:GetAbility():GetSpecialValueFor("heal_interval")
	if IsServer() then
		self:StartIntervalThink( self.interval )
	end
	self.manaCost = self:GetAbility():GetSpecialValueFor("mana_per_second") * self.interval
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.mainParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControlEnt(self.mainParticle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_staff", self:GetParent():GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.mainParticle, 1, Vector( self.radius, self.radius, self.radius ) )
			ParticleManager:SetParticleControlEnt(self.mainParticle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_staff", self:GetParent():GetAbsOrigin(), true)
end

function imba_witch_doctor_voodoo_restoration_handler:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
	end
	ParticleManager:DestroyParticle(self.mainParticle, false)
	ParticleManager:ReleaseParticleIndex(self.mainParticle)
end

function imba_witch_doctor_voodoo_restoration_handler:OnIntervalThink()
	if self:GetCaster():GetMana() >= self:GetAbility():GetManaCost(-1) then
		self:GetCaster():SpendMana(self.manaCost, self:GetAbility())
	else
		self:GetAbility():ToggleAbility()
	end
end

function imba_witch_doctor_voodoo_restoration_handler:IsAura()
	return true
end

function imba_witch_doctor_voodoo_restoration_handler:IsAuraActiveOnDeath()
	return false
end

function imba_witch_doctor_voodoo_restoration_handler:GetAuraRadius()
	return self.radius
end

function imba_witch_doctor_voodoo_restoration_handler:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function imba_witch_doctor_voodoo_restoration_handler:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function imba_witch_doctor_voodoo_restoration_handler:GetModifierAura()
	return "imba_witch_doctor_voodoo_restoration_heal"
end

function imba_witch_doctor_voodoo_restoration_handler:IsHidden()
	return true
end

LinkLuaModifier("imba_witch_doctor_voodoo_restoration_heal", "hero/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
imba_witch_doctor_voodoo_restoration_heal = class({})

function imba_witch_doctor_voodoo_restoration_heal:OnCreated()
	self.interval = self:GetAbility():GetSpecialValueFor("heal_interval")
	if IsServer() then
		self:StartIntervalThink( self.interval )
		self.heal = (self:GetAbility():GetSpecialValueFor("heal") + self:GetCaster():GetIntellect()*self:GetAbility():GetSpecialValueFor("int_to_heal")/100 ) * self.interval
		self.purgeCounter = 0
		self.purgeTimer = self:GetAbility():GetSpecialValueFor("cleanse_interval")
	end
	self.stickTime = 0.5
	self:SetDuration(self.stickTime, false)
end

function imba_witch_doctor_voodoo_restoration_heal:OnRefresh()
	if IsServer() then
		self.heal = (self:GetAbility():GetSpecialValueFor("heal") + self:GetCaster():GetIntellect()*self:GetAbility():GetSpecialValueFor("int_to_heal")/100 ) * self.interval
	end
	self:SetDuration(self.stickTime, false)
end

function imba_witch_doctor_voodoo_restoration_heal:IsBuff()
	return true
end


function imba_witch_doctor_voodoo_restoration_heal:OnIntervalThink()
	self:GetParent():Heal(self.heal, self:GetCaster())
	SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_HEAL, self:GetParent(), self.heal, self:GetParent())
	self.purgeCounter = self.purgeCounter + self.interval
	if self.purgeCounter > self.purgeTimer then
		EmitSoundOn("Hero_WitchDoctor.Attack", self:GetParent())
		local burst = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_ward_attack_explosion.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(burst, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:GetParent():Purge(false, true, false, false, false)
		self.purgeCounter = 0
	end
end

imba_witch_doctor_maledict = class({})

function imba_witch_doctor_maledict:OnSpellStart()
	local vPosition = self:GetCursorPosition()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), 0, 0, false)
	local aoe = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_maledict_aoe.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl( aoe, 0, vPosition )
		ParticleManager:SetParticleControl( aoe, 1, Vector(radius, radius, radius) )
	if #enemies > 0 then
		EmitSoundOn("Hero_WitchDoctor.Maledict_Cast", caster)
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier(caster, self, "modifier_maledict_imba_thinker", {duration = self:GetDuration()+0.1})
		end
	else
		EmitSoundOn("Hero_WitchDoctor.Maledict_CastFail", caster)
	end
end

function imba_witch_doctor_maledict:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

LinkLuaModifier("modifier_maledict_imba_thinker", "hero/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
modifier_maledict_imba_thinker = class({})

function modifier_maledict_imba_thinker:OnCreated()
	self.burstDamage = self:GetAbility():GetAbilityDamage()
	self.baseDamage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.burstCounter = 0
	self.burstTimer = self:GetAbility():GetDuration() / self:GetAbility():GetSpecialValueFor("ticks")
	self.thinkInterval = self:GetAbility():GetSpecialValueFor("tick_time") 
	self.burstParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_maledict.vpcf", PATTACH_POINT_FOLLOW, self:GetParent()) 
		ParticleManager:SetParticleControlEnt(self.burstParticle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.burstParticle, 1, Vector(self.burstTimer, 0, 0))
	if IsServer() then
		self.healthComparator = self:GetParent():GetHealth()
		self:StartIntervalThink( self.thinkInterval )
	end
	EmitSoundOn("Hero_WitchDoctor.Maledict_Loop", self:GetParent())
end

function modifier_maledict_imba_thinker:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
	end
	StopSoundEvent("Hero_WitchDoctor.Maledict_Loop", self:GetParent())
	ParticleManager:DestroyParticle(self.burstParticle, false)
	ParticleManager:ReleaseParticleIndex(self.burstParticle)
end

function modifier_maledict_imba_thinker:OnIntervalThink()
	self.burstCounter = self.burstCounter + self.thinkInterval
	ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.baseDamage, damage_type = self:GetAbility():GetAbilityDamageType()})
	if self.burstCounter >= self.burstTimer then
		self.burstCounter = 0
		self:DealHPBurstDamage(self:GetParent())
	end
end

function modifier_maledict_imba_thinker:GetStatusEffectName()
	return "particles/status_fx/status_effect_maledict.vpcf"
end

function modifier_maledict_imba_thinker:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}
	return funcs
end

function modifier_maledict_imba_thinker:GetDisableHealing()
	return 1
end

function modifier_maledict_imba_thinker:IsPurgable()
	return false
end

function modifier_maledict_imba_thinker:DealHPBurstDamage(target)
	local oldHP = self.healthComparator
	local newHP = target:GetHealth()
	local ability = self:GetAbility()
	if newHP > oldHP then return end
	local hpDiffDamage = (oldHP - newHP) * ability:GetSpecialValueFor("bonus_damage") / 100
	ApplyDamage({victim = target, attacker = self:GetCaster(), damage = hpDiffDamage, damage_type = ability:GetAbilityDamageType()})
	EmitSoundOn("Hero_WitchDoctor.Maledict_Tick", target)
end

imba_witch_doctor_death_ward = class({})

function imba_witch_doctor_death_ward:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local vPosition = self:GetCursorPosition()
		self.wardDamage = self:GetSpecialValueFor("damage") + caster:GetIntellect()*self:GetSpecialValueFor("int_to_damage")/100
		self.death_ward = CreateUnitByName("imba_witch_doctor_death_ward", vPosition, true, caster, nil, caster:GetTeam())
		self.death_ward:SetControllableByPlayer(caster:GetPlayerID(), true)
		self.death_ward:SetOwner(caster)
		self.death_ward:SetBaseAttackTime( self:GetSpecialValueFor("base_attack_time") )
		self.death_ward:AddNewModifier(caster, self, "modifier_death_ward_handling", {duration = self:GetChannelTime()})
		EmitSoundOn("Hero_WitchDoctor.Death_WardBuild", self.death_ward)
		local exceptionList = {
			["item_imba_azura"] = true,
			["item_imba_bfury"] = true,
			["item_imba_butterfly"] = true,
			["item_imba_echo_sabre"] = true,
			["item_imba_reverb_rapier"] = true,
			["item_imba_starfury"] = true,
			["item_imba_shotgun"] = true,
		}
		for i = 0, 5 do
			local item = caster:GetItemInSlot(i)
			if item and not exceptionList[item:GetName()] then
				self.death_ward:AddItemByName(item:GetName())
			end
		end
		local damageOffset = self.death_ward:GetAverageTrueAttackDamage(self.death_ward)
		self.death_ward:SetBaseDamageMax( self.wardDamage - damageOffset )
		self.death_ward:SetBaseDamageMin( self.wardDamage - damageOffset )
	end
end

function imba_witch_doctor_death_ward:OnChannelFinish()
	if IsServer() then
		StopSoundEvent("Hero_WitchDoctor.Death_WardBuild", self.death_ward)
		UTIL_Remove(self.death_ward)	
	end
end

function imba_witch_doctor_death_ward:OnProjectileHit_ExtraData(target, vLocation, extraData)
	if not self.death_ward:IsNull() then
		self.death_ward:PerformAttack(target, false, true, true, true, false)
		if extraData.bounces_left > 0 and self:GetCaster():HasScepter() then
			extraData.bounces_left = extraData.bounces_left - 1
			extraData[tostring(target:GetEntityIndex())] = 1
			self:CreateBounceAttack(target, extraData)
		end
	end
end

function imba_witch_doctor_death_ward:CreateBounceAttack(originalTarget, extraData)
    local caster = self:GetCaster()
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), originalTarget:GetAbsOrigin(), nil, self:GetSpecialValueFor("bounce_radius"),
                    self:GetAbilityTargetTeam(), self:GetAbilityTargetType(),
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
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

LinkLuaModifier("modifier_death_ward_handling", "hero/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
modifier_death_ward_handling = class({})

function modifier_death_ward_handling:OnCreated()
	self.wardParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_ward_skull.vpcf", PATTACH_POINT_FOLLOW, self:GetParent()) 
		ParticleManager:SetParticleControlEnt(self.wardParticle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.wardParticle, 2, self:GetParent():GetAbsOrigin())
	if IsServer() then
		self:StartIntervalThink( self:GetParent():GetBaseAttackTime() )
	end
end

function modifier_death_ward_handling:OnIntervalThink()
	if IsServer() then
		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("attack_range"), self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 1, false)
		local bounces = 0
		if self:GetCaster():HasScepter() then bounces = self:GetAbility():GetSpecialValueFor("bounces_scepter") end
		for _, unit in pairs(units) do
			local projectile = {
				Target = unit,
				Source = self:GetParent(),
				Ability = self:GetAbility(),
				EffectName = "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_attack.vpcf",
				bDodgable = true,
				bProvidesVision = false,
				iMoveSpeed = self:GetParent():GetProjectileSpeed(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
				ExtraData = {bounces_left = bounces, [tostring(unit:GetEntityIndex())] = 1}
			}
			EmitSoundOn("Hero_WitchDoctor_Ward.Attack", self:GetParent())
			ProjectileManager:CreateTrackingProjectile(projectile)
			break
		end
	end
end

function modifier_death_ward_handling:CheckState()
	local state = {
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
	return state
end