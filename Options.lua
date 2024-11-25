local _, addon = ...
local Options = addon:NewObject("Options")

local L = addon.L

function Options:OnInitializing()
    local category = Settings.RegisterVerticalLayoutCategory(WowInfo:GetName())

    addon.OptionsID = category:GetID()

    do
        local Storage = WowInfo:GetStorage("CurrencyTracker")
        local subCategory, layout = Settings.RegisterVerticalLayoutSubcategory(category, L["Currency Tracker"])

        local addSearchTags = false;
        local initializer = CreateSettingsButtonInitializer(
            "", 
            L["Reset Currency Data"], 
            Storage.Reset, 
            nil, 
            addSearchTags)

		layout:AddInitializer(initializer)

        --local initializer = CreateSettingsListSectionHeaderInitializer("Description ...")
        --layout:AddInitializer(initializer)
    end

    do
        local Storage = WowInfo:GetStorage("Guild")
        local subCategory, layout = Settings.RegisterVerticalLayoutSubcategory(category, L["Guild Friends"])

        do
            local setting = Settings.RegisterProxySetting(
                subCategory, 
                "WOWINFO_MAX_ONLINE_FRIENDS",
                Settings.VarType.Number, 
                L["Maximum Friends Online"],
                Storage:GetDefault("maxOnlineFriends"), 
                Storage.GetMaxOnlineFriends, 
                Storage.SetMaxOnlineFriends)

            local minValue, maxValue, step = 0, 50, 1
            
            local options = Settings.CreateSliderOptions(minValue, maxValue, step)
            options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
        
            Settings.CreateSlider(subCategory, setting, options)
        end

        

        
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
