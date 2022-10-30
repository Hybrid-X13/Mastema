local Enums = require("mastema_src.enums")
local sfx = SFXManager()
local rng = RNG()

local Trinket = {}

function Trinket.useCard(card, player, flag)
	if not player:HasTrinket(Enums.Trinkets.ETERNAL_CARD) then return end
	if flag & UseFlag.USE_MIMIC == UseFlag.USE_MIMIC then return end
	
	local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.ETERNAL_CARD)
	local rng = player:GetTrinketRNG(Enums.Trinkets.ETERNAL_CARD)
	local rngMax = 60 / trinketMultiplier
	local randNum = rng:RandomInt(rngMax)
	
	--Had to hardcode which cards it works for cause you can't check card type
	if (card > 0 and card < 32)
	or (card > 41 and card < 49)
	or (card > 50 and card < 55)
	or (card > 55 and card < 78)
	or (card > 78 and card < 81)
	or card == Enums.Cards.UNHOLY_CARD
	or card == Enums.Cards.PRAYER_OF_REPENTANCE
	then
		if randNum < 6 then
			player:AddEternalHearts(1)
			sfx:Play(SoundEffect.SOUND_SUPERHOLY)
		end
	end
end

return Trinket