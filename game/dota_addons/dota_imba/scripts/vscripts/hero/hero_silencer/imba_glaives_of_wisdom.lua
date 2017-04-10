imba_silencer_glaives_of_wisdom = class({})

function imba_silencer_glaives_of_wisdom:GetCastRange()
	return self:GetCaster():GetAttackRange()
end

function imba_silencer_glaives_of_wisdom:IsStealable()
	return false
end

function imba_silencer_glaives_of_wisdom:GetIntrinsicModifierName()
	return "modifier_imba_silencer_glaives_of_wisdom"
end


function imba_silencer_glaives_of_wisdom:OnSpellStart()
	if IsServer() then
		-- Tag the current shot as a forced one
		self.force_glaive = true

		-- Force attack the target		
		self:GetCaster():MoveToTargetToAttack(self:GetCursorTarget())

		-- Replenish mana cost (since it's spent on the OnAttack function)
		self:RefundManaCost()
	end
end

---------------------------------
-- Glaives of Wisdom intrinsic modifier for attack and particle checks
-- All credit to Shush, whose code I pilfered and adapted
---------------------------------
LinkLuaModifier("modifier_imba_silencer_glaives_of_wisdom", "hero/hero_silencer/imba_glaives_of_wisdom", LUA_MODIFIER_MOTION_NONE)
modifier_imba_silencer_glaives_of_wisdom = class({})

function modifier_imba_silencer_glaives_of_wisdom:DeclareFunctions()
	local decFunc = {MODIFIER_EVENT_ON_ATTACK_START,
					MODIFIER_EVENT_ON_ATTACK,
					MODIFIER_EVENT_ON_ATTACK_LANDED,
					MODIFIER_EVENT_ON_ORDER}

	return decFunc
end

function modifier_imba_silencer_glaives_of_wisdom:OnCreated()
	-- Ability properties
	self.caster = self:GetParent()
	self.ability = self:GetAbility()
	self.sound_cast = "Hero_Silencer.GlaivesOfWisdom"
	self.sound_hit = "Hero_Silencer.GlaivesOfWisdom.Damage"
	self.modifier_int_damage = "modifier_imba_silencer_glaives_int_damage"
	self.modifier_hit_counter = "modifier_imba_silencer_glaives_hit_counter"
end

function modifier_imba_silencer_glaives_of_wisdom:OnAttackStart(keys)
	if IsServer() then	
		local attacker = keys.attacker
		local target = keys.target		

		-- Do absolutely nothing if the attacker is an illusion
		if attacker:IsIllusion() then
			return nil
		end

		-- Only apply on caster's attacks
		if self.caster == attacker then						
			-- Ability specials
			self.intellect_damage_pct = self.ability:GetSpecialValueFor("intellect_damage_pct") + self.caster:FindTalentValue("special_bonus_imba_silencer_6")
			self.hits_to_silence = self.ability:GetSpecialValueFor("hits_to_silence")
			self.hit_count_duration = self.ability:GetSpecialValueFor("hit_count_duration")
			self.silence_duration = self.ability:GetSpecialValueFor("silence_duration") + self.caster:FindTalentValue("special_bonus_imba_silencer_5")
			self.int_reduction_pct = self.ability:GetSpecialValueFor("int_reduction_pct")
			self.int_reduction_duration = self.ability:GetSpecialValueFor("int_reduction_duration")

			-- Assume it's a frost arrow unless otherwise stated
			local glaive_attack = true

			-- Initialize attack table
			if not self.attack_table then
				self.attack_table = {}
			end

			-- Get variables
			self.auto_cast = self.ability:GetAutoCastState()
			self.current_mana = self.caster:GetMana()
			self.mana_cost = self.ability:GetManaCost(-1)			

			-- If the caster is silenced, mark attack as non-frost arrow
			if self.caster:IsSilenced() then
				glaive_attack = false
			end

			-- If the target is a building or is magic immune, mark attack as non-frost arrow
			if target:IsBuilding() or target:IsMagicImmune() then
				glaive_attack = false				
			end

			-- If it wasn't a forced frost attack (through ability cast), or
			-- auto cast is off, change projectile to non-frost and return 
			if not self.ability.force_glaive and not self.auto_cast then								
				glaive_attack = false
			end		

			-- If there isn't enough mana to cast a Frost Arrow, assign as a non-frost arrow
			if self.current_mana < self.mana_cost then
				glaive_attack = false
			end			

			if glaive_attack then
				--mark that attack as a frost arrow							
				self.glaive_attack = true
				SetGlaiveAttackProjectile(self.caster, true)		
			else
				-- Transform back to usual projectiles
				self.glaive_attack = false
				SetGlaiveAttackProjectile(self.caster, false)
			end			
		end
	end
end

function modifier_imba_silencer_glaives_of_wisdom:OnAttack(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply on caster's attacks
		if self.caster == keys.attacker then			
				
			-- Clear instance of ability's forced frost arrow
			self.ability.force_glaive = nil						

			-- If it wasn't a frost arrow, do nothing
			if not self.glaive_attack then
				return nil
			end							

			-- Emit sound
			EmitSoundOn(self.sound_cast, self.caster)

			-- Spend mana
			self.caster:SpendMana(self.mana_cost, self.ability)			
		end
	end
end

function modifier_imba_silencer_glaives_of_wisdom:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply on Silencer's attacks
		if self.caster == attacker then	

			if target:IsAlive() and self.glaive_attack then 
				local glaive_pure_damage = self.caster:GetIntellect() * self.intellect_damage_pct / 100

				local damage_table = {
					victim = target,
					attacker = attacker,
					damage = glaive_pure_damage,
					damage_type = self.ability:GetAbilityDamageType(),
					ability = self.ability
				}

				ApplyDamage( damage_table )

				local hit_counter = target:FindModifierByName(self.modifier_hit_counter)
				if not hit_counter then
					hit_counter = target:AddNewModifier(self.caster, self.ability, self.modifier_hit_counter, {req_hits = self.hits_to_silence, silence_dur = self.silence_duration})
				end
				hit_counter:IncrementStackCount()
				hit_counter:SetDuration(self.hit_count_duration, true)

				local int_damage = target:FindModifierByName(self.modifier_int_damage)
				if not int_damage then
					int_damage = target:AddNewModifier(self.caster, self.ability, self.modifier_int_damage, {int_reduction = self.int_reduction_pct})
				end
				int_damage:IncrementStackCount()
				int_damage:SetDuration(self.int_reduction_duration, true)
				
				EmitSoundOn(self.sound_hit, target)
			end
		end
	end
end

function modifier_imba_silencer_glaives_of_wisdom:OnOrder(keys)
	local order_type = keys.order_type	

	-- On any order apart from attacking target, clear the forced frost arrow variable.
	if order_type ~= DOTA_UNIT_ORDER_ATTACK_TARGET then
		self.ability.force_glaive = nil
	end 
end

function modifier_imba_silencer_glaives_of_wisdom:IsHidden()
	return true
end

function modifier_imba_silencer_glaives_of_wisdom:IsPurgable()
	return false
end

function modifier_imba_silencer_glaives_of_wisdom:IsDebuff()
	return false
end

function SetGlaiveAttackProjectile(caster, is_glaive_attack)
	-- modifiers
	local skadi_modifier = "modifier_item_imba_skadi_unique"
	local deso_modifier = "modifier_item_imba_desolator_unique"	
	local morbid_modifier = "modifier_item_mask_of_death"
	local mom_modifier = "modifier_imba_mask_of_madness"
	local satanic_modifier = "modifier_item_satanic"
	local vladimir_modifier = "modifier_item_imba_vladmir"
	local vladimir_2_modifier = "modifier_item_imba_vladmir_blood"

	-- normal projectiles
	local skadi_projectile = "particles/items2_fx/skadi_projectile.vpcf"
	local deso_projectile = "particles/items_fx/desolator_projectile.vpcf"	
	local deso_skadi_projectile = "particles/item/desolator/desolator_skadi_projectile_2.vpcf"	
	local lifesteal_projectile = "particles/item/lifesteal_mask/lifesteal_particle.vpcf"

	-- Frost arrow projectiles
	local base_attack = "particles/units/heroes/hero_silencer/silencer_base_attack.vpcf"
	local glaive_attack = "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf"
	
	local glaive_lifesteal_projectile = "particles/hero/silencer/lifesteal_glaives/silencer_lifesteal_glaives_of_wisdom.vpcf"
	local glaive_skadi_projectile = "particles/hero/silencer/skadi_glaives/silencer_skadi_glaives_of_wisdom.vpcf"
	local glaive_deso_projectile = "particles/hero/silencer/deso_glaives/silencer_deso_glaives_of_wisdom.vpcf"
	local glaive_deso_skadi_projectile = "particles/hero/silencer/deso_skadi_glaives/silencer_deso_skadi_glaives_of_wisdom.vpcf"
	local glaive_lifesteal_skadi_projectile = "particles/hero/silencer/lifesteal_skadi_glaives/silencer_lifesteal_skadi_glaives_of_wisdom.vpcf"
	local glaive_lifesteal_deso_projectile = "particles/hero/silencer/lifesteal_deso_glaives/silencer_lifesteal_deso_glaives_of_wisdom.vpcf"
	local glaive_lifesteal_deso_skadi_projectile = "particles/hero/silencer/lifesteal_deso_skadi_glaives/silencer_lifesteal_deso_skadi_glaives_of_wisdom.vpcf"

	-- Set variables
	local has_lifesteal
	local has_skadi
	local has_desolator

	-- Assign variables
	-- Lifesteal
	if caster:HasModifier(morbid_modifier) or caster:HasModifier(mom_modifier) or caster:HasModifier(satanic_modifier) or caster:HasModifier(vladimir_modifier) or caster:HasModifier(vladimir_2_modifier) then
		has_lifesteal = true
	end

	-- Skadi
	if caster:HasModifier(skadi_modifier) then
		has_skadi = true
	end

	-- Desolator
	if caster:HasModifier(deso_modifier) then
		has_desolator = true
	end

	-- ASSIGN PARTICLES
	-- Frost attack
	if is_glaive_attack then
		-- Desolator + lifesteal + frost + skadi (doesn't exists yet)
		if has_desolator and has_skadi and has_lifesteal then
			caster:SetRangedProjectileName(glaive_lifesteal_deso_skadi_projectile)

		-- Desolator + lifesteal + frost
		elseif has_desolator and has_lifesteal then
			caster:SetRangedProjectileName(glaive_lifesteal_deso_projectile)

		-- Desolator + skadi + frost 
		elseif has_skadi and has_desolator then
			caster:SetRangedProjectileName(glaive_deso_skadi_projectile)

		-- Lifesteal + skadi + frost 
		elseif has_lifesteal and has_skadi then
			caster:SetRangedProjectileName(glaive_lifesteal_skadi_projectile)

		-- skadi + frost
		elseif has_skadi then
			caster:SetRangedProjectileName(glaive_skadi_projectile)

		-- lifesteal + frost
		elseif has_lifesteal then
			caster:SetRangedProjectileName(glaive_lifesteal_projectile)

		-- Desolator + frost			
		elseif has_desolator then
			caster:SetRangedProjectileName(glaive_deso_projectile)
			return

		-- Frost
		else
			caster:SetRangedProjectileName(glaive_attack)
			return
		end
	
	else -- Non frost attack
		-- Skadi + desolator
		if has_skadi and has_desolator then
			caster:SetRangedProjectileName(deso_skadi_projectile)
			return

		-- Skadi
		elseif has_skadi then
			caster:SetRangedProjectileName(skadi_projectile)

		-- Desolator
		elseif has_desolator then
			caster:SetRangedProjectileName(deso_projectile)
			return 

		 Lifesteal
		elseif has_lifesteal then
			caster:SetRangedProjectileName(lifesteal_projectile)

		-- Basic arrow
		else
			caster:SetRangedProjectileName(base_attack)
			return 
		end
	end
end

---------------------------------
-- Glaives of Wisdom hit counter dummy modifier
---------------------------------
LinkLuaModifier("modifier_imba_silencer_glaives_hit_counter", "hero/hero_silencer/imba_glaives_of_wisdom", LUA_MODIFIER_MOTION_NONE)
modifier_imba_silencer_glaives_hit_counter = class({})

function modifier_imba_silencer_glaives_hit_counter:OnCreated( kv )
	if IsServer() then
		self.target = self:GetParent()
		self.caster = self:GetAbility():GetCaster()
		self.hits_to_silence = kv.req_hits
		self.silence_duration = kv.silence_dur
	end
end

function modifier_imba_silencer_glaives_hit_counter:OnStackCountChanged(old_stack_count)
	if IsServer() then
		if self:GetStackCount() >= self.hits_to_silence then
			self:GetParent():AddNewModifier(self.caster, self:GetAbility(), "modifier_silence", {duration = self.silence_duration})
			self:SetStackCount(0)
		end
	end
end

function modifier_imba_silencer_glaives_hit_counter:IsDebuff()
	return true
end

function modifier_imba_silencer_glaives_hit_counter:IsHidden()
	return true
end

---------------------------------
-- Glaives of Wisdom int reduction modifier
---------------------------------
LinkLuaModifier("modifier_imba_silencer_glaives_int_damage", "hero/hero_silencer/imba_glaives_of_wisdom", LUA_MODIFIER_MOTION_NONE)
modifier_imba_silencer_glaives_int_damage = class({})

function modifier_imba_silencer_glaives_int_damage:OnCreated( kv )
	if IsServer() then
		self.caster = self:GetCaster()
		self.int_reduction_pct = kv.int_reduction
		self.total_int_reduced = 0
	end
end

function modifier_imba_silencer_glaives_int_damage:IsDebuff()
	return true
end

function modifier_imba_silencer_glaives_int_damage:OnStackCountChanged(old_stack_count)
	if IsServer() then
		local target = self:GetParent()
		local target_intelligence = target:GetIntellect()
		if target_intelligence > 1 then
			local int_to_steal = math.max(1, math.floor(target_intelligence * self.int_reduction_pct / 100))
			local int_taken
			if ( (target_intelligence - int_to_steal) >= 1 ) then
				int_taken = int_to_steal
			else
				int_taken = -(1 - target_intelligence)
			end
			-- Calculate the amount of mana to remove, based on int-based max mana
			local mana_to_burn = self.int_reduction_pct / 100 * target:GetMana() * ( target_intelligence * 12 + 50 ) / target:GetMaxMana()
			self.total_int_reduced = self.total_int_reduced + int_taken
			target:ReduceMana(mana_to_burn)
			target:CalculateStatBonus()
		end
	end
end

function modifier_imba_silencer_glaives_int_damage:GetTexture()
	return "silencer_glaives_of_wisdom"
end

function modifier_imba_silencer_glaives_int_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}

	return funcs
end

function modifier_imba_silencer_glaives_int_damage:GetModifierBonusStats_Intellect()
	return -self.total_int_reduced
end