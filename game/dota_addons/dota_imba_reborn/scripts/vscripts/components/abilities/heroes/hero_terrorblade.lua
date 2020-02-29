-- Creator:
--	   AltiV, January 7th, 2020

LinkLuaModifier("modifier_imba_terrorblade_reflection_slow", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_terrorblade_reflection_unit", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_terrorblade_metamorphosis_transform", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_terrorblade_metamorphosis", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_terrorblade_metamorphosis_transform_aura", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_terrorblade_metamorphosis_transform_aura_applier", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)

imba_terrorblade_reflection					= imba_terrorblade_reflection or class({})
modifier_imba_terrorblade_reflection_slow	= modifier_imba_terrorblade_reflection_slow or class({})
modifier_imba_terrorblade_reflection_unit	= modifier_imba_terrorblade_reflection_unit or class({})

imba_terrorblade_conjure_image				= imba_terrorblade_conjure_image or class({})

imba_terrorblade_metamorphosis									= imba_terrorblade_metamorphosis or class({})
modifier_imba_terrorblade_metamorphosis_transform				= modifier_imba_terrorblade_metamorphosis_transform or class({})
modifier_imba_terrorblade_metamorphosis							= modifier_imba_terrorblade_metamorphosis or class({})
modifier_imba_terrorblade_metamorphosis_transform_aura			= modifier_imba_terrorblade_metamorphosis_transform_aura or class({})
modifier_imba_terrorblade_metamorphosis_transform_aura_applier	= modifier_imba_terrorblade_metamorphosis_transform_aura_applier or class({})

imba_terrorblade_sunder						= imba_terrorblade_sunder or class({})

---------------------------------
-- IMBA_TERRORBLADE_REFLECTION --
---------------------------------

function imba_terrorblade_reflection:GetAOERadius()
	return self:GetSpecialValueFor("range")
end

function imba_terrorblade_reflection:OnSpellStart()
	local spawn_range	= 108
	local slow_modifier	= nil

	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)) do
		if enemy:GetHullRadius() > 8 then
			spawn_range = 108
		else
			spawn_range	= 72
		end
		
		enemy:EmitSound("Hero_Terrorblade.Reflection")
		
		local illusions = CreateIllusions(self:GetCaster(), enemy, {
			outgoing_damage = self:GetTalentSpecialValueFor("illusion_outgoing_damage"),
			incoming_damage	= -100,
			bounty_base		= 0,
			bounty_growth	= nil,
			outgoing_damage_structure	= nil,
			outgoing_damage_roshan		= nil,
			duration		= self:GetSpecialValueFor("illusion_duration")
		}
		, 1, spawn_range, false, true)
		
		for _, illusion in pairs(illusions) do
			illusion:SetAttacking(enemy)
			-- illusion:AddNewModifier(self:GetCaster(), self, "modifier_imba_terrorblade_reflection_unit", {})
			illusion:AddNewModifier(self:GetCaster(), self, "modifier_terrorblade_reflection_invulnerability", {})
		end
		
		slow_modifier = enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_terrorblade_reflection_slow", {duration = self:GetSpecialValueFor("illusion_duration")})
		
		if slow_modifier then
			slow_modifier:SetDuration(self:GetSpecialValueFor("illusion_duration") * (1 - enemy:GetStatusResistance()), true)
		end
	end
end

-----------------------------------------------
-- MODIFIER_IMBA_TERRORBLADE_REFLECTION_SLOW --
-----------------------------------------------

function modifier_imba_terrorblade_reflection_slow:OnCreated()
	self.move_slow	= self:GetAbility():GetSpecialValueFor("move_slow") * (-1)
end

function modifier_imba_terrorblade_reflection_slow:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_imba_terrorblade_reflection_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.move_slow
end

-----------------------------------------------
-- MODIFIER_IMBA_TERRORBLADE_REFLECTION_UNIT --
-----------------------------------------------

function modifier_imba_terrorblade_reflection_unit:IsPurgable()	return false end

function modifier_imba_terrorblade_reflection_unit:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

function modifier_imba_terrorblade_reflection_unit:OnCreated()

end

-- "Reflection illusions are invulnerable, untargetable, and uncontrollable."
-- "The illusions are completely immune to every spell, even those which affect invulnerable units."
function modifier_imba_terrorblade_reflection_unit:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE]		= true,
		[MODIFIER_STATE_UNTARGETABLE]		= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED]	= true,
		
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY]	= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]	= true,
		[MODIFIER_STATE_MAGIC_IMMUNE]		= true,
		[MODIFIER_STATE_NO_HEALTH_BAR]		= true
	}
