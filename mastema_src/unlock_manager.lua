local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local SaveData = require("mastema_src.savedata")
local game = Game()
local rng = RNG()
local Character = Enums.Characters
local Collectible = Enums.Collectibles
local Trinket = Enums.Trinkets
local Card = Enums.Cards
local blueBabyDead = false
local lambDead = false

local collectibleUnlocks = {
	[Collectible.BOOK_OF_JUBILEES] = {
		Unlock = "BlueBaby",
		Tainted = false,
	},
	[Collectible.BLOODY_HARVEST] = {
		Unlock = "TheLamb",
		Tainted = false,
	},
	[Collectible.MASTEMAS_WRATH] = {
		Unlock = "BossRush",
		Tainted = false,
	},
	[Collectible.TORN_WINGS] = {
		Unlock = "Delirium",
		Tainted = false,
	},
	[Collectible.RAVEN_BEAK] = {
		Unlock = "Mother",
		Tainted = false,
	},
	[Collectible.BLOODSPLOSION] = {
		Unlock = "Beast",
		Tainted = false,
	},
	[Collectible.DEVILS_BARGAIN] = {
		Unlock = "Greedier",
		Tainted = false,
	},
	[Collectible.BROKEN_DICE] = {
		Unlock = "BossRush",
		Tainted = true,
	},
	[Collectible.SINISTER_SIGHT] = {
		Unlock = "Delirium",
		Tainted = true,
	},
	[Collectible.SACRIFICIAL_CHALICE] = {
		Unlock = "Mother",
		Tainted = true,
	},
	[Collectible.CORRUPT_HEART] = {
		Unlock = "Beast",
		Tainted = true,
	},
}

local trinketUnlocks = {
	[Trinket.ETERNAL_CARD] = {
		Unlock = "Isaac",
		Tainted = false,
	},
	[Trinket.LIFE_SAVINGS] = {
		Unlock = "Satan",
		Tainted = false,
	},
	[Trinket.TWISTED_FAITH] = {
		Unlock = "MegaSatan",
		Tainted = false,
	},
	[Trinket.MANTLED_HEART] = {
		Unlock = "Greed",
		Tainted = false,
	},
	[Trinket.GOODWILL_TAG] = {
		Unlock = "Isaac",
		Tainted = true,
	},
	[Trinket.SHATTERED_SOUL] = {
		Unlock = "Satan",
		Tainted = true,
	},
	[Trinket.SATANIC_CHARM] = {
		Unlock = "Greed",
		Tainted = true,
	},
	[Trinket.PURISTS_HEART] = {
		Special = function()
			return Functions.HasFullCompletion(Character.MASTEMA)
		end,
		Tainted = true,
	},
	[Trinket.SPIRITS_HEART] = {
		Special = function()
			return Functions.HasFullCompletion(Character.T_MASTEMA)
		end,
		Tainted = true,
	},
}

local cardUnlocks = {
	[Card.LIFE_DICE] = {
		Unlock = "Hush",
		Tainted = false,
	},
	[Card.PRAYER_OF_REPENTANCE] = {
		Unlock = "BlueBaby",
		Tainted = true,
	},
	[Card.SANGUINE_JEWEL] = {
		Unlock = "TheLamb",
		Tainted = true,
	},
	[Card.SOUL_OF_MASTEMA] = {
		Unlock = "Hush",
		Tainted = true,
	},
	[Card.UNHOLY_CARD] = {
		Unlock = "Greedier",
		Tainted = true,
	},
}

local UnlockManager = {}

local function UpdateCompletion(str1, str2, tainted)
	if game:IsGreedMode() then
		if game.Difficulty == Difficulty.DIFFICULTY_GREED then
			if tainted then
				SaveData.UnlockData.T_Mastema.Greed = true
			else
				SaveData.UnlockData.Mastema.Greed = true
			end
			CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/mastema_achievements/achievement_" .. str1 .. ".png")
		elseif game.Difficulty == Difficulty.DIFFICULTY_GREEDIER then
			if tainted then
				SaveData.UnlockData.T_Mastema.Greed = true
				SaveData.UnlockData.T_Mastema.Greedier = true
			else
				SaveData.UnlockData.Mastema.Greed = true
				SaveData.UnlockData.Mastema.Greedier = true
			end
			CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/mastema_achievements/achievement_" .. str1 .. ".png")
			CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/mastema_achievements/achievement_" .. str2 .. ".png")
		end
	else
		CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/mastema_achievements/achievement_" .. str1 .. ".png")
	end
	
	if not tainted
	and Functions.HasFullCompletion(Enums.Characters.MASTEMA)
	then
		CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/mastema_achievements/achievement_puristsheart.png")
	elseif tainted
	and Functions.HasFullCompletion(Enums.Characters.T_MASTEMA)
	then
		CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/mastema_achievements/achievement_spiritsheart.png")
	end

	SaveData.SaveModData()
