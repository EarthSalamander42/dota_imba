-- Creator:
--	   AltiV, February 19th, 2019

LinkLuaModifier("modifier_imba_keeper_of_the_light_illuminate", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_spirit_form_illuminate", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_blinding_light", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_blinding_light_knockback", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_charka_magic", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_will_o_wisp", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_will_o_wisp_aura", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)

imba_keeper_of_the_light_illuminate							= class({})
modifier_imba_keeper_of_the_light_illuminate				= class({})
modifier_imba_keeper_of_the_light_spirit_form_illuminate	= class({})

imba_keeper_of_the_light_illuminate_end						= class({})

imba_keeper_of_the_light_blinding_light						= class({})
modifier_imba_keeper_of_the_light_blinding_light			= class({})
modifier_imba_blinding_light_knockback						= class({})		

imba_keeper_of_the_light_charka_magic						= class({})
modifier_imba_keeper_of_the_light_charka_magic				= class({})

imba_keeper_of_the_light_spotlights							= class({})

imba_keeper_of_the_light_will_o_wisp						= class({})
modifier_imba_keeper_of_the_light_will_o_wisp				= class({})
modifier_imba_keeper_of_the_light_will_o_wisp_aura			= class({})

-- //=================================================================================================================
	-- // Keeper of the Light: Illuminate
	-- //=================================================================================================================
	-- "keeper_of_the_light_illuminate"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"							"5471"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_CHANNELLED"
		-- "AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"	
		-- "SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		-- "FightRecapLevel"				"1"
		-- "AbilitySound"					"Hero_KeeperOfTheLight.Illuminate.Discharge"
		
		-- "HasScepterUpgrade"			"1"

		-- // Casting
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCastRange"				"1800"
		-- "AbilityCastPoint"				"0.3 0.3 0.3 0.3"

		-- // Time		
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCooldown"				"11"
		-- "AbilityChannelTime"			"2.0 3.0 4.0 5.0"

		-- // Cost
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityManaCost"				"150 160 170 180"

		-- // Special
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilitySpecial"
		-- {
			-- "01"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "damage_per_second"		"100.0 100.0 100.0 100.0"
			-- }
			-- "02"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "max_channel_time"		"2.0 3.0 4.0 5.0"
			-- }
			-- "03"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "radius"				"375"
			-- }
			-- "04"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "range"					"1550"
			-- }
			-- "05"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "speed"					"1050.0"
			-- }			
			-- "06"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "vision_radius"			"800 800 800 800"
			-- }
			-- "07"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "vision_duration"		"3.34 3.34 3.34 3.34"
			-- }
			-- "08"
			-- {	
				-- "var_type"				"FIELD_INTEGER"
				-- "channel_vision_radius"	"375"
			-- }
			-- "09"
			-- {	
				-- "var_type"					"FIELD_FLOAT"
				-- "channel_vision_interval"	"0.5"
			-- }
			-- "10"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "channel_vision_duration"	"10.34"
			-- }
			-- "11"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "channel_vision_step"		"150"
			-- }
			-- "12"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "total_damage"				"200 300 400 500"
				-- "LinkedSpecialBonus"		"special_bonus_unique_keeper_of_the_light"
			-- }
		-- }
		-- "AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	-- }

	-- //=================================================================================================================
	-- // Keeper of the Light: Mana Leak
	-- //=================================================================================================================
	-- "keeper_of_the_light_mana_leak"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"							"5472"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		-- "AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		-- "AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		-- "SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		-- "SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		-- "AbilitySound"					"Hero_KeeperOfTheLight.ManaLeak.Cast"

		-- // Casting
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCastPoint"				"0.3 0.3 0.3 0.3"

		-- // Time		
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCooldown"				"16 14 12 10"

		-- // Cost
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityManaCost"				"160"		

		-- // Cast Range
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCastRange"				"400 500 600 700"

		-- // Special
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilitySpecial"
		-- {
			-- "01"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "duration"					"4.0 5.0 6.0 7.0"
			-- }
			-- "02"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "mana_leak_pct"				"5.0"
			-- }
			-- "03"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "stun_duration"				"1.5 2.0 2.5 3.0"
				-- "LinkedSpecialBonus"		"special_bonus_unique_keeper_of_the_light_3"
			-- }
			-- "04"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "cast_range_tooltip"		"400 500 600 700"
			-- }
		-- }
		-- "AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	-- }	

	-- //=================================================================================================================
	-- // Keeper of the Light: Will-O-Wisp
	-- //=================================================================================================================
	-- "keeper_of_the_light_will_o_wisp"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"							"7316"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE"
		-- "AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		-- "AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		-- "SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		-- "SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		-- "AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		-- "AbilitySound"					"Hero_KeeperOfTheLight.ManaLeak.Cast"

		-- // Casting
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCastPoint"				"0.1"

		-- // Time		
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCooldown"				"120"

		-- // Cost
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityManaCost"				"250 350 450"		

		-- // Cast Range
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCastRange"				"900"

		-- // Special
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilitySpecial"
		-- {
			-- "01"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "on_count"					"3 4 5"
				-- "LinkedSpecialBonus"		"special_bonus_unique_keeper_of_the_light_3"
			-- }
			-- "02"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "radius"					"675"
			-- }
			-- "03"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "hit_count"					"4 5 6"
				-- "LinkedSpecialBonus"		"special_bonus_unique_keeper_of_the_light_4"
			-- }
			-- "04"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "off_duration"				"1.85"
			-- }
			-- "05"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "on_duration"				"1.3"
			-- }
			-- "06"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "off_duration_initial"		"1.0"
			-- }
			-- "07"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "fixed_movement_speed"		"25"
			-- }
			-- "08"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "bounty"		"100 125 150"
			-- }
		-- }
		-- "AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	-- }	

	-- //=================================================================================================================
	-- // Keeper of the Light: Chakra Magic
	-- //=================================================================================================================
	-- "keeper_of_the_light_chakra_magic"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"							"5473"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		-- "AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		-- "AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		-- "SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		-- "SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		-- "AbilitySound"					"Hero_KeeperOfTheLight.ChakraMagic.Target"

		-- // Casting
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCastRange"				"900 900 900 900"
		-- "AbilityCastPoint"				"0.3 0.3 0.3 0.3"

		-- // Time		
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCooldown"				"20 18 16 14"

		-- // Cost
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityManaCost"				"0"

		-- // Stats
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityModifierSupportValue"	"3.0"	// Value much higher than cost.


		-- // Special
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilitySpecial"
		-- {
			-- "01"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "mana_restore"			"80 160 240 320"
				-- "LinkedSpecialBonus"	"special_bonus_unique_keeper_of_the_light_2"
			-- }			
			-- "02"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "cooldown_reduction"	"3 4 5 6"
			-- }
		-- }
		-- "AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	-- }

	-- //=================================================================================================================
	-- // Keeper of the Light: Empty 1
	-- //=================================================================================================================
	-- "keeper_of_the_light_empty1"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"							"5501"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE"
		-- "MaxLevel"						"0"
	-- }

	-- //=================================================================================================================
	-- // Keeper of the Light: Empty 2
	-- //=================================================================================================================
	-- "keeper_of_the_light_empty2"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"							"5502"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE"
		-- "MaxLevel"						"0"
	-- }

	-- //=================================================================================================================
	-- // Keeper of the Light: Spirit Form
	-- //=================================================================================================================
	-- "keeper_of_the_light_spirit_form"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"							"5474"							// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		-- "AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		-- "SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		-- "AbilitySound"					"Hero_KeeperOfTheLight.SpiritForm"
 		-- "AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_6"

		-- "HasScepterUpgrade"			"1"

		-- // Time		
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCooldown"				"80.0 70.0 60.0"

		-- // Cost
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityManaCost"				"100 100 100"		

		-- // Stats
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityModifierSupportValue"	"0.35"	// Attacks are primarily about the damage

		-- // Special
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilitySpecial"
		-- {
			-- "01"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "duration"					"40.0 40.0 40.0"
			-- }
		-- }
	-- }

	-- //=================================================================================================================
	-- // Keeper of the Light: Recall
	-- //=================================================================================================================
	-- "keeper_of_the_light_recall"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"							"5475"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_CHANNELLED | DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		-- "AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		-- "AbilityUnitTargetType"			"DOTA_UNIT_TARGET_CUSTOM"
		-- "AbilityUnitTargetFlags"			"DOTA_UNIT_TARGET_FLAG_INVULNERABLE"
		-- "SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		-- "SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		-- "MaxLevel"						"3"
		-- "AbilitySound"					"Hero_KeeperOfTheLight.Recall.Cast"

		-- // Casting
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCastPoint"				"0.3 0.3 0.3"
 		-- "AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		-- // Time		
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCastRange"				"0"
		-- "AbilityCooldown"				"15"

		-- // Cost
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityManaCost"				"100 100 100"

		-- // Special
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilitySpecial"
		-- {
			-- "01"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "teleport_delay"		"5.0 4.0 3.0"
			-- }
		-- }
	-- }

	-- //=================================================================================================================
	-- // Keeper of the Light: Blinding Light
	-- //=================================================================================================================
	-- "keeper_of_the_light_blinding_light"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"							"5476"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_POINT"
		-- "SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		-- "SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		-- "AbilitySound"					"Hero_KeeperOfTheLight.BlindingLight"

		-- // Casting
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCastRange"				"550 600 650 700"
		-- "AbilityCastPoint"				"0.3 0.3 0.3 0.3"
 		-- "AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_5"

		-- // Time		
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCooldown"				"30 25 20 15"

		-- // Cost
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityManaCost"				"100 125 150 175"

		-- // Stats
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityModifierSupportValue"	"1.0"

		-- // Special
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilitySpecial"
		-- {
			-- "01"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "miss_rate"				"70"
			-- }
			-- "02"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "duration"				"3 4 5 6"
			-- }
			-- "03"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "radius"				"600"
			-- }
			-- "05"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "knockback_duration"	"0.4"
			-- }
			-- "06"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "knockback_distance"	"350"
			-- }
			-- "07"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "damage"				"50 100 150 200"
			-- }
			-- "08"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "cast_range_tooltip"	"550 600 650 700"
			-- }
		-- }
	-- }

	-- //=================================================================================================================
	-- // Keeper of the Light: Illuminate End
	-- //=================================================================================================================
	-- "keeper_of_the_light_illuminate_end"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"							"5477"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK"

		-- // Casting
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCastPoint"				"0.0 0.0 0.0 0.0"
 		-- "AbilityCastAnimation"			"ACT_INVALID"
	-- }

	-- //=================================================================================================================
	-- // Keeper of the Light: Spirit Form Illuminate
	-- //=================================================================================================================
	-- "keeper_of_the_light_spirit_form_illuminate"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"							"5479"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		-- "AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"	
		-- "SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		-- "FightRecapLevel"				"1"

		-- "HasScepterUpgrade"			"1"

		-- // Casting
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCastRange"				"1800"
		-- "AbilityCastPoint"				"0.3 0.3 0.3 0.3"
 		-- "AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_7"

		-- // Time		
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCooldown"				"10.0 10.0 10.0 10.0"

		-- // Cost
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityManaCost"				"150 160 170 180"

		-- // Special
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilitySpecial"
		-- {
			-- "01"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "damage_per_second"		"100.0 100.0 100.0 100.0"
			-- }
			-- "02"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "max_channel_time"		"2.0 3.0 4.0 5.0"
			-- }
			-- "03"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "radius"				"375"
			-- }
			-- "04"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "range"					"1550"
			-- }
			-- "05"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "speed"					"1050.0"
			-- }			
			-- "06"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "vision_radius"			"800 800 800 800"
			-- }
			-- "07"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "vision_duration"		"3.34 3.34 3.34 3.34"
			-- }
			-- "08"
			-- {	
				-- "var_type"				"FIELD_INTEGER"
				-- "channel_vision_radius"	"375"
			-- }
			-- "09"
			-- {	
				-- "var_type"					"FIELD_FLOAT"
				-- "channel_vision_interval"	"0.5"
			-- }
			-- "10"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "channel_vision_duration"	"10.34"
			-- }
			-- "11"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "channel_vision_step"		"150"
			-- }
			-- "12"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "total_damage"				"200 300 400 500"
				-- "LinkedSpecialBonus"		"special_bonus_unique_keeper_of_the_light"
			-- }
		-- }
	-- }

	-- //=================================================================================================================
	-- // Keeper of the Light: Spirit Form Illuminate End
	-- //=================================================================================================================
	-- "keeper_of_the_light_spirit_form_illuminate_end"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"							"5503"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK"

		-- // Casting
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCastPoint"				"0.0 0.0 0.0 0.0"
 		-- "AbilityCastAnimation"			"ACT_INVALID"
	-- }

