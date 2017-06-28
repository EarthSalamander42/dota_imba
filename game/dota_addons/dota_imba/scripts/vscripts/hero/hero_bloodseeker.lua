CreateEmptyTalents("bloodseeker")
local LinkedModifiers = {}
-------------------------------------------
--				BLOOD RAGE
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_bloodrage_buff_stats"] = LUA_MODIFIER_MOTION_NONE,
})
imba_bloodseeker_bloodrage = imba_bloodseeker_bloodrage or class({})

function imba_bloodseeker_bloodrage:GetAbilityTextureName()
   return "bloodseeker_bloodrage"
end

function imba_bloodseeker_bloodrage:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	local caster = self:GetCaster()
	if hTarget:TriggerSpellAbsorb(self) then return end --if target has spell absorption, stop.
	hTarget:AddNewModifier(caster, self, "modifier_imba_bloodrage_buff_stats", {duration = self:GetSpecialValueFor("duration")})
	EmitSoundOn("hero_bloodseeker.bloodRage", hTarget)
end
modifier_imba_bloodrage_buff_stats = modifier_imba_bloodrage_buff_stats or class({})

if IsServer() then
	function modifier_imba_bloodrage_buff_stats:OnCreated()
		self.ampin = self:GetAbility():GetSpecialValueFor("damage_increase_pct")
		self.ampout = self:GetAbility():GetSpecialValueFor("damage_increase_pct")
		self.damageout = self:GetAbility():GetSpecialValueFor("damage_increase_pct")
		self.damage = self:GetAbility():GetSpecialValueFor("aoe_damage")
		self.radius = self:GetAbility():GetSpecialValueFor("aoe_radius")
		self.alliedpct = self:GetAbility():GetSpecialValueFor("allied_damage") / 100
		if self:GetCaster():HasTalent("special_bonus_imba_bloodseeker_1") then
			if self:GetParent():GetTeam() == self:GetCaster():GetTeam() then
				self.ampin = self.ampin - self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_1")
				self.ampout = self.ampout + self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_1")
			else
				self.ampin = self.ampin + self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_1")
				self.ampout = self.ampout -	self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_1")
			end
		end
		self:StartIntervalThink(1)
	end

	function modifier_imba_bloodrage_buff_stats:IsHidden() return false end
	function modifier_imba_bloodrage_buff_stats:IsPurgable() return true end	
	
	function modifier_imba_bloodrage_buff_stats:OnRefresh()
		self.ampin = self:GetAbility():GetSpecialValueFor("damage_increase_pct")
		self.ampout = self:GetAbility():GetSpecialValueFor("damage_increase_pct")
		self.damageout = self:GetAbility():GetSpecialValueFor("damage_increase_pct")
		self.damage = self:GetAbility():GetSpecialValueFor("aoe_damage")
		self.alliedpct = self:GetAbility():GetSpecialValueFor("allied_damage") * 0.01
		self.radius = self:GetAbility():GetSpecialValueFor("aoe_radius")
		if self:GetCaster():HasTalent("special_bonus_imba_bloodseeker_1") then
			if self:GetParent():GetTeam() == self:GetCaster():GetTeam() then
				self.ampin = self.ampin - self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_1")
				self.ampout = self.ampout + self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_1")
			else
				self.ampin = self.ampin + self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_1")
				self.ampout = self.ampout -	self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_1")
			end
		end
	end
	
	function modifier_imba_bloodrage_buff_stats:OnIntervalThink()
		local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		for _,target in pairs(targets) do
			local damage = self.damage
			if target:GetTeam() == self:GetCaster():GetTeam() then damage = damage * self.alliedpct end

			if target:GetTeam() == self:GetParent():GetTeam() then
				ApplyDamage({victim = target, attacker = self:GetCaster(), damage = damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
			else
				ApplyDamage({victim = target, attacker = self:GetParent(), damage = damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
			end
		end
	end
	
	function modifier_imba_bloodrage_buff_stats:DeclareFunctions()
		local funcs = {
			MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE ,
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE ,
			MODIFIER_EVENT_ON_DEATH,
		}
		return funcs
	end
	function modifier_imba_bloodrage_buff_stats:GetModifierTotalDamageOutgoing_Percentage(params)
		if params.attacker == self:GetParent() then
			local outamp = self.ampout
			if CalcDistanceBetweenEntityOBB(params.target, params.attacker) > self:GetAbility():GetSpecialValueFor("red_val_distance") then
				outamp = outamp * self:GetAbility():GetSpecialValueFor("red_val_amount") / 100
			end
			if self:GetCaster():HasTalent("special_bonus_imba_bloodseeker_8") then
				local ampPct = self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_8", "value") / self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_8", "value2") -- find amp per pct
				local hpPct = (1 - self:GetParent():GetHealth() / self:GetParent():GetMaxHealth()) * 100 -- missing hp in pct
				outamp = outamp + ampPct * hpPct
			end
			return outamp
		end
	end
	function modifier_imba_bloodrage_buff_stats:GetModifierIncomingDamage_Percentage(params)
		if params.target == self:GetParent() then
			local inamp = self.ampin
			if CalcDistanceBetweenEntityOBB(params.target, params.attacker) > self:GetAbility():GetSpecialValueFor("red_val_distance") then
				inamp = inamp * self:GetAbility():GetSpecialValueFor("red_val_amount") / 100
			end
			if self:GetCaster():HasTalent("special_bonus_imba_bloodseeker_8") then
				local ampPct = self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_8", "value") / self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_8", "value2") -- find amp per pct
				local hpPct = (1 - self:GetParent():GetHealth() / self:GetParent():GetMaxHealth()) * 100 -- missing hp in pct
				inamp = inamp + ampPct * hpPct
			end
			return inamp
		end
	end
	function modifier_imba_bloodrage_buff_stats:OnDeath(params)
		if (params.attacker == self:GetParent() or params.unit == self:GetParent()) and params.attacker ~= params.unit then

			-- If the dead target is a building, do nothing
			if params.unit:IsBuilding() then
				return nil
			end

			local heal = params.unit:GetMaxHealth() * self:GetAbility():GetSpecialValueFor("health_bonus_pct") / 100
			SendOverheadEventMessage( self:GetCaster():GetOwner(), OVERHEAD_ALERT_HEAL , self:GetParent(), heal, self:GetCaster() )
			params.attacker:Heal(heal, self:GetCaster())
			local healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
			ParticleManager:ReleaseParticleIndex(healFX)
		end
	end
end

function modifier_imba_bloodrage_buff_stats:GetEffectName()
	return "particles/hero/bloodseeker/bloodseeker_boiling_blood.vpcf"
end

function modifier_imba_bloodrage_buff_stats:GetStatusEffectName()
	return "particles/status_fx/status_effect_bloodrage.vpcf"
end

function modifier_imba_bloodrage_buff_stats:StatusEffectPriority()
	return 8
end
-------------------------------------------
--				BLOOD RITE
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_blood_bath_buff_stats"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_blood_bath_debuff_silence"] = LUA_MODIFIER_MOTION_NONE,
})
imba_bloodseeker_blood_bath = imba_bloodseeker_blood_bath or class({})

