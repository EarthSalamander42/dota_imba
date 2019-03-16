-- Creator:
-- 	AltiV - March 15th, 2019

LinkLuaModifier("modifier_item_imba_transient_boots", "components/items/item_transient_boots.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_transient_boots_invis", "components/items/item_transient_boots.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_transient_boots_break", "components/items/item_transient_boots.lua", LUA_MODIFIER_MOTION_NONE)

item_imba_transient_boots					= class({})
modifier_item_imba_transient_boots			= class({})
modifier_item_imba_transient_boots_invis	= class({})
modifier_item_imba_transient_boots_break	= class({})

-- //=================================================================================================================
	-- // Glimmer Cape
	-- //=================================================================================================================
	-- "item_glimmer_cape"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"							"254"														// unique ID number for this item.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_IMMEDIATE | DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT"
		-- "AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		-- "AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		-- "FightRecapLevel"				"1"
		-- "SpellDispellableType"			"SPELL_DISPELLABLE_YES"

		-- // Stats		
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCastRange"				"800"
		-- "AbilityCooldown"				"14.0"
		-- "AbilityManaCost"				"90"
		
		-- // Item Info
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ItemCost"						"1950"
		-- "ItemShopTags"					""
		-- "ItemQuality"					"rare"
		-- "ItemAliases"					"glimmer cape"
		-- "ShouldBeSuggested"				"1"
		
		-- // Special	
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilitySpecial"
		-- {			
			-- "01"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "bonus_attack_speed"	"20"
			-- }
			-- "02"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "bonus_magical_armor"	"15"
			-- }
			-- "03"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "fade_delay"				"0.6"
			-- }
			-- "04"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "active_magical_armor"	"45"
			-- }
			-- "05"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "duration"	"5"
			-- }
			-- "06"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "tooltip_range"			"800"
			-- }
			-- "07"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "building_duration_limit"			"180"
			-- }
		-- }
	-- }
	
		-- //=================================================================================================================
	-- // Tranquil Boots
	-- //=================================================================================================================
	-- "item_tranquil_boots"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"							"214"														// unique ID number for this item.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"

		-- // Stats		
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCooldown"				"13.0"
		-- "AbilityManaCost"				"0"
		
		-- // Item Info
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ItemCost"						"1050"
		-- "ItemShopTags"					"move_speed;regen_health;armor"
		-- "ItemQuality"					"rare"
		-- "ItemAliases"					"tranquil boots"
		-- "ItemHideCharges"		     	"1"
		-- "ItemDeclarations"				"DECLARE_PURCHASES_TO_SPECTATORS"
		-- "ShouldBeSuggested"				"1"
		
		-- // Special	
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilitySpecial"
		-- {
			-- "01"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "bonus_movement_speed"	"26"
			-- }
			-- "02"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "bonus_armor"			"0"
			-- }
			-- "03"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "bonus_health_regen"	"16"
			-- }
			-- "04"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "heal_duration"			"20.0"
			-- }
			-- "05"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "heal_amount"			"250"
			-- }
			-- "06"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "heal_interval"			"0.334"
			-- }
			-- "07"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "break_time"			"13"
			-- }
			-- "08"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "break_count"			"1"
			-- }
			-- "09"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "break_threshold"		"20"
			-- }
			-- "10"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "broken_movement_speed"	"18"
			-- }
		-- }
	-- }
	

--------------------------
-- TRANSIENT BOOTS BASE --
--------------------------

function item_imba_transient_boots:GetIntrinsicModifierName()
	return "modifier_item_imba_transient_boots"
end

-- function item_imba_rod_of_atos:GetAbilityTextureName()
	-- if self:GetLevel() == 2 then
		-- if self:GetCaster():GetModifierStackCount("modifier_item_imba_rod_of_atos", self:GetCaster()) == self:GetSpecialValueFor("curtain_fire_activation_charge") then
			-- return "custom/imba_rod_of_atos_2_cfs"
		-- else
			-- return "custom/imba_rod_of_atos_2"
		-- end
	-- else
		-- return "item_rod_of_atos"
	-- end
