local UnlockManager = require("mastema_src.unlock_manager")
local Mastema = require("mastema_src.characters.mastema")
local T_Mastema = require("mastema_src.characters.t_mastema")
local SinisterSight = require("mastema_src.items.passives.sinister_sight")
local UnholyCard = require("mastema_src.items.cards.unholy_card")
local BirthcakeCompat = require("mastema_src.compat.birthcake")

local function MC_POST_PLAYER_UPDATE(_, player)
	UnlockManager.postPlayerUpdate(player)

	Mastema.postPlayerUpdate(player)
	T_Mastema.postPlayerUpdate(player)
	
	SinisterSight.postPlayerUpdate(player)

	UnholyCard.postPlayerUpdate(player)

	BirthcakeCompat.postPlayerUpdate(player)
end

return MC_POST_PLAYER_UPDATE