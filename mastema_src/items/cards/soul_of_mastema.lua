local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local Card = {}

function Card.useCard(card, player, flag)
	if card ~= Enums.Cards.SOUL_OF_MASTEMA then return end
	
	local spawnpos = Isaac.GetFreeNearPosition(player.Position, 40)
	local rng = player:GetCardRNG(Enums.Cards.SOUL_OF_MASTEMA)
	local pool = rng:RandomInt(ItemPoolType.NUM_ITEMPOOLS)
	local seed = rng:RandomInt(999999999)
	local itemID = game:GetItemPool():GetCollectible(pool, true, seed)
	local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
	local quality = itemConfig.Quality
	local randNum = rng:RandomInt(3)

	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, spawnpos, Vector.Zero, nil)
	
	if randNum == 0 then
		if quality < 2 then
			player:AddBrokenHearts(1)
			
			if player:GetPlayerType() == PlayerType.PLAYER_THELOST
			or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
			then
				local pos = Isaac.GetFreeNearPosition(player.Position, 40)
				Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_SUPERTROLL, 0, pos, Vector.Zero, nil)
			end
		else
			player:AddBrokenHearts(quality)
			
			if player:GetPlayerType() == PlayerType.PLAYER_THELOST
			or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
			then
				for i = 1, quality do
					local pos = Isaac.GetFreeNearPosition(player.Position, 40)
					Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_SUPERTROLL, 0, pos, Vector.Zero, nil)
				end
			end
		end
		
		sfx:Play(SoundEffect.SOUND_DEVILROOM_DEAL)
		local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnpos, Vector.Zero, nil)
		local color = Color(1, 0, 1, 1, 0, 0, 0)
		local sprite = poof:GetSprite()
		color:SetColorize(4, 0, 4, 1)
		sprite.Color = color
	elseif randNum == 1 then
		local devilPrice = itemConfig.DevilPrice
		local maxRedHearts = player:GetEffectiveMaxHearts()
		
		if player:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) then
			player:TryRemoveTrinket(TrinketType.TRINKET_YOUR_SOUL)
			player:TryRemoveTrinket(TrinketType.TRINKET_YOUR_SOUL + TrinketType.TRINKET_GOLDEN_FLAG)
		elseif player:GetPlayerType() == PlayerType.PLAYER_THELOST
		or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
		then
			player:TakeDamage(1, 0, EntityRef(player), 0)
		elseif maxRedHearts > 0
		and not Functions.IsSoulHeartCharacter(player)
		then
			if pool == ItemPoolType.POOL_DEVIL
			or pool == ItemPoolType.POOL_ANGEL
			then
				if devilPrice == 2 then
					if (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B)
					and player:GetNumCoins() >= 30
					then
						player:AddCoins(-30)
					elseif maxRedHearts >= 4 then
						player:AddMaxHearts(-4)
					else
						player:AddMaxHearts(-2)
						player:AddSoulHearts(-4)
					end
				else
					if (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B)
					and player:GetNumCoins() >= 15
					then
						player:AddCoins(-15)
					else
						player:AddMaxHearts(-2)
					end
				end
			else
				if quality > 2 then
					if (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B)
					and player:GetNumCoins() >= 30
					then
						player:AddCoins(-30)
					elseif maxRedHearts >= 4 then
						player:AddMaxHearts(-4)
					else
						player:AddMaxHearts(-2)
						player:AddSoulHearts(-4)
					end
				else
					if (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B)
					and player:GetNumCoins() >= 15
					then
						player:AddCoins(-15)
					else
						player:AddMaxHearts(-2)
					end
				end
			end
		else
			if player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY then
				if pool == ItemPoolType.POOL_DEVIL
				or pool == ItemPoolType.POOL_ANGEL
				then
					player:AddSoulHearts(-2 * devilPrice)
				else
					if quality > 2 then
						player:AddSoulHearts(-4)
					else
						player:AddSoulHearts(-2)
					end
				end
			else
				player:AddSoulHearts(-6)
			end
		end

		sfx:Play(SoundEffect.SOUND_DEVILROOM_DEAL)
		local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnpos, Vector.Zero, nil)
		local color = Color(1, 0, 0, 1, 0, 0, 0)
		local sprite = poof:GetSprite()
		color:SetColorize(6.5, 0, 0, 1)
		sprite.Color = color
	else
		sfx:Play(SoundEffect.SOUND_THUMBSUP)
	end

	randNum = rng:RandomInt(2)

	if flag & UseFlag.USE_MIMIC ~= UseFlag.USE_MIMIC then
		if Options.AnnouncerVoiceMode == 2
		or (Options.AnnouncerVoiceMode == 0 and randNum == 0)
		then
			sfx:Play(Enums.Voicelines.SOUL_OF_MASTEMA)
		end
	end
end

return Card