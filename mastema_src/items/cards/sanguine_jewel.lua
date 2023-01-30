local Enums = require("mastema_src.enums")
local SaveData = require("mastema_src.savedata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local Consumable = {}

function Consumable.evaluateCache(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
			player.Damage = player.Damage + (0.5 * SaveData.ItemData.SanguineJewel.DMG * 0.2)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
			player.Damage = player.Damage + (0.5 * SaveData.ItemData.SanguineJewel.DMG * 0.3)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
			player.Damage = player.Damage + (0.5 * SaveData.ItemData.SanguineJewel.DMG * 0.8)
		else
			player.Damage = player.Damage + (0.5 * SaveData.ItemData.SanguineJewel.DMG)
		end
	end
	
	if cacheFlag == CacheFlag.CACHE_FLYING
	and not player:HasCollectible(Enums.Collectibles.TORN_WINGS)
	and SaveData.ItemData.SanguineJewel.Leviathan
	then
		player.CanFly = true
	end
end

function Consumable.useCard(card, player, flag)
	if card ~= Enums.Cards.SANGUINE_JEWEL then return end

	local rng = player:GetCardRNG(Enums.Cards.SANGUINE_JEWEL)
	local randNum = rng:RandomInt(100)

	player:ResetDamageCooldown()
	player:TakeDamage(2, DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_INVINCIBLE, EntityRef(player), 0)
	
	if flag & UseFlag.USE_MIMIC ~= UseFlag.USE_MIMIC then
		player:AnimateCard(Enums.Cards.SANGUINE_JEWEL, "UseItem")
	end

	if randNum < 2 then
		if not player:HasPlayerForm(PlayerForm.PLAYERFORM_EVIL_ANGEL)
		and not SaveData.ItemData.SanguineJewel.Leviathan
		then
			SaveData.ItemData.SanguineJewel.Leviathan = true
			game:GetHUD():ShowItemText("Leviathan!")
			sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER)
			player:AddPlayerFormCostume(PlayerForm.PLAYERFORM_EVIL_ANGEL)
			player:AddBlackHearts(4)
			player:AddCacheFlags(CacheFlag.CACHE_FLYING)
			player:EvaluateItems()
		else
			for i = 1, 2 do
				local pos = Isaac.GetFreeNearPosition(player.Position, 40)
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, pos, Vector.Zero, nil)
			end
		end
	elseif randNum < 7 then
		local itemPool = game:GetItemPool()
		local itemID = itemPool:GetCollectible(ItemPoolType.POOL_DEVIL, true, game:GetSeeds():GetStartSeed())
		local pos = Isaac.GetFreeNearPosition(player.Position, 40)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, pos, Vector.Zero, nil)
	elseif randNum < 17 then
		for i = 1, 2 do
			local pos = Isaac.GetFreeNearPosition(player.Position, 40)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, pos, Vector.Zero, nil)
		end
	elseif randNum < 32 then
		for i = 1, 6 do
			local pos = Isaac.GetFreeNearPosition(player.Position, 40)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, pos, Vector.Zero, nil)
		end
	elseif randNum < 65 then
		SaveData.ItemData.SanguineJewel.DMG = SaveData.ItemData.SanguineJewel.DMG + 1
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:EvaluateItems()
	end
end

return Consumable