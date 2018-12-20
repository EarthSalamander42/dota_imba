-- Editors:
--     AtroCty, 04.07.2017

local LinkedModifiers = {}
-------------------------------------------
--        MANA BREAK
-------------------------------------------
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_mana_break_passive"] = LUA_MODIFIER_MOTION_NONE,
})
imba_antimage_mana_break = imba_antimage_mana_break or class({})

function imba_antimage_mana_break:GetAbilityTextureName()
	return "antimage_mana_break"
end

function imba_antimage_mana_break:GetIntrinsicModifierName()
	return "modifier_imba_mana_break_passive"
end

-- Mana break modifier
modifier_imba_mana_break_passive = modifier_imba_mana_break_passive or class({})

function modifier_imba_mana_break_passive:IsHidden()
	return true
end

function modifier_imba_mana_break_passive:IsPurgable()
	return false
end

function modifier_imba_mana_break_passive:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE}
	return decFuncs
end

function modifier_imba_mana_break_passive:OnCreated()
	if IsServer() then
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.particle_blast = "particles/hero/antimage/mana_break_blast.vpcf"
		self.sound_blast = "tutorial_smallfence_smash"
		self.particle_aoe_mana_burn = "particles/hero/antimage/mana_break_aoe_burn.vpcf"

		self.damage_per_burn = self.ability:GetSpecialValueFor("damage_per_burn")
		self.base_mana_burn = self.ability:GetSpecialValueFor("base_mana_burn")
		self.threshold_difference = self.ability:GetSpecialValueFor("threshold_difference")
		self.blast_aoe = self.ability:GetSpecialValueFor("blast_aoe")
		self.max_mana_blast = self.ability:GetSpecialValueFor("max_mana_blast")
		self.illusions_efficiency_pct = self.ability:GetSpecialValueFor("illusions_efficiency_pct")
	end
end

function modifier_imba_mana_break_passive:OnRefresh()
	if IsServer() then
		self:OnCreated()
	end
end