-----------------------
-- Viscous Nasal Goo --
-----------------------

function imba_bristleback_viscous_nasal_goo:GetIntrinsicModifierName()
	return "modifier_imba_bristleback_viscous_nasal_goo_autocaster"
end

function imba_bristleback_viscous_nasal_goo:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	else
		return self.BaseClass.GetBehavior(self)
	end
end

function imba_bristleback_viscous_nasal_goo:OnSpellStart()
	self.caster	= self:GetCaster()
	
	-- AbilitySpecials
	self.goo_speed					= self:GetSpecialValueFor("goo_speed")
	self.goo_duration				= self:GetSpecialValueFor("goo_duration")
	self.base_armor					= self:GetSpecialValueFor("base_armor")
	self.armor_per_stack			= self:GetSpecialValueFor("armor_per_stack")
	self.base_move_slow				= self:GetSpecialValueFor("base_move_slow")
	self.move_slow_per_stack		= self:GetSpecialValueFor("move_slow_per_stack")
	--self.stack_limit 				= self:GetSpecialValueFor("stack_limit")
	self.goo_duration_creep			= self:GetSpecialValueFor("goo_duration_creep")
	self.radius_scepter 			= self:GetSpecialValueFor("radius_scepter")
	
	self.disgust_knockback 			= self:GetSpecialValueFor("disgust_knockback")
	self.disgust_knockup 			= self:GetSpecialValueFor("disgust_knockup")
	self.base_disgust_duration 		= self:GetSpecialValueFor("base_disgust_duration")
	self.disgust_duration_per_stack	= self:GetSpecialValueFor("disgust_duration_per_stack")
	
	if not IsServer() then return end
	
	self.caster:EmitSound("Hero_Bristleback.ViscousGoo.Cast")
	
	if self.caster:HasScepter() then
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.radius_scepter, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		
		for _, enemy in pairs(enemies) do
			local projectile =
			{
				Target 				= enemy,
				Source 				= self.caster,
				Ability 			= self,
				EffectName 			= "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf",
				iMoveSpeed 			= self.goo_speed,
				vSourceLoc			= self.caster:GetAbsOrigin(),
				bDrawsOnMinimap		= false,
				bDodgeable			= true,
				bIsAttack 			= false,
				bVisibleToEnemies	= true,
				bReplaceExisting 	= false,
				flExpireTime 		= GameRules:GetGameTime() + 10,
				bProvidesVision 	= false,
				iVisionRadius 		= 0,
				iVisionTeamNumber 	= self.caster:GetTeamNumber()
			}
			
			ProjectileManager:CreateTrackingProjectile(projectile)
		end
	else
		self.target	= self:GetCursorTarget()
	
		-- Stop if target has linkens
		if self.target:TriggerSpellAbsorb(self) then return end
	
		local projectile =
		{
			Target 				= self.target,
			Source 				= self.caster,
			Ability 			= self,
			EffectName 			= "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf",
			iMoveSpeed 			= self.goo_speed,
			vSourceLoc			= self.caster:GetAbsOrigin(),
			bDrawsOnMinimap		= false,
			bDodgeable			= true,
			bIsAttack 			= false,
			bVisibleToEnemies	= true,
			bReplaceExisting 	= false,
			flExpireTime 		= GameRules:GetGameTime() + 10,
			bProvidesVision 	= false,
			iVisionRadius 		= 0,
			iVisionTeamNumber 	= self.caster:GetTeamNumber()
		}
		
		ProjectileManager:CreateTrackingProjectile(projectile)
	end
		
	if self.caster:GetName() == "npc_dota_hero_bristleback" and RollPercentage(40) then
		self.caster:EmitSound("bristleback_bristle_nasal_goo_0"..math.random(1,7))
	end
