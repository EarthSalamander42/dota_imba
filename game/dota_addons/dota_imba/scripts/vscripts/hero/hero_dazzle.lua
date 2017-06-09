--	Author - 		zimberzimber
--	Date Created -	10.03.2017

CreateEmptyTalents("dazzle")

---------------------------------------------------------------------
-------------------------	Poison Touch	-------------------------
---------------------------------------------------------------------
if imba_dazzle_poison_touch == nil then imba_dazzle_poison_touch = class({}) end
LinkLuaModifier( "modifier_imba_dazzle_poison_touch_setin", "hero/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )	-- Set in modifier (slow + attack counter)
LinkLuaModifier( "modifier_imba_dazzle_poison_touch_debuff", "hero/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )	-- Stun + damage over time

function imba_dazzle_poison_touch:GetAbilityTextureName()
   return "dazzle_poison_touch"
end

function imba_dazzle_poison_touch:GetCooldown()
	local cooldown = self:GetSpecialValueFor("cooldown")
	local cooldownbonus = self:GetCaster():FindTalentValue("special_bonus_imba_dazzle_5")
	
	return cooldown + cooldownbonus
end

function imba_dazzle_poison_touch:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET end

function imba_dazzle_poison_touch:OnSpellStart()
	local projectile = {
		Target = self:GetCursorTarget(),
		Source = self:GetCaster(),
		Ability = self,
		EffectName = "particles/units/heroes/hero_dazzle/dazzle_poison_touch.vpcf",
		bDodgable = true,
		bProvidesVision = false,
		iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
	}
	EmitSoundOn("Hero_Dazzle.Poison_Cast", self:GetCaster())
	ProjectileManager:CreateTrackingProjectile(projectile)
end

function imba_dazzle_poison_touch:OnProjectileHit(target, location)
	if target:TriggerSpellAbsorb(self) then return end
	
	EmitSoundOn("Hero_Dazzle.Poison_Touch", target)
	target:AddNewModifier(self:GetCaster(), self, "modifier_imba_dazzle_poison_touch_setin", {duration = self:GetSpecialValueFor("set_in_time")})
end

-----------------------------------------------
-----	Poison Touch set in modifier	  -----
-----------------------------------------------
if modifier_imba_dazzle_poison_touch_setin == nil then modifier_imba_dazzle_poison_touch_setin = class({}) end
function modifier_imba_dazzle_poison_touch_setin:IsPurgable() return true end
function modifier_imba_dazzle_poison_touch_setin:IsHidden() return false end
function modifier_imba_dazzle_poison_touch_setin:IsDebuff() return true end
function modifier_imba_dazzle_poison_touch_setin:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_dazzle_poison_touch_setin:GetEffectName()
	return "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf" end
	
function modifier_imba_dazzle_poison_touch_setin:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_dazzle_poison_touch_setin:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_imba_dazzle_poison_touch_setin:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if parent:IsAlive() and not parent:IsMagicImmune() then
			local ability = self:GetAbility()
			local mod = parent:AddNewModifier(ability:GetCaster(), ability, "modifier_imba_dazzle_poison_touch_debuff", {duration = ability:GetSpecialValueFor("poison_duration")})
			mod:SetStackCount(self:GetStackCount())
		end
	end
end

function modifier_imba_dazzle_poison_touch_setin:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
					MODIFIER_EVENT_ON_ATTACK_LANDED,			}
	return funcs
end

function modifier_imba_dazzle_poison_touch_setin:OnIntervalThink()
	if IsServer() then
		EmitSoundOn("Hero_Dazzle.Poison_Tick", self:GetParent())
		
		local remaining = self:GetRemainingTime()
		if remaining <= 1 then
			local ability = self:GetAbility()
			self:GetParent():AddNewModifier(ability:GetCaster(), ability, "modifier_stunned", {duration = 1})
			self:StartIntervalThink(-1)
		end
	end
end

function modifier_imba_dazzle_poison_touch_setin:OnAttackLanded( keys )
	if IsServer() then
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local victim = keys.target
		local damage = keys.damage
		
		if victim == parent and damage > 0 then
			local stacks = self:GetStackCount()
			if stacks then
				self:SetStackCount(1 + stacks)
			else
				self:SetStackCount(1)
			end
		end
	end
end

function modifier_imba_dazzle_poison_touch_setin:GetModifierMoveSpeedBonus_Percentage()
	if IsServer() then
		local ability = self:GetAbility()
		local minSlow = ability:GetSpecialValueFor("minimum_slow")
		local maxSlow = ability:GetSpecialValueFor("maximum_slow")
		
		local duration = self:GetDuration() - 1
		local elapsed = math.floor(self:GetElapsedTime())
		
		local totalSlow = (maxSlow - minSlow) / duration * elapsed + minSlow
		return totalSlow * -1
	end
end

-----------------------------------------------
-----	Poison Touch debuff modifier	  -----
-----------------------------------------------
if modifier_imba_dazzle_poison_touch_debuff == nil then modifier_imba_dazzle_poison_touch_debuff = class({}) end
function modifier_imba_dazzle_poison_touch_debuff:IsPurgable() return true end
function modifier_imba_dazzle_poison_touch_debuff:IsHidden() return false end
function modifier_imba_dazzle_poison_touch_debuff:IsDebuff() return true end
function modifier_imba_dazzle_poison_touch_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_dazzle_poison_touch_debuff:GetTexture()
	return "dazzle_poison_touch" end

function modifier_imba_dazzle_poison_touch_debuff:GetEffectName()
	return "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf" end
	
function modifier_imba_dazzle_poison_touch_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_dazzle_poison_touch_debuff:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,}
	return funcs
