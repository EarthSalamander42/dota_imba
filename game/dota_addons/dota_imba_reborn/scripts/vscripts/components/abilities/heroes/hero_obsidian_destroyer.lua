-- Author: Shush
-- Author: 17/04/2017

---------------------------
--       ARCANE ORB      --
---------------------------
imba_obsidian_destroyer_arcane_orb = class({})
LinkLuaModifier("modifier_imba_arcane_orb_thinker", "components/abilities/heroes/hero_obsidian_destroyer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_arcane_orb_buff", "components/abilities/heroes/hero_obsidian_destroyer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_arcane_orb_debuff", "components/abilities/heroes/hero_obsidian_destroyer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_arcane_orb_instance", "components/abilities/heroes/hero_obsidian_destroyer.lua", LUA_MODIFIER_MOTION_NONE)

function imba_obsidian_destroyer_arcane_orb:GetAbilityTextureName()
   return "obsidian_destroyer_arcane_orb"
end

function imba_obsidian_destroyer_arcane_orb:IsStealable()
	return false
end

function imba_obsidian_destroyer_arcane_orb:IsNetherWardStealable()
	return false
end

function imba_obsidian_destroyer_arcane_orb:GetIntrinsicModifierName()
	return "modifier_imba_arcane_orb_thinker"
end

function imba_obsidian_destroyer_arcane_orb:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self
		local modifier = "modifier_imba_arcane_orb_thinker"
		local target = self:GetCursorTarget()

		-- Tag the current shot as a forced one
		self.force_arcane_orb = true

		-- Force attack the target              
		caster:MoveToTargetToAttack(target)

		-- Replenish mana cost (since it's spent on the OnAttack function)
		ability:RefundManaCost()
	end
end

function imba_obsidian_destroyer_arcane_orb:GetCastRange(location, target)
	-- Get caster's cast range
	local caster = self:GetCaster()
	return caster:Script_GetAttackRange()
end


-- Arcane Orb thinker modifier
modifier_imba_arcane_orb_thinker = class({})

function modifier_imba_arcane_orb_thinker:DeclareFunctions()
	local decFunc = {MODIFIER_EVENT_ON_ATTACK_START,
					MODIFIER_EVENT_ON_ATTACK,
					MODIFIER_EVENT_ON_ATTACK_FAIL,
					MODIFIER_EVENT_ON_ATTACK_LANDED,
					MODIFIER_EVENT_ON_ORDER}

	return decFunc
end

function modifier_imba_arcane_orb_thinker:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()        
	self.sound_cast = "Hero_ObsidianDestroyer.ArcaneOrb"             
	self.particle_explosion = "particles/hero/outworld_devourer/arcane_orb_explosion.vpcf"
	self.particle_explosion_scatter = "particles/hero/outworld_devourer/arcane_orb_explosion_f.vpcf"
	self.modifier_buff = "modifier_imba_arcane_orb_buff"  
	self.modifier_debuff = "modifier_imba_arcane_orb_debuff"    
	self.modifier_essence = "modifier_imba_essence_aura_buff"
	self.mana_per_int = 12

	-- Ability specials
	self.mana_pool_damage_pct = self.ability:GetSpecialValueFor("mana_pool_damage_pct")
	self.illusion_bonus_dmg = self.ability:GetSpecialValueFor("illusion_bonus_dmg")
	self.int_steal_duration = self.ability:GetSpecialValueFor("int_steal_duration")
	self.int_steal_count = self.ability:GetSpecialValueFor("int_steal_count")
	self.splash_radius = self.ability:GetSpecialValueFor("splash_radius")
end

function modifier_imba_arcane_orb_thinker:OnAttackStart(keys)
	if IsServer() then  
		local attacker = keys.attacker
		local target = keys.target      

		-- Do absolutely nothing if the attacker is an illusion
		if attacker:IsIllusion() then
			return nil
		end

		-- Only apply on caster's attacks
		if self.caster == attacker then
			-- Assume it's an Arcane Orb unless otherwise stated
			local orb_attack = true            

			-- Get variables
			self.auto_cast = self.ability:GetAutoCastState()
			self.current_mana = self.caster:GetMana()
			self.mana_cost = self.ability:GetManaCost(-1) * attacker:GetStatusResistance()

			-- If the caster is silenced, mark attack as non-orb
			if self.caster:IsSilenced() then
				orb_attack = false
			end

			-- If the target is a building or is magic immune, mark attack as non-orb
			if target:IsBuilding() or target:IsMagicImmune() then
				orb_attack = false                
			end

			if self.caster:GetTeamNumber() == target:GetTeamNumber() then
				orb_attack = false
			end

			-- If it wasn't a forced arcane orb attack (through ability cast), or
			-- auto cast is off, change projectile to non-orb
			if not self.ability.force_arcane_orb and not self.auto_cast then                               
				orb_attack = false
			end     

			-- If there isn't enough mana to cast an Arcane Orb, assign as a non-orb attack
			if self.current_mana < self.mana_cost then
				orb_attack = false
			end         

			if orb_attack then
				--mark that attack as an Arcane Orb attack
				self.arcane_orb_attack = true
				SetArcaneOrbProjectile(self.caster, true)     
			else
				-- Transform back to usual projectiles
				self.arcane_orb_attack = false
				SetArcaneOrbProjectile(self.caster, false)
			end         
		end
	end
end

function modifier_imba_arcane_orb_thinker:OnAttack(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply on caster's attacks
		if self.caster == keys.attacker then
			-- Clear instance of ability's forced arcane orb attack
			self.ability.force_arcane_orb = nil                        

			-- If it wasn't an arcane orb, do nothing
			if not self.arcane_orb_attack then
				return nil
			end                         

			-- Emit sound
			EmitSoundOn(self.sound_cast, self.caster)

			-- Spend mana
			self.ability:UseResources(true, false, false)        
			
			-- If the caster has the Essence Aura buff, roll for a proc
			if self.caster:HasModifier(self.modifier_essence) then
				local modifier_essence_handler = self.caster:FindModifierByName(self.modifier_essence)
				if modifier_essence_handler then
					modifier_essence_handler:ProcEssenceAura()
				end
			end
		end
	end
end

function modifier_imba_arcane_orb_thinker:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply on caster's attacks
		if self.caster == attacker then                         

			-- Only apply if the attack was an arcane orb and the target is alive
			if target:IsAlive() and self.arcane_orb_attack then 
				self:ApplyArcaneOrbAttack(target)
			end
		end
	end 
end

function modifier_imba_arcane_orb_thinker:OnRefresh()
	self:OnCreated()
end

function modifier_imba_arcane_orb_thinker:ApplyArcaneOrbAttack(target)    

	-- Apply effect if the target didn't suddenly become magic immune              
	if not target:IsMagicImmune() then

		-- Calculate bonus pure damage according to a percent of current mana
		local damage = self.caster:GetMana() * self.mana_pool_damage_pct * 0.01

		-- Add damage if the target is a summoned unit or an illusion
		if target:IsSummoned() or target:IsIllusion() then
			damage = damage + self.illusion_bonus_dmg
		end

		-- Deal damage
		local damageTable = {victim = target,
							damage = damage,
							damage_type = DAMAGE_TYPE_PURE,
							damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
							attacker = self.caster,
							ability = self.ability
							}
							
		ApplyDamage(damageTable)

		-- Show damage alert
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, damage, nil)

		-- If a target is an illusion or a summoned unit, check if it's still alive after the damage instance
		if target:IsSummoned() or target:IsIllusion() then
			Timers:CreateTimer(FrameTime(), function()

				-- If the target has died, deal damage to all nearby enemies in a blast!
				if not target:IsAlive() then

					-- Add main particle                            
					self.particle_explosion_fx = ParticleManager:CreateParticle(self.particle_explosion, PATTACH_ABSORIGIN_FOLLOW, target)
					ParticleManager:SetParticleControl(self.particle_explosion_fx, 0, target:GetAbsOrigin())
					ParticleManager:SetParticleControl(self.particle_explosion_fx, 1, target:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(self.particle_explosion_fx)

					-- Add unleashed energy particles
					self.particle_explosion_scatter_fx = ParticleManager:CreateParticle(self.particle_explosion_scatter, PATTACH_ABSORIGIN, self.caster)
					ParticleManager:SetParticleControl(self.particle_explosion_scatter_fx, 0, target:GetAbsOrigin())
					ParticleManager:SetParticleControl(self.particle_explosion_scatter_fx, 3, Vector(self.splash_radius, 0, 0))
					ParticleManager:ReleaseParticleIndex(self.particle_explosion_scatter_fx)

					-- Find all units in radius
					local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
													  target:GetAbsOrigin(),
													  nil,
													  self.splash_radius,
													  DOTA_UNIT_TARGET_TEAM_ENEMY,
													  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
													  DOTA_UNIT_TARGET_FLAG_NONE,
													  FIND_ANY_ORDER,
													  false)

					-- Deal the pure damage it dealt to that unit to all enemies
					for _,enemy in pairs(enemies) do
						-- Deal damage
						local damageTable = {victim = enemy,
											damage = (damage - self.illusion_bonus_dmg),
											damage_type = DAMAGE_TYPE_PURE,
											damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
											attacker = self.caster,
											ability = self.ability
											}
											
						ApplyDamage(damageTable)

						-- Show damage alert
						SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damage, nil)
					end                    
				end
			end)
		end

		-- If the target is not a hero, do nothing else (don't steal int)
		if not target:IsRealHero() then
			return nil
		end

		local int_steal_count = self.int_steal_count

		-- Steal intelligence from target
		ApplyIntelligenceSteal(self.caster, self.ability, target, int_steal_count, self.int_steal_duration)
		
		-- #1 Talent: Arcane Orb now explodes the difference between the target's and caster's INT in 300 AOE
		if self.caster:HasTalent("special_bonus_imba_obsidian_destroyer_1") and self.caster:GetIntellect() > target:GetIntellect() then
		
		Timers:CreateTimer(FrameTime(), function()
			local damage = self.caster:GetIntellect() - target:GetIntellect()
				
			-- Add main particle                            
			self.particle_explosion_fx = ParticleManager:CreateParticle(self.particle_explosion, PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(self.particle_explosion_fx, 0, Vector(self.caster:FindTalentValue("special_bonus_imba_obsidian_destroyer_1"), 0, 0))
			ParticleManager:SetParticleControl(self.particle_explosion_fx, 1, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.particle_explosion_fx)

			-- Find all units in radius
			local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
												  target:GetAbsOrigin(),
												  nil,
												  self.caster:FindTalentValue("special_bonus_imba_obsidian_destroyer_1"),
												  DOTA_UNIT_TARGET_TEAM_ENEMY,
												  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
												  DOTA_UNIT_TARGET_FLAG_NONE,
												  FIND_ANY_ORDER,
												  false)

			-- Deal the pure damage it dealt to that unit to all enemies
			for _,enemy in pairs(enemies) do
				-- Deal damage
				local damageTable = {victim = enemy,
				damage = damage,
				damage_type = DAMAGE_TYPE_PURE,
				attacker = self.caster,
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				ability = self.ability
				}
														
				ApplyDamage(damageTable)

				-- Show damage alert
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damage, nil)
			end  
		end)
		end
	end 
