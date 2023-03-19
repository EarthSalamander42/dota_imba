-- Editors:
--     Seinken, 05.07.2017

local LinkedModifiers = {}
-------------------------------------------
--				BLOOD RAGE
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers, {
	["modifier_imba_bloodrage_buff_stats"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_bloodrage_blood_frenzy"] = LUA_MODIFIER_MOTION_NONE,
})
imba_bloodseeker_bloodrage = imba_bloodseeker_bloodrage or class({})

function imba_bloodseeker_bloodrage:GetAbilityTextureName()
	return "bloodseeker_bloodrage"
end

function imba_bloodseeker_bloodrage:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	local caster = self:GetCaster()
	if hTarget:TriggerSpellAbsorb(self) then return end --if target has spell absorption, stop.

	if hTarget:GetTeamNumber() ~= caster:GetTeamNumber() then
		hTarget:AddNewModifier(caster, self, "modifier_imba_bloodrage_buff_stats", { duration = self:GetSpecialValueFor("duration") * (1 - hTarget:GetStatusResistance()) })
	else
		hTarget:AddNewModifier(caster, self, "modifier_imba_bloodrage_buff_stats", { duration = self:GetSpecialValueFor("duration") })
	end

	EmitSoundOn("hero_bloodseeker.bloodRage", hTarget)
end

modifier_imba_bloodrage_buff_stats = modifier_imba_bloodrage_buff_stats or class({})

function modifier_imba_bloodrage_buff_stats:GetEffectName()
	return "particles/hero/bloodseeker/bloodseeker_boiling_blood.vpcf"
end

function modifier_imba_bloodrage_buff_stats:GetStatusEffectName()
	return "particles/status_fx/status_effect_bloodrage.vpcf"
end

function modifier_imba_bloodrage_buff_stats:StatusEffectPriority()
	return 8
end

function modifier_imba_bloodrage_buff_stats:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.health_bonus_pct = self:GetAbility():GetSpecialValueFor("health_bonus_pct")

	if not IsServer() then return end

	self.modifier_frenzy = "modifier_imba_bloodrage_blood_frenzy"

	self.damage_increase_outgoing_pct = self:GetAbility():GetSpecialValueFor("damage_increase_outgoing_pct")
	self.damage_increase_incoming_pct = self:GetAbility():GetSpecialValueFor("damage_increase_incoming_pct")

	if self:GetCaster():HasTalent("special_bonus_imba_bloodseeker_1") then
		if self:GetParent():GetTeam() == self:GetCaster():GetTeam() then
			self.damage_increase_incoming_pct = self.damage_increase_incoming_pct - self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_1")
			self.damage_increase_outgoing_pct = self.damage_increase_outgoing_pct + self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_1")
		else
			self.damage_increase_incoming_pct = self.damage_increase_incoming_pct + self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_1")
			self.damage_increase_outgoing_pct = self.damage_increase_outgoing_pct - self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_1")
		end
	end

	self.health_bonus_aoe = self:GetAbility():GetSpecialValueFor("health_bonus_aoe")
	self.health_bonus_share_percent = self:GetAbility():GetSpecialValueFor("health_bonus_share_percent")
	self.damage = self:GetAbility():GetSpecialValueFor("aoe_damage")
	self.radius = self:GetAbility():GetSpecialValueFor("aoe_radius")
	self.alliedpct = self:GetAbility():GetSpecialValueFor("allied_damage") / 100

	self.damage_type = self:GetAbility():GetAbilityDamageType()

	local tick_interval = 1

	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		tick_interval = tick_interval * (1 - self:GetParent():GetStatusResistance())
	end

	self:StartIntervalThink(tick_interval)
end

function modifier_imba_bloodrage_buff_stats:OnRefresh()
	self:OnCreated()
end

function modifier_imba_bloodrage_buff_stats:OnIntervalThink()
	for _, target in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)) do
		ApplyDamage({ victim = target, attacker = self:GetCaster(), damage = self.damage, damage_type = self.damage_type, ability = self:GetAbility() })
	end
end

function modifier_imba_bloodrage_buff_stats:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_imba_bloodrage_buff_stats:GetModifierTotalDamageOutgoing_Percentage(params)
	if not IsServer() then return end

	if params.attacker == self:GetParent() and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
		local outamp = self.damage_increase_outgoing_pct

		if CalcDistanceBetweenEntityOBB(params.target, params.attacker) > self:GetAbility():GetSpecialValueFor("red_val_distance") then
			outamp = outamp * self:GetAbility():GetSpecialValueFor("red_val_amount") / 100
		end

		if self:GetCaster():HasTalent("special_bonus_imba_bloodseeker_8") then
			local ampPct = self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_8", "value") / self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_8", "value2") -- find amp per pct
			local hpPct = (1 - self:GetParent():GetHealth() / self:GetParent():GetMaxHealth()) * 100                                                                             -- missing hp in pct
			outamp = outamp + ampPct * hpPct
		end
		return outamp
	end
end

