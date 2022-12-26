local T_Mastema = require("mastema_src.characters.t_mastema")
local SinisterSight = require("mastema_src.items.passives.sinister_sight")
local SatanicRitual = require("mastema_src.misc.satanic_ritual")

local function MC_POST_EFFECT_UPDATE(_, effect)
	T_Mastema.postEffectUpdate(effect)
	
	SinisterSight.postEffectUpdate(effect)

	SatanicRitual.postEffectUpdate(effect)
end

return MC_POST_EFFECT_UPDATE