end

function modifier_imba_arcane_orb_thinker:OnOrder(keys)
	if keys.unit == self.caster then
		local order_type = keys.order_type  

		-- On any order apart from attacking target, clear the forced frost arrow variable.
		if order_type ~= DOTA_UNIT_ORDER_ATTACK_TARGET then
			self.ability.force_arcane_orb = nil
		end
	end
end

function SetArcaneOrbProjectile(caster, orb_attack)
	-- modifiers
	local skadi_modifier = "modifier_item_imba_skadi_unique"
	local deso_modifier = "modifier_item_imba_desolator_unique" 
	local morbid_modifier = "modifier_imba_morbid_mask"
	local mom_modifier = "modifier_imba_mask_of_madness"
	local satanic_modifier = "modifier_imba_satanic"
	local vladimir_modifier = "modifier_item_imba_vladmir"
	local vladimir_2_modifier = "modifier_item_imba_vladmir_blood"

	-- normal projectiles
	local skadi_projectile = "particles/items2_fx/skadi_projectile.vpcf"
	local deso_projectile = "particles/items_fx/desolator_projectile.vpcf"  
	local deso_skadi_projectile = "particles/item/desolator/desolator_skadi_projectile_2.vpcf"  
	local lifesteal_projectile = "particles/item/lifesteal_mask/lifesteal_particle.vpcf"

	-- Arcane Orb projectiles
	local basic_attack = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_base_attack.vpcf"
	local arcane_orb = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf"
	
	local lifesteal_arcane_orb_projectile = "particles/hero/outworld_devourer/lifesteal_orb/lifesteal_arcane_orb.vpcf"
	local skadi_arcane_orb_projectile = "particles/hero/outworld_devourer/skadi_orb/skadi_orb.vpcf"
	local desolator_arcane_orb_projectile = "particles/hero/outworld_devourer/desolator_orb/desolator_arcane_orb.vpcf"  
	local deso_skadi_orb_projectile = "particles/hero/outworld_devourer/deso_skadi_orb/deso_skadi_arcane_orb.vpcf"
	local lifesteal_skadi_arcane_projectile = "particles/hero/outworld_devourer/lifesteal_skadi_orb/lifesteal_skadi_orb.vpcf"
	local lifesteal_deso_arcane_orb_projectile = "particles/hero/outworld_devourer/lifesteal_deso_orb/lifesteal_deso_arcane_orb.vpcf"
	local lifesteal_deso_skadi_arcane_projectile = "particles/hero/outworld_devourer/lifesteal_deso_skadi_orb/deso_skadi_orb/lifesteal_deso_skadi_arcane_orb.vpcf"

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
	-- Arcane Orb attack
	if orb_attack then
		-- Desolator + lifesteal + skadi + Arcane Orb
		if has_desolator and has_skadi and has_lifesteal then
			caster:SetRangedProjectileName(lifesteal_deso_skadi_arcane_projectile)

		-- Desolator + lifesteal + Arcane Orb
		elseif has_desolator and has_lifesteal then
			caster:SetRangedProjectileName(lifesteal_deso_arcane_orb_projectile)

		-- Desolator + skadi + Arcane Orb
		elseif has_skadi and has_desolator then
			caster:SetRangedProjectileName(deso_skadi_orb_projectile)

		-- Lifesteal + skadi + Arcane Orb
		elseif has_lifesteal and has_skadi then
			caster:SetRangedProjectileName(lifesteal_skadi_arcane_projectile)

		-- skadi + Arcane Orb
		elseif has_skadi then
			caster:SetRangedProjectileName(skadi_arcane_orb_projectile)

		-- lifesteal + Arcane Orb
		elseif has_lifesteal then
			caster:SetRangedProjectileName(lifesteal_arcane_orb_projectile)

		-- Desolator + Arcane Orb            
		elseif has_desolator then
			caster:SetRangedProjectileName(desolator_arcane_orb_projectile)
			return

		-- Arcane Orb
		else
			caster:SetRangedProjectileName(arcane_orb)
			return
		end
	
	else -- Non arcane orb attack
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

		-- Lifesteal
		elseif has_lifesteal then
			caster:SetRangedProjectileName(lifesteal_projectile)

		-- Basic orb
		else
			caster:SetRangedProjectileName(basic_attack)
			return 
		end
	end
