--[[	Author: d2imba
		Date:	16.08.2015	]]

function PipeParticle( keys )
	local target = keys.target
	local particle_pipe = keys.particle_pipe

	if not target.pipe_of_insight_particle then
		target.pipe_of_insight_particle = ParticleManager:CreateParticle(particle_pipe, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(target.pipe_of_insight_particle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(target.pipe_of_insight_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_origin", target:GetAbsOrigin(), true)
		--ParticleManager:SetParticleControl(target.pipe_of_insight_particle, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(target.pipe_of_insight_particle, 2, Vector(target:GetModelRadius() * 1.1,0,0))
	end
end

function PipeParticleEnd( keys )
	local target = keys.target

	if target.pipe_of_insight_particle then
		ParticleManager:DestroyParticle(target.pipe_of_insight_particle, false)
		target.pipe_of_insight_particle = nil
	end
end