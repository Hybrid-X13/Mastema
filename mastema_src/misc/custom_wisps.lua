local Enums = require("mastema_src.enums")
local sfx = SFXManager()
local rng = RNG()

local Wisp = {}

function Wisp.postEntityKill(entity)
	rng:SetSeed(entity.InitSeed, 35)

	local randNum = rng:RandomInt(20)
	
	if entity:GetData().killedByBHWisp
	and randNum == 0
	then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0, entity.Position, Vector.Zero, nil)
	end

	if entity.Type ~= EntityType.ENTITY_FAMILIAR then return end
	if entity.Variant ~= FamiliarVariant.WISP then return end
	
	if entity.SubType == Enums.Collectibles.RAVEN_BEAK then
		Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.DEAD_BIRD, 0, entity.Position, Vector.Zero, nil)
	elseif entity.SubType == Enums.Collectibles.BROKEN_DICE then
		local familiar = entity:ToFamiliar()
		local player = familiar.Player
		randNum = rng:RandomInt(6)
		
		if player:GetBrokenHearts() > 0
		and randNum == 0
		then
			player:AddBrokenHearts(-1)
			sfx:Play(SoundEffect.SOUND_THUMBSUP)
			sfx:Play(SoundEffect.SOUND_DEATH_CARD)
		end
	end
end

function Wisp.entityTakeDmg(target, amount, flags, source, countdown)
	local enemy = target:ToNPC()
	
	if enemy == nil then return end
	if source.Type ~= EntityType.ENTITY_TEAR then return end
	
	local spawner = source.Entity.SpawnerEntity

	if spawner == nil then return end

	local familiar = spawner:ToFamiliar()

	if familiar == nil then return end
	if familiar.SubType ~= Enums.Collectibles.BLOODY_HARVEST then return end

	local health = enemy.HitPoints - amount

	if health <= 0 then
		enemy:GetData().killedByBHWisp = true
	end
end

return Wisp