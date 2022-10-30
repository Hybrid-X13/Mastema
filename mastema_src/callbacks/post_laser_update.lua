local T_Mastema = require("mastema_src.characters.t_mastema")
local SinisterSight = require("mastema_src.items.passives.sinister_sight")

local function MC_POST_LASER_UPDATE(_, laser)
	T_Mastema.postLaserUpdate(laser)

	SinisterSight.postLaserUpdate(laser)
end

return MC_POST_LASER_UPDATE