local Enums = require("mastema_src.enums")

local Trinket = {}

function Trinket.evaluateCache(player, cacheFlag)
	if not player:HasTrinket(Enums.Trinkets.PURISTS_HEART) then return end
	if cacheFlag ~= CacheFlag.CACHE_DAMAGE then return end

	if player:GetSoulHearts() == 0
	or player:GetPlayerType() == PlayerType.PLAYER_THELOST
	or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
	then
		player.Damage = player.Damage * (1 + (0.2 * player:GetTrinketMultiplier(Enums.Trinkets.PURISTS_HEART)))
	end
end

function Trinket.postPEffectUpdate(player)
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Sodom", false) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Sodom", true) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Gomorrah", false) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Gomorrah", true) then return end
	
	if player:HasTrinket(Enums.Trinkets.PURISTS_HEART) then
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:EvaluateItems()
	else
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:EvaluateItems()
	end
end

return Trinket