local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local game = Game()
local sfx = SFXManager()
local rng = RNG()
local itemPool = game:GetItemPool()
local newFloor = false

local horns = Isaac.GetCostumeIdByPath("gfx/characters/character_mastema_b_horns.anm2")

local Stats = {
	Speed = 0.2,
	Tears = 1,
	DMG = 0,
	Range = 0,
	ShotSpeed = 0,
	Luck = -6.66,
	TearColor = Color(1, 0, 1, 1, 0, 0, 0),
	Fly = true,
}

local Blacklist = {
	Items = {
		CollectibleType.COLLECTIBLE_SANGUINE_BOND,
		CollectibleType.COLLECTIBLE_TRANSCENDENCE,
		CollectibleType.COLLECTIBLE_YUM_HEART,
		CollectibleType.COLLECTIBLE_YUCK_HEART,
		CollectibleType.COLLECTIBLE_CANDY_HEART,
		CollectibleType.COLLECTIBLE_BLOOD_OATH,
		CollectibleType.COLLECTIBLE_ADRENALINE,
		CollectibleType.COLLECTIBLE_DARK_PRINCES_CROWN,
		CollectibleType.COLLECTIBLE_SHARD_OF_GLASS,
		CollectibleType.COLLECTIBLE_CONVERTER,
		CollectibleType.COLLECTIBLE_POTATO_PEELER,
		CollectibleType.COLLECTIBLE_LADDER,
		CollectibleType.COLLECTIBLE_BRITTLE_BONES,
	},
}

local Character = {}

--Passive items that aren't food or quest items that shouldn't give broken hearts
local function IsBlacklisted(itemID)
	local blacklist = {
		CollectibleType.COLLECTIBLE_SANGUINE_BOND,
		CollectibleType.COLLECTIBLE_HEART,
		CollectibleType.COLLECTIBLE_PLACENTA,
		CollectibleType.COLLECTIBLE_MARROW,
		CollectibleType.COLLECTIBLE_STEM_CELLS,
		CollectibleType.COLLECTIBLE_MAGIC_SCAB,
		CollectibleType.COLLECTIBLE_CRACK_JACKS,
		CollectibleType.COLLECTIBLE_MAGGYS_BOW,
		CollectibleType.COLLECTIBLE_FATE,
		CollectibleType.COLLECTIBLE_TRANSCENDENCE,
		CollectibleType.COLLECTIBLE_CANDY_HEART,
		CollectibleType.COLLECTIBLE_EMPTY_HEART,
		CollectibleType.COLLECTIBLE_BLOOD_OATH,
		CollectibleType.COLLECTIBLE_ADRENALINE,
		CollectibleType.COLLECTIBLE_DARK_PRINCES_CROWN,
		CollectibleType.COLLECTIBLE_SHARD_OF_GLASS,
		CollectibleType.COLLECTIBLE_HEARTBREAK,
		CollectibleType.COLLECTIBLE_HOLY_GRAIL,
		CollectibleType.COLLECTIBLE_RAW_LIVER,
		CollectibleType.COLLECTIBLE_BUCKET_OF_LARD,
		CollectibleType.COLLECTIBLE_LADDER,
		CollectibleType.COLLECTIBLE_BODY,
		CollectibleType.COLLECTIBLE_BLACK_LOTUS,
		CollectibleType.COLLECTIBLE_SUPER_BANDAGE,
		CollectibleType.COLLECTIBLE_LATCH_KEY,
		CollectibleType.COLLECTIBLE_PAGEANT_BOY,
		CollectibleType.COLLECTIBLE_BOOM,
		CollectibleType.COLLECTIBLE_QUARTER,
		--Fiend Folio items
		Isaac.GetItemIdByName("Tea"),
		Isaac.GetItemIdByName("Bacon Grease"),
		Isaac.GetItemIdByName(">3"),
		--Retribution items
		Isaac.GetItemIdByName("Brunch"),
		Isaac.GetItemIdByName("Hundred Dollar Steak"),
		Isaac.GetItemIdByName("Philosopher's Stone"),
		Isaac.GetItemIdByName("Bucket of Blood"),
		Isaac.GetItemIdByName("Silver Charm"),
	}
	
	for i = 1, #blacklist do
		if itemID == blacklist[i] then
			return true
		end
	end
	return false
end

local function IsTaintedTreasureRoom(roomDesc)
	if roomDesc
	and roomDesc.Data
	and roomDesc.Data.Type == RoomType.ROOM_DICE
	and roomDesc.Data.Variant >= 12000
	and roomDesc.Data.Variant <= 12050
	then
		return true
	else
		return false
	end
