-- Editors:
--    AltiV, June 22nd, 2019
-- Primary Idea Giver:
--    Flat is Justice / SnowyFang

LinkLuaModifier("modifier_imba_grimstroke_dark_artistry_extend", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_grimstroke_dark_artistry_slow", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_grimstroke_dark_artistry_ink_line", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_grimstroke_ink_creature_thinker", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_grimstroke_ink_creature_vision", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_grimstroke_ink_creature", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_grimstroke_ink_creature_debuff", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_grimstroke_spirit_walk_buff", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_grimstroke_spirit_walk_debuff", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_grimstroke_ink_gods_incarnation", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_imba_grimstroke_soul_chain", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_grimstroke_soul_chain_vanilla_enhancer", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_grimstroke_soul_chain_vanilla_enhancer_slow", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)

imba_grimstroke_dark_artistry					= class({})
modifier_imba_grimstroke_dark_artistry_extend	= class({})
modifier_imba_grimstroke_dark_artistry_slow		= class({})
modifier_imba_grimstroke_dark_artistry_ink_line	= class({})

imba_grimstroke_ink_creature					= class({})
-- This applies on the phantom and handles the phantom's particles/animations and how it takes damage
modifier_imba_grimstroke_ink_creature_thinker	= class({})
-- This applies on the enemy and provides vision
modifier_imba_grimstroke_ink_creature_vision	= class({})
-- This applies on the enemy and handles the silence/mute
modifier_imba_grimstroke_ink_creature			= class({})
-- This applies on the enemy and counts "modifier_imba_grimstroke_ink_creature" modifiers and handles damage instances
modifier_imba_grimstroke_ink_creature_debuff	= class({})

imba_grimstroke_spirit_walk						= class({})
modifier_imba_grimstroke_spirit_walk_buff		= class({})
modifier_imba_grimstroke_spirit_walk_debuff		= class({})

imba_grimstroke_ink_gods_incarnation			= class({})
modifier_imba_grimstroke_ink_gods_incarnation	= class({})

-- imba_grimstroke_soul_chain						= class({})
-- modifier_imba_grimstroke_soul_chain				= class({})

-- This modifies the vanilla Soulbind, until (if ever) a truly correct custom Soulbind is implemented
imba_grimstroke_soul_chain_vanilla_enhancer					= class({})
modifier_imba_grimstroke_soul_chain_vanilla_enhancer		= class({})
modifier_imba_grimstroke_soul_chain_vanilla_enhancer_slow	= class({})

--------------------
-- STROKE OF FATE --
--------------------

-- IMBAfication: My Brush Extends
function imba_grimstroke_dark_artistry:GetIntrinsicModifierName()
	return "modifier_imba_grimstroke_dark_artistry_extend"
end

function imba_grimstroke_dark_artistry:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

function imba_grimstroke_dark_artistry:GetCastRange(location, target)
	return self:GetTalentSpecialValueFor("range_tooltip") + self:GetCaster():GetModifierStackCount("modifier_imba_grimstroke_dark_artistry_extend", self:GetCaster())
end

function imba_grimstroke_dark_artistry:GetCooldown(level)
	if self:GetCaster():HasModifier("modifier_imba_grimstroke_dark_artistry_ink_line") then
		return self.BaseClass.GetCooldown(self, level) + self:GetSpecialValueFor("ink_lines_cd_increase")
	else
		return self.BaseClass.GetCooldown(self, level)
	end
end

function imba_grimstroke_dark_artistry:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Grimstroke.DarkArtistry.PreCastPoint")
	
	self.precast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_cast2_ground.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.precast_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
	
	return true
end

function imba_grimstroke_dark_artistry:OnAbilityPhaseInterrupted()
	self:GetCaster():StopSound("Hero_Grimstroke.DarkArtistry.PreCastPoint")
	
	if self.precast_particle then
		ParticleManager:DestroyParticle(self.precast_particle, true)
		ParticleManager:ReleaseParticleIndex(self.precast_particle)
		self.precast_particle = nil
	end
end

function imba_grimstroke_dark_artistry:OnSpellStart()
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

	self:GetCaster():StopSound("Hero_Grimstroke.DarkArtistry.PreCastPoint")
	
	self:GetCaster():EmitSound("Hero_Grimstroke.DarkArtistry.Cast")
	self:GetCaster():EmitSound("Hero_Grimstroke.DarkArtistry.Cast.Layer")
	
	if self:GetCaster():GetName() == "npc_dota_hero_grimstroke" and RollPercentage(50) then
		if not self.responses then
			self.responses = 
			{
				["grimstroke_grimstroke_attack_12_02"] = 0,
				["grimstroke_grimstroke_ability3_01"] = 0,
				["grimstroke_grimstroke_ability3_02"] = 0,
				["grimstroke_grimstroke_ability3_04"] = 0,
				["grimstroke_grimstroke_ability3_05"] = 0,
				["grimstroke_grimstroke_ability3_06"] = 0,
				["grimstroke_grimstroke_ability3_07"] = 0, -- This one is supposed to play separately at a 10% chance but like...come on
				["grimstroke_grimstroke_ability3_08"] = 0,
				["grimstroke_grimstroke_ability3_09"] = 0,
				["grimstroke_grimstroke_ability3_10"] = 0,
				["grimstroke_grimstroke_ability3_11"] = 0
			}
		end

		for response, timer in pairs(self.responses) do
			if GameRules:GetDOTATime(true, true) - timer >= 120 then
				self:GetCaster():EmitSound(response)
				self.responses[response] = GameRules:GetDOTATime(true, true)
				break
			end
		end
	end
	
	if self.precast_particle then
		ParticleManager:ReleaseParticleIndex(self.precast_particle)
		self.precast_particle = nil
	end
	
	local offset_start_vector = self:GetCaster():GetRightVector() * 120 * (-1)
	
	-- "The ink trail starts 120 range towards Grimstroke's left side and travels towards the targeted point."
	local projectile_start_location = self:GetCaster():GetAbsOrigin() + offset_start_vector
	
	-- Start Location, End Location, Primary Projectile
	self:Stroke(projectile_start_location, self:GetCursorPosition(), true, self:GetAutoCastState())
	
	if self:GetCaster():FindModifierByNameAndCaster("modifier_imba_grimstroke_ink_gods_incarnation", self:GetCaster()) then
		for extra_strokes = 1, 3 do
			local start_position	= RotatePosition(self:GetCaster():GetAbsOrigin(), QAngle(0, 90 * extra_strokes, 0), projectile_start_location)
			local end_position		= RotatePosition(self:GetCaster():GetAbsOrigin(), QAngle(0, 90 * extra_strokes, 0), self:GetCursorPosition())
			
			self:Stroke(start_position, end_position, true)
		end
	end
end

