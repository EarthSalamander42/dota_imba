-- Author: Shush
-- Date: 26/02/2020

item_imba_tango = item_imba_tango or class({})

LinkLuaModifier("modifier_imba_tango", "components/items/item_tango", LUA_MODIFIER_MOTION_NONE)


------------
-- TANGO  --
------------

-- This is done to centralize the code for both Tango and Single Tango
function TangoCastFilterResult(ability, target)
	-- Cannot cast on self
	if target == ability:GetCaster() then
		return UF_FAIL_CUSTOM
	end  

	-- Cannot cast on illusions
	if target:IsIllusion() then
		return UF_FAIL_ILLUSION
	end
		
	if not IsServer() then return end    

	-- Allow it if it's an enemy ward of any kind, or your own units
	if target:IsOther() then
		if target:GetTeamNumber() ~= ability:GetCaster():GetTeamNumber() or target:GetOwner() == ability:GetCaster() or target:GetName() == "npc_dota_ward_base" then
			return UF_SUCCESS
		else
			return UF_FAIL_CUSTOM
		end
	end

	-- Cannot cast on enemies (except for wards)
	if target:GetTeamNumber() ~= ability:GetCaster():GetTeamNumber() then
		return UF_FAIL_ENEMY    

	-- Allow if target is a tree of any kind
	elseif target:Custom_IsTree() then        
		return UF_SUCCESS

	-- Allow if target is a friendly real hero, or a creep hero with inventory e.g. Lone Druid bear
	elseif target:IsConsideredHero() and not target:IsIllusion() and target:HasInventory() and target:GetTeamNumber() == ability:GetCaster():GetTeamNumber() then
		return UF_SUCCESS
	end    

	local unitFilter = UnitFilter(target, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), ability:GetCaster():GetTeamNumber())
	return unitFilter
end

function CastErrorTarget(self, target)
	-- Cannot cast on self
	if target == self:GetCaster() then
		return "dota_hud_error_cant_cast_on_self"
	end    

	-- Can only target enemy wards or your own. If we're here, the caster tried to eat a ward that is not allowed
	if target:IsOther() then
		return "Can only eat your and the enemy's wards."
	end
end

function item_imba_tango:CastFilterResultTarget(target)    
	return TangoCastFilterResult(self, target)
end

function item_imba_tango:GetCustomCastErrorTarget(target)    
	return CastErrorTarget(self, target)
end

function item_imba_tango:OnSpellStart()
	UseTango(self)
end


