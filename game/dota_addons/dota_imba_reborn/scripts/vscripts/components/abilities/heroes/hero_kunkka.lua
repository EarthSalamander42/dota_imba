-- Editors:
--     AtroCty
--     Hewdraw
--     Firetoad
--     Yahnich, 23.03.2017

-- #1 Talent - Giving gold on lasthits
--function modifier_special_bonus_imba_kunkka_1:DeclareFunctions()
--	local decFuncs =
--	{
--		MODIFIER_EVENT_ON_DEATH
--	}
--	return decFuncs
--end

--function modifier_special_bonus_imba_kunkka_1:OnDeath( params )
--	if (params.attacker:GetTeam() == self:GetCaster():GetTeam()) and (params.attacker == self:GetParent()) and (params.attacker ~= params.unit) and (params.attacker:HasTalent("special_bonus_imba_kunkka_1")) then
--		local custom_gold_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "bounty_multiplier")["1"])
--		local gold = params.attacker:FindTalentValue("special_bonus_imba_kunkka_1") * (custom_gold_bonus / 100)
--		SendOverheadEventMessage( self:GetCaster():GetOwner(),  OVERHEAD_ALERT_GOLD , self:GetParent(), gold, self:GetCaster() )
--		params.attacker:ModifyGold(gold, false, 0)
--	end
--end

-------------------------------------------
--			EBB & FLOW
-------------------------------------------

imba_kunkka_ebb_and_flow = class({})

LinkLuaModifier("modifier_imba_ebb_and_flow_thinker", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ebb_and_flow_tide_low", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ebb_and_flow_tide_red", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ebb_and_flow_tide_flood", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ebb_and_flow_tide_high", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ebb_and_flow_tide_wave", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ebb_and_flow_tsunami", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)

function imba_kunkka_ebb_and_flow:GetAbilityTextureName()
	return "custom/kunkka_ebb_and_flow"
end

function imba_kunkka_ebb_and_flow:GetIntrinsicModifierName()
	return "modifier_imba_ebb_and_flow_thinker"
end

function imba_kunkka_ebb_and_flow:IsNetherWardStealable() return false end
function imba_kunkka_ebb_and_flow:IsInnateAbility()
	return true
end

function imba_kunkka_ebb_and_flow:IsStealable()
	return false
end

-- Remove current Tide
function imba_kunkka_ebb_and_flow:RemoveTide()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_ebb_and_flow_tsunami")  	then caster:RemoveModifierByName("modifier_imba_ebb_and_flow_tsunami") end
	if caster:HasModifier("modifier_imba_ebb_and_flow_tide_low")	then caster:RemoveModifierByName("modifier_imba_ebb_and_flow_tide_low") end
	if caster:HasModifier("modifier_imba_ebb_and_flow_tide_red")	then caster:RemoveModifierByName("modifier_imba_ebb_and_flow_tide_red") end
	if caster:HasModifier("modifier_imba_ebb_and_flow_tide_flood")	then caster:RemoveModifierByName("modifier_imba_ebb_and_flow_tide_flood") end
	if caster:HasModifier("modifier_imba_ebb_and_flow_tide_high")	then caster:RemoveModifierByName("modifier_imba_ebb_and_flow_tide_high") end
	if caster:HasModifier("modifier_imba_ebb_and_flow_tide_wave")	then caster:RemoveModifierByName("modifier_imba_ebb_and_flow_tide_wave") end
end

function imba_kunkka_ebb_and_flow:GetCooldown( nLevel )
	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
	return cooldown
end

-- Re-roll buff
function imba_kunkka_ebb_and_flow:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_imba_ebb_and_flow_thinker")
		self:RemoveTide()
		modifier.tsunami_check = 0
	end
end

function imba_kunkka_ebb_and_flow:GetAbilityTextureName()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_ebb_and_flow_tsunami")    then return "custom/kunnka_tide_tsunami" end
	if caster:HasModifier("modifier_imba_ebb_and_flow_tide_low")   then return "custom/kunnka_tide_low"     end
	if caster:HasModifier("modifier_imba_ebb_and_flow_tide_red")   then return "custom/kunnka_tide_red"     end
	if caster:HasModifier("modifier_imba_ebb_and_flow_tide_flood") then return "custom/kunnka_tide_flood"   end
	if caster:HasModifier("modifier_imba_ebb_and_flow_tide_high")  then return "custom/kunnka_tide_high"    end
	if caster:HasModifier("modifier_imba_ebb_and_flow_tide_wave")  then return "custom/kunnka_tide_wave"    end
	return "custom/kunkka_ebb_and_flow"
end

modifier_imba_ebb_and_flow_thinker = class({})

-- State defining
function modifier_imba_ebb_and_flow_thinker:RemoveOnDeath()
	return false
end

function modifier_imba_ebb_and_flow_thinker:IsPermanent()
	return true
end

function modifier_imba_ebb_and_flow_thinker:IsPurgable()
	return false
end

function modifier_imba_ebb_and_flow_thinker:IsHidden()
	return true
end

-- Cooldown checker
function modifier_imba_ebb_and_flow_thinker:OnCreated()
	if IsServer() then
		self.tide_counter = 1
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_ebb_and_flow_thinker:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		-- Tsunami-Tide Chance
		-- 0 = not rolled yet, 1 = Tsunami, 2 = regular tide
		self.tsunami_check = self.tsunami_check or 0
		if self.tsunami_check == 0 then
			local tsunami_chance = ability:GetTalentSpecialValueFor("tsunami_chance")
			if tsunami_chance >= RandomInt(1, 100) then
				self.tsunami_check = 1
			else
				self.tsunami_check = 2
				self:NextTide()
			end
		end

		local current_tide_modifier
		if self.tsunami_check == 1 then
			current_tide_modifier = "modifier_imba_ebb_and_flow_tsunami"
		else
			current_tide_modifier = self:GetCurrentTide(self.tide_counter)
		end

		-- Check if caster should have the next tide
		if ability:IsCooldownReady() and not caster:HasModifier(current_tide_modifier) then
			caster:AddNewModifier(caster, ability, current_tide_modifier, {})
		end
	end
end

modifier_imba_ebb_and_flow_tide_low = class({})

function modifier_imba_ebb_and_flow_tide_low:IsHidden()
	return false
end
function modifier_imba_ebb_and_flow_tide_low:IsDebuff()
	return false
end

function modifier_imba_ebb_and_flow_tide_low:GetTexture()
	return "custom/kunnka_tide_low"
end

modifier_imba_ebb_and_flow_tide_red = class({})

function modifier_imba_ebb_and_flow_tide_red:IsHidden()
	return false
end
function modifier_imba_ebb_and_flow_tide_red:IsDebuff()
	return false
end

function modifier_imba_ebb_and_flow_tide_red:GetTexture()
	return "custom/kunnka_tide_red"
end

modifier_imba_ebb_and_flow_tide_flood = class({})

function modifier_imba_ebb_and_flow_tide_flood:IsHidden()
	return false
end
function modifier_imba_ebb_and_flow_tide_flood:IsDebuff()
	return false
end

function modifier_imba_ebb_and_flow_tide_flood:GetTexture()
	return "custom/kunnka_tide_flood"
end

modifier_imba_ebb_and_flow_tide_high = class({})

function modifier_imba_ebb_and_flow_tide_high:IsHidden()
	return false
end
function modifier_imba_ebb_and_flow_tide_high:IsDebuff()
	return false
end

function modifier_imba_ebb_and_flow_tide_high:GetTexture()
	return "custom/kunnka_tide_high"
end

modifier_imba_ebb_and_flow_tide_wave = class({})

function modifier_imba_ebb_and_flow_tide_wave:IsHidden()
	return false
end
function modifier_imba_ebb_and_flow_tide_wave:IsDebuff()
	return false
end

function modifier_imba_ebb_and_flow_tide_wave:GetTexture()
	return "custom/kunnka_tide_wave"
end

modifier_imba_ebb_and_flow_tsunami = class({})

function modifier_imba_ebb_and_flow_tsunami:IsHidden()
	return false
end
function modifier_imba_ebb_and_flow_tsunami:IsDebuff()
	return false
end

function modifier_imba_ebb_and_flow_tsunami:GetTexture()
	return "custom/kunnka_tide_tsunami"
end

-- Flexible list of all possible tides (excluding tsunami)
function modifier_imba_ebb_and_flow_thinker:GetCurrentTide( index )
	local tide_list

	-- #1 Talent: Add Tsunami to Ebb & Flow cycle
	if self:GetCaster():HasTalent("special_bonus_imba_kunkka_1") then
		tide_list = {
			"modifier_imba_ebb_and_flow_tide_low",
			"modifier_imba_ebb_and_flow_tide_red",
			"modifier_imba_ebb_and_flow_tide_flood",
			"modifier_imba_ebb_and_flow_tide_high",
			"modifier_imba_ebb_and_flow_tide_wave",
			"modifier_imba_ebb_and_flow_tsunami"
		}
	else
		tide_list = {
			"modifier_imba_ebb_and_flow_tide_low",
			"modifier_imba_ebb_and_flow_tide_red",
			"modifier_imba_ebb_and_flow_tide_flood",
			"modifier_imba_ebb_and_flow_tide_high",
			"modifier_imba_ebb_and_flow_tide_wave"
		}
	end
	tide_list['tide_count'] = #tide_list
	return tide_list[index]
