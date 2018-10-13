-- Editors:
--     Shush, 12.04.2017

--------------------------------
--       NETHER BLAST         --
--------------------------------

imba_pugna_nether_blast = class({})
LinkLuaModifier("modifier_imba_nether_blast_magic_res", "components/abilities/heroes/hero_pugna.lua", LUA_MODIFIER_MOTION_NONE)

function imba_pugna_nether_blast:GetAbilityTextureName()
	return "pugna_nether_blast"
end

function imba_pugna_nether_blast:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function imba_pugna_nether_blast:GetAOERadius()
	local ability = self
	local radius = ability:GetSpecialValueFor("main_blast_radius")

	return radius
end

function imba_pugna_nether_blast:IsNetherWardStealable()
	return true
end

function imba_pugna_nether_blast:IsHiddenWhenStolen()
	return false
end

function imba_pugna_nether_blast:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local sound_precast = "Hero_Pugna.NetherBlastPreCast"
	local sound_cast = "Hero_Pugna.NetherBlast"
	local particle_pre_blast = "particles/units/heroes/hero_pugna/pugna_netherblast_pre.vpcf"
	local particle_blast = "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"
	local modifier_magic_res = "modifier_imba_nether_blast_magic_res"

	-- Ability specials
	local mini_blast_count = ability:GetSpecialValueFor("mini_blast_count")
	local magic_res_duration = ability:GetSpecialValueFor("magic_res_duration")
	local blast_delay = ability:GetSpecialValueFor("blast_delay")
	local damage = ability:GetSpecialValueFor("damage")
	local damage_buildings_pct = ability:GetSpecialValueFor("damage_buildings_pct")
	local mini_blast_distance = ability:GetSpecialValueFor("mini_blast_distance")
	local mini_blast_radius = ability:GetSpecialValueFor("mini_blast_radius")
	local main_blast_radius = ability:GetSpecialValueFor("main_blast_radius")

	-- Play precast sound
	EmitSoundOn(sound_cast, caster)

	-- Find all enemies that would be in the mini blast radius
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		target_point,
		nil,
		mini_blast_distance + mini_blast_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	-- Clear magic resistance stacks from all enemies found
	for _,enemy in pairs(enemies) do
		if enemy:HasModifier(modifier_magic_res) then
			local modifier_magic_res_handler = enemy:FindModifierByName(modifier_magic_res)
			if modifier_magic_res_handler then
				modifier_magic_res_handler:SetStackCount(0)
				modifier_magic_res_handler:ForceRefresh()
			end
		end
	end

	-- Calculate mini blasts locations
	for i = 1, mini_blast_count do
		-- Get the relative blast angle gaps
		local angle_gaps = 360 / mini_blast_count

		-- Get the location of a blow center
		local qangle = QAngle(0, (i-1)*angle_gaps, 0)
		local direction = (target_point - caster:GetAbsOrigin()):Normalized()

		-- Get the primary blast point
		local spawn_point = target_point + direction * mini_blast_distance

		-- Rotate it to the correct location
		local mini_blast_center = RotatePosition(target_point, qangle, spawn_point)

		-- Add miniblast particle effects
		local particle_blast_fx = ParticleManager:CreateParticle(particle_blast, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_blast_fx, 0, mini_blast_center)
		ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(mini_blast_radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(particle_blast_fx)

		-- Find all enemies in range
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			mini_blast_center,
			nil,
			mini_blast_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		-- Cycle through each enemy
		for _,enemy in pairs(enemies) do
			if caster:HasTalent("special_bonus_imba_pugna_5") then
				local damageTable = {victim = enemy,
									damage = damage * caster:FindTalentValue("special_bonus_imba_pugna_5") * 0.01,
									damage_type = DAMAGE_TYPE_MAGICAL,
									attacker = caster,
									ability = ability
									}
				ApplyDamage(damageTable)
			end

			-- If the enemy doesn't have the modifier yet, apply it
			if not enemy:HasModifier(modifier_magic_res) then
				enemy:AddNewModifier(caster, ability, modifier_magic_res, {duration = magic_res_duration})
			end

			-- Increment stack count
			local modifier_magic_res_handler = enemy:FindModifierByName(modifier_magic_res)
			if modifier_magic_res_handler then
				modifier_magic_res_handler:IncrementStackCount()
			end

		end
	end

	-- Add main blast preparation particle and sound only to allies
	local particle_pre_blast_fx = ParticleManager:CreateParticle(particle_pre_blast, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle_pre_blast_fx, 0, target_point)
	ParticleManager:SetParticleControl(particle_pre_blast_fx, 1, Vector(main_blast_radius, blast_delay, 1))
	ParticleManager:ReleaseParticleIndex(particle_pre_blast_fx)

	EmitSoundOnLocationForAllies(caster:GetAbsOrigin(), sound_precast, caster)

	-- Create a timer to delay the main blast
	Timers:CreateTimer(blast_delay, function()
		-- Blow up! Add particle effect
		local particle_blast_fx = ParticleManager:CreateParticle(particle_blast, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_blast_fx, 0, target_point)
		ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(main_blast_radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(particle_blast_fx)

		-- Find all enemies, including buildings
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			target_point,
			nil,
			main_blast_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		for _,enemy in pairs(enemies) do
			local blast_damage = damage

			-- If the enemy is a building, adjust damage.
			if enemy:IsBuilding() then
				blast_damage = blast_damage * damage_buildings_pct * 0.01
			end

			-- Deal damage
			local damageTable = {victim = enemy,
				damage = blast_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				attacker = caster,
				ability = ability
			}

			ApplyDamage(damageTable)
		end
	end)
end


-- Magic resistance reduction modifier
modifier_imba_nether_blast_magic_res = class({})

function modifier_imba_nether_blast_magic_res:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.magic_res_reduction_pct = self.ability:GetSpecialValueFor("magic_res_reduction_pct")

end

function modifier_imba_nether_blast_magic_res:IsHidden() return false end
function modifier_imba_nether_blast_magic_res:IsPurgable() return true end
function modifier_imba_nether_blast_magic_res:IsDebuff() return true end

function modifier_imba_nether_blast_magic_res:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}

	return decFuncs
end

function modifier_imba_nether_blast_magic_res:GetModifierMagicalResistanceBonus()
	local stacks = self:GetStackCount()
	if self:GetParent():IsBuilding() then
		return self.magic_res_reduction_pct * stacks * (-1) * self:GetAbility():GetSpecialValueFor("magic_res_building_pct") * 0.01
	else
		return self.magic_res_reduction_pct * stacks * (-1)
	end
end


--------------------------------
--         DECREPIFY          --
--------------------------------

imba_pugna_decrepify = class({})
LinkLuaModifier("modifier_imba_decrepify", "components/abilities/heroes/hero_pugna.lua", LUA_MODIFIER_MOTION_NONE)

function imba_pugna_decrepify:GetAbilityTextureName()
	return "pugna_decrepify"
end

function imba_pugna_decrepify:IsHiddenWhenStolen()
	return false
end

function imba_pugna_decrepify:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		local casterID = caster:GetPlayerOwnerID()
		local targetID = target:GetPlayerOwnerID()

		if target ~= nil and not target:IsOpposingTeam(caster:GetTeamNumber()) and PlayerResource:IsDisableHelpSetForPlayerID(targetID,casterID) then
			return UF_FAIL_DISABLE_HELP
		end

		-- If the target is either a nether ward or a tombstone, approve
		if string.find(target:GetUnitName(),"npc_dota_unit_tombstone") or string.find(target:GetUnitName(), "npc_imba_pugna_nether_ward")then
			return UF_SUCCESS
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_pugna_decrepify:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local sound_cast = "Hero_Pugna.Decrepify"
	local modifier_decrep = "modifier_imba_decrepify"

	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration") + caster:FindTalentValue("special_bonus_imba_pugna_3")

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- If an enemy target has Linken's sphere ready, do nothing
	if caster:GetTeamNumber() ~= target:GetTeamNumber() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- Apply decrepify modifier on target
	target:AddNewModifier(caster, ability, modifier_decrep, {duration = duration})
end

-- Decrepify modifier
modifier_imba_decrepify = class({})

function modifier_imba_decrepify:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound_precast = "Hero_Pugna.NetherBlastPreCast"
	self.sound_cast = "Hero_Pugna.NetherBlast"
	self.particle_pre_blast = "particles/units/heroes/hero_pugna/pugna_netherblast_pre.vpcf"
	self.particle_blast = "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"

	-- Ability specials
	self.ally_res_reduction_pct = self.ability:GetSpecialValueFor("ally_res_reduction_pct")
	self.enemy_res_reduction_pct = self.ability:GetSpecialValueFor("enemy_res_reduction_pct")
	self.enemy_slow_pct = self.ability:GetSpecialValueFor("enemy_slow_pct")
	self.blast_delay = self.ability:GetSpecialValueFor("blast_delay")
	self.base_radius = self.ability:GetSpecialValueFor("base_radius")
	self.total_dmg_conversion_pct = self.ability:GetSpecialValueFor("total_dmg_conversion_pct")
	self.max_radius = self.ability:GetSpecialValueFor("max_radius")

	-- Define whether the afflicted is an ally or an enemy
	if self.parent:GetTeamNumber() == self.caster:GetTeamNumber() then
		self.is_ally = true
	else
		self.is_ally = false
	end

	if IsServer() then
		-- Start storing damage
		self.damage_stored = 0
	end
end

function modifier_imba_decrepify:OnRefresh()
	if IsServer() then
		self:OnDestroy()
		self.damage_stored = 0
	end
end

function modifier_imba_decrepify:IsHidden() return false end
function modifier_imba_decrepify:IsPurgable() return true end

function modifier_imba_decrepify:IsDebuff()
	if self.is_ally then
		return false
	else
		return true
	end
end

function modifier_imba_decrepify:CheckState()
	local state = {[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true}
	return state
end

function modifier_imba_decrepify:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_EVENT_ON_TAKEDAMAGE}

	return decFuncs
end

function modifier_imba_decrepify:GetModifierMagicalResistanceBonus()
	if self.is_ally then
		return self.ally_res_reduction_pct * (-1)
	else
		return self.enemy_res_reduction_pct * (-1)
	end
end

function modifier_imba_decrepify:GetModifierMoveSpeedBonus_Percentage()
	if self.is_ally then
		return nil
	else
		return self.enemy_slow_pct * (-1)
	end
end

function modifier_imba_decrepify:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_imba_decrepify:GetEffectName()
	return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf"
end

function modifier_imba_decrepify:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_decrepify:OnTakeDamage(keys)
	if IsServer() then
		local unit = keys.unit
		local damage = keys.damage

		-- Only apply if the unit taking damage is the parent of this modifier
		if unit == self.parent then
			-- Add the current damage to the damage stored
			self.damage_stored = self.damage_stored + damage
		end
	end
end

function modifier_imba_decrepify:OnDestroy()
	if IsServer() then

		-- If no damage was stored, do nothing
		if self.damage_stored == 0 then
			return nil
		end

		-- Radius is equal to base radius + all damage stored
		local total_radius = self.base_radius + self.damage_stored

		-- Radius cannot exceed max radius
		if total_radius > self.max_radius then
			total_radius = self.max_radius
		end

		-- Calculate damage and heal
		local damage = self.damage_stored * self.total_dmg_conversion_pct * 0.01

		-- #4 Talent: Heal/damage increase at the end of Decrepify
		damage = damage * 0.01

		-- Use the damage value as heal
		local heal = damage

		-- Play pre-cast sound
		EmitSoundOn(self.sound_precast, self.parent)

		-- Add pre-cast blase particle
		self.particle_pre_blast_fx = ParticleManager:CreateParticle(self.particle_pre_blast, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(self.particle_pre_blast_fx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_pre_blast_fx, 1, Vector(total_radius, self.blast_delay, 1))
		ParticleManager:ReleaseParticleIndex(self.particle_pre_blast_fx)

		-- Start a timer, wait out the delay
		Timers:CreateTimer(self.blast_delay, function()

				-- Play blast sound
				EmitSoundOn(self.sound_cast, self.parent)

				-- Add blast particle
				self.particle_blast_fx = ParticleManager:CreateParticle(self.particle_blast, PATTACH_ABSORIGIN, self.caster)
				ParticleManager:SetParticleControl(self.particle_blast_fx, 0, self.parent:GetAbsOrigin())
				ParticleManager:SetParticleControl(self.particle_blast_fx, 1, Vector(total_radius, 0, 0))
				ParticleManager:ReleaseParticleIndex(self.particle_blast_fx)

				-- Find all nearby units
				local units = FindUnitsInRadius(self.caster:GetTeamNumber(),
					self.parent:GetAbsOrigin(),
					nil,
					total_radius,
					DOTA_UNIT_TARGET_TEAM_BOTH,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_NONE,
					FIND_ANY_ORDER,
					false)

				for _,unit in pairs(units) do

					-- If the unit is an ally, heal it
					if unit:GetTeamNumber() == self.caster:GetTeamNumber() then
						unit:Heal(heal, self.caster)
						SendOverheadEventMessage(unit, OVERHEAD_ALERT_HEAL, unit, heal, unit)
					else
						-- If the unit is an enemy, damage it
						local damageTable = {victim = unit,
							damage = damage,
							damage_type = DAMAGE_TYPE_MAGICAL,
							attacker = self.caster,
							ability = self.ability
						}

						ApplyDamage(damageTable)
					end
				end
		end)
	end
end


--------------------------------
--       NETHER WARD          --
--------------------------------
imba_pugna_nether_ward = class({})
function imba_pugna_nether_ward:IsHiddenWhenStolen() return false end
function imba_pugna_nether_ward:IsRefreshable() return true end
function imba_pugna_nether_ward:IsStealable() return true end
function imba_pugna_nether_ward:IsNetherWardStealable() return false end

function imba_pugna_nether_ward:GetAbilityTextureName()
	return "pugna_nether_ward"
end

-------------------------------------------
function imba_pugna_nether_ward:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	local ability = self
	local ability_level = ability:GetLevel()
	local sound_cast = "Hero_Pugna.NetherWard"
	local ability_ward = "imba_pugna_nether_ward_aura"
	local player_id = caster:GetPlayerID()

	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")

	local point = {}
	point[1] = target_point
	point[2] = RotatePosition(target_point, QAngle(0,90,0), target_point + (target_point - caster:GetAbsOrigin()):Normalized() * 64)
	point[3] = RotatePosition(target_point, QAngle(0,-90,0), target_point + (target_point - caster:GetAbsOrigin()):Normalized() * 64)
	-- Play cast sound
	EmitSoundOn(sound_cast, caster)
	for i = 1, 1+caster:FindTalentValue("special_bonus_imba_pugna_8") do
		-- Spawn the Nether Ward
		local nether_ward = CreateUnitByName("npc_imba_pugna_nether_ward_"..(ability_level), point[i], false, caster, caster, caster:GetTeam())
		FindClearSpaceForUnit(nether_ward, point[i], true)
		nether_ward:SetControllableByPlayer(player_id, true)

		-- Prevent nearby units from getting stuck
		Timers:CreateTimer(FrameTime(), function()
			ResolveNPCPositions(point[i], 128)
		end)

		-- Apply the Nether Ward duration modifier
		nether_ward:AddNewModifier(caster, ability, "modifier_kill", {duration = duration - duration * caster:FindTalentValue("special_bonus_imba_pugna_8","duration_reduce_pct") * 0.01})
		nether_ward:AddNewModifier(caster, ability, "modifier_rooted", {})

		-- Grant the Nether Ward its aura ability
		local aura_ability = nether_ward:FindAbilityByName(ability_ward)
		aura_ability:SetLevel(ability_level)
	end
end


--------------------------------
--        NETHER AURA         --
--------------------------------
imba_pugna_nether_ward_aura = class({})
LinkLuaModifier("modifier_imba_nether_ward_aura", "components/abilities/heroes/hero_pugna.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_nether_ward_degen", "components/abilities/heroes/hero_pugna.lua", LUA_MODIFIER_MOTION_NONE)

function imba_pugna_nether_ward_aura:GetAbilityTextureName()
	return "pugna_nether_ward"
end

function imba_pugna_nether_ward_aura:GetIntrinsicModifierName()
	return "modifier_imba_nether_ward_aura"
end

function imba_pugna_nether_ward_aura:GetCastRange()
	return self:GetSpecialValueFor("radius") end
-- Aura modifier
modifier_imba_nether_ward_aura = class({})

function modifier_imba_nether_ward_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.hero_damage = self.ability:GetSpecialValueFor("hero_damage")
	self.creep_damage = self.ability:GetSpecialValueFor("creep_damage")
end


function modifier_imba_nether_ward_aura:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,}

	return decFuncs
end

function modifier_imba_nether_ward_aura:GetModifierIgnoreCastAngle()
	return 360
end

function modifier_imba_nether_ward_aura:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
end

function modifier_imba_nether_ward_aura:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_imba_nether_ward_aura:GetDisableHealing()
	return 1
end

function modifier_imba_nether_ward_aura:OnAttackLanded(keys)
	local target = keys.target
	local attacker = keys.attacker

	-- Only apply if the target of the landed attack is the Nether Ward
	if target == self.caster then
		local damage

		-- If the attacker is a real hero, a tower or Roshan, deal hero damage
		if attacker:IsRealHero() or attacker:IsTower() or attacker:IsRoshan() then
			damage = self.hero_damage
		else
			-- Assign creep or illusion damage
			damage = self.creep_damage
		end

		-- If the damage is enough to kill the ward, destroy it
		if self.caster:GetHealth() <= damage then
			self.caster:Kill(self.ability, attacker)

			-- Else, reduce its HP
		else
			self.caster:SetHealth(self.caster:GetHealth() - damage)
		end
	end
end

function modifier_imba_nether_ward_aura:CheckState()
	local state = {[MODIFIER_STATE_MAGIC_IMMUNE] = true}
	return state
end

function modifier_imba_nether_ward_aura:IsHidden() return true end
function modifier_imba_nether_ward_aura:IsPurgable() return false end
function modifier_imba_nether_ward_aura:IsDebuff() return false end

function modifier_imba_nether_ward_aura:GetAuraRadius()
	return self.radius
end

function modifier_imba_nether_ward_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_imba_nether_ward_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_nether_ward_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_nether_ward_aura:GetModifierAura()
	return "modifier_imba_nether_ward_degen"
end

function modifier_imba_nether_ward_aura:IsAura()
	return true
end



-- Degen modifier
modifier_imba_nether_ward_degen = class({})


function modifier_imba_nether_ward_degen:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound_zap = "Hero_Pugna.NetherWard.Attack"
	self.sound_target = "Hero_Pugna.NetherWard.Target"
	self.particle_heavy = "particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_heavy_ti_5.vpcf"
	self.particle_medium = "particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_medium_ti_5.vpcf"
	self.particle_light = "particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_light_ti_5.vpcf"

	-- SAFEGUARD AGAINST CRASHES
	if not self.ability then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.mana_multiplier = self.ability:GetSpecialValueFor("mana_multiplier")
	self.mana_regen_reduction = self.ability:GetSpecialValueFor("mana_regen_reduction")
	self.hero_damage = self.ability:GetSpecialValueFor("hero_damage")
	self.creep_damage = self.ability:GetSpecialValueFor("creep_damage")
	self.spell_damage = self.ability:GetSpecialValueFor("spell_damage")
end

function modifier_imba_nether_ward_degen:IsHidden() return false end
function modifier_imba_nether_ward_degen:IsPurgable() return false end
function modifier_imba_nether_ward_degen:IsDebuff() return true end

function modifier_imba_nether_ward_degen:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_nether_ward_degen:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_EVENT_ON_SPENT_MANA}

	return decFuncs