function modifier_imba_mana_break_passive:OnAttackStart(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- If caster has break, do nothing
		if attacker:PassivesDisabled() then
			return nil
		end

		-- If the target is an item, do nothing
		if target:IsItemContainer() then
			return nil
		end

		-- If there isn't a valid target, do nothing
		if target:GetMaxMana() == 0 or target:IsMagicImmune() then
			return nil
		end

		-- Only apply on caster attacking enemies
		if self.parent == attacker and target:GetTeamNumber() ~= self.parent:GetTeamNumber() then

			-- Calculate mana to burn
			local target_mana_burn = target:GetMana()
			if (target_mana_burn > self.base_mana_burn) then
				target_mana_burn = self.base_mana_burn
			end

			-- Get the target's current mana percentage
			self.mana_percentage = target:GetManaPercent()

			-- Get the threshold difference phase he's currently in (4 is 75%-100%, 3 is 50%-75% etc unless numbers change)
			-- Phase 0 means he has no mana at all
			self.mana_phase = math.ceil(self.mana_percentage / self.threshold_difference)

			-- Decide how much damage should be added
			self.add_damage = target_mana_burn * self.damage_per_burn

			-- Talent 4 - % of missing mana as extra-dmg
			if attacker:HasTalent("special_bonus_imba_antimage_4") then
				self.add_damage = self.add_damage + (( (target:GetMaxMana() - target:GetMana() + target_mana_burn) * ( (attacker:FindTalentValue("special_bonus_imba_antimage_4")) / 100)) * self.damage_per_burn)
			end
		end
	end
end

function modifier_imba_mana_break_passive:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- If target has break, do nothing
		if attacker:PassivesDisabled() then
			return nil
		end

		-- If there isn't a valid target, do nothing
		if target:GetMaxMana() == 0 or target:IsMagicImmune() then
			return nil
		end

		-- Only apply on caster attacking enemies
		if self.parent == attacker and target:GetTeamNumber() ~= self.parent:GetTeamNumber() then

			-- Play sound
			target:EmitSound("Hero_Antimage.ManaBreak")

			-- Add hit particle effects
			local manaburn_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(manaburn_pfx, 0, target:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex(manaburn_pfx)

			-- Calculate and burn mana
			local target_mana_burn = target:GetMana()
			if (target_mana_burn > self.base_mana_burn) then
				target_mana_burn = self.base_mana_burn

			end

			target:ReduceMana(target_mana_burn)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, target, target_mana_burn, nil)

			-- If the target is magic immune, this is it for us.
			if target:IsMagicImmune() then
				return nil
			end

			-- Get the target's percentage now
			local current_mana_percentage = target:GetManaPercent()

			-- Get the current mana phase the target is in now
			local current_mana_phase = math.ceil(current_mana_percentage / self.threshold_difference)

			-- If the attack caused the target to "lose" a phase of mana, or it is in phase 0, BLAST IT!
			if current_mana_phase < self.mana_phase or current_mana_phase == 0 then

				-- Sexy blast effect
				local particle_blast_fx = ParticleManager:CreateParticle(self.particle_blast, PATTACH_CUSTOMORIGIN_FOLLOW, target)
				ParticleManager:SetParticleControlEnt(particle_blast_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(particle_blast_fx)

				-- Calculate blast damage
				local blast_damage = target:GetMaxMana() * self.max_mana_blast * 0.01

				-- Find all enemies, and deal damage to them
				local enemies = FindUnitsInRadius(attacker:GetTeamNumber(),
					target:GetAbsOrigin(),
					nil,
					self.blast_aoe,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_NONE,
					FIND_ANY_ORDER,
					false)

				-- If this is an illusion, the blast deals less damage
				if self.parent:IsIllusion() then
					blast_damage = blast_damage * self.illusions_efficiency_pct * 0.01
				end

				for _,enemy in pairs(enemies) do
					-- If the enemy suddenly became magic immune, ignore it. Otherwise, continue
					if not enemy:IsMagicImmune() then
						local damageTable = {victim = enemy,
							damage = blast_damage,
							damage_type = DAMAGE_TYPE_MAGICAL,
							attacker = attacker,
							ability = self.ability
						}

						ApplyDamage(damageTable)
					end
				end

				-- Play blast sound
				EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), self.sound_blast, self.parnet)
			end

			-- #7 Talent: Mana Break attacks burn mana of nearby enemies in AoE, equal to a portion of the mana burned.
			if self.parent:HasTalent("special_bonus_imba_antimage_7") then

				-- Gather talent information
				local mana_burn_aoe = self.parent:FindTalentValue("special_bonus_imba_antimage_7", "mana_burn_aoe")
				local mana_burn_pct = self.parent:FindTalentValue("special_bonus_imba_antimage_7", "mana_burn_pct")

				-- Create particle
				local particle_aoe_mana_burn_fx = ParticleManager:CreateParticle(self.particle_aoe_mana_burn, PATTACH_ABSORIGIN, self.parent)
				ParticleManager:SetParticleControl(particle_aoe_mana_burn_fx, 0, target:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle_aoe_mana_burn_fx)

				-- Calculate mana to burn
				local mana_aoe_break = target_mana_burn * mana_burn_pct * 0.01

				-- Find nearby enemies in range
				local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),
					target:GetAbsOrigin(),
					nil,
					mana_burn_aoe,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_NONE,
					FIND_ANY_ORDER,
					false)

				-- Remove mana from enemies. Ignore the main target
				for _,enemy in pairs(enemies) do
					if enemy ~= target and not enemy:IsMagicImmune() then
						enemy:ReduceMana(mana_aoe_break)
						SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, enemy, mana_aoe_break, nil)
					end
				end
			end
		end
	end
end

function modifier_imba_mana_break_passive:GetModifierBaseAttack_BonusDamage(params)
	if IsServer() then
		return self.add_damage
	end
end

