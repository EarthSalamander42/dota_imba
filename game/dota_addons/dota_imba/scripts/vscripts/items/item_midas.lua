--[[	Author: D2Imba, rework by Shush
		Date:	05.03.2017	]]

item_imba_hand_of_midas = class({})
LinkLuaModifier("modifier_item_imba_hand_of_midas", "items/item_midas", LUA_MODIFIER_MOTION_NONE)

function item_imba_hand_of_midas:GetAbilityTextureName()
   return "custom/imba_hand_of_midas"
end

function item_imba_hand_of_midas:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()

		-- If the target is in the caster's team, deny it
		if target:GetTeamNumber() == caster:GetTeamNumber() then
			return UF_FAIL_FRIENDLY
		end

		-- If the target is a hero, deny it
		if target:IsHero() then
			return UF_FAIL_HERO
		end		

		-- If the target is a ward, deny it
		if target:IsOther() then
			return UF_FAIL_CUSTOM
		end

		-- If the target is a necronbook summon, deny it
		if string.find(target:GetUnitName(), "necronomicon") then
			return UF_FAIL_CUSTOM
		end

		-- If the target is a building, deny it
		if target:IsBuilding() then
			return UF_FAIL_BUILDING
		end

		return UF_SUCCESS
	end
end

function item_imba_hand_of_midas:GetCustomCastErrorTarget(target)
	if IsServer() then
		local caster = self:GetCaster()

		-- Ward message
		if target:IsOther() then
			return "#dota_hud_error_cant_use_on_wards"
		end

		-- Necronomicon message		
		if string.find(target:GetUnitName(), "necronomicon") then
			return "#dota_hud_error_cant_use_on_necrobook"
		end
	end
end

function item_imba_hand_of_midas:GetAbilityTextureName()
	local caster = self:GetCaster()
	local caster_name = caster:GetUnitName()

	local animal_heroes = {
		"npc_dota_hero_brewmaster",
		"npc_dota_hero_magnataur",
		"npc_dota_hero_lone_druid",
		"npc_dota_hero_broodmother",
		"npc_dota_hero_lycan",
		"npc_dota_hero_ursa"
	}

	for _, hero_name in pairs (animal_heroes) do
		if caster_name == hero_name then
			return "custom/item_paw_of_midas"
		end
	end

	return "custom/imba_hand_of_midas"
end

function item_imba_hand_of_midas:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local ability = self
	local sound_cast = "DOTA_Item.Hand_Of_Midas"

	-- Parameters and calculations
	local bonus_gold = ability:GetSpecialValueFor("bonus_gold")
	local xp_multiplier = ability:GetSpecialValueFor("xp_multiplier")
	local passive_gold_bonus = ability:GetSpecialValueFor("passive_gold_bonus")
	local bonus_xp = target:GetDeathXP()	

	-- Adjust for the lobby settings and for midas' own bonuses
	bonus_xp = bonus_xp * xp_multiplier * (1 + CUSTOM_XP_BONUS * 0.01)
	bonus_gold = bonus_gold * (1 + CUSTOM_GOLD_BONUS * 0.01)

	-- Play sound and show gold gain message to the owner
	target:EmitSound(sound_cast)
	SendOverheadEventMessage(PlayerResource:GetPlayer(caster:GetPlayerID()), OVERHEAD_ALERT_GOLD, target, bonus_gold, nil)

	-- Draw the midas gold conversion particle
	local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)	
	ParticleManager:SetParticleControlEnt(midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)

	-- Grant gold and XP only to the caster
	target:SetDeathXP(0)
	target:SetMinimumGoldBounty(0)
	target:SetMaximumGoldBounty(0)
	target:Kill(ability, caster)
	caster:AddExperience(bonus_xp, false, false)
	caster:ModifyGold(bonus_gold, true, 0)
end

function item_imba_hand_of_midas:GetIntrinsicModifierName()
	return "modifier_item_imba_hand_of_midas"
end

modifier_item_imba_hand_of_midas = class({})

function modifier_item_imba_hand_of_midas:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_item_imba_hand_of_midas:GetModifierAttackSpeedBonus_Constant()
	local ability = self:GetAbility()	
	local bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")

	return bonus_attack_speed
end

function modifier_item_imba_hand_of_midas:IsHidden()
	return true
end

function modifier_item_imba_hand_of_midas:IsPermanent()
	return true
end