local Mastema = require("mastema_src.characters.mastema")
local T_Mastema = require("mastema_src.characters.t_mastema")
local BloodyHarvest = require("mastema_src.items.actives.bloody_harvest")
local DevilsBargain = require("mastema_src.items.actives.devils_bargain")
local RavenBeak = require("mastema_src.items.actives.raven_beak")
local BrokenDice = require("mastema_src.items.actives.broken_dice")

local function MC_USE_ITEM(_, item, rng, player, flags, activeSlot, customVarData)
	local returned = Mastema.useItem(item, rng, player, flags, activeSlot, customVarData)
	if returned ~= nil then return returned end

	local returned = T_Mastema.useItem(item, rng, player, flags, activeSlot, customVarData)
	if returned ~= nil then return returned end
	
	local returned = BloodyHarvest.useItem(item, rng, player, flags, activeSlot, customVarData)
	if returned ~= nil then return returned end

	local returned = DevilsBargain.useItem(item, rng, player, flags, activeSlot, customVarData)
	if returned ~= nil then return returned end
	
	local returned = RavenBeak.useItem(item, rng, player, flags, activeSlot, customVarData)
	if returned ~= nil then return returned end
	
	local returned = BrokenDice.useItem(item, rng, player, flags, activeSlot, customVarData)
	if returned ~= nil then return returned end
end

return MC_USE_ITEM