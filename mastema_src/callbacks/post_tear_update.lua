local Mastema = require("mastema_src.characters.mastema")

local function MC_POST_TEAR_UPDATE(_, tear)
	Mastema.postTearUpdate(tear)
end

return MC_POST_TEAR_UPDATE