local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local game = Game()
local rng = RNG()

local SanguineBond = {}

function SanguineBond.postNewRoom()
	local room = game:GetRoom()

	if room:GetType() ~= RoomType.ROOM_DEVIL then return end
	if not room:IsFirstVisit() then return end

	if not Functions.AnyPlayerHasCollectible(CollectibleType.COLLECTIBLE_SANGUINE_BOND)
	or not Functions.AnyPlayerIsType(Enums.Characters.MASTEMA)
	or not Functions.AnyPlayerIsType(Enums.Characters.T_MASTEMA)
	then
		return
	end
	
	--Fix beggars/pickups spawning on top of the Sanguine Bond spikes
	local pickup = Isaac.FindByType(EntityType.ENTITY_PICKUP, -1)
	local demonBeggar = Isaac.FindByType(EntityType.ENTITY_SLOT, 5)
	
	if #demonBeggar > 0 then
		for i = 1, #demonBeggar do
			if demonBeggar[i].Position:Distance(room:GetCenterPos()) < 1 then
				demonBeggar[i].Position = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0)
			end
		end
	end

	if #pickup > 0 then
		for i = 1, #pickup do
			if pickup[i].Position:Distance(room:GetCenterPos()) < 1 then
				pickup[i].Position = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0)
			end
		end
	end
end

function SanguineBond.postPEffectUpdate(player)
	local room = game:GetRoom()
	local grid = room:GetGridEntity(67)
	
	if room:GetType() ~= RoomType.ROOM_DEVIL then return end

	if Functions.AnyPlayerHasCollectible(CollectibleType.COLLECTIBLE_SANGUINE_BOND)
	or player:GetPlayerType() == Enums.Characters.MASTEMA
	or player:GetPlayerType() == Enums.Characters.T_MASTEMA
	then
		if grid == nil then
			local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_SANGUINE_BOND)
			rng:SetSeed(room:GetDecorationSeed(), 35)
			local variant = rng:RandomInt(4) + 101
			room:SpawnGridEntity(67, GridEntityType.GRID_SPIKES, variant, room:GetDecorationSeed(), 0)
			local spikes = room:GetGridEntity(67)
			spikes:GetRNG():SetSeed(room:GetDecorationSeed(), 35)
			local sprite = spikes:GetSprite()
			sprite:Play("Summon")
		else
			if grid:GetType() ~= GridEntityType.GRID_SPIKES
			or (grid:GetType() == GridEntityType.GRID_SPIKES and grid:GetVariant() < 101)
			then
				room:RemoveGridEntity(67, 0, false)
				room:Update()
			end
		end
	end
end

return SanguineBond