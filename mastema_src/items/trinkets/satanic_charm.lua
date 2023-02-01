local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local SaveData = require("mastema_src.savedata")
local game = Game()

local Trinket = {}

function Trinket.evaluateCache(player, cacheFlag)
	if not player:HasTrinket(Enums.Trinkets.SATANIC_CHARM) then return end
	if cacheFlag ~= CacheFlag.CACHE_DAMAGE then return end

	local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.SATANIC_CHARM)
	local dmg = 0.5

	if player:GetPlayerType() == Enums.Characters.MASTEMA
	or player:GetPlayerType() == Enums.Characters.T_MASTEMA
	then
		dmg = 0.25
	end

	if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
		player.Damage = player.Damage + (dmg * SaveData.ItemData.SatanicCharm.DMG * trinketMultiplier * 0.2)
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
		player.Damage = player.Damage + (dmg * SaveData.ItemData.SatanicCharm.DMG * trinketMultiplier * 0.3)
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
		player.Damage = player.Damage + (dmg * SaveData.ItemData.SatanicCharm.DMG * trinketMultiplier * 0.8)
	else
		player.Damage = player.Damage + (dmg * SaveData.ItemData.SatanicCharm.DMG * trinketMultiplier)
	end
end

function Trinket.prePickupCollision(pickup, collider, low)
	if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
	if pickup.SubType == 0 then return end
	if pickup.Price == PickupPrice.PRICE_FREE then return end
	if pickup.Price == PickupPrice.PRICE_SPIKES then return end
	if pickup.Price == PickupPrice.PRICE_SOUL then return end

	local room = game:GetRoom()

	if (pickup.Price >= 0 and room:GetType() ~= RoomType.ROOM_DEVIL)
	or (pickup.Price == 0 and room:GetType() == RoomType.ROOM_DEVIL)
	then
		return
	end
	
	local player = collider:ToPlayer()

	if player == nil then return end
	if not player:HasTrinket(Enums.Trinkets.SATANIC_CHARM) then return end
	if player:IsCoopGhost() or (player.SubType == 59 and player.Parent ~= nil) then return end
	if not Functions.CanPickUpItem(player, pickup) then return end

	SaveData.ItemData.SatanicCharm.DMG = SaveData.ItemData.SatanicCharm.DMG + 1
	player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
	player:EvaluateItems()
end

return Trinket