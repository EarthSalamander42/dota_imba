-- Editors:
--     MouJiaoZi, 01.08.2017

function imba_phoenix_check_for_canceled( caster )
	if caster:IsStunned() or caster:IsHexed() or caster:IsNightmared() or caster:HasModifier("modifier_naga_siren_song_of_the_siren") or caster:HasModifier("modifier_eul_cyclone") or caster:IsFrozen() or caster:IsOutOfGame() then
		return true
	else
		return false
	end
end

-------------------------------------------
--			  Icarus Dive
-------------------------------------------
LinkLuaModifier("modifier_imba_phoenix_icarus_dive_dash_dummy", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phoenix_icarus_dive_extend_burn", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phoenix_icarus_dive_ignore_turn_ray", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phoenix_icarus_dive_slow_debuff", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)

imba_phoenix_icarus_dive = imba_phoenix_icarus_dive or class({})

function imba_phoenix_icarus_dive:IsHiddenWhenStolen() 		return false end
function imba_phoenix_icarus_dive:IsRefreshable() 			return true  end
function imba_phoenix_icarus_dive:IsStealable() 			return true  end
function imba_phoenix_icarus_dive:IsNetherWardStealable() 	return false end
function imba_phoenix_icarus_dive:GetAssociatedSecondaryAbilities() return "imba_phoenix_icarus_dive_stop" end

function imba_phoenix_icarus_dive:GetAbilityTextureName()   return "phoenix_icarus_dive" end

function imba_phoenix_icarus_dive:GetCastPoint()
	local caster= self:GetCaster()
	if caster:HasTalent("special_bonus_imba_phoenix_1") then
		return 0
	else
		return self:GetSpecialValueFor("cast_point")
	end
end

function imba_phoenix_icarus_dive:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end

function imba_phoenix_icarus_dive:OnAbilityPhaseStart()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	caster:AddNewModifier(caster, self, "modifier_imba_phoenix_icarus_dive_ignore_turn_ray", {} ) -- Add the ignore turn buff to cast dive when sun ray
	return true
end

function imba_phoenix_icarus_dive:OnSpellStart()
	if not IsServer() then
		return
	end
	local caster		= self:GetCaster()
	local ability		= self
	local target_point  = self:GetCursorPosition()
	local caster_point  = caster:GetAbsOrigin()

	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)

	local hpCost		= self:GetSpecialValueFor("hp_cost_perc")
	local dashLength	= self:GetSpecialValueFor("dash_length")
	local dashWidth		= self:GetSpecialValueFor("dash_width")
	local dashDuration	= self:GetSpecialValueFor("dash_duration")
	local effect_radius = self:GetSpecialValueFor("hit_radius")

	if caster:HasTalent("special_bonus_imba_phoenix_1") then
		hpCost = hpCost * 2
		dashDuration = dashDuration / 2
	end

	local dummy_modifier	= "modifier_imba_phoenix_icarus_dive_dash_dummy" -- This is used to determain if dive can countinue
	caster:AddNewModifier(caster, self, dummy_modifier, { duration = dashDuration })

	local _direction = (target_point - caster:GetAbsOrigin()):Normalized()
	caster:SetForwardVector(_direction)

	local casterOrigin	= caster:GetAbsOrigin()
	local casterAngles	= caster:GetAngles()
	local forwardDir	= caster:GetForwardVector()
	local rightDir		= caster:GetRightVector()

	--caster:SetAngles( casterAngles.x, yaw, casterAngles.z )

	local ellipseCenter	= casterOrigin + forwardDir * ( dashLength / 2 )

	local startTime = GameRules:GetGameTime()

	local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_icarus_dive.vpcf", PATTACH_WORLDORIGIN, nil )

	caster:SetContextThink( DoUniqueString("updateIcarusDive"), function ( )
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + caster:GetRightVector() * 32 )

		local elapsedTime = GameRules:GetGameTime() - startTime
		local progress = elapsedTime / dashDuration
		self.progress = progress

		-- Check the Debuff that can interrupt spell
		if imba_phoenix_check_for_canceled( caster ) then
			caster:RemoveModifierByName("modifier_imba_phoenix_icarus_dive_dash_dummy")
		end

		-- check for interrupted
		if not caster:HasModifier( dummy_modifier ) then
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
			return nil
		end

		-- Calculate potision
		local theta = -2 * math.pi * progress
		local x =  math.sin( theta ) * dashWidth * 0.5
		local y = -math.cos( theta ) * dashLength * 0.5

		local pos = ellipseCenter + rightDir * x + forwardDir * y
		local yaw = casterAngles.y + 90 + progress * -360

		pos = GetGroundPosition( pos, caster )
		caster:SetAbsOrigin( pos )
		caster:SetAngles( casterAngles.x, yaw, casterAngles.z )

		-- Cut Trees
		GridNav:DestroyTreesAroundPoint(pos, 80, false)

		-- Find Enemies apply the debuff
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
			nil,
			effect_radius,
			DOTA_UNIT_TARGET_TEAM_BOTH,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		for _,enemy in pairs(enemies) do
			if enemy ~= caster then
				if enemy:GetTeamNumber() ~= caster:GetTeamNumber() then
					enemy:AddNewModifier(caster, self, "modifier_imba_phoenix_icarus_dive_slow_debuff", {duration = self:GetSpecialValueFor("burn_duration")} )
				else
					enemy:AddNewModifier(caster, self, "modifier_imba_phoenix_burning_wings_ally_buff", {duration = 0.2})
				end
				if caster:HasTalent("special_bonus_imba_phoenix_2") and caster:GetTeamNumber() ~= enemy:GetTeamNumber() then
					local item = CreateItem( "item_imba_dummy", caster, caster)
					item:ApplyDataDrivenModifier( caster, enemy, "modifier_stunned", {duration = caster:FindTalentValue("special_bonus_imba_phoenix_2","stun_duration")} )
					UTIL_Remove(item)
				end
			end
		end
		enemies = {}

		return 0.03
	end, 0 )

	-- Spend HP cost
	self.healthCost = caster:GetHealth() * hpCost / 100
	if caster:HasModifier("modifier_imba_phoenix_burning_wings_buff") then
		caster:Heal(self.healthCost, caster)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, self.healthCost, nil)
	else
		local AfterCastHealth = caster:GetHealth() - self.healthCost
		if AfterCastHealth <= 1 then
			caster:SetHealth(1)
		else
			caster:SetHealth(AfterCastHealth)
		end
	end

	-- Swap sub ability
	local sub_ability_name	= "imba_phoenix_icarus_dive_stop"
	local main_ability_name	= ability:GetAbilityName()
	caster:SwapAbilities( main_ability_name, sub_ability_name, false, true )
end

function imba_phoenix_icarus_dive:OnUpgrade()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()

	-- The ability to level up
	local ability_name = "imba_phoenix_icarus_dive_stop"
	local ability_handle = caster:FindAbilityByName(ability_name)
	if ability_handle then
		ability_handle:SetLevel(1)
	end
end

modifier_imba_phoenix_icarus_dive_dash_dummy = modifier_imba_phoenix_icarus_dive_dash_dummy or class({})

function modifier_imba_phoenix_icarus_dive_dash_dummy:IsDebuff()			return false end
function modifier_imba_phoenix_icarus_dive_dash_dummy:IsHidden() 			return true  end
function modifier_imba_phoenix_icarus_dive_dash_dummy:IsPurgable() 			return false end
function modifier_imba_phoenix_icarus_dive_dash_dummy:IsPurgeException() 	return false end
function modifier_imba_phoenix_icarus_dive_dash_dummy:IsStunDebuff() 		return false end
function modifier_imba_phoenix_icarus_dive_dash_dummy:RemoveOnDeath() 		return true  end

function modifier_imba_phoenix_icarus_dive_dash_dummy:GetEffectName() return "particles/units/heroes/hero_phoenix/phoenix_supernova_radiance_streak_light.vpcf" end

function modifier_imba_phoenix_icarus_dive_dash_dummy:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		}
	return decFuns
end

function modifier_imba_phoenix_icarus_dive_dash_dummy:GetModifierIgnoreCastAngle() return 360 end

function modifier_imba_phoenix_icarus_dive_dash_dummy:GetTexture()
	return "phoenix_icarus_dive"
end

function modifier_imba_phoenix_icarus_dive_dash_dummy:OnCreated()
	if not IsServer() then
		return
	end

	local caster = self:GetCaster()
	EmitSoundOn("Hero_Phoenix.IcarusDive.Cast", caster)

	-- Disable Sun Ray spell
	local sun_ray = caster:FindAbilityByName("imba_phoenix_sun_ray")
	if sun_ray then
		sun_ray:SetActivated(false)
	end
end

function modifier_imba_phoenix_icarus_dive_dash_dummy:OnDestroy()
	if not IsServer() then
		return
	end

	local caster = self:GetCaster()
	local point = caster:GetAbsOrigin()
	local ability = self:GetAbility()
	local hpCost = ability.healthCost
	local dmg_heal_max = ability:GetSpecialValueFor("stop_dmg_heal_max")
	local radius = ability:GetSpecialValueFor("stop_radius")
	local stop_dmg_heal

	-- IMBA: when finish cast, deal dmg and heal to near by units, number is equal to the hp cost
	if hpCost > dmg_heal_max then
		stop_dmg_heal = dmg_heal_max
	else
		stop_dmg_heal = hpCost
	end

	local units = FindUnitsInRadius(caster:GetTeamNumber(),
		point,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	for _, unit in pairs(units) do -- It's an ally, heal
		if unit:GetTeamNumber() == caster:GetTeamNumber() and unit ~= caster then
			local heal_amp = 1 + (caster:GetSpellAmplification(false) * 0.01)
			stop_dmg_heal = stop_dmg_heal * heal_amp
			unit:Heal(stop_dmg_heal, caster)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, stop_dmg_heal, nil)
	elseif unit:GetTeamNumber() ~= caster:GetTeamNumber() and unit ~= caster then -- It's  an enemy, dmg
		local damageTable = {
			victim = unit,
			attacker = caster,
			damage = stop_dmg_heal,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(),
		}
	ApplyDamage(damageTable)
	end
	end

	-- IMBA: when finish cast, deal dmg and heal to near by units, number is equal to the hp cost
	caster:AddNewModifier(caster, ability, "modifier_imba_phoenix_icarus_dive_extend_burn", { duration = ability:GetSpecialValueFor("extend_burn_duration") } ) -- IMBA: Extend the burn effect after cast finish

	local sun_ray = caster:FindAbilityByName("imba_phoenix_sun_ray")
	if sun_ray then
		sun_ray:SetActivated(true) -- Re-activa the SUN RAY
	end

	-- Switch the dive abilities
	local sub_ability_name	= "imba_phoenix_icarus_dive"
	local main_ability_name	= "imba_phoenix_icarus_dive_stop"
	caster:SwapAbilities( main_ability_name, sub_ability_name, false, true )
	caster:RemoveModifierByName("modifier_imba_phoenix_icarus_dive_ignore_turn_ray")

	-- Audio-visual effects
	StopSoundOn("Hero_Phoenix.IcarusDive.Cast", caster)
	EmitSoundOn("Hero_Phoenix.IcarusDive.Stop", caster)
	caster:RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_1)

	-- Anti-stuck
	caster:SetContextThink( DoUniqueString("waitToFindClearSpace"), function ( )
		if not caster:HasModifier("modifier_naga_siren_song_of_the_siren") then
			FindClearSpaceForUnit(caster, point, false)
			return nil
		end
		return 0.1
	end, 0 )

end

modifier_imba_phoenix_icarus_dive_ignore_turn_ray = modifier_imba_phoenix_icarus_dive_ignore_turn_ray or class({})

function modifier_imba_phoenix_icarus_dive_ignore_turn_ray:IsDebuff()			return false end
function modifier_imba_phoenix_icarus_dive_ignore_turn_ray:IsHidden() 			return true  end
function modifier_imba_phoenix_icarus_dive_ignore_turn_ray:IsPurgable() 			return false end
function modifier_imba_phoenix_icarus_dive_ignore_turn_ray:IsPurgeException() 	return false end
function modifier_imba_phoenix_icarus_dive_ignore_turn_ray:IsStunDebuff() 		return false end
function modifier_imba_phoenix_icarus_dive_ignore_turn_ray:RemoveOnDeath() 		return true  end

