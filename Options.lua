local _, addon = ...
local Options = addon:NewObject("Options")

local AceOptions = LibStub("AceOptions-1.0")

local L = addon.L

local function CreateReputationOptions()
    local Reputation = WowInfo:GetObject("Reputation")
    local ReputationDB = Reputation.storage

    local args = {}
    local headerTable, headerChildTable

    table.insert(args, {
        type = "description",
        name = L["Display the reputation status for the tracked factions in the tooltip of the Character Info button."],
    })

    table.insert(args, {
        type = "separator"
    })

    table.insert(args, {
        type = "toggle",
        name = L["Always Show Paragon Rewards"],
        descStyle = "hidden",
        width = "full",
        handler = ReputationDB,
        get = function(self)
            return self.handler:GetAlwaysShowParagon()
        end,
        set = function(self)
            self.handler:ToggleAlwaysShowParagon()
        end
    })

    for i = 1, Reputation:GetNumFactions() do
        local faction = Reputation:GetFactionInfoByIndex(i)
        if faction then
            local factionName = faction.name
            local factionID = faction.ID
            if faction.isHeader then
                if faction.isChild then
                    headerChildTable = {
                        name = factionName,
                        type = "group",
                        inline = true,
                        args = {}
                    }
                    table.insert(headerTable.args, headerChildTable)
                    if faction.isHeaderWithRep then
                        table.insert(headerChildTable.args, {
                            name = factionName,
                            type = "toggle",
                            descStyle = "hidden",
                            width = "full",
                            handler = ReputationDB,
                            get = function(self)
                                return self.handler:IsSelectedFaction(factionID)
                            end,
                            set = function(self)
                                self.handler:ToggleFaction(factionID)
                            end
                        })
                    end
                else
                    headerChildTable = nil
                    headerTable = {
                        name = factionName,
                        type = "group",
                        inline = false,
                        args = {}
                    }
                    table.insert(args, headerTable)
                end
            else
                local header = headerChildTable or headerTable
                table.insert(header.args, {
                    name = factionName,
                    type = "toggle",
                    descStyle = "hidden",
                    width = "full",
                    handler = ReputationDB,
                    get = function(self)
                        return self.handler:IsSelectedFaction(factionID)
                    end,
                    set = function(self)
                        self.handler:ToggleFaction(factionID)
                    end
                })
            end
        end
    end

    return args
end

function Options:OnInitializing()
    AceOptions:RegisterOptions({
        name = "WowInfo",
        type = "group",
        args = {
            {
                type = "description",
                name = function()
                    return C_AddOns.GetAddOnMetadata("WowInfo", "Notes")
                end,
                cmdHidden = true,
            },
            {
                type = "separator"
            },
            {
                type = "description",
                name = "",
            },
        },
    })

    do
        local MoneyDB = WowInfo:GetStorage("Money")

        AceOptions:RegisterOptions({
            type = "group",
            name = L["Money"],
            inline = true,
            handler = MoneyDB,
            args = {
                {
                    type = "description",
                    name = L["Display the total money information for all characters in the tooltip of the Backpack."],
                },
                {
                    type = "separator"
                },
                {
                    type = "toggle",
                    name = L["Hide Connected Realms Names"],
                    descStyle = "hidden",
                    width = "full",
                    get = function(self)
                        return MoneyDB:IsConnectedRealmsNamesHidden()
                    end,
                    set = function(self)
                        MoneyDB:ToggleConnectedRealmsNames()
                    end
                },
                {
                    type = "toggle",
                    name = L["Show All Characters"],
                    descStyle = "hidden",
                    width = "full",
                    get = function(self)
                        return MoneyDB:CanShowAllCharacters()
                    end,
                    set = function(self)
                        MoneyDB:ToggleShowAllCharacters()
                    end
                },
                {
                    type = "description",
                    name = L["Show only characters that has more than specified amount of money:"],
                },
                {
                    type = "input",
                    name = "",
                    get = function(self)
                        return tostring(MoneyDB:GetMinMoneyAmount())
                    end,
                    set = function(self, value)
                        MoneyDB:SetMinMoneyAmount(value)
                    end,
                    validate = function(info, value)
                        if value ~= nil and value ~= "" and (not tonumber(value) or tonumber(value) >= 2^31) then
                            return false
                        end
                        return true
                    end,
                    disabled = function(self)
                        return MoneyDB:CanShowAllCharacters()
                    end
                },
                {
                    type = "newline"
                },
                {
                    type = "execute",
                    name = L["Reset Money Information"],
                    descStyle = "hidden",
                    width = "double",
                    func = function(self)
                        MoneyDB:Reset()
                    end
                }
            }
        })
    end

    do
        local GuildDB = WowInfo:GetStorage("Guild")

        AceOptions:RegisterOptions({
            type = "group",
            name = L["Guild & Communities"],
            inline = true,
            handler = GuildDB,
            args = {
                {
                    type = "description",
                    name = L["Display the status of your guild friends in the tooltip of the Guild & Communities button."]
                },
                {
                    type = "separator"
                },
                {
                    type = "range",
                    name = L["Maximum Friends Online"],
                    descStyle = "hidden",
                    width = "double",
                    step = 1,
                    min = 0,
                    max = 50,
                    get = function(self)
                        return self.handler:GetMaxOnlineFriends()
                    end,
                    set = function(self, value)
                        self.handler:SetMaxOnlineFriends(value)
                    end
                },
            }
        })
    end

    do
        local FriendsDB = WowInfo:GetStorage("Friends")

        AceOptions:RegisterOptions({
            type = "group",
            name = L["Social"],
            inline = true,
            handler = FriendsDB,
            args = {
                {
                    type = "description",
                    name = L["Display the status of your friends in the tooltip of the Social button."]
                },
                {
                    type = "separator"
                },
                {
                    type = "range",
                    name = L["Maximum Friends Online"],
                    width = "double",
                    descStyle = "hidden",
                    step = 1,
                    min = 0,
                    max = 50,
                    get = function(self)
                        return self.handler:GetMaxOnlineFriends()
                    end,
                    set = function(self, value)
                        self.handler:SetMaxOnlineFriends(value)
                    end
                },
            }
        })
    end
    
    AceOptions:RegisterOptions({
        name = L["Reputation"],
        type = "group",
        args = CreateReputationOptions()
    })

    do
        local CurrencyDB = WowInfo:GetStorage("Currency")

        AceOptions:RegisterOptions({
            type = "group",
            name = L["Currency"],
            inline = true,
            args = {
                {
                    type = "description",
                    name = L["Display the currency amount per character in the tooltip of the Currency Tab."]
                },
                {
                    type = "separator"
                },
                {
                    type = "execute",
                    name = L["Reset Currency Data"],
                    descStyle = "hidden",
                    width = "double",
                    func = function(self)
                        CurrencyDB:Reset()
                    end
                }
            }
        })
    end
end

WowInfo:RegisterEvent("WOWINFO_OPTIONS_OPENED", function()
    AceOptions:Open()
end)


