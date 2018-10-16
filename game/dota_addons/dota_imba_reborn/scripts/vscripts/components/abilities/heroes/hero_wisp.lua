-- Editors:
--     EarthSalamander #42, 23.05.2018 (contributor)
--	   Naowin, 13.06.2018 (creator)
--     Based on old Dota 2 Spell Library: https://github.com/Pizzalol/SpellLibrary/blob/master/game/scripts/vscripts/heroes/hero_wisp

------------------------------
--			TETHER			--
------------------------------
imba_wisp_tether = class({})
LinkLuaModifier("modifier_imba_wisp_tether", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_tether_ally", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_tether_latch", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_tether_slow", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_tether_slow_immune", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_tether_ally_attack", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_tether_bonus_regen", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)

function imba_wisp_tether:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "dota_hud_error_cant_cast_on_self"
	elseif target:HasModifier("modifier_imba_wisp_tether") and self:GetCaster():HasModifier("modifier_imba_wisp_tether_ally") then
		return "WHY WOULD YOU DO THIS"
	end
end

function imba_wisp_tether:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		local casterID = caster:GetPlayerOwnerID()
		local targetID = target:GetPlayerOwnerID()

		if target == caster then
			return UF_FAIL_CUSTOM
		end

		if target:IsCourier() then
			return UF_FAIL_COURIER
		end

		if target ~= nil and not target:IsOpposingTeam(caster:GetTeamNumber()) and PlayerResource:IsDisableHelpSetForPlayerID(targetID,casterID) then
			return UF_FAIL_DISABLE_HELP
		end

		if target:HasModifier("modifier_imba_wisp_tether") and self:GetCaster():HasModifier("modifier_imba_wisp_tether_ally") then
			return UF_FAIL_CUSTOM
		end
		
		local nResult = UnitFilter(target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), caster:GetTeamNumber())
		return nResult
	end
end

function imba_wisp_tether:GetCastRange(location, target)
	local cast_range = self.BaseClass.GetCastRange(self,location,target) + self:GetCaster():FindTalentValue("special_bonus_imba_wisp_5")
	return cast_range
end


function imba_wisp_tether:OnSpellStart()
	local ability 				= self:GetCaster():FindAbilityByName("imba_wisp_tether")
	local caster 				= self:GetCaster()
	local destroy_tree_radius 	= ability:GetSpecialValueFor("destroy_tree_radius")
	local movespeed 			= ability:GetSpecialValueFor("movespeed")
	local regen_bonus			= ability:GetSpecialValueFor("tether_bonus_regen")
	local latch_distance 		= self:GetSpecialValueFor("latch_distance")

	if caster:HasTalent("special_bonus_imba_wisp_5") then 
		ability.bonus_range 	= caster:FindTalentValue("special_bonus_imba_wisp_5")
		latch_distance 			= latch_distance + ability.bonus_range
	end	

	-- needed to be accessed globaly
	ability.slow_duration 		= ability:GetSpecialValueFor("stun_duration")
	ability.slow 	    		= ability:GetSpecialValueFor("slow")

	self.caster_origin 			= self:GetCaster():GetAbsOrigin()
	self.target_origin 			= self:GetCursorTarget():GetAbsOrigin()
	self.tether_ally 			= self:GetCursorTarget()
	self.tether_slowedUnits 	= {}
	self.target 				= self:GetCursorTarget()

	caster:AddNewModifier(self:GetCaster(), self, "modifier_imba_wisp_tether", {})

	local self_regen_bonus = caster:AddNewModifier(self:GetCaster(), self, "modifier_imba_wisp_tether_bonus_regen", {})
	self_regen_bonus:SetStackCount(regen_bonus)
	local tether_modifier = self:GetCursorTarget():AddNewModifier(self:GetCaster(), ability, "modifier_imba_wisp_tether_ally", {})
	tether_modifier:SetStackCount(movespeed)
	local target_regen_bonus = self:GetCursorTarget():AddNewModifier(self:GetCaster(), ability, "modifier_imba_wisp_tether_bonus_regen", {})
	target_regen_bonus:SetStackCount(regen_bonus)

	if caster:HasModifier("modifier_imba_wisp_overcharge") then
		if self.target:HasModifier("modifier_imba_wisp_overcharge") then 
			self.target:RemoveModifierByName("modifier_imba_wisp_overcharge")
		end
		
		imba_wisp_overcharge:AddOvercharge(self:GetCaster(), self.target)
	end

	if caster:HasTalent("special_bonus_imba_wisp_2") then
		self.tether_ally:SetStolenScepter(true)
	end

	if caster:HasTalent("special_bonus_imba_wisp_6") then
		self.target:AddNewModifier(self:GetCaster(), ability, "modifier_imba_wisp_tether_ally_attack", {})
	end

	local distToAlly = (self:GetCursorTarget():GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
	if distToAlly >= latch_distance then
		caster:AddNewModifier(caster, self, "modifier_imba_wisp_tether_latch", { destroy_tree_radius =  destroy_tree_radius})
	end

	-- Let's manually add Tether Break for Rubick and Morphling so they can use the skill properly
	if not caster:HasAbility("imba_wisp_tether_break") then
		caster:AddAbility("imba_wisp_tether_break")
	end
	
	caster:SwapAbilities("imba_wisp_tether", "imba_wisp_tether_break", false, true)
	caster:FindAbilityByName("imba_wisp_tether_break"):SetLevel(1)
end

-- Remove Tether Break for Rubick and Morphling when skill is lost
function imba_wisp_tether:OnUnStolen()
	if self:GetCaster():HasAbility("imba_wisp_tether_break") then
		self:GetCaster():RemoveAbility("imba_wisp_tether_break")
	end
end

modifier_imba_wisp_tether = class({})
function modifier_imba_wisp_tether:IsHidden() return false end
function modifier_imba_wisp_tether:IsPurgable() return false end

function modifier_imba_wisp_tether:OnCreated(params)
	if IsServer() then 
		self.target 			= self:GetAbility().target
		self.radius 			= self:GetAbility():GetSpecialValueFor("radius")
		self.tether_heal_amp 	= self:GetAbility():GetSpecialValueFor("tether_heal_amp")

		if self:GetCaster():HasTalent("special_bonus_imba_wisp_5") then 
		local bonus_range 		= self:GetCaster():FindTalentValue("special_bonus_imba_wisp_5")
		self.radius 			= self.radius + bonus_range
		end	
		
		-- used to count total health/mana gained during 1sec
		self.total_gained_mana 		= 0
		self.total_gained_health 	= 0
		self.update_timer 			= 0
		self.time_to_send 			= 1

		EmitSoundOn("Hero_Wisp.Tether", self:GetParent())

		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_wisp_tether:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_HEALTH_GAINED,
		MODIFIER_EVENT_ON_MANA_GAINED,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_MAX
	}

	return decFuncs
end