end

-- Sets the current Tide-counter
function modifier_imba_ebb_and_flow_thinker:NextTide()
	if ( self.tide_counter >= self:GetCurrentTide('tide_count') ) then
		self.tide_counter = 1
	else
		self.tide_counter = self.tide_counter + 1
	end
end

-------------------------------------------
--			  TORRENT
-------------------------------------------

imba_kunkka_torrent = class({})
LinkLuaModifier("modifier_imba_torrent_cast", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_torrent_slow_tide", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_torrent_slow", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sec_torrent_slow", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_torrent_phase", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_kunkka_torrent_talent_thinker", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)

function imba_kunkka_torrent:GetAbilityTextureName()
	return "kunkka_torrent"
end

function imba_kunkka_torrent:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorPosition()

		-- Parameters
		local vision_duration = 4
		local first_delay = self:GetSpecialValueFor("launch_delay")

		local radius = self:GetTalentSpecialValueFor("radius")
		local slow_duration = self:GetSpecialValueFor("slow_duration")
		local stun_duration = self:GetSpecialValueFor("stun_duration")
		local damage = self:GetSpecialValueFor("damage")
		local sec_torrent_count = self:GetSpecialValueFor("sec_torrent_count")
		local sec_torrent_stun = self:GetSpecialValueFor("sec_torrent_stun")
		local sec_torrent_damage = self:GetTalentSpecialValueFor("sec_torrent_damage")
		local sec_torrent_slow_duration = self:GetSpecialValueFor("sec_torrent_slow_duration")
		local tick_count = self:GetSpecialValueFor("tick_count")
		local torrent_height = self:GetSpecialValueFor("torrent_height")

		-- Check buffs by Ebb and Flow, and set on Cooldown after cast to give a new buff
		local tsunami = caster:HasModifier("modifier_imba_ebb_and_flow_tsunami")
		if caster:HasModifier("modifier_imba_ebb_and_flow_tide_flood") or tsunami then
			damage = damage + self:GetSpecialValueFor("tide_flood_damage")
		end
		if caster:HasModifier("modifier_imba_ebb_and_flow_tide_high") or tsunami then
			radius = radius + self:GetSpecialValueFor("tide_high_radius")
		end
		if caster:HasModifier("modifier_imba_ebb_and_flow_tide_wave") or tsunami then
			first_delay = first_delay / 2
		end
		local extra_slow = false
		if caster:HasModifier("modifier_imba_ebb_and_flow_tide_red") or tsunami then
			extra_slow = true
		end
		-- In case the ability is stolen don't cast the next tide
		if caster:HasAbility("imba_kunkka_ebb_and_flow") then
			local ability_tide = caster:FindAbilityByName("imba_kunkka_ebb_and_flow")
			ability_tide:CastAbility()
		end

		-- Calculates the damage to deal per tick
		local tick_interval = stun_duration / tick_count
		local damage_tick = damage / tick_count
		vision_duration = vision_duration + (sec_torrent_count * 2)

		-- Set slow duration (After stun)
		slow_duration = slow_duration + stun_duration
		sec_torrent_slow_duration = sec_torrent_slow_duration + sec_torrent_stun

		self:CreateVisibilityNode(target, radius, vision_duration)

		local bubbles_pfx = ParticleManager:CreateParticleForTeam("particles/hero/kunkka/torrent_bubbles.vpcf", PATTACH_ABSORIGIN, caster, caster:GetTeam())
		ParticleManager:SetParticleControl(bubbles_pfx, 0, target)
		ParticleManager:SetParticleControl(bubbles_pfx, 1, Vector(radius,0,0))
		local bubbles_sec_pfc

		EmitSoundOnLocationForAllies(target, "Ability.pre.Torrent", caster)

		-- #4 Talent: Secondary Torrents appear at random intervals inside the radius of Main Torrent
		if caster:HasTalent("special_bonus_imba_kunkka_4") then
			local thinker = CreateModifierThinker(caster, self, "modifier_imba_kunkka_torrent_talent_thinker",
				{duration = (first_delay + sec_torrent_count),
					pos_x = target.x,
					pos_y = target.y,
					pos_z = target.z,
					affected_radius = radius,
					sec_torrent_radius = self:GetSpecialValueFor("sec_torrent_radius"),
					sec_torrent_stun = sec_torrent_stun,
					sec_torrent_count = sec_torrent_count,
					sec_torrent_damage = sec_torrent_damage,
					sec_torrent_slow_duration = sec_torrent_slow_duration,
					tick_count = tick_count,
					torrent_height = torrent_height}, target, caster:GetTeamNumber(), false)
		end

		-- Cast for each count
		for torrent_count = 0, sec_torrent_count, 1
		do
			local delay = first_delay + (torrent_count * 2)
			-- Start after the delay
			Timers:CreateTimer(delay, function()
					-- Parameters for secoundary Torrents
					if torrent_count > 0 then
						damage_tick = sec_torrent_damage / tick_count
						stun_duration = sec_torrent_stun
						torrent_height = torrent_height / 1.5
						radius = self:GetSpecialValueFor("sec_torrent_radius")
					end

					-- Destroy initial bubble-particle & create secoundary visible for both teams
					if torrent_count == 0 then
						ParticleManager:DestroyParticle(bubbles_pfx, false)
						ParticleManager:ReleaseParticleIndex(bubbles_pfx)
						bubbles_sec_pfc = ParticleManager:CreateParticleForTeam("particles/hero/kunkka/torrent_bubbles.vpcf", PATTACH_ABSORIGIN, caster, caster:GetTeam())
						ParticleManager:SetParticleControl(bubbles_sec_pfc, 0, target)
						ParticleManager:SetParticleControl(bubbles_sec_pfc, 1, Vector(radius,0,0))
					end

					-- Destroy bubbles if it was the last torrent
					if torrent_count == sec_torrent_count then
						ParticleManager:DestroyParticle(bubbles_sec_pfc, false)
						ParticleManager:ReleaseParticleIndex(bubbles_sec_pfc)
					end

					-- Finds affected enemies
					local enemies = FindUnitsInRadius(caster:GetTeam(), target, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)

					-- Torrent response if an enemy was hit 30%
					if (#enemies > 0) and (caster:GetName() == "npc_dota_hero_kunkka") then
						if math.random(1,10) < 3 then
							caster:EmitSound("kunkka_kunk_ability_torrent_0"..math.random(1,4))
						end
					end
					-- Iterate through affected enemies
					for _,enemy in pairs(enemies) do

						-- Deals the initial damage
						ApplyDamage({victim = enemy, attacker = caster, ability = self, damage = damage_tick, damage_type = self:GetAbilityDamageType()})
						local current_ticks = 0
						local randomness_x = 0
						local randomness_y = 0

						-- Calculates the knockback position (for Tsunami)
						local torrent_border = ( enemy:GetAbsOrigin() - target ):Normalized() * ( radius + 100 )
						local distance_from_center = ( enemy:GetAbsOrigin() - target ):Length2D()
						if not ( tsunami and torrent_count == 0 ) then
							distance_from_center = 0
						else
							-- Some randomness to tsunami-torrent for smoother animation
							randomness_x = math.random() * math.random(-30,30)
							randomness_y = math.random() * math.random(-30,30)
						end

						-- Knocks the target up
						local knockback =
						{
							should_stun = 1,
							knockback_duration = stun_duration,
							duration = stun_duration,
							knockback_distance = distance_from_center,
							knockback_height = torrent_height,
							center_x = (target + torrent_border).x + randomness_x,
							center_y = (target + torrent_border).y + randomness_y,
							center_z = (target + torrent_border).z
						}

						-- Apply knockback on enemies hit
						enemy:RemoveModifierByName("modifier_knockback")
						enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
						enemy:AddNewModifier(caster, self, "modifier_imba_torrent_phase", {duration = stun_duration})

						-- Deals tick damage tick_count times
						Timers:CreateTimer(function()
								if current_ticks < tick_count then
									ApplyDamage({victim = enemy, attacker = caster, ability = self, damage = damage_tick, damage_type = self:GetAbilityDamageType()})
									current_ticks = current_ticks + 1
									return tick_interval
								end
							end)

						-- Applies the slow
						if torrent_count == 0 then
							enemy:AddNewModifier(caster, self, "modifier_imba_torrent_slow", {duration = slow_duration})
							if extra_slow then
								enemy:AddNewModifier(caster, self, "modifier_imba_torrent_slow_tide", {duration = slow_duration})
							end
						else
							enemy:AddNewModifier(caster, self, "modifier_imba_sec_torrent_slow", {duration = sec_torrent_slow_duration})
						end
					end

					-- Creates the post-ability sound effect
					EmitSoundOnLocationWithCaster(target, "Ability.Torrent", caster)

					-- Draws the particle
					local particle = "particles/hero/kunkka/torrent_splash.vpcf"
					local torrent_fx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(torrent_fx, 0, target)
					ParticleManager:SetParticleControl(torrent_fx, 1, Vector(radius,0,0))
					ParticleManager:ReleaseParticleIndex(torrent_fx)

					-- SUPER DUPER HYPER torrent animation if tsunami
					if torrent_count == 0 and tsunami then
						local torrent_tsunami_fx = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_whaleblade/kunkka_spell_torrent_whaleblade_tail.vpcf", PATTACH_CUSTOMORIGIN, caster)
						ParticleManager:SetParticleControl(torrent_tsunami_fx, 0, target)
						ParticleManager:ReleaseParticleIndex(torrent_tsunami_fx)

						local count_mini = math.floor(radius / 35)
						for i = 0, count_mini, 1
						do
							Timers:CreateTimer(math.random(80)*0.01, function()
									local radius_mini = math.random(50)+15
									local angle = (360 / count_mini) * i
									local border = radius - radius_mini
									local mini_target = target + Vector( math.cos(angle) * border , math.sin(angle) * border , 0 )
									local torrent_fx_mini = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
									ParticleManager:SetParticleControl(torrent_fx_mini, 0, mini_target)
									ParticleManager:SetParticleControl(torrent_fx_mini, 1, Vector(radius_mini,0,0))
									ParticleManager:ReleaseParticleIndex(torrent_fx_mini)
								end)
						end
					end
				end)
		end
	end
end

function imba_kunkka_torrent:IsHiddenWhenStolen()
	return false
end

function imba_kunkka_torrent:GetAOERadius()
	local caster = self:GetCaster()
	local radius = self:GetTalentSpecialValueFor("radius")
	if caster:HasModifier("modifier_imba_ebb_and_flow_tide_high") or caster:HasModifier("modifier_imba_ebb_and_flow_tsunami") then
		radius = radius + self:GetSpecialValueFor("tide_high_radius")
	end
	return radius
end

function imba_kunkka_torrent:GetCastRange( location , target)
	local caster = self:GetCaster()
	local range = self.BaseClass.GetCastRange(self,location,target)
	if caster:HasModifier("modifier_imba_ebb_and_flow_tide_low") or caster:HasModifier("modifier_imba_ebb_and_flow_tsunami") then
		range = range + self:GetSpecialValueFor("tide_low_range")
	end
	return range
end

modifier_imba_torrent_phase = class({})

function modifier_imba_torrent_phase:CheckState()
	local state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	return state
end

function modifier_imba_torrent_phase:IsHidden()
	return true
end

function modifier_imba_torrent_phase:IsDebuff()
	return true
end

modifier_imba_torrent_slow_tide = class({})

function modifier_imba_torrent_slow_tide:IsHidden()
	return true
end

function modifier_imba_torrent_slow_tide:IsDebuff()
	return true
end

function modifier_imba_torrent_slow_tide:IsPurgable()
	return true
end

modifier_imba_torrent_slow = class({})

function modifier_imba_torrent_slow:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return decFuncs
end

function modifier_imba_torrent_slow:GetModifierMoveSpeedBonus_Percentage( )
	local ability = self:GetAbility()
	local slow = ability:GetSpecialValueFor("main_slow")
	if self:GetParent():HasModifier("modifier_imba_torrent_slow_tide")then
		slow = slow + ability:GetSpecialValueFor("tide_red_slow")
	end
	return slow * (-1)
end

function modifier_imba_torrent_slow:IsHidden()
	return false
end

function modifier_imba_torrent_slow:IsDebuff()
	return true
end

function modifier_imba_torrent_slow:IsPurgable()
	return true
end

modifier_imba_sec_torrent_slow = class({})

function modifier_imba_sec_torrent_slow:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return decFuncs
end

function modifier_imba_sec_torrent_slow:GetModifierMoveSpeedBonus_Percentage( )
	return ( self:GetAbility():GetSpecialValueFor("sec_torrent_slow") * (-1) )
end

function modifier_imba_sec_torrent_slow:IsHidden()
	return false
end

function modifier_imba_sec_torrent_slow:IsDebuff()
	return true
end

function modifier_imba_sec_torrent_slow:IsPurgable()
	return true
end

-- Modifier for casting torrent without showing cast direction
-- Modifier is added in the OrderFilter in imba.lua !
modifier_imba_torrent_cast = class({})

function modifier_imba_torrent_cast:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		MODIFIER_PROPERTY_DISABLE_TURNING
	}
	return decFuncs
end

function modifier_imba_torrent_cast:GetModifierIgnoreCastAngle( params )
	return 1
end

function modifier_imba_torrent_cast:GetModifierDisableTurning( params )
	return 1
end

function modifier_imba_torrent_cast:IsHidden()
	return false
end

-- Do a stop order after finish casting to prevent turning to the destination point
function modifier_imba_torrent_cast:OnDestroy( params )
	if IsServer() then
		local stopOrder =
		{
			UnitIndex = self:GetCaster():entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP
		}
		ExecuteOrderFromTable( stopOrder )
	end
end

modifier_imba_kunkka_torrent_talent_thinker = class({})

function modifier_imba_kunkka_torrent_talent_thinker:IsHidden()
	return false
end

function modifier_imba_kunkka_torrent_talent_thinker:IsPurgable()
	return false
end

function modifier_imba_kunkka_torrent_talent_thinker:OnCreated(keys)
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.min_interval = self.caster:FindTalentValue("special_bonus_imba_kunkka_4","min_interval") * 10
		self.max_interval = self.caster:FindTalentValue("special_bonus_imba_kunkka_4") * 10

		self.tick = (math.random() + math.random(self.min_interval, self.max_interval)) / 10

		-- Parameters
		-- fuck you vectors
		self.pos = Vector(keys.pos_x,keys.pos_y,keys.pos_z)
		self.affected_radius = keys.affected_radius
		self.sec_torrent_radius = keys.sec_torrent_radius
		self.sec_torrent_stun = keys.sec_torrent_stun
		self.sec_torrent_count = keys.sec_torrent_count
		self.sec_torrent_damage = keys.sec_torrent_damage
		self.sec_torrent_slow_duration = keys.sec_torrent_slow_duration
		self.tick_count = keys.tick_count
		self.torrent_height = keys.torrent_height

		-- Ability specials
		self:StartIntervalThink(self.tick)
	end
end

function modifier_imba_kunkka_torrent_talent_thinker:OnIntervalThink()
	if IsServer() then
		local interval = (math.random() + math.random(self.min_interval, ((self:GetRemainingTime()+self.tick) * 10))) / 10
		-- Re-roll the interval
		self.tick = (math.random() + math.random(self.min_interval, self.max_interval)) / 10
		Timers:CreateTimer(interval, function()

				-- Parameters for secoundary Torrents
				local random_radius = math.random(0, self.affected_radius)
				local random_vector = self.pos + RandomVector(random_radius)
				damage_tick = self.sec_torrent_damage / self.tick_count
				stun_duration = self.sec_torrent_stun
				torrent_height = self.torrent_height / 1.5
				radius = self.sec_torrent_radius
				tick_interval = stun_duration / self.tick_count

				-- Finds affected enemies
				local enemies = FindUnitsInRadius(self.caster:GetTeam(), random_vector, nil, radius, self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(), self.ability:GetAbilityTargetFlags(), 0, false)

				-- Torrent response if an enemy was hit 30%
				if (#enemies > 0) and (self.caster:GetName() == "npc_dota_hero_kunkka") then
					if math.random(1,10) < 3 then
						self.caster:EmitSound("kunkka_kunk_ability_torrent_0"..math.random(1,4))
					end
				end
				-- Iterate through affected enemies
				for _,enemy in pairs(enemies) do

					-- Deals the initial damage
					ApplyDamage({victim = enemy, attacker = self.caster, ability = self.ability, damage = damage_tick, damage_type = self.ability:GetAbilityDamageType()})
					local current_ticks = 0
					local randomness_x = 0
					local randomness_y = 0

					-- Calculates the knockback position (for Tsunami)
					local torrent_border = ( enemy:GetAbsOrigin() - random_vector ):Normalized() * ( radius + 100 )
					local distance_from_center = ( enemy:GetAbsOrigin() - random_vector ):Length2D()
					if not ( tsunami and torrent_count == 0 ) then
						distance_from_center = 0
					else
						-- Some randomness to tsunami-torrent for smoother animation
						randomness_x = math.random() * math.random(-30,30)
						randomness_y = math.random() * math.random(-30,30)
					end

					-- Knocks the target up
					local knockback =
					{
						should_stun = 1,
						knockback_duration = stun_duration,
						duration = stun_duration,
						knockback_distance = distance_from_center,
						knockback_height = torrent_height,
						center_x = (random_vector + torrent_border).x + randomness_x,
						center_y = (random_vector + torrent_border).y + randomness_y,
						center_z = (random_vector + torrent_border).z
					}

					-- Apply knockback on enemies hit
					enemy:RemoveModifierByName("modifier_knockback")
					enemy:AddNewModifier(self.caster, self.ability, "modifier_knockback", knockback)
					enemy:AddNewModifier(self.caster, self.ability, "modifier_imba_torrent_phase", {duration = stun_duration})

					-- Deals tick damage tick_count times
					Timers:CreateTimer(function()
							-- TODO: tick count can be nil for some reason
							if tick_count ~= nil and current_ticks < tick_count then
								ApplyDamage({victim = enemy, attacker = self.caster, ability = self.ability, damage = damage_tick, damage_type = self.ability:GetAbilityDamageType()})
								current_ticks = current_ticks + 1
								return tick_interval
							end
						end)


					enemy:AddNewModifier(self.caster, self.ability, "modifier_imba_sec_torrent_slow", {duration = self.sec_torrent_slow_duration})
				end

				-- Creates the post-ability sound effect
				EmitSoundOnLocationWithCaster(random_vector, "Ability.Torrent", caster)

				-- Draws the particle
				local particle = "particles/hero/kunkka/torrent_splash.vpcf"
				local torrent_fx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, self.caster)
				ParticleManager:SetParticleControl(torrent_fx, 0, random_vector)
				ParticleManager:SetParticleControl(torrent_fx, 1, Vector(radius,0,0))
				ParticleManager:ReleaseParticleIndex(torrent_fx)

			end)
	end
end

-------------------------------------------
--			  TIDEBRINGER
-------------------------------------------

imba_kunkka_tidebringer = class({})
LinkLuaModifier("modifier_imba_tidebringer", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidebringer_sword_particle", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidebringer_manual", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidebringer_slow", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidebringer_cleave_hit_target", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)

function imba_kunkka_tidebringer:GetAbilityTextureName()
	return "kunkka_tidebringer"
end

function imba_kunkka_tidebringer:GetIntrinsicModifierName()
	return "modifier_imba_tidebringer"
end

function imba_kunkka_tidebringer:GetCastRange(location, target)
	return self:GetCaster():Script_GetAttackRange()
end

function imba_kunkka_tidebringer:IsStealable()
	return false
end

function imba_kunkka_tidebringer:OnSpellStart()
	if IsServer() then
		-- Force attack the target
		local caster = self:GetCaster()
		caster:MoveToTargetToAttack(self:GetCursorTarget())
		caster:AddNewModifier(caster, self, "modifier_imba_tidebringer_manual", {})
		-- If manually casted, reset CD, CD getting applied on hit
		self:EndCooldown()
	end
end

function imba_kunkka_tidebringer:OnUpgrade()
	if IsServer() then
		self:GetCaster():RemoveModifierByName("modifier_imba_tidebringer")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_tidebringer", {})

		-- Toggles the autocast when first leveled
		local caster_tidebringer = self:GetCaster():FindAbilityByName("imba_kunkka_tidebringer")
		if caster_tidebringer and caster_tidebringer:GetLevel() == 1 then
			caster_tidebringer:ToggleAutoCast()
		end
	end
end

function imba_kunkka_tidebringer:GetCooldown( nLevel )
	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_imba_ebb_and_flow_tide_wave") or caster:HasModifier("modifier_imba_ebb_and_flow_tsunami") or (caster:HasTalent("special_bonus_imba_kunkka_2") and caster:HasModifier("modifier_imba_ghostship_rum")) then
		cooldown = 0
	end
	return cooldown
end

modifier_imba_tidebringer_sword_particle = class({})

function modifier_imba_tidebringer_sword_particle:IsHidden()
	return true
end

function modifier_imba_tidebringer_sword_particle:RemoveOnDeath()
	return false
end

function modifier_imba_tidebringer_sword_particle:IsPurgable()
	return false
end

function modifier_imba_tidebringer_sword_particle:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local cooldown = ability:GetCooldown(ability:GetLevel()-1)

		caster:EmitSound("Hero_Kunkka.Tidebringer.Attack")
		ParticleManager:DestroyParticle(caster.tidebringer_weapon_pfx, true)
		ParticleManager:ReleaseParticleIndex(caster.tidebringer_weapon_pfx)
		caster.tidebringer_weapon_pfx = 0
	end
end

function modifier_imba_tidebringer_sword_particle:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		caster.tidebringer_weapon_pfx = caster.tidebringer_weapon_pfx or 0
		if caster.tidebringer_weapon_pfx == 0 then
			EmitSoundOn("Hero_Kunkaa.Tidebringer", caster)
			caster.tidebringer_weapon_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_weapon_tidebringer.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(caster.tidebringer_weapon_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_tidebringer", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(caster.tidebringer_weapon_pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_sword", caster:GetAbsOrigin(), true)
		end
	end
end

modifier_imba_tidebringer_manual = class({})

function modifier_imba_tidebringer_manual:IsHidden()
	return false
end

modifier_imba_tidebringer = class({})

function modifier_imba_tidebringer:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}

	return decFuncs