end

function UnlockManager.postEntityKill(entity)
	if game.Challenge > 0 then return end
	if game:GetVictoryLap() > 0 then return end
	if entity.Type ~= EntityType.ENTITY_BEAST then return end
	if entity.Variant ~= 0 then return end
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local playerType = player:GetPlayerType()
		
		if (playerType == Character.MASTEMA or playerType == Character.T_MASTEMA)
		then
			if playerType == Character.MASTEMA
			and not SaveData.UnlockData.Mastema.Beast
			then
				SaveData.UnlockData.Mastema.Beast = true
				UpdateCompletion("bloodsplosion", "", false)
			elseif playerType == Character.T_MASTEMA
			and not SaveData.UnlockData.T_Mastema.Beast
			then
				SaveData.UnlockData.T_Mastema.Beast = true
				UpdateCompletion("corruptheart", "", true)
			end
		end
	end
end

function UnlockManager.postNPCDeath(npc)
	if game.Challenge > 0 then return end
	if game:GetVictoryLap() > 0 then return end

	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local playerType = player:GetPlayerType()
		local level = game:GetLevel()
		local levelStage = level:GetStage()

		if (playerType == Character.MASTEMA or playerType == Character.T_MASTEMA) then
			if levelStage == LevelStage.STAGE5 then
				if npc.Type == EntityType.ENTITY_ISAAC then
					if playerType == Character.MASTEMA
					and not SaveData.UnlockData.Mastema.Isaac
					then
						SaveData.UnlockData.Mastema.Isaac = true
						UpdateCompletion("eternalcard", "", false)
					elseif playerType == Character.T_MASTEMA
					and not SaveData.UnlockData.T_Mastema.Isaac
					then
						SaveData.UnlockData.T_Mastema.Isaac = true
						UpdateCompletion("goodwilltag", "", true)
					end
				elseif npc.Type == EntityType.ENTITY_SATAN then
					if playerType == Character.MASTEMA
					and not SaveData.UnlockData.Mastema.Satan
					then
						SaveData.UnlockData.Mastema.Satan = true
						UpdateCompletion("lifesavings", "", false)
					elseif playerType == Character.T_MASTEMA
					and not SaveData.UnlockData.T_Mastema.Satan
					then
						SaveData.UnlockData.T_Mastema.Satan = true
						UpdateCompletion("shatteredsoul", "", true)
					end
				end
			elseif levelStage == LevelStage.STAGE6 then
				if npc.Type == EntityType.ENTITY_ISAAC
				and npc.Variant == 1
				then
					if playerType == Character.MASTEMA
					and not SaveData.UnlockData.Mastema.BlueBaby
					then
						blueBabyDead = true
					elseif playerType == Character.T_MASTEMA
					and not SaveData.UnlockData.T_Mastema.BlueBaby
					then
						blueBabyDead = true
					end
				elseif npc.Type == EntityType.ENTITY_THE_LAMB then
					if playerType == Character.MASTEMA
					and not SaveData.UnlockData.Mastema.TheLamb
					then
						lambDead = true
					elseif playerType == Character.T_MASTEMA
					and not SaveData.UnlockData.T_Mastema.TheLamb
					then
						lambDead = true
					end
				elseif npc.Type == EntityType.ENTITY_MEGA_SATAN_2 then
					if playerType == Character.MASTEMA
					and not SaveData.UnlockData.Mastema.MegaSatan
					then
						SaveData.UnlockData.Mastema.MegaSatan = true
						UpdateCompletion("twistedfaith", "", false)
					elseif playerType == Character.T_MASTEMA
					and not SaveData.UnlockData.T_Mastema.MegaSatan
					then
						SaveData.UnlockData.T_Mastema.MegaSatan = true
						UpdateCompletion("satanicritual", "", true)
					end
				end
			elseif levelStage == LevelStage.STAGE7
			and npc.Type == EntityType.ENTITY_DELIRIUM
			then
				if playerType == Character.MASTEMA
				and not SaveData.UnlockData.Mastema.Delirium
				then
					SaveData.UnlockData.Mastema.Delirium = true
					UpdateCompletion("tornwings", "", false)
				elseif playerType == Character.T_MASTEMA
				and not SaveData.UnlockData.T_Mastema.Delirium
				then
					SaveData.UnlockData.T_Mastema.Delirium = true
					UpdateCompletion("sinistersight", "", true)
				end
			elseif (levelStage == LevelStage.STAGE4_1 or levelStage == LevelStage.STAGE4_2)
			and npc.Type == EntityType.ENTITY_MOTHER
			and npc.Variant == 10
			then
				if playerType == Character.MASTEMA
				and not SaveData.UnlockData.Mastema.Mother
				then
					SaveData.UnlockData.Mastema.Mother = true
					UpdateCompletion("ravenbeak", "", false)
				elseif playerType == Character.T_MASTEMA
				and not SaveData.UnlockData.T_Mastema.Mother
				then
					SaveData.UnlockData.T_Mastema.Mother = true
					UpdateCompletion("sacrificialchalice", "", true)
				end
			end
		end
	end