function modifier_imba_bloodrage_buff_stats:GetModifierIncomingDamage_Percentage(params)
	if not IsServer() then return end

	if params.target == self:GetParent() then
		local inamp = self.damage_increase_incoming_pct
		if CalcDistanceBetweenEntityOBB(params.target, params.attacker) > self:GetAbility():GetSpecialValueFor("red_val_distance") then
			inamp = inamp * self:GetAbility():GetSpecialValueFor("red_val_amount") / 100
		end
		if self:GetCaster():HasTalent("special_bonus_imba_bloodseeker_8") then
			local ampPct = self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_8", "value") / self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_8", "value2") -- find amp per pct
			local hpPct = (1 - self:GetParent():GetHealth() / self:GetParent():GetMaxHealth()) * 100                                                                             -- missing hp in pct
			inamp = inamp + ampPct * hpPct
		end
		return inamp
	end
end

function modifier_imba_bloodrage_buff_stats:OnDeath(params)
	-- "Bloodrage does not heal upon killing illusions, Arc Warden Tempest Doubles, Roshan, wards, or buildings."
	if not params.unit:IsIllusion() and not params.unit:IsTempestDouble() and not params.unit:IsRoshan() and not params.unit:IsOther() and not params.unit:IsBuilding() then
		if (params.attacker == self:GetParent() or params.unit == self:GetParent()) and params.attacker ~= params.unit and not params.attacker:IsOther() and not params.attacker:IsBuilding() then
			local heal = params.unit:GetMaxHealth() * self.health_bonus_pct / 100

			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, params.attacker, heal, nil)
			params.attacker:Heal(heal, self:GetCaster())
			local healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
			ParticleManager:ReleaseParticleIndex(healFX)
		elseif params.unit:IsRealHero() and (self:GetParent():GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() <= self.health_bonus_aoe then
			local heal = params.unit:GetMaxHealth() * (self.health_bonus_pct / 100) * (self.health_bonus_share_percent / 100)

			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), heal, nil)
			self:GetParent():Heal(heal, self:GetCaster())
			local healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
			ParticleManager:ReleaseParticleIndex(healFX)
		end
	end

	-- If the caster has #7 Talent, grant a Blood Frenzy to it
	if self:GetCaster():HasTalent("special_bonus_imba_bloodseeker_7") then
		if params.unit == self:GetParent() or params.attacker == self:GetParent() then
			-- Gather duration from talent
			local frenzy_duration = self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_7", "duration")

			-- Apply frenzy!
			params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), self.modifier_frenzy, { duration = frenzy_duration })
		end
	end
end

-- #7 Talent: Blood Frenzy bonuses
modifier_imba_bloodrage_blood_frenzy = modifier_imba_bloodrage_blood_frenzy or class({})

function modifier_imba_bloodrage_blood_frenzy:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.particle_frenzy = "particles/hero/bloodseeker/bloodseeker_blood_frenzy_ring.vpcf"

	-- Talent specials
	self.ms_bonus_pct = self.caster:FindTalentValue("special_bonus_imba_bloodseeker_7", "ms_bonus_pct")

	-- Apply Blood Frenzy's effect
	local particle_frenzy_fx = ParticleManager:CreateParticle(self.particle_frenzy, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle_frenzy_fx, 0, self.parent:GetAbsOrigin())
	self:AddParticle(particle_frenzy_fx, false, false, -1, false, false)

	if not IsServer() then return end

	self:SetStackCount(self.ms_bonus_pct)
end

function modifier_imba_bloodrage_blood_frenzy:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_imba_bloodrage_blood_frenzy:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

function modifier_imba_bloodrage_blood_frenzy:IsHidden() return false end

function modifier_imba_bloodrage_blood_frenzy:IsPurgable() return true end

function modifier_imba_bloodrage_blood_frenzy:IsDebuff() return false end

-------------------------------------------
--				BLOOD RITE
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers, {
	["modifier_imba_blood_bath_buff_stats"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_blood_bath_debuff_silence"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_special_bonus_imba_bloodseeker_9"] = LUA_MODIFIER_MOTION_NONE
})
imba_bloodseeker_blood_bath = imba_bloodseeker_blood_bath or class({})

function imba_bloodseeker_blood_bath:GetAbilityTextureName()
	return "bloodseeker_blood_bath"
end

function imba_bloodseeker_blood_bath:GetAOERadius()
	local radius = self:GetSpecialValueFor("radius")

	if self:GetCaster():HasTalent("special_bonus_imba_bloodseeker_5") then
		radius = radius + self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_5", "distance")
	end

	return radius
end

function imba_bloodseeker_blood_bath:GetCooldown(level)
	local talent_reduction = 0
	if self:GetCaster():HasModifier("modifier_special_bonus_imba_bloodseeker_9") then
		talent_reduction = self:GetSpecialValueFor("cooldown_reduction_talent")
	end
	return self.BaseClass.GetCooldown(self, level) - talent_reduction
end

