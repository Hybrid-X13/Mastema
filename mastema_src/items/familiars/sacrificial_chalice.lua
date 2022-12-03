local Enums = require("mastema_src.enums")
local SaveData = require("mastema_src.savedata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()
local MAX_HITS = 20
local newFloor = false

local Familiar = {}

local function ResetChalice(familiar)
	local player = familiar.Player
	local sprite = familiar:GetSprite()
	familiar:AddToFollowers()
	player.ControlsEnabled = true

	if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
		SaveData.ItemData.SacrificialChalice.Hits = 1
		SaveData.ItemData.SacrificialChalice.Level = 1
		sprite:Play("Float1")
	else
		SaveData.ItemData.SacrificialChalice.Hits = 0
		SaveData.ItemData.SacrificialChalice.Level = 0
		sprite:Play("Float0")
	end
	newFloor = false
end

local function HasBloodTears(player)
	local tearVariant = player:GetTearHitParams(WeaponType.WEAPON_TEARS, 1, 1, nil).TearVariant

	if tearVariant == TearVariant.BLOOD
	or tearVariant == TearVariant.CUPID_BLOOD
	or tearVariant == TearVariant.PUPULA_BLOOD
	or tearVariant == TearVariant.GODS_FLESH_BLOOD
	or tearVariant == TearVariant.NAIL_BLOOD
	or tearVariant == TearVariant.GLAUCOMA_BLOOD
	or tearVariant == TearVariant.EYE_BLOOD
	or tearVariant == TearVariant.KEY_BLOOD
	or player:HasCollectible(CollectibleType.COLLECTIBLE_LEAD_PENCIL)
	or player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA)
	then
		return true
	end
	return false
end

local function SpawnBlackLocust(numLocusts, player, pos)
	if player:HasTrinket(TrinketType.TRINKET_FISH_TAIL) then
		numLocusts = numLocusts * 2
	end
	
	for i = 1, numLocusts do
		local blackLocust = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, LocustSubtypes.LOCUST_OF_DEATH, pos, Vector.Zero, nil)
		blackLocust:GetSprite():Play("LocustDeath")
		blackLocust:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	end
end

function Familiar.evaluateCache(player, cacheFlag)
	if not player:HasCollectible(Enums.Collectibles.SACRIFICIAL_CHALICE) then return end
	if cacheFlag ~= CacheFlag.CACHE_FAMILIARS then return end
	
	player:CheckFamiliar(Enums.Familiars.SACRIFICIAL_CHALICE, 1, player:GetCollectibleRNG(Enums.Collectibles.SACRIFICIAL_CHALICE), Isaac.GetItemConfig():GetCollectible(Enums.Collectibles.SACRIFICIAL_CHALICE))
end

function Familiar.familiarInit(familiar)
	if familiar.Variant ~= Enums.Familiars.SACRIFICIAL_CHALICE then return end

	if familiar:GetData().chaliceLevel == nil
	and SaveData.ItemData.SacrificialChalice.Level == 0
	then
		familiar:GetData().chaliceLevel = 0
	else
		familiar:GetData().chaliceLevel = SaveData.ItemData.SacrificialChalice.Level
	end
	SaveData.ItemData.SacrificialChalice.Level = familiar:GetData().chaliceLevel

	local player = familiar.Player
	local sprite = familiar:GetSprite()
	familiar:AddToFollowers()
	sprite:Play("Float" .. SaveData.ItemData.SacrificialChalice.Level)

	if player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS
	or player:GetPlayerType() == PlayerType.PLAYER_JUDAS_B
	then
		sprite:ReplaceSpritesheet(0, "gfx/familiar/mastema_familiar_chalice_darkjudas.png")
		sprite:ReplaceSpritesheet(1, "gfx/familiar/mastema_familiar_chalice_darkjudas.png")
		sprite:LoadGraphics()
	elseif player:GetPlayerType() == Isaac.GetPlayerTypeByName("Andromeda", false) then
		sprite:ReplaceSpritesheet(0, "gfx/familiar/mastema_familiar_chalice_andromeda.png")
		sprite:ReplaceSpritesheet(1, "gfx/familiar/mastema_familiar_chalice_andromeda.png")
		sprite:LoadGraphics()
	elseif player:GetPlayerType() == Isaac.GetPlayerTypeByName("AndromedaB", true) then
		local skinColor = player:GetHeadColor()
		
		if HasBloodTears(player) then
			sprite:ReplaceSpritesheet(0, "gfx/familiar/mastema_familiar_chalice_darkjudas.png")
			sprite:ReplaceSpritesheet(1, "gfx/familiar/mastema_familiar_chalice_darkjudas.png")
		elseif skinColor == SkinColor.SKIN_WHITE then
			sprite:ReplaceSpritesheet(0, "gfx/familiar/mastema_familiar_chalice_andromedab_white.png")
			sprite:ReplaceSpritesheet(1, "gfx/familiar/mastema_familiar_chalice_andromedab_white.png")
		elseif skinColor == SkinColor.SKIN_BLACK then
			sprite:ReplaceSpritesheet(0, "gfx/familiar/mastema_familiar_chalice_andromedab_black.png")
			sprite:ReplaceSpritesheet(1, "gfx/familiar/mastema_familiar_chalice_andromedab_black.png")
		elseif skinColor == SkinColor.SKIN_BLUE then
			sprite:ReplaceSpritesheet(0, "gfx/familiar/mastema_familiar_chalice_andromedab_blue.png")
			sprite:ReplaceSpritesheet(1, "gfx/familiar/mastema_familiar_chalice_andromedab_blue.png")
		elseif skinColor == SkinColor.SKIN_RED then
			sprite:ReplaceSpritesheet(0, "gfx/familiar/mastema_familiar_chalice_andromedab_red.png")
			sprite:ReplaceSpritesheet(1, "gfx/familiar/mastema_familiar_chalice_andromedab_red.png")
		elseif skinColor == SkinColor.SKIN_GREEN then
			sprite:ReplaceSpritesheet(0, "gfx/familiar/mastema_familiar_chalice_andromedab_green.png")
			sprite:ReplaceSpritesheet(1, "gfx/familiar/mastema_familiar_chalice_andromedab_green.png")
		elseif skinColor == SkinColor.SKIN_GREY then
			sprite:ReplaceSpritesheet(0, "gfx/familiar/mastema_familiar_chalice_andromedab_grey.png")
			sprite:ReplaceSpritesheet(1, "gfx/familiar/mastema_familiar_chalice_andromedab_grey.png")
		else
			sprite:ReplaceSpritesheet(0, "gfx/familiar/mastema_familiar_chalice_andromedab.png")
			sprite:ReplaceSpritesheet(1, "gfx/familiar/mastema_familiar_chalice_andromedab.png")
		end
		sprite:LoadGraphics()
	end
