local SatanicRitual = require("mastema_src.misc.satanic_ritual")

local function MC_POST_EFFECT_UPDATE(_, effect)
	SatanicRitual.postEffectUpdate(effect)
end

return MC_POST_EFFECT_UPDATE