local Mastema = require("mastema_src.characters.mastema")
local SinisterSight = require("mastema_src.items.passives.sinister_sight")

local function MC_POST_FIRE_TEAR(_, tear)
	Mastema.postFireTear(tear)
	
	SinisterSight.postFireTear(tear)
end

return MC_POST_FIRE_TEAR