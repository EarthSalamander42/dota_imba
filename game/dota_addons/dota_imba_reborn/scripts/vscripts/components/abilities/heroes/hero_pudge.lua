-- Editors:
--     MouJiaoZi, 05.01.2018

--------------------------------------------------------
---- PUDGE'S HOOK
--------------------------------------------------------

imba_pudge_meat_hook = imba_pudge_meat_hook or class({})
imba_pudge_sharp_hook = imba_pudge_sharp_hook or class({})
imba_pudge_light_hook = imba_pudge_light_hook or class({})

LinkLuaModifier("modifier_imba_hook_sharp_stack","components/abilities/heroes/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hook_light_stack","components/abilities/heroes/hero_pudge", LUA_MODIFIER_MOTION_NONE)

function imba_pudge_sharp_hook:GetIntrinsicModifierName() return "modifier_imba_hook_sharp_stack" end
function imba_pudge_light_hook:GetIntrinsicModifierName() return "modifier_imba_hook_light_stack" end

function imba_pudge_sharp_hook:OnToggle()
	local toggle = self:GetToggleState()
	local buff = self:GetCaster():FindModifierByName("modifier_imba_hook_sharp_stack")
	local another_ability = self:GetCaster():FindAbilityByName("imba_pudge_light_hook")

	if toggle and another_ability:GetToggleState() then
		another_ability:ToggleAbility()
	end

	if toggle then
		buff:StartIntervalThink(self:GetSpecialValueFor("think_interval"))
	else
		buff:StartIntervalThink(-1)
	end
end

function imba_pudge_light_hook:OnToggle()
	local toggle = self:GetToggleState()
	local buff = self:GetCaster():FindModifierByName("modifier_imba_hook_light_stack")
	local another_ability = self:GetCaster():FindAbilityByName("imba_pudge_sharp_hook")

	if toggle and another_ability:GetToggleState() then
		another_ability:ToggleAbility()
	end

	if toggle then
		buff:StartIntervalThink(self:GetSpecialValueFor("think_interval"))
	else
		buff:StartIntervalThink(-1)
	end
end

function imba_pudge_sharp_hook:OnInventoryContentsChanged()
	if IsClient() then return end

	if self:GetCaster():HasModifier("modifier_imba_hook_sharp_stack") then
		if self:GetCaster():FindModifierByName("modifier_imba_hook_sharp_stack"):GetStackCount() + self:GetCaster():FindModifierByName("modifier_imba_hook_light_stack"):GetStackCount() ~= UpdateHookStacks(self:GetCaster()) * 2 then
			self:GetCaster():FindModifierByName("modifier_imba_hook_sharp_stack"):SetStackCount(UpdateHookStacks(self:GetCaster()))
		end
	end
end

function imba_pudge_light_hook:OnInventoryContentsChanged()
	if IsClient() then return end

	if self:GetCaster():HasModifier("modifier_imba_hook_light_stack") then
		if self:GetCaster():FindModifierByName("modifier_imba_hook_sharp_stack"):GetStackCount() + self:GetCaster():FindModifierByName("modifier_imba_hook_light_stack"):GetStackCount() ~= UpdateHookStacks(self:GetCaster()) * 2 then
			self:GetCaster():FindModifierByName("modifier_imba_hook_light_stack"):SetStackCount(UpdateHookStacks(self:GetCaster()))
		end
	end
end

function imba_pudge_sharp_hook:GetAbilityTextureName()
	if not IsClient() then return end
	if not self:GetCaster().arcana_style then return "custom/pudge_sharp_hook" end
	return "custom/pudge_sharp_hook_arcana_style"..self:GetCaster().arcana_style
end

function imba_pudge_light_hook:GetAbilityTextureName()
	if not IsClient() then return end
	if not self:GetCaster().arcana_style then return "custom/pudge_light_hook" end
	return "custom/pudge_light_hook_arcana_style"..self:GetCaster().arcana_style
end

modifier_imba_hook_sharp_stack = modifier_imba_hook_sharp_stack or class({})
modifier_imba_hook_light_stack = modifier_imba_hook_light_stack or class({})

function modifier_imba_hook_sharp_stack:IsDebuff() return false end
function modifier_imba_hook_sharp_stack:IsHidden() return false end
function modifier_imba_hook_sharp_stack:IsPurgable() return false end
function modifier_imba_hook_sharp_stack:IsStunDebuff() return false end
function modifier_imba_hook_sharp_stack:RemoveOnDeath() return false end

function modifier_imba_hook_sharp_stack:OnCreated()
	if IsClient() then return end

	if self:GetCaster() and self:GetCaster().FindAbilityByName and self:GetCaster():FindAbilityByName("imba_pudge_meat_hook") then
		self:SetStackCount(UpdateHookStacks(self:GetCaster()))
	end
end

function modifier_imba_hook_sharp_stack:OnIntervalThink()
	if IsServer() then
		local buff = self:GetCaster():FindModifierByName("modifier_imba_hook_light_stack")
		if not buff then return end
		if buff:GetStackCount() > 0 then
			buff:SetStackCount(buff:GetStackCount() - 1)
			self:SetStackCount(self:GetStackCount() + 1)
		else
			self:GetAbility():ToggleAbility()
		end
	end
end

function modifier_imba_hook_light_stack:IsDebuff() return false end
function modifier_imba_hook_light_stack:IsHidden() return false end
function modifier_imba_hook_light_stack:IsPurgable() return false end
function modifier_imba_hook_light_stack:IsStunDebuff() return false end
function modifier_imba_hook_light_stack:RemoveOnDeath() return false end

function modifier_imba_hook_light_stack:OnCreated()
	if IsClient() then return end

	if self:GetCaster() and self:GetCaster().FindAbilityByName and self:GetCaster():FindAbilityByName("imba_pudge_meat_hook") then
		self:SetStackCount(UpdateHookStacks(self:GetCaster()))
	end
end

function modifier_imba_hook_light_stack:OnIntervalThink()
	if IsServer() then
		local buff = self:GetCaster():FindModifierByName("modifier_imba_hook_sharp_stack")
		if not buff then return end
		if buff:GetStackCount() > 0 then
			buff:SetStackCount(buff:GetStackCount() - 1)
			self:SetStackCount(self:GetStackCount() + 1)
		else
			self:GetAbility():ToggleAbility()
		end
	end