end

function Familiar.familiarUpdate(familiar)
	if familiar.Variant ~= Enums.Familiars.SACRIFICIAL_CHALICE then return end

	local player = familiar.Player
	local sprite = familiar:GetSprite()
	familiar:FollowParent()
	
	if SaveData.ItemData.SacrificialChalice.Level == 0
	and (SaveData.ItemData.SacrificialChalice.Hits > 0 or player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS))
	and SaveData.ItemData.SacrificialChalice.Hits <= 4
	then
		SaveData.ItemData.SacrificialChalice.Level = 1
		familiar:GetData().chaliceLevel = 1
		sprite:Play("Float1")
	elseif SaveData.ItemData.SacrificialChalice.Level == 1
	and SaveData.ItemData.SacrificialChalice.Hits > 4
	and SaveData.ItemData.SacrificialChalice.Hits <= 9
	then
		SaveData.ItemData.SacrificialChalice.Level = 2
		familiar:GetData().chaliceLevel = 2
		sprite:Play("Float2")
	elseif SaveData.ItemData.SacrificialChalice.Level == 2
	and SaveData.ItemData.SacrificialChalice.Hits > 9
	and SaveData.ItemData.SacrificialChalice.Hits <= 14
	then
		SaveData.ItemData.SacrificialChalice.Level = 3
		familiar:GetData().chaliceLevel = 3
		sprite:Play("Float3")
	elseif SaveData.ItemData.SacrificialChalice.Level == 3
	and SaveData.ItemData.SacrificialChalice.Hits > 15
	then
		SaveData.ItemData.SacrificialChalice.Level = 4
		familiar:GetData().chaliceLevel = 4
		sprite:Play("Float4")
	end

	if newFloor
	and player:IsExtraAnimationFinished()
	then
		local room = game:GetRoom()
		local rng = player:GetCollectibleRNG(Enums.Collectibles.SACRIFICIAL_CHALICE)

		familiar:RemoveFromFollowers()
		familiar.Position = Isaac.GetFreeNearPosition(player.Position, 40)
		familiar.Velocity = Vector.Zero
		player.ControlsEnabled = false

		if SaveData.ItemData.SacrificialChalice.Hits == 0
		and not player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS)
		then
			sprite:Play("angerangry")

			if sprite:IsEventTriggered("Unprize") then
				local randNum = rng:RandomInt(2)

				if randNum == 0 then
					local numBrokenHearts = math.ceil((player:GetHeartLimit() / 2) / 4)
					player:AddBrokenHearts(numBrokenHearts)
				elseif randNum == 1 then
					if player:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) then
						player:TryRemoveTrinket(TrinketType.TRINKET_YOUR_SOUL)
						player:TryRemoveTrinket(TrinketType.TRINKET_YOUR_SOUL + TrinketType.TRINKET_GOLDEN_FLAG)
					elseif (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B)
					and player:GetNumCoins() >= 30
					then
						player:AddCoins(-30)
					elseif player:GetEffectiveMaxHearts() > 0 then
						if player:GetEffectiveMaxHearts() >= 4 then
							player:AddMaxHearts(-4)
						else
							player:AddMaxHearts(-2)
							player:AddSoulHearts(-4)
						end
					else
						if player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY then
							player:AddSoulHearts(-4)
						else
							player:AddSoulHearts(-6)
						end
					end
				else
					--Add 2 or 3 curses maybe
				end
				
				sfx:Play(SoundEffect.SOUND_DEVILROOM_DEAL)
				sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
				player:AnimateSad()
			end

			if sprite:IsFinished("angerangry") then
				ResetChalice(familiar)
			end
		else
			local pos = Isaac.GetFreeNearPosition(player.Position, 40)
			local color = Color(0.55, 0, 0, 1, 0, 0, 0)

			sprite:Play("Pour" .. SaveData.ItemData.SacrificialChalice.Level)

			local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_LEMON_MISHAP, 0, pos, Vector.Zero, player)
			local bloodSprite = blood:GetSprite()
			bloodSprite.Color = color

			if SaveData.ItemData.SacrificialChalice.Level > 2 then
				blood:ToEffect().Scale = 2
			else
				blood:ToEffect().Scale = 1
			end

			if sprite:IsFinished("Pour" .. SaveData.ItemData.SacrificialChalice.Level) then
				local randNum = rng:RandomInt(MAX_HITS) + 1
				
				if randNum <= SaveData.ItemData.SacrificialChalice.Hits then
					local itemPool = game:GetItemPool()
					local itemID = itemPool:GetCollectible(ItemPoolType.POOL_DEVIL, true, game:GetSeeds():GetStartSeed())
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, blood.Position, Vector.Zero, nil)
				else
					local rewards = {
						{PickupVariant.PICKUP_REDCHEST, 0},
						{PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK},
						{PickupVariant.PICKUP_GRAB_BAG, SackSubType.SACK_BLACK},
					}
					
					for i = 1, SaveData.ItemData.SacrificialChalice.Level do
						randNum = rng:RandomInt(4)

						if randNum == 0 then
							SpawnBlackLocust(5, blood.Position)
						else
							local position = room:FindFreePickupSpawnPosition(blood.Position, 0)

							if SaveData.ItemData.SacrificialChalice.Level == 2
							or SaveData.ItemData.SacrificialChalice.Level == 3
							then
								if i == 1 then
									position = blood.Position + Vector(40, 0)
								elseif i == 2 then
									position = blood.Position - Vector(40, 0)
								elseif i == 3 then
									position = blood.Position + Vector(0, 40)
								end
							end

							Isaac.Spawn(EntityType.ENTITY_PICKUP, rewards[randNum][1], rewards[randNum][2], position, Vector.Zero, nil)
						end
					end
				end
				sfx:Play(SoundEffect.SOUND_DEVILROOM_DEAL)
				ResetChalice(familiar)
			end
		end
	end
