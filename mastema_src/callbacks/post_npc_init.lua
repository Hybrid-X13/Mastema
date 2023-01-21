local DevilsBargain = require("mastema_src.items.actives.devils_bargain")

local function MC_POST_NPC_INIT(_, npc)
	DevilsBargain.postNPCInit(npc)
end

return MC_POST_NPC_INIT