end

LinkLuaModifier("modifier_imba_pudge_meat_hook_caster_root","components/abilities/heroes/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hook_target_enemy","components/abilities/heroes/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hook_target_ally","components/abilities/heroes/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_pudge_meat_hook_handler","components/abilities/heroes/hero_pudge", LUA_MODIFIER_MOTION_NONE)

function imba_pudge_meat_hook:IsHiddenWhenStolen() return false end
function imba_pudge_meat_hook:IsRefreshable() 			return true  end
function imba_pudge_meat_hook:IsStealable() 			return true  end
function imba_pudge_meat_hook:IsNetherWardStealable() 	return true end

function imba_pudge_meat_hook:OnUpgrade()
	local ability1 = self:GetCaster():FindAbilityByName("imba_pudge_sharp_hook")
	local ability2 = self:GetCaster():FindAbilityByName("imba_pudge_light_hook")
	if ability1 then ability1:SetLevel(self:GetLevel()) end
	if ability2 then ability2:SetLevel(self:GetLevel()) end
	if not self:GetCaster().successful_hooks then self:GetCaster().successful_hooks = 0 end

	local dmg_hook_buff = self:GetCaster():AddNewModifier(self:GetCaster(), ability1, "modifier_imba_hook_sharp_stack", {})
	local spd_hook_buff = self:GetCaster():AddNewModifier(self:GetCaster(), ability2, "modifier_imba_hook_light_stack", {})

	dmg_hook_buff:SetStackCount(UpdateHookStacks(self:GetCaster()))
	spd_hook_buff:SetStackCount(UpdateHookStacks(self:GetCaster()))
end

function imba_pudge_meat_hook:GetCastRange()
	local hook_range = self:GetSpecialValueFor("base_range") + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_5")
	local charges = self:GetCaster():GetModifierStackCount("modifier_imba_hook_light_stack", self:GetCaster())
	
	-- -- volvo?
	-- -- TODO: This is not working because GetCastRange is clientside
	-- if self:GetCaster() and self:GetCaster().FindAbilityByName and self:GetCaster():FindAbilityByName("imba_pudge_light_hook") then
		-- hook_range = hook_range + (self:GetCaster():FindAbilityByName("imba_pudge_light_hook"):GetSpecialValueFor("stack_range") * charges)
	-- end

	-- if IsClient() then
		-- --print(charges, hook_range)
	-- end

	-- return hook_range
	
	-- One value here is hard-coded for now due to relying on the abilityvalue of another ability which breaks client-side design
	return hook_range + (charges * 10)
end

function imba_pudge_meat_hook:OnAbilityPhaseStart()
	if self.launched then
		return false
	end
	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
	return true
end

function imba_pudge_meat_hook:OnAbilityPhaseInterrupted()
	local caster = self:GetCaster()
	caster:RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
	--Should fix meat hook breaking sometimes
	self.launched = false
end

function imba_pudge_meat_hook:OnOwnerDied()
	self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 );
	self:GetCaster():RemoveGesture( ACT_DOTA_CHANNEL_ABILITY_1 );

	-- Allow again to launch meat hook
	self.launched = false
	
	-- Get rid of lingering modifiers for Rubick
	if self:IsStolen() then
		if self:GetCaster():HasModifier("modifier_imba_hook_sharp_stack") then
			self:GetCaster():RemoveModifierByName("modifier_imba_hook_sharp_stack")
		end
		
		if self:GetCaster():HasModifier("modifier_imba_hook_light_stack") then
			self:GetCaster():RemoveModifierByName("modifier_imba_hook_light_stack")
		end
	end
end

function imba_pudge_meat_hook:CastFilterResultLocation(vLocation)
	if not IsServer() then return end

	if IsNearFountain(vLocation, 1700) then
		return UF_FAIL_CUSTOM
	end
end

function imba_pudge_meat_hook:GetCustomCastErrorLocation(vLocation)
	return "Cannot Hook Units Located Within Fountain"
end


