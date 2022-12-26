local UnlockManager = require("mastema_src.unlock_manager")
local Mastema = require("mastema_src.characters.mastema")
local T_Mastema = require("mastema_src.characters.t_mastema")
local BloodyHarvest = require("mastema_src.items.actives.bloody_harvest")
local DevilsBargain = require("mastema_src.items.actives.devils_bargain")
local TornWings = require("mastema_src.items.passives.torn_wings")
local MastemasWrath = require("mastema_src.items.passives.mastemas_wrath")
local SacrificialChalice = require("mastema_src.items.familiars.sacrificial_chalice")
local TwistedFaith = require("mastema_src.items.trinkets.twisted_faith")
local PuristsHeart = require("mastema_src.items.trinkets.purists_heart")
local SpiritsHeart = require("mastema_src.items.trinkets.spirits_heart")
local SatanicRitual = require("mastema_src.misc.satanic_ritual")
local SanguineBondFixes = require("mastema_src.misc.sanguine_bond_fixes")

local function MC_POST_PEFFECT_UPDATE(_, player)
	UnlockManager.postPEffectUpdate(player)
	
	Mastema.postPEffectUpdate(player)
	T_Mastema.postPEffectUpdate(player)
	
	BloodyHarvest.postPEffectUpdate(player)
	DevilsBargain.postPEffectUpdate(player)
	
	TornWings.postPEffectUpdate(player)
	MastemasWrath.postPEffectUpdate(player)

	SacrificialChalice.postPEffectUpdate(player)

	TwistedFaith.postPEffectUpdate(player)
	PuristsHeart.postPEffectUpdate(player)
	SpiritsHeart.postPEffectUpdate(player)
	
	SatanicRitual.postPEffectUpdate(player)
	
	SanguineBondFixes.postPEffectUpdate(player)
end

return MC_POST_PEFFECT_UPDATE