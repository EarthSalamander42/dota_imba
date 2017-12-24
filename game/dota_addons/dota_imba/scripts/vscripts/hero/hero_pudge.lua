
CreateEmptyTalents("pudge")
--[[
-------------------------------------------
--                Flesh Heap
-------------------------------------------
LinkLuaModifier("modifier_flesh_heap", "hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_flesh_heap_return_timer", "hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)

imba_pudge_flesh_heap = class({})
function imba_pudge_flesh_heap:IsHiddenWhenStolen() return true end
function imba_pudge_flesh_heap:IsRefreshable() return false end
function imba_pudge_flesh_heap:IsStealable() return false end
function imba_pudge_flesh_heap:IsNetherWardStealable() return false end
function imba_pudge_flesh_heap:IsInnateAbility() return true end

function imba_pudge_flesh_heap:GetAbilityTextureName()
   return "pudge_flesh_heap"
end
-------------------------------------------

function imba_pudge_flesh_heap:GetIntrinsicModifierName()
	return "modifier_flesh_heap"
end
-------------------------------------------
modifier_flesh_heap_return_timer = class({})
function modifier_flesh_heap_return_timer:IsDebuff() return true end
function modifier_flesh_heap_return_timer:IsHidden() return not IsInToolsMode() end
function modifier_flesh_heap_return_timer:IsPurgable() return false end
function modifier_flesh_heap_return_timer:IsPurgeException() return false end
function modifier_flesh_heap_return_timer:IsStunDebuff() return false end
function modifier_flesh_heap_return_timer:RemoveOnDeath() return true end
function modifier_flesh_heap_return_timer:AllowIllusionDuplicate() return false end
-------------------------------------------
function modifier_flesh_heap_return_timer:GetAttributes()
	return {MODIFIER_ATTRIBUTE_MULTIPLE}
end

function modifier_flesh_heap_return_timer:OnCreated()
 if IsServer() then
 	local modifier = self:GetParent():FindModifierByName(self:GetAbility():GetIntrinsicModifierName())
 	for i=0, self:GetParent():FindTalentValue("special_bonus_imba_pudge_2","stacks_needed")-1 do
 		modifier:DecrementStackCount()
 	end
 end
end

function modifier_flesh_heap_return_timer:OnDestroy()
	if IsServer() then
	 	local modifier = self:GetParent():FindModifierByName(self:GetAbility():GetIntrinsicModifierName())
	 	for i=0, self:GetParent():FindTalentValue("special_bonus_imba_pudge_2","stacks_needed")-1 do
	 		modifier:IncrementStackCount()
	 	end
  end
end
-------------------------------------------
modifier_flesh_heap = class({})
function modifier_flesh_heap:IsDebuff() return false end
function modifier_flesh_heap:IsHidden() return false end
function modifier_flesh_heap:IsPurgable() return false end
function modifier_flesh_heap:IsPurgeException() return false end
function modifier_flesh_heap:IsStunDebuff() return false end
function modifier_flesh_heap:RemoveOnDeath() return false end
function modifier_flesh_heap:AllowIllusionDuplicate() return true end
-------------------------------------------

function modifier_flesh_heap:OnCreated()
	if IsServer() then
		-- Set stack count for illusions
		local id = self:GetCaster():GetPlayerOwnerID()
		local hero = PlayerResource:GetSelectedHeroEntity(id)

		if hero and not hero.nKills then 
			hero.nKills = 0 
		end

		if hero then
			self:SetStackCount(hero.nKills)
		end
	end
end


function modifier_flesh_heap:DeclareFunctions()
		local decFuns =
		{
			MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_MODEL_SCALE,
			MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,  

			MODIFIER_EVENT_ON_DEATH,
				
		}
		return decFuns
end

function modifier_flesh_heap:GetModifierSpellLifesteal()
	local mult = self:GetCaster():FindTalentValue("special_bonus_imba_pudge_3") or 0
	return self:GetStackCount() * mult 
end

function modifier_flesh_heap:GetModifierMagicalResistanceBonus()
	if self:GetParent():PassivesDisabled() then return end
	local resist = self:GetAbility():GetSpecialValueFor("base_magic_resist")
	local stack_resist = self:GetAbility():GetSpecialValueFor("stack_magic_resistance") * self:GetStackCount()
	stack_resist = math.min(stack_resist, self:GetAbility():GetSpecialValueFor("max_stack_resist"))
	resist =  resist + stack_resist
	return resist
end

function modifier_flesh_heap:GetModifierBonusStats_Strength()
	if self:GetParent():PassivesDisabled() then return end
	local str = self:GetAbility():GetSpecialValueFor("stack_str")
	return self:GetStackCount() * str
end

function modifier_flesh_heap:GetModifierModelScale()
	if self:GetParent():PassivesDisabled() then return end
	local size = 1 + (self:GetAbility():GetSpecialValueFor("stack_scale_up") * self:GetStackCount())
	if size > self:GetAbility():GetSpecialValueFor("max_size") then
		size = self:GetAbility():GetSpecialValueFor("max_size")
	end
	return size
end

function modifier_flesh_heap:GetModifierTotal_ConstantBlock(keys)
	if not IsServer() then return end
	if keys.target ~= self:GetCaster() then return 0 end
	if keys.attacker == self:GetCaster() then return 0 end
	if self:GetParent():PassivesDisabled() then return 0 end
	if not self:GetParent():IsRealHero() then return 0 end

	-- Only attacks?
	if keys.inflictor then return 0 end

	if self:GetStackCount() < self:GetParent():FindTalentValue("special_bonus_imba_pudge_2","stacks_needed") then return 0 end

	local damage = keys.damage
	if damage <= self:GetParent():FindTalentValue("special_bonus_imba_pudge_2","min_damage") then return 0 end
	local max_damage = self:GetParent():FindTalentValue("special_bonus_imba_pudge_2","damage_block")
	if damage > max_damage then
		damage = max_damage
	end
	self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_flesh_heap_return_timer",{duration=self:GetParent():FindTalentValue("special_bonus_imba_pudge_2","return_time")})
	return damage
end


function modifier_flesh_heap:OnDeath(keys)
	-- All these cases shouldn't do anything.
	if not IsServer() then return end
	if not keys.unit or not keys.attacker then return end
	if not keys.unit:IsRealHero() then return end
	if keys.reincarnate then return end
	if self:GetParent():IsIllusion() then return end
	-- Break
	if self:GetParent():PassivesDisabled() then return end
	-----------------------------------------------------------------------------

	local hKiller = keys.attacker
	local hVictim = keys.unit

	if self:GetCaster():GetTeamNumber() ~= hVictim:GetTeamNumber() then
		self.fleshHeapRange = self:GetAbility():GetSpecialValueFor("range")
		local vToCaster = self:GetCaster():GetOrigin() - hVictim:GetOrigin()
		local flDistance = vToCaster:Length2D() - (self:GetCaster():GetCollisionPadding() + hVictim:GetCollisionPadding())
		if hKiller == self:GetCaster() or self.fleshHeapRange >= flDistance then

			--self:GetCaster().nKills = self:GetCaster().nKills + 1
			local hBuff = self:GetCaster():FindModifierByName("modifier_flesh_heap")
			if hBuff ~= nil then
				hBuff:IncrementStackCount()
				self:GetCaster():CalculateStatBonus()
			else
				self:GetCaster():AddNewModifier(self:GetCaster(), self,  "modifier_flesh_heap" , {})
			end
			if hKiller == self:GetCaster() then
				hBuff:IncrementStackCount()
			end
			local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
			ParticleManager:SetParticleControl(nFXIndex, 1, Vector(1, 0, 0))
			ParticleManager:ReleaseParticleIndex(nFXIndex)

		end
	end
end
-------------------------------------------

-------------------------------------------
--                Rot
-------------------------------------------
LinkLuaModifier("modifier_rot", "hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cleaver_rot", "hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)

imba_pudge_rot = class({})
function imba_pudge_rot:IsHiddenWhenStolen() return false end
function imba_pudge_rot:IsRefreshable() return false end
function imba_pudge_rot:IsStealable() return true end
function imba_pudge_rot:IsNetherWardStealable() return false end
function imba_pudge_rot:ProcsMagicStick() return false end
function imba_pudge_rot:ResetToggleOnRespawn() return true end

function imba_pudge_rot:GetAbilityTextureName()
   return "pudge_rot"
end
-------------------------------------------
function imba_pudge_rot:GetCastRange()
	self.rot_radius = self:GetSpecialValueFor("base_radius")
	if self:GetCaster():HasModifier("modifier_flesh_heap") then 
		local heap_stack_increase = self:GetCaster():GetModifierStackCount("modifier_flesh_heap",self:GetCaster()) * self:GetSpecialValueFor("stack_radius")
		if heap_stack_increase > self:GetSpecialValueFor("max_radius_tooltip") then
			heap_stack_increase = self:GetSpecialValueFor("base_radius")
		end
		self.rot_radius = self.rot_radius + heap_stack_increase
	end
	return self.rot_radius
end

function imba_pudge_rot:OnToggle()
	-- Apply the rot modifier if the toggle is on
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_rot", {})

		if not self:GetCaster():IsChanneling() then
			self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_ROT)
		end
	else
		-- Remove it if it is off
		local hRotBuff = self:GetCaster():FindModifierByName("modifier_rot")
		if hRotBuff ~= nil then
			hRotBuff:Destroy()
		end
	end
end

-------------------------------------------
modifier_rot = modifier_rot or class({})
function modifier_rot:IsDebuff() return true end
function modifier_rot:IsHidden() return false end
function modifier_rot:IsPurgable() return false end
function modifier_rot:IsPurgeException() return false end
function modifier_rot:IsStunDebuff() return false end
function modifier_rot:RemoveOnDeath() return true end
-------------------------------------------
function modifier_rot:IsAura()
	if self:GetCaster() == self:GetParent() or self:GetParent().butcher_cleaver_target then
		return true
	end
	
	return false
end

function modifier_rot:GetModifierAura()
	return "modifier_rot"
end

--------------------------------------------------------------------------------

function modifier_rot:GetAuraSearchTeam()
	if self:GetCaster() == self:GetParent() then
		return DOTA_UNIT_TARGET_TEAM_ENEMY
	end

	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_rot:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------

function modifier_rot:GetAuraRadius()
	return self.rot_radius
end


function modifier_rot:DeclareFunctions()
	local decFuns =
	{
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return decFuns
end

function modifier_rot:GetModifierMoveSpeedBonus_Percentage()
	if self:GetParent() == self:GetCaster() then
		return 0
	end

	return self.rot_slow
end


function modifier_rot:OnCreated(kv)
	local caster = self:GetCaster()
	self.rot_slow = self:GetAbility():GetSpecialValueFor("rot_slow") 
	self.rot_damage = self:GetAbility():GetSpecialValueFor("rot_damage")

	self.rot_tick = self:GetAbility():GetSpecialValueFor("rot_tick")

	if IsServer() then
		self.rot_radius = self:GetAbility():GetCastRange()
		if self:GetParent() == self:GetCaster()then
			EmitSoundOn("Hero_Pudge.Rot", self:GetCaster())
			local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self.rot_radius, 1, self.rot_radius))
			self:AddParticle(nFXIndex, false, false, -1, false, false)

		elseif self:GetParent().butcher_cleaver_target then
			local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self.rot_radius, 1, self.rot_radius))
			self:AddParticle(nFXIndex, false, false, -1, false, false)
		else		
			local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			self:AddParticle(nFXIndex, false, false, -1, false, false)
		end

		self:StartIntervalThink(self.rot_tick)
	end
