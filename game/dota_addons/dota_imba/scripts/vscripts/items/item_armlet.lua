--	Author		 -	d2imba
--	DateCreated	 -	24.05.2015	<-- Shits' ancient yo
--	Date Updated -	05.03.2017
--	Converted to Lua by zimberzimber

-----------------------------------------------------------------------------------------------------------
--	Item Definition
-----------------------------------------------------------------------------------------------------------
if item_imba_armlet == nil then item_imba_armlet = class({}) end
LinkLuaModifier( "modifier_imba_armlet_basic", 			 "items/item_armlet.lua", LUA_MODIFIER_MOTION_NONE )	-- Item stat
LinkLuaModifier( "modifier_imba_armlet_unholy_strength", "items/item_armlet.lua", LUA_MODIFIER_MOTION_NONE )	-- Unholy Strength

function item_imba_armlet:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE + DOTA_ABILITY_BEHAVIOR_ITEM end
	
function item_imba_armlet:GetIntrinsicModifierName()
	return "modifier_imba_armlet_basic" end

function item_imba_armlet:OnSpellStart()
	if IsServer() then

		-- Health modification parameters
		local caster = self:GetCaster()
		local bonus_strength = self:GetSpecialValueFor("unholy_bonus_strength")
		local initial_hp = caster:GetHealth()
		local bonus_hp = bonus_strength * 20

		-- Adjust caster's health and grant the bonuses
		if caster:HasModifier("modifier_imba_armlet_unholy_strength") then
			caster:EmitSound("DOTA_Item.Armlet.Activate")
			caster:RemoveModifierByName("modifier_imba_armlet_unholy_strength")
			caster:SetHealth(math.max(initial_hp - bonus_hp, 1))
		else
			caster:EmitSound("DOTA_Item.Armlet.DeActivate")
			caster:AddNewModifier(caster, self, "modifier_imba_armlet_unholy_strength", {})
			caster:SetHealth(initial_hp + bonus_hp)
		end
	end
end

function item_imba_armlet:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_armlet_unholy_strength") then
		return "custom/imba_armlet_active" end
	
	return "custom/imba_armlet"
end

-----------------------------------------------------------------------------------------------------------
--	Basic modifier definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_armlet_basic == nil then modifier_imba_armlet_basic = class({}) end
function modifier_imba_armlet_basic:IsHidden() return true end
function modifier_imba_armlet_basic:IsDebuff() return false end
function modifier_imba_armlet_basic:IsPurgable() return false end
function modifier_imba_armlet_basic:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_armlet_basic:DeclareFunctions()
	return {	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
				MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,	
				MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
				MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,		}
end

function modifier_imba_armlet_basic:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage") end

function modifier_imba_armlet_basic:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end

function modifier_imba_armlet_basic:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor") end
	
function modifier_imba_armlet_basic:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_health_regen") end

-----------------------------------------------------------------------------------------------------------
--	Unholy Strength modifier definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_armlet_unholy_strength == nil then modifier_imba_armlet_unholy_strength = class({}) end
function modifier_imba_armlet_unholy_strength:IsHidden() return false end
function modifier_imba_armlet_unholy_strength:IsDebuff() return false end
function modifier_imba_armlet_unholy_strength:IsPurgable() return false end

function modifier_imba_armlet_unholy_strength:GetEffectName()
	return "particles/items_fx/armlet.vpcf" end

function modifier_imba_armlet_unholy_strength:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end
	
function modifier_imba_armlet_unholy_strength:DeclareFunctions()
	return {	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
				MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,	
				MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
				MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,}
end

function modifier_imba_armlet_unholy_strength:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_armlet_unholy_strength:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local health_per_stack = ability:GetSpecialValueFor("health_per_stack")
		local health_drain = ability:GetSpecialValueFor("unholy_health_drain") * 0.1
		
		-- If the parent no longer has the modifier (which means he no longer has an armlet), commit sudoku
		if not parent:HasModifier("modifier_imba_armlet_basic") then
			self:Destroy()
			return
		end
		
		-- If this is an illusion, do nothing
		if not parent:IsRealHero() then return end
		
		-- Remove health from the owner
		parent:SetHealth(math.max( parent:GetHealth() - health_drain, 1))
		
		-- Calculate stacks to apply
		local unholy_stacks = math.floor((parent:GetMaxHealth() - parent:GetHealth()) / health_per_stack)
		
		-- Update stacks
		self:SetStackCount(unholy_stacks)
	end
end

function modifier_imba_armlet_unholy_strength:GetModifierBonusStats_Strength()			-- Static only
	return self:GetAbility():GetSpecialValueFor("unholy_bonus_strength")
end

function modifier_imba_armlet_unholy_strength:GetModifierPreAttack_BonusDamage()		-- Static + stacks
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local stacks = self:GetStackCount()
	
	local base_bonus = ability:GetSpecialValueFor("unholy_bonus_damage")
	local bonus_per_stack = ability:GetSpecialValueFor("stack_damage")
	
	return bonus_per_stack * stacks + base_bonus
end

function modifier_imba_armlet_unholy_strength:GetModifierPhysicalArmorBonus()			-- Static + stacks
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local stacks = self:GetStackCount()
	
	local base_bonus = ability:GetSpecialValueFor("unholy_bonus_armor")
	local bonus_per_stack = ability:GetSpecialValueFor("stack_armor")
	
	return bonus_per_stack * stacks + base_bonus
end

function modifier_imba_armlet_unholy_strength:GetModifierAttackSpeedBonus_Constant()	-- Stacks only
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local stacks = self:GetStackCount()
	
	local bonus_per_stack = ability:GetSpecialValueFor("stack_as")
	
	return bonus_per_stack * stacks
end
