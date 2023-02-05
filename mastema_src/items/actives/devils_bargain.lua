local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local SaveData = require("mastema_src.savedata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()
local MAX_CHARGE = 12
local waveCount = 0
local waveChanged = false

local Item = {}

local function ChargeDevilsBargain(player, numCharges)
	local activeSlot
	local curCharge
	local newCharge
	
	for i = 0, 2 do
		if player:GetActiveItem(i) == Enums.Collectibles.DEVILS_BARGAIN then
			activeSlot = i
		end
	end
	
	if activeSlot == nil then return end

	curCharge = player:GetActiveCharge(activeSlot) + player:GetBatteryCharge(activeSlot)
	
	if curCharge < MAX_CHARGE
	or (player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) and curCharge < MAX_CHARGE * 2)
	then
		newCharge = curCharge + numCharges
		
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY)
		and newCharge > MAX_CHARGE * 2
		then
			newCharge = MAX_CHARGE * 2
		elseif not player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY)
		and newCharge > MAX_CHARGE
		then
			newCharge = MAX_CHARGE
		end
		
		player:SetActiveCharge(newCharge, activeSlot)
		game:GetHUD():FlashChargeBar(player, activeSlot)

		if (curCharge < MAX_CHARGE and newCharge >= MAX_CHARGE)
		or (curCharge < MAX_CHARGE * 2 and curCharge >= MAX_CHARGE and newCharge == MAX_CHARGE * 2)
		then
			sfx:Play(SoundEffect.SOUND_ITEMRECHARGE)
		elseif newCharge < MAX_CHARGE then
			sfx:Play(SoundEffect.SOUND_BEEP)
		end
	end
end

function Item.useItem(item, rng, player, flags, activeSlot, customVarData)
	if item ~= Enums.Collectibles.DEVILS_BARGAIN then return end
	
	local room = game:GetRoom()
	local roomType = room:GetType()
	local seed = rng:RandomInt(999999999)
	local pool = game:GetItemPool():GetPoolForRoom(roomType, seed)
	local maxRedHearts = player:GetEffectiveMaxHearts()

	if player:HasCollectible(CollectibleType.COLLECTIBLE_9_VOLT) then
		local slot
		local curCharge
		
		for i = 0, 2 do
			if player:GetActiveItem(i) == Enums.Collectibles.SINGULARITY then
				slot = i
			end
		end
		curCharge = player:GetActiveCharge(slot) + player:GetBatteryCharge(slot)
		
		if curCharge == MAX_CHARGE then
			player:AddCollectible(CollectibleType.COLLECTIBLE_BATTERY)
			ChargeDevilsBargain(player, 1)
			player:RemoveCollectible(CollectibleType.COLLECTIBLE_BATTERY)
		end
	end
	
	if pool == ItemPoolType.POOL_NULL then
		if game:IsGreedMode() then
			pool = ItemPoolType.POOL_GREED_TREASURE
		else
			pool = ItemPoolType.POOL_TREASURE
		end
	end
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) then
		pool = rng:RandomInt(ItemPoolType.NUM_ITEMPOOLS)
	end
	
	local collectible = game:GetItemPool():GetCollectible(pool, false, seed)
	local itemConfig = Isaac.GetItemConfig():GetCollectible(collectible)
	
	--Loop until a passive item is chosen
	while itemConfig.Type == ItemType.ITEM_ACTIVE do
		seed = rng:RandomInt(999999999)
		collectible = game:GetItemPool():GetCollectible(pool, false, seed)
		itemConfig = Isaac.GetItemConfig():GetCollectible(collectible)
	end

	SaveData.ItemData.DevilsBargain.BargainItem = collectible
	player:AddCollectible(collectible)
	sfx:Play(SoundEffect.SOUND_DEVILROOM_DEAL)
	
	if player:GetPlayerType() == PlayerType.PLAYER_THELOST
	or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
	then
		player:RemoveCollectible(Enums.Collectibles.DEVILS_BARGAIN)
	elseif maxRedHearts > 0
	and not Functions.IsSoulHeartCharacter(player)
	then
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
			player:SetActiveCharge(MAX_CHARGE, i)
		end
	end