end

function modifier_imba_terrorblade_reflection_unit:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE}
end

-- "Reflection illusions have 550 movement speed and free pathing."
function modifier_imba_terrorblade_reflection_unit:GetModifierMoveSpeed_Absolute()
	return 550
end

------------------------------------
-- IMBA_TERRORBLADE_CONJURE_IMAGE --
------------------------------------

function imba_terrorblade_conjure_image:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Terrorblade.ConjureImage")

	CreateIllusions(self:GetCaster(), self:GetCaster(), {
		outgoing_damage = self:GetSpecialValueFor("illusion_outgoing_damage"),
		incoming_damage	= self:GetSpecialValueFor("illusion_incoming_damage"),
		bounty_base		= self:GetCaster():GetIllusionBounty(), -- Custom function but it should just be caster level * 2
		bounty_growth	= nil,
		outgoing_damage_structure	= nil,
		outgoing_damage_roshan		= nil,
		duration		= self:GetSpecialValueFor("illusion_duration")
	}
	, 1, 108, false, true)
end

------------------------------------
-- IMBA_TERRORBLADE_METAMORPHOSIS --
------------------------------------

function imba_terrorblade_metamorphosis:OnSpellStart()
-- Hero_Terrorblade.Metamorphosis
-- Hero_Terrorblade.Metamorphosis.Scepter
-- Hero_Terrorblade.Metamorphosis.Fear

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_terrorblade_metamorphosis_transform", {duration = self:GetSpecialValueFor("transformation_time")})
end

-------------------------------------------------------
-- MODIFIER_IMBA_TERRORBLADE_METAMORPHOSIS_TRANSFORM --
-------------------------------------------------------

function modifier_imba_terrorblade_metamorphosis_transform:OnCreated()
	self.duration	= self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_imba_terrorblade_metamorphosis_transform:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_terrorblade_metamorphosis", {duration = self.duration})
end

---------------------------------------------
-- MODIFIER_IMBA_TERRORBLADE_METAMORPHOSIS --
---------------------------------------------

function modifier_imba_terrorblade_metamorphosis:OnCreated()
	self.bonus_range 	= self:GetAbility():GetTalentSpecialValueFor("bonus_range")
	self.speed_loss		= self:GetAbility():GetSpecialValueFor("speed_loss") * (-1)
end

function modifier_imba_terrorblade_metamorphosis:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
end

function modifier_imba_terrorblade_metamorphosis:GetModifierProjectileName()

end

function modifier_imba_terrorblade_metamorphosis:GetModifierAttackRangeBonus()
	return self.bonus_range
end

function modifier_imba_terrorblade_metamorphosis:GetModifierMoveSpeedBonus_Constant()
	return self.speed_loss
end

------------------------------------------------------------
-- MODIFIER_IMBA_TERRORBLADE_METAMORPHOSIS_TRANSFORM_AURA --
------------------------------------------------------------

function modifier_imba_terrorblade_metamorphosis_transform_aura:OnCreated()

end

--------------------------------------------------------------------
-- MODIFIER_IMBA_TERRORBLADE_METAMORPHOSIS_TRANSFORM_AURA_APPLIER --
--------------------------------------------------------------------

function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:OnCreated()
	self.metamorph_aura_tooltip	= self:GetAbility():GetSpecialValueFor("metamorph_aura_tooltip")
end

function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:IsHidden()						return true end

function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:IsAura()						return true end
function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:IsAuraActiveOnDeath() 			return false end

-- "The transformation aura's buff lingers for 1 second."
function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:GetAuraDuration()				return 1 end
function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:GetAuraRadius()					return self.metamorph_aura_tooltip end
function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end
function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:GetAuraSearchTeam()				return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:GetAuraSearchType()				return DOTA_UNIT_TARGET_HERO end
function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:GetModifierAura()				return "modifier_imba_vengefulspirit_command_negative_aura_effect_723" end
function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:GetAuraEntityReject(hTarget)	return hTarget:GetPlayerOwnerID() ~= self:GetCaster():GetPlayerOwnerID() end

-----------------------------
-- IMBA_TERRORBLADE_SUNDER --
-----------------------------

