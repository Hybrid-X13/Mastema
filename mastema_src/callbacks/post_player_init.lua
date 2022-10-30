local SaveData = require("mastema_src.savedata")
local UnlockManager = require("mastema_src.unlock_manager")
local Mastema = require("mastema_src.characters.mastema")
local T_Mastema = require("mastema_src.characters.t_mastema")

local function MC_POST_PLAYER_INIT(_, player)
	SaveData.postPlayerInit(player)
	UnlockManager.postPlayerInit(player)
	
	Mastema.postPlayerInit(player)
	T_Mastema.postPlayerInit(player)
end

return MC_POST_PLAYER_INIT