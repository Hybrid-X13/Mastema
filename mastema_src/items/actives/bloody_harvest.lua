local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local game = Game()
local rng = RNG()

local Item = {}

function Item.useItem(item, rng, player, flags, activeSlot, customVarData)
	if item ~= Enums.Collectibles.BLOODY_HARVEST then return end
	
	local room = game:GetRoom()
	local spawnpos = Isaac.GetFreeNearPosition(player.Position, 40)
	local randNum = rng:RandomInt(10)
	
	if flags & UseFlag.USE_NOHUD == UseFlag.USE_NOHUD
	and player:GetPlayerType() == Enums.Characters.MASTEMA
	and player:HasTrinket(Enums.Trinkets.MASTEMA_BIRTHCAKE)
	then
		randNum = 0
		spawnpos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0)
	end

	if randNum == 9 then --Spawn devil deal
		local itemID
		
		if player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) then
			local pool = rng:RandomInt(ItemPoolType.NUM_ITEMPOOLS)
			local seed = rng:RandomInt(999999999)
			itemID = game:GetItemPool():GetCollectible(pool, true, seed)
		else
			itemID = game:GetItemPool():GetCollectible(ItemPoolType.POOL_DEVIL, true, randNum)
		end
		
		local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
		local collectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, spawnpos, Vector.Zero, nil)
		local devilItem = collectible:ToPickup()
		local devilPrice = itemConfig.DevilPrice
		local maxRedHearts = player:GetEffectiveMaxHearts()
		
		if player:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) then
			devilItem.Price = PickupPrice.PRICE_SOUL
		elseif Functions.IsKeeper(player) then
			if devilPrice == 2 then
				devilItem.Price = math.floor(30 / (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_STEAM_SALE) + 1))
			else
				devilItem.Price = 15
			end
		elseif maxRedHearts > 0
		and not Functions.IsSoulHeartCharacter(player)
		then
			if devilPrice == 2
			and not player:HasTrinket(TrinketType.TRINKET_JUDAS_TONGUE)
			then
				if maxRedHearts >= 4 then
					devilItem.Price = PickupPrice.PRICE_TWO_HEARTS
				else
					devilItem.Price = PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS
				end
			else
				devilItem.Price = PickupPrice.PRICE_ONE_HEART
			end
		else
			if player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY then
				if devilPrice == 2 then
					devilItem.Price = PickupPrice.PRICE_TWO_SOUL_HEARTS
				else
					devilItem.Price = PickupPrice.PRICE_ONE_SOUL_HEART
				end
			else
				devilItem.Price = PickupPrice.PRICE_THREE_SOULHEARTS
			end
		end
		
		if room:GetType() ~= RoomType.ROOM_SHOP then
			devilItem.ShopItemId = -1
		end

		if devilItem.Price > 15
		or (devilItem.Price == 15 and devilPrice == 2)
		or devilItem.Price < 0
		then
			devilItem.AutoUpdatePrice = false
		end

		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, devilItem.Position, Vector.Zero, devilItem)
	else --Spawn pickup surrounded by spikes
		randNum = rng:RandomInt(7)
		local spawnPickup
		
		if randNum == 0 then --Spawn one of the heart subtypes below or a coin when playing as Keeper/T. Keeper
			randNum = rng:RandomInt(100)
			
			if Functions.IsKeeper(player) then
				spawnPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, spawnpos, Vector.Zero, nil)
			elseif randNum == 0 then
				spawnPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_GOLDEN, spawnpos, Vector.Zero, nil)
			elseif randNum < 4 then
				spawnPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ETERNAL, spawnpos, Vector.Zero, nil)
			elseif randNum < 9 then
				spawnPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN, spawnpos, Vector.Zero, nil)
			elseif randNum < 16 then
				spawnPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_DOUBLEPACK, spawnpos, Vector.Zero, nil)
			elseif randNum < 26 then
				spawnPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BONE, spawnpos, Vector.Zero, nil)
			elseif randNum < 46 then
				spawnPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, spawnpos, Vector.Zero, nil)
			elseif randNum < 71 then
				spawnPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, spawnpos, Vector.Zero, nil)
			else
				spawnPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, spawnpos, Vector.Zero, nil)
			end
		elseif randNum == 1 then --Spawn any type of key
			spawnPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, spawnpos, Vector.Zero, nil)
		elseif randNum == 2 then --Spawn either a normal bomb, double pack, or golden bomb
			randNum = rng:RandomInt(20)
				
			if randNum == 0 then
				spawnPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDEN, spawnpos, Vector.Zero, nil)
			elseif randNum < 3 then
				spawnPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_DOUBLEPACK, spawnpos, Vector.Zero, nil)
			else
				spawnPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL, spawnpos, Vector.Zero, nil)
			end
		elseif randNum == 3 then --Spawn any type of sack
			spawnPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0, spawnpos, Vector.Zero, nil)
		elseif randNum == 4 then --Spawn any type of card or rune
			spawnPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, spawnpos, Vector.Zero, nil)
		elseif randNum == 5 then --Spawn trinket
			spawnPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, spawnpos, Vector.Zero, nil)
		elseif randNum == 6 then --Spawn pill
			spawnPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, spawnpos, Vector.Zero, nil)
		end
		
		local pickup = spawnPickup:ToPickup()
		pickup.Price = PickupPrice.PRICE_SPIKES
		
		if room:GetType() ~= RoomType.ROOM_SHOP then
			pickup.ShopItemId = -1
		end
		
		pickup.AutoUpdatePrice = false
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, pickup)
	end
	
	return true
end

function Item.postPEffectUpdate(player)
	if not player:HasCollectible(Enums.Collectibles.BLOODY_HARVEST) then return end
	if player:GetPlayerType() == Enums.Characters.MASTEMA then return end
		
	local room = game:GetRoom()
	local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
	local maxRedHearts = player:GetEffectiveMaxHearts()
	
	for i, j in pairs(items) do
		local collectible = j:ToPickup()
		
		if collectible.SubType > 0 then
			local itemID = collectible.SubType
			local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
			local devilPrice = itemConfig.DevilPrice
			
			if collectible.Price < 0 then
				if player:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) then
					collectible.Price = PickupPrice.PRICE_SOUL
				elseif maxRedHearts > 0
				and not Functions.IsSoulHeartCharacter(player)
				then
					if devilPrice == 2
					and not player:HasTrinket(TrinketType.TRINKET_JUDAS_TONGUE)
					then
						if maxRedHearts >= 4 then
							collectible.Price = PickupPrice.PRICE_TWO_HEARTS
						else
							collectible.Price = PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS
						end
					else
						collectible.Price = PickupPrice.PRICE_ONE_HEART
					end
				else
					if player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY then
						if devilPrice == 2 then
							collectible.Price = PickupPrice.PRICE_TWO_SOUL_HEARTS
						else
							collectible.Price = PickupPrice.PRICE_ONE_SOUL_HEART
						end
					else
						collectible.Price = PickupPrice.PRICE_THREE_SOULHEARTS
					end
				end
				
				if room:GetType() ~= RoomType.ROOM_SHOP then
					collectible.ShopItemId = -1
				end
				
				collectible.AutoUpdatePrice = false
			end
		end
	end
end

return Item