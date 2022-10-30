local Enums = require("mastema_src.enums")
local rng = RNG()

local Card = {}

function Card.useCard(card, player, flag)
	if card ~= Enums.Cards.LIFE_DICE then return end
	if player:GetPlayerType() == PlayerType.PLAYER_THELOST then return end
	if player:GetPlayerType() == PlayerType.PLAYER_THELOST_B then return end
	
	local heartLimit = player:GetHeartLimit()
	local numHeartContainers = player:GetEffectiveMaxHearts()
	local numSoulHearts = player:GetSoulHearts()
	local numBoneHearts = player:GetBoneHearts()
	local rng = player:GetCardRNG(Enums.Cards.LIFE_DICE)
	local randNum
	local newHealthTotal
	local filledRedHealth
	local rottenHeartChance
	local goldenHeartChance
	local brokenHeartChance
	
	player:AddMaxHearts(-numHeartContainers)

	if player:GetPlayerType() == PlayerType.PLAYER_KEEPER
	or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B
	then
		newHealthTotal = rng:RandomInt(heartLimit) + 1
		filledRedHealth = rng:RandomInt(newHealthTotal) + 1

		if newHealthTotal % 2 ~= 0 then
			newHealthTotal = newHealthTotal + 1
		end

		if filledRedHealth % 2 ~= 0 then
			filledRedHealth = filledRedHealth + 1
		end

		player:AddMaxHearts(newHealthTotal)
		player:AddHearts(filledRedHealth)
	elseif player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN
	or player:GetPlayerType() == PlayerType.PLAYER_BETHANY
	then
		newHealthTotal = rng:RandomInt(heartLimit) + 1
		filledRedHealth = rng:RandomInt(newHealthTotal + 1)
		
		if newHealthTotal % 2 ~= 0 then
			newHealthTotal = newHealthTotal + 1
		end

		if player:GetPlayerType() == PlayerType.PLAYER_BETHANY
		and filledRedHealth == 0
		then
			filledRedHealth = rng:RandomInt(newHealthTotal) + 1
		end

		player:AddMaxHearts(newHealthTotal)

		for i = 1, filledRedHealth do
			rottenHeartChance = rng:RandomInt(20)

			if rottenHeartChance == 0 then
				player:AddRottenHearts(1)
			else
				player:AddHearts(1)
			end
		end
	elseif player:GetPlayerType() == PlayerType.PLAYER_THESOUL then
		player:AddSoulHearts(-numSoulHearts)
		newHealthTotal = rng:RandomInt(heartLimit) + 1

		for i = 1, math.floor(newHealthTotal / 2) do
			randNum = rng:RandomInt(2)
			
			if randNum == 0 then
				player:AddSoulHearts(2)
			else
				player:AddBlackHearts(2)
			end
		end

		if newHealthTotal % 2 ~= 0 then
			randNum = rng:RandomInt(2)
			
			if randNum == 0 then
				player:AddSoulHearts(1)
			else
				player:AddBlackHearts(1)
			end
		end
	else
		local newRedHearts = 0
		local newBoneHearts = 0

		player:AddSoulHearts(-numSoulHearts)
		player:AddBoneHearts(-numBoneHearts)
		newHealthTotal = rng:RandomInt(heartLimit) + 1
		newRedHearts = rng:RandomInt(newHealthTotal)

		if newRedHearts % 2 ~= 0
		and newRedHearts ~= 0
		then
			newRedHearts = newRedHearts + 1
		end
		
		player:AddMaxHearts(newRedHearts)
		randNum = rng:RandomInt(5)

		if randNum == 0
		and newRedHearts > 0
		then
			newBoneHearts = math.ceil((rng:RandomInt(newRedHearts) + 1) / 2)
			player:AddMaxHearts(-(newBoneHearts * 2))
			player:AddBoneHearts(newBoneHearts)
		end
		
		if newHealthTotal - newRedHearts > 0 then
			for i = 1, newHealthTotal - newRedHearts do
				randNum = rng:RandomInt(15)
			
				if randNum == 0 then
					player:AddBoneHearts(1)
				elseif randNum > 0
				and randNum <= 9
				then
					player:AddSoulHearts(1)
				else
					player:AddBlackHearts(1)
				end
			end
		end

		filledRedHealth = rng:RandomInt(newHealthTotal + 1)

		if filledRedHealth == 0
		and newHealthTotal - newRedHearts == 0
		and newBoneHearts == 0
		then
			filledRedHealth = rng:RandomInt(newHealthTotal) + 1
		end
		
		for i = 1, filledRedHealth do
			rottenHeartChance = rng:RandomInt(20)

			if rottenHeartChance == 0 then
				player:AddRottenHearts(1)
			else
				player:AddHearts(1)
			end
		end
	end

	--10% chance per broken heart to turn it into a permanent red heart container
	for i = 1, player:GetBrokenHearts() do
		brokenHeartChance = rng:RandomInt(10)

		if brokenHeartChance == 0 then
			player:AddBrokenHearts(-1)
			player:AddMaxHearts(2)

			randNum = rng:RandomInt(3)

			if randNum > 0 then
				for i = 1, randNum do
					player:AddHearts(1)
				end
			end
		end
	end

	--1% chance to add any number of broken hearts >:)
	brokenHeartChance = rng:RandomInt(100)
	
	if brokenHeartChance == 0 then
		local maxBrokenHearts = player:GetHeartLimit() / 2

		if maxBrokenHearts < 1 then
			maxBrokenHearts = 1
		end
		
		randNum = rng:RandomInt(maxBrokenHearts)
		player:AddBrokenHearts(randNum)
	end

	if player:GetPlayerType() ~= PlayerType.PLAYER_KEEPER
	and player:GetPlayerType() ~= PlayerType.PLAYER_KEEPER_B
	then
		--5% chance to give an eternal heart on use
		randNum = rng:RandomInt(20)
		
		if randNum == 0 then
			player:AddEternalHearts(1)
		end

		--1% chance to fill all hearts with rotten hearts
		rottenHeartChance = rng:RandomInt(100)

		if rottenHeartChance == 0 then
			player:AddRottenHearts(player:GetEffectiveMaxHearts())
		end

		--5% chance to give golden hearts
		goldenHeartChance = rng:RandomInt(20)

		if goldenHeartChance == 0 then
			goldenHeartChance = rng:RandomInt(math.floor(player:GetHeartLimit() / 2))
			player:AddGoldenHearts(goldenHeartChance)
		end
	end
end

return Card