function imba_pudge_meat_hook:OnSpellStart()
	self.launched = true

	if not self:GetCaster():HasTalent("special_bonus_imba_pudge_7") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_pudge_meat_hook_caster_root", {})
	end
	local vHookOffset = Vector( 0, 0, 96 )
	local target_position = GetGroundPosition(self:GetCursorPosition() + vHookOffset, self:GetCaster())

	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if target_position == self:GetCaster():GetAbsOrigin() then
		target_position = target_position + self:GetCaster():GetForwardVector()
	end

	local dmg_hook_buff = self:GetCaster():FindModifierByName("modifier_imba_hook_sharp_stack")
	local spd_hook_buff = self:GetCaster():FindModifierByName("modifier_imba_hook_light_stack")

	local hook_width = self:GetSpecialValueFor("hook_width") + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_3")
	local hook_speed = self:GetSpecialValueFor("base_speed") + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_2")
	-- local hook_range = self:GetSpecialValueFor("base_range") + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_5")
	local stack_speed = 0
	local stack_range = 0
	if self:GetCaster():HasAbility("imba_pudge_light_hook") then
		stack_speed = self:GetCaster():FindAbilityByName("imba_pudge_light_hook"):GetSpecialValueFor("stack_speed")
		stack_range = self:GetCaster():FindAbilityByName("imba_pudge_light_hook"):GetSpecialValueFor("stack_range")
	end
	local hook_dmg = self:GetSpecialValueFor("base_damage")
	local stack_dmg = 0

	if self:GetCaster():HasAbility("imba_pudge_light_hook") then
		stack_dmg = self:GetCaster():FindAbilityByName("imba_pudge_sharp_hook"):GetSpecialValueFor("stack_damage")
	end

	if spd_hook_buff then
		hook_speed = hook_speed + stack_speed * spd_hook_buff:GetStackCount()
		-- hook_range = hook_range + stack_range * spd_hook_buff:GetStackCount()
	end

	if dmg_hook_buff then
		hook_dmg = hook_dmg + stack_dmg * dmg_hook_buff:GetStackCount()
	end

	--[[
	pfx shit:
	cp 0: pudge's hand
	cp 1: target position
	cp 2: speed, distance, width
	cp 3: max duration, 0, 0
	cp 4: 1,0,0
	cp 5: 0,0,0
	]]
	--[[finall date:
	hook_speed
	hook_range
	hook_dmg
	hook_width
	]]
	
	if not self:GetCaster().hook_pfx then
		--self:GetCaster().hook_pfx = "particles/units/heroes/hero_pudge/pudge_meathook.vpcf"
		self:GetCaster().hook_pfx = "particles/econ/items/pudge/pudge_dragonclaw/pudge_meathook_dragonclaw_imba.vpcf"
	end

	local vKillswitch = Vector((((self:GetCastRange() + GetCastRangeIncrease(self:GetCaster())) / hook_speed) * 2) + 10, 0, 0)
	local hook_particle = ParticleManager:CreateParticle(self:GetCaster().hook_pfx, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleAlwaysSimulate(hook_particle)
	ParticleManager:SetParticleControlEnt(hook_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", self:GetCaster():GetAbsOrigin() + vHookOffset, true)
	ParticleManager:SetParticleControl(hook_particle, 2, Vector(hook_speed, self:GetCastRange() + GetCastRangeIncrease(self:GetCaster()), hook_width))
	ParticleManager:SetParticleControl(hook_particle, 3, vKillswitch)
	ParticleManager:SetParticleControl(hook_particle, 4, Vector( 1, 0, 0 ) )
	ParticleManager:SetParticleControl(hook_particle, 5, Vector( 0, 0, 0 ) )
	
	if self:GetCaster().hook_pfx == "particles/units/heroes/hero_pudge/pudge_meathook.vpcf" then
		ParticleManager:SetParticleControlEnt(hook_particle, 7, self:GetCaster(), PATTACH_CUSTOMORIGIN, nil, self:GetCaster():GetOrigin(), true)
	end

	local projectile_info = {
		Ability = self,
		EffectName = nil,
		vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
		fDistance = self:GetCastRange() + GetCastRangeIncrease(self:GetCaster()),
		fStartRadius = hook_width,
		fEndRadius = hook_width,
		Source = self:GetCaster(),
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + ((self:GetCastRange() + GetCastRangeIncrease(self:GetCaster()) / hook_speed)),
		vVelocity = (target_position - self:GetCaster():GetAbsOrigin()):Normalized() * hook_speed,
		bProvidesVision = false,
		bDeleteOnHit = true,
		ExtraData = {
			hook_width = hook_width,
			hook_dmg = hook_dmg,
			hook_spd = hook_speed,
			pfx_index = hook_particle,
			goorback = "go",
			rune = -1,
		}
	}
	self.hook_go = ProjectileManager:CreateLinearProjectile(projectile_info)

	if self:GetCaster() and self:GetCaster():IsHero() then
		local hHook = self:GetCaster().hook_wearable
		if hHook ~= nil and not hHook:IsNull() then
			hHook:AddEffects( EF_NODRAW )
		end
	end

	EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Hero_Pudge.AttackHookExtend", caster)
end

local hooked_loc
function imba_pudge_meat_hook:OnProjectileThink_ExtraData(vLocation, ExtraData)

	if ExtraData.goorback == "go" then
		ParticleManager:SetParticleControl(ExtraData.pfx_index, 1, vLocation)
		-- Hook Rune Think
		local location = vLocation
		local radius = ExtraData.hook_width
		local runes = {
			"models/props_gameplay/rune_goldxp.vmdl",
			"models/props_gameplay/rune_haste01.vmdl",
			"models/props_gameplay/rune_doubledamage01.vmdl",
			"models/props_gameplay/rune_regeneration01.vmdl",
			"models/props_gameplay/rune_arcane.vmdl",
			"models/props_gameplay/rune_invisibility01.vmdl",
			"models/props_gameplay/rune_illusion01.vmdl",
			"models/props_gameplay/rune_frost.vmdl",
			"models/props_gameplay/gold_coin001.vmdl",	-- Overthrow coin
		}

		--check if there are runes to grab
		for _, ent in pairs(Entities:FindAllInSphere(location, radius)) do
			for _, model in pairs(runes) do
				for _, rune in pairs(Entities:FindAllByModel(model)) do
					if (location - rune:GetAbsOrigin()):Length2D() < radius then
						ExtraData.rune = rune:entindex()
						self:OnProjectileHit_ExtraData(nil, location, ExtraData) --grab the rune
					end
				end
			end
		end
	end

	if ExtraData.goorback ~= "back" then
		hooked_loc = vLocation
	elseif ExtraData.goorback == "back" then
		if EntIndexToHScript(ExtraData.rune) then
			local rune = EntIndexToHScript(ExtraData.rune)
			ParticleManager:SetParticleControlEnt(ExtraData.pfx_index, 1, rune, PATTACH_POINT_FOLLOW, "attach_hitloc", rune:GetAbsOrigin() + Vector( 0, 0, 96 ), true)
			rune:SetAbsOrigin(GetGroundPosition(vLocation, self:GetCaster()))
		else
			local target = EntIndexToHScript(ExtraData.hooked_target)
			local location = vLocation + (self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Normalized() * (ExtraData.hook_spd / (1 / FrameTime()))
			target:SetAbsOrigin(GetGroundPosition(vLocation, target))

			--Talent #7: Grabbed units are ruptured
			if self:GetCaster():GetTeamNumber() ~= target:GetTeamNumber() and not target:IsRune() and self:GetCaster():HasTalent("special_bonus_imba_pudge_7") then
				local damage_cap = self:GetCaster():FindTalentValue("special_bonus_imba_pudge_7", "damage_cap")
				local rupture_damage = self:GetCaster():FindTalentValue("special_bonus_imba_pudge_7", "movement_damage_pct")
				-- vector expected got nil
				local distance_diff = (hooked_loc - target:GetAbsOrigin()):Length2D()

--				print(distance_diff)
				if distance_diff < damage_cap then
					local move_damage = distance_diff * rupture_damage
--					print(move_damage)
					if move_damage > 0 then
						if not target.is_ruptured then
							target.is_ruptured = true
							self.RuptureFX = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf", PATTACH_POINT_FOLLOW, target)
							EmitSoundOn("hero_bloodseeker.rupture.cast", target)
							EmitSoundOn("hero_bloodseeker.rupture", target)
						end

						ApplyDamage({victim = target, attacker = self:GetCaster(), damage = move_damage, damage_type = DAMAGE_TYPE_PURE, ability = self:GetCaster():FindAbilityByName("imba_pudge_meat_hook")})
					end
				end
			end
		end
	end
end

function imba_pudge_meat_hook:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if hTarget then
		local buff1 = hTarget:FindModifierByName("modifier_imba_hook_target_enemy")
		local buff2 = hTarget:FindModifierByName("modifier_imba_hook_target_ally")
	end

	if hTarget and self:GetCaster():GetTeamNumber() ~= hTarget:GetTeamNumber() and (IsNearFountain(hTarget:GetAbsOrigin(), 1700) or IsNearFountain(self:GetCaster():GetAbsOrigin(), 1700)) then
		return false
	end

	if ExtraData.goorback == "go" then
		if self:GetCaster() == hTarget or buff1 or buff2 then
			return
		end
		local root_buff = self:GetCaster():FindModifierByName("modifier_imba_pudge_meat_hook_caster_root")
		if root_buff then
			root_buff:Destroy()
		end
		ParticleManager:SetParticleControl(ExtraData.pfx_index, 4, Vector( 0, 0, 0 ) )
		ParticleManager:SetParticleControl(ExtraData.pfx_index, 5, Vector( 1, 0, 0 ) )
		local target = hTarget
		local bVision = false

		if not target then
			target = CreateUnitByName("npc_dummy_unit", vLocation, false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		end

		ParticleManager:SetParticleControlEnt(ExtraData.pfx_index, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin() + Vector(0,0,96), true)

		if hTarget then
			EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Pudge.AttackHookImpact", hTarget)
			EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Pudge.AttackHookRetract", hTarget)
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_meathook_impact.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
			ParticleManager:SetParticleControlEnt(nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin() + Vector( 0, 0, 96 ), true)
			ParticleManager:ReleaseParticleIndex(nFXIndex)
			bVision = true
			if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
				local dmg = ExtraData.hook_dmg
				local damageTable = {
					victim = hTarget,
					attacker = self:GetCaster(),
					damage = dmg,
					damage_type = DAMAGE_TYPE_PURE,
					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
					ability = self, --Optional.
				}
				local actually_dmg = ApplyDamage(damageTable)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, hTarget, actually_dmg, nil)
				hTarget:AddNewModifier(self:GetCaster(), self, "modifier_imba_hook_target_enemy", {})

				if Battlepass and Battlepass:HasPudgeArcana(self:GetCaster()) then -- error for reasons, maybe because target is dead
					if hTarget:IsRealHero() then
						self:GetCaster().successful_hooks = self:GetCaster().successful_hooks + 1
					else
						self:GetCaster().successful_hooks = 0
					end

					if self:GetCaster().successful_hooks >= 2 then
						EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Hero_Pudge.HookDrag.Arcana", self:GetCaster())
						local pfx = "particles/econ/items/pudge/pudge_arcana/pudge_arcana_red_hook_streak.vpcf"
						if Battlepass and Battlepass:HasPudgeArcana(self:GetCaster()) == 1 then
							pfx = "particles/econ/items/pudge/pudge_arcana/pudge_arcana_hook_streak.vpcf"
						end

						self:GetCaster():EmitSound("Hero.Pudge.Arcana.Streak")

						local hook_counter = ParticleManager:CreateParticle(pfx, PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
						local stack_10 = math.floor(self:GetCaster().successful_hooks / 10)
						ParticleManager:SetParticleControl(hook_counter, 2, Vector(stack_10, self:GetCaster().successful_hooks - stack_10 * 10, self:GetCaster().successful_hooks))
						ParticleManager:ReleaseParticleIndex(hook_counter)
					end
				end
			elseif hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
				hTarget:AddNewModifier(self:GetCaster(), self, "modifier_imba_hook_target_ally", {})
			else
				if Battlepass and Battlepass:HasPudgeArcana(self:GetCaster()) then
					self:GetCaster().successful_hooks = 0
				end
			end
		else
			if Battlepass and Battlepass:HasPudgeArcana(self:GetCaster()) then
				self:GetCaster().successful_hooks = 0
			end
		end

		local projectile_info = {
			Target = self:GetCaster(),
			Source = target,
			Ability = self,
			EffectName = nil,
			iMoveSpeed = ExtraData.hook_spd,
			vSourceLoc = target:GetAbsOrigin(),
			bDrawsOnMinimap = false,
			bDodgeable = false,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			bProvidesVision = bVision,
			iVisionRadius = 400,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			ExtraData = {
				hooked_target = target:entindex(),
				hook_spd = ExtraData.hook_spd,
				pfx_index = ExtraData.pfx_index,
				goorback = "back",
				rune = ExtraData.rune,
			}
		}
		ProjectileManager:CreateTrackingProjectile(projectile_info)
		if self:GetCaster():IsAlive() then
			self:GetCaster():FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
		end
		if self.hook_go then
			ProjectileManager:DestroyLinearProjectile(self.hook_go)
		end
		return true
	end

	if ExtraData.goorback == "back" then
		ParticleManager:DestroyParticle(ExtraData.pfx_index, true)
		ParticleManager:ReleaseParticleIndex(ExtraData.pfx_index)

		local target = EntIndexToHScript(ExtraData.hooked_target)
		target:SetUnitOnClearGround()
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Pudge.AttackHookRetractStop", target)
		self:GetCaster():StopSound("Hero_Pudge.AttackHookExtend")

		if target:GetUnitName() == "npc_dummy_unit" then
			target:ForceKill(false)
		else
			target:StopSound("Hero_Pudge.AttackHookImpact")
			target:StopSound("Hero_Pudge.AttackHookRetract")
		end

		self:GetCaster():FadeGesture(ACT_DOTA_CHANNEL_ABILITY_1)

		if self:GetCaster() and self:GetCaster():IsHero() then
			local hHook = self:GetCaster().hook_wearable
			if hHook ~= nil and not hHook:IsNull() then
				hHook:RemoveEffects( EF_NODRAW )
			end

			if target.is_ruptured then
				target.is_ruptured = false
			end

			StopSoundOn( "Hero_Pudge.AttackHookRetract", self:GetCaster())
			StopSoundOn( "Hero_Pudge.AttackHookExtend", self:GetCaster())
			StopSoundOn( "Hero_Pudge.AttackHookRetractStop", self:GetCaster())
		end

		local buff1 = target:FindModifierByName("modifier_imba_hook_target_enemy")
		local buff2 = target:FindModifierByName("modifier_imba_hook_target_ally")
		if buff1 then buff1:Destroy() end
		if buff2 then buff2:Destroy() end

		self.launched = false

		if self.RuptureFX then
			ParticleManager:DestroyParticle(self.RuptureFX, true)
			ParticleManager:ReleaseParticleIndex(self.RuptureFX)
		end

		return true
	end
end

function imba_pudge_meat_hook:GetIntrinsicModifierName()
	return "modifier_imba_pudge_meat_hook_handler"
end

function imba_pudge_meat_hook:GetAbilityTextureName()
	if not IsClient() then return end
	if self:GetCaster().arcana_style then
		return "custom/pudge_meat_hook_arcana_style"..self:GetCaster().arcana_style
	else
		return "pudge_meat_hook"
	end
end

if modifier_imba_pudge_meat_hook_handler == nil then modifier_imba_pudge_meat_hook_handler = class({}) end

function modifier_imba_pudge_meat_hook_handler:IsHidden() return true end
function modifier_imba_pudge_meat_hook_handler:RemoveOnDeath() return false end

function modifier_imba_pudge_meat_hook_handler:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}

	return funcs
end

function modifier_imba_pudge_meat_hook_handler:OnCreated()
	if self:GetCaster():IsIllusion() then self:Destroy() return end
end

function modifier_imba_pudge_meat_hook_handler:GetActivityTranslationModifiers()
	if self:GetCaster().successful_hooks == nil then self:GetCaster().successful_hooks = 0 end

	if self:GetCaster().successful_hooks >= 1 and self:GetCaster().successful_hooks < 3 then
		return "hook_streak_small"
	elseif self:GetCaster().successful_hooks >= 3 and self:GetCaster().successful_hooks < 5 then
		return "hook_streak_medium"
	elseif self:GetCaster().successful_hooks >= 5 then
		return "hook_streak_large"
	end
end

modifier_imba_pudge_meat_hook_caster_root = modifier_imba_pudge_meat_hook_caster_root or class({})

function modifier_imba_pudge_meat_hook_caster_root:IsDebuff() return true end
function modifier_imba_pudge_meat_hook_caster_root:IsHidden() return true end
function modifier_imba_pudge_meat_hook_caster_root:IsPurgable() return false end
function modifier_imba_pudge_meat_hook_caster_root:IsStunDebuff() return false end
function modifier_imba_pudge_meat_hook_caster_root:RemoveOnDeath() return true end

function modifier_imba_pudge_meat_hook_caster_root:CheckState()
	local state =
		{
			[MODIFIER_STATE_ROOTED] = true,
		}
	return state
end

function modifier_imba_pudge_meat_hook_caster_root:OnCreated()
	if not IsServer() then return end
	local disable_items = {"item_tpscroll", "item_travel_boots", "item_travel_boots_2"}
	local caster = self:GetCaster()
	self.disable = {}
	for i=0,8 do
		local item = caster:GetItemInSlot(i)
		for _, check in pairs(disable_items) do
			if item and item:GetAbilityName() == check then
				item:SetActivated(false)
				table.insert(self.disable, item)
				break
			end
		end
	end
end

function modifier_imba_pudge_meat_hook_caster_root:OnDestroy()
	if not IsServer() then return end
	for _,item in pairs(self.disable) do
		if item then
			item:SetActivated(true)
		end
	end
end

modifier_imba_hook_target_enemy = modifier_imba_hook_target_enemy or class({})

function modifier_imba_hook_target_enemy:IsDebuff()
	if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return false
	else
		return true
	end
end

function modifier_imba_hook_target_enemy:IsHidden() return false end
function modifier_imba_hook_target_enemy:IsPurgable() return false end
function modifier_imba_hook_target_enemy:IsStunDebuff() return false end
function modifier_imba_hook_target_enemy:RemoveOnDeath() return false end
function modifier_imba_hook_target_enemy:IsMotionController()  return true end
function modifier_imba_hook_target_enemy:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end

-- Adding this to prevent bricking from Rubick
function modifier_imba_hook_target_enemy:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_imba_hook_target_enemy:OnIntervalThink()
	if not self:GetAbility() then
		self:Destroy()
	end
end

function modifier_imba_hook_target_enemy:CheckState()
	local state_ally =
		{
			[MODIFIER_STATE_ROOTED] = true,
		}
	local state_enemy =
		{
			[MODIFIER_STATE_STUNNED] = true,
		}
	if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return state_ally
	else
		return state_enemy
	end
end

modifier_imba_hook_target_ally = modifier_imba_hook_target_ally or class({})

function modifier_imba_hook_target_ally:IsDebuff()
	if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return false
	else
		return true
	end
end

function modifier_imba_hook_target_ally:IsHidden() return false end
function modifier_imba_hook_target_ally:IsPurgable() return false end
function modifier_imba_hook_target_ally:IsStunDebuff() return false end
function modifier_imba_hook_target_ally:RemoveOnDeath() return false end
function modifier_imba_hook_target_ally:IsMotionController()  return true end
function modifier_imba_hook_target_ally:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end

function modifier_imba_hook_target_ally:CheckState()
	local state_ally =
		{
			[MODIFIER_STATE_ROOTED] = true,
		}
	local state_enemy =
		{
			[MODIFIER_STATE_STUNNED] = true,
		}
	if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return state_ally
	else
		return state_enemy
	end
end

--//=================================================================================================================
--// Pudge's Rot
--//=================================================================================================================

imba_pudge_rot = imba_pudge_rot or class({})

LinkLuaModifier("imba_pudge_rot_active","components/abilities/heroes/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rot_slow","components/abilities/heroes/hero_pudge", LUA_MODIFIER_MOTION_NONE)

function imba_pudge_rot:IsHiddenWhenStolen() 	return false end
function imba_pudge_rot:IsRefreshable() 		return true  end
function imba_pudge_rot:IsStealable() 			return true  end
function imba_pudge_rot:IsNetherWardStealable() return false end
function imba_pudge_rot:ResetToggleOnRespawn()	return true end

function imba_pudge_rot:GetCastRange()
	--"modifier_imba_flesh_heap_stacks"
	local caster = self:GetCaster()
	local ability = self
	local charges = self:GetCaster():GetModifierStackCount("modifier_imba_flesh_heap_stacks", self:GetCaster())
	local stack_radius = ability:GetSpecialValueFor("stack_radius")
	local radius = ability:GetSpecialValueFor("base_radius") + charges * stack_radius
	if radius > ability:GetSpecialValueFor("max_radius_tooltip") then
		radius = ability:GetSpecialValueFor("max_radius_tooltip")
	end
	return radius
end

function imba_pudge_rot:OnToggle()
	local toggle = self:GetToggleState()  --true为打开 false为关闭
	local caster = self:GetCaster()
	if toggle then
		caster:AddNewModifier(caster, self, "imba_pudge_rot_active", {})
	else
		local buff = caster:FindModifierByName("imba_pudge_rot_active")
		if buff then
			buff:Destroy()
		end
	end
end

function imba_pudge_rot:GetAbilityTextureName()
	if not IsClient() then return end
	if not self:GetCaster().arcana_style then return "pudge_rot" end
	return "custom/pudge_rot_arcana_style"..self:GetCaster().arcana_style
end

imba_pudge_rot_active = imba_pudge_rot_active or class({})

function imba_pudge_rot_active:IsDebuff()				return false end
function imba_pudge_rot_active:IsHidden() 				return true end
function imba_pudge_rot_active:IsPurgable() 			return false end
function imba_pudge_rot_active:IsPurgeException() 		return false end
function imba_pudge_rot_active:IsStunDebuff() 			return false end

function imba_pudge_rot_active:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local buff = caster:FindModifierByName("modifier_imba_flesh_heap_stacks")
		self.radius = ability:GetSpecialValueFor("base_radius")
--		print("Rot radius:", self.radius)

		if buff then
			local stack_radius = ability:GetSpecialValueFor("stack_radius")
			self.radius = self.radius + buff:GetStackCount() * stack_radius
		end

		if self.radius > ability:GetSpecialValueFor("max_radius_tooltip") then
			self.radius = ability:GetSpecialValueFor("max_radius_tooltip")
		end

		self:OnIntervalThink()
		self:StartIntervalThink(ability:GetSpecialValueFor("rot_tick"))
		self:GetParent():StartGesture(ACT_DOTA_CHANNEL_ABILITY_2)
		EmitSoundOn("Hero_Pudge.Rot", caster)

		local pfx_name = "particles/units/heroes/hero_pudge/pudge_rot.vpcf"
		self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.radius, 0, 0))
	end
end

function imba_pudge_rot_active:OnIntervalThink()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local dmg = (ability:GetSpecialValueFor("rot_damage") + caster:GetMaxHealth() * ability:GetSpecialValueFor("bonus_damage") / 100 + caster:FindTalentValue("special_bonus_imba_pudge_6")) / (1 / ability:GetSpecialValueFor("rot_tick"))
	local selfDamageTable = {
		victim = caster,
		attacker = caster,
		damage = dmg,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		ability = ability,
	}
	ApplyDamage(selfDamageTable)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	for _, enemy in pairs(enemies) do
		local DamageTable = {
			victim = enemy,
			attacker = caster,
			damage = dmg,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			ability = ability,
		}
		ApplyDamage(DamageTable)
		local stick = ability:GetSpecialValueFor("rot_stickyness")
		enemy:AddNewModifier(caster, ability, "modifier_imba_rot_slow", {duration = stick})
	end
end

function imba_pudge_rot_active:OnDestroy()
	local caster = self:GetCaster()
	StopSoundOn("Hero_Pudge.Rot", caster)

	if IsServer() then
		self:GetParent():FadeGesture(ACT_DOTA_CHANNEL_ABILITY_2)

		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end

modifier_imba_rot_slow = modifier_imba_rot_slow or class({})

function modifier_imba_rot_slow:IsDebuff() return true end
function modifier_imba_rot_slow:IsHidden() return false end
function modifier_imba_rot_slow:IsPurgable() return true end
function modifier_imba_rot_slow:IsStunDebuff() return false end

function modifier_imba_rot_slow:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_imba_rot_slow:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("rot_slow") end

--//=================================================================================================================
--// Pudge's Flesh Heap
--//=================================================================================================================

imba_pudge_flesh_heap = imba_pudge_flesh_heap or class({})

LinkLuaModifier("modifier_imba_flesh_heap_stacks","components/abilities/heroes/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_pudge_flesh_heap_handler","components/abilities/heroes/hero_pudge", LUA_MODIFIER_MOTION_NONE)

function imba_pudge_flesh_heap:GetIntrinsicModifierName()
	return "modifier_imba_flesh_heap_stacks"
end

function imba_pudge_flesh_heap:GetAbilityTextureName()
	if not IsClient() then return end
	if not self:GetCaster().arcana_style then return "pudge_flesh_heap" end
	return "custom/pudge_flesh_heap_arcana_style"..self:GetCaster().arcana_style
end

modifier_imba_pudge_flesh_heap_handler = class({})
function modifier_imba_pudge_flesh_heap_handler:IsDebuff() return false end
function modifier_imba_pudge_flesh_heap_handler:IsHidden() return true end
function modifier_imba_pudge_flesh_heap_handler:IsPurgable() return false end
function modifier_imba_pudge_flesh_heap_handler:RemoveOnDeath() return false end

function modifier_imba_pudge_flesh_heap_handler:DeclareFunctions()
	local decfuncs = {
		MODIFIER_EVENT_ON_DEATH
	}

	return decfuncs
end

function modifier_imba_pudge_flesh_heap_handler:OnDeath(params)
	local caster = self:GetCaster()
	local target = params.unit
		
	-- Checks to make sure death is an enemy hero
	if target:IsRealHero() and caster:GetTeamNumber() ~= target:GetTeamNumber() then
			
		local flesh_heap_range = self:GetAbility():GetSpecialValueFor("range")
		if flesh_heap_range == 0 then
			flesh_heap_range = 2000
		end

		-- Check to make sure death is within range of Pudge
		if (self:GetAbility():GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= flesh_heap_range then
			self:SetStackCount(self:GetStackCount() + 1)
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
			ParticleManager:ReleaseParticleIndex(pfx)
		end
	end
end

modifier_imba_flesh_heap_stacks = modifier_imba_flesh_heap_stacks or class({})

function modifier_imba_flesh_heap_stacks:IsDebuff() return false end
function modifier_imba_flesh_heap_stacks:IsHidden() return false end
function modifier_imba_flesh_heap_stacks:IsPurgable() return false end
function modifier_imba_flesh_heap_stacks:IsStunDebuff() return false end
function modifier_imba_flesh_heap_stacks:RemoveOnDeath() return false end

function modifier_imba_flesh_heap_stacks:OnCreated()
	if IsServer() then
		local ability = self:GetCaster():FindAbilityByName("imba_pudge_flesh_heap") 
		if not self:GetCaster():HasModifier("modifier_imba_pudge_flesh_heap_handler") then
			self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_imba_pudge_flesh_heap_handler", {})
		end
	end

	self:StartIntervalThink(0.1)
end

function modifier_imba_flesh_heap_stacks:OnIntervalThink()
	if not IsServer() then return end
	local buff = self:GetCaster():FindModifierByName("modifier_imba_pudge_flesh_heap_handler")
	if not buff then return end
	self:SetStackCount(buff:GetStackCount())
end

function modifier_imba_flesh_heap_stacks:DeclareFunctions()
	local funcs = {
		--MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}

	return funcs
end

-- function modifier_imba_flesh_heap_stacks:GetModifierMagicalResistanceBonus()
	-- if self:GetCaster():PassivesDisabled() then return end
	-- local base = self:GetAbility():GetSpecialValueFor("base_magic_resist")
	-- local stack_magic_resist = self:GetAbility():GetSpecialValueFor("stack_magic_resist")
	-- local stacks = self:GetStackCount()
	-- local max_stack = self:GetAbility():GetSpecialValueFor("max_stacks") + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_4")
	-- if stacks > max_stack then stacks = max_stack end
	-- return base + stack_magic_resist * stacks
-- end

function modifier_imba_flesh_heap_stacks:GetModifierConstantHealthRegen()
	if self:GetCaster():PassivesDisabled() then return end
	local base = self:GetAbility():GetSpecialValueFor("base_health_regen")
	local stack_health_regen = self:GetAbility():GetSpecialValueFor("stack_health_regen")
	local stacks = self:GetStackCount()
	local max_stack = self:GetAbility():GetSpecialValueFor("max_stacks") + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_4")
	if stacks > max_stack then stacks = max_stack end
	return base + stack_health_regen * stacks
end

function modifier_imba_flesh_heap_stacks:GetModifierBonusStats_Strength()
	if self:GetCaster():PassivesDisabled() then return end
	local stacks = self:GetStackCount()
	local bonusStr = self:GetAbility():GetSpecialValueFor("stack_str")
	return stacks * bonusStr
end

function modifier_imba_flesh_heap_stacks:GetModifierModelScale()
	if self:GetCaster():PassivesDisabled() then return end
	local stacks = self:GetStackCount()
	local max_stack = self:GetAbility():GetSpecialValueFor("max_stacks") + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_4")
	if stacks > max_stack then stacks = max_stack end
	return stacks * 1.75
end

--=================================================================================================================
-- Pudge's Dismember
--=================================================================================================================

imba_pudge_dismember = imba_pudge_dismember or class({})

LinkLuaModifier("modifier_imba_pudge_dismember_handler","components/abilities/heroes/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dismember","components/abilities/heroes/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_pudge_dismember_buff","components/abilities/heroes/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_pudge_dismember_pull", "components/abilities/heroes/hero_pudge", LUA_MODIFIER_MOTION_HORIZONTAL)

function imba_pudge_dismember:GetIntrinsicModifierName()
	return "modifier_imba_pudge_dismember_handler"
end

function imba_pudge_dismember:GetChannelTime()
	return self:GetCaster():GetModifierStackCount("modifier_imba_pudge_dismember_handler", self:GetCaster()) * 0.01
end

function imba_pudge_dismember:OnSpellStart()
	local target = self:GetCursorTarget()

	if self:GetCaster():GetTeamNumber() ~= target:GetTeamNumber() then
		if target:TriggerSpellAbsorb(self) then
			return nil
		end
	end

--	self:GetCaster():StartGesture(ACT_DOTA_CHANNEL_ABILITY_4)

	self.target = target
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_pudge_dismember_buff", {})
	target:AddNewModifier(self:GetCaster(), self, "modifier_imba_dismember", {duration = self:GetChannelTime()})

	if Battlepass and Battlepass:HasPudgeArcana(self:GetCaster()) then
		self.pfx = ParticleManager:CreateParticle("particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_"..target:GetHeroType()..".vpcf", PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControl(self.pfx, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 8, Vector(1, 1, 1))
		ParticleManager:SetParticleControl(self.pfx, 15, target:GetFittingColor())
	else
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_dismember.vpcf", PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	end
end

function imba_pudge_dismember:OnChannelFinish(bInterrupted)
	if self.target then
		local target_buff = self.target:FindModifierByNameAndCaster("modifier_imba_dismember", self:GetCaster())

		if bInterrupted then
			self.target:RemoveModifierByName("modifier_imba_dismember")
		end
	end

	local caster_buff = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_pudge_dismember_buff", self:GetCaster())

	if target_buff then target_buff:Destroy() end
	if caster_buff then caster_buff:Destroy() end

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end

function imba_pudge_dismember:GetAbilityTextureName()
	if not IsClient() then return end
	if not self:GetCaster().arcana_style then return "pudge_dismember" end
	return "custom/pudge_dismember_arcana_style"..self:GetCaster().arcana_style
end

--------------------------------
-- DISMEMBER HANDLER MODIFIER --
--------------------------------

modifier_imba_pudge_dismember_handler	= class({})

function modifier_imba_pudge_dismember_handler:IsHidden()	return true end
-- Grimstroke Soulbind exception (without this line the modifier disappears -_-)
function modifier_imba_pudge_dismember_handler:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_pudge_dismember_handler:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ABILITY_EXECUTED}
	
	return decFuncs
end

-- Going to use this hacky method to determine channel time on UI
-- During the brief time before the ability actually casts, record the target's status resistance * 100 into its intrinsic modifier, then use that divided by 100 as the channel time
function modifier_imba_pudge_dismember_handler:OnAbilityExecuted(keys)
	if not IsServer() then return end
	
	if keys.ability == self:GetAbility() then
		if keys.target:IsHero() then
			self:GetCaster():SetModifierStackCount("modifier_imba_pudge_dismember_handler", self:GetCaster(), self:GetAbility():GetTalentSpecialValueFor("hero_duration") * (1 - keys.target:GetStatusResistance()) * 100)
		else
			self:GetCaster():SetModifierStackCount("modifier_imba_pudge_dismember_handler", self:GetCaster(), self:GetAbility():GetTalentSpecialValueFor("creep_duration") * (1 - keys.target:GetStatusResistance()) * 100)
		end
	end
end

modifier_imba_dismember = class({})

-- Doesn't actually ignore status resist, but this is handled in the channel time function
function modifier_imba_dismember:IgnoreTenacity()	return true end
function modifier_imba_dismember:IsDebuff() return true end
function modifier_imba_dismember:IsHidden() return false end

function modifier_imba_dismember:OnCreated()
	self:StartIntervalThink(1.0)

	self:OnIntervalThink()

	if IsServer() then
		-- Add the pull towards modifier
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_pudge_dismember_pull", {duration = self:GetAbility():GetChannelTime()})
	
		self:GetParent():StartGesture(ACT_DOTA_DISABLED)
	end
end

function modifier_imba_dismember:OnIntervalThink()
	if not IsServer() then return end
	local ability = self:GetAbility()
	local dmg = ability:GetSpecialValueFor("dismember_damage") + self:GetCaster():GetStrength() * ability:GetSpecialValueFor("strength_damage") * 0.01
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = dmg,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		ability = self:GetAbility(),
	}
	ApplyDamage(damageTable)
end

function modifier_imba_dismember:OnDestroy()
	if IsServer() then
		self:GetParent():FadeGesture(ACT_DOTA_DISABLED)
		self:GetCaster():FadeGesture(ACT_DOTA_CHANNEL_ABILITY_4)
		
		-- Status Resistance compromise to make Pudge automatically attack the Dismember target on interrupt
		if self:GetCaster():IsChanneling() then
			self:GetAbility():EndChannel(false)
			self:GetCaster():MoveToPositionAggressive(self:GetParent():GetAbsOrigin())
		end
	end
end

function modifier_imba_dismember:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true,}
	return state