end


function modifier_imba_nether_ward_degen:GetModifierTotalPercentageManaRegen()
	return self.mana_regen_reduction * (-1)
end

function modifier_imba_nether_ward_degen:OnSpentMana(keys)
	if IsServer() then
		local target 		= 	keys.unit
		local cast_ability 	= 	keys.ability
		local ability_cost	= 	keys.cost
		-- If there is no target ability, or the ability costs no mana, do nothing
		if not target or not cast_ability or not ability_cost or ability_cost == 0 then
			return nil
		end

		-- If the caster of the event is not the one holding the modifier, do nothing
		if target ~= self.parent then
			return nil
		end

		-- If the caster of the ability is a Nether Ward, do nothing
		if string.find(target:GetUnitName(), "npc_imba_pugna_nether_ward") then
			return nil
		end
		
		-- Check if the ability is tagged as an allowed ability for Nether Ward through the ability definition
		if cast_ability.IsNetherWardStealable then
			if not cast_ability:IsNetherWardStealable() then
				return nil
			end
		end

		local ward = self.caster
		local caster = ward:GetOwnerEntity()
		local ability_zap = self.ability
		if caster:HasTalent("special_bonus_imba_pugna_6") then
			ward:AddNewModifier(ward, nil, "modifier_pugna_decrepify", {duration = caster:FindTalentValue("special_bonus_imba_pugna_6")})
		end

		-- Deal damage
		ApplyDamage({attacker = ward,
			victim = target,
			ability = ability_zap,
			damage = ability_cost * self.mana_multiplier,
			damage_type = DAMAGE_TYPE_MAGICAL})

		-- Play zap sounds
		ward:EmitSound(self.sound_zap)
		target:EmitSound(self.sound_target)

		-- Play zap particle
		if ability_cost < 200 then
			local zap_pfx = ParticleManager:CreateParticle(self.particle_light, PATTACH_ABSORIGIN, target)
			ParticleManager:SetParticleControlEnt(zap_pfx, 0, ward, PATTACH_POINT_FOLLOW, "attach_hitloc", ward:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(zap_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(zap_pfx)
		elseif ability_cost < 400 then
			local zap_pfx = ParticleManager:CreateParticle(self.particle_medium, PATTACH_ABSORIGIN, target)
			ParticleManager:SetParticleControlEnt(zap_pfx, 0, ward, PATTACH_POINT_FOLLOW, "attach_hitloc", ward:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(zap_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(zap_pfx)
		else
			local zap_pfx = ParticleManager:CreateParticle(self.particle_heavy, PATTACH_ABSORIGIN, target)
			ParticleManager:SetParticleControlEnt(zap_pfx, 0, ward, PATTACH_POINT_FOLLOW, "attach_hitloc", ward:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(zap_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(zap_pfx)
		end

		-- If the ward does not have enough health to survive a spell cast, do nothing
		if ward:GetHealth() <= self.spell_damage then
			return nil
		end

		-- Iterate through the ability list
		local cast_ability_name = cast_ability:GetName()
		local forbidden_abilities = {
			"ancient_apparition_ice_blast",
			"furion_teleportation",
			"furion_wrath_of_nature",
			"life_stealer_infest",
			"life_stealer_assimilate",
			"life_stealer_assimilate_eject",
			"storm_spirit_static_remnant",
			"storm_spirit_ball_lightning",
			"invoker_ghost_walk",
			"shadow_demon_shadow_poison",
			"shadow_demon_demonic_purge",
			"phantom_lancer_doppelwalk",
			"chaos_knight_phantasm",
			"wisp_relocate",
			"templar_assassin_refraction",
			"templar_assassin_meld",
			"naga_siren_mirror_image",
			"imba_ember_spirit_activate_fire_remnant",
			"legion_commander_duel",
			"phoenix_fire_spirits",
			"terrorblade_conjure_image",
			"winter_wyvern_arctic_burn",
			"beastmaster_call_of_the_wild",
			"beastmaster_call_of_the_wild_boar",
			"dark_seer_ion_shell",
			"dark_seer_wall_of_replica",
			"morphling_waveform",
			"morphling_adaptive_strike",
			"morphling_replicate",
			"morphling_morph_replicate",
			"morphling_hybrid",
			"leshrac_pulse_nova",
			"rattletrap_power_cogs",
			"rattletrap_rocket_flare",
			"rattletrap_hookshot",
			"spirit_breaker_charge_of_darkness",
			"shredder_timber_chain",
			"shredder_chakram",
			"shredder_chakram_2",
			"spectre_haunt",
			"windrunner_focusfire",
			"viper_poison_attack",
			"arc_warden_tempest_double",
			"broodmother_insatiable_hunger",
			"weaver_time_lapse",
			"death_prophet_exorcism",
			"treant_eyes_in_the_forest",
			"treant_living_armor",
			"enchantress_impetus",
			"chen_holy_persuasion",
			"batrider_firefly",
			"undying_decay",
			"undying_tombstone",
			"tusk_walrus_kick",
			"tusk_walrus_punch",
			"tusk_frozen_sigil",
			"gyrocopter_flak_cannon",
			"elder_titan_echo_stomp_spirit",
			"visage_soul_assumption",
			"visage_summon_familiars",
			"earth_spirit_geomagnetic_grip",
			"keeper_of_the_light_recall",
			"monkey_king_boundless_strike",
			"monkey_king_mischief",
			"monkey_king_tree_dance",
			"monkey_king_primal_spring",
			"monkey_king_wukongs_command",
			"doom_doom",
			"zuus_cloud",
		}

		-- Ignore items
		if string.find(cast_ability_name, "item") then
			return nil
		end

		if target:IsMagicImmune() then
			return
		end


		-- If the ability is on the list of uncastable abilities, do nothing
		for _,forbidden_ability in pairs(forbidden_abilities) do
			if cast_ability_name == forbidden_ability then
				return nil
			end
		end

		-- Look for the cast ability in the Nether Ward's own list
		local ability = ward:FindAbilityByName(cast_ability_name)

		-- If it was not found, add it to the Nether Ward
		if not ability then
			ward:AddAbility(cast_ability_name)
			ability = ward:FindAbilityByName(cast_ability_name)

			-- Else, activate it
		else
			ability:SetActivated(true)
		end

		-- Level up the ability
		ability:SetLevel(cast_ability:GetLevel())

		-- Refresh the ability
		ability:EndCooldown()

		local ability_range = ability:GetCastRange(ward:GetAbsOrigin(), target)
		local target_point = target:GetAbsOrigin()
		local ward_position = ward:GetAbsOrigin()

		-- Special cases

		-- Dark Ritual: target a random nearby creep
		if cast_ability_name == "imba_lich_dark_ritual" then
			local creeps = FindUnitsInRadius(   caster:GetTeamNumber(),
				ward:GetAbsOrigin(),
				nil,
				ability_range,
				DOTA_UNIT_TARGET_TEAM_BOTH,
				DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_SUMMONED,
				FIND_CLOSEST,
				false)

			-- If there are no creeps nearby, do nothing (ward also counts as a creep)
			if #creeps == 1 then
				return nil
			end

			-- Find the SECOND closest creep and set it as the target (since the ward counts as a creep)
			target = creeps[2]
			target_point = target:GetAbsOrigin()
			ability_range = ability:GetCastRange(ward:GetAbsOrigin(), target)
		end

		-- Nether Strike: add greater bash
		if cast_ability_name == "spirit_breaker_nether_strike" then
			ward:AddAbility("spirit_breaker_greater_bash")
			local ability_bash = ward:FindAbilityByName("spirit_breaker_greater_bash")
			ability_bash:SetLevel(4)
		end

		-- Repel: Find a target to cast it on
		if cast_ability_name == "imba_omniknight_repel" then
			local allies = FindUnitsInRadius(caster:GetTeamNumber(),
				ward:GetAbsOrigin(),
				nil,
				ability_range,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
				FIND_CLOSEST,
				false)

			-- If there are no allies nearby, cast on self
			if #allies == 1 then
				target = allies[1]
				target_point = target:GetAbsOrigin()
				ability_range = ability:GetCastRange(ward:GetAbsOrigin(), target)
			else
				-- Find the closest ally and set it as the target
				target = allies[2]
				target_point = target:GetAbsOrigin()
				ability_range = ability:GetCastRange(ward:GetAbsOrigin(), target)
			end
		end


		-- Meat Hook: ignore cast range
		if cast_ability_name == "imba_pudge_meat_hook" then
			ability_range = ability:GetLevelSpecialValueFor("base_range", ability:GetLevel() - 1)
		end

		-- Earth Splitter: ignore cast range
		if cast_ability_name == "elder_titan_earth_splitter" then
			ability_range = 25000
		end

		-- Shadowraze: face the caster
		if cast_ability_name == "imba_nevermore_shadowraze_close" or cast_ability_name == "imba_nevermore_shadowraze_medium" or cast_ability_name == "imba_nevermore_shadowraze_far" then
			ward:SetForwardVector((target_point - ward_position):Normalized())
		end

		-- Reqiuem of Souls: Get target's Necromastery stack count
		if cast_ability_name == "imba_nevermore_requiem" and not ward:HasModifier("modifier_imba_necromastery_souls") and target:HasAbility("imba_nevermore_necromastery") then
			local ability_handle = ward:AddAbility("imba_nevermore_necromastery")
			ability_handle:SetLevel(7)

			-- Find target's modifier and its stacks
			if target:HasModifier("modifier_imba_necromastery_souls") then
				local stacks = target:GetModifierStackCount("modifier_imba_necromastery_souls", target)

				-- Set the ward stacks count to be the same as the caster
				if ward:HasModifier("modifier_imba_necromastery_souls") then
					local modifier_souls_handler = ward:FindModifierByName("modifier_imba_necromastery_souls")
					if modifier_souls_handler then
						modifier_souls_handler:SetStackCount(stacks)
					end
				end
			end
		end

		-- Storm Bolt: choose another target
		if cast_ability_name == "imba_sven_storm_bolt" then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), ward_position, nil, ability_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				if enemies[1]:FindAbilityByName("imba_sven_storm_bolt") then
					if #enemies > 1 then
						target = enemies[2]
					else
						return nil
					end
				else
					target = enemies[1]
				end
			else
				return nil
			end
		end

		-- Sun Strike: global cast range
		if cast_ability_name == "invoker_sun_strike" then
			ability_range = 25000
		end

		-- Eclipse: add lucent beam before cast
		if cast_ability_name == "luna_eclipse" then
			if not ward:FindAbilityByName("luna_lucent_beam") then
				ward:AddAbility("luna_lucent_beam")
			end
			local ability_lucent = ward:FindAbilityByName("luna_lucent_beam")
			ability_lucent:SetLevel(4)
		end

		-- Decide which kind of targetting to use
		local ability_behavior = ability:GetBehavior()
		local ability_target_team = ability:GetAbilityTargetTeam()

		-- If the ability is hidden, reveal it and remove the hidden binary sum
		if ability:IsHidden() then
			ability:SetHidden(false)
			ability_behavior = ability_behavior - 1
		end

		-- Memorize if an ability was actually cast
		local ability_was_used = false

		if ability_behavior == DOTA_ABILITY_BEHAVIOR_NONE then
		--Do nothing, not suppose to happen

		-- Toggle ability
		elseif ability_behavior % DOTA_ABILITY_BEHAVIOR_TOGGLE == 0 then
			ability:ToggleAbility()
			ability_was_used = true

			-- Point target ability
		elseif ability_behavior % DOTA_ABILITY_BEHAVIOR_POINT == 0 then

			-- If the ability targets allies, use it on the ward's vicinity
			if ability_target_team == DOTA_UNIT_TARGET_TEAM_FRIENDLY then
				ExecuteOrderFromTable({ UnitIndex = ward:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_CAST_POSITION, Position = ward:GetAbsOrigin(), AbilityIndex = ability:GetEntityIndex(), Queue = queue})
				ability_was_used = true

				-- Else, use it as close as possible to the enemy
			else

				-- If target is not in range of the ability, use it on its general direction
				if ability_range > 0 and (target_point - ward_position):Length2D() > ability_range then
					target_point = ward_position + (target_point - ward_position):Normalized() * (ability_range - 50)
				end
				ExecuteOrderFromTable({ UnitIndex = ward:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_CAST_POSITION, Position = target_point, AbilityIndex = ability:GetEntityIndex(), Queue = queue})
				ability_was_used = true
			end

			-- Unit target ability
		elseif ability_behavior % DOTA_ABILITY_BEHAVIOR_UNIT_TARGET == 0 then

			-- If the ability targets allies, use it on a random nearby ally
			if ability_target_team == DOTA_UNIT_TARGET_TEAM_FRIENDLY then

				-- Find nearby allies
				local allies = FindUnitsInRadius(caster:GetTeamNumber(), ward_position, nil, ability_range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

				-- If there is at least one ally nearby, cast the ability
				if #allies > 0 then
					ExecuteOrderFromTable({ UnitIndex = ward:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_CAST_TARGET, TargetIndex = allies[1]:GetEntityIndex(), AbilityIndex = ability:GetEntityIndex(), Queue = queue})
					ability_was_used = true
				end

				-- If not, try to use it on the original caster
			elseif (target_point - ward_position):Length2D() <= ability_range then
				ExecuteOrderFromTable({ UnitIndex = ward:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_CAST_TARGET, TargetIndex = target:GetEntityIndex(), AbilityIndex = ability:GetEntityIndex(), Queue = queue})
				ability_was_used = true

				-- If the original caster is too far away, cast the ability on a random nearby enemy
			else

				-- Find nearby enemies
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), ward_position, nil, ability_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

				-- If there is at least one ally nearby, cast the ability
				if #enemies > 0 then
					ExecuteOrderFromTable({ UnitIndex = ward:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_CAST_TARGET, TargetIndex = enemies[1]:GetEntityIndex(), AbilityIndex = ability:GetEntityIndex(), Queue = queue})
					ability_was_used = true
				end
			end

			-- No-target ability
		elseif ability_behavior % DOTA_ABILITY_BEHAVIOR_NO_TARGET == 0 then
			ability:CastAbility()
			ability_was_used = true
		end

		-- Very edge cases in which the nether ward is silenced (doesn't actually cast a spell)
		if ward:IsSilenced() then
			ability_was_used	=	false
		end

		-- If an ability was actually used, reduce the ward's health
		if ability_was_used then
			ward:SetHealth(ward:GetHealth() - self.spell_damage)
		end

		-- Refresh the ability's cooldown and set it as inactive
		local cast_point = ability:GetCastPoint()
		Timers:CreateTimer(cast_point + 0.5, function()
			ability:SetActivated(false)
		end)
	end
end


--------------------------------
--       LIFE DRAIN           --
--------------------------------
imba_pugna_life_drain = class({})
LinkLuaModifier("modifier_imba_life_drain", "components/abilities/heroes/hero_pugna.lua", LUA_MODIFIER_MOTION_NONE)

function imba_pugna_life_drain:GetAbilityTextureName()
	return "pugna_life_drain"
end

function imba_pugna_life_drain:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function imba_pugna_life_drain:IsHiddenWhenStolen()
	return false
end

function imba_pugna_life_drain:GetAssociatedPrimaryAbilities()
	return "imba_pugna_life_drain_end"
end

function imba_pugna_life_drain:OnUpgrade()
	local caster = self:GetCaster()
	local ability_cancel = "imba_pugna_life_drain_end"

	ability_cancel_handler = caster:FindAbilityByName(ability_cancel)
	if ability_cancel_handler then
		if ability_cancel_handler:GetLevel() == 0 then
			ability_cancel_handler:SetLevel(1)
		end
	end
end

function imba_pugna_life_drain:GetCooldown(level)
	local caster = self:GetCaster()
	local scepter = caster:HasScepter()

	if scepter then
		return 0
	else
		return self.BaseClass.GetCooldown(self, level)
	end
end

function imba_pugna_life_drain:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		local modifier_drain = "modifier_imba_life_drain"

		-- Cannot be cast on invulnerable targets
		if target:IsInvulnerable() then
			return UF_FAIL_INVULNERABLE
		end

		-- Cannot be cast on self
		if target == caster then
			return UF_FAIL_CUSTOM
		end

		-- Cannot be cast on targets already afflicted with Life Drain
		if target:HasModifier(modifier_drain) then
			return UF_FAIL_CUSTOM
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_pugna_life_drain:GetCustomCastErrorTarget(target)
	local caster = self:GetCaster()
	local modifier_drain = "modifier_imba_life_drain"

	-- Cannot be cast on self
	if target == caster then
		return "dota_hud_error_life_drain_self"
	end

	-- Cannot be cast on targets already afflicted with Life Drain
	if target:HasModifier(modifier_drain) then
		return "dota_hud_error_life_drain_target"
	end
end

function imba_pugna_life_drain:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local sound_cast = "Hero_Pugna.LifeDrain.Cast"
	local modifier_lifedrain = "modifier_imba_life_drain"

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- If an enemy target has Linken's sphere ready, do nothing
	if caster:GetTeamNumber() ~= target:GetTeamNumber() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- Add life drain modifier on target
	target:AddNewModifier(caster, ability, modifier_lifedrain, {})
end

-- Life drain modifier
modifier_imba_life_drain = class({})

function modifier_imba_life_drain:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_imba_life_drain:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound_target = "Hero_Pugna.LifeDrain.Target"
	self.sound_loop = "Hero_Pugna.LifeDrain.Loop"
	self.particle_drain = "particles/units/heroes/hero_pugna/pugna_life_drain.vpcf"
	self.particle_give = "particles/units/heroes/hero_pugna/pugna_life_give.vpcf"
	self.scepter = self.caster:HasScepter()
	self.nether_ward = "npc_imba_pugna_nether_ward"

	-- Ability specials
	self.health_drain = self.ability:GetSpecialValueFor("health_drain")
	self.scepter_health_drain = self.ability:GetSpecialValueFor("scepter_health_drain")
	self.base_slow_pct = self.ability:GetSpecialValueFor("base_slow_pct")
	self.slow_per_second = self.ability:GetSpecialValueFor("slow_per_second")
	self.tick_rate = self.ability:GetSpecialValueFor("tick_rate")
	self.break_distance_extend = self.ability:GetSpecialValueFor("break_distance_extend")


	-- Play target sounds
	EmitSoundOn(self.sound_target, self.parent)

	-- Stop any ongoing looping sound on the target
	StopSoundOn(self.sound_loop, self.parent)
	EmitSoundOn(self.sound_loop, self.parent)

	-- Decide whether it is an enemy or an ally
	if self.parent:GetTeamNumber() == self.caster:GetTeamNumber() then
		self.is_ally = true
	else
		self.is_ally = false
	end

	-- Set the damage for the duration
	if self.scepter then
		self.drain_amount = self.scepter_health_drain
	else
		self.drain_amount = self.health_drain
	end


	-- Add appropriate particle effect
	if self.is_ally then
		-- Play ally particle
		self.particle_drain_fx = ParticleManager:CreateParticle(self.particle_give, PATTACH_ABSORIGIN, self.caster)
		ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	else
		-- Play enemy particle
		self.particle_drain_fx = ParticleManager:CreateParticle(self.particle_drain, PATTACH_ABSORIGIN, self.caster)
		ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	end

	if IsServer() then
		-- Extend break range by caster's Cast Range
		self.break_distance_extend = self.break_distance_extend + GetCastRangeIncrease(self.caster)

		-- Wait for the first tick, then start thinking
		Timers:CreateTimer(self.tick_rate, function()
			self:StartIntervalThink(self.tick_rate)
		end)
	else
		-- Start thinking for slow
		self:StartIntervalThink(self.tick_rate)
	end
end

function modifier_imba_life_drain:OnIntervalThink()
	if IsServer() then
		-- If the target is an enemy illusion, kill it
		if self.parent:IsIllusion() and self.parent:GetTeamNumber() ~= self.caster:GetTeamNumber() then
			self.parent:Kill(self.ability, self.caster)
			return nil
		end

		-- Check if the link has been severed
		-- Link breaks if the caster is silenced or stunned
		if self.caster:IsStunned() or self.caster:IsSilenced() then
			self:Destroy()
		end

		-- Link breaks if the caster is invisible
		if self.parent:IsImbaInvisible() then
			self:Destroy()
		end

		-- Link breaks if the target's status doesn't allow for it to continue
		if not self.caster:CanEntityBeSeenByMyTeam(self.parent) or self.parent:IsInvulnerable() then
			self:Destroy()
		end

		-- Link breaks if the distance is greater than current cast range + base
		local cast_range = self.ability:GetCastRange(self.caster:GetAbsOrigin(), self.parent) + GetCastRangeIncrease(self.caster)
		local distance = (self.parent:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D()

		if not self.caster:HasTalent("special_bonus_imba_pugna_4") then
			if distance > (cast_range + self.break_distance_extend) then
				self:Destroy()
			end
		else
			if self:GetElapsedTime() > self.caster:FindTalentValue("special_bonus_imba_pugna_4") then
				if distance > (cast_range + self.break_distance_extend) then
					self:Destroy()
				end
			end
		end

		-- Link breaks if the caster died
		if not self.caster:IsAlive() then
			self:Destroy()
		end

		-- Calculate damage for this instance
		local damage = (self.drain_amount + self.caster:FindTalentValue("special_bonus_imba_pugna_7") * 0.01 * self.parent:GetHealth()) * self.tick_rate

		-- The target is an ally: the caster is transferring health to it
		if self.is_ally then
			local damageTable = {victim = self.caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				attacker = self.caster,
				ability = self.ability
			}

			local actual_damage = ApplyDamage(damageTable)

			-- Calculate how much health is missing from the parent
			local missing_health = self.parent:GetMaxHealth() - self.parent:GetHealth()

			-- Heal the parent for the damage done to the caster
			self.parent:Heal(actual_damage, self.caster)

			-- If that instance was an excessive heal, recover mana instead
			if missing_health < actual_damage then
				-- Calculate mana to recover
				local recover_mana = actual_damage - missing_health
				self.parent:GiveMana(recover_mana)
			end

			-- If the targeted ally is a nether ward, heal it by 1 HP per tick
			if string.find(self.parent:GetUnitName(), self.nether_ward) then
				self.parent:SetHealth(self.parent:GetHealth() + 1)
			end
		else
			-- The target is an enemy: the caster is draining health from it
			local damageTable = {victim = self.parent,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				attacker = self.caster,
				ability = self.ability
			}

			local actual_damage = ApplyDamage(damageTable)

			-- Calculate how much health is missing from the caster
			local missing_health = self.caster:GetMaxHealth() - self.caster:GetHealth()

			-- Heal the caster for the damage done to the parent
			self.caster:Heal(actual_damage, self.caster)

			-- If that instance was an excessive heal, recover mana instead
			if missing_health < actual_damage then
				-- Calculate mana to recover
				local recover_mana = actual_damage - missing_health
				self.caster:GiveMana(recover_mana)
			end

			-- If the caster is a nether ward, heal it by 1 HP per tick
			if string.find(self.caster:GetUnitName(), self.nether_ward) then
				self.caster:SetHealth(self.caster:GetHealth() + 1)
			end
		end
	end

	-- Increment the slow (clientside needed which is why it's out of IsServer())
	if not self.is_ally then
		self.base_slow_pct = self.base_slow_pct + (self.slow_per_second * self.tick_rate)
	end
end

function modifier_imba_life_drain:DeclareFunctions()
	local decFuncs =   {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}


	return decFuncs
end

function modifier_imba_life_drain:CheckState()
	if self:GetParent():HasModifier("modifier_slark_shadow_dance") then
		local state = {[MODIFIER_STATE_PROVIDES_VISION] = true}
		return state
	end

	local state = {[MODIFIER_STATE_PROVIDES_VISION]= true,
		[MODIFIER_STATE_INVISIBLE] = false}
	return state
end

function modifier_imba_life_drain:GetModifierProvidesFOWVision() return 1 end

function modifier_imba_life_drain:GetModifierMoveSpeedBonus_Percentage()
	-- Don't slow allies
	if self.is_ally then
		return nil
	end

	return self.base_slow_pct * (-1)
end

function modifier_imba_life_drain:IsHidden() return true end
function modifier_imba_life_drain:IsPurgable() return false end
function modifier_imba_life_drain:IsDebuff()
	if self.is_ally then
		return false
	else
		return true
	end
end

function modifier_imba_life_drain:OnDestroy()
	-- Remove particles
	ParticleManager:DestroyParticle(self.particle_drain_fx, false)
	ParticleManager:ReleaseParticleIndex(self.particle_drain_fx)

	-- Stop sounds
	StopSoundOn(self.sound_target, self.parent)
	StopSoundOn(self.sound_loop, self.parent)
end




--------------------------------
--     LIFE DRAIN CANCEL      --
--------------------------------
imba_pugna_life_drain_end = class({})

function imba_pugna_life_drain_end:GetAbilityTextureName()
	return "custom/pugna_life_drain_end"
end

function imba_pugna_life_drain_end:IsNetherWardStealable()
	return false
end

function imba_pugna_life_drain_end:IsHiddenWhenStolen()
	return false
end

function imba_pugna_life_drain_end:GetAssociatedSecondaryAbilities()
	return "imba_pugna_life_drain"
end

function imba_pugna_life_drain_end:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_lifedrain = "modifier_imba_life_drain"

	-- Ability specials
	local search_range = ability:GetSpecialValueFor("search_range")

	-- Find all nearby allies
	local allies = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		search_range,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	-- Remove all allied lifedrain modifiers
	for _,ally in pairs(allies) do
		if ally:HasModifier(modifier_lifedrain) then
			local modifier_lifedrain_handler = ally:FindModifierByName(modifier_lifedrain)

			if modifier_lifedrain_handler then
				-- Only remove if the allied lifedrain is from the same caster (Rubick/AM interactions)
				local modifier_caster = modifier_lifedrain_handler:GetCaster()
				if caster == modifier_caster then
					ally:RemoveModifierByName(modifier_lifedrain)
				end
			end
		end
	end
end
