--[[	Author: zimberzimber
		Date:	5.2.2017	]]

LinkLuaModifier( "modifier_imba_power_treads_2", "items/item_power_treads.lua", LUA_MODIFIER_MOTION_NONE )					-- Mega Treads passive item effect
LinkLuaModifier( "modifier_imba_mega_treads_stat_multiplier_00", "items/item_power_treads.lua", LUA_MODIFIER_MOTION_NONE )	-- Mega Treads strength stat multiplier
LinkLuaModifier( "modifier_imba_mega_treads_stat_multiplier_01", "items/item_power_treads.lua", LUA_MODIFIER_MOTION_NONE )	-- Mega Treads agility stat multiplier
LinkLuaModifier( "modifier_imba_mega_treads_stat_multiplier_02", "items/item_power_treads.lua", LUA_MODIFIER_MOTION_NONE )	-- Mega Treads intelligence stat multiplier

-----------------------------------------------------------------------------------------------------------
--	Item Definition 
-----------------------------------------------------------------------------------------------------------

if item_imba_power_treads_2 == nil then item_imba_power_treads_2 = class({}) end
function item_imba_power_treads_2:GetBehavior() return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET end

function item_imba_power_treads_2:GetIntrinsicModifierName()
	return "modifier_imba_power_treads_2"
end

function item_imba_power_treads_2:OnSpellStart()
	if IsServer() then
		
		local caster = self:GetCaster()
		if not caster:IsHero() then return end
		
		-- Switch tread attribute
		local modifiers = caster:FindAllModifiersByName("modifier_imba_power_treads_2")
		for _,modifier in pairs(modifiers) do
			if modifier:GetAbility() == self then
				local state = modifier:GetStackCount()
				modifier:SetStackCount((state - 1 + DOTA_ATTRIBUTE_MAX) % DOTA_ATTRIBUTE_MAX)
				self.state = state		
				break
			end
		end	
		
		-- Remove stat multiplier modifiers (they get reapplied in the item modifier if relevant)
		for i = 0,2 do 
			local mod = caster:FindModifierByName("modifier_imba_mega_treads_stat_multiplier_0"..i)
			if mod then caster:RemoveModifierByName("modifier_imba_mega_treads_stat_multiplier_0"..i) end
		end
		caster:CalculateStatBonus()
	end		
end

function item_imba_power_treads_2:GetAbilityTextureName()
	if IsClient() then
		local caster = self:GetCaster()
		if not caster:IsHero() or not self.state then return "custom/imba_power_treads" end
		
		return "custom/imba_mega_treads_"..self.state
	end
end

-----------------------------------------------------------------------------------------------------------
--	Item Modifier - Movement speed and stat bonus (stacks responsible for texture and stat bonus choice)
-----------------------------------------------------------------------------------------------------------
if modifier_imba_power_treads_2 == nil then modifier_imba_power_treads_2 = class({}) end
function modifier_imba_power_treads_2:IsHidden() return true end
function modifier_imba_power_treads_2:IsDebuff() return false end
function modifier_imba_power_treads_2:IsPurgable() return false end
function modifier_imba_power_treads_2:RemoveOnDeath() return false end
function modifier_imba_power_treads_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_power_treads_2:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
				}	
	return funcs
end

function modifier_imba_power_treads_2:OnCreated()
	if IsServer() then		
		if self:GetParent():IsHero() then
			local ability = self:GetAbility()
			local parent = self:GetParent()
			
			if parent:IsRealHero() then				
				self:StartIntervalThink(0.2)
			else
				Timers:CreateTimer(FrameTime(), function()	-- Timer because Valve decided that modifiers should be applied before items are added
					local ownerFinder = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH , DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD , FIND_ANY_ORDER , false) 
					for _,hero in pairs(ownerFinder) do
						if hero:GetName() == parent:GetName() then
							for i = 0,5 do
								local hero_item = hero:GetItemInSlot(i)
								if hero_item and hero_item:GetName() == "item_imba_power_treads_2" then
									local illusion_item = parent:GetItemInSlot(i)
									if illusion_item == self:GetAbility() then
										local state = (hero_item.state - 1 + DOTA_ATTRIBUTE_MAX) % DOTA_ATTRIBUTE_MAX
										illusion_item.state = state
										self:SetStackCount(state)
										ability.state = state
										local healthPcnt = hero:GetHealthPercent()/100
										local manaPcnt = hero:GetManaPercent()/100
										
										local maxHealth = parent:GetMaxHealth()
										local maxMana = parent:GetMaxMana() 
										
										parent:SetHealth(maxHealth*healthPcnt)
										parent:SetMana(maxMana*manaPcnt)
										break
									end
								end
							end
							break
						end
					end	
					self:StartIntervalThink(0.2)									
				end)
			end			
		end
	end	
	if IsClient() then
		self:StartIntervalThink( 0.2 )
	end
