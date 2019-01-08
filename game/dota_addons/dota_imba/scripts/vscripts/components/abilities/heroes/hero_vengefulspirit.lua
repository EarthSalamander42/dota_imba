-- Editors:
--     Firetoad
--     AtroCty, 20.04.2017

LinkLuaModifier("modifier_special_bonus_imba_vengefulspirit_4", "components/abilities/heroes/hero_vengefulspirit.lua", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_vengefulspirit_4 = modifier_special_bonus_imba_vengefulspirit_4 or class({})

function modifier_special_bonus_imba_vengefulspirit_4:IsHidden() return false end
function modifier_special_bonus_imba_vengefulspirit_4:RemoveOnDeath() return false end
function modifier_special_bonus_imba_vengefulspirit_4:IsAura()
	return true
end

function modifier_special_bonus_imba_vengefulspirit_4:GetAuraEntityReject(target)
	if IsServer() then
		-- Always reject caster
		if target == self:GetCaster() then
			return true
		end
		return false
	end
end

function modifier_special_bonus_imba_vengefulspirit_4:GetModifierAura()
	return "modifier_imba_rancor_allies"
end

function modifier_special_bonus_imba_vengefulspirit_4:GetAuraRadius()
	local caster = self:GetCaster()
	if caster:IsRealHero() then
		return self:GetCaster():FindTalentValue("special_bonus_imba_vengefulspirit_4", "radius")
	else
		return 0
	end
end

function modifier_special_bonus_imba_vengefulspirit_4:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_special_bonus_imba_vengefulspirit_4:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_special_bonus_imba_vengefulspirit_4:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

-------------------------------------------
--				 RANCOR
-------------------------------------------
LinkLuaModifier("modifier_imba_rancor", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rancor_stack", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rancor_allies", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)

imba_vengefulspirit_rancor = class({})
function imba_vengefulspirit_rancor:IsHiddenWhenStolen() return false end
function imba_vengefulspirit_rancor:IsRefreshable() return false end
function imba_vengefulspirit_rancor:IsStealable() return false end
function imba_vengefulspirit_rancor:IsNetherWardStealable() return false end
function imba_vengefulspirit_rancor:IsInnateAbility() return true end

function imba_vengefulspirit_rancor:GetAbilityTextureName()
	return "custom/vengeful_rancor"
end
-------------------------------------------

function imba_vengefulspirit_rancor:GetIntrinsicModifierName()
	return "modifier_imba_rancor"
end

-------------------------------------------
modifier_imba_rancor = class({})
function modifier_imba_rancor:IsDebuff() return false end
function modifier_imba_rancor:IsHidden() return true end
function modifier_imba_rancor:IsPurgable() return false end
function modifier_imba_rancor:IsPurgeException() return false end
function modifier_imba_rancor:IsStunDebuff() return false end
-------------------------------------------

function modifier_imba_rancor:OnCreated()
	self.dmg_received_pct = self.dmg_received_pct or 0
	self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
end

function modifier_imba_rancor:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_EVENT_ON_TAKEDAMAGE,
		}
	return decFuns
end

function modifier_imba_rancor:OnTakeDamage( params )
	if IsServer() then
		local parent = self:GetParent()
		if (parent == params.unit) or params.unit:HasModifier("modifier_imba_rancor_allies") then
			if params.damage > 0 and not parent:PassivesDisabled() and params.unit:IsRealHero() then
				local ability = self:GetAbility()
				local stack_receive_pct = ability:GetSpecialValueFor("stack_receive_pct")
				if params.unit:HasModifier("modifier_imba_rancor_allies") and not (parent == params.unit) then
					if params.unit:FindModifierByNameAndCaster("modifier_imba_rancor_allies", parent) then
						self.dmg_received_pct = self.dmg_received_pct + ((100 / parent:GetMaxHealth()) * math.min(params.damage, parent:GetHealth())) * (parent:FindTalentValue("special_bonus_imba_vengefulspirit_4", "rate_pct") / 100)
					end
				else
					self.dmg_received_pct = self.dmg_received_pct + ((100 / parent:GetMaxHealth()) * math.min(params.damage, parent:GetHealth()))
				end
				while (self.dmg_received_pct >= stack_receive_pct ) do
					if parent:HasModifier("modifier_imba_rancor_stack") then
						local modifier = parent:FindModifierByName("modifier_imba_rancor_stack")
						-- Adding a limit to prevent possible exploits
						if modifier:GetStackCount() < self.max_stacks then
							modifier:IncrementStackCount()
						end
					else
						local modifier = parent:AddNewModifier(parent, ability, "modifier_imba_rancor_stack", {})
						modifier:SetStackCount(1)
					end
					self.dmg_received_pct = self.dmg_received_pct - stack_receive_pct
				end
			end
		end
	end
end

