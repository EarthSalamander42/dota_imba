--	Nokrah's Blade
--	by Firetoad, 2018.06.26

LinkLuaModifier( "modifier_item_nokrash_blade", "components/items/item_nokrash_blade.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_nokrash_blade_unique", "components/items/item_nokrash_blade.lua", LUA_MODIFIER_MOTION_NONE )	-- Unique toggle modifier
LinkLuaModifier( "modifier_item_nokrash_blade_buff", "components/items/item_nokrash_blade.lua", LUA_MODIFIER_MOTION_NONE )		-- Physical damage prevention modifier
LinkLuaModifier( "modifier_item_nokrash_blade_debuff", "components/items/item_nokrash_blade.lua", LUA_MODIFIER_MOTION_NONE )	-- Target magic resistance debuff

item_nokrash_blade = item_nokrash_blade or class({})

function item_nokrash_blade:GetIntrinsicModifierName()
	return "modifier_item_nokrash_blade"
end

function item_nokrash_blade:OnSpellStart()
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_item_nokrash_blade_unique") then
			self:GetCaster():RemoveModifierByName("modifier_item_nokrash_blade_unique")
		else
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_nokrash_blade_unique", {})
		end
	end
end

function item_nokrash_blade:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_item_nokrash_blade_unique") then
		return "custom/nokrash_blade_active"
	else
		return "custom/nokrash_blade"
	end
end

---------------------------------------------------------------------------------------------------------

modifier_item_nokrash_blade = class({})

function modifier_item_nokrash_blade:IsHidden() return true end
function modifier_item_nokrash_blade:IsDebuff() return false end
function modifier_item_nokrash_blade:IsPurgable() return false end
function modifier_item_nokrash_blade:IsPermanent() return true end
function modifier_item_nokrash_blade:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_nokrash_blade:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
	return funcs
end

function modifier_item_nokrash_blade:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

function modifier_item_nokrash_blade:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
end

function modifier_item_nokrash_blade:GetModifierPercentageManacost()
	return self:GetAbility():GetSpecialValueFor("bonus_manacost_reduction")
end

function modifier_item_nokrash_blade:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

-----------------------------------------------------------------------------------------------------------

modifier_item_nokrash_blade_unique = class({})

function modifier_item_nokrash_blade_unique:IsHidden() return true end
function modifier_item_nokrash_blade_unique:IsDebuff() return false end
function modifier_item_nokrash_blade_unique:IsPurgable() return false end
function modifier_item_nokrash_blade_unique:IsPermanent() return true end

function modifier_item_nokrash_blade_unique:ActivateNokrahProjectile()
	if IsServer() then
		self:GetParent():SetRangedProjectileName("particles/items_fx/nokrahs_blade.vpcf")
	end
end

function modifier_item_nokrash_blade_unique:DeactivateNokrahProjectile()
	if IsServer() then
		local owner = self:GetParent()
		if NPC_HEROES_CUSTOM[owner:GetUnitName()] then
			if NPC_HEROES_CUSTOM[owner:GetUnitName()]["ProjectileModel"] then
				owner:SetRangedProjectileName(NPC_HEROES_CUSTOM[owner:GetUnitName()]["ProjectileModel"])
			end
		elseif NPC_HEROES[owner:GetUnitName()] then
			if NPC_HEROES[owner:GetUnitName()]["ProjectileModel"] then
				owner:SetRangedProjectileName(NPC_HEROES[owner:GetUnitName()]["ProjectileModel"])
			end
		end
	end
end

function modifier_item_nokrash_blade_unique:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_item_nokrash_blade_unique:OnAttackStart(keys)
	if IsServer() then
		if self:GetParent() == keys.attacker then
			local owner = self:GetParent()
			-- No spellfencers in inventory, do nothing
			if ( not owner ) or ( not owner:HasModifier("modifier_item_nokrash_blade") ) then
				self:DeactivateNokrahProjectile()
				self:Destroy()
				return nil
			end

			-- If this is an illusion, do zilch
			if owner:IsIllusion() then
				return nil
			end

			-- If the target is not valid, do nada
			local target = keys.target
			if target:IsBuilding() then
				return nil
			end

			-- If the attacker doesn't have enough mana, put your hands in your ears and say tralala
			local ability = self:GetAbility()
			if owner:GetMana() < ability:GetSpecialValueFor("mana_cost") then
				return nil

			-- Else, actually launch the attack
			else
				-- owner:SpendMana(ability:GetSpecialValueFor("mana_cost"), ability)
				-- owner:EmitSound("DOTA_Item.Nokrahs_Blade.Attack")
				self:ActivateNokrahProjectile()
				Timers:CreateTimer(0.01, function()
					self:DeactivateNokrahProjectile()
				end)
			end
		end
	end