modifier_imba_phoenix_icarus_dive_slow_debuff = modifier_imba_phoenix_icarus_dive_slow_debuff or class({})

function modifier_imba_phoenix_icarus_dive_slow_debuff:IsDebuff()			return true  end

function modifier_imba_phoenix_icarus_dive_slow_debuff:IsHidden()
	if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		return false
	else
		return true
	end
end

function modifier_imba_phoenix_icarus_dive_slow_debuff:IsPurgable()
	if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		return true
	else
		return false
	end
end

function modifier_imba_phoenix_icarus_dive_slow_debuff:IsPurgeException()
	if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		return true
	else
		return false
	end
end

function modifier_imba_phoenix_icarus_dive_slow_debuff:IsStunDebuff() 		return false end
function modifier_imba_phoenix_icarus_dive_slow_debuff:RemoveOnDeath() 		return true  end

function modifier_imba_phoenix_icarus_dive_slow_debuff:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
		}
	return decFuns
end

function modifier_imba_phoenix_icarus_dive_slow_debuff:GetTexture()
	return "phoenix_icarus_dive"
end

function modifier_imba_phoenix_icarus_dive_slow_debuff:GetEffectName()	return "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf" end

function modifier_imba_phoenix_icarus_dive_slow_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_phoenix_icarus_dive_slow_debuff:GetModifierMoveSpeedBonus_Percentage()	return self:GetAbility():GetSpecialValueFor("slow_movement_speed_pct") * (-1)  end

function modifier_imba_phoenix_icarus_dive_slow_debuff:OnCreated()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	local tick = ability:GetSpecialValueFor("burn_tick_interval")
	self:StartIntervalThink( tick )
end


function modifier_imba_phoenix_icarus_dive_slow_debuff:OnIntervalThink()
	if not IsServer() then
		return
	end
	if not self:GetParent():IsAlive() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local tick = ability:GetSpecialValueFor("burn_tick_interval")
	local dmg = ability:GetSpecialValueFor("damage_per_second") * ( tick / 1.0 )
	local damageTable = {
		victim = self:GetParent(),
		attacker = caster,
		damage = dmg,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
	}
	ApplyDamage(damageTable)
end

modifier_imba_phoenix_icarus_dive_extend_burn = modifier_imba_phoenix_icarus_dive_extend_burn or class({})

function modifier_imba_phoenix_icarus_dive_extend_burn:IsDebuff()			return false end
function modifier_imba_phoenix_icarus_dive_extend_burn:IsHidden() 			return false  end
function modifier_imba_phoenix_icarus_dive_extend_burn:IsPurgable() 		return false end
function modifier_imba_phoenix_icarus_dive_extend_burn:IsPurgeException() 	return false end
function modifier_imba_phoenix_icarus_dive_extend_burn:IsStunDebuff() 		return false end
function modifier_imba_phoenix_icarus_dive_extend_burn:RemoveOnDeath() 		return true  end

function modifier_imba_phoenix_icarus_dive_extend_burn:GetTexture() return "phoenix_icarus_dive" end
function modifier_imba_phoenix_icarus_dive_extend_burn:GetEffectName() return "particles/units/heroes/hero_phoenix/phoenix_supernova_radiance_streak_light.vpcf" end

function modifier_imba_phoenix_icarus_dive_extend_burn:OnCreated()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	ability.extPfx = ParticleManager:CreateParticle("particles/econ/courier/courier_greevil_red/courier_greevil_red_ambient_3.vpcf",PATTACH_POINT_FOLLOW,caster)
	ParticleManager:SetParticleControlEnt(ability.extPfx,0,caster,PATTACH_POINT_FOLLOW,"attach_hitloc",caster:GetAbsOrigin(),true)
	ParticleManager:SetParticleControlEnt(ability.extPfx,1,caster,PATTACH_POINT_FOLLOW,"attach_hitloc",caster:GetAbsOrigin(),true)
	self:StartIntervalThink(0.1)
end

function modifier_imba_phoenix_icarus_dive_extend_burn:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		ability:GetSpecialValueFor("hit_radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, ability, "modifier_imba_phoenix_icarus_dive_slow_debuff", {duration = ability:GetSpecialValueFor("burn_duration")} )
	end
end

function modifier_imba_phoenix_icarus_dive_extend_burn:OnDestroy()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	ParticleManager:DestroyParticle(ability.extPfx, false)
	ParticleManager:ReleaseParticleIndex(ability.extPfx)
end

-------------------------------------------
--			  Icarus Dive : Stop
-------------------------------------------

imba_phoenix_icarus_dive_stop = imba_phoenix_icarus_dive_stop or class({})

function imba_phoenix_icarus_dive_stop:IsHiddenWhenStolen() 	return true end
function imba_phoenix_icarus_dive_stop:IsRefreshable() 			return true  end
function imba_phoenix_icarus_dive_stop:IsStealable() 			return false end
function imba_phoenix_icarus_dive_stop:IsNetherWardStealable() 	return false end
function imba_phoenix_icarus_dive_stop:GetAssociatedPrimaryAbilities()  return "imba_phoenix_icarus_dive" end

function imba_phoenix_icarus_dive_stop:GetAbilityTextureName()
	return "phoenix_icarus_dive_stop"
end

function imba_phoenix_icarus_dive_stop:OnSpellStart()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_imba_phoenix_icarus_dive_dash_dummy")

	-- IMBA: Stop diving by cast will reduce the CD, which is 50% of diving progress
	local ability = caster:FindAbilityByName("imba_phoenix_icarus_dive")
	-- Rubick steal fix
	if not ability.progress then return end
	local cdr_pct = ability.progress / 2
	local cd_now = ability:GetCooldownTimeRemaining()
	local cd_toSet = cd_now * (1 - cdr_pct)
	if cd_toSet > 0 then
		ability:EndCooldown()
		ability:StartCooldown(cd_toSet)
	end
end

function imba_phoenix_icarus_dive_stop:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end

-------------------------------------------
--			  Fire Spirits
-------------------------------------------
LinkLuaModifier("modifier_imba_phoenix_fire_spirits_count", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)

imba_phoenix_fire_spirits = imba_phoenix_fire_spirits or class({})

function imba_phoenix_fire_spirits:IsHiddenWhenStolen() 	return false end
function imba_phoenix_fire_spirits:IsRefreshable() 			return true  end
function imba_phoenix_fire_spirits:IsStealable() 			return true  end
function imba_phoenix_fire_spirits:IsNetherWardStealable() 	return false end
function imba_phoenix_fire_spirits:GetAssociatedSecondaryAbilities() return "imba_phoenix_launch_fire_spirit" end

function imba_phoenix_fire_spirits:GetAbilityTextureName() return "phoenix_fire_spirits" end

function imba_phoenix_fire_spirits:OnSpellStart()
	if not IsServer() then
		return
	end

	local caster	= self:GetCaster()
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
	EmitSoundOn("Hero_Phoenix.FireSpirits.Cast", caster)

	caster.ability_spirits = self

	local hpCost		= self:GetTalentSpecialValueFor("hp_cost_perc")
	local numSpirits	= self:GetTalentSpecialValueFor("spirit_count")
	local AfterCastHealth = caster:GetHealth()-(caster:GetHealth() * hpCost / 100)

	if caster:HasModifier("modifier_imba_phoenix_burning_wings_buff") then
		caster:Heal((caster:GetHealth() * hpCost / 100), caster)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, (caster:GetHealth() * hpCost / 100), nil)
	else
		if AfterCastHealth <= 1 then
			caster:SetHealth(1)
		else
			caster:SetHealth(AfterCastHealth)
		end
	end

	-- Create particle FX
	local particleName = "particles/units/heroes/hero_phoenix/phoenix_fire_spirits.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( pfx, 1, Vector( numSpirits, 0, 0 ) )
	for i=1, numSpirits do
		ParticleManager:SetParticleControl( pfx, 8+i, Vector( 1, 0, 0 ) )
	end

	caster.fire_spirits_numSpirits	= numSpirits
	caster.fire_spirits_pfx			= pfx

	-- Set the stack count
	local iDuration = self:GetSpecialValueFor("spirit_duration")
	if self:GetCaster():HasTalent("special_bonus_imba_phoenix_7") then
		iDuration = iDuration * self:GetCaster():FindTalentValue("special_bonus_imba_phoenix_7","duration_pct") / 100
	end
	caster:AddNewModifier(caster, self, "modifier_imba_phoenix_fire_spirits_count", { duration =  iDuration})
	if not caster:HasTalent("special_bonus_imba_phoenix_7") then
		caster:SetModifierStackCount( "modifier_imba_phoenix_fire_spirits_count", caster, numSpirits )
	end

	-- Swap sub ability
	local sub_ability_name	= "imba_phoenix_launch_fire_spirit"
	local main_ability_name	= self:GetAbilityName()
	caster:SwapAbilities( main_ability_name, sub_ability_name, false, true )
end

function imba_phoenix_fire_spirits:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function imba_phoenix_fire_spirits:OnUpgrade()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local this_ability = self
	local this_abilityName = self:GetAbilityName()
	local this_abilityLevel = self:GetLevel()

	-- The ability to level up
	local ability_name = "imba_phoenix_launch_fire_spirit"
	local ability_handle = caster:FindAbilityByName(ability_name)
	if ability_handle then
		local ability_level = ability_handle:GetLevel()

		-- Check to not enter a level up loop
		if ability_level ~= this_abilityLevel then
			ability_handle:SetLevel(this_abilityLevel)
		end
	end
end

modifier_imba_phoenix_fire_spirits_count = modifier_imba_phoenix_fire_spirits_count or class({})

function modifier_imba_phoenix_fire_spirits_count:IsDebuff()			return false end
function modifier_imba_phoenix_fire_spirits_count:IsHidden() 			return false end
function modifier_imba_phoenix_fire_spirits_count:IsPurgable() 			return false end
function modifier_imba_phoenix_fire_spirits_count:IsPurgeException() 	return false end
function modifier_imba_phoenix_fire_spirits_count:IsStunDebuff() 		return false end
function modifier_imba_phoenix_fire_spirits_count:RemoveOnDeath() 		return true  end

function modifier_imba_phoenix_fire_spirits_count:GetTexture()
	return "phoenix_fire_spirits"
end

function modifier_imba_phoenix_fire_spirits_count:OnCreated()
	if not IsServer() then
		return
	end
	self:StartIntervalThink(1.0)
end

function modifier_imba_phoenix_fire_spirits_count:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("imba_phoenix_launch_fire_spirit")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		192,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, ability, "modifier_imba_phoenix_fire_spirits_debuff", { duration = ability:GetSpecialValueFor("duration") } )
	end
end

function modifier_imba_phoenix_fire_spirits_count:OnDestroy()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local pfx = caster.fire_spirits_pfx
	if pfx then
		ParticleManager:DestroyParticle( pfx, false )
		ParticleManager:ReleaseParticleIndex( pfx )
	end
	local main_ability_name	= "imba_phoenix_fire_spirits"
	local sub_ability_name	= "imba_phoenix_launch_fire_spirit"
	if caster then
		caster:SwapAbilities( main_ability_name, sub_ability_name, true, false )
	end
end

-------------------------------------------
--			  Fire Spirits : Launch
-------------------------------------------

