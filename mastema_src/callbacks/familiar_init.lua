local SacrificialChalice = require("mastema_src.items.familiars.sacrificial_chalice")

local function MC_FAMILIAR_INIT(_, familiar)
	SacrificialChalice.familiarInit(familiar)
end

return MC_FAMILIAR_INIT