-------------------------------------------
--       BLINK
-------------------------------------------
imba_antimage_blink = imba_antimage_blink or class({})
MergeTables(LinkedModifiers,{
	["modifier_imba_antimage_blink_charges"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_antimage_blink_spell_immunity"] = LUA_MODIFIER_MOTION_NONE,
})

function imba_antimage_blink:GetAbilityTextureName()
	return "antimage_blink"
end

function imba_antimage_blink:GetIntrinsicModifierName()
	return "modifier_imba_antimage_blink_charges"
end

function imba_antimage_blink:IsNetherWardStealable() return false end
-- Talent reducing cast point
function imba_antimage_blink:OnAbilityPhaseStart()
	if IsServer() then
		local caster = self:GetCaster()
		if ( caster:HasTalent("special_bonus_imba_antimage_3") ) and (not self.cast_point) then
			self.cast_point = true
			local cast_point = self:GetCastPoint()
			cast_point = cast_point - caster:FindTalentValue("special_bonus_imba_antimage_3")
			self:SetOverrideCastPoint(cast_point)
		end
		return true
	end
end

-- Talent reducing CD + CDR
function imba_antimage_blink:GetCooldown( nLevel )
	-- #1 Talent: Blink becomes charges (no CD needed)
	if self:GetCaster():HasTalent("special_bonus_imba_antimage_1") then
		return 0
	end

	return self.BaseClass.GetCooldown( self, nLevel )
end

function imba_antimage_blink:OnSpellStart()
	if IsServer() then
		-- Declare variables
		local caster = self:GetCaster()
		local caster_position = caster:GetAbsOrigin()
		local target_point = self:GetCursorPosition()
		local modifier_spell_immunity = "modifier_imba_antimage_blink_spell_immunity"

		local distance = target_point - caster_position

		self.blink_range = self:GetSpecialValueFor("blink_range")
		self.percent_mana_burn = self:GetSpecialValueFor("percent_mana_burn")
		self.percent_damage = self:GetSpecialValueFor("percent_damage")
		self.radius = self:GetSpecialValueFor("radius")
		local mana_burn_limit = self:GetSpecialValueFor("mana_burn_limit")

		-- #1 Talent: Blink has charges
		if caster:HasTalent("special_bonus_imba_antimage_1") then
			local modifier_blink_charges_handler = caster:FindModifierByName("modifier_imba_antimage_blink_charges")
			if modifier_blink_charges_handler then
				modifier_blink_charges_handler:DecrementStackCount()
			end
		end

		-- Range-check
		if distance:Length2D() > self.blink_range then
			target_point = caster_position + (target_point - caster_position):Normalized() * self.blink_range
		end

		-- Disjointing everything
		ProjectileManager:ProjectileDodge(caster)

		-- Blink particles/sound on starting point
		local blink_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:ReleaseParticleIndex(blink_pfx)
		caster:EmitSound("Hero_Antimage.Blink_out")

		-- #5 Talent: Blinking grants a brief magic immunity shield.
		if caster:HasTalent("special_bonus_imba_antimage_5") then
			local immunity_duration = caster:FindTalentValue("special_bonus_imba_antimage_5")
			caster:AddNewModifier(caster, self, modifier_spell_immunity, {duration = immunity_duration})
		end

		-- Adding an extreme small timer for the particles, else they will only appear at the dest
		Timers:CreateTimer(0.01, function()
			-- Move hero
			caster:SetAbsOrigin(target_point)
			FindClearSpaceForUnit(caster, target_point, true)

			-- Create Particle/sound on end-point
			local blink_end_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_blink_end.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:ReleaseParticleIndex(blink_end_pfx)
			caster:EmitSound("Hero_Antimage.Blink_in")

			-- Manaburn-Nova
			if not ( self.percent_mana_burn == 0) then

				-- Make a damage particle
				local mananova_pfx = ParticleManager:CreateParticle("particles/hero/antimage/blink_manaburn_basher_ti_5.vpcf", PATTACH_POINT, caster)
				ParticleManager:SetParticleControl(mananova_pfx, 0, caster:GetAbsOrigin() )
				ParticleManager:SetParticleControl(mananova_pfx, 1, Vector((self.radius * 2),1,1))
				ParticleManager:ReleaseParticleIndex(mananova_pfx)

				local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _,enemy in pairs(nearby_enemies) do
					-- Calculate this enemy's damage contribution
					local mana_burn = enemy:GetMana() * (self.percent_mana_burn * 0.01)


					-- Only continue if target has mana
					if mana_burn > 0 then
						local this_enemy_damage = mana_burn * (self.percent_damage * 0.01)

						-- The damage cannot go over the limit
						if this_enemy_damage > mana_burn_limit then
							this_enemy_damage = mana_burn_limit
						end

						-- Add hit particle effects
						local manaburn_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
						ParticleManager:SetParticleControl(manaburn_pfx, 0, enemy:GetAbsOrigin() )
						ParticleManager:ReleaseParticleIndex(manaburn_pfx)

						-- Deal damage and burn mana
						local damageTable = {victim = enemy,
							damage = this_enemy_damage,
							damage_type = DAMAGE_TYPE_MAGICAL,
							attacker = caster,
							ability = self
						}
						ApplyDamage(damageTable)
						enemy:ReduceMana(mana_burn)
						SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, enemy, mana_burn, nil)
					end
				end
			end
		end)
	end
