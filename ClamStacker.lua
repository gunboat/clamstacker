ClamStacker = LibStub("AceAddon-3.0"):NewAddon("ClamStacker", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ClamStacker", false)
local version = "1.6.50"

local debugFrame = tekDebug and tekDebug:GetFrame("ClamStacker")

local function Set(list)
    local set = {}
    for _, l in ipairs(list) do set[tostring(l)] = true end
    return set
end

local lockboxItemIds = Set {
4632, --Ornate Bronze Lockbox
4633, --Heavy Bronze Lockbox
4634, --Iron Lockbox
4636, --Strong Iron Lockbox
4637, --Steel Lockbox
4638, --Reinforced Steel Lockbox
5758, --Mithril Lockbox
5759, --Thorium Lockbox
5760, --Eternium Lockbox
6354, --Small Locked Chest
6355, --Sturdy Locked Chest
13875, --Ironbound Locked Chest
13918, --Reinforced Locked Chest
16882, --Battered Junkbox
16883, --Worn Junkbox
16884, --Sturdy Junkbox
16885, --Heavy Junkbox
29569, --Strong Junkbox
31952, --Khorium Lockbox
43575, --Reinforced Junkbox
43622, --Froststeel Lockbox
43624, --Titanium Lockbox
45986, --Tiny Titanium Lockbox
63349, --Flame-Scarred Junkbox
68729, --Elementium Lockbox
88165, --Vine-Cracked Junkbox
88567, --Ghost Iron Lockbox
116920, --True Steel Lockbox
}

local salvagedGoods = Set {
114116, --Bag of Salvaged Goods
114119, --Crate of Salvage
114120, --Big Crate of Salvage
118473, --Small Sack of Salvaged Goods
}

local armorTokens = Set {
102263, --Timeless Plate Chestpiece
102264, --Timeless Plate Boots
102265, --Timeless Plate Gloves
102266, --Timeless Plate Helm
102267, --Timeless Plate Leggings
102268, --Timeless Plate Spaulders
102269, --Timeless Plate Belt
102270, --Timeless Mail Chestpiece
102271, --Timeless Mail Boots
102272, --Timeless Mail Gloves
102273, --Timeless Mail Helm
102274, --Timeless Mail Leggings
102275, --Timeless Mail Spaulders
102276, --Timeless Mail Belt
102277, --Timeless Leather Chestpiece
102278, --Timeless Leather Boots
102279, --Timeless Leather Gloves
102280, --Timeless Leather Helm
102281, --Timeless Leather Leggings
102282, --Timeless Leather Spaulders
102283, --Timeless Leather Belt
102284, --Timeless Cloth Robes
102285, --Timeless Cloth Boots
102286, --Timeless Cloth Gloves
102287, --Timeless Cloth Helm
102288, --Timeless Cloth Leggings
102289, --Timeless Cloth Spaulders
102290, --Timeless Cloth Belt
102291, --Timeless Signet
102318, --Timeless Cloak
102320, --Timeless Plate Bracers
102321, --Timeless Cloth Bracers
102322, --Timeless Leather Bracers
102323, --Timeless Mail Bracers
102345, --Timeless Lavalliere
102347, --Timeless Curio
114052, --Gleaming Ring
114053, --Shimmering Gauntlets
114057, --Munificent Bracers
114058, --Munificent Robes
114059, --Munificent Treads
114060, --Munificent Gauntlets
114061, --Munificent Hood
114062, --Munificent Leggings
114063, --Munificent Spaulders
114064, --Munificent Girdle
114065, --Munificent Ring
114066, --Munificent Choker
114067, --Munificent Cloak
114068, --Munificent Trinket
114069, --Turbulent Bracers
114070, --Turbulent Robes
114071, --Turbulent Treads
114072, --Turbulent Gauntlets
114073, --Turbulent Hood
114074, --Turbulent Leggings
114075, --Turbulent Spaulders
114076, --Turbulent Girdle
114077, --Turbulent Ring
114078, --Turbulent Choker
114079, --Turbulent Cloak
114080, --Turbulent Trinket
114082, --Grandiose Bracers
114083, --Grandiose Robes
114084, --Grandiose Treads
114085, --Grandiose Spaulders
114086, --Grandiose Choker
114087, --Grandiose Trinket
114094, --Tormented Bracers
114096, --Tormented Treads
114097, --Tormented Gauntlets
114098, --Tormented Hood
114099, --Tormented Leggings
114100, --Tormented Spaulders
114101, --Tormented Girdle
114105, --Tormented Trinket
114108, --Tormented Armament
114109, --Munificent Armament
114110, --Turbulent Armament
114112, --Grandiose Armament
119114, --Grandiose Gauntlets
119116, --Grandiose Hood
119118, --Grandiose Leggings
119120, --Grandiose Girdle
119122, --Grandiose Ring
119124, --Grandiose Cloak
--Coming in patch 6.1
122621, --Shared Turbulent Bracers
122622, --Shared Turbulent Robes
122623, --Shared Turbulent Treads
122624, --Shared Turbulent Gauntlets
122625, --Shared Turbulent Hood
122626, --Shared Turbulent Leggings
122627, --Shared Turbulent Spaulders
122628, --Shared Turbulent Girdle
122629, --Shared Turbulent Ring
122630, --Shared Turbulent Choker
122631, --Shared Turbulent Cloak
122632, --Shared Turbulent Trinket
122633, --Shared Turbulent Armament
124550, --Baleful Bracers
124551, --Baleful Tunic
124552, --Baleful Treads
124553, --Baleful Gauntlets
124554, --Baleful Hood
124555, --Baleful Leggings
124556, --Baleful Spaulders
124557, --Baleful Girdle
124558, --Baleful Ring
124559, --Baleful Choker
124560, --Baleful Cloak
124561, --Baleful Trinket
124562, --Baleful Armament
127777, --Baleful Cloth Bracers
127778, --Baleful Cloth Robe
127780, --Baleful Cloth Gauntlets
127781, --Baleful Cloth Hood
127782, --Baleful Cloth Leggings
127783, --Baleful Cloth Spaulders
127790, --Baleful Leather Bracers
127791, --Baleful Leather Tunic
127792, --Baleful Leather Treads
127793, --Baleful Leather Gauntlets
127794, --Baleful Leather Hood
127795, --Baleful Leather Leggings
127803, --Baleful Mail Bracers
127804, --Baleful Mail Robe
127805, --Baleful Mail Treads
127806, --Baleful Mail Gauntlets
127807, --Baleful Mail Hood
127808, --Baleful Mail Leggings
127809, --Baleful Mail Spaulders
127816, --Baleful Plate Bracers
127817, --Baleful Plate Robe
127818, --Baleful Plate Treads
127819, --Baleful Plate Gauntlets
127820, --Baleful Plate Hood
127821, --Baleful Plate Leggings
127822, --Baleful Plate Spaulders
128348, --Baleful Spaulders
}

local smallDraenorFish = Set {
111589, --Small Crescent Saberfish
111650, --Small Jawless Skulker
111651, --Small Fat Sleeper
111652, --Small Blind Lake Sturgeon
111656, --Small Fire Ammonite
111658, --Small Sea Scorpion
111659, --Small Abyssal Gulper Eel
111662, --Small Blackwater Whiptail

}

local mediumDraenorFish = Set {
111595, --Crescent Saberfish
111663, --Blackwater Whiptail
111664, --Abyssal Gulper Eel
111665, --Sea Scorpion
111666, --Fire Ammonite
111667, --Blind Lake Sturgeon
111668, --Fat Sleeper
111669, --Jawless Skulker

}

local largeDraenorFish = Set {
111601, --Enormous Crescent Saberfish
111670, --Enormous Blackwater Whiptail
111671, --Enormous Abyssal Gulper Eel
111672, --Enormous Sea Scorpion
111673, --Enormous Fire Ammonite
111674, --Enormous Blind Lake Sturgeon
111675, --Enormous Fat Sleeper
111676, --Enourmous Jawless Skulker
}

local smallReagentBits = Set {
89112,  --Mote of Harmony
110610, --Raw Beast Hide Scraps
115502, --Small Luminous Shard
115504, --Fractured Temporal Crystal
}

local smallOreBits = Set {
97512,
97546,
108294,
108296,
108297,
108298,
108299,
108300,
108301,
108302,
108304,
108305,
108306,
108307,
108308,
108309,
108391,
109991, --True Iron Nugget
109992, --Blackrock Fragment
}

local smallHerbBits = Set {
97619,
97620,
97621, -- Silkweed Stem
97622,
97623,
97624,
108318,
108319,
108320,
108321,
108322,
108323,
108324,
108325,
108326,
108327,
108328,
108329,
108330,
108331,
108332,
108333,
108334,
108335,
108336,
108337,
108338,
108339,
108340,
108341,
108342,
108343,
108344,
108345,
108346,
108347,
108348,
108349,
108350,
108351,
108352,
108353,
108354,
108355,
108356,
108357,
108358,
108359,
108360,
108361,
108362,
108363,
108364,
108365,
109624,
109625,
109626,
109627,
109628,
109629, --Talador Orchid Petal
}

local smallLeatherBits = Set {
2934,
}

local mediumLeatherBits = Set {
25649,
33567,
52977, --Savage Leather Scraps
72162,
}

local largeLeatherBits = Set {
112155,
112156,
112157,
112158,
112177,
112178,
112179,
112180,
112181,
112182,
112184,
112185,
}

local clamItemIds = Set {
5523, --small barnacled clam
5524, --thick shelled clam
5738, --Covert Ops Pack
6307, --Message in a Bottle
6351, --Dented Crate
6352, --Waterlogged Crate
6353, --Small Chest
6356, --Battered Chest
6357, --Sealed Crate
6643, --Bloated Smallfish
6645, --Bloated Mud Snapper
6647, --Bloated Catfish
6715, --Ruined Jumper Cables
6827, --Box of Supplies
7190, --Rocket Boots Malfunction
7209, --Tazan's Satchel
7870, --Thaumaturgy Vessel Lockbox
7973, --Big-mouth clam
8049, --Gnarlpine Necklace
8366, --Bloated Trout
8484, --Gadgetzan Water Co. Care Package
8647, --Egg Crate
9265, --Cuergo's Hidden Treasure
9276, --Pirate's Footlocker
9363, --Sparklematic-Wrapped Box
9539, --Box of Rations
9540, --Box of Spells
9541, --Box of Goodies

10479, --Kovic's Trading Satchel
10695, --Box of Empty Vials
10752, --Emerald Encrusted Chest
10773, --Hakkari Urn
10834, --Felhound Tracker Kit
11024, --Evergreen Herb Casing
11422, --Goblin Engineer's Renewal Gift
11423, --Gnome Engineer's Renewal Gift
11568, --Torwa's Pouch
11617, --Eridan's Supplies
11887, --Cenarion Circle Cache
11912, --Package of Empty Ooze Containers
11937, --Fat Sack of Coins
11938, --Sack of Gems
11955, --Bag of Empty Ooze Containers
11966, --Small Sack of Coins
12033, --Thaurissan Family Jewels
12122,
12122, --Kum'isha's Junk
12339, --Vaelan's Gift
12849, --Demon Kissed Sack
13874, --Heavy Crate
13881, --Bloated Redgill
13891, --Bloated Salmon
15102, --Un'Goro Tested Sample
15103, --Corrupt Tested Sample
15699,
15699, --Small Brown-Wrapped Package
15874,
15876, --Nathanos' Chest
17305, --Green Ribboned Holiday Gift
17685,
17685, --Smokywood Pastures Sampler
17726,
17726, --Smokywood Pastures Special Gift
17727,
17727, --Smokywood Pastures Gift Pack
17962, --Blue Sack of Gems
17963, --Green Sack of Gems
17964, --Gray Sack of Gems
17965, --Yellow Sack of Gems
17969, --Red Sack of Gems
18636, --Ruined Jumper Cables XL
18804, --Lord Grayson's Satchel
19035, --Lard's Special Picnic Basket
19150, --Sentinel Basic Care Package
19151, --Sentinel Standard Care Package
19152, --Sentinel Advanced Care Package
19153, --Outrider Advanced Care Package
19154, --Outrider Basic Care Package
19155, --Outrider Standard Care Package
19296, --Greater Darkmoon Prize
19297, --Lesser Darkmoon Prize
19298, --Minor Darkmoon Prize
19422, --Darkmoon Faire Fortune
19425, --Mysterious Lockbox
20228, --Defiler's Advanced Care Package
20229, --Defiler's Basic Care Package
20230, --Defiler's Standard Care Package
20231, --Arathor Advanced Care Package
20233, --Arathor Basic Care Package
20236, --Arathor Standard Care Package
20393,
20469, --Decoded True Believer Clippings
20601, --Sack of Spoils
20602, --Chest of Spoils
20603, --Bag of Spoils
20708, --Tightly Sealed Trunk
20766, --Slimy Bag
20767,
20767, --Scum Covered Bag
20768,
20768, --Oozing Bag
20808, --Combat Assignment
21042, --Narain's Special Kit
21113,
21113, --Watertight Trunk
21131, --Followup Combat Assignment
21150,
21150, --Iron Bound Trunk
21156, --Scarab Bag
21162, --Bloated Oily Blackmouth
21164, --Bloated Rockscale Cod
21191,
21191, --Carefully Wrapped Present
21216,
21216, --Smokywood Pastures Extra-Special Gift
21228,
21228, --Mithril Bound Trunk
21270,
21270, --Gently Shaken Gift
21271,
21271, --Gently Shaken Gift
21310,
21310, --Gaily Wrapped Present
21315, --Smokywood Satchel
21327,
21327, --Ticking Present
21363,
21363, --Festive Gift
21528, --Colossal Bag of Loot
21640, --Lunar Festival Fireworks Pack
21740, --Small Rocket Recipes
21741, --Cluster Rocket Recipes
21742, --Large Rocket Recipes
21743, --Large Cluster Rocket Recipes
21746,
21746, --Lucky Red Envelope
21812, --Box of Chocolates
21975, --Pledge of Adoration: Stormwind
21979, --Gift of Adoration: Darnassus
21980, --Gift of Adoration: Ironforge
21981, --Gift of Adoration: Stormwind
22137, --Ysida's Satchel
22154, --Pledge of Adoration: Ironforge
22155, --Pledge of Adoration: Darnassus
22156, --Pledge of Adoration: Orgrimmar
22157, --Pledge of Adoration: Undercity
22158, --Pledge of Adoration: Thunder Bluff
22159, --Pledge of Friendship: Darnassus
22160, --Pledge of Friendship: Ironforge
22161, --Pledge of Friendship: Orgrimmar
22162, --Pledge of Friendship: Thunder Bluff
22163, --Pledge of Friendship: Undercity
22164, --Gift of Adoration: Orgrimmar
22165, --Gift of Adoration: Thunder Bluff
22166, --Gift of Adoration: Undercity
22167, --Gift of Friendship: Darnassus
22168, --Gift of Friendship: Ironforge
22169, --Gift of Friendship: Orgrimmar
22170, --Gift of Friendship: Stormwind
22171, --Gift of Friendship: Thunder Bluff
22172, --Gift of Friendship: Undercity
22178, --Pledge of Friendship: Stormwind
22320, --Mux's Quality Goods
22568, --Sealed Craftsman's Writ
22746, --Buccaneer's Uniform
23022, --Curmudgeon's Payoff
23921, --Bulging Sack of Silver
24336, --Fireproof Satchel
24402,
24402, --Package of Identified Plants
24476,
25419, --Unmarked Bag of Gems
25422, --Bulging Sack of Gems
25423,
25423, --Bag of Premium Gems
25424, --Gem-Stuffed Envelope
27446, --Mr. Pinchy's Gift
27481,
27481, --Heavy Supply Crate
27511,
27511, --Inscribed Scrollcase
27513,
27513, --Curious Crate
30260, --Voren'thal's Package
30320, --Bundle of Nether Spikes
30650, --Dertrok's Wand Case
31408, --Offering of the Sha'tar
31522, --Primal Mooncloth Supplies
31955, --Arelion's Knapsack
32064, --Protectorate Treasure Cache
32462, --Morthis' Materials
32624, --Large Iron Metamorphosis Geode 
32625, --Small Iron Metamorphosis Geode
32626, --Large Copper Metamorphosis Geode
32627, --Small Copper Metamorphosis Geode
32628, --Large Silver Metamorphosis Geode
32629, --Large Gold Metamorphosis Geode
32630, --Small Gold Metamorphosis Geode
32631, --Small Silver Metamorphosis Geode
32724,
32724, --Sludge-Covered Object
32777, --Kronk's Grab Bag
33045, --Renn's Supplies
33844,
33857,
33857, --Crate of Meat
33926, --Sealed Scroll Case
33928, --Hollowed Bone Decanter
34077,
34077, --Crudely Wrapped Gift
34119, --Black Conrad's Treasure
34426, --Winter Veil Gift
34583, --Aldor Supplies Package
34584, --Scryer Supplies Package
34585, --Scryer Supplies Package
34587, --Aldor Supplies Package
34592, --Aldor Supplies Package
34593, --Scryer Supplies Package
34594, --Scryer Supplies Package
34595, --Aldor Supplies Package
34846, --Black Sack of Gems
34863,
34871, --Crafty's Sack
35232, --Shattered Sun Supplies
35286, --Bloated Giant Sunfish
35313,
35348,
35512, --Pocket Full of Snow
35792,
35792, --Mage Hunter Personal Effects
35945, --Brilliant Glass
36781,
37168, --Mysterious Tarot
37586,
37586, --Handful of Treats
39418, --Ornately Jeweled Box
39883,
39883, --Cracked Egg
39903, --Argent Crusade Gratuity
39904, --Argent Crusade Gratuity
41426,
41426, --Magically Wrapped Gift
41888, --Small Velvet Bag
41989,
42104,
42105,
42106,
42107,
42108,
43346, --Large Satchel of Spoils
43347, --Satchel of Spoils
43504, --Winter Veil Gift
43556, --Patroller's Pack
44113,
44113, --Small Spice Bag
44142, --Strange Tarot
44161, --Arcane Tarot
44163, --Shadowy Tarot
44475,
44475, --Reinforced Crate
44663, --Abandoned Adventurer's Satchel
44700,
44700, --Brooding Darkwater Clam
44718, --Ripe Disgusting Jar
44751,
44751, --Hyldnir Spoils
44943, --Icy Prism
44951, --Box of Bombs
45072,
45072, --Brightly Colored Egg
45328,
45328, --Bloated Slippery Eel
45724,
45724, --Champion's Purse
45875, --Sack of Ulduar Spoils
45878, --Large Sack of Ulduar Spoils
45902,
45909,
46007,
46110, --Alchemist's Cache
46740, --Winter Veil Gift
46809, --Bountiful Cookbook
46810, --Bountiful Cookbook
49294, --Ashen Sack of Gems
49369, --Red Blizzcon Bag
49631, --Standard Apothecary Serving Kit
49909, --Box of Chocolates
49926, --Brazie's Black Book of Secrets
50160, --Lovely Dress Box
50161, --Dinner Suit Box
50238, --Cracked Un'Goro Coconut
50301, --Landro's Pet Box
50409, --Spark's Fossil Finding Kit
51316, --Unsealed Chest
51999,
51999, --Satchel of Helpful Goods
52000,
52000, --Satchel of Helpful Goods
52001,
52001, --Satchel of Helpful Goods
52002,
52002, --Satchel of Helpful Goods
52003,
52003, --Satchel of Helpful Goods
52004,
52004, --Satchel of Helpful Goods
52005,
52005, --Satchel of Helpful Goods
52006,
52006, --Sack of Frosty Treasures
52274, --Earthen Ring Supplies
52304,
52304, --Fire Prism
52331, --Snufflenose Starter Kit
52340,
52344, --Earthen Ring Supplies
52676,
52676, --Cache of the Ley-Guardian
54467, --Tabard Lost & Found
54516,
54516, --Loot-Filled Pumpkin
54535,
54535, --Keg-Shaped Treasure Chest
54536,
54536, --Satchel of Chilled Goods
54537, --Heart-Shaped Box
57540, --Coldridge Mountaineer's Pouch
58856,
60681, --Cannary's Cache
61387,
62062,
62062, --Bulging Sack of Gold
64491, --Royal Reward
64657, --Canopic Jar
65513, --Crate of Tasty Meat
66943,
67248,
67248, --Satchel of Helpful Goods
67250,
67250, --Satchel of Helpful Goods
67414,
67443, --Winter Veil Gift
67495,
67539,
67597, -- Sealed Crate
67597, --Sealed Crate
68133, --Violet Chest
68384, --Moonkin Egg
68598, --Very Fat Sack of Coins
68689, --Imported Supplies
68795, --Stendel's Bane
68813, --Satchel of Freshly-Picked Herbs
69817, --Hive Queen's Honeycomb
69818, --Giant Sack
69822, --Master Chef's Groceries
69823,
69823, --Gub's Catch
69886,
69886, --Bag of Coins
69903,
69903, --Satchel of Exotic Mysteries
69914,
69999, --Moat Monster Feeding Kit
70719, --Water-Filled Gills
70931, --Scrooge's Payoff
70938, --Winter Veil Gift
71631,
71631, --Zen'Vorka's Cache
72201, -- Plump Intestine
73792,
73792, --Stolen Present
77501, --Blue Blizzcon Bag
77952, --Elementium Gem Cluster
77956, --Spectral Mount Crate
78890,
78891,
78897,
78897, --Pouch o' Tokens
78898,
78898, --Sack o' Tokens
78899,
78899, --Pouch o' Tokens
78900,
78900, --Pouch o' Tokens
78901,
78901, --Pouch o' Tokens
78902,
78902, --Pouch o' Tokens
78903,
78903, --Pouch o' Tokens
78904,
78904, --Pouch o' Tokens
78905,
78905, --Sack o' Tokens
78906,
78906, --Sack o' Tokens
78907,
78907, --Sack o' Tokens
78908,
78908, --Sack o' Tokens
78909,
78909, --Sack o' Tokens
78910,
78910, --Sack o' Tokens
78930, -- Sealed Crate
85223, --Enigma Seed Pack
85224, --Basic Seed Pack
85225, --Basic Seed Pack
85226, --Basic Seed Pack
85227, --Special Seed Pack
85271, --Secret Stash
85272, --Tree Seed Pack
85274, --Gro-Pack
85275, --Chee Chee's Goodie Bag
85276, --Celebration Gift
85277, --Nicely Packed Lunch
85497, --Chirping Package
85498, --Songbell Seed Pack
86087, --Test Cache
86428, --Old Man Thistle's Treasure
86595, --Bag of Helpful Things
86623, --Blingtron 4000 Gift Package
87217, --Small Bag of Goods
87218, --Big Bag of Arms
87219, --Big Bag of Herbs
87220, --Big Bag of Mysteries
87221, --Big Bag of Jewels
87222, --Big Bag of Linens
87223, --Big Bag of Skins
87224, --Big Bag of Wonders
87225, --Big Bag of Food
87391, --Plundered Treasure
87533, --Crate of Dwarven Archaeology Fragments
87534, --Crate of Draenei Archaeology Fragments
87535, --Crate of Fossil Archaeology Fragments
87536, --Crate of Night Elf Archaeology Fragments
87537, --Crate of Nerubian Archaeology Fragments
87538, --Crate of Orc Archaeology Fragments
87539, --Crate of Tol'vir Archaeology Fragments
87540, --Crate of Troll Archaeology Fragments
87541, --Crate of Vrykul Archaeology Fragments
87701, --Sack of Raw Tiger Steaks
87702, --Sack of Mushan Ribs
87703, --Sack of Raw Turtle Meat
87704, --Sack of Raw Crab Meat
87705, --Sack of Wildfowl Breasts
87706, --Sack of Green Cabbages
87707, --Sack of Juicycrunch Carrots
87708, --Sack of Mogu Pumpkin
87709, --Sack of Scallions
87710, --Sack of Red Blossom Leeks
87712, --Sack of Witchberries
87713, --Sack of Jade Squash
87714, --Sack of Striped Melons
87715, --Sack of Pink Turnips
87716, --Sack of White Turnips
87721, --Sack of Jade Lungfish
87722, --Sack of Giant Mantis Shrimp
87723, --Sack of Emperor Salmon
87724, --Sack of Redbelly Mandarin
87725, --Sack of Tiger Gourami
87726, --Sack of Jewel Danio
87727, --Sack of Reef Octopus
87728, --Sack of Krasarang Paddlefish
87729, --Sack of Golden Carp
87730, --Sack of Crocolisk Belly
88457, --QA Test 1000g Box
88458, --QA Test 10k G Box
88496, -- Sealed Crate MoP
89125, --Sack of Pet Supplies
89427, --Ancient Mogu Treasure
89428, --Ancient Mogu Treasure
89607, --Crate of Leather
89608, --Crate of Ore
89609, --Crate of Dust
89610, --Pandaria Herbs
89613, --Greater Cache of Treasures
89804, --Cache of Mogu Riches
89807, --Amber Encased Treasure Pouch
89808, --Dividends of the Everlasting Spring
89810, --Bounty of a Sundered Land
89856, --Amber Encased Treasure Pouch
89857, --Dividends of the Everlasting Spring
89858, --Cache of Mogu Riches
89907, --Test Crate
89991, --Pandaria Fireworks
90155, --Golden Chest of the Golden King
90156, --Golden Chest of the Betrayer
90157, --Golden Chest of Windfury
90158, --Golden Chest of the Elemental Triad
90159, --Golden Chest of the Silent Assassin
90160, --Golden Chest of the Light
90161, --Golden Chest of the Holy Warrior
90162, --Golden Chest of the Regal Lord
90163, --Golden Chest of the Howling Beast
90164, --Golden Chest of the Cycle
90165, --Golden Chest of the Lich Lord
90395, -- River's Heart Facets of Research
90395, --Facets of Research
90397, -- Wild Jade Facets of Research
90397, --Facets of Research
90398, -- Sun's Radiance Facets of Research
90398, --Facets of Research
90399, -- Imperial Amethyst Facets of Research
90399, --Facets of Research
90400, -- Vermilion Onyx Facets of Research
90400, --Facets of Research
90401, -- Primordial Ruby Facets of Research
90401, --Facets of Research
90406, -- Secrets of the Stone Facets of Research
90406, --Facets of Research
90537, -- Winner's Reward
90621, --Hero's Purse
90622, -- Hero's Purse
90622, --Hero's Purse
90623, --Hero's Purse
90624, --Hero's Purse
90625, --Treasures of the Vale
90626, --Hero's Purse
90627, --Hero's Purse
90628, --Hero's Purse
90629, --Hero's Purse
90630, --Hero's Purse
90631, --Hero's Purse
90632, --Hero's Purse
90633, --Hero's Purse
90634, --Hero's Purse
90635, --Hero's Purse
90716, --Good Fortune
90735, --Goodies from Nomi
90818, --Misty Satchel of Exotic Mysteries
90839, --Cache of Sha-Touched Gold
90840, --Marauder's Gleaming Sack of Gold
91086, --Darkmoon Pet Supplies
92718, --Brawler's Purse
92788, --Ride Ticket Book
92789, --Ride Ticket Book
92790, --Ride Ticket Book
92791, --Ride Ticket Book
92792, --Ride Ticket Book
92793, --Ride Ticket Book
92794, --Ride Ticket Book
92813, --Greater Cache of Treasures
92960, --Silkwoom Cocoon
93146, --Pandaren Spirit Pet Supplies
93147, --Pandaren Spirit Pet Supplies
93148, --Pandaren Spirit Pet Supplies
93149, --Pandaren Spirit Pet Supplies
93724, --Darkmoon Game Prize
94158, --Big Bag of Zandalari Supplies
94159, --Small Bag of Zandalari Supplies
94207, --Fabled Pandaren Pet Supplies
94219, --Arcane Trove
94220, --Sunreaver Bounty
94553, --Notes on Lightning Steel
94566, --Foruitous Coffer
95343, --Treasures of the Thunder King
95469, --Serpent's Heart
95601, --Shiny Pile of Refuse
95602, --Stormtouched Cache
95617, --Dividends of the Everlasting Spring
95618, --Cache of Mogu Riches
95619, --Amber Encased Treasure Pouch
97153, --Spoils of the Thunder King
97268, --Tome of Valor
97948, --Surplus Supplies
97949, --Surplus Supplies
97950, --Surplus Supplies
97951, --Surplus Supplies
97952, --Surplus Supplies
97953, --Surplus Supplies
97954, --Surplus Supplies
97955, --Surplus Supplies
97956, --Surplus Supplies
97957, --Surplus Supplies
98095, --Brawler's Pet Supplies
98133, -- Greater Cache of Treasures
98134, --Heroic Cache of Treasures
98546, --Bulging Heroic Cache of Treasures
98560, --Arcane Trove (rep purchasable)
103624, --Treasures of the Vale
104035, --Giant Purse of Timeless Coins
104260, --Satchel of Cosmic Mysteries
104261, --Glowing Blue Ash
104271, --Coalesced Turmoil
104272, --Celestial Treasure Box
104273, --Flame-scarred Cache of Offerings
104275, --Twisted Treasures of the Vale
104292, --Partially-digested Meal
104296, --Ordon Ceremonial Robes
105713, --Twisted Treasures of the Vale
105714, --Coalesced Turmoil
107694, --Garrison Blueprint: Lunarfall Inn, Level 2
108738, --Giant Draenor Clam
109062, --Garrison Blueprint: Mage Tower, Level 2
109063, --Garrison Blueprint: Mage Tower, Level 3
109065, --Garrison Blueprint: Lunarfall Inn, Level 3
109254, --Garrison Blueprint: Lumber Mill, Level 2
109255, --Garrison Blueprint: Lumber Mill, Level 3
109256, --Garrison Blueprint: Engineering Works, Level 2
109257, --Garrison Blueprint: Engineering Works, Level 3
109258, --Garrison Blueprint: Engineering Works, Level 1
109558, --A Treatise on the Alchemy of Draenor
109576, --Garrison Blueprint: Lunarfall Excavation, Level 2
109577, --Garrison Blueprint: Herb Garden, Level 2
109578, --Garrison Blueprint: Fishing Shack
109586, --Brittle Cartography Journal
111349, --A Treatise on Mining in Draenor
111350, --A Compendium of the Herbs of Draenor
111351, --A Guide to Skinning in Draenor
111356, --Fishing Guide to Draenor
111364, --First Aid in Draenor
111387, --The Joy of Draenor Cooking
111812, --Garrison Blueprint: Alchemy Lab, Level 1
111813, --Garrison Blueprint: The Forge, Level 1
111814, --Garrison Blueprint: Gem Boutique, Level 1
111815, --Garrison Blueprint: Scribe's Quarters, Level 1
111816, --Garrison Blueprint: Tailoring Emporium, Level 1
111817, --Garrison Blueprint: Enchanter's Study, Level 1
111818, --Garrison Blueprint: The Tannery, Level 1
111921, --Draenor Engineering
111922, --Draenor Enchanting
111923, --Draenor Inscription
111927, --Garrison Blueprint: Fishing Shack, Level 2
111928, --Garrison Blueprint: Fishing Shack, Level 3
111929, --Garrison Blueprint: Alchemy Lab, Level 2
111930, --Garrison Blueprint: Alchemy Lab, Level 3
111956, --Garrison Blueprint: Barracks, Level 1
111957, --Garrison Blueprint: Salvage Yard, Level 1
111966, --Garrison Blueprint: Dwarven Bunker, Level 2
111967, --Garrison Blueprint: Dwarven Bunker, Level 3
111968, --Garrison Blueprint: Barn, Level 2
111969, --Garrison Blueprint: Barn, Level 3
111970, --Garrison Blueprint: Barracks, Level 2
111971, --Garrison Blueprint: Barracks, Level 3
111972, --Garrison Blueprint: Enchanter's Study, Level 2
111973, --Garrison Blueprint: Enchanter's Study, Level 3
111974, --Garrison Blueprint: Gem Boutique, Level 2
111975, --Garrison Blueprint: Gem Boutique, Level 3
111976, --Garrison Blueprint: Salvage Yard, Level 2
111977, --Garrison Blueprint: Salvage Yard, Level 3
111978, --Garrison Blueprint: Scribe's Quarters, Level 2
111979, --Garrison Blueprint: Scribe's Quarters, Level 3
111980, --Garrison Blueprint: Gladiator's Sanctum, Level 2
111981, --Garrison Blueprint: Gladiator's Sanctum, Level 3
111982, --Garrison Blueprint: Storehouse, Level 2
111983, --Garrison Blueprint: Storehouse, Level 3
111984, --Garrison Blueprint: Gnomish Gearworks, Level 2
111985, --Garrison Blueprint: Gnomish Gearworks, Level 3
111986, --Garrison Blueprint: Trading Post, Level 2
111987, --Garrison Blueprint: Trading Post, Level 3
111988, --Garrison Blueprint: The Tannery, Level 2
111989, --Garrison Blueprint: The Tannery, Level 3
111991, --Garrison Blueprint: The Forge, Level 3
111992, --Garrison Blueprint: Tailoring Emporium, Level 2
111993, --Garrison Blueprint: Tailoring Emporium, Level 3
111996, --Garrison Blueprint: Lunarfall Excavation, Level 3
111997, --Garrison Blueprint: Herb Garden, Level 3
111998, --Garrison Blueprint: Menagerie, Level 2
111999, --Garrison Blueprint: Menagerie, Level 3
112002, --Garrison Blueprint: Stables, Level 2
112003, --Garrison Blueprint: Stables, Level 3
112623, --Pack of Fishing Supplies
113138, --Garrison Blueprint: Lunarfall Excavation
113258, --Blingtron 5000 Gift Package
113992, --Scribe's Research Notes
114028, --Small Pouch of Coins
114634, --Icy Satchel of Helpful Goods
114641, --Icy Satchel of Helpful Goods
114662, --Tranquil satchel of helpful goods
114970, --Small Pouch of Coins
115356, --Draenor Blacksmithing
115357, --Draenor Tailoring
115358, --Draenor Leatherworking
115359, --Draenor Jewelcrafting
115981, --Abrogator Stone Cluster
116062, --Greater Darkmoon Pet Supplies
116111, --Small Pouch of Coins
116129, --Dessicated Orc's Coin Pouch
116185, --Garrison Blueprint: War Mill, Level 2
116186, --Garrison Blueprint: War Mill, Level 3
116196, --Garrison Blueprint: Spirit Lodge, Level 2
116197, --Garrison Blueprint: Spirit Lodge, Level 3
116200, --Garrison Blueprint: Goblin Workshop, Level 2
116201, --Garrison Blueprint: Goblin Workshop, Level 3
116247, --Garrison Blueprint: Frostwall Mines
116248, --Garrison Blueprint: Frostwall Mines, Level 2
116249, --Garrison Blueprint: Frostwall Mines, Level 3
116376, --Small Pouch of Coins
116404, -- Pilgrim's Bounty
116431, --Garrison Blueprint: Frostwall Tavern, Level 2
116432, --Garrison Blueprint: Frostwall Tavern, Level 3
116761, --Winter Veil Gift
116762, --Stolen Present
116764, --Small Pouch of Coins
116980, --Invader's Forgotten Treasure
117392, --Loot-filled pumpkin
117394, --Satchel of Chilled Goods
117492, --Relic of Rukhmar
118193, --Mysterious Shining Lockbox
118215, --Book of Garrison Blueprints
118473, --Small Sack of Salvaged Goods
118529, --Cache of Highmaul Treasures
118530, --Cache of Highmaul Treasures
118531, --Cache of Highmaul Treasures
118697, --Big Bag of Pet Supplies
118759, --Alchemy Experiment
118924, --Cache of Arms
118925, --Plundered Booty
118926, --Huge Pile of Skins
118927, --Maximillian's Laundry
118928, --Faintly-Sparkling Cache
118929, --Sack of Mined Ore
118930, --Bag of Everbloom Herbs
118931, --Leonid's Bag of Supplies
119036, --Box of Storied Treasures
119037, --Supply of Storied Rarities
119040, --Cache of Mingled Treasures
119041, --Strongbox of Mysterious Treasures
119042, --Crate of Valuable Treasures
119043, --Trove of Smoldering Treasures
119191, --Jewelcrafting Payment
119195, --Jewelcrafting Payment
119196, --Jewelcrafting Payment
119197, --Jewelcrafting Payment
119198, --Jewelcrafting Payment
119199, --Jewelcrafting Payment
119200, --Jewelcrafting Payment
119201, --Jewelcrafting Payment
120151, --Gleaming Ashmaul Strongbox
120170, -- Partially-Digested Bag
120301, --Armor Enhancement Token
120302, --Weapon Enhancement Token
120319, --Invader's Damaged Cache
120320, --Invader's Abandoned Sack
120322, --Klinking Stacked Card Deck
120323, --Bulging Stacked Card Deck
120324, --Bursting Stacked Card Deck
120325, --Overflowing Stacked Card Deck
122163, --Routed Invader's Crate of Spoils
122195, --Music Roll: Legends of Azeroth
122196, --Music Roll: The Burning Legion
122197, --Music Roll: Wrath of the Lich King
122198, --Music Roll: The Shattering
122199, --Music Roll: Heart of Pandaria
122200, --Music Roll: A Siege of Worlds
122201, --Music Roll: Stormwind
122202, --Music Roll: High Seas
122203, --Music Roll: Ironforge
122204, --Music Roll: Cold Mountain
122205, --Music Roll: Night Song
122206, --Music Roll: Gnomeregan
122207, --Music Roll: Tinkertown
122208, --Music Roll: Exodar
122209, --Music Roll: Curse of the Worgen
122210, --Music Roll: Orgrimmar
122211, --Music Roll: War March
122212, --Music Roll: Undercity
122213, --Music Roll: Thunder Bluff
122214, --Music Roll: Mulgore Plains
122215, --Music Roll: Zul'Gurub Voodoo
122216, --Music Roll: The Zandalari
122217, --Music Roll: Silvermoon
122218, --Music Roll: Rescue the Warchief
122219, --Music Roll: Way of the Monk
122221, --Music Roll: Song of Liu Lang
122222, --Music Roll: Angelic
122223, --Music Roll: Ghost
122224, --Music Roll: Mountains
122226, --Music Roll: Magic
122228, --Music Roll: The Black Temple
122229, --Music Roll: Invincible
122231, --Music Roll: Karazhan Opera House
122232, --Music Roll: The Argent Tournament
122233, --Music Roll: Lament of the Highborne
122234, --Music Roll: Faerie Dragon
122236, --Music Roll: Totems of the Grizzlemaw
122237, --Music Roll: Mountains of Thunder
122238, --Music Roll: Darkmoon Carousel
122239, --Music Roll: Shalandis Isle
122307, --Rush Order: Barn
122484, --Blackrock Foundry Spoils
122485, --Blackrock Foundry Spoils
122486, --Blackrock Foundry Spoils
122487, --Rush Order: Gladiator's Sanctum
122490, --Rush Order: Dwarven Bunker
122491, --Rush Order: War Mill
122496, --Rush Order: Garden Shipment
122497, --Rush Order: Garden Shipment
122500, --Rush Order: Gnomish Gearworks
122501, --Rush Order: Goblin Workshop
122502, --Rush Order: Mine Shipment
122503, --Rush Order: Mine Shipment
122535, --Traveler's Pet Supplies
122576, --Rush Order: Alchemy Lab
122590, --Rush Order: Enchanter's Study
122591, --Rush Order: Engineering Works
122592, --Rush Order: Gem Boutique
122593, --Rush Order: Scribe's Quarters
122594, --Rush Order: Tailoring Emporium
122595, --Rush Order: The Forge
122596, --Rush Order: The Tannery
122599, --Tome of Sorcerous Elements
122613, --Stash of Dusty Music Rolls
122718, --Clinking Present
123857, --Runic Pouch
123858, --Follower Retraining Scroll Case
123975, --Greater Bounty Spoils
124670, --Sealed Darkmoon Crate
126900, --Ship Blueprint: Destroyer
127141, --Bloated Thresher
127148, --Silas' Secret Stash
127267, --Ship Blueprint: Carrier
127268, --Ship Blueprint: Transport
127269, --Ship Blueprint: Battleship
127270, --Ship Blueprint: Submarine
127751, --Fel-Touched Pet Supplies
127777, --Baleful Cloth Bracers
127778, --Baleful Cloth Robe
127779, --Baleful Cloth Treads
127780, --Baleful Cloth Gauntlets
127781, --Baleful Cloth Hood
127782, --Baleful Cloth Leggings
127783, --Baleful Cloth Spaulders
127784, --Baleful Cloth Girdle
127796, --Baleful Leather Spaulders
127797, --Baleful Leather Girdle
127798, --Baleful Ring
127799, --Baleful Pendant
127800, --Baleful Cloak
127810, --Baleful Mail Girdle
127823, --Baleful Plate Girdle
127853, -- Iron Fleet Treasure Chest Normal
127853, --Iron Fleet Treasure Chest
127854, -- Iron Fleet Treasure Chest Heroic
127854, --Iron Fleet Treasure Chest
127855, -- Iron Fleet Treasure Chest Mythic
127855, --Iron Fleet Treasure Chest
127953, --Chest of Hellfire's Conqueror
127954, --Gauntlets of Hellfire's Conqueror
127955, --Leggings of Hellfire's Conqueror
127956, --Helm of Hellfire's Conqueror
127957, --Shoulders of Hellfire's Conqueror
127958, --Gauntlets of Hellfire's Vanquisher
127959, --Helm of Hellfire's Vanquisher
127960, --Leggings of Hellfire's Vanquisher
127961, --Shoulders of Hellfire's Vanquisher
127962, --Chest of Hellfire's Vanquisher
127963, --Chest of Hellfire's Protector
127964, --Gauntlets of Hellfire's Protector
127965, --Leggings of Hellfire's Protector
127966, --Helm of Hellfire's Protector
127967, --Shoulders of Hellfire's Protector
127968, --Badge of Hellfire's Vanquisher
127969, --Badge of Hellfire's Conqueror
127970, --Badge of Hellfire's Protector
128327, --Small Pouch of Coins  Engineering
128373, --Rush Order: Shipyard
128391, -- Iron Fleet Treasure Chest LFR
128492, --Ship Blueprint: Battleship
128652, --Gently Shaken Gift
128653, --Winter Veil Gift
128803, --Savage Satchel of Cooperation
136419, --Excavator's Notebook
137560, --Dreamweaver Provisions
137561, --Highmountain Tribute
137562, --Valarjar Cache
137563, --Farondis Lockbox
137564, --Nightfallen Hoard
137565, --Warden's Field Kit
139048, --Small Legion Chest
139049, --Large Legion Chest
139390, --Artifact Research Notes
139786, --Ancient Mana Crystal
139890, --Ancient Mana Gem
140226, --Mana-Tinged Pack
140239, --Excavated Highborne Artifact
140240, --Enchanted Moonwell Waters
140243, --Azurefall Essence
140997, --Alliance Strongbox
140998, --Horde Strongbox
141350, --Kirin Tor Chest
141992, --Greater Nightfallen Insignia

-- artifact power things (CWCID: dabear76 accumulated this list)
127999,
128000,
128021,
128022,
128026,
130144,
130149,
130152,
130153,
130159,
130160,
130165,
131728,
131751,
131753,
131758,
131763,
131778,
131784,
131785,
131789,
131795,
131802,
131808,
132361,
132897,
132923,
132950,
134118,
134133,
138480,
138487,
138726,
138732,
138781,
138782,
138783,
138784,
138785,
138786,
138812,
138813,
138814,
138816,
138839,
138864,
138865,
138880,
138881,
138885,
138886,
139413,
139506,
139507,
139508,
139509,
139510,
139511,
139512,
139608,
139609,
139610,
139611,
139612,
139613,
139614,
139615,
139616,
139617,
140176,
140237,
140238,
140241,
140244,
140247,
140250,
140251,
140252,
140254,
140255,
140304,
140305,
140306,
140307,
140310,
140322,
140349,
140357,
140358,
140359,
140361,
140364,
140365,
140366,
140367,
140368,
140369,
140370,
140371,
140372,
140373,
140374,
140377,
140379,
140380,
140381,
140382,
140383,
140384,
140385,
140386,
140387,
140388,
140389,
140391,
140392,
140393,
140396,
140409,
140410,
140421,
140422,
140444,
140445,
140459,
140460,
140461,
140462,
140463,
140466,
140467,
140468,
140469,
140470,
140471,
140473,
140474,
140475,
140476,
140477,
140478,
140479,
140480,
140481,
140482,
140484,
140485,
140486,
140487,
140488,
140489,
140490,
140491,
140492,
140494,
140497,
140498,
140503,
140504,
140505,
140507,
140508,
140509,
140510,
140511,
140512,
140513,
140516,
140517,
140518,
140519,
140520,
140521,
140522,
140523,
140524,
140525,
140528,
140529,
140530,
140531,
140532,
140685,
140847,
141023,
141024,
141310,
141313,
141314,
141383,
141384,
141385,
141386,
141387,
141388,
141389,
141390,
141391,
141392,
141393,
141394,
141395,
141396,
141397,
141398,
141399,
141400,
141401,
141402,
141403,
141404,
141405,
141638,
141639,
141667,
141668,
141669,
141670,
141671,
141672,
141673,
141674,
141675,
141676,
141677,
141678,
141679,
141680,
141681,
141682,
141683,
141684,
141685,
141689,
141690,
141699,
141701,
141702,
141703,
141704,
141705,
141706,
141707,
141708,
141709,
141710,
141711,
141852,
141853,
141854,
141855,
141856,
141857,
141858,
141859,
141863,
141872,
141876,
141877,
141883,
141886,
141887,
141888,
141889,
141890,
141891,
141892,
141896,
141921,
141922,
141923,
141924,
141925,
141926,
141927,
141928,
141929,
141930,
141931,
141932,
141933,
141934,
141935,
141936,
141937,
141940,
141941,
141942,
141943,
141944,
141945,
141946,
141947,
141948,
141949,
141950,
141951,
141952,
141953,
141954,
141955,
141956,
142001,
142002,
142003,
142004,
142005,
142006,
142007,
142054,

-- PvP strongboxes
111598, --Gold Strongbox
111599, --Silver Strongbox
111600, --Bronze Strongbox
116762, --Stolen Present
118065, --Gleaming Ashmaul Strongbox
118066, --Ashmaul Strongbox
118697, --Big Bag of Pet Supplies
119330, --Steel Strongbox
120146, --Smuggled Sack of Gold
120147, --Bloody Gold Purse
120184, --Ashmaul Strongbox
120321, --Mystery Bag
120353, --Steel Strongbox
120354, --Gold Strongbox
120355, --Silver Strongbox
120356, --Bronze Strongbox
126909, --Gold Strongbox
126911, --Bronze Strongbox
126922, --Ashmaul Strongbox
126924, --Champion's Strongbox
128215, --Dented Ashmaul Strongbox

}

local openableInStacks = {
	{ smallDraenorFish,  20 },
	{ mediumDraenorFish, 10 },
	{ largeDraenorFish,   5 },
	{ smallReagentBits,  10 },
	{ smallOreBits,      10 },
	{ smallHerbBits,     10 },
	{ smallLeatherBits,   3 },
	{ mediumLeatherBits,  5 },
	{ largeLeatherBits,  10 },
}

-- This will be filled in once we have I18N loaded
ClamStacker.OrientationChoices = {}

local options = {
    type = 'group',
    name = "ClamStacker",
    handler = ClamStacker,
    desc = "Manage clams and other things that can be opened",
    args = {
    	head0 = {
    		name = "",
    		desc = "heaing 0",
    		type = "header",
    		order = 1
    	},
    	frame_locked = {
    		name = "Locked?",
    		desc = "Is frame locked from moving?",
    		type = "toggle",
    		set = function ( info, val ) ClamStacker.db.profile.frame_locked = val; ClamStacker:BAG_UPDATE_DELAYED() end,
    		get = function (info) return ClamStacker.db.profile.frame_locked end,
    		order = 2.
    	},
    	head1 = {
    		name = "",
    		desc = "Heading 1",
    		type = "header",
    		order = 10,
    	},
        orientation = {
            name = "Orientation",
            desc = "Orientation of the popup window",
            type = "select",
            values = ClamStacker.OrientationChoices,
            set = function(info, val) ClamStacker.db.profile.orientation = val; ClamStacker:BAG_UPDATE_DELAYED() end,
            get = function(info) return ClamStacker.db.profile.orientation end,
            order = 20,
        },
    	head2 = {
    		name = "",
    		desc = "Heading 2",
    		type = "header",
    		order = 200,
    	},
        lockboxes = {
        	name = "Lockboxes",
        	desc = "Show lockboxes in ClamStacker window?",
        	type = "toggle",
        	set = function(info, val) ClamStacker.db.profile.lockboxes = val; ClamStacker:BAG_UPDATE_DELAYED() end,
        	get = function(info) return ClamStacker.db.profile.lockboxes end,
        	order = 210,
    	},
    	head3 = {
    		name = "",
    		desc = "Heading 3",
    		type = "header",
    		order = 300,
    	},
    	salvage = {
    		name = "Salvage",
    		desc = "Show salvage containers in ClamStacker window?",
    		type = "toggle",
    		set = function(info, val) ClamStacker.db.profile.salvage = val; ClamStacker:BAG_UPDATE_DELAYED() end,
    		get = function(info) return ClamStacker.db.profile.salvage end,
    		order = 310,
    	},
    	head4 = {
    		name = "",
    		desc = "Heading 4",
    		type = "header",
    		order = 400,
    	},
    	verbose = {
    		name = "Verbose debug output",
    		desc = "Print deebug output to the chat window",
    		type = "toggle",
    		set = function(info, val) ClamStacker.db.profile.verbose = val; ClamStacker:BAG_UPDATE_DELAYED() end,
    		get = function(info) return ClamStacker.db.profile.verbose end,
    		order = 410,
    	},
    },
}

local defaults = {
    profile = {
        orientation = 1,
        lockboxes = true,
        verbose = false,
        frame_locked = false,
    }
}

local profileOptions = {
    name = "Profiles",
    type = "group",
    childGroups = "tab",
    args = {},
}

ClamStacker.itemButtons = {}

local function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    local sb = {}
    for key, value in pairs (tt) do
      table.insert(sb, string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        table.insert(sb, "{\n");
        table.insert(sb, table_print (value, indent + 2, done))
        table.insert(sb, string.rep (" ", indent)) -- indent it
        table.insert(sb, "}\n");
      elseif "number" == type(key) then
        table.insert(sb, string.format("\"%s\"\n", tostring(value)))
      else
        table.insert(sb, string.format(
            "%s = \"%s\"\n", tostring (key), tostring(value)))
       end
    end
    return table.concat(sb)
  else
    return tt .. "\n"
  end
end

local function to_string( tbl )
    if  "nil"       == type( tbl ) then
        return tostring(nil)
    elseif  "table" == type( tbl ) then
        return table_print(tbl)
    elseif  "string" == type( tbl ) then
        return tbl
    else
        return tostring(tbl)
    end
end

function ClamStacker:Debug(...)
    if debugFrame then
        debugFrame:AddMessage(string.join(", ", ...))
    end
    if ClamStacker.db.profile.verbose then
    	self:Print(string.join(", ", ...))
    end
end

function ClamStacker:OnInitialize()
    options.args.orientation.name = L["OPTIONS_ORIENTATION_NAME"]
    options.args.orientation.desc = L["OPTIONS_ORIENTATION_DESC"]

    options.args.lockboxes.name = L["OPTIONS_LOCKBOXES_NAME"]
    options.args.lockboxes.desc = L["OPTIONS_LOCKBOXES_DESC"]

    options.args.salvage.name = L["OPTIONS_SALVAGE_NAME"]
    options.args.salvage.desc = L["OPTIONS_SALVAGE_DESC"]

    ClamStacker.orientation = L["ORIENTATION_HORIZONTAL"]
    defaults.profile.orientation = L["ORIENTATION_HORIZONTAL"]

    ClamStacker.db = LibStub("AceDB-3.0"):New("ClamStackerDB", defaults, "Default")
    ClamStacker.db.RegisterCallback(ClamStacker, "OnProfileChanged", "BAG_UPDATE_DELAYED")

    ClamStacker.cache = {}

    local ACFG = LibStub("AceConfig-3.0")
    ACFG:RegisterOptionsTable("ClamStacker", options)
    ACFG:RegisterOptionsTable("ClamStacker Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(ClamStacker.db))

    local ACD = LibStub("AceConfigDialog-3.0")
    ClamStacker.optionsFrame = ACD:AddToBlizOptions("ClamStacker", "ClamStacker")
    ACD:AddToBlizOptions("ClamStacker Profiles", "Profiles", "ClamStacker")

    self:RegisterChatCommand("clamstacker", "ChatCommand")

    -- preload map to avoid iterating "openableInStacks" all the time
    ClamStacker.cache.openableInStacks = {}
    for i,v in ipairs(openableInStacks) do
    	for ik,iv in pairs(v[1]) do
    		self:Debug("adding item " .. ik .. " with count " .. v[2])
    		ClamStacker.cache.openableInStacks[ik] = v[2]
    	end
    end

    -- Configuration I18N
    tinsert(ClamStacker.OrientationChoices, L["ORIENTATION_VERTICAL"])
    tinsert(ClamStacker.OrientationChoices, L["ORIENTATION_HORIZONTAL"])
end

function ClamStacker:ChatCommand(...)
    local args = { n = select("#", ...), ... }
    if args.n ~= 1 and args[1] ~= "" then
	local _, _, id = string.find(args[1], "item:(%d+):")
	self:Print(string.format("item ID = %d", id))
	return
    end

    InterfaceOptionsFrame_OpenToCategory(ClamStacker.optionsFrame)
end

function ClamStacker:OnEnable()
    self:Print("v"..version.." loaded")
    self:RegisterEvent("BAG_UPDATE_DELAYED");
    self:RegisterEvent("ZONE_CHANGED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")

    self:BAG_UPDATE_DELAYED()
end

function ClamStacker:PLAYER_REGEN_DISABLED(self)
    if ClamStacker.popupFrame and ClamStacker.popupFrame:IsShown() then
        ClamStacker.popupFrame:Hide()
        ClamStacker.popupFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    end
end

local function PLAYER_REGEN_ENABLED(self)
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    ClamStacker:PopulatePopupFrame(self.dataModel[1], self.dataModel[2])
    self:Show()
end

function ClamStacker:inGarrison()
    local mapID = GetCurrentMapAreaID()
    local inGarrison = false
    if mapID == 971 or mapID == 976 then
        inGarrison = true
    end
    self:Debug("inGarrison = " .. (inGarrison and "true" or "nil"))
    return inGarrison
end

function ClamStacker:ZONE_CHANGED()
	self:Debug("ZONE_CHANGED called")
    local inGarrison = self:inGarrison()
    if (inGarrison) then
		self:BAG_UPDATE_DELAYED()
	end
end

function ClamStacker:BAG_UPDATE_DELAYED()
    self:Debug("BAG_UPDATE_DELAYED called")

    local inGarrison = self:inGarrison()

    -- See if we have any clams.
    local itemlist = {}
    local numItems = 0
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local itemLink = GetContainerItemLink(bag, slot)
            if itemLink then
                local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bag, slot)
                local itemName, _, itemRarity = GetItemInfo(itemLink)
                if itemName then
                    local itemString = select(3, string.find(itemLink, "^|c%x+|H(.+)|h%[.+%]"))
                    local itemId = select(2, strsplit(":", itemString))
                    if clamItemIds[itemId]
                    		or (ClamStacker.db.profile.lockboxes and lockboxItemIds[itemId])
                    		or (inGarrison and ClamStacker.db.profile.salvage and salvagedGoods[itemId])
                    		or (ClamStacker.cache.openableInStacks[itemId] ~= nil and IsUsableItem(itemId))
                    		or (armorTokens[itemId] and select(5,GetItemInfo(itemId)) <= UnitLevel('player'))
                    		then
                        self:Debug(itemId.." is a clam")
                        if not itemlist[itemId] then
                            self:Debug("adding entry for "..itemId)
                            numItems = numItems + 1
                            itemlist[itemId] = {
                                name = itemName,
                                texture = texture,
                                itemLink = itemLink,
                                bag = bag,
                                slot = slot,
                                itemId = itemId,
                                itemCount = 0,
                            }
                        end
                        itemlist[itemId].itemCount = itemlist[itemId].itemCount + tonumber(itemCount)
                        self:Debug(itemlist[itemId].itemCount.." items in the stack")
                        haveClams = true
                    end
                end
            end
        end
    end

    if ClamStacker.popupFrame and ClamStacker.popupFrame:IsShown() then
    	ClamStacker.popupFrame:Hide()
    end

    -- No clams? We're all done
    if numItems == 0 then
        return
    end

    -- Okay ... so we have some clams. Populate our window with them
    -- and show it
    table.sort(itemlist, function(a,b) return a.itemId < b.itemId end)

    self:CreatePopupFrame()
    ClamStacker.popupFrame.dataModel = { numItems, itemlist }

    if InCombatLockdown() then
        ClamStacker.popupFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    else
        PLAYER_REGEN_ENABLED(ClamStacker.popupFrame)
    end
end

function ClamStacker:StartMoving()
	if ClamStacker.db.profile.frame_locked then
		return
	end

	ClamStacker.popupFrame:StartMoving()
end

function ClamStacker:StopMoving()
	if ClamStacker.db.profile.frame_locked then
		return
	end

	local f = ClamStacker.popupFrame
    f:StopMovingOrSizing()
    self:Debug("#points="..to_string(f:GetNumPoints()))
    local point,relativeTo,relativePoint,xOfs,yOfs = f:GetPoint(1)
    self:Debug("point="..to_string(point))
    self:Debug("relativeTo"..to_string(relativeTo))
    self:Debug("relativePoint="..to_string(relativePoint))
    self:Debug("xOfs="..xOfs)
    self:Debug("yOfs="..yOfs)
    ClamStacker.db.profile.point = point
    ClamStacker.db.profile.relativeTo = relativeTo
    ClamStacker.db.profile.relativePoint = relativePoint
    ClamStacker.db.profile.xOfs = xOfs
    ClamStacker.db.profile.yOfs = yOfs
end


function ClamStacker:CreatePopupFrame()
	if ClamStacker.popupFrame and ClamStacker.db.profile.point then
		local f = ClamStacker.popupFrame
	    f:SetPoint(ClamStacker.db.profile.point,
	        UIParent,
	        ClamStacker.db.profile.relativePoint,
	        ClamStacker.db.profile.xOfs,
	        ClamStacker.db.profile.yOfs)
	    self:Debug("restoring frmae to "
	    	..ClamStacker.db.profile.relativePoint
	    	..", x="..ClamStacker.db.profile.xOfs
	    	..", y="..ClamStacker.db.profile.yOfs)
	end
    if not ClamStacker.popupFrame then
        ClamStacker.popupFrame = CreateFrame("Frame", "ClamStackerPopupFrame", UIParent)
        local f = ClamStacker.popupFrame
        f:RegisterForDrag("LeftButton")
        f:ClearAllPoints()
        if not ClamStacker.db.profile.point then
            f:SetPoint("TOPLEFT", 0, 0)
            self:Debug("putting frame in default position")
        else
            f:SetPoint(ClamStacker.db.profile.point,
                UIParent,
                ClamStacker.db.profile.relativePoint,
                ClamStacker.db.profile.xOfs,
                ClamStacker.db.profile.yOfs)
        end
        self:Debug("ClamStackerPopupFrame created")
        f:SetFrameStrata("HIGH")
        f:SetClampedToScreen(true)
        f:EnableMouse(true)
        f:SetMovable(true)
        f:SetScript("OnDragStart", function() ClamStacker:StartMoving() end)
        f:SetScript("OnDragStop", function() ClamStacker:StopMoving() end)
        f:SetScript("OnEvent", PLAYER_REGEN_ENABLED)

        f:SetBackdrop{
          bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
          edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
          edgeSize = 16,
          tile = true, tileSize = 16,
          insets = {left = 4, right = 4, top = 4, bottom = 4}
        }
    end
end

function ClamStacker:PopulatePopupFrame(numItems, itemlist)
    local f = ClamStacker.popupFrame
    local buttonSize = 48

    local deltaX, deltaY
    self:Debug("orientation="..ClamStacker.db.profile.orientation)
    if ClamStacker.db.profile.orientation == 1 then
        self:Debug("setting width,height="..buttonSize..","..buttonSize*numItems)
        f:SetWidth(8 + buttonSize)
        f:SetHeight(16 + buttonSize * numItems)
        deltaX = 0
        deltaY = 1
    else
        self:Debug("setting width,height="..buttonSize*numItems..","..buttonSize)
        f:SetWidth(8 + buttonSize * numItems)
        f:SetHeight(16 + buttonSize)
        deltaX = 1
        deltaY = 0
    end

    self:Debug("numItems="..numItems..", #ClamStacker.itemButtons="..#ClamStacker.itemButtons)

    -- Hide the frames we won't be using any longer
    for i = numItems, #ClamStacker.itemButtons do
        self:Debug("hiding button #"..i)
        local w = ClamStacker.itemButtons[i]
        w.cooldown:UnregisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
        w:Hide()
    end

    local i = 1
    for k,v in pairs(itemlist) do
        self:Debug("adding item:"..k..", name="..v.name.." to frame")

        local button = ClamStacker.itemButtons[i]
        if not button then
            self:Debug("creating button #"..i)
            button = CreateFrame("Button", "ClamStackerItemButton_"..i, ClamStacker.popupFrame, "SecureActionButtonTemplate,ActionButtonTemplate")
            button:SetMovable(true)
            button.cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
            button.texture = button:CreateTexture(nil, "BACKGROUND")
            button:RegisterForClicks("AnyUp")


            ClamStacker.itemButtons[i] = button
        end

        button:SetID(v.itemId)
        button:SetAttribute("type1", "item")
        button:SetAttribute("item1", "item:"..v.itemId)
        button:SetAttribute("type2", "item")
        button:SetAttribute("item2", "item:"..v.itemId)
        button:SetWidth(buttonSize)
        button:SetHeight(buttonSize)
        button:SetPoint("TOPLEFT", ClamStacker.popupFrame, 4+(i-1)*buttonSize*deltaX, -12-(i-1)*buttonSize*deltaY)

        button:SetNormalFontObject("GameFontHighlightLarge")
        button:SetText(tostring(v.itemCount))

        button.cooldown:SetID(v.itemId)
        button.cooldown:SetAllPoints()
        button.cooldown:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")

        button.texture:SetAllPoints()
        button.texture:SetTexture(v.texture)

        button:SetScript("OnEnter", function(widget)
            GameTooltip:SetOwner(widget, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink(v.itemLink)
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave", function(widget) GameTooltip:Hide() end)
        button.cooldown:SetScript("OnEvent", function(widget)
            self:Debug("cooldown OnEvent handler fired for item:"..widget:GetID())
            local start, duration, enabled = GetItemCooldown(widget:GetID())
            if enabled then
                widget:Show()
                widget:SetCooldown(start, duration)
            else
                widget:Hide()
            end
        end)

        button:Show()

        self:Debug("button:IsShown()="..tostring(button:IsShown()))
        self:Debug("button:IsVisible()="..tostring(button:IsVisible()))

        i = i+1
    end

end