function modifier_imba_wisp_tether:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_imba_wisp_tether:OnIntervalThink()
	if IsServer() then
		self.update_timer = self.update_timer + FrameTime()
	
		CustomNetTables:SetTableValue(
		"player_table", 
		tostring(self:GetCaster():GetPlayerOwnerID()), 
		{ 	
			tether_movement_speed = self:GetAbility().tether_ally:GetIdealSpeed()
		})

		-- handle health and mana
		if self.update_timer > self.time_to_send then 
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.target, self.total_gained_health * self.tether_heal_amp, nil)	
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self.target, self.total_gained_mana * self.tether_heal_amp, nil)

			self.total_gained_mana 		= 0
			self.total_gained_health 	= 0
			self.update_timer 			= 0
		end
		
		if (self:GetParent():IsOutOfGame()) then
			self:GetParent():RemoveModifierByName("modifier_imba_wisp_tether")
			return
		end
		
		if self:GetParent():HasModifier("modifier_imba_wisp_tether_latch") then
			return
		end

		local distance = (self:GetAbility().tether_ally:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()

		if distance <= self.radius then
			return
		end

		self:GetParent():RemoveModifierByName("modifier_imba_wisp_tether")
	end
end

function modifier_imba_wisp_tether:OnHealthGained(keys)
	if keys.unit == self:GetParent() then
		self.target:Heal(keys.gain * self.tether_heal_amp, self:GetAbility())
		-- in order to avoid spam in "OnGained" we group it up in total_gained. Value is sent and reset each 1s
		self.total_gained_health = self.total_gained_health + keys.gain
	end
end

function modifier_imba_wisp_tether:OnManaGained(keys)
	if keys.unit == self:GetParent() then
		self.target:GiveMana(keys.gain * self.tether_heal_amp)
		-- in order to avoid spam in "OnGained" we group it up in total_gained. Value is sent and reset each 1s
		self.total_gained_mana = self.total_gained_mana + keys.gain
	end
end

function modifier_imba_wisp_tether:GetModifierMoveSpeed_Absolute()
    local net_table = CustomNetTables:GetTableValue("player_table", tostring(self:GetCaster():GetPlayerOwnerID())) or {}
	return net_table.tether_movement_speed or 0
end

function modifier_imba_wisp_tether:GetModifierMoveSpeed_Max()
	return 3000
end

function modifier_imba_wisp_tether:OnRemoved()
	if IsServer() then
		if self:GetParent():HasModifier("modifier_imba_wisp_tether_latch") then
			self:GetParent():RemoveModifierByName("modifier_imba_wisp_tether_latch")
		end

		if self:GetParent():HasModifier("modifier_imba_wisp_tether_bonus_regen") then
			self:GetParent():RemoveModifierByName("modifier_imba_wisp_tether_bonus_regen")
		end

		if self.target:HasModifier("modifier_imba_wisp_tether_ally") then
			self.target:RemoveModifierByName("modifier_imba_wisp_overcharge")
			self.target:RemoveModifierByName("modifier_imba_wisp_tether_ally")
			self.target:RemoveModifierByName("modifier_imba_wisp_tether_bonus_regen")
		end

		if self:GetCaster():HasTalent("special_bonus_imba_wisp_2") then
			self.target:SetStolenScepter(false)
		end

		self:GetCaster():EmitSound("Hero_Wisp.Tether.Stop")
		self:GetCaster():StopSound("Hero_Wisp.Tether")
		self:GetParent():SwapAbilities("imba_wisp_tether_break", "imba_wisp_tether", false, true)
	end
end

------------------------------
--	 TETHER Regen modifier	--
------------------------------
modifier_imba_wisp_tether_bonus_regen = class({})
function modifier_imba_wisp_tether_bonus_regen:IsHidden() return true end
function modifier_imba_wisp_tether_bonus_regen:IsPurgable() return false end
function modifier_imba_wisp_tether_bonus_regen:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}

	return decFuncs
end

function modifier_imba_wisp_tether_bonus_regen:GetTexture()
	return "wisp_tether"
end

function modifier_imba_wisp_tether_bonus_regen:GetModifierHealthRegenPercentage()
	return self:GetStackCount() / 100
end


------------------------------
--	 TETHER AllY modifier	--
------------------------------
modifier_imba_wisp_tether_ally = class({})
function modifier_imba_wisp_tether_ally:IsHidden() return false end
function modifier_imba_wisp_tether_ally:IsPurgable() return false end
function modifier_imba_wisp_tether_ally:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return decFuncs
end

function modifier_imba_wisp_tether_ally:OnCreated()
	if IsServer() then
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

		EmitSoundOn("Hero_Wisp.Tether.Target", self:GetParent())

		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_wisp_tether_ally:OnIntervalThink()
	if IsServer() then
		local velocity = self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()
		local vVelocity = velocity / FrameTime()
		vVelocity.z = 0

		local projectile = 
		{
			Ability				= self:GetAbility(),
			EffectName			= "particles/hero/ghost_revenant/blackjack_projectile.vpcf",
			vSpawnOrigin		= self:GetCaster():GetAbsOrigin(),
			fDistance			= velocity:Length2D(),
			fStartRadius		= 100,
			fEndRadius			= 100,
			bReplaceExisting 	= false,
			iMoveSpeed			= vVelocity,
			Source				= self:GetCaster(),
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime			= GameRules:GetGameTime() + 1,
			bDeleteOnHit		= false,
			vVelocity			= vVelocity / 3, 
			ExtraData 			= {
				slow_duration 	= self:GetAbility().slow_duration,
				slow 			= self:GetAbility().slow
			}
		}

		ProjectileManager:CreateLinearProjectile(projectile)
	end
end

function modifier_imba_wisp_tether_ally:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

function imba_wisp_tether:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target ~= nil then
		-- Variables
		local caster		= self:GetCaster()
		local slow 			= ExtraData.slow
		local slow_duration = ExtraData.slow_duration

		-- Acalia wants more stuff here...

		-- Apply slow debuff
		local slow_ref = target:AddNewModifier(caster, self, "modifier_imba_wisp_tether_slow", { duration = slow_duration })
		slow_ref:SetStackCount(slow)

		-- An enemy unit may only be slowed once per cast.
		-- We store the enemy unit to the hashset, so we can check whether the unit has got debuff already later on.
		--self:GetAbility().tether_slowedUnits[target] = true
	end
end

function modifier_imba_wisp_tether_ally:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_imba_wisp_tether_ally:OnRemoved() 
	if IsServer() then
		self:GetAbility().target = nil
		self:GetParent():RemoveModifierByName("modifier_imba_wisp_tether_slow_immune")
		self:GetCaster():RemoveModifierByName("modifier_imba_wisp_tether_slow_immune")
		self:GetParent():RemoveModifierByName("modifier_imba_wisp_tether_ally_attack")
		self:GetCaster():RemoveModifierByName("modifier_imba_wisp_tether")
		self:GetParent():StopSound("Hero_Wisp.Tether.Target")
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end

--------------------------------------
--	 TETHER Track attack modifier	--
--------------------------------------
modifier_imba_wisp_tether_ally_attack = class({})
function modifier_imba_wisp_tether_ally_attack:IsHidden() return true end
function modifier_imba_wisp_tether_ally_attack:IsPurgable() return false end
function modifier_imba_wisp_tether_ally_attack:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ATTACK
	}

	return decFuncs
end

function modifier_imba_wisp_tether_ally_attack:OnAttack(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:GetCaster():PerformAttack(params.target, true, true, true, false, true, false, false)
		end
	end
end

--------------------------------------
--	 TETHER slow immune modifier	--
--------------------------------------
modifier_imba_wisp_tether_slow_immune = class({})
function modifier_imba_wisp_tether_slow_immune:IsHidden() return true end
function modifier_imba_wisp_tether_slow_immune:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT
	}
	return funcs
end

function modifier_imba_wisp_tether_slow_immune:OnCreated(params)
	if IsServer() then 
		self.limit 			= params.limit
		self.minimum_speed 	= params.minimum_speed
	else
		local net_table 	= CustomNetTables:GetTableValue("player_table", tostring(self:GetCaster():GetPlayerOwnerID())) or {}
		self.minimum_speed 	= net_table.tether_minimum_speed or 0
		self.limit 			= net_table.tether_limit or 0
	end
end

function modifier_imba_wisp_tether_slow_immune:GetModifierMoveSpeed_AbsoluteMin()
	return self.minimum_speed
end

function modifier_imba_wisp_tether_slow_immune:GetModifierMoveSpeed_Limit()
	return self.limit
end

------------------------------
--	 TETHER slow modifier	--
------------------------------
modifier_imba_wisp_tether_slow = class({})
function modifier_imba_wisp_tether_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}	
	return funcs
end

function modifier_imba_wisp_tether_slow:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()
end

function modifier_imba_wisp_tether_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end

function modifier_imba_wisp_tether_slow:OnCreated()
end


