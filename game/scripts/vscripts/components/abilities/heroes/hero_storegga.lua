-- Editors:
--     Earth Salamander #42, 03.02.2018

storegga_arm_slam = class({})
LinkLuaModifier( "modifier_storegga_arm_slam", "components/abilities/heroes/hero_storegga", LUA_MODIFIER_MOTION_NONE )

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
LinkLuaModifier( "modifier_storegga_avalanche_thinker", "components/abilities/heroes/hero_storegga", LUA_MODIFIER_MOTION_NONE )

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
LinkLuaModifier( "modifier_storegga_grab", "components/abilities/heroes/hero_storegga", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_storegga_grabbed_buff", "components/abilities/heroes/hero_storegga", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_storegga_grabbed_debuff", "components/abilities/heroes/hero_storegga", LUA_MODIFIER_MOTION_BOTH )

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
					self.hThrowTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.stun_duration * (1 - self.hThrowTarget:GetStatusResistance()) } )
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
						enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.knockback_duration * (1 - enemy:GetStatusResistance()) } )
					end

				end
			end
		end

		return false
	end
end

-----------------------------------------------------------------------

storegga_passive = class({})
LinkLuaModifier( "modifier_storegga_passive", "components/abilities/heroes/hero_storegga", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function storegga_passive:GetIntrinsicModifierName()
	return "modifier_storegga_passive"
end

-----------------------------------------------------------------------------------------

modifier_storegga_arm_slam = class ({})

--------------------------------------------------------------------------------

function modifier_storegga_arm_slam:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_storegga_arm_slam:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_arm_slam:OnCreated( kv )
	if IsServer() then
		self.damage_radius = self:GetAbility():GetSpecialValueFor( "damage_radius" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
		self.bAttackBegin = false
		self.hHitTargets = {}
		self:StartIntervalThink( kv["initial_delay"] / 2 )
	end
	
end

--------------------------------------------------------------------------------

function modifier_storegga_arm_slam:OnIntervalThink()
	if IsServer() then
		if self.bAttackBegin == false then
			self.bAttackBegin = true
			return
		end
		local attach1 = self:GetParent():ScriptLookupAttachment( "attach_attack1" )
		local attach2 = self:GetParent():ScriptLookupAttachment( "attach_attack1_2" )

		local vLocation1 = self:GetParent():GetAttachmentOrigin( attach1 )
		vLocation1 = GetGroundPosition( vLocation1, self:GetParent() )
		local vLocation2 = self:GetParent():GetAttachmentOrigin( attach2 )
		vLocation2 = GetGroundPosition( vLocation2, self:GetParent() )
		local Locations = {}
		table.insert( Locations, vLocation1 )
		table.insert( Locations, vLocation2 )

		for _,vPos in pairs ( Locations ) do
			local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN,  self:GetCaster()  )
			ParticleManager:SetParticleControl( nFXIndex, 0, vPos )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.damage_radius, self.damage_radius, self.damage_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), vPos, self:GetParent(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false and self:HasHitTarget( enemy ) == false then
					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self,
					}

					ApplyDamage( damageInfo )
					self:AddHitTarget( enemy )
					if enemy:IsAlive() == false then
						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
						ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
						ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
						ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nFXIndex )

						EmitSoundOn( "Dungeon.BloodSplatterImpact", enemy )
						EmitSoundOn( "Hero_PhantomAssassin.Spatter", enemy )
					else
						enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self.stun_duration } )
					end
				end
			end
		end

		EmitSoundOnLocationWithCaster( vLocation1, "Ability.TossImpact", self:GetCaster() )
		self:StartIntervalThink( -1 )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_arm_slam:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_storegga_arm_slam:GetModifierDisableTurning( params )
	if IsServer() then
		if self.bAttackBegin == true then
			return 1
		end
	end
	
	return 0
end

-------------------------------------------------------------------------------

function modifier_storegga_arm_slam:GetModifierTurnRate_Percentage( params )
	return -99
end

--------------------------------------------------------------------------------

function modifier_storegga_arm_slam:HasHitTarget( hTarget )
	for _, target in pairs( self.hHitTargets ) do
		if target == hTarget then
	    	return true
	    end
	end
	
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_arm_slam:AddHitTarget( hTarget )
	table.insert( self.hHitTargets, hTarget )
end


modifier_storegga_avalanche_thinker = class({})

--------------------------------------------------------------------------------

