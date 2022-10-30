local T_Mastema = require("mastema_src.characters.t_mastema")

local function MC_POST_PICKUP_UPDATE(_, pickup)
	T_Mastema.postPickupUpdate(pickup)
end

return MC_POST_PICKUP_UPDATE