end

function imba_antimage_blink:IsHiddenWhenStolen()
	return false
end


-- Blink charges modifier
modifier_imba_antimage_blink_charges = modifier_imba_antimage_blink_charges or class({})

function modifier_imba_antimage_blink_charges:IsHidden()
	if self:GetCaster():HasTalent("special_bonus_imba_antimage_1") then
		return false
	end

	return true
end

function modifier_imba_antimage_blink_charges:IsDebuff() return false end
function modifier_imba_antimage_blink_charges:IsPurgable() return false end
function modifier_imba_antimage_blink_charges:RemoveOnDeath() return false end

function modifier_imba_antimage_blink_charges:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		if self.caster:IsIllusion() then return end
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.modifier_charge = "modifier_imba_antimage_blink_charges"

		-- Ability specials
		self.max_charge_count = self.caster:FindTalentValue("special_bonus_imba_antimage_1")
		self.charge_replenish_rate = self.ability.BaseClass.GetCooldown(self.ability, -1)

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

function modifier_imba_antimage_blink_charges:OnIntervalThink()
	if IsServer() then
		-- If the caster doesn't have the blink charges talent, do nothing
		if not self.caster:HasTalent("special_bonus_imba_antimage_1") then
			return nil
		end

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

function modifier_imba_antimage_blink_charges:OnStackCountChanged(old_stack_count)
	if IsServer() then
		-- If the talent isn't activated yet, do nothing
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

function modifier_imba_antimage_blink_charges:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST}

	return decFuncs
end

function modifier_imba_antimage_blink_charges:OnAbilityFullyCast(keys)
	if IsServer() then
		local ability = keys.ability
		local unit = keys.unit

		-- If this was the caster casting Refresher, refresh charges
		if unit == self.caster and ability:GetName() == "item_refresher" then
			self:SetStackCount(self.max_charge_count)
		end
	end
end

function modifier_imba_antimage_blink_charges:DestroyOnExpire()
	return false
end


-- Blink's Spell Immunity
modifier_imba_antimage_blink_spell_immunity = modifier_imba_antimage_blink_spell_immunity or class({})

function modifier_imba_antimage_blink_spell_immunity:OnCreated()
	-- Purge the target
	self:GetParent():Purge(false, true, false, false, false) -- TODO: Purge is a nil value? WTF? WHITE IS BLACK? BLACK IS WHITE?
end

function modifier_imba_antimage_blink_spell_immunity:GetEffectName()
	return "particles/hero/antimage/blink_spellguard_immunity.vpcf"
end

function modifier_imba_antimage_blink_spell_immunity:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_antimage_blink_spell_immunity:IsHidden() return false end
function modifier_imba_antimage_blink_spell_immunity:IsPurgable() return false end
function modifier_imba_antimage_blink_spell_immunity:IsDebuff() return false end

function modifier_imba_antimage_blink_spell_immunity:CheckState()
	local state = {[MODIFIER_STATE_MAGIC_IMMUNE] = true}

	return state
end


-------------------------------------------
--      SPELL SHIELD
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_spell_shield_buff_reflect"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_spellshield_scepter_ready"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_spellshield_scepter_recharge"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_spell_shield_buff_passive"] = LUA_MODIFIER_MOTION_NONE,
})
imba_antimage_spell_shield = imba_antimage_spell_shield or class({})

