local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local SaveData = require("mastema_src.savedata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()
local itemPool = game:GetItemPool()

local horns = Isaac.GetCostumeIdByPath("gfx/characters/character_mastema_horns.anm2")
local bodyCostume = Isaac.GetCostumeIdByPath("gfx/characters/character_mastema_body.anm2")

local Stats = {
	Speed = -0.1,
	Tears = 0.8,
	DMG = -0.2,
	Range = 0,
	ShotSpeed = 0,
	Luck = 0,
}

local Blacklist = {
	Items = {
		CollectibleType.COLLECTIBLE_SANGUINE_BOND,
		CollectibleType.COLLECTIBLE_DUALITY,
		CollectibleType.COLLECTIBLE_POUND_OF_FLESH,
		CollectibleType.COLLECTIBLE_COUPON,
		CollectibleType.COLLECTIBLE_STEAM_SALE,
		CollectibleType.COLLECTIBLE_KEEPERS_SACK,
	},
	Trinkets = {
		TrinketType.TRINKET_DEVILS_CROWN,
		TrinketType.TRINKET_KEEPERS_BARGAIN,
		TrinketType.TRINKET_JUDAS_TONGUE,
		TrinketType.TRINKET_STORE_CREDIT,
	},
}

local Character = {}

local function ChangeTear(tear)
	local variant = {
		[TearVariant.BLUE] = TearVariant.BLOOD,
		[TearVariant.CUPID_BLUE] = TearVariant.CUPID_BLOOD,
		[TearVariant.PUPULA] = TearVariant.PUPULA_BLOOD,
		[TearVariant.GODS_FLESH] = TearVariant.GODS_FLESH_BLOOD,
		[TearVariant.NAIL] = TearVariant.NAIL_BLOOD,
		[TearVariant.GLAUCOMA] = TearVariant.GLAUCOMA_BLOOD,
		[TearVariant.EYE] = TearVariant.EYE_BLOOD,
		[TearVariant.KEY] = TearVariant.KEY_BLOOD,
	}

	if variant[tear.Variant] then
		tear:ChangeVariant(variant[tear.Variant])
	end
end

--Change the price of items to red hearts/spikes. Item prices are based on the item's quality
local function ChangeItemPrices()
	local room = game:GetRoom()
	local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, -1)
	
	for i, j in pairs(items) do
		local pickup = j:ToPickup()
		
		if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
			if pickup.SubType > 0 then
				local itemID = pickup.SubType
				local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
				local quality = itemConfig.Quality
			
				if (pickup.Price >= 0 and (room:GetType() == RoomType.ROOM_ANGEL or room:GetType() == RoomType.ROOM_LIBRARY or room:GetType() == RoomType.ROOM_SECRET or room:GetType() == RoomType.ROOM_ULTRASECRET))
				or (pickup.Price ~= 0 and room:GetType() == RoomType.ROOM_SHOP)
				or (pickup.Price < 0 and (room:GetType() == RoomType.ROOM_TREASURE or room:GetType() == RoomType.ROOM_DEVIL or room:GetType() == RoomType.ROOM_BLACK_MARKET))
				then
					if itemConfig.Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST then
						if quality > 2 then
							pickup.Price = PickupPrice.PRICE_TWO_HEARTS
						else
							pickup.Price = PickupPrice.PRICE_ONE_HEART
						end
					end
				end
			end
		else
			if pickup.Price > 0 then
				pickup.Price = PickupPrice.PRICE_SPIKES
			end
		end
		
		if room:GetType() ~= RoomType.ROOM_SHOP then
			pickup.ShopItemId = -1
		end
		
		pickup.AutoUpdatePrice = false
	end
end

