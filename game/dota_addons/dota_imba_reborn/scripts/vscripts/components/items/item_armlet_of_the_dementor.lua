-- Creator:
-- 	AltiV - March 20th, 2019

LinkLuaModifier("modifier_item_imba_armlet_of_the_dementor", "components/items/item_armlet_of_the_dementor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_armlet_of_the_dementor_active", "components/items/item_armlet_of_the_dementor.lua", LUA_MODIFIER_MOTION_NONE)

-- Mind's Despair

item_imba_armlet_of_the_dementor					= class({})
modifier_item_imba_armlet_of_the_dementor			= class({})
modifier_item_imba_armlet_of_the_dementor_active	= class({})

---------------------------------
-- ARMLET OF THE DEMENTOR BASE --
---------------------------------

function item_imba_armlet_of_the_dementor:GetIntrinsicModifierName()
	-- Client/server way of checking for multiple items and only apply the effects of one without relying on extra modifiers
	
	Timers:CreateTimer(FrameTime(), function()
		if not self:IsNull() then
			for _, modifier in pairs(self:GetParent():FindAllModifiersByName("modifier_item_imba_armlet_of_the_dementor")) do
				modifier:SetStackCount(_)
			end
		end
	end)

	return "modifier_item_imba_armlet_of_the_dementor"
end

-- function item_imba_armlet_of_the_dementor:GetAbilityTextureName()
	-- if self:GetCaster():HasModifier("modifier_item_imba_armlet_of_the_dementor_active") then
		-- return "custom/imba_armlet_active" end
	-- else
		-- return "custom/imba_armlet"
	-- end
-- end

function item_imba_armlet_of_the_dementor:OnSpellStart()

	local caster	= self:GetCaster()
	
	-- AbilitySpecials
	-- put stuff here
	
				-- "01"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "bonus_damage"			"9"
			-- }
			-- "02"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "bonus_attack_speed"	"25"
			-- }
			-- "03"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "bonus_armor"			"5"
			-- }
			-- "04"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "bonus_health_regen"	"5"
			-- }
			-- "05"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "unholy_bonus_damage"	"31"
			-- }
			-- "06"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "unholy_bonus_attack_speed"	"0"
			-- }
			-- "07"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "unholy_bonus_strength"	"25"
			-- }
			-- "08"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "unholy_bonus_armor"	"4"
			-- }
			-- "09"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "unholy_health_drain_per_tick"	"6"
			-- }		
			-- "10"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "unholy_health_drain_per_second_tooltip"	"54"
			-- }	
			-- "11"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "toggle_cooldown"		"0.036f"
			-- }	

	if not IsServer() then return end

	if not caster:HasModifier("modifier_item_imba_armlet_of_the_dementor_active") then
		caster:EmitSound("DOTA_Item.Armlet.Activate")
		caster:AddNewModifier(caster, self, "modifier_item_imba_armlet_of_the_dementor_active", {})
	else
		caster:EmitSound("DOTA_Item.Armlet.DeActivate")
		caster:RemoveModifierByName("modifier_item_imba_armlet_of_the_dementor_active")
	end

end

--------------------------------------------
-- ARMLET OF THE DEMENTOR ACTIVE MODIFIER --
--------------------------------------------

-- spell amp, int, magic res and drain mana

-- have some consequence if you let your mana drop to 0
-- maybe some sort of stone gaze into freeze scenario if you don't turn it off
-- or hp regen freeze + your def gets slowly destroyed

function modifier_item_imba_armlet_of_the_dementor_active:IsPurgable() 	return false end

function modifier_item_imba_armlet_of_the_dementor_active:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()	

	-- AbilitySpecials
	self.mind_bonus_int			=	self.ability:GetSpecialValueFor("mind_bonus_int")
	self.mind_bonus_magic_res	=	self.ability:GetSpecialValueFor("mind_bonus_magic_res")
	self.mind_bonus_spell_amp	=	self.ability:GetSpecialValueFor("mind_bonus_spell_amp")
	self.mind_mana_drain_per_tick	=	self.ability:GetSpecialValueFor("mind_mana_drain_per_tick")	-- I might just make this MP regen reduction or straight up MP regen disable
end

function modifier_item_imba_armlet_of_the_dementor_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,	-- GetModifierBonusStats_Intellect
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, --GetModifierMagicalResistanceBonus
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, --GetModifierSpellAmplify_Percentage
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT	-- GetModifierConstantManaRegen
	}

	return funcs
