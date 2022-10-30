local Mastema = require("mastema_src.characters.mastema")
local T_Mastema = require("mastema_src.characters.t_mastema")
local RavenBeak = require("mastema_src.items.actives.raven_beak")
local TornWings = require("mastema_src.items.passives.torn_wings")
local MastemasWrath = require("mastema_src.items.passives.mastemas_wrath")
local SinisterSight = require("mastema_src.items.passives.sinister_sight")
local SacrificialChalice = require("mastema_src.items.familiars.sacrificial_chalice")
local SatanicCharm = require("mastema_src.items.trinkets.satanic_charm")
local PuristsHeart = require("mastema_src.items.trinkets.purists_heart")
local SpiritsHeart = require("mastema_src.items.trinkets.spirits_heart")
local SanguineJewel = require("mastema_src.items.cards.sanguine_jewel")
local SatanicRitual = require("mastema_src.misc.satanic_ritual")

local function MC_EVALUATE_CACHE(_, player, cacheFlag)
	Mastema.evaluateCache(player, cacheFlag)
	T_Mastema.evaluateCache(player, cacheFlag)
	
	RavenBeak.evaluateCache(player, cacheFlag)
	
	TornWings.evaluateCache(player, cacheFlag)
	MastemasWrath.evaluateCache(player, cacheFlag)
	SinisterSight.evaluateCache(player, cacheFlag)

	SacrificialChalice.evaluateCache(player, cacheFlag)

	SatanicCharm.evaluateCache(player, cacheFlag)
	PuristsHeart.evaluateCache(player, cacheFlag)
	SpiritsHeart.evaluateCache(player, cacheFlag)
	
	SanguineJewel.evaluateCache(player, cacheFlag)

	SatanicRitual.evaluateCache(player, cacheFlag)
end

return MC_EVALUATE_CACHE