end

function modifier_item_nokrash_blade_unique:OnAttack(keys)
	if IsServer() then
		if self:GetParent() == keys.attacker then
			local owner = self:GetParent()
			self.magicAttack = false
			-- No spellfencers in inventory, do nothing
			-- if ( not owner ) or ( not owner:HasModifier("modifier_item_nokrash_blade") ) then
			-- 	self:Destroy()
			-- 	return nil
			-- end

			-- If this is an illusion, do zilch
			if owner:IsIllusion() then
				return nil
			end

			-- If the target is not valid, do nada
			local target = keys.target
			if target:IsBuilding() then
				return nil
			end

			-- Do not trigger on secondary attacks
			if keys.no_attack_cooldown then 
				return nil
			end

			-- if not self.magicAttack then return nil end

			-- If the attacker doesn't have enough mana, put your hands in your ears and say tralala
			local ability = self:GetAbility()
			if owner:GetMana() < ability:GetSpecialValueFor("mana_cost") then
				return nil

			-- Else, actually launch the attack
			else
				self.magicAttack = true
				owner:SpendMana(ability:GetSpecialValueFor("mana_cost"), ability)
				owner:EmitSound("DOTA_Item.Nokrahs_Blade.Attack")
				-- self:ActivateNokrahProjectile()
				-- Timers:CreateTimer(0.01, function()
				-- 	self:DeactivateNokrahProjectile()
				-- end)
			end
		end
	end
end

function modifier_item_nokrash_blade_unique:OnAttackLanded(keys)
	if IsServer() then
		if self:GetParent() == keys.attacker then
			local owner = self:GetParent()
			local target = keys.target
			local ability = self:GetAbility()

			-- If this is an illusion, do zilch
			if owner:IsIllusion() then
				return nil
			end

			-- If the target is not valid, do nada
			local target = keys.target
			if target:IsBuilding() then
				return nil
			end

			-- If the last attack was not activated with the item, do a barrel roll
			if not self.magicAttack then return nil end

			-- If this is not a ranged attacker, play the impact animation
			if not owner:IsRangedAttacker() then
				local impact_pfx = ParticleManager:CreateParticle("particles/items_fx/nokrahs_blade_explosion_flash.vpcf", PATTACH_CUSTOMORIGIN, target)
				ParticleManager:SetParticleControl(impact_pfx, 3, target:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(impact_pfx)
			end

			-- Play sound
			target:EmitSound("DOTA_Item.Nokrahs_Blade.Hit")

			-- Apply the damage conversion modifier and deal magical damage
			owner:AddNewModifier(owner, ability, "modifier_item_nokrash_blade_buff", {duration = 0.01})
			target:AddNewModifier(owner, ability, "modifier_item_nokrash_blade_buff", {duration = 0.01})
			target:AddNewModifier(owner, ability, "modifier_item_nokrash_blade_debuff", {duration = ability:GetSpecialValueFor("duration")})
			ApplyDamage({attacker = owner, victim = target, ability = ability, damage = keys.original_damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flag = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS})
		end
	end
end

-----------------------------------------------------------------------------------------------------------

modifier_item_nokrash_blade_debuff = class({})
function modifier_item_nokrash_blade_debuff:IsHidden() return false end
function modifier_item_nokrash_blade_debuff:IsDebuff() return true end
function modifier_item_nokrash_blade_debuff:IsPurgable() return true end

function modifier_item_nokrash_blade_debuff:GetTexture()
	return "custom/nokrash_blade_active"
end

function modifier_item_nokrash_blade_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_item_nokrash_blade_debuff:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("magic_resist_debuff")
end

-----------------------------------------------------------------------------------------------------------

modifier_item_nokrash_blade_buff = class({})

function modifier_item_nokrash_blade_buff:IsHidden() return true end
function modifier_item_nokrash_blade_buff:IsDebuff() return false end
function modifier_item_nokrash_blade_buff:IsPurgable() return false end

function modifier_item_nokrash_blade_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL
	}
	return funcs
end

function modifier_item_nokrash_blade_buff:GetAbsoluteNoDamagePhysical()
	return 1
end