-- This is done to centralize the code for both Tango and Single Tango
function UseTango(ability)
	-- Ability properties
	local caster = ability:GetCaster()    
	local target = ability:GetCursorTarget()
	local cast_sound = "DOTA_Item.Tango.Activate"
	local single_tango = "item_imba_tango_single"
	local orig_tango = "item_imba_tango"       
	local modifier_tango = "modifier_imba_tango" 

	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")
	local ironwood_multiplier = ability:GetSpecialValueFor("ironwood_multiplier")
	local ward_multiplier = ability:GetSpecialValueFor("ward_multiplier")
	local ward_eat_cd = ability:GetSpecialValueFor("ward_eat_cd")         

	-- Set defaault variable values
	local stacks = 1
	local gave_tango = false

	-- Determine target type and behave accordingly
	-- If target is a friendly hero or a creep hero, give it a Single Tango
	if target.IsConsideredHero and target:IsConsideredHero() then        

		-- Using custom function since creep heroes (e.g. Lone Druid's bear) don't have the HasAnyAvailableInventorySpace function
		if target:Custom_HasAnyAvailableInventorySpace() then
			target:AddItemByName(single_tango)
		else
			local single_tango_item = CreateItem(single_tango, target, nil)
			CreateItemOnPositionSync(target:GetAbsOrigin(), single_tango_item)
		end

		-- If this is a single instance that you gave, refresh the cooldown of the item.
		if ability:GetName() == single_tango then
			ability:EndCooldown()
		end

		-- This tags to the code that the tango has been given, not used.
		gave_tango = true

	-- if target is a tree
	elseif target:Custom_IsTree() then

		-- Determine if tree is special tree or regular
		-- If it's a special tree, set special tree multiplier
		if target:Custom_IsTempTree() then
			stacks = ironwood_multiplier
			-- Destroy the tree (need to be killed instead of cut)
			target:Kill()
		else            
			-- Destroy the tree
			target:CutDown(caster:GetTeamNumber())
		end        

	-- Otherwise, if the target is a ward
	else 
		-- Destroy ward, crediting the kill to the owner
		target:Kill(ability, caster)                

		-- Cause item to go on cooldown
		-- Only do this if the tango isn't a single instance, since it has its own cooldown already
		if ability:GetName() == orig_tango then
			ability:StartCooldown(ward_eat_cd)

			-- Check if you have single instances tango, and put them on cooldown too
			if caster:HasItemInInventory(single_tango) then
				caster:FindItemInInventory(single_tango):StartCooldown(ward_eat_cd)
			end
		end

		-- Put Tango into a cooldown if Single Instance tango was used to eat a ward
		if ability:GetName() == single_tango then
			if caster:HasItemInInventory(orig_tango) then
				caster:FindItemInInventory(orig_tango):StartCooldown(ward_eat_cd)
			end
		end

		-- Set stacks to ward stacks count
		stacks = ward_multiplier
	end

	

	-- We'll only  further if the tango was used and not given.
	if not gave_tango then
	   -- Emit sound
		EmitSoundOn(cast_sound, caster)

		-- Check if the caster already has tango modifier
		if caster:HasModifier(modifier_tango) then
			-- Get modifier and tweak stack count and refresh it
			local modifier = caster:FindModifierByName(modifier_tango)
			modifier:SetStackCount(modifier:GetStackCount() + stacks)
			modifier:ForceRefresh()
		else
			-- Otherwise add regeneration modifier to yourself and set stacks accordingly
			local modifier = caster:AddNewModifier(caster, ability, modifier_tango, {duration = duration})
			modifier:SetStackCount(stacks)
		end
	end    

	-- Decrease charge, destroy item when out of charges
	ability:SpendCharge()
end


---------------------------
-- TANGO REGEN MODIFIER  --
---------------------------


modifier_imba_tango = modifier_imba_tango or class({})

function modifier_imba_tango:IsHidden() return false end
function modifier_imba_tango:IsPurgable() return false end
function modifier_imba_tango:IsDebuff() return false end

function modifier_imba_tango:GetTexture()
	return "item_tango"
end

function modifier_imba_tango:OnCreated(params)
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()        

	-- Ability specials
	self.hp_regen = self.ability:GetSpecialValueFor("hp_regen")    
	self.duration = self.ability:GetSpecialValueFor("duration")

	if IsServer() then
		-- Initialize stacks table
		self.stack_table = {}

		-- Start thinking
		self:StartIntervalThink(1)
	end    
end

function modifier_imba_tango:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT} 
	return decFuncs
end

function modifier_imba_tango:GetModifierConstantHealthRegen()    
	return self.hp_regen * self:GetStackCount()
end

function modifier_imba_tango:GetEffectName()
	return "particles/items_fx/healing_tango.vpcf"
end

function modifier_imba_tango:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_tango:OnIntervalThink()
	local repeat_needed = true

	-- We''ll repeat the table removal check and remove as many expired items from it as needed.
	while repeat_needed do
		-- Check if the firstmost entry in the table has expired
		local item_time = self.stack_table[1]

		-- If the difference between times is longer, it's time to get rid of a stack
		if GameRules:GetGameTime() - item_time >= self.duration then
			-- Check if there is only one stack, which would mean bye bye debuff
			if self:GetStackCount() == 1 then
				self:Destroy()
				break
			else
				-- Remove the entry from the table
				table.remove(self.stack_table, 1)

				-- Decrement a stack
				self:DecrementStackCount()

				-- Calculate hero status
				if self.parent.CalculateStatBonus then
					self.parent:CalculateStatBonus(true)
				end
			end
		else
			-- If no more items need to be removed, no need to repeat the table
			repeat_needed = false
		end
	end
end

function modifier_imba_tango:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end

	local stacks = self:GetStackCount()

	-- We only care about stack incrementals
	if stacks > prev_stacks then
		-- Insert the current game time of the stack that was just added to the stack table
		table.insert(self.stack_table, GameRules:GetGameTime())

		-- Refresh timer
--		self:ForceRefresh()
	end
end

------------------------------
-- Tango - Single Instance  --
------------------------------

item_imba_tango_single = item_imba_tango_single or class({})

function item_imba_tango_single:CastFilterResultTarget(target)    
	return TangoCastFilterResult(self, target)
end

function item_imba_tango_single:GetCustomCastErrorTarget(target)    
	return CastErrorTarget(self, target)
end

function item_imba_tango_single:OnSpellStart()
	UseTango(self)
end