-- Needed for the CD reduction talent
function imba_bloodseeker_blood_bath:OnOwnerSpawned()
	if not IsServer() then return end
	if self:GetCaster():HasAbility("special_bonus_imba_bloodseeker_9") and self:GetCaster():FindAbilityByName("special_bonus_imba_bloodseeker_9"):IsTrained() and not self:GetCaster():HasModifier("modifier_special_bonus_imba_bloodseeker_9") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_bloodseeker_9", {})
	end
end

function imba_bloodseeker_blood_bath:OnSpellStart()
	local vPos = self:GetCursorPosition()
	local caster = self:GetCaster()

	-- #5 Talent: Blood Rite casts itself in a form of "glasses"
	if not caster:HasTalent("special_bonus_imba_bloodseeker_5") then
		self:FormBloodRiteCircle(caster, vPos)
	else
		-- Gather talent information
		local circles = caster:FindTalentValue("special_bonus_imba_bloodseeker_5", "circles")
		local distance = caster:FindTalentValue("special_bonus_imba_bloodseeker_5", "distance")

		-- Caster's position on cast
		local caster_pos = caster:GetAbsOrigin()

		-- Find position in front of the target point
		local direction = (vPos - caster_pos):Normalized()
		local front_point = vPos + direction * distance
		self:FormBloodRiteCircle(caster, front_point)

		-- Find positions, to the left and right of the target point
		for i = 1, circles - 1 do
			-- Rotate the direction clockwise or counter-clockwise
			local vector_direction
			if i % 2 == 0 then
				vector_direction = self:Orthogonal(direction, false)
			else
				vector_direction = self:Orthogonal(direction, true)
			end

			-- Claim position in the distance of the main target point
			local final_circle_position = vPos + vector_direction * distance
			self:FormBloodRiteCircle(caster, final_circle_position)
		end
	end
end

function imba_bloodseeker_blood_bath:FormBloodRiteCircle(caster, vPos)
	AddFOWViewer(caster:GetTeamNumber(), vPos, self:GetSpecialValueFor("vision_aoe"), self:GetSpecialValueFor("vision_duration"), true) --gives ground vision
	local radius = self:GetSpecialValueFor("radius")
	EmitSoundOn("Hero_Bloodseeker.BloodRite.Cast", caster)
	EmitSoundOnLocationWithCaster(vPos, "Hero_Bloodseeker.BloodRite", caster)
	local bloodriteFX = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_ring.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(bloodriteFX, 0, vPos)
	ParticleManager:SetParticleControl(bloodriteFX, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(bloodriteFX, 3, vPos)
	Timers:CreateTimer(self:GetSpecialValueFor("delay"), function()
		EmitSoundOnLocationWithCaster(vPos, "hero_bloodseeker.bloodRite.silence", caster)
		ParticleManager:DestroyParticle(bloodriteFX, false)
		ParticleManager:ReleaseParticleIndex(bloodriteFX)
		local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), vPos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

		if #targets > 0 then
			local overheal = caster:AddNewModifier(caster, self, "modifier_imba_blood_bath_buff_stats", { duration = self:GetSpecialValueFor("overheal_duration") })
		end

		local rupture = false
		if caster:HasTalent("special_bonus_imba_bloodseeker_2") and caster:HasAbility("imba_bloodseeker_rupture") then
			rupture = caster:FindAbilityByName("imba_bloodseeker_rupture")
		end

		for _, target in pairs(targets) do
			local damage = self:GetSpecialValueFor("damage")
			target:AddNewModifier(caster, self, "modifier_imba_blood_bath_debuff_silence", { duration = self:GetSpecialValueFor("silence_duration") * (1 - target:GetStatusResistance()) })
			if rupture then
				if rupture:GetLevel() >= 1 then
					rupture.from_blood_rite = true
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
			ApplyDamage({ victim = target, attacker = self:GetCaster(), damage = damage, damage_type = self:GetAbilityDamageType(), ability = self })
		end
	end)
end

function imba_bloodseeker_blood_bath:Orthogonal(vec, clockwise)
	local vector = Vector(-vec.y, vec.x, 0)

	if not clockwise then
		vector = vector * (-1)
	end

	return vector
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

function modifier_imba_blood_bath_debuff_silence:IsPurgable()
	if self:GetCaster():HasTalent("special_bonus_imba_bloodseeker_4") then
		return false
	end

	return true
end

function modifier_imba_blood_bath_debuff_silence:IsDebuff() return true end

function modifier_imba_blood_bath_debuff_silence:CheckState()
	return { [MODIFIER_STATE_SILENCED] = true }
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
	self.overheal = self:GetAbility():GetSpecialValueFor("dmg_to_overheal") / 100
	self.particle_overheal = "particles/hero/bloodseeker/blood_bath_power.vpcf"

	local particle_overheal_fx = ParticleManager:CreateParticle(self.particle_overheal, PATTACH_OVERHEAD_FOLLOW, self.caster)
	ParticleManager:SetParticleControl(particle_overheal_fx, 0, self.caster:GetAbsOrigin())
	self:AddParticle(particle_overheal_fx, false, false, -1, false, true)
end

function modifier_imba_blood_bath_buff_stats:OnRefresh()
	self.overheal = self:GetAbility():GetSpecialValueFor("dmg_to_overheal") / 100
	self:SetStackCount(0)