end

function Character.evaluateCache(player, cacheFlag)
	if player:GetPlayerType() ~= Enums.Characters.T_MASTEMA then return end

	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		player.Damage = player.Damage + Stats.DMG
	end
	if cacheFlag == CacheFlag.CACHE_FIREDELAY then
		player.MaxFireDelay = player.MaxFireDelay * Stats.Tears
	end
	if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
		player.ShotSpeed = player.ShotSpeed + Stats.ShotSpeed
	end
	if cacheFlag == CacheFlag.CACHE_RANGE then
		player.TearRange = player.TearRange + Stats.Range
	end
	if cacheFlag == CacheFlag.CACHE_SPEED then
		player.MoveSpeed = player.MoveSpeed + Stats.Speed
	end
	if cacheFlag == CacheFlag.CACHE_LUCK then
		player.Luck = player.Luck + Stats.Luck
	end
	if cacheFlag == CacheFlag.CACHE_FLYING
	and Stats.Fly
	then
		player.CanFly = true
	end
	if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
		player.TearColor = Stats.TearColor
		player.LaserColor = Stats.TearColor
	end

	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
		local numBrokenHearts = player:GetBrokenHearts()

		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
				player.Damage = player.Damage + (0.25 * numBrokenHearts * 0.2)
			elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
				player.Damage = player.Damage + (0.25 * numBrokenHearts * 0.3)
			elseif player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
				player.Damage = player.Damage + (0.25 * numBrokenHearts * 0.8)
			else
				player.Damage = player.Damage + (0.25 * numBrokenHearts)
			end
		end
		
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = Functions.TearsUp(player.MaxFireDelay, 0.18 * numBrokenHearts)
		end
		
		if cacheFlag == CacheFlag.CACHE_RANGE then
			player.TearRange = player.TearRange + (15 * numBrokenHearts)
		end
	end
end

function Character.postPlayerInit(player)
	if game:GetFrameCount() > 0 then return end
	if player:GetPlayerType() ~= Enums.Characters.T_MASTEMA then return end

	local lordPit = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT)

	for i = 1, #Blacklist.Items do
		itemPool:RemoveCollectible(Blacklist.Items[i])
	end

	player:AddNullCostume(horns)
	player:AddCostume(lordPit)
end

function Character.postNewRoom()
	local room = game:GetRoom()
	local level = game:GetLevel()
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:GetPlayerType() ~= Enums.Characters.T_MASTEMA then return end

		local tempEffects = player:GetEffects()

		if not tempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_INNER_EYE) then
			tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_INNER_EYE, false, 1)
		end

		if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		and player:GetBrokenHearts() == 11
		and not tempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE)
		then
			tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, true, 1)
		end

		if level:GetCurrentRoomIndex() == GridRooms.ROOM_GENESIS_IDX then
			local lordPit = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT)
			player:AddNullCostume(horns)
			player:AddCostume(lordPit)
		end

		if not room:IsFirstVisit() then return end
		
		--Chance for slot machines to be converted into a Confessional
		if room:GetType() ~= RoomType.ROOM_ARCADE then
			local slot = Isaac.FindByType(EntityType.ENTITY_SLOT, -1)

			if #slot > 0 then
				for i = 1, #slot do
					rng:SetSeed(slot[i].InitSeed, 35)
					local randNum = rng:RandomInt(20)
					
					if (slot[i].Variant == 1 or slot[i].Variant == 2 or slot[i].Variant == 3)
					and randNum < 3
					then
						local pos = slot[i].Position
						slot[i]:Remove()
						Isaac.Spawn(EntityType.ENTITY_SLOT, 17, 0, pos, Vector.Zero, nil)
					end
				end
			end
		end
	end
end

function Character.postNewLevel()
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:GetPlayerType() ~= Enums.Characters.T_MASTEMA then return end

		newFloor = true

		if player:GetBrokenHearts() > 0 then
			player:AddBrokenHearts(-1)
			sfx:Play(SoundEffect.SOUND_THUMBSUP)
			sfx:Play(SoundEffect.SOUND_DEATH_CARD)
		end
	end
end

