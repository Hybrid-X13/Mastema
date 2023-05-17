local Enums = {}

Enums.Characters = {
	MASTEMA = Isaac.GetPlayerTypeByName("Mastema", false),
	T_MASTEMA = Isaac.GetPlayerTypeByName("MastemaB", true),
}

Enums.Collectibles = {
	--Actives
	BLOODY_HARVEST = Isaac.GetItemIdByName("Bloody Harvest"),
	RAVEN_BEAK = Isaac.GetItemIdByName("Raven Beak"),
	DEVILS_BARGAIN = Isaac.GetItemIdByName("Devil's Bargain"),
	BROKEN_DICE = Isaac.GetItemIdByName("Broken Dice"),
	--Passives
	BOOK_OF_JUBILEES = Isaac.GetItemIdByName("Book of Jubilees"),
	MASTEMAS_WRATH = Isaac.GetItemIdByName("Mastema's Wrath"),
	TORN_WINGS = Isaac.GetItemIdByName("Torn Wings"),
	BLOODSPLOSION = Isaac.GetItemIdByName("Bloodsplosion"),
	SINISTER_SIGHT = Isaac.GetItemIdByName("Sinister Sight"),
	SACRIFICIAL_CHALICE = Isaac.GetItemIdByName("Sacrificial Chalice"),
	CORRUPT_HEART = Isaac.GetItemIdByName("Corrupt Heart"),
	--Nulls
	SATANIC_RITUAL_DMG_NULL = Isaac.GetItemIdByName("Satanic Ritual DMG"),
	SATANIC_RITUAL_TEARS_NULL = Isaac.GetItemIdByName("Satanic Ritual Tears"),
	SATANIC_RITUAL_SPEED_NULL = Isaac.GetItemIdByName("Satanic Ritual Speed"),
	SATANIC_RITUAL_LUCK_NULL = Isaac.GetItemIdByName("Satanic Ritual Luck"),
	SANGUINE_JEWEL_DMG_NULL = Isaac.GetItemIdByName("Sanguine Jewel DMG"),
}

Enums.Trinkets = {
	ETERNAL_CARD = Isaac.GetTrinketIdByName("Eternal Card"),
	LIFE_SAVINGS = Isaac.GetTrinketIdByName("Life Savings"),
	TWISTED_FAITH = Isaac.GetTrinketIdByName("Twisted Faith"),
	MANTLED_HEART = Isaac.GetTrinketIdByName("Mantled Heart"),
	GOODWILL_TAG = Isaac.GetTrinketIdByName("Goodwill Tag"),
	SHATTERED_SOUL = Isaac.GetTrinketIdByName("Shattered Soul"),
	SATANIC_CHARM = Isaac.GetTrinketIdByName("Satanic Charm"),
	PURISTS_HEART = Isaac.GetTrinketIdByName("Purist's Heart"),
	SPIRITS_HEART = Isaac.GetTrinketIdByName("Spirit's Heart"),
	MASTEMA_BIRTHCAKE = Isaac.GetTrinketIdByName("Mastema's Cake"),
	T_MASTEMA_BIRTHCAKE = Isaac.GetTrinketIdByName("Tainted Mastema's Cake"),
}

Enums.Cards = {
	SOUL_OF_MASTEMA = Isaac.GetCardIdByName("soulofmastema"),
	UNHOLY_CARD = Isaac.GetCardIdByName("unholycard"),
	PRAYER_OF_REPENTANCE = Isaac.GetCardIdByName("prayerofrepentance"),
	LIFE_DICE = Isaac.GetCardIdByName("lifedice"),
	SANGUINE_JEWEL = Isaac.GetCardIdByName("sanguinejewel"),
}

Enums.Familiars = {
	SACRIFICIAL_CHALICE = Isaac.GetEntityVariantByName("Sacrificial Chalice"),
}

Enums.Effects = {
	MASTEMAS_WRATH_INDICATOR = Isaac.GetEntityVariantByName("Mastema's Wrath Indicator"),
}

Enums.Slots = {
	SLOT = 1,
	BLOOD_DONATION = 2,
	FORTUNE = 3,
	BEGGAR = 4,
	DEVIL_BEGGAR = 5,
	KEY_MASTER = 7,
	BOMB_BUM = 9,
	BATTERY_BUM = 13,
	CONFESSIONAL = 17,
}

Enums.Voicelines = {
	SOUL_OF_MASTEMA = Isaac.GetSoundIdByName("SoulofMastema"),
	UNHOLY_CARD = Isaac.GetSoundIdByName("UnholyCard"),
	PRAYER_OF_REPENTANCE = Isaac.GetSoundIdByName("PrayerofRepentance"),
}

Enums.Dimensions = {
	DEATH_CERTIFICATE = 2,
}

return Enums