end

function modifier_imba_tidebringer:OnCreated()
	self.range = self:GetAbility():GetSpecialValueFor("range")
	self.radius_start = self:GetAbility():GetSpecialValueFor("radius_start")
	self.radius_end = self:GetAbility():GetSpecialValueFor("radius_end")
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if IsServer() then
		if (not caster:HasModifier("modifier_imba_tidebringer_sword_particle")) and ability:IsCooldownReady() then
			caster:AddNewModifier(caster, ability, "modifier_imba_tidebringer_sword_particle", {})
		end
	end
end

function modifier_imba_tidebringer:OnRefresh()
	self.range = self:GetAbility():GetSpecialValueFor("range")
	self.radius_start = self:GetAbility():GetSpecialValueFor("radius_start")
	self.radius_end = self:GetAbility():GetSpecialValueFor("radius_end")
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if IsServer() then
		if ( not caster:HasModifier("modifier_imba_tidebringer_sword_particle")) and ability:IsCooldownReady() then
			caster:AddNewModifier(caster, ability, "modifier_imba_tidebringer_sword_particle", {})
		end
	end
end

function modifier_imba_tidebringer:OnAttackStart( params )
	if IsServer() then
		local parent = self:GetParent()
		local target = params.target
		if (parent == params.attacker) and (target:GetTeamNumber() ~= parent:GetTeamNumber()) and (target.IsCreep or target.IsHero) then
			if not target:IsBuilding() then
				local ability = self:GetAbility()
				self.sound_triggered = false
				-- Check buffs by Ebb and Flow, and set on Cooldown after cast to give a new buff
				self.tide_index = 0
				if parent:HasModifier("modifier_imba_ebb_and_flow_tsunami") 	then self.tide_index = 1 end
				if parent:HasModifier("modifier_imba_ebb_and_flow_tide_low") 	then self.tide_index = 2 end
				if parent:HasModifier("modifier_imba_ebb_and_flow_tide_red") 	then self.tide_index = 3 end
				if parent:HasModifier("modifier_imba_ebb_and_flow_tide_flood")	then self.tide_index = 4 end
				if parent:HasModifier("modifier_imba_ebb_and_flow_tide_high") 	then self.tide_index = 5 end
				if parent:HasModifier("modifier_imba_ebb_and_flow_tide_wave") 	then self.tide_index = 6 end

				if ability:IsCooldownReady() and not (parent:PassivesDisabled()) then
					if ability:GetAutoCastState() or parent:HasModifier("modifier_imba_tidebringer_manual") then
						self.pass_attack = true
						self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
						if (self.tide_index == 4) or (self.tide_index == 1) then
							self.bonus_damage = self.bonus_damage + ability:GetSpecialValueFor("tide_flood_damage")
						end
					else
						self.pass_attack = false
						self.bonus_damage = 0
					end
				end
			end
		end
	end