end

function modifier_imba_blood_bath_buff_stats:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_imba_blood_bath_buff_stats:OnTakeDamage(params)
	if params.attacker == self:GetParent() and params.inflictor == self:GetAbility() then
		local bonusHP = params.damage * self.overheal
		self:SetStackCount(self:GetStackCount() + bonusHP)
		self:GetParent():CalculateStatBonus(true)
		self:GetParent():Heal(bonusHP, self:GetParent())
	end
end

function modifier_imba_blood_bath_buff_stats:GetModifierExtraHealthBonus(params)
	return self:GetStackCount()
end

-- Blood Rite's CD reduction talent (-6 seconds default)
-- Separate modifier is needed to pass relevant information for client-side viewing
modifier_special_bonus_imba_bloodseeker_9 = class({})

function modifier_special_bonus_imba_bloodseeker_9:IsHidden() return true end

function modifier_special_bonus_imba_bloodseeker_9:IsPurgable() return false end

function modifier_special_bonus_imba_bloodseeker_9:RemoveOnDeath() return false end

-------------------------------------------
--				THIRST
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers, {
	["modifier_imba_thirst_debuff_vision"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers, {
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

	if not IsServer() then return end

	if not self:GetCaster():HasModifier("modifier_bloodseeker_thirst") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bloodseeker_thirst", {})
	end

	self:StartIntervalThink(0.1)
end

function modifier_imba_thirst_passive:OnRefresh()
	self.minhp = self:GetAbility():GetSpecialValueFor("max_threshold_pct")
	self.maxhp = self:GetAbility():GetSpecialValueFor("visibility_threshold_pct")
	self.movespeed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed") / (self.minhp - self.maxhp)
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage") / (self.minhp - self.maxhp)
	self.deathstick = self:GetAbility():GetSpecialValueFor("stick_time")
end

function modifier_imba_thirst_passive:OnIntervalThink()
	if IsServer() then
		-- Vanilla modifier for speed cap that is dispellable...keep checking to ensure the modifier stays or not
		if self:GetParent():PassivesDisabled() then
			self:GetParent():RemoveModifierByNameAndCaster("modifier_bloodseeker_thirst", self:GetCaster())
		elseif not self:GetParent():HasModifier("modifier_bloodseeker_thirst") and self:GetAbility() then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bloodseeker_thirst", {})
		end

		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		local hpDeficit = 0
		for _, enemy in pairs(enemies) do
			if self:GetCaster():PassivesDisabled() or not self:GetCaster():IsAlive() then
				enemy:RemoveModifierByName("modifier_imba_thirst_debuff_vision")
			else
				if enemy and not enemy:IsNull() and (enemy:IsRealHero() or enemy:IsClone()) and enemy:IsAlive() or (not enemy:IsAlive() and enemy.thirstDeathTimer < self.deathstick) then
					if enemy:GetHealthPercent() < self.minhp then
						local enemyHp = (self.minhp - enemy:GetHealthPercent())
						if enemyHp > (self.minhp - self.maxhp) and not enemy:IsMagicImmune() then
							enemyHp = (self.minhp - self.maxhp)
							enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_thirst_debuff_vision", {})
						elseif enemy:HasModifier("modifier_imba_thirst_debuff_vision") then
							enemy:RemoveModifierByName("modifier_imba_thirst_debuff_vision")
						end
						if not enemy:IsAlive() then
							enemy.thirstDeathTimer = enemy.thirstDeathTimer + 0.1
						else
							enemy.thirstDeathTimer = 0
						end
						hpDeficit = hpDeficit + enemyHp
					end
				end

				-- Second check cause there's some logic skipping happening in the above block
				if enemy:GetHealthPercent() > self.maxhp and enemy:HasModifier("modifier_imba_thirst_debuff_vision") then
					enemy:RemoveModifierByName("modifier_imba_thirst_debuff_vision")
				end
			end
		end
		self:SetStackCount(hpDeficit)
	end
end

function modifier_imba_thirst_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		-- MODIFIER_PROPERTY_MOVESPEED_MAX,
	}
end

function modifier_imba_thirst_passive:GetModifierAttackSpeedBonus_Constant(params)
	return self:GetStackCount() * self.damage
end

function modifier_imba_thirst_passive:GetModifierMoveSpeedBonus_Percentage(params)
	return self:GetStackCount() * self.movespeed
end

--[[
function modifier_imba_thirst_passive:GetModifierMoveSpeed_Max()
	return 5000
end
--]]
function modifier_imba_thirst_passive:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf"
end

function modifier_imba_thirst_passive:OnTakeDamage(params)
	if IsServer() then
		if params.attacker and params.attacker:GetTeam() == self:GetCaster():GetTeam() and params.unit:GetTeam() ~= self:GetCaster():GetTeam() and params.attacker:IsRealHero() and params.unit:IsRealHero() then
			local duration = self:GetAbility():GetTalentSpecialValueFor("atk_buff_duration")
			local attackList = self:GetCaster():FindAllModifiersByName("modifier_imba_thirst_haste")
			local confirmTheKill = false
			for _, modifier in pairs(attackList) do
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
				local modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_thirst_haste", { duration = duration })

				if modifier then
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
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_imba_thirst_haste:GetModifierAttackSpeedBonus_Constant(params)
	return self:GetStackCount() * self.damage
end

function modifier_imba_thirst_haste:GetModifierMoveSpeedBonus_Percentage(params)
	return self:GetStackCount() * self.movespeed
end

function modifier_imba_thirst_haste:IsHidden()
	return true
end

modifier_imba_thirst_debuff_vision = modifier_imba_thirst_debuff_vision or class({})

function modifier_imba_thirst_debuff_vision:OnCreated()
	self.visibility_threshold_pct = self:GetAbility():GetSpecialValueFor("visibility_threshold_pct")
end

function modifier_imba_thirst_debuff_vision:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}
end

function modifier_imba_thirst_debuff_vision:GetModifierProvidesFOWVision()
	return 1
end

function modifier_imba_thirst_debuff_vision:CheckState()
	if self:GetParent():GetHealthPercent() > self.visibility_threshold_pct then
		self:Destroy()
	else
		return { [MODIFIER_STATE_INVISIBLE] = false }
	end
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

function modifier_imba_thirst_debuff_vision:IsPurgable()
	return false
end

-- Gonna remake Thirst because the above has a LOT of issues (like permanently lingering modifiers), inconsistent variable naming, extraneous modifiers, bad and outdated logic handling, boring IMBAfication, etc.
-- IDK someone might get mad if I outright delete it

LinkLuaModifier("modifier_bloodseeker_thirst_v2", "components/abilities/heroes/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_v2_speed", "components/abilities/heroes/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_v2_vision", "components/abilities/heroes/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)

imba_bloodseeker_thirst_v2            = imba_bloodseeker_thirst_v2 or class({})
modifier_bloodseeker_thirst_v2        = modifier_bloodseeker_thirst_v2 or class({})
modifier_bloodseeker_thirst_v2_speed  = modifier_bloodseeker_thirst_v2_speed or class({})
modifier_bloodseeker_thirst_v2_vision = modifier_bloodseeker_thirst_v2_vision or class({})

--------------------------------
-- IMBA_BLOODSEEKER_THIRST_V2 --
--------------------------------

function imba_bloodseeker_thirst_v2:GetIntrinsicModifierName()
	return "modifier_bloodseeker_thirst_v2"
end

------------------------------------
-- MODIFIER_BLOODSEEKER_THIRST_V2 --
------------------------------------

function modifier_bloodseeker_thirst_v2:IsHidden() return true end

function modifier_bloodseeker_thirst_v2:IsPurgable() return false end

function modifier_bloodseeker_thirst_v2:RemoveOnDeath() return false end

function modifier_bloodseeker_thirst_v2:OnIntervalThink()
	-- This variable tracks the total amount of health percentage missing from all enemies, which is used to calculate the bonus movement and attack speed
	self.health_percent_sum = 0
	-- This variable tracks how many enemies are under max Thirst effects (mostly just to handle the visible Thirst buff for Bloodseeker)
	self.max_thirst_enemies = 0

	if not self:GetParent():PassivesDisabled() then
		for _, enemy in pairs(FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false)) do
			if (enemy:IsRealHero() or enemy:IsClone() or enemy:IsTempestDouble()) and enemy:GetHealthPercent() <= self:GetAbility():GetSpecialValueFor("min_bonus_pct") and (enemy:IsAlive() or enemy:HasModifier("modifier_bloodseeker_thirst_v2_vision")) then
				self.health_percent_sum = self.health_percent_sum + (self:GetAbility():GetSpecialValueFor("min_bonus_pct") - math.max(enemy:GetHealthPercent(), self:GetAbility():GetSpecialValueFor("max_bonus_pct")))

				if enemy:GetHealthPercent() <= self:GetAbility():GetSpecialValueFor("visibility_threshold_pct") then
					self.max_thirst_enemies = self.max_thirst_enemies + 1

					enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_thirst_v2_vision", {})
				end
			end
		end
	end

	if self.max_thirst_enemies >= 1 and not self:GetParent():PassivesDisabled() then
		if not self:GetParent():HasModifier("modifier_bloodseeker_thirst_v2_speed") then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bloodseeker_thirst_v2_speed", {})
		end
	else
		if self:GetParent():HasModifier("modifier_bloodseeker_thirst_v2_speed") then
			self:GetParent():RemoveModifierByName("modifier_bloodseeker_thirst_v2_speed")
		end
	end

	-- Multiplying by 100 here to better handle decimals
	self:SetStackCount(self.health_percent_sum * 100)
end

function modifier_bloodseeker_thirst_v2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_bloodseeker_thirst_v2:GetModifierMoveSpeedBonus_Percentage()
	return (self:GetAbility():GetSpecialValueFor("bonus_movement_speed") / (self:GetAbility():GetSpecialValueFor("min_bonus_pct") - self:GetAbility():GetSpecialValueFor("max_bonus_pct"))) * self:GetStackCount() / 100
end

function modifier_bloodseeker_thirst_v2:GetModifierAttackSpeedBonus_Constant()
	return (self:GetAbility():GetSpecialValueFor("bonus_attack_speed") / (self:GetAbility():GetSpecialValueFor("min_bonus_pct") - self:GetAbility():GetSpecialValueFor("max_bonus_pct"))) * self:GetStackCount() / 100
end

------------------------------------------
-- MODIFIER_BLOODSEEKER_THIRST_V2_SPEED --
------------------------------------------

function modifier_bloodseeker_thirst_v2_speed:IsPurgable() return false end

-------------------------------------------
-- MODIFIER_BLOODSEEKER_THIRST_V2_VISION --
-------------------------------------------

function modifier_bloodseeker_thirst_v2_vision:IsPurgable() return false end

function modifier_bloodseeker_thirst_v2_vision:RemoveOnDeath() return false end

function modifier_bloodseeker_thirst_v2_vision:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_vision.vpcf"
end

function modifier_bloodseeker_thirst_v2_vision:GetStatusEffectName()
	return "particles/status_fx/status_effect_thirst_vision.vpcf"
end

function modifier_bloodseeker_thirst_v2_vision:StatusEffectPriority()
	return 8
end

function modifier_bloodseeker_thirst_v2_vision:OnCreated()
	self.visibility_threshold_pct = self:GetAbility():GetSpecialValueFor("visibility_threshold_pct")
	self.linger_duration          = self:GetAbility():GetSpecialValueFor("linger_duration")
end

function modifier_bloodseeker_thirst_v2_vision:CheckState()
	if self:GetParent():GetHealthPercent() > self.visibility_threshold_pct then
		self:Destroy()
	else
		return { [MODIFIER_STATE_INVISIBLE] = false }
	end
end

function modifier_bloodseeker_thirst_v2_vision:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_bloodseeker_thirst_v2_vision:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,

		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_bloodseeker_thirst_v2_vision:GetModifierProvidesFOWVision()
	return 1
end

function modifier_bloodseeker_thirst_v2_vision:OnDeath(keys)
	if keys.unit == self:GetParent() then
		if not self:GetParent().IsReincarnating or not self:GetParent():IsReincarnating() then
			self:SetDuration(self.linger_duration, true)
		else
			self:Destroy()
		end
	end
end

-------------------------------------------
--				RUPTURE
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers, {
	["modifier_imba_rupture_debuff_dot"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_rupture_charges"] = LUA_MODIFIER_MOTION_NONE,
})

imba_bloodseeker_rupture = imba_bloodseeker_rupture or class({})

function imba_bloodseeker_rupture:GetAbilityTextureName()
	return "bloodseeker_rupture"
end

function imba_bloodseeker_rupture:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():FindTalentValue("special_bonus_imba_bloodseeker_rupture_cast_range")
end

function imba_bloodseeker_rupture:GetCooldown(nLevel)
	-- Scepter grants charges, no cooldown needed
	if self:GetCaster():HasScepter() then
		return 0
	end

	return self.BaseClass.GetCooldown(self, nLevel)
end

function imba_bloodseeker_rupture:GetIntrinsicModifierName()
	return "modifier_imba_rupture_charges"
end

function imba_bloodseeker_rupture:OnSpellStart(target)
	local hTarget = target or self:GetCursorTarget()
	local caster = self:GetCaster()
	local modifier_rupture_charges = "modifier_imba_rupture_charges"

	if not IsServer() then return end

	if target then
		hTarget:AddNewModifier(caster, self, "modifier_imba_rupture_debuff_dot", { duration = 0.3 })
	else
		if hTarget:TriggerSpellAbsorb(self) then return end --if target has spell absorption, stop.
		hTarget:AddNewModifier(caster, self, "modifier_imba_rupture_debuff_dot", { duration = self:GetSpecialValueFor("duration") * (1 - hTarget:GetStatusResistance()) })
		EmitSoundOn("hero_bloodseeker.rupture.cast", caster)
		EmitSoundOn("hero_bloodseeker.rupture", hTarget)
		--How bad was their day?
		if RollPercentage(15) then
			--You're taking one down
			EmitSoundOn("Imba.BloodseekerBadDay", hTarget)
			--SING A SAD SONG JUST TO TURN IT AROUND
		end
	end

	if not target and hTarget:GetHealthPercent() > self:GetSpecialValueFor("damage_initial_pct") then
		local hpBurn = hTarget:GetHealthPercent() - self:GetSpecialValueFor("damage_initial_pct")
		local damage = hTarget:GetMaxHealth() * hpBurn / 100

		local damage_table = {
			victim = hTarget,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self,
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
		}

		ApplyDamage(damage_table)
		if self:GetCaster():HasTalent("special_bonus_imba_bloodseeker_3") then
			caster:Heal(damage, caster)
			local healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_POINT_FOLLOW, caster)
			ParticleManager:ReleaseParticleIndex(healFX)
		end
	end

	-- Scepter effect: Rupture has charges
	-- God damn spaghetti check for Grimstroke exception
	if caster:HasScepter() and (not self.from_blood_rite or self:IsStolen()) and self:GetAbilityIndex() ~= 0 then
		local modifier_rupture_charges_handler = caster:FindModifierByName(modifier_rupture_charges)
		if modifier_rupture_charges_handler then
			modifier_rupture_charges_handler:DecrementStackCount()
			self:StartCooldown(0.25)
		end
	end

	self.from_blood_rite = false
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

		self.movedamage = self:GetParent():GetHealth() * self.ability:GetSpecialValueFor("movement_damage_pct") / 100 / 100
		self.attackdamage = self.ability:GetSpecialValueFor("attack_damage")
		self.castdamage = self.ability:GetSpecialValueFor("cast_damage")
		self.damagecap = self.ability:GetTalentSpecialValueFor("damage_cap_amount")
		self.prevLoc = self.parent:GetAbsOrigin()

		self.movedamage_think = self.ability:GetSpecialValueFor("movement_damage_pct") / 100

		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("damage_cap_interval"))
	end

	function modifier_imba_rupture_debuff_dot:OnRefresh()
		self:OnCreated()
	end

	function modifier_imba_rupture_debuff_dot:OnIntervalThink()
		if CalculateDistance(self.prevLoc, self.parent) < self.damagecap then
			self.movedamage = self.movedamage_think

			local move_damage = CalculateDistance(self.prevLoc, self.parent) * self.movedamage
			if move_damage > 0 then
				ApplyDamage({ victim = self.parent, attacker = self.caster, damage = move_damage, damage_type = self.ability:GetAbilityDamageType(), damage_flags = DOTA_DAMAGE_FLAG_NONE, ability = self.ability })
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
		return {
			MODIFIER_EVENT_ON_ABILITY_START,
			MODIFIER_EVENT_ON_ATTACK_START,
		}
	end

	function modifier_imba_rupture_debuff_dot:OnAbilityStart(params)
		if params.unit == self.parent then
			ApplyDamage({ victim = self.parent, attacker = self.caster, damage = self.castdamage, damage_type = self.ability:GetAbilityDamageType(), damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL, ability = self.ability })
			if self.caster:HasTalent("special_bonus_imba_bloodseeker_3") then
				self.caster:Heal(self.castdamage, self.caster)
				local healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_POINT_FOLLOW, self.caster)
				ParticleManager:ReleaseParticleIndex(healFX)
			end
		end
	end

	function modifier_imba_rupture_debuff_dot:OnAttackStart(params)
		if params.attacker == self.parent then
			ApplyDamage({ victim = self.parent, attacker = self.caster, damage = self.attackdamage, damage_type = self.ability:GetAbilityDamageType(), damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL, ability = self.ability })
			if self.caster:HasTalent("special_bonus_imba_bloodseeker_3") then
				self.caster:Heal(self.castdamage, self.caster)
				local healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_POINT_FOLLOW, self.caster)
				ParticleManager:ReleaseParticleIndex(healFX)
			end
		end
	end

	function modifier_imba_rupture_debuff_dot:OnDestroy()
		--Stop Meme Sounds
		StopSoundEvent("Imba.BloodseekerBadDay", self.parent)
	end