function Character.entityTakeDmg(target, amount, flag, source, countdown)
	local player = target:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.T_MASTEMA then return end
	if flag & DamageFlag.DAMAGE_SPIKES ~= DamageFlag.DAMAGE_SPIKES then return end

	local room = game:GetRoom()

	if room:GetType() == RoomType.ROOM_SACRIFICE
	or room:GetType() == RoomType.ROOM_DEVIL
	or game:IsGreedMode()
	then
		local numBrokenHearts = player:GetBrokenHearts()
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_SANGUINE_BOND)
		local randNum = rng:RandomInt(100)
		
		--Percent chance is based on the number of broken hearts Tainted Mastema currently has
		if randNum < ((numBrokenHearts * 6) + 30)
		and numBrokenHearts > 0
		then
			player:AddBrokenHearts(-1)
			sfx:Play(SoundEffect.SOUND_THUMBSUP)
			sfx:Play(SoundEffect.SOUND_DEATH_CARD)
		end
		
		if randNum < 33 then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_COUPON, false)
		end
	end
end

function Character.postPickupInit(pickup)
	if pickup.Variant ~= PickupVariant.PICKUP_HEART then return end
	
	rng:SetSeed(pickup.InitSeed, 35)

	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:GetPlayerType() ~= Enums.Characters.T_MASTEMA then return end

		local randNum = rng:RandomInt(3)
		
		if randNum == 0
		and pickup.Price == 0
		then
			if pickup.SubType == HeartSubType.HEART_FULL
			or pickup.SubType == HeartSubType.HEART_SCARED
			or pickup.SubType == HeartSubType.HEART_DOUBLEPACK
			then
				pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, true, false, false)
			elseif pickup.SubType == HeartSubType.HEART_HALF then
				pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, true, false, false)
			end
		end

		--No patched hearts for you
		if pickup.SubType == 3320
		or pickup.SubType == 3321
		then
			pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, true, false, false)
		end
	end
end

function Character.postPickupUpdate(pickup)
	if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
	if pickup.Price ~= PickupPrice.PRICE_THREE_SOULHEARTS then return end

	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:GetPlayerType() ~= Enums.Characters.T_MASTEMA then return end
		
		local itemID = pickup.SubType
		local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
		
		--Passive devil deals only cost 1 soul heart
		if itemConfig.Type ~= ItemType.ITEM_ACTIVE then
			pickup.Price = PickupPrice.PRICE_ONE_SOUL_HEART
			pickup.AutoUpdatePrice = false
		end
	end
end

function Character.prePickupCollision(pickup, collider, low)
	if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
	if pickup.SubType == 0 then return end
	
	local player = collider:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.T_MASTEMA then return end
	if not Functions.CanPickUpItem(player, pickup) then return end

	local level = game:GetLevel()
	local roomIndex = level:GetCurrentRoomIndex()
	local roomDesc = level:GetCurrentRoomDesc()
	local soulHearts = player:GetSoulHearts() / 2
	local totalHearts = soulHearts + player:GetBrokenHearts()
	local itemID = pickup.SubType
	local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
	local quality = itemConfig.Quality
	
	--Passive items cost broken hearts based on item quality
	if itemConfig.Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST
	and itemConfig.Tags & ItemConfig.TAG_FOOD ~= ItemConfig.TAG_FOOD
	and itemConfig.Type ~= ItemType.ITEM_ACTIVE
	and not IsBlacklisted(itemID)
	and roomIndex ~= GridRooms.ROOM_GENESIS_IDX
	and Functions.GetDimension(roomDesc) ~= 2
	and not IsTaintedTreasureRoom(roomDesc)
	then
		if quality <= 1 then
			player:AddBrokenHearts(1)
		elseif quality == 2
		or quality == 3
		then
			player:AddBrokenHearts(2)
		elseif quality > 3 then
			player:AddBrokenHearts(3)
		end
	end
	
	--Fix devil deals taking more hearts than normal when at a certain number of total hearts
	if itemConfig.Type ~= ItemType.ITEM_ACTIVE
	and pickup.Price == PickupPrice.PRICE_ONE_SOUL_HEART
	and totalHearts > 10
	and soulHearts > 1
	and pickup.Wait == 0
	and not player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE)
	then
		local soulHeart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, player.Position, Vector.Zero, nil)
		local sprite = soulHeart:GetSprite()
		sprite:Play("Idle")
		soulHeart.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
	end
end

function Character.postLaserUpdate(laser)
	if laser.SpawnerEntity == nil then return end
	if laser.SpawnerType ~= EntityType.ENTITY_PLAYER then return end

	local player = laser.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.T_MASTEMA then return end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then return end

	local color = Color(1, 0, 1, 1, 0, 0, 0)
	local sprite = laser:GetSprite()

	color:SetColorize(4, 0, 4, 1)
	sprite.Color = color

	if laser.Child then
		local impactSprite = laser.Child:GetSprite()
		impactSprite.Color = color
	end