------------------------------
--	 TETHER latch modifier	--
------------------------------
modifier_imba_wisp_tether_latch = class({})
function modifier_imba_wisp_tether_latch:OnCreated(params)
	if IsServer() then
		self.target 				= self:GetAbility().target
		self.destroy_tree_radius 	= params.destroy_tree_radius
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_wisp_tether_latch:OnIntervalThink()
	if IsServer() then
		-- Calculate the distance
		local casterDir = self:GetCaster():GetAbsOrigin() - self.target:GetAbsOrigin()
		local distToAlly = casterDir:Length2D()
		casterDir = casterDir:Normalized()

		if distToAlly > self:GetAbility():GetSpecialValueFor("latch_distance") then
			-- Leap to the target
			distToAlly = distToAlly - self:GetAbility():GetSpecialValueFor("latch_speed") * FrameTime()
			distToAlly = math.max( distToAlly, self:GetAbility():GetSpecialValueFor("latch_distance"))	-- Clamp this value

			local pos = self.target:GetAbsOrigin() + casterDir * distToAlly
			pos = GetGroundPosition(pos, self:GetCaster())

			self:GetCaster():SetAbsOrigin(pos)
		end

		if distToAlly <= self:GetAbility():GetSpecialValueFor("latch_distance") then
			-- We've reached, so finish latching
			GridNav:DestroyTreesAroundPoint(self:GetCaster():GetAbsOrigin(), self.destroy_tree_radius, false)
			ResolveNPCPositions(self:GetCaster():GetAbsOrigin(), 128)
			self:GetCaster():RemoveModifierByName("modifier_imba_wisp_tether_latch")
		end
	end
end

------------------------------
--		 BREAK TETHER 		--
------------------------------
imba_wisp_tether_break = class({})
function imba_wisp_tether_break:IsInnateAbility() return true end
function imba_wisp_tether_break:IsStealable() return false end

function imba_wisp_tether_break:OnSpellStart()

	-- Let's manually add Tether for Morphling so they can use the skill properly (super bootleg)
	if not self:GetCaster():HasAbility("imba_wisp_tether") then
		local stolenAbility = self:GetCaster():AddAbility("imba_wisp_tether")
		stolenAbility:SetLevel(min((self:GetCaster():GetLevel() / 2) - 1, 4))
		self:GetCaster():SwapAbilities("imba_wisp_tether_break", "imba_wisp_tether", false, true)
	end

	self:GetCaster():RemoveModifierByName("modifier_imba_wisp_tether")
	local target = self:GetCaster():FindAbilityByName("imba_wisp_tether").target
	if target ~= nil and target:HasModifier("modifier_imba_wisp_overcharge") then
		target:RemoveModifierByName("modifier_imba_wisp_overcharge")
	end
end

-- ugh
function imba_wisp_tether_break:OnUnStolen()
	if self:GetCaster():HasAbility("imba_wisp_tether") then
		self:GetCaster():RemoveAbility("imba_wisp_tether")
	end
end

------------------------------
--			SPIRITS			--
------------------------------
imba_wisp_spirits = class({})
LinkLuaModifier("modifier_imba_wisp_spirits", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_spirit_handler", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_spirits_hero_hit", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_spirits_creep_hit", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_spirits_slow", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_spirit_damage_handler", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_spirits_true_sight", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)

function imba_wisp_spirits:OnSpellStart()
	if IsServer() then
		self.caster 					= self:GetCaster()
		self.ability 					= self.caster:FindAbilityByName("imba_wisp_spirits")
		self.start_time 				= GameRules:GetGameTime()
		self.spirits_num_spirits		= 0
		local spirit_min_radius 		= self.ability:GetSpecialValueFor("min_range")
		local spirit_max_radius 		= self.ability:GetSpecialValueFor("max_range")
		local spirit_movement_rate		= self.ability:GetSpecialValueFor("spirit_movement_rate")
		local creep_damage				= self.ability:GetSpecialValueFor("creep_damage")
		local explosion_damage			= self.ability:GetSpecialValueFor("explosion_damage")
		local slow						= self.ability:GetSpecialValueFor("slow")
		local spirit_duration 			= self.ability:GetSpecialValueFor("spirit_duration")
		local spirit_summon_interval	= self.ability:GetSpecialValueFor("spirit_summon_interval")
		local max_spirits 				= self.ability:GetSpecialValueFor("num_spirits")
		local collision_radius			= self.ability:GetSpecialValueFor("collision_radius")
		local explosion_radius			= self.ability:GetSpecialValueFor("explode_radius")
		local spirit_turn_rate 			= self.ability:GetSpecialValueFor("spirit_turn_rate")
		local vision_radius				= self.ability:GetSpecialValueFor("explode_radius")
		local vision_duration 			= self.ability:GetSpecialValueFor("vision_duration")
		local slow_duration 			= self.ability:GetSpecialValueFor("slow_duration")
		local damage_interval			= self.ability:GetSpecialValueFor("damage_interval")

		self.spirits_movementFactor				= 1	
		self.ability.spirits_spiritsSpawned		= {}

		EmitSoundOn("Hero_Wisp.Spirits.Cast", self.caster)	

		-- Exception for naughty Morphlings...
		if self.caster:HasModifier("modifier_imba_wisp_spirits") then
			self.caster:RemoveModifierByName("modifier_imba_wisp_spirits")
		end
		
		-- Let's manually add Toggle Spirits for Rubick and Morphling so they can use the skill properly
		if not self.caster:HasAbility("imba_wisp_spirits_toggle") then
			self.caster:AddAbility("imba_wisp_spirits_toggle")
		end
		
		self.caster:SwapAbilities("imba_wisp_spirits", "imba_wisp_spirits_toggle", false, true )
		self.caster:FindAbilityByName("imba_wisp_spirits_toggle"):SetLevel(1)
		self.caster:AddNewModifier(
			self.caster, 
			self.ability, 
			"modifier_imba_wisp_spirits", 
			{
				duration = spirit_duration,
				spirits_starttime 		= GameRules:GetGameTime(),
				spirit_summon_interval	= spirit_summon_interval,
				max_spirits 			= max_spirits,
				collision_radius 		= collision_radius,
				explosion_radius 		= explosion_radius,
				spirit_min_radius		= spirit_min_radius,
				spirit_max_radius		= spirit_max_radius,
				spirit_movement_rate	= spirit_movement_rate,
				spirit_turn_rate 		= spirit_turn_rate,
				vision_radius			= vision_radius,
				vision_duration			= vision_duration,
				creep_damage 			= creep_damage,
				explosion_damage 		= explosion_damage,
				slow_duration 			= slow_duration,
				slow 					= slow
			}) 

		self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_wisp_spirit_damage_handler", {duration = -1, damage_interval = damage_interval})
	end
end

-- Remove Toggle Spirits for Rubick and Morphling when skill is lost
function imba_wisp_spirits:OnUnStolen()
	if self:GetCaster():HasAbility("imba_wisp_spirits_toggle") then
		self:GetCaster():RemoveAbility("imba_wisp_spirits_toggle")
	end
end

modifier_imba_wisp_spirit_damage_handler = class({})
function modifier_imba_wisp_spirit_damage_handler:IsHidden() return true end
function modifier_imba_wisp_spirit_damage_handler:IsPurgable() return false end
function modifier_imba_wisp_spirit_damage_handler:OnCreated(params)
	if IsServer() then 
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()

		self:StartIntervalThink(params.damage_interval)
	end
end

function modifier_imba_wisp_spirit_damage_handler:OnIntervalThink()
	if IsServer() then 
		self.ability.hit_table = {}
	end
end

------------------------------
--		SPIRITS	modifier	--
------------------------------
modifier_imba_wisp_spirits = class({})
function modifier_imba_wisp_spirits:OnCreated(params)
	if IsServer() then
		self.start_time 				= params.spirits_starttime
		self.spirit_summon_interval 	= params.spirit_summon_interval
		self.max_spirits				= params.max_spirits
		self.collision_radius			= params.collision_radius
		self.explosion_radius			= params.explosion_radius
		self.spirit_radius 				= params.collision_radius
		self.spirit_min_radius			= params.spirit_min_radius
		self.spirit_max_radius			= params.spirit_max_radius
		self.spirit_movement_rate 		= params.spirit_movement_rate
		self.spirit_turn_rate			= params.spirit_turn_rate
		self.vision_radius				= params.vision_radius
		self.vision_duration			= params.vision_duration
		self.creep_damage 				= params.creep_damage
		self.explosion_damage			= params.explosion_damage
		self.slow_duration				= params.slow_duration
		self.slow 						= params.slow

		-- timers for tracking update of FX
		self:GetAbility().update_timer 	= 0
		self.time_to_update  			= 0.5

		EmitSoundOn("Hero_Wisp.Spirits.Loop", self:GetCaster())	

		self:StartIntervalThink(0.03)
	end