end

function modifier_imba_power_treads_2:OnIntervalThink()
	if IsClient() then
		local state = self:GetStackCount()
		local ability = self:GetAbility()
		ability.state = state
		
	elseif IsServer() then
		local state = self:GetStackCount()
		local ability = self:GetAbility()
		local parent = self:GetParent()
		if not parent:IsRealHero() then return end		

		if not parent:HasModifier("modifier_imba_mega_treads_stat_multiplier_0"..state) then
		 	parent:AddNewModifier(parent, ability, "modifier_imba_mega_treads_stat_multiplier_0"..state, {})
		end
	end
end

function modifier_imba_power_treads_2:OnDestroyed()
	if IsServer() then
		for i = 0,2 do
			local parent = self:GetParent()
			parent:RemoveModifierByName("modifier_imba_mega_treads_stat_multiplier_0"..i)
		end
	end
end



function modifier_imba_power_treads_2:GetModifierMoveSpeedBonus_Special_Boots()
	local ability = self:GetAbility()
	local speed_bonus = ability:GetSpecialValueFor("bonus_movement_speed")
	return speed_bonus
end

function modifier_imba_power_treads_2:GetModifierBonusStats_Strength()
	if self:GetStackCount() ~= DOTA_ATTRIBUTE_STRENGTH then return end
	
	local parent = self:GetParent()
	if not parent:IsHero() then return end
	
	local ability = self:GetAbility()
	local stat_bonus = ability:GetSpecialValueFor("bonus_stat")
	return stat_bonus
end

function modifier_imba_power_treads_2:GetModifierBonusStats_Agility()
	if self:GetStackCount() ~= DOTA_ATTRIBUTE_AGILITY then return end
	
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if not parent:IsHero() then return end
	
	local stat_bonus = ability:GetSpecialValueFor("bonus_stat")
	return stat_bonus
end

function modifier_imba_power_treads_2:GetModifierBonusStats_Intellect()
	if self:GetStackCount() ~= DOTA_ATTRIBUTE_INTELLECT then return end
	
	local parent = self:GetParent()
	if not parent:IsHero() then return end
	
	local ability = self:GetAbility()
	local stat_bonus = ability:GetSpecialValueFor("bonus_stat")
	return stat_bonus
end

-----------------------------------------------------------------------------------------------------------
--	Strength multiplier modifier
-----------------------------------------------------------------------------------------------------------
if modifier_imba_mega_treads_stat_multiplier_00 == nil then modifier_imba_mega_treads_stat_multiplier_00 = class({}) end
function modifier_imba_mega_treads_stat_multiplier_00:IsHidden() return true end
function modifier_imba_mega_treads_stat_multiplier_00:IsDebuff() return false end
function modifier_imba_mega_treads_stat_multiplier_00:IsPurgable() return false end

function modifier_imba_mega_treads_stat_multiplier_00:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_mega_treads_stat_multiplier_00:OnIntervalThink()
	if IsServer() then
		local strength = self:GetParent():GetStrength()
		self:SetStackCount(strength)
	end
end

function modifier_imba_mega_treads_stat_multiplier_00:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_HEALTH_BONUS,			
					MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
					MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
					}
	return funcs
end

function modifier_imba_mega_treads_stat_multiplier_00:GetModifierHealthBonus()	
	
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if not parent:IsHero() then return end
	
	local strength = self:GetStackCount()
	local health_bonus = ability:GetSpecialValueFor("str_bonus_max_health")	
	return strength * health_bonus
end

function modifier_imba_mega_treads_stat_multiplier_00:GetModifierConstantHealthRegen()	
	
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if not parent:IsHero() then return end
	
	local strength = self:GetStackCount()
	local regen_bonus = ability:GetSpecialValueFor("str_bonus_hp_regen")	
	return strength * regen_bonus
end