end

function Character.postPEffectUpdate(player)
	if player:GetPlayerType() ~= Enums.Characters.T_MASTEMA then return end

	--Fix demon wings turning into angel wings when flying over grid objects
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_HOLY_GRAIL) then
		local holyGrail = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_HOLY_GRAIL)
		player:RemoveCostume(holyGrail)
	end

	if player:GetBrokenHearts() > 0
	and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
	then
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_RANGE)
		player:EvaluateItems()
	end
	
	if newFloor
	and player:IsExtraAnimationFinished()
	then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		and player:GetBrokenHearts() == 10
		then
			player:UseCard(Card.CARD_SOUL_AZAZEL, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
		end
		newFloor = false
	end

	if not player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
		local brimSwirl = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BRIMSTONE_SWIRL, -1)
		local techDot = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TECH_DOT, -1)
		local color = Color(1, 0, 1, 1, 0, 0, 0)
			
		if #brimSwirl > 0 then
			for i = 1, #brimSwirl do
				if brimSwirl[i].SpawnerType == EntityType.ENTITY_PLAYER then
					local sprite = brimSwirl[i]:GetSprite()
					color:SetColorize(4, 0, 4, 1)
					sprite.Color = color
				end
			end
		end
		
		if #techDot > 0 then
			for i = 1, #techDot do
				if techDot[i].SpawnerType == EntityType.ENTITY_PLAYER then
					local sprite = techDot[i]:GetSprite()
					color:SetColorize(4, 0, 4, 1)
					sprite.Color = color
				end
			end
		end
	end
end

function Character.postPlayerUpdate(player)
	if player:GetPlayerType() ~= Enums.Characters.T_MASTEMA then return end
	if player:IsCoopGhost() then return end

	local hearts = player:GetMaxHearts()
	local boneHearts = player:GetBoneHearts()
	local tempEffects = player:GetEffects()

	if hearts > 0 then
		player:AddMaxHearts(-hearts)
		player:AddSoulHearts(hearts)
	end
	
	if boneHearts > 0 then
		player:AddBoneHearts(-boneHearts)
		player:AddBlackHearts(boneHearts * 2)
	end

	if not tempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_INNER_EYE) then
		tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_INNER_EYE, false, 1)
	end

	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
	and player:GetBrokenHearts() == 11
	and not tempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE)
	then
		tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, true, 1)
	end
end

function Character.postRender()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomIndex = level:GetCurrentRoomIndex()
	local roomDesc = level:GetCurrentRoomDesc()
	
	if room:GetFrameCount() == 0 then return end
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:GetPlayerType() ~= Enums.Characters.T_MASTEMA then return end
		
		local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
		local renderCount
		
		for _, j in pairs(items) do
			if j.SubType > 0 then
				local collectible = j:ToPickup()
				local itemID = collectible.SubType
				local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
				local quality = itemConfig.Quality
				
				if itemConfig.Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST
				and itemConfig.Tags & ItemConfig.TAG_FOOD ~= ItemConfig.TAG_FOOD
				and itemConfig.Type ~= ItemType.ITEM_ACTIVE
				and not IsBlacklisted(itemID)
				and roomIndex ~= GridRooms.ROOM_GENESIS_IDX
				and Functions.GetDimension(roomDesc) ~= 2
				and not IsTaintedTreasureRoom(roomDesc)
				then
					if quality <= 1 then
						renderCount = 1
					elseif quality == 2
					or quality == 3
					then
						renderCount = 2
					elseif quality > 3 then
						renderCount = 3
					end
					Functions.RenderBrokenCost(collectible, renderCount)
				end
			end
		end
	end
end

function Character.preUseItem(item, rng, player, flags, activeSlot, customVarData)
	if player:GetPlayerType() ~= Enums.Characters.T_MASTEMA then return end
	if item ~= CollectibleType.COLLECTIBLE_CLICKER then return end
	
	player:TryRemoveNullCostume(horns)
end

function Character.useItem(item, rng, player, flags, activeSlot, customVarData)
	if player:GetPlayerType() ~= Enums.Characters.T_MASTEMA then return end

	if item == CollectibleType.COLLECTIBLE_D4
	or item == CollectibleType.COLLECTIBLE_D100
	then
		local lordPit = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT)
		player:AddNullCostume(horns)
		player:AddCostume(lordPit)
	end
end

return Character