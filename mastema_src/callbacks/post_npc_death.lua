local UnlockManager = require("mastema_src.unlock_manager")
local TMastema = require("mastema_src.characters.t_mastema")
local Bloodsplosion = require("mastema_src.items.passives.bloodsplosion")

local function MC_POST_NPC_DEATH(_, npc)
	UnlockManager.postNPCDeath(npc)
	
	TMastema.postNPCDeath(npc)
	
	Bloodsplosion.postNPCDeath(npc)
end

return MC_POST_NPC_DEATH