end

function Familiar.entityTakeDmg(target, amount, flag, source, countdown)
	local player = target:ToPlayer()
	
	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.SACRIFICIAL_CHALICE) then return end
	if flag & DamageFlag.DAMAGE_FAKE == DamageFlag.DAMAGE_FAKE then return end

	SaveData.ItemData.SacrificialChalice.Hits = SaveData.ItemData.SacrificialChalice.Hits + 1

	local chalices = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, Enums.Familiars.SACRIFICIAL_CHALICE)

	if #chalices > 0 then
		for i = 1, #chalices do
			local familiar = chalices[i]:ToFamiliar()
			local sprite = familiar:GetSprite()
			sprite:PlayOverlay("BloodDrop", true)
		end
	end
end

function Familiar.postNewLevel()
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if not player:HasCollectible(Enums.Collectibles.SACRIFICIAL_CHALICE) then return end
		
		local chalices = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, Enums.Familiars.SACRIFICIAL_CHALICE)

		if #chalices > 0 then
			for i = 1, #chalices do
				local familiar = chalices[i]:ToFamiliar()
				familiar:RemoveFromFollowers()
				familiar.Position = Isaac.GetFreeNearPosition(player.Position, 40)
			end
		end
		newFloor = true
	end
end

function Familiar.postPEffectUpdate(player)
	if player:HasCollectible(Enums.Collectibles.SACRIFICIAL_CHALICE) then return end
	
	player:CheckFamiliar(Enums.Familiars.SACRIFICIAL_CHALICE, 0, player:GetCollectibleRNG(Enums.Collectibles.SACRIFICIAL_CHALICE), Isaac.GetItemConfig():GetCollectible(Enums.Collectibles.SACRIFICIAL_CHALICE))
end

return Familiar