--Used to update heart prices based on Mastema's current health
local function UpdateItemPrices(player)
	local room = game:GetRoom()
	local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, -1)
	local maxRedHearts = player:GetEffectiveMaxHearts()
	
	for i, j in pairs(items) do
		local pickup = j:ToPickup()
		
		if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
			if pickup.SubType > 0 then
				local itemID = pickup.SubType
				local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
				local quality = itemConfig.Quality
				
				--Check every scenario of current health and pickup price
				if pickup.Price ~= 0
				and itemConfig.Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST
				and (not pickup:GetData().cyclePrice or pickup:GetData().cyclePrice == nil)
				then
					if player:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) then
						pickup.Price = PickupPrice.PRICE_SOUL
					elseif maxRedHearts > 0 then
						if quality > 2 then
							if maxRedHearts >= 4 then
								pickup.Price = PickupPrice.PRICE_TWO_HEARTS
							else
								pickup.Price = PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS
							end
						else
							pickup.Price = PickupPrice.PRICE_ONE_HEART
						end
					else
						if quality > 2 then
							pickup.Price = PickupPrice.PRICE_THREE_SOULHEARTS
						elseif quality == 2 then
							pickup.Price = PickupPrice.PRICE_TWO_SOUL_HEARTS
						else
							pickup.Price = PickupPrice.PRICE_ONE_SOUL_HEART
						end
					end
					
					if room:GetType() ~= RoomType.ROOM_SHOP then
						pickup.ShopItemId = -1
					end
					
					pickup.AutoUpdatePrice = false
				end
			end
		else
			if pickup.Price > 0 then
				if room:GetType() ~= RoomType.ROOM_SHOP then
					pickup.ShopItemId = -1
				end
				
				pickup.Price = PickupPrice.PRICE_SPIKES
				pickup.AutoUpdatePrice = false
			end
		end
	end
end

--Cycles heart prices when Mastema has Birthright
local function AlternateItemPrices(player)
	local room = game:GetRoom()
	local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
	local maxRedHearts = player:GetEffectiveMaxHearts()
	local soulHearts = player:GetSoulHearts()
	
	for i, j in pairs(items) do
		local collectible = j:ToPickup()
		
		if collectible.SubType > 0
		and collectible.Price < 0
		and collectible.Price ~= PickupPrice.PRICE_SOUL
		then
			local itemID = collectible.SubType
			local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
			local quality = itemConfig.Quality
			local prevPrice = collectible.Price
			local newPrice
			
			if quality > 2 then
				if (collectible.Price == PickupPrice.PRICE_THREE_SOULHEARTS and maxRedHearts > 2)
				or (collectible.Price == PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS and maxRedHearts > 2 and soulHearts < 6)
				then
					collectible.Price = PickupPrice.PRICE_TWO_HEARTS
				elseif collectible.Price ~= PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS
				and maxRedHearts >= 2
				and soulHearts >= 4
				then
					collectible.Price = PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS
				elseif collectible.Price ~= PickupPrice.PRICE_THREE_SOULHEARTS
				and soulHearts >= 6
				then
					collectible.Price = PickupPrice.PRICE_THREE_SOULHEARTS
				end
			elseif quality == 2 then
				if collectible.Price ~= PickupPrice.PRICE_ONE_HEART
				and maxRedHearts > 0
				then
					collectible.Price = PickupPrice.PRICE_ONE_HEART
				elseif collectible.Price ~= PickupPrice.PRICE_TWO_SOUL_HEARTS
				and soulHearts >= 4
				then
					collectible.Price = PickupPrice.PRICE_TWO_SOUL_HEARTS
				end
			else
				if collectible.Price ~= PickupPrice.PRICE_ONE_HEART
				and maxRedHearts > 0
				then
					collectible.Price = PickupPrice.PRICE_ONE_HEART
				elseif collectible.Price ~= PickupPrice.PRICE_ONE_SOUL_HEART
				and soulHearts >= 2
				then
					collectible.Price = PickupPrice.PRICE_ONE_SOUL_HEART
				end
			end
			
			if room:GetType() ~= RoomType.ROOM_SHOP then
				collectible.ShopItemId = -1
			end

			collectible.AutoUpdatePrice = false
			newPrice = collectible.Price

			if newPrice == prevPrice then
				collectible:GetData().cyclePrice = false
			else
				collectible:GetData().cyclePrice = true
			end
		end
	end
