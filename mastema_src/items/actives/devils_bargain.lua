local Enums = require("mastema_src.enums")
local SaveData = require("mastema_src.savedata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local Item = {}

function Item.useItem(item, rng, player, flags, activeSlot, customVarData)
	if item ~= Enums.Collectibles.DEVILS_BARGAIN then return end
	
	local room = game:GetRoom()
	local roomType = room:GetType()
	local seed = game:GetSeeds():GetStartSeed()
	local pool = game:GetItemPool():GetPoolForRoom(roomType, seed)
	local maxRedHearts = player:GetEffectiveMaxHearts()
	
	if pool == ItemPoolType.POOL_NULL then
		if game:IsGreedMode() then
			pool = ItemPoolType.POOL_GREED_TREASURE
		else
			pool = ItemPoolType.POOL_TREASURE
		end
	end
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) then
		pool = rng:RandomInt(ItemPoolType.NUM_ITEMPOOLS)
		seed = rng:RandomInt(999999999)
	end
	
	local collectible = game:GetItemPool():GetCollectible(pool, true, seed)
	local itemConfig = Isaac.GetItemConfig():GetCollectible(collectible)
	
	--Loop until a passive item is chosen
	while itemConfig.Type == ItemType.ITEM_ACTIVE do
		collectible = game:GetItemPool():GetCollectible(pool, true, seed)
		itemConfig = Isaac.GetItemConfig():GetCollectible(collectible)
	end

	SaveData.ItemData.DevilsBargain.BargainItem = collectible
	player:AddCollectible(collectible)
	sfx:Play(SoundEffect.SOUND_DEVILROOM_DEAL)
	
	if player:GetPlayerType() == PlayerType.PLAYER_THELOST
	or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
	then
		player:RemoveCollectible(Enums.Collectibles.DEVILS_BARGAIN)
	elseif maxRedHearts > 0 then
		if itemConfig.Quality > 2 then
			if maxRedHearts >= 4 then
				player:AddMaxHearts(-4)
				SaveData.ItemData.DevilsBargain.RedHearts = 4
				SaveData.ItemData.DevilsBargain.SoulHearts = 0
			else
				player:AddMaxHearts(-2)
				player:AddSoulHearts(-4)
				SaveData.ItemData.DevilsBargain.RedHearts = 2
				SaveData.ItemData.DevilsBargain.SoulHearts = 4
			end
		else
			player:AddMaxHearts(-2)
			SaveData.ItemData.DevilsBargain.RedHearts = 2
			SaveData.ItemData.DevilsBargain.SoulHearts = 0
		end
	else
		if player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY then
			if itemConfig.Quality > 2 then
				player:AddSoulHearts(-4)
				SaveData.ItemData.DevilsBargain.SoulHearts = 4
			else
				player:AddSoulHearts(-2)
				SaveData.ItemData.DevilsBargain.SoulHearts = 2
			end
		else
			player:AddSoulHearts(-6)
			SaveData.ItemData.DevilsBargain.SoulHearts = 6
		end
		SaveData.ItemData.DevilsBargain.RedHearts = 0
	end
	
	if player:GetPlayerType() ~= PlayerType.PLAYER_THELOST
	and player:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B
	then
		SaveData.ItemData.DevilsBargain.IsCharging = true
		SaveData.ItemData.DevilsBargain.BargainReset = false
	end
	
	return true
end

function Item.entityTakeDmg(target, amount, flag, source, countdown)
	local player = target:ToPlayer()

	if player == nil then return end
	if not SaveData.ItemData.DevilsBargain.IsCharging then return end
	if flag & DamageFlag.DAMAGE_RED_HEARTS == DamageFlag.DAMAGE_RED_HEARTS then return end
	if flag & DamageFlag.DAMAGE_SPIKES == DamageFlag.DAMAGE_SPIKES then return end
	if flag & DamageFlag.DAMAGE_CURSED_DOOR == DamageFlag.DAMAGE_CURSED_DOOR then return end
	if flag & DamageFlag.DAMAGE_IV_BAG == DamageFlag.DAMAGE_IV_BAG then return end
	if flag & DamageFlag.DAMAGE_CHEST == DamageFlag.DAMAGE_CHEST then return end
	if flag & DamageFlag.DAMAGE_FAKE == DamageFlag.DAMAGE_FAKE then return end
	if not player:HasCollectible(SaveData.ItemData.DevilsBargain.BargainItem) then return end
	
	player:RemoveCollectible(SaveData.ItemData.DevilsBargain.BargainItem)
	sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
	sfx:Play(SoundEffect.SOUND_SATAN_GROW)
	SaveData.ItemData.DevilsBargain.RedHearts = 0
	SaveData.ItemData.DevilsBargain.SoulHearts = 0
	SaveData.ItemData.DevilsBargain.IsCharging = false
	
	for i = 0, 2 do
		if player:GetActiveItem(i) == Enums.Collectibles.DEVILS_BARGAIN then
			player:SetActiveCharge(12, i)
		end
	end
end

function Item.postPEffectUpdate(player)
	if not player:HasCollectible(Enums.Collectibles.DEVILS_BARGAIN) then return end
	
	for i = 0, 2 do
		if player:GetActiveItem(i) == Enums.Collectibles.DEVILS_BARGAIN
		and player:GetActiveCharge(i) == 12
		and not SaveData.ItemData.DevilsBargain.BargainReset
		then
			if SaveData.ItemData.DevilsBargain.RedHearts > 0
			or SaveData.ItemData.DevilsBargain.SoulHearts > 0
			then
				sfx:Play(SoundEffect.SOUND_THUMBSUP)
			end
			
			player:AddMaxHearts(SaveData.ItemData.DevilsBargain.RedHearts)
			player:AddHearts(SaveData.ItemData.DevilsBargain.RedHearts)
			player:AddSoulHearts(SaveData.ItemData.DevilsBargain.SoulHearts)

			SaveData.ItemData.DevilsBargain.IsCharging = false
			SaveData.ItemData.DevilsBargain.BargainItem = 0
			SaveData.ItemData.DevilsBargain.BargainReset = true

			break
		end
	end
end

return Item