end

function modifier_imba_rupture_debuff_dot:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end

-- Rupture charges modifier
modifier_imba_rupture_charges = modifier_imba_rupture_charges or class({})

function modifier_imba_rupture_charges:IsHidden()
	if self:GetCaster():HasScepter() then
		return false
	end

	return true
end

function modifier_imba_rupture_charges:IsDebuff() return false end

function modifier_imba_rupture_charges:IsPurgable() return false end

function modifier_imba_rupture_charges:RemoveOnDeath() return false end

-- Need this for the Grimstroke interaction
function modifier_imba_rupture_charges:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_rupture_charges:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.modifier_charge = "modifier_imba_rupture_charges"

		-- Ability specials
		self.max_charge_count = self.ability:GetSpecialValueFor("rupture_charges")
		self.charge_replenish_rate = self.ability:GetSpecialValueFor("scepter_charge_replenish_rate")

		-- If it the real one, set max charges
		if self.caster:IsRealHero() then
			self:SetStackCount(self.max_charge_count)
		else
			-- Illusions find their owner and its charges
			local playerid = self.caster:GetPlayerID()
			local real_hero = playerid:GetAssignedHero()

			if hero:HasModifier(self.modifier_charge) then
				self.modifier_charge_handler = hero:FindModifierByName(self.modifier_charge)
				if self.modifier_charge_handler then
					self:SetStackCount(self.modifier_charge_handler:GetStackCount())
					self:SetDuration(self.modifier_charge_handler:GetRemainingTime(), true)
				end
			end
		end

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_rupture_charges:OnIntervalThink()
	if IsServer() then
		-- If the caster doesn't have scepter, do nothing, and turn off if he dropped it.
		-- if not self.caster:HasScepter() then
		-- self.turned_on = false
		-- return nil
		-- end

		-- If this is the first time the charges are "turned on", set the stack count.
		if not self.turned_on then
			self.turned_on = true
			self:OnCreated()
		end

		local stacks = self:GetStackCount()

		-- If we have at least one stack, set ability to active, otherwise disable it
		if stacks > 0 then
			self.ability:SetActivated(true)
		else
			self.ability:SetActivated(false)
		end

		-- If we're at max charges, do nothing else
		if stacks == self.max_charge_count then
			return nil
		end

		-- If a charge has finished charging, give a stack
		if self:GetRemainingTime() < 0 then
			self:IncrementStackCount()
		end
	end