function modifier_imba_mega_treads_stat_multiplier_00:GetModifierBaseAttack_BonusDamage()
	local parent = self:GetParent()
	if not parent:IsHero() then return end
	
	local ability = self:GetAbility()
	local main_stats = parent:GetPrimaryStatValue()
	local damage_bonus = ability:GetSpecialValueFor("main_stat_bonus_damage")	
	return main_stats * damage_bonus
end

-----------------------------------------------------------------------------------------------------------
--	Agility multiplier modifier
-----------------------------------------------------------------------------------------------------------
if modifier_imba_mega_treads_stat_multiplier_01 == nil then modifier_imba_mega_treads_stat_multiplier_01 = class({}) end
function modifier_imba_mega_treads_stat_multiplier_01:IsHidden() return true end
function modifier_imba_mega_treads_stat_multiplier_01:IsDebuff() return false end
function modifier_imba_mega_treads_stat_multiplier_01:IsPurgable() return false end

function modifier_imba_mega_treads_stat_multiplier_01:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
					MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
					}
	return funcs
end

function modifier_imba_mega_treads_stat_multiplier_01:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_mega_treads_stat_multiplier_01:OnIntervalThink()
	if IsServer() then
		local agility = self:GetParent():GetAgility()
		self:SetStackCount(agility)
	end
end

function modifier_imba_mega_treads_stat_multiplier_01:GetModifierAttackSpeedBonus_Constant()		
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if not parent:IsHero() then return end
	
	local agility = self:GetStackCount()
	local attack_speed_bonus = ability:GetSpecialValueFor("agi_bonus_attack_speed")	
	return agility * attack_speed_bonus	
end

function modifier_imba_mega_treads_stat_multiplier_01:GetModifierPhysicalArmorBonus()			
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if not parent:IsHero() then return end
	
	local agility = self:GetStackCount()
	local armor_bonus = ability:GetSpecialValueFor("agi_bonus_armor")	

	return agility * armor_bonus	
end

function modifier_imba_mega_treads_stat_multiplier_01:GetModifierBaseAttack_BonusDamage()
	local parent = self:GetParent()
	if not parent:IsHero() then return end
	
	local ability = self:GetAbility()
	local main_stats = parent:GetPrimaryStatValue()
	local damage_bonus = ability:GetSpecialValueFor("main_stat_bonus_damage")	
	return main_stats * damage_bonus
end

-----------------------------------------------------------------------------------------------------------
--	Intelliegence multiplier modifier (Stacks are used to calculate bonus spell power)
-----------------------------------------------------------------------------------------------------------
if modifier_imba_mega_treads_stat_multiplier_02 == nil then modifier_imba_mega_treads_stat_multiplier_02 = class({}) end
function modifier_imba_mega_treads_stat_multiplier_02:IsHidden() return true end
function modifier_imba_mega_treads_stat_multiplier_02:IsDebuff() return false end
function modifier_imba_mega_treads_stat_multiplier_02:IsPurgable() return false end

function modifier_imba_mega_treads_stat_multiplier_02:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MANA_BONUS,	
					MODIFIER_PROPERTY_BASE_MANA_REGEN,
					MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
					}
	return funcs
end

function modifier_imba_mega_treads_stat_multiplier_02:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_mega_treads_stat_multiplier_02:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local int = parent:GetIntellect()
		self:SetStackCount(int)
	end
end

function modifier_imba_mega_treads_stat_multiplier_02:GetModifierManaBonus()	
	
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if not parent:IsHero() then return end
	
	local intellect = self:GetStackCount()
	local mana_bonus = ability:GetSpecialValueFor("int_bonus_max_mp")
	
	return intellect * mana_bonus
end

function modifier_imba_mega_treads_stat_multiplier_02:GetModifierBaseRegen()	
	
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if not parent:IsHero() then return end
	
	local intellect = self:GetStackCount()
	local regen_bonus = ability:GetSpecialValueFor("int_bonus_mp_regen")
	
	return intellect * regen_bonus
end

function modifier_imba_mega_treads_stat_multiplier_02:GetModifierBaseAttack_BonusDamage()
	local parent = self:GetParent()
	if not parent:IsHero() then return end
	
	local ability = self:GetAbility()
	local main_stats = parent:GetPrimaryStatValue()
	local damage_bonus = ability:GetSpecialValueFor("main_stat_bonus_damage")	
	return main_stats * damage_bonus
end