function imba_antimage_spell_shield:GetAbilityTextureName()
	return "antimage_spell_shield"
end

function imba_antimage_spell_shield:GetBehavior()
	if self:GetCaster():HasTalent("special_bonus_imba_antimage_2") then
		return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
	end

	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

-- Declare active skill + visuals
function imba_antimage_spell_shield:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self
		local active_modifier = "modifier_imba_spell_shield_buff_reflect"
		self.duration = ability:GetSpecialValueFor("active_duration")

		-- Start skill cooldown.
		caster:AddNewModifier(caster, ability, active_modifier, {duration = self.duration})

		-- Run visual + sound
		local shield_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_blink_end_glow.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(shield_pfx)
		caster:EmitSound("Hero_Antimage.Counterspell.Cast")
	end
end

-- Magic resistence modifier
function imba_antimage_spell_shield:GetIntrinsicModifierName()
	return "modifier_imba_spell_shield_buff_passive"
end

function imba_antimage_spell_shield:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end

function imba_antimage_spell_shield:IsHiddenWhenStolen()
	return false
end

local function SpellReflect(parent, params)
	-- If some spells shouldn't be reflected, enter it into this spell-list
	local exception_spell =
		{
		["rubick_spell_steal"] = true,
		["imba_alchemist_greevils_greed"] = true,
		["imba_alchemist_unstable_concoction"] = true,
		["imba_disruptor_glimpse"] = true,
		["legion_commander_duel"] = true,
	}

	local reflected_spell_name = params.ability:GetAbilityName()
	local target = params.ability:GetCaster()

	-- Does not reflect allies' projectiles for any reason
	if target:GetTeamNumber() == parent:GetTeamNumber() then
		return nil
	end

	-- FOR NOW, UNTIL LOTUS ORB IS DONE
	-- Do not reflect spells if the target has Lotus Orb on, otherwise the game will die hard.
	if target:HasModifier("modifier_item_lotus_orb_active") then
		return nil
	end

	if ( not exception_spell[reflected_spell_name] ) and (not target:HasModifier("modifier_imba_spell_shield_buff_reflect")) then

		-- If this is a reflected ability, do nothing
		if params.ability.spell_shield_reflect then
			return nil
		end

		local reflect_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(reflect_pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(reflect_pfx)

		local old_spell = false
		for _,hSpell in pairs(parent.tOldSpells) do
			if hSpell ~= nil and hSpell:GetAbilityName() == reflected_spell_name then
				old_spell = true
				break
			end
		end
		if old_spell then
			ability = parent:FindAbilityByName(reflected_spell_name)
		else
			ability = parent:AddAbility(reflected_spell_name)
			ability:SetStolen(true)
			ability:SetHidden(true)

			-- Tag ability as a reflection ability
			ability.spell_shield_reflect = true

			-- Modifier counter, and add it into the old-spell list
			ability:SetRefCountsModifiers(true)
			table.insert(parent.tOldSpells, ability)
		end

		ability:SetLevel(params.ability:GetLevel())
		-- Set target & fire spell
		parent:SetCursorCastTarget(target)
		ability:OnSpellStart()
		target:EmitSound("Hero_Antimage.Counterspell.Target")
	end

	return false
end

local function SpellAbsorb(parent)
	local reflect_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(reflect_pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetOrigin(), true)
	ParticleManager:ReleaseParticleIndex(reflect_pfx)
	return 1
end

modifier_imba_spell_shield_buff_passive = modifier_imba_spell_shield_buff_passive or class({})

function modifier_imba_spell_shield_buff_passive:IsHidden()
	return true
end

function modifier_imba_spell_shield_buff_passive:IsDebuff()
	return false
end

function modifier_imba_spell_shield_buff_passive:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_ABSORB_SPELL,
		MODIFIER_PROPERTY_REFLECT_SPELL
	}
	return decFuncs
end

