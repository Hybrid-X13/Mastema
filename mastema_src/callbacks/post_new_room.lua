local Mastema = require("mastema_src.characters.mastema")
local T_Mastema = require("mastema_src.characters.t_mastema")
local MastemasWrath = require("mastema_src.items.passives.mastemas_wrath")
local SinisterSight = require("mastema_src.items.passives.sinister_sight")
local TwistedFaith = require("mastema_src.items.trinkets.twisted_faith")
local GoodwillTag = require("mastema_src.items.trinkets.goodwill_tag")
local ShatteredSoul = require("mastema_src.items.trinkets.shattered_soul")
local UnholyCard = require("mastema_src.items.cards.unholy_card")
local SatanicRitual = require("mastema_src.misc.satanic_ritual")
local SanguineBondFixes = require("mastema_src.misc.sanguine_bond_fixes")

local function MC_POST_NEW_ROOM()
	Mastema.postNewRoom()
	T_Mastema.postNewRoom()
	
	MastemasWrath.postNewRoom()
	SinisterSight.postNewRoom()
	
	TwistedFaith.postNewRoom()
	GoodwillTag.postNewRoom()
	ShatteredSoul.postNewRoom()

	UnholyCard.postNewRoom()
	
	SatanicRitual.postNewRoom()
	
	SanguineBondFixes.postNewRoom()
end

return MC_POST_NEW_ROOM