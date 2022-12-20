local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local entFlags = {
	EntityFlag.FLAG_POISON,
	EntityFlag.FLAG_SLOW,
	EntityFlag.FLAG_FREEZE,
	EntityFlag.FLAG_CHARM,
	EntityFlag.FLAG_CONFUSION,
	EntityFlag.FLAG_FEAR,
	EntityFlag.FLAG_BURN,
	EntityFlag.FLAG_BAITED,
}

local tearFlags = {
	TearFlags.TEAR_POISON,
	TearFlags.TEAR_SLOW,
	TearFlags.TEAR_FREEZE,
	TearFlags.TEAR_CHARM,
	TearFlags.TEAR_CONFUSION,
	TearFlags.TEAR_FEAR,
	TearFlags.TEAR_BURN,
	TearFlags.TEAR_BAIT,
}

local Item = {}

function Item.postNPCDeath(npc)
	if npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then return end
	if Functions.IsInvulnerableEnemy(npc) then return end
	
	rng:SetSeed(npc.InitSeed, 35)
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if not player:HasCollectible(Enums.Collectibles.BLOODSPLOSION) then return end

		local randNum = rng:RandomInt(2)
		
		if randNum == 0 then
			local explosionFlags = TearFlags.TEAR_NORMAL
			
			for i = 1, #entFlags do
				if npc:HasEntityFlags(entFlags[i]) then
					explosionFlags = explosionFlags | tearFlags[i]
				end
			end
			
			game:BombExplosionEffects(npc.Position, player.Damage, explosionFlags, Color.Default, player)
			sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE, 1.3)
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, npc.Position, Vector.Zero, npc)
			
			if player:HasTrinket(TrinketType.TRINKET_LOST_CORK) then
				creep.SpriteScale = Vector(2.5, 2.5)
			else
				creep.SpriteScale = Vector(2, 2)
			end
		end
	end
end

return Item