end

modifier_imba_pudge_dismember_buff = modifier_imba_pudge_dismember_buff or class({})

function modifier_imba_pudge_dismember_buff:IsDebuff() return false end
function modifier_imba_pudge_dismember_buff:IsHidden() return true end
function modifier_imba_pudge_dismember_buff:IsPurgable() return false end
function modifier_imba_pudge_dismember_buff:IsStunDebuff() return false end

function modifier_imba_pudge_dismember_buff:GetModifierSpellLifesteal()
	return self:GetAbility():GetSpecialValueFor("spell_lifesteal")
end

function modifier_imba_pudge_dismember_buff:DeclareFunctions()
	local table = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return table
end

function modifier_imba_pudge_dismember_buff:GetActivityTranslationModifiers()
	if self:GetCaster():HasItemInInventory("item_imba_aether_lens") then
		return "long_dismember"
	else
		return ""
	end
end

function modifier_imba_pudge_dismember_buff:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_4
end

-----------------------------
-- DISMEMBER PULL MODIFIER --
-----------------------------

modifier_imba_pudge_dismember_pull = class({})

function modifier_imba_pudge_dismember_pull:OnCreated(params)
	if not IsServer() then return end
	
	self.ability				= self:GetAbility()
	self.caster					= self:GetCaster()
	self.parent					= self:GetParent()
	
	-- AbilitySpecials
	self.pull_units_per_second		= self.ability:GetSpecialValueFor("pull_units_per_second")
	self.pull_distance_limit		= self.ability:GetSpecialValueFor("pull_distance_limit")

	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
		return
	end