function modifier_storegga_avalanche_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_storegga_avalanche_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_avalanche_thinker:OnCreated( kv )
	if IsServer() then
		self.interval = self:GetAbility():GetSpecialValueFor( "interval" )
		self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.movement = self:GetAbility():GetSpecialValueFor( "movement" )

		self.Avalanches = {}

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		self.hAvalancheTarget = enemies[RandomInt(1, #enemies)]

		self:OnIntervalThink()
		self:StartIntervalThink( self.interval )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_avalanche_thinker:OnIntervalThink()
	if IsServer() then
		if self:GetCaster():IsNull() then
			self:Destroy()
			return
		end

		local vNewAvalancheDir1 = RandomVector( 1 )
		local vNewAvalancheDir2 = RandomVector( 1 )
		if self.hAvalancheTarget ~= nil and self.hAvalancheTarget:IsAlive() then
			vNewAvalancheDir2 = self.hAvalancheTarget:GetOrigin() - self:GetCaster():GetOrigin()
		else
			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
			self.hAvalancheTarget = enemies[RandomInt(1, #enemies)]
			if self.hAvalancheTarget ~= nil then
				vNewAvalancheDir2 = self.hAvalancheTarget:GetOrigin() - self:GetCaster():GetOrigin()
			end
		end
		
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Ability.Avalanche", self:GetCaster() )
	
		vNewAvalancheDir1 = vNewAvalancheDir1:Normalized()
		vNewAvalancheDir2 = vNewAvalancheDir2:Normalized()

		local vRadius = Vector( self.radius * .72, self.radius * .72, self.radius * .72 )
		local nFXIndex1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_tiny/tiny_avalanche.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex1, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex1, 1, vRadius )
		ParticleManager:SetParticleControlForward( nFXIndex1, 0, vNewAvalancheDir1 )
		self:AddParticle( nFXIndex1, false, false, -1, false, false )

		local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_tiny/tiny_avalanche.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex2, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex2, 1, vRadius )
		ParticleManager:SetParticleControlForward( nFXIndex2, 0, vNewAvalancheDir2 )
		self:AddParticle( nFXIndex2, false, false, -1, false, false )

		local Avalanche1 = 
		{
			vCurPos = self:GetCaster():GetOrigin(),
			vDir = vNewAvalancheDir1,
			nFX = nFXIndex1,
		}
		local Avalanche2 = 
		{
			vCurPos = self:GetCaster():GetOrigin(),
			vDir = vNewAvalancheDir2,
			nFX = nFXIndex2,
		}
		
		table.insert( self.Avalanches, Avalanche1 )
		table.insert( self.Avalanches, Avalanche2 )

		for _,ava in pairs ( self.Avalanches ) do
			local vNewPos = ava.vCurPos + ava.vDir * self.movement
			ava.vCurPos = vNewPos

			ParticleManager:SetParticleControl( ava.nFX, 0, vNewPos )


			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vNewPos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsMagicImmune() == false then
					local damageInfo =
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility(),
					}
					ApplyDamage( damageInfo )
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_polar_furbolg_ursa_warrior_thunder_clap", { duration = self.slow_duration } )
				end
			end
		end
	end
end


modifier_storegga_grab = class({})

--------------------------------------------------------------------------------

function modifier_storegga_grab:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_storegga_grab:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_grab:OnCreated( kv )
	if IsServer() then
		self.grab_radius = self:GetAbility():GetSpecialValueFor( "grab_radius" )
		self.min_hold_time = self:GetAbility():GetSpecialValueFor( "min_hold_time" )
		self.max_hold_time = self:GetAbility():GetSpecialValueFor( "max_hold_time" )

		self:StartIntervalThink( kv["initial_delay"] )

		local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/generic_attack_crit_blur.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_grab:OnIntervalThink()
	if IsServer() then
		if self.hTarget == nil then
			return
		end

		local flDist = ( self.hTarget:GetOrigin() - self:GetParent():GetOrigin() ):Length2D()
		if flDist > 700 then
			return
		end
	
		local hBuff = self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_storegga_grabbed_buff", {} )
		if hBuff ~= nil then
			self:GetCaster().flThrowTimer = GameRules:GetGameTime() + RandomFloat( self.min_hold_time, self.max_hold_time )
			hBuff.hThrowObject = self.hTarget
			self.hTarget:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_storegga_grabbed_debuff", {} )		
		end
		self:Destroy()
		return
	end
end


modifier_storegga_grab = class({})

--------------------------------------------------------------------------------

function modifier_storegga_grab:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_storegga_grab:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_grab:OnCreated( kv )
	if IsServer() then
		self.grab_radius = self:GetAbility():GetSpecialValueFor( "grab_radius" )
		self.min_hold_time = self:GetAbility():GetSpecialValueFor( "min_hold_time" )
		self.max_hold_time = self:GetAbility():GetSpecialValueFor( "max_hold_time" )

		self:StartIntervalThink( kv["initial_delay"] )

		local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/generic_attack_crit_blur.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_grab:OnIntervalThink()
	if IsServer() then
		if self.hTarget == nil then
			return
		end

		local flDist = ( self.hTarget:GetOrigin() - self:GetParent():GetOrigin() ):Length2D()
		if flDist > 700 then
			return
		end
	
		local hBuff = self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_storegga_grabbed_buff", {} )
		if hBuff ~= nil then
			self:GetCaster().flThrowTimer = GameRules:GetGameTime() + RandomFloat( self.min_hold_time, self.max_hold_time )
			hBuff.hThrowObject = self.hTarget
			self.hTarget:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_storegga_grabbed_debuff", {} )		
		end
		self:Destroy()
		return
	end
end


modifier_storegga_grabbed_debuff = class({})

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:OnCreated( kv )
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			self:Destroy()
			return
		end

		self.nProjHandle = -1
		self.flTime = 0.0
		self.flHeight = 0.0
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:CheckState()
	local state = 
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		local vLocation = nil
		if self.nProjHandle == -1 then
			local attach = self:GetCaster():ScriptLookupAttachment( "attach_attack2" )
			vLocation = self:GetCaster():GetAttachmentOrigin( attach )
		else
			vLocation = ProjectileManager:GetLinearProjectileLocation( self.nProjHandle )
		end
		vLocation.z = 0.0
		me:SetOrigin( vLocation )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:UpdateVerticalMotion( me, dt )
	if IsServer() then
		local vMyPos = me:GetOrigin()
		if self.nProjHandle == -1 then
			local attach = self:GetCaster():ScriptLookupAttachment( "attach_attack2" )
			local vLocation = self:GetCaster():GetAttachmentOrigin( attach )
			vMyPos.z = vLocation.z
		else
			local flGroundHeight = GetGroundHeight( vMyPos, me )
			local flHeightChange = dt * self.flTime * self.flHeight * 1.3
			vMyPos.z = math.max( vMyPos.z - flHeightChange, flGroundHeight )
		end
		me:SetOrigin( vMyPos )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetCaster() then
			self:Destroy()
		end
	end

	return 0
end

modifier_storegga_passive = modifier_storegga_passive or class({})
