local Enums = require("mastema_src.enums")

local Trinket = {}

function Trinket.evaluateCache(player, cacheFlag)
	if not player:HasTrinket(Enums.Trinkets.SPIRITS_HEART) then return end
	if cacheFlag ~= CacheFlag.CACHE_FIREDELAY then return end
	if player:GetEffectiveMaxHearts() > 0 then return end
	if player:GetBoneHearts() > 0 then return end

	player.MaxFireDelay = player.MaxFireDelay * (1 - (0.2 * player:GetTrinketMultiplier(Enums.Trinkets.SPIRITS_HEART)))
end

function Trinket.postPEffectUpdate(player)
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Sodom", false) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Sodom", true) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Gomorrah", false) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Gomorrah", true) then return end
	
	if player:HasTrinket(Enums.Trinkets.SPIRITS_HEART) then
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:EvaluateItems()
	else
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:EvaluateItems()
	end
end

return Trinket