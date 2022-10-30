local Enums = require("mastema_src.enums")
local SaveData = require("mastema_src.savedata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local pools = {
	ItemPoolType.POOL_TREASURE,
	ItemPoolType.POOL_SHOP,
	ItemPoolType.POOL_BOSS,
	ItemPoolType.POOL_DEVIL,
	ItemPoolType.POOL_ANGEL,
	ItemPoolType.POOL_SECRET,
	ItemPoolType.POOL_PLANETARIUM,
}

local Item = {}

function Item.preSpawnCleanAward()
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local spawnpos = Isaac.GetFreeNearPosition(player.Position, 40)
		
		if not player:HasCollectible(Enums.Collectibles.BOOK_OF_JUBILEES) then return end
		
		SaveData.ItemData.BookOfJubilees.Count = SaveData.ItemData.BookOfJubilees.Count + 1
		SaveData.ItemData.BookOfJubilees.Count7x7 = SaveData.ItemData.BookOfJubilees.Count7x7 + 1
		SaveData.ItemData.BookOfJubilees.Count7x7x7 = SaveData.ItemData.BookOfJubilees.Count7x7x7 + 1
		
		if SaveData.ItemData.BookOfJubilees.Count7x7x7 == 343 then --Spawn 7 items, 1 from each pool. You'll never clear enough rooms in a run for this >:)
			for i = 1, #pools do
				local item = game:GetItemPool():GetCollectible(pools[i], true, game:GetSeeds():GetStartSeed())
				spawnpos = Isaac.GetFreeNearPosition(player.Position, 40)
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item, spawnpos, Vector.Zero, nil)
			end
			sfx:Play(SoundEffect.SOUND_SUPERHOLY)
			SaveData.ItemData.BookOfJubilees.Count = 0
			SaveData.ItemData.BookOfJubilees.Count7x7 = 0
			SaveData.ItemData.BookOfJubilees.Count7x7x7 = 0
		elseif SaveData.ItemData.BookOfJubilees.Count7x7 == 49 then --Grant the effect of sleeping in a bed
			if player:HasFullHearts() then
				player:AddSoulHearts(6)
			else
				player:SetFullHearts()
			end
			game:GetHUD():ShowItemText("You feel refreshed!")
			sfx:Play(SoundEffect.SOUND_POWERUP1)
			player:AnimateHappy()
			SaveData.ItemData.BookOfJubilees.Count = 0
			SaveData.ItemData.BookOfJubilees.Count7x7 = 0
		elseif SaveData.ItemData.BookOfJubilees.Count == 7 then
			local rng = player:GetCollectibleRNG(Enums.Collectibles.BOOK_OF_JUBILEES)
			local randNum = rng:RandomInt(100)
			
			if randNum < 15 then --Give holy mantle shield
				if not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
				and not player:HasCollectible(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
				then
					player:UseCard(Card.CARD_HOLY, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
				else
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, spawnpos, Vector.Zero, nil)
				end
			elseif randNum < 35 then --Spawn random high quality heart
				local hearts = {
					HeartSubType.HEART_SOUL,
					HeartSubType.HEART_ETERNAL,
					HeartSubType.HEART_BLACK,
					HeartSubType.HEART_BONE,
				}
				randNum = rng:RandomInt(#hearts) + 1
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, hearts[randNum], spawnpos, Vector.Zero, nil)
			elseif randNum < 55 then --Spawn random high quality coin
				local coins = {
					CoinSubType.COIN_DIME,
					CoinSubType.COIN_LUCKYPENNY,
					CoinSubType.COIN_GOLDEN,
				}
				randNum = rng:RandomInt(#coins) + 1
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, coins[randNum], spawnpos, Vector.Zero, nil)
			elseif randNum < 75 then --Spawn random heart
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0, spawnpos, Vector.Zero, nil)
			else --Spawn 7 pennies
				for i = 1, 7 do
					spawnpos = Isaac.GetFreeNearPosition(player.Position, 40)
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, spawnpos, Vector.Zero, nil)
				end
			end
			sfx:Play(SoundEffect.SOUND_HOLY, 1, 2, false, 1.1)
			SaveData.ItemData.BookOfJubilees.Count = 0
		end
	end
end

return Item