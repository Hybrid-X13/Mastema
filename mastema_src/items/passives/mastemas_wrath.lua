local Enums = require("mastema_src.enums")
local Functions = require("mastema_src.functions")
local game = Game()
local rng = RNG()

local slayerIcon = Sprite()
slayerIcon:Load("gfx/1000.049_effect notify.anm2", true)

local Item = {}

function Item.evaluateCache(player, cacheFlag)
	if not player:HasCollectible(Enums.Collectibles.MASTEMAS_WRATH) then return end
	if cacheFlag ~= CacheFlag.CACHE_DAMAGE then return end
	
	if player:GetData().roomDmg then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
			player.Damage = player.Damage + 0.4
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
			player.Damage = player.Damage + 0.6
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
		
		for i, entity in pairs(Isaac.GetRoomEntities()) do
			if entity:IsActiveEnemy()
			and entity:IsVulnerableEnemy()
			and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
			then
				table.insert(enemies, entity)
			end
		end
		
		if #enemies > 0 then
			strongestEnemy = enemies[1]
			
			for i = 1, #enemies do
				if strongestEnemy.MaxHitPoints < enemies[i].MaxHitPoints then
					strongestEnemy = enemies[i]
				elseif strongestEnemy.MaxHitPoints == enemies[i].MaxHitPoints then
					local rng = player:GetCollectibleRNG(Enums.Collectibles.MASTEMAS_WRATH)
					local randNum = rng:RandomInt(2)

					if randNum == 0 then
						strongestEnemy = enemies[i]
					end
				end
			end
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

function Item.postRender()
	local room = game:GetRoom()

	if room:GetFrameCount() == 0 then return end
	if not Functions.AnyPlayerHasCollectible(Enums.Collectibles.MASTEMAS_WRATH) then return end
		
	for i, entity in pairs(Isaac.GetRoomEntities()) do
		if entity:GetData().mostHP then
			local offset = Vector(0, -5) * entity.Size
			slayerIcon:SetFrame("Betrayal", 6)
			slayerIcon:Render(Isaac.WorldToScreen(entity.Position + offset), Vector.Zero, Vector.Zero)
		end
	end
end

return Item