function imba_bloodseeker_blood_bath:GetAbilityTextureName()
   return "bloodseeker_blood_bath"
end

function imba_bloodseeker_blood_bath:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_bloodseeker_blood_bath:OnSpellStart()
	local vPos = self:GetCursorPosition()
	local caster = self:GetCaster()
	
	AddFOWViewer(caster:GetTeamNumber(),vPos,self:GetSpecialValueFor("vision_aoe"),self:GetSpecialValueFor("vision_duration"),true)   --gives ground vision
	local radius = self:GetSpecialValueFor("radius")
	EmitSoundOn("Hero_Bloodseeker.BloodRite.Cast", caster)
	EmitSoundOnLocationWithCaster( vPos, "Hero_Bloodseeker.BloodRite", caster )
	local bloodriteFX = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_ring.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( bloodriteFX, 0, vPos )
		ParticleManager:SetParticleControl( bloodriteFX, 1, Vector(radius, radius, radius) )
		ParticleManager:SetParticleControl( bloodriteFX, 3, vPos )
	Timers:CreateTimer(self:GetSpecialValueFor("delay"), function()
		EmitSoundOnLocationWithCaster( vPos, "hero_bloodseeker.bloodRite.silence", caster )
		ParticleManager:DestroyParticle(bloodriteFX, false)
		ParticleManager:ReleaseParticleIndex(bloodriteFX)
		local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), vPos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

		if #targets > 0 then
			local overheal = caster:AddNewModifier(caster, self, "modifier_imba_blood_bath_buff_stats", {duration = self:GetSpecialValueFor("overheal_duration")})
		end

		local rupture = false
		if caster:HasScepter() and caster:HasAbility("imba_bloodseeker_rupture") then
			rupture = caster:FindAbilityByName("imba_bloodseeker_rupture")
		end
		
		for _,target in pairs(targets) do
			local damage = self:GetSpecialValueFor("damage")
			target:AddNewModifier(caster, self, "modifier_imba_blood_bath_debuff_silence", {duration = self:GetSpecialValueFor("silence_duration")})
			if rupture then
				if rupture:GetLevel() >= 1 then
					rupture:OnSpellStart(target)
				end
				local distance = radius - (target:GetAbsOrigin() - vPos):Length2D()
				local knockback =
				{
					should_stun = false,
					knockback_duration = 0.3,
					duration = 0.3,
					knockback_distance = distance,
					knockback_height = 0,
					center_x = vPos.x,
					center_y = vPos.y,
					center_z = vPos.z
				}
				target:RemoveModifierByName("modifier_knockback")
				target:AddNewModifier(caster, self, "modifier_knockback", knockback)
			end
			ApplyDamage({victim = target, attacker = self:GetCaster(), damage = damage, damage_type = self:GetAbilityDamageType(), ability = self})
		end
	end)
