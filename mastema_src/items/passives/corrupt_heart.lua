local Enums = require("mastema_src.enums")
local game = Game()
local rng = RNG()

local RepPlus = {
	BROKEN_HEART = 84,
	DAUNTLESS_HEART = 85,
	HOARDED_HEART = 86,
	DECEIVER_HEART = 87,
	SOILED_HEART = 88,
	CURDLED_HEART = 89,
	SAVAGE_HEART = 90,
	BENIGHTED_HEART = 91,
	ENIGMA_HEART = 92,
	CAPRICIOUS_HEART = 93,
	BALEFUL_HEART = 94,
	HARLOT_HEART = 95,
	MISER_HEART = 96,
	EMPTY_HEART = 97,
	FETTERED_HEART = 98,
	ZEALOT_HEART = 99,
	DESERTED_HEART = 100,
}

local FiendFolio = {
	HALF_BLACK_HEART = 1022,
	BLENDED_BLACK_HEART = 1023,
	IMMORAL_HEART = 1024,
	HALF_IMMORAL_HEART = 1025,
	BLENDED_IMMORAL_HEART = 1026,
	MORBID_HEART = 1028,
	TWO_THIRDS_MORBID_HEART = 1029,
	THIRD_MORBID_HEART = 1029,
}

local CellHeart = {
	HALF = 120,
	FULL = 121,
	DOUBLE = 122,
}

local heartMap = {
	[HeartSubType.HEART_HALF] = 1,
	[HeartSubType.HEART_FULL] = 2,
	[HeartSubType.HEART_HALF_SOUL] = 2,
	[HeartSubType.HEART_BLENDED] = 3,
	[HeartSubType.HEART_DOUBLEPACK] = 4,
	[HeartSubType.HEART_ROTTEN] = 4,
	[HeartSubType.HEART_BONE] = 5,
	[HeartSubType.HEART_SOUL] = 5,
	[HeartSubType.HEART_GOLDEN] = 6,
	[HeartSubType.HEART_ETERNAL] = 7,
	--Rep+ Hearts
	[RepPlus.BROKEN_HEART] = 5,
	[RepPlus.DAUNTLESS_HEART] = 7,
	[RepPlus.HOARDED_HEART] = 8,
	[RepPlus.SOILED_HEART] = 4,
	[RepPlus.CURDLED_HEART] = 5,
	[RepPlus.SAVAGE_HEART] = 5,
	[RepPlus.ENIGMA_HEART] = 6,
	[RepPlus.BALEFUL_HEART] = 7,
	[RepPlus.HARLOT_HEART] = 3,
	[RepPlus.MISER_HEART] = 6,
	[RepPlus.EMPTY_HEART] = 5,
	[RepPlus.FETTERED_HEART] = 6,
	[RepPlus.ZEALOT_HEART] = 6,
	--Fiend Folio Hearts
	[FiendFolio.IMMORAL_HEART] = 5,
	[FiendFolio.HALF_IMMORAL_HEART] = 2,
	[FiendFolio.MORBID_HEART] = 6,
	[FiendFolio.TWO_THIRDS_MORBID_HEART] = 4,
	[FiendFolio.THIRD_MORBID_HEART] = 2,
	--Cell Hearts
	[CellHeart.HALF] = 1,
	[CellHeart.FULL] = 2,
	[CellHeart.DOUBLE] = 4,
}

local Item = {}

local function SpawnBlackLocust(numLocusts, pickup)
	for i = 1, numLocusts do
		local blackLocust = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, LocustSubtypes.LOCUST_OF_DEATH, pickup.Position, Vector.Zero, pickup)
		blackLocust:GetSprite():Play("LocustDeath")
		blackLocust:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	end
end

function Item.postPickupInit(pickup)
	if pickup.Variant ~= PickupVariant.PICKUP_HEART then return end
	if pickup.Price ~= 0 then return end
	
	rng:SetSeed(pickup.InitSeed, 35)
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if not player:HasCollectible(Enums.Collectibles.CORRUPT_HEART) then return end
		
		local randNum = rng:RandomInt(3)

		if player:GetCollectibleNum(Enums.Collectibles.CORRUPT_HEART) > 1 then
			randNum = rng:RandomInt(2)
		end

		if randNum ~= 0 then return end

		if player:GetPlayerType() == PlayerType.PLAYER_KEEPER
		or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B
		then
			if pickup.SubType == HeartSubType.HEART_BLACK
			or pickup.SubType == RepPlus.BENIGHTED_HEART
			or pickup.SubType == RepPlus.DESERTED_HEART
			then
				SpawnBlackLocust(6, pickup)
				pickup:Remove()
			else
				if heartMap[pickup.SubType] then
					randNum = rng:RandomInt(10)
					
					if randNum < heartMap[pickup.SubType] then
						SpawnBlackLocust(heartMap[pickup.SubType], pickup)
						pickup:Remove()
					end
				else
					randNum = rng:RandomInt(5)
					
					if randNum == 0 then
						SpawnBlackLocust(2, pickup)
						pickup:Remove()
					end
				end
			end
		else
			if heartMap[pickup.SubType] then
				randNum = rng:RandomInt(10)
				
				if randNum < heartMap[pickup.SubType] then
					pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, true, false, false)
					pickup:SetColor(Color(0, 0, 0, 1, 0.1, 0, 0.1), 60, 1, true, false)

					if pickup.SubType == HeartSubType.HEART_ROTTEN then
						SpawnBlackLocust(2, pickup)
					end
				else
					SpawnBlackLocust(heartMap[pickup.SubType], pickup)
					pickup:Remove()
				end
			elseif pickup.SubType ~= HeartSubType.HEART_BLACK
			and pickup.SubType ~= RepPlus.BENIGHTED_HEART
			and pickup.SubType ~= RepPlus.DESERTED_HEART
			and pickup.SubType ~= RepPlus.DECEIVER_HEART
			and pickup.SubType ~= RepPlus.CAPRICIOUS_HEART
			and pickup.SubType ~= FiendFolio.HALF_BLACK_HEART
			and pickup.SubType ~= FiendFolio.BLENDED_BLACK_HEART
			then
				randNum = rng:RandomInt(10)
				
				if randNum < 3 then
					pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, true, false, false)
					pickup:SetColor(Color(0, 0, 0, 1, 0.1, 0, 0.1), 60, 1, true, false)
				else
					SpawnBlackLocust(3, pickup)
					pickup:Remove()
				end
			end
		end
	end
end

return Item