function imba_terrorblade_sunder:OnSpellStart()
	local target = self:GetCursorTarget()
	
	if target:TriggerSpellAbsorb(self) then return end
	
	local caster_health	= self:GetCaster():GetHealth()
	local target_health	= target:GetHealth()
	
	self:GetCaster():EmitSound("Hero_Terrorblade.Sunder.Cast")
	target:EmitSound("Hero_Terrorblade.Sunder.Target")
	
	self:GetCaster():SetHealth(math.max(target_health, self:GetCaster():GetMaxHealth() * self:GetSpecialValueFor("hit_point_minimum_pct") * 0.01))
	target:SetHealth(math.max(caster_health, target:GetMaxHealth() * self:GetSpecialValueFor("hit_point_minimum_pct") * 0.01))
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_terrorblade_reflection_cooldown", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_terrorblade_metamorphosis_attack_range", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_terrorblade_sunder_cooldown", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_terrorblade_reflection_cooldown				= modifier_special_bonus_imba_terrorblade_reflection_cooldown or class({})
modifier_special_bonus_imba_terrorblade_metamorphosis_attack_range		= modifier_special_bonus_imba_terrorblade_metamorphosis_attack_range or class({})
modifier_special_bonus_imba_terrorblade_sunder_cooldown					= modifier_special_bonus_imba_terrorblade_sunder_cooldown or class({})

function modifier_special_bonus_imba_terrorblade_reflection_cooldown:IsHidden() 		return true end
function modifier_special_bonus_imba_terrorblade_reflection_cooldown:IsPurgable() 		return false end
function modifier_special_bonus_imba_terrorblade_reflection_cooldown:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_terrorblade_metamorphosis_attack_range:IsHidden() 		return true end
function modifier_special_bonus_imba_terrorblade_metamorphosis_attack_range:IsPurgable() 		return false end
function modifier_special_bonus_imba_terrorblade_metamorphosis_attack_range:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_terrorblade_sunder_cooldown:IsHidden() 		return true end
function modifier_special_bonus_imba_terrorblade_sunder_cooldown:IsPurgable() 		return false end
function modifier_special_bonus_imba_terrorblade_sunder_cooldown:RemoveOnDeath() 	return false end

function imba_terrorblade_reflection:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_terrorblade_reflection_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_terrorblade_reflection_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_terrorblade_reflection_cooldown"), "modifier_special_bonus_imba_terrorblade_reflection_cooldown", {})
	end
end

function imba_terrorblade_metamorphosis:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_terrorblade_metamorphosis_attack_range") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_terrorblade_metamorphosis_attack_range") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_terrorblade_metamorphosis_attack_range"), "modifier_special_bonus_imba_terrorblade_metamorphosis_attack_range", {})
	end
end

function imba_terrorblade_sunder:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_terrorblade_sunder_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_terrorblade_sunder_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_terrorblade_sunder_cooldown"), "modifier_special_bonus_imba_terrorblade_sunder_cooldown", {})
	end
end

