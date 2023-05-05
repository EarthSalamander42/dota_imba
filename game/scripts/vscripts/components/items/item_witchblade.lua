-- Creator:
-- 	AltiV - February 28th, 2019

LinkLuaModifier("modifier_item_imba_witchblade_slow", "components/items/item_witchblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_witchblade_root", "components/items/item_witchblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_witchblade", "components/items/item_witchblade", LUA_MODIFIER_MOTION_NONE)

item_imba_witchblade					= class({})
modifier_item_imba_witchblade_slow		= class({})
modifier_item_imba_witchblade_root		= class({})
modifier_item_imba_witchblade			= class({})

---------------------
-- WITCHBLADE BASE --
---------------------

function item_imba_witchblade:GetIntrinsicModifierName()
	return "modifier_item_imba_witchblade"
end

function item_imba_witchblade:GetCooldown(level)
	local base_cd = self.BaseClass.GetCooldown(self, level)
	if self.bypass then
		return base_cd * self:GetSpecialValueFor("bypass_cd_mult")
	else
		return base_cd
	end
end

function item_imba_witchblade:OnSpellStart()
	-- AbilitySpecials
	self.bonus_agility							= self:GetSpecialValueFor("bonus_agility")
	self.bonus_intellect						= self:GetSpecialValueFor("bonus_intellect")
	self.feedback_mana_burn						= self:GetSpecialValueFor("feedback_mana_burn")
	self.feedback_mana_burn_illusion_melee		= self:GetSpecialValueFor("feedback_mana_burn_illusion_melee")
	self.feedback_mana_burn_illusion_ranged		= self:GetSpecialValueFor("feedback_mana_burn_illusion_ranged")
	self.purge_rate								= self:GetSpecialValueFor("purge_rate")
	self.purge_root_duration					= self:GetSpecialValueFor("purge_root_duration")
	self.purge_slow_duration					= self:GetSpecialValueFor("purge_slow_duration")
	self.damage_per_burn						= self:GetSpecialValueFor("damage_per_burn")
	self.cast_range_tooltip						= self:GetSpecialValueFor("cast_range_tooltip")
	
	-- Inhibiting Combustion
	self.combust_mana_loss						= self:GetSpecialValueFor("combust_mana_loss")
	self.severance_chance						= self:GetSpecialValueFor("severance_chance")

	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	
	-- If the target has Linken sphere, trigger it and do nothing else
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(self) then
			return
		end
	end
	
	-- Play the cast sounds
	caster:EmitSound("DOTA_Item.DiffusalBlade.Activate")
	target:EmitSound("DOTA_Item.DiffusalBlade.Target")
	
	-- Play hit particle
	local particle = ParticleManager:CreateParticle("particles/item/diffusal/diffusal_manaburn_3.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	
	-- Get the initial amount of modifiers
	local initial_modifiers = target:GetModifierCount()

	-- Purge target
	target:Purge(true, false, false, false, false)

	-- Find the amount of modifiers it has after it has been purged. Give it a frame to lose modifiers
	local ability = self
	Timers:CreateTimer(FrameTime(), function()
		local modifiers_lost = initial_modifiers - target:GetModifierCount()

		if modifiers_lost > 0 then
			-- Burn mana and deal damage according to modifiers lost on the purge
			local mana_burn = modifiers_lost * ability.combust_mana_loss

			-- Burn the target's mana
			local target_mana = target:GetMana()
			target:ReduceMana(mana_burn, ability)

			-- Calculate damage according to burnt mana
			local damage
			if target_mana >= mana_burn then
				damage = mana_burn
			else
				damage = target_mana
			end

			-- Damage the target
			local damageTable = {
				victim = target,
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = ability,
				damage_flags = (DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL)
			}

			ApplyDamage(damageTable)

			-- Apply the explosion particle effect
			local particle = ParticleManager:CreateParticle("particles/item/diffusal/diffusal_3_dispel_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle)
		end
	end)
	
	-- Add the slow modifier
	target:AddNewModifier(caster, self, "modifier_item_imba_witchblade_slow", {duration = self.purge_slow_duration * (1 - target:GetStatusResistance())})
	
	-- If the target is not a hero (or a creep hero), root it
	if not target:IsHero() and not target:IsRoshan() and not target:IsConsideredHero() then
		target:AddNewModifier(caster, self, "modifier_rooted", {duration = self:GetSpecialValueFor("purge_root_duration") * (1 - target:GetStatusResistance())})
	end

	-- IMBAfication: Internal Bypass
	if target:IsMagicImmune() or target:IsBuilding() then
		self:EndCooldown()
		self.bypass = true
		self:UseResources(false, false, false, true)
		self.bypass = false
	end
end

------------------------------
-- WITCHBLADE SLOW MODIFIER --
------------------------------

function modifier_item_imba_witchblade_slow:GetEffectName()
	return "particles/items_fx/diffusal_slow.vpcf"
end

function modifier_item_imba_witchblade_slow:OnCreated()	
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.ability	= self:GetAbility()
	
	if not self.ability then return end
	
	-- AbilitySpecials
	self.bonus_agility							= self.ability:GetSpecialValueFor("bonus_agility")
	self.bonus_intellect						= self.ability:GetSpecialValueFor("bonus_intellect")
	self.feedback_mana_burn						= self.ability:GetSpecialValueFor("feedback_mana_burn")
	self.feedback_mana_burn_illusion_melee		= self.ability:GetSpecialValueFor("feedback_mana_burn_illusion_melee")
	self.feedback_mana_burn_illusion_ranged		= self.ability:GetSpecialValueFor("feedback_mana_burn_illusion_ranged")
	self.purge_rate								= self.ability:GetSpecialValueFor("purge_rate")
	self.purge_root_duration					= self.ability:GetSpecialValueFor("purge_root_duration")
	self.purge_slow_duration					= self.ability:GetSpecialValueFor("purge_slow_duration")
	self.damage_per_burn						= self.ability:GetSpecialValueFor("damage_per_burn")
	self.cast_range_tooltip						= self.ability:GetSpecialValueFor("cast_range_tooltip")
	
	self.combust_mana_loss						= self.ability:GetSpecialValueFor("combust_mana_loss")
	self.severance_chance						= self.ability:GetSpecialValueFor("severance_chance")
	
	self.initial_slow 							= -100
	self.slow_intervals							= self.initial_slow / self.purge_rate
	
	if not IsServer() then return end
	
	self:SetStackCount(self.initial_slow)
	
	self:StartIntervalThink((self.purge_slow_duration / self.purge_rate)* (1 - self:GetParent():GetStatusResistance()))
end

function modifier_item_imba_witchblade_slow:OnRefresh()
	self:StartIntervalThink(-1)
	self:OnCreated()
end

function modifier_item_imba_witchblade_slow:OnIntervalThink()
	self:SetStackCount(self:GetStackCount() - self.slow_intervals)
end

function modifier_item_imba_witchblade_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_item_imba_witchblade_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

------------------------------
-- WITCHBLADE ROOT MODIFIER --
------------------------------

function modifier_item_imba_witchblade_root:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true
	}
end

-------------------------
-- WITCHBLADE MODIFIER --
-------------------------

function modifier_item_imba_witchblade:IsHidden()		return true end
function modifier_item_imba_witchblade:IsPurgable()		return false end
function modifier_item_imba_witchblade:RemoveOnDeath()	return false end
function modifier_item_imba_witchblade:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_witchblade:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
end

function modifier_item_imba_witchblade:GetModifierBonusStats_Agility()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_agility")
	end
end

function modifier_item_imba_witchblade:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_intellect")
	end
end

function modifier_item_imba_witchblade:GetModifierProcAttack_BonusDamage_Physical(keys)
	if not IsServer() then return end
	
	local ability = self:GetAbility()

	-- Only apply if the attacker is the caster / non-ally team / target has mana / target is not spell immune / only applies to one item
	if ability and keys.attacker == self:GetCaster() and keys.attacker:GetTeam() ~= keys.target:GetTeam() and keys.target:GetMaxMana() > 0 and not keys.target:IsMagicImmune() and self:GetCaster():FindAllModifiersByName(self:GetName())[1] == self then

		-- Apply mana burn particle effect
		local particle = ParticleManager:CreateParticle("particles/item/diffusal/diffusal_manaburn_3.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
		ParticleManager:ReleaseParticleIndex(particle)

		-- Determine amount of mana burn - illusions deal less
		local mana_burn = 0
		
		if keys.attacker:IsIllusion() then
			if keys.attacker:IsRangedAttacker() then
				mana_burn = ability:GetSpecialValueFor("feedback_mana_burn_illusion_ranged")
			elseif not keys.attacker:IsRangedAttacker() then
				mana_burn = ability:GetSpecialValueFor("feedback_mana_burn_illusion_melee")
			end
		else
			mana_burn = ability:GetSpecialValueFor("feedback_mana_burn")
		end
		
		-- Anti Mage Compromise?...
		if self:GetCaster():HasAbility("imba_antimage_mana_break") then
			mana_burn = math.max(mana_burn - self:GetCaster():FindAbilityByName("imba_antimage_mana_break"):GetSpecialValueFor("base_mana_burn"), 0)
		end
		
		-- Get the target's mana, to check how much we're burning him
		local target_mana = keys.target:GetMana()

		-- Burn mana
		keys.target:ReduceMana(mana_burn, ability)

		-- Damage target depending on amount of mana actually burnt
		local damage
		if target_mana >= mana_burn then
			damage = mana_burn * ability:GetSpecialValueFor("damage_per_burn")
		else
			damage = target_mana * ability:GetSpecialValueFor("damage_per_burn")
		end

		return damage
	end
end

function modifier_item_imba_witchblade:OnTakeDamage(keys)
	if not IsServer() then return end

	local target = keys.unit
	local attacker = keys.attacker
	local ability = self:GetAbility()

	-- Only apply if the attacker is the caster / non-ally team / target has mana / target is not spell immune / only applies for one item
	if ability and attacker == self:GetCaster() and attacker:GetTeam() ~= target:GetTeam() and target:GetMaxMana() > 0 and not target:IsMagicImmune() and self:GetCaster():FindAllModifiersByName(self:GetName())[1] == self and keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK and keys.damage > 0 then
		-- Copying part of OnSpellStart code
		-- Roll for a chance to dispel a buff
		if RollPseudoRandom(ability:GetSpecialValueFor("severance_chance"), self) then
			target:EmitSound("DOTA_Item.DiffusalBlade.Target")
	
			-- Play hit particle
			local particle = ParticleManager:CreateParticle("particles/item/diffusal/diffusal_manaburn_3.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle)
			
			-- Get the initial amount of modifiers
			local initial_modifiers = target:GetModifierCount()

			-- Purge target
			target:Purge(true, false, false, false, false)

			-- Find the amount of modifiers it has after it has been purged. Give it a frame to lose modifiers
			Timers:CreateTimer(FrameTime(), function()
				local modifiers_lost = initial_modifiers - target:GetModifierCount()

				if modifiers_lost > 0 then
					-- Burn mana and deal damage according to modifiers lost on the purge
					local mana_burn = modifiers_lost * ability:GetSpecialValueFor("combust_mana_loss")

					-- Burn the target's mana
					local target_mana = target:GetMana()
					target:ReduceMana(mana_burn, ability)

					-- Calculate damage according to burnt mana
					local damage
					if target_mana >= mana_burn then
						damage = mana_burn
					else
						damage = target_mana
					end

					-- Damage the target
					local damageTable = {
						victim = target,
						attacker = attacker,
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = ability,
						damage_flags = (DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL)
					}

					ApplyDamage(damageTable)

					-- Apply the explosion particle effect
					local particle = ParticleManager:CreateParticle("particles/item/diffusal/diffusal_3_dispel_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
					ParticleManager:ReleaseParticleIndex(particle)
				end
			end)
		end
	end
end