end

function modifier_imba_wisp_spirits:OnIntervalThink()
	if IsServer() then
		local caster 					= self:GetCaster()
		local caster_position 			= caster:GetAbsOrigin()
		local ability 					= self:GetAbility()
		local elapsedTime 				= GameRules:GetGameTime() - self.start_time
		local idealNumSpiritsSpawned 	= elapsedTime / self.spirit_summon_interval

		-- add time to update timer
		ability.update_timer 	= ability.update_timer + FrameTime()


		idealNumSpiritsSpawned 	= math.min(idealNumSpiritsSpawned, self.max_spirits)

		if ability.spirits_num_spirits < idealNumSpiritsSpawned then

			-- Spawn a new spirit
			local newSpirit = CreateUnitByName("npc_dota_wisp_spirit", caster_position, false, caster, caster, caster:GetTeam())

			-- Create particle FX
			local pfx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, newSpirit)
			if caster:HasModifier("modifier_imba_wisp_swap_spirits_disarm") then
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_disarm_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit)
				newSpirit.spirit_pfx_disarm = pfx
			elseif caster:HasModifier("modifier_imba_wisp_swap_spirits_silence") then
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_silence_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit)
				newSpirit.spirit_pfx_silence = pfx
			else -- Just for Rubick...since he's not stealing the silence/disarm skill right now
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit)
				newSpirit.spirit_pfx_silence = pfx
			end

			if caster:HasTalent("special_bonus_imba_wisp_3") then 
				self.true_sight_radius = caster:FindTalentValue("special_bonus_imba_wisp_3", "true_sight_radius")
				local true_sight_aura = newSpirit:AddNewModifier(caster, self, "modifier_imba_wisp_spirits_true_sight", {})
				true_sight_aura:SetStackCount(self.true_sight_radius)
				newSpirit:SetDayTimeVisionRange(self.true_sight_radius)
				newSpirit:SetNightTimeVisionRange(self.true_sight_radius)
			end
			
			-- Update the state
			local spiritIndex = ability.spirits_num_spirits + 1
			newSpirit.spirit_index = spiritIndex
			ability.spirits_num_spirits = spiritIndex
			ability.spirits_spiritsSpawned[spiritIndex] = newSpirit

			-- Apply the spirit modifier
			newSpirit:AddNewModifier(
				caster, 
				ability, 
				"modifier_imba_wisp_spirit_handler", 
				{ 
					duraiton 			= -1,
					vision_radius 		= self.vision_radius,
					vision_duration 	= self.vision_duration,
					tinkerval 			= 360 / self.spirit_turn_rate / self.max_spirits,
					collision_radius 	= self.collision_radius,
					explosion_radius 	= self.explosion_radius,
					creep_damage 		= self.creep_damage,
					explosion_damage 	= self.explosion_damage,
					slow_duration 		= self.slow_duration,
					slow 				= self.slow	
				}
			)
		end
		
		--------------------------------------------------------------------------------
		-- Update the radius
		--------------------------------------------------------------------------------
		local currentRadius	= self.spirit_radius
		local deltaRadius 	= ability.spirits_movementFactor * self.spirit_movement_rate * 0.03
		currentRadius 		= currentRadius + deltaRadius
		currentRadius 		= math.min( math.max( currentRadius, self.spirit_min_radius ), self.spirit_max_radius )
		self.spirit_radius 	= currentRadius

		--------------------------------------------------------------------------------
		-- Update the spirits' positions
		--------------------------------------------------------------------------------
		local currentRotationAngle	= elapsedTime * self.spirit_turn_rate
		local rotationAngleOffset	= 360 / self.max_spirits
		local numSpiritsAlive 		= 0

		for k,spirit in pairs( ability.spirits_spiritsSpawned ) do
			if not spirit:IsNull() then
				numSpiritsAlive = numSpiritsAlive + 1

				-- Rotate
				local rotationAngle = currentRotationAngle - rotationAngleOffset * (k - 1)
				local relPos 		= Vector(0, currentRadius, 0)
				relPos 				= RotatePosition(Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos)
				local absPos 		= GetGroundPosition( relPos + caster_position, spirit)

				spirit:SetAbsOrigin(absPos)

				-- Update particle... switch particle depending on currently active effect. 
				-- the dealy is needed since it takes 0.3s for spirits to fade in.
				if ability.update_timer > self.time_to_update then 
					if caster:HasModifier("modifier_imba_wisp_swap_spirits_disarm") then
						if spirit.spirit_pfx_silence ~= nil then
							ParticleManager:DestroyParticle(spirit.spirit_pfx_silence, true)
						end
					elseif caster:HasModifier("modifier_imba_wisp_swap_spirits_silence") then
						if spirit.spirit_pfx_disarm ~= nil then
							ParticleManager:DestroyParticle(spirit.spirit_pfx_disarm, true)
						end
					end
				end
				
				if spirit.spirit_pfx_silence ~= nil then
					spirit.currentRadius = Vector(currentRadius, 0, 0)
					ParticleManager:SetParticleControl(spirit.spirit_pfx_silence, 1, Vector(currentRadius, 0, 0))
				end

				if spirit.spirit_pfx_disarm ~= nil then 
					spirit.currentRadius = Vector(currentRadius, 0, 0)
					ParticleManager:SetParticleControl(spirit.spirit_pfx_disarm, 1, Vector(currentRadius, 0, 0))
				end
			end
		end

		if ability.update_timer > self.time_to_update then 
			ability.update_timer = 0
		end

		if ability.spirits_num_spirits == self.max_spirits and numSpiritsAlive == 0 then
			-- All spirits have been exploded.
			caster:RemoveModifierByName("modifier_imba_wisp_spirits")
			return
		end
	end
end

function modifier_imba_wisp_spirits:Explode(caster, spirit, explosion_radius, explosion_damage, ability)
	if IsServer() then
		EmitSoundOn("Hero_Wisp.Spirits.Target", spirit)
		ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, spirit)

		-- Check if we hit stuff
		local nearby_enemy_units = FindUnitsInRadius(
			caster:GetTeam(),
			spirit:GetAbsOrigin(), 
			nil, 
			explosion_radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER, 
			false
		)

		local damage_table 			= {}
		damage_table.attacker 		= caster
		damage_table.ability 		= ability
		damage_table.damage_type 	= ability:GetAbilityDamageType() 
		damage_table.damage			= explosion_damage

		-- Deal damage to each enemy hero
		for _,enemy in pairs(nearby_enemy_units) do
			if enemy ~= nil then
				damage_table.victim = enemy

				-- getting random lua errors here... not sure whats up
				ApplyDamage(damage_table)
			end
		end

		-- Let's just have another one here for Rubick to "properly" destroy Spirit particles
		if spirit_pfx_silence ~= nil then
			ParticleManager:DestroyParticle(spirit.spirit_pfx_silence, true)
			ParticleManager:ReleaseParticleIndex(spirit.spirit_pfx_silence)
		end
		
		ability.spirits_spiritsSpawned[spirit.spirit_index] = nil
	end
end

function modifier_imba_wisp_spirits:OnRemoved()
	if IsServer() then
		self:GetCaster():SwapAbilities("imba_wisp_spirits_toggle", "imba_wisp_spirits", false, true )
		local ability 	= self:GetAbility()
		local caster 	= self:GetCaster()
		for k,spirit in pairs( ability.spirits_spiritsSpawned ) do
			if not spirit:IsNull() then
				spirit:RemoveModifierByName("modifier_imba_wisp_spirit_handler")
			end
		end

		self:GetCaster():StopSound("Hero_Wisp.Spirits.Loop")
	end
end

function modifier_imba_wisp_spirits:GetAbilityTextureName()
	if self:GetAbility().spirits_movementFactor == 1 then
		return "custom/kunnka_tide_red"
	else
		return "custom/kunnka_tide_high"
	end