LinkLuaModifier("modifier_imba_phoenix_fire_spirits_debuff", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phoenix_fire_spirits_buff", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)

imba_phoenix_launch_fire_spirit = imba_phoenix_launch_fire_spirit or class({})

function imba_phoenix_launch_fire_spirit:IsHiddenWhenStolen() 		return true end
function imba_phoenix_launch_fire_spirit:IsRefreshable() 			return true  end
function imba_phoenix_launch_fire_spirit:IsStealable() 				return false end
function imba_phoenix_launch_fire_spirit:IsNetherWardStealable() 	return false end
function imba_phoenix_launch_fire_spirit:GetAssociatedPrimaryAbilities() return "imba_phoenix_fire_spirits" end

function imba_phoenix_launch_fire_spirit:GetAbilityTextureName()   return "phoenix_launch_fire_spirit" end

function imba_phoenix_launch_fire_spirit:GetAOERadius()  return self:GetSpecialValueFor("radius") end

function imba_phoenix_launch_fire_spirit:GetManaCost()
	if not self:GetCaster():HasTalent("special_bonus_imba_phoenix_7") then
		return 0
	else
		return self:GetCaster():FindTalentValue("special_bonus_imba_phoenix_7","mana_cost")
	end
end

function imba_phoenix_launch_fire_spirit:OnSpellStart()
	if not IsServer() then
		return
	end
	local caster		= self:GetCaster()
	local point 		= self:GetCursorPosition()
	point.z = point.z + 70
	local ability		= self
	local modifierName	= "modifier_imba_phoenix_fire_spirits_count"
	local iModifier 	= caster:FindModifierByName(modifierName)

	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
	EmitSoundOn("Hero_Phoenix.FireSpirits.Launch", caster)

	if not caster:HasTalent("special_bonus_imba_phoenix_7") then
		-- Update spirits count
		local currentStack
		if iModifier then
			iModifier:DecrementStackCount()
			currentStack = iModifier:GetStackCount()
		else
			return
		end

		-- Update the particle FX
		local pfx = caster.fire_spirits_pfx
		ParticleManager:SetParticleControl( pfx, 1, Vector( currentStack, 0, 0 ) )
		for i=1, caster.fire_spirits_numSpirits do
			local radius = 0
			if i <= currentStack then
				radius = 1
			end
			ParticleManager:SetParticleControl( pfx, 8+i, Vector( radius, 0, 0 ) )
		end
	end

	-- Projectile
	local direction = (point - caster:GetAbsOrigin()):Normalized()
	local DummyUnit = CreateUnitByName("npc_dummy_unit",point,false,caster,caster:GetOwner(),caster:GetTeamNumber())
	DummyUnit:AddNewModifier(caster, ability, "modifier_kill", {duration = 0.1})
	local cast_target = DummyUnit

	local info =
		{
			Target = cast_target,
			Source = caster,
			Ability = ability,
			EffectName = "particles/hero/phoenix/phoenix_fire_spirit_launch.vpcf",
			iMoveSpeed = self:GetSpecialValueFor("spirit_speed"),
			vSourceLoc = direction,							-- Optional (HOW)
			bDrawsOnMinimap = false,						-- Optional
			bDodgeable = false,								-- Optional
			bIsAttack = false,								-- Optional
			bVisibleToEnemies = true,						-- Optional
			bReplaceExisting = false,						-- Optional
			flExpireTime = GameRules:GetGameTime() + 10,	-- Optional but recommended
			bProvidesVision = false,						-- Optional
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
		}
	ProjectileManager:CreateTrackingProjectile(info)

	-- Remove the stack modifier if all the spirits has been launched.
	if iModifier:GetStackCount() < 1 and not self:GetCaster():HasTalent("special_bonus_imba_phoenix_7") then
		iModifier:Destroy()
	end
end

function imba_phoenix_launch_fire_spirit:OnProjectileThink( vLocation )
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		vLocation,
		nil,
		20,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	for _, enemy in pairs(enemies) do
		if enemy:GetTeamNumber() ~= caster:GetTeamNumber() then
			enemy:AddNewModifier(caster, ability, "modifier_imba_phoenix_fire_spirits_debuff", { duration = ability:GetSpecialValueFor("duration") } )
		else
			enemy:AddNewModifier(caster, ability, "modifier_imba_phoenix_burning_wings_ally_buff", {duration = 0.2})
		end
	end
end

function imba_phoenix_launch_fire_spirit:OnProjectileHit( hTarget, vLocation)
	if not IsServer() then
		return
	end

	local caster = self:GetCaster()
	local location = vLocation
	if hTarget then
		location = hTarget:GetAbsOrigin()
	end
	-- Particles and sound
	local DummyUnit = CreateUnitByName("npc_dummy_unit",location,false,caster,caster:GetOwner(),caster:GetTeamNumber())
	DummyUnit:AddNewModifier(caster, ability, "modifier_kill", {duration = 0.1})
	local pfx_explosion = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_explosion, 0, location)
	ParticleManager:ReleaseParticleIndex(pfx_explosion)

	EmitSoundOn("Hero_Phoenix.ProjectileImpact", DummyUnit)
	EmitSoundOn("Hero_Phoenix.FireSpirits.Target", DummyUnit)

	-- Vision
	AddFOWViewer(caster:GetTeamNumber(), DummyUnit:GetAbsOrigin(), 175, 1, true)

	local units = FindUnitsInRadius(caster:GetTeamNumber(),
		location,
		nil,
		self:GetSpecialValueFor("radius"),
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	for _,unit in pairs(units) do
		if unit ~= caster then
			if unit:GetTeamNumber() ~= caster:GetTeamNumber() then
				unit:AddNewModifier(caster, self, "modifier_imba_phoenix_fire_spirits_debuff", {duration = self:GetSpecialValueFor("duration")} )
			else
				unit:AddNewModifier(caster, self, "modifier_imba_phoenix_fire_spirits_buff", {duration = self:GetSpecialValueFor("duration")} )
			end
		end
	end
	return true
end

function imba_phoenix_launch_fire_spirit:GetCastAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_2
end

function imba_phoenix_launch_fire_spirit:OnUpgrade()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local this_ability = self
	local this_abilityName = self:GetAbilityName()
	local this_abilityLevel = self:GetLevel()

	-- The ability to level up
	local ability_name = "imba_phoenix_fire_spirits"
	local ability_handle = caster:FindAbilityByName(ability_name)
	local ability_level = ability_handle:GetLevel()

	-- Check to not enter a level up loop
	if ability_level ~= this_abilityLevel then
		ability_handle:SetLevel(this_abilityLevel)
	end
end


modifier_imba_phoenix_fire_spirits_debuff = modifier_imba_phoenix_fire_spirits_debuff or class({})

function modifier_imba_phoenix_fire_spirits_debuff:IsDebuff()			return true  end
function modifier_imba_phoenix_fire_spirits_debuff:IsHidden() 			return false end
function modifier_imba_phoenix_fire_spirits_debuff:IsPurgable() 		return true  end
function modifier_imba_phoenix_fire_spirits_debuff:IsPurgeException() 	return true  end
function modifier_imba_phoenix_fire_spirits_debuff:IsStunDebuff() 		return false end
function modifier_imba_phoenix_fire_spirits_debuff:RemoveOnDeath() 		return true  end

function modifier_imba_phoenix_fire_spirits_debuff:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
		}
	return decFuns
end

function modifier_imba_phoenix_fire_spirits_debuff:GetTexture()
	return "phoenix_fire_spirits"
end

function modifier_imba_phoenix_fire_spirits_debuff:GetEffectName() return "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_burn.vpcf" end
function modifier_imba_phoenix_fire_spirits_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_phoenix_fire_spirits_debuff:GetModifierAttackSpeedBonus_Constant()
	if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return 0
	else
		return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("attackspeed_slow") * (-1)
	end
end

function modifier_imba_phoenix_fire_spirits_debuff:OnCreated()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	if self:GetStackCount() <= 1 then
		self:SetStackCount(1)
	end
	local tick = ability:GetSpecialValueFor("tick_interval")
	self:StartIntervalThink( tick )
end

function modifier_imba_phoenix_fire_spirits_debuff:OnRefresh()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	if self:GetStackCount() <= 1 then
		self:SetStackCount(1)
	end
	if caster:HasTalent("special_bonus_imba_phoenix_3") and self:GetStackCount() < caster:FindTalentValue("special_bonus_imba_phoenix_3","max_stacks") then
		self:IncrementStackCount()
	end
end

function modifier_imba_phoenix_fire_spirits_debuff:OnIntervalThink()
	if not IsServer() then
		return
	end
	if not self:GetParent():IsAlive() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local tick = ability:GetSpecialValueFor("tick_interval")
	local dmg = ability:GetSpecialValueFor("damage_per_second") * ( tick / 1.0 )
	local damageTable = {
		victim = self:GetParent(),
		attacker = caster,
		damage = dmg * self:GetStackCount(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
	}
	ApplyDamage(damageTable)
end

modifier_imba_phoenix_fire_spirits_buff = modifier_imba_phoenix_fire_spirits_buff or class({})

function modifier_imba_phoenix_fire_spirits_buff:IsDebuff()			return false end

function modifier_imba_phoenix_fire_spirits_buff:IsHidden() 			return false end
function modifier_imba_phoenix_fire_spirits_buff:IsPurgable() 			return true  end
function modifier_imba_phoenix_fire_spirits_buff:IsPurgeException() 	return true  end
function modifier_imba_phoenix_fire_spirits_buff:IsStunDebuff() 		return false end
function modifier_imba_phoenix_fire_spirits_buff:RemoveOnDeath() 		return true  end

function modifier_imba_phoenix_fire_spirits_buff:GetTexture()
	return "phoenix_fire_spirits"
end

function modifier_imba_phoenix_fire_spirits_buff:GetEffectName() return "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_burn.vpcf" end
function modifier_imba_phoenix_fire_spirits_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_phoenix_fire_spirits_buff:OnCreated()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	if self:GetStackCount() <= 1 then
		self:SetStackCount(1)
	end
	local tick = ability:GetSpecialValueFor("tick_interval")
	self:StartIntervalThink( tick )
end

function modifier_imba_phoenix_fire_spirits_buff:OnRefresh()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	if self:GetStackCount() <= 1 then
		self:SetStackCount(1)
	end
	if caster:HasTalent("special_bonus_imba_phoenix_3") and self:GetStackCount() < caster:FindTalentValue("special_bonus_imba_phoenix_3","max_stacks") then
		self:IncrementStackCount()
	end
end

function modifier_imba_phoenix_fire_spirits_buff:OnIntervalThink()
	if not IsServer() then
		return
	end
	if not self:GetParent():IsAlive() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local tick = ability:GetSpecialValueFor("tick_interval")
	local dmg = ability:GetSpecialValueFor("damage_per_second") * ( tick / 1.0 )
	local heal_amp = 1 + (caster:GetSpellAmplification(false) * 0.01)
	dmg = dmg * heal_amp
	self:GetParent():Heal(dmg * self:GetStackCount(), caster)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), dmg * self:GetStackCount(), nil)
end


-------------------------------------------
--			  Sun Ray
-------------------------------------------

imba_phoenix_sun_ray = imba_phoenix_sun_ray or class({})

function imba_phoenix_sun_ray:IsHiddenWhenStolen() 		return false end
function imba_phoenix_sun_ray:IsRefreshable() 			return true  end
function imba_phoenix_sun_ray:IsStealable() 			return true  end
function imba_phoenix_sun_ray:IsNetherWardStealable() 	return true  end
function imba_phoenix_sun_ray:GetAssociatedSecondaryAbilities()  return "imba_phoenix_sun_ray_toggle_move" end

function imba_phoenix_sun_ray:GetAbilityTextureName()   return "phoenix_sun_ray" end

LinkLuaModifier("modifier_imba_phoenix_sun_ray_caster_dummy", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phoenix_sun_ray_dummy_unit_thinker", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phoenix_sun_ray_dummy_buff", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phoenix_sun_ray_buff", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phoenix_sun_ray_debuff", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)

