local UnlockManager = require("mastema_src.unlock_manager")
local MastemasWrath = require("mastema_src.items.passives.mastemas_wrath")

local function MC_POST_ENTITY_KILL(_, entity)
	UnlockManager.postEntityKill(entity)
	
	MastemasWrath.postEntityKill(entity)
end

return MC_POST_ENTITY_KILL