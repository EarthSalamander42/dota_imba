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
	local funcs = 
	{
--		MODIFIER_EVENT_ON_ATTACKED,
--		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
--		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
--		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
	return funcs
end

function modifier_companion:OnCreated()
	-- Stacks determine invisibility state:
	-- 0: not invisible
	-- 1: invisible

	if IsServer() then
		self:StartIntervalThink(0.2)

		local companion = self:GetParent()
		if not companion.base_model then
			companion.base_model = companion:GetModelName()
		end

		-- Talent specials
		self.stand_time = self:GetParent():FindTalentValue("special_bonus_imba_mirana_5")

		-- Set the current stand position and timer
		self.last_position = self:GetParent():GetAbsOrigin()
		self.last_time_tick = GameRules:GetGameTime()

		-- Set invisibility state
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

function modifier_companion:OnIntervalThink()
	if IsServer() then
		local companion = self:GetParent()
		local hero = self:GetParent():GetPlayerOwner():GetAssignedHero()
		local fountain = Entities:FindByName(nil, "ent_dota_fountain_good")
		if hero:GetTeamNumber() == 3 then
			fountain = Entities:FindByName(nil, "ent_dota_fountain_bad")
		end

		local hero_distance = (hero:GetAbsOrigin() - companion:GetAbsOrigin()):Length()
		local fountain_distance = (fountain:GetAbsOrigin() - companion:GetAbsOrigin()):Length()
		local min_distance = 160
		local blink_distance = 800

		local invisModifiers = {
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
		}

		if companion:GetIdealSpeed() ~= hero:GetIdealSpeed() + 10 then
			companion:SetBaseMoveSpeed(hero:GetIdealSpeed() + 10)
		end

		if self.last_position ~= self:GetParent():GetAbsOrigin() then
			companion:RemoveModifierByName("modifier_invisible")
			self.last_position = self:GetParent():GetAbsOrigin()
			self.last_time_tick = GameRules:GetGameTime()
		else            
			for _,v in ipairs(invisModifiers) do
				if not hero:HasModifier(v) then
					if companion:HasModifier(v) then
						companion:RemoveModifierByName(v)
					end
				else
					companion:AddNewModifier(companion, nil, v, {})				
				end
			end
		end

		if not hero:IsAlive() then
			if fountain_distance > blink_distance then -- min_distance is too high with fountain bound radius
				ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, companion)
--				companion:EmitSound("DOTA_Item.BlinkDagger.Activate")
				FindClearSpaceForUnit(companion, fountain:GetAbsOrigin(), false)
				ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, companion)
				companion:Stop()
				return
			end
		elseif hero_distance > blink_distance then
			if companion:HasModifier("modifier_river") and companion:GetAbsOrigin().z < 160 then
			else
				ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, companion)
--				companion:EmitSound("DOTA_Item.BlinkDagger.Activate")
				FindClearSpaceForUnit(companion, hero:GetAbsOrigin() + RandomVector(200), false)
				ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, companion)
			end
		elseif hero_distance > min_distance + 200 then
--			Timers:CreateTimer(0.2, function()
--				companion:MoveToTargetToAttack(hero)
--			end)
		elseif hero_distance < min_distance then
			companion:Stop()
		end
	end
end
