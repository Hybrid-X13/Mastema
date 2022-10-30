local UnlockManager = require("mastema_src.unlock_manager")
local Mastema = require("mastema_src.characters.mastema")
local T_Mastema = require("mastema_src.characters.t_mastema")
local CorruptHeart = require("mastema_src.items.passives.corrupt_heart")
local SatanicRitual = require("mastema_src.misc.satanic_ritual")

local function MC_POST_PICKUP_INIT(_, pickup)
	UnlockManager.postPickupInit(pickup)
	
	Mastema.postPickupInit(pickup)
	T_Mastema.postPickupInit(pickup)

	CorruptHeart.postPickupInit(pickup)
	
	SatanicRitual.postPickupInit(pickup)
end

return MC_POST_PICKUP_INIT