end

function modifier_rot:OnIntervalThink()
	if IsServer() then
		if self:GetCaster():FindTalentValue("special_bonus_imba_pudge_1","damage") ~= 0 then
			self.rot_real_damage = self.rot_damage + (self:GetCaster():FindTalentValue("special_bonus_imba_pudge_1","damage") * (((100-self:GetCaster():GetHealthPercent())/100) / self:GetCaster():FindTalentValue("special_bonus_imba_pudge_1","hp_treshhold_percent")))
		else
			self.rot_real_damage = self.rot_damage
		end
		local flDamagePerTick = self.rot_tick * self.rot_real_damage		

		if self:GetCaster():IsAlive() then
			local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = flDamagePerTick,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}

			ApplyDamage(damage)
		end
	end
end

function modifier_rot:OnDestroy()
	if IsServer() then
		StopSoundOn( "Hero_Pudge.Rot", self:GetCaster() )

		if self:GetParent().butcher_cleaver_target then
			self:GetParent().butcher_cleaver_target = nil
		end
	end
end





modifier_cleaver_rot = modifier_cleaver_rot or class({})
function modifier_cleaver_rot:IsDebuff() return true end
function modifier_cleaver_rot:IsHidden() return false end
function modifier_cleaver_rot:IsPurgable() return false end
function modifier_cleaver_rot:IsPurgeException() return false end
function modifier_cleaver_rot:IsStunDebuff() return false end
function modifier_cleaver_rot:RemoveOnDeath() return true end
-------------------------------------------
function modifier_cleaver_rot:IsAura()
	if self:GetParent().butcher_cleaver_target then
		return true
	end
	
	return false
end

function modifier_cleaver_rot:GetModifierAura()
	return "modifier_cleaver_rot"
end

--------------------------------------------------------------------------------

function modifier_cleaver_rot:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_cleaver_rot:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------

function modifier_cleaver_rot:GetAuraRadius()
	return self.rot_radius
end


function modifier_cleaver_rot:DeclareFunctions()
	local decFuns =
	{
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return decFuns
end

function modifier_cleaver_rot:GetModifierMoveSpeedBonus_Percentage()
	return self.rot_slow
end


function modifier_cleaver_rot:OnCreated(kv)
	self.rot_slow = self:GetAbility():GetSpecialValueFor("rot_slow")
	self.rot_damage = self:GetAbility():GetSpecialValueFor("rot_damage")

	-- #6 Talent: Rot deals increased damage per tick
	self.rot_damage = self.rot_damage + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_6")
	self.rot_tick = self:GetAbility():GetSpecialValueFor("rot_tick")

	if IsServer() then
		self.rot_radius = self:GetAbility():GetCastRange()		

		if self:GetParent().butcher_cleaver_target then
			local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self.rot_radius, 1, self.rot_radius))
			self:AddParticle(nFXIndex, false, false, -1, false, false)
		else		
			local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			self:AddParticle(nFXIndex, false, false, -1, false, false)
		end

		self:StartIntervalThink(self.rot_tick)
	end
end

function modifier_cleaver_rot:OnIntervalThink()
	if IsServer() then
		local flDamagePerTick = self.rot_tick * self.rot_damage		

		if self:GetCaster():IsAlive() then
			local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = flDamagePerTick,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}

			ApplyDamage(damage)
		end
	end
end

function modifier_cleaver_rot:OnDestroy()
	if IsServer() then
		if self:GetParent().butcher_cleaver_target then
			self:GetParent().butcher_cleaver_target = nil
		end
	end
end
-------------------------------------------

--                Meat Hook
-------------------------------------------
LinkLuaModifier("modifier_meat_hook", "hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_meat_hook_followthrough", "hero/hero_pudge" ,LUA_MODIFIER_MOTION_NONE )
imba_pudge_meat_hook = class({})
function imba_pudge_meat_hook:IsHiddenWhenStolen() return false end
function imba_pudge_meat_hook:IsRefreshable() return true end
function imba_pudge_meat_hook:IsStealable() return true end
function imba_pudge_meat_hook:IsNetherWardStealable() return true end
function imba_pudge_meat_hook:IsInnateAbility() return false end

function imba_pudge_meat_hook:GetAbilityTextureName()
   return "pudge_meat_hook"
end
-------------------------------------------
function imba_pudge_meat_hook:GetCastRange()
	return self:GetSpecialValueFor("hook_distance") + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_2")
end

function imba_pudge_meat_hook:GetCooldown()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("scepter_cooldown")
	else
		return self:GetSpecialValueFor("cooldown")
	end
end
--------------------------------------------------------------------------------

function imba_pudge_meat_hook:OnAbilityPhaseStart()
	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
	return true
end

--------------------------------------------------------------------------------

function imba_pudge_meat_hook:OnAbilityPhaseInterrupted()
	self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
end

--------------------------------------------------------------------------------

