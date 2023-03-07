local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local SaveData = require("mastema_src.savedata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()
local SATANIC_RITUAL = 3666
local MIN_ROOM_ID = 4666
local MAX_ROOM_ID = 4677

local roomIds = {}

for i = MIN_ROOM_ID, MAX_ROOM_ID do
	table.insert(roomIds, i)
end
--[[
if MinimapAPI then
	local RitualRoomIcon = Sprite()
	RitualRoomIcon:Load("gfx/ui/minimapapi/ritualroomicon.anm2", true)
	RitualRoomIcon:SetFrame("RitualRoom", 0)
	MinimapAPI:AddIcon("AbandonedPlanetarium", RitualRoomIcon)
end]]

local Ritual = {}

local function AddStats(num, player)
	local tempEffects = player:GetEffects()
	
	if num == 0 then
		SaveData.ItemData.SatanicRitual.DMG = SaveData.ItemData.SatanicRitual.DMG + 1 + (0.25 * (SaveData.ItemData.SatanicRitual.Level - 1))
		tempEffects:AddCollectibleEffect(Enums.Collectibles.SATANIC_RITUAL_DMG_NULL)
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:EvaluateItems()
	elseif num == 1 then
		SaveData.ItemData.SatanicRitual.Tears = SaveData.ItemData.SatanicRitual.Tears + 0.66 + (0.25 * (SaveData.ItemData.SatanicRitual.Level - 1))
		tempEffects:AddCollectibleEffect(Enums.Collectibles.SATANIC_RITUAL_TEARS_NULL)
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:EvaluateItems()
	elseif num == 2 then
		SaveData.ItemData.SatanicRitual.Luck = SaveData.ItemData.SatanicRitual.Luck + 2 + (0.5 * (SaveData.ItemData.SatanicRitual.Level - 1))
		tempEffects:AddCollectibleEffect(Enums.Collectibles.SATANIC_RITUAL_LUCK_NULL)
		player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		player:EvaluateItems()
	elseif num == 3 then
		SaveData.ItemData.SatanicRitual.Speed = SaveData.ItemData.SatanicRitual.Speed + 0.3 + (0.1 * (SaveData.ItemData.SatanicRitual.Level - 1))
		tempEffects:AddCollectibleEffect(Enums.Collectibles.SATANIC_RITUAL_SPEED_NULL)
		player:AddCacheFlags(CacheFlag.CACHE_SPEED)
		player:EvaluateItems()
	end
end

local function IsSatanicRitualRoom()
	local room = game:GetRoom()
	local roomType = room:GetType()
	local level = game:GetLevel()
	local roomDesc = level:GetCurrentRoomDesc()
	local roomConfig = roomDesc.Data

	if (roomConfig.Variant == MIN_ROOM_ID and (roomType == RoomType.ROOM_DEVIL or roomType == RoomType.ROOM_SUPERSECRET))
	or (roomType == RoomType.ROOM_SACRIFICE and roomConfig.Variant >= MIN_ROOM_ID and roomConfig.Variant <= MAX_ROOM_ID)
	then
		return true
	end

	return false
end

function Ritual.evaluateCache(player, cacheFlag)
	local tempEffects = player:GetEffects()
	
	if cacheFlag == CacheFlag.CACHE_DAMAGE
	and SaveData.ItemData.SatanicRitual.DMG > 0
	and tempEffects:HasCollectibleEffect(Enums.Collectibles.SATANIC_RITUAL_DMG_NULL)
	then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
			player.Damage = player.Damage + (SaveData.ItemData.SatanicRitual.DMG * 0.2)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
			player.Damage = player.Damage + (SaveData.ItemData.SatanicRitual.DMG * 0.3)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
			player.Damage = player.Damage + (SaveData.ItemData.SatanicRitual.DMG * 0.8)
		else
			player.Damage = player.Damage + SaveData.ItemData.SatanicRitual.DMG
		end
	end

	if cacheFlag == CacheFlag.CACHE_FIREDELAY
	and SaveData.ItemData.SatanicRitual.Tears > 0
	and tempEffects:HasCollectibleEffect(Enums.Collectibles.SATANIC_RITUAL_TEARS_NULL)
	then
		player.MaxFireDelay = Functions.TearsUp(player.MaxFireDelay, SaveData.ItemData.SatanicRitual.Tears)
	end

	if cacheFlag == CacheFlag.CACHE_LUCK
	and SaveData.ItemData.SatanicRitual.Luck > 0
	and tempEffects:HasCollectibleEffect(Enums.Collectibles.SATANIC_RITUAL_LUCK_NULL)
	then
		player.Luck = player.Luck + SaveData.ItemData.SatanicRitual.Luck
	end

	if cacheFlag == CacheFlag.CACHE_SPEED
	and SaveData.ItemData.SatanicRitual.Speed > 0
	and tempEffects:HasCollectibleEffect(Enums.Collectibles.SATANIC_RITUAL_SPEED_NULL)
	then
		player.MoveSpeed = player.MoveSpeed + SaveData.ItemData.SatanicRitual.Speed
	end
end

function Ritual.postNewLevel()
	if not SaveData.UnlockData.T_Mastema.MegaSatan then return end

	local room = game:GetRoom()
	local level = game:GetLevel()

	if level:GetStage() == LevelStage.STAGE1_1 then return end

	rng:SetSeed(room:GetDecorationSeed(), 35)
	local rooms = level:GetRooms()

	for i = rooms.Size, 0, -1 do
		local roomDesc = rooms:Get(i - 1)

		if roomDesc
		and roomDesc.Data
		and roomDesc.Data.Type == RoomType.ROOM_SACRIFICE
		then
			local randFloat = rng:RandomFloat()
			local chance = 0.05 + (game:GetDevilRoomDeals() / 100)
			
			if randFloat < chance then
				local randNum = rng:RandomInt(#roomIds) + MIN_ROOM_ID
				Isaac.ExecuteCommand("goto s.sacrifice." .. randNum)
				local data = level:GetRoomByIdx(GridRooms.ROOM_DEBUG_IDX, 0).Data
				local sacrificeDesc = level:GetRoomByIdx(roomDesc.SafeGridIndex, 0)
				sacrificeDesc.Data = data
				--[[
				if MinimapAPI then
					local roomidx = level:GetCurrentRoomIndex()
			
					if roomidx ~= GridRooms.ROOM_DEBUG_IDX then
						local roomIndex = MinimapAPI:GetRoomByIdx(roomidx)
						roomIndex.PermanentIcons = {"RitualRoom"}
					end
				end]]
				
				game:StartRoomTransition(level:GetStartingRoomIndex(), Direction.NO_DIRECTION, RoomTransitionAnim.FADE)
			end
		end
	end
end

function Ritual.postNewRoom()
	if not IsSatanicRitualRoom() then return end
	
	local room = game:GetRoom()

	if room:GetType() == RoomType.ROOM_SACRIFICE then
		game:ShowHallucination(0, BackdropType.SHEOL)
		sfx:Stop(SoundEffect.SOUND_DEATH_CARD)

		if StageAPI
		and room:IsFirstVisit()
		then
			for _, customGrid in ipairs(StageAPI.GetCustomGrids()) do
				customGrid:Remove(false)
			end
		end
	end

	if room:IsFirstVisit()
	and SaveData.UnlockData.T_Mastema.MegaSatan
	then
		local demonBeggar = Isaac.FindByType(EntityType.ENTITY_SLOT, Enums.Slots.DEVIL_BEGGAR)

		if #demonBeggar > 0 then
			local pos = demonBeggar[1].Position
			demonBeggar[1]:Remove()
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DIRT_PATCH, SATANIC_RITUAL, pos, Vector.Zero, nil)
		end
	end
end

function Ritual.postEffectInit(effect)
	if effect.Variant ~= EffectVariant.DIRT_PATCH then return end
	if effect.SubType ~= SATANIC_RITUAL then return end

	local room = game:GetRoom()
	local sprite = effect:GetSprite()
	sprite:Play("Idle1")
	
	if not room:IsFirstVisit() then return end
	
	SaveData.ItemData.SatanicRitual.Level = 1

	for i = 0, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i)

		if player:GetPlayerType() == PlayerType.PLAYER_THELOST
		or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
		then
			sprite:Play("Idle5")
			SaveData.ItemData.SatanicRitual.Level = 5
		end
	end