-------------------------------------------
modifier_imba_rancor_allies = class({})
function modifier_imba_rancor_allies:IsDebuff() return false end
function modifier_imba_rancor_allies:IsHidden() return true end
function modifier_imba_rancor_allies:IsPurgable() return false end
function modifier_imba_rancor_allies:IsPurgeException() return false end
function modifier_imba_rancor_allies:IsStunDebuff() return false end
function modifier_imba_rancor_allies:RemoveOnDeath() return false end
-------------------------------------------
modifier_imba_rancor_stack = class({})
function modifier_imba_rancor_stack:IsDebuff() return false end
function modifier_imba_rancor_stack:IsHidden() return false end
function modifier_imba_rancor_stack:IsPurgable() return false end
function modifier_imba_rancor_stack:IsPurgeException() return false end
function modifier_imba_rancor_stack:IsStunDebuff() return false end
function modifier_imba_rancor_stack:RemoveOnDeath() return false end
-------------------------------------------

function modifier_imba_rancor_stack:OnCreated()
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("stack_duration"))
	end
end

function modifier_imba_rancor_stack:OnIntervalThink()
	if IsServer() then
		if self:GetParent():IsAlive() then
			if self:GetStackCount() == 1 then
				self:Destroy()
			else
				self:DecrementStackCount()
			end
		end
	end
end

function modifier_imba_rancor_stack:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
		}
	return decFuncs
end

function modifier_imba_rancor_stack:GetModifierSpellAmplify_Percentage()
	return (self:GetAbility():GetSpecialValueFor("spell_power") * self:GetStackCount())
end

function modifier_imba_rancor_stack:GetModifierPreAttack_BonusDamage()
	return (self:GetAbility():GetSpecialValueFor("damage_pct") * self:GetStackCount())
end

-------------------------------------------
--            MAGIC MISSILE
-------------------------------------------

imba_vengefulspirit_magic_missile = class({})
function imba_vengefulspirit_magic_missile:IsHiddenWhenStolen() return false end
function imba_vengefulspirit_magic_missile:IsRefreshable() return true end
function imba_vengefulspirit_magic_missile:IsStealable() return true end
function imba_vengefulspirit_magic_missile:IsNetherWardStealable() return true end

function imba_vengefulspirit_magic_missile:GetAbilityTextureName()
	return "vengefulspirit_magic_missile"
end

function imba_vengefulspirit_magic_missile:GetAbilityTextureName()
	if not IsClient() then return end
	if not self:GetCaster().magic_missile_icon then return "vengefulspirit_magic_missile" end
	return "custom/imba_vengefulspirit_magic_missile_immortal"..self:GetCaster().magic_missile_icon
end

function imba_vengefulspirit_magic_missile:GetIntrinsicModifierName()
	return "modifier_imba_vengefulspirit_magic_missile_handler"
end

-------------------------------------------

function imba_vengefulspirit_magic_missile:GetAOERadius()
	return self:GetTalentSpecialValueFor("split_radius")
end

function imba_vengefulspirit_magic_missile:CastFilterResultTarget( target )
	if IsServer() then

		if target ~= nil and target:IsMagicImmune() and ( not self:GetCaster():HasTalent("special_bonus_imba_vengefulspirit_5") ) then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end


