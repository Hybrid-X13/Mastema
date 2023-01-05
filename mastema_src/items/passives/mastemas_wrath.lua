local Enums = require("mastema_src.enums")
local game = Game()
local rng = RNG()
local slayerIcon = Enums.Effects.MASTEMAS_WRATH_INDICATOR

local Item = {}

function Item.evaluateCache(player, cacheFlag)
	if not player:HasCollectible(Enums.Collectibles.MASTEMAS_WRATH) then return end
	if cacheFlag ~= CacheFlag.CACHE_DAMAGE then return end
	
	if player:GetData().roomDmg then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
			player.Damage = player.Damage + 0.4
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
			player.Damage = player.Damage + 0.6
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
			player.Damage = player.Damage + 1.6
		else
			player.Damage = player.Damage + 2
		end
	end

	if player:GetData().fadingDmg ~= nil
	and player:GetData().fadingDmg > 0
	then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
			player.Damage = player.Damage + (player:GetData().fadingDmg * 0.2)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
			player.Damage = player.Damage + (player:GetData().fadingDmg * 0.3)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
			player.Damage = player.Damage + (player:GetData().fadingDmg * 0.8)
		else
			player.Damage = player.Damage + player:GetData().fadingDmg
		end
	end
end

function Item.postNewRoom()
	local room = game:GetRoom()

	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if not player:HasCollectible(Enums.Collectibles.MASTEMAS_WRATH) then return end
		
		player:GetData().roomDmg = false
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:EvaluateItems()
		
		if room:IsClear() then return end

		local enemies = {}
		local strongestEnemy
		
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity:IsActiveEnemy()
			and entity:IsVulnerableEnemy()
			and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
			then
				table.insert(enemies, entity)
			end
		end
		
		if #enemies > 0 then
			strongestEnemy = enemies[1]
			
			for _, enemy in pairs(enemies) do
				if strongestEnemy.MaxHitPoints < enemy.MaxHitPoints then
					strongestEnemy = enemy
				elseif strongestEnemy.MaxHitPoints == enemy.MaxHitPoints then
					local rng = player:GetCollectibleRNG(Enums.Collectibles.MASTEMAS_WRATH)
					local randNum = rng:RandomInt(2)

					if randNum == 0 then
						strongestEnemy = enemy
					end
				end
			end

			local icon = Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.MASTEMAS_WRATH_INDICATOR, 0, strongestEnemy.Position, Vector.Zero, nil):ToEffect()
			icon.Parent = strongestEnemy
			icon:FollowParent(strongestEnemy)
			icon.DepthOffset = 1
			strongestEnemy:GetData().mostHP = true
		end
	end
end

function Item.postEntityKill(npc)
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if not player:HasCollectible(Enums.Collectibles.MASTEMAS_WRATH) then return end
		
		if npc:GetData().mostHP then
			if npc:IsBoss() then
				if player:GetData().fadingDmg == nil
				or player:GetData().fadingDmg <= 0
				then
					player:GetData().fadingDmg = 2
				else
					player:GetData().fadingDmg = player:GetData().fadingDmg + 2
				end
			else
				player:GetData().roomDmg = true
			end
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
		end
	end
end

function Item.postPEffectUpdate(player)
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Sodom", false) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Sodom", true) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Gomorrah", false) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Gomorrah", true) then return end
	if player:GetData().fadingDmg == nil then return end
	
	if player:GetData().fadingDmg > 0 then
		local level = game:GetLevel()
		local modulus = 30

		if level:GetStage() == LevelStage.STAGE6 then
			modulus = 3
		end
		
		if game:GetFrameCount() % modulus == 0 then
			player:GetData().fadingDmg = player:GetData().fadingDmg - 0.01
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
		end
	elseif player:GetData().fadingDmg < 0 then
		player:GetData().fadingDmg = 0
	end
end

function Item.postEffectUpdate(effect)
	if effect.Variant ~= slayerIcon then return end

	local parent = effect.Parent
	
	if parent == nil then
		effect:Remove()
	else
		effect.SpriteOffset = Vector(0, -30 - parent.Size)
	end
end

return Item