if Encyclopedia then
	local Enums = require("mastema_src.enums")
	local Functions = require("mastema_src.functions")
	local SaveData = require("mastema_src.savedata")
	
	local Wiki = {
		MASTEMA = {
			{ -- Start Data
				{str = "Start Data", fsize = 2, clr = 3, halign = 0},
				{str = "Pocket Active: Prayer Card"},
				{str = "Smelted Trinket: Devil's Crown"},
				{str = "Stats", clr = 3, halign = 0},
				{str = "HP: 2 Red Hearts, 1 Black Heart"},
				{str = "Speed: 0.90"},
				{str = "Tears: 3.53"},
				{str = "Damage: 3.30"},
				{str = "Range: 6.50"},
				{str = "Shotspeed: 1.00"},
				{str = "Luck: 0"},
			},
			{ -- Traits
				{str = "Traits", fsize = 2, clr = 3, halign = 0},
				{str = "As Mastema, most items you come across have to be paid for with his health."},
				{str = "The heart cost of items are based on the item's quality. Quality 0 and 1 items always cost 1 red or 1 soul heart. Quality 2 items cost either 1 red or 2 soul hearts. Quality 3 and 4 items cost 2 - 3 hearts."},
				{str = "Despite having Devil's Crown, devil items have a 50% chance of spawning in red treasure rooms."},
				{str = "However, Mastema's red treasure rooms always contain a blind item, even when you're not on the alt path. Both the visible item and the blind item can be bought."},
				{str = "Mastema innately has the effect of Duality, and he also has additional benefits inside of devil and angel rooms. The Sanguine Bond spikes in devil rooms allows him to gain damage ups, black hearts, and occasionally free devil items."},
				{str = "Items purchased in angel rooms grant a 1-time holy mantle shield."},
				{str = "After depths, Mastema's Prayer Card will only give half a soul heart on use instead of an eternal heart."},
				{str = "In Greed Mode, coins spawned from waves have a 15% chance of being replaced with an eternal heart."},
			},
			{ -- Birthright
				{str = "Birthright", fsize = 2, clr = 3, halign = 0},
				{str = "The heart cost of items now cycle depending on what your current health is."},
				{str = "Buying items gives a random stat up for every heart spent."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "Mastema was a fallen angel from the Book of Jubilees who carried out punishments, tempted humans, and tested their faith, all under the permission of God."},
				{str = "Despite being fallen, which implies that he sinned and was cast out of heaven, it's not described in the Book of Jubilees as to why God still wanted Mastema to carry out duties under his guidance."},
			},
		},
		MASTEMA_B = {
			{ -- Start Data
				{str = "Start Data", fsize = 2, clr = 3, halign = 0},
				{str = "Pocket Active: Satanic Bible"},
				{str = "Stats", clr = 3, halign = 0},
				{str = "HP: 3 Black Hearts"},
				{str = "Speed: 1.20"},
				{str = "Tear Rate: 1.39"},
				{str = "Damage: 3.50"},
				{str = "Range: 6.50"},
				{str = "Shot Speed: 1.00"},
				{str = "Luck: -6.66"},
			},
			{ -- Traits
				{str = "Traits", fsize = 2, clr = 3, halign = 0},
				{str = "Tainted Mastema gains broken hearts when picking up most items. The number of broken hearts added is based on the item's quality:"},
				{str = "- Quality 0-2: 1 broken heart"},
				{str = "- Quality 3: 2 broken hearts"},
				{str = "- Quality 4: 3 broken hearts"},
				{str = "Quest, food (Breakfast, Dinner, etc), and active items won't give any broken hearts."},
				{str = "In addition to Confessionals, Tainted Mastema can use sacrifice rooms and the spikes from Sanguine Bond in devil rooms to remove broken hearts. The chance of removing one increases for every broken heart you have."},
				{str = "1 broken heart is automatically removed at the start of each floor."},
				{str = "In Greed Mode, the spiked button can also remove broken hearts."},
				{str = "Using the Sanguine Bond spikes in devil rooms has a chance to remove the heart cost of a random item in the room. The item will still cost broken hearts if it's a passive item, however."},
			},
			{ -- Birthright
				{str = "Birthright", fsize = 2, clr = 3, halign = 0},
				{str = "Gain damage, range, and tears up for each broken heart you have."},
				{str = "Having 11 broken hearts grants Brimstone."},
				{str = "Moving to the next floor while at 11 broken hearts causes you to fire a Mega Blast for 8 seconds."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "Tainted Mastema's lore is that he himself has fallen into the grasp of temptation by betraying God and instead pledging his new faith to the devil, who claimed to offer him more than God ever could."},
				{str = "In return, the devil restored Mastema's torn wings and gave him newfound power, with the catch that he'll forever have to sacrifice his blood to him in order to stay alive."},
			},
		},
		BOOK_OF_JUBILEES = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Every 7th room cleared grants one of the following rewards:"},
				{str = "- 7 pennies"},
				{str = "- A random heart"},
				{str = "- A random high quality coin"},
				{str = "- A random high quality heart"},
				{str = "- A holy mantle shield"},
				{str = "Every 49th room cleared grants the effect of sleeping in a bed."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "The Book of Jubilees is the book that Mastema is from."},
				{str = "One of the things it mentions is the Year of Jubilee, which occurred after every 49 years. During this year, all debts were pardoned, people were laid off work, and all slaves were freed. It was a time of rest and health."},
			},
		},
		BLOODY_HARVEST = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Spawns a random pickup that's surrounded by spikes."},
				{str = "Has a chance to spawn a devil deal instead."},
			},
		},
		MASTEMAS_WRATH = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "When entering a hostile room, the enemy with the highest hp will be marked."},
				{str = "Killing that enemy grants +2 damage up for the room."},
				{str = "If the enemy is a boss, the damage persists between rooms but will slowly fade away."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "This item's effect is based on the following quote from the Book of Jubilees:"},
				{str = "For on this night -the beginning of the festival and the beginning of the joy- ye were eating the passover in Egypt, when all the powers of Mastema had been let loose to slay all the first-born in the land of Egypt, from the first-born of Pharaoh to the first-born of the captive maid-servant in the mill, and to the cattle."},
			},
		},
		TORN_WINGS = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Devil items can appear in any item pool."},
				{str = "Tears up for each item and transformation you have that grants flight."},
				{str = "Prevents flight for the rest of the run (the only exception is the Beast fight)."},
			},
			{ -- Interactions
				{str = "Interactions", fsize = 2, clr = 3, halign = 0},
				{str = "Characters that have innate flight will immediately gain a tears up."},
				{str = "Certain effects that grant temporary flight will also grant a tears up for their duration, such as:"},
				{str = "- The Bible"},
				{str = "- The Hanged Man"},
				{str = "- The Devil?"},
				{str = "- The Sun?"},
				{str = "- Soul of the Lost/the white fire"},
				{str = "- Astral Projection"},
				{str = "- Spirit Shackles"},
				{str = "- Esau Jr"},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "This item is a direct reference to Mastema's torn wings and the fact that he's a fallen angel, which are angels who have sinned and have been cast out of heaven."},
				{str = "He cry cause no fly."},
			},
		},
		RAVEN_BEAK = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Consumes all pickups in the room and grants a small, permanent damage up for each pickup consumed."},
				{str = "The amount of damage gained is based on the quality of the pickups, similar to Bag of Crafting."},
			},
			{ -- Interactions
				{str = "Interactions", fsize = 2, clr = 3, halign = 0},
				{str = "Chests, sacks, and pedestal items won't be consumed."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "This item is based on the following quote from the Book of Jubilees:"},
				{str = "And the prince Mastema sent ravens and birds to devour the seed which was sown in the land, in order to destroy the land, and rob the children of men of their labours. Before they could plough in the seed, the ravens picked (it) from the surface of the ground. And for this reason he called his name Terah because the ravens and the birds reduced them to destitution and devoured their seed. And the years began to be barren, owing to the birds, and they devoured all the fruit of the trees from the trees: it was only with great effort that they could save a little of all the fruit of the earth in their days."},
			},
		},
		BLOODSPLOSION = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Enemies have a 50% chance to explode and create a pool of red creep upon death."},
				{str = "The explosion deals your current damage and can spread status effects if the enemy died with any."},
				{str = "Explosions caused by this item can't damage you."},
			},
			{ -- Interactions
				{str = "Interactions", fsize = 2, clr = 3, halign = 0},
				{str = "The explosions caused by this item don't inherit any bomb effects you have."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "This item is based on Krieg's skill with the same name from Borderlands 2, one of my other favorite games besides Isaac."},
			},
		},
		DEVILS_BARGAIN = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Grants a passive item from the current room's pool and removes heart containers equivalent to a devil deal."},
				{str = "The number of hearts removed is based on your current health and the quality of the item given."},
				{str = "After being fully charged without getting hit, you get to keep the item plus the hearts that were taken are given back."},
				{str = "If you get hit while recharging, the item is taken away and your hearts won't be returned. When this happens, Devil's Bargain instantly recharges."},
			},
			{ -- Interactions
				{str = "Interactions", fsize = 2, clr = 3, halign = 0},
				{str = "Acts as a one-time use item when used by the Lost or tainted Lost."},
			},
		},
		BROKEN_DICE = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Rerolls all pedestal items and pickups in the room but gives 1 broken heart each use."},
				{str = "While held, removes 1 broken heart at the start of each floor."},
			},
			{ -- Interactions
				{str = "Interactions", fsize = 2, clr = 3, halign = 0},
				{str = "Car Battery", clr = 3, halign = 0},
				{str = "Has no effect."},
				{str = "The Lost/Tainted Lost", clr = 3, halign = 0},
				{str = "This item has a 1/6 chance to be removed when used by the Lost or Tainted Lost."},
			},
		},
		SINISTER_SIGHT = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "+0.5 Tears up."},
				{str = "Gain homing tears."},
				{str = "Tears have a chance to fear enemies."},
				{str = "Feared enemies take 1.5x damage from all sources."},
			},
		},
		SACRIFICIAL_CHALICE = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Gain a chalice familiar that gets filled with blood each time you get hit."},
				{str = "When moving to the next floor, gain devil themed rewards based on how many hits you took the previous floor, including a chance for devil items. The rewards could be black hearts, black locusts, black sacks, or red chests."},
				{str = "Moving to the next floor when the chalice is empty will either remove some hearts containers or give some broken hearts."},
			},
			{ -- Synergies
				{str = "Synergies", fsize = 2, clr = 3, halign = 0},
				{str = "BFFS!", clr = 3, halign = 0},
				{str = "The chalice is guaranteed to give at least one reward each floor and can no longer give a negative effect, even if you didn't get hit on the previous floor."},
			},
		},
		CORRUPT_HEART = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "+1 Black heart."},
				{str = "All heart types have a 33% chance of being converted into either a black heart or black locusts."},
			},
		},
		ETERNAL_CARD = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Using a card has a 10% chance of granting an eternal heart."},
				{str = "Doesn't work with runes, soul stones, or anything that's not a card."},
			},
		},
		LIFE_SAVINGS = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Demon beggars, blood donation machines, and confessionals have a 15% chance to not take health."},
				{str = "Also allows for one free play of Satanic Rituals, but the trinket will be destroyed."},
			},
		},
		TWISTED_FAITH = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Automatically smelted on pickup."},
				{str = "Devil room items are free but only one can be taken."},
				{str = "Angel room items cost hearts but you can take multiple."},
			},
			{ -- Synergies
				{str = "Synergies", fsize = 2, clr = 3, halign = 0},
				{str = "Mom's Box/Golden Variant", clr = 3, halign = 0},
				{str = "An extra soul heart appears in devil rooms and an extra black heart spawns in angel rooms."},
			},
		},
		MANTLED_HEART = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Picking up a soul heart has a 15% chance of granting a holy mantle shield."},
				{str = "30% chance when picking up eternal hearts."},
			},
		},
		GOODWILL_TAG = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "While held, certain special rooms will always contain a beggar:"},
				{str = "Angel: Normal beggar"},
				{str = "Devil: Demon beggar"},
				{str = "Treasure: Key beggar"},
			},
			{ -- Synergies
				{str = "Synergies", fsize = 2, clr = 3, halign = 0},
				{str = "Mom's Box/Golden Variant", clr = 3, halign = 0},
				{str = "A battery bum will spawn in shops."},
				{str = "Mom's Box + Golden Variant", clr = 3, halign = 0},
				{str = "Bomb beggars appear in secret rooms."},
			},
		},
		SHATTERED_SOUL = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Devil rooms will have an extra item that costs broken hearts."},
				{str = "You can only choose between this item or the room's devil deals."},
				{str = "Using a sacrifice room removes all broken hearts but will also destroy the trinket."},
			},
			{ -- Synergies
				{str = "Synergies", fsize = 2, clr = 3, halign = 0},
				{str = "Mom's Box/Golden Variant", clr = 3, halign = 0},
				{str = "Reduces the broken heart cost of the item by 1."},
			},
		},
		SATANIC_CHARM = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Paying for a devil deal grants +0.5 damage up."},
				{str = "Mastema and Tainted Mastema only gain +0.25 damage."},
			},
		},
		PURISTS_HEART = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "1.2x Damage multiplier if you don't have any soul or black hearts."},
			},
		},
		SPIRITS_HEART = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "1.2x Tear multiplier if you don't have any red heart containers or bone hearts."},
			},
		},
		PRAYER_OF_REPENTANCE = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Spawns a Confessional."},
			},
		},
		SOUL_OF_MASTEMA = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Spawns an item from a random pool and will either:"},
				{str = "- Give broken hearts based on the item's quality"},
				{str = "- Remove hearts equivalent to a devil deal"},
				{str = "- Or spawn the item for free"},
			},
			{ -- Interactions
				{str = "Interactions", fsize = 2, clr = 3, halign = 0},
				{str = "If you think there's no risk to using this as the Lost or Tainted Lost, then think again."},
				{str = "Keeper/Tainted Keeper", clr = 3, halign = 0},
				{str = "Coins will try to be removed first instead of heart containers."},
				{str = "Your Soul", clr = 3, halign = 0},
				{str = "The trinket will be removed instead if Soul of Mastema was supposed to remove heart containers."},
			},
		},
		UNHOLY_CARD = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Grants mega Brimstone for the current room."},
			},
			{ -- Interactions
				{str = "Interactions", fsize = 2, clr = 3, halign = 0},
				{str = "Further uses of this card in the same room, already having Brimstone, or using Sulfur grants a damage up for the room."},
			},
		},
		LIFE_DICE = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Rerolls your total amount of health into any combination of heart types."},
			},
		},
		SANGUINE_JEWEL = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Take 1 full heart of damage to get a reward:"},
				{str = "- 35%: Nothing"},
				{str = "- 33%: +0.5 Damage up."},
				{str = "- 15%: 6 pennies"},
				{str = "- 10%: 2 Black hearts"},
				{str = "- 5%: Random devil item"},
				{str = "- 2%: Leviathan transformation"},
			},
		},
	}
	Encyclopedia.AddCharacter({
		ModName = "Mastema",
		Name = "Mastema",
		WikiDesc = Wiki.MASTEMA,
		ID = Enums.Characters.MASTEMA,
		Sprite = Encyclopedia.RegisterSprite(Functions.GetCurrentModPath() .. "content/gfx/characterportraits.anm2", "Mastema", 0),
	})
	Encyclopedia.AddCharacterTainted({
		ModName = "Mastema",
		Name = "MastemaB",
		Description = "The Persecuted",
		WikiDesc = Wiki.MASTEMA_B,
		ID = Enums.Characters.T_MASTEMA,
		Sprite = Encyclopedia.RegisterSprite(Functions.GetCurrentModPath() .. "content/gfx/characterportraitsalt.anm2", "MastemaB", 0),
	})
	--Unlocks
	Encyclopedia.AddItem({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Collectibles.BOOK_OF_JUBILEES,
		WikiDesc = Wiki.BOOK_OF_JUBILEES,
		Pools = {
			Encyclopedia.ItemPools.POOL_TREASURE,
			Encyclopedia.ItemPools.POOL_ANGEL,
			Encyclopedia.ItemPools.POOL_LIBRARY,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Mastema.BlueBaby then
				self.Desc = "Defeat ??? as Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Collectibles.BLOODY_HARVEST,
		WikiDesc = Wiki.BLOODY_HARVEST,
		Pools = {
			Encyclopedia.ItemPools.POOL_DEVIL,
			Encyclopedia.ItemPools.POOL_GREED_DEVIL,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Mastema.TheLamb then
				self.Desc = "Defeat The Lamb as Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Collectibles.MASTEMAS_WRATH,
		WikiDesc = Wiki.MASTEMAS_WRATH,
		Pools = {
			Encyclopedia.ItemPools.POOL_DEVIL,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Mastema.BossRush then
				self.Desc = "Defeat Boss Rush as Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Collectibles.TORN_WINGS,
		WikiDesc = Wiki.TORN_WINGS,
		Pools = {
			Encyclopedia.ItemPools.POOL_DEVIL,
			Encyclopedia.ItemPools.POOL_GREED_DEVIL,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Mastema.Delirium then
				self.Desc = "Beat The Void as Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Collectibles.RAVEN_BEAK,
		WikiDesc = Wiki.RAVEN_BEAK,
		Pools = {
			Encyclopedia.ItemPools.POOL_TREASURE,
			Encyclopedia.ItemPools.POOL_GREED_TREASURE,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Mastema.Mother then
				self.Desc = "Beat the Corpse as Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Collectibles.BLOODSPLOSION,
		WikiDesc = Wiki.BLOODSPLOSION,
		Pools = {
			Encyclopedia.ItemPools.POOL_TREASURE,
			Encyclopedia.ItemPools.POOL_ULTRA_SECRET,
			Encyclopedia.ItemPools.POOL_GREED_TREASURE,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Mastema.Beast then
				self.Desc = "Beat the Final Chapter as Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Collectibles.DEVILS_BARGAIN,
		WikiDesc = Wiki.DEVILS_BARGAIN,
		Pools = {
			Encyclopedia.ItemPools.POOL_DEVIL,
			Encyclopedia.ItemPools.POOL_GREED_DEVIL,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Mastema.Greedier then
				self.Desc = "Beat Greedier Mode as Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Collectibles.BROKEN_DICE,
		WikiDesc = Wiki.BROKEN_DICE,
		Pools = {
			Encyclopedia.ItemPools.POOL_CURSE,
			Encyclopedia.ItemPools.POOL_RED_CHEST,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Mastema.BossRush then
				self.Desc = "Beat Boss Rush as Tainted Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Collectibles.SINISTER_SIGHT,
		WikiDesc = Wiki.SINISTER_SIGHT,
		Pools = {
			Encyclopedia.ItemPools.POOL_DEVIL,
			Encyclopedia.ItemPools.POOL_GREED_DEVIL,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Mastema.Delirium then
				self.Desc = "Beat The Void as Tainted Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Collectibles.SACRIFICIAL_CHALICE,
		WikiDesc = Wiki.SACRIFICIAL_CHALICE,
		Pools = {
			Encyclopedia.ItemPools.POOL_DEVIL,
			Encyclopedia.ItemPools.POOL_CURSE,
			Encyclopedia.ItemPools.POOL_GREED_DEVIL,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Mastema.Mother then
				self.Desc = "Beat the Corpse as Tainted Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Collectibles.CORRUPT_HEART,
		WikiDesc = Wiki.CORRUPT_HEART,
		Pools = {
			Encyclopedia.ItemPools.POOL_DEVIL,
			Encyclopedia.ItemPools.POOL_DEMON_BEGGAR,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Mastema.Beast then
				self.Desc = "Beat the Final Chapter as Tainted Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddTrinket({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Trinkets.ETERNAL_CARD,
		WikiDesc = Wiki.ETERNAL_CARD,
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Mastema.Isaac then
				self.Desc = "Defeat Isaac as Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddTrinket({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Trinkets.LIFE_SAVINGS,
		WikiDesc = Wiki.LIFE_SAVINGS,
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Mastema.Satan then
				self.Desc = "Defeat Satan as Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddTrinket({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Trinkets.TWISTED_FAITH,
		WikiDesc = Wiki.TWISTED_FAITH,
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Mastema.MegaSatan then
				self.Desc = "Defeat Mega Satan as Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddTrinket({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Trinkets.MANTLED_HEART,
		WikiDesc = Wiki.MANTLED_HEART,
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Mastema.Greed then
				self.Desc = "Beat Greed Mode as Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddTrinket({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Trinkets.GOODWILL_TAG,
		WikiDesc = Wiki.GOODWILL_TAG,
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Mastema.Isaac then
				self.Desc = "Defeat Isaac as Tainted Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddTrinket({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Trinkets.SHATTERED_SOUL,
		WikiDesc = Wiki.SHATTERED_SOUL,
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Mastema.Satan then
				self.Desc = "Defeat Satan as Tainted Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddTrinket({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Trinkets.SATANIC_CHARM,
		WikiDesc = Wiki.SATANIC_CHARM,
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Mastema.Greed then
				self.Desc = "Beat Greed Mode as Tainted Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddTrinket({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Trinkets.PURISTS_HEART,
		WikiDesc = Wiki.PURISTS_HEART,
		UnlockFunc = function(self)
			if not Functions.HasFullCompletion(Enums.Characters.MASTEMA) then
				self.Desc = "Get full completion marks as Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddTrinket({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Trinkets.SPIRITS_HEART,
		WikiDesc = Wiki.SPIRITS_HEART,
		UnlockFunc = function(self)
			if not Functions.HasFullCompletion(Enums.Characters.T_MASTEMA) then
				self.Desc = "Get full completion marks as Tainted Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddCard({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Cards.LIFE_DICE,
		WikiDesc = Wiki.LIFE_DICE,
		Spr = Encyclopedia.RegisterSprite(Functions.GetCurrentModPath() .. "content/gfx/ui_cardfronts.anm2", "lifedice", 0),
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Mastema.Hush then
				self.Desc = "Defeat Hush as Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddCard({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Cards.PRAYER_OF_REPENTANCE,
		WikiDesc = Wiki.PRAYER_OF_REPENTANCE,
		Spr = Encyclopedia.RegisterSprite(Functions.GetCurrentModPath() .. "content/gfx/ui_cardfronts.anm2", "prayerofrepentance", 0),
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Mastema.BlueBaby then
				self.Desc = "Defeat ??? as Tainted Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddCard({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Cards.UNHOLY_CARD,
		WikiDesc = Wiki.UNHOLY_CARD,
		Spr = Encyclopedia.RegisterSprite(Functions.GetCurrentModPath() .. "content/gfx/ui_cardfronts.anm2", "unholycard", 0),
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Mastema.Greedier then
				self.Desc = "Beat Greedier Mode as Tainted Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddRune({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Cards.SANGUINE_JEWEL,
		WikiDesc = Wiki.SANGUINE_JEWEL,
		Spr = Encyclopedia.RegisterSprite(Functions.GetCurrentModPath() .. "content/gfx/ui_cardfronts.anm2", "sanguinejewel", 0),
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Mastema.TheLamb then
				self.Desc = "Defeat The Lamb as Tainted Mastema."
				return self
			end
		end,
	})
	Encyclopedia.AddSoul({
		Class = "Mastema",
		ModName = "Mastema",
		ID = Enums.Cards.SOUL_OF_MASTEMA,
		WikiDesc = Wiki.SOUL_OF_MASTEMA,
		Spr = Encyclopedia.RegisterSprite(Functions.GetCurrentModPath() .. "content/gfx/ui_cardfronts.anm2", "soulofmastema", 0),
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Mastema.Hush then
				self.Desc = "Defeat Hush as Tainted Mastema."
				return self
			end
		end,
	})
end