function imba_vengefulspirit_magic_missile:OnSpellStart( params , reduce_pct, target_loc, ix )
	if IsServer() then
		local caster = self:GetCaster()
		local target
		if params then
			target = params
		else
			target = self:GetCursorTarget()
		end

		-- Parameters
		local damage = self:GetTalentSpecialValueFor("damage")
		local stun_duration = self:GetSpecialValueFor("stun_duration")
		local split_radius = self:GetSpecialValueFor("split_radius")
		local split_reduce_pct = self:GetSpecialValueFor("split_reduce_pct")
		local split_amount = self:GetSpecialValueFor("split_amount")
		local projectile_speed = self:GetSpecialValueFor("projectile_speed")
		local index
		local sound = "Hero_VengefulSpirit.MagicMissile"
		if caster.magic_missile_sound then
			sound = caster.magic_missile_sound
		end

		-- Create an unique index, else use the old
		if ix then
			index = ix
		else
			index = DoUniqueString("projectile")
			proj_index = "projectile_" .. index
			-- Finished traveling counter
			self[index] = 0
			-- Already hit targets
			self[proj_index] = {}
			table.insert(self[proj_index],target)
		end

		-- Reduce damage and stun duration if this is a secondary, else emit cast-sound
		if reduce_pct then
			damage = math.ceil(damage - (damage * (reduce_pct / 100)))
			stun_duration = stun_duration - (stun_duration * (reduce_pct / 100))
			split_reduce_pct = reduce_pct + (reduce_pct * (split_reduce_pct / 100))
		else
			caster:EmitSound(sound)
			if (math.random(1,100) <= 5) and (caster:GetName() == "npc_dota_hero_vengefulspirit") then
				caster:EmitSound("vengefulspirit_vng_cast_05")
			end
		end

		local particle = "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf"
		if caster.magic_missile_effect then
			particle = caster.magic_missile_effect
		end

		local projectile
		if params then
			projectile =
				{
					Target 				= target,
					Source 				= target_loc,
					Ability 			= self,
					EffectName 			= particle,
					iMoveSpeed			= projectile_speed,
					bDrawsOnMinimap 	= false,
					bDodgeable 			= true,
					bIsAttack 			= false,
					bVisibleToEnemies 	= true,
					bReplaceExisting 	= false,
					flExpireTime 		= GameRules:GetGameTime() + 10,
					bProvidesVision 	= false,
					--	iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
					--	iVisionRadius 		= 400,
					--	iVisionTeamNumber 	= caster:GetTeamNumber()
					ExtraData			= {index = index, target_index = target:GetEntityIndex(), damage = damage, stun_duration = stun_duration, split_radius = split_radius, split_reduce_pct = split_reduce_pct, split_amount = split_amount}
				}
			if target_loc:GetName() == "npc_dummy_unit" then
				target_loc:Destroy()
			end
		else
			projectile =
				{
					Target 				= target,
					Source 				= caster,
					Ability 			= self,
					EffectName 			= particle,
					iMoveSpeed			= projectile_speed,
					vSpawnOrigin 		= caster:GetAbsOrigin(),
					bDrawsOnMinimap 	= false,
					bDodgeable 			= true,
					bIsAttack 			= false,
					bVisibleToEnemies 	= true,
					bReplaceExisting 	= false,
					flExpireTime 		= GameRules:GetGameTime() + 10,
					bProvidesVision 	= false,
					iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
					--	iVisionRadius 		= 400,
					--	iVisionTeamNumber 	= caster:GetTeamNumber()
					ExtraData			= {index = index, target_index = target:GetEntityIndex(), damage = damage, stun_duration = stun_duration, split_radius = split_radius, split_reduce_pct = split_reduce_pct, split_amount = split_amount}
				}
		end
		ProjectileManager:CreateTrackingProjectile(projectile)
	end
end

