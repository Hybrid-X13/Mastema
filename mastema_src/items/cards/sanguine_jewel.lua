local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local game = Game()
local rng = RNG()

local Consumable = {}

local transformationMap = {
	[PlayerForm.PLAYERFORM_GUPPY] = CollectibleType.COLLECTIBLE_GUPPYS_TAIL,
	[PlayerForm.PLAYERFORM_LORD_OF_THE_FLIES] = CollectibleType.COLLECTIBLE_MULLIGAN,
	[PlayerForm.PLAYERFORM_MUSHROOM] = CollectibleType.COLLECTIBLE_GODS_FLESH,
	[PlayerForm.PLAYERFORM_ANGEL] = CollectibleType.COLLECTIBLE_MITRE,
	[PlayerForm.PLAYERFORM_BOB] = CollectibleType.COLLECTIBLE_IPECAC,
	[PlayerForm.PLAYERFORM_DRUGS] = CollectibleType.COLLECTIBLE_VIRUS,
	[PlayerForm.PLAYERFORM_MOM] = CollectibleType.COLLECTIBLE_MOMS_EYE,
	[PlayerForm.PLAYERFORM_BABY] = CollectibleType.COLLECTIBLE_BROTHER_BOBBY,
	[PlayerForm.PLAYERFORM_EVIL_ANGEL] = CollectibleType.COLLECTIBLE_BRIMSTONE,
	[PlayerForm.PLAYERFORM_POOP] = CollectibleType.COLLECTIBLE_E_COLI,
	[PlayerForm.PLAYERFORM_BOOK_WORM] = CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES,
	[PlayerForm.PLAYERFORM_SPIDERBABY] = CollectibleType.COLLECTIBLE_SPIDER_BITE,
}

local function AddTransformation(player, transformation)
	if transformationMap[transformation] == nil then return end

	for i = 1, 3 do
		player:AddCollectible(transformationMap[transformation])
		player:RemoveCollectible(transformationMap[transformation], true, 0, false)
	end
end

function Consumable.evaluateCache(player, cacheFlag)
	if cacheFlag ~= CacheFlag.CACHE_DAMAGE then return end

	local tempEffects = player:GetEffects()
	local effectCount = tempEffects:GetCollectibleEffectNum(Enums.Collectibles.SANGUINE_JEWEL_DMG_NULL)

	player.Damage = player.Damage + (0.5 * effectCount * Functions.GetDamageMultiplier(player))
end

function Consumable.useCard(card, player, flag)
	if card ~= Enums.Cards.SANGUINE_JEWEL then return end

	local tempEffects = player:GetEffects()
	local rng = player:GetCardRNG(Enums.Cards.SANGUINE_JEWEL)
	local randNum = rng:RandomInt(100)

	player:ResetDamageCooldown()
	player:TakeDamage(2, DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_INVINCIBLE, EntityRef(player), 0)
	
	if flag & UseFlag.USE_MIMIC ~= UseFlag.USE_MIMIC then
		player:AnimateCard(Enums.Cards.SANGUINE_JEWEL, "UseItem")
	end
	
	if randNum < 2 then
		if not player:HasPlayerForm(PlayerForm.PLAYERFORM_EVIL_ANGEL) then
			AddTransformation(player, PlayerForm.PLAYERFORM_EVIL_ANGEL)
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
		tempEffects:AddCollectibleEffect(Enums.Collectibles.SANGUINE_JEWEL_DMG_NULL)
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:EvaluateItems()
	end
end

return Consumable