end

--Rooms where item prices should be updated
local function IsValidRoom()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomIndex = level:GetCurrentRoomIndex()
	local startRoomIndex = level:GetStartingRoomIndex()

	if room:GetType() == RoomType.ROOM_SHOP
	or room:GetType() == RoomType.ROOM_TREASURE
	or room:GetType() == RoomType.ROOM_DEVIL
	or room:GetType() == RoomType.ROOM_ANGEL
	or room:GetType() == RoomType.ROOM_LIBRARY
	or room:GetType() == RoomType.ROOM_SECRET
	or room:GetType() == RoomType.ROOM_BLACK_MARKET
	or room:GetType() == RoomType.ROOM_ULTRASECRET
	or (level:GetStage() == LevelStage.STAGE6 and roomIndex == startRoomIndex)
	then
		return true
	else
		return false
	end
end

local function AnyItemCostsHP()
	local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, -1)

	if #items == 0 then return false end

	for _, item in pairs(items) do
		local pickup = item:ToPickup()

		if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
			if (pickup.Price < 0 and pickup.Price > PickupPrice.PRICE_SPIKES)
			or (pickup.Price < PickupPrice.PRICE_SOUL and pickup.Price >= PickupPrice.PRICE_TWO_SOUL_HEARTS)
			then
				return true
			end
		else
			if pickup.Price == PickupPrice.PRICE_SPIKES then
				return true
			end
		end
	end

	return false
end

function Character.evaluateCache(player, cacheFlag)
	if player:GetPlayerType() ~= Enums.Characters.MASTEMA then return end
	
	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
			player.Damage = player.Damage + (Stats.DMG * 0.2)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
			player.Damage = player.Damage + (Stats.DMG * 0.3)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
			player.Damage = player.Damage + (Stats.DMG * 0.8)
		else
			player.Damage = player.Damage + Stats.DMG
		end
	end
	if cacheFlag == CacheFlag.CACHE_FIREDELAY then
		player.MaxFireDelay = Functions.TearsUp(player.MaxFireDelay, Stats.Tears)
	end
	if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
		player.ShotSpeed = player.ShotSpeed + Stats.ShotSpeed
	end
	if cacheFlag == CacheFlag.CACHE_RANGE then
		player.TearRange = player.TearRange + Stats.Range
	end
	if cacheFlag == CacheFlag.CACHE_SPEED then
		player.MoveSpeed = player.MoveSpeed + Stats.Speed
	end
	if cacheFlag == CacheFlag.CACHE_LUCK then
		player.Luck = player.Luck + Stats.Luck
	end

	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
				player.Damage = player.Damage + (0.5 * SaveData.PlayerData.Mastema.Birthright.DMG * 0.2)
			elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
				player.Damage = player.Damage + (0.5 * SaveData.PlayerData.Mastema.Birthright.DMG * 0.3)
			elseif player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
				player.Damage = player.Damage + (0.5 * SaveData.PlayerData.Mastema.Birthright.DMG * 0.8)
			else
				player.Damage = player.Damage + (0.5 * SaveData.PlayerData.Mastema.Birthright.DMG)
			end
		end
		
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = Functions.TearsUp(player.MaxFireDelay, 0.25 * SaveData.PlayerData.Mastema.Birthright.Tears)
		end
		
		if cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + (0.1 * SaveData.PlayerData.Mastema.Birthright.Speed)
		end
		
		if cacheFlag == CacheFlag.CACHE_RANGE then
			player.TearRange = player.TearRange + (16 * SaveData.PlayerData.Mastema.Birthright.Range)
		end
		
		if cacheFlag == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + (0.5 * SaveData.PlayerData.Mastema.Birthright.Luck)
		end
	end