end

function modifier_imba_rupture_charges:OnStackCountChanged(old_stack_count)
	if IsServer() then
		-- If the caster doesn't have a scepter yet, do nothing
		if not self.turned_on then
			return nil
		end

		-- Current stacks
		local stacks = self:GetStackCount()
		local true_replenish_cooldown = self.charge_replenish_rate

		-- If the stacks are now 0, start the ability's cooldown
		if stacks == 0 then
			self.ability:EndCooldown()
			self.ability:StartCooldown(self:GetRemainingTime())
		end

		-- If the stack count is now 1, and the skill is still in cooldown because of some cd manipulation, refresh it
		if stacks == 1 and not self.ability:IsCooldownReady() then
			self.ability:EndCooldown()
		end

		local lost_stack
		if old_stack_count > stacks then
			lost_stack = true
		else
			lost_stack = false
		end

		if not lost_stack then
			-- If we're not at the max stacks yet, reset the timer
			if stacks < self.max_charge_count then
				self:SetDuration(true_replenish_cooldown, true)
			else
				-- Otherwise, stop the timer
				self:SetDuration(-1, true)
			end
		else
			if old_stack_count == self.max_charge_count then
				self:SetDuration(true_replenish_cooldown, true)
			end
		end
	end
end

function modifier_imba_rupture_charges:DeclareFunctions()
	return { MODIFIER_EVENT_ON_ABILITY_FULLY_CAST }