function imba_phoenix_sun_ray:OnSpellStart()
	if not IsServer() then
		return
	end

	local caster	= self:GetCaster()
	local ability	= self

	local ray_stop = caster:FindAbilityByName("imba_phoenix_sun_ray_stop")
	local toggle_move = caster:FindAbilityByName("imba_phoenix_sun_ray_toggle_move")
	if not ray_stop or not toggle_move then
		caster:RemoveAbility("imba_phoenix_sun_ray")
		return
	end

	local pathLength					= self:GetSpecialValueFor("beam_range")
	local max_duration 					= self:GetSpecialValueFor("duration")
	local forwardMoveSpeed				= self:GetSpecialValueFor("move_speed")
	local turnRateInitial				= self:GetSpecialValueFor("turn_rate_initial")
	local turnRate						= self:GetSpecialValueFor("turn_rate")
	local initialTurnDuration			= self:GetSpecialValueFor("initial_turn_max_duration")
	local vision_radius					= self:GetSpecialValueFor("radius") / 2
	local numVision						= math.ceil( pathLength / vision_radius )
	local modifierCasterName			= "modifier_imba_phoenix_sun_ray_caster_dummy"

	local casterOrigin	= caster:GetAbsOrigin()

	caster:AddNewModifier(caster, ability, modifierCasterName, { duration = max_duration })

	caster.sun_ray_is_moving = false
	caster.sun_ray_hp_at_start = caster:GetHealth()

	-- Create particle FX
	local particleName = "particles/units/heroes/hero_phoenix/phoenix_sunray.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, nil )
	local attach_point = caster:ScriptLookupAttachment( "attach_head" )
	-- Attach a loop sound to the endcap
	local endcapSoundName = "Hero_Phoenix.SunRay.Beam"
	StartSoundEvent( endcapSoundName, endcap )
	StartSoundEvent("Hero_Phoenix.SunRay.Cast", caster)

	--
	-- Note: The turn speed
	--
	--  Original's actual turn speed = 277.7735 (at initial) and 22.2218 [deg/s].
	--  We can achieve this weird value by using this formula.
	--	  actual_turn_rate = turn_rate / (0.0333..) * 0.03
	--
	--  And, initial turn buff ends when the delta yaw gets 0 or 0.75 seconds elapsed.
	--
	turnRateInitial	= turnRateInitial	/ (1/30) * 0.03
	turnRate		= turnRate			/ (1/30) * 0.03

	-- Update
	local deltaTime = 0.03

	local lastAngles = caster:GetAngles()
	local isInitialTurn = true
	local elapsedTime = 0.0

	caster:SetContextThink( DoUniqueString( "updateSunRay" ), function ( )

			ParticleManager:SetParticleControl(pfx, 0, caster:GetAttachmentOrigin(attach_point))
			-- Check the Debuff that can interrupt spell
			if imba_phoenix_check_for_canceled( caster ) then
				caster:RemoveModifierByName("modifier_imba_phoenix_sun_ray_caster_dummy")
			end

			-- OnInterrupted :
			--  Destroy FXs and the thinkers.
			if not caster:HasModifier( modifierCasterName ) then
				ParticleManager:DestroyParticle( pfx, false )
				StopSoundEvent( endcapSoundName, endcap )
				caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
				return nil
			end

			-- Cut Trees
			local pos = caster:GetAbsOrigin()
			GridNav:DestroyTreesAroundPoint(pos, 128, false)

			-- 距离是32
			-- "MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE" is seems to be broken.
			-- So here we fix the yaw angle manually in order to clamp the turn speed.
			--
			-- If the hero has "modifier_ignore_turn_rate_limit_datadriven" modifier,
			-- we shouldn't change yaw from here.
			--
			-- Calculate the turn speed limit.
			local deltaYawMax

			if isInitialTurn then
				deltaYawMax = turnRateInitial * deltaTime
			else
				deltaYawMax = turnRate * deltaTime
			end

			-- Calculate the delta yaw
			local currentAngles	= caster:GetAngles()
			local deltaYaw		= RotationDelta( lastAngles, currentAngles ).y
			local deltaYawAbs	= math.abs( deltaYaw )

			if deltaYawAbs > deltaYawMax and not caster:HasModifier( "modifier_imba_phoenix_icarus_dive_ignore_turn_ray" ) and not caster:HasTalent("special_bonus_imba_phoenix_8")then
				-- Clamp delta yaw
				local yawSign = (deltaYaw < 0) and -1 or 1
				local yaw = lastAngles.y + deltaYawMax * yawSign

				currentAngles.y = yaw	-- Never forget!

				-- Update the yaw
				caster:SetAngles( currentAngles.x, currentAngles.y, currentAngles.z )
			end

			lastAngles = currentAngles

			-- Update the turning state.
			elapsedTime = elapsedTime + deltaTime

			if isInitialTurn then
				if deltaYawAbs == 0 then
					isInitialTurn = false
				end
				if elapsedTime >= initialTurnDuration then
					isInitialTurn = false
				end
			end

			-- Current position & direction
			local casterOrigin	= caster:GetAbsOrigin()
			local casterForward	= caster:GetForwardVector()

			-- Move forward
			if caster.sun_ray_is_moving and not GameRules:IsGamePaused() then
				casterOrigin = casterOrigin + casterForward * forwardMoveSpeed * deltaTime
				casterOrigin = GetGroundPosition( casterOrigin, caster )
				caster:SetAbsOrigin( casterOrigin )
			end

			-- Update thinker positions
			local endcapPos = casterOrigin + casterForward * pathLength
			endcapPos = GetGroundPosition( endcapPos, nil )
			endcapPos.z = endcapPos.z + 92

			-- Update particle FX
			ParticleManager:SetParticleControl( pfx, 1, endcapPos )

			-- Dmg and heal
			local units = FindUnitsInLine(caster:GetTeamNumber(),
				caster:GetAbsOrigin() + caster:GetForwardVector() * 32 ,
				endcapPos,
				nil,
				ability:GetSpecialValueFor("radius"),
				DOTA_UNIT_TARGET_TEAM_BOTH,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE)
			for _,unit in pairs(units) do
				unit:AddNewModifier(caster, ability, "modifier_imba_phoenix_sun_ray_dummy_buff", { duration = ability:GetSpecialValueFor("tick_interval") } )
			end

			-- Give vision
			for i=1, numVision do
				AddFOWViewer(caster:GetTeamNumber(), ( casterOrigin + casterForward * ( vision_radius * 2 * (i-1) ) ), vision_radius, deltaTime, false)
			end

			return deltaTime

	end, 0.0 )

end

function imba_phoenix_sun_ray:OnUpgrade()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()

	-- I love Rubick
	if self:IsStolen() then
		caster:AddAbility("imba_phoenix_sun_ray_stop")
		local stop = caster:FindAbilityByName("imba_phoenix_sun_ray_stop")
		--stop:SetHidden(true)
		stop:SetStolen(true)
		stop:SetLevel(1)
	end
	caster.sun_ray_is_moving = false

	-- The ability to level up
	local ray_stop = caster:FindAbilityByName("imba_phoenix_sun_ray_stop")
	if ray_stop then
		ray_stop:SetLevel(1)
	end

	local toggle_move = caster:FindAbilityByName("imba_phoenix_sun_ray_toggle_move")
	if toggle_move then
		toggle_move:SetLevel(1)
		toggle_move:SetActivated(false)
	end

end

modifier_imba_phoenix_sun_ray_caster_dummy = modifier_imba_phoenix_sun_ray_caster_dummy or class({})

function modifier_imba_phoenix_sun_ray_caster_dummy:IsDebuff()			return false end
function modifier_imba_phoenix_sun_ray_caster_dummy:IsHidden() 			return true  end
function modifier_imba_phoenix_sun_ray_caster_dummy:IsPurgable() 		return false end
function modifier_imba_phoenix_sun_ray_caster_dummy:IsPurgeException() 	return false end
function modifier_imba_phoenix_sun_ray_caster_dummy:IsStunDebuff() 		return false end
function modifier_imba_phoenix_sun_ray_caster_dummy:RemoveOnDeath() 	return true  end

function modifier_imba_phoenix_sun_ray_caster_dummy:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE}
	return funcs
end