end

function imba_bristleback_viscous_nasal_goo:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil and hTarget:IsAlive() and not hTarget:IsMagicImmune() then
		local goo_modifier = hTarget:AddNewModifier(self.caster, self, "modifier_imba_bristleback_viscous_nasal_goo", {duration = self.goo_duration})
		
		hTarget:EmitSound("Hero_Bristleback.ViscousGoo.Target")
		
		-- IMBAfication: Disgust
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, self.radius_scepter, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
		for	_, enemy in pairs(enemies) do
			if enemy ~= hTarget then
				local knockback = {
					should_stun 		= 0,
					knockback_distance 	= self.disgust_knockback * goo_modifier:GetStackCount(), 
					knockback_height 	= self.disgust_knockup * goo_modifier:GetStackCount(),
					center_x			= hTarget:GetAbsOrigin().x,
					center_y			= hTarget:GetAbsOrigin().y,
					center_z			= hTarget:GetAbsOrigin().z,
					knockback_duration	= self.base_disgust_duration + (self.disgust_duration_per_stack * goo_modifier:GetStackCount()) -- This doesn't work or something?
				}

				enemy:AddNewModifier(self.caster, self, "modifier_knockback", knockback):SetDuration(self.base_disgust_duration + (self.disgust_duration_per_stack * goo_modifier:GetStackCount()), true)
			end
		end
	end