end


modifier_imba_blood_bath_debuff_silence = modifier_imba_blood_bath_debuff_silence or class({})

if IsServer() then
	function modifier_imba_blood_bath_debuff_silence:OnCreated()
		self.cdr = 1 - self:GetAbility():GetTalentSpecialValueFor("cooldown_reduction") / 100
	end
	function modifier_imba_blood_bath_debuff_silence:OnRefresh()
		self.cdr = 1 - self:GetAbility():GetTalentSpecialValueFor("cooldown_reduction") / 100
	end
	function modifier_imba_blood_bath_debuff_silence:DeclareFunctions()
		local funcs = {
			MODIFIER_EVENT_ON_DEATH,
		}
		return funcs
	end
	function modifier_imba_blood_bath_debuff_silence:OnDeath(params)
		if params.unit == self:GetParent() and params.unit:IsRealHero() then
			for i = 0, 16 do
				local ability = self:GetCaster():GetAbilityByIndex(i)
				if ability and not ability:IsCooldownReady() then
					local cd = ability:GetCooldownTimeRemaining()
					ability:EndCooldown()
					ability:StartCooldown(cd * self.cdr)
				end
			end
		end
	end
end

function modifier_imba_blood_bath_debuff_silence:IsHidden() return false end
function modifier_imba_blood_bath_debuff_silence:IsPurgable() return true end
function modifier_imba_blood_bath_debuff_silence:IsDebuff() return true end

function modifier_imba_blood_bath_debuff_silence:CheckState()
	return {[MODIFIER_STATE_SILENCED] = true}
end

function modifier_imba_blood_bath_debuff_silence:GetEffectName()
	return "particles/generic_gameplay/generic_silence.vpcf"
end

