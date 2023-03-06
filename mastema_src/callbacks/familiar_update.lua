local Mastema = require("mastema_src.characters.mastema")
local TMastema = require("mastema_src.characters.t_mastema")
local SacrificialChalice = require("mastema_src.items.familiars.sacrificial_chalice")

local function MC_FAMILIAR_UPDATE(_, familiar)
	Mastema.familiarUpdate(familiar)
	TMastema.familiarUpdate(familiar)

	SacrificialChalice.familiarUpdate(familiar)
end

return MC_FAMILIAR_UPDATE