end


----------------------------------------------------------------------
--		SPIRITS	true_sight modifier 								--
----------------------------------------------------------------------
modifier_imba_wisp_spirits_true_sight = class({})
function modifier_imba_wisp_spirits_true_sight:IsAura()
    return true
end

function modifier_imba_wisp_spirits_true_sight:IsHidden()
    return true
end

function modifier_imba_wisp_spirits_true_sight:IsPurgable()
    return false
end

function modifier_imba_wisp_spirits_true_sight:GetAuraRadius()
    return self:GetStackCount()
end

function modifier_imba_wisp_spirits_true_sight:GetModifierAura()
    return "modifier_truesight"
end
   
function modifier_imba_wisp_spirits_true_sight:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_wisp_spirits_true_sight:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_imba_wisp_spirits_true_sight:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER
end

function modifier_imba_wisp_spirits_true_sight:GetAuraDuration()
    return 0.5
end
----------------------------------------------------------------------
--		SPIRITS	on creep hit modifier 								--
----------------------------------------------------------------------
modifier_imba_wisp_spirits_creep_hit = class({})
function modifier_imba_wisp_spirits_creep_hit:IsHidden() return true end
function modifier_imba_wisp_spirits_creep_hit:OnCreated() 
	if IsServer() then
		local target = self:GetParent()
		EmitSoundOn("Hero_Wisp.Spirits.TargetCreep", target)
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_explosion_small.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	end
end

function modifier_imba_wisp_spirits_creep_hit:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx, false)
	end
end

----------------------------------------------------------------------
--		SPIRITS	on hero hit modifier 								--
----------------------------------------------------------------------
modifier_imba_wisp_spirits_hero_hit = class({})
function modifier_imba_wisp_spirits_hero_hit:IsHidden() return true end
function modifier_imba_wisp_spirits_hero_hit:OnCreated(params) 
	if IsServer() then
		local target = self:GetParent()
		local slow_modifier = target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_wisp_spirits_slow", {duration = params.slow_duration})
		slow_modifier:SetStackCount(params.slow)
	end
end

----------------------------------------------------------------------
--		SPIRITS	on hero hit slow modifier							--
----------------------------------------------------------------------
modifier_imba_wisp_spirits_slow = class({})
function modifier_imba_wisp_spirits_slow:IsDebuff() return true end
function modifier_imba_wisp_spirits_slow:IsHidden() return true end
function modifier_imba_wisp_spirits_slow:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
	return funcs
end

function modifier_imba_wisp_spirits_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

function modifier_imba_wisp_spirits_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end

----------------------------------------------------------------------
--		SPIRITS	modifier (keep them from getting targeted)			--
----------------------------------------------------------------------
modifier_imba_wisp_spirit_handler = class({})
function modifier_imba_wisp_spirit_handler:CheckState()
	local state = {
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
	}

	return state
end

function modifier_imba_wisp_spirit_handler:OnCreated(params)
	if IsServer() then
		self.caster 			= self:GetCaster()
		self.ability 			= self:GetAbility()
		self.vision_radius 		= params.vision_radius
		self.vision_duration	= params.vision_duration
		self.tinkerval 			= params.tinkerval
		self.collision_radius 	= params.collision_radius
		self.explosion_radius 	= params.explosion_radius
		self.creep_damage 		= params.creep_damage
		self.explosion_damage 	= params.explosion_damage
		self.slow_duration 		= params.slow_duration
		self.slow 				= params.slow	

		-- dmg timer and hittable
		self.damage_interval 	= 0.10
		self.damage_timer 		= 0
		self.ability.hit_table	= {}

		self:StartIntervalThink(self.damage_interval)
	end
end

function modifier_imba_wisp_spirit_handler:OnIntervalThink()
	if IsServer() then 
		local spirit = self:GetParent()
		-- Check if we hit stuff
		local nearby_enemy_units = FindUnitsInRadius(
			self.caster:GetTeam(),
			spirit:GetAbsOrigin(), 
			nil, 
			self.collision_radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER, 
			false
		)

		spirit.hit_table = self.ability.hit_table
		if nearby_enemy_units ~= nil and #nearby_enemy_units > 0 then
			modifier_imba_wisp_spirit_handler:OnHit(self.caster, spirit, nearby_enemy_units, self.creep_damage, self.ability, self.slow_duration, self.slow)
		end
	end
end

function modifier_imba_wisp_spirit_handler:OnHit(caster, spirit, enemies_hit, creep_damage, ability, slow_duration, slow) 
	local hit_hero = false
	-- Initialize damage table
	local damage_table 			= {}
	damage_table.attacker 		= caster
	damage_table.ability 		= ability
	damage_table.damage_type 	= ability:GetAbilityDamageType() 

	-- Deal damage to each enemy hero
	for _,enemy in pairs(enemies_hit) do
		-- cant dmg ded stuff + cant dmg if ded
		if enemy:IsAlive() and not spirit:IsNull() then 
			local hit = false

			damage_table.victim = enemy

			if enemy:IsHero() then
				enemy:AddNewModifier(caster, ability, "modifier_imba_wisp_spirits_hero_hit", {duration = 0.03, slow_duration = slow_duration, slow = slow})
				if caster:HasModifier("modifier_imba_wisp_swap_spirits_disarm") then
					enemy:AddNewModifier(caster, ability, "modifier_disarmed", {duration=ability:GetSpecialValueFor("spirit_debuff_duration")})
				elseif caster:HasModifier("modifier_imba_wisp_swap_spirits_silence") then
					enemy:AddNewModifier(caster, ability, "modifier_silence", {duration=ability:GetSpecialValueFor("spirit_debuff_duration")})
				end

				hit_hero = true
				hit = true
			else
				if spirit.hit_table[enemy] == nil then
					spirit.hit_table[enemy] = true
					enemy:AddNewModifier(caster, ability, "modifier_imba_wisp_spirits_creep_hit", {duration = 0.03})
					damage_table.damage	= creep_damage
					hit = true
				end
			end

			if hit then
				ApplyDamage(damage_table)
			end
		end
	end

	if hit_hero then 
		spirit:RemoveModifierByName("modifier_imba_wisp_spirit_handler")
	end
end

function modifier_imba_wisp_spirit_handler:OnRemoved()
	if IsServer() then
		local spirit	= self:GetParent()
		local ability	= self:GetAbility()
		
		modifier_imba_wisp_spirits:Explode(self.caster, spirit, self.explosion_radius, self.explosion_damage, ability)
		
		if spirit.spirit_pfx_silence ~= nil then
			ParticleManager:DestroyParticle(spirit.spirit_pfx_silence, true)
		end
		
		if spirit.spirit_pfx_disarm ~= nil then
			ParticleManager:DestroyParticle(spirit.spirit_pfx_disarm, true)
		end

		-- Create vision
		ability:CreateVisibilityNode(spirit:GetAbsOrigin(), self.vision_radius, self.vision_duration)

		-- Kill
		spirit:ForceKill( true )
	end
end

--------------------------------------
--		SPIRITS	TOGGLE	Near/Far	--
--------------------------------------
imba_wisp_spirits_toggle = class({})

function imba_wisp_spirits_toggle:IsStealable() return false end

function imba_wisp_spirits_toggle:OnSpellStart()
	if IsServer() then
		
		-- Let's manually add Spirits for Morphling so they can use the skill properly (super bootleg)
		if not self:GetCaster():HasAbility("imba_wisp_spirits") then
			local stolenAbility = self:GetCaster():AddAbility("imba_wisp_spirits")
			stolenAbility:SetLevel(min((self:GetCaster():GetLevel() / 2) - 1, 4))
			self:GetCaster():SwapAbilities("imba_wisp_spirits_toggle", "imba_wisp_spirits", false, true)
		end
	
		local caster 					= self:GetCaster()
		local ability 					= caster:FindAbilityByName("imba_wisp_spirits")
		local spirits_movementFactor 	= ability.spirits_movementFactor

		if ability.spirits_movementFactor == 1 then
			ability.spirits_movementFactor = -1			
		else
			ability.spirits_movementFactor = 1
		end
	end
