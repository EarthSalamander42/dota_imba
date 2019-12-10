-- Creator:
--	   AltiV, December 10th, 2019

LinkLuaModifier("modifier_imba_form_change", "components/abilities/imba_form_change", LUA_MODIFIER_MOTION_NONE)

imba_form_change 			= imba_form_change or class({})
modifier_imba_form_change	= modifier_imba_form_change or class({})

----------------------
-- IMBA_FORM_CHANGE --
----------------------

function imba_form_change:GetIntrinsicModifierName()
	return "modifier_imba_form_change"
end

function imba_form_change:OnSpellStart()

end

-------------------------------
-- MODIFIER_IMBA_FORM_CHANGE --
-------------------------------