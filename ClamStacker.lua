ClamStacker = LibStub("AceAddon-3.0"):NewAddon("ClamStacker", "AceConsole-3.0", "AceEvent-3.0", "AceBucket-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ClamStacker", false)
local version = "1.4.12"

local debugFrame = tekDebug and tekDebug:GetFrame("ClamStacker")

local function Set(list)
    local set = {}
    for _, l in ipairs(list) do set[tostring(l)] = true end
    return set
end

local clamItemIds = Set {

4632, --Ornate Bronze Lockbox
4633, --Heavy Bronze Lockbox
4634, --Iron Lockbox
4636, --Strong Iron Lockbox
4637, --Steel Lockbox
4638, --Reinforced Steel Lockbox
5523,
5524,
5738, --Covert Ops Pack
5758, --Mithril Lockbox
5759, --Thorium Lockbox
5760, --Eternium Lockbox
6307, --Message in a Bottle
6351, --Dented Crate
6352, --Waterlogged Crate
6353, --Small Chest
6354, --Small Locked Chest
6355, --Sturdy Locked Chest
6356, --Battered Chest
6357, --Sealed Crate
6643, --Bloated Smallfish
6645,
6645, --Bloated Mud Snapper
6647, --Bloated Catfish
6715, --Ruined Jumper Cables
6827, --Box of Supplies
7190, --Rocket Boots Malfunction
7209, --Tazan's Satchel
7870, --Thaumaturgy Vessel Lockbox
7973,
8049, --Gnarlpine Necklace
8366, --Bloated Trout
8484,
8484, --Gadgetzan Water Co. Care Package
8647, --Egg Crate
9265, --Cuergo's Hidden Treasure
9276,
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
13875, --Ironbound Locked Chest
13881, --Bloated Redgill
13891, --Bloated Salmon
13918, --Reinforced Locked Chest
15102, --Un'Goro Tested Sample
15103, --Corrupt Tested Sample
15699,
15699, --Small Brown-Wrapped Package
15874,
15876, --Nathanos' Chest
16882, --Battered Junkbox
16883, --Worn Junkbox
16884, --Sturdy Junkbox
16885, --Heavy Junkbox
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
29569, --Strong Junkbox
30260, --Voren'thal's Package
30320, --Bundle of Nether Spikes
30650, --Dertrok's Wand Case
31408, --Offering of the Sha'tar
31522, --Primal Mooncloth Supplies
31952, --Khorium Lockbox
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
34426,
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
43504,
43504, --Winter Veil Gift
43556, --Patroller's Pack
43575, --Reinforced Junkbox
43622, --Froststeel Lockbox
43624, --Titanium Lockbox
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
45986, --Tiny Titanium Lockbox
46007,
46110, --Alchemist's Cache
46740,
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
63349, --Flame-Scarred Junkbox
64491, --Royal Reward
64657, --Canopic Jar
65513, --Crate of Tasty Meat
66943,
67248,
67248, --Satchel of Helpful Goods
67250,
67250, --Satchel of Helpful Goods
67414,
67443,
67443, --Winter Veil Gift
67495,
67539,
67597, -- Sealed Crate
67597, --Sealed Crate
68133, --Violet Chest
68384, --Moonkin Egg
68598, --Very Fat Sack of Coins
68689, --Imported Supplies
68729, --Elementium Lockbox
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
70938,
70938, --Winter Veil Gift
71631,
71631, --Zen'Vorka's Cache
72201, -- Plump Intestine
73792,
73792, --Stolen Present
77501, --Blue Blizzcon Bag
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
88165, --Vine-Cracked Junkbox
88457, --QA Test 1000g Box
88458, --QA Test 10k G Box
88496, -- Sealed Crate MoP
88567, --Ghost Iron Lockbox
89125, --Sack of Pet Supplies
89427, --Ancient Mogu Treasure
89428, --Ancient Mogu Treasure
89607, --Crate of Leather
89608, --Crate of Ore
89609, --Crate of Dust
89613, --Greater Cache of Treasures
89610, --Pandaria Herbs
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
92813, --Greater Cache of Treasures
93146, --Pandaren Spirit Pet Supplies
93147, --Pandaren Spirit Pet Supplies
93148, --Pandaren Spirit Pet Supplies
93149, --Pandaren Spirit Pet Supplies
92960, --Silkwoom Cocoon
92718, --Brawler's Purse
92793, --Ride Ticket Book
93724, --Darkmoon Game Prize
94158, --Big Bag of Zandalari Supplies
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
103624, --Treasures of the Vale
104035, --Giant Purse of Timeless Coins
104260, --Satchel of Cosmic Mysteries
104272, --Celestial Treasure Box
104273, --Flame-scarred Cache of Offerings
104275, --Twisted Treasures of the Vale
104292, --Partially-digested Meal
105713, --Twisted Treasures of the Vale
}

