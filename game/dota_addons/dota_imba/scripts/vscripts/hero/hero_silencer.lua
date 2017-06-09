CreateEmptyTalents("silencer")

----------------------------------------------------
-- Arcane Curse
----------------------------------------------------
imba_silencer_arcane_curse = imba_silencer_arcane_curse or class({})

function imba_silencer_arcane_curse:GetAbilityTextureName()
   return "silencer_curse_of_the_silent"
end

function imba_silencer_arcane_curse:OnSpellStart()
	local point = self:GetCursorPosition()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local base_duration = self:GetSpecialValueFor("base_duration")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), 0, 0, false)
	local aoe = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_curse_aoe.vpcf", PATTACH_POINT, caster)
		ParticleManager:SetParticleControl( aoe, 0, point )
		ParticleManager:SetParticleControl( aoe, 1, Vector(radius, radius, radius) )

	EmitSoundOn("Hero_Silencer.Curse.Cast", caster)

	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_imba_arcane_curse_debuff", {duration = base_duration})
		EmitSoundOn("Hero_Silencer.Curse.Impact", enemy)
	end
end

function imba_silencer_arcane_curse:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

---------------------------------
-- Arcane Curse debuff modifier
---------------------------------
LinkLuaModifier("modifier_imba_arcane_curse_debuff", "hero/hero_silencer", LUA_MODIFIER_MOTION_NONE)
modifier_imba_arcane_curse_debuff = modifier_imba_arcane_curse_debuff or class({})

function modifier_imba_arcane_curse_debuff:OnCreated( kv )
	self.parent = self:GetParent()
	self.caster = self:GetAbility():GetCaster()
	self.tick_rate = self:GetAbility():GetSpecialValueFor("tick_rate")
	self.curse_slow = self:GetAbility():GetSpecialValueFor("curse_slow")
	self.curse_damage = self:GetAbility():GetSpecialValueFor("damage_per_second")
	self.penalty_duration = self:GetAbility():GetSpecialValueFor("penalty_duration")	
	self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")
	self.talent_learned = self.caster:HasTalent("special_bonus_imba_silencer_1")

	if IsServer() then
		self.penalty_duration = self.penalty_duration + self.caster:FindTalentValue("special_bonus_imba_silencer_2")
		self.curse_slow = self.curse_slow + self.caster:FindTalentValue("special_bonus_imba_silencer_7")

		if self.caster:HasScepter() then
			self.aghs_upgraded = true
		else
			self.aghs_upgraded = false
		end
		self:StartIntervalThink( self.tick_rate )
	end
end

function modifier_imba_arcane_curse_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_arcane_curse_debuff:GetEffectName()
	return "particles/units/heroes/hero_silencer/silencer_curse.vpcf"
end

function modifier_imba_arcane_curse_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_arcane_curse_debuff:GetTexture()
	return "silencer_curse_of_the_silent"
end

function modifier_imba_arcane_curse_debuff:IsPurgable()
	return true
end

function modifier_imba_arcane_curse_debuff:IsDebuff()
	return true
end

function modifier_imba_arcane_curse_debuff:OnIntervalThink()
	if IsServer() then
		local target = self.parent

		if target:IsSilenced() then
			self:SetDuration( self:GetRemainingTime() + self.tick_rate, true )
		end

		if ( not target:IsSilenced() ) or self.aghs_upgraded then
			local damage_dealt = self.curse_damage * self.tick_rate			
			local stack_count = self:GetStackCount()

			if stack_count then
				damage_dealt = damage_dealt + (self.damage_per_stack * stack_count)
			end

			local damage_table = {
					victim = target,
					attacker = self.caster,
					damage = damage_dealt,
					damage_type = self:GetAbility():GetAbilityDamageType(),
					ability = self:GetAbility()
				}

			local actual_Damage = ApplyDamage( damage_table )

			-- #1 Talent: Silencer heals from Arcane Curse damage
			if self.talent_learned then
				local heal_amount = actual_Damage * self.caster:FindTalentValue("special_bonus_imba_silencer_1") * 0.01
				self.caster:Heal(heal_amount, self.caster)

				-- Show heal particles on the caster
				local particle_lifesteal = "particles/generic_gameplay/generic_lifesteal.vpcf"
				local particle_lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, self.caster)
				ParticleManager:SetParticleControl(particle_lifesteal_fx, 0, self.caster:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle_lifesteal_fx)
			end			
		end
	end
end