function imba_pudge_meat_hook:OnSpellStart()
	self.bChainAttached = false	
	self.hooks = self.hooks or {}
	self.targets = {}
	self.treeTargets = {}
	self.max_targets = self:GetSpecialValueFor( "max_targets" )  
	self.hook_damage = self:GetSpecialValueFor( "hook_damage" )
	self.hook_stackdamage = math.min(self:GetCaster():GetModifierStackCount("modifier_flesh_heap",self:GetCaster()) * self:GetSpecialValueFor("stack_bonus_damage"),self:GetSpecialValueFor("stack_max_bonus_damage"))  
	self.hook_damage = self.hook_damage + self.hook_stackdamage
	self.hook_speed = self:GetSpecialValueFor( "hook_speed" )
	self.hook_width = self:GetSpecialValueFor( "hook_width" )
	self.hook_distance = self:GetSpecialValueFor( "hook_distance" ) + GetCastRangeIncrease(self:GetCaster())
	self.hook_distance = self.hook_distance + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_2")
	self.vision_radius = self:GetSpecialValueFor( "vision_radius" )  
	self.vision_duration = self:GetSpecialValueFor( "vision_duration" )
	self.nAmountOfHooks = self:GetSpecialValueFor( "number_of_hooks" ) + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_8")  

	-- Visually remove the hook from pudge
	if self:GetCaster() and self:GetCaster():IsHero() then
		local hHook = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
		if hHook ~= nil then
			hHook:AddEffects( EF_NODRAW )
		end
	end

	self.vStartPosition = self:GetCaster():GetAbsOrigin()

	-- Root the caster
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_meat_hook_followthrough", {} )

	EmitSoundOn( "Hero_Pudge.AttackHookExtend", self:GetCaster())

	for i=1,self.nAmountOfHooks do
		self.hooks[i] = {}
		self.treeTargets[i] = 0
		self.hooks[i]["vStartPosition"] = self:GetCaster():GetAbsOrigin()
		self.hooks[i]["vProjectileLocation"] = self.hooks[i]["vStartPosition"]
		self.hooks[i]["vDirection"] = (self:GetCursorPosition() - self.hooks[i]["vStartPosition"]):Normalized() * self.hook_distance
		
		if self.nAmountOfHooks > 1 then
			local rotation = (i-self:GetCaster():FindTalentValue("special_bonus_imba_pudge_8"))	 * self:GetSpecialValueFor("multiple_hook_rotation")
			self.hooks[i]["vDirection"] = RotatePosition(Vector(0,0,0), QAngle(0,rotation,0), self.hooks[i]["vDirection"])
		end

		self.hooks[i]["vDirection"].z = 0.0
		self.hooks[i]["vTargetPosition"] = self.hooks[i]["vStartPosition"] + self.hooks[i]["vDirection"]
		local vHookOffset = Vector( 0, 0, 96 )
		self.hooks[i]["vHookTarget"] = self.hooks[i]["vTargetPosition"] + vHookOffset
		local vKillswitch = Vector( ( ( self.hook_distance / self.hook_speed ) * 2 ), 0, 0 )

		local info = {
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
			vVelocity = self.hooks[i]["vDirection"] /self.hook_distance * self.hook_speed,
			fDistance = self.hook_distance,
			fStartRadius = self.hook_width ,
			fEndRadius = self.hook_width ,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_TREE,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			EffectName = "particles/units/heroes/hero_pudge/pudge_meathook.vpcf",
			ExtraData = 
			{
				nProjectileNumber = i
			}
		}

		self.hooks[i]["hProjectile"] = ProjectileManager:CreateLinearProjectile( info )

		self.hooks[i]["nChainParticleFXIndex"] = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_meathook.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleAlwaysSimulate( self.hooks[i]["nChainParticleFXIndex"])
		ParticleManager:SetParticleControlEnt( self.hooks[i]["nChainParticleFXIndex"], 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", self:GetCaster():GetAbsOrigin() + vHookOffset, true )
		ParticleManager:SetParticleControl( self.hooks[i]["nChainParticleFXIndex"], 1, self.hooks[i]["vHookTarget"] )
		ParticleManager:SetParticleControl( self.hooks[i]["nChainParticleFXIndex"], 2, Vector( self.hook_speed, self.hook_distance, self.hook_width ) )
		ParticleManager:SetParticleControl( self.hooks[i]["nChainParticleFXIndex"], 3, vKillswitch )
		ParticleManager:SetParticleControl( self.hooks[i]["nChainParticleFXIndex"], 4, Vector( 1, 0, 0 ) )
		ParticleManager:SetParticleControl( self.hooks[i]["nChainParticleFXIndex"], 5, Vector( 0, 0, 0 ) )
		ParticleManager:SetParticleControlEnt( self.hooks[i]["nChainParticleFXIndex"], 7, self:GetCaster(), PATTACH_CUSTOMORIGIN, nil, self:GetCaster():GetAbsOrigin(), true )

		self.hooks[i]["bRetracting"] = false
		self.hooks[i]["hVictim"] = nil
		self.hooks[i]["bDiedInHook"] = false
		self.hooks[i]["unitsHit"] = {}
	end
end

--------------------------------------------------------------------------------

function imba_pudge_meat_hook:OnProjectileHit_ExtraData( hTarget, vLocation,keys )
	
	local i = keys.nProjectileNumber
	if not self.hooks[i] then return end	
	
	-- RETRACTING
	if self.hooks[i]["bRetracting"] then		
		-- Hitting someone on the way back is ignored
	 	if hTarget then
			return 
		end
		-- The endpoint has been reached. Clean up
		if self:GetCaster() and self:GetCaster():IsHero() then
			local hHook = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
			if hHook ~= nil then
				hHook:RemoveEffects( EF_NODRAW )								
			end			
			StopSoundOn( "Hero_Pudge.AttackHookRetract", self:GetCaster())
			StopSoundOn( "Hero_Pudge.AttackHookExtend", self:GetCaster())
			StopSoundOn( "Hero_Pudge.AttackHookRetractStop", self:GetCaster() )			
		end

		if self.hooks[i]["unitsHit"] and #self.hooks[i]["unitsHit"] > 0 then
			for k,v in pairs(self.hooks[i]["unitsHit"]) do
				if IsValidEntity(v) then
					v:RemoveModifierByName( "modifier_meat_hook" )
					v:SetUnitOnClearGround()
				end
			end
		end
		--self.hooks[i]["unitsHit"] = nil
		ParticleManager:DestroyParticle( self.hooks[i]["nChainParticleFXIndex"], true )
		ParticleManager:ReleaseParticleIndex( self.hooks[i]["nChainParticleFXIndex"] )
		EmitSoundOn( "Hero_Pudge.AttackHookRetractStop", self:GetCaster() )

		self.hooks[i] = nil
		return
	end

	-- Here the hook always moves forward and has a target. The impact is handled here.
	if hTarget then
		-- You can't pull yourself or Juggernaut ward.
		if hTarget == self:GetCaster() or hTarget:GetUnitName() == "npc_imba_juggernaut_healing_ward" then
			return
		end

		if not self.targets[hTarget] then -- Storing the targets so it won't get handled again
			if hTarget.IsStanding then -- It is a tree	or Jugg's healing ward		
			else
				EmitSoundOn( "Hero_Pudge.AttackHookImpact", hTarget )
				hTarget:AddNewModifier( self:GetCaster(), self, "modifier_meat_hook", {duration = 1.5} )
				self.targets[hTarget] = i
				if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
					local bonusTreeDamage = self.treeTargets[i] * self:GetCaster():FindTalentValue("special_bonus_imba_pudge_6")
					local damage = 
					{
						victim = hTarget,
						attacker = self:GetCaster(),
						damage = bonusTreeDamage,
						damage_type = DAMAGE_TYPE_PHYSICAL,		
						ability = self
					}
					ApplyDamage( damage )
					local damage = 
					{
						victim = hTarget,
						attacker = self:GetCaster(),
						damage = self.hook_damage,
						damage_type = DAMAGE_TYPE_PURE,		
						ability = self
					}
					ApplyDamage( damage )

					if not hTarget:IsAlive() then
						self.hooks[i]["bDiedInHook"] = true
					end

					if not hTarget:IsMagicImmune() then
						hTarget:Interrupt()
					end

					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_meathook_impact.vpcf", PATTACH_CUSTOMORIGIN, hTarget )
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
			end

			AddFOWViewer( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), self.vision_radius, self.vision_duration, false )

			table.insert(self.hooks[i]["unitsHit"], hTarget)
		end
	end
	-- Check if the hook should retract
	
	if not hTarget or #self.hooks[i]["unitsHit"] >= self.max_targets or (self.targets[hTarget] == i and hTarget:GetTeamNumber() == self:GetCaster():GetTeamNumber()) then
		
		if self.hooks[i]["hProjectile"] then
			ProjectileManager:DestroyLinearProjectile(self.hooks[i]["hProjectile"])
		end
		local vHookOffset = Vector( 0, 0, 96 )
		if not self.hooks[i]["unitsHit"] or #self.hooks[i]["unitsHit"] == 0  then 
	
			ParticleManager:SetParticleControlEnt( self.hooks[i]["nChainParticleFXIndex"], 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", self:GetCaster():GetAbsOrigin() + vHookOffset, true);
			ParticleManager:SetParticleControl( self.hooks[i]["nChainParticleFXIndex"], 4, Vector( 0, 0, 0 ) )
			ParticleManager:SetParticleControl( self.hooks[i]["nChainParticleFXIndex"], 5, Vector( 1, 0, 0 ) )
		else
	
			for k,v in pairs(self.hooks[i]["unitsHit"]) do
	
				if v ~= nil and ( not v:IsInvisible() ) then
					ParticleManager:SetParticleControlEnt( self.hooks[i]["nChainParticleFXIndex"], 1, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin() + vHookOffset, true )
					ParticleManager:SetParticleControl( self.hooks[i]["nChainParticleFXIndex"], 4, Vector( 0, 0, 0 ) )
					ParticleManager:SetParticleControl( self.hooks[i]["nChainParticleFXIndex"], 5, Vector( 1, 0, 0 ) )
				end			
			end
		end
		self.hooks[i]["bRetracting"] = true		
		
		for j = 1,self.nAmountOfHooks do
			self.bAllRetracting = false
			if self.hooks[i]["bRetracting"] == false then
				self.bAllRetracting = false
				break
			else
				self.bAllRetracting = true
			end
		end

		if self.bAllRetracting then
			self:GetCaster():RemoveModifierByName("modifier_meat_hook_followthrough")
		end

		local vHookPos = self.hooks[i]["vProjectileLocation"]
		local flPad = self:GetCaster():GetPaddedCollisionRadius()
		if hTarget ~= nil then
			vHookPos = hTarget:GetAbsOrigin()
			flPad = flPad + hTarget:GetPaddedCollisionRadius()
		end
		--Missing: Setting target facing angle
		local vVelocity = self.hooks[i]["vStartPosition"] - vHookPos
		vVelocity.z = 0.0
	
		local flDistance = vVelocity:Length2D()-- - flPad
		vVelocity = vVelocity:Normalized() * self.hook_speed
	
		self.hooks[i]["vDirection"] = self.hooks[i]["vDirection"] * -1
		local info = 
		{
			Ability = self,
			vSpawnOrigin = vHookPos,
			vVelocity = self.hooks[i]["vDirection"] ,
			fDistance = flDistance-100,
			Source = self:GetCaster(),
			EffectName =  "particles/units/heroes/hero_pudge/pudge_meathook.vpcf",
			--iUnitTargetType = DOTA_UNIT_TARGET_TREE,
			ExtraData = 
			{
				nProjectileNumber = i
			}
		}
		
		self.hooks[i]["hProjectile"] = ProjectileManager:CreateLinearProjectile( info )
	end

	if self:GetCaster():IsAlive() then
		self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 );
		self:GetCaster():StartGesture( ACT_DOTA_CHANNEL_ABILITY_1 );
	end