end

function modifier_item_imba_armlet_of_the_dementor_active:GetModifierBonusStats_Intellect()
	return self.mind_bonus_int
end

function modifier_item_imba_armlet_of_the_dementor_active:GetModifierMagicalResistanceBonus()
	return self.mind_bonus_magic_res
end

function modifier_item_imba_armlet_of_the_dementor_active:GetModifierSpellAmplify_Percentage()
	return self.mind_bonus_spell_amp
end

function modifier_item_imba_armlet_of_the_dementor_active:GetModifierConstantManaRegen()
	return -54
end

-------------------------------------
-- ARMLET OF THE DEMENTOR MODIFIER --
-------------------------------------

function modifier_item_imba_armlet_of_the_dementor:IsHidden()		return true end
function modifier_item_imba_armlet_of_the_dementor:IsPermanent()	return true end
function modifier_item_imba_armlet_of_the_dementor:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Int, magic resis, spell amp?


--passive: spell amp, spell cd (not stack with frantic or self), magic res, mana regen?
function modifier_item_imba_armlet_of_the_dementor:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.bonus_spell_amp	=	self.ability:GetSpecialValueFor("bonus_spell_amp")
	self.bonus_spell_cd		=	self.ability:GetSpecialValueFor("bonus_spell_cd")
	self.bonus_magic_res	=	self.ability:GetSpecialValueFor("bonus_magic_res")
	self.bonus_mana_regen	=	self.ability:GetSpecialValueFor("bonus_mana_regen")
end

-- This is just to make sure the CD modifier doesn't stack with itself or frantic modifier, without having to make an additional modifier to check
function modifier_item_imba_armlet_of_the_dementor:OnDestroy()
	if not IsServer() then return end
	
	for _, modifier in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
		modifier:SetStackCount(_)
	end
end

function modifier_item_imba_armlet_of_the_dementor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, --GetModifierSpellAmplify_Percentage
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING, --GetModifierPercentageCooldownStacking
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, --GetModifierMagicalResistanceBonus
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT	-- GetModifierConstantManaRegen
	}

	return funcs
end

function modifier_item_imba_armlet_of_the_dementor:GetModifierSpellAmplify_Percentage()
	return self.bonus_spell_amp
end

function modifier_item_imba_armlet_of_the_dementor:GetModifierPercentageCooldownStacking()
	if self.parent:HasModifier("modifier_frantic") or self:GetStackCount() ~= 1 then
		return 0
	else
		return self.bonus_spell_cd
	end
end

function modifier_item_imba_armlet_of_the_dementor:GetModifierMagicalResistanceBonus()
	return self.bonus_magic_res
end

function modifier_item_imba_armlet_of_the_dementor:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

-- -- The rest are copied from swords.lua cause I can't transfer the classes between files
-- -------------------------------------
-- -- THE TRIUMVIRATE V2 SANGE ACTIVE --
-- -------------------------------------

-- function modifier_item_imba_the_triumvirate_v2_sange:OnCreated()
	-- self.ability			= self:GetAbility()
	-- self.sange_extension	= self.ability:GetSpecialValueFor("sange_extension")
	
	-- -- AbilitySpecials
	-- self.bonus_status_resistance_active	= self.ability:GetSpecialValueFor("bonus_status_resistance_active")
-- end

-- -- Modifier particle
-- function modifier_item_imba_the_triumvirate_v2_sange:GetEffectName()
	-- return "particles/items2_fx/sange_active.vpcf"
-- end

-- -- Declare modifier events/properties
-- function modifier_item_imba_the_triumvirate_v2_sange:DeclareFunctions()
	-- local funcs = {
		-- MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
		-- MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		-- MODIFIER_PROPERTY_TOOLTIP
	-- }
	-- return funcs
-- end

-- function modifier_item_imba_the_triumvirate_v2_sange:GetModifierStatusResistanceStacking()
	-- return self.bonus_status_resistance_active
-- end

-- function modifier_item_imba_the_triumvirate_v2_sange:OnAttackLanded(keys)
	-- if keys.target == self:GetParent() and keys.attacker:IsRealHero() and keys.attacker:GetTeam() ~= keys.target:GetTeam() then
		-- self:IncrementStackCount()
		-- -- Seems like I need to call this to update the health properly
		-- self:GetParent():CalculateStatBonus()
		-- self:SetDuration(self:GetRemainingTime() + self.sange_extension, true)
	-- end
