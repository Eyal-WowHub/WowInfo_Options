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
                        options = {
                            min = 0,
                            max = 50,
                            steps = 1,
                            label = MinimalSliderWithSteppersMixin.Label.Right
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