function modifier_imba_phoenix_sun_ray_caster_dummy:CheckState()
	return{ [MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
end

function modifier_imba_phoenix_sun_ray_caster_dummy:GetModifierMoveSpeed_Limit()
	if not self:GetCaster():HasTalent("special_bonus_imba_phoenix_8") then
		return 1
	else
		return nil
	end
end

function modifier_imba_phoenix_sun_ray_caster_dummy:GetModifierMoveSpeed_Max()
	if not self:GetCaster():HasTalent("special_bonus_imba_phoenix_8") then
		return 1
	else
		return nil
	end
end

function modifier_imba_phoenix_sun_ray_caster_dummy:GetModifierIgnoreCastAngle()
	if not self:GetCaster():HasTalent("special_bonus_imba_phoenix_8") then
		return 360
	else
		return nil
	end
end

function modifier_imba_phoenix_sun_ray_caster_dummy:GetEffectName()
	return "particles/units/heroes/hero_phoenix/phoenix_sunray_mane.vpcf"
end

function modifier_imba_phoenix_sun_ray_caster_dummy:OnCreated()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
	StartSoundEvent("Hero_Phoenix.SunRay.Loop", caster)
	local particleName = "particles/units/heroes/hero_phoenix/phoenix_sunray_flare.vpcf"
	self.pfx_sunray_flare = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( self.pfx_sunray_flare, 9, caster, PATTACH_POINT_FOLLOW, "attach_mouth", caster:GetAbsOrigin(), true )

	-- Swap sub ability
	local main_ability_name	= "imba_phoenix_sun_ray"
	local sub_ability_name	= "imba_phoenix_sun_ray_stop"
	caster:SwapAbilities( main_ability_name, sub_ability_name, false, true )
	caster.sun_ray_is_moving = false
	local toggle_move = caster:FindAbilityByName("imba_phoenix_sun_ray_toggle_move")
	if toggle_move and not self:GetCaster():HasTalent("special_bonus_imba_phoenix_8") then
		toggle_move:SetActivated(true)
	end
	self:StartIntervalThink(ability:GetSpecialValueFor("tick_interval"))
end

function modifier_imba_phoenix_sun_ray_caster_dummy:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	caster:AddNewModifier(caster, ability, "modifier_imba_phoenix_sun_ray_dummy_unit_thinker", { duration = ability:GetSpecialValueFor("tick_interval") * 1.9 })
end

function modifier_imba_phoenix_sun_ray_caster_dummy:OnDestroy()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if caster:HasTalent("special_bonus_imba_phoenix_4") then
		local endcapPos = caster:GetAbsOrigin() + caster:GetForwardVector() * ability:GetSpecialValueFor("beam_range")
		local units = FindUnitsInLine(caster:GetTeamNumber(),
			caster:GetAbsOrigin() + caster:GetForwardVector() * 32 ,
			endcapPos,
			nil,
			ability:GetSpecialValueFor("radius"),
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE)
		for _,unit in pairs(units) do
			unit:Purge(false, true, false, true, true)
		end
	end
	caster:RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
	StartSoundEvent("Hero_Phoenix.SunRay.Stop", caster)
	StopSoundEvent( "Hero_Phoenix.SunRay.Loop", caster)
	if self.pfx_sunray_flare then
		ParticleManager:DestroyParticle(self.pfx_sunray_flare, false)
		ParticleManager:ReleaseParticleIndex(self.pfx_sunray_flare)
	end
	-- Swap sub ability
	caster.sun_ray_is_moving = false
	local toggle_move = caster:FindAbilityByName("imba_phoenix_sun_ray_toggle_move")
	if toggle_move then
		toggle_move:SetActivated(false)
	end
	local main_ability_name	= "imba_phoenix_sun_ray_stop"
	local sub_ability_name	= "imba_phoenix_sun_ray"
	caster:SwapAbilities( main_ability_name, sub_ability_name, false, true )
	caster:SetContextThink( DoUniqueString("waitToFindClearSpace"), function ( )

			if not caster:HasModifier("modifier_naga_siren_song_of_the_siren") then
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin() , false)
				return nil
			end

			return 0.1
	end, 0 )
end

modifier_imba_phoenix_sun_ray_dummy_unit_thinker = modifier_imba_phoenix_sun_ray_dummy_unit_thinker or class({})

function modifier_imba_phoenix_sun_ray_dummy_unit_thinker:IsDebuff()				return false end
function modifier_imba_phoenix_sun_ray_dummy_unit_thinker:IsHidden() 				return true end
function modifier_imba_phoenix_sun_ray_dummy_unit_thinker:IsPurgable() 				return false end
function modifier_imba_phoenix_sun_ray_dummy_unit_thinker:IsPurgeException() 		return false end
function modifier_imba_phoenix_sun_ray_dummy_unit_thinker:IsStunDebuff() 			return false end
function modifier_imba_phoenix_sun_ray_dummy_unit_thinker:RemoveOnDeath() 			return true end

function modifier_imba_phoenix_sun_ray_dummy_unit_thinker:OnCreated()
	if not IsServer() then
		return
	end
	self:SetStackCount(1)
end

function modifier_imba_phoenix_sun_ray_dummy_unit_thinker:OnRefresh()
	if not IsServer() then
		return
	end
	self:IncrementStackCount()
end

modifier_imba_phoenix_sun_ray_dummy_buff = modifier_imba_phoenix_sun_ray_dummy_buff or class({})

function modifier_imba_phoenix_sun_ray_dummy_buff:IsDebuff()				return false end
function modifier_imba_phoenix_sun_ray_dummy_buff:IsHidden() 				return true end
function modifier_imba_phoenix_sun_ray_dummy_buff:IsPurgable() 				return false end
function modifier_imba_phoenix_sun_ray_dummy_buff:IsPurgeException() 		return false end
function modifier_imba_phoenix_sun_ray_dummy_buff:IsStunDebuff() 			return false end
function modifier_imba_phoenix_sun_ray_dummy_buff:RemoveOnDeath() 			return true end

function modifier_imba_phoenix_sun_ray_dummy_buff:OnCreated()
	if not IsServer() then
		return
	end

	local ability = self:GetAbility()
	self:StartIntervalThink( ability:GetSpecialValueFor("tick_interval") )
end

function modifier_imba_phoenix_sun_ray_dummy_buff:OnIntervalThink()
	if not IsServer() then
		return
	end

	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local target = self:GetParent()
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		target:AddNewModifier(caster, ability, "modifier_imba_phoenix_sun_ray_debuff", { duration = ability:GetSpecialValueFor("tick_interval") * 1.9 } )
	else
		target:AddNewModifier(caster, ability, "modifier_imba_phoenix_sun_ray_buff", { duration = ability:GetSpecialValueFor("tick_interval") * 1.9 } )
	end
end

modifier_imba_phoenix_sun_ray_debuff = modifier_imba_phoenix_sun_ray_debuff or class({})

function modifier_imba_phoenix_sun_ray_debuff:IsDebuff()				return false end
function modifier_imba_phoenix_sun_ray_debuff:IsHidden() 				return true end
function modifier_imba_phoenix_sun_ray_debuff:IsPurgable() 				return false end
function modifier_imba_phoenix_sun_ray_debuff:IsPurgeException() 		return false end
function modifier_imba_phoenix_sun_ray_debuff:IsStunDebuff() 			return false end
function modifier_imba_phoenix_sun_ray_debuff:RemoveOnDeath() 			return true end
function modifier_imba_phoenix_sun_ray_debuff:IgnoreTenacity() 			return true end

function modifier_imba_phoenix_sun_ray_debuff:GetEffectName() return "particles/units/heroes/hero_phoenix/phoenix_sunray_debuff.vpcf" end

function modifier_imba_phoenix_sun_ray_debuff:OnCreated()
	if not IsServer() then
		return
	end
	if self:GetStackCount() < 1 then
		self:SetStackCount(1)
	end
	local ability = self:GetAbility()
	self:StartIntervalThink( ability:GetSpecialValueFor("tick_interval") )
end

function modifier_imba_phoenix_sun_ray_debuff:OnRefresh()
	if not IsServer() then
		return
	end
	self:IncrementStackCount()
end

function modifier_imba_phoenix_sun_ray_debuff:OnIntervalThink()
	if not IsServer() then
		return
	end

	local ability = self:GetAbility()
	local caster = self:GetCaster()

	if not caster:HasModifier("modifier_imba_phoenix_sun_ray_dummy_unit_thinker") then
		return
	end

	local num_stack = caster:FindModifierByName("modifier_imba_phoenix_sun_ray_dummy_unit_thinker"):GetStackCount()
	local taker = self:GetParent()
	local tick_sum = ability:GetSpecialValueFor("duration") / ability:GetSpecialValueFor("tick_interval")

	local base_dmg = ability:GetSpecialValueFor("base_damage")
	base_dmg = base_dmg / tick_sum * num_stack

	local pct_base_dmg = ability:GetSpecialValueFor("hp_perc_damage") / 100
	pct_base_dmg = pct_base_dmg / tick_sum * num_stack
	local taker_health = taker:GetMaxHealth()

	local total_damage = base_dmg + taker_health * pct_base_dmg

	local damageTable = {
		victim = taker,
		attacker = self:GetCaster(),
		damage = total_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
	}
	ApplyDamage(damageTable)

	local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_sunray_debuff.vpcf", PATTACH_ABSORIGIN, taker )
	ParticleManager:SetParticleControlEnt( pfx, 1, taker, PATTACH_POINT_FOLLOW, "attach_hitloc", taker:GetAbsOrigin(), true )
	ParticleManager:DestroyParticle( pfx, false )
	ParticleManager:ReleaseParticleIndex( pfx )

	-- IMBA: effected by Sun Ray's enemy's other phoenix debuff duration won't decrease
	local dive_debuff = taker:FindModifierByNameAndCaster("modifier_imba_phoenix_icarus_dive_slow_debuff", caster)
	local bird_debuff = taker:FindModifierByNameAndCaster("modifier_imba_phoenix_fire_spirits_debuff", caster)
	if dive_debuff then
		dive_debuff:SetDuration(dive_debuff:GetDuration(), true)
	end
	if bird_debuff then
		bird_debuff:SetDuration(bird_debuff:GetDuration(), true)
	end

end


modifier_imba_phoenix_sun_ray_buff = modifier_imba_phoenix_sun_ray_buff or class({})

function modifier_imba_phoenix_sun_ray_buff:IsDebuff()				return false end
function modifier_imba_phoenix_sun_ray_buff:IsHidden() 				return true end
function modifier_imba_phoenix_sun_ray_buff:IsPurgable() 				return false end
function modifier_imba_phoenix_sun_ray_buff:IsPurgeException() 		return false end
function modifier_imba_phoenix_sun_ray_buff:IsStunDebuff() 			return false end
function modifier_imba_phoenix_sun_ray_buff:RemoveOnDeath() 			return true end
function modifier_imba_phoenix_sun_ray_buff:IgnoreTenacity() 			return true end

function modifier_imba_phoenix_sun_ray_buff:GetEffectName() return "particles/units/heroes/hero_phoenix/phoenix_sunray_beam_friend.vpcf" end

function modifier_imba_phoenix_sun_ray_buff:OnCreated()
	if not IsServer() then
		return
	end
	if self:GetStackCount() < 1 then
		self:SetStackCount(1)
	end
	local ability = self:GetAbility()
	self:StartIntervalThink( ability:GetSpecialValueFor("tick_interval") )
end

function modifier_imba_phoenix_sun_ray_buff:OnRefresh()
	if not IsServer() then
		return
	end
	self:IncrementStackCount()
end

function modifier_imba_phoenix_sun_ray_buff:OnIntervalThink()
	if not IsServer() then
		return
	end

	local caster = self:GetCaster()
	local ability = self:GetAbility()

	if not caster:HasModifier("modifier_imba_phoenix_sun_ray_dummy_unit_thinker") then
		return
	end

	local num_stack = caster:FindModifierByName("modifier_imba_phoenix_sun_ray_dummy_unit_thinker"):GetStackCount()
	local taker = self:GetParent()
	local tick_sum = ability:GetSpecialValueFor("duration") / ability:GetSpecialValueFor("tick_interval")

	local base_heal = ability:GetSpecialValueFor("base_heal")
	base_heal = base_heal / tick_sum * num_stack

	local pct_base_heal = ability:GetSpecialValueFor("hp_perc_heal") / 100
	pct_base_heal = pct_base_heal / tick_sum * num_stack
	local taker_health = taker:GetMaxHealth()

	local total_heal = base_heal + taker_health * pct_base_heal
	total_heal = total_heal * (1 + (caster:GetSpellAmplification(false) * 0.01))
	if taker ~= self:GetCaster() then
		taker:Heal( total_heal , self:GetCaster())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, taker, total_heal, nil)

		local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_sunray_beam_friend.vpcf", PATTACH_ABSORIGIN, taker )
		ParticleManager:SetParticleControlEnt( pfx, 1, taker, PATTACH_POINT_FOLLOW, "attach_hitloc", taker:GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex( pfx )

		local explode_stack = ability:GetSpecialValueFor("explode_min_time") / ability:GetSpecialValueFor("tick_interval")
		local current_stack = self:GetStackCount()
		if current_stack > explode_stack and taker:IsRealHero() then
			local pfx_explode = ParticleManager:CreateParticle("particles/hero/phoenix/phoenix_sun_ray_explode.vpcf", PATTACH_POINT_FOLLOW, taker)
			ParticleManager:SetParticleControlEnt(pfx_explode, 0, taker,PATTACH_POINT_FOLLOW, "attach_hitloc", taker:GetAbsOrigin(), true)
			--ParticleManager:DestroyParticle(pfx_explode, false)
			ParticleManager:ReleaseParticleIndex(pfx_explode)
			local damage_this_tick = ability:GetSpecialValueFor("explode_dmg") / ( 1 / ability:GetSpecialValueFor("tick_interval") )
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
				taker:GetAbsOrigin(),
				nil,
				ability:GetSpecialValueFor("explode_radius"),
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false)
			for _, enemy in pairs(enemies) do
				local damageTable = {
					victim = enemy,
					attacker = caster,
					damage = damage_this_tick,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self:GetAbility(),
				}
				ApplyDamage(damageTable)
			end
		end
	else
		local heal_cost_pct = ability:GetSpecialValueFor("hp_cost_perc_per_second") / 100
		local tick_per_sec = 1 / ability:GetSpecialValueFor("tick_interval")
		local heal_cost_per_tick = heal_cost_pct / tick_per_sec
		local heal_cost_this_time = caster:GetHealth() * heal_cost_per_tick
		if caster:HasModifier("modifier_imba_phoenix_burning_wings_buff") then
			caster:Heal(heal_cost_this_time, caster)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, heal_cost_this_time, nil)
		else
			if (caster:GetHealth() - heal_cost_this_time) <= 1 then
				caster:SetHealth(1)
			else
				caster:SetHealth( caster:GetHealth() - heal_cost_this_time )
			end
		end
	end
end

-------------------------------------------
--			  Sun Ray Stop
-------------------------------------------

imba_phoenix_sun_ray_stop = imba_phoenix_sun_ray_stop or class({})

function imba_phoenix_sun_ray_stop:IsHiddenWhenStolen() 	return true end
function imba_phoenix_sun_ray_stop:IsRefreshable() 			return true end
function imba_phoenix_sun_ray_stop:IsStealable() 			return false end
function imba_phoenix_sun_ray_stop:IsNetherWardStealable() 	return false end
function imba_phoenix_sun_ray_stop:GetAssociatedPrimaryAbilities() return "imba_phoenix_sun_ray" end

function imba_phoenix_sun_ray_stop:GetAbilityTextureName()   return "phoenix_sun_ray_stop" end

function imba_phoenix_sun_ray_stop:OnSpellStart()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_imba_phoenix_sun_ray_caster_dummy")

end


-------------------------------------------
--			  Sun Ray Move
-------------------------------------------

imba_phoenix_sun_ray_toggle_move = imba_phoenix_sun_ray_toggle_move or class({})

function imba_phoenix_sun_ray_toggle_move:IsHiddenWhenStolen() 		return false end
function imba_phoenix_sun_ray_toggle_move:IsRefreshable() 			return true end
function imba_phoenix_sun_ray_toggle_move:IsStealable() 			return false end
function imba_phoenix_sun_ray_toggle_move:IsNetherWardStealable() 	return false end
function imba_phoenix_sun_ray_toggle_move:GetAssociatedPrimaryAbilities() return "imba_phoenix_sun_ray" end

function imba_phoenix_sun_ray_toggle_move:GetAbilityTextureName()   return "phoenix_sun_ray_toggle_move" end

function imba_phoenix_sun_ray_toggle_move:OnSpellStart()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	if caster.sun_ray_is_moving then
		caster.sun_ray_is_moving = false
	else
		caster.sun_ray_is_moving = true
	end
end



-------------------------------------------
--			  Super Nova
-------------------------------------------

LinkLuaModifier("modifier_imba_phoenix_supernova_egg_thinker", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phoenix_supernova_caster_dummy", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phoenix_supernova_bird_thinker", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phoenix_supernova_dmg", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phoenix_supernova_scepter_passive", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phoenix_supernova_scepter_passive_cooldown", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phoenix_supernova_egg_double", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kill_no_timer", "modifier/modifier_kill_no_timer", LUA_MODIFIER_MOTION_NONE)

imba_phoenix_supernova = imba_phoenix_supernova or class({})

function imba_phoenix_supernova:IsHiddenWhenStolen() 	return false end
function imba_phoenix_supernova:IsRefreshable() 			return true end
function imba_phoenix_supernova:IsStealable() 			return true end
function imba_phoenix_supernova:IsNetherWardStealable() 	return false end

function imba_phoenix_supernova:OnAbilityPhaseStart()
	if not IsServer() then
		return
	end
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_5)
	return true