end

function Ritual.postEffectUpdate(effect)
	if effect.Variant ~= EffectVariant.DIRT_PATCH then return end
	if effect.SubType ~= SATANIC_RITUAL then return end
	
	local sprite = effect:GetSprite()
	local radius = 6

	if sprite:IsPlaying("Broken")
	or sprite:IsPlaying("Broken0")
	then
		return
	end

	if sprite:IsPlaying("Idle1")
	and SaveData.ItemData.SatanicRitual.Level ~= 1
	then
		if SaveData.ItemData.SatanicRitual.Level == -2 then
			sprite:Play("Broken0")
		elseif SaveData.ItemData.SatanicRitual.Level == -1 then
			sprite:Play("Broken")
		else
			sprite:Play("Idle" .. SaveData.ItemData.SatanicRitual.Level)
		end
	end

	if (sprite:IsEventTriggered("SuperJackpot") or sprite:IsEventTriggered("KnifeBreak"))
	and effect:GetData().bombed
	then
		local itemPool = game:GetItemPool()
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_SACRIFICIAL_DAGGER, effect.Position + Vector(0, 5), Vector.Zero, effect)
		itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_SACRIFICIAL_DAGGER)
		effect:GetData().bombed = false
	end

	if sprite:IsFinished("Death0") then
		sprite:Play("Broken0")
		SaveData.ItemData.SatanicRitual.Level = -2
	end
	
	for i = 1, 5 do
		if sprite:IsPlaying("Initiate" .. i) then
			radius = 500
		elseif sprite:IsFinished("Initiate" .. i) then
			if i == 5 then
				sprite:Play("Idle0")
				SaveData.ItemData.SatanicRitual.Level = 0
			else
				sprite:Play("Idle" .. (i + 1))
			end
		elseif sprite:IsFinished("Death" .. i) then
			sprite:Play("Broken")
			SaveData.ItemData.SatanicRitual.Level = -1
		end
	end

	if #Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.MAMA_MEGA_EXPLOSION) > 0 then
		for i = 0, 5 do
			if sprite:IsPlaying("Idle" .. i)
			or sprite:IsPlaying("Initiate" .. i)
			then
				sprite:Play("Death" .. i, true)
				sfx:Play(SoundEffect.SOUND_STEAM_HALFSEC)
				effect:GetData().bombed = true
			end
		end
	end

	local player = game:GetNearestPlayer(effect.Position):ToPlayer()

	for i = 0, 5 do
		if sprite:IsPlaying("Initiate" .. i) then
			local players = Isaac.FindInRadius(effect.Position, radius, EntityPartition.PLAYER)
			
			for i = 1, #players do
				if not players[i]:ToPlayer().ControlsEnabled then
					player = players[i]:ToPlayer()
				end
			end
		end
	end

	if (effect.Position - player.Position):Length() > radius then return end

	if sprite:IsEventTriggered("Prize")
	and (effect:GetData().tookHP == nil or not effect:GetData().tookHP)
	then
		local rngMax = 4

		if player.MoveSpeed == 2 then
			rngMax = 3
		end

		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_SACRIFICIAL_DAGGER)
		local randNum = rng:RandomInt(rngMax)
		
		if player:HasTrinket(Enums.Trinkets.LIFE_SAVINGS) then
			player:TryRemoveTrinket(Enums.Trinkets.LIFE_SAVINGS)
			player:TryRemoveTrinket(Enums.Trinkets.LIFE_SAVINGS + TrinketType.TRINKET_GOLDEN_FLAG)
		elseif (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B)
		and player:GetNumCoins() >= 15
		then
			player:AddCoins(-15)
		elseif player:GetEffectiveMaxHearts() > 0
		and not Functions.IsSoulHeartCharacter(player)
		then
			player:AddMaxHearts(-2)
		else
			player:AddSoulHearts(-4)
		end

		player:TakeDamage(0, DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_DEVIL | DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(player), 60)
		AddStats(randNum, player)
		sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
		player.ControlsEnabled = true
		player:GetData().ritualCooldown = 90
		effect:GetData().tookHP = true

		if player:GetPlayerType() == PlayerType.PLAYER_THELOST
		or player:GetPlayerType() == PlayerType.PLAYER_THELOST
		then
			SaveData.ItemData.SatanicRitual.Level = 0
		else
			SaveData.ItemData.SatanicRitual.Level = SaveData.ItemData.SatanicRitual.Level + 1
		end

		if player:HasCollectible(Enums.Collectibles.SACRIFICIAL_CHALICE) then
			SaveData.ItemData.SacrificialChalice.Hits = SaveData.ItemData.SacrificialChalice.Hits + 1

			local chalices = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, Enums.Familiars.SACRIFICIAL_CHALICE)

			if #chalices > 0 then
				for i = 1, #chalices do
					local familiar = chalices[i]:ToFamiliar()
					local familiarSprite = familiar:GetSprite()
					familiarSprite:PlayOverlay("BloodDrop", true)
				end
			end
		end
	end

	for i = 1, 5 do
		if sprite:IsPlaying("Idle" .. i)
		and (player:GetData().ritualCooldown == nil or player:GetData().ritualCooldown == 0)
		then
			player.ControlsEnabled = false
			effect:GetData().tookHP = false
			sprite:Play("Initiate" .. i)
		end
	end
