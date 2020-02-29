modifier_invulnerable_hidden = class({})

--------------------------------------------------------------------------------

function modifier_invulnerable_hidden:IsHidden() return true end
function modifier_invulnerable_hidden:IsPurgable() return false end
function modifier_invulnerable_hidden:RemoveOnDeath() return false end

--------------------------------------------------------------------------------

function modifier_invulnerable_hidden:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end