end

function modifier_imba_rupture_charges:OnAbilityFullyCast(keys)
	if IsServer() then
		local ability = keys.ability
		local unit = keys.unit

		-- If this was the caster casting Refresher, refresh charges
		if unit == self.caster and (ability:GetName() == "item_refresher" or ability:GetName() == "item_refresher_shard") then
			self:SetStackCount(self.max_charge_count)
		end
	end
end

function modifier_imba_rupture_charges:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------
for LinkedModifier, MotionController in pairs(LinkedModifiers) do
	LinkLuaModifier(LinkedModifier, "components/abilities/heroes/hero_bloodseeker", MotionController)
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_bloodseeker_1", "components/abilities/heroes/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_bloodseeker_5", "components/abilities/heroes/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_bloodseeker_7", "components/abilities/heroes/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_bloodseeker_rupture_cast_range", "components/abilities/heroes/hero_bloodseeker", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_bloodseeker_1                  = modifier_special_bonus_imba_bloodseeker_1 or class({})
modifier_special_bonus_imba_bloodseeker_5                  = modifier_special_bonus_imba_bloodseeker_5 or class({})
modifier_special_bonus_imba_bloodseeker_7                  = modifier_special_bonus_imba_bloodseeker_7 or class({})
modifier_special_bonus_imba_bloodseeker_rupture_cast_range = modifier_special_bonus_imba_bloodseeker_rupture_cast_range or class({})