end

function Ritual.postRender()
	local rituals = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DIRT_PATCH, SATANIC_RITUAL)
	
	if #rituals == 0 then return end

	local player = Isaac.FindInRadius(rituals[1].Position + Vector(0, -22), 20, EntityPartition.PLAYER)
	
	if #player > 0 then
		local sprite = rituals[1]:GetSprite()

		if not sprite:IsPlaying("Idle0") then
			sprite:RenderLayer(2, Isaac.WorldToRenderPosition(rituals[1].Position))
			sprite:RenderLayer(3, Isaac.WorldToRenderPosition(rituals[1].Position))
			sprite:RenderLayer(8, Isaac.WorldToRenderPosition(rituals[1].Position))
		end
	end
end

function Ritual.postPEffectUpdate(player)
	if player:GetData().ritualCooldown ~= nil
	and player:GetData().ritualCooldown > 0
	then
		player:GetData().ritualCooldown = player:GetData().ritualCooldown - 1
	end
end

function Ritual.postPickupInit(pickup)
	if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
	if pickup.SubType ~= CollectibleType.COLLECTIBLE_SACRIFICIAL_DAGGER then return end
	if pickup.Price ~= 0 then return end
	
	local rituals = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DIRT_PATCH, SATANIC_RITUAL)
	
	if #rituals == 0 then return end

	local sprite = pickup:GetSprite()
	sprite:ReplaceSpritesheet(5, "invisible.png")
	sprite:LoadGraphics()
end

return Ritual