end

function modifier_imba_dazzle_poison_touch_debuff:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_imba_dazzle_poison_touch_debuff:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local stacks = self:GetStackCount()
		local baseDamage = ability:GetSpecialValueFor("poison_base_damage")
		local stackDamage = ability:GetSpecialValueFor("poison_stack_damage")
		local totalDamage = baseDamage
		
		totalDamage = baseDamage + stackDamage * stacks
		
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), totalDamage, nil)
		ApplyDamage({victim = self:GetParent(), attacker = ability:GetCaster(), damage = totalDamage, damage_type = DAMAGE_TYPE_PHYSICAL})
	end
end

function modifier_imba_dazzle_poison_touch_debuff:GetModifierPhysicalArmorBonus()
	local stacks = self:GetStackCount()
	if stacks then return self:GetAbility():GetSpecialValueFor("stack_armor_reduction") * stacks * -1 end
	return 0
end

---------------------------------------------------------------------
-------------------------	Shallow Grave	-------------------------
---------------------------------------------------------------------
if imba_dazzle_shallow_grave == nil then imba_dazzle_shallow_grave = class({}) end
LinkLuaModifier( "modifier_imba_dazzle_shallow_grave", "hero/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )	-- Shallow Grave effect
LinkLuaModifier( "modifier_imba_dazzle_nothl_protection", "hero/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )-- Passive self-cast

function imba_dazzle_shallow_grave:GetAbilityTextureName()
   return "dazzle_shallow_grave"
end

function imba_dazzle_shallow_grave:GetManaCost()
	if self:GetCaster():HasTalent("special_bonus_imba_dazzle_1") then 
		return 0 end
	return self:GetSpecialValueFor("mana_cost")
end

function imba_dazzle_shallow_grave:GetCastAnimation()
	return ACT_DOTA_SHALLOW_GRAVE end
	
function imba_dazzle_shallow_grave:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET end

function imba_dazzle_shallow_grave:OnSpellStart()
	if IsServer() then
		local target = self:GetCursorTarget()
		EmitSoundOn("Hero_Dazzle.Shallow_Grave", target)
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_dazzle_shallow_grave", {duration = self:GetSpecialValueFor("duration")})
	end
end

function imba_dazzle_shallow_grave:GetIntrinsicModifierName()
	local caster = self:GetCaster()
	if not caster:HasAbility("imba_pugna_nether_ward_aura") and not caster:IsIllusion() then
		return "modifier_imba_dazzle_nothl_protection"
	end
end

---------------------------------------
-----	Shallow Grave modifier	  -----
---------------------------------------
if modifier_imba_dazzle_shallow_grave == nil then modifier_imba_dazzle_shallow_grave = class({}) end
function modifier_imba_dazzle_shallow_grave:IsPurgable() return false end
function modifier_imba_dazzle_shallow_grave:IsHidden() return false end
function modifier_imba_dazzle_shallow_grave:IsDebuff() return false end

function modifier_imba_dazzle_shallow_grave:GetEffectName()
	return "particles/econ/items/dazzle/dazzle_dark_light_weapon/dazzle_dark_shallow_grave.vpcf" end
	
function modifier_imba_dazzle_shallow_grave:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_dazzle_shallow_grave:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MIN_HEALTH,
					MODIFIER_EVENT_ON_TAKEDAMAGE,}
	return funcs
end

function modifier_imba_dazzle_shallow_grave:GetMinHealth()
	return 1 end

function modifier_imba_dazzle_shallow_grave:OnCreated()
	if IsServer() then
		self.shallowDamage = 0
	end
end

function modifier_imba_dazzle_shallow_grave:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		
		-- Checking if alive for cases of death that don't care for Shallow Grave
		if parent:IsAlive() and self.shallowDamage > 0 then
			parent:Heal(self.shallowDamage, self:GetAbility():GetCaster())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, self.shallowDamage, nil)
		end
	end
