--[[	Author: Firetoad
		Date: 10.09.2015	]]

function Rearm( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_rearm = keys.particle_rearm
	local sound_cast = keys.sound_cast
	
	-- Parameters
	local cooldown = ability:GetLevelSpecialValueFor("cooldown_tooltip", ability_level)
	local stack_duration = ability:GetLevelSpecialValueFor("stack_duration", ability_level)

	-- List of unrefreshable abilities (for Random OMG/LOD modes)
	local forbidden_abilities = {
		"imba_tinker_rearm"
	}

	-- List of unrefreshable items
	local forbidden_items = {
		"item_imba_bloodstone",
		"item_imba_arcane_boots",
		"item_imba_mekansm",
		"item_imba_mekansm_2",
		"item_imba_guardian_greaves",
		"item_imba_hand_of_midas",
		"item_imba_white_queen_cape",
		"item_imba_black_king_bar",
		"item_imba_refresher",
		"item_imba_necronomicon",
		"item_imba_necronomicon_2",
		"item_imba_necronomicon_3"
	}

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Play a random cast line
	caster:EmitSound("tink_ability_rearm_0"..RandomInt(1, 9))

	-- Fire particle
	local rearm_pfx = ParticleManager:CreateParticle(particle_rearm, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(rearm_pfx, 0, caster:GetAbsOrigin())

	-- Play animation
	if ability_level == 0 then
		StartAnimation(caster, {duration = 3.0, activity = ACT_DOTA_TINKER_REARM1, rate = 1.0})
	elseif ability_level == 1 then
		StartAnimation(caster, {duration = 2.0, activity = ACT_DOTA_TINKER_REARM2, rate = 1.0})
	elseif ability_level == 2 then
		StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_TINKER_REARM3, rate = 1.0})
	end

	-- Refresh abilities
	for i = 0, 15 do
		local current_ability = caster:GetAbilityByIndex(i)
		local should_refresh = true

		-- If this ability is forbidden, do not refresh it
		for _,forbidden_ability in pairs(forbidden_abilities) do
			if current_ability and current_ability:GetName() == forbidden_ability then
				should_refresh = false
			end
		end

		-- Refresh
		if current_ability and should_refresh then
			current_ability:EndCooldown()
		end
	end

	-- Refresh items
	for i = 0, 5 do
		local current_item = caster:GetItemInSlot(i)
		local should_refresh = true

		-- If this item is forbidden, do not refresh it
		for _,forbidden_item in pairs(forbidden_items) do
			if current_item and current_item:GetName() == forbidden_item then
				should_refresh = false
			end
		end

		-- Refresh
		if current_item and should_refresh then
			current_item:EndCooldown()
		end
	end

	-- Put Rearm on cooldown
	ability:StartCooldown(cooldown)
end
