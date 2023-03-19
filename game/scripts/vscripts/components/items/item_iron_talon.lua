-- Creator:
-- 	AltiV - June 7th, 2019

LinkLuaModifier("modifier_item_imba_iron_talon", "components/items/item_iron_talon", LUA_MODIFIER_MOTION_NONE)

item_imba_iron_talon          = class({})
modifier_item_imba_iron_talon = class({})

---------------------
-- IRON TALON BASE --
---------------------

function item_imba_iron_talon:CastFilterResultTarget(hTarget)
	if not IsServer() then return end

	-- If the target is a different team than the caster AND
	-- If the target is a creep or a ward-type unit AND
	-- If the target is not an ancient OR
	-- If the target is an ancient and the caster satisfies the max stack criteria for The Hunt IMBAfication THEN
	-- yeah go ahead and cast it

	-- W.R.T. ward-types:
	-- "Can also target Observer Wards, Sentry Wards and Techies' Stasis Traps and Remote Mines."
	-- Guess it should be made to be ONLY be able to target those types of wards and not like...veno or shaman wards
	-- However, since they all share the same name, it'll work on Techies' Proximity Mines too
	if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		if (hTarget:IsCreep() or (hTarget:IsOther() and (string.find(hTarget:GetName(), "npc_dota_ward_base") or string.find(hTarget:GetName(), "npc_dota_techies_mines")))) and
			not hTarget:IsRoshan() then
			return UF_SUCCESS
		elseif hTarget:IsOther() and not (string.find(hTarget:GetName(), "npc_dota_ward_base") or string.find(hTarget:GetName(), "npc_dota_techies_mines")) then
			return UF_FAIL_CUSTOM
		end
	end

	-- Otherwise just follow the standard unit filtering and use the standard cast errors
	local nResult = UnitFilter(hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber())

	return nResult
end

function item_imba_iron_talon:GetCustomCastErrorTarget(hTarget)
	if not IsServer() then return end

	if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		if hTarget:IsOther() and not (string.find(hTarget:GetName(), "npc_dota_ward_base") or string.find(hTarget:GetName(), "npc_dota_techies_mines")) then
			return "Ability Can't Target This Ward-Type Unit"
		end
	end
end

function item_imba_iron_talon:GetCastRange(location, target)
	if target and target:IsOther() then
		return self:GetSpecialValueFor("cast_range_ward")
	else
		return self.BaseClass.GetCastRange(self, location, target)
	end
end

function item_imba_iron_talon:GetCooldown(level)
	if IsClient() then
		return self.BaseClass.GetCooldown(self, level)
	elseif self:GetCursorTarget() and (self:GetCursorTarget().CutDown or self:GetCursorTarget():IsOther()) then
		return self:GetSpecialValueFor("alternative_cooldown")
	else
		return self.BaseClass.GetCooldown(self, level)
	end
end

function item_imba_iron_talon:GetIntrinsicModifierName()
	return "modifier_item_imba_iron_talon"
end

