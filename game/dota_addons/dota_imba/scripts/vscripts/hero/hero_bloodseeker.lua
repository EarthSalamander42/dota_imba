imba_bloodseeker_bloodrage = imba_bloodseeker_bloodrage or class({})
function imba_bloodseeker_bloodrage:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	local caster = self:GetCaster()
	hTarget:AddNewModifier(caster, self, "modifier_imba_bloodseeker_bloodrage", {duration = self:GetSpecialValueFor("duration")})
	EmitSoundOn("hero_bloodseeker.bloodRage", hTarget)
end


LinkLuaModifier("modifier_imba_bloodseeker_bloodrage", "hero/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
modifier_imba_bloodseeker_bloodrage = class({})

if IsServer() then
	function modifier_imba_bloodseeker_bloodrage:OnCreated()
		self.ampin = self:GetAbility():GetSpecialValueFor("damage_increase_pct")
		self.ampout = self:GetAbility():GetSpecialValueFor("damage_increase_pct")
		self.damageout = self:GetAbility():GetSpecialValueFor("damage_increase_pct")
		self.damage = self:GetAbility():GetSpecialValueFor("aoe_damage")
		self.radius = self:GetAbility():GetSpecialValueFor("aoe_radius")
		self.alliedpct = self:GetAbility():GetSpecialValueFor("allied_damage") / 100
		if self:GetCaster():HasTalent("special_bonus_unique_bloodseeker_1") then
			if self:GetParent():GetTeam() == self:GetCaster():GetTeam() then
				self.ampin = self.ampin - self:GetCaster():FindTalentValue("special_bonus_unique_bloodseeker_1")
				self.ampout = self.ampout + self:GetCaster():FindTalentValue("special_bonus_unique_bloodseeker_1")
			else
				self.ampin = self.ampin + self:GetCaster():FindTalentValue("special_bonus_unique_bloodseeker_1")
				self.ampout = self.ampout -	self:GetCaster():FindTalentValue("special_bonus_unique_bloodseeker_1")
			end
		end
		self:StartIntervalThink(1)
	end
	
	function modifier_imba_bloodseeker_bloodrage:OnRefresh()
		self.ampin = self:GetAbility():GetSpecialValueFor("damage_increase_pct")
		self.ampout = self:GetAbility():GetSpecialValueFor("damage_increase_pct")
		self.damageout = self:GetAbility():GetSpecialValueFor("damage_increase_pct")
		self.damage = self:GetAbility():GetSpecialValueFor("aoe_damage")
		self.alliedpct = self:GetAbility():GetSpecialValueFor("allied_damage") / 100
		self.radius = self:GetAbility():GetSpecialValueFor("aoe_radius")
		if self:GetCaster():HasTalent("special_bonus_unique_bloodseeker_1") then
			if self:GetParent():GetTeam() == self:GetCaster():GetTeam() then
				self.ampin = self.ampin - self:GetCaster():FindTalentValue("special_bonus_unique_bloodseeker_1")
				self.ampout = self.ampout + self:GetCaster():FindTalentValue("special_bonus_unique_bloodseeker_1")
			else
				self.ampin = self.ampin + self:GetCaster():FindTalentValue("special_bonus_unique_bloodseeker_1")
				self.ampout = self.ampout -	self:GetCaster():FindTalentValue("special_bonus_unique_bloodseeker_1")
			end
		end
	end
	
	function modifier_imba_bloodseeker_bloodrage:OnIntervalThink()
		local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		for _,target in pairs(targets) do
			local damage = self.damage
			if target:GetTeam() == self:GetCaster():GetTeam() then damage = damage * self.alliedpct end
			ApplyDamage({victim = target, attacker = self:GetParent(), damage = damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
		end
	end
	
	function modifier_imba_bloodseeker_bloodrage:DeclareFunctions()
		local funcs = {
			MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE ,
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE ,
			MODIFIER_EVENT_ON_DEATH,
		}
		return funcs
	end
	function modifier_imba_bloodseeker_bloodrage:GetModifierTotalDamageOutgoing_Percentage(params)
		if params.attacker == self:GetParent() then
			local outamp = self.ampout
			if CalcDistanceBetweenEntityOBB(params.target, params.attacker) > self:GetAbility():GetSpecialValueFor("red_val_distance") then
				outamp = outamp * self:GetAbility():GetSpecialValueFor("red_val_amount") / 100
			end
			if self:GetCaster():HasTalent("special_bonus_unique_bloodseeker_8") then
				local ampPct = self:GetCaster():FindSpecificTalentValue("special_bonus_unique_bloodseeker_8", "value") / self:GetCaster():FindSpecificTalentValue("special_bonus_unique_bloodseeker_8", "value2") -- find amp per pct
				local hpPct = (1 - self:GetParent():GetHealth() / self:GetParent():GetMaxHealth()) * 100 -- missing hp in pct
				outamp = outamp + ampPct * hpPct
			end
			return outamp
		end
	end
	function modifier_imba_bloodseeker_bloodrage:GetModifierIncomingDamage_Percentage(params)
		if params.target == self:GetParent() then
			local inamp = self.ampin
			if CalcDistanceBetweenEntityOBB(params.target, params.attacker) > self:GetAbility():GetSpecialValueFor("red_val_distance") then
				inamp = inamp * self:GetAbility():GetSpecialValueFor("red_val_amount") / 100
			end
			if self:GetCaster():HasTalent("special_bonus_unique_bloodseeker_8") then
				local ampPct = self:GetCaster():FindSpecificTalentValue("special_bonus_unique_bloodseeker_8", "value") / self:GetCaster():FindSpecificTalentValue("special_bonus_unique_bloodseeker_8", "value2") -- find amp per pct
				local hpPct = (1 - self:GetParent():GetHealth() / self:GetParent():GetMaxHealth()) * 100 -- missing hp in pct
				inamp = inamp + ampPct * hpPct
			end
			return inamp
		end
	end
	function modifier_imba_bloodseeker_bloodrage:OnDeath(params)
		if (params.attacker == self:GetParent() or params.unit == self:GetParent()) and params.attacker ~= params.unit then
			local heal = params.unit:GetMaxHealth() * self:GetAbility():GetSpecialValueFor("health_bonus_pct") / 100
			SendOverheadEventMessage( self:GetCaster():GetOwner(), OVERHEAD_ALERT_HEAL , self:GetParent(), heal, self:GetCaster() )
			params.attacker:Heal(heal, self:GetCaster())
			local healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
			ParticleManager:ReleaseParticleIndex(healFX)
		end
	end
end

function modifier_imba_bloodseeker_bloodrage:GetEffectName()
	return "particles/hero/bloodseeker/bloodseeker_boiling_blood.vpcf"
end

function modifier_imba_bloodseeker_bloodrage:GetStatusEffectName()
	return "particles/status_fx/status_effect_bloodrage.vpcf"
end

function modifier_imba_bloodseeker_bloodrage:StatusEffectPriority()
	return 8
end
--------------------------------------------------------------------------------

imba_bloodseeker_blood_bath = imba_bloodseeker_blood_bath or class({})

function imba_bloodseeker_blood_bath:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_bloodseeker_blood_bath:OnSpellStart()
	local vPos = self:GetCursorPosition()
	local caster = self:GetCaster()
	
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
		local overheal = caster:AddNewModifier(caster, self, "modifier_imba_bloodseeker_blood_bath_overheal", {duration = self:GetSpecialValueFor("overheal_duration")})
		for _,target in pairs(targets) do
			local damage = self:GetSpecialValueFor("damage")
			target:AddNewModifier(caster, self, "modifier_imba_bloodseeker_blood_bath_silence", {duration = self:GetSpecialValueFor("silence_duration")})
			
			ApplyDamage({victim = target, attacker = self:GetCaster(), damage = damage, damage_type = self:GetAbilityDamageType(), ability = self})
		end
	end)
end

LinkLuaModifier("modifier_imba_bloodseeker_blood_bath_silence", "hero/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
modifier_imba_bloodseeker_blood_bath_silence = class({})

if IsServer() then
	function modifier_imba_bloodseeker_blood_bath_silence:OnCreated()
		self.cdr = 1 - self:GetAbility():GetTalentSpecialValueFor("cooldown_reduction") / 100
	end
	function modifier_imba_bloodseeker_blood_bath_silence:OnRefresh()
		self.cdr = 1 - self:GetAbility():GetTalentSpecialValueFor("cooldown_reduction") / 100
	end
	function modifier_imba_bloodseeker_blood_bath_silence:DeclareFunctions()
		local funcs = {
			MODIFIER_EVENT_ON_DEATH,
		}
		return funcs
	end
	function modifier_imba_bloodseeker_blood_bath_silence:OnDeath(params)
		if params.unit == self:GetParent() and params.unit:IsRealHero() then
			for i = 0, 16 do
				local ability = self:GetCaster():GetAbilityByIndex(i)
				if ability and not ability:IsCooldownReady() then
					local cd = ability:GetCooldownTimeRemaining()
					ability:EndCooldown()
					ability:StartCooldown(cd * self.cdr)
				end
				if ability and ability:GetName() == "imba_bloodseeker_rupture" and self:GetCaster():HasScepter() then
					local charges = self:GetCaster():FindModifierByName("")
					charges:SetDuration(charges:GetRemainingTime()/2, true)
					charges:Update()
				end
			end
		end
	end
end

function modifier_imba_bloodseeker_blood_bath_silence:CheckState()
	return {[MODIFIER_STATE_SILENCED] = true}
end

function modifier_imba_bloodseeker_blood_bath_silence:GetEffectName()
	return "particles/generic_gameplay/generic_silence.vpcf"
end

function modifier_imba_bloodseeker_blood_bath_silence:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

LinkLuaModifier("modifier_imba_bloodseeker_blood_bath_overheal", "hero/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
modifier_imba_bloodseeker_blood_bath_overheal = class({})

function modifier_imba_bloodseeker_blood_bath_overheal:IsHidden()
	return true
end

function modifier_imba_bloodseeker_blood_bath_overheal:OnCreated()
	self.overheal = self:GetAbility():GetSpecialValueFor("dmg_to_overheal") / 100
end

function modifier_imba_bloodseeker_blood_bath_overheal:OnRefresh()
	self.overheal = self:GetAbility():GetSpecialValueFor("dmg_to_overheal") / 100
	self:SetStackCount(0)
end

function modifier_imba_bloodseeker_blood_bath_overheal:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_imba_bloodseeker_blood_bath_overheal:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodrage_silenced_old.vpcf"
end

function modifier_imba_bloodseeker_blood_bath_overheal:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


	
function modifier_imba_bloodseeker_blood_bath_overheal:OnTakeDamage(params)
	if params.attacker == self:GetParent() and params.inflictor == self:GetAbility() then
		local bonusHP = params.damage * self.overheal
		self:SetStackCount(self:GetStackCount() + bonusHP)
		self:GetParent():CalculateStatBonus()
		self:GetParent():Heal(bonusHP, self:GetParent())
	end
end	

function modifier_imba_bloodseeker_blood_bath_overheal:GetModifierExtraHealthBonus(params)
	return self:GetStackCount()
end
--------------------------------------------------------------------------------

imba_bloodseeker_thirst = imba_bloodseeker_thirst or class({})

function imba_bloodseeker_thirst:GetIntrinsicModifierName()
	return "modifier_imba_bloodseeker_thirst_passive"
end

LinkLuaModifier("modifier_imba_bloodseeker_thirst_passive", "hero/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
modifier_imba_bloodseeker_thirst_passive = class({})

function modifier_imba_bloodseeker_thirst_passive:IsHidden()
	return true
end

function modifier_imba_bloodseeker_thirst_passive:OnCreated()
	self.minhp = self:GetAbility():GetSpecialValueFor("max_threshold_pct")
	self.maxhp = self:GetAbility():GetSpecialValueFor("visibility_threshold_pct")
	self.movespeed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed") / (self.minhp - self.maxhp)
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage") / (self.minhp - self.maxhp)
	self.deathstick = self:GetAbility():GetSpecialValueFor("stick_time")
	self:StartIntervalThink(0.1)
end

function modifier_imba_bloodseeker_thirst_passive:OnRefresh()
	self.minhp = self:GetAbility():GetSpecialValueFor("max_threshold_pct")
	self.maxhp = self:GetAbility():GetSpecialValueFor("visibility_threshold_pct")
	self.movespeed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed") / (self.minhp - self.maxhp)
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage") / (self.minhp - self.maxhp)
	self.deathstick = self:GetAbility():GetSpecialValueFor("stick_time")
	self.talent7 = false
	if IsServer() then
		if self:GetParent():HasTalent("special_bonus_unique_bloodseeker_7") then
			self.movespeed = self.movespeed + self:GetParent():FindSpecificTalentValue("special_bonus_unique_bloodseeker_7", "value") / (self.minhp - self.maxhp)
			self.damage = self.damage + self:GetParent():FindSpecificTalentValue("special_bonus_unique_bloodseeker_7", "value2") / (self.minhp - self.maxhp)
			CustomNetTables:SetTableValue("talents", "hero_bloodseeker_talents", {talent7_ms = self.movespeed, talent7_dmg = self.damage})
		end
	end
end

function modifier_imba_bloodseeker_thirst_passive:OnIntervalThink()
	if IsServer() then
		if not self.talent7 then
			if self:GetParent():HasTalent("special_bonus_unique_bloodseeker_7") then
				self.talent7 = true
				self.movespeed = self.movespeed + self:GetParent():FindSpecificTalentValue("special_bonus_unique_bloodseeker_7", "value")  / (self.minhp - self.maxhp)
				self.damage = self.damage + self:GetParent():FindSpecificTalentValue("special_bonus_unique_bloodseeker_7", "value2")  / (self.minhp - self.maxhp)
				CustomNetTables:SetTableValue("talents", "hero_bloodseeker_talents", {talent7_ms = self.movespeed, talent7_dmg = self.damage})
			end
		end
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false)
		local hpDeficit = 0
		for _,enemy in pairs(enemies) do
			if self:GetCaster():PassivesDisabled() then 
				enemy:RemoveModifierByName("modifier_imba_bloodseeker_thirst_vision")
			else
				if enemy:IsAlive() or (not enemy:IsAlive() and enemy.thirstDeathTimer < self.deathstick) then
					if enemy:GetHealthPercent() < self.minhp then
						local enemyHp = (self.minhp - enemy:GetHealthPercent())
						if enemyHp > (self.minhp - self.maxhp) then 
							enemyHp = (self.minhp - self.maxhp)
							enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_bloodseeker_thirst_vision", {})
						elseif enemy:HasModifier("modifier_imba_bloodseeker_thirst_vision") then
							enemy:RemoveModifierByName("modifier_imba_bloodseeker_thirst_vision")
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

function modifier_imba_bloodseeker_thirst_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_imba_bloodseeker_thirst_passive:GetModifierPreAttack_BonusDamage(params)
	return self:GetStackCount() * self.damage
end

function modifier_imba_bloodseeker_thirst_passive:GetModifierMoveSpeedBonus_Percentage(params)
	return self:GetStackCount() * self.movespeed
end

function modifier_imba_bloodseeker_thirst_passive:OnTakeDamage(params)
	if IsServer() then
		if params.attacker:GetTeam() == self:GetCaster():GetTeam() and params.unit:GetTeam() ~= self:GetCaster():GetTeam() and params.attacker:IsRealHero() and params.unit:IsRealHero() then
			local duration = self:GetAbility():GetTalentSpecialValueFor("atk_buff_duration")
			local attackList = self:GetCaster():FindAllModifiersByName("modifier_imba_bloodseeker_thirst_attack_buff")
			local confirmTheKill = false
			for _,modifier in pairs(attackList) do
				if modifier.sourceUnit == params.unit then
					attackerCount = 1
					if params.attacker == self:GetCaster() then attackerCount = 2 end
					confirmTheKill = true
					modifier:SetStackCount(attackerCount)
					modifier:SetDuration(duration, true)
					break
				end
			end
			if not confirmTheKill then
				local modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_bloodseeker_thirst_attack_buff", {duration = duration})
				modifier.sourceUnit = params.unit
				attackerCount = 1
				if params.attacker == self:GetCaster() then attackerCount = 2 end
				modifier:SetStackCount(attackerCount)
			end
		end
	end
end

LinkLuaModifier("modifier_imba_bloodseeker_thirst_attack_buff", "hero/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
modifier_imba_bloodseeker_thirst_attack_buff = class({})

function modifier_imba_bloodseeker_thirst_attack_buff:OnCreated()
	self.movespeed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed_atk")
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage_atk")
end

function modifier_imba_bloodseeker_thirst_attack_buff:OnRefresh()
	self.movespeed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed_atk")
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage_atk")
end

function modifier_imba_bloodseeker_thirst_attack_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_bloodseeker_thirst_attack_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_imba_bloodseeker_thirst_attack_buff:GetModifierPreAttack_BonusDamage(params)
	return self:GetStackCount() * self.damage
end

function modifier_imba_bloodseeker_thirst_attack_buff:GetModifierMoveSpeedBonus_Percentage(params)
	return self:GetStackCount() * self.movespeed
end

function modifier_imba_bloodseeker_thirst_attack_buff:IsHidden()
	return true
end

function modifier_imba_bloodseeker_thirst_attack_buff:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf"
end

LinkLuaModifier("modifier_imba_bloodseeker_thirst_vision", "hero/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
modifier_imba_bloodseeker_thirst_vision = class({})

function modifier_imba_bloodseeker_thirst_vision:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}
	return funcs
	
end

function modifier_imba_bloodseeker_thirst_vision:GetModifierProvidesFOWVision()
return 1
end

function modifier_imba_bloodseeker_thirst_vision:CheckState()
	local state = {[MODIFIER_STATE_INVISIBLE] = false,}
	return state
end

function modifier_imba_bloodseeker_thirst_vision:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_imba_bloodseeker_thirst_vision:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_vision.vpcf"
end

function modifier_imba_bloodseeker_thirst_vision:GetStatusEffectName()
	return "particles/status_fx/status_effect_thirst_vision.vpcf"
end

function modifier_imba_bloodseeker_thirst_vision:StatusEffectPriority()
	return 8
end

--------------------------------------------------------------------------------

imba_bloodseeker_rupture = imba_bloodseeker_rupture or class({})

function imba_bloodseeker_rupture:OnInventoryContentsChanged()
	-- Scepter stuff
	-- if not self.hasScepter and self:GetCaster():HasScepter() then
		-- self.hasScepter = true
		-- self:GetParent():AddNewModifier(self:GetParent(), shield, "modifier_rupture_charges",
		-- {
			-- max_count = self:GetSpecialValueFor("max_charges_scepter"),
			-- start_count = self:GetSpecialValueFor("max_charges_scepter"),
			-- replenish_time = self:GetSpecialValueFor("cooldown_scepter")
		-- })
	-- end
end

function imba_bloodseeker_rupture:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	local caster = self:GetCaster()
	hTarget:AddNewModifier(caster, self, "modifier_imba_bloodseeker_rupture", {duration = self:GetSpecialValueFor("duration")})
	EmitSoundOn("hero_bloodseeker.rupture.cast", caster)
	EmitSoundOn("hero_bloodseeker.rupture", hTarget)
	if hTarget:GetHealthPercent() > self:GetSpecialValueFor("damage_initial_pct") then
		local hpBurn = hTarget:GetHealthPercent() - self:GetSpecialValueFor("damage_initial_pct")
		ApplyDamage({victim = hTarget, attacker = caster, damage = hTarget:GetMaxHealth() * hpBurn / 100, damage_type = self:GetAbilityDamageType(), ability = self})
		if self:GetCaster():HasTalent("special_bonus_unique_bloodseeker_3") then 
			caster:Heal(hpBurn, caster) 
			local healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
			ParticleManager:ReleaseParticleIndex(healFX)
		end
	end
end

LinkLuaModifier("modifier_imba_bloodseeker_rupture", "hero/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
modifier_imba_bloodseeker_rupture = class({})

if IsServer() then
	function modifier_imba_bloodseeker_rupture:OnCreated()
		self.movedamage = self:GetAbility():GetSpecialValueFor("movement_damage_pct") / 100
		self.attackdamage = self:GetAbility():GetSpecialValueFor("attack_damage")
		self.castdamage = self:GetAbility():GetSpecialValueFor("cast_damage")
		if self:GetCaster():HasTalent("special_bonus_unique_bloodseeker_5") then
			self.attackdamage = self.attackdamage + self.attackdamage * self:GetCaster():FindTalentValue("special_bonus_unique_bloodseeker_5")
			self.castdamage = self.castdamage + self.castdamage * self:GetCaster():FindTalentValue("special_bonus_unique_bloodseeker_5")
		end
		self.damagecap = self:GetAbility():GetTalentSpecialValueFor("damage_cap_amount")
		self.prevLoc = self:GetParent():GetAbsOrigin()
		self:StartIntervalThink( self:GetAbility():GetSpecialValueFor("damage_cap_interval") )
	end

	function modifier_imba_bloodseeker_rupture:OnRefresh()
		self.movedamage = self:GetAbility():GetSpecialValueFor("movement_damage_pct") / 100
		self.attackdamage = self:GetAbility():GetSpecialValueFor("attack_damage")
		self.castdamage = self:GetAbility():GetSpecialValueFor("cast_damage")
		if self:GetCaster():HasTalent("special_bonus_unique_bloodseeker_5") then
			self.attackdamage = self.attackdamage + self.attackdamage * self:GetCaster():FindTalentValue("special_bonus_unique_bloodseeker_5")
			self.castdamage = self.castdamage + self.castdamage * self:GetCaster():FindTalentValue("special_bonus_unique_bloodseeker_5")
		end
		self.damagecap = self:GetAbility():GetSpecialValueFor("damage_cap_amount")
	end
	
	function modifier_imba_bloodseeker_rupture:OnIntervalThink()
		if CalculateDistance(self.prevLoc, self:GetParent()) < self.damagecap then
			local move_damage = CalculateDistance(self.prevLoc, self:GetParent()) * self.movedamage
			ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = move_damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
			if self:GetCaster():HasTalent("special_bonus_unique_bloodseeker_3") then 
				self:GetCaster():Heal(move_damage, self:GetCaster()) 
				local healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
				ParticleManager:ReleaseParticleIndex(healFX)
			end
		end
		self.prevLoc = self:GetParent():GetAbsOrigin()
	end
	
	function modifier_imba_bloodseeker_rupture:DeclareFunctions()
        local funcs = {
            MODIFIER_EVENT_ON_ABILITY_START,
			MODIFIER_EVENT_ON_ATTACK_START,
        }

        return funcs
    end
	
	function modifier_imba_bloodseeker_rupture:OnAbilityStart(params)
        if params.unit == self:GetParent() then
			ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.castdamage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
			if self:GetCaster():HasTalent("special_bonus_unique_bloodseeker_3") then 
				self:GetCaster():Heal(self.castdamage, self:GetCaster()) 
				local healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
				ParticleManager:ReleaseParticleIndex(healFX)
			end
		end
    end
	
	function modifier_imba_bloodseeker_rupture:OnAttackStart(params)
        if params.attacker == self:GetParent() then
			ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.attackdamage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
			if self:GetCaster():HasTalent("special_bonus_unique_bloodseeker_3") then 
				self:GetCaster():Heal(self.attackdamage, self:GetCaster()) 
				local healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
				ParticleManager:ReleaseParticleIndex(healFX)
			end
		end
    end
end

function modifier_imba_bloodseeker_rupture:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end


LinkLuaModifier("modifier_rupture_charges", "hero/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
modifier_rupture_charges = class({})

if IsServer() then
    function modifier_rupture_charges:Update()
        if self:GetDuration() == -1 then
			local octarine = GetCooldownReduction(self:GetCaster())
            self:SetDuration(self.kv.replenish_time*octarine, true)
            self:StartIntervalThink(self.kv.replenish_time*octarine)
        end
		
		if self:GetStackCount() == self.kv.max_count then
			self:SetDuration(-1, true)
		elseif self:GetStackCount() > self.kv.max_count then
			self:SetDuration(-1, true)
			self:SetStackCount(self.kv.max_count)
		end

        if self:GetStackCount() == 0 then
            self:GetAbility():StartCooldown(self:GetRemainingTime())
        end
    end

    function modifier_rupture_charges:OnCreated(kv)
        self:SetStackCount(kv.start_count or kv.max_count)
        self.kv = kv

        if kv.start_count and kv.start_count ~= kv.max_count then
            self:Update()
        end
    end

    function modifier_rupture_charges:DeclareFunctions()
        local funcs = {
            MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
        }

        return funcs
    end

    function modifier_rupture_charges:OnAbilityFullyCast(params)
        if params.unit == self:GetParent() then
            local ability = params.ability
            if params.ability == self:GetAbility() then
                self:DecrementStackCount()
				ability:EndCooldown()
                self:Update()
			elseif params.ability:GetName() == "item_refresher" and self:GetStackCount() < self.kv.max_count then
                self:IncrementStackCount()
                self:Update()
            end
        end

        return 0
    end

    function modifier_rupture_charges:OnIntervalThink()
        local stacks = self:GetStackCount()
		local octarine = GetCooldownReduction(self:GetCaster())
        if stacks < self.kv.max_count then
            self:SetDuration(self.kv.replenish_time*octarine, true)
            self:IncrementStackCount()

            if stacks == self.kv.max_count - 1 then
                self:SetDuration(-1, true)
                self:StartIntervalThink(-1)
            end
        end
    end
end

function modifier_rupture_charges:DestroyOnExpire()
    return false
end

function modifier_rupture_charges:IsPurgable()
    return false
end

function modifier_rupture_charges:RemoveOnDeath()
    return false
end

--------------------------------------------------------------------------------


LinkLuaModifier("modifier_special_bonus_unique_bloodseeker_1", "hero/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_unique_bloodseeker_1 = class({})

function modifier_special_bonus_unique_bloodseeker_1:IsHidden()
	return true
end

function modifier_special_bonus_unique_bloodseeker_1:RemoveOnDeath()
	return false
end


LinkLuaModifier("modifier_special_bonus_unique_bloodseeker_2", "hero/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_unique_bloodseeker_2 = class({})

function modifier_special_bonus_unique_bloodseeker_2:IsHidden()
	return true
end

function modifier_special_bonus_unique_bloodseeker_2:RemoveOnDeath()
	return false
end

LinkLuaModifier("modifier_special_bonus_unique_bloodseeker_3", "hero/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_unique_bloodseeker_3 = class({})

function modifier_special_bonus_unique_bloodseeker_3:IsHidden()
	return true
end

function modifier_special_bonus_unique_bloodseeker_3:RemoveOnDeath()
	return false
end
LinkLuaModifier("modifier_special_bonus_unique_bloodseeker_4", "hero/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_unique_bloodseeker_4 = class({})

function modifier_special_bonus_unique_bloodseeker_4:IsHidden()
	return true
end

function modifier_special_bonus_unique_bloodseeker_4:RemoveOnDeath()
	return false
end

LinkLuaModifier("modifier_special_bonus_unique_bloodseeker_5", "hero/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_unique_bloodseeker_5 = class({})

function modifier_special_bonus_unique_bloodseeker_5:IsHidden()
	return true
end

function modifier_special_bonus_unique_bloodseeker_5:RemoveOnDeath()
	return false
end

LinkLuaModifier("modifier_special_bonus_unique_bloodseeker_6", "hero/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_unique_bloodseeker_6 = class({})

function modifier_special_bonus_unique_bloodseeker_6:IsHidden()
	return true
end

function modifier_special_bonus_unique_bloodseeker_6:RemoveOnDeath()
	return false
end

LinkLuaModifier("modifier_special_bonus_unique_bloodseeker_7", "hero/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_unique_bloodseeker_7 = class({})

function modifier_special_bonus_unique_bloodseeker_7:IsHidden()
	return true
end

function modifier_special_bonus_unique_bloodseeker_7:RemoveOnDeath()
	return false
end

LinkLuaModifier("modifier_special_bonus_unique_bloodseeker_8", "hero/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_unique_bloodseeker_8 = class({})

function modifier_special_bonus_unique_bloodseeker_8:IsHidden()
	return true
end

function modifier_special_bonus_unique_bloodseeker_8:RemoveOnDeath()
	return false
end