end

function modifier_imba_pudge_dismember_pull:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end

	local distance = self.caster:GetOrigin() - me:GetOrigin()
	
	-- Check to see if the victim is farther than the minimum distance or not and is actually being Dismembered
	if distance:Length2D() > self.pull_distance_limit and self.parent:HasModifier("modifier_imba_dismember") then
		-- Pull victim towards Pudge
		me:SetOrigin( me:GetOrigin() + distance:Normalized() * self.pull_units_per_second * dt )
	else
		-- Victim is probably close enough or no longer being Dismembered; remove modifier
		self:Destroy()
	end
end

function modifier_imba_pudge_dismember_pull:OnDestroy()
	if not IsServer() then return end
	
	self.parent:RemoveHorizontalMotionController( self )
end

-- util

function UpdateHookStacks(caster)
	-- Jank exception for Morphling
	if not caster:FindAbilityByName("imba_pudge_meat_hook") then
		local pudge = Entities:FindAllByName("npc_dota_hero_pudge")
		for _, main_hero in pairs(pudge) do			
			local borrowed_stacks = main_hero:FindAbilityByName("imba_pudge_meat_hook"):GetSpecialValueFor("hook_stacks")
			
			if main_hero:HasScepter() then
				stacks = main_hero:FindAbilityByName("imba_pudge_meat_hook"):GetSpecialValueFor("hook_stacks") + main_hero:FindAbilityByName("imba_pudge_meat_hook"):GetSpecialValueFor("scepter_hook_stacks")
			end
		
			return borrowed_stacks
		end
	end
	
	local stacks = caster:FindAbilityByName("imba_pudge_meat_hook"):GetSpecialValueFor("hook_stacks")

	if caster:HasScepter() then
		stacks = caster:FindAbilityByName("imba_pudge_meat_hook"):GetSpecialValueFor("hook_stacks") + caster:FindAbilityByName("imba_pudge_meat_hook"):GetSpecialValueFor("scepter_hook_stacks")
	end

	return stacks
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_pudge_5", "components/abilities/heroes/hero_pudge", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_pudge_5	= class({})

function modifier_special_bonus_imba_pudge_5:IsHidden() 		return true end
function modifier_special_bonus_imba_pudge_5:IsPurgable() 	return false end
function modifier_special_bonus_imba_pudge_5:RemoveOnDeath() 	return false end

function imba_pudge_meat_hook:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_pudge_5") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_pudge_5") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_pudge_5"), "modifier_special_bonus_imba_pudge_5", {})
	end
end
