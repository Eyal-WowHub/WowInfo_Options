local _, addon = ...
local Options = addon:NewObject("Options")

local L = addon.L

function Options:OnInitializing()
    local category = Settings.RegisterVerticalLayoutCategory(WowInfo:GetName())

    addon.OptionsID = category:GetID()

    do
        local storage = WowInfo:GetStorage("CurrencyTracker")
        local frame = CreateFrame("Frame")
        local subCategory, layout = Settings.RegisterCanvasLayoutSubcategory(category, frame, L["Currency Tracker"])
    end

    Settings.RegisterAddOnCategory(category)
end

WowInfo:RegisterEvent("WOWINFO_OPTIONS_OPENED", function()
    Settings.OpenToCategory(addon.OptionsID)
end)


