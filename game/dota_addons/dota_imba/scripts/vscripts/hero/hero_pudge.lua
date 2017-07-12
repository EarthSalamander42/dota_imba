
CreateEmptyTalents("pudge")

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
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_meat_hook_followthrough", { --[[duration = flFollowthroughDuration]] } )

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
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
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
	-- You can't pull yourself.
	if hTarget == self:GetCaster() then
		return
	end

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
		if not self.targets[hTarget] then -- Storing the targets so it won't get handled again
			if hTarget.IsStanding then -- It is a treea
			--[[	self.treeTargets[i] = self.treeTargets[i] + 1 -- Doesn't work, using OnProjectileThink
				print("Trees hit:", self.treeTargets[i])
				return]]
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
		UTIL_Remove(self.cleaver)
		return 
	end
	
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_meathook_impact.vpcf", PATTACH_CUSTOMORIGIN, hTarget )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	
	self.cleaver = CreateUnitByName("npc_dummy_blank",self:GetCaster():GetAbsOrigin(),false,nil,nil,self:GetCaster():GetTeamNumber())
	self.cleaver:AddNewModifier(self:GetCaster(),self,"modifier_butchers_cleaver_dummy",{duration = self:GetSpecialValueFor("root_duration")})
	self.cleaver.parentUnit = hTarget

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
function modifier_butchers_cleaver:IsPurgable() return false end
function modifier_butchers_cleaver:IsPurgeException() return false end
function modifier_butchers_cleaver:IsStunDebuff() return false end
function modifier_butchers_cleaver:RemoveOnDeath() return true end
function modifier_butchers_cleaver:AllowIllusionDuplicate() return false end

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