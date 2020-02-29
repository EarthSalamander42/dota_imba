-- Creator:
--	   AltiV, May 5th, 2019

-- This modifier is simply used to track if a hero bought back, and will apply a respawn timer penalty when the hero dies again, removing this modifier in the process

modifier_buyback_penalty = class({})

function modifier_buyback_penalty:IsHidden() 		return true end
function modifier_buyback_penalty:IsDebuff() 		return true end
function modifier_buyback_penalty:IsPurgable() 		return false end
function modifier_buyback_penalty:RemoveOnDeath() 	return false end	-- Will be removed by the respawn timer code