function item_imba_iron_talon:OnSpellStart()
	-- IDK the proper way to check if a target is a tree or not so I'll just it with function check
	if self:GetCursorTarget().CutDown then
		self:GetCursorTarget():CutDown(self:GetCaster():GetTeamNumber())
	else
		-- Furion Sprout exception???
		if not self:GetCursorTarget().IsCreep then
			self:GetCursorTarget():Kill()
		elseif self:GetCursorTarget():IsCreep() then
			self:GetCursorTarget():EmitSound("DOTA_Item.IronTalon.Activate")

			local talon_particle = ParticleManager:CreateParticle("particles/items3_fx/iron_talon_active.vpcf", PATTACH_ABSORIGIN, self:GetCursorTarget())
			ParticleManager:SetParticleControl(talon_particle, 1, self:GetCursorTarget():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(talon_particle)

			local damageTable = {
				victim       = self:GetCursorTarget(),
				damage       = self:GetCursorTarget():GetHealth() * self:GetSpecialValueFor("creep_damage_pct") / 100,
				damage_type  = DAMAGE_TYPE_PURE,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = self:GetCaster(),
				ability      = self
			}

			ApplyDamage(damageTable)
		elseif self:GetCursorTarget():IsOther() then
			self:GetCursorTarget():Kill(self, self:GetCaster())
		end
	end
end

-------------------------
-- IRON TALON MODIFIER --
-------------------------

function modifier_item_imba_iron_talon:AllowIllusionDuplicate() return false end

function modifier_item_imba_iron_talon:IsPurgable() return false end

function modifier_item_imba_iron_talon:RemoveOnDeath() return false end

function modifier_item_imba_iron_talon:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_iron_talon:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- AbilitySpecials
	self.damage_bonus        = self:GetAbility():GetSpecialValueFor("damage_bonus")
	self.damage_bonus_ranged = self:GetAbility():GetSpecialValueFor("damage_bonus_ranged")
	self.bonus_armor         = self:GetAbility():GetSpecialValueFor("bonus_armor")

	self.hunt_bonus          = self:GetAbility():GetSpecialValueFor("hunt_bonus")
	self.hunt_bonus_ranged   = self:GetAbility():GetSpecialValueFor("hunt_bonus_ranged")
	self.hunt_max            = self:GetAbility():GetSpecialValueFor("hunt_max")
	self.hunt_max_ranged     = self:GetAbility():GetSpecialValueFor("hunt_max_ranged")

	if not IsServer() then return end

	if self:GetAbility() and self:GetAbility().hunt_stacks then
		self:SetStackCount(self:GetAbility().hunt_stacks)
	end
end

function modifier_item_imba_iron_talon:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

		--IMBAfication: The Hunt
		MODIFIER_EVENT_ON_DEATH,

		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP_2
	}

	return funcs
end

-- "Does not work against wards, buildings, Lone Druid Spirit Bear and allied units."
function modifier_item_imba_iron_talon:GetModifierPreAttack_BonusDamage(keys)
	if not IsServer() then return end

	if (self:GetParent():FindAllModifiersByName("modifier_item_imba_iron_talon")[1] == self) and keys.target and not keys.target:IsHero() and not keys.target:IsOther() and not keys.target:IsBuilding() and not string.find(keys.target:GetUnitName(), "npc_dota_lone_druid_bear") and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		-- Does not stack with Quelling Blade (let "The Hunt" bonus damage go through though)
		if self:GetParent():HasItemInInventory("item_quelling_blade") then
			return self:GetStackCount()
		elseif not self:GetParent():IsRangedAttacker() then
			return self.damage_bonus + self:GetStackCount()
		else
			return self.damage_bonus_ranged + self:GetStackCount()
		end
	end
end

function modifier_item_imba_iron_talon:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_imba_iron_talon:OnDeath(keys)
	if not IsServer() then return end

	if not self:GetParent():IsIllusion() and (self:GetParent():FindAllModifiersByName("modifier_item_imba_iron_talon")[1] == self) and keys.attacker == self:GetParent() and keys.unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS and ((not self:GetParent():IsRangedAttacker() and self:GetStackCount() < self.hunt_max) or (self:GetParent():IsRangedAttacker() and self:GetStackCount() < self.hunt_max_ranged)) then
		if not self:GetParent():IsRangedAttacker() then
			self:SetStackCount(math.min(self:GetStackCount() + self.hunt_bonus, self.hunt_max))
		else
			self:SetStackCount(math.min(self:GetStackCount() + self.hunt_bonus_ranged, self.hunt_max_ranged))
		end

		-- Save this value to the item itself, to preserve stacks if the item is dropped/picked up
		if self:GetAbility() then
			self:GetAbility().hunt_stacks = self:GetStackCount()
		end
	end
end

-- Tooltip for bonus melee damage
function modifier_item_imba_iron_talon:OnTooltip()
	return self.damage_bonus + self:GetStackCount()
end

-- Tooltip for bonus range damage
function modifier_item_imba_iron_talon:OnTooltip2()
	return self.damage_bonus_ranged + self:GetStackCount()
end