end

function modifier_imba_dazzle_shallow_grave:OnTakeDamage( keys )
	if IsServer() then
		local parent = self:GetParent()
		local health = parent:GetHealth()
		local victim = keys.unit
		local damage = keys.damage
		
		if parent == victim and math.floor(health) <= 1 then
			self.shallowDamage = self.shallowDamage + damage
		end
	end
end

-------------------------------------------
-----	Nothl Protection modifier	  -----
-------------------------------------------
if modifier_imba_dazzle_nothl_protection == nil then modifier_imba_dazzle_nothl_protection = class({}) end
function modifier_imba_dazzle_nothl_protection:IsPurgable() return false end
function modifier_imba_dazzle_nothl_protection:IsHidden() return false end
function modifier_imba_dazzle_nothl_protection:DestroyOnExpire() return false end

function modifier_imba_dazzle_nothl_protection:IsDebuff()
	if self:GetStackCount() < 1 then
		return false
	end
	return true
end

function modifier_imba_dazzle_nothl_protection:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MIN_HEALTH,
					MODIFIER_EVENT_ON_TAKEDAMAGE,}
	return funcs
end

function modifier_imba_dazzle_nothl_protection:GetTexture()
	if self:GetStackCount() > 0 then
		return "custom/dazzle_shallow_grave_cooldown"
	else
		return "custom/dazzle_nothl_protection"
	end
end

function modifier_imba_dazzle_nothl_protection:GetMinHealth()
	if IsServer() then
		if self:GetParent():PassivesDisabled() and not self.isActive then
			return 0
		elseif self:GetStackCount() > 0 then
			return 0
		else
			return 1
		end
	end
end

function modifier_imba_dazzle_nothl_protection:OnCreated()
	if IsServer() then
		self.isActive = false
		self.shallowDamage = 0
	end
end