end

--------------------------------
-- VISCOUS NASAL GOO MODIFIER --
--------------------------------

function modifier_imba_bristleback_viscous_nasal_goo:GetEffectName()
	return "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf"
end

-- IDK which status effect it uses for this one and I can't find it so might just leave it, cause it's not this one...
function modifier_imba_bristleback_viscous_nasal_goo:GetStatusEffectName()
	return "particles/status_fx/status_effect_goo.vpcf"
end

function modifier_imba_bristleback_viscous_nasal_goo:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.goo_speed				= self.ability:GetSpecialValueFor("goo_speed")
	self.goo_duration			= self.ability:GetSpecialValueFor("goo_duration")
	self.base_armor				= self.ability:GetSpecialValueFor("base_armor")
	self.armor_per_stack		= self.ability:GetSpecialValueFor("armor_per_stack")
	self.base_move_slow			= self.ability:GetSpecialValueFor("base_move_slow")
	self.move_slow_per_stack	= self.ability:GetSpecialValueFor("move_slow_per_stack")
	self.stack_limit 			= self.ability:GetSpecialValueFor("stack_limit") + self.caster:FindTalentValue("special_bonus_unique_bristleback")
	self.goo_duration_creep		= self.ability:GetSpecialValueFor("goo_duration_creep")
	self.radius_scepter 		= self.ability:GetSpecialValueFor("radius_scepter")

	if not IsServer() then return end

	self:SetStackCount(1)
	
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))
	self:AddParticle(self.particle, false, false, -1, false, false)
	
end

function modifier_imba_bristleback_viscous_nasal_goo:OnRefresh()
	if not IsServer() then return end

	if self:GetStackCount() < self.stack_limit then
		self:IncrementStackCount()
		ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))
	end
	
	-- Custom Status Resist nonsense (need to learn how to make an all-encompassing function for this...)
	self:SetDuration(self.goo_duration * (1 - self.parent:GetStatusResistance()), true)
end

function modifier_imba_bristleback_viscous_nasal_goo:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }

    return decFuncs
end

function modifier_imba_bristleback_viscous_nasal_goo:GetModifierMoveSpeedBonus_Percentage()
    return ((self.base_move_slow + (self.move_slow_per_stack * self:GetStackCount())) * (-1))
end

function modifier_imba_bristleback_viscous_nasal_goo:GetModifierPhysicalArmorBonus()
    return ((self.base_armor + (self.armor_per_stack * self:GetStackCount())) * (-1))
end

-------------------------------------------
-- VISCOUS NASAL GOO AUTOCASTER MODIFIER --
-------------------------------------------

function modifier_imba_bristleback_viscous_nasal_goo_autocaster:IsHidden()	return true end

function modifier_imba_bristleback_viscous_nasal_goo_autocaster:OnCreated()
	if not IsServer() then return end

	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()

	self:StartIntervalThink(0.1)
end

function modifier_imba_bristleback_viscous_nasal_goo_autocaster:OnRefresh()
	if not IsServer() then return end

	self:StartIntervalThink(-1)

	self:OnCreated()
end

function modifier_imba_bristleback_viscous_nasal_goo_autocaster:OnIntervalThink()
	if not IsServer() then return end

	if self.ability:GetAutoCastState() and self.ability:IsFullyCastable() and not self.ability:IsInAbilityPhase() then
		if self.caster:HasScepter() then
			self.caster:CastAbilityNoTarget(self.ability, self.caster:GetPlayerID())
		else
			local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.ability:GetCastRange(self.caster:GetAbsOrigin(), self.caster), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
			
			if #enemies > 0 then
				self.caster:CastAbilityOnTarget(enemies[1], self.ability, self.caster:GetPlayerID())
			end
		end

		Timers:CreateTimer(self.ability:GetBackswingTime(), function()
			-- This is just to prevent Bristleback from bricking up in super low CD situations, but he won't target people after cast then
			if not self.ability:IsNull() and self.ability:GetCooldownTimeRemaining() > self.ability:GetBackswingTime() then
				self.caster:MoveToPositionAggressive(self.caster:GetAbsOrigin())
			end
		end)
	end
end

-----------------
-- Quill Spray --
-----------------

function imba_bristleback_quill_spray:GetIntrinsicModifierName()
	return "modifier_imba_bristleback_quill_spray_autocaster"
end

function imba_bristleback_quill_spray:OnSpellStart()
	self.caster	= self:GetCaster()
	
	-- AbilitySpecials
	self.radius					= self:GetSpecialValueFor("radius") -- Note that the particle doesn't seem to support proper radius change so be warned...
	-- self.quill_base_damage		= self:GetSpecialValueFor("quill_base_damage")
	-- self.quill_stack_damage		= self:GetSpecialValueFor("quill_stack_damage")
	-- self.quill_stack_duration	= self:GetSpecialValueFor("quill_stack_duration")
	-- self.max_damage				= self:GetSpecialValueFor("max_damage")
	self.projectile_speed		= self:GetSpecialValueFor("projectile_speed")
	
	-- Calculate amount of time quills should "exist" based on speed and radius
	self.duration				= self.radius / self.projectile_speed
	
	if not IsServer() then return end
	
	CreateModifierThinker(self.caster, self, "modifier_imba_bristleback_quillspray_thinker", {duration = self.duration}, self.caster:GetAbsOrigin(), self.caster:GetTeamNumber(), false)
	
	self.caster:EmitSound("Hero_Bristleback.QuillSpray.Cast")