function imba_vengefulspirit_magic_missile:OnProjectileHit_ExtraData(target, location, ExtraData)
	if IsServer() then
		local caster = self:GetCaster()
		local proj_index = "projectile_" .. ExtraData.index
		self[ExtraData.index] = self[ExtraData.index] + 1
		if target then
			if #self[proj_index] == 1 then
				if target:TriggerSpellAbsorb(self) then
					return nil
				end
			end
			ApplyDamage({victim = target, attacker = caster, ability = self, damage = ExtraData.damage, damage_type = self:GetAbilityDamageType()})
			if (not target:IsMagicImmune()) or caster:HasTalent("special_bonus_imba_vengefulspirit_5") then
				target:AddNewModifier(caster, self, "modifier_stunned", {duration = ExtraData.stun_duration})
			end
		else
			target = CreateUnitByName("npc_dummy_unit", location, false, caster, caster, caster:GetTeamNumber() )
		end

		local sound_hit = "Hero_VengefulSpirit.MagicMissileImpact"
		if caster.magic_missile_sound_hit then
			sound_hit = caster.magic_missile_sound_hit
		end

		EmitSoundOnLocationWithCaster(location, sound_hit, caster)

		local valid_targets = {}
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, ExtraData.split_radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		for _,enemy in ipairs(enemies) do
			local already_hit = false
			for _, stored_target in ipairs(self[proj_index]) do
				if stored_target == enemy then
					already_hit = true
					break
				end
			end
			if not already_hit then
				table.insert(valid_targets, enemy)
			end
		end
		local target_missiles = math.min(#valid_targets, ExtraData.split_amount)
		for i = 1, target_missiles do
			self:OnSpellStart( valid_targets[i] , ExtraData.split_reduce_pct, target, ExtraData.index )
			table.insert(self[proj_index] , valid_targets[i])
		end
		-- Delete these variables if no more targets are avaible
		if self[ExtraData.index] == #self[proj_index] then
			self[ExtraData.index] = nil
			self[proj_index] = nil
		end
	end
end

LinkLuaModifier("modifier_imba_vengefulspirit_magic_missile_handler", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)

if modifier_imba_vengefulspirit_magic_missile_handler == nil then modifier_imba_vengefulspirit_magic_missile_handler = class({}) end

function modifier_imba_vengefulspirit_magic_missile_handler:IsHidden() return true end
function modifier_imba_vengefulspirit_magic_missile_handler:RemoveOnDeath() return false end

function modifier_imba_vengefulspirit_magic_missile_handler:OnCreated()
	if self:GetCaster():IsIllusion() then self:Destroy() return end

	if IsServer() then
		if self:GetCaster().magic_missile_icon == nil then self:Destroy() return end
		self:SetStackCount(self:GetCaster().magic_missile_icon)
	end

	if IsClient() then
		if self:GetStackCount() == 0 then self:Destroy() return end
		self:GetCaster().magic_missile_icon = self:GetStackCount()
	end
end

-------------------------------------------
--          WAVE OF TERROR
-------------------------------------------

imba_vengefulspirit_wave_of_terror = class({})
function imba_vengefulspirit_wave_of_terror:IsHiddenWhenStolen() return false end
function imba_vengefulspirit_wave_of_terror:IsRefreshable() return true end
function imba_vengefulspirit_wave_of_terror:IsStealable() return true end
function imba_vengefulspirit_wave_of_terror:IsNetherWardStealable() return true end

function imba_vengefulspirit_wave_of_terror:GetAbilityTextureName()
	return "vengefulspirit_wave_of_terror"
end
-------------------------------------------
LinkLuaModifier("modifier_imba_wave_of_terror", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)

function imba_vengefulspirit_wave_of_terror:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()

		-- Parameters
		local damage = self:GetSpecialValueFor("damage")
		local speed = self:GetSpecialValueFor("wave_speed")
		local wave_width = self:GetSpecialValueFor("wave_width")
		local duration = self:GetSpecialValueFor("duration")
		local primary_distance = self:GetCastRange(caster_loc,caster) + GetCastRangeIncrease(caster)
		local vision_aoe = self:GetSpecialValueFor("vision_aoe")
		local vision_duration = self:GetSpecialValueFor("vision_duration")

		local dummy = CreateUnitByName("npc_dummy_unit", caster_loc, false, caster, caster, caster:GetTeamNumber() )
		dummy:EmitSound("Hero_VengefulSpirit.WaveOfTerror")

		if caster:GetName() == "npc_dota_hero_vengefulspirit" then
			caster:EmitSound("vengefulspirit_vng_ability_0"..math.random(1,9))
		end

		-- Distances
		local direction = (target_loc - caster_loc):Normalized()
		local velocity = direction * speed

		local projectile =
			{
				Ability				= self,
				EffectName			= "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf",
				vSpawnOrigin		= caster_loc,
				fDistance			= primary_distance,
				fStartRadius		= wave_width,
				fEndRadius			= wave_width,
				Source				= caster,
				bHasFrontalCone		= false,
				bReplaceExisting	= false,
				iUnitTargetTeam		= self:GetAbilityTargetTeam(),
				iUnitTargetFlags	= self:GetAbilityTargetFlags(),
				iUnitTargetType		= self:GetAbilityTargetType(),
				fExpireTime 		= GameRules:GetGameTime() + 10.0,
				bDeleteOnHit		= false,
				vVelocity			= Vector(velocity.x,velocity.y,0),
				bProvidesVision		= true,
				iVisionRadius 		= vision_aoe,
				iVisionTeamNumber 	= caster:GetTeamNumber(),
				ExtraData			= {damage = damage, duration = duration}
			}
		ProjectileManager:CreateLinearProjectile(projectile)

		-- Vision geometry
		local current_distance = vision_aoe / 2
		local tick_rate = vision_aoe / speed / 2

		-- Provide vision along the projectile's path
		Timers:CreateTimer(0, function()
			local current_vision_location = caster_loc + direction * current_distance

			self:CreateVisibilityNode(current_vision_location, vision_aoe, vision_duration)
			dummy:SetAbsOrigin(current_vision_location)

			current_distance = current_distance + vision_aoe / 2
			if current_distance < primary_distance then
				return tick_rate
			end
		end)
	end
end

function imba_vengefulspirit_wave_of_terror:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target then
		local caster = self:GetCaster()
		ApplyDamage({victim = target, attacker = caster, ability = self, damage = ExtraData.damage, damage_type = self:GetAbilityDamageType()})
		target:AddNewModifier(caster, self, "modifier_imba_wave_of_terror", {duration = ExtraData.duration})
	else
		self:CreateVisibilityNode(location, self:GetSpecialValueFor("vision_aoe"), self:GetSpecialValueFor("vision_duration"))
	end
	return false
end

-------------------------------------------
modifier_imba_wave_of_terror = class({})
function modifier_imba_wave_of_terror:IsDebuff() return true end
function modifier_imba_wave_of_terror:IsHidden() return false end
function modifier_imba_wave_of_terror:IsPurgable() return true end
function modifier_imba_wave_of_terror:IsStunDebuff() return false end
function modifier_imba_wave_of_terror:RemoveOnDeath() return true end
-------------------------------------------

function modifier_imba_wave_of_terror:OnCreated( params )
	local ability = self:GetAbility()
	self.armor_reduction = ability:GetSpecialValueFor("armor_reduction")
	self.atk_reduction_pct = ability:GetSpecialValueFor("atk_reduction_pct")
end

function modifier_imba_wave_of_terror:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
		}
	return decFuncs
end

function modifier_imba_wave_of_terror:GetModifierPhysicalArmorBonus()
	return self.armor_reduction * (-1)
end

function modifier_imba_wave_of_terror:GetModifierBaseDamageOutgoing_Percentage()
	return self.atk_reduction_pct * (-1)
end

function modifier_imba_wave_of_terror:GetEffectName()
	return "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror_recipient.vpcf"
