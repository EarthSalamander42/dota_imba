--	Author		 -	d2imba
--	Date Created -	15.08.2015	<-- Shits' ancient yo
--	Date Updated -	04.03.2017
--	Converted to Lua by zimberzimber

-----------------------------------------------------------------------------------------------------------
--	Item Definition
-----------------------------------------------------------------------------------------------------------
if item_imba_octarine_core == nil then item_imba_octarine_core = class({}) end
LinkLuaModifier( "modifier_imba_octarine_core_basic", "items/item_octarine_core.lua", LUA_MODIFIER_MOTION_NONE )	-- Item stat
LinkLuaModifier( "modifier_imba_octarine_core_unique", "items/item_octarine_core.lua", LUA_MODIFIER_MOTION_NONE )	-- lifesteal + magus pressence handler

function item_imba_octarine_core:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE + DOTA_ABILITY_BEHAVIOR_ITEM end
	
function item_imba_octarine_core:GetIntrinsicModifierName()
	return "modifier_imba_octarine_core_basic" end

function item_imba_octarine_core:OnSpellStart()
	if IsServer() then
		local uniqueModifier = self:GetCaster():FindModifierByName("modifier_imba_octarine_core_unique")
		if not uniqueModifier then return end -- If this happens, something is terribly wrong
		
		-- Get, and toggle state [ 1 = disabled | 2 = enabled ]
		local state = uniqueModifier:GetStackCount()
		if state == 2 then
			uniqueModifier:SetStackCount(1)
		else
			uniqueModifier:SetStackCount(2)
		end

		-- Play sound only to the caster
		self:GetCaster():EmitSound("Item.DropGemWorld")

		-- Ignore the item's cooldown
		self:EndCooldown()
	end
end

function item_imba_octarine_core:GetAbilityTextureName()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_octarine_core_unique") then
		local state = caster:GetModifierStackCount("modifier_imba_octarine_core_unique", caster)
		if state == 1 then return "custom/imba_octarine_core_off" end
	end
	
	return "custom/imba_octarine_core"
end

-----------------------------------------------------------------------------------------------------------
--	Basic modifier definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_octarine_core_basic == nil then modifier_imba_octarine_core_basic = class({}) end
function modifier_imba_octarine_core_basic:IsHidden() return true end
function modifier_imba_octarine_core_basic:IsDebuff() return false end
function modifier_imba_octarine_core_basic:IsPurgable() return false end
function modifier_imba_octarine_core_basic:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_octarine_core_basic:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local uniqueModifier = parent:FindModifierByName("modifier_imba_octarine_core_unique")
		
		-- If the parent doesn't have the unique modifier, apply it and set its state to enabled
		if not uniqueModifier then
			uniqueModifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_imba_octarine_core_unique", {})
			uniqueModifier:SetStackCount(2)
		end
	end
end

function modifier_imba_octarine_core_basic:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		
		-- See if the parent has another core
		for i = 0,5 do
			local item = parent:GetItemInSlot(i)
			if item and item:GetName() == "item_imba_octarine_core" then return end
		end
		
		-- Remove the unique modifier if no other core was found
		parent:RemoveModifierByName("modifier_imba_octarine_core_unique")
	end
end

function modifier_imba_octarine_core_basic:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MANA_BONUS,
					MODIFIER_PROPERTY_HEALTH_BONUS,	
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,	}
	return funcs
end
	
function modifier_imba_octarine_core_basic:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_mana") end
	
function modifier_imba_octarine_core_basic:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health") end

function modifier_imba_octarine_core_basic:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_intelligence") end

-----------------------------------------------------------------------------------------------------------
--	Unique modifier definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_octarine_core_unique == nil then modifier_imba_octarine_core_unique = class({}) end
function modifier_imba_octarine_core_unique:IsHidden() return true end
function modifier_imba_octarine_core_unique:IsDebuff() return false end
function modifier_imba_octarine_core_unique:IsPurgable() return false end

function modifier_imba_octarine_core_unique:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
					MODIFIER_EVENT_ON_SPENT_MANA	}
	return funcs
end

function modifier_imba_octarine_core_unique:GetModifierSpellLifesteal()
	return self:GetAbility():GetSpecialValueFor("spell_lifesteal") end

function modifier_imba_octarine_core_unique:GetModifierPercentageCooldownStacking()
	return self:GetAbility():GetSpecialValueFor("bonus_cooldown") end

function modifier_imba_octarine_core_unique:OnSpentMana( keys )
	if IsServer() then
		local state = self:GetStackCount()
		if state == 2 then	-- [ 1 = disabled | 2 = enabled ]
		
			local ability = self:GetAbility()
			local parent = self:GetParent()

			local spell = keys.ability
			local cost = keys.cost
			local unit = keys.unit
			
			local blast_radius = ability:GetSpecialValueFor("blast_radius")
			local blast_damage = ability:GetSpecialValueFor("blast_damage")
			
			if unit == parent and ability:IsCooldownReady() and cost > 0 then

				-- Trigger ability cooldown
				ability:StartCooldown(ability:GetCooldown(0) * GetCooldownReduction(parent))
				
				-- Blast geometry
				local blast_duration = 0.75 * 0.75
				local blast_speed = blast_radius / blast_duration

				-- Calculate damage
				local damage = cost * blast_damage * 0.01
				
				-- Fire particle
				local blast_pfx = ParticleManager:CreateParticle("particles/item/octarine_core/octarine_core_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
				ParticleManager:SetParticleControl(blast_pfx, 0, parent:GetAbsOrigin())
				ParticleManager:SetParticleControl(blast_pfx, 1, Vector(100,0,blast_speed))
				ParticleManager:ReleaseParticleIndex(blast_pfx)

				-- Fire sound
				parent:EmitSound("Hero_Zuus.StaticField")
					
				-- Find units in the blast radius
				local blast_targets = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, blast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

				-- Damage units inside the blast radius if they haven't been affected already
				for _,target in pairs(blast_targets) do
					
					-- Apply damage
					ApplyDamage({attacker = parent, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
					
					-- Fire particle
					local hit_pfx = ParticleManager:CreateParticle("particles/item/octarine_core/octarine_core_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
					ParticleManager:SetParticleControl(hit_pfx, 0, target:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(hit_pfx)
					
					-- Print overhead message
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, damage, nil)
				end
			end
		end
	end
end