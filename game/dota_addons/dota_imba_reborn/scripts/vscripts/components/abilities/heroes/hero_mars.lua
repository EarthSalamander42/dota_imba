-- THIS FILE IS CURRENTLY JUST TO ADD A MEME FACTOR; IT DOESN'T HAVE ANY CUSTOM SKILLS/IMBAFICATIONS RIGHT NOW

-- Creator:
--	   AltiV, March 16th, 2019

LinkLuaModifier("modifier_imba_mars_arena_of_blood_enhance", "components/abilities/heroes/hero_mars.lua", LUA_MODIFIER_MOTION_NONE)

imba_mars_arena_of_blood_enhance						= class({})
modifier_imba_mars_arena_of_blood_enhance				= class({})

----------------------------
-- Arena of Blood ENHANCE --
----------------------------

function imba_mars_arena_of_blood_enhance:IsInnateAbility() return true end

function imba_mars_arena_of_blood_enhance:GetIntrinsicModifierName()
	return "modifier_imba_mars_arena_of_blood_enhance"
end

-------------------------------------
-- Arena of Blood ENHANCE Modifier --
-------------------------------------

function modifier_imba_mars_arena_of_blood_enhance:IsHidden()	return true end

function modifier_imba_mars_arena_of_blood_enhance:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return funcs
end

function modifier_imba_mars_arena_of_blood_enhance:GetModifierModelScale(keys)
	if self:GetParent():HasModifier("modifier_mars_arena_of_blood_animation") then
		return self:GetAbility():GetSpecialValueFor("expansion_pct")
	end
end