end

function modifier_imba_arcane_orb_thinker:IsHidden()
	return true
end

function modifier_imba_arcane_orb_thinker:IsPurgable()
	return false
end

function modifier_imba_arcane_orb_thinker:IsDebuff()
	return false
end

function ApplyIntelligenceSteal(caster, ability, target, stack_count, duration)    
	-- Ability properties
	local mana_per_int = 12
	local modifier_buff = "modifier_imba_arcane_orb_buff"  
	local modifier_debuff = "modifier_imba_arcane_orb_debuff"           

	if not target:HasModifier(modifier_debuff) then
		target:AddNewModifier(caster, ability, modifier_debuff, {duration = duration})                                                   
	end            

	local modifier_debuff_handler = target:FindModifierByName(modifier_debuff)                                 
	if modifier_debuff_handler then                
		for i = 1, stack_count do
			-- Remove mana from the target for each stack
			target:ReduceMana(mana_per_int)

			-- Increment the stack count
			modifier_debuff_handler:IncrementStackCount()
			modifier_debuff_handler:ForceRefresh()
		end
	end        

	-- Apply int steal buff on caster        
	if not caster:HasModifier(modifier_buff) then
		caster:AddNewModifier(caster, ability, modifier_buff, {duration = duration})                                   
	end

	local modifier_buff_handler = caster:FindModifierByName(modifier_buff)                     
	if modifier_buff_handler then
		for i = 1, stack_count do

			-- Increment the stack count
			modifier_buff_handler:IncrementStackCount()
			modifier_buff_handler:ForceRefresh()
		end
	end

	-- #2 Talent: Sanity Eclipse's cooldown is reduced by 1 second for each instance of INT steal Obsidian Destroyer applies
	if caster:HasTalent("special_bonus_imba_obsidian_destroyer_2") then
		local modifier_stack = "modifier_imba_arcane_orb_instance"
		-- Apply int the steal modifier on caster        
		if not caster:HasModifier(modifier_stack) then
			caster:AddNewModifier(caster, ability, modifier_stack, {duration = duration})                                   
		end
		
		local modifier_stack_handler = caster:FindModifierByName(modifier_stack)                     
		if modifier_stack_handler then
		-- Increment the stack count
			modifier_stack_handler:IncrementStackCount()
			modifier_stack_handler:ForceRefresh()
		end
	end
end

-- Arcane Orb int steal buff
modifier_imba_arcane_orb_buff = class({})

function modifier_imba_arcane_orb_buff:GetTexture()
	return "obsidian_destroyer_arcane_orb"
end

function modifier_imba_arcane_orb_buff:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()        

		-- Ability specials
		self.int_steal_duration = self.ability:GetSpecialValueFor("int_steal_duration")

		-- Initialize table
		self.stacks_table = {}        

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_arcane_orb_buff:OnIntervalThink()
	if IsServer() then

		-- Check if there are any stacks left on the table
		if #self.stacks_table > 0 then

			-- For each stack, check if it is past its expiration time. If it is, remove it from the table
			for i = #self.stacks_table, 1, -1 do
				if self.stacks_table[i] + self.int_steal_duration < GameRules:GetGameTime() then
					table.remove(self.stacks_table, i)                          
				end
			end
			
			-- If after removing the stacks, the table is empty, remove the modifier.
			if #self.stacks_table == 0 then
				self:Destroy()

			-- Otherwise, set its stack count
			else
				self:SetStackCount(#self.stacks_table)
			end

			-- Recalculate bonus based on new stack count
			self:GetParent():CalculateStatBonus()

		-- If there are no stacks on the table, just remove the modifier.
		else
			self:Destroy()
		end
	end
end

function modifier_imba_arcane_orb_buff:OnRefresh()
	if IsServer() then
		-- Insert new stack values
		table.insert(self.stacks_table, GameRules:GetGameTime())
	end
end

function modifier_imba_arcane_orb_buff:IsHidden() return false end
function modifier_imba_arcane_orb_buff:IsPurgable() return false end
function modifier_imba_arcane_orb_buff:IsDebuff() return false end

function modifier_imba_arcane_orb_buff:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}

	return decFunc
end

function modifier_imba_arcane_orb_buff:GetModifierBonusStats_Intellect()
	local stacks = self:GetStackCount()
	return stacks
end


-- Arcane Orb int steal debuff
modifier_imba_arcane_orb_debuff = class({})

function modifier_imba_arcane_orb_debuff:GetTexture()
	return "obsidian_destroyer_arcane_orb"
end

function modifier_imba_arcane_orb_debuff:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.mana_per_int = 12

		-- Ability specials
		self.int_steal_duration = self.ability:GetSpecialValueFor("int_steal_duration")

		-- Initialize table
		self.stacks_table = {}        

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_arcane_orb_debuff:OnIntervalThink()
	if IsServer() then

		-- Check if there are any stacks left on the table
		if #self.stacks_table > 0 then

			-- For each stack, check if it is past its expiration time. If it is, remove it from the table
			for i = #self.stacks_table, 1, -1 do
				if self.stacks_table[i] + self.int_steal_duration < GameRules:GetGameTime() then
					table.remove(self.stacks_table, i)      

					-- Give mana lost to the parent
					self.parent:GiveMana(self.mana_per_int)
				end
			end
			
			-- If after removing the stacks, the table is empty, remove the modifier.
			if #self.stacks_table == 0 then
				self:Destroy()

			-- Otherwise, set its stack count
			else
				self:SetStackCount(#self.stacks_table)
			end

			-- Recalculate bonus based on new stack count
			self:GetParent():CalculateStatBonus()

		-- If there are no stacks on the table, just remove the modifier.
		else
			self:Destroy()
		end
	end
end

function modifier_imba_arcane_orb_debuff:OnRefresh()
	if IsServer() then
		-- Insert new stack values
		table.insert(self.stacks_table, GameRules:GetGameTime())
	end
end

function modifier_imba_arcane_orb_debuff:IsHidden() return false end
function modifier_imba_arcane_orb_debuff:IsPurgable() return false end
function modifier_imba_arcane_orb_debuff:IsDebuff() return true end

function modifier_imba_arcane_orb_debuff:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}

	return decFunc
end

function modifier_imba_arcane_orb_debuff:GetModifierBonusStats_Intellect()
	local stacks = self:GetStackCount()
	return stacks * (-1)
end


-- Arcane Orb int steal instance
modifier_imba_arcane_orb_instance = class({})

function modifier_imba_arcane_orb_instance:GetTexture()
    return "obsidian_destroyer_sanity_eclipse"
end

function modifier_imba_arcane_orb_instance:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent()        

        -- Ability specials
        self.int_steal_duration = self.ability:GetSpecialValueFor("int_steal_duration")

        -- Initialize table
        self.stacks_table = {}        

        -- Start thinking
        self:StartIntervalThink(0.1)
    end
end

