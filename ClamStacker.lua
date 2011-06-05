ClamStacker = LibStub("AceAddon-3.0"):NewAddon("ClamStacker", "AceConsole-3.0", "AceEvent-3.0", "AceBucket-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ClamStacker", false)
local version = "1.2.14"

local debugFrame = tekDebug and tekDebug:GetFrame("ClamStacker")

local function Set(list)
    local set = {}
    for _, l in ipairs(list) do set[tostring(l)] = true end
    return set
end

local clamItemIds = Set {
    5523,
    5524,
    7973,
    8484,
    9276,
    15699,
    15874,
    20393,
    20767,
    21113,
    21150,
    21191,
    21270,
    21271,
    21310,
    21327,
    21363,
    21746,
    24402,
    24476,
    25423,
    27481,
    27511,
    27513,
    33844,
    33857,
    34077,
    34426,
    34863,
    35313,
    35348,
    35792,
    36781,
    37586,
    39883,
    41989,
    42104,
    42105,
    42106,
    42107,
    42108,
    43504,
    44113,
    44475,
    44700,
    44751,
    45072,
    45328,
    45724,
    45902,
    45909,
    46007,
    46740,
    51999,
    52000,
    52001,
    52002,
    52003,
    52004,
    52005,
    52006,
    52340,
    52676,
    54516,
    54535,
    54536,
    62062,
    67414,
    67443,
    67495,
    69903,
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

function ClamStacker:ChatCommand(input)
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
