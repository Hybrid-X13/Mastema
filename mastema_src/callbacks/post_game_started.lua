local Functions = require("mastema_src.functions")
local BirthcakeCompat = require("mastema_src.compat.birthcake")

local function MC_POST_GAME_STARTED(_, isContinue)
	Functions.postGameStarted(isContinue)

	BirthcakeCompat.postGameStarted(isContinue)
end

return MC_POST_GAME_STARTED