function modifier_special_bonus_imba_bloodseeker_1:IsHidden() return true end

function modifier_special_bonus_imba_bloodseeker_1:IsPurgable() return false end

function modifier_special_bonus_imba_bloodseeker_1:RemoveOnDeath() return false end

function modifier_special_bonus_imba_bloodseeker_5:IsHidden() return true end

function modifier_special_bonus_imba_bloodseeker_5:IsPurgable() return false end

function modifier_special_bonus_imba_bloodseeker_5:RemoveOnDeath() return false end

function modifier_special_bonus_imba_bloodseeker_7:IsHidden() return true end

function modifier_special_bonus_imba_bloodseeker_7:IsPurgable() return false end

function modifier_special_bonus_imba_bloodseeker_7:RemoveOnDeath() return false end

function modifier_special_bonus_imba_bloodseeker_rupture_cast_range:IsHidden() return true end

function modifier_special_bonus_imba_bloodseeker_rupture_cast_range:IsPurgable() return false end

function modifier_special_bonus_imba_bloodseeker_rupture_cast_range:RemoveOnDeath() return false end

function imba_bloodseeker_rupture:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_bloodseeker_rupture_cast_range") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_bloodseeker_rupture_cast_range") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_bloodseeker_rupture_cast_range"), "modifier_special_bonus_imba_bloodseeker_rupture_cast_range", {})
	end
end

function imba_bloodseeker_bloodrage:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_bloodseeker_7") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_bloodseeker_7") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_bloodseeker_7"), "modifier_special_bonus_imba_bloodseeker_7", {})
	end
end