function modifier_imba_spell_shield_buff_passive:OnCreated()
	--	if self:GetCaster():IsIllusion() then
	--		print("Removing buff from an illusion..") -- CRASH WITH NEW MANTA LUA
	--		self:Destroy()
	--		return
	--	end
	self.magic_resistance = self:GetAbility():GetSpecialValueFor("magic_resistance")

	if IsServer() then
		self.duration = self:GetAbility():GetSpecialValueFor("active_duration")
		self.spellshield_max_distance = self:GetAbility():GetSpecialValueFor("spellshield_max_distance")
		self.internal_cooldown = self:GetAbility():GetSpecialValueFor("internal_cooldown")
		self.modifier_ready = "modifier_imba_spellshield_scepter_ready"
		self.modifier_recharge = "modifier_imba_spellshield_scepter_recharge"

		-- Add the scepter modifier
		if not self:GetParent():HasModifier(self.modifier_ready) then
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), self.modifier_ready, {})
		end

		self:GetParent().tOldSpells = {}

		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_spell_shield_buff_passive:OnRefresh()
	self:OnCreated()
end

function modifier_imba_spell_shield_buff_passive:GetModifierMagicalResistanceBonus(params)
	return self.magic_resistance
end

function modifier_imba_spell_shield_buff_passive:GetReflectSpell( params )
	if IsServer() then
		local parent = self:GetParent()
		if parent:HasScepter() and parent:IsRealHero() and not self:GetParent():HasModifier(self.modifier_recharge) then
			if not self:GetParent():PassivesDisabled() then

				-- If the targets are too far apart, do nothing
				local distance = (parent:GetAbsOrigin() - params.ability:GetCaster():GetAbsOrigin()):Length2D()
				if distance > self.spellshield_max_distance then
					return nil
				end

				-- Apply the spell reflect
				return SpellReflect(parent, params)
			end
		end
	end
end

function modifier_imba_spell_shield_buff_passive:GetAbsorbSpell( params )
	if IsServer() then
		local parent = self:GetParent()
		if parent:HasScepter() and parent:IsRealHero() and not self:GetParent():HasModifier(self.modifier_recharge) then
			if not self:GetParent():PassivesDisabled() then

				-- Start the internal recharge modifier
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), self.modifier_recharge, {duration = self.internal_cooldown})

				-- Apply Spell Absorption
				return SpellAbsorb(parent)
			end
		end
		return false
	end
end

function modifier_imba_spell_shield_buff_passive:OnDestroy()
	-- If for some reason this modifier is destroyed (Rubick losing it, for instance), remove the scepter modifier
	if IsServer() then
		if self:GetParent():HasModifier(self.modifier_ready) then
			self:GetParent():RemoveModifierByName(self.modifier_ready)
		end
	end
end

-- Reflect modifier
-- Biggest thanks to Yunten !
modifier_imba_spell_shield_buff_reflect = modifier_imba_spell_shield_buff_reflect or class({})

function modifier_imba_spell_shield_buff_reflect:IsHidden()
	return false
end

function modifier_imba_spell_shield_buff_reflect:IsDebuff()
	return false
end

function modifier_imba_spell_shield_buff_reflect:IsPurgable()
	return false
end

function modifier_imba_spell_shield_buff_reflect:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_ABSORB_SPELL,
		MODIFIER_PROPERTY_REFLECT_SPELL
	}
	return decFuncs
end

-- Initialize old-spell-checker
function modifier_imba_spell_shield_buff_reflect:OnCreated( params )
	if IsServer() then

	end
end

function modifier_imba_spell_shield_buff_reflect:GetReflectSpell( params )
	if IsServer() then
		if not self:GetParent():PassivesDisabled() then
			return SpellReflect(self:GetParent(), params)
		end
	end
end

function modifier_imba_spell_shield_buff_reflect:GetAbsorbSpell( params )
	if IsServer() then
		if not self:GetParent():PassivesDisabled() then
			return SpellAbsorb(self:GetParent())
		end
	end
end

