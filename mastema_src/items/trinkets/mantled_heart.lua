local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local sfx = SFXManager()
local rng = RNG()

local Trinket = {}

function Trinket.prePickupCollision(pickup, collider, low)
	local player = collider:ToPlayer()
	
	if player == nil then return end
	if not player:HasTrinket(Enums.Trinkets.MANTLED_HEART) then return end
	if pickup.Variant ~= PickupVariant.PICKUP_HEART then return end

	if (player:IsHoldingItem() and pickup.Price == 0)
	or (not player:IsHoldingItem() and player:GetNumCoins() >= pickup.Price)
	then
		local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.MANTLED_HEART)
		local rng = player:GetTrinketRNG(Enums.Trinkets.MANTLED_HEART)
		local rngMax = 60 / trinketMultiplier
		local randNum = rng:RandomInt(rngMax)

		if (pickup.SubType == HeartSubType.HEART_ETERNAL and randNum < 18 and Functions.CanPickEternalHearts(player))
		or (player:CanPickSoulHearts() and ((pickup.SubType == HeartSubType.HEART_SOUL and randNum < 9) or (pickup.SubType == HeartSubType.HEART_HALF_SOUL and (randNum + rng:RandomFloat()) < 4.5)))
		then
			if not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) then
				player:UseCard(Card.CARD_HOLY, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
				sfx:Play(SoundEffect.SOUND_DIVINE_INTERVENTION, 1.3, 2, false, 1.2)
			end
		end
	end
end

return Trinket