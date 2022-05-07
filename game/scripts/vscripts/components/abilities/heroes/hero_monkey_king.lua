-- Creator:
--	   AltiV, September 2nd, 2019

-- Sorry, no actual IMBAfications in here right now.

LinkLuaModifier("modifier_imba_monkey_king_true_strike", "components/abilities/heroes/hero_monkey_king", LUA_MODIFIER_MOTION_NONE)

imba_monkey_king_true_strike			= class({})
modifier_imba_monkey_king_true_strike	= class({})

----------------------------------
-- IMBA_MONKEY_KING_TRUE_STRIKE --
----------------------------------

function imba_monkey_king_true_strike:IsInnateAbility()	return true end

function imba_monkey_king_true_strike:GetIntrinsicModifierName()
	return "modifier_imba_monkey_king_true_strike"
end

-------------------------------------------
-- MODIFIER_IMBA_MONKEY_KING_TRUE_STRIKE --
-------------------------------------------

function modifier_imba_monkey_king_true_strike:GetTexture()
	return "item_monkey_king_bar"
end

function modifier_imba_monkey_king_true_strike:CheckState()
	return {[MODIFIER_STATE_CANNOT_MISS] = true}
end
