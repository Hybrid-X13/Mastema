if EID then
	local Enums = require("mastema_src.enums")
	
	--Mimic charge info for cards/runes
	EID:addCardMetadata(Enums.Cards.PRAYER_OF_REPENTANCE, 6, false)
	EID:addCardMetadata(Enums.Cards.UNHOLY_CARD, 6, false)
	EID:addCardMetadata(Enums.Cards.SOUL_OF_MASTEMA, 6, true)
	EID:addCardMetadata(Enums.Cards.SANGUINE_JEWEL, 6, true)

	EID:addBirthright(Enums.Characters.MASTEMA, "The heart cost of items now cycle depending on what your current health is#↑ Buying items gives a random stat up for every heart spent", "Mastema")
	EID:addBirthright(Enums.Characters.T_MASTEMA, "↑ Gain damage, range, and tears up for each broken heart you have#{{BrokenHeart}} Having 11 broken hearts grants {{Collectible118}} Brimstone#{{Collectible441}} Moving to the next floor while at 11 broken hearts causes you to fire a Mega Blast for 8 seconds", "Tainted Mastema")
	--Actives
	EID:addCollectible(Enums.Collectibles.BLOODY_HARVEST, "Spawns a pickup that's surrounded by spikes#Has a chance to spawn a devil deal instead", "Bloody Harvest")
	EID:addCollectible(Enums.Collectibles.RAVEN_BEAK, "Consumes all pickups in the room and grants a small, permanent damage up for each pickup consumed#The amount of damage gained is based on the quality of the pickups", "Raven Beak")
	EID:addCollectible(Enums.Collectibles.DEVILS_BARGAIN, "Grants a passive item from the current room's pool and removes some heart containers#After being fully charged without getting hit, you get to keep the item plus the hearts that were taken are given back#If you get hit while recharging, the item is taken away and your hearts won't be returned", "Devil's Bargain")
	EID:addCollectible(Enums.Collectibles.BROKEN_DICE, "Rerolls all pedestal items and pickups in the room but gives 1 broken heart each use#While held, removes 1 broken heart at the start of each floor", "Broken Dice")
	--Passives
	EID:addCollectible(Enums.Collectibles.BOOK_OF_JUBILEES, "Every 7th room cleared grants one of the following rewards:#{{Coin}} 7 pennies#{{Heart}} A random heart#{{Coin}} A random high quality coin#{{SoulHeart}} A random high quality heart#{{Collectible313}} A holy mantle shield#Every 49th room cleared grants the effect of sleeping in a bed", "Book of Jubilees")
	EID:addCollectible(Enums.Collectibles.MASTEMAS_WRATH, "When entering a hostile room, the enemy with the highest hp will be marked#Killing that enemy grants ↑+2 damage up for the room#If the enemy is a boss, the damage persists between rooms but will slowly fade away", "Mastema's Wrath")
	EID:addCollectible(Enums.Collectibles.TORN_WINGS, "{{DevilRoom}} Devil items can appear in any item pool#{{Tears}} Tears up for each item that grants flight#!!! Prevents flight for the rest of the run", "Torn Wings")
	EID:addCollectible(Enums.Collectibles.BLOODSPLOSION, "Enemies have a 50% chance to explode and create a pool of red creep upon death#The explosion deals your current damage and can spread status effects if the enemy died with any#Explosions caused by this item can't damage you", "Bloodsplosion")
	EID:addCollectible(Enums.Collectibles.SINISTER_SIGHT, "↑ +0.5 Tears up#Gain homing tears#{{Fear}} Tears have a chance to fear enemies#Feared enemies take 1.5x damage from all sources", "Sinister Sight")
	EID:addCollectible(Enums.Collectibles.SACRIFICIAL_CHALICE, "Chalice familiar that gets filled with blood each time you get hit#When moving to the next floor, gain devil themed rewards based on how many hits you took the previous floor, including a chance for devil items#!!! Moving to the next floor when the chalice is empty has a negative effect", "Sacrificial Chalice")
	EID:addCollectible(Enums.Collectibles.CORRUPT_HEART, "{{BlackHeart}} +1 Black heart#All heart types have a 33% chance of being converted into either a black heart or black locusts", "Corrupt Heart")
	--Transformation contributions
	EID:assignTransformation("collectible", Enums.Collectibles.BOOK_OF_JUBILEES, EID.TRANSFORMATION["BOOKWORM"])
	--Trinkets
	EID:addTrinket(Enums.Trinkets.ETERNAL_CARD, "{{Card}} Using a card has a 10% chance of granting an {{EternalHeart}}eternal heart#Doesn't work with runes, soul stones, or anything that's not a card", "Eternal Card")
	EID:addTrinket(Enums.Trinkets.LIFE_SAVINGS, "Demon beggars, blood donation machines, and confessionals have a 15% chance to not take health", "Life Savings")
	EID:addTrinket(Enums.Trinkets.TWISTED_FAITH, "!!! Automatically smelted on pickup#{{DevilRoom}} Devil room items are free but only one can be taken#{{AngelRoom}} Angel room items cost hearts but you can take multiple", "Twisted Faith")
	EID:addTrinket(Enums.Trinkets.MANTLED_HEART, "{{SoulHeart}} Picking up a soul heart has a 15% chance of granting a {{Collectible313}} Holy Mantle shield#{{EternalHeart}} 30% chance when picking up eternal hearts", "Mantled Heart")
	EID:addTrinket(Enums.Trinkets.GOODWILL_TAG, "While held, certain special rooms will always contain a beggar:#{{AngelRoom}} Angel: #{{Blank}} Normal beggar#{{DevilRoom}} Devil: #{{Blank}} Demon beggar#{{TreasureRoom}} Treasure: #{{Blank}} Key beggar", "Goodwill Tag")
	EID:addTrinket(Enums.Trinkets.SHATTERED_SOUL, "{{DevilRoom}} Devil rooms will have an extra item that costs broken hearts#You can only choose between this item or the room's devil deals#{{SacrificeRoom}} Using a sacrifice room removes all broken hearts but will also destroy the trinket", "Shattered Soul")
	EID:addTrinket(Enums.Trinkets.SATANIC_CHARM, "Paying for a devil deal grants ↑+0.5 damage up#Mastema and Tainted Mastema only gain +0.25 damage", "Satanic Charm")
	EID:addTrinket(Enums.Trinkets.PURISTS_HEART, "↑ 1.2x Damage multiplier if you don't have any soul or black hearts", "Purist's Heart")
	EID:addTrinket(Enums.Trinkets.SPIRITS_HEART, "↑ 1.2x Tear multiplier if you don't have any red heart containers or bone hearts", "Spirit's Heart")
	--Cards/runes
	EID:addCard(Enums.Cards.LIFE_DICE, "Rerolls your total amount of health", "Life Dice")
	EID:addCard(Enums.Cards.PRAYER_OF_REPENTANCE, "Spawns a Confessional", "Prayer of Repentance")
	EID:addCard(Enums.Cards.SOUL_OF_MASTEMA, "Spawns an item from a random pool and will either:#{{BrokenHeart}} Give broken hearts based on the item's quality#{{Heart}} Remove hearts equivalent to a devil deal#Or spawn the item for free", "Soul of Mastema")
	EID:addCard(Enums.Cards.UNHOLY_CARD, "{{Collectible118}} Grants mega Brimstone for the current room", "Unholy Card")
	EID:addCard(Enums.Cards.SANGUINE_JEWEL, "Take 1 full heart of damage to get a reward:#35%: Nothing#↑ 33%: +0.5 Damage up#{{Coin}} 15%: 6 pennies#{{BlackHeart}} 10%: 2 Black hearts#{{DevilRoom}} 5%: Random devil item#2%: Leviathan transformation", "Sanguine Jewel")
	--Golden trinket effects
	EID:addGoldenTrinketMetadata(Enums.Trinkets.ETERNAL_CARD, nil, 10, 3)
	EID:addGoldenTrinketMetadata(Enums.Trinkets.LIFE_SAVINGS, nil, 15, 3)
	EID:addGoldenTrinketMetadata(Enums.Trinkets.TWISTED_FAITH, "Extra soul heart spawn in devil rooms; extra black heart in angel rooms", 0, 2)
	EID:addGoldenTrinketMetadata(Enums.Trinkets.MANTLED_HEART)
	EID:addGoldenTrinketMetadata(Enums.Trinkets.GOODWILL_TAG, {"{{Shop}} Shop: #{{Blank}} Battery bum", "{{Shop}} Shop: #{{Blank}} Battery bum#{{SecretRoom}} Secret: #{{Blank}} Bomb bum"}, 0, 3)
	EID:addGoldenTrinketMetadata(Enums.Trinkets.SHATTERED_SOUL, "Reduces the broken heart cost of the item by 1", 0, 2)
	EID:addGoldenTrinketMetadata(Enums.Trinkets.SATANIC_CHARM, nil, {0.5, 0.25}, 3)

	-- Русский
	EID:addBirthright(Enums.Characters.MASTEMA, "Цены предметов за сердца теперь меняются в зависимости от текущего здоровья игрока#↑ Покупка предметов теперь даёт плюс к характеристике за каждое потраченное сердце", "Мастема", "ru")
	EID:addBirthright(Enums.Characters.T_MASTEMA, "↑ Плюс к урону, дальности и скорострельности за каждое разбитое сердце#{{BrokenHeart}} Имея 11 разбитых сердец игрок получает {{Collectible118}} Серу#{{Collectible441}} Переходя на следующий этаж с 11 разбитыми сердцами игрок активирует Мегазаряд на 8 секунд", "Порченый Мастема", "ru")
	--Actives
	EID:addCollectible(Enums.Collectibles.BLOODY_HARVEST, "Спавнит расходник за шипами#Есть шанс вместо этого заспавнить дьявольскую сделку", "Кровавая Жатва", "ru")
	EID:addCollectible(Enums.Collectibles.RAVEN_BEAK, "Поглощает все пикапы в комнате, даруя небольшой, но постоянный плюс к урону за каждый поглощённый пикап#Кол-во урона зависит от качества поглощённых пикапов", "Вороний Клюв", "ru")
	EID:addCollectible(Enums.Collectibles.DEVILS_BARGAIN, "Дарует пассивный предмет из пула текущей комнаты и отбирает немного сердец#После полного заряда, при условии, что вы ни разу не получали урон, вы сохраняете пассивный предмет и вам возвращаются ваши сердца#Если вы получили урон при заряде, предмет отбирается и сердца не вернутся", "Дьявольский Договор", "ru")
	EID:addCollectible(Enums.Collectibles.BROKEN_DICE, "Реролит все предметы на пьедисталах но даёт одно разбитое сердце за каждое использование#Пока в руках, 1 разбитое сердце убирается при переходе на этаж", "Разбитый Кубик", "ru")
	--Passives
	EID:addCollectible(Enums.Collectibles.BOOK_OF_JUBILEES, "Каждую 7-ю комнату даёт одну из следующих наград:#{{Coin}} 7 пенни#{{Heart}} Случайное сердце#{{Coin}} Случайная монетка высокого качества#{{SoulHeart}} Случайное сердце высокого качества#{{Collectible313}} Щит Святой Мантии#Каждую 49-ю комнату даёт заслуженный отдых", "Книга Юбилеев", "ru")
	EID:addCollectible(Enums.Collectibles.MASTEMAS_WRATH, "При заходе в комнату с врагами, враг с самым высоким здоровьем будет помечен#Убийство этого врага даёт ↑+2 урона игроку до конца комнаты#Если этот враг - босс, то эффект будет сохраняться между комнатами, но медленно испаряться", "Гнев Мастемы", "ru")
	EID:addCollectible(Enums.Collectibles.TORN_WINGS, "{{DevilRoom}} Предметы пула дьявола могут появиться в любом пуле#{{Tears}} Плюс скорострельность за каждый предмет дающий полёт#!!! Предотвращает полёт на весь забег", "Порванные Крылья", "ru")
	EID:addCollectible(Enums.Collectibles.BLOODSPLOSION, "У врагов есть 50% взорваться и оставить лужу крови после смерти#Взрыв наносит текущий урон игрока и может распространить статусные эффекты, если у врага они были#Взрывы от этого предмета не наносят урон игрокам", "Крововзрыв", "ru")
	EID:addCollectible(Enums.Collectibles.SINISTER_SIGHT, "↑ +0.5 Скорострельность#Даёт самонаводку#{{Fear}} Слёзы имеют шанс наложить страх#Враги под страхом получают 1.5х больше урона из любого источника", "Зловещий Взгляд", "ru")
	EID:addCollectible(Enums.Collectibles.SACRIFICIAL_CHALICE, "Фамильяр-чаша, наполняющийся каждый раз когда игрок получает урон#При переходе на следующий этаж, даёт разные дьявольские награды в зависимости от полученного на предыдущем этаже урона, вкл. дьявольские предметы#!!! Переходя на следующий этаж с пустой чашей имеет негативный эффект", "Чаша Жертвоприношений", "ru")
	EID:addCollectible(Enums.Collectibles.CORRUPT_HEART, "{{BlackHeart}} +1 Чёрное сердце#Все виды сердец имеют 33% шанс превратиться либо в чёрное сердце либо в чёрную саранчу", "Порченое Сердце", "ru")
	--Trinkets
	EID:addTrinket(Enums.Trinkets.ETERNAL_CARD, "{{Card}} Использование карты имеет 10% шанс даровать {{EternalHeart}}вечное сердце#Не работает с рунами, камнями душ или чем-либо ещё не являющимся картой", "Вечная Карта", "ru")
	EID:addTrinket(Enums.Trinkets.LIFE_SAVINGS, "Дьявольские попрошайки, банк по сдачи крови и исповедальни имеют 15% шанс не потратить здоровье игрока", "Жизненные Сбережения", "ru")
	EID:addTrinket(Enums.Trinkets.TWISTED_FAITH, "!!! Автоматически приваривается при подборе#{{DevilRoom}} Дьявольские предметы теперь бесплатные но только один может быть взят#{{AngelRoom}} Ангельские предметы теперь стоят сердца но можно взять несколько", "Невера", "ru")
	EID:addTrinket(Enums.Trinkets.MANTLED_HEART, "{{SoulHeart}} Подбор сердца души имеет 15% шанс дать {{Collectible313}} щит Святой Мантии#{{EternalHeart}} 30% Шанс при подборе вечного сердца", "Укрытое Сердце", "ru")
	EID:addTrinket(Enums.Trinkets.GOODWILL_TAG, "Пока в руках, некоторые специальные комнаты будут содержать попрошайку:#{{AngelRoom}} Ангел: #{{Blank}} Обычный попрошайка#{{DevilRoom}} Devil: #{{Blank}} Дьявольский попрошайка#{{TreasureRoom}} Treasure: #{{Blank}} Мастер Ключей", "Бирка доброй воли", "ru")
	EID:addTrinket(Enums.Trinkets.SHATTERED_SOUL, "{{DevilRoom}} Дьявольские комнаты содержат дополнительный предмет стоящий разбитые сердца#Можно выбрать только между этим предметом и сделками самой комнаты#{{SacrificeRoom}} Использование комнаты жертвоприношений сбросит все разбитые сердца, но и уничтожит этот брелок", "Треснувшая Душа", "ru")
	EID:addTrinket(Enums.Trinkets.SATANIC_CHARM, "Покупка дьявольской сделки даёт ↑+0.5 урона#Мастема и Порченый Мастема получают лишь ↑+0.25 урона", "Сатанинский амулет", "ru")
	EID:addTrinket(Enums.Trinkets.PURISTS_HEART, "↑ 1.2x Мультипликатора урона если игрок не имеет черных сердец или сердец душ", "Сердце Пуриста", "ru")
	EID:addTrinket(Enums.Trinkets.SPIRITS_HEART, "↑ 1.2x Мультипликатора слёз если игрок не имеет красных или костяных сердец", "Сердце Духа", "ru")
	--Cards/runes
	EID:addCard(Enums.Cards.LIFE_DICE, "Реролит здоровье игрока", "Кубики Жизни", "ru")
	EID:addCard(Enums.Cards.PRAYER_OF_REPENTANCE, "Спавнит исповедальню", "Мольба Покояния", "ru")
	EID:addCard(Enums.Cards.SOUL_OF_MASTEMA, "Спавнит предмет случайного пула, а также одно из следующих:#{{BrokenHeart}} Даст разбитые сердца в зависимости от качества предмета#{{Heart}} Уберёт сердца равноценно дьявольской сделке#Ничего", "Душа Мастемы", "ru")
	EID:addCard(Enums.Cards.UNHOLY_CARD, "{{Collectible118}} Даёт Мега Серу до конца комнаты", "Несвятая карта", "ru")
	EID:addCard(Enums.Cards.SANGUINE_JEWEL, "Получите полное сердце урона взамен:#35%: Ничего#↑ 33%: +0.5 Урона#{{Coin}} 15%: 6 Пенни#{{BlackHeart}} 10%: 2 Чёрных сердца#{{DevilRoom}} 5%: Случайный дьявольский предмет#2%: Превращение Левиафана", "Кровный Камушек", "ru")
end