end

function UnlockManager.postPEffectUpdate(player)
	if game.Challenge > 0 then return end
	if game:GetVictoryLap() > 0 then return end
	
	local playerType = player:GetPlayerType()

	if playerType ~= Character.MASTEMA and playerType ~= Character.T_MASTEMA then return end

	local level = game:GetLevel()
	local levelStage = level:GetStage()
	local room = game:GetRoom()
	
	if levelStage == LevelStage.STAGE6
	and room:GetType() == RoomType.ROOM_BOSS
	and room:IsClear()
	then
		if blueBabyDead then
			if playerType == Character.MASTEMA
			and not SaveData.UnlockData.Mastema.BlueBaby
			then
				SaveData.UnlockData.Mastema.BlueBaby = true
				UpdateCompletion("bookofjubilees", "", false)
				blueBabyDead = false
			elseif playerType == Character.T_MASTEMA
			and not SaveData.UnlockData.T_Mastema.BlueBaby
			then
				SaveData.UnlockData.T_Mastema.BlueBaby = true
				UpdateCompletion("prayerofrepentance", "", true)
				blueBabyDead = false
			end
		elseif lambDead then
			if playerType == Character.MASTEMA
			and not SaveData.UnlockData.Mastema.TheLamb
			then
				SaveData.UnlockData.Mastema.TheLamb = true
				UpdateCompletion("bloodyharvest", "", false)
				lambDead = false
			elseif playerType == Character.T_MASTEMA
			and not SaveData.UnlockData.T_Mastema.TheLamb
			then
				SaveData.UnlockData.T_Mastema.TheLamb = true
				UpdateCompletion("sanguinejewel", "", true)
				lambDead = false
			end
		end
	end
			
	if game:GetStateFlag(GameStateFlag.STATE_BOSSRUSH_DONE)
	and (levelStage == LevelStage.STAGE3_1 or levelStage == LevelStage.STAGE3_2)
	then
		if playerType == Character.MASTEMA
		and not SaveData.UnlockData.Mastema.BossRush
		then
			SaveData.UnlockData.Mastema.BossRush = true
			UpdateCompletion("mastemaswrath", "", false)
		elseif playerType == Character.T_MASTEMA
		and not SaveData.UnlockData.T_Mastema.BossRush
		then
			SaveData.UnlockData.T_Mastema.BossRush = true
			UpdateCompletion("brokendice", "", true)
		end
	end
	
	if game:GetStateFlag(GameStateFlag.STATE_BLUEWOMB_DONE)
	and levelStage == LevelStage.STAGE4_3
	then
		if playerType == Character.MASTEMA
		and not SaveData.UnlockData.Mastema.Hush
		then
			SaveData.UnlockData.Mastema.Hush = true
			UpdateCompletion("lifedice", "", false)
		elseif playerType == Character.T_MASTEMA
		and not SaveData.UnlockData.T_Mastema.Hush
		then
			SaveData.UnlockData.T_Mastema.Hush = true
			UpdateCompletion("soulofmastema", "", true)
		end
	end
	
	if game:IsGreedMode()
	and levelStage == LevelStage.STAGE7_GREED
	and room:GetRoomShape() == RoomShape.ROOMSHAPE_1x2
	and room:IsClear()
	then
		if game.Difficulty == Difficulty.DIFFICULTY_GREED then
			if playerType == Character.MASTEMA
			and not SaveData.UnlockData.Mastema.Greed
			then
				UpdateCompletion("mantledheart", "", false)
			elseif playerType == Character.T_MASTEMA
			and not SaveData.UnlockData.T_Mastema.Greed
			then
				UpdateCompletion("sataniccharm", "", true)
			end
		elseif game.Difficulty == Difficulty.DIFFICULTY_GREEDIER then
			if playerType == Character.MASTEMA then
				if not SaveData.UnlockData.Mastema.Greed
				and not SaveData.UnlockData.Mastema.Greedier
				then
					UpdateCompletion("devilsbargain", "mantledheart", false)
				elseif SaveData.UnlockData.Mastema.Greed
				and not SaveData.UnlockData.Mastema.Greedier
				then
					UpdateCompletion("devilsbargain", "", false)
				end
			elseif playerType == Character.T_MASTEMA then
				if not SaveData.UnlockData.T_Mastema.Greed
				and not SaveData.UnlockData.T_Mastema.Greedier
				then
					UpdateCompletion("unholycard", "sataniccharm", true)
				elseif SaveData.UnlockData.T_Mastema.Greed
				and not SaveData.UnlockData.T_Mastema.Greedier
				then
					UpdateCompletion("unholycard", "", true)
				end
			end
		end
	end
