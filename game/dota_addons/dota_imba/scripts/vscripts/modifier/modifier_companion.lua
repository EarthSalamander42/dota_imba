modifier_companion = class({})

function modifier_companion:IsHidden() return true end
function modifier_companion:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_companion:GetAbsoluteNoDamageMagical() return 1 end
function modifier_companion:GetAbsoluteNoDamagePure() return 1 end

function modifier_companion:CheckState()
	local state = {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end

function modifier_companion:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return decFuncs
end

function modifier_companion:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.5)

		local companion = self:GetParent()
		if not companion.base_model then
			companion.base_model = companion:GetModelName()
		end

		self:SetStackCount(0)
	end
end

--[[
local anti_spam = false
function modifier_companion:OnAttacked(keys)
local target = keys.target

	if IsServer() then
		if target == self:GetParent() then
			if anti_spam == false then
				anti_spam = true
				target:EmitSound("Companion.Llama")
				Timers:CreateTimer(5.0, function()
					anti_spam = false
				end)
			end
		end
	end
end
--]]

function modifier_companion:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()
end

function modifier_companion:OnIntervalThink()
	if IsServer() then
		local companion = self:GetParent()
		local hero = self:GetParent():GetPlayerOwner():GetAssignedHero()
		local fountain = Entities:FindByName(nil, "ent_dota_fountain_good")
		if hero:GetTeamNumber() == 3 then
			fountain = Entities:FindByName(nil, "ent_dota_fountain_bad")
		end

		local hero_origin = hero:GetAbsOrigin()
		local hero_distance = (hero_origin - companion:GetAbsOrigin()):Length()
		local fountain_distance = (fountain:GetAbsOrigin() - companion:GetAbsOrigin()):Length()
		local min_distance = 200
		local blink_distance = 800

		local shared_modifiers = {
			"modifier_invisible",
			"modifier_mirana_moonlight_shadow",
			"modifier_item_imba_shadow_blade_invis",
			"modifier_item_shadow_amulet_fade",
			"modifier_imba_vendetta",
			"modifier_nyx_assassin_burrow",
			"modifier_item_imba_silver_edge_invis",
			"modifier_item_glimmer_cape_fade",
			"modifier_weaver_shukuchi",
			"modifier_treant_natures_guise_invis",
			"modifier_templar_assassin_meld",
			"modifier_imba_skeleton_walk_dummy",
			"modifier_invoker_ghost_walk_self",
			"modifier_rune_invis",
			"modifier_item_imba_silver_edge_invis",
			"modifier_imba_skeleton_walk_invis",
			"modifier_imba_riki_invisibility",
			"modifier_imba_shadow_walk_buff_invis",
			"modifier_smoke_of_deceit",
		}

		if companion:GetIdealSpeed() ~= hero:GetIdealSpeed() - 60 then
			companion:SetBaseMoveSpeed(hero:GetIdealSpeed() - 60)
		end
         
		for _,v in ipairs(shared_modifiers) do
			if not hero:HasModifier(v) then
				if companion:HasModifier(v) then
					companion:RemoveModifierByName(v)
				end
			else
				companion:AddNewModifier(companion, nil, v, {})				
			end
		end

		if not hero:IsAlive() then
			if fountain_distance > blink_distance then -- min_distance is too high with fountain bound radius
				FindClearSpaceForUnit(companion, fountain:GetAbsOrigin(), false)
				companion:Stop()
				return
			end
		elseif hero_distance < min_distance then
			companion:Stop()
		elseif hero_distance > blink_distance then
			FindClearSpaceForUnit(companion, hero_origin + RandomVector(RandomFloat(200, 300)), false)
			companion:Stop()
		elseif hero_distance > min_distance then
			if not companion:IsMoving() then
				companion:MoveToNPC(hero)
			end
		end

		self:SetStackCount(hero_distance / 4)
	end
end
