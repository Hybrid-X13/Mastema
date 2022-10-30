local Mastema = require("mastema_src.characters.mastema")

local function MC_PRE_USE_ITEM(_, item, rng, player, flags, activeSlot, customVarData)
	local returned = Mastema.preUseItem(item, rng, player, flags, activeSlot, customVarData)
	if returned ~= nil then return returned end
end

return MC_PRE_USE_ITEM