function modifier_imba_dazzle_nothl_protection:OnTakeDamage( keys )
	if IsServer() then
		if self:GetStackCount() < 1 then
			local parent = self:GetParent()
			local health = parent:GetHealth()
			local victim = keys.unit
			local damage = keys.damage
			
			-- If the victim is the modifier holder
			if parent == victim and math.floor(health) <= 1 and not parent:FindModifierByName("modifier_imba_dazzle_shallow_grave") then
			
				-- If the modifier is not active, and the carrier is not broken
				if not self.isActive and not parent:PassivesDisabled() then
					local ability = self:GetAbility()
					
					self.shallowDamage = self.shallowDamage + damage
					self.isActive = true
					
					local particle = ParticleManager:CreateParticle("particles/hero/dazzle/dazzle_shallow_grave_3.vpcf", PATTACH_ABSORIGIN_FOLLOW , parent)
					
					local nothl_duration = ability:GetSpecialValueFor("nothl_protection_duration")
					Timers:CreateTimer(nothl_duration, function()
					
						-- Checking if alive for cases of death that don't care for Nothl Protection 
						if parent:IsAlive() and self.shallowDamage > 0 then
							parent:Heal(self.shallowDamage, parent)
							SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self.shallowDamage, nil)
						end
						
						self.isActive = false
						self.shallowDamage = 0
						
						ParticleManager:DestroyParticle(particle, true)
						ParticleManager:ReleaseParticleIndex(particle)
						
						local nothl_cooldown = ability:GetSpecialValueFor("nothl_protection_cooldown")						
						nothl_cooldown = nothl_cooldown + parent:FindTalentValue("special_bonus_imba_dazzle_7")						
						
						self:SetStackCount(math.floor(nothl_cooldown))
						self:StartIntervalThink(1)
					end)
				
				-- If the modifier is active
				elseif self.isActive and not parent:PassivesDisabled() then
					self.shallowDamage = self.shallowDamage + damage
				end
			end
		end
	end
end

function modifier_imba_dazzle_nothl_protection:OnIntervalThink()
	local stacks = self:GetStackCount()
	if stacks > 0 then
		self:SetStackCount(stacks - 1)
	else
		self:StartIntervalThink(-1)
	end
end

function modifier_imba_dazzle_nothl_protection:OnDestroy()
	if IsServer() then
		if self.isActive then
			self:GetParent():Heal(self.shallowDamage, self:GetParent())
		end
	end
end