end 

-------------------------
-- QUILL SPRAY THINKER --
-------------------------

function modifier_imba_bristleback_quillspray_thinker:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.radius					= self.ability:GetSpecialValueFor("radius")
	self.quill_base_damage		= self.ability:GetSpecialValueFor("quill_base_damage")
	self.quill_stack_damage		= self.ability:GetSpecialValueFor("quill_stack_damage") + self.caster:FindTalentValue("special_bonus_unique_bristleback_2")
	self.quill_stack_duration	= self.ability:GetSpecialValueFor("quill_stack_duration")
	self.max_damage				= self.ability:GetSpecialValueFor("max_damage")
	-- self.projectile_speed		= self.ability:GetSpecialValueFor("projectile_speed")
	
	if not IsServer() then return end
	
	-- CP60 for colour, CP61 Vector(1, 0, 0) to activate it
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf", PATTACH_ABSORIGIN, self.parent)
	-- For the hell of it
	ParticleManager:SetParticleControl(self.particle, 60, Vector(RandomInt(0, 255), RandomInt(0, 255), RandomInt(0, 255)))
	ParticleManager:SetParticleControl(self.particle, 61, Vector(1, 0, 0))
	self:AddParticle(self.particle, false, false, -1, false, false)
	
	-- Establish table to populate hit enemies with (so they only get hit once per quill spray)
	self.hit_enemies = {}
	
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_bristleback_quillspray_thinker:OnIntervalThink()
	if not IsServer() then return end

	-- From 0 to 1 to track how far the quills have spread and the damage radius
	local radius_pct = math.min((self:GetDuration() - self:GetRemainingTime()) / self:GetDuration(), 1)
	
	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius * radius_pct, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	
	for _, enemy in pairs(enemies) do
	
		local hit_already = false
	
		for _, hit_enemy in pairs(self.hit_enemies) do
			if hit_enemy == enemy then
				hit_already = true
				break
			end
		end

		if not hit_already then
			local quill_spray_stacks 	= 0
			local quill_spray_modifier	= enemy:FindModifierByName("modifier_imba_bristleback_quill_spray")
			
			if quill_spray_modifier then
				quill_spray_stacks		= quill_spray_modifier:GetStackCount()
			end
		
			local damageTable = {
				victim 			= enemy,
				damage 			= math.min(self.quill_base_damage + (self.quill_stack_damage * quill_spray_stacks), self.max_damage),
				damage_type		= DAMAGE_TYPE_PHYSICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self.caster,
				ability 		= self.ability
			}
									
			ApplyDamage(damageTable)
			
			-- Blood particle is smaller than vanilla...but IDK how much people care about this
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(particle, 1, enemy:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle)
			
			enemy:EmitSound("Hero_Bristleback.QuillSpray.Target")
			
			enemy:AddNewModifier(self.caster, self.ability, "modifier_imba_bristleback_quill_spray", {duration = self.quill_stack_duration})
			
			table.insert(self.hit_enemies, enemy)
			
			if not enemy:IsAlive() and enemy:IsRealHero() and (enemy.IsReincarnating and not enemy:IsReincarnating()) then
				self.caster:EmitSound("bristleback_bristle_quill_spray_0"..math.random(1,6))
			end
		end
	end
end

-- IDK if I really need this but I'm hearing potential horror stories
function modifier_imba_bristleback_quillspray_thinker:OnDestroy()
	if not IsServer() then return end

	self.parent:RemoveSelf()
end

--------------------------
-- QUILL SPRAY MODIFIER --
--------------------------

function modifier_imba_bristleback_quill_spray:IsPurgable()	return false end

