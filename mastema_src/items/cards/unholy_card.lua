local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local Consumable = {}

function Consumable.useCard(card, player, flag)
	if card ~= Enums.Cards.UNHOLY_CARD then return end

	local rng = player:GetCardRNG(Enums.Cards.UNHOLY_CARD)

	if player:GetData().unholyCardTimer == nil then
		local tempEffects = player:GetEffects()
		tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, true, 2)
	end

	sfx:Play(SoundEffect.SOUND_MONSTER_YELL_A, 1, 2, false, 0.98)
	player:GetData().unholyCardTimer = 900

	Functions.PlayVoiceline(Enums.Voicelines.UNHOLY_CARD, flag, rng:RandomInt(2))
end

function Consumable.postNewRoom()
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:GetData().unholyCardTimer then
			local tempEffects = player:GetEffects()
			tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, true, 2)
		end
	end
end

function Consumable.postPEffectUpdate(player)
	if player:GetData().unholyCardTimer == nil then return end

	player:GetData().unholyCardTimer = player:GetData().unholyCardTimer - 1

	if player:GetData().unholyCardTimer == 0 then
		local tempEffects = player:GetEffects()
		tempEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, 2)
		player:GetData().unholyCardTimer = nil
	end
end

function Consumable.postPlayerUpdate(player)
	if player:GetData().unholyCardTimer == nil then return end

	local tempEffects = player:GetEffects()

	if not tempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE) then
		tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, true, 2)
	end
end

return Consumable