end

function modifier_imba_wave_of_terror:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

-------------------------------------------
--            VENGEANCE AURA
-------------------------------------------
LinkLuaModifier("modifier_imba_command_aura_positive", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_command_aura_positive_aura", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_command_aura_negative", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_command_aura_negative_aura", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)

imba_vengefulspirit_command_aura = class({})
function imba_vengefulspirit_command_aura:IsHiddenWhenStolen() return false end
function imba_vengefulspirit_command_aura:IsRefreshable() return false end
function imba_vengefulspirit_command_aura:IsStealable() return false end
function imba_vengefulspirit_command_aura:IsNetherWardStealable() return false end

function imba_vengefulspirit_command_aura:GetAbilityTextureName()
	return "vengefulspirit_command_aura"
end
-------------------------------------------

function imba_vengefulspirit_command_aura:GetIntrinsicModifierName()
	return "modifier_imba_command_aura_positive_aura"
end

-- Positive Aura Effects
-------------------------------------------
modifier_imba_command_aura_positive = class({})
function modifier_imba_command_aura_positive:IsDebuff() return false end
function modifier_imba_command_aura_positive:IsHidden() return false end
function modifier_imba_command_aura_positive:IsPurgable() return false end
function modifier_imba_command_aura_positive:IsPurgeException() return false end
function modifier_imba_command_aura_positive:IsStunDebuff() return false end
function modifier_imba_command_aura_positive:RemoveOnDeath() return false end
-------------------------------------------

function modifier_imba_command_aura_positive:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
			MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
			MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
		}
	return decFuncs
end

function modifier_imba_command_aura_positive:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("spell_power") + self:GetCaster():FindTalentValue("special_bonus_imba_vengefulspirit_3", "spell_power")
end

function modifier_imba_command_aura_positive:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetCaster() then
		if self:GetCaster():HasTalent("special_bonus_imba_vengefulspirit_8") then
			return 0
		else
			return self:GetAbility():GetSpecialValueFor("bonus_damage_pct") + self:GetCaster():FindTalentValue("special_bonus_imba_vengefulspirit_3", "bonus_damage_pct")
		end
	end
end

function modifier_imba_command_aura_positive:GetModifierDamageOutgoing_Percentage()
	if self:GetCaster() then
		if self:GetCaster():HasTalent("special_bonus_imba_vengefulspirit_8") then
			return self:GetAbility():GetSpecialValueFor("bonus_damage_pct") + self:GetCaster():FindTalentValue("special_bonus_imba_vengefulspirit_3", "bonus_damage_pct")
		else
			return 0
		end
	end
end

-------------------------------------------
modifier_imba_command_aura_positive_aura = class({})
function modifier_imba_command_aura_positive_aura:IsAura() return true end
function modifier_imba_command_aura_positive_aura:IsDebuff() return false end
function modifier_imba_command_aura_positive_aura:IsHidden() return true end
function modifier_imba_command_aura_positive_aura:IsPurgable() return false end
function modifier_imba_command_aura_positive_aura:IsPurgeException() return false end
function modifier_imba_command_aura_positive_aura:IsStunDebuff() return false end
function modifier_imba_command_aura_positive_aura:RemoveOnDeath() return false end
-------------------------------------------

function modifier_imba_command_aura_positive_aura:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_EVENT_ON_DEATH,
		}
	return decFuncs
end

function modifier_imba_command_aura_positive_aura:OnDeath(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			-- If this is an illusion, do nothing
			if not params.unit:IsRealHero() then
				return nil
			end
			local ability = self:GetAbility()
			ability.enemy_modifier = params.attacker:AddNewModifier(params.unit, ability, "modifier_imba_command_aura_negative_aura", {})
		end
	end
end

function modifier_imba_command_aura_positive_aura:GetAuraEntityReject(target)
	if IsServer() then
		if self:GetParent():PassivesDisabled() then return true end
		return false
	end
end

function modifier_imba_command_aura_positive_aura:GetModifierAura()
	return "modifier_imba_command_aura_positive"
end

function modifier_imba_command_aura_positive_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_imba_command_aura_positive_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end

function modifier_imba_command_aura_positive_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_command_aura_positive_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

-------------------------------------------
modifier_imba_command_aura_negative = class({})
function modifier_imba_command_aura_negative:IsDebuff() return true end
function modifier_imba_command_aura_negative:IsHidden() return false end
function modifier_imba_command_aura_negative:IsPurgable() return false end
function modifier_imba_command_aura_negative:IsPurgeException() return false end
function modifier_imba_command_aura_negative:IsStunDebuff() return false end
function modifier_imba_command_aura_negative:RemoveOnDeath() return false end
-------------------------------------------

function modifier_imba_command_aura_negative:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
			MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
			MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
		}
	return decFuncs
end