function modifier_imba_arcane_orb_instance:OnIntervalThink()
    if IsServer() then

        -- Check if there are any stacks left on the table
        if #self.stacks_table > 0 then

            -- For each stack, check if it is past its expiration time. If it is, remove it from the table
            for i = #self.stacks_table, 1, -1 do
                if self.stacks_table[i] + self.int_steal_duration < GameRules:GetGameTime() then
                    table.remove(self.stacks_table, i)                          
                end
            end
            
            -- If after removing the stacks, the table is empty, remove the modifier.
            if #self.stacks_table == 0 then
                self:Destroy()

            -- Otherwise, set its stack count
            else
                self:SetStackCount(#self.stacks_table)
            end

            -- Recalculate bonus based on new stack count
            self:GetParent():CalculateStatBonus()

        -- If there are no stacks on the table, just remove the modifier.
        else
            self:Destroy()
        end
    end
end

function modifier_imba_arcane_orb_instance:OnRefresh()
    if IsServer() then
        -- Insert new stack values
        table.insert(self.stacks_table, GameRules:GetGameTime())
    end
end

function modifier_imba_arcane_orb_instance:IsHidden() return false end
function modifier_imba_arcane_orb_instance:IsPurgable() return false end
function modifier_imba_arcane_orb_instance:IsDebuff() return false end


---------------------------
--  ASTRAL IMPRISONMENT  --
---------------------------
imba_obsidian_destroyer_astral_imprisonment = class({})
LinkLuaModifier("modifier_imba_astral_imprisonment", "components/abilities/heroes/hero_obsidian_destroyer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_astral_imprisonment_buff", "components/abilities/heroes/hero_obsidian_destroyer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_astral_imprisonment_sucked", "components/abilities/heroes/hero_obsidian_destroyer.lua", LUA_MODIFIER_MOTION_NONE)

function imba_obsidian_destroyer_astral_imprisonment:GetAbilityTextureName()
   return "obsidian_destroyer_astral_imprisonment"
end

function imba_obsidian_destroyer_astral_imprisonment:GetBehavior()
	local caster = self:GetCaster()
	local modifier_self = "modifier_imba_astral_imprisonment_buff"

	-- If a prison is ongoing, change the spell to a point target
	if caster:HasModifier(modifier_self) then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK        
	end

	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end

function imba_obsidian_destroyer_astral_imprisonment:CastFilterResultTarget(target)   
	if IsServer() then
		local caster = self:GetCaster()
		local casterID = caster:GetPlayerOwnerID()
		local targetID = target:GetPlayerOwnerID()

		if target ~= nil and not target:IsOpposingTeam(caster:GetTeamNumber()) and PlayerResource:IsDisableHelpSetForPlayerID(targetID,casterID) then
			return UF_FAIL_DISABLE_HELP
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_obsidian_destroyer_astral_imprisonment:GetCastPoint()
	-- If a prison is ongoing, remove the cast point
	if self:GetCaster():HasModifier("modifier_imba_astral_imprisonment_buff") then
		return 0
	end

	return self.BaseClass.GetCastPoint(self)
end

function imba_obsidian_destroyer_astral_imprisonment:GetCastRange(location, target)
	-- If a prison is ongoing, allow it to be cast globally
	if self:GetCaster():HasModifier("modifier_imba_astral_imprisonment_buff") then
		return 25000
	end   

	-- Otherwise, normal cast range
	local cast_range = self:GetSpecialValueFor("cast_range")

	return cast_range    
end

function imba_obsidian_destroyer_astral_imprisonment:GetManaCost(level)
	-- If a prison is ongoing, remove the mana cost
	if self:GetCaster():HasModifier("modifier_imba_astral_imprisonment_buff") then
		return 0
	end

	return self.BaseClass.GetManaCost(self, level)
end

function imba_obsidian_destroyer_astral_imprisonment:GetCooldown(level)
	local prison_duration = self:GetSpecialValueFor("prison_duration")

	-- If a prison is ongoing, remove the cooldown
	if self:GetCaster():HasModifier("modifier_imba_astral_imprisonment_buff") then
		return 0
	end

	if IsServer() then
		return self.BaseClass.GetCooldown(self, level) - prison_duration
	end

	-- Make the client see the full cooldown
	return self.BaseClass.GetCooldown(self, level)
end

function imba_obsidian_destroyer_astral_imprisonment:IsHiddenWhenStolen()
	local caster = self:GetCaster()
	if caster:HasAbility("imba_obsidian_destroyer_sanity_eclipse") then
		return true
	end

	return false
end

function imba_obsidian_destroyer_astral_imprisonment:OnSpellStart()    
	-- Ability properties    
	local caster = self:GetCaster()
	local modifier_self = "modifier_imba_astral_imprisonment_buff"

	-- ASTRAL PRISON
	if not caster:HasModifier(modifier_self) then
		-- Ability properties
		local target = self:GetCursorTarget()    
		local sound_cast = "Hero_ObsidianDestroyer.AstralImprisonment.Cast"     
		local modifier_prison = "modifier_imba_astral_imprisonment"        
		local modifier_essence = "modifier_imba_essence_aura_buff"

		-- Ability specials
		local prison_duration = self:GetSpecialValueFor("prison_duration")    

		-- Play cast sound
		EmitSoundOn(sound_cast, caster)  

		-- If there was no target (happens because of the transitions from point to target), do nothing
		if not target then
			return nil
		end       

		-- If target has Linken's sphere ready, do nothing
		if caster:GetTeamNumber() ~= target:GetTeamNumber() then
			if target:TriggerSpellAbsorb(self) then
				return nil
			end
		end

		-- Restart cooldown
		self:EndCooldown()

		-- Apply the imprisonment modifier on the target
		local prison_modifier = target:AddNewModifier(caster, self, modifier_prison, {duration = prison_duration})

		-- Give self a buff that would allow the spell to move the prison
		local modifier_self_handler = caster:AddNewModifier(caster, self, modifier_self, {duration = prison_modifier:GetRemainingTime()})
		if modifier_self_handler then
			modifier_self_handler.target = target
			modifier_self_handler.target_point = target:GetAbsOrigin()
		end

		-- Apply the imprisonment modifier on the target
		target:AddNewModifier(caster, self, modifier_prison, {duration = prison_duration})

		-- If the caster has Essence Aura, roll for a proc
		if caster:HasModifier(modifier_essence) then
			modifier_essence_handler = caster:FindModifierByName(modifier_essence)
			if modifier_essence_handler then
				modifier_essence_handler:ProcEssenceAura()
			end
		end

		self:UseResources(false, false, true)
	else
	-- MOVE ACTIVE PRISON
		-- Ability properties
		local target_point = self:GetCursorPosition()    

		-- Find the self buff, and assign a new target point
		local modifier_self_handler = caster:FindModifierByName(modifier_self)
		if modifier_self_handler then
			modifier_self_handler.target_point = target_point
		end
	end
end

-- Prison modifier 
modifier_imba_astral_imprisonment = class({})

function modifier_imba_astral_imprisonment:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()    
		self.sound_astral = "Hero_ObsidianDestroyer.AstralImprisonment"
		self.sound_end = "Hero_ObsidianDestroyer.AstralImprisonment.End"         
		self.particle_prison = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf"
		self.particle_prison_end = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_end.vpcf"
		self.modifier_prison_self = "modifier_imba_astral_imprisonment_buff"
		self.scepter = self.caster:HasScepter()

		-- Ability specials
		self.radius = self.ability:GetSpecialValueFor("radius")
		self.damage = self.ability:GetSpecialValueFor("damage")        
		self.scepter_int_steal_count = self.ability:GetSpecialValueFor("scepter_int_steal_count")
		self.scepter_int_steal_duration = self.ability:GetSpecialValueFor("scepter_int_steal_duration")

		-- Play astral prison loop sound
		EmitSoundOn(self.sound_astral, self.parent)

		-- Remove the model
		self.parent:AddNoDraw()

		-- If the caster has scepter, steal intelligence if it is an enemy
		if self.scepter and self.parent:GetTeamNumber() ~= self.caster:GetTeamNumber() then        
			ApplyIntelligenceSteal(self.caster, self.ability, self.parent, self.scepter_int_steal_count, self.scepter_int_steal_duration)
		end

		-- Wait one frame. If the caster doesn't have the self buff, it means it's been triggered from Sanity Eclipse
		Timers:CreateTimer(FrameTime(), function()
			if self.scepter and not self.caster:HasModifier(self.modifier_prison_self) then
				-- Apply particles
				self.particle_prison_fx = ParticleManager:CreateParticle(self.particle_prison, PATTACH_WORLDORIGIN, self.parent)
				ParticleManager:SetParticleControl(self.particle_prison_fx, 0, self.parent:GetAbsOrigin())
				ParticleManager:SetParticleControl(self.particle_prison_fx, 2, self.parent:GetAbsOrigin())
				ParticleManager:SetParticleControl(self.particle_prison_fx, 3, self.parent:GetAbsOrigin())
				self:AddParticle(self.particle_prison_fx, false, false, -1, false, false)
			end
		end)
	end
end

function modifier_imba_astral_imprisonment:IsHidden() return false end
function modifier_imba_astral_imprisonment:IsPurgable() return false end
function modifier_imba_astral_imprisonment:IsDebuff() return true end

function modifier_imba_astral_imprisonment:CheckState()
	local state 
	
	-- Prevent the caster from being stunned, so he will able to move his prison
	if self.parent == self.caster then
		state = {[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_MUTED] = true,
			[MODIFIER_STATE_DISARMED] = true
		}
	else
		state = {[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_STUNNED] = true
		}
	end
			 
	return state
end

function modifier_imba_astral_imprisonment:OnDestroy()
	if IsServer() then
		-- Play end sound
		self.parent:StopSound(self.sound_astral)
		EmitSoundOn(self.sound_end, self.parent)

		-- Bring the model back
		self.parent:RemoveNoDraw()

		Timers:CreateTimer(FrameTime(), function()
			-- Find all units in radius
			local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
				self.parent:GetAbsOrigin(),
				nil,
				self.radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)

			for _,enemy in pairs(enemies) do
				-- Remove the Talent modifier from nearby enemies, if any.
				if not enemy:IsMagicImmune() and not enemy.astral_imprisonment_immunity then
					-- Add prison end particle on each enemy
					self.particle_prison_end_fx = ParticleManager:CreateParticle(self.particle_prison_end, PATTACH_ABSORIGIN, self.caster)
					ParticleManager:SetParticleControl(self.particle_prison_end_fx, 0, enemy:GetAbsOrigin())
					
					-- Deal damage
					local damageTable = {victim = enemy,
						damage = self.damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						attacker = self.caster,
						ability = self.ability
					}
										
					ApplyDamage(damageTable)

					-- Protect this enemy from astral further Astral Imprisonments in the vicinity
					enemy.astral_imprisonment_immunity = true

					-- Immunity goes down after a small delay
					Timers:CreateTimer(0.2, function()
						enemy.astral_imprisonment_immunity = false
					end)
				end
			end
		end)

		-- Resolve positions for everyone so they won't get stuck
		self.parent:AddNewModifier(self.parent, nil, "modifier_phased", {duration=FrameTime()})
	end