function modifier_imba_arcane_curse_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_imba_arcane_curse_debuff:OnAbilityExecuted( params )
	if IsServer() then		
		if params.ability then			
			if ( not params.ability:IsItem() ) and ( params.unit == self.parent ) then
				
				-- Ignore toggles
				if params.ability:IsToggle() then
					return nil
				end

				-- List of abilities that shouldn't get triggered by Arcane Curse
				local uneffected_spells = {"invoker_quas",
										   "invoker_wex",
										   "invoker_exort",
											"ancient_apparition_ice_blast_release",
											"earth_spirit_stone_caller",
											"elder_titan_return_spirit",
											"ember_spirit_fire_remnant",
											"wisp_tether_break",
											"keeper_of_the_light_illuminate_end",
											"keeper_of_the_light_spirit_form_illuminate_end",
											"life_stealer_control",
											"life_stealer_consume",
											"life_stealer_assimilate_eject",
											"monkey_king_tree_dance",
											"monkey_king_primal_spring_early",
											"monkey_king_mischief",
											"monkey_king_untransform",
											"naga_siren_song_of_the_siren_cancel",
											"nyx_assassin_burrow",
											"nyx_assassin_unburrow",
											"phoenix_icarus_dive_stop",
											"phoenix_launch_fire_spirit",
											"phoenix_sun_ray_stop",
											"puck_ethereal_jaunt",
											"puck_phase_shift",
											"shadow_demon_shadow_poison_release",
											"spectre_reality",
											"imba_techies_minefield_sign",
											"techies_focused_detonate",
											"templar_assassin_trap",
											"shredder_return_chakram",
											"shredder_return_chakram_2",											
											"imba_drow_ranger_frost_arrows",
											"imba_jakiro_liquid_fire",
											"imba_obsidian_destroyer_arcane_orb",
											"imba_sniper_take_aim"}

				-- If the ability is one of those spells that should be ignored, do nothing
				for _, spell in pairs(uneffected_spells) do
					if params.ability:GetName() == spell then
						return nil
					end
				end

				self:SetDuration( self:GetRemainingTime() + self.penalty_duration, true )
				self:IncrementStackCount()
			end
		end
	end
end

function modifier_imba_arcane_curse_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return -self.curse_slow
end

----------------------------------------------------
-- Glaives of Wisdom
----------------------------------------------------
imba_silencer_glaives_of_wisdom = imba_silencer_glaives_of_wisdom or class({})

function imba_silencer_glaives_of_wisdom:GetAbilityTextureName()
   return "silencer_glaives_of_wisdom"
end

function imba_silencer_glaives_of_wisdom:IsNetherWardStealable() return false end
function imba_silencer_glaives_of_wisdom:IsStealable() return false end

function imba_silencer_glaives_of_wisdom:GetCastRange()
	return self:GetCaster():GetAttackRange()
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
LinkLuaModifier("modifier_imba_silencer_glaives_of_wisdom", "hero/hero_silencer", LUA_MODIFIER_MOTION_NONE)
modifier_imba_silencer_glaives_of_wisdom = modifier_imba_silencer_glaives_of_wisdom or class({})

function modifier_imba_silencer_glaives_of_wisdom:IsHidden() return true end
function modifier_imba_silencer_glaives_of_wisdom:IsPurgable() return false end
function modifier_imba_silencer_glaives_of_wisdom:IsDebuff() return false end

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

				if hit_counter then
					hit_counter:IncrementStackCount()
					hit_counter:SetDuration(self.hit_count_duration, true)
				end

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
LinkLuaModifier("modifier_imba_silencer_glaives_hit_counter", "hero/hero_silencer", LUA_MODIFIER_MOTION_NONE)
modifier_imba_silencer_glaives_hit_counter = modifier_imba_silencer_glaives_hit_counter or class({})

function modifier_imba_silencer_glaives_hit_counter:IsDebuff() return true end
function modifier_imba_silencer_glaives_hit_counter:IsHidden() return true end

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
---------------------------------
-- Glaives of Wisdom int reduction modifier
---------------------------------
LinkLuaModifier("modifier_imba_silencer_glaives_int_damage", "hero/hero_silencer", LUA_MODIFIER_MOTION_NONE)
modifier_imba_silencer_glaives_int_damage = modifier_imba_silencer_glaives_int_damage or class({})

function modifier_imba_silencer_glaives_int_damage:IsDebuff() return true end

function modifier_imba_silencer_glaives_int_damage:OnCreated( kv )
	if IsServer() then
		self.caster = self:GetCaster()
		self.int_reduction_pct = kv.int_reduction
		self.total_int_reduced = 0
	end
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

--------------------------------------------------
-- Last Word
--------------------------------------------------
imba_silencer_last_word = imba_silencer_last_word or class({})

function imba_silencer_last_word:GetAbilityTextureName()
   return "silencer_last_word"
