--[[

			Author: MouJiaoZi
			Date: 2018/01/04

]]


--------------------------------------------------------
---- PUDGE'S HOOK
--------------------------------------------------------

CreateEmptyTalents("pudge")

imba_pudge_meat_hook = imba_pudge_meat_hook or class({})
imba_pudge_sharp_hook = imba_pudge_sharp_hook or class({})
imba_pudge_light_hook = imba_pudge_light_hook or class({})

LinkLuaModifier("modifier_imba_hook_sharp_stack","hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hook_light_stack","hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)

function imba_pudge_sharp_hook:GetIntrinsicModifierName() return "modifier_imba_hook_sharp_stack" end
function imba_pudge_light_hook:GetIntrinsicModifierName() return "modifier_imba_hook_light_stack" end

function imba_pudge_sharp_hook:OnToggle()
	local toggle = self:GetToggleState()  --true为打开 false为关闭
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
	local toggle = self:GetToggleState()  --true为打开 false为关闭
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

modifier_imba_hook_sharp_stack = modifier_imba_hook_sharp_stack or class({})
modifier_imba_hook_light_stack = modifier_imba_hook_light_stack or class({})

function modifier_imba_hook_sharp_stack:IsDebuff() return false end
function modifier_imba_hook_sharp_stack:IsHidden() return false end
function modifier_imba_hook_sharp_stack:IsPurgable() return false end
function modifier_imba_hook_sharp_stack:IsStunDebuff() return false end
function modifier_imba_hook_sharp_stack:RemoveOnDeath() return false end
function modifier_imba_hook_sharp_stack:GetTexture() return "custom/pudge_sharp_hook" end

function modifier_imba_hook_sharp_stack:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.caster_level = 1
	self:SetStackCount(1)
	if self.caster:HasTalent("special_bonus_imba_pudge_1") then
		self:SetStackCount(1 + self.caster:FindTalentValue("special_bonus_imba_pudge_1") / 2)
	end
end

function modifier_imba_hook_sharp_stack:OnIntervalThink()
	if IsServer() then
		local buff = self.caster:FindModifierByName("modifier_imba_hook_light_stack")
		if not buff then return end
		if buff:GetStackCount() > 0 then
			buff:SetStackCount(buff:GetStackCount() - 1)
			self:SetStackCount(self:GetStackCount() + 1)
		else
			self.ability:ToggleAbility()
		end
	end
end

function modifier_imba_hook_light_stack:IsDebuff() return false end
function modifier_imba_hook_light_stack:IsHidden() return false end
function modifier_imba_hook_light_stack:IsPurgable() return false end
function modifier_imba_hook_light_stack:IsStunDebuff() return false end
function modifier_imba_hook_light_stack:RemoveOnDeath() return false end
function modifier_imba_hook_light_stack:GetTexture() return "custom/pudge_light_hook" end

function modifier_imba_hook_light_stack:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.caster_level = 1
	self:SetStackCount(1)
	if self.caster:HasTalent("special_bonus_imba_pudge_1") then
		self:SetStackCount(1 + self.caster:FindTalentValue("special_bonus_imba_pudge_1") / 2)
	end
end

function modifier_imba_hook_light_stack:OnIntervalThink()
	if IsServer() then
		local buff = self.caster:FindModifierByName("modifier_imba_hook_sharp_stack")
		if not buff then return end
		if buff:GetStackCount() > 0 then
			buff:SetStackCount(buff:GetStackCount() - 1)
			self:SetStackCount(self:GetStackCount() + 1)
		else
			self.ability:ToggleAbility()
		end
	end
end

function modifier_special_bonus_imba_pudge_1:OnCreated()
	if not IsServer() then return end
	local dmg_hook_buff = self:GetParent():FindModifierByName("modifier_imba_hook_sharp_stack")
	local spd_hook_buff = self:GetParent():FindModifierByName("modifier_imba_hook_light_stack")
	local stack = self:GetParent():FindTalentValue("special_bonus_imba_pudge_1")
	if dmg_hook_buff and spd_hook_buff then
		dmg_hook_buff:SetStackCount(dmg_hook_buff:GetStackCount() + (stack / 2))
		spd_hook_buff:SetStackCount(spd_hook_buff:GetStackCount() + (stack / 2))
	end
end


LinkLuaModifier("modifier_imba_pudge_meat_hook_stack_controller","hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_pudge_meat_hook_caster_root","hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hook_target_enemy","hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hook_target_ally","hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)

function imba_pudge_meat_hook:GetIntrinsicModifierName() return "modifier_imba_pudge_meat_hook_stack_controller" end

modifier_imba_pudge_meat_hook_stack_controller = modifier_imba_pudge_meat_hook_stack_controller or class({})

function modifier_imba_pudge_meat_hook_stack_controller:IsDebuff() return false end
function modifier_imba_pudge_meat_hook_stack_controller:IsHidden() return true end
function modifier_imba_pudge_meat_hook_stack_controller:IsPurgable() return false end
function modifier_imba_pudge_meat_hook_stack_controller:IsStunDebuff() return false end
function modifier_imba_pudge_meat_hook_stack_controller:RemoveOnDeath() return false end

function modifier_imba_pudge_meat_hook_stack_controller:OnCreated()
	self.caster = self:GetCaster()
	self:StartIntervalThink(1.0)
end

function modifier_imba_pudge_meat_hook_stack_controller:OnIntervalThink()
	if IsServer() then
		local dmg_hook_buff = self.caster:FindModifierByName("modifier_imba_hook_sharp_stack")
		local spd_hook_buff = self.caster:FindModifierByName("modifier_imba_hook_light_stack")
		local caster_level = self.caster:GetLevel()
		if dmg_hook_buff and spd_hook_buff then
			if dmg_hook_buff.caster_level < caster_level and spd_hook_buff.caster_level < caster_level then
				local stacks = caster_level - dmg_hook_buff.caster_level
				dmg_hook_buff.caster_level = caster_level
				spd_hook_buff.caster_level = caster_level
				dmg_hook_buff:SetStackCount(dmg_hook_buff:GetStackCount() + stacks)
				spd_hook_buff:SetStackCount(spd_hook_buff:GetStackCount() + stacks)
			end
		end
	end
end

function imba_pudge_meat_hook:IsHiddenWhenStolen() return false end
function imba_pudge_meat_hook:IsRefreshable() 			return true  end
function imba_pudge_meat_hook:IsStealable() 			return true  end
function imba_pudge_meat_hook:IsNetherWardStealable() 	return true end

function imba_pudge_meat_hook:OnUpgrade()
	local ability1 = self:GetCaster():FindAbilityByName("imba_pudge_sharp_hook")
	local ability2 = self:GetCaster():FindAbilityByName("imba_pudge_light_hook")
	if ability1 then ability1:SetLevel(self:GetLevel()) end
	if ability2 then ability2:SetLevel(self:GetLevel()) end
	if self:IsStolen() then
		local caster = self:GetCaster()
		local dmg_hook_buff = caster:AddNewModifier(caster, self, "modifier_imba_hook_sharp_stack", {})
		local spd_hook_buff = caster:AddNewModifier(caster, self, "modifier_imba_hook_light_stack", {})
	end
end

function imba_pudge_meat_hook:GetCastRange()
	local caster = self:GetCaster()
	local charges = self:GetCaster():GetModifierStackCount("modifier_imba_hook_light_stack", self:GetCaster())
	local hook_range = self:GetSpecialValueFor("base_range") + caster:FindTalentValue("special_bonus_imba_pudge_5") + self:GetSpecialValueFor("stack_range") * charges
	return hook_range
end

function imba_pudge_meat_hook:GetCooldown(nLevel)
	local charges = self:GetCaster():GetModifierStackCount("modifier_imba_hook_sharp_stack", self:GetCaster())
	local cd = self.BaseClass.GetCooldown( self, nLevel )
	if self:GetCaster():HasScepter() then
		cd = self.BaseClass.GetCooldown( self, nLevel ) - charges * self:GetSpecialValueFor("cooldown_scepter")
	end
	local cd_min = self:GetSpecialValueFor("cooldown_cap_scepter")
	if cd < cd_min then
		cd = cd_min
	end
	return cd
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
	local caster = self:GetCaster()
	caster:RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 );
	caster:RemoveGesture( ACT_DOTA_CHANNEL_ABILITY_1 );

	-- Allow again to launch meat hook
	self.launched = false
end	

function imba_pudge_meat_hook:OnSpellStart()

	self.launched = true

	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_imba_pudge_meat_hook_caster_root", {})
	local vHookOffset = Vector( 0, 0, 96 )
	local target_position = self:GetCursorPosition() + vHookOffset

	local dmg_hook_buff = caster:FindModifierByName("modifier_imba_hook_sharp_stack")
	local spd_hook_buff = caster:FindModifierByName("modifier_imba_hook_light_stack")

	local hook_width = self:GetSpecialValueFor("hook_width") + caster:FindTalentValue("special_bonus_imba_pudge_3")
	local hook_speed = self:GetSpecialValueFor("base_speed") + caster:FindTalentValue("special_bonus_imba_pudge_2")
	local stack_speed = self:GetSpecialValueFor("stack_speed")
	local hook_range = self:GetSpecialValueFor("base_range") + caster:FindTalentValue("special_bonus_imba_pudge_5")
	local stack_range = self:GetSpecialValueFor("stack_range")
	local hook_dmg = self:GetSpecialValueFor("base_damage")
	local stack_dmg = self:GetSpecialValueFor("stack_damage")
	local stack_dmg_scepter = self:GetSpecialValueFor("damage_scepter")
	if spd_hook_buff then
		hook_speed = hook_speed + stack_speed * spd_hook_buff:GetStackCount()
		hook_range = hook_range + stack_range * spd_hook_buff:GetStackCount()
		if caster:HasScepter() then
			hook_dmg = hook_dmg + stack_dmg_scepter * spd_hook_buff:GetStackCount()
		end
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

	local vKillswitch = Vector(((hook_range / hook_speed) * 2) + 10, 0, 0)
	local pfx_name = "particles/units/heroes/hero_pudge/pudge_meathook.vpcf"
	local hook_pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleAlwaysSimulate(hook_pfx)
	ParticleManager:SetParticleControlEnt(hook_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", caster:GetAbsOrigin() + vHookOffset, true)
	ParticleManager:SetParticleControl(hook_pfx, 2, Vector(hook_speed, hook_range, hook_width))
	ParticleManager:SetParticleControl(hook_pfx, 3, vKillswitch)
	ParticleManager:SetParticleControl(hook_pfx, 4, Vector( 1, 0, 0 ) )
	ParticleManager:SetParticleControl(hook_pfx, 5, Vector( 0, 0, 0 ) )

	local projectile_info = {
							Ability = self,
							EffectName = nil,
							vSpawnOrigin = caster:GetAbsOrigin(),
							fDistance = hook_range,
							fStartRadius = hook_width,
							fEndRadius = hook_width,
							Source = caster,
							bHasFrontalCone = false,
							bReplaceExisting = false,
							iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
							iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
							iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
							fExpireTime = GameRules:GetGameTime() + ((hook_range / hook_speed)),
							vVelocity = (target_position - caster:GetAbsOrigin()):Normalized() * hook_speed,
							bProvidesVision = false,
							bDeleteOnHit = true,
							ExtraData = {
										hook_width = hook_width,
										hook_dmg = hook_dmg,
										hook_spd = hook_speed,
										pfx_index = hook_pfx,
										goorback = "go",
										rune = -1,
										}
							}
	self.hook_go = ProjectileManager:CreateLinearProjectile(projectile_info)

	if caster and caster:IsHero() then
		local hHook = caster:GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
		if hHook ~= nil then
			hHook:AddEffects( EF_NODRAW )
		end
	end
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Pudge.AttackHookExtend", caster)

end

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
	
	if ExtraData.goorback == "back" then
		if EntIndexToHScript(ExtraData.rune) then
			local rune = EntIndexToHScript(ExtraData.rune)
			ParticleManager:SetParticleControlEnt(ExtraData.pfx_index, 1, rune, PATTACH_POINT_FOLLOW, "attach_hitloc", rune:GetAbsOrigin(), true)
			rune:SetAbsOrigin(GetGroundPosition(vLocation, self:GetCaster()))
		else
			local target = EntIndexToHScript(ExtraData.hooked_target)
			local location = vLocation + (self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Normalized() * (ExtraData.hook_spd / (1 / FrameTime()))
			target:SetAbsOrigin(GetGroundPosition(vLocation, target))
		end
	end
	
end

function imba_pudge_meat_hook:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local caster = self:GetCaster()
	if hTarget then
		local buff1 = hTarget:FindModifierByName("modifier_imba_hook_target_enemy")
		local buff2 = hTarget:FindModifierByName("modifier_imba_hook_target_ally")
	end
	if hTarget and caster:GetTeamNumber() ~= hTarget:GetTeamNumber() and IsNearEnemyFountain(hTarget:GetAbsOrigin(), caster:GetTeamNumber(), 1200) then
		return false
	end

	if ExtraData.goorback == "go" then
		if caster == hTarget or buff1 or buff2 then
			return
		end
		local root_buff = caster:FindModifierByName("modifier_imba_pudge_meat_hook_caster_root")
		if root_buff then
			root_buff:Destroy()
		end
		ParticleManager:SetParticleControl(ExtraData.pfx_index, 4, Vector( 0, 0, 0 ) )
		ParticleManager:SetParticleControl(ExtraData.pfx_index, 5, Vector( 1, 0, 0 ) )
		local target = hTarget
		local bVision = false
		if not target then
			target = CreateUnitByName("npc_dummy_unit", vLocation, false, caster, caster, caster:GetTeamNumber())
		end
		ParticleManager:SetParticleControlEnt(ExtraData.pfx_index, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin() + Vector(0,0,96), true)
		if hTarget then
			EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Pudge.AttackHookImpact", hTarget)
			EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Pudge.AttackHookRetract", hTarget)
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_meathook_impact.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
			ParticleManager:SetParticleControlEnt(nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(nFXIndex)
			bVision = true
			if hTarget:GetTeamNumber() ~= caster:GetTeamNumber() then
				local dmg = ExtraData.hook_dmg
				if caster:HasTalent("special_bonus_imba_pudge_7") then
					local distance = CalcDistanceBetweenEntityOBB(caster, hTarget)
					local talent_dmg = distance * (caster:FindTalentValue("special_bonus_imba_pudge_7", "movement_damage_pct") * 0.01)
					if talent_dmg > caster:FindTalentValue("special_bonus_imba_pudge_7", "damage_cap") then
						talent_dmg = caster:FindTalentValue("special_bonus_imba_pudge_7", "damage_cap")
					end
					dmg = dmg + talent_dmg
				end
				local damageTable = {
									victim = hTarget,
									attacker = caster,
									damage = dmg,
									damage_type = DAMAGE_TYPE_PURE,
									damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
									ability = self, --Optional.
									}
				local actually_dmg = ApplyDamage(damageTable)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, hTarget, actually_dmg, nil)
				hTarget:AddNewModifier(caster, self, "modifier_imba_hook_target_enemy", {})
			else
				hTarget:AddNewModifier(caster, self, "modifier_imba_hook_target_ally", {})
			end
		end
		local projectile_info = {
								Target = caster,
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
								iVisionTeamNumber = caster:GetTeamNumber(),
								ExtraData = {
											hooked_target = target:entindex(),
											hook_spd = ExtraData.hook_spd,
											pfx_index = ExtraData.pfx_index,
											goorback = "back",
											rune = ExtraData.rune,
											}
								}
		ProjectileManager:CreateTrackingProjectile(projectile_info)
		if caster:IsAlive() then
			caster:FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
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
		caster:StopSound("Hero_Pudge.AttackHookExtend")
		if target:GetUnitName() == "npc_dummy_unit" then
			target:ForceKill(false)
		else
			target:StopSound("Hero_Pudge.AttackHookImpact")
			target:StopSound("Hero_Pudge.AttackHookRetract")
		end

		caster:FadeGesture(ACT_DOTA_CHANNEL_ABILITY_1)
		if caster and caster:IsHero() then
			local hHook = caster:GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
			if hHook ~= nil then
				hHook:RemoveEffects( EF_NODRAW )								
			end
			StopSoundOn( "Hero_Pudge.AttackHookRetract", caster)
			StopSoundOn( "Hero_Pudge.AttackHookExtend", caster)
			StopSoundOn( "Hero_Pudge.AttackHookRetractStop", caster)			
		end
		local buff1 = target:FindModifierByName("modifier_imba_hook_target_enemy")
		local buff2 = target:FindModifierByName("modifier_imba_hook_target_ally")
		if buff1 then buff1:Destroy() end
		if buff2 then buff2:Destroy() end

		self.launched = false
		return true
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

LinkLuaModifier("imba_pudge_rot_active","hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rot_slow","hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)

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

imba_pudge_rot_active = imba_pudge_rot_active or class({})

function imba_pudge_rot_active:IsDebuff()				return false end
function imba_pudge_rot_active:IsHidden() 				return true end
function imba_pudge_rot_active:IsPurgable() 			return false end
function imba_pudge_rot_active:IsPurgeException() 		return false end
function imba_pudge_rot_active:IsStunDebuff() 			return false end
function imba_pudge_rot_active:RemoveOnDeath() 			return true end

function imba_pudge_rot_active:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local buff = caster:FindModifierByName("modifier_imba_flesh_heap_stacks")
		self.radius = ability:GetSpecialValueFor("base_radius")
		if buff then
			local stack_radius = ability:GetSpecialValueFor("stack_radius")
			self.radius = self.radius + buff:GetStackCount() * stack_radius
		end
		if self.radius > ability:GetSpecialValueFor("max_radius_tooltip") then
			self.radius = ability:GetSpecialValueFor("max_radius_tooltip")
		end
		self:OnIntervalThink()
		self:StartIntervalThink(ability:GetSpecialValueFor("rot_tick"))
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
	local dmg = ability:GetSpecialValueFor("rot_damage") + caster:GetMaxHealth() * ability:GetSpecialValueFor("bonus_damage") / 100 + caster:FindTalentValue("special_bonus_imba_pudge_6")
	print(dmg, ability:GetSpecialValueFor("rot_damage"), caster:GetMaxHealth() * ability:GetSpecialValueFor("bonus_damage") / 100, caster:FindTalentValue("special_bonus_imba_pudge_6"))
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

imba_pudge_flesh_heap_handle = imba_pudge_flesh_heap_handle or class({})

LinkLuaModifier("modifier_imba_pudge_flesh_heap_handle","hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)

function imba_pudge_flesh_heap_handle:IsInnateAbility() return true end

function imba_pudge_flesh_heap_handle:GetIntrinsicModifierName()
	return "modifier_imba_pudge_flesh_heap_handle"
end

modifier_imba_pudge_flesh_heap_handle = modifier_imba_pudge_flesh_heap_handle or class({})

function modifier_imba_pudge_flesh_heap_handle:IsDebuff() return false end
function modifier_imba_pudge_flesh_heap_handle:IsHidden() return true end
function modifier_imba_pudge_flesh_heap_handle:IsPurgable() return false end
function modifier_imba_pudge_flesh_heap_handle:IsStunDebuff() return false end
function modifier_imba_pudge_flesh_heap_handle:RemoveOnDeath() return false end

function modifier_imba_pudge_flesh_heap_handle:DeclareFunctions()
	local funcs = {MODIFIER_EVENT_ON_DEATH}
	return funcs
end

function modifier_imba_pudge_flesh_heap_handle:OnDeath(keys)
	local unit = keys.unit
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("imba_pudge_flesh_heap")
	if not ability then return end
	local distance = ability:GetLevelSpecialValueFor("range", 1)
	if unit:IsRealHero() and unit:GetTeamNumber() ~= caster:GetTeamNumber() and CalcDistanceBetweenEntityOBB(unit, caster) <= distance then
		self:SetStackCount(self:GetStackCount() + 1)
		if IsServer() then
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:ReleaseParticleIndex(pfx)
		end
	end
end

--[[
imba_pudge_flesh_heap = imba_pudge_flesh_heap or class({})

LinkLuaModifier("modifier_imba_flesh_heap_stacks","hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)

function imba_pudge_flesh_heap:GetIntrinsicModifierName()
	return "modifier_imba_flesh_heap_stacks"
end

modifier_imba_flesh_heap_stacks = modifier_imba_flesh_heap_stacks or class({})

function modifier_imba_flesh_heap_stacks:IsDebuff() return false end
function modifier_imba_flesh_heap_stacks:IsHidden() return false end
function modifier_imba_flesh_heap_stacks:IsPurgable() return false end
function modifier_imba_flesh_heap_stacks:IsStunDebuff() return false end
function modifier_imba_flesh_heap_stacks:RemoveOnDeath() return false end

function modifier_imba_flesh_heap_stacks:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_imba_flesh_heap_stacks:OnIntervalThink()
	if not IsServer() then return end
	local buff = self:GetCaster():FindModifierByName("modifier_imba_pudge_flesh_heap_handle")
	if not buff then return end
	self:SetStackCount(buff:GetStackCount())
end

function modifier_imba_flesh_heap_stacks:DeclareFunctions()
	local funcs = {
					MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_MODEL_SCALE,
					}
	return funcs
end

function modifier_imba_flesh_heap_stacks:GetModifierMagicalResistanceBonus()
	local base = self:GetAbility():GetSpecialValueFor("base_magic_resist")
	local stack_magic_resist = self:GetAbility():GetSpecialValueFor("stack_magic_resist")
	local stacks = self:GetStackCount()
	local max_stack = self:GetAbility():GetSpecialValueFor("max_stacks") + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_4")
	if stacks > max_stack then stacks = max_stack end
	return base + stack_magic_resist * stacks
end

function modifier_imba_flesh_heap_stacks:GetModifierBonusStats_Strength()
	local stacks = self:GetStackCount()
	local bonusStr = self:GetAbility():GetSpecialValueFor("stack_str")
	return stacks * bonusStr
end

function modifier_imba_flesh_heap_stacks:GetModifierModelScale()
	local stacks = self:GetStackCount()
	local max_stack = self:GetAbility():GetSpecialValueFor("max_stacks") + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_4")
	if stacks > max_stack then stacks = max_stack end
	return stacks * 3
end
--]]
--=================================================================================================================
-- Pudge's Dismember
--=================================================================================================================

imba_pudge_dismember = imba_pudge_dismember or class({})

LinkLuaModifier("modifier_dismember","hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_pudge_dismember_buff","hero/hero_pudge", LUA_MODIFIER_MOTION_NONE)

function imba_pudge_dismember:GetChannelTime()
	return self.channelTime
end

function imba_pudge_dismember:OnAbilityPhaseStart()
	if self:GetCursorTarget():IsHero() then
		self.channelTime = self:GetSpecialValueFor("hero_duration") + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_8")
	else
		self.channelTime = self:GetSpecialValueFor("creep_duration") + self:GetCaster():FindTalentValue("special_bonus_imba_pudge_8")
	end
	return true
end

function imba_pudge_dismember:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	target:AddNewModifier(caster, self, "modifier_dismember", {})
	caster:AddNewModifier(caster, self, "modifier_imba_pudge_dismember_buff", {duration = self.channelTime})
	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_dismember.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
end

function imba_pudge_dismember:OnChannelFinish()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local target_buff = target:FindModifierByNameAndCaster("modifier_dismember", caster)
	local caster_buff = caster:FindModifierByNameAndCaster("modifier_imba_pudge_dismember_buff", caster)
	if target_buff then target_buff:Destroy() end
	if caster_buff then caster_buff:Destroy() end
	ParticleManager:DestroyParticle(self.pfx, true)
	ParticleManager:ReleaseParticleIndex(self.pfx)
end

modifier_dismember = class({})

function modifier_dismember:IsDebuff() return true end
function modifier_dismember:IsHidden() return false end
function modifier_dismember:IsPurgable() return false end
function modifier_dismember:IsStunDebuff() return false end
function modifier_dismember:RemoveOnDeath() return true end

function modifier_dismember:OnCreated()
	self:StartIntervalThink(1.0)
	self:OnIntervalThink()
	if IsServer() then
		self:GetParent():StartGesture(ACT_DOTA_DISABLED)
	end
end

function modifier_dismember:OnIntervalThink()
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

function modifier_dismember:OnDestroy()
	if IsServer() then
		self:GetParent():FadeGesture(ACT_DOTA_DISABLED)
	end
end

function modifier_dismember:CheckState()
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

function FleshHeapUpgrade( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_resist = keys.modifier_resist
	local modifier_stacks = keys.modifier_stacks

	-- Parameters
	local stack_scale_up = ability:GetLevelSpecialValueFor("stack_scale_up", ability_level)
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)
	local stack_amount
	local resist_amount

	if caster:HasTalent("special_bonus_imba_pudge_4") then
		max_stacks = max_stacks + caster:FindTalentValue("special_bonus_imba_pudge_4", "max_stacks")
	end

	-- If Heap is already learned, fetch the current amount of stacks
	if caster.heap_stacks then
		stack_amount = caster.heap_stacks
		resist_amount = caster.heap_resist_stacks
	-- Else, fetch kills/assists up to this point of the game (lazy way to make Heap retroactive)
	else
		local assists = caster:GetAssists()
		local kills = caster:GetKills()	
		stack_amount = kills + assists
		resist_amount = math.min(stack_amount, max_stacks)

		-- Define the global variables which keep track of heap stacks
		caster.heap_stacks = stack_amount
		caster.heap_resist_stacks = resist_amount
	end

	-- Remove both modifiers in order to update their bonuses
	caster:RemoveModifierByName(modifier_stacks)
	while caster:HasModifier(modifier_resist) do
		caster:RemoveModifierByName(modifier_resist)
	end

	-- Add stacks of the capped (magic resist) modifier
	for i = 1, resist_amount do
		ability:ApplyDataDrivenModifier(caster, caster, modifier_resist, {})
	end

	-- Add stacks of the uncapped modifier
	AddStacks(ability, caster, caster, modifier_stacks, stack_amount, true)

	-- Update stats
	caster:CalculateStatBonus()

	-- Make pudge GROW
	caster:SetModelScale( math.min( 1 + stack_scale_up * stack_amount / 100, 2.0) )
end

function FleshHeap( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- If this isnt a real hero, do nothing.
	if ( not target:IsRealHero() ) or target:HasModifier("modifier_arc_warden_tempest_double") then
		return nil
	end

	-- Parameters
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	if caster:HasTalent("special_bonus_imba_pudge_4") then
		max_stacks = max_stacks + caster:FindTalentValue("special_bonus_imba_pudge_4", "max_stacks")
	end

	-- Prevent resist stacks from resetting if the skill is unlearned
	if ability_level == 0 then
		max_stacks = caster.heap_resist_stacks + 1
	end

	-- Update the global heap stacks variable
	caster.heap_stacks = caster.heap_stacks + 1
	caster.heap_resist_stacks = math.min(caster.heap_resist_stacks + 1, max_stacks)

	-- Play pudge's voice reaction
	caster:EmitSound("pudge_pud_ability_heap_0"..RandomInt(1,2))
end

function HeapUpdater( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_resist = keys.modifier_resist
	local modifier_stacks = keys.modifier_stacks

	-- Parameters
	local stack_scale_up = ability:GetLevelSpecialValueFor("stack_scale_up", ability_level)
	local stack_amount = caster:GetModifierStackCount(modifier_stacks, caster)
	local resist_amount = caster:FindAllModifiersByName(modifier_resist)
	print(modifier_stacks, stack_amount, caster.heap_stacks)

	-- If the amount of strength stacks has increased, update it
--	if caster.heap_stacks > stack_amount and caster:IsAlive() then
		local stacks_missing = caster.heap_stacks - stack_amount

		-- Add the appropriate amount of strength stacks
		caster:SetModifierStackCount(modifier_stacks, ability, caster.heap_stacks)

		-- Update stats
		caster:CalculateStatBonus()

		-- Make pudge GROW
		caster:SetModelScale( math.min( 1 + stack_scale_up * stack_amount / 100, 2.0) )
--	end

	-- If the amount of resist stacks has increased, update it
	if caster.heap_resist_stacks > #resist_amount and caster:IsAlive() then
		local stacks_missing = caster.heap_resist_stacks - #resist_amount

		-- Add the appropriate amount of resist stacks
		for i = 1, stacks_missing do
			ability:ApplyDataDrivenModifier(caster, caster, modifier_resist, {})
		end
	end
end