-- end

-- function modifier_item_imba_the_triumvirate_v2_sange:GetModifierBonusStats_Strength(keys)
	-- return self:GetStackCount()
-- end

-- function modifier_item_imba_the_triumvirate_v2_sange:OnTooltip()
	-- return self:GetStackCount()
-- end

-- ------------------------------------------
-- -- THE TRIUMVIRATE V2 BASE YASHA ACTIVE --
-- ------------------------------------------

-- function modifier_item_imba_the_triumvirate_v2_yasha:OnCreated()
	-- self.ability			= self:GetAbility()
	-- self.yasha_extension	= self.ability:GetSpecialValueFor("yasha_extension")
	
	-- -- AbilitySpecials
	-- self.bonus_evasion_active	= self.ability:GetSpecialValueFor("bonus_evasion_active")
-- end

-- -- Modifier particle
-- function modifier_item_imba_the_triumvirate_v2_yasha:GetEffectName()
	-- return "particles/items2_fx/yasha_active.vpcf"
-- end

-- function modifier_item_imba_the_triumvirate_v2_yasha:DeclareFunctions()
	-- local funcs = {
		-- MODIFIER_PROPERTY_EVASION_CONSTANT,
		
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
		-- MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		-- MODIFIER_PROPERTY_TOOLTIP
	-- }

	-- return funcs
-- end

-- function modifier_item_imba_the_triumvirate_v2_yasha:GetModifierEvasion_Constant()
	-- return self:GetAbility():GetSpecialValueFor("bonus_evasion_active")
-- end

-- function modifier_item_imba_the_triumvirate_v2_yasha:OnAttackLanded(keys)
	-- if keys.attacker == self:GetParent() and keys.target:IsRealHero() and keys.attacker:GetTeam() ~= keys.target:GetTeam() then
		-- self:IncrementStackCount()
		-- -- IDK if I need to call this for Yasha but I'm doing it for the other two so w/e
		-- self:GetParent():CalculateStatBonus()
		-- self:SetDuration(self:GetRemainingTime() + self.yasha_extension, true)
	-- end
-- end

-- function modifier_item_imba_the_triumvirate_v2_yasha:GetModifierBonusStats_Agility(keys)
	-- return self:GetStackCount()
-- end

-- function modifier_item_imba_the_triumvirate_v2_yasha:OnTooltip()
	-- return self:GetStackCount()
-- end

-- -----------------------------------------
-- -- THE TRIUMVIRATE V2 BASE KAYA ACTIVE --
-- -----------------------------------------

-- function modifier_item_imba_the_triumvirate_v2_kaya:OnCreated()
	-- self.ability				= self:GetAbility()
	-- self.kaya_extension			= self.ability:GetSpecialValueFor("kaya_extension")
	-- self.kaya_min_health_dmg	= self.ability:GetSpecialValueFor("kaya_min_health_dmg")
	
	-- -- AbilitySpecials
	-- self.bonus_cdr_active	= self.ability:GetSpecialValueFor("bonus_cdr_active")
-- end

-- function modifier_item_imba_the_triumvirate_v2_kaya:GetEffectName()
	-- return "particles/items2_fx/kaya_active.vpcf"
-- end

-- function modifier_item_imba_the_triumvirate_v2_kaya:DeclareFunctions()
	-- local funcs =
	-- {
		-- MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		-- MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		-- MODIFIER_EVENT_ON_TAKEDAMAGE,
		
		-- MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		-- MODIFIER_PROPERTY_TOOLTIP
	-- }

	-- return funcs
-- end

-- function modifier_item_imba_the_triumvirate_v2_kaya:GetModifierPercentageCooldown()
	-- return self.bonus_cdr_active
-- end

-- function modifier_item_imba_the_triumvirate_v2_kaya:GetModifierPercentageManacost()
	-- return self.bonus_cdr_active
-- end

-- function modifier_item_imba_the_triumvirate_v2_kaya:OnTakeDamage(keys)
	-- if ((keys.attacker == self:GetParent() and keys.unit:IsRealHero()) or (keys.unit == self:GetParent() and keys.attacker:IsRealHero())) and keys.damage_category == 0 and keys.attacker:GetTeam() ~= keys.unit:GetTeam() then
		
		-- -- Spell damage taken/received should be above some threshold for...obvious reasons
		-- if (keys.damage >= self.kaya_min_health_dmg) then
			-- self:IncrementStackCount()
			-- -- Seems like I need to call this to update the mana properly
			-- self:GetParent():CalculateStatBonus()
			-- self:SetDuration(self:GetRemainingTime() + self.kaya_extension, true)
		-- end
	-- end
