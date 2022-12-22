local Mastema = require("mastema_src.characters.mastema")

local function MC_POST_TEAR_INIT(_, tear)
	Mastema.postTearInit(tear)
end

return MC_POST_TEAR_INIT