-- end


function item_imba_transient_boots:OnSpellStart()
	self.caster		= self:GetCaster()
	
	-- AbilitySpecials
	self.fade_delay				= self:GetSpecialValueFor("fade_delay")
	self.active_magical_armor	= self:GetSpecialValueFor("active_magical_armor")
	self.duration				= self:GetSpecialValueFor("duration")
			
	-- Play the cast sound
	self.caster:EmitSound("Item.GlimmerCape.Activate")
	
	
	
	
	
	
	
	-- -- self.bonus_intellect	=	self:GetSpecialValueFor("bonus_intellect")
	-- -- self.bonus_strength		=	self:GetSpecialValueFor("bonus_strength")
	-- -- self.bonus_agility		=	self:GetSpecialValueFor("bonus_agility")
	-- self.duration				=	self:GetSpecialValueFor("duration")
	-- self.tooltip_range			=	self:GetSpecialValueFor("tooltip_range")
	-- self.projectile_speed		=	self:GetSpecialValueFor("projectile_speed")

	-- self.curtain_fire_radius			=	self:GetSpecialValueFor("curtain_fire_radius")
	-- self.curtain_fire_length			=	self:GetSpecialValueFor("curtain_fire_length")
	-- self.curtain_fire_shot_count		=	self:GetSpecialValueFor("curtain_fire_shot_count")
	-- self.curtain_fire_delay				=	self:GetSpecialValueFor("curtain_fire_delay")
	-- self.curtain_fire_speed				=	self:GetSpecialValueFor("curtain_fire_speed")
	-- self.curtain_fire_activation_charge	=	self:GetSpecialValueFor("curtain_fire_activation_charge")
	
	-- self.curtain_fire_radius_second		=	self:GetSpecialValueFor("curtain_fire_radius_second")
	
	-- if not IsServer() then return end
	
	-- local caster_location	= self.caster:GetAbsOrigin()
	-- local target			= self:GetCursorTarget()
	-- local target_location	= 0
	-- local direction			= 0
		
	-- -- Play the cast sound
	-- self.caster:EmitSound("DOTA_Item.RodOfAtos.Cast")

	-- -- Only the upgraded version with enough charges gets Curtain Fire Shooting (also no tempest doubles allowed cause anti-fun)
	-- if self:GetLevel() < 2 or self:GetCurrentCharges() < self.curtain_fire_activation_charge or self.caster:IsTempestDouble() then 
		-- local projectile =
				-- {
					-- Target 				= target,
					-- Source 				= self.caster,
					-- Ability 			= self,
					-- EffectName 			= "particles/items2_fx/rod_of_atos_attack.vpcf",
					-- iMoveSpeed			= self.projectile_speed,
					-- vSourceLoc 			= caster_location,
					-- bDrawsOnMinimap 	= false,
					-- bDodgeable 			= true,
					-- bIsAttack 			= false,
					-- bVisibleToEnemies 	= true,
					-- bReplaceExisting 	= false,
					-- flExpireTime 		= GameRules:GetGameTime() + 20,
					-- bProvidesVision 	= false,
				-- }
				
			-- ProjectileManager:CreateTrackingProjectile(projectile)
		
		-- -- Increment a charge towards Curtain Fire Shooting
		-- if self:GetLevel() >= 2 then
			-- self:SetCurrentCharges(math.min(self:GetCurrentCharges() + 1, self.curtain_fire_activation_charge))
			-- -- This is just for client-side showing AoE radius when it is ready
			-- local modifier = self.caster:FindModifierByName("modifier_item_imba_rod_of_atos")
			
			-- if modifier then
				-- modifier:SetStackCount(self:GetCurrentCharges())
			-- end
		-- end
		
		-- return 
	-- end

	-- -- If the thing is casted (this is "legacy" code that allowed location cast but it was removed)
	-- if target then
		-- target_location 		= target:GetAbsOrigin()
	-- else	
		-- target_location			= self:GetCursorPosition()
	-- end
	
	-- -- Get the direction between the caster and the target
	-- direction				= (target_location - caster_location):Normalized()

	-- local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), target_location, nil, self.curtain_fire_radius, DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	
	-- local counter = 0
	
	-- for _, enemy in pairs(enemies) do
		-- Timers:CreateTimer(counter * self.curtain_fire_delay, function()
			-- local projectile =
			-- {
				-- Target 				= enemy,
				-- Source 				= self.caster,
				-- Ability 			= self,
				-- EffectName 			= "particles/items2_fx/rod_of_atos_attack.vpcf",
				-- iMoveSpeed			= self.projectile_speed,
				-- vSourceLoc 			= caster_location,
				-- bDrawsOnMinimap 	= false,
				-- bDodgeable 			= true,
				-- bIsAttack 			= false,
				-- bVisibleToEnemies 	= true,
				-- bReplaceExisting 	= false,
				-- flExpireTime 		= GameRules:GetGameTime() + 20,
				-- bProvidesVision 	= false,
				-- --	iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
				-- --	iVisionRadius 		= 400,
				-- --	iVisionTeamNumber 	= self.caster:GetTeamNumber()
				-- -- ExtraData			= {caster = self.caster, duration = self.duration} -- IDK if this doesn't work with items or something
			-- }
			
			-- ProjectileManager:CreateTrackingProjectile(projectile)
		-- end)
		
		-- counter = counter + 1
	-- end

	-- local curtain_fire_starting_point	=	target_location - (direction * 1400)

	-- for shot = 0, self.curtain_fire_shot_count + #enemies do
		-- Timers:CreateTimer(shot * self.curtain_fire_delay, function()
			-- local random_spawn_distance		=	RandomInt(-self.curtain_fire_length, self.curtain_fire_length)

			-- local random_spawn_location		=	curtain_fire_starting_point + Vector(direction.y * random_spawn_distance, -direction.x * random_spawn_distance, 100) -- 100 is so the projectiles don't all spawn sunk into the ground
			-- local random_target_location	=	GetGroundPosition(target_location + RandomVector(self.curtain_fire_radius_second * 0.5), nil)
			-- local random_fire_direction		=	random_target_location - random_spawn_location
			
			-- -- So the console doesn't yell at us for non-zero vertical velocity
			-- random_fire_direction.z			= 0
		
			-- local linear_projectile = {
				-- Ability				= self,
				-- EffectName			= "particles/hero/scaldris/ice_spell_projectile.vpcf", -- Borrowing pre-made projectile...
				-- vSpawnOrigin		= random_spawn_location,
				-- fDistance			= random_fire_direction:Length2D() + self.curtain_fire_radius_second,
				-- fStartRadius		= 70,
				-- fEndRadius			= 70,
				-- Source				= self.caster,
				-- bHasFrontalCone		= true,
				-- bReplaceExisting	= false,
				-- iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
				-- iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
				-- iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				-- fExpireTime 		= GameRules:GetGameTime() + 10.0,
				-- bDeleteOnHit		= true,
				-- vVelocity			= random_fire_direction:Normalized() * self.curtain_fire_speed,
				-- bProvidesVision		= false
			-- }
			
			-- ProjectileManager:CreateLinearProjectile(linear_projectile)
		-- end)
	-- end
	
	-- -- Reset charges to 0
	-- self:SetCurrentCharges(0)
	-- self.caster:FindModifierByName("modifier_item_imba_rod_of_atos"):SetStackCount(0)
