---------------------------------------------------------------
-- sly_king - Ice route
---------------------------------------------------------------

LinkLuaModifier( "modifier_imba_sly_king_burrow_blast", "hero/hero_sly_king.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_sly_king_burrow_blast_stun", "hero/hero_sly_king.lua" ,LUA_MODIFIER_MOTION_NONE )

imba_sly_king_burrow_blast = imba_sly_king_burrow_blast or class({})

function imba_sly_king_burrow_blast:GetAbilityTextureName()
   local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_sly_king_burrow_blast") then return "alchemist_acid_spray" end
   	return "disruptor_thunder_strike"
end

function imba_sly_king_burrow_blast:GetCooldown(nLevel)
	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
	return cooldown
end

function imba_sly_king_burrow_blast:OnAbilityPhaseStart()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:HasModifier("modifier_imba_sly_king_burrow_blast") then 
			self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_5 )
		else 
			self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_4 )
		end
		return true
	end
end

function imba_sly_king_burrow_blast:OnAbilityPhaseInterrupted()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_sly_king_burrow_blast") then 
		self:GetCaster():RemoveGesture( ACT_DOTA_CAST_ABILITY_4 )
	else 
		self:GetCaster():RemoveGesture( ACT_DOTA_CAST_ABILITY_4 )
	end
	
end

function imba_sly_king_burrow_blast:GetCastPoint()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_sly_king_burrow_blast") then return nil end
   	return 0.7
end

function imba_sly_king_burrow_blast:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self
		local duration = ability:GetSpecialValueFor("duration")
		local radius = ability:GetSpecialValueFor("radius")
		local damage = ability:GetSpecialValueFor("damage")
		local stun_duration = ability:GetSpecialValueFor("stun_duration")

		if caster:HasModifier("modifier_imba_sly_king_burrow_blast") then
			-- 2eme parti du spell
			caster:RemoveModifierByName("modifier_imba_sly_king_burrow_blast")
			-- self:GetCaster():RemoveGesture( ACT_DOTA_CAST_ABILITY_4 )
			Timers:CreateTimer(0.2, function()
				local particleName = "particles/heroes/hero_slyli/ice_route.vpcf"
				local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, self:GetCaster())
				ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))
				Timers:CreateTimer(0.1, function()

						if caster:IsAlive() then
							-- caster:RemoveGesture( ACT_DOTA_CAST_ABILITY_5 );
						end
						local radius_find = FindUnitsInRadius(caster:GetTeamNumber(),
	                                        caster:GetAbsOrigin(),
	                                        nil,
	                                        radius,
	                                        DOTA_UNIT_TARGET_TEAM_ENEMY,
	                                        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	                                        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	                                        FIND_ANY_ORDER,
											false)
						for _,enemy in pairs(radius_find) do
							if enemy ~= target and not enemy:IsAttackImmune() then
								ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
								enemy:AddNewModifier(caster, ability, "modifier_imba_sly_king_burrow_blast_stun", { duration = stun_duration })
							end
						end
						self:GetCaster():RemoveGesture( ACT_DOTA_IDLE_RARE )
					end)
			end)
		else
			-- 1er Partie du spell
			self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_imba_sly_king_burrow_blast", {duration = duration} )
		end
	end
end

---------------------------------------------------------------
-- Modifier modifier_imba_sly_king_burrow_blast
---------------------------------------------------------------

modifier_imba_sly_king_burrow_blast = class({})

function modifier_imba_sly_king_burrow_blast:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}

	return funcs
end

function modifier_imba_sly_king_burrow_blast:CheckState()	
	local state = {} 
	state = {
		-- [MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		-- [MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
	
	return state
end

function modifier_imba_sly_king_burrow_blast:GetModifierMoveSpeed_Limit()
	return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_imba_sly_king_burrow_blast:GetModifierMoveSpeed_Max()
	return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_imba_sly_king_burrow_blast:GetModifierMoveSpeed_Absolute()
	return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_imba_sly_king_burrow_blast:IsHidden()
	return false
end

function modifier_imba_sly_king_burrow_blast:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		caster:AddNoDraw()

		self.particleName = "particles/heroes/hero_slyli/slyli_underground.vpcf"
		self.particle = ParticleManager:CreateParticle(self.particleName, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle, 1, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle, 2, caster:GetAbsOrigin())
		self:StartIntervalThink(0.01)
	end
end

function modifier_imba_sly_king_burrow_blast:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle, 1, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle, 2, caster:GetAbsOrigin())
	end
end

function modifier_imba_sly_king_burrow_blast:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		caster:RemoveNoDraw()
	end
end

------------------------------------------------------------------------------------------------------------------

if modifier_imba_sly_king_burrow_blast_stun == nil then modifier_imba_sly_king_burrow_blast_stun = class({}) end
function modifier_imba_sly_king_burrow_blast_stun:IsPurgable()		return false end
function modifier_imba_sly_king_burrow_blast_stun:IsDebuff()			return true end
function modifier_imba_sly_king_burrow_blast_stun:IsHidden()			return true end
function modifier_imba_sly_king_burrow_blast_stun:IsStunDebuff()		return true end
function modifier_imba_sly_king_burrow_blast_stun:IsPurgeException()	return true end

function modifier_imba_sly_king_burrow_blast_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf" end

function modifier_imba_sly_king_burrow_blast_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_sly_king_burrow_blast_stun:OnCreated()
	if IsServer() then
		self:GetParent():SetRenderColor(105,105,255)

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack02.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:ReleaseParticleIndex(particle)
	end
end

function modifier_imba_sly_king_burrow_blast_stun:OnDestroy()
	if IsServer() then self:GetParent():SetRenderColor(255,255,255) end end

function modifier_imba_sly_king_burrow_blast_stun:CheckState()
	if IsServer() then
		local state = {	[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_FROZEN ] = true	}
		return state
	end
end