local Enums = require("mastema_src.enums")
local sfx = SFXManager()
local rng = RNG()

local Trinket = {}

function Trinket.useCard(card, player, flag)
	if not player:HasTrinket(Enums.Trinkets.ETERNAL_CARD) then return end
	if flag & UseFlag.USE_MIMIC == UseFlag.USE_MIMIC then return end
	if flag & UseFlag.USE_OWNED ~= UseFlag.USE_OWNED then return end

	local itemConfig = Isaac.GetItemConfig():GetCard(card)

	if not itemConfig:IsCard() then return end
	
	local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.ETERNAL_CARD)
	local rng = player:GetTrinketRNG(Enums.Trinkets.ETERNAL_CARD)
	local randFloat = rng:RandomFloat() / trinketMultiplier

	if randFloat < 0.1 then
		player:AddEternalHearts(1)
		sfx:Play(SoundEffect.SOUND_SUPERHOLY)
	end
end

return Trinket