end

-- function item_imba_rod_of_atos:OnProjectileHit(target, location)
	-- if not IsServer() then return end
	
	-- -- Check if a valid target has been hit
	-- if target and not target:IsMagicImmune() then
	
		-- -- This is where we get really jank...again. Try to differentiate between the targetted and the linear projectiles to apply different affects. More difficult on items cause apparently they don't get access to ExtraData.
		
		-- local contactDistance	= (target:GetAbsOrigin() - location):Length2D()
		
		-- -- Arbitrary numerical value based on super rough testing (still might break on super high movement speeds)
		-- local targetted_projectile = (self:GetLevel() == 1 or contactDistance <= 65)
		
		-- -- Assumption: If contact distance is within hull radius, then it's the targetted projectile. Otherwise it's the linear
		-- -- Problem arises if people blink directly onto the projectile in which case it'd be treated like a targetted but eh.....
		-- if targetted_projectile  then
			-- -- Check for Linken's / Lotus Orb
			-- if target:TriggerSpellAbsorb(self) then return nil end
		-- end
		
		-- -- Otherwise, play the sound...
		-- target:EmitSound("DOTA_Item.RodOfAtos.Target")
		
		-- -- IMBAfication: Ankle Breaker
		-- local damageTable = {
			-- victim 			= target,
			-- damage 			= target:GetIdealSpeed(),
			-- damage_type		= DAMAGE_TYPE_PURE,
			-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			-- attacker 		= self.caster,
			-- ability 		= self
		-- }
								
		-- ApplyDamage(damageTable)		
		
		-- if targetted_projectile then
			-- -- ...and apply the Cripple modifier.
			-- local cripple_modifier = target:AddNewModifier(self.caster, self, "modifier_item_imba_rod_of_atos_debuff", {duration = self.duration})
			
			-- if cripple_modifier then
				-- cripple_modifier:SetDuration(self.duration * (1 - target:GetStatusResistance()), true)
			-- end
		-- end
	-- end