function imba_grimstroke_dark_artistry:Stroke(start_location, end_position, bPrimary, bMain)
	if start_location == end_position then
		end_position = end_position + self:GetCaster():GetForwardVector()
	end
	
	-- Create a modifier thinker to attach the sound to, as well as keep track of accumulating damage within one stroke
	local stroke_dummy = CreateModifierThinker(self:GetCaster(), self, nil, {}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	stroke_dummy:EmitSound("Hero_Grimstroke.DarkArtistry.Projectile")
	stroke_dummy.hit_units = 0
	
	local velocity = (end_position - start_location):Normalized() * self:GetSpecialValueFor("projectile_speed")
	
	local info = {
		Ability				= self,
		EffectName			= "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_proj.vpcf",
		vSpawnOrigin		= start_location,
		fDistance			= self:GetTalentSpecialValueFor("range_tooltip") + GetCastRangeIncrease(self:GetCaster()) + self:GetCaster():GetModifierStackCount("modifier_imba_grimstroke_dark_artistry_extend", self:GetCaster()),
		fStartRadius		= self:GetSpecialValueFor("start_radius"),
		fEndRadius			= self:GetSpecialValueFor("end_radius"),
		Source				= self:GetCaster(),
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime 		= GameRules:GetGameTime() + 10.0,
		bDeleteOnHit		= false,
		vVelocity			= Vector(velocity.x, velocity.y, 0),
		bProvidesVision		= true,
		iVisionRadius 		= self:GetSpecialValueFor("end_radius"),
		iVisionTeamNumber 	= self:GetCaster():GetTeamNumber(),
		
		ExtraData			= 
		{
			stroke_dummy	= stroke_dummy:entindex(),
			bPrimary		= bPrimary,
			bMain			= bMain
		}
	}
	
	local projectile = ProjectileManager:CreateLinearProjectile(info)
end

-- Make the travel sound follow the stroke
function imba_grimstroke_dark_artistry:OnProjectileThink_ExtraData(location, data)
	if not IsServer() then return end
	
	if data.stroke_dummy then
		EntIndexToHScript(data.stroke_dummy):SetAbsOrigin(location)
	end
end

function imba_grimstroke_dark_artistry:OnProjectileHit_ExtraData(target, location, data)
	if not IsServer() then return end
	
	-- "Provides 160 radius ground vision at every hit enemy's location and at the end location of the projectile, which lasts for 2 seconds."
	self:CreateVisibilityNode(location, self:GetSpecialValueFor("end_radius"), 2)
	
	-- Stroke of Fate hit some unit
	if target then
		if not target:IsCreep() then
			target:EmitSound("Hero_Grimstroke.DarkArtistry.Damage")
		else
			target:EmitSound("Hero_Grimstroke.DarkArtistry.Damage.Creep")
		end
		
		local stroke_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_demonartist/demonartist_darkartistry_dmg.vpcf", PATTACH_ABSORIGIN, target)
		ParticleManager:ReleaseParticleIndex(stroke_particle)
		
		-- "Stroke of Fate first applies the damage, then the debuff."
		local damageTable = {
			victim 			= target,
			damage 			= (self:GetSpecialValueFor("damage") + (self:GetSpecialValueFor("bonus_damage_per_target") * EntIndexToHScript(data.stroke_dummy).hit_units)) * math.max(1 + (self:GetCaster():FindTalentValue("special_bonus_imba_grimstroke_stroke_of_fate_damage") * 0.01), 1),
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}

		ApplyDamage(damageTable)
		
		-- Increment the amount of hit units to deal more damage against further targets
		EntIndexToHScript(data.stroke_dummy).hit_units = EntIndexToHScript(data.stroke_dummy).hit_units + 1
		
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_grimstroke_dark_artistry_slow", {duration = self:GetSpecialValueFor("slow_duration") * (1 - target:GetStatusResistance())})
		
		if data.bPrimary == 1 then
			-- IMBAfication: Your Stain Spreads
			if EntIndexToHScript(data.stroke_dummy).hit_units == 1 then
				-- local counter = 0
			
				local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("stain_spread_max_distance"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)

				for _, enemy in pairs(enemies) do
					-- Using vanilla Soulbind modifier name for now
					-- if target ~= enemy and ((target:GetAbsOrigin() - enemy:GetAbsOrigin()):Length2D() >= self:GetSpecialValueFor("stain_spread_min_distance") or (target:FindModifierByNameAndCaster("modifier_grimstroke_soul_chain", self:GetCaster()))) then
					
					if target ~= enemy and target:FindModifierByNameAndCaster("modifier_grimstroke_soul_chain", self:GetCaster()) and enemy:FindModifierByNameAndCaster("modifier_grimstroke_soul_chain", self:GetCaster()) then
					
						self:Stroke(target:GetAbsOrigin(), enemy:GetAbsOrigin(), false)
						
						-- if not target:FindModifierByNameAndCaster("modifier_grimstroke_soul_chain", self:GetCaster()) then
							-- counter = counter + 1
						-- end
						
						-- if counter >= self:GetSpecialValueFor("stain_spread_max_units") then
							-- break
						-- end
					end
				end
			end
			
			-- IMBAfication: My Brush Extends
			if (target:IsRealHero() or target:IsClone()) and self:GetIntrinsicModifierName() then
				local brush_extend_modifier = self:GetCaster():FindModifierByNameAndCaster(self:GetIntrinsicModifierName(), self:GetCaster())
				
				if brush_extend_modifier then
					brush_extend_modifier:SetStackCount(brush_extend_modifier:GetStackCount() + self:GetSpecialValueFor("brush_extend_range_per_hero"))
				end
			end
		end
	-- Stroke of Fate has reached its end location
	elseif data.stroke_dummy then
		EntIndexToHScript(data.stroke_dummy):RemoveSelf()
		
		-- IMBAfication: The Ink Lines Flow
		if location and data.bMain == 1 then
			local warp_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_ink_lines_warp.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
			ParticleManager:SetParticleControl(warp_particle, 0, self:GetCaster():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(warp_particle)
			
			FindClearSpaceForUnit(self:GetCaster(), location, false)
			
			warp_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_ink_lines_warp.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
			ParticleManager:SetParticleControl(warp_particle, 0, self:GetCaster():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(warp_particle)
		end
	end
end

------------------------------------
-- STROKE OF FATE EXTEND MODIFIER --
------------------------------------

function modifier_imba_grimstroke_dark_artistry_extend:IsHidden()	return self:GetAbility():GetLevel() == 0 end

-- Probably not needed but just in case?
function modifier_imba_grimstroke_dark_artistry_extend:OnCreated()
	if not IsServer() then return end
	
	self:SetStackCount(0)
end


function modifier_imba_grimstroke_dark_artistry_extend:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ORDER}	
end

function modifier_imba_grimstroke_dark_artistry_extend:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end
	
	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:GetParent():RemoveModifierByName("modifier_imba_grimstroke_dark_artistry_ink_line")
	else
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_grimstroke_dark_artistry_ink_line", {})
	end
end

----------------------------------
-- STROKE OF FATE SLOW MODIFIER --
----------------------------------

function modifier_imba_grimstroke_dark_artistry_slow:GetEffectName()
	return "particles/units/heroes/hero_grimstroke/grimstroke_dark_artistry_debuff.vpcf"
end

function modifier_imba_grimstroke_dark_artistry_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_grimstroke_dark_artistry.vpcf"
end

function modifier_imba_grimstroke_dark_artistry_slow:OnCreated()
	if self:GetAbility() then
		self.movement_slow_pct	= self:GetAbility():GetSpecialValueFor("movement_slow_pct")
	else
		self:Destroy()
	end
end

function modifier_imba_grimstroke_dark_artistry_slow:OnRefresh()
	self:OnCreated()
end

function modifier_imba_grimstroke_dark_artistry_slow:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	
	return decFuncs
end

function modifier_imba_grimstroke_dark_artistry_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow_pct * (-1)
end

--------------------------------------
-- STROKE OF FATE INK LINE MODIFIER --
--------------------------------------

function modifier_imba_grimstroke_dark_artistry_ink_line:IsHidden()			return true end
function modifier_imba_grimstroke_dark_artistry_ink_line:IsPurgable()		return false end
function modifier_imba_grimstroke_dark_artistry_ink_line:RemoveOnDeath()	return false end

-----------------------
-- PHANTOM'S EMBRACE --
-----------------------

function imba_grimstroke_ink_creature:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

-- Probably need to switch projectile out for a horizontal mover later since it needs to latch at 130 distance rather than actual overlap
-- However, there's so much other weird stuff going on with the vanilla ability that this might not be feasible)
function imba_grimstroke_ink_creature:OnSpellStart()
	-- Yes, this is needed so we don't get Soulbind errors (cause self:GetCursorTarget() goes nil on the duplication)
	local target = self:GetCursorTarget()
	
	if target:TriggerSpellAbsorb(self) then return end
	
	local vision_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_grimstroke_ink_creature_vision", {})
	
	if self:GetCaster():GetName() == "npc_dota_hero_grimstroke" and RollPercentage(50) then
		if not self.responses then
			self.responses = 
			{
				["grimstroke_grimstroke_ability1_01"] = 0,
				["grimstroke_grimstroke_ability1_02"] = 0,
				["grimstroke_grimstroke_ability1_03"] = 0,
				["grimstroke_grimstroke_ability1_04"] = 0,
				["grimstroke_grimstroke_ability1_05"] = 0,
				["grimstroke_grimstroke_ability1_06"] = 0,
				["grimstroke_grimstroke_ability1_07"] = 0,
				["grimstroke_grimstroke_ability1_08"] = 0,
				["grimstroke_grimstroke_ability1_09"] = 0,
				["grimstroke_grimstroke_ability1_10"] = 0,
				["grimstroke_grimstroke_ability1_11"] = 0,
				["grimstroke_grimstroke_ability1_12"] = 0
			}
		end

		for response, timer in pairs(self.responses) do
			if GameRules:GetDOTATime(true, true) - timer >= 120 then
				self:GetCaster():EmitSound(response)
				self.responses[response] = GameRules:GetDOTATime(true, true)
				break
			end
		end
	end
	
	-- Need these variables due to using a timer
	local ability					= self
	local caster					= self:GetCaster()
	local target					= target
	
	local speed 					= self:GetSpecialValueFor("speed")
	local latch_unit_offset_short	= self:GetSpecialValueFor("latched_unit_offset_short")
	
	Timers:CreateTimer(self:GetSpecialValueFor("spawn_time"), function()
		caster:EmitSound("Hero_Grimstroke.InkCreature.Cast")
		
		local ink_unit = CreateUnitByName("npc_dota_grimstroke_ink_creature", self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * self:GetSpecialValueFor("latched_unit_offset_short"), false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		
		ink_unit:EmitSound("Hero_Grimstroke.InkCreature.Cast")
		ink_unit:AddNewModifier(caster, ability, "modifier_imba_grimstroke_ink_creature_thinker", 
		{
			destroy_attacks			= self:GetTalentSpecialValueFor("destroy_attacks"),
			hero_attack_multiplier	= self:GetSpecialValueFor("hero_attack_multiplier"),
			target_entindex			= target:entindex()
		})
		ink_unit:SetForwardVector((target:GetAbsOrigin() - ink_unit:GetAbsOrigin()):Normalized())
		
			
		local phantoms_embrace_particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_grimstroke/grimstroke_phantom_marker.vpcf", PATTACH_OVERHEAD_FOLLOW, target, self:GetCaster():GetTeamNumber())
		
		local projectile =
		{
			Target 				= target,
			Source 				= caster,
			Ability 			= ability,
			--EffectName 			= self:GetCaster():GetRangedProjectileName() or "particles/units/heroes/hero_puck/puck_base_attack.vpcf",
			iMoveSpeed			= speed,
			vSourceLoc 			= caster:GetAbsOrigin() + caster:GetForwardVector() * latch_unit_offset_short,
			bDrawsOnMinimap 	= false,
			bDodgeable 			= false,
			bIsAttack 			= false,
			bVisibleToEnemies 	= true,
			bReplaceExisting 	= false,
			flExpireTime 		= GameRules:GetGameTime() + 10.0,
			bProvidesVision 	= true,
			iVisionRadius 		= 400, -- IDK if there's some number to refer to
			iVisionTeamNumber 	= caster:GetTeamNumber(),
			
			ExtraData = {
				ink_unit_entindex			= ink_unit:entindex(),
				target_entindex				= target:entindex(),
				phantoms_embrace_particle	= phantoms_embrace_particle
			}
		}
		
		ProjectileManager:CreateTrackingProjectile(projectile)
	end)
end

function imba_grimstroke_ink_creature:OnProjectileThink_ExtraData(location, data)
	if not IsServer() then return end
	
	if not data.returning and data.ink_unit_entindex and EntIndexToHScript(data.ink_unit_entindex) then
		if EntIndexToHScript(data.ink_unit_entindex):IsAlive() then
			EntIndexToHScript(data.ink_unit_entindex):SetAbsOrigin(location)
			EntIndexToHScript(data.ink_unit_entindex):FaceTowards(EntIndexToHScript(data.target_entindex):GetAbsOrigin())
		else
			-- Destroy the vision particle early if the phantom is killed mid-air while moving towards target
			ParticleManager:DestroyParticle(data.phantoms_embrace_particle, false)
			ParticleManager:ReleaseParticleIndex(data.phantoms_embrace_particle)
		end
	end

	-- ChangeTrackingProjectileSpeed(arg1: handle, arg2: int): nil
end

function imba_grimstroke_ink_creature:OnProjectileHit_ExtraData(target, location, data)
	if not IsServer() then return end

	if data.phantoms_embrace_particle then
		ParticleManager:DestroyParticle(data.phantoms_embrace_particle, false)
		ParticleManager:ReleaseParticleIndex(data.phantoms_embrace_particle)
	end
	
	if target then
		if target ~= self:GetCaster() and data.ink_unit_entindex and EntIndexToHScript(data.ink_unit_entindex) and EntIndexToHScript(data.ink_unit_entindex):IsAlive() then
			if target:IsInvulnerable() or target:IsOutOfGame() or not target:IsAlive() then
				local projectile =
				{
					Target 				= self:GetCaster(),
					Source 				= EntIndexToHScript(data.ink_unit_entindex),
					Ability 			= self,
					EffectName 			= "particles/units/heroes/hero_grimstroke/grimstroke_phantom_return.vpcf",
					iMoveSpeed			= self:GetSpecialValueFor("return_projectile_speed"),
					vSourceLoc 			= EntIndexToHScript(data.ink_unit_entindex):GetAbsOrigin(),
					bDrawsOnMinimap 	= false,
					bDodgeable 			= true,
					bIsAttack 			= false,
					bVisibleToEnemies 	= true,
					bReplaceExisting 	= false,
					flExpireTime 		= GameRules:GetGameTime() + 10.0,
					bProvidesVision 	= false,
					
					ExtraData = {
						returning		= true
					}
				}	

				ProjectileManager:CreateTrackingProjectile(projectile)

				EntIndexToHScript(data.ink_unit_entindex):ForceKill(false)
				EntIndexToHScript(data.ink_unit_entindex):AddNoDraw()
			else
				target:EmitSound("Hero_Grimstroke.InkCreature.Attach")

				-- Apply the silence modifier
				target:AddNewModifier(EntIndexToHScript(data.ink_unit_entindex), self, "modifier_imba_grimstroke_ink_creature", 
					{
						duration 			= self:GetSpecialValueFor("latch_duration") * (1 - target:GetStatusResistance()),
						latched_unit_offset	= self:GetSpecialValueFor("latched_unit_offset"),
						ink_unit_entindex	= data.ink_unit_entindex
					})
				
				-- Check the ink creature's own handler modifier
				local ink_modifier	= EntIndexToHScript(data.ink_unit_entindex):FindModifierByNameAndCaster("modifier_imba_grimstroke_ink_creature_thinker", self:GetCaster())
				
				if ink_modifier then
					-- This seems pretty sketch, but it's to switch animations while retaining a modifier (although two modifiers would have been fine I guess...)
					ink_modifier:SetStackCount(0)
				end
				
				-- Apply the silence counting modifier
				target:AddNewModifier(EntIndexToHScript(data.ink_unit_entindex), self, "modifier_imba_grimstroke_ink_creature_debuff", 
					{
						duration 			= self:GetSpecialValueFor("latch_duration") * (1 - target:GetStatusResistance()),
					})
			end
		else
			-- Refresh cooldown
			self:GetCaster():EmitSound("Hero_Grimstroke.InkCreature.Returned")
			
			self:EndCooldown()
		end
	else

	end
end

----------------------------------------
-- PHANTOM'S EMBRACE THINKER MODIFIER --
----------------------------------------

function modifier_imba_grimstroke_ink_creature_thinker:IsHidden()	return true end
function modifier_imba_grimstroke_ink_creature_thinker:IsPurgable()	return false end

function modifier_imba_grimstroke_ink_creature_thinker:OnCreated(params)
	if not IsServer() then return end

	self.destroy_attacks			= params.destroy_attacks
	self.hero_attack_multiplier		= params.hero_attack_multiplier
	self.target						= EntIndexToHScript(params.target_entindex)

	-- Calculate health chunks that the unit will lose on getting attacked
	self.health_increments		= self:GetParent():GetMaxHealth() / self.destroy_attacks

	if self:GetAbility() and self:GetCaster():FindAbilityByName(self:GetAbility():GetName()):GetAutoCastState() then
		self:SetStackCount(2)
	else
		self:SetStackCount(1)
	end
	
	local phantoms_embrace_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_phantom_ambient.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(phantoms_embrace_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(phantoms_embrace_particle, false, false, -1, false, false)
end

function modifier_imba_grimstroke_ink_creature_thinker:GetStatusEffectName()
	if self:GetStackCount() == 2 then
		return "particles/status_fx/status_effect_dark_willow_wisp_fear.vpcf"
	end
end

function modifier_imba_grimstroke_ink_creature_thinker:OnDestroy()
	if not IsServer() then return end
	
	if self.target and self.target:FindModifierByNameAndCaster("modifier_imba_grimstroke_ink_creature", self:GetParent()) then
		self.target:RemoveModifierByNameAndCaster("modifier_imba_grimstroke_ink_creature", self:GetParent())
	end
	
	if self.target and self.target:FindModifierByNameAndCaster("modifier_imba_grimstroke_ink_creature_vision", self:GetCaster()) then
		self.target:RemoveModifierByNameAndCaster("modifier_imba_grimstroke_ink_creature_vision", self:GetCaster())
	end	
end

function modifier_imba_grimstroke_ink_creature_thinker:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		
		MODIFIER_EVENT_ON_ATTACKED
    }

    return decFuncs
end

-- These aren't working right now
function modifier_imba_grimstroke_ink_creature_thinker:GetOverrideAnimation()
	if self:GetStackCount() == 0 then
		return ACT_DOTA_ATTACK
	else
		return ACT_DOTA_RUN
	end
end

function modifier_imba_grimstroke_ink_creature_thinker:GetActivityTranslationModifiers()
	if self:GetStackCount() == 0 then
		return "ink_creature_latched"
	end
end

function modifier_imba_grimstroke_ink_creature_thinker:GetAbsoluteNoDamageMagical()
    return 1
end

function modifier_imba_grimstroke_ink_creature_thinker:GetAbsoluteNoDamagePhysical()
    return 1
end

function modifier_imba_grimstroke_ink_creature_thinker:GetAbsoluteNoDamagePure()
    return 1
end

function modifier_imba_grimstroke_ink_creature_thinker:OnAttacked(keys)
    if not IsServer() then return end
	
	if keys.target == self:GetParent() then
		
		if keys.attacker:IsHero() then
			self:GetParent():SetHealth(self:GetParent():GetHealth() - (self.health_increments * self.hero_attack_multiplier))
		else
			self:GetParent():SetHealth(self:GetParent():GetHealth() - self.health_increments)
		end
		
		if self:GetParent():GetHealth() <= 0 then
			self:GetParent():EmitSound("Hero_Grimstroke.InkCreature.Death")
		
			self:GetParent():Kill(nil, keys.attacker)
			self:Destroy()
		end
	end
end

---------------------------------------
-- PHANTOM'S EMBRACE VISION MODIFIER --
---------------------------------------

function modifier_imba_grimstroke_ink_creature_vision:IsHidden()	return true end
function modifier_imba_grimstroke_ink_creature_vision:IsPurgable()	return false end
function modifier_imba_grimstroke_ink_creature_vision:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_grimstroke_ink_creature_vision:OnCreated()
	if not IsServer() then return end
end

function modifier_imba_grimstroke_ink_creature_vision:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION}
	
	return decFuncs
end

function modifier_imba_grimstroke_ink_creature_vision:GetModifierProvidesFOWVision()
	return 1
end

--------------------------------
-- PHANTOM'S EMBRACE MODIFIER --
--------------------------------

function modifier_imba_grimstroke_ink_creature:IsHidden()		return true end
function modifier_imba_grimstroke_ink_creature:IsPurgable()		return false end
function modifier_imba_grimstroke_ink_creature:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_grimstroke_ink_creature:OnCreated(params)
	self.return_projectile_speed	= self:GetAbility():GetSpecialValueFor("return_projectile_speed")
	self.pop_damage					= self:GetAbility():GetSpecialValueFor("pop_damage")

	if not IsServer() then return end
	
	self.damage_type			= self:GetAbility():GetAbilityDamageType()
	
	self.latched_unit_offset	= params.latched_unit_offset
	self.ink_unit				= EntIndexToHScript(params.ink_unit_entindex)
	
	if self.ink_unit and self.ink_unit:FindModifierByName("modifier_imba_grimstroke_ink_creature_thinker") then
		self:SetStackCount(self.ink_unit:FindModifierByName("modifier_imba_grimstroke_ink_creature_thinker"):GetStackCount())
	end
	
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_grimstroke_ink_creature:OnIntervalThink()
	if not IsServer() then return end

	if self.ink_unit and self.ink_unit:IsAlive() then
		if self:GetParent():IsInvulnerable() or self:GetParent():IsMagicImmune() or self:GetParent():IsOutOfGame() then
			self:Destroy()
		else
			self.ink_unit:SetAbsOrigin(self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * self.latched_unit_offset)
			self.ink_unit:SetForwardVector((self:GetParent():GetAbsOrigin() - self.ink_unit:GetAbsOrigin()):Normalized())
		end
	else
		self:StartIntervalThink(-1)
	end
end

function modifier_imba_grimstroke_ink_creature:OnDestroy()
	if not IsServer() then return end

	local ink_creature_counter = self:GetParent():FindModifierByName("modifier_imba_grimstroke_ink_creature_debuff")
	
	if ink_creature_counter then
		ink_creature_counter:DecrementStackCount()
		
		if ink_creature_counter:GetStackCount() == 0 then
			ink_creature_counter:Destroy()
		end
	end

	-- IMBAfication: Sentient Bond
	if self.ink_unit and self.ink_unit:IsAlive() then
		self:Return()
	end
	
	if self:GetRemainingTime() <= 0 then
		self:GetParent():EmitSound("Hero_Grimstroke.InkCreature.Damage")
	
		-- "The phantom returns to Grimstroke upon expiring, or when its target dies. It does not return when it gets killed."
		local damageTable = {
			victim 			= self:GetParent(),
			damage 			= self.pop_damage,
			damage_type		= self.damage_type,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster():GetOwner(),
			ability 		= self:GetAbility()
		}

		ApplyDamage(damageTable)
	end
end

function modifier_imba_grimstroke_ink_creature:Return()
	if self.ink_unit and self.ink_unit:IsAlive() and self:GetCaster():GetOwner() then
		local projectile =
		{
			Target 				= self:GetCaster():GetOwner(),
			Source 				= self.ink_unit,
			Ability 			= self:GetAbility(),
			EffectName 			= "particles/units/heroes/hero_grimstroke/grimstroke_phantom_return.vpcf",
			iMoveSpeed			= self.return_projectile_speed,
			vSourceLoc 			= self.ink_unit:GetAbsOrigin(),
			bDrawsOnMinimap 	= false,
			bDodgeable 			= true,
			bIsAttack 			= false,
			bVisibleToEnemies 	= true,
			bReplaceExisting 	= false,
			flExpireTime 		= GameRules:GetGameTime() + 10.0,
			bProvidesVision 	= false,
			
			ExtraData = {
				returning		= true
			}
		}	

		ProjectileManager:CreateTrackingProjectile(projectile)
		
		-- The unit doesn't actually get deleted in vanilla so...
		self.ink_unit:ForceKill(false)
		self.ink_unit:AddNoDraw()
		-- self.ink_unit:RemoveSelf()
	end
end

function modifier_imba_grimstroke_ink_creature:CheckState()
	local state = {}
	
	if self:GetStackCount() == 1 then
		state[MODIFIER_STATE_SILENCED] = true
	else
		state[MODIFIER_STATE_MUTED] = true
	end
	
	return state
end

---------------------------------------
-- PHANTOM'S EMBRACE DEBUFF MODIFIER --
---------------------------------------

-- This deals with damage summation in the case of mulitple phantoms

function modifier_imba_grimstroke_ink_creature_debuff:OnCreated(params)
	self.damage_per_tick	= self:GetAbility():GetSpecialValueFor("damage_per_tick")
	self.tick_interval		= self:GetAbility():GetSpecialValueFor("tick_interval")
	
	if not IsServer() then return end
	
	self.damage_type		= self:GetAbility():GetAbilityDamageType()
	
	self:IncrementStackCount()
	
	self:StartIntervalThink(self.tick_interval * (1 - self:GetParent():GetStatusResistance()))
end

function modifier_imba_grimstroke_ink_creature_debuff:OnRefresh()
	if not IsServer() then return end
	
	self:OnCreated()
end

function modifier_imba_grimstroke_ink_creature_debuff:OnIntervalThink()
	if not IsServer() then return end
	
	self:GetParent():EmitSound("Hero_Grimstroke.InkCreature.Attack")
	
	local damageTable = {
		victim 			= self:GetParent(),
		damage 			= self.damage_per_tick * self:GetStackCount(),
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster():GetOwner(),
		ability 		= self:GetAbility()
	}

	ApplyDamage(damageTable)
end

function modifier_imba_grimstroke_ink_creature_debuff:OnDestroy()
	if not IsServer() then return end
	
	local vision_modifier	= self:GetParent():FindModifierByNameAndCaster("modifier_imba_grimstroke_ink_creature_vision", self:GetCaster())
	
	if vision_modifier then
		vision_modifier:Destroy()
	end
end

---------------
-- INK SWELL --
---------------

function imba_grimstroke_spirit_walk:CastFilterResultTarget(target)
	if target:HasModifier("modifier_imba_grimstroke_ink_gods_incarnation") then
		return UF_FAIL_CUSTOM
	end
	
	return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
end

function imba_grimstroke_spirit_walk:GetCustomCastErrorTarget(target)
	if target:HasModifier("modifier_imba_grimstroke_ink_gods_incarnation") then
		return "#dota_hud_error_target_has_ink_gods_incarnation"
	end
end

function imba_grimstroke_spirit_walk:OnSpellStart()
	-- Yes, this is needed so we don't get Soulbind errors (cause self:GetCursorTarget() goes nil on the duplication)
	local target = self:GetCursorTarget()

	if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and target:TriggerSpellAbsorb(self) then return end
	
	self:GetCaster():EmitSound("Hero_Grimstroke.InkSwell.Cast")

	local ink_swell_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_cast_ink_swell.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControlEnt(ink_swell_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(ink_swell_particle)

	if self:GetCaster():GetName() == "npc_dota_hero_grimstroke" and RollPercentage(50) then
		if not self.responses_target or not self.responses_self then
			self.responses_target = 
			{
				["grimstroke_grimstroke_ability2_01"] = 0,
				["grimstroke_grimstroke_ability2_02"] = 0,
				["grimstroke_grimstroke_ability2_04"] = 0,
				["grimstroke_grimstroke_ability2_06"] = 0,
				["grimstroke_grimstroke_ability2_07"] = 0,
				["grimstroke_grimstroke_ability2_11"] = 0,
				["grimstroke_grimstroke_ability3_03"] = 0,
				
				["grimstroke_grimstroke_ability2_08"] = 0,
			}
			
			self.responses_self = 
			{
				["grimstroke_grimstroke_ability2_01"] = 0,
				["grimstroke_grimstroke_ability2_02"] = 0,
				["grimstroke_grimstroke_ability2_04"] = 0,
				["grimstroke_grimstroke_ability2_06"] = 0,
				["grimstroke_grimstroke_ability2_07"] = 0,
				["grimstroke_grimstroke_ability2_11"] = 0,
				["grimstroke_grimstroke_ability3_03"] = 0,
				
				["grimstroke_grimstroke_ability2_03"] = 0,
				["grimstroke_grimstroke_ability2_09"] = 0,
				["grimstroke_grimstroke_ability2_10"] = 0,
			}
		end

		if target ~= self:GetCaster() then
			for response, timer in pairs(self.responses_target) do
				if GameRules:GetDOTATime(true, true) - timer >= 120 then
					self:GetCaster():EmitSound(response)
					self.responses_target[response] = GameRules:GetDOTATime(true, true)
					break
				end
			end
		else
			for response, timer in pairs(self.responses_self) do
				if GameRules:GetDOTATime(true, true) - timer >= 120 then
					self:GetCaster():EmitSound(response)
					self.responses_self[response] = GameRules:GetDOTATime(true, true)
					break
				end
			end
		end
	end
	
	target:AddNewModifier(self:GetCaster(), self, "modifier_imba_grimstroke_spirit_walk_buff", {duration = self:GetSpecialValueFor("buff_duration")})
end

-----------------------------
-- INK SWELL BUFF MODIFIER --
-----------------------------

-- For the IMBAfication that allows casting on enemies
function modifier_imba_grimstroke_spirit_walk_buff:IgnoreTenacity()	return true end

-- Not working?
function modifier_imba_grimstroke_spirit_walk_buff:GetStatusEffectName()
	if not self:GetCaster():HasModifier("modifier_imba_grimstroke_ink_gods_incarnation") then
		return "particles/status_fx/status_effect_grimstroke_ink_swell.vpcf"
	end
end

function modifier_imba_grimstroke_spirit_walk_buff:OnCreated()
	self.buff_duration			= self:GetAbility():GetSpecialValueFor("buff_duration")
	self.movespeed_bonus_pct	= self:GetAbility():GetSpecialValueFor("movespeed_bonus_pct")
	self.radius					= self:GetAbility():GetTalentSpecialValueFor("radius")
	self.max_damage				= self:GetAbility():GetTalentSpecialValueFor("max_damage")
	self.max_stun				= self:GetAbility():GetSpecialValueFor("max_stun")
	self.damage_per_tick		= self:GetAbility():GetSpecialValueFor("damage_per_tick")
	self.tick_rate				= self:GetAbility():GetSpecialValueFor("tick_rate")
	
	self.coat_of_armor_amount	= self:GetAbility():GetSpecialValueFor("coat_of_armor_amount")
	
	if not IsServer() then return end
	
	-- Track how many times a real hero was hit to determine max damage and stun
	self.counter				= 0
	
	self.ticks					= 0
	self.total_ticks			= self.buff_duration / self.tick_rate

	local ink_swell_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_buff.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(ink_swell_particle, 2, Vector(self.radius, self.radius, self.radius))
	ParticleManager:SetParticleControlEnt(ink_swell_particle, 3, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(ink_swell_particle, 6, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
	self:AddParticle(ink_swell_particle, false, false, -1, false, false)

	self:OnIntervalThink()
	self:StartIntervalThink(self.tick_rate)
end

function modifier_imba_grimstroke_spirit_walk_buff:OnRefresh()
	if not IsServer() then return end
	
	self.ticks					= 0
end

function modifier_imba_grimstroke_spirit_walk_buff:OnIntervalThink()
	if not IsServer() or self.ticks >= self.total_ticks then return end
	
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, enemy in pairs(enemies) do
		if self:GetParent() ~= enemy then
			enemy:EmitSound("Hero_Grimstroke.InkSwell.Damage")
			
			local ink_swell_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_tick_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(ink_swell_particle, 1, enemy:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(ink_swell_particle)
			
			local damageTable = {
				victim 			= enemy,
				damage 			= self.damage_per_tick,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			}
			
			ApplyDamage(damageTable)
		end
	end
	
	-- "The damage and stun upon losing the buff is based on the amount of damage instances the tendrils applied to a single enemy hero."
	if #FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false) >= 1 or (self:GetParent():FindModifierByNameAndCaster("modifier_imba_grimstroke_ink_gods_incarnation", self:GetCaster()) and #FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false) >= 1) then
		self.counter	= math.min(self.counter + 1, self.total_ticks)
	end
	
	self.ticks	= self.ticks + 1
end

-- "When the debuff is lost prematurely, it still applies the area expire damage and stun, based on the damage instances it dealt up to that point."
function modifier_imba_grimstroke_spirit_walk_buff:OnDestroy()
	if not IsServer() then return end

	self:GetParent():EmitSound("Hero_Grimstroke.InkSwell.Stun")
	
	local ink_swell_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(ink_swell_particle, 2, Vector(self.radius, self.radius, self.radius))
	ParticleManager:ReleaseParticleIndex(ink_swell_particle)
	
	-- "The expire damage and stun only apply when there is at least one enemy hero within the area."
	if #FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false) >= 1 or self:GetParent():FindModifierByNameAndCaster("modifier_imba_grimstroke_ink_gods_incarnation", self:GetCaster()) then
	
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		-- Custom Ability: Ink God's Incarnation
		-- Don't stun units that have just been stunned by the previous Ink Swell explosion since it keeps casting
		-- Yeah tne standard logic is intertwined in here too
		local ink_gods_incarnation_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_grimstroke_ink_gods_incarnation", self:GetCaster())
		
		local stunned_table = {}
		
		for _, enemy in pairs(enemies) do
			if self:GetParent() ~= enemy then
				enemy:EmitSound("Hero_Grimstroke.InkSwell.Target")
			
				-- "Ink Swell first applies the damage, then the debuff."
				local damageTable = {
					victim 			= enemy,
					damage 			= (self.max_damage / self.total_ticks) * self.counter,
					damage_type		= DAMAGE_TYPE_MAGICAL,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self:GetCaster(),
					ability 		= self:GetAbility()
				}
				
				ApplyDamage(damageTable)
				
				if not ink_gods_incarnation_modifier or (ink_gods_incarnation_modifier and ink_gods_incarnation_modifier.stunned and not ink_gods_incarnation_modifier.stunned[enemy]) then
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_grimstroke_spirit_walk_debuff", {duration = ((self.max_stun / self.total_ticks) * self.counter) * (1 - enemy:GetStatusResistance())})
					
					stunned_table[enemy] = true
				end
			end
		end
		
		if ink_gods_incarnation_modifier then
			ink_gods_incarnation_modifier.stunned = stunned_table
		end
		
		-- Clear the temp table after sending it to the other modifier
		stunned_table = {}
	end
end

-- IMBAfication: Unburdened
function modifier_imba_grimstroke_spirit_walk_buff:CheckState()
	local state = {}
	
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		state[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	end
	
	return state
end

function modifier_imba_grimstroke_spirit_walk_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_imba_grimstroke_spirit_walk_buff:GetModifierMoveSpeedBonus_Percentage()
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return self.movespeed_bonus_pct
	else
		return self.movespeed_bonus_pct * (-1)
	end
end

-- IMBAfication: A Coat of Armor
function modifier_imba_grimstroke_spirit_walk_buff:GetModifierPhysicalArmorBonus()
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return self.coat_of_armor_amount
	else
		return self.coat_of_armor_amount * (-1)
	end
end

-------------------------------
-- INK SWELL DEBUFF MODIFIER --
-------------------------------

function modifier_imba_grimstroke_spirit_walk_debuff:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true}
end

function modifier_imba_grimstroke_spirit_walk_debuff:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }
end

function modifier_imba_grimstroke_spirit_walk_debuff:GetOverrideAnimation()
	 return ACT_DOTA_DISABLED
end


---------------------------
-- INK GOD'S INCARNATION --
---------------------------

function imba_grimstroke_ink_gods_incarnation:OnHeroLevelUp()
	self:SetLevel(min(math.floor(self:GetCaster():GetLevel() / 6), 3))
end

function imba_grimstroke_ink_gods_incarnation:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Grimstroke.Stinger")

	local ink_swell_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(ink_swell_particle, 2, Vector(250, 250, 250))
	ParticleManager:ReleaseParticleIndex(ink_swell_particle)

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_grimstroke_ink_gods_incarnation", {duration = self:GetSpecialValueFor("duration")})
end

------------------------------------
-- INK GOD'S INCARNATION MODIFIER --
------------------------------------

function modifier_imba_grimstroke_ink_gods_incarnation:IsPurgable()	return false end

function modifier_imba_grimstroke_ink_gods_incarnation:GetStatusEffectName()
	return "particles/status_fx/status_effect_phantom_assassin_active_blur.vpcf"
end

function modifier_imba_grimstroke_ink_gods_incarnation:OnCreated()
	if not IsServer() then return end
	
	self.ink_swell_ability = self:GetCaster():FindAbilityByName("imba_grimstroke_spirit_walk")
	
	if self.ink_swell_ability and self.ink_swell_ability:IsTrained() then
		self.ink_swell_ability_duration = self.ink_swell_ability:GetSpecialValueFor("buff_duration")
	
		self.ink_swell_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self.ink_swell_ability, "modifier_imba_grimstroke_spirit_walk_buff", {duration = self.ink_swell_ability:GetSpecialValueFor("buff_duration")})
		
		-- Initialize table to store units that will be stunned by Ink Swell's explosion, as they will not be stunned by consecutive ones
		self.stunned = {}

		self:StartIntervalThink(self.ink_swell_ability_duration)
	end
end

function modifier_imba_grimstroke_ink_gods_incarnation:OnRefresh()
	self:OnCreated()
end

function modifier_imba_grimstroke_ink_gods_incarnation:OnIntervalThink()
	if not IsServer() or self:GetRemainingTime() <= 0.1 then return end
	
	if self.ink_swell_modifier then self.ink_swell_modifier:Destroy() end
	
	self.ink_swell_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self.ink_swell_ability, "modifier_imba_grimstroke_spirit_walk_buff", {duration = self.ink_swell_ability:GetSpecialValueFor("buff_duration")})
end

function modifier_imba_grimstroke_ink_gods_incarnation:OnDestroy()
	if not IsServer() then return end
	
	self:GetCaster():StopSound("Hero_Grimstroke.Stinger")
end

function modifier_imba_grimstroke_ink_gods_incarnation:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_SCALE
	}
end

function modifier_imba_grimstroke_ink_gods_incarnation:GetModifierModelScale()
	return 30
end

-- This ALMOST works but there's so many exceptions and weird interactions (all the other examples of this are wrong in the sense that they re-cast the ability, but the vanilla one CREATES A DUPLICATE instance/entity without actually putting the ability/icon to the hero) that this requires more time that cannot be spared before release
-- --------------
-- -- SOULBIND --
-- --------------

-- --Hero_Grimstroke.SoulChain.Leash

-- function imba_grimstroke_soul_chain:GetAOERadius()
	-- return self:GetSpecialValueFor("chain_latch_radius")
-- end

-- function imba_grimstroke_soul_chain:OnSpellStart()
	-- if self:GetCursorTarget() and not self:GetCursorTarget():TriggerSpellAbsorb(self) then
		-- self:GetCursorTarget():EmitSound("Hero_Grimstroke.SoulChain.Cast")

		-- local soulbind_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_cast_soulchain.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		-- ParticleManager:SetParticleControl(soulbind_particle, 1, self:GetCursorTarget():GetAbsOrigin())
		-- ParticleManager:ReleaseParticleIndex(soulbind_particle)
	
		-- self:GetCursorTarget():AddNewModifier(self:GetCaster(),	self, "modifier_imba_grimstroke_soul_chain",
		-- { 
			-- duration	= self:GetSpecialValueFor("chain_duration"),
			-- primary		= true -- Designate this as the cast modifier, which will then apply non-primary modifiers to nearby targets
		 -- })
	-- end
-- end

-- -----------------------
-- -- SOULBIND MODIFIER --
-- -----------------------

-- function modifier_imba_grimstroke_soul_chain:IgnoreTenacity()	return true end
-- function modifier_imba_grimstroke_soul_chain:IsPurgable()		return false end

-- function modifier_imba_grimstroke_soul_chain:OnCreated( kv )
	-- self.chain_latch_radius		= self:GetAbility():GetSpecialValueFor("chain_latch_radius")
	-- self.chain_break_distance	= self:GetAbility():GetSpecialValueFor("chain_break_distance")
	-- self.leash_radius_buffer	= self:GetAbility():GetSpecialValueFor("leash_radius_buffer")
	-- self.movement_slow			= self:GetAbility():GetSpecialValueFor("movement_slow")

	-- self.leash_radius_buffer_radius		= self.chain_latch_radius - self.leash_radius_buffer
	-- self.normal_ms_limit				= 550
	-- self.limit							= self.normal_ms_limit	
	
	-- if not IsServer() then return end
	
	-- -- Designate if the modifier was directly from Grimstroke's cast or not (this is the one that typically chains to others)
	-- self.primary = (kv.primary == 1)
	
	-- -- Determine who chained the modifier to this unit, if applicable
	-- if kv.source then
		-- self.source		= EntIndexToHScript(kv.source)
	-- end
	
	-- -- Might let this hit more than two targets later...
	-- -- Initialize table to hold other latched targets
	-- self.latched_targets = {}
	
	-- self:GetParent():EmitSound("Hero_Grimstroke.SoulChain.Target")

	-- local soulbind_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	-- ParticleManager:SetParticleControlEnt(soulbind_particle, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
	-- self:AddParticle(soulbind_particle, false, false, -1, false, false)
	
	-- -- The overhead particle only displays on the primary target of Soulbind
	-- if self.primary then
		-- local soulbind_marker = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain_marker.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		-- self:AddParticle(soulbind_marker, false, false, -1, false, true)
	-- end

	-- self:StartIntervalThink(0.1)
	-- self:OnIntervalThink()
-- end

-- function modifier_imba_grimstroke_soul_chain:OnRefresh( kv )
	-- if not IsServer() then return end
	
	-- self.movement_slow = self:GetAbility():GetSpecialValueFor("movement_slow")

	-- -- check if non-primary being refreshed as primary
	-- if (kv.primary == 1) and (not self.primary) then
		-- self.primary = true
		
		-- -- If refreshed while there is already a latched pair target, remove that other unit's primary status (might cause issues otherwise)
		-- if self.pair then
			-- self.pair.primary = false
			-- self.pair:SetDuration(kv.duration, true)
		-- end
	-- end
-- end

-- -- This constantly checks for latching or movement speed manipulation on stretching chain
-- function modifier_imba_grimstroke_soul_chain:OnIntervalThink()
	-- if not IsServer() then return end

	-- -- If there aren't any bounded targets yet, continue searching for nearby potential victims
	-- if self.primary and not self.pair then
		-- self:FindPair()
	-- -- Otherwise if there is a bound target, ensure that they cannot stray too far from each other
	-- elseif self.pair then
		-- self:Bind()
	-- end
-- end

-- function modifier_imba_grimstroke_soul_chain:FindPair()
	-- -- "Only binds the primary target to heroes (excluding illusions, including clones) or creep-heroes. The primary target can be an illusion though."
	-- -- "Does not bind to nearby invisible or invulnerable heroes."
	
	-- -- TODO: Check if this works on creep-heroes (it's supposed to)
	-- local heroes = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(),	nil, self.chain_latch_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false)

	-- for _, hero in pairs(heroes) do
		-- if hero ~= self:GetParent() and not hero:FindModifierByNameAndCaster("modifier_imba_grimstroke_soul_chain", self:GetCaster()) then
			-- self.latched_targets[hero] = true
			
			-- hero:EmitSound("Hero_Grimstroke.SoulChain.Partner")

			-- self.pair = hero:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_grimstroke_soul_chain",
			-- {
				-- primary = false,
				-- source	= self:GetParent():entindex()
			-- })
			
			-- if self.pair then
				-- self.pair.pair = self
			-- end

			-- self.soulbind_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			-- ParticleManager:SetParticleControlEnt(self.soulbind_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
			-- ParticleManager:SetParticleControlEnt(self.soulbind_particle, 1, self.pair:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)	

			-- break
		-- end
	-- end
-- end

-- -- Yeah this was taking from Elfansoer's Soulbind and largely modified for all the other functions, although they're both still kinda...really not working properly
-- function modifier_imba_grimstroke_soul_chain:Bind()
	-- -- get info
	-- local vectorToPair = self.pair:GetParent():GetOrigin() - self:GetParent():GetOrigin()
	-- local facingAngle = self:GetParent():GetAnglesAsVector().y

	-- -- calculate facing angle
	-- local angleToPair = VectorToAngles(vectorToPair).y
	-- local angleDifference = math.abs(AngleDiff( angleToPair, facingAngle ))

	-- -- calculate distance
	-- local distanceToPair = vectorToPair:Length2D()

	-- -- check if it is within boundaries
	-- if distanceToPair < self.leash_radius_buffer_radius then
		-- -- within limit
		-- self.limit = nil

	-- elseif distanceToPair < self.chain_break_distance then
		-- -- slowed if facing away
		-- if angleDifference > 90 then
			-- -- slow interpolates linearly between buffer radius and chain radius
			-- local interpolate = math.min((distanceToPair - self.leash_radius_buffer_radius) / self.leash_radius_buffer, 1)

			-- -- slow inversely related with interpolation
			-- self.limit = (1 - interpolate) * self.normal_ms_limit

			-- -- 0 limit means no limit
			-- if self.limit < 1 then
				-- self.limit = 0.01
			-- end
		-- else
			-- -- not slowed if facing towards pair
			-- self.limit = nil
		-- end

		-- -- -- interrupts weak motion controllers
		-- -- self:GetParent():InterruptMotionControllers( true )
	-- else
		-- -- outside, break
		-- if self.primary then
			-- ParticleManager:DestroyParticle(self.soulbind_particle, false)
			-- ParticleManager:ReleaseParticleIndex(self.soulbind_particle)
			-- self.pair:Destroy()
			-- self.pair = nil
		-- end
	-- end
-- end

-- function modifier_imba_grimstroke_soul_chain:OnRemoved()
	-- if not IsServer() then return end
	
	-- if self.primary and self.pair and (not self.pair:IsNull()) then
		-- ParticleManager:DestroyParticle( self.soulbind_particle, false )
		-- ParticleManager:ReleaseParticleIndex( self.soulbind_particle )
	-- end
-- end

-- function modifier_imba_grimstroke_soul_chain:OnDestroy()
	-- if not IsServer() then return end

	-- if self.primary and self.pair and (not self.pair:IsNull()) then
		-- self.pair:Destroy()
	-- end
-- end

-- function modifier_imba_grimstroke_soul_chain:CheckState()
	-- if not IsServer() then return end
	
	-- local state = {}
	
	-- if self.pair then
		-- state[MODIFIER_STATE_TETHERED] = true
	-- end
	
	-- return state
-- end

-- function modifier_imba_grimstroke_soul_chain:DeclareFunctions()
	-- local decFuncs = {
		-- -- This thing does not duplicate spells that do not trigger Linken's, so I guess it makes sense to use MODIFIER_PROPERTY_ABSORB_SPELL for the duplication logic
		-- MODIFIER_PROPERTY_ABSORB_SPELL,
		-- MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		-- MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	-- }

	-- return decFuncs
-- end

-- function modifier_imba_grimstroke_soul_chain:GetAbsorbSpell(keys)
	-- -- local test = SpawnEntityFromTableSynchronous(keys.ability:GetClassname(), {})
	-- -- print(keys.ability:entindex())
	-- --print(test)
	-- --print(keys.ability)
	-- -- print(keys.ability:GetClassname())
	
	-- if self.casted then return end
	-- if not self.pair then return end
	-- if keys.ability == self:GetAbility() then return end
	
	-- -- Create main proc particle
	-- local soulbind_paritcle_1 = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain_proc_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	-- ParticleManager:ReleaseParticleIndex(soulbind_paritcle_1)

	-- -- Create chain proc particle
	-- local soulbind_particle_2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_soulchain_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	-- ParticleManager:SetParticleControl(soulbind_particle_2, 1, self.pair:GetParent():GetAbsOrigin())
	-- ParticleManager:ReleaseParticleIndex(soulbind_particle_2)

	-- -- Create pair proc particle
	-- local soulbind_paritcle_3 = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain_proc_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.pair:GetParent())
	-- ParticleManager:ReleaseParticleIndex(soulbind_paritcle_3)

	-- self:GetCaster():SetCursorCastTarget(self.pair:GetParent())

	-- -- Testing some stuff with vanilla Soulbind (which may be similar for Multicast):
	-- -- The duplicate ability is actually a DIFFERENT ability instance, such that it has a different entity index
	-- -- Its AbsOrigin (for some reason it has one) is Vector(0, 0, 0), whereas the standard ability is where the caster is
	-- -- GetPurchaseTime() for items is -1 for the duplicate
	-- -- For items AND abilities, it looks like it actually CREATES the item, casts the ability, and has the item delete itself after its modifier or w/e (print(#Entities:FindAllByName(self:GetName())))

	-- self.casted = true
	-- keys.ability:OnSpellStart()
	-- self.casted = nil
-- end

-- function modifier_imba_grimstroke_soul_chain:GetModifierMoveSpeedBonus_Percentage()
	-- return self.movement_slow * (-1)
-- end

-- function modifier_imba_grimstroke_soul_chain:GetModifierMoveSpeed_Limit()
	-- if not IsServer() or not self.limit then return end

	-- return self.limit
-- end

-------------------------------
-- SOULBIND VANILLA ENHANCER --
-------------------------------

function imba_grimstroke_soul_chain_vanilla_enhancer:GetIntrinsicModifierName()
	return "modifier_imba_grimstroke_soul_chain_vanilla_enhancer"
end

function imba_grimstroke_soul_chain_vanilla_enhancer:OnHeroLevelUp()
	self:SetLevel(min(math.floor(self:GetCaster():GetLevel() / 6), 3))
end

----------------------------------------
-- SOULBIND VANILLA ENHANCER MODIFIER --
----------------------------------------

function modifier_imba_grimstroke_soul_chain_vanilla_enhancer:IsHidden()		return true end

function modifier_imba_grimstroke_soul_chain_vanilla_enhancer:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_MODIFIER_ADDED}
	
	return decFuncs
end

function modifier_imba_grimstroke_soul_chain_vanilla_enhancer:OnModifierAdded(keys)
	if keys.unit:FindModifierByNameAndCaster("modifier_grimstroke_soul_chain", self:GetCaster()) and not keys.unit:FindModifierByNameAndCaster("modifier_imba_grimstroke_soul_chain_vanilla_enhancer_slow", self:GetCaster()) and keys.unit:FindModifierByNameAndCaster("modifier_grimstroke_soul_chain", self:GetCaster()):GetElapsedTime() <= FrameTime() then
		local soulbind_modifier = keys.unit:FindModifierByNameAndCaster("modifier_grimstroke_soul_chain", self:GetCaster())
		
		-- IMBAfication: Tenacity Nullification
		-- The if statement here should make it so this only affects the primary target, and not further chained units (cause their duration is based on the primary duration)
		if keys.unit == soulbind_modifier:GetAbility():GetCursorTarget() then
			soulbind_modifier:SetDuration(soulbind_modifier:GetAbility():GetSpecialValueFor("chain_duration"), true)
		end
		
		-- IMBAfication: Historical Viscosity
		keys.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_grimstroke_soul_chain_vanilla_enhancer_slow", {duration = soulbind_modifier:GetRemainingTime()})
	end
end

---------------------------------------------
-- SOULBIND VANILLA ENHANCER SLOW MODIFIER --
---------------------------------------------

function modifier_imba_grimstroke_soul_chain_vanilla_enhancer_slow:IgnoreTenacity()	return true end
function modifier_imba_grimstroke_soul_chain_vanilla_enhancer_slow:IsPurgable()		return false end

function modifier_imba_grimstroke_soul_chain_vanilla_enhancer_slow:GetTexture()
	return "grimstroke_soul_chain"
end

function modifier_imba_grimstroke_soul_chain_vanilla_enhancer_slow:OnCreated()
	self.movement_slow	= self:GetAbility():GetSpecialValueFor("movement_slow")
end

function modifier_imba_grimstroke_soul_chain_vanilla_enhancer_slow:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
	
	return decFuncs
end

function modifier_imba_grimstroke_soul_chain_vanilla_enhancer_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow * (-1)
end


---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_grimstroke_ink_swell_max_damage", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_grimstroke_phantoms_embrace_extra_hits", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_grimstroke_ink_swell_radius", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_grimstroke_stroke_of_fate_damage", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_grimstroke_ink_swell_max_damage	= modifier_special_bonus_imba_grimstroke_ink_swell_max_damage or class({})
modifier_special_bonus_imba_grimstroke_phantoms_embrace_extra_hits	= modifier_special_bonus_imba_grimstroke_phantoms_embrace_extra_hits or class({})
modifier_special_bonus_imba_grimstroke_ink_swell_radius	= modifier_special_bonus_imba_grimstroke_ink_swell_radius or class({})
modifier_special_bonus_imba_grimstroke_stroke_of_fate_damage	= modifier_special_bonus_imba_grimstroke_stroke_of_fate_damage or class({})

function modifier_special_bonus_imba_grimstroke_ink_swell_max_damage:IsHidden() 		return true end
function modifier_special_bonus_imba_grimstroke_ink_swell_max_damage:IsPurgable()		return false end
function modifier_special_bonus_imba_grimstroke_ink_swell_max_damage:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_grimstroke_phantoms_embrace_extra_hits:IsHidden() 		return true end
function modifier_special_bonus_imba_grimstroke_phantoms_embrace_extra_hits:IsPurgable()		return false end
function modifier_special_bonus_imba_grimstroke_phantoms_embrace_extra_hits:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_grimstroke_ink_swell_radius:IsHidden() 		return true end
function modifier_special_bonus_imba_grimstroke_ink_swell_radius:IsPurgable()		return false end
function modifier_special_bonus_imba_grimstroke_ink_swell_radius:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_grimstroke_stroke_of_fate_damage:IsHidden() 		return true end
function modifier_special_bonus_imba_grimstroke_stroke_of_fate_damage:IsPurgable()		return false end
function modifier_special_bonus_imba_grimstroke_stroke_of_fate_damage:RemoveOnDeath() 	return false end

LinkLuaModifier("modifier_special_bonus_imba_grimstroke_stroke_of_fate_cast_range", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_grimstroke_stroke_of_fate_cast_range	= class({})

function modifier_special_bonus_imba_grimstroke_stroke_of_fate_cast_range:IsHidden() 		return true end
function modifier_special_bonus_imba_grimstroke_stroke_of_fate_cast_range:IsPurgable() 		return false end
function modifier_special_bonus_imba_grimstroke_stroke_of_fate_cast_range:RemoveOnDeath() 	return false end

function imba_grimstroke_dark_artistry:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_grimstroke_stroke_of_fate_cast_range") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_grimstroke_stroke_of_fate_cast_range") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_grimstroke_stroke_of_fate_cast_range"), "modifier_special_bonus_imba_grimstroke_stroke_of_fate_cast_range", {})
	end
end