function modifier_imba_command_aura_negative:GetModifierSpellAmplify_Percentage()
	return (self:GetAbility():GetSpecialValueFor("spell_power") + self:GetCaster():FindTalentValue("special_bonus_imba_vengefulspirit_3", "spell_power")) * (-1)
end

function modifier_imba_command_aura_negative:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetCaster():HasTalent("special_bonus_imba_vengefulspirit_8") then
		return 0
	else
		return (self:GetAbility():GetSpecialValueFor("bonus_damage_pct") + self:GetCaster():FindTalentValue("special_bonus_imba_vengefulspirit_3", "bonus_damage_pct")) * (-1)
	end
end

function modifier_imba_command_aura_negative:GetModifierDamageOutgoing_Percentage()
	if self:GetCaster():HasTalent("special_bonus_imba_vengefulspirit_8") then
		return (self:GetAbility():GetSpecialValueFor("bonus_damage_pct") + self:GetCaster():FindTalentValue("special_bonus_imba_vengefulspirit_3", "bonus_damage_pct")) * (-1)
	else
		return 0
	end
end

-------------------------------------------
modifier_imba_command_aura_negative_aura = class({})
function modifier_imba_command_aura_negative_aura:IsAura() return true end
function modifier_imba_command_aura_negative_aura:IsDebuff() return true end
function modifier_imba_command_aura_negative_aura:IsHidden() return true end
function modifier_imba_command_aura_negative_aura:IsPurgable() return false end
function modifier_imba_command_aura_negative_aura:IsPurgeException() return false end
function modifier_imba_command_aura_negative_aura:IsStunDebuff() return false end
function modifier_imba_command_aura_negative_aura:RemoveOnDeath() return false end
-------------------------------------------

function modifier_imba_command_aura_negative_aura:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_EVENT_ON_RESPAWN
		}
	return decFuns
end

function modifier_imba_command_aura_negative_aura:OnRespawn( params )
	if IsServer() then
		if (self:GetCaster() == params.unit) then
			self:Destroy()
		end
	end
end

function modifier_imba_command_aura_negative_aura:GetModifierAura()
	return "modifier_imba_command_aura_negative"
end

function modifier_imba_command_aura_negative_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_imba_command_aura_negative_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end

function modifier_imba_command_aura_negative_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_command_aura_negative_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

-------------------------------------------
--            NETHER SWAP
-------------------------------------------

LinkLuaModifier("modifier_imba_nether_swap", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)

imba_vengefulspirit_nether_swap = class({})
function imba_vengefulspirit_nether_swap:IsHiddenWhenStolen() return false end
function imba_vengefulspirit_nether_swap:IsRefreshable() return true end
function imba_vengefulspirit_nether_swap:IsStealable() return true end
function imba_vengefulspirit_nether_swap:IsNetherWardStealable() return false end

function imba_vengefulspirit_nether_swap:GetAbilityTextureName()
	return "vengefulspirit_nether_swap"
end
-------------------------------------------

function imba_vengefulspirit_nether_swap:CastFilterResultTarget( target )
	if IsServer() then
		local caster = self:GetCaster()
		local casterID = caster:GetPlayerOwnerID()
		local targetID = target:GetPlayerOwnerID()

		if target ~= nil and target == caster then
			return UF_FAIL_OTHER
		end

		if target ~= nil and (not target:IsHero()) and (not caster:HasScepter()) then
			return UF_FAIL_CREEP
		end

		if target ~= nil and not target:IsOpposingTeam(caster:GetTeamNumber()) and PlayerResource:IsDisableHelpSetForPlayerID(targetID,casterID) then
			return UF_FAIL_DISABLE_HELP
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), caster:GetTeamNumber() )
		return nResult
	end
end

function imba_vengefulspirit_nether_swap:GetCooldown( nLevel )
	if self:GetCaster():HasScepter() then return self:GetSpecialValueFor("cooldown_scepter") end
	return self.BaseClass.GetCooldown( self, nLevel )
end

function imba_vengefulspirit_nether_swap:CastTalentMeteor(target)
	local caster = self:GetCaster()
	projectile =
		{
			Target 				= target,
			Source 				= caster,
			Ability 			= self,
			EffectName 			= "particles/hero/vengefulspirit/rancor_magic_missile.vpcf",
			iMoveSpeed			= 1350,
			vSpawnOrigin 		= caster:GetAbsOrigin(),
			bDrawsOnMinimap 	= false,
			bDodgeable 			= true,
			bIsAttack 			= false,
			bVisibleToEnemies 	= true,
			bReplaceExisting 	= false,
			flExpireTime 		= GameRules:GetGameTime() + 10,
			bProvidesVision 	= false,
		--	iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
		--	iVisionRadius 		= 400,
		--	iVisionTeamNumber 	= caster:GetTeamNumber()
		}
	ProjectileManager:CreateTrackingProjectile(projectile)
end

