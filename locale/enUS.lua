local AL3 = LibStub("AceLocale-3.0")
local L = AL3:NewLocale("ClamStacker", "enUS", true, true)
if (not L) then return; end

L["ORIENTATION_HORIZONTAL"] = "Horizontal"
L["ORIENTATION_VERTICAL"] = "Vertical"
L["OPTIONS_ENABLE_NAME"] = "Enabled"
L["OPTIONS_ENABLE_DESC"] = "Enabled / disable the ClamStacker"
L["OPTIONS_ORIENTATION_NAME"] = "Orientation"
L["OPTIONS_ORIENTATION_DESC"] = "Orientation of the ClamStacker popup"

L["OPTIONS_LOCKBOXES_NAME"] = "Show lockboxes"
L["OPTIONS_LOCKBOXES_DESC"] = "Display lockboxes in the ClamStacker popup?"

L["OPTIONS_SALVAGE_NAME"] = "Show salvage"
L["OPTIONS_SALVAGE_DESC"] = "Display salvage containers in the ClamStacker popup?"
