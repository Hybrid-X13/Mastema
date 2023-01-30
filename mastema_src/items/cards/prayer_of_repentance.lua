local Enums = require("mastema_src.enums")
local sfx = SFXManager()
local rng = RNG()

local Consumable = {}

function Consumable.useCard(card, player, flag)
	if card ~= Enums.Cards.PRAYER_OF_REPENTANCE then return end
	
	local spawnpos = Isaac.GetFreeNearPosition(player.Position, 40)
	local confessional = Isaac.Spawn(EntityType.ENTITY_SLOT, 17, 0, spawnpos, Vector.Zero, nil)
	Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, confessional.Position, Vector.Zero, confessional)

	if flag & UseFlag.USE_MIMIC ~= UseFlag.USE_MIMIC then
		local rng = player:GetCardRNG(Enums.Cards.PRAYER_OF_REPENTANCE)
		local randNum = rng:RandomInt(2)

		if Options.AnnouncerVoiceMode == 2
		or (Options.AnnouncerVoiceMode == 0 and randNum == 0)
		then
			sfx:Play(Enums.Voicelines.PRAYER_OF_REPENTANCE)
		end
	end
end

return Consumable