function modifier_imba_bristleback_quill_spray:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.radius					= self.ability:GetSpecialValueFor("radius")
	self.quill_base_damage		= self.ability:GetSpecialValueFor("quill_base_damage")
	self.quill_stack_damage		= self.ability:GetSpecialValueFor("quill_stack_damage")
	self.quill_stack_duration	= self.ability:GetSpecialValueFor("quill_stack_duration")
	self.max_damage				= self.ability:GetSpecialValueFor("max_damage")
	self.projectile_speed		= self.ability:GetSpecialValueFor("projectile_speed")

	self:IncrementStackCount()
	
	if not IsServer() then return end
	
	-- Why does the normal particle emit so many quills
	--if self:GetParent():IsCreep() then
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray_hit_creep.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	--else
	--	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	--end

	ParticleManager:SetParticleControlEnt(self.particle, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	self:AddParticle(self.particle, false, false, -1, false, false)
	
	-- Stacks don't get refreshed with subsequent stacks
	Timers:CreateTimer(self.quill_stack_duration * (1 - self.parent:GetStatusResistance()), function()
		-- Really don't want errors here...
		if self ~= nil and not self:IsNull() and not self.ability:IsNull() and not self.parent:IsNull() and not self.caster:IsNull() then
			self:DecrementStackCount()
		end
	end)
end

function modifier_imba_bristleback_quill_spray:OnRefresh()
	if not IsServer() then return end

	self:OnCreated()
	
	-- Custom Status Resist nonsense (need to learn how to make an all-encompassing function for this...)
	self:SetDuration(self.quill_stack_duration * (1 - self.parent:GetStatusResistance()), true)
end

--------------------------------
-- QUILL SPRAY STACK MODIFIER --
--------------------------------

-- IDK why this thing uses two modifiers for vanilla seems like just one can handle it

-------------------------------------
-- QUILL SPRAY AUTOCASTER MODIFIER --
-------------------------------------

function modifier_imba_bristleback_quill_spray_autocaster:IsHidden()	return true end

function modifier_imba_bristleback_quill_spray_autocaster:OnCreated()
	if not IsServer() then return end

	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	self.cardio_threshold	= self.ability:GetSpecialValueFor("cardio_threshold")
	self.last_position		= self.caster:GetAbsOrigin()
	self.distance			= self.distance or 0

	self:StartIntervalThink(0.1) -- Could make this every frame but that might be too much of a crutch lul
end

function modifier_imba_bristleback_quill_spray_autocaster:OnRefresh()
	if not IsServer() then return end

	self:StartIntervalThink(-1)

	self:OnCreated()
end

function modifier_imba_bristleback_quill_spray_autocaster:OnIntervalThink()
	if not IsServer() then return end

	if self.ability:GetAutoCastState() and self.ability:IsFullyCastable() then
		self.caster:CastAbilityImmediately(self.ability, self.caster:GetPlayerID())
	end
	
	-- IMBAfication: Cardio
	self.distance			= self.distance + (self.caster:GetAbsOrigin() - self.last_position):Length()
	self.last_position		= self.caster:GetAbsOrigin()
	
	if self.distance >= self.cardio_threshold then
		self.ability:OnSpellStart()
		self.distance = 0
	end
end

-----------------
-- Bristleback --
-----------------

function imba_bristleback_bristleback:ResetToggleOnRespawn()	return true end

function imba_bristleback_bristleback:GetIntrinsicModifierName()
	return "modifier_imba_bristleback_bristleback"
end

-- IMBAfication: Heavy Arms Shell
function imba_bristleback_bristleback:OnToggle()
	self.caster	= self:GetCaster()

	if self:GetToggleState() then
		self.caster:AddNewModifier(self.caster, self, "modifier_imba_bristleback_bristleback_has", {})
	else
		self.caster:RemoveModifierByName("modifier_imba_bristleback_bristleback_has")
	end
end

--------------------------
-- BRISTLEBACK MODIFIER --
--------------------------

function modifier_imba_bristleback_bristleback:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.front_damage_reduction		= 0
	self.side_damage_reduction		= self.ability:GetSpecialValueFor("side_damage_reduction")
	self.back_damage_reduction		= self.ability:GetSpecialValueFor("back_damage_reduction")
	self.side_angle					= self.ability:GetSpecialValueFor("side_angle")
	self.back_angle					= self.ability:GetSpecialValueFor("back_angle")
	self.quill_release_threshold	= self.ability:GetSpecialValueFor("quill_release_threshold")
	
	self.cumulative_damage			= self.cumulative_damage or 0
end

function modifier_imba_bristleback_bristleback:OnRefresh()
	self:OnCreated()
end

function modifier_imba_bristleback_bristleback:DeclareFunctions()
    local decFuncs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return decFuncs
end

function modifier_imba_bristleback_bristleback:GetModifierIncomingDamage_Percentage(keys)
	if self.parent:PassivesDisabled() then return 0 end

	local forwardVector			= self.caster:GetForwardVector()
	local forwardAngle			= math.deg(math.atan2(forwardVector.x, forwardVector.y))
			
	local reverseEnemyVector	= (self.caster:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Normalized()
	local reverseEnemyAngle		= math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

	local difference = math.abs(forwardAngle - reverseEnemyAngle)

	--print(difference)
	
	-- Check for Heavy Arms Shell modifier
	if self.caster:HasModifier("modifier_imba_bristleback_bristleback_has") then
		self.front_damage_reduction		= self.ability:GetSpecialValueFor("HAS_damage_reduction_inc")
		self.side_damage_reduction		= self.ability:GetSpecialValueFor("side_damage_reduction") + self.ability:GetSpecialValueFor("HAS_damage_reduction_inc")
		self.back_damage_reduction		= self.ability:GetSpecialValueFor("back_damage_reduction") + self.ability:GetSpecialValueFor("HAS_damage_reduction_inc")
		self.quill_release_threshold	= self.ability:GetSpecialValueFor("HAS_quill_release_threshold")
	else
		self.front_damage_reduction		= 0
		self.side_damage_reduction		= self.ability:GetSpecialValueFor("side_damage_reduction")
		self.back_damage_reduction		= self.ability:GetSpecialValueFor("back_damage_reduction")
		self.quill_release_threshold	= self.ability:GetSpecialValueFor("quill_release_threshold")
	end
	
	-- There's 100% a more straightforward way to calculate this but I can't think properly right now
	if (difference <= (self.back_angle / 2)) or (difference >= (360 - (self.back_angle / 2))) then
		--print("Hit the back ", (self.back_damage_reduction), "%")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle)
	
		local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_lrg_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(particle2, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle2)
		
		self.parent:EmitSound("Hero_Bristleback.Bristleback")
		
		return self.back_damage_reduction * (-1)
	elseif (difference <= (self.side_angle / 2)) or (difference >= (360 - (self.side_angle / 2))) then 
		--print("Hit the side", (self.side_damage_reduction), "%")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle)
		
		return self.side_damage_reduction * (-1)
	else
		--print("Hit the front")
		return self.front_damage_reduction * (-1)
	end
end