end

-- ugh
function imba_wisp_spirits_toggle:OnUnStolen()
	if self:GetCaster():HasAbility("imba_wisp_spirits") then
		self:GetCaster():RemoveAbility("imba_wisp_spirits")
	end
end

------------------------------------------
--		SPIRITS	Swap silence/disarm		--
------------------------------------------
LinkLuaModifier("modifier_imba_wisp_swap_spirits_disarm", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_swap_spirits_silence", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
imba_wisp_swap_spirits = class({})

function imba_wisp_swap_spirits:IsInnateAbility() return true end
function imba_wisp_swap_spirits:IsStealable() return false end

function imba_wisp_swap_spirits:GetIntrinsicModifierName()
	return "modifier_imba_wisp_swap_spirits_silence"
end

function imba_wisp_swap_spirits:GetIntrinsicModifierName()
	return "modifier_imba_wisp_swap_spirits_silence"
end


function imba_wisp_swap_spirits:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_wisp_swap_spirits_silence") then
		return "custom/kunnka_tide_high"
	elseif self:GetCaster():HasModifier("modifier_imba_wisp_swap_spirits_disarm") then
		return "custom/kunnka_tide_red"
	end
end

function imba_wisp_swap_spirits:OnSpellStart()
	if IsServer() then
		local caster 					= self:GetCaster()
		local ability 					= caster:FindAbilityByName("imba_wisp_spirits")
		--local spirits_movementFactor 	= ability.spirits_movementFactor
		local particle 					= nil
		local silence 					= false
		local disarm 					= false
		
		if not self.particles then
			self.particles = {}
		end
		
		if caster:HasModifier("modifier_imba_wisp_swap_spirits_disarm") then
			caster:RemoveModifierByName("modifier_imba_wisp_swap_spirits_disarm")
			caster:AddNewModifier(self:GetCaster(), self, "modifier_imba_wisp_swap_spirits_silence", {})
		elseif caster:HasModifier("modifier_imba_wisp_swap_spirits_silence") then
			caster:RemoveModifierByName("modifier_imba_wisp_swap_spirits_silence")
			caster:AddNewModifier(self:GetCaster(), self, "modifier_imba_wisp_swap_spirits_disarm", {})
		end

		if caster:HasModifier("modifier_imba_wisp_swap_spirits_silence") then
			particle = "particles/units/heroes/hero_wisp/wisp_guardian_silence_a.vpcf"
			silence  = true
			disarm 	 = false
		elseif caster:HasModifier("modifier_imba_wisp_swap_spirits_disarm") then
			particle = "particles/units/heroes/hero_wisp/wisp_guardian_disarm_a.vpcf"
			silence  = false
			disarm 	 = true
		end
	
		if ability.spirits_spiritsSpawned then
			for k,spirit in pairs( ability.spirits_spiritsSpawned ) do
				if not spirit:IsNull() then					
					if self.particles[k] then
						ParticleManager:DestroyParticle(self.particles[k], false)
						ParticleManager:ReleaseParticleIndex(self.particles[k])
					end
					
					self.particles[k] = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, spirit)
					if silence then
						spirit.spirit_pfx_silence = self.particles[k]
					elseif disarm then
						spirit.spirit_pfx_disarm = self.particles[k]
					end
				end
			end
		end
	end 
end

modifier_imba_wisp_swap_spirits_disarm = class({})

function modifier_imba_wisp_swap_spirits_disarm:IsHidden() return true end
function modifier_imba_wisp_swap_spirits_disarm:IsPurgable() return false end
function modifier_imba_wisp_swap_spirits_disarm:RemoveOnDeath() return false end

modifier_imba_wisp_swap_spirits_silence = class({})

function modifier_imba_wisp_swap_spirits_silence:IsHidden() return true end
function modifier_imba_wisp_swap_spirits_silence:IsPurgable() return false end
function modifier_imba_wisp_swap_spirits_silence:RemoveOnDeath() return false end


