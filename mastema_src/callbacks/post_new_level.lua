local SaveData = require("mastema_src.savedata")
local Mastema = require("mastema_src.characters.mastema")
local T_Mastema = require("mastema_src.characters.t_mastema")
local BrokenDice = require("mastema_src.items.actives.broken_dice")
local SacrificialChalice = require("mastema_src.items.familiars.sacrificial_chalice")
local ShatteredSoul = require("mastema_src.items.trinkets.shattered_soul")

local function MC_POST_NEW_LEVEL()
	SaveData.postNewLevel()

	Mastema.postNewLevel()
	T_Mastema.postNewLevel()
	
	BrokenDice.postNewLevel()

	SacrificialChalice.postNewLevel()

	ShatteredSoul.postNewLevel()
end

return MC_POST_NEW_LEVEL