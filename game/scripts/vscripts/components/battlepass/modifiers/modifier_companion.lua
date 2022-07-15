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

	if self.is_flying == 1 then
		state[MODIFIER_STATE_FLYING] = true
	end

	return state
end

function modifier_companion:DeclareFunctions() return {
	MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
} end

function modifier_companion:GetVisualZDelta()
	if self.is_flying == 1 then
		return 290
	end

	return 0
end

-- add "ultimate_scepter" + "enchant_totem_leap_from_battle"
function modifier_companion:GetActivityTranslationModifiers()
	if self:GetParent():GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then
		return "arcana"
	end

	return ""
end

function modifier_companion:OnCreated()
	if IsServer() then
		self.is_flying = false
		self.set_final_pos = false

		if GetMapName() == "imba_1v1" then
			self:GetParent():ForceKill(false)
			return
		else
			self:StartIntervalThink(0.1)
		end

		if not self:GetParent().base_model then
			self:GetParent().base_model = self:GetParent():GetModelName()
		end

		if not self:GetParent():HasModifier("modifier_bloodseeker_thirst") then
			self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_bloodseeker_thirst", {})
		end

		if string.find(self:GetParent():GetModelName(), "flying") or DONATOR_COMPANION_ADDITIONAL_INFO[self:GetParent():GetModelName()] and DONATOR_COMPANION_ADDITIONAL_INFO[self:GetParent():GetModelName()][2] == true then
			self.is_flying = true
			self:SetStackCount(1)
		end
	end

	if IsClient() then
		if self:GetStackCount() == 1 then
			self.is_flying = true
		end
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

		-- vanilla baseclass bug
--		if companion:IsMoving() then
--			companion:StartGesture(ACT_DOTA_RUN)
--		else
--			companion:FadeGesture(ACT_DOTA_RUN)
--		end

		if companion:GetPlayerOwner() == nil or companion:GetPlayerOwner():GetAssignedHero() == nil then return end
		local hero = companion:GetPlayerOwner():GetAssignedHero()
		hero.companion = companion
		local fountain_abs

		if GetMapName() == "imbathrow_ffa" then
			fountain_abs = Entities:FindByName(nil, "@overboss"):GetAbsOrigin()
		elseif GetMapName() == "imba_demo" then
			for _, ent in pairs(Entities:FindAllByClassname("ent_dota_fountain")) do
				if ent:GetTeamNumber() == companion:GetTeamNumber() then
					fountain_abs = ent:GetAbsOrigin()
					break
				end
			end
		elseif GetMapName() == "pudgewars_new" then
			fountain_abs = _G.rune_spell_caster_good:GetAbsOrigin()
		elseif GetMapName() == "battle_royale_ffa" or "battle_royale_2v2v2v2v2" then
			fountain_abs = Vector(0, 0, 0)
		else
			if GoodCamera then
				if hero:GetTeamNumber() == 2 then
					fountain_abs = GoodCamera:GetAbsOrigin()
				end
			else
				fountain_abs = Vector(0, 0, 0)
			end

			if BadCamera then
				if hero:GetTeamNumber() == 3 then
					fountain_abs = BadCamera:GetAbsOrigin()
				end
			else
				fountain_abs = Vector(0, 0, 0)
			end
		end

		local hero_origin = hero:GetAbsOrigin()
		local hero_distance = (hero_origin - companion:GetAbsOrigin()):Length()
		local fountain_distance = (fountain_abs - companion:GetAbsOrigin()):Length()
		local min_distance = 250
		local blink_distance = 750

		if companion:GetIdealSpeed() ~= hero:GetIdealSpeed() - 70 then
			companion:SetBaseMoveSpeed(hero:GetIdealSpeed() - 70)
		end

		-- This thing crashes with Treant's Nature's Guise
		-- Also using static lists for invisibltiy modifiers is just asking for trouble
		-- for _,v in pairs(IMBA_INVISIBLE_MODIFIERS) do
			-- if not hero:HasModifier(v) then
				-- if companion:HasModifier(v) then
					-- companion:RemoveModifierByName(v)
				-- end
			-- else
				-- if not companion:HasModifier(v) then
					-- companion:AddNewModifier(companion, nil, v, {})
					-- break -- remove this break if you want to add multiple modifiers at the same time
				-- end
			-- end
		-- end

		if hero:IsInvisible() then
			companion:AddNewModifier(companion, nil, "modifier_invisible", {})
		else
			companion:RemoveModifierByNameAndCaster("modifier_invisible", companion)
		end

		for _, v in ipairs(SHARED_NODRAW_MODIFIERS) do
			if hero:HasModifier(v) or self:IsOnMountain() then
				companion:AddNoDraw()
				return
			elseif not hero:HasModifier(v) then
				companion:RemoveNoDraw()
			end
		end

		if hero_distance < min_distance then
			if hero:IsMoving() == false and self.set_final_pos == false then
				self.set_final_pos = true
				companion:MoveToPosition(hero:GetAbsOrigin() + RandomVector(200))
				return
			elseif hero:IsMoving() and self.set_final_pos == true then
				self.set_final_pos = false
			end
		elseif hero_distance > blink_distance then
			companion:Blink(hero_origin + RandomVector(RandomInt(150, 300)), true, false)
			companion:Stop()
		elseif hero_distance > min_distance then
			if not companion:IsMoving() then
				companion:MoveToNPC(hero)
			end
		elseif fountain_distance > blink_distance and not hero:IsAlive() then -- min_distance is too high with fountain bound radius
			FindClearSpaceForUnit(companion, fountain_abs, false)
			companion:Stop()
			return
		end

		self:SetStackCount(hero_distance / 4)
	end
end

function modifier_companion:IsOnMountain()
	local hero = self:GetParent():GetPlayerOwner():GetAssignedHero()
	local origin = hero:GetAbsOrigin()

--	print("cliff:", origin.z, 512)
	if origin.z > 512 then
		return true
	else
		return false
	end
end