end

function imba_silencer_last_word:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()

	if IsServer() then
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(self) then
				return nil
			end
		end

		EmitSoundOn("Hero_Silencer.LastWord.Cast", caster)

		target:AddNewModifier(caster, self, "modifier_imba_silencer_last_word_debuff", {duration = self:GetDuration()})
	end
end

function imba_silencer_last_word:GetIntrinsicModifierName()
	return "imba_silencer_last_word_aura"
end

----------------------------------------------------
-- Last Word silence talent aura
----------------------------------------------------
LinkLuaModifier("imba_silencer_last_word_aura", "hero/hero_silencer", LUA_MODIFIER_MOTION_NONE)
imba_silencer_last_word_aura = imba_silencer_last_word_aura or class({})

function imba_silencer_last_word_aura:IsHidden() return true end
function imba_silencer_last_word_aura:IsAuraActiveOnDeath() return false end

function imba_silencer_last_word_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
end

function imba_silencer_last_word_aura:IsAura()
	if self:GetCaster():HasTalent("special_bonus_imba_silencer_8") then
		return true
	else
		return false
	end

	return false
end

function imba_silencer_last_word_aura:GetModifierAura()
	return "imba_silencer_last_word_silence_aura"
end

function imba_silencer_last_word_aura:GetAuraRadius()
	return self.aura_radius
end

function imba_silencer_last_word_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function imba_silencer_last_word_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end


----------------------------------------------------
-- Last Word silence talent aura prevention
----------------------------------------------------
LinkLuaModifier("imba_silencer_last_word_aura_prevent", "hero/hero_silencer", LUA_MODIFIER_MOTION_NONE)
imba_silencer_last_word_aura_prevent = imba_silencer_last_word_aura_prevent or class({})

function imba_silencer_last_word_aura_prevent:IsHidden() return false end
function imba_silencer_last_word_aura_prevent:IsPurgable() return false end
function imba_silencer_last_word_aura_prevent:IsDebuff() return false end


----------------------------------------------------
-- Last Word aura enemy silence modifier
----------------------------------------------------
LinkLuaModifier("imba_silencer_last_word_silence_aura", "hero/hero_silencer", LUA_MODIFIER_MOTION_NONE)
imba_silencer_last_word_silence_aura = imba_silencer_last_word_silence_aura or class({})

function imba_silencer_last_word_silence_aura:IsDebuff() return true end
function imba_silencer_last_word_silence_aura:IsPurgable() return false end

function imba_silencer_last_word_silence_aura:OnCreated( kv )
	self.silence_duration = self:GetAbility():GetSpecialValueFor("aura_silence")
	self.prevention_duration = self:GetCaster():FindTalentValue("special_bonus_imba_silencer_8")
	self.modifier_prevention = "imba_silencer_last_word_aura_prevent"
end

function imba_silencer_last_word_silence_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end

function imba_silencer_last_word_silence_aura:OnAbilityExecuted( params )
	if IsServer() then
		if ( not params.ability:IsItem() ) and ( params.unit == self:GetParent() ) and ( not self:GetParent():IsMagicImmune() ) then
			if CheckExceptions(params.ability) then
				return
			end
			if params.ability:IsToggle() and params.ability:GetToggleState() then
				return
			end

			-- If Last Aura aura was already triggered, do nothing
			if self:GetCaster():HasModifier(self.modifier_prevention) then
			 	return nil
			end

			-- Add prevention modifier
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), self.modifier_prevention, {duration = self.prevention_duration})

			-- Silence!
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_silence", {duration = self.silence_duration})
		end
	end
end

function imba_silencer_last_word_silence_aura:GetTexture()
	return "silencer_last_word"
end

----------------------------------------------------
-- Last Word initial debuff : disarms and provides vision of target
----------------------------------------------------
LinkLuaModifier("modifier_imba_silencer_last_word_debuff", "hero/hero_silencer", LUA_MODIFIER_MOTION_NONE)
modifier_imba_silencer_last_word_debuff = modifier_imba_silencer_last_word_debuff or class({})

function modifier_imba_silencer_last_word_debuff:IsPurgable() return true end

function modifier_imba_silencer_last_word_debuff:OnCreated( kv )
	self.caster = self:GetCaster()

	if IsServer() then
		EmitSoundOn("Hero_Silencer.LastWord.Target", self:GetParent())
		self.damage = self:GetAbility():GetAbilityDamage()
		self.silence_duration = self:GetAbility():GetSpecialValueFor("silence_duration")
		self:StartIntervalThink(self:GetAbility():GetDuration())
	end
end