end

function UnlockManager.postPlayerInit(player)
	if game:GetFrameCount() > 0 then return end

	for item, tab in pairs(collectibleUnlocks) do
		local prefix = ""
		local unlocked = false

		if tab.Tainted then
			prefix = "T_"
		end
		unlocked = SaveData.UnlockData[prefix .. "Mastema"][tab.Unlock]
		
		if not unlocked then
			game:GetItemPool():RemoveCollectible(item)
		end
	end

	for trinket, tab in pairs(trinketUnlocks) do
		local prefix = ""
		local unlocked = false

		if tab.Special then
			unlocked = tab.Special()
		else
			if tab.Tainted then
				prefix = "T_"
			end
			unlocked = SaveData.UnlockData[prefix .. "Mastema"][tab.Unlock]
		end

		if not unlocked then
			game:GetItemPool():RemoveTrinket(trinket)
		end
	end
end

function UnlockManager.postPickupInit(pickup)
	local room = game:GetRoom()
	local roomType = room:GetType()
	rng:SetSeed(pickup.InitSeed, 35)

	if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
		local tab = collectibleUnlocks[pickup.SubType]
		local prefix = ""
		local unlocked = false

		if tab == nil then return end

		if tab.Tainted then
			prefix = "T_"
		end
		unlocked = SaveData.UnlockData[prefix .. "Mastema"][tab.Unlock]

		if not unlocked then
			local seed = game:GetSeeds():GetStartSeed()
			local pool = game:GetItemPool():GetPoolForRoom(roomType, seed)

			if pool == ItemPoolType.POOL_NULL then
				pool = ItemPoolType.POOL_TREASURE
			end

			if roomType ~= RoomType.ROOM_DEVIL then
				if pickup.SubType == Collectible.BLOODY_HARVEST
				or pickup.SubType == Collectible.TORN_WINGS
				or pickup.SubType == Collectible.DEVILS_BARGAIN
				or pickup.SubType == Collectible.SACRIFICIAL_CHALICE
				or pickup.SubType == Collectible.MASTEMAS_WRATH
				or pickup.SubType == Collectible.SINISTER_SIGHT
				or pickup.SubType == Collectible.CORRUPT_HEART
				then
					pool = ItemPoolType.POOL_DEVIL
				end
			end

			if roomType ~= RoomType.ROOM_CURSE
			and pickup.SubType == Collectible.BROKEN_DICE
			then
				pool = ItemPoolType.POOL_RED_CHEST
			end

			local newItem = game:GetItemPool():GetCollectible(pool, true, pickup.InitSeed)
			game:GetItemPool():RemoveCollectible(pickup.SubType)
			pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, true, false, false)
		end
	elseif pickup.Variant == PickupVariant.PICKUP_TRINKET then
		local tab = trinketUnlocks[pickup.SubType]
		local trinketID = pickup.SubType
		local isGolden = false
		local prefix = ""
		local unlocked = false

		if pickup.SubType > TrinketType.TRINKET_GOLDEN_FLAG then
			tab = trinketUnlocks[pickup.SubType - TrinketType.TRINKET_GOLDEN_FLAG]
			trinketID = pickup.SubType - TrinketType.TRINKET_GOLDEN_FLAG
			isGolden = true
		end

		if tab == nil then return end

		if tab.Special then
			unlocked = tab.Special()
		else
			if tab.Tainted then
				prefix = "T_"
			end
			unlocked = SaveData.UnlockData[prefix .. "Mastema"][tab.Unlock]
		end
		
		if not unlocked then
			local newTrinket = game:GetItemPool():GetTrinket(false)

			if isGolden then
				newTrinket = newTrinket + TrinketType.TRINKET_GOLDEN_FLAG
			end

			game:GetItemPool():RemoveTrinket(trinketID)
			pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, newTrinket, true, false, false)
		end
	elseif pickup.Variant == PickupVariant.PICKUP_TAROTCARD then
		local tab = cardUnlocks[pickup.SubType]
		local prefix = ""
		local unlocked = false

		if tab == nil then return end

		if tab.Tainted then
			prefix = "T_"
		end
		unlocked = SaveData.UnlockData[prefix .. "Mastema"][tab.Unlock]

		if not unlocked then
			local pool = game:GetItemPool()
			local newCard = pool:GetCard(Random(), false, false, false)
				
			if pickup.SubType == Card.SOUL_OF_MASTEMA
			or pickup.SubType == Card.SANGUINE_JEWEL
			then
				newCard = pool:GetCard(Random(), false, true, true)
			end
			
			pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, newCard, true, false, false)
		end
	end
