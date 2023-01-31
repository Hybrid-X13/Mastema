local Enums = require("mastema_src.enums")
local SaveData = require("mastema_src.savedata")
local rng = RNG()

local Item = {}

function Item.evaluateCache(player, cacheFlag)
	if cacheFlag ~= CacheFlag.CACHE_DAMAGE then return end
	
	if player:HasCollectible(Enums.Collectibles.RAVEN_BEAK)
	or SaveData.ItemData.RavenBeak.DMG > 0
	then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
			player.Damage = player.Damage + (SaveData.ItemData.RavenBeak.DMG * 0.2)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
			player.Damage = player.Damage + (SaveData.ItemData.RavenBeak.DMG * 0.3)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
			player.Damage = player.Damage + (SaveData.ItemData.RavenBeak.DMG * 0.8)
		else
			player.Damage = player.Damage + SaveData.ItemData.RavenBeak.DMG
		end
	end
end

function Item.useItem(item, rng, player, flags, activeSlot, customVarData)
	if item ~= Enums.Collectibles.RAVEN_BEAK then return end
	
	local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, -1)

	for _, j in pairs(items) do
		local pickup = j:ToPickup()
		local sprite = pickup:GetSprite()

		if pickup.Price == 0
		and not sprite:IsPlaying("Collect")
		then
			if pickup.Variant == PickupVariant.PICKUP_HEART
			or pickup.Variant == PickupVariant.PICKUP_COIN
			or pickup.Variant == PickupVariant.PICKUP_KEY
			or pickup.Variant == PickupVariant.PICKUP_BOMB
			or pickup.Variant == PickupVariant.PICKUP_PILL
			or pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY
			or pickup.Variant == PickupVariant.PICKUP_TAROTCARD
			or pickup.Variant == PickupVariant.PICKUP_TRINKET
			then
				if pickup.Variant == PickupVariant.PICKUP_HEART then
					if pickup.SubType == HeartSubType.HEART_ETERNAL then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.25
					elseif pickup.SubType == HeartSubType.HEART_BLACK
					or pickup.SubType == HeartSubType.HEART_GOLDEN
					or pickup.SubType == HeartSubType.HEART_BONE
					then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.15
					elseif pickup.SubType == HeartSubType.HEART_SOUL then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.1
					elseif pickup.SubType == HeartSubType.HEART_BLENDED then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.07
					elseif pickup.SubType == HeartSubType.HEART_HALF_SOUL then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.05
					elseif pickup.SubType == HeartSubType.HEART_DOUBLEPACK then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.04
					elseif pickup.SubType == HeartSubType.HEART_FULL
					or pickup.SubType == HeartSubType.HEART_ROTTEN
					then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.02
					else
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.01
					end
				elseif pickup.Variant == PickupVariant.PICKUP_COIN then
					if pickup.SubType == CoinSubType.COIN_GOLDEN then
						local dmg = 0.01
						
						for i = 1, 99 do
							local randNum = rng:RandomInt(10)
							
							if randNum == 0 then
								break
							else
								dmg = dmg + 0.01
							end
						end
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + dmg
					elseif pickup.SubType == CoinSubType.COIN_DIME then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.1
					elseif pickup.SubType == CoinSubType.COIN_LUCKYPENNY then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.08
					elseif pickup.SubType == CoinSubType.COIN_NICKEL
					or pickup.SubType == CoinSubType.COIN_STICKYNICKEL
					then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.05
					elseif pickup.SubType == CoinSubType.COIN_DOUBLEPACK then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.02
					else
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.01
					end
				elseif pickup.Variant == PickupVariant.PICKUP_KEY then
					if pickup.SubType == KeySubType.KEY_GOLDEN then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.12
					elseif pickup.SubType == KeySubType.KEY_CHARGED then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.08
					elseif pickup.SubType == KeySubType.KEY_DOUBLEPACK then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.04
					else
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.02
					end
				elseif pickup.Variant == PickupVariant.PICKUP_BOMB then
					if pickup.SubType == BombSubType.BOMB_GIGA then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.5
					elseif pickup.SubType == BombSubType.BOMB_GOLDEN then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.12
					elseif pickup.SubType == BombSubType.BOMB_DOUBLEPACK then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.04
					else
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.02
					end
				elseif pickup.Variant == PickupVariant.PICKUP_PILL then
					if pickup.SubType == PillColor.PILL_GOLD + PillColor.PILL_GIANT_FLAG then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.5
					elseif pickup.SubType == PillColor.PILL_GOLD then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.25
					elseif pickup.SubType > PillColor.PILL_GIANT_FLAG then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.1
					else
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.05
					end
				elseif pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY then
					if pickup.SubType == BatterySubType.BATTERY_MEGA
					or pickup.SubType == BatterySubType.BATTERY_GOLDEN
					then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.25
					elseif pickup.SubType == BatterySubType.BATTERY_NORMAL then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.08
					else
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.04
					end
				elseif pickup.Variant == PickupVariant.PICKUP_TAROTCARD then
					local itemConfig = Isaac.GetItemConfig():GetCard(pickup.SubType)

					if itemConfig:IsCard() then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.07
					else
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.1
					end
				elseif pickup.Variant == PickupVariant.PICKUP_TRINKET then
					if pickup.SubType > TrinketType.TRINKET_GOLDEN_FLAG then
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.16
					else
						SaveData.ItemData.RavenBeak.DMG = SaveData.ItemData.RavenBeak.DMG + 0.08
					end
				end
				
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:EvaluateItems()
				pickup:Remove()
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, pickup)
			end
		end
	end
	
	return true
end

return Item