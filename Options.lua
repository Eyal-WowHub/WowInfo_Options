local _, addon = ...
local Options = addon:NewObject("Options")

local Config = LibStub("AddonConfig-1.0")

local L = addon.L

function Options:OnInitializing()
    local currencyTracker = WowInfo:GetStorage("CurrencyTracker")
    local guildFriends = WowInfo:GetStorage("GuildFriends")

    local settings = {
        name = WowInfo:GetName(),
        type = "vertical-layout",
        props = {
            {
                name = L["Currency Tracker"],
                type = "vertical-layout",
                props = {
                    {
                        name = L["Reset Currency Data"],
                        type = "button",
                        click = currencyTracker.Reset
                    }
                }
            },
            {
                name = L["Guild Friends"],
                type = "vertical-layout",
                props = {
                    {
                        name = L["Maximum Friends Online"],
                        type = "slider",
                        default = 20,
                        get = guildFriends.GetMaxOnlineFriends,
                        set = guildFriends.SetMaxOnlineFriends,
                        label = {MinimalSliderWithSteppersMixin.Label.Right},
                        options = {
                            min = 0,
                            max = 50,
                            steps = 1
                        }
                    }
                }
            },
            {
                name = L["Money"],
                type = "vertical-layout",
                props = {}
            },
            {
                name = L["Reputation"],
                type = "vertical-layout",
                props = {}
            },
            {
                name = L["Social"],
                type = "vertical-layout",
                props = {}
            },
            {
                name = L["Tooltips"],
                type = "vertical-layout",
                props = {}
            },
            {
                name = L["Profiles"],
                type = "vertical-layout",
                props = {}
            }
        }
    }

    addon.OptionsID = Config:Generate(settings)

    --[[local category = Settings.RegisterVerticalLayoutCategory(WowInfo:GetName())

    addon.OptionsID = category:GetID()

    do
        local storage = WowInfo:GetStorage("CurrencyTracker")
        local subCategory, layout = Settings.RegisterVerticalLayoutSubcategory(category, L["Currency Tracker"])

        local addSearchTags = false;
        local initializer = CreateSettingsButtonInitializer(
            "",
            L["Reset Currency Data"],
            storage.Reset,
            nil,
            addSearchTags)

		layout:AddInitializer(initializer)

        --local initializer = CreateSettingsListSectionHeaderInitializer("Description ...")
        --layout:AddInitializer(initializer)
    end

    do
        local storage = WowInfo:GetStorage("Guild")
        local subCategory, layout = Settings.RegisterVerticalLayoutSubcategory(category, L["Guild Friends"])

        do
            local setting = Settings.RegisterProxySetting(
                subCategory,
                "WOWINFO_MAX_ONLINE_FRIENDS",
                Settings.VarType.Number,
                L["Maximum Friends Online"],
                storage:GetDefault("maxOnlineFriends"),
                storage.GetMaxOnlineFriends,
                storage.SetMaxOnlineFriends)

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
    do
        local frame = CreateFrame("Frame")

        local subCategory, layout = Settings.RegisterCanvasLayoutSubcategory(category, frame, "Tooltips")
    end

    -- TODO: Add the ability to manage profiles.
    do
        local frame = CreateFrame("Frame")

        local subCategory, layout = Settings.RegisterCanvasLayoutSubcategory(category, frame, "Profiles")
    end

    Settings.RegisterAddOnCategory(category)]]
end

do
    local OPTIONS_FAILURE_MESSAGE = "Failed to open '%s'."

    WowInfo:RegisterEvent("WOWINFO_OPTIONS_OPENED", function()
        if addon.OptionsID then
            Settings.OpenToCategory(addon.OptionsID)
        else
            WowInfo:Warn(OPTIONS_FAILURE_MESSAGE:format(addon:GetName()))
        end
    end)
end


