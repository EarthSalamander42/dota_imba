-- Editors:
--     Earth Salamander #42, 03.02.2018

storegga_arm_slam = class({})
LinkLuaModifier( "modifier_storegga_arm_slam", "modifier/modifier_storegga_arm_slam", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function storegga_arm_slam:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function storegga_arm_slam:OnAbilityPhaseStart()
	if IsServer() then
		self.animation_time = self:GetSpecialValueFor( "animation_time" )
		self.initial_delay = self:GetSpecialValueFor( "initial_delay" )

		local kv = {}
		kv["duration"] = self.animation_time
		kv["initial_delay"] = self.initial_delay
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_storegga_arm_slam", kv )
	end
	return true
end

--------------------------------------------------------------------------------

function storegga_arm_slam:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_storegga_arm_slam" )
	end
end

--------------------------------------------------------------------------------

function storegga_arm_slam:GetPlaybackRateOverride()
	return 0.5
end

--------------------------------------------------------------------------------

function storegga_arm_slam:GetCastRange( vLocation, hTarget )
	if IsServer() then
		if self:GetCaster():FindModifierByName( "modifier_storegga_arm_slam" ) ~= nil then
			return 99999
		end
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

storegga_avalanche = class({})
LinkLuaModifier( "modifier_storegga_avalanche_thinker", "modifier/modifier_storegga_avalanche_thinker", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------

function storegga_avalanche:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function storegga_avalanche:GetChannelAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_1
end

--------------------------------------------------------------------------------

function storegga_avalanche:GetPlaybackRateOverride()
	return 1
end

--------------------------------------------------------------------------------

function storegga_avalanche:OnAbilityPhaseStart()
	if IsServer() then
		self.nChannelFX = ParticleManager:CreateParticle( "particles/act_2/storegga_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	end
	return true
end

-----------------------------------------------------------------------

function storegga_avalanche:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
	end
end

-----------------------------------------------------------------------

function storegga_avalanche:OnSpellStart()
	if IsServer() then
		self.flChannelTime = 0.0
		self.hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_storegga_avalanche_thinker", { duration = self:GetChannelTime() }, self:GetCaster():GetOrigin(), self:GetCaster():GetTeamNumber(), false )
	end
end

function storegga_avalanche:OnChannelThink( flInterval )
	if IsServer() then
		self.flChannelTime = self.flChannelTime + flInterval
		if self.flChannelTime > 9.2 and self.bStartedGesture ~= true then
			self.bStartedGesture = true
			self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_2_END )
		end
	end
end

-----------------------------------------------------------------------

function storegga_avalanche:OnChannelFinish( bInterrpted )
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
		if self.hThinker ~= nil and self.hThinker:IsNull() == false then
			self.hThinker:ForceKill( false )
		end

	end
end

storegga_grab = class({})
LinkLuaModifier( "modifier_storegga_grab", "modifier/modifier_storegga_grab", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_storegga_grabbed_buff", "modifier/modifier_storegga_grabbed_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_storegga_grabbed_debuff", "modifier/modifier_storegga_grabbed_debuff", LUA_MODIFIER_MOTION_BOTH )

--------------------------------------------------------------------------------

function storegga_grab:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function storegga_grab:OnAbilityPhaseStart()
	if IsServer() then
		if self:GetCaster():FindModifierByName( "modifier_storegga_grabbed_buff" ) ~= nil then
			return
		end
		self.animation_time = self:GetSpecialValueFor( "animation_time" )
		self.initial_delay = self:GetSpecialValueFor( "initial_delay" )

		local kv = {}
		kv["duration"] = self.animation_time
		kv["initial_delay"] = self.initial_delay
		local hBuff = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_storegga_grab", kv )
		if hBuff ~= nil then
			hBuff.hTarget = self:GetCursorTarget()
		end
	end
	return true
end

--------------------------------------------------------------------------------

function storegga_grab:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_storegga_grab" )
	end
end

--------------------------------------------------------------------------------

function storegga_grab:GetPlaybackRateOverride()
	return 0.35
end

--------------------------------------------------------------------------------

function storegga_grab:GetCastRange( vLocation, hTarget )
	if IsServer() then
		if self:GetCaster():FindModifierByName( "modifier_storegga_grab" ) ~= nil then
			return 99999
		end
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

storegga_grab_throw = class({})

--------------------------------------------------------------------------------

function storegga_grab_throw:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function storegga_grab_throw:OnAbilityPhaseStart()
	if IsServer() then

	end
	return true
end

--------------------------------------------------------------------------------

function storegga_grab_throw:OnAbilityPhaseInterrupted()
	if IsServer() then
	--ParticleManager:DestroyParticle( self.nTargetFX, false )
	end
end

--------------------------------------------------------------------------------

function storegga_grab_throw:GetPlaybackRateOverride()
	return 0.7
end

--------------------------------------------------------------------------------

function storegga_grab_throw:OnSpellStart()
	if IsServer() then
		self.hBuff = self:GetCaster():FindModifierByName( "modifier_storegga_grabbed_buff" )
		if self.hBuff == nil then
			return false
		end

		self.hThrowTarget = self.hBuff.hThrowObject
		if self.hThrowTarget == nil then
			self:GetCaster():RemoveModifierByName( "modifier_storegga_grabbed_buff" )
			return false
		end

		self.hThrowBuff = self.hThrowTarget:FindModifierByName( "modifier_storegga_grabbed_debuff" )
		if self.hThrowBuff == nil then
			self:GetCaster():RemoveModifierByName( "modifier_storegga_grabbed_buff" )
			return false
		end

		self.throw_speed = self:GetSpecialValueFor( "throw_speed" )
		self.impact_radius = self:GetSpecialValueFor( "impact_radius" )
		self.stun_duration = self:GetSpecialValueFor( "stun_duration" )
		self.knockback_duration = self:GetSpecialValueFor( "knockback_duration" )
		self.knockback_distance = self:GetSpecialValueFor( "knockback_distance" )
		self.knockback_damage = self:GetSpecialValueFor( "knockback_damage" )
		self.knockback_height = self:GetSpecialValueFor( "knockback_height" )

		if self.hThrowTarget:GetUnitName() == "npc_dota_storegga_rock" then
			self.throw_speed = self.throw_speed * 1.5
			self.impact_radius = self.impact_radius * 0.75
			self.knockback_damage = self.knockback_damage * 0.75
		end
		if self.hThrowTarget:GetUnitName() == "npc_dota_storegga_rock2" then
			self.throw_speed = self.throw_speed * 1
			self.impact_radius = self.impact_radius * 1.25
			self.knockback_damage = self.knockback_damage * 1.5
		end
		if self.hThrowTarget:GetUnitName() == "npc_dota_storegga_rock3" then
			self.throw_speed = self.throw_speed * 0.5
			self.impact_radius = self.impact_radius * 1.5
			self.knockback_damage = self.knockback_damage * 3
		end

		self.vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		self.flDist = self.vDirection:Length2D() - 300 -- the direction is offset due to the attachment point
		self.vDirection.z = 0.0
		self.vDirection = self.vDirection:Normalized()

		self.attach = self:GetCaster():ScriptLookupAttachment( "attach_attack2" )
		self.vSpawnLocation = self:GetCaster():GetAttachmentOrigin( self.attach )
		self.vEndPos = self.vSpawnLocation + self.vDirection * self.flDist

		local info = {
			EffectName = "",
			Ability = self,
			vSpawnOrigin = self.vSpawnLocation,
			fStartRadius = self.impact_radius,
			fEndRadius = self.impact_radius,
			vVelocity = self.vDirection * self.throw_speed,
			fDistance = self.flDist,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO,
		}

		self.hThrowBuff.nProjHandle = ProjectileManager:CreateLinearProjectile( info )
		self.hThrowBuff.flHeight = self.vSpawnLocation.z - GetGroundHeight( self:GetCaster():GetOrigin(), self:GetCaster() )
		self.hThrowBuff.flTime = self.flDist  / self.throw_speed
		self:GetCaster():RemoveModifierByName( "modifier_storegga_grabbed_buff" )
		EmitSoundOn( "Hero_Tiny.Toss.Target", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function storegga_grab_throw:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil then
			return
		end

		--ParticleManager:DestroyParticle( self.nTargetFX, false )

		EmitSoundOnLocationWithCaster( vLocation, "Ability.TossImpact", self:GetCaster() )
		--		EmitSoundOnLocationWithCaster( vLocation, "OgreTank.GroundSmash", self:GetCaster() )

		if self.hThrowTarget ~= nil then
			self.hThrowBuff:Destroy()
			if self.hThrowTarget:IsRealHero() then
				local damageInfo =
					{
						victim = self.hThrowTarget,
						attacker = self:GetCaster(),
						damage = self.knockback_damage / 3,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self,
					}

				ApplyDamage( damageInfo )
				if self.hThrowTarget:IsAlive() == false then
					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, self.hThrowTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hThrowTarget:GetOrigin(), true )
					ParticleManager:SetParticleControl( nFXIndex, 1, self.hThrowTarget:GetOrigin() )
					ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
					ParticleManager:SetParticleControlEnt( nFXIndex, 10, self.hThrowTarget, PATTACH_ABSORIGIN_FOLLOW, nil, self.hThrowTarget:GetOrigin(), true )
					ParticleManager:ReleaseParticleIndex( nFXIndex )

					EmitSoundOn( "Hero_PhantomAssassin.Spatter", self.hThrowTarget )
				else
					self.hThrowTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.stun_duration } )
				end
			end

			local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN, self:GetCaster()  )
			ParticleManager:SetParticleControl( nFXIndex, 0, GetGroundPosition( vLocation, self.hThrowTarget ) )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.impact_radius, self.impact_radius, self.impact_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vLocation, self:GetCaster(), self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false and enemy ~= self.hThrowTarget then
					local damageInfo =
						{
							victim = enemy,
							attacker = self:GetCaster(),
							damage = self.knockback_damage,
							damage_type = DAMAGE_TYPE_PHYSICAL,
							ability = self,
						}

					ApplyDamage( damageInfo )
					if enemy:IsAlive() == false then
						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
						ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
						ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
						ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nFXIndex )

						EmitSoundOn( "Hero_PhantomAssassin.Spatter", enemy )
					else
						local kv =
							{
								center_x = vLocation.x,
								center_y = vLocation.y,
								center_z = vLocation.z,
								should_stun = true,
								duration = self.knockback_duration,
								knockback_duration = self.knockback_duration,
								knockback_distance = self.knockback_distance,
								knockback_height = self.knockback_height,
							}
						enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.knockback_duration } )
					end

				end
			end
		end

		return false
	end
end

-----------------------------------------------------------------------

storegga_passive = class({})
LinkLuaModifier( "modifier_storegga_passive", "modifier/modifier_storegga_passive", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function storegga_passive:GetIntrinsicModifierName()
	return "modifier_storegga_passive"
end

-----------------------------------------------------------------------------------------