-- // TERRORBLADE
		-- "DOTA_Tooltip_ability_terrorblade_reflection"										"Reflection"
		-- "DOTA_Tooltip_ability_terrorblade_reflection_Description"							"Terrorblade brings forth an invulnerable dark reflection of all enemy heroes in a target area. Affected enemy heroes are slowed and attacked by their reflection."
		-- "DOTA_Tooltip_ability_terrorblade_reflection_Lore"									"In the fractal prison of Foulfell, Terrorblade learned the truth of this old tale: you are your own worst enemy.  Now it is a lesson he teaches others."
		-- "DOTA_Tooltip_ability_terrorblade_reflection_illusion_duration"						"REFLECTION DURATION:"
		-- "DOTA_Tooltip_ability_terrorblade_reflection_illusion_outgoing_tooltip"				"%REFLECTION DAMAGE:"
		-- "DOTA_Tooltip_ability_terrorblade_reflection_move_slow"								"%MOVEMENT SLOW:"
		-- "DOTA_Tooltip_ability_terrorblade_reflection_range"									"RADIUS:"
		-- "DOTA_Tooltip_ability_terrorblade_reflection_Note0"									"Reflections are untargetable, invulnerable illusions, that will be destroyed if the slow debuff is removed."
		-- "DOTA_Tooltip_ability_terrorblade_reflection_Note1"									"Reflections can only attack their source."
		-- "DOTA_Tooltip_ability_terrorblade_conjure_image"									"Conjure Image"
		-- "DOTA_Tooltip_ability_terrorblade_conjure_image_Description"						"Creates an illusion of Terrorblade that deals damage."
		-- "DOTA_Tooltip_ability_terrorblade_conjure_image_Lore"								"There's only one thing more dangerous than facing Terrorblade.  Facing MORE Terrrorblades!"
		-- "DOTA_Tooltip_ability_terrorblade_conjure_image_Note0"								"Illusions created by Conjure Image are visually different for enemies."
		-- "DOTA_Tooltip_ability_terrorblade_conjure_image_illusion_duration"					"ILLUSION DURATION:"
		-- "DOTA_Tooltip_ability_terrorblade_conjure_image_illusion_outgoing_tooltip"			"%ILLUSION DAMAGE:"
		-- "DOTA_Tooltip_ability_terrorblade_conjure_image_illusion_incoming_damage_total_tooltip"			"%ILLUSION DAMAGE TAKEN:"
		-- "DOTA_Tooltip_ability_terrorblade_metamorphosis"									"Metamorphosis"
		-- "DOTA_Tooltip_ability_terrorblade_metamorphosis_Description"						"Terrorblade transforms into a powerful demon with a ranged attack. Any of Terrorblade's illusions that are within %metamorph_aura_tooltip% range will also be transformed by Metamorphosis."
		-- "DOTA_Tooltip_ability_terrorblade_metamorphosis_aghanim_description"                "Casting Metamorphosis will make a wave travel outwards in all directions causing enemy heroes to become feared upon impact."
		-- "DOTA_Tooltip_ability_terrorblade_metamorphosis_Lore"								"Temper, temper. The rage rises up and takes control.  Meet Terrorblade's own worst self."
		-- "DOTA_Tooltip_ability_terrorblade_metamorphosis_duration"							"DURATION:"
		-- "DOTA_Tooltip_ability_terrorblade_metamorphosis_transformation_time"				"TRANSFORMATION TIME:"
		-- "DOTA_Tooltip_ability_terrorblade_metamorphosis_base_attack_time"					"BASE ATTACK TIME:"
		-- "DOTA_Tooltip_ability_terrorblade_metamorphosis_tooltip_attack_range"				"ATTACK RANGE:"
		-- "DOTA_Tooltip_ability_terrorblade_metamorphosis_bonus_damage"						"BONUS DAMAGE:"
		-- "DOTA_Tooltip_ability_terrorblade_metamorphosis_speed_loss"							"MOVEMENT SPEED LOSS:"
		-- "DOTA_Tooltip_ability_terrorblade_metamorphosis_metamorph_aura_tooltip"		"ILLUSION AURA RADIUS:"
		-- "DOTA_Tooltip_ability_terrorblade_metamorphosis_fear_duration"		        "SCEPTER FEAR DURATION:"
		-- "DOTA_Tooltip_ability_terrorblade_metamorphosis_scepter_radius"		        "SCEPTER WAVE RADIUS:"
		-- "DOTA_Tooltip_ability_terrorblade_metamorphosis_Note0"							"Cooldowns of items that are different for ranged and melee units will be based on which form Terrorblade was in when the item was used."
		-- "DOTA_Tooltip_ability_terrorblade_sunder"											"Sunder"
		-- "DOTA_Tooltip_ability_terrorblade_sunder_Description"								"Severs the life from both Terrorblade and a target hero, exchanging a percentage of both units' current health. Some health points must remain."
		-- "DOTA_Tooltip_ability_terrorblade_sunder_Lore"										"You didn't need that life, did you?  The demon marauder steals that which you hold most dear."
		-- "DOTA_Tooltip_ability_terrorblade_sunder_hit_point_minimum_pct"						"%MINIMUM HP SWAP:"

		-- "DOTA_Tooltip_modifier_terrorblade_reflection_slow"					"Reflection"
		-- "DOTA_Tooltip_modifier_terrorblade_reflection_slow_Description"		"Movement speed reduced by %dMODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE%%%, and being attacked by Terrorblade's reflection."
		-- "DOTA_Tooltip_modifier_terrorblade_metamorphosis"					"Metamorphosis"
		-- "DOTA_Tooltip_modifier_terrorblade_metamorphosis_Description"		"Powerful demon form with a ranged attack."
		-- "DOTA_Tooltip_modifier_terrorblade_metamorphosis_transform_aura_applier"					"Metamorphosis Aura"
		-- "DOTA_Tooltip_modifier_terrorblade_metamorphosis_transform_aura_applier_Description"					"Terrorblade's nearby illusions will match his current form."
		-- "DOTA_Tooltip_modifier_terrorblade_fear"							"Fear"
		-- "DOTA_Tooltip_modifier_terrorblade_fear_Description"				"Feared by Terrorblade's Metamorphosis."