end

function imba_phoenix_supernova:GetCastRange() 	return self:GetSpecialValueFor("cast_range") end

function imba_phoenix_supernova:GetAbilityTextureName()   return "phoenix_supernova" end

function imba_phoenix_supernova:GetIntrinsicModifierName()
	return "modifier_imba_phoenix_supernova_scepter_passive"
end

function imba_phoenix_supernova:OnSpellStart()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self
	local location = caster:GetAbsOrigin()
	local ground_location = GetGroundPosition(location, caster)
	local egg_duration = self:GetSpecialValueFor("duration")

	local max_attack = self:GetSpecialValueFor("max_hero_attacks")

	caster:AddNewModifier(caster, ability, "modifier_imba_phoenix_supernova_caster_dummy", {duration = egg_duration })
	caster:AddNoDraw()

	local egg = CreateUnitByName("npc_dota_phoenix_sun", ground_location, false, caster, caster:GetOwner(), caster:GetTeamNumber())
	egg:AddNewModifier(caster, ability, "modifier_kill", {duration = egg_duration })
	egg:AddNewModifier(caster, ability, "modifier_imba_phoenix_supernova_egg_thinker", {duration = egg_duration + 0.3 })

	egg.max_attack = max_attack
	egg.current_attack = 0

	local egg_playback_rate = 6 / egg_duration
	egg:StartGestureWithPlaybackRate(ACT_DOTA_IDLE , egg_playback_rate)

	caster.egg = egg
	caster.HasDoubleEgg = false

	caster.ally = self:GetCursorTarget()
	if caster.ally == caster then
		caster.ally = nil
	else
		local ally = caster.ally
		if not caster:HasTalent("special_bonus_imba_phoenix_6") then
			ally:AddNewModifier(caster, ability, "modifier_imba_phoenix_supernova_caster_dummy", {duration = egg_duration})
			ally:AddNoDraw()
			ally:SetAbsOrigin(caster:GetAbsOrigin())
		else
			-- Talent: Double Super Nova
			ally:AddNewModifier(ally, ability, "modifier_imba_phoenix_supernova_caster_dummy", {duration = egg_duration})
			ally:AddNoDraw()
			local _direction = (ally:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
			caster:SetForwardVector(_direction)
			local loaction = caster:GetForwardVector() * 192 + caster:GetAbsOrigin()
			local egg2 = CreateUnitByName("npc_dota_phoenix_sun", loaction, false, ally, ally:GetOwner(), ally:GetTeamNumber())

			egg2:AddNewModifier(ally, ability, "modifier_kill", {duration = egg_duration })
			egg2:AddNewModifier(caster, ability, "modifier_imba_phoenix_supernova_egg_double", { } )
			egg2:AddNewModifier(ally, ability, "modifier_imba_phoenix_supernova_egg_thinker", {duration = egg_duration + 0.3 })

			max_attack = max_attack * ( (100 - caster:FindTalentValue("special_bonus_imba_phoenix_6","attack_reduce_pct") ) / 100)

			egg.max_attack = max_attack
			egg.current_attack = 0

			egg2.max_attack = max_attack
			egg2.current_attack = 0

			local info =
				{
					Target = egg2,
					Source = ally,
					Ability = ability,
					EffectName = "particles/hero/phoenix/phoenix_super_nova_double_egg_projectile.vpcf",
					iMoveSpeed = 1400,
					bDrawsOnMinimap = false,						  -- Optional
					bDodgeable = false,								-- Optional
					bIsAttack = false,								-- Optional
					bVisibleToEnemies = true,						 -- Optional
					bReplaceExisting = false,						 -- Optional
					flExpireTime = GameRules:GetGameTime() + 10,	  -- Optional but recommended
					bProvidesVision = false,						   -- Optional
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
				}
			ProjectileManager:CreateTrackingProjectile(info)

			caster.HasDoubleEgg = true
			ally:SetAbsOrigin(egg2:GetAbsOrigin())
			local egg_playback_rate = 6 / egg_duration
			egg2:StartGestureWithPlaybackRate(ACT_DOTA_IDLE , egg_playback_rate)
		end
	end


end

modifier_imba_phoenix_supernova_caster_dummy = modifier_imba_phoenix_supernova_caster_dummy or class({})

function modifier_imba_phoenix_supernova_caster_dummy:IsDebuff()				return false end
function modifier_imba_phoenix_supernova_caster_dummy:IsHidden() 				return false end
function modifier_imba_phoenix_supernova_caster_dummy:IsPurgable() 				return false end
function modifier_imba_phoenix_supernova_caster_dummy:IsPurgeException() 		return false end
function modifier_imba_phoenix_supernova_caster_dummy:IsStunDebuff() 			return false end
function modifier_imba_phoenix_supernova_caster_dummy:RemoveOnDeath() 			return true end
function modifier_imba_phoenix_supernova_caster_dummy:IgnoreTenacity() 			return true end

function modifier_imba_phoenix_supernova_caster_dummy:GetTexture() return "phoenix_supernova" end

function modifier_imba_phoenix_supernova_caster_dummy:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
			MODIFIER_EVENT_ON_DEATH,
		}
	return decFuns
end

function modifier_imba_phoenix_supernova_caster_dummy:CheckState()
	local state =
		{
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_MUTED] = true,
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
		}
	return state
end

function modifier_imba_phoenix_supernova_caster_dummy:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_imba_phoenix_supernova_caster_dummy:OnCreated()
	if not IsServer() then
		return
	end
	if self:GetAbility():IsStolen() then
		return
	end
	local caster = self:GetCaster()
	local abi = caster:FindAbilityByName("imba_phoenix_launch_fire_spirit")
	if abi then
		if self:GetParent() == self:GetCaster() and abi:IsTrained() then
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_phoenix_supernova_bird_thinker", {duration = self:GetDuration()})
		end
	end
	local innate = caster:FindAbilityByName("imba_phoenix_burning_wings")
	if innate then
		if innate:GetToggleState() then
			innate:ToggleAbility()
		end
	end
end

function modifier_imba_phoenix_supernova_caster_dummy:OnDeath( keys )
	if not IsServer() then
		return
	end
	if keys.unit == self:GetParent() then
		if keys.unit ~= self:GetCaster() then
			local caster = self:GetCaster()
			caster.ally = nil
		end
		local eggs = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),
			nil,
			2500,
			DOTA_UNIT_TARGET_TEAM_BOTH,
			DOTA_UNIT_TARGET_ALL,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false )
		for _, egg in pairs(eggs) do
			if egg:GetUnitName() == "npc_dota_phoenix_sun" and egg:GetTeamNumber() == self:GetParent():GetTeamNumber() and egg:GetOwner() == self:GetParent():GetOwner() then
				egg:Kill(self:GetAbility(), keys.attacker)
			end
		end
	end
end

function modifier_imba_phoenix_supernova_caster_dummy:OnDestroy()
	if not IsServer() then
		return
	end
	if self:GetCaster():GetUnitName() == "npc_imba_hero_phoenix" or self:GetCaster():GetUnitName() == "npc_dota_hero_phoenix" then
		self:GetCaster():StartGesture(ACT_DOTA_INTRO)
	end
end

modifier_imba_phoenix_supernova_bird_thinker = modifier_imba_phoenix_supernova_bird_thinker or class({})

function modifier_imba_phoenix_supernova_bird_thinker:IsDebuff()			return false end
function modifier_imba_phoenix_supernova_bird_thinker:IsHidden() 			return false end
function modifier_imba_phoenix_supernova_bird_thinker:IsPurgable() 			return false end
function modifier_imba_phoenix_supernova_bird_thinker:IsPurgeException() 	return false end
function modifier_imba_phoenix_supernova_bird_thinker:IsStunDebuff() 		return false end
function modifier_imba_phoenix_supernova_bird_thinker:RemoveOnDeath() 		return true  end

function modifier_imba_phoenix_supernova_bird_thinker:GetTexture()
	return "phoenix_fire_spirits"
end

function modifier_imba_phoenix_supernova_bird_thinker:OnCreated()
	if not IsServer() then
		return
	end

	self:StartIntervalThink(0.5)

	local numSpirits = self:GetAbility():GetSpecialValueFor("bird_num")
	-- Set the stack count
	self:SetStackCount(numSpirits)

end

function modifier_imba_phoenix_supernova_bird_thinker:OnIntervalThink()
	if not IsServer() then
		return
	end

	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local egg = caster.egg
	if not egg then
		return
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		egg:GetAbsOrigin(),
		nil,
		ability:GetSpecialValueFor("aura_radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false )
	local distance = ability:GetSpecialValueFor("aura_radius") + 1
	local target
	local target_num = 0
	for _, enemy in pairs(enemies) do
		target_num = target_num + 1
		if enemy:GetAttackTarget() == egg then
			target = enemy
			break
		end
		target = enemy
	end

	if target_num == 0 then
		return
	end

	local attach_point = egg:ScriptLookupAttachment( "attach_hitloc" )
	local info =
		{
			Target = target,
			Source = caster,
			Ability = caster:FindAbilityByName("imba_phoenix_launch_fire_spirit"),
			EffectName = "particles/hero/phoenix/phoenix_fire_spirit_launch.vpcf",
			iMoveSpeed = caster:FindAbilityByName("imba_phoenix_launch_fire_spirit"):GetSpecialValueFor("spirit_speed"),
			vSourceLoc= egg:GetAttachmentOrigin(attach_point),				-- Optional (HOW)
			bDrawsOnMinimap = false,						  -- Optional
			bDodgeable = true,								-- Optional
			bIsAttack = false,								-- Optional
			bVisibleToEnemies = true,						 -- Optional
			bReplaceExisting = false,						 -- Optional
			flExpireTime = GameRules:GetGameTime() + 10,	  -- Optional but recommended
			bProvidesVision = false,						   -- Optional
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
		}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
	EmitSoundOn("Hero_Phoenix.FireSpirits.Launch", caster)

	self:DecrementStackCount()
	if self:GetStackCount() < 1 then
		self:Destroy()
		return
	end

end

function modifier_imba_phoenix_supernova_bird_thinker:OnProjectileHit( hTarget, vLocation)
	if not IsServer() then
		return
	end

	local caster = self:GetCaster()
	local location = vLocation
	if hTarget then
		location = hTarget:GetAbsOrigin()
	end
	-- Particles and sound
	local DummyUnit = CreateUnitByName("npc_dummy_unit",location,false,caster,caster:GetOwner(),caster:GetTeamNumber())
	DummyUnit:AddNewModifier(caster, ability, "modifier_kill", {duration = 0.1})
	local pfx_explosion = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_explosion, 0, location)
	ParticleManager:ReleaseParticleIndex(pfx_explosion)

	EmitSoundOn("Hero_Phoenix.ProjectileImpact", DummyUnit)
	EmitSoundOn("Hero_Phoenix.FireSpirits.Target", DummyUnit)

	-- Vision
	AddFOWViewer(caster:GetTeamNumber(), DummyUnit:GetAbsOrigin(), 175, 1, true)

	local units = FindUnitsInRadius(caster:GetTeamNumber(),
		location,
		nil,
		caster:FindAbilityByName("imba_phoenix_launch_fire_spirit"):GetSpecialValueFor("radius"),
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	for _,unit in pairs(units) do
		if unit ~= caster then
			if unit:GetTeamNumber() ~= caster:GetTeamNumber() then
				unit:AddNewModifier(caster, caster:FindAbilityByName("imba_phoenix_launch_fire_spirit"), "modifier_imba_phoenix_fire_spirits_debuff", {duration = caster:FindAbilityByName("imba_phoenix_launch_fire_spirit"):GetSpecialValueFor("duration")} )
			else
				unit:AddNewModifier(caster, caster:FindAbilityByName("imba_phoenix_launch_fire_spirit"), "modifier_imba_phoenix_fire_spirits_buff", {duration = caster:FindAbilityByName("imba_phoenix_launch_fire_spirit"):GetSpecialValueFor("duration")} )
			end
		end
	end
	return true
end

function modifier_imba_phoenix_supernova_bird_thinker:OnDestroy()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()

end


modifier_imba_phoenix_supernova_egg_double = modifier_imba_phoenix_supernova_egg_double or class({})

function modifier_imba_phoenix_supernova_egg_double:IsDebuff()					return false end
function modifier_imba_phoenix_supernova_egg_double:IsHidden() 				return false end
function modifier_imba_phoenix_supernova_egg_double:IsPurgable() 				return false end
function modifier_imba_phoenix_supernova_egg_double:IsPurgeException() 		return false end
function modifier_imba_phoenix_supernova_egg_double:IsStunDebuff() 			return false end
function modifier_imba_phoenix_supernova_egg_double:RemoveOnDeath() 			return true end

function modifier_imba_phoenix_supernova_egg_double:GetTexture() return "phoenix_supernova" end

function modifier_imba_phoenix_supernova_egg_double:OnCreated()
	if not IsServer() then
		return
	end
	local egg = self:GetParent()
	local ability = self:GetAbility()
	local pfx = ParticleManager:CreateParticle( "particles/hero/phoenix/phoenix_super_nova_double_egg.vpcf", PATTACH_POINT_FOLLOW, egg )
	ParticleManager:SetParticleControlEnt( pfx, 3, egg, PATTACH_POINT_FOLLOW, "attach_hitloc", egg:GetAbsOrigin(), true )
	Timers:CreateTimer({
		endTime = ability:GetSpecialValueFor("duration"),
		callback = function()
			ParticleManager:ReleaseParticleIndex( pfx )
		end
	})
end

modifier_imba_phoenix_supernova_egg_thinker = modifier_imba_phoenix_supernova_egg_thinker or class({})

function modifier_imba_phoenix_supernova_egg_thinker:IsDebuff()					return false end
function modifier_imba_phoenix_supernova_egg_thinker:IsHidden() 				return false end
function modifier_imba_phoenix_supernova_egg_thinker:IsPurgable() 				return false end
function modifier_imba_phoenix_supernova_egg_thinker:IsPurgeException() 		return false end
function modifier_imba_phoenix_supernova_egg_thinker:IsStunDebuff() 			return false end
function modifier_imba_phoenix_supernova_egg_thinker:RemoveOnDeath() 			return true end
function modifier_imba_phoenix_supernova_egg_thinker:IgnoreTenacity() 			return true end
function modifier_imba_phoenix_supernova_egg_thinker:IsAura() 					return true end
function modifier_imba_phoenix_supernova_egg_thinker:GetAuraSearchTeam() 		return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_phoenix_supernova_egg_thinker:GetAuraSearchType() 		return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_imba_phoenix_supernova_egg_thinker:GetAuraRadius() 			return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_imba_phoenix_supernova_egg_thinker:GetModifierAura()			return "modifier_imba_phoenix_supernova_dmg" end

function modifier_imba_phoenix_supernova_egg_thinker:GetTexture() return "phoenix_supernova" end

function modifier_imba_phoenix_supernova_egg_thinker:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
			MODIFIER_EVENT_ON_ATTACKED,
			MODIFIER_EVENT_ON_DEATH,
		}
	return decFuns