end


--------------------------------------------------------------------------------

function imba_pudge_meat_hook:OnProjectileThink_ExtraData(vLocation,keys)

	local i = keys.nProjectileNumber
	if not self.hooks[i] then return end
	if self:GetCaster():FindTalentValue("special_bonus_imba_pudge_6") ~= 0 then
		local trees = GridNav:GetAllTreesAroundPoint(vLocation,self.hook_width,false)
		for _,tree in pairs(trees) do
			if tree:IsStanding() then
				tree:CutDown(self:GetCaster():GetTeamNumber())
				self.treeTargets[i] = self.treeTargets[i] + 1
			else
				table.remove(trees, tree)
			end
		end
	end
	

	self.hooks[i]["vProjectileLocation"] = vLocation
	if self.hooks[i]["unitsHit"] then
		for k,v in pairs(self.hooks[i]["unitsHit"]) do
			if IsValidEntity(v) then
				v:SetAbsOrigin(GetGroundPosition(vLocation,self:GetCaster()))
			end
		end
	end
end

--------------------------------------------------------------------------------

function imba_pudge_meat_hook:OnOwnerDied()
	self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 );
	self:GetCaster():RemoveGesture( ACT_DOTA_CHANNEL_ABILITY_1 );
end	


--------------------------------------------------------------------------------

modifier_meat_hook = class({})
--------------------------------------------------------------------------------