------------------------------
--		OVERCHARGE		--
------------------------------
imba_wisp_overcharge = class({})
LinkLuaModifier("modifier_imba_wisp_overcharge", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_overcharge_drain", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_overcharge_regen_talent", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_overcharge_aura", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)

function imba_wisp_overcharge:IsNetherWardStealable()
	return false
end

function imba_wisp_overcharge:AddOvercharge(caster, target, efficiency, overcharge_duration)
		local ability 			= caster:FindAbilityByName("imba_wisp_overcharge")
		local tether_ability 	= caster:FindAbilityByName("imba_wisp_tether")

		local bonus_attack_speed	= ability:GetSpecialValueFor("bonus_attack_speed")
		local bonus_cast_speed		= ability:GetSpecialValueFor("bonus_cast_speed")
		local bonus_missile_speed 	= ability:GetSpecialValueFor("bonus_missile_speed")
		local bonus_damage_pct 		= ability:GetSpecialValueFor("bonus_damage_pct")
		local bonus_attack_range 	= ability:GetSpecialValueFor("bonus_attack_range")

		if caster:HasTalent("special_bonus_imba_wisp_1") then 
			local bonus_effect 		= caster:FindTalentValue("special_bonus_imba_wisp_1", "bonus_effect")
			bonus_attack_speed 		= bonus_attack_speed + bonus_effect
			bonus_cast_speed 		= bonus_cast_speed + bonus_effect
			bonus_missile_speed 	= bonus_missile_speed + bonus_effect
			bonus_attack_range 		= bonus_attack_range + bonus_effect
		end

		if caster:HasTalent("special_bonus_imba_wisp_4") then 
			local damage_reduction 		= caster:FindTalentValue("special_bonus_imba_wisp_4", "damage_reduction")
			bonus_damage_pct 			= bonus_damage_pct - damage_reduction
		end

		if caster:HasTalent("special_bonus_imba_wisp_8") and efficiency == 1.0 then 
			local bonus_regen 				= caster:FindTalentValue("special_bonus_imba_wisp_8", "bonus_regen")
			local overcharge_regen 			= caster:AddNewModifier(caster, ability, "modifier_imba_wisp_overcharge_regen_talent", {})
			overcharge_regen:SetStackCount(bonus_regen)
		end

		if efficiency ~= nil and efficiency < 1.0 then
			bonus_attack_speed 		= bonus_attack_speed * efficiency
			bonus_cast_speed 		= bonus_cast_speed * efficiency
			bonus_missile_speed 	= bonus_missile_speed * efficiency
			bonus_attack_range 		= bonus_attack_range * efficiency
			bonus_damage_pct 		= bonus_damage_pct * efficiency
		end

		-- set stats for client
		CustomNetTables:SetTableValue(
			"player_table", 
			tostring(caster:GetPlayerOwnerID()), 
			{ 	
				overcharge_bonus_attack_speed 	= bonus_attack_speed,
				overcharge_bonus_cast_speed 	= bonus_cast_speed,
				overcharge_bonus_missile_speed 	= bonus_missile_speed,
				overcharge_bonus_damage_pct 	= bonus_damage_pct,
				overcharge_bonus_attack_range 	= bonus_attack_range,
			})

		target:AddNewModifier(
				caster, 
				ability, 
				"modifier_imba_wisp_overcharge", 
				{
					duration 				= overcharge_duration,
					bonus_attack_speed 		= bonus_attack_speed,
					bonus_cast_speed 		= bonus_cast_speed,
					bonus_missile_speed 	= bonus_missile_speed,
					bonus_damage_pct 		= bonus_damage_pct,
					bonus_attack_range 		= bonus_attack_range,
				})
end

function imba_wisp_overcharge:OnToggle()
	if IsServer() then 
		local caster 			= self:GetCaster()
		local ability 			= caster:FindAbilityByName("imba_wisp_overcharge")
		local tether_ability 	= caster:FindAbilityByName("imba_wisp_tether")

		if ability:GetToggleState() then

			EmitSoundOn("Hero_Wisp.Overcharge", caster)

			local drain_interval 		= ability:GetSpecialValueFor("drain_interval")
			local drain_pct 			= ability:GetSpecialValueFor("drain_pct")

			imba_wisp_overcharge:AddOvercharge(caster, caster, 1.0, -1)

			if caster:HasModifier("modifier_imba_wisp_tether") then
				if tether_ability.target:HasModifier("modifier_imba_wisp_overcharge") then 
					tether_ability.target:RemoveModifierByName("modifier_imba_wisp_overcharge")
				end

				imba_wisp_overcharge:AddOvercharge(caster, tether_ability.target, 1.0, -1)
			end

			if caster:HasScepter() then 
				caster:AddNewModifier(caster, ability, "modifier_imba_wisp_overcharge_aura", {})
			end

			drain_pct = drain_pct / 100
			caster:AddNewModifier( caster, ability, "modifier_imba_wisp_overcharge_drain", { duration = -1, drain_interval = drain_interval, drain_pct = drain_pct })			
		else
			caster:StopSound("Hero_Wisp.Overcharge")
			caster:RemoveModifierByName("modifier_imba_wisp_overcharge")
			caster:RemoveModifierByName("modifier_imba_wisp_overcharge_drain")
			caster:RemoveModifierByName("modifier_imba_wisp_overcharge_regen_talent")
			caster:RemoveModifierByName("modifier_imba_wisp_overcharge_aura")

			if caster:HasModifier("modifier_imba_wisp_tether") then
				tether_ability.target:RemoveModifierByName("modifier_imba_wisp_overcharge")
				tether_ability.target:RemoveModifierByName("modifier_imba_wisp_overcharge_regen_talent")
			end
		end
	end
end


----------------------------------
--	Overchargge Aura modifier	--
----------------------------------
modifier_imba_wisp_overcharge_aura = class({})
function modifier_imba_wisp_overcharge_aura:IsHidden() return false end
function modifier_imba_wisp_overcharge_aura:IsPurgable() return false end
function modifier_imba_wisp_overcharge_aura:IsNetherWardStealable()
	return false
end
function modifier_imba_wisp_overcharge_aura:OnCreated()
	if IsServer() then 
		self.ability 				= self:GetAbility()
		self.tether_ability 		= self:GetCaster():FindAbilityByName("imba_wisp_tether")
		self.scepter_radius			= self.ability:GetSpecialValueFor("scepter_radius")
		self.scepter_efficiency		= self.ability:GetSpecialValueFor("scepter_efficiency")

		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_wisp_overcharge_aura:OnIntervalThink()
	if IsServer() then 
		local caster = self:GetCaster()
		local nearby_friendly_units = FindUnitsInRadius(	
				caster:GetTeam(), 
				caster:GetAbsOrigin(), 
				nil, 
				self.scepter_radius, 
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
				DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, 
				FIND_ANY_ORDER, 
				false)

		for _,unit in pairs(nearby_friendly_units) do
			if unit ~= caster and unit ~= self.tether_ability.target and unit ~= "npc_dota_hero" then 
				imba_wisp_overcharge:AddOvercharge(caster, unit, self.scepter_efficiency, 1)
			end
		end
	end
end

----------------------------------
--	Overchargge buff modifier	--
----------------------------------
modifier_imba_wisp_overcharge = class({})
function modifier_imba_wisp_overcharge:IsBuff() return true end
function modifier_imba_wisp_overcharge:IsPurgable() return false end
function modifier_imba_wisp_overcharge:IsNetherWardStealable() return false end
function modifier_imba_wisp_overcharge:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
	return funcs
end

function modifier_imba_wisp_overcharge:OnCreated(params)
	if IsServer() then
		self.overcharge_pfx 		= ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_overcharge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self.bonus_attack_speed 	= params.bonus_attack_speed
		self.bonus_cast_speed 		= params.bonus_cast_speed
		self.bonus_missile_speed 	= params.bonus_missile_speed
		self.bonus_damage_pct 		= params.bonus_damage_pct
		self.bonus_attack_range 	= params.bonus_attack_range
	else
		local net_table 			= CustomNetTables:GetTableValue("player_table", tostring(self:GetCaster():GetPlayerOwnerID())) or {}
		self.bonus_attack_speed 	= net_table.overcharge_bonus_attack_speed or 0
		self.bonus_cast_speed 		= net_table.overcharge_bonus_cast_speed or 0
		self.bonus_missile_speed	= net_table.overcharge_bonus_missile_speed or 0
		self.bonus_damage_pct		= net_table.overcharge_bonus_damage_pct or 0
		self.bonus_attack_range 	= net_table.overcharge_bonus_attack_range or 0
	end
end

function modifier_imba_wisp_overcharge:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.overcharge_pfx, false)
		if not self:GetCaster():HasModifier("modifier_imba_wisp_overcharge") then
			self:GetCaster():RemoveModifierByName("modifier_imba_wisp_overcharge_drain")
		end
	end
end

function modifier_imba_wisp_overcharge:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_imba_wisp_overcharge:GetModifierPercentageCasttime()
	return self.bonus_cast_speed
end

function modifier_imba_wisp_overcharge:GetModifierProjectileSpeedBonus()
	return self.bonus_missile_speed
end

function modifier_imba_wisp_overcharge:GetModifierIncomingDamage_Percentage()
	return self.bonus_damage_pct
end

function modifier_imba_wisp_overcharge:GetModifierAttackRangeBonus()
	return self.bonus_attack_range
end

----------------------------------------------
--	Overchargge health/mana-drain modifier	--
----------------------------------------------
modifier_imba_wisp_overcharge_drain = class({})
function modifier_imba_wisp_overcharge_drain:IsHidden() return true end
function modifier_imba_wisp_overcharge_drain:IsPurgable() return false end
function modifier_imba_wisp_overcharge_drain:OnCreated(params)
	if IsServer() then
		self.caster 		= self:GetCaster()
		self.ability 		= self:GetAbility()
		self.drain_pct 		= params.drain_pct
		self.drain_interval = params.drain_interval
		self.deltaDrainPct	= self.drain_interval * self.drain_pct
		self:StartIntervalThink(self.drain_interval)
	end
end

function modifier_imba_wisp_overcharge_drain:OnIntervalThink()
	-- hp removal instead of self dmg... this wont break urn or salve
	local current_health 	= self.caster:GetHealth() 
	local health_drain 		= current_health * self.deltaDrainPct
	self.caster:ModifyHealth(current_health - health_drain, self.ability, true, 0)

	self.caster:SpendMana(self.caster:GetMana() * self.deltaDrainPct, self.ability)
end

------------------------------
--	Overcharge Talent	    --
------------------------------
modifier_imba_wisp_overcharge_regen_talent = class({})
function modifier_imba_wisp_overcharge_regen_talent:IsHidden() return true end
function modifier_imba_wisp_overcharge_regen_talent:IsPurgable() return false end
function modifier_imba_wisp_overcharge_regen_talent:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
	}

	return decFuncs
end

function modifier_imba_wisp_overcharge_regen_talent:GetModifierTotalPercentageManaRegen()
	return self:GetStackCount()
end

