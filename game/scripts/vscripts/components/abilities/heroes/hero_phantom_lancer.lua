-- Editors:
--     Shush, 13.09.2017
--     AltiV, 23.12.2019

LinkLuaModifier("modifier_imba_phantom_lancer_spirit_lance_handler", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantom_lancer_spirit_lance", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantom_lancer_spirit_lance_phantom_pain", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantom_lancer_illusion", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_phantom_lancer_doppelwalk_phase", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_phantom_lancer_phantom_edge", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantom_lancer_phantom_edge_boost", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantom_lancer_phantom_edge_agility", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_phantom_lancer_sun_catcher_thinker", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantom_lancer_sun_catcher_aura", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_phantom_lancer_juxtapose", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantom_lancer_juxtapose_assault", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)

imba_phantom_lancer_spirit_lance			= imba_phantom_lancer_spirit_lance or class({})
modifier_imba_phantom_lancer_spirit_lance_handler	= modifier_imba_phantom_lancer_spirit_lance_handler or class({})
modifier_imba_phantom_lancer_spirit_lance	= modifier_imba_phantom_lancer_spirit_lance or class({})
modifier_imba_phantom_lancer_spirit_lance_phantom_pain	= modifier_imba_phantom_lancer_spirit_lance_phantom_pain or class({})
modifier_imba_phantom_lancer_illusion		= modifier_imba_phantom_lancer_illusion or class({})

imba_phantom_lancer_doppelwalk					= imba_phantom_lancer_doppelwalk or class({})
modifier_imba_phantom_lancer_doppelwalk_phase	= modifier_imba_phantom_lancer_doppelwalk_phase or class({})

imba_phantom_lancer_phantom_edge					= imba_phantom_lancer_phantom_edge or class({})
modifier_imba_phantom_lancer_phantom_edge			= modifier_imba_phantom_lancer_phantom_edge or class({})
modifier_imba_phantom_lancer_phantom_edge_boost		= modifier_imba_phantom_lancer_phantom_edge_boost or class({})
modifier_imba_phantom_lancer_phantom_edge_agility	= modifier_imba_phantom_lancer_phantom_edge_agility or class({})

imba_phantom_lancer_sun_catcher					= imba_phantom_lancer_sun_catcher or class({})
modifier_imba_phantom_lancer_sun_catcher_thinker	= modifier_imba_phantom_lancer_sun_catcher_thinker or class({})
modifier_imba_phantom_lancer_sun_catcher_aura	= modifier_imba_phantom_lancer_sun_catcher_aura or class({})

imba_phantom_lancer_juxtapose					= imba_phantom_lancer_juxtapose or class({})
modifier_imba_phantom_lancer_juxtapose			= modifier_imba_phantom_lancer_juxtapose or class({})
modifier_imba_phantom_lancer_juxtapose_assault	= modifier_imba_phantom_lancer_juxtapose_assault or class({})

--------------------------------------
--			SPIRIT LANCE            --
--------------------------------------

-- IMBAfication: Illusory Heart
function imba_phantom_lancer_spirit_lance:GetIntrinsicModifierName()
	return "modifier_imba_phantom_lancer_spirit_lance_handler"
end

function imba_phantom_lancer_spirit_lance:CastFilterResultTarget(target)
	if self:GetCaster():GetModifierStackCount("modifier_imba_phantom_lancer_spirit_lance_handler", self:GetCaster()) == 0 then
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	elseif target ~= self:GetCaster() then
	-- IMBAfication: Illusory Heart
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	else
		return UF_FAIL_CUSTOM
	end
end

function imba_phantom_lancer_spirit_lance:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	end
end

function imba_phantom_lancer_spirit_lance:GetCastRange(location, target)
	if not target or (target and not target:HasModifier("modifier_imba_phantom_lancer_sun_catcher_aura")) then
		return self.BaseClass.GetCastRange(self, location, target)
	else
		return 0
	end
end

function imba_phantom_lancer_spirit_lance:OnAbilityPhaseStart()
	-- Cycle between found units, only include illusions
	for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("fake_lance_distance"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)) do
		if unit:GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID() and unit ~= self:GetCaster() then
			-- Fake casting animation
			unit:StartGesture(ACT_DOTA_CAST_ABILITY_1)

			-- Illusions that are moving/attacking are ignored. Idle illusions fake their Spirit Lance
			if unit:IsIdle() then
				unit:FaceTowards(self:GetCursorTarget():GetAbsOrigin())
			end
		end
	end

	return true
end

