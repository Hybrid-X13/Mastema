local Enums = require("mastema_src.enums")
local sfx = SFXManager()
local rng = RNG()

local Card = {}

function Card.useCard(card, player, flag)
	if card ~= Enums.Cards.UNHOLY_CARD then return end

	player:UseActiveItem(CollectibleType.COLLECTIBLE_BRIMSTONE, false)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_BRIMSTONE, false)

	if flag & UseFlag.USE_MIMIC ~= UseFlag.USE_MIMIC then
		local rng = player:GetCardRNG(Enums.Cards.UNHOLY_CARD)
		local randNum = rng:RandomInt(2)
		
		if Options.AnnouncerVoiceMode == 2
		or (Options.AnnouncerVoiceMode == 0 and randNum == 0)
		then
			sfx:Play(Enums.Voicelines.UNHOLY_CARD)
		end
	end
end

return Card