end

function UnlockManager.postPlayerUpdate(player)
	for item, val in pairs(collectibleUnlocks) do
		local tab = collectibleUnlocks[item]
		local prefix = ""
		local unlocked = false

		if tab == nil then return end

		if tab.Tainted then
			prefix = "T_"
		end
		unlocked = SaveData.UnlockData[prefix .. "Mastema"][tab.Unlock]
		
		if player:HasCollectible(item, true)
		and not unlocked
		then
			local itemConfig = Isaac.GetItemConfig()
			local pool = ItemPoolType.POOL_TREASURE

			if item == Collectible.BROKEN_DICE then
				pool = ItemPoolType.POOL_RED_CHEST
			elseif item == Collectible.BLOODY_HARVEST
			or item == Collectible.TORN_WINGS
			or item == Collectible.DEVILS_BARGAIN
			or item == Collectible.SACRIFICIAL_CHALICE
			or item == Collectible.MASTEMAS_WRATH
			or item == Collectible.SINISTER_SIGHT
			or item == Collectible.CORRUPT_HEART
			then
				pool = ItemPoolType.POOL_DEVIL
			end

			local newItem = game:GetItemPool():GetCollectible(pool, true, player.InitSeed)
			player:RemoveCollectible(item)
			player:AddCollectible(newItem, itemConfig:GetCollectible(newItem).MaxCharges)
		end
	end
	
	for trinket, val in pairs(trinketUnlocks) do
		local tab = trinketUnlocks[trinket]
		local prefix = ""
		local unlocked = false

		if tab == nil then return end

		if tab.Special then
			unlocked = tab.Special()
		else
			if tab.Tainted then
				prefix = "T_"
			end
			unlocked = SaveData.UnlockData[prefix .. "Mastema"][tab.Unlock]
		end
		
		if player:HasTrinket(trinket)
		and not unlocked
		then
			local newTrinket = game:GetItemPool():GetTrinket(false)

			if trinket > TrinketType.TRINKET_GOLDEN_FLAG then
				newTrinket = newTrinket + TrinketType.TRINKET_GOLDEN_FLAG
			end

			player:TryRemoveTrinket(trinket)
			player:AddTrinket(newTrinket)
		end
	end

	for i = 0, 3 do
		for card, val in pairs(cardUnlocks) do
			local tab = cardUnlocks[card]
			local prefix = ""
			local unlocked = false

			if tab == nil then return end

			if tab.Tainted then
				prefix = "T_"
			end
			unlocked = SaveData.UnlockData[prefix .. "Mastema"][tab.Unlock]

			if player:GetCard(i) == card
			and not unlocked
			then
				local pool = game:GetItemPool()
				local newCard = pool:GetCard(Random(), false, false, false)
				
				if card == Card.SOUL_OF_MASTEMA
				or card == Card.SANGUINE_JEWEL
				then
					newCard = pool:GetCard(Random(), false, true, true)
				end
				player:SetCard(i, newCard)
			end
		end
	end
end

return UnlockManager