function modifier_imba_silencer_last_word_debuff:OnDestroy( kv )
	if not self:GetParent():IsMagicImmune() then
		if IsServer() then
			EmitSoundOn("Hero_Silencer.LastWord.Damage", self:GetParent())
			local damage_table = {
					victim = self:GetParent(),
					attacker = self.caster,
					damage = self.damage,
					damage_type = self:GetAbility():GetAbilityDamageType(),
					ability = self:GetAbility()
				}
			ApplyDamage(damage_table)
		end
	end
end

function modifier_imba_silencer_last_word_debuff:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_PROVIDES_VISION] = true,
	}

	return state
end

function modifier_imba_silencer_last_word_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end

function modifier_imba_silencer_last_word_debuff:OnAbilityExecuted( params )
	if IsServer() then
		if ( not params.ability:IsItem() ) and ( params.unit == self:GetParent() ) then
			if CheckExceptions(params.ability) then
				return
			end
			if params.ability:IsToggle() and params.ability:GetToggleState() then
				return
			end
			self:GetParent():AddNewModifier(self.caster, self:GetAbility(), "modifier_imba_silencer_last_word_repeat_thinker", {duration = self.silence_duration})
			self:Destroy()
		end
	end
end

function modifier_imba_silencer_last_word_debuff:OnIntervalThink()
	local target = self:GetParent()
	if IsServer() then
		target:AddNewModifier(self.caster, self:GetAbility(), "modifier_silence", {duration = self.silence_duration})
	end
end

function modifier_imba_silencer_last_word_debuff:GetEffectName()
	return "particles/units/heroes/hero_silencer/silencer_last_word_status.vpcf"
end

function modifier_imba_silencer_last_word_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function CheckExceptions(ability)
	local exceptions = {
		["imba_silencer_glaives_of_wisdom"] = true,
		["imba_drow_ranger_frost_arrows"] = true,
		["imba_clinkz_searing_arrows"] = true,
	}

	if exceptions[ability:GetName()] then
		return true
	end

	if ability:GetManaCost(-1) == 0 then
		return true
	end

	return false
end

----------------------------------------------------
-- Last Word repeat thinker : casts Last Word on parent when the modifier expires
----------------------------------------------------
LinkLuaModifier("modifier_imba_silencer_last_word_repeat_thinker", "hero/hero_silencer", LUA_MODIFIER_MOTION_NONE)
modifier_imba_silencer_last_word_repeat_thinker = modifier_imba_silencer_last_word_repeat_thinker or class({})

function modifier_imba_silencer_last_word_repeat_thinker:IsDebuff() return true end
function modifier_imba_silencer_last_word_repeat_thinker:IsPurgable() return true end

function modifier_imba_silencer_last_word_repeat_thinker:OnCreated( kv )
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.modifier = "modifier_imba_silencer_last_word_debuff"
end

function modifier_imba_silencer_last_word_repeat_thinker:OnDestroy( kv )
	if IsServer() then
		if not self:GetParent():IsMagicImmune() then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), self.modifier, {duration = self.duration})
		end
	end
end

