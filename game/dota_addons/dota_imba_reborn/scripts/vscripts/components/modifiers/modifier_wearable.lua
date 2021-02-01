modifier_wearable = modifier_wearable or class({})

function modifier_wearable:CheckState() return { 
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
} end

function modifier_wearable:IsPurgable() return false end
function modifier_wearable:IsStunDebuff() return false end
function modifier_wearable:IsPurgeException() return false end
function modifier_wearable:IsHidden() return true end

function modifier_wearable:OnCreated()
	if not IsServer() then return end

	self:StartIntervalThink(FrameTime())
	self.render_color = nil
end

function modifier_wearable:OnIntervalThink()
	local cosmetic = self:GetParent()
	local hero = cosmetic:GetOwnerEntity()
	if hero == nil then return end

	if self.render_color == nil then
		if hero:HasModifier("modifier_juggernaut_arcana") then
--			print("Jugg arcana 1, Color wearables!")
			self.render_color = true
			cosmetic:SetRenderColor(80, 80, 100)
		elseif hero:HasModifier("modifier_juggernaut_arcana") and hero:FindModifierByName("modifier_juggernaut_arcana"):GetStackCount() == 1 then
			print("Jugg arcana 2, Color wearables!")
			self.render_color = true
			cosmetic:SetRenderColor(255, 220, 220)
		elseif hero:GetUnitName() == "npc_dota_hero_vardor" then
--			print("Vardor, Color wearables!")
			self.render_color = true
			cosmetic:SetRenderColor(255, 0, 0)
		end
	end

	for _, v in pairs(IMBA_INVISIBLE_MODIFIERS) do
		local mod = hero:FindModifierByName(v)

		if not mod then
			if cosmetic:HasModifier(v) then
				cosmetic:RemoveModifierByName(v)
			end
		else
			if not cosmetic:HasModifier(v) then
				cosmetic:AddNewModifier(cosmetic, mod:GetAbility(), v, {})
				break -- remove this break if you want to add multiple modifiers at the same time
			end
		end
	end

	for _, v in pairs(IMBA_NODRAW_MODIFIERS) do
		if hero:HasModifier(v) then
			if not cosmetic.model then
				print("ADD NODRAW TO COSMETICS")
				cosmetic.model = cosmetic:GetModelName()
			end

			if cosmetic.model and cosmetic:GetModelName() ~= "models/development/invisiblebox.vmdl" then
				cosmetic:SetOriginalModel("models/development/invisiblebox.vmdl")
				cosmetic:SetModel("models/development/invisiblebox.vmdl")
				break
			end
		else
			if cosmetic.model and cosmetic:GetModelName() ~= cosmetic.model then
				print("REMOVE NODRAW TO COSMETICS")
				cosmetic:SetOriginalModel(cosmetic.model)
				cosmetic:SetModel(cosmetic.model)
				break
			end
		end
	end

	if hero:IsOutOfGame() or hero:IsHexed() then
		cosmetic:AddNoDraw()
	else
		cosmetic:RemoveNoDraw()
	end
end