function modifier_imba_blood_bath_debuff_silence:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


modifier_imba_blood_bath_buff_stats = modifier_imba_blood_bath_buff_stats or class({})

function modifier_imba_blood_bath_buff_stats:IsHidden()
	return false
end

function modifier_imba_blood_bath_buff_stats:OnCreated()
	self.caster = self:GetCaster()
	self.overheal = self:GetAbility():GetSpecialValueFor("dmg_to_overheal") * 0.01
	self.particle_overheal = "particles/hero/bloodseeker/blood_bath_power.vpcf"

	local particle_overheal_fx = ParticleManager:CreateParticle(self.particle_overheal, PATTACH_OVERHEAD_FOLLOW, self.caster)
	ParticleManager:SetParticleControl(particle_overheal_fx, 0, self.caster:GetAbsOrigin())
	self:AddParticle(particle_overheal_fx, false, false, -1, false, true)
end

function modifier_imba_blood_bath_buff_stats:OnRefresh()
	self.overheal = self:GetAbility():GetSpecialValueFor("dmg_to_overheal") * 0.01
	self:SetStackCount(0)
end

function modifier_imba_blood_bath_buff_stats:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end
	
function modifier_imba_blood_bath_buff_stats:OnTakeDamage(params)
	if params.attacker == self:GetParent() and params.inflictor == self:GetAbility() then
		local bonusHP = params.damage * self.overheal
		self:SetStackCount(self:GetStackCount() + bonusHP)
		self:GetParent():CalculateStatBonus()
		self:GetParent():Heal(bonusHP, self:GetParent())
	end
end	

function modifier_imba_blood_bath_buff_stats:GetModifierExtraHealthBonus(params)
	return self:GetStackCount()
end
-------------------------------------------
--				THIRST
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_thirst_debuff_vision"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_thirst_passive"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_thirst_haste"] = LUA_MODIFIER_MOTION_NONE,
})
imba_bloodseeker_thirst = imba_bloodseeker_thirst or class({})

function imba_bloodseeker_thirst:GetAbilityTextureName()
   return "bloodseeker_thirst"
end

function imba_bloodseeker_thirst:GetIntrinsicModifierName()
	return "modifier_imba_thirst_passive"
end

modifier_imba_thirst_passive = modifier_imba_thirst_passive or class({})

function modifier_imba_thirst_passive:IsHidden()
	return true
end

function modifier_imba_thirst_passive:OnCreated()	
	self.minhp = self:GetAbility():GetSpecialValueFor("max_threshold_pct")
	self.maxhp = self:GetAbility():GetSpecialValueFor("visibility_threshold_pct")
	self.movespeed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed") / (self.minhp - self.maxhp)
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage") / (self.minhp - self.maxhp)
	self.deathstick = self:GetAbility():GetSpecialValueFor("stick_time")
	self:StartIntervalThink(0.1)
end

function modifier_imba_thirst_passive:OnRefresh()
	self.minhp = self:GetAbility():GetSpecialValueFor("max_threshold_pct")
	self.maxhp = self:GetAbility():GetSpecialValueFor("visibility_threshold_pct")
	self.movespeed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed") / (self.minhp - self.maxhp)
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage") / (self.minhp - self.maxhp)
	self.deathstick = self:GetAbility():GetSpecialValueFor("stick_time")
	self.talent7 = false
	if IsServer() then
		if self:GetParent():HasTalent("special_bonus_imba_bloodseeker_7") then
			self.movespeed = self.movespeed + self:GetParent():FindTalentValue("special_bonus_imba_bloodseeker_7", "value") / (self.minhp - self.maxhp)
			self.damage = self.damage + self:GetParent():FindTalentValue("special_bonus_imba_bloodseeker_7", "value2") / (self.minhp - self.maxhp)
			CustomNetTables:SetTableValue("talents", "hero_bloodseeker_talents", {talent7_ms = self.movespeed, talent7_dmg = self.damage})
		end
	end
end

