original_CreateParticle = CDOTA_PlayerResource.CreateParticle
CDOTA_PlayerResource.CreateParticle = function(self, sPfxName, iAttachType, hTarget)
	local old_hero = Core:GetHero(pid)

	-- Before finishing this, need to finish items_game library to gather informations inside items_game.txt file

	-- todo: check if a BP reward contain this pfx name and if the hero has unlocked this BP reward
	if sPfxName == "" then
		-- apply the unlocked particle
		sPfxName = ""
	end

	local response = original_CreateParticle(self, sPfxName, iAttachType, hTarget)

	return response
end

local mana_burn_pfx = ParticleManager:CreateParticle(particle_burn, PATTACH_ABSORIGIN, enemy)
