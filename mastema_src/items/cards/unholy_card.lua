local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local rng = RNG()

local Consumable = {}

function Consumable.useCard(card, player, flag)
	if card ~= Enums.Cards.UNHOLY_CARD then return end

	local rng = player:GetCardRNG(Enums.Cards.UNHOLY_CARD)

	player:UseActiveItem(CollectibleType.COLLECTIBLE_BRIMSTONE, false)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_BRIMSTONE, false)

	Functions.PlayVoiceline(Enums.Voicelines.UNHOLY_CARD, flag, rng:RandomInt(2))
end

return Consumable