---------------------------------------------------------------------
-------------------------	Shadow Wave		-------------------------
---------------------------------------------------------------------
if imba_dazzle_shadow_wave == nil then imba_dazzle_shadow_wave = class({}) end
LinkLuaModifier( "modifier_imba_dazzle_shadow_wave_buff", "hero/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )		-- Allied bonus armor
LinkLuaModifier( "modifier_imba_dazzle_shadow_wave_injured_buff", "hero/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )-- Allied bonus armor

function imba_dazzle_shadow_wave:GetAbilityTextureName()
   return "dazzle_shadow_wave"
end

function imba_dazzle_shadow_wave:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK end

function imba_dazzle_shadow_wave:OnSpellStart()
	if IsServer() then
		local target = self:GetCursorTarget()
		local caster = self:GetCaster()
		
		self.healedTargets = {}
		table.insert(self.healedTargets, caster:entindex(), true)
		
		if target == caster then
			self:WaveHit(target)
			self:WaveBounce(target)
		else
			self:WaveBounce(target)
			self:WaveHit(caster)
			table.insert(self.healedTargets, target:entindex(), true)
		end
		
		EmitSoundOn("Hero_Dazzle.Shadow_Wave", self:GetCaster())
		local waveParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(waveParticle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(waveParticle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(waveParticle)
	end
end

-- Unit finder
function imba_dazzle_shadow_wave:WaveBounce(target)
	if IsServer() then
		local caster = self:GetCaster()
		local bounceDistance = self:GetSpecialValueFor("bounce_distance")
		local newTarget
		
		if caster:HasTalent("special_bonus_imba_dazzle_2") then
			bounceDistance = bounceDistance + caster:FindTalentValue("special_bonus_imba_dazzle_2")
		end
		
		-- Prioritize injured heroes, then heroes, then injured creeps, then creeps
		-- Priority changed from vanilla since the skill now applies a buff, which you'd probably prefer hitting heroes over creeps
		local heroTable = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, bounceDistance, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		local creepTable = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, bounceDistance, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		
		for _,hero in pairs(heroTable) do
			if hero:GetHealth() < hero:GetMaxHealth() and not self.healedTargets[hero:entindex()] then
				table.insert(self.healedTargets, hero:entindex(), true)
				newTarget = hero
				break
			end
		end
		
		if not newTarget then
			for _,hero in pairs(heroTable) do
				if not self.healedTargets[hero:entindex()] then
					table.insert(self.healedTargets, hero:entindex(), true)
					newTarget = hero
					break
				end
			end
		end
		
		if not newTarget then
			for _,creep in pairs(creepTable) do
				if creep:GetHealth() < creep:GetMaxHealth() and not self.healedTargets[creep:entindex()] then
					table.insert(self.healedTargets, creep:entindex(), true)
					newTarget = creep
					break
				end
			end
		end
		
		if not newTarget then
			for _,creep in pairs(creepTable) do
				if not self.healedTargets[creep:entindex()] then
					table.insert(self.healedTargets, creep:entindex(), true)
					newTarget = creep
					break
				end
			end
		end
		
		if newTarget then
			local waveParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_CUSTOMORIGIN, target)
			ParticleManager:SetParticleControlEnt(waveParticle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(waveParticle, 1, newTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", newTarget:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(waveParticle)
			
			self:WaveBounce(newTarget)
			self:WaveHit(newTarget)
		end
	end
end

-- Heal + buff + damage
function imba_dazzle_shadow_wave:WaveHit(unit)
	if IsServer() then
		local caster = self:GetCaster()
		
		local spellAmp = caster:GetSpellPower()
		local damage = self:GetSpecialValueFor("damage")
		local bonusHeal = self:GetSpecialValueFor("bonus_heal") / 100
		local damageRadius = self:GetSpecialValueFor("damage_radius")
		
		if caster:HasTalent("special_bonus_imba_dazzle_3") then
			damageRadius = damageRadius + caster:FindTalentValue("special_bonus_imba_dazzle_3")
		end
		
		if caster:HasTalent("special_bonus_imba_dazzle_4") then
			damage = damage + caster:FindTalentValue("special_bonus_imba_dazzle_4")
		end
		
		local buffDuration = self:GetSpecialValueFor("buff_duration")
		local injuredThreshold = self:GetSpecialValueFor("injured_threshold") / 100
		
		local health = unit:GetHealth()
		local maxHealth = unit:GetMaxHealth()
		local totalHeal = ((maxHealth - health) * bonusHeal + damage) * (1 + spellAmp * 0.01)
		
		if unit:FindModifierByName("modifier_imba_dazzle_shadow_wave_injured_buff") then unit:RemoveModifierByName("modifier_imba_dazzle_shadow_wave_injured_buff") end
		if unit:FindModifierByName("modifier_imba_dazzle_shadow_wave_buff") then unit:RemoveModifierByName("modifier_imba_dazzle_shadow_wave_buff") end
		
		if maxHealth * injuredThreshold >= health then
			unit:AddNewModifier(caster, self, "modifier_imba_dazzle_shadow_wave_injured_buff", {duration = buffDuration})
		else
			unit:AddNewModifier(caster, self, "modifier_imba_dazzle_shadow_wave_buff", {duration = buffDuration})
		end
		
		unit:Heal(totalHeal, caster) 
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, totalHeal, nil)
		
		-- Prioritize injured heroes, then heroes, then injured creeps, then creeps
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, damageRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		for _,enemy in pairs(enemies) do
			local damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave_impact_damage.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(damage_particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(damage_particle)
			
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
		end
	end
end

---------------------------------------
-----	Shadow Wave armor bonus	  -----
---------------------------------------
if modifier_imba_dazzle_shadow_wave_buff == nil then modifier_imba_dazzle_shadow_wave_buff = class({}) end
function modifier_imba_dazzle_shadow_wave_buff:IsPurgable() return true end
function modifier_imba_dazzle_shadow_wave_buff:IsHidden() return false end
function modifier_imba_dazzle_shadow_wave_buff:IsDebuff() return false end

function modifier_imba_dazzle_shadow_wave_buff:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,}
	return funcs
end

function modifier_imba_dazzle_shadow_wave_buff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor") end

-----------------------------------------------
-----	Shadow Wave injured armor bonus	  -----
-----------------------------------------------
if modifier_imba_dazzle_shadow_wave_injured_buff == nil then modifier_imba_dazzle_shadow_wave_injured_buff = class({}) end
function modifier_imba_dazzle_shadow_wave_injured_buff:IsPurgable() return true end
function modifier_imba_dazzle_shadow_wave_injured_buff:IsHidden() return false end
function modifier_imba_dazzle_shadow_wave_injured_buff:IsDebuff() return false end

function modifier_imba_dazzle_shadow_wave_injured_buff:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,}
	return funcs
end

function modifier_imba_dazzle_shadow_wave_injured_buff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor_injured") end

-------------------------------------------------------------
-------------------------	Weave	-------------------------
-------------------------------------------------------------
if imba_dazzle_weave == nil then imba_dazzle_weave = class({}) end
LinkLuaModifier( "modifier_imba_dazzle_weave_buff", "hero/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )	-- Allied bonus armor
LinkLuaModifier( "modifier_imba_dazzle_weave_debuff", "hero/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )-- Allied bonus armor

function imba_dazzle_weave:GetAbilityTextureName()
   return "dazzle_weave"
end

function imba_dazzle_weave:GetCooldown()
	local cooldown = self:GetSpecialValueFor("cooldown")
	if self:GetCaster():HasTalent("special_bonus_imba_dazzle_8") then
		cooldown = cooldown + self:GetCaster():FindTalentValue("special_bonus_imba_dazzle_8")
	end
	
	return cooldown
end

function imba_dazzle_weave:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE end

function imba_dazzle_weave:GetAOERadius()
	return self:GetSpecialValueFor("area_of_effect") end

function imba_dazzle_weave:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_point = self:GetCursorPosition()
		
		local area_of_effect = self:GetSpecialValueFor("area_of_effect")
		local modifier_duration = self:GetSpecialValueFor("modifier_duration")
		local vision_duration = self:GetSpecialValueFor("vision_duration")
		local vision_radius = self:GetSpecialValueFor("vision_radius")
		
		if caster:HasTalent("special_bonus_imba_dazzle_6") then
			modifier_duration = modifier_duration / 2
		end
		
		local searchTargetType = DOTA_UNIT_TARGET_HERO
		if caster:HasScepter() then
			area_of_effect = area_of_effect + self:GetSpecialValueFor("scepter_aoe_bonus")
			searchTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING
		end
		
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), target_point, nil, area_of_effect, DOTA_UNIT_TARGET_TEAM_BOTH, searchTargetType, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE , FIND_ANY_ORDER , false) 
		for _,target in pairs(targets) do
			if target:GetTeamNumber() == caster:GetTeamNumber() then
				target:AddNewModifier(caster, self, "modifier_imba_dazzle_weave_buff", {duration = modifier_duration})
			else
				target:AddNewModifier(caster, self, "modifier_imba_dazzle_weave_debuff", {duration = modifier_duration})
			end
		end
		
		self:CreateVisibilityNode(target_point, area_of_effect, vision_duration)
		EmitSoundOnLocationWithCaster(target_point, "Hero_Dazzle.Weave", caster)
		
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_weave.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(particle, 0, target_point)
		ParticleManager:SetParticleControl(particle, 1, Vector(area_of_effect,0,0))
		ParticleManager:ReleaseParticleIndex(particle)
	end
end

-----------------------------
-----	Weave ally buff	-----
-----------------------------
if modifier_imba_dazzle_weave_buff == nil then modifier_imba_dazzle_weave_buff = class({}) end
function modifier_imba_dazzle_weave_buff:IsPurgable() return false end
function modifier_imba_dazzle_weave_buff:IsHidden() return false end
function modifier_imba_dazzle_weave_buff:IsDebuff() return false end
function modifier_imba_dazzle_weave_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
	
function modifier_imba_dazzle_weave_buff:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,}
	return funcs
end

function modifier_imba_dazzle_weave_buff:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local tick_interval = self:GetAbility():GetSpecialValueFor("tick_interval")
		
		if not parent:IsBuilding() then
			if self:GetAbility():GetCaster():HasTalent("special_bonus_imba_dazzle_6") then
				tick_interval = tick_interval / 2
			end
			self:StartIntervalThink(tick_interval)
		end
		
		self.particle =  ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_armor_friend.vpcf", PATTACH_OVERHEAD_FOLLOW , parent)
		ParticleManager:SetParticleControlEnt(self.particle, 1, parent, PATTACH_POINT_FOLLOW, "follow_origin", parent:GetAbsOrigin(), true)
	end
end

function modifier_imba_dazzle_weave_buff:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

function modifier_imba_dazzle_weave_buff:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + 1)
	end
end

function modifier_imba_dazzle_weave_buff:GetModifierPhysicalArmorBonus()
	local base = self:GetAbility():GetSpecialValueFor("base_shift")
	local stacked = self:GetAbility():GetSpecialValueFor("stack_shift")
	
	if self:GetParent():IsBuilding() then
		return base
	else
		return (stacked * self:GetStackCount() + base)
	end
end

---------------------------------
-----	Weave enemy debuff	-----
---------------------------------
if modifier_imba_dazzle_weave_debuff == nil then modifier_imba_dazzle_weave_debuff = class({}) end
function modifier_imba_dazzle_weave_debuff:IsPurgable() return false end
function modifier_imba_dazzle_weave_debuff:IsHidden() return false end
function modifier_imba_dazzle_weave_debuff:IsDebuff() return false end
function modifier_imba_dazzle_weave_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_dazzle_weave_debuff:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,}
	return funcs
