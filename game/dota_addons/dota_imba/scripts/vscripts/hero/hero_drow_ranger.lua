 -- Author: Shush
 -- Date: 08/03/2017

----------------------------
--		FROST ARROWS      --
----------------------------

imba_drow_ranger_frost_arrows = class({})
LinkLuaModifier("modifier_imba_frost_arrows_thinker", "hero/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_arrows_slow", "hero/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_arrows_freeze", "hero/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

function imba_drow_ranger_frost_arrows:GetIntrinsicModifierName()
	return "modifier_imba_frost_arrows_thinker"
end

function imba_drow_ranger_frost_arrows:GetCastRange(Location, Target)
	-- Get caster's cast range
	local caster = self:GetCaster()
	return caster:GetAttackRange()
end

function imba_drow_ranger_frost_arrows:IsStealable()
	return false
end

function imba_drow_ranger_frost_arrows:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self
		local modifier = "modifier_imba_frost_arrows_thinker"
		local target = self:GetCursorTarget()

		-- Tag the current shot as a forced one
		self.force_frost_arrow = true

		-- Force attack the target		
		caster:MoveToTargetToAttack(target)

		-- Replenish mana cost (since it's spent on the OnAttack function)
		ability:RefundManaCost()				
	end
end

-- Frost arrows thinker modifier
modifier_imba_frost_arrows_thinker = class({})



function modifier_imba_frost_arrows_thinker:DeclareFunctions()
	local decFunc = {MODIFIER_EVENT_ON_ATTACK_START,
					MODIFIER_EVENT_ON_ATTACK,
					MODIFIER_EVENT_ON_ATTACK_FAIL,
					MODIFIER_EVENT_ON_ATTACK_LANDED,
					MODIFIER_EVENT_ON_ORDER}

	return decFunc
end

function modifier_imba_frost_arrows_thinker:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()	
	self.parent = self:GetParent()	
	self.sound_cast = "Hero_DrowRanger.FrostArrows"				
	self.modifier_slow = "modifier_imba_frost_arrows_slow"	
end

function modifier_imba_frost_arrows_thinker:OnAttackStart(keys)
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
			self.hero_duration = self.ability:GetSpecialValueFor("hero_duration")
			self.creep_duration = self.ability:GetSpecialValueFor("creep_duration")			

			-- Assume it's a frost arrow unless otherwise stated
			local frost_attack = true

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
				frost_attack = false
			end

			-- If the target is a building or is magic immune, mark attack as non-frost arrow
			if target:IsBuilding() or target:IsMagicImmune() then
				frost_attack = false				
			end

			-- If it wasn't a forced frost attack (through ability cast), or
			-- auto cast is off, change projectile to non-frost and return 
			if not self.ability.force_frost_arrow and not self.auto_cast then								
				frost_attack = false
			end		

			-- If there isn't enough mana to cast a Frost Arrow, assign as a non-frost arrow
			if self.current_mana < self.mana_cost then
				frost_attack = false
			end			

			if frost_attack then
				--mark that attack as a frost arrow							
				self.frost_arrow_attack = true
				SetArrowAttackProjectile(self.caster, true)		
			else
				-- Transform back to usual projectiles
				self.frost_arrow_attack = false
				SetArrowAttackProjectile(self.caster, false)
			end			
		end
	end
end

function modifier_imba_frost_arrows_thinker:OnAttack(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply on caster's attacks
		if self.caster == keys.attacker then			
				
			-- Clear instance of ability's forced frost arrow
			self.ability.force_frost_arrow = nil						

			-- If it wasn't a frost arrow, do nothing
			if not self.frost_arrow_attack then
				return nil
			end							

			-- Emit sound
			EmitSoundOn(self.sound_cast, self.caster)

			-- Spend mana
			self.caster:SpendMana(self.mana_cost, self.ability)			
		end
	end
end

function modifier_imba_frost_arrows_thinker:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply on Drow's attacks
		if self.caster == attacker then	

			-- #2 Talent: Chance to kill creeps instantly			
			if self.caster:HasTalent("special_bonus_imba_drow_ranger_2") then
				local instakill_chance = self.caster:FindTalentValue("special_bonus_imba_drow_ranger_2")

				-- Only applicable on creeps, except ancients
				if target:IsCreep() and not target:IsAncient() then
					if RollPercentage(instakill_chance) then
						target:Kill(self.ability, self.caster)
					end
				end
			end

			-- Only apply if the arrow was a frost attack and the target is alive
			if target:IsAlive() and self.frost_arrow_attack then 
				ApplyFrostAttack(self, target)
			end
		end
	end	
end

function ApplyFrostAttack(modifier, target)
	

	-- Determine duration
	local duration			

	if target:IsHero() then
		duration = modifier.hero_duration
	else
		duration = modifier.creep_duration
	end

	-- #1 Talent: Frost Arrows duration increase
	if modifier.caster:HasTalent("special_bonus_imba_drow_ranger_1") then
		duration = duration + modifier.caster:FindTalentValue("special_bonus_imba_drow_ranger_1")
	end

	-- Apply slow effect if the target didn't suddenly become magic immune				
	if not target:IsMagicImmune() then
		if not target:HasModifier(modifier.modifier_slow) then
			local modifier_slow_handler = target:AddNewModifier(modifier.caster, modifier.ability, modifier.modifier_slow, {duration = duration})			
			if modifier_slow_handler then
				modifier_slow_handler:IncrementStackCount()
			end
		else
			local modifier_slow_handler = target:FindModifierByName(modifier.modifier_slow)						
			modifier_slow_handler:IncrementStackCount()						
			modifier_slow_handler:SetDuration(modifier_slow_handler:GetDuration(), true)
		end
	end	
end

function modifier_imba_frost_arrows_thinker:OnOrder(keys)
	local order_type = keys.order_type	

	-- On any order apart from attacking target, clear the forced frost arrow variable.
	if order_type ~= DOTA_UNIT_ORDER_ATTACK_TARGET then
		self.ability.force_frost_arrow = nil
	end 
end

function SetArrowAttackProjectile(caster, frost_attack)
	-- modifiers
	local skadi_modifier = "modifier_item_imba_skadi_unique"
	local deso_modifier = "modifier_item_imba_desolator_unique"	
	local morbid_modifier = "modifier_item_mask_of_death"
	local mom_modifier = "modifier_item_mask_of_madness"
	local satanic_modifier = "modifier_item_satanic"
	local vladimir_modifier = "modifier_item_imba_vladmir"
	local vladimir_2_modifier = "modifier_item_imba_vladmir_2"

	-- normal projectiles
	local skadi_projectile = "particles/items2_fx/skadi_projectile.vpcf"
	local deso_projectile = "particles/items_fx/desolator_projectile.vpcf"	
	local deso_skadi_projectile = "particles/item/desolator/desolator_skadi_projectile_2.vpcf"	
	local lifesteal_projectile = "particles/item/lifesteal_mask/lifesteal_particle.vpcf"

	-- Frost arrow projectiles
	local basic_arrow = "particles/units/heroes/hero_drow/drow_base_attack.vpcf"
	local frost_arrow = "particles/units/heroes/hero_drow/drow_frost_arrow.vpcf"
	
	local frost_lifesteal_projectile = "particles/hero/drow/lifesteal_arrows/drow_lifedrain_frost_arrow.vpcf"
	local frost_skadi_projectile = "particles/hero/drow/skadi_arrows/drow_skadi_frost_arrow.vpcf"
	local frost_deso_projectile = "particles/hero/drow/deso_arrows/drow_deso_frost_arrow.vpcf"	
	local frost_deso_skadi_projectile = "particles/hero/drow/deso_skadi_arrows/drow_deso_skadi_frost_arrow.vpcf"
	local frost_lifesteal_skadi_projectile = "particles/hero/drow/lifesteal_skadi_arrows/drow_lifesteal_skadi_frost_arrow.vpcf"
	local frost_lifesteal_deso_projectile = "particles/hero/drow/lifesteal_deso_arrows/drow_lifedrain_deso_frost_arrow.vpcf"
	local frost_lifesteal_deso_skadi_projectile = "particles/hero/drow/lifesteal_deso_skadi_arrows/drow_lifesteal_deso_skadi_frost_arrow.vpcf"

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
	if frost_attack then
		-- Desolator + lifesteal + frost + skadi (doesn't exists yet)
		if has_desolator and has_skadi and has_lifesteal then
			caster:SetRangedProjectileName(frost_lifesteal_deso_skadi_projectile)

		-- Desolator + lifesteal + frost
		elseif has_desolator and has_lifesteal then
			caster:SetRangedProjectileName(frost_lifesteal_deso_projectile)

		-- Desolator + skadi + frost 
		elseif has_skadi and has_desolator then
			caster:SetRangedProjectileName(frost_deso_skadi_projectile)

		-- Lifesteal + skadi + frost 
		elseif has_lifesteal and has_skadi then
			caster:SetRangedProjectileName(frost_lifesteal_skadi_projectile)

		-- skadi + frost
		elseif has_skadi then
			caster:SetRangedProjectileName(frost_skadi_projectile)

		-- lifesteal + frost
		elseif has_lifesteal then
			caster:SetRangedProjectileName(frost_lifesteal_projectile)

		-- Desolator + frost			
		elseif has_desolator then
			caster:SetRangedProjectileName(frost_deso_projectile)
			return

		-- Frost
		else
			caster:SetRangedProjectileName(frost_arrow)
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
			caster:SetRangedProjectileName(basic_arrow)
			return 
		end
	end
end

function modifier_imba_frost_arrows_thinker:IsHidden()
	return true
end

function modifier_imba_frost_arrows_thinker:IsPurgable()
	return false
end

function modifier_imba_frost_arrows_thinker:IsDebuff()
	return false
end

-- Slow modifier
modifier_imba_frost_arrows_slow = class({})

function modifier_imba_frost_arrows_slow:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()		
	self.sound_freeze = "hero_Crystal.frostbite"
	self.modifier_freeze = "modifier_imba_frost_arrows_freeze"

	-- Ability specials
	self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")
	self.as_slow = self.ability:GetSpecialValueFor("as_slow")
	self.stacks_to_freeze = self.ability:GetSpecialValueFor("stacks_to_freeze")
	self.freeze_duration = self.ability:GetSpecialValueFor("freeze_duration")

	-- Play freeze sound
	EmitSoundOn(self.modifier_freeze, self.parent)
end

function modifier_imba_frost_arrows_slow:GetTexture()
	return "drow_ranger_frost_arrows"
end

function modifier_imba_frost_arrows_slow:GetEffectName()
	return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_imba_frost_arrows_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_frost_arrows_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_imba_frost_arrows_slow:OnStackCountChanged()
	local stacks = self:GetStackCount()

	-- If the stacks should freeze an enemy, reset the stack count and freeze it!
	if stacks >= self.stacks_to_freeze then
		self:SetStackCount(self:GetStackCount()-self.stacks_to_freeze)
		self.parent:AddNewModifier(self.caster, self.ability, self.modifier_freeze, {duration = self.freeze_duration})
	end
end

function modifier_imba_frost_arrows_slow:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
					 MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFunc
end

function modifier_imba_frost_arrows_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end

function modifier_imba_frost_arrows_slow:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow * (-1)
end

function modifier_imba_frost_arrows_slow:IsHidden()
	return false
end

function modifier_imba_frost_arrows_slow:IsPurgable()
	return true
end

function modifier_imba_frost_arrows_slow:IsDebuff()
	return true
end

-- Freeze modifier
modifier_imba_frost_arrows_freeze = class({})

function modifier_imba_frost_arrows_freeze:CheckState()
	local state = {[MODIFIER_STATE_ROOTED] = true,
				   [MODIFIER_STATE_DISARMED] = true}
	return state				  
end

function modifier_imba_frost_arrows_freeze:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_imba_frost_arrows_freeze:GetEffectAttachType()
	return PATTACH_ABSORIGIN
end

function modifier_imba_frost_arrows_freeze:IsHidden()
	return false
end

function modifier_imba_frost_arrows_freeze:IsPurgable()
	return true
end

function modifier_imba_frost_arrows_freeze:IsDebuff()
	return true
end


----------------------------
--		DEADEYE		      --
----------------------------

imba_drow_ranger_deadeye = class({})
LinkLuaModifier("modifier_imba_deadeye_aura", "hero/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_deadeye_vision", "hero/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

function imba_drow_ranger_deadeye:GetIntrinsicModifierName()
	return "modifier_imba_deadeye_aura"
end

-- Aura modifier
modifier_imba_deadeye_aura = class({})

function modifier_imba_deadeye_aura:OnCreated()
	self.caster = self:GetCaster()
    self.modifier_active = "modifier_imba_trueshot_active"
end

function modifier_imba_deadeye_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_deadeye_aura:GetAuraEntityReject(target)
    if IsServer() then
	   -- Never reject caster	
    	if target == self.caster then
    		return false
    	end    	

    	-- #7 Talent: Deadeye becomes an aura
        if self.caster:HasTalent("special_bonus_imba_drow_ranger_7") then
            if target:IsHero() then
                return false
            end            
        end        

        return true
    end	
end

function modifier_imba_deadeye_aura:GetAuraRadius()
	return 50000 --global
end

function modifier_imba_deadeye_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_imba_deadeye_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_deadeye_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_deadeye_aura:GetModifierAura()
	return "modifier_imba_deadeye_vision"
end

function modifier_imba_deadeye_aura:IsAura()
	-- Stops working when the caster is Broken
	if self.caster:PassivesDisabled() then
		return false
	end

	return true
end

function modifier_imba_deadeye_aura:IsDebuff()
	return false
end

function modifier_imba_deadeye_aura:IsHidden()
	return true
end

function modifier_imba_deadeye_aura:IsPurgable()
	return false
end

-- Vision modifier
modifier_imba_deadeye_vision = class({})

function modifier_imba_deadeye_vision:OnCreated()
    self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	self.day_vision = self.ability:GetSpecialValueFor("day_vision")
	self.night_vision = self.ability:GetSpecialValueFor("night_vision")
end

function modifier_imba_deadeye_vision:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_BONUS_DAY_VISION,
					MODIFIER_PROPERTY_BONUS_NIGHT_VISION}

	return decFunc
end

function modifier_imba_deadeye_vision:GetBonusDayVision()
    if IsServer() then
        -- #6 Talent: Deadeye vision bonuses
        if self.caster:HasTalent("special_bonus_imba_drow_ranger_6") then
            local vision_bonus = self.caster:FindTalentValue("special_bonus_imba_drow_ranger_6")
            CustomNetTables:SetTableValue("talents", "hero_drow_ranger_talents"..tostring(self.caster:GetPlayerOwnerID()), {vision_bonus = vision_bonus})
        end        
    end

    local day_vision = self.day_vision

    if CustomNetTables:GetTableValue( "talents", "hero_drow_ranger_talents"..tostring(self.caster:GetPlayerOwnerID())) then          
        if CustomNetTables:GetTableValue( "talents", "hero_drow_ranger_talents"..tostring(self.caster:GetPlayerOwnerID())).vision_bonus then
            day_vision = day_vision + CustomNetTables:GetTableValue( "talents", "hero_drow_ranger_talents"..tostring(self.caster:GetPlayerOwnerID())).vision_bonus
        end        
    end

	return day_vision
end

function modifier_imba_deadeye_vision:GetBonusNightVision()
     local night_vision = self.night_vision

    if CustomNetTables:GetTableValue( "talents", "hero_drow_ranger_talents"..tostring(self.caster:GetPlayerOwnerID())) then          
        if CustomNetTables:GetTableValue( "talents", "hero_drow_ranger_talents"..tostring(self.caster:GetPlayerOwnerID())).vision_bonus then
            night_vision = night_vision + CustomNetTables:GetTableValue( "talents", "hero_drow_ranger_talents"..tostring(self.caster:GetPlayerOwnerID())).vision_bonus
        end        
    end   

	return night_vision
end

function modifier_imba_deadeye_vision:IsHidden()
	return false
end

function modifier_imba_deadeye_vision:IsPurgable()
	return false
end

function modifier_imba_deadeye_vision:IsDebuff()
	return false
end



----------------------------
--			GUST 		  --
----------------------------

imba_drow_ranger_gust = class({})
LinkLuaModifier("modifier_imba_gust_silence", "hero/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

function imba_drow_ranger_gust:IsHiddenWhenStolen()
	return false
end

function imba_drow_ranger_gust:OnSpellStart()
	-- Ability properties
 	local caster = self:GetCaster()
 	local ability = self
 	local target_point = self:GetCursorPosition()
 	local sound_cast = "Hero_DrowRanger.Silence"
 	local particle_gust = "particles/units/heroes/hero_drow/drow_silence_wave.vpcf"

 	-- Ability specials
 	local wave_speed = ability:GetSpecialValueFor("wave_speed")
 	local wave_distance = ability:GetSpecialValueFor("wave_distance")
 	local wave_width = ability:GetSpecialValueFor("wave_width") 	

 	-- Play cast sound
 	EmitSoundOn(sound_cast, caster) 	

 	-- #4 Talent: Gust effect/knockback range increase
 	if caster:HasTalent("special_bonus_imba_drow_ranger_4") then
 		wave_distance = wave_distance + caster:FindTalentValue("special_bonus_imba_drow_ranger_4")
 	end

 	-- Send Gust!
 	local gust_projectile = {	Ability = ability,
								EffectName = particle_gust,
								vSpawnOrigin = caster:GetAbsOrigin(),
								fDistance = wave_distance,
								fStartRadius = wave_width,
								fEndRadius = wave_width,
								Source = caster,
								bHasFrontalCone = false,
								bReplaceExisting = false,
								iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,							
								iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,							
								bDeleteOnHit = false,
								vVelocity = (((target_point - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()) * wave_speed,
								bProvidesVision = false,							
							}

 	ProjectileManager:CreateLinearProjectile(gust_projectile)
 end 

function imba_drow_ranger_gust:OnProjectileHit(target, location)
	if IsServer() then
		-- Ability properties
	 	local caster = self:GetCaster()
	 	local ability = self
	 	local modifier_silence = "modifier_imba_gust_silence"
	 	local modifier_chill = "modifier_imba_frost_arrows_slow"
	 	local frost_arrow_ability = "imba_drow_ranger_frost_arrows"	 		 	

	 	-- Ability specials 	
	 	local knockback_duration = ability:GetSpecialValueFor("knockback_duration")
	 	local max_distance = ability:GetSpecialValueFor("max_distance")
	 	local silence_duration = ability:GetSpecialValueFor("silence_duration")
	 	local chill_duration = ability:GetSpecialValueFor("chill_duration")
	 	local chill_stacks = ability:GetSpecialValueFor("chill_stacks")
	 	local damage = ability:GetSpecialValueFor("damage")

	 	-- if no target was found, do nothing
	 	if not target then
	 		return nil
	 	end	 	

	 	-- Calculate knockback distance
	 	local distance = max_distance - ((target:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D())
	 	
	 	-- If the distance is higher than the max distance (negative result), just make it go back a little
	 	if distance < 0 then
	 		distance = 50 
	 	end

	 	-- #4 Talent: Gust effect/knockback range increase
		if caster:HasTalent("special_bonus_imba_drow_ranger_4") then
 			distance = distance + caster:FindTalentValue("special_bonus_imba_drow_ranger_4")
	 	end

	 	-- Knockback properties
	 	local knockbackProperties =
	    {
	        center_x = caster:GetAbsOrigin()[1]+1,
	        center_y = caster:GetAbsOrigin()[2]+1,
	        center_z = caster:GetAbsOrigin()[3],
	        duration = knockback_duration,
	        knockback_duration = knockback_duration,
	        knockback_distance = distance,
	        knockback_height = 0,
	        should_stun = 0
	    }

	 	-- Apply knockback on enemies hit
	 	target:AddNewModifier(caster, ability, "modifier_knockback", knockbackProperties)

	 	-- Deal damage
	 	local damageTable = {victim = target,
							damage = damage,
							damage_type = DAMAGE_TYPE_MAGICAL,
							attacker = caster,
							ability = ability
							}
								
		ApplyDamage(damageTable)	

	 	-- Apply silence
	 	target:AddNewModifier(caster, ability, modifier_silence, {duration = silence_duration})

	 	
	 	-- if appropriate, apply chill stacks (only if Frost Arrows were learned)	 		 			
 		if caster:HasAbility(frost_arrow_ability) then	 			
 			local frost_ability = caster:FindAbilityByName(frost_arrow_ability)	 			
 			if frost_ability:GetLevel() > 0 then	 				
                -- #1 Talent: Frost Arrows duration increase
                if caster:HasTalent("special_bonus_imba_drow_ranger_1") then
                    chill_duration = chill_duration + caster:FindTalentValue("special_bonus_imba_drow_ranger_1")
                end

 				-- Apply stacks or increase stacks if already exists
 				if not target:HasModifier(modifier_chill) then
 					local modifier = target:AddNewModifier(caster, frost_ability, modifier_chill, {duration = chill_duration})
 					if modifier then
 						modifier:SetStackCount(chill_stacks)
 					end
 				else
 					local modifier = target:FindModifierByName(modifier_chill)
 					modifier:SetStackCount(modifier:GetStackCount() + chill_stacks)
 				end
 			end
	 	end	 	
	end
end


-- Silence modifier
modifier_imba_gust_silence = class({})

function modifier_imba_gust_silence:CheckState()
 	local state = {[MODIFIER_STATE_SILENCED] = true}
	return state				  
 end 


----------------------------
--	   PRECISION AURA     --
----------------------------

 imba_drow_ranger_trueshot = class({})
 LinkLuaModifier("modifier_imba_trueshot_aura", "hero/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
 LinkLuaModifier("modifier_imba_trueshot", "hero/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
 LinkLuaModifier("modifier_imba_trueshot_active", "hero/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE) 

function imba_drow_ranger_trueshot:GetIntrinsicModifierName()
	return "modifier_imba_trueshot_aura"
end

function imba_drow_ranger_trueshot:IsHiddenWhenStolen()
	return false
end

function imba_drow_ranger_trueshot:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_active = "modifier_imba_trueshot_active"

	-- Ability specials	
	local active_duration = ability:GetSpecialValueFor("active_duration")

	-- Add active modifier
	caster:AddNewModifier(caster, ability, modifier_active, {duration = active_duration})	
end

 -- Trueshot aura
 modifier_imba_trueshot_aura = class({})

function modifier_imba_trueshot_aura:OnCreated()
	self.caster = self:GetCaster()		
	self.modifier_active = "modifier_imba_trueshot_active"
end

function modifier_imba_trueshot_aura:GetAuraEntityReject(target)
	-- Don't reject heroes, even illusion ones
	if target:IsHero() then
		return false
	end

	-- Don't reject anyone, including creeps, if the active modifier is active
	if self.caster:HasModifier(self.modifier_active) then
		return false
	end

	return true
end

function modifier_imba_trueshot_aura:GetAuraDuration()
	return 5
end

function modifier_imba_trueshot_aura:GetAuraRadius()	
	return 50000 --global
end

function modifier_imba_trueshot_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_trueshot_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_trueshot_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_trueshot_aura:GetModifierAura()
	return "modifier_imba_trueshot"
end

function modifier_imba_trueshot_aura:IsAura()
	-- Not an aura when the caster is broken
	if self.caster:PassivesDisabled() then
		return false
	end

	-- Illusions cannot emit the aura
	if self.caster:IsIllusion() then
		return false
	end

	return true
end

function modifier_imba_trueshot_aura:IsDebuff()
	return false
end

function modifier_imba_trueshot_aura:IsHidden()
	return true
end

function modifier_imba_trueshot_aura:IsPurgable()
	return false
end

 -- Trueshot modifier
 modifier_imba_trueshot = class({})

 function modifier_imba_trueshot:OnCreated()  
 	-- Ability properties
 	self.caster = self:GetCaster()
 	self.ability = self:GetAbility()
 	self.parent = self:GetParent()
 	self.modifier_active = "modifier_imba_trueshot_active"

 	-- Ability specials
 	self.agi_to_damage_pct = self.ability:GetSpecialValueFor("agi_to_damage_pct")
 	self.melee_reduction_pct = self.ability:GetSpecialValueFor("melee_reduction_pct")
 	self.active_bonus_agi_pct = self.ability:GetSpecialValueFor("active_bonus_agi_pct")

 	if IsServer() then 		
 		self:StartIntervalThink(1)
 	end
 end

function modifier_imba_trueshot:OnIntervalThink()
	if IsServer() then
		-- Update Drow's agility
		local drow_agility = self.caster:GetAgility()			

        if self.parent:IsHero() then
		  self.parent:CalculateStatBonus()
        end

		-- #3 Talent: Precision Aura damage increase
		if self.caster:HasTalent("special_bonus_imba_drow_ranger_3") then
			drow_agility = drow_agility * (1 + (self.caster:FindTalentValue("special_bonus_imba_drow_ranger_3")/100))
		end

		-- Set the values in the nettable		
		CustomNetTables:SetTableValue( "player_table", "precision_aura_drow_agility"..tostring(self.parent:GetPlayerOwnerID()), { precision_aura_drow_agility = drow_agility})			
	end
end

function modifier_imba_trueshot:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS}

	return decFunc
end

function modifier_imba_trueshot:GetModifierPreAttack_BonusDamage()	
	if CustomNetTables:GetTableValue("player_table", "precision_aura_drow_agility"..tostring(self.parent:GetPlayerOwnerID())) then
		if CustomNetTables:GetTableValue("player_table", "precision_aura_drow_agility"..tostring(self.parent:GetPlayerOwnerID())).precision_aura_drow_agility then
			local drow_agility = CustomNetTables:GetTableValue("player_table", "precision_aura_drow_agility"..tostring(self.parent:GetPlayerOwnerID())).precision_aura_drow_agility						

			-- Calculate bonus damage
			local bonus_damage = drow_agility * (self.agi_to_damage_pct/100)

			-- Reduce damage if the target is melee
			if not self.parent:IsRangedAttacker() then
				bonus_damage = bonus_damage * (self.melee_reduction_pct/100)
			end

			return bonus_damage
		end		
	end	
end

function modifier_imba_trueshot:GetModifierAttackSpeedBonus_Constant()
	return nil
end

function modifier_imba_trueshot:GetModifierBonusStats_Agility()		
	-- Check if Drow's agility was indexed
	if CustomNetTables:GetTableValue("player_table", "precision_aura_drow_agility"..tostring(self.parent:GetPlayerOwnerID())) then
		if CustomNetTables:GetTableValue("player_table", "precision_aura_drow_agility"..tostring(self.parent:GetPlayerOwnerID())).precision_aura_drow_agility then
			local drow_agility = CustomNetTables:GetTableValue("player_table", "precision_aura_drow_agility"..tostring(self.parent:GetPlayerOwnerID())).precision_aura_drow_agility						 			
			-- Only applies when the active component works
			if self.caster:HasModifier(self.modifier_active) then						
				-- Only applies to heroes
				if self.parent:IsHero() then												
					-- Does not apply to Drow herself
					if self.parent ~= self.caster then
						-- Calculate bonus agility
						local bonus_agility = drow_agility * (self.active_bonus_agi_pct/100)																									
						return bonus_agility
					end				
				end
			end
		end
	end

	return nil
end

function modifier_imba_trueshot:IsHidden()
	return false	
end

function modifier_imba_trueshot:IsPurgable()
	return false
end

function modifier_imba_trueshot:IsDebuff()
	return false
end

 -- Active Trueshot modifier
 modifier_imba_trueshot_active = class({})

function modifier_imba_trueshot_active:IsHidden()
	return false	
end

function modifier_imba_trueshot_active:IsPurgable()
	return false
end

function modifier_imba_trueshot_active:IsDebuff()
	return false
end



----------------------------
--	  MARKSMANSHIP        --
----------------------------

imba_drow_ranger_marksmanship = class({})
LinkLuaModifier("modifier_imba_marksmanship", "hero/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_marksmanship_scepter_dmg_reduction", "hero/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

function imba_drow_ranger_marksmanship:GetIntrinsicModifierName()
	return "modifier_imba_marksmanship"
end

function imba_drow_ranger_marksmanship:OnUpgrade()
	-- This is needed to renew values to the correct levels
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self
		local modifier_markx = "modifier_imba_marksmanship"

		if caster:HasModifier(modifier_markx) then
			caster:RemoveModifierByName(modifier_markx)
			caster:AddNewModifier(caster, ability, modifier_markx, {})
		end
	end
end

-- Agility bonus modifier
modifier_imba_marksmanship = class({})

function modifier_imba_marksmanship:OnCreated()		
	-- Ability propertiesw
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.particle_start = "particles/units/heroes/hero_drow/drow_marksmanship_start.vpcf"
	self.particle_marksmanship = "particles/units/heroes/hero_drow/drow_marksmanship.vpcf"

	-- Ability specials
	self.agility_bonus = self.ability:GetSpecialValueFor("agility_bonus")
	self.range_bonus = self.ability:GetSpecialValueFor("range_bonus")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.damage_reduction_scepter = self.ability:GetSpecialValueFor("damage_reduction_scepter")
	self.splinter_radius_scepter = self.ability:GetSpecialValueFor("splinter_radius_scepter")

	if IsServer() then
		-- Assign Marksmanship variable
		self.marksmanship_enabled = false

		self:StartIntervalThink(0.25)
	end
end

function modifier_imba_marksmanship:OnIntervalThink()
	if IsServer() then
		-- #8 Talent: Marksmanship no longer disables itself
        -- Find enemies nearby
            local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
                                              self.caster:GetAbsOrigin(),
                                              nil,
                                              self.radius,
                                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                                              DOTA_UNIT_TARGET_HERO,
                                              DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
                                              FIND_ANY_ORDER,
                                              false)

        if not self.caster:HasTalent("special_bonus_imba_drow_ranger_8") then
            

            -- If there are enemies near drow, destroy particles and disable Marksmanship
            if #enemies > 0 and self.marksmanship_enabled then          
                ParticleManager:DestroyParticle(self.particle_marksmanship_fx, false)
                ParticleManager:ReleaseParticleIndex(self.particle_marksmanship_fx)

                self.marksmanship_enabled = false
            end
        end        

		-- If there aren't and Marksmanship was disabled, enable it and activate particles
		if not self.marksmanship_enabled and #enemies == 0 then
			-- Apply start particle
			self.particle_start_fx = ParticleManager:CreateParticle(self.particle_start, PATTACH_ABSORIGIN, self.caster)
			ParticleManager:SetParticleControl(self.particle_start_fx, 0, self.caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.particle_start_fx)

			-- Apply marksmanship particle
			self.particle_marksmanship_fx = ParticleManager:CreateParticle(self.particle_marksmanship, PATTACH_ABSORIGIN_FOLLOW, self.caster)
			ParticleManager:SetParticleControl(self.particle_marksmanship_fx, 0, self.caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(self.particle_marksmanship_fx, 2, Vector(2,0,0))
			ParticleManager:SetParticleControl(self.particle_marksmanship_fx, 3, self.caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(self.particle_marksmanship_fx, 5, self.caster:GetAbsOrigin())

			self.marksmanship_enabled = true
		end

		-- Either way, recalculate stats.
		self.caster:CalculateStatBonus()
	end
end

function modifier_imba_marksmanship:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
					MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFunc
end

function modifier_imba_marksmanship:GetModifierAttackRangeBonus()
	-- Do nothing if caster is disabled by break
	if self.caster:PassivesDisabled() then
		return nil
	end

	return self.range_bonus
end

function modifier_imba_marksmanship:GetModifierBonusStats_Agility()
	if IsServer() then
		-- Do nothing if caster is disabled by break
		if self.caster:PassivesDisabled() then
			return nil
		end

		-- Only apply if Marksmanship is enabled
		if self.marksmanship_enabled then
			local agility_bonus = self.agility_bonus

			-- #5 Talent: Marksmanship Agility Increase
			if self.caster:HasTalent("special_bonus_imba_drow_ranger_5") then
				agility_bonus = agility_bonus + self.caster:FindTalentValue("special_bonus_imba_drow_ranger_5")
			end

			return agility_bonus
		end
	end
end

function modifier_imba_marksmanship:OnAttackLanded(keys)
	if IsServer() then
		local scepter = self.caster:HasScepter()	
		local target = keys.target
		local attacker = keys.attacker
		local modifier_frost = "modifier_imba_frost_arrows_thinker"

		-- Only apply on caster's attacks, and only when she has scepter
		if self.caster == attacker and scepter then
			-- Find enemies near the target's hit location
			local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
											  target:GetAbsOrigin(),
											  nil,
											  self.splinter_radius_scepter,
											  DOTA_UNIT_TARGET_TEAM_ENEMY,
											  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
											  DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
											  FIND_ANY_ORDER,
											  false)

			-- If any enemies were found, splinter an attack towards them
			if #enemies > 0 then											
				for _,enemy in pairs(enemies) do
					-- Ignore the original target
					if enemy ~= target then
						-- Launch an arrow
						local arrow_projectile						

						arrow_projectile = {hTarget = enemy,
											hCaster = target,
											hAbility = self.ability,
											iMoveSpeed = self.caster:GetProjectileSpeed(),
											EffectName = self.caster:GetRangedProjectileName(),
											SoundName = "",
											flRadius = 1,
											bDodgeable = true,
											bDestroyOnDodge = true,
											iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
											OnProjectileHitUnit = function(params, projectileID)																		
																	  SplinterArrowHit(params, projectileID, self)
																  end
											}						

						TrackingProjectiles:Projectile(arrow_projectile)	
					end					
				end		
			end
		end
	end
end

function SplinterArrowHit(keys, projectileID, modifier)	
	local caster = modifier.caster
	local target = keys.hTarget
	local modifier_reduction = "modifier_imba_marksmanship_scepter_dmg_reduction"

	-- Give caster the weakening effect
	caster:AddNewModifier(modifier.caster, modifier.ability, modifier_reduction, {})

	-- Perform an instant attack on hit enemy
	caster:PerformAttack(target, false, false, true, true, false, false, false)

	-- Remove weakening effect from caster
	caster:RemoveModifierByName(modifier_reduction)

	-- Access the Frost Attack modifier
	if modifier.caster:HasModifier("modifier_imba_frost_arrows_thinker") then
		local modifier_frost = modifier.caster:FindModifierByName("modifier_imba_frost_arrows_thinker")
		ApplyFrostAttack(modifier_frost, target)
	end
end

function modifier_imba_marksmanship:IsPurgable()
	return false
end

function modifier_imba_marksmanship:IsHidden()
	return true
end

function modifier_imba_marksmanship:IsDebuff()
	return false
end

function modifier_imba_marksmanship:OnDestroy()
	-- Make sure the particles don't stay on Drow
	if self.particle_marksmanship_fx then
		ParticleManager:DestroyParticle(self.particle_marksmanship_fx, false)
		ParticleManager:ReleaseParticleIndex(self.particle_marksmanship_fx)
	end
end

-- Scepter splinter damage reduction modifier
modifier_imba_marksmanship_scepter_dmg_reduction = class({})

function modifier_imba_marksmanship_scepter_dmg_reduction:OnCreated()
	self.ability = self:GetAbility()
	self.damage_reduction_scepter = self.ability:GetSpecialValueFor("damage_reduction_scepter")
end

function modifier_imba_marksmanship_scepter_dmg_reduction:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE}

	return decFunc
end

function modifier_imba_marksmanship_scepter_dmg_reduction:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage_reduction_scepter * (-1)
end