local Enums = require("mastema_src.enums")
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local Item = {}

function Item.postNewLevel()
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasCollectible(Enums.Collectibles.BROKEN_DICE)
		and player:GetBrokenHearts() > 0
		then
			player:AddBrokenHearts(-1)
			sfx:Play(SoundEffect.SOUND_THUMBSUP)
			sfx:Play(SoundEffect.SOUND_DEATH_CARD)
		end
	end
end

function Item.useItem(item, rng, player, flags, activeSlot, customVarData)
	if item ~= Enums.Collectibles.BROKEN_DICE then return end
	
	if player:GetPlayerType() == PlayerType.PLAYER_THELOST
	or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
	then
		local randNum = rng:RandomInt(6)
			
		if randNum == 0 then
			player:RemoveCollectible(Enums.Collectibles.BROKEN_DICE)
			player:AnimateSad()
			sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
			return false
		end
	end

	player:UseCard(Card.CARD_DICE_SHARD, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
	player:AddBrokenHearts(1)
	
	return true
end

return Item