end

function modifier_imba_phoenix_supernova_egg_thinker:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_imba_phoenix_supernova_egg_thinker:OnCreated()
	if not IsServer() then
		return
	end
	local egg = self:GetParent()
	local caster = self:GetCaster()
	local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_supernova_egg.vpcf", PATTACH_ABSORIGIN_FOLLOW, egg )
	ParticleManager:SetParticleControlEnt( pfx, 1, egg, PATTACH_POINT_FOLLOW, "attach_hitloc", egg:GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex( pfx )
	StartSoundEvent( "Hero_Phoenix.SuperNova.Begin", egg)
	StartSoundEvent( "Hero_Phoenix.SuperNova.Cast", egg)

	local ability = self:GetAbility()
	GridNav:DestroyTreesAroundPoint(egg:GetAbsOrigin(), ability:GetSpecialValueFor("cast_range") * 1.5 , false)
	self:StartIntervalThink(1.0)
end

function modifier_imba_phoenix_supernova_egg_thinker:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local egg = self:GetParent()
	if not egg:IsAlive() or egg:HasModifier("modifier_imba_phoenix_supernova_egg_double") then
		return
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		egg:GetAbsOrigin(),
		nil,
		ability:GetSpecialValueFor("aura_radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false )
	for _, enemy in pairs(enemies) do
		local damageTable = {
			victim = enemy,
			attacker = caster,
			damage = ability:GetSpecialValueFor("damage_per_sec"),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability,
		}
		ApplyDamage(damageTable)
	end
end

function modifier_imba_phoenix_supernova_egg_thinker:OnDeath( keys )
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local egg = self:GetParent()
	local killer = keys.attacker
	if egg ~= keys.unit then
		return
	end
	if egg.IsDoubleNova then
		egg.IsDoubleNova = nil
	end
	if egg.NovaCaster then
		egg.NovaCaster = nil
	end
	print(killer:GetUnitName())

	caster:RemoveNoDraw()
	if caster.ally and not caster.HasDoubleEgg then
		caster.ally:RemoveNoDraw()
	end
	egg:AddNoDraw()

	StopSoundEvent("Hero_Phoenix.SuperNova.Begin", egg)
	StopSoundEvent( "Hero_Phoenix.SuperNova.Cast", egg)
	if egg == killer then
		-- Phoenix reborns
		StartSoundEvent( "Hero_Phoenix.SuperNova.Explode", egg)
		local pfxName = "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf"
		local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl( pfx, 0, egg:GetAbsOrigin() )
		ParticleManager:SetParticleControl( pfx, 1, Vector(1.5,1.5,1.5) )
		ParticleManager:SetParticleControl( pfx, 3, egg:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(pfx)
		self:ResetUnit(caster)
		caster:SetHealth( caster:GetMaxHealth() )
		caster:SetMana( caster:GetMaxMana() )
		if caster.ally and not caster.HasDoubleEgg and caster.ally:IsAlive() then
			self:ResetUnit(caster.ally)
			caster.ally:SetHealth( caster.ally:GetMaxHealth() )
			caster.ally:SetMana( caster.ally:GetMaxMana() )
		end
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			egg:GetAbsOrigin(),
			nil,
			ability:GetSpecialValueFor("aura_radius"),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER,
			false )
		for _, enemy in pairs(enemies) do
			local item = CreateItem( "item_imba_dummy", caster, caster)
			item:ApplyDataDrivenModifier( caster, enemy, "modifier_stunned", {duration = ability:GetSpecialValueFor("stun_duration")} )
			UTIL_Remove(item)
		end
	else
		-- Phoenix killed
		StartSoundEventFromPosition( "Hero_Phoenix.SuperNova.Death", egg:GetAbsOrigin())
		if not caster:HasTalent("special_bonus_imba_phoenix_5") then
			if caster:IsAlive() then  caster:Kill(ability, killer) end
			if caster.ally and not caster.HasDoubleEgg and caster.ally:IsAlive() then
				caster.ally:Kill(ability, killer)
			end
		elseif caster:IsAlive() then
			self:ResetUnit(caster)
			caster:SetHealth( caster:GetMaxHealth() * caster:FindTalentValue("special_bonus_imba_phoenix_5","reborn_pct") / 100 )
			caster:SetMana( caster:GetMaxMana() * caster:FindTalentValue("special_bonus_imba_phoenix_5","reborn_pct") / 100)
			local egg_buff = caster:FindModifierByNameAndCaster("modifier_imba_phoenix_supernova_caster_dummy", caster)
			if egg_buff then
				egg_buff:Destroy()
			end
			if caster.ally and caster.ally:IsAlive() then
				self:ResetUnit(caster.ally)
				caster.ally:SetHealth( caster.ally:GetMaxHealth() * caster:FindTalentValue("special_bonus_imba_phoenix_5","reborn_pct") / 100 )
				caster.ally:SetMana( caster.ally:GetMaxMana() * caster:FindTalentValue("special_bonus_imba_phoenix_5","reborn_pct") / 100 )
				local egg_buff2 = caster.ally:FindModifierByNameAndCaster("modifier_imba_phoenix_supernova_caster_dummy", caster)
				if egg_buff2 then
					egg_buff2:Destroy()
				end
			end
		end
		local pfxName = "particles/units/heroes/hero_phoenix/phoenix_supernova_death.vpcf"
		local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_WORLDORIGIN, nil )
		local attach_point = caster:ScriptLookupAttachment( "attach_hitloc" )
		ParticleManager:SetParticleControl( pfx, 0, caster:GetAttachmentOrigin(attach_point) )
		ParticleManager:SetParticleControl( pfx, 1, caster:GetAttachmentOrigin(attach_point) )
		ParticleManager:SetParticleControl( pfx, 3, caster:GetAttachmentOrigin(attach_point) )
		ParticleManager:ReleaseParticleIndex(pfx)
	end
	caster.ally = nil
	caster.egg = nil
	FindClearSpaceForUnit(caster, egg:GetAbsOrigin(), false)
	if caster.ally then
		FindClearSpaceForUnit(caster.ally, egg:GetAbsOrigin(), false)
	end
	self.bIsFirstAttacked = nil
end

function modifier_imba_phoenix_supernova_egg_thinker:ResetUnit( unit )
	for i=0,10 do
		local abi = unit:GetAbilityByIndex(i)
		if abi then
			if abi:GetAbilityType() ~= 1 and not abi:IsItem() then
				abi:EndCooldown()
			end
		end
	end
	unit:Purge( true, true, true, true, true )
end

function modifier_imba_phoenix_supernova_egg_thinker:OnAttacked( keys )
	if not IsServer() then
		return
	end

	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local egg = self:GetParent()
	local attacker = keys.attacker

	if keys.target ~= egg then
		return
	end

	local max_attack = egg.max_attack
	local current_attack = egg.current_attack

	if attacker:IsRealHero() then
		egg.current_attack = egg.current_attack + 1
	else
		egg.current_attack = egg.current_attack + 0.25
	end
	if egg.current_attack >= egg.max_attack then
		egg:Kill(ability, attacker)
	else
		egg:SetHealth( (egg:GetMaxHealth() * ((egg.max_attack-egg.current_attack)/egg.max_attack)) )
	end
	local pfxName = "particles/units/heroes/hero_phoenix/phoenix_supernova_hit.vpcf"
	local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_POINT_FOLLOW, egg )
	local attach_point = egg:ScriptLookupAttachment( "attach_hitloc" )
	ParticleManager:SetParticleControlEnt( pfx, 0, egg, PATTACH_POINT_FOLLOW, "attach_hitloc", egg:GetAttachmentOrigin(attach_point), true )
	ParticleManager:SetParticleControlEnt( pfx, 1, egg, PATTACH_POINT_FOLLOW, "attach_hitloc", egg:GetAttachmentOrigin(attach_point), true )
	--ParticleManager:ReleaseParticleIndex(pfx)
end

modifier_imba_phoenix_supernova_dmg = modifier_imba_phoenix_supernova_dmg or class({})

function modifier_imba_phoenix_supernova_dmg:IsHidden() return false end
function modifier_imba_phoenix_supernova_dmg:IsDebuff() return true end
function modifier_imba_phoenix_supernova_dmg:IsPurgable() return false end

function modifier_imba_phoenix_supernova_dmg:DeclareFunctions()
	local decFuns = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
	}
	return decFuns
end

function modifier_imba_phoenix_supernova_dmg:GetHeroEffectName() return "particles/units/heroes/hero_phoenix/phoenix_supernova_radiance.vpcf" end

function modifier_imba_phoenix_supernova_dmg:GetEffectAttachType() return PATTACH_WORLDORIGIN end

function modifier_imba_phoenix_supernova_dmg:OnCreated()
	if not IsServer() then
		return
	end
	local target = self:GetParent()
	local caster = self:GetCaster()
	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_radiance_streak_light.vpcf", PATTACH_POINT_FOLLOW, target)
	-- The fucking particle I can't do
	ParticleManager:SetParticleControlEnt( self.pfx, 8, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )

end