function modifier_imba_thirst_passive:OnIntervalThink()
	if IsServer() then		

		if not self.talent7 then
			if self:GetParent():HasTalent("special_bonus_imba_bloodseeker_7") then
				self.talent7 = true
				self.movespeed = self.movespeed + self:GetParent():FindTalentValue("special_bonus_imba_bloodseeker_7", "value")  / (self.minhp - self.maxhp)
				self.damage = self.damage + self:GetParent():FindTalentValue("special_bonus_imba_bloodseeker_7", "value2")  / (self.minhp - self.maxhp)
				CustomNetTables:SetTableValue("talents", "hero_bloodseeker_talents", {talent7_ms = self.movespeed, talent7_dmg = self.damage})
			end
		end
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false)
		local hpDeficit = 0
		for _,enemy in pairs(enemies) do			
			if self:GetCaster():PassivesDisabled() or not self:GetCaster():IsAlive() then 
				enemy:RemoveModifierByName("modifier_imba_thirst_debuff_vision")
			else


				if enemy:IsAlive() or (not enemy:IsAlive() and enemy.thirstDeathTimer < self.deathstick) then
					if enemy:GetHealthPercent() < self.minhp then
						local enemyHp = (self.minhp - enemy:GetHealthPercent())
						if enemyHp > (self.minhp - self.maxhp) then 
							enemyHp = (self.minhp - self.maxhp)
							enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_thirst_debuff_vision", {})
						elseif enemy:HasModifier("modifier_imba_thirst_debuff_vision") then
							enemy:RemoveModifierByName("modifier_imba_thirst_debuff_vision")
						end
						if not enemy:IsAlive() then 
							enemy.thirstDeathTimer = enemy.thirstDeathTimer + 0.1
						else enemy.thirstDeathTimer = 0 end
						hpDeficit = hpDeficit + enemyHp
					end
				end
			end
		end
		self:SetStackCount(hpDeficit)
	else
		if CustomNetTables:GetTableValue( "talents", "hero_bloodseeker_talents") and not self.talent7 then
			self.movespeed = CustomNetTables:GetTableValue( "talents", "hero_bloodseeker_talents").talent7_ms
			self.damage = CustomNetTables:GetTableValue( "talents", "hero_bloodseeker_talents").talent7_dmg
			self.talent7 = true
		end
	end
end

function modifier_imba_thirst_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_MAX
	}
	return funcs
end

function modifier_imba_thirst_passive:GetModifierPreAttack_BonusDamage(params)
	return self:GetStackCount() * self.damage
end

function modifier_imba_thirst_passive:GetModifierMoveSpeedBonus_Percentage(params)
	return self:GetStackCount() * self.movespeed
end

function modifier_imba_thirst_passive:GetModifierMoveSpeed_Max()
	return 5000
end

function modifier_imba_thirst_passive:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf"
end

function modifier_imba_thirst_passive:OnTakeDamage(params)
	if IsServer() then
		if params.attacker:GetTeam() == self:GetCaster():GetTeam() and params.unit:GetTeam() ~= self:GetCaster():GetTeam() and params.attacker:IsRealHero() and params.unit:IsRealHero() then
			local duration = self:GetAbility():GetTalentSpecialValueFor("atk_buff_duration")
			local attackList = self:GetCaster():FindAllModifiersByName("modifier_imba_thirst_haste")
			local confirmTheKill = false
			for _,modifier in pairs(attackList) do
				if modifier.sourceUnit == params.unit then
					attackerCount = 1
					if params.attacker == self:GetCaster() then attackerCount = 2 end
					confirmTheKill = true
					if modifier:GetStackCount() <= attackerCount then
						modifier:SetStackCount(attackerCount)						
					end
					modifier:SetDuration(duration, true)
					break
				end
			end
			if not confirmTheKill then
				local modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_thirst_haste", {duration = duration})
				modifier.sourceUnit = params.unit
				attackerCount = 1
				if params.attacker == self:GetCaster() then attackerCount = 2 end
				if modifier:GetStackCount() <= attackerCount then
					modifier:SetStackCount(attackerCount)
				end
			end
		end
	end