function modifier_imba_bristleback_bristleback:OnTakeDamage( keys )
	if keys.unit == self.parent then
		if self.parent:PassivesDisabled() or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
	
		-- Pretty inefficient to calculate this stuff twice but I don't want to make these class variables due to how much damage might stack in a single frame...
		local forwardVector			= self.caster:GetForwardVector()
		local forwardAngle			= math.deg(math.atan2(forwardVector.x, forwardVector.y))
				
		local reverseEnemyVector	= (self.caster:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Normalized()
		local reverseEnemyAngle		= math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

		local difference = math.abs(forwardAngle - reverseEnemyAngle)

		if (difference <= (self.back_angle / 2)) or (difference >= (360 - (self.back_angle / 2))) then
			self:SetStackCount(self:GetStackCount() + keys.damage)
			
			local quill_spray_ability = self.parent:FindAbilityByName("imba_bristleback_quill_spray")
			
			if quill_spray_ability and quill_spray_ability:IsTrained() and self:GetStackCount() >= self.quill_release_threshold then
				quill_spray_ability:OnSpellStart()
				-- IMBAfication: Overflow Harnessing
				self:SetStackCount(self:GetStackCount() - self.quill_release_threshold)
			end
		end
	end
end

-------------------------------------------
-- BRISTLEBACK HEAVY ARMS SHELL MODIFIER --
-------------------------------------------

function modifier_imba_bristleback_bristleback_has:IsPurgable() return false end

function modifier_imba_bristleback_bristleback_has:OnCreated()
	self.parent	= self:GetParent()
	
	if not IsServer() then return end

	self.particle = ParticleManager:CreateParticle("particles/econ/items/pangolier/pangolier_ti8_immortal/pangolier_ti8_immortal_shield_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle, 1, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle, 3, Vector(50, 0, 0))
	self:AddParticle(self.particle, false, false, -1, false, false)
	
	self.parent:EmitSound("Imba.BristlebackHASStart")
end

function modifier_imba_bristleback_bristleback_has:CheckState(keys)
	local state = {
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_DISARMED] = true
	}

	return state
end

-------------
-- Warpath --
-------------

function imba_bristleback_warpath:GetIntrinsicModifierName()
	return "modifier_imba_bristleback_warpath"
end

----------------------
-- WARPATH MODIFIER --
----------------------

function modifier_imba_bristleback_warpath:IsHidden()
	if self:GetStackCount() >= 1 then 
		return false
	else
		return true
	end
end

function modifier_imba_bristleback_warpath:DestroyOnExpire() return false end

function modifier_imba_bristleback_warpath:GetEffectName()
	if self:GetStackCount() >= 1 then 
		return "particles/units/heroes/hero_bristleback/bristleback_warpath_dust.vpcf"
	end
end

function modifier_imba_bristleback_warpath:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.damage_per_stack		= self.ability:GetSpecialValueFor("damage_per_stack") + self.caster:FindTalentValue("special_bonus_imba_bristleback_3")
	self.move_speed_per_stack	= self.ability:GetSpecialValueFor("move_speed_per_stack")
	self.stack_duration			= self.ability:GetSpecialValueFor("stack_duration")
	self.max_stacks				= self.ability:GetSpecialValueFor("max_stacks")
	
	self.counter				= self.counter or 0
	self.particle_table			= self.particle_table or {}
end

function modifier_imba_bristleback_warpath:OnRefresh()
	self:OnCreated()
end

function modifier_imba_bristleback_warpath:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_MODEL_SCALE,
		-- IMBAfication: I Swear On Me Mum
		MODIFIER_EVENT_ON_HERO_KILLED
    }

    return decFuncs
end

function modifier_imba_bristleback_warpath:GetModifierPreAttack_BonusDamage(keys)
	if not self.parent:IsIllusion() then
		-- Need to call this somewhere other than OnCreated since it can be boosted by talent
		self.damage_per_stack		= self.ability:GetSpecialValueFor("damage_per_stack") + self.caster:FindTalentValue("special_bonus_imba_bristleback_3")
		
		return self.damage_per_stack * self:GetStackCount()
	end
end

function modifier_imba_bristleback_warpath:GetModifierMoveSpeedBonus_Percentage(keys)
	return self.move_speed_per_stack * self:GetStackCount()
end

-- Gonna ignore the mechanic that updates stacks for illusions too for now
function modifier_imba_bristleback_warpath:OnAbilityFullyCast(keys)
	if keys.ability and keys.unit == self.parent and not self.parent:PassivesDisabled() and not keys.ability:IsItem() then
		
		-- Keep a separate variable for "virtual" stacks so as to proper handle refreshing and decrementing when going past standard max stacks
		self.counter = self.counter + 1
		
		self:SetStackCount(math.min(self.counter, self.max_stacks))
		
		if self:GetStackCount() < self.max_stacks then
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_warpath.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControlEnt(particle, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 4, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
			table.insert(self.particle_table, particle)
		end
		
		self:SetDuration(self.stack_duration, true)
		
		-- Stacks don't get refreshed with subsequent stacks
		Timers:CreateTimer(self.stack_duration, function()
			if self ~= nil and not self:IsNull() and not self.ability:IsNull() and not self.parent:IsNull() and not self.caster:IsNull() and self:GetStackCount() > 0 then
				self.counter = self.counter - 1
				
				self:SetStackCount(math.min(self.counter, self.max_stacks))

				if #self.particle_table > 0 then
					ParticleManager:DestroyParticle(self.particle_table[1], false)
					ParticleManager:ReleaseParticleIndex(self.particle_table[1])
					table.remove(self.particle_table, 1)
				end
			end
		end)
	end
end

function modifier_imba_bristleback_warpath:GetModifierModelScale()
	return self:GetStackCount() * 5
end

function modifier_imba_bristleback_warpath:OnHeroKilled(keys)
	if keys.target == self.caster and keys.attacker ~= self.caster then
		keys.attacker:AddNewModifier(self.caster, self.ability, "modifier_imba_bristleback_warpath_revenge", {})
	end
end

----------------------------
-- WARPATH STACK MODIFIER --
----------------------------

-- Nothing to see here...

------------------------------
-- WARPATH REVENGE MODIFIER --
------------------------------

function modifier_imba_bristleback_warpath_revenge:IsPurgable()		return false end
function modifier_imba_bristleback_warpath_revenge:RemoveOnDeath()	return false end

function modifier_imba_bristleback_warpath_revenge:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.revenge_inc_dmg_pct	= self.ability:GetSpecialValueFor("revenge_inc_dmg_pct")
end

function modifier_imba_bristleback_warpath_revenge:OnRefresh()	
	self:SetStackCount(self:GetStackCount() + self.revenge_inc_dmg_pct)
end

function modifier_imba_bristleback_warpath_revenge:DeclareFunctions()
    local decFuncs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_TOOLTIP
    }

    return decFuncs
