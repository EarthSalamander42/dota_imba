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

		-- Grant or remove the appropriate modifiers
		local caster = self:GetCaster()
		if caster:HasModifier("modifier_imba_armlet_unholy_strength") then
			caster:EmitSound("DOTA_Item.Armlet.Activate")
			caster:RemoveModifierByName("modifier_imba_armlet_unholy_strength")
		else
			caster:EmitSound("DOTA_Item.Armlet.DeActivate")
			caster:AddNewModifier(caster, self, "modifier_imba_armlet_unholy_strength", {})
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
				MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,	}
end

function modifier_imba_armlet_unholy_strength:OnCreated()
	if IsServer() then

		-- Store parameters
		self.bonus_strength = self:GetAbility():GetSpecialValueFor("unholy_bonus_strength")
		self.health_per_stack = self:GetAbility():GetSpecialValueFor("health_per_stack")
		self.health_drain = self:GetAbility():GetSpecialValueFor("unholy_health_drain")
		self.unholy_bonus_damage = self:GetAbility():GetSpecialValueFor("unholy_bonus_damage")
		self.stack_damage = self:GetAbility():GetSpecialValueFor("stack_damage")
		self.unholy_bonus_armor = self:GetAbility():GetSpecialValueFor("unholy_bonus_armor")
		self.stack_armor = self:GetAbility():GetSpecialValueFor("stack_armor")
		self.stack_as = self:GetAbility():GetSpecialValueFor("stack_as")

		-- Adjust caster's health
		local caster = self:GetCaster()
		caster:SetHealth(caster:GetHealth() + self.bonus_strength * 20)

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_armlet_unholy_strength:OnDestroy()
	if IsServer() then

		-- Adjust caster's health
		local caster = self:GetCaster()
		local bonus_hp = self.bonus_strength * 20
		caster:SetHealth(math.max(caster:GetHealth() - self.bonus_strength, 1))
	end
end

function modifier_imba_armlet_unholy_strength:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		
		-- If the parent no longer has the modifier (which means he no longer has an armlet), commit sudoku
		if not parent:HasModifier("modifier_imba_armlet_basic") then
			self:Destroy()
			return
		end
		
		-- If this is an illusion, do nothing
		if not parent:IsRealHero() then return end
		
		-- Remove health from the owner
		parent:SetHealth(math.max( parent:GetHealth() - self.health_drain * 0.1, 1))
		
		-- Calculate stacks to apply
		local unholy_stacks = math.floor((parent:GetMaxHealth() - parent:GetHealth()) / self.health_per_stack)
		
		-- Update stacks
		self:SetStackCount(unholy_stacks)
		print(parent:GetAttackSpeed())
	end
end

function modifier_imba_armlet_unholy_strength:GetModifierBonusStats_Strength()			-- Static only
	return self.bonus_strength
end

function modifier_imba_armlet_unholy_strength:GetModifierPreAttack_BonusDamage()		-- Static + stacks
	return self.unholy_bonus_damage + self:GetStackCount() * self.stack_damage
end

function modifier_imba_armlet_unholy_strength:GetModifierPhysicalArmorBonus()			-- Static + stacks
	return self.unholy_bonus_armor + self:GetStackCount() * self.stack_armor
end

function modifier_imba_armlet_unholy_strength:GetModifierAttackSpeedBonus_Constant()	-- Stacks only
	return self:GetStackCount() * self.stack_as
end