end


modifier_imba_thirst_haste = modifier_imba_thirst_haste or class({})

function modifier_imba_thirst_haste:OnCreated()
	self.movespeed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed_atk")
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage_atk")
end

function modifier_imba_thirst_haste:OnRefresh()
	self.movespeed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed_atk")
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage_atk")
end

function modifier_imba_thirst_haste:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_thirst_haste:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,		
	}
	return funcs
end

function modifier_imba_thirst_haste:GetModifierPreAttack_BonusDamage(params)
	return self:GetStackCount() * self.damage
end

function modifier_imba_thirst_haste:GetModifierMoveSpeedBonus_Percentage(params)
	return self:GetStackCount() * self.movespeed
end

function modifier_imba_thirst_haste:IsHidden()
	return true
end


modifier_imba_thirst_debuff_vision = modifier_imba_thirst_debuff_vision or class({})

function modifier_imba_thirst_debuff_vision:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}
	return funcs
	
end

function modifier_imba_thirst_debuff_vision:GetModifierProvidesFOWVision()
return 1
end

function modifier_imba_thirst_debuff_vision:CheckState()
	local state = {[MODIFIER_STATE_INVISIBLE] = false,}
	return state
end

function modifier_imba_thirst_debuff_vision:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_imba_thirst_debuff_vision:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_vision.vpcf"
end

function modifier_imba_thirst_debuff_vision:GetStatusEffectName()
	return "particles/status_fx/status_effect_thirst_vision.vpcf"
end

function modifier_imba_thirst_debuff_vision:StatusEffectPriority()
	return 8
end

-------------------------------------------
--				RUPTURE
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_rupture_debuff_dot"] = LUA_MODIFIER_MOTION_NONE,
})

imba_bloodseeker_rupture = imba_bloodseeker_rupture or class({})

function imba_bloodseeker_rupture:GetAbilityTextureName()
   return "bloodseeker_rupture"
end

function imba_bloodseeker_rupture:OnSpellStart(target)
	local hTarget = target or self:GetCursorTarget()
	local caster = self:GetCaster()
	if hTarget:TriggerSpellAbsorb(self) then return end --if target has spell absorption, stop.
	if target then
		hTarget:AddNewModifier(caster, self, "modifier_imba_rupture_debuff_dot", {duration = 0.3})
	else
		hTarget:AddNewModifier(caster, self, "modifier_imba_rupture_debuff_dot", {duration = self:GetSpecialValueFor("duration")})
		EmitSoundOn("hero_bloodseeker.rupture.cast", caster)
		EmitSoundOn("hero_bloodseeker.rupture", hTarget)
	end
	if hTarget:GetHealthPercent() > self:GetSpecialValueFor("damage_initial_pct") then
		local hpBurn = hTarget:GetHealthPercent() - self:GetSpecialValueFor("damage_initial_pct")
		ApplyDamage({victim = hTarget, attacker = caster, damage = hTarget:GetMaxHealth() * hpBurn / 100, damage_type = self:GetAbilityDamageType(), ability = self})
		if self:GetCaster():HasTalent("special_bonus_imba_bloodseeker_3") then 
			caster:Heal(hpBurn, caster)
			local healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_POINT_FOLLOW, caster)
			ParticleManager:ReleaseParticleIndex(healFX)
		end
	end
end

modifier_imba_rupture_debuff_dot = modifier_imba_rupture_debuff_dot or class({})
-- Rupture is undispellable.
function modifier_imba_rupture_debuff_dot:IsPurgable()
    return false