end

function modifier_imba_bristleback_warpath_revenge:GetModifierIncomingDamage_Percentage(keys)
	if keys.target == self.parent then
		if keys.attacker == self.caster then
			return self:GetStackCount()
		else
			return 0
		end
	end
end

function modifier_imba_bristleback_warpath_revenge:OnDeath(keys)
	if keys.unit == self.parent and keys.attacker == self.caster then
		self:Destroy()
	end
end

function modifier_imba_bristleback_warpath_revenge:OnTooltip()
	return self:GetStackCount()
end

---------------------
-- TALENT HANDLERS --
---------------------

-- Gonna leave everything here vanilla for now cause his talents seem really strong as is and I don't want to destroy the balance and thematics for now

-- # Talents
-- * Level 10: +3 Mana Regen | +20 Movement Speed
-- * Level 15: +6 Max Goo Stacks | +250 Health
-- * Level 20: +25 Quill Stack Damage | +25 Health Regen
-- * Level 25: +30 Warpath Damage Per Stack | 15% Spell Lifesteal

-- Client-side helper functions --

-- LinkLuaModifier("modifier_special_bonus_imba_bristleback_1", "components/abilities/heroes/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_special_bonus_imba_bristleback_2", "components/abilities/heroes/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
 LinkLuaModifier("modifier_special_bonus_imba_bristleback_3", "components/abilities/heroes/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_special_bonus_imba_bristleback_4", "components/abilities/heroes/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_special_bonus_imba_bristleback_5", "components/abilities/heroes/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_special_bonus_imba_bristleback_6", "components/abilities/heroes/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_special_bonus_imba_bristleback_7", "components/abilities/heroes/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_special_bonus_imba_bristleback_8", "components/abilities/heroes/hero_bristleback", LUA_MODIFIER_MOTION_NONE)

-- modifier_special_bonus_imba_bristleback_1		= class({})
-- modifier_special_bonus_imba_bristleback_2		= class({})
 modifier_special_bonus_imba_bristleback_3		= class({})
-- modifier_special_bonus_imba_bristleback_4		= class({})
-- modifier_special_bonus_imba_bristleback_5		= class({})
-- modifier_special_bonus_imba_bristleback_6		= class({})
-- modifier_special_bonus_imba_bristleback_7		= class({})
-- modifier_special_bonus_imba_bristleback_8		= class({})

-- -----------------------
-- -- TALENT 1 MODIFIER --
-- -----------------------
-- function modifier_special_bonus_imba_bristleback_1:IsHidden() 			return true end
-- function modifier_special_bonus_imba_bristleback_1:IsPurgable() 		return false end
-- function modifier_special_bonus_imba_bristleback_1:RemoveOnDeath() 		return false end

-- -----------------------
-- -- TALENT 2 MODIFIER --
-- -----------------------
-- function modifier_special_bonus_imba_bristleback_2:IsHidden() 			return true end
-- function modifier_special_bonus_imba_bristleback_2:IsPurgable() 		return false end
-- function modifier_special_bonus_imba_bristleback_2:RemoveOnDeath() 		return false end

-- -----------------------
-- -- TALENT 3 MODIFIER --
-- -----------------------
-- +30 Warpath Damage Per Stack
function modifier_special_bonus_imba_bristleback_3:IsHidden() 			return true end
function modifier_special_bonus_imba_bristleback_3:IsPurgable() 		return false end
function modifier_special_bonus_imba_bristleback_3:RemoveOnDeath() 		return false end

-- -----------------------
-- -- TALENT 4 MODIFIER --
-- -----------------------
-- function modifier_special_bonus_imba_bristleback_4:IsHidden() 			return true end
-- function modifier_special_bonus_imba_bristleback_4:IsPurgable() 		return false end
-- function modifier_special_bonus_imba_bristleback_4:RemoveOnDeath() 		return false end

-- -----------------------
-- -- TALENT 5 MODIFIER --
-- -----------------------
-- function modifier_special_bonus_imba_bristleback_5:IsHidden() 			return true end
-- function modifier_special_bonus_imba_bristleback_5:IsPurgable() 		return false end
-- function modifier_special_bonus_imba_bristleback_5:RemoveOnDeath() 		return false end

-- -----------------------
-- -- TALENT 6 MODIFIER --
-- -----------------------
-- function modifier_special_bonus_imba_bristleback_6:IsHidden() 			return true end
-- function modifier_special_bonus_imba_bristleback_6:IsPurgable() 		return false end
-- function modifier_special_bonus_imba_bristleback_6:RemoveOnDeath() 		return false end

-- -----------------------
-- -- TALENT 7 MODIFIER --
-- -----------------------
-- function modifier_special_bonus_imba_bristleback_7:IsHidden() 			return true end
-- function modifier_special_bonus_imba_bristleback_7:IsPurgable() 		return false end
-- function modifier_special_bonus_imba_bristleback_7:RemoveOnDeath() 		return false end

-- -----------------------
-- -- TALENT 8 MODIFIER --
-- -----------------------
-- function modifier_special_bonus_imba_bristleback_8:IsHidden() 			return true end
-- function modifier_special_bonus_imba_bristleback_8:IsPurgable() 		return false end
-- function modifier_special_bonus_imba_bristleback_8:RemoveOnDeath() 		return false end

function imba_bristleback_warpath:OnOwnerSpawned()
	if self:GetCaster():HasTalent("modifier_special_bonus_imba_bristleback_3") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_bristleback_3") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_bristleback_3"), "modifier_special_bonus_imba_bristleback_3", {})
	end
end