-- Deleting old abilities
-- This is bound to the passive modifier, so this is constantly on!
function modifier_imba_spell_shield_buff_passive:OnIntervalThink()
	if IsServer() then
		local caster = self:GetParent()
		for i=#caster.tOldSpells,1,-1 do
			local hSpell = caster.tOldSpells[i]
			if hSpell:NumModifiersUsingAbility() == 0 and not hSpell:IsChanneling() then
				hSpell:RemoveSelf()
				table.remove(caster.tOldSpells,i)
			end
		end
	end
end



-- Scepter block Ready modifier
modifier_imba_spellshield_scepter_ready = modifier_imba_spellshield_scepter_ready or class({})

function modifier_imba_spellshield_scepter_ready:IsHidden()
	-- If the caster doesn't have scepter, hide
	if not self:GetParent():HasScepter() then
		return true
	end

	-- If the caster is recharging its scepter reflect, hide
	if self:GetParent():HasModifier("modifier_imba_spellshield_scepter_recharge") then
		return true
	end

	-- Otherwise, show normally
	return false
end

function modifier_imba_spellshield_scepter_ready:IsPurgable() return false end
function modifier_imba_spellshield_scepter_ready:IsDebuff() return false end
function modifier_imba_spellshield_scepter_ready:RemoveOnDeath() return false end


-- Scepter block recharge modifier
modifier_imba_spellshield_scepter_recharge = modifier_imba_spellshield_scepter_recharge or class({})

function modifier_imba_spellshield_scepter_recharge:IsHidden()
	-- If the caster doesn't has scepter, hide it
	if not self:GetParent():HasScepter() then
		return true
	end

	return false
end

function modifier_imba_spellshield_scepter_recharge:IsPurgable() return false end
function modifier_imba_spellshield_scepter_recharge:IsDebuff() return false end
function modifier_imba_spellshield_scepter_recharge:RemoveOnDeath() return false end


-------------------------------------------
--      MANA VOID
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_mana_void_stunned"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_mana_void_delay_counter"] = LUA_MODIFIER_MOTION_NONE,
})
imba_antimage_mana_void = imba_antimage_mana_void or class({})

function imba_antimage_mana_void:GetAbilityTextureName()
	return "antimage_mana_void"
end

function imba_antimage_mana_void:OnAbilityPhaseStart()
	if IsServer() then
		self:GetCaster():EmitSound("Hero_Antimage.ManaVoidCast")
		return true
	end
end

-- Talent reducing CD + CDR
function imba_antimage_mana_void:GetCooldown( nLevel )
	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
	local caster = self:GetCaster()

	return cooldown
end

function imba_antimage_mana_void:GetAOERadius()
	return self:GetSpecialValueFor("mana_void_aoe_radius")
end

function imba_antimage_mana_void:IsHiddenWhenStolen()
	return false
end