end

function Character.postPlayerInit(player)
	if game:GetFrameCount() > 0 then return end
	if player:GetPlayerType() ~= Enums.Characters.MASTEMA then return end
	
	for i = 1, #Blacklist.Items do
		itemPool:RemoveCollectible(Blacklist.Items[i])
	end
	for i = 1, #Blacklist.Trinkets do
		itemPool:RemoveTrinket(Blacklist.Trinkets[i])
	end
	
	player:AddNullCostume(horns)
	player:AddNullCostume(bodyCostume)
end

function Character.postNewRoom()
	local room = game:GetRoom()
	rng:SetSeed(room:GetDecorationSeed(), 35)
	local level = game:GetLevel()
	local stageType = level:GetStageType()
	local roomIndex = level:GetCurrentRoomIndex()
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:GetPlayerType() ~= Enums.Characters.MASTEMA then return end
		
		--Blind item in normal path
		if room:GetType() == RoomType.ROOM_TREASURE
		and stageType ~= StageType.STAGETYPE_REPENTANCE
		and stageType ~= StageType.STAGETYPE_REPENTANCE_B
		and level:GetStage() ~= LevelStage.STAGE4_3
		and not game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH)
		then
			local pedestals = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)

			if #pedestals > 0 then
				for i = 1, #pedestals do
					local collectible = pedestals[i]

					if i == 2 then
						local blindSprite = collectible:GetSprite()
						blindSprite:ReplaceSpritesheet(1,"gfx/items/collectibles/questionmark.png")
						blindSprite:ReplaceSpritesheet(0,"gfx/items/collectibles/questionmark.png")
						blindSprite:LoadGraphics()
						SaveData.PlayerData.Mastema.BlindItem = pedestals[i]
					end
				end
			end
		end

		if room:IsFirstVisit()
		and IsValidRoom()
		then
			if room:GetType() == RoomType.ROOM_TREASURE
			and (not game:IsGreedMode() or (game:IsGreedMode() and roomIndex ~= 98))
			then
				local pool = ItemPoolType.POOL_TREASURE
				local seed = game:GetSeeds():GetStartSeed()
				local pedestals = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
				local rng = player:GetTrinketRNG(TrinketType.TRINKET_DEVILS_CROWN)

				--Extra item when you have More Options for real
				if player:HasCollectible(CollectibleType.COLLECTIBLE_MORE_OPTIONS, true)
				and stageType ~= StageType.STAGETYPE_REPENTANCE
				and stageType ~= StageType.STAGETYPE_REPENTANCE_B
				then
					local pos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0)
					local itemID = itemPool:GetCollectible(pool, true, seed)
					local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, pos, Vector.Zero, nil)
					local collectible = item:ToPickup()
					collectible.Price = PickupPrice.PRICE_ONE_HEART
				end

				if #pedestals > 0 then
					for i = 1, #pedestals do
						local collectible = pedestals[i]
						
						if i == 2
						and stageType ~= StageType.STAGETYPE_REPENTANCE
						and stageType ~= StageType.STAGETYPE_REPENTANCE_B
						and level:GetStage() ~= LevelStage.STAGE4_3
						and not game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH)
						then
							local blindSprite = collectible:GetSprite()
							blindSprite:ReplaceSpritesheet(1,"gfx/items/collectibles/questionmark.png")
							blindSprite:ReplaceSpritesheet(0,"gfx/items/collectibles/questionmark.png")
							blindSprite:LoadGraphics()
							SaveData.PlayerData.Mastema.BlindItem = pedestals[i]
						end
					end
				end
			end
			ChangeItemPrices()
		end

		--Update prices more smoothly
		if IsValidRoom() then
			UpdateItemPrices(player)
		end

		--No white fire exploit
		if (stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B)
		and (level:GetStage() == LevelStage.STAGE1_1 or level:GetStage() == LevelStage.STAGE1_2)
		and not room:IsMirrorWorld()
		and player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE)
		and IsValidRoom()
		and AnyItemCostsHP()
		then
			player:GetEffects():RemoveNullEffect(NullItemID.ID_LOST_CURSE, -1)
		end

		if level:GetCurrentRoomIndex() == GridRooms.ROOM_GENESIS_IDX then
			player:AddNullCostume(horns)
			player:AddNullCostume(bodyCostume)
		end
	end