-- This will be filled in once we have I18N loaded
ClamStacker.OrientationChoices = {}

local options = {
    type = 'group',
    name = "ClamStacker",
    handler = ClamStacker,
    desc = "Manage clams and other things that can be opened",
    args = {
        orientation = {
            name = "Orientation",
            desc = "Orientation of the popup window",
            type = "select",
            values = ClamStacker.OrientationChoices,
            set = function(info, val) ClamStacker.db.profile.orientation = val; ClamStacker:BAG_UPDATE() end,
            get = function(info) return ClamStacker.db.profile.orientation end
        },
    },
}

local defaults = {
    profile = {
        orientation = 1,
    }
}

local profileOptions = {
    name = "Profiles",
    type = "group",
    childGroups = "tab",
    args = {},
}

ClamStacker.itemButtons = {}

function ClamStacker:Debug(...)
    if debugFrame then
        debugFrame:AddMessage(string.join(", ", ...))
    end
end

function ClamStacker:OnInitialize()
    options.args.orientation.name = L["OPTIONS_ORIENTATION_NAME"]
    options.args.orientation.desc = L["OPTIONS_ORIENTATION_DESC"]

    ClamStacker.orientation = L["ORIENTATION_HORIZONTAL"]
    defaults.profile.orientation = L["ORIENTATION_HORIZONTAL"]

    ClamStacker.db = LibStub("AceDB-3.0"):New("ClamStackerDB", defaults, "Default")

    LibStub("AceConfig-3.0"):RegisterOptionsTable("ClamStacker", options)

    ClamStacker.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ClamStacker", "ClamStacker")

    self:RegisterChatCommand("clamstacker", "ChatCommand")



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
    self:RegisterBucketEvent("BAG_UPDATE", 0.5, "BAG_UPDATE");
end

local function PLAYER_REGEN_ENABLED(self)
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    ClamStacker:PopulatePopupFrame(self.dataModel[1], self.dataModel[2])
    self:Show()
end

function ClamStacker:BAG_UPDATE()
    self:Debug("BAG_UPDATE called")

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
                    if clamItemIds[itemId] then
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

    if ClamStacker.popupFrame then
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

function ClamStacker:CreatePopupFrame()
    if not ClamStacker.popupFrame then
        ClamStacker.popupFrame = CreateFrame("Frame", "ClamStackerPopupFrame", UIParent)
        local f = ClamStacker.popupFrame
        f:ClearAllPoints()
        if not ClamStacker.db.char.point then
            f:SetPoint("CENTER", 0, 0)
        else
            f:SetPoint(ClamStacker.db.char.point,
                UIParent,
                ClamStacker.db.char.relativePoint,
                ClamStacker.db.char.xOfs,
                ClamStacker.db.char.yOfs)
        end
        self:Debug("ClamStackerPopupFrame created")
        f:SetFrameStrata("HIGH")
        f:SetClampedToScreen(true)
        f:EnableMouse(true)
        f:SetMovable(true)
        f:SetScript("OnMouseDown", function() f:StartMoving() end)
        f:SetScript("OnMouseUp", function()
            f:StopMovingOrSizing()
            local point,relativeTo,relativePoint,xOfs,yOfs = f:GetPoint()
            self:Debug("point="..point)
            self:Debug("relativePoint="..relativePoint)
            self:Debug("xOfs="..xOfs)
            self:Debug("yOfs="..yOfs)
            ClamStacker.db.char.point = point
            ClamStacker.db.char.relativeTo = relativeTo
            ClamStacker.db.char.relativePoint = relativePoint
            ClamStacker.db.char.xOfs = xOfs
            ClamStacker.db.char.yOfs = yOfs
        end)
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
            button = CreateFrame("Button", "ClamStackerItemButton_"..i, ClamStacker.popupFrame, "SecureActionButtonTemplate")
            button:SetMovable(true)
            button.cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
            button.texture = button:CreateTexture(nil, "BACKGROUND")


            ClamStacker.itemButtons[i] = button
        end

        button:SetID(v.itemId)
        button:SetAttribute("type1", "item")
        button:SetAttribute("item1", "item:"..v.itemId)
        button:SetWidth(buttonSize)
        button:SetHeight(buttonSize)
        button:SetPoint("TOPLEFT", ClamStacker.popupFrame, 4+(i-1)*buttonSize*deltaX, -12-(i-1)*buttonSize*deltaY)

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

        self:Debug("button:IsShown()="..(button:IsShown() or "nil"))
        self:Debug("button:IsVisible()="..(button:IsVisible() or "nil"))

        i = i+1
    end

end
