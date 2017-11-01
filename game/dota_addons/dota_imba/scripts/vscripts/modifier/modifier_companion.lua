modifier_companion = class({})

function modifier_companion:IsHidden() return true end
function modifier_companion:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_companion:GetAbsoluteNoDamageMagical() return 1 end
function modifier_companion:GetAbsoluteNoDamagePure() return 1 end

function modifier_companion:CheckState()
	local state = 
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	}

	return state
end

function modifier_companion:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
	return funcs
end

function modifier_companion:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

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

function modifier_companion:OnIntervalThink()
	if IsServer() then
		local companion = self:GetParent()
		local hero = self:GetParent():GetPlayerOwner():GetAssignedHero()
		local distance = (hero:GetOrigin() - companion:GetOrigin()):Length()
		local min_distance = 250
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
			"modifier_rune_invis"
		}

--		print("Companion MS:", companion:GetBaseMoveSpeed())
--		print("Hero MS:", hero:GetBaseMoveSpeed() - 10)
--		if companion:GetBaseMoveSpeed() ~= hero:GetBaseMoveSpeed() - 10 then
--			companion:SetBaseMoveSpeed(hero:GetBaseMoveSpeed() - 10)
--		end

		for _,v in ipairs(invisModifiers) do
			if not hero:HasModifier(v) then
				if companion:HasModifier(v) then
					companion:RemoveModifierByName(v)
				end
			else
				companion:AddNewModifier(companion, nil, v, {})				
			end
		end

		if distance > blink_distance then
			ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, companion)
			companion:EmitSound("DOTA_Item.BlinkDagger.Activate")
			FindClearSpaceForUnit(companion, hero:GetAbsOrigin(), false)
			ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, companion)
		elseif distance > min_distance then
			local order = {
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
				UnitIndex = companion:entindex(),
				TargetIndex = hero:entindex()
			}
			ExecuteOrderFromTable(order)
		end
	end
end
