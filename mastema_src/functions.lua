local Enums = require("mastema_src.enums")
local SaveData = require("mastema_src.savedata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local KnownFilePathsByName = {
	["resources/scripts/"] = true
}

local KnownFilePathsByIndex = {
	"resources/scripts/"
}

local BrokenHeartIcon = Sprite()

local Functions = {}

function Functions.postGameStarted(isContinue)
	if CustomHealthAPI then
		BrokenHeartIcon:Load("gfx/ui/CustomHealthAPI/hearts.anm2", true)
	else
		BrokenHeartIcon:Load("gfx/ui/ui_hearts.anm2", true)
	end
end

--Lemegeton wisp functions originally made by Aevilok, tweaked by me
function Functions.AddInnateItem(player, collectibleID, removeCostume)
	if removeCostume == nil then
		removeCostume = false
	end
	
	local itemWisp = player:AddItemWisp(collectibleID, Vector.Zero, true)

    itemWisp:RemoveFromOrbit()
    itemWisp:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    itemWisp.Visible = false
    itemWisp.CollisionDamage = 0
	itemWisp.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	itemWisp:GetData().mastemaWisp = true

	if removeCostume then
		local itemConfig = Isaac.GetItemConfig():GetCollectible(collectibleID)
		player:RemoveCostume(itemConfig)
	end

    return itemWisp
end

function Functions.HasInnateItem(collectibleID)
	local itemWisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP, collectibleID)

	if #itemWisps == 0 then return false end
	
	for _, wisp in pairs(itemWisps) do
		if wisp:GetData().mastemaWisp then
            return true
        end
    end
	return false
end

function Functions.RemoveInnateItem(collectibleID)
    local itemWisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP, collectibleID)
	
    if #itemWisps == 0 then return end

	for _, wisp in pairs(itemWisps) do
		if wisp:GetData().mastemaWisp then
			wisp:Remove()
			wisp:Kill()
		end
	end
end

function Functions.AnyPlayerHasCollectible(itemID, ignoreModifiers)
	if ignoreModifiers == nil then
		ignoreModifiers = false
	end
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:HasCollectible(itemID, ignoreModifiers) then
			return true
		end
	end

	return false
end

function Functions.AnyPlayerIsType(playerType)
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:GetPlayerType() == playerType then
			return true
		end
	end

	return false
end

function Functions.CanPickEternalHearts(player)
	local eternalHearts = player:GetEternalHearts()
    local maxHearts = player:GetMaxHearts()
    local heartLimit = player:GetHeartLimit()
	
	if eternalHearts > 0
	and maxHearts == heartLimit
	then
		return false
	end

	return true
end

--Function provided by KingBobson. Prevents PRE_PICKUP_COLLISION from being executed multiple times when colliding with a pedestal item
function Functions.CanPickUpItem(player, pickup)
    if pickup.SubType == CollectibleType.COLLECTIBLE_NULL then return false end
    if player.ItemHoldCooldown > 0 then return false end
    if player:IsHoldingItem() then return false end
    if pickup.Wait > 0 then return false end
	if not player:IsExtraAnimationFinished() then return false end
	
	if pickup.Price > 0 and player:GetNumCoins() < pickup.Price then return false end
	if pickup.Price == PickupPrice.PRICE_ONE_HEART and player:GetEffectiveMaxHearts() < 2 then return false end
    if pickup.Price == PickupPrice.PRICE_TWO_HEARTS and player:GetEffectiveMaxHearts() < 2 then return false end
    if pickup.Price == PickupPrice.PRICE_THREE_SOULHEARTS and player:GetSoulHearts() < 1 then return false end
    if pickup.Price == PickupPrice.PRICE_TWO_SOUL_HEARTS and player:GetSoulHearts() < 1 then return false end
    if pickup.Price == PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART and player:GetSoulHearts() < 1 then return false end
    if pickup.Price == PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS and player:GetEffectiveMaxHearts() < 2 then return false end

	return true
end

--returns the path to the current mod
function Functions.GetCurrentModPath()
	--use some very hacky trickery to get the path to this mod
	local _, err = pcall(require, "")
	local _, basePathStart = string.find(err, "no file '", 1)
	local _, modPathStart = string.find(err, "no file '", basePathStart)
	local modPathEnd, _ = string.find(err, ".lua'", modPathStart)
	local modPath = string.sub(err, modPathStart+1, modPathEnd-1)
	modPath = string.gsub(modPath, "\\", "/")
	
	if not KnownFilePathsByName[modPath] then
		KnownFilePathsByName[modPath] = true
		table.insert(KnownFilePathsByIndex, 2, modPath)
	end
	
	return modPath
end

