local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local rng = RNG()

local Consumable = {}

function Consumable.useCard(card, player, flag)
	if card ~= Enums.Cards.PRAYER_OF_REPENTANCE then return end
	
	local rng = player:GetCardRNG(Enums.Cards.PRAYER_OF_REPENTANCE)
	local pos = Isaac.GetFreeNearPosition(player.Position, 40)
	local confessional = Isaac.Spawn(EntityType.ENTITY_SLOT, Enums.Slots.CONFESSIONAL, 0, pos, Vector.Zero, nil)
	Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, confessional.Position, Vector.Zero, confessional)

	Functions.PlayVoiceline(Enums.Voicelines.PRAYER_OF_REPENTANCE, flag, rng:RandomInt(2))
end

return Consumable