function modifier_meat_hook:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_meat_hook:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_meat_hook:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function modifier_meat_hook:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_meat_hook:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function modifier_meat_hook:CheckState()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetParent() ~= nil then
			if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() and ( not self:GetParent():IsMagicImmune() ) then
				local state = 
				{
					[MODIFIER_STATE_STUNNED] = true,
				}

				return state
			end
		end
	end

	local state = 
	{
		[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

modifier_meat_hook_followthrough = class({})

--------------------------------------------------------------------------------

function modifier_meat_hook_followthrough:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_meat_hook_followthrough:CheckState()
	local state = 
	{
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

--------------------------------------------------------------------------------

LinkLuaModifier("modifier_butchers_cleaver", "hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_butchers_cleaver_dummy", "hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)

imba_pudge_butchers_cleaver = class({})
function imba_pudge_butchers_cleaver:IsHiddenWhenStolen() return false end
function imba_pudge_butchers_cleaver:IsRefreshable() return true end
function imba_pudge_butchers_cleaver:IsStealable() return true end
function imba_pudge_butchers_cleaver:IsNetherWardStealable() return true end
function imba_pudge_butchers_cleaver:IsInnateAbility() return false end

function imba_pudge_butchers_cleaver:GetAbilityTextureName()
   return "custom/imba_pudge_cleaver"
end
-------------------------------------------

function imba_pudge_butchers_cleaver:OnSpellStart()
	local vTargetPosition = self:GetCursorPosition()
	local caster = self:GetCaster()

	-- I want to remove the thing but I can't find it.
	if self:GetCaster() and self:GetCaster():IsHero() then
		local cleaver = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_OFFHAND_WEAPON )
		if cleaver ~= nil then
			cleaver:AddEffects( EF_NODRAW )
		end
	end
	local velocity = (self:GetCursorPosition() - caster:GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("projectile_speed")
	local info = {
		bDeleteOnHit = self:GetCaster():FindTalentValue("special_bonus_imba_pudge_5") == 0,
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
		vVelocity = Vector(velocity.x,velocity.y,0),
		fDistance = self:GetSpecialValueFor("range"),
		fStartRadius = self:GetSpecialValueFor("projectile_radius"),
		fEndRadius = self:GetSpecialValueFor("projectile_radius"),
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		EffectName = "particles/hero/pudge/butchers_cleave_projectile.vpcf",

		iVisionRadius = self:GetSpecialValueFor("projectile_radius"),
		bProvidesVision = true,
		iVisionTeamNumber = caster:GetTeamNumber(),		
		
	}
	
	self.projectile = ProjectileManager:CreateLinearProjectile(info)

end

function imba_pudge_butchers_cleaver:OnProjectileHit(hTarget,vLocation)
	if not hTarget then 
		for i =0,30 do
			local cleaver = self:GetCaster():GetTogglableWearable( i )
			if cleaver ~= nil then
				cleaver:RemoveEffects(EF_NODRAW)		
			end
		end
		return 
	end
	
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_meathook_impact.vpcf", PATTACH_CUSTOMORIGIN, hTarget )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	hTarget:AddNewModifier(self:GetCaster(),self,"modifier_butchers_cleaver",{duration = self:GetSpecialValueFor("root_duration")})

	local damage = 
	{
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = self:GetSpecialValueFor("damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,		
		ability = self,
	}
	ApplyDamage( damage )
	if self:GetCaster():FindTalentValue("special_bonus_imba_pudge_5") == 0 then
		return true
	end
end


-------------------------------------------
modifier_butchers_cleaver_dummy = class({})

function modifier_butchers_cleaver_dummy:IsDebuff() return false end
function modifier_butchers_cleaver_dummy:IsHidden() return true end
function modifier_butchers_cleaver_dummy:IsPurgable() return false end
function modifier_butchers_cleaver_dummy:IsPurgeException() return false end
function modifier_butchers_cleaver_dummy:IsStunDebuff() return false end
function modifier_butchers_cleaver_dummy:RemoveOnDeath() return true end
function modifier_butchers_cleaver_dummy:AllowIllusionDuplicate() return false end


function modifier_butchers_cleaver_dummy:CheckState()
	local state = 
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
	return state
end

function modifier_butchers_cleaver_dummy:OnCreated()
	if IsServer() then
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_butchers_cleaver_dummy:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())

		if self:GetCaster() and self:GetCaster():IsHero() then
			local cleaver = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_OFFHAND_WEAPON )
			if cleaver ~= nil then
				cleaver:RemoveEffects(EF_NODRAW)
			end
		end
	end
end

function modifier_butchers_cleaver_dummy:OnIntervalThink()
	if not self:GetParent().parentUnit or not IsValidEntity(self:GetParent().parentUnit) then
		UTIL_Remove(self:GetParent())
		return 
	end	
end

modifier_butchers_cleaver = class({})
function modifier_butchers_cleaver:IsDebuff() return true end
function modifier_butchers_cleaver:IsHidden() return false end
function modifier_butchers_cleaver:IsPurgable() return true end

function modifier_butchers_cleaver:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.modifier_rot = "modifier_cleaver_rot"	

	if IsServer() then
	self.ability_rot = self.caster:FindAbilityByName("imba_pudge_rot")
	
		if self.ability_rot and self.ability_rot:GetLevel() > 0 then
			self.parent.butcher_cleaver_target = true			
			self.parent:AddNewModifier(self.caster, self.ability_rot, self.modifier_rot, {})
		end
	end
end

function modifier_butchers_cleaver:OnDestroy()
	if IsServer() then
		if self.parent.butcher_cleaver_target then
			self.parent:RemoveModifierByNameAndCaster(self.modifier_rot, self.caster)
		end
	end
end
-------------------------------------------

function modifier_butchers_cleaver:DeclareFunctions()
	local decFuns =
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return decFuns
end

--------------------------------------------------------------------------------

function modifier_butchers_cleaver:CheckState()
	local state = 
	{
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state
end

function modifier_butchers_cleaver:OnTakeDamage(keys)
	if IsServer() then
		if keys.attacker == self:GetCaster() and keys.unit == self:GetParent() then
			local factor = 0 + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_4")
			self:GetCaster():Heal(keys.damage*factor ,self:GetCaster())
		end
	end
end

function modifier_butchers_cleaver:GetEffectName()
	return "particles/hero/pudge/pudge_cleaver_overhead.vpcf"
end

function modifier_butchers_cleaver:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
--]]
imba_pudge_dismember = imba_pudge_dismember or class({})

LinkLuaModifier( "modifier_dismember", "hero/hero_pudge" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dismember_lifesteal", "hero/hero_pudge" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dismember_dummy", "hero/hero_pudge" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dismember_disarm", "hero/hero_pudge" ,LUA_MODIFIER_MOTION_NONE )

function imba_pudge_dismember:GetAbilityTextureName()
   return "pudge_dismember"
end

function imba_pudge_dismember:IsHiddenWhenStolen() return false end
function imba_pudge_dismember:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

function imba_pudge_dismember:GetIntrinsicModifierName()
	return "modifier_dismember_dummy"
end

--------------------------------------------------------------------------------

function imba_pudge_dismember:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

--------------------------------------------------------------------------------

function imba_pudge_dismember:GetChannelTime()
	self.creep_duration = self:GetSpecialValueFor( "creep_duration" ) + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_7")
	self.hero_duration = self:GetSpecialValueFor( "hero_duration" ) + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_7")

	local time = self.hero_duration
	if self:GetCaster():GetModifierStackCount("modifier_dismember_dummy",self:GetCaster()) == 1 then
		time = self.creep_duration
	end

	if self:GetCaster():HasTalent("special_bonus_imba_pudge_8") then
		time = time + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_8", "dismember_duration")
	end
	return time
end

--------------------------------------------------------------------------------

function imba_pudge_dismember:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end
	return true
end

--------------------------------------------------------------------------------

function imba_pudge_dismember:OnSpellStart()
	if self.hVictim == nil then
		return
	end
	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.startTime = GameRules:GetGameTime()
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_dismember", { duration = self:GetChannelTime() } )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_dismember_lifesteal", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
	end
end

--------------------------------------------------------------------------------

function imba_pudge_dismember:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_dismember" )
		self:GetCaster():RemoveModifierByName( "modifier_dismember_lifesteal")
		if self:GetCaster():FindTalentValue("special_bonus_imba_pudge_7") ~= 0 then
			self.hVictim:AddNewModifier(self:GetCaster(),self,"modifier_dismember_disarm",{duration = GameRules:GetGameTime() - self.startTime})
		end
	end
end

--------------------------------------------------------------------------------
modifier_dismember_disarm = class({})	
function modifier_dismember_disarm:IsHidden() return false end
function modifier_dismember_disarm:IsDebuff() return true end
function modifier_dismember_disarm:IsPurgable() return false end
function modifier_dismember_disarm:IsPurgeException() return false end


-- Modifier particle
function modifier_dismember_disarm:GetEffectName()
	return "particles/items2_fx/heavens_halberd.vpcf"
end

function modifier_dismember_disarm:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Declare modifier states
function modifier_dismember_disarm:CheckState()
	local states = {
		[MODIFIER_STATE_DISARMED] = true,
	}
	return states
end

modifier_dismember_dummy = class({})
function modifier_dismember_dummy:IsDebuff() return false end
function modifier_dismember_dummy:IsHidden() return true end
function modifier_dismember_dummy:IsPurgable() return false end
function modifier_dismember_dummy:IsPurgeException() return false end
function modifier_dismember_dummy:IsStunDebuff() return false end
function modifier_dismember_dummy:RemoveOnDeath() return false end

function modifier_dismember_dummy:DeclareFunctions()
	local decFuns =
	{
		MODIFIER_EVENT_ON_ABILITY_START,		
	}
	return decFuns
end

function modifier_dismember_dummy:OnAbilityStart(keys)
	if IsServer() then
		if keys.unit == self:GetCaster() and keys.ability == self:GetAbility() then
			if keys.target:IsConsideredHero() then
				self:SetStackCount(0)
			else
				self:SetStackCount(1)
			end
		end
	end
end

modifier_dismember = class({})

--------------------------------------------------------------------------------

function modifier_dismember:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_dismember:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_dismember:OnCreated( kv )
	self.dismember_damage = self:GetAbility():GetSpecialValueFor( "dismember_damage" )
	self.tick_rate = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	self.strength_damage = self:GetAbility():GetSpecialValueFor( "strength_damage" )/100

	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		local cast_responses = {"Imba.PudgeDismember1", "Imba.PudgeDismember2", "Imba.PudgeDismember3", "Imba.PudgeNom"}
		self.castResponse = cast_responses[math.random(1, #cast_responses)]
		EmitSoundOn(self.castResponse, self:GetCaster())
		self:StartIntervalThink( self.tick_rate )
	end
end

--------------------------------------------------------------------------------

function modifier_dismember:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
		if self.castResponse then
			StopSoundEvent(self.castResponse, self:GetCaster())
		end
	end
end

--------------------------------------------------------------------------------

function modifier_dismember:OnIntervalThink()
	if IsServer() then
		local flDamage = self.dismember_damage
		flDamage = flDamage + ( self:GetCaster():GetStrength() * self.strength_damage )
		--flDamage = self:GetParent():GetMagicalResistance() * flDamage
		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = flDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(),
			--damage_flags  = DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR,
		}
		ApplyDamage( damage )
		
		EmitSoundOn( "Hero_Pudge.Dismember", self:GetParent() )		
	end
end

--------------------------------------------------------------------------------

function modifier_dismember:CheckState()
	if self:GetParent():HasModifier("modifier_slark_shadow_dance") then
		local state = {[MODIFIER_STATE_STUNNED] = true}
		return state
	end

	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_dismember:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_dismember:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

modifier_dismember_lifesteal = class({})
function modifier_dismember_lifesteal:IsDebuff() return false end
function modifier_dismember_lifesteal:IsHidden() return true end
function modifier_dismember_lifesteal:IsPurgable() return false end
function modifier_dismember_lifesteal:IsPurgeException() return false end
function modifier_dismember_lifesteal:IsStunDebuff() return true end
function modifier_dismember_lifesteal:RemoveOnDeath() return true end
function modifier_dismember_lifesteal:AllowIllusionDuplicate() return false end
	
function modifier_dismember_lifesteal:GetModifierSpellLifesteal()
	return self:GetAbility():GetSpecialValueFor("spell_lifesteal")
end
--]]

--[[ 	Authors: Pizzalol and D2imba
		Date: 10.07.2015				]]

function HookCast( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_cast_check = keys.modifier_cast_check
	local modifier_light = keys.modifier_light

	-- Parameters
	local base_range = ability:GetLevelSpecialValueFor("base_range", ability_level)
	local stack_range = ability:GetLevelSpecialValueFor("stack_range", ability_level)
	local cast_distance = ( target - caster:GetAbsOrigin() ):Length2D()
	caster.stop_hook_cast = nil

	if caster:HasTalent("special_bonus_imba_pudge_5") then
		base_range = base_range + caster:FindTalentValue("special_bonus_imba_pudge_5", "hook_range")
	end

	-- Calculate actual cast range
	local light_stacks = caster:GetModifierStackCount(modifier_light, caster)
	local hook_range = base_range + stack_range * light_stacks + GetCastRangeIncrease(caster)

	-- Check if the target point is inside range, if not, stop casting and move closer
	if cast_distance > hook_range then
		-- Start moving
		caster:MoveToPosition(target)
		Timers:CreateTimer(0.1, function()
			-- Update distance and range
			cast_distance = ( target - caster:GetAbsOrigin() ):Length2D()
			light_stacks = caster:GetModifierStackCount(modifier_light, caster)
			hook_range = base_range + stack_range * light_stacks + GetCastRangeIncrease(caster)

			-- If it's not a legal cast situation and no other order was given, keep moving
			if cast_distance > hook_range and not caster.stop_hook_cast then
				return 0.1

			-- If another order was given, stop tracking the cast distance
			elseif caster.stop_hook_cast then
				caster:RemoveModifierByName(modifier_cast_check)
				caster.stop_hook_cast = nil

			-- If all conditions are met, cast Hook again
			else
				caster:CastAbilityOnPosition(target, ability, caster:GetPlayerID())
			end
		end)
		return nil
	end
end

function HookCastCheck( keys )
	local caster = keys.caster
	caster.stop_hook_cast = true
end

function MeatHook( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- If another hook is already out, refund mana cost and do nothing
	if caster.hook_launched then
		caster:GiveMana(ability:GetManaCost(ability_level))
		ability:EndCooldown()
		return nil
	end

	-- Set the global hook_launched variable
	caster.hook_launched = true

	-- Prevent Pudge from using tps while the hook is out
	local forbidden_items = {
		"item_tpscroll",
		"item_travel_boots",
		"item_travel_boots_2"
	}

	for i = 0, 5 do
		local current_item = caster:GetItemInSlot(i)
		local should_mute = false

		-- If this item is forbidden, do not refresh it
		for _,forbidden_item in pairs(forbidden_items) do
			if current_item and current_item:GetName() == forbidden_item then
				should_mute = true
			end
		end

		-- Make item inactive
		if current_item and should_mute then
			current_item:SetActivated(false)
		end
	end

	-- Sound, particle and modifier keys
	local sound_extend = keys.sound_extend
	local sound_hit = keys.sound_hit
	local sound_retract = keys.sound_retract
	local sound_retract_stop = keys.sound_retract_stop
	local particle_hook = keys.particle_hook
	local particle_hit = keys.particle_hit
	local modifier_caster = keys.modifier_caster
	local modifier_target_enemy = keys.modifier_target_enemy
	local modifier_target_ally = keys.modifier_target_ally
	local modifier_dummy = keys.modifier_dummy
	local modifier_light = keys.modifier_light
	local modifier_sharp = keys.modifier_sharp

	-- Parameters
	local base_speed = ability:GetLevelSpecialValueFor("base_speed", ability_level)
	local hook_width = ability:GetLevelSpecialValueFor("hook_width", ability_level)
	local base_range = ability:GetLevelSpecialValueFor("base_range", ability_level)
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local stack_range = ability:GetLevelSpecialValueFor("stack_range", ability_level)
	local stack_speed = ability:GetLevelSpecialValueFor("stack_speed", ability_level)
	local stack_damage = ability:GetLevelSpecialValueFor("stack_damage", ability_level)
	local damage_scepter = ability:GetLevelSpecialValueFor("damage_scepter", ability_level)
	local cooldown_scepter = ability:GetLevelSpecialValueFor("cooldown_scepter", ability_level)
	local cooldown_cap_scepter = ability:GetLevelSpecialValueFor("cooldown_cap_scepter", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)
	local enemy_disable_linger = ability:GetLevelSpecialValueFor("enemy_disable_linger", ability_level)
	local caster_loc = caster:GetAbsOrigin()
	local start_loc = caster_loc + (keys.target_points[1] - caster_loc):Normalized() * hook_width

	-- Calculate range, speed, and damage
	local light_stacks = caster:GetModifierStackCount(modifier_light, caster)
	local sharp_stacks = caster:GetModifierStackCount(modifier_sharp, caster)
	local hook_speed = base_speed + stack_speed * light_stacks
	local hook_range = base_range + stack_range * light_stacks + GetCastRangeIncrease(caster)
	local hook_damage = base_damage + stack_damage * sharp_stacks

	if caster:HasTalent("special_bonus_imba_pudge_5") then
		hook_range = hook_range + caster:FindTalentValue("special_bonus_imba_pudge_5", "hook_range")
	end

	if caster:HasTalent("special_bonus_imba_pudge_2") then
		hook_speed = hook_speed + caster:FindTalentValue("special_bonus_imba_pudge_2", "hook_speed")
	end

	if caster:HasTalent("special_bonus_imba_pudge_3") then
		hook_width = hook_width + caster:FindTalentValue("special_bonus_imba_pudge_3", "hook_width")
	end

	-- If the caster has a scepter, improve stack-based damage and cooldown
	if caster:HasScepter() then
		local cdr = 0
		local caster_cdr = caster:GetCooldownReduction()
		hook_damage = hook_damage + light_stacks * damage_scepter
		local hook_cooldown = math.max(ability:GetCooldown(ability_level) - cooldown_scepter * sharp_stacks, cooldown_cap_scepter)
		ability:EndCooldown()
		if caster_cdr and caster_cdr ~= 0 then
			cdr = hook_cooldown * caster_cdr / 100
		end
		ability:StartCooldown(hook_cooldown - cdr)
	end

	-- Stun the caster for the hook duration
	ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})

	-- Play Hook launch sound
	caster:EmitSound(sound_extend)

	-- Create and set up the Hook dummy unit
	local hook_dummy = CreateUnitByName("npc_dummy_unit", start_loc + Vector(0, 0, 150), false, caster, caster, caster:GetTeam())
	hook_dummy:AddNewModifier(caster, nil, "modifier_phased", {})
	ability:ApplyDataDrivenModifier(caster, hook_dummy, modifier_dummy, {})
	hook_dummy:SetForwardVector(caster:GetForwardVector())

	-- Make the hook always visible to both teams
	caster:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, hook_range / hook_speed)
	caster:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, hook_range / hook_speed)

	-- Attach the Hook particle
	local hook_pfx = ParticleManager:CreateParticle(particle_hook, PATTACH_RENDERORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleAlwaysSimulate(hook_pfx)
	ParticleManager:SetParticleControlEnt(hook_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", caster_loc, true)
	ParticleManager:SetParticleControl(hook_pfx, 1, start_loc )
	ParticleManager:SetParticleControl(hook_pfx, 2, Vector(hook_speed, hook_range, hook_width) )
	ParticleManager:SetParticleControl(hook_pfx, 6, start_loc)
	ParticleManager:SetParticleControlEnt(hook_pfx, 6, hook_dummy, PATTACH_POINT_FOLLOW, "attach_overhead", start_loc, false)
	ParticleManager:SetParticleControlEnt(hook_pfx, 7, caster, PATTACH_CUSTOMORIGIN, nil, caster_loc, true)

	-- Remove the caster's hook
	local weapon_hook
	if caster:IsHero() then
		weapon_hook = caster:GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
		if weapon_hook ~= nil then
			weapon_hook:AddEffects( EF_NODRAW )
		end
	end

	-- Initialize Hook variables
	local hook_loc = start_loc
	hook_speed = hook_speed * FrameTime()

	local travel_distance = (hook_loc - caster_loc):Length2D()
	local hook_step = (keys.target_points[1] - caster_loc):Normalized() * hook_speed

	local target_hit = false
	local target_special = false
	local target

	-- Main Hook loop
	Timers:CreateTimer(FrameTime(), function()
		-- Check for valid units in the area
		local units = FindUnitsInRadius(caster:GetTeamNumber(), hook_loc, nil, hook_width, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,unit in pairs(units) do
			if unit ~= caster and unit ~= hook_dummy and not unit:IsAncient() and not IsNearFriendlyClass(unit, 1360, "ent_dota_fountain") then
				target_hit = true
				target = unit
				break
			end
		end

		local runes = {
			"models/props_gameplay/rune_goldxp.vmdl",
			"models/props_gameplay/rune_haste01.vmdl",
			"models/props_gameplay/rune_doubledamage01.vmdl",
			"models/props_gameplay/rune_regeneration01.vmdl",
			"models/props_gameplay/rune_arcane.vmdl",
			"models/props_gameplay/rune_invisibility01.vmdl",
			"models/props_gameplay/rune_illusion01.vmdl",
			"models/props_gameplay/rune_frost.vmdl",
		}

		for _, ent in pairs(Entities:FindAllInSphere(hook_loc, hook_width)) do
			for _, model in pairs(runes) do
				for _, rune in pairs(Entities:FindAllByModel(model)) do
					if (hook_loc - rune:GetAbsOrigin()):Length2D() < hook_width then
						target_hit = true
						target_special = true
						target = rune
					end
				end
			end
		end

		for _, rune in pairs(runes) do
--			print(Entities:FindByNameWithin(nil, rune, hook_loc, hook_width))
		end

		-- If a valid target was hit, start dragging them
		if target_hit then
			if target_special == false then
				-- Apply stun/root modifier, and damage if the target is an enemy
				if caster:GetTeam() == target:GetTeam() then
					ability:ApplyDataDrivenModifier(caster, target, modifier_target_ally, {})
				else
					ability:ApplyDataDrivenModifier(caster, target, modifier_target_enemy, {})
					ApplyDamage({attacker = caster, victim = target, ability = ability, damage = hook_damage, damage_type = DAMAGE_TYPE_PURE})
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, hook_damage, nil)
				end
			else
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, target, 0, nil)
			end

			-- Play the hit sound and particle
			target:EmitSound(sound_hit)
			local hook_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, target)

			-- Grant vision on the hook hit area
			ability:CreateVisibilityNode(hook_loc, vision_radius, vision_duration)

			-- Increase hook return speed
--			hook_speed = math.max(hook_speed, 3000 * FrameTime())
		end

		-- If no target was hit and the maximum range is not reached, move the hook and keep going
		if not target_hit and travel_distance < hook_range then

			-- Move the hook
			hook_dummy:SetAbsOrigin(hook_loc + hook_step)

			-- Recalculate position and distance
			hook_loc = hook_dummy:GetAbsOrigin()
			travel_distance = (hook_loc - caster_loc):Length2D()
			return FrameTime()
		end

		-- If we are here, this means the hook has to start reeling back; prepare return variables
		local direction = ( caster_loc - hook_loc )
		local current_tick = 0

		-- Stop the extending sound and start playing the return sound
		caster:StopSound(sound_extend)
		caster:EmitSound(sound_retract)

		-- Remove the caster's self-stun
		caster:RemoveModifierByName(modifier_caster)

		-- Play sound reaction according to which target was hit
		if target_special == false then
			if target_hit and target:IsRealHero() and target:GetTeam() ~= caster:GetTeam() then
				caster:EmitSound("pudge_pud_ability_hook_0"..RandomInt(1,9))
			elseif target_hit and target:IsRealHero() and target:GetTeam() == caster:GetTeam() then
				caster:EmitSound("pudge_pud_ability_hook_miss_01")
			elseif target_hit then
				caster:EmitSound("pudge_pud_ability_hook_miss_0"..RandomInt(2,6))
			else
				caster:EmitSound("pudge_pud_ability_hook_miss_0"..RandomInt(8,9))
			end
		else
			if target_hit then
				caster:EmitSound("pudge_pud_ability_hook_miss_0"..RandomInt(2,6))
			else
				caster:EmitSound("pudge_pud_ability_hook_miss_0"..RandomInt(8,9))
			end
		end

		local damage_cap = 2500
		local target_previous_position
		if target then
			target_previous_position = target:GetAbsOrigin()
		end

		-- Hook reeling loop
		Timers:CreateTimer(FrameTime(), function()
			-- Recalculate position variables
			caster_loc = caster:GetAbsOrigin()
			hook_loc = hook_dummy:GetAbsOrigin()
			direction = ( caster_loc - hook_loc )
			hook_step = direction:Normalized() * hook_speed
			current_tick = current_tick + 1

			-- If the target is close enough, or the hook has been out too long, finalize the hook return
			if direction:Length2D() < hook_speed or current_tick > 300 then

				-- Stop moving the target
				if target_hit then
					local final_loc = caster_loc + caster:GetForwardVector() * 100
					FindClearSpaceForUnit(target, final_loc, false)

					-- Remove the target's modifiers
					if target_special == false then
						target:RemoveModifierByName(modifier_target_ally)

						-- Enemies have a small extra duration on their stun
						Timers:CreateTimer(enemy_disable_linger, function()
							target:RemoveModifierByName(modifier_target_enemy)
						end)
					end
				end

				-- Destroy the hook dummy and particles
				hook_dummy:Destroy()
				ParticleManager:DestroyParticle(hook_pfx, false)
				ParticleManager:ReleaseParticleIndex(hook_pfx)

				-- Stop playing the reeling sound
				caster:StopSound(sound_retract)
				caster:EmitSound(sound_retract_stop)

				-- Give back the caster's hook
				if weapon_hook ~= nil then
					weapon_hook:RemoveEffects( EF_NODRAW )
				end

				-- Clear global variables
				caster.hook_launched = nil

				-- Reactivate tp scrolls/boots
				for i = 0, 5 do
					local current_item = caster:GetItemInSlot(i)
					if current_item then
						current_item:SetActivated(true)
					end
				end
			-- If this is not the final step, keep reeling the hook in
			else
				-- Move the hook and an eventual target
				hook_dummy:SetAbsOrigin(hook_loc + hook_step)
				ParticleManager:SetParticleControl(hook_pfx, 6, hook_loc + hook_step + Vector(0, 0, 90))

				if target and target_hit then
					target:SetAbsOrigin(hook_loc + hook_step)
					target:SetForwardVector(direction:Normalized())
					ability:CreateVisibilityNode(hook_loc, vision_radius, 0.5)

					if caster:GetTeamNumber() ~= target:GetTeamNumber() and target_special == false and caster:HasTalent("special_bonus_imba_pudge_7") then
						local rupture_damage = caster:FindTalentValue("special_bonus_imba_pudge_7", "movement_damage_pct") / 20

						if CalculateDistance(target_previous_position, target) < damage_cap then
							local move_damage = CalculateDistance(target_previous_position, target) * rupture_damage
							if move_damage > 0 then
								if not target.is_ruptured then
									target.is_ruptured = true
									ability.RuptureFX = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf", PATTACH_POINT_FOLLOW, target)
									EmitSoundOn("hero_bloodseeker.rupture.cast", target)
									EmitSoundOn("hero_bloodseeker.rupture", target)
								end
								ApplyDamage({victim = target, attacker = caster, damage = move_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
							end
						end
						target_previous_position = target:GetAbsOrigin()
					end
				end
				return FrameTime()
			end
			if ability.RuptureFX then
				ParticleManager:DestroyParticle(ability.RuptureFX, true)
				ParticleManager:ReleaseParticleIndex(ability.RuptureFX)
			end
		end)
	end)
end

function HookUpgrade( keys )
	local caster = keys.caster
	local ability_level = keys.ability:GetLevel()
	local ability_sharp = caster:FindAbilityByName(keys.ability_sharp)
	local ability_light = caster:FindAbilityByName(keys.ability_light)

	-- Level up sharp and light hook abilities
	if ability_sharp and ability_light then
		ability_sharp:SetLevel(ability_level)
		ability_light:SetLevel(ability_level)
	end
end

function HookStacksUpdater( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_sharp = keys.modifier_sharp
	local modifier_light = keys.modifier_light

	-- If this is Rubick and Meat Hook is no longer present, kill the modifier
	if IsStolenSpell(caster) then
		if not caster:FindAbilityByName("imba_pudge_meat_hook") then
			caster:RemoveModifierByName(modifier_sharp)
			caster:RemoveModifierByName(modifier_light)
			return nil
		end
	end

	-- Parameters
	local sharp_stacks = caster:GetModifierStackCount(modifier_sharp, caster)
	local light_stacks = caster:GetModifierStackCount(modifier_light, caster)
	local caster_level = caster:GetLevel()
	if caster:HasTalent("special_bonus_imba_pudge_1") then
		caster_level = caster:GetLevel() + caster:FindTalentValue("special_bonus_imba_pudge_1", "bonus_stacks")
	end

	-- Check if caster level is greater than twice the amount of stacks
	if caster_level > sharp_stacks + light_stacks then
		AddStacks(ability, caster, caster, modifier_sharp, 1, true)
		AddStacks(ability, caster, caster, modifier_light, 1, true)
	end
end

function SharpHookToggle( keys )
	local caster = keys.caster
	local ability_light = caster:FindAbilityByName(keys.ability_light)

	if ability_light:GetToggleState() then
		ability_light:ToggleAbility()
	end
end

function LightHookToggle( keys )
	local caster = keys.caster
	local ability_sharp = caster:FindAbilityByName(keys.ability_sharp)

	if ability_sharp:GetToggleState() then
		ability_sharp:ToggleAbility()
	end
end

function SharpHook( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_hook = caster:FindAbilityByName(keys.ability_hook)
	local modifier_sharp = keys.modifier_sharp
	local modifier_light = keys.modifier_light

	-- If there are no stacks of Light Hook, do nothing and toggle the skill off
	if not caster:HasModifier(modifier_light) then
		ability:ToggleAbility()
		return nil
	end

	-- Fetch the amount of Light Hook stacks
	local light_stacks = caster:GetModifierStackCount(modifier_light, caster)

	-- If the amount of Light Hook stacks is 1, remove the buff
	if light_stacks <= 1 then
		caster:RemoveModifierByName(modifier_light)

	-- If not, just remove 1 stack from it
	else
		AddStacks(ability_hook, caster, caster, modifier_light, -1, true)
	end

	-- Add a stack of Sharp Hook
	AddStacks(ability_hook, caster, caster, modifier_sharp, 1, true)
end

function LightHook( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_hook = caster:FindAbilityByName(keys.ability_hook)
	local modifier_sharp = keys.modifier_sharp
	local modifier_light = keys.modifier_light

	-- If there are no stacks of Sharp Hook, do nothing and toggle the skill off
	if not caster:HasModifier(modifier_sharp) then
		ability:ToggleAbility()
		return nil
	end

	-- Fetch the amount of Sharp Hook stacks
	local sharp_stacks = caster:GetModifierStackCount(modifier_sharp, caster)

	-- If the amount of Sharp Hook stacks is 1, remove the buff
	if sharp_stacks <= 1 then
		caster:RemoveModifierByName(modifier_sharp)

	-- If not, just remove 1 stack from it
	else
		AddStacks(ability_hook, caster, caster, modifier_sharp, -1, true)
	end

	-- Add a stack of Light Hook
	AddStacks(ability_hook, caster, caster, modifier_light, 1, true)
end

function Rot( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_slow= keys.modifier_slow
	local modifier_heap = keys.modifier_heap

	-- Parameters
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local bonus_damage = ability:GetLevelSpecialValueFor("bonus_damage", ability_level) * 0.01
	local base_radius = ability:GetLevelSpecialValueFor("base_radius", ability_level)
	local stack_radius = ability:GetLevelSpecialValueFor("stack_radius", ability_level)
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)
	local rot_tick = ability:GetLevelSpecialValueFor("rot_tick", ability_level)

	-- Retrieve flesh heap stacks
	local heap_stacks = 0
	if caster:HasModifier(modifier_heap) then
		heap_stacks = math.min(caster:GetModifierStackCount(modifier_heap, caster), max_stacks)
	end

	-- Calculate damage and radius
	local damage = (base_damage + caster:GetMaxHealth() * bonus_damage) * rot_tick
	local radius = base_radius + stack_radius * heap_stacks

	if caster:HasTalent("special_bonus_imba_pudge_6") then
		damage = damage + caster:FindTalentValue("special_bonus_imba_pudge_6", "rot_damage")
	end

	-- Damage the caster
	ApplyDamage({attacker = caster, victim = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})


	-- Deal damage and apply slow
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,unit in pairs(units) do
		ApplyDamage({attacker = caster, victim = unit, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		ability:ApplyDataDrivenModifier(caster, unit, modifier_slow, {})
	end
end

function RotParticle( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_heap = keys.modifier_heap
	local rot_particle= keys.rot_particle

	-- Parameters
	local base_radius = ability:GetLevelSpecialValueFor("base_radius", ability_level)
	local stack_radius = ability:GetLevelSpecialValueFor("stack_radius", ability_level)
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	-- Retrieve flesh heap stacks
	local heap_stacks = 0
	if caster:HasModifier(modifier_heap) then
		heap_stacks = math.min(caster:GetModifierStackCount(modifier_heap, caster), max_stacks)
	end

	-- Calculate radius
	local radius = base_radius + stack_radius * heap_stacks

	-- Draw the particle
	caster.rot_fx = ParticleManager:CreateParticle(rot_particle, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(caster.rot_fx, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl(caster.rot_fx, 1, Vector(radius,0,0) )
end

function RotResponse( keys )
	local caster = keys.caster

	-- Play pudge's voice reaction
	local random_int = RandomInt(7,13)
	if random_int < 10 then
		caster:EmitSound("pudge_pud_ability_rot_0"..random_int)
	else
		caster:EmitSound("pudge_pud_ability_rot_"..random_int)
	end
end

function RotEnd( keys )
	local caster = keys.caster
	local rot_sound = keys.rot_sound

	StopSoundEvent(rot_sound, caster)
	ParticleManager:DestroyParticle(caster.rot_fx, false)
end

function FleshHeapUpgrade( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_resist = keys.modifier_resist
	local modifier_stacks = keys.modifier_stacks

	-- Parameters
	local stack_scale_up = ability:GetLevelSpecialValueFor("stack_scale_up", ability_level)
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)
	local stack_amount
	local resist_amount

	if caster:HasTalent("special_bonus_imba_pudge_4") then
		max_stacks = max_stacks + caster:FindTalentValue("special_bonus_imba_pudge_4", "max_stacks")
	end

	-- If Heap is already learned, fetch the current amount of stacks
	if caster.heap_stacks then
		stack_amount = caster.heap_stacks
		resist_amount = caster.heap_resist_stacks
	-- Else, fetch kills/assists up to this point of the game (lazy way to make Heap retroactive)
	else
		local assists = caster:GetAssists()
		local kills = caster:GetKills()	
		stack_amount = kills + assists
		resist_amount = math.min(stack_amount, max_stacks)

		-- Define the global variables which keep track of heap stacks
		caster.heap_stacks = stack_amount
		caster.heap_resist_stacks = resist_amount
	end

	-- Remove both modifiers in order to update their bonuses
	caster:RemoveModifierByName(modifier_stacks)
	while caster:HasModifier(modifier_resist) do
		caster:RemoveModifierByName(modifier_resist)
	end

	-- Add stacks of the capped (magic resist) modifier
	for i = 1, resist_amount do
		ability:ApplyDataDrivenModifier(caster, caster, modifier_resist, {})
	end

	-- Add stacks of the uncapped modifier
	AddStacks(ability, caster, caster, modifier_stacks, stack_amount, true)

	-- Update stats
	caster:CalculateStatBonus()

	-- Make pudge GROW
	caster:SetModelScale( math.min( 1 + stack_scale_up * stack_amount / 100, 2.0) )
end

function FleshHeap( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- If this isnt a real hero, do nothing.
	if ( not target:IsRealHero() ) or target:HasModifier("modifier_arc_warden_tempest_double") then
		return nil
	end

	-- Parameters
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	if caster:HasTalent("special_bonus_imba_pudge_4") then
		max_stacks = max_stacks + caster:FindTalentValue("special_bonus_imba_pudge_4", "max_stacks")
	end

	-- Prevent resist stacks from resetting if the skill is unlearned
	if ability_level == 0 then
		max_stacks = caster.heap_resist_stacks + 1
	end

	-- Update the global heap stacks variable
	caster.heap_stacks = caster.heap_stacks + 1
	caster.heap_resist_stacks = math.min(caster.heap_resist_stacks + 1, max_stacks)

	-- Play pudge's voice reaction
	caster:EmitSound("pudge_pud_ability_heap_0"..RandomInt(1,2))
end

function HeapUpdater( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_resist = keys.modifier_resist
	local modifier_stacks = keys.modifier_stacks

	-- Parameters
	local stack_scale_up = ability:GetLevelSpecialValueFor("stack_scale_up", ability_level)
	local stack_amount = caster:GetModifierStackCount(modifier_stacks, caster)
	local resist_amount = caster:FindAllModifiersByName(modifier_resist)

	-- If the amount of strength stacks has increased, update it
	if caster.heap_stacks > stack_amount and caster:IsAlive() then
		local stacks_missing = caster.heap_stacks - stack_amount

		-- Add the appropriate amount of strength stacks
		AddStacks(ability, caster, caster, modifier_stacks, stacks_missing, true)

		-- Update stats
		caster:CalculateStatBonus()

		-- Make pudge GROW
		caster:SetModelScale( math.min( 1 + stack_scale_up * stack_amount / 100, 2.0) )
	end

	-- If the amount of resist stacks has increased, update it
	if caster.heap_resist_stacks > #resist_amount and caster:IsAlive() then
		local stacks_missing = caster.heap_resist_stacks - #resist_amount

		-- Add the appropriate amount of resist stacks
		for i = 1, stacks_missing do
			ability:ApplyDataDrivenModifier(caster, caster, modifier_resist, {})
		end
	end
end
--[[
function Dismember( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_target = keys.particle_target
	local modifier_debuff = keys.modifier_debuff

	-- Parameters
	local dismember_damage = ability:GetLevelSpecialValueFor("dismember_damage", ability_level)
	local strength_damage = ability:GetLevelSpecialValueFor("strength_damage", ability_level)
	local caster_str = 0
	if caster:IsHero() then
		caster_str = caster:GetStrength()
	end

	-- If the target possesses a ready Linken's Sphere, break channel and do nothing else
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		if target:TriggerSpellAbsorb(ability) then
			Timers:CreateTimer(0.01, function()
				ability:EndChannel(true)
				caster:MoveToPosition(caster:GetAbsOrigin())
			end)
			return nil
		end
	end

	-- Flag the target as such
	if not caster.dismember_target then
		caster.dismember_target = target
	end

	-- Calculate damage/heal
	local damage = dismember_damage + caster_str * strength_damage / 100

	-- Apply Dismember debuff
	ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})

	-- Apply damage/heal
	caster:Heal(damage, caster)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, damage, nil)
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Play the particle
	local blood_pfx = ParticleManager:CreateParticle(particle_target, PATTACH_ABSORIGIN, target)
	ParticleManager:ReleaseParticleIndex(blood_pfx)
end

function DismemberEnd( keys )
	local caster = keys.caster
	local modifier_dismember = keys.modifier_dismember

	-- Remove dismember modifier from the target
	if caster.dismember_target then
		caster.dismember_target:RemoveModifierByName(modifier_dismember)

		-- Reset dismember target
		caster.dismember_target = nil
	end
end
--]]