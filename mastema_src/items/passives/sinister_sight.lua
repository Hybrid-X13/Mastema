local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local game = Game()

local Item = {}

function Item.evaluateCache(player, cacheFlag)
	if not player:HasCollectible(Enums.Collectibles.SINISTER_SIGHT) then return end
	
	if cacheFlag == CacheFlag.CACHE_TEARFLAG then
		player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
	end
	
	if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
		player.TearColor = Color(1, 0, 1, 1, 0, 0, 0)
		player.LaserColor = Color(1, 0, 1, 1, 0, 0, 0)
	end
end

function Item.postNewRoom()
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if not player:HasCollectible(Enums.Collectibles.SINISTER_SIGHT) then return end
		if player:HasCurseMistEffect() then return end
		if player:IsCoopGhost() then return end
	
		local tempEffects = player:GetEffects()
	
		if not tempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MOMS_PERFUME) then
			tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_MOMS_PERFUME, false, 1)
		end
	end
end

function Item.entityTakeDmg(target, amount, flag, source, countdown)
	local enemy = target:ToNPC()
	
	if enemy == nil then return end
	if not enemy:HasEntityFlags(EntityFlag.FLAG_FEAR) then return end
	if flag & DamageFlag.DAMAGE_CLONES == DamageFlag.DAMAGE_CLONES then return end
	if not Functions.AnyPlayerHasCollectible(Enums.Collectibles.SINISTER_SIGHT) then return end
	
	local extraDMG = amount / 2
	enemy:TakeDamage(extraDMG, flag | DamageFlag.DAMAGE_CLONES, source, 0)
end

function Item.postFireTear(tear)
	if tear.SpawnerEntity == nil then return end
	
	local player = tear.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.SINISTER_SIGHT) then return end
	if not tear:HasTearFlags(TearFlags.TEAR_FEAR) then return end
	
	tear.Color = Color(0.4, 0, 0.4, 1, 0, 0, 0)
end

function Item.postLaserUpdate(laser)
	if laser.SpawnerEntity == nil then return end

	local player = laser.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.SINISTER_SIGHT) then return end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then return end

	local sprite = laser:GetSprite()
	local color = Color(1, 0, 1, 1, 0, 0, 0)
	color:SetColorize(4, 0, 4, 1)
	sprite.Color = color
end

function Item.postPEffectUpdate(player)
	if not player:HasCollectible(Enums.Collectibles.SINISTER_SIGHT) then return end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then return end

	local brimSwirl = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BRIMSTONE_SWIRL, -1)
	local techDot = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TECH_DOT, -1)
	local color = Color(1, 0, 1, 1, 0, 0, 0)
		
	if #brimSwirl > 0 then
		for i = 1, #brimSwirl do
			if brimSwirl[i].SpawnerType == EntityType.ENTITY_PLAYER then
				local sprite = brimSwirl[i]:GetSprite()
				color:SetColorize(4, 0, 4, 1)
				sprite.Color = color
			end
		end
	end
	
	if #techDot > 0 then
		for i = 1, #techDot do
			if techDot[i].SpawnerType == EntityType.ENTITY_PLAYER then
				local sprite = techDot[i]:GetSprite()
				color:SetColorize(4, 0, 4, 1)
				sprite.Color = color
			end
		end
	end
end

function Item.postPlayerUpdate(player)
	if not player:HasCollectible(Enums.Collectibles.SINISTER_SIGHT) then return end
	if player:HasCurseMistEffect() then return end
	if player:IsCoopGhost() then return end

	local tempEffects = player:GetEffects()

	if not tempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MOMS_PERFUME) then
		tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_MOMS_PERFUME, false, 1)
	end
end

return Item