end

function modifier_imba_dazzle_weave_debuff:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local tick_interval = self:GetAbility():GetSpecialValueFor("tick_interval")
		
		if not parent:IsBuilding() then
			if self:GetAbility():GetCaster():HasTalent("special_bonus_imba_dazzle_6") then
				tick_interval = tick_interval / 2
			end
			self:StartIntervalThink(tick_interval)
		end
		
		self.particle =  ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_armor_enemy.vpcf", PATTACH_OVERHEAD_FOLLOW , parent)
		ParticleManager:SetParticleControlEnt(self.particle, 1, parent, PATTACH_POINT_FOLLOW, "follow_origin", parent:GetAbsOrigin(), true)
	end
end

function modifier_imba_dazzle_weave_debuff:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

function modifier_imba_dazzle_weave_debuff:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + 1)
	end
end

function modifier_imba_dazzle_weave_debuff:GetModifierPhysicalArmorBonus()
	local base = self:GetAbility():GetSpecialValueFor("base_shift")
	local stacked = self:GetAbility():GetSpecialValueFor("stack_shift")
	
	if self:GetParent():IsBuilding() then
		return base * -1
	else
		return (stacked * self:GetStackCount() + base) * -1
	end
end

for i = 1,8 do
	LinkLuaModifier("modifier_special_bonus_imba_dazzle_"..i, "hero/hero_dazzle", LUA_MODIFIER_MOTION_NONE)
end

modifier_special_bonus_imba_dazzle_1 = class({
	IsHidden      = function(self) return true  end,
	RemoveOnDeath = function(self) return false end })
	
modifier_special_bonus_imba_dazzle_2 = class({
	IsHidden      = function(self) return true  end,
	RemoveOnDeath = function(self) return false end })
	
modifier_special_bonus_imba_dazzle_3 = class({
	IsHidden      = function(self) return true  end,
	RemoveOnDeath = function(self) return false end })
	
modifier_special_bonus_imba_dazzle_4 = class({
	IsHidden      = function(self) return true  end,
	RemoveOnDeath = function(self) return false end })
	
modifier_special_bonus_imba_dazzle_5 = class({
	IsHidden      = function(self) return true  end,
	RemoveOnDeath = function(self) return false end })
	
modifier_special_bonus_imba_dazzle_6 = class({
	IsHidden      = function(self) return true  end,
	RemoveOnDeath = function(self) return false end })
	
modifier_special_bonus_imba_dazzle_7 = class({
	IsHidden      = function(self) return true  end,
	RemoveOnDeath = function(self) return false end })
	
modifier_special_bonus_imba_dazzle_8 = class({
	IsHidden      = function(self) return true  end,
	RemoveOnDeath = function(self) return false end })