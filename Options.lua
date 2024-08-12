local _, addon = ...
local L = addon.L

local Options = addon:NewObject("Options")
local MoneyDB = addon:GetStorage("Money")
local GuildDB = addon:GetStorage("Guild")
local FriendsDB = addon:GetStorage("Friends")
local ReputationDB = addon:GetStorage("Reputation")
local CurrencyDB = addon:GetStorage("Currency")

local function CreateReputationOptions()
    local args = {}
    local prevTable

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

    local parentName
    for i = 1, C_Reputation.GetNumFactions() do
        local factionData = C_Reputation.GetFactionDataByIndex(i)
        local name, isHeader, hasRep, isChild, factionID = factionData.name, factionData.isHeader, factionData.isHeaderWithRep, factionData.isChild, factionData.factionID
        if isHeader and not hasRep and not isChild then
            parentName = name
        end
        if isHeader then
            if isChild and parentName then
                name = parentName .. " - " .. name
            end
            prevTable = {
                name = name,
                type = "group",
                inline = true,
                args = {}
            }
            table.insert(args, prevTable)
        else
            table.insert(prevTable.args, {
                name = name,
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

    for i, parent in ipairs(args) do
        if parent.args and #parent.args == 0 then 
            table.remove(args, i) 
        end
    end

    return args
end

local function BuildOptions()
    addon.AceOptions:RegisterOptions({
        name = "WowInfo",
        type = "group",
        args = {
            {
                type = "description",
                name = function()
                    return GetAddOnMetadata("WowInfo", "Notes")
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

    addon.AceOptions:RegisterOptions({
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
                        return false;
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

    addon.AceOptions:RegisterOptions({
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

    addon.AceOptions:RegisterOptions({
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

    addon.AceOptions:RegisterOptions({
        name = L["Reputation"],
        type = "group",
        args = CreateReputationOptions()
    })

    addon.AceOptions:RegisterOptions({
        type = "group",
        name = L["Currency"],
        inline = true,
        handler = CurrencyDB,
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

    BuildOptions = function() end
end

function Options:OnInitialize()
    BuildOptions()
end