function imba_vengefulspirit_nether_swap:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		-- Parameters
		local swapback_delay = self:GetTalentSpecialValueFor("swapback_delay")
		local swapback_duration = self:GetSpecialValueFor("swapback_duration")
		local tree_radius = self:GetSpecialValueFor("tree_radius")

		-- If the target possesses a ready Linken's Sphere, do nothing
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(self) then
				return nil
			end
		end

		-- Ministun the target if it's an enemy
		if target:GetTeamNumber() ~= caster:GetTeamNumber() then
			target:AddNewModifier(caster, self, "modifier_stunned", {duration = 0.1})
		end

		-- Play sounds
		caster:EmitSound("Hero_VengefulSpirit.NetherSwap")
		target:EmitSound("Hero_VengefulSpirit.NetherSwap")

		-- Disjoint projectiles
		ProjectileManager:ProjectileDodge(caster)
		if target:GetTeamNumber() == caster:GetTeamNumber() then
			ProjectileManager:ProjectileDodge(target)
		end

		-- Play caster particle
		local caster_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControlEnt(caster_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(caster_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

		-- Play target particle
		local target_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControlEnt(target_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(target_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

		local target_loc = target:GetAbsOrigin()
		local caster_loc = caster:GetAbsOrigin()

		-- Adjust target's position if it is inside the enemy fountain
		local fountain_loc
		if target:GetTeam() == DOTA_TEAM_GOODGUYS then
			fountain_loc = Vector(7472, 6912, 512)
		else
			fountain_loc = Vector(-7456, -6938, 528)
		end
		if (caster_loc - fountain_loc):Length2D() < 1700 then
			caster_loc = fountain_loc + (target_loc - fountain_loc):Normalized() * 1700
		end

		-- Swap positions
		Timers:CreateTimer(FrameTime(), function()
			FindClearSpaceForUnit(caster, target_loc, true)
			FindClearSpaceForUnit(target, caster_loc, true)

			-- #6 Talent - cast weak meteors
			if caster:HasTalent("special_bonus_imba_vengefulspirit_6") then
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, caster:FindTalentValue("special_bonus_imba_vengefulspirit_6", "radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _, enemy in pairs(enemies) do
					self:CastTalentMeteor(enemy)
				end
				if #enemies >= 1 then
					local sound = "Hero_VengefulSpirit.MagicMissile"
					if caster.magic_missile_sound then
						sound = caster.magic_missile_sound
					end
					caster:EmitSound(sound)
				end
			end
		end)

		-- Destroy trees around start and end areas
		GridNav:DestroyTreesAroundPoint(caster_loc, tree_radius, false)
		GridNav:DestroyTreesAroundPoint(target_loc, tree_radius, false)

		local ability_handle = caster:FindAbilityByName("imba_vengefulspirit_swap_back")
		-- Swap positions
		Timers:CreateTimer(swapback_delay, function()
			caster:AddNewModifier(caster, self, "modifier_imba_nether_swap", {duration = swapback_duration})
			ability_handle.position = caster_loc
		end)
	end
end

function imba_vengefulspirit_nether_swap:OnUpgrade()
	local ability_handle = self:GetCaster():FindAbilityByName("imba_vengefulspirit_swap_back")

	if ability_handle then
		-- Upgrades Return to level 1 and make it inactive, if it hasn't already
		if ability_handle:GetLevel() < 1 then
			ability_handle:SetLevel(1)
			ability_handle:SetActivated(false)
		end
	end
end

function imba_vengefulspirit_nether_swap:GetAssociatedSecondaryAbilities()
	return "imba_vengefulspirit_swap_back"
end

function imba_vengefulspirit_nether_swap:OnProjectileHit(target, location)
	local caster = self:GetCaster()

	if target then
		local damage = caster:FindTalentValue("special_bonus_imba_vengefulspirit_6", "damage")
		local stun_duration = caster:FindTalentValue("special_bonus_imba_vengefulspirit_6", "stun_duration")
		ApplyDamage({victim = target, attacker = caster, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
		if not target:IsMagicImmune() then
			target:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration})
		end
	end

	local sound_hit = "Hero_VengefulSpirit.MagicMissileImpact"
	if caster.magic_missile_sound_hit then
		sound_hit = caster.magic_missile_sound_hit
	end

	EmitSoundOnLocationWithCaster(location, sound_hit, caster)
end

function imba_vengefulspirit_nether_swap:OnOwnerDied()
	local caster = self:GetCaster()
	if self:GetLevel() > 0 and caster:HasScepter() and( not caster:IsIllusion() ) then
		local super_illusion = CreateUnitByName(caster:GetUnitName(), caster:GetAbsOrigin(), true, caster, nil, caster:GetTeam())
		super_illusion:AddNewModifier(caster, self, "modifier_illusion", {outgoing_damage = -(100 - self:GetSpecialValueFor("tooltip_illu_dmg_scepter")), incoming_damage = -(100 - self:GetSpecialValueFor("tooltip_illu_amp_scepter"))})
		super_illusion:AddNewModifier(caster, self, "modifier_vengefulspirit_hybrid_special", {}) -- speshul snowflek modifier from vanilla
		super_illusion:SetRespawnsDisabled(true)
		super_illusion:MakeIllusion()

		super_illusion:SetControllableByPlayer(caster:GetPlayerID(), true)
		super_illusion:SetPlayerID(caster:GetPlayerID())

		local parent_level = caster:GetLevel()
		for i=1, parent_level-1 do
			super_illusion:HeroLevelUp(false)
		end

		-- Set the skill points to 0 and learn the skills of the caster
		super_illusion:SetAbilityPoints(0)
		for abilitySlot=0,15 do
			local ability = caster:GetAbilityByIndex(abilitySlot)
			if ability ~= nil then
				local abilityLevel = ability:GetLevel()
				local abilityName = ability:GetAbilityName()
				local illusionAbility = super_illusion:FindAbilityByName(abilityName)
				if illusionAbility then
					illusionAbility:SetLevel(abilityLevel)
				end
			end
		end

		-- Recreate the items of the caster
		for itemSlot=0,5 do
			local item = caster:GetItemInSlot(itemSlot)
			if item ~= nil then
				local itemName = item:GetName()
				local newItem = CreateItem(itemName, super_illusion, super_illusion)
				super_illusion:AddItem(newItem)
			end
		end
	end
end
-------------------------------------------
modifier_imba_nether_swap = class({})
function modifier_imba_nether_swap:IsDebuff() return false end
function modifier_imba_nether_swap:IsHidden() return true end
function modifier_imba_nether_swap:IsPurgable() return false end
function modifier_imba_nether_swap:IsPurgeException() return false end
function modifier_imba_nether_swap:IsStunDebuff() return false end
function modifier_imba_nether_swap:RemoveOnDeath() return false end
-------------------------------------------

function modifier_imba_nether_swap:OnCreated()
	if IsServer() then
		local ability_handle = self:GetCaster():FindAbilityByName("imba_vengefulspirit_swap_back")
		if ability_handle then
			ability_handle:SetActivated(true)
		end
	end
end

function modifier_imba_nether_swap:OnDestroy()
	if IsServer() then
		local ability_handle = self:GetCaster():FindAbilityByName("imba_vengefulspirit_swap_back")
		if ability_handle then
			ability_handle:SetActivated(false)
		end
	end
end

-------------------------------------------
--            SWAPBACK
-------------------------------------------
LinkLuaModifier("modifier_imba_swap_back", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)

imba_vengefulspirit_swap_back = class({})
function imba_vengefulspirit_swap_back:IsHiddenWhenStolen() return false end
function imba_vengefulspirit_swap_back:IsRefreshable() return true end
function imba_vengefulspirit_swap_back:IsStealable() return true end
function imba_vengefulspirit_swap_back:IsNetherWardStealable() return false end

function imba_vengefulspirit_swap_back:GetAbilityTextureName()
	return "custom/vengeful_swap_back"
end
-------------------------------------------
function imba_vengefulspirit_swap_back:GetAssociatedPrimaryAbilities()
	return "imba_vengefulspirit_nether_swap"
end

function imba_vengefulspirit_swap_back:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self.position

		local ability_handle = caster:FindAbilityByName("imba_vengefulspirit_nether_swap")
		local tree_radius = ability_handle:GetSpecialValueFor("tree_radius")
		-- Play sounds
		caster:EmitSound("Hero_VengefulSpirit.NetherSwap")

		-- Disjoint projectiles
		ProjectileManager:ProjectileDodge(caster)

		-- Play particle
		local swap_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(swap_pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(swap_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

		FindClearSpaceForUnit(caster, target_loc, true)
		-- #6 Talent - cast weak meteors
		if caster:HasTalent("special_bonus_imba_vengefulspirit_6") then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, caster:FindTalentValue("special_bonus_imba_vengefulspirit_6", "radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				ability_handle:CastTalentMeteor(enemy)
			end
		end

		-- Destroy trees around end area
		GridNav:DestroyTreesAroundPoint(target_loc, tree_radius, false)

		if caster:HasModifier("modifier_imba_nether_swap") then
			caster:RemoveModifierByNameAndCaster("modifier_imba_nether_swap", caster)
		end
	end
end

-- This modifier is there to set the ability hidden when gained through illusion or spellsteal
function imba_vengefulspirit_swap_back:GetIntrinsicModifierName()
	return "modifier_imba_swap_back"
end

-------------------------------------------
modifier_imba_swap_back = class({})
function modifier_imba_swap_back:IsDebuff() return false end
function modifier_imba_swap_back:IsHidden() return true end
function modifier_imba_swap_back:IsPurgable() return false end
function modifier_imba_swap_back:IsPurgeException() return false end
function modifier_imba_swap_back:IsStunDebuff() return false end
function modifier_imba_swap_back:RemoveOnDeath() return false end
-------------------------------------------

function modifier_imba_swap_back:OnCreated()
	if IsServer() then
		self:GetAbility():SetActivated(false)
	end
end
