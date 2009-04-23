ClamStacker = LibStub("AceAddon-3.0"):NewAddon("ClamStacker", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ClamStacker", false)
local version = "1.0.0"

local debugFrame = tekDebug and tekDebug:GetFrame("ClamStacker")
if tekDebug then
    ClamStacker:EnableDebug(10, debugFrame)
end

local clamItemIds = {
    ["7973"] = true,
    ["44700"] = true,
    ["36781"] = true,
    ["45909"] = true,
    ["24476"] = true,
    ["5523"] = true,
    ["15874"] = true,
    ["5524"] = true,
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
            values = ClamStacker:OrientationChoices,
            set = function(info, val) ClamStacker.orientation = val end,
            get = function(info) return ClamStacker.orientation end
        },
    },
}

function ClamStacker:Debug(...)
    if debugFrame then
        debugFrame:AddMessage(string.join(", ", ...))
    end
end

function ClamStacker:OnInitialize(self)
    options.args.enable.name = L["OPTIONS_ENABLE_NAME"]
    options.args.enable.desc = L["OPTIONS_ENABLE_DESC"]
    options.args.orientation.name = L["OPTIONS_ORIENTATION_NAME"]
    options.args.orientation.desc = L["OPTIONS_ORIENTATION_DESC"]
    LibStub("AceConfig-3.0"):RegisterOptionsTable("ClamStacker", options)

    self:RegisterBucketEvent("BAG_UPDATE", 0.5, "BAG_UPDATE");

    LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("ClamStacker", {
        launcher = true,
        icon = "Interface\\Icons\\INV_Misc_Bag_08",
        text = "ClamStacker",
        OnTooltipShow = function(tooltip)
            tooltip:AddLine("ClamStacker |cff00ff00("..version..")|r");
        end
    })

    -- Configuration I18N
    ClamStacker:OrientationChoices = {}
    tinsert(ClamStacker:OrientationChoices, L["ORIENTATION_VERTICAL"])
    tinsert(ClamStacker:OrientationChoices, L["ORIENTATION_HORIZONTAL"])
end

function ClamStacker:BAG_UPDATE()
    self:Debug("BAG_UPDATE called")

    -- See if we have any clams.
    local itemlist = {}
    local haveClams = false
    for bag = 0, 4, 1 do
        for slot = 1, GetContainerNumSlots(bag), 1 do
            local itemLink = GetContainerItemLink(bag, slot)
            if itemLink then
                local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bag, slot)
                local itemName, _, itemRarity = GetItemInfo(itemLink)
                local itemString = select(3, string.find(itemLink, "^|c%x+|H(.+)|h%[.+%]"))
                local itemId = select(2, strsplit(":", itemString))
                if clamItemIds[itemId] then
                    self:Debug(itemId.." is a clam")
                    if not itemlist[itemId] then
                        self:Debug("adding entry for "..itemId)
                        itemlist[itemId] = {
                            name = itemName,
                            texture = texture,
                            itemLink = itemLink
                            bag = bag,
                            slot = slot,
                            itemCount = 0,
                        }
                    end
                    itemlist[itemId].itemCount += itemCount
                    self:Debug(itemlist[itemId].." items in the stack")
                    haveClams = true
                end
            end
        end
        if not haveClams then return end

        -- Okay ... so we have some clams. Populate our window with them
        -- and show it
        local popupFrame = self:CreatePopupFrame(itemlist)
        popupFrame:Show()
    end
end

function ClamStacker:CreatePopupFrame(itemlist)
    local buttonSize = 64
    local f = CreateFrame("Frame", "ClamStackerPopupFrame", UIParent)
    f:SetFrameStrata("PARENT")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)

    frame:SetBackdrop{
      bgFile = 'Interface/ChatFrame/ChatFrameBackground',
      edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
      edgeSize = 16,
      tile = true, tileSize = 16,
      insets = {left = 4, right = 4, top = 4, bottom = 4}
    }

    local deltaX, deltaY
    if ClamStacker.orientation == L["ORIENTATION_HORIZONTAL"] then
        f:SetWidth(buttonSize * #itemlist)
        f:SetHeight(buttonSize)
        deltaX = 1
        deltaY = 0
    else
        f:SetWidth(buttonSize)
        f:SetHeight(buttonSize * #itemlist)
        deltaX = 0
        deltaY = 1
    end

end

