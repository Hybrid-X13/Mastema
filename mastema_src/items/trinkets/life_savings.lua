local Enums = require("mastema_src.enums")
local rng = RNG()

local Trinket = {}

function Trinket.entityTakeDmg(target, amount, flag, source, countdown)
	local player = target:ToPlayer()
	
	if player == nil then return end
	if not player:HasTrinket(Enums.Trinkets.LIFE_SAVINGS) then return end
	if flag & DamageFlag.DAMAGE_RED_HEARTS ~= DamageFlag.DAMAGE_RED_HEARTS then return end
	if source.Type ~= EntityType.ENTITY_SLOT then return end
	
	local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.LIFE_SAVINGS)
	local rng = player:GetTrinketRNG(Enums.Trinkets.LIFE_SAVINGS)
	local randFloat = rng:RandomFloat() / trinketMultiplier
		
	if randFloat < 0.15 then
		return false
	end
end

return Trinket