function modifier_imba_phoenix_supernova_dmg:GetModifierMiss_Percentage()
	if not IsServer() then
		return
	end
	local enemy = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	-- Get the miss pct
	local egg = caster.egg
	if egg then
		local miss_pct = ability:GetSpecialValueFor("miss_pct_base") + ability:GetSpecialValueFor("miss_pct_perHit") * egg.current_attack
		local miss_radius = self:GetAbility():GetSpecialValueFor("cast_range")
		local miss_angle = self:GetAbility():GetSpecialValueFor("miss_angle")
		local caster_location = caster:GetAbsOrigin()
		local enemy_location = enemy:GetAbsOrigin()
		local distance = CalcDistanceBetweenEntityOBB(caster, enemy)
		if distance <= miss_radius then
			local enemy_to_caster_direction = (caster_location - enemy_location):Normalized()
			local enemy_forward_vector =  enemy:GetForwardVector()
			local view_angle = math.abs(RotationDelta(VectorToAngles(enemy_to_caster_direction), VectorToAngles(enemy_forward_vector)).y)
			if view_angle <= ( miss_angle / 2 ) and enemy:CanEntityBeSeenByMyTeam(caster) then
				return miss_pct
			else
				return 0
			end
		else
			return 0
		end
	else
		return 0
	end
end

function modifier_imba_phoenix_supernova_dmg:OnDestroy()
	if not IsServer() then
		return
	end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
end

modifier_imba_phoenix_supernova_scepter_passive = modifier_imba_phoenix_supernova_scepter_passive or class({})

function modifier_imba_phoenix_supernova_scepter_passive:IsDebuff()					return false end
function modifier_imba_phoenix_supernova_scepter_passive:IsHidden()
	if self:GetCaster():HasScepter() and not self:GetCaster():HasModifier("modifier_imba_phoenix_supernova_scepter_passive_cooldown") then
		return false
	else
		return true
	end
end
function modifier_imba_phoenix_supernova_scepter_passive:IsPurgable() 				return false end
function modifier_imba_phoenix_supernova_scepter_passive:IsPurgeException() 		return false end
function modifier_imba_phoenix_supernova_scepter_passive:IsStunDebuff() 			return false end
function modifier_imba_phoenix_supernova_scepter_passive:RemoveOnDeath()
	if self:GetCaster():IsRealHero() then
		return false
	else
		return true
	end
end
function modifier_imba_phoenix_supernova_scepter_passive:IsPermanent() 				return true end
function modifier_imba_phoenix_supernova_scepter_passive:AllowIllusionDuplicate() 	return true end

function modifier_imba_phoenix_supernova_scepter_passive:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TAKEDAMAGE}

	return decFuncs
end

function modifier_imba_phoenix_supernova_scepter_passive:GetMinHealth()
	if self:GetCaster():PassivesDisabled() or self:GetCaster():HasModifier("modifier_imba_phoenix_supernova_caster_dummy") or self:GetCaster():HasModifier("modifier_imba_phoenix_supernova_scepter_passive_cooldown") or not self:GetCaster():IsRealHero() then
		return nil
	end
	if not self:GetCaster():HasScepter() then
		return nil
	else
		return 1
	end
end

function modifier_imba_phoenix_supernova_scepter_passive:OnTakeDamage( keys )
	if not  IsServer() then
		return
	end
	if keys.unit ~= self:GetCaster() then
		return
	end
	if not self:GetCaster():HasScepter() then
		return
	end
	if self:GetCaster():FindModifierByName("modifier_imba_phoenix_supernova_caster_dummy") or self:GetCaster():HasModifier("modifier_imba_phoenix_supernova_scepter_passive_cooldown") then
		return
	end
	if self:GetCaster():PassivesDisabled() or not self:GetCaster():IsRealHero() then
		return
	end

	if self:GetCaster():GetHealth() <= 1 then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		caster:AddNewModifier(caster, ability, "modifier_imba_phoenix_supernova_scepter_passive_cooldown", { duration = ability:GetSpecialValueFor("scepter_cooldown")})
		local location = caster:GetAbsOrigin()
		local egg_duration = ability:GetSpecialValueFor("duration")
		local extend_duration = ability:GetSpecialValueFor("scepter_additional_duration")

		local max_attack = ability:GetSpecialValueFor("max_hero_attacks")

		caster:AddNewModifier(caster, ability, "modifier_imba_phoenix_supernova_caster_dummy", {duration = egg_duration + extend_duration })
		caster:AddNoDraw()

		local egg = CreateUnitByName("npc_dota_phoenix_sun",location,false,caster,caster:GetOwner(),caster:GetTeamNumber())
		egg:AddNewModifier(caster, ability, "modifier_kill", {duration = egg_duration + extend_duration })
		egg:AddNewModifier(caster, ability, "modifier_imba_phoenix_supernova_egg_thinker", {duration = egg_duration + extend_duration + 0.3})

		egg.max_attack = max_attack
		egg.current_attack = 0

		local egg_playback_rate = 6 / (egg_duration + extend_duration)
		egg:StartGestureWithPlaybackRate(ACT_DOTA_IDLE , egg_playback_rate)

		caster.egg = egg

	end

end


modifier_imba_phoenix_supernova_scepter_passive_cooldown = modifier_imba_phoenix_supernova_scepter_passive_cooldown or class({})

function modifier_imba_phoenix_supernova_scepter_passive_cooldown:IsDebuff()				return true end
function modifier_imba_phoenix_supernova_scepter_passive_cooldown:IsHidden() 				return false end
function modifier_imba_phoenix_supernova_scepter_passive_cooldown:IsPurgable() 				return false end
function modifier_imba_phoenix_supernova_scepter_passive_cooldown:IsPurgeException() 		return false end
function modifier_imba_phoenix_supernova_scepter_passive_cooldown:IsStunDebuff() 			return false end
function modifier_imba_phoenix_supernova_scepter_passive_cooldown:RemoveOnDeath() 			return false end
function modifier_imba_phoenix_supernova_scepter_passive_cooldown:IsPermanent() 			return false end
function modifier_imba_phoenix_supernova_scepter_passive_cooldown:AllowIllusionDuplicate() 	return false end

-------------------------------------------
--			Burning Wings
-------------------------------------------

LinkLuaModifier("modifier_imba_phoenix_burning_wings_buff", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phoenix_burning_wings_ally_buff", "components/abilities/heroes/hero_phoenix", LUA_MODIFIER_MOTION_NONE)

imba_phoenix_burning_wings = imba_phoenix_burning_wings or class({})

function imba_phoenix_burning_wings:IsHiddenWhenStolen() 		return false end
function imba_phoenix_burning_wings:IsRefreshable() 			return true end
function imba_phoenix_burning_wings:IsStealable() 				return false end
function imba_phoenix_burning_wings:IsNetherWardStealable() 	return false end
function imba_phoenix_burning_wings:IsInnateAbility()			return true end

function imba_phoenix_burning_wings:GetAbilityTextureName()   	return "custom/phoenix_burningwings" end

function imba_phoenix_burning_wings:OnToggle()
	if not IsServer() then
		return
	end
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_phoenix_burning_wings_buff", {} )
	else
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_imba_phoenix_burning_wings_buff", self:GetCaster())
		if self:GetCaster():HasScepter() then
			self:StartCooldown(self:GetSpecialValueFor("scepter_off_cooldown"))
		else
			self:StartCooldown(self:GetSpecialValueFor("off_cooldown"))
		end
	end
end

modifier_imba_phoenix_burning_wings_buff = modifier_imba_phoenix_burning_wings_buff or class({})

function modifier_imba_phoenix_burning_wings_buff:IsDebuff()				return false end
function modifier_imba_phoenix_burning_wings_buff:IsHidden() 				return false end
function modifier_imba_phoenix_burning_wings_buff:IsPurgable() 				return false end
function modifier_imba_phoenix_burning_wings_buff:IsPurgeException() 		return false end
function modifier_imba_phoenix_burning_wings_buff:IsStunDebuff() 			return false end
function modifier_imba_phoenix_burning_wings_buff:RemoveOnDeath() 			return false end
function modifier_imba_phoenix_burning_wings_buff:IsPermanent() 			return false end
function modifier_imba_phoenix_burning_wings_buff:AllowIllusionDuplicate() 	return false end

function modifier_imba_phoenix_burning_wings_buff:DeclareFunctions()		return {MODIFIER_EVENT_ON_TAKEDAMAGE} end

function modifier_imba_phoenix_burning_wings_buff:GetEffectName()			return "particles/hero/phoenix/phoenix_burning_wings.vpcf" end

function modifier_imba_phoenix_burning_wings_buff:GetTexture()				return "custom/phoenix_burningwings" end

function modifier_imba_phoenix_burning_wings_buff:OnCreated()
	if not IsServer() then
		return
	end
	local bird = self:GetCaster()
	local ability = self:GetAbility()
	local hpCost = ability:GetSpecialValueFor("cast_hp_cost") / 100
	local healthCost = bird:GetMaxHealth() * hpCost
	local AfterCastHealth = bird:GetHealth() - healthCost
	if AfterCastHealth <= 1 then
		bird:SetHealth(1)
	else
		bird:SetHealth(AfterCastHealth)
	end
	local particleName = "particles/hero/phoenix/phoenix_burning_wings_2.vpcf"
	self.pfx = { }
	for i = 1, 5 do
		self.pfx[i] = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, bird)
		ParticleManager:SetParticleControlEnt(self.pfx[i], 0, bird,PATTACH_POINT_FOLLOW, "attach_attack1", bird:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx[i], 1, bird,PATTACH_POINT_FOLLOW, "attach_attack2", bird:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx[i], 4, bird,PATTACH_POINT_FOLLOW, "attach_neck", bird:GetAbsOrigin(), true)
	end
	self:StartIntervalThink(ability:GetSpecialValueFor("tick_rate"))
end

function modifier_imba_phoenix_burning_wings_buff:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local hpCost = (ability:GetSpecialValueFor("hp_cost_per_sec") / 100 ) * ability:GetSpecialValueFor("tick_rate")
	local healthCost = caster:GetMaxHealth() * hpCost
	local AfterCastHealth = caster:GetHealth() - healthCost
	if AfterCastHealth <= 1 then
		caster:SetHealth(1)
	else
		caster:SetHealth(AfterCastHealth)
	end
end

function modifier_imba_phoenix_burning_wings_buff:OnTakeDamage( keys )
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	if keys.attacker ~= caster then
		return
	end
	local ability1 = caster:FindAbilityByName("imba_phoenix_icarus_dive")
	local ability2 = caster:FindAbilityByName("imba_phoenix_icarus_dive_stop")
	local ability3 = caster:FindAbilityByName("imba_phoenix_fire_spirits")
	local ability4 = caster:FindAbilityByName("imba_phoenix_launch_fire_spirit")
	local ability5 = caster:FindAbilityByName("imba_phoenix_sun_ray")
	local abi_table = {ability1,ability2,ability3,ability4,ability5}
	for _, abi in pairs(abi_table) do
		if keys.inflictor == abi then
			local damage = keys.damage
			caster:Heal(damage, caster)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, damage, nil)
		end
	end
end

function modifier_imba_phoenix_burning_wings_buff:OnDestroy()
	if not IsServer() then
		return
	end
	for i = 1, 5 do
		ParticleManager:DestroyParticle(self.pfx[i], false)
		ParticleManager:ReleaseParticleIndex(self.pfx[i])
		self.pfx[i] = nil
	end
end


modifier_imba_phoenix_burning_wings_ally_buff = modifier_imba_phoenix_burning_wings_ally_buff or class({})

function modifier_imba_phoenix_burning_wings_ally_buff:IsDebuff()				return false end
function modifier_imba_phoenix_burning_wings_ally_buff:IsHidden() 				return true end
function modifier_imba_phoenix_burning_wings_ally_buff:IsPurgable() 			return false end
function modifier_imba_phoenix_burning_wings_ally_buff:IsPurgeException() 		return false end
function modifier_imba_phoenix_burning_wings_ally_buff:IsStunDebuff() 			return false end
function modifier_imba_phoenix_burning_wings_ally_buff:RemoveOnDeath() 			return false end

function modifier_imba_phoenix_burning_wings_ally_buff:OnDestroy()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("imba_phoenix_burning_wings")
	local buff = caster:FindModifierByName("modifier_imba_phoenix_burning_wings_buff")
	if not buff or not ability or caster == self:GetParent() then
		return
	end
	local num_heal = ability:GetSpecialValueFor("hit_ally_heal") + ability:GetSpecialValueFor("hit_ally_heal") * ( caster:GetSpellAmplification(false) / 100 )
	caster:Heal(num_heal, caster)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, num_heal, nil)
end