end

function Character.postNewLevel()
	local level = game:GetLevel()
	local stageType = level:GetStageType()
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:GetPlayerType() ~= Enums.Characters.MASTEMA then return end

		SaveData.PlayerData.Mastema.BlindItem = 0

		if stageType == StageType.STAGETYPE_REPENTANCE
		or stageType == StageType.STAGETYPE_REPENTANCE_B
		then
			if Functions.HasInnateItem(CollectibleType.COLLECTIBLE_MORE_OPTIONS) then
				Functions.RemoveInnateItem(CollectibleType.COLLECTIBLE_MORE_OPTIONS)
			end
		else
			if not Functions.HasInnateItem(CollectibleType.COLLECTIBLE_MORE_OPTIONS) then
				Functions.AddInnateItem(player, CollectibleType.COLLECTIBLE_MORE_OPTIONS, true)
			end
		end
	end
end

function Character.preGetCollectible(pool, decrease, seed)
	if not Functions.AnyPlayerIsType(Enums.Characters.MASTEMA) then return end
	if pool == ItemPoolType.POOL_TREASURE then return end
	if pool == ItemPoolType.POOL_GREED_BOSS then return end
	
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomIndex = level:GetCurrentRoomIndex()
	
	if room:GetType() ~= RoomType.ROOM_TREASURE then return end
	if game:IsGreedMode() and roomIndex == 98 then return end

	rng:SetSeed(seed, 35)
	local randNum = rng:RandomInt(2)
	
	if randNum == 0 then
		local itemID = game:GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, true, seed)
		return itemID
	end
end

function Character.postTearInit(tear)
	if tear.SpawnerEntity == nil then return end
	if tear.SpawnerEntity.Type ~= EntityType.ENTITY_FAMILIAR then return end
	if tear.SpawnerEntity.Variant ~= FamiliarVariant.ITEM_WISP then return end
	if tear.SpawnerEntity:GetData().mastemaWisp == nil then return end

	tear:Remove()
end

function Character.postFireTear(tear)
	if tear.SpawnerEntity == nil then return end
	
	local player = tear.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.MASTEMA then return end

	ChangeTear(tear)
end

function Character.postTearUpdate(tear)
	if tear.SpawnerEntity == nil then return end
	
	local player = tear.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.MASTEMA then return end
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then return end
	if player:HasCollectible(Enums.Collectibles.SINISTER_SIGHT) then return end
	
	--Fix Ludo tear not being a blood tear
	ChangeTear(tear)
end

function Character.postPickupInit(pickup)
	rng:SetSeed(pickup.InitSeed, 35)
	local room = game:GetRoom()

	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:GetPlayerType() ~= Enums.Characters.MASTEMA then return end

		if pickup.Variant == PickupVariant.PICKUP_TRINKET
		and (pickup.SubType == TrinketType.TRINKET_DEVILS_CROWN or pickup.SubType == (TrinketType.TRINKET_DEVILS_CROWN + TrinketType.TRINKET_GOLDEN_FLAG))
		then
			pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, true, false, false)
		end

		--Eternal hearts can spawn instead of coins for Mastema in greed mode
		if pickup.Variant == PickupVariant.PICKUP_COIN
		and game:IsGreedMode()
		and room:GetType() == RoomType.ROOM_DEFAULT
		and not room:IsClear()
		then
			local randNum = rng:RandomInt(20)
			
			if randNum < 3 then
				pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ETERNAL, true, false, false)
			end
		end

		--Fix an exploit with restocked batteries and Car Battery
		if pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY
		and pickup.SubType ~= BatterySubType.BATTERY_MICRO
		and room:GetType() == RoomType.ROOM_SHOP
		and player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY)
		and (game:IsGreedMode() or player:HasCollectible(CollectibleType.COLLECTIBLE_RESTOCK))
		then
			pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_MICRO, true, false, false)
		end
	end