------------------------------
--			RELOCATE		--
------------------------------
imba_wisp_relocate = class({})
LinkLuaModifier("modifier_imba_wisp_relocate", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_relocate_cast_delay", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_relocate_talent", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
function imba_wisp_relocate:GetBehavior()
	if IsServer() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT
	else
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET
	end
end

function imba_wisp_relocate:OnSpellStart()
	if IsServer() then
		local unit 					= self:GetCursorTarget()
		local caster 				= self:GetCaster()
		local ability 				= caster:FindAbilityByName("imba_wisp_relocate")
		local tether_ability 		= caster:FindAbilityByName("imba_wisp_tether")
		local target_point 			= self:GetCursorPosition()
		local vision_radius 		= ability:GetSpecialValueFor("vision_radius")
		local cast_delay 			= ability:GetSpecialValueFor("cast_delay")
		local return_time 			= ability:GetSpecialValueFor("return_time")
		local destroy_tree_radius	= ability:GetSpecialValueFor("destroy_tree_radius")
	
		EmitSoundOn("Hero_Wisp.Relocate", self:GetCaster())
	
		if unit == caster then
			if caster:GetTeam() == DOTA_TEAM_GOODGUYS then
				-- radiant fountain location
				target_point = Vector(-7168, -6646, 528)
			else
				-- dire fountain location
				target_point = Vector(7037, 6458, 512)
			end
		end

		-- remember where too return
		ability.relocate_target_point = target_point

		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_marker_endpoint.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, target_point)

		-- Store the particle ID
		ability.relocate_endpointPfx = pfx

		-- Create vision
		ability:CreateVisibilityNode(target_point, vision_radius, cast_delay)

		if caster:HasTalent("special_bonus_imba_wisp_7") then 
			local immunity_duration = caster:FindTalentValue("special_bonus_imba_wisp_7", "duration")
			caster:AddNewModifier(caster, self, "modifier_imba_wisp_relocate_talent", {duration = immunity_duration})
			if tether_ability.target ~= nil then 
				tether_ability.target:AddNewModifier(caster, self, "modifier_imba_wisp_relocate_talent", {duration = immunity_duration})
			end
		end

		caster:AddNewModifier(caster, ability, "modifier_imba_wisp_relocate_cast_delay", {duration = cast_delay})

		Timers:CreateTimer({
			endTime = cast_delay,
			callback = function()
				ParticleManager:DestroyParticle(pfx, false)
				if not imba_wisp_relocate:InterruptRelocate(caster, ability, tether_ability) then
					EmitSoundOn("Hero_Wisp.Return", self:GetCaster())
					
					GridNav:DestroyTreesAroundPoint(target_point, destroy_tree_radius, false)

					-- Here we go again (Rubick)
					if not caster:HasAbility("imba_wisp_relocate_break") then
						caster:AddAbility("imba_wisp_relocate_break")
					end
					
					caster:SwapAbilities("imba_wisp_relocate", "imba_wisp_relocate_break", false, true)
					local break_ability = caster:FindAbilityByName("imba_wisp_relocate_break")
					break_ability:SetLevel(1)
				
					ability.origin = caster:GetAbsOrigin()

					if caster:HasModifier("modifier_imba_wisp_tether") and tether_ability.target:IsHero() then
						ability.ally_origin = tether_ability.target:GetAbsOrigin()
						ability.ally 		= tether_ability.target 
					else
						ability.ally_origin = nil
						ability.ally 		= nil
					end

					caster:AddNewModifier( caster, ability, "modifier_imba_wisp_relocate", { duration = return_time, return_time = return_time })
				end
			end
		})
	end
end

function imba_wisp_relocate:InterruptRelocate(caster, ability, tether_ability)
	if not caster:IsAlive() or caster:IsStunned() or caster:IsHexed() or caster:IsNightmared() or caster:IsOutOfGame() then
		return true
	end

	return false
end

-- Remove Relocate Break for Rubick when skill is lost
function imba_wisp_relocate:OnUnStolen()
	if self:GetCaster():HasAbility("imba_wisp_relocate_break") then
		self:GetCaster():RemoveAbility("imba_wisp_relocate_break")
	end
end

----------------------
--	Relocate timer	--
----------------------
modifier_imba_wisp_relocate_cast_delay = class({})


--------------------------
--	Relocate modifier	--
--------------------------
modifier_imba_wisp_relocate = class({})
function modifier_imba_wisp_relocate:IsDebuff() return false end
function modifier_imba_wisp_relocate:IsHidden() return true end
function modifier_imba_wisp_relocate:IsPurgable() return false end
function modifier_imba_wisp_relocate:IsStunDebuff() return false end
function modifier_imba_wisp_relocate:IsPurgeException() return false end
function modifier_imba_wisp_relocate:OnCreated(params)
	if IsServer() then
		local caster 		= self:GetCaster()
		local ability 		= self:GetAbility()
		local ally 			= ability.ally

		self.return_time	= params.return_time

		-- Create marker at origin
		self.caster_origin_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_marker.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(self.caster_origin_pfx, 0, caster:GetAbsOrigin())

		-- Add teleport effect
		self.caster_teleport_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_teleport.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(self.caster_teleport_pfx, 0, caster, PATTACH_POINT, "attach_hitloc", caster:GetAbsOrigin(), true)

		-- Move units
		FindClearSpaceForUnit(caster, ability.relocate_target_point, true)

		if caster:HasModifier("modifier_imba_wisp_tether") and ally ~= nil and ally:IsHero() then
			self.ally_teleport_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_teleport.vpcf", PATTACH_CUSTOMORIGIN, ally)
			ParticleManager:SetParticleControlEnt(self.ally_teleport_pfx, 0, ally, PATTACH_POINT, "attach_hitloc", ally:GetAbsOrigin(), true)
			FindClearSpaceForUnit(ally, ability.relocate_target_point + Vector( 0, 100, 0 ), true)
		end

		self.relocate_timerPfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		local timerCP1_x = self.return_time >= 10 and 1 or 0			
		local timerCP1_y = self.return_time % 10
		ParticleManager:SetParticleControl(self.relocate_timerPfx, 1, Vector( timerCP1_x, timerCP1_y, 0 ) )

		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_wisp_relocate:OnIntervalThink()
	self.return_time = self.return_time - 1
	local timerCP1_x = self.return_time >= 10 and 1 or 0
	local timerCP1_y = self.return_time % 10
	ParticleManager:SetParticleControl(self.relocate_timerPfx, 1, Vector( timerCP1_x, timerCP1_y, 0 ) )
end

function modifier_imba_wisp_relocate:OnRemoved()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility();

		EmitSoundOn("Hero_Wisp.Return", self:GetCaster())
		
		-- Add teleport effect
		self.caster_teleport_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_teleport.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(self.caster_teleport_pfx, 0, caster, PATTACH_POINT, "attach_hitloc", caster:GetAbsOrigin(), true)

		-- remove origin marker + delay timer
		ParticleManager:DestroyParticle(self.relocate_timerPfx, false)
		ParticleManager:DestroyParticle(self.caster_origin_pfx, false)

		self:GetCaster():SetAbsOrigin(ability.origin)

		local tether_ability 	= caster:FindAbilityByName("imba_wisp_tether")
		if caster:HasModifier("modifier_imba_wisp_tether") and tether_ability.target ~= nil and tether_ability.target:IsHero() and caster:IsAlive() then
			self.ally_teleport_pfx 	= ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_teleport.vpcf", PATTACH_CUSTOMORIGIN, tether_ability.target)
			ParticleManager:SetParticleControlEnt(self.ally_teleport_pfx, 0, tether_ability.target, PATTACH_POINT, "attach_hitloc", tether_ability.target:GetAbsOrigin(), true)

			if ability.ally_origin == nil then
				ability.ally_origin = ability.origin + Vector( 0, 100, 0 ) 
			end
			tether_ability.target:SetAbsOrigin(ability.ally_origin)
		end

		caster:SwapAbilities("imba_wisp_relocate_break", "imba_wisp_relocate", false, true)
	end
end

modifier_imba_wisp_relocate_talent = class({})
function modifier_imba_wisp_relocate_talent:IsDebuff() return false end
function modifier_imba_wisp_relocate_talent:IsHidden() return false end
function modifier_imba_wisp_relocate_talent:IsPurgable() return false end
function modifier_imba_wisp_relocate_talent:IsStunDebuff() return false end
function modifier_imba_wisp_relocate_talent:IsPurgeException() return false end
function modifier_imba_wisp_relocate_talent:RemoveOnDeath() return true end
function modifier_imba_wisp_relocate_talent:CheckState()
	local state = {[MODIFIER_STATE_MAGIC_IMMUNE] = true}
	return state
end

function modifier_imba_wisp_relocate_talent:GetEffectName()
	return "particles/item/black_queen_cape/black_king_bar_avatar.vpcf"
end

function modifier_imba_wisp_relocate_talent:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


------------------------------
--		RELOCATE BREAK		--
------------------------------
imba_wisp_relocate_break = class({})

function imba_wisp_relocate_break:IsStealable() return false end

function imba_wisp_relocate_break:OnSpellStart() 
	if IsServer() then
		local caster = self:GetCaster()
		caster:RemoveModifierByName("modifier_imba_wisp_relocate")
	end
end