end

function modifier_imba_tidebringer:OnAttackLanded( params )
	local ability = self:GetAbility()
	if IsServer() then
		local parent = self:GetParent()
		local tidebringer_bonus_damage = self.bonus_damage
		if params.attacker == parent and ( not parent:IsIllusion() ) and self.pass_attack then
			self.pass_attack = false
			self.bonus_damage = 0

			-- If you get break during attack-swing
			if parent:PassivesDisabled() then
				return 0
			end

			local range = self.range
			local radius_start = self.radius_start
			local radius_end = self.radius_end

			parent:RemoveModifierByName("modifier_imba_tidebringer_sword_particle")

			if (self.tide_index == 2) or (self.tide_index == 1) then
				range = range + ability:GetSpecialValueFor("tide_low_range")
			end

			if (self.tide_index == 5) or (self.tide_index == 1) then
				radius_start = radius_start + ability:GetSpecialValueFor("tide_high_radius")
				radius_end = radius_end + ability:GetSpecialValueFor("tide_high_radius")
			end

			-- Torrent animation if Tsunami
			if self.tide_index == 1 then
				self.torrent_radius = radius_end * ( math.sqrt( math.pow((radius_end - radius_start), 2) + math.pow(range, 2)) + radius_start - radius_end) / range
				self.position_center = parent:GetAbsOrigin() + parent:GetForwardVector() * self.torrent_radius

				local torrent_fx_mini = ParticleManager:CreateParticle("particles/hero/kunkka/torrent_splash.vpcf", PATTACH_CUSTOMORIGIN, parent)
				ParticleManager:SetParticleControl(torrent_fx_mini, 0, self.position_center)
				ParticleManager:SetParticleControl(torrent_fx_mini, 1, Vector(self.torrent_radius,0,0))
			end

			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then

				self:TidebringerEffects( target, ability )
                
                -- Calculate bonus damage to be used for cleave
                local cleaveDamage = params.damage * (ability:GetSpecialValueFor("cleave_damage") / 100)
                
				local enemies_to_cleave = FindUnitsInCone(self:GetParent():GetTeamNumber(),CalculateDirection(params.target, self:GetParent()),self:GetParent():GetAbsOrigin(), radius_start, radius_end, range, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)

				-- #7 Talent: Tidebringer will always hit enemies with Torrent debuff
				if parent:HasTalent("special_bonus_imba_kunkka_7") then
					local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
					local hit_enemy = false

					for _,enemy in pairs (enemies) do
						if enemy:HasModifier("modifier_imba_torrent_slow") or enemy:HasModifier("modifier_imba_torrent_slow_tide") or enemy:HasModifier("modifier_imba_sec_torrent_slow") or enemy:HasModifier("modifier_imba_torrent_phase") then
							hit_enemy = true
							-- Prevent the enemy from being hit again if it's already hit once by Tidebringer.
							for _,enemy_hit in pairs (enemies_to_cleave) do
								if enemy == enemy_hit then
									hit_enemy = false
								end
							end
							if hit_enemy then
								-- Play hit particle
								local tidebringer_hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
								ParticleManager:SetParticleControlEnt(tidebringer_hit_fx, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
								ParticleManager:SetParticleControlEnt(tidebringer_hit_fx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
								ParticleManager:SetParticleControlEnt(tidebringer_hit_fx, 2, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)

								-- Deal the cleave damage
								ApplyDamage({attacker = self:GetParent(), victim = enemy, ability = ability, damage = cleaveDamage, damage_type = DAMAGE_TYPE_PHYSICAL})
							end
						end
					end
				end

				-- #7 Talent: If the enemy is the target itself, Tidebringer also hits him, dealing what damage that should be done, true Cleave damage
				if parent:HasTalent("special_bonus_imba_kunkka_7") then
					if params.target:HasModifier("modifier_imba_torrent_slow") or params.target:HasModifier("modifier_imba_torrent_slow_tide") or params.target:HasModifier("modifier_imba_sec_torrent_slow") or params.target:HasModifier("modifier_imba_torrent_phase") then
						for _,enemy_to_hit in pairs (enemies_to_cleave) do
							-- Play hit particle
							local tidebringer_hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
							ParticleManager:SetParticleControlEnt(tidebringer_hit_fx, 0, enemy_to_hit, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy_to_hit:GetAbsOrigin(), true)
							ParticleManager:SetParticleControlEnt(tidebringer_hit_fx, 1, enemy_to_hit, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy_to_hit:GetAbsOrigin(), true)
							ParticleManager:SetParticleControlEnt(tidebringer_hit_fx, 2, enemy_to_hit, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy_to_hit:GetAbsOrigin(), true)

							target_cleaved = enemy_to_hit:AddNewModifier(self:GetParent(),ability,"modifier_imba_tidebringer_cleave_hit_target",{duration = 0.01})
							if target_cleaved then
								target_cleaved.cleave_damage = cleaveDamage
							end
						end
					else
						DoCleaveAttack( params.attacker, params.target, ability, cleaveDamage, radius_start, radius_end, range, "particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf" )
					end
				else
					DoCleaveAttack( params.attacker, params.target, ability, cleaveDamage, radius_start, radius_end, range, "particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf" )
				end

				if not ((self.tide_index == 6) or (self.tide_index == 1)) then
					local cooldown = ability:GetCooldown(ability:GetLevel()-1)
					ability:UseResources(false, false, true)
					Timers:CreateTimer( cooldown, function()
							if not parent:HasModifier("modifier_imba_tidebringer_sword_particle") then
								parent:AddNewModifier(parent, ability, "modifier_imba_tidebringer_sword_particle", {})
							end
							--return nil
						end)
				end
				if parent:HasModifier("modifier_imba_tidebringer_manual") then
					parent:RemoveModifierByName("modifier_imba_tidebringer_manual")
				end
				if parent:HasAbility("imba_kunkka_ebb_and_flow") then
					local ability_tide = parent:FindAbilityByName("imba_kunkka_ebb_and_flow")
					if self.tide_index >= 1 then
						ability_tide:CastAbility()
					end
					cooldown = ability_tide:GetCooldownTimeRemaining() - (self.hitCounter * ability:GetSpecialValueFor("cdr_per_hit"))
					ability_tide:EndCooldown()
					ability_tide:StartCooldown(cooldown)
					self.hitCounter = nil
				end
			end
		end
	end
	return 0
end

function modifier_imba_tidebringer:GetModifierPreAttack_BonusDamage(params)
	self.bonus_damage = self.bonus_damage or 0
	return self.bonus_damage
end

function modifier_imba_tidebringer:OnTakeDamage( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( bit.band( params.damage_flags , DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR) == DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR) and params.inflictor:GetAbilityName() == "imba_kunkka_tidebringer" then
			self:TidebringerEffects( params.unit, params.inflictor )
		end
	end
end

function modifier_imba_tidebringer:TidebringerEffects( target, ability )
	local sound_height = 1000
	self.hitCounter = self.hitCounter or 0
	self.hitCounter = self.hitCounter + 1
	local attacker = self:GetCaster()
	if ( self.tide_index == 1 or self.tide_index == 3 ) and not target:IsMagicImmune() then
		target:AddNewModifier(attacker, ability, "modifier_imba_tidebringer_slow", {duration = ability:GetSpecialValueFor("tide_red_slow_duration")})
	end

	if self.tide_index == 1 then
		local location = target:GetAbsOrigin()

		local distance_from_center = ( location - self.position_center ):Length2D()

		local knocking_up = ((self.torrent_radius / distance_from_center ) * 50) * ( attacker:GetAverageTrueAttackDamage(attacker) / 300) + 40
		local knockback =
		{
			should_stun = 1,
			knockback_duration = ability:GetSpecialValueFor("tsunami_stun"),
			duration = ability:GetSpecialValueFor("tsunami_stun"),
			knockback_distance = 0,
			knockback_height = knocking_up,
			center_x = location.x,
			center_y = location.y,
			center_z = location.z
		}

		target:EmitSound("Hero_Kunkka.TidebringerDamage")
		if (knocking_up > sound_height) and not self.sound_triggered then
			EmitSoundOn("Kunkka.ShootingStar", target)
			self.sound_triggered = true
		end

		-- Apply knockback on enemies hit
		target:RemoveModifierByName("modifier_knockback")
		target:AddNewModifier(self:GetParent(), ability, "modifier_knockback", knockback)
	end
end

function modifier_imba_tidebringer:IsHidden()
	return true
end

function modifier_imba_tidebringer:RemoveOnDeath()
	return false
end

function modifier_imba_tidebringer:IsPurgable()
	return false
end

modifier_imba_tidebringer_slow = class({})

function modifier_imba_tidebringer_slow:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return decFuncs
end

function modifier_imba_tidebringer_slow:GetModifierMoveSpeedBonus_Percentage( )
	return ( self:GetAbility():GetSpecialValueFor("tide_red_slow") * (-1) )
end

function modifier_imba_tidebringer_slow:IsDebuff()
	return true
end

function modifier_imba_tidebringer_slow:IsPurgable()
	return true
end

function modifier_imba_tidebringer_slow:IsHidden()
	return false
end

function modifier_imba_tidebringer_slow:RemoveOnDeath()
	return true
end

modifier_imba_tidebringer_cleave_hit_target = class({})

function modifier_imba_tidebringer_cleave_hit_target:IsHidden()
	return true
end

function modifier_imba_tidebringer_cleave_hit_target:IsPurgable()
	return false
end

function modifier_imba_tidebringer_cleave_hit_target:IsDebuff()
	return false
end

function modifier_imba_tidebringer_cleave_hit_target:StatusEffectPriority()
	return 20
end

function modifier_imba_tidebringer_cleave_hit_target:OnDestroy()
	if IsServer() then
		ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = self.cleave_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
	end
end

function modifier_imba_tidebringer_cleave_hit_target:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end

function modifier_imba_tidebringer_cleave_hit_target:GetModifierIncomingDamage_Percentage()
	return -100
end

-------------------------------------------
--			X MARKS THE SPOT
-------------------------------------------

imba_kunkka_x_marks_the_spot = class({})
LinkLuaModifier("modifier_imba_x_marks_the_spot", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_x_marks_the_spot_return", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_x_marks_the_spot_talent_ms", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)

function imba_kunkka_x_marks_the_spot:GetAbilityTextureName()
	return "kunkka_x_marks_the_spot"
end

function imba_kunkka_x_marks_the_spot:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local duration = self:GetSpecialValueFor("duration")
		local sec_duration = self:GetSpecialValueFor("sec_duration")
		local talent_hits = false

		if caster:HasTalent("special_bonus_imba_kunkka_5") then
			local radius = caster:FindTalentValue("special_bonus_imba_kunkka_5")
			-- Finds affected enemies
			local enemies = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
			for _,enemy in pairs(enemies) do
				if enemy ~= target then
					talent_hits = true
					enemy:AddNewModifier(caster, self, "modifier_imba_x_marks_the_spot", {duration = duration, sec_duration = sec_duration})
					self:CreateVisibilityNode(enemy:GetAbsOrigin(), 300, 8)
				end
			end
		end

		if caster:GetTeam() == target:GetTeam() then
			duration = self:GetSpecialValueFor("allied_duration")
			sec_duration = 0
		end
		self:CreateVisibilityNode(target:GetAbsOrigin(), 300, 8)
		if target:TriggerSpellAbsorb(self) then
			if talent_hits then caster:AddNewModifier(caster, self, "modifier_imba_x_marks_the_spot_return", {duration = duration}) end
			return nil
		end
		caster:AddNewModifier(caster, self, "modifier_imba_x_marks_the_spot_return", {duration = duration})
		target:AddNewModifier(caster, self, "modifier_imba_x_marks_the_spot", {duration = duration, sec_duration = sec_duration})
	end
end

function imba_kunkka_x_marks_the_spot:GetAOERadius()
	local caster = self:GetCaster()
	if caster:HasTalent("special_bonus_imba_kunkka_5") then
		return caster:FindTalentValue("special_bonus_imba_kunkka_5")
	end
	return 0
end

function imba_kunkka_x_marks_the_spot:OnUpgrade()
	local ability_handle = self:GetCaster():FindAbilityByName("imba_kunkka_return")
	self.positions = self.positions or {}

	if ability_handle then
		-- Upgrades Return to level 1 and make it inactive, if it hasn't already
		if ability_handle:GetLevel() < 1 then
			ability_handle:SetLevel(1)
			ability_handle:SetActivated(false)
		end
	end
end

function imba_kunkka_x_marks_the_spot:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		local casterID = caster:GetPlayerOwnerID()
		local targetID = target:GetPlayerOwnerID()

		if target ~= nil and not target:IsOpposingTeam(caster:GetTeamNumber()) and PlayerResource:IsDisableHelpSetForPlayerID(targetID,casterID) then
			return UF_FAIL_DISABLE_HELP
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_kunkka_x_marks_the_spot:GetAssociatedSecondaryAbilities()
	return "imba_kunkka_return"
end

function imba_kunkka_x_marks_the_spot:IsHiddenWhenStolen()
	return false
end

modifier_imba_x_marks_the_spot = class({})

function modifier_imba_x_marks_the_spot:OnCreated( params )
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()


		self.position = parent:GetAbsOrigin()
		self.sec_duration = params.sec_duration

		-- Positions for Aghanims Boat
		self.position_id = params.position_id or 0
		if self.position_id == 0 then
			table.insert(ability.positions , self.position)
			self.position_id = #ability.positions
		end

		EmitSoundOn("Ability.XMarksTheSpot.Target", caster)
		EmitSoundOn("Ability.XMark.Target_Movement", parent)

		self.x_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_spell_x_spot.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(self.x_pfx, 0, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.x_pfx, 1, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
	end
end

function modifier_imba_x_marks_the_spot:OnDestroy( params )
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local position = self.position
		local duration = self.sec_duration or 0

		parent:StopSound("Ability.XMark.Target_Movement")
		self.sec_duration = 0

		EmitSoundOn("Ability.XMarksTheSpot.Return", parent)
		ParticleManager:DestroyParticle(self.x_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.x_pfx)

		-- Response 20%
		if (math.random(1,5) < 2) and (caster:GetName() == "npc_dota_hero_kunkka") then
			caster:EmitSound("kunkka_kunk_ability_xmark_0"..math.random(1,5))
		end

		if not ( parent:IsMagicImmune() or parent:IsInvulnerable() ) then
			local stopOrder =
			{
				UnitIndex = parent:entindex(),
				OrderType = DOTA_UNIT_ORDER_STOP
			}
			ExecuteOrderFromTable( stopOrder )

			FindClearSpaceForUnit(parent, self.position, true)
			if duration > 0 then
				parent:AddNewModifier(caster, ability, "modifier_imba_x_marks_the_spot", {duration = duration, sec_duration = 0, position_id = self.position_id})
			else
				ability.positions[self.position_id] = nil
			end
			-- #3 Talent: X Marks The Spot Return grants 10% movespeed for allies, 10% movespeed reduction for enemies
			if caster:HasTalent("special_bonus_imba_kunkka_3") then
				if caster:GetTeamNumber() ~= parent:GetTeamNumber() then
					parent:AddNewModifier(caster,ability,"modifier_imba_x_marks_the_spot_talent_ms",{duration = ability:GetTalentSpecialValueFor("duration")})
				else
					parent:AddNewModifier(caster,ability,"modifier_imba_x_marks_the_spot_talent_ms",{duration = ability:GetTalentSpecialValueFor("allied_duration")})
				end
			end
		end
	end
end

function modifier_imba_x_marks_the_spot:IsDebuff()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	if caster:GetTeamNumber() ~= parent:GetTeamNumber() then
		return true
	end
	return false
end

function modifier_imba_x_marks_the_spot:IsHidden()
	return false
end

function modifier_imba_x_marks_the_spot:GetTexture()
	return "kunkka_x_marks_the_spot"
end

function modifier_imba_x_marks_the_spot:IsPurgable()
	return false
end

function modifier_imba_x_marks_the_spot:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

modifier_imba_x_marks_the_spot_return = class({})

function modifier_imba_x_marks_the_spot_return:IsHidden()
	return true
end

function modifier_imba_x_marks_the_spot_return:GetTexture()
	return "kunkka_x_marks_the_spot"
end

function modifier_imba_x_marks_the_spot_return:IsPurgable()
	return false
end

function modifier_imba_x_marks_the_spot_return:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_x_marks_the_spot_return:OnCreated( params )
	if IsServer() then
		local ability_handle = self:GetCaster():FindAbilityByName("imba_kunkka_return")
		if ability_handle then
			ability_handle:SetActivated(true)
		end
	end
end

function modifier_imba_x_marks_the_spot_return:OnDestroy( params )
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()
		if not caster:HasModifier("modifier_imba_x_marks_the_spot_return") and caster:HasAbility("imba_kunkka_return") then
			caster:FindAbilityByName("imba_kunkka_return"):SetActivated(false)
		end
	end
end

modifier_imba_x_marks_the_spot_talent_ms = class({})

function modifier_imba_x_marks_the_spot_talent_ms:IsDebuff()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	if caster:GetTeamNumber() ~= parent:GetTeamNumber() then
		return true
	end
	return false
end

function modifier_imba_x_marks_the_spot_talent_ms:IsHidden()
	return false
end

function modifier_imba_x_marks_the_spot_talent_ms:GetTexture()
	return "kunkka_x_marks_the_spot"
end

function modifier_imba_x_marks_the_spot_talent_ms:IsPurgable()
	return false
end

function modifier_imba_x_marks_the_spot_talent_ms:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_x_marks_the_spot_talent_ms:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_imba_x_marks_the_spot_talent_ms:GetModifierMoveSpeedBonus_Percentage()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	if caster:GetTeamNumber() ~= parent:GetTeamNumber() then
		return caster:FindTalentValue("special_bonus_imba_kunkka_3") * (-1)
	end
	return caster:FindTalentValue("special_bonus_imba_kunkka_3")
end

-------------------------------------------
--			   RETURN
-------------------------------------------

imba_kunkka_return = class({})

function imba_kunkka_return:GetAbilityTextureName()
	return "kunkka_return"
end

function imba_kunkka_return:IsNetherWardStealable() return false end

function imba_kunkka_return:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false)
		for _,target in pairs(targets) do
			if target:HasModifier("modifier_imba_x_marks_the_spot") then
				local modifiers = target:FindAllModifiersByName("modifier_imba_x_marks_the_spot")
				for _, modifier in pairs( modifiers ) do
					if (( modifier:GetCaster() == self:GetCaster() ) and ( (modifier.sec_duration > 0) or (modifier:IsDebuff() == false))) then
						modifier:Destroy()
					end
				end
			end
		end
		for _, modifier in pairs( caster:FindAllModifiersByName("modifier_imba_x_marks_the_spot_return") ) do
			modifier:Destroy()
		end
	end
end

function imba_kunkka_return:IsHiddenWhenStolen()
	return false
end

function imba_kunkka_return:IsStealable()
	return false
end

function imba_kunkka_return:GetAssociatedPrimaryAbilities()
	return "imba_kunkka_x_marks_the_spot"
end

-------------------------------------------
--			GHOSTSHIP
-------------------------------------------

imba_kunkka_ghostship = class({})
LinkLuaModifier("modifier_imba_ghostship_rum", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ghostship_rum_damage", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ghostship_tide_slow", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ghostship_drag", "components/abilities/heroes/hero_kunkka", LUA_MODIFIER_MOTION_NONE)

function imba_kunkka_ghostship:GetAbilityTextureName()
	return "kunkka_ghostship"
end

function imba_kunkka_ghostship:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorPosition()

		-- Parameters
		local scepter = caster:HasScepter()
		local damage = self:GetSpecialValueFor("damage")
		local speed = self:GetSpecialValueFor("ghostship_speed")
		local radius = self:GetSpecialValueFor("ghostship_width")
		local start_distance = self:GetSpecialValueFor("start_distance")
		local crash_distance = self:GetSpecialValueFor("crash_distance")
		local stun_duration = self:GetSpecialValueFor("stun_duration")
		local buff_duration = self:GetSpecialValueFor("buff_duration")
		local crash_delay = 0
		local caster_pos = caster:GetAbsOrigin()

		-- Check buffs by Ebb and Flow
		local tsunami = caster:HasModifier("modifier_imba_ebb_and_flow_tsunami")
		-- Flood Tide
		if caster:HasModifier("modifier_imba_ebb_and_flow_tide_flood") or tsunami then
			damage = damage + self:GetSpecialValueFor("tide_flood_damage")
		end
		-- High Tide
		if caster:HasModifier("modifier_imba_ebb_and_flow_tide_high") or tsunami then
			if scepter then
				radius = radius + self:GetSpecialValueFor("scepter_tide_high_radius")
			end
			radius = radius + self:GetSpecialValueFor("tide_high_radius")
		end
		-- Wave Tide
		if caster:HasModifier("modifier_imba_ebb_and_flow_tide_wave") or tsunami then
			speed = speed + self:GetSpecialValueFor("tide_wave_speed")
		end
		-- Red Tide
		local extra_slow = false
		if caster:HasModifier("modifier_imba_ebb_and_flow_tide_red") or tsunami then
			extra_slow = true
		end
		-- Tsunami exclusive
		if tsunami then
			stun_duration = stun_duration + self:GetSpecialValueFor("tsunami_stun")
		end

		-- Calculate spawn and crash positions
		local closest_target = true
		local spawn_pos
		local boat_direction
		local crash_pos
		local travel_time

		-- Response on cast
		if caster:GetName() == "npc_dota_hero_kunkka" then
			caster:EmitSound("kunkka_kunk_ability_ghostshp_0"..math.random(1,3))
		end

		-- Scepter check
		if scepter then
			local scepter_damage = damage * (self:GetSpecialValueFor("buff_duration") / 100)
			-- Wave Tide
			if caster:HasModifier("modifier_imba_ebb_and_flow_tide_wave") or tsunami then
				crash_delay = self:GetSpecialValueFor("scepter_tide_wave_delay")
			else
				crash_delay = self:GetSpecialValueFor("scepter_crash_delay")
			end

			spawn_pos = target

			boat_direction = ( target - caster_pos ):Normalized()
			crash_pos = target + boat_direction * (start_distance + crash_distance) * (-1)
		end

		-- In case the ability is stolen don't cast the next tide
		if caster:HasAbility("imba_kunkka_ebb_and_flow") and not ( caster:HasModifier("modifier_imba_ebb_and_flow_tide_low") and not scepter ) then
			local ability_tide = caster:FindAbilityByName("imba_kunkka_ebb_and_flow")
			ability_tide:CastAbility()
		end

		if not scepter then
			boat_direction = ( target - caster_pos ):Normalized()
			crash_pos = target
			spawn_pos = target + boat_direction * (start_distance + crash_distance) * (-1)
		end

		travel_time = ((start_distance + crash_distance - radius ) / speed )
		local bubbles_pfx
		-- Aghanims crushing down
		if scepter then
			local height = 1000
			local ticks = FrameTime()
			local travel = 0
			local float_boat = spawn_pos + Vector(0,0,height)
			local height_ticks = height *  ticks / crash_delay * (-1)
			self:CreateVisibilityNode(target, radius, crash_delay + 1 )
			bubbles_pfx = ParticleManager:CreateParticle("particles/hero/kunkka/torrent_bubbles.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(bubbles_pfx, 0, target)
			ParticleManager:SetParticleControl(bubbles_pfx, 1, Vector(radius,0,0))
			Timers:CreateTimer((crash_delay + 1), function()
					ParticleManager:DestroyParticle(bubbles_pfx, false)
					ParticleManager:ReleaseParticleIndex(bubbles_pfx)
				end)
			local boat_pfx = ParticleManager:CreateParticle("particles/hero/kunkka/kunkka_ghost_ship.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(boat_pfx, 0, (spawn_pos - boat_direction * (-1) * crash_distance ) )
			Timers:CreateTimer(ticks, function()
					float_boat = float_boat + Vector(0,0,height_ticks)
					ParticleManager:SetParticleControl(boat_pfx, 3, float_boat )

					travel = travel + ticks
					if travel > crash_delay then

						-- Water Nova on hit + crash sound
						local water_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_boat_splash_end.vpcf", PATTACH_CUSTOMORIGIN, caster)
						ParticleManager:SetParticleControl(water_fx, 3, target)
						Timers:CreateTimer(2, function()
								ParticleManager:DestroyParticle(water_fx, false)
								ParticleManager:ReleaseParticleIndex(water_fx)
							end)

						-- Stunning and rooting all hit enemies
						local enemies = FindUnitsInRadius(caster:GetTeam(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, self:GetAbilityTargetType(), 0, 0, false)
						for k, enemy in pairs(enemies) do
							--enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = travel_time})
							--enemy:AddNewModifier(caster, self, "modifier_rooted", { duration = travel_time})

							-- Deal crash damage to enemies hit
							ApplyDamage({victim = enemy, attacker = caster, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
						end

						-- Setting ship underneath the world + deleting it
						ParticleManager:SetParticleControl(boat_pfx, 3, ( float_boat - Vector(0,0,500)) )
						ParticleManager:DestroyParticle(boat_pfx, false)
						ParticleManager:ReleaseParticleIndex(boat_pfx)
						return nil
					end
					return ticks
				end)
		end

		Timers:CreateTimer(crash_delay, function()
				self:CreateVisibilityNode(crash_pos, radius, travel_time + 2 )
				local boat_velocity
				if caster:HasScepter() then
					boat_velocity = boat_direction * speed * (-1)
				else
					boat_velocity = boat_direction * speed
				end
				-- Spawn the boat
				local boat_projectile = {
					Ability = self,
					EffectName = "particles/units/heroes/hero_kunkka/kunkka_ghost_ship.vpcf",
					vSpawnOrigin = spawn_pos,
					fDistance = start_distance + crash_distance - radius,
					fStartRadius = radius,
					fEndRadius = radius,
					fExpireTime = GameRules:GetGameTime() + travel_time + 2,
					Source = caster,
					bHasFrontalCone = false,
					bReplaceExisting = false,
					bProvidesVision = false,
					iUnitTargetTeam = self:GetAbilityTargetTeam(),
					iUnitTargetType = self:GetAbilityTargetType(),
					vVelocity = boat_velocity,
					ExtraData =
					{
						crash_x = crash_pos.x,
						crash_y = crash_pos.y,
						crash_z = crash_pos.z,
						speed = speed,
						radius = radius
					}
				}
				ProjectileManager:CreateLinearProjectile(boat_projectile)

				EmitSoundOnLocationWithCaster( spawn_pos, "Ability.Ghostship.bell", caster )
				EmitSoundOnLocationWithCaster( spawn_pos, "Ability.Ghostship", caster )

				-- Show visual crash point effect to allies only
				local crash_pfx = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_kunkka/kunkka_ghostship_marker.vpcf", PATTACH_ABSORIGIN, caster, caster:GetTeam())
				ParticleManager:SetParticleControl(crash_pfx, 0, crash_pos )
				-- Destroy particle after the crash
				Timers:CreateTimer(travel_time, function()
						ParticleManager:DestroyParticle(crash_pfx, false)
						ParticleManager:ReleaseParticleIndex(crash_pfx)

						-- Fire sound on crash point
						EmitSoundOnLocationWithCaster(crash_pos, "Ability.Ghostship.crash", caster)

						-- Stun and damage enemies
						local enemies = FindUnitsInRadius(caster:GetTeam(), crash_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, self:GetAbilityTargetType(), 0, 0, false)
						if (not (#enemies > 0)) and (caster:GetName() == "npc_dota_hero_kunkka") then
							if math.random(1,2) == 1 then
								caster:EmitSound("kunkka_kunk_ability_failure_0"..math.random(1,2))
							end
						end
						for k, enemy in pairs(enemies) do
							ApplyDamage({victim = enemy, attacker = caster, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
							if extra_slow then
								enemy:AddNewModifier(caster, self, "modifier_imba_ghostship_tide_slow", { duration = stun_duration + self:GetSpecialValueFor("tide_red_slow_duration") })
							end
							enemy:AddNewModifier(caster, self, "modifier_stunned", { duration = stun_duration })
						end
					end)
			end)
	end
end

function imba_kunkka_ghostship:IsHiddenWhenStolen()
	return false
end

function imba_kunkka_ghostship:GetCastRange( location , target)
	local caster = self:GetCaster()
	local range = self.BaseClass.GetCastRange(self,location,target)
	if caster:HasScepter() then
		range = self:GetSpecialValueFor("scepter_cast_range")
	end
	if caster:HasModifier("modifier_imba_ebb_and_flow_tide_low") or caster:HasModifier("modifier_imba_ebb_and_flow_tsunami") then
		range = range + self:GetSpecialValueFor("scepter_tide_low_range")
	end
	return range
end

function imba_kunkka_ghostship:GetAOERadius()
	local caster = self:GetCaster()
	if (not caster:HasScepter()) then return 0 end
	local radius = self:GetSpecialValueFor("ghostship_width")
	if caster:HasModifier("modifier_imba_ebb_and_flow_tide_high") or caster:HasModifier("modifier_imba_ebb_and_flow_tsunami") then
		radius = radius + self:GetSpecialValueFor("scepter_high_tide_radius")
	end
	return radius
end

function imba_kunkka_ghostship:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target then
		local caster = self:GetCaster()
		
		-- If the target hit is on the same team as the caster, give them the rum buff and do nothing else
		if caster:GetTeam() == target:GetTeam() then
			local duration = self:GetSpecialValueFor("buff_duration")
			target:AddNewModifier(caster, self, "modifier_imba_ghostship_rum", { duration = duration })
			-- #4 Talent: Ghostship now drags Kunkka into the target location
			if caster:HasTalent("special_bonus_imba_kunkka_6") then
				if target == caster then
				else
					return false
				end
			else
				return false
			end
		end
		
		-- Rest of this code is for enemy interaction
		
		-- The exact location where the boat is going to finish impact
		local crash_pos =  Vector(ExtraData.crash_x,ExtraData.crash_y,ExtraData.crash_z)
		-- The exact location where the enemy makes contact with the boat
		local target_pos = target:GetAbsOrigin()
		-- 
		local knockback_origin = target_pos + (target_pos - crash_pos):Normalized() * 100
		-- Distnace between target and crash location
		local distance = (crash_pos - target_pos ):Length2D()
		local duration = ((location - crash_pos ):Length2D() - ExtraData.radius) / ExtraData.speed
		if IsNearFountain(target_pos, 1200) or IsNearFountain(crash_pos, 1200) then
			duration = 0
		end
		
		-- Apply the knockback modifier
		local knockback =
		{	should_stun = 0,
			knockback_duration = duration,
			duration = duration,
			knockback_distance = distance,
			knockback_height = 0,
			center_x = knockback_origin.x + (math.random() * math.random(-10,10)),
			center_y = knockback_origin.y + (math.random() * math.random(-10,10)),
			center_z = knockback_origin.z
		}
		-- Apply a new modifier to drag
		if target == caster then
			ghostship_drag = target:AddNewModifier(caster,self,"modifier_imba_ghostship_drag", {duration = duration})
			if ghostship_drag then
				ghostship_drag.crash_pos = crash_pos
				ghostship_drag.direction = (crash_pos - target_pos):Normalized()
				ghostship_drag.ship_width = ExtraData.radius
				ghostship_drag.ship_speed = ExtraData.speed
			end
		else
			target:RemoveModifierByName("modifier_knockback")
			target:AddNewModifier(caster, nil, "modifier_knockback", knockback)
		end
	end
	return false
end

modifier_imba_ghostship_drag = class({})

function modifier_imba_ghostship_drag:IsHidden()
	return false
end

function modifier_imba_ghostship_drag:IsPurgable()
	return false
end

function modifier_imba_ghostship_drag:IsDebuff()
	return false
end

function modifier_imba_ghostship_drag:RemoveOnDeath()
	return false
end

function modifier_imba_ghostship_drag:IsMotionController()
	return true
end

function modifier_imba_ghostship_drag:StatusEffectPriority()
	return 20
end

function modifier_imba_ghostship_drag:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_imba_ghostship_drag:GetMotionControllerPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH
end

function modifier_imba_ghostship_drag:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.tick = FrameTime()

		self:StartIntervalThink(self.tick)
	end
end

function modifier_imba_ghostship_drag:OnIntervalThink()
	-- Check for motion controllers
	if self:CheckMotionControllers() then
	else
		self:Destroy()
		return nil
	end

	self:GetDragged()
end

function modifier_imba_ghostship_drag:GetDragged()
	if IsServer() then
		self.current_loc = self.caster:GetAbsOrigin()
		self.new_loc = self.current_loc + self.direction * self.ship_speed * self.tick
		self.distance = (self.crash_pos - self.current_loc):Length2D()

		Timers:CreateTimer(self.tick, function()
				if not self:IsNull() then
					self.next_loc = self.caster:GetAbsOrigin()
					self.distance_between_ship = (self.next_loc - self.current_loc):Length2D()
					-- If Kunkka exits the Ghost ship, remove the drag force.
					if self.distance_between_ship > (self.ship_width/2) then
						self:Destroy()
					end
				end
			end)
		-- If the distance is more than 20, set Kunkka to the new dragged location
		if self.distance > 20 then
			self.caster:SetAbsOrigin(self.new_loc)
		else
			self.caster:SetAbsOrigin(self.crash_pos)
			self.caster:SetUnitOnClearGround()
			self:Destroy()
		end
	end
end

function modifier_imba_ghostship_drag:OnDestroy()
	if IsServer() then
		if self.caster:HasModifier("modifier_item_forcestaff_active") or self.caster:HasModifier("modifier_item_hurricane_pike_active") or self.caster:HasModifier("modifier_item_hurricane_pike_active_alternate") then
		else
			self.caster:SetUnitOnClearGround()
		end
	end
end

modifier_imba_ghostship_rum = class({})

function modifier_imba_ghostship_rum:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("rum_speed")
end

-- Setting up the damage counter
function modifier_imba_ghostship_rum:OnCreated()
	if IsServer() then
		self.damage_counter = 0
	end
end

function modifier_imba_ghostship_rum:GetCustomIncomingDamagePct()
	return self:GetAbility():GetSpecialValueFor("rum_reduce_pct") * (-1)
end

function modifier_imba_ghostship_rum:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return decFuncs
end

function modifier_imba_ghostship_rum:OnTakeDamage( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			local rum_reduction = (100 - self:GetAbility():GetSpecialValueFor("rum_reduce_pct"))/100
			local gen_reduction = (100 + params.unit:GetIncomingDamagePct())/100
			local prevented_damage = params.damage / rum_reduction - params.damage

			self.damage_counter = self.damage_counter + prevented_damage
		end
	end
end

function modifier_imba_ghostship_rum:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		if not caster:HasTalent("special_bonus_imba_kunkka_8") then
			self:GetParent():AddNewModifier(caster, ability, "modifier_imba_ghostship_rum_damage", { duration = ability:GetSpecialValueFor("damage_duration"), stored_damage = self.damage_counter })
		end
		self.damage_counter = 0
	end
end

function modifier_imba_ghostship_rum:GetStatusEffectName()
	return "particles/status_fx/status_effect_rum.vpcf"
end

function modifier_imba_ghostship_rum:StatusEffectPriority()
	return 10
end

function modifier_imba_ghostship_rum:GetTexture()
	return "kunkka_ghostship"
end

function modifier_imba_ghostship_rum:IsHidden()
	return false
end

function modifier_imba_ghostship_rum:IsPurgable()
	return false
end

function modifier_imba_ghostship_rum:IsDebuff( )
	return false
end

modifier_imba_ghostship_rum_damage = class({})

function modifier_imba_ghostship_rum_damage:GetCustomIncomingDamagePct()
	return self:GetAbility():GetSpecialValueFor("rum_reduce_pct")
end

function modifier_imba_ghostship_rum_damage:IsHidden()
	return false
end

function modifier_imba_ghostship_rum_damage:GetTexture()
	return "kunkka_ghostship"
end

function modifier_imba_ghostship_rum_damage:IsPurgable()
	return false
end

function modifier_imba_ghostship_rum_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_ghostship_rum_damage:IsDebuff( )
	return true
end

function modifier_imba_ghostship_rum_damage:OnCreated( params )
	if IsServer() then
		local ability = self:GetAbility()
		local parent = self:GetParent()

		local damage_duration = ability:GetSpecialValueFor("damage_duration")
		local damage_interval = ability:GetSpecialValueFor("damage_interval")
		local ticks = damage_duration / damage_interval
		local damage_amount = params.stored_damage / ticks
		local current_tick = 0

		Timers:CreateTimer(damage_interval, function()
				-- If the target has died, do nothing
				if parent:IsAlive() then

					-- Nonlethal HP removal
					local target_hp = parent:GetHealth()
					if target_hp - damage_amount < 1 then
						parent:SetHealth(1)
					else
						parent:SetHealth(target_hp - damage_amount)
					end

					current_tick = current_tick + 1
					if current_tick >= ticks then
						return nil
					else
						return damage_interval
					end
				else
					return nil
				end
			end)
	end
end

modifier_imba_ghostship_tide_slow = class({})

function modifier_imba_ghostship_tide_slow:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return decFuncs
end

function modifier_imba_ghostship_tide_slow:GetModifierMoveSpeedBonus_Percentage( )
	return ( self:GetAbility():GetSpecialValueFor("tide_red_slow") * (-1) )
end

function modifier_imba_ghostship_tide_slow:IsDebuff()
	return true
end

function modifier_imba_ghostship_tide_slow:IsPurgable()
	return true
end

function modifier_imba_ghostship_tide_slow:IsHidden()
	return false
end

function modifier_imba_ghostship_tide_slow:RemoveOnDeath()
	return true
end