end


-- Self prison buff 
modifier_imba_astral_imprisonment_buff = class({})

function modifier_imba_astral_imprisonment_buff:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.particle_prison = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf"

		-- Ability specials
		self.prison_movespeed = self.ability:GetSpecialValueFor("prison_movespeed")        

		-- Allow the game to index the target location, then start thinking
		Timers:CreateTimer(0.1, function()
			self.current_location = self.target:GetAbsOrigin()

			-- Apply particles
			self.particle_prison_fx = ParticleManager:CreateParticle(self.particle_prison, PATTACH_WORLDORIGIN, self.target)
			ParticleManager:SetParticleControl(self.particle_prison_fx, 0, self.target:GetAbsOrigin())
			ParticleManager:SetParticleControl(self.particle_prison_fx, 2, self.target:GetAbsOrigin())
			ParticleManager:SetParticleControl(self.particle_prison_fx, 3, self.target:GetAbsOrigin())
			self:AddParticle(self.particle_prison_fx, false, false, -1, false, false)

			self:StartIntervalThink(FrameTime())
		end)
	end
end

function modifier_imba_astral_imprisonment_buff:OnIntervalThink()

	-- #4 Talent: Astral Imprisonment now sucks in nearby units
	if self.caster:HasTalent("special_bonus_imba_obsidian_destroyer_4") then
			
		-- Find all units in radius
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
			self.target:GetAbsOrigin(),
			nil,
			self.caster:FindTalentValue("special_bonus_imba_obsidian_destroyer_4") + self.caster:GetIntellect(),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		for _,enemy in pairs(enemies) do
			-- Only applies to enemies near the target
			if enemy == self.target then
			else
				if (not enemy:HasModifier("modifier_imba_astral_imprisonment_sucked")) then
					-- Add prison end particle on each enemy
					local particle_prison_end_fx = ParticleManager:CreateParticle(self.particle_prison_end, PATTACH_ABSORIGIN, self.caster)
					ParticleManager:SetParticleControl(particle_prison_end_fx, 0, enemy:GetAbsOrigin())
					
					-- Remove the model and apply the sucked modifier
					enemy:AddNoDraw()
					enemy:AddNewModifier(self.caster,self.ability,"modifier_imba_astral_imprisonment_sucked",{duration = self:GetRemainingTime()}) -- Reduce the duration by a minimal delay to apply the damage
				end
			end
		end                
				
	end
	
	-- If the target or the target point aren't indexed, do nothing
	if not self.target or not self.target_point then
		return nil
	end

	-- If the current location is the target point, do nothing
	if self.current_location == self.target_point then
		return nil
	end

	-- Calculate distance and direction between points    
	local distance = (self.target_point - self.current_location):Length2D()
	local direction = (self.target_point - self.current_location):Normalized()

	-- Decide a new point to move to, unless the speed is too high
	local new_point
	if distance < (self.prison_movespeed * FrameTime()) then
		new_point = self.current_location + direction * distance
	else
		new_point = self.current_location + direction * self.prison_movespeed * FrameTime()
	end    

	-- Update the new location of the target
	self.current_location = new_point
	self.target:SetAbsOrigin(self.current_location)

	-- Update the particle controls to reflect the change
	ParticleManager:SetParticleControl(self.particle_prison_fx, 0, self.target:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_prison_fx, 2, self.target:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_prison_fx, 3, self.target:GetAbsOrigin())

	-- #4 Talent: Moving the disabled units along with the prison
	if self.caster:HasTalent("special_bonus_imba_obsidian_destroyer_4") then
			
		-- Find all units in radius
		local enemies_sucked = FindUnitsInRadius(self.caster:GetTeamNumber(),
			self.target:GetAbsOrigin(),
			nil,
			FIND_UNITS_EVERYWHERE,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
			FIND_ANY_ORDER,
			false
		)

		-- Set the new path
		for _,enemy in pairs(enemies_sucked) do
			if enemy:HasModifier("modifier_imba_astral_imprisonment_sucked") then
			enemy:SetAbsOrigin(self.current_location)
			end
		end
	end
end

function modifier_imba_astral_imprisonment_buff:OnDestroy()
	if IsServer() then
		-- Spend the cooldown of the ability
		self.ability:UseResources(false, false, true)
	end
end

function modifier_imba_astral_imprisonment_buff:IsHidden() return true end
function modifier_imba_astral_imprisonment_buff:IsPurgable() return false end
function modifier_imba_astral_imprisonment_buff:IsDebuff() return true end