-- end

-- function modifier_item_imba_the_triumvirate_v2_kaya:GetModifierBonusStats_Intellect()
	-- return self:GetStackCount()
-- end

-- function modifier_item_imba_the_triumvirate_v2_kaya:OnTooltip()
	-- return self:GetStackCount()
-- end

-- ---------------------------------
-- -- THE TRIUMVIRATE V2 MODIFIER --
-- ---------------------------------

-- function modifier_item_imba_the_triumvirate_v2:IsHidden()		return true end
-- function modifier_item_imba_the_triumvirate_v2:IsPermanent()	return true end
-- function modifier_item_imba_the_triumvirate_v2:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- function modifier_item_imba_the_triumvirate_v2:OnCreated()
	-- self.ability	= self:GetAbility()
	-- self.caster		= self:GetCaster()
	-- self.parent		= self:GetParent()
	
	-- -- AbilitySpecials
	-- self.bonus_strength					=	self.ability:GetSpecialValueFor("bonus_strength")
	-- self.bonus_agility					=	self.ability:GetSpecialValueFor("bonus_agility")
	-- self.bonus_intellect				=	self.ability:GetSpecialValueFor("bonus_intellect")
	-- self.bonus_damage					=	self.ability:GetSpecialValueFor("bonus_damage")
	-- self.bonus_attack_speed				=	self.ability:GetSpecialValueFor("bonus_attack_speed")
	-- self.spell_amp						=	self.ability:GetSpecialValueFor("spell_amp")
	-- self.status_resistance				=	self.ability:GetSpecialValueFor("status_resistance")
	-- self.movement_speed_percent_bonus	=	self.ability:GetSpecialValueFor("movement_speed_percent_bonus")
	-- self.manacost_reduction				=	self.ability:GetSpecialValueFor("manacost_reduction")
	-- self.bonus_cdr						=	self.ability:GetSpecialValueFor("bonus_cdr")
	-- self.bonus_status_resistance_active	=	self.ability:GetSpecialValueFor("bonus_status_resistance_active")
	-- self.bonus_evasion_active			=	self.ability:GetSpecialValueFor("bonus_evasion_active")
	-- self.bonus_cdr_active				=	self.ability:GetSpecialValueFor("bonus_cdr_active")
-- end

-- function modifier_item_imba_the_triumvirate_v2:DeclareFunctions()
	-- local funcs = {
		-- MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		-- MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		-- MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		
		-- MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		-- MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		-- MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
		
		-- MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		-- MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,
		-- MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		
		-- MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	-- }

	-- return funcs
-- end

-- function modifier_item_imba_the_triumvirate_v2:GetModifierBonusStats_Strength()
	-- return self.bonus_strength
-- end

-- function modifier_item_imba_the_triumvirate_v2:GetModifierBonusStats_Agility()
	-- return self.bonus_agility
-- end

-- function modifier_item_imba_the_triumvirate_v2:GetModifierBonusStats_Intellect()
	-- return self.bonus_intellect
-- end



-- function modifier_item_imba_the_triumvirate_v2:GetModifierPreAttack_BonusDamage()
	-- return self.bonus_damage
-- end

-- function modifier_item_imba_the_triumvirate_v2:GetModifierAttackSpeedBonus_Constant()
	-- return self.bonus_attack_speed
-- end

-- function modifier_item_imba_the_triumvirate_v2:GetModifierSpellAmplify_PercentageUnique()
	-- return self.spell_amp
-- end



-- function modifier_item_imba_the_triumvirate_v2:GetModifierStatusResistanceStacking()
	-- return self.status_resistance
-- end

-- function modifier_item_imba_the_triumvirate_v2:GetModifierMoveSpeedBonus_Percentage_Unique()
	-- return self.movement_speed_percent_bonus
-- end

-- function modifier_item_imba_the_triumvirate_v2:GetModifierPercentageManacost()
	-- return self.manacost_reduction
-- end


-- function modifier_item_imba_the_triumvirate_v2:GetModifierPercentageCooldown()
	-- return self.bonus_cdr
-- end
