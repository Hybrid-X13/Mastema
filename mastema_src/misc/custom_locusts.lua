local Enums = require("mastema_src.enums")
local game = Game()
local rng = RNG()
local sfx = SFXManager()
local initSeeds = {}

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

local Locust = {}

local function ShouldTriggerOnDeathEffect(npc)
	for i = 1, #initSeeds do
		if npc.InitSeed == initSeeds[i] then
			table.remove(initSeeds, i)

			return true
		end
	end

	return false
end

function Locust.entityTakeDmg(target, amount, flags, source, countdown)
	local enemy = target:ToNPC()
	
	if enemy == nil then return end
	if not enemy:IsActiveEnemy() then return end
	if source.Entity == nil then return end
	if source.Entity.Type ~= EntityType.ENTITY_FAMILIAR then return end
	if source.Variant ~= FamiliarVariant.ABYSS_LOCUST then return end
	
	if source.Entity.SubType == Enums.Collectibles.SINISTER_SIGHT
	and enemy:HasEntityFlags(EntityFlag.FLAG_FEAR)
	and flags & DamageFlag.DAMAGE_CLONES ~= DamageFlag.DAMAGE_CLONES
	then
		local extraDMG = amount / 2
		enemy:TakeDamage(extraDMG, flags | DamageFlag.DAMAGE_CLONES, source, 0)
	elseif source.Entity.SubType == Enums.Collectibles.BLOODSPLOSION
	and (enemy.HitPoints - amount) <= 0
	then
		table.insert(initSeeds, enemy.InitSeed)
	end
end

function Locust.postNPCDeath(npc)
	if not ShouldTriggerOnDeathEffect(npc) then return end

	local bloodsplosionLocust = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, Enums.Collectibles.BLOODSPLOSION)

	if #bloodsplosionLocust == 0 then return end
	
	local familiar = bloodsplosionLocust[1]:ToFamiliar()
	local player = familiar.Player
	
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

return Locust