end
if IsServer() then
	function modifier_imba_rupture_debuff_dot:OnCreated()
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		self.movedamage = self.ability:GetSpecialValueFor("movement_damage_pct") / 100
		self.attackdamage = self.ability:GetSpecialValueFor("attack_damage")
		self.castdamage = self.ability:GetSpecialValueFor("cast_damage")
		if self.caster:HasTalent("special_bonus_imba_bloodseeker_5") then
			self.attackdamage = self.attackdamage + self.attackdamage * self.caster:FindTalentValue("special_bonus_imba_bloodseeker_5") * 0.01
			self.castdamage = self.castdamage + self.castdamage * self.caster:FindTalentValue("special_bonus_imba_bloodseeker_5") * 0.01
		end
		self.damagecap = self.ability:GetTalentSpecialValueFor("damage_cap_amount")
		self.prevLoc = self.parent:GetAbsOrigin()
		self:StartIntervalThink( self:GetAbility():GetSpecialValueFor("damage_cap_interval") )
	end

	function modifier_imba_rupture_debuff_dot:OnRefresh()
		self.movedamage = self:GetAbility():GetSpecialValueFor("movement_damage_pct") / 100
		self.attackdamage = self:GetAbility():GetSpecialValueFor("attack_damage")
		self.castdamage = self:GetAbility():GetSpecialValueFor("cast_damage")
		if self.caster:HasTalent("special_bonus_imba_bloodseeker_5") then
			self.attackdamage = self.attackdamage + self.attackdamage * self.caster:FindTalentValue("special_bonus_imba_bloodseeker_5") * 0.01
			self.castdamage = self.castdamage + self.castdamage * self.caster:FindTalentValue("special_bonus_imba_bloodseeker_5") * 0.01
		end
		self.damagecap = self:GetAbility():GetSpecialValueFor("damage_cap_amount")
	end
	
	function modifier_imba_rupture_debuff_dot:OnIntervalThink()
		if CalculateDistance(self.prevLoc, self.parent) < self.damagecap then
			local move_damage = CalculateDistance(self.prevLoc, self.parent) * self.movedamage
			if move_damage > 0 then
				ApplyDamage({victim = self.parent, attacker = self.caster, damage = move_damage, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability})
				if self.caster:HasTalent("special_bonus_imba_bloodseeker_3") then 
					self.caster:Heal(move_damage, self.caster) 
					local healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_POINT_FOLLOW, self.caster)
					ParticleManager:ReleaseParticleIndex(healFX)
				end
			end
		end
		self.prevLoc = self:GetParent():GetAbsOrigin()
	end
	
	function modifier_imba_rupture_debuff_dot:DeclareFunctions()
        local funcs = {
            MODIFIER_EVENT_ON_ABILITY_START,
			MODIFIER_EVENT_ON_ATTACK_START,
        }

        return funcs
    end
	
	function modifier_imba_rupture_debuff_dot:OnAbilityStart(params)
        if params.unit == self.parent then
			ApplyDamage({victim = self.parent, attacker = self.caster, damage = self.castdamage, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability})
			if self.caster:HasTalent("special_bonus_imba_bloodseeker_3") then 
				self.caster:Heal(self.castdamage, self.caster) 
				local healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_POINT_FOLLOW, self.caster)
				ParticleManager:ReleaseParticleIndex(healFX)
			end
		end
    end
	
	function modifier_imba_rupture_debuff_dot:OnAttackStart(params)
        if params.attacker == self.parent then
			ApplyDamage({victim = self.parent, attacker = self.caster, damage = self.castdamage, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability})
			if self.caster:HasTalent("special_bonus_imba_bloodseeker_3") then 
				self.caster:Heal(self.castdamage, self.caster) 
				local healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_POINT_FOLLOW, self.caster)
				ParticleManager:ReleaseParticleIndex(healFX)
			end
		end
    end
end

function modifier_imba_rupture_debuff_dot:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end

--------------------------------------------------------------------------------
for LinkedModifier, MotionController in pairs(LinkedModifiers) do
	LinkLuaModifier(LinkedModifier, "hero/hero_bloodseeker", MotionController)
end