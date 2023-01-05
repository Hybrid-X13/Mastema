local T_Mastema = require("mastema_src.characters.t_mastema")
local ShatteredSoul = require("mastema_src.items.trinkets.shattered_soul")
local SatanicRitual = require("mastema_src.misc.satanic_ritual")

local function MC_POST_RENDER()
	T_Mastema.postRender()

	ShatteredSoul.postRender()
	
	SatanicRitual.postRender()
end

return MC_POST_RENDER