function imba_antimage_mana_void:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local ability = self
		local modifier_ministun = "modifier_imba_mana_void_stunned"
		local modifier_delay = "modifier_imba_mana_void_delay_counter"

		-- Parameters
		local damage_per_mana = ability:GetSpecialValueFor("mana_void_damage_per_mana")
		local radius = ability:GetSpecialValueFor("mana_void_aoe_radius")
		local mana_burn_pct = ability:GetSpecialValueFor("mana_void_mana_burn_pct")
		local mana_void_ministun = ability:GetSpecialValueFor("mana_void_ministun")
		local damage = 0

		-- If the target possesses a ready Linken's Sphere, do nothing
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(ability) then
				return nil
			end
		end

		local time_to_wait = 0

		-- #6 Talent: Mana Void explosion is delayed. Each point of mana lost is worth as 2 missing mana points
		if caster:HasTalent("special_bonus_imba_antimage_6") then
			time_to_wait = caster:FindTalentValue("special_bonus_imba_antimage_6", "delay_duration")

			-- Add a counter to the target
			target:AddNewModifier(caster, ability, modifier_delay, {duration = time_to_wait + 0.2})
		end

		Timers:CreateTimer(time_to_wait, function()
			-- Burn main target's mana & ministun
			local target_mana_burn = target:GetMaxMana() * mana_burn_pct / 100
			target:ReduceMana(target_mana_burn)
			target:AddNewModifier(caster, ability, modifier_ministun, {duration = mana_void_ministun})

			-- Find all enemies in the area of effect
			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(nearby_enemies) do

				-- Calculate this enemy's damage contribution
				local this_enemy_damage = 0

				-- Talent 8, all missing mana pools added to damage
				if ( caster:HasTalent("special_bonus_imba_antimage_8") ) or (enemy == target) then
					this_enemy_damage = (enemy:GetMaxMana() - enemy:GetMana()) * damage_per_mana
				end
				-- Add this enemy's contribution to the damage tally
				damage = damage + this_enemy_damage
			end

			-- #6 Talent: Every point of mana lost during the delay duration is added as additional damage
			if caster:HasTalent("special_bonus_imba_antimage_6") then
				local modifier_delay_handler = target:FindModifierByName(modifier_delay)
				if modifier_delay_handler then
					damage = damage + modifier_delay_handler:GetStackCount()
					modifier_delay_handler:Destroy()
				end
			end

			-- Damage all enemies in the area for the total damage tally
			for _,enemy in pairs(nearby_enemies) do
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damage, nil)
			end

			-- Shake screen due to excessive PURITY OF WILL
			ScreenShake(target:GetOrigin(), 10, 0.1, 1, 500, 0, true)

			local void_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", PATTACH_POINT_FOLLOW, target)
			ParticleManager:SetParticleControlEnt(void_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true)
			ParticleManager:SetParticleControl(void_pfx, 1, Vector(radius,0,0))
			ParticleManager:ReleaseParticleIndex(void_pfx)
			target:EmitSound("Hero_Antimage.ManaVoid")
		end)
	end
end

-------------------------------------------
-- Stun modifier
modifier_imba_mana_void_stunned = modifier_imba_mana_void_stunned or class({})
function modifier_imba_mana_void_stunned:CheckState()
	local state =
		{[MODIFIER_STATE_STUNNED] = true}
	return state
end

function modifier_imba_mana_void_stunned:IsPurgable() return false end
function modifier_imba_mana_void_stunned:IsPurgeException() return true end
function modifier_imba_mana_void_stunned:IsStunDebuff() return true end
function modifier_imba_mana_void_stunned:IsHidden() return false end
function modifier_imba_mana_void_stunned:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_imba_mana_void_stunned:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
-------------------------------------------
for LinkedModifier, MotionController in pairs(LinkedModifiers) do
	LinkLuaModifier(LinkedModifier, "components/abilities/heroes/hero_antimage", MotionController)
end


-- #6 Talent Delay counter
modifier_imba_mana_void_delay_counter = modifier_imba_mana_void_delay_counter or class({})

function modifier_imba_mana_void_delay_counter:IsHidden() return true end
function modifier_imba_mana_void_delay_counter:IsDebuff() return true end
function modifier_imba_mana_void_delay_counter:IsPurgable() return false end

function modifier_imba_mana_void_delay_counter:OnCreated()
	self.caster = self:GetCaster()
	if self.caster:IsIllusion() then return end
	self.parent = self:GetParent()
	self.mana_point_worth = self.caster:FindTalentValue("special_bonus_imba_antimage_6", "mana_point_worth")
	self.particle_bubble = "particles/hero/antimage/mana_void_delay_bubble.vpcf"

	-- Apply a delay bubble!
	local particle_bubble_fx = ParticleManager:CreateParticle(self.particle_bubble, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle_bubble_fx, 0, self.parent:GetAbsOrigin())
	self:AddParticle(particle_bubble_fx, false, false, -1, false, false)

	-- Index current target's mana
	self.target_mana = self.parent:GetMana()
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_mana_void_delay_counter:OnIntervalThink()
	-- Check for difference in mana
	local mana_difference = self.target_mana - self.parent:GetMana()

	self.target_mana = self.parent:GetMana()

	-- If mana difference is negative (target got mana), do nothing
	if mana_difference <= 0 then
		return nil
	end

	-- Get current stacks
	local stacks = self:GetStackCount()

	-- Add stacks equal to mana lost and its value
	local stack_to_add = mana_difference * self.mana_point_worth
	self:SetStackCount(self:GetStackCount() + stack_to_add)
end