function modifier_imba_silencer_last_word_repeat_thinker:CheckState()
	local state = {
	[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

--------------------------------------------------------
-- Arcane Supremacy
--------------------------------------------------------
imba_silencer_arcane_supremacy = imba_silencer_arcane_supremacy or class({})

function imba_silencer_arcane_supremacy:GetAbilityTextureName()
   return "custom/arcane_supremacy"
end

LinkLuaModifier("modifier_imba_silencer_arcane_supremacy", "hero/hero_silencer", LUA_MODIFIER_MOTION_NONE)
modifier_imba_silencer_arcane_supremacy = modifier_imba_silencer_arcane_supremacy or class({})

-- Properties
function imba_silencer_arcane_supremacy:IsInnateAbility() return true end
function modifier_imba_silencer_arcane_supremacy:AllowIllusionDuplicate() return false end
function modifier_imba_silencer_arcane_supremacy:RemoveOnDeath() return false end
function modifier_imba_silencer_arcane_supremacy:IsPermanent() return true end
function modifier_imba_silencer_arcane_supremacy:IsPurgeable() return false end

function imba_silencer_arcane_supremacy:GetIntrinsicModifierName()
	return "modifier_imba_silencer_arcane_supremacy"
end

function modifier_imba_silencer_arcane_supremacy:GetTexture()
    return "custom/arcane_supremacy"
end
-------------

function modifier_imba_silencer_arcane_supremacy:OnCreated( kv )
	self.steal_range = self:GetAbility():GetSpecialValueFor("int_steal_range")
	self.steal_amount = self:GetAbility():GetSpecialValueFor("int_steal_amount")
	self.silence_reduction_pct = self:GetAbility():GetSpecialValueFor("silence_reduction_pct")
	self.caster = self:GetCaster()
end

function modifier_imba_silencer_arcane_supremacy:GetSilenceReductionPct()
	local reduction = self.silence_reduction_pct + self.caster:FindTalentValue("special_bonus_imba_silencer_4")

	return reduction
end

function modifier_imba_silencer_arcane_supremacy:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_imba_silencer_arcane_supremacy:OnDeath( params )
	if IsServer() then		
		if self.caster:PassivesDisabled() then
			return nil
		end
		if params.unit:IsRealHero() and ( params.unit ~= self.caster ) and ( params.unit:GetTeam() ~= self.caster:GetTeam() ) then

			-- If the dead unit is reincarnating, do nothing
			if params.reincarnate then
				return nil
			end

			local distance = ( self.caster:GetAbsOrigin() - params.unit:GetAbsOrigin() ):Length2D()
			if ( distance <= self.steal_range ) or ( params.attacker == self.caster ) or ( params.unit:HasModifier("modifier_imba_silencer_global_silence") ) then
				local enemy_min_int = 1
				local enemy_intelligence = params.unit:GetBaseIntellect()
				local enemy_intelligence_taken = 0
				local steal_amount = self.steal_amount + self.caster:FindTalentValue("special_bonus_imba_silencer_3")

				if enemy_intelligence > enemy_min_int then
					if ( (enemy_intelligence - steal_amount) >= enemy_min_int ) then
						enemy_intelligence_taken = steal_amount
					else
						enemy_intelligence_taken = -(enemy_min_int - enemy_intelligence)
					end
					params.unit:SetBaseIntellect( enemy_intelligence - enemy_intelligence_taken )
					params.unit:CalculateStatBonus()

					self.caster:SetBaseIntellect(self.caster:GetBaseIntellect() + enemy_intelligence_taken)
					self:SetStackCount(self:GetStackCount() + enemy_intelligence_taken)
					self.caster:CalculateStatBonus()

					-- Copied from https://moddota.com/forums/discussion/1156/modifying-silencers-int-steal
					local life_time = 2.0
					local digits = string.len( math.floor( enemy_intelligence_taken ) ) + 1
					local numParticle = ParticleManager:CreateParticle( "particles/msg_fx/msg_miss.vpcf", PATTACH_OVERHEAD_FOLLOW, self.caster )
					ParticleManager:SetParticleControl( numParticle, 1, Vector( 10, enemy_intelligence_taken, 0 ) )
					ParticleManager:SetParticleControl( numParticle, 2, Vector( life_time, digits, 0 ) )
					ParticleManager:SetParticleControl( numParticle, 3, Vector( 100, 100, 255 ) )
				end
			end
		end
	end
end

---------------------------------------------------------
-- Global Silence
---------------------------------------------------------
imba_silencer_global_silence = imba_silencer_global_silence or class({})

function imba_silencer_global_silence:GetAbilityTextureName()
   return "silencer_global_silence"
end

function imba_silencer_global_silence:OnSpellStart()
	local caster = self:GetCaster()
	local curse_ability = caster:FindAbilityByName("imba_silencer_arcane_curse")
	if IsServer() then
		EmitSoundOn("Hero_Silencer.GlobalSilence.Cast", caster)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_global_silence.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier(caster, self, "modifier_imba_silencer_global_silence", {duration = self:GetDuration()})
			if curse_ability and curse_ability:IsTrained() then
				enemy:AddNewModifier(caster, curse_ability, "modifier_imba_arcane_curse_debuff", {duration = self:GetDuration()})
			end
			EmitSoundOnClient("Hero_Silencer.GlobalSilence.Effect", enemy:GetPlayerOwner())
		end
	end
end
------------------------------------------------
-- Global Silence modifier
------------------------------------------------
LinkLuaModifier("modifier_imba_silencer_global_silence", "hero/hero_silencer", LUA_MODIFIER_MOTION_NONE)
modifier_imba_silencer_global_silence = modifier_imba_silencer_global_silence or class({})

function modifier_imba_silencer_global_silence:IsPurgable() return true end
function modifier_imba_silencer_global_silence:IsDebuff() return true end

function modifier_imba_silencer_global_silence:GetEffectName()
	return "particles/generic_gameplay/generic_silence.vpcf"
end

function modifier_imba_silencer_global_silence:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_silencer_global_silence:CheckState()
	local state = {
	[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

function modifier_imba_silencer_global_silence:GetTexture()
	return "silencer_global_silence"
end