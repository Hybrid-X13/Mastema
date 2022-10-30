local TornWings = require("mastema_src.items.passives.torn_wings")
local EternalCard = require("mastema_src.items.trinkets.eternal_card")
local SoulOfMastema = require("mastema_src.items.cards.soul_of_mastema")
local LifeDice = require("mastema_src.items.cards.life_dice")
local PrayerOfRepentance = require("mastema_src.items.cards.prayer_of_repentance")
local UnholyCard = require("mastema_src.items.cards.unholy_card")
local SanguineJewel = require("mastema_src.items.cards.sanguine_jewel")

local function MC_USE_CARD(_, card, player, flags)
	TornWings.useCard(card, player, flags)
	
	EternalCard.useCard(card, player, flags)
	
	SoulOfMastema.useCard(card, player, flags)
	LifeDice.useCard(card, player, flags)
	PrayerOfRepentance.useCard(card, player, flags)
	UnholyCard.useCard(card, player, flags)
	SanguineJewel.useCard(card, player, flags)
end

return MC_USE_CARD