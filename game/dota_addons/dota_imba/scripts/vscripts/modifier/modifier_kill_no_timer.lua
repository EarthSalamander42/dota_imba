modifier_kill_no_timer = modifier_kill_no_timer or class({})

-- Modifier properties
function modifier_kill_no_timer:IsHidden() 		  return true end
function modifier_kill_no_timer:IsPurgable() 	  return false end
function modifier_kill_no_timer:IsDebuff() 		  return false end

function modifier_kill_no_timer:OnDestroy()
	self:GetParent():ForceKill(false)
end