local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local SaveData = require("mastema_src.savedata")
local game = Game()
local sfx = SFXManager()

local Trinket = {}

function Trinket.postNewRoom()
	local room = game:GetRoom()
	
	if room:GetType() ~= RoomType.ROOM_DEVIL then return end
	if not room:IsFirstVisit() then return end

	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasTrinket(Enums.Trinkets.SHATTERED_SOUL) then
			local rng = player:GetTrinketRNG(Enums.Trinkets.SHATTERED_SOUL)
			local seed = game:GetSeeds():GetStartSeed()
			local pool = ItemPoolType.POOL_DEVIL
			local spawnpos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0)
			
			if Functions.AnyPlayerIsType(Enums.Characters.MASTEMA)
			or Functions.AnyPlayerIsType(Enums.Characters.T_MASTEMA)
			then
				spawnpos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
			end

			if player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) then
				pool = rng:RandomInt(ItemPoolType.NUM_ITEMPOOLS)
				seed = rng:RandomInt(999999999)
			end
			
			SaveData.ItemData.ShatteredSoul.DealItems = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
			local brokenItemID = game:GetItemPool():GetCollectible(pool, true, seed)
			SaveData.ItemData.ShatteredSoul.BrokenItem = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, brokenItemID, spawnpos, Vector.Zero, nil)
		end
	end
end

function Trinket.postNewLevel()
	if SaveData.ItemData.ShatteredSoul.BrokenItem ~= 0 then
		SaveData.ItemData.ShatteredSoul.BrokenItem = 0
	end
end

function Trinket.entityTakeDmg(target, amount, flag, source, countdown)
	local player = target:ToPlayer()

	if player == nil then return end
	if not player:HasTrinket(Enums.Trinkets.SHATTERED_SOUL) then return end
	if flag & DamageFlag.DAMAGE_SPIKES ~= DamageFlag.DAMAGE_SPIKES then return end

	local room = game:GetRoom()

	if room:GetType() ~= RoomType.ROOM_SACRIFICE then return end

	local numBrokenHearts = player:GetBrokenHearts()

	if numBrokenHearts > 0 then
		player:AddBrokenHearts(-numBrokenHearts)
		sfx:Play(SoundEffect.SOUND_THUMBSUP)
		sfx:Play(SoundEffect.SOUND_DEATH_CARD)
	end
	
	player:TryRemoveTrinket(Enums.Trinkets.SHATTERED_SOUL)
	player:TryRemoveTrinket(Enums.Trinkets.SHATTERED_SOUL + TrinketType.TRINKET_GOLDEN_FLAG)
end

function Trinket.prePickupCollision(pickup, collider, low)
	if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
	if pickup.SubType == 0 then return end
	if SaveData.ItemData.ShatteredSoul.BrokenItem == 0 then return end
	
	local player = collider:ToPlayer()

	if player == nil then return end
	if not player:HasTrinket(Enums.Trinkets.SHATTERED_SOUL) then return end
	if player:IsCoopGhost() then return end
	if not Functions.CanPickUpItem(player, pickup) then return end

	local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.SHATTERED_SOUL)
	local reducePrice = 0
	local itemID = pickup.SubType
	local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
	local quality = itemConfig.Quality
	
	if trinketMultiplier > 1 then
		reducePrice = 1
	end
	
	if itemID == SaveData.ItemData.ShatteredSoul.BrokenItem.SubType
	and pickup.Position:Distance(SaveData.ItemData.ShatteredSoul.BrokenItem.Position) < 1
	then
		if quality > 2 then
			player:AddBrokenHearts(4 - reducePrice)
		else
			player:AddBrokenHearts(2 - reducePrice)
		end

		if #SaveData.ItemData.ShatteredSoul.DealItems > 0 then
			for i = 1, #SaveData.ItemData.ShatteredSoul.DealItems do
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, SaveData.ItemData.ShatteredSoul.DealItems[i].Position, Vector.Zero, SaveData.ItemData.ShatteredSoul.DealItems[i])
				SaveData.ItemData.ShatteredSoul.DealItems[i]:Remove()
			end
		end
		SaveData.ItemData.ShatteredSoul.BrokenItem = 0
	else
		if #SaveData.ItemData.ShatteredSoul.DealItems > 0 then
			for i = 1, #SaveData.ItemData.ShatteredSoul.DealItems do
				if itemID == SaveData.ItemData.ShatteredSoul.DealItems[i].SubType
				and pickup.Position:Distance(SaveData.ItemData.ShatteredSoul.DealItems[i].Position) < 1
				then
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, SaveData.ItemData.ShatteredSoul.BrokenItem.Position, Vector.Zero, SaveData.ItemData.ShatteredSoul.BrokenItem)
					SaveData.ItemData.ShatteredSoul.BrokenItem:Remove()
					SaveData.ItemData.ShatteredSoul.BrokenItem = 0
				end
			end
		end
	end
end

function Trinket.postRender()
	local room = game:GetRoom()
	
	if room:GetType() ~= RoomType.ROOM_DEVIL then return end
	if room:GetFrameCount() == 0 then return end
	if SaveData.ItemData.ShatteredSoul.BrokenItem == 0 then return end

	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
		local renderCount
		
		for _, j in pairs(items) do
			if j.SubType > 0 then
				local collectible = j:ToPickup()
				local itemID = collectible.SubType
				local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
				local quality = itemConfig.Quality
				local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.SHATTERED_SOUL)
				local reducePrice = 0
				
				if trinketMultiplier > 1 then
					reducePrice = 1
				end
				
				if itemID == SaveData.ItemData.ShatteredSoul.BrokenItem.SubType
				and collectible.Position:Distance(SaveData.ItemData.ShatteredSoul.BrokenItem.Position) < 1
				then
					if quality > 2 then
						renderCount = 4 - reducePrice
					else
						renderCount = 2 - reducePrice
					end
					Functions.RenderBrokenCost(collectible, renderCount)
				end
			end
		end
	end
end

return Trinket