-- end

-- ---------------------------------
-- -- ROD OF ATOS DEBUFF MODIFIER --
-- ---------------------------------

-- function modifier_item_imba_rod_of_atos_debuff:GetEffectName()
	-- return "particles/items2_fx/rod_of_atos.vpcf"
-- end

-- function modifier_item_imba_rod_of_atos_debuff:CheckState(keys)
	-- local state = {
	-- [MODIFIER_STATE_ROOTED] = true
	-- }

	-- return state
-- end

-- --------------------------
-- -- ROD OF ATOS MODIFIER --
-- --------------------------

-- function modifier_item_imba_rod_of_atos:IsHidden()		return true end
-- function modifier_item_imba_rod_of_atos:IsPermanent()	return true end
-- function modifier_item_imba_rod_of_atos:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- function modifier_item_imba_rod_of_atos:OnCreated()
	-- self.ability	= self:GetAbility()
	-- self.caster		= self:GetCaster()
	-- self.parent		= self:GetParent()
	
	-- -- AbilitySpecials
	-- self.bonus_intellect	=	self.ability:GetSpecialValueFor("bonus_intellect")
	-- self.bonus_strength		=	self.ability:GetSpecialValueFor("bonus_strength")
	-- self.bonus_agility		=	self.ability:GetSpecialValueFor("bonus_agility")
	-- self.initial_charges		=	self.ability:GetSpecialValueFor("initial_charges")
	
	-- if not IsServer() then return end
	
	-- -- Need to do this instead of using the "ItemInitialCharges" KV because the latter messes with sell prices
	-- if self.ability:GetLevel() >= 2 then
		-- if not self.ability.initialized then
			-- self.ability:SetCurrentCharges(self.initial_charges)
			-- self.ability.initialized = true
		-- end	
	-- end
-- end

-- function modifier_item_imba_rod_of_atos:DeclareFunctions()
    -- local decFuncs = {
		-- MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		-- MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		-- MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    -- }
	
    -- return decFuncs
-- end

-- function modifier_item_imba_rod_of_atos:GetModifierBonusStats_Intellect()
	-- return self.bonus_intellect
-- end

-- function modifier_item_imba_rod_of_atos:GetModifierBonusStats_Strength()
	-- return self.bonus_strength
-- end

-- function modifier_item_imba_rod_of_atos:GetModifierBonusStats_Agility()
	-- return self.bonus_agility
-- end
