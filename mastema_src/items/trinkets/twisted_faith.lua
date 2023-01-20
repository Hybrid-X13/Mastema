local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local game = Game()
local rng = RNG()
local GOLDEN_TWISTED_FAITH = Enums.Trinkets.TWISTED_FAITH + TrinketType.TRINKET_GOLDEN_FLAG

local Trinket = {}

local function TwistedFaithEffect(player)
	local room = game:GetRoom()
	local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
	
	if room:GetType() == RoomType.ROOM_DEVIL then
		player:UseCard(Card.CARD_CREDIT, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)

		if player:GetTrinketMultiplier(Enums.Trinkets.TWISTED_FAITH) > 1 then
			local pos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0)

			if Functions.AnyPlayerIsType(Enums.Characters.MASTEMA)
			or Functions.AnyPlayerIsType(Enums.Characters.T_MASTEMA)
			then
				pos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
			end

			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, pos, Vector.Zero, nil)
		end

		for _, j in pairs(items) do
			local collectible = j:ToPickup()
			collectible.OptionsPickupIndex = 666
		end
	elseif room:GetType() == RoomType.ROOM_ANGEL then
		if player:GetTrinketMultiplier(Enums.Trinkets.TWISTED_FAITH) > 1 then
			local pos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, pos, Vector.Zero, nil)
		end
		
		for _, j in pairs(items) do
			local collectible = j:ToPickup()
			local maxRedHearts = player:GetEffectiveMaxHearts()
			
			if collectible.SubType > 0 then
				local itemID = collectible.SubType
				local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
				local devilPrice = itemConfig.DevilPrice
				
				collectible.OptionsPickupIndex = 0
			
				if collectible.Price == 0 then
					if player:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) then
						collectible.Price = PickupPrice.PRICE_SOUL
					elseif player:GetPlayerType() == PlayerType.PLAYER_KEEPER
					or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B
					or player:HasCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH)
					then
						if devilPrice == 2 then
							collectible.Price = math.floor(30 / (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_STEAM_SALE) + 1))
						else
							collectible.Price = 15
						end
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

					collectible.ShopItemId = -1
					
					if collectible.Price > 15
					or collectible.Price < 0
					or (collectible.Price > 0 and player:HasCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH))
					then
						collectible.AutoUpdatePrice = false
					end
				end
			end
		end
	end
end

function Trinket.postNewRoom()
	local room = game:GetRoom()

	if not room:IsFirstVisit() then return end
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:HasTrinket(Enums.Trinkets.TWISTED_FAITH)
		and (room:GetType() == RoomType.ROOM_DEVIL or room:GetType() == RoomType.ROOM_ANGEL)
		then
			TwistedFaithEffect(player)
		end
	end
end

function Trinket.postPEffectUpdate(player)
	if not player:HasTrinket(Enums.Trinkets.TWISTED_FAITH) then return end

	local room = game:GetRoom()
	local trinket0 = player:GetTrinket(0)
	local trinket1 = player:GetTrinket(1)

	if player:IsExtraAnimationFinished()
	and (trinket0 == Enums.Trinkets.TWISTED_FAITH
		or trinket0 == GOLDEN_TWISTED_FAITH
		or trinket1 == Enums.Trinkets.TWISTED_FAITH
		or trinket1 == GOLDEN_TWISTED_FAITH)
	then
		if trinket0 ~= Enums.Trinkets.TWISTED_FAITH
		and trinket0 ~= GOLDEN_TWISTED_FAITH
		and trinket0 ~= 0
		then
			player:TryRemoveTrinket(trinket0)
		end

		if trinket1 ~= Enums.Trinkets.TWISTED_FAITH
		and trinket1 ~= GOLDEN_TWISTED_FAITH
		and trinket1 ~= 0
		then
			player:TryRemoveTrinket(trinket0)
		end

		player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false)

		if trinket0 ~= Enums.Trinkets.TWISTED_FAITH
		and trinket0 ~= GOLDEN_TWISTED_FAITH
		and trinket0 ~= 0
		then
			player:AddTrinket(trinket0, false)
		end

		if trinket1 ~= Enums.Trinkets.TWISTED_FAITH
		and trinket1 ~= GOLDEN_TWISTED_FAITH
		and trinket1 ~= 0
		then
			player:AddTrinket(trinket1, false)
		end
	end

	if room:GetType() ~= RoomType.ROOM_ANGEL then return end
	if player:GetPlayerType() == Enums.Characters.MASTEMA then return end

	local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
	
	for _, j in pairs(items) do
		local collectible = j:ToPickup()
		local maxRedHearts = player:GetEffectiveMaxHearts()
		
		if collectible.SubType > 0 then
			local itemID = collectible.SubType
			local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
			local devilPrice = itemConfig.DevilPrice
			
			--Check every scenario of current health and pickup price
			if collectible.Price ~= 0 then
				if player:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) then
					collectible.Price = PickupPrice.PRICE_SOUL
				elseif player:GetPlayerType() == PlayerType.PLAYER_KEEPER
				or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B
				or player:HasCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH)
				then
					if devilPrice == 2 then
						collectible.Price = math.floor(30 / (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_STEAM_SALE) + 1))
					else
						collectible.Price = 15
					end
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

				collectible.ShopItemId = -1

				if collectible.Price > 15
				or collectible.Price < 0
				or (collectible.Price > 0 and player:HasCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH))
				then
					collectible.AutoUpdatePrice = false
				end
			end
		end
	end
end

return Trinket