end

function Item.preSpawnCleanAward()
	if not Functions.AnyPlayerHasCollectible(Enums.Collectibles.DEVILS_BARGAIN) then return end

	local room = game:GetRoom()
	local roomShape = room:GetRoomShape()
	local level = game:GetLevel()
	local roomIndex = level:GetCurrentRoomIndex()
	local startRoomIndex = level:GetStartingRoomIndex()

	if not game:IsGreedMode()
	or (game:IsGreedMode() and roomIndex ~= startRoomIndex)
	then
		for i = 0, game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)

			if player:HasCollectible(Enums.Collectibles.DEVILS_BARGAIN) then
				if roomShape >= RoomShape.ROOMSHAPE_2x2 then
					ChargeDevilsBargain(player, 2)
				else
					ChargeDevilsBargain(player, 1)
				end
			end
		end
	end
end

function Item.postPEffectUpdate(player)
	if not player:HasCollectible(Enums.Collectibles.DEVILS_BARGAIN) then return end

	local wisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP)
	
	for i = 0, 2 do
		if player:GetActiveItem(i) == Enums.Collectibles.DEVILS_BARGAIN then
			if game:IsGreedMode() then
				local level = game:GetLevel()
				local greedModeWave = level.GreedModeWave

				if waveCount ~= greedModeWave then
					if greedModeWave > 0
					and waveCount < greedModeWave
					then
						ChargeDevilsBargain(player, 1)
					end
					
					waveCount = greedModeWave
				end
			end

			if waveChanged then
				local room = game:GetRoom()

				if room:GetType() == RoomType.ROOM_BOSSRUSH then
					ChargeDevilsBargain(player, 2)
				elseif room:GetType() == RoomType.ROOM_CHALLENGE then
					ChargeDevilsBargain(player, 1)
				end

				waveChanged = false
			end
			
			if player:GetBatteryCharge(i) > 0 then
				player:SetActiveCharge(player:GetActiveCharge(i), i)
			end
			
			if player:GetActiveCharge(i) == MAX_CHARGE
			and not SaveData.ItemData.DevilsBargain.BargainReset
			then
				local itemPool = game:GetItemPool()

				if SaveData.ItemData.DevilsBargain.RedHearts > 0
				or SaveData.ItemData.DevilsBargain.SoulHearts > 0
				then
					sfx:Play(SoundEffect.SOUND_THUMBSUP)
				end

				for _, wisp in pairs(wisps) do
					if wisp.HitPoints < wisp.MaxHitPoints then
						wisp.HitPoints = wisp.MaxHitPoints
					end
				end
				
				player:AddMaxHearts(SaveData.ItemData.DevilsBargain.RedHearts)
				player:AddHearts(SaveData.ItemData.DevilsBargain.RedHearts)
				player:AddSoulHearts(SaveData.ItemData.DevilsBargain.SoulHearts)
				itemPool:RemoveCollectible(SaveData.ItemData.DevilsBargain.BargainItem)

				SaveData.ItemData.DevilsBargain.IsCharging = false
				SaveData.ItemData.DevilsBargain.BargainItem = 0
				SaveData.ItemData.DevilsBargain.BargainReset = true

				break
			end
		end
	end
end

--Boss rush/challenge room wave change detector function by kittenchilly
function Item.postNPCInit(npc)
	local room = game:GetRoom()

	if not room:IsAmbushActive() then return end
	if not npc.CanShutDoors then return end
	if npc.SpawnerEntity then return end
	if npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or npc:HasEntityFlags(EntityFlag.FLAG_PERSISTENT) or npc:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then return end

	local preventCounting

	for _, entity in ipairs(Isaac.FindInRadius(room:GetCenterPos(), 1000, EntityPartition.ENEMY)) do
		if entity:ToNPC()
		and entity:CanShutDoors()
		and not (entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or entity:HasEntityFlags(EntityFlag.FLAG_PERSISTENT) or entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET))
		and entity.FrameCount ~= npc.FrameCount
		then
			preventCounting = true
			break
		end
	end

	if not preventCounting then
		waveChanged = true
	end
end

return Item