modifier_imba_astral_imprisonment_sucked = class({})

function modifier_imba_astral_imprisonment_sucked:IsHidden() return true end
function modifier_imba_astral_imprisonment_sucked:IsPurgable() return false end
function modifier_imba_astral_imprisonment_sucked:IsDebuff() return true end

function modifier_imba_astral_imprisonment_sucked:CheckState()
	local state = {[MODIFIER_STATE_INVULNERABLE] = true,
				   [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
				   [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
				   [MODIFIER_STATE_NO_HEALTH_BAR] = true,
				   [MODIFIER_STATE_STUNNED] = true}
	return state
end

function modifier_imba_astral_imprisonment_sucked:OnDestroy()
	if IsServer() then
		-- Add prison end particle on each enemy
		local particle_prison_end_fx = ParticleManager:CreateParticle(self.particle_prison_end, PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(particle_prison_end_fx, 0, self:GetParent():GetAbsOrigin())
		
		-- Bring the model back
		self:GetParent():RemoveNoDraw()

		-- Resolve positions for everyone so they won't get stuck
		ResolveNPCPositions(self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"))
		self:GetParent():SetUnitOnClearGround()
	end
end

---------------------------
--     ESSENCE AURA      --
---------------------------
imba_obsidian_destroyer_essence_aura = class({})
LinkLuaModifier("modifier_imba_essence_aura", "components/abilities/heroes/hero_obsidian_destroyer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_essence_aura_buff", "components/abilities/heroes/hero_obsidian_destroyer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_essence_aura_proc", "components/abilities/heroes/hero_obsidian_destroyer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_essence_aura_over_maximum", "components/abilities/heroes/hero_obsidian_destroyer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_essence_aura_over_maximum_indicator", "components/abilities/heroes/hero_obsidian_destroyer.lua", LUA_MODIFIER_MOTION_NONE)

function imba_obsidian_destroyer_essence_aura:GetAbilityTextureName()
   return "obsidian_destroyer_essence_aura"
end

function imba_obsidian_destroyer_essence_aura:GetIntrinsicModifierName()
	return "modifier_imba_essence_aura"
end

-- Aura modifier
modifier_imba_essence_aura = class({})

function modifier_imba_essence_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")

	if IsServer() then
		-- If it is an illusion, find the real one and get his current int. Do not think.
		if self.caster:IsIllusion() then
			local casters = FindUnitsInRadius(self.caster:GetTeamNumber(),
											  self.caster:GetAbsOrigin(),
											  nil,
											  FIND_UNITS_EVERYWHERE, --global
											  DOTA_UNIT_TARGET_TEAM_FRIENDLY,
											  DOTA_UNIT_TARGET_HERO,
											  DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
											  FIND_CLOSEST,
											  false)
			for _,caster in pairs(casters) do
				if caster:GetUnitName() == self.caster:GetUnitName() then
					local int = caster:GetIntellect()                    
					self:SetStackCount(int)
					break
				end
			end

			return nil
		end

		-- Start thinking
		self:StartIntervalThink(0.5)
	end
end

function modifier_imba_essence_aura:OnIntervalThink()
	if IsServer() then
		-- Get the caster's int count and set the stacks accordingly
		local int = self.caster:GetIntellect()
		self:SetStackCount(int)
	end
end

function modifier_imba_essence_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_essence_aura:GetAuraRadius()
	return self.radius
end

function modifier_imba_essence_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end

function modifier_imba_essence_aura:GetAuraSearchTeam()
	-- #3 Talent: Essence Synergy now procs from enemies
	if self:GetCaster():HasTalent("special_bonus_imba_obsidian_destroyer_3") then
	return DOTA_UNIT_TARGET_TEAM_BOTH
	else
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
end

function modifier_imba_essence_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_essence_aura:GetModifierAura()
	return "modifier_imba_essence_aura_buff"
end

function modifier_imba_essence_aura:IsAura()
	if IsServer() then
		-- Aura is not emitted if the caster is broken
		if self.caster:PassivesDisabled() then
			return false
		end

		-- Illusions do not emit the Essence Aura
		if self.caster:IsIllusion() then
			return false
		end

		return true
	end
end

function modifier_imba_essence_aura:AllowIllusionDuplicate()
	return true
end

function modifier_imba_essence_aura:IsDebuff() return false end
function modifier_imba_essence_aura:IsHidden() return true end
function modifier_imba_essence_aura:IsPurgable() return false end    


modifier_imba_essence_aura_buff = class({})

function modifier_imba_essence_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound_proc = "Hero_ObsidianDestroyer.EssenceAura"
	self.particle_essence = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf"
	self.modifier_proc = "modifier_imba_essence_aura_proc"
	self.modifier_overmana = "modifier_imba_essence_aura_over_maximum"
	self.modifier_overmana_indicator = "modifier_imba_essence_aura_over_maximum_indicator"

	-- Ability specials
	self.restore_chance_pct = self.ability:GetSpecialValueFor("restore_chance_pct")
	self.restore_mana_pct = self.ability:GetSpecialValueFor("restore_mana_pct")    
	self.bonus_int_on_proc = self.ability:GetSpecialValueFor("bonus_int_on_proc") 
	self.int_proc_duration = self.ability:GetSpecialValueFor("int_proc_duration")
end

function modifier_imba_essence_aura_buff:DeclareFunctions()
	local decFunc = {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST}

	return decFunc
end

function modifier_imba_essence_aura_buff:OnAbilityFullyCast(keys)
	if IsServer() then
		local ability = keys.ability
		local unit = keys.unit        

		-- Only apply if the unit is the one holding the buff
		if unit == self.parent then

			-- If the ability costs no mana, do nothing
			if ability:GetManaCost(-1) == 0 then
				return nil
			end

			-- If the ability has no cooldown, do nothing
			if ability:GetCooldown(-1) == 0 then
				return nil
			end

			-- If the ability is from an item, do nothing
			if ability:IsItem() then
				return nil
			end            

			-- Otherwise, roll Essence Aura proc
			self:ProcEssenceAura()
		end
	end
end

function modifier_imba_essence_aura_buff:ProcEssenceAura()
	if IsServer() then
		-- Roll for a random proc. Pseudo distribution
		if RollPseudoRandom(self.restore_chance_pct, self) then     
			-- Only applied to the heroes on the same team
			if self.parent:GetTeamNumber() == self.caster:GetTeamNumber() then
				-- Restore % of maximum mana to the parent
				local max_mana = self.parent:GetMaxMana()
				local mana_restore = max_mana * (self.restore_mana_pct * 0.01)
				
				-- #5 Talent: Essence Aura now heals when proccing
				if self.caster:HasTalent("special_bonus_imba_obsidian_destroyer_5") then
					local heal_amount = self.caster:GetIntellect()
					self.parent:Heal(heal_amount, self.caster)
				end
				-- #8 Talent: Essence Aura can go beyond maximum mana temporarily (caster only)
				if self.caster:HasTalent("special_bonus_imba_obsidian_destroyer_8") and self.caster == self.parent then
					-- Get current mana
					local current_mana = self.caster:GetMana()

					-- Calculate how much the excess mana this proc has
					local excess_mana = (current_mana + mana_restore) - max_mana
					if excess_mana > 0 then
						if not self.caster:HasModifier(self.modifier_overmana) then
							local overmana_duration = self.caster:FindTalentValue("special_bonus_imba_obsidian_destroyer_8")
							self.caster:AddNewModifier(self.caster, self.ability, self.modifier_overmana, {duration = overmana_duration})
							self.caster:AddNewModifier(self.caster, self.ability, self.modifier_overmana_indicator, {duration = overmana_duration})
						end

						local modifier_overmana_handler = self.caster:FindModifierByName(self.modifier_overmana)
						local modifier_overmana_indicator = self.caster:FindModifierByName(self.modifier_overmana_indicator)
						if modifier_overmana_handler then
							for i = 1, excess_mana do
								modifier_overmana_handler:IncrementStackCount()
								modifier_overmana_handler:ForceRefresh()
							end                        
						end
						if modifier_overmana_indicator then
							modifier_overmana_indicator:IncrementStackCount()
							modifier_overmana_indicator:ForceRefresh()                     
						end
					end
				end

				self.parent:GiveMana(mana_restore)

				-- Apply particle effect on parent
				self.particle_essence_fx = ParticleManager:CreateParticle(self.particle_essence, PATTACH_ABSORIGIN_FOLLOW, self.parent)
				ParticleManager:SetParticleControl(self.particle_essence_fx, 0, self.parent:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(self.particle_essence_fx)
			else
			
			-- If the hero is not on the same team, only apply the particle effect on parent
			self.particle_essence_fx = ParticleManager:CreateParticle(self.particle_essence, PATTACH_ABSORIGIN_FOLLOW, self.parent)
			ParticleManager:SetParticleControl(self.particle_essence_fx, 0, self.parent:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.particle_essence_fx)
			
			end
			
			-- If the one proccing the aura wasn't the caster, give the caster a proc stack
			if self.caster ~= self.parent then

				-- Add the buff if the caster doesn't have it yet
				if not self.caster:HasModifier(self.modifier_proc) then
					self.caster:AddNewModifier(self.caster, self.ability, self.modifier_proc, {duration = self.int_proc_duration})
				end

				-- Get the handle and give the caster a stack
				local modifier_proc_handler = self.caster:FindModifierByName(self.modifier_proc)
				if modifier_proc_handler then
					for i = 1, self.bonus_int_on_proc do
						modifier_proc_handler:IncrementStackCount()
						modifier_proc_handler:ForceRefresh()
					end
				end
			end
		end
	end
end

function modifier_imba_essence_aura_buff:OnRefresh()
	self:OnCreated()
end

-- Caster's aura proc modifier
modifier_imba_essence_aura_proc = class({})

function modifier_imba_essence_aura_proc:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()        

		-- Ability specials
		self.int_proc_duration = self.ability:GetSpecialValueFor("int_proc_duration")

		-- Initialize table
		self.stacks_table = {}        

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_essence_aura_proc:OnIntervalThink()
	if IsServer() then

		-- Check if there are any stacks left on the table
		if #self.stacks_table > 0 then

			-- For each stack, check if it is past its expiration time. If it is, remove it from the table
			for i = #self.stacks_table, 1, -1 do
				if self.stacks_table[i] + self.int_proc_duration < GameRules:GetGameTime() then
					table.remove(self.stacks_table, i)                          
				end
			end
			
			-- If after removing the stacks, the table is empty, remove the modifier.
			if #self.stacks_table == 0 then
				self:Destroy()

			-- Otherwise, set its stack count
			else
				self:SetStackCount(#self.stacks_table)
			end

			-- Recalculate bonus based on new stack count
			self:GetParent():CalculateStatBonus()

		-- If there are no stacks on the table, just remove the modifier.
		else
			self:Destroy()
		end
	end
end

function modifier_imba_essence_aura_proc:OnRefresh()
	if IsServer() then
		-- Insert new stack values
		table.insert(self.stacks_table, GameRules:GetGameTime())
	end
end

function modifier_imba_essence_aura_proc:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}

	return decFunc
end 

function modifier_imba_essence_aura_proc:GetModifierBonusStats_Intellect()
	local stacks = self:GetStackCount()
	return stacks
end

function modifier_imba_essence_aura_proc:IsHidden() return false end    
function modifier_imba_essence_aura_proc:IsPurgable() return false end
function modifier_imba_essence_aura_proc:IsDebuff() return false end


-- #8 Talent: Essence Aura can go beyond maximum mana temporarily
modifier_imba_essence_aura_over_maximum = class({})

function modifier_imba_essence_aura_over_maximum:IsHidden() return true end    
function modifier_imba_essence_aura_over_maximum:IsPurgable() return false end
function modifier_imba_essence_aura_over_maximum:IsDebuff() return false end

function modifier_imba_essence_aura_over_maximum:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()        

		-- Overmana duration
		self.overmana_duration = self.caster:FindTalentValue("special_bonus_imba_obsidian_destroyer_8")

		-- Initialize table
		self.stacks_table = {}        

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_essence_aura_over_maximum:OnIntervalThink()
	if IsServer() then

		-- Check if there are any stacks left on the table
		if #self.stacks_table > 0 then

			-- For each stack, check if it is past its expiration time. If it is, remove it from the table
			for i = #self.stacks_table, 1, -1 do
				if self.stacks_table[i] + self.overmana_duration < GameRules:GetGameTime() then
					table.remove(self.stacks_table, i)                          
				end
			end
			
			-- If after removing the stacks, the table is empty, remove the modifier.
			if #self.stacks_table == 0 then
				self:Destroy()

			-- Otherwise, set its stack count
			else
				self:SetStackCount(#self.stacks_table)
			end

			-- Recalculate bonus based on new stack count
			self:GetParent():CalculateStatBonus()

		-- If there are no stacks on the table, just remove the modifier.
		else
			self:Destroy()
		end
	end
end

function modifier_imba_essence_aura_over_maximum:OnRefresh()
	if IsServer() then
		-- Insert new stack values
		table.insert(self.stacks_table, GameRules:GetGameTime())
	end
end

function modifier_imba_essence_aura_over_maximum:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_EXTRA_MANA_BONUS}

	return decFunc
end

function modifier_imba_essence_aura_over_maximum:GetModifierExtraManaBonus()
	local stacks = self:GetStackCount()
	return stacks
end


-- #8 Talent: Indicator
modifier_imba_essence_aura_over_maximum_indicator = class({})

function modifier_imba_essence_aura_over_maximum_indicator:IsHidden() return false end    
function modifier_imba_essence_aura_over_maximum_indicator:IsPurgable() return false end
function modifier_imba_essence_aura_over_maximum_indicator:IsDebuff() return false end

function modifier_imba_essence_aura_over_maximum_indicator:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()        

		-- Overmana duration
		self.overmana_duration = self.caster:FindTalentValue("special_bonus_imba_obsidian_destroyer_8")

		-- Initialize table
		self.stacks_table = {}        

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_essence_aura_over_maximum_indicator:OnIntervalThink()
	if IsServer() then

		-- Check if there are any stacks left on the table
		if #self.stacks_table > 0 then

			-- For each stack, check if it is past its expiration time. If it is, remove it from the table
			for i = #self.stacks_table, 1, -1 do
				if self.stacks_table[i] + self.overmana_duration < GameRules:GetGameTime() then
					table.remove(self.stacks_table, i)                          
				end
			end
			
			-- If after removing the stacks, the table is empty, remove the modifier.
			if #self.stacks_table == 0 then
				self:Destroy()

			-- Otherwise, set its stack count
			else
				self:SetStackCount(#self.stacks_table)
			end

			-- Recalculate bonus based on new stack count
			self:GetParent():CalculateStatBonus()

		-- If there are no stacks on the table, just remove the modifier.
		else
			self:Destroy()
		end
	end
end

function modifier_imba_essence_aura_over_maximum_indicator:OnRefresh()
	if IsServer() then
		-- Insert new stack values
		table.insert(self.stacks_table, GameRules:GetGameTime())
	end
end

---------------------------
--    SANITY ECLIPSE     --
---------------------------
imba_obsidian_destroyer_sanity_eclipse = class({})

function imba_obsidian_destroyer_sanity_eclipse:GetAbilityTextureName()
   return "obsidian_destroyer_sanity_eclipse"
end

function imba_obsidian_destroyer_sanity_eclipse:IsHiddenWhenStolen()
	return false
end

function imba_obsidian_destroyer_sanity_eclipse:GetAOERadius()
	local ability = self
	local radius = ability:GetSpecialValueFor("radius")
	return radius
end

function imba_obsidian_destroyer_sanity_eclipse:GetAssociatedSecondaryAbilities()
	return "imba_obsidian_destroyer_astral_imprisonment"
end

function imba_obsidian_destroyer_sanity_eclipse:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local sound_cast = "Hero_ObsidianDestroyer.SanityEclipse.Cast"
	local sound_target = "Hero_ObsidianDestroyer.SanityEclipse"
	local particle_area = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_area.vpcf"
	local particle_damage = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_damage.vpcf"
	local particle_burn = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_mana_loss.vpcf"    
	local modifier_prison = "modifier_imba_astral_imprisonment"    
	local scepter = caster:HasScepter()    

	-- Ability specials
	local radius = ability:GetSpecialValueFor("radius")
	local int_multiplier = ability:GetSpecialValueFor("int_multiplier")
	local max_mana_burn_pct = ability:GetSpecialValueFor("max_mana_burn_pct")
	local int_steal_count = ability:GetSpecialValueFor("int_steal_count")    
	local int_steal_duration = ability:GetSpecialValueFor("int_steal_duration")

	-- Get Prison ability and duration
	local prison_ability = caster:FindAbilityByName("imba_obsidian_destroyer_astral_imprisonment")        
	local prison_duration    

	if prison_ability then
		prison_duration = prison_ability:GetSpecialValueFor("prison_duration")
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Play target sound
	EmitSoundOnLocationWithCaster(target_point, sound_target, caster)

	-- Get current intelligence
	local caster_int = caster:GetIntellect()

	-- Add area particle
	local particle_area_fx = ParticleManager:CreateParticle(particle_area, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle_area_fx, 0, target_point)
	ParticleManager:SetParticleControl(particle_area_fx, 1, Vector(radius, 1, 1))
	ParticleManager:SetParticleControl(particle_area_fx, 2, Vector(radius, 1, 1))
	ParticleManager:SetParticleControl(particle_area_fx, 3, target_point)
	ParticleManager:ReleaseParticleIndex(particle_area_fx)

	-- Find all enemies in radius
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									  target_point,
									  nil,
									  radius,
									  DOTA_UNIT_TARGET_TEAM_ENEMY,
									  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									  DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
									  FIND_ANY_ORDER,
									  false)

	for _,enemy in pairs(enemies) do
		-- #7 Talent: Sanity Eclipse pierces spell immunity
		if caster:HasTalent("special_bonus_imba_obsidian_destroyer_7") or not enemy:IsMagicImmune() then            
			
			-- Add mana burn particle
			local particle_burn_fx = ParticleManager:CreateParticle(particle_burn, PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(particle_burn_fx, 0, enemy:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_burn_fx)

			-- Burn a portion of max mana, if they have any
			if enemy:GetMana() > 0 then
				local max_mana = enemy:GetMaxMana()
				local mana_burn = max_mana * (max_mana_burn_pct * 0.01)
				-- #6 Talent: Heroes with INT less than 50% of Obsidian Destroyer's INT receives doubled the mana burn and 50% more damage from Sanity Eclipse
				if caster:HasTalent("special_bonus_imba_obsidian_destroyer_6") then
					if enemy:IsHero() and enemy:GetIntellect() < caster_int*caster:FindTalentValue("special_bonus_imba_obsidian_destroyer_6")*0.01 then
						mana_burn = max_mana * (caster:FindTalentValue("special_bonus_imba_obsidian_destroyer_6","mana_burn") * 0.01) 
					end
				end
				enemy:ReduceMana(mana_burn)
			end

			-- If the enemy is an illusion, KILL IT!!!!!!!!!!!!!!!!!!
			if enemy:IsIllusion() then
				enemy:Kill(ability, caster)
			else
				-- Calculate difference in intelligence for heroes, otherwise there are regarded as 0 int
				local enemy_int
				if enemy:IsHero() then
					enemy_int = enemy:GetIntellect()
				else
					enemy_int = 0
				end

				local int_difference = caster_int - enemy_int

				-- If difference is above 0, calculate damage
				local damage = 0
				if int_difference > 0 then
					damage = int_difference * int_multiplier
				end
				
				-- #6 Talent: Heroes with INT less than 50% of Obsidian Destroyer's INT receives doubled the mana burn and 50% more damage from Sanity Eclipse
				if caster:HasTalent("special_bonus_imba_obsidian_destroyer_6") then
					if enemy_int < caster_int*caster:FindTalentValue("special_bonus_imba_obsidian_destroyer_6")*0.01 then
						damage = damage * (1+caster:FindTalentValue("special_bonus_imba_obsidian_destroyer_6","bonus_incoming_damage")*0.01)
					end
				end
				
				-- Deal damage. If the target has Astral Prison, remove its invulnerablity and return it after applying damage                
				if damage > 0 then
					local damage_type = DAMAGE_TYPE_MAGICAL
					if caster:HasTalent("special_bonus_imba_obsidian_destroyer_7") then
						damage_type = DAMAGE_TYPE_PURE
					end

					local damageTable
					if enemy:HasModifier(modifier_prison) then
						damageTable = {victim = enemy,
									   damage = damage,
									   damage_type = damage_type,
									   attacker = caster,
									   ability = ability,                                
									   damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY
									   }
					else
						damageTable = {victim = enemy,
									   damage = damage,
									   damage_type = damage_type,
									   attacker = caster,
									   ability = ability,                                
									   }
					end                    

					ApplyDamage(damageTable)

					-- Add damage particle
					local particle_damage_fx = ParticleManager:CreateParticle(particle_damage, PATTACH_ABSORIGIN_FOLLOW, caster)
					ParticleManager:SetParticleControl(particle_damage_fx, 0, enemy:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(particle_damage_fx)
				end    

				-- Steal intelligence if the enemy is a hero
				if enemy:IsHero() and int_steal_count > 0 then           
					ApplyIntelligenceSteal(caster, ability, enemy, int_steal_count, int_steal_duration)
				end            

				-- If caster has scepter, trap enemies in Astral Prisons if they aren't in it already
				if scepter and prison_ability and not enemy:HasModifier(modifier_prison) then
					enemy:AddNewModifier(caster, prison_ability, modifier_prison, {duration = prison_duration})
				end            
			end
		end        
	end
	
	-- #2 Talent: Sanity Eclipse's cooldown is reduced by 1 second for each instance of INT steal Obsidian Destroyer applies
	if caster:HasTalent("special_bonus_imba_obsidian_destroyer_2") then
		local talent_modifier = caster:FindModifierByName("modifier_imba_arcane_orb_instance")
		if talent_modifier then
			local cooldown_remaining = ability:GetCooldownTimeRemaining()
			local new_cooldown = cooldown_remaining - talent_modifier:GetStackCount()

			-- if cdr is very high cap to 50%
			if talent_modifier:GetStackCount() > cooldown_remaining / 2 then
				ability:EndCooldown()
				ability:StartCooldown(cooldown_remaining / 2)
			else
				ability:EndCooldown()
				ability:StartCooldown(new_cooldown)
			end
		end
	end
end
