local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local game = Game()
local rng = RNG()

local flightItems = {
	CollectibleType.COLLECTIBLE_FATE,
	CollectibleType.COLLECTIBLE_HOLY_GRAIL,
	CollectibleType.COLLECTIBLE_TRANSCENDENCE,
	CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT,
	CollectibleType.COLLECTIBLE_DEAD_DOVE,
	CollectibleType.COLLECTIBLE_SPIRIT_OF_THE_NIGHT,
	CollectibleType.COLLECTIBLE_REVELATION,
	CollectibleType.COLLECTIBLE_PONY,
	CollectibleType.COLLECTIBLE_WHITE_PONY,
}

local collectibleEffects = {
	CollectibleType.COLLECTIBLE_TRANSCENDENCE,
	CollectibleType.COLLECTIBLE_EMPTY_VESSEL,
}

local transformations = {
	PlayerForm.PLAYERFORM_GUPPY,
	PlayerForm.PLAYERFORM_LORD_OF_THE_FLIES,
	PlayerForm.PLAYERFORM_ANGEL,
	PlayerForm.PLAYERFORM_EVIL_ANGEL,
}

local nullItems = {
	NullItemID.ID_REVERSE_SUN,
	NullItemID.ID_REVERSE_DEVIL,
	NullItemID.ID_ESAU_JR,
	NullItemID.ID_SPIRIT_SHACKLES_SOUL,
	NullItemID.ID_LOST_CURSE,
}

local Item = {}

local function IsFlyingChar(player)
	if player:GetPlayerType() == PlayerType.PLAYER_AZAZEL
	or player:GetPlayerType() == PlayerType.PLAYER_THELOST
	or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
	or player:GetPlayerType() == PlayerType.PLAYER_JACOB2_B
	or player:GetPlayerType() == PlayerType.PLAYER_THESOUL
	or player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B
	or player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B
	or player:GetPlayerType() == Enums.Characters.T_MASTEMA
	then
		return true
	end
	return false
end

function Item.evaluateCache(player, cacheFlag)
	if not player:HasCollectible(Enums.Collectibles.TORN_WINGS) then return end
	
	local level = game:GetLevel()
	local tempEffects = player:GetEffects()
	local tearBonus = 0
	local bibleUses = tempEffects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BIBLE)

	if IsFlyingChar(player) then
		tearBonus = tearBonus + 1
	end
	
	for i = 1, #flightItems do
		if player:HasCollectible(flightItems[i]) then
			tearBonus = tearBonus + player:GetCollectibleNum(flightItems[i])
		end
	end

	for i = 1, #collectibleEffects do
		if tempEffects:HasCollectibleEffect(collectibleEffects[i]) then
			tearBonus = tearBonus + 1
		end
	end
	
	for i = 1, #transformations do
		if player:HasPlayerForm(transformations[i]) then
			tearBonus = tearBonus + 1
		end
	end

	if player:GetData().hasSpode
	and tempEffects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_TRANSCENDENCE) > 1
	then
		tearBonus = tearBonus + 1
	end

	for i = 1, #nullItems do
		if tempEffects:HasNullEffect(nullItems[i]) then
			tearBonus = tearBonus + 1
		end
	end
	
	if tempEffects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION) == 1 then
		tearBonus = tearBonus + 1
	end
	
	tearBonus = tearBonus + bibleUses
	
	if cacheFlag == CacheFlag.CACHE_FIREDELAY then
		player.MaxFireDelay = Functions.TearsUp(player.MaxFireDelay, 0.33 * tearBonus)
	end
	
	if cacheFlag == CacheFlag.CACHE_FLYING
	and level:GetStage() ~= LevelStage.STAGE8
	then
		player.CanFly = false
	end
end

function Item.preGetCollectible(pool, decrease, seed)
	if not Functions.AnyPlayerHasCollectible(Enums.Collectibles.TORN_WINGS) then return end
	if pool == ItemPoolType.POOL_DEVIL then return end

	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomIndex = level:GetCurrentRoomIndex()
	
	if (Functions.AnyPlayerIsType(Enums.Characters.MASTEMA) or Functions.AnyPlayerIsType(Enums.Characters.MASTEMA))
	and room:GetType() == RoomType.ROOM_TREASURE
	and (not game:IsGreedMode() or (game:IsGreedMode() and roomIndex ~= 98))
	then
		return
	end
	
	rng:SetSeed(seed, 35)
	local randNum = rng:RandomInt(4)
	
	if randNum == 0 then
		local itemID = game:GetItemPool():GetCollectible(ItemPoolType.POOL_DEVIL, true, seed)
		return itemID
	end
end

function Item.postPEffectUpdate(player)
	if not player:HasCollectible(Enums.Collectibles.TORN_WINGS) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Sodom", false) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Sodom", true) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Gomorrah", false) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Gomorrah", true) then return end
	if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B then return end
	
	local level = game:GetLevel()

	if level:GetStage() ~= LevelStage.STAGE8 then
		local lordPit = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT)
		local fate = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_FATE)
		local holyGrail = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_HOLY_GRAIL)
		local transcendence = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_TRANSCENDENCE)
		
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_FLYING)
		player:EvaluateItems()
		
		player:RemoveCostume(lordPit)
		player:RemoveCostume(fate)
		player:RemoveCostume(holyGrail)
		player:RemoveCostume(transcendence)

		if Eterepheartsforeternaltransformation then
			Eterepheartsforeternaltransformation = 0
		end
	else
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_FLYING)
		player:EvaluateItems()
	end
end

return Item