end

function Character.prePickupCollision(pickup, collider, low)
	if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
	if pickup.SubType == 0 then return end
	
	local player = collider:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.MASTEMA then return end
	if not Functions.CanPickUpItem(player, pickup) then return end

	local room = game:GetRoom()
	local level = game:GetLevel()

	--Holy mantle shield for buying an item in angel rooms
	if room:GetType() == RoomType.ROOM_ANGEL
	and level:GetCurrentRoomIndex() ~= GridRooms.ROOM_ANGEL_SHOP_IDX
	and pickup.Price < 0
	then
		player:UseCard(Card.CARD_HOLY, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
		sfx:Play(SoundEffect.SOUND_DIVINE_INTERVENTION, 1.3, 2, false, 1.2)
	end

	--Birthright effect
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
		local birthrightStats = {
			"DMG",
			"Tears",
			"Speed",
			"Range",
			"Luck",
		}
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		local randNum
		
		if pickup.Price == PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS
		or pickup.Price == PickupPrice.PRICE_THREE_SOULHEARTS
		then
			for i = 1, 3 do 
				randNum = rng:RandomInt(#birthrightStats) + 1
				SaveData.PlayerData.Mastema.Birthright[birthrightStats[randNum]] = SaveData.PlayerData.Mastema.Birthright[birthrightStats[randNum]] + 1
			end
		elseif pickup.Price == PickupPrice.PRICE_TWO_HEARTS
		or pickup.Price == PickupPrice.PRICE_TWO_SOUL_HEARTS
		or pickup.Price == PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART
		then
			for i = 1, 2 do 
				randNum = rng:RandomInt(#birthrightStats) + 1
				SaveData.PlayerData.Mastema.Birthright[birthrightStats[randNum]] = SaveData.PlayerData.Mastema.Birthright[birthrightStats[randNum]] + 1
			end
		elseif pickup.Price == PickupPrice.PRICE_ONE_HEART
		or pickup.Price == PickupPrice.PRICE_ONE_SOUL_HEART
		then
			randNum = rng:RandomInt(#birthrightStats) + 1
			SaveData.PlayerData.Mastema.Birthright[birthrightStats[randNum]] = SaveData.PlayerData.Mastema.Birthright[birthrightStats[randNum]] + 1
		end
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_RANGE | CacheFlag.CACHE_LUCK)
		player:EvaluateItems()
	end
end

function Character.familiarUpdate(familiar)
	if familiar.Variant ~= FamiliarVariant.ITEM_WISP then return end

	local player = familiar.Player

	if player:GetPlayerType() ~= Enums.Characters.MASTEMA then return end

	if (familiar.SubType == CollectibleType.COLLECTIBLE_MORE_OPTIONS or familiar.SubType == CollectibleType.COLLECTIBLE_DUALITY)
	and familiar.Visible
	then
		if familiar.SubType == CollectibleType.COLLECTIBLE_MORE_OPTIONS then
			local moreOptions = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_MORE_OPTIONS)
			player:RemoveCostume(moreOptions)
		end

		if familiar.SubType == CollectibleType.COLLECTIBLE_DUALITY then
			local duality = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_DUALITY)
			player:RemoveCostume(duality)
		end

		familiar:RemoveFromOrbit()
		familiar:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		familiar.Visible = false
		familiar.CollisionDamage = 0
		familiar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		familiar:GetData().mastemaWisp = true
	end
end

function Character.postPEffectUpdate(player)
	if player:GetPlayerType() ~= Enums.Characters.MASTEMA then return end

	if not player:HasCurseMistEffect()
	and not player:IsCoopGhost()
	then
		if not player:HasTrinket(TrinketType.TRINKET_DEVILS_CROWN, false) then
			player:AddTrinket(TrinketType.TRINKET_DEVILS_CROWN)
			player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false)
		end

		if not Functions.HasInnateItem(CollectibleType.COLLECTIBLE_DUALITY) then
			Functions.AddInnateItem(player, CollectibleType.COLLECTIBLE_DUALITY, true)
		end
	end

	--Update heart prices
	if IsValidRoom() then
		UpdateItemPrices(player)
	end
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
	and game:GetFrameCount() % 30 == 0
	then
		AlternateItemPrices(player)
	end

	if Eterepheartsforeternaltransformation then
		Eterepheartsforeternaltransformation = 0
	end