function imba_phantom_lancer_spirit_lance:OnSpellStart()
	local target = self:GetCursorTarget()

	-- Play cast sound
	self:GetCaster():EmitSound("Hero_PhantomLancer.SpiritLance.Throw")

	if self:GetCaster():GetName() == "npc_dota_hero_phantom_lancer" then
		if not self.responses then
			self.responses = 
			{
				"phantom_lancer_plance_ability_spiritlance_01",
				"phantom_lancer_plance_ability_spiritlance_03",
				"phantom_lancer_plance_ability_spiritlance_05",
				"phantom_lancer_plance_ability_spiritlance_06",
				"phantom_lancer_plance_ability_spiritlance_08"
			}
		end
		
		self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
	end
	
	local lance_speed = self:GetSpecialValueFor("lance_speed")
	
	-- Sun Catcher speed boost
	if target:HasModifier("modifier_imba_phantom_lancer_sun_catcher_aura") then
		lance_speed = self:GetSpecialValueFor("sun_catcher_lance_speed")
	end

	ProjectileManager:CreateTrackingProjectile({
		Target = target,
		Source = self:GetCaster(),
		Ability = self,
		EffectName = "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_projectile.vpcf",
		iMoveSpeed = lance_speed,
		bDodgeable = true,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = false,
	})
	
	-- Nearby illusions also cast their own projectiles. Those are fake, of course
	-- Find all nearby illusions
	-- Cycle between found units, only include illusions
	for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetAbsOrigin(),
		nil,
		self:GetSpecialValueFor("fake_lance_distance"),
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
		FIND_ANY_ORDER,
		false)) do
		if unit:GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID() and unit ~= self:GetCaster() and unit:IsIllusion() then
			ProjectileManager:CreateTrackingProjectile({
				Target = target,
				Source = unit,
				Ability = unit:FindAbilityByName("imba_phantom_lancer_spirit_lance"),
				EffectName = "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_projectile.vpcf",
				iMoveSpeed = lance_speed * ((unit:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() / (self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Length2D()),
				bDodgeable = true,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				bProvidesVision = false,
			})
		end
	end
end

function imba_phantom_lancer_spirit_lance:OnProjectileHit_ExtraData(target, location, extradata)
	-- If there was no target (disjointed), do nothing
	if not target or (target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and target:IsMagicImmune()) then
		return nil
	end

	if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		if not self:GetCaster():IsIllusion() then
			-- Play hit sound
			EmitSoundOn("Hero_PhantomLancer.SpiritLance.Impact", target)

			-- If target has Linken's sphere ready, do nothing
			if self:GetCaster():GetTeamNumber() ~= target:GetTeamNumber() then
				if target:TriggerSpellAbsorb(self) then
					return nil
				end
			end
		
			-- "The lance first applies the debuff, then the damage."
			-- Slow target
			target:AddNewModifier(self:GetCaster(), self, "modifier_imba_phantom_lancer_spirit_lance", {duration = self:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance())})
			
			-- Deal damage to target
			ApplyDamage({
				victim 			= target,
				damage 			= self:GetTalentSpecialValueFor("lance_damage"),
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self
			})

			-- "The illusion spawns 58 range away from the target, at random spot around it."
			-- "Illusions created by Spirit Lance have a static 5 gold and experience bounty which does not scale with levels."
			local illusions = CreateIllusions(self:GetCaster(), self:GetCaster(), 
			{
				outgoing_damage = self:GetSpecialValueFor("illusion_damage_out_pct"),
				incoming_damage	= self:GetSpecialValueFor("illusion_damage_in_pct"),
				bounty_base		= 5,
				bounty_growth	= nil,
				outgoing_damage_structure	= nil,
				outgoing_damage_roshan		= nil,
				duration		= self:GetSpecialValueFor("illusion_duration")
			}
			, 1, self:GetCaster():GetHullRadius(), false, true)


			for _, illusion in pairs(illusions) do
				self.spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantom_lancer_spawn_illusion.vpcf", PATTACH_ABSORIGIN_FOLLOW, illusion)
				ParticleManager:SetParticleControlEnt(self.spawn_particle, 0, illusion, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(self.spawn_particle, 1, illusion, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(self.spawn_particle)
			
				-- illusion:AddNewModifier(self:GetCaster(), self, "modifier_imba_phantom_lancer_illusion", {})
				illusion:AddNewModifier(self:GetCaster(), self, "modifier_phantom_lancer_juxtapose_illusion", {})
				FindClearSpaceForUnit(illusion, target:GetAbsOrigin() + RandomVector(58), true)
			end

			-- -- Create illusion
			-- local illusion = IllusionManager:CreateIllusion(caster, ability, target:GetAbsOrigin(), caster, {damagein = illusion_in_damage, damageout = illusion_out_damage, duration = illusion_duration, callback = attack_callback_func}, target)
		elseif self:GetCaster():IsAlive() then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_phantom_lancer_spirit_lance_phantom_pain", {})
			-- IMBAfication: Phantom Pain
			self:GetCaster():PerformAttack(target, false, true, true, false, false, false, true)
			self:GetCaster():RemoveModifierByName("modifier_imba_phantom_lancer_spirit_lance_phantom_pain")
		end
	else
		-- IMBAfication: Illusory Heart
		if not self:GetCaster():IsIllusion() then
			local illusion_type = target
		
			if not target:IsHero() then
				illusion_type = self:GetCaster()
			end
			
			-- "The illusion spawns 58 range away from the target, at random spot around it."
			-- "Illusions created by Spirit Lance have a static 5 gold and experience bounty which does not scale with levels."
			local illusions = CreateIllusions(self:GetCaster(), illusion_type, 
			{
				outgoing_damage = self:GetSpecialValueFor("illusion_damage_out_pct"),
				incoming_damage	= self:GetSpecialValueFor("illusion_damage_in_pct"),
				bounty_base		= 5,
				bounty_growth	= nil,
				outgoing_damage_structure	= nil,
				outgoing_damage_roshan		= nil,
				duration		= self:GetSpecialValueFor("illusion_duration") + self:GetSpecialValueFor("illusory_heart_bonus_duration")
			}
			, 1, self:GetCaster():GetHullRadius(), false, true)


			for _, illusion in pairs(illusions) do
				self.spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantom_lancer_spawn_illusion.vpcf", PATTACH_ABSORIGIN_FOLLOW, illusion)
				ParticleManager:SetParticleControlEnt(self.spawn_particle, 0, illusion, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(self.spawn_particle, 1, illusion, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(self.spawn_particle)
			
				-- illusion:AddNewModifier(self:GetCaster(), self, "modifier_imba_phantom_lancer_illusion", {})
				illusion:AddNewModifier(self:GetCaster(), self, "modifier_phantom_lancer_juxtapose_illusion", {})
				FindClearSpaceForUnit(illusion, target:GetAbsOrigin() + RandomVector(58), true)
			end
		end
	end
end

-------------------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_SPIRIT_LANCE_HANDLER --
-------------------------------------------------------

function modifier_imba_phantom_lancer_spirit_lance_handler:IsHidden()		return true end
function modifier_imba_phantom_lancer_spirit_lance_handler:IsPurgable()		return false end
function modifier_imba_phantom_lancer_spirit_lance_handler:RemoveOnDeath()	return false end
function modifier_imba_phantom_lancer_spirit_lance_handler:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_phantom_lancer_spirit_lance_handler:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ORDER}
end

function modifier_imba_phantom_lancer_spirit_lance_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end
	
	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

-----------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_SPIRIT_LANCE --
-----------------------------------------------

function modifier_imba_phantom_lancer_spirit_lance:GetEffectName()
	return "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_target.vpcf"
end

function modifier_imba_phantom_lancer_spirit_lance:GetStatusEffectName()
	return "particles/status_fx/status_effect_phantoml_slowlance.vpcf"
end

function modifier_imba_phantom_lancer_spirit_lance:OnCreated()
	-- Ability specials
	self.movement_speed_pct = self:GetAbility():GetSpecialValueFor("movement_speed_pct")
end

function modifier_imba_phantom_lancer_spirit_lance:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_imba_phantom_lancer_spirit_lance:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_speed_pct
end

------------------------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_SPIRIT_LANCE_PHANTOM_PAIN --
------------------------------------------------------------

function modifier_imba_phantom_lancer_spirit_lance_phantom_pain:IsHidden()		return true end
function modifier_imba_phantom_lancer_spirit_lance_phantom_pain:IsPurgable()	return false end

function modifier_imba_phantom_lancer_spirit_lance_phantom_pain:OnCreated()
	self.phantom_pain_damage_pct	= self:GetAbility():GetSpecialValueFor("phantom_pain_damage_pct") * (-1)
end

function modifier_imba_phantom_lancer_spirit_lance_phantom_pain:DeclareFunctions()
	return {MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE}
end

function modifier_imba_phantom_lancer_spirit_lance_phantom_pain:GetModifierDamageOutgoing_Percentage()
	return self.phantom_pain_damage_pct
end

------------------------------------
-- IMBA_PHANTOM_LANCER_DOPPELWALK --
------------------------------------

function imba_phantom_lancer_doppelwalk:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_phantom_lancer_doppelwalk_cooldown")
end

function imba_phantom_lancer_doppelwalk:GetAOERadius()
	return self:GetSpecialValueFor("target_aoe")
end

-- Doppelganger disjoints projectiles upon cast.
-- Applies a basic dispel on Phantom Lancer upon cast.
function imba_phantom_lancer_doppelwalk:OnSpellStart()
	self:GetCaster():EmitSound("Hero_PhantomLancer.Doppelganger.Cast")

	local doppleganger_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantom_lancer_doppleganger_aoe.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(doppleganger_particle, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(doppleganger_particle, 2, Vector(self:GetSpecialValueFor("target_aoe"), self:GetSpecialValueFor("target_aoe"), self:GetSpecialValueFor("target_aoe")))
	ParticleManager:SetParticleControl(doppleganger_particle, 3, Vector(self:GetSpecialValueFor("delay"), 0, 0))
	ParticleManager:ReleaseParticleIndex(doppleganger_particle)

	if self:GetCaster():GetName() == "npc_dota_hero_phantom_lancer" then
		if RollPercentage(5) then
			if not self.rare_responses then
				self.rare_responses = 
				{
					"phantom_lancer_plance_ability_dopplewalk_01",
					"phantom_lancer_plance_ability_dopplewalk_06"
				}
			end
			
			self:GetCaster():EmitSound(self.rare_responses[RandomInt(1, #self.rare_responses)])
		else	
			if not self.responses then
				self.responses = 
				{
					"phantom_lancer_plance_ability_dopplewalk_02",
					"phantom_lancer_plance_ability_dopplewalk_04",
					"phantom_lancer_plance_ability_dopplewalk_05",
					"phantom_lancer_plance_ability_juxtapose_02"
				}
			end
			
			self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
		end
	end

	self.first_unit = nil
	self.new_pos	= nil
	
	local affected_units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("search_radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)
	
	if not self.illusion_1 or self.illusion_1:IsNull() or not self.illusion_1:IsAlive() then
		self.illusion_1 = CreateIllusions(self:GetCaster(), self:GetCaster(), 
		{
			outgoing_damage = self:GetSpecialValueFor("illusion_1_damage_out_pct"),
			incoming_damage	= self:GetSpecialValueFor("illusion_1_damage_in_pct"),
			bounty_base		= 5,
			bounty_growth	= nil,
			outgoing_damage_structure	= nil,
			outgoing_damage_roshan		= nil,
			duration		= self:GetSpecialValueFor("illusion_duration") + self:GetSpecialValueFor("delay")
		}
		, 1, self:GetCaster():GetHullRadius(), false, true)[1]
		
		self.illusion_1:AddNewModifier(self:GetCaster(), self, "modifier_phantom_lancer_doppelwalk_illusion", {})
		self.illusion_1:AddNewModifier(self:GetCaster(), self, "modifier_phantom_lancer_juxtapose_illusion", {}) -- This should be the brighter one, but I don't know how to get that to work
	else
		self.illusion_1:SetHealth(self:GetCaster():GetHealth())
		self.illusion_1:FindModifierByName("modifier_illusion"):SetDuration(self:GetSpecialValueFor("illusion_duration") + self:GetSpecialValueFor("delay"), true)
	end
	
	table.insert(affected_units, self.illusion_1)
	
	if not self.illusion_2 or self.illusion_2:IsNull() or not self.illusion_2:IsAlive() then
		self.illusion_2 = CreateIllusions(self:GetCaster(), self:GetCaster(), 
		{
			outgoing_damage = self:GetSpecialValueFor("illusion_2_damage_out_pct"),
			incoming_damage	= self:GetSpecialValueFor("illusion_2_damage_in_pct"),
			bounty_base		= 5,
			bounty_growth	= nil,
			outgoing_damage_structure	= nil,
			outgoing_damage_roshan		= nil,
			duration		= self:GetSpecialValueFor("illusion_duration") + self:GetSpecialValueFor("delay")
		}
		, 1, self:GetCaster():GetHullRadius(), false, true)[1]
		
		self.illusion_2:AddNewModifier(self:GetCaster(), self, "modifier_phantom_lancer_doppelwalk_illusion", {})
		self.illusion_2:AddNewModifier(self:GetCaster(), self, "modifier_phantom_lancer_juxtapose_illusion", {})
	else
		self.illusion_2:SetHealth(self:GetCaster():GetHealth())
		self.illusion_2:FindModifierByName("modifier_illusion"):SetDuration(self:GetSpecialValueFor("illusion_duration") + self:GetSpecialValueFor("delay"), true)
	end
	
	table.insert(affected_units, self.illusion_2)
	
	-- IMBAfication: Crowdsourcing
	if self.illusion_3 and not self.illusion_3:IsNull() and self.illusion_3:IsAlive() then
		self.illusion_3:ForceKill(false)
	end

	for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("search_radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_CLOSEST, false)) do
		if unit:GetName() ~= self:GetCaster():GetName() and (unit:IsRealHero() or unit:IsClone() or unit:IsTempestDouble() or unit:IsIllusion()) then
			self.illusion_3 = CreateIllusions(self:GetCaster(), unit, 
			{
				outgoing_damage = -100,
				incoming_damage	= 0,
				bounty_base		= 5,
				bounty_growth	= nil,
				outgoing_damage_structure	= nil,
				outgoing_damage_roshan		= nil,
				duration		= self:GetSpecialValueFor("illusion_duration") + self:GetSpecialValueFor("delay")
			}
			, 1, self:GetCaster():GetHullRadius(), false, true)[1]
			
			if self.illusion_3 then
				self.illusion_3:AddNewModifier(self:GetCaster(), self, "modifier_phantom_lancer_doppelwalk_illusion", {})
				self.illusion_3:AddNewModifier(self:GetCaster(), self, "modifier_phantom_lancer_juxtapose_illusion", {})
			end
			
			break
		end
	end
	
	table.insert(affected_units, self.illusion_3)
	
	for _, unit in pairs(affected_units) do
		if unit:GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID() and (unit == self:GetCaster() or unit:IsIllusion()) then
			unit:Purge(false, true, false, false, false)
	
			ProjectileManager:ProjectileDodge(unit)
			
			if not self.first_unit then
				self.first_unit = unit:entindex()
				self.new_pos	= self:GetCursorPosition()
			else
				-- "Phantom Lancer and his illusions reappear in a formation shaped like a plus, with a bit of variaton."
				if RollPercentage(50) then
					self.new_pos	= self:GetCursorPosition() + Vector(RandomInt(-self:GetSpecialValueFor("target_aoe"), self:GetSpecialValueFor("target_aoe")), 0, 0)
				else
					self.new_pos	= self:GetCursorPosition() + Vector(0, RandomInt(-self:GetSpecialValueFor("target_aoe"), self:GetSpecialValueFor("target_aoe")), 0)
				end
			end
			
			unit:AddNewModifier(self:GetCaster(), self, "modifier_imba_phantom_lancer_doppelwalk_phase", {
				duration	= self:GetSpecialValueFor("delay"),
				pos_x		= self:GetCursorPosition().x,
				pos_y		= self:GetCursorPosition().y,
				pos_z		= self:GetCursorPosition().z,
				
				new_pos_x	= self.new_pos.x,
				new_pos_y	= self.new_pos.y,
				new_pos_z	= self.new_pos.z
			})
		end
	end
end

---------------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_DOPPELWALK_PHASE --
---------------------------------------------------

function modifier_imba_phantom_lancer_doppelwalk_phase:IsHidden()	return true end
function modifier_imba_phantom_lancer_doppelwalk_phase:IsPurgable()	return false end

function modifier_imba_phantom_lancer_doppelwalk_phase:OnCreated(keys)
	if not IsServer() then return end
	
	self.new_pos	= Vector(keys.new_pos_x, keys.new_pos_y, keys.new_pos_z)
	
	self:GetParent():AddNoDraw()
	
	local doppleganger_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantom_lancer_doppleganger_illlmove.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(doppleganger_particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(doppleganger_particle, 1, self.new_pos)
	self:AddParticle(doppleganger_particle, false, false, -1, false, false)
	
	if self:GetParent():IsIllusion() and self:GetParent():HasModifier("modifier_illusion") then
		self:GetParent():FindModifierByName("modifier_illusion"):SetDuration(self:GetParent():FindModifierByName("modifier_illusion"):GetRemainingTime() + self:GetAbility():GetSpecialValueFor("illusion_extended_duration"), true)
	end
end

function modifier_imba_phantom_lancer_doppelwalk_phase:OnDestroy()
	if not IsServer() then return end
	
	self:GetCaster():EmitSound("Hero_PhantomLancer.Doppelganger.Appear")
	
	self:GetParent():RemoveNoDraw()
	
	if self:GetParent():IsAlive() then
		FindClearSpaceForUnit(self:GetParent(), self.new_pos, true)
		
		-- "Destroys trees within 200 radius of Phantom Lancer and every affected illusion upon reappearing."
		GridNav:DestroyTreesAroundPoint(self.new_pos, 200, false)
	end

	self.spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantom_lancer_spawn_illusion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.spawn_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.spawn_particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(self.spawn_particle)
	
	PlayerResource:AddToSelection(self:GetCaster():GetPlayerID(), self:GetParent())
end

-- "Phantom Lancer and his affected illusions are invulnerable and hidden during the reappear delay."
-- "Phantom Lancer cannot do anything during the reappear delay. Any order given during it is queued as next order."
function modifier_imba_phantom_lancer_doppelwalk_phase:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE]	= true,
		[MODIFIER_STATE_OUT_OF_GAME]	= true,
		[MODIFIER_STATE_STUNNED]		= true
	}
end

--------------------------------------
-- IMBA_PHANTOM_LANCER_PHANTOM_EDGE --
--------------------------------------

function imba_phantom_lancer_phantom_edge:IsStealable() return false end

function imba_phantom_lancer_phantom_edge:GetIntrinsicModifierName()
	return "modifier_imba_phantom_lancer_phantom_edge"
end

-- function imba_phantom_lancer_phantom_edge:GetCooldown(level)
	-- if not self:GetCaster():HasScepter() then
		-- return self.BaseClass.GetCooldown(self, level)
	-- else
		-- return 0
	-- end
-- end

function imba_phantom_lancer_phantom_edge:OnToggle()
	if self:GetToggleState() then
		self:EndCooldown()
	end
	-- print(self:GetToggleState())
end

function imba_phantom_lancer_phantom_edge:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function imba_phantom_lancer_phantom_edge:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

-----------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_PHANTOM_EDGE --
-----------------------------------------------

function modifier_imba_phantom_lancer_phantom_edge:IsHidden()		return true end
function modifier_imba_phantom_lancer_phantom_edge:IsPurgable()		return false end
function modifier_imba_phantom_lancer_phantom_edge:RemoveOnDeath()	return false end

function modifier_imba_phantom_lancer_phantom_edge:OnCreated()
	if not IsServer() then return end

	self:StartIntervalThink(0.1)
end

function modifier_imba_phantom_lancer_phantom_edge:OnIntervalThink()
	if self.bRushChecking and self:GetParent():GetAggroTarget() == self.target and ((self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self:GetAbility():GetTalentSpecialValueFor("max_distance") or self.target:HasModifier("modifier_imba_phantom_lancer_sun_catcher_aura")) and ((self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() >= self:GetAbility():GetTalentSpecialValueFor("min_distance") or self:GetCaster():HasScepter()) then
		self:GetParent():EmitSound("Hero_PhantomLancer.PhantomEdge")
	
		self.rush_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_phantom_lancer_phantom_edge_boost", {duration = 5})
		
		if self.rush_modifier then
			self.rush_modifier:SetStackCount(-self.target:entindex())
		end
		
		self:GetAbility():UseResources(true, false, false, true)

		self.bRushChecking = false
	end
end

function modifier_imba_phantom_lancer_phantom_edge:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_ATTACK_RECORD
	}
end

function modifier_imba_phantom_lancer_phantom_edge:OnOrder(keys)
	if keys.unit == self:GetParent() and self:GetAbility() and not self:GetAbility():GetToggleState() and (self:GetAbility():IsCooldownReady() or self:GetCaster():HasScepter()) and not self:GetParent():PassivesDisabled() and keys.target then
		if keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
			if ((keys.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self:GetAbility():GetTalentSpecialValueFor("max_distance") or keys.target:HasModifier("modifier_imba_phantom_lancer_sun_catcher_aura")) and ((keys.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() >= self:GetAbility():GetTalentSpecialValueFor("min_distance") or self:GetCaster():HasScepter()) then
				self:GetParent():EmitSound("Hero_PhantomLancer.PhantomEdge")
				
				if self:GetAbility():IsCooldownReady() then
					self.rush_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_phantom_lancer_phantom_edge_boost", {duration = 5, bAgility = true})
					self:GetAbility():UseResources(true, false, false, true)
				else
					self.rush_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_phantom_lancer_phantom_edge_boost", {duration = 5, bAgility = false})
				end
				
				if self.rush_modifier then
					self.rush_modifier:SetStackCount(-keys.target:entindex())
				end
			else
				self.target			= keys.target
				self.bRushChecking  = true
			end
		else
			self.target			= nil
			self.bRushChecking	= false
		end
	end
end

function modifier_imba_phantom_lancer_phantom_edge:OnAttackRecord(keys)
	if keys.attacker == self:GetParent() and self:GetAbility() and not self:GetAbility():GetToggleState() and self:GetAbility():IsCooldownReady() and self:GetParent():HasScepter() and not keys.no_attack_cooldown and not self:GetParent():PassivesDisabled() then
		if not self:GetParent():HasModifier("modifier_imba_phantom_lancer_phantom_edge_boost") then
			self:GetParent():EmitSound("Hero_PhantomLancer.PhantomEdge")
		
			self.rush_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_phantom_lancer_phantom_edge_boost", {duration = 5, bAgility = true})
		
			if self.rush_modifier then
				self.rush_modifier:SetStackCount(-keys.target:entindex())
			end
		
			self:GetAbility():UseResources(true, false, false, true)
		end
	end
end

-----------------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_PHANTOM_EDGE_BOOST --
-----------------------------------------------------

function modifier_imba_phantom_lancer_phantom_edge_boost:GetEffectName()
	return "particles/units/heroes/hero_phantom_lancer/phantomlancer_edge_boost.vpcf"
end

function modifier_imba_phantom_lancer_phantom_edge_boost:OnCreated(keys)
	self.bonus_speed		= self:GetAbility():GetSpecialValueFor("bonus_speed")
	self.bonus_agility		= self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.agility_duration	= self:GetAbility():GetSpecialValueFor("agility_duration")
	self.mob_mentality_radius	= self:GetAbility():GetSpecialValueFor("mob_mentality_radius")
	self.mob_mentality_additional_agility	= self:GetAbility():GetSpecialValueFor("mob_mentality_additional_agility")
	self.sun_catcher_bonus_speed	= self:GetAbility():GetSpecialValueFor("sun_catcher_bonus_speed")
	
	self:StartIntervalThink(FrameTime())	
	
	if not IsServer() then return end
	
	self.bAgility	= keys.bAgility
	
	self.destroy_orders	=
	{
		[DOTA_UNIT_ORDER_MOVE_TO_POSITION]	= true,
		[DOTA_UNIT_ORDER_MOVE_TO_TARGET]	= true,
		[DOTA_UNIT_ORDER_ATTACK_MOVE]		= true,
		[DOTA_UNIT_ORDER_ATTACK_TARGET]		= true,
		
		[DOTA_UNIT_ORDER_STOP]				= true,
		[DOTA_UNIT_ORDER_CONTINUE]			= true,
		[DOTA_UNIT_ORDER_CAST_POSITION]		= true,
		[DOTA_UNIT_ORDER_CAST_TARGET]		= true,
		[DOTA_UNIT_ORDER_CAST_TARGET_TREE]	= true,
		[DOTA_UNIT_ORDER_CAST_TOGGLE]		= true,
		[DOTA_UNIT_ORDER_HOLD_POSITION]		= true,
		[DOTA_UNIT_ORDER_DROP_ITEM]			= true,
		[DOTA_UNIT_ORDER_GIVE_ITEM]			= true,
		[DOTA_UNIT_ORDER_PICKUP_ITEM]		= true,
		[DOTA_UNIT_ORDER_PICKUP_RUNE]		= true,
	}
end

-- Needs a frame to properly retrieve the stack count, which is set in the above intrinsic modifier for Sun Catcher checking
function modifier_imba_phantom_lancer_phantom_edge_boost:OnIntervalThink()
	self.target = EntIndexToHScript(-self:GetStackCount())
	self:StartIntervalThink(-1)
end

function modifier_imba_phantom_lancer_phantom_edge_boost:CheckState()
	return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
end

function modifier_imba_phantom_lancer_phantom_edge_boost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_STATE_CHANGED,
		
		MODIFIER_EVENT_ON_ATTACK_START
	}
end

function modifier_imba_phantom_lancer_phantom_edge_boost:GetModifierMoveSpeed_AbsoluteMin()
	if not self.target or not self.target.HasModifier or not self.target:HasModifier("modifier_imba_phantom_lancer_sun_catcher_aura") then
		return self.bonus_speed
	else
		return self.sun_catcher_bonus_speed
	end
end

-- "This buff lasts for up to 5 seconds, until Phantom Lancer successfully hits the rush target, or until he receives another order."
-- "Non-targeted items do not cancel the rush. Items which can be double-clicked to cast on self still count as targeted."
function modifier_imba_phantom_lancer_phantom_edge_boost:OnOrder(keys)
	if keys.unit == self:GetParent() and self.destroy_orders[keys.order_type] and not self.bFading then
		self:Destroy()
		
		-- self:SetDuration(0.5, true)
		-- self.bFading = true
	end
end

-- "The rush buff is also lost when Phantom Lancer gets stunned, cycloned, slept, hexed or hidden."
function modifier_imba_phantom_lancer_phantom_edge_boost:OnStateChanged(keys)
	if keys.unit == self:GetParent() and (self:GetParent():IsStunned() or self:GetParent():IsNightmared() or self:GetParent():IsHexed() or self:GetParent():IsOutOfGame()) then
		self:Destroy()
	end
end

function modifier_imba_phantom_lancer_phantom_edge_boost:OnAttackStart(keys)
	if keys.attacker == self:GetParent() and not keys.no_attack_cooldown and self.bAgility and self.bAgility == 1 then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_phantom_lancer_phantom_edge_agility", {
			duration		= self.agility_duration,
			bonus_agility	= self.bonus_agility,
			mob_mentality_radius	= self.mob_mentality_radius,
			mob_mentality_additional_agility	= self.mob_mentality_additional_agility
		})
		
		self:Destroy()
	end
end

-------------------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_PHANTOM_EDGE_AGILITY --
-------------------------------------------------------

function modifier_imba_phantom_lancer_phantom_edge_agility:OnCreated(keys)
	if self:GetAbility() then
		self.bonus_agility						= self:GetAbility():GetSpecialValueFor("bonus_agility")
		self.mob_mentality_radius				= self:GetAbility():GetSpecialValueFor("mob_mentality_radius")
		self.mob_mentality_additional_agility	= self:GetAbility():GetSpecialValueFor("mob_mentality_additional_agility")
	elseif keys and keys.bonus_agility then
		self.bonus_agility						= keys.bonus_agility
		self.mob_mentality_radius				= keys.mob_mentality_radius
		self.mob_mentality_additional_agility	= keys.mob_mentality_additional_agility
	else
		self.bonus_agility	= 11
		self.mob_mentality_radius				= 400
		self.mob_mentality_additional_agility	= 3
	end
	
	if not IsServer() then return end

	-- Cycle between found units, only include illusions
	for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.mob_mentality_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)) do
		if unit ~= self:GetParent() and unit:GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID() then
			self.bonus_agility = self.bonus_agility + self.mob_mentality_additional_agility
		end
	end
end

function modifier_imba_phantom_lancer_phantom_edge_agility:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS}
end

function modifier_imba_phantom_lancer_phantom_edge_agility:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

-------------------------------------
-- IMBA_PHANTOM_LANCER_SUN_CATCHER --
-------------------------------------

function imba_phantom_lancer_sun_catcher:IsInnateAbility()	return true end

function imba_phantom_lancer_sun_catcher:OnSpellStart()
	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

	local linear_particle = ParticleManager:CreateParticle("particles/hero/phantom_lancer/sun_catcher_projectile.vpcf", PATTACH_CUSTOMORIGIN, nil)
	-- CP0 is the starting point
	-- ParticleManager:SetParticleControlEnt(linear_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(linear_particle, 0, self:GetCaster():GetAbsOrigin() + Vector(0, 0, 700))
	-- CP1 is the velocity
	ParticleManager:SetParticleControl(linear_particle, 1, (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("speed") * Vector(1, 1, 0))
	-- CP14 is..random sizing
	ParticleManager:SetParticleControl(linear_particle, 14, Vector(1, self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius")))
	-- CP15 is primary colour
	ParticleManager:SetParticleControl(linear_particle, 15, Vector(255, 255, 128))
	-- CP15 is secondary colour
	ParticleManager:SetParticleControl(linear_particle, 16, Vector(255, 255, 0))
	
	local sun_thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_imba_phantom_lancer_sun_catcher_thinker", {
		duration	= self:GetSpecialValueFor("duration")
	}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
	
	sun_thinker:EmitSound("Hero_Phantom_Lancer.Sun_Catcher")
	
	ProjectileManager:CreateLinearProjectile({
		Ability				= self,
		-- EffectName			= "",
		vSpawnOrigin		= self:GetCaster():GetAbsOrigin(),
		fDistance			= self:GetSpecialValueFor("speed") * self:GetSpecialValueFor("duration"),
		fStartRadius		= self:GetSpecialValueFor("radius"),
		fEndRadius			= self:GetSpecialValueFor("radius"),
		Source				= self:GetCaster(),
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime 		= GameRules:GetGameTime() + self:GetSpecialValueFor("duration"),
		bDrawsOnMinimap		= true,
		bDeleteOnHit		= false,
		vVelocity			= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("speed") * Vector(1, 1, 0),
		bProvidesVision		= true,
		iVisionRadius 		= self:GetSpecialValueFor("radius"),
		iVisionTeamNumber 	= self:GetCaster():GetTeamNumber(),
		
		ExtraData			= {
			linear_particle 		= linear_particle,
			sun_thinker_entindex	= sun_thinker:entindex()
		}
	})
end

function imba_phantom_lancer_sun_catcher:OnProjectileThink_ExtraData(vLocation, ExtraData)
	if not IsServer() then return end
	
	EntIndexToHScript(ExtraData.sun_thinker_entindex):SetAbsOrigin(vLocation)
end

function imba_phantom_lancer_sun_catcher:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if not IsServer() then return end
	
	if not hTarget then
		ParticleManager:ReleaseParticleIndex(ExtraData.linear_particle)
	end
end

------------------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_SUN_CATCHER_THINKER --
------------------------------------------------------

function modifier_imba_phantom_lancer_sun_catcher_thinker:IsHidden()	return true end
function modifier_imba_phantom_lancer_sun_catcher_thinker:IsPurgable()	return false end

function modifier_imba_phantom_lancer_sun_catcher_thinker:OnCreated()
	self.radius			= self:GetAbility():GetSpecialValueFor("radius")
	self.aura_duration	= self:GetAbility():GetSpecialValueFor("aura_duration")
end

function modifier_imba_phantom_lancer_sun_catcher_thinker:IsAura() 						return true end
function modifier_imba_phantom_lancer_sun_catcher_thinker:IsAuraActiveOnDeath() 		return false end

function modifier_imba_phantom_lancer_sun_catcher_thinker:GetAuraRadius()				return self.radius end
function modifier_imba_phantom_lancer_sun_catcher_thinker:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_phantom_lancer_sun_catcher_thinker:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_phantom_lancer_sun_catcher_thinker:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_phantom_lancer_sun_catcher_thinker:GetModifierAura()				return "modifier_imba_phantom_lancer_sun_catcher_aura" end
function modifier_imba_phantom_lancer_sun_catcher_thinker:GetAuraDuration()				return self.aura_duration end

-- function modifier_imba_phantom_lancer_sun_catcher_thinker:GetAuraEntityReject(hEntity) 	return false end

---------------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_SUN_CATCHER_AURA --
---------------------------------------------------

function modifier_imba_phantom_lancer_sun_catcher_aura:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf"
end

function modifier_imba_phantom_lancer_sun_catcher_aura:DeclareFunctions()
	return {MODIFIER_PROPERTY_MISS_PERCENTAGE}
end

function modifier_imba_phantom_lancer_sun_catcher_aura:GetModifierMiss_Percentage()
	return 100
end
 
-----------------------------------
-- IMBA_PHANTOM_LANCER_JUXTAPOSE --
-----------------------------------

function imba_phantom_lancer_juxtapose:IsStealable() return false end

function imba_phantom_lancer_juxtapose:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL
end

function imba_phantom_lancer_juxtapose:GetCooldown(level)
	return self:GetSpecialValueFor("confusion_cooldown")
end

function imba_phantom_lancer_juxtapose:GetIntrinsicModifierName()
	return "modifier_imba_phantom_lancer_juxtapose"
end

function imba_phantom_lancer_juxtapose:OnToggle()
	if self:GetToggleState() then
		self:EndCooldown()
	end
end

function imba_phantom_lancer_juxtapose:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
	
	if self:GetCaster():HasTalent("special_bonus_imba_phantom_lancer_juxtapose_assault_delimiter") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_phantom_lancer_juxtapose_assault_delimiter") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_phantom_lancer_juxtapose_assault_delimiter"), "modifier_special_bonus_imba_phantom_lancer_juxtapose_assault_delimiter", {})
	end
end

function imba_phantom_lancer_juxtapose:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

--------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_JUXTAPOSE --
--------------------------------------------

function modifier_imba_phantom_lancer_juxtapose:IsHidden()		return true end
function modifier_imba_phantom_lancer_juxtapose:IsPurgable()	return false end
function modifier_imba_phantom_lancer_juxtapose:RemoveOnDeath()	return false end

function modifier_imba_phantom_lancer_juxtapose:OnCreated()
	self.duration = 0
	
	self.directional_vectors = {
		Vector(72, 0, 0),
		Vector(0, -72, 0),
		Vector(-72, 0, 0),
		Vector(0, 72, 0)
	}
	
	if not IsServer() then return end
	
	if self:GetParent():IsRealHero() then
		self.owner = self:GetParent()
		
		self.owner.juxtapose_table = {}
	elseif not self:GetParent():IsRealHero() and self:GetParent():GetOwner() and self:GetParent():GetOwner():GetAssignedHero() then
		self.owner = self:GetParent():GetOwner():GetAssignedHero()
	end
end

function modifier_imba_phantom_lancer_juxtapose:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_imba_phantom_lancer_juxtapose:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() and not keys.target:IsBuilding() and self.owner and self.owner.juxtapose_table and not self.owner:PassivesDisabled() then
		if self:GetParent():IsRealHero() and RollPseudoRandom(self:GetAbility():GetSpecialValueFor("proc_chance_pct"), self.owner:FindModifierByName("modifier_imba_phantom_lancer_juxtapose")) then
			self.duration = self:GetAbility():GetSpecialValueFor("illusion_duration")
		elseif not self:GetParent():IsRealHero() and RollPseudoRandom(self:GetAbility():GetSpecialValueFor("illusion_proc_chance_pct"), self.owner:FindModifierByName("modifier_imba_phantom_lancer_juxtapose")) then
			self.duration = self:GetAbility():GetSpecialValueFor("illusion_from_illusion_duration")
		end
		
		if #(self.owner.juxtapose_table) < self:GetAbility():GetTalentSpecialValueFor("max_illusions") and self.duration > 0 and self.owner.juxtapose_table then
			-- for _, mod in pairs(self:GetParent():FindAllModifiers()) do
				-- print(mod:GetName())
			-- end
		
			local illusions = CreateIllusions(self.owner, self:GetParent(), 
			{
				outgoing_damage = self:GetAbility():GetSpecialValueFor("illusion_damage_out_pct"),
				incoming_damage	= self:GetAbility():GetSpecialValueFor("illusion_damage_in_pct"),
				bounty_base		= 5,
				bounty_growth	= nil,
				outgoing_damage_structure	= nil,
				outgoing_damage_roshan		= nil,
				duration		= self.duration
			}
			, 1, 72, false, true)
			
			for _, illusion in pairs(illusions) do
				self.spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantom_lancer_spawn_illusion.vpcf", PATTACH_ABSORIGIN_FOLLOW, illusion)
				ParticleManager:SetParticleControlEnt(self.spawn_particle, 0, illusion, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(self.spawn_particle, 1, illusion, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(self.spawn_particle)
			
				illusion:AddNewModifier(self:GetCaster(), self, "modifier_phantom_lancer_juxtapose_illusion", {})
				-- FindClearSpaceForUnit(illusion, self:GetParent():GetAbsOrigin() + self.directional_vectors[RandomInt(1, #self.directional_vectors)], true)
				illusion:SetAggroTarget(keys.target)
				
				table.insert(self.owner.juxtapose_table, illusion:entindex())
			end
			
			-- IMBAfication: Confusion of the Highest Order
			if self.owner:FindAbilityByName("imba_phantom_lancer_juxtapose") and self.owner:FindAbilityByName("imba_phantom_lancer_juxtapose"):GetToggleState() and self.owner:FindAbilityByName("imba_phantom_lancer_juxtapose"):IsCooldownReady() then
				self.confusion_positions = {}
				
				for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.owner:FindAbilityByName("imba_phantom_lancer_juxtapose"):GetSpecialValueFor("confusion_radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)) do
					table.insert(self.confusion_positions, unit:GetAbsOrigin())
				end
				
				for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.owner:FindAbilityByName("imba_phantom_lancer_juxtapose"):GetSpecialValueFor("confusion_radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)) do
					FindClearSpaceForUnit(unit, self.confusion_positions[_], true)
				end
				
				self.confusion_positions = nil
				
				self.owner:FindAbilityByName("imba_phantom_lancer_juxtapose"):UseResources(true, false, false, true)
			end
		end
	
		-- IMBAfication: Assault Fever		
		if self.duration > 0 and (#(self.owner.juxtapose_table) >= self:GetAbility():GetTalentSpecialValueFor("max_illusions")) then -- or (self.owner.HasTalent and self.owner:HasTalent("special_bonus_imba_phantom_lancer_juxtapose_assault_delimiter"))) then
			for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)) do
				if unit:GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID() then
					local assault_modifier = unit:AddNewModifier(self:GetParent():GetOwner():GetAssignedHero(), self:GetAbility(), "modifier_imba_phantom_lancer_juxtapose_assault", {duration = self:GetAbility():GetSpecialValueFor("assault_duration")})
					
					if self.owner:HasModifier("modifier_imba_phantom_lancer_juxtapose_assault") and self.owner:FindModifierByName("modifier_imba_phantom_lancer_juxtapose_assault"):GetStackCount() ~= assault_modifier:GetStackCount() then
						assault_modifier:SetStackCount(self.owner:FindModifierByName("modifier_imba_phantom_lancer_juxtapose_assault"):GetStackCount())
					end
				end
			end
		end
		
		self.duration = 0
	end
end

function modifier_imba_phantom_lancer_juxtapose:OnDeath(keys)
	if keys.unit == self:GetParent() and self.owner and not self.owner:IsNull() and self.owner.juxtapose_table then
		Custom_ArrayRemove(self.owner.juxtapose_table, function(i, j)
			return self.owner.juxtapose_table[i] ~= self:GetParent():entindex()
		end)
	end
end

----------------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_JUXTAPOSE_ASSAULT --
----------------------------------------------------

function modifier_imba_phantom_lancer_juxtapose_assault:OnCreated()
	self.assault_attack_speed	= self:GetAbility():GetSpecialValueFor("assault_attack_speed") + self:GetCaster():FindTalentValue("special_bonus_imba_phantom_lancer_juxtapose_assault_delimiter")
	self.assault_armor			= self:GetAbility():GetSpecialValueFor("assault_armor") + self:GetCaster():FindTalentValue("special_bonus_imba_phantom_lancer_juxtapose_assault_delimiter", "value2")
	
	if not IsServer() then return end
	
	self:IncrementStackCount()
end

function modifier_imba_phantom_lancer_juxtapose_assault:OnRefresh()
	if not IsServer() then return end
	
	self:IncrementStackCount()
end

function modifier_imba_phantom_lancer_juxtapose_assault:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_imba_phantom_lancer_juxtapose_assault:GetModifierAttackSpeedBonus_Constant()
	return self.assault_attack_speed * self:GetStackCount()
end

function modifier_imba_phantom_lancer_juxtapose_assault:GetModifierPhysicalArmorBonus()
	return self.assault_armor * self:GetStackCount()
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_phantom_lancer_spirit_lance_damage", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_phantom_lancer_juxtapose_assault_delimiter", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_phantom_lancer_phantom_edge_distance", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_phantom_lancer_doppelwalk_cooldown", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_phantom_lancer_spirit_lance_damage			= modifier_special_bonus_imba_phantom_lancer_spirit_lance_damage or class({})
modifier_special_bonus_imba_phantom_lancer_juxtapose_assault_delimiter	= modifier_special_bonus_imba_phantom_lancer_juxtapose_assault_delimiter or class({})
modifier_special_bonus_imba_phantom_lancer_phantom_edge_distance		= modifier_special_bonus_imba_phantom_lancer_phantom_edge_distance or class({})
modifier_special_bonus_imba_phantom_lancer_doppelwalk_cooldown			= modifier_special_bonus_imba_phantom_lancer_doppelwalk_cooldown or class({})

function modifier_special_bonus_imba_phantom_lancer_spirit_lance_damage:IsHidden() 			return true end
function modifier_special_bonus_imba_phantom_lancer_spirit_lance_damage:IsPurgable() 		return false end
function modifier_special_bonus_imba_phantom_lancer_spirit_lance_damage:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_phantom_lancer_juxtapose_assault_delimiter:IsHidden() 			return true end
function modifier_special_bonus_imba_phantom_lancer_juxtapose_assault_delimiter:IsPurgable() 		return false end
function modifier_special_bonus_imba_phantom_lancer_juxtapose_assault_delimiter:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_phantom_lancer_phantom_edge_distance:IsHidden() 		return true end
function modifier_special_bonus_imba_phantom_lancer_phantom_edge_distance:IsPurgable() 		return false end
function modifier_special_bonus_imba_phantom_lancer_phantom_edge_distance:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_phantom_lancer_doppelwalk_cooldown:IsHidden() 			return true end
function modifier_special_bonus_imba_phantom_lancer_doppelwalk_cooldown:IsPurgable() 		return false end
function modifier_special_bonus_imba_phantom_lancer_doppelwalk_cooldown:RemoveOnDeath() 	return false end

function imba_phantom_lancer_spirit_lance:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_phantom_lancer_spirit_lance_damage") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_phantom_lancer_spirit_lance_damage") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_phantom_lancer_spirit_lance_damage"), "modifier_special_bonus_imba_phantom_lancer_spirit_lance_damage", {})
	end
end

function imba_phantom_lancer_doppelwalk:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_phantom_lancer_doppelwalk_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_phantom_lancer_doppelwalk_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_phantom_lancer_doppelwalk_cooldown"), "modifier_special_bonus_imba_phantom_lancer_doppelwalk_cooldown", {})
	end
end

function imba_phantom_lancer_phantom_edge:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_phantom_lancer_phantom_edge_distance") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_phantom_lancer_phantom_edge_distance") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_phantom_lancer_phantom_edge_distance"), "modifier_special_bonus_imba_phantom_lancer_phantom_edge_distance", {})
	end
end

function imba_phantom_lancer_juxtapose:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_phantom_lancer_juxtapose_assault_delimiter") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_phantom_lancer_juxtapose_assault_delimiter") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_phantom_lancer_juxtapose_assault_delimiter"), "modifier_special_bonus_imba_phantom_lancer_juxtapose_assault_delimiter", {})
	end
end
