local Mastema = require("mastema_src.characters.mastema")
local TMastema = require("mastema_src.characters.t_mastema")
local TornWings = require("mastema_src.items.passives.torn_wings")

local function MC_PRE_GET_COLLECTIBLE(_, pool, decrease, seed)
	local returned = Mastema.preGetCollectible(pool, decrease, seed)
	if returned ~= nil then return returned end

	local returned = TMastema.preGetCollectible(pool, decrease, seed)
	if returned ~= nil then return returned end
	
	local returned = TornWings.preGetCollectible(pool, decrease, seed)
	if returned ~= nil then return returned end
end

return MC_PRE_GET_COLLECTIBLE