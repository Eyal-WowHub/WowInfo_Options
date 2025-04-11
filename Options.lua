local _, addon = ...
local Options = addon:NewObject("Options")

local Config = LibStub("AddonConfig-1.0")

local L = addon.L

function Options:OnInitializing()
    local settings = {
        {
            name = WowInfo:GetName()
        },
        {
            name = L["Currency Tracker"],
            handler = WowInfo:GetStorage("CurrencyTracker"),
            layout = {
                {
                    name = L["Reset Currency Data"],
                    type = "button",
                    click = function(self) self:Reset() end
                }
            }
        },
        {
            name = L["Guild Friends"],
            handler = WowInfo:GetStorage("GuildFriends"),
            layout = {
                {
                    name = L["Maximum Friends Online"],
                    type = "slider",
                    default = 20,
                    get = function(self) return self:GetMaxOnlineFriends() end,
                    set = function(self, value) self:SetMaxOnlineFriends(value) end,
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
            handler = WowInfo:GetStorage("Money"),
            layout = {
                {
                    name = L["Hide Connected Realms Names"],
                    type = "checkbox",
                    default = true,
                    get = function(self) return self:IsConnectedRealmsNamesHidden() end,
                    set = function(self) self:ToggleConnectedRealmsNames() end
                },
                {
                    name = L["Show All Characters"],
                    type = "checkbox",
                    default = false,
                    get = function(self) return self:CanShowAllCharacters() end,
                    set = function(self) self:ToggleShowAllCharacters() end
                },
                {
                    name = L["Min Amount of Gold Required"],
                    type = "editbox",
                    get = function(self) return self:GetMinMoneyAmount() end,
                    set = function(self, value) self:SetMinMoneyAmount(value) end,
                    validate = function(value)
                        if value ~= nil and value ~= "" and (not tonumber(value) or tonumber(value) >= 2^31) then
                            return false
                        end
                        return true
                    end,
                    disabled = function(self) return self:CanShowAllCharacters() end
                },
                {
                    name = L["Reset Money Information"],
                    type = "button",
                    click = function(self) self:Reset() end
                }
            }
        },
        {
            name = L["Reputation"],
            handler = WowInfo:GetStorage("Reputation"),
            layout = function(tbl)
                local Reputation = WowInfo:GetObject("Reputation")

                table.insert(tbl, {
                    name = L["Always Show Paragon Rewards"],
                    type = "checkbox",
                    default = true,
                    get = function(self) return self:GetAlwaysShowParagon() end,
                    set = function(self) self:ToggleAlwaysShowParagon() end
                })

                table.insert(tbl, {
                    name = L["Factions"],
                    type = "header",
                })

                for i = 1, Reputation:GetNumFactions() do
                    local faction = Reputation:GetFactionInfoByIndex(i)

                    if faction then
                        local factionName = faction.name
                        local factionID = faction.ID
                        
                        if not faction.isHeader or isHeaderWithRep then
                            table.insert(tbl, {
                                name = factionName,
                                type = "checkbox",
                                default = false,
                                get = function(self) return self:IsSelectedFaction(factionID) end,
                                set = function(self) self:ToggleFaction(factionID) end
                            })
                        end
                    end
                end
            end,
        },
        {
            name = L["Social"],
            handler = WowInfo:GetStorage("Friends"),
            layout = {
                {
                    name = L["Maximum Battle.Net Friends Online"],
                    type = "slider",
                    default = 10,
                    get = function(self) return self:GetMaxOnlineFriends("BN") end,
                    set = function(self, value) self:SetMaxOnlineFriends("BN", value) end,
                    options = {
                        min = 0,
                        max = 20,
                        steps = 1,
                        label = MinimalSliderWithSteppersMixin.Label.Right
                    }
                },
                {
                    name = L["Maximum WoW Friends Online"],
                    type = "slider",
                    default = 10,
                    get = function(self) return self:GetMaxOnlineFriends("WOW") end,
                    set = function(self, value) self:SetMaxOnlineFriends("WOW", value) end,
                    options = {
                        min = 0,
                        max = 20,
                        steps = 1,
                        label = MinimalSliderWithSteppersMixin.Label.Right
                    }
                }
            }
        },
        {
            name = L["Tooltips"],
            handler = WowInfo:GetStorage("TooltipManager"),
            layout = function(tbl)
                table.insert(tbl, {
                    name = L["Enabled Tooltips"],
                    type = "header",
                })

                local TooltipManager = WowInfo:GetStorage("TooltipManager")

                for name in TooltipManager:IterableEnabledTooltips() do
                    local uiName = name:match("^(.-)%.Tooltip$")
                    table.insert(tbl, {
                        name = uiName,
                        type = "checkbox",
                        default = false,
                        get = function(self) return self:IsEnabled(name) end,
                        set = function(self) self:ToggleTooltip(name) end
                    })
                end
            end
        },
        --[[{
            name = L["Profiles"],
            layout = {}
        }]]
    }

    addon.OptionsID = Config:Generate(settings, "vertical-layout")
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