end

function Character.postPlayerUpdate(player)
	if player:GetPlayerType() ~= Enums.Characters.MASTEMA then return end
	if game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH) then return end

	local room = game:GetRoom()
	local level = game:GetLevel()
	local stageType = level:GetStageType()

	if room:GetType() ~= RoomType.ROOM_TREASURE then return end
	if stageType == StageType.STAGETYPE_REPENTANCE then return end
	if stageType == StageType.STAGETYPE_REPENTANCE_B then return end
	if level:GetStage() == LevelStage.STAGE4_3 then return end

	--Prevent rerolling from revealing the blind item
	local pedestals = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)

	if #pedestals == 0 then return end
	
	for i = 1, #pedestals do
		local collectible = pedestals[i]
		local item = collectible:ToPickup()

		if SaveData.PlayerData.Mastema.BlindItem ~= 0
		and item.SubType > 0
		and item.SubType == SaveData.PlayerData.Mastema.BlindItem.SubType
		then
			local blindSprite = collectible:GetSprite()
			blindSprite:ReplaceSpritesheet(1,"gfx/items/collectibles/questionmark.png")
			blindSprite:ReplaceSpritesheet(0,"gfx/items/collectibles/questionmark.png")
			blindSprite:LoadGraphics()
		end
	end
end

function Character.preUseItem(item, rng, player, flags, activeSlot, customVarData)
	if player:GetPlayerType() ~= Enums.Characters.MASTEMA then return end
	
	local level = game:GetLevel()

	if item == CollectibleType.COLLECTIBLE_CLICKER then
		player:TryRemoveNullCostume(horns)
		player:TryRemoveNullCostume(bodyCostume)
	end

	if item == CollectibleType.COLLECTIBLE_PRAYER_CARD
	and (level:GetStage() > LevelStage.STAGE3_2 or game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH))
	and not game:IsGreedMode()
	then
		player:AnimateCollectible(CollectibleType.COLLECTIBLE_PRAYER_CARD, "UseItem", "PlayerPickupSparkle")
		player:AddSoulHearts(1)
		return true
	end
end

function Character.useItem(item, rng, player, flags, activeSlot, customVarData)
	if player:GetPlayerType() ~= Enums.Characters.MASTEMA then return end

	local level = game:GetLevel()
	local stageType = level:GetStageType()

	if item == CollectibleType.COLLECTIBLE_D4
	or item == CollectibleType.COLLECTIBLE_D100
	then
		player:AddNullCostume(horns)
		player:AddNullCostume(bodyCostume)
	end

	if item == CollectibleType.COLLECTIBLE_SACRIFICIAL_ALTAR
	and stageType ~= StageType.STAGETYPE_REPENTANCE
	and stageType ~= StageType.STAGETYPE_REPENTANCE_B
	then
		Functions.AddInnateItem(player, CollectibleType.COLLECTIBLE_MORE_OPTIONS, true)
	end
end

return Character