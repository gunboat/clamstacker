ClamStacker = LibStub("AceAddon-3.0"):NewAddon("ClamStacker", "AceConsole-3.0", "AceEvent-3.0", "AceBucket-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ClamStacker", false)
local version = "1.0.8"

local debugFrame = tekDebug and tekDebug:GetFrame("ClamStacker")

local clamItemIds = {
    ["7973"] = true,
    ["44700"] = true,
    ["36781"] = true,
    ["45909"] = true,
    ["24476"] = true,
    ["5523"] = true,
    ["15874"] = true,
    ["5524"] = true,

    -- Shattrath daily quest rewards
    ["34863"] = true,
    ["35348"] = true,
    ["33844"] = true,
    ["33857"] = true,

    -- Dalaran daily quest rewards
    ["46007"] = true,
    ["44113"] = true,

    -- Crates and other things that can be caught
    ["27513"] = true,
    ["44475"] = true,
    ["21150"] = true,

    -- Noblegarden eggs
    ["45072"] = true,

}

local options = {
    type = 'group',
    args = {
        enable = {
            name = "Enable",
            desc = "Enables / disables clam stacking",
            type = "toggle",
            set = function(info, val) ClamStacker.enabled = val end,
            get = function(info) return ClamStacker.enabled end
        },
        orientation = {
            name = "Orientation",
            desc = "Orientation of the popup window",
            type = "select",
            values = ClamStacker.OrientationChoices,
            set = function(info, val) ClamStacker.orientation = val end,
            get = function(info) return ClamStacker.orientation end
        },
    },
}

ClamStacker.itemButtons = {}

function ClamStacker:Debug(...)
    if debugFrame then
        debugFrame:AddMessage(string.join(", ", ...))
    end
end

function ClamStacker:OnInitialize()
    options.args.enable.name = L["OPTIONS_ENABLE_NAME"]
    options.args.enable.desc = L["OPTIONS_ENABLE_DESC"]
    options.args.orientation.name = L["OPTIONS_ORIENTATION_NAME"]
    options.args.orientation.desc = L["OPTIONS_ORIENTATION_DESC"]
    LibStub("AceConfig-3.0"):RegisterOptionsTable("ClamStacker", options)

    ClamStacker.orientation = L["ORIENTATION_HORIZONTAL"]

    ClamStacker.db = LibStub("AceDB-3.0"):New("ClamStackerDB")

    LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("ClamStacker", {
        launcher = true,
        icon = "Interface\\Icons\\INV_Misc_Bag_08",
        text = "ClamStacker",
        OnTooltipShow = function(tooltip)
            tooltip:AddLine("ClamStacker |cff00ff00("..version..")|r");
        end
    })

    -- Configuration I18N
    ClamStacker.OrientationChoices = {}
    tinsert(ClamStacker.OrientationChoices, L["ORIENTATION_VERTICAL"])
    tinsert(ClamStacker.OrientationChoices, L["ORIENTATION_HORIZONTAL"])
end

function ClamStacker:OnEnable()
    self:Print("v"..version.." loaded")
    self:RegisterBucketEvent("BAG_UPDATE", 0.5, "BAG_UPDATE");
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
    self:CreatePopupFrame(numItems, itemlist)
    ClamStacker.popupFrame:Show()
end

function ClamStacker:CreatePopupFrame(numItems, itemlist)
    local buttonSize = 48

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

        f:SetBackdrop{
          bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
          edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
          edgeSize = 16,
          tile = true, tileSize = 16,
          insets = {left = 4, right = 4, top = 4, bottom = 4}
        }
    end
    local f = ClamStacker.popupFrame

    local deltaX, deltaY
    self:Debug("orientation="..ClamStacker.orientation)
    if ClamStacker.orientation == L["ORIENTATION_HORIZONTAL"] then
        self:Debug("setting width,height="..buttonSize*numItems..","..buttonSize)
        f:SetWidth(8 + buttonSize * numItems)
        f:SetHeight(16 + buttonSize)
        deltaX = 1
        deltaY = 0
    else
        self:Debug("setting width,height="..buttonSize..","..buttonSize*numItems)
        f:SetWidth(8 + buttonSize)
        f:SetHeight(16 + buttonSize * numItems)
        deltaX = 0
        deltaY = 1
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

            button:SetPoint("TOPLEFT", ClamStacker.popupFrame, 4+(i-1)*buttonSize*deltaX, -12-(i-1)*buttonSize*deltaY)

            ClamStacker.itemButtons[i] = button
        end
        i = i+1

        button:SetID(v.itemId)
        button:SetAttribute("type1", "item")
        button:SetAttribute("item1", "item:"..v.itemId)
        button:SetWidth(buttonSize)
        button:SetHeight(buttonSize)

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
    end

end

