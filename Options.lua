local _, addon = ...
local Options = addon:NewObject("Options")

local L = addon.L

function Options:OnInitializing()
    local category = Settings.RegisterVerticalLayoutCategory(self:GetName())

    addon.OptionsID = category:GetID()

    do
        local frame = CreateFrame("Frame")
        local subCategory, layout = Settings.RegisterCanvasLayoutSubcategory(category, frame, L["Currency"])
    end

    do
        local frame = CreateFrame("Frame")
        local subCategory, layout = Settings.RegisterCanvasLayoutSubcategory(category, frame, L["Guild & Communities"])
    end

    do
        local frame = CreateFrame("Frame")
        local subCategory, layout = Settings.RegisterCanvasLayoutSubcategory(category, frame, L["Money"])
    end

    do
        local frame = CreateFrame("Frame")
        local subCategory, layout = Settings.RegisterCanvasLayoutSubcategory(category, frame, L["Reputation"])
    end


    do
        local frame = CreateFrame("Frame")
        local subCategory, layout = Settings.RegisterCanvasLayoutSubcategory(category, frame, L["Social"])
    end

    -- TODO: Allow to sort and disable tooltips.
    --[[do
        local frame = CreateFrame("Frame")

        local subCategory, layout = Settings.RegisterCanvasLayoutSubcategory(category, frame, "Tooltips")
    end

    -- TODO: Add the ability to manage profiles.
    do
        local frame = CreateFrame("Frame")

        local subCategory, layout = Settings.RegisterCanvasLayoutSubcategory(category, frame, "Profiles")
    end]]

    Settings.RegisterAddOnCategory(category)
end

WowInfo:RegisterEvent("WOWINFO_OPTIONS_OPENED", function()
    Settings.OpenToCategory(addon.OptionsID)
end)
