local Functions = require("mastema_src.functions")

local function MC_POST_GAME_STARTED(_, isContinue)
	Functions.postGameStarted(isContinue)
end

return MC_POST_GAME_STARTED