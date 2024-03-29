local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
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

local FF = {
	HALF_BLACK_HEART = 1022,
	BLENDED_BLACK_HEART = 1023,
	IMMORAL_HEART = 1024,
	HALF_IMMORAL_HEART = 1025,
	BLENDED_IMMORAL_HEART = 1026,
	MORBID_HEART = 1028,
	TWO_THIRDS_MORBID_HEART = 1029,
	THIRD_MORBID_HEART = 1030,
}

local CellHeart = {
	HALF = 120,
	FULL = 121,
	DOUBLE = 122,
}

local PatchedHeart = {
	FULL = 3320,
	DOUBLE = 3321,
}

local ImmortalHeart = 902

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
	[HeartSubType.HEART_ETERNAL] = 8,
	--Rep+ Hearts
	[RepPlus.BROKEN_HEART] = 5,
	[RepPlus.DAUNTLESS_HEART] = 8,
	[RepPlus.HOARDED_HEART] = 8,
	[RepPlus.SOILED_HEART] = 4,
	[RepPlus.CURDLED_HEART] = 5,
	[RepPlus.SAVAGE_HEART] = 6,
	[RepPlus.ENIGMA_HEART] = 8,
	[RepPlus.BALEFUL_HEART] = 8,
	[RepPlus.HARLOT_HEART] = 3,
	[RepPlus.MISER_HEART] = 7,
	[RepPlus.EMPTY_HEART] = 5,
	[RepPlus.FETTERED_HEART] = 7,
	[RepPlus.ZEALOT_HEART] = 7,
	--Fiend Folio Hearts
	[FF.IMMORAL_HEART] = 5,
	[FF.HALF_IMMORAL_HEART] = 2,
	[FF.MORBID_HEART] = 6,
	[FF.TWO_THIRDS_MORBID_HEART] = 4,
	[FF.THIRD_MORBID_HEART] = 2,
	--Cell Hearts
	[CellHeart.HALF] = 1,
	[CellHeart.FULL] = 2,
	[CellHeart.DOUBLE] = 4,
	--Patched Hearts
	[PatchedHeart.FULL] = 2,
	[PatchedHeart.DOUBLE] = 4,
	--Immortal Hearts
	[ImmortalHeart] = 9,
}

local Item = {}

local function SpawnBlackLocust(numLocusts, player, pos)
	if player:HasTrinket(TrinketType.TRINKET_FISH_TAIL) then
		numLocusts = numLocusts * 2
	end
	
	for i = 1, numLocusts do
		local blackLocust = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, LocustSubtypes.LOCUST_OF_DEATH, pos, Vector.Zero, player)
		blackLocust:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	end
end

function Item.postPickupInit(pickup)
	if pickup.Variant ~= PickupVariant.PICKUP_HEART then return end
	if pickup.Price ~= 0 then return end

	local room = game:GetRoom()

	if room:GetFrameCount() == -1 and not room:IsFirstVisit() then return end
	
	rng:SetSeed(pickup.InitSeed, 35)
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasCollectible(Enums.Collectibles.CORRUPT_HEART) then
			local randNum = rng:RandomInt(3)

			if player:GetCollectibleNum(Enums.Collectibles.CORRUPT_HEART) > 1 then
				randNum = rng:RandomInt(2)
			end

			if randNum ~= 0 then return end

			if Functions.IsKeeper(player) then
				if pickup.SubType == HeartSubType.HEART_BLACK
				or pickup.SubType == RepPlus.BENIGHTED_HEART
				or pickup.SubType == RepPlus.DESERTED_HEART
				then
					SpawnBlackLocust(6, player, pickup.Position)
					pickup:Remove()
				else
					if heartMap[pickup.SubType] then
						randNum = rng:RandomInt(10)
						
						if randNum < heartMap[pickup.SubType] then
							SpawnBlackLocust(heartMap[pickup.SubType], player, pickup.Position)
							pickup:Remove()
						end
					else
						randNum = rng:RandomInt(2)
						
						if randNum == 0 then
							SpawnBlackLocust(5, player, pickup.Position)
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
							SpawnBlackLocust(2, player, pickup.Position)
						end
					else
						SpawnBlackLocust(heartMap[pickup.SubType], player, pickup.Position)
						pickup:Remove()
					end
				elseif pickup.SubType ~= HeartSubType.HEART_BLACK
				and pickup.SubType ~= RepPlus.BENIGHTED_HEART
				and pickup.SubType ~= RepPlus.DESERTED_HEART
				and pickup.SubType ~= RepPlus.DECEIVER_HEART
				and pickup.SubType ~= RepPlus.CAPRICIOUS_HEART
				and pickup.SubType ~= FF.HALF_BLACK_HEART
				and pickup.SubType ~= FF.BLENDED_BLACK_HEART
				then
					--Any modded hearts that aren't in the heart map have a 50/50 chance
					randNum = rng:RandomInt(2)
					
					if randNum == 0 then
						pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, true, false, false)
						pickup:SetColor(Color(0, 0, 0, 1, 0.1, 0, 0.1), 60, 1, true, false)
					else
						SpawnBlackLocust(5, player, pickup.Position)
						pickup:Remove()
					end
				end
			end
		end
	end
end

return Item