--By DeadInfinity
function Functions.GetDimension(roomDesc)
	local level = game:GetLevel()
    local desc = roomDesc or level:GetCurrentRoomDesc()
    local hash = GetPtrHash(desc)
    for dimension = 0, 2 do
        local dimensionDesc = level:GetRoomByIdx(desc.SafeGridIndex, dimension)
        if GetPtrHash(dimensionDesc) == hash then
            return dimension
        end
    end
end

function Functions.HasFullCompletion(mastema)
	local marks
	
	if mastema == Enums.Characters.MASTEMA then
		marks = SaveData.UnlockData.Mastema
	elseif mastema == Enums.Characters.T_MASTEMA then
		marks = SaveData.UnlockData.T_Mastema
	end
	
	for _, val in pairs(marks) do
		if not val then
			return false
		end
	end
	
	return true
end

function Functions.IsInvulnerableEnemy(npc)
	local blacklist = {
		EntityType.ENTITY_STONEY,
		EntityType.ENTITY_STONEHEAD,
		EntityType.ENTITY_CONSTANT_STONE_SHOOTER,
		EntityType.ENTITY_BROKEN_GAPING_MAW,
		EntityType.ENTITY_DEATHS_HEAD,
		EntityType.ENTITY_DUSTY_DEATHS_HEAD,
		EntityType.ENTITY_POKY,
		EntityType.ENTITY_WALL_HUGGER,
		EntityType.ENTITY_GRUDGE,
		EntityType.ENTITY_FROZEN_ENEMY,
	}
	
	for i = 1, #blacklist do
		if npc.Type == blacklist[i] then
			return true
		end
	end
	return false
end

function Functions.IsSoulHeartCharacter(player)
	local chars = {
		PlayerType.PLAYER_BLUEBABY,
		PlayerType.PLAYER_BLUEBABY_B,
		PlayerType.PLAYER_BLACKJUDAS,
		PlayerType.PLAYER_JUDAS_B,
		PlayerType.PLAYER_THESOUL,
		PlayerType.PLAYER_BETHANY_B,
		PlayerType.PLAYER_THEFORGOTTEN_B,
		PlayerType.PLAYER_THESOUL_B,
	}

	for i = 1, #chars do
		if player:GetPlayerType() == chars[i] then
			return true
		end
	end
	
	return false
end

function Functions.PlayVoiceline(voiceline, flag, randNum)
	if flag & UseFlag.USE_MIMIC == UseFlag.USE_MIMIC then return end

	if Options.AnnouncerVoiceMode == 2
	or (Options.AnnouncerVoiceMode == 0 and randNum == 0)
	then
		sfx:Play(voiceline)
	end
end

--Displays the broken heart cost of items for T. Mastema or for the broken item from Shattered Soul
function Functions.RenderBrokenCost(collectible, renderCount)
	BrokenHeartIcon:SetFrame("BrokenHeart", 0)
	
	if renderCount == 1 then
		if collectible.Price ~= 0 then
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(0, -41)), Vector.Zero, Vector.Zero)
		else
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(0, -69)), Vector.Zero, Vector.Zero)
		end
	elseif renderCount == 2 then
		if collectible.Price ~= 0 then
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(11, -41)), Vector.Zero, Vector.Zero)
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(-11, -41)), Vector.Zero, Vector.Zero)
		else
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(11, -69)), Vector.Zero, Vector.Zero)
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(-11, -69)), Vector.Zero, Vector.Zero)
		end
	elseif renderCount == 3 then
		if collectible.Price ~= 0 then
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(13, -53)), Vector.Zero, Vector.Zero)
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(-13, -53)), Vector.Zero, Vector.Zero)
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(0, -41)), Vector.Zero, Vector.Zero)
		else
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(13, -82)), Vector.Zero, Vector.Zero)
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(-13, -82)), Vector.Zero, Vector.Zero)
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(0, -69)), Vector.Zero, Vector.Zero)
		end
	elseif renderCount == 4 then
		if collectible.Price ~= 0 then
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(11, -41)), Vector.Zero, Vector.Zero)
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(-11, -41)), Vector.Zero, Vector.Zero)
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(32, -41)), Vector.Zero, Vector.Zero)
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(-32, -41)), Vector.Zero, Vector.Zero)
		else
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(11, -69)), Vector.Zero, Vector.Zero)
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(-11, -69)), Vector.Zero, Vector.Zero)
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(32, -69)), Vector.Zero, Vector.Zero)
			BrokenHeartIcon:Render(Isaac.WorldToScreen(collectible.Position + Vector(-32, -69)), Vector.Zero, Vector.Zero)
		end
	end
end

function Functions.TearsUp(firedelay, val)
	local currentTears = 30 / (firedelay + 1)
	